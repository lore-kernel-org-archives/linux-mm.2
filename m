Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B40C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD6D6B0095; Wed,  9 Sep 2026 05:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095096B009B; Wed,  9 Sep 2026 05:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECF56B009D; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE2EB6B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 904344015B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:25 +0000 (UTC)
X-FDA: 85193738490.14.29793A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8964540005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ca+kykha;
	spf=pass (imf01.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947063;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+tZjI3sUyjkRvCtsblbEGXoJAmrvcbBjVrM5/lsbO8=;
	b=bjPBfehbF8Nxj3iL3hGSrCWFrB0ebFmKoC1LuVzKfaqEp3FXM+jmaVnfWNZP+iMvAiSxgT
	e5z6vmGLdqkhGpAN6+iUNJBwav2/Eg6CiQ/AwK3/QVKcNyi0gti1veKMMWumu/rTl/I6Mh
	YSc+YDpcD4mXs313tc4Jm/FSZ2tLNh8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ca+kykha;
	spf=pass (imf01.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947063;
	b=DznEt4tBnWrjioICiNTraiApGt8CSMMGhYAFdSBJRjWCr9zjTrJw+SQgc6vFlSs3hy7QHu
	nhEv846bT4MVyN5GKs1l3KIS7KLkp7QSaBWuC2lLah+CP2poZ1vKFVguwoMejW9J00t9vs
	lkOlQZKR4o6BcuT4wj8/LpldrQ64R8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6E5243EA5;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6EB0C4AF0B;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788947062;
	bh=CRNCNFOv1d/GN5B5RDOOI3W6Az4pcT/yOZ7OHd2PmTU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ca+kykhajnNckAaTgWwCtYDMwntf2X0wkKrXlvNUTTINw9pfmajZwXe2mCtVHDXkS
	 eSzJjxzbPFw+aTWc9xCtU02u6fR0Fduew3A08cvSMVtz5i9fAxyb8eoiApeB+XL1dl
	 uvP2eAAOTxcPT2MLZXToPLVcJDF+jwUjhY0Vtuqtv7prm0zkdH87TjRBrtX19ZT/2e
	 fGyIhNRN4Bfb55rxaR5Sa8pvR2jYydZmc5J4NRllPJvBCJFzVTwUvmmRffLXGe4BfQ
	 f3BnW+tiHI/RNfGA5ewq3n9IwTS5keBbKWxfKx75PoNf+xLoyVyBRkbRHBM/7fVO5g
	 GG9JeGilqKlgA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885CCC79F8C;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
From: linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Wed, 09 Sep 2026 17:44:20 +0800
Subject: [PATCH v2 2/3] mm: page_counter: track protection state in
 page_counter_protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-descriptive-name-v2-2-d7dd7c099049@tencent.com>
References: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
In-Reply-To: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
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
 Oscar Salvador <osalvador@suse.de>, 
 Jingxiang Zeng <jingxiangzeng.cas@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linuszeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788947061; l=9367;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=XnbhI6+XRiaUlggWoaB82VSvLpQ+T9RolGkd/4opeEI=;
 b=5VgMCSoPCaXiCqb5wg+bntHG8d6Ak9j8BQa82fZVBGqZccF2FPppQ4a8KIUtrqj7tSklZX58w
 J1XUmGOlDWkCMxeVIF2N7KV/UqP5LXntzd+BqFlzw8g7w4RgPHAeSVX
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: linuszeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspam-User: 
X-Stat-Signature: nwbib5m3mrgd3zex51yxaw4w9a6ifb15
X-Rspamd-Queue-Id: 8964540005
X-Rspamd-Server: rspam07
X-HE-Tag: 1788947063-119755
X-HE-Meta: U2FsdGVkX18tKwq3+Z8vgcfkv17g4I3WWfT5catNtkjRHnsimMy61vWLdrxYmYcgbWR3Ox9zoaNgFxoc09Z0oa0o8oMP3dSp5MjAoPdgV7CFDVo+y4hhTWGJ7XLghLw8jBHxgQobZT/jaIjfDUaxGqcoCnTn+gN8eg7+FWmu9J2HivzaeXq9mAMPc/+XfcrPBCOXbwNvVenAjIuFrEkVAT3ujTCqMnk6xpjgokIAU/1Ts5JWZT+Dwj4Ah/3ieHrtDqGFKtZWwTCFOZGKW2cHXPwvOEpCuGqEvcg+ewZrrqgomNpA1+KvoVWifK3reG2aB2SNuMyS+aSghHcJIll5gZcHgI5heFU/ZediJEEG3SOpJG2ZTgiQRH7x4Ac+G0mSKQ2786Sztm+LaExvc+SecjhqXgBO3fD7Oi8DtSE3HTwqe7qAKgbCYeTTKuzCEBb+cxfV7KmGPXm/o3+ttXfTAAb3nWCozqT4oLde+20JUWM4bBGA++LT6p12R6aRPpNkMYWu0R6g/J2++EOOFJ4nxDT4Rjb2ehOb8T+7kKDf1OLmag5Y9eIorvR/e9/z20WyLb3us1ZkZAul4BMVqRmuKGGENphOsDwcNJi6ZPmhQVlbfBQy6VY0oOufN3du+00GdnQPuR5FHyXzbzaG4F+x/gYC+NQr2ZfYV2Toycx5WtHY01VboeV85TDw1GqiLk9d7AyVdaH2KnfIqmMHGb4ha1qliLXCN2/Od3P7z5B+VIZrsKxxdopRnBIxIjlwVStpiIBsqAFPdj7+xhY+E+AMu2jNypSIQXLmtfeugINpWgWqmAQlfJmnB923kLKLEgzlLMnabV2gXk0tSoVtsUzbu25GWcAVKr6AFKN2TIkosEYsGJBqhhHD+GT4IJcTIIOdUxJPoOzpeAv0UehAKm4fKvdRRfNJNvSNUcdV6o5Sar6nCO4czTnDB77BGP0uzisJqGv8b0U3hiAc33EJNqc
 cOCFYfwP
 O+ppCePfoEz3QD1TCHi0Hy5Qn7vIrBgsR0589otSnbq8GdEmjrqGVDdUR8GFmcLH1UlcTpA7tSnatAkCTbTj2j/dUiE/DtGhPxMYZLOhE8MGtzc7tMBoGhEffRh8kB5o2RwBFq/6q5rR+xvB6hP5lgHvBNJm++NcYdlp2WtWh3+R72NSuIKbOzVEk/HGUp/xE1dNXUmUdrbfXa+B0fE0JsB0kUA5Ae1w+LaaIp6lV9rtbkh7KfSgSN9LoxVnaDF44Gzg8Q//clNK17hgpsnGfcFj5QY0hrdZV7V/IO2/Bk7DYzShLh/ARRU+Si91qaOCkVSSWMmULgfeIo0X3s/wNW0ovEpgiiGdbmilHCb7CvAHUvNmxI8YX+Uod7TvQ2tBjVQ9/AEqOPjM9BnpG5rrtxrAFzFReZH+Krbp017HSp9FvqxqQIparKJyDobHZEjvQgyrkjlf/SLFB8wbF8jILzDHAEz7ZsEZUj1ofcZnmqu1wCsjPpcQE29jFog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: linuszeng <linuszeng@tencent.com>

Move the read/write side of hierarchical protection from struct
page_counter to struct page_counter_protection: propagate_protected_usage()
updates the protection context of the parent, page_counter_set_min()/low()
and page_counter_calculate_protection() operate on it, and memcg and dmem
accessors (including dmem_cgroup_below_min()/below_low()) read
min/low/emin/elow and children_*_usage from it.

struct page_counter keeps its now-unused protection fields for now; they
are removed in a follow-up commit.

No functional change.
---
 include/linux/memcontrol.h |  8 +++----
 kernel/cgroup/dmem.c       | 12 +++++-----
 mm/memcontrol.c            |  8 +++----
 mm/page_counter.c          | 59 +++++++++++++++++++++++++++++-----------------
 4 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ed863f4ed233..44065001a66a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -591,8 +591,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 	if (root == memcg)
 		return;
 
-	*min = READ_ONCE(memcg->memory.emin);
-	*low = READ_ONCE(memcg->memory.elow);
+	*min = READ_ONCE(memcg->memory_prot.emin);
+	*low = READ_ONCE(memcg->memory_prot.elow);
 }
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
@@ -616,7 +616,7 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.elow) >=
+	return READ_ONCE(memcg->memory_prot.elow) >=
 		page_counter_read(&memcg->memory);
 }
 
@@ -626,7 +626,7 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.emin) >=
+	return READ_ONCE(memcg->memory_prot.emin) >=
 		page_counter_read(&memcg->memory);
 }
 
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index a4bac0d5ac3b..4027d3d309c8 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -212,12 +212,12 @@ set_resource_max(struct dmem_cgroup_pool_state *pool, u64 val, bool nonblock)
 
 static u64 get_resource_low(struct dmem_cgroup_pool_state *pool)
 {
-	return pool ? READ_ONCE(pool->cnt.low) : 0;
+	return pool ? READ_ONCE(pool->cnt.prot->low) : 0;
 }
 
 static u64 get_resource_min(struct dmem_cgroup_pool_state *pool)
 {
-	return pool ? READ_ONCE(pool->cnt.min) : 0;
+	return pool ? READ_ONCE(pool->cnt.prot->min) : 0;
 }
 
 static u64 get_resource_max(struct dmem_cgroup_pool_state *pool)
@@ -388,13 +388,13 @@ bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 	dmem_cgroup_calculate_protection(limit_pool, test_pool);
 
 	used = page_counter_read(ctest);
-	min = READ_ONCE(ctest->emin);
+	min = READ_ONCE(ctest->prot->emin);
 
 	if (used <= min)
 		return false;
 
 	if (!ignore_low) {
-		low = READ_ONCE(ctest->elow);
+		low = READ_ONCE(ctest->prot->elow);
 		if (used > low)
 			return true;
 
@@ -787,7 +787,7 @@ bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state *root,
 	 * here.
 	 */
 	dmem_cgroup_calculate_protection(root, test);
-	return page_counter_read(&test->cnt) <= READ_ONCE(test->cnt.emin);
+	return page_counter_read(&test->cnt) <= READ_ONCE(test->cnt.prot->emin);
 }
 EXPORT_SYMBOL_GPL(dmem_cgroup_below_min);
 
@@ -818,7 +818,7 @@ bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
 	 * here.
 	 */
 	dmem_cgroup_calculate_protection(root, test);
-	return page_counter_read(&test->cnt) <= READ_ONCE(test->cnt.elow);
+	return page_counter_read(&test->cnt) <= READ_ONCE(test->cnt.prot->elow);
 }
 EXPORT_SYMBOL_GPL(dmem_cgroup_below_low);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ffa1ced3baae..b4c01a0dfd4f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4823,7 +4823,7 @@ static ssize_t memory_peak_write(struct kernfs_open_file *of, char *buf,
 static int memory_min_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
-		READ_ONCE(mem_cgroup_from_seq(m)->memory.min));
+		READ_ONCE(mem_cgroup_from_seq(m)->memory_prot.min));
 }
 
 static ssize_t memory_min_write(struct kernfs_open_file *of,
@@ -4846,7 +4846,7 @@ static ssize_t memory_min_write(struct kernfs_open_file *of,
 static int memory_low_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
-		READ_ONCE(mem_cgroup_from_seq(m)->memory.low));
+		READ_ONCE(mem_cgroup_from_seq(m)->memory_prot.low));
 }
 
 static ssize_t memory_low_write(struct kernfs_open_file *of,
@@ -6271,6 +6271,6 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 		memcg = root_mem_cgroup;
 
 	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
-		K(atomic_long_read(&memcg->memory.children_min_usage)),
-		K(atomic_long_read(&memcg->memory.children_low_usage)));
+		K(atomic_long_read(&memcg->memory_prot.children_min_usage)),
+		K(atomic_long_read(&memcg->memory_prot.children_low_usage)));
 }
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 38cb99f5f50e..401201c8e390 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -21,28 +21,29 @@ static bool track_protection(struct page_counter *c)
 static void propagate_protected_usage(struct page_counter *c,
 				      unsigned long usage)
 {
+	struct page_counter_protection *prot = c->prot;
 	unsigned long protected, old_protected;
 	long delta;
 
-	if (!c->parent)
+	if (!prot || !prot->parent)
 		return;
 
-	protected = min(usage, READ_ONCE(c->min));
-	old_protected = atomic_long_read(&c->min_usage);
+	protected = min(usage, READ_ONCE(prot->min));
+	old_protected = atomic_long_read(&prot->min_usage);
 	if (protected != old_protected) {
-		old_protected = atomic_long_xchg(&c->min_usage, protected);
+		old_protected = atomic_long_xchg(&prot->min_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
-			atomic_long_add(delta, &c->parent->children_min_usage);
+			atomic_long_add(delta, &prot->parent->children_min_usage);
 	}
 
-	protected = min(usage, READ_ONCE(c->low));
-	old_protected = atomic_long_read(&c->low_usage);
+	protected = min(usage, READ_ONCE(prot->low));
+	old_protected = atomic_long_read(&prot->low_usage);
 	if (protected != old_protected) {
-		old_protected = atomic_long_xchg(&c->low_usage, protected);
+		old_protected = atomic_long_xchg(&prot->low_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
-			atomic_long_add(delta, &c->parent->children_low_usage);
+			atomic_long_add(delta, &prot->parent->children_low_usage);
 	}
 }
 
@@ -257,7 +258,10 @@ void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
 
-	WRITE_ONCE(counter->min, nr_pages);
+	if (!counter->prot)
+		return;
+
+	WRITE_ONCE(counter->prot->min, nr_pages);
 
 	for (c = counter; c; c = c->parent)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
@@ -274,7 +278,10 @@ void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
 
-	WRITE_ONCE(counter->low, nr_pages);
+	if (!counter->prot)
+		return;
+
+	WRITE_ONCE(counter->prot->low, nr_pages);
 
 	for (c = counter; c; c = c->parent)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
@@ -445,9 +452,18 @@ void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
 				       bool recursive_protection)
 {
+	struct page_counter_protection *prot = counter->prot;
+	struct page_counter_protection *parent_prot;
 	unsigned long usage, parent_usage;
 	struct page_counter *parent = counter->parent;
 
+	/*
+	 * Only counters with protection support (memory, dmem pools) are
+	 * ever passed here, but guard anyway.
+	 */
+	if (!prot)
+		return;
+
 	/*
 	 * Effective values of the reclaim targets are ignored so they
 	 * can be stale. Have a look at mem_cgroup_protection for more
@@ -463,23 +479,24 @@ void page_counter_calculate_protection(struct page_counter *root,
 		return;
 
 	if (parent == root) {
-		counter->emin = READ_ONCE(counter->min);
-		counter->elow = READ_ONCE(counter->low);
+		prot->emin = READ_ONCE(prot->min);
+		prot->elow = READ_ONCE(prot->low);
 		return;
 	}
 
+	parent_prot = parent->prot;
 	parent_usage = page_counter_read(parent);
 
-	WRITE_ONCE(counter->emin, effective_protection(usage, parent_usage,
-			READ_ONCE(counter->min),
-			READ_ONCE(parent->emin),
-			atomic_long_read(&parent->children_min_usage),
+	WRITE_ONCE(prot->emin, effective_protection(usage, parent_usage,
+			READ_ONCE(prot->min),
+			READ_ONCE(parent_prot->emin),
+			atomic_long_read(&parent_prot->children_min_usage),
 			recursive_protection));
 
-	WRITE_ONCE(counter->elow, effective_protection(usage, parent_usage,
-			READ_ONCE(counter->low),
-			READ_ONCE(parent->elow),
-			atomic_long_read(&parent->children_low_usage),
+	WRITE_ONCE(prot->elow, effective_protection(usage, parent_usage,
+			READ_ONCE(prot->low),
+			READ_ONCE(parent_prot->elow),
+			atomic_long_read(&parent_prot->children_low_usage),
 			recursive_protection));
 }
 #endif /* CONFIG_MEMCG || CONFIG_CGROUP_DMEM */

-- 
2.43.7



