Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51856F459E5
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94656B008A; Fri, 10 Apr 2026 17:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BDE6B0092; Fri, 10 Apr 2026 17:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5EC6B0093; Fri, 10 Apr 2026 17:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FAD36B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:07:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A29814067F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:49 +0000 (UTC)
X-FDA: 84643883058.22.50CC10F
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 65780A0019
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LQc+PvWb;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855267; a=rsa-sha256;
	cv=none;
	b=lNbfU/onvOZlEHqX8aPZzKD0wteYWUwhp62YYBywXx4EGN3oQKelwbM5wZY+mMj0hlUJoJ
	DETivlDrbhv8O6HlkLSIspXFJcVIXihD5d8BZBwfUNTUmMO937MoLB2jxbkasuiuuEDRjf
	zTybpKGaEOLwvjkqR94j7B/oWsFsZcY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra7lyKTz0FXclo/ZAhEfnaPWl8hR2IKs3cjWe/KBKyU=;
	b=NoRpNexNPZoqYwm9svgnhTwYpvnN0OWBIc1gCrJmCO2UllXVcip1C+sy3UJaH+nnYB5uZG
	QXCs4LOkjOF8dsftvPoJi+PahtUAB/LUFCTFQRicX8jAbn8j6mW+111xHZ8oQu0Rxfb+oA
	sNTwqm4GTwnKu/y0V3cqDIfKjh59UIQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LQc+PvWb;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d1872504cbso2236925a34.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855266; x=1776460066; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ra7lyKTz0FXclo/ZAhEfnaPWl8hR2IKs3cjWe/KBKyU=;
        b=LQc+PvWbZ3imNEaviecKGNODG7PebvY9gAFjl9lWuF9Z9DBfs0+hlf9h7g53AxCIkF
         yU602sjDsUyhlYSqcJD107zUWfKe+G+Mfwr444gr53aJDpCNT+S2MIKvykguRwY0OjAg
         +tBpv86teMNQI4WQqbpqAiCd/3Elkpk3bkuBrQZNktNCE8dDBDQjLSoyNWkmR75RopCL
         kDRNKPbC35s+j0fTI0p1+6//fhTsKiTZk4kTlJTHvQerDcJF4+TJqqv+pTXeqU6vlO5q
         rk6jazLBsEgtKgf8giaPMNuZ4kakPTuvO5EFftdb+TV7Bx7sf9oDrRG/8wkj1WGNfbCM
         L0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855266; x=1776460066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ra7lyKTz0FXclo/ZAhEfnaPWl8hR2IKs3cjWe/KBKyU=;
        b=G1PBFQziPMddELOy+KG0GH6M2RWu2hHk/EZuL4aeoO6IwEO3UKFgFzW4fXXJGXjed2
         aCyp4W8zFiF7FuSVlnRMSGQsHJFNbqas73it+isigjA/dQa/Iq4QZO3qvlB9qIpboauG
         SM1iSUIVl5JwTwNxdOOHQdw4BzLCP9ApbHfrfTczix0HopfnBkzkwb7Q9unfojMUOFGE
         m/dTDark4OZi7j1qYeKVuIPXuW7a90KwIbxidF0Rzqpjwm4hRBmA6MpEXyXkmo2RuA7c
         LL9J1dgXYPNuBZiM3o12zfsS0WX4Oa9TSOUHLqzyO80EbCVMiDBbthsecEzxKp1jPrAF
         Yc+g==
X-Forwarded-Encrypted: i=1; AJvYcCU2yW8GHQLnn1/HMl1wJnrWFMOAq6GspcW67Ww+9WE0sydZd8BoXmTxozBJQ1cTVNJ1v1bsCfPLYA==@kvack.org
X-Gm-Message-State: AOJu0YyqwlIH0O0xoT8XD5+IHNnoC8NxOoUYKtod6haxSgSPYdfLQOz7
	mAaZqSVzu73RKDSJfWs/+3cxLtUGaN6qiaRc1k3SThUOrBuYWvz8uBOt
X-Gm-Gg: AeBDiet9muOIhve2NRg9MTdQiZpwk60V/M8GsDCIM7TNQw8kWFbt/M/di7cBU5LkqDC
	vI82wCifSWYXHoonMKZJ6N9aojnWd+26AZRiUhftS0+aH+5R/5I3rAbQC6I7BIwtFAskpp5Jw9H
	tdF33RTYMd7lyqMmZsHV5TlDJf+/RKBVFCXGReQc9498l5oAwPkgt4P/Ho5cYddWnBE6//LXy3/
	4Iem4xfynrCsIp4HAGs7VwbdcwHd2t5uMihbYluZp0d0/DlQjyPTBwNJi6fFJ6essnhMwMtQPFL
	pnNhwKVw5GpGCjqMmQt0jwNhIKC8Db+bmOA+6ck+6RfrhAsHhdjbUsTj75trUEr8EFsz7bj8pOL
	heYOql8JITuPGLNlwcVq21Mp/jz7X7xwdyZGBvzdyeMG5L61L6t5a79amjT2LiMGW/E00lRAIEp
	IU5L24h/cIGCVc1nbsGyXohAPnkV8dK22M
X-Received: by 2002:a05:6830:8312:b0:7d8:7da0:7d8f with SMTP id 46e09a7af769-7dc177a646fmr3456536a34.16.1775855266401;
        Fri, 10 Apr 2026 14:07:46 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc269d52ffsm3136947a34.26.2026.04.10.14.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:46 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
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
Subject: [PATCH 1/8 RFC] mm/page_counter: introduce per-page_counter stock
Date: Fri, 10 Apr 2026 14:06:55 -0700
Message-ID: <20260410210742.550489-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 65780A0019
X-Stat-Signature: rwemhrr7khh5nrukhs3xq6y6jwomoi6p
X-HE-Tag: 1775855267-281641
X-HE-Meta: U2FsdGVkX1+kk7dKXgl0R3gPMzLCGulxxJO57ki1mLzWycs5wmiFjaGKu84lkbrKiPyvfFks64oRz8hF6Ziv3JLPhXH78l3MdF9nAriENTK01uRfSgfqOWLfksTwVi8YZx9/+kd5/OJAD3P19RsqCegERLbo421So97dNhBuPDFbvzHZxqRRXW3ZHjnNnsJcWDDkP5kRFb5bb3A6WKhklIelTRZSGD2QCj/5NXjuMuZ+/vikdvLlk6cx//p+Uu9UthNwdBR9tm9h9xGbMdvaFz+xTN7L+TNPwijMAGOG47XmMSrZHejXYCFlQYC6Jp/tT0iWsC0DQITWD9D7Zp2cssogCKoaZAMzjO8cr1ke6MhL4drASpQ/shu3//uQP7eG+4jdwJjnqgEZdseksQ2aOHkT/OR6Y5xbLCE1y9dh/HFpYDnSnvIdfjpBls9buZ1MonN7dyaejKGFdSP2hsCXWOEml4nfmQW7gVcS2rRP/K67Xed9n28u/BSm8lM/DPjsnXK7LjBKsYlW6g6x2/C3f2nuuCYlxLDc6tQizfzVKPL+8h537AYR+LyeW9FzJ84ZWA/n27IQC/2pnGlJO1+834Nvotc91tnfJjeP/VVOWGNLGkRB9E+yqBzHfSw943wm/s+wgV+zGEXli93iL6H2YAnhAItjHrVKH1WLEOYqwO3iFulzJjm49YAfB6PVI4ASDxzCHQR0IGLjaVbAe8svbRs6F50kBcYjtjW+I8RjN5getVAtnGW+/Qx6fUWDTuGX+He3zTB2V/5K861s3qEF2GO7OQukAwoSNv/0gqIjcUekeOn4LpdXJy0ovoS934u2TfeCtnuWP1MlXU3NIk8A2tAWdEbTnmIKEdUoB0PnAc6i/6TyQ66m4YmDWMa6aDYcOrVJyGBtRpYfgY1B5PaYZl2ki/4r1Va/BWucrwiHxWkCVRxzJ0cu867BCuMHfzVp5YYrqLOEZd/Z+QBzBKE
 EDoDNcbQ
 Tf8xcrx27x02hP6g8f6exm+9ciulwihDkbxqWDCWx+JvMdGb34Bual3FJzaGs2ZIhz+PRbOtd/9AtqPpiYJGCNupeck62VfGjwM9uIzzVcDJyRBj3YuJdTD7Wb4Ewsa58JspaPuE+hvsXZw7AsePXA1O5v32smVE/w3r6PQDAe22hSoL8HUghtUu/G8cOBN10kxVriyXoE7LLsjdic+WUR375k7esL50SAfE/AFBjLLFXs/2OAmCHM7trT54/WXEOskUNh+w35G+N6FrejlZlc60QPWdfwcZtMHhGof41OAWpDxHauMrygjTL54kKRbG6A8yBkyX4nIFxSHMaPhjJN5nEPD3+5wbMRXTsZZBs7lSGz9P/jawT8PHzL23IHFNujEbxMAxuAfiMqT6ZgaD5FY38xBzhNT1jSQ+JelO7fnHud0LKIte1RlpGER1j0CJ3ky0aLCk29rvqE6l27AIOal8bJylDxaxkDOTQngNaoOYPjc/RZHSPaibajbkHsucbWnXUdqm6NWT0dR7BFYg6a8nZ3xCMX24ic9FxSmJs1m90jw603X+Mc7W+sLnHkUBcE9Lm6mjpeEgJF/ActBAiltJjVjrw0Llr1dCgHyhXYhopay0r8gAWWb3ooT4sRtZEUslYspoFBsD7eS8=
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
 mm/page_counter.c            | 60 ++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

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
index 661e0f2a5127a..965021993e161 100644
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
@@ -289,6 +290,65 @@ int page_counter_memparse(const char *buf, const char *max,
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
+void page_counter_disable_stock(struct page_counter *counter)
+{
+	unsigned int stock_to_drain = 0;
+	int cpu;
+
+	if (!counter->stock)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct page_counter_stock *stock;
+
+		/*
+		 * No need for local lock; this is called during css_offline,
+		 * after the cgroup has already been removed.
+		 */
+		stock = per_cpu_ptr(counter->stock, cpu);
+		stock_to_drain += stock->nr_pages;
+	}
+
+	if (stock_to_drain) {
+		struct page_counter *c;
+
+		for (c = counter; c; c = c->parent)
+			page_counter_cancel(c, stock_to_drain);
+	}
+
+	/* This prevents future charges from trying to deposit pages */
+	counter->batch = 0;
+}
+
+void page_counter_free_stock(struct page_counter *counter)
+{
+	if (!counter->stock)
+		return;
+
+	free_percpu(counter->stock);
+	counter->stock = NULL;
+}
+
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.52.0


