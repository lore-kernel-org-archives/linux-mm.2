Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3953607555A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hGLOrTkN
Received: by kanga.kvack.org (Postfix)
	id CBEBC6B05BD; Tue, 10 Nov 2026 02:45:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6FC36B05BE; Tue, 10 Nov 2026 02:45:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F5F6B05BF; Tue, 10 Nov 2026 02:45:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 892636B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:45:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EB4FA085D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:45 +0000 (UTC)
X-FDA: 85418425050.16.F966206
Received: from mta1.migadu.com (out-97.mta1.migadu.com [95.215.58.97])
	by imf17.hostedemail.com (Postfix) with ESMTP id 33F0740002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hGLOrTkN;
	spf=pass (imf17.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794296743;
	b=5vuJbQKqigfO5rXcRFSzr5tnITOSfQMrhR7swMwRHxzxwwDCOryQ1456dWbWVZbOzjpF/R
	b7arVhgisYxXrg52TEnUHEE40vptkQULC3o4iQV1ZfQZQCw3+0Qx3uDDB40cnAYRYQ9EU1
	cQRilhq3oNvwHuETwpFZxhkbF7lhz1w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hGLOrTkN;
	spf=pass (imf17.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794296743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/UcQFN1fT4xKZkZ8LLvoG6TGQaSTpYGVdEtojnOZAc=;
	b=usWVXtdCX9OJx2gAUYC9a//rTrPNghfvBeAziDAESjTNiYsZiZX7pTJTz3E53/rxSNQGV1
	QHsN4Na5LfJZqzmxtq9cGYuhgfUT0p5yLqYyxAbyo6F0sfJTb+nEGZmeyTMdpb0+WLupqA
	1/wW0iRBmbrUdFUMrQgdoC6U9OpIJeU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ltueAResg7nQ5h4N2uZJoyGUbiD7RPPYBW6X+pD3324=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794296742; v=1; x=1794901542;
 b=hGLOrTkNtVDCRVp0cyzkHifJmElg80y14hV6JM3WDP18ctmttS0g93cczYi/tmnwtFZXwL/2
 BKZ+r8+pV20A3at5nmYOWaSLYK8qH+AfKMnwBvKK1BVJNQYYeopD5BuDhD1CjZ5gCy3MaN7izCu
 9ddvsSi+oLmjg16qgBWCaiHc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a3f2b9640a841c13;
	Tue, 10 Nov 2026 07:45:28 +0000
X-Mizu-Trace-ID: a3f2b9640a841c13
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	david@kernel.org,
	link@vivo.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	odys.yuan@gmail.com,
	rppt@kernel.org,
	surenb@google.com,
	tujinjiang@huawei.com,
	vbabka@kernel.org,
	xiao.wang@vivo.com
Subject: [PATCH 3/4] selftests/ksm: consolidate ksm_stat readers into ksm_get_self_stat()
Date: Tue, 10 Nov 2026 15:44:50 +0800
Message-Id: <20261110074451.220524-3-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110074451.220524-1-xu.xin@linux.dev>
References: <20261110074312.219847-1-xu.xin@linux.dev>
 <20261110074451.220524-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4kqkf5ywn3371xtwkermfj4nsecuet4n
X-Rspamd-Queue-Id: 33F0740002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794296742-709878
X-HE-Meta: U2FsdGVkX1+TpeAJaH7vFulD9lQHIxMwWOPcblzsEMt4Jt2htTb1PhBtBC+9r59rdchYLkMyOR4mKzxxPaUPolSOVL5j7EeHeu3ndCzruRBqduwSujZFG5KUviqxCuS0yQDEDj0GGulK9gen39RnCZYiBTR6jMhoPpBW3ofctLke13lsOqV31wijNSvlzDKC0n6TiA3b16C6Kkok7buLxnfZtXWp+PfVMNZz8Ssd5tMR86LR3JC5I+K9ZxQr7vp7KkN3QX75ynHxXcNTh9K7E/zBQqn9YUbXIqaYnAB6gGJSo5FwO2SCig6eQTSHR339fTiL3V5AdKPfkzaPsDKmRSk4ibZiVNBvbteQGSNo2XcusYPK0UENJRv8guAB7iitPJocUU+2cakfyygeuCdPh/ghoEDD9PgoCc4c9nIiTe5y2R0keAJAuWekGZlKJeorKGUQyhhp8Q1F9OnBWTosOHMe3mjbDyF+EJpD5ZjhdSJXH7Xb04wBYLqVWjQlFLPVZ8rX0VToiDy/1VmJ28vKztmqz1TMaVH4jRnyyVVvgosjiY3OTzTvxZkrqRFuNaMWq31pgG1e2PlRYjNbN4EKAcmihtDQRz4A0Gx0BhqoTGgb4obfsI2rSS6HGujbsgRJE2ZxaH40GdMk4FQZdOQM7XksybTeQqwtJ5xqAEvPGGINuOC0zD2Y4apKveoEL1k8TCdUKCy3exoZMRzwOOsniPdo8p4sNcux6rrEgUaI+n0m5emU7H0fFmOnUwl+4KsfqSH1vjL9YnDwPdN32l3KQel/EZv3onSJvhzYO0vGeET1jYeax95lSSQy6Wum1jORCJRUcLskYGOL0rBDUcqIEhhbSFjBOiN8jt3LkEhVkQbhupc+e6zMR5PhLrYQL3OApnhES0WaggichgPCs8Dkd4kKHDHkhpNUNMAoeRE3ppqjh3KFv26PQ1KsTRZHtdb7BFH4SIFFZPU+lIo/xJP
 4V/5j+O5
 rFaF7ehYvz15HNYdd5o3vwuU/QNZn/3Xk2aL4DHlkNXUe+HlSRZNWaSk4DphCy6IKWgMl3TK3Gsf1WiGF1L8y/24lrVZIgIxM8NFLl3LHbJIKO2IOD2sMsuCWafoypYQ/yFERFZrsvGuziYmtKcnafblA0oAqIKcPLE/QWhvVP0C5K/ENw6hB1FCsO0ItiUD+UbvQd1odMPIe9IhPUSc8awZyz1SRdFWUvb1A30oWAvnp4uvKDeI4zfYbUodoQi4yL8+Y5Q+wpTSGST3Kk/YCjcpcJI4R4QQhSNrjh7y0COyzMs6CClc/h6vLCkz0OTRJ5LkEyAQwRPXDwp4+zxc03p7n+9ugwHgrOAaj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ksm_get_self_zero_pages() and ksm_get_self_merging_pages() both read
/proc/self/ksm_stat and differ only in the key they look up. Replace
them with a single ksm_get_self_stat(key) helper in vm_util.c, which
reads one value from /proc/self/ksm_stat by key name and accepts only
the keys used by the tests.

This is a pure refactor with no functional change; it prepares for a
new test that also needs to read ksm_rmap_items from /proc/self/ksm_stat.

No functional change intended.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
 .../selftests/mm/ksm_functional_tests.c       | 18 ++++-----
 tools/testing/selftests/mm/vm_util.c          | 40 ++++++-------------
 tools/testing/selftests/mm/vm_util.h          |  3 +-
 3 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 135191f99962..2ffb97ae3120 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -85,7 +85,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 		return err_map;
 	}
 
-	if (ksm_get_self_merging_pages() > 0) {
+	if (ksm_get_self_stat("ksm_merging_pages") > 0) {
 		ksft_print_msg("Still pages merged\n");
 		return err_map;
 	}
@@ -144,7 +144,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	 * Check if anything was merged at all. Ignore the zero page that is
 	 * accounted differently (depending on kernel support).
 	 */
-	if (val && !ksm_get_self_merging_pages()) {
+	if (val && !ksm_get_self_stat("ksm_merging_pages")) {
 		ksft_print_msg("No pages got merged\n");
 		goto unmap;
 	}
@@ -204,7 +204,7 @@ static void test_unmerge_zero_pages(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	if (ksm_get_self_zero_pages() < 0) {
+	if (ksm_get_self_stat("ksm_zero_pages") < 0) {
 		ksft_test_result_skip("accessing \"/proc/self/ksm_stat\" failed\n");
 		return;
 	}
@@ -221,7 +221,7 @@ static void test_unmerge_zero_pages(void)
 
 	/* Check if ksm_zero_pages is updated correctly after KSM merging */
 	pages_expected = size / pagesize;
-	if (pages_expected != ksm_get_self_zero_pages()) {
+	if (pages_expected != ksm_get_self_stat("ksm_zero_pages")) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after merging\n");
 		goto unmap;
 	}
@@ -234,7 +234,7 @@ static void test_unmerge_zero_pages(void)
 
 	/* Check if ksm_zero_pages is updated correctly after unmerging */
 	pages_expected /= 2;
-	if (pages_expected != ksm_get_self_zero_pages()) {
+	if (pages_expected != ksm_get_self_stat("ksm_zero_pages")) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after unmerging\n");
 		goto unmap;
 	}
@@ -244,7 +244,7 @@ static void test_unmerge_zero_pages(void)
 		*((unsigned int *)&map[offs]) = offs;
 
 	/* Now we should have no zeropages remaining. */
-	if (ksm_get_self_zero_pages()) {
+	if (ksm_get_self_stat("ksm_zero_pages")) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after write fault\n");
 		goto unmap;
 	}
@@ -671,7 +671,7 @@ static void test_fork_ksm_merging_page_count(void)
 	child_pid = fork();
 	if (!child_pid) {
 		init_global_file_handles();
-		exit(ksm_get_self_merging_pages());
+		exit(ksm_get_self_stat("ksm_merging_pages"));
 	} else if (child_pid < 0) {
 		ksft_test_result_fail("fork() failed\n");
 		goto unmap;
@@ -771,7 +771,7 @@ static void test_merge_aged_pairs(void)
 		goto unmap;
 	}
 
-	ksft_test_result(ksm_get_self_merging_pages() == 2 * pairs,
+	ksft_test_result(ksm_get_self_stat("ksm_merging_pages") == 2 * pairs,
 			 "Pages aged by smart scan got merged\n");
 unmap:
 	ksm_stop();
@@ -793,7 +793,7 @@ static void init_global_file_handles(void)
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
-	if (ksm_get_self_merging_pages() < 0)
+	if (ksm_get_self_stat("ksm_merging_pages") < 0)
 		ksft_exit_skip("accessing \"/proc/self/ksm_merging_pages\") failed\n");
 
 	pages_to_scan_fd = open("/sys/kernel/mm/ksm/pages_to_scan", O_RDWR);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index f26f9e4bfdbe..8f1ee1f81e36 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -904,14 +904,20 @@ bool detect_huge_zeropage(void)
 	return enabled;
 }
 
-long ksm_get_self_zero_pages(void)
+long ksm_get_self_stat(const char *key)
 {
 	int proc_self_ksm_stat_fd;
 	char buf[200];
-	char *substr_ksm_zero;
+	char *substr;
 	size_t value_pos;
 	ssize_t read_size;
 
+	/* Only the keys actually used by the tests are accepted. */
+	if (strcmp(key, "ksm_rmap_items") &&
+	    strcmp(key, "ksm_zero_pages") &&
+	    strcmp(key, "ksm_merging_pages"))
+		return -EINVAL;
+
 	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
 	if (proc_self_ksm_stat_fd < 0)
 		return -errno;
@@ -925,34 +931,12 @@ long ksm_get_self_zero_pages(void)
 
 	buf[read_size] = 0;
 
-	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
-	if (!substr_ksm_zero)
+	substr = strstr(buf, key);
+	if (!substr)
 		return 0;
 
-	value_pos = strcspn(substr_ksm_zero, "0123456789");
-	return strtol(substr_ksm_zero + value_pos, NULL, 10);
-}
-
-long ksm_get_self_merging_pages(void)
-{
-	int proc_self_ksm_merging_pages_fd;
-	char buf[10];
-	ssize_t ret;
-
-	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
-						O_RDONLY);
-	if (proc_self_ksm_merging_pages_fd < 0)
-		return -errno;
-
-	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
-	close(proc_self_ksm_merging_pages_fd);
-	if (ret < 0)
-		return -errno;
-	if (!ret)
-		return -EIO;
-	buf[ret] = 0;
-
-	return strtol(buf, NULL, 10);
+	value_pos = strcspn(substr, "0123456789");
+	return strtol(substr + value_pos, NULL, 10);
 }
 
 long ksm_get_full_scans(void)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ab1325dc6580..2b25a9eab30c 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -159,8 +159,7 @@ static inline int sz2ord(size_t size, size_t pagesize)
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
-long ksm_get_self_zero_pages(void);
-long ksm_get_self_merging_pages(void);
+long ksm_get_self_stat(const char *key);
 long ksm_get_full_scans(void);
 int ksm_wait_full_scans(long nr);
 int ksm_get_smart_scan(void);
-- 
2.34.1


