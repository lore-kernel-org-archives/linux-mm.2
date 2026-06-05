Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85D1CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ADCC6B0088; Fri,  5 Jun 2026 11:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282D06B008C; Fri,  5 Jun 2026 11:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174EC6B0092; Fri,  5 Jun 2026 11:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 087A56B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:36:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB2A51201CE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:08 +0000 (UTC)
X-FDA: 84846260016.14.B1A406B
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD0D81C0014
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OoSSaCKm;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lh7157a6UldulsYLa+rcYTJC4JAQaUR5k2UCa7NfvOc=;
	b=l/VGrNhbsb9rZDeaL5/RFZSV+Uma46CkzcjRfwLd9p12Gu2Xn0DL21xfV/SLiYegO4RBML
	i6wmX+E5HKq/Y6zaIrm2XM4LQTdXbexlnSFaKLXuKjqCH+OSwrEjKGhgIa6I+2+Uh9rmeV
	Mcmezb9o7RXn5fJXrVFB/7K6E5UPa4g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OoSSaCKm;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673766;
	b=3FwYooCFvc8SwLG1RIaYbJCoxRCLUrD2FWTWfmiBJlUXEhfutIP/zKTXdeEtfkeCPo9B24
	oz6Or/lMcPIMPhxpPbR/AxWT3V58iVuYgBMpnHEPN2b2SUdKgyV1x0Ib4bINZYojddOpwe
	t5FRYRsNQCvR+Vqn6Jc5U4wlwDadua8=
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-69d60694c9bso1173440eaf.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780673766; x=1781278566; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lh7157a6UldulsYLa+rcYTJC4JAQaUR5k2UCa7NfvOc=;
        b=OoSSaCKm4onql02gH+fhtMaJDY7zenfk6y5Uqcv0ZV8tPdhSAJY9Lu1F8C/Rg3hOEI
         CR1Xk8IdHHCf2vtNyfS2TdEEOvzV3jrDqgs4P4F6x4JuZ9aS2Kkt61UA6lBmSCCszU2f
         Zexm3OkeyPb7kjMkH6i2rp+KXKNG4ulk2ADVRH3eMdKkLR+Fgu8AAgsjWLlkc8MScBrA
         +1Ee4eCpWdA5lTffytGoQwBb+NPQg4bzzDvv9sZaCJb1xsX7U8GnEs60YhZoEEsU6Xar
         RtXEiZPYWvPOGz2F1gmq9PQCkQlsd0Xfp3Wu1MfF3xlJoheWJIB39Ph9aby20WsGgMW0
         WA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780673766; x=1781278566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lh7157a6UldulsYLa+rcYTJC4JAQaUR5k2UCa7NfvOc=;
        b=BLCnKwcTSB+Le5nFAOOXdfgQXtuoQwF8BvwmuUcvyoHsgS/CL6gPeyQ6EJz/vH7ebf
         0KDm0DhwzsJ/WumPX6wCC2I70b4hqIpCq13aUxydQvEd+hTdDGtmunif4jFSjCQFDevd
         dzF7/hCQFdzkZfAAyuFqzSgElfDRlDJZPltjdJxcEakOwLiPzyOCnl+7rmGWTPrhQG5d
         wezwGyLZMyHWsex4am9+oyMllC8Xf/rWSVqMLJFc3QwjxZYU9dXlXdA6F+c5y+WObFoi
         nwtr8hhp0Iy+M4a+Izu5mCFYNtmzOUWhOX8eSOHEOpgR9wq2aHTlwyDuQEu5lAKx3cqT
         QxCw==
X-Forwarded-Encrypted: i=1; AFNElJ/qiPyO44iSxTHj+0vJcZDf5K0UXWM4oE39Cw9WUqQhqvB8nuLlrQeNO/lGlWEEmZwAPVwZhywUbg==@kvack.org
X-Gm-Message-State: AOJu0YwqdH7ofNJmnoO3M+AsC2VTgzLJ121qvgNjYKA+znEdCkvLTM8W
	BCEfDXzNEOmNXUrLFnKutkNC86iWnoGieQKmVUf4gzq/48JT0hymdUtn
X-Gm-Gg: Acq92OF+8ZNB/DWN/RLJv9D9YObzqP3sZ3GnhkrAichDZz7LZU89GYOQCqO25hV5zOc
	emMS8v9ryVAKZg/EcIEkppalhl76Tll1XbAp5cMrDX2gMOQQXJooTuj6L+QCrS2hQVoi8cHKoPH
	AtHbFoNk5gEfhmgo70nRqoCcr3TdLqfn5/wqXLitEg7NWn52qbu6ylmQ0zoHHZ+dvn2FfvfaTBP
	MR1Zx+yXbsuSrO5TJRA1ZhvRiU+Km3SgDZ116Ads1bFfAKwlI0Z6P1oVYkMO0phxLei/vil7jdj
	HsWJoJo0Ta0NffLahhnyV5vt5A08Pyp9x2jBQvYBE+bvGt3O1szq3N6SiSSx9RGQHw0naX9LSjO
	5u/q5yhRWb8AFYMTknXkLZZVuaJorKJu/uIy8aN1zJOoh6vOQ2PVN2vM2vzO0hf/NAMYgXuBGBN
	NsWg2ldvCQBoGNjIoAI1Oz69nZ75FQJfpMX1ZV+8o+8iRq2XCjhKF5UCSlkOyjIbY=
X-Received: by 2002:a05:6820:818a:b0:69e:59af:ec9d with SMTP id 006d021491bc7-69e68c089eamr2288542eaf.31.1780673765870;
        Fri, 05 Jun 2026 08:36:05 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e464050fasm5180102eaf.9.2026.06.05.08.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:36:05 -0700 (PDT)
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
Subject: [PATCH 1/6 v3] mm/page_counter: introduce per-page_counter stock
Date: Fri,  5 Jun 2026 08:35:57 -0700
Message-ID: <20260605153603.234296-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
References: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD0D81C0014
X-Stat-Signature: f7xhijacghciw8rqg61uajijp4nesqqk
X-Rspam-User: 
X-HE-Tag: 1780673766-428430
X-HE-Meta: U2FsdGVkX1+5Tjh7W6idUK2ea7/MbjlpQ1xiyHX6PyCuoyXYS8n9F/nPwJ05c2aB8PnMRiEh1S7OvSQmtV4GcucqZ4xSjLDgqtjLudB7qZCPK9L7vKZ17Z9mORDQxt5dBlz1UYRY06RImN1f3F53Y9bZGtxJ4EHGrcHCVMBrZGh+Z9zhtI9Evh5UYeDaqgSKvnz3imaOsV0KWQoADZfIgTyKXIKhYVgu4s5e/cXakVthZv6brOUcKVJ1XZmprSTD+tPRemBchN0Ej1M7E2k9con2ouTCrmdSgHxJK/qh9Uvh9H6Zd+LL5o7s2bOivcXaXIxSN79uS+S8svTYtt0GSY1rY23fI4QSXi6jnSF4uwA/zHAv3xuspZYfnp/B+RJp4igW+AbFlr6UWPp/drtnKW4eKDZ1cnhr/PyGBnDsAMSn6WWHTwHzBRQSCvMSs5VB5HUbr4MWrA5BZGp2HhDLsUVJvBvhofYeXz7fDgAVp3fmsi6x12ISCjx62xe55eHLuHYS3lw/UYK/OWeI1XAXXRZEOvuqc6OWoqg+f6zETS/b0kjhzgzr807KR3fpRSgjGC0n5W93pISDxgkcnx1BNy4DuGFPIyA9sDF+IhHpSKBERb0zWNPAg+UlbPohrFesFC7D+8+3bpLLBzcFcjDg6Zsiav6W7eQhulb0wOeUyplR//zsfambHQZian+SynWvDhCjc0OnS0FLkOBvPOJlJUfy7lQmaBQWEmTLiTOthU0pPxIQnQyd+LqpLA0qdEB9v1ydvjPC3uGU0BWoskooMX21Hryajfsxk9VI6hofjUXZ5vR9itmspxH4iRLM9FoCjpOS7S9kLJkek+BlTC45gSYYGAUnfgiFpYlymN2xLi5UJQIx/myHqqeUGFMaildvIGRdQJpP4hlSpGG/z/wwPTeITwyPGLCN1WHVszi2XH8bpHdOHiPwH0oV9Clh5EWl5Optr1vqToPIKvpMwCC
 KVCNlA1m
 mnz1o9RA6P9TE9eKO6SgPo6qagkxfUjdIzjPSrJmsIAHGWNgUu6EjcwqThAEQTykQBxodoWFuVgPKI4oMaOipizlCQyGPKSveGl8lQZ8sVeUtQUAOp9XnPFhCS0J+17Q9UTyTamNAfRvZzdMMXLQu4XGMLp1qqGG6dsN09Uah+yjrWxpx/dHKoFLxS5f92WNzh5vYHuccY0GimoZ59clI9tqRjJgYV0kxuzLSsr8w8xTThh7cnwTiEHYhceqqQwPlQNLSCyOvzEhKhRxANDIn3Fnpgikwn9av1sB/EIs4+RJ26OKBKFwaHj7WgecDxMHigEnOKlhprbCDDvYm6kM6ngjA9DK1J/45ZzJfv4jgtxUM0HbMAoOeAUoCtdjwTE2TIYjm2PhlgsWg+FCItIiyEKWhXEzWuDPN3fa4iOI07zrO03dv0x9j5PcTivowDIa3aZRnAFJYRN6OMp4HGoWKWLVXhQNWQiMbKSCLl+1UuE3A8wYUE1dEDtrzeh1U1q+NK/Y0TVm1yn1JHITKy9YeLgwShPnoMSd7S6rqIOclReznbbsFSOu8vRxCTSEo8XxmdQQ4gp/37G4PfVbzIoMcxy3GXLFsodTbpApxtzieMXEsXnY=
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
alloc/disable/free functions, but does not use these yet.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h | 13 +++++++++
 mm/page_counter.c            | 53 ++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc871..c92bb2ee2a581 100644
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
 
+int page_counter_alloc_stock(struct page_counter *counter, unsigned int batch);
+void page_counter_disable_stock(struct page_counter *counter);
+void page_counter_free_stock(struct page_counter *counter);
+
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127a..9f3e3f8d896c4 100644
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
@@ -289,6 +290,58 @@ int page_counter_memparse(const char *buf, const char *max,
 	return 0;
 }
 
+int page_counter_alloc_stock(struct page_counter *counter, unsigned int batch)
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
+	if (!counter->stock)
+		return;
+
+	/* This prevents future charges from trying to deposit pages */
+	WRITE_ONCE(counter->batch, 0);
+}
+
+void page_counter_free_stock(struct page_counter *counter)
+{
+	unsigned long stock_to_drain = 0;
+	int cpu;
+
+	if (!counter->stock)
+		return;
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
+
+	free_percpu(counter->stock);
+	counter->stock = NULL;
+}
+
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.53.0-Meta


