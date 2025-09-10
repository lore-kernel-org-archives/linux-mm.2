Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B40CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD7C8E000C; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3378E0017; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774858E0016; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47CE88E000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1345D1A086A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:19 +0000 (UTC)
X-FDA: 83873185158.17.02EE28E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D9D840004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sMgw7mkX
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1eXy/jyV38FQHP7c+CCJuMjEoSpSsEX1ydD7JMy/g3U=;
	b=C23mBpKa/kS5VoY7r0zdu5VrwkWF7vNrn6LTuCyW6Cz1ItXU3rMj6mTOHqfAjSn7NFW4Ja
	zeqVTinpbeJFcJd6EX+Yo2MlDdIPHHNdQbMXhb2xpuisV0iFTFuVYMNf+dyxCuQ8epJy3k
	EXOxRhv/dYO8x2iPfeCdIRximGAFOwM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sMgw7mkX;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505317; a=rsa-sha256;
	cv=none;
	b=HaiVj/vrchbfnP2xMD4wxWN1djPlAvFnsRelqmSql6W1IuoG5HhR3J5OyfT1MLuDmJspux
	H0xEONHdGU3zAJwWyk7KhFAbk48uzotuHit94ikgeyRKzbBe4Rezgrh/G2kwZRwey1D+os
	8YBsafHqz4TENV394QsS5NJmY1uAoD8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=1eXy/jyV38FQHP7c+CCJuMjEoSpSsEX1ydD7JMy/g3U=; b=sMgw7mkXq68TSoz5b2MDjVivSK
	Um9ebS2jax0ri5S4ZjvFLNobcY/BDVvhNgoy9mfn+MZ5kxeD4IDB7a3KejqH1yOP663BcrIxJh5Dl
	vkktfhdZDkAV+nT4pSJDBAbPzG0Iqo5IuYrY6HOHlMSAtWVNMMuJs1oBGgHySGI+CFOf1lXE5Ci7B
	u9/RMCa1cbTfJ+LtZwguju/Qo6+MhQdEF/ViEgonuIySVaWyZxpHyEoMNQRSRmy8wWAkzvE9ynMue
	E0TCF04mHPu4afAWT7hO+32DlvSNmF566kRbuqFCde6KCmIQbx8ZM3b5T8r+bB51o8v+ZQdscbTxt
	1mhWzQ3Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MFD-444C;
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
Subject: [PATCH v2 12/22] slab: Remove folio references from kvfree_rcu_cb()
Date: Wed, 10 Sep 2025 12:54:54 +0100
Message-ID: <20250910115507.1991829-13-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ynydtkemhwstqgcmsywe9tx36p6objz
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D9D840004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757505317-154396
X-HE-Meta: U2FsdGVkX1+SjDf7v8LIYO/aI1VFsdDr3hSV+9Js/jVhTTeCWMe+dphI/7vDSSxCjB2EqZuvaC93VkYrCoEEvgFSoSLQFbvCCggYLlOoU6R8eH5IEc1EDFKlqEk72II48hfwxYTXwvjfsMxZ0gss/SxDj6qXG4Ga+EJ0jMxMoP+fu1rVNlo3OpJv2+CvDqS/N2J6MdRCr4Nt0A1S96kjgos/TEpzBSdNIcni5FvpEecpo26dsItRNQOM+e3JoGzJsxtPlJo9NAzZxEUG16pe3yaPbJTGHs4Q26f690lvSTXSIcmuO+XbOFt4RtsmIskzPPH23YAa3uH+ZnUULV6ARwusDVwfRegtQGk8r+8HxmQuSu3BiISNGBwpCLZCo3c1UwN7FEid7VC30Okl5oYLPgc6Z1TLX80iDyuFIPODyZNaPSw0WmaBKYd7Wu5ZBukl3wqOEb2IDAiXmK0kxYhDiqnvicb9KlJZ3D0cFJPrTlk4R6F0F5vbsObIii0YPsGvJumHfymBUMeX2WLb+kDNGQRdf3tZMiouVUe5E+GdLDBX9+t4yz8x4WhkCrfCPj/AQFQBWZFpV49n8iDzHNMxmysJFTkI3LLykNQ6yYaetVInJ1an/52PX22pTuXfg1+bx9oGUqwefC7EbZOPzqVCpKw4BvNjNM5+NUwzfSPHF5I8DDHqC5I7wKPqeHMikm/G0cl2FwUtmXFkliU8h97fYtRFgE0fRtamMfGzULhgggI346co6otqmOTsCK8mr5yVjLzdqOeI0yZitzi073ViXU/HXHlw2IDflrXas+ExN+/JfvbPzARKU4FM4TiJukhHNQ+XFMUfwWUDmTZDfS4XZEvS9iJrOd8w/ZPoSfmZQRfk3TCFX7t/5DNHSDYIQ+omMVSzhoCscRnXFgD5VUN3wDvkNbwigqJBvPaDKfzIwEKYFtAlmyW98PagserHgxmlYcsO8Avp0EbhtoamZVP
 6uNZFyuC
 lZkjKp2IWYtA9vfYexiyD2S6zA/nOw0zImRQJm76Gv5MhIPd8l3WGHHBpNNvcub3590mb99XL52+Hpnta9Tw/To0rUW1FP62w7xcpBjQWRAqEkUu5AADI9WtOxBDnydMEmkuiIqr7mtxM7MqvWf2qdLke8VhZ66MIZZW8deTfHpVgM3+XifHUFL/lClC9RlWroeLIQj7Q0eLWCl3Uiko87LL6FQO3f0Hn4tSwb83PyPKnV2xruZD8QOetT7T5jUj41fuvCcLfcPsi7FY=
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
index 68a013411ff7..547ef6ef4373 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6252,7 +6252,7 @@ static void free_large_kmalloc(struct page *page, void *object)
 void kvfree_rcu_cb(struct rcu_head *head)
 {
 	void *obj = head;
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *slab_addr;
@@ -6263,20 +6263,20 @@ void kvfree_rcu_cb(struct rcu_head *head)
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


