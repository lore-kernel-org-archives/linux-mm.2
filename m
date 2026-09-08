Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F52C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887A86B00B1; Tue,  8 Sep 2026 08:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811EB6B00B2; Tue,  8 Sep 2026 08:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68BAE6B00B3; Tue,  8 Sep 2026 08:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C78A6B00B1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D73AE1C277E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:48 +0000 (UTC)
X-FDA: 85190581896.27.417EF9F
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf16.hostedemail.com (Postfix) with ESMTP id F0E00180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="c 9Y3CyA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=AvEJhTm2;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqvacDlN0e2w6egDKHKDWVi4bm/TZ7c4rTBepRvovoM=;
	b=qEvL41pa2uLiHVZ+8cCFRbWICaGbglBk4beZh5EhadsOB0+IyUb4muHDgFsWUFDO75KQ5T
	floDWPQrsizpJz519yjAERcoZd9FqSlAdQSnjWq6UBwIpsHsS5KA0pNOy+fZBHirK/inmS
	7qQDNbM8E8kE1PkFiGZ6U5dRyiTaZy4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="c 9Y3CyA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=AvEJhTm2;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871907;
	b=74ReuQJEukYqW3B9npE+zjDhlBuqqrvX6B84M1XoTWgnvHxEb06gfcroyyMXwJKDYsfIVs
	w4KkmdtA3xiB6NFYj3kW+qPscGnilxnt1BTq1/VrYqw9Ml4oFQaKdfKaZitEdfUAfnuKXm
	gz4TapFOzeAsADjMgyI71xsXw2kBRaA=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 85507140006E;
	Tue,  8 Sep 2026 08:51:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Tue, 08 Sep 2026 08:51:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871906; x=
	1788958306; bh=zqvacDlN0e2w6egDKHKDWVi4bm/TZ7c4rTBepRvovoM=; b=c
	9Y3CyAylZLS5kOC0oNs7ri1UFySi9umg5CeHU2uK4jLDC3R4j+IZN1zrsV/NBAt8
	sjTk/mRcgNuuqqgS3W9rQn4N10sIsGQBElj0moQGUapZiVTgkGykyYgu115RX/xr
	5QwP5ydVtCdBfs5Ui15qQNF7UJ9p5vWxjjvm+t4k3cKrEaB/+7jxaJftFGFnjXkV
	WxdOPuiBUXTHkWmw0mdGThKp/9U+7aF3VS9LeZDv28cvmoxhBnMEJbz1ulLA8/F5
	PpvWwVvH0fnfs/YQUjzbdZ3iyLCD0waj0UKR+bezjMcqTlc/BdrF5+JETf/vtZAg
	ZftisHQhkXHacPhz4smug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871906; x=1788958306; bh=z
	qvacDlN0e2w6egDKHKDWVi4bm/TZ7c4rTBepRvovoM=; b=AvEJhTm2JAnnieYVd
	k4g/vlDtlMCYLYcplvJ2DDpmxYlf/roP7IeJY/p7pFcQrA0E/Ih67pjKsfSbDRzn
	134f0ZGRNwjiV/7kdQNrA+Z3BDP1zhcS8k0ipYnpCxqwFYTVQownIR2/VmzM8tvi
	xK1PTCSK6KtMlh8gk3CbTAD1CXMP/tYRNLMrSWVVWwUoZc7BRNFTwPN/xcHz0PZ1
	DDLB6hg3nz5ghDh5iprLlY2BECTPUbjbfLxvpL8R+/EQnI9lzTsvgsAK9kJD2dg+
	G8Ce+cv6Mi2R3UTAvikJ5yGioGNKhDNoBlQPSlxRLHbg5kdTzZNKvIPj95rjoiJU
	+y89Q==
X-ME-Sender: <xms:4gSgakA8SX-DX-Gfh5uAGwEERc7wnrCDCbCHINZ4qGqWVyxtmuGbOA>
    <xme:4gSgaoZ_FDSS5oHmS-bXzy0agCoqwgtNho_DK7aA5D3OHNrm668qLhw3lRmbbITGw
    alVZVMj4WN3O6Vijua3oqkh3VELoNQvyjlZEUxr-Y_VxE9QyKITWy8k>
X-ME-Received: <xmr:4gSgasvhMkxP_B2HgY__LP7sXQfJQGkCRTFBeYLI3XK-K24bGcK8wfrFO0o>
X-ME-Proxy-Cause: dmFkZTEFE5qoX+UuF24uzYsEDVhBj7K7PVNhp/QrdS9IridywNr6zbUVHRTwEJHEkegH78
    2Q0FzpV7Ffbkv2IdJy+2X+gRr5j/GVU+OmQCyX7TrMKkR+B67hpV4qik2kuPcySyPVfL0N
    fjj0puKIPOVKC53VUKH1AFABHK+HgKXG4fFGTm0bttO6aht4AByKsMi5q5m3My1bWaIsHx
    VvWLDqNEgw9NR009yUV13rBPhKD5hG186SgbvLIVXWjVzTBDRGAi2tS1solDyldiLqdSzW
    Z7lbjekX5xhyyUWYdDppP3CJdHwaOTYUEqdi4pIet3xRU1rw2DJzUGF3Njycnc94ehWzPa
    vyAAOqe73Pl13+klFC5N/QOg1BhsXHpd+vVpfxLPxcnWMqyPAjq9YobTdfsrZ7COd/vDux
    AcdlwHGf6V6gdwGca+kLxFa4//EDlDVxr9FWn7d4CP+XYBPZRFx1Y5HpkUnEMvxYp8jn2v
    VMB2tnByHyvca8cjYMG2uRxTeArPeslgB1YFWCkOBLje8bLCFvxkQ1laerqKTxH5AUQYlh
    ldLdqHSvRU+u4z7McyHtiJwTtFIlJEWKTih1uh/MravE8iA21qbIxTnwg6VcYuj/RpZ27d
    Lj88J0kjUTocPL4rn5NVEXbn+olYGpziUqynafsRUsnixcqPM1XmZMqz2tHw
X-ME-Proxy: <xmx:4gSgaq_ue6OnGowX8LalEnBJKcDXeOUxjjhdQ7oP7g-8GDTxyhHCzQ>
    <xmx:4gSgasU5mQOeVXTUUVrju3J1Li86er0RTG2evnA86-UF-NXr4DxxPQ>
    <xmx:4gSgautAsu1DuTrg03f3x0W_wn5XiNzkE-ccfeDi7eKhS7hNR8N7TA>
    <xmx:4gSgaq8d1LVqwyLPtVe43Wp5clWrVCBJ9asUTVMql_abWj4hcWDUHg>
    <xmx:4gSgakcBS7Q6qodGBD3XhI7VTX9xiCF_1cjzpAaxHUn5Xd06inMrE5nE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:45 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 18/19] selftests/mm: add memory-pressure threads to the khugepaged race harness
Date: Tue,  8 Sep 2026 13:51:04 +0100
Message-ID: <20260908125105.1510704-19-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 66qinw8yf8wm3z48m9omcuxkkfrgj3ya
X-Rspamd-Queue-Id: F0E00180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1788871906-85702
X-HE-Meta: U2FsdGVkX1/pyG5rdefGCcUJcdv+F1V2AZTskA3jxp2xUAD6iVZJhDhivFCev6RjUVLkEW8HWwshCLt97tzjeo+zMJNnvzdcVmaD0DMiCu8W7Qh/gBHpmWK1cD1Gw+QJSKgDe5uLwdOp9Ou3zEK1K97mkvXcx7kplruv47dzuhnjqlt703DcoO39CJPp4r8McuoblTHT/02/TUsgmtJkrdmuPBprFdXUmJcRzrnNhZ/AC/FP1X0iGVBoMYc31cVL2hJhTcCkDP4AAdLss5+sgilj5wdiAJ/1nrOALX+vCRRkuQw4VbRb4EXW3RclC3+Ec8rIlMumxPDEGtesiDq8Y1wQKTTFxdpyer+UAUiyHjdojLF/XMV/HnOiRSJ/EDc2Zb3Kvcxa+KNq0OAv4i86MDXVyWifB/rG70BCVTtHl/2h9VII7ZfIHC4hL9+JfIMynMHDA0cDwPntgHbaeKFNaS7q8rETqWd0qoU2G64CdqhCbgOX3F7Bm19tapJQ0pO919Atm4Bidxeqe2CViLmbCjsJfC7j6XFUeh4cwjCw7Z2xibQ5bZzNHUgqkKQNA9qnjgzAXg791+2/IfKBO7hyGeLZDG0dJHCt4QJFuZoZhGDwx7sk8CViSEN63/cDPoXUs9m7AwDiEasAqWPnvVwdVRhIHTnES3WhP5MFG2gmzfZLo9fOkWc6KDlurdWgrx0YuLIOxptqzC3LJe/44CTeDECvS9M8OFMRf8cIMZluWblSlBVcS5dp4wiUzXx4wS8K8FSDYXefonYh/isVThhfmyJXiG51OsXPkLoXFbcO+NCpff0eGN+wiHXXmbayeEkR15/E2M11ioRapzHf7jQKpLb/XTVAEXh1Ls6wm1XOMUUYO8AVmCPGSen6VNdWP7BT4m/g/HuSIgYwL5o8lfR29FqwDGZ/ijGnXyLnH5PxlmjeK5zbqBMbV11NCE5hOKV+2KA5C/8Qe6HcCgJRuSI
 2tPXWj57
 29Vq309c0JbtTV4uHWcitGXTLILy3sQ5mJhZuFJb7aAt2sazOv3Zb+l9bYwbzrFBFKI6uXSB80QZTf/7iHZJwb0pIccgE3Dg3jMXbR+OhJStxdggp+Gql3BJesi9iWsC3QnqaeKwDZ3/8d96lX9yiexTyA426ZcjAqkYRF1Jjr0kydSDhIxO91JFvKne/cqtdK5xHZ4iQ3gVd19220oElZV8ycjvQ9sE2BLP2ckxz0Mcx7c4jBOp17sY428h4MyREazft8pUA0Uh1XKdkh7tdJCl7dP8n0XuFLdQBptyV3V2RZMpwPgJZfjbNRJaWnFIqf/cdwE5r+LMUtYPlBFTQ7iZETRUlplQu4vJ0KT3Y+Ev0eEOmGy/aCgiyj7t+F4r4JyXVI3OpIMBchZW7BtzyEjCpgVxmPu5KMWNiiBTjJ+KScIJRbEOGvQXI+DUPCAliXt76oAU6nFZiQFMgLs1o11YEGaYiRNJVCTnw3phEx1B349g6V4km+zfpGcxBadVs5W79
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness races collapse against faults, pins, fork, mremap and
MADV_DONTNEED, but nothing in it runs reclaim or compaction against the
collapse.

Add two more threads, and run every mode and occupancy limit both with and
without them:

 - pageout: cycles MADV_PAGEOUT over a region of its own, faults it back
   in and checks the content each round, since a page's pattern must
   survive the trip through swap.  Left out when the host has no swap,
   because then there is no anon reclaim to drive.

 - compactor: writes /proc/sys/vm/compact_memory in a loop.  Compaction
   isolates and migrates folios, so it competes with a collapse for the
   pages it is gathering, with refcount elevations and migration entries
   of its own.

Each result says whether it ran under pressure:

  ok 2 stepped/strict/pressure: 5s, 88 steps, no corruption

A full run is now twelve combinations; -m picks one mode, -d shortens
each run.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 142 ++++++++++++++++---
 1 file changed, 122 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index f31f12fc0390..1f4aa23834db 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -44,6 +44,8 @@ static unsigned long page_size;
 static char *region;
 static char *mremap_area;
 static char *mremap_scratch;
+static char *pageout_area;
+static size_t pageout_size;
 static int gup_fd = -1;
 static volatile int stop;
 static volatile int corrupted;
@@ -199,6 +201,69 @@ static void *mremapper_fn(void *arg)
 	return NULL;
 }
 
+/*
+ * Swap traffic and LRU churn on a region nothing else writes, so a page's
+ * pattern must survive the trip through swap exactly.
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
+/* Compaction migrates the collapse sources while they are being gathered */
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
@@ -222,17 +287,23 @@ int main(int argc, char **argv)
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
@@ -241,6 +312,9 @@ int main(int argc, char **argv)
 	unsigned long end_ms;
 	int duration_s = 5;
 	unsigned long thread_mask = ~0UL;
+	unsigned long base_mask;
+	bool have_swap;
+	char label[64];
 	int nr_areas_arg = 0;
 	unsigned long i;
 	int steps = 0;
@@ -300,7 +374,13 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes * nr_occupancies);
+	base_mask = thread_mask;
+	have_swap = swap_available();
+	if (!have_swap)
+		/* No swap, no anon reclaim: compaction-only pressure */
+		ksft_print_msg("no swap: the pageout thread is not started\n");
+
+	ksft_set_plan(nr_modes * nr_occupancies * nr_pressures);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -308,9 +388,25 @@ int main(int argc, char **argv)
 	/* Base of the settings stack; the bottom entry is never popped */
 	thp_push_settings(&settings);
 
-	for (int run = 0; run < nr_modes * nr_occupancies; run++) {
-		const char *mode = modes[run / nr_occupancies];
-		bool holes = occupancies[run % nr_occupancies];
+	for (int run = 0; run < nr_modes * nr_occupancies * nr_pressures; run++) {
+		int rem = run % (nr_occupancies * nr_pressures);
+		const char *mode = modes[run / (nr_occupancies * nr_pressures)];
+		bool holes = occupancies[rem / nr_pressures];
+		bool pressure = pressures[rem % nr_pressures];
+
+		snprintf(label, sizeof(label), "%s/%s%s", mode,
+			 holes ? "holes" : "strict", pressure ? "/pressure" : "");
+		if (corrupted) {
+			/* Memory is suspect; the rest would prove nothing */
+			ksft_test_result_skip("%s: skipped after corruption\n", label);
+			continue;
+		}
+
+		thread_mask = base_mask;
+		if (!pressure)
+			thread_mask &= ~(pageout_bit | compactor_bit);
+		else if (!have_swap)
+			thread_mask &= ~pageout_bit;
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -344,6 +440,20 @@ int main(int argc, char **argv)
 			ksft_exit_fail_perror("mmap() playground");
 		mremap_area = region + nr_shared_areas * hpage_pmd_size;
 
+		if (thread_mask & pageout_bit) {
+			/* Enough to drive real reclaim without swamping a small guest */
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
 		/* Populate so the first pass has something to collapse */
 		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
 			*(unsigned int *)(region + i * page_size) = pattern(i);
@@ -392,26 +502,18 @@ int main(int argc, char **argv)
 		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
 			check_page(i);
 
-		ksft_test_result(!corrupted,
-				 "%s/%s: %ds, %d steps, no corruption\n",
-				 mode, holes ? "holes" : "strict",
-				 duration_s, steps);
+		ksft_test_result(!corrupted, "%s: %ds, %d steps, no corruption\n",
+				 label, duration_s, steps);
 
 		/* The next mode maps the same fixed address with its own settings */
 		munmap(region, nr_areas * hpage_pmd_size);
+		if (pageout_area) {
+			munmap(pageout_area, pageout_size);
+			pageout_area = NULL;
+		}
 		thp_pop_settings();
 		stop = 0;
 		steps = 0;
-
-		if (corrupted) {
-			/* Memory is suspect; the rest would prove nothing */
-			while (++run < nr_modes * nr_occupancies)
-				ksft_test_result_skip("%s/%s: skipped after corruption\n",
-						      modes[run / nr_occupancies],
-						      occupancies[run % nr_occupancies] ?
-						      "holes" : "strict");
-			break;
-		}
 	}
 
 	ksft_finished();
-- 
2.54.0


