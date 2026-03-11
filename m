Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183261125875
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2096B0096; Wed, 11 Mar 2026 15:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886526B0098; Wed, 11 Mar 2026 15:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747A56B0099; Wed, 11 Mar 2026 15:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6F36B0096
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2ACB31B7D2F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:07 +0000 (UTC)
X-FDA: 84534828294.14.6FF8B41
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D8FBA000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QUlJU4Bw;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8u5o092L3ULCpmoipnWOnXiIPpIcwoMHmpMXH/cA6Oo=;
	b=FMsEnNZCJrcyGzsnfM7IaUv6e2GkpQVYF5LO6tUGdlJBzF861o+uH5Hb2nUYanXgO8CCfu
	uCmGOrcjsOSMNVAi5QheYoceYQPPNBlhdPrOQvE+cxMeoXsXFPddNoHOLQPohOnRQBcbBx
	rqMD7rO6+hLDDEPZFw5NK2Ldovi71H8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258725; a=rsa-sha256;
	cv=none;
	b=ZF+SXZvoBj9KeSum5AKTDwqg3shlmPdwVf6AO7IGv8UNRq0oz78v7PMfYNDkx3boN4suTj
	Vgc4eZcZY0Yx0/9rl/I3FDabJJBHJ1y7o9M8SqZ8ylrYABm4zAa3FAwO+Emp6V6ffXbi6I
	K4/rHyPfZNzL70a2rTSjYYmk6gxVmEI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QUlJU4Bw;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-41708f6c3feso189563fac.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258724; x=1773863524; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8u5o092L3ULCpmoipnWOnXiIPpIcwoMHmpMXH/cA6Oo=;
        b=QUlJU4BwKZr9HBcLr3++01b1lXZz3U0klTERA+5DRfnojP1bPp5D5NQz9LdZVnMoX2
         cjS61yI3R4uL+6YVdazgpxUofma3xF2Zuzg45Bkvr23pi4JTyyMFmZ3q/ZsyvnPU+yOd
         Ly79vra22bFruVh+ElA0CPuE0ODM2ArsWbC6cFl9t7XAlwWhWcKm3S16VeVFaD/0/PWu
         kiZ/OgPmv9FFFaRY+h4VU4XjFqS2bUs0f6yhnJLwrwVqURVK+jjqaVBrneHmLi69VGPI
         kziCJAUth/6KEut+rHmOXU++RC2InDrJnVGhNOcCZ7WNJJUabdNjV5GklBNBlsdbZqS7
         KMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258724; x=1773863524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8u5o092L3ULCpmoipnWOnXiIPpIcwoMHmpMXH/cA6Oo=;
        b=N+TUFaUh3zwIlgsIsyu8y/SIVBdqACCmrPQPz50XzH6KUTyk15Q0sQRs17YoT2MkWX
         YBewn8aTsvD/hSrif/F9G/Se29DekhPLuLdj9Lx+inO4jYWiMcRdb96kaxhwl7Pqh9hN
         lPnaquJJYPteka4Ixghs0bmgR87FpPgMub3lP76QIpAgkm7zeRr2IeI+68xMmokD7NcW
         E7+RvMwV1QWSKjcukbt9qSQ5joNFKTwUAaG512igK67zpv0cjYahjwMdvsxJ+be/33G/
         cQi5f1Fnh9xLJi99hJK2gD1icXU4rfNUvPBwR7ZqQAhyUKPafFzR+GfyVFvwjY7kPoof
         9X+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUICVgRUi172bqh7TivYXzzuzk4KqE9NS7fwTxCerLAInVlm5a/cUQ+0M5hlXU5O/QckmqLLQENdw==@kvack.org
X-Gm-Message-State: AOJu0Yy62tMAaKscICFK0n9pYtQ3r2IyZljp7V596MSAYVgOssF/OyHA
	sgjUi8u/fm2pXAinJuzm4u6mDnBywmUdlo9qx7S3ppB4YBco3hpMj345
X-Gm-Gg: ATEYQzzhqZ08f19uW7Dz4zgLWLJ6+X4BxSeBo3D6HrOvAWcnM1Yf6yyvsK/EbXpLG2O
	4IdF/4xAtq27dvUDT4qlz7X028Bacb8H5NViF4oA4erN4l9q/oqNMRVZRVQ+1M9aOffbxiygyYv
	amGB0OwnTH5KFEyRgQ5SMlXzy/cSiMjMGdRQU7mwjRFOu368kYdSpmKNqMRd9pxlhaxXIwgvezg
	LhfzZ/4m4ze/bswh8Ujj/Iz1GW4X5JCqM4xFL2PMXT9MkjqeSPxZBmhNG7G0AsRAJaj6X/RdkaY
	eeW8tlh+Kl5iqywEuuB/6E/allArpMMGnE6W4QpeR2ESm75mIliVsztqv6584l4Q6+QAvJ0L/8L
	zhUP71Gvf/09EB47e6T46QWJuZBN+7J1vOzIwsu6wuOO3J3b82wEIF77TUOFbezEYnB2NDmJj6R
	OHeGAiYEcwhWsTjvpWFrHggA==
X-Received: by 2002:a05:6870:169d:b0:3fa:eb8:4c92 with SMTP id 586e51a60fabf-4177c9c1dd0mr2187825fac.50.1773258724198;
        Wed, 11 Mar 2026 12:52:04 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e6e82cdsm3116391fac.18.2026.03.11.12.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:52:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 07/11] mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
Date: Wed, 11 Mar 2026 12:51:44 -0700
Message-ID: <20260311195153.4013476-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uwo674zi53ix6iitp5kw6t1brxeyq3o1
X-Rspamd-Queue-Id: 4D8FBA000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773258725-775462
X-HE-Meta: U2FsdGVkX19UVBGrKNd/nPJPB3WVPE3syLmluNo3gwqeu/IFLLPtKP3h+A4FaIGJ4Szq6WYohyJQA2e09OJq8BW9mhwMO9ebWj9INzUuuHo6DIEgJFuP5Sa9VJQnoWKOkBHcBhckAqJ0z6sLEmA6I5R90GHim4arHbX4+iGW/KugIrH9FP558zGKY9zbsgVhKRXF64eR0Ki6SpXdIsLhaERpkMhWTBRTZ5Z5fo1+4cxtcc9I3jNg9e5e9ANK95A6Ejiv2wyBiGmyj61HK0/v9mKaXCt8RbHTHxVSdJ/VEF5XwtgJrLwzvrZlfE10yhlBfU78wDjKmfAnaehoBd4f+7iZ5J6VkXB8YIWIL+AF5HoumybLkaE2jqcpXPiDdmAe9byYtHwgXV4pdHN/lAvO4IXQPo8O1Nw/y8EncFdWfyzxROxyLaRn5npAm3OudWvTt6b0eBF7m22VS4iCi5E92vmpUK8WMHXX0f3VMzeNrBKtqro/R1//09KvBo6hnXb/SLOQNwZrrnJwQZRvX+4O+4MtIL3ZstM3zNDSWFby43jXSm7O3xT5yepseyXObV/AhxamPjmkHC0s5PBQrO6EHeSNtgCwMSH/1McR1kO/D8jRd3uvm69Fh3qWR1jjH9dp1SL2MnA+7WBWX0kKZkN3vUO9J5YYeUB9rPlIjChtDgyLHAwC520Fk7aqWXS4/rYaIZTQOus0+BADxEs0fvSGxG3VPUegZrgbnzLikSQrCpJ80bp7qcEKB7VaoOkpUE9oPKSXc6s1nvenPFXy3tXucR/4BDYhkSja8h7a9ilMCakAkA98e/99gy0scZXIB9Ybtl2Xu9i56HZiEs6sUcq1IWd9s+M2gmJBTrJhQq3ITLcXi2w02qHoB9n1mN8Q350tT+WtmiA92Dpc6nP+igUD1392/k/kXowSUHMXQNptg153Xzi4SRgMqHJvscdKv/x7t5iDPKP2+qKKkwJ4Ebq
 1CXLuWRw
 FKkIQa6q+udKVKyoHIA1KQ5+iONa/5wfbRJuTYf3PTlurz2gawlZlD7FoDn7iaKepQuxzE8DmnGYFmUh2KkLbHf+9H6Arjtmsl8HC9SM/cCg/dWauYxjfO2yNZrDR9TRsvXlkzgCORCdTOpuhOLLQZt7w6AfKoQ7AnVgmYFolf/D4OYtcyvcf6j496E6qxRfFkp/p/t5YUVm9LQbOU460GzICj9GGzi/c8FnGR/PerXiKstqfg7y7ZgJWCUH6ye9IV+Xnq30Z1Db7+UE1bkpxHZIccHiokeTnx10SLQo7TQTgMSEPVtzKAZYWg/NHCcVGo1RO0vjKR1u9q6W0XYDplJFqcWEu21urqNss++Z5Mi1oHO3/dTuc7MJhgw2Mo6aWgl8kP7EUUHjvAVPMdvWvSi0yPEfXxZAN7pzNlxPktBOPjiitHS0xiJdZV1kNfsoALGdoqyyEMqiU0AqtF6PJ81BAXk4lpTSVtN3ViaThRWv4y0BOBQNJmhwujuQ9fdOdjNw6BDrXtMnS2tyiYF+7dTDK+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that zswap_entries do not directly track obj_cgroups of the entries,
handle the lifetime management and charging of these entries into the
zsmalloc layer.

One functional change is that zswap entries are now no longer accounted
by the size of the compressed object, but by the size of the size_class
slot they occupy.

This brings charging one step closer to an accurate representation of
the memory consumed in the zpdesc; even if a compressed object doesn't
consume the entirety of a obj slot, we should account the entirety of
the compressed object slot that the object makes unusable.

While at it, also remove an unnecessary newline in obj_free.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 10 ------
 mm/memcontrol.c            | 54 ++-----------------------------
 mm/zsmalloc.c              | 65 ++++++++++++++++++++++++++++++++++++--
 mm/zswap.c                 |  8 -----
 4 files changed, 66 insertions(+), 71 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0652db4ff2d5..701d9ab6fef1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1851,22 +1851,12 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
-void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
-void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
 }
-static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
-					   size_t size)
-{
-}
-static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
-					     size_t size)
-{
-}
 static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a52da3a5e4fd..68139be66a4f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -716,6 +716,7 @@ void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 
 	put_cpu();
 }
+EXPORT_SYMBOL(mod_memcg_state);
 
 #ifdef CONFIG_MEMCG_V1
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -3169,11 +3170,13 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 {
 	return obj_cgroup_charge_account(objcg, gfp, size, NULL, 0);
 }
+EXPORT_SYMBOL(obj_cgroup_charge);
 
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 {
 	refill_obj_stock(objcg, size, true, 0, NULL, 0);
 }
+EXPORT_SYMBOL(obj_cgroup_uncharge);
 
 static inline size_t obj_full_size(struct kmem_cache *s)
 {
@@ -5488,57 +5491,6 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 	return ret;
 }
 
-/**
- * obj_cgroup_charge_zswap - charge compression backend memory
- * @objcg: the object cgroup
- * @size: size of compressed object
- *
- * This forces the charge after obj_cgroup_may_zswap() allowed
- * compression and storage in zswap for this cgroup to go ahead.
- */
-void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
-{
-	struct mem_cgroup *memcg;
-
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
-
-	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
-
-	/* PF_MEMALLOC context, charging must succeed */
-	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
-		VM_WARN_ON_ONCE(1);
-
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
-	rcu_read_unlock();
-}
-
-/**
- * obj_cgroup_uncharge_zswap - uncharge compression backend memory
- * @objcg: the object cgroup
- * @size: size of compressed object
- *
- * Uncharges zswap memory on page in.
- */
-void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
-{
-	struct mem_cgroup *memcg;
-
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
-
-	obj_cgroup_uncharge(objcg, size);
-
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
-	rcu_read_unlock();
-}
-
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index a94ca8c26ad9..291194572a09 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1028,6 +1028,59 @@ static bool zspage_empty(struct zspage *zspage)
 	return get_zspage_inuse(zspage) == 0;
 }
 
+#ifdef CONFIG_MEMCG
+static void zs_charge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
+			    int size)
+{
+	struct mem_cgroup *memcg;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
+	WARN_ON_ONCE(!pool->memcg_aware);
+
+	/* PF_MEMALLOC context, charging must succeed */
+	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
+		VM_WARN_ON_ONCE(1);
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_state(memcg, pool->compressed_stat, size);
+	mod_memcg_state(memcg, pool->uncompressed_stat, 1);
+	rcu_read_unlock();
+}
+
+static void zs_uncharge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
+			      int size)
+{
+	struct mem_cgroup *memcg;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	WARN_ON_ONCE(!pool->memcg_aware);
+
+	obj_cgroup_uncharge(objcg, size);
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_state(memcg, pool->compressed_stat, -size);
+	mod_memcg_state(memcg, pool->uncompressed_stat, -1);
+	rcu_read_unlock();
+}
+#else
+static void zs_charge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
+			    int size)
+{
+}
+
+static void zs_uncharge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
+			      int size)
+{
+}
+#endif
+
 /**
  * zs_lookup_class_index() - Returns index of the zsmalloc &size_class
  * that hold objects of the provided size.
@@ -1244,6 +1297,8 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 	if (objcg) {
 		WARN_ON_ONCE(!pool->memcg_aware);
 		zspage->objcgs[obj_idx] = objcg;
+		obj_cgroup_get(objcg);
+		zs_charge_objcg(pool, objcg, class->size);
 	}
 
 	if (!ZsHugePage(zspage))
@@ -1409,17 +1464,23 @@ static void obj_free(int class_size, unsigned long obj)
 	struct link_free *link;
 	struct zspage *zspage;
 	struct zpdesc *f_zpdesc;
+	struct zs_pool *pool;
 	unsigned long f_offset;
 	unsigned int f_objidx;
 	void *vaddr;
 
-
 	obj_to_location(obj, &f_zpdesc, &f_objidx);
 	f_offset = offset_in_page(class_size * f_objidx);
 	zspage = get_zspage(f_zpdesc);
+	pool = zspage->pool;
+
+	if (pool->memcg_aware && zspage->objcgs[f_objidx]) {
+		struct obj_cgroup *objcg = zspage->objcgs[f_objidx];
 
-	if (zspage->pool->memcg_aware)
+		zs_uncharge_objcg(pool, objcg, class_size);
+		obj_cgroup_put(objcg);
 		zspage->objcgs[f_objidx] = NULL;
+	}
 
 	vaddr = kmap_local_zpdesc(f_zpdesc);
 	link = (struct link_free *)(vaddr + f_offset);
diff --git a/mm/zswap.c b/mm/zswap.c
index 436066965413..bca29a6e18f3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -711,10 +711,6 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	zswap_lru_del(&zswap_list_lru, entry, objcg);
 	zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
-	if (objcg) {
-		obj_cgroup_uncharge_zswap(objcg, entry->length);
-		obj_cgroup_put(objcg);
-	}
 	if (entry->length == PAGE_SIZE)
 		atomic_long_dec(&zswap_stored_incompressible_pages);
 	zswap_entry_cache_free(entry);
@@ -1437,10 +1433,6 @@ static bool zswap_store_page(struct page *page,
 	 * when the entry is removed from the tree.
 	 */
 	zswap_pool_get(pool);
-	if (objcg) {
-		obj_cgroup_get(objcg);
-		obj_cgroup_charge_zswap(objcg, entry->length);
-	}
 	atomic_long_inc(&zswap_stored_pages);
 	if (entry->length == PAGE_SIZE)
 		atomic_long_inc(&zswap_stored_incompressible_pages);
-- 
2.52.0


