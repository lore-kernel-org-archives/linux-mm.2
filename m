Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925F7606A88F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O0iwsBs4
Received: by kanga.kvack.org (Postfix)
	id 6D6266B05B3; Fri, 13 Nov 2026 17:05:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACFA6B05B5; Fri, 13 Nov 2026 17:05:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572486B05B3; Fri, 13 Nov 2026 17:05:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23DC36B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:05:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 881C21401B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:50 +0000 (UTC)
X-FDA: 85431478860.26.A868B4E
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86E93100005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=O0iwsBs4;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794607548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3U8jhke3RBD55kF2ywexkvmentOUqyFGvRCrHrWYAo=;
	b=BN+4K4vkJiRsklCPGQidwF5qXAMdtNYo7hYcP5cepkZkYmRBf3YMjEH/27IfHjc1nIChLt
	FcGLKXlsnTdZa7S7lgE4FTxw6kfsy+s7gbjCXd9dvTWUKbuQnWNzMwvU+H7l1Kak3+xYQb
	x/9aEtRgb9Arp0M6dqAFT4OqrAKHvuM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794607548;
	b=Fn7fypBJxSBsqgTEE37kp3l3O7jTiCiN40FIJGd0Dq7haRekCW3HvPQ+UJMEYYoWz0zgVj
	YTTL3fhmDPCzV7SoV84w+Oe8Z+JWMah5kVgSUH6FyQw1eIJABr2S1OhRZ9LPtK7kdA9YIm
	9zmfF5sQjtgcXlLGeRNW0H6uyz3ya+0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=O0iwsBs4;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b3653df740so8394617b3.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607548; x=1795212348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x3U8jhke3RBD55kF2ywexkvmentOUqyFGvRCrHrWYAo=;
        b=O0iwsBs4L/NDg/td6f2foeH8vQ9EpT+hI8C9nBmmaFsrqA5ACygu3NkeNs3PlyM0fR
         HxD6+TJmLrA/pwPSNF3a8SlkrIXvWCz6CRinlVEy0NUotlME4gYPACzrpyLpfguQ3lFH
         stxXaeaeTckkSv/DO68Su55vjnkpySdHf+A/yb5ScnxVVxDW/bPVb9/VXFyWbW3XcHOL
         yAtUA+v6Q5VoP6AO/4Mfnk52+427sZrytoqrBzutmmpybgEMTnPH2+4q0iN7IGvCRwfZ
         SspOJwzzUlIUVWQQngxMxBzESGmMNpSNWMw0bZ+TZ3u44EQ+qSZ4+eEVzIqC8gwe6yQr
         IxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607548; x=1795212348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x3U8jhke3RBD55kF2ywexkvmentOUqyFGvRCrHrWYAo=;
        b=V9lsuLJGeglNRbKO9GMfEQEQrljhPefCBW1yYi4JP4AqZTku1xwKoWeIB8MSn1U79W
         g2tNj23e1PSDnqPM85ltrOoKg6XIYGACTwgEYpqMc7DmJ1vVEgwRnj+kisVjgDkAvocu
         UKvQfLfeZKsf3glZa7FO0rIUcpcE+X1BOY8WqJ03cqj3YET9D6SyZwqKGVp40OF5ca3v
         U1QUQE+uIfpF8F4L2OYSkg3NY7OSMOV19XKkXfPmrP42z0+MHz43EBtxt9n6EIF2XudP
         pwpejZDtI3Al6JfTm3sCLPzqAY9KiSXQXW3fmiGqMU653iKvxE72xwxST2RA7pMmZbdd
         IXTw==
X-Forwarded-Encrypted: i=1; AL+hErG4rPnoUO3i2OPWBti+EDb8WzE+f4c2C+ino2qxJoEuIpc2o+8R0DqWWjyUjR6zpn6LWHAjvtX+bA==@kvack.org
X-Gm-Message-State: APuU4Z8SaJvGjYQYQgFnu5ikY4toM/hqm4QzZD2KG2Yg0AKENtE0/oTD
	3rr+kUHwO+m9mwc8DMh4kwfpnKGzk5z2/ctAoH0VHw/hD2GrpgeCUQbj
X-Gm-Gg: AYBFou2SBwEz7hdoh0yp4eS9AzM6gyKUslt3YLkCqR+DOZ190HQqDFRVne8yvxzESqD
	eBJ9SiF/B2AQT2iBvN9ROTpSHQYYK4UuvTSkeydXu/C88mzJhKCxlFyRqrSTWoFlpXXO8aiY4vs
	H2De5+PscHYJM4YCd1geR4CQUmlBuVbUprBgixqfx11rqmZ7FmgAJCSiLE4VVw+TYb++Gre/6Yw
	xRnp3QpmA4vrZzwyN7SbH3lCCFOIoKBo5Inu1JWNxi5A4lI39qGjFixCp+YRmMB/0nR7s2H0Qhy
	d8/IsFJsabUxabuLA8lZwFGilK5w6ZPF91PKVOhd8ZVih7kBJfUegXDqWZtCnYQ6sS1YCuAYKQg
	kM9SMK4ByLYd1dZGDXjO9LH+ET6s2kOpi2aoX7wK7U4/vUtu2ZcLhkWQPTiCuQT1IEBYHtjZ71t
	1DUPULviTIxZJyLbIsfBXaTUCCI8b4oIiJO2YM2s1wRQ95JVT3rFhgWRK6Tsk4xFxx3UtRKdmOQ
	DwlWrwyhNV2gKHjmI6qnUTwazfk8ChuEYliu4HwXS9wJeXcWNyVeNffbQfnxoyWyUE1bl9KQw+L
	0Bcga2K1zImCKrq5Efk1Uf7nTy7aNgnfw/y76nYutt++PPNUUvTE9nU2yerG
X-Received: by 2002:a05:690c:530a:10b0:8b3:2997:f9d8 with SMTP id 00721157ae682-8b4aa36ecffmr20756877b3.54.1794607547707;
        Fri, 13 Nov 2026 14:05:47 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa8f354asm31651117b3.14.2026.11.13.14.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:46 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
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
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 3/7] mm/page_counter: make page_counter_try_charge() stock-aware
Date: Fri, 13 Nov 2026 14:05:30 -0800
Message-ID: <20261113220539.2275715-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7xfmzjdy9d8menkjjpw8q1z6w8mpo5w5
X-Rspamd-Queue-Id: 86E93100005
X-Rspam-User: 
X-HE-Tag: 1794607548-56223
X-HE-Meta: U2FsdGVkX1/WH6d0KKz88AyC11rUimUpnOUGtR+f2SccSGRCmevYIUIpiCOvpBRz//tECioYyJFq6d2Hcs2Q4D19GrJjO1GAzEH0oIxOHZ8nU7m0yJCX60MdwePACiQalNdTCel5+bRgukOihqMdjImh3J3/2vabwccTPXZH025Mg3mEdkkHpbI20wZckh1K8D7iysuv6Ao8gOS2cuCC1b+uD5S0Mza28/2LLJ8ybVB4LKQreNudjdHCiAA3jArIhEfuE5/UxFo1ZGpUdoW9gfpBhFgWzCEeW0g8Uq5xXaj8rik0i3FOo9gPxwdvBs3GlVTBSSI1LOtEIR8KT2MclWz/v4XFpUfm5h7D9N42Ta2Uz/EsyzGltl00ZPvXCPC44H1mVixfy5D/TsXOwfwrK7zZtcKgg+S4s3TjcsXPm1hwzL/uXm8G+WpHI9mmDeWjp9kGS3ny8rCRgLNcw5HKJTU8T6aMiFn/k1yaJO7AfIq+WWnKPaYKaC6WlwiwvY5TE9HQ7flOfQJfdtCa1Qiv3F8SKlDVAd9L5fNidE/g37jXU75/K+wveej6R/595z+jTYiTWVE00sbJKZjZOvJnJLgm78U3fGhPfTFTPjuGIDElm+iHorNbt8d+pwmJL9uAZtmWIhiEwYyZ0C0vbT+fftQbCPrW1f8l+B8d4fgbdbfGK+/Zac3z/E6YVr3YLJjoPcJa4oGrCUoN0zos/7CLWEVKzTqsnDAzl6L/0vd0TMymJ1NpxOolPCTe337APQuchU7YuKJ6tadvXRpRGvYERZFNLvDI5Xq+/cIWu/hREx+eRdN+/AhgM82Qy5/m79KL1QChlQDAZOw0+ZFlOcbbPZV3PQ4Oz8TdKDc1SoqW7piOFJt9hyMPgJ7wbTOjR6Y+ZSx0d54gHa9bI6Xuw/e0f+Dj4NsbAEro0LKIhBXF0NAARpml3dq04yhNmWb1nwq00Zyw0LaokhBSPdrcwKI
 xk0htTBz
 2guHM619ZU8dcaLvc67SKG+mPCgvw6TvGQJoEzhF34wvg1K2D9nCyYIwY+OTyLipnXeHn1m0aX2Ni0hUnxMPSrd86J2hlrON1YnUh2oSwhh5MLyGreXiIDGfzZ8lzBeoHZLPyVTuFCHlqOmf3gmj1KRtGZDToAA442sIP9DmBbu+NCdi8LZNqiXZ8MF057UlFd3lRDItYzle94U13xO6SNmwOcrZ0HjyQB/3omTwVZy2khB2VjMeVDpb1nxoJUUzATr9+jj5BsCfIYkgAg5VjPLRZ9QYPj2dz09ERXy0+YjJ1dAOVqhPm6/++aUSm/ayP3mynMGhNo4R9FQP6Ddum/bHkBtZ2488MF8diUerVWCKT9smCFVrjWlzR92PMiXZ+Gj16k/7QwliuQ77gMvZEDT4Lh0RTDCeOYZHhoYnHFm3lmmv8/qLyeIiM3CnX5Jzuw5VPAvACB/G9VVubiMXXrsRB02aTi3NL7nqct8wvbK7Ya/6mC9QQrESopY65EcM7Oions3KDdnMEyZisgofSvvicvIewyIPvtFYM9N6xJotDYbg=
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
index 6921b18572666..c67d961cf8943 100644
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
index aaeef20eec06a..0e7500624b9e3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2816,13 +2816,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
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
@@ -6057,7 +6058,8 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
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
2.53.1-Meta


