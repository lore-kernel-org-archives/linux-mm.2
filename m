Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D53606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Aeuvsmlu
Received: by kanga.kvack.org (Postfix)
	id B3DF36B05B2; Wed,  4 Nov 2026 18:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC626B05B3; Wed,  4 Nov 2026 18:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967276B05B4; Wed,  4 Nov 2026 18:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1556B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:30:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C89741608A8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:36 +0000 (UTC)
X-FDA: 85399033272.22.4577B40
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 02B1B1C0011
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Aeuvsmlu;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLEbYdbz2ZYNUmD7gx73lbpFTU6wBtu/7lasgoqtOEw=;
	b=IOiFGFrf87+c2EEhOoh1JYY7fehHAcCf61wcVY3Te6hTWjO3MbQTNNHRjb77yVJit2W0Vv
	VpDycMStTetS9mmNGjrf5N09sQzEK7e1Sur5XKA60g9RyLWp/OzFT0osoMleMEIJSlqs01
	4qpcJso9859qmpO75G8mAESqTrXyDGU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793835035;
	b=y87n5u1CdvtqtOouiwz1iR2UpX/x6TEWtOTAQgb61yQfrU0qqYo1ZUtpkMc1letkHSDvzt
	yZsjLQVx1s8Ss8xQX75ciELu9Zyj9Gwgw2zIWEMxyaF1NxuReT0txK4FqbZhtXo9qGJAAE
	GB4rI/k2c57mXjpYVoIYIDX1ZqfAhkY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Aeuvsmlu;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-67bec5dc8d4so1299353d50.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835034; x=1794439834; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FLEbYdbz2ZYNUmD7gx73lbpFTU6wBtu/7lasgoqtOEw=;
        b=AeuvsmluCb/E+UaYe1KnXB5TI6NImOHlQ0CrU4vrpv66l6FnT4NOQ7EMOk+WgvEOfX
         I8/CTA0QKQ5Ekxtk2afiL/XxqxSVNfAS1NNJxL4wkBznNURYOwwj1EI7WoUD8GFmW4kQ
         ofPbQ3GXT1dJ5wFOzcrv41w/LROFGRqvmAZ8VIiNKZzKXadlWmg8JSGDPTwP1bD4Weng
         uy7oR2rS3zparJeoGAP0aAzYLMokPIJ5RKie/L8bxQ5cLg+b224JN9KcD8jpHio5AGOW
         ouJsJWQpq3PAjQvtgoigipIv3IOJKp0xxhbv4MwqZMLeFSFVocBJaefLD4pFy4VPuqTz
         XXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835034; x=1794439834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FLEbYdbz2ZYNUmD7gx73lbpFTU6wBtu/7lasgoqtOEw=;
        b=BppTPz21vB2Uxb+IskxCugb2NGFQwjq4l+uVwHoV8TgMi9/tn6axC1tWbIkfykOGL1
         1QLhDwlNh65StOeoImWKB2kXf6Nmo5fVLx5HO0YLb60nhm/yan3v0UZeAMNQO0ZZwPP3
         xByS51Aom4bU8RJ7k1MgVKKI5Sg4S1Zt29UX7P0mZcuOxKcm0oOzpOSCjVVjjysxR52L
         KdaQtlPhLI5cs6A5nSmNcvkiIDquMu208EgN2r+EhlQVgCpU5AKWEqCO872Yb0oqk5lq
         EFlY23T/yCxwx8GS/AXjT64YVMoy481xoh+Jyx4GjZsnInIlz/pcRmkb3tU1uMgecRXE
         74mA==
X-Forwarded-Encrypted: i=1; AKwUvBy1ua+9fXL6pf24bY5nhFqXVnyu0Hvw4tu/zqN8EJNiuWHSXox+IpeGeNT77GTOKqkzMMvulQgSOw==@kvack.org
X-Gm-Message-State: APuU4Z9HmGoCjDhU6RBRBrn18Dgz1canaVeHvIffrg1gmMxn2vo99qwH
	MU2EVxau33zPPEnRzgPIBn1rhq7xIyZ2UiQ4SVUTBZ2wz+yo7sRKENph
X-Gm-Gg: AYBFou2NmywXwcRa7W2OlO5mYIVChXYXdcJCIwoOBSPKd/zb+J1o0z+HXdYTgh8mKm9
	X44eIsDy7kW44ADrRHD+Hq49m7C217MIXKDtzJwP4zdx+gI1yZzskMW9JeF2uO98MdO+Wzg/8LF
	uJF/dda5A4b9wQxgRt6r9s4cTt/05wuVm8umX82lDkJ1NphvOCwGH16kW0MHxgV1i5jsFidww50
	+Igu+5fAvfF075jit3NWxx8V+Ii07zu05anmDNCjCrygRliQfaUoU+4/jP7Xredtqrbw8VZWyWc
	DIbFyiF59TGr5guXkfxhC+P8pTU61XGxX7qS7An2MQDeSAuOpwyKuw1Bkohy99LlAtUk11tFv7Q
	vkoOqVP1DQmZI2+Q8E560ZtCNf6jtyKKxmBxQBsrIGLkeHWm0+53Xi2nvrvpuvXokHjOH8XmxCp
	/DGrsDskdODuhCn2Vr8CLne8ualxTEudbrYNHMDW82LCQBqDPqvrDM/7UAK0/TFgXPLEtSWCqbQ
	v+DCMFUCR0UnHw7QXheE+SeMxrHmIub40pgeIEpaWxjYoHWCM+Yk0om14TQP0CCvGijxuP0kXhq
	UUJP5heGEVD6CiKSnoE0bj0STlyq5TmKxeCFJifpaAaTQhLkaz0ge3FfQkA=
X-Received: by 2002:a05:690e:1c1e:b0:67c:7f7:206e with SMTP id 956f58d0204a3-67c07f72658mr45393d50.77.1793835034093;
        Wed, 04 Nov 2026 15:30:34 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bee2a03cfsm2382004d50.19.2026.11.04.15.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:33 -0800 (PST)
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
Subject: [PATCH v8 3/7] mm/page_counter: make page_counter_try_charge() stock-aware
Date: Wed,  4 Nov 2026 15:30:24 -0800
Message-ID: <20261104233029.3282438-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 6bq3s1bqg3qtghddkmyx438k96bxqnkr
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 02B1B1C0011
X-Rspam-User: 
X-HE-Tag: 1793835034-161480
X-HE-Meta: U2FsdGVkX1/PcG9/WYSJ5jhClN4/hw+ZoV9Z7jzoe4ji3QQjeSsYn6638mPubkJg33wGxqoc50w22YXiNJEa6s0EQbPmFNQmESJsE49LQDcMnIM1I0/mprP8z5YDFuJvn7tc4Rf0N7CaMfKZ2Z8c7VFEKbvhY/7vSiY7nc0ltPMwKYRxNwU5VDYHk8JBb/v4wXQZtrQAgArUEYsSnkCjz04p7+Q+uY8jPCyC/gCoVFgbmfp5C56ClOErs3zX3UQ9waa4A8V+0kiwokYuz7SdRLZywBrO8znp2j256zpS46xLy1SP3d3GpummAmJTOQ+OGOzX6sFUDjHSvtSt5CZWjMYCjFc2zEZenTcrysAQjZr4y0UvGeMlAiSg9ruPxrvt7jmhakijMKqhby6+m9Mn6svUYwuBV09e0oBVYUzf/nfpPUtA6MKqdSDxZZTXcrFvQt6kGogMdRCmwfPmPZCeL08LmFBmbOVu5lJGgG7XAnRamH7PW+DbzMseh8VgggHBIsFYQo6hhbDBmyVK1boVsHh0mUZyaJg+jJVvB3HKa3oTPuS6cgkmS4EWWBm8fQw+Mqa7fqJMOhlECH+xBxIY3zCk+6nMI5G6L1D+TDTfTju9HXSu2mO1kBmhr/S8TeVxaNDcxWvHvpezNA7Y1frcJEjS51TVapwfRzbYfIwpBF8/urm7eaSQ3PrhrHXgphrUvUU5P1XUYfd88B4Yq3eV4z2J6uqDuf2Kz0FsMtpskY+9jNQ4eNYx2YVob0IH0iJ1mgo83LeCmp8dDbFJIEHmsSdfIUnrwz/caP+ave1oduN0iDsvoGr3bufq/6BPuCQ83ybNuw0eFtpy5Q9KkoIabVgUZExmpvah9UYhiUyMR6pZ5o7yiIvQG5FRN9ZnKsOECFv5zcco60Pb/pCB0dGgQCkFnJg1fKQaZGXRyMWOsPnlP0jDfF+YYqFrt6EFIaFmNG1TIBHQm68bWD5FEcv
 pabr7c8l
 xNbTnsjJ1E61/VWw1Aw3JjUZ0JL0W8Ajl5FytMFyj9aiEESyDKG4TQ/FNWslynFGf0vbjWbP92SRT0F3+9aeSA375JLQOZCjsukila+cqehkHDf67C3qHN1ShUD7I4hwdOHqTnHyxnfTnGk7zxm9ZF/P5CEbq64AA6DlskO67rW6HRJS6aV/FxioFR6zGtF1wjJg4UZRryR3d8r4tR01md1VaMraSmX7lYCCVTgn+tJ5Cp2k/NVrweZmGXTYHmAkD/JLmz5jMH09iZlPRrdZSofGIvPQHIUyFX57fTyG7Q5OXHZbO/g6GBVIM/LHFSTngMlf+nmxh7oS0oeYLUFFmpf7U2mEwcSQPVYkgDD5Qn7zhGIcRdrpT6egE0GI5PyCyGL+tt+aiykJykrThY7ZSe7BC5D2qluAStF0domISTbOtn0tj6FOzJ4e1oQqstljkNPCutyeobuVs0AYic9rGZsrDYxC1Xe6ZM6PLJeQX9nIZm6/NhBJFQKsKa7HU23XyO9Om2uhHZgIlotzJcHsJnK02cMOAx6sFoFg/atoXauauxwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Make page_counter_try_charge() consume stock transparently to callers
while preserving the same semantics as try_charge_memcg's greedy
charge attempt, refill, and !allow_spinning special case.

page_counter_try_charge gets two new parameters, may_batch and
nr_charged.

may_batch is intended to preserve the behavior of !allow_spinning
scenarios in try_charge_memcg, where the goal is to charge as quickly
as possible, without evicting other stock slots or making a greedy
charge to refill the stock.

nr_charged is used to reflect the size of the successful hierarchy
charge, preserving the existing batch-based memory.high accounting
for current->memcg_nr_pages_over_high. As with refill_stock() today,
the full charge is reported even if the excess is later uncharged
because the stock could not accept it. This only affects memory.high
throttling heuristics and never fails a charge.

So this preserves the existing accounting heuristic. Accounting for
credits returned by refill would be a separate behavioral change which
may be addressed in a future follow-up.

As of this patch, no page_counter has stock yet, so there are no
functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  4 +-
 kernel/cgroup/dmem.c         |  2 +-
 mm/hugetlb_cgroup.c          |  2 +-
 mm/memcontrol-v1.c           |  3 +-
 mm/memcontrol.c              |  8 ++--
 mm/page_counter.c            | 85 +++++++++++++++++++++++++++++++-----
 6 files changed, 86 insertions(+), 18 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index cf627c5090093..58532259e7f59 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -98,8 +98,8 @@ long page_counter_margin(const struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail);
+			     unsigned long nr_pages, struct page_counter **fail,
+			     bool may_batch, unsigned long *nr_charged);
 void page_counter_refill_stock(struct page_counter *counter,
 			       unsigned long nr_pages);
 void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock);
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index d49ed5d4a9237..dd325e9413fb5 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -736,7 +736,7 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		goto err;
 	}
 
-	if (!page_counter_try_charge(&pool->cnt, size, &fail)) {
+	if (!page_counter_try_charge(&pool->cnt, size, &fail, false, NULL)) {
 		if (ret_limit_pool) {
 			*ret_limit_pool = container_of(fail, struct dmem_cgroup_pool_state, cnt);
 			css_get(&(*ret_limit_pool)->cs->css);
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 3fb41311e4c7d..bbc2dd3fa3c97 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -304,7 +304,7 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 
 	if (!page_counter_try_charge(
 		    __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
-		    nr_pages, &counter)) {
+		    nr_pages, &counter, false, NULL)) {
 		ret = -ENOMEM;
 		hugetlb_event(h_cg, idx, HUGETLB_MAX);
 		css_put(&h_cg->css);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b7f2868885071..a146e54c6f9f7 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2193,7 +2193,8 @@ bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 {
 	struct page_counter *fail;
 
-	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail,
+				    false, NULL)) {
 		memcg->tcpmem_pressure = 0;
 		return true;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 66f38efb800ab..311bc2fa644a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2812,13 +2812,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter, false,
+				     NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+	if (page_counter_try_charge(&memcg->memory, batch, &counter, false, NULL))
 		goto done_restock;
 
 	if (do_memsw_account())
@@ -6051,7 +6052,8 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		private_id = mem_cgroup_private_id_get(memcg, nr_pages);
 
 		if (!mem_cgroup_private_id_is_root(private_id) &&
-		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter,
+					     false, NULL)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 			mem_cgroup_private_id_put(private_id, nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 70d76689e3212..e1feb2bd1e225 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -154,23 +154,79 @@ static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
 	css_put(counter->stock_css);
 }
 
+/*
+ * Consume the cached charge if enough nr_pages are present, otherwise return
+ * failure. Also return failure for charge requests larger than
+ * PAGE_COUNTER_STOCK_BATCH or if the local lock is already taken.
+ */
+static bool page_counter_consume_stock(struct page_counter *counter,
+				       unsigned long nr_pages)
+{
+	struct page_counter_stock_pcp __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock_pcp *pcp_stock;
+	u8 stock_pages;
+	bool ret = false;
+	int i;
+
+	if (!stock || unlikely(nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+			       !local_trylock(&stock->lock)))
+		return false;
+
+	pcp_stock = this_cpu_ptr(stock);
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		struct page_counter *cached = pcp_stock->cached[i];
+
+		if (counter != cached)
+			continue;
+
+		stock_pages = pcp_stock->nr_pages[i];
+		if (unlikely(stock_pages < nr_pages))
+			break;
+
+		stock_pages -= nr_pages;
+		WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+		if (unlikely(!stock_pages)) {
+			WRITE_ONCE(pcp_stock->cached[i], NULL);
+			css_put(counter->stock_css);
+		}
+		ret = true;
+		break;
+	}
+	local_unlock(&stock->lock);
+
+	return ret;
+}
+
 /**
- * page_counter_try_charge - try to hierarchically charge pages
+ * page_counter_try_charge - try to hierarchically charge pages using stock
  * @counter: counter
- * @nr_pages: number of pages to charge
- * @fail: points first counter to hit its limit, if any
+ * @nr_pages: number of pages requested
+ * @fail: points to the first counter to hit its limit, if any
+ * @may_batch: whether a stock miss may trigger a batch charge
+ * @nr_charged: optional; set to the hierarchy charge size on success
  *
- * Returns %true on success, or %false and @fail if the counter or one
- * of its ancestors has hit its configured limit.
+ * Return: %true if the request was satisfied. A failed batch charge may update
+ * @fail before an exact retry succeeds.
  */
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail)
+			     unsigned long nr_pages, struct page_counter **fail,
+			     bool may_batch, unsigned long *nr_charged)
 {
+	unsigned long charge = nr_pages;
 	struct page_counter *c;
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	if (READ_ONCE(counter->stock) && may_batch)
+		charge = max(nr_pages, PAGE_COUNTER_STOCK_BATCH);
+
+retry:
+	if (page_counter_consume_stock(counter, nr_pages)) {
+		if (nr_charged)
+			*nr_charged = 0;
+		return true;
+	}
+
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -187,9 +243,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
-		new = atomic_long_add_return(nr_pages, &c->usage);
+		new = atomic_long_add_return(charge, &c->usage);
 		if (new > c->max) {
-			atomic_long_sub(nr_pages, &c->usage);
+			atomic_long_sub(charge, &c->usage);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
@@ -210,11 +266,20 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+	if (charge > nr_pages)
+		page_counter_refill_stock(counter, charge - nr_pages);
+	if (nr_charged)
+		*nr_charged = charge;
 	return true;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+		page_counter_cancel(c, charge);
+
+	if (charge > nr_pages) {
+		charge = nr_pages;
+		goto retry;
+	}
 
 	return false;
 }
-- 
2.53.0-Meta


