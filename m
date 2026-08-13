Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A2BFC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7654E6B01F8; Thu, 13 Aug 2026 03:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7436E6B01F9; Thu, 13 Aug 2026 03:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B706B01FA; Thu, 13 Aug 2026 03:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9A46B01F8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FD9B120572
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:52 +0000 (UTC)
X-FDA: 85095474744.29.AEDCC09
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 602551C0008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lfto0VWs;
	spf=pass (imf20.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786607450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
	b=shB+teZdZ0+etw0a4gWnJnyQWFgbJskXUlJT5Y8kjsrxAWEl4biLyqEXkFEnqEc8r4Pw0v
	VQ9E/Bzdlw4COZpF3aTPC4qTTwVc1BgjyQY9OzhlB8hcnxAt9aNTOb8uBopyeTSqioVwY0
	8ZOr9zW26OlW+CaHmceJicbzaJ0V1+g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lfto0VWs;
	spf=pass (imf20.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786607450;
	b=sW+La3NsALf4lfdBX5jVjPli2WSmUKNWOMgKv9yy/EWjXYg8CdOSEtC8Vm7ZzBndlycB72
	5DfC8rjcU6joB3AdqkFWWU/APb8/89NnQQnO5JmnaQ83vQi6q6e0rUcc9j4ZiWqEBtMxdM
	E34qws1coGk605esSJ72HoLmGzrWVEI=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cf4c37dbe6so3276155ad.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607449; x=1787212249; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
        b=lfto0VWsteDNO6KVQ0W0Vys49Se9YoSocurPT28AuLCUpmrqwBl23pKnCvgk4Z5SFj
         rNdMilKvicB8aOFDVsD0JvbIMJBggsLnkHiACypLokm4F87sFB8kXrQYC6d3dYtQYyFr
         bgqubs8UvfJ+rNc7sBaKU/wbYDHi9qtCzMSVKytL3z09okjAesM2ELbNnwnwmbVPj84S
         XkPPbMZ8LohAM10MF72ptv4FMZS2NbuYe4+GsvsTU28+1YdgaHDHxnwOpLM5cC9erd4D
         HCedk0KZz0RUOxml10bMyFIJjhXfhsKN9/05Aekadysp6jDDWAwxfpsc3+HS9yML35js
         ar8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607449; x=1787212249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
        b=pVoeF4vp6/GZaqAl/7LHriI1cOXWBT09h8Fen0KIQOaOMoUMO5qVVdz9DIIiu5+mMH
         JSCGuCf1v5R2i1s++VuwkfaW8Q429i1SRBxWGZebCc/8co4RL46QFFT9VOGM2Lg3gOJ+
         MOUT4LQK1Qw9bFhwrUx3AiYkG/HNyKpFYSDb3kHdEggX74sKLp6ONjC1mdhq6MgcF38r
         wGb2e2KxwLKZo2csiunN0a0z6ulBYZu+/T1F+36j6Ye9TzTOLsewYeI0ec4tcA0zaA4Q
         ZjkGEXSRVjgxkqffjbWsC1QzCWgxHwimAMB88X3dKqBHEkNpZT2M3h8phk1tqeARJkm/
         lKSg==
X-Forwarded-Encrypted: i=1; AHgh+RqJ9ooNVlf85m1dVNGmFoSw2mkC/jM8/tJHv2zB0/QslyU/oA1rn3IkGNRp96v6BywpcuP0Widp4g==@kvack.org
X-Gm-Message-State: AOJu0Yz4wXP/XujCvulZMl3eqWmYT/uaRDiY4CGN+7MACBYpHdFF6JEb
	AQOsjAs1uHGzOeKmRe7+bcEKVK4JXF8S6hYzvP29yfW1diRl/4nSx35n
X-Gm-Gg: AR+sD10lNtHWP0AUy/4vhXCUEq3mmJKEG4YcfSQtdDkvzfiP7CYKQcDXZep9DFLJ4dd
	qGoq9VvDvjBBWY7lPoVyakc28mSxUmxfxxoPp5fa+WL1FWPwpej1iTBVwcsvb8zqy/xqQQE2CZv
	4uZd0Hl6/5BByX3ScDWKtKZjAFppe8dvIREwj1/WEL0eFX6pObtoVpeAhldyQsUYDRBSdZXXV0V
	XLP6Qc9NVR9eQn4CxYc7MfoiULG/2wYAMXIIKdzmx4pLNkfObcf6OY24sua0Qg7VnKNvhpTKEZe
	lfySivgsy9Gc8HkM5VpiYmUwp/pYgpLY+hFo+WKd/9BOxfyPQwAeJoYCStIuVkegsdobeMHSQWI
	/an7udezB6C9V3w6pPCVaRe7ZLjQXVGmtGpWpLHVYrWJlTQtW1Aj2/GTu7gzDD432ypYsxbX/Co
	AhOzQIqip+uW+HcCZxPDaibeRiCyljEbyCsAogQQZnS9VVKnICVaje+Uc/+EatIxL+gfhax6hW+
	RCZRgNUcE9teZh/+gUvSd2cAY1PZ1Jp3n2to7kWc1gSSS7v5X0D/kv7u84hu87xcTwveShY7Qg3
	acW66tlrcYedrbxv
X-Received: by 2002:a17:903:4688:b0:2cc:d6de:d58e with SMTP id d9443c01a7336-2d37f237867mr34765455ad.4.1786607449116;
        Thu, 13 Aug 2026 00:50:49 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:50:48 -0700 (PDT)
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
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 13 Aug 2026 15:50:23 +0800
Message-ID: <20260813075025.1406585-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 602551C0008
X-Stat-Signature: kg4bo5q33715z739hh4c3x8s1k7fxnde
X-Rspam-User: 
X-HE-Tag: 1786607450-741193
X-HE-Meta: U2FsdGVkX1+NElb7/8fjZKmfcA2KReNwUy8b0CmFVRpoORjjTIY7Kjy23AiOtwpLYubgduXcCQou+xzrnUesr5B+0p9Y90Vw6Z7e7Niyn/PF8xaNSpRR8FW/HfBr6U7FsZyW826N52gv3N2b6ssvZfBRfIIZLkLYG9ZE99kgCMRjAh5MbtaOD01IQYNN9LJYToVZBqYOuqFrSXb9ef164JDf5jU8dcgoRMY7klhj4INzvc4zsVxJyikrLblbhTCDc5FKoHvJzj7MitOmvhlPekffinrMZ6oes9KSzmNc85UUcSU1f6oYotIl26oR66E0Do24B628RQRXWqBTLvDsBWx/dRRSyEAODruxNYaaCxCp5DrJXcXButUGk2DxdRmLSaXobwVg0BTiEFp67hPjxtNl3hFiLkgtsHg6SWwnNmGvSDdro2bI7UPduG2tNyiM+XVUP65ERsbo9gLWYpop7T8vrzI3LoDufJf52YZYAQz9UD7Nm4uW1AGQ4tJWCkcRCOOaXB+8XxbTLP7KNPhePxZlXPDdgg/r+Y2wrz4rMjtlB83DlgLnMHY9B29V1dpgfIzux/4g38aXDqeC/sZSuby5bB+So69rLu3XguflklSF1QS2/Ts5aUWkGUyZ6NwoWDVP8Z7Q5G0NC3JoAHrDfoPebU0c5BOe/0fnuQ8gH7tLgb1wQZe51ngySnZFfhLbjQeJKkCkcxr0Djs11dJmIKoQgqf+bLgTXCEGwTWvr0aNUsupqnixZ0fuhw/H6AaCcmADyWBk92eiH5otwbpXWolDt6Y+6JSSotO8m7VgWC3jU0Y6EjQs4qlQd3z/pWlRG08043wKXgvWc7mMrr3qjN5N2NBgJdwNsHqXLje91w3raghHoDNI5V95jpbAGtJ+Ts0iGYpJLtf3aUJtH9jBJ2bu3FzxoXNrL0pNxyG/ZnXe5uj4evi/Fyi5A09rhaqXDrvANqQqrtWTwydAmaa
 +lX2zTqk
 8P4VMKdmoRDrRjNUHW/IsWhWkr3WVWvsrpMfLMOrXhecURviu2EgaTFv0hMJxzISbzg2cw9F4d4RwMFMSROXdZTpsPvyf682/8QrV7wW6iMHNwRyqxjywLjYqriRaLO0oytkBS5lyD64jLxMLWmZCscyFa9OgVej5fewWYefJDN2k6zlrT1JbqISiMmWcYfoDBWb9AbPB0c6Vlo3OMlnwK6Xclu8cOc5OYRPglEDzDpew11a/BYG5l4DwoFzuA+XmTObfxC6ScB3qPbHOrGd5p+TO9HqtM+DbrsokqtBIkXWjl2RPnNKObiyy2m+rlixVxp7/OJaxqD3LmnC7V1JoHbt/QzczB4B8U6AngQPp2TkAvqzExz5ISO1VMKxcsTVyc0R2+JpXtBe6eb0f2MuLSg9c98+umdGBntHapNel3rK0C4tmATOiK+naxGIoNj7VXVPgJDJS+qntFYVFwe0sainkHtqc6WeyUbxc5WIRhipcjCYxsmLw16F2Ic3P71+58EmE7jK9vTwOM8S+2JPsUIrXQ3YLyO14zwxF
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


