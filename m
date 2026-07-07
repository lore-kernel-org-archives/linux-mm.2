Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7910C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4766B00C7; Tue,  7 Jul 2026 02:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9753B6B00C9; Tue,  7 Jul 2026 02:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF716B00CA; Tue,  7 Jul 2026 02:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0CFD6B00C7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60C501C7D6C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:41 +0000 (UTC)
X-FDA: 84961037322.05.AC803CD
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC785180006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wFM/pPRS";
	spf=pass (imf16.hostedemail.com: domain of 33p9MagsKCKkbXdaJeYJWMJPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--souravpanda.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=33p9MagsKCKkbXdaJeYJWMJPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3/6FtQizBI37BpPuKE5LV5SzdpXotLVZrr6UgpgZPY=;
	b=1OnTwmjwDUZIlfF5Fp5U1+9EGZWAieN2TlT1hT4tTCU386JOhZf5g20LcDQ6WwSZNPz5sX
	LU7h1nvYh4ftN2loKM+u0xCf1BBymZ1tRkjumutZVYnyKjIXvwiHGD3Bsx8ZcG/yv0CNeA
	LqU7eroILPfSUL32ofMkTrB2ERzu9X0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wFM/pPRS";
	spf=pass (imf16.hostedemail.com: domain of 33p9MagsKCKkbXdaJeYJWMJPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--souravpanda.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=33p9MagsKCKkbXdaJeYJWMJPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406559;
	b=zbUsdls6nM8/Zr9bgLpQjYAdsrF3axzYzqgweWb+qWcpf/Q7B3IIz/NJGWC3Xva7OqM4/C
	bcGJpjYC3G+crDnB3aB9wPsRzpQIoo8ZzTBQYywxUGqeuSDOLKXgWteW0b9u8HrM0mr5iJ
	l5A4AsJpronRsw0j8AoExCnSqbIjLy8=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-381d039b797so2819956a91.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 23:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783406559; x=1784011359; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U3/6FtQizBI37BpPuKE5LV5SzdpXotLVZrr6UgpgZPY=;
        b=wFM/pPRS5VOt2uyqSe5CsX2Fw3miHHTj0XcJdOW+qb3YDqZD/e0Qv0orBmG1fQv6Si
         2ILTc1xiJ5NDPLYEtBopzLcaxCev/23dzz4W14YxB1eEM75UoCQ1MkiArn7+BxGjVqdW
         dHAA5ZxBvPF7mx91Z/dbZmJLusnB6kFskO5x8vzXns9Sc3d2WFsYsHJzbI3w4QcMiVLs
         s6E913e5mo+nFZGqlmaAs/iraaVpWQ8m0CO7TnWNXFap/F7/l/xzbBBDsIiZZGew7v12
         0BIEKRMf2aEng5+AwC0J7r/Gf6CCDScPoR46OviCUT+LUT2XvvJkStRY94Sipm+Y7AtW
         tGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783406559; x=1784011359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3/6FtQizBI37BpPuKE5LV5SzdpXotLVZrr6UgpgZPY=;
        b=egvs0bteaO1SO9CXKMd7uAav5MNNs41KHLqweJbbk3jQX1gpUXygbD36tq7UZkAa3N
         CE7UrSwcxazulIY1Gtvm3L6a4XW5xfdBpt4QbJ5BPAQ165FYXQiZa5HLC2D5UWRRbtIE
         ixrKbC0SJHe0e7EA/pwzvQNGWVk/Y1H0OpcrwDd/eCZPP9OdRg9lGiEaWKnoCxpAohc8
         5ETcBBmtlKz1KzqrbLeZeZ6iMGcPg0JKEldPQsog/VgY+7arKjmKu49NUt28oeOXHYnk
         hNFFTefh2zwD+gmLRjSkHCMw89W0N/b3TGCsKoKE8yE6pOTA2A2ar4nntMQTG6uPF0rS
         D/Lg==
X-Forwarded-Encrypted: i=1; AHgh+RoYYeoF+UIk/acPo71tV84qmMCJ6Zm2FSZdjjYKMePwtMh2dvLc4Pxdurjq9Oppt/5vXGzAMSQH2w==@kvack.org
X-Gm-Message-State: AOJu0YwsY2H8cybEmJMQzo6XyIEpFZVUbloZ3f4pkuHkQJpovw93t1qO
	nn+KCCgD/d7meORP2hfqDPI06bxwrN2ClBk8NwxO/V0PFJCDHTfWvdiRwMASn4FlpAhBSgp+tw/
	VZkI03U1lS6m88hs1wV7XlhTAaA==
X-Received: from plba2.prod.google.com ([2002:a17:903:1002:b0:2ca:f1f8:e9f8])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4fc5:b0:37f:9ce0:af36 with SMTP id 98e67ed59e1d1-38757c78e6dmr4191418a91.33.1783406558283;
 Mon, 06 Jul 2026 23:42:38 -0700 (PDT)
Date: Tue,  7 Jul 2026 06:42:31 +0000
In-Reply-To: <20260707064235.1386552-1-souravpanda@google.com>
Mime-Version: 1.0
References: <20260707064235.1386552-1-souravpanda@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260707064235.1386552-3-souravpanda@google.com>
Subject: [PATCH 2/6] mm/hugetlb: implement cache recycling and allocation
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC785180006
X-Stat-Signature: scm4g44mkotts8rnygfr4htbozd3m31m
X-HE-Tag: 1783406559-32103
X-HE-Meta: U2FsdGVkX1+FCZ9Id8aOboQaDHGvLQC9SPCbwIndzDvvIQtDp29aw+J9pElHvmE9Bg6sWHL/s+/CtwKdjVCV/QIwMhhzoi/qc654IwIHwXysiLckoaoSm/81p63XR/NHVZVv7dBa3JbOZPdQ3WxkEhJjPgKOEJ8C/vVcg9zqhkTLvac4l3WI156dLPVIaiJxveEvoVUURhuRauOeIB1jnzSxbiy0WCw5+2ZL2bKyZv4sMzsSLoUhhCgIs7AZSOcoNFVsUMNEski+8r/qkf2KzMeAtnm0fEqJthyc/ZUJTpb/6qODiyk6ES9H+dGhk7v065X/QfqP0KiAtaSNTnDFraLSyM65r8QFL5lAfScLytXfePFv/MR85QJhAGtgr54+8OLhQgrgpF17XefMuOwkg/pguxicpkUfl7UV41eQkpaviqnfoiYaLaC7OWzldQdC+NBRjW1NMTQPqrIn9xwBvyr9z50ENlGSUBYd6GYqYJoP8F0U0rJ6iONvXeWDAMbMq/zm5kTSiviaTB8r6lcDbITuYPnW5lZ11HPZvQYrpT4IGGtDlV6Z0avrlQGQadJXx46be5YaIvkfTUDSN0jIcrTPrwBhf1UHrWZzX6WUfC7DFnB+RKzErYAqlPGqlxmi63LAJCnU1P+AZaC3Kd4UCZMsTbHjwDC1Ccb8lWiW/1cHsg41FkPeCqKlo53daMnioCT0sr4LW9mOT2klHzCDgCbXwnx6YOVAbI+AKPpThF9s6ipeKA2yRb82bevqrS9wOyFTkQ8Owa1g/Cbp9ZoKE1lV4rn5fe2IqhERWi1HL8L6SyPsblkR5PfhEj5MqkTagGsDSnSGDryUQL/Eg3VHvWJl7ebS/Lwb6fdsn9gOwGnUVqqM7TtxCBpS2DqiVNHJCZdaMM7lcOvNU84zy3d20FOm7qZjUgpPJ6yNyOXomAqtUrx+cbnASLWIPd4sGdw5+hVoNH5rolIUbR8YUAf
 hFBx1Knx
 89eaGIj/6ARU6npy1d+Mg92f8MKuxYnbP/f+i47qXASmIi2g0Nfwo/077jcw6suJO6qu4xU9c8nTScm/1biLVXgN2VGMwn53OkTykTvRXFlVqdb0Y3Xga5A3KM8K0jF1/RXewjNm8XxeQ9/4odS7QoR8+gGkxG6D6Qw1UH0WvBU/kxnnSh/+zbkx5+MAgxKmQxSVkwKfUZNF0T9kc9/dFMeVHoE4OpfIHUJIwqT8YYwivpisIZxLT0XFfE4pwgJT3xsa4nCKIoLZNEyob6ViSnh9CjrkAqlxBDXdeaCaL5sveoNZwfbt3kAwJXYwaRuh5w7IMn3ngq8Zlsvnq1Df98yTJ4yAqrUCnSFHHXuX/Okj6xemyqQUH8eyerPNW9JGwo/b+PhMr3wrkrfEEsX7VYFfoTG4WhGY9s7fHFhbBa8dTQEAsxeKw3ZWWbzc0KKDA0aZsJu3N2DFtfw3VlNfA9Benkdcc5kP4adHEF7jzfVfdgqUGS4bba/ljtNprvCs3a7fJ0Sc6thPwdy0AI0I4efyLQaTG3ryhEw9R2xo6dFYqd55dpmIcGhyx2jlqs+F39QrIL8MOEf/CZUM2+8jVVO33oIG4Hnsbrgc9HEB+NE/nFipVFs97o5Ge9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the core recycling and allocation logic for the HugeTLB dynamic
cache.

Recycle surplus hugepages in free_huge_folio() up to max_cached_huge_pages.
Allocate from the cache in alloc_surplus_hugetlb_folio() if pages are
available.

To ensure safety and architecture correctness:
- Skip recycling of hardware-poisoned pages in free_huge_folio() and
  skip poisoned pages in the cache during allocation.
- Call arch_clear_hugetlb_flags() before caching a page to clear stale
  architecture-specific metadata (e.g. ARM64 MTE tags, dcache dirty).
- Use MRU (Most Recently Used) policy for allocation (taking from the
  tail of the cache list) to prefer hot pages.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 include/linux/hugetlb.h |  4 +++
 mm/hugetlb.c            | 76 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 4768f52ddd35..e882c99780b6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -650,6 +650,10 @@ HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
 HPAGEFLAG(Cma, cma)
 #ifdef CONFIG_HUGETLB_CACHE
 HPAGEFLAG(Cached, cached)
+#else
+static inline bool folio_test_hugetlb_cached(const struct folio *folio) { return false; }
+static inline void folio_clear_hugetlb_cached(struct folio *folio) { }
+static inline void folio_set_hugetlb_cached(struct folio *folio) { }
 #endif
 
 #ifdef CONFIG_HUGETLB_PAGE
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 15be3cf54606..d00aa67b8e13 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -125,6 +125,11 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
+#ifdef CONFIG_HUGETLB_CACHE
+static void hugetlb_cache_add(struct hstate *h, struct folio *folio, bool from_surplus);
+static void hugetlb_cache_remove(struct hstate *h, struct folio *folio, bool to_surplus);
+#endif
+
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
@@ -1796,6 +1801,15 @@ void free_huge_folio(struct folio *folio)
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else if (h->surplus_huge_pages_node[nid]) {
+#ifdef CONFIG_HUGETLB_CACHE
+		if (h->nr_cached_hugepages < h->max_cached_huge_pages &&
+		    !folio_test_hwpoison(folio)) {
+			arch_clear_hugetlb_flags(folio);
+			hugetlb_cache_add(h, folio, true);
+			spin_unlock_irqrestore(&hugetlb_lock, flags);
+			return;
+		}
+#endif
 		/* remove the page from active list */
 		remove_hugetlb_folio(h, folio, true);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2035,8 +2049,14 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 		struct hstate *h = folio_hstate(folio);
 		bool adjust_surplus = false;
 
-		if (!available_huge_pages(h))
+		if (!available_huge_pages(h) && !folio_test_hugetlb_cached(folio))
+			goto out;
+
+		/* If the folio is currently isolated for page reporting, skip it */
+		if (folio_test_hugetlb_cached(folio) && list_empty(&folio->lru)) {
+			rc = -EBUSY;
 			goto out;
+		}
 
 		/*
 		 * We should make sure that the page is already on the free list
@@ -2128,6 +2148,50 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn, unsigned long end_pfn)
 	return rc;
 }
 
+#ifdef CONFIG_HUGETLB_CACHE
+static struct folio *get_cached_folio(struct hstate *h, int nid, nodemask_t *nmask)
+{
+	int node;
+	struct folio *folio;
+
+	if (h->nr_cached_hugepages == 0)
+		return NULL;
+
+	if (nid != NUMA_NO_NODE && (!nmask || node_isset(nid, *nmask))) {
+		list_for_each_entry_reverse(folio, &h->hugepage_cache_lists[nid], lru) {
+			if (!folio_test_hwpoison(folio))
+				goto found;
+		}
+	}
+
+	if (nmask) {
+		for_each_node_mask(node, *nmask) {
+			list_for_each_entry_reverse(folio, &h->hugepage_cache_lists[node], lru) {
+				if (!folio_test_hwpoison(folio))
+					goto found;
+			}
+		}
+	} else {
+		for_each_node_state(node, N_MEMORY) {
+			list_for_each_entry_reverse(folio, &h->hugepage_cache_lists[node], lru) {
+				if (!folio_test_hwpoison(folio))
+					goto found;
+			}
+		}
+	}
+	return NULL;
+
+found:
+	hugetlb_cache_remove(h, folio, true);
+	return folio;
+}
+#else
+static inline struct folio *get_cached_folio(struct hstate *h, int nid, nodemask_t *nmask)
+{
+	return NULL;
+}
+#endif
+
 /*
  * Allocates a fresh surplus page from the page allocator.
  */
@@ -2136,10 +2200,16 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 {
 	struct folio *folio = NULL;
 
+	spin_lock_irq(&hugetlb_lock);
+	folio = get_cached_folio(h, nid, nmask);
+	if (folio) {
+		spin_unlock_irq(&hugetlb_lock);
+		return folio;
+	}
+
 	if (hstate_is_gigantic_no_runtime(h))
-		return NULL;
+		goto out_unlock;
 
-	spin_lock_irq(&hugetlb_lock);
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages)
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
-- 
2.55.0.rc0.799.gd6f94ed593-goog


