Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00AC3606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a44r4mmX
Received: by kanga.kvack.org (Postfix)
	id 2E12D6B07DA; Wed, 21 Oct 2026 18:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2442B6B07DC; Wed, 21 Oct 2026 18:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159D66B07DD; Wed, 21 Oct 2026 18:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC51A6B07DA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:55:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56D3DC0681
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:23 +0000 (UTC)
X-FDA: 85348141326.21.9B9E67D
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8FF88160003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a44r4mmX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4TFursOBUs7to8y4FWwAK3ge25kSxsoywm4OhWQZu4=;
	b=iVspCtklQFlJ9mn6WuwV29a9Ik3uQiKAtZ7jwPMlSYkud2XekauBuFR/mNAL2koTdeF1QT
	f/nVpc5GeMGJVzdhyFynSWg1wkp9kDMOEw4rw21es/Z0bPLtbZZ1T9U25jabL3IgaaoLqd
	thCdxyFHNJVE8Wi1WyYHW5SMVd8AnRs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a44r4mmX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623321;
	b=GmfJVNJpFJ3kScq2Ri3xJiqu5OkgAn+wpGnKhHMrvb8X3VgRmYofRnc6JJRsVjMH6lKihn
	AhaLSJN0MkyFp2rt5tyTX/mPmiwRFshYnChPsLFCTbx1VEuXcVLzBlT2sdbHRDXBD20qNx
	sZfVQaMOlQF3MxXscSZZmy4Mxsai1Xo=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6740e7ae219so1129227d50.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623321; x=1793228121; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s4TFursOBUs7to8y4FWwAK3ge25kSxsoywm4OhWQZu4=;
        b=a44r4mmX/4YbT7PahJUGKuvOh6A5YVHEPg03Mi7rMDeVmrlxQE8jt/jUcjAca8DxhA
         sgdqKD0z76XWnxSWhYn6rPssWGOC1OUgfBlD3GizMiZXQVmRmyOi15cTZe1ku9xERE4N
         Je0RFLn37UyLAk0rBT/9wvz9UODvHBGg4uca44IoJjzBNo11uieQwpiHo9gRUjV3F8Zd
         0YRHI3Jz2UAaVfT1pP5ofcj+JAYklfdChxSFjzhZ+hhcJlt1RR3pO1JHjpJDA5RmFoK1
         n/VFEphMmcu5IFKjtDqogaLVgC0fuUqVvh2XBwm0qBQRCmWT8kG1NUWooVDo/BzAvvrW
         bHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623321; x=1793228121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s4TFursOBUs7to8y4FWwAK3ge25kSxsoywm4OhWQZu4=;
        b=ygSIekveP+Mz6UVWPrg0aswRjaSkEuUmgeSm2BH2YBEV4p02UufNeK39PF7Ee2Ckak
         o4m92fSjqDCVz9oUFvQwJ9rh8gVGLGUMKNDJCKVDoJj27GtsUtGq1jYHQ/CKrBdOVaV+
         LXDlpf+a6TRjus9Un02p895SQ1w17ArQTcB0EV1XCFpQm/CbHtqOWjm38vUsaHL0fB1h
         aBJ/x4dx8jGcSJ7PkpauMBS60cdL2rbsWW04yoY9f5UhdjLobt99cYPuh/JaMtmzkFRh
         cAiHZB6ZS8WRWQXtogPzxTZGcaEe77ZMTzg8WVfIXM6Bdz57zTgYjRagR8zSqKqlRab9
         jMtg==
X-Forwarded-Encrypted: i=1; AKwUvBz+eXIddBdBZvt5uo6CLYDzZz9YiUOnd5JsKmxSRBdJGdEQzuya+OXvDxOVqtESpBZjKtEeBmfjEg==@kvack.org
X-Gm-Message-State: AFq9FYJQu1ZEXZ9Z688YU60zDA4Ir8gyglBoF2DT0JKPP36+cfsjhyo5
	cMxOn35Vbw9Pcd6vgB5LaL/IUOGl4tEYy8Qy3xix076yGaHW25xPNtwd
X-Gm-Gg: AYBFou1kXlBQfzmWNqxLasUDc5eYTnNK5hKClDmP+BfSKKVqGbjOWC8AsttfJAnTQuF
	k+zqn3QtCjvCZI3bT6y0kLKfC1BFupdlbNl3cntcMYLFCxZ/GFcs9pZnFq/ooJwGdh3QWnajqdL
	93F4sJKF4gTZYTdJbcNdEZ9PIGU/sIrkaPhmP7xDTMWy1703Nfenh4fRZ+08BhD7prG1F/LxALv
	vk02AFM1tSYvVs57rxp5RrbNW6duH3yB6R2bBtDaVNtOp+RyMaxGRW8AspmmCuxDZEuZMQMvFks
	t2QxjDbbCFQ8C7/aOgk5kwTjw0wwYoSgb60PWcHlsGb8XYpetXJ49ctrRAMRg4RXGAt+QRLaO9t
	x9tAKUXcsu5d0DM531JOVUFf5xWx39boPv6RFT8zUk4wab8twa3pNNf/nt2t6xcVqSMH31vIEaQ
	y2u0eNOMPbtNDvOse/BfLisGTJ+1KrFZMxrUy8TWOInl7VBG0o+DdF6ienpVWs1tRejzwDAFmin
	hq1bobZ/ZDOcPWXvOkRvu+9VOks5dOP7vaBfvtsF/OCSFWoKVIsOyBIEocX4khVsCYK7/3zVv9u
	G6HMF+FmNm4=
X-Received: by 2002:a05:690c:16:b0:8b1:447c:cf05 with SMTP id 00721157ae682-8b1447cd40cmr7951537b3.67.1792623320629;
        Wed, 21 Oct 2026 15:55:20 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b13012f929sm18363607b3.33.2026.10.21.15.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:20 -0700 (PDT)
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
Subject: [PATCH v7 3/5] mm/page_counter: make page_counter_try_charge() stock-aware
Date: Wed, 21 Oct 2026 15:55:12 -0700
Message-ID: <20261021225516.1620680-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8FF88160003
X-Stat-Signature: wdqgnuxa459wx9kc5tbupmpzac5pu8yr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792623321-86021
X-HE-Meta: U2FsdGVkX19whNcgpHh9j1v2rwxqaM/NR2fuYjW6xHWYxRX1S6epH6Z/wg9jhR/fIY5hBeXjXnYH9Ev1Zz02i1gscVUdCKZBA9yHFb9W2MeGpTyKRT9Og6vTqf5UwtxuOvJFJinhPJlXLjXBZ4fjJuQrDw3hT/AqFQdZK43h0pDxQoeCFL8yimOSW4JLN0UKJFVXvHLWapWHeBpSSwzklfVQrwAPMM3epJ6bU1x7llQN/3DmOFsp8yeLOY4my47PFcJRno5VnZIJxmwiBq5sfp9dtts/zXX7DgrP2WmYgHqO5ZRVAFjIyvNIao3cH16L+R9ePXbxjOUb+zThS46AibJk9+fJlTGOQAA0N09Cr01sEPlxe/9n/oGzDtuGqCP8ZtSoeSErCGGEc0l6H1ksk++0mB1g+4ARBfKQcFEPuXF3lDV0jkV6benITKKQ7CwWt3b5nre3LYGDZ6cD1yM+Kk07wzuzH8rs0BogVN/QORaAVX/5H2FsiB9PYX5DgSBNHp7GELQATCLezLt0edyvCis0gO5tGqeeIXN6Lg+MrZ/da1R/zWcFZabD3QSCeV8zXnziqD4plF3BopIUymPpLf3Fzw+KlxHewDYDNuVY5LoAuTgvqCqFruC/2FwXgwcPxs83BVpmz/9+4RtRiCLyt9d4YJOscnKHNbEj5i+RSVngEthcPV3yJWy9xwSAAMm4UD0c3ekoXE7VwEUm1dXtQPYh/A/Wkbd4CDON86pvpfeHvaL8Kamf3tHo4v1rdOFv23/d1Ohffg8bXMDcdK6PGrDf0i6nYPXwUC7fKQabScwe80uWpejaDJN2a4N0AKbHYWX4Vg9bZrPP7sizE+VVTnI/WpUXjvBsx4NE3idDPbo+Hzmg+dvq7VbB6hsGg+XcfRcdAvdTC9gWaeIWWpmVunoHZmXs498M3I0COwN+CuHCwJ2MXDjXhGjDVTXLa+y/qQtUbhgVHRxKbk74toW
 pr1FH0P6
 hR86DTOQZF7sJz5YoOUDTz2DCdixjmO5MAjAidXNGGEGY8WbrFP8pR4fnkSn4KCksP7kgGp/5eZSAovSHX+1vivNTov3wXuYtUC4l9ali68Cq9UX+d/zBZWDXoyad/FsVrtmD9FZ7ZsZTyBqe/9wKBzIQNm/CzNW1iLofCvHrVzgJoBALW9nA2nFn7yzBjUyxfgqIQAkBvTIePZJk+WpanKay41WgLuBbqfL8DABD1Ew9m8MbVof6bS3eax9onYg1+d/jhrtFH3KN/uFoZX6qQ5AEKLQiCGn+uvNPbKZCuRQDPDdeNWsOrIec2FYDzhOVprVvfdVRI8+EMltGxzoAo6b/frthqrP21QPYULT9pNS5fLwTUSztIGp1PBTK14ipyWd5/iLWYTLWYqsGkAvB6XiGhd3FbnmocktW/hPetXfeJn1P5RH3fuA9BRWjwXUbiEFg91IOF33SriWtsIXJkXh1G+vnokoCpytYnL/ijamJqVguXOJ9ZTE5F9kbqDFezEqvKJ/z/nwZUdev1mskJMUGlL04sSgjQBxv1qZOOl6TVxw=
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
throttling heuristics and never fails a charge. This behavior may be
fixed to properly account the net charge in a future follow-up.

As of this patch, no page_counter has stock yet, so there are no
functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  4 +-
 kernel/cgroup/dmem.c         |  2 +-
 mm/hugetlb_cgroup.c          |  2 +-
 mm/memcontrol-v1.c           |  3 +-
 mm/memcontrol.c              |  8 ++--
 mm/page_counter.c            | 82 +++++++++++++++++++++++++++++++-----
 6 files changed, 83 insertions(+), 18 deletions(-)

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
index 4683f3d680226..569307aa4bd62 100644
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
index cdd6aba91e444..f232ccac69c36 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2722,13 +2722,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
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
@@ -6028,7 +6029,8 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		private_id = mem_cgroup_private_id_get(memcg, nr_pages);
 
 		if (!mem_cgroup_private_id_is_root(private_id) &&
-		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter,
+					     false, NULL)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 			mem_cgroup_private_id_put(private_id, nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 71c7a89026cb9..4c30abf51e966 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -136,23 +136,76 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 	}
 }
 
+/*
+ * Consume the cached charge if enough nr_pages are present, otherwise return
+ * failure. Also return failure for charge requests larger than
+ * PAGE_COUNTER_STOCK_BATCH or if the local lock is already taken.
+ */
+static bool page_counter_consume_stock(struct page_counter *counter,
+				       unsigned long nr_pages)
+{
+	struct page_counter_stock_pcp __percpu *stock = counter->stock;
+	struct page_counter_stock_pcp *pcp_stock;
+	u8 stock_pages;
+	bool ret = false;
+	int i;
+
+	if (nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+	    !local_trylock(&stock->lock))
+		return false;
+
+	pcp_stock = this_cpu_ptr(stock);
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		if (counter != READ_ONCE(pcp_stock->cached[i]))
+			continue;
+
+		stock_pages = READ_ONCE(pcp_stock->nr_pages[i]);
+		if (stock_pages >= nr_pages) {
+			stock_pages -= nr_pages;
+			WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+			if (!stock_pages) {
+				WRITE_ONCE(pcp_stock->cached[i], NULL);
+				css_put(counter->stock_css);
+			}
+			ret = true;
+		}
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
 
+	if (counter->stock && may_batch)
+		charge = max(nr_pages, PAGE_COUNTER_STOCK_BATCH);
+
+retry:
+	if (counter->stock && page_counter_consume_stock(counter, nr_pages)) {
+		if (nr_charged)
+			*nr_charged = 0;
+		return true;
+	}
+
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -169,9 +222,9 @@ bool page_counter_try_charge(struct page_counter *counter,
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
@@ -192,11 +245,20 @@ bool page_counter_try_charge(struct page_counter *counter,
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


