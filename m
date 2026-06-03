Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90F7CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3C06B0088; Wed,  3 Jun 2026 09:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583BF6B008A; Wed,  3 Jun 2026 09:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BCE6B0098; Wed,  3 Jun 2026 09:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324F46B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:06:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F198B1A02A6
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:06:09 +0000 (UTC)
X-FDA: 84838624458.03.DB8A4A6
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id E2AB81C000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:06:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YwuLfvsj;
	spf=pass (imf21.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491968;
	b=Dnk6ZPQNSboGoZvGVUalEDnzqjBYZRd347axp7DDlzXf+dgvkk2qjQW2Jixp0pPBpdzyW/
	DnQLnV4LWXZwVoS4t4KufjtKFG3F/p2HzOhyAVXT3H5Lg3qlhZBKsbgMg+FuIwgJhuqwE+
	Jf5qjtzSKlhEYhxjldgfalec9a01hFQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YwuLfvsj;
	spf=pass (imf21.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AdEtlgwKVGn3OjI19JPJND+SGmb9+Nc9aTPH09hmBU=;
	b=w9wV17Z66f7jAD9mG1Kyqvh/OeWVSmMkKTjVvC/B4GhZmQltY/Gzuz9l5uO8DK7b2x1ly0
	bGlCyELsGabkWLk+kBg+XoSplmXPxbZQFqzjvGV6zGRb0EfIL37CRDfJ6Ykv07Si+rlztL
	Sxtrra4RyPpdWeJNNd7G+T/D3mm9/Cc=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c855599a77aso3319106a12.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 06:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780491967; x=1781096767; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/AdEtlgwKVGn3OjI19JPJND+SGmb9+Nc9aTPH09hmBU=;
        b=YwuLfvsj6iIvv8cnt77JseSWSRCjsMG7hDWzxXhF3uR1buahrp98T5VKACSrIfyThK
         DBofNNLQ6DnLm0+4CIiHybyIfwtzzu33hg//wlTOUkdIQiFIORR1z/cbw6lvOaTGwPdD
         nRG4Otu0CiBYZbt06QsJFYTVUqci1vjYgewmRVyN3yDCac3/22StxtQZGo4THpB10B7y
         NNmYKIOWcEgdI0sCyTlpTStcjvniwwdHy8evXuDwzGX3BVuyZz6VUkwl5OCugEQxaZmD
         jL0hPcw56uzxK32QDw1jIN9D1quTRxCtBn8VlXhg8ytOHpKmuY6GEzrD6jGipHu4GsN7
         JJkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780491967; x=1781096767;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/AdEtlgwKVGn3OjI19JPJND+SGmb9+Nc9aTPH09hmBU=;
        b=ZYKN+TKIX7CCQ4qNrOZ88DqsWg4EkB5F/KYXFF63t7wLuX9259rVJO5b/3ayOteX6z
         jCeipOwM4N1UjekR6iFtBR/9mdoEnOElsErI1Hm1rnm42wfPa8CTMRqN6LLSJ5jnI/iX
         mu+uMlE+hS9yRAfevd3Zl+lzT02C4/j2eATWQvj5IGTPMwWxIsjfem1Rccs+XFuaX2fk
         WkrL9CZNQA3sivay1VMxf8PW9JS8LZ5qkkP624P7cEE3oTL0qx9Ugj8iN+zKEWBQA7XK
         Jn7/m/WYA2rQu80AIpsfh9/DsOdo+xYm9umUTtL39wj08J9meAdY5tfK96zjsukfldWR
         p1BQ==
X-Gm-Message-State: AOJu0YyPL0t1uc7EY0Ek07ayyCJfKKoR60yq7bQzvrt1745xGrtE8dzH
	MrD1eGCvy//CSgm74x50X0ho5UhIT+TFmcSnubW5967ftkKCUf6lxFYc
X-Gm-Gg: Acq92OFgWeGhNy1/eWBtRe/pmevir0B5+ivNBs4K0HfbO8MxqckGmle44X4TyWFEeB6
	9MD0LfdD18ww1YbRETAbG08M7cYuLfJiH0dTcmzs+DguYKfiqXZeE2dL9KvuYz1swPA9glLLQ+o
	EQrgXBprN+tkOfUbSGtb2TtI36tZ1tvxnpPcgCb/ewGM4ukiEArGUMEshqPLIv392/Ht8Xlc1K2
	t+efVW5uI8rQMhkDbaUKsFWxsXdbzxz+CEa8K/Cn+U1YoDXQkdYMboonBz6K5M7se/DkHjYSs1t
	LhHD6ajmAjl+5ln9HtnQjgn1xnccbrtHeU0gFzu7vGS0BSDJV0/OWOfJvslEKYyJYjWj/5mLp8x
	8R9fHCgFsNBUCXSVBSmCGibt2SZKkjVbd4fbZD/vn7w8/yW6O0E21yQ3uw8SLOZkrhEWNDD3gNJ
	xvQaQkaBeATv7CFfA1GiRGc8iCo4zjcYw6KpyKmjFD4jS4OrU3Cyqcwrf2UHtADaI3R6kpC1XkW
	L9DUUbxcLI=
X-Received: by 2002:a05:6a00:340b:b0:82c:d7c4:4c5c with SMTP id d2e1a72fcca58-84284ea24f6mr3094033b3a.20.1780491966627;
        Wed, 03 Jun 2026 06:06:06 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828821d0sm3018661b3a.28.2026.06.03.06.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 06:06:06 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 03 Jun 2026 21:05:34 +0800
Subject: [PATCH v4 3/3] mm: move reclaim-internal declarations out of
 swap.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-3-ce0219e100d9@gmail.com>
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1780491936; l=7974;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=T6kHT+p1VwjYophqk0ehEJosMAed3iZy1b1M7R+o828=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QD4bVWhMe8NLfW7WaNlCFAwsZgMqQhUe7WFiFzMCNG3jj26NJzsItffE/f0Y0lHspxRMIi1Z50i
 ycVwcPcdRAAY=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Queue-Id: E2AB81C000E
X-Stat-Signature: u9zehfwf8pxmxwd6uqo9sewzrw3n7btc
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780491967-557088
X-HE-Meta: U2FsdGVkX1/d1MelGxKrH2pBAC7+UIAliKFmzDJiGm9zF3bd/ntJCAzvQpki+/1pqksDpvyhyGmmHqT59kIGtxVTVFGA232WDSoM8W8KLw7ecUnQoXjIqySxdKlcPZ9RvzP4dMiHF/Ha4u+VAs9A39Dg9fjZMFXXUlc8VHjk+YvEWBm4hey62K0NjVuDGM5hnPH6KRXq9FNUnpTKFbA8SFHKtx6WRUw1xGdvLMZmySoHiQzvJMzWDnjYuygp7eRqtGXgCNmAZSKoSdnSoddn6j4lHcSroFSKFOaJ6lb4te3xCQvQJQDcHDI4ss197CXqQG5+f5RqGlUsoDQm9JwBE6yWT4ZtkZh/wQDOawOx0ZWHw1W0IVwDNXsXG1Y0wAtZPNWh5cZB1cakCvKGS7ujd58ld/kfILWboyNTC5bxftDMqpQtiN2cjZiKVDsbndk+kBSuiaT//fBplrIlOeYlY/nAvxoNMzHGzpjyuPPsHomnha8KUyW9fmfFZPeNA4nLwnsCs5DF3q6d28ladgir8SibH9OFc2qfcxZ79xZJMSk98ZNVn7d584PcOQmC1KtR8V30lSXWepNjD66C6WxK53u4HvAfRJjjuAamZ4xAnhBXWnL/QMTdo9xhz9rT+kU7w98hKmwU6zIruG9lUmu2+GLUdQGtQMPf4A1PgTtQFME5oqqT2aYGBomjcQvkb0yKlHM6IND2CI94comnSf0GZE6q4hs9kpLTj04Uwq8UEaVBe92KXDYCn0qG3g+Kl85dh9nqH+ZXxX8+6Z3+x9cr7dRE74Mb8Z/ma6DehxQtfP1JfQcw1AkMH/BbS1oT6HRULL8dbRDuVBpBddGRB7IUaPEHq8wtCF+fSIzz7547yZ3+xxmkBfIoxkvnKkti/ygnjuADOOjoJUDnymlwD4BnOMwTQ6oNcstJwKETCBeCeCnLXG7sjzvle8gjzYczM3ipkkVdLPhYRIiQBua4VwY
 P9tu+mlr
 JAh226j6fhzzBJC3vA5k6Jfpj3p8HdrvRiNs50N1gdRlCKZOuZAZNrT/JGFzpCn/G0TUns6hQeelX9ZqKlHE+d4taVfMwZkZ0J5kKeRFurcdpwz/+mBEi28IUnCtKH1CdFUecWr7y/4f626/bshqGbTsrMj7LKuzIvJo591+6pYhlQXwroYesqV7KwECNvEYYcVmQa7EzAyGW9p2WgIB6mmlPbenrXqU7gIhSeZTcLn3cFKoeXq/9K9ANRidV70LxRWAQ2OLmGILWHf9z0RlCsVuEm7SBH3ZR76yRhQK65aAa7WbhpqNyK3gWQlcP3jD7KLsksDE2fky+RGjwH49O86nSBs3XMX2gRMEdrPWfbG50D0qIpQlDVi7CNoWZuJ3a+FiPxt/8IiQV1JrPojBR1jgt29pXz1FkS7wSgwMEQpArGpOD5Q7bkpLDL9seuYfrabmwVl0I+0PJ0163ftU2KZ+Lhg9B7URP427oJuQHm0NoRTIE5cHtEGpROg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Keep include/linux/swap.h focused on swap-facing interfaces by moving
MM-internal reclaim and workingset declarations into mm/internal.h.

Leave the small set of LRU helper declarations that are used outside mm/
in swap.h so this cleanup does not need a new public header under
include/linux/.

Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h | 74 +++++-----------------------------------------------
 mm/internal.h        | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/memfd.c           |  1 +
 3 files changed, 76 insertions(+), 67 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5bd6f1d5984a..5c0d92613a35 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -292,39 +292,19 @@ static inline swp_entry_t page_swap_entry(struct page *page)
 	return entry;
 }
 
-/* linux/mm/workingset.c */
-bool workingset_test_recent(void *shadow, bool file, bool *workingset,
-				bool flush);
-void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
-void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
-void workingset_refault(struct folio *folio, void *shadow);
-void workingset_activation(struct folio *folio);
-
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 
 /* Definition of global_zone_page_state not available yet */
 #define nr_free_pages() global_zone_page_state(NR_FREE_PAGES)
 
+/* linux/mm/folio_lru.c */
+void folio_add_lru(struct folio *folio);
+void folio_mark_accessed(struct folio *folio);
+void lru_add_drain_all(void);
 
-/* linux/mm/swap.c */
-void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
-		unsigned int nr_io, unsigned int nr_rotated);
-void lru_note_cost_refault(struct folio *);
-void folio_add_lru(struct folio *);
-void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
-void mark_page_accessed(struct page *);
-void folio_mark_accessed(struct folio *);
-
-static inline bool folio_may_be_lru_cached(struct folio *folio)
-{
-	/*
-	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
-	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
-	 * will be sensible, but nobody has implemented and tested that yet.
-	 */
-	return !folio_test_large(folio);
-}
+/* linux/mm/folio-compat.c */
+void mark_page_accessed(struct page *page);
 
 extern atomic_t lru_disable_count;
 
@@ -333,42 +313,7 @@ static inline bool lru_cache_disabled(void)
 	return atomic_read(&lru_disable_count);
 }
 
-static inline void lru_cache_enable(void)
-{
-	atomic_dec(&lru_disable_count);
-}
-
-extern void lru_cache_disable(void);
-extern void lru_add_drain(void);
-extern void lru_add_drain_cpu(int cpu);
-extern void lru_add_drain_cpu_zone(struct zone *zone);
-extern void lru_add_drain_all(void);
-void folio_deactivate(struct folio *folio);
-void folio_mark_lazyfree(struct folio *folio);
-
 /* linux/mm/vmscan.c */
-extern unsigned long zone_reclaimable_pages(struct zone *zone);
-extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-					gfp_t gfp_mask, nodemask_t *mask);
-unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
-
-#define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
-#define MEMCG_RECLAIM_PROACTIVE (1 << 2)
-#define MIN_SWAPPINESS 0
-#define MAX_SWAPPINESS 200
-
-/* Just reclaim from anon folios in proactive memory reclaim */
-#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
-
-extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
-						  unsigned long nr_pages,
-						  gfp_t gfp_mask,
-						  unsigned int reclaim_options,
-						  int *swappiness);
-extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
-						gfp_t gfp_mask, bool noswap,
-						pg_data_t *pgdat,
-						unsigned long *nr_scanned);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
@@ -389,11 +334,6 @@ static inline void reclaim_unregister_node(struct node *node)
 }
 #endif /* CONFIG_SYSFS && CONFIG_NUMA */
 
-#ifdef CONFIG_NUMA
-extern int sysctl_min_unmapped_ratio;
-extern int sysctl_min_slab_ratio;
-#endif
-
 void check_move_unevictable_folios(struct folio_batch *fbatch);
 
 extern void __meminit kswapd_run(int nid);
@@ -553,7 +493,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 #else
-static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
+static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	return READ_ONCE(vm_swappiness);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 5602393054f3..1744bb6b3222 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,6 +24,74 @@
 
 struct folio_batch;
 
+/* mm/workingset.c */
+bool workingset_test_recent(void *shadow, bool file, bool *workingset,
+			    bool flush);
+void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
+void *workingset_eviction(struct folio *folio,
+			  struct mem_cgroup *target_memcg);
+void workingset_refault(struct folio *folio, void *shadow);
+void workingset_activation(struct folio *folio);
+
+/* mm/folio_lru.c */
+void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
+		unsigned int nr_io, unsigned int nr_rotated)
+		__releases(lruvec->lru_lock);
+void lru_note_cost_refault(struct folio *folio);
+void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma);
+
+static inline bool folio_may_be_lru_cached(struct folio *folio)
+{
+	/*
+	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
+	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
+	 * will be sensible, but nobody has implemented and tested that yet.
+	 */
+	return !folio_test_large(folio);
+}
+
+static inline void lru_cache_enable(void)
+{
+	atomic_dec(&lru_disable_count);
+}
+
+void lru_cache_disable(void);
+void lru_add_drain(void);
+void lru_add_drain_cpu(int cpu);
+void lru_add_drain_cpu_zone(struct zone *zone);
+void folio_deactivate(struct folio *folio);
+void folio_mark_lazyfree(struct folio *folio);
+
+/* mm/vmscan.c */
+unsigned long zone_reclaimable_pages(struct zone *zone);
+unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
+				gfp_t gfp_mask, nodemask_t *mask);
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
+			      int zone_idx);
+
+#define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
+#define MEMCG_RECLAIM_PROACTIVE (1 << 2)
+#define MIN_SWAPPINESS 0
+#define MAX_SWAPPINESS 200
+
+/* Just reclaim from anon folios in proactive memory reclaim */
+#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
+
+unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
+					   unsigned long nr_pages,
+					   gfp_t gfp_mask,
+					   unsigned int reclaim_options,
+					   int *swappiness);
+unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
+				     gfp_t gfp_mask, bool noswap,
+				     pg_data_t *pgdat,
+				     unsigned long *nr_scanned);
+
+#ifdef CONFIG_NUMA
+extern int sysctl_min_unmapped_ratio;
+extern int sysctl_min_slab_ratio;
+#endif
+
 /*
  * Maintains state across a page table move. The operation assumes both source
  * and destination VMAs already exist and are specified by the user.
diff --git a/mm/memfd.c b/mm/memfd.c
index abe13b291ddc..6c72fe6caef7 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -19,6 +19,7 @@
 #include <linux/memfd.h>
 #include <linux/pid_namespace.h>
 #include <uapi/linux/memfd.h>
+#include "internal.h"
 #include "swap.h"
 
 /*

-- 
2.43.0


