Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC51C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0736B00A9; Fri,  7 Aug 2026 07:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B7A6B00AA; Fri,  7 Aug 2026 07:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D416B00AB; Fri,  7 Aug 2026 07:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B82956B00A9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 457AF140210
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:34 +0000 (UTC)
X-FDA: 85074273228.12.40C5B70
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf11.hostedemail.com (Postfix) with ESMTP id 53C2140008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="W xjzI+j";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DFMFvzsp;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqABGYaTDBjD+cwWJAm5MV885+wK1zKh6mDVYP63LKI=;
	b=SopTdAdYYse/mDvsH2SawFCQzfgm1J3GxD6T8UYdyGkVG+y35RaqYnIhD9EDzZUsn3ZwSv
	eTamqXr+bt9glbCup/MaEa8MMJqACkkF7TFUDbXvS23GrhER3bqJmklHfGeAMsMWAeY7jx
	pXYMetskw4FOn8CmmnpllnLmxuCJTV8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="W xjzI+j";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DFMFvzsp;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102652;
	b=Odg3NcUPrDXpFL3vZf932NQTjhG/5Fk0h+sxJsZDCXmqKa3po+acvNEATfwLmfw/CWSPpJ
	kkZn615YnkR9Oe0SiOYEClUgkjzoZSUMun90dDzaEVssOG3Wnq2bzSG32zj6HB53aUPX4G
	kOje+ttc0Uh7JVAf9YAhJla86lApGM0=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 38B421D000DA;
	Fri,  7 Aug 2026 07:37:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 07 Aug 2026 07:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102651; x=
	1786189051; bh=OqABGYaTDBjD+cwWJAm5MV885+wK1zKh6mDVYP63LKI=; b=W
	xjzI+jD+AKuhzGdFBCgf8zaJLRFQ5VC18xsWsxekiPDCXdCcpZo9GbG/u3x0bJrL
	WKo+Wp6CbYCxRIYss4kRANOy2S0x5Mvj7hwkVNRmaA1HVVFVEp6jKV8dHHNFBIsO
	82ez0QTonL9r+IrQ+mOOaOPB8Aj6Untdu229hlkmSITokttshsd93JQeC8bh1nbO
	SAxAcx/+PyIgUXgWbri6lEM2aCS/8Kc4ZErqdPPKJNM4afpclsk5vwRiNrUFJcWd
	S3oY6o8FQXkpBqtioc8XP5f8+owugenmUqip1uAX6TReOVNg29wR1xrqTQP7cxRW
	khvk6WBnQeMxesduSaiUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102651; x=1786189051; bh=O
	qABGYaTDBjD+cwWJAm5MV885+wK1zKh6mDVYP63LKI=; b=DFMFvzsp6InJdi/IH
	B4xHaxSxATDcX9SMie17GDw9dOmjs0Bde1NdPYO/yrfHlWR2njTsFBSW36AtNRCD
	k1b/uLcOJ+jrZRaZAZVh3dLWS7pKIXJKLGICWsN4ylfLCZzIntZX90B5ic+nLVdC
	o8K9btkxM0uK9qn6a1EBgClO3K+ntTy/IGuvE4DF7n0KhRSQ5PkLF9ao/wzXAROC
	a/XPy7M+lf8HGFO27LonZayAxkdIali8U4KZFkHIs40/lAQ1gHbzYgIDxABdJRHl
	F/PAf9r9iY7eSAQUs1sJ2br26/KQKjWgplCQ5Q97A4CAYs6K9zr2ukV/sJfGdWtJ
	mmBHQ==
X-ME-Sender: <xms:e8N1ar8LklwlXwlBult7o2uiCgqoV0_LF9rytw4dj3Lk4E69Qsi88Q>
    <xme:e8N1arrh-uRrkivzjAmlJFCvnsqJHGccQ2E-7pzkwsQDsAo9jzuobrsEbGKx6l83J
    XG1q-pmZ7h9JPcEoKwkWIqt5sPKwhlBQyqYRCnpVOU3AvUbL5pnmcc>
X-ME-Received: <xmr:e8N1ahh41JFiifcysJBXzcxTxHF8rng_6-O8S_YuK5UDlDfV9iFn1d_8-xs>
X-ME-Proxy-Cause: dmFkZTEcBCtHwgFqhRPkncf0k+1ylINMWkiJotqLKgP2XUmyCnaVLH6jJFUJYUtwVpCetV
    bzy51nCrHgVQnKUbL6xUc35a2wACIZl+NbR3y/w0ModeWlKP4SKCXfcn2Mi8esZBMBdaWx
    faB4jzBJOawj2LBnFTgyCBiywrPp7FpNgfXB5cgYmB0wgvQ/HhhWAfKjMf/weJgLhMF/VV
    yXrMoja9EZiHjuXu8bb94hiDoU2fqI8TuwJJmzzN4TUL6MxSST+GnkpA2ZnKWVewXCphJB
    Lec89iAB+bDvFyV3zsxjbJ8cA1IEQ3aF+gxi5HDHtN75oTRJtbf/Sd54tDaiXy5fa0cQol
    MW02m0ZGtjHD58JE8hq66IpVl0U+UPJ3nIC2pthVrT/8lSmS/xrVKgAZ9KysURaeJoEhw5
    WpFpAmC8vf159gkJAGhW8a/tUyRz26I4LvuoRP+Xa0VlHgTOMmYlw0igpjphktySm6WZ13
    46PBg7JdeKJ/GB9sE5rFCoFlTqgY+IR6H61d+UuuYKrpZ00RVuMZsiGazJ3uH1j1nzi7u7
    5rP73EdU+fkpAuY1FQ1fYfRVDALBGosYQnjzbDtPx9MVdzp/o2L7ailpK8+VfvossfiVSM
    c+3BZp/vLcPZJs/IZbkaQEAhNUonJ23UQVWpdakD9zo2ikaCXh83KADXdxeg
X-ME-Proxy: <xmx:e8N1ahDDWPOCa7pTVvb9j3E2-wDEVVu6Imisbecl5-FnuTxcvXUrxA>
    <xmx:e8N1anvAk92JhG_mNKV5fONnnQwMUuWLn1iH7XSDxmZHPHPm3dLGGw>
    <xmx:e8N1aj6IhDGf231MftnQwaZ2V2HL-ejya7VUhq2hdpSZSq-5VWirRQ>
    <xmx:e8N1apfc7tSfOsgo9cSRQ55TEVL7VRpfjco3eEKNI4NOTN-emqzflw>
    <xmx:e8N1apxSqpk366C8GniXfpuSTKu_ngI1OqfYZVI9GcLrEMmmmE2x1fQk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:30 -0400 (EDT)
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
Subject: [PATCH v2 16/17] selftests/mm: add memory-pressure threads to the khugepaged race harness
Date: Fri,  7 Aug 2026 12:36:46 +0100
Message-ID: <20260807113647.3744609-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rp5g55imp6yh667rmg1ey78y7esmdwiq
X-Rspamd-Queue-Id: 53C2140008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786102652-752170
X-HE-Meta: U2FsdGVkX1/2etdhokkhjdIZj6mnu8MLdr6HfaNsObXG+R1R9+zh0CpnWUUVMO7b6w/6eTztVYfCkQef/8peC+BOgDlfmG5iJWWmmJLEh0c73M7ZUstJrl/fkbaqb5xJ2Ce7NlObBrm7jNnU9aLQ92ave1Mjl4xiiYJt1gX47bDN0xGJXP6nkJoXdpJCZzFE2I4NRv3NuT6m7jO7ARffHGD14EIC1JKY3DQitKj0Wncc/kzPDiifi41DWaxQTugMOS7ORkHOsxsyTFPTXZ0qhu+YRYSDN1M1AJja5W0zf8aXnD9TSqg0hWiwPCnDPODwb30yVUtwQ6UQS9MIe1yLhMSlgU6yoVCXO5nIOWZovvuW9Awyfycl5ISQ4tc6BZjZK3mg7zuyOCYAMylZPJxxzUUslWse0Kf7Fxtff6qZcoMJTIZXL9QqnKkcpWjuaaIVYuJIn6ZuH7938QlNYB3ovAauP1KRjrIrNoL4Fh8nxJqcllQIHRRgIPhkHsT7xDKhzTRYjowuDijZd3WhBbRq3xsZZIt7YAjV0ot5IIipdFZhD1CYtUluNmjvO2HGFqgB1yRQXuz2pf6k4RuTMrwA57R8b9nDHkcVA6woZJIXXFQDOWFRgZPCiLZrhHvOSUDGp1giQ25W4HntaMln87vubWqAJBVNOFwfdHfRCuIS6Y7PWfQJDQPOwMrm0nTb9+K09XW83xsO7PaqSyqiYNO9J6oBoCxQu+N2or3vg0aqW2oWM0TFt2tdF1uS0XTtHsNqK6a7E+/1fR7jYHZi0ugX79+ymo1pCZPrDwpgCu3WUuuVVVq7tvhGpl+uR2ffwQDMv9MH0/KbL0AuiL1V/AE6n/oi31yF70YkB7wDslDXGuBbUHH3q8SLzUlrDyTcgLrDcQ68f/XIOKUUj5zQG4jV851ySuu1TWRDvHZxExQ6UKJFRdOtuRQdTOr8d2EZW9MGwi4MbKbsPiSmV9i34CM
 fy3HmjUB
 mNCK0NvZoQK2H6xVa9uA3VRNgWdnfkXVqveq2RI0e5OUX3Rr8IHmZ6oh3HhHXWGp/9DUogrC0SB2NFkDq2tjhMbOKCIl6Q7hT6hb5dvmwJrzsnGxs35ViSqFWy1rviYtA9ADu1r+saunze2eT8L7A/XdPdYHDu+XnTctFu01neY5qhkfq2+BUa56fYJttYwLpT24ePkIn6rfAGmulQmGJEntuRMJuO846YaTDnb7j/3v8kp5/fuFAUnmRLjH33DCtar/tcd7IfCaIloELmr3Xo4I9QRw/PdB5lXlefMm8WW31l0XRsJxUup+ZmRjXx27CZrzkdxGbGqKGfJTV2H5xhViAYXSvERz7tpMBd8S14h4uAqP23Cvb7CDoc8/FE1Thulaw1W46skb7VtcgpzZNzHTWx/oskSJFOPMONht8GjO0DZ4hferpduTcKFFVRL1LmRKgHiXFQHRK4g8=
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
   must survive the trip through swap.  Idle when the host has no swap,
   because then there is no anon reclaim to drive.

 - compactor: writes /proc/sys/vm/compact_memory in a loop.  Compaction
   isolates and migrates folios, so it competes with a collapse for the
   pages it is gathering, with refcount elevations and migration entries
   of its own.

-p narrows a run to the combinations that have them, the way -z narrows
the occupancy and -m the mode.  Each result says which it ran:

  ok 2 stepped/strict/pressure: 5s, 88 steps, no corruption

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 147 +++++++++++++++++--
 1 file changed, 136 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index a2a91906285b..abd142db7cbe 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -18,6 +18,12 @@
  * zero-filled, and re-checked under the page table lock at install time in
  * case a racing fault got there first.
  *
+ * -p adds memory pressure to any of the above: MADV_PAGEOUT cycling
+ * on a dedicated neighbor region (swap traffic and LRU churn; skipped
+ * with a note when the host has no swap) and a compact_memory trigger
+ * loop (compaction migrates source folios, racing collapse's freeze
+ * with refcount elevation and migration entries of its own).
+ *
  * Correctness signals: every racing page must read as its pattern or
  * zero (MADV_DONTNEED), never anything else.  The faulters and the fork
  * children check that continuously, a final sweep checks it once more, plus
@@ -61,6 +67,8 @@ static unsigned long page_size;
 static char *region;		/* NR_AREAS * hpage_pmd_size */
 static char *mremap_area;	/* region + NR_SHARED_AREAS areas */
 static char *mremap_scratch;	/* well above the region */
+static char *pageout_area;	/* -p: dedicated pressure region */
+static size_t pageout_size;
 static int gup_fd = -1;
 static volatile int stop;
 static volatile int corrupted;
@@ -188,6 +196,70 @@ static void *mremapper_fn(void *arg)
 	return NULL;
 }
 
+/*
+ * -p: swap traffic and LRU churn on a region of our own. The content
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
+/* -p: compaction migrates the collapse sources out from under us. */
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
@@ -199,11 +271,14 @@ static unsigned long now_ms(void)
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-z] [-a areas]\n"
+		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-z] [-p] [-a areas]\n"
 		"\tWithout -m, every mode runs in turn.\n"
 		"\t-d: seconds per mode (default 5)\n"
 		"\tBoth occupancy limits run unless -z asks for holes only.\n"
 		"\t-z: only max_ptes_none = HPAGE_PMD_NR - 1 (hole-heavy)\n"
+		"\tRuns with and without memory pressure unless -p asks for\n"
+		"\tpressure only.\n"
+		"\t-p: only with the pageout and compaction threads\n"
 		"\t-a: number of shared PMD-sized playground areas (default 3)\n");
 	exit(1);
 }
@@ -212,18 +287,22 @@ int main(int argc, char **argv)
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
+	const unsigned long pageout_bit = 1UL << 6, compactor_bit = 1UL << 7;
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	static const char * const all_modes[] = { "stepped", "free", "madvise" };
 	static const int all_nones[] = { 0, 1 };	/* strict, holes */
+	static const int all_press[] = { 0, 1 };	/* quiet, under pressure */
 	const int *nones = all_nones;
+	const int *press = all_press;
 	int nr_nones = ARRAY_SIZE(all_nones);
+	int nr_press = ARRAY_SIZE(all_press);
 	const char *one_mode[1];
 	const char * const *modes = all_modes;
 	int nr_modes = ARRAY_SIZE(all_modes);
@@ -232,13 +311,15 @@ int main(int argc, char **argv)
 	unsigned long end_ms;
 	int duration_s = 5;
 	unsigned long thread_mask = ~0UL;
+	unsigned long base_mask;
 	int nr_areas_arg = 0;
 	bool holes_only = false;
+	bool pressure_only = false;
 	unsigned long i;
 	int steps = 0;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "a:d:m:t:zh")) != -1) {
+	while ((opt = getopt(argc, argv, "a:d:m:t:zph")) != -1) {
 		switch (opt) {
 		case 'a':
 			nr_areas_arg = atoi(optarg);
@@ -256,6 +337,9 @@ int main(int argc, char **argv)
 		case 'z':
 			holes_only = true;
 			break;
+		case 'p':
+			pressure_only = true;
+			break;
 		default:
 			usage();
 		}
@@ -265,6 +349,11 @@ int main(int argc, char **argv)
 		nr_nones = 1;
 	}
 
+	if (pressure_only) {
+		press = all_press + 1;
+		nr_press = 1;
+	}
+
 	if (mode_arg) {
 		if (strcmp(mode_arg, "stepped") && strcmp(mode_arg, "free") &&
 		    strcmp(mode_arg, "madvise"))
@@ -304,7 +393,12 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes * nr_nones);
+	base_mask = thread_mask;
+	if (!swap_available())
+		/* No swap, no anon reclaim: compaction-only pressure. */
+		ksft_print_msg("no swap: the pageout thread stays idle\n");
+
+	ksft_set_plan(nr_modes * nr_nones * nr_press);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -316,9 +410,17 @@ int main(int argc, char **argv)
 	 */
 	thp_push_settings(&settings);
 
-	for (int mn = 0; mn < nr_modes * nr_nones; mn++) {
-		const char *mode = modes[mn / nr_nones];
-		bool holes = nones[mn % nr_nones];
+	for (int run = 0; run < nr_modes * nr_nones * nr_press; run++) {
+		int rem = run % (nr_nones * nr_press);
+		const char *mode = modes[run / (nr_nones * nr_press)];
+		bool holes = nones[rem / nr_press];
+		bool pressure = press[rem % nr_press];
+
+		thread_mask = base_mask;
+		if (!pressure)
+			thread_mask &= ~(pageout_bit | compactor_bit);
+		else if (!swap_available())
+			thread_mask &= ~pageout_bit;
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -354,6 +456,24 @@ int main(int argc, char **argv)
 			ksft_exit_fail_perror("mmap() playground");
 		mremap_area = region + nr_shared_areas * hpage_pmd_size;
 
+		if (thread_mask & pageout_bit) {
+			/*
+			 * Big enough to cycle real reclaim, small enough not
+			 * to dominate a TCG guest: 4 PMD areas, clamped to
+			 * [16M, 64M].
+			 */
+			pageout_size = 4 * hpage_pmd_size;
+			pageout_size = pageout_size < (16UL << 20) ?
+				       (16UL << 20) :
+				       pageout_size > (64UL << 20) ?
+				       (64UL << 20) : pageout_size;
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
@@ -403,8 +523,9 @@ int main(int argc, char **argv)
 			check_page(i);
 
 		ksft_test_result(!corrupted,
-				 "%s/%s: %ds, %d steps, no corruption\n",
+				 "%s/%s%s: %ds, %d steps, no corruption\n",
 				 mode, holes ? "holes" : "strict",
+				 pressure ? "/pressure" : "",
 				 duration_s, steps);
 
 		/*
@@ -413,15 +534,19 @@ int main(int argc, char **argv)
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
-			while (++mn < nr_modes * nr_nones)
+			while (++run < nr_modes * nr_nones * nr_press)
 				ksft_test_result_skip("%s: skipped after corruption\n",
-						      modes[mn / nr_nones]);
+						      modes[run / (nr_nones * nr_press)]);
 			break;
 		}
 	}
-- 
2.54.0


