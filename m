Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF81C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 752946B009F; Thu,  6 Aug 2026 14:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729A16B00A0; Thu,  6 Aug 2026 14:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6417F6B00A1; Thu,  6 Aug 2026 14:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE136B009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:43:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C513D1401B3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:14 +0000 (UTC)
X-FDA: 85071717108.20.7ABD2B2
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 15C1D180012
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qn1iXOiz;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786041793;
	b=qHnsxGSByTtu/zuyKgUbiQClQqPlppZX3KqYuECg/xtmiCEndO0JNC/CtBRzgnylxARg26
	nL6lU+ifdTVgiUqe6Socv1zC/2zDbK7vSaKAOyhFlICoY6nmSjoci4yIGDwqhrDGQa8igG
	QN7TrYfErcoz1OuDEqHsyZdu/7KX3ds=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qn1iXOiz;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786041793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6q7yoTOhS8xVdFoqcdm5Nyx0rOXnYxJmiHBoOvthnIM=;
	b=XRU5uTclic6EWibYfsqzCxaKb+0Vt8S+A4dsdNay0CsZwebhLGloFjDNqcBTtrUANN3Hfg
	G0nWWiFTa9F5nRHj8s1RCBbaDY0XOfIaMZGmjmhCoNMWKlIa7C90BJNbTiQSSOx/5pdsMC
	0v+RS0VAqQcMPUKnTaiXQSIVh742xL0=
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6aea94f96c4so1023427eaf.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041792; x=1786646592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6q7yoTOhS8xVdFoqcdm5Nyx0rOXnYxJmiHBoOvthnIM=;
        b=qn1iXOizfkZBbCrEZDEX+OHIkW3thYBHRpcdmU6/31ekuD8/dbbxFnF5dyHjLk4E0q
         SLp/ZzQsZRRCVetbUkcYjzHMNYeIcn4dI0gV9vSn3Nf3DPEPMU9osQrte519EKCC05aN
         IEaUXukXC0mjKYU9LxC4NTKevD1xRzSDmn9lKMABnRAjw0FuBO+QL4F2uuLd2uO4xzJE
         tnFzTWaTw92zSGQ4b8uYigh1B2GbaJVqOYFlBY8g5qBi/DkNZs68Wrg1R+xTr3bv5GqA
         GZD6dxBP5RXnTgbgLXUbssQuz5QpeiNoSbJG+1tiaq3ItW8PLWQmLQz1xxNW36xIYHJ/
         UPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041792; x=1786646592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6q7yoTOhS8xVdFoqcdm5Nyx0rOXnYxJmiHBoOvthnIM=;
        b=OBc6DshQL0nLeXSwgOjE6anSYNxmUSEpqYA0tuabHFDioQF3deyu6TRQQvA1p9bbqe
         umo2pchqi4Jyq/khX3JICPXbFPxFJ4NJt2Q4Fs2qnf78m1lRcxzCr5hyGtQdiWJsb8rM
         jU12G3X1wMDzLIHpPNoWilo9WcKOO18s1fQwkPeTXdqZBnMqc4zRaVy4TDCQQa2KiyhW
         kXkljC1+xbuicIQJjeMBFJ7ZubMpqCcdn4X3usO+zAvG0yO0a6QWdPsu9pAHlsbNRrGg
         eqTNM113YWMs1xfbMaDQ69wnOIQJILpMpEgfBb2++LhqkOm9AYNepDAqNsuQzWToBZq2
         7qnQ==
X-Forwarded-Encrypted: i=1; AHgh+RraOJF+u6uT7dL9+QVPKSvHCQPRTMvLypuFi8q9vGG5b5cV5jtkVqgta1SpORmuACtn3VOiUFj1EA==@kvack.org
X-Gm-Message-State: AOJu0YxnK5IF9DD5DLmSXqHJ86P54uVaRXJOu/SHW9fzR+95aw9P5RpB
	n3sOjDscPU6t0MKxDj/3YzZoL//lTpvtOWNhcPBPcNssRS/6QJpVU13G
X-Gm-Gg: AR+sD11eoD7mfLBhqhkEjpP3ElNOxMiUd6re7YZyD7JffGBodbE6cA2j7wLvqHYzA00
	oZmcAZBBzzNXk4KQMhZx3C0rGJ+3t2ikU6aSDzHQLqkfYI09gRXMjRELgvp+QDtWXa1g+x6quxe
	JtF1SuWWN+nNDB0KAl77zM3PESh7iZH+8aTHXnxlAuwY9dYXxddNolkZRwYHEWDSx0s60PIC79X
	NERPxiCnLqneIWwMxb/6xtiGRhVulm9IVXXCvkJ142BYF098M27Yeu873IQPqyq/zXyOqgj2y67
	ACV38t+69vEMPeifGLpYwYxRwN+oT4nKjtjB0WkL6LrQD85rY5KfYXqlzPkjbX1sR0rM8cW19e5
	7a1Sg9yYKW7+DfqbKcluzquKKd25QAX1+MXuAyBfvGfnveMJtrtfrDtB2Jmsby6nxpiPeWfiqvy
	QdYirnvJ8jjGSyUbJ+uby0xPFKroM4hxlKW3shIBSiU29GgMdaS0Dq3MsgoycAzvjSUvouBty2Z
	5tOHhGIJOPKtRLxng==
X-Received: by 2002:a05:6820:c8b:b0:6ac:8e23:3078 with SMTP id 006d021491bc7-6ae96c10021mr8748486eaf.5.1786041791947;
        Thu, 06 Aug 2026 11:43:11 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bc2631esm203436eaf.4.2026.08.06.11.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:11 -0700 (PDT)
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
Subject: [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical swap clusters
Date: Thu,  6 Aug 2026 11:42:53 -0700
Message-ID: <20260806184254.3790858-11-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 15C1D180012
X-Stat-Signature: bq3h7bttzxtufpauqtbdjhz61di5bkw7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786041792-24907
X-HE-Meta: U2FsdGVkX18VNNl/sUWZrm5w2LklEzDfln3RJFtmY/wUXIlNx7L1/PAlUUH07p5gMOZsUva+sMQB0hOQrVJQpm5MPrIqbbLBEsR5AITBwXsOVaMCzWBDDzqDhC64xQMyelwk19R6HDpQ4+OPBHp4t7X6jYlCsWX849Ex173Wkkv0paP7wn2N6A1lY2v9Iy/tsejsEP7m4kMzVXi8qhTLRsdEwUyUYx5OtxC3VSixq3oCsmn8zyFNcVKpe1ICy5BrDcoGS3b2l2L3D/EqGlFIWTmytS2yg/WZIsNx+wQCto9Ho03AEMLwBbBMqaic/mURuxN3EwDFms8JE2EVknHVY9fk4y6h6AaIHcejgAaL6vAFzJeTYb0lE2HshyNU4/enV5TIKotY5vVxl5yz1ygsxoGel/JlCoNAJJWL+D9DGrSI0DCig5RTyS/xhmBghNzG+RSmIWOrGDKzpj+2wBSJ/AggpJcJIlNkTFXeUnsuNGGBVzsBrKJ2l0KOdj0WbVr9J/3SvfZsZr3Jb0sWxeDE37Mv38vOXbR89xUIjQzDGbgd+/E30pOSKWA1qorSN3mu+26r5egmFe68WOo2nC3+hbwz64UQQtU5MP/1qbHoNM1rHf4hq1HXZTVyoI5R9BMBAPb3sBPnipGxY1Vg79+x66WsxdfcgsxkPHRceDo3Hzzanoj4r8RxKhak2VeLXl3cr+9AcGpoP60xXLwkOui0Nl2CGNPyqE0YHkRZxE3drNq0eU0w5/RPLnPDj3RdGYuyX4chbYi5FmvaNrUgdL8s+keLFLD5OTlFOdHmyeECL5VTTlc+cYHmyubf5xt9nrXBfuZKzhi0ThiftRXq194nbo91ie+BQzl9r371slhRW3wllHwQ+V8Iwp4Pc5uJeRinU9QJzWZjhqBRv70R5kE4HY7PLkuHy/Gkgs9rXVmXQkhTsh6SuQ+PUBFe5PcdMVv6pEU1GP4oAbssgVJtwfS
 4lZANN6r
 UDYQm52SpiYjaI5zaMjyCzBhCksiQxvdQrKczUOtMrbSub3PVryEWfEzuAi5Jo/y3nMsK2jlN/hGxkS7wDIfeGAGTqq5p2WjU0PsNN8SnTS5a6Wa1vm1FxS61kjeLhtfsWKaZuWu+MWo0fJcPo9/fvPcZPPHGn7woy7an2kfnjiUriRcnXN4zENd7PvUC0ZsJ3nheDnPxSXw4G/Dwm25CYbDCGukQeMN4SpyrWTfv3z7MuoRo+fxSR8i63YS9VtUdNUXrkTS0AN9e65doGX+MHtL4nkJxl+PIF0NbwamPx5D8/XWBKSUVplDn0RaZFEKY1STqjhoaauXvYCGgjHAyJ+Vo/biYMLj6l4a0U6/BVReUbd+2i9LniS0mrDDOjz8XV6DKiZuG1JD4ypx+99F4/lcaws89IQWUdQDhv97loa5/7lYXfP6jWM0Kj305rmpT9SWHBRnbEasqJ2N4lY2p1cb1HkjM2rmPjTBzdPTAsFzERhsGZO0d1fQPoaoCJfwOuhwit0vX2aG57W0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop allocating a memcg table for every physical swap cluster that only
ever holds vswap backings. The table costs SWAPFILE_CLUSTER *
sizeof(unsigned short) per cluster, 1 KB per 2 MB of swap on a 64-bit
kernel with 4 KB pages. On a vswap-heavy workload, where zswap writeback
is the only consumer of physical swap, that is the common case.

Such clusters never have their memcg_table read or written: vswap-layer
charging records on the vswap cluster's table, not the physical one.

Allocate eagerly only when the cluster is known to need a table: any
cluster in a !CONFIG_VSWAP build, or any vswap cluster. For physical
clusters in CONFIG_VSWAP builds, defer to alloc_swap_scan_cluster(),
which allocates on the first direct-use slot and skips entirely when the
cluster only holds pointer-tagged vswap backings.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b4d7af21ca1c..65559647eeb4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -492,7 +492,8 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		 swap_cluster_free_table_folio_rcu_cb);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
@@ -515,7 +516,16 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	rcu_assign_pointer(ci->table, table);
 
 #ifdef CONFIG_MEMCG
-	if (!mem_cgroup_disabled()) {
+	/*
+	 * Allocate memcg_table eagerly only when we know it will be used:
+	 * any cluster in a !CONFIG_VSWAP build (all slots are direct use),
+	 * or any vswap cluster (every vswap alloc records memcg). Physical
+	 * clusters in a CONFIG_VSWAP build defer to alloc_swap_scan_cluster,
+	 * which allocates on the first direct-use slot and skips entirely
+	 * when the cluster only holds Pointer-tagged vswap backings.
+	 */
+	if ((!IS_ENABLED(CONFIG_VSWAP) || swap_is_vswap(si)) &&
+	    !mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
 		if (!ci->memcg_table) {
@@ -589,8 +599,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN))
 		return ci;
 
 	/*
@@ -608,8 +618,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 	if (!swap_is_vswap(si))
 		local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					       GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -911,7 +921,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+	if (!ci->count && swap_cluster_alloc_table(si, ci, GFP_KERNEL))
 		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
@@ -1193,6 +1203,20 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
+#ifdef CONFIG_MEMCG
+		/*
+		 * Lazy-allocate memcg_table on the first direct-use slot of a
+		 * physical cluster.
+		 */
+		if (IS_ENABLED(CONFIG_VSWAP) && folio &&
+		    !folio_test_swapcache(folio) && !mem_cgroup_disabled() &&
+		    !ci->memcg_table) {
+			ci->memcg_table = kzalloc_obj(*ci->memcg_table,
+						      GFP_ATOMIC | __GFP_NOWARN);
+			if (!ci->memcg_table)
+				goto out;
+		}
+#endif
 		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER))
 			break;
 		found = offset;
@@ -1259,7 +1283,7 @@ static unsigned int alloc_swap_scan_dynamic(struct swap_info_struct *si,
 	spin_lock_init(&ci_dyn->ci.lock);
 	INIT_LIST_HEAD(&ci_dyn->ci.list);
 
-	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC)) {
+	if (swap_cluster_alloc_table(si, &ci_dyn->ci, GFP_ATOMIC)) {
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
-- 
2.53.0-Meta


