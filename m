Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C41E5C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A61B6B014D; Wed, 12 Aug 2026 09:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D906B014F; Wed, 12 Aug 2026 09:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56CD36B0150; Wed, 12 Aug 2026 09:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33F916B014D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDAB8A28C1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:53 +0000 (UTC)
X-FDA: 85092685146.05.F35466F
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF600A000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="S 9H1VZR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WtsbVfUF;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymEJqkwUinB+T+KKBklAPXcC2k5sBcIeWFiKz2tJ1JM=;
	b=KP1JEowc2Mcftqcvrw1Fh8SxU97+QCSC6Ew7/CsAbd58TGGiiJPOrpI675PwlDcH0+iJdm
	NBMI0aB4P073UFtZDq02oqhpwGI7Pj+dAskz0mOC/wSCQZfCYbARn9IBHiNsx5neUHDEUw
	Q0WVVAWbOBxfLLl/LQrTkhsmayeibc0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="S 9H1VZR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WtsbVfUF;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541031;
	b=oPCtApS4zIbgHNG3i63/qvRhg6lX5FYlm0P12bUDsbaIt8czc/JIvVAhh/Gr0osEi+q3zG
	GVSVkPaQJcR4tVA9c+Y0VBS7I5ALqxQl+3JhE+HXtA5CMK09xSOv7yfJaeK2OwDgj2HEji
	siYx+EWgqVd0Y1Wo7KNkJHfyF+5IdFY=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id ACA201D0016F;
	Wed, 12 Aug 2026 09:23:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 12 Aug 2026 09:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541030; x=
	1786627430; bh=ymEJqkwUinB+T+KKBklAPXcC2k5sBcIeWFiKz2tJ1JM=; b=S
	9H1VZRqLFa3pXg6pF3HLc29eLjfAHk3GKk60lm5wFJqrDUCvvedrIFbZ59UPmLae
	87oOL5Vf9c8+IbyITmpBQPTfLW14RFaqI9HPcWrNwsbm6DcWd4iZNk3BOdl3ugr7
	G89EertJStnBDXm5fmGDfzahPV5aBuV5wT9+KD2MoMGtT85rJpoptRp5DP+Fsbvt
	/SslAXJdk4AZgSOJ39X1Nzmn5I3xMaOv8B56uU4ikUSx3SRM3f3fa4tdaYdN1X2s
	/Y7VhaSM1n0g8JYjLZgTxKmNPrf0kNUYJzsnbgBm82ZBYpBss3UD1FaDlLDj88LX
	Pqd+hcwQU8Qg+5UVeXO6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541030; x=1786627430; bh=y
	mEJqkwUinB+T+KKBklAPXcC2k5sBcIeWFiKz2tJ1JM=; b=WtsbVfUFoSwajttct
	pMFE3KBG6bt45uwtQsVtE8TBordu7tf5RXfr/pm4YBBrJfNLtXha71jlu2/Kt1Y5
	2zAY0V+fkQtp2A3CG715rykCYdvnOPLG8fd98Q4lxnvZv2bXU4pkx6VB+gY/BvVy
	x3FqBjeZrL1VsdLsHK34vReQk6vkGPniZ5u6CktJabhN889JdpUSZNg68AEnKnIB
	zIDvI/XzBo7fOYWXiac9HvOsLFl42TgUKdxH9Y22iJBcL1y0X0gM6ib2yoJY018J
	y9PU+W+GlQ6XkIeclt2b9w9NXrZCsUztWc735CII5X3YZyENbHBIRrWpSO2Cfobp
	YouTw==
X-ME-Sender: <xms:5nN8atUuLO1H4E0CWcuTn9L4CYatV-0iM1xtHtv6tB7EYWoo3rz9yw>
    <xme:5nN8ahiWaV5dyRPJs7y9PlfaaJK_jPu_SLZp05dprk-pk38W8bOk2_bXC6F6jGfP2
    Ia0WuHF3p4VGclDwk_cxcJ0nU5vfAVXZrM3AgyKRBNUf_cdkQxGK8k>
X-ME-Received: <xmr:5nN8ah64q4YvujTup5sQBJZbk-HHxbL9YBcH2BABL1fASXHMBcv-fYFIARE>
X-ME-Proxy-Cause: dmFkZTGK88F9UMnXZ5YHCfZ+3CEyhDPNn2cwpG7gczg1QtUW3+KH6lRiOTrWgwtmC8SwM8
    lS9N2AAOkbX57R9oIGEGX/Y22a2ZgCAGYteUW+bA41LZ08JSUTSnxLP4aLeGJ+l2igRpiI
    z056Op0LI1NxVlka48nXFKSS8a/uwNZK+39708VFH13YHS1sNHrX5zvuU5299hb11Ao5H/
    zQrZEfdZM4G7c0rNyXZ30syjB6Y8P8LTAhLTAHwdc8i3T8CZWzvPOusg5fBb0jumhRSeE4
    e5clat+a+U2DXBe0wlr1aBcOwBQzkKo/UFV6TzMBSg5j9cF+ay7ufreZHSHrXPVD1XvoiK
    0gdJKI8U7fbIGj0HZXI1c4pGX6rHFYyG2kcmUon0bnMEum6bTcKdn+AS3ZN6sQ9l8HpyGR
    Jhf86xrJtorxgBIdnEOe8djhD4Akbuh/xMBZMkPCnoqkfkdePxuB66oPTKp9nmhn19rafD
    teQichvbgkO21ko9xW+rsH+2LOyLHer3IyunhZ+cNF72Q4tlbZciZOu9NCGFXA7jKAMPiF
    G88p6TycyVjRW11TsMM8hRfdyIYSNw/Sb5Lpcs9wgmcoi/OmzTDrV+D/6li9grvIytJpXJ
    8saFUo2wylxtQeciGVI7lp33+rMUZ0kMCXnkkjS5RDMGLx+T+ptToq8ZTwnQ
X-ME-Proxy: <xmx:5nN8ap5pDNCtXFe3xqg83rZ2X37wPJi0Yhz-nGSTZVHDox0USIfbOQ>
    <xmx:5nN8avE-neznTsCFN72jLIuv1tP8Jt_VRPXca40gZwWg-lj6iwwkfA>
    <xmx:5nN8anxk9QjJNwIrX9cUukk2It31lTiurm_RB8KnrD3TDgoMu5Keug>
    <xmx:5nN8av1WBMOhHg7M3PijPkXsCpx03vw45pFXhM3WCHMC0MjTpaW0Bw>
    <xmx:5nN8an1mv7KqXmWjN_HiNtX3i02LWkBQ9ABNIYgV7M8kmyI9mo5T941G>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:49 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v3 16/18] selftests/mm: race collapse of windows with holes
Date: Wed, 12 Aug 2026 14:23:02 +0100
Message-ID: <20260812132304.199287-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF600A000B
X-Stat-Signature: xb1bmzr6otifuyz31ccpadunz9mctpui
X-Rspam-User: 
X-HE-Tag: 1786541031-704520
X-HE-Meta: U2FsdGVkX18PwXkw7jRfklRs+RkchfaKM4jHPYwsAxKIUH1jHzozcz1CexMnEGy9Jptk37c18iYmaRIkk63llXR2HjXArRH4isB3JWKhuPtD+YwbhdNg5fVf4Rsw6ZHVxq2A1xcFTIWs6Z+qlH1NWKIhbuHYG9hzVpdbpKQwSTJhphgf8KoCJYOXkeRNgR5FPgOJnlszhlE3PLZNMZd70ZnZuW3/ZcdakwF9+gA8qVfwDE/QjY1ff0J1HJv492vkqlqFwhxxR3i+C9vkvHcI/GdmmkuvLiwIF7UGA5tRAvIeXLIArs39mYD/hcbqi9Tc5U4+tT75getri+ybMarzyYk6aQsa24qcpgTyfHcQxqH+M88uUN/bV0+tRNMjTImVri+cTpAInyXoAxGbxqBY+UNdSkPpgPg1PcbWFvb9bICMm9YGlKNQGBK8A+4BGUSvUq57OwTI8n4cDl8OaYSFDKbwJ4h/VgPv8hXtBTD3J6yYn9Gmi9khvvNc+a6g73lxQum5mo2wgRzLJWJ3SB47t4jvpCtRXndyrYawuVQxe5hckEpQpg7o0ijp5fNy/lrn32iZ19nu1AGv51MV4qNxH3AQGF9Rr1G1fOZTgy9K/z0Dnz0Ih2sb0KlJcWkTlwSPJNlOzf0YGqX7GSj78cq/qPFr2IrrFKLSxF1GHugKztJE2ewgIr0fLEkvlvWW4PJAXpcpQpRExJ1sg11MlfIcoQcAf1ZlooWalMaGRWy8WGO1hctetnAukQbOiSQar1d5AJ5J/LgDwgGFFOlFauxR7lSDZBcsFGCTYDaagmbfhBULgEOnmtEqIp1tLBP45ryRSTEbz5Lqgw8mzWcUGCqJeJScm1XEo4o4EDnvBzBaN8pEDbN05tkGH0u3VVqxvkUTy5lRJvcMlKHOVG4pbOYkj9C+fiahWnnLVC6B96AUnrfGxYIJhOthVb1DfUPehT3n1q6VuSGu5WsrWlys8y9
 uEcvQgmt
 dQZ6ZewNs7t/Mk4DWlarMN4M99oEkw21x/lye/R9ROztQZpN6+P7sDKiGTeror+bgz+4xeT+nGetqmHyBaSFGJndIXa6QShARTf3mOfucighESMy4XTLYDF5sLXuPuMVH6esqRv/O2JtQPgpz/sD807F4ss6lpc0PCr8VwGcOt3ZLaF3fV5YQIWUrqIrWnfotOeiIdehlZA26DGAFhjzOOYAtLEeZNSXbQAZWyMo8kdb96ENkWf6SxQul48TxRY/LKZHQLG+WnzsxP7huG8a1ckeOR5UxZPiKiYEsbbDOoixPpSmXdjCLVC92rTDbNW9pf50kFIROdFZskUJsncQ3TYoqnhcYe4vHAeXMLw3P0Cmw3tvEoxVTJoxWAxDqS1K0ZhjOp/wb84YvmJ37SuyKA/1Xpms7ISSOjNOxBHPMBXkLVgfegvFtLGqfGJDEeQWERVNGNuqz5d6u5525qOMAFu/1nOh2VncO/QPcBzjJFuN3m6gaifS4P2OeiQu2SSZsxcki
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness pins max_ptes_none to 0, so khugepaged only collapses a window
once every PTE in it is present.  Collapsing a window that has holes never
happens, and that is a different path: a hole is not copied from anywhere
but zero-filled into the new folio, and the slot is re-checked under the
page table lock at install time in case a racing fault filled it first.

Run both ends of the occupancy scale, one after the other, for every
driver mode -- mTHP collapse supports only those two, 0 and
HPAGE_PMD_NR - 1, and coerces anything between them to 0.  Each result
says which end it ran:

  ok 1 stepped/strict: 5s, 231 steps, no corruption
  ok 2 stepped/holes: 5s, 194 steps, no corruption

-z narrows a run to the hole-heavy end, the way -m narrows it to one mode.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 61 ++++++++++++++------
 1 file changed, 42 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index d9e421ede6de..ba4f5c36bf88 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -11,9 +11,12 @@
  *   free	khugepaged left to run (scan_sleep_millisecs=0), for soak;
  *   madvise	MADV_COLLAPSE in a loop.
  *
- * All anon THP orders are enabled (inherit) and max_ptes_none is 0, so a
- * window has to be fully populated before khugepaged will collapse it, and
- * the racing MADV_DONTNEED decides which orders it can still use.
+ * All anon THP orders are enabled (inherit).  Occupancy runs at both ends
+ * of what mTHP collapse supports: max_ptes_none 0, where a window must be
+ * fully populated, and HPAGE_PMD_NR - 1, where a window full of holes
+ * collapses too.  The holes are not copied from anywhere -- they are
+ * zero-filled, and re-checked under the page table lock at install time in
+ * case a racing fault got there first.
  *
  * Correctness signals: every racing page must read as its pattern or
  * zero (MADV_DONTNEED), never anything else.  The faulters and the fork
@@ -227,9 +230,11 @@ static unsigned long now_ms(void)
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-a areas]\n"
+		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-z] [-a areas]\n"
 		"\tWithout -m, every mode runs in turn.\n"
 		"\t-d: seconds per mode (default 5)\n"
+		"\tBoth occupancy limits run unless -z asks for holes only.\n"
+		"\t-z: only max_ptes_none = HPAGE_PMD_NR - 1 (hole-heavy)\n"
 		"\t-a: number of shared PMD-sized playground areas (default 3)\n");
 	exit(1);
 }
@@ -247,6 +252,9 @@ int main(int argc, char **argv)
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	static const char * const all_modes[] = { "stepped", "free", "madvise" };
+	static const int all_nones[] = { 0, 1 };	/* strict, holes */
+	const int *nones = all_nones;
+	int nr_nones = ARRAY_SIZE(all_nones);
 	const char *one_mode[1];
 	const char * const *modes = all_modes;
 	int nr_modes = ARRAY_SIZE(all_modes);
@@ -256,11 +264,12 @@ int main(int argc, char **argv)
 	int duration_s = 5;
 	unsigned long thread_mask = ~0UL;
 	int nr_areas_arg = 0;
+	bool holes_only = false;
 	unsigned long i;
 	int steps = 0;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "a:d:m:t:h")) != -1) {
+	while ((opt = getopt(argc, argv, "a:d:m:t:zh")) != -1) {
 		switch (opt) {
 		case 'a':
 			nr_areas_arg = atoi(optarg);
@@ -275,10 +284,18 @@ int main(int argc, char **argv)
 			/* debug: bitmask of racing threads to start */
 			thread_mask = strtoul(optarg, NULL, 0);
 			break;
+		case 'z':
+			holes_only = true;
+			break;
 		default:
 			usage();
 		}
 	}
+	if (holes_only) {
+		nones = all_nones + 1;
+		nr_nones = 1;
+	}
+
 	if (mode_arg) {
 		if (strcmp(mode_arg, "stepped") && strcmp(mode_arg, "free") &&
 		    strcmp(mode_arg, "madvise"))
@@ -318,7 +335,7 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes);
+	ksft_set_plan(nr_modes * nr_nones);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -330,8 +347,9 @@ int main(int argc, char **argv)
 	 */
 	thp_push_settings(&settings);
 
-	for (int m = 0; m < nr_modes; m++) {
-		const char *mode = modes[m];
+	for (int mn = 0; mn < nr_modes * nr_nones; mn++) {
+		const char *mode = modes[mn / nr_nones];
+		bool holes = nones[mn % nr_nones];
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -341,14 +359,16 @@ int main(int argc, char **argv)
 		settings.khugepaged.scan_sleep_millisecs =
 			strcmp(mode, "free") ? 1000 : 0;
 		settings.khugepaged.alloc_sleep_millisecs = 10;
+
 		/*
-		 * Strict occupancy: mTHP collapse only supports 0 or
-		 * HPAGE_PMD_NR - 1 and coerces anything else to 0 anyway, and 0
-		 * also keeps khugepaged from burning the whole step in doomed
-		 * PMD-sized allocations on 512M-PMD configs: under racing
-		 * MADV_DONTNEED a fully populated PMD area is rare.
+		 * mTHP collapse only supports the two ends of the occupancy
+		 * scale: 0 or HPAGE_PMD_NR - 1 (anything else coerces to 0).
+		 * Strict needs a fully populated window, which is rare under
+		 * racing MADV_DONTNEED; hole-heavy windows collapse instead,
+		 * so the two ends race different paths.
 		 */
-		settings.khugepaged.max_ptes_none = 0;
+		settings.khugepaged.max_ptes_none = holes ?
+			(hpage_pmd_size / page_size) - 1 : 0;
 		settings.khugepaged.pages_to_scan =
 			nr_areas * (hpage_pmd_size / page_size) * 8;
 		for (i = 0; i < NR_ORDERS; i++) {
@@ -414,8 +434,9 @@ int main(int argc, char **argv)
 			check_page(i);
 
 		ksft_test_result(!corrupted,
-				 "%s: %ds, %d steps, no corruption\n",
-				 mode, duration_s, steps);
+				 "%s/%s: %ds, %d steps, no corruption\n",
+				 mode, holes ? "holes" : "strict",
+				 duration_s, steps);
 
 		/*
 		 * Hand the address space and the settings back before the
@@ -429,9 +450,11 @@ int main(int argc, char **argv)
 
 		if (corrupted) {
 			/* Memory is suspect; the rest would prove nothing. */
-			while (++m < nr_modes)
-				ksft_test_result_skip("%s: skipped after corruption\n",
-						      modes[m]);
+			while (++mn < nr_modes * nr_nones)
+				ksft_test_result_skip("%s/%s: skipped after corruption\n",
+						      modes[mn / nr_nones],
+						      nones[mn % nr_nones] ?
+						      "holes" : "strict");
 			break;
 		}
 	}
-- 
2.54.0


