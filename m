Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 648BFC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37DE16B0093; Wed, 29 Jul 2026 22:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355D76B0095; Wed, 29 Jul 2026 22:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B3F6B0096; Wed, 29 Jul 2026 22:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB5E06B0093
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:17:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F1538084D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:17:20 +0000 (UTC)
X-FDA: 85043831040.30.36EE3CA
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id A26C110000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:17:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kBworsds;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785377838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
	b=hC0d4XlxhB21r8NcaODkcWTEmB5ml4XIXTLvid/3Mdh/atNRHQ0WzTR7AkYLBG2a/xE3M+
	iJGndHhPQlbGU/Y7f1UpLKv3NCQ/eAHwyOxZzv2gaogOPzspDU3G3Iyfle7o+LYJ1kWQuI
	NqOHX/KD/RL64aBELG+Dqo/8HGGQlwM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785377838;
	b=fm4Y2EgR+IuV52pg+Q4waO1owBgC853uBbymuNYz5nroZoEdEuMfEDfKvLT6Fc8ZF3K160
	LEJhH9vy9JznGlFo5Z7P8VD1tXwVFeNlvLSh8wwduDh+pFHeepb+NQln3h634za2o4viZP
	4QSfadkbkZ3uHnmYbH7GA8JCvObz2DY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kBworsds;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8486c9a946bso161546b3a.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377837; x=1785982637; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
        b=kBworsdszzBIeHa/2uY8Jjfzcz7jbWm/SAbE35Nsm3EHaCie0gFn8mZBGDOZ1V61V0
         xefMRcYvgZnudMItnwg75Ez8DXsyzz6OWgbteNc21+7aPKevXlApD7Viz0pbNibPBo3R
         lMYmkoBqaike8A48om+O6XQEPxkxV3jERV9GnMtRUCY4GB8iJOM1dFPuIQ4N+SHZs2sn
         BvA5oRYkI8aL/yvhSCTzcwwtvrkSrSlilZ/B224NOSSO3o1Au2IUfKC/hAtojcDHmTHK
         atXXfVh/26D7Gowz3/mQRHkZjYi+hTubI7xbchlCeAJ/v6APfFYbbONOAMdCSm5E+QVO
         h75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377837; x=1785982637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
        b=iqmsnCcACQt0KgiByf97C5XvTLc8WP7hw4L9q1SKzF2K/afAnvShxcwwJiXk6lmkhj
         SpTbLlnovVvmQvuc0MCshA10WrtVf4Q8tLP6O8+Q4pdtzzc+4MtMf/xQHRQow+MJ6FzU
         hYsY2UcWCgEe7CTJQWwZlJQn1w0CD9vk6sEPKiQHpA813VeHEhJ07fF6Nckm+zk1jI15
         FeSOTSr/0BE66WPZqaTmMPlifEiEv3BVQf3kDS01Gnl2i1tfWzdm3I0Rg+v8WlEa/zrV
         aK/nVDrtccz00sEdvgkgDTtUXDnJjUdTrb2q0rHpUGW0mKVpzl0PriAasnGm37nm3/fC
         8zWA==
X-Forwarded-Encrypted: i=1; AHgh+RprQR/Q4E4N85vDcVyO1Mgek+8b4zV0c6IfWJVLK1JP7IxUKn3x5LhN2sFXoHSmN9wYHhXTBki5cQ==@kvack.org
X-Gm-Message-State: AOJu0YwRyGatajh1MehkzHgbjZxTDXnTrErleQBGTcW/ZuMYgona2kR/
	B93trfV9OZCsNDo/o5r7oFXKSwBPtj3F+FJ7JX1jo4eHvz04EMaK/jEnGdImLVfGJj+SIAtF
X-Gm-Gg: AR+sD139FTYFUCqMzcDE863X+yO9te49O2EBz3A85+hpldHD67f6DMm5ic93hwbvvoU
	vHJnl0Mtf7d0DZO9t0b/qxDC7q4AmDNWpyO/W02pNoHqOcuxazOD5Vl+N7S0vZzcaYB5CYJoVjX
	KGMhcufhVXxBq4O6iH6cJJcMjB6mhT4i2F5DjT8lIl/la4jaQJmRpR4JoTRbE98gI4SRkXkSQ2U
	6QI/KCPj0tOcJ7WZOQ9UuBJmQJv2LrTxoXKeZm6lpZMNlvKcYUkZls2SAQUt2RkztIziP/Be4oz
	FYjLt4HsoHrJfujYhzWr4I93mlTkMCPibjLYVYyGPZTsyqxN/+wCDgG51PjM+MNk8opRwWm6xI3
	rrX7WH+YcBo5XBazsezG5/AA3iPz0ukNSGbpzz7jmX35vVhNgyxWXj6eOSgnP5GlyDzz75mBSth
	g3psWsJy4mW7ujp6WYKbsb+IHTuwaJmoQUChb/YcbiYfsRzYB6ftXg2co/KjdIhpRIAf/W6rUJi
	+btNL1Dk5qdz8Kap49NxiUwJFhmQU9sDnTuylf0PRJhnQhePext
X-Received: by 2002:a05:6a00:4e02:b0:845:cb89:c1a3 with SMTP id d2e1a72fcca58-84ebc1ed5f0mr801314b3a.1.1785377837315;
        Wed, 29 Jul 2026 19:17:17 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:17:16 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 30 Jul 2026 10:16:28 +0800
Message-ID: <20260730021630.2235914-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
References: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A26C110000B
X-Stat-Signature: ubjyf8gqyt7s4adw7zqrc83faxepheay
X-Rspam-User: 
X-HE-Tag: 1785377838-449048
X-HE-Meta: U2FsdGVkX1++6WYevS/2SAVrqPjmxnVUq0CR57oqWZRVzfZIUVUsPJnHEOXcNrjH6d30SRWAw94OeBUdqvD0jFwZc73DHAxh+wYFFqQE6so27+SLlPggSUI2YUsPK0IlJvB55W28dDCnn0QXq2MkiM5MGPezia3/FMz1ZYVjnRcv5udIHqHYAblztQiHi/FvYth1sn5CA2LhKC+wW3o5xUmQbL6Pj/OyrNL3XdskBMbTjb7pP4qUka0232VwmmamnEXN39/OUYhmrnkb5bsq7c7DsY72PSwzfABq2rs98jOAtRam1uMpHb7cfhB1E8fGbHBdKPjLD2w/v94SVKtJLkoQxApX3JPmcGR0FhIqyN6e1rK+xn2sq9/1uniiKIyrNb+nN1xWgIfwbi+yGR4YISP+X62g9Pq1crgYIhvTfHSdRGew8gXIWtPUBRZliDDjPaNjoElZEZH1LbU0MWCMB9GFPRBhrTzyYL4ZPQNMXUyUrUxiPaNp+KIm/hNm4hXk+sVRkYwbXS76cJyjE1IvUavF2kdTT01e2zjmJlBQ5TYXeqC+eAiFE9otkp46QA2+fJqCSYIpy7y8AnhOKzYNp2aVWKswSfYP+BQs3AqQyREBLZc7+5eM32vR/0l5uU9oPkOlnhYp7kvcFfT7PkX6v3OIBzPleiCRXFuewXJMQsLFtG7h43+BbpCz+7yScUdGCuaFtLq7eRiyjKLCkEhzwaeVaIKnSWL2xt2pjJpmEdhwrcn/R8TclLrVkU5tE41PQrU/4JdXFe0M/pwY1OuiJ+1fqyinzGc9Xvjvvk4u1blegxOFo6G8rh3RJhVL7qZ+Qe96uis84rUk4a7WAsGsdOM0/OHvIj0+qozn8XrjXhlXrWgqDuOzXyzc9mnHEqQ+G8WiD4Izd77I7yUPWeawbBk3WZ6N34gwuCTUw/NWxdIooVgZQOOvGIGsr20mImka6tp3KAui0271gtj0Qsv
 p7kb1LbE
 jYcqpFGDTk67YbP9K0U2SQ+W3IPGBcPaSeQlkiMpJNfCrxxcC/KhisAzKDS64MbFCVOqthDbS9SKmGZQLrsdLJXlt1tCQFTm6PcMrPSMUxooaAceabFG1db6jrQAGlP0AU5jarj9J26Nzv1lKFeOYqwpR5qQgzx6ijGwFPeINH6iX9iVex3RmNsS9pCbuErSoEMszb73MNGGjUxYE5DlJKdRhkKnka7SQTZWOptXygnVhSTADslBstKA0+R6MBDhBkYubj0ahBDn6jnoxuMwO4cRz0Ff9+0LsuHGsz0gSWTW+KcAjoEMBSHe9ckO4vZ8jvyvlx3MTuWh9aXvXohehA9j/S1TzX+gAOFw/94n6rnIRv1e8Hjb5NmOheScDNF8Jv1l19do/aE2PctfRGX81ZvreuY7zqVatm6PRG8I2bRrpOVA62geKgmpNMkhvWyUoh2SHFG8rWs9pRHTb/mYBtQjmYXNBkRBU+V52caW+8OyhAhxirK4+nXD53tEdsm10UjBP6Jp3QlFLQSx2QgrsiEIpxrEIsrT9yNkP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_alloc_swap() reports most allocation failures with a generic
negative error code. Reclaim cannot tell whether splitting a large folio
could make progress or whether there is no backing space at all.

Keep the global free swap count and the remaining hierarchical memcg swap
margin as separate inputs. The memcg charge path reports only its own
margin; folio_alloc_swap() combines the two layers when classifying an
allocation failure.

Return -E2BIG for large folios when a smaller allocation might still fit,
-ENOSPC when no global swap space is available, and -ENOMEM when the
failure is not helped by splitting.

For early large-folio rejections, check global and memcg swap availability
instead of returning -E2BIG unconditionally. On a memcg charge failure,
swap slot allocation has already succeeded, so use the remaining memcg
margin to decide whether a smaller charge might fit.

This only refines folio_alloc_swap() return codes. The reclaim callers are
updated separately.

Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/swap.h | 16 ++++++++++++----
 mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
 mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
 3 files changed, 67 insertions(+), 13 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0544b2ec4c56..7d12058174ae 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
+static inline int mem_cgroup_try_charge_swap(struct folio *folio,
+					     long *swap_margin)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio);
+	return __mem_cgroup_try_charge_swap(folio, swap_margin);
 }
 
 extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
@@ -525,10 +526,12 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
+long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+static inline int mem_cgroup_try_charge_swap(struct folio *folio,
+					     long *swap_margin)
 {
 	return 0;
 }
@@ -538,6 +541,11 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
 {
 }
 
+static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	return PAGE_COUNTER_MAX;
+}
+
 static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 109c08be91cf..fb0ec439ba2d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5592,12 +5592,13 @@ int __init mem_cgroup_init(void)
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
+ * @swap_margin: remaining memcg swap margin if allocation or charge fails
  *
  * Try to charge @folio's memcg for the swap space at folio->swap.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio)
+int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
@@ -5616,6 +5617,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!folio_test_swapcache(folio)) {
+		*swap_margin = page_counter_margin(&memcg->swap);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
 		return 0;
@@ -5629,6 +5631,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		*swap_margin = page_counter_margin(counter);
 		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
@@ -5676,6 +5679,33 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return nr_swap_pages;
 }
 
+/**
+ * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
+ * @folio: folio whose memcg margin is queried
+ *
+ * Return: Remaining chargeable pages in the folio's memcg hierarchy.
+ */
+long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	long swap_margin = PAGE_COUNTER_MAX;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	if (mem_cgroup_disabled() || do_memsw_account())
+		return swap_margin;
+
+	objcg = folio_objcg(folio);
+	if (!objcg)
+		return swap_margin;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	swap_margin = page_counter_margin(&memcg->swap);
+	rcu_read_unlock();
+
+	return swap_margin;
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 70b90fa9c2a0..ae62c9f9c0f2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1735,23 +1735,28 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
  * swap cache.
  *
  * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
+ * Return: %0 on success, %-E2BIG if splitting the folio might allow swapout,
+ * %-ENOSPC if no global swap space is available, or %-ENOMEM if splitting
+ * would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	long swap_margin = PAGE_COUNTER_MAX;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
 	if (order) {
 		/*
-		 * Reject large allocation when THP_SWAP is disabled,
-		 * the caller should split the folio and try again.
+		 * Reject large allocation when THP_SWAP is disabled. Check below
+		 * whether splitting and retrying can make progress.
 		 */
-		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+		if (!IS_ENABLED(CONFIG_THP_SWAP)) {
+			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
+			goto failed;
+		}
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1759,7 +1764,8 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			swap_margin = mem_cgroup_get_folio_swap_margin(folio);
+			goto failed;
 		}
 	}
 
@@ -1775,13 +1781,23 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio, &swap_margin))) {
 		swap_cache_del_folio(folio);
+		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		goto failed;
 
 	return 0;
+
+failed:
+	if (get_nr_swap_pages() <= 0)
+		return -ENOSPC;
+	if (swap_margin <= 0)
+		return -ENOMEM;
+
+	return order ? -E2BIG : -ENOMEM;
 }
 
 /**
-- 
2.47.3


