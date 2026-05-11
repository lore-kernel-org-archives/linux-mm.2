Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C3BCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1A26B00FD; Mon, 11 May 2026 12:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078BA6B00FE; Mon, 11 May 2026 12:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7B76B00FF; Mon, 11 May 2026 12:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1F406B00FD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:31:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91A831C04C7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:16 +0000 (UTC)
X-FDA: 84755678952.17.510CDC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD1154000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nfCbssLp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKCgxvExksLPOlR++sZiZSXBayJA2fpLzhfSFtMdT38=;
	b=mb8fM9b5J3iSU7qPztrqmQIOc598CVNn4Wi6TL7wTP4Wp5YTAM6FET+Wf53EmItuQlLgg5
	/eYyJDhK17wOXaTnK9uTlggoSq3CzefAcnukHAo/Elzhz7Ca0oSg6LLvRgIGV9sW8506Ki
	8+xFm8S0VMwqLRk4CgwgmWbXXCjyOv0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517075; a=rsa-sha256;
	cv=none;
	b=BWBpkfKv0RZGC73AZHrNyjG8hKL55+JX/w+zmQ6k1Z3Z+0rnYz706Z0wLQjVT1tST5rsYP
	KuUCXi7hx8DGLpUY7MHxzkkIa2nw1O/ntBHFFlVk7Xxe8meEFygr6nhwHHspy/J0+hHknr
	Jid8fRZz/GKmDVV/H3Yr8UOp7+REM2s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nfCbssLp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11176401BE;
	Mon, 11 May 2026 16:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DADC2BCF5;
	Mon, 11 May 2026 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517073;
	bh=IXob8ni/FXlrR8eQN7nzJDDR/ebDxRCffZ1TE7TJr8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfCbssLptfKaX1E4zrbAVFGQsJ0frFq8WtPXCe8uVw9QyPrK4+4+aIR36HZrc1zVr
	 gZjcuP2p7Ah4J6AFZOYtp+7+PZSVafr2+2lmjCBV0GI63OCqcglhdAEnCNWdId84sh
	 J50DmqGroRUqjCNNJKenC6jDbxk//nKXKMf0HQRjebPHphTfnwByxEYHLieQLWPfHo
	 So8tCyD8cog//TtKkW497ejNTbejYNE836ZCdhsuPTjZLllhocYWpDvsEc3Ww/SDpH
	 ubq8OLMaFKOm6CrxHAomkvTRH1X/YAoyyk9rwRYTJnMXaEXO1HeQVATj4v9vHpyP/S
	 3Mjek335x184Q==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 22/55] selftests/mm: add atexit() and signal handlers to thp_settings
Date: Mon, 11 May 2026 19:28:06 +0300
Message-ID: <20260511162840.375890-23-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD1154000A
X-Stat-Signature: 5h56ouwcj46unj1pbwggydd7mtg6y4ay
X-Rspam-User: 
X-HE-Tag: 1778517074-668215
X-HE-Meta: U2FsdGVkX19GuC7OPuXaoefQJ/G9VqLp36bEMLEyLFKQ/jwGPQdmDETwa+emcth/jwKmi7TrD5TjbUYiH/MHXvGOgIOGi+KRX1Q9G3LWi57VQdKwriqvukWSEv7Bl8C3AhocQqk6w3gi+M8a/W/S6u7uDg6/QttFFsZddUQT/gLcHy3qgPufBVTOAZt5kqUnXTbM4UXjNUTn7NcWv5jRSfBAFIs7j0/qNqnKpdJ7En2utTL4KfRYaT1PCngfWXzFrs/Ho/l5oRRu5Z0G4u2JH1+18eKHRQTmyM8C/rvjeIWYTV7ygpWjHCZdpoKxZGBkN3kEqvB+rf/DNQ735whGDRtz7WyJoUcFI+LnX7ZYZuod3QrZXtd/h9g7uE6px6Xtl6emB4In+Jg71WTrlicYbHHyVFqtSK14VCKXM8I0IQGAcY0y0Q1/iel3856mk0BW2oH8CWcBk/CuquCAv1PQbUSryiNS4xgKHDQ93yFje0c02Kk729xDia5VetTW7nm+sCao7U4LMjIyi7DQYawl202qXTaqv+kymai72reeRu0PCQwD3F13lkT6g3t4GDdiz+mP7FXIGfo7OOecIxfI88+ncEePw/cmnPkP15+ZTPQN2A7S1VAglRGAVKwNh+zpjvZ9Hl9lkOp1t2cjARjDFJcz4dvugqcvBlK7LouGLBSKpbEC0aSX0Vn5Zkva8Uk5Gx9BBC2DwYhfnwWGdP38ixZ/i+xSkq6zzXnEpsQidGaWUFV9+TagyMiif4t2MD57w8K76uCQoW4UAJEeAjVTP14PlXy+5Z8sg+vlnFwst7p9lwB5t+L+ZW/Lw+7AwxTcQkZgxwfAquI/ZK7kcRYgPyiJ/sTJBDRgLsYVjmkBK8sbopjnkMHVXnHLIzI4ylLtlVITd2TKPhBgXkOddxxYoAjECJURJ9Q3oE+XkVFCYkUQOAxnRuab/TtujptgwKTCq0ZThChGUsSA/SYK+s3
 BX8gQIoQ
 GUY1YuDrdHXinDjY6zMBloUy6B6j0DURj0YOPggYgMzGYIjMb7hDnKJM2NT9pCoRvPZ9E2OEFKEF9NlyJLSjTCtNofBzrnMeNcx94FjYC3tTy+mtO9TPC2Cj1Zv6xRNtIniiQOyOkwZtf2HejtZy3S74Ebs45gEYJwenZC9BozjU5J8l8RnvzE2/FFrR+6P0dLUi51UvIcEGCbtM/YHKEcJAPhHx7HOQbP8lmG4EdI1AFZAJAr3aAQDG/fXLDKWASOi7XuxugUEI/JTvtlsVjAFSRY5Uulj9gI3MuuHGn2DKoYuYfXkH9rmIZ/yZb6lUt37Plcsp1BfSyxOD9HVe86R35SwFvJ70VHlr6Qk8ASzkDbbk=
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

Update child process in khugepaged tests using thp_settings to use
_exit() instead of exit() to avoid altering THP settings in the middle
of a test.

Remove redundant THP cleanup from folio_split_race_test.c.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/cow.c              | 21 ++++------
 .../selftests/mm/folio_split_race_test.c      | 23 -----------
 tools/testing/selftests/mm/khugepaged.c       | 41 ++-----------------
 tools/testing/selftests/mm/thp_settings.c     | 27 +++++++++++-
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  4 --
 5 files changed, 38 insertions(+), 78 deletions(-)

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
diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
index ff026f183ac7..390fd97c1bd9 100644
--- a/tools/testing/selftests/mm/folio_split_race_test.c
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -226,23 +226,6 @@ static uint64_t run_iteration(void)
 	return reader_failures;
 }
 
-static void thp_cleanup_handler(int signum)
-{
-	thp_restore_settings();
-	/*
-	 * Restore default handler and re-raise the signal to exit.
-	 * This is to ensure the test process exits with the correct
-	 * status code corresponding to the signal.
-	 */
-	signal(signum, SIG_DFL);
-	raise(signum);
-}
-
-static void thp_settings_cleanup(void)
-{
-	thp_restore_settings();
-}
-
 int main(void)
 {
 	struct thp_settings current_settings;
@@ -261,12 +244,6 @@ int main(void)
 		ksft_exit_skip("Please run the test as root\n");
 
 	thp_save_settings();
-	/* make sure thp settings are restored */
-	if (atexit(thp_settings_cleanup) != 0)
-		ksft_exit_fail_msg("atexit failed\n");
-
-	signal(SIGINT, thp_cleanup_handler);
-	signal(SIGTERM, thp_cleanup_handler);
 
 	thp_read_settings(&current_settings);
 	current_settings.shmem_enabled = SHMEM_ADVISE;
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fd0693cc45d..712e8f194b3d 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -72,7 +72,6 @@ struct file_info {
 };
 
 static struct file_info finfo;
-static bool skip_settings_restore;
 static int exit_status;
 
 static void success(const char *msg)
@@ -93,26 +92,6 @@ static void skip(const char *msg)
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
-	ksft_print_cnts();
-	exit(exit_status);
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
@@ -121,12 +100,6 @@ static void save_settings(void)
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
@@ -846,8 +819,6 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 	ksft_print_msg("Share small page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 0))
 			success("OK");
 		else
@@ -859,7 +830,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 		validate_memory(p, 0, page_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -884,8 +855,6 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
@@ -908,7 +877,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 
 		validate_memory(p, 0, hpage_pmd_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -934,8 +903,6 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 	ksft_print_msg("Share huge page over fork()...");
 	if (!fork()) {
 		/* Do not touch settings on child exit */
-		skip_settings_restore = true;
-
 		if (ops->check_huge(p, 1))
 			success("OK");
 		else
@@ -968,7 +935,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 
 		validate_memory(p, 0, hpage_pmd_size);
 		ops->cleanup_area(p, hpage_pmd_size);
-		exit(exit_status);
+		_exit(exit_status);
 	}
 
 	wait(&wstatus);
@@ -1261,5 +1228,5 @@ int main(int argc, char **argv)
 		t->fn(t->ctx, t->ops);
 	}
 
-	restore_settings(0);
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
index e748ebfb3d4e..9bfa5dc42624 100644
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
@@ -298,12 +300,35 @@ void thp_pop_settings(void)
 
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
+	thp_settings_saved = true;
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


