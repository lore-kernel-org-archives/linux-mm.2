Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C71C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3157C6B009D; Thu,  9 Jul 2026 10:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5BB6B009F; Thu,  9 Jul 2026 10:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5036B00A2; Thu,  9 Jul 2026 10:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C686F6B009D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:51:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E594401DB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:51:56 +0000 (UTC)
X-FDA: 84969527832.13.55B7499
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 572E94000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:51:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IoKogOo8;
	spf=pass (imf12.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783608714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9b7aaO69R2fNMLXh0/PKSXnUU+kkoQXOZs7b0+s748=;
	b=bdrTe2Pb/vKvQwcOa4X8w3Ivlv3qPbxzM3RaEuxwq2TeEwbsEZZYMDwxm/bJHjq/Gvqxe8
	msZZ1mgTIL193JtdH5KD4Y/ngJJswblb8jVgFm7X2xcg6EVLv8j4NwgqlI9nYAP1SlOvGO
	98jLy3iadPlkGbiqJlW3ihE0CHC4JIs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IoKogOo8;
	spf=pass (imf12.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783608714;
	b=P7QN5lQWxs5HnuGe33tj51F4pZLK4yEhKit1hoQKAG/bZdus307EkTRdGAD2IfQJbZfNSO
	SigX3IPBWr3eOB1JJT1h3fq4PdgaYSMqzGwEmydYaKhBwxiowY+W4PI4kbvE3HVUIl/5TO
	ld1RT4RFrJ27ukqub+Dswimv8qEB1Dg=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-381f03d7be0so181691a91.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 07:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783608713; x=1784213513; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/9b7aaO69R2fNMLXh0/PKSXnUU+kkoQXOZs7b0+s748=;
        b=IoKogOo8xFBqXFA77jAZoh0ucT4gAeb7vH8TtLs9k28pffE1LIdKbHte+9GF8vA726
         OjcEpkShsbesJ0zjfVYKHh7hO68k0faIl1BQTxXmpCeB9DzfThDUrWSG4EkMpDcSCxea
         IxSRCKaWFwKVYeL6oDBgSGL3pLVN+2rXtF7267V0rEWtRsgHDvxj3Ti5uYDID1PBwUG5
         wi2RiReXN3IHxQSMj3n39hhTBjIXu49YV0elOef4maj5gDKoZ99EznYLqWhggnTJy/HK
         8VcqFPJb1/zpT9wCQBIHGMFu7xbLiFpkTmmMxovQpkUcsiqcSjtm9uChwOs3FFUOaUCB
         mqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783608713; x=1784213513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/9b7aaO69R2fNMLXh0/PKSXnUU+kkoQXOZs7b0+s748=;
        b=f8ijcKVKjVHTsJ+MyLTQ2IaQ7grH+1PsEEzNIz+7i91N+/k80bP9uXrddtuVKV4rZM
         z43PIyL7Y1PjVpr6B5PuPiyG+3xjX5aFGIG6pZa4u/kZpR+R3MSscdtIZ/HgOek0PN2N
         9GeoBmnghzvM2edG9BEuTAXSnTzoLO02sUfUEamQXvBFipEClzn2fzMQEdsA5eYFVeev
         fDnRVsL7uDUAQMGFO+KY18anSMUKcm4D7jOMCq1wGLgrspdZL5dTAmBSAgjv/udkbKdY
         tpCBn3+gKdFK+VHpLam386IrGYiYmXMdYkPPohz55OHJ/pMRI+JOZmNDGqzPhuwbMCw6
         yHxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp4ZjE3kQbF5CEi9+8nHbBJYA9IF1+b91LLd9vgHX2GMlXIteDrk1IORy2JI5+sdrZdbqzqoj7z/w==@kvack.org
X-Gm-Message-State: AOJu0Yy11FqERz9oFHa5LpTZJjSppQRo2WVSto75si95qXDO8Exy4HEi
	HO2Hl3kGXRf13ZGKU2J7mtr2Wb2sm79Bq1JBClvbreY1TrX2FHdNpxDN
X-Gm-Gg: AfdE7ckiYlLVDMC8vQS34PxbAAgftgMKaIXmeXLKYbQE/ePjwXeF/QUWqjPtju19tHn
	QwyIOTeVp4e+HF3GaflQMam3GXggs0cbMzEtMHQNWHlRlnZARH/RoV6ravcx+HDFTvFuibPtEeI
	NILJt7p9CtrdNSu9YGoQ8Ski7bodsaULx5i9pNmKe/NP7IEd7FRPESXpA/J49V9jHaXnChx/u7/
	tZ+sODqjdjey6WzmQFIgAQspnQC6uTI1f7JHLSfLp9Ka+FngkokvpCWzzrO8GuFMyVGYPdbz1iz
	OVefgcvnSZU0jpq2jPDc09sJQfPaomwLa2moCTj9Fi8PK0OYyWxs0NnrIEUOjSQ5FCJzMbfRuW7
	c0eFE/TyAUuAlBA6igYGG0IlJ4PV5axoygeQN/wRHwov7r4Z45oxBZ4Oa3/pNVk7Pmy9LDjAi26
	/Qd+1kmMEIX1XBx5GXtlT/3SeQ8nkSb92yfu32npmbsF3n1+QWIxvXeb5Rsk3tlbLksHAcrkxtB
	kLkSTMVlPlAtCtc0A==
X-Received: by 2002:a17:90b:554f:b0:381:96a2:14d8 with SMTP id 98e67ed59e1d1-38a21eddb43mr3429162a91.8.1783608713109;
        Thu, 09 Jul 2026 07:51:53 -0700 (PDT)
Received: from debian.lan ([240e:391:ea3:6910:38e7:894b:82e3:a58b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a57dc5820sm1286917a91.10.2026.07.09.07.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 07:51:52 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v2 2/3] mm: distinguish large folio swap allocation failures
Date: Thu,  9 Jul 2026 22:51:23 +0800
Message-ID: <20260709145124.764807-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
References: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 572E94000D
X-Stat-Signature: b8ryheunsgwwk8j6ottp6u6uwwbexwy3
X-HE-Tag: 1783608714-87579
X-HE-Meta: U2FsdGVkX1+Jb+sK6EKYpzM5qzTOlnMzbWldG8eCaomiM+TDSu8atpsQv8KVPXMmwiWdUZ9JCDItHInCIy0EqXfNKNpeP9iOliVuip5EZvpGVJ1MYAPBbxQhRl5Mo7mi09oEFaFSCiWhRfw0lqsBYrij36DAydagD6SWAdWy/XVhN0FwBnPK0LoDc9BxaBCbR5lD+WQfPU7NHYPyo5zLSx4qRF/q63uvE72eUi4CB1KAcGEc3udilUJyzTxg2lPuGor8BCnb33U8gK0T+eBfFi0TVXnO2kuTRIG8tBf11y+s4G8bSi1yzKsTAcIb51HuaT/WVVDmL20k+N1cpJj4EHlThaEMBTtvm6o0DaN4EoCnMEU8vO/tLGFiQO38uuDHG4Q8+KQ8Q1lupInj9cXqk74cAtfdfEa5jIU8toIEZCtD2bfzAqiG/knj1QgcKkHg7lHJWWkTpS9h8rwZyWHIATzpN9sshL+w5qydfK9KmVFfoKCU2h8TT7ilLzrHJVquDg7fpvNsh9j0JOy/pnph9kQtEL3y2nqKO0zPq/p8R80aMdjRUz4oiyoZpHjLsx38d8ST8z6TTGxV7pYhXUCD48RotokqXlz6dmWOg7BHNmc9jhkuQeY1mdgqY8TMVSotT++rjFuOvAp0kq1CFH/rMix9jTsK6kYRdu5qbhkD2M+33ozgh4V4FTMTIPLrnS9My0+2UQO8tDuDPP6kE4Va1qeWWle23cKPRNKiBds0j68ZT1gfqzY84v0v3GtkFccZLESuWsuixMdqCrJu8cozVBocmEWAVFz3YXYd0vMKPvhchJyxbO+RItiJ2yziOyPdn4y+KNaoyu7XC5fMWsOd9drvqIK0ELwrgq35bb5KL+nb5L5P7Nv5Z4ofwUQLc6ai7rlOJdhf2BSQVLeTsdb9jezJyHy1XqahnlqmFMwSZqNdV8zJPbTCR4cGWK6G8EZ+OnAaX16bFI/Rgr+56de
 jy75P5HG
 Ki9jEepOqaBHiPrF0YKsvGP9g0HvzkMEhuca+7NM7gSy2ibpFjDjmij+YxYD5N+6voI+22Kn1aKm88dbbP9d4tjidhmjHsDZcEmdPfoDvwkHZw2XJVfnnH0z29MiJxgaob1b2Wk52ggrNfFpN51/9KSGfF/SPsdIYgoIAxWgfDGzG30ZwpKUYfrDKmLwTJsl4mpoYUZofzDLK1LD4yURKFmGPzsRY2h4ao9+RRgFTYtyiyt+mJOFhBER4RkGI6rZpbDUPan+qgwiGuR+lzmZfdLjLvOT7BSx3EoyVmLzvtY9+MGYMucoRA9tfOFy5HhHHPJ7TAbK5FpvIw7a/V5WQ2mrP8m6cl9WhwQvqM8LkWFJtZKZ/G8kqOAZAzO7yn+XSWmiHVRRGip99fp1jw/hL+YJWKbSeQ5aPSCua0y2gQ3lqaZ6fcm8haHd5aILSNPIPsTbAEEa2x5Xmh/upOZVa42aNXFt8RFJAlv412nRiW0iWAJgZLcWdCCE2oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_alloc_swap() reports most allocation failures with a generic
negative error code. Reclaim cannot tell whether splitting a large folio
could make progress or whether there is no backing space at all.

Track the global free swap count around the allocation attempt and let the
memcg swap charge path cap it by the remaining hierarchical swap margin.
Return -E2BIG for large folios when a smaller allocation might still fit,
-ENOSPC when no swap space is available, and -ENOMEM when the failure is
not helped by splitting.

This only refines folio_alloc_swap() return codes. The reclaim caller is
updated separately.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/swap.h | 10 ++++++----
 mm/memcontrol.c      | 15 ++++++++++-----
 mm/swapfile.c        | 21 +++++++++++++++------
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..0695ac56457f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -571,13 +571,14 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
+				 long *nr_swap_pages);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-		swp_entry_t entry)
+		swp_entry_t entry, long *nr_swap_pages)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio, entry);
+	return __mem_cgroup_try_charge_swap(folio, entry, nr_swap_pages);
 }
 
 extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
@@ -592,7 +593,8 @@ extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
-					     swp_entry_t entry)
+					     swp_entry_t entry,
+					     long *nr_swap_pages)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 177732fef010..71600d41958e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5472,12 +5472,14 @@ int __init mem_cgroup_init(void)
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
  * @entry: swap entry to charge
+ * @nr_swap_pages: optional swap availability to cap by memcg margin
  *
  * Try to charge @folio's memcg for the swap space at @entry.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
+				 long *nr_swap_pages)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct page_counter *counter;
@@ -5495,6 +5497,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!entry.val) {
+		if (nr_swap_pages && !mem_cgroup_is_root(memcg))
+			*nr_swap_pages = min(*nr_swap_pages,
+					     page_counter_margin(&memcg->swap));
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5509,6 +5514,9 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
+		if (nr_swap_pages)
+			*nr_swap_pages = min(*nr_swap_pages,
+					     page_counter_margin(counter));
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
@@ -5550,10 +5558,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 
 	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
-		nr_swap_pages = min_t(long, nr_swap_pages,
-				      READ_ONCE(memcg->swap.max) -
-				      page_counter_read(&memcg->swap));
+	nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
 	return nr_swap_pages;
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..53a921ca099a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1690,12 +1690,14 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
  * swap cache.
  *
  * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
+ * Return: 0 on success, -E2BIG if splitting the folio might allow swapout,
+ * or another negative error code if splitting would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	long nr_swap_pages;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1706,7 +1708,7 @@ int folio_alloc_swap(struct folio *folio)
 		 * the caller should split the folio and try again.
 		 */
 		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+			return -E2BIG;
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1714,10 +1716,12 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			return -E2BIG;
 		}
 	}
 
+	nr_swap_pages = get_nr_swap_pages();
+
 again:
 	local_lock(&percpu_swap_cluster.lock);
 	if (!swap_alloc_fast(folio))
@@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
+						&nr_swap_pages))) {
 		swap_cache_del_folio(folio);
+		return order && nr_swap_pages > 0 ? -E2BIG : -ENOMEM;
+	}
 
-	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+	if (unlikely(!folio_test_swapcache(folio))) {
+		nr_swap_pages = get_nr_swap_pages();
+		return order && nr_swap_pages > 0 ? -E2BIG : -ENOSPC;
+	}
 
 	return 0;
 }
-- 
2.47.3


