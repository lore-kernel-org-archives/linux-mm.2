Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDE43CD343F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D11B6B00D1; Tue,  5 May 2026 11:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEE36B00D2; Tue,  5 May 2026 11:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F466B00D3; Tue,  5 May 2026 11:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2806B00D1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDF281C0475
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:50 +0000 (UTC)
X-FDA: 84733776540.20.E43A0FE
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8B58160010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lEakyASL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1GFC//rZpyawf7P6IxHBKxiduOuIyH6Indf4FQKWpk=;
	b=YOi0j5nDvuXyLn2e4Pi/9qh8mFTkpMJtGjXiJigYWsKLjeXtVQ7vrkoIMjS+rA0yKqxaqi
	ug+gdc2fFRW7ZGUpP209XpCUAhVlK3Sk+j1xukQ0qYs7axF7vH14r9oUGqD91FxIBg0Esl
	ugyUAdm2DsGIoxowRE67hIL/928eaCI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995589; a=rsa-sha256;
	cv=none;
	b=krwiWondJbOQ7Y2AYRoqAfp3NyjGbQlndT7/0GTPuIEWXNCJzRcSfE/+HWA+uXZQ42GTTG
	rSbnD48efwyfEKXa3divPW97xj0CZsxG7TYn60s7yBHd4+SPVnoWEA0H6wgkv053+t2hxv
	ZtNTzoDkLrkGU4IVmrjT8xaEUkYJxHQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lEakyASL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7dea1272943so3245321a34.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995588; x=1778600388; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1GFC//rZpyawf7P6IxHBKxiduOuIyH6Indf4FQKWpk=;
        b=lEakyASLsa8JUnlA5ZiNsMzWNAP959gOl3tBk0YCw48NT3ML5np259uOvHRxR6RZ7c
         wbsDkPUkeCboIi8pkqHhbD0n3a9fPcuvaGvC81rW69bWfWN2rYsoS75L5tNXSrPS6VQc
         ryHtdE+Kdv2Yim6Wc8GC1d1iLXaDdHl0e6Z17Bs1Ff8GIyK+h8nO222FXQrSfyuxyapD
         zqAa/ufR2UyHGgPJxvvODNL0IG1F4prpy6QB4br1BuX4/HSPy1PZEX4p79fODvA6dRir
         /+27lzSDlMgYcvaIshmjl6SSMcw51s9hUrdo5g4hW9Ihe6acl77mI4NMFo/B0PvHCViV
         /qgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995588; x=1778600388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O1GFC//rZpyawf7P6IxHBKxiduOuIyH6Indf4FQKWpk=;
        b=N28D6q2y9fkNTgNHuH+x0jAOj0g+8/QRK0IFBoc+oP8RUECe7jyCtkN9a7Mpzo+7G1
         jo85+Dtk6lLylBkTqmx8ed3e+plOwZj3PixLaViwypvdCMjLBa8CBErxJM0PJI8HWG2f
         43y0JwROdez+GdgDOf7YBfano2bNGGqCKP33OpurYyOuzF957pVGfgjOMLwevIQycuLw
         iAs8XQdrBgr2zPGDwokngX0JcyrXEKgJasBvPbuKQFSXebfl61QBFuMPSghqXNwkvZwK
         sHj6TNC51MxC1h8EWFE4bvi3qMaZRrM8JUYTzRN01htZTyUk4mUKn9Ls0VWUZJBCEhja
         EcxA==
X-Forwarded-Encrypted: i=1; AFNElJ9UR9nw/bKkqpu7JM1FEsxCda4NkdI+0VCrGH8g1fUots+NhPYiXUFI6pkaSxKxZ/h7vdpqSLQhGg==@kvack.org
X-Gm-Message-State: AOJu0Yws7S9ySZUxCzmJ70fUSaAOJSqUdSa0N96UX/WslCeCXpZudrt7
	vOcCFDkTFXZ7ZqCz1jWv9AAW/Skfj5D7scniG3LXx3KUUE1amkFm7+uH
X-Gm-Gg: AeBDiesr4Lt3wzNwqBodH1CTWxzyhwzcS8avfi87bmfjEqtOtcxcA2sGq+XIWWvzO9h
	RRepeypgKDrfOfbRT+WPki6c/bsnMCV137Bt/b3KwZCmZ5hJLm7YIJ74+Ua7zHYNyoIBcK+1nBP
	My3F1o89rueAxFzkpJhhfttNlv3nIdXvvh+vNc0g7MOH8MurP59pWotu6HxgKJpSXA/XhzPRwxU
	x/AbV268l3lV3Dffbq2JkU/6jjUfD/HUiXB6B9VJVMZVd5+RWDdzLzUyW6nrH8ZiPF3KzuVVK6D
	pg73Bz7TwbjeK5QJRM39/R2jlPiQzUSjYwFD6D7Fkerl5OzaTG4wgX44RB083JeDaczx1gFDvO/
	OkToUNrSCTpMh2bD+SRWlg3bNtY99tUoHY+B73EywvjfvIqQbzMLsd61yw9MTLHWQRHq7Ys1KuP
	BOjgHB2g7CxvQQa0I9kp5m/sbRNXXeCDm8e27WAgy1dclsu/GUIxVXlEcn
X-Received: by 2002:a05:6830:630d:b0:7dc:d0e3:5bdd with SMTP id 46e09a7af769-7e17d08a7damr2045882a34.19.1777995587726;
        Tue, 05 May 2026 08:39:47 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7decae2be8dsm10220944a34.25.2026.05.05.08.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:46 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 22/22] vswap: cache cluster lookup
Date: Tue,  5 May 2026 08:38:51 -0700
Message-ID: <20260505153854.1612033-23-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D8B58160010
X-Rspamd-Server: rspam04
X-Stat-Signature: rx9ozt8bmecq1m1whn57phe99gbmofia
X-HE-Tag: 1777995588-98475
X-HE-Meta: U2FsdGVkX18WAM960qmXCuhc/dSxLkNG4cXA3tIjDxwKM9BltTwz6wLhSQn5rxGIRoB0eS0+8pTlwnOR35k7okS2FcAfIpuvgq2Cncw8pEtbIU6b89b+7uOpEeQC35BbrY+1sBRgux6/P+T/k6VNpByv7S1EAQeCsZVuEXu0B+JbTfcBuuBQf/vcyHYOiYZPWS6PaVzTW4HEUZSnFK1EyYw1jiCmpVnSYKeJEUOyQ7AyoEG8dQop0hus99J4xzAdKdHGBZIBsk8WYsUyJ0lDwZ+2xhUBs0ovQ/HyTMElbvh0MAMp4XkSX0a4cXoTZSz1OHVvGLj7WlcD79NnQvRIzWGup30z8wDfIQEikUtEpmafWoe+YeTZ7w1LNbqb23ArfiPFl7P5dh9UquxJLB/EEU6zSzIVTFmzpZlxkRivS4FviV0231se2hlx1vuhzfaRNQ5VRkAiDEiHd9QA6cv7ftg6HUNLfqYNU26MecaFxA83nDYTB5k5jeXDHQfHOmlLIi4IHOI3sttZJok+8itnw2Ku8W5Co2YvXavuNLgOUxVTmIUrEePuPvyEP1IIefTlJ8lcmdwGWLrmB6KRA/EiQ4dA+5/nolsOJ+UXHhKG8ljP6cC3G3ZkrtCJ+L2StUmWjlbNKwIwoMJ3x3pYwteuD+z1YNQwHD8BNmyyX3xwAQYmsZ3dH10qNgDPdOWjgET5B44L7E2SEWiusKgYepT1fwMZFo/P5frTjUTQZG+zYxTj+V4nCdjHFKm4ekq+kEvAkLy6CvTfJKi/gKWdilBB/5SXmI8NKZ+0ABx5/ZK2uTo7dc7jwRhTRWoLeBwyw2jMVXDstA92H4YwyiBsQSEqGWFf23lkk2Vk3Ishd4JVtUDOLdJgtT2oIWOvcvOOhiKD32NPR6Z1wXs2gC6G3H9CVuFF2uDIUp94YdSaNtDWzY8D6zbO5EIhBQZZ+FAG4c1VtmTjZv3GerXV7IBraus
 ubWTTWb3
 JBhYkM8EhZKmIAs6wiu/OaBEG5brOlGj4/M2g9XFWU4vX1hyKkmk39Ge95MZpPrTXFEEBjJuPkInSJQ7P4VUxOdqxQdG9RTatFaaATxh9URLWzoBHgbYKVgQnm8uhnwtM6XVV3IzrGgV/IuLTGAdkAWY0WhIv85a0ERsehyCflzocTDc5YAHaHMaukrAzy00n91CsDE9k9jEX8M0n8GnpUnTGoVXIjZeKkZ/Hj20dy8TQC7BalSsXnbtKkf8JWXdspG2fQ1f5nUb5tItwusbf2VmBE9rl6CEgTTkmZln6gVAGc4CeKIyw7VmAax5/9p63T2AFfSMi0+bvC1lHKoJSOaBkVRN+70C5EKWlVkYRvoc0FlE+ZJP1K+dqHrj67MBjMYJ8Q5sPm6HOs6FVw6ytznFwNuOz97yQJoMz1V9tHi/0eUn4EwmT76U/OP/3oEyXqsbUCtpCT+OHA7EEgbZ7j1V23Cxewziqn9JjSQ3w3KVo+0MfAeytwwbJX0G8buSpb8eKkhEtA/fYYzea/FpPPfLA8ffPcFQqlws4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking up the vswap cluster from the global xarray on every vswap
operation shows up in profiles for swap-heavy workloads. The xa_load
cost is paid even when consecutive operations target the same cluster,
which is the common case for swap out, swap in, and swap freeing on
process teardown paths.

Inspired by how the TLB caches virtual-to-physical address
translations, add a per-CPU cache for the most recently used vswap
cluster pointer so consecutive lookups on the same cluster can skip
the xarray traversal.

The cache holds a reference on the cluster. It is cleared on:
- a lookup that targets a different cluster,
- the cached cluster becoming empty at the end of a swap operation,
- the CPU going offline.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/vswap.c | 344 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 286 insertions(+), 58 deletions(-)

diff --git a/mm/vswap.c b/mm/vswap.c
index f07e6d9ec1df..f87df0f9d186 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -216,6 +216,62 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+/*
+ * Per-CPU cache of the most recently used cluster during vswap_iter().
+ * This allows us to skip the xarray lookup if the same cluster is being
+ * iterated over again. We increment a reference to the cluster when it
+ * is cached here to keep the cluster alive.
+ */
+struct percpu_vswap_iter_cache {
+	struct vswap_cluster *cluster;
+	local_lock_t lock;
+};
+
+static DEFINE_PER_CPU(struct percpu_vswap_iter_cache, percpu_vswap_iter_cache) = {
+	.cluster = NULL,
+	.lock = INIT_LOCAL_LOCK(),
+};
+
+static inline struct vswap_cluster *read_cached_vswap_cluster(void)
+{
+	struct vswap_cluster *cached;
+
+	/*
+	 * The returned pointer (if non-NULL) is only protected by RCU. The per-CPU
+	 * cache holds a +1 refcount on its cached cluster, but another context may
+	 * evict the cache between this read and the caller's use of the pointer:
+	 * the refcount can drop to 0, vswap_cluster_free() may queue the cluster
+	 * for kvfree_rcu(), and the per-CPU slot may even be replaced by a
+	 * different cluster. Because the caller holds rcu_read_lock(), the
+	 * kvfree_rcu() grace period cannot complete and the returned pointer
+	 * remains valid memory throughout the RCU critical section. Pointer
+	 * comparisons (e.g. inside try_to_clear_local_vswap_iter_cache()) stay
+	 * meaningful for the same reason.
+	 */
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "must be called under rcu_read_lock()");
+
+	local_lock(&percpu_vswap_iter_cache.lock);
+	cached = this_cpu_read(percpu_vswap_iter_cache.cluster);
+	local_unlock(&percpu_vswap_iter_cache.lock);
+
+	return cached;
+}
+
+static inline struct vswap_cluster *read_cached_vswap_cluster_irq(void)
+{
+	struct vswap_cluster *cached;
+
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "must be called under rcu_read_lock()");
+
+	local_lock_irq(&percpu_vswap_iter_cache.lock);
+	cached = this_cpu_read(percpu_vswap_iter_cache.cluster);
+	local_unlock_irq(&percpu_vswap_iter_cache.lock);
+
+	return cached;
+}
+
 static atomic_t vswap_alloc_reject;
 static atomic_t vswap_used;
 
@@ -261,28 +317,74 @@ static struct swp_desc *__vswap_iter(struct vswap_cluster *cluster, unsigned lon
 	return NULL;
 }
 
+static void vswap_cluster_put(struct vswap_cluster *cluster, int nr);
+
+static void try_to_clear_local_vswap_iter_cache(struct vswap_cluster *cluster)
+{
+	lockdep_assert_held(&cluster->lock);
+	local_lock(&percpu_vswap_iter_cache.lock);
+	if (this_cpu_read(percpu_vswap_iter_cache.cluster) == cluster) {
+		this_cpu_write(percpu_vswap_iter_cache.cluster, NULL);
+		vswap_cluster_put(cluster, 1);
+	}
+	local_unlock(&percpu_vswap_iter_cache.lock);
+}
+
+static void try_to_cache_local_vswap_iter_cache(struct vswap_cluster *cluster)
+{
+	lockdep_assert_held(&cluster->lock);
+	local_lock(&percpu_vswap_iter_cache.lock);
+	if (!this_cpu_read(percpu_vswap_iter_cache.cluster)) {
+		this_cpu_write(percpu_vswap_iter_cache.cluster, cluster);
+		refcount_inc(&cluster->refcnt);
+	}
+	local_unlock(&percpu_vswap_iter_cache.lock);
+}
+
 static struct swp_desc *vswap_iter(struct vswap_cluster **clusterp, unsigned long i)
 {
 	unsigned long cluster_id = VSWAP_VAL_CLUSTER_IDX(i);
 	struct vswap_cluster *cluster = *clusterp;
+	struct vswap_cluster *cached = NULL;
 	struct swp_desc *desc = NULL;
 	unsigned long slot_index;
+	bool need_clear_cache = false;
 
 	if (!cluster || cluster_id != cluster->id) {
 		if (cluster)
 			spin_unlock(&cluster->lock);
-		cluster = xa_load(&vswap_cluster_map, cluster_id);
+
+		cached = read_cached_vswap_cluster();
+
+		if (cached && cached->id == cluster_id) {
+			cluster = cached;
+		} else {
+			need_clear_cache = (cached != NULL);
+			cluster = xa_load(&vswap_cluster_map, cluster_id);
+		}
+
+		if (need_clear_cache) {
+			spin_lock(&cached->lock);
+			try_to_clear_local_vswap_iter_cache(cached);
+			spin_unlock(&cached->lock);
+		}
+
 		if (!cluster)
 			goto done;
 		VM_WARN_ON(cluster->id != cluster_id);
 		spin_lock(&cluster->lock);
+	} else {
+		cached = cluster;
 	}
 
 	slot_index = VSWAP_IDX_WITHIN_CLUSTER_VAL(i);
-	if (test_bit(slot_index, cluster->bitmap))
+	if (test_bit(slot_index, cluster->bitmap)) {
 		desc = &cluster->descriptors[slot_index];
-
-	if (!desc) {
+		if (cached != cluster)
+			try_to_cache_local_vswap_iter_cache(cluster);
+	} else {
+		if (!cluster->count)
+			try_to_clear_local_vswap_iter_cache(cluster);
 		spin_unlock(&cluster->lock);
 		cluster = NULL;
 	}
@@ -292,6 +394,17 @@ static struct swp_desc *vswap_iter(struct vswap_cluster **clusterp, unsigned lon
 	return desc;
 }
 
+static void vswap_iter_break(struct vswap_cluster *cluster)
+{
+	if (!cluster)
+		return;
+
+	if (!cluster->count)
+		try_to_clear_local_vswap_iter_cache(cluster);
+
+	spin_unlock(&cluster->lock);
+}
+
 static bool cluster_is_alloc_candidate(struct vswap_cluster *cluster)
 {
 	return cluster->count + (1 << (cluster->order)) <= VSWAP_CLUSTER_SIZE;
@@ -412,7 +525,7 @@ int folio_alloc_swap(struct folio *folio)
 		cluster = kmem_cache_zalloc(vswap_cluster_cache, GFP_KERNEL);
 		if (cluster) {
 			cluster->descriptors = vzalloc(array_size(VSWAP_CLUSTER_SIZE,
-						sizeof(struct swp_desc)));
+							sizeof(struct swp_desc)));
 			if (!cluster->descriptors) {
 				kmem_cache_free(vswap_cluster_cache, cluster);
 				cluster = NULL;
@@ -529,6 +642,13 @@ static void vswap_cluster_free(struct vswap_cluster *cluster)
 	call_rcu(&cluster->rcu, vswap_cluster_free_rcu);
 }
 
+static void vswap_cluster_put(struct vswap_cluster *cluster, int nr)
+{
+	lockdep_assert_held(&cluster->lock);
+	if (refcount_sub_and_test(nr, &cluster->refcnt))
+		vswap_cluster_free(cluster);
+}
+
 static inline void release_vswap_slot_nr(struct vswap_cluster *cluster,
 		unsigned long index, int nr)
 {
@@ -819,7 +939,7 @@ swp_slot_t vswap_alloc_swap_slot(struct folio *folio)
 		desc->type = VSWAP_SWAPFILE;
 		desc->slot.val = slot.val + i;
 	}
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 
 	return slot;
 }
@@ -854,7 +974,7 @@ swp_slot_t swp_entry_to_swp_slot(swp_entry_t entry)
 		slot.val = 0;
 	else
 		slot = desc->slot;
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 
 	return slot;
@@ -946,8 +1066,7 @@ static bool vswap_free_nr_any_cache_only(swp_entry_t entry, int nr)
 	}
 	if (free_nr)
 		vswap_free_nr(cluster, free_start, free_nr);
-	if (cluster)
-		spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 	return ret;
 }
@@ -979,8 +1098,7 @@ static int swap_duplicate_nr(swp_entry_t entry, int nr)
 		desc->swap_count++;
 	}
 done:
-	if (cluster)
-		spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 	if (i && i < nr)
 		swap_free_nr(entry, i);
@@ -1008,7 +1126,7 @@ int swap_duplicate(swp_entry_t entry)
  */
 bool folio_free_swap(struct folio *folio)
 {
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	swp_entry_t entry = folio->swap;
 	int i, nr = folio_nr_pages(folio);
 	unsigned long cluster_id;
@@ -1028,8 +1146,21 @@ bool folio_free_swap(struct folio *folio)
 	cluster_id = VSWAP_CLUSTER_IDX(entry);
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+
+	cached = read_cached_vswap_cluster_irq();
+
+	if (!cached || cached->id != cluster_id)
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
+	else
+		cluster = cached;
 	VM_WARN_ON(!cluster);
+
+	if (cached && cached != cluster) {
+		spin_lock_irq(&cached->lock);
+		try_to_clear_local_vswap_iter_cache(cached);
+		spin_unlock_irq(&cached->lock);
+	}
+
 	spin_lock_irq(&cluster->lock);
 
 	/* check if any PTE still points to the swap entries */
@@ -1050,6 +1181,8 @@ bool folio_free_swap(struct folio *folio)
 	}
 
 	vswap_free_nr(cluster, entry, nr);
+	if (!cluster->count)
+		try_to_clear_local_vswap_iter_cache(cluster);
 	spin_unlock_irq(&cluster->lock);
 	rcu_read_unlock();
 
@@ -1080,8 +1213,7 @@ int swp_swapcount(swp_entry_t entry)
 	rcu_read_lock();
 	desc = vswap_iter(&cluster, entry.val);
 	ret = desc ? desc->swap_count : 0;
-	if (cluster)
-		spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 
 	return ret;
@@ -1142,7 +1274,7 @@ void swapcache_clear(swp_entry_t entry, int nr)
 	desc = vswap_iter(&cluster, entry.val);
 	VM_WARN_ON(!desc);
 	__swapcache_clear(cluster, entry, nr);
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 }
 
@@ -1174,8 +1306,7 @@ int swapcache_prepare(swp_entry_t entry, int nr)
 		desc->in_swapcache = true;
 	}
 done:
-	if (cluster)
-		spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 	if (i && i < nr)
 		swapcache_clear(entry, i);
@@ -1199,8 +1330,7 @@ bool is_swap_cached(swp_entry_t entry)
 	rcu_read_lock();
 	desc = vswap_iter(&cluster, entry.val);
 	cached = desc ? desc->in_swapcache : false;
-	if (cluster)
-		spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 
 	return cached;
@@ -1231,8 +1361,7 @@ int non_swapcache_batch(swp_entry_t entry, int max_nr)
 			goto done;
 	}
 done:
-	if (cluster)
-		spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 	return i;
 }
@@ -1268,7 +1397,7 @@ void vswap_store_folio(swp_entry_t entry, struct folio *folio)
 		desc->type = VSWAP_FOLIO;
 		desc->swap_cache = folio;
 	}
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 }
 
@@ -1349,7 +1478,7 @@ void swap_zeromap_folio_set(struct folio *folio)
 		VM_WARN_ON(!desc);
 		desc->type = VSWAP_ZERO;
 	}
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 
 	count_vm_events(SWPOUT_ZERO, nr);
@@ -1419,8 +1548,7 @@ static int vswap_check_backing(swp_entry_t entry, enum swap_type *type, int nr,
 		/* Caller takes ownership of the lock and rcu_read_lock */
 		*clusterp = cluster;
 	} else {
-		if (cluster)
-			spin_unlock(&cluster->lock);
+		vswap_iter_break(cluster);
 		rcu_read_unlock();
 	}
 	if (type)
@@ -1498,8 +1626,7 @@ int swap_zeromap_batch(swp_entry_t entry, int max_nr, bool *is_zeromap)
 			goto done;
 	}
 done:
-	if (cluster)
-		spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 	if (i && is_zeromap)
 		*is_zeromap = is_zero;
@@ -1614,9 +1741,9 @@ void put_swap_entry(swp_entry_t entry, struct swap_info_struct *si)
 
 	rcu_read_lock();
 	cluster = xa_load(&vswap_cluster_map, VSWAP_CLUSTER_IDX(entry));
+	VM_WARN_ON(!cluster);
 	spin_lock(&cluster->lock);
-	if (refcount_dec_and_test(&cluster->refcnt))
-		vswap_cluster_free(cluster);
+	vswap_cluster_put(cluster, 1);
 	spin_unlock(&cluster->lock);
 	rcu_read_unlock();
 }
@@ -1637,14 +1764,26 @@ static int vswap_cpu_dead(unsigned int cpu)
 	int order;
 
 	guard(rcu)();
+
+	/*
+	 * No need to take local_lock for the dead CPU's per-CPU caches,
+	 * as no local modifications can happen on a dead CPU.
+	 */
+	cluster = per_cpu(percpu_vswap_iter_cache.cluster, cpu);
+	if (cluster) {
+		spin_lock(&cluster->lock);
+		per_cpu(percpu_vswap_iter_cache.cluster, cpu) = NULL;
+		vswap_cluster_put(cluster, 1);
+		spin_unlock(&cluster->lock);
+	}
+
 	for (order = 0; order < SWAP_NR_ORDERS; order++) {
 		cluster = per_cpu(percpu_vswap_cluster.clusters[order], cpu);
 		if (cluster) {
 			per_cpu(percpu_vswap_cluster.clusters[order], cpu) = NULL;
 			spin_lock(&cluster->lock);
 			cluster->cached = false;
-			if (refcount_dec_and_test(&cluster->refcnt))
-				vswap_cluster_free(cluster);
+			vswap_cluster_put(cluster, 1);
 			spin_unlock(&cluster->lock);
 		}
 	}
@@ -1660,13 +1799,26 @@ static int vswap_cpu_dead(unsigned int cpu)
  */
 void swap_cache_lock(swp_entry_t entry)
 {
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	cached = read_cached_vswap_cluster();
+
+	if (!cached || cached->id != cluster_id)
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
+	else
+		cluster = cached;
 	VM_WARN_ON(!cluster);
+
+	if (cached && cached != cluster) {
+		spin_lock(&cached->lock);
+		try_to_clear_local_vswap_iter_cache(cached);
+		spin_unlock(&cached->lock);
+	}
+
 	spin_lock(&cluster->lock);
+	try_to_cache_local_vswap_iter_cache(cluster);
 	rcu_read_unlock();
 }
 
@@ -1678,12 +1830,20 @@ void swap_cache_lock(swp_entry_t entry)
  */
 void swap_cache_unlock(swp_entry_t entry)
 {
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	cached = read_cached_vswap_cluster();
+
+	if (!cached || cached->id != cluster_id)
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
+	else {
+		cluster = cached;
+		try_to_clear_local_vswap_iter_cache(cached);
+	}
 	VM_WARN_ON(!cluster);
+
 	spin_unlock(&cluster->lock);
 	rcu_read_unlock();
 }
@@ -1696,13 +1856,27 @@ void swap_cache_unlock(swp_entry_t entry)
  */
 void swap_cache_lock_irq(swp_entry_t entry)
 {
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+
+	cached = read_cached_vswap_cluster_irq();
+
+	if (!cached || cached->id != cluster_id)
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
+	else
+		cluster = cached;
 	VM_WARN_ON(!cluster);
+
+	if (cached && cached != cluster) {
+		spin_lock_irq(&cached->lock);
+		try_to_clear_local_vswap_iter_cache(cached);
+		spin_unlock_irq(&cached->lock);
+	}
+
 	spin_lock_irq(&cluster->lock);
+	try_to_cache_local_vswap_iter_cache(cluster);
 	rcu_read_unlock();
 }
 
@@ -1714,11 +1888,18 @@ void swap_cache_lock_irq(swp_entry_t entry)
  */
 void swap_cache_unlock_irq(swp_entry_t entry)
 {
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	cached = read_cached_vswap_cluster();
+
+	if (!cached || cached->id != cluster_id)
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
+	else {
+		cluster = cached;
+		try_to_clear_local_vswap_iter_cache(cluster);
+	}
 	VM_WARN_ON(!cluster);
 	spin_unlock_irq(&cluster->lock);
 	rcu_read_unlock();
@@ -1746,24 +1927,24 @@ static struct folio *vswap_get_swap_cache(swp_entry_t entry, bool swap_cache_onl
 		if (!desc->in_swapcache ||
 		    xa_is_value(desc->shadow) ||
 		    (swap_cache_only && desc->swap_count)) {
-			spin_unlock(&cluster->lock);
+			vswap_iter_break(cluster);
 			rcu_read_unlock();
 			return NULL;
 		}
 
 		folio = desc->swap_cache;
 		if (!folio) {
-			spin_unlock(&cluster->lock);
+			vswap_iter_break(cluster);
 			rcu_read_unlock();
 			return NULL;
 		}
 
 		if (likely(folio_try_get(folio))) {
-			spin_unlock(&cluster->lock);
+			vswap_iter_break(cluster);
 			rcu_read_unlock();
 			return folio;
 		}
-		spin_unlock(&cluster->lock);
+		vswap_iter_break(cluster);
 		cluster = NULL;
 		rcu_read_unlock();
 	}
@@ -1812,7 +1993,7 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	}
 
 	shadow = desc->shadow;
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 
 	if (xa_is_value(shadow))
@@ -1834,7 +2015,7 @@ void *swap_cache_get_shadow(swp_entry_t entry)
  */
 void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp)
 {
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	unsigned long nr_pages = folio_nr_pages(folio);
 	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
 	unsigned long i;
@@ -1850,9 +2031,23 @@ void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp
 	folio->swap = entry;
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+
+	cached = read_cached_vswap_cluster_irq();
+
+	if (!cached || cached->id != cluster_id)
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
+	else
+		cluster = cached;
 	VM_WARN_ON(!cluster);
+
+	if (cached && cached != cluster) {
+		spin_lock_irq(&cached->lock);
+		try_to_clear_local_vswap_iter_cache(cached);
+		spin_unlock_irq(&cached->lock);
+	}
+
 	spin_lock_irq(&cluster->lock);
+	try_to_cache_local_vswap_iter_cache(cluster);
 
 	for (i = 0; i < nr_pages; i++) {
 		desc = __vswap_iter(cluster, entry.val + i);
@@ -1892,7 +2087,7 @@ void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp
 void __vswap_remove_mapping(struct folio *folio, swp_entry_t entry, void *shadow)
 {
 	long nr_pages = folio_nr_pages(folio);
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
 	struct swp_desc *desc;
 	int i;
@@ -1902,7 +2097,18 @@ void __vswap_remove_mapping(struct folio *folio, swp_entry_t entry, void *shadow
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+
+	/*
+	 * The caller has already taken the cluster lock via
+	 * swap_cache_lock_irq(), which consults and updates the per-CPU
+	 * cluster cache. Read from the cache to avoid a redundant
+	 * xa_load() on the reclaim hot path.
+	 */
+	cached = read_cached_vswap_cluster();
+	if (cached && cached->id == cluster_id)
+		cluster = cached;
+	else
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
 	VM_WARN_ON(!cluster);
 
 	/* Set shadow on all descriptors */
@@ -1914,6 +2120,8 @@ void __vswap_remove_mapping(struct folio *folio, swp_entry_t entry, void *shadow
 
 	memcg1_swapout(folio, entry);
 	__swapcache_clear(cluster, entry, nr_pages);
+	if (cached == cluster && !cluster->count)
+		try_to_clear_local_vswap_iter_cache(cluster);
 	spin_unlock_irq(&cluster->lock);
 	rcu_read_unlock();
 
@@ -1938,7 +2146,7 @@ void swap_cache_del_folio(struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
 	swp_entry_t entry = folio->swap;
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
 	struct swp_desc *desc;
 	int i;
@@ -1948,9 +2156,23 @@ void swap_cache_del_folio(struct folio *folio)
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+
+	cached = read_cached_vswap_cluster_irq();
+
+	if (!cached || cached->id != cluster_id)
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
+	else
+		cluster = cached;
 	VM_WARN_ON(!cluster);
+
+	if (cached && cached != cluster) {
+		spin_lock_irq(&cached->lock);
+		try_to_clear_local_vswap_iter_cache(cached);
+		spin_unlock_irq(&cached->lock);
+	}
+
 	spin_lock_irq(&cluster->lock);
+	try_to_cache_local_vswap_iter_cache(cluster);
 
 	for (i = 0; i < nr_pages; i++) {
 		desc = __vswap_iter(cluster, entry.val + i);
@@ -1958,6 +2180,7 @@ void swap_cache_del_folio(struct folio *folio)
 		desc->shadow = NULL;
 	}
 
+	try_to_clear_local_vswap_iter_cache(cluster);
 	spin_unlock_irq(&cluster->lock);
 	rcu_read_unlock();
 
@@ -1987,7 +2210,7 @@ void __swap_cache_replace_folio(struct folio *old, struct folio *new)
 {
 	swp_entry_t entry = new->swap;
 	unsigned long nr_pages = folio_nr_pages(new);
-	struct vswap_cluster *cluster;
+	struct vswap_cluster *cached, *cluster;
 	struct swp_desc *desc;
 	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
 	void *old_entry;
@@ -1998,7 +2221,13 @@ void __swap_cache_replace_folio(struct folio *old, struct folio *new)
 	VM_WARN_ON_ONCE(!entry.val);
 
 	rcu_read_lock();
-	cluster = xa_load(&vswap_cluster_map, cluster_id);
+
+	cached = read_cached_vswap_cluster();
+
+	if (cached && cached->id == cluster_id)
+		cluster = cached;
+	else
+		cluster = xa_load(&vswap_cluster_map, cluster_id);
 	VM_WARN_ON(!cluster);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -2031,7 +2260,7 @@ void zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry)
 	release_backing(cluster, swpentry, 1, NULL);
 	desc->zswap_entry = entry;
 	desc->type = VSWAP_ZSWAP;
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 }
 
@@ -2059,7 +2288,7 @@ void *zswap_entry_load(swp_entry_t swpentry)
 
 	type = desc->type;
 	zswap_entry = desc->zswap_entry;
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 
 	if (type != VSWAP_ZSWAP)
@@ -2130,7 +2359,7 @@ static unsigned short vswap_cgroup_record(swp_entry_t entry,
 	desc = vswap_iter(&cluster, entry.val);
 	VM_WARN_ON(!desc);
 	oldid = __vswap_cgroup_record(cluster, entry, memcgid, nr_ents);
-	spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 
 	return oldid;
@@ -2199,8 +2428,7 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t entry)
 	rcu_read_lock();
 	desc = vswap_iter(&cluster, entry.val);
 	ret = desc ? desc->memcgid : 0;
-	if (cluster)
-		spin_unlock(&cluster->lock);
+	vswap_iter_break(cluster);
 	rcu_read_unlock();
 	return ret;
 }
-- 
2.52.0


