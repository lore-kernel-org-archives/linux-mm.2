Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED748CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6AA48E0047; Wed, 20 Aug 2025 05:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1BFF8E003E; Wed, 20 Aug 2025 05:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE47D8E0047; Wed, 20 Aug 2025 05:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5EF08E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B4461175B5
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:58 +0000 (UTC)
X-FDA: 83796558636.18.2ABE43C
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf20.hostedemail.com (Postfix) with ESMTP id E830D1C0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dRby7plr;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvI4x2iIQB1VP2FwvPVI+Ftp5i1v0UQgsUVTdBGrP/g=;
	b=L9co+doiNlfrTzrg0p3yRx6UmZqxfNU/gW0QSejH/yRfM/OeOiotYE480uGYEQUXD13zq7
	mivedc3bTvhXQTbQLC+awexvqmRQclMbSiDFLymdIx7ln9ysrIBgmw0El8rK0qS92KZETr
	5ouq441bSRmH0gD+yAg32bJX5mZD4b4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dRby7plr;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680876; a=rsa-sha256;
	cv=none;
	b=DLRK0i+Mns+4VBhBgrS5vgsHEEQT1oxIO1RuAtgB2JvOqyfmxKIrKgK9rZBJxur97vdyWX
	bUGD5VOYhKqj9sydV8RmUPWpjKg+XH+Ea4IAKJvuM+QrPr7E/OSs+IomJ7uiep0JoV0O0/
	wSgkTKyhpzlaMV2d8ilQ++7x8nsvN94=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680869; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=lvI4x2iIQB1VP2FwvPVI+Ftp5i1v0UQgsUVTdBGrP/g=;
	b=dRby7plrMJPfhpilHGUKLliIM5LYudrd6fvBN5tezFpwZucv0j1gY57gwJ0pqIwYdHr4IbhlEatOF5+NbPzWwxUmttq84bRg3xD2b/GQM+OFmmItNoetydEADhFzshZv1xEVoY3Y1vwOeHJtdaaIpqBYxARIAQv+17xbFS/SiDE=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBICwN_1755680868 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:48 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 11/11] selftests: mm: add mTHP collapse test cases
Date: Wed, 20 Aug 2025 17:07:22 +0800
Message-ID: <e364feceb95917f569d5c0b36289788fcab45e24.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4zbj69mocaobfsuzqarriya1kbk869u9
X-Rspam-User: 
X-Rspamd-Queue-Id: E830D1C0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755680875-197771
X-HE-Meta: U2FsdGVkX1/NiamoDfiLwYl9h2o3vv5JCPMUZ2bNX3yCFiCKmZ7bfNO3Qhd4a7AkiwwbjpGH75KrI/MVHd6GZxWup7u1FR84damkYPdviEE0B18UrtlAUlIEzcOKh7VA2aHKD9FuQWDwpKOdFq2vwqdfVcLIwgizLbU/UDcgcvtFgzTj6vh+2czG1lGhrocFx+nZ8Edt5rHcGMOSvQKGxaq8G/Mc/wmnauk34DAo3IWVe4ogrAdG0256xMBeqQaBtLh0596+qlhMJlRCML4GPAfzC/SCCh20NjXdO/yicPh3JQLaNvO2h1BBlhvdXwrvhsSEKB5rSNmo/+a/I+OatCddLmUVzGdtOrUlAUyCTR62Y6LtXTFYzjXixoUFbvDyPZnYYVj76SWjsvbxZl9qfpBfzlL+Ucz9WUnUZNk5gWW6PiiWxFs+OIzMmoSVwrpQfjc00pZzrghdc021yF5nQQd9NZkHVHs6t3yiU5EB5uTBG1OSxr5robNx3NB67YRyQJ5dHnuFCY0D+mBk8pExwk3srdPnSMghPk52WjZ3E3136Li/0xFCincrE53JvqtReTQwSt1RoQjEdsc/3sYmSB3qks4Ah5i8E7LQmwvoOC7UhIaQf8BwpNobh/lzfvKjV5AT6dIO/w9jgLNdnM+Clk5vWfl6SLMnLjI+UbuoJgPGb6kJK4oVD2CFYIgKI7oUlR7QrvB5YlEZCXDLK4yYeq5Wlr4RLMtHTV1bfFW+6NEWezoLqf6xWsPbxqiW3fKWyDdJlpn8uV/EopWzeo6WEMZ31sZ4lS+mvR8YXwx+tARjoQ0rk7HLx6bZznKRJTlBz0QPWXw1bt9DOht2bkx/ZD+YXEg+8ZH/xUIhWDl7zPohBFBiHoYo3pUXiteoyO5Ep1q0KqRRdKukY9Jyhwaf8rS6laSB/DgkUG6+/YmniSxaL/kxXxi1ME0OUa1toX3oTqLZfaE6tc2BK1oju+H
 lP0DWgYe
 Bq8wKGvBO9HP1WOgiSWmNScj5oNRcMglpOaIngh+huTzP2UScheIqPKswMNhqwQuP+T650nV72SP/Gz+JvjCul6vB3NBwPXJMAPdbh4Jm34QQ1aJ3CWmywDfoQupgcue5rHOlPRymf1DYbMi3BokKAXRYpz+SHFgz2w6Kxfrysw4Ovgw14wwp124D+euLjRxc8Em1l/TqsUKSj9AKNCggKXx51qzEhARA6wlCIeu+r01vHw1OP4EdSPHMIKKg2/XZ5/lo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mTHP collapse test cases.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 tools/testing/selftests/mm/khugepaged.c   | 102 +++++++++++++++++++---
 tools/testing/selftests/mm/run_vmtests.sh |   4 +
 2 files changed, 92 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index e529074a1fdf..f7081e9e20ec 100644
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
@@ -61,6 +63,7 @@ struct collapse_context {
 };
 
 static struct collapse_context *khugepaged_context;
+static struct collapse_context *mthp_khugepaged_context;
 static struct collapse_context *madvise_context;
 
 struct file_info {
@@ -538,26 +541,27 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
 
 #define TICK 500000
 static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
-			  struct mem_ops *ops)
+			  int collap_order, struct mem_ops *ops)
 {
-	unsigned long size = nr_hpages * hpage_pmd_size;
+	unsigned long hpage_size = page_size << collap_order;
+	unsigned long size = nr_hpages * hpage_size;
 	int full_scans;
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
-	if (!ops->check_huge(p, size, 0, hpage_pmd_size)) {
+	if (!ops->check_huge(p, size, 0, hpage_size)) {
 		printf("Unexpected huge page\n");
 		exit(EXIT_FAILURE);
 	}
 
-	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
+	madvise(p, size, MADV_HUGEPAGE);
 
 	/* Wait until the second full_scan completed */
 	full_scans = thp_read_num("khugepaged/full_scans") + 2;
 
 	printf("%s...", msg);
 	while (timeout--) {
-		if (ops->check_huge(p, size, nr_hpages, hpage_pmd_size))
+		if (ops->check_huge(p, size, nr_hpages, hpage_size))
 			break;
 		if (thp_read_num("khugepaged/full_scans") >= full_scans)
 			break;
@@ -573,7 +577,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 {
 	unsigned long size = nr_hpages * hpage_pmd_size;
 
-	if (wait_for_scan(msg, p, nr_hpages, ops)) {
+	if (wait_for_scan(msg, p, nr_hpages, hpage_pmd_order, ops)) {
 		if (expect)
 			fail("Timeout");
 		else
@@ -595,12 +599,66 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 		fail("Fail");
 }
 
+static void mthp_khugepaged_collapse(const char *msg, char *p, int nr_hpages,
+				struct mem_ops *ops, bool expect)
+{
+	unsigned long hpage_size = page_size << collapse_order;
+	unsigned long size = nr_hpages * hpage_pmd_size;
+	struct thp_settings settings = *thp_current_settings();
+
+	nr_hpages = size / hpage_size;
+
+	/* Set mTHP setting for mTHP collapse */
+	if (ops == &__anon_ops) {
+		settings.thp_enabled = THP_NEVER;
+		settings.hugepages[collapse_order].enabled = THP_ALWAYS;
+	} else if (ops == &__shmem_ops) {
+		settings.shmem_enabled = SHMEM_NEVER;
+		settings.shmem_hugepages[collapse_order].enabled = SHMEM_ALWAYS;
+	}
+
+	thp_push_settings(&settings);
+
+	if (wait_for_scan(msg, p, nr_hpages, collapse_order, ops)) {
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
+		ops->fault(p, 0, size);
+
+	if (ops->check_huge(p, size, expect ? (size / hpage_size) : 0, hpage_size))
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
@@ -650,6 +708,12 @@ static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
 	int nr_hpages = 4;
 	unsigned long size = nr_hpages * hpage_pmd_size;
 
+	/* Only try 1 PMD sized range for mTHP collapse. */
+	if (c == &__mthp_khugepaged_context) {
+		nr_hpages = 1;
+		size = hpage_pmd_size;
+	}
+
 	p = ops->setup_area(nr_hpages);
 	ops->fault(p, 0, size);
 	c->collapse("Collapse multiple fully populated PTE table", p, nr_hpages,
@@ -1074,7 +1138,7 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
 
 	/* Let khugepaged collapse and leave pmd cleared */
 	if (wait_for_scan("Collapse and leave PMD cleared", p, nr_hpages,
-			  ops)) {
+			  hpage_pmd_order, ops)) {
 		fail("Timeout");
 		return;
 	}
@@ -1089,7 +1153,7 @@ static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
 	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
-	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
+	fprintf(stderr, "\t<context>\t: [all|khugepaged|mthp_khugepaged|madvise]\n");
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
@@ -1100,6 +1164,7 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-h: This help message.\n");
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
+	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
 	exit(1);
 }
 
@@ -1109,11 +1174,14 @@ static void parse_test_type(int argc, char **argv)
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
@@ -1139,6 +1207,10 @@ static void parse_test_type(int argc, char **argv)
 		madvise_context =  &__madvise_context;
 	} else if (!strcmp(token, "khugepaged")) {
 		khugepaged_context =  &__khugepaged_context;
+	} else if (!strcmp(token, "mthp_khugepaged")) {
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
+		if (collapse_order == 0 || collapse_order >= hpage_pmd_order)
+			usage();
 	} else if (!strcmp(token, "madvise")) {
 		madvise_context =  &__madvise_context;
 	} else {
@@ -1173,7 +1245,6 @@ static void parse_test_type(int argc, char **argv)
 
 int main(int argc, char **argv)
 {
-	int hpage_pmd_order;
 	struct thp_settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
@@ -1199,10 +1270,6 @@ int main(int argc, char **argv)
 		return KSFT_SKIP;
 	}
 
-	parse_test_type(argc, argv);
-
-	setbuf(stdout, NULL);
-
 	page_size = getpagesize();
 	hpage_pmd_size = read_pmd_pagesize();
 	if (!hpage_pmd_size) {
@@ -1212,6 +1279,10 @@ int main(int argc, char **argv)
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
+	parse_test_type(argc, argv);
+
+	setbuf(stdout, NULL);
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
@@ -1236,11 +1307,14 @@ int main(int argc, char **argv)
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, file_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
+	TEST(collapse_full, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_full, mthp_khugepaged_context, shmem_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, file_ops);
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
+	TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 75b94fdc915f..12d2a4f28ab5 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -496,6 +496,10 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
+CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
+
+CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:shmem
+
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 # Try to create XFS if not provided
-- 
2.43.5


