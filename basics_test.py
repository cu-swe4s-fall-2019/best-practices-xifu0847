import unittest
import numpy as np
import get_column_stats


class TestGetColStats(unittest.TestCase):

    # data preparation
    def setUp(self):
        self.testcase1 = []
        self.testcase2 = [1, 2, 3]
        self.testcase3 = [1, 2, 3, 4, 5, 6]
        self.testcase4 = np.random.rand(100)

    # test if the list is empty
    def test_empty_list(self):
        self.assertRaises(ZeroDivisionError,
                          get_column_stats.calculate_mean, self.testcase1)
        self.assertRaises(ZeroDivisionError,
                          get_column_stats.calculate_stdev, self.testcase1)

    # test testcase2 in setUp function
    def test_testcase2(self):
        self.assertEqual(
            get_column_stats.calculate_mean(self.testcase2), 2)
        self.assertAlmostEqual(
            get_column_stats.calculate_stdev(self.testcase2), 0.816496581, 5)

    # test testcase3 in setUp function
    def test_testcase3(self):
        self.assertEqual(
            get_column_stats.calculate_mean(self.testcase3), 3.5)
        self.assertAlmostEqual(
            get_column_stats.calculate_stdev(self.testcase3), 1.707825128, 5)

    # test 100 random numbers in the list
    def test_random_list(self):
        self.assertAlmostEqual(
            get_column_stats.calculate_mean(self.testcase4),
            np.mean(self.testcase4), 5)
        self.assertAlmostEqual(
            get_column_stats.calculate_stdev(self.testcase4),
            np.std(self.testcase4), 5)


if __name__ == '__main__':
    unittest.main()
