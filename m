Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6571E606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sYHIz/YA
Received: by kanga.kvack.org (Postfix)
	id E7C4C6B05BB; Fri,  6 Nov 2026 02:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53A36B05BC; Fri,  6 Nov 2026 02:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF44C6B05C6; Fri,  6 Nov 2026 02:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 989886B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:24:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 181B540548
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:32 +0000 (UTC)
X-FDA: 85403856384.04.8583604
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4FABB40003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="sYHIz/YA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPKGTeKDiBLjJEUjuWcNmxgLTe9SMXKIDb5z53Wh2O8=;
	b=f7hN3IpwbB+JULsRmOqyqtqdNSdZSFYnC10ZgdXF1H14EWqlOw8/wlSKEmXbHfArGkK5Bn
	3YI4RNQs14gpMS4/v2Hr6s3rR+PUNx4uu7TN9jKUDKNHf2d+rAYgYMWxcuZnppesYR7m+V
	CVe+YfIkbUIjmGv7WCJB4/J2O6eAv5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949870;
	b=WRZttqv0ia6gE7+rKJ6R26CrMyWi+la0gMQjpaUBSkg0Hbvq80ML77uhqXctYBUPVzKzUs
	zN/F4ncu8UUeXu3vbQ6ywP1UxriktZMxFYyAEoaJCfh/ELaYQMGq3qWIUcrdKfa9EYNcwE
	t+RvuL0mcX3eF7N6NSZmZsR9tipV10E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="sYHIz/YA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1ae18eb9ad0so508085c88.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949869; x=1794554669; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zPKGTeKDiBLjJEUjuWcNmxgLTe9SMXKIDb5z53Wh2O8=;
        b=sYHIz/YA7q8BnDneS9sXKk8rML3aEmTav6faZhBn50VxKFPPrjZM+XMt1EEkRZa1WC
         8187UwgQk/bZABugew1Mxdp3PeQsGeSNsDsPagrp9mtw65klaJjIUoahKWYCuIEtZLaz
         hQ8I4DsblHvapdR8z5ISZ7AUy802yYrgGOZ5vcmmU2HN7szAdMfvLFE79XTaOFfQsfIu
         4tzqEi2K9gRBKW6iClTY6cx8g8FVdIcZwt4N8Viyn9TjtP8vyAm5/huW7uf7ACaWGzgU
         6h8mvGAdCZtt5sJA1xavglwDPYFXoDwZ1qh3vdFx9Mi9Impuf3jJ+1zPkktQ+0G/aTKI
         9r1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949869; x=1794554669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zPKGTeKDiBLjJEUjuWcNmxgLTe9SMXKIDb5z53Wh2O8=;
        b=gOnTdnNE4846lGNJPHh0f/P8nUSrHa6ClvX+zLWNVI9kZWnWE2XBZ+Ji5+7Wn6F0p3
         +F+zat+6f0awVIz2yWxsZNtp2us19Etn8j61D2gy6Asd4FBL2gFfO4JjrGazhIYD10sN
         CF400Kc42XH30W0JqdB+mY15DYncMKVPHkhAvsZzx4LvMmEagEks1qNNSLQ0+g/LEUdM
         UwElIWiG1y+7BXppwtn7MQVpf41yOci6C7Qx6DGvk/RAu+TU3qzKqZGYqtHxmtj6EYTk
         ufIcLshkhpS7kwnQ9nTRCbfiENTYvQlEiG7K9Iubqq3EOuUqPtUZC7CKqsHjbpfXU0bW
         yYiw==
X-Forwarded-Encrypted: i=1; AKwUvBzQp7CluPbOV4DAVXo6LzcMnF9/L8oLxQeW6SW6slkp8e2j+/oxi7K52uKIOZKFYHNwHUxHZEi/PQ==@kvack.org
X-Gm-Message-State: APuU4Z/QUynWwx319lFQnKy3mObiL2Lzilo1nRyAb93qt4v0Q+nmQeAC
	W0UIjN9vEAl8+H5BsbIAsEDw9ihPHfyjNLYfgxkl+n5Qi+A6e5DfalDf
X-Gm-Gg: AYBFou3ql8cknYh0PwaVLrLBaKIe7Ef4J0jTgYu8pHPkm+0o1YUjZK3a9inlSXsFrIn
	Eoc0Wgy5qQjpal4pXbdStAKSMZN6PjxZTs89qiC6tjZgLw5N6/3WRtdwa/AeewgLjkS29j+xvbJ
	CwbgPrzs3eOK8DXEzL75hho7c9j+LRUZqZUFI3nbGyADusvxrJW8PQA+kMhlHS170WdQx4Uh5c3
	tONnTKk6Co08GkM18Lz2/9Qw0UI8cWaH4euwr2kGUXIzw6OULXDqStdRgB2KLeJfGOMIoxKM0Ub
	vfKdqnuD/zz3M/seKQZLsVkMUb6T49I8/21PNk+I/rqc3wYATf7uSj+oFuZeD788nJZBHq+6Gxl
	jA5uD/02wXzPM3nzyFxTe/8rmn0hePnk3D55xUAI0Z5ng2sAM2J0k4kxNsRfjo3cMUkcPye61EZ
	FXvSY1/yQSIG2wHtLcdQD8KLSPAI1akjL24nuqQx/izhBkp7ek+U/4a7YYLVYscu4T0bm+S1sdG
	YttiJ6f1PeRGfpBWkpdCGMribX2+eXLciLmhuN/bm1eZECKh/F3mfGAGMVME1Xsw/MvxqnYjc+p
	2nd7ZAAntmEfOK+DV5lXUBU6m+ZzOhl5WCL+mfFRgx4ordAw3+XL6SuBLjZyCBI=
X-Received: by 2002:a05:7022:7f04:b0:1a9:cad6:5b58 with SMTP id a92af1059eb24-1b25d3650f3mr2241658c88.39.1793949868871;
        Thu, 05 Nov 2026 23:24:28 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:27 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v3 7/8] mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
Date: Thu,  5 Nov 2026 23:24:11 -0800
Message-Id: <20261106072412.7909-8-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r8p6mzm6rqdqr968j59xcfrm5rokbmax
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4FABB40003
X-HE-Tag: 1793949870-238780
X-HE-Meta: U2FsdGVkX1/t1qiWC0Rc0vShwoG4JRDA5vy9JRyqCNBTcpp5vTyw/VhYzSSl/wGPDTWuYBpJsCtuKGnBe/ly7hryjipHsLsDGv5NIfmIpTWjfIDdFfnvLL3ATYNgnc71soHBZZarJffPyp66o+HTkfKDkvOf7AmZr9YacCEU/wmKp9N+xoe3CvpLnJvLrRByn5d29XgNuescW9KEMyb7vcpG3TXbFGcXDOBhv/Ae/cPRDPi4TSzvT1V4+517oK3fwizyb1q8pPFzRUXvh8mfJSyfgJCKaK8cu92K+mLwy3Rh/UpF4ChENFbzdWbpeZ6B3Iabf0SSB9PgoogL5ijYYJQuXmFJlyvAFTZSVc5w6z3VGbpZ90I7hakuFIgJgcmG31yewh7VobLck1rBHw0bY4/EUvTbXekBM55/sSky1Vh0l0PrceWFxmZn5dlzzijauUFYIPzHW1OdkJFMF+/ypAudHuhmTZ48uJEKDzynYmlGyiEiikJbUgmFodqAq7e3RuhkmVXKoi6u8rzIK6dy/G3G7KgslQI5aPcPQ/2CmAz9t/CHVE0DgCobu+MNWx25UhozKwB6NA+2fINW6ux0eNBXDeglhMCLBrACQeudoLLnqvtERI7iRcgyP7/NagZbauNKJQEuGyyoop/7ClFVK9Zfqi1fux2V2zykDaR1ooiGr9qv/jip/VVf7EhOJI05cjwA1m5fGPd4s5EABSFKb3AIKB/e+yvvCrg0Y57Mi+nn0qtSGzkto7IOQkBd9s2rrW1tOFnJpxgwVkoR955rUW1TUjRSuv8kh35OcT+KWdeaNApee/ckCSp49Zxw52JYVUqdLGipDFPS5s4Z+n/JqryorzjOkxBTIzyW6Qgjs3Vq7iFdIMk9vzzCEO8krLAXAesxTeUysw3SlEcfrz5bSi1untxQapZwIGRByzMZ9YSv2ETdEUau7QNWHKFU0rwOuFcD4dHNuVIgaT4zgUD
 k8+u6Ndp
 pSbYHAwbLczEN5H1ReHna5fMQMEdQdaxh2NZHCDa8kMmBZO7pgn6Gs3aAHSdfyMncugHDn+tOohB1pSjkEuu6a/1u5d+r+diQo0Nk+JZvt8jrRGiBhJwIwX0PTuosnCq0PjLTxQ40ExYwkGAds0Lxzjm0AVld3KuqVq1bpyo07EOzs97qVDZvmOhJ/LMrhaNyhF/svBicrjLPZgF5v3VuTVERo36gO69OTNpMatGLC/aWFz4zFxlemwugYX1Z38M/q4xS4cOh4KqR01elxOcXl86tW39rLVE1czwBHhLObOtoydac0PdKkrdpoA4e+vV7G/dNYnpKNrfGF7hGXDp/j8sZOXMrGpVyiI3NxviFyr2klmdSDoTPOsZyxxF11tuLYVll2DR4jegJtSiUxNLzRGl/GoIZMYFxOiZ+rI7FK8WMEOM3wn9SJ51p7/1B0y6A5IU/nfC8NceoAjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The various stages of zswap_store_pages() are broken down into routines
that work on a batch of data when a large folio is being processed:

 zswap_init_entries()
 zswap_tree_stores()

The struct zswap_store_context is used to pass constraints and data
among these batching components. The resulting code is highly simplified
and maintainable, where each of the batching sub-routines of
zswap_store() can be optimized modularly.

For instance, the zswap_tree_stores() now does the zswap atomics
counter increments, getting pool references, getting objcg references
and objcg zswap charging at the batch level. A new
obj_cgroup_charge_zswap_many() is added to enable batch charging of
compressed bytes for multiple pages/incompressible pages in the batch,
in order to accurately update the MEMCG_ZSWAP* counters.

The next commit will implement batching of zswap_compress().

Subsequent patch series will be submitted, that implement ideas building
upon this batching framework:

 1) Replacing zsmalloc with SLUB allocator, comprising of kmem_caches
    for a finite # of compressed size bins. This enables bulk allocation
    of compressed buffers in a batch that belong to the same size
    bin. It gets rid of significant zsmalloc latency overhead (locks,
    compressed data spanning zspages, etc.), without compromising memory
    efficiency.

 2) vmscan reclaim batching of hybrid any-order folios, that will submit
    a batch of folios to zswap_store()'s batching framework to optimize
    storing of batches of pages from different folios, in addition to
    within large folios.

Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/linux/memcontrol.h |   7 ++
 mm/memcontrol.c            |  36 ++++++++
 mm/zswap.c                 | 182 ++++++++++++++++++++++++-------------
 3 files changed, 164 insertions(+), 61 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..7532dd9f2211 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1946,6 +1946,8 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
+void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
+				  u8 nr_pages, u8 nr_incomp_pages);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
@@ -1957,6 +1959,11 @@ static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
 					   size_t size)
 {
 }
+static inline void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg,
+						size_t size, u8 nr_pages,
+						u8 nr_incomp_pages)
+{
+}
 static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
 					     size_t size)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..eddf6dbe6342 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6345,6 +6345,42 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_unlock();
 }
 
+/**
+ * obj_cgroup_charge_zswap_many - bulk charge compression backend memory
+ *                                from compressing a batch of pages.
+ * @objcg: the object cgroup
+ * @size: total compressed length of a batch of compressed objects
+ * @nr_pages: # of pages that were compressed to store in zswap
+ * @nr_incomp_pages: # of incompressible pages to store in zswap
+ *
+ * This forces the charge after obj_cgroup_may_zswap() allowed
+ * compression and storage in zswap for this cgroup to go ahead.
+ */
+void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
+				  u8 nr_pages, u8 nr_incomp_pages)
+{
+	struct mem_cgroup *memcg;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	if (obj_cgroup_is_root(objcg))
+		return;
+
+	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
+
+	/* PF_MEMALLOC context, charging must succeed */
+	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
+		VM_WARN_ON_ONCE(1);
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
+	mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
+	mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pages);
+	rcu_read_unlock();
+}
+
 /**
  * obj_cgroup_uncharge_zswap - uncharge compression backend memory
  * @objcg: the object cgroup
diff --git a/mm/zswap.c b/mm/zswap.c
index 00cc4586b284..c2d17ccb53a1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -490,12 +490,12 @@ static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
 }
 
 /* The caller must already have a reference. */
-static void zswap_pool_get(struct zswap_pool *pool)
+static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
 {
-	percpu_ref_get(&pool->ref);
+	percpu_ref_get_many(&pool->ref, nr);
 }
 
-static void zswap_pool_put(struct zswap_pool *pool)
+static inline void zswap_pool_put(struct zswap_pool *pool)
 {
 	percpu_ref_put(&pool->ref);
 }
@@ -1570,56 +1570,61 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
+/* Functions called by zswap_store(), that operate on batches of pages. */
+
 /*
- * Store multiple pages in @zc->folio, starting from the page at index @start up
- * to the page at index @end-1.
+ * zswap_init_entries() co-locates most of the zswap entry fields' setup under
+ * the assumption that all phases of store processing will succeed. An important
+ * marker to simplify catch-all cleanup in zswap_store_pages() is done by
+ * initializing each entry's @handle to ERR_PTR(-EINVAL).
  */
-static bool zswap_store_pages(struct zswap_store_context *zc,
-			      long start,
-			      long end,
-			      struct zswap_pool *pool,
-			      struct obj_cgroup *objcg)
+static inline void zswap_init_entries(struct zswap_store_context *zc,
+				      struct zswap_pool *pool,
+				      struct obj_cgroup *objcg)
 {
-	u8 i, store_fail_idx = 0;
-	bool ret;
-
-	zc->nr_pages = end - start;
-	zc->folio_start = start;
-
-	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
-
-	ret = zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
-	if (unlikely(!ret))
-		return false;
+	struct zswap_entry *entry;
+	u8 i;
 
 	/*
 	 * We co-locate entry initialization as much as possible here to
 	 * minimize potential cache misses.
 	 */
 	for (i = 0; i < zc->nr_pages; ++i) {
-		zc->entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		entry = zc->entries[i];
+		entry->handle = (unsigned long)ERR_PTR(-EINVAL);
 		/*
-		 * Set pool_idx before the xa_store() below publishes the entry, or a
-		 * concurrent reader could resolve a stale pool_idx left by slab reuse
-		 * to an unrelated live pool.
+		 * Set pool_idx before the xa_store() in zswap_tree_stores()
+		 * publishes the entry, or a concurrent reader could resolve a
+		 * stale pool_idx left by slab reuse to an unrelated live pool.
 		 */
-		zc->entries[i]->pool_idx = pool->idx;
-		zc->entries[i]->swpentry = folio_swap_entry(zc->folio,
+		entry->pool_idx = pool->idx;
+		entry->swpentry = folio_swap_entry(zc->folio,
 							zc->folio_start + i);
-		zc->entries[i]->objcg = objcg;
-		zc->entries[i]->referenced = true;
-		zc->entries[i]->nid = zc->nid;
-		INIT_LIST_HEAD(&zc->entries[i]->lru);
+		entry->objcg = objcg;
+		entry->referenced = true;
+		entry->nid = zc->nid;
+		INIT_LIST_HEAD(&entry->lru);
 	}
+}
 
-	for (i = 0; i < zc->nr_pages; ++i) {
-		if (!zswap_compress(zc->folio, zc->folio_start + i,
-				    zc->entries[i], pool, zc->wb_enabled))
-			goto store_pages_failed;
-	}
+/*
+ * zswap_tree_stores() stores the batch entries in xarray and adds them to the
+ * zswap LRU list. If an error occurs during xa_store(), localized state
+ * unwinding is done to erase prior batch entries from the xarray and delete
+ * them from the zswap LRU list. Remaining batch cleanup occurs in
+ * zswap_store_pages(). As batch entries are processed, we maintain aggregate
+ * statistics to do the accounting in one bulk operation.
+ */
+static bool zswap_tree_stores(struct zswap_store_context *zc,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
+{
+	u8 i, store_fail_idx = 0, nr_incomp = 0;
+	size_t total_batch_comp_length = 0;
+	struct zswap_entry *old, *entry;
 
 	for (i = 0; i < zc->nr_pages; ++i) {
-		struct zswap_entry *old, *entry = zc->entries[i];
+		entry = zc->entries[i];
 
 		old = xa_store(swap_zswap_tree(entry->swpentry),
 			       swp_offset(entry->swpentry),
@@ -1631,13 +1636,11 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			zswap_reject_alloc_fail++;
 			/*
 			 * Entries up to this point have been stored in the
-			 * xarray. zswap_store() will erase them from the xarray
-			 * and call zswap_entry_free(). Local cleanup in
-			 * 'store_pages_failed' only needs to happen for
-			 * entries from [@i to @nr_pages).
+			 * xarray. Local cleanup in 'tree_store_failed' needs to
+			 * erase entries up until now.
 			 */
 			store_fail_idx = i;
-			goto store_pages_failed;
+			goto tree_store_failed;
 		}
 
 		/*
@@ -1648,22 +1651,10 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		if (unlikely(old))
 			zswap_entry_free(old);
 
-		/*
-		 * The entry is successfully compressed and stored in the tree,
-		 * and further failures will be cleaned up in zswap_store().
-		 * Grab refs to the pool and objcg, charge zswap memory, and
-		 * increment zswap_stored_pages. The opposite actions will be
-		 * performed by zswap_entry_free() when the entry is removed
-		 * from the tree.
-		 */
-		zswap_pool_get(pool);
-		if (objcg) {
-			obj_cgroup_get(objcg);
-			obj_cgroup_charge_zswap(objcg, entry->length);
-		}
-		atomic_long_inc(&zswap_stored_pages);
+		total_batch_comp_length += entry->length;
+
 		if (unlikely(entry->length == PAGE_SIZE))
-			atomic_long_inc(&zswap_stored_incompressible_pages);
+			++nr_incomp;
 
 		/*
 		 * We finish by adding the entry to the LRU while it's already
@@ -1679,17 +1670,86 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			zswap_lru_add(entry);
 	}
 
+	/*
+	 * Each batch entry is successfully compressed and stored in the tree,
+	 * and further failures will be cleaned up in zswap_store().
+	 * Next, we do bulk accounting for the batch: grab refs to the pool and
+	 * objcg, charge zswap memory, increment zswap_stored_pages and
+	 * zswap_stored_incompressible_pages. The opposite actions will be
+	 * performed by zswap_entry_free() when the entry is removed from the
+	 * tree.
+	 */
+	zswap_pool_get_many(pool, zc->nr_pages);
+	if (objcg) {
+		obj_cgroup_get_many(objcg, zc->nr_pages);
+		obj_cgroup_charge_zswap_many(objcg, total_batch_comp_length,
+					     zc->nr_pages, nr_incomp);
+	}
+	atomic_long_add(zc->nr_pages, &zswap_stored_pages);
+	atomic_long_add(nr_incomp, &zswap_stored_incompressible_pages);
+
+	return true;
+
+tree_store_failed:
+	for (i = 0; i < store_fail_idx; ++i) {
+		xa_erase(swap_zswap_tree(zc->entries[i]->swpentry),
+			 swp_offset(zc->entries[i]->swpentry));
+		zswap_lru_del(zc->entries[i]);
+	}
+
+	return false;
+}
+
+/*
+ * Store multiple pages in @zc->folio, starting from the page at index @start up
+ * to the page at index @end-1, i.e. @zc->nr_pages. Each phase of
+ * zswap_store_pages() does batch processing of @zc->nr_pages in the folio.
+ * State unwinding is kept to a minimum as a result of the batch processing: a
+ * batch proceeds to the next phase of store processing only if it passes this
+ * stage. The batch cleanup is consolidated under the @store_pages_failed
+ * label. Errors in storing a batch result in folio level cleanup occurring in
+ * zswap_store().
+ */
+static bool zswap_store_pages(struct zswap_store_context *zc,
+			      long start,
+			      long end,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
+{
+	bool ret;
+	u8 i;
+
+	zc->nr_pages = end - start;
+	zc->folio_start = start;
+
+	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
+
+	ret = zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
+	if (unlikely(!ret))
+		return false;
+
+	zswap_init_entries(zc, pool, objcg);
+
+	for (i = 0; i < zc->nr_pages; ++i) {
+		if (!zswap_compress(zc->folio, zc->folio_start + i,
+				    zc->entries[i], pool, zc->wb_enabled))
+			goto store_pages_failed;
+	}
+
+	ret = zswap_tree_stores(zc, pool, objcg);
+
+	if (unlikely(!ret))
+		goto store_pages_failed;
+
 	return true;
 
 store_pages_failed:
-	for (i = store_fail_idx; i < zc->nr_pages; ++i) {
+	for (i = 0; i < zc->nr_pages; ++i) {
 		if (!IS_ERR_VALUE(zc->entries[i]->handle))
 			zs_free(pool->zs_pool, zc->entries[i]->handle);
 	}
 
-	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
-				       zc->nr_pages - store_fail_idx);
-
+	zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
 	return false;
 }
 
-- 
2.39.5


