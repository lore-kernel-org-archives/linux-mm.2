Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EE0FCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 17:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446876B0006; Fri, 29 Aug 2025 13:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7846B0023; Fri, 29 Aug 2025 13:50:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D396B0024; Fri, 29 Aug 2025 13:50:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE1E6B0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:50:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E16785825
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:50:30 +0000 (UTC)
X-FDA: 83830534620.07.9BEA26A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 716ECC0002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:50:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JMVFL8NC
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756489828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJyQ9DdqRon/Ac0j0yFdaCgdVenbgK/swZVKOAGTdm8=;
	b=CbI7zjctn1sg7l2VOhzr28fIpq3ch8HZCm/JMbVgt7ySLPOl+UMuI1P6BBy1CTSWr0umn9
	6bmdJCvxr3nAoY3QUJWoG2tuiJzZtR5pxA2e4936HfAU2sQQbzsUjXQHVHNPOfpnEzAmxv
	4oBZp+JChTCEArwGadWjTxRTOazirfc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JMVFL8NC;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756489828; a=rsa-sha256;
	cv=none;
	b=b8LAnXFPIozTtXC8GNIVNC6071HkE1oWHTri9tTvE8fLSCAvdCznYyMvb4+dNdHoAEFmXT
	dMNOKaTGN8qlb8LO+dSelLGL0T+R0sfNYV+tG5b5tMeFOUPLuLBl/k+c0oULcreZaaFPq6
	65RPHXSgCqljd51Ta8ai/4IkJRe53gs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=gJyQ9DdqRon/Ac0j0yFdaCgdVenbgK/swZVKOAGTdm8=; b=JMVFL8NCJY/P0RXkEC4Q6YU89J
	SNxDx40cvfqfqVUWssoEUDHzbfF6WeI3L/ASu/4M+Nlo0AIAd33x+eO44+Ooh3BMQdZNZB6UPi3o0
	UgYPZW1Or/ZNcjVaP5gPQQ0wXKLr21oGAp52J0z6dO+wFJuiVqTZV+CU/wIi76RpJUGAHQHHwMkio
	qK9Gkf09cBwtne/793zSuFfhFZR3IyleQuqZ+dejkjNxRlshCiPBkLHvghuHK2LLqWfDS24XSt+Ux
	yonFhqiLzZW0xT9nON4NftD0ue3xhAF4efl8RVZ40nlVWqLdRj18Sajy+LGQvjT2/014aEizIsU+w
	CSd6+R0Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFww-40uC;
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
Subject: [PATCH 12/22] slab: Remove folio references from kvfree_rcu_cb()
Date: Fri, 29 Aug 2025 16:47:16 +0100
Message-ID: <20250829154728.3397606-13-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 716ECC0002
X-Rspam-User: 
X-Stat-Signature: 8qzd8tj9ntxpupqdz183bx9r8rbark1j
X-Rspamd-Server: rspam09
X-HE-Tag: 1756489828-81645
X-HE-Meta: U2FsdGVkX18P5LPTQ9M86cos2BlpH1ZtTTFKIC3oVP4lA47gzVAWQE14jc+S+JxhIorcJ0VkwX2zQ0THbqe45KE04twXP8EN9+B3P9WOmtisHBdx65DzXDtsz/idn0fS+BKltXYv+3vPyDXho4DH+2xXh6y6YsQTwhl4sWWOPISScwBBjOuhmXN/nni0RmSZWcuFAMYXL4SnFS/9acpu7eknFyRQWJTGqfu89dFFItNVBOwh/zSkAcgKt0Qz7cPP6WtrqlNC7KxLS9x0uLLbqk2utH0IqE9J97qH/D+9jg0OCcoaS313rBFjDeiPywtjWVVLTVTHzsXR8wIWlULOKEyW492w4Tqv6m0i7SKD/HY3frZPS4v7XcWmTCUevFXPFs8AU26biDa1T74cVYEXBuZAs4IUkxxJ9Iqb+Q5QQE9UqBeGBJA3UYPkt3+J5S+fO+CxhihuHcB9L7Xq0OTMzINiWQNHj/BX9omemD4GtA/mND3Pzfst5zlA7qDlN858c8DEJE77I5Tl6cfsDuQJjlYWpINJpjBbd59TliV8QRgfk2YD69ICh5wlPw2YNeny9M5G4q3PSmQolHXLqRMXRsl8AyPJMBoHEz5sbmQf4kw/ixoBoRjU6uCaoky0dIoWBgTOmRz/wthzTg92GnlOdxtlWlcae8iu4tSA0LBeXxjinLEd4tSLfQInNM0ct9IwoTj+K8x5k0G0gn/f08euvpIkKptgEWd1/jE/+JsgzpKUWxfwMmHl4oSv75MsOY6OJiRv1Gup7hmHDKYGBfexQPtKYhZSfN12vg5G3SJrsJ/GF2pR7YpNPLwUixHXj/KreyLvfnewdS3JzJ8v8nzGTN0vCOdF3pYyWBQpC1C13xzVgHjcbHCr5QWXb741khZitoHv7Zy6bCLsKrkTeMsdq0XRMlCRQ6WpsRYQNoSgdvxB4eLI7AwOE9LWiucpLHBwjZ4L5Sl+vjCi0joIePj
 cYPhAzO1
 DXq/qW8xa97xJy3ck9FXNXtN5Hn119KYQotPPVR+c/SjAeZJncwJpDuAe7qY2482JOjtnyfWJf+cMO+BiXA1Bh3WCuscN7beUAKKneVMQt34w1qY9AZCLbdIon3yvIB1tVsQdzWZafsOsoEVNROoL7PIsoccAvnmz5DD6lRaGpXTeflQaa7sO1Tul/S74zTOMPMzqNe/fVhX2KJDi1/Fn3PWMF69aiZTKugigBkb2ZrtGsl732g8d1Neg9oTO7IHUP8y8W20w5u1VIgM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head()
for large kmallocs.  This has a slight change of behaviour in that
non-vmalloc, non-slab, non-kmalloc pointers will now cause a NULL
pointer dereference rather than a warning.  We could add that back if
really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0330f7f21ef0..b344cb0ee381 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6224,7 +6224,7 @@ static void free_large_kmalloc(struct page *page, void *object)
 void kvfree_rcu_cb(struct rcu_head *head)
 {
 	void *obj = head;
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *slab_addr;
@@ -6235,20 +6235,20 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		return;
 	}
 
-	folio = virt_to_folio(obj);
-	if (!folio_test_slab(folio)) {
+	page = virt_to_page(obj);
+	if (PageLargeKmalloc(page)) {
 		/*
 		 * rcu_head offset can be only less than page size so no need to
-		 * consider folio order
+		 * consider allocation order
 		 */
 		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
-		free_large_kmalloc(&folio->page, obj);
+		free_large_kmalloc(page, obj);
 		return;
 	}
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 	s = slab->slab_cache;
-	slab_addr = folio_address(folio);
+	slab_addr = slab_address(slab);
 
 	if (is_kfence_address(obj)) {
 		obj = kfence_object_start(obj);
-- 
2.47.2


