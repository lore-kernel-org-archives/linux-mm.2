Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622C5D232C5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 04:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8116B008A; Thu,  8 Jan 2026 23:13:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D986B008C; Thu,  8 Jan 2026 23:13:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB316B0092; Thu,  8 Jan 2026 23:13:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD416B008A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:13:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3948B140334
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:13:58 +0000 (UTC)
X-FDA: 84311107356.27.8D6BA92
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9BAF8140009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:13:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kQl5H4In;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767932036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GmujxOz21XBVqECrt5MKDbprhNozHecJEQBjQMqnv84=;
	b=lPUgOeFuzY0a44wcuZ2tHPmCttcvYL1ozaVXGchpU3nIaAp5fsZXjRQtJOtMgiZm8BIQPO
	/TVcVxTHF3aTzVuxiOe8zbm2FHQwmmAMAiFAyamy6jjuKDksIuJqX+DQUOtJJM9N5oibsd
	aEzsqawEa8y4R57KxamId83V34ZTX7U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kQl5H4In;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767932036; a=rsa-sha256;
	cv=none;
	b=7gkmurmxxVED5truHKRD/jxAKk/mVwq22Xm5zaFrRnldwON7pPtF4jjAbMFYhZBD3kSmki
	+r7nSgXPrP87VgeK12ZWEg9VTRJvx4vvVGSwNxIienrSgxe62f+2ZWanoyn9P+rkg5TDM/
	Azo2h3i7o9dG5SKB0lwLoqo22XLDoYk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=GmujxOz21XBVqECrt5MKDbprhNozHecJEQBjQMqnv84=; b=kQl5H4InFzUKaaxfCrrs66cwFI
	3Ec9UtNGz8lsLt2U5EaWTkbtdWZe9+SMG2Rub8Lkl2AaKogRINwTmq+UyKaHuOW3Ma4JGMSATwZSy
	rK38A0ygTNXqwzdIHSHEqqfaaZEPh8nsyJ5ORy8zFkM2NfUvRHVh2d65XnsD7R+vwNPaJ+TRZmLqU
	EVgorOcJUTCK8Ybgq6aiXW5981YNuyhsG+qtzLRChkDDNxPDmh1NLKzCZsYPMwLgVxS0vFR80NJpK
	818WpgFjZmatsqQGDj3qNYiQ7WNGS/NwdTX5oD9JSLAvoqaQzXCc7BcBn8RBufd6WxK+N4IAA73ek
	kw4x0emQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ve3sh-0000000GCyA-2yr4;
	Fri, 09 Jan 2026 04:13:47 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org
Subject: [PATCH 2/2] migrate: Replace RMP_ flags with TTU_ flags
Date: Fri,  9 Jan 2026 04:13:43 +0000
Message-ID: <20260109041345.3863089-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260109041345.3863089-1-willy@infradead.org>
References: <20260109041345.3863089-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BAF8140009
X-Stat-Signature: 1e7zgnxwdx85t5qnz5yiufqpnfmgmjxk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767932036-708305
X-HE-Meta: U2FsdGVkX19qJgZzIaYG3XdXUD9Bw9zidZqpACNPuqktbL9LSfWsMXsDE4MLTsIjk3Rr5HWzmD201+TcLdvmW0mBTG8eBphrdCe4SFuqotRNKRi6vpBrJnpDTKJz8mMUSqULqDV6HlgOc3VDqNlZOGD7v8oy5GPTIcj9iIkgPnZNY7DsQ1yipBAjWhEBjdV8OLa0D5FAjTESz68MBkT5xXdRIJpKsHXWCB2J+1pRyF2iCcWaFctpq/6O1nP5WbXQAf1duWZpjt+W7Ax4uf7ffW3y8e9IIzSyHKMSn3uD2I1ELWcoBde3Xb0QKFHqHJHaWAmMfbJqbzGzAPmtkkk/nOIGGKoDBE39qcSFLYe9jijsT5J6qrix2t6hCh7QGVuGOS5tZbBC/b5ST4NAoYNmeysSCHt40erzqWGfht7JsoWpR6RN6PkxH7mb7fMdLJJkRiWEQ663sne5MKbP2JJwQixJ6Fek/Cn+5ldftB1uhayWW5aJQ8rqQ2rscgtWDa5wBsmAMukMof+tdqw7JBEBGU1fNw7H7Z742dIphdZEsMblA5aGBH+yun4AnknUflNoulU6gkxZWKXfXxJuy95fw1UMHFEEdYggyb8zTJGy+cFGXTz/APK+0oNrVBOKMDPROrg6Yluo3DTQbfua8fgDpyBiaJchqLzkgwPt98+1tQrj+WViT9IdBnDVmdKr0MVeDUwomjn3944lzs3ggSbB6SCd48MaI+ClKDlz5xXbgxhCCC/1/dn0O/aqe4oTOy9+1efm7YU8v+D2OiKAaYAJoqB+g/iltrGHhkPerDozlD5tdK/Few2fx5Ipak57Jxy9y1j3yhMuqlVe7s4THw/OsAno1AXQorwy/UFYfHlO840TwlQnA8uDDgQEz8ujlUw2Cd8TRJBNdH/iSZj8mKVp7SSQuFnJj4Tq237U/dHJFq8aVsrYE7UXRXTY2Zwt8R60LKZBJSL+5XzZmRnQ7at
 jhBc9xyS
 lCI2nuVdITabUuF/vYGVUQqf0qMGqSrtfXbYJKRDXYjiKQPElGMStxLm+Ri9zeGuoqG9lIDvxq5LJBDQNGK4E1iLiyC6yKhsHcVEy3S+f8Idg9ToFEE4CujH427AMQx8m96sExfKufuYuv8jwE1fKWHKLYUUsXYbppEtxpUhqGyMlqF4Jp/SnQYeU70Y5IrLkfcVsR/NfcDnrHgnQNgSArElpuu7SAKzt/C9FSWN/4zSHTt93e58hFhuMIQCQsCGKAPcJH8HgLpQDsMw/9RGbBrqnvLRnfJVPEGvjRd9Ulf3j4DG9o2/xIEE7ee+WogY3/5wsJLOgaMhWdQ4gg/jyS/9kmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of translating between RMP_ and TTU_ flags, remove the RMP_
flags and just use the TTU_ flag space; there's plenty available.

Possibly we should rename these to RMAP_ flags, and maybe even pass them
in through rmap_walk_arg, but that can be done later.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/rmap.h |  9 +++------
 mm/huge_memory.c     |  8 ++++----
 mm/migrate.c         | 12 ++++++------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d..7afc6abe1c23 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -92,6 +92,7 @@ struct anon_vma_chain {
 };
 
 enum ttu_flags {
+	TTU_USE_SHARED_ZEROPAGE	= 0x2,	/* for unused pages of large folios */
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
 	TTU_SYNC		= 0x10,	/* avoid racy checks with PVMW_SYNC */
@@ -1000,12 +1001,8 @@ int mapping_wrprotect_range(struct address_space *mapping, pgoff_t pgoff,
 int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		      struct vm_area_struct *vma);
 
-enum rmp_flags {
-	RMP_LOCKED		= 1 << 0,
-	RMP_USE_SHARED_ZEROPAGE	= 1 << 1,
-};
-
-void remove_migration_ptes(struct folio *src, struct folio *dst, int flags);
+void remove_migration_ptes(struct folio *src, struct folio *dst,
+		enum ttu_flags flags);
 
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..44ff8a648afd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3431,7 +3431,7 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
-		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
+		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
 		if (i >= nr)
 			break;
@@ -3944,7 +3944,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
-	int remap_flags = 0;
+	enum ttu_flags ttu_flags = 0;
 	int ret;
 	pgoff_t end = 0;
 
@@ -4064,9 +4064,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
 	if (!ret && is_anon && !folio_is_device_private(folio))
-		remap_flags = RMP_USE_SHARED_ZEROPAGE;
+		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 
-	remap_page(folio, 1 << old_order, remap_flags);
+	remap_page(folio, 1 << old_order, ttu_flags);
 
 	/*
 	 * Unlock all after-split folios except the one containing
diff --git a/mm/migrate.c b/mm/migrate.c
index 4688b9e38cd2..4750a2ba15fe 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -452,11 +452,12 @@ static bool remove_migration_pte(struct folio *folio,
  * Get rid of all migration entries and replace them by
  * references to the indicated page.
  */
-void remove_migration_ptes(struct folio *src, struct folio *dst, int flags)
+void remove_migration_ptes(struct folio *src, struct folio *dst,
+		enum ttu_flags flags)
 {
 	struct rmap_walk_arg rmap_walk_arg = {
 		.folio = src,
-		.map_unused_to_zeropage = flags & RMP_USE_SHARED_ZEROPAGE,
+		.map_unused_to_zeropage = flags & TTU_USE_SHARED_ZEROPAGE,
 	};
 
 	struct rmap_walk_control rwc = {
@@ -464,9 +465,9 @@ void remove_migration_ptes(struct folio *src, struct folio *dst, int flags)
 		.arg = &rmap_walk_arg,
 	};
 
-	VM_BUG_ON_FOLIO((flags & RMP_USE_SHARED_ZEROPAGE) && (src != dst), src);
+	VM_BUG_ON_FOLIO((flags & TTU_USE_SHARED_ZEROPAGE) && (src != dst), src);
 
-	if (flags & RMP_LOCKED)
+	if (flags & TTU_RMAP_LOCKED)
 		rmap_walk_locked(dst, &rwc);
 	else
 		rmap_walk(dst, &rwc);
@@ -1521,8 +1522,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src,
-				ttu ? RMP_LOCKED : 0);
+		remove_migration_ptes(src, !rc ? dst : src, ttu);
 
 	if (ttu & TTU_RMAP_LOCKED)
 		i_mmap_unlock_write(mapping);
-- 
2.47.3


