Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DE1C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE8B6B0095; Thu, 17 Sep 2026 01:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6D26B0096; Thu, 17 Sep 2026 01:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F41D6B0098; Thu, 17 Sep 2026 01:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8E1D6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:24:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7B4C8022F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:08:15 +0000 (UTC)
X-FDA: 85222072950.02.26A54D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CF6BC40007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:08:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g1jSnoMW;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789621694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxF+quTmMkP88JVINsM1zjO8HUUAwhac5Ig08+pXxYY=;
	b=qgOy3n5u1e3Xu9xKOSad8QZa4mjIMrITD//bOv0obpRJccO04GXxMhkRFsY2lxL3W/zdb+
	Wb+uVDUX7huNAAtzX9LJwa7TyRCMW+75Qucfod8GhMY1PzCe1ahFg6MMS26OKI91PvSRuk
	b3m7HEq8FAAVTeFXXetN+jor9fozHdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789621694;
	b=E0ZiakEXi1aF9eqmnHCY3buANG01jc0vSZz/4iqJOjp1jAsOZcjCFz8NMup9f2gXh6VPwb
	QhnQAaN1fwsTQD5J1Y/r6O887IYS9BCUV4K6ChSFQQlkf4uKIAyR8s5Lojx9CoRpNpfFNa
	5I2J5DY32H97D20C4+2ts8DEl+u2R2E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g1jSnoMW;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 815E441141;
	Thu, 17 Sep 2026 05:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2F21F000FF;
	Thu, 17 Sep 2026 05:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789621692;
	bh=YxF+quTmMkP88JVINsM1zjO8HUUAwhac5Ig08+pXxYY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=g1jSnoMWakdlm2eR7r1XwyTF+mBNmpJp6/UepjWi4ImTULFCe+SnQg/HpKD95NlqQ
	 SQCdCLzKlKGiu6jhqHq9NwS/olHflcEfKa6VOujpPzMeThOjT934m0d8eW5AhH1wJG
	 wZp4HdBatUxRgBfEUZ7Jg0KNgZ9vZJzz9HN3UcFg=
Date: Wed, 16 Sep 2026 22:08:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH v5 0/4] mm: workingset: fix the shadow node budget under
 MGLRU
Message-Id: <20260916220811.c83d7d4e0761f645f3f3808c@linux-foundation.org>
In-Reply-To: <cover.1789096175.git.zhuhui@kylinos.cn>
References: <cover.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h9g88dif9rtf8aofbijz8dwgfx65yn33
X-Rspam-User: 
X-Rspamd-Queue-Id: CF6BC40007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789621693-928056
X-HE-Meta: U2FsdGVkX1+QVMQQ5A1eiTpEJ7V94YzzhI/DpRPyYvqnvLusbNU2wnHKUp8FhU7q/Ffk7pqt741Smb6vhl7Um5KKiykiaAB0wpDgM/hTB47FMJ9aU32/zvCijgG73/8oDNoELcVRVTPKo0DpA0/PlXcaWBCsGubqpfoDBZOBRyPLLmlSzla2Wj9yEhEDvOlxOhYu+AwBQ7RfECG7YgePTbIfHDJABgvRG/SFvwo7QA5Aw7/yVHEV63XsoEPtWnpg+M9RdIQTxi/z44bInC1m72WJpjI3M5ryumOWqoDlru9UkefazXoRnTWZBAaHjLpqA11Gc/aT6guDRnvEdZ7fq7Zb/lOa5QRI6LeIYshNzfko1pwRD71R0pSEm7H1ov39XzSLvQOWljU3UyWFpOsuoe/V1RRd7ZRv2/Jg4NEyWn4N5glUUvhjaOdFx4DypnyYrgq7beVWvsewDzRECidFhoVr+p/yX7C5Dpk0NZRQjMdcAuVFc0oNbJVZa7eShfk6q8U0fpBPaiNj/xRYi10AbcCW8dMFKX0t+IGSWCA/a0UkSlVyj4nYjFPqwW/iOBDwqUOThuvyXQ8JvIObk2BfOr+ul59A1dsDEqrOjnTf6v42IRbOyUQc3062GX0pm2kkDl92C/r0tL3acuEzh7qAtltl/pUkTR3ruYRtD1z0DbORjbDXAxWbshLE/g3oG4ZSrNRRfvrlasiOdsGDuP8XCr4d+JccuPa/VacAN3rFtkMLLMvhmUWjoke9v2+XEKas0YWrpxJOaaSv/tRY1XOIjTCtb+Zycr/negPqxX2W+hdwiWlWYkkf4D1UmcWghfnYebzlJmlnxpVWq/Mo6UBWBQhhBh5oGTy3RAWZimJnGzhRWC/2yQ6m8JjtaKurbDP5UOrmWZ6pz8QeaZ8U7CVB0cYfxH47MK333+VzAy9aM2EVPlnV6qK3/F+s9Z1EIuzdOpTtsLyvjiDhM3HP36O
 rWhZtUgf
 uSoC5HYyeTFkMeTkM0obFDmoc8X9nlkrrYOUzW0nB8lFz+FJnQe0jicO8NYF3mKakG69cGibFNsV3yIPolhiC+Z+dQIFa0BvroB3EDOgpDQjnC0cHA8g4xGniq2rkRkdDPdMNfjF6J/U1RIZaA3wVUHHQEzq9K9D3ZSaSsBqjI/8f9TH6ZEdtFMqKWAwsOj+bQ3r6vz371b2nQNbiM1F2YNTkLddaTUecHTME2xvPfpGdCBS5Xy/1wT026z/tPTCCIYBw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 16:00:47 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") broke the workingset shadow node budget under
> MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
> maintains, so count_shadow_nodes() sees the evictable LRU lists as
> empty and the shadow shrinker reclaims eviction tokens almost as fast
> as they are created, losing thrashing protection.

Thanks, I've updated mm.git to this version.

> Changelog:
> v5:
> According to the comments of Andrew, clarify the performance testing
> section: the w2-file-churn differences are within run-to-run noise;
> w1-anon-churn is the meaningful signal.
> v4:
> According to the comments of Andrew, Fix "follow-up patch" to
> "preceding patch" in the commit message to match the reordered series.
> According to the comments of Sashiko, add patch 4 to reparent the
> non-hierarchical lruvec stats on cgroup v2 to fixing the state_local
> underflow.

Here's how v5 (and v4) altered mm.git:


 mm/memcontrol-v1.h |    5 +++--
 mm/memcontrol.c    |   42 ++++++++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 16 deletions(-)

--- a/mm/memcontrol.c~b
+++ a/mm/memcontrol.c
@@ -233,14 +233,29 @@ static inline struct obj_cgroup *__memcg
 	return objcg;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
 
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+/*
+ * Reparent the non-hierarchical lruvec stats that count_shadow_nodes() reads
+ * to approximate the shadow node budget.  They are not exposed to userspace
+ * on cgroup v2, but they must follow the reparented folios; otherwise the
+ * ancestor would only receive the negative deltas when the folios are freed
+ * without ever having received the positive base, and its local stats would
+ * permanently underflow.
+ */
+static void reparent_v2_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
+	int i;
 
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, NR_LRU_BASE + i);
+
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_RECLAIMABLE_B);
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_UNRECLAIMABLE_B);
+}
+
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	/*
 	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
 	 * to read its stats accurately , and conservatively flush @parent's
@@ -249,17 +264,18 @@ static inline void reparent_state_local(
 	 */
 	__mem_cgroup_flush_stats(memcg, true);
 
-	/* The following counts are all non-hierarchical and need to be reparented. */
-	reparent_memcg1_state_local(memcg, parent);
-	reparent_memcg1_lruvec_state_local(memcg, parent);
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		reparent_v2_lruvec_state_local(memcg, parent);
+	} else {
+#ifdef CONFIG_MEMCG_V1
+		/* The following counts are all non-hierarchical and need to be reparented. */
+		reparent_memcg1_state_local(memcg, parent);
+		reparent_memcg1_lruvec_state_local(memcg, parent);
+#endif
+	}
 
 	__mem_cgroup_flush_stats(parent, true);
 }
-#else
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
-}
-#endif
 
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
 {
@@ -571,7 +587,6 @@ unsigned long lruvec_page_state_local(st
 	return x;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, long val);
 
@@ -593,7 +608,6 @@ void reparent_memcg_lruvec_state_local(s
 		__mod_memcg_lruvec_state(parent_pn, idx, value);
 	}
 }
-#endif
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
--- a/mm/memcontrol-v1.h~b
+++ a/mm/memcontrol-v1.h
@@ -25,6 +25,9 @@ int memory_stat_show(struct seq_file *m,
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
@@ -67,8 +70,6 @@ void reparent_memcg1_lruvec_state_local(
 
 void reparent_memcg_state_local(struct mem_cgroup *memcg,
 				struct mem_cgroup *parent, int idx);
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
_


