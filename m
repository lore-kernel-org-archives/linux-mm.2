Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40E5CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E828E0012; Mon, 18 Aug 2025 02:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE846B00C9; Mon, 18 Aug 2025 02:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE2E8E0012; Mon, 18 Aug 2025 02:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3477D6B00C7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:46:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1171138FA7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:36 +0000 (UTC)
X-FDA: 83788944792.06.81602D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E16D40002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHwvojO5;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHxW3qwIF/Ofo5/PK92JwnfUWazELyG7oJdOM561dZY=;
	b=jBw/BEs947b8yFHaCP8ryrXyBqtHpij8/Zt6V5jZDr92iN9GkEbcioERkBg0R9LY0jwXNP
	fECYQwjBQyb2yu8bJlRSppBy+6YVNgOPCchQGhtJ5I4ziJ1yGlm6j8WvTpWZxA21aBzTes
	jZG5QTzxIIzjMfI68RrZmI8I5rl2dYk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHwvojO5;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499595; a=rsa-sha256;
	cv=none;
	b=8BPdDmGHMeaFXKXyt8QrUcHUBpnjs+Cpbi5UWzhmLWjSsKh4stEHJJcUXAcHwF5nI7oiE3
	HSR5aEvZ5EVBKtVA/w91fNUKJZVpt0KUme8UK8RBsABqcE8mSdGxmQ2Bzwdrvzi8yvz6wR
	J5u2ZtTaKuwIdKBVQsTXoBOR8+Ecxo0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2510344E63;
	Mon, 18 Aug 2025 06:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96028C4CEED;
	Mon, 18 Aug 2025 06:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755499593;
	bh=DisL+u0A+oDt7cK+lZ4T+ubCByoMEuH39AEZRCnBWcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHwvojO5ZNQ/vIbqTX2n+p36PC7eGEFq5CKUCZcbcf+pDLqlU5qIAkSNiv7MO9IzM
	 PQ+YPYOTEmQ6eW0FZFl5PgCJQQZ/kBct1QG9lJweWjnLh238X+HGsXGJpWZaxA+ZAT
	 ysCq4vtiZoiCv5ENtSwG7GMkrUD0nlaTBdMdsKdNF2YkXz4Tt0TIHQXjaqMxIgK6py
	 D3LwtTcQRZpsR7d7rN2my9k+45XHP9FfmM3HzPbEUET+rQG1IBYvvNkkrDWZgchm7q
	 ktz1nk2n5SFzJXxJljWaJUdV6ZUj3gw6WBkd3ccgikDjUGIGuuFIfEkDt8zXNC4ewp
	 B63YizXPZVfYA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH 3/4] mm/mm_init: drop deferred_init_maxorder()
Date: Mon, 18 Aug 2025 09:46:14 +0300
Message-ID: <20250818064615.505641-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818064615.505641-1-rppt@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E16D40002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fmqcf4jtrtpmbq1q17rgkj55ynj8i5re
X-HE-Tag: 1755499594-324499
X-HE-Meta: U2FsdGVkX1//GiXs2BWMLOwkmMWq8QybJzc/q+vu8PfIKlfG0zG6whWf1LcQceTIhVZv/TSJpuSryY5lszRyh4JZ2wgNObusBMNIBcSU45ofK9WqcJmNAMQm/L/Fh4r0XCg/K/uKlnsmjZUqMlXMEyzgWq3k3KurCSz+IdxflYcf7r85nxdzpXMUM/aqOl/hNKGRLbOu4EJ5JqyTiZsv7OuL2L6qXYVvJUS6w5XkxSisEee26zp0ZHBOMp27GZbiqIduawVaLDN42p8xwjXY+p5fbRkQQg4GjQmgCOPPFGYayoM2IcZydecI86qFvjOJ3Gxa+uXV0y112S5Xwu5EZMsyN/brf4Yno9pVU4KOafjub8e9JyjInIkft7A1/uJ6YJYpSE6EBxV9N+4vdnr00QvyeCrb1ky5oWd4eLwIbz5LIye4J26OTLU+c5UGV0aUlUmEQ1zgCBGXJVLRej9QRsCC/AtSUzLRkzyBYwWbHGVf5AXKSH3tMLtD1bC/Oky6iSInJncGr9J3BX23AM7JO9VSHszm4kjLUzKnfJ2vSUj8GCcaOIPlWslS14W7GgTdEWh7jDiCPaxOrwMEDwina63C+Fbbdy9lcr1ANJvLHTRxfaIJlqhkEId6XOfHzZqUvqEEsW4sIFxJjAT/8AC773YMND1pJLagmvK8HO3BAkppC+IKZ5ushCHvlCi8zfTyNd7iryce7fC6AYSBnyQa9XI7mKCpk52FTqK3uI2VL1eDzI0imEWZVgR4rBps0qPSHmiRgl6w4tRv+LMcHh2qzOztvujhMNgP4ZTYAhd1Ag0ilpGAn71SGtsQyw/ER+ZNfUNunbwNWA8C0X/uU59YKo5Ae8HgAqsZGYryPSjrkf5d///EZIVNPgf2O1ObtHVUlzGoWd7b0TamZ4GyYB1mYg5VECnDJMwvcz+0+W4CsSr7U7zBMrerqKEZwQoZKbstneiOKI2L7duYjLYqP+z
 FzNEeAU2
 15AGRsAH0O4J7C735noIIl1k8CNiohlK/qFZzYHKUy6GmUBkobGYZDHRkEpUdcZc7pBmtSI3kwrG/twz8VgU/QeRCGXuQuFS3TNRfdxJAJbb/L2Se9fkRwkC8qmosnkdwhehSdqW7H1pe0x/FumFdKl/IdvWb8okg3WL/teSi/j/Ys/SpzkDR2ooo5jB+qa0hQCTUHBZToda1heUzlptQYFe2doo2sWmIrQWLBo4SN3k0jed9GGEWmZDGWLMd8F8ASTXdYVpsfN+DGQJ0ja1f8RdMcaQJntNpInCnQlSEYGahP+Tpwf8vnXpqBhEAYjCOz+xtN9mHz34cIIsRnSe6BRNNSfRapmSncYqB387GHzviaOc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

deferred_init_memmap_chunk() calls deferred_init_maxorder() to initialize
struct pages in MAX_ORDER_NR_PAGES because according to commit 0e56acae4b4d
("mm: initialize MAX_ORDER_NR_PAGES at a time instead of doing larger
sections") this provides better cache locality than initializing the memory
map in larger sections.

The looping through free memory ranges is quite cumbersome in the current
implementation as it is divided between deferred_init_memmap_chunk() and
deferred_init_maxorder(). Besides, the latter has two loops, one that
initializes struct pages and another one that frees them.

There is no need in two loops because it is safe to free pages in groups
smaller than MAX_ORDER_NR_PAGES. Even if lookup for a buddy page will
access a struct page ahead of the pages being initialized, that page is
guaranteed to be initialized either by memmap_init_reserved_pages() or by
init_unavailable_range().

Simplify the code by moving initialization and freeing of the pages into
deferred_init_memmap_chunk() and dropping deferred_init_maxorder().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 122 ++++++++++++---------------------------------------
 1 file changed, 29 insertions(+), 93 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1ecfba98ddbe..bca05891cb16 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2046,111 +2046,47 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
 }
 
 /*
- * This function is meant to pre-load the iterator for the zone init from
- * a given point.
- * Specifically it walks through the ranges starting with initial index
- * passed to it until we are caught up to the first_init_pfn value and
- * exits there. If we never encounter the value we return false indicating
- * there are no valid ranges left.
- */
-static bool __init
-deferred_init_mem_pfn_range_in_zone(u64 *i, struct zone *zone,
-				    unsigned long *spfn, unsigned long *epfn,
-				    unsigned long first_init_pfn)
-{
-	u64 j = *i;
-
-	if (j == 0)
-		__next_mem_pfn_range_in_zone(&j, zone, spfn, epfn);
-
-	/*
-	 * Start out by walking through the ranges in this zone that have
-	 * already been initialized. We don't need to do anything with them
-	 * so we just need to flush them out of the system.
-	 */
-	for_each_free_mem_pfn_range_in_zone_from(j, zone, spfn, epfn) {
-		if (*epfn <= first_init_pfn)
-			continue;
-		if (*spfn < first_init_pfn)
-			*spfn = first_init_pfn;
-		*i = j;
-		return true;
-	}
-
-	return false;
-}
-
-/*
- * Initialize and free pages. We do it in two loops: first we initialize
- * struct page, then free to buddy allocator, because while we are
- * freeing pages we can access pages that are ahead (computing buddy
- * page in __free_one_page()).
+ * Initialize and free pages.
+ *
+ * At this point reserved pages and struct pages that correspond to holes in
+ * memblock.memory are already intialized so every free range has a valid
+ * memory map around it.
+ * This ensures that access of pages that are ahead of the range being
+ * initialized (computing buddy page in __free_one_page()) always reads a valid
+ * struct page.
  *
- * In order to try and keep some memory in the cache we have the loop
- * broken along max page order boundaries. This way we will not cause
- * any issues with the buddy page computation.
+ * In order to try and improve CPU cache locality we have the loop broken along
+ * max page order boundaries.
  */
 static unsigned long __init
-deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
-		       unsigned long *end_pfn)
+deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
+			   struct zone *zone)
 {
-	unsigned long mo_pfn = ALIGN(*start_pfn + 1, MAX_ORDER_NR_PAGES);
-	unsigned long spfn = *start_pfn, epfn = *end_pfn;
+	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = 0;
-	u64 j = *i;
-
-	/* First we loop through and initialize the page values */
-	for_each_free_mem_pfn_range_in_zone_from(j, zone, start_pfn, end_pfn) {
-		unsigned long t;
-
-		if (mo_pfn <= *start_pfn)
-			break;
-
-		t = min(mo_pfn, *end_pfn);
-		nr_pages += deferred_init_pages(zone, *start_pfn, t);
-
-		if (mo_pfn < *end_pfn) {
-			*start_pfn = mo_pfn;
-			break;
-		}
-	}
-
-	/* Reset values and now loop through freeing pages as needed */
-	swap(j, *i);
-
-	for_each_free_mem_pfn_range_in_zone_from(j, zone, &spfn, &epfn) {
-		unsigned long t;
-
-		if (mo_pfn <= spfn)
-			break;
+	phys_addr_t start, end;
+	u64 i = 0;
 
-		t = min(mo_pfn, epfn);
-		deferred_free_pages(spfn, t - spfn);
+	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
+		unsigned long spfn = PFN_UP(start);
+		unsigned long epfn = PFN_DOWN(end);
 
-		if (mo_pfn <= epfn)
+		if (spfn >= end_pfn)
 			break;
-	}
 
-	return nr_pages;
-}
+		spfn = max(spfn, start_pfn);
+		epfn = min(epfn, end_pfn);
 
-static unsigned long __init
-deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
-			   struct zone *zone)
-{
-	unsigned long nr_pages = 0;
-	unsigned long spfn, epfn;
-	u64 i = 0;
+		while (spfn < epfn) {
+			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
+			unsigned long chunk_end = min(mo_pfn, epfn);
 
-	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
+			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
+			deferred_free_pages(spfn, chunk_end - spfn);
 
-	/*
-	 * Initialize and free pages in MAX_PAGE_ORDER sized increments so that
-	 * we can avoid introducing any issues with the buddy allocator.
-	 */
-	while (spfn < end_pfn) {
-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		cond_resched();
+			spfn = chunk_end;
+			cond_resched();
+		}
 	}
 
 	return nr_pages;
-- 
2.50.1


