Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9172EC83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22FEE6B0098; Mon, 21 Jul 2025 16:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206966B0099; Mon, 21 Jul 2025 16:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143C06B009A; Mon, 21 Jul 2025 16:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3D906B0098
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:46:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAEE610B0CE
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:46:26 +0000 (UTC)
X-FDA: 83689454772.20.63F8F56
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3140A140006
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:46:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cmg47XtR
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130785; a=rsa-sha256;
	cv=none;
	b=f/t9cs/DM8PhZdBB1vUTlYwoMAMxsCgiXXpBDTSWNT1TSp8B69OQWjrThadV6yTUOnMDcP
	hcAs2mxL0Nn3IMvT591EVYRzygdI9Y2qXlAZc+tdjZg1a/tRgVAELz2YIPv+jTmCz6fq/H
	cgPxrydXxMmicrBag4alG8rDNWbFpNU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cmg47XtR;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5gvso2s+VoajEmfGpzQ+NxfLY/p5U8zPq+da+4rZmQA=;
	b=cKbC2UO791l9k8/VzqkaM6bxZcnoR4IAmzjIMKTDXODojEgdbjHYJEJFXEHCa2nsJIfAS+
	09oDbyLw7TPLNU/LdOOQFcAsBTFomelsV01u1Trjv3Iu1Ih6E8UfPjeW3bB5NOHidGvuOP
	vMe71T06eze7TtyEwyg+lA2BlpeUEiw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=5gvso2s+VoajEmfGpzQ+NxfLY/p5U8zPq+da+4rZmQA=; b=cmg47XtRUn44ysP8cRNpRCT+Hm
	2OKvJM4NcbpXpVEVEtZM4IFTfO9Gsbtzpw+tJgYyNnsq8nRFAQ6OsA0XbUjsbjO8nNdEJcmQFSlUb
	ntw6kfZn6H9WDciHkXHaxF1NLJOzcoolsasg+IT0Sl+jMBzb95xXxq92t40v1ldNY5t76BTS7Zu4k
	qu3gliiq4Gpf6JJX24wSWEhvaDw46GvGHhurYgROJGSNpyHGsGwIbIlTZqaGYu7OXRymiFQELChjV
	fItgjjdtBT8fCHkKu/YMnhN3CgAFPQp0HIHyKfk1oqCeyjCreiIwL8TD0C5V/2TLtEwCS70hx5nbN
	DCm5Lzzw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1udxOv-00000000gfU-1Zzw;
	Mon, 21 Jul 2025 20:46:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] mm: Remove grab_cache_page()
Date: Mon, 21 Jul 2025 21:46:18 +0100
Message-ID: <20250721204619.163883-1-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3140A140006
X-Stat-Signature: bx53yyfc4i3oaibxmtj385nionwfoge1
X-HE-Tag: 1753130783-447740
X-HE-Meta: U2FsdGVkX18UOfGFoXM2tLNvEql3PUKKZQJ4nz+Xqli+b0fArcyHE6rpSrAITCMtos2uJBQGY/77euOiuLePxDfU0jFv7K/XWjVTLA+Q19bcrHZCMiipOxP4Dwln2yL57BgKpqZUBSd45wPNcpyiw69DDPkJaYyUhqSNz+Bg1Wn3RGML5aWAZ9pH4hFkwzQqEsnxx08m+7hxbzDGDROeZLogERh3MvGOpfHAligaB+Jiy9Y2SK2bHAo7EpHOR7KnXbJ/Os322KQvj1uCc3hBvwGsZZXXzX/7ce4L6jWsxfllBKrDjHZeMGtRGi19LzNRjsC26zZpgP56e/qkU9BvpeGu9XT++kAuwkswSmbIeEml3grf0Qnaq4MRkYsvIx2lL9Yh+aUwQv+V9Y0A2FnOheB3Fif8yRVwpopAALAUwlh5O+ZvCbekTGJkCAX6n25QczVMqLC4H7ESgZ1+ibR1V+bd3dj9uG6d9gXkhEPra3yiRl7iXxTjBHmfuhS/d23VejRIxUONDMGoJRLNaceD7Th8wG6CPK55Zdg2kMc/aPfHXj+WOPJ98AqOeIxe2VNw79uqIacpkH1WbDedUC+dsfJ6EC1VvUCUoEmdjG6TELef7bmNvg1usft85+QdUrnTGITZ9Va+YKcZHvbtXHDmjeshNrx9pun+1tHe1quH+eYRRlZYhKyMSjYak82iuXJfCkV7bSaC/z0CCAcMOFGI16xB59I5sX05omDt874325AgifKTQshdgF9KmAx76YqTrTlIWEkdl39hfrWM4BFZkjsycGNEHV6jmjOLp5WUOFzttM1Y7kvZyT3BCC9K4sNwMMggYyJhDZ45CyhWGhv9RzrB+RjIP9fxFoG+6JQh02ci3FTxWKzXs08CChM+EEo+YIguf5paZp2RiCmZ3yk37H3jvNxTI9m4lWseRkSp/gc0knLc6gAGlxPzEG82n/dogH4lvKonhOJRwlMAX1V
 Ipf8f/9W
 7JnvC43YREhESmLLZ4pY7ME1aHz0qpXYxSiTj2qNao7+fJVc6OjcgEts9rA6t2Qbvk53lfTeOyaLy9HfZTPP2aWhxWCfoDKtMwD3NNKwTvC98LCERO83CE3bgvkPUgxJxvxetlIHXPG/GwIB4EI26DaD048wWNyVuDwL6xAMEDeDLiHcfm25GMewPl0zSaDSEenfM5Z1Zf/syFyxi6fLl6UAR2ALhzLhjN8blWHd3xUJuuOPWCesVd8sk0j+CNJ1ie97ChjTagKCJH2E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers have been converted to use filemap_grab_folio().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e63fbfbd5b0f..a5c5af8d70d1 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -878,7 +878,8 @@ static inline struct page *find_or_create_page(struct address_space *mapping,
  * @mapping: target address_space
  * @index: the page index
  *
- * Same as grab_cache_page(), but do not wait if the page is unavailable.
+ * Returns locked page at given index in given cache, creating it if
+ * needed, but do not wait if the page is locked or to reclaim memory.
  * This is intended for speculative data generators, where the data can
  * be regenerated if the page couldn't be grabbed.  This routine should
  * be safe to call while holding the lock for another page.
@@ -942,15 +943,6 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch);
 
-/*
- * Returns locked page at given index in given cache, creating it if needed.
- */
-static inline struct page *grab_cache_page(struct address_space *mapping,
-								pgoff_t index)
-{
-	return find_or_create_page(mapping, index, mapping_gfp_mask(mapping));
-}
-
 struct folio *read_cache_folio(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
 struct folio *mapping_read_folio_gfp(struct address_space *, pgoff_t index,
-- 
2.47.2


