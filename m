Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E31FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40636B00BC; Tue, 28 Apr 2026 16:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA2D6B00BE; Tue, 28 Apr 2026 16:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0576B00BF; Tue, 28 Apr 2026 16:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA9A6B00BC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:45:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C762C0AE2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:12 +0000 (UTC)
X-FDA: 84709144464.02.CA5829E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D8C41C0013
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nitaGYyg;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1RGvY0kHAmoYq099jdMzseF+ot3kjEXyNpqiT3gqPM=;
	b=uPJWDbxmN+jcjjeak4C+N6khwgeqRe5mAyT0SmkUGgMTGB+HndzpNaSG3ZwueqpaV8wuYF
	7ernmrlISIgUnnQohknKJYJH2emzYlCWf14iirPN4dgQ8deSBLi4jeWlSALJVnuZQTVML7
	qhx+ZuqBQinLPxXVgyawaBePuQmeVdw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nitaGYyg;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409110; a=rsa-sha256;
	cv=none;
	b=zOw1aEWS0tNyMI4MG/INME2QbA0hNWGjzAMsYgcT5xbR2yKl1elJOCuhGjzQm0DBvW67Xw
	uVMKMhuU+YX/QeDIiP4KW8kIfH+ORxsxL/Wvzy/HC6R0D8HbK3hkq6Kj10i0p+SGgmkItZ
	sDJbLYtb8Yd2rr0tutSrq0Hgm3+SzqY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1097E61119;
	Tue, 28 Apr 2026 20:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABACFC2BCAF;
	Tue, 28 Apr 2026 20:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409109;
	bh=gVU+NxBS58ndkAl4KdeNWT7uSAZiwRivKfRFLz7HiUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nitaGYyggSlLWsIVkpEsoRkkTis2eaPVf9ZfYRijDkozg64rpFStEVydukPk21Zlu
	 Qw34ZYsAvetVYaLuB9sLrAep8WNmRplx0USdAHSy6ymmd9nN9VyELgmveo+EtFZNvR
	 xxMsaFAxLZ6JluCihJ6hM7KuxjpNDlPwBHXEYRrpvUBendqWrfRNrAK/jSM0mOgcLw
	 RTfrwIK82UjcD7FTHqtBLDyLGCW39/TpsZIBDYbcjDveRYfUAZEAGs9icb6Cejsse1
	 GYUaR7AkWyzYO/UItvFjauGu4tLeKMIAH2Aq/Fen7KAsouItEEiFDL5CjS6fysgf1z
	 NG8icHfoXfmOA==
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
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v3 21/54] selftests/mm: add atexit() and signal handlers to thp_settings
Date: Tue, 28 Apr 2026 23:42:07 +0300
Message-ID: <20260428204240.1924129-22-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D8C41C0013
X-Stat-Signature: hjtemdi1sxtgtsg1m11hh7csaapzjczc
X-HE-Tag: 1777409110-769927
X-HE-Meta: U2FsdGVkX18ahWxLDUrZYSSk0jugMBqmt2/lM+gEQXRz1U6WX6gqTAmOrSpiTtHG+7OMnu5t/4ARj7jOsD4XXQM+7x+Y3ZoZIhi6e8p2XkzGUdFdZNV6rm5DDg+rArKQ5G6zfT0HpvjNe1PjS50HdlDfgInNsgCkgKCSGsyE8fUk7zxHB68s3wn37KyQzd39wH4WvQd7XdIW1w6PVFFerx28gHYnfiVTEsmsBKzyXUUqudi79wQXbP280IEWiOJqJHUwsz9tHI4w+hBmMiVJ2yRb7VH4pCzx+jo8Ou5SScSLQnYuyBN4GEXJPwN+ROFspFpCEG3wH/2sOOOwRuNKEh0QhWNCxkHtFerYhCN6g5qHQFEp3TqwB80jBdlth5ZuZ3HnTFbN/jFInquu2Ok2chi/c7SFWD3gs+uCoItQHOW843STkZif2iXQc0zzJmv9zoNDmWyxexn5GGCZFQB8gjcNOQkkk6+CRMHaJRwY0Bh15wU4bqxSUTtY8YbO+f8aHhMefI8WBWcQCri1ckulOqqOlWrbmjfdqX130BgaS5XzuaDKCQ44mHNDAo/7K4lEeZSrbXvISszkDH6pZflb30PCbP5jxZnlj4VejnetRy7kuBMFzjvyM/pHEu53iOM7PgMsVcNdv36gtxk7kVL1QEt5tWgpdv/7XSGJrx1RfoR50FJlfJfB80oggl+uL4Kaf2Y4MgOgEVDH0nZHbpUUqxA3wtxKCCrG2Ap0qoNgwq18S1Ru3SU+71OHELROdtshacoWxO0bjGqpAlFpwZ3l+XfcxblHdxfbhpKlamXBNd0PRCRre4YOraIMnqvbjJvvhVMFazj91T7jpjDAI/4R9Ncm2o/rzlgegCEJRKv5n265lkwJfZG5GVjGzeS+pQ+qE2BNqvAIkmvdFeYwdWY/s7OIs4mAgzjEcWUlkrVw0eId0oeJdKz89x0Z/ZHreku3A0SQCftgXIznaq9KlNC
 GXCRmf65
 Q03nJ94OG59PVzyUFXnCRFNv70xxMO4Xwn4FMVzxeaONtf8o9kiAtC23nPauxKm7AIkUcGB5LWVgF2G5mOawWtkD8uUFZ9xEQt/yHqA1vEJAUwObhws31dv5HG0Qucyml9PuFkiielL2KwDyrApguRvvwTPFvwEQmof09O4kBoTdYVy2ZWKA8WbeJCUHw8JEbPcveCcMQkRvgeSo69cspOggNziYKDrmI5jFS7tIv5wfwtl/OUaGOtYCPqMKFNCIBCU1AjEnxdtQ7EOaRyYWhu4tlQRf9gxDTZvOi
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
index 2f0baa2321ca..ef3b6464ff3f 100644
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
@@ -844,8 +818,6 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	ksft_print_msg("Share small page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 0))
 			success("OK");
 		else
@@ -857,7 +829,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 		validate_memory(p, 0, page_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -882,8 +854,6 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
@@ -906,7 +876,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 
 		validate_memory(p, 0, hpage_pmd_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -932,8 +902,6 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
@@ -966,7 +934,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 
 		validate_memory(p, 0, hpage_pmd_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -1260,5 +1228,5 @@ int main(int argc, char **argv)
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


