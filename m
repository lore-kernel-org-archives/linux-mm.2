Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A861C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1506B0098; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323866B009B; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5126B009B; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF9E56B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17B20C05A2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:17 +0000 (UTC)
X-FDA: 85226271354.22.F9569ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D56210000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1QL4I5I;
	spf=pass (imf05.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789721655;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3Lbs9hmCFGVDZM8xwxZvJV5/4rMkyXflfiYqQTnkkw=;
	b=yudNnZOAUhnC0suokwsKgcjBmK0pC8RLfofHu1aya3jdy+xKtiKMYZZmZyeW0kT5V2ZatJ
	y0+eBuajnlVSTKwmbJI2zxNTZU2HW1D1xWBprKf/Rn/Sb8BYnAcHtbS8VEmQtgMGTDtv24
	Hse71001FGXkURMEOEhs/wU3yfR6JlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789721655;
	b=VKx3Kn6HrWsj28y/F3RoZs9b4+pWhGXph5ErrqSmXy58XCPZfngH8L2ygf7TzM8e9tSKk7
	qFqhqVx0Q7fDtG15TfXACP3wLtmULaz8S1RQEzJXu8pC8hEHnnlYGaM8raY4wIRTsCHu6m
	Re6NwWhMkaklpOlbJkdAYegTy78O1PY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1QL4I5I;
	spf=pass (imf05.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0958D60A5B;
	Fri, 18 Sep 2026 08:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90018C2BCF6;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789721653;
	bh=aU+zGcsd/b4y8gfxOYwXDtxYISGgw2Gxjyv9f8ql9dc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=o1QL4I5IGfsnNrIicKfPQX/iil/P9M1bH8Pdv4kbigwcX8gWkvg5JF5J+Hg7VlAXN
	 xYdZ19IHpBeWktRwevW3h/MLgguWInfVuHF68NJtoPqjgDFWHaF/e10ZjCFvmKQC1S
	 2IEQtcnh5oG+WFvpJ5GQM62W8xCaVJl3GFEn3EQCqdt1NX9JaUK44yz8X+LNXcqmlU
	 IkwtiV8svxqY5+DtTJylBxmPFG8mNDT24MB1MNJMVFdvhkJN3hiLwnhz5+6qgUPkBl
	 4I+kloUIKk/7j2TnT/UesqILUmuR+wExzb7Ln9YZpcuWOmQFEijnG1Fllv6YdyCUP5
	 2AlLcwNYjrE0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A3BC982D7;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
From: Jingxiang Zeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 16:53:42 +0800
Subject: [PATCH 2/6] mm: page_counter: track protection state in
 page_counter_protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-descriptive-name-v1-2-dfcfdd91b456@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789721651; l=9424;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=CfFjeGPSW+N+Iw1P+GRZXWwVce/M2M1WMHPh1nAZy3E=;
 b=jHpPy7d+GDh+HUqiPXX7FRb0ibwbrNw7nMVEoGk2aTWH+mJ3cLPntP/bIns5bUIeOcTpATZxL
 1OdQfYToxPuBu+9swnmlTRddbMrjgSG3r5RhShXyjuZltZZBazTGJim
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: Jingxiang Zeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: buq9n89dyj4psri4xx96ncrawd9eh66a
X-Rspamd-Queue-Id: 2D56210000B
X-HE-Tag: 1789721655-789872
X-HE-Meta: U2FsdGVkX190Hy4ZIyPUAKZI/pxd3usahIYCbhYyoVq0wtMuVLp+DrXfkagAr0UjCpD8mT0hb9Kgq0oFLJppL/GaGbukc9d4mfypJ/SI2qbvghZOWYsHnxL/Z+Sl6yjQtdzhNWT8FezkPUMre+mF2o/WNuF2fuqJwOSzj77oQDsxGFMwJ6gm/74553qyv2cHGdIDS1fKazyAk8DPXBsXSbxOjk/N8RgpYTHFn4Xebw1kJH7L8N2AhtmezUFUJBnQRnGVVeg0gWwBAWDMmGUtGum2FvSGX+cYEc9n2nUZb701U4bsoy3xzXyYMSXcjwUlhHua0yBFe83kufdDvGwTVqYVFVXUxWg3A0kD1rg/Pub3TRzW1QEvYZguuhbGHFLbaG8GiQewPzJSBvsSemkK5l3sJ/4KM9U8JS3GBKI0jSY4YfsoN5+OFQf7QYq1WcACuNHR0rLhsnj5m6cFYj8/RrHs4cSyEHvhKZFoMT1lb/m9iLl5zlwj6TRLmKwbWkYpuW+bM84LtP5VBOrrPrEe+eyEJnEVqJTUFTVxNehup4/mszhAQKPerrfTpS2LgTWDawCwCnVLwgsRTOPmaD5X2f9f9r0p5gAKkQCPFvDeIYtQ6cNYXNHQy+d8rv37V01cXj0RpWDDrP7d19T/cbJOSw1c+f4q5wSu6F2XPWONVDOS31B8+hdR/m8Mc9DiVG/rCcpxDXw6aVl69XVogEk2fV3LJcvyfnMZUJ83I27HHB/MSQIJrBJ1trovdsBo0vGVLO7gelZm+bvovGUn4raXG6nIEdxfRBF25GQta1BNg1CickB5QrH4r00yRE6hNYt8gkzQoXeGWasoAZix0ORDjaOX6OAwZ9qooexmJHpZTpFM+M6QwXDBLA389os1cUoJRXoSp/0c3tu4kDKnI0A/TtJfdYUV04/7nk14o8IuJAdY/9RMSVYRZs93biyhrYsrkBo5ccC0+74xqKr3rA7
 4BYz9gFD
 HWxXXchW9BETMLoiQpKXw80qVjGQ0GNWDYTjfZV26H+KpSBxu88asHtHTz1sDZyuaLGbzjBn4aZarmTmhCsIJQgjoABWusyoz+qPAu2J2bBWLnynsaYaeQAeY2DOlz9Fk8YQmx8wdjbNNCjHgzKlj/nGj5/POLfQwk7WNmN63LVm4c9zXAtRkkX0UltIZ8hIudrpyR36iYJmf87+Mdey/DGinGqn7VKgtxw2ViYwExfTkaTK+qXDz0F3a+lVlhA5HLQPGNdkwcli8CobhHHT6YDTNnco5Rn62aigVpA7jxLNH45V9jx06TmE13rH9eDXbyfVbAzdb3PsqViu84l7zhSZYbm3HHo8QZi3qEGO3QYoBY1HVFgDmNdXhI+sNqZCtT+wQIdfQAFCbcLKnIu04rVmp5RAMjz1NGwdcz0qs8rj3GRD9POKAZyRVQ78dN5sFgDU/l78ecq9Y6rvbwspjKj/+oq7Mt01M40X4zfex0PAPJz+Tg0T8eYLrcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jingxiang Zeng <linuszeng@tencent.com>

Move the read/write side of hierarchical protection from struct
page_counter to struct page_counter_protection: propagate_protected_usage()
updates the protection context of the parent, page_counter_set_min()/low()
and page_counter_calculate_protection() operate on it, and memcg and dmem
accessors (including dmem_cgroup_below_min()/below_low()) read
min/low/emin/elow and children_*_usage from it.

struct page_counter keeps its now-unused protection fields for now; they
are removed in a follow-up commit.

No functional change.

Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
---
 include/linux/memcontrol.h |  8 +++----
 kernel/cgroup/dmem.c       | 12 +++++-----
 mm/memcontrol.c            |  8 +++----
 mm/page_counter.c          | 59 +++++++++++++++++++++++++++++-----------------
 4 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5936f497aea6..ff69a390a809 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -625,8 +625,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 	if (root == memcg)
 		return;
 
-	*min = READ_ONCE(memcg->memory.emin);
-	*low = READ_ONCE(memcg->memory.elow);
+	*min = READ_ONCE(memcg->memory_prot.emin);
+	*low = READ_ONCE(memcg->memory_prot.elow);
 }
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
@@ -650,7 +650,7 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.elow) >=
+	return READ_ONCE(memcg->memory_prot.elow) >=
 		page_counter_read(&memcg->memory);
 }
 
@@ -660,7 +660,7 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
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
index 94c538ea3cb5..aaf23e849408 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4860,7 +4860,7 @@ static ssize_t memory_peak_write(struct kernfs_open_file *of, char *buf,
 static int memory_min_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
-		READ_ONCE(mem_cgroup_from_seq(m)->memory.min));
+		READ_ONCE(mem_cgroup_from_seq(m)->memory_prot.min));
 }
 
 static ssize_t memory_min_write(struct kernfs_open_file *of,
@@ -4883,7 +4883,7 @@ static ssize_t memory_min_write(struct kernfs_open_file *of,
 static int memory_low_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
-		READ_ONCE(mem_cgroup_from_seq(m)->memory.low));
+		READ_ONCE(mem_cgroup_from_seq(m)->memory_prot.low));
 }
 
 static ssize_t memory_low_write(struct kernfs_open_file *of,
@@ -6457,6 +6457,6 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 		memcg = root_mem_cgroup;
 
 	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
-		K(atomic_long_read(&memcg->memory.children_min_usage)),
-		K(atomic_long_read(&memcg->memory.children_low_usage)));
+		K(atomic_long_read(&memcg->memory_prot.children_min_usage)),
+		K(atomic_long_read(&memcg->memory_prot.children_low_usage)));
 }
diff --git a/mm/page_counter.c b/mm/page_counter.c
index aa1f9a9a314f..d33f40ca2c78 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -22,28 +22,29 @@ static bool track_protection(struct page_counter *c)
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
 
@@ -258,7 +259,10 @@ void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
 
-	WRITE_ONCE(counter->min, nr_pages);
+	if (!counter->prot)
+		return;
+
+	WRITE_ONCE(counter->prot->min, nr_pages);
 
 	for (c = counter; c; c = c->parent)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
@@ -275,7 +279,10 @@ void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
 
-	WRITE_ONCE(counter->low, nr_pages);
+	if (!counter->prot)
+		return;
+
+	WRITE_ONCE(counter->prot->low, nr_pages);
 
 	for (c = counter; c; c = c->parent)
 		propagate_protected_usage(c, atomic_long_read(&c->usage));
@@ -454,9 +461,18 @@ void page_counter_calculate_protection(struct page_counter *root,
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
@@ -472,23 +488,24 @@ void page_counter_calculate_protection(struct page_counter *root,
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



