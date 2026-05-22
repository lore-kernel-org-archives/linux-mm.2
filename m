Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E50DCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B8C6B0096; Fri, 22 May 2026 18:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB56D6B0098; Fri, 22 May 2026 18:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB036B0099; Fri, 22 May 2026 18:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC976B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:06:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52AE8140A80
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:35 +0000 (UTC)
X-FDA: 84796440750.20.2DDBD7D
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 760074000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JQH1RAcx;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDRjwcWKT8jzrOHACXaQIaOyyT2TFq8Oufd7POOepxo=;
	b=KL9JTJ5oy8mviMo8Lc+56LaPTmIXJiSDshH7qW+4rhNMFZ9AgouR/4JMgKb35vLIHBvYzn
	a9cjNb1jpS9tm7zobl4t03uvty4KkD/+X1BMeGsICTD/MNLx5vPKBOX3O38yGVc9+Cbb3q
	VwMBPfEU3pnm5wKAI5cEPn49NDXzlMg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JQH1RAcx;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487593; a=rsa-sha256;
	cv=none;
	b=KXo5kSVDGEH6iwvZyAc88mV5OhWCgen/NEZ8iKSA2I4lkjF0qVoUqibsQn6xC5w9SsSnpI
	e/vNsfphJuk5ZTloVggvJyD3lD6NKah94j8QTQ7XFyBGzoLMlF34O4hUVwTXX8wfnrXDIp
	tEZGtvuQZJkEr0rH+D174HLf0L9YvO4=
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-479d85152c9so2991254b6e.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779487592; x=1780092392; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDRjwcWKT8jzrOHACXaQIaOyyT2TFq8Oufd7POOepxo=;
        b=JQH1RAcxVdX0bslNsIW8jmwT5B8im7rR177U1Kh0UhnmctLMFzGbr31Kb/HzsjxAbA
         BROH45n91Ho3ScIyKaQ63Gbzq2x9lVUm8bpdG5qraWO47hRdzgbZy/JaB+Hct+P9xQQ+
         eNylhs6sWnwt9ypJ1Esn0qXk+YCt86Zm430gHt/3sIZvbqcaKlOAY5nBOqAL9cCGxodZ
         0+nNNbfvAvJvMGvoqYRW69mXSjLdAZpx+NYvnisNX2fk1noabK5pAWbknzUHJ7dHXaL4
         LNdU4o48sAb6JFUROAGT6fMEsRLqX7YYv/9P8jHVgSmZTxFLAN1Q20YjO32PoK0b5J3W
         2lGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487592; x=1780092392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RDRjwcWKT8jzrOHACXaQIaOyyT2TFq8Oufd7POOepxo=;
        b=ZcUW5hiHcXfUrqqqdGYTz4h7mCiJO4MLpigZO5/KH8ZSAWPieipP+hY1me0Nr3qpGC
         Cr43o5NjPkN3A7G9P6vVtabMhFBH/gQDSd9uJ91cBOk2bIKYkQm3b6+1dcL17pSZ8r5O
         PKetUohAJ7XjlkIUvZ+YwGn1pFsaofcXjIjUYt4759SgWUgf6FQGCvc+kJLNVrOxcUwD
         ljRWJELS6CtJTU8Ptpmslyiyc4viSD8iFtjNBg2VpuZdzN/Yk3/L7qSHss4nyzAwGpo/
         H34kjzWhhGBDWEiZYzQTnJuvWDoBnvASDNuXIGb8Ez/7WbKJbx5DD69bfc+WnTso0sOp
         rbAw==
X-Forwarded-Encrypted: i=1; AFNElJ/6YU8JTQxwE/9j4PurgiMw0i2+PCIDwygL9gEsWoKbXW18A1R1oGSn4qEAMPvVZ7SZZC5F5MD55A==@kvack.org
X-Gm-Message-State: AOJu0YxlDccJADRDFIzbI8QGORqJ7OevYu4t3oA43Nn7wV9FmLeciGuT
	nuI87zNqmxxSIMRr/vZPYvkX0LGbZ9KoBeA83ScspjJMf3mFkhwIiVl0
X-Gm-Gg: Acq92OHlBUPG/BQ80t/2VdGvmALjPmIEFBEF6iOHlbk2o/XEEDjiri24pdbpEd8CdB8
	QQaRH42Tfvg55p/R0rb9Ffb864JOGO7rkZ4hxfRVay0n0Ruqbgxi9jfgyQ7S+NNdGYrnXNvgQD+
	kCLsskPY8O8AQqMrFODySXt+23occCZyiDmtAwLFXpWHgDYucbeZY2RivjdCl+E4HaAR8Rmpxbr
	eVGJFjlv/AbRvwOzxr0qSNFxw+r5ceIKBY1r8e6/nycGEo1ybFbXPgAhRbFBo7ZUvzmclFKpVBF
	avk13znKQx0bRskuAiTyo5eTIzFzQqCi9pE9cXbesvK1h3ki025nBOvJj9TiCYjpxo6gCGznUl5
	u5a9LcUVwQ9rWKlbJVHxCbJsWiJUpQye/kNJbYq8sRlQL9+auUC19OE5TBUT7a0e0QXkoOAe3qU
	ebihCO7ZrsSYUa9A+xw+/VwY70Ohe5KKXm/3wwUWvN7iFwYNZpcx4LUg==
X-Received: by 2002:a05:6808:1387:b0:45f:12bc:4579 with SMTP id 5614622812f47-4854a0e93c1mr3205060b6e.19.1779487592420;
        Fri, 22 May 2026 15:06:32 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-485546edd14sm1199998b6e.10.2026.05.22.15.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 15:06:31 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 1/7 v2] mm/page_counter: introduce per-page_counter stock
Date: Fri, 22 May 2026 15:06:19 -0700
Message-ID: <20260522220627.1150804-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qtw5mfunocxes98xbugioyoumwx6btuc
X-Rspamd-Queue-Id: 760074000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779487593-969197
X-HE-Meta: U2FsdGVkX1+qnm1aFuoxzdHIfPYaxwGULE7DXgb/LfEQ7c8QnaTHrACWmFgmM7buK1QGCbSZfIvgKZENOZjMwhkjBQdz+BfbOZJFAZO/+zhw1f11OBhPF/qwrAB4xOkTsN1a4F3ggjARuCXoY3GnN6Yp61hZkF5Gy9roi1laHQLIRNoiM9+MHxsx6yTpPVqLDlbGP6r1HuTQ78AQzoi519bqgNC9KYLBE/EbItQpj/NbIxr6Cs5akLSvi30lCC35HiUx6f4/c0XrFskZDrmOw6zxvYTzcJmL07Vd+0vocXg1B5VK51X8pOW+5hu5rM1SKZ+N1LI7CsYXPSX/y6OayQ5r8swlT+gTc3OE6vlSpClpSbb3veOgJ8bUEAaR9pDpDUjWQXuLHL8ki30rRY1OE5zDKAWfsBvF2Gtc4zHnusszxZLkUqCpNHNcLDMc1RmZwz1PlDPFt8SYaXYztWNKHIEeUlEz8flhB2DDqIenczOFcJqcOaW97Z+pfqJWgXNRuW/4S0EY8YnTI0DtNDJIfTDipvpE+oNkaFwau1h9fUI+qIWDHDjkn2xkrw6mWwEbQ67n+XfevUrR5EEC0MYDdjV+71bflDJD4lf6W8HHVPfQzg81vq8qjkuc5xRhkUgU3jX2PjPN7XPg43I8HKAb9MjlelGGmkriyhedAfDHhANPrR8V1ay1xYW2pzAM71ZpJE0zlRJK6Eh2hQwDHp5jCDWdaPSDWvyY3sANv+ti6gIxOLM0QsnlRIdyWntjitsvxLTQ/j9SwFpp+tms7Xa2ZD3w7UGdNfaV4gIUnLuMVrkSR6wlESErYZuR8FQr9GtZAS/siPmry5Y0BzWDjK883VMGVsIq87yvx4gUqFGZhmSTQGReKDFDufIl0aqYeJryk0XsqC4VxU8GlUH0flNqdo2l3tWH05pZsQAuuP4Ycpilf1YoM3Gd5iE4iy+F85lwUGfMNlKRaisAICVlMsw
 1eVLnZJC
 cPLxg3bwV1IDwLdhLe90quCpgM/xUUTV4fenlAMTwHlUwaNFswjxl5XuNqepsq7VvhtGGN1yPMKmyCfsgUXnmls9Wv944UamaTN4l/J0u6rOXHe/iyUW+j8bqNm0Lf5ofxBkohRis7KNJY1hnP3NnNMh/q+K+R6fAPCSpmhm9AMikCVDBlIiSQiRZ6D6/d9RDRuDrMZLrSlBPv8tworAY5vDBWYguTdyaNACPEAKnLPgREkX8ntIuWvmv++Z9cGuWWIgc/We9moOLorUssg2iiCyKkvwoWumV1zKdKzuUxEVDspQRRAyRz8fcyOqLBi0BylQR2L+N5W1k/5eJZcZ+8iRYjWttMIwlndmeXZ+Lw9CbU5fc6erwXsELuRtWS6DPzRQQKQjdPtDUTmaewQEPaBbk2oEvAriOROw1Zb9C/ythInmhDPzvvU6ik43yAGJSP/YhJZOJMqcDvnMo7X0rGjzLjxzX8H9fOxY8A4WTmjttrFsqTH+8vgnuwkv9pX9ZYzAfBliX4Isf7GyKQcot6xEolqEhdaxmNBlAK6EiU9ANs6erRViWFyhQD/syPaVnqN5M+SLyYlyJjoMlUd1DgNhkjKodB9/yfeNH8wtlvP3li2eB/3ClOTUEgRBzV2S9GO0QlmU9PxETyiw=
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
could be improved upon.

First, each memcg_stock_pcp can only cache the charges of 7 memcgs
(defined as NR_MEMCG_STOCK), which means that once a CPU starts handling
the charging of more than 7 memcgs, it randomly selects a victim memcg
to evict and drain from the cpu, which can cause unnecessarily increased
latencies and thrashing as memcgs continually evict each others' stock.

Second, stock is tightly coupled with memcg, which means that all page
counters in a memcg share the same resource. This may simplify some of
the charging logic, but it prevents new page counters from being added
and using a separate stock.

We can address these concerns by pushing the concept of stock down to
the page_counter level, which addresses the random eviction problem by
getting rid of the 7 slot limit, and makes enabling separate stock
caches for other page_counters simpler.

Introduce a generic per-cpu stock directly in struct page_counter.
Stock can optionally be enabled per-page_counter, limiting the overhead
increase for page_counters who do not benefit greatly from caching
charges.

This patch introduces the page_counter_stock struct and its
enable/disable/free functions, but does not use these yet.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h | 13 ++++++++
 mm/page_counter.c            | 64 ++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc871..c7e3ab3356d20 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -5,8 +5,15 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 #include <linux/limits.h>
+#include <linux/local_lock.h>
+#include <linux/percpu.h>
 #include <asm/page.h>
 
+struct page_counter_stock {
+	local_trylock_t lock;
+	unsigned long nr_pages;
+};
+
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field in
@@ -41,6 +48,8 @@ struct page_counter {
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
+	struct page_counter_stock __percpu *stock;
+	unsigned int batch;
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
@@ -99,6 +108,10 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 	counter->watermark = usage;
 }
 
+int page_counter_enable_stock(struct page_counter *counter, unsigned int batch);
+void page_counter_disable_stock(struct page_counter *counter);
+void page_counter_free_stock(struct page_counter *counter);
+
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127a..a1a871a9d5c49 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,6 +8,7 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/percpu.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
@@ -289,6 +290,69 @@ int page_counter_memparse(const char *buf, const char *max,
 	return 0;
 }
 
+int page_counter_enable_stock(struct page_counter *counter, unsigned int batch)
+{
+	struct page_counter_stock __percpu *stock;
+	int cpu;
+
+	stock = alloc_percpu(struct page_counter_stock);
+	if (!stock)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		struct page_counter_stock *s = per_cpu_ptr(stock, cpu);
+
+		local_trylock_init(&s->lock);
+	}
+	counter->stock = stock;
+	counter->batch = batch;
+
+	return 0;
+}
+
+static void page_counter_drain_stock_nolock(struct page_counter *counter)
+{
+	unsigned long stock_to_drain = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct page_counter_stock *stock;
+
+		stock = per_cpu_ptr(counter->stock, cpu);
+		stock_to_drain += stock->nr_pages;
+		stock->nr_pages = 0;
+	}
+
+	if (stock_to_drain)
+		page_counter_uncharge(counter, stock_to_drain);
+}
+
+void page_counter_disable_stock(struct page_counter *counter)
+{
+	if (!counter->stock)
+		return;
+
+	/* This prevents future charges from trying to deposit pages */
+	WRITE_ONCE(counter->batch, 0);
+
+	/*
+	 * Charges can still be in-flight at this time. Instead of locking here,
+	 * do the majority of the drains here without locking to free up pages
+	 * now. Any remaining stock will be drained in page_counter_free_stock.
+	 */
+	page_counter_drain_stock_nolock(counter);
+}
+
+void page_counter_free_stock(struct page_counter *counter)
+{
+	if (!counter->stock)
+		return;
+
+	page_counter_drain_stock_nolock(counter);
+	free_percpu(counter->stock);
+	counter->stock = NULL;
+}
+
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.53.0-Meta


