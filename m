Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22805F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E2A6B0256; Sat, 18 Apr 2026 06:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82ED96B0258; Sat, 18 Apr 2026 06:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6126B0259; Sat, 18 Apr 2026 06:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 599146B0256
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E10A1A049B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:54 +0000 (UTC)
X-FDA: 84671376468.04.D41B932
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 76EE4A000C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPR6Atsz;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUU+1A/y0uYDh5II4BlhS/1syC/EeSqYyYdTxkCLt8w=;
	b=A+0DvZTnibVFopY1nVE75A6EojFssY4BZZDi6ak9KJuwAQvOiwLDuuLVwWv1C0QdH++4c8
	a5gHa8kOIWmxV5ky2JkKbF1YTWI1KPzNTFrpsxQaJxKiePGfAQkEm5OXnY9Rz7rEYPlGUA
	6WLVaSq+BzkvjBOJG5HycIxZNbYfi7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509872; a=rsa-sha256;
	cv=none;
	b=tYRzS2gvi+ytCq4hYM2Pfkol6FskR0fy5tfPEU1RSPokyiz50fVF11GmlQ8Xe66oL/DWHE
	5KoFsaiDW9UkoWJeSj5uwe+Mus12jq7Hojj67iasM76SCRLjxZFjDUcZS5HjYx2CuE01D2
	qsCghm3EWsuCvK66BYTwl1uUd1IbJso=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPR6Atsz;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4406403C3;
	Sat, 18 Apr 2026 10:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE4FC19424;
	Sat, 18 Apr 2026 10:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509871;
	bh=SUEKnFjgA5lp1MZkCJZ9Uvwy9fm6gZpAshi2W0BTLT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPR6AtszcrCAROPz6cVfTYXxEnwyWBwoLHy2I8Fu3LCf5P6yHWUKbkRobJiE+1iuH
	 WDbcMaw9zNQBYgHkvzPFI2aTc2tGWbp2vbi4+2tmF2I92zR3BYDlWTzQHVNf1TRl59
	 QbBtXy1rxld9/auhfGaUIZ5UqPn63kad1PzqipS7Dv3i5tfsLfKKzMQWnnhRT1X10e
	 R1N+7GrWvS4esYzLkTM1rgPwnDMPa/XNuo1fKkGzNyoJgpjXSl07AqnUOGsyweU3uj
	 G/p9ZoXzjgTfM+iU2RT7F4LzFtbtGeoNwnBpVY7hnnMYTeS2uphyf63Wx2FdlhaSBB
	 PScSsReYvyzKA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 20/53] selftests/mm: add atexit() and signal handlers to thp_settings
Date: Sat, 18 Apr 2026 13:55:05 +0300
Message-ID: <20260418105539.1261536-21-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u4amx5catuo4kgh6aaigemgwxbhu8iku
X-Rspam-User: 
X-Rspamd-Queue-Id: 76EE4A000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1776509872-908839
X-HE-Meta: U2FsdGVkX19m+Uo3wcC1cmQBlPi8B42DPTa+2lORn3101rD/k96n4fZJf84rpp1yKD3/Vky3ScEhcC+VLQb94HNCSDoZtVv75xpAdVWH4PRs+czOj3yneydQBMlCXh1mNeHuimT4MozNtN3lfr/AI+m4AnUIvQPmCZoZzcTW3H2yt8GNtN+/yVs5LjbH1MtU04WwpOZw/Exs9xZ8dLwzk6KVWBz/TlRAiZQug9LCHhlJq0rCOM+Ai3bV0FBGzyDh65xXjFgXbpZBDl0N4t4MxBD8YIU4ojZCLYReIbLFy2SzVMW/Xg3t+/jAOKNOd4z26qbksDW+YSA1ka+/qtoVzRXR/X4xgdiVVH3IJOraGs/PtamEQNGw/5ZG5gE73LmoOOu51JHjRX9CsSP5ZZOAtCmiPB4LyWVabYY1RShhTnzNnWRd2vLiYtlpfm8upLP3cEs4MpUV+XfOR5KJFORUY5VzGCUQ20NDuGLQ+SNBkFl5+V6l3gtujJFdHX8xNl06fhUGUnijTSjNwaw4rDI8SjGiqA41XYlvyIdhy6NkGhpxOF0pCjgOkKcOyV3roXiwgs6Eiqo46UQ8JQ6uu+5+7sCEkney2JzImIfIxRhk8j518lfu4ymPWiMaMD6e3w/Nf2hbMJ96tLU3mphXtKziX2SGXkTP00EKoi2Pw6dQXx3DNrJzKSfvNfFCcaBK4gwYdPNJDPlORQLuFC0ayAwVVYxXDkfSVIgIcY8ILgwDmqcd8inf1VssBzo4cl47DaopCg6ReVHhNbhhx8OlSPu4/Fp90kz4OK4dk01+Dw1MMgChK4iV9UsHkX5fNK/qz4VDmJYvBsPuLhFFCT2600m02Xm+ZGNJlIS/tXxgNuvYwFkeeoALlVUwRWY5ECU+Fdk2IcB132WUXXK0PnrYmx5vQC7juBKucTbPMfSlWblkQrM0lW2miF+bkmJQ6pP3MerInclsL5XnMEJ7vetcyVp
 zSjSQaMl
 +PuwSVCV1/240BWYf6F8QjyA7dPXexCu5lbe7MYGY4kNNWGLRti3GfM9eJFTtX8ble2ZsR24igDXK9zYh+tzFYJDupwU9ogUWdEwLufCiPQJTj+1Ef+Te10iivBhJGZr6UiVVBWwPaIqudPBiLpzXeb13H5SUU7Baajhqtag5mJvIr4OPy17Rd1jCpuZRg87exvmQ7KkYG5CFd++CyjUFHYCbpt3e/dtqWRTQKH7BaLD9tLcDO0CIzeYZTmNEmzyACo8FhsO3W2kpuRnqTEDnf6/pq5odobpvqAN+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

khugepaged registers atexit() and signal handlers that ensure that THP
settings are restored regardless of how the test exited.

Make these handlers available for all users of thp_settings.

The call to thp_save_settings() installs thp_restore_settings as the
atexit() callback and makes sure that signals that kill a process would
still call exit() and atexit() callback.

Update child process in tests using thp_settings to use _exit() instead
of exit() to avoid altering THP settings in the middle of a test.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/cow.c            | 21 +++++------
 tools/testing/selftests/mm/khugepaged.c     | 40 +++------------------
 tools/testing/selftests/mm/thp_settings.c   | 28 ++++++++++++++-
 tools/testing/selftests/mm/uffd-wp-mremap.c |  4 ---
 4 files changed, 39 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index d9c69c04b67d..6abdcb30aba8 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -202,7 +202,7 @@ static void do_test_cow_in_parent(char *mem, size_t size, bool do_mprotect,
 		log_test_result(KSFT_FAIL);
 		goto close_comm_pipes;
 	} else if (!ret) {
-		exit(fn(mem, size, &comm_pipes));
+		_exit(fn(mem, size, &comm_pipes));
 	}
 
 	while (read(comm_pipes.child_ready[0], &buf, 1) != 1)
@@ -333,7 +333,7 @@ static void do_test_vmsplice_in_parent(char *mem, size_t size,
 			;
 		/* Modify page content in the child. */
 		memset(mem, 0xff, size);
-		exit(0);
+		_exit(0);
 	}
 
 	if (!before_fork) {
@@ -480,7 +480,7 @@ static void do_test_iouring(char *mem, size_t size, bool use_fork)
 			write(comm_pipes.child_ready[1], "0", 1);
 			while (read(comm_pipes.parent_ready[0], &buf, 1) != 1)
 				;
-			exit(0);
+			_exit(0);
 		}
 
 		while (read(comm_pipes.child_ready[0], &buf, 1) != 1)
@@ -645,7 +645,7 @@ static void do_test_ro_pin(char *mem, size_t size, enum ro_pin_test test,
 			write(comm_pipes.child_ready[1], "0", 1);
 			while (read(comm_pipes.parent_ready[0], &buf, 1) != 1)
 				;
-			exit(0);
+			_exit(0);
 		}
 
 		/* Wait until our child is ready. */
@@ -956,7 +956,7 @@ static void do_run_with_thp(test_fn fn, enum thp_run thp_run, size_t thpsize)
 			log_test_result(KSFT_FAIL);
 			goto munmap;
 		} else if (!ret) {
-			exit(0);
+			_exit(0);
 		}
 		wait(&ret);
 		/* Allow for sharing all pages again. */
@@ -1347,13 +1347,13 @@ static void do_test_anon_thp_collapse(char *mem, size_t size,
 		switch (test) {
 		case ANON_THP_COLLAPSE_UNSHARED:
 		case ANON_THP_COLLAPSE_FULLY_SHARED:
-			exit(child_memcmp_fn(mem, size, &comm_pipes));
+			_exit(child_memcmp_fn(mem, size, &comm_pipes));
 			break;
 		case ANON_THP_COLLAPSE_LOWER_SHARED:
-			exit(child_memcmp_fn(mem, size / 2, &comm_pipes));
+			_exit(child_memcmp_fn(mem, size / 2, &comm_pipes));
 			break;
 		case ANON_THP_COLLAPSE_UPPER_SHARED:
-			exit(child_memcmp_fn(mem + size / 2, size / 2,
+			_exit(child_memcmp_fn(mem + size / 2, size / 2,
 					     &comm_pipes));
 			break;
 		default:
@@ -1911,10 +1911,5 @@ int main(int argc, char **argv)
 	run_anon_thp_test_cases();
 	run_non_anon_test_cases();
 
-	if (pmdsize) {
-		/* Only if THP is supported. */
-		thp_restore_settings();
-	}
-
 	ksft_finished();
 }
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index da365f850365..87442e902b26 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -72,7 +72,6 @@ struct file_info {
 };
 
 static struct file_info finfo;
-static bool skip_settings_restore;
 static int exit_status;
 
 static void success(const char *msg)
@@ -92,25 +91,6 @@ static void skip(const char *msg)
 	exit_status = KSFT_SKIP;
 }
 
-static void restore_settings_atexit(void)
-{
-	if (skip_settings_restore)
-		return;
-
-	ksft_print_msg("Restore THP and khugepaged settings...");
-	thp_restore_settings();
-	success("OK");
-
-	skip_settings_restore = true;
-	ksft_finished();
-}
-
-static void restore_settings(int sig)
-{
-	/* exit() will invoke the restore_settings_atexit handler. */
-	exit(sig ? KSFT_FAIL : exit_status);
-}
-
 static void save_settings(void)
 {
 	ksft_print_msg("Save THP and khugepaged settings...");
@@ -119,12 +99,6 @@ static void save_settings(void)
 	thp_save_settings();
 
 	success("OK");
-
-	atexit(restore_settings_atexit);
-	signal(SIGTERM, restore_settings);
-	signal(SIGINT, restore_settings);
-	signal(SIGHUP, restore_settings);
-	signal(SIGQUIT, restore_settings);
 }
 
 static void get_finfo(const char *dir)
@@ -840,8 +814,6 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	ksft_print_msg("Share small page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 0))
 			success("OK");
 		else
@@ -853,7 +825,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 		validate_memory(p, 0, page_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -878,8 +850,6 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
@@ -902,7 +872,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 
 		validate_memory(p, 0, hpage_pmd_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -928,8 +898,6 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
@@ -962,7 +930,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 
 		validate_memory(p, 0, hpage_pmd_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -1258,5 +1226,5 @@ int main(int argc, char **argv)
 		t->fn(t->ctx, t->ops);
 	}
 
-	restore_settings(0);
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
index e748ebfb3d4e..f38ba8a27b30 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ b/tools/testing/selftests/mm/thp_settings.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <fcntl.h>
 #include <limits.h>
+#include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -15,6 +16,7 @@ static struct thp_settings settings_stack[MAX_SETTINGS_DEPTH];
 static int settings_index;
 static struct thp_settings saved_settings;
 static char dev_queue_read_ahead_path[PATH_MAX];
+static bool thp_settings_saved;
 
 static const char * const thp_enabled_strings[] = {
 	"never",
@@ -298,12 +300,36 @@ void thp_pop_settings(void)
 
 void thp_restore_settings(void)
 {
-	thp_write_settings(&saved_settings);
+	if (thp_settings_saved)
+		thp_write_settings(&saved_settings);
+}
+
+static void thp_restore_settings_atexit(void)
+{
+	thp_restore_settings();
+}
+
+static void thp_restore_settings_sighandler(int sig)
+{
+	/* exit() will invoke the thp_restore_settings_atexit handler. */
+	exit(KSFT_FAIL);
 }
 
 void thp_save_settings(void)
 {
 	thp_read_settings(&saved_settings);
+
+	/*
+	 * setup exit hooks to make sure THP settings are restored on graceful
+	 * and error exits and signals
+	 */
+	atexit(thp_restore_settings_atexit);
+	signal(SIGTERM, thp_restore_settings_sighandler);
+	signal(SIGINT, thp_restore_settings_sighandler);
+	signal(SIGHUP, thp_restore_settings_sighandler);
+	signal(SIGQUIT, thp_restore_settings_sighandler);
+
+	thp_settings_saved = true;
 }
 
 void thp_set_read_ahead_path(char *path)
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 17186d4a4147..516c35d236e1 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -368,10 +368,6 @@ int main(int argc, char **argv)
 				       tc->swapout, tc->hugetlb);
 	}
 
-	/* If THP is supported, restore original THP settings. */
-	if (nr_thpsizes)
-		thp_restore_settings();
-
 	i = ksft_get_fail_cnt();
 	if (i)
 		ksft_exit_fail_msg("%d out of %d tests failed\n",
-- 
2.53.0


