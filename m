Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94EAFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B68A6B00AC; Tue,  5 May 2026 11:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FAD6B00AD; Tue,  5 May 2026 11:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D3C6B00AE; Tue,  5 May 2026 11:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51C8B6B00AC
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 139744050C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:26 +0000 (UTC)
X-FDA: 84733775532.18.1B89318
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 38658C0002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l4rhFr7p;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4A1Rhza7++tBGVkrCxZWq6+tCWAvd5BViTmAL2CBcjA=;
	b=b2f0xe2QHzhaLhdr15h9Yqpqxt8lGsV06TMRC2yaPwzpzG98WkFj14K1aFHUf017lOEsQQ
	2NfZUMG85X2uiAaNDFDq1LMM33oZLgfgFaokJhxu69mM2eEOW2ai4rMw12coAStRNDEniI
	kKAPcikrhvQGmHloj4nhMP2hO+RqPCc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l4rhFr7p;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995564; a=rsa-sha256;
	cv=none;
	b=pv4N0oRA38ubAPYALdFL+3nTf5Pbwix9aAA7Rtjnj+58ZswFedAuz5YQV8wFajkLCVJApu
	9acwKads0+fXDhzbY6h+J9d2mGd5f3opBM8qfyUeUPPf9KF6txsvtd6S0KLfNKF1f6h3RI
	h+avEjEhAzgPB06SU+Yvkr/+PZO2R2M=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-479dc6d26e3so3030910b6e.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995563; x=1778600363; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4A1Rhza7++tBGVkrCxZWq6+tCWAvd5BViTmAL2CBcjA=;
        b=l4rhFr7pMdfQ5Bax9TSfbv4dTHSAbwkqxdAwXqnL2K+sGV3eWKKeBUUKagZc5r1ESu
         KxJwMPh/MfmYW2HXlPpn1DEFm5x14JxNfB9Ga+g7cOvRrlrliClmVWHvUrZxHZO9E4yr
         WXA9hBTW1tVoeIs7GF9JErg0HnpuBvkk1Mg6OVDije7DUFX9SJ/sZ+CK+HA4MwGdNi5U
         maCtmUOFW+kGrnhzgpNs2ytUpA0sCfm51YIMiPqZBf23doM/oSm8Wxk4Vz0onlep9EaU
         uGzG9DdkXhghZ1icVPtb9S9JwemVax2GE4lI978DyLCxWyLhUkeglJ7oxqyZos2geJ1J
         dLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995563; x=1778600363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4A1Rhza7++tBGVkrCxZWq6+tCWAvd5BViTmAL2CBcjA=;
        b=pQD4TH8sjFoMv8neUwgd1VhpoiIGXQiWsZCMSJ5rUmzx4ghN2u1p8qCA8MmBLzVTNx
         dggQ2qv0oWwyKtiazk7FakBGDJCmNRI9jvc2OuVFByPLCgHZuvQq/ShoUO5hUZuCqGJ3
         fMYukyjZPidfiSaEfUtLy86zwGUd5ugVdzVTezGlSE9+3Wrw4naFhLfcFUvlSvvd5/bn
         6GERtULHP3iMXv/MVgYRinNOTgunzAfadbZBas6GvvZ/vYl8F7DGXOV1mDuYQBChL131
         IiMINMDYU6sfRzpP0euKuVSdVN6RnGbQ0Y0/pTiqgMiyJwBmcTIiY1ucVhZ7jOh7kURv
         HEjw==
X-Forwarded-Encrypted: i=1; AFNElJ+UMxXZ5gPUtz3h0KNVlaH3oIHHolCEkuW3TiWljfS1ZRSRuyuTGhS8zArwt7E1l2R2shgEaFKewA==@kvack.org
X-Gm-Message-State: AOJu0YxYxpY8GS/PVKDY2J4Li8d6UnRJadtFmr+qbKsqhRyW+wUHdGmW
	emspkgZasEesRaL71/fku+3korVSBkZzM+JTe8an41Q+wOqkzu6v4EZp
X-Gm-Gg: AeBDiesUIhn1bzlDbqeaNshFcLLkw/6gJYWw1eTp1CekQCNWpBEGobJkEp4Iu8WAouG
	vxWd6DVKfRiaDzyfU24psovvUf1mnKxHM4T7cR9aN7RzhRxJAekEJ0uoeFjMSUIhR+uPcoHZyKG
	Kg0z252Ba+EVEI2/QYAJTJ2MmMh1IphJE1zaRVnyTsgwJqPdMi/iBPj6F9bHGCys+1RTKaVk5DU
	TRvl2V4ewZQ8fIjgnM307yzh/3rcs5Wigd+HcHGP+WM0KEgTV8ACtl4v1d9L9h9G0pWvUKfyS9P
	UqHw2vI87UR35I5wLamdNOUGmQPC75eqNWpfoaPvyhtaUNDuq/cEk3fM4rEfr4cFzScKrF9U+qU
	R04aTVjZQvxd+UVOODnBMooIbeQEDXjUD6UZRgu9lDESDplDsq4oYmQu3f6zQuGgEeolAGtmvPT
	eFeUqjkt0Xzl5r9Dix3YD9AhuVTVnOswlZr1VhbYeTS9HKZ1SQXuqiT30ktZtT8Guf3cY=
X-Received: by 2002:a05:6808:190b:b0:472:878f:347d with SMTP id 5614622812f47-47c8922ed6dmr6800850b6e.26.1777995563088;
        Tue, 05 May 2026 08:39:23 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76985f8fsm8843938b6e.14.2026.05.05.08.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:22 -0700 (PDT)
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
Subject: [PATCH v6 11/22] zswap: move zswap entry management to the virtual swap descriptor
Date: Tue,  5 May 2026 08:38:40 -0700
Message-ID: <20260505153854.1612033-12-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b6akyeaboaocnth9pycrk4mdcgsrebt9
X-Rspamd-Queue-Id: 38658C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777995564-275115
X-HE-Meta: U2FsdGVkX1/r698kdllWhRJ3G9psAAUiQC2G1rTx65gRi2d8euQX4QRD6EJmKVNcLUixpXIVeOI/B/fckJ03exBmS8qayzy0RMatXcfdZtH4+0lBDfX1YjwsBLKTjknAyl9QZDwty5SZGSlQHLaDdYpbu/I6ruVDh7ph+psl6jNAwJl7iBYV0rNOgkIFcx72P49pYXMzTSXOQcG46n3Oes+OoPw2RF+9D/JgB38zaawQZXOixn2DBh1JkeIyedgGrH8JP1mPLrcbs2SQeb5EfVE+tu7wWMl/1MhyUOUE5yAG0VGaA6bJXe5+p36F/Q8WU6dOGLPWRTIgwzC1CZfYuIl96liOMaTC7BQL/XV5xOvLGS208gStQC1lor1pBXARonDotdQ/IHmoiyaBY4doymN11aWMFeN9PYZIa5oJ+ENy5PRX8whu7/FjyZ2VNE2O54KqCuS50Pqy9C/F3GIVXT6S1B8CvEzawYkJ+v7nXDDbWIrodzBAm52KUoeUWkWYDQCwqe4RjXNMwIQ8fGyNSP9aM/1TS5bKwNKPLYRm5PXHvpjtlJ4YikX9rN98GqwSSxQKZLHia2t12OKcexwPGbdX6oJV93tYn/JX7zMQjA5xtWNkAC8tetnpqOo+QYn2sMYFrrV6dZqMkOCgkT4pPZb8B6Fz4yNn4SMHjNwQnLUVNqHXe2nTDk30gp99n7I5o8XRzMjt2lmWUedyRQDCgHF0zZGqpkUORbTaI0YxQOBe5qJQwQKmNbe11Cg1EXR7fAq8z6+T/eM9K6S3zID/SH3kXTBHUxi3k94GS2bhvzOqoT25CIYik/E2LL8Xakcb1l7znZszmYaIbLDl8Hcseb1JpVtxgkHzjZXhqJioxPlUJY466liJNNtKDUXlK6AmKNhvQoo5lirxSlv/rYrnyyZXSFHPi4i+8AyouzgrtwPq2H9TMZuJp+/3jQY+nVzykxUhvjFv6wQniifdlE6
 ZRCWu4JF
 Z7RT4U2Kxbsz8ZVtQjXvpdWt+PxFjJZo/5/wWIGQjWE7aRIwx5sJibgqWcJPVPJoNCMZzgGbFEDC3HFy/Tz09640q7HEHgeFt7KT//yivZBMpcRZl83QtkvfDmRJv4Gr0qfnp3EfyDgLgydtRJhw3TFibrgNuORWFwPJBy5hPXLRrDmuqgmX9PJotdea+cfJN+nYKDTvfV+2v1TbFCoWex6fKVsgYnU6DBalKWrzY1Fa94BwjrJY3MIMd3wBfzUbdAMtfpw/LJKyy7P35z5+qdgLrFVJ6Rxc1lWsHHgsDBVdI4WYPgUpOMce7BW9/0NaSwqGjdbuqNl5sFzh68gez/5w4697D1I7tT8tx16uJoSu/h81baOJM+UxcPPchvql4zpSxB2z2rDVqmYZKMaAeQ/0vBzQxNdOEe/Q6QyP9OfRbK2ccJhD6veKFiG3R6Roh+qBCmkPolVGC0xf/dZ664hx4xT82oTVIHx2Gf7ymlPx9J/rDmW+m0EtR6gkUaHzouw+3xQXMWxNiCHVRMxKId9HyT5m7golCrKgy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the zswap tree and manage zswap entries directly
through the virtual swap descriptor. This re-partitions the zswap pool
(by virtual swap cluster), which eliminates zswap tree lock contention.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/zswap.h |   6 +++
 mm/vswap.c            | 100 ++++++++++++++++++++++++++++++++++++++++++
 mm/zswap.c            |  56 ++++-------------------
 3 files changed, 114 insertions(+), 48 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 1a04caf283dc..7eb3ce7e124f 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -6,6 +6,7 @@
 #include <linux/mm_types.h>
 
 struct lruvec;
+struct zswap_entry;
 
 extern atomic_long_t zswap_stored_pages;
 
@@ -33,6 +34,11 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+void *zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry);
+void *zswap_entry_load(swp_entry_t swpentry);
+void *zswap_entry_erase(swp_entry_t swpentry);
+bool zswap_empty(swp_entry_t swpentry);
+
 #else
 
 struct zswap_lruvec_state {};
diff --git a/mm/vswap.c b/mm/vswap.c
index 3be42c45a1bb..fad1fd86e0f5 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -10,6 +10,7 @@
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
 #include <linux/cpuhotplug.h>
+#include <linux/zswap.h>
 #include <linux/vmalloc.h>
 #include "swap.h"
 #include "swap_table.h"
@@ -38,11 +39,13 @@
  * Swap descriptor - metadata of a swapped out page.
  *
  * @slot: The handle to the physical swap slot backing this page.
+ * @zswap_entry: The zswap entry associated with this swap slot.
  * @swap_cache: The folio in swap cache.
  * @shadow: The shadow entry.
  */
 struct swp_desc {
 	swp_slot_t slot;
+	struct zswap_entry *zswap_entry;
 	union {
 		struct folio *swap_cache;
 		void *shadow;
@@ -241,6 +244,7 @@ static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start,
 	for (i = 0; i < nr; i++) {
 		desc = &cluster->descriptors[start + i];
 		desc->slot.val = 0;
+		desc->zswap_entry = NULL;
 		desc->swap_cache = folio;
 	}
 	cluster->count += nr;
@@ -1034,6 +1038,102 @@ void __swap_cache_replace_folio(struct folio *old, struct folio *new)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_ZSWAP
+/**
+ * zswap_entry_store - store a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ * @entry: the zswap entry to store
+ *
+ * Stores a zswap entry in the swap descriptor for the given swap entry.
+ * The cluster is locked during the store operation.
+ *
+ * Return: the old zswap entry if one existed, NULL otherwise
+ */
+void *zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *old;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	old = desc->zswap_entry;
+	desc->zswap_entry = entry;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return old;
+}
+
+/**
+ * zswap_entry_load - load a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ *
+ * Loads the zswap entry from the swap descriptor for the given swap entry.
+ *
+ * Return: the zswap entry if one exists, NULL otherwise
+ */
+void *zswap_entry_load(swp_entry_t swpentry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *zswap_entry;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	zswap_entry = desc->zswap_entry;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return zswap_entry;
+}
+
+/**
+ * zswap_entry_erase - erase a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ *
+ * Erases the zswap entry from the swap descriptor for the given swap entry.
+ * The cluster is locked during the erase operation.
+ *
+ * Return: the zswap entry that was erased, NULL if none existed
+ */
+void *zswap_entry_erase(swp_entry_t swpentry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *old;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	old = desc->zswap_entry;
+	desc->zswap_entry = NULL;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return old;
+}
+
+bool zswap_empty(swp_entry_t swpentry)
+{
+	return xa_empty(&vswap_cluster_map);
+}
+#endif /* CONFIG_ZSWAP */
+
 int vswap_init(void)
 {
 	int i;
diff --git a/mm/zswap.c b/mm/zswap.c
index f7313261673f..18725d9b1194 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -145,10 +145,10 @@ struct crypto_acomp_ctx {
 };
 
 /*
- * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
- * The only case where lru_lock is not acquired while holding tree.lock is
- * when a zswap_entry is taken off the lru for writeback, in that case it
- * needs to be verified that it's still valid in the tree.
+ * The lock ordering is the vswap cluster lock -> zswap_pool.lru_lock.
+ * The only case where lru_lock is not acquired while holding the vswap
+ * cluster lock is when a zswap_entry is taken off the lru for writeback,
+ * in that case it needs to be verified that it's still valid in vswap.
  */
 struct zswap_pool {
 	struct zs_pool *zs_pool;
@@ -223,37 +223,6 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-static DEFINE_XARRAY(zswap_tree);
-
-#define zswap_tree_index(entry)	(entry.val)
-
-static inline void *zswap_entry_store(swp_entry_t swpentry,
-		struct zswap_entry *entry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_store(&zswap_tree, offset, entry, GFP_KERNEL);
-}
-
-static inline void *zswap_entry_load(swp_entry_t swpentry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_load(&zswap_tree, offset);
-}
-
-static inline void *zswap_entry_erase(swp_entry_t swpentry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_erase(&zswap_tree, offset);
-}
-
-static inline bool zswap_empty(swp_entry_t swpentry)
-{
-	return xa_empty(&zswap_tree);
-}
-
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
@@ -1168,7 +1137,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	/*
 	 * Once the lru lock is dropped, the entry might get freed. The
 	 * swpentry is copied to the stack, and entry isn't deref'd again
-	 * until the entry is verified to still be alive in the tree.
+	 * until the entry is verified to still be alive in vswap.
 	 */
 	swpentry = entry->swpentry;
 
@@ -1445,13 +1414,6 @@ static bool zswap_store_page(struct page *page,
 		goto compress_failed;
 
 	old = zswap_entry_store(page_swpentry, entry);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
-
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
-	}
 
 	/*
 	 * We may have had an existing entry that became stale when
@@ -1462,11 +1424,11 @@ static bool zswap_store_page(struct page *page,
 		zswap_entry_free(old);
 
 	/*
-	 * The entry is successfully compressed and stored in the tree, there is
+	 * The entry is successfully compressed and stored in vswap, there is
 	 * no further possibility of failure. Grab refs to the pool and objcg,
 	 * charge zswap memory, and increment zswap_stored_pages.
 	 * The opposite actions will be performed by zswap_entry_free()
-	 * when the entry is removed from the tree.
+	 * when the entry is removed from vswap.
 	 */
 	zswap_pool_get(pool);
 	if (objcg) {
@@ -1478,7 +1440,7 @@ static bool zswap_store_page(struct page *page,
 		atomic_long_inc(&zswap_stored_incompressible_pages);
 
 	/*
-	 * We finish initializing the entry while it's already in xarray.
+	 * We finish initializing the entry while it's already in vswap.
 	 * This is safe because:
 	 *
 	 * 1. Concurrent stores and invalidations are excluded by folio lock.
@@ -1498,8 +1460,6 @@ static bool zswap_store_page(struct page *page,
 
 	return true;
 
-store_failed:
-	zs_free(pool->zs_pool, entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
-- 
2.52.0


