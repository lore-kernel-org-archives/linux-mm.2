Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A57E606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x6OIY6ZP
Received: by kanga.kvack.org (Postfix)
	id F18B56B05BA; Fri,  6 Nov 2026 02:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2386B05BC; Fri,  6 Nov 2026 02:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1B496B05BA; Fri,  6 Nov 2026 02:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7DF6B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:24:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0930B40D31
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:30 +0000 (UTC)
X-FDA: 85403856300.15.E6962BC
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3455080005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=x6OIY6ZP;
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949868;
	b=eETpl5ghcQR0epnvyySAps252FIlIT/wHegXPcskPMUujOUgkM4c2RGaH8uaE1E8s4Glbt
	LPuPsSU0ywN6WebEJTmsdfUXE/vkUQ69LW62jGcowB8QG7g4B9On6qYso6hrJtSYyLhVUY
	PUPsUXzAIFuY+dQPmCazpFLptLlWoKQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=x6OIY6ZP;
	spf=pass (imf02.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+SsT0VqRyTfN8lC353rIijD7LbE4Wu8DXCcMg5rqu4=;
	b=PM4G9J7X/YgUOZ4K6loHWJoVvzb0xQ9fMh7MHL1RsDu1U7tLCQKbT6JUBrB/Sd5rMaxL3l
	1aXQmJhBPq+/viXFWNrvCsuWeCX2eEiFDs8t0BPqrOaNBxz54AKnt8mC3GIUmjvfcaTlA8
	za9uxGRNbXVCQHXaHCcsEDxXx/8e+8I=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1ae18eb9ad0so508058c88.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949867; x=1794554667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M+SsT0VqRyTfN8lC353rIijD7LbE4Wu8DXCcMg5rqu4=;
        b=x6OIY6ZP9DlvpMhkx90YeBInhyqvY8Qww5iFGqOeGlwPvge8RRj/PTfDWzn9ruMHBn
         BYP/0ALc17Q49/TwAeGGmf0K88r8yQLDdtm/6lyYFmURJyDr5xHoPaH2BachotXJd7tO
         Z71WbJAKxVVY7+v1kHYrnt4mUFtu+KzwArJqTTse9eGe2TmIiN+8NuVhtdQab/fvpG8n
         U8LUvC3LA1hEgIJb/ZrifwM9EAabbowwyuKDHoPG/VfHQz54OJC/3jqrKsh9oWFJbDf8
         Nyyazl8OmQqOY8codZn+Ojjr8aSPTFTug6BI8KxammQUnjlqNkQBoKSukd83r2/gpHql
         jZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949867; x=1794554667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M+SsT0VqRyTfN8lC353rIijD7LbE4Wu8DXCcMg5rqu4=;
        b=rpN8c9rdSWZ7hlbqA+IeJ2WXRh01kiGcuoHk50jhBUxm/BQM5rxfreRrPsGRQrHbmo
         iFOV7a7yVKAk+vpvvNiOsyGfMeB+3bRywOs/OhJwlfA1O2pUUJ2eqc+FZNG6bMgaPM8L
         L+ECIRSUcNT/qepv2WVVALWAgdOPS1rHzf9C3Gj4sr1pcKbeYtGGh1BEvVRHJ8yVvLkV
         K1JBXQShMvb2WXvsxZmdTMcr1SurWr3XRR2J6yqhfFVcusU1tE55MdsgduloE4Wo+yLT
         Uc7XHHTPCvozmnQAhMSXkInOLSYzrMJQKZ0RtgQDkJZqTjZQCeOxqTl3XM7wCe+ch8S7
         wylg==
X-Forwarded-Encrypted: i=1; AKwUvByykHE7BLXdz4NExeubdEMIL6LQuNMC6ya7bIqSj7tVowvutk+63gwtvQt3Gexc9XgGplH2+z51iA==@kvack.org
X-Gm-Message-State: APuU4Z+5q/GZRrW5oTGxqzfc18o1se0BNA1ByJ0oUaRRj/a/DVQisRwu
	dxiymjIj12ShVvykodF6/q+kMV7kElEblPO6dmvv+43CDYntlGhMrYvM
X-Gm-Gg: AYBFou1N7T0FpxcqfVYGCW1LbLzqt5JuwvrbvSZ7QeiPRV+v7GuvuEM3y0IyFVKy96E
	LfDttGM7/axdlcfdMsCeZ2hLCWjcHpiYNEpMJGWYsO0TTIws9saO1PFoRzwciLZQW2eJ1jBNTtE
	jzJWJ/gFwWp2Ed89T3Ri72fKbJbVz/eiNSY6Y7OhgGsedRt3cx0ce/1az24+z+3eQ+36Gbhg8Yv
	1ueFQVWPmklaUbZtbAUTgEVrme3zdUuPHCRXQsP4NXwJQJCXRiprSAdjNvKiMUj1PdmfBR1/o8S
	M9uOTLQ5rfDz4wvY4ZvETwW3YaadDGR49RR9sSQZz+LYZtOYsYqys6d85hpxAv1wRDO2Ra5AuTM
	J9arSFpIESzrKbNkB8fqsghWrxVvLyY6Gx8TQ/CA3skYvGmL1cNGzjWNx2Dhm95YDp0Jio8WKyZ
	vIL1LyYlKXvlrLc048Lc+oalH78gujNEMngbiMyWmZ9VYlXUN4vDI+EOQo8GV0rjn8jDc+bg/NN
	ke/k46Udggw8YErJIE3UbpB6MFluXyJMe5QWksT8mJ3pHDkIby8vzwU+SOKXU/IFYoWvbsSQRe5
	IQD/h+MBH45u5p7gUxOwPKL6M24MvlWVmynKhfmYrg==
X-Received: by 2002:a05:701b:21db:b0:181:5cac:8f27 with SMTP id a92af1059eb24-1b25d34ab7bmr1913466c88.35.1793949865384;
        Thu, 05 Nov 2026 23:24:25 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:24 -0800 (PST)
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
Subject: [PATCH v3 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
Date: Thu,  5 Nov 2026 23:24:09 -0800
Message-Id: <20261106072412.7909-6-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gbcfuojjkeqdcyd6nh9x9zcs6cy63cxf
X-Rspamd-Queue-Id: 3455080005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793949868-206571
X-HE-Meta: U2FsdGVkX1/+5nXKdhqgHfjO//nZlsK2snmDJdkSRNHFW7m96goeeG9znBz0fRRqX4J/7hMTIlQdspf4acTFh2IxDW9hc6dTAPVYluFQt/QQZaA6JYmL/Y/uI0cIckNitiQM0T/mhsT4tyfL05WY0Y4J7FEBXOh8iUgWtrNARVZ+FvM+iY67CZ2q5PLp0Zf0SjoqKw3xDR0mKkpLDYZkkxwoaZNaJlkCaf0PKbW1RiU1EvSr1BL8hl247Pk90++/kvfDJhnbAzRvwKor3cJ0R4JR+kJN/50yErWPoPDs66yIP2lDQJuT8u1W+72Z0w2/OnE1h1ClxBHQItLZXgTE0xYUt9UsnVFttR8ahaWTci5g06I3dWNXbKMFJwm4F4UENJs5w6mV8H99OnRyxJEHdnOLktkozKcK8TuBxhq1VCIyVB6vSVkGFjlyHHez41JaWJM4y9n7ExY7Si2dcl1TvH27fzjL7n6b2lpCm2HZ2OPgfmDWyCKPaYmWxpRb8S817zoQBdIe3QfBpgWdZ+rHDizPX0YehY63cp64ApjLyAeeVtJ1EvHF0DfU1jl8E/n+QuIxul+VKdWPrPvme4hRLv2N/Ccc2z1XBD6GlIymefoPpFTtMJahkZF4Jbx+oUpIL2ROu5FfkoWeWT8ick97VKQTzYOPsTaMgxONa7i9+K4oAwm6xL/tfBOhkvOqZK2MGnGke4aY5jcJYDTxTkjcGlKFVPnx0BZE/hHSHopsYkhLSXg2TWUX90hpZzHrgDRp/12+tD2+CVqI80Z8sjEL/mbdP+6CPC9ghxPDVQXNA9pDRpiGXB/uSIyOT9ZSNWcU4K0Ws7hMIN8lMnUB/VgkODTSVLWuhNi0mAFSh/VRKkrGz40bF/VhePvqsQO+h6bGLRbCfz33EkkZLYPfX3iWX9w0I4YHpIZQl6YFEjqxEOnl2hh9LQVEz0DFcx2IhliW6mDCZp8I0Vt/yA0IBsL
 ioF51SZE
 RIuf8u1AeqF4NN1JFREsGt36YFgQVOfdZK0oMLWouwFXj4Yd04/Qx9x9bDwLnC1cjRuzBSToGv6WPc//4ockiYnZCMslyw04nNWrwB2eZ+BXaGkpH2mxChGhYwiaxyirPwUFe5rba5tuRSGA7PVzX5ED5P7/1FQOyxMEj7JaZF2ejcb65RUBCfGCwwvwoO1BCfB/pCM0Ndd20Empqxqso0Cv8/UJtHmFeJhaoNPmXfu81QfI8/8AjGAk4qPEGaApXQ1eaic8IWHnfZ1APIwXWwID4iT+AlRU2WLaRIQSTBzatlWLzEShfcLL6V0c96Ia/ofTCA9U4ocnbwOrnWNKIBjXdIWnvE4bgwjEs9/vcsuJWA0pIZEZFeEyBTsRWwKZI3CF2F+2w3FAOmbG0ElYSZacRV6IDPTncA3w5e4X4pr1mTteMJLjk/5vYrWbV7/1RO3NA9h6DZeTG3kzUdkilAQJt5LeRqT1FLLkl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When storing a folio in zswap, save the folio's node id in the zswap
entry instead of relying on the zswap_entry being allocated on the same
node. This enables optimizations such as batch allocation of zswap
entries for large folios using kmem_cache_alloc_bulk() that does not
support specifying a node id.

Accordingly, replace the SLUB allocation in zswap_entry_cache_alloc() to
be node-agnostic.

The size of the zswap_entry remains unchanged as 'referenced' is lumped
in with the 'length' (as it doesn't need a full unsigned int anyway).
A build time assertion checks for the zswap_entry's 'length' bitfield
being large enough to represent PAGE_SIZE, which can be 256KB on some
architectures.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e1d57a7d9595..8cc9e0fde456 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -180,6 +180,7 @@ struct zswap_pool {
  */
 #define ZSWAP_FIRST_POOL_ID 1
 #define ZSWAP_MAX_POOL_ID U8_MAX
+#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 19U
 static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
 static struct zswap_pool __rcu *zswap_current_pool;
 
@@ -206,15 +207,19 @@ static struct shrinker *zswap_shrinker;
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
  * pool_idx - id of the zswap_pool that the entry's data is in.
+ * nid - NUMA node id of the page for which this is the zswap entry.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
  */
 struct zswap_entry {
 	swp_entry_t swpentry;
-	unsigned int length;
-	bool referenced;
-	u8 pool_idx;
+	struct {
+		unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
+		bool referenced:1U;
+		u8 pool_idx;
+	};
+	int nid;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
@@ -679,14 +684,8 @@ static int zswap_enabled_param_set(const char *val,
 * lru functions
 **********************************/
 
-static inline int entry_to_nid(struct zswap_entry *entry)
-{
-	return page_to_nid(virt_to_page(entry));
-}
-
 static void zswap_lru_add(struct zswap_entry *entry)
 {
-	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
 
 	/*
@@ -703,19 +702,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
-	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
+	list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
 	rcu_read_unlock();
 }
 
 static void zswap_lru_del(struct zswap_entry *entry)
 {
-	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
-	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
+	list_lru_del(&zswap_list_lru, &entry->lru, entry->nid, memcg);
 	rcu_read_unlock();
 }
 
@@ -763,10 +761,11 @@ void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
 **********************************/
 static struct kmem_cache *zswap_entry_cache;
 
-static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
+static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp)
 {
 	struct zswap_entry *entry;
-	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
+
+	entry = kmem_cache_alloc(zswap_entry_cache, gfp);
 	if (!entry)
 		return NULL;
 	return entry;
@@ -1507,9 +1506,10 @@ static bool zswap_store_page(struct folio *folio, long index,
 {
 	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
+	int nid = folio_nid(folio);
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
+	entry = zswap_entry_cache_alloc(GFP_KERNEL);
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		return false;
@@ -1524,6 +1524,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	 * to an unrelated live pool.
 	 */
 	entry->pool_idx = pool->idx;
+	entry->nid = nid;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
@@ -1897,6 +1898,8 @@ static int zswap_setup(void)
 	struct zswap_pool *pool;
 	int ret;
 
+	BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <= PAGE_SHIFT);
+
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
-- 
2.39.5


