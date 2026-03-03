Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C57E67A62
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC056B00BE; Tue,  3 Mar 2026 09:57:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4006B00BF; Tue,  3 Mar 2026 09:57:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFB06B00E0; Tue,  3 Mar 2026 09:57:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 309836B00BE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:57:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4A5C1C19C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:56:59 +0000 (UTC)
X-FDA: 84505054158.16.B455CAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1A432C0003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:56:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J0KG0k1k;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772549818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6WrENax+sUD4gQp+dJwQG59dAxFL4UYh9VdUk0MCKQ=;
	b=KVAqvcWXzPVMXRfzoCS9TjMWy9PN6iadsxyr6WZo4kroHA8Fp6o3ClhPF3PNBXDspQTRc+
	fV2zfeYx0vRtvZ7dl0gGm3IfJnThjQHhT7+qa5aG0O1stqr00Ag9cIcprGXyorwau8/bMq
	RCIj9sUuvHmRH/0hAi64pldoTosaIN4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J0KG0k1k;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772549818; a=rsa-sha256;
	cv=none;
	b=2BOzqhs5PjjqpQ45oPlT4Yu+fF55AlxauXa6OFmXsq5DEhkzPKDaMjFfwNmcumo9OAS4xv
	2JgkP1ZzBkcb35pLWAniPAbmomHvDMqHahLbnuGAxp7wZtm4AO6urQve/JwM4HyZwOROps
	1+hziTrS6sEjXRlJOrM02wzDhedCE9g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1584043F22;
	Tue,  3 Mar 2026 14:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CC0C116C6;
	Tue,  3 Mar 2026 14:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772549816;
	bh=YDDRbdkOmZu4woFY/biSTxPY9XVlmlte9LluXIX79po=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J0KG0k1kdbUbJLb4ilLyBDyMYnY2ac0zwF9AnGwtN08Mqs30xW8p6PTwiRV0xzCU1
	 1WUmDa9S22Gx5SOYFBQJn1CfcX+Arl81UgBduK30jmWV/WjU+A9HnAAcZHuKEMAZrt
	 NDm32zqff115xaiAPy83OAUrSXS1pTMn0kqTxJS3ulhjptOIuVQm4f6BlJZfIB7toZ
	 +V2oljnwyK9K3blbhGzVTagIct4fGIiu81pzZHNcTJp2ERLL4aSfGfZg0SpQIIUo6p
	 duFtMMOIxOrYJyAMZPR7CGFuOQEIXgHMdudxRzHDu6dQyXItPuQto2ZGpcRMR1GNH8
	 mROATaBd/5T+Q==
Date: Tue, 3 Mar 2026 14:56:54 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <46bgg2vwqvmex7wtk2fkvf454tqgaychb7l4odnnrx7svci5ha@vy4b4ophm763>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
 <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
 <de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
X-Rspamd-Queue-Id: 1A432C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: jo5ncn4xbnnhmkuuxewbareh6b8mc7h3
X-Rspam-User: 
X-HE-Tag: 1772549817-298930
X-HE-Meta: U2FsdGVkX1+EGWZ1+l4ugtBkP64ceZgWUPqSbYU9To3f1EF/d26104Md5Ja8iCeOxmQH7Xdgu/KHYd7UnhcZG4huo3S7APRIud7HOkyrkGmK+n/J8eDEaqVX0b155nVEOmr1V3A2xWJxY7wH/qICc43x4SRz62tLPqACeCOUIUOA62jqxOSq8T67iGcecwJpx7j0Aa92g/aW8LTOH0sTRxB3kZho/qJ1Lq+Wlre3YCspi40CHhv28BPLWACmnKOfS2lTGwPzWqQqBsGjnAusOSOc79fNtxkIdh2m1JvvHHAtCO+DgN4qGa5OF/y/mdWeaRGUN5z2wRPZBmRkQIp2aJbd/HCUOwyAr6zd2ex7ergSSr4xEwnVI1v5erlq6kJBxiSkx/K7k8NMc24PWtcqhfQQDgz3eot+uDLcOuaXurrR+nd5iWaK+J+hxgrOPDCESCZFVafk67/W3S6NDs09vQmHP3p/hXj66VDlh5ZzczBy+l1xpMGA1+UouHTAm7clqakT6unCoWBNpBxy5YLeAwx4EtvYMwzH/VCbvOtr97MuwCuNTxJZtIztNBGmMxuW/ZZMqFfpCoHsjJtowMtOArFwtYdOJ71MhNabyG0/GFE8SnhL3RHwTdaBxTRyt1Mw+e9cAZ3UcpUuP7vsAhKhkX1SjKFBhYgSrKDyAVbQrRbi0P00FIFfLkgz8uE8GKruuLFW6HZGCTsX1aSqGA19JqjjVJnRSxEq9bAfAlTX8wsak/MaIOHKbyZuzKk6DHAQvGpFJbXBOjqMrKbLfxhFK6bQFRA6F8XZfdDxFwrA4I0KNPyvHcp/LSVFZk1XSsF/mJkGetemQXuU3llFJo1SREFooO3NzSjMZMp13EV6r545/rNCWtmvPIf+d0XwBMzAjAIFm3hHumIob2KOU2TPmRyWCLIMCDJqHU1joVyr08XDXBDE43S+aAKMgn06UuyRHAv4v2CjnEvaOT4IV27
 ne4Nkm97
 CdcENI/AUepSnhUcj0boOA9cauEzcXI+XlayPBEDd+psLWyouSeKlwU3wQFW82n3Ph5ZV7szB4y3DY1cq5GxKVNq9v9DuwV08XgRdkbn7X/wOAYUQp5TkH/rYO1bwyeOzWmRdEDkywdx02/SfkaWgzQ4OxwyWOxFxCilnLuS3/eRobtXIqUTM3N8MMa67nojBHrOahroaxfq7JMDyjFqaeJB8N/VDOnx+sEmNE4tJ4qdA90KNfyyYA5e3PNK4h//7RXMQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:08:56AM +0800, Qi Zheng wrote:
> Hi Yosry,
[..] 
> > 
> > I don't think we should end up with two copies of
> > __mod_memcg_state/mod_memcg_state() and
> > __mod_memcg_lruvec_state/mod_memcg_lruvec_state(). I meant to refactor
> > mod_memcg_state() to call __mod_memcg_state(), where the latter does
> > not call get_non_dying_memcg_{start/end}(). Same for
> > mod_memcg_lruvec_state().
> 
> Okay, like the following? But this would require modifications to
> [PATCH v5 31/32]. If there are no problems, I will send the updated
> patch to [PATCH v5 29/32] and [PATCH v5 31/32].

I cannot apply the diff, seems a bit corrupted.

But ideally, instead of a @reparent argument, we just have
__mod_memcg_lruvec_state() and __mod_memcg_state() do the work without
getting parent of dead memcgs, and then mod_memcg_lruvec_state() and
mod_memcg_state() just call them after get_non_dying_memcg_start().

What about this (untested), it should apply on top of 'mm: memcontrol:
eliminate the problem of dying memory cgroup for LRU folios' in mm-new,
so maybe it needs to be broken down across different patches:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 753d76e96cc67..f0d55e1f9c49a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 }
 
 #ifdef CONFIG_MEMCG_V1
-static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, int val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
@@ -536,16 +536,17 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 	int i = memcg_stats_index(idx);
 	int nid;
 
-	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
-		return;
-
 	for_each_node(nid) {
 		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
 		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
+		struct mem_cgroup_per_node *child_pn, *parent_pn;
 
-		__mod_memcg_lruvec_state(child_lruvec, idx, -value);
-		__mod_memcg_lruvec_state(parent_lruvec, idx, value);
+		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
+		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
+
+		__mod_memcg_lruvec_state(child_pn, idx, -value);
+		__mod_memcg_lruvec_state(parent_pn, idx, value);
 	}
 }
 #endif
@@ -831,39 +832,42 @@ static inline void get_non_dying_memcg_end(void)
 }
 #endif
 
-/**
- * mod_memcg_state - update cgroup memory statistics
- * @memcg: the memory cgroup
- * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
- * @val: delta to add to the counter, can be negative
- */
-void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
-		       int val)
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+			      enum memcg_stat_item idx, int val)
 {
 	int i = memcg_stats_index(idx);
 	int cpu;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
 	cpu = get_cpu();
 
-	memcg = get_non_dying_memcg_start(memcg);
-
 	this_cpu_add(memcg->vmstats_percpu->state[i], val);
 	val = memcg_state_val_in_pages(idx, val);
 	memcg_rstat_updated(memcg, val, cpu);
-
-	get_non_dying_memcg_end();
-
 	trace_mod_memcg_state(memcg, idx, val);
 
 	put_cpu();
 }
 
+/**
+ * mod_memcg_state - update cgroup memory statistics
+ * @memcg: the memory cgroup
+ * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
+ * @val: delta to add to the counter, can be negative
+ */
+void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		     int val)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	memcg = get_non_dying_memcg_start(memcg);
+	__mod_memcg_state(memcg, idx, val);
+	get_non_dying_memcg_end();
+}
+
 #ifdef CONFIG_MEMCG_V1
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
@@ -882,35 +886,26 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 	return x;
 }
 
-static void __mod_memcg_state(struct mem_cgroup *memcg,
-			      enum memcg_stat_item idx, int val)
+void reparent_memcg_state_local(struct mem_cgroup *memcg,
+				struct mem_cgroup *parent, int idx)
 {
 	int i = memcg_stats_index(idx);
-	int cpu;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	cpu = get_cpu();
-
-	this_cpu_add(memcg->vmstats_percpu->state[i], val);
-	val = memcg_state_val_in_pages(idx, val);
-	memcg_rstat_updated(memcg, val, cpu);
-	trace_mod_memcg_state(memcg, idx, val);
+	unsigned long value = memcg_page_state_local(memcg, idx);
 
-	put_cpu();
+	__mod_memcg_state(memcg, idx, -value);
+	__mod_memcg_state(parent, idx, value);
 }
+#endif
 
-static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
 	int cpu;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = pn->memcg;
+	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
+		return;
 
 	cpu = get_cpu();
 
@@ -927,20 +922,6 @@ static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 	put_cpu();
 }
 
-void reparent_memcg_state_local(struct mem_cgroup *memcg,
-				struct mem_cgroup *parent, int idx)
-{
-	int i = memcg_stats_index(idx);
-	unsigned long value = memcg_page_state_local(memcg, idx);
-
-	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
-		return;
-
-	__mod_memcg_state(memcg, idx, -value);
-	__mod_memcg_state(parent, idx, value);
-}
-#endif
-
 static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 				     enum node_stat_item idx,
 				     int val)
@@ -948,32 +929,13 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
-	int i = memcg_stats_index(idx);
-	int cpu;
-
-	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
-		return;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = pn->memcg;
-
-	cpu = get_cpu();
-
-	memcg = get_non_dying_memcg_start(memcg);
+	memcg = get_non_dying_memcg_start(pn->memcg);
 	pn = memcg->nodeinfo[pgdat->node_id];
-
-	/* Update memcg */
-	this_cpu_add(memcg->vmstats_percpu->state[i], val);
-	/* Update lruvec */
-	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
-	val = memcg_state_val_in_pages(idx, val);
-	memcg_rstat_updated(memcg, val, cpu);
-
+	__mod_memcg_lruvec_state(pn, idx, val);
 	get_non_dying_memcg_end();
 
-	trace_mod_memcg_lruvec_state(memcg, idx, val);
-
-	put_cpu();
 }
 
 /

