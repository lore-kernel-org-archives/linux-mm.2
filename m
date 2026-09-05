Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FAEC79F89
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 03:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E6F6B0096; Fri,  4 Sep 2026 23:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6EE6B0098; Fri,  4 Sep 2026 23:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4BC6B0099; Fri,  4 Sep 2026 23:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACDE6B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:05:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E93061401B9
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:49 +0000 (UTC)
X-FDA: 85178218818.15.43550EB
Received: from mta1.migadu.com (out-134.mta1.migadu.com [95.215.58.134])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0A24220003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ENKTF5V4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788577548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXJ9u/uxcNDsijc5/H41GDixo838+SaWhrAkFVHi+Ys=;
	b=c6pahgsRK4IpSG10sxXl6WgBemLL0PG/Lqp+r1+sp9Sr3xZoSbPULlOtONwg/MEIsKLy+k
	csIeeVgvPVf06QTSm2cNHrdFKpv0axTy1RxKE7v/2gmSwU7YMaaq6Sopd/sO5V5OcPEBrC
	zJYPQWJjlVPrg8MwuAHd631JWwV/fyc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ENKTF5V4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788577548;
	b=j3+sy+uqv1yS67a9+Z95pb8daoV8UreSF6yhoy7cqPOAGozp3GkMIq4S/x/kMDLpq26hGj
	KHhTDx/ksZcNOosiJDQAC9UjFJZibVUDzC7EXiVh4rmjWO4eM1YXJDXXH++yt6bSZwYXII
	xNgnXsQzFG3y8egy6wiIBOCilLALJUE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iPlKgRCUUQd3XAlmVdK29edWcfnznhNVidhGTeL5Mag=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577546; v=1; x=1789182346;
 b=ENKTF5V4Ne+I80OH/xVQhbReWdLhttoPnvc/x2gc+Pzbi5EyCc44P1WH7g2avzpbF145w617
 N1LDGuz42r1pCSgqb/ES8DhUTZS9df5F2ACZhA4s52SUa//BP9FCW2MFh54hfP6zqSbVVP8/fN7
 UkjVvJPlRGx3P4AxQJ+92Iec=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 460a9f945d6b52a6;
	Sat, 05 Sep 2026 03:05:46 +0000
X-Mizu-Trace-ID: 460a9f945d6b52a6
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
Subject: [PATCH 5/6] memcg: group the read-mostly fields of struct mem_cgroup
Date: Fri,  4 Sep 2026 20:05:21 -0700
Message-ID: <20260905030522.1887837-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: iqp6frjaur63ii9ys5sgjzky98ydbcg4
X-Rspamd-Queue-Id: 0A24220003
X-HE-Tag: 1788577547-386850
X-HE-Meta: U2FsdGVkX1+FkOTwnfy4adlsAqBRErjotYZOIMVeUF3bo+8LA3VeEbK3pIVQyeoMZ6/e4Wtvx8L1rhr4zsrzMhl8Cd5xTOA+mgfhkaNJvOTtfSwB+Pw2qSje1FhNwC8U27cvjmDtWPP6WR6tCFPRLc2BBj+V8L+NgFIljP4muxkTZGYUJRN31RPM7PUXL32Yk6kLMekm7/4UOldCr8VJ5U1LflOTvOTr1K2SWMwgvHR2AjQ7ZIwW4kZdIzd1sJpuA2+jlAneo/JLeH0ZJS6OAJqRsdKFFAz6Ax+AOKTAHZ8AaHLCYZraSw2m3h+HoOOQba6K6Q9W7/gPl4MJ9IWnokszR01l8+UdeUdnHJcWnC41iJYluo+B2tvmvn+gdzQDdEIlvDyjZvjduYG80zfzSKKOL9UBRccRCAmTF2L4fSaANHmCHQsTZweYK4J41/+JHgfxMkMrLYYVyBvisswuaf+BJa30UUlCJLMi7tOXdo4ICNB6XDhosHwPEDQ2WQktR1xgJMd0xv74xxD+TEAIQLgy8gJPQR3FUXISaBwv9tKlxGOGTPE/wXXgOEqVe00/sb/kTMdDoRt6l08MXsjf1cV8S8fECrVmiXsYSma45/6CCkd8AXKhzD5m64xOZcYVPOMfKUNDnpQpzLFqu/8b0DrUeTyYAyyEd0ubOwQuogZ002KYroKX3+o647gWLvgVB+PonFFl/7e5PYFXO6a6/tjuKd4CMU14UzVjnhNMNtZozlacnVDG03km4pRCcBx6tBuQuzMEmy2Gb6nBygpA7RnThpbdarXr+5KDQdE24H0ED6KiUNrWXvTA01WeGMDn0AebxmP+44aIUoMIR4uD71hcy7SS3QJbxuw7FrQj/LxGzU+Iw7M3o8KWwhURaQqle8KYH1j/b4zkYzcQ1w6uArX+fNlxtFI0YZJfJHlO8HBqQN6/nrIy1XtGD1w4lygAuQaHpCx6Fs2QTpy5ZUk
 GzRZZRxl
 Fgcm1W3WmfEStqHdyUv32Pblz0Z0WYuTzlckQvwuV1rPqhoc66N87Tvne1+QZ7lgdaS09K3m7n6scgWj4VJSjKe6M9RUbA50KkfWnXmEQcvqn7Eqmblt6iOpXid03wyTsxvJtBpDQDedqgrm0VfYn5iV1QpIK27+O9TlqA4Pu/MrxYiFwrOHAT/Fne8TIOb3kuyP5DDCTDNLalCivFiL8pQynq5cRgc3nyx3isggDCbT+rBlFPnfkitulH5pzXW3x3IGrTll8VBydCUkmNtvkHbtX3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These fields are set when the memcg is created and only read after
that:

  vmstats_percpu   read on every stat update
  vmstats
  zswap_max, zswap_writeback
  private_id       read on every eviction and refault
  kmemcg_id        read on every list_lru lookup
  oom_group

Put them in one cache line group at the end of the struct, right
before nodeinfo[]. nodeinfo[] is read-mostly too but it is a flexible
array, so it cannot sit inside a group. The group ends without padding
so the two share a line.

This also drops the ____cacheline_aligned_in_smp on vmstats_percpu
added by commit c1afbd5de131 ("mm/memcontrol: avoid false sharing
between vmstats and events"). That only aligned the start of the
field. cgwb_domain followed it on the same line and is written on
every writeout completion. A group boundary covers both sides.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 62 +++++++++++++++++++++-----------------
 mm/memcontrol.c            | 17 +++++++++++
 2 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 635929a1f13b..d0f3458f9250 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -183,9 +183,6 @@ struct obj_cgroup {
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
-	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	int private_id;
-
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
 
@@ -259,30 +256,6 @@ struct mem_cgroup {
 #endif
 	__cacheline_group_end_aligned(memcg_cold);
 
-#ifdef CONFIG_ZSWAP
-	unsigned long zswap_max;
-
-	/*
-	 * Prevent pages from this memcg from being written back from zswap to
-	 * swap, and from being swapped out on zswap store failures.
-	 */
-	bool zswap_writeback;
-#endif
-
-	/*
-	 * Should the OOM killer kill all belonging tasks, had it kill one?
-	 */
-	bool oom_group;
-
-	/* memory.stat */
-	struct memcg_vmstats	*vmstats;
-
-	int kmemcg_id;
-
-	/* Keep the hot per-CPU stats pointer away from memory event counters. */
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu
-		____cacheline_aligned_in_smp;
-
 #ifdef CONFIG_MEMCG_V1
 	/* v1 only. Not grouped: v1 is legacy, sorting it is not worth it. */
 
@@ -322,6 +295,41 @@ struct mem_cgroup {
 	int swappiness;
 #endif /* CONFIG_MEMCG_V1 */
 
+	/*
+	 * Set when the memcg is created and cleared when it is offlined.
+	 * Never written on a hot path.
+	 */
+	__cacheline_group_begin_aligned(memcg_read_mostly);
+	/* Read on every stat update */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+
+	/* memory.stat */
+	struct memcg_vmstats	*vmstats;
+
+#ifdef CONFIG_ZSWAP
+	unsigned long zswap_max;
+#endif
+
+	/* Private memcg ID. Used to ID objects that outlive the cgroup */
+	int private_id;
+
+	int kmemcg_id;
+
+	/*
+	 * Should the OOM killer kill all belonging tasks, had it kill one?
+	 */
+	bool oom_group;
+
+#ifdef CONFIG_ZSWAP
+	/*
+	 * Prevent pages from this memcg from being written back from zswap to
+	 * swap, and from being swapped out on zswap store failures.
+	 */
+	bool zswap_writeback;
+#endif
+	/* Not padded: nodeinfo[] is read-mostly too, let it share the line. */
+	__cacheline_group_end(memcg_read_mostly);
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b2cc82c936ed..4a5a30439a03 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5779,6 +5779,23 @@ static void __init memcg_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
 				      mm_list);
 #endif
+
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      vmstats_percpu);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      vmstats);
+#ifdef CONFIG_ZSWAP
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      zswap_max);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      zswap_writeback);
+#endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      private_id);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      kmemcg_id);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      oom_group);
 }
 
 int __init mem_cgroup_init(void)
-- 
2.53.0-Meta


