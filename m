Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB4ECD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F8A6B00A7; Fri, 22 May 2026 18:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00206B00A8; Fri, 22 May 2026 18:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16AB6B00A9; Fri, 22 May 2026 18:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA9166B00A7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:06:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E567C3481
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:49 +0000 (UTC)
X-FDA: 84796441338.13.7CA7A01
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id AAAE4180010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J9oRZcjy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LcIS+VJgzgWoo9AJl45fIdipLbvB6geiavxJnRYEKM=;
	b=y5KSF+joA7PKDcbHLFuPqLH9Zi5Eup8iykuCNxi76NigqkoDFwHuo7pSRV9mEJQYs/QKYv
	iXyXmokA6eCPOORJJhBAh6+cM6EgUAkZFHwQKxOagb97PxlrfLT7PCjK/0OUBfg4+5yKPn
	RYFF/jH5SwrVb/R3GLfJn00GM5N4rak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J9oRZcjy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487607; a=rsa-sha256;
	cv=none;
	b=IufYfILWVf3ZpUrow3NBQ36n6lHLeLKvO/vB9Wfshfm9iZUA/n+4eC3MRTfKtD3s5gQ6Qw
	dh61bwGYWqTjs8JJQXFy7Y9+BSK9RBtrkOb9nFLryUeaZICM0nvFiHb+52QaJA71Gsov+z
	OWXbnMIGyD4KaUh2AVY/miFi0SVk0xs=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-439acb393f7so8483022fac.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779487607; x=1780092407; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2LcIS+VJgzgWoo9AJl45fIdipLbvB6geiavxJnRYEKM=;
        b=J9oRZcjylivZAzuLdaRlIehckRKPFmie34DsphFLtOr/RlA0FT+OlCWccTg2+R8I6k
         cM+rPvi4ar2mKP/SHbI8n1Jpd10Ve9ExaqLnIRJ5OqApXGO2wJ0qcLch7uUJXUFvhslo
         f0K5vJhe701RkSOM4RvrHfppMoUh3CJ0pABQBT5fH1wyYFoielYDpDtx3w1gFCo16mRS
         xfy2byqobYUW7Uv9YY+oAjcTeHCcSO5OvqmBh6DpcVEE2jIfcr/VVIQt6FiW+V1dPRLX
         uta0mRy4CadZ1C6j5Wy2TJq8WejgQnX8+cK390O3GpWb2zWyLbOoSGZiAhklXFUEOWAP
         ZjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487607; x=1780092407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2LcIS+VJgzgWoo9AJl45fIdipLbvB6geiavxJnRYEKM=;
        b=bv0y1hf73oFRMsy1unmB327BJ5SVQhU8FRMxKL7u6ioWiNtemTgFtJKhEB8pVacOpy
         eIjm4j0RJdiPhOD0K35GaZ9wpje094OzcaU4RFxPDfEpxfm/5JgIxpuPFLK7WQZmC3xi
         tEdbvsmytTB79wsBGEXFGBilLHeBHVB16V+6f0DEzol6eijc/F8oHgtjI9sFMt/20c/0
         LOW+gqdGT6fU1NEBpbnjT8ITOntVKlSF8hHqVcMBQiL9opt+xLyz/BRT+w6EO4/YfqDW
         zWtDaetMRd8cOMsovFCfqM2ELNu1e0oC+2ZcBZWl97sKl+SEgvjxxsLp8WRmdEsbXThh
         KeTw==
X-Forwarded-Encrypted: i=1; AFNElJ/VinJtnl232cL3M7o3IZDjb/I1GJuut6W9lzlZpfLEpiJJb05dbZu1Oc4IqOv8Y1z2Fyv4ug4V7A==@kvack.org
X-Gm-Message-State: AOJu0YzIdBhtSs1O7qUsLkOaVDmtnk2t0qEUo8vTYJT7sky1FzCkwCo/
	2FIfGAZ+WtOdRi8PKJHlEqL5qQsh0JTpFqdlSEZBvfv7uUnfP810TRP4
X-Gm-Gg: Acq92OFXy6hOU0cURL9j9g5QOazG17JvfmPB3l69XVeyU1fb+w6Ca5xNmTVcVR7fKBO
	GB8XTXNNScloj9HkuoxCEzFx7tD2Z7NncfPZrpEFPNN7AUVf8j9TLcdfS+vuhYu2ZMfQf/TMD4D
	Z+gDFOSx4S0HLx99zDqEYXf93775WqkOde+w3skXJsfNmqsg2TijYABPjnd3uYs1S51VU1iU5zL
	yGcVsfgwkMaHlPa5IqCEEat86z2q1Op2UCqqVtnjZ2oG8kPtTS1izFvVAInv+nI6wJUjQYrX+5A
	RtTP2/lSzmxiDLJQRAMnvwlCR6toywxDn3RiyNrw0khazPwWp2rUon92Wlc/tF9QL8rSz5IQFIf
	CbaYcgxPI66KgoGpDVmS8BiTaMZYn2WJgIZlZZENpcX2tptHTiZuvyg4bCkT2IkgRtFK5cQC3gW
	RfPCf9R4giuA36n6Ml0IbL6GrlXT68VTohLEGbyompuBuTpXijnADxNA==
X-Received: by 2002:a05:6870:310e:b0:439:baa5:9f21 with SMTP id 586e51a60fabf-43b5ae75b29mr3333686fac.26.1779487606711;
        Fri, 22 May 2026 15:06:46 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b63512d63sm2857806fac.2.2026.05.22.15.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 15:06:45 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 7/7 v2] mm/memcontrol: remove unused memcg_stock code
Date: Fri, 22 May 2026 15:06:25 -0700
Message-ID: <20260522220627.1150804-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: coc1orzom555h48cp99musgtat6uax1j
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAAE4180010
X-Rspam-User: 
X-HE-Tag: 1779487607-235314
X-HE-Meta: U2FsdGVkX1+an3pEg1fHhW8flV7IR/fP9RzA6BnFvE7UK6YTC4nhsx9XCY0eCTDQx2CqP0kTg8ZwscNVHmsflo7ey/w0MJBq20KdDGJwu7/X9h0dSQ+ZTrfwk3aKkL/33SA8jJcn4J2unvZGzutOtfxMgoHpBMhoRMH98bkCftQnIu4+yJZMN/B4vGJ43Rc69uSjK5zQj9eExE2Zeg2wJBKgl8W3GpsqQW/FWYIe6xqSm1EwGSmXCvcNXHAHokhSkfn+p/lOF6K2Benji2u4zGqmoXA0+QM3I/8i1yUB/vzjdxED1z3xjHphKBR4UzGLahMS8RXMFG0eSxoJ1Rxq9G4Iuy5FqoZkpCehS/CRMyWVHshL8+Vyc1aejdwiMsaXa2jqIh/35u1nowONdhjjLWscC2vMYm6GuWmasodGynIgn1jWKQMGHeJZHesIO+e/kV/LtqgwrZrEEgIxDa2cQku9S1puGFvhU4GNH78Egx27Zv2vJYYHxfgJy4mAMcHMv104id7lyOfVyDObN4zNv7TNu0ecOvcZr5lFX/rFh2UqsCSulQ2LkW87BRkDO3PIywEPlHLRytnzFCm6oe0dOuetVyZFiO9FuTnwy1ErDA2HK+GNi1kyvE1qxKlAi6oqsdUyVfTTakEQj0ga++9ngTFrmxDtdNHILcLk6SAto1lepKOYAzik9Tv4Ap4a62HB5laqJnrsNDaBOpwXMhfEP7S7SQbrOdq6WsDd4u9nIDHkmuD/Qszm/BewniaKCGU1xgbUyhcwi/f1KPlESv6Owlr0yrWp14e21vLhVrdzPGjWQIj6K0VJMZNq57Gkxx0HWkhlcSUsX9x/ErkvxDm6lGWwmSYr3YU6J5taqPGYVHaJYcqOrLvkwKI86j9iO7+srJHsFhWvPUMfo3oBmMrE245Fq3k8cBi5F0YRRK+Q4lCyMnSIsUNd3NsaBkiv5CWm2CoUtuAHbI+DeKXJG7K
 +xc25HA5
 ftI3qyXIv0My6lqHarjscoCSpLPbmI/PTRj37wFMjAgN5uuubGpWB76a+Rh/3qBgt62Y+/EtaU0IcqgEmIVf65IDnRBrOrIWykCyVvpp86V55ZwU8Jj/whuVl5kI3czwTjw1U88IxLEnIyn8FRYU7lLVbWVdEoqSnqXDC0qfWtz25nocVeIQriMHj7vbi2yK9/ij+mtNU43evP0jcIAYcBToYGiwIE5Sn0+m8WVwp71DQJxgyN0+V5ir+KjsiZjOoHvj0tSOR/GGPW/jRVLDdToQ9GUuB/i/dipE4Rzt9vNx6FICReYrrzEfM5LYutIQ5VHul1nmwo0IXUg4Ubv/2tcsInRn+Zq5tn2XSfD7FI8dd4F1k5UPnBIwMEHvzsDHfLGMIy2iKGWhsJpta8Hmqm3OSQkitY6q1hK7hnDdbgIIc5t82sZa0vnjt9joocMlNfda0UEvD8ZymlbidxnDUpmqmsvFChXsSyKQBuxkFN25J9qWgNFdf6H88/xNnMxOBfM7Eqa1aaN7pUEVeNSxcH87sIFTFhA7wJM2B/8AALtOSRPTq0L6npI/KrubkYrVcOw8JgA/lkNtJM12OACTu5305a87qptyyy6STULg2UCQjmQVPjuvtISz6DJqwVz9C+ehG8iNczjKfcgmTwx8/4d++1lVYpm1q0T0bJYMF0XpcyuGoD9SSBNeCaqt9Sjl6f0hW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all memcg_stock logic has been moved to page_counter_stock, we
can remove all code related to handling memcg_stock. Note that obj_stock
is untouched and is still needed. FLUSHING_CACHED_CHARGE is preserved
so that it can be used by obj_stock as well.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 183 ------------------------------------------------
 1 file changed, 183 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fc1e1b10b6ab6..24774c272ef8c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1810,24 +1810,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
-/*
- * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
- * nr_pages in a single cacheline. This may change in future.
- */
-#define NR_MEMCG_STOCK 7
 #define FLUSHING_CACHED_CHARGE	0
-struct memcg_stock_pcp {
-	local_trylock_t lock;
-	uint8_t nr_pages[NR_MEMCG_STOCK];
-	struct mem_cgroup *cached[NR_MEMCG_STOCK];
-
-	struct work_struct work;
-	unsigned long flags;
-};
-
-static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
-	.lock = INIT_LOCAL_TRYLOCK(lock),
-};
 
 struct obj_stock_pcp {
 	local_trylock_t lock;
@@ -1851,47 +1834,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
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
-			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
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
@@ -1899,51 +1841,6 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
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
-{
-	int i;
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i)
-		drain_stock(stock, i);
-}
-
-static void drain_local_memcg_stock(struct work_struct *dummy)
-{
-	struct memcg_stock_pcp *stock;
-
-	if (WARN_ONCE(!in_task(), "drain in non-task context"))
-		return;
-
-	local_lock(&memcg_stock.lock);
-
-	stock = this_cpu_ptr(&memcg_stock);
-	drain_stock_fully(stock);
-	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
-
-	local_unlock(&memcg_stock.lock);
-}
-
 static void drain_local_obj_stock(struct work_struct *dummy)
 {
 	struct obj_stock_pcp *stock;
@@ -1960,86 +1857,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
 	local_unlock(&obj_stock.lock);
 }
 
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *cached;
-	uint8_t stock_pages;
-	bool success = false;
-	int empty_slot = -1;
-	int i;
-
-	/*
-	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
-	 * decide to increase it more than 127 then we will need more careful
-	 * handling of nr_pages[] in struct memcg_stock_pcp.
-	 */
-	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
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
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (stock_pages > MEMCG_CHARGE_BATCH)
-				drain_stock(stock, i);
-			success = true;
-			break;
-		}
-	}
-
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = get_random_u32_below(NR_MEMCG_STOCK);
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
 static void schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
-- 
2.53.0-Meta


