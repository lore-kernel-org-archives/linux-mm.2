Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4141E606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZUzGGPYy
Received: by kanga.kvack.org (Postfix)
	id 94FC76B0751; Thu, 19 Nov 2026 23:19:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901806B0752; Thu, 19 Nov 2026 23:19:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0026B0753; Thu, 19 Nov 2026 23:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3056B0751
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:19:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B27B140CE5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:27 +0000 (UTC)
X-FDA: 85454193174.30.052F6E0
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id AF1EC100005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZUzGGPYy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795148365;
	b=b9OVkpAycMOLKqz+yDyYGEKjoM38194j91mDu/IqVXPgFzpT+Z2ftxyWWDXnF2AsgaEeBe
	d9G3vuKDvm8Rc62QfFMdcQu/ON9Gr+SRVkh2wRQ2PWQhTnWraacPFtIrOQmcb0KaTZLrUw
	9p6ux1AM9bJ33vSMc/GqZ6kqx7hBhXs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tw2IAI5wSBNupIKIxL5Ig7aobgIjCUpdJvEt5vs8Kl4=;
	b=SyFTQfWhnR+1MnW908+5LsldMbW/7IrnI/50r2XyI0Ww+m9rVQtp0gKS3zhjh8D4MOlPXk
	lhv3A6bsSqUOCteKU3ZXQzaNWfhEB2jrQStVftTttk5Jgs6MCYxbM3LYvcdXTvfJ73HHTI
	PTG7JB15CviWDFuDDpiM9yjcxGSl89k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZUzGGPYy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1b244fb7fffso477319c88.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148364; x=1795753164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tw2IAI5wSBNupIKIxL5Ig7aobgIjCUpdJvEt5vs8Kl4=;
        b=ZUzGGPYyxrVdVAi3hx0LQkXZVswZ9SD7VTuZUmnwl1+DHC2n61Qt/uwF/vFO0Y9ht8
         HeQLTXCAlLhPPOLZOqffvjkDLHnz93EU3PaCfxvKGyAbjUzIQMzCHRf1XFyjsgiOdxYF
         xn7YtdUSwziwTAqvXUwchZZ/GUPf/76sHIQebvSIpIJ+5zmi74Jn0ms8jWvCKV76xOE4
         f/MyvDCvfWIoADzHQFZKA+S3XnjJ9BXBM0sYzOXRIO+Z0UaiWkhBle2yjtwysvah3O8K
         QrgyB4Zd3XVayHTRFTXU7Ecxp4V9FoWI/7ohF3vjLeF3nefXTd1WXhCVDcwpB8tHYYv4
         l05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148364; x=1795753164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tw2IAI5wSBNupIKIxL5Ig7aobgIjCUpdJvEt5vs8Kl4=;
        b=TySIue8VNiuu/naF3yl3gcnszfC3CtqCTsKnYEHQrD8Q4yF2o89i9GarGcBNUKCZW1
         nj2PnXXJ/7axlhWSPOE9rhD5ZnLxlbmZukGeT16MKtiu00VF0r2+vFk0sPridFUnGwCC
         y6hRe0q4kJv3wwmSXlUXleHY/hT/ISAuAd6YDkXSO3Lyr1+iWEFWLeBLD0hH5DZfZ0XT
         egOfxVM2L9fPsfj9Hl9GuGt8i0lGUDB5Q7A8giTtPWLR7O7hPLmtCce/moOa9k46vrpg
         7e4c7UgnHiENKe4kdPNewj2ZcFtsD7CNCHsDBVS7M0yi+60pDyvOJxFWn3ZXPeYKd/Fn
         ZMQQ==
X-Forwarded-Encrypted: i=1; AL+hErHZ5Kpe2YlyDtBUUaUJ6zauH86mawInJEiu4J5UZjVEIK5nMbDIZBBbk2VqT5nreAz69ttUzJb/vA==@kvack.org
X-Gm-Message-State: APuU4Z+4LhdGqmQCYoTx7rJMQXYnCrAVVFUh2fu6pkbWYIi1XikWfe9j
	ZzHlo73aHHrzImVi+VhSfVaj0Lr+kSmrbgVcaPtF8Ig1aYvZFqUJQFFG
X-Gm-Gg: AYBFou28FpFCmnmtDzn2UTP+UDPmV0hAhubVECNCQNtGgtCaJbWAuc7xF+ZrtS+/6ll
	Iu7JQ+6nHNAiZ3QMsO1iAJA/zLvWohwDC/DqKNyJa58mNBmPQWSPYvWvMuplnQfiEozuMlSaAtO
	4hRgq7VORiPQ0PRfvHpIQxSpqPtAppnIF8m4cLid4ZizKihMgZ95EL3bsM6jirUz4+vA+4XlUVc
	I7j9BMietAC9CFtaMfvldlFJhyIQAXOF+Fwh/oy+aX00qkIDl0GwLnlZea2NS71gd2TaYWXgrIU
	WQI7njinmn9/tPwYjvI19xtj5/8cP0ROPafw/BQMU1i+1Q6gyBEOBcDQrxnN+zVZuu6jEOFyRus
	6sBVlHgJa9X3ofiqqNuZHiSRdmNIw5hQ+JERZh6FxVTgCihipTVcID3i86UiTnGsvGs5A8xE1AZ
	uGZcCtTEIf2un3wJdtby7ERnJPY1QSlzj+m4Lswqf6ruWd7fVmNnlDsqvsJT8qf6a0uk3HTt3Ti
	Na2uj+B7WBoDPgCMhy0BTYoZ8bxVOqLnSAFa/OCIC2H51fEBNAtlnmSRFjPbLDNOdeALboOJat/
	Jhfc/Somb0DIfmNfEXtx/iVUScKqKpW4lP0zv4SRRg==
X-Received: by 2002:a05:7022:170c:b0:1ae:59d6:91cd with SMTP id a92af1059eb24-1b5568f522fmr1440476c88.38.1795148364438;
        Thu, 19 Nov 2026 20:19:24 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:23 -0800 (PST)
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
Subject: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
Date: Thu, 19 Nov 2026 20:19:03 -0800
Message-Id: <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF1EC100005
X-Stat-Signature: 3z7zt8fxkf1rrecthztiygc7xpzhzbgf
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795148365-367388
X-HE-Meta: U2FsdGVkX1/DS3hfgqjEu0NYJcbej2y3qhCGoYpUrGQUT+TUJn8DV5J7ZhosxVfJjcHTmiNzNmwIyAuaZTVEzVupMZiEGgdaLBvfSoxyPL/JlfPrYk/pulSjSIay9ViFRK+Y06H09Ansa8W4962Nn4xEU+BsQ/gwJOhHkLxnCEEzYE4g3gpcVHM63lckVlm/94BhsvJWREUIWCC4MKzcg8J52d6WF+QILbY3aHs+lDj5rFJWik1irzcqBSVhmneBVwghjcrJxrG8URghxlwlJA+L7GlmEXAxm6Dl4jNqLdGDfRYX/AFgFijp5Ui8qkBQb4oUghofgf7soiuIu9uhkXDTAbGPnnH5aWWJnG47NHB9WLhnKmVsGYcPUQ9NVBMian5/Fuf8CI2rAZmGFq2P7HwsPi1An4rKQ7zUhfBTGvHCJXiziglpoc7i/CTXkp3TXevqlJ5lYNHWPVXc4hPcIBsNl7QWLQvVTQA4bevorGqQdyEdekdHl4MykTh1l/wDzJLLoX2Fvblrt8YA9hxLI3Yz/76Fg0dDfEwEtOlRZrefbliHEbGtRFAMnmjQRN7bfKZ7mRSTxQiu+tZdyB0ZKOoj6UISFKJvS0iXS4OA+86OO2PHCUOiisX5EryeAKc1NNWgvEaWBOUYIzwCb+lzdxGKleWF3vagpOwAEQ7TRnIRs0f20rE83Zhak6MaD6wGppEzi9rS3tcZk+9sEWSYYKls1rlMTkdiZIPVtk/tnZnwV4sKOJbaRNsAkqrxmqErrc21yyq43soZhBDRvGA1zHGqv4+1FLbZ+NZG4qLRUjGvNX+4ye7xRnvdA3tIaqXTLwUnkdztcJuerCiJeSPUbjLK50KoglEk3hhN0TenmENIF3slfYWzM2SaktfXiVzTyiwXMQHVXGJIBHQM0rZTvO6TozZDOdBTbf91K9IzmbaV0jaxG0Jy+noLeJoqgbe+xc4b/U4coWU1rjVjP5a
 0M51ckDA
 UGfxM2fJBQmorR2LzvkvPNhfJ2z64rcJruT19MYbKV0z1c/48QeDnvTwlS28plD+52w26kRidszMz/srGnlHkl2miYr6Kc/Q5oh73a+9BSnIbnsmtgFrK+7AlQtKt3lvd3RlCT7sK8kqcEnkaObLcFQ7MvWIJ8GU7eAUrsNGt9PcWAO9vaJiZXp71S4QqGkZJsYAza/Xud/q2PSQL7F8sr8JzmHJKzhXimPxIOQ8oQWwb50IUGnzPA6/Sf3ggYhkquYWY/LNiA/jzCum8TQoOXbMl+xrzXZcE9H8W7pK0lpRU+ITuiRFL8+bgBeumHnAkOC0WNMXnmTo6ortAq5pGHUXkyf15uJGPCuf2Qbd9j/6ChIlPGNIlfWRC6YK7DSUDShOFza92RWs9k7HXJP9koWIfiSt/XmulQTp0FE/iGW8WhF0PKlWvMKv4KJPk/hFPpKoo9Pbpdfg1+p4QirrpW4WfVsHEOF6ybWrwOx4HJLpIbfKJ2pdZhaFOrKhW4a7Z3xyJJAolvvvdeWW6YxgshSl3uWfsOahT+R51dZRbi7ZIlAUpOcqBLrqMAzl8Wu+ZsYxWpNqhytctx3T6iY4ek48CS/nggy1xYIvcBkIxW+I+FCwhkoikajyElEqeIzuAYHbV7bwLLMCCGsguNpRpOljnZKh0Bcp5syGt5qjoQ2pFaKqDKTLtjn8bjPK/OhUmqQVCPsBXsKwLaKU=
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
index 9a323862bd59..78d9694f75b5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -181,6 +181,7 @@ struct zswap_pool {
  */
 #define ZSWAP_FIRST_POOL_ID 1
 #define ZSWAP_MAX_POOL_ID U8_MAX
+#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 19U
 static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
 static struct zswap_pool __rcu *zswap_current_pool;
 
@@ -207,15 +208,19 @@ static struct shrinker *zswap_shrinker;
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
 	struct zs_handle handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
@@ -680,14 +685,8 @@ static int zswap_enabled_param_set(const char *val,
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
@@ -704,19 +703,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
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
 
@@ -764,10 +762,11 @@ void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
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
 	zs_handle_init(&entry->handle);
@@ -1537,9 +1536,10 @@ static bool zswap_store_page(struct folio *folio, long index,
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
@@ -1554,6 +1554,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	 * to an unrelated live pool.
 	 */
 	entry->pool_idx = pool->idx;
+	entry->nid = nid;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
@@ -1930,6 +1931,8 @@ static int zswap_setup(void)
 	struct zswap_pool *pool;
 	int ret;
 
+	BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <= PAGE_SHIFT);
+
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
-- 
2.39.5


