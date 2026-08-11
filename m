Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0ECCC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB216B00A9; Tue, 11 Aug 2026 16:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A448C6B00AB; Tue, 11 Aug 2026 16:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934576B00AC; Tue, 11 Aug 2026 16:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62F3E6B00A9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:33:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E8A2A1A01B2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:33:16 +0000 (UTC)
X-FDA: 85090138392.14.826786E
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4EAE120004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:33:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UQ+63i7M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhLQTHM31HiibodbQJGZPDVgE2DmcphLRRks8z+Fmcw=;
	b=ALdSmEqEPOoZLWvHncTftA1InULWVW3TwbIsSMQH7qx9uh+kadWdrgbFsP3AuTkJ4rXy1a
	S2eRznLOP1M8ykVrH+E5jlwCtcAWXwonTSILmLUbY+JhHP0siOcAR7s+IyeKYUM3QZFzBq
	4XJWrDQjROGiECvbj4qMhfkHw56cTM0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UQ+63i7M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480395;
	b=EdVXhnwF4mvHfSwdNAehUiarB9UYcUFuvvi1wYpvMtgPixAzEc97OrDxhDjRIubfGWHXZ7
	DPzw4O7SiumC9/tq/sXkD1fDPpx2UGAW0F4Eie3SA/6uznsqk2IRSkj7PBTdvYPJ7GX9hI
	UkoFKNLztHzGHZ9hi/vSBmK6GSzdMhw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lhLQTHM31HiibodbQJGZPDVgE2DmcphLRRks8z+Fmcw=;
	b=UQ+63i7MGIYBEySTOISWQSlyGmVRykIdbn6QYgoo951mXXsO1jO4SD0VHvfVVsyZivVyLG
	toSZNLG94NUFaJ6zxz2k1cYdeHR2HgeMPTytvvBQeOOK8GquY0fOgUf0MaHDuKkebOfMxr
	heUlhJ7ebcAnlddFji+a+M5Kj+irWMw=
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
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] memcg: simplify v1 event ratelimiting
Date: Tue, 11 Aug 2026 13:32:03 -0700
Message-ID: <20260811203203.3456029-10-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4EAE120004
X-Stat-Signature: er7acdcm3zzrdddd33z8wxqticq8udhb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786480395-895151
X-HE-Meta: U2FsdGVkX18pLdKmWtKOV9fQ7r3n6hLQxHsaR7w7SjclsPTbvvbOKjfG7HwvLUyuhEDWSxHqkI1QE/R65VQueb7+QVHFYAmvpwv0GKWOiQHSNIBEJbsuyUJm7gx73jyP2UWtxkOq3H5//ELEsAtrTo6R+WCXYiQIfhkVfHGH95HjUlD2D8xKibGpyTYlAetqRQfWeKfTzOQwO8C0r1AXr/iWNULm8aHd+AYqwhBf0iNMnsjWBn4Z0ql34K7IY9BlC0BdstK/sdc7en/VZvftkkDQdD935HucNjiBknGuEHzg9BwrTdEnytMNkNBWLp2eBVqSCyrgvKhPPBibdaHy5PeVvu8lIN79AfAzl3DeT9vS3BMous5Uxfmy44WdUK2qu9pnfbSUwoplWpR/2dknYpqm5n6Mgjeo8VpMIpeoXy6jORasP3QUV+qSvuFJEGhM/AFcLBamoeO8gHY6DAdprpLGsNxxXW9fsvOWwru771PluLoEbJujewOdxyAh+8FSdBJfuMkPStBldMN1AAeYBK3dNJHjex0JK6XJeUKacvrqQU7hl1Vx0+OzHB8s9IAj5Cn/bObZum5UeQEHJ+Eb8Y845KDzfv/Ys6bzTQOPaKrc3gJS2ieayXXi00TgWEqzlgmDzCemoumtT6Z2M4hgsxeK1OaycC18yCDF0Eu6jxuUkWwuLXpsd7ueAkDoE4/X1vzSBGRKmuIy1O2otTYd0ayjofmPTyrj4PkQxPylQQMKYlG5CfX7FjuShafQHSCzyWgivUnFlEJKxE12MRrwwXe6AmxwcyDcWa3NG+9cfTDa278ni98KhzRQx3146I4v7aRjtbqX2DkdcC+MNW6fC3YET8uN6jljbI966xlx7AHRV8RUxVLMYF6RGbs/NEYHPRNH7CoMA/qC9EzmLWQSfw3ys+unmik3TK/fR5WYwGKI2v7EO0ATtB/GOu0OiNqDC4uqF9VAj1onfY9xw+l
 9ZDw0onj
 jUJ5yQvfSe5gwqRo5aB4uETqX8OavM559cfJP/pYHNEh6l2vrDSTU1RJjnv7cGzxUt8rQShakmjifMTm9q11yMNjg+R/aDgbacLpSewQ6xPAin5bqNwqJ7CArPeCmYmke+dbuzOtbFJu7+Kvy4bFIpYkmHZAJ5OvtKh4Em1kUvylz3K8CKF3Z1QiBHVTJVprpYX1Db/zTEICWs6E=
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
index ba3ef821553d..44ef376d657b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5293,7 +5293,6 @@ struct uncharge_gather {
 	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
-	int nid;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -5316,7 +5315,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 		memcg1_oom_recover(memcg);
 	}
 
-	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory, ug->nid);
+	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory);
 	rcu_read_unlock();
 
 	/* drop reference from uncharge_folio */
@@ -5345,7 +5344,6 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 			uncharge_gather_clear(ug);
 		}
 		ug->objcg = objcg;
-		ug->nid = folio_nid(folio);
 
 		/* pairs with obj_cgroup_put in uncharge_batch */
 		obj_cgroup_get(objcg);
-- 
2.53.0-Meta


