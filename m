Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDB5CA6011
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281986B0098; Thu,  8 Oct 2026 14:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B736B0099; Thu,  8 Oct 2026 14:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121386B009B; Thu,  8 Oct 2026 14:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E42926B0098
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 662CC16045D
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:38 +0000 (UTC)
X-FDA: 85300294716.23.7603A56
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9AE7740002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f6nKOpGD;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484116;
	b=OMyh8uxz1y2IBVFWQxN1CtkrwsGJoaLVtmiKtvsTTotrUtiy+ysFIL+YjCKZcEubOf/AtH
	yKHlQLbqHmpa3/RGv77iH5IAD18fAEClHXMTFly5M91mQfMSAdg/pVx2SCgsiSpGkfIqCS
	Vs518KkfIIFsqjrOwSmfBhvtefAOKSk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f6nKOpGD;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxE3sHe6me8Wwsd+c2Znto62yEHlspamg6eVt2Dlhi0=;
	b=wqZu+s4zqGa2UnNVQ6cTaezoyIndvfG55NpUqBIigCI7/B+8XK84MeZ1gEKoKEEGDWBYWi
	cWixRmW3bkMRusSRJRyTVPi/jqhJK20BLEERCNMwCv1lUVlamILgdC4GwFsN48GX5NEZJN
	ID1pUWIGuVNyhXG7m/b9Ri3o9Q+hU7I=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1433e7b057fso4031501c88.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484115; x=1792088915; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AxE3sHe6me8Wwsd+c2Znto62yEHlspamg6eVt2Dlhi0=;
        b=f6nKOpGD+aHkJGC2zVsc/2jf2Jz31w3HwXRLYKAoa9E3el3PM2LifpbgKM+qTWJahd
         nD/mS+ZiI5qK4LrDItSv2Pd6tRdnWAjvxHCl7/Jum+ARSyBWC8FNUrVdLpzzoQkSeIiC
         vFdYVq2fLN8imvMyYzQc/XmCQowti8tNSZiWsjG41IP/gSWzF1MMsEr7a9BQwDOizv90
         t6xKd2PXltW2pikV0p+kv7ECdxsyrgEQOt3IfgRM3l2WgG/YrOngFXjGHYv+4XFYhtye
         1o9OeRyimM0Qy77D1X+0X60jyU9ploUvzGuAhyw9E+NCh/PN23C0I6PfuEaqrqUGCnyC
         z7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484115; x=1792088915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AxE3sHe6me8Wwsd+c2Znto62yEHlspamg6eVt2Dlhi0=;
        b=xj738gGUlJVszB/SY8jrHMP/F4u40UsO8yi3Rpgm9ZAFBXubd8hrCpdRqs5z2UFTRQ
         LYdhuChATL5sTG1frO2HpHvoLuFh4f1PqVtGjBbY8BV3DlVppQXWIjGFKaIV484FIroM
         gYHwOZFLANJOn6D1OOnTbH/LvEspd3wfBhD00P+B5ZTBIvSReBUVRCCRcAkiTbOLpsvn
         EBIVCP84iNBJ07O4mkqO6O+Xs0+oUEcXE+pQPGzgTHoSR3OOK4E7kmiWjMChKtCcvDhQ
         mKiKtrer1FKfVDt14wupGvB/bjtFVyk2wcCRHUIWrozyilNEL4hLvq2uEMqsxGLYjOY/
         L6eA==
X-Forwarded-Encrypted: i=1; AKwUvBypycS3Msd9SpRiQ8Oqyo5ekQmfI5rE+APkUqKbuv7BKJqw1ol0fj/wcpYy4yIF69whVlPxXiGplQ==@kvack.org
X-Gm-Message-State: AFuF++nnixC3iY5px7KbUHf6AJJ80J6OS4e66RXzHpAGb0bZPGSLpMPv
	IDiQ0abKyYHCIeBlhydq0MV3KGFYA3T1uO/9noZL+IxaU+1Snss6ch0b
X-Gm-Gg: AYBFou2hgbUII4sASDcqNeEmTxhz26pssoDFTx5E5jRnBgCeJabbUjSNpz9xzelFgWK
	wAKhAiRUe7PDal3h36SRwjBolW6tB5JSY4Z0OgQsLZ0pc0TxY5hEYTLl1S2xNpoKjEl9ximE/ev
	Tk4Ba2UnkdISBazjwjIjOEOVqBNahbfDleTfcClltSqs0EQxpMdUy8QPSyPO/XK9NbvLD2wyv0T
	wX7n5ngyd/Iq+R5vRGI9NVmPa/nxGIJ9CW/oGd402jpot9dy6bYpSpQNlwk//1d50aCpZ4Q7AX+
	vgq9BcyJyt66qwZlgcbmPUvKTFDnOfjwOsJOTivUnB3Dkh8nJTuDUT2+BoLl1p1onfBlgLS9pHD
	Cm8oHf/F/tUQ3o/o1mJd/DyDSCzgcNs2DPk4AVvXtjqQ1+8QQm9Nzb62IpHFok2KTOKeSVm8g0K
	vCzKIEyxZp1Jer/1NQXmsJie/h75tq97p9tACX2rm54FQcANwVJngGh1TYyYouOe5w6Sg/nTgZ6
	rY381aPt30=
X-Received: by 2002:a05:701b:21ce:b0:151:8280:2c57 with SMTP id a92af1059eb24-1620880900amr6711157c88.38.1791484115200;
        Thu, 08 Oct 2026 11:28:35 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:34 -0700 (PDT)
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
Subject: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
Date: Thu,  8 Oct 2026 11:28:11 -0700
Message-Id: <20261008182814.27450-6-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9AE7740002
X-Rspam-User: 
X-Stat-Signature: 4q4mijcnkdxj5c79bzqx4a8q8g6xbonb
X-HE-Tag: 1791484116-903785
X-HE-Meta: U2FsdGVkX18v0J4+z9iy1ww05jE04+J19vUWcdcOeo9w68QFSslk/g+KhZeflqjioRtBbOBxRAr66+X0BAtTvQLvc2MGepdmFAFdd0vCtOUxLXW2Ei7eiy/P/NnqXs+AkbjhQRSIZZ7ElCL6Bvj6wulLRzCNJIkh9vy3xJ8NZWGmCUmi1gfjcmNY5mzYuw6fpBFeIwXAlnPpql8tMn2p0jsaV3D1JtW3+7MQp9XA/76q9hTla0D8XaTg1/pEXDQajoIGLyLeZmdPalW++0rNLBcoHN4VfQyuxbcZceYnidCd5Ss61YTTQvdE/OtiTty7h8+ylsQRByAM3DPmaq/q6Fn64ZYzg6s1jBchYL8Fq5oNha7pvcpuEN8y63NtJL3fdOniWVldxhBWKdd0wOd9oZlzejqWRA636rsdX4nwLowe3rEMZnjgAQE151b/KcEWvtsXq8j+JLOTfeIQzjQYvojARldCvv/5lBvuF3S+s7DwwjoMqs0tTTvPCb/16Bnl3z+9+qDOOuZxyXwAk+37J64Hyv9W8THqSVgS5SgBjZx6BMGCLTqBwNHNrzhIoTwQsJ2V9ZsaCtMt27x8cCaMfNy+ekY9IxWMrMhamoCBREXxIRMjw96dxAIknxgQorwKU9Ss5fAUFM/FaR8x8OqPCxAKBoOafYeKpl7jnKZ1+kO93vgrAQo/7T2AygIWemDljBzmbjuh4Zk+nYshE11PrDl6100nqhIQYvcPwTRCB8bkSHukUu5ncFxUA4wO1Xw0oFsKKA1Ma0K7JV/epKkbAL8asIh9Y/qxtjRfEb+uQM04ZPUr/oGyeEvG5hpg3XyP+nuP2GcV0jVwkDudzyHjxdljfCv7WESx4JH+WELYLIRNF1BqGURbhO1ok3kD+MbBsBcRIMS8I1fqmqjBnzYEt3Bha4LjjPfsb80pIcz1vML9dOS2KlXPByobAAzT5FzgD61wMm13Rx/tuFHzozk
 glxxkSqw
 UWEit31qAISsVutRTmKwE7WrS1xspyg7/SbMjQdNL7jWpvQnjN7uoODle4O2uYbGVncy1I2kJH6OU/zok1lY0XevIyoLsU0XAJyE5onlCKzIH69OTB2ndmURW2MfmGYezvuAgLEaVzS+wHZMPfi/whJJc8NUGp0vyOk2tFgZQ765QmKKL/zSbKnzTIDF44gJmBiw8PsOpdlpavLrQAS+kkNvEs5xhHDfySu6rs8zNmbDk4VAHPSvuc1doG7ccRliXt6ywj18NEDKZwfmUZWwE4D7AD1lwC/DhfS0Oatk3P+L3gEuRj2z/OpFMPf5WJUBswVayZQGU2k5a81yCf0NoIv+gDzwsTnOHUVVIfdtKXw1s022pP70cHjLsre17nAJGL2drcio8Cat++vnUxTc0jPJCbpks4Hr0y4IHnHfDSFE/f50pZFpgvHhpoTVopZbeLFqMwbyr+NRwV7a8iaosOrqsW0coxmoKUCZxvC9nYK3plKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When storing a folio in zswap, save the folio's node id in the zswap
entry instead of relying on the zswap_entry being allocated on the same
node. This enables optimizations such as batch allocation of zswap
entries for large folios using kmem_cache_alloc_bulk() that does not
support specifying a node id.

The size of the zswap_entry remains unchanged as 'referenced' is lumped
in with the 'length' (as it doesn't need a full unsigned int anyway).

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ca513a9f89e3..c2731d3acb2c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -194,6 +194,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
+ * nid - NUMA node id of the page for which this is the zswap entry.
  * pool_idx - id of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
@@ -201,8 +202,11 @@ static struct shrinker *zswap_shrinker;
  */
 struct zswap_entry {
 	swp_entry_t swpentry;
-	unsigned int length;
-	bool referenced;
+	struct {
+		unsigned int length:31;
+		bool referenced:1;
+	};
+	int nid;
 	u8 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
@@ -672,14 +676,8 @@ static int zswap_enabled_param_set(const char *val,
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
@@ -696,19 +694,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
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
 
@@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct folio *folio, long index,
 {
 	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
+	int nid = folio_nid(folio);
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
+	entry = zswap_entry_cache_alloc(GFP_KERNEL, nid);
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		return false;
@@ -1466,6 +1464,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	 * to an unrelated live pool.
 	 */
 	entry->pool_idx = pool->idx;
+	entry->nid = nid;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
-- 
2.39.5


