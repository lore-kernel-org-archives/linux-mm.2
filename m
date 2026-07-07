Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5567C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557D56B009E; Tue,  7 Jul 2026 02:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4448F6B00C7; Tue,  7 Jul 2026 02:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE156B00C8; Tue,  7 Jul 2026 02:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF7996B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C9321C33F0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:40 +0000 (UTC)
X-FDA: 84961037280.30.9405658
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id C9B7540005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dcvCpjie;
	spf=pass (imf12.hostedemail.com: domain of 33Z9MagsKCKgaWcZIdXIVLIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--souravpanda.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=33Z9MagsKCKgaWcZIdXIVLIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406558;
	b=q81XA94p7+hn72ylcEN9hGtf9Y6xYD55jgKtoATJvMPT2s9vjEl6Q2B8ZyhQvYvdiZekq8
	1+NXyVih1nZvKYyOXqqU8Ng1d6KJHx86DSX3GMSjwXe/gC7aQUpsbNbCoSshveN6LV5fJ4
	S5SNrG7gEH/nQqov++3rYj35Rte5BZ8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dcvCpjie;
	spf=pass (imf12.hostedemail.com: domain of 33Z9MagsKCKgaWcZIdXIVLIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--souravpanda.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=33Z9MagsKCKgaWcZIdXIVLIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2+6BMS1LET88hmhEtqV37vGf+7f7OZkNHnFc4ohCrA=;
	b=UayccopEn86las28pfFNTqVKo3HW8wi6cpN6Diaqj47Zbq2HYnO6r4W3/qTtjhTWPNdMQZ
	wZeccvu9nFXtq6MSnXSxbL4L73r4G+mQ8lo6KLAB5fmmo7PZ63fc3zLY5aCYzm6B5RTxOe
	MfWQ/SFW2qTjmrrrMMNSu9WwxCnrXAk=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8479b45ad08so6464689b3a.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 23:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783406558; x=1784011358; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S2+6BMS1LET88hmhEtqV37vGf+7f7OZkNHnFc4ohCrA=;
        b=dcvCpjieoQvIdwlZ6CNrv7uDEtcB6lFRvIPDO6qPEKsPNnHNuHnDmAO6eNPDfPMqsR
         hOSfG+cvjf614bXvLndLZd+fcXakXilkZCByQ29+8dO6CLsRkta7k0cROKU1GgEb7cze
         9vgOpFTVTgR2OzMTy+VMkNLj0EwCp3B61VJbio/NKwzJbOkIQ2RSHe3ZZFy/1sRN7fT4
         m2togMZoEUSeLR22UL239tpxA7SMIuffKSVMqA90574OTEQOXiuUQOE9TB3E1BCa3fCI
         /buQ5whxauvAHCSxp0jBf22Cfe2/BStuUxqVFFByY9Um2DGkMD0r3lO5R33iv+tkfXGN
         CZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783406558; x=1784011358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S2+6BMS1LET88hmhEtqV37vGf+7f7OZkNHnFc4ohCrA=;
        b=GDn3YrOfg6kDjac2msgIaLPS27o49AYBb22Nl5fkemtjsstvvd1VAeRnUP9moLs8JV
         idvNcKNOJfd3MxOodPDAGxh/rdtiYCFPRAL3dWbA74vpOtbBnD4vyF+aewjLmF/X8qC3
         madDU5h0KVHcJyYZ6zK88NAq8OlYEqz/qHUqJPEJ8vM1w+O1QxxpsnBw3jOjhOE9ILyS
         FPSCZosMwTioKUez67ZLf1PUqEnOiNdBDsVtBPxjygFbwbpBAyHdHC+P+D+Fo4yfAm77
         RdqAh/1RUitTiodiQAhZRkpmzaUZJjCRJl+nghvl9cRY7avMmGKlb4ea5ajE8BdE+t7d
         tK+g==
X-Forwarded-Encrypted: i=1; AHgh+RoTh+jVaZQVIBbHAK8YbtT8w5WHehCfZxKp2O2jMx0oxFA+UEInfCDSHWevvY7q4UkJ441xtqEVfQ==@kvack.org
X-Gm-Message-State: AOJu0YzGEtNmUaIeKrIrnMFsO1BjehXQ60/JY97pocOuB8r+YoXaRMLu
	ycccIYJPVFdb/ic66I1qT+sBnOnYcPBTZr7RULGK+reWU6B97LihqcYo1A+tSPQK0d4yXLzWLPG
	qG4wOHE1W8oX48swZjzcBB5mfwA==
X-Received: from pfhh1.prod.google.com ([2002:a05:6a00:2301:b0:845:e874:e087])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2350:b0:847:9367:e054 with SMTP id d2e1a72fcca58-84826e226d0mr3798373b3a.57.1783406557455;
 Mon, 06 Jul 2026 23:42:37 -0700 (PDT)
Date: Tue,  7 Jul 2026 06:42:30 +0000
In-Reply-To: <20260707064235.1386552-1-souravpanda@google.com>
Mime-Version: 1.0
References: <20260707064235.1386552-1-souravpanda@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260707064235.1386552-2-souravpanda@google.com>
Subject: [PATCH 1/6] mm/hugetlb: add Kconfig and basic cache infrastructure
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mst@redhat.com, 
	mhklinux@outlook.com, souravpanda@google.com, fvdl@google.com, 
	gthelen@google.com, mike.kravetz@oracle.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, riel@surriel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9B7540005
X-Stat-Signature: 3omtabh6wqzie4sd69fp364yx5a5k9kg
X-HE-Tag: 1783406558-297325
X-HE-Meta: U2FsdGVkX18i820vpQwMb30xwSq7+ZtSJui8d7GEJzrvbXxkwX+nE5ImVWcd68zgVeD5f6j80yWJQv+LOpgpQ54I1BZH83DRU5I5NhH8uA4i9pzod8SYra/p1CfMIYOMepHNYCLvC9blMLJcClNEFbqVSs5RD+SxeEgOQ8WCsVQorL2aM0KcZLfHBGUZTDoBelf54o3nBA9yJrrfx8L1irC1hh92+NgmjdcOAweugSdRoBIgI7gIW+jH29mAHIPxH65zjYQqt5XguRNg5KOMiEvZUo11izV/rCBsjVmtZwqF0uNko5ViEohnU0sKoF3r8KJdfomu8oO8hZZLBu3od8Ng8BuUvuGPwA6qOsNVibQblTn6Kh/P5Sn67qga+llA07OcGzF2Rj+lvIW7EXm542O48u8j3KuoVvjt+2fPs14vxQq7oOuZzPGZ31H75rXNvDjdb7TbkNiVunV12zDGi00d/TEs1sYrF1BPkVgi+rY9pyTV+1G/F4j0xX7qX/4uiSPhLXt2SHY6aadLXx+yUI/kOjiOjr7sa6KAQBqdZcw2ZafCPOBub/tW1E9fwVNKyHAt2AL6tF4Ct4s/6GKtFhoQIm80j6aV/6Qv5CRqyvpwupgO/VKRoX3i3wVOQNP1CwgL6MrVafO787H5aSEfvrwtEZc62RXFSwaAG5LWLtZJXxvE1JJPlE4JPTFKO9Woz8vfCjU59ym4AMafMum0k+/7IcaxhG1Y4MrczIX7cf5gYJQO40O3nNZWX4BBV4/hcyNy84I08rd33Rq3fwvSzaBa5pMwnHYjDyyoikO+PcOKMEFkrKLO8FzKAbSsADQac9JAdOFJJYBLyrqKIao4LCWJSK1zh3gi5CblsQ7/vyI5YsHdk9p9pIYIyvlcXn4hNBs1D9XchegMS8LcsPLfDK85ZrX2ni7svRL+NU+//Hehg86NrLlEPlE8EPEC0LwPNXpOyxPPpha3DHR4sxZ
 9DpfpqHh
 qIns5xodCH4nDc0iDAGMkz03UwEodpmz9YtFnXOug99JYn2NggaILA+CckHX5h5bc12PwKJYegP8zcYxUHd28CJl6lFyCiEQ0Z1dE2t+7rwDAqDavzWS14hTqkVbbsiuWORRkFe57lRByk5sClEGAOCmI9u0jrcNlW5iVLv7UEqUrzkpoiD77WK32dl2lV+SZ/SrRYZTZNDq2eh0+x93w9QxcJ8+vyL4k84SrUgNDczoiJW/Efe6DQJuMEJHBuy4I08h4OQfjIeVp6F7NqXC2Nfz5islehmXuoGF8CdPoEshE87D1m4z+QFdL4tWfVAaKqi8XhXqiFtyNcOVo9QpEX7WaZe5r//dRg+dkYZnS3hMgW7AC8I8PLE+QpYZC4amsFJqbvyKhR0ezf18mPuhzlkNsVaIt8ngc81X41hPLsym9N/UCq9IudkC2nUpb8aL7gW53uyJZmOJnqg/7+lGwCT0tAyTceAiA1utQFQYBqy8MNkMFPubpOuNL8At+TQq08KxMjLmvwbWs9w1eywhgoUoLfdXchcSc6lyHZXnkkwM/KoS15p4B1+Juwgxs0E129t2Qa5rRfXzBLWLN8wSgsOQF7VxcCxMwId41T9rHnu7TLNCdBGb+AHa3bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce CONFIG_HUGETLB_CACHE Kconfig option and add the basic
infrastructure for the HugeTLB dynamic cache.

This includes:
- Adding new fields to struct hstate to track cached pages
  (nr_cached_hugepages, max_cached_huge_pages, and node-specific versions)
  and initializing them.
- Introducing a new hugetlb page flag HPG_cached to track cached folios.
- Updating remove_hugetlb_folio() to be cache-aware: if the folio has
  HPG_cached set, decrement cache counters instead of the free page
  counters. This prevents leaks during memory hotplug
  (dissolve_free_hugetlb_folios).
- Preventing inflation of free_huge_pages by cached pages to protect
  memory reservation guarantees.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 fs/Kconfig              |  9 +++++
 include/linux/hugetlb.h | 14 +++++++
 mm/hugetlb.c            | 82 +++++++++++++++++++++++++++++++++++++----
 3 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 43cb06de297f..d33d1973ce8f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -268,6 +268,15 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
 	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y here to
 	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
 	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
+
+config HUGETLB_CACHE
+	bool "HugeTLB dynamic cache"
+	help
+	  Enables a dynamic, NUMA-aware hugepage cache for
+	  gigantic hugepages to allow faster allocation of surplus pages.
+	  Surplus pages are recycled into this cache upon release
+	  instead of being freed back to the buddy allocator immediately.
+	  Subsequent hugetlb allocations will prefer this cache.
 endif # HUGETLBFS
 
 config HUGETLB_PAGE
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e9..4768f52ddd35 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -585,6 +585,9 @@ enum hugetlb_page_flags {
 	HPG_vmemmap_optimized,
 	HPG_raw_hwp_unreliable,
 	HPG_cma,
+#ifdef CONFIG_HUGETLB_CACHE
+	HPG_cached,
+#endif
 	__NR_HPAGEFLAGS,
 };
 
@@ -645,6 +648,9 @@ HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
 HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
 HPAGEFLAG(Cma, cma)
+#ifdef CONFIG_HUGETLB_CACHE
+HPAGEFLAG(Cached, cached)
+#endif
 
 #ifdef CONFIG_HUGETLB_PAGE
 
@@ -670,6 +676,14 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+
+#ifdef CONFIG_HUGETLB_CACHE
+	unsigned long nr_cached_hugepages;
+	unsigned int nr_cached_hugepages_node[MAX_NUMNODES];
+	struct list_head hugepage_cache_lists[MAX_NUMNODES];
+	unsigned long max_cached_huge_pages;
+	unsigned int max_cached_huge_pages_node[MAX_NUMNODES];
+#endif
 	char name[HSTATE_NAME_LEN];
 };
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c921287489de..15be3cf54606 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1381,6 +1381,60 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int
 }
 #endif
 
+#ifdef CONFIG_HUGETLB_CACHE
+static inline bool hugetlb_folio_is_cached(struct folio *folio)
+{
+	return folio_test_hugetlb_cached(folio);
+}
+
+static void hugetlb_cache_add(struct hstate *h, struct folio *folio, bool from_surplus)
+{
+	int nid = folio_nid(folio);
+
+	list_move_tail(&folio->lru, &h->hugepage_cache_lists[nid]);
+	folio_set_hugetlb_freed(folio);
+	folio_set_hugetlb_cached(folio);
+	h->nr_cached_hugepages++;
+	h->nr_cached_hugepages_node[nid]++;
+	if (from_surplus) {
+		h->surplus_huge_pages--;
+		h->surplus_huge_pages_node[nid]--;
+	}
+}
+
+static void hugetlb_cache_remove(struct hstate *h, struct folio *folio, bool to_surplus)
+{
+	int nid = folio_nid(folio);
+
+	list_del_init(&folio->lru);
+	folio_clear_hugetlb_freed(folio);
+	folio_clear_hugetlb_cached(folio);
+	h->nr_cached_hugepages--;
+	h->nr_cached_hugepages_node[nid]--;
+	if (to_surplus) {
+		h->surplus_huge_pages++;
+		h->surplus_huge_pages_node[nid]++;
+	}
+}
+#else
+static inline bool hugetlb_folio_is_cached(struct folio *folio)
+{
+	return false;
+}
+
+static inline void hugetlb_cache_add(struct hstate *h,
+				     struct folio *folio,
+				     bool from_surplus)
+{
+}
+
+static inline void hugetlb_cache_remove(struct hstate *h,
+					struct folio *folio,
+					bool to_surplus)
+{
+}
+#endif
+
 /*
  * Remove hugetlb folio from lists.
  * If vmemmap exists for the folio, clear the hugetlb flag so that the
@@ -1401,12 +1455,16 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 	if (hstate_is_gigantic_no_runtime(h))
 		return;
 
-	list_del(&folio->lru);
-
-	if (folio_test_hugetlb_freed(folio)) {
-		folio_clear_hugetlb_freed(folio);
-		h->free_huge_pages--;
-		h->free_huge_pages_node[nid]--;
+	if (hugetlb_folio_is_cached(folio)) {
+		if (folio_test_hugetlb_freed(folio))
+			hugetlb_cache_remove(h, folio, false);
+	} else {
+		list_del(&folio->lru);
+		if (folio_test_hugetlb_freed(folio)) {
+			folio_clear_hugetlb_freed(folio);
+			h->free_huge_pages--;
+			h->free_huge_pages_node[nid]--;
+		}
 	}
 	if (adjust_surplus) {
 		h->surplus_huge_pages--;
@@ -4169,8 +4227,18 @@ void __init hugetlb_add_hstate(unsigned int order)
 	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order = order;
 	h->mask = ~(huge_page_size(h) - 1);
-	for (i = 0; i < MAX_NUMNODES; ++i)
+	for (i = 0; i < MAX_NUMNODES; ++i) {
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
+#ifdef CONFIG_HUGETLB_CACHE
+		INIT_LIST_HEAD(&h->hugepage_cache_lists[i]);
+		h->nr_cached_hugepages_node[i] = 0;
+		h->max_cached_huge_pages_node[i] = 0;
+#endif
+	}
+#ifdef CONFIG_HUGETLB_CACHE
+	h->nr_cached_hugepages = 0;
+	h->max_cached_huge_pages = 0;
+#endif
 	INIT_LIST_HEAD(&h->hugepage_activelist);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/SZ_1K);
-- 
2.55.0.rc0.799.gd6f94ed593-goog


