Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886D7C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE556B00B0; Wed,  2 Sep 2026 13:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C56C6B00B3; Wed,  2 Sep 2026 13:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650B96B00B0; Wed,  2 Sep 2026 13:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35CC76B00B0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:43:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C073C1602E2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:43 +0000 (UTC)
X-FDA: 85169544726.17.3CDC7FC
Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	by imf31.hostedemail.com (Postfix) with ESMTP id D909D2000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lrvJDXC0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZeEHCXKwcQMg96HmEQ82WZyZcBTCBFp6hiZsga03Kc=;
	b=lqXiqGyzWzKHOKAApDCWtPlcHfnF9Be0fjxl6Bve2muxOvKaj45G7PnFW6HHZWX3NinOvT
	xhEs+O+4bwEtvPhppvtkua3cd0s/s0RyCjAgA4UAju6iYOpRLgKImjbPiKvQq1DSSqFCXA
	aLaafV09wwgZ78ABJIGLDMQmBHKJzII=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lrvJDXC0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371022;
	b=UPTStuTHWJ1EB1AzDFFE46ktLdShv09FTzCH6j4Yus8dn4e7MzKkjUW6qFrHC8Y5ZG2n6D
	wIdYPnPSHugrMzEaTK3yuDpKT6BM3CR/QJHbg1Bl9EP6JfR46ut/8YAclrsVLeZDmNDihN
	bduTLFB5EJx88Uq2AGHmcvaEDpeMhdE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lrjCYHOcwMy32zOEwRExw4Ntk5Rn48/VDKas/aRCiDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371020; v=1; x=1788975820;
 b=lrvJDXC0nJs+aCSd7NRfT7aybqATfJqcfbjFjtRVnBCiTk9x9tKcMEDhxQlPq+FWuSBudbPy
 mNq1HX9+LHsqUGKGT3M1H/MxyendhoaPECHd4tTfAFYmrMdfyjummbGEGAK83XJGhoHvtEL/dOU
 umj0yL1zwEFDBpTa1L/UwFsg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9d2b252c45d99bda;
	Wed, 02 Sep 2026 17:43:40 +0000
X-Mizu-Trace-ID: 9d2b252c45d99bda
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] memcg: simplify v1 event ratelimiting
Date: Wed,  2 Sep 2026 10:43:11 -0700
Message-ID: <20260902174311.1772372-9-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D909D2000B
X-Stat-Signature: ihuzuna4q76z469i41he4wordw6ehzou
X-Rspam-User: 
X-HE-Tag: 1788371021-986756
X-HE-Meta: U2FsdGVkX19W9iJylhhq44O3ac96EzneS6V3+4ObJlHSh/EJBmImyjcNq/RbkkVGfRlOdRKqwacpa4sa9KTzILIUimY4Zw85HUWOLwdZiDAFqPLpe9LsVeNuDrT2ieZ98ZxZWOFsaRFy/Og+/gtfJ29PlqI2et53xAp64g2cuNTuIhz52kFGm8JTX7DjJ7RgCIQ24sChZhqkPW7NBc+F3eEinVDey8R7U+9aGeZd2zZGxzxwaeE4AlHHhANRGLJQcozYZNkJhA254wER1o2TbiLAhSkOqFSD9w3al3fMYtHnll6mgfA7YUdYcUQgyvxhWuhSk/kx8AruoTBLwe+ezXCXmTYgadIvGFFE2Aokp1HKYKhdiDbtQ0PYOZljqyCC8AxuGvAiupSRxS/vlKwZw/negtTX7oaE5Mh3l3b5yHljNlh7hXCWSP+EdxsRD3iTq+VTyAvwpIVounlWV76TKjnUS+52J12xTbFuyXJEvKt5BdM7cRo4kqloVzyX1Hs7dol/17p59UWg19glCVTMkffaviNukFZtUVHGb4Q/VwVTE/VJd2aZgpkHv+PcC5kw8ltcwBzcWfuE2Kfi8M2pABSbVqB8k/Yh5Dr0NX+y15f8eL8J9l03L3pkXh9CqgNPbgvpUuhivGfPmAro0K9pfVfBNi28F57VhdX/6B9v0eSyfqZDzw+cDaONXoZ9DqoldPq9mV2q+Q3dkcd1kiiZpvxJWki0aY3YN8ecUBNqJyedPUD01X1uTUyk0u4fKwT4CbYpVNLnRiG1/HlhX7wz/e+saXaquZuhPY+EQCxKiBbVbOXIYPwh95TUfOluoAXT5FThtFpXmYMeGz+gXk56DhcbxiftaLu/HzOpxnfH1ooMO0+RkpO33ylRWgZg8h/5l92nTe/9BjtqvMefKOebPmgEkzsNa50BWoXTUlD3sNGVHe844f/ul9ClYCUdtkOiiq6dcA51I2qDL3v4jOz
 WQiBMQpk
 vqSNfFbidw7UaPUSC6wlA8EdXIhDFgSlQRvCoqowH9P7sN7XWTqiTiy1otlvPwmTG4+ol89BCBBmgGyi87WVBmS1nIxmT48YXKatlfAmWZtmruKadkvonJJzMRAjrwQ927yU2vM1ELk5cs5DEIbE0wF/zjt/DcTvJI3v75hux7+z6hdiSjSDXcNO/nJZ9OGtg1xysF1Nt8xrWrOnDwr7pUWmRpqQP3w7J/7I1Nzcmr7VOWqFqv4SzU22y5Q5bYaOVlsw4CKeXgNwnP92cpV1He7F8S4iGUW6ijLy40ijP3MZkt04VxfuNVAb/Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thresholds are the only periodic v1 event left, so the target enum, the
per-cpu target array and the switch in memcg1_event_ratelimit() all
collapse to a single counter.

memcg1_check_events() no longer needs a node id either, which lets
memcg1_uncharge_batch() drop its nid argument and struct
uncharge_gather drop the field feeding it.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memcontrol-v1.c | 43 +++++++++++--------------------------------
 mm/memcontrol-v1.h |  4 ++--
 mm/memcontrol.c    |  4 +---
 3 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 475f998b7643..bf2c7d53b01b 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -200,15 +200,9 @@ static void mem_cgroup_threshold(struct mem_cgroup *memcg)
  * to trigger some periodic events. This is straightforward and better
  * than using jiffies etc. to handle periodic memcg event.
  */
-enum mem_cgroup_events_target {
-	MEM_CGROUP_TARGET_THRESH,
-	MEM_CGROUP_TARGET_SOFTLIMIT,
-	MEM_CGROUP_NTARGETS,
-};
-
 struct memcg1_events_percpu {
 	unsigned long nr_page_events;
-	unsigned long targets[MEM_CGROUP_NTARGETS];
+	unsigned long threshold_target;
 };
 
 static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
@@ -225,43 +219,28 @@ static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
 }
 
 #define THRESHOLDS_EVENTS_TARGET 128
-#define SOFTLIMIT_EVENTS_TARGET 1024
 
-static bool memcg1_event_ratelimit(struct mem_cgroup *memcg,
-				enum mem_cgroup_events_target target)
+static bool memcg1_event_ratelimit(struct mem_cgroup *memcg)
 {
 	unsigned long val, next;
 
 	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
-	next = __this_cpu_read(memcg->events_percpu->targets[target]);
+	next = __this_cpu_read(memcg->events_percpu->threshold_target);
 	/* from time_after() in jiffies.h */
 	if ((long)(next - val) < 0) {
-		switch (target) {
-		case MEM_CGROUP_TARGET_THRESH:
-			next = val + THRESHOLDS_EVENTS_TARGET;
-			break;
-		case MEM_CGROUP_TARGET_SOFTLIMIT:
-			next = val + SOFTLIMIT_EVENTS_TARGET;
-			break;
-		default:
-			break;
-		}
-		__this_cpu_write(memcg->events_percpu->targets[target], next);
+		__this_cpu_write(memcg->events_percpu->threshold_target,
+				 val + THRESHOLDS_EVENTS_TARGET);
 		return true;
 	}
 	return false;
 }
 
-/*
- * Check events in order.
- *
- */
-static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
+static void memcg1_check_events(struct mem_cgroup *memcg)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		return;
 
-	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
+	if (unlikely(memcg1_event_ratelimit(memcg)))
 		mem_cgroup_threshold(memcg);
 }
 
@@ -271,7 +250,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 
 	local_irq_save(flags);
 	memcg1_charge_statistics(memcg, folio_nr_pages(folio));
-	memcg1_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg);
 	local_irq_restore(flags);
 }
 
@@ -344,7 +323,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	VM_WARN_ON_IRQS_ENABLED();
 	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
 	preempt_enable_nested();
-	memcg1_check_events(memcg, folio_nid(folio));
+	memcg1_check_events(memcg);
 
 	rcu_read_unlock();
 	obj_cgroup_put(objcg);
@@ -398,14 +377,14 @@ void memcg1_swapin(struct folio *folio)
 #endif
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
-			   unsigned long nr_memory, int nid)
+			   unsigned long nr_memory)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
 	count_memcg_events(memcg, PGPGOUT, pgpgout);
 	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_memory);
-	memcg1_check_events(memcg, nid);
+	memcg1_check_events(memcg);
 	local_irq_restore(flags);
 }
 
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index f48d0e22e615..b9a21f0fd2c3 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -59,7 +59,7 @@ void memcg1_oom_recover(struct mem_cgroup *memcg);
 
 void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
-			   unsigned long nr_memory, int nid);
+			   unsigned long nr_memory);
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
@@ -107,7 +107,7 @@ static inline void memcg1_commit_charge(struct folio *folio,
 
 static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
 					 unsigned long pgpgout,
-					 unsigned long nr_memory, int nid) {}
+					 unsigned long nr_memory) {}
 
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bce3962dba57..30636b9d9673 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5328,7 +5328,6 @@ struct uncharge_gather {
 	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
-	int nid;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -5351,7 +5350,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 		memcg1_oom_recover(memcg);
 	}
 
-	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory, ug->nid);
+	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory);
 	rcu_read_unlock();
 
 	/* drop reference from uncharge_folio */
@@ -5380,7 +5379,6 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 			uncharge_gather_clear(ug);
 		}
 		ug->objcg = objcg;
-		ug->nid = folio_nid(folio);
 
 		/* pairs with obj_cgroup_put in uncharge_batch */
 		obj_cgroup_get(objcg);
-- 
2.53.0-Meta


