Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B6CCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A316B0088; Thu, 28 May 2026 23:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2AC96B008C; Thu, 28 May 2026 23:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19A96B0092; Thu, 28 May 2026 23:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B085B6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:51:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 589C9141054
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:51:53 +0000 (UTC)
X-FDA: 84819083706.29.03ED1BF
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf15.hostedemail.com (Postfix) with ESMTP id A867FA0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:51:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=deJpLXPn;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780026711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0B/bCGwErREfiHqYBbNLfFiWmSgms7I7OCV4Ix5QlOg=;
	b=nnq2r1LGK6oAnfoUMxMywzKh/5xObgjef8BGKP31fhpttFck+lP59QGkRkrVVFyHGs17Sh
	6XjtuEM306fKveKVUR26aeSIxk7WFfwsj+SHxQVB9E6jX6++KMKnRWKwXfy4I1eGdm+PoX
	ZHoNZ9PhHPYfQd92FW4OCpHHf/E/t7k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=deJpLXPn;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780026711; a=rsa-sha256;
	cv=none;
	b=D7PxBoBjZEUjDQ+n2z8VB1OChcZkUPr1eRkn7jD/+5MiUIcUnamW8meNx31lin4yRnb7s+
	joSOBs1Gq/TZHSFsp/kxN/h2ql+4Jmg/HH0aZ5Zc8vm+7a4Vsu9BjrMt/VoxO84j9mGf1S
	Ds5A+SwPMCwDYugyTD8M2o/nB2y4/jc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780026708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0B/bCGwErREfiHqYBbNLfFiWmSgms7I7OCV4Ix5QlOg=;
	b=deJpLXPnqBZX3xG39KVWI1DoXBwP0OQ8KIFV3yIrnfpDUPnOG5EO2JYevOBV7b+AmSrMHI
	MHD85XCZKUrdzImMMsKoS5+giXII668/nj/LzilMpnAwfy/7rqujGuZxwBvBezg7680b7e
	Js+pdQWpT9Q23nhOI+DpS1qO1qJRD+s=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v3 1/2] mm/slub: introduce helpers for node partial slab state
Date: Fri, 29 May 2026 11:50:51 +0800
Message-ID: <20260529035120.81304-2-hao.li@linux.dev>
In-Reply-To: <20260529035120.81304-1-hao.li@linux.dev>
References: <20260529035120.81304-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A867FA0005
X-Stat-Signature: jwcfjifbtqcxe8f6k3sgp5b779zrihjs
X-HE-Tag: 1780026711-570626
X-HE-Meta: U2FsdGVkX1+5uJhlpMCIMGrC2dHOYlWqmUrvVsj7u1tRv609R1X2ECDNoGXWiEVv2T6d6GW+dM4DLOU8Q3Vx0KV9qBf1q3VoJolNClsfpzciLyJD6w2nwFysst/uXev7y2XFyb7ZPCvNX1bgxTwTPe43VKTl8FHJchtQWzgcm3WOz7w85F5Pkmo4x38MKHJceXpGgs6h6JFJqGZ01AiXfDvlxcm3MXSI1cze5D7m9M/ZXOEbyt6q9mQiP6NlGj9qcTKnTPlt7k6xpAb2Ogu+BadWsugZUcrZLRlSv80Uz1jBxxKNPMM4nfGVWgCjbwDMkKLuXdYfo2DwVYlZuP3lzbGi0C1oRMyXpBmSpPzFf0KDBQY9vDDnFcV3f8rPzSU9Tav7B97Muzv7JvgDzIgUyx/R0aatpWr2PXeY3TVVT3btbQUJwoAARZXwI1YePIMFqAWBDekEQXdoHeDPyuWFNC3Zdgj+2zm28BEklBg75OXVEh0vC8gQFDdaDd7V+ZRgq/jUERkTyGKymW9AuGJF95ynuuOUtKkPoXIimbRuFTfB5+fJ0e6VigbUp0ar5Dv0yHsWi24KI0MTa+PAt9jvhUVOqq177X6pMCwTKNrI8vjCQkV2+8VMsc1j6kxU3t8Lk7avG1an1adKI6kn4Qqt4qTEyR6blZ40YM5LLJYh5Im1+SWPZzCSObLB1M++tZQ6CL7W03mHV9+8c/jHTycNk65C7jc0Dwmw5dpEFLz6YTdkfzcOFtIGKtrNHZD/Mb69I/mLEvljTnzyUfj9UpOgrgo8k5peILjKhqZO1WCVBYkW2X0WwRIfLPIhOZ6Bcw13ZcQuLR2Q9Nz9uxeEhu2R2i1qmEJCaj+xqjZNVeMFlTv8cUqt5Dzy/TXvv9xEuRxwJ4esHqTNyVssLzNtkr+1joJGu3uRVeBeUB12K3c6EAD70Xiiv/FeFMOWU/knt1ZDt7/YdepMoxlLFt5QIRn
 a0PP94k/
 B7/N1fXzrl6lPzyDokjgSbGBuDVyo+XzXE5nB7i9YaO167KDouZ0pdZLfmhqWwttSls/6rUdlOlDKZnrTx874wz2zcpyaMbjZ50GYKBcGO360T5qTOCsgTyDxzt4zvMAvjExG5Kh13O3LLeB/k8vi3+9n4G3cMQxMfsmsqsjoBJlTHBen1Acf0QEVFPd14yivY6OWQ63F/Ayt1b46Lm3HykYu4n8kRLEEPl4aXPmcrLVLWh+fHcNnW2cK34ewZL3rJP5r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wrap partial slab count inc/dec and flag set/clear into
helper functions to reduce code duplication.

Note that __add_partial() is called locklessly in
early_kmem_cache_node_alloc(), but since there is no such use case for
removal, __remove_partial() does not exist.

Suggested-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b9f10b869914..45aa0a834f97 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3521,15 +3521,21 @@ static inline void slab_clear_node_partial(struct slab *slab)
 /*
  * Management of partially allocated slabs.
  */
+static inline void set_node_partial_state(struct kmem_cache_node *n,
+					struct slab *slab)
+{
+	slab_set_node_partial(slab);
+	n->nr_partial++;
+}
+
 static inline void
 __add_partial(struct kmem_cache_node *n, struct slab *slab, enum add_mode mode)
 {
-	n->nr_partial++;
 	if (mode == ADD_TO_TAIL)
 		list_add_tail(&slab->slab_list, &n->partial);
 	else
 		list_add(&slab->slab_list, &n->partial);
-	slab_set_node_partial(slab);
+	set_node_partial_state(n, slab);
 }
 
 static inline void add_partial(struct kmem_cache_node *n,
@@ -3539,13 +3545,19 @@ static inline void add_partial(struct kmem_cache_node *n,
 	__add_partial(n, slab, mode);
 }
 
+static inline void clear_node_partial_state(struct kmem_cache_node *n,
+					struct slab *slab)
+{
+	slab_clear_node_partial(slab);
+	n->nr_partial--;
+}
+
 static inline void remove_partial(struct kmem_cache_node *n,
 					struct slab *slab)
 {
 	lockdep_assert_held(&n->list_lock);
 	list_del(&slab->slab_list);
-	slab_clear_node_partial(slab);
-	n->nr_partial--;
+	clear_node_partial_state(n, slab);
 }
 
 /*
@@ -8271,8 +8283,7 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 
 			if (free == slab->objects) {
 				list_move(&slab->slab_list, &discard);
-				slab_clear_node_partial(slab);
-				n->nr_partial--;
+				clear_node_partial_state(n, slab);
 				dec_slabs_node(s, node, slab->objects);
 			} else if (free <= SHRINK_PROMOTE_MAX)
 				list_move(&slab->slab_list, promote + free - 1);
-- 
2.54.0


