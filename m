Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4DBC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982576B0093; Wed, 16 Sep 2026 17:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959786B0095; Wed, 16 Sep 2026 17:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8002E6B0096; Wed, 16 Sep 2026 17:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED346B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:06:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C45451A0174
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:06:03 +0000 (UTC)
X-FDA: 85220857806.26.1D89D8B
Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6F76C0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:06:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oSou9mQB;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789592761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPow959ZPjGUlrz9e897hy2PeMPVtPPWVlAib704wP4=;
	b=SPIi+nKgjT5dDrj7XweZzj1eXTAOO1mrH0pHZ9tzmLGoUyrck+rGQuygT3a4o/n2IGTyvm
	dV+Z6L8HN7wd752XhQ6oq6ouWFdQisUNORH2QeH2qsWihOI+dSHW08Nk3EY1mApT6XIWQn
	Jzl83BSGxWoBYapOsdT/AtevjY0m5Dw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oSou9mQB;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789592761;
	b=mRlDksNyzYU/zlXzolwl+uSmQ/Ohq464eSULOgprPntNGwHSeI2ytvyzcTRcX3PiGNvOkh
	JiSk4StS2Z7kHvnAck1WFtXbVNnNwPuCamxmKMfFVdjriV5GjWIqEccZJ+Yr2ZhJ0Ic6yy
	9A+sMA2c2Htg1neAXx3m4iuaZZ7d6Jw=
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-80a854e5b3cso87826a34.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592761; x=1790197561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QPow959ZPjGUlrz9e897hy2PeMPVtPPWVlAib704wP4=;
        b=oSou9mQBBTlx4cZSnhsPl0i0rjyBIh1Z2HMttxLCGMpVbNduiGcXMxLFVwRY7aN3de
         AkBX5Zd6nRITTb9/KU8Isw2TfNlqF7cdDn/cqdTIcyZxh1dDb5BeiS1Nsjep5gGxPG4y
         1EtQKfQcTXgQB120uMzC2oVI4jMwOmNXcWProylaxEXlM58IjdKgd8nv4+SXtKJ+VlCS
         wKosRXhLJU4j1ZJNRFCr2Jemmu/65eUTMJRogXnpOsOgDiJ8rb4m+hrNNQnBqOF2bR1a
         GoJE/XnIYo8IUOpG254NQg1l9YCOn3EGZ3JBiQhaIw91pHeNvULjccmHA0Vy6kMGRXHc
         IITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592761; x=1790197561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QPow959ZPjGUlrz9e897hy2PeMPVtPPWVlAib704wP4=;
        b=YvsKCX7zdJNV3RAPz1vnr66maeGLAJlBQLYYtFspc5WWIlUwYD+4oPEkUbyWLMC0ur
         iURnhTJDmltD73zF3YTcs9dzxUuR46CpD8eWZ35sNhx7asEP011dqUWlw9SMyOL4BcBB
         6rswh0CtNW+3NIoyFrpQNyKNNGx2e3nvVr9vFg+7gL+oxERfoCdahWIgDllUq48audhw
         y8mRkwpfu+IDnsViebw/fWAcXhF8yfTNFvJC/oLjdRpdcTt3wf7b+Rd7/sMa9pQR2nHX
         NOgcXBKBrg/+KKzO3wJaKSafoycwKZQDvyqJjc5+TMmzGtNBfqoeKsgOLZxYoQNgddnr
         mr8A==
X-Forwarded-Encrypted: i=1; AKwUvBwui4i3b6mR6xA6YnWPtFjNzIBo7eYXW/8vYWO5Fq0m3dzKHxC9M6lJAru6o/sP2Jlmd23zFnDRqA==@kvack.org
X-Gm-Message-State: AFuF++kYO/RUMzEiQWyufbz6WdS+kxapKQysbxSixl8C2vgZV7bvfLq5
	IWuMTf7AIJF46IVOrA0WcImgKfIuEPlzo8It5dcTk/LM7XgHlo50SD/h
X-Gm-Gg: AYBFou2K80gfoV1+fBR/XIVfRNCsKltRak/y1D7agx3voTVgOHD4jEG8LjHNMEJ1DzF
	Q+2C0BJQjcwRZO7wvJKBlMXMwBO57bPsi/T6vUFxNe/sJGXAhVLEqLmbSCHwp4kVqKavNMDQEdM
	bKyUWK246BVMt9tTXLC282o6YW5d9HjZdvu8zFS1A/1/+q7MN50QrFABScdH5ylvmHNOafy4nCi
	EJUdJG9iA4Z7saGGMbKPVHlqtDkdbM9ls/chdMBk0k2HaW4FaVQLYlF4SMkctr1bn2FQThAejDt
	IC+Te13xOO5ZbI/YKOiDFcX8ItfMeeask6TyfAMer2GNRVxxazl1BITnEg+ElRdXdIotFrlinbK
	oOEFQZpBg31cYmXJPZnegejhOx/KmaFmxJrSTwObPi/2gSkO4YXV6W5ed0EZwBxC5f3/1RTRqIm
	54K2G+IG4LQRsKjB8nRt8Egv2Hg+qd6YoqhyVezkBzjFwPWxAwXbxVg44chxYg+YJO/5yOI4nFd
	j2vOsZ74hNzikalMNnHKwZ0HPRSRU4=
X-Received: by 2002:a05:6830:6503:b0:7e6:d0ad:5254 with SMTP id 46e09a7af769-80b2cfc865fmr8183323a34.8.1789592760843;
        Wed, 16 Sep 2026 14:06:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:37::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c46199e7csm901867a34.7.2026.09.16.14.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:06:00 -0700 (PDT)
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
Subject: [PATCH v6 4/5] mm/memcontrol: move memory stock to page counters
Date: Wed, 16 Sep 2026 14:05:50 -0700
Message-ID: <20260916210552.891730-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6F76C0005
X-Stat-Signature: sd9o7mjjbjwx8cupf3en84berh5aic68
X-Rspam-User: 
X-HE-Tag: 1789592761-121994
X-HE-Meta: U2FsdGVkX191PEB+Wc5c2cWgD4InBjY2myOwwZQstgEuRelxYvwhaUEBWtvLZrzljSWeIGVr5RJ5OaakyABGCToyNdLZfNX6pSk9P/czsnM4Er+cfc1w41dnuKf1godeZBjS1fvT3kCCVjyPswC/31VhjUSIaqBF7HLeD+XpyqdiIly8sZvj04Mkwj1sFwZeA7JQVOwBVkKicPKmyhHE5AU0fuPre+pQY222+UJu1zTyoV5kkz85ya8o5ROQLZMuGrQTsBmsdDS26HaHFMmNs4+oohhpCv8nskaCnN+B2qxAINJmc7tO+SHOwTqnTH0P8ycaNRPav5tk7C7ITqthPwPb+auVxOTs385iI433BA/MGs14EWNaz7ZDEkaE/tGGJNkttXnAsnkHRaA+jVWVec5HvFFAF1HD96LphSTeVhrbJGL//x7Dj/xd9obDl7Rc9H6bOwvpOcqFU40XwTuVyF3fmZKi0950IPEjyII4hkGI+42l0uqdY7iRreI8L3DESLVfMcEkdyiX1kGiahFvy6YhfaCM0Dc3gm5q3ejJTZgZG3w3c0j/70vEB8Opn2TdlWtXNQmMH3OChtCOLm+IyhYyrsfXi/Khw3/t+NEpGFmE9Cy2e+Vc016yEFMThthmd3bb/m2LIYvT/9Vpti+/ftZhWoVnZyooCxZEn/OYzG8cCdtWImnW9cvjdnW0RVhwzA7diBBGyFPJQBI2c85K2+i1Zcxh8DpueN5X4CyzUYfiOpv7FNPysd3yvNpMdefpxSdSsINlp1FdqBlA/xCKS2m8qQpxuY/Z4OtlG0RL6iaPI8ypiKd2HjxJUWBGsGaYNpfNkIKCBjO9HfdUx6uQa4zhRnYq6eYaue6MORfhSbpP9hz07kR8kCA8MHhtCEucXMBb/pWgApZKtm0PncDpPKmyWFpJLfg/m+5VMNbq93kBP9qYOcF+iQixwFJt6/mNtCzJ1RKW7dE/i5oeavM
 SsW1hrLm
 wSy2TOqscZeaq75beuOzSn4gco3tDbHJ2c2BFxiY7zKeuwlFUWwsZ2kTqAL4qlFc/+vqdPsfJbGEcsNSJ0wMqrNYv61/LsxB9mekhoqvsKcGuranUv5s+Go20fLSPJJ+vJvfmlP8tUQSAqpT9c492i1wv0ve8Qygs0ReDN4heODsSf0pJDWBpTeNkpCAGLB98XP97HBpDuHiooB8WLBzUgdjeMaE/TzC18YC0YAM6YgCaxC9F9TkoY1lYLYawwniWbax7/TS+DxLc0m9DwoqUuW40ckZcvYQ1j3peXscCTBXVYqqek5dc6XnfbqS27frRhvGxUvwMgHSswUjOMPNjuLD1RR0JkIZA9p7KG5cqCoiD09vAvnuTZNCnVAtsZMauKsLPaciH+f0C1RLndPUw4ZzWdxpAOEoMal7Cn/svbu39p1Xu6wW+WVhobhPZqrDa2xf+r9DR4aqChRDJoSohYCy/gmknL1hYi8vq+RFQopNCq8H5/xVDEe04n99X2VXOitIB0e8fOxpxAg+V1sH7TRjHKbV5aPn5OmplEC2cAnMTQ6uQ2vwm+JBc+Q==
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
index aba9e3b851235..22822e7a85b49 100644
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
index 04ab7355c6d2d..1a209ad535540 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2049,33 +2049,11 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
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
@@ -2125,52 +2103,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
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
@@ -2178,49 +2110,22 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
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
@@ -2239,92 +2144,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
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
@@ -2356,23 +2175,25 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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
@@ -2392,12 +2213,14 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
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
@@ -2405,7 +2228,6 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	 * clear the flags here to make these stocks drainable again once
 	 * the CPU comes back online.
 	 */
-	clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags);
 	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
@@ -2685,10 +2507,10 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
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
@@ -2696,37 +2518,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
@@ -2839,10 +2654,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
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
@@ -2882,7 +2696,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_charged;
 			set_notify_resume(current);
 			break;
 		}
@@ -3187,8 +3001,11 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 
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
@@ -4287,6 +4104,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
+		memcg->memory.stock = &memory_stock;
+		memcg->memory.stock_css = &memcg->css;
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
@@ -5754,7 +5573,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_refill_stock(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5902,6 +5721,8 @@ int __init mem_cgroup_init(void)
 	 * exceed S32_MAX / PAGE_SIZE.
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
+	/* Batched page-counter charges feed memcg's memory.high accounting. */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH != PAGE_COUNTER_STOCK_BATCH);
 
 	memcg_struct_check();
 
@@ -5912,8 +5733,8 @@ int __init mem_cgroup_init(void)
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


