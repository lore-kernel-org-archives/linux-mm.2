Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F288C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BF46B00AA; Wed, 16 Sep 2026 05:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924AD6B00AB; Wed, 16 Sep 2026 05:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A496B00AC; Wed, 16 Sep 2026 05:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56C1F6B00AA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D956CA0558
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:11 +0000 (UTC)
X-FDA: 85219109262.08.7CAF175
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf13.hostedemail.com (Postfix) with ESMTP id ECD9020008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="F KpQmXZ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=jhs+5HDI;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551130;
	b=AqTqFdGQXz8SraBkC1xfS513up+isrUXttnrO25dhmeInjxM48tVboE/Spv/uaRkOIDP2O
	LhnyDNgZYmmn+SUHn2v8gAV8v9vnrQsQ65Cu6DZl1zNFgf+rUOEycUa8QGzIKW1XYM1Wfu
	UeQzqtDPHegjy5GyLk4z8eY3sjT4ZjY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="F KpQmXZ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=jhs+5HDI;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3XbtEJmWsNT+g02Bw1UcrtZfkVHUUoW2q6DbPGG+78=;
	b=Y9cdmBzLt1guXd5szmeT5AYSFaOijjj7wDQyNbxGUz7268UwrmgNdDERbGmGu5OYM9d1F9
	qECSsNR0PDIveTCJPXpf6pnnBj/unrArQVuhsHzduCX7re+ILkqm1KGAECw16C/ubR/afQ
	+WiLwdf3gsglzyoz3QlsB75INfCah98=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id EFF897A008A;
	Wed, 16 Sep 2026 05:32:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 16 Sep 2026 05:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551128; x=
	1789637528; bh=Q3XbtEJmWsNT+g02Bw1UcrtZfkVHUUoW2q6DbPGG+78=; b=F
	KpQmXZB184fo6UZ4QEOsFWMW47cqaVTzpJh6v4ISCKy4NRxLFRX9uv1s+Vy8ShRD
	W+422RyRjLIiUol4usrTCx14rQ3hDMQy+8Nx1HlIXQvWL4dwhQRPLr2cOUrMpEpL
	CBm04Jh6Vvgui4qLCv5R95bZLmBMcqTDRrZzBepeONIxO0U6Ja2KvUnG0LLAf9H1
	0njnDuJfW+AEq5VGIdWmJWR8wmESiOW6ildk5hcnl+4n6anmDYrEPFuAOoQPnfTm
	jC5RQzfgitDpQz1tTgU2RLLzAmcr9exMuNoRX6Cp7YkN1EsfjlM+qjNsD/1I0ab4
	014sI2tbLtq6QjoYlD71A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551128; x=1789637528; bh=Q
	3XbtEJmWsNT+g02Bw1UcrtZfkVHUUoW2q6DbPGG+78=; b=jhs+5HDIuFHICLQiN
	ApAxXIoxBGHIQJV35Nc4lvTdPggixWJVh/vMxtHefvDmDgLv72iKzBj6Jm31F/bf
	HhC17a6FPCpelOaWJWuom0ZJ+7WH9LHiY9yhXc2zAiO6g9k1MlC5vTQ7DEGny9Fi
	5LDqGojttj4oCKQEGRIyo4GX8kKEUUao/GbaP91/aFw8rJ8lQYVB0358q2HLB3p+
	xklnv5WOaNxLizxm3wK3qUZ09qPLyZe9iQPOCwRKaWe4Krt4O+OqezHxaDukasCI
	im8GMftcyxahcAAE6q/2ty6DydSkEpPN/lKYcBOvmaTHMzQFgdVVJlWSPoytaba6
	aTZ6Q==
X-ME-Sender: <xms:GGKqalOi-DHOFYKPTiLyTmttEhDmWjQ7RnqBwED8jRMSOByqxj4c-Q>
    <xme:GGKqaj5ufJBVqHRhubPt-EruhL_WZmrFVRESS2eBkEUHe3hWpycauh0aLKr9aPZMk
    xqCm03_t_QQqwGUPygqNm8O1GSzfGAwQPjHB9HoG96clmu-gwNTDSZj>
X-ME-Received: <xmr:GGKqaqZAEHhTln9eMdmj99euuFHunLnwHMdP_7WjsFix6Kyi30Moy1LuQm4>
X-ME-Proxy-Cause: dmFkZTE31qL+uaIHQKQPvpaICSxxs7QGWvIquuW8cKaqYQWKvt9pKCqy5bgk//TApl3wTl
    ad4FQSRAknjhMkzVuMAZNh0T12ywqROLvU4AnUXGVwd2kiN78Ar+1NR+fesCkATu1LALh1
    4LvX/9qk4pAfO725ECjoAkI82P3z755hZxEkAV0An15e7Wr2vIbgLFM815SfkNmTU/eBmL
    ORNXO2IPaHkpkCtL9iOfg4dR3lpAdl3Xvq/Y35opAbs/zzbuDBIkBs44NTO3w5x5Bedurt
    thFl4kzzMjhv7UlAxOBz4vPRXQMYZm6skstaNA0N2ZkZEKrpjBUX5624wA8G4zEpHd89IN
    i/KDmLvP9t2q/TyXL5za1fYFxo4c+gyrrE4t5l81/2lkILfQ54MPazgd5LGC9+oo2D32LK
    ZgH4y7AHi4PJxaJtXgsxSllVA4w/pea91FWnyh2eMIshTViwU3sZ0fraEvUw60BjmdV3gd
    kdNL+FW33NdX9EnfyRI3AAqhm8DOeYNARCQHEZUFjDtsr7O7w8NJFOC9JL+d4XUGLUww0w
    Ve0jEfV8rN8L/lIHxDHnthdK7FmfioNKt0JMBsuYj8eurCU9RVN31ctkdMTQqGuvQr5bPq
    MbLd0CkRtCceKCp+kWaCjTbp1V7ttFuhZqhkZBshAQgPahHgTccFTHawGdnA
X-ME-Proxy: <xmx:GGKqaoGDrmi9MvoA57QLWBILGGkkzG2NK0BBxRihQKX3FLXCTKCzJg>
    <xmx:GGKqarmWH4K-D9xpRiLBIqq2rkFTuPrsgPnMpaQJnS-vgWUsklgj-A>
    <xmx:GGKqann-kcYLMXqtv_LmfjQP6k9DvuMs21ZDcmBsWP0d5HkJNykLRA>
    <xmx:GGKqagUv9YbSAfUTr_5gMgWKzad-qu8ZFf0_eBeRRgaqpj4SVCFHdQ>
    <xmx:GGKqaovYuakxmZ111QYtnRLQ0teKAu8fzFL2-mKeINcM6P83R84-fALP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:32:08 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 08/12] mm/collapse: separate scanning a PTE table from collapsing it
Date: Wed, 16 Sep 2026 10:31:35 +0100
Message-ID: <20260916093145.4022188-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECD9020008
X-Stat-Signature: nqt6xj9ayaoqs95e4efzf8z7pi54r16z
X-HE-Tag: 1789551129-132827
X-HE-Meta: U2FsdGVkX1+eN0geQRufAowcQIHeMDyGsc0eEwmVWchbJjddm71YyofTqNnyK+KMWKnosCncN+3OVVg9AD8p9c+hRODm+KLSdbdeLq+Osck1W5jgd9YF3w5dM1K/FHF9xaN6+LixiLHxAnNrTeytfiAyubw4Zffeqj8ZQq9A2//bzMIL8LOyW22ItnkPHTfyuy0yb8DVyQ/shUfbrmEV5ouLv5UZIE0J4hAA/EZ3kcOQnUDf03ez49DG2/xo9qEUJlQ9L5jXFOKnKRQClP0k8JlSriQP2T/0BHtDZfX3AK71eCCycBKsnhxSwkQTf8T01c1TNzn7iiHKn2HNRltE8wISUpf0/tovcJlQ41LCN6chWhE9WmfjhuIzGSWQ6DPF8TQMA544BkYxfXjPTMCUGHYtRLDylB/jwVarte/1ZEizLbU5+BY1I9rE3hHwxy+cKEEI5aUkRS6WQRfAA2dE7bdA9yG5pm2yZFKdjOt+FnpGTk/+WuElAxySTjHIOBJ2hTeTEcgojCbE2dHpDKxaut6X/qU0YXfLTk4yAdDRL0jAYCEVBRsHbYuziPcz+GzdVHYhBQX1JgNIk+IbIjhc/dn/OKAX6M3jLlPzeQtDrIVK/Coff+u45h2IeJFOCU0NVl1xLLjaR9VpcN8M/rEI+cex80PR7uwekUvhu8MZn4/G0vstYDB0V27NWfyjjmKqwFH5jpzMCBPNW0WhFlo+HO5KPRvse3WA1QoYwzcU+4YwrfIXw3rwCUY8bZbM1If20krNEVnQSqmUm4A8R7AFIx0NzOeiRaBPxmMQb9PuXwDchwSY7BemI1thf1BD9lTurJ585b5OTmKQ1OzqRdAli1ETod+d1MwsNVHE5pUZl7PZRtqsAHqJXQGAh8sTJ5nlhNZFMYntEH8r+cmurBgtZdtZcN14UJPqr4jJSH5yP32+ovs1LGQ6bcljBQT3j0MOGHjcDjqvWKdY5kBVIYd
 2bEwaQT3
 1Id8c/n3pYiKbS/bCowgP8YcwyI6v+VWLsMZ/DZeFMD+jB9kxiF+EEU+166o2j0VkshEOd0cbwYdbFYEX4dLqVAtWFzaIz7KTVy+fK/PfPVwiWmH/9OCQWu2bdvAO7CppQHTYNryeBeWBC7v0VndxHjMy3IFwB+FaIzu6jWWDx+qJr6s0Q3xilcb57FG/ovfHUGDZcjkI5IBZ4tyqUxzAoYs6eNQWuCLoIt+w0JbUuazRypdGRqd/oERJ3gMleyS82SWVy8WEnDoXMMfcUUIuiRPKfiZnUHsAIAYErFXoanCu4yWdwc4eNbbfsoVuavkDD01inxlDUc+Q4NKU1AwC58MXhqbJXnNkx/Kq1PfAF3kQraw6K/Kh64Ivo8KyS5r6nt7Nl2wuAs3gzrV7KvOyoVygmBXIILfRMqnU0RhDsWzar4jUEn1qGMPCgVq5oXgOLo+S+K54I27oi0ANmCAu6yK1fYtOx+s7bWV5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
whether the range is worth collapsing.  The other allocates, isolates,
copies and flushes, and wants the lock given up first.

collapse_single_pmd() did both, so the boundary between them was somewhere
in the middle of a function.

Give each half its own function:

  - collapse_scan_pmd() scans one table and only reads.  The anonymous
    scan that used to carry that name keeps its body as
    collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
    that picks the anonymous or the file side.

  - collapse_run_pmd() does the collapse the scan asked for, and is
    handed what the scan returned.  SCAN_SUCCEED means there is
    something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
    cache already holds the PMD folio and only the PTE table is left to
    retract.  Both are work for the run; anything else is why there is
    nothing to do.

collapse_single_pmd() is now the two of them with the mmap_lock drop in
between, so its callers see what they saw before.

What the scan found and the run needs travels in collapse_control.  For
an anonymous table that is the orders and the referenced and swapped-out
counts, which mthp_collapse() and collapse_huge_page() now read from
there instead of taking as arguments.  For a file it is the file itself
and the offset in it.

The file side moves with the anonymous one.  collapse_scan_file() used to
run with mmap_lock already given up, and called collapse_file() itself
when the page cache looked worth it.  It now runs under the lock like the
anonymous scan and only reads; the run does the collapse.  A file
collapse works on the page cache and never sees a VMA, so the scan takes
the file reference while it still has one and the run gives it back.

That changes what a refused file table costs khugepaged.  Every file
table it scanned used to end its pass over that mm, because the lock had
been dropped to scan it; now only a table it goes on to collapse does.

Two things on the file side stop being rescanned.  When the page cache
already holds the PMD folio, the scan says so and the run goes straight
to retracting the PTE table.  A run that refuses dirty pages and may
write them back retries collapse_file() alone.  The checks the scan makes
ahead of it are ones collapse_file() repeats under the page cache lock.

Tracing changes with it.  mm_khugepaged_scan_pmd and
mm_khugepaged_scan_file used to fire after the collapse, so for an
accepted table their status field carried what the collapse made of it.
They now fire before it and read SCAN_SUCCEED for an accepted table.  What
the collapse then made of it is for mm_collapse_huge_page and
mm_khugepaged_collapse_file to report.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  14 ++++
 mm/khugepaged.c | 166 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 130 insertions(+), 50 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 7044dc71c7c2..9764011bad86 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -88,6 +88,20 @@ struct collapse_control {
 
 	/* Each bit marks a PTE the scan accepted as a collapse source */
 	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+
+	/*
+	 * What a scan found and the run after it needs.  Live only between the
+	 * two, and read by nobody else.
+	 *
+	 * The file side takes a reference while it still has the VMA, since a
+	 * file collapse works on the page cache and never sees one; the run is
+	 * what gives it back.
+	 */
+	unsigned long scan_orders;
+	int scan_referenced;
+	int scan_unmapped;
+	struct file *scan_file;
+	pgoff_t scan_pgoff;
 };
 
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ff1756c1255d..b6fc2c78e3e2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1237,8 +1237,8 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
  * while allocating a THP, as that could trigger direct reclaim/compaction.
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
  */
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
-		int referenced, int unmapped, struct collapse_control *cc,
+static enum scan_result collapse_huge_page(struct mm_struct *mm,
+		unsigned long start_addr, struct collapse_control *cc,
 		unsigned int order)
 {
 	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
@@ -1277,14 +1277,14 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 		goto out_nolock;
 	}
 
-	if (unmapped) {
+	if (cc->scan_unmapped) {
 		/*
 		 * __collapse_huge_page_swapin() will return with mmap_lock
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
-						     referenced, order);
+						     cc->scan_referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1448,9 +1448,8 @@ static unsigned int max_order_from_offset(unsigned int offset)
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static enum scan_result mthp_collapse(struct mm_struct *mm,
-		unsigned long address, int referenced, int unmapped,
-		struct collapse_control *cc, unsigned long enabled_orders)
+static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long address,
+		struct collapse_control *cc)
 {
 	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
@@ -1463,7 +1462,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 	while (offset < HPAGE_PMD_NR) {
 		nr_ptes = 1UL << order;
 
-		if (!test_bit(order, &enabled_orders))
+		if (!test_bit(order, &cc->scan_orders))
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
@@ -1471,19 +1470,18 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 						      offset + nr_ptes);
 
 		/*
-		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in cc->eligible_ptes. Account them for the PMD-order
-		 * candidate.
+		 * Swap PTEs accepted during the scan are counted in
+		 * cc->scan_unmapped, not in cc->eligible_ptes. Account them for
+		 * the PMD-order candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_eligible_ptes += unmapped;
+			nr_eligible_ptes += cc->scan_unmapped;
 
 		if (nr_eligible_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
-			ret = collapse_huge_page(mm, collapse_address, referenced,
-						 unmapped, cc, order);
+			ret = collapse_huge_page(mm, collapse_address, cc, order);
 
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
@@ -1525,7 +1523,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		 * we must always move to the next offset.
 		 */
 		if (order > COLLAPSE_MIN_MTHP_ORDER &&
-		    (enabled_orders & GENMASK(order - 1, 0))) {
+		    (cc->scan_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
 		}
@@ -1550,14 +1548,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 	return last_result;
 }
 
-static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *lock_dropped, struct collapse_control *cc)
+static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+		unsigned long start_addr, struct collapse_control *cc)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->policy.tva_type;
+	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1737,12 +1735,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page() expects the lock to be dropped before calling */
-		mmap_read_unlock(mm);
-		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
-		/* mmap_lock was released above, set lock_dropped */
-		*lock_dropped = true;
+		cc->scan_orders = enabled_orders;
+		cc->scan_referenced = referenced;
+		cc->scan_unmapped = unmapped;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
@@ -2739,45 +2734,86 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	else
 		cc->progress += HPAGE_PMD_NR;
 
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc);
-		}
+	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
-	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap,
+				      result);
 	return result;
 }
 
-/*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
- */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
+static void collapse_control_init(struct collapse_control *cc)
+{
+	cc->progress = 0;
+	cc->scan_file = NULL;
+}
+
+/* A scan that took a file reference should have been run */
+static void collapse_put_scan_file(struct collapse_control *cc)
+{
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
+}
+
+static void collapse_control_release(struct collapse_control *cc)
+{
+	collapse_put_scan_file(cc);
+}
+
+static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	bool triggered_wb = false;
 	enum scan_result result;
-	struct file *file;
 	pgoff_t pgoff;
 
-	mmap_assert_locked(mm);
+	mmap_assert_locked(vma->vm_mm);
+	/* Whatever the last scan found has to have been run by now */
+	collapse_put_scan_file(cc);
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc);
 
-	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
+	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
+	/*
+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
+	 * the PMD folio, and retracting the PTE table is the run's job.
+	 */
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+		return result;
 
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
+	/*
+	 * A file collapse works on the page cache and never sees a VMA, so take
+	 * what it needs from this one while it is still here.
+	 */
+	cc->scan_file = get_file(vma->vm_file);
+	cc->scan_pgoff = pgoff;
+	return result;
+}
+
+static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+		unsigned long addr, enum scan_result result,
+		struct collapse_control *cc)
+{
+	struct file *file = cc->scan_file;
+	bool triggered_wb = false;
+	pgoff_t pgoff;
+
+	if (!file)
+		return mthp_collapse(mm, addr, cc);
+
+	cc->scan_file = NULL;
+	pgoff = cc->scan_pgoff;
+
+	/* The scan found the PMD folio in place: nothing to collapse */
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+		goto retract;
 retry:
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	result = collapse_file(mm, addr, file, pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
@@ -2789,8 +2825,13 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 		triggered_wb = true;
 		goto retry;
 	}
+retract:
 	fput(file);
 
+	/*
+	 * A PMD folio is in the page cache, whether the collapse just put it
+	 * there or found it: retract the PTE table, and map the PMD if asked.
+	 */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 		mmap_read_lock(mm);
 		if (collapse_test_exit_or_disable(mm))
@@ -2805,6 +2846,28 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	enum scan_result result;
+
+	result = collapse_scan_pmd(vma, addr, cc);
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+		return result;
+
+	/* The collapse takes its own locks, so give this up */
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+
+	return collapse_run_pmd(mm, addr, result, cc);
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2947,10 +3010,10 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 
 	lru_add_drain_all();
 
+	collapse_control_init(cc);
 	/* One policy for the whole pass, so every table is treated the same */
 	collapse_policy_khugepaged(&cc->policy);
 
-	cc->progress = 0;
 	while (true) {
 		cond_resched();
 
@@ -2981,6 +3044,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			khugepaged_alloc_sleep();
 		}
 	}
+
+	collapse_control_release(cc);
 }
 
 static bool khugepaged_should_wakeup(void)
@@ -3177,8 +3242,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
+	collapse_control_init(cc);
 	collapse_policy_forced(&cc->policy);
-	cc->progress = 0;
 
 	lru_add_drain_all();
 
@@ -3235,6 +3300,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	}
 out_nolock:
 	mmap_assert_locked(mm);
+	collapse_control_release(cc);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-- 
2.54.0


