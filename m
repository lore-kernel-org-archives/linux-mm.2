Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B0BCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E5D6B0023; Wed, 10 Sep 2025 10:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72D8C6B0024; Wed, 10 Sep 2025 10:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CC06B0026; Wed, 10 Sep 2025 10:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5010F6B0023
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:51:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05F0EBBF2C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:51:24 +0000 (UTC)
X-FDA: 83873628888.15.E04DBF6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 43E7A40007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:51:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YRpfSUmF
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqLre3PWTeB4kRSfNC3TbMcV7oJKVHsMeYonGSLSboI=;
	b=ULOd9hRpxWF9eUwfQC95+dxOXeA7R0dmni7FFtKbtUFiD8jxikCsvh8vxnbdSQEG4R/KR2
	O3RJLCOP4qeNNhjg/GwP47lcghTXoQ+WTfu4r+hCxWn0TIf1SCcynH8sIG/++ADvbYV9vL
	9ZJrsDpJ9OTE8bzuAWL9/bvrqvLf9WA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YRpfSUmF;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757515882; a=rsa-sha256;
	cv=none;
	b=wifOgWZqINZuHT8DTV3Fzo0RpbyoHwYXeuWwaHVUDBJwPtL7Ynxga8dPLU5CD4Tul2JLmC
	V5PKgDhLHnTTMnAVZ7mGU965DjNdt3qeb7qPNemoiGdT27+odVRqvk3cuMkEGm04aHLyhB
	EjScUKvcRglTA1bFkUzi89aOGWlHo5g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xqLre3PWTeB4kRSfNC3TbMcV7oJKVHsMeYonGSLSboI=; b=YRpfSUmFYB41vmDjm0/6KJ7uev
	MULgxhG0D/W3tUY43YWK6F9wyIn6mN6E+H/a677n9R73eDS2byTlB0hF5n549WKFgEgysQ+UvKBt/
	k6Zj+EEksMjy2M0FvGgDv/qEaOhfJHopleweb04ggd0I3v7dHwEVxdez5KG6QqsRsw9Ee4w51rRKy
	lO5I7RZXA5MejVVXKwRnYcdAoh2vOnxSFvH8swAYgTduQswicy+ijdNU60cXsY4n9F3tiZmjTzjpF
	FPfy2XB7GsZhPj7EaJ5LK3Xn8TNm03VvUFQ1iiehVp8HMW6zseHqHxN4BPb1L4VhXFVglkmGvKxgF
	jJCbKCAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MF2-2x8T;
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
Subject: [PATCH v2 09/22] slab: Remove folio references in slab alloc/free
Date: Wed, 10 Sep 2025 12:54:51 +0100
Message-ID: <20250910115507.1991829-10-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43E7A40007
X-Rspamd-Server: rspam05
X-Stat-Signature: ajpztzgpr4kfws167we88u9hc8bc5dtr
X-Rspam-User: 
X-HE-Tag: 1757515882-462809
X-HE-Meta: U2FsdGVkX1+krxh+YlqtNMg7tOfqTOnLXTs0v8y4b7bienskgwCp7ITsEcPhFYYbZS5qZMyoxIiDS43kXP+UozfCPJBJ6NhUgrRISj5vezIxjYI6cQZjbHTc6ltYnTMeIDi5CQ+857hIC+e+0sq9Jif6HtOTfUwOv6gunSaUCY3em+v1QAFXVm2OFOxNAyvsReomo486LiyJOZi1MzdQwCLN+bQrJD9iGc5eg6oQlAdhNG3p83PqFAHeNvvbeJpUSSJ8DOsjcbdkGZJYFSgoGhPeBHYKRYCE9k3s/+9/XdDC0QEGymSuZP77eC34r6LhNADrtPSw6vUIeD2P2YYU2xcxbCH7q9BXYQAZk8B0OQ8NjGWkOlKkbLSFhKVSH/QJ2sNGcd9HaL7ujr6IcCmFtoHvkUxmM+PBbcOY5eUoKE+EfXUDed8yzst130N03w5J07E7wlQzq28JGvgEnClM/TEQpEtvgfLkVEgGby75UNcRKCQrpImttu4KDfi6+52sZ0ZgkkTpL1OHLyg9h6/Bt6z4EvijF8aqf8XN4QmEf7gwcPKo8dNv9unuPee1y78BU5aI2ApoF5neyyiwVOoy0PRa1aZEC28R1ZiqUKhM9JquF9Fgl+l6YoofHvaIdZY2cuPpWuOX5mUfmgTkvqybAUsKm+AW84TqptgEhIzqLtCM7p1MF79YEyl2VPujQOEf8yUidmzVckYeAeZqQPak+crBzIl9F8Ss+Bzcsg4FQVPWnqjgSxxGFb1L3ek7Cpmrw/GoTOrslD09TE+zqudEMe4NogTsORGiR6cVljrzjRkGGFsw+oykzsML5ToIZUFHIwYOmAVU6yAWAcpNsOcvVT3YnfoTgBmmx6TKXj1DC/253b5+Dg7TDRuk5HaJgIzcnL89S53GCtG9O7svlCEf1YaFSmZD6NvAdIsUbSZboQdpGiR5OPWZKYp7c4Bt4ZmNQsb4ZtLz+1bFZLoqw9R
 p0ea0Ckk
 IvXT56rMJnWFt4Oct9Iw4nltgqdl653rhWwT5hQjyP/ttsOI1XfZyXUbNybrg0wVZCKR8Qzx6W7s8TdTCsKv0jNBRhNnlScQYixFYHK0jLAU60EMEHNEuXTcudFX/IvkKncVlz+7HH8QkKwzqBetkzCN46O1W5aqr5MunMGE2gVzrFlczi4ETlpu8v7VeCx9MekFYERX44uqjq4o0Z9BNhfISrE1TgHpEPV8A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use pages directly to further the split between slab and folio.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9bca3e4b82e6..7973b064639e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2979,21 +2979,21 @@ static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
 static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 		struct kmem_cache_order_objects oo)
 {
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	unsigned int order = oo_order(oo);
 
 	if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_frozen_pages(flags, order);
+		page = alloc_frozen_pages(flags, order);
 	else
-		folio = (struct folio *)__alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL);
 
-	if (!folio)
+	if (!page)
 		return NULL;
 
-	slab = folio_slab(folio);
-	__folio_set_slab(folio);
-	if (folio_is_pfmemalloc(folio))
+	__SetPageSlab(page);
+	slab = page_slab(page);
+	if (page_is_pfmemalloc(page))
 		slab_set_pfmemalloc(slab);
 
 	return slab;
@@ -3212,16 +3212,16 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 static void __free_slab(struct kmem_cache *s, struct slab *slab)
 {
-	struct folio *folio = slab_folio(slab);
-	int order = folio_order(folio);
+	struct page *page = slab_page(slab);
+	int order = compound_order(page);
 	int pages = 1 << order;
 
 	__slab_clear_pfmemalloc(slab);
-	folio->mapping = NULL;
-	__folio_clear_slab(folio);
+	page->mapping = NULL;
+	__ClearPageSlab(page);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
-	free_frozen_pages(&folio->page, order);
+	free_frozen_pages(page, order);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
-- 
2.47.2


