Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7626ECD5BCF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2FD6B0088; Mon, 25 May 2026 15:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A976B008A; Mon, 25 May 2026 15:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0146B008C; Mon, 25 May 2026 15:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C65A6B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:05:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4AEE16084C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:02 +0000 (UTC)
X-FDA: 84806869644.10.34E7F8D
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A9FAC000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ovQCCt9y;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDRjwcWKT8jzrOHACXaQIaOyyT2TFq8Oufd7POOepxo=;
	b=oiVO4WTg7PL2txZy/Wki91umecFmlNi7uhD25n8BTvZMkJxpDdUodTsqXzblyqZXLtJAuf
	2JyRfF6vOFA0u1CF9VTWMWPVTjMVtST25bmATbsVGlI9Yam3E6R3GXa4CuzkTSA61B5FJT
	ugmY6buY7p/+aM5mdNQbj09zr74EJ5s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ovQCCt9y;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735901; a=rsa-sha256;
	cv=none;
	b=6+nbAkKF07YETtEDHV+EAJrmg6JOrL/Kqzu6ig8904RaxvXbrK5H14beFIlR0G2C2nWqJc
	AO9R6blynl5fGG+1T3TOJaKXuOCBv6LQ/OrQph0R8vrBnOHK2BZ4BIKZKHmT6Zm+alCvjX
	mBYJ3jOLAhec4kzyzkWibaK66vC4ctI=
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-479d85152c9so3536203b6e.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735900; x=1780340700; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDRjwcWKT8jzrOHACXaQIaOyyT2TFq8Oufd7POOepxo=;
        b=ovQCCt9y45DPmCrXVwH15xSl2IeLG2wC6lVjFZ1XlCIJ1oVk9i3lQnCmFS/IUwGfks
         1CZ4lRqQyz9com9y/Wgrx2vaAtNv03sIHonQKplbSt53OO7el0x36CqbrEgjzAAG7xde
         peuD91jQ1zqccznq+UPsqtvodIQsUEDCNFWu0hxQpq7a4eV9LwfSDr1JgvUK3h7t/g/+
         Huwc1ieWIr3Wo+EAjOm1zVWRMG7KGvTfCe2DMndhgELiqzeYh8eIpaO7xrXcHPd4ltGr
         HIXI6Oxzyqmc1x9DWEG+PylHqvjEh94AdbaCF8sJeiJxUP0brk6oaeBW3rRq+9XaqVRd
         fDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735900; x=1780340700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RDRjwcWKT8jzrOHACXaQIaOyyT2TFq8Oufd7POOepxo=;
        b=SV7HfT8yGq08mD3clB5dv7ke26kdLfixJARqqhonLkarRjhXsf3nB3x2SKgnLHlX0h
         seIG5AmvnlZaRsCmiWrCQkiM8nK+QIeRA7k3tCisphAXFUPoHKEaaMlZBU7mw58c2Rsj
         J3i6X/Rr8YOzMYhzSFiN13i5b1lMOsLd0GIY8+sgGw764sRwCPtNH0grULQXphAcsK44
         2wZrKfgTaaZ7d3VrROu4xtJnNi1GQD5fEKWHcqXArC0zBj4oERJSzLqxnD+E+cZ4sn66
         H5vNJe92plejXLQKSpjN6SG3kx8p+z3VFHws0oRJKPZMi0zHEJEFUhD2+W1XSIoiheKH
         TtYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/yLWzQmU2FN0DBkN7ocjggKJeO+9SWTiPsq617QvLOry68fOAH++aW4FnLWm4BANBQRKJAVsqFGQ==@kvack.org
X-Gm-Message-State: AOJu0YwUmQ0DeimMfz+wsXXFbwUIAte+A+de88NQzLyywFmGJ2FcYX/k
	oFhgXlKAil9fC3w9XsxEj6PIEaeyKjKclkY9LQotsMWWn2WXUelCoHrl
X-Gm-Gg: Acq92OHH8aQnzvKioY79Xe7njy4C+h/UozppWeyNRBtNovIokLxc0a7W1tZnoyE7cH7
	RMzJddJRhFM4HDbgq1yFEqX1JulKqCk++3hm4eSC0BkKrBGtfR0zKIXRzRge6URTvaqCb8Xrwco
	WHQ9fSfUDgrLEZnekVCirPRQrp3/miqOBN7DaOodnnqHoe/wJFsTZaDKxX5P9yQtOxCAZBlsbeg
	fmOVRleME2/+1kYNB818hnK+x9zfUKtdnhxqd+gDWaaaQFS4fpkULQxbrODv/ueg+WF3cZwP0Dl
	lTVl6eMEiKILB7rTs2L1sKjMwc++RTIeF3DigRr6kDsI6iPzU28zgbV803Djci5h37CzoNIUSCr
	EhXtBybqOrsa+yJ8hSySiIIx09lNIx8sayrHBZVzNCvV4yWRqf10HAI6UWo5TkiS/gr58XNqIc6
	2pXnpSkTleD3HWtrK1JiXfRxib5fSjNXzGd7L0fv2V+lPRM8/5VAri3Q==
X-Received: by 2002:a05:6808:1455:b0:485:1173:f62a with SMTP id 5614622812f47-48549d8fb9fmr8720464b6e.1.1779735899959;
        Mon, 25 May 2026 12:04:59 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-485545070easm5050032b6e.7.2026.05.25.12.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:04:58 -0700 (PDT)
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
Subject: [PATCH 1/7 v3] mm/page_counter: introduce per-page_counter stock
Date: Mon, 25 May 2026 12:04:48 -0700
Message-ID: <20260525190455.2843786-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
References: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j89bknbdm7pehxbh3xzme7aj4h87xae6
X-Rspamd-Queue-Id: 0A9FAC000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779735900-63987
X-HE-Meta: U2FsdGVkX1/yXKCiFGFtd4h7vcRCOQP3XNybw1SmNCgRVz5LoMk4EJR2cAfUK+pv3lVjORK8lf8Cwt/UeIlykLAeR5jHqpnooI+Zvn3G6SUSFnEqD/yPRs/GxcGtxLKEvQ6cYwUBuDcSVnHJfxfplWyYWSH31gKCL2pC+4n+3RkHfQh+syZfUW8xszQyNSHkd0ORynAYfTO/Fjh8Fz+NzN8blRr4lp+Ay6FA2HJ+qRZ6e40W1JB1pQWAaMHdWJomdiL1zKy64ik2HdHMgv0FB5bS6jbandOPnkebb3tkhprB6MYPk+r2u5hOM3vosJTNk5pRbu/oBWYboMvZaRRSw0/t5htMHQ2UthCMPB6sLfJXyMOu0PVyglM148d0rFIyKyNOj9BkPlcyW8fwVjAYA5gCX57tHW2ylSo/grOO+PhwDwUGaoEyaS3tsu9QAyWjPFmHGH1jPi7np2RqLm6Ap5CUW8pfgKaxZammb1gtyEFdi7WGIemiVuswnuuWRJkVP1+OH/aRAgIv0iZh74v8c/FBnxQOBPensM9S95vigAKaPTnfinpjd0wIlLLytZwRohTdOLDtETq065nFUs8FN2g7t3yccFB0Uugp/jOL3stYvowkm6OOf91MUOOxuLpXHsVwFB9Zk6KGHFmHijU4nfMx0tn0SKHHJdsHkYEQODrZDDPnXA7r879XyTA+TttXpzVFhq2OfI6naRD/Hysfvj3ZBsEk/qc/RymBSDYi+e2CvUNulv/flsePYWh2klJuBeYAVJEuSi6gogxhYpGRizE1J2yKcoyDeLOitQRG0FsUeQ4O7dpRsWGXdm7CinclsFb0enD3P26JNiFwReRmU3Yn939VRO6Kek/jwtJpFPN83FLLNo630z5grra4tjg/ZfC0nZNNs/nL4aok2733CIWo28tzxP8D7u1Jy+uKv7eFiZi29sg5PcPIM6B/eqa0nY+au8L4GjSbiegXY9R
 QmRjYUjx
 kfZrlDR6ct27OGb8WDYxOK5UkisDocPXCfoXl86slyphiJh1VKH5ZK6bSdwIArQW/ITsWnGcHJlVtVqUQFWM3cT7GExQGRyx2TQ2atA7AablM8KJSx1rI8+KlzWcAPRWhUkRXDDQwS5uzAPTjXoFC5bX+3D4w2DeDF9jJJ7brZ+8fAmsa8dZu7jNvCsQb8EVRLSofH3Kj/SPU+MTer1D5cz/Isb3BPqunrcZJvbgQCM3uswzCZx8KPK7UAU0S1AuYgnq9Fpj2Kw14a56tYtlOYGEbKsq38UpL49qMsmnljOHPpMXKQ7VoP99mYudzKDm3WyYmbfKYpMbYoX5YeARcmfGkAfqT8zkvHmXwYpWS2X27AANQspQDEO/Rf1AZ9ZaGBzSCEZwiMxmUFY3XlQRCap37RXM/s/SaVbBMmHzRGwX2EkeYaAFXmvyQcZGweoICTwkxjGyB5iggrTfwQ1LN5fJSGqYbVYxqeEfIt+e6Ed/Ooz1C4Amsh9IhQWTxsbtXyTtgwk986WwU7tiqh5ofoVm1deHAzJGjC2vlSw+gF8ooFWh7JcQfWr6A4EBzNhhPTndY9m7WchG+aW8uq+BCFXMt09bsKkYqq6gCEbc/QFfFwOBURAR/yvvbCIloCXWQjGwAznKUpnFMeok=
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


