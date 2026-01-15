Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85456D41169
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65756B0095; Thu, 15 Jan 2026 05:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB8B6B0096; Thu, 15 Jan 2026 05:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE526B0098; Thu, 15 Jan 2026 05:42:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0A116B0095
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:42:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 667ADB7C20
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:42:21 +0000 (UTC)
X-FDA: 84333858882.27.D08DCA0
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5698616000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:42:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wjil01Sl;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768473739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35UwOuLDsnd+wCybJPYIumYnuCDYEBE4kSwMd4EKtLc=;
	b=qkeNSsFI+T9EvMluz5qK59U/GXDeXUp8Vj2dtXDwwqwI9MU6F/t/jaRCLk2XrvgmnenPTG
	ML1w9jbesPi9xmbE+J4b1uSxtovkPVTErz3cFLKja7z+D0Ju6FmtZcXFETN1LMOCvJUc0E
	dahy4wUSRquQN8wEK5DOn0SFuGLgO0w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wjil01Sl;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768473739; a=rsa-sha256;
	cv=none;
	b=Cu61te8hUGbmBVEK2mPzWcXICtWxOpsGP6s9vpwZQrGeh+1igpy264sp21EcPqssGQb8qe
	8XtcsYCUi1vxDETyKWTu4/JiV4VU0zZ3gmJ21RwWDDI6UJZUEDz769QoI+6rji+Gd8Ix1n
	6BUjnJWYEj0frpTN+MG4ktYgXH2EBc8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768473736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=35UwOuLDsnd+wCybJPYIumYnuCDYEBE4kSwMd4EKtLc=;
	b=Wjil01SlR/oO7ddWVF49DyCoOjfKHh07SUGNGDI5HCIsrjvSeoqifmv9AxWbx4+r/9Accg
	xm/7eIh6IpHq1vGFGhm+D736fbxhaDbjIzkk4sdm67r6ezQZNKn6v6uQFw4duXQqns8ZX+
	5kRtoV8q19bi9FkiFYCz+UndmsiMrCc=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix lruvec_stats->state_local reparenting
Date: Thu, 15 Jan 2026 18:41:38 +0800
Message-ID: <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
In-Reply-To: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5698616000C
X-Stat-Signature: ocbsr55m4mqkzutio9omdryk85kyojiy
X-HE-Tag: 1768473739-987669
X-HE-Meta: U2FsdGVkX1+Ldw3XLJKtgxwits0bsvEHuwIiW09LBnPSxHfn7qfH2A1wbkYxs9BeGDZI7QkYKTw5u+ci43QaRvINdqBi4mhkHOKbYktJjSUkZcH4gjNWMeN+4wt+CET5UO1HcIJzfpTIv42vfjkvck4vdz3K3Z9oqx2Q6OJf6xdTX622ytEH2W6MexRS8H3gha4a9ZiC8J2x2/qwUFYzF5MZV1td1p04vMPi5vI/8OyhBprMB9w6j291RjjXCLTA66rBAlqE7CMmO8Jrd3oesiB7tTbHj1M1d5H41estH64LWoOx1kuetbbGBAfVln0kKtSOlIJQ70Xg4fNx30JMPiCRGSMCJ1mAdt2nVPTXpiZxUcCb7g0GjGciR4sGAbWGUle2GLgFK4TBz0ut9e9VU4KKv8KTWUXYq18RmfHoZEa6vJ6H6mfl7XJ0+42ISxwMwgp1Ujn0VTw9lYv6XYQW5WD+5V+9x7T962wu9Tlv8gEfLtgD3UG/MHVjIxAO4rs2L9ACzJtS4KN0D2J1uolqg6lrOTmaMrJPVikr43d2p8JuRGlJ5xOUsCn7GlSistaNw54jGZoLU4yP2MHlZoiYsncyCiNxZqrT6S+czw5k9b/f69IzNpLVMGsxCPxxPzTbN4EkpBfpNkJp6qlrnm4RRA1AOlJq3jQUJ6EG4U8jmMgnySOuvyfhJTNz30HLsWKrRPmXXiYVeAR5k8RjJn27QzkMV5xOZCDZfQ6m0Hev4vtb43Ec0P4iySU1pzo/DBg/3ztPb9B4E8aPqcFBi2mq3HXX5K7Kz/dyecIWX9mO3HapZPsZMbp6ZEahKi7a9EWTzMA0niQWGGsoncp5r/h1hJ/hb6gl+KYkQMMHP/m1bzYHRDXlPTYZ9s9Up8nZTE0dIf7YTNR5ZcmwcVQEkyZjIyQjT2bbv3GgPsdNiKYB5duz2Is3Drm+sMs/4svO6ybCNEcBwYdomOWpLJgttrK
 oaUiw4vq
 8gR8tjZO4SvHAMkUl/HnLUabcqe1QzLXl2D5v7Nel1vq9KZxmK1NoLslLFOkt/M+w+zt1WHfgvx5cUkhMOB+C4Pxp6W/nxnY6bx0S6kVU8I0968qIC3EBmXhH0DSfH42vn+k+UyEz6Bx+MITjRkSzbWfxdeLH798fJIwm2NATC70Hp7ENYffhUMyv5hqwcQXw68GlPyHq11cPdfma5DQ6gp9J+s9NyKsNP9czqHNC3c29rGrptQ6QkoQDlpCWoossycJXEtMIRTnRHeM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h |  2 --
 mm/memcontrol-v1.c         |  8 --------
 mm/memcontrol-v1.h         |  5 ++++-
 mm/memcontrol.c            | 19 ++++++++-----------
 4 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1fe554eec1e25..e0b84b109b7ac 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -944,8 +944,6 @@ bool memcg_vm_event_item_valid(enum vm_event_item idx);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 03b924920d6a5..daf9bad8c45ea 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1909,14 +1909,6 @@ void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *pa
 		reparent_memcg_state_local(memcg, parent, memcg1_stats[i]);
 }
 
-void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
-		reparent_memcg_lruvec_state_local(memcg, parent, memcg1_stats[i]);
-}
-
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	unsigned long memory, memsw;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 45528195d3578..5b1188f3d4173 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -75,7 +75,6 @@ void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
-void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
@@ -116,6 +115,10 @@ static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
 
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
+static inline void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+}
+
 static inline void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages) {}
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg) { return false; }
 static inline bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7333a37830051..b7b35143d4d2d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -225,13 +225,13 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
 	return objcg;
 }
 
-#ifdef CONFIG_MEMCG_V1
+static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+					      struct mem_cgroup *parent, int idx);
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
 
 static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
+	int i;
 
 	synchronize_rcu();
 
@@ -239,13 +239,10 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
 
 	/* The following counts are all non-hierarchical and need to be reparented. */
 	reparent_memcg1_state_local(memcg, parent);
-	reparent_memcg1_lruvec_state_local(memcg, parent);
-}
-#else
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, i);
 }
-#endif
 
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
@@ -510,8 +507,8 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx)
+static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+					      struct mem_cgroup *parent, int idx)
 {
 	int i = memcg_stats_index(idx);
 	int nid;
-- 
2.20.1


