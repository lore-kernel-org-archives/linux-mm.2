Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E15CCD4F26
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463968E001B; Wed, 12 Nov 2025 19:10:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 414488E0012; Wed, 12 Nov 2025 19:10:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCC38E001B; Wed, 12 Nov 2025 19:10:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 155428E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:10:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD9E713B9DC
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:59 +0000 (UTC)
X-FDA: 84103650918.05.5E3F224
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 43F7D1C0005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dAjPiZpV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992598; a=rsa-sha256;
	cv=none;
	b=X2uAIR5XcO2NVTC++PXwYeKmkxkXqAr332UfEhCtCPGCd274d3rHJFu+xCdhMnyu62Ngxg
	RsI+DQ+Wh4YeOpWpWs7AwTaafTfYx41VEEr6EXb8ZXL1P1z3PIL3c9Za0WGya9aqlxeegd
	RQZePWxqOXBhEdMrgNH7WXquUYtX/FM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dAjPiZpV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtGNxsUjQXO67fdJt9UrhteqGNWvnUn7nNOR+KxCJK4=;
	b=GwKiaO7faqA+qWNNajWtDsLho3Qi6qxPdot53748D5P2cgvGUC3lxQfTm4VpJ0RFPcOIVe
	vbW6eIoZxv4WQISjSTfkwHeLUEaV2gABpy/Ep7YoLrRAbcHZcLq7d0NBgj/flAfy4+jXOL
	EjpGeY3mZEtd4Dm08VwjjGMAmKr6tXI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=GtGNxsUjQXO67fdJt9UrhteqGNWvnUn7nNOR+KxCJK4=; b=dAjPiZpVBojVmblwN36oQpvl/F
	4wuYAVUijQIgAhflLz2VN1Wa/E++uDf8ALcUEdWsKZvLxaHnnDDHsA/jIV0rbfxluF/L8UxYj4BqU
	6Nlt0DSDXT1tw6IvmMnEr8lwFwVAFj/zL9Kuc/1FlihQnvPeH0iTLh8cYm66YnRCar5AmNZPKvtmF
	kgJDMC2SoLobruJv4y8fBnnScug+uRtzho1NQwJbqGJUZZKMjHB9u34O1V7OOW9z0uz6OVL/hNciW
	FCkh0e7CyonUylG4inZTbsNhg8hnNbJQhU1viwHBekQodeQASgfr/XVlARQPLAi5DAhhyzn+CCR/9
	0rVjH7Yg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu6-00000006fOW-34V7;
	Thu, 13 Nov 2025 00:09:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v4 05/16] slab: Remove folio references from ___kmalloc_large_node()
Date: Thu, 13 Nov 2025 00:09:19 +0000
Message-ID: <20251113000932.1589073-6-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 43F7D1C0005
X-Stat-Signature: setwnwj6ocb6147kw5w6qykuopa6h6hu
X-HE-Tag: 1762992597-124096
X-HE-Meta: U2FsdGVkX19E9gmt+OnquBJ71mWn5TTFR+/QDUZzoNpx+Ylk9NYVBQZKv9OVrqYtEaoOuD3jeAGOTejNdADM3pSRxXvGJmoPLmiQ8Khda6wVBXb+6yfkxUFIeHPq22r8DhrQnju1ynyAzCzkd51RjwwESP4yON65wr4VvGMFSleKBy9wd0LIcEpJWB4NbmrCn3MJ0IZaw/wuIHpeXrgmGKmFAh2EyFAr4f8MQ54/Gfo7gsOAtmKRg0XYh0rU+t2MpEvRFA0Qr2TdSFbMojK4/UTSAEaZvv5IS4ri9h1pq8QzeN8Lh4PPT4BtEcsoF4Be+PkOlqf+yffAeyS1JjC2IUdRje/n4bXQyuzg0UISEbJWJ2jFigZOxPskvtHhmsKNO7pYXYc4aw/lIVDjRn9LsjTne6xHnvCgAayTjPSoZOVLFBS3hH2g7eHzLqg77l6LE9CSYgnweQOgl51QwwxLv4ebOwkmjfI+g46+GueZZbr1VUz9sTFIyyCGHwloHJeguJZ9aHtWSlOB7wbc7RaWQHebrs0wnTf27mI2bt/9Q10H81sMlDRRWvu6TmR8dEeIzghvTGa97tyS5B1L3WPr6UySjsVb15lmwOzS4Ls31Wo+PVca1XruV1MK2IxvDLfVm9jzhDb9wS3H6L0gehKcoX3A71ms9Vp0VpCkJXrOQRp6Hew5oNL/fT8sCc2MaRbX/L6rqBx+zkp54fFW6HpA056EWuslBBRohWlAw5cl6A1ABs8BbUQInPPL2axDYm6PzIbaNixdibLMNJND1fxcrbec5XRHyIwfxdXzEHVQ+q+ONEar0ZTzxKNvir+kd+sdIjijCkrOqu6vcBbqsRq5gyibe0aJFCr4Vljo0QIlbZw7yUyAhYbk2uUL3ANpDxyjW/z3lKHTZ0WcYUP9o8FTi8G9DrllieeJfV/g+hNW8BeDQnDoPMmDjeJtF5jTmE5LHts4+cjaZQq8nf3zodA
 /Zm3IgXK
 5yVgXPbyUt/KTM4Zu5NlI9ftkP1MxM2Hv8RWUC4OLx2hyhbdCYSxgkZ14mIJmeRvQ/DLUAFQXZvg0fEA5XmByLo7Ww4A5qML8nk2CgqBK6Ox7ogsNdUDmv2FLQ6iZtHBBmje3iTV+rbvBHAyN9y85sTS1+hqQJfHMzou/BCKjPQd3dWNIJ5oDAJcHKttc7riZ0B0D1SL0yeF6S1skgMCiey9+IVh0wLfOxumgPiSWPJiIEl9jHyzE56JtI4Z9WPcWmJwhUu5SCn56WQ09v7TTKQDA0C20ebpJ3W/qbPJWfUWkkpl3lQ/3we8xquwK9Aq3CYFTY9cnhYc3sHY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use folio APIs here; just use a page directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4a093140f985..90c5663f2b71 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5601,7 +5601,7 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
  */
 static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct folio *folio;
+	struct page *page;
 	void *ptr = NULL;
 	unsigned int order = get_order(size);
 
@@ -5611,15 +5611,15 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	flags |= __GFP_COMP;
 
 	if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_frozen_pages_noprof(flags, order);
+		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		folio = (struct folio *)__alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
 
-	if (folio) {
-		ptr = folio_address(folio);
-		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
+	if (page) {
+		ptr = page_address(page);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 				      PAGE_SIZE << order);
-		__folio_set_large_kmalloc(folio);
+		__SetPageLargeKmalloc(page);
 	}
 
 	ptr = kasan_kmalloc_large(ptr, size, flags);
-- 
2.47.2


