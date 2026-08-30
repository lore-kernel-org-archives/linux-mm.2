Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BAB3C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418816B00AB; Sun, 30 Aug 2026 00:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0596B00AC; Sun, 30 Aug 2026 00:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DEEF6B00AD; Sun, 30 Aug 2026 00:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08FAF6B00AB
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:29:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E643C024E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:42 +0000 (UTC)
X-FDA: 85156657404.06.9F2950C
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id B12BDC0002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E7pv+2pI;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788064180;
	b=oqeQCR8uhbpXZUrTwZVFf61FVzfRYHOnZxOcod6RbthSFceGESTlz2uQKCHcSN10lJbv+s
	+tD9ms0S4Wmt+feCcnGhSGdIAjed5Gxi5UYJUY6kc6mosb5mrrruTpH/YH705t4IBifA44
	lnrKs8va26NL1AsaiIs+hrJxsMUWhB8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E7pv+2pI;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788064180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
	b=0Yez6Gl8pqHyJxMhUo0JtH+jL1e4+Xf9zghEMR8TQUyclql8SeEU/TUD8tCyc83JJmkVzx
	rUYydv/1Iw/M9017cijhltIGop7OIs3jc+UQVMCVtMdC94xwmI4NtwrRhB6/LEGC/u2bZl
	YCOQmX4PGbYQy4jkTQ6eAxexCPKL2YA=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cf110997efso2911145ad.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064179; x=1788668979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
        b=E7pv+2pIC94BO20PL7lTg5WbIssI+Kw1G/OC69GAGAkWPjpGde86Esi47HVI9eGarQ
         6a1OiETNLo+K+eCevHdvK5yncQBCwdL9SWjRkFKOj+d0yDQJ+LdrYh56XIHYA/4NaRf1
         p+SOsjpWcPTISTw1JGdKquk7juEWEIaM4UBFGFa9lBO69/tQhc6RWJavHNiszuVU5Z6p
         fdzBYUqP/UVusfBZh383iD58f3DkasunyBWALBZBko08kdRPMDgnaKtAG9fobNqyPIKW
         /llit/SmbDFIhXV7v9iM5tUMqm5fSzC4jK1XbOqDP2KZ1cnbNt6zwq3acOkDPsy2GMNd
         OlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064179; x=1788668979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
        b=pTUkVG1Kjemft4jwL+aHAD7ca932ddM15emEOLTrePVsHObbfAq9IKubZ8SZOIlKLm
         W+LdELqjPwzdpuKUDdHCYbw8+zrGh6NEjGWByGjpcrfwytTY6CS078/YDdEVE2L3yBC7
         1zA9sWCj9sZOMwS4ytPWlja50IagEq6Cv6aK6XXcbkFJ8keq8Y6IfwwGAHnm63J3CL21
         xOHqYZ2VpAiRzuUMdAlD4bllxKqNB8NWfMwLcO1evvsRcqBoeE7Ua7HVLozvXalQw1Dd
         4gpy8dOHsnL5RSKyQgaEYc+jaX5qBlJkfUqkQnmHGvqStISOge7fYwZuERla+M+qs1Hr
         BQWw==
X-Forwarded-Encrypted: i=1; AKwUvBxMic8xradb7U9D8LbLTOn3uhp83QMwYPt4xXquz15p8anGIYEY+8JS+uofVkfNL6wmdS+Dj/QbUQ==@kvack.org
X-Gm-Message-State: AFuF++m+chJOb8kVdyTpSow9sGoKlCs3LPf+2kIyxe+OVwwLckDuWubp
	b5S5CvwtVNzbQ81YlyphRtgGw6zmk7P2BMZjIzYDTZaLGG47Td2qc9si
X-Gm-Gg: AYBFou0/f/yrYRW8aEFPyLue05b3mFgwqz8ZeXgf0OHbw9k4w9vwOGIBeSSiKfQCxE7
	ZtIfXQAjl0PX/P09ihT33wa4W6jmhPwpv2bON++a/OMsOB2mQ4hG8qCb5Srl4qgi3+9FfBHOE/b
	dwGUDU1GcLGpExoT5LbJprsYkdCV3Z1xy9CvjyXH5arTntah3aIK7qsE87AI5ZbEz93JMhGZgx1
	EmG/iUKFObu/9xAqXyy+1b4K1/nvuFfV9RXhaVEqxlWvAEdetKnIQ9zdQ7cIXUL88KFtHTLpuff
	/uKz5d9LWSKxsMN4cK1EYUSJEzIXdZTbV2ZUvh+b7FfBVf9X0atR6yCJzPV+kRjc+Kj45uiRhAe
	XQaQSS1dqLGWZWepBm43yd6lU+6cKCvmisEDoEa8/1q+my+J33vqusOBEJDkkxDDE1TOPnmqWAy
	WUcqkZ0V7RSEW4vf7Yv+hfMcmjqIDHcqqsvwW0X9UwWDKR9XMX32AjkGx8v/Py68ajxcziKuLQk
	pQxXQ63n9dQ4s+t9g9l91ajlYY8+sGgtKg+KpXRQicKpKz81Cw=
X-Received: by 2002:a17:902:ec82:b0:2d2:a952:2628 with SMTP id d9443c01a7336-2d74def63efmr160857695ad.2.1788064179371;
        Sat, 29 Aug 2026 21:29:39 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:39 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 2/4] mm: distinguish large folio swap allocation failures
Date: Sun, 30 Aug 2026 12:29:18 +0800
Message-ID: <20260830042920.2280454-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B12BDC0002
X-Stat-Signature: cjs6y8iztrk371x6bak5djcpisf3ad9u
X-HE-Tag: 1788064180-259195
X-HE-Meta: U2FsdGVkX1/ve+6j7gL5iLzLC4dC8w+y2CTv1RojW9KH64KpJFwfW/dyCxtQuKvlU8TjpR/dzI+jkTD0qBJ6AMI0IFxEE2a9+9hnSmLUQiskNsHb5HZpPPMxLcO9rEzy5abcNNQfypL78va4iqVcyE/caGu1ebzv02oIlCfEizFklzlM2NBsAWU4zao6RqNujdWp9LjPctmYIJjB3pHyEpkldJFG19QSycUzuEUhDQmdI2LzLEkwSrsM7E8p6awLRpRLbs6mUgPMW3d+1QcSSPPOuPyfQPEcQBVm68Zd9kM3roAs05B9pgLuenVl2JUHdR+TIM/AxKS6tPE4DJfot17ikv0sw5a+YMaaGSyGj0hW7j5sa3HjIBzU72ikDmMu7sJ6EVqDrFy32hWt/saCTA7tHgFIEs4ApvdZ6loOMqm4wu4Hs2lfK3Ch1mXKgfjvwjOKGVp8XZtdYrvMar9YdvzY9XllZDAQzZ52fv0fjgbmDEbZw4jUnqlwC43uJQOwm5PZOdb1rrXCIQRFAb2i5tH8Xau/TZoeGOlX05OOgSlaXi4zyPC4so8fZmvpA7+lA1Bhb5yWiSGfMo6prNwJtl5wc65VP79bV8U59k+peyXB6gJ3tMZqQWEUA+Mnq5Yt2hT3q9Qp87zAXV3Me3v5Md8FZ1U7b1Ax7JzMEsCQ8Mkikt66Qx3FWcc2qDcJFjLJaOPjVFjp48dDtm/HMWeMJeIYgFJOxZjwQHVFnA5K+Ttnvaox2ii0Lv9uzakblIqXqAG7b59+rkDl1TadrJsfrH8vUq/pX9mpcwDnnforLcq7vWMuuXK4L93/mu4jNpeB25isJzlTPRD0lgQRjtn1+eb08qdn6vKbfi8KhHEzGg9lWvvwdon5TrxG32BQOfcgZa3wrBigKXQHbFt9k1MFLJtJTrxzgOx8cP1A3PFx0wMRoOPiQk8waX0OTx7KwWmyZCo45JxEC0vO/kGR+aE
 ECWbAvqx
 bhAQn5PBQUS+4j+5y/+0sBtePpH71RCKBeOmiJFgaHN1niLLQBqyni3tjx1kX+k70YCMyrRxQWKeLcZhXJY36V/YUh4FPkwGwkqlYfZueTlz/axG8OCQtayoAMSB5efymyUxb242m8oX326hzj6HNM8OeEkHdmRt6FnlBM3XiujAh4qgKGH2V2vdqgHh4DS4C7AjnGb30IfuHIvfbH6287i5GiwVdys3aD77saXgIfO0MgTtO+6n2q4aXrnO2ZnieHE3Mx0Njy1/C3VjzaR+XYI0tveg4q0HNPuYCH7D1dd2UbiOymKhVVi2PGM372WFic9k52/bgua4qTmphqNv9x1uyryv/S76DqUj4VDx3WBPEt+8DsNdtEVMd17xdo2fJHaT7BjJoabaz7EeASfoaNtacvUnHqWV20O88CrMHVmhkZDcabHjxYJNZb8sCsDHAubIdnZ5Cq/ad2DQV8OEAjFmyaV/R02A7+85L+eyJSXdSr/KjNB8aWIgEnIzCbvZxE/3em7MpkwizEGAc0VpxB9lyx4KcQhMacfDv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_alloc_swap() reports most failures with generic negative error
codes. Reclaim callers consequently cannot tell whether splitting a large
folio could make progress, or whether no swap space is available for even
a single page.

Classify failures using both the global free swap count and the remaining
capacity in the folio's memcg swap hierarchy. Return -ENOSPC when global
swap space is exhausted, -ENOMEM when splitting cannot overcome the
failure, and -E2BIG for a large folio when allocating or charging a
smaller folio might still succeed.

Use this classification for all folio_alloc_swap() failure paths,
including capability rejection, swap slot allocation failure, and memcg
swap charge failure. Callers are updated separately to split large folios
only on -E2BIG.

Suggested-by: Kairui Song <ryncsn@gmail.com>
Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/swap.h |  6 ++++++
 mm/memcontrol.c      | 23 +++++++++++++++++++++++
 mm/swapfile.c        | 26 +++++++++++++++++++-------
 3 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0544b2ec4c56..b23108d992aa 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -525,6 +525,7 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
+long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
@@ -538,6 +539,11 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
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
index 109c08be91cf..4b42f3fc6075 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5676,6 +5676,29 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
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
+	struct mem_cgroup *memcg;
+	long margin;
+
+	if (mem_cgroup_disabled() || do_memsw_account() ||
+	    !folio_memcg_charged(folio))
+		return PAGE_COUNTER_MAX;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	margin = page_counter_margin(&memcg->swap);
+	rcu_read_unlock();
+
+	return margin;
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 70b90fa9c2a0..651682b1fe63 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1735,7 +1735,9 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
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
@@ -1747,11 +1749,11 @@ int folio_alloc_swap(struct folio *folio)
 
 	if (order) {
 		/*
-		 * Reject large allocation when THP_SWAP is disabled,
-		 * the caller should split the folio and try again.
+		 * Reject large allocation when THP_SWAP is disabled. Check below
+		 * whether splitting and retrying can make progress.
 		 */
 		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+			goto failed;
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1759,7 +1761,7 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			goto failed;
 		}
 	}
 
@@ -1775,13 +1777,23 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
 		swap_cache_del_folio(folio);
+		goto failed;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		goto failed;
 
 	return 0;
+
+failed:
+	if (get_nr_swap_pages() <= 0)
+		return -ENOSPC;
+	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
+		return -ENOMEM;
+
+	return order ? -E2BIG : -ENOMEM;
 }
 
 /**
-- 
2.47.3


