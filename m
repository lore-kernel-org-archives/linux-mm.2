Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB471CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6456B009D; Mon, 28 Sep 2026 15:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56846B009E; Mon, 28 Sep 2026 15:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7E66B009F; Mon, 28 Sep 2026 15:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93CD46B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:23:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 222DD8030D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:58 +0000 (UTC)
X-FDA: 85264146156.11.700D089
Received: from mail-oo2-f38.google.com (mail-oo2-f38.google.com [74.125.231.166])
	by imf08.hostedemail.com (Postfix) with ESMTP id 52DB3160005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jMz0AIj6;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.166 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLlbCWMV3nJ6yAKcvozTfTelkpuj4O0zQsMvz607NIc=;
	b=2KJJfxvlVXtsuUJPiABLkwJuEXmhFiVepcPgE8HqBoO3SaKV0kTCVvSXD56dQVU+pnFlOi
	MmmpzOYxQTSqwACm2wd+HuqZeHX0BmeHva6VT9JV/VSP5ygq4naxA0YoOnBnzkAGiD3JGP
	jg1B5V6Bq5112USu1aR5eGnwmLUIyeg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623436;
	b=svtfDwU2tu3J+HQjSdgrkowVLz4W5Xtd3/QhOzW0/QNIj3dC1tuL6mDHLU8WZWxTmYpOjS
	B+4RPy5/RhcZu0h6LuBDceaAyQL3nHjO8Nc24GQ3iB/LAsJ6/faxOZb1NYoFAb3dkwvkxj
	bx1nTNN0ijE5vWIi7oyHGV1AmU9gunY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jMz0AIj6;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.166 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo2-f38.google.com with SMTP id 46e09a7af769-80a71781323so2055929a34.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790623435; x=1791228235; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mLlbCWMV3nJ6yAKcvozTfTelkpuj4O0zQsMvz607NIc=;
        b=jMz0AIj6vraG8d8QLF3bEt0ER/97h3k84nYh0Vg2hh7aEjcPhjK8ruxgtJjCUuxzsG
         RIQd9OiOQMIFy5lthD44e63tHsnW6NxfdSTlmYsPLJswoKghmLSjzTOlrKKcALD6uCfR
         zoeg3mi8lyjEfDYNvHUTa+ufV2T4SyrJmWykk3ikwm8wyTNayEhfpm6aAIcAJsijldic
         V/i7XkC1m+lGgAeLoSP+AgSBqsdJ6l28HN9hukRkV4FyDA1shVzb6t/r3g3rdDwyk5tX
         BAIB1jPOLNpEnVY/3a4IyjzrkqTYALo0cHsmhAAAo3CuKwIdecFrxf4WGyg2hVrLWKpL
         7lzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790623435; x=1791228235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mLlbCWMV3nJ6yAKcvozTfTelkpuj4O0zQsMvz607NIc=;
        b=d+rFFH8JI18mnXdzdMlcu57C5W4Dv2kxJ17U1taYF5hFILVr5PKIGEQB8x+0Vy30l1
         8IckI5rGw14xcmLoIyUKxur9gSwo1YnEkdcguc+eDOFeO7qyX31S/nMJZJZiL31gO6sA
         BoPrDruxkvg0gi8PUNX3VZjh/2VmN/P5wAF2EUFyaW6bLXYqjcMbGrKZsQdVpr4wbX4C
         ITHxEL9V16rDUncBKWvf/b7VMgr/amCfQaPt4F6ler6BnFLmAxk2Z4LIg+96wQVKRFl3
         TmPIWTNrXGS48j5PW0sjWG3WNvAlSXH1jC7tnxTzcte+oq+uwY8bfCUaOi08piiEHfpr
         +MgA==
X-Forwarded-Encrypted: i=1; AKwUvBz3QpJLJbEF7et2jSNJKcvfw+0c+rO7hYVO5u31sloz4vyyrqHKQt7U12+atV+4GuPdaUPsPaQcEQ==@kvack.org
X-Gm-Message-State: AFuF++kHpXQOWjea6zMI53rnqSPl3dtuFEZMu0E83qVtlV++jida3y2t
	TI+vktVDYRfpET4kJv5188hXjNr1UriLBvZYrW4TDoGZKWqvRXqn1BX7
X-Gm-Gg: AYBFou2JOG5s1jKgnYgFUAFKwqycCr0WMcC5LlP3elof1/0DdI76+mUKNBtBoCHsYIm
	uHnfdhSy7mZixPUggw2+PRbk1YKT14IgFnPlDzj/c85Pr1T8X9QJXybIndjjwTrLWzKxH/ozaLN
	y+9uvuAMmnrUnTemEgTD//mGW7nf9FOb3/4iCWLD4hkKwx5FG97GBioFDhlG3DCEH7/reclFna2
	pXGyLFjt3rXKg1XzLSa56GLsKhG4QV83cpSQfHkeHfczZN33sr2izF44xRnaRjgzjuV6TrRGVvT
	APbkvobsi2BWNhD8WXfCSDAIAsUJCgiq0Osl4Gxe3UdYIt5eIi2aW5IIjzMUL+8cow+owTMiQ6G
	XLCpZ0VFJ9jrXdFyRw4GeA7WTwchLybdpr7agYbEUzvwWSnOS+MIBPpw3a5A29UYjeo7vjzKNyM
	9R0aZwV5Omf/mUfK3kP8NfmiFTuXB+vaqcN1E4EU7jWVEacjgUkEzPEJLEQfXF0HtlkD8M48FFz
	aPdA3IDEnsDOqmG/69k8QYQYK3FGtzjt6p1ITlb
X-Received: by 2002:a05:6820:a0e:b0:6da:9097:c3d6 with SMTP id 006d021491bc7-6da9097e034mr1246593eaf.43.1790623435198;
        Mon, 28 Sep 2026 12:23:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4933094a74asm10553089fac.0.2026.09.28.12.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:23:54 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 RESEND 4/5] mm/memcontrol: move memory stock to page counters
Date: Mon, 28 Sep 2026 12:23:47 -0700
Message-ID: <20260928192349.3432886-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
References: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cq7y31nmhfaxxogxgft11mt19rxrnxnx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 52DB3160005
X-HE-Tag: 1790623436-520939
X-HE-Meta: U2FsdGVkX19Iz1LVPJucIowM5jfVWIeUI7VQawte0hOXTKEfhUEkberT7nk7SGrh8xZWanlz/yOisBGAbOudyYJIaGFeO5N1wWxX4UGoxg2tgkYQd56Soz70kFwZgZraYT9ejnjRJHJt3kgLevLNKeC50ILEuth2nSqb3VxMzfbhMs9it3bJX8NWi0S7ZqfawiwIVJz0wBYM6I9gw5KALAsZFnYspYxH62OzhI94CNllt9QINgK5jA7XJ5gGCLHJHa/3tLzvZDusfAcvXSSoZvKCvSKlck+Q9bz2Lf633a7wQW3BJqyb7jiD1VHFbuMKl3sKuYQYg+t0DExphEa450l7ZcUwYSZ7nSzIcXZh4T9+84KriumxZVzQDWlHJBOBLi6B2xWNGV39Ft1s43b9Fmns8MFxannw6kWBe0MmonKg7WZWoTFhIUgTZO2chj9okxwbvOSiaAEmA226swCFHWBbnPa8xpNRCxkmZhjt7BZv4pC+qaywLinkv4tBZXL4G0x6PUjYOFoPXpGT70Aq0Wuc9n9CIHWbpKs2j0wePY0F37yn/zjRonAihhFhpAuu3cj0AEg+QTp5y3WQ/mWhvtZ9Qp+Qk3g6KnQ6z3nHSyVmnrbNNCY8fbH2abG2FW0dpTUvd9zGi4VymaB9xnZ4kasQDp8eFEoMucf7pzhK0NHJqfmRNwkz+0qMgYIhw6rzBpILN7UTowfmz8ONvNXnykrxnoYYJ+RawoWgcWmjdALB50nFE6Yfn5Opg6vJj8POk0s8Up5gESJtILqUkuJMoKCfysHLmslc9/bS0Plnr1GNrIyNs08k/57RvA+0uHod6Pb5INZM0i8g5yqN/RES3dv9h/uz4u7b0JszF6wDp9w8HXudcnqIbwIOwUrZNOLpxXpxDWpTyQm6QYjPyOYXkS8IMfQmp02lJHRjTJ2Msy5Xgm61T4ap6AkX74g0sgyMhpJB0xuVRXKI/SHpOEo
 m23fP0TJ
 2a9yYpCVzS8BBUXFYJ5zQcBqGlT97q9heoSC5DbNQA6ef1hHTfRuaF6N8+GKRbCEaSqb/Qaic6H7gqOYwUl/Q5hYxkZVKBkb3mzCeFQhQ7XkXdk+fbTioIO1hnkm26SfUHd7boFxY8l3J/nKB9DhCaljFH1PhDsl8pvPxINoj8kvCMvZyPfnzfFdnQnF4UShMYPbytQ+wCMsx6pLeJHtp0gpaQtTd/Af0JAE3isrM86GTgWCcj2xYK8uiVHbUmtvepcUBZmrvt5WA5DssqtVunf7nNhTy+tRWakcoFbES7tU6gXK4fVBzCbh+Udo0+H/APS5KSDxm09KMC6CJ3n0l/I0AkIORQBLkmdEE0/kAZ6gBvuVy0M3BCxWoBQWm+rORLbIh2cH+/Gj2Cip370fO7JQV24Kc8fPpPdOUmYboPnWQYv9RF6X20caAa7Fac8cRi6gE7Y8FSowxiLJOLCIAs4hzfFSumXiSukH42NQVO/ShbNx3ipMXzbPhtqs6WjLVq97XF9A5mc6HO1O1mrtLqvYITcWokIS2qdCltlyuCZum4LNIkk9W1DE4yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Transition memcg to use the page_counter_stock for the memory
page_counter instead of relying on a memcg-wide stock.

One aspect that remains non-transparent to memcg is the uncharge path.
This is intentional, as the caller is responsible for managing the
batching. Cacheable releases refill the stock, while already-batched
frees (i.e. uncharge_gather), rollbacks, and accounting transfers
uncharge the hierarchy directly. The refill helper itself already falls
back to a raw uncharge when the stock cannot accept the pages anyways.

Because the memory and memsw counters no longer share one stock, their
raw values can temporarily diverge. Preserve the legacy user-visible
memory <= memory+swap invariant by reporting the larger raw value for
memory.memsw.usage_in_bytes. This masks the temporary inversions
caused by the decoupling of the single memcg stock.

Note that this remains a bounded stock-related overestimate, consistent
with the existing fuzzy usage reporting for usage.

With this transition, remove all memcg code that is no longer used.
After all of this, there should be no functional change for cgroup v2
users. All v2 behaviors from memcg are preserved, just moved from
memcg to page_counter code, so that future work can introduce
additional page_counters without removing the fast path.
Explicitly, the preserved behaviors are:
 - 7-slot stock
 - drain policy works locally and remotely through the memcg_wq
 - check whether a stock requires flushing before taking action
 - exact charging for non-spinning callers
 - report hierarchy growth for memory.high overage accounting

As of this patch, this leaves memsw un-stocked and always taking the
slow path (raw hierarchy charge). The next patch will make memsw
stocked, which will close the fast path gap for legacy cgroup users.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol-v1.c |   9 +-
 mm/memcontrol.c    | 279 ++++++++-------------------------------------
 2 files changed, 56 insertions(+), 232 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index a146e54c6f9f7..5660ba4597db2 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -122,10 +122,13 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 		if (swap)
 			val += total_swap_pages - get_nr_swap_pages();
 	} else {
-		if (!swap)
+		if (!swap) {
 			val = page_counter_read(&memcg->memory);
-		else
-			val = page_counter_read(&memcg->memsw);
+		} else {
+			/* Preserve the user-visible memory <= memsw invariant. */
+			val = max(page_counter_read(&memcg->memory),
+				  page_counter_read(&memcg->memsw));
+		}
 	}
 	return val;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53be4365e2c9e..e666572a7c7cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2063,33 +2063,11 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
-/*
- * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
- * nr_pages in a single cacheline. This may change in future.
- */
-#define NR_MEMCG_STOCK 7
-
-/*
- * Watermarks for a charge stock slot, in the spirit of pcp->high and
- * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
- * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
- */
-#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
-#define MEMCG_STOCK_HIGH	(MEMCG_CHARGE_BATCH)
-
 #define FLUSHING_CACHED_CHARGE	0
-struct memcg_stock_pcp {
-	local_trylock_t lock;
-	uint8_t nr_pages[NR_MEMCG_STOCK];
-	struct mem_cgroup *cached[NR_MEMCG_STOCK];
 
-	struct work_struct work;
-	unsigned long flags;
-	uint8_t drain_idx;
-};
-
-static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
+static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.base = &memory_stock,
 };
 
 /*
@@ -2139,52 +2117,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
 static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
-/**
- * consume_stock: Try to consume stocked charge on this cpu.
- * @memcg: memcg to consume from.
- * @nr_pages: how many pages to charge.
- *
- * Consume the cached charge if enough nr_pages are present otherwise return
- * failure. Also return failure for charge request larger than
- * MEMCG_CHARGE_BATCH or if the local lock is already taken.
- *
- * returns true if successful, false otherwise.
- */
-static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	uint8_t stock_pages;
-	bool ret = false;
-	int i;
-
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
-		return ret;
-
-	stock = this_cpu_ptr(&memcg_stock);
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != READ_ONCE(stock->cached[i]))
-			continue;
-
-		stock_pages = READ_ONCE(stock->nr_pages[i]);
-		if (stock_pages >= nr_pages) {
-			stock_pages -= nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (!stock_pages) {
-				css_put(&memcg->css);
-				WRITE_ONCE(stock->cached[i], NULL);
-			}
-			ret = true;
-		}
-		break;
-	}
-
-	local_unlock(&memcg_stock.lock);
-
-	return ret;
-}
-
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	page_counter_uncharge(&memcg->memory, nr_pages);
@@ -2192,49 +2124,22 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
 
-/*
- * Returns stocks cached in percpu and reset cached information.
- */
-static void drain_stock(struct memcg_stock_pcp *stock, int i)
-{
-	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
-	uint8_t stock_pages;
-
-	if (!old)
-		return;
-
-	stock_pages = READ_ONCE(stock->nr_pages[i]);
-	if (stock_pages) {
-		memcg_uncharge(old, stock_pages);
-		WRITE_ONCE(stock->nr_pages[i], 0);
-	}
-
-	css_put(&old->css);
-	WRITE_ONCE(stock->cached[i], NULL);
-}
-
-static void drain_stock_fully(struct memcg_stock_pcp *stock)
+static void drain_local_stock(struct work_struct *work)
 {
-	int i;
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i)
-		drain_stock(stock, i);
-}
-
-static void drain_local_memcg_stock(struct work_struct *dummy)
-{
-	struct memcg_stock_pcp *stock;
+	struct page_counter_stock_pcp *pcp_stock;
+	struct page_counter_stock_pcp __percpu *stock;
 
 	if (WARN_ONCE(!in_task(), "drain in non-task context"))
 		return;
 
-	local_lock(&memcg_stock.lock);
+	stock = container_of(work, struct page_counter_stock_pcp, work)->base;
+	local_lock(&stock->lock);
 
-	stock = this_cpu_ptr(&memcg_stock);
-	drain_stock_fully(stock);
-	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+	pcp_stock = this_cpu_ptr(stock);
+	page_counter_drain_stock_fully(pcp_stock);
+	clear_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags);
 
-	local_unlock(&memcg_stock.lock);
+	local_unlock(&stock->lock);
 }
 
 static void drain_local_obj_stock(struct work_struct *dummy)
@@ -2253,92 +2158,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
 	local_unlock(&obj_stock.lock);
 }
 
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *cached;
-	unsigned int stock_pages;
-	bool success = false;
-	int empty_slot = -1;
-	int i;
-
-	/*
-	 * nr_pages[] is a uint8_t and a slot's count is capped at
-	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
-	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
-	 */
-	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
-	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
-
-	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
-
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
-		/*
-		 * In case of larger than batch refill or unlikely failure to
-		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
-		 */
-		memcg_uncharge(memcg, nr_pages);
-		return;
-	}
-
-	stock = this_cpu_ptr(&memcg_stock);
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		cached = READ_ONCE(stock->cached[i]);
-		if (!cached && empty_slot == -1)
-			empty_slot = i;
-		if (memcg == READ_ONCE(stock->cached[i])) {
-			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
-			if (stock_pages > MEMCG_STOCK_HIGH) {
-				memcg_uncharge(memcg,
-					       stock_pages - MEMCG_STOCK_LOW);
-				stock_pages = MEMCG_STOCK_LOW;
-			}
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			success = true;
-			break;
-		}
-	}
-
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
-			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
-	}
-
-	local_unlock(&memcg_stock.lock);
-}
-
-static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
-				  struct mem_cgroup *root_memcg)
-{
-	struct mem_cgroup *memcg;
-	bool flush = false;
-	int i;
-
-	rcu_read_lock();
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		memcg = READ_ONCE(stock->cached[i]);
-		if (!memcg)
-			continue;
-
-		if (READ_ONCE(stock->nr_pages[i]) &&
-		    mem_cgroup_is_descendant(memcg, root_memcg)) {
-			flush = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return flush;
-}
-
 static bool schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
@@ -2370,23 +2189,25 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	 * Notify other cpus that system-wide "drain" is running
 	 * We do not care about races with the cpu hotplug because cpu down
 	 * as well as workers from this path always operate on the local
-	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
+	 * per-cpu data. CPU up doesn't touch the stocks at all.
 	 */
 	migrate_disable();
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
-		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+		struct page_counter_stock_pcp *memory_st =
+			per_cpu_ptr(&memory_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags) &&
-		    is_memcg_drain_needed(memcg_st, root_memcg) &&
+		if (!test_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags) &&
+		    page_counter_stock_flush_required(memory_st,
+						      &root_memcg->css) &&
 		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memcg_st->flags)) {
+				      &memory_st->flags)) {
 			if (cpu == curcpu)
-				drain_local_memcg_stock(&memcg_st->work);
-			else if (!schedule_drain_work(cpu, &memcg_st->work))
+				drain_local_stock(&memory_st->work);
+			else if (!schedule_drain_work(cpu, &memory_st->work))
 				clear_bit(FLUSHING_CACHED_CHARGE,
-					  &memcg_st->flags);
+					  &memory_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2406,12 +2227,14 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
-	struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+	struct page_counter_stock_pcp *stock;
 	struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
 	/* no need for the local lock */
 	drain_obj_stock(obj_st);
-	drain_stock_fully(memcg_st);
+	stock = per_cpu_ptr(&memory_stock, cpu);
+	page_counter_drain_stock_fully(stock);
+	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2419,7 +2242,6 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	 * clear the flags here to make these stocks drainable again once
 	 * the CPU comes back online.
 	 */
-	clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags);
 	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
@@ -2699,10 +2521,10 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
+	unsigned long nr_charged;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
 	unsigned int reclaim_options;
@@ -2710,37 +2532,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	bool may_batch = allow_spinning;
 	int ret = 0;
 
 retry:
-	if (consume_stock(memcg, nr_pages))
-		return ret;
-
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
-		batch = nr_pages;
-
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter, false,
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
 				     NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter, false, NULL))
-		goto done_restock;
+	if (page_counter_try_charge(&memcg->memory, nr_pages, &counter,
+				    may_batch, &nr_charged))
+		goto check_high;
 
 	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, batch);
+		page_counter_uncharge(&memcg->memsw, nr_pages);
 	mem_over_limit = mem_cgroup_from_counter(counter, memory);
 
 reclaim:
-	if (batch > nr_pages) {
-		batch = nr_pages;
-		goto retry;
-	}
+	/* Do not retry speculative batch charges after the first miss. */
+	may_batch = false;
 
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
@@ -2853,10 +2668,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	return ret;
 
-done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
-
+check_high:
+	if (!nr_charged)
+		return ret;
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2896,7 +2710,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_charged;
 			set_notify_resume(current);
 			break;
 		}
@@ -3201,8 +3015,11 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 
 	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
-	if (!mem_cgroup_is_root(memcg))
-		refill_stock(memcg, nr_pages);
+	if (!mem_cgroup_is_root(memcg)) {
+		page_counter_refill_stock(&memcg->memory, nr_pages);
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+	}
 
 	css_put(&memcg->css);
 }
@@ -4349,6 +4166,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
+		memcg->memory.stock = &memory_stock;
+		memcg->memory.stock_css = &memcg->css;
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
@@ -5817,7 +5636,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_refill_stock(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5965,6 +5784,8 @@ int __init mem_cgroup_init(void)
 	 * exceed S32_MAX / PAGE_SIZE.
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
+	/* Batched page-counter charges feed memcg's memory.high accounting. */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH != PAGE_COUNTER_STOCK_BATCH);
 
 	memcg_struct_check();
 
@@ -5975,8 +5796,8 @@ int __init mem_cgroup_init(void)
 	WARN_ON(!memcg_wq);
 
 	for_each_possible_cpu(cpu) {
-		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
-			  drain_local_memcg_stock);
+		INIT_WORK(&per_cpu_ptr(&memory_stock, cpu)->work,
+			  drain_local_stock);
 		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
 			  drain_local_obj_stock);
 	}
-- 
2.53.0-Meta


