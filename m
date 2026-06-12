Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 725BDCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3568D6B009B; Fri, 12 Jun 2026 15:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E17B6B009D; Fri, 12 Jun 2026 15:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095A66B009E; Fri, 12 Jun 2026 15:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDA9A6B009B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:37:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F3F88C52B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:54 +0000 (UTC)
X-FDA: 84872270868.20.1EBF6BC
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA04F1C0003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mwPKsqI7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF1YM3iIffsWq3aue3unk5VZq1rQajY4MddWtIHftpQ=;
	b=S5ZhTpr9wwP98HBQgxf/fIsbW5qw362L9dTL8ymo8K4hGIIcom5nOFafNtpYCNImwCfYfm
	7Er+lwWVST9hlwxFyTJ71weicfTfWK8xggu9qwbuBbpX3xyveoF5962aY77jSLxR0Uw421
	MYBUrBY34brB73gvH6yzAM50PHYx0gc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mwPKsqI7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293072;
	b=oLt5Jqm8qeJ7NrBeALy10c9EuSfjpPiAaJyOVP5UUQfvKznNhfyo0cIK7uFtqvy769QBkU
	k9x6AjPoQHrE4TvOvN4X20UJ7LOcUwByI1Kfndk71KLuRHbPZVcpLpaAlsndFDqFxMd45e
	avwhj24dtHACfG/10WhOjSy+wreuaqo=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-43ccd4f6f6eso1000754fac.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293072; x=1781897872; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wF1YM3iIffsWq3aue3unk5VZq1rQajY4MddWtIHftpQ=;
        b=mwPKsqI7EhaAjYEnrOVXTFrfxDczngjWuBLtZRX9Q9oTyReXJLtEqNAXGtBdXZMbUb
         xeOjDSg37NG4AnLix/SzKKUmEGkRMwJrXxrOsKgOnc6w8utncOo/2BwOU3w9ROcje6bO
         1GoGnJEFH11fOOdBTHyW8Cxs5SmaLz4RLVR6E4A6dNVqVBv77bzQxGnOvSGL8gaa2ksU
         z53JxXks3QBpaWtpLvF2GRpc1nWJZXNYh57S54va9Hr8bkhbsJZs6iusNleseD4K/Y/K
         dQXUc3z+27Zqqz7u4bs7hkC3COOSsrqsCkYz2OmdonFsAH6aPezJ+RuROiQj1EhNmMeS
         0xIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293072; x=1781897872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wF1YM3iIffsWq3aue3unk5VZq1rQajY4MddWtIHftpQ=;
        b=Ev1kMlXRpc/0wZIAMX8c6irHYvaL4HslHpjBuVcVCtuixY3gAFX89XgX+HzYtR74AO
         mAN2juuMm2ieQp3BCqDuXfPZU6yvO2e+/MTPRomu5UR1ZJCZgNTGQu9Chn4+1u0hMZB1
         E0JA4rr1BfYO6YAjvDuNr7zcOWPhJ64UKaWb50NhZaNISmmiU+JPU7h0VrIXzFw1do/U
         /8Aad4owouwZfrrQvSqy2EizCPT1BEQIgrt/olfSs2QzQWsZYDaErmNJvN58BDYwiuT1
         0cLgphhwhWQco+D3/rsaDhjxMOZzPVEKb6hZK06ijabH+vr8Wiyt+oIGwDrM9N26tItJ
         Q1Mg==
X-Forwarded-Encrypted: i=1; AFNElJ+6EdivI03Mz4OGvQ3yAFgeyfSzFo//cKUhbsat0mYupDDyDivRoniC2xP542FE+FFKYxfuFw1fyw==@kvack.org
X-Gm-Message-State: AOJu0Yz7A17gYExk/Z6V5HMC0i5wRnH/T2fVUbE5sguLfK1/mTmxpUyt
	OqTqNKhZjA3+bCcU+kK+XnBLFbacy7bLMQ4+9kQnP4mx/RMaOYt+5gK1
X-Gm-Gg: Acq92OF98gy0cxTOPqV1heInNCR5HuP43NEfudkHLX9lxNHtthulWIxylzxRq2g2/uL
	Ui4pPJTXdd2A6/TBpx5/9iQ8oslgIJofrpvDUlUy3YfVFHVQfz0p8Tqp+8zcAKFWCnD8OLyzk7q
	JwmQBjUCu0vO+0PMPvsgp/GFnosriLPOPQ7uxRjpZHx1JAyjxyBZNDBacrXVRy27kenNogI3QkY
	/WK7TVPHRnSEhZvdUPoBTLCKRzeZa4NnPno/AkuHhXWkwEBSwthswmAOHeINaQo2NeSPK4D9mlT
	g0E69dP0/tzu9t5sLdkq0AoCiihNCkUdEdEhMhjaMJRCVm57xmRFUeXbjSJ+37FPZBfs0hdHUMJ
	Qxr/5WoORFolUfn7HVEvomueJjNllqLVVZc5fG3Lpwi+JHkJIdi7TLAY/Vi1QttXt3eDKKewzkq
	R19OIYotgipulxtHxJIc5Rsh43C3Cvei5jbPUsjs9SOv3UaA==
X-Received: by 2002:a4a:ee88:0:b0:687:d4de:1f9d with SMTP id 006d021491bc7-69edc68d84cmr2637237eaf.24.1781293071874;
        Fri, 12 Jun 2026 12:37:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4426b2f8a9csm2643507fac.13.2026.06.12.12.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 12:37:51 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 6/7] mm, swap: defer memcg_table allocation on physical clusters
Date: Fri, 12 Jun 2026 12:37:37 -0700
Message-ID: <20260612193738.2183968-7-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612193738.2183968-1-nphamcs@gmail.com>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA04F1C0003
X-Stat-Signature: jspq4dxxki7rt5189kmkjj69zn677idc
X-Rspam-User: 
X-HE-Tag: 1781293072-683712
X-HE-Meta: U2FsdGVkX1+fcgcSY9mAwBLS50FLtiy2dIzKSPfsTlke//b/cJBfhnRHXZF2m1NFIG1K6t0jP/cNnE/t+uWclCm8kig6dbd8rJ8Tkd1nPPphCxyAS8WWcCo4rC6Z6BBmyDfCaGw7/ChDF4Z/O1cvY/zbrRD4wzOCsNWRWCz6D4ZGrAXJtygjEQaNVaeaJs4MZyNJP7/h3WbbSKIjICbjBkasndwdYn51jONtUnWx1SdrltZbJDf9Rrsq2utUCmGdUzDk8gMsDgYTCXKpXAY212547Wu/DHVktKPV9dXw8hyG93I3/q5mpPPm25UvRwkAyb/HKF2kus9NNHMjabwWxxT1FBNdtfInKvF2/qFSpKKInRgJXAW/mKSzcMv8xeJRmlPIVtggUxP01RdDAQtujEXJq2W3Mt1ApVKZN4vqIieqyFvLSM2eqe+niHRA7ArBsYY0uUQdDvRk9niNp9hXM6JaxHnIoGvU3DIDDrICAVzV6Vec1UpjX11DMAn/+O5Bl4oohyN0e22C7ssZOibUMVVDkdXP0wlZnkFQ6BWMccDTXZXgkSrFPtfLrLgvkCFzQVflrHT9wb2Sb8CHXCqWA+oKMjQG3xAATCkmkD+nSPnOqx3qVsv2qYkU1N0yr8LDts+VR421O5FrqFpWlvIM0P6co5Szilu0gv1xzR7f4OTrNPbELORbolK95B5ZgkLBX18DnCrWks+KX/swwAH4mmLIziR3WCxgYwa1V2p8Fi9CyxAVgLDCsIEPQgkIs6mmzHuOY/QqoM51GPd6dhxa5GvJdEtKKxn4+vZxtO7WRNVxSKD7UiH9d33NQN2m/dJaO/OQi4uSBpml5LAsM8OlIA/oXt6xrekcOpSZb+zS+/Rkx+QrvRK64z4pDMlBIZWuCvfHBT0yAz3Sr1VnWkYG+Ud1D0w/8seGJuBoNCjWd/o9ITtcFmbTvd6sSxEi3EaytUoGJCuXogyuK2L/U4J
 XJpwrgYk
 t13IICCkMx3wKxR//zAZrGyM0y6Ut6vjsJxkfRb98n3SawudG2jrFHjWKj8dIVYVlMGgVJhlG1zE/I/pqGRP2WAtFQOVE5TdpQElpmEu1Dj1x+ffzo/Y9sOvDGaRTtTQRE5mDpmBnp9TyqS1kjLsAaGxAubCPw+bHquFQoVkynj5/5LlUEXeXivUGOCCsAhiMrIPufK50kdqGJybCxNng1MKyf7uFd8hK4htLQmnFshVWNY4x4K2Y9b7ipvs6CQD7DGssq0yPu8/OnDkXTgOjRYPajU/wAnkEYmjzws6kr9yiSqq17ReqU/J7ARFzpKcqyhkbl0uxQy0UsbQGHFmM9jv3ilmeii8EpIK/eKwl6qqKG5yiwS9xUQZ7M2mIkgEoalBFxUsC18fgcDDHGNmE7Txc9hu/79BBw1iCvx4O+yXANiAuba45MECKBIbvRk4BU53XuuFJL1y3XIi3yq4R0tPviBp/JP2Zww5q6lie7lcvtAZfpWUXkthBbb6aQ2JuQBUt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Physical swap clusters whose slots only serve as Pointer-tagged
vswap backings never have their memcg_table read or written.
Vswap-layer memcg charging records on the VSWAP cluster's table,
not the physical cluster's. Allocating memcg_table eagerly for
such clusters wastes SWAPFILE_CLUSTER * sizeof(unsigned short)
bytes per cluster, which adds up on vswap-heavy workloads where
zswap writeback is the only consumer of physical swap.

Allocate eagerly only when the cluster is known to need a memcg
table: any cluster in a !CONFIG_VSWAP build (all slots are direct
use), or any vswap cluster (every vswap allocation records memcg).
For physical clusters in CONFIG_VSWAP builds, defer the allocation
to alloc_swap_scan_cluster, which lazy-allocates on the first
direct-use slot and skips entirely when the cluster only holds
Pointer-tagged vswap backings (folio in swap cache).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index afb118ab8179..0d48240de345 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -493,7 +493,8 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		 swap_cluster_free_table_folio_rcu_cb);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
@@ -516,7 +517,16 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
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
@@ -590,8 +600,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN))
 		return ci;
 
 	/*
@@ -609,8 +619,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 	if (!swap_is_vswap(si))
 		local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					       GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -883,7 +893,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+	if (!ci->count && swap_cluster_alloc_table(si, ci, GFP_KERNEL))
 		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
@@ -1175,6 +1185,28 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
+#ifdef CONFIG_MEMCG
+		/*
+		 * Physical cluster in a CONFIG_VSWAP build: lazy alloc
+		 * memcg_table on the first direct-use slot. Checked here
+		 * (not above the loop) because cluster_reclaim_range may
+		 * have dropped ci->lock and a concurrent vswap-backing
+		 * alloc could have freed and re-populated the cluster
+		 * without the lazy alloc firing (that path has
+		 * folio_test_swapcache(folio) true and skips it). For
+		 * vswap-backing allocs here, the lazy alloc is also
+		 * skipped because vswap-backing slots never touch
+		 * memcg_table on the physical cluster.
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
@@ -1241,7 +1273,7 @@ static unsigned int alloc_swap_scan_dynamic(struct swap_info_struct *si,
 	spin_lock_init(&ci_dyn->ci.lock);
 	INIT_LIST_HEAD(&ci_dyn->ci.list);
 
-	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC)) {
+	if (swap_cluster_alloc_table(si, &ci_dyn->ci, GFP_ATOMIC)) {
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
-- 
2.53.0-Meta


