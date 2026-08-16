Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C170EC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF956B0375; Sun, 16 Aug 2026 18:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CC76B0378; Sun, 16 Aug 2026 18:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF236B0379; Sun, 16 Aug 2026 18:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD7776B0375
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C13B12051E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:35 +0000 (UTC)
X-FDA: 85108618350.15.8B6D143
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf18.hostedemail.com (Postfix) with ESMTP id 732AD1C0002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="p 4USo8N";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Qhx8ktES;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XhPXvryxg5fpsuZkpieQ1Un5AH038hbB+W7T9Aoa/s=;
	b=pjJYKpPznvTzSCTHspda6oPcwUuwFTf3iqA4RvU6Bq2V/TGGFE6SZwL20UWWbji1K7q3jt
	3N7bShAESQVkOaZlVmV0Amx87MPCZveq/wY3b2LBO+Wr8BBH2mAfRchiGK6/RlgQUNNgZa
	BVGIIasD3kSj1EsTEgjyCnMEWU8m6bo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="p 4USo8N";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Qhx8ktES;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920393;
	b=LlipPMRqfrAzWQOerroCPjfPwqAu12hKIm0YLArXLxaeAoVXFxTJ4qj1JMJPXtLshyUzFd
	ODUvadgwTMRkygjwl0uwCvGK/fr0a1TDI7NMKffQAGozJ1gGoP5PG0wY6fvteA8msMslIi
	PcwqA8Z73BOBEuVEnXVwC0LJwTW65JI=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 10E7BEC0241;
	Sun, 16 Aug 2026 18:46:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sun, 16 Aug 2026 18:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920393; x=
	1787006793; bh=8XhPXvryxg5fpsuZkpieQ1Un5AH038hbB+W7T9Aoa/s=; b=p
	4USo8N9/+B5/dIGGB8UZK3mvOa5tz05SY2zXme+4ezgXIb5PS9VjAjOicaRhtCW5
	95dF04FTD/SLLZHhVVpSvn87U24l1Ii/ViYCLIvUUoHwNLsyHGUcnU8+0vYmuZnV
	502aXAXVXT7bAfLCGrZ1y9np0XapvqWNaOaKRhAWPB/pxdOxlnOfBhdwdfyq5epK
	H1hR8/siemyvyEUrUetJvOnYU3jRYFp2R86xQbPwGeTH1pqveyStgZJ9z42kAtbq
	WQ8/jHAk6PzTfCCzNEYX41l5GTH8o6KnY9konMzLX30on9Fn7U7umcuhjzlJk3Q+
	njpbqTTf8UseR0OPVIWrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920393; x=1787006793; bh=8
	XhPXvryxg5fpsuZkpieQ1Un5AH038hbB+W7T9Aoa/s=; b=Qhx8ktESQtz/mufMN
	pHMdTjo47SG2Zg3B4+ysZ+o26OxTe5JUrqwUF6Gf751BtExE1XB4/4ANROgtIqaa
	mxJtXU5cwmm9KAuQW8PtKm4jrNH3C5zXNbUPNA8VOD75+eVgTVLq0hU6O6kOeiSV
	NouKdzqyAABI3+bT+8b9pfN6dZBZEovMcCyuAkUquAwUPohgaytbkUhr+F5DG6j/
	bhRVd3ehj/dPhTVzJwnC9qBe8MNYFmwn+CRvjmgg6S8PUmugc+fpBsmNU5Alb4tW
	Gv0jcu54m04uBcU75FO6N+FVboxZbucchY7e5Y6pqOaQfLP4fUa2vH9smOICFDUB
	qbBMw==
X-ME-Sender: <xms:yD2CaimxSoHsoLB6EVxAqLxVTaY8J3yErMCW3D6UH-5BqPW2QkK6Vg>
    <xme:yD2CavJ5N9LMXFVK1Fq3F15pexsuseU-ELVjPa3JGy3S7Ws7rqSx4i6mp6oi5cZ61
    fdGyNN6MBGVWTbg_8Xdyx9GYML-gqF7tCzE3x1XDOxOW6xaYMh7bUaB>
X-ME-Received: <xmr:yD2CastPFP3ky56YN0qPu-v4BPOG23Jwt_7EsFIVMXIdFr7GdSDGeSkfLG8>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtfW
    NEpLu0J2+1AtombAx/oKQAUo4FdAqIyUBygKONCIsIuzHn0ehaewfPdQc9JRA72ZVjUcvT
    NN0yVeiW9iRHbQYdFkF2m3zJxcH+dpN3/rKfytNUy69Sg+2VSptJPgM26K/k2U4bFEl7EU
    690xUCzQ2LJrxar1DAPsq7zqzyyluJwuIcx9Z841gYPLj1lJoDte6VWlNqmUvxKKp1BwlP
    FLEH3ulX8mo8toqp8ngqwN6XZKd6wxD+06z8GoGpI2LzwWCTbBUI/s9vlIEsR3N3tn75UR
    b2ROg4E02kVetP8D1V/XH9Rhum6U9QIMIrGTLJxUGQ368Ahd/W1KjD8NSZPA
X-ME-Proxy: <xmx:yD2CajI-B3jAybRfhYHpZVzn8jTGKyrBQ20U8zUj-JVlplkukelNHw>
    <xmx:yD2CanGob07kLNnwYKv02i3zaATxy3vi-yovk6H8w61CqvrUXXz9hA>
    <xmx:yD2CanRcDQ1dSN-5BgirfpMFCi3th-A4SN3lIZjdJVVW0EzLoaescA>
    <xmx:yD2CahXqeL8a-9gCmp9qdI63jY-jY4NsKey1Q5p5ft6RRVT4Xq-uXA>
    <xmx:yT2CasnV-FrNd97dBrFOXFnov62LH7AeZI3wr_DmU_fzPzlv5XVwgJPE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:32 -0400 (EDT)
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
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 08/57] mm/collapse: scan a table for what a collapse could use
Date: Sun, 16 Aug 2026 23:45:20 +0100
Message-ID: <20260816224609.308019-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: y8narkb35zccxjq9jrggjbgyapxqwn51
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 732AD1C0002
X-HE-Tag: 1786920393-497433
X-HE-Meta: U2FsdGVkX193FbSCHJcz1QlkD+FCk7pYbHTg+Azvi+7QfwJ1bTH5HE6pe5Gf+fc2WUjyH8JzLqjBo7CF3mnLv+00rDtieG5nTM7ViRzMLr/gXlz7hCjLutLnKlpG5qVKgGRvdvMK44T/XybhHdPbd/wRJBLjtuZ+UIw1G/nucYj4+q3BYuBidG9SSeU7329Or7Wi1XsX8DcoaYtbTprSJ4ccQ8k+gL8Ft9RJ+fqr9HP0uSwypnbDeCw9dzj7EpDzUO65TlsvpKTnvEyIqqsaRyCgQpuhID5+Dg+XsSy1GxDm77gdL3JQxD8OWy7240qC/vsjcPnfh3x18yXc29tFh/SUKwUhnNYEkwiEnDU7xsFfgy8fMYwlSYckEwQzMygF5rmxNRW5zdW1wQXNRDANWJtqUcTfyHVnLLPQ3w0KbnfgOkGKi4K4jC9jYh+3EwThusDmWSXJ5x5FneFL9uVLZ9O2XxGvi1z4zG7sfMj+ysPuAFojCMn2swPgSF/PVgWv3gG/2sD3HSIeRx1c+6cEnLxkzfGUlesAj32HDPrYjWREAPO1j9Glw9zqJef2qh3qR8PWV2nkg0+tp3dgcAEPAvOHms2PkcGz3jtj8Q58pqFcSJaS4hc9Qzp//t1tguU8dGvo+Z5ndPXrAgDMXC34ZbUMONwi0SlEVvyfzVsEOTZbYtD+dMnArDrINjQOkBv/9Z4/CXSqHy+2Tg67i0S9t2F3sPGlst+ZTbLzGGlyO9OqB6pRQMSajCeNr5QSuK0T4pkslTBMWb/dvNHQDqfgGnswhIcoBkHwbcbvPJrM7j2dND3OjUmGO5AkSDblW8xkvz5+bKu0ajooGGMtI/Dz4CU4CvS6ZJmh1UdJMcMZOKT/irCPk3lYfrnT6skA2Qt/cG9EayaEv3ICTn2l1849m8/EVSYULi5tWv5YL4M0vmpT2ba+uE46Cf5FcHBqDSAyLec05S8v9OeDsNpYT2x
 aeqIzZt+
 Yc4sfDDMwe0TgrHfjku6G6bRT7LhPdbiXFCP14kYhdxQ7z48jY6TAahemduddlBUch6H3mAZhWD/qjPFJ0gP7vAajO3lwvyFSqK3y5zhI/lpVm/m1LDypewi0cY5p1mslAhxaVYnSxqvV38qbGVUwKj26uzU1D9xEOPdcwej1kDK7IhLKsjvVUvsJifSJPDup25wwGWYWXoDDPgVvXTNBAHp0n1d6DXf35kiR/2otmozSKyTw5OoAzhkwp6mgx7OfyqhXT5z6KsZ/rHvIuuP9KLtQv/rlkMSqNxRmGkOJsro+y+YChpz4qO4IzFVmTm5ApHwcTJ3swrqkIInAehvN2CQyNwHuw5urGWlgg8ZVE6T+vypjHiAqvc9G9SdFs3GbfIpVZzSEE0MaySXqDcw+xOQdctz9ZYDYujMqbFtyJBfkL+3eDOgHv8nItuCMYfw4rgWXdu5NSFb3BNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Fill in the scan.  Walk the range and set a bit in cc->eligible_ptes for
every PTE a collapse may take as a source: present, anonymous, not
uffd-armed, on the LRU and unlocked.  The bit is set last, so a PTE that
failed anything leaves it clear.

The walk takes no page table lock.  What it produces is advice: the
freeze settles every question the scan asks, by re-reading the table
under the lock and freezing each source to the count it expects.  A racy
read can only cost a candidate the freeze then refuses, or miss one the
next pass finds.  What it buys is that a fault in the range does not wait
for a walk of the whole table.

pte_offset_map() holds rcu_read_lock() until pte_unmap(), which keeps the
table from being freed underneath the walk.  mmap_lock keeps the VMA
attached, without which free_pgtables() could free it without waiting for
RCU at all.

The verdict is two-sided, which is the point:

 - A PTE that disqualifies only itself leaves the bitmap clear there and
   drops the PMD order, since a PMD candidate needs the whole table.
   Selection still gets the smaller windows that avoid it.
 - What refuses the table as a unit -- a limit the whole range exceeds,
   or sources spread across nodes too distant for one folio to serve --
   leaves no order eligible at all.

Limits on swapped-out and shared PTEs are stated per PMD and scaled to
what was actually scanned, so a partial table is held to the same density
as a whole one.

A folio whose reference count its mappings do not account for -- a GUP
pin, say -- is left to the freeze rather than refused here.
folio_expected_ref_count() wants a folio that cannot change order while
it is read.  This walk holds no page table lock and no folio lock, so a
folio splitting underneath it would have its count read for the wrong
size.  A reference of its own would not help: that stops a folio being
freed, not split.

Whether a range has to look used at all is the caller's policy, so only a
caller that asks gathers the young/referenced evidence.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 239 +++++++++++++++++++++++++++++++++++++++++++++++-
 mm/collapse.h   |   7 ++
 mm/khugepaged.c |   8 +-
 3 files changed, 249 insertions(+), 5 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 0e6c3c68b44c..66931ef6a6d0 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -86,6 +86,20 @@
  * replaces, and is switched over once both halves are complete.
  */
 
+/*
+ * Is @count past a limit stated per PMD, when only part of a table was scanned?
+ * Scale the comparison to the table so a partial scan is held to the same
+ * density as a whole one.
+ */
+static bool collapse_exceeds_limit(unsigned int count, unsigned int max_per_pmd,
+				   unsigned long start, unsigned long end)
+{
+	const unsigned long nr_scanned = (end - start) >> PAGE_SHIFT;
+
+	return (unsigned long)count * HPAGE_PMD_NR >
+	       (unsigned long)max_per_pmd * nr_scanned;
+}
+
 /*
  * Scan the PTEs between @start and @end and record what a collapse could use: a
  * bit in cc->eligible_ptes for every PTE that may be a source.  Returns
@@ -97,7 +111,230 @@ static enum scan_result collapse_scan_table(struct vm_area_struct *vma,
 					    unsigned long end,
 					    struct collapse_control *cc)
 {
-	return SCAN_SUCCEED;
+	const unsigned long pmd_addr = start & HPAGE_PMD_MASK;
+	unsigned int max_ptes_none, max_ptes_swap, max_ptes_shared;
+	int none_or_zero = 0, shared = 0, referenced = 0, unmapped = 0;
+	enum scan_result result, pmd_result = SCAN_SUCCEED;
+	unsigned int first_offset;
+	unsigned long addr;
+	pte_t *pte;
+	int i;
+
+	max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
+	max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
+	max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
+
+	/*
+	 * No page table lock: what this builds is advice, and the freeze settles
+	 * every question it asks by re-reading the table under the lock and
+	 * freezing each source to the count it expects.  A racy read can only
+	 * cost a candidate that the freeze then refuses, or miss one that the
+	 * next pass finds.  What it buys is that a fault in this range does not
+	 * wait for a scan of the whole table.
+	 *
+	 * pte_offset_map() holds rcu_read_lock() until pte_unmap(), which is
+	 * what keeps the table itself from being freed underneath the walk;
+	 * mmap_lock keeps the VMA attached, without which free_pgtables() could
+	 * free it without waiting for RCU at all.  Nothing below here sleeps.
+	 */
+	pte = pte_offset_map(pmd, start);
+	if (!pte) {
+		cc->progress++;
+		result = SCAN_NO_PTE_TABLE;
+		goto out_no_table;
+	}
+
+	/*
+	 * The bitmap and the selection offsets stay relative to the table:
+	 * natural-alignment math needs the table-absolute position, not the
+	 * position within an arbitrarily placed VMA.
+	 */
+	first_offset = (start - pmd_addr) >> PAGE_SHIFT;
+	for (i = first_offset, addr = start; addr < end;
+	     i++, addr += PAGE_SIZE) {
+		pte_t pteval = ptep_get(pte + (i - first_offset));
+		struct folio *folio;
+		struct page *page;
+		int node;
+
+		cc->progress++;
+
+		if (pte_none_or_zero(pteval)) {
+			if (++none_or_zero > max_ptes_none &&
+			    pmd_result == SCAN_SUCCEED) {
+				pmd_result = SCAN_EXCEED_NONE_PTE;
+				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_NONE);
+			}
+			continue;
+		}
+		if (!pte_present(pteval)) {
+			unmapped++;
+			if (collapse_exceeds_limit(unmapped, max_ptes_swap,
+						   start, end)) {
+				result = SCAN_EXCEED_SWAP_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+				goto out_table_refused;
+			}
+			/* Swap entries armed with uffd-wp are refused too */
+			if (pte_swp_uffd_any(pteval) &&
+			    pmd_result == SCAN_SUCCEED)
+				pmd_result = SCAN_PTE_UFFD;
+			continue;
+		}
+		if (pte_uffd(pteval)) {
+			/*
+			 * The huge PMD could be marked write protected when any
+			 * of the small ones is, but that could deliver
+			 * userfaults outside the registered range.  Keep it
+			 * simple and refuse the PTE.
+			 */
+			if (pmd_result == SCAN_SUCCEED)
+				pmd_result = SCAN_PTE_UFFD;
+			continue;
+		}
+
+		page = vm_normal_page(vma, addr, pteval);
+		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+			if (pmd_result == SCAN_SUCCEED)
+				pmd_result = SCAN_PAGE_NULL;
+			continue;
+		}
+		folio = page_folio(page);
+
+		/*
+		 * A VM_DROPPABLE VMA keeps the lazyfree property across the
+		 * collapse, so there is nothing to preserve by skipping.
+		 */
+		if (cc->policy.skip_lazyfree &&
+		    !(vma->vm_flags & VM_DROPPABLE) &&
+		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
+			if (pmd_result == SCAN_SUCCEED)
+				pmd_result = SCAN_PAGE_LAZYFREE;
+			continue;
+		}
+
+		if (!folio_test_anon(folio)) {
+			if (pmd_result == SCAN_SUCCEED)
+				pmd_result = SCAN_PAGE_ANON;
+			continue;
+		}
+
+		/*
+		 * A page counts as shared if any part of its folio is, which
+		 * bounds the cost of CoW-breaking rather than the count of it:
+		 * collapse_faultin() unshares on !PageAnonExclusive(), a broader
+		 * test -- a page whose fork co-mapper has exited is
+		 * single-mapped, so not counted here, yet stays non-exclusive
+		 * until a write reuses it.  Those are the cheap ones, reused in
+		 * place.  A page that has to be copied is one this test catches,
+		 * so the limit does bound the copying it is there to bound.
+		 */
+		if (folio_maybe_mapped_shared(folio)) {
+			shared++;
+			if (collapse_exceeds_limit(shared, max_ptes_shared,
+						   start, end)) {
+				result = SCAN_EXCEED_SHARED_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+				goto out_table_refused;
+			}
+		}
+
+		/*
+		 * Which node the sources are on decides where the destination is
+		 * allocated: the one with the most of them wins.
+		 */
+		node = folio_nid(folio);
+		if (collapse_scan_abort(node, cc)) {
+			result = SCAN_SCAN_ABORT;
+			goto out_table_refused;
+		}
+		cc->node_load[node]++;
+
+		/*
+		 * Usually a folio somebody else is already isolating, whose
+		 * reference the freeze would refuse anyway.  Not exact: one
+		 * still on a per-CPU add batch reads the same, and the freeze
+		 * drains those before it starts.
+		 */
+		if (!folio_test_lru(folio)) {
+			if (pmd_result == SCAN_SUCCEED)
+				pmd_result = SCAN_PAGE_LRU;
+			continue;
+		}
+		if (folio_test_locked(folio)) {
+			if (pmd_result == SCAN_SUCCEED)
+				pmd_result = SCAN_PAGE_LOCK;
+			continue;
+		}
+
+		/*
+		 * A folio whose reference count its mappings do not account for
+		 * -- a GUP pin, say -- is refused by the freeze, not here.
+		 * folio_expected_ref_count() wants a folio that cannot change
+		 * order while it is read, and this walk holds no page table lock
+		 * and no folio lock, so a folio splitting underneath it would
+		 * have the count read for the wrong size.  A reference of our
+		 * own would not help: it stops the folio being freed, not split.
+		 *
+		 * So leave it to the freeze, which reads the table under the
+		 * lock and settles the question by freezing each source to the
+		 * count it expects.  What it costs is a window selected here and
+		 * refused there.
+		 */
+
+		/*
+		 * Every check passed: this PTE can be a collapse source.  The
+		 * bit is set last, so a disqualified PTE leaves it clear.
+		 */
+		__set_bit(i, cc->eligible_ptes);
+
+		/*
+		 * Whether a range has to look used at all is the caller's
+		 * policy, so only a caller that asks gathers the evidence.
+		 */
+		if (cc->policy.require_referenced &&
+		    (pte_young(pteval) || folio_test_young(folio) ||
+		     folio_test_referenced(folio) ||
+		     mmu_notifier_test_young(vma->vm_mm, addr)))
+			referenced++;
+	}
+
+	if (cc->policy.require_referenced &&
+	    (!referenced || (unmapped && referenced < HPAGE_PMD_NR / 2)))
+		result = SCAN_LACK_REFERENCED_PAGE;
+	else
+		result = pmd_result;
+	pte_unmap(pte);
+	goto out;
+
+out_table_refused:
+	/*
+	 * The table is refused as a unit -- a limit the whole range exceeds, or
+	 * pages on nodes too distant for one folio to serve them all -- so no
+	 * window inside it is eligible either.
+	 */
+	pte_unmap(pte);
+out_no_table:
+	cc->select_orders = 0;
+out:
+	/*
+	 * A PMD candidate needs the whole table, so anything that disqualified a
+	 * single PTE rules it out.  Smaller windows that avoid the offending
+	 * PTEs are still collapsible, so drop just that order and leave the rest
+	 * to selection -- dropping it also lowers the order selection roots its
+	 * windows at.  MADV_COLLAPSE has no other order enabled, so it is left
+	 * with none.
+	 */
+	if (result != SCAN_SUCCEED)
+		cc->select_orders &= ~BIT(HPAGE_PMD_ORDER);
+
+	return result;
 }
 
 /* Everything a table is judged on starts empty for each table */
diff --git a/mm/collapse.h b/mm/collapse.h
index e2af4c47cb60..ad88b91d9a72 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -130,5 +130,12 @@ unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags);
 enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
 		unsigned long address, pmd_t **pmd);
+bool collapse_scan_abort(int nid, struct collapse_control *cc);
+unsigned int collapse_max_ptes_none(struct collapse_control *cc,
+		struct vm_area_struct *vma, unsigned int order);
+unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
+		unsigned int order);
+unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
+		unsigned int order);
 
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 26d25093260b..9823884a83c9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -305,7 +305,7 @@ struct attribute_group khugepaged_attr_group = {
  *
  * Return: Maximum number of empty/shared zeropage PTEs for the collapse operation
  */
-static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
+unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
 	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
@@ -341,7 +341,7 @@ static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
  * Return: Maximum number of PTEs that map shared anonymous pages for the
  * collapse operation
  */
-static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
+unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
@@ -362,7 +362,7 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
  * Return: Maximum number of non-present PTEs or the maximum allowed non-present
  * pagecache entries for the collapse operation.
  */
-static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
+unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
@@ -934,7 +934,7 @@ static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool collapse_scan_abort(int nid, struct collapse_control *cc)
+bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
-- 
2.54.0


