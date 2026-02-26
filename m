Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC1CCFD8FC1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCEC46B00C0; Thu, 26 Feb 2026 10:17:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C556B00C1; Thu, 26 Feb 2026 10:17:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E7E6B00C2; Thu, 26 Feb 2026 10:17:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 954B46B00C0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:17:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34633572FA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:17:06 +0000 (UTC)
X-FDA: 84486960852.21.8ED45D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2E4DB100006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:17:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=guLzeONK;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772119024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kov3j5zPQMyTNWP+qINsSwoY/CmNqJJ92uzSo9lapX4=;
	b=eF4+pPCnpYywTlKc4D50agye3MXMrffQtk9xDtRjkidlk18HZDtLRzeVC/FWHu7AR8Nhu7
	7BpursDYXODIMmpG3L7SFD34ylsPZcc1fCeyFiUnujYIxcYLI7RYxFM7FAu5TBTRcaxmFx
	sLWDLFESx90eCBcNiAjy+dxGuA5Fksw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=guLzeONK;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772119024; a=rsa-sha256;
	cv=none;
	b=jIqT2AcVfRjxyYz/XPrCv4BMxoihJgOGfeW6nD8xivenXgm53620cVRbHHvVoxKrKkegvP
	cb1UE/clzXBObXYcjD51XxSBDGXUwKPNE4/fwg6g9YYbYKe0m2IS7/E3bjlPZ2e2AtjBss
	ux1cHC/EXE/clu+j0J+M+LVqVgplO14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A56544580
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2C9C116C6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772119023;
	bh=ZfKOiFMxI1AUZBKl1/6wIBin5AjCjKFiRaNVEE4xNNM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=guLzeONK+GX1ZARHuAjqp3AuE2ZdTLF6dUwHjGWqr0CGTuA/8UGt4lZwgoEMPHyuD
	 qePC21AEXifEckAy2ol1AVRj3G2VlF+9tr2bK4F9IsCZVU4eMM70LE/EEnJdBDigJw
	 2k3S/v7rthqdjmxXuXo2ZwBdlHTtUPjyvqbiCHRA9csnhkxroBeTXFvJfokEoIIxhr
	 +XdLsTeiH2xR1YqixOBrMJTM+uJvD4xFJsU82aNOaYHjDrV0ecMhIYpKF4ZQo9T9he
	 TE6+v7GMY9tQP0qI+CferBOZAYkmRwD62hEq5Yxp2XowQgcxpm3wqBL+BmimHplm/x
	 dw8YCccMFiW6w==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8850aa5b56so156526466b.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:17:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWRupnt+oWDExw6nGAHB7y4waodi1gR4iBredh1CoezvVvEAOF7AYo/lwQuY33b+ry3ZLkwfM7R5Q==@kvack.org
X-Gm-Message-State: AOJu0Yxl7rFlcomr0IhZw9q8YlhLCuMsjtTbLlfrxr33jYfk8hUeMrkn
	eNy8c9NsNTU9sBMZ+/gDD5e3SKbRHdHJjRHdAFeHau2HeoMkzwvLMu3Te/auVfGhWJSCaEMFbAu
	it2DvacftqQTzH7rrvDoyDry88QE4eks=
X-Received: by 2002:a17:907:6d1a:b0:b8f:ccab:a344 with SMTP id
 a640c23a62f3a-b908199ef63mr1373906866b.14.1772119021523; Thu, 26 Feb 2026
 07:17:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com> <aZ-R87JfacQ2gGq1@linux.dev>
In-Reply-To: <aZ-R87JfacQ2gGq1@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 26 Feb 2026 07:16:50 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
X-Gm-Features: AaiRm51ckbGxYZpsUeJsgBHqqSKUBYiDeW5PPTyqteMx0y9DdmIndToJpPaCT48
Message-ID: <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E4DB100006
X-Stat-Signature: w4qmwzswkrun5dr3eogha5pikmewudyc
X-Rspam-User: 
X-HE-Tag: 1772119023-599631
X-HE-Meta: U2FsdGVkX19OVBOpbs9YAUiwVbJcsAhk/1etJyZJQmC5LzMz6ylg0LPzP/K5Gd3EaeEnuX+HotOE+N6EUacs32b+z/rPrrmMDF40vPdIpwPr0UsynorFPtJuikcEK4rEQT6jQLnrHJin7x1yV5/5/riZrOsRZ4APPtGK8Ep3j197ll5wAxWTpPp2jUdFv6zuRX5OiCg8f4TVX8bp3e3eUuKn7pdiOFPhXXGW/iIA2AvXJPRdPBysyLOx7sQnOuCpnbITJM0wwcsxJEupnJ5ybd4NfKrdtLeQA50yWLJTe2spa85jNzKOeX60Xbwz+ug8R78DfvKXzyWqfxSUb8MuWXAKs/wB2+w/bgNYk62rFJsvuj8Tu8wDx8a94DwaulTGdeJSgWkqSGUUyDCICBDTKys9awQCMQsf5GTfFxjNVHK9erI+uAWg0PijbxsKDcGQUkgZlPYJqs8mFfhgdQsIhnGvjld1h4jd3JMaB/VXTqWFFIuEHt6foEHkTLeN5GX2GPboEJNLBt7BF31/aaedcUn7fGDjsfZ697OvDbEOT3p0DPw2vcPVHmzuc8yhwKJ7r2IjjTUAiu3aqVrxP/VFcez7R3JgUQrHRA2wGsh9mbyFgp/wBoqxJg2INI7Ym4mlKDJLy4pQj9FcRFfYCig2mUMff9uAvF7qqv2FvHaPcRGcLIcjQYPVHrZ0B9fasYCuMQrislizevftCvSHJN43jdSQk/P6G99KLzrqfOsMCfgrwS9gm7rF0Ka8rXIa7oyqPaKrSBsMTyRYH+7d4LkJo0suYWtvwA9ZX+58DEASBboFUIsTDqFB2cO3U8ChKW4jW2kibbLh71GIqjRHXEzPo47QkcDN+Ga9FoBs+OWB5DshjkXS6XziknbCHL21bChYKPN41+FR9kgRCrgbYA9tIgorLOUTIlzR4eLlA211EmobtVn2jdwHKdGtT0z7V63pgYA6FNYHaSFBr+CX6MW
 /Z1lp4tg
 +lnyXY/n7HaUgcIii/kdT/bz0UWN89TxqAa8M3i6GH6/riHXfKJtG9p/8GdsWDPK0ZvtHyPUCcwTie/2SB+P8vj/ULek1WcDoXKfxTMeytkCG7cKuSCS6sN7aBgO3j+4VmLTUcJ6r+F8EVB7rKfb9/FvEwnlZMehsc2NWSo3jRg4z5Q+V5181F1ir33M/JV852ak0nTGQGvxqt6gUw0ZIEC1E9ffaGEfahVx9WgoeSW8oMLdyY+mFL6z3Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Did you measure the impact of making state_local atomic on the flush
> > path? It's a slow path but we've seen pain from it being too slow
> > before, because it extends the critical section of the rstat flush
> > lock.
>
> Qi, please measure the impact on flushing and if no impact then no need to do
> anything as I don't want anymore churn in this series.
>
> >
> > Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
> > will update the stat on the local counter and it will be added to
> > state_local in the flush path when needed. We can even force another
> > flush in reparent_state_local () after reparenting is completed, if we
> > want to avoid leaving a potentially large stat update pending, as it
> > can be missed by mem_cgroup_flush_stats_ratelimited().
> >
> > Same for reparent_memcg_state_local(), we can probably use mod_memcg_state()?
>
> Yosry, do you mind sending the patch you are thinking about over this series?

Honestly, I'd rather squash it into this patch if possible. It avoids
churn in the history (switch to atomics and back), and is arguably
simpler than checking for regressions in the flush path.

What I have in mind is the diff below (build tested only). Qi, would
you be able to test this? It applies directly on this patch in mm-new:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d82dbfcc28057..404565e80cbf3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -234,11 +234,18 @@ static inline void reparent_state_local(struct
mem_cgroup *memcg, struct mem_cgr
        if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
                return;

+       /*
+        * Reparent stats exposed non-hierarchically. Flush @memcg's
stats first to
+        * read its stats accurately , and conservatively flush @parent's stats
+        * after reparenting to avoid hiding a potentially large stat update
+        * (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
+        */
        __mem_cgroup_flush_stats(memcg, true);

-       /* The following counts are all non-hierarchical and need to
be reparented. */
        reparent_memcg1_state_local(memcg, parent);
        reparent_memcg1_lruvec_state_local(memcg, parent);
+
+       __mem_cgroup_flush_stats(parent, true);
 }
 #else
 static inline void reparent_state_local(struct mem_cgroup *memcg,
struct mem_cgroup *parent)
@@ -442,7 +449,7 @@ struct lruvec_stats {
        long state[NR_MEMCG_NODE_STAT_ITEMS];

        /* Non-hierarchical (CPU aggregated) state */
-       atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
+       long state_local[NR_MEMCG_NODE_STAT_ITEMS];

        /* Pending child counts during tree propagation */
        long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
@@ -485,7 +492,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
                return 0;

        pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-       x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
+       x = READ_ONCE(pn->lruvec_stats->state_local[i]);
 #ifdef CONFIG_SMP
        if (x < 0)
                x = 0;
@@ -493,6 +500,10 @@ unsigned long lruvec_page_state_local(struct
lruvec *lruvec,
        return x;
 }

+static void mod_memcg_lruvec_state(struct lruvec *lruvec,
+                                  enum node_stat_item idx,
+                                  int val);
+
 #ifdef CONFIG_MEMCG_V1
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
                                       struct mem_cgroup *parent, int idx)
@@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(struct
mem_cgroup *memcg,
        for_each_node(nid) {
                struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg,
NODE_DATA(nid));
                struct lruvec *parent_lruvec =
mem_cgroup_lruvec(parent, NODE_DATA(nid));
-               struct mem_cgroup_per_node *parent_pn;
                unsigned long value =
lruvec_page_state_local(child_lruvec, idx);

-               parent_pn = container_of(parent_lruvec, struct
mem_cgroup_per_node, lruvec);
-
-               atomic_long_add(value,
&(parent_pn->lruvec_stats->state_local[i]));
+               mod_memcg_lruvec_state(child_lruvec, idx, -value);
+               mod_memcg_lruvec_state(parent_lruvec, idx, value);
        }
 }
 #endif
@@ -598,7 +607,7 @@ struct memcg_vmstats {
        unsigned long           events[NR_MEMCG_EVENTS];

        /* Non-hierarchical (CPU aggregated) page state & events */
-       atomic_long_t           state_local[MEMCG_VMSTAT_SIZE];
+       long                    state_local[MEMCG_VMSTAT_SIZE];
        unsigned long           events_local[NR_MEMCG_EVENTS];

        /* Pending child counts during tree propagation */
@@ -835,7 +844,7 @@ unsigned long memcg_page_state_local(struct
mem_cgroup *memcg, int idx)
        if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n",
__func__, idx))
                return 0;

-       x = atomic_long_read(&(memcg->vmstats->state_local[i]));
+       x = READ_ONCE(memcg->vmstats->state_local[i]);
 #ifdef CONFIG_SMP
        if (x < 0)
                x = 0;
@@ -852,7 +861,8 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
        if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n",
__func__, idx))
                return;

-       atomic_long_add(value, &(parent->vmstats->state_local[i]));
+       mod_memcg_state(memcg, idx, -value);
+       mod_memcg_state(parent, idx, value);
 }
 #endif

@@ -4174,8 +4184,6 @@ struct aggregate_control {
        long *aggregate;
        /* pointer to the non-hierarchichal (CPU aggregated) counters */
        long *local;
-       /* pointer to the atomic non-hierarchichal (CPU aggregated) counters */
-       atomic_long_t *alocal;
        /* pointer to the pending child counters during tree propagation */
        long *pending;
        /* pointer to the parent's pending counters, could be NULL */
@@ -4213,12 +4221,8 @@ static void mem_cgroup_stat_aggregate(struct
aggregate_control *ac)
                }

                /* Aggregate counts on this level and propagate upwards */
-               if (delta_cpu) {
-                       if (ac->local)
-                               ac->local[i] += delta_cpu;
-                       else if (ac->alocal)
-                               atomic_long_add(delta_cpu, &(ac->alocal[i]));
-               }
+               if (delta_cpu)
+                       ac->local[i] += delta_cpu;

                if (delta) {
                        ac->aggregate[i] += delta;
@@ -4289,8 +4293,7 @@ static void mem_cgroup_css_rstat_flush(struct
cgroup_subsys_state *css, int cpu)

        ac = (struct aggregate_control) {
                .aggregate = memcg->vmstats->state,
-               .local = NULL,
-               .alocal = memcg->vmstats->state_local,
+               .local = memcg->vmstats->state_local,
                .pending = memcg->vmstats->state_pending,
                .ppending = parent ? parent->vmstats->state_pending : NULL,
                .cstat = statc->state,
@@ -4323,8 +4326,7 @@ static void mem_cgroup_css_rstat_flush(struct
cgroup_subsys_state *css, int cpu)

                ac = (struct aggregate_control) {
                        .aggregate = lstats->state,
-                       .local = NULL,
-                       .alocal = lstats->state_local,
+                       .local = lstats->state_local,
                        .pending = lstats->state_pending,
                        .ppending = plstats ? plstats->state_pending : NULL,
                        .cstat = lstatc->state,

