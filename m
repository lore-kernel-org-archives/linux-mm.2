Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42702C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9937E6B0098; Fri, 18 Sep 2026 14:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FC86B0099; Fri, 18 Sep 2026 14:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881616B009B; Fri, 18 Sep 2026 14:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6B46B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:02:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDDE9A0780
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:56 +0000 (UTC)
X-FDA: 85227653952.04.490E771
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C7B5100006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BsmshUkW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BsmshUkW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789754575;
	b=0PukfN8XBthLgfLu5UMj1WQX6FJcjzb85jDhzmVoeNC7pEI9wuIG2tkxs2z83tuOuMF3rj
	hSDQjypDwMNYUyvq24hv9niExflHJ4H0SMn/Fnu4hXBUkug/9UJ1vn3LbBpc0YKZe/lGzQ
	8pWyqr31oM3D6mfOfMSjIWGf5l4naNY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHkgIfdkKYj8pIFBCxdLHIsV2Dv3mqE/3ti2RlbB1g0=;
	b=BIS6tAMS/sc8Nhv7f5dv5gEp9ZImiwMw82l3FOlktZa8yezdTmcoBb2iPxGE9ABFZVybxV
	n3afflDJFek9cOsqsGJnUwRo9rjULRXTHst1Ac10LQb7WL8jI3rF4xFrGH7kTsBXBv0DCt
	+frfqkAl0mZZ9O72GlqgGsUL8zKwM0U=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b37a3ed714so668078b6e.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754574; x=1790359374; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wHkgIfdkKYj8pIFBCxdLHIsV2Dv3mqE/3ti2RlbB1g0=;
        b=BsmshUkW8gPEJJGbTNVISBnekayO8p2weslyzc82fV0LgYm5QAWqNMhc+K4cVS3SVB
         s070XgWIkHNzWz7b/eU84oHPI3JelmVlfCvPkiCyREOLgmwwLDan9l7XzCmld5J9bALU
         7wmVz3WTu2I8/kU8p8rLbj/pQJDi6Vo6Dbv/KRalLZoNIoXC2H/ljL7ctdxR0xL5d+0d
         UhmY90nl32liOl2Tl4tuNoyZfljTaoGAi75GRyl2FWDniM07iNPS/WaRlXpLp2nBEMB9
         naJJ9aAgKmZqMNE+niFfEP5Mmsitl5JxTMica1HWJiSsBTBitBGDy4TPrIX3KWhwcOUh
         5epg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754574; x=1790359374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wHkgIfdkKYj8pIFBCxdLHIsV2Dv3mqE/3ti2RlbB1g0=;
        b=pucA2NdffmxAx/uMmoGRNwzbfgErujPzsYBqRO3tCP+JRYBZZGJoz37ZKqnk1xqhfb
         AXK4azAmK9Wh7LnOY7HKZ8QWSBGnq4zHuCWMjngjzkfFfW61Fzwj23c1+axvcHmxQnbe
         cpZNR3cyotz4lCp2XDOHf1tKZEWkgF2YafM48pkbEdMpoTZU8Y0JQ2UJl6YEea/iXieB
         z3k1Ai4+eO7FsvAljdlg3b8Nkkw0gVL3q5jthU8BLQWcfpQNK2Ur7tKZgDNcqptdtUgS
         7d0eOA8rBzb6U9QPXjtL5bKv2HNmoC3Mqj8lFo+389cV85I20xma0Bbm1UEYUUDj2S8e
         SwHQ==
X-Forwarded-Encrypted: i=1; AKwUvBwFbK46XiaNveMAIgY5Z/MQZWlxqIEi6huLiwLscE6/GrKAL7jFEwWEPhhSpmqXaGhQ9hjBWVuMXw==@kvack.org
X-Gm-Message-State: AFuF++k7sO99hu2Cq1BmMfqgLVsjAzt60yFOuNkSp46AiJofda6tJ7xP
	HQciDTycTORSiurXZzXIiSx0+KpQIEQ5cni99KNN+T+EhYNfi747qSFB
X-Gm-Gg: AYBFou394n85AtGC4iWdkBotkAI4tQ18yws+wLaCAKJEPEP3AfRG0Zt5h/lXXTzXa8n
	JuQAHDiH1dZsaJhzfAP1GhDjOt7GKpsbSfkF4pOiWMI6xv4rHkHmsyx9aD89kVK48dCGSDdKGaz
	Y3j/05Da1YjijhUUmWedMB7YZCQrn+irDhHuwCKhjTwI6RErXjDPBQSrgJZoSKsjLfWPH88Mble
	I/7FhZWv/NjpNWCdQbq3U9XMY2bHKg3iOjJKvRYs3aH53K9RSdowO+9vtWvgjEVk1AJqwtFAQDE
	qxBmMg+mu5TNCDW9CMrnv3J6jlSoo1/mH5afSN45cs12/mqr1yxD4xJ2MVUbM+l0Oa/NHF7ak4F
	M7h/LlJvxtkZXWoJrhlaM/T9RWK3qvy4EFjysXSNV8AcKMoX1XQEzHT3sGBKZPKSPoAWG0lASUc
	DjYB3gqX4mv5E+Guii96XRmnb3wqofg52Q2rPfBTk8HxjUbFQfhVuWwTtkf4DhMpCWxkddsMz9y
	WWGGK3dwPIYSwbPzRxL
X-Received: by 2002:a05:6808:3c47:b0:4b9:a829:f016 with SMTP id 5614622812f47-4ccf74b986fmr3815644b6e.34.1789754573817;
        Fri, 18 Sep 2026 11:02:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8107dd8bd0esm154912a34.5.2026.09.18.11.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:53 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v5 06/11] mm, swap: write back vswap zswap entries to physical swap
Date: Fri, 18 Sep 2026 11:02:36 -0700
Message-ID: <20260918180241.3424851-7-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C7B5100006
X-Stat-Signature: 1dezjcqmosc8rki7jg9id64ufgahm1yz
X-Rspamd-Server: rspam01
X-HE-Tag: 1789754574-551885
X-HE-Meta: U2FsdGVkX18343TknLEK9NFeaG76wmqKzhy/D12hE3eKL9M1oukDqdHVzWEayMWR9ZqxitjbFuphRNfGZwckV81FYP9oopV2iG8OgEIflbBSrKnnEvDoyNsuiomVa02bKWUt+IVQ7SRXaQauhNGuwDF+mr/Cz8Gq1uGGA4jUgaWUWkntvXAPVrU0Mb9bPyrdpkGkSATorBm6VKv6SlZfSF1X8U450QbdxyGEtNbwYPPLaztEQsk3iJYU2LV4E7Kn9hD1+CjwvPAWeUjzmMEcXm4aUjdcoW/+4fYRFb0WP+JOiEVGgZfjMa9usDieWLncfEOBtCpEiER1Fx5e23fZBqr7DlV2Osal43wAP2H+Ntru5pwtr5rAbDSGBcx3i6RBjQMcUCPPLdueFHRRH8VvI+bHEk35nrXhcwa/FggzNf225oKqZN6msFCd7o50uAg8j+TSpp0pwy5cbkXKR301tRCJGxBJpIArcuL7MmQwSYJySWnRhxzUX+xJnyBcivrXHhSuEiuRhiL8zhT4zhtZj2HYZ4Ave93BzT4hsKoP5H1l6K0oc8zzO7q1E8yJTbvfasnk0RKustbgatduegiVQ11+hCZBREUNoxPuPFZ9zs0qbCjZiTe9QsLtWZO+VpZ83H6GGvM5ttoncOxDOYQq5BkpwpeQzZqTtmxP/3ahwdlSH8VIS846WmWJjrDNtLxvt/BzqgT1szO/sEM69HHWu5zfktZgVl2zdgMBBW/NXXvCA7pTuXTZEV3qzF70W3JunxFRaqkYqscUf4qCC+5xkxp/m091zBZUB4mCub8THmwvhAfcnPbhLZq85DqTt/JEPXgL33Dpk9iVx2FYqcErLTP3wpCyAttFYKUGl10jIpLMie6FVJVUXRslCRpWFxs94MfzkJ47imujV7VYqp4NmIXOYq2Y8buBXjqAjm2iJAaHQ0yZ7GkS/9FsNRG/4QaAtPBEsEZhGJogxZiFCDD
 ur/3ECAv
 N+HIaiPaKU3ZweioS4UqmaQX762Al6lU509bSoMlmy/9QI6MjyFQYldG4c+9GFTH9cstef0en+20okiy1AazxKiRDxpGFWf//Dh4yywqTOlkI1cH220+PljjDxBexoZqg2ieamuqvVJ4VMqJ341fKY1V8LgMTEOXpy73VvmV/pwvqFHRO5sft2wW1BSNQqAg3cHr92icado1vHeKLZ6V5Z9GlW05tnTX+kNmMZPOMSQV9w1Dih9kYdGm1xDblgkU8nv6dCC2xKeBg0wgH7fk85amiygAD2p65yJeoA85IvoF1nH4MIqMO0UJw+SjPZwr13/gs/1zvFpu7H4hlqLd7qCLdXuNvBbuPbtjItuE9KVg6vkIO8LFBlQaW1vMghKz6PwCVYn2nRd+Z7mGaFN/4ocF9Nla1Bt91q3qu2eYaovQGIqduHBojkfmMGiU9M1iyOgwHo0+8WBreHOrVqYkBr//7zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for writing back zswap-backed vswap entries to physical
swap. The mechanism mirrors the existing zswap writeback path, except
the backing physical slot is allocated on demand at writeback time
rather than already being pinned by the PTE.

The zswap shrinker no longer skips vswap entries, unless we are out of
physical swap space.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 67 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 21 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3e1aa295f9dd..56315298c291 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1025,12 +1025,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
 	struct swap_io_ctx ctx = {};
+	swp_entry_t phys = {};
+	bool is_vswap;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1038,12 +1039,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (IS_ERR_OR_NULL(si))
 		return -ENOENT;
 
-	/* Vswap entries have no physical backing to write to. */
-	if (swap_is_vswap(si)) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
-
+	is_vswap = swap_is_vswap(si);
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1062,24 +1058,44 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/*
 	 * folio is locked, and the swapcache is now secured against
 	 * concurrent swapping to and from the slot, and concurrent
-	 * swapoff so we can safely dereference the zswap tree here.
+	 * swapoff so we can safely dereference the zswap tree (or vswap
+	 * vtable) here.
 	 * Verify that the swap entry hasn't been invalidated and recycled
 	 * behind our backs, to avoid overwriting a new swap folio with
 	 * old compressed data. Only when this is successful can the entry
 	 * be dereferenced.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
+	if (entry != zswap_entry_load(swpentry)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	if (is_vswap) {
+		/*
+		 * Allocate physical backing before decompress so a failure
+		 * wastes no work.
+		 */
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
+		/*
+		 * The phys allocation above took the entry out of the vtable.
+		 * Restore the zswap entry to the vtable, which also frees the
+		 * allocated physical swap space.
+		 */
+		if (is_vswap)
+			vswap_zswap_store(swpentry, entry);
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	if (!is_vswap)
+		xa_erase(swap_zswap_tree(swpentry), offset);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1094,7 +1110,10 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio, folio->swap);
+	if (is_vswap)
+		__swap_writeout(&ctx, folio, phys);
+	else
+		__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 out:
@@ -1109,6 +1128,15 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 /*********************************
 * shrinker functions
 **********************************/
+/*
+ * vswap zswap entries get a physical slot allocated on demand at writeback
+ * time. Skip the shrinker when none is available.
+ */
+static bool zswap_writeback_possible(void)
+{
+	return !vswap_is_enabled() || get_nr_swap_pages() > 0;
+}
+
 /*
  * The dynamic shrinker is modulated by the following factors:
  *
@@ -1246,7 +1274,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return 0;
 
 	/*
@@ -1332,7 +1360,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * were scanned but none could be written back, or -ENOENT if @memcg has
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  *
- * Also returns -ENOENT when vswap is enabled.
+ * Also returns -ENOENT when vswap is enabled and there is no physical
+ * swap to write back to.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1341,7 +1370,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return -ENOENT;
 
 	/*
@@ -1372,11 +1401,7 @@ static void shrink_worker(struct work_struct *w)
 	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
-	/*
-	 * When vswap is enabled, zswap entries are almost all vswap backed,
-	 * with no slot to write back to.
-	 */
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return;
 
 	/* Reclaim down to the accept threshold */
@@ -1457,7 +1482,7 @@ static void shrink_worker(struct work_struct *w)
 			break;
 resched:
 		cond_resched();
-	} while (zswap_total_pages() > thr);
+	} while (zswap_total_pages() > thr && zswap_writeback_possible());
 }
 
 /*********************************
-- 
2.53.0-Meta


