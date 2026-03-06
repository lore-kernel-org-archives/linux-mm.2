Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F46DF513ED
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 00:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050396B0005; Thu,  5 Mar 2026 19:51:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40206B0089; Thu,  5 Mar 2026 19:51:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75F66B008A; Thu,  5 Mar 2026 19:51:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5F4E6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:51:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 655A1C185C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 00:51:23 +0000 (UTC)
X-FDA: 84513809646.11.D223C2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 961BA40004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 00:51:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xsQ3RRU9;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772758281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOiMZwz1xnq0nx/TFLYOj8SvO7Te4pTWi/YlrxysVhs=;
	b=ajW6et2zFav9aRdL5/In/2UqW91rS5eHaGoiBFEzCJgTnAm6yzexjTCPsb8MDdy7lGxxMX
	gw0d48t9ZIwy5mQnRmrxwp39jmbyvH7FhUnsfevPSsGgB/wWWAfXaLUkCto95Tt087S6hY
	AUJ/ot9tJh3zJP998Wi0YuCQ6+qFzQc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xsQ3RRU9;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772758281; a=rsa-sha256;
	cv=none;
	b=Kq1Xf7SxxRiHVHjC9heIPZUUqCctBlRETgHplFKFL+J5mPq1AO85Vf49Nrser3/wKySEAT
	chHASZC64p2pAGTrRw1GDAxTpNxTYip7DSEmRXYcJezUMOxaJx3KAnAhIZc8jSmgcF8d46
	Gcj4AREMC/klK56tLjccg4skvllBrGA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52E73400A8;
	Fri,  6 Mar 2026 00:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F46BC116C6;
	Fri,  6 Mar 2026 00:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772758280;
	bh=I/BWr/0mA1g8/sbDHYUZiwRMeSm+NWbDKYSZFZTO4DI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xsQ3RRU9VHWVxisor/UYVoad0VPyF40BQePhkZZlongLargaRVbJpy4ll1hJcJpYG
	 uUM3qylVY1DIxL/4r0sQ2KzwOo/C1AJZkWTzXswFmSgdAhKnPGTglRtFPdVoUdnm4r
	 K6RyzCGxZH8G7WELzz98N2cfM488udhsxHIqEV/o=
Date: Thu, 5 Mar 2026 16:51:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 00/33] Eliminate Dying Memory Cgroup
Message-Id: <20260305165118.33c0af5b7742e18f18b7231a@linux-foundation.org>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 961BA40004
X-Rspamd-Server: rspam07
X-Stat-Signature: 9197ta4yn9nxao77c3dzb3u664z3i5x7
X-Rspam-User: 
X-HE-Tag: 1772758281-696201
X-HE-Meta: U2FsdGVkX1+o3b+CMUxIRdq0AKKB/KaTb59b+wwjQowOBCCA2peCULJJ7XICpzpPq/2yjpLIVArS87W5vfynnznYJvob+SGbpikVlfMg84reWJMP5Q+Hl+25kr9KmZN3ny1VO+J3Wi+eH2qxreVMw6j+brXXLqODe/0+VBnkZVge2fk6AXtbYUyRHBTVuyvrUF/Cdlt1U5/7GiL/AKoZ8UJ2KC7CMgdl98Y9QaHPVWlWp21wAOR1CW7IXK7RuOmV95SOfZB3NeovHob97mtgX16uZQeLcSz3OMAWu5U8w5WK8PY9jo17L5DiCfmdZJb9yJglKd+9pAv9rGa0pIHy3viGHmDWF7lflY6wLPSkgKsKBCSq2Mq0K9Xi2Yi1ZBtNqY/sVrywXH94AbI1MztTfCZwgGkkEM4mj6j+zzy5dRaNq9/rwsQwOXDAX4xU9VqcYzhbPjVcC4PoILwDTHndDOIhNByx1+lw1rTgpLn//WteFrIxUqaya3+Y4TsxXSdA2uSg7aOJvwL59K/t66J7vkhVSWjpTdO2HOH0/vPWdgu2XDzRr92PyUl8QHi67BnHtsdgiCbxP677Y88b74VIX8cZLbWFrTBgqjKd9BLL78IE9msrwxIU7O9b31hBUi0WDitNqaZ43jkryrcaJz+wAavRLxFWr27zDEeBJWaXUEySjyniKbdhG0Z2/XfDWvfAW4E3K7ll3DDDsaX3veikg+iQSoo7HuloDscv3NHjKzqaNTCxtYck87862qqQ8PwNrmnaUDqLaPS+QBcLhNp3PQqSup+BeUQgzJGsvSdJETTqpEF1HTrVnzwAAaX+BkhJN06/RG6O7j4vSebcq1jvNaNlgdURV7YhttkjT1Fls9w14SC87nzNAhp32cUB6Cx6yH7F/mFfGmcdnsi3h8nYEwPxpF5Wug6JS88l43HEPIsArb0iNQ80RBdW8tCkbxfefW+DBb4H5CoUs3rFYWU
 m8NbrzCM
 Au6WW/hON+oeDGCCUF5rO0tx02VK945bXAODUABVsgpQEwJ9zuX76jacnVg3gzLdbcLJYrZ4Y8yauJfK04Kok87XBAJJ/P3y4TOtBxAeWAAJVKLUj5Qf22MZhiKr0FjCYHW0PnWOAjCjTKgD15Mkc4u1lF4mFY28l/ORaPpsCK/5IZqWOYDS710jcJPd5sys3X/pR6RwZ/IiDSZK1oGjb3gZ80kiaXcXYggsm4w/r07W9Pz+0klBbJKTnUKaKWtOrQ0PC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  5 Mar 2026 19:52:18 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

>  - refactor mod_memcg_state() and mod_memcg_lruvec_state()
>    (suggested by Yosry Ahmed)
>  - use non-atomic method to reparent non-hierarchical stats
>    (suggested by Yosry Ahmed)
>  - remove the redundant declaration in  [PATCH v5 29/32]
>    (pointed by Shakeel Butt)
>  - collect Acked-bys

Updated, thanks.

Appended is how this update altered mm.git.

Hopefully we'll be able to move this into mm-unstable (and hance
linux-next) soon,

--- a/kernel/cgroup/cgroup.c~b
+++ a/kernel/cgroup/cgroup.c
@@ -6043,8 +6043,9 @@ out_unlock:
  */
 static void css_killed_work_fn(struct work_struct *work)
 {
-	struct cgroup_subsys_state *css = container_of(to_rcu_work(work),
-				struct cgroup_subsys_state, destroy_rwork);
+	struct cgroup_subsys_state *css;
+
+	css = container_of(to_rcu_work(work), struct cgroup_subsys_state, destroy_rwork);
 
 	cgroup_lock();
 
--- a/mm/memcontrol.c~b
+++ a/mm/memcontrol.c
@@ -526,25 +526,25 @@ unsigned long lruvec_page_state_local(st
 }
 
 #ifdef CONFIG_MEMCG_V1
-static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, int val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx)
 {
-	int i = memcg_stats_index(idx);
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
@@ -830,39 +830,43 @@ static inline void get_non_dying_memcg_e
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
+		       int val)
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
@@ -881,35 +885,25 @@ unsigned long memcg_page_state_local(str
 	return x;
 }
 
-static void __mod_memcg_state(struct mem_cgroup *memcg,
-			      enum memcg_stat_item idx, int val)
+void reparent_memcg_state_local(struct mem_cgroup *memcg,
+				struct mem_cgroup *parent, int idx)
 {
-	int i = memcg_stats_index(idx);
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
 
@@ -926,20 +920,6 @@ static void __mod_memcg_lruvec_state(str
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
@@ -947,32 +927,14 @@ static void mod_memcg_lruvec_state(struc
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
 
-	/* Update memcg */
-	this_cpu_add(memcg->vmstats_percpu->state[i], val);
-	/* Update lruvec */
-	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
-	val = memcg_state_val_in_pages(idx, val);
-	memcg_rstat_updated(memcg, val, cpu);
+	__mod_memcg_lruvec_state(pn, idx, val);
 
 	get_non_dying_memcg_end();
-
-	trace_mod_memcg_lruvec_state(memcg, idx, val);
-
-	put_cpu();
 }
 
 /**
_


