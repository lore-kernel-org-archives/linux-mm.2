Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E80CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271936B00C9; Tue,  7 Jul 2026 02:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3B66B00CB; Tue,  7 Jul 2026 02:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074016B00CC; Tue,  7 Jul 2026 02:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF0726B00CB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32AA61A02ED
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:42 +0000 (UTC)
X-FDA: 84961037364.02.F19E290
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 75EF040006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eSRMPxdA;
	spf=pass (imf11.hostedemail.com: domain of 3359MagsKCKocYebKfZKXNKQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--souravpanda.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3359MagsKCKocYebKfZKXNKQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iyFxv+a9AoNecfBItBeqHuAUs1hY8V/dePzFhTlOMv8=;
	b=2xbheybFQZ2n2m6gwB6q+Z2eFPy3FG7o12WlRDrpPUbCX9obLsNzM253O+dcy2h9TPXLSx
	iMqmM0uNaYG+M5AqSNFKuLC+3FQ4M+CBl1sbDlcCzxvqf24K00UL2hyhlOgq4rXNYy0Fd4
	tEAAjWgGZh9jlJbQPf/uH8682qRC0/A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eSRMPxdA;
	spf=pass (imf11.hostedemail.com: domain of 3359MagsKCKocYebKfZKXNKQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--souravpanda.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3359MagsKCKocYebKfZKXNKQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406560;
	b=Ek6dFGKVgVLa6Nd0Yzxk3WKR8QTDyzBA9s2BJvSborO5vj/sg7R11bpJvrZWKmMAZV6YPM
	e5zbvi9hXy283SNY5N7ZC2Yb3PKNTLTct8RWbhH79uHPjZjsJo6ovxQ6S5kIvd6AbzTl6a
	jF2h4/NecqXZ64IVz1GjBbeUp9JvY8I=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8423f1fe39eso7821148b3a.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 23:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783406559; x=1784011359; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iyFxv+a9AoNecfBItBeqHuAUs1hY8V/dePzFhTlOMv8=;
        b=eSRMPxdAFL+bcaTVmcHrlBD/q2lS1ZO7sRp6a5L+YnBnX1kqT3pku15H+MIetWC0Ik
         FWORdvAy+hDUhEbVPHSqcaTMaXh7/C0Mrjl7YHJrR53WRFRrxj2L2o33TCC67EMzLgYF
         lzIOtrFf/ekJP1D+ZNhO2W/7uymr5cS4OAyUCmVkh0dcEll075bIyALexP+PIU99Jzfb
         9SFD6ncpMOixqPBim9irb0bn0ZDD+GPmA6UryQYLK+ULXZ38pG4s9ovOxRxdoB3N25C/
         /OBiRsuMh3R9SvAkQN9twFrDvZBeougtUto2ccDlU54C3Byp9GIdrSJ2RWeFEOLSIGrs
         HaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783406559; x=1784011359;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iyFxv+a9AoNecfBItBeqHuAUs1hY8V/dePzFhTlOMv8=;
        b=HO3dwDhnESGD6GC9ivbGW5Qh0asBrwaDR4cYwvTl9XX9C1RfdNDPKWmI0ntnAl56U7
         xhCJgxTdpiPClUQRsroKehrrT3hLaNVh963dGwXPgn1JLNBOtk7apUbSLfxdNcehyhNS
         Bci5yWSoYQzfedls1kXLvuai9wsC+ER8e+XyaPBSm8GjwBXiBKDM8AF+V+uw6ZT38DEQ
         w1TRqItrlX/gaBAYZXASdz5a886q2BVOVQwYHVO2GxhSIf9Ds6ILAIF8BjyTjxNHy/3p
         b8kvXY1yCtYeJqgYKyUQ3+ulmEILXe8rgmd+tlds5Wyt1CM9PUr8TAYR6298Za8b2Szt
         A/Tw==
X-Forwarded-Encrypted: i=1; AHgh+Ro/yNP8zNc167jVtwoxSrjT5wGMA4HjINyCEAmP/tSmkxENWSJJp7csqyZmw3ddavV65pXlEXyWvw==@kvack.org
X-Gm-Message-State: AOJu0YyrdddlC+1mSd1QxpypY053joFiZwcBUuSbPQ5SRn99tBYo0tUv
	rpOx8N8EJG8JRdU5bgbLZ9Rm09LrWCtX3n+yrrSqPAJL+68ITK4aTB6JbBwQzXPL3aIypbgn5RJ
	+hefLFwYoIgq1DN9Fm7WBSHBBYA==
X-Received: from pfop8.prod.google.com ([2002:a05:6a00:b48:b0:845:3a81:a435])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1488:b0:847:9745:2f91 with SMTP id d2e1a72fcca58-84826db0eefmr3988189b3a.28.1783406559141;
 Mon, 06 Jul 2026 23:42:39 -0700 (PDT)
Date: Tue,  7 Jul 2026 06:42:32 +0000
In-Reply-To: <20260707064235.1386552-1-souravpanda@google.com>
Mime-Version: 1.0
References: <20260707064235.1386552-1-souravpanda@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260707064235.1386552-4-souravpanda@google.com>
Subject: [PATCH 3/6] mm/hugetlb: add sysfs interfaces for cache
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
X-Rspamd-Queue-Id: 75EF040006
X-Stat-Signature: khf6j1by53ppchid8jn38xfxqk4psh7k
X-HE-Tag: 1783406560-371146
X-HE-Meta: U2FsdGVkX197/zBbLAEmadxsdODTT+n4/IvjVvJvZ3qaGizZmdvNTqS68psKsVW99h8V49APCI7bTCp3Ot65rvRXCl/u265JuM/Ad0JHr1XdKF4qEyfuCgb5sQAgQex2aRBEPEA9F9LRsaRHNoCUzTogn2j/qxHG+EaOJ62FSihZpkxmbcn/3wnFZEr+lsQq1boNMML2tznUsfmfyer0Texxj3aFZYx4Y9p1IUxcikTZKugAa/fVWoMkSq8BO8UheYEI13H+vyTxs80sLXmdnqcZP6FBfWWeJ3tl3hSzwsg2mV6DlomDLe3dYLjVnu+r9HADEOC6RNsPaBIZqZ4wpOSj9ViQCuYdukQPpk6TkBsTgStxNnxAbCkJh/ASwyv4yn9Ns3uJh+SE9AFKXXYkUTFpYGtob+C+8ckqsNdhCFhnvOETu+f5fJUlaO7vhcy4znC0j9MzvR3RGUM0YJ8dKLS2VJ5D4TZJV3i8U6XQAq3nm1a0pX774+KyzVZ0ZocvFdLfLjSYvKSsLzYWTSxwqwlgMCXamqt3Zury8Vf2zNSB3ElITtVHyO9/YCvmLBFV85Rptx5SO6DxJeORenEKMFDITtQYDRPr/UWVk7IQ8oMyr0J/cE8VfVGTtAHu4owAtOBIdGBdyt4wpj41ozXZEYBdhQmqYu1o2389wVkgCWsW0wSEzef4CXPO6B105w+wuHvyWP+7memzpaPZ6Q4Y7n4qDhS5jPX01ljctarUz3IHKr2YagkEQuWUyg3jaSyruE79jFL9TO/mSoZqehLL2tARaH17odm+9Qrw28KhxRJyYqcBjbZFpYsbWUoL86mWEQ8LVig1lTntPq9vx0vbQeQ8PiZw7pYVwFMr3C8NRySQEQDvdd9k7ESImkMjuhtXVqcfer9W9Q+n+Pn6TaLjvIN/Ht3EsFJidVo8dQVW5+qIqHM0gisHpdkydeQreK8tit/bOe+07tXVOypEtZi
 B9YAcsHN
 3IIILHEEAZz5LhYTSJpXi1dfTyA6QE1GYp/55zlXIqR2UiXCcSvAaMDIiquOHNJ64MbHYDS/TnPJYmPceMQ1Plc0Zozr/zdql6YB1wmQF9499oNrUga1VQpWFipvj9aFyGD4BinHCWHp8uKf9QGA9SUl/oAEHe0uxhu/27zgBYAjQDVSESahxGtNsipwJt0VcI1MdgOB+Gi6QjFrO8mIGBh1S8WTUFINUkVHXlrG4rP3bj6tLdKIHI8a22nNaonItmRHesz1gUQqxXIf0J22zVvGVKLWumYxo2GjdfMPvuJ2JzPUoO90NKOCrGZt3+TbNzXAvAlLA52CF+00uvn4ff0nccaN+/JkvB7JysBXwDQOD9e63dRNdN49rp+Q+4elqbYF6CJ59CRtu/KO8fPHnfIBK30yxSWo2jEvvLhesSV0OAmybN+jiKn/kPOey/Sg40Op3XyJ1tzN/9J/kTRSmN2P25Aq6o6Q1Vvh63hj2HBfq36wYx/jdoq5AhLeJgD/E0No7ff2iqHATeL7uRWbkbDbxPXCKro55CE7WJsBjwZrL/O7bIlXlmz2x+m7M0pgQEeidhUoHz9c5wSFtpU6zsPldoGbe7yRGXFv1osr6lUP9BvzbEne4uaonJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce sysfs interfaces to control and monitor the HugeTLB dynamic
cache.

Expose the following attributes under:
/sys/kernel/mm/hugepages/hugepages-<size>/
- max_cached_huge_pages: Max limit of cached hugepages (global).
- nr_cached_hugepages: Current number of cached hugepages. Writing to
  this file allows manual expansion or contraction of the cache.
  These interfaces support writing delta values (e.g. "+1" or "-1")
  in addition to absolute values, allowing orchestrators (e.g. borglet)
  to dynamically scale the cache without racing against the kernel
  shrinker.

Also expose node-specific versions under node sysfs if CONFIG_NUMA.

Implement adjust_cached_huge_pages to handle the actual expansion
(allocating fresh hugepages to cache) and contraction
(freeing cached hugepages to buddy).

For expansion and contraction correctness:
- Global expansion interleaves allocations across allowed nodes.
- Node-specific expansion enforces the global cache limit ceiling and
  overcommit limits, uses __GFP_THISNODE to prevent fallback, and accounts
  to the actual allocated node using folio_nid().
- Contraction uses LRU (Least Recently Used) policy (taking from the
  head of the cache list) to discard cold pages first.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 mm/hugetlb.c          | 230 ++++++++++++++++++++++++++++++++++++++++++
 mm/hugetlb_internal.h |   9 ++
 mm/hugetlb_sysfs.c    | 158 +++++++++++++++++++++++++++++
 3 files changed, 397 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d00aa67b8e13..f18a3123cbcb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4171,6 +4171,236 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 	return -EBUSY;
 }
 
+#ifdef CONFIG_HUGETLB_CACHE
+static int adjust_cached_huge_pages(struct hstate *h, long count, bool is_delta, int nid,
+				    nodemask_t *nodes_allowed, bool update_limit)
+{
+	struct folio *folio;
+	int err = 0;
+
+	mutex_lock(&h->resize_lock);
+
+	if (is_delta) {
+		long current_val;
+
+		if (nid == NUMA_NO_NODE)
+			current_val = update_limit ? h->max_cached_huge_pages :
+						     h->nr_cached_hugepages;
+		else
+			current_val = update_limit ? h->max_cached_huge_pages_node[nid] :
+						     h->nr_cached_hugepages_node[nid];
+
+		current_val += count;
+		if (current_val < 0)
+			current_val = 0;
+		count = current_val;
+	}
+
+	if (nid == NUMA_NO_NODE) {
+		int temp_next_node = first_node(*nodes_allowed);
+
+		if (update_limit) {
+			h->max_cached_huge_pages = count;
+		} else if (count > h->max_cached_huge_pages) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		/* Expansion */
+		while (!update_limit) {
+			unsigned long curr;
+
+			spin_lock_irq(&hugetlb_lock);
+			curr = h->nr_cached_hugepages;
+			spin_unlock_irq(&hugetlb_lock);
+
+			if (curr >= count)
+				break;
+
+			folio = alloc_pool_huge_folio(h, nodes_allowed,
+						      NULL, &temp_next_node);
+			if (!folio) {
+				err = -ENOMEM;
+				break;
+			}
+
+			spin_lock_irq(&hugetlb_lock);
+			if (h->nr_cached_hugepages >= count) {
+				spin_unlock_irq(&hugetlb_lock);
+				update_and_free_hugetlb_folio(h, folio, false);
+				break;
+			}
+
+			account_new_hugetlb_folio(h, folio);
+
+			hugetlb_cache_add(h, folio, false);
+			spin_unlock_irq(&hugetlb_lock);
+			cond_resched();
+		}
+
+		/* Contraction */
+		while (1) {
+			unsigned long curr;
+			struct folio *folio = NULL;
+
+			spin_lock_irq(&hugetlb_lock);
+			curr = h->nr_cached_hugepages;
+			if (curr <= count) {
+				spin_unlock_irq(&hugetlb_lock);
+				break;
+			}
+
+			int node;
+
+			for_each_node_mask(node, *nodes_allowed) {
+				if (!list_empty(&h->hugepage_cache_lists[node])) {
+					folio = list_first_entry(&h->hugepage_cache_lists[node],
+								 struct folio, lru);
+					break;
+				}
+			}
+
+			if (!folio) {
+				spin_unlock_irq(&hugetlb_lock);
+				break;
+			}
+
+			remove_hugetlb_folio(h, folio, false);
+			spin_unlock_irq(&hugetlb_lock);
+
+			update_and_free_hugetlb_folio(h, folio, false);
+			cond_resched();
+		}
+	} else {
+		if (update_limit) {
+			h->max_cached_huge_pages_node[nid] = count;
+		} else if (count > h->max_cached_huge_pages_node[nid]) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		/* Node expansion */
+		while (!update_limit) {
+			unsigned long curr;
+			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
+
+			spin_lock_irq(&hugetlb_lock);
+			curr = h->nr_cached_hugepages_node[nid];
+			if (h->nr_cached_hugepages >= h->max_cached_huge_pages) {
+				spin_unlock_irq(&hugetlb_lock);
+				err = -ENOSPC;
+				break;
+			}
+			spin_unlock_irq(&hugetlb_lock);
+
+			if (curr >= count)
+				break;
+
+			folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
+							  nid, nodes_allowed);
+			if (!folio) {
+				err = -ENOMEM;
+				break;
+			}
+
+			spin_lock_irq(&hugetlb_lock);
+			if (h->nr_cached_hugepages_node[nid] >= count) {
+				spin_unlock_irq(&hugetlb_lock);
+				update_and_free_hugetlb_folio(h, folio, false);
+				break;
+			}
+
+			account_new_hugetlb_folio(h, folio);
+
+			hugetlb_cache_add(h, folio, false);
+			spin_unlock_irq(&hugetlb_lock);
+			cond_resched();
+		}
+
+		/* Node contraction */
+		while (1) {
+			unsigned long curr;
+			struct folio *folio = NULL;
+
+			spin_lock_irq(&hugetlb_lock);
+			curr = h->nr_cached_hugepages_node[nid];
+			if (curr <= count) {
+				spin_unlock_irq(&hugetlb_lock);
+				break;
+			}
+
+			if (!list_empty(&h->hugepage_cache_lists[nid]))
+				folio = list_first_entry(&h->hugepage_cache_lists[nid],
+							 struct folio, lru);
+
+			if (!folio) {
+				spin_unlock_irq(&hugetlb_lock);
+				break;
+			}
+
+			remove_hugetlb_folio(h, folio, false);
+			spin_unlock_irq(&hugetlb_lock);
+
+			update_and_free_hugetlb_folio(h, folio, false);
+			cond_resched();
+		}
+	}
+
+out:
+	mutex_unlock(&h->resize_lock);
+	return err;
+}
+
+ssize_t __nr_cached_hugepages_store_common(bool obey_mempolicy,
+					   struct hstate *h, int nid,
+					   long count, bool is_delta, size_t len)
+{
+	int err;
+	nodemask_t nodes_allowed, *n_mask;
+
+	if (hstate_is_gigantic_no_runtime(h))
+		return -EINVAL;
+
+	if (nid == NUMA_NO_NODE) {
+		if (!(obey_mempolicy &&
+		      init_nodemask_of_mempolicy(&nodes_allowed)))
+			n_mask = &node_states[N_MEMORY];
+		else
+			n_mask = &nodes_allowed;
+	} else {
+		init_nodemask_of_node(&nodes_allowed, nid);
+		n_mask = &nodes_allowed;
+	}
+
+	err = adjust_cached_huge_pages(h, count, is_delta, nid, n_mask, false);
+
+	return err ? err : len;
+}
+
+ssize_t __max_cached_huge_pages_store_common(bool obey_mempolicy,
+					     struct hstate *h, int nid,
+					     long count, bool is_delta, size_t len)
+{
+	int err;
+	nodemask_t nodes_allowed, *n_mask;
+
+	if (hstate_is_gigantic_no_runtime(h))
+		return -EINVAL;
+
+	if (nid == NUMA_NO_NODE) {
+		if (!(obey_mempolicy &&
+		      init_nodemask_of_mempolicy(&nodes_allowed)))
+			n_mask = &node_states[N_MEMORY];
+		else
+			n_mask = &nodes_allowed;
+	} else {
+		init_nodemask_of_node(&nodes_allowed, nid);
+		n_mask = &nodes_allowed;
+	}
+
+	err = adjust_cached_huge_pages(h, count, is_delta, nid, n_mask, true);
+
+	return err ? err : len;
+}
+#endif /* CONFIG_HUGETLB_CACHE */
+
 ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 					   struct hstate *h, int nid,
 					   unsigned long count, size_t len)
diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
index 1d2f870deccf..16ed9ac9dc05 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -114,4 +114,13 @@ extern void hugetlb_sysctl_init(void);
 static inline void hugetlb_sysctl_init(void) { }
 #endif
 
+#ifdef CONFIG_HUGETLB_CACHE
+ssize_t __nr_cached_hugepages_store_common(bool obey_mempolicy,
+					   struct hstate *h, int nid,
+					   long count, bool is_delta, size_t len);
+ssize_t __max_cached_huge_pages_store_common(bool obey_mempolicy,
+					     struct hstate *h, int nid,
+					     long count, bool is_delta, size_t len);
+#endif
+
 #endif /* _LINUX_HUGETLB_INTERNAL_H */
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 79ece91406bf..682a3805e6ff 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -277,6 +277,152 @@ static ssize_t demote_size_store(struct kobject *kobj,
 }
 HSTATE_ATTR(demote_size);
 
+#ifdef CONFIG_HUGETLB_CACHE
+static ssize_t nr_cached_hugepages_show_common(struct kobject *kobj,
+					       struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h;
+	unsigned long nr_cached;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE)
+		nr_cached = h->nr_cached_hugepages;
+	else
+		nr_cached = h->nr_cached_hugepages_node[nid];
+
+	return sysfs_emit(buf, "%lu\n", nr_cached);
+}
+
+static ssize_t nr_cached_hugepages_store_common(bool obey_mempolicy,
+						struct kobject *kobj, const char *buf,
+						size_t len)
+{
+	struct hstate *h;
+	long count;
+	bool is_delta = false;
+	int nid;
+	int err;
+	const char *p = skip_spaces(buf);
+
+	if (*p == '+' || *p == '-') {
+		is_delta = true;
+		err = kstrtol(p, 10, &count);
+	} else {
+		unsigned long ucount;
+
+		err = kstrtoul(p, 10, &ucount);
+		count = (long)ucount;
+	}
+	if (err)
+		return err;
+
+	h = kobj_to_hstate(kobj, &nid);
+	return __nr_cached_hugepages_store_common(obey_mempolicy, h, nid, count, is_delta, len);
+}
+
+static ssize_t nr_cached_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return nr_cached_hugepages_show_common(kobj, attr, buf);
+}
+
+static ssize_t nr_cached_hugepages_store(struct kobject *kobj,
+					 struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	return nr_cached_hugepages_store_common(false, kobj, buf, len);
+}
+HSTATE_ATTR(nr_cached_hugepages);
+
+#ifdef CONFIG_NUMA
+static ssize_t nr_cached_hugepages_mempolicy_show(struct kobject *kobj,
+						  struct kobj_attribute *attr,
+						  char *buf)
+{
+	return nr_cached_hugepages_show_common(kobj, attr, buf);
+}
+
+static ssize_t nr_cached_hugepages_mempolicy_store(struct kobject *kobj,
+						   struct kobj_attribute *attr,
+						   const char *buf, size_t len)
+{
+	return nr_cached_hugepages_store_common(true, kobj, buf, len);
+}
+HSTATE_ATTR(nr_cached_hugepages_mempolicy);
+#endif
+
+static ssize_t max_cached_huge_pages_show_common(struct kobject *kobj,
+						 struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h;
+	unsigned long max_cached;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE)
+		max_cached = h->max_cached_huge_pages;
+	else
+		max_cached = h->max_cached_huge_pages_node[nid];
+
+	return sysfs_emit(buf, "%lu\n", max_cached);
+}
+
+static ssize_t max_cached_huge_pages_store_common(bool obey_mempolicy,
+						  struct kobject *kobj, const char *buf,
+						  size_t len)
+{
+	struct hstate *h;
+	long count;
+	bool is_delta = false;
+	int nid;
+	int err;
+	const char *p = skip_spaces(buf);
+
+	if (*p == '+' || *p == '-') {
+		is_delta = true;
+		err = kstrtol(p, 10, &count);
+	} else {
+		unsigned long ucount;
+
+		err = kstrtoul(p, 10, &ucount);
+		count = (long)ucount;
+	}
+	if (err)
+		return err;
+
+	h = kobj_to_hstate(kobj, &nid);
+	return __max_cached_huge_pages_store_common(obey_mempolicy, h, nid, count, is_delta, len);
+}
+
+static ssize_t max_cached_huge_pages_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	return max_cached_huge_pages_show_common(kobj, attr, buf);
+}
+
+static ssize_t max_cached_huge_pages_store(struct kobject *kobj,
+					   struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	return max_cached_huge_pages_store_common(false, kobj, buf, len);
+}
+HSTATE_ATTR(max_cached_huge_pages);
+
+#ifdef CONFIG_NUMA
+static ssize_t max_cached_huge_pages_mempolicy_show(struct kobject *kobj,
+						    struct kobj_attribute *attr,
+						    char *buf)
+{
+	return max_cached_huge_pages_show_common(kobj, attr, buf);
+}
+
+static ssize_t max_cached_huge_pages_mempolicy_store(struct kobject *kobj,
+						     struct kobj_attribute *attr,
+						     const char *buf, size_t len)
+{
+	return max_cached_huge_pages_store_common(true, kobj, buf, len);
+}
+HSTATE_ATTR(max_cached_huge_pages_mempolicy);
+#endif
+#endif /* CONFIG_HUGETLB_CACHE */
+
 static struct attribute *hstate_attrs[] = {
 	&nr_hugepages_attr.attr,
 	&nr_overcommit_hugepages_attr.attr,
@@ -285,6 +431,14 @@ static struct attribute *hstate_attrs[] = {
 	&surplus_hugepages_attr.attr,
 #ifdef CONFIG_NUMA
 	&nr_hugepages_mempolicy_attr.attr,
+#endif
+#ifdef CONFIG_HUGETLB_CACHE
+	&nr_cached_hugepages_attr.attr,
+	&max_cached_huge_pages_attr.attr,
+#ifdef CONFIG_NUMA
+	&nr_cached_hugepages_mempolicy_attr.attr,
+	&max_cached_huge_pages_mempolicy_attr.attr,
+#endif
 #endif
 	NULL,
 };
@@ -359,6 +513,10 @@ static struct attribute *per_node_hstate_attrs[] = {
 	&nr_hugepages_attr.attr,
 	&free_hugepages_attr.attr,
 	&surplus_hugepages_attr.attr,
+#ifdef CONFIG_HUGETLB_CACHE
+	&nr_cached_hugepages_attr.attr,
+	&max_cached_huge_pages_attr.attr,
+#endif
 	NULL,
 };
 
-- 
2.55.0.rc0.799.gd6f94ed593-goog


