Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3349A10ED651
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98DC86B0005; Fri, 27 Mar 2026 06:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E526B0095; Fri, 27 Mar 2026 06:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D7C6B0096; Fri, 27 Mar 2026 06:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 739C86B0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:17:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D1461A0F7F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:17:03 +0000 (UTC)
X-FDA: 84591439926.08.54C985F
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4D2B9C0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:17:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n7etKLiZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Goj2w/XvX2fuIVw9KmHpMrros6oROepUqCQ10lc9aw=;
	b=dGTLd7mVTb07AudL8lp2PYWQ4SRYyGjWkvpJcWeexEjRgyZJUNAnYVRFAKEcsw4XoImAFS
	y01T58U3VqeVUMrWg+/Nsx106SBmOWWMaTsPX8PxRuOBZDDeTfPd3aGt2nXCbd0SHQH2Z7
	XDygG4BiRRiVlu8Ewu3nU33GuZ4/qmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606621; a=rsa-sha256;
	cv=none;
	b=rBpaI5IaC0yTnPDCwp/Nquw00y0DG5W3gTwxA82qjAZ+16TC54ByilWIgZv6zAXEoYWXqK
	vqfj/dgZG/dBdX1RIbTEQjrLyw0a7yvNA/M04prVDuLHnvXkHugsSboD7SzBW3LmzSe4h/
	9j2SRH44hBINYfckurjMJXwmEYOfhgA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n7etKLiZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774606619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Goj2w/XvX2fuIVw9KmHpMrros6oROepUqCQ10lc9aw=;
	b=n7etKLiZxHhpFOAJwSDC/lgn1t/0yHC/rGmzxUeTDg/IPtxY7A79rsV54HZBom8pfN2fQN
	Nm7TSdTkpDI2z1ZgpgHOqU7amDU9vq8fqcgoOt1HWv++g4L/0DLzFZtFbE+uuYeg7fiA1m
	vBWkW8nj0VfsYJKwLT383Mfn8Qi5UAQ=
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
Subject: [PATCH v3 1/3] mm: memcontrol: correct the type of stats_updates to unsigned long
Date: Fri, 27 Mar 2026 18:16:28 +0800
Message-ID: <a5b0b468e7b4fe5f26c50e36d5d016f16d92f98f.1774604356.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774604356.git.zhengqi.arch@bytedance.com>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4D2B9C0002
X-Stat-Signature: tr89ndw5bo8eg6cgsz78eqx5qqfxre1s
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774606621-603496
X-HE-Meta: U2FsdGVkX1/F3dOyWuilkHWGAB9ulH5IrX+KzXdQi3/SgSDnaiyhZutzuiNYo2zfJzZQm5rUd0/GvUQi7r41FHNVpEHAowh19oHZWUqYesTaIE/V5Y4wjEcKyTDjafCq6rljQbFIScbs6EEcea8ldVw4wphxrBdFy6GHqKWYk9gP+qJ3hgGU8YXw2MiLfFMVo/z+FXu3PYK5FnEPvhdP3zoIdTFUBSh0Wdzc9boyFF7xmY3jxnBExTIeAiYsj7uZ0mww8IiNysnEYqcIEoUJMOf9sxPhOnBqvs4ua/zqNwBRbfDWF4YtiImOVudBm1C7fFGWbo3/4qdjKW/2+GgOsqAN2Ov/Pk+a+p39kmPOLJjBWLOMa1FhdjqXpIydWb7XRhdqpC/U6AYazo8yRIb6rBy98RczgpQGPg++q4KgD+mfZ+LXpTddiHOGN9DRGaOuf47n1VOeR3srj2M9IhilnTtBYhA5XxLN0N4U1HEAFgiynwh1p1iPNHOQQrnCPh+dJpAhPz3jwHw1K+jLTAScaBtLsTKadxbhEKKu5++vQtwxUqiaXy17Eed6F+RD1NZQ31r/M43V3PsQdUmFyUvIOyyAefOPt2h3fpNfsFZtWsrR1Zzb9O/foXFlDxdYfx/PThHi1H7++eLKuhc3nAqKq8vBeCM0FEWNSAO+2gP91GO2xM4r2YTUqRgZIH0D15dLTrNsDnBax/JLpPN331q+EFrhqV8qJfLjNYWrM6WYZ/gS2LHP93DkQzq3oe7a/rlh0T4nkGWVLnzeQxOdBc+WL6ZMrekBtSCHel5q0/YbbFhAef0W5ApDUcPBSBIDiDdQZ/IFJGu1OivZT2dCgoOran867L43MBr/Zz/KvmBVUvqPBiccxoIMQA0Uw3ypXjm4gZrBV3X9qqgAJfaomeRZgo5dzqVGaOSyMjFinbDFUCMEKU07NTPkNmGrVny3CiqGTUaREock+x/vlUXKYA5
 3ELN9f6i
 FV5fETbJgFqq97J0GG0CVUKEYxHOzK9Qf14i+/5r9zzUE5j2Max/+SvwR1MydkqCrlk0+4QS+XJJBeN+J7b2sVBnvBuRN3Illxso+eE8mP/8omyCkEXLmMLFuaeuwS1AspxOcCy2jbMpLZL/7A8Zt16TK4tshvJhs0Ii0VLheoUgvOblcz97mhO0wAbeYBt4++0dxbGCgfdL0+9OUWKr5BCYx7y5vLzPl8mOg+RQC6xmkFWauWxb8qOnHZW+1u+lI/vRXoxsJF65BaqOrtFjMtSIK3JvHpaAicqSr
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
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/memcontrol.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac7b46c4d67e4..3daab9b46429a 100644
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
@@ -4446,8 +4446,8 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
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


