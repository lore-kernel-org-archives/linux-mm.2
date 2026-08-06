Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC6DC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D9E6B0098; Thu,  6 Aug 2026 14:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DA76B009B; Thu,  6 Aug 2026 14:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CCB6B009D; Thu,  6 Aug 2026 14:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E44AC6B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:43:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53CD11201B1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:11 +0000 (UTC)
X-FDA: 85071716982.28.4B2A921
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A46E180009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="o/12bnNJ";
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786041789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkErdUV7HA1hqz0H4I2ABEL6H9gZP+ZkKpUGTLLTXSY=;
	b=O9FG1GDvj5s4clDcFvHowQMa6sUmKVff7TqWfrfiODBgF0pp+fjCJXU6vQ+dzRS34Zzczh
	hRv0wl33FpnqlN2ddnvN/yGgvYj6aCmiBivU8AB7zKA+HyHlTFUkZh+HMjiTa6XMwm0bOM
	NuKZBTCoxKDnwEJFPGTgqydXvrwbwKc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="o/12bnNJ";
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786041789;
	b=sS7DoVdKmGPJRwk/9PcL9cn86WYC80uXQTAjS/KaZKxZNg+SEhvZ9Ig7qoLDO38dawGmVx
	aRSlDwmEWi36pngNoowQVQRPWGoUPzrrfzWUn5g6sBd1ucSrbdkoxw9bfbq1Emhi4OzWcf
	TSj3ahqvqLf62mFozhSGqzFi3xQFTWA=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7eb63dbd229so958316a34.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041788; x=1786646588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JkErdUV7HA1hqz0H4I2ABEL6H9gZP+ZkKpUGTLLTXSY=;
        b=o/12bnNJHk2JoOZbtp0Y78nOrGmWfcOoastgXXxxFnPj5eYTxlbdYRabgESAdZmN66
         o88eaVzh54ZOvTnr4/11KOR2E0mdkOad9nYlh13nGyHsJaEY/BDP5qKMLL1zcXSF8dJQ
         BakgF4g/RF5x7yEthdqwCxOwyPxFONDZhL2r09vo0XsljUSJLg65y96uCaXqcQwPn7fd
         Uxf3IB9SWvi7u92mBi/bp//oIvmiu9eW8VBI9XE3BjzIMfgE5Z9WeEJ4eqbnbXHjDmAm
         dpARkCSQmb7t3BaONpKvP22/sosDwLIUh2Bcc4BKB8y7zN7utFjsXxOEwJPkSxFaENlM
         sLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041788; x=1786646588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JkErdUV7HA1hqz0H4I2ABEL6H9gZP+ZkKpUGTLLTXSY=;
        b=enl+mJv4yThntfL9bkmwxV9RPIUy+KjJrGJgXU58VcTKatuTB4o6lWt99atwQdBfzl
         9RXP1/6VSlSnNGB6VBGkvh9QKu36BmJ0xAgnV9ixlJ2cXMBwz1fNMBRWX25scVbKSCAF
         CuylTNpoJvDM2NFSrB/sBife1snLvGoXvmeQnAVT72Z3h3+lwoy1OtNDLdjTlY5Az67K
         9vo23amhnqQ7Dvjr99cd/wmwbOsKNvlihWQpNkNcym0r8prTLCc3XLC3Tv1uWm8jVH2u
         L9XgjJQ34frp2aSY3mWk1dl/qSPYT5NssIes3411kSsYtCjoo7i6ETxs2d/x1VbVfBfS
         2YGg==
X-Forwarded-Encrypted: i=1; AHgh+RrBE7A0xoAA6+U3di11khnea/7RRnbDrfx0/LbNkaKcQcC6aboCsmx6EwRtejC3vwosaEPy8Bp9pg==@kvack.org
X-Gm-Message-State: AOJu0YxPjaZ6AjZJMecrV6ZfQpg9/Cp+KP06B1SoZP/+j4DUz4BGUf3Z
	8Oq1ytele/xgDYaVmUwR0YiGTTtFx/auCJR4OtzEzTOpjPoedx7UDO3X
X-Gm-Gg: AR+sD13oqZREG6dQIZKDuSXgVxOmM+WvSDswj/PuehVkT+JoigGO/uF3tHPmMnGy4TW
	4DaGgdkTgyuxG0aHdgSaH4Sov4Wvmxl5uI1n5nMR1BvOYuc4Vw2PL6gV9UMGZPcho/tYkKnngYu
	URM2jbvs2LAAp+v0fCvVuD32Cx3pqXijYyoqCvWkQEdODm8/VKbWcH5buzyVtHMqj6keGzkN4WJ
	GeNpMkfQDFg1UOtD6wMt3PqyewfkGCuaoTaiBqDcShn56FAmFfeFTmSr2A76u0khScpvyszpPcb
	3oDYZWeq7J3DW6zKtMY+DrVguuRDYomwYRT65H/JZQ+h+tl8nV4vPmxGpY9gBeTi88IoAiqurce
	tAAC2FYIYnl1jXoWS91k9YdUv4mdY6bryvXmNP/U8yQJ3QUGj4KRzSnw2cRPES7qPx9vyZ2I6Jh
	EV/eUNRH9MxZs8r/n2NwZl+S4gyzyBfgdlSNMzEMDdBLLJxX12FnZThZqptV6ysmw8SXsJt3ASH
	bsNpb9z5A==
X-Received: by 2002:a05:6830:6d19:b0:7e9:dabf:fba0 with SMTP id 46e09a7af769-7f3444f2529mr1882168a34.15.1786041783901;
        Thu, 06 Aug 2026 11:43:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f1df34556asm5010219a34.9.2026.08.06.11.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:03 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
Date: Thu,  6 Aug 2026 11:42:48 -0700
Message-ID: <20260806184254.3790858-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A46E180009
X-Stat-Signature: dfziwetq5ck1jkmui73j6m8z3bwyityu
X-HE-Tag: 1786041789-723926
X-HE-Meta: U2FsdGVkX1+Xhf562kcpA7jtS3fAwzmDIyRze2lfgPkJWT4V+QGh4B6hThmqRYsRWIwk6ifph2Ll9GJJwBSPl7vCXwZYLZpKSGpguU3VvyWLJ00OoXNqeLQRrmtZu2Thwr0TS6tQEd6+D9F+A504aoYxPw/GK10we+E7vvUg+SSQ7pNqS5SrrQX1hUpwFLRLBkt+T0axKdLjofd7t2lPtLfVfx5IJbuPJuD3nLQT6ckS6mkJrGhcr7I6ZmBwZ1VBDSU0DWMcQreCUR3MrrFLkb7lyOYKxMhT+qUYTTInWze4IqHRIs2hw9keb6opZy0qzQW93YH1DnAc9qtYEvLZd9uV9AlKGfnIvCyAP+XTIRtEHd5PuAOu8amqnEc0yAL5Awbym2l+nGkhLon3UUe3NzbnctkGvvqSXxLKFn3A+Sq4lsPAvlaXM9jHqDVGUgafs1nVRE70WbshDs0Hyl4+MF31KSaf3XcbPkNj0X0ELbKKhKcYoLKYpjHDwzpIIVkCZgINyj+ifiVOQgs+5QdB5K8jCJ0Vgr1OmB3q2zB3kCWhubOPyWAmQoBBm3zQjUbl4aPAZGQxA60Ve1H4CbP0yuHNAwS0U3eSZVkTQZtRt/votnlHKXZuEHEA6uoNG/U1WMOrNgkM6qWh3T9JKO0EVVc54zTZtNbUEnsGl0hyxz3gWILILI0/gP5tj9iEoC5z0SIt3+U3k1qqHjgv4rJt5KEobnvtgt1JkdCN3gb8SUBbutlNxbyyKeWaqHTnC2Nlo4hHztCKjYZmCFZJVaPBmM3aLMNizJTN3wzYyJUgc39J9cQnhl4eQusEsVvj1to+vJjWjooRofMY5emk5uNj3un//iw3xdDpmhv4AibTaYUg2p82lILo1XEO30bUtyCE74rV9Ezt8ILtyaKHUbs6JLwSAYLaet6ez3Udk/M4cRS5lIBe9aoCl+sYFh96sZ4UgzNV60kIMnKp08sulK+
 ROD1nplP
 irOM437iKRixy103WoRlNwcKcAw4jO1l/c3GRpjxuv9Dl7xPRLMtkr0zNq0PLzdv4xqsL8nLpB66t5davSaGH/rwocFp4cPKJwrRAQKXjopWEVjikbRjZbaxCZZdkmW3+q80TcdNFepvURGf46PlGPjAcNVz+4arRmbvyzOFkna4SXYLjmzbH642MmKSM95SHiGifqDVsukF0HA4ghvNNB+UPsxBZ64Ox//f0wJKcCAFZ8pbRN06lyvFSWiomno7OHWYTYrcn3ZYPDBLkgV32FkNuSwsmUGwb6n09yrbtT93xK+F/HvDzbrWXrfvnSoBuixBgDpaIMHkhf2p3b5nxy8rWWLFeFD+p8xX7OWrBRRD+XA630aH5Vc4/8JtR2jd7BbgyelyCp1UBz8YYlJIRfg1vEDXk/B7BteLifVPRORIA/DHLcFFu016EaDXU0tz0nU1ffxBWctUY+SJKTBpIs00E6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap a large folio back in as a unit when its vswap entries share a
THP-amenable backing (a contiguous physical run, or all zero-filled),
instead of always falling back to order-0 faults.

A zswap-backed or mixed-backing batch is still refused, and the fault
retries at a smaller order.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     | 12 ++++++++----
 mm/swap_state.c | 17 +++++++++++++----
 mm/vswap.h      |  7 +++++++
 mm/zswap.c      | 18 ++++++++++++------
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ba84565605a1..a1e106a5c5e6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4815,11 +4815,15 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	entry = softleaf_from_pte(vmf->orig_pte);
 
 	/*
-	 * THP swapin for vswap is not supported yet. Also, a large swapped
-	 * out folio could be partially or fully in zswap, which we lack
-	 * handling for. In both cases, fall back to order-0 swapin.
+	 * A large swapped out folio could be partially or fully in zswap.
+	 * For vswap entries the THP-amenability of the backing is checked
+	 * later under the cluster lock in __swap_cache_add_check, which
+	 * rejects ZSWAP and mixed batches via -EBUSY and triggers
+	 * order-fallback. For non-vswap entries we still need the
+	 * zswap_never_enabled() bail: zswap_load rejects large folios with
+	 * -EINVAL, which would SIGBUS the fault.
 	 */
-	if (is_vswap_entry(entry) || !zswap_never_enabled())
+	if (!is_vswap_entry(entry) && !zswap_never_enabled())
 		return 0;
 
 	/*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c61bb3eef62a..479814d19f50 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -173,6 +173,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	enum vswap_backing_type type;
+	int ret;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -201,11 +204,17 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return 0;
 
 	/*
-	 * THP swapin for vswap is not supported yet; reject the batch so
-	 * swap_cache_alloc_folio falls back to order 0.
+	 * For a vswap entry batch, reject if the backing is not THP-amenable
+	 * (e.g. uniformly ZSWAP, or mixed). The order-fallback loop in
+	 * swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
 	 */
-	if (is_vswap_entry(targ_entry))
-		return -EBUSY;
+	if (is_vswap_entry(targ_entry)) {
+		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+		ret = __vswap_check_backing(ci_dyn, round_down(ci_off, nr),
+					    nr, &type);
+		if (ret != nr || type == VSWAP_ZSWAP)
+			return -EBUSY;
+	}
 
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
diff --git a/mm/vswap.h b/mm/vswap.h
index 239b47b577d5..a921620f08be 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -378,6 +378,13 @@ static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
 static inline void folio_release_vswap_backing(struct folio *folio) {}
 static inline void folio_release_non_phys_swap_backing(struct folio *folio) {}
 
+static inline int __vswap_check_backing(struct swap_cluster_info_dynamic *ci_dyn,
+					unsigned int voff, int nr,
+					enum vswap_backing_type *typep)
+{
+	return 0;
+}
+
 static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn)
 {
 	return 0;
diff --git a/mm/zswap.c b/mm/zswap.c
index d0c6ce2aa092..5dc338188a29 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1630,13 +1630,19 @@ int zswap_load(struct folio *folio)
 		return -ENOENT;
 
 	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
+	 * zswap_load() does not support large folios. For non-vswap
+	 * entries this is unexpected on the swapin path: WARN and
+	 * sigbus. For vswap entries __swap_cache_add_check() has already
+	 * filtered out ZSWAP-backed THPs under the cluster lock, so the
+	 * large folio here is zero- or phys-backed; return -ENOENT so the
+	 * phys/zero IO path handles it.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (WARN_ON_ONCE(!swap_is_vswap(si))) {
+			folio_unlock(folio);
+			return -EINVAL;
+		}
+		return -ENOENT;
 	}
 
 	entry = zswap_entry_load(swp);
-- 
2.53.0-Meta


