Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63149CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F2C6B0108; Fri, 26 Jun 2026 06:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF856B010A; Fri, 26 Jun 2026 06:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEDF6B010B; Fri, 26 Jun 2026 06:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 165266B0108
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:28:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83BF6403F7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:28:42 +0000 (UTC)
X-FDA: 84921690084.09.53A979A
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by imf21.hostedemail.com (Postfix) with ESMTP id A6A2D1C000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:28:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469720;
	b=MrfWAerRM5lOD3ao2RcuDCeBTJhjrX4fjQrJ5lyHfA1k/s7KOdW4vdsy6heKZvyUK75roc
	iRwVuGfEjZzFOAmlV0qi7R2tS9B8Mjn+65n1cyd0l8+9lWVa6y1+d70B7kqKIqk+MsV11p
	RejsCLNztyjrkmBHT5gShmV99U8GTFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zNmutVevFROVWVFlOe8iAyV3H9Xxv4R/Io9gPw1gnEE=;
	b=jEmRqUaSNXBlq0SFy0vbFkj0SL/xc5CDx4y5Ci6tpTzyCMqzMBQLJXB4Q/0afAkFCY4AsO
	Q9jpoEIAce6jgcRNrQONdw8GA+6+Ovart31+goL7MXFXm4cUhv1YKqP4KaSSbeKiLuvwit
	p8yitBjT60Vo/d6cAmhx79yrnPd+tjA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id C680A3E97D;
	Fri, 26 Jun 2026 10:28:33 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 4/9] mm: percpu: Split memcg charging and kmem accounting
Date: Fri, 26 Jun 2026 12:20:53 +0200
Message-ID: <20260626102358.1603618-5-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGnYIDq9A11TftEatbke2wSLsM4U/RRnbCHpAUAIQBwHbVmowa+ke86M8Z6PPn5o7UKBvUMbr2gZWgcRiFc7ixLzqgLUvmoF1f6yq0GAxvM7ym0xa3n5f10aBqF/6aF0YuddnSkH5x50aCnRuJBlmRRybtyRnTHEtDjNABLsbF8/J37ko6Bm3zG+eW4NfAtWrkoIM0OVuVjH1i1R2t7kHuPQJtjQvB5ayDwVI8gcfE8wIDI8ctauyWpfQVDC9X4EX6LKQuBwn+BvrBeBO0dxg0WQvW3qtFakFlV8vs7Ehg02InoNEqwXY73y16xKIg4BKzVJqVRXZF2evXpKGHtjYSRNxlbUiwuS2sOBwb5wzBvPVvTjrFl2004zwsSACTxdhfQeaavFBDsBF/b3hO966Jk2xT286aRYLCJv6XwNbFEkAfxCaBELfb9yeTEv+1sqCgoZ0XBPTFLOkXm7zqbESobHistHSi0hRUaSIx9L7tENTV9ORLM0vsetphGk4KGc5C/n2ebSZtv4nRM5KVpX3vblXPWGGn5TDd+TjYRALl4wWch4Sqf6eVD/d0rtPP660OvESHW0Y7XELo8EckP8J2Ajbj4waaKFEqb5ifOJcGIODUI1k0zpSRXko+dJ2mRwIidMIWaKZILquumPc3Ip5SsGQ+sISDnb13Fg8RlO3qHxg
X-Rspamd-Queue-Id: A6A2D1C000B
X-Stat-Signature: bba177xpnybm4m1pntj9k3onrkccfryq
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782469720-918455
X-HE-Meta: U2FsdGVkX18T7oZoiLu4yNl/rcmi5RUir17tkjGDyWnQ6CA7f3+ArKakh6TZtIfdAd7I0wkCnaSUF+nDm5O9TEEzt6zbke6gCSTZ/25xvfJk1r/6gsbVF7iJY9Ijq5eU0QWjmaSPvALL5xDXJfB+y95fCc7iWjpXhFkV7o8ty4cfk9erZHfMTn9nQMXY98sJCIDItIwWlxFnWwIdMhhEBeUUMbV2LwQIkUOf3BF4h2REx2kPLn+JxPvLPj8PBYyoLg4KtI7k1hM7U5d2LMqdsPv1Hq773ONuuhUVyF8qo4vAGgTCGwCEdqN8CvigQ7NqGtehsuN1FytBG22CcGq2EXyUH6k+VDLxVY7CCdY5sE0Zpn1WuNq1v1dTUN0zh2qk36kP7MQwO1lo6R50DzhNkX+L5OxU61IwHRBjBk+xEr9Jt7fnRh7e4BSb6es1FL87mAzEkUvIIoxygD0CgfOQaSad27ItzhXCgSMXJ+L7Imu3sY3C3NkMcwk3b5KMu1AO/ruOmnZizUG+3cJTS2J6IgVjGt6e1GrBuO7mjTNH4PwXqhkno1iy5kj6NCCtJZpZmg5E6siAZiXJ2SVtt3HMYmcX7CCxv+vkwWn7f7suakdTVjrvDkinA3OFBNezOjTJuNbAAkFhWyhbELEUdxzDnucmOTj4IpaxOeilgm9vp/UmYO56k72sDANmQ8sVk4XiOqtssw5ORJR1RJFk8xJjZjdSBzjd7f+I7+gBVSCGWvkA7YM4Jd4Sa+VgWUEAsLltjb11nWYX7Z1EH9ycinbtIpAQn7WzryTZSetyeDOfAzGLXyvfnX7kyKx4MkTL1trCykhfzcmdvmceZIra7uzEExBZhcmNnC4baDTwD8dF6NL2CS5mWdPiVvM6CaUnb+dq1Jxf1uMX6L7Kc+NgC8hKenCIUZ803Y2wsp/jXB32q9K0XHqvCGQvZcuKBzwGyS2/XU4vE7DiBqiLYjHotqU
 hT7kZZi5
 CVeHx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is preparatory patch for upcoming per-memcg-per-node kmem
accounting.

Percpu allocations charge memory before knowing which NUMA nodes the
pages will land on. So we need to decouple the memcg charging from the
kmem accounting:

1. In the pre-alloc hook, obj_cgroup_precharge() reserves pages for
   memcg limit enforcement without updating kmem stats.
2. In the post-alloc hook, obj_cgroup_account_kmem() accounts kmem
   and places the sub-page remainder into the obj stock after the
   allocation succeeds.

Because of that decoupling, we must not rely on the stock in the
precharge function and always charge the necessary pages that will
be accounted after the allocations happened. That means we may
temporarily overcharge the memcg but the obj_stock draining will get
things back to normal.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/memcontrol.h |  4 +++
 mm/memcontrol.c            | 50 ++++++++++++++++++++++++++++++++++++++
 mm/percpu.c                | 15 +++++++++---
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..8f419ee54510 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1704,6 +1704,10 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
+int obj_cgroup_precharge(struct obj_cgroup *objcg, gfp_t gfp,
+			 unsigned int nr_pages);
+void obj_cgroup_unprecharge(struct obj_cgroup *objcg, unsigned int nr_pages);
+void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages);
 
 extern struct static_key_false memcg_bpf_enabled_key;
 static inline bool memcg_bpf_enabled(void)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3bcc20e72914..480fba12a217 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3536,6 +3536,56 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 	refill_obj_stock(objcg, size, true);
 }
 
+/*
+ * obj_cgroup_account_kmem - account KMEM for nr_pages
+ *
+ * Called after obj_cgroup_precharge() when the allocation succeeds.
+ * Accounts KMEM for nr_pages on the objcg's node.
+ */
+void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	account_kmem_nmi_safe(memcg, nr_pages);
+	memcg1_account_kmem(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
+/*
+ * obj_cgroup_precharge - reserve pages without KMEM accounting
+ *
+ * Reserves page counter credits for limit enforcement. Does not update
+ * KMEM stats or the per-CPU obj stock, because precharge decouples
+ * the page counter charge from KMEM accounting (which happens later
+ * per-node via obj_cgroup_account_kmem).
+ *
+ * On failure, use obj_cgroup_unprecharge() to release the reservation.
+ */
+int obj_cgroup_precharge(struct obj_cgroup *objcg, gfp_t gfp,
+			 unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	css_put(&memcg->css);
+
+	return ret;
+}
+
+void obj_cgroup_unprecharge(struct obj_cgroup *objcg, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	css_put(&memcg->css);
+}
+
 static inline size_t obj_full_size(struct kmem_cache *s)
 {
 	/*
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..01c87e39d366 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1625,7 +1625,8 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
+	if (obj_cgroup_precharge(objcg, gfp,
+				 PAGE_ALIGN(pcpu_obj_full_size(size)) >> PAGE_SHIFT))
 		return false;
 
 	*objcgp = objcg;
@@ -1640,15 +1641,23 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		return;
 
 	if (likely(chunk && chunk->obj_exts)) {
+		size_t total = pcpu_obj_full_size(size);
+		size_t remainder = PAGE_ALIGN(total) - total;
+
 		obj_cgroup_get(objcg);
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+				total);
 		rcu_read_unlock();
+
+		obj_cgroup_account_kmem(objcg, PAGE_ALIGN(total) >> PAGE_SHIFT);
+		if (remainder)
+			obj_cgroup_uncharge(objcg, remainder);
 	} else {
-		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+		obj_cgroup_unprecharge(objcg,
+				       PAGE_ALIGN(pcpu_obj_full_size(size)) >> PAGE_SHIFT);
 	}
 }
 
-- 
2.54.0


