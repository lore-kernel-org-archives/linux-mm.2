Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BDD7606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLdmbU2Z
Received: by kanga.kvack.org (Postfix)
	id 5C1026B05CB; Mon, 16 Nov 2026 07:51:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5722F6B05CC; Mon, 16 Nov 2026 07:51:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439D96B05CD; Mon, 16 Nov 2026 07:51:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 245416B05CB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:51:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9AB51608DA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:51:29 +0000 (UTC)
X-FDA: 85440968298.24.8BF76E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8706180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:51:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLdmbU2Z;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAagbYd6dfyVbsnE+ND+6hIHPmL9gs+3rPo9JeiHsMQ=;
	b=ET77nTMjvkXqHVselHrl069GoRyaaQpE9c/TLP9mfc+g2PuMUAl8dI4jKdY4r5vNzXfXvC
	GcBZslbCrGcQk1y/Ik2t34u4hPJq6k1lu+XPSdQZolJDlyq58pfQI2LYehDh7SZH6uphWm
	ljeLVicTeZLiwa/cETax3dkguGuEZcY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833487;
	b=wdwhy9ANDA/rr8I34ocLULPuut85XmAJCukkHfm2QS4/I3ZLfUEsr2trLqDo/zFiQPiXmi
	KUtVTdu7s7GZzXcQtT9cUXSElWac8QogKR6iCKTL1YZeXExhrQ6KqpkG/a/CkQ3BRbGHmN
	Ht0ImcNfzx5I98iG+CzAXNoLah43FXI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLdmbU2Z;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 647CC62A12;
	Mon, 16 Nov 2026 12:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE651F000C5;
	Mon, 16 Nov 2026 12:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833487;
	bh=FAagbYd6dfyVbsnE+ND+6hIHPmL9gs+3rPo9JeiHsMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLdmbU2Z+UVFQ5P5eFC+KTD/9uZwaS30niLlDfbDUoZlP5hu0et6f3svcPbuL7rOr
	 az9nd1uq7ZC+rizT+xL5NCKiXkEnS0Pr3dbeai4qM4VPdlVWRWi78QHhhuLZ4EQX4A
	 VsIOxhCRJoSI+OTsbLJGHB0/BHYnW3ty555fMKV9i/czVGep523sf0prb7byGH03Z5
	 vQeDVqVoLMwIBxTiXhSEwTBCWtWRNRu8aWebhCh0gomtPtCiqByjdTloOm/wQ0a4uL
	 LFnS+bnZW+QZteqLaZ3+/bBuTFpI9Nn1/AAX1XGdfrMURXzUTiAZruM0IwM0563ZYX
	 sp0Q5IHxgvgdw==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id 08B801980050;
	Mon, 16 Nov 2026 07:51:20 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 16 Nov 2026 07:51:23 -0500
X-ME-Sender: <xms:SPz6apvWilaRJSGouPhH8DesEmoczVzoEM1Gqq36GxC80jAfiW9oHQ>
    <xme:SPz6ajhZgb4kg0XHQsriE8yvhGRipQPq6mdQXQQgS9X1xHf-IDGBZjfaW5qGF_V4C
    sc0yiTDpYoF3WROfn_YIZ8VS7Q1_Bj0pilmT2T_BHNzjBDjGn01XoPh>
X-ME-Received: <xmr:SPz6avshY1kZXIN1743uja3J0EBoTC0J_LbtpjbpJldAE7ggHCvTzdJw1mY>
X-ME-Proxy-Cause: dmFkZTF4rqJmiWH6IxaIGSp21Kb2Ng7z9JItazqdzGM2eHVk/wCcpFjnKvz66lSKeJiy6i
    GkGS1IphOvpdNcnGTCoD0LO8NJl9WQhzX/ydQP46jTnnlMEBX6PtiTbR8FZ2F3YYyDZsbT
    lVPwtUs9gugBiqHWV1BQEfSXkaQ0ojXXrQsPwFCXdDWi7jdNlqZKWxp0zDuBKKSuCBe+AL
    Aup75rUan66x/SXWCgRSqoJMzCwkyV23j3f/y82hcmmz+mdaaAbUUf5R45xX2f2ff0z5kb
    A7qPyHTsZy1dtOV4ZTXmHPPt0k9a9Vadifimq/dyMy7ZXKMI8hG8u8cxAfmEa2ujpQB4R8
    i3EBfjkejfwfLV5vuvL7v1mz8J1cJPa+Shj4s0H4M0fdU2wH6keUvVq/IaTv5suchxsusb
    gvXnw9s+Gwp4P78gLhTb6jiFQtHkmbGpapAPzaCiPxTc5NsF+c7oMKbQyHKnXecqNd+aVL
    NL50Q4nnRVSJCu0ubT1jy6fTBJgXxPPZfQN/5Zx3AZ0StwPJE9f8x+yaCk+SgDXaUnXaSE
    sVTrmYfPtUAQRLUJvjW8Eazcm0tPyYnC0AbTJi18Qj9Inzg8BqlOIi2sD2OJcEXhKfoM9y
    F588QlvneyWPdLCC99ZHza+GMw9BHzulyhSBU1MfpRxgRqiZC5R8FsbUkQYg
X-ME-Proxy: <xmx:SPz6at4_-29V69swvyQLWLKh-3FW_smgYEXeEx5V5j7vAXqO6Vg2jA>
    <xmx:SPz6aithVOyAccN7e7c9rIPpdsWNdZgzMf1-WAtTCNiTE1IcduVDDQ>
    <xmx:SPz6av2ZIrdOX1lOzFecYYRcqjADZW5urzDdP2DwVCdvxX4LN922cA>
    <xmx:SPz6av82FZZYrqlIHgkLHwlqpya_WO_wtR_fJxiQ0b5qpk_Tq9wUng>
    <xmx:SPz6alC247wpQ18KROO8aJi-SROfHDI6z0Ni60PEfiTLwReSS5W0vYbi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 07:51:19 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v3 3/3] mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT
Date: Mon, 16 Nov 2026 12:51:01 +0000
Message-ID: <20261116125103.2894162-4-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261116125103.2894162-1-kas@kernel.org>
References: <20261116125103.2894162-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fqsd6yuui8yeyf5r46ceofnxite8spm9
X-Rspamd-Queue-Id: C8706180007
X-Rspam-User: 
X-HE-Tag: 1794833487-359873
X-HE-Meta: U2FsdGVkX1+MrUiQ+TcIzV2KaGmnckD71O91JkK656mxvru5Xm/yGfjnTAYh/4OGDxTBHhR0DeO3mfDHn3uaTQNB93jrCV8bt9Ds5PqF15e/H+ydl+oYXsOPqf3LGJo9E5q9CimKVhXWqWS8w42vM9sZaplCOdNpiCbi/IpHudOmIIGdxMIISViA8O0Aar/pQ0SmqBmVaRYYvY9tfGJ4gwOp6Mn/iEJPjLr78Bl0OviliTdT25ALn2eULevCoxtj26TDuEO6Qj2mDBSlrkJC4G1u5MBxlIV7njbotyfXgWg8FZCkFTcW3BH/5o/jt7aYiLsMaPDUGVNUlnx1IzggY02yM/Tu+2KWJBxI3TXdH7L2LPR2bhURTcNX+dkFei4LsUd3StRmQUHxkAjkdpBdZzYERzvvJ0m80bsoxES8sQtawfEXDFWpra6OH9/TOh9B1VcQn48keH4zwU3IVmqwxQTYG+rd10QysOMyWY8p2W1oaZjK9FxbacRSHprQb3gV0iAzde6wrhpOuIw0HmhmodQXKPlZqVpZjuh2gtSeofyRnGhlZESbuI2jrCIl6lWlir31zi/Ba4TO9fO9JMO5xLFXvJASKGL+YllHR+o0p223KHGk1mew2RMC8wMy1KeK0euHD24xoEPqSidL3boGBEYDkIDXYlhQkHXpK954nzd3uLiGCrIlEUktKxGq7MmKcL2t5/kyGgUr2e8ie5nk7deXCkTy11zox+M8ELtp3whysVq4mQLMlTLOb7jf5SOxGut3XVuiS7I5NtF12emrSX483aiE7//tLPUub9p6gcucijAV7Tnl37WAIi8NSKQC4SNbo1V7UIBsxYQJMh7FObNpGWJG0HMZvw6uDzh1tps1ueiDKvkqQBtp8OEfArNoQzgKQofk9wdtGfkcSviYB8oXykf20dtNZV5AHZYHmwCf7svsNV50zox47mwYUH66zHDZZGOO+0UoF5TNFns
 IQkLdakS
 RS7XhJSIgcU1hq3YuylFkyxE3PhEA4g9gN4cH5uB9Vo9UiXh3ievxpCnfzXDVYFRrUE2uggM014XfN1dw3fLm9K2KVDB8Cs7B8MgOIKbr8PjVf8uJc+fIT6ZeCCtxzVK76nHJl4bGKRYfFKWDBWRLqBIgzdbc8q6qlqanH4N3PxH9P9O2H3tVR0tbix8omi/siEtI2z8Lj9W86bkb+ijTYc6v+9pS8nURfKg1mHt5ZvWRHl+HPhY3G6Hl3TbUPqOFzaxlem127/g0dsD7sbVQKqNkCU2LIW2UqEMx6iOetEhqkQVpOywthrJ4TSyPTwV1hLj3CPEw7HdqvAVYsUJd0tEdpwr+D7aNjy64ZnOc2Ab6EFEq1ReKDbJOBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Direct reclaim for a costly order stops as soon as the allocation could
succeed.  compaction_ready() skips a zone and should_continue_reclaim()
stops reclaiming when zone_watermark_ok() passes, and zone_watermark_ok()
accepts a free page of any migratetype.

With defrag_mode, the allocation behind the reclaim is ALLOC_NOFRAGMENT
and cannot take the free pages left in unmovable and reclaimable
pageblocks.  Reclaim stops on them anyway, having freed little.

In Dev Jain's 64K mTHP benchmark, with the high-order watermark check
already honouring ALLOC_NOFRAGMENT, an order-4 direct reclaim frees 16
pages on average with defrag_mode and 45 without.  64K faults get a bit
over half as many folios as without defrag_mode (medians of 15 runs):

                              defrag_mode=0  defrag_mode=1  defrag_mode=1
                                                            + this patch
    64K faults allocated              20750          11538         19759
    64K faults falling back to 4K       725           9945          1664

Pass the allocation's alloc_flags down to try_to_free_pages(), and
record ALLOC_NOFRAGMENT in scan_control.  Both checks then ask
__zone_watermark_ok_mt() for a free page the allocation can take, and an
order-4 direct reclaim frees 40 pages on average.

Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Reported-by: Dev Jain <dev.jain@arm.com>
Closes: https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---

try_to_free_pages() takes the whole alloc_flags, but reclaim uses only
ALLOC_NOFRAGMENT.  Using all of them would change when costly reclaim
stops for every allocation, not only with defrag_mode.  ALLOC_CMA would
count free CMA pages for movable requests, and the reserve flags would
lower the min.

Storing the whole word in scan_control and masking it would work the
same, but kswapd and memcg reclaim have no alloc_flags to put there.

So the patch stores ALLOC_NOFRAGMENT as a bit in scan_control and
reconstructs it in allocation_can_succeed().

 mm/internal.h   |  3 ++-
 mm/page_alloc.c |  7 ++++---
 mm/vmscan.c     | 24 +++++++++++++++++++-----
 3 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce48..3ef9b7036afd 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -65,7 +65,8 @@ void folio_mark_lazyfree(struct folio *folio);
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-				gfp_t gfp_mask, const nodemask_t *mask);
+				gfp_t gfp_mask, const nodemask_t *mask,
+				unsigned int alloc_flags);
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 			      int zone_idx);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e75c03b303b..93362e0f699b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4459,7 +4459,7 @@ static unsigned int check_retry_zonelist(unsigned int seq)
 
 /* Perform direct synchronous page reclaim */
 static unsigned long
-__perform_reclaim(gfp_t gfp_mask, unsigned int order,
+__perform_reclaim(gfp_t gfp_mask, unsigned int order, unsigned int alloc_flags,
 					const struct alloc_context *ac)
 {
 	unsigned int noreclaim_flag;
@@ -4473,7 +4473,7 @@ __perform_reclaim(gfp_t gfp_mask, unsigned int order,
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	progress = try_to_free_pages(ac->zonelist, order, gfp_mask,
-								ac->nodemask);
+				     ac->nodemask, alloc_flags);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
@@ -4495,7 +4495,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	int reclaim_order = ac->reclaim_compact_order;
 
 	psi_memstall_enter(&pflags);
-	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
+	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order,
+					       alloc_flags, ac);
 	if (unlikely(!(*did_some_progress)))
 		goto out;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..3fbcdcc87a00 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -142,6 +142,9 @@ struct scan_control {
 	/* One of the zones is ready for compaction */
 	unsigned int compaction_ready:1;
 
+	/* The allocation may not steal from other migratetypes' blocks */
+	unsigned int nofragment:1;
+
 	/* There is easily reclaimable cold cache in the current node */
 	unsigned int cache_trim_mode:1;
 
@@ -6316,6 +6319,17 @@ static bool in_reclaim_compaction(struct scan_control *sc)
 	return false;
 }
 
+static bool allocation_can_succeed(struct zone *zone, struct scan_control *sc,
+				   unsigned long mark)
+{
+	unsigned int alloc_flags = sc->nofragment ? ALLOC_NOFRAGMENT : 0;
+	long free_pages = zone_page_state(zone, NR_FREE_PAGES);
+	int migratetype = gfp_migratetype(sc->gfp_mask);
+
+	return __zone_watermark_ok_mt(zone, sc->order, mark, sc->reclaim_idx,
+				      alloc_flags, free_pages, migratetype);
+}
+
 /*
  * Reclaim/compaction is used for high-order allocation requests. It reclaims
  * order-0 pages before compacting the zone. should_continue_reclaim() returns
@@ -6354,8 +6368,7 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
 		unsigned long watermark = min_wmark_pages(zone);
 
 		/* Allocation can already succeed, nothing to do */
-		if (zone_watermark_ok(zone, sc->order, watermark,
-				      sc->reclaim_idx, 0))
+		if (allocation_can_succeed(zone, sc, watermark))
 			return false;
 
 		if (compaction_suitable(zone, sc->order, watermark,
@@ -6580,8 +6593,7 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 		return false;
 
 	/* Allocation can already succeed, nothing to do */
-	if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
-			      sc->reclaim_idx, 0))
+	if (allocation_can_succeed(zone, sc, min_wmark_pages(zone)))
 		return true;
 
 	/*
@@ -6965,7 +6977,8 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-				gfp_t gfp_mask, const nodemask_t *nodemask)
+				gfp_t gfp_mask, const nodemask_t *nodemask,
+				unsigned int alloc_flags)
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
@@ -6978,6 +6991,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		.may_writepage = 1,
 		.may_unmap = 1,
 		.may_swap = 1,
+		.nofragment = !!(alloc_flags & ALLOC_NOFRAGMENT),
 	};
 
 	/*
-- 
2.54.0


