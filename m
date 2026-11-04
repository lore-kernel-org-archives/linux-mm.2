Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03AC7606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bkfnoP7i
Received: by kanga.kvack.org (Postfix)
	id 4ACEC6B05B4; Wed,  4 Nov 2026 18:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438406B05B5; Wed,  4 Nov 2026 18:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FFD6B05B6; Wed,  4 Nov 2026 18:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDA526B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:30:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7969F1C42B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:39 +0000 (UTC)
X-FDA: 85399033398.05.FD84D0E
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id B02CA1A000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bkfnoP7i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPJvB8G7lWjKk0VYdV3KVWsRis1hROxsCznjRxccNKc=;
	b=k+QKI+0XRpC4iQvcV1dr7/CWvZ49W3VfZJZ/CxmpRmpjXqkV2doCNrUO8wSFOnqjOUWOPW
	iSnD+IQV9pr6TAF4DGrWB68+PpnR3v3Syne+SXLLDDelfwwlZ0RDvP37Fq3/K0KHarnxYa
	EMKMeoP+T+aMRgmbEmEwG594sJefPVQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bkfnoP7i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793835037;
	b=oqZ6N2sPUTqEWWUIvF82iRiItAepP79Hms4+1xRrarFp2u+FiyS4mLf8pG9xb9MCT7YKs2
	mCZCMfZjDVDHja476lG8TppBfOKw9jiaVRv37wbWBRXdTK09QwNfvNUIWNtM9X/V1fLA3n
	Jsl+kFF5kn8iT7Id/1NM5RnGekiCU40=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-67bf3c6654fso1322793d50.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835037; x=1794439837; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mPJvB8G7lWjKk0VYdV3KVWsRis1hROxsCznjRxccNKc=;
        b=bkfnoP7iTCmt194PZwhTKLbHlZhMtTXlXqPW6HCr4pjl30OPA1hMGeLgvTlo3Pfy/a
         xSyR+fS16wDVvxAuVARgZNmzE0tiSeizFjXokp2QK1CPPbODHrFlcoBiiHMj/SRlzlsS
         4aFUOlVSW9lxTW6xr7VPPkcvdmMpvm63BymHohliR9ogg1LNetLvVsSi4v7W171789et
         kA57eady2leDC8VAgcAnu6P8kMeWFlz3eHEyKlHf4uh1rrleCHoohaW6VM4X5ZVztnaA
         ZoVuCmrA8be55DmrJYn9Bw+kvgVg+i3FUNRjYpqM1q0HAVzrj6+SC1wCbU61nIfYSKep
         OA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835037; x=1794439837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mPJvB8G7lWjKk0VYdV3KVWsRis1hROxsCznjRxccNKc=;
        b=GPdrZ4s6fgaCMoV1+jogKwPdr+NLE0bgsInijmQ14aR+nv73HBrC/7pt6h4NSPXPQu
         9iS8iYeR04GDOlzbJRfz0TXheyQjVC0blzu0fNQGlssHg9jwSQbDcGXF6ZsP6rlU8ur+
         zBkUumOSoVtyWlCDkgqVed2l2js4FJi7towPEAfxdBBHiszyqNkAF2nf/v3ykN9wos8W
         v8+1ahEIyXhVviUiDV7j6YlI1oo6NepRdKGms0uHF5WfWxB1apqAvHNDkjK1NgF8aDyx
         jNOXQg+FOUDPMTaT64DSCxtHcwcUNqN4y3o03hYndPJde+kx7AQY2xseJnAOloAs7NIz
         LBtw==
X-Forwarded-Encrypted: i=1; AKwUvBzJtX5QRntCRsW+ruufsZXngVxtFeAUeANCBvZvjoKd46osebC5Q3/B+/bQ7NxvxW7LKGPbsJzruA==@kvack.org
X-Gm-Message-State: APuU4Z8PQ0bqEgt5TGGwTF2kKbIicmch1+yebZI5mmV0vM4d3Lx2aedV
	J49NSHEBdz2Bp8eljhoRbLgMd9xhrqVHUH4lZURtG/aPTydJUb6PrZIy
X-Gm-Gg: AYBFou2EbYW9E6PusVJa9Ry8sM1YhT44W+0eSsWIfcd2wSDFh6dQ9qneub2yS4R5a99
	Npt4Bxk0JhYBKwv4feWPlspLpxrn9sCU7AgupYmrBwjij7zoXwtxqD/6DtTMtubmgDGC418t4EK
	3Q7nSObe/e6JBEhPErJv8jSx6oRA/LY/S/TmkBuJe6lZPZQicHNaYFIeQXkL+Uh4zj4OYnXrSF8
	zh6XR24RpqLc3i2KGXdxnyTg/cM/cYWs8SPsLvltshzJpSpiZdTACH8XmzZqCNmCkOE/BLoAOKu
	eVvHdW9gCNzi00SlKMH9lj+FJQzen4J5CO5HjSI30f9MN7N/rzc1tnubtSVwz6mjnffnUS2GvNO
	Gy9pNr3c0rdIqQyLRQD1cw88IfMbHg5JFqk+ob5LP6BSUPj3XAD5ydqekLvDnxkuTBGYxrA7tAI
	IbuRtObreqEa7TNIJatU/kV19pBLdQ/Jcm9f42BPrveXzB32Xq9pc61OliWUygnHcyeASdfFJQD
	17LEoP8f5n9m1+2X8PqYUbp0TaOKnrDHEncV+K402OKl958pUAEvfALMTwn/EWwvtSGfcSLFS90
	5k3AJ1CLzsxBjWsGtcyP9/x10Gdh3/6RW+1ctYIoFkDxmv6BxZ5TAro9Kidl
X-Received: by 2002:a05:690e:11c4:b0:679:b192:5eae with SMTP id 956f58d0204a3-67ba4eea232mr9937426d50.24.1793835036509;
        Wed, 04 Nov 2026 15:30:36 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bee2449b5sm2380498d50.12.2026.11.04.15.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:36 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 5/7] mm/memcontrol: move memory stock to page counters
Date: Wed,  4 Nov 2026 15:30:26 -0800
Message-ID: <20261104233029.3282438-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B02CA1A000D
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jsgb6pqzi8fbhipuwkt1kkds7eihjxcn
X-HE-Tag: 1793835037-385534
X-HE-Meta: U2FsdGVkX18kGq1w1q6Nb2pYUEdXmZmRVerTv4pnvoYHqOl9gvq0BsywVWkJUP9ARfoOWapItQfosgi0rZU+JiP/7cvMk8DHUmrWCSItjlxqRl0mdQtHbNIsavplVIU7wXCQBdV/RQREdsr5FtDmcC7lLsco0uwVuR4cYJtaBQYmz4kgOXFtRpXxw0sHQ+KEqLXacjTXquv/5T2xe2QbWBwtY/Jh+u857FgSKy0qamQv3QAHeqn1sNTTsoutjVu6LHbE5ahAqzFYk7e9lXCve3UM/h1bFTQYZlzeD/jIVG4YisQvow1zgWDNAlvQX5b23x9vINBPJiEu4YKiqUYDF6buG01lEKWIzZd0eSIf61eaJEPFj27Qh2oWH71q5ZW2Lh8AELjpgi+JyMQjaCQu3zeWh90x4S46es3PbuTRRDoB6Klx6p9MwO95usqE/oTtCwdx9f6DYvYbeTqKGVggCvb8QUeRSlHhTEio2gDWR+4IufxGi5ceUKv7q/RGgWELaugw9Cs9GwXQ2iqNUEGC3zJSZFegjti2KWkVemZWJ3S29qrmZV//wUPzRR0PR6m55l10hdASGmOWOrGGenIwar+t8PuXJt5y1ZRcIi9FF2UFeH6HmAy9u4Whtvr3QoCyQPih3bPBWCwZc/E4uVjR5PYdFS5w27qEkD8lGXVNxERELF9cD5KHro/Sb6sOS7dLcvVcD+H6eoDuHWbRcBYYHiz8QClpGb7bPTnp51HYrwsVJz5Uuq7pztPTNH5Ch7rvG8Vn5h8nt41Qr5PTFuGD7AtYleIFxNYMYUusz21j7/QSc9E7xfeuo8t1auHJes86cQ4HUnGCrXhlYCr7dOZMGWIvqz8xa9ZV26FU1qT3dENajW/witFWCCC06QOJdTPZ/GLxpF53UaV7hVZVLRUrr9ylw+5NGRuM5CWigxe997JZKcRgXv9VOv+Lkeif98TzBDDh8QYNUbZShqdiqBt
 kL5HjElb
 3McE0kv5HeNEvB8ot+teGQqH62pr7rq+jPvq0rTSRwoKw/llToW51UZe75rUj2BFgmtvzD8qG7DtbZ5h8HIYDAdt/TcqGQzJ4OfO2kEiXFjUqniy2Fi2O9RBhJGWn8oJCOsChO/AOILMCK6lwXX+MFJDkkn5pCkkKWJoulqhHTO2vSwJJRF154V5Gdg0uFt3R6bDGN9klS7yWQU1qIwDkLrAgpeSFjk+9Zo9Fw0hbXs0dg6gnTitSSLxU0I9RdJlf5j3y/VlGN3le20Iu/w/eVnV1Mg0cEfztI+yCkV/NiGYJ7iSVhMOc3rXMbPAsysmwWwvExrG6GEKmpEsvb6grGUlKmJomaqvjbE2EwqUvoNtFr/bLgA5RL/OB1Vgj9JazE1hpiS6grN4HrSPzyuOb87W/qd+ECv3NTPUXUyxOxy/u+cmeN7sZmIvo4GIcDpQ0W3QcarhhQCn17Xp4a8AvFHso1IVWNmzGhmNlhFJvxuAFgffpPvRCieRm8K2kfQF8uAkREn5+JDuk1HK7nwkxeZB3JM6qUvwo2AjqdxcuIrcjUmxi/8Vt5wyq0g==
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
 mm/memcontrol-v1.c |  14 +-
 mm/memcontrol.c    | 322 ++++++++++-----------------------------------
 2 files changed, 84 insertions(+), 252 deletions(-)

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
index 75b915febb06b..d03d64969548d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2050,33 +2050,11 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
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
-
-	struct work_struct work;
-	unsigned long flags;
-	uint8_t drain_idx;
-};
 
-static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
+static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.base = &memory_stock,
 };
 
 /*
@@ -2126,54 +2104,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
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
-	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
-		     !local_trylock(&memcg_stock.lock)))
-		return ret;
-
-	stock = this_cpu_ptr(&memcg_stock);
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != stock->cached[i])
-			continue;
-
-		stock_pages = stock->nr_pages[i];
-		if (unlikely(stock_pages < nr_pages))
-			break;
-
-		stock_pages -= nr_pages;
-		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (unlikely(!stock_pages)) {
-			WRITE_ONCE(stock->cached[i], NULL);
-			css_put(&memcg->css);
-		}
-
-		ret = true;
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
@@ -2181,49 +2111,22 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
 
-/*
- * Returns stocks cached in percpu and reset cached information.
- */
-static void drain_stock(struct memcg_stock_pcp *stock, int i)
-{
-	struct mem_cgroup *old = stock->cached[i];
-	uint8_t stock_pages;
-
-	if (!old)
-		return;
-
-	stock_pages = stock->nr_pages[i];
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
+static void drain_local_stock(struct work_struct *work)
 {
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
@@ -2242,109 +2145,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
 	local_unlock(&obj_stock.lock);
 }
 
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *cached;
-	unsigned int stock_pages;
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
-	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
-		     !local_trylock(&memcg_stock.lock))) {
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
-		cached = stock->cached[i];
-		if (!cached && empty_slot == -1)
-			empty_slot = i;
-
-		if (memcg != cached)
-			continue;
-
-		stock_pages = stock->nr_pages[i] + nr_pages;
-		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
-			WRITE_ONCE(stock->nr_pages[i], MEMCG_STOCK_LOW);
-			stock_pages -= MEMCG_STOCK_LOW;
-		} else {
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			stock_pages = 0;
-		}
-
-		local_unlock(&memcg_stock.lock);
-
-		if (unlikely(stock_pages))
-			memcg_uncharge(memcg, stock_pages);
-		return;
-	}
-
-	cached = NULL;
-	stock_pages = 0;
-
-	i = empty_slot;
-	if (i == -1) {
-		i = stock->drain_idx++;
-		if (stock->drain_idx == NR_MEMCG_STOCK)
-			stock->drain_idx = 0;
-
-		cached = stock->cached[i];
-		stock_pages = stock->nr_pages[i];
-	}
-
-	css_get(&memcg->css);
-	WRITE_ONCE(stock->cached[i], memcg);
-	WRITE_ONCE(stock->nr_pages[i], nr_pages);
-
-	local_unlock(&memcg_stock.lock);
-
-	if (unlikely(cached)) {
-		if (stock_pages)
-			memcg_uncharge(cached, stock_pages);
-
-		css_put(&cached->css);
-	}
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
@@ -2376,23 +2176,25 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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
@@ -2412,12 +2214,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
-	struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+	struct page_counter_stock_pcp *memory_st =
+		per_cpu_ptr(&memory_stock, cpu);
 	struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
 	/* no need for the local lock */
 	drain_obj_stock(obj_st);
-	drain_stock_fully(memcg_st);
+	page_counter_drain_stock_fully(memory_st);
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2425,7 +2228,7 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	 * clear the flags here to make these stocks drainable again once
 	 * the CPU comes back online.
 	 */
-	clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags);
+	clear_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags);
 	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
@@ -2771,13 +2574,33 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		__mem_cgroup_handle_over_high(gfp_mask);
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
@@ -2785,37 +2608,31 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	/* Charges from reclaim or non-spinning contexts don't batch. */
+	bool may_batch = allow_spinning && !(current->flags & PF_MEMALLOC);
 	int ret = 0;
 
 retry:
-	if (consume_stock(memcg, nr_pages))
-		return ret;
-
-	/* Charges from reclaim or non-spinning contexts don't batch. */
-	if (!allow_spinning || (current->flags & PF_MEMALLOC))
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
 	 * Reclaim may need memory to free memory. Let it go over the
@@ -2926,9 +2743,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	return ret;
 
-done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
+check_high:
+	if (!nr_charged)
+		return ret;
 
 	/*
 	 * Skip memory.high for charges from reclaim, so the high_work
@@ -2937,7 +2754,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (unlikely(current->flags & PF_MEMALLOC))
 		return ret;
 
-	memcg_enforce_high(memcg, batch, gfp_mask);
+	memcg_enforce_high(memcg, nr_charged, gfp_mask);
 	return ret;
 }
 
@@ -3226,8 +3043,11 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 
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
@@ -4374,6 +4194,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
+		memcg->memory.stock = &memory_stock;
+		memcg->memory.stock_css = &memcg->css;
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
@@ -5839,7 +5661,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_refill_stock(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5987,6 +5809,8 @@ int __init mem_cgroup_init(void)
 	 * exceed S32_MAX / PAGE_SIZE.
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
+	/* Batched page-counter charges feed memcg's memory.high accounting. */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH != PAGE_COUNTER_STOCK_BATCH);
 
 	memcg_struct_check();
 
@@ -5997,8 +5821,8 @@ int __init mem_cgroup_init(void)
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


