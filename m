Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46458C79F89
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 03:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33D66B0095; Fri,  4 Sep 2026 23:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B9C6B0096; Fri,  4 Sep 2026 23:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA706B0098; Fri,  4 Sep 2026 23:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6666B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:05:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8DC4A0265
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:47 +0000 (UTC)
X-FDA: 85178218734.04.1160F6E
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	by imf24.hostedemail.com (Postfix) with ESMTP id 081E8180005
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yql80JcS;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788577546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckvjwWkqqxs5l/dJB6Wmb/ksXBEepnmWOOLp2T7wDhM=;
	b=eyUDEVktxZqsaZu+hgH7lYLXZ0Nm/6bKk/14ZfXI9x+nNqbfaFT8mPzId0YvPACvwqrAP4
	g9km1x2OjH962UfcJsBDPYUJPwg5PMkXQI90OyC7VmDcHLq4c9FbCEkcrviZvi1Tenq3JQ
	HXCPdMnmwJm1oHJpyQ/PbhPt4ltUx9I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yql80JcS;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788577546;
	b=xh4E65cJgTPlpZ4hnsRz/NyDLltZYhgWd9OGzXpNRdztciXDp9bOzIVmvladVAhOQWhR+Z
	eD51yy+ylH08Dni38/p1/m53NW7VDSGzN1sMirsWTxs6N/I8i6w//dhMh0HoxTpNa/64j7
	ntWpLmxcjZf9DBF6MiFGgP7PM2SJya4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DhoeiXFp7UyoSRxvvEzH1+kOUdYsRS2oS9Jn9zavQlk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577544; v=1; x=1789182344;
 b=Yql80JcSu02o0RCt4JLOLCs8wE+G4nIh0vSz84qwOwMxZ34VFcmPmb3dTFVIdefKdWQl5TnG
 RVj6URvSfwVQf7/hjowyk4xVaFC/aoAvO+JOiHFFjBuZ4T9xDtmt0qygmjUlWm9IOYmrXM0ecxH
 YcoDIQqR1JopgQtbUDFn94d8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2febea93e74d4996;
	Sat, 05 Sep 2026 03:05:44 +0000
X-Mizu-Trace-ID: 2febea93e74d4996
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] memcg: group the cold fields of struct mem_cgroup
Date: Fri,  4 Sep 2026 20:05:20 -0700
Message-ID: <20260905030522.1887837-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 35mik6nxuko64ai3z3enh317ap3nmwio
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 081E8180005
X-Rspam-User: 
X-HE-Tag: 1788577545-536302
X-HE-Meta: U2FsdGVkX1+68lExkwWWaQBP4BnwdJWCzS1AZZqVzb5lhO6rUzqYkoN0qotViWzuqDqMTfpZGZa0CzmkMaKxrqFpe6SoJmCs6V6TgdbSZdF0SUCk3AYx3c8HQIhNJHFZK7F6dDLkOUc+Tx1Eaa9qykjzwsrOqfnOdTdl9PA/9M0nxcOrfTyryMjZkXg/g+QT5iDHY3nh+JGF2c5MphaUMV9GLSmuJnLAeqsQb8Irsg1j/DyfLpcser/dPQG4Cwgp4W51LujE4ehkLajMnybXScjgm8o3oa0kGevdjpfhfZqKmJjrhZuPl7gIJx9VYe5Bca4uYI6Eo77u6fOZR6ghdhq4NFbMthUFq2b3CMrPHpVhNOA1VZwg1uuYvIVfiwe3RLO+f0i+iBHEBuDnT68pMshovWDU5eBLBQDcMHB/XB68LUr1Y0Yyi0ClHTr3lb6tw2jI774Npj4q7qmTVEh6ZeWJAzU9Vb2CbP8MJ98BGnu1ffacKHDY669iCdyE1yOokxoF2XnhE3gxEh+5K7R74jPuz2h6XtD4r+Cd5FyiwOizUcTr9ad/qWVlzrTKXezFgytXHgxcumvqcRXvHH2fdIge00ETQsvf5vVFTiV/BKbV2FonFrv2FdcM42RY64qbOUewV+rYG+mpfxtKo7mOq59jNvOPlGoCFHf6SRcsZzUdDrT+U+w4EAVeN6A6iNOwmaasTIgeYWCsKWzUFtzMOBFKV3RnwLGLhC1tlrSTb8ScGelB+vLljad0pD5GMUhX0AsidcugYWMsvIfgt6rqv7r9TBVOe71Hs73DpOvPU4zbbN7v4QvekKo1zjROm+AQiHBL443/GvMNnM282yOuBmwxCSejDjG04zJFMGE9okq3auXU1XERysxCZBuDtdtqlUmeorW2vR3RsRn3WWz2FWmErZQyzr/sxz8wSvAE4VZHAlzUlPXhnf3Wdn3oKVE29k2I3TTa+G2A9tyzM32
 WZDz2YlV
 erm3XW9lpRL4g5MsTbHzzjDRmCJl8OqrqH9lJA++3oXUGewG0CYzJ/aYUNApMSE/Yr7rC5E5p4tIUIKPThzQnYvJBtt7ZUWVeIKTG7493MZb3KHaLHxnE/l54DVuERjsUM6C3q4BjPgHyrzMRswWW3GX++EjSvobc/zldyReyv8Ir5nnN+OMZ0huEgr6q4ZdtrXhhbdzCNQ4xbUuh5T9zgstArBtb4DgRgiI8ckZFIZNCEplmt2kyAiPtTiJGcuadSmd64a0m7Wa9OXCN80RtMCALeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These fields are only touched by the cgroup control paths:

  memory_peaks, swap_peaks, peaks_lock   memory.peak open/read/release
  events_file, events_local_file,
  swap_events_file                       cgroup_file_notify()
  cgwb_list, cgwb_domain, cgwb_frn       writeback setup and the
                                         foreign dirty slow path
  mm_list                                MGLRU mm list

They sit in the middle of the struct today. The three cgroup_file
members alone are 192 bytes of notify state next to the vmstats
pointer. Put them in one cache line group.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 49 ++++++++++++++++++++++----------------
 mm/memcontrol.c            | 25 +++++++++++++++++++
 2 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 32b77ec5ba98..635929a1f13b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -228,11 +228,37 @@ struct mem_cgroup {
 
 	__cacheline_group_end_aligned(memcg_write_hot);
 
+	/*
+	 * Off the charge and fault paths.  Not write free: cgwb_domain is
+	 * written on every writeout completion and mm_list on fork, exit and
+	 * MGLRU aging.  They are grouped here so those writes cannot land on
+	 * a line that the fast paths read.
+	 */
+	__cacheline_group_begin_aligned(memcg_cold);
 	/* registered local peak watchers */
 	struct list_head memory_peaks;
 	struct list_head swap_peaks;
 	spinlock_t	 peaks_lock;
 
+	/* memory.events and memory.events.local */
+	struct cgroup_file events_file;
+	struct cgroup_file events_local_file;
+
+	/* handle for "memory.swap.events" */
+	struct cgroup_file swap_events_file;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+	struct list_head cgwb_list;
+	struct wb_domain cgwb_domain;
+	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+#endif
+
+#ifdef CONFIG_LRU_GEN_WALKS_MMU
+	/* per-memcg mm_struct list */
+	struct lru_gen_mm_list mm_list;
+#endif
+	__cacheline_group_end_aligned(memcg_cold);
+
 #ifdef CONFIG_ZSWAP
 	unsigned long zswap_max;
 
@@ -248,37 +274,18 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
-	/* memory.events and memory.events.local */
-	struct cgroup_file events_file;
-	struct cgroup_file events_local_file;
-
-	/* handle for "memory.swap.events" */
-	struct cgroup_file swap_events_file;
-
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
 
 	int kmemcg_id;
 
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct list_head cgwb_list;
-#endif
-
 	/* Keep the hot per-CPU stats pointer away from memory event counters. */
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu
 		____cacheline_aligned_in_smp;
 
-#ifdef CONFIG_CGROUP_WRITEBACK
-	struct wb_domain cgwb_domain;
-	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
-#endif
-
-#ifdef CONFIG_LRU_GEN_WALKS_MMU
-	/* per-memcg mm_struct list */
-	struct lru_gen_mm_list mm_list;
-#endif
-
 #ifdef CONFIG_MEMCG_V1
+	/* v1 only. Not grouped: v1 is legacy, sorting it is not worth it. */
+
 	/* Legacy consumer-oriented counters */
 	struct page_counter kmem;		/* v1 only */
 	struct page_counter tcpmem;		/* v1 only */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e209dedeb4f..b2cc82c936ed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5754,6 +5754,31 @@ static void __init memcg_struct_check(void)
 				      high_irq_work);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      high_work);
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      memory_peaks);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      swap_peaks);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      peaks_lock);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      events_file);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      events_local_file);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      swap_events_file);
+#ifdef CONFIG_CGROUP_WRITEBACK
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_list);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_domain);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      cgwb_frn);
+#endif
+#ifdef CONFIG_LRU_GEN_WALKS_MMU
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
+				      mm_list);
+#endif
 }
 
 int __init mem_cgroup_init(void)
-- 
2.53.0-Meta


