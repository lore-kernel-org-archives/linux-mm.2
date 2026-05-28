Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E7C9CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3FF6B0096; Thu, 28 May 2026 05:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DD16B0099; Thu, 28 May 2026 05:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B796B0096; Thu, 28 May 2026 05:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 40C5F6B0096
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04B6CC279F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:22 +0000 (UTC)
X-FDA: 84816365886.15.FFF8444
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 75B441C0007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MFvO0i0i;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779962001; a=rsa-sha256;
	cv=none;
	b=xt+0+a+JUVGYpteR21M5GJl5/1MfErCDEt5k+24uY5UUPycQzjTTbEMU3dF4W5lYQO4HnE
	IBp5Krs+HkILwDxgV79Gb7X9bc5Mawa06/Z+KdDPcVjoCqt5QAPNwdfTNdDb8gbmjAGzxU
	ZxnUO3P6hcg6sktsWtgL+ko52tuudEc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MFvO0i0i;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Psi/3PdGYQ/8BNVb4Dult2mh9IIeWs6X+I0h1Ys+4s=;
	b=ICnFGQsIeanWRUmztT3XRh3apKBPxkp3yTqAhFnZAPvx39G2ACRYPRfmqWXlshVNeH2PLa
	X/ByBXqCvyseVopysHkr7wI4KIh97nEnGePCVhruk736yDGEJbYioiUx3d7ijTrm7OJ2/x
	lkhMRB2rdtpn0EZOh1Dwd4BKUeVrsxg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779961999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Psi/3PdGYQ/8BNVb4Dult2mh9IIeWs6X+I0h1Ys+4s=;
	b=MFvO0i0i8oD03Zk4F4oBxnrdZN92TFSlALnlmqAM2vtQEzVA/wIphM7iFUXo3AGL8DX/Vi
	oYoArEu82HTsvhp+EMKbRJruB5IbtLZecAJQLrvYDbLL6gedfg7haDTjsHd2AJRxmaiBQh
	iNwwye44gXCxTXcYHgku4EhHyCkwOyg=
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
Subject: [PATCH v2 1/2] mm/slub: detach and reattach partial slabs in batch
Date: Thu, 28 May 2026 17:52:43 +0800
Message-ID: <20260528095254.43721-2-hao.li@linux.dev>
In-Reply-To: <20260528095254.43721-1-hao.li@linux.dev>
References: <20260528095254.43721-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75B441C0007
X-Stat-Signature: gu4cbom4imiii3545bqz3chyhczhegff
X-HE-Tag: 1779962001-560939
X-HE-Meta: U2FsdGVkX1+ueuRl6bgIdh6nTStvPSw+MF6Q0GyzclIb8WGv7dQfHvZJOXcls2Xxj74I7J1dNWQ5izJAeZ4L6re4i1+tCoBPuMHDcXqgrUFOtBgCv0PbgZRYH4f530Cx7vf62+VCV9kV1jPpjlOhH8rxjqzsvYBVoxDZ6ENtm391skU9WalkIAAR+XAEQhVejdOSSQRWW8QRx75Fs/EXAEhb9HqjRm3zsNfAgpav9AkAaI5qBw0wDTgqGUZ15+elDfvE98DvFd5N1Lt4jtgMFqQBuD7wFnDKDGPzFHAdS0J5Xdk5hD8697IfAOJLQ6kjNulV6wA05b0AUEdxy4dR5myUCVd1NqB5lnU0N+Nz0d/F/Bxr1QfPnKwqo9FnBw3hnTSSvtBXTMSdZJpupuTWEdYAiGbmvHELwjw2+wGdUKVbeg+tiTQty29NgMjTrtc++q6VpvkPouNAH9FMUhJiHa3vWXbXGKqaJvwh1raYBGo6KHVCKuc6BAj0Dq2srKuhWi9HxULfS+iaE4pfqV51alVy4Wz5zsdZhhj0idiJNIu436k5oIVIH1zU8Y9h9oD7GExov5byvxtaN7Cg9DZXd7QN0vTobCM21kK7qit9Fgy6bDE4pRr/toWJ3AP4Q/WgSNhar5XHKHEX5weP0k5D3CiOftFJlh+BDu6OoG/JSE2cGt189C6a0lblCCJebCO3cVT04mDLhWiTSH1tE0SKBHgjw7VQeUrR3zzjQKQ9y8FIOkA1LId9TcD0zrj6iJTA5K7Ql2Edm74A5YeoSOTnilom0Pr/SFgGteOWqLIUt364eLi7yM9T4XUrOdDLvUkNUDIH1QOPTMuRXVhjUVD5Oi1x/bYWQrmZ82CTOLmdFq4/egMxI4GfSoF/nP6iwpSQlaI4IZSpSf0nLWrXiPivuIsPltzwjTKd8UrhR2fkaePCNjiz8bevPo3iL+JiMdcVTJJ/cqxitGm8ej4kkG0
 0vTq4uyW
 jRTQVTQ1TwD0zYP2pZY2taI+uyK4kqsTP7EykLGlOF7bJbvfY/3I0ZydLh3y+pNr389dERW5x5ZTnv+PCGEDJrr7KZG9iUn19Lgr18f72pCRmVUHgK8dKZJWTHd3HGKrZOtYHE7zsvyhDyu7C1Njro1bcJRbbrvhDSq6Mq0mkpnRyS2c/R4qZXs3ElP8gJMzOCi6z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_partial_node_bulk() moves each selected slab from the node's
partial list to the local pc->slabs list using a remove_partial() and
list_add() pair. In practice, the loop often detaches several adjacent
slabs. Doing this individually repeatedly manipulates list pointers
while holding n->list_lock, which causes unnecessary churn.

To demonstrate this, the counts below show how often single vs. multiple
consecutive slabs are retrieved during a will-it-scale mmap stress test:

consecutive_slabs_count        frequency
= 1                            277345324
= 2                            335238023
= 3                            175717884
>= 4                           88862337

The data confirms that retrieving multiple contiguous slabs is highly
frequent.

To optimize this, track contiguous runs of matching slabs and move each
run in a single operation using list_bulk_move_tail(). This reduces list
pointer churn inside the lock critical section.

Apply the same optimization to __refill_objects_node() when reattaching
leftover partial slabs back to the node's partial list.

The will-it-scale mmap benchmark shows a 2% ~ 5% performance improvement
after applying this patch.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b9f10b869914..eb60b3da23ff 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3739,6 +3739,7 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 				  bool allow_spin)
 {
 	struct slab *slab, *slab2;
+	struct slab *first = NULL, *last = NULL;
 	unsigned int total_free = 0;
 	unsigned long flags;
 
@@ -3757,8 +3758,15 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 		struct freelist_counters flc;
 		unsigned int slab_free;
 
-		if (!pfmemalloc_match(slab, pc->flags))
+		if (!pfmemalloc_match(slab, pc->flags)) {
+			if (first) {
+				list_bulk_move_tail(&pc->slabs,
+						    &first->slab_list,
+						    &last->slab_list);
+				first = NULL;
+			}
 			continue;
+		}
 
 		/*
 		 * determine the number of free objects in the slab racily
@@ -3775,15 +3783,21 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 		    && total_free + slab_free > pc->max_objects)
 			break;
 
-		remove_partial(n, slab);
-
-		list_add(&slab->slab_list, &pc->slabs);
+		if (!first)
+			first = slab;
+		last = slab;
+		slab_clear_node_partial(slab);
+		n->nr_partial--;
 
 		total_free += slab_free;
 		if (total_free >= pc->max_objects)
 			break;
 	}
 
+	if (first)
+		list_bulk_move_tail(&pc->slabs, &first->slab_list,
+				    &last->slab_list);
+
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return total_free > 0;
 }
@@ -7194,12 +7208,13 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 	if (!list_empty(&pc.slabs)) {
 		spin_lock_irqsave(&n->list_lock, flags);
 
-		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
-
-			list_del(&slab->slab_list);
-			add_partial(n, slab, ADD_TO_TAIL);
+		list_for_each_entry(slab, &pc.slabs, slab_list) {
+			slab_set_node_partial(slab);
+			n->nr_partial++;
 		}
 
+		list_splice_tail(&pc.slabs, &n->partial);
+
 		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
-- 
2.54.0


