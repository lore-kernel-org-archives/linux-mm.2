Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F43BC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9986B0098; Mon, 31 Aug 2026 12:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462CC6B0099; Mon, 31 Aug 2026 12:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCDA6B009B; Mon, 31 Aug 2026 12:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED2316B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:38:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E93AA33DC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:02 +0000 (UTC)
X-FDA: 85162121604.28.5F62631
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9054D4000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PGPbT6xl;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZLPtkE4K+x7inkg5AOVUnb1Simer6GkDXLFxdMoHE0=;
	b=58OiRvVbOioJCfnjthxEanCWokahs3dOvezlThWbS6ETWLIFy5TTn+VXspsiGeK6jEOIlB
	YW9eHq0BqG/oGIH7+DfnrVHRru8sE0Rd6wSWjY/n0KnL4XSCJKDuEBedAfIzk/qvMMc8V0
	/IZ/cfAz695mysbIYpdEyD9dsbKb4nc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194280;
	b=tzSqLZEi09rKIgOTKHyXVkJrCnD5RP4Mt+xZffVuf+9//7izcclNvjGdB8bz5mMruCGtqr
	ElBX/7lamQlmDEQb20B7eI2zs1S5FExRk6Py1RhkZ63WLFKD5NHq3jyFn0M4/f/chaoipo
	qUgHJFg5MNUKLm1aoTvfbdUq3FEp8B8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PGPbT6xl;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7f3f52143cdso2907533a34.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194279; x=1788799079; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tZLPtkE4K+x7inkg5AOVUnb1Simer6GkDXLFxdMoHE0=;
        b=PGPbT6xlYLbAl9yfUdYdiDsLTjnQH3AcEdGA8xVoha0HWzZwbWeoYg7AiahZgjZqjS
         P70yZksDKsZWsHjHUxWjm0m7eg1kfa7PvNlRrfU4qgZwXqYRWWw+bYIVXvZ7B0JHW8Q4
         VvHbt4jmCjor/GdRH6Zql8YkY89LpmXzwHh9pyLCbCqBPbhljaL1HeJaTTFhiGiTYgVj
         Xw59ukGUvjPCCR9io9oyhfvlI0j0X1Exy7x3Ven59NmsywJCkzBPRirAL4ZKEMaOJbUN
         IoEuCK3qQCbA5A1xGa8GeTHYnrXW4VBtpIELwsKRNOtdQVciQDJTYngmlWmZpgTdhOPd
         G1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194279; x=1788799079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tZLPtkE4K+x7inkg5AOVUnb1Simer6GkDXLFxdMoHE0=;
        b=dS9AvZiHfGs3IjB1GBwGprLdkBPkdWO7Tuy3CbqW+5HUL/VlMRO1tuEcBWVOr1TV0b
         gFafh+/qZgAiQonfmX8eJLVf+hEJg+1+GCzsA8h3n75EGK1mvRMOe7yvwX4Wz3oMpAFT
         kM8ggPTQGaE222jyeKAC1aB88Zhn0HNiaeCJ+bDH9aQx6FHQmEV+Ll8p3lkH3Tl39n/g
         JCAbEdjLxJ2yf5AVUWHs1ZYYwQJ7Bqh54D45JkopeiK9HzmGoH25Nj0/mP1j9YHa/XaS
         VyHE7tPFEwYPlQFBk4Sb9rj0OPmXT+ajB1oL72OBbs6IBP0kcpsGTya59bRj++uhzh+8
         hDMg==
X-Forwarded-Encrypted: i=1; AHgh+RrJ1zBwKtK7i/yg4fczzMr7mLHjAKN8vD/k71BIo7rf2MqjqZzxBzVB0/4hVzcHFzFrVO9YKxFZbw==@kvack.org
X-Gm-Message-State: AFuF++k5jEhTNREXtqszu1m2MSQyQ8DNS7OiXURN97s9UjEyPF8egk01
	LKgldtXLNAVXRPD6sp58UGh9wDGUHrjiUt9WnZeREhzt9g3+CvQmOFiU
X-Gm-Gg: AR+sD10fzqucLD3TJ0WW5ITPWC2i93rTTFZtYNGUaHQFQICyXIphLxapy1uRtCLNUw0
	seSlmroUHwZg5m/8fXxr/LNEtQED+Z/1Lm6otDoPDDXRNiQ3VevVDrfNcuiv1TQCqRPk4pwgWUF
	1KbQs8TNBTS6eISY4olpxmjplULiwoPPD7aj9CBkbws/rQSnR4ed3RWx9ddB5KLUECdLRhyBnBq
	9gi8ILCC6BNf8gFTb6z1rJMBB4KZ80ldNNENTwpQDQPCkR+OFOHpOvf5j9Srr9Jk7cMwrbAyQA6
	Dcn52bgwB2sewo3rz5pWa718HMnW9tv/6Ro7PbvRxIphAecd0qWhgDyvGuYiDSXNJqqbhUwKq4k
	ETUPWWyC5qWRzAm4eQ3oMYVamP0Te4/uzjkZ/4PRb6ccizLuDq/RnbArXbdlWpKbXFaeq06zo8B
	mr1D0dthCjlii0957lux/PDMqiOZAsUrZNiR+OUb9oVczLPhol2hNJq5KZffNn9eejFuNLgPmb7
	dcFWImNvO36goTcpUak
X-Received: by 2002:a05:6820:4d02:b0:6b1:afc8:3162 with SMTP id 006d021491bc7-6b1c6642c52mr23408705eaf.7.1788194279553;
        Mon, 31 Aug 2026 09:37:59 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2b::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a2fedbcasm10399867fac.2.2026.08.31.09.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:59 -0700 (PDT)
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
Subject: [PATCH v5 5/7] mm/page_counter: introduce an asynchronous drainer
Date: Mon, 31 Aug 2026 09:37:49 -0700
Message-ID: <20260831163752.2193337-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9054D4000C
X-Stat-Signature: x9rpnxb1s3n649t9s4cdwkndo18c4hhk
X-HE-Tag: 1788194280-864766
X-HE-Meta: U2FsdGVkX1/06qbxo34GmbTa8KGEFliKyDhSlP3utw16YH2UxGTSkokgcx6sVXUTQ8eYaZJIrVvsTcs0YlwH1HvUQpT+rrAZVdIMa+ZeObShVtBIj4rimCRNP+tfm9kRJKZM1BmKTIpok3TbNz3aXaCWmhie/GCBAV+j+ND9iRHnp1hVwAMHGEG+oY6rXfEIrvKziOi/kf1SQgyGOndTN3p2yYtT2esxpF6WFNxQINp0RzT1CINgaeRbpvMHrIs+5OACOycnb2ui5/h+KfbXi2qI7vJxsjHI+m+bWhzMTmKx9OMSeppm61udk5lYy44FMWnbwbI5vDudECcsPt/CilEmohHzbHWuzv9YA+hoHeBpcfioJiK5wLDLrAMK4KYuoPRCbQLhtZK+MOpxT4Ep178kDNOXPeo4QIeHgFefUlRYY+amf/2SAO1Kc1utQiHEXHVsv2PQ+jO5QKeM5aSzsQtiLKGP1DvXhiPt7UR2s4xjKxnMAtLaSoUkHuGhH5jjcmTfNfl9kFHcRVcjGji+HzsLf0LIE9xYuxIRUG0an+80S0q6TPd8wg70HLjc4F+BtRomfOvWK6O7BcLcDTGSK9mVS7o8rT+80tcEfiAW4jVEn6As43zn7/q0V6+kIxfg+MjvaGQ4ZagKwwXMLYY4r+/uaFOT15faz900BYdOtTYxksEoVDxyVr9jhIxc/ajVcuyc5/vwORJC/8GYVWzo6RsFOMvWlowsjKwn2xkhbHcGoe6McgzNWuBhR5XBPvP/FX2Gsm3g11uK8o5U0GUnW/XrhrdSMshukAIZw49+AcXBs4U7/1h2vblY0tDITJ2nBq9NWfn2UcEW+DclDK7y1kH1SEpl5Ctv8s198dYi9F1rlvvXW92FEmr/xR2HmPIUDTv+Xgwd+slp1np5oaKrlHk5BnXIV3YP+0Z68rswI3obmChuPYn/uFFnNXMk7hfNqQD/K41FwtxliallWsn
 NweMEGuk
 +NFslwGyvXsN1zsIJYAXRu3QiUnZxNlgx98oO7WweHi5LT0hox/T5xUDsgQaXVjoBvN0UWwQeC+9zptxcVcIsDRX0SmGOMhwjp4WJC4w+qVBnKWNiHvhtK+lHtMtwP+3ED3+KLohu319QJTcjIVpBROTaVsUBz4F71PiddvpI6i2dFgZGXtAetiYxq7TRYtcm6TAPZfbS6WqFcbbq2rqoI4LuqJpTc3ZkjbAUAIzmYhhwRyPBbRNQvEArXqAZLUQDhgZL/q47Dw/UZDoj8iodJHhD5ThBFD8XZJj9Jw/xIOFodKNibNCOjiH0dCSp5795Qb4Yuu7xoN5bMEx0gxENAM3WyL9PO7R6eCq9rrpDQxbP8X3xTcF4Ub/Ln7M7T515u44DbUGlJ2qMwgsRNZ3s3K3Ak09jr/+qMSmZ1cXebrBdTflKLz5vWOPn13E1ZyGiNsWJIhHI93jY8oPXySliwTPz09BfijNL8aJzaqj1JVwsopNQSn0i4Wx/zD3OCwLCzFMBfr4ZIhQc/Es7kYqgUpXBxzlvb9UHZj9JdgTIhC7cp8mwhzQfhXXWxXDlTghR8SfZcF9l9pWGzhx9r25phEKG1JbYjOri8XgjgJ4ksUrCrbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing percpu memcg stock drainer schedules a stock drain worker
per-cpu, one for every CPU containing the target memcg's stock.

One issue with this design is the coarseness of the drain; when a worker
runs on a CPU, it drains not only the target memcg's stock, but all
other (up to 6) memcgs who are stocked on that CPU.

Instead, use a per-page_counter drainer that iterates through each CPU
and flushes any existing charges, leaving other unrelated memcgs' stock
alone. Since that walks every possible CPU, the per-cpu helper now skips
the remote lock when a stock looks empty.

One benefit of having one worker flush through all CPUs is that
duplicate drain requests when a worker is already queued are coalesced,
since the asynchronous drainer takes no arguments and flushes all CPUs.

We use the system_dfl_wq for this asynchronous drain worker, since
memcg_wq is a percpu workqueue. Note that neither workqueue has
WQ_MEM_RECLAIM.

Previously the local CPU was drained inline because local_lock made it
the only reachable stock. The lock is now a per-cpu raw_spinlock_t that
any CPU can take, so drain any CPU's stock to return pages immediately.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  1 +
 mm/page_counter.c            | 55 ++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 428ca8e7b2da5..b10ef785f06de 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -114,6 +114,7 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 }
 
 void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu);
+void page_counter_drain_stock_async(struct page_counter *counter);
 void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch);
 void page_counter_free_stock(struct page_counter *counter);
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index a76949abf04e7..e6cfb5865ba75 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <linux/bug.h>
 #include <asm/page.h>
 
@@ -135,7 +136,7 @@ static bool page_counter_consume_stock(struct page_counter *counter,
 		return false;
 
 	if (pcp_stock->nr_pages >= nr_pages) {
-		pcp_stock->nr_pages -= nr_pages;
+		WRITE_ONCE(pcp_stock->nr_pages, pcp_stock->nr_pages - nr_pages);
 		charged = true;
 	}
 
@@ -183,10 +184,10 @@ unsigned long page_counter_refill_stock(struct page_counter *counter,
 	 */
 	stocked = pcp_stock->nr_pages + overage;
 	if (stocked > high) {
-		pcp_stock->nr_pages = low;
+		WRITE_ONCE(pcp_stock->nr_pages, low);
 		to_flush = stocked - low;
 	} else {
-		pcp_stock->nr_pages = stocked;
+		WRITE_ONCE(pcp_stock->nr_pages, stocked);
 		to_flush = 0;
 	}
 	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
@@ -429,15 +430,53 @@ void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu)
 		return;
 
 	pcp_stock = per_cpu_ptr(stock, cpu);
+
+	/*
+	 * Skip the remote lock when empty. Racing with the charge path is why
+	 * nr_pages uses WRITE_ONCE(); a stale read defers to the next drain.
+	 */
+	if (!READ_ONCE(pcp_stock->nr_pages))
+		return;
+
 	raw_spin_lock_irqsave(&pcp_stock->lock, flags);
 	nr_pages = pcp_stock->nr_pages;
-	pcp_stock->nr_pages = 0;
+	WRITE_ONCE(pcp_stock->nr_pages, 0);
 	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
 
 	if (nr_pages)
 		page_counter_uncharge(counter, nr_pages);
 }
 
+static void page_counter_drain_work_fn(struct work_struct *work)
+{
+	struct page_counter *counter = container_of(work, struct page_counter,
+						    drain_work);
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		page_counter_drain_cpu_stock(counter, cpu);
+}
+
+/**
+ * page_counter_drain_stock_async - schedule a page_counter stock drain
+ * @counter: page_counter to drain
+ *
+ * Drains any CPU's stock inline, then schedules a drain over every CPU and
+ * returns. Concurrent requests coalesce onto the same queued work. @counter
+ * must outlive that work, which page_counter_free_stock() cancels.
+ * Must not be called from NMI context.
+ */
+void page_counter_drain_stock_async(struct page_counter *counter)
+{
+	/* Pairs with the smp_store_release() in page_counter_alloc_stock() */
+	if (!smp_load_acquire(&counter->stock))
+		return;
+
+	/* Drain any CPU's stock to immediately return pages; migrating is OK */
+	page_counter_drain_cpu_stock(counter, raw_smp_processor_id());
+	queue_work(system_dfl_wq, &counter->drain_work);
+}
+
 /**
  * page_counter_alloc_stock - allocate the percpu stock for a page_counter
  * @counter: counter to allocate percpu stock for
@@ -469,6 +508,7 @@ void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch)
 	}
 
 	counter->batch = batch;
+	INIT_WORK(&counter->drain_work, page_counter_drain_work_fn);
 	/* Publish stock only after percpu allocs / inits are finished */
 	smp_store_release(&counter->stock, stock);
 }
@@ -477,8 +517,9 @@ void page_counter_alloc_stock(struct page_counter *counter, unsigned long batch)
  * page_counter_free_stock - free @counter's percpu cached charge
  * @counter: page_counter whose stock to free
  *
- * Caller must guarantee no (un)charge or drain of @counter is in flight or can
- * start. memcg only calls this once the cgroup is dead and unreachable.
+ * Caller must guarantee no (un)charge or drain of @counter can start, and must
+ * be ordered against the last CPU to touch the stock, since the drain peeks at
+ * nr_pages unlocked. memcg's RCU grace period before css_free provides both.
  */
 void page_counter_free_stock(struct page_counter *counter)
 {
@@ -490,6 +531,8 @@ void page_counter_free_stock(struct page_counter *counter)
 
 	/* Stop greedy over-charging before the stock goes away */
 	counter->batch = 0;
+	/* Make sure pending drainers don't run on freed page_counters */
+	cancel_work_sync(&counter->drain_work);
 	for_each_possible_cpu(cpu)
 		page_counter_drain_cpu_stock(counter, cpu);
 
-- 
2.53.0-Meta


