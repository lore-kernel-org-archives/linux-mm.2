Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DA6606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zJz07YcW
Received: by kanga.kvack.org (Postfix)
	id DA3386B0967; Tue, 27 Oct 2026 23:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B9D6B0969; Tue, 27 Oct 2026 23:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDFF6B096A; Tue, 27 Oct 2026 23:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93BB56B0967
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19980140B2A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:21 +0000 (UTC)
X-FDA: 85370544042.25.7BCB642
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C44E100008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zJz07YcW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3MUpJwq590qKxQafFD8yMuDx2EKKmvFmC/ravAUrJ70=;
	b=Il/uQYZ1zy42D7kTDBO4Cw/nL2ECgDWNuHtfODpUg5mE82fwmlhqqUQW6NxkD5r63yMzz1
	l7BBRknnKS1eWUie3GbkZtmaRnA3bEEE+cpD1RU5xuk0Lf3MMW3BTkCLgOIudTYoRmiGIH
	207fwfbzbZvD6xcIf0ZSbiQ02TD26N4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zJz07YcW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156719;
	b=sNn8tzcMR91SiEsuYGvphY/u/gseHHJt9R8kcR9RnOLVkcReqCKMOgprn9NsfRIiua8Gh2
	EzTPhTBKAGockuFHNy5gzzdMFL/i7zkLypdEFnZpmu7WsfLvRuL/VDcuYEBi2GRL2o9m1b
	4bfkr7y3eAN9aRi/qGGN9kONOJpH8M8=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-157fe9d771bso581538c88.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156718; x=1793761518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3MUpJwq590qKxQafFD8yMuDx2EKKmvFmC/ravAUrJ70=;
        b=zJz07YcWS2177m8/elip5rF0Cp/b6ZA/e+lP/39nGe8GWvxk4doOdsweeK/xu/iyup
         qOFFpxehZSJRnic0bHn804pZaspnXkuiI+w4nUdoCykdgiMNmYsL6kq9TGymCNAG2Q6I
         xbbTvqEkaHg7VJniouIsBK3T04ggT7wXN6v6X+k0bNt1LaNtf8tPab8eyLqJScUSd8/h
         xJrS6aRePaPM5bZYXdnK7vDfkzPSQICMpZjyqjpONsr2n4xF318X64reFidC5Ra+HaSm
         z28rK/W125kTFEycNLGAW4S8ttlK4YmzxuE4W4gizPBO6XLuGwgHVI6/XS/Ujmidgs9P
         Q6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156718; x=1793761518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3MUpJwq590qKxQafFD8yMuDx2EKKmvFmC/ravAUrJ70=;
        b=1nPtNyZ1V8ExFshHY7iBxZwqK+jC3aaguHXC020nd/eh4q1gCWCnAt2OobAvvSl+ok
         nmlHaZmmtdreT0x4xnckQ4CDIRsa5/V9JoKPDbZUzjDCJTLeMEAnLc3tKN5jR44nihRe
         edifY+fgmgritVFsOwdh1XJsJM9wbrA54NC2kuRXxRKLx8v45Cp8A8FPFqZoN02c3Ssm
         EYRU58i4DEU6zolpSu2e1KYo+iQMTftjO35ai07VayF7KQYYaTvMsbkuOgr1k6JbkFG9
         EY9QP/yA+VoJPd84POOj7ct7wy843nyYfNr5RAz8hvrfcmWzZkyVYUENryen5hosJWdr
         6ADg==
X-Forwarded-Encrypted: i=1; AKwUvBz9u5RH43FheKO1T8oISoW2KsSNN8O45BfshJx3NV0nIW6Bd/swwYbHPs+dPHo7Cam6c+/B4NAPEA==@kvack.org
X-Gm-Message-State: AFq9FYIsifvCsYT+sTN8kL1QzaIWgTNyN6KwWsILcgxAFZSJ5gSVqDCc
	hTEL046vl/rOI/JVcE4CQkjwxy91ZY3aVnpnpuLUEnN4Fp9LZ8LeDiM4
X-Gm-Gg: AYBFou0hmXqvmPyOOi+MzhvXSevL/NNk5PpgP+U5/sru/d43DYBhtSTCLkNL2lhz45L
	nE36PhGvubDQ17GVN1raAS9OUS5vNB2xptHhE+YjJw68/ARs/RTr6xPn+Byp3vtFj9XxGW5gVqU
	pq/3b05qdpagxtkKD5YAGmoHx1dVt4ayY78sTA5lgZJIzqoOBy+LAeGPfG0/FZ5giUt1XtQT8YK
	/KQM4rrfNQ1DMMu4oXsvrJwYrWQ9C40Qitowg2k654JtnxADrvQr/n6iLEoPL0tv/aArquFhXsd
	tSpo56Z5BSCyEQxkd1AqQ1ShxiVxreLHyjWqJZ1NF34+oN+VCPy1DgpfVGWJQiPhWdFVpHFjifD
	86evSyG0OuMiw9cFXlYBTiEay/wrsZFLK4Z+JdGNZC7A3NOSj/SlweBOIPlht0KO0/aDyo2htzu
	A4kCuSFJPBqJhwQFI4vpQdwhNOz47jYWjXqXPe8D0b+YGtXRNnha+3WCI4gY9RdPrFDUFT7aINE
	jWCD8VkGpZ+oP4qVaCMCPqr3t5CyZyht5FbNGZ7oNcijVDbRgnPD5zdIGMsrvm+piI8dwmGOpas
	fzrK8PTBX9CUuYjwTQ22Bu0otlIKF/XLGHlPM65QRw==
X-Received: by 2002:a05:701b:4552:10b0:1a3:dfb6:e593 with SMTP id a92af1059eb24-1a6ced8ee94mr1353465c88.27.1793156717838;
        Tue, 27 Oct 2026 20:05:17 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:17 -0700 (PDT)
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
Subject: [PATCH v2 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
Date: Tue, 27 Oct 2026 20:05:00 -0700
Message-Id: <20261028030503.17923-6-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C44E100008
X-Stat-Signature: hmwjm6i7q7gm75zdc6k7fk1e434h5rz5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793156719-408134
X-HE-Meta: U2FsdGVkX1+tTKTmWHf+OK5SyYWV/E3Jk2FGhnHN6ob0jUUXeFF3CJ7Oy7sSBgWFkrpJywMyMrFoFURiA8mnU1Xdv+UhR8JcY61am/WGdt/wE44hna94ch0KXExwAbD7iElDz+saHbJE8uEWHmBd0IIlDi63vI6FQyQ5eteX9BA3hgUqLvT4/+hd8ACBmWdDf5FpS+byHsJ5YAszcnNDO8BC8lYkYCQeMAUPn3fMwOrRyZ5F5jXtQmTkrGyhL1E0VXiepB/5XFlIof60YkVRn3yEk4Ob8OV0pxwS2hRIRrVvnrnzbUd0VagsZfFAo1rjHonn46gN9f9VVszaWBBqWzJMR/7UG/hMgj5JsvIBafyv1yJEgKxVp0pof2Ii35pOzK5W4lMltsm0Gh2btf4k/rSsbKTz2Koj7KMWr/MHmX9AP5oMgSUrDI3GfI5YzXK8IBZ+CpHEbqtqTrz5eR0CxE4nYzqp3cJ+AoQa4Ann7VdeJbEENsPi17RsaLu8tr800Y28MMF6yvGHg+e8Znjyvvjlqi94ZqNxrEFjwLawZBnpJ0KA9iNJrr0+38zdJNHtOftK5XWORQ4dwZiWH8PFu0IAzcMCuRec5XyDF8ahMO7Lz/WJ0niCpmtmlZSJp5z9cq47280WW+jEZz32xQXS5qNaiTilnI9xf02URKGew0PBBA9i92OLgunqRJhzHC+8PxQu+MrBXnhfIFS5n25RDPJ7QbJSBUSVml7svSKOexzPUC3R5S7R0EoMX4DjbvyyhZJVoJ5BLXZHNWdOxVZGd0eZ72YzVM5Jn37fSm5BuTVnoetTNQht4OlyaX3qKK++EbunxSVMnI4wx2FvEPLxXZHOPxPAF5fB50d+AWmMRd+Yuw5620BJBEOLPWyd0gh2AD40Bnm0I3Zd7TviGoRLP6E0Nht6qWyTEq6oEhwawy5ixGmFABd/vyChOlgcn87LDPL9AlxFfgnfZ1Vjkt7
 nGpcIDZU
 Dbr6qCBYmX6dFQgnpcJXxctalOjeKetFRPj6FWxogAJKy/fLcjKpu8GqNDJ2njcikm37Fwsfdb1VdHG89flarmxy9EhAG74xua+TSoWIABsxe+/6OrDdQE8kCJWoJ8b7BAJbu1mBa6X3wYaR8/SjU6A/mJL10p02Ies7ZaF1qf+7yF6wIv8m1oAJrdCSYdEZxYoQSkemsz3E+oGGT4FGI66i83jNQfgJ4BnI/l8J0mH5Sk1WWb1dR2c+vuJtR+A163JpwA/LUfejWJ1IqRXi4b8oMYcSBdGjPft0FlpSaTt7mdn5AAyPBaSjJztWOcqCgI/KG+behz0Jz3CynmLvcMBJAy4D/ytHZQgVCvJYM283BF8b/8I4GrFBxrWq0LzhqrUUkNqQZtK02xfhtWAMiSPrOp8N4VY/elJ7ZMA9W4OnNr0JZCpBia5dDhB/KcvpXtERTThBbtCDmo4WXnD7cQZIFNJUYjq8L17lEAheNXhHi7UY=
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
being at least as large as the PAGE_SHIFT, which can be 18 on some
architectures.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e1d57a7d9595..19b7d60bc7d2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -180,6 +180,7 @@ struct zswap_pool {
  */
 #define ZSWAP_FIRST_POOL_ID 1
 #define ZSWAP_MAX_POOL_ID U8_MAX
+#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 18U
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
 
+	BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT < PAGE_SHIFT);
+
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
-- 
2.39.5


