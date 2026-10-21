Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19F1606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZDCyr2Q2
Received: by kanga.kvack.org (Postfix)
	id 6642D6B07DC; Wed, 21 Oct 2026 18:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D186B07DE; Wed, 21 Oct 2026 18:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504736B07DF; Wed, 21 Oct 2026 18:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0866B07DC
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:55:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A1951206D5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:24 +0000 (UTC)
X-FDA: 85348141368.03.7719CA8
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id ADAC31A0008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZDCyr2Q2;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wW947gQyLZU4t6f7nTdHiVco0/uKiWm2bQ0CXFj7rVY=;
	b=Pyhgb16/KmiUFGerP/cpDgYfajGQ7HHOQdDKaT3bTvbMdy4Jbvo0GMujQAcI7eQXY/T0Sk
	CQ91EnLVaUXXQ3rX7ScvEHn3wxkK3P5M62zADAMACLeuRrF7ZmJ2JKuHFNmiEqdB3uxoK1
	Y+L2yOr84iYKGW2wnBBUsOQi3puPCVA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623322;
	b=KbJCugotn71EHI1jKljLeCCQBxpnpu3I6Sngk9yNlTvNgQx1oAweDQdF4W7DuhNmPLHL82
	oZZSBeV32Fs1rNDnqWbyN9EQsiAs2RS2ld3o6AP4etamJCk7pUwhbertFpB//Ax1YCTtqd
	P9skNY5LrbBgw3dcE0sZ7WqVt/qa77E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZDCyr2Q2;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b0a28a720aso13187107b3.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623322; x=1793228122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wW947gQyLZU4t6f7nTdHiVco0/uKiWm2bQ0CXFj7rVY=;
        b=ZDCyr2Q27SEORY1e0THh9rbF99HC6BkQEAt5ILXcv8Qg3fX+dVY7M3TUr5IxQ1K3KO
         p6XtwTeQFs3DoydUSr3F6iJL3sMwBVT0FUVP9tasqZgWcX+35SZdARxdOa5Oed4QLbnL
         0nfm9FD23D2MqITYW4Ot+1PR1o23ayD0sStbUM4rrLrCAPNVbIN32jHvBxExZQAbbFSz
         5VHVj2veHGRTlsM0hGvoGqJRH3X4+bVy3i4ORRR7N+x33GD+6LzZg3aCTKAvem7miOMf
         IhXtka0on7bpPTT+4RBUPLWc4NwDGb8tIiDLXWVDEzSvw40Y3VuBmRzds+UimxfXoRrg
         MXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623322; x=1793228122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wW947gQyLZU4t6f7nTdHiVco0/uKiWm2bQ0CXFj7rVY=;
        b=chhgLqZrxHuQuZd5fNc93CeP9rBybTgXxdKJHn5OA90+/QHHZkTpCZCBIDE9bVR57F
         nyyN44d3NkYGglPTq87LyB5Z32l53xITADf/Ivdxho/DocN2Kesovm30XfFB5c8hNPwA
         FE8ONlW/GjrWCN0ifPQbh170h+Ggml9fzUTY7GPeRNA3uWOX80yIAYHkjVInn3AwFyX+
         m8QxNgYn07taUPi+kwScVzgEtb4h/qakgS4hU5RUg3iv8Kgu0SBQz8eRdCG6Xi3nwTl9
         ElAHEGNVSr4uTWuCN+3zuH2hUzWAaly6HTSRcIiFCn5hi5OY05th0apBGm9G4+vEln4Y
         WWLw==
X-Forwarded-Encrypted: i=1; AKwUvBz1mcj7Ki8B8SCI8/Uxhyt5KRbkNwvq/M1e00Cg2qnx16wnlhEqbfFmOnZfP8o7F3H4u/QX0zrkPA==@kvack.org
X-Gm-Message-State: AFq9FYLWFNPIIMs3F3z/o9PtJ3xxS5IZ9lqON1QVHyX1MzX02QUWNfNH
	3jGWI7p1chPpOW38Q//JnpwqY5rMHW82FcEhmsruFqNmJ/TmLFiPQ6Zs
X-Gm-Gg: AYBFou2oWKZjDMsPvZ9ZNfhgX48rptCP1RM/bG4ofI0YdKIhfF82fajlbB1lsixi1VB
	4D5ZqCvsUtdgbwqxQNxjXlgmiciMIV7trG3nM9+xw4TuROT6ei950pDITz3FSgiJkUVxqq8NRF+
	bzCvPeYMc3WR6neRwgHOgShdkulUixCJXfGi5YSlnunXDagWC44vO6okR7KLL69kncSdxPBZyfW
	etNNAt7NQCzUSzCyCnAWLYs9v0TBuJMikgPm8U683vBGQwqGmP4bHXw4dCgkewW2oX7fuPSTIv5
	C/lXy06pm+INLuDSkXbLzP3L//HjdWVHE6dbDjlRWmmxfvpxnnx2XPYasZRbE20DdlKq0PZSphL
	BcEhznAzv1gfpPcIUm6Fxo4gDQhTRr52ULC6xI2yIK+LAoWhRJRuwtOwn/kGIRXJ8QHtkgf+8EI
	Z9rIrSPbzytwusuHiaAO8P93Vx0aUyu5JZjvafJhhFYaVasUXkCPI68wmYTkH5bLWTwJESdcKRg
	xeLiSCKci2OiD9+EdxrGJ7EZMBxTBQc6+HkDgFRoj9qDgKHbz4Z1XE7YsTWt6jRYlUI13RWJEps
	uFRRxMtmzNv7
X-Received: by 2002:a05:690c:ec8:b0:8b0:acc6:8e5c with SMTP id 00721157ae682-8b133cdb0edmr21026557b3.9.1792623321768;
        Wed, 21 Oct 2026 15:55:21 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b130071fdasm18132867b3.15.2026.10.21.15.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:21 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
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
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v7 4/5] mm/memcontrol: move memory stock to page counters
Date: Wed, 21 Oct 2026 15:55:13 -0700
Message-ID: <20261021225516.1620680-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ADAC31A0008
X-Stat-Signature: kd79nqp4c4zw16ij9cf4pot3f7s5sxmu
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792623322-308547
X-HE-Meta: U2FsdGVkX18n67J79DKAL+CWH3hPEGuWxvGI77hgFXwron4xFq/Gomxhe7jeRGSWFWH5raZ0nbE8UEZ8WFM3+BbTiEhPb25vy8XMwK8Cd5nxVan1FxQCKx2VR7/t4TKS9jX1SmzQUPc29cPT09cfI2YYgLwP2XD8yhSpokc+Ma6+Sy0NexhD6Jcfzzh+o2DxS8T5m9aQfE5XRSFtUS80C9lF3rU081VJ7dumzq+zk4jJDdv8g5vsn+NaNLeaCz2BBpU9xcgXjMvOXGtncGOaL3dNR5t/iIlKfnfHwq2eoj/mE8rqmKw6Y/yTeZEb0+MYtqW0apayMKSWA6vgJOr1UPtgLc0ZaIWIPjbJj6Wcce+WLKeJGarqOfSTPdjPkyOjB+Zv4+z2dsTYAZeTvfSBMvKpR/qzmctJTmulRdoiIJ6v2Z6E8ZPkDGUXrZmxityCeIO+pSqMr92MYdMsC+ThfNNN86Oh1L4TzhInUD1ZvXt5LFWNGfznq37AtKgsnZekxCrQ9Fiy+8FCoEztnsuigULagWjxKURymJDsg3yYe9GuEXP54jOkKUP+OeHZQSIS1lWv+GkI5vLpCofL8DLDV8Oqi4wHEtdGPdtddNExrkeyLtDxg7ytApIKyXVaElFqKGqgVadQjlRkMXkuK1JgQlMoqkrKWyz+REA8iO5UjhE8hjMwME3+TYnX6aJvkPh5QRLNbjEl3q9yZf0pHn/mBVheKkpjxQc2pTYroI5+q8WMnjB4YeT7XTD8oVtMxEoPBGxLMuV1NIH5Uow6RfoUOpM45xg/oQRooAZvUj6SN+nx1CZ7bBmGXbAxMjTikwlFvLufXkBDmnlPgt0lKd98r114mQHHLL8VZLWtzniH7Rool25OZaLTZV33mXsLu2rp3v8Pc8CJ8QuYBoVm7SLIBuk9bWWUZB+15oasip4ZTpDV2+LppK4eKQofRkBSvP4+KO17AII3PJDbBTJTvGb
 Gc5KOjAc
 utLp7CXSWV3NukmBj/EEV3TQxvKet9hYuma3fBXURqqL48r9XJdG4Q1vVyoUw8+DEMPeQbll75R+ofdiD3J/gCCS+7SZruaaVbpVXxuA6b5aWuHgcfvThkXobWTnWhqEwmKIHOF82ENuuhu2H07sF5A4NTq+xVf/rpGzZFd2ItU7deM0R+5ERTijO+7OdtesO3NYl8uTmmzijq8DMp/lgCG1AGl5fNbJaaSjeBrE9Z+6LILeLx6yiqEcnRVIDSP1Rq5V4rl7LWZtxyxJgkGBh0xe8U9uxCuBaInsX8aye/Rxzr0WoFVdp/pTSt2enDPmbJ75Es3oDI0JJBNGFpTkR2xQMxWzhapQlAB03d6ElWRUZiOcwwbviawO92rNDdrdfwEwHWJoMNY+bNReE0Z3Ylc0IWn85yVUul1ZGVw6cDKy5XH8DC5QkMbxeiHKLYpf5IeT3WDP5scgDytJSlN4oSx2mhKj6R9y6502hgrjCvk8YxMiSVxpMWryt66ueO/ro1Hv4pYTAmIsfJw0ShLKE/IIKWkFVq3TazCjQv4+i6FreBCiRhbK5IIjjqvofG+mrrasJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Transition memcg to use the page_counter_stock for the memory
page_counter instead of relying on a memcg-wide stock.

One aspect that remains non-transparent to memcg is the uncharge path.
This is intentional, as the caller is responsible for managing the
batching. Cacheable releases refill the stock, while already-batched
frees (i.e. uncharge_gather), rollbacks, and accounting transfers
uncharge the hierarchy directly. The refill helper itself already falls
back to a raw uncharge when the stock cannot accept the pages anyways.

Because the memory and memsw counters no longer share one stock, their
raw values can temporarily diverge, and the raw memory counter can
exceed the raw memsw counter. Preserve the legacy user-visible
memory <= memory+swap relationship by reporting the smaller of the two
raw values for memory.usage_in_bytes.

We accept this fuzziness over breaking the invariant, as usage_in_bytes
has always been a fuzzy value due to stock charges being included.
Moreover, the raw counters are upper bounds on charged memory, so the
reported value stays within that fuzz.

One final nuance is that with divergent charges now, it is possible for
memory to fail first even when memory and memsw have equal limits.
When this happens, make sure reclaim doesn't swap, as if memsw failed.
Factor out this logic into memcg_charge_reclaim_options() for clarity.

With this transition, remove all memcg code that is no longer used.
After all of this, there should be no functional change for cgroup v2
users, and the cgroup-v1 equal-limit no-swap behavior is preserved. All
v2 behaviors from memcg are preserved, just moved from memcg to
page_counter code, so that future work can introduce additional
page_counters without removing the fast path.
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
 mm/memcontrol-v1.c |  14 ++-
 mm/memcontrol.c    | 303 +++++++++++----------------------------------
 2 files changed, 83 insertions(+), 234 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index a146e54c6f9f7..2f29315b69fc3 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -122,10 +122,18 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 		if (swap)
 			val += total_swap_pages - get_nr_swap_pages();
 	} else {
-		if (!swap)
-			val = page_counter_read(&memcg->memory);
-		else
+		if (!swap) {
+			/*
+			 * Both counters remain upper bounds on charged memory,
+			 * but cached charges can make their raw values drift.
+			 * Use the smaller value to preserve the user-visible
+			 * memory <= memsw invariant.
+			 */
+			val = min(page_counter_read(&memcg->memory),
+				  page_counter_read(&memcg->memsw));
+		} else {
 			val = page_counter_read(&memcg->memsw);
+		}
 	}
 	return val;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f232ccac69c36..ee1e46e58e38f 100644
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
-				WRITE_ONCE(stock->cached[i], NULL);
-				css_put(&memcg->css);
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
+static void drain_local_stock(struct work_struct *work)
 {
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
-	WRITE_ONCE(stock->cached[i], NULL);
-	css_put(&old->css);
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
@@ -2696,13 +2518,33 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	css_put(&memcg->css);
 }
 
+static unsigned int memcg_charge_reclaim_options(struct mem_cgroup *memcg,
+						 struct page_counter *counter)
+{
+	if (!do_memsw_account())
+		return MEMCG_RECLAIM_MAY_SWAP;
+
+	if (counter == &memcg->memsw)
+		return 0;
+
+	/*
+	 * With separate stocks, raw memory can exceed raw memsw, so memory can
+	 * fail first even when equal limits leave no room for swap. Don't swap
+	 * in that case, as if memsw had failed.
+	 */
+	if (READ_ONCE(memcg->memory.max) >= READ_ONCE(memcg->memsw.max))
+		return 0;
+
+	return MEMCG_RECLAIM_MAY_SWAP;
+}
+
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
@@ -2710,37 +2552,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
-	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter, false,
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
 				     NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
-		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
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
+	reclaim_options = memcg_charge_reclaim_options(mem_over_limit, counter);
+
+	/* Do not retry speculative batch charges after the first miss. */
+	may_batch = false;
 
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
@@ -2853,10 +2688,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
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
@@ -2896,7 +2730,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_charged;
 			set_notify_resume(current);
 			break;
 		}
@@ -3201,8 +3035,11 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 
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
@@ -4349,6 +4186,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
+		memcg->memory.stock = &memory_stock;
+		memcg->memory.stock_css = &memcg->css;
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
@@ -5817,7 +5656,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_refill_stock(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5965,6 +5804,8 @@ int __init mem_cgroup_init(void)
 	 * exceed S32_MAX / PAGE_SIZE.
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
+	/* Batched page-counter charges feed memcg's memory.high accounting. */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH != PAGE_COUNTER_STOCK_BATCH);
 
 	memcg_struct_check();
 
@@ -5975,8 +5816,8 @@ int __init mem_cgroup_init(void)
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


