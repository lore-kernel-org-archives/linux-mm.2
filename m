Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C25BBCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5F16B00C6; Mon, 11 May 2026 16:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D026B00C9; Mon, 11 May 2026 16:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3076B00CA; Mon, 11 May 2026 16:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6726B00C6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:25:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD3A91A0239
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:25:06 +0000 (UTC)
X-FDA: 84756268212.24.2A7D4E8
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf24.hostedemail.com (Postfix) with ESMTP id C852E18000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:25:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778531105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YPv4n29CZjDx9uFWkjg55hS2oczfmHKyF64SeIrm0T0=;
	b=HNpzss5bZgG2Zj73RWeAKc2ssQsCbGRl611g6eiyMmA2JEgfhHaILKG7q9Eg5H0ku0tpCA
	gMqdrjNyzxjOgV60GzTQuBNl6KhQnza20zepWWobph4pGKsOvQ8v3hfAFYTG2tqOwjBWNh
	qeT9q612h6T1+Jbig0G3IDRZ2xp1s+A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778531105; a=rsa-sha256;
	cv=none;
	b=pU1a3Rswwjn8jRCbAmIvUhoxKO+d7AOCjN0Jyf1S3ybAgPTzwn16LBlIorU8Sto7mykrLY
	mWEqd2HOYJItm/wmb2nWMTai25PweQMVSVl19ootRB8hxP7wZ9WnkeRbaMmfU/kYoghA2p
	AuJmS0N+nKLhYADRoGcz8dBEcYa3+DY=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 0B2463EC97;
	Mon, 11 May 2026 20:24:57 +0000 (UTC)
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
Subject: [PATCH 3/8] mm: percpu: Split memcg charging and kmem accounting
Date: Mon, 11 May 2026 22:20:38 +0200
Message-ID: <20260511202136.330358-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511202136.330358-1-alex@ghiti.fr>
References: <20260511202136.330358-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGASuQ7DzVEqE1yqVdt2m1IEMvyeiZ424ZAVS1woSZRBsZRcHOaYxo/wRroa9V549fgoGhwPyYnAfDpxQNFtzkxj0I5TMeBg/5jBppJQkWIBRGnFCdwyKb3+iAwjbc6HCyc2w6Fq1RMe0bJWfA1ndpco4RPwk+ydi46o3tuXnoPGtt57UGuv0fBX6aLFC8egYVKjqd5+b/oNYSj52BJhnje7YewqzwfY3MT59q3IHUZSXd+23dBE9VioRxzwOkioSO0aPH0PeFEsizQ7P2RVgZRWW0PznWL4m6swkEsBSSzcbL/DhTQy/lqZtdEuHj15ch+irNHdmG3iRmpUdYJcCG6FVRyCFmUUefwWKvmaU8zciFZr9tv02clCs29RgJIe6uEHw+tHpKx9hC0tk9VwW3YlOuSyQlzq7zcDO7cJZuRLZjIeYUuDZY43XuUpam9sFTsMHZohmtUl9SiE0Jfu6DdZaxw90yzWEKKUSOlXg4J1Z16+k7QwHE/Ap3MW22DG/TSgjt5seNYJm7KBXRAPlXmUsd2VjSwn8EV/3xg3yQpsgdLhJbkr5M3xPszfR56699O1eGfBtzdrb6nViTLCQHO+Gkproj+k5gd7upyyXN9nu3oJJPtq6HaXmZYNdI2z47UdrcWga1FD/yPaRKqkRrOKPqmtOp4KPeDAPJHh2y4+w
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C852E18000C
X-Stat-Signature: 9h15itnp143aw5s3go7ud4sq7canqsyo
X-HE-Tag: 1778531104-659033
X-HE-Meta: U2FsdGVkX1+w23KhZAocKnUAJW+ECR+g5Djsv1bGkLf63fMt4raAYfmu5LlXggJMVnbIsYxPVVPORNpwtNsB4E/lzSU6dHUwk21/PzHiuWEhyK3oHMWe+5WKU8LY1iuet/FM5as4K/HCras2O/UV8XbWWdajmcqEbMfuOT2vLP/X7Vg4DUWTgx8PnKLK4GFszVCn2qPnX9SmYK9iU2/SBwpTF4P7K/S/CZva8QUJ9D1StwMqzGpFNYGu84Fs8wP0yUdPyxDvxwa0iLzP/aP9tYIsUstA7INoLq9tgLxMb9ByPBFjs8jfQWna51zem6xFwWgZ24C7kDEKVxjff+uY9Yuhp3mqLec6MVf+ompHbWB0dnA+ZtuX1W6Dvlta39xsVIATg6zudXmd85eJ2WQboahom9JpiZH0wm5+j1H/W97lmeUNUrsugQvWtt7Zai5xzIv7etF20ZLY/Si4jY7qDgBEYquAyy7UFB8NJY4im/iKhtakVQZGNNZ7p1AeWoSDSZ7KFNz75qG7J0uQFL/FGKYmfvyIrwkF9425TypLq3oGvae5C58jv1CrTA17xro5zEBmLvqeclYS/lXtIXtos28zH3GVq7UZFBe0fnUp/1kWUUN0K2+rMN8ekwi+ZKafglqYfZj2A5TLK40pIP5V4D2enxbQaFu+a/jN5yBOVsBkrXlMomwfK7QTaiksAei1KzVRJDHcyI7FF77CTv4DTCM3zzgMlHl/2dBeZb/SJQKXvT/K8lpkm7yzMvh8OREwiL6f5ZDoLFM1rYHYegLC2EVSZ58jLbfq262DXwhvshexFbTIbTbLYiu6J4t2EIIakPAomnmfaIcUCEOhfesWs3g0yUqmkgCKqHKbgB5mW2rPkE9HSV99we/KYbTuBSfJhE8k69PZg19KjyPxRzEFnKO/zgH6hGgP5RuOy8qU6kKrv4v0xkVNgIwpqKoeHbLfYEkepEhWGKJfORZNV0C
 TawsGLII
 5Gdjj1ZJQz9UH/DfNvcK6QOtH3XBtjY+9Eu4WoyCbtYQrh5HI2N+7bRKbfeNPD653lhiL8guJmoEtTd2zCmPnnceTiMsz1RVCEjg2cGTjP5Gw8b8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is preparatory patch for upcoming per-memcg-per-node kmem
accounting.

Percpu allocations charge memory before knowing which NUMA nodes the
pages will land on. So we need to decouple the memcg charging from the
kmem accounting:

1. In the pre-alloc hook, obj_cgroup_precharge() reserves pages for
   memcg limit enforcement without updating kmem stats.
2. In the post-alloc hook, obj_cgroup_account_kmem() accounts kmem
   and places the sub-page remainder into the obj stock after the
   allocation succeeds.

Because of that decoupling, we must not rely on the stock in the
precharge function and always charge the necessary pages that will
be accounted after the allocations happened. That means we may
temporarily overcharge the memcg but the obj_stock draining will get
things back to normal.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/memcontrol.h |  4 +++
 mm/memcontrol.c            | 50 ++++++++++++++++++++++++++++++++++++++
 mm/percpu.c                | 15 +++++++++---
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b..568ab08f42af 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1707,6 +1707,10 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
+int obj_cgroup_precharge(struct obj_cgroup *objcg, gfp_t gfp,
+			 unsigned int nr_pages);
+void obj_cgroup_unprecharge(struct obj_cgroup *objcg, unsigned int nr_pages);
+void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages);
 
 extern struct static_key_false memcg_bpf_enabled_key;
 static inline bool memcg_bpf_enabled(void)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d81a76654b2c..aaaa6a8b9f15 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3405,6 +3405,56 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 	refill_obj_stock(objcg, size, true);
 }
 
+/*
+ * obj_cgroup_account_kmem - account KMEM for nr_pages
+ *
+ * Called after obj_cgroup_precharge() when the allocation succeeds.
+ * Accounts KMEM for nr_pages on the objcg's node.
+ */
+void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	account_kmem_nmi_safe(memcg, nr_pages);
+	memcg1_account_kmem(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
+/*
+ * obj_cgroup_precharge - reserve pages without KMEM accounting
+ *
+ * Reserves page counter credits for limit enforcement. Does not update
+ * KMEM stats or the per-CPU obj stock, because precharge decouples
+ * the page counter charge from KMEM accounting (which happens later
+ * per-node via obj_cgroup_account_kmem).
+ *
+ * On failure, use obj_cgroup_unprecharge() to release the reservation.
+ */
+int obj_cgroup_precharge(struct obj_cgroup *objcg, gfp_t gfp,
+			 unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	css_put(&memcg->css);
+
+	return ret;
+}
+
+void obj_cgroup_unprecharge(struct obj_cgroup *objcg, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	css_put(&memcg->css);
+}
+
 static inline size_t obj_full_size(struct kmem_cache *s)
 {
 	/*
diff --git a/mm/percpu.c b/mm/percpu.c
index 13de6e099d96..7c67dc2e4878 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1626,7 +1626,8 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_total_size(size)))
+	if (obj_cgroup_precharge(objcg, gfp,
+				 PAGE_ALIGN(pcpu_obj_total_size(size)) >> PAGE_SHIFT))
 		return false;
 
 	*objcgp = objcg;
@@ -1641,15 +1642,23 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		return;
 
 	if (likely(chunk && chunk->obj_exts)) {
+		size_t total = pcpu_obj_total_size(size);
+		size_t remainder = PAGE_ALIGN(total) - total;
+
 		obj_cgroup_get(objcg);
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_total_size(size));
+				total);
 		rcu_read_unlock();
+
+		obj_cgroup_account_kmem(objcg, PAGE_ALIGN(total) >> PAGE_SHIFT);
+		if (remainder)
+			obj_cgroup_uncharge(objcg, remainder);
 	} else {
-		obj_cgroup_uncharge(objcg, pcpu_obj_total_size(size));
+		obj_cgroup_unprecharge(objcg,
+				       PAGE_ALIGN(pcpu_obj_total_size(size)) >> PAGE_SHIFT);
 	}
 }
 
-- 
2.54.0


