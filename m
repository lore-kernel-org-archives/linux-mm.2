Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 267CCF531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8657D6B0098; Mon, 13 Apr 2026 14:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8161E6B009E; Mon, 13 Apr 2026 14:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7532B6B00A3; Mon, 13 Apr 2026 14:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FABB6B0098
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:43:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09F54E2F8A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:43:24 +0000 (UTC)
X-FDA: 84654405528.10.A637117
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F446100008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:43:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Mhxaednr;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776105802; a=rsa-sha256;
	cv=none;
	b=AvjaMqNyPjBQiQkdDTXG1BnKXva/4ow28OR0AiF4LuSryFSTeS2UfxkHPMaWwZXp5J3GRI
	ZtRHBzgP9IpK3IKJUJnY3p/iJckmJEPGFjXMWyBvAscY+myMAYynWEa0eqt0P98TSpstqe
	nWzLiwFIMt5MoPu/hFh4VRMV3W3HfX8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776105802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7+dnmsOeh6AHqg2BhNW2UdgF8EdFnZSC7APgeVGJlpg=;
	b=wveTdj0bjBRtT7yYps/57lPrcyOPfCRl8kHAOS9NQ+P88JyDVhKAKuvyobfxBjkUg4pSKY
	XFAmqQYIJRwri9gQnLTKgz2J3i+i5OTZfBSxfhF3JY3pH8TANRI97hbHNyz+MnZbxGtOsd
	2Wql4S5qhcPheLXlgnRAt4Q1lLCt6vo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Mhxaednr;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=7+dnmsOeh6AHqg2BhNW2UdgF8EdFnZSC7APgeVGJlpg=; b=MhxaednrwdG+RPq61MKq1e/UmW
	FV41IdAWLXwizrThta5K0oncE8BD/J8z4GvuPpbmGK9Pv1muKA+VQuUrbOtCQeEuihMNChHI4EW5H
	1t5jGMSUGGYnkizBuCKlXETLVRH64DWCVwUpLX9/fHLxjNL6lGoC84kqnVa+0rfuTiutbkgFNSEkg
	2coY2kgJbXER1qJKaP8XcWaXAKO0TIXw4TsLNN3/GqezimYRKZltRjSsDSEXBMnkP9IjPS28pal+F
	KWd3s1SQGi7Pk635NRfHlmo1IeQPUeg5wIYiC5LfLPsyAugUytIVw62lhkFrknUjUeuodaoCHf7M0
	TyVNN0ew==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCMFj-0000000ELgf-0Jru;
	Mon, 13 Apr 2026 18:43:19 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org,
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-501448199@google.com>
Subject: [PATCH] mm: Call ->free_folio() directly in folio_unmap_invalidate()
Date: Mon, 13 Apr 2026 19:43:11 +0100
Message-ID: <20260413184314.3419945-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F446100008
X-Stat-Signature: 98sd4q7z8ek3dp38cfm43746j8upcu1b
X-HE-Tag: 1776105801-301872
X-HE-Meta: U2FsdGVkX188RmSv6txL3w1vUJfVr0/QcWshghfjSdrvVmKNExmXdsB+h5Vjvqd1D7LDxZ9LXV5f5whKfbN9AgD9NHQh/dhCn2LdGvPUSxLlcLV6vLv5SZD/W8WrQSqofXcT2oFItCn6HbNaCBiPNn9o28NmOkhaB46hbcml8FoVhsQ4JJUwqhnw+RLL6LWE5wuNTzZ0Y5Tascc1cugJ0D2uXjixa5gbzvVq2lHxgnCzRi+h8QIH7PuTUpr1kKccxr9Em0AsrdzPjkQ4rMCqxGy0q8bmh8xCZl+xQdNeo7NvoQlwnkG+tHv+kSSvsUtX1r83AH4/pZRCbPfL+/up/QCvE0T6g58ZIoQkz5wHBupvtufHOqOPxR7ZaW0AUuOSRLSiJZaQpADYWW5bIx2lkdwUguJ/gbiao3PfSeGQRbXj2JAjDq07CUPuz2wZ+GWeSUNJfTHWQ9Bi5B6GRsLKiR6FGXvNdBdLoNZ9Mqfr/MD5wT5S9tnJaaC/z0ZnKRy+1r8slXb3tHBYEdgwh9dizSdbGaR+6f8iGyDQSF4S8h3He5rpS2I/0AsKpe1TYRd0WlpsbhpjjNyC+mfFQyCeARdStwHS/vWyjpqlMIrog08dXAOWxAyWDR7stR3jh2eWa+AhdKgb64/HYTv+rUbaxXroNvXiuuoLPcybAtfGpJzjTSRKSM33v+oW9+MVMKR6WczYu3euGz1kOqMBcO+UbNGiFeELNozutg6qEs7DZYxKPWslyuPVjz269Nt1RHzZuaiJSCrQ8JoPBH3cmdy29vBbxwpYfd1SJbCPNC1HE8oQ37YmYidYuN2AcSOHIG6TkHH+/QiGU8xq88kfCUIA7gZSz1lTHUv/oe8JVFTdLSud75vQ/USwVzW0tHxLRUlVu4tqWKD7wWALLV1wiqWkWdT1Dv7M6jioBxFOnymSgrEfNI7KjWI7iqsdZSVwvF+VG4YrAuKbItnbKuMpadM
 mp5c0Sxj
 aatw10W3FraYS8rWDrzSbGUsNR7KNNW+1WDNA0BuC6/t89SejnuuI7s+O00gv9K0AsUvCqGY/jAYDymu/xR2246GYg9EdFFS61HD9ZLFPnoBr1vtMUjPYxCxdqkoYoXFg7kTLHsi6w6khZj+vjmb1zaVjeI5JYglMyoYFX9bRFaVM+ZQka0OUAU62u+e8LK4ckqMHiFEiAXPyl57ViJTB5ymrXcvE+mkdqEegGHE30zLCcVKVpuSG/v99V1NvnlvrYVuofpWMfMiq/dTJ1jdTC6gVEk66o+Lvu80COO0bGW/FP4BSvz/g3hWKNKgZYFs6+jewxf9wRymQHuP6T9gKhqmiwjsD5WYF0O2thlHbbOyChrHNzOTAZvJi+dC+Xr8F5MFJH+hWgebalStedKkdGbkmzgo76X65kWGzldj+uWUoQLjJQ80/OTl22br3Mj2khMPN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can only call filemap_free_folio() if we have a reference to (or hold a
lock on) the mapping.  Otherwise, we've already removed the folio from the
mapping so it no longer pins the mapping and the mapping can be removed,
causing a use-after-free when accessing mapping->a_ops.

Follow the same pattern as __remove_mapping() and load the free_folio
function pointer before dropping the lock on the mapping.  That lets
us make filemap_free_folio() static as this was the only caller outside
filemap.c.

Fixes: 4a9e23159fd3 (mm/truncate: add folio_unmap_invalidate() helper)
Cc: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-501448199@google.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c  | 3 ++-
 mm/internal.h | 1 -
 mm/truncate.c | 6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 406cef06b684..5a4fecb24257 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -228,7 +228,8 @@ void __filemap_remove_folio(struct folio *folio, void *shadow)
 	page_cache_delete(mapping, folio, shadow);
 }
 
-void filemap_free_folio(struct address_space *mapping, struct folio *folio)
+static void filemap_free_folio(const struct address_space *mapping,
+		struct folio *folio)
 {
 	void (*free_folio)(struct folio *);
 
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..546114d3ee44 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -540,7 +540,6 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
-void filemap_free_folio(struct address_space *mapping, struct folio *folio);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
diff --git a/mm/truncate.c b/mm/truncate.c
index 12467c1bd711..8617a12cb169 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -622,6 +622,7 @@ static int folio_launder(struct address_space *mapping, struct folio *folio)
 int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp)
 {
+	void (*free_folio)(struct folio *);
 	int ret;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -648,9 +649,12 @@ int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 	xa_unlock_irq(&mapping->i_pages);
 	if (mapping_shrinkable(mapping))
 		inode_lru_list_add(mapping->host);
+	free_folio = mapping->a_ops->free_folio;
 	spin_unlock(&mapping->host->i_lock);
 
-	filemap_free_folio(mapping, folio);
+	if (free_folio)
+		free_folio(folio);
+	folio_put_refs(folio, folio_nr_pages(folio));
 	return 1;
 failed:
 	xa_unlock_irq(&mapping->i_pages);
-- 
2.47.3


