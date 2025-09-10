Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE70CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8A28E0013; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2908C8E000C; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CDAC8E0013; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 042138E0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA424B9CE0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:18 +0000 (UTC)
X-FDA: 83873185116.10.35B5506
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 294A416000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FOuIhKcW
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Xmongdc7DvOZsO2c5OoFPq0TLo5BTBH8w5SjPVE7L8=;
	b=KxKQhU141K/Q8TotqhOYMXgEJBPW7dFj3FXk9diNCXP84qoGnbGF5MRLCD5mVSqbLAVoUl
	8sXJ2aD+whpwN62b4VST26BEZZgpZ92CW7YSx6shj6UMLyM51/NhG4E2mqAL76VI++uo0M
	WGNiI4gJDTgj2+S9eiJzToGG8byLNFg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FOuIhKcW;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505317; a=rsa-sha256;
	cv=none;
	b=xh3YvGfMt1eI1atz/BCZl5WydoIw3AeiGWDf4eFaot6gTzr+2PrCtiD7sx6+BQBd0qMNCT
	dstqQd8KMlzGEEZ/XFDIzfNu/UT60hvm/pLlAQNGs/db/flS1T1FoGWVe4UR6+89LXyBVX
	cTqrFhZYETdgIXM6J+Bjx53+1bt+sDw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=/Xmongdc7DvOZsO2c5OoFPq0TLo5BTBH8w5SjPVE7L8=; b=FOuIhKcWeH9kaRHz88dYHZeW9Q
	tWQnz5aAt+fY/r56SPt9n8hESyIVE0Ipq43OYjHSxcXAV4KPcavELZl97BeNCIdYc0hYd9ugAlNGt
	0AxSo8Yjhkv9mTK+gQXDmvpNJ8n48hzY2F7O8hK81Jx/9KMtjGvXV2SMCFz57FX7FXIO1nA+LSu+L
	lrxAFA/UxR7iVR7KTjljerlzwYCZMvf6oSwXOzBWU6RJ7MNmGmk1vBELr+YutJAkF+3P9muBzggmI
	jrXOXn64TK+Yiq5FasuIFk4HF3WtifnCkpeoF6NSurstSX7cEIGcjFTbHqpI+ZD3DrzJQt3Iy/VvM
	UDtniZxw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MFA-3ftz;
	Wed, 10 Sep 2025 11:55:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 11/22] slab: Remove folio references from free_large_kmalloc()
Date: Wed, 10 Sep 2025 12:54:53 +0100
Message-ID: <20250910115507.1991829-12-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 294A416000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8i4d4quewisp84s93ruw6bhzst7sgmn5
X-HE-Tag: 1757505316-342343
X-HE-Meta: U2FsdGVkX19M/XuV6zBdiHHGVBWOjAu6FCowZmLDcKELZVq9BF05vFozO/jcN9phydyj0vT1E5snC7dTYTwQTcOjgS3sRX1wzz7s7GRHCynrl7HFVLV1GCMKmX9IFNUE9cegniweZV3ENvuLtFEi1YtkuaSQlJGZUFOgI9FKowKLBBejOzTi446DWe064lzs7S/4P0Txlgt3tsBlZ6jmWhzDQ6QLArWlmR4SWpQlFCUJisew3B8l3vFUf+TY6YlhlseZ4F09g5oKgobJ913PKDct+JJkOQZcu84C4D4AKSKky34CYIDcr5xW3zUTBFNQpj9BDWcJ3Opida3yba1BFaqAOH64AJ/M9EqcYJT6DPk56rSWEwa8bDPGBNSayMms4FnpI5RCq8kN011fObknNhkuGj9+ZPwEp4C3g7hVyeIgDc1qjN58kRof1BWfsVLq9kxhvrA8V3wOGrZwU06GcHxj02dTCCdQIMEwMznqrns+anbX9L/w6D4Jbb2lL4MsXuQtDDXXi1Sy173Z5VTRZ6f7Sdi6F+midDNiE9DaZiePzEY5y5+I3GUzg0+KJ8nKLMZ7wZhTHZLBgV0+hVVE2bXK2RxIYzWrlQ8zfvS4263n0rhNyoPUdQvhBKmXbS5f3ddZb0QvHEFcwq/g6w/vtVpEj1OUETxRVY/PFxxpEEVm8Fq2299fpS/gbDEc24gqcss/BajrwqqBTGeaI9ZxBxc7sQmi1Sf2Z1W/kfXtukhWXooXjM5I40m34jq+2514Btxsw3skJBdgjgu43BYsIo3tekfNmQIZxh/aZCDXgZYpVf88TTALqw0kzfvmA5/sj1tbqX8Wcs/Xq7S302151zcqhu0P35WPm7AHs7jEiiHI75PMYjS/oNa1C3d93S2yLwzsqFif0eqgv2eEH14zbbQN0GqCdcldZJI2TdhkyYVea43pTHme0vnJDglPN8cEKafT5Vpbo0LLlKmWEhL
 vD37vK3K
 4DG1YBkSA4QWz3PH17lFBYdcPURr2DFdlne++VqyxfN+Rjl96JBoTTxA8gnBWvtqwY++5VaxSSlb7I9D3CjCEamuP332rPSoJPk3F6Ihfqu8TCgLmveswSFcZebwScCseI7arrtjt1p0BdEHOZoG172u2HQIAcU3u4rFMezznlAfWWnALRAUScAKv8hI09mCpzolF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use folio APIs here; just use a page directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 28f68887ac3c..68a013411ff7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6223,12 +6223,12 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
-static void free_large_kmalloc(struct folio *folio, void *object)
+static void free_large_kmalloc(struct page *page, void *object)
 {
-	unsigned int order = folio_order(folio);
+	unsigned int order = compound_order(page);
 
-	if (WARN_ON_ONCE(!folio_test_large_kmalloc(folio))) {
-		dump_page(&folio->page, "Not a kmalloc allocation");
+	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
+		dump_page(page, "Not a kmalloc allocation");
 		return;
 	}
 
@@ -6239,10 +6239,10 @@ static void free_large_kmalloc(struct folio *folio, void *object)
 	kasan_kfree_large(object);
 	kmsan_kfree_large(object);
 
-	lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
+	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 			      -(PAGE_SIZE << order));
-	__folio_clear_large_kmalloc(folio);
-	free_frozen_pages(&folio->page, order);
+	__ClearPageLargeKmalloc(page);
+	free_frozen_pages(page, order);
 }
 
 /*
@@ -6270,7 +6270,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		 * consider folio order
 		 */
 		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
-		free_large_kmalloc(folio, obj);
+		free_large_kmalloc(&folio->page, obj);
 		return;
 	}
 
@@ -6310,7 +6310,7 @@ void kfree(const void *object)
 
 	folio = virt_to_folio(object);
 	if (unlikely(!folio_test_slab(folio))) {
-		free_large_kmalloc(folio, (void *)object);
+		free_large_kmalloc(&folio->page, (void *)object);
 		return;
 	}
 
@@ -6669,7 +6669,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	if (!s) {
 		/* Handle kalloc'ed objects */
 		if (unlikely(!folio_test_slab(folio))) {
-			free_large_kmalloc(folio, object);
+			free_large_kmalloc(&folio->page, object);
 			df->slab = NULL;
 			return size;
 		}
-- 
2.47.2


