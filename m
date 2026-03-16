Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03CFDF013E0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 08:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE536B00BC; Mon, 16 Mar 2026 04:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685C16B0163; Mon, 16 Mar 2026 04:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587FE6B0164; Mon, 16 Mar 2026 04:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 471E76B00BC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:49:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2BB01A0106
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:49:20 +0000 (UTC)
X-FDA: 84551302080.27.DEF5C94
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id E693F20006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:49:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="md/OlqQc";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773650959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/PtoIr7fuDhAgCMKXfyK5jHWTNc0oBcDWYqsZ2x/pUE=;
	b=t+4V/RrTG3NbpQFSXzPxSkdWnj3uV8n5GnNXwEV7+SLifSH49r3fUX8TKQ4h/+zuNtYRUH
	YgtNO4J9jXWlmlqCId84IKo13l8BntxH4GKhr9aARzCPS+DqjQv0KQ4x1uE9dGIJkDnjNt
	hWxxZf9PmoDiWky7YGat+b9WN7mhCiE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773650959; a=rsa-sha256;
	cv=none;
	b=RssQnF4aAKUQYaxpV9epQH5lg4idfBeEHj1yVHovd0OgO3B+y63kUmPWLDZtx3MJEKdJjv
	TKwbUL3wQyOx2Yz+yS2Ejvml555ekOQA1y0WWmBjHia6RqnQd51PFLKCzpXTfCCBL4Qqod
	sQy+uTRjxFWUDkvH3T0LAwgd+eVa2P8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="md/OlqQc";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773650956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/PtoIr7fuDhAgCMKXfyK5jHWTNc0oBcDWYqsZ2x/pUE=;
	b=md/OlqQcYzDYcxpMIvH8DJny98ZuSVFmvQ+aaE1I1gYhPq7ktmS9+/WUqSupyhruKXWBO6
	MsrOtGk+v4bIDz70+L/F0wnIiweeos3p9r9SYQE5nHj7VE+J61AS0k/jpI+40irSSvS9NV
	qS2l9qbSFhZzppC93IrXu1PF6UPEoX8=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable] mm/memcontrol: batch memcg charging in __memcg_slab_post_alloc_hook
Date: Mon, 16 Mar 2026 16:48:38 +0800
Message-ID: <20260316084839.1342163-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E693F20006
X-Stat-Signature: djyy3y6jukzqb8ce4ogb37fxexkmfapt
X-Rspam-User: 
X-HE-Tag: 1773650958-926399
X-HE-Meta: U2FsdGVkX18HD3vjENngo9SK/pbnR1bD0nuQjbTAMZiC5fPGvYcOhu25V71FfR8Ybb748ieTdG8tyk8DLgeGUZz1LnaCbIgmKWZuMrlV6eDHynqcR9BVZCP1+/ge92KOWaRp+eZVi+rvcMagOA7UZ5Zy3PtnfZUA7FLYXK3/B31Teo4GuuWJ3Wal9F8uin0MP+ZVJujjYLp17XjPShi6tTvWVDNHF5YzK7C7R5ui9iQ+6Jtu+wpXNBFrJ0Foz2ScqaxMGuKfQYhnfgexbMfAGiWGSijN3Gvv2g+VHXDmagR2wyX7d2GJ4Cv0rGLV9uObQ6YlugFvliGC/LH4eFYglt+dKWP/vrmCcS7Jnjp4oamUNHGsaOBOPPfJTb+JBdue+yZUljZjs0FKuu8CJij4zPmvGkH22MuSxnua6TBZ+/iffOjkSwELOYm4G3gBz3CMyL49UdpGTdrnJZCeWc+K4ijpK5B6wS0cBXGcIRjt0CQij6P03kR7eDN8M6GGt1gUTdoiXme3/gysC5o8WDX25zFNW6LjYPLxXygpXv/NLLfdq9XhenyNl57E6GQ7zMLXrxn1pau01Li+G3m/T+n6gxOiuzVhueLC7EMq4r9QYlrwq2Co2S++C7jyuqH+mpZoXd74FIIAfEgJXjT3gQsEHWyy+Uv2y/JfJV/E3bQ1Jaj1qDBTyf0sowQdDaf/03fQn23AL8I3uaTLvBPd79+7OCBariL2P/c863G6nYjc8yj8t5e5706RfymsSAQeYW16mRrVp/+XoZaLmWj1ByrihYwrPHyXQoLOIGHR07i5lPDbN1pYuL1IGkPywZCBiG5mGLbiWfBzqXqO70qnD/dTTyXvMcdSbvqbCXI8mWYlk16YzubkHtyidCNiKZoOfVl1Y1Eyln99zIJPt6XeFbHpxD+pQQbOPFMndi3iEIgBCYecPq3EnxREGID3PiHorg/fGpw3ei43+0RH4zfbVLV
 p2rY6Wh8
 1+08Z3J5ykqXUPSLkjER4z1LTBW9BaKzWfl6FAwW2PV1Dh93PVNosvJMzmXyp35yWWRHRZyoEsZHZKX4G45+x2YiA44Z323gIdNxIl/mtzcpyVoN4EO5FBQ4/cyvw3pOStmndGkHKw9xaMpzFpXZgW2C2qGTSeQu6UksJbCZWWyhq8Gw15Fx/o55xJ4GUUS897AoLrEuGPGfhFt8Mv+wyvGOWrzEKiWMnRMfkZeraByEZBUWXzbdNvMmKqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
hook __memcg_slab_post_alloc_hook() previously charged memcg one object
at a time, even though consecutive objects may reside on slabs backed by
the same pgdat node.

Batch the memcg charging by scanning ahead from the current position to
find a contiguous run of objects whose slabs share the same pgdat, then
issue a single __obj_cgroup_charge() / __consume_obj_stock() call for
the entire run. The per-object obj_ext assignment loop is preserved as-is
since it cannot be further collapsed.

This implements the TODO comment left in commit bc730030f956 ("memcg:
combine slab obj stock charging and accounting").

The existing error-recovery contract is unchanged: if size == 1 then
memcg_alloc_abort_single() will free the sole object, and for larger
bulk allocations kmem_cache_free_bulk() will uncharge any objects that
were already charged before the failure.

Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
(iters=100000):

  bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
  bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)

No measurable regression for bulk=1, as expected.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 68 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..17ada0540bed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3448,51 +3448,81 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 			return false;
 	}
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < size; ) {
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		struct pglist_data *pgdat;
+		unsigned int batch_bytes;
+		size_t run_len = 0;
+		size_t j;
+		bool skip_next = false;
 
 		slab = virt_to_slab(p[i]);
 
 		if (!slab_obj_exts(slab) &&
 		    alloc_slab_obj_exts(slab, s, flags, false)) {
+			i++;
 			continue;
 		}
 
+		pgdat = slab_pgdat(slab);
+		run_len = 1;
+
+		for (j = i + 1; j < size; j++) {
+			struct slab *slab_j = virt_to_slab(p[j]);
+
+			if (slab_pgdat(slab_j) != pgdat)
+				break;
+
+			if (!slab_obj_exts(slab_j) &&
+			    alloc_slab_obj_exts(slab_j, s, flags, false)) {
+				skip_next = true;
+				break;
+			}
+
+			run_len++;
+		}
+
 		/*
-		 * if we fail and size is 1, memcg_alloc_abort_single() will
+		 * If we fail and size is 1, memcg_alloc_abort_single() will
 		 * just free the object, which is ok as we have not assigned
-		 * objcg to its obj_ext yet
-		 *
-		 * for larger sizes, kmem_cache_free_bulk() will uncharge
-		 * any objects that were already charged and obj_ext assigned
+		 * objcg to its obj_ext yet.
 		 *
-		 * TODO: we could batch this until slab_pgdat(slab) changes
-		 * between iterations, with a more complicated undo
+		 * For larger sizes, kmem_cache_free_bulk() will uncharge
+		 * any objects that were already charged and obj_ext assigned.
 		 */
+		batch_bytes = obj_size * run_len;
 		stock = trylock_stock();
-		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
+		if (!stock || !__consume_obj_stock(objcg, stock, batch_bytes)) {
 			size_t remainder;
 
 			unlock_stock(stock);
-			if (__obj_cgroup_charge(objcg, flags, obj_size, &remainder))
+			if (__obj_cgroup_charge(objcg, flags, batch_bytes, &remainder))
 				return false;
 			stock = trylock_stock();
 			if (remainder)
 				__refill_obj_stock(objcg, stock, remainder, false);
 		}
-		__account_obj_stock(objcg, stock, obj_size,
-				    slab_pgdat(slab), cache_vmstat_idx(s));
+		__account_obj_stock(objcg, stock, batch_bytes,
+				    pgdat, cache_vmstat_idx(s));
 		unlock_stock(stock);
 
-		obj_exts = slab_obj_exts(slab);
-		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
-		obj_cgroup_get(objcg);
-		obj_ext->objcg = objcg;
-		put_slab_obj_exts(obj_exts);
+		for (j = 0; j < run_len; j++) {
+			slab = virt_to_slab(p[i + j]);
+			obj_exts = slab_obj_exts(slab);
+			get_slab_obj_exts(obj_exts);
+			off = obj_to_index(s, slab, p[i + j]);
+			obj_ext = slab_obj_ext(slab, obj_exts, off);
+			obj_cgroup_get(objcg);
+			obj_ext->objcg = objcg;
+			put_slab_obj_exts(obj_exts);
+		}
+
+		if (skip_next)
+			i = i + run_len + 1;
+		else
+			i += run_len;
 	}
 
 	return true;
-- 
2.43.0


