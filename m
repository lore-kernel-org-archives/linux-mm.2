Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61D2C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95946B014F; Wed, 12 Aug 2026 09:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D2F6B0151; Wed, 12 Aug 2026 09:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D829F6B0152; Wed, 12 Aug 2026 09:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADD2C6B014F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34701120377
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:56 +0000 (UTC)
X-FDA: 85092685272.25.5A5D458
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf21.hostedemail.com (Postfix) with ESMTP id 40B7A1C0007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q QGr3i+";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=XAdy8p4P;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7LCReNWni5AyzqrKHBrxiaeJCnTTFdJVGlYhEXGLCk=;
	b=rmjqJ+w/BcjYL2G1Rk5v/8Ryt95AWZ9j9VcppU8lao4dPaq2AupOnSFyCE91riPBZPvAUx
	Kptz6qS2yZnHmNutP5UlscxC04ofuQh2jMIHN5P1g0A+tWggGtrdoX0XLLJe6bT6E6rOb8
	ydjYKCnOj4xejkwhkY3F6roA4t+zLQ8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q QGr3i+";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=XAdy8p4P;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541034;
	b=qOcTYDEFBVEP4ZEZeCAOINABKjVkvhMEWNStpz1xNF7Sn0zMCJbxPiTe1I64LN3XmiAfSG
	GvK3Xu2em+e0eyqU8coQEogEEkkLoCYqY4xMHiRmyoAKh3xrXXWSmOpB1PS1J4s1cdT98x
	iKmWDql/BJhaM4J9BsxfZTkSI2xMPlQ=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1B1807A0173;
	Wed, 12 Aug 2026 09:23:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 12 Aug 2026 09:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541032; x=
	1786627432; bh=N7LCReNWni5AyzqrKHBrxiaeJCnTTFdJVGlYhEXGLCk=; b=Q
	QGr3i+YcqmaXLYc1+qBt5+N9VHD/fm8L+kkEalfLzOVAkuOJuPtww7QclBkQ3o98
	k6N9h+JaQH+fdqWjVQrLFA/xDdeF+H5khW1qnUrhUzHuIj7mJdXyl111b4zloiOu
	Fkfa9/UTSgOGd50i1H6k1LsgNUYyGwU+Lt64ZofWUa3JfjEOnkZvE7Qonle6CDHe
	1hqu7edgD5Fe9lSMB6POY2cDDCDzBT0/fKrb7bq3oFE4zlxhddegz3u4MTR+ZeEg
	/iAwY4A4IifPM0GGa70qZb8WD5T0tKPsuG8r97BSInL6uG0D6gxSDB1WzdqH/ugr
	dO2JF3M6raqcE7fpX29tA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541032; x=1786627432; bh=N
	7LCReNWni5AyzqrKHBrxiaeJCnTTFdJVGlYhEXGLCk=; b=XAdy8p4PcD9p7T995
	LyY9WetgpWpoaAuifi/iSEG8knfe6Ey7IH4oIOl3JbLHlNNsLJYlSyUtl/zCHtIC
	ae8wbn7O6Llqq5V5JDwKu0xfoKG0z5f38ZdbKD+D7IAmDv90NxZ7znPaDPEN8KBN
	WncYC8vqiFEd46eQKArCjY7wE9DLNATuh1lTnGfLB6p09oybXgj7k9W6sojbdvnt
	TNLx9Nq56SMuaz0MNAaHJzpj3HY9ziTFGWo2Bj+NcFoA4OeZsCwR6I/CB6jW8LRN
	8a+7E9qDMZJHpZRa/zFjaRNW91pcbooJtzwptBlBdUD468xagEObyfBYtLdKJE1U
	3GQJw==
X-ME-Sender: <xms:6HN8avZPFWWTk0G4HAxz-aK7mOSe5VPMLTr_YPWjQ0goNLZZvz6ylw>
    <xme:6HN8aiVX3Ai9GUVyP756T-jwwcYgdqOUuHjXuf2t5EyduLnEvtkD3L4u0GIcsKp_A
    kjbFuBReBHIhWbE1XRTR_4gyQrvNuHHOBY5ixItKvLhuqO8nUvmQvrB>
X-ME-Received: <xmr:6HN8aqeY9XDL4cqreDqyuFujXZYS_r4BoVw0pbStaJL7j-iSzW4_D4pjPZY>
X-ME-Proxy-Cause: dmFkZTFkdXlhB1yyyGZX3J7dnv16PFzu5W734vHfSlZD/y8c/c/hfyf9JcTqEblNR0Fovw
    r+VLRtLwlZT2tYuTqMJsjjjBxJMgoAM7D6pmLt36lViB2yT50Uubj7I3KQF8rzeVMBK9wq
    rm57aKmY5NwWN7q607eE1gnukbthccXm6lhrmbDGqX6XovHG8JRMLfqJj+jBW3X680r35h
    P9o/w0aRWYBwLgRKYH9oTyb2lbiE5fXNRZyQYMHMmm7yuduJ70EU4YPdENzrqcZn4mtIUi
    PPdmMfUKqzUyYVrtf6UgPYBrZU3VzLkrgoUPTsKVKEpiHQHdj45X731bFwNLlQpPGy3Qck
    3rH4D3RYGs85EQdsgI+nO0kGwXnp1+YPBPQEZ674qFSOTpHnJMdRTrEnca3M3nqPQDMI8/
    ot33MuJyjdjtqfgPRq9ROijZZ1wIUlw7rPGF0hcNfCu2dViVV4NYep85twdkb01CCSV7wr
    5LzGBvkUx8M0vZPNJavpmA1lEY8+Xmei4gP0gtjC4GUILlPtElB/7LhUvA8qzAb7tdsg5E
    7biggFc6E1CeiLviqvxjkxXH+5n2eXOrJn0eeU3BOoJ1aKI9U9fZnq2ihJeIUH3ydyPOzS
    4VHbf0mHgOLh5uk1YDcHD+S5UsCKHaTQT7LiHh6qZtmj8vI+p2Ve1aGavVgw
X-ME-Proxy: <xmx:6HN8avMZiL1t0U4osvPJtXXAaYF_dp55lLexOWvjrgAyezaFXdUtzQ>
    <xmx:6HN8aiKxD2-kgMp05_X9Sb83Mb1WkCOQ_OcqD8fumBtGy-tQbfC5rg>
    <xmx:6HN8alkJdClqGjd44-PQ0UUlFuru8tXsC9-ZU2uY8iI_Bl2_spF9ag>
    <xmx:6HN8ahYXywJw_7GLoU0W4M_gmpnWZUZXiYBey4fxQlGPpN1pffguMw>
    <xmx:6HN8aq4j0fW8VBhiCw_DaiT1b7hoJMNNwaEvlWGT5oC6kzDviJ8jogeI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:52 -0400 (EDT)
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
Subject: [PATCH v3 17/18] selftests/mm: add memory-pressure threads to the khugepaged race harness
Date: Wed, 12 Aug 2026 14:23:03 +0100
Message-ID: <20260812132304.199287-18-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 40B7A1C0007
X-Stat-Signature: admpckrit5kidksrgo4cq9i16kh3tx1z
X-Rspam-User: 
X-HE-Tag: 1786541034-644265
X-HE-Meta: U2FsdGVkX181+lSlw0FVOB5b6dSCIIQQXLYfv8NChahp/1Y78Nzfm/mE07cfBvmHAQq2KlZJgGjyVnGJh3B95RoK2p+bq0s2wi/SCBzgCnSs4yR+4bhWeDjPMbF9WDJjZdOQVWPQkdICmrl/aH5JZStGXXvuQPLBVFhyoh8vd9CNPxQFRkNKldlIUVPfCkLLrxDBVB90uSyWCyep3BJ/c5Weyj8OUQ7vgYnHKpbPjVdkms/UXfBcIcEAqIULSOSKqE6neRYyUggEEpKTdCzli4umIP6eQghHmVrGEKFaL3hF+lLmN6Nnw2sqE1f4L22KWBjaGlA4e0iZHM6L8bW895MISiLxaH6ABfkvE7t1iZqyGUcZf0axerwjgvwBaC6KZK2e/iXKDZkmz3nT84HqabQlvfxvG3/qnsTdrCMsziFrDQYUNQPwZSsJVwVaDo6WrJxDHNf54Qlm3UsUQ2a0vPRFIgUlNWTzycHYoBSkaLnT4JEoPgp1c4tmjNnxk09G61QcO15XALvFCSnJ/guiGv2P3hPF5wWQvA0hms0eNWWukJSAyUS0LkHHCGvEy8bTcPLF9Jh+jcVJaQJSYuKritfKqraIUWHoA8ZxraEdKhSfedjWUjxE8eLE/cXQW3g4EC8c9ZsiWNbwZObnJ1NpaAi9aQipjd+BRpDwg2pqXrfuuAm+ARsbPY30UmXjZySwN7VfiQNYEXf8C+V1nM9QHZQt7vCMB4q3EpzTYZSnamXS6arlYDFvis8FbkDt4UHr81eUXTWvKXDWvFMAz76qcshET6i+8VJpUWkvXS/ytc6sIVq/5u+/ijL866csfcREQlf2H7wQ+w7s1QYabUUGEO7RRnHttH3hmJR6lIiu/MPsRSbSqG/Tq8W4I8hWkCBRmXzE7oj0Yt+vP3dmWCiIKwBr8Gc0kCNjL5nHWXW//phc4ay2ofVJ+VUHGrm1PG8GLUmr2oIzd6r5ZJo60Lk
 n66sqE+M
 +27D6/C1FvuEQrvyvY3Okc6cIIG+Z/t4zV+8NfusblAkCVw4KDs5QSdQTBmmOIVxxyEJzxmH5/PGP+wrMdOSp6AeJ4jM6yY2Dvct4CkImNNtDF4fn+3pS6XVE9Nm5mHuzQMNPVXM8P1qKSRmi7mXrjqhPI1PQ5kecQEDUy8xTlzdDUi9Ecu4n0xKOtJNeeTaHipfq3fxjErasmEnvd02FIIBP4vhJe3xzGTv9SVZdMBYfQZu0WB2EO4cmlbCNGn4fzFU1FOOT0bR3seVQ7gf0eZ4DN6tGmLw9WmntTb6H/gqrfJm6IpzxrQ4LmPoWVYj1vXFJdAK4M1W4TQmc1LY6+14STzYfmfh2D8KAf7c2S+jl6pqffJU8qW02wDxub0Pu9S9DmzEO6JxCJLcuHif4Vg5+dVslCSaC9rh4PKUJE3jLk+2XriTosj6JILEkKiUOZjeSd9iXGU0GZrFi/K41fFqa0sV1p0lit0yOwIOw9Qg3epJKW90/zQSlK46K29KoO5O7
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 158 +++++++++++++++++--
 1 file changed, 144 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index ba4f5c36bf88..bde36af03e49 100644
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
@@ -219,6 +227,70 @@ static void *mremapper_fn(void *arg)
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
@@ -230,11 +302,14 @@ static unsigned long now_ms(void)
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
@@ -243,18 +318,22 @@ int main(int argc, char **argv)
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
@@ -263,13 +342,15 @@ int main(int argc, char **argv)
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
@@ -287,6 +368,9 @@ int main(int argc, char **argv)
 		case 'z':
 			holes_only = true;
 			break;
+		case 'p':
+			pressure_only = true;
+			break;
 		default:
 			usage();
 		}
@@ -296,6 +380,11 @@ int main(int argc, char **argv)
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
@@ -335,7 +424,12 @@ int main(int argc, char **argv)
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
@@ -347,9 +441,17 @@ int main(int argc, char **argv)
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
@@ -385,6 +487,24 @@ int main(int argc, char **argv)
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
@@ -434,8 +554,9 @@ int main(int argc, char **argv)
 			check_page(i);
 
 		ksft_test_result(!corrupted,
-				 "%s/%s: %ds, %d steps, no corruption\n",
+				 "%s/%s%s: %ds, %d steps, no corruption\n",
 				 mode, holes ? "holes" : "strict",
+				 pressure ? "/pressure" : "",
 				 duration_s, steps);
 
 		/*
@@ -444,17 +565,26 @@ int main(int argc, char **argv)
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
-				ksft_test_result_skip("%s/%s: skipped after corruption\n",
-						      modes[mn / nr_nones],
-						      nones[mn % nr_nones] ?
-						      "holes" : "strict");
+			while (++run < nr_modes * nr_nones * nr_press) {
+				rem = run % (nr_nones * nr_press);
+
+				ksft_test_result_skip("%s/%s%s: skipped after corruption\n",
+						      modes[run / (nr_nones * nr_press)],
+						      nones[rem / nr_press] ?
+						      "holes" : "strict",
+						      press[rem % nr_press] ?
+						      "/pressure" : "");
+			}
 			break;
 		}
 	}
-- 
2.54.0


