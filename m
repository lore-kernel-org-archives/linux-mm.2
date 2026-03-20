Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FD71099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E796B0150; Fri, 20 Mar 2026 15:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964426B0153; Fri, 20 Mar 2026 15:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767226B0154; Fri, 20 Mar 2026 15:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 680D66B0150
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:27:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A5DD1A0206
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:47 +0000 (UTC)
X-FDA: 84567426174.25.804F395
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 57CF24000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QmLAp+c+;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2la7S1lv8SZ13es345xjBt9aiwYWClPAry0jC6dTWYc=;
	b=DJ9GXeFpVNE0gioYMfv/qBoYj70NHWpxTz0hcDqlz8bj28jtxBrYWLQVew88awPfGEiymJ
	7XJvK72feMKJyaV3rFiVwJJHhZ52BruTE5x9ZmA50EvIpIP9Rw8xe57EvFBMA3PThuSImN
	+M3nRI8nkWfgrZlJBeKdxtvcUYQklL8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QmLAp+c+;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034865; a=rsa-sha256;
	cv=none;
	b=VZZpnV9BQnCLnS5JX8WmFpuBv6u8ZcBMIGLOdvcvXa3ZKmviCYcFrpcDIESLxp+lL62zM8
	vVbu9evMXyhEcg1yumQVZIZ+nd7uLq4aGuVvSHBGSW8pLafM1Ahkc51j7my4Ra/q90etx7
	EdWggRxS2X8B4e2djj3VfrI1+BH2AKs=
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-41c096fab64so1204774fac.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034864; x=1774639664; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2la7S1lv8SZ13es345xjBt9aiwYWClPAry0jC6dTWYc=;
        b=QmLAp+c+/Hmbv2nzGsJwnUZoK+8MTwxFphdr0vgsJJAORNY6fx8PEOwOl8hMAkoA8C
         IBMk+W8I17yPMJjeBX+m49MLE0PO797wsjtPoevcxpIRiQB3QYnpVTdL0/AaBVsNPDix
         L1yDr+Taukibqb3lCq1aFHxXt/pspQgHMI8QU6jBNLCW6D095bhsGcKS7YhVEpQzMLYB
         579VSyazcpPQpL6pRcDpPVGssuPqyHRI1hQV7iCpSrQkjULAb4wQOhT2vh/GsN3bE52q
         AxtlgNmroraaogAHRnygYXi3QsB6CqAXAdddhn1Z56ueq2npEtQz/o/tSHT3x2iIhF8H
         uc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034864; x=1774639664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2la7S1lv8SZ13es345xjBt9aiwYWClPAry0jC6dTWYc=;
        b=e2uZsW+02zV2ddyxmJm8vg5g0dqZyHUnEu9SXW1aYS4MMU0Ul86LrZz1G+u9KRqfjE
         NuMbqGvPe5utbDtger87zsjZmbp16Ad4g06R65OeRs5BXjpROeug8epReDbLXpyByOuw
         nn6URk5emSZl1acFesJuA0EYmHAgfnfOHPJY8guql67qhC999AIyYBjNaTI9Gz/85iwp
         pAkBsNu6hkrVRk2jXnw++4FW0vt/RimnJMDW0WAk5RdMlwVu+KBuH5XAGjj/V2OwKDGm
         gVtHiqhIq2scLw1JoV1MMBO3juCA0H1XAJojnvpPTxaeCjv7UI/t4ngAhL2FonmbuyDz
         N8Mw==
X-Forwarded-Encrypted: i=1; AJvYcCWVmpfSG9jqMLltHGJjtfYFqL43m+lMVHqV8aNQi1PwJD/BBgmZ8soHOeCx7UQVb+QWntZ3zaAhIg==@kvack.org
X-Gm-Message-State: AOJu0Yx7ofnLE7+W286waxjHzDycomBLjcV9TMhIhDO26V804A6YhyTI
	BFzgQK/QS2Q7Kz1rBnax1xf/sHH4nYx4PDzArwCvXSoef3OgJYmxsfeX
X-Gm-Gg: ATEYQzwHiA4DvWv4LMjgU+Zs8k8aZV+VjxHeWyTO0KJ0x+LST09DRDQoPHWfM2fg1iP
	BidUwkJmszfn8EzDv5sOq8pPIcLSESiEmnGjTS9dbH77yD+/5O5wV2Wiw2yqgIfLo+R0sUWWWBU
	Lk3oNiXOpjBXoxbmkt/8HKqRVtM0/YAcTP9SJ9dZJ0qWu+JftsJO9p8hltn+Ur+ODIhDLQZUpAT
	xdN0ybmAzYmY09+STC+Rn467LwSUfaJRwEkNCYQZlvvkujL7bmNou0PvindboYMuUd6QbGnXPw2
	D33lDgxT/B70KTv2wgY0+zBlMxPAmDERhAqMmrbz5yeNbIzUMqDlu2/1uJPFqXv+pMiWgD51VBo
	N/ZzrHBgFJRCqIexvIXA8MHuq9N+rsmzqv3pqrYBTHOelalepuMoEw9C6NAs/lm1RsqiO98MbE1
	WTQ02I8QurjQhfyKCUq2NRsBehbEY9XvqCLRrcN5au9LwqmQ==
X-Received: by 2002:a05:6871:6d0e:b0:417:3833:fbdb with SMTP id 586e51a60fabf-41c10686204mr2791653fac.17.1774034864179;
        Fri, 20 Mar 2026 12:27:44 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14e45213sm2645089fac.18.2026.03.20.12.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:43 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v5 05/21] mm/swap: add a new function to check if a swap entry is in swap cached.
Date: Fri, 20 Mar 2026 12:27:19 -0700
Message-ID: <20260320192735.748051-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57CF24000F
X-Stat-Signature: t3573zyyucr7e6sqctk46sf1mbxnr1xm
X-Rspam-User: 
X-HE-Tag: 1774034865-378707
X-HE-Meta: U2FsdGVkX1/OAvTws1y2hFUlXZ3SDiC7NG/CfEG0UoCsaMX75zUGFqwuxAf8FYpdtB+GeIziNAKcFzILbLULeVCsEulIID6EiIoDW9XT0uAI1lEVNLNZs+dWUCbeh/5ckSWitTVm6BmQeglX5rPUBdFlYi8MGmJZbUVda5sc7o/2/Om60LBCraUPmVLabI+0RmuzPkZfC9z/S6TAIR85FAFCOy2ZCOLnNc6gjTgH2XliQ8GVYD8TU7SDzRJoFVlLU08LQlhFlMC9zrQlAE7npqujyjzVHt/ZIMRHYbES6qX0RcAiH0C39Z26HfG5Ue04Z1MQYI/ieswYiImkHi6ovmIbu9+gsz/IVJx/tLCJOuESW1ImbzNYxogErrGoo+fldn8g03murZkbm6ucu728SChPd1tNp9lgg9vLkJoEa2atmsAicz0SoR9FMGzZXLyvpher5Y0N7Z8aGWdynvaxVrY4WXisd/Po/Ezw3G3k4+T4oaSFKhKcFuTNNEpe9AZaPxan5fwK+y2p9XjrK7RSgqghRJ8uri6BtkUmtvkIUoU1Zv4Qq/gti/lUMUKb6g6SwLTHDDB1OckyKQndcJI+4CoxC1VTCrqRIkTBlJSO0Dq8KhMB1bpikWw8ddAKF79YZUkWB6UB61ko7Ce9H/BUCcWa69/XrFpKOzzSlOzZSJPxN94Fyv3yJvRZ1IC2/4VYfBkkOd8/j64moQ0yoQU1Q+54+IPO7HVj4JMBFdwFz2dTnb9oAJPOGqVYbdoSf8WawGXylG0ANBnfoj/2iKnupc0kCNHyJ/SElBjobIAl9zWa+mEAiuQdXYifMa9wZ/7OSvkpn9+mvKVzu39JhbLow5JvtrT2Uaa7lUqkpROU6xkJNU07juVhIclqYf1XmSqg98vYb7zRO+Q4Owx1lwdehhLn/01nWDMP625B78cVlvSo5ZqnoYi3pqNZ2AmlERuLY2h9YZNjKZAsDvgUwWD
 o4QzPc1F
 84nn8FSPkpE40XNNIQ5DX/+u+GRCIqwF1i93GaxTopTuiO5nhNiWUr10D1sB6VhJytq0o0U145NdKugJJYWGa7bQP1Za4kO765e7WlNQXv7pV3gUuAntJlsKvbKPDoTgo4Rz2qwa9tTd/SZ89EXs4yLHxNkxcXUuu9baGf9LH+3zeEvNF0QgZaevoO/Q13Rp6dRxgvPaN7XJiZ8o4WNcSq7KhOjCv+x5ZFHOnop3hroOzlu8Mfbz4ePUsidZLRENb85LX2gq+QD8CC2LNwYCpKIDm3/qxv0Ng99mi7ELwmzMuLaCcyeb9rr2xsHFA9dN6jcNUhqcW7HOf0v6hA61huHWnkIN9Uxchpugde/KJaJucZiK3H4tflR05w7FFm3IACivWuvjojfsOhOgbqMExuBv1/qZUYtwztMPJ64ivqk4jk+6O4ZhHgkYdh4yQTGScbhyzjHmXqwVH1zFgvyYDQkrGgTNQtkEhJACSgc+6asaF1Te6f4YJZQHpxB/YiZ8JwSiWeZ7ejomgNVIcYPCKGyhi+u5rsp/9ziAlsMeFLvRi++MirTRLYH7N2O4TqixriLHg0XEeHgWSUcGGSV6XmzJnJYCPXOp4ojsh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userfaultfd checks whether a swap entry is in swapcache. This is
currently done by directly looking at the swapfile's swap map - however,
the swap cached state will soon be managed at the virtual swap layer.
Abstract away this function.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  6 ++++++
 mm/swapfile.c        | 15 +++++++++++++++
 mm/userfaultfd.c     |  3 +--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3da637b218baf..f91a442ac0e82 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -435,6 +435,7 @@ void free_swap_and_cache_nr(swp_entry_t entry, int nr);
 int __swap_count(swp_entry_t entry);
 bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 int swp_swapcount(swp_entry_t entry);
+bool is_swap_cached(swp_entry_t entry);
 
 /* Swap cache API (mm/swap_state.c) */
 static inline unsigned long total_swapcache_pages(void)
@@ -554,6 +555,11 @@ static inline int swp_swapcount(swp_entry_t entry)
 	return 0;
 }
 
+static inline bool is_swap_cached(swp_entry_t entry)
+{
+	return false;
+}
+
 static inline int folio_alloc_swap(struct folio *folio)
 {
 	return -EINVAL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 46da28c533bbe..0471a965f222b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -194,6 +194,21 @@ static bool swap_only_has_cache(struct swap_info_struct *si,
 	return true;
 }
 
+/**
+ * is_swap_cached - check if the swap entry is cached
+ * @entry: swap entry to check
+ *
+ * Check swap_map directly to minimize overhead, READ_ONCE is sufficient.
+ *
+ * Returns true if the swap entry is cached, false otherwise.
+ */
+bool is_swap_cached(swp_entry_t entry)
+{
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
+
+	return READ_ONCE(si->swap_map[swp_offset(entry)]) & SWAP_HAS_CACHE;
+}
+
 static bool swap_is_last_map(struct swap_info_struct *si,
 		unsigned long offset, int nr_pages, bool *has_cache)
 {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 25f89eba0438c..98be764fb3ecd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1190,7 +1190,6 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 		 * Check if the swap entry is cached after acquiring the src_pte
 		 * lock. Otherwise, we might miss a newly loaded swap cache folio.
 		 *
-		 * Check swap_map directly to minimize overhead, READ_ONCE is sufficient.
 		 * We are trying to catch newly added swap cache, the only possible case is
 		 * when a folio is swapped in and out again staying in swap cache, using the
 		 * same entry before the PTE check above. The PTL is acquired and released
@@ -1200,7 +1199,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 		 * cache, or during the tiny synchronization window between swap cache and
 		 * swap_map, but it will be gone very quickly, worst result is retry jitters.
 		 */
-		if (READ_ONCE(si->swap_map[swp_offset(entry)]) & SWAP_HAS_CACHE) {
+		if (is_swap_cached(entry)) {
 			double_pt_unlock(dst_ptl, src_ptl);
 			return -EAGAIN;
 		}
-- 
2.52.0


