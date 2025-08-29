Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378C7CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 17:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0568E0008; Fri, 29 Aug 2025 13:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F238E0001; Fri, 29 Aug 2025 13:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3751A8E0008; Fri, 29 Aug 2025 13:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 230D18E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:10:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8063213A9EF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:10:30 +0000 (UTC)
X-FDA: 83830433820.11.9251287
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id C677C40010
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:10:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oqWhGAkG
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756487429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wY4a6GjZscTKFWhFDFv9d0GjZfYsRNT/CH+bao9oqFU=;
	b=yqI/4rC522YhtjQk0/8QxAnXA+rDgyaJ/EQGuqXlJ79RcmV7skRNLUt8jSI1Opt8tdChZO
	lJHcpXDuIihbBsFGuUyd+HQWTbsJ13boJMwAJHGALMrUHiuHhT6M+bM93jtvNDNvOj3RjJ
	gwCjJ94MUk2WGStr7hpLvKr87YwrcgQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oqWhGAkG;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756487429; a=rsa-sha256;
	cv=none;
	b=mY6yidHJRDf+VIMrgDYOlF/uGdpmKEMlcMizycrTzwEk322vEg/8fk5iiU2a6ekwXDqIV6
	jhC4KMBfp36MmKTr07kLF4WjJF5K0OGLcWatxy6MINYAoEC/KV9PKL7lPpA0lnoIaKuLe6
	zmct8H7/8ZcFlcshlxlzQI/afh0s7n4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=wY4a6GjZscTKFWhFDFv9d0GjZfYsRNT/CH+bao9oqFU=; b=oqWhGAkGIDTYhsh8lH6p6kbh5Q
	sjj+Y+iDKLILHV7pYuEenjl9k0cVtG2i/FZV84B4Js7N4yxQ6DnlZpfgBsxih9NCLQmnghgO4VlcV
	R3cfoRdBTdGH7WM0HABgJp5dWUBodNPlLkd/x4+xojXFOX0Y7KnlTyv83tboig6dWq8+77L+LfMrO
	6rCjiJ4VrW4bAeto35u1MMKbulNHjKnNOH60JAvFttRHKyZ9xxmokidPiSn1qRbogIkZEAgC21ffr
	y/OY55ihLG8ZSPyc5uIVf/ZCUCGi7bZSKi8kkos64bMfeYrRpvA8zO2V+zmKfPWH2eDmBdgh4WYEq
	pDTUXUbA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFwW-2DHD;
	Fri, 29 Aug 2025 15:47:31 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 08/22] slab: Remove folio references in memcg_slab_post_charge()
Date: Fri, 29 Aug 2025 16:47:12 +0100
Message-ID: <20250829154728.3397606-9-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C677C40010
X-Stat-Signature: xp3d4nqs35cr9es8yo5wprspgj61j8x8
X-Rspam-User: 
X-HE-Tag: 1756487428-342071
X-HE-Meta: U2FsdGVkX1+2TWEWqF4wEUib/t4e569V/+lZZALG5sZH+11VSItOZrSjdpkEmbQNWkmHK2UyoteNBryxEtXhtp1T/0yputiSEHUO4Q0h1miI37CjxMrPjQlcEoFQOBDJp7jNcSYsP5ar3dr8R3BO6oez59xpeE2ykreQdNHP3nTWwS2qqsMd++gfwyBBJDlEMyioHhaoC1N1cwIqacty6UOoq+knLjtJh/BVfE58+3FPtiAHN1Zu57NzvDkLmWlXI56y2VhuukyuQ4RpdkNeZhSyg9XlQWMg8YEjMzuCx5gXHHExUIcFHDsEuVwQLcNGdwMgN4Tegj8iFq3KDrPlfTTqjuqn4oUGShJN2lKLcMBFGbDDTgrlKbPrgj/WmWEW5RE1h/uG4/WcdTyBBj+PgTaweMePxwtW8pNf7pk9wTdfFqVPYeR/QSKskDzBcjxoswpsG4/aVQhPVVWcw+hFX/AgNS8qlNkH1GyEmNm2TB2Wr9HXFZDH9YrvNto3TUT5l0PeCxhKfMUNQVY11C5/3AP4E5dKIl6imTX/EXO7Pe7Wc2UFDFNX46fIM40Lap/eD07bHGs4dhokdxAkeX38W/eJwVhl9kjNmvKrFpc9xLLQPvd49F/guk9ywuSXLgpvdh5IYwLkDTvlyigqRsQ6dL173V2d2eFOdBi+YtrZJwmTtXnqeQ3/YXYT0WOKE/vLRER8iVZKRjlQ5luoHcVh27Y+U8dQofzNl7VTW9iSvyFVedKC2+l/k8kKCxecftqocCtYiVhD4eb7MWgCICW8qlXdDpn3ACPa5TOk+jzk16BpU0y6oC4oPn2f88dZbHIIfVuuoq6o4qBeB3AebreVFS5IOK/S8DGhRP3R45b3O9V9L0tBywrrJWSE/efY+PjHqQbLFeN+WUmK1BRP1CrWjmud4n4PubdG6EeR5N55OPftLpFI9fkUNg/o82jwcE+cDJ60aPL/KUu1le4po2J
 MdTpslHg
 RxLEWVq+Gtw9Qr/sN5K8YI9PPNea/gOYxPZhThPKFjrJICjZ/63BjiDDS4qvHSmgS4Zx9sEIPaoHOCCIuqVbb3sPKFqIQlZkQShHq5Ii9F9gLER5X5HzuIbyT2AuXnU2KwUa+3Xji5QggE4y9irk4ICtxoM69eeBGhDxWidwMjFBE+L/vazgeabg3gBKntHxmJdahyHt03uslSR2RoBFeSBgecB0mbi19D8SXjnJChcCT2OJfu63o4NcFIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows us to skip the compound_head() call for large kmalloc
objects as the virt_to_page() call will always give us the head page
for the large kmalloc case.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7b9fb7a88fdd..8d984fb5208c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2299,33 +2299,34 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 {
 	struct slabobj_ext *slab_exts;
 	struct kmem_cache *s;
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	unsigned long off;
 
-	folio = virt_to_folio(p);
-	if (!folio_test_slab(folio)) {
+	page = virt_to_page(p);
+	if (PageLargeKmalloc(page)) {
+		unsigned int order;
 		int size;
 
-		if (folio_memcg_kmem(folio))
+		if (PageMemcgKmem(page))
 			return true;
 
-		if (__memcg_kmem_charge_page(folio_page(folio, 0), flags,
-					     folio_order(folio)))
+		order = large_kmalloc_order(page);
+		if (__memcg_kmem_charge_page(page, flags, order))
 			return false;
 
 		/*
-		 * This folio has already been accounted in the global stats but
+		 * This page has already been accounted in the global stats but
 		 * not in the memcg stats. So, subtract from the global and use
 		 * the interface which adds to both global and memcg stats.
 		 */
-		size = folio_size(folio);
-		node_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, -size);
-		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, size);
+		size = PAGE_SIZE << order;
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B, -size);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, size);
 		return true;
 	}
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 	s = slab->slab_cache;
 
 	/*
-- 
2.47.2


