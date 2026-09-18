Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A01C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831756B0092; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805076B0095; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719E06B0096; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE356B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8CFDA5FFA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:16 +0000 (UTC)
X-FDA: 85226271312.19.2F8C7CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFDB040005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XsSv2yPh;
	spf=pass (imf11.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789721654;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHah+5jRfk1cgHRtiHBlbzO56mR5ghvVPWRiNJxdFWM=;
	b=0H5BJHc7VBpCrfKu40/et/F+f37CEkeCrjItCDrivSgyex7ITRyXSRqR0l2lE+r+uRLnsI
	BxM2xLZzvwAAbEUSvqFE+QBYSmPY0uAQLOxzzYp8XC6pdFGFi6aNzQkUqi8x35rOwH5OMy
	VyakueaXiWGBAc5akdpYxZzo3ZjZYm0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XsSv2yPh;
	spf=pass (imf11.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789721654;
	b=uK8FrfvQ0ht0GMEKLgj0O09FS0iSUbKvmOaC6DyZH539EY14JUcfI6TpM19gbPig+a09Gz
	ujtG5AqgO8rbGNLc2RlpKZj+Hkwt4zHfiDtp8t3AdaF7tGSF5wHeJ4slNcJ/j+wX9dWyyE
	229Pd6r+8C2BfkawbxgiOdwXdR5xycg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAFD0435AE;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8064EC2BCF5;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789721653;
	bh=r4CY+G42WiwuyLzYzLu2owW/EFmLx2vvck8FT8JXxh8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XsSv2yPht3vXmhPx5bMC1JjvsfbAS5cvjXdPMHtt00LXKy+XWkkJmN6Kub/aBcnou
	 AF7SHrlDuxhKKLvIDFpKdkXBAgLw0mXxVYtLlLyUR+HWbUElLEvzwlhDThpnV7eJIA
	 K4TkeVXL/wUlZ1kakM18DZSH5oo/ms2LHPNBrx6KBDDszz9Q1uhzpUDGujbPPTSe/7
	 qB3th514H/czohzTrDGNemD3RNMIuCVggivdiXiTRYs46pgRyRp7FXDPhmi8CD8eqH
	 d5D0lWA9xKma55vzIW9yWAKb/2/iz8ecOEjjzZOPuzkU1zAdeluOxaZoO7ZXKCAX3k
	 DPnbnwmis1d1A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60005C88E75;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
From: Jingxiang Zeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 16:53:41 +0800
Subject: [PATCH 1/6] mm: page_counter: add page_counter_protection struct
 and init API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-descriptive-name-v1-1-dfcfdd91b456@tencent.com>
References: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
In-Reply-To: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, 
 Jingxiang Zeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789721651; l=10506;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=XbEGRKxxHK1Nrej2GHdMz4TmIbAR4XKSXg/71ifM2nY=;
 b=eXC22pAC/5CqXJJBYbY6x3pyJLlR37S08bG7Uza31/gbk0+xAbjfenzgW5Db3JdnXD7fDNQE/
 pwrNFCppoGjBfsJI3HuKBNVQEJpdQj4W3RDIpVbknjGs00cWt713CVZ
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: Jingxiang Zeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFDB040005
X-Stat-Signature: 4pbkpc41qtbrtda6fuw6oxsoctn83sng
X-Rspam-User: 
X-HE-Tag: 1789721654-351733
X-HE-Meta: U2FsdGVkX1/fOLesPsgYqWw0aGsdGfDgU+bx4RN3WCJPIAFfAF24fHqguYMqvmSijWH5SgNVNIZkI2x9NZnafFr1xyQo13o8cB9di4q313KL4qmUFWXs3T7n9NHx30GszXOJgqO4YVBUsd5P+4pPqoMBSn+iYLOSHumpuDh/+yE0hnEWCtCSjBl11qw0KNSZNZ6aqlIKjvzTPaTSqoB6a96texLO2TnulSFXKVNgyDReGhOPGKxzBn8ZwlvPKav0dkqk/d9UDaP/HrcqLdC39P1z/tOhWHF3QOi0y9It9YvuksDezDdJTPinXhbg2NgPDFcQCtOH2HUS0w3DXQcS7et1dBfesY6bx/lTXULAUlhCjJvvBzGq/k7QbJ1FJc/OPl/VfuSpJ6tV2Kr/Y+RmrmEVqpdHYsFnpZWdyjW6j3DL3OfrR1DGgH+P4GhK2neUcYAFmU73BmNU9oypqinv88NvgdnMsDY8LNYUUvkvqZx0FIR+qTIkUYemCIGFInQALloWvenx2KteUrfk5fNlHhIoyiWnEpxFQhvMHbM2k3XlC7UNkr+L/LS6DQZs2uuEFMiXhAuebAbro6kniKCeHRkb1zP2kJEgFFr2c8SFeIudWQmLjA8COFQGMrzmMOwwDexbGCLYJWr7mqYX5Bjjnn7A1WZNa6fMD71/IhhigMOZ2MzdISgbB5riu7yq9Ughvsfc/YUvB6n0H0BQOP/WJ7PnjXK3t7xTz023e0q/c4Ni1ooV+0DseXBeJg4sr4LT8sZzcAV+d/UN/O+9e2FDZzPcGf8vjQIUb86/FSUwGe3ywvKRxiBO3WlqAZKksv9aFGT1OfDSDTpTfSYMkxQn9HFnWU/YhPXaFgrnkfIIxqyhhQvEmVM0KvCzC1j4pHjt1oMSCD9yL6+tbmIEAdDaTejor1XNwYkUqR5d66FuvuuV+svr1dorNdxvftF7t/JBxaVJP25pHLH2ZF3nGd8
 wNmmx5G5
 TXq2x5sH/qbegqx/s89a0kFnrdchkArnlhfMKpBvvfP3z5xxsAt0RMa72k8QOAWW4prEeQHY7Gyeio0d1TR/LvRPr6HW21xMnGuI0q68JnC8S/ijOMrmfPKa8Cn5prGPHElxv5UeOnWKYqUtgpdCSb1trn8V8PllYfpfpz7n439yTvJQ4/t+t6nGfUlz+nJeo92GkdKGKzAToFGwyKF1cLjbjQVQd0kARwWsSCEV4WOEgy4A8dyl/7htHtQLqK4Rbe6JVXDyOrf3kbA1Ii5wy3ENwqwTkCDY9JC8erjFj/3xtpKc8vAAaP7Aj1s3mcfoGyuU2Ji0H0H9V+cWb0hNWm1OCKzO8vDQWd8Gpprwpo3umdiOgzqbbnsVaCWGd+zjBplQVeSUFteODI/8bSyK3uiuhJlaASkMv5jvrvqlcRb7bsSFN4VkkWI9FjdHnhD8nAfJW5Aj1xRhkVp/PKgiTVdwIS8291V4LsGUuCpVvgaZHrH1cgp6Q101AoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jingxiang Zeng <linuszeng@tencent.com>

Hierarchical protection (memory.min/memory.low) is only used by the
memory page counter and by dmem pools; swap/memsw, kmem, tcpmem and
hugetlb counters never participate in it, yet every struct page_counter
carries the full protection state.

Add struct page_counter_protection to hold that state and link it to
struct page_counter through a ->prot pointer, NULL when protection is
not supported.  page_counter_init() loses its protection_support
argument and the new page_counter_init_protection() attaches the
context; track_protection() tests ->prot instead of the flag.
Protection stays enabled only on the cgroup v2 hierarchy, matching the
previous page_counter_init(..., memcg_on_dfl) behaviour, and the root
memcg keeps it unconditionally.

Order the new structure by access frequency: parent, min, low and the
four usage counters are what propagate_protected_usage() touches on
every charge and uncharge, once per level, so they come first and share
a cache line - both embedders place the structure at a cache line
boundary, at offset 384 in struct mem_cgroup and 192 in the dmem pool
state.  emin and elow are only recomputed during reclaim and read by
the protection checks, so they go last.

struct page_counter still carries the old protection fields at this
point, so nothing shrinks yet: they are migrated onto the new structure
in the next commit and removed in the one after that.

The dmem pool allocator points its counter at the embedded protection
context, and the pool fix-up path in get_cg_pool_locked() links
prot->parent the same way it links cnt.parent, so pools created
bottom-up do not lose hierarchical protection.

No functional change.

Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
---
 include/linux/memcontrol.h   |  7 +++++
 include/linux/page_counter.h | 72 ++++++++++++++++++++++++++++++++++++++++----
 kernel/cgroup/dmem.c         |  9 ++++--
 mm/hugetlb_cgroup.c          |  4 +--
 mm/memcontrol.c              | 21 ++++++++-----
 mm/page_counter.c            |  2 +-
 6 files changed, 95 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..5936f497aea6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -199,6 +199,13 @@ struct mem_cgroup {
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
 
+	/*
+	 * Hierarchical memory.min/memory.low protection tracking for the
+	 * memory page counter. swap/memsw, kmem and tcpmem counters do not
+	 * support protection and have no such context.
+	 */
+	struct page_counter_protection memory_prot;
+
 	union {
 		struct page_counter swap;	/* v2 only */
 		struct page_counter memsw;	/* v1 only */
diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 07b7cb12249c..5020e62aacb4 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -7,6 +7,45 @@
 #include <linux/limits.h>
 #include <asm/page.h>
 
+/*
+ * Hierarchical protection (memory.min / memory.low) tracking.
+ *
+ * Only the memory page counter (and dmem pools) participate in protection.
+ * swap/memsw, kmem and tcpmem page counters never do, so the protection
+ * fields are kept out of struct page_counter in this separate structure to
+ * save space in the common case. struct page_counter links to it via ->prot,
+ * which is NULL for counters without protection support.
+ */
+struct page_counter_protection {
+	/*
+	 * Fields up to and including children_low_usage are read and
+	 * updated by propagate_protected_usage() on every charge and
+	 * uncharge, once per level of the hierarchy.  Keep them together
+	 * so that they share a cache line: both embedders (struct
+	 * mem_cgroup and the dmem pool state) place this structure at a
+	 * cache line boundary.
+	 */
+	struct page_counter_protection *parent;
+
+	unsigned long min;
+	unsigned long low;
+
+	/* memory.min and memory.low usage tracking */
+	atomic_long_t min_usage;
+	atomic_long_t low_usage;
+	atomic_long_t children_min_usage;
+	atomic_long_t children_low_usage;
+
+	/*
+	 * Effective values, recomputed by
+	 * page_counter_calculate_protection() during reclaim and read by
+	 * the mem_cgroup and dmem protection checks.  Not touched by the
+	 * charge path.
+	 */
+	unsigned long emin;
+	unsigned long elow;
+};
+
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field in
@@ -41,6 +80,12 @@ struct page_counter {
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
+
+	/*
+	 * Hierarchical protection context, NULL for counters that do not
+	 * support memory.min/memory.low (swap, memsw, kmem, tcpmem, ...).
+	 */
+	struct page_counter_protection *prot;
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
@@ -49,18 +94,33 @@ struct page_counter {
 #define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
 #endif
 
-/*
- * Protection is supported only for the first counter (with id 0).
- */
 static inline void page_counter_init(struct page_counter *counter,
-				     struct page_counter *parent,
-				     bool protection_support)
+				     struct page_counter *parent)
 {
 	counter->usage = (atomic_long_t)ATOMIC_LONG_INIT(0);
 	counter->max = PAGE_COUNTER_MAX;
 	counter->parent = parent;
-	counter->protection_support = protection_support;
 	counter->track_failcnt = false;
+	counter->prot = NULL;
+}
+
+/*
+ * Enable hierarchical protection (memory.min/memory.low) on @counter.
+ * @prot and @parent are the protection contexts of @counter and its
+ * parent page counter respectively. Only the memory page counter (and
+ * dmem pools) call this.
+ *
+ * The remaining members of @prot (emin, elow and the usage counters) are
+ * expected to be zero already, so @prot must come from zeroed memory.
+ */
+static inline void page_counter_init_protection(struct page_counter *counter,
+						struct page_counter_protection *prot,
+						struct page_counter_protection *parent)
+{
+	counter->prot = prot;
+	prot->parent = parent;
+	prot->min = 0;
+	prot->low = 0;
 }
 
 static inline unsigned long page_counter_read(struct page_counter *counter)
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4683f3d68022..a4bac0d5ac3b 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -88,6 +88,7 @@ struct dmem_cgroup_pool_state {
 	struct rcu_head rcu;
 
 	struct page_counter cnt;
+	struct page_counter_protection prot;
 	struct dmem_cgroup_pool_state *parent;
 
 	refcount_t ref;
@@ -426,8 +427,9 @@ alloc_pool_single(struct dmemcg_state *dmemcs, struct dmem_cgroup_region *region
 	if (parent)
 		ppool = find_cg_pool_locked(parent, region);
 
-	page_counter_init(&pool->cnt,
-			  ppool ? &ppool->cnt : NULL, true);
+	page_counter_init(&pool->cnt, ppool ? &ppool->cnt : NULL);
+	page_counter_init_protection(&pool->cnt, &pool->prot,
+				     ppool ? &ppool->prot : NULL);
 	reset_all_resource_limits(pool);
 	refcount_set(&pool->ref, 1);
 	kref_get(&region->ref);
@@ -480,8 +482,9 @@ get_cg_pool_locked(struct dmemcg_state *dmemcs, struct dmem_cgroup_region *regio
 		/* ppool was created if it didn't exist by above loop. */
 		ppool = find_cg_pool_locked(pp, region);
 
-		/* Fix up parent links, mark as inited. */
+		/* Fix up parent links (counter and protection), mark as inited. */
 		pool->cnt.parent = &ppool->cnt;
+		pool->prot.parent = &ppool->prot;
 		if (ppool && !pool->parent) {
 			pool->parent = ppool;
 			dmemcg_pool_get(ppool);
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index ecb6e0b7819a..7fdae504cfc6 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -108,8 +108,8 @@ static void hugetlb_cgroup_init(struct hugetlb_cgroup *h_cgroup,
 		fault = hugetlb_cgroup_counter_from_cgroup(h_cgroup, idx);
 		rsvd = hugetlb_cgroup_counter_from_cgroup_rsvd(h_cgroup, idx);
 
-		page_counter_init(fault, fault_parent, false);
-		page_counter_init(rsvd, rsvd_parent, false);
+		page_counter_init(fault, fault_parent);
+		page_counter_init(rsvd, rsvd_parent);
 
 		if (!cgroup_subsys_on_dfl(hugetlb_cgrp_subsys)) {
 			fault->track_failcnt = true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 791e536efaeb..94c538ea3cb5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4296,25 +4296,30 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
-		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
-		page_counter_init(&memcg->swap, &parent->swap, false);
+		page_counter_init(&memcg->memory, &parent->memory);
+		if (memcg_on_dfl)
+			page_counter_init_protection(&memcg->memory, &memcg->memory_prot,
+						     &parent->memory_prot);
+		page_counter_init(&memcg->swap, &parent->swap);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
-		page_counter_init(&memcg->kmem, &parent->kmem, false);
-		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
+		page_counter_init(&memcg->kmem, &parent->kmem);
+		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
 #endif
 	} else {
 		init_memcg_stats();
 		init_memcg_events();
-		page_counter_init(&memcg->memory, NULL, true);
-		page_counter_init(&memcg->swap, NULL, false);
+		page_counter_init(&memcg->memory, NULL);
+		page_counter_init_protection(&memcg->memory, &memcg->memory_prot,
+					     NULL);
+		page_counter_init(&memcg->swap, NULL);
 #ifdef CONFIG_MEMCG_V1
-		page_counter_init(&memcg->kmem, NULL, false);
-		page_counter_init(&memcg->tcpmem, NULL, false);
+		page_counter_init(&memcg->kmem, NULL);
+		page_counter_init(&memcg->tcpmem, NULL);
 #endif
 		root_mem_cgroup = memcg;
 		return &memcg->css;
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 98322803941a..aa1f9a9a314f 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -16,7 +16,7 @@
 
 static bool track_protection(struct page_counter *c)
 {
-	return c->protection_support;
+	return c->prot != NULL;
 }
 
 static void propagate_protected_usage(struct page_counter *c,

-- 
2.43.7



