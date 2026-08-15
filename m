Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA70C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA6F6B0769; Fri, 14 Aug 2026 21:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181E86B076B; Fri, 14 Aug 2026 21:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0703B6B076C; Fri, 14 Aug 2026 21:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 997DC6B0769
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 108B91602A4
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:42 +0000 (UTC)
X-FDA: 85101847404.16.68C440A
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf18.hostedemail.com (Postfix) with ESMTP id 143A81C0002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="D 3mtboi";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=NsrmYP7W;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JK5GVI6pI2lxoa84VhaQKI3w4xKylzP6fAx1cS2WfAU=;
	b=R+II3gU457N4YNFFKxrzWakYdwNu6HXJRWt/22x8rsTJ93ENESsbz3pmEVpEXPWHVs+yS5
	QTKqMCzhq4FgZgrBfivmlAEiZ/dqQCc5HU7ObU86vToAYIV852NdmeMyHIlCXvqZJ5dLs0
	+GH4uMsH78ZDN+Mgs4tefjwJsEDrJ90=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="D 3mtboi";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=NsrmYP7W;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759180;
	b=OP7jXZVv06PgM++FfTp1oMDQ3kCSc43Hlynh1ll1nuF86zerIeZVGTnHpCrADDDDN4CQbH
	fgGgX2NQgiw4LcUoxmuV8VWTR6rc1D9VkFNeBMGimFM27M9EOTGT9Ln8EE9UDBOLorHIMP
	Ozfu6fBCDfGjs/VEVL8f/EqjkQfiwZc=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id A420CEC0238;
	Fri, 14 Aug 2026 21:59:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 14 Aug 2026 21:59:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759179; x=
	1786845579; bh=JK5GVI6pI2lxoa84VhaQKI3w4xKylzP6fAx1cS2WfAU=; b=D
	3mtboiFR8kAyvDL6O4AAcA0NezFYPVsOBnyzr59jVjz0lHrw/n7/MXZAkjs4b620
	+036gY92utRhm5FoKr3ImhrTHrMvMa0uDnoe/umnyg1yirU+b7UuqD0xYXIVzRZ8
	Y8k20gVLeor+svnZLALZeyznV9gJCUo2ztgxE+TnYPRAZg0xzEroHJz/4wTBDmEZ
	F32gFOJbzh5RUAijasgnvSBy475Wysl/HVM99AkmJnHev3rra1H5YOS8W+sclsuk
	ER0opUBTumB5T0E9epZUNA/ZYNx9eQjRAqbelVEjljcWyJW41Nx7lW5qbUI1xasV
	MidifAiUitaU+Q3KHc65w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759179; x=1786845579; bh=J
	K5GVI6pI2lxoa84VhaQKI3w4xKylzP6fAx1cS2WfAU=; b=NsrmYP7WnbCsDiaKE
	+BtqmC4eB9oen/ucBplSll7oiH2kHU40wlRIPQoFg94/hKjh2lyiSzRTOp8JvSCq
	JF5337sawFgeLeUC2kRsX2kCG/LeJznHCf2C3k7q/g1fgzy17StdLNjewE5Qrc87
	Yqi5h3mmE+Z4Q0lca9w4fFyHkx/s8k4QoSRDLeTa29D7c/TDRajBIelQ1ILe1TQC
	IIKzxmX8pBMfYjU/Lx1eY32JZ6zCEXr0lEHZfV/n4YkROXIFeNdv41lLGcLavduJ
	++bJ+8HVPZg014EKnk8pcmgQFh2mi2DYEOzGa2FZnpYQgk6Rr1XrytpDg4BzxlDg
	b9OWw==
X-ME-Sender: <xms:C8h_au_OQjBsh7-FIdh74mIiJewAFPyYGwA5-AdIu23kpgytGxV4WQ>
    <xme:C8h_aiod22ZXQXDOjHDrXICf5O6KkvTNbXQPRID4bQ3sBB0RrsPh-Yxy4Ozm1z2cb
    rBs3DuWyRBwDZas8oGX0w6qMVolGZd1isbmbJPakedDayRwUTqCalo>
X-ME-Received: <xmr:C8h_ashm9D6zhY8SxJ5egxGeIS6i3u-bw42VPbO317xNgUxRtbp4WJTAxs0>
X-ME-Proxy-Cause: dmFkZTFzGpGFm5W4vTTPFWblEwVteikp8ZQmNhgJQ39PW7T7XQcfx50sk9SsorwQ5kiHE1
    GkGyp58aXi1XV7w9FWqCEkAAXyywQWDaCYDP4jk79Tj+fneRM/f70WhpHyk68ivSHa8CNO
    EHCv/WuNeVKTxC+1Am5pTEbXGz94MYKYsyM7kpGX5dHsQKSWoIOFoaOZhong5pPq1D5dt9
    kZJFmHpp6Lnk5BJwnqgflVky13nVISEGlBe9NK3zcAVq5kZlGc2PqnLHdjdexqJ0GH5I+D
    CyEe7NNeMVRnhwRmAQGYSBBJ6RBvmXxfczeNb/t4Esr0tR7Igh8W/aIlPiSt8FyWTQd+TG
    GnssYIczN2LI/Xz94YDefGLowoNoiM6pqpAUodaYbR6hi2S4OnC2iEHjxeNfrDS9HJXd2f
    6IXWtuE6XJrzJTWNEAJgdYW2s+C51dwE/YnPLYE+HrvL5uB09u1QbSTWUynuv92A4cmqT1
    uMUJOkGjlyorBDYinuQkYUiV5ws9EBM9YxluzUjsCJN7p1yORebiDQdoM8urJIm7L2qpIl
    +k9nX7OtbQij9IAgZW1EW6gDbm9nndabfK8vO5jsdbZ82g1CKkd8Wj8huKmCfXIRb32UZV
    aE5H1qmmSf9V/qWZ3bw3wrXcKyUhCHDA11D0RzeVcbH74bO9xK+ZkznWeKog
X-ME-Proxy: <xmx:C8h_agCEowTTdGnINcVkniOzPBgPbaocYPXr_TyJi-EwEGxt2JWZ5g>
    <xmx:C8h_aquG_2CP1HCFRHBuPZ8ZEW0Uqmp-cOfRzN-f6X4wbb5EKv5oxg>
    <xmx:C8h_aq4Kt06t-My11772voNi3nXnrC9Csc3tKPrEfCINF2irCCkGfA>
    <xmx:C8h_akcG4QPTKYQh8Un8YoXihnV7tQ7V_6HHl1ih4Mc6GmWZUpQfhA>
    <xmx:C8h_ajeMFZzkYFuuwgcfy1GUiHsLOZ2BYSsu1U65Oc2D3lnOmPvc7V6B>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:39 -0400 (EDT)
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
Subject: [PATCH v4 18/19] selftests/mm: add memory-pressure threads to the khugepaged race harness
Date: Sat, 15 Aug 2026 02:59:00 +0100
Message-ID: <20260815015901.1236937-19-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 143A81C0002
X-Stat-Signature: fuob6b59hm37wf6r5iz1s1w8wg15necg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786759179-427336
X-HE-Meta: U2FsdGVkX18Az6c/Cg2UYQJNN4+HFr6mhc1EIgK/nibZlGG0RVp/zr7A+0NaWqd25QMG1fj5hgNkaMVSSUdatNNVzrd99dDZe3bVVW3N2Rln0pre6luaFJJdGF4Ge44eHf/r9sY2Tg7TzLqfPTYpegMM9GaZKhh/45tclsQWX1j7FZlUFb5zmWWd508WIsOfLtbJzNAkwRc5asaNmgXGlRQmFR8LOtK4I5VNWUtk2dgU2TECDcZSyPlUcQTDOpITnXjudU6tnTILmCtAsDcBnaXCkVQzWFyq5uZ0yPPRHPpboq6+E+ZTBtS7iy1gDGKSsEFEzmbjs52CU23sgiY6tG8v1D6ReMP3e573F1Z1VAPRTtlK6wEh6/TDl/7pWEpwaE5kIn+2GSPmZdDf+ucemHRZyJcMcdbgpMO18xUiPS9QFM9PFGaIFXRUaPCDcjN7w7ZHplC81hAzhQmPfpsmjus/i9MXeZDFPllsxBUxYK28A6jEIDJm5O7EBqO8d9gLSmamL43gIMb5uqQkY4bFUbI050gHbJMUAnkBYd8FIq/SYQFKNIyMduD4hHQXS3rubn0D77nmYgzvyn2EPxm+wXRYAibNtaUYi8+OPa/MLaKDlSCec7vXhonH6GEz8heMnlN49bnvg1gOf2AHjIUs0G+e4tR05BzTVhygLnVia1Y6Qnlaa3lgHI5UCt9JyiYvX1HzEUfwe6RWKUF8ay+IbvuMkD1/TgLfekrk7NzE8rG6ec9aS6z/ugMXIdx+IoS6tXkbnSoiEIYy/k/BBHu2cqOKF8dk+2an8IbQBkpbKMINaWQQca7JhTwA5WjjUiShoO7PD/4PA7DkMuh2v4s3PP+e210qnoVEP2DL2f+blIen9wvjwALYnpbrHKyj2hNs05uhhe1wH50LCGqfh6bah614XJVFjk+2elZamX3yGk90qHX8boxl1LhlxZQ/Bql7JaJmiVF+lf1fDc4k4n4
 bG97bP2k
 zXIBT9B7jYBsk6uf14HPSlTDFaE7RKxewYSjvm14V8wENhBKq4ULBb9JD9JtB1jN8/yLWoJHG6Le2ERJRzI8qljHo8+55Tow/qgaBgS+E4LsLXGaxQ3TI2B+4M5eB/lTQW//jS7icNQPHZ/7a4/pq2WACF/Jh0LGtGGP+KszXhc+apBR1Ph2aKZeFcx1jRssyK++C68TTEaf1MCpFf8DQg6a1/YReYQSqNG5yweCAJZJQk4OezbWwgwlNnntQeebBbQNnltg9kGadotgfrRfTfN7cqu5SWR54+Qg/qVs0T/8Z/hbwj5yuc3AAH50Wqj17q5NthL1nlS5MwemCZT6w2IFWNTskisIPx70xwzTm47K0WPB1VrnbWFFSPu7Lrbpm8vUka+/dVdqkyup9r+m61U0kz8voznZejasuS4GH3VnpkztRzEZnrILffUnvuy87RnbeZ4HII0RotCwrjWG9/Z8Ic9oHINDbTLGNf3kOKF2+54SppUCDrrFjYuvDGuVVAdQO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness races collapse against faults, pins, fork, mremap and
MADV_DONTNEED, but nothing in it elevates a source folio's refcount from
the reclaim or compaction side.

Add two more threads, and run every mode and occupancy limit both with and
without them:

 - pageout: cycles MADV_PAGEOUT over a dedicated neighbour region, faults
   it back in and checks the content each round, since a page's pattern
   must survive the trip through swap.  Left out when the host has no
   swap, because then there is no anon reclaim to drive.

 - compactor: writes /proc/sys/vm/compact_memory in a loop.  Compaction
   isolates and migrates folios, so it competes with a collapse for the
   pages it is gathering, with refcount elevations and migration entries
   of its own.

Each result says whether it ran under pressure:

  ok 2 stepped/strict/pressure: 5s, 88 steps, no corruption

A full run is now twelve combinations; -m and -d narrow it.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 144 +++++++++++++++++--
 1 file changed, 132 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 3b369046edf5..a23e5bfe78af 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -17,6 +17,12 @@
  * collapses too.  A hole is zero-filled into the new folio rather than
  * copied, and the racing MADV_DONTNEED keeps moving which slots are holes.
  *
+ * Every combination also runs under memory pressure: MADV_PAGEOUT cycling
+ * on a dedicated neighbour region (swap traffic and LRU churn; left out
+ * with a note when the host has no swap) and a compact_memory trigger
+ * loop (compaction migrates source folios, racing collapse's freeze
+ * with refcount elevation and migration entries of its own).
+ *
  * Correctness signals: every racing page must read as its pattern or
  * zero (MADV_DONTNEED), never anything else.  The faulters and the fork
  * children check that continuously, a final sweep checks it once more, plus
@@ -60,6 +66,8 @@ static unsigned long page_size;
 static char *region;		/* NR_AREAS * hpage_pmd_size */
 static char *mremap_area;	/* region + NR_SHARED_AREAS areas */
 static char *mremap_scratch;	/* well above the region */
+static char *pageout_area;	/* dedicated pressure region */
+static size_t pageout_size;
 static int gup_fd = -1;
 static volatile int stop;
 static volatile int corrupted;
@@ -218,6 +226,70 @@ static void *mremapper_fn(void *arg)
 	return NULL;
 }
 
+/*
+ * Swap traffic and LRU churn on a region of our own. The content
+ * check is exact: a page out and back through swap must preserve the
+ * pattern, and nothing else ever writes here.
+ */
+static void *pageout_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+	unsigned long nr = pageout_size / page_size;
+	unsigned long i;
+
+	for (i = 0; i < nr; i++)
+		*(unsigned int *)(pageout_area + i * page_size) = pattern(i);
+
+	while (!stop) {
+		madvise(pageout_area, pageout_size, MADV_PAGEOUT);
+		for (i = 0; i < nr && !stop; i++) {
+			unsigned int val = *(unsigned int *)(pageout_area +
+							     i * page_size);
+
+			if (val != pattern(i)) {
+				corrupted = 1;
+				ksft_print_msg("Pageout corruption at page %lu: %#x != %#x\n",
+					       i, val, pattern(i));
+			}
+		}
+		usleep(rand_r(&seed) % 2000);
+	}
+	return NULL;
+}
+
+/* Compaction migrates the collapse sources out from under us. */
+static void *compactor_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+	int fd = open("/proc/sys/vm/compact_memory", O_WRONLY);
+
+	if (fd < 0) {
+		ksft_print_msg("No compact_memory; compactor idle\n");
+		return NULL;
+	}
+	while (!stop) {
+		if (write(fd, "1", 1) < 0)
+			break;
+		usleep(10000 + rand_r(&seed) % 100000);
+	}
+	close(fd);
+	return NULL;
+}
+
+static bool swap_available(void)
+{
+	char line[256];
+	int lines = 0;
+	FILE *fp = fopen("/proc/swaps", "r");
+
+	if (!fp)
+		return false;
+	while (fgets(line, sizeof(line), fp))
+		lines++;
+	fclose(fp);
+	return lines > 1;
+}
+
 static unsigned long now_ms(void)
 {
 	struct timeval tv;
@@ -240,17 +312,23 @@ int main(int argc, char **argv)
 {
 	static const char * const thread_names[] = {
 		"faulter", "faulter2", "dontneed", "pinner", "forker",
-		"mremapper",
+		"mremapper", "pageout", "compactor",
 	};
 	void *(*const thread_fns[])(void *) = {
 		faulter_fn, faulter_fn, dontneed_fn, pinner_fn, forker_fn,
-		mremapper_fn,
+		mremapper_fn, pageout_fn, compactor_fn,
 	};
+	enum { T_FAULTER, T_FAULTER2, T_DONTNEED, T_PINNER, T_FORKER,
+	       T_MREMAPPER, T_PAGEOUT, T_COMPACTOR };
+	const unsigned long pageout_bit = 1UL << T_PAGEOUT;
+	const unsigned long compactor_bit = 1UL << T_COMPACTOR;
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	static const char * const all_modes[] = { "stepped", "free", "madvise" };
 	static const bool occupancies[] = { false, true };	/* strict, holes */
+	static const bool pressures[] = { false, true };	/* quiet, under pressure */
 	const int nr_occupancies = ARRAY_SIZE(occupancies);
+	const int nr_pressures = ARRAY_SIZE(pressures);
 	const char *one_mode[1];
 	const char * const *modes = all_modes;
 	int nr_modes = ARRAY_SIZE(all_modes);
@@ -259,6 +337,7 @@ int main(int argc, char **argv)
 	unsigned long end_ms;
 	int duration_s = 5;
 	unsigned long thread_mask = ~0UL;
+	unsigned long base_mask;
 	int nr_areas_arg = 0;
 	unsigned long i;
 	int steps = 0;
@@ -323,7 +402,12 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes * nr_occupancies);
+	base_mask = thread_mask;
+	if (!swap_available())
+		/* No swap, no anon reclaim: compaction-only pressure. */
+		ksft_print_msg("no swap: the pageout thread stays idle\n");
+
+	ksft_set_plan(nr_modes * nr_occupancies * nr_pressures);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -335,9 +419,17 @@ int main(int argc, char **argv)
 	 */
 	thp_push_settings(&settings);
 
-	for (int mn = 0; mn < nr_modes * nr_occupancies; mn++) {
-		const char *mode = modes[mn / nr_occupancies];
-		bool holes = occupancies[mn % nr_occupancies];
+	for (int run = 0; run < nr_modes * nr_occupancies * nr_pressures; run++) {
+		int rem = run % (nr_occupancies * nr_pressures);
+		const char *mode = modes[run / (nr_occupancies * nr_pressures)];
+		bool holes = occupancies[rem / nr_pressures];
+		bool pressure = pressures[rem % nr_pressures];
+
+		thread_mask = base_mask;
+		if (!pressure)
+			thread_mask &= ~(pageout_bit | compactor_bit);
+		else if (!swap_available())
+			thread_mask &= ~pageout_bit;
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -373,6 +465,24 @@ int main(int argc, char **argv)
 			ksft_exit_fail_perror("mmap() playground");
 		mremap_area = region + nr_shared_areas * hpage_pmd_size;
 
+		if (thread_mask & pageout_bit) {
+			/*
+			 * Big enough to cycle real reclaim, small enough not
+			 * to dominate a TCG guest: 4 PMD areas, clamped to
+			 * [16M, 64M].
+			 */
+			pageout_size = 4 * hpage_pmd_size;
+			if (pageout_size < 16UL << 20)
+				pageout_size = 16UL << 20;
+			if (pageout_size > 64UL << 20)
+				pageout_size = 64UL << 20;
+			pageout_area = mmap(NULL, pageout_size,
+					    PROT_READ | PROT_WRITE,
+					    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+			if (pageout_area == MAP_FAILED)
+				ksft_exit_fail_perror("mmap() pageout area");
+		}
+
 		/* Populate so the first pass has something to collapse. */
 		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
 			*(unsigned int *)(region + i * page_size) = pattern(i);
@@ -423,8 +533,9 @@ int main(int argc, char **argv)
 			check_page(i);
 
 		ksft_test_result(!corrupted,
-				 "%s/%s: %ds, %d steps, no corruption\n",
+				 "%s/%s%s: %ds, %d steps, no corruption\n",
 				 mode, holes ? "holes" : "strict",
+				 pressure ? "/pressure" : "",
 				 duration_s, steps);
 
 		/*
@@ -433,17 +544,26 @@ int main(int argc, char **argv)
 		 * and its scan cadence differs.
 		 */
 		munmap(region, nr_areas * hpage_pmd_size);
+		if (pageout_area) {
+			munmap(pageout_area, pageout_size);
+			pageout_area = NULL;
+		}
 		thp_pop_settings();
 		stop = 0;
 		steps = 0;
 
 		if (corrupted) {
 			/* Memory is suspect; the rest would prove nothing. */
-			while (++mn < nr_modes * nr_occupancies)
-				ksft_test_result_skip("%s/%s: skipped after corruption\n",
-						      modes[mn / nr_occupancies],
-						      occupancies[mn % nr_occupancies] ?
-						      "holes" : "strict");
+			while (++run < nr_modes * nr_occupancies * nr_pressures) {
+				rem = run % (nr_occupancies * nr_pressures);
+
+				ksft_test_result_skip("%s/%s%s: skipped after corruption\n",
+						      modes[run / (nr_occupancies * nr_pressures)],
+						      occupancies[rem / nr_pressures] ?
+						      "holes" : "strict",
+						      pressures[rem % nr_pressures] ?
+						      "/pressure" : "");
+			}
 			break;
 		}
 	}
-- 
2.54.0


