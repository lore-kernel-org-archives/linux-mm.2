Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5EF1C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F536B0092; Wed, 16 Sep 2026 17:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478A66B0093; Wed, 16 Sep 2026 17:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366D86B0095; Wed, 16 Sep 2026 17:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 092836B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:06:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B4A3160162
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:06:02 +0000 (UTC)
X-FDA: 85220857764.16.18E830F
Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	by imf03.hostedemail.com (Postfix) with ESMTP id B87A720002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:06:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hnlqGfwe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.76 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789592760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqYH4Dmno3zIyHsVcbhXkDT5EaBSu0ei+LzQmvQECZs=;
	b=bP3nA4oiTZQIhFT27KvX6D1tGb3HWY6idW+AzoHhBW+83b0T0mEOaqVh8tFuebRs+LPjJ1
	iFGnRGWgV8qrPDW8WpgbxtAK1HbfBGak17DTwDmYFdEl7+y2oXUPzV4PDXPverh3wIk95m
	lwUoyi5GgIt/ZjAgH4Ah1HVAJ64D+aQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789592760;
	b=EBxWdEo/4vtuy25eg8yAkWrRQ5E/2g65ZydSRpD6xHZScfe30OvwOcLg3Uk4W/mX0QBUEY
	0f741IKwHYqp/L1JfergEWbfuojJgqZ3CN6IEuRKGQgFyn5ApvPxnKyTFXGxZbBaq8YyhI
	qEDng4dDgodBxVrBH8pCrmMzJcRPCXE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hnlqGfwe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.76 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-466ccdd7695so24198fac.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592759; x=1790197559; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iqYH4Dmno3zIyHsVcbhXkDT5EaBSu0ei+LzQmvQECZs=;
        b=hnlqGfwePL26wvd82iQORmZ3UfQRb8OfZ1gZtkP2S6OpKWm1HRrMiAesGGCRtWn+zt
         HrlV1qU8PmpIFOVEhUJJgSP8CccNMIOhn0sxDfHI6FZIJauXZBdbIKvr4GO9ROaAH++2
         Bz8cAfy5azzZCUVXTI/BselrAZrs+IfQTFONR9nMrfRv3zD+BBPa93XbnvJJKlEKD1x6
         uLFeBqBXvek21e4J38EfWRuHtxnGrCa+4QGZvbkibIhqewYqfacJ2BlHp6d3FcHMJKRa
         EU6tbXgTBCfvQe3oanguPkEWPnaln93ogzMnZLCY+imisje32VE3O7tGLzGwun4Sgi1p
         +jYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592759; x=1790197559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iqYH4Dmno3zIyHsVcbhXkDT5EaBSu0ei+LzQmvQECZs=;
        b=rqMbF8lFedtnmI2TNiO0rRYcwJs9BUEYh3wJlnHUgPTJ+oZLnwogMHHvlp1j2W8jhF
         ajUwX+YIhVM5MeLWcDwOvHt0TD7L0wEormi27iAgcaDqeMC9SWYacV9XvD62W5ZmOkTY
         PYgPrOp+f+hZYQZyxqOj1UTkNYd6dlp+UFCRb1ITfXstVZYTihPpXTeIeDaEEaUk/GBG
         vguRMUDKvxjnITJc6Wb9H5ZK3JS59IK9cbRf22K/j/+9/akm+DT6VKBC5yBc0kuoyj5Z
         HKoOVI1PeRNG4vFs8f/JmBfI5Ck1ZyoIabGtyADxzGH1OyC32WXXCQ9ZnoSzF6diVNxk
         oHMg==
X-Forwarded-Encrypted: i=1; AKwUvBxxwkl6UKUzKurclj6XNSiJx4tDn2SccDMoKpfayoRgJ8MlVeWlHSdgOVE5+VeuT5ZpkT3gLbZXYQ==@kvack.org
X-Gm-Message-State: AFuF++l2Y8Djh9djjefl5BTbfKUpCADJBZegBy3gsh2dYgo0REtzMp7d
	BKpM+xs5RQ73K8kpYTm71gKbi2Lii6yn7Mlh2CHJkYKEsz5+hZ7snsUT
X-Gm-Gg: AYBFou2QnZfl4KXxPsYZFUfNYPTved82h5WvlL1wm/1crUrlFYJvj4wFW8luxZlzDqL
	Bp2HaGE3tkfNfU69e9/0g3IJn/c/ZY9eHVVo21ArMKjNLAfmexLM79pWT620jC3xLlxkyCmKLoF
	MiHELg6xzC8IXT57wvi9xqgbZZQL8dbfPPBTk5wNJyXE20XDtfRD3wxuYXeJ0iZ9STwPJkLhIJF
	LVKIWXh7tiqrjunWUdb6uA0XtZDcUVbXwRCUEWR0cHHOBsT+y+zEUjMVdXHCZ+rY2fnjtbcvtVw
	KIRLgjlwOTHA/sNAMCv4H8C6dcnc3y28fVkBiykPb3hYiqQC6EpqE7FokMd3GZFTDcYIqpWMhIC
	v8LJWXKJcH57G2GQHq7m4qnX0oM6G1hoT0jhDftSbe+ec1ipZ6BHBctPa3TLXYxoeNhC9UIDl/5
	JZq8AaBcAG31BSpjN1BAITOvD5ij2sFBvFu6OCcAZr7Q6drivC8JzI4rGKi8NJdcVHdpKPzYzRb
	tpPNLc9yIjRslroo87doc8nBFxwXgYyup5n3t4=
X-Received: by 2002:a05:6820:4c17:b0:6b7:46e9:9706 with SMTP id 006d021491bc7-6c7d45e67c4mr3656381eaf.54.1789592759507;
        Wed, 16 Sep 2026 14:05:59 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c43e5385csm1117267a34.1.2026.09.16.14.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:05:59 -0700 (PDT)
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
Subject: [PATCH v6 3/5] mm/page_counter: make page_counter_try_charge() stock-aware
Date: Wed, 16 Sep 2026 14:05:49 -0700
Message-ID: <20260916210552.891730-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B87A720002
X-Stat-Signature: gnfh81bbudumwfbktipxza4pz7ocok4h
X-HE-Tag: 1789592760-831093
X-HE-Meta: U2FsdGVkX191MwYQhG6q+5UU43O1Vd7ZcnQRCN4NTAt/HAFdiYnv8xVudujbrGkjiR4R3cpxuWhWwGJX6Y2Fxbs5cQ6m5I7ikD0btkY/ykA6kU6odLOgkCUhqesNTuXlDcth+fKA/3VsloYh4MBGQrqutUxRhvsZi89T8kaMLdIUYBRYNvetaAR7mPyZkrVNMAt7FZp8qP26wt8qzcbOeatcJrMfigkVF6yrJQk/LwowY14RNzV4od5QhUQr3h/S7/9L3qrJsELiNE8eYgM28mya8+fl0Kx2Ir1dFh/VGAaySt3aymchVbKM+YBWP1ARXpLIP57QqLfUDKa5f2g+ZmDFKYHZku5IhS60XDk8OsfL7jRoHJfvhBAV+SEyqZy5JCh231PE4b/2rl1S9FgYkBFA+2+uCMgJveo/54x6PjWLxdaDwqbSGD7bSybWSodjPflTMnSzQ5MazVDGu0agtdqmOlwCmtpIHzFHBEDHrXtla5LH/rooaBCiCavFy97qdjlSd2/SQ9tdiwqRigHUqyneHBpgNQoerxqFeWFKMjK5bRklI/teD7I9d5E0cenWOiHEcxhj0zrS9O4Q2CFBjB3GAyjyjP01NMSOOFwxgc0G5zcjf6FDpkOuVH/JTqUiU8QAvO/HiB4vXTX1x/QMyaRFjN30jlCMZ4MMP1gVwe7LiTyJol62rhixSic73cZbapsdIJO5ymhaeFJjSALP/6EyDLBH9H1qHqeXGDX8sFpw8RtZXG2IcH2LzPhLSfmEk2+WmC1GyYe5al1VAtR+UzT1JbJ2RMCYfGJq6zmeVM2ZG8uyCjPTzaY7dSR7PX1cHnrvLWntCAbqC3YCeOJyFU7FiYRaRLmcAA9tTvU1KIMPwvXq6/OlIC/OwvWLoCz24dda3YbSTi2yt+oCQeioZSyycRzSVE3Ac4zAm5wFUeIlxPYQII1dswYLMQwhFREZG8a2QxrQw1tDiKlU64l
 wP1W7HkP
 e6SO5R3wbJ4qfSxHRhdqzhyI85QEf14+QtTfYmUQ6l2GcXhYYEWhG8ZslODYKeBH1VdHbGjPfvqfS9zsFwDU2la4iPxSfzyTXoS96VChJMgSPFw8fLLONUb5UHfAr2yfAPj7Geff17dMZJ74nNvuHVl6ibV81ipDDPnfN3d9EHYW+PjwdNePkVpz3WQKpodDbQfvsvtOIrfBvAkibXthrhVh4TRYp2CaOYADzwknHpVBZDxIKoPPpc5W5thGYAZRoxNeqmu7oNUOCT99buNKg9KsLwfpxDMAPcJHRLL0A0eDGMslCdadokDZYfehoQeaC9L81V8awv0Dangvi8YWYlKdg81adZdlh9NJprRF087t4OtHq/O4O2IFkGj1eA9arwNCxcu9I28j9SEGY7YKkbF5Nykxi7wVLg3z/y1BZ5W9onx4N69b/yZ03vikMdo0OivG0g3mXJMQlyCiD/QvxAn3wkpNfATN872Qj491bX8AOlQ6M3FnLUsrFpDuMwMxYihEWAm7DofzBHMv47rqnv5QaNDWoIbSaBkmw9KQVRmFnb/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
for current->memcg_nr_pages_over_high.

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
index 9cb5612fe190f..a5a5a789d002c 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -98,8 +98,8 @@ long page_counter_margin(struct page_counter *counter);
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
index ecb6e0b7819a0..5b8d9f0e25535 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -274,7 +274,7 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 
 	if (!page_counter_try_charge(
 		    __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
-		    nr_pages, &counter)) {
+		    nr_pages, &counter, false, NULL)) {
 		ret = -ENOMEM;
 		hugetlb_event(h_cg, idx, HUGETLB_MAX);
 		css_put(&h_cg->css);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b1..aba9e3b851235 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2194,7 +2194,8 @@ bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 {
 	struct page_counter *fail;
 
-	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail,
+				    false, NULL)) {
 		memcg->tcpmem_pressure = 0;
 		return true;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 48c475909e6bb..04ab7355c6d2d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2708,13 +2708,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
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
@@ -5965,7 +5966,8 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter, false,
+				     NULL)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 480a447bd7265..3cd8601961673 100644
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
+				css_put(counter->stock_css);
+				WRITE_ONCE(pcp_stock->cached[i], NULL);
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


