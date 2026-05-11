Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B22CCD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821E06B00C9; Mon, 11 May 2026 16:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9426B00CB; Mon, 11 May 2026 16:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736516B00CC; Mon, 11 May 2026 16:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6578F6B00C9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:28:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16A8B1C0783
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:28:20 +0000 (UTC)
X-FDA: 84756276360.21.A7D9301
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26631C0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:28:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778531298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/6dYUbjdSwh5y8RCJWKLvMF4pBIBXFozdQ0w1APnGPY=;
	b=KnCLz7s1lE4cTtsX3EB8TV+E8+t6sOdq+CBak3GURyZozl6B64zbbxMXQyVhk2kSIn4H7t
	DtWdciKYwtQTVwjKL/WFtdOFXQPbooT6E8eOjGRt7T7wStTbdSW82iYOfbJtzjwOgVCxHI
	xNNESB4gvNIfEJ7CNn2ZdX7MHWD3O4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778531298; a=rsa-sha256;
	cv=none;
	b=8CNC2jBL1p3sJA277jHM8CfUcpNZcNV07UFatLQVLv2+w1rwagCYkOanrPqKOknKfzYODC
	aT4WPcUe6XJcqeQ5LXXg0HGNLQt+c6TB955YtRi/AVbDn/MEUOwjDfM5BK0sia4zAeFoy6
	OkVo9858aZvV803p86OYXDIwUE0DhD4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 5E1823ECA9;
	Mon, 11 May 2026 20:28:12 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 6/8] mm: slab: per-node kmem accounting for slab
Date: Mon, 11 May 2026 22:20:41 +0200
Message-ID: <20260511202136.330358-7-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511202136.330358-1-alex@ghiti.fr>
References: <20260511202136.330358-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGZq0GkJau6RWVth2AkA6mXp5hevURRivnwJLaOUMsROukueZFeGriViT3+cCjdcQdQP0MXVJyz1fLtz5XFi7fYpUSG4G6HGJNwB7Iq+AffJ+iN70qPoWx4sPkTvS8S8edtNse4haP6xRwCWHJvcVy7zsnDElyg9ELyVKHPrzVc71knPq23qOqkwc4KIrg5BHucIt4/5JbUi95cV8eeMKs6lPZKscraThdxjN0ea9JVj3y6puOv/mj1bfUb5Bpth59ONuYJuZ08jwh3vLgdvYEWkwTPa3c1OOv3+xRvJspVD1HTOqkt57ReSG7Uxn9/R/VsgPJlS+GPzNYXtlpAG3mkJbX67Njd6BIGbSd3kIMF6zI2SPxxVU8jrtHRPzhlOBMH78KZWa8sI6jzpCjCXhcVEcIIzcsk8ommP5+c+1S0+dBBC9M+DOr4qPvb7bjSQ9Bst2E7PCINEbdpofRg5cA3z50NO9Cxcf2ieLYT6YiOgFdZ3qCrvKKNG2Riem3KWDi/ad+KeaoCy0jkm5wkkolorVmEICRJ2TEKw/KZ54E3okbW4BByQNZZN45W9cpM7WFWL8Zs7eSB2YAcy+uCNP/LDkC7E08aaXjNJnMuas8rQDUCIGWuY0yybBBOpu/8LjqBbsxYR5yHgI/HmTNUq6bE7H7TFFFTL5qQ3OodEeOs6Q
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26631C0007
X-Stat-Signature: 54ahwh71s3wopeiz49h84frs7joafnc6
X-Rspam-User: 
X-HE-Tag: 1778531297-688780
X-HE-Meta: U2FsdGVkX1+N56Hl52RhhDXmLYX1Xz1hT4jVbFXQvsjQlb8c0V6VY3bG6MkGsZ07wkFlRocwJMDoqauqtmpY5Kuq52/OIE6Ww0m9s4+/93/GkZ8KNgPzXC/4Dm1WFyi5B8pXE2Z1iZBkilRmd6icDpSgNYvwOEyO0THNBGsfmwJ7pQ8iMdadLgPMWYJli6b6nYeEnXTplscFfAljQX+NWF6KnQ6klpD3FsKgvdYBRI4GpXZ5KiZoGefSosvIbzmIdv0mrk2QaFpjAAYudfabaXWA6seQeUZA2WzJi2UgZ8BG6/n+aNXDB7ZDy9EGrwvWDUgallRZmyjnyzwz4JAUxWX8hMQQz81udkn/4veRl94n0FBn5MFOEXMJ8ZhYfTrdb34fHD3ZLH7gyfp5tD+P8zqR6JIuZLO1XQ2M++N0EPAAbwICKa2gRSGlHFiw2NChd9IaQi4S6LK3C8sp+e50LYJ+a5AQg6m5NkTA3fZBfWWjp2x4VTaHxtJ0T480JD5+upBiExunf7yybNTCdTAlq5Ayq/4AS6fgeeQl4DJpdUXI42C2df+rpMAquNEGE1ut1/tBTO9aPW870lKrn8Hz/ERP/vi+E+nY5/M3CzG7ZXUwL8ejeTK1oXVNGN7T+WeFCSbsMFEK2oMKoKqujJlJolkxYrZPFBHR2s0+uE7MvtnbFy2jFlKdBgLnLDTFb3U8JOsRJIgN0SC5mXv1qEMg7CxzE+ZFscqvxtW0etIdBLwB0sPfDiSn7lMsilBLnqFhFEyV4mI5rKSLc1/7hZCPSVlCuwDGwxBiLzxAPTKKVSFPu8NMJ7eIc2vcm7qSIqOc84Gz8N+N1z1UvihU/VgooyXb7XR2P3Z9kiiKf0xRsbFXn24EXVLWdYKEjh0cT05Zo9ov17feXd2+wGedfPZ5O/x9xi5AFJCqNiEJ4j0k63ZlsR8EF8KhcXnkyNl1cP02fed+KlaW3n6Cd2gjhwG
 OC6Grx7x
 Kt7HCSa3ae+c4n0HeYdjoqCx8j/krzhf++5BV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update slab hook to use per-node obj_cgroup for correct NUMA
attribution of NR_KMEM.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/memcontrol.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 66d2beb1c974..cefb335c990e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3521,14 +3521,18 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		struct obj_cgroup *nid_objcg;
+		int nid;
 
 		slab = virt_to_slab(p[i]);
+		nid = slab_pgdat(slab)->node_id;
 
 		if (!slab_obj_exts(slab) &&
 		    alloc_slab_obj_exts(slab, s, flags, false)) {
 			continue;
 		}
 
+		nid_objcg = obj_cgroup_get_nid(objcg, nid);
 		/*
 		 * if we fail and size is 1, memcg_alloc_abort_single() will
 		 * just free the object, which is ok as we have not assigned
@@ -3541,17 +3545,17 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		 * between iterations, with a more complicated undo
 		 */
 		stock = trylock_stock();
-		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
+		if (!stock || !__consume_obj_stock(nid_objcg, stock, obj_size)) {
 			size_t remainder;
 
 			unlock_stock(stock);
-			if (__obj_cgroup_charge(objcg, flags, obj_size, &remainder))
+			if (__obj_cgroup_charge(nid_objcg, flags, obj_size, &remainder))
 				return false;
 			stock = trylock_stock();
 			if (remainder)
-				__refill_obj_stock(objcg, stock, remainder, false);
+				__refill_obj_stock(nid_objcg, stock, remainder, false);
 		}
-		__account_obj_stock(objcg, stock, obj_size,
+		__account_obj_stock(nid_objcg, stock, obj_size,
 				    slab_pgdat(slab), cache_vmstat_idx(s));
 		unlock_stock(stock);
 
@@ -3559,8 +3563,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		get_slab_obj_exts(obj_exts);
 		off = obj_to_index(s, slab, p[i]);
 		obj_ext = slab_obj_ext(slab, obj_exts, off);
-		obj_cgroup_get(objcg);
-		obj_ext->objcg = objcg;
+		obj_cgroup_get(nid_objcg);
+		obj_ext->objcg = nid_objcg;
 		put_slab_obj_exts(obj_exts);
 	}
 
-- 
2.54.0


