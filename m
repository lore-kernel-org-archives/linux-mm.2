Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2723C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 08:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF48B6B0093; Tue, 28 Jul 2026 04:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6C36B0095; Tue, 28 Jul 2026 04:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C786B0096; Tue, 28 Jul 2026 04:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 550F66B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:13:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDF881A02B3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:13:57 +0000 (UTC)
X-FDA: 85037472114.23.A57684A
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf25.hostedemail.com (Postfix) with ESMTP id AD63AA0003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:13:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hxaDWIjE;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785226436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfxisp9S98oc5Z0LzgyZkCz4KtJiQIPq4LJ80FUffIw=;
	b=LFa1SW+c2QN0OcNMFwvsgesll6u4MVRrXfNmfOkQmB1s0WJoitT02eHGyIb9RPbmxqTM9l
	ZXIsud023fFKcN2Pj90chzGGCtAhAXM0jP3KcuHO5HxJPQPhBgozDJksHbemE3HPmEjdpx
	h8X300jG3aOWSczGJqo14C4BDIv4tMU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785226436;
	b=TEle6nxxZNqha+p/LhnimAJUDqSmo3daQCNRvBx0YJJTdGe5B/SRpjqpIejZ435KnE8lqk
	tluQraO/gZz99P2SqWVIUHMRBcWfxnBtXUMcrAX895ch6h6VG5IrTxVYYyfSQ45LbO4WJ0
	jrV3Oh/EE9vWoYhnv3h4iqZtSvwITaA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hxaDWIjE;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785226428; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=nfxisp9S98oc5Z0LzgyZkCz4KtJiQIPq4LJ80FUffIw=;
	b=hxaDWIjEbwk5nfswMT4SZzwntsKujWZBfl957UssQpmtAp33J9hjeRriS+68MsVXbL0AWDe37Qtjnrs0XcUlUU8OxozXdDElTIDsFr6ws2sqTp9AeBf78oHtnx+iWuhdTT0VWLzBWRAgsNN8+kRF90hjxe5zHEKcaN7p2n1WCV4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8-Elbm_1785226425;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8-Elbm_1785226425 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Jul 2026 16:13:45 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] selftests: mm: add mTHP collapse test cases
Date: Tue, 28 Jul 2026 16:13:36 +0800
Message-ID: <bea2086517b69a1af8813dac5774a1409aafd262.1785224928.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
References: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ytfhn3dz84fbkjza6srx11n348ap5j7k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD63AA0003
X-HE-Tag: 1785226434-322705
X-HE-Meta: U2FsdGVkX1/8Qsa5+1CxrRl9qNXryvPUxeIPIk/aAnm+wQKhquoj5fsotAw0FRMLK3rUaOm2LuQ57gSfEK0sgI1AHLn7T88sVfStwY2jXSBPRZoAQ7ulmubhKaDRbVMZCZMzD5y+pPjR6tsOeO5k6vRTP6PPUGdxqlwPwuupRx5GmiPciS2Xs7UNuKKx4ahTGWy0hmtXtSAwM2abT1O6nhf5oJin7xcgotErdJCJiV3lAPWtTcKKQN00nDUcV1ZFD5Ln8KkxsUowD6LVI0tvD2VokkTaTv9VAHlVV4o1INkIkOy7Q2QdM+N/8ik+zDbrggqT7aW04ZX2bcz8A3cksr+S1wM2kmm86Sh6b0C8ORrjOd2p3OTa6U1nno2GHMVZ6sdgkLbPaFudUzhuyB95B8zEeygZJX5Fsx2NE2YDtEekal4sHiZL9VqtBCrDqtN4awiCkSfJUbLqNBTL0QniyxFGXZJunl3Pq54+0LXZk8cyEa6h596zruokLr4PtUVN9N4HRuTX92By4Aiq5JmKder1HoVu/oLmWcWe19Z8nU+5ch7Byq3xJlzQ0dFwR4XHi78PmZdNGH+cwz6PBn3H/7ekhQ9EDABefZG77Hgs03jFyNk31Ey4uZDEdXGoFp7nt28d3acPPvIhgUpuVWakEUFy7XKXc0U7UCNF5w+3lZmNc4Chj4mAnI2/MdQYLFYLBIT0e4m3g0byVokyLsUNFmCilSyMfQADU5abalrVu6A9LwQQqphDyp4tuSscBw0sxfPAzeQlMqovgL1eIt8g5n56K4h5sHcOkW7fJUTs39ASL7aBSxWCw7N1eOfAPj2GRzQHBAJ55xdrqIS5NKiOZFYVWVik6dYoJFBX1/rhFHzkQaK71nAVyijj7zdG98QXPS/C7x8/MiBK5NWhsivpnYqecKblKwyeK8VolzAdZjag+XX3fZc9MzdWtnmxx0lk3q/0Ge3e7uOtiS4KPU+
 RHXAbSEs
 jsG3VVXcZDA2x+psp96tMA71zDjk71BMW8qHxdhvaxL0vnYScOzTEOA5UUvwpvSh5DW2JdWUElVuYVSiUAbQL4HySQpcdF+ocKuhyWTVAk2csHDJaXHi3DsajscxIEQgMDBkN2z2DTVoUVyXf4rGqbDc6xIi9eNsYPdWj0SDGmgFD8IBDbIogTi/AuC/JXDRB4yV5izvoUt+mgdWtmjWbmGYmlhGVBr4Jl7nha99G63gwJcqngqlc1rhu9VYtkZdkAY+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '-c'
parameter to specify the collapse order. Additionally, added mTHP collapse
test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mthp'
for anonymous folios. All khugepaged test cases passed.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 tools/testing/selftests/mm/khugepaged.c   | 130 ++++++++++++++++++----
 tools/testing/selftests/mm/run_vmtests.sh |   2 +
 2 files changed, 113 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f69be6be0ecd..e21a6ec38363 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -26,9 +26,11 @@
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
+static int hpage_pmd_order;
 static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
+static int collapse_order;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -69,6 +71,7 @@ struct collapse_context {
 };
 
 static struct collapse_context *khugepaged_context;
+static struct collapse_context *mthp_khugepaged_context;
 static struct collapse_context *madvise_context;
 
 struct file_info {
@@ -554,25 +557,25 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
 }
 
 #define TICK 500000
-static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
-			  struct mem_ops *ops)
+static bool wait_for_scan(const char *msg, char *p, unsigned long size,
+		int nr_hpages, int collap_order, struct mem_ops *ops)
 {
-	unsigned long size = nr_hpages * hpage_pmd_size;
+	unsigned long hpage_size = page_size << collap_order;
 	int full_scans;
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
-	if (!ops->check_huge(p, size, 0, hpage_pmd_size))
+	if (!ops->check_huge(p, size, 0, hpage_size))
 		ksft_exit_fail_msg("Unexpected huge page\n");
 
-	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
+	madvise(p, size, MADV_HUGEPAGE);
 
 	/* Wait until the second full_scan completed */
 	full_scans = thp_read_num("khugepaged/full_scans") + 2;
 
 	ksft_print_msg("%s...", msg);
 	while (timeout--) {
-		if (ops->check_huge(p, size, nr_hpages, hpage_pmd_size))
+		if (ops->check_huge(p, size, nr_hpages, hpage_size))
 			break;
 		if (thp_read_num("khugepaged/full_scans") >= full_scans)
 			break;
@@ -595,7 +598,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 	if (!is_tmpfs(ops) && ops == &__read_write_file_write_ops)
 		expect = false;
 
-	if (wait_for_scan(msg, p, nr_hpages, ops)) {
+	if (wait_for_scan(msg, p, size, nr_hpages, hpage_pmd_order, ops)) {
 		if (expect)
 			fail("Timeout");
 		else
@@ -617,12 +620,62 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 		fail("Fail");
 }
 
+static void mthp_khugepaged_collapse(const char *msg, char *p, int nr_hpages,
+				struct mem_ops *ops, bool expect)
+{
+	unsigned long hpage_size = page_size << collapse_order;
+	struct thp_settings settings = *thp_current_settings();
+	/* mTHP collpase only allocates PMD sized memory */
+	unsigned long size = hpage_pmd_size;
+
+	/* Set mTHP setting for mTHP collapse */
+	if (ops == &__anon_ops) {
+		settings.thp_enabled = THP_NEVER;
+		settings.hugepages[collapse_order].enabled = THP_ALWAYS;
+	}
+
+	thp_push_settings(&settings);
+
+	if (wait_for_scan(msg, p, size, nr_hpages, collapse_order, ops)) {
+		if (expect)
+			fail("Timeout");
+		else
+			success("OK");
+
+		/* Restore THP settings for mTHP collapse. */
+		thp_pop_settings();
+		return;
+	}
+
+	/*
+	 * For file and shmem memory, khugepaged only retracts pte entries after
+	 * putting the new hugepage in the page cache. The hugepage must be
+	 * subsequently refaulted to install the pmd mapping for the mm.
+	 */
+	if (ops != &__anon_ops)
+		ops->fault(p, 0, nr_hpages * hpage_size);
+
+	if (ops->check_huge(p, size, expect ? nr_hpages : 0, hpage_size))
+		success("OK");
+	else
+		fail("Fail");
+
+	/* Restore THP settings for mTHP collapse. */
+	thp_pop_settings();
+}
+
 static struct collapse_context __khugepaged_context = {
 	.collapse = &khugepaged_collapse,
 	.enforce_pte_scan_limits = true,
 	.name = "khugepaged",
 };
 
+static struct collapse_context __mthp_khugepaged_context = {
+	.collapse = &mthp_khugepaged_collapse,
+	.enforce_pte_scan_limits = true,
+	.name = "mthp_khugepaged",
+};
+
 static struct collapse_context __madvise_context = {
 	.collapse = &madvise_collapse,
 	.enforce_pte_scan_limits = false,
@@ -661,10 +714,17 @@ static void alloc_at_fault(void)
 static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
 {
 	void *p;
-	int nr_hpages = 4;
+	int nr_pmds = 4, nr_hpages = 4;
 	unsigned long size = nr_hpages * hpage_pmd_size;
 
-	p = ops->setup_area(nr_hpages);
+	/* Only try 1 PMD sized range for mTHP collapse. */
+	if (c == &__mthp_khugepaged_context) {
+		nr_pmds = 1;
+		nr_hpages = 1 << (hpage_pmd_order - collapse_order);
+		size = hpage_pmd_size;
+	}
+
+	p = ops->setup_area(nr_pmds);
 	ops->fault(p, 0, size);
 	c->collapse("Collapse multiple fully populated PTE table", p, nr_hpages,
 		    ops, true);
@@ -676,10 +736,31 @@ static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
 
 static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
 {
+	int nr_hpages = 1;
+	void *p;
+
+	if (c == &__mthp_khugepaged_context)
+		nr_hpages = 1 << (hpage_pmd_order - collapse_order);
+
+	p = ops->setup_area(1);
+	c->collapse("Do not collapse empty PTE table", p, nr_hpages, ops, false);
+	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_single_mthp(struct collapse_context *c, struct mem_ops *ops)
+{
+	unsigned long hpage_size = page_size << collapse_order;
 	void *p;
 
 	p = ops->setup_area(1);
-	c->collapse("Do not collapse empty PTE table", p, 1, ops, false);
+	/*
+	 * Only fault collapse_order sized ranges, and only check 1
+	 * collapse_order sized huge page.
+	 */
+	ops->fault(p, 0, hpage_size);
+	c->collapse("Collapse PTE table with half PTE entries present",
+		p, 1, ops, true);
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1081,8 +1162,8 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
 	ops->fault(p, 0, size);
 
 	/* Let khugepaged collapse and leave pmd cleared */
-	if (wait_for_scan("Collapse and leave PMD cleared", p, nr_hpages,
-			  ops)) {
+	if (wait_for_scan("Collapse and leave PMD cleared", p, size, nr_hpages,
+			  hpage_pmd_order, ops)) {
 		fail("Timeout");
 		return;
 	}
@@ -1098,7 +1179,7 @@ static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
 	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
-	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
+	fprintf(stderr, "\t<context>\t: [all|khugepaged|mthp_khugepaged|madvise]\n");
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
@@ -1109,6 +1190,7 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-h: This help message.\n");
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
+	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
 	exit(1);
 }
 
@@ -1118,11 +1200,14 @@ static void parse_test_type(int argc, char **argv)
 	char *buf;
 	const char *token;
 
-	while ((opt = getopt(argc, argv, "s:h")) != -1) {
+	while ((opt = getopt(argc, argv, "s:c:h")) != -1) {
 		switch (opt) {
 		case 's':
 			anon_order = atoi(optarg);
 			break;
+		case 'c':
+			collapse_order = atoi(optarg);
+			break;
 		case 'h':
 		default:
 			usage();
@@ -1148,6 +1233,10 @@ static void parse_test_type(int argc, char **argv)
 		madvise_context =  &__madvise_context;
 	} else if (!strcmp(token, "khugepaged")) {
 		khugepaged_context =  &__khugepaged_context;
+	} else if (!strcmp(token, "mthp_khugepaged")) {
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
+		if (collapse_order <= 0 || collapse_order >= hpage_pmd_order)
+			usage();
 	} else if (!strcmp(token, "madvise")) {
 		madvise_context =  &__madvise_context;
 	} else {
@@ -1213,7 +1302,6 @@ static int nr_test_cases;
 
 int main(int argc, char **argv)
 {
-	int hpage_pmd_order;
 	struct thp_settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
@@ -1239,10 +1327,6 @@ int main(int argc, char **argv)
 	if (!thp_is_enabled())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
-	parse_test_type(argc, argv);
-
-	setbuf(stdout, NULL);
-
 	page_size = getpagesize();
 	hpage_pmd_size = read_pmd_pagesize();
 	if (!hpage_pmd_size)
@@ -1250,6 +1334,10 @@ int main(int argc, char **argv)
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
+	parse_test_type(argc, argv);
+
+	setbuf(stdout, NULL);
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
@@ -1267,6 +1355,7 @@ int main(int argc, char **argv)
 	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
+	TEST(collapse_full, mthp_khugepaged_context, anon_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
 	TEST(collapse_full, madvise_context, read_write_file_read_ops);
@@ -1274,8 +1363,11 @@ int main(int argc, char **argv)
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
+	TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
+	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
+
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_read_ops);
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 687d115e3bd8..d09f9f6a384e 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -410,6 +410,8 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
+CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
+
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-- 
2.47.3


