Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DDDF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9CD6B00BB; Mon,  6 Apr 2026 10:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1A96B00BD; Mon,  6 Apr 2026 10:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8066B00BE; Mon,  6 Apr 2026 10:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD496B00BB
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:19:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 355931B7FCC
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:45 +0000 (UTC)
X-FDA: 84628339530.29.F62BCC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 70F7240017
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WkkzDwRF;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485183; a=rsa-sha256;
	cv=none;
	b=Vy3ahNiVDWTRbxQ0tNH+zwhZTkKwSxHY4cnwz/jxgBXSCPNLSMCyrMp6tf+3ne9CcMBhOU
	IR/GeZ47cjuFxx2cf4zwAPvV2svwOG6SXSsmJHtssKOiIgmgAOtbq1MlVersjw2O4xlMAX
	g1encvv0PQi9J1BMr6s6uxCpp8EQdpI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YI+O0bsFFUx7JE1qaiXB/WsW8cWb9KXXQfI47c5bDNU=;
	b=EPeY7Tjp5M32sLVPmRjM+dMzhA9BE27ZwIu19mMK3f3H0rKa2r5g3jp+qIQwY9s8INlnr4
	am7qonJn+WVS2c4g81m+IT5s/gyLESGDbhE2dp0nd8TEt/83XZNs/DG+Y6N+hiuYJFhs63
	8fLAHI18gKjUYgkkt7/ecMGCBxe9GYk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WkkzDwRF;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 868B3437DB;
	Mon,  6 Apr 2026 14:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09315C4CEF7;
	Mon,  6 Apr 2026 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485182;
	bh=CSRWIbnqZ2+IUD8e7KEy7LOUD0pEzBaiEkzcv/mT4lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkkzDwRFh22fX0emoHfuxUNPut6dxYmqhLmgjOy4hBGeBJLq8J2htWFvJlocgrmpd
	 71lH2/zYqfL4U+/u4tJ4vi/n1leSLbw4uNd32Dn8kfmxFU1tjGDWaKzB/6R/OBzM2E
	 Dap6EDkqFQzKCf4paMgOcse5gtbtjmbUEYt/I3APkwuTdNX+Rvs26R20pA7u456bzW
	 TGdk4F9BOLisA6ZJEHelNZtP55sWJ7JHlcaWyzQDVV783ziK89JHIWuf/7FHJw2kQ9
	 2yX31+BbsSP1dcD9aJClS+aR+yxs9UNT4thnfq7nnYNiGBdrujppI6l1z5ttljvcd0
	 ZSGAXoKOl/t6w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 20/53] selftests/mm: add atexit() and signal handlers to thp_settings
Date: Mon,  6 Apr 2026 17:17:02 +0300
Message-ID: <20260406141735.2179309-21-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70F7240017
X-Stat-Signature: 3ku8r51wozn945zpjquxsg8hqutmjh37
X-HE-Tag: 1775485183-386977
X-HE-Meta: U2FsdGVkX1/EewnyK2BEEaKY2fjWtozsIlzVpGsH5p8keqPhF9QcI0gea3hvWy+8oUfdgY+qeKtKRgo+BJSremq/bAcKhMiDWr5sjCheQnBQ7pJq+o2EfKRUptGAxCgWJaOhNHKCy72jG7/uNu73ehYNyJaTsyiCzCMQrfoShz9ib2mLo+ZbA34jHLRFjt8OtZVh8+d6ljTn8XspcFmFKEfl5qf97cKau/JsRvKHMOhujuoipsv3absVMMASdjSuLS9aQ4OfEW/Rt697TXXEUfk5pmAGHWmFAbHtK68lOnay+3Cw6O/08KfG13Tdhk/bYZshKRQvG5zwQ3mtVQCiv0PwV1iCoWZo8EGO0ghVAXcfKMfxMQYxS0AkmIxruwRSXeXqTPBzJnu4qO65xptQTe9PfCcZE+0y6agNLDV+u/saO6huQGUTvvnuPcRdrWSGxDbiu6xoYVJAIsCmbqM+IdkEvnuuRqAjLswydfugLPrErTZAkJRCJnHAC4RmOqQZP4RHxDqGfDGLKS6xDIsZOtLof1cBzUnhfIPbabwk3keU0hIk7/LzpujdbSB3Cfhv6XuBWiHecqjbIfHW6S50+tVUZEol3J5hbAjL5WYKdVJi/sGKvJPqgOd9At6uACkuK4Nr2g8jY/JHVf2rmcZr69kWV9pOvBKG4DwO2mbrNUSlGduVp5bRBFDgRq6ww9BHuY5GBXpNMSEbu724xP6y5C2lLvVY2l1BBUqKGD9huvSVq4t6H40pGw2ox0FNPUBoYqkQC+sl8mVL06IACymGbEhRYGSFGoWSMoABiH+pU/efcS0oQ7BAHWm9jXXetsHsFcCEqTpp9gverQ8UiR++kNl3dmJJGxVI2Ftoc24NfuTHP+ZGYFaEs68OGB30yKyWHSaAVfMxXZolU7qsTxEOWYcKdzgJucZAf2e7ZTG2s8p0HgYbpAg94xiJ2RPgl1ITGoF2zvJg9arWpluZcpE
 /2jKfdw+
 MNlVkXlTyRCpmdN3X/bQRjAsBijJA14IvKXd/9tSVwzElWmE8xAQXRZJ+Gpayxy+rGp2OXHzakCzfX/Rh1PqY0tSIKJs+P07+KWQgEg+L5cUI1wyZetj0T5BLrks9zhmC5f4alHEZWROEMKAowQ77VxTFthvKkS2Sgc8AKMLCZFGtRsIV6C3fIxfoGHT4Ann8Tnqi28Fc9hvn7gnnbDEDchjlMFsHxRfNI2dCRF6gcEcJYk/+9sW7ySUcYuJ8y+ZXcpbUYfh6R9Pmro69CthB3J882ZM/ky7yeTiC
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
index ba0a9e14e600..fac11b7e7443 100644
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


