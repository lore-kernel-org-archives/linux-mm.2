Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F7EC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08836B0093; Thu, 30 Jul 2026 08:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0266B0095; Thu, 30 Jul 2026 08:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5F56B0096; Thu, 30 Jul 2026 08:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82BBA6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:23:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BE198011F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:23:52 +0000 (UTC)
X-FDA: 85045359504.15.BE3E68C
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 484391A000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:23:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dlj9NoIU;
	spf=pass (imf19.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785414230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
	b=Wsj+zzV1FyxDORAWUCPDC1tZHjaLKToGPlFGLYzELYSGbJkuBrQHBHbTXRCKVN5jfHKdHk
	rXXw8FKCssTsCWJcvXC3YeDSXY0X4th7BST505myY6R+UVlyNbCDEFuSWPpc2UUWpbb4LU
	3u1NXjGk9YQtL2NJqSlrvBv2Q0uQlBs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dlj9NoIU;
	spf=pass (imf19.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785414230;
	b=jy8V8b4+Yngg/5J5qxoJuvErFPyvHG4m14Cfn8fKm4ATbgUkRzX2zaulkCb94HsW2ciKE0
	XXn5X5nQlLTvAbMJ5ROT8Utsq3aqALWvC9J/w/zLcB1vn0EMwMiFnu8wkxI/Yb81SIXKgU
	86jAVpmtGvtEQLiaFr1lc2uPETojaTw=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c96d7933910so239900a12.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414229; x=1786019029; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
        b=dlj9NoIUnmMLdtkqwNgJrw5r+xtY/UPwd4DzC8BCvJ134cZPj9JXkdfOrRRqxDR2aj
         B7ykMoDrloaEJZyl3K/gTuv07bmGiJySSYphTP0my1vVVjfpo7l+bNqFSDcZ62LVhf9+
         /r2IfXCtFd+LEBjjPN1b0eRZwkAP2SIzbTyD11QRFxvjwpNjOhN/8N5G8Uj9mnzKfeJm
         Qjf+nR4jCuhOzUfLdnkKzvBB5FlYwlh1Ibw8/dujalxmd620VKt7HeZmrhxgOAxnistF
         15VmDFw5V+Yk4n0RS6yyWTksJHMNYEhmiZvc/Wn5EEctnys90SjikIfx4nk9lOii4M3/
         80jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414229; x=1786019029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=32qTViblj4WdG3yffSuiPSX88DSQgp+MB+zeQ6Jntjc=;
        b=ef4yo9ikyVeWMskf5QYMONzV7HmKaH5pdQnRmA9UgySQvpfr2ZdrEUsuntipFKzq3Z
         i4YVDANDyqd+eMZpHMMUz88XXa5GUCU7D/Sw2/wVoTun4g71+Vl6k5m/xBg5coUp1QRc
         EOjb84VbVeKaT3cPnnLOyNS9yj16hH75fX6zma/vuyT+G2u/i0i16ASLsu5YeFybL1St
         ZN0HzvdLX7Guob2oycn8pJ3R6PJqjmf8PuvDsp7rHZQaVaC13ZKM+y3q5iagJOrgvAEQ
         jjJxHeSzve4mZpY09B/ZV0hIyRj7rS+X+Cc/MEpsfuKKTmjBgk/kndIiTYCUSy4TYk7j
         u4yA==
X-Forwarded-Encrypted: i=1; AHgh+Rrsj6f0Fg3lUFXp4n2yFkXtQcuPB4JZ//wVx9C6VE2b1mzwBbbk8P1EMU6g3Wf94MtaYb6CXDVusw==@kvack.org
X-Gm-Message-State: AOJu0YwWFrV3z7D+dLBF055xVguVX8o4Tc1woeiUBhz9P4e56AJ2u29d
	slecNToXzCBO1J30YdQ6u5CzJI7fRM03vZIdtH071V90WnBrM26+PB3n
X-Gm-Gg: AR+sD12iSXE7+HoHLUkXkZ6IEX3CJyFoSlWzHI8Uy5BFzuTimTOLOSYyfgh+bzz735V
	YcZjYAgyM5Iz81m/suu0oEOV4blMskrxJQQeXpCKXk6gzkqmxFMJYIzLIo1Ug4kPKoE94dO9RUX
	k80ui4vS7kzzkD+aNOk7QubScYfpsiFlrdmkoPe4Bf3vyxIcCUq4WQm8rwvLm4O1OekbIE5g13E
	1MrBY2smDrKtdtgIzW3OYV6SjqapBwPGg/4xm+GHh8VFzfyWscLyJ0NRM6W6cuMANL0Pp8dC1iM
	l8IHKziCkTLGD33A9H9QWZtAufi9lYo9jIJyuB2futlgESf2xABL37ZaQHgfjn+O0JX4d59zg/D
	GK2XFZhzspZhq0afVAtBY2v6NF2QQkNdHXJuFSrD8djyOnLNsWexqxtfA1G5HURXHcjdl+GFOFs
	694BlqeeZmoLo/EVPZE+xHeUVMC5PXtlTS77vjb61v2MRcMwshRXs8AJ5dVxRYPzByI1uSDWfOm
	30VsEJ0b04PmvOBHBwe3Y8luY7Zb/VL6TSkBGMM7Lm62Pp8rhoP
X-Received: by 2002:a17:90b:4c52:b0:38e:c140:2a0b with SMTP id 98e67ed59e1d1-38f9beb5127mr2980493a91.3.1785414229126;
        Thu, 30 Jul 2026 05:23:49 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:23:48 -0700 (PDT)
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
	weixugc@google.com
Subject: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 30 Jul 2026 20:23:02 +0800
Message-ID: <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 484391A000B
X-Rspamd-Server: rspam01
X-Stat-Signature: cwakrj9xagpi5mn11mca4j6ajb71p4h6
X-HE-Tag: 1785414230-6386
X-HE-Meta: U2FsdGVkX19NTbXveE1PqyaCpO22wMcy0VpqC0CjvwaE2KuA+b3FEUlG5epr6/mKfG89xc1Oq0wYj5+Szyziw0Hemgai8it/WQCea7G4sWULGkT1GgdtUJDThml2zV9tcg2ymoqpbPGW3A+25W7hHkKqZyThaNeJH42lsNM7ryXk4ZJM0sUft8ub/hz3U7vLj1BPyhVgZQOZrdmY5hwFBJDC9pdGB8i7tKrUb6PZqq0LqHqY8dbgitYActjHidqJPFxjNltRwI4cGSd/KnmC8xIjnZigfXJYDLT8sBSb5GleC8Z/RKLitk7UXMjo5PnM2KadRHDljH/vDlBQ3mWCvwNlUtqLHYBYs/M7/Mzb59U1knh08k0fQ5EXuHnrDuHlDjee0Uv+fwWLwxaSxoxNw/DGi60zXZGcNj0RNcMf6zhdONVjPjsfenP8ptPgamWbI3CMDujq+p6pOa87mAkVMV/zOMZPonVdAB0TrXt/2VB2Qc0vclrbk4meBQP/OU9/VOfTH4An/GTGFgaaKVox9WYbJi69fOU1WN2SOF/cDGrd/S2BTkMP7vHgYcO/0mdrNRu4zQOL0y970Blr/GLZvRzi3owamaPjdkRPGrhM/3lLZg7kIcTUtvoL+aDGLS3/WG3j99AIsO96Ix4EdMXGCgcE0h7QEFLxfdlvkP+Rdyyidv5/0kVr56s2uKomS7bKC3F6LJMBBBDy7pJ/4BeVMLxhNG/B7k/zWAD//G/O4lsrYXdJ581iYLafxnO0CnqwnKMjmTBmbx7eEXTwRiDm5ANIzJd+MBIq1paiDMkW9eObxutZys+qXxy+IMWnp9jJE1ww8HydifcR3nBNgTdwMxNERnJe0px8eWLZRmimeULkFze+auP5R+7Z9sGbNqfSpLUX8GRMlzTvN45lGqNDeSsfGVxmBiBMU6byrOVPkwgzu+Lm/aFmPgRnqA8NJW/pkZiArhnfy1vAsN7OU5G
 AYpGlpY2
 7GNlTsqUjDJq3bgt2v1IA9pBu4srxcvarib7dYNH+Nfyz9QgDCSFKk9EmJw3kFvjabXdaOhxcVboRcJu494RNsiBuSJ53YE7cZqyZ4rwhftbRVymCNu8xHFfBKDhogr+MEJ3+WAiIwyASt/cDpvBUC3XSbW+WDiGmptfQETmUO8D1ywPMeIdUN3ddC/ykVzsgKoQm40f0w0SDGIFrWjdibKTx45uF7t7hbGQiZH7RXSFXnAL0uIwcTyKGBQW1eWnkdixn+jjLm69cSKX9//NxjhIjU4H+R6HoDxFMZKKsUHySrbNVT97AxfMCa04v6U1yjBGnXiPvEaKkpjLMTOF1gMTdb3nDs5eYGyldGGinwlhbPv2YzgQclKgO/LduInEwyz2YECdB1BCeJZGG4v0F6VPgOMQLy8Wkl+SuaGuy+IFiby6YIByXaeX2FpwCN08QM8bAZCMiiSsvMWcat8sp0N+aZp6sV81nLS5okquZTSLE0pmhDGeIYnxFCA==
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


