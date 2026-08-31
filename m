Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E4F7C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290646B008C; Mon, 31 Aug 2026 12:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3D36B0092; Mon, 31 Aug 2026 12:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38A96B0095; Mon, 31 Aug 2026 12:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDB6B6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:38:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BDD5A35A9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:00 +0000 (UTC)
X-FDA: 85162121520.17.9167575
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 82C5910000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:37:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JYt/IT+M";
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194278;
	b=DHl+l/G9dkI0nKwQTtkiBFti5Rt/BgTddNeG8/AYXWQmBsjeZ4YUkWIT2bSOQY03Q7R4/4
	vLBR8g8/qdkyZGc3uFNDbUCcy0pxNvCQWqNg4rjz38QjMSe6y2ceZq+lFT02A3RHkvfTmo
	G6qXt0CnTReP9594I/U2+/RcQ7AtjL0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JYt/IT+M";
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZzK6JqUVQtEF4ncuPC417FBn/U4i41SWhLzyFT/8Js=;
	b=WCqj3hTdRV4GGO4DoX/YCgwEz/QQw1Ya1TO4+SRQRgbT+DcOXPuS010SBJRyjkxHoWhvSs
	TugxDTOqRSX9Gn2CnuIe1k/tNMu5bGX0AULaxadQshFkbsDsUi7ih04roUjgMcc7EwlLoj
	YXxNhIh/QlSytDUzfnIfhdgo/toMxBs=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7f3f52143cdso2907486a34.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194277; x=1788799077; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UZzK6JqUVQtEF4ncuPC417FBn/U4i41SWhLzyFT/8Js=;
        b=JYt/IT+M8hiYNLhw8wzhYHIGlgOiWWCiRuoynNmOOCGQ+SaAp5adp2fWJIWTbqVQby
         VH8DCnvv1IiTUMXlc3E2Aymgc2VUK7pt2YAlVGPyVLTVACTmg2GQ+xn4oaTvgPnvuGHH
         m+xp5K3i74ZBweSo4JdV5At3SI78isKGZ18/Epn85SG1R0xO7i6QtKZGZIjs3le7EmFU
         e1cnG2m7tZYk0Uo26Ibg8S11gWGtMxDxhdUTpz3HrKGt2RFWgcW9kWpDLXrguwWIBuK5
         c8iBVTJplsjcJKLucgPrW4rivcp+kPXAe/OD+51mAxCKxv4QcFKEyx3kZcAoLIaQ/MQ9
         VTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194277; x=1788799077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UZzK6JqUVQtEF4ncuPC417FBn/U4i41SWhLzyFT/8Js=;
        b=YYGLjk4X7sq7im3gI5x7/u7zwBtvkjsyCAK+8FqecUNwTO8EoxEGHXfRYKrmWZoWRK
         /HFa+Zc3pZ2xIdSGmb7XCbXxPpw58d+y+56AzK1fYB4xGZUC6BxMAQZ7a79eUvezQmCX
         YB2w9jPsQTP06q1+ddEHcOs5VdRUnKyL11okWwfjkfNAAxaRBUwSvXGsgT5SRHLGa3u8
         M4mBnT5Hxh6z/9z5VBSZJeklbPLl6I/bhObyp97CBtZvg546pD+qfealBiVUGy7Mu6pM
         Tp3yBbCdhxIfLLarjjq7byUWH395fJWfnuJvzmb4nYWsPuHvj9/emz+xfLfJS9Z6trdg
         NsyA==
X-Forwarded-Encrypted: i=1; AHgh+Rr6wPiZ3iFFIV9BT2/hqyWky8sb+rHbuPNbqn8OaBrUe1zyQ34DmAsC0jX1PkLAmQys+LVJ/uImLQ==@kvack.org
X-Gm-Message-State: AFuF++k6BK1mj8X6lTzkqBFKiflZ5cu0jAUHkyj2COe0yiId8VjgSTvv
	mD4340REP0Rgep3xELEaN32zXqMFLOivdZvrPhE2PcyhYtvUVivliWiO
X-Gm-Gg: AR+sD12J+7osg7W/Z98oapKtruSoS/RSL0Hrz/hqRItLabLOKuQGJJhX7DNJYAFgRA2
	gxYCs0dqFOpr/fbU9K7tVAV9i+gwxMjYGaBIVfLq2ydKoG4xo6FsAy7Z2JjlE8+lDzrIznGSEMC
	n2iQ5oJ8oIx4DLABuG4sAEPHRX9i1G06uXDyzo9xG9Z07fAp72ZqU3z6+LhjTfSfmbPBwp/Gf8q
	JDFFmBc1/JChAK1fVhyh5urKxuHVvN40ieuYQUI1dqBJc3+/lyP+VMpBkcgB+Y+0sOHLRfJlaTJ
	kuMnsB4aWYEaLMj8+tcBil2hnOq1gqerkYmZe6eqcVKSzVIRIYsG/xTT6f3aKxhYFjCbc5A/Hh/
	IxTjX8+l2AzIUEZYay2kwa5FE64aZKRlaJ0kOhc83AtTMktMXGL9UAfHfUcXhNdiqC5IoQounTk
	SeEqzsffSj1YS4L8eYPBx9T/pf7vrHtu2EVfMyunypT/nBkOvjUpD39jsfyU7GyzoYyTwFVtTPY
	OZxQ5p1aGkxUF+zGg==
X-Received: by 2002:a05:6830:349a:b0:7e9:e288:2b60 with SMTP id 46e09a7af769-7f4f21cb626mr27446752a34.1.1788194277265;
        Mon, 31 Aug 2026 09:37:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f4fa96cf17sm8719481a34.15.2026.08.31.09.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 3/7] mm/page_counter: introduce per-page_counter stock
Date: Mon, 31 Aug 2026 09:37:47 -0700
Message-ID: <20260831163752.2193337-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ej79fybjxeknwtrj78ejce5uyhz7engf
X-Rspamd-Queue-Id: 82C5910000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788194278-962352
X-HE-Meta: U2FsdGVkX1+4Y5et4BUGpnb+e2RqAKyvNPtKLBefwWyfzCHfpF/eDP9Vo3zfa38eHYcGAf6frpCm1McUVhl48nMBu6E67J8QkELAi+wFlX2w8aJjlnPOU/OHIFZPCqBTB6k+OLI3vvJva/yyhoqucgYSkr54pylugBF4akhkajTJkMhJZmOpPEZUqzzV3Y7vnSNm25m8XpiXj7m71j2IfB2h9eQ+lfVyX9jBEHIZdw3rgOq5nWqTlzN8UGCy6gCKAS03RW95FqCuHZigLw7D3MAcGsuj3MkqGrFR0ooDTi8DjO7DvA9K/wAw6bwqnJYOtIYitqcT6nE4nXb6H8QsSIorER5VUv90nj/kyhqASwD/ntiRyIoROcPQ7kR9UJstjx8baO2TaQB865sFg01IeF2Atkn73rKhbgShissWW8A5EwwoM3Nejf7hrlWhfLnMreBLXITuRNf/7mG8aASXmXSkoez65z3ac2JAx3iBoS4xTZHHYoMD9c2BX+eDmygFMytCCaX1XTAIzewm3hlvY3SU9gY9uMsukHRD8vhPFKGQGNa7sBo+y69yw7fTj8Qm/MLDvRW66I4q9m2SjotZDvTtg5Af6ztd5cNrlC1c6NhvYZEZsQ8+B0Mx7HHbkz85npqSKnb8dkcoO0hNFZnZchPhEpPoegUOwGG1ElrXcHE3a4b4MdpERxSRAlu5pa8qZ8AeaFvp/zliuXVULKft9LYcILvCHfq/+lmmUJkGN6AMa8bqppUvfvM0Xe3jAtv6RfGPrTYYFMG7NU/JVLraVJGi0fb0BIOVgRmGJ9iwVb2sPVCtBLeFw0ocC9gxxguOefLUkQhL/nRh0XrUBqtzkO24rGhL/lNJJSl5LMu9HiakfRrGmgzKKaf9IYNk7C7aMp+rYNeCQ+MPpLSM6/2/mKCZqo9cgvoyei4GYUKmYYZBFC9nhXLSWLJt+YTOjxvphOIRsQ1R92a5OXgOOhD
 TYrfiMfY
 3UritNgK89J9X7y6oPnqHvuSPlgTdLUhNQxrQWvxXOgXbK4leE9k7ERUWOCYmzLz/s7auLTfM3vuLju39OHFydh1swaZTAjnWMdrVuIgWvW2AEIeegdFXRCxD79tsb4uyvqJZkONAaLJXYLfGIe4kpckFOpgvnAePs4eE7g0B72QeykOW+fJJVfhUa8r7eHhZh3ZWUX9MyyP82otu6mmXZq7LeVMcXF3PZz1UCPlbl3rpCa1Ue/jEPMh3PnDeHbp44F6wgTuCzMCNuT8vnNcPegq9vY4oldBPJEIjFCXFz5d3tpeT/3Iym1SOLbSV8bQWB5l0AiV1MIVfRMLyWgYiEElLOSkTg7eIa/PrN8LRuyz9cH/YtQ8iHcWXk3UY+HzSVUv0FcTgtHgN7AP4UeztWSChNbfNKZuCVEEUK0ZlYM4k1V/vpsuKNzPIyGnkgGAa3STGOtEdWPtohwCHLqjg9ECpn6v+NX4oVEWBF5YkpbMoWLqSu7k1J202lE8lvZtV1ThR+vC9VAWf23BuhW8M4c7hMeQqSY+jPPcGBLLRUtJpmcwAXs/YLj/r64LD+0oaOMTwp2lN5bYjigjbMAq8sNQqmMhdrIcbeu5H1ytjvzFxCV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to avoid expensive hierarchy walks on every memcg charge and
limit check, memcontrol uses per-cpu stocks (memcg_stock_pcp) to cache
pre-charged pages and introduce a fast path to try_charge_memcg.

However, there are a few quirks with the current implementation that
can be improved upon.

First, each memcg_stock_pcp can only cache the charges of 7 memcgs
(NR_MEMCG_STOCK). When an 8th memcg wants to cache its charge on a CPU,
a victim memcg is chosen among the 7 cached memcgs and is evicted,
losing all cached charges.

Second, stock draining is per-CPU rather than per-memcg. That is,
when a memcg is under pressure and must retrieve all cached charges,
it iterates through every CPU and drains the stock charges of all
present memcgs. This means that one under-pressure memcg evicts the
caches of all co-cpu-resident memcg stock caches.

Finally, stock is tightly coupled with memcg, so adding new
page_counters to memcg is an unscalable operation where only one counter
gets to use the fastpath.

We can address all of these concerns by pushing stock caches down to the
page_counter level, and making each counter responsible for its own
charge.

Introduce struct page_counter_stock along with its allocation, free, and
per-CPU drain helpers.

No functional change intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h | 16 +++++++
 mm/page_counter.c            | 90 ++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 89a083f16fbf7..c1fe331f34e7e 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -5,8 +5,11 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 #include <linux/limits.h>
+#include <linux/workqueue_types.h>
 #include <asm/page.h>
 
+struct page_counter_stock;
+
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field in
@@ -41,6 +44,13 @@ struct page_counter {
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
+	struct page_counter_stock __percpu *stock;
+	unsigned long batch;
+
+	/* make sure the work_struct is separate from the read most fields */
+	CACHELINE_PADDING(_pad3_);
+
+	struct work_struct drain_work;
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
@@ -61,6 +71,8 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->parent = parent;
 	counter->protection_support = protection_support;
 	counter->track_failcnt = false;
+	counter->stock = NULL;
+	counter->batch = 0;
 }
 
 static inline unsigned long page_counter_read(struct page_counter *counter)
@@ -99,6 +111,10 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 	counter->watermark = usage;
 }
 
+void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu);
+void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch);
+void page_counter_free_stock(struct page_counter *counter);
+
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index a934619cc7bf7..3f61eba695518 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,11 +8,18 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/percpu.h>
 #include <linux/string.h>
 #include <linux/sched.h>
+#include <linux/spinlock.h>
 #include <linux/bug.h>
 #include <asm/page.h>
 
+struct page_counter_stock {
+	raw_spinlock_t lock;
+	unsigned long nr_pages;
+};
+
 static bool track_protection(struct page_counter *c)
 {
 	return c->protection_support;
@@ -295,6 +302,89 @@ int page_counter_memparse(const char *buf, const char *max,
 	return 0;
 }
 
+/**
+ * page_counter_drain_cpu_stock - release @cpu's cached charges
+ * @counter: counter whose stock to drain
+ * @cpu: CPU whose stock is drained
+ */
+void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu)
+{
+	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock *pcp_stock;
+	unsigned long nr_pages;
+	unsigned long flags;
+
+	if (!stock)
+		return;
+
+	pcp_stock = per_cpu_ptr(stock, cpu);
+	raw_spin_lock_irqsave(&pcp_stock->lock, flags);
+	nr_pages = pcp_stock->nr_pages;
+	pcp_stock->nr_pages = 0;
+	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
+
+	if (nr_pages)
+		page_counter_uncharge(counter, nr_pages);
+}
+
+/**
+ * page_counter_alloc_stock - allocate the percpu stock for a page_counter
+ * @counter: counter to allocate percpu stock for
+ * @batch: maximum number of pages a CPU may cache
+ *
+ * Failure to allocate is not fatal; @counter falls back to hierarchy charges.
+ * The caller must not (un)charge @counter concurrently with this call, and this
+ * must not be called twice on the same counter. A concurrent drain is fine
+ * since the stock is published with a release store the drain paths pair with.
+ *
+ * Context: Process context. May sleep, the percpu alloc uses GFP_KERNEL.
+ */
+void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch)
+{
+	struct page_counter_stock __percpu *stock;
+	int cpu;
+
+	if (WARN_ON_ONCE(counter->stock))
+		return;
+
+	stock = alloc_percpu_gfp(struct page_counter_stock, GFP_KERNEL_ACCOUNT);
+	if (!stock)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct page_counter_stock *pcp_stock = per_cpu_ptr(stock, cpu);
+
+		raw_spin_lock_init(&pcp_stock->lock);
+	}
+
+	counter->batch = batch;
+	/* Publish stock only after percpu allocs / inits are finished */
+	smp_store_release(&counter->stock, stock);
+}
+
+/**
+ * page_counter_free_stock - free @counter's percpu cached charge
+ * @counter: page_counter whose stock to free
+ *
+ * Caller must guarantee no (un)charge or drain of @counter is in flight or can
+ * start. memcg only calls this once the cgroup is dead and unreachable.
+ */
+void page_counter_free_stock(struct page_counter *counter)
+{
+	struct page_counter_stock __percpu *stock = counter->stock;
+	int cpu;
+
+	if (!stock)
+		return;
+
+	/* Stop greedy over-charging before the stock goes away */
+	counter->batch = 0;
+	for_each_possible_cpu(cpu)
+		page_counter_drain_cpu_stock(counter, cpu);
+
+	WRITE_ONCE(counter->stock, NULL);
+	free_percpu(stock);
+}
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.53.0-Meta


