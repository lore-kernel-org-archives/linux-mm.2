Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB39CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D436B0092; Thu, 28 May 2026 23:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DB56B0095; Thu, 28 May 2026 23:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B256B0096; Thu, 28 May 2026 23:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEA9C6B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:52:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82F05141054
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:52:01 +0000 (UTC)
X-FDA: 84819084042.06.51223BF
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id DBDA518000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:51:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A1u8pdDo;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780026720; a=rsa-sha256;
	cv=none;
	b=3exiQsZEU/y+3u6JR2GxPnaCZCFoL7nIWkPKOwQExljyXbvFo/ZE6IoU+kRm5MuUxVlYl6
	vGJPVcHqLxF1NUDYuttPzdvCu8ZRIjsarpmwS2Ag1kDAK9SmeXQQ7CSI1XVBuIoEfT2/Iv
	ZG+8RFjQT4uMUW2aJ9GGHjrKn6RS7aI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A1u8pdDo;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780026720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vm7EtoPN4QmeJ2Y9CSRukPyMKuVmFRo7olYJHuJ3ke8=;
	b=ZJsgNgWUAnc83fFOMyBtBmMlQvGEaDbFSofE1mCNoV1IZhm9PBLr0Yp/wO9XybmlD96OP8
	Z66x1DB2gkha4y85bHWiql7O2502zpfsvKRLRZRKZs9Af8GT/WmE4XupcQnMleDnCfve5K
	X6VFeMGvQ3JMmB5RpcEBPhG18P6h8AA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780026717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vm7EtoPN4QmeJ2Y9CSRukPyMKuVmFRo7olYJHuJ3ke8=;
	b=A1u8pdDoeRJKed4RmTVAxkvXMMDzLTT/u2icwQoTkOfKw/eCkU3sFNbZX7SpzsB87+/cXP
	nb6dKS9jiBAGo4D+oZa3/Onc+9Jasal9zy9SEOOOWlM0YH/ub3HuI1Ygi8vyB1zXrDhPKu
	ZdTJrfVlgbXNEjJ97gzG3LXZNK/w9co=
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
Subject: [PATCH v3 2/2] mm/slub: detach and reattach partial slabs in batch
Date: Fri, 29 May 2026 11:50:52 +0800
Message-ID: <20260529035120.81304-3-hao.li@linux.dev>
In-Reply-To: <20260529035120.81304-1-hao.li@linux.dev>
References: <20260529035120.81304-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: DBDA518000B
X-Rspamd-Server: rspam03
X-Stat-Signature: dqc3h1pgmabxonbgzhwsgtky433hn3dr
X-HE-Tag: 1780026719-417058
X-HE-Meta: U2FsdGVkX19BD3VJyG41sT3Tac92f8fC3YvzOK7VcPkmO017MuIHvUEV1L87tPwHqdnU66nyQhfHmLlT+U5Eqa9LC2mEkHZdO3itR6XKElbp2ISZZe/R4QO6DWPRQQBsvCbQiI9rDPGqQwAaUqromdbQ38+RWxHZJsaGEwfQAKFWgAOzOrDq1L0BAL932kmLrcLo2KUcuEFmhiZQf3FAGRN3Mmeu4mf7QG+QcRda+j3NDZPL+r8EfVDDrpTdcGxz/VyHN9PrGM2g9dGq/fTki/1bi3jKmghW2jV1Potmb1jLSNFjUDxD3teOpBwVe1dxy7spVfLhHaTv5EvWgq8498tYmjzkj7RbkqKD/SZj97wwof+xgA2mzJ04V6hbczzGV9lebiSNhHb0AN/Si45jP8Mnp1HtRPHG3SfYG8QtbYUdJq9D/EY6N0uKtSVPl8mJclBBXYSf/+vLZy1naF+d7QyoUFo8edPOeZ2mN8Y7SIo+OtQG/7wd3E6Selyvy4QHkGLkgTj+8wPUHehR9zSpapoz3R0M5arXPjbqDeifoPEzrJuPHNVYq+sx8xlZ5xEqDiZ+BVwPV4JJKJJmL/9KAPY9IBVQwirkupdcA9MS1iF8/HyXmqym5UMTEvMd7AyYiXSPwK5yhN9uVW6Y7+uHPXGCR0nklEBGV/4FD/csCTmue2UDK6PtUtLX8r3uIpCwSyX7mjXHT2+s0eO3D4OmVW749vpDnTGxQUOvfygEMNgW/osmb2h3N33ozoJcRyDcDt0xK56ZwANUHEDZiHZ6/bGNKSoBaIjSNfE8DK36VpaK7tHJQHLNNIBnwgNREzrd9SrDfU7o0nKSRBXQU2GiyamnO3P+iSQ/RxcFm5ACkUIZqIesp0St1h8aYJQomclUHXWrSRUBmDibvvWOGejOEFaBZX2EhCEqBlTI2IcjEDb+Uh9TsNU7AeBojkhxS4gm+/kvAXPRWSuMv1qgoB3
 rXvWQc6+
 HEvSMLqsSXpsr30xF/MoG46HRbQ74wv1JOy8n1oU+mSH6mfAEpz2O0OVjyhQecqSOk96X8YkUd0GAaB6bK6aOdiLBFSHuAlUBmwSGGeIVjLFOau3A/PTw1xio8gFwh6gruAHU8aEnM02bUPoqGLfs8v8kn/bFCjocyzlm1XreDpX4a5Pv/6HSwCAbrViPtOrkpuCV
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
 mm/slub.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 45aa0a834f97..4fdf5c36a69b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3751,6 +3751,7 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 				  bool allow_spin)
 {
 	struct slab *slab, *slab2;
+	struct slab *first = NULL, *last = NULL;
 	unsigned int total_free = 0;
 	unsigned long flags;
 
@@ -3769,8 +3770,15 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
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
@@ -3787,15 +3795,20 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 		    && total_free + slab_free > pc->max_objects)
 			break;
 
-		remove_partial(n, slab);
-
-		list_add(&slab->slab_list, &pc->slabs);
+		if (!first)
+			first = slab;
+		last = slab;
+		clear_node_partial_state(n, slab);
 
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
@@ -7206,11 +7219,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 	if (!list_empty(&pc.slabs)) {
 		spin_lock_irqsave(&n->list_lock, flags);
 
-		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
+		list_for_each_entry(slab, &pc.slabs, slab_list)
+			set_node_partial_state(n, slab);
 
-			list_del(&slab->slab_list);
-			add_partial(n, slab, ADD_TO_TAIL);
-		}
+		list_splice_tail(&pc.slabs, &n->partial);
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
-- 
2.54.0


