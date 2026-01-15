Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2941D4116B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4562F6B0096; Thu, 15 Jan 2026 05:42:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420CC6B0099; Thu, 15 Jan 2026 05:42:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340EF6B009B; Thu, 15 Jan 2026 05:42:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB666B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:42:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAF631AD8F9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:42:26 +0000 (UTC)
X-FDA: 84333859092.05.9090B8F
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0680620002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:42:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gd1WwsIh;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768473745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E21X6Rw5hX+kzgnPEdRnLJU6eESdHa8WNZNfTERO9us=;
	b=dd6YEkVnWRggXWchgCbhFHLGb2LP2NWgo0vdCyenoUfZtEoX6Oy6L4S3XujwVmINAjxATa
	wKQAcYHYS/922fDyeYwU5+o0hZKQ+7mqv8n9C9OSspFVLCD6r8wT9JXBNJSxWq3Dspozou
	6kD3hXaAiCJ86tnZJ/+IUhXZlFdOvnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768473745; a=rsa-sha256;
	cv=none;
	b=0AE7VcM+dWUMl+HywIeN9I/8Lufeu140n5+JKy+r340CYzFNuwaGKLwMtRlZ6CnO2t0pVO
	CELtFn6ktbBmixkZZewvcOPfd1q6aBukz70/ujs8SDGdSeeLcZp5pmDLG3N94t+F5QFPkv
	vfzPDkl1e2YsJVkaQYxlAqaoMuHdomM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gd1WwsIh;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768473743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E21X6Rw5hX+kzgnPEdRnLJU6eESdHa8WNZNfTERO9us=;
	b=Gd1WwsIhns0nEOkvgNwLvRtzBTjlgigfzTtsf/Lb9TtF1sy9u8ynT8tTtHvToPAmD9bKkj
	jySAiCoogyimKgEEdnUnz4OYpXIgetozQzJOLMdwOln6mXBS6sD9efPIvExQ3Bck6SDxKt
	gdtnGkpuXaea0OZt5Mg6e1+YFZ9zmVw=
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
Subject: [PATCH v3 28/30 fix 2/2] mm: memcontrol: change state_locals to atomic_long_t type
Date: Thu, 15 Jan 2026 18:41:39 +0800
Message-ID: <4aad240fe536ce024c002087b2c395a197928e8a.1768473427.git.zhengqi.arch@bytedance.com>
In-Reply-To: <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
References: <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0680620002
X-Rspam-User: 
X-Stat-Signature: xnbidps9nwxktjggx11je6azbuxy8i6t
X-HE-Tag: 1768473744-991545
X-HE-Meta: U2FsdGVkX18nYfZavKaXR5n67ZIUPHq91tk5wzlkPZO2D6GzBQhuPilNYo5iun3lwPf4g6y41wttzO5y+kzg5b2yzmO2aJLomu2KXW7RkmlOsETdWECMfNCay3JWv3+4eS4aE7uAgsX99N0vRmS8AuNSYWueQ3hcHb2EhjBM5OZcZT4LDmLK74r4IGTnUeA9LnZSWd1ZMjT6eJLLWlDuj9mYHEoRjXef1ghCf6C19YCjO+euWAoTZO1qdGcxERmymaxu6qk/NNZMwO3bZgHqM1TNlaNj39OELgEnrutkEtBGHI0oFkP33XYzp2VrnZBJT7nWt/fNaLPtF4RiJkzNVIhogDRYrvBUNY18sK1j0yxSL9mv73pqRPgZVqq+RhU6bUSOzBvKEuk275427OHzaSMimr4xiIJsertJTsab9vMRZkj9rZxqZtD8i4SqiBp1IEMMowGBTvtYubLd7A6GXKABhW/V6awJUj15jG/luWRJQs7DHi0Z9BHu9se8x6pVGx+Q4K8LCu9nJzJMP6qRgTOe+rutlMKc2+6CDFql/aBsJrgMdZeHw9iI2BSoA+cy6A9LCPd4WjvRJQVzMl5nPxAZkw4NdukoLT8JlpgFnuq9iALiaAekB9JVdMjpWbCqMldHpefPBRYRzp4BIS8fo43NaC/muanUW0YnfkZUofQwZS+OZx/UZtNVnYZoFa18+CL/DqpndT0GoGjUUhYQooq2CjQvHAb8eU7uuR45XyHWx+TrtlT+PQdO1R4O3GFbW3uyYWMAnvxUbqZ4PBqUwYaIBUq4okKs7+RNmVpflJIweGAN/4KUk3FNqHGiTG+FhW2qhx8GZctHbLEdM2JFrpOwB2JW/nvdp/ZipVaLfVQQk7z/k+aAe/V/F5rPXX6/d3bqn1w+sQCmVzgXeATRxMgvuq8ze6phv/RlEZ8yiPIxUxLxWMRUKe00hlHqoY/Lf08zfNc+XlcgqoEa/6m
 qge+mccw
 5fJqatjXkU8g8muUmw0HZ0bu7Tk3p30iIk4Se0blD4UicRhi9PMmXI+VzUTtt0AarYD8OQAKRfjTpOfqchivnpxixLQmNL7DNpMflMg2AqNMLio+xOmGsoJhL6XNDfHhVHvQULIiHgozK1UMnjjzY/271Mkg9lDx5nbHO1WpTMatjRjRhlS6X1PHZ935BtCAMO1JmBPedSTW08Q8pD3m9FC6rqXM1nWX1kAXJtL/2IzlqBIA=
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
 mm/memcontrol.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b7b35143d4d2d..c303c483f55a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -456,7 +456,7 @@ struct lruvec_stats {
 	long state[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Non-hierarchical (CPU aggregated) state */
-	long state_local[NR_MEMCG_NODE_STAT_ITEMS];
+	atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Pending child counts during tree propagation */
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
@@ -499,7 +499,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
+	x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -524,8 +524,7 @@ static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 
 		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
 
-		WRITE_ONCE(parent_pn->lruvec_stats->state_local[i],
-			   parent_pn->lruvec_stats->state_local[i] + value);
+		atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
 	}
 }
 
@@ -620,8 +619,8 @@ struct memcg_vmstats {
 	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Non-hierarchical (CPU aggregated) page state & events */
-	long			state_local[MEMCG_VMSTAT_SIZE];
-	unsigned long		events_local[NR_MEMCG_EVENTS];
+	atomic_long_t		state_local[MEMCG_VMSTAT_SIZE];
+	atomic_long_t		events_local[NR_MEMCG_EVENTS];
 
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_VMSTAT_SIZE];
@@ -824,7 +823,7 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	x = READ_ONCE(memcg->vmstats->state_local[i]);
+	x = atomic_long_read(&(memcg->vmstats->state_local[i]));
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -841,7 +840,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	WRITE_ONCE(parent->vmstats->state_local[i], parent->vmstats->state_local[i] + value);
+	atomic_long_add(value, &(parent->vmstats->state_local[i]));
 }
 #endif
 
@@ -1001,7 +1000,7 @@ unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
-	return READ_ONCE(memcg->vmstats->events_local[i]);
+	return atomic_long_read(&(memcg->vmstats->events_local[i]));
 }
 #endif
 
@@ -4126,7 +4125,7 @@ struct aggregate_control {
 	/* pointer to the aggregated (CPU and subtree aggregated) counters */
 	long *aggregate;
 	/* pointer to the non-hierarchichal (CPU aggregated) counters */
-	long *local;
+	atomic_long_t *local;
 	/* pointer to the pending child counters during tree propagation */
 	long *pending;
 	/* pointer to the parent's pending counters, could be NULL */
@@ -4165,7 +4164,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 
 		/* Aggregate counts on this level and propagate upwards */
 		if (delta_cpu)
-			ac->local[i] += delta_cpu;
+			atomic_long_add(delta_cpu, &(ac->local[i]));
 
 		if (delta) {
 			ac->aggregate[i] += delta;
-- 
2.20.1


