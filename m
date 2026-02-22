Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC57AC624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D7C6B00B6; Sun, 22 Feb 2026 03:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E216B00B8; Sun, 22 Feb 2026 03:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3796B00B9; Sun, 22 Feb 2026 03:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 088E96B00B6
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAC1A16064D
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:09 +0000 (UTC)
X-FDA: 84471470538.14.BB13756
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0578480003
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cgyzok8O;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FZckDxptwGx8klYMDL0XD8dz9+dfEviXYn1CKFqg9s=;
	b=duzOKzJ1Lk8xcfIjqiTLvik8UGGbNdM3YdTb2Lsmd4q1IRXU2zYCteKBPaM10HsPxh5dZ7
	VAQIEzz+BRWTxuKcGBMT2vDaXF+lIoL/Y1mKsvWV5vQPm1QG2YsCMcoh9plSj3O3s8DXWj
	v5B2hK+6W+cCxzib0soSYxqvFc0xtcQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cgyzok8O;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750208; a=rsa-sha256;
	cv=none;
	b=syuQdihgzZw2bhFHYow0j0rUKDNHVhLGPJLeN3N6Dk++NZzUvuKLrwupRiLqiZFgnaORWD
	bJML8YqC1xnYGOvoq/vXR8vhCy7Sw5OBlhMdtMVIwGtqzfMBqITBm1Mlyf+/g428izi5mw
	NR36yOt0l2akpyWFtbwfY0xlcBifuE0=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506a1b23c05so43290681cf.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750207; x=1772355007; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6FZckDxptwGx8klYMDL0XD8dz9+dfEviXYn1CKFqg9s=;
        b=cgyzok8OCPUebb6r6czssE0DBUoaHvQhdR4J4UX0GFT5m84oZU0tzRPK+p5Y6y9uwA
         a3LXMXcfRmO+AOgxdhWIzwgvF+8aF2GSeBGq/g7SIaty3UOXeLylqgnKmuiar/CGC48X
         hqDh/AklPPhXgJOQGareAU0nW/OFSDyn7owFYeaI7zokPSz0qIDjmlqghUcgXW0MCiix
         BCxD0dAwlbkLXw0RmH5EbHpepGQkUdycRs2i8ZwEBQ+/VfIPQcZ5kY5wONKZIdb7dSsS
         ekHl29Y2YcF5/Z08yzjrZD0lGVutlT0GLWK3x94zAPv6lsC9zVpHWYpyMtt6010ZSG7S
         uJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750207; x=1772355007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6FZckDxptwGx8klYMDL0XD8dz9+dfEviXYn1CKFqg9s=;
        b=S+iX05npYrOoDpyfZqB1VQGg/IYwBGH0C+NdYOvtN5U2Hf07ljFmZgCTIPjkt1AzDl
         eW+65CapVFnfNTAp8rNDycvMkGljrADMgs8sbQwwRsSnSNrx0p3aJZFOpTChAS1hsSSS
         8eyW/2/BQg5MzU06A6AGl+I98+pYGg7Jm/hxhyE2eSif9KEEVPga4jNdRxvUsdLrxJBT
         300pWUnZfYrtW1l0Pna8Dgqp/jbN6jxYiG1ZVfFzcJoIwTQWXfNk2Tla2UIu+X+hyCZq
         vkne/sNYovx1tHlyOTmvDZUW2KPY/ciXBV27OK5MTzkqrhpaENfUZRqO0Ww9EKLzN34Y
         FlTg==
X-Forwarded-Encrypted: i=1; AJvYcCVAWnmMpQlPAfx/94CHP439vCcGfZfPMwoBPPwSnbtSUYNGGpZdl6ApOIeD6zS/eLMCYPufslwUQw==@kvack.org
X-Gm-Message-State: AOJu0Yw0PwzsatDkmJncjdPETfoxHXscDok4qXDY4mSyMyXutbraOWyq
	J3Sr8SqJfQ1mPQbUdEZ9OrPpH/S5i5D55oDcESe0QjxmHFb/PwfWgIOwTtfpAmKBmNc=
X-Gm-Gg: AZuq6aLTTN0Uq/jWTVnO+sR6e0MCTLh39PJF0VUp/4NvKxbNgPGFCrrtluNmfQJCf2r
	eX5eUD5/4uHuDnJW4OPW+eoBfaeFDUuQkpFyNh54sYTqheN0BDubWMBPomcEs+X6XLjKo0UtGtx
	+qp9MtmAcV6E37D9adnY+ukQYLCDpjUGLnOtGyFokGQ07ue1We0/JkLErd7k6T6/p2tPwV/rb+W
	LUcFzrTFErvzqhP2fqK9OH+W3kmKUEzjFcgd5KsXr9LseHr+OwJE+5DMmdwGl0csrHSKHt2lbZi
	mn7PVQMfuFuv2y9WI7vPgu/NvcrFGl9FKUH8JCJeN7qXKQIXbcfvV7o8yQeYt+PFCVdVFcs/Xgv
	lDnIJVpu5v02yVtnPJxD1B4M3m/H9j3LB/YMPATGsptfysu9ceFN8phC4sqFfFumgPa92no8/xD
	K8/HBxix08xAC2IOQYfsXOYDMIRRXqu63S0NbiFHETLqQSOiT/UE85yIzlqQBvyfcOpZaM5cSL8
	+6He+IakyDp61w=
X-Received: by 2002:a05:622a:209:b0:4ff:4a7c:da11 with SMTP id d75a77b69052e-5070bba08b0mr86322821cf.11.1771750207039;
        Sun, 22 Feb 2026 00:50:07 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:06 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 19/27] mm/compaction: NP_OPS_COMPACTION - private node compaction support
Date: Sun, 22 Feb 2026 03:48:34 -0500
Message-ID: <20260222084842.1824063-20-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0578480003
X-Rspamd-Server: rspam02
X-Stat-Signature: uhym8pdqw9bbzi6qwxasqqxuy8zog8x5
X-HE-Tag: 1771750207-772817
X-HE-Meta: U2FsdGVkX1/gZSZr3zAgNiyAxXVb8GErn0QKnquxsDS8OLMybhbK76rzA0zIcNDIdPmG61OFlNMjQUe5SCNtiCoxzbiAU4230269P/8gFctftx66uasgxVcGPvz8wpdsq/VuAp139unQPJZCvYmt39cwXoYR1mK/4jG/lx8lAuH4h+Ckr/jmX3G10VDHCEaRHapkJp6H0KjZ+CxWE1p7RP3Epa8rfcX1zPtiK2Ej6VdivZpROZsxefNzu4DSLBBQ1e8UPtZWdtFE8/BHxqwEFWeCAT/VqVn1xyD/crA7Pn6Dp8jn1pa5LMTMBdO1uimGiw7sh7Q8+fndJgd7ZvDwueAHm3qRd3F7HYod+qSp2jECFAAGxwL3Uqwuq2SocGN4+tfxIHWjVJZh5xMA9cyolXmIvcbvaKhkX5Uo2bLV2TeA1suyZqd1L1/fvOg+HPJhOB7V746jI8UbZ1qADgVTWKKKji0+Ly9ZKtQ/GGOtpmemoBGUgH1HOGt+muGvPmAT/7OuIhw9/d/lsr2s6zi01WSSMXuKaFDVIIe5tReGSNbqFg52iOekqS1FX84EbbLEXzJ9EWGJTEzTgamUj88/qciNiiVW80PI0sb5SrkrsQQxH5r1Bs1BQhtnCrkQGsgSRi2gI6VHXa/TbFCIbJGoZjk9McfJmWVvaTjCKgipH81naISE/jl/xP77oH8eP+ZyNltKFBeH3ZUDvC4TAp26dtFhhDfMCmr6OJVnvSpPkyhTEEQoQbbynD6iHwiGs9aXeJ/BTSM9lCwPg4iH/LZB1ucV+RfCLGJRTV29usLKrO+hrLBFRsIafm023ZLN0UX3hLCkUD/irJ+76dmForF02Il2Jzk6XBqqbSo24fF88t4/lpLGe45jBRdtPnZrm2oVaafb3ln6qJxJOwUtgRJihX1M6vrsSGP1F3xGdPfdEPTFUDCAPpy3e9UxhUdQIDohZd9JyBknXvRq5fRF2VH
 VnaF+B8q
 VY5YECi7EfO6jOr/WMD3keA8GMxv/kAMZEPQ2PgDKFq3TJ8EMBfjSGSfJ7r9xcwe0HYOXBpVVWK1Ni70Z0L0bdSjaEbfISK3UD4izpzcX1k2jjFKdpCx786N3Y3ls+X8Q6NNjITtqXbHA2NbPCwvQLL8wb5zQ6F2W+Ce6koVzNwUJEmDLgtvpaQZPCJeyWbyqs1SJYUEAKxd0nY9YArru5+iSueD/Y4azTOVgM0qdQ3n+y3jOF/Nf9HFblr1AYBehsWQngnMZEp2nGjhv/EVeGfZWJ/81URMG7qNCBd55cw1IGrex/0dFN3xcxKej4HGKYUBnjRPr49U779OxHpT6dM+pcKu08TidI5//B9FtUEyqhw5oxoiKA6ItOl44G0XtmzPAwtuYl0T4w1gDkGWtGrNOxMBrNN1osgaG6gHhEZ2By4A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private node zones should not be compacted unless the service explicitly
opts in - as compaction requires migration and services may have
PFN-based metadata that needs updating.

Add a folio_migrate callback which fires from migrate_folio_move() for
each relocated folio before faults are unblocked.

Add zone_supports_compaction() which returns true for normal zones and
checks NP_OPS_COMPACTION for N_MEMORY_PRIVATE zones.

Filter three direct compaction zone loops:
  - compaction_zonelist_suitable() (reclaimer eligibility)
  - try_to_compact_pages()         (direct compaction)
  - compact_node()                 (proactive/manual compaction)

kcompactd paths are intentionally unfiltered -- the service is
responsible for starting kcompactd on its node.

NP_OPS_COMPACTION requires NP_OPS_MIGRATION.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c          |  4 ++++
 include/linux/node_private.h |  2 ++
 mm/compaction.c              | 26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 88aaac45e814..da523aca18fa 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -965,6 +965,10 @@ int node_private_set_ops(int nid, const struct node_private_ops *ops)
 	    !(ops->flags & NP_OPS_MIGRATION))
 		return -EINVAL;
 
+	if ((ops->flags & NP_OPS_COMPACTION) &&
+	    !(ops->flags & NP_OPS_MIGRATION))
+		return -EINVAL;
+
 	mutex_lock(&node_private_lock);
 	np = rcu_dereference_protected(NODE_DATA(nid)->node_private,
 				       lockdep_is_held(&node_private_lock));
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 5ac60db1f044..fe0336773ddb 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -142,6 +142,8 @@ struct node_private_ops {
 #define NP_OPS_RECLAIM			BIT(4)
 /* Allow NUMA balancing to scan and migrate folios on this node */
 #define NP_OPS_NUMA_BALANCING		BIT(5)
+/* Allow compaction to run on the node.  Service must start kcompactd. */
+#define NP_OPS_COMPACTION		BIT(6)
 
 /* Private node is OOM-eligible: reclaim can run and pages can be demoted here */
 #define NP_OPS_OOM_ELIGIBLE		(NP_OPS_RECLAIM | NP_OPS_DEMOTION)
diff --git a/mm/compaction.c b/mm/compaction.c
index 6a65145b03d8..d8532b957ec6 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,9 +24,26 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include <linux/node_private.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
+
+/*
+ * Private node zones require NP_OPS_COMPACTION to opt in.  Normal zones
+ * always support compaction.
+ */
+static inline bool zone_supports_compaction(struct zone *zone)
+{
+#ifdef CONFIG_NUMA
+	if (!node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
+		return true;
+	return zone_private_flags(zone, NP_OPS_COMPACTION);
+#else
+	return true;
+#endif
+}
+
 /*
  * Fragmentation score check interval for proactive compaction purposes.
  */
@@ -2443,6 +2460,9 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 				ac->highest_zoneidx, ac->nodemask) {
 		unsigned long available;
 
+		if (!zone_supports_compaction(zone))
+			continue;
+
 		/*
 		 * Do not consider all the reclaimable memory because we do not
 		 * want to trash just for a single high order allocation which
@@ -2832,6 +2852,9 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		if (!numa_zone_alloc_allowed(alloc_flags, zone, gfp_mask))
 			continue;
 
+		if (!zone_supports_compaction(zone))
+			continue;
+
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
@@ -2906,6 +2929,9 @@ static int compact_node(pg_data_t *pgdat, bool proactive)
 		if (!populated_zone(zone))
 			continue;
 
+		if (!zone_supports_compaction(zone))
+			continue;
+
 		if (fatal_signal_pending(current))
 			return -EINTR;
 
-- 
2.53.0


