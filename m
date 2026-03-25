Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2C9106B53F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842806B0092; Wed, 25 Mar 2026 10:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A046B0095; Wed, 25 Mar 2026 10:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757126B0096; Wed, 25 Mar 2026 10:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 635806B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:14:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D3581A0972
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:14:07 +0000 (UTC)
X-FDA: 84584779734.12.8DE6D04
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5521640013
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:14:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpnBZ0C6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448045; a=rsa-sha256;
	cv=none;
	b=b3hFEE4w2krKZDlb6cRHxEvK8WI9xA9QM/8ABMZAkEk2LIla2JJEcJ/AsvBN5rLXBS5d2O
	TSIu87pswtVxP3imDt9qI4usiQNMuft0DRV9TV9qZsE9qBGHY759IzUN4IC+oTk1loqdZW
	oqYho2czNwpexEljodjXPzD3BwO1ZjI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpnBZ0C6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unxX+YCaGOR4hMqvOj24eLc6KtUp2XUHiBihi+jpnkM=;
	b=1S2/t4EUfFOcTM4n76u+oWpjHf8HjHRF4pLxHrV9pukJ9560zZ/sCC25HMuIAcQDfbu/jz
	H/4uLetGN/zU54UT03hdp9S72BaVIK0GIwSe+zAq1tKwy1pGmHTgAkIeXPcWfI+YtomrJK
	6g/gIcDEsGLSJqtBVRzBoeO0BbT6YJA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774448043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=unxX+YCaGOR4hMqvOj24eLc6KtUp2XUHiBihi+jpnkM=;
	b=mpnBZ0C6cRs98GwpxSR2ONoc2LqnKnFzoIwX0CLtPwEVxLHw5GMlQ9nhNT+CDUNCR1jFkO
	OtCAl7FFMI/9yUQgxx5N1xcQtVlah9thpFUIGS2TjReEE17oFpVkupBqaDxiagMKeLZSTT
	VVVnZ5Fiwi4DCrTZeR56zpikeDPY4Bc=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
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
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 1/4] mm: memcontrol: correct the type of stats_updates to unsigned long
Date: Wed, 25 Mar 2026 22:13:22 +0800
Message-ID: <158fa0b1296168047342f02050e9d2bda6888d27.1774447069.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774447069.git.zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5521640013
X-Stat-Signature: 5d81e9u1econddgfexnnasfaihpmmni5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774448045-723903
X-HE-Meta: U2FsdGVkX1/3TbaCWAfAZKgyN7ICAyxper3O/IrqLwDU8Xm06eMFJcKTmNflHTwwWrL4qo+00PeQRu14lxupS5xIW7xUoTb9TNRuC6D3FUgfz+h3agUMOAGPWtiUAoPxbI5Gd48SAvfvaTw+dGiWVLxs5nFXzb85NErb+IOrHTRR2PRnCzuyKhxY2nDqjC8iREzqInuamXbp5mjatRhEllEbtgJeLHXFdzUbTmqvLv/PwKFhUHhh0ipslZS7lnvU6w/nvrlJKO7RycEdE2JUZJrT3WYkFSiyV9SOPQnAIzOdH7ge7tMRfp7s6zTI7C2UnXDD7IDtXqDpUXZoxWhPNH/PZvumqoLYylFweWEUckXhqLdzL5Ut/2tA4nVI99aHHvaMeW8n+lZiRX+MLfwOiJMoZxyBamwl2mvZD6lstvmgu4pJW+YwJFNqOtPYxq0PxLkX7XG2SzGk7qxOYr4pR1RcLyoztzm30AKZcJUooDQZj+6xMXdxxDLvWjNuXcMKt9nUoDMlF4+B4WAy9GFkERzxb5ChogT+OKAIkpLedDB/tYigFKeqrSi62Gft6T58T5RmX6y2tBxZdoST5AQ2Q5VX34PvDx9a/VaNRr01zd6fvxvwSDInEvoW07FmKMvTC3omaQGgHnDdyJFBLNkurQ4S8c9VvB+pBfq2dYU4RAZ4hquyS+Pq16Z0CfYkB+qKHgqOI0VXNzWFvb41r1b26ADS7o8fZvlo2w55t9uYqbM42KydI3nq7Q8MIPepPejwzQDKew6HgrbcYeGyw7Xtu8B1BUotrN0j2ivXEkk5gWJDSJZBFs3eUqNGOEtMoTJ9HSuWGDFadTufc+A37QLoxXkkhdtU8uysGwVaV7ktfn6pB56YXIAlpv2AXCG6OkzPpLYYBqmxIbhMOkQKKimH3EFY89rLNVHywv1WhH6TtucE0jVXr9Prx6Tkm/pfH6anP0Em13SVb5L0SqtkCJ6
 eSoSreEk
 ISOsQ3twYg4yEbi1AV8fhbSSxblVMMWvFUJhqORD8LV3bHUJ2OoELMdqqCOY4I37UxvU8J11+FoR0trJiy+2zCJRUwr3Gnjt76SXeaewVEXE0xNfVwSOdDQWKH79kunp8QX6ngh1unC4dcvS7cSMVM6dnK51AVq61TrFIPLFqLgsPXsPtrv0Q3kMMnzV/3c5AJ0SzkboXqKjkSho1X/4x9BmHrO0UJ5ji8MIVc3LxritLcYe0pl6SHW3rnRePoMRDiC5I4ahsJ1NDl1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The memcg_rstat_updated() tracks updates for vmstats_percpu->state
and lruvec_stats_percpu->state. Since these state values are of type long,
change the val parameter passed to memcg_rstat_updated() to long as well.

Correspondingly, change the type of stats_updates in struct
memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
atomic_t to unsigned long and atomic_long_t respectively to prevent
potential overflow when handling large state updates during the
reparenting of LRU folios.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f1..7fb9cbc10dfbb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -608,7 +608,7 @@ static inline int memcg_events_index(enum vm_event_item idx)
 
 struct memcg_vmstats_percpu {
 	/* Stats updates since the last flush */
-	unsigned int			stats_updates;
+	unsigned long			stats_updates;
 
 	/* Cached pointers for fast iteration in memcg_rstat_updated() */
 	struct memcg_vmstats_percpu __percpu	*parent_pcpu;
@@ -639,7 +639,7 @@ struct memcg_vmstats {
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
 
 	/* Stats updates since the last flush */
-	atomic_t		stats_updates;
+	atomic_long_t		stats_updates;
 };
 
 /*
@@ -665,16 +665,16 @@ static u64 flush_last_time;
 
 static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
-	return atomic_read(&vmstats->stats_updates) >
+	return atomic_long_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }
 
-static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg, long val,
 				       int cpu)
 {
 	struct memcg_vmstats_percpu __percpu *statc_pcpu;
 	struct memcg_vmstats_percpu *statc;
-	unsigned int stats_updates;
+	unsigned long stats_updates;
 
 	if (!val)
 		return;
@@ -697,7 +697,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
 			continue;
 
 		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
-		atomic_add(stats_updates, &statc->vmstats->stats_updates);
+		atomic_long_add(stats_updates, &statc->vmstats->stats_updates);
 	}
 }
 
@@ -705,7 +705,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 {
 	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
 
-	trace_memcg_flush_stats(memcg, atomic_read(&memcg->vmstats->stats_updates),
+	trace_memcg_flush_stats(memcg, atomic_long_read(&memcg->vmstats->stats_updates),
 		force, needs_flush);
 
 	if (!force && !needs_flush)
@@ -4406,8 +4406,8 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 	}
 	WRITE_ONCE(statc->stats_updates, 0);
 	/* We are in a per-cpu loop here, only do the atomic write once */
-	if (atomic_read(&memcg->vmstats->stats_updates))
-		atomic_set(&memcg->vmstats->stats_updates, 0);
+	if (atomic_long_read(&memcg->vmstats->stats_updates))
+		atomic_long_set(&memcg->vmstats->stats_updates, 0);
 }
 
 static void mem_cgroup_fork(struct task_struct *task)
-- 
2.20.1


