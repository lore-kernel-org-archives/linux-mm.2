Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5973C79F82
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 03:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBA46B0092; Fri,  4 Sep 2026 23:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3056B0095; Fri,  4 Sep 2026 23:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9496B0096; Fri,  4 Sep 2026 23:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65D996B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:05:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D99EE1401B9
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:46 +0000 (UTC)
X-FDA: 85178218692.15.25F9DF7
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5674A0004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U3DiYY19;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788577545;
	b=K80cjQGHx96RMGRFqK9cfc2jdjqs8RPwu+uSTD8NadwpftlP0ruM5fkPEFoXbY2nTctpEN
	geiU0xObCl7KEQSKsB8ZuyBVkDMzz2zbz4IaPkqn2iIR6SeueZPOLPbgMnp1iEHpqKvY7Q
	jadR999xbp7/5QvJkwK791IAzcX8+d4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U3DiYY19;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788577545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xsACVlUt/qLeChj8wnyvLoVOQpUoCMmyTKDFhWuvts=;
	b=D82pZXKQ6zphPFOdjqrzzK9jGFEx5etKF8ZdKVx9dDf1IVuue+ETlwtwzAlEASXHUqomn/
	yAKXYLs8NAewodMrSx8gdE5z8hkAdLoB/ebV4Rs1VfwDfyqfk/G9aXC2T+TErvf96JbsLI
	juECjBUdT3lvuJaUgxnDwFo/eFXpFPw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OCqMxy89FiBT48toG1bb2lBNxftt+Uy3sG/HpFdPjKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577542; v=1; x=1789182342;
 b=U3DiYY19bAXB6/KVr3LU7yjm1cTAB71T4DUya3mKji9CBTaU+wHDZhh6fCiTJgFrcRgpz3iQ
 QPbSw2vzRdCYsD/EYU+MGXip0NNPj/cK5/A2h1//WpUqJjzGo4MjTI5SnXsWC/Q93PNoAgj1u4Y
 LnZchLA+sOn5hVB+Wh794aZ0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 77fe83e8f7634880;
	Sat, 05 Sep 2026 03:05:41 +0000
X-Mizu-Trace-ID: 77fe83e8f7634880
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] memcg: group the write-hot fields of struct mem_cgroup
Date: Fri,  4 Sep 2026 20:05:19 -0700
Message-ID: <20260905030522.1887837-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mmbq1p8pk6kfjyjbp7cxcegrwyueddin
X-Rspamd-Queue-Id: C5674A0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788577544-406571
X-HE-Meta: U2FsdGVkX1/TtCxN+kV3G6cuXgcmxhF08zGLfKDcKjpOBqNFmeuQUo99r6CnzW4vomrxxgWLJwPOWp3waLs/GramU7s8XUhZ3Q5mzFvjxwKs5zpwXt7d/7wto+TBxvo8nsWrkeYi+UfqppE+W8k2jpboZo9K7aQOUvvG+t/t36n7sha5m7WUGSVIfzB3vgJ/QYShGtB2wgm0Qzrt6P3v9D/jJ6cgaYvGnazKGwYI79MBH+N1A4f69OHl0LV9abF2gJyjGjV87ylSxs5KsGtI7Kbhq9aaJym12EFM/kG2y3mXjVwE8tTU6EqN2o3LkIYK/HaCv/X62QS42xy0hUkFq/hwM5XzGd1gjUGH4F7qfmveB94usNS8kl0ep4WfeAzEPGgziyuP3SoWGGUIZyk/dJzqsfn492zLHEdQynM9NZjWm7WqXbzBdZOtAUMei+Pk1F/CKLtt8lb4A7mHGAanuSjtyrBLWm+O47UZ6MlOUAGw3unEB9VjtwaRttrXNtuhUH6gFxLiw3OuOCf+XXTDgEZkRAD4K/jLlgyy1jpHJ3ABycab+De0eF4cOsmglr2srTZXpGLoAFizIrzm20lM6im1hnXDbFTtlk2iJy9DSnu5Zv1mVP6ynxoRW/f5B30ECYYLhI8VjDnvcnm+v6tNjtKIG/NjhzR35J+Al6kdqJ8IaCAo3c4Js4fmNbJ5wFdWEUAkKq/HStIvSHFfomBq8KdePnJZjkylzGZ3Tt5WG7cVLYRssqVqATXHV63YjJJ4gE+eS+cJqIL0cMG51G3IMN1haAiew1WICbbGFZ12IPdogOaX+mudWuKSnwRv6xbRGCy1+YQW5fIsTTrmPQq9Nl/PvLE9PsDIpoIA8kA5Gylf/VtLEAhOd+TmEQgqzNNoC0U/CJmmDHVt94zXs/24h8jI2olgeBoMkm8HtQRhWZQPJC9Ki5qjsqbvRDuoat9xly+cMBxEf/O8qntPDVQ
 Ae7pcl8C
 1NzwDV6PZdKnKintDPmxUXxJqPfRQLjXgQ7n1Q2VkR8Os3n9nXRd6KzmoynjDATgRBLtdZX1WuBskfat4LDY9fee5aaX3Mgp1rF8gpcY62BXcLX3hXrjE4q5QN9BRDj7D5JFtM37TzYAfD94NI6ZUPNHF4GzBh3RwHYN1/e10Z3aWEPHGEavDP8nYS//asi5O6r6oEWKDVWbWLAxaIRHtfM2s7YOCIYSLIEvaZzNeykRv6kpB54jhF9HcFq5uMP0tWnNCHq8ivRULuenKm9HeHSiG2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These fields are written on the charge, reclaim and socket paths:

  socket_pressure       written by reclaim, read on every socket charge
  memory_events         bumped for this memcg and every ancestor, so a
                        busy child dirties the whole chain
  memory_events_local
  vmpressure            written on every reclaim iteration
  private_id_ref        written on every swap charge and uncharge
  kmem_stat
  high_irq_work, high_work

They are spread over the struct today and share cache lines with
read-mostly fields. Put them in one cache line group.

socket_pressure is kept next to memory_events because
mem_cgroup_sk_under_memory_pressure() reads one and bumps the other.

Add memcg_struct_check() so the build fails if a field lands outside
its group.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 59 ++++++++++++++++++++++----------------
 mm/memcontrol.c            | 32 +++++++++++++++++++++
 2 files changed, 66 insertions(+), 25 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46fc99786ebd..32b77ec5ba98 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -185,7 +185,6 @@ struct mem_cgroup {
 
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
-	refcount_t private_id_ref;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -195,15 +194,45 @@ struct mem_cgroup {
 		struct page_counter memsw;	/* v1 only */
 	};
 
-	/* registered local peak watchers */
-	struct list_head memory_peaks;
-	struct list_head swap_peaks;
-	spinlock_t	 peaks_lock;
+	/* Written on the charge, reclaim and socket paths. */
+	__cacheline_group_begin_aligned(memcg_write_hot);
+	/*
+	 * Hint of reclaim pressure for socket memory management. Note
+	 * that this indicator should NOT be used in legacy cgroup mode
+	 * where socket memory is accounted/charged separately.
+	 */
+	u64			socket_pressure;
+#if BITS_PER_LONG < 64
+	seqlock_t		socket_pressure_seqlock;
+#endif
+	/*
+	 * memory.events is bumped for this memcg and all its ancestors, so a
+	 * busy child dirties every ancestor.
+	 */
+	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
+	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
+
+	/* vmpressure notifications. Written on every reclaim iteration. */
+	struct vmpressure vmpressure;
+
+	/* Written on every swap charge and uncharge. */
+	refcount_t private_id_ref;
 
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	/* MEMCG_KMEM for nmi context */
+	atomic_t		kmem_stat;
+#endif
 	/* Range enforcement for interrupt charges */
 	struct irq_work high_irq_work;
 	struct work_struct high_work;
 
+	__cacheline_group_end_aligned(memcg_write_hot);
+
+	/* registered local peak watchers */
+	struct list_head memory_peaks;
+	struct list_head swap_peaks;
+	spinlock_t	 peaks_lock;
+
 #ifdef CONFIG_ZSWAP
 	unsigned long zswap_max;
 
@@ -214,9 +243,6 @@ struct mem_cgroup {
 	bool zswap_writeback;
 #endif
 
-	/* vmpressure notifications */
-	struct vmpressure vmpressure;
-
 	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
 	 */
@@ -232,23 +258,6 @@ struct mem_cgroup {
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
 
-	/* memory.events */
-	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
-	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
-
-#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
-	/* MEMCG_KMEM for nmi context */
-	atomic_t		kmem_stat;
-#endif
-	/*
-	 * Hint of reclaim pressure for socket memroy management. Note
-	 * that this indicator should NOT be used in legacy cgroup mode
-	 * where socket memory is accounted/charged separately.
-	 */
-	u64			socket_pressure;
-#if BITS_PER_LONG < 64
-	seqlock_t		socket_pressure_seqlock;
-#endif
 	int kmemcg_id;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c42297ae3b0e..2e209dedeb4f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5726,6 +5726,36 @@ __setup("cgroup.memory=", cgroup_memory);
  * basically everything that doesn't depend on a specific mem_cgroup structure
  * should be initialized from here.
  */
+/*
+ * Fields are grouped by access pattern. Putting a field in the wrong group
+ * breaks the build here.
+ */
+static void __init memcg_struct_check(void)
+{
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      socket_pressure);
+#if BITS_PER_LONG < 64
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      socket_pressure_seqlock);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      memory_events);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      memory_events_local);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      vmpressure);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      private_id_ref);
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      kmem_stat);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      high_irq_work);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
+				      high_work);
+}
+
 int __init mem_cgroup_init(void)
 {
 	unsigned int memcg_size;
@@ -5739,6 +5769,8 @@ int __init mem_cgroup_init(void)
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
 
+	memcg_struct_check();
+
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
-- 
2.53.0-Meta


