Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696D6C624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB886B00B0; Sun, 22 Feb 2026 03:49:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80936B00B2; Sun, 22 Feb 2026 03:49:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76106B00B3; Sun, 22 Feb 2026 03:49:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3E7A6B00B0
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6470A13B4F8
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:58 +0000 (UTC)
X-FDA: 84471470076.07.C1D4BA3
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 997148000B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Mg4TzlSg;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750196; a=rsa-sha256;
	cv=none;
	b=PIlxMEcPbT08penuObKcZ5/pGDCT3HA2K3BHfEC0E4rVVS+eU7IY9oJdhQEI/uOUL989np
	X3Mwni45idfNVF3b6DlfOfmopRPxLeMq100VzOlLJFIOxN3qs3olAzzpxfdFymauTDQKyk
	G/1itFXLKj/TBMeu/D81oAR+2DQU2uw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Mg4TzlSg;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usXNzPjhzvXJyzCooKRQ50P2LfA8iFR+qYeKDTB2vCk=;
	b=Zflfjei+2l/gnn54Jg0h0iRjRQr121keiHbNqEPr6ZfNJGNFW+AMSzcY51WPWbab0UCrQw
	HfaJbkTg1Ht/njNMlLdwiyvWcS3ER+Jtfa5t1gf5fXO6FZfouGCJdJOtruU3MWNTHBlVqg
	Exv8Aju4t8UTw1bcnGOyHqz7YusIGuU=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cb40149037so380338285a.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750196; x=1772354996; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usXNzPjhzvXJyzCooKRQ50P2LfA8iFR+qYeKDTB2vCk=;
        b=Mg4TzlSg8KWroColuCqnMZfQAOaClfQnzwYQOiFKbFwjUYjJGSu0Kcs1//qRLdtZWC
         Il82eMR93BUNWW2u8sZy9dcUs6BnDIHoKSSUmsApyIYjdSQ6Ivc9VIJweG1MagtXGUdw
         fW8m98B8sWw449DBGMlIOPOdTP90KuHqemCNzh0PUzZzMMIuZudPX7qZ2WuZy9QBERWB
         h0W/Cx2EYf+6FUTdSe42iRX27WGIJpGhVOz+ixSrceP5xu+EkGixEuwHnF7Yu6ej7hgG
         +xekOYLdmhxv0HlDGQOseNKC9v1GTDD2D0tKXKcjrKwTYch4s6fkwxuxIClNcQSyUoLD
         tXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750196; x=1772354996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=usXNzPjhzvXJyzCooKRQ50P2LfA8iFR+qYeKDTB2vCk=;
        b=A1VIH28axshbRWqIyZMWAQhB1uOoSTUqKcDQwQJeYSBYz/WY36SL3ofqqjhuO43uip
         qWC4UgafygoecCf+7mnJJblUl0neam8lIk+B7KIWTXdQqxBb5ACuo6nG3YRwahMrqZzX
         Li0DLYTlaHOBrKjPOEgsA2+AUNkc04dKEIMa5mUd5m5EcfEN3OJu/ENbKXixb85jOuRY
         SECFKUejCWN0092VypZRPzZBlSU6jEZI7w8Mz/OnV1b0FUhyxJt9X8jgLcvZ1dzLxEsF
         iYAjGkqQzyxBhbut9sK60nzelSTRkE8bX/nDMW7hTn0hFh5+mUhpG2ItOT6Zi+yxDzyf
         8Xjg==
X-Forwarded-Encrypted: i=1; AJvYcCVZz3QRmyMRb+I7YCZDK7qyUpabKtE+7noEb50jJb/PwvfoV9Xa7yXNb+kLFrUXZQ3IlfAN1fOd2w==@kvack.org
X-Gm-Message-State: AOJu0Yw2LKVodHEEg/V3msaP95Q8/wtIpUyxuYTo+kEuej7uQmjbnV6H
	sQeUMMmq+5u6gRCkOK1xEt1pYq+X0Mx2mkZJRoMhkPnGS5e7nLd3Cz51MakxYXdpnLM=
X-Gm-Gg: AZuq6aLyF8S2GbeQVAAyb5O+EBvpdwQZdiUfj9w9bSOoZ2GTyPIoB/m3LDtZ9rqm0a6
	tQ9aP4hU5wk/SKsjtv0qOG66xYm1qVbFzzQ6cj3U2tqU3cTHu6094P+1HL4/7OaZQdt+TpDL2AL
	2Pv6t8AmFjr0L3bg9pClwhjKEeNu3/eANUki4Cfkx0GJUR4oNqGHC57CxnwB/JYK+EOTfygVmOB
	Ftmyw4MJsO2TBTZabdRv74OwrzjmeDLburynsW0mrb2xWXp/6XDjuMpbpTtJlosyirLnP13aDXn
	lf2hzAtuLhcle3Txgd1GEAkygkqbRwrvyIh3zb2q8XE2Fy4f8pRdBY1eQUJXF7YlJOCjymHM916
	L/fIfbInsAlodoulPIn0gaZdM3THBextyfUd74ezJU62VmExjgRUs5dbnOYsY0f+VvXQ8SLpQy1
	QD91x+fGHMezoH76DY3++7wSBpA0FN5V+wqxSMTu8NzCJ8jbVc2ZZ+VF9bOLcXSvhB5hmWsdEPz
	+1eqyFDNvRTPK0=
X-Received: by 2002:a05:620a:f0d:b0:8cb:3a1d:79f2 with SMTP id af79cd13be357-8cb8ca9274fmr587644685a.71.1771750195536;
        Sun, 22 Feb 2026 00:49:55 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:54 -0800 (PST)
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
Subject: [RFC PATCH v4 16/27] mm: NP_OPS_RECLAIM - private node reclaim participation
Date: Sun, 22 Feb 2026 03:48:31 -0500
Message-ID: <20260222084842.1824063-17-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q8is8jyxmp44phpguyxmczdbje6cn7j8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 997148000B
X-HE-Tag: 1771750196-535772
X-HE-Meta: U2FsdGVkX18WcOLANIBNVSzqNMBgGSZp9Kb5r+4KHxjZqpvHJLvODfgGIWTOQD1gW6eyO5n7YDAlt+u779wTm0m5iQ8MxHQtMjLOfdLFI0iMbZ2+YWlKr6RmryjDMyS2MJfkN8xZLBoGMg6vK/fAaGTmUz4L1gQ6RkKAyzRZiUOLEEsoaEUhgkkj/2OBQbdQLf2CF4OdPUj+/c0ZOgrh8gluUg/GnnNc2Vfrp/D/sYPWNdXvlKCdWtYSQ0EdmSvZqe3MmCoW5N+ZoWqKc6ZD42O/LMV0Sy58qPoYXmZP1m1CZhGkHNkplhAmD0G9B1Ie3OqxqSXlzeBZ2gXXzTbC5hSq+V77qSKEKFFkH2SilKR0c2QQKWulAzFFi+4TnMtf8fAO2ijFQtTU6YgketV7IeIVmjPUivBvH6YKCH+IGUDwD64TBo9LXNeE6YEJRPkOnQSGfFkg4UI612YSVAyjwcnbxErBnO1dr9l4nwhsWm9lqfMp4loRN6kmhhPmrEgiiRkuxAC9cA/NMUi3BQg3DeO0T9EPywHYi3YgfurdJNmUJULe4JnQ9URRbg6zqLX+V3gmpBlICvnRgWRDtL1U8uT3XaBRLDXAMXxd5fU0BfsdCL6Z+AIHrhFb0Ys1vhfbMPgr2MrMh2H+DN3ISlysJ2aoI/E9g2MRV2JAy7rjrT3tqncSELM8vAkebKuqT5WADtjauUMB8GzgeoqSfQ20wAlZBW0cNpW1SxsV9oyEmRbTWHjuxx9aGceVpkvIDM55Dr1ivVbMKgZ36vda7W3BBb6+XXN+3er5lxRjWfjO2aBD6kYuNZIqmGqA35T9RYX5qDGx2Iq+nxfNj5QsAuTMf7sKkgykl/N3+eWiJlqBA1TavhRtRVz1P0Pq6FrFnltZ9eBKvhxnOrAql7sgSaW5Dtz9YWEQW8pFLNhtcR9JEqOk7PBAaDBAdI0hFXraqax32TflMMpkvVM6rDMbfIo
 1xy9FvFp
 vL5uawn6hBj6VpYVecAH4wr2AmnuEbI8RKxwO5csZuBlDjqvG2+SF0/txO6N8qG4LEuvIeFjrVH+Sw5BFBDE2yhjB7V9p1FN0UhUOSVHuLcIKiRqGqACEISdjxP0oghjzsBblP4rfJ3tTt5BayxKoCB3cgaJ0P8QOfWCMRbBL0AUv/Vzxs91+nQcU791w/KNz9SaRueEs1BGaGHJ2ejqUWcmdgGT37i4xG3hosS1jDd3AZCyDvw3G73SJS4R6/SaKG4bzYiyPwdsJ1Dj3fYnIvRlAinj7MXKtKhGRaTC/AeBtaLscFN157cAjX3ra+NyIgZKvaq9vT/DShsYQMIuDYzxKpo+zKcnmrLuCN3pcONmtXnvpRgaI2F0VeeCQyAYLlnT1WyDuNox+dzrfm2Uf/cJ3r9QFHHAhnEx37Vu3KNFUmAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private node services that drive kswapd via watermark_boost need
control over the reclaim policy.  There are three problems:

1) Boosted reclaim suppresses may_swap and may_writepage.  When
   demotion is not possible, swap is the only evict path, so kswapd
   cannot make progress and pages are stranded.

2) __setup_per_zone_wmarks() unconditionally zeros watermark_boost,
   killing the service's pressure signal.

3) Not all private nodes want reclaim to touch their pages.

Add a reclaim_policy callback to struct node_private_ops and a
struct node_reclaim_policy with:

  - active:             set by the helper when a callback was invoked
  - may_swap:           allow swap writeback during boosted reclaim
  - may_writepage:      allow writepage during boosted reclaim
  - managed_watermarks: service owns watermark_boost lifecycle

We do not allow disabling swap/writepage, as core MM may have
explicitly enabled them on a non-boosted pass.

We only allow enablign swap/writepage, so that the supression during
a boost can be overridden.  This allows a device to force evictions
even when the system otherwise would not percieve pressure.

This is important for a service like compressed RAM, as device capacity
may differ from reported capacity, and device may want to relieve real
pressure (poor compression ratio) as opposed to percieved pressure
(i.e. how many pages are in use).

Add zone_reclaim_allowed() to filter private nodes that have not
opted into reclaim.

Regular nodes fall through to cpuset_zone_allowed() unchanged.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 28 ++++++++++++++++++++++++++++
 mm/internal.h                | 36 ++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c              | 11 ++++++++++-
 mm/vmscan.c                  | 25 +++++++++++++++++++++++--
 4 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 27d6e5d84e61..34be52383255 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -14,6 +14,24 @@ struct page;
 struct vm_area_struct;
 struct vm_fault;
 
+/**
+ * struct node_reclaim_policy - Reclaim policy overrides for private nodes
+ * @active: set by node_private_reclaim_policy() when a callback was invoked
+ * @may_swap: allow swap writeback during boosted reclaim
+ * @may_writepage: allow writepage during boosted reclaim
+ * @managed_watermarks: service owns watermark_boost lifecycle; kswapd must
+ *                      not clear it after boosted reclaim
+ *
+ * Passed to the reclaim_policy callback so each private node service can
+ * inject its own reclaim policy before kswapd runs boosted reclaim.
+ */
+struct node_reclaim_policy {
+	bool active;
+	bool may_swap;
+	bool may_writepage;
+	bool managed_watermarks;
+};
+
 /**
  * struct node_private_ops - Callbacks for private node services
  *
@@ -88,6 +106,13 @@ struct vm_fault;
  *
  *   Returns: vm_fault_t result (0, VM_FAULT_RETRY, etc.)
  *
+ * @reclaim_policy: Configure reclaim policy for boosted reclaim.
+ *   [called hodling rcu_read_lock, MUST NOT sleep]
+ *   Called by kswapd before boosted reclaim to let the service override
+ *   may_swap / may_writepage.  If provided, the service also owns the
+ *   watermark_boost lifecycle (kswapd will not clear it).
+ *   If NULL, normal boost policy applies.
+ *
  * @flags: Operation exclusion flags (NP_OPS_* constants).
  *
  */
@@ -101,6 +126,7 @@ struct node_private_ops {
 	void (*folio_migrate)(struct folio *src, struct folio *dst);
 	vm_fault_t (*handle_fault)(struct folio *folio, struct vm_fault *vmf,
 				   enum pgtable_level level);
+	void (*reclaim_policy)(int nid, struct node_reclaim_policy *policy);
 	unsigned long flags;
 };
 
@@ -112,6 +138,8 @@ struct node_private_ops {
 #define NP_OPS_DEMOTION			BIT(2)
 /* Prevent mprotect/NUMA from upgrading PTEs to writable on this node */
 #define NP_OPS_PROTECT_WRITE		BIT(3)
+/* Kernel reclaim (kswapd, direct reclaim, OOM) operates on this node */
+#define NP_OPS_RECLAIM			BIT(4)
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
diff --git a/mm/internal.h b/mm/internal.h
index ae4ff86e8dc6..db32cb2d7a29 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1572,6 +1572,42 @@ static inline void folio_managed_migrate_notify(struct folio *src,
 		ops->folio_migrate(src, dst);
 }
 
+/**
+ * node_private_reclaim_policy - invoke the service's reclaim policy callback
+ * @nid: NUMA node id
+ * @policy: reclaim policy struct to fill in
+ *
+ * Called by kswapd before boosted reclaim.  Zeroes @policy, then if the
+ * private node service provides a reclaim_policy callback, invokes it
+ * and sets policy->active to true.
+ */
+#ifdef CONFIG_NUMA
+static inline void node_private_reclaim_policy(int nid,
+					       struct node_reclaim_policy *policy)
+{
+	struct node_private *np;
+
+	memset(policy, 0, sizeof(*policy));
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return;
+
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	if (np && np->ops && np->ops->reclaim_policy) {
+		np->ops->reclaim_policy(nid, policy);
+		policy->active = true;
+	}
+	rcu_read_unlock();
+}
+#else
+static inline void node_private_reclaim_policy(int nid,
+					       struct node_reclaim_policy *policy)
+{
+	memset(policy, 0, sizeof(*policy));
+}
+#endif
+
 struct vm_struct *__get_vm_area_node(unsigned long size,
 				     unsigned long align, unsigned long shift,
 				     unsigned long vm_flags, unsigned long start,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e272dfdc6b00..9692048ab5fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -55,6 +55,7 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/node_private.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -6437,6 +6438,8 @@ static void __setup_per_zone_wmarks(void)
 	unsigned long lowmem_pages = 0;
 	struct zone *zone;
 	unsigned long flags;
+	struct node_reclaim_policy rp;
+	int prev_nid = NUMA_NO_NODE;
 
 	/* Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages */
 	for_each_zone(zone) {
@@ -6446,6 +6449,7 @@ static void __setup_per_zone_wmarks(void)
 
 	for_each_zone(zone) {
 		u64 tmp;
+		int nid = zone_to_nid(zone);
 
 		spin_lock_irqsave(&zone->lock, flags);
 		tmp = (u64)pages_min * zone_managed_pages(zone);
@@ -6482,7 +6486,12 @@ static void __setup_per_zone_wmarks(void)
 			    mult_frac(zone_managed_pages(zone),
 				      watermark_scale_factor, 10000));
 
-		zone->watermark_boost = 0;
+		if (nid != prev_nid) {
+			node_private_reclaim_policy(nid, &rp);
+			prev_nid = nid;
+		}
+		if (!rp.managed_watermarks)
+			zone->watermark_boost = 0;
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = low_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0f534428ea88..07de666c1276 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -73,6 +73,13 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
 
+static inline bool zone_reclaim_allowed(struct zone *zone, gfp_t gfp_mask)
+{
+	if (node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
+		return zone_private_flags(zone, NP_OPS_RECLAIM);
+	return cpuset_zone_allowed(zone, gfp_mask);
+}
+
 struct scan_control {
 	/* How many pages shrink_list() should reclaim */
 	unsigned long nr_to_reclaim;
@@ -6274,7 +6281,7 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		 * to global LRU.
 		 */
 		if (!cgroup_reclaim(sc)) {
-			if (!cpuset_zone_allowed(zone,
+			if (!zone_reclaim_allowed(zone,
 						 GFP_KERNEL | __GFP_HARDWALL))
 				continue;
 
@@ -6992,6 +6999,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	unsigned long zone_boosts[MAX_NR_ZONES] = { 0, };
 	bool boosted;
 	struct zone *zone;
+	struct node_reclaim_policy policy;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.order = order,
@@ -7016,6 +7024,9 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	}
 	boosted = nr_boost_reclaim;
 
+	/* Query/cache private node reclaim policy once per balance() */
+	node_private_reclaim_policy(pgdat->node_id, &policy);
+
 restart:
 	set_reclaim_active(pgdat, highest_zoneidx);
 	sc.priority = DEF_PRIORITY;
@@ -7083,6 +7094,12 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		sc.may_writepage = !laptop_mode && !nr_boost_reclaim;
 		sc.may_swap = !nr_boost_reclaim;
 
+		/* Private nodes may enable swap/writepage when using boost */
+		if (policy.active) {
+			sc.may_swap |= policy.may_swap;
+			sc.may_writepage |= policy.may_writepage;
+		}
+
 		/*
 		 * Do some background aging, to give pages a chance to be
 		 * referenced before reclaiming. All pages are rotated
@@ -7176,6 +7193,10 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 			if (!zone_boosts[i])
 				continue;
 
+			/* Some private nodes may own the\ boost lifecycle */
+			if (policy.managed_watermarks)
+				continue;
+
 			/* Increments are under the zone lock */
 			zone = pgdat->node_zones + i;
 			spin_lock_irqsave(&zone->lock, flags);
@@ -7406,7 +7427,7 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 	if (!managed_zone(zone))
 		return;
 
-	if (!cpuset_zone_allowed(zone, gfp_flags))
+	if (!zone_reclaim_allowed(zone, gfp_flags))
 		return;
 
 	pgdat = zone->zone_pgdat;
-- 
2.53.0


