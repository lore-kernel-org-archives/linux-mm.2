Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9382C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 06:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D616B0093; Sat,  1 Aug 2026 02:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407706B0095; Sat,  1 Aug 2026 02:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1086B0096; Sat,  1 Aug 2026 02:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAC926B0093
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:27:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D615160269
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:27:02 +0000 (UTC)
X-FDA: 85051717884.03.BAB29DA
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5CD9C80002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:26:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yjzAedOe;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785565619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeTN6/wbbbJzcWBYOmzqiIEjf07PxMHihk3dLZnDlrk=;
	b=vQy+8YHuWxeFlsh3N2xcuQlOc01ULuWs6TgWHxmQKAVZbilVPjFvv56qmN0c/N2W3VV9AU
	fCQXaxm/3uuOtR+RZzQG21NA/+qr+KfMTJUN9NUgm4FlraVcg7lDyiKdJ5uNgDm/xzpjjJ
	PpTJsSAKnHxZKUvWPCoUiIDOL1UEPQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785565619;
	b=8aaduCHznSWHnJ+3SNAKoUFSc3d86ZKbZFlgxhkl+IoMjMnRjXCNZ29flzJp2yzGwr1VIK
	19XzmzehyZhMmEbYFpf3ROUdatHSZKfi2YFZ3SnIbV2va6aq5wEkxfwyI25BTbzJhRIQwv
	9MCxCXaO65NxJwF70pIDtZr+JPs8sVw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yjzAedOe;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785565613; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=FeTN6/wbbbJzcWBYOmzqiIEjf07PxMHihk3dLZnDlrk=;
	b=yjzAedOe0h7r3zejJXKWU4raT1u+q+yYK27lYwekA0Zn+phVm3J14UXBTtm4XSZ+Cs8jiG6gE8ejNFXsDqrF8+++oQQ1RXx6wLqCaAIAv7aHcyPXGnNEZF2U0jqihwENzYAJUMQt7PMtpDyffmPC4L3IWhRqMjd2ZWZ0uY3cF24=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X89c9eS_1785565611;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X89c9eS_1785565611 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 01 Aug 2026 14:26:52 +0800
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
Subject: [PATCH v2 4/4] selftests: mm: add mTHP collapse test cases
Date: Sat,  1 Aug 2026 14:26:38 +0800
Message-ID: <dd8013c1ddada90913876e3bd912c07e613fba8d.1785564857.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5CD9C80002
X-Stat-Signature: 91o1aazprcizbizy6qrrbxarn1x65fjc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785565618-741258
X-HE-Meta: U2FsdGVkX1+/BDEWE2l4tNCk2BylSuJovUGlBXpyksW6S+TKoxRrDNoyHTUkYSAFNziuQJVLpqR3V/zWs27jELyS6WOCkDoSwTTs3A8eQCQ7yjOmC3mI78++0cJO3CzKyXQdmD7gk/VMpaZ2M/cEygDyxcgWiRyuaW5eKN6Kg/kWOcUPc7RKjA9k/lmYx4jTJfPZ5ylWvRwSkmSqXCLzyoCRk2zdWAtdbYo/krhz4FvcZwAyYPFhH1ZMyQEI2hlwcM9IW2ZXNMeRSd9s6ai4vTeszJkqMATOcKawHjL0/pgPlUq5m8ovEMWGUAvPStHtcWnOT9C8RAB+WOdY6GZ6zq/6nWXjvV8BvxSZbiGlwncqLYluCbTlOA2FeIHfKBq1bvago7231FZA1LC67jvpAO5a6hHUObfIrTOHOKTNhHxhYOe4hcyi/oLc0Mv4zLfUkrtxQmx14sSOBANzmLv2CeGC7jK2a1jsZ0XcfwMGnjCCQFmgIuw3Re2RRQsK+Ps99ZXNwlGyJiXNS3lCXGMTpV6We79iRFIKOvflQIUvemjRGj2eZR+CvO8dlp+i54saDTSvzHptM3bTQszJp8/X8DPYn9l9a/pV51FOY6RR8jA9Lmet88j2uRnhr3uPKZtQ4lZL3y/yes2el8uof2r6TxOmjla6JVOZGJCtTsjlUR9u2rJO5eA8eINicMjsCTGHzR9Xdkc/Zh5RHtnoxHMG1ue6P78giofSfRGumjC4FbjUFp14/ubtw9Rz4q0O3jv3IR5Xf7x7la1OCN4Af71TO76slmNVlEZL8ZWt/sStEwnNXwuqYCi8QlzPrihkneUAnZSc+Ze8J8M6u14Ip4fGnuImzsR0S6aEW1zn8rj5YEWwenUbSpeEP7DDJ82kFNI647M0qlljs4Np/9PponxVMam75ZyzxW9V7jMaC9POGJER/LBLFWMrY5h5QljA1/utVCRcG4oMjqyXkvyQQ1W
 ST08dXGH
 dPFenJNfqHM85ItNNdQK7eZgThv7B+SPcblXIhCCeXLnSZ5g3NaPjZX02Q35/VSV4x72BnDTmq+TvCkb+aDiqVLOZjQ82+fxH2Fy03rsZq+uYViKn5GEUPwwJZt/aCXNd35w+mHZvz8zNckbmu6AQ3ftridM5lLgM+O807QjJXszyAfhW2Xyk0wcVTAEEQCBtYyR3aU1tOwNh+rPYEfR63E5whCmbXxiEJU1z6FWuqXltet/GygJdZrgjME5mWVYlcGee
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
index f69be6be0ecd..64d6da6aa90d 100644
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
+		settings.hugepages[collapse_order].enabled = THP_MADVISE;
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


