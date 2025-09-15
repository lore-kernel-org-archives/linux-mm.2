Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2369CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63DE8E0015; Mon, 15 Sep 2025 15:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9E08E0010; Mon, 15 Sep 2025 15:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00458E0015; Mon, 15 Sep 2025 15:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EFDB8E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 694C013BA04
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:30 +0000 (UTC)
X-FDA: 83892531660.04.5C1F1F5
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9BD4B180012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RYWR7bPi;
	spf=pass (imf24.hostedemail.com: domain of 3e27IaAQKCMYr7pxs00sxq.o0yxuz69-yyw7mow.03s@flex--fvdl.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3e27IaAQKCMYr7pxs00sxq.o0yxuz69-yyw7mow.03s@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8sdVCwgpzgSZpEZdIa2RxiH6JcLxFU2dfzzWpV7l6M=;
	b=ay9sHUyQBSEh3RLYnlB41EapO2ZLkyOu5FvA8m9nKwSfsnhfbz6VAUjdeksrIf0bPknD5t
	xu4HLad/vhVKqeZjRG+R5M3F9qIqAtymruu/kC8fNWzdZsN0PERDCWURJnl7ebZjidbQv1
	uYiNtUDyNa84p6F04XkjlA6q8vWhc4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965948; a=rsa-sha256;
	cv=none;
	b=NpRVgV5VKn/gKJaMpN0s3guTdsBhRDGjoj4+4hzYdEiZ1d7oDeqS1w+SVaLvuGektUtUts
	cOaimOELOiylFqz0wun7KN1/CYWc1FT1SUXhn+tiJrkpJUeE+Qf31SIdnvdguE4sxdk2OX
	wu6cGnDTaLR7bgtKTGRhHvbi6R2gMNs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RYWR7bPi;
	spf=pass (imf24.hostedemail.com: domain of 3e27IaAQKCMYr7pxs00sxq.o0yxuz69-yyw7mow.03s@flex--fvdl.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3e27IaAQKCMYr7pxs00sxq.o0yxuz69-yyw7mow.03s@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7779219ccc2so1609073b3a.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965947; x=1758570747; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8sdVCwgpzgSZpEZdIa2RxiH6JcLxFU2dfzzWpV7l6M=;
        b=RYWR7bPiapCTPVdUGv/lSO4lwvoS+ex/Mo0QYmZJyg4i8FG6oN7If6p+2/HmO79Vm4
         ntB6F7U41Q6AIyQlo2Qwu6G8AKvcsY8wup/RaOjK3qZjg+Y3Fe0YEAJDNIF34eN7ebQ9
         LQMbJEASh1KC+J++X+ekqPlx4lFZIHllNswKcfk5jTdv12kY/iIbbCLlOq6W8uAZNEQN
         vLvljZkViclEhfaMLdhTIwO3wf+hjAzZbO42O3v9w7wlnk96s6qeYO2rjsJuGfMNgVRP
         TUa4swowFpMLGi8GsGals0j5AfnPTYucAlf8BV2a9gnPOs3LRNPpP7K1KID0+azabrU9
         SVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965947; x=1758570747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8sdVCwgpzgSZpEZdIa2RxiH6JcLxFU2dfzzWpV7l6M=;
        b=xGVsOE3DQOqsniZG/+MXqi99wNcMKSxC01oVvGm7DMTcOjF+PC8KRH9/zPEGIq/O36
         3rMvXygMKFY+IkKtbaqcNARjK4SIsk+rFlqyIrd4hBW4JWCa5sFodOwxasnReBA/5PnS
         Licb4id5rnS3sWOSUqLjP7PBqQZixK6UnAUkIlyjCkJFoLMbJbQ8LcxM/tRFY3ZOMPvR
         HXCAyUmcvds5mN/s3zS6PaXlY8g7amKxGTc90jmhtXwxkFdZQN6mVOg/Ueb6PKAY/CSK
         Mpwrvn3dkR+/0VVkOYaJlOy1kJfYL1cp22MzsIUgRvs6e6oByFK9gziBHdT9A3TfAd1s
         mOgw==
X-Forwarded-Encrypted: i=1; AJvYcCWj2Z4e63FvVD9JalhvrK0xk/KXOMifUDpOmAQ7dSJFtGmWPer5cZKrKyZBmoc3HpXe4FBS/MlFVw==@kvack.org
X-Gm-Message-State: AOJu0Yx9boT7kcuKn6PTuGTHKBaPzjqefbiETdvrRzzkNK1AoyeurBIh
	0rz94xUr2lv9xaZ2Jor8opfDobs7tbUQ2i3GNOJiYQwO1iKgUtdT8m2Yg8xj/XhO/PBCXLuQyA=
	=
X-Google-Smtp-Source: AGHT+IHSrj8b6/0anPmsTtmAtpPpKBamD1vvncwaV7EMPgRBfcfV+2TtFZIJ4M8kZJb/oeTBgqjLyGgI
X-Received: from pfaq4.prod.google.com ([2002:a05:6a00:a884:b0:772:32b1:58f9])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:17a1:b0:772:8694:1d71
 with SMTP id d2e1a72fcca58-77611f99ea8mr14148444b3a.0.1757965947238; Mon, 15
 Sep 2025 12:52:27 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:47 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-7-fvdl@google.com>
Subject: [RFC PATCH 06/12] mm/cma: define and act on CMA_BALANCE flag
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9BD4B180012
X-Stat-Signature: u6h86ya9gyghih7go9ucm7oztrmg6pnj
X-Rspam-User: 
X-HE-Tag: 1757965948-374537
X-HE-Meta: U2FsdGVkX19nszZuZuViSadVBH6cobXWrdfSv9gxPgeoy+dBm/kTdRHZWGdd9CcIRawd1qXC2mhJhvf6FSRucJpTY9TkwtN1RifzsgtIMEv+J2Rnbpu7Z0Os6OAkADnJlgv50LlGvGD7NvFlnF4tdCY6AmZoPepxAeJ2yhvNvA4T91F7UkcLJkBpW/FqOT7h0P+rtgY9A9kMwx+S2RvqMIl+2cKR12ZT6LNYYB7NMph1cyGWJy7ys5ilCVWTeOf/EXCbfBkXf7Am5BWtBsjxIUm1t2n3w7BO6goVAvZgevNl7zy2Bv+amepzt6gRcLaLbG8QyHJAfyuNNZr5glJbM9vajpdvYwlvBmY+iyeAmeLsgBfatKDe2EFVp4vlkZrqZVrxPg2wABUlfCLR3mDTh//hUaZnpPm2P156yOm50zcbQRH+v9mKlKaI32fz1pOXKSCu0I+apC6+XA3o2QfdKO2XnA4jiMZ18d5w/5oSlngGTROEV4bMbSa1quJqU1MJJYj1Gd9JuO9K3nN9p7ZJY9z+n0jI0giZBKkw23DiG3fPhwT+t9tk+FGQrJi/nGHiy2kDpQbkVBTzUXptaQJwHfEVCOHXbkgOngWE69yhEPE8VZrqsSyfuKZRdc22dXM+jQwuuCQcT/96d8B8Ess4IkkL6eDkXPfAwYvaeu/S8VPy6iGMG2SPRW2RAEQHEolJy6zZ/mR40cGsFsTFHW+tMHKFhMr04ZQkPYClxkSXC5OPf9Dg2dmLWy7qLSvekuYYdJRDImmuIPush4lcHAUjB8I6CVr9oY8BxOzcwz9Cbyf3KEWmkSZKtnvVtzyom1ERCszvwJbM+sj510Z3ya9m53d49DF+G6uT8a8FpPRsYBzmet76Aza4uXNMRYFuHG2YtwGTUHzpgR2VjK7YqhJzzASqLwhcANyvPKWuKfJw7BHK+rhdeaAPj/vg2KkWEJOzv9wvp6siZuZ55pXqXbl
 Qipuw6Sr
 wbxUeN8rLydxyf4lyeeBTEIAbxxZtZm9sFsO6k7cOhW6E++AIDgQzBePYFeO4JSuZQyRa9BjDjkblmqVVWI3e4QfqDfkG+LMl5IbnM+oGl5k6ByPIsmITpDdS3iAODGsI0WaToWHgW7LpVpbw8/md5eHvwOuI4mW2TxtxiAI8Rm0YvyGH3OoV71611fGgTC0vV89/LKH3n0eM8VzzGr+b8X/bg5YhbN3RixkVZCH+EfR0GGHa2FBWLyQopvDuFMWuvhuC6c7oh0QMaidvQ6Ev3XkaCdhW2UH4EnWumiCfm8gwwXtAlyQv4aFuTDdel7Qgl5uz4zaMhWaOn+UPlcOqP3E6SM9YQejXy0zUkj4GgPbrVi9h5oppW4V7zLofwn0vAXO6aovloXUxnl27ljNPIRhVORtKZj/aKIwceRw0pZcpM8P3gbzPA6pYkGl9Zs71f4lN+5FSaB8v+1W0cJsL80xbxNqmvhJz5TyyBD6tCO3cp8QP1gtjtOPoouvjws7zn9lnztd6flpwMWR6Ma5s3KJVPJlOmcHJX30SlKrQ+IBJMPXTqpTIHunvnm+pB8xLhjx+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the CMA_BALANCE flag is set for a CMA area, it means that
it opts in to CMA balancing. This means two things:

1) It allows movable allocations to be migrated in to it in
   the case of a CMA inbalance (too much free memory in CMA
   pageblocks as compared to other pageblocks).
2) It is allocated top-down, so that compaction will end up
   migrating pages in to it. Doing this will make sure that
   compaction doesn't aggrevate a CMA imbalance, and that it
   won't fight with CMA balance migration from non-CMA to
   CMA.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 include/linux/cma.h |  4 +++-
 mm/cma.c            | 33 ++++++++++++++++++++++++++-------
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 0504580d61d0..6e98a516b336 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -26,6 +26,7 @@ enum cma_flags {
 	__CMA_ZONES_INVALID,
 	__CMA_ACTIVATED,
 	__CMA_FIXED,
+	__CMA_BALANCE,
 };
 
 #define CMA_RESERVE_PAGES_ON_ERROR	BIT(__CMA_RESERVE_PAGES_ON_ERROR)
@@ -33,8 +34,9 @@ enum cma_flags {
 #define CMA_ZONES_INVALID		BIT(__CMA_ZONES_INVALID)
 #define CMA_ACTIVATED			BIT(__CMA_ACTIVATED)
 #define CMA_FIXED			BIT(__CMA_FIXED)
+#define CMA_BALANCE			BIT(__CMA_BALANCE)
 
-#define CMA_INIT_FLAGS (CMA_FIXED|CMA_RESERVE_PAGES_ON_ERROR)
+#define CMA_INIT_FLAGS (CMA_FIXED|CMA_RESERVE_PAGES_ON_ERROR|CMA_BALANCE)
 
 struct cma;
 struct zone;
diff --git a/mm/cma.c b/mm/cma.c
index 53cb1833407b..6050d57f3c2e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -272,6 +272,9 @@ static bool cma_next_free_range(struct cma_memrange *cmr,
 static inline bool cma_should_balance_range(struct zone *zone,
 				      struct cma_memrange *cmr)
 {
+	if (!(cmr->cma->flags & CMA_BALANCE))
+		return false;
+
 	if (page_zone(pfn_to_page(cmr->base_pfn)) != zone)
 		return false;
 
@@ -527,6 +530,12 @@ static bool __init basecmp(struct cma_init_memrange *mlp,
 	return mlp->base < mrp->base;
 }
 
+static bool __init revbasecmp(struct cma_init_memrange *mlp,
+			   struct cma_init_memrange *mrp)
+{
+	return mlp->base > mrp->base;
+}
+
 /*
  * Helper function to create sorted lists.
  */
@@ -575,7 +584,8 @@ static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
 }
 
 static phys_addr_t __init cma_alloc_mem(phys_addr_t base, phys_addr_t size,
-			phys_addr_t align, phys_addr_t limit, int nid)
+			phys_addr_t align, phys_addr_t limit, int nid,
+			unsigned long flags)
 {
 	phys_addr_t addr = 0;
 
@@ -588,7 +598,8 @@ static phys_addr_t __init cma_alloc_mem(phys_addr_t base, phys_addr_t size,
 	 * like DMA/DMA32.
 	 */
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
-	if (!memblock_bottom_up() && limit >= SZ_4G + size) {
+	if (!(flags & CMA_BALANCE) && !memblock_bottom_up()
+			&& limit >= SZ_4G + size) {
 		memblock_set_bottom_up(true);
 		addr = memblock_alloc_range_nid(size, align, SZ_4G, limit,
 						nid, true);
@@ -695,7 +706,7 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 		if (ret)
 			return ret;
 	} else {
-		base = cma_alloc_mem(base, size, alignment, limit, nid);
+		base = cma_alloc_mem(base, size, alignment, limit, nid, flags);
 		if (!base)
 			return -ENOMEM;
 
@@ -851,7 +862,10 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 	list_for_each_safe(mp, next, &ranges) {
 		mlp = list_entry(mp, struct cma_init_memrange, list);
 		list_del(mp);
-		list_insert_sorted(&final_ranges, mlp, basecmp);
+		if (flags & CMA_BALANCE)
+			list_insert_sorted(&final_ranges, mlp, revbasecmp);
+		else
+			list_insert_sorted(&final_ranges, mlp, basecmp);
 		sizesum += mlp->size;
 		if (sizesum >= total_size)
 			break;
@@ -866,7 +880,12 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 	list_for_each(mp, &final_ranges) {
 		mlp = list_entry(mp, struct cma_init_memrange, list);
 		size = min(sizeleft, mlp->size);
-		if (memblock_reserve(mlp->base, size)) {
+		if (flags & CMA_BALANCE)
+			start = (mlp->base + mlp->size - size);
+		else
+			start = mlp->base;
+
+		if (memblock_reserve(start, size)) {
 			/*
 			 * Unexpected error. Could go on to
 			 * the next one, but just abort to
@@ -877,9 +896,9 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 		}
 
 		pr_debug("created region %d: %016llx - %016llx\n",
-		    nr, (u64)mlp->base, (u64)mlp->base + size);
+		    nr, (u64)start, (u64)start + size);
 		cmrp = &cma->ranges[nr++];
-		cmrp->base_pfn = PHYS_PFN(mlp->base);
+		cmrp->base_pfn = PHYS_PFN(start);
 		cmrp->early_pfn = cmrp->base_pfn;
 		cmrp->count = size >> PAGE_SHIFT;
 		cmrp->cma = cma;
-- 
2.51.0.384.g4c02a37b29-goog


