Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DC2EB1051
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE226B008C; Tue, 10 Mar 2026 07:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F9C6B0092; Tue, 10 Mar 2026 07:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF2B6B0093; Tue, 10 Mar 2026 07:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 797956B008C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:38:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 431F9160130
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:38:49 +0000 (UTC)
X-FDA: 84529956378.02.A9D81A8
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id D00651C0006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:38:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=I6slFtHH;
	spf=pass (imf21.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773142727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Pj32kdU73jtg0RPPrl74jg5H3Dfkdxo7gX8u6gz0W4=;
	b=6uQxmzsl71IDQKTZZojA0ZATTKpZgaoxJMtQf+4mELy8gaucixvnttfiT9Gp7XxbcpnVt9
	yCgS77+eD3Yab8IonvzFpfK5kLF+xgYPzrU8USgvDSaKqFW3i7BsH/T3pPP+kCpXXiC8MF
	JL70qr+jTijdxy80eyvJ2VuzkIccub8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=I6slFtHH;
	spf=pass (imf21.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773142727; a=rsa-sha256;
	cv=none;
	b=I/DL1sGd8JsolOJX9kKMwpRIsinPFfojiJH+FdXQGHT4hCLWzuEJZp49su4Lr4H4RpxXTA
	rV5emJ9xRR31o70dpop/dn+DaCSfhNmOTBeBaeRy1KUK5Ig25/fQM7wJvNEWJGQbaSNHle
	3EQZN3kqrejq6gt2gd8pybfmjlk6ARs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=2P
	j32kdU73jtg0RPPrl74jg5H3Dfkdxo7gX8u6gz0W4=; b=I6slFtHH7b6XoU4ZtK
	JOQZmU4X+zhk+Ii3QIxTkYg8QjveW1L6lTP9UGDOYKveh65rb5Z578OSr73hNyo7
	N+pxW9cFm6GgAC/vQpUKi8CUb33h4IFGsPkdUZn/bCLXqHyim+FWy/+098NZ+2Vu
	8q583NsBxI9hhsezEZVIro/mg=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wAXvQ+eArBpwhXAAA--.11763S4;
	Tue, 10 Mar 2026 19:38:10 +0800 (CST)
From: ranxiaokai627@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	harry.yoo@oracle.com,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	stable@vger.kernel.org
Subject: [PATCH 2/2] memcg: fix kmem over-charging for embedded obj_exts array
Date: Tue, 10 Mar 2026 11:38:04 +0000
Message-ID: <20260310113804.245647-3-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310113804.245647-1-ranxiaokai627@163.com>
References: <20260310113804.245647-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXvQ+eArBpwhXAAA--.11763S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr1kCw4UJrW3ZF4ftw47Arb_yoW5Gr47pF
	y3C3sFy3yrZFZ7WrsFqFsru34fZ3yvvFyUCayxtr1kZFsxtw1vva1Yvry8JFZ8JFWxGF1q
	qrn8Kr1rWayUA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR58nnUUUUU=
X-Originating-IP: [117.176.242.62]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxgIve2mwAqJlqAAA3k
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D00651C0006
X-Stat-Signature: umiaeeh4rsnrhghpp7ke9fqgst1dgttk
X-Rspam-User: 
X-HE-Tag: 1773142726-229335
X-HE-Meta: U2FsdGVkX18F/0DHtAqU1VqhNDAdedzFm5w6D8ffznvqXQnXDffLrUMggLWLeujvMzexMPfSzFvKIciYcMIjX+ShOHDZE3k+ki0y+WRMf3dV8gEhZUK8Cas4FoTiwZ4zPswo7X/TGHaBhgQXEMWgifIMYAMPNuCP0CLXrQ7a2b7JnlcixWaZzz8Epw4SQQ2wrqHcuK5wrT+913BacHrgjgdLlnV5WnKXBnzTRLXlHq48pRlI0JRk780AW3tictseaPP1CK87BkZuq+dgMH64ycyAXIio2S/MAwowqyVl7YMpriEifL9n7IuCHAkt6dszz4mFtfM13eB+6Qb3uTy8BDgmUdV7D7TWZ10yki9GYsFaW/m8e22fFdDz0mnnu511vWCdqkehVUF0q4xpy2kly3/G6KgSZu8vJ9JbCGQHThPIzC9uXgqkXzGJZkkp4tfoXdfBRTRxvedStXRKmNBC34mnp+/m1VqiImw6v3iHuWrQas20eWNGFuxnd+akfwAwOveGOXyquSr1o8NpQQ5+CMQeagcLgcICJRuIww7VhXL6m3bAKZD1IUvauk9aElOy82HZzpQoivDTnj0uZIYnoxZ1ihUD0b3ePoEnp+/+6GwjJCHilEDL4gbjmo7KRVrSYVwtB63cbZtzwQ7qn/oKGVli9Eulde37vR4ikoj47HzjLWaTM9jov5sGucu8oj70XN1YyEP4CwysyZfpqvJoFD2+w2ycaZgQbOvv75cDJRMiEijIcv5X1fCHO0Yz12pTK/BjWquBqHtkDrQixGRWDUtIoxZXlADH9pZA51wYxhwfx88CohMY9PoWXRS2E+BzjLRn1Gcztux/M2++dO6hTH95tST3PQf5qUZoJutfW7P6jWrrRzZPwPKiuO0dz3A1663P6PZza0P6b2d1kIdNnh1bwacPCJ1l2hv210jhclool4gghuqvglXSYfS1G1HLn7pe/Bgg7px6q9xM7Ib
 kq5MtSqV
 y/CspKKNb7LaZTBR1wMh69oHOzWUzQb0ZcVtixh0HUp/9+66G381zJb7BDqCOLWk6/z9tCjE/TGjKg1n4IHfMJDcNN7BgNPryuM0sxOeKwSlnXFnMg3a/OuWNcz9801lwwR88P11AE1URK0FRAKX99i0l3tvmcxsdq4wd2OYgfi+Nd53j8QVhRwtzcYxwTmGCDumpK0mw9PCPO5Vxjt/uK0Z67sOPy/1pfg/9GBiW1nbIhuu2gH2TC6Rl40Bf7i3+Txi/FHA+dRraRUIZROuBgIp/LCUs4clxFElJJTLzA5f3H6x3Q1hJVe1dn9eCw98Cwy3qTOQLB4qgXL27dbHNRR9/3wlTHJAQt5OPPUPirUtbscupYTl5Mjd2f6iSttifpfyDdICUPhClmKCSVthhY64SSCESAwNUTcrptOhJUHD+c/o367p87Wa01/eSBktr1suvtNWif7hZSRHrjOzHmx0Vbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata
in unused space within s->size"), the struct slabobj_ext array
can use slab leftover space or be embedded into the slub object
to save memory by calling alloc_slab_obj_exts_early(). In these
cases, no extra kmalloc space is allocated to store the obj_exts array.

Optimize obj_full_size() behavior to avoid over-charging kmem
for objects whose obj_exts use slab leftover space or are embedded
in the object.

Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
Cc: stable@vger.kernel.org
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/memcontrol.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 87614cfc4a3e..d6289a5cd6f3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3199,11 +3199,20 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 	refill_obj_stock(objcg, size, true, 0, NULL, 0);
 }
 
-static inline size_t obj_full_size(struct kmem_cache *s)
+static inline size_t obj_full_size(struct kmem_cache *s, struct slab *slab)
 {
+	if (obj_exts_in_slab(s, slab)) {
+		/*
+		 * If obj_exts array uses slab leftover space or is embedded
+		 * in object, no extra space is allocated, just charge the
+		 * object size.
+		 */
+		return s->size;
+	}
+
 	/*
-	 * For each accounted object there is an extra space which is used
-	 * to store obj_cgroup membership. Charge it too.
+	 * For caches whose obj_exts array is allocated separately
+	 * outside of slab, also charge the objcg pointer.
 	 */
 	return s->size + sizeof(struct obj_cgroup *);
 }
@@ -3270,7 +3279,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		 * TODO: we could batch this until slab_pgdat(slab) changes
 		 * between iterations, with a more complicated undo
 		 */
-		if (obj_cgroup_charge_account(objcg, flags, obj_full_size(s),
+		if (obj_cgroup_charge_account(objcg, flags, obj_full_size(s, slab),
 					slab_pgdat(slab), cache_vmstat_idx(s)))
 			return false;
 
@@ -3289,7 +3298,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 			    void **p, int objects, unsigned long obj_exts)
 {
-	size_t obj_size = obj_full_size(s);
+	size_t obj_size = obj_full_size(s, slab);
 
 	for (int i = 0; i < objects; i++) {
 		struct obj_cgroup *objcg;
-- 
2.25.1



