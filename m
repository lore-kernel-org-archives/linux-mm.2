Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893D7CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 18:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99BA8E000F; Thu, 23 Oct 2025 14:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E716E8E0007; Thu, 23 Oct 2025 14:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE618E000F; Thu, 23 Oct 2025 14:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB70E8E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:01:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77A10493E4
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:01:56 +0000 (UTC)
X-FDA: 84030147432.06.960DC74
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A5B818001D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:01:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="V/y/M0rr";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761242514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eI+vLZZ7p1Mhi0cj4jqewiN+BVL4Z8G4YkFeSbfUXkI=;
	b=OcWhp7/bIHIJsXuvewznhinFhOe1l2O81CvIw4/zB+Hxp/jeooJsTC00uhncD+N4XHsqkX
	de1acUlsEhRTfgyiq0P+XvqOyi6L1lYDr3Lky+9PCsaNV8P25yMICKlU7yRB9zikHaUooW
	5ckAU6Wd3vY0O4Gu86dycRefjljZqio=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="V/y/M0rr";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761242514; a=rsa-sha256;
	cv=none;
	b=JLsvpumWRtgjauEusT9OCNQ/hzzyiOlK1cGSNux0ACrkPTnqym+HWJf6+bpn4Ahj3saOyu
	EDfYVWDVXRMr1rtJWkAEH4dZG2k8X5ODB1Oh2otjeZqtkgoj6Yx97OX3ssKgAm7TJN8VwV
	7gpCMlJnw6BZwNN8rOBJSOEdyD0n+rg=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7a26dab3a97so698542b3a.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761242513; x=1761847313; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eI+vLZZ7p1Mhi0cj4jqewiN+BVL4Z8G4YkFeSbfUXkI=;
        b=V/y/M0rrGawaKZDv+ee+WbRrNVfbWhMThuoQ+xjesVhoeVtmm9+OMG0ln8srHsDFsZ
         C/sd3a7V3ty/4A1cgr6ESHGAofSWJflnakJml8RjTtmKI0MG8WNK4VPNfTF7UEhQkHDt
         clvd/dygjwrThlg2EJLD4kNKppoQeLaq4j+JeyXVJ3plCWVHcSWNrQDRI41t7cKZi/Fw
         S8FIbayUupI/7w+g56p8Lec3y6EsD/BKP+Rbut7AVr53WObzAcEkET0nTF/lGtG9yG4e
         NdAnQNLRjJY9EPOZWoiJUo+kDBc5beg8jP2VV6qTGgsN7P3kSIuj+PxmBVwVlIdVFThF
         dchA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761242513; x=1761847313;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eI+vLZZ7p1Mhi0cj4jqewiN+BVL4Z8G4YkFeSbfUXkI=;
        b=q3Yx/s4y9IfIZ+wjZMwRbC/UdtjwHoCXg4ofisbvkdyRiOvukIWleXujMuX7AP3Av3
         efHogtQYvXOSXAhpHmV/wik/hPT1mUdsC/J7vxP6ktkcokcs1/b8+KQ62hR8FBP1k9Kh
         l5zXFIMWFi+DeK88eZAViRn8Rusa7OBf/bEu6yr/V6qnYUwmonby1sqqsMTarYyyswoH
         e6Y4j5+dhVGVFnvYNP3iDAQ78iR7Nm73nf+vwPPUyxiu0bsfFaY0vJ5qOCnbSoWD/ICx
         B4qeD0dL5/SFeOX3UKHiR0WbLV6qwsl13v9/UpkeD/XEn9RXu6bEOcJZsmxyhJG16EMK
         gEmg==
X-Gm-Message-State: AOJu0Yxyq/8IKUKKcHty8bTxL9KWrv+tDe++CZzBT+V+wHXVTVCeaiXn
	VkImZuKnqE9y2u8jgElt0ZMf5+OpJSpgD5h+G7deWFv4IOQms5wtOXzj
X-Gm-Gg: ASbGncuUeqTzFyYotV7Rqkqh/W9qYH5pxhB+RkZElBoZ1O6k15Q2I/LUegAwD6zXfAu
	2zKr9flec/E2VyWQw4v2iWa6joYxqIdqmhRNcMvSAdnJFsz5xyjFXN7vueioNcQ2IA4j83/X2Yz
	kGN/vu3KRUULVN6mx+Xzn35kS6TjZMUCz0lB+/rBmwOWoWA6SIiaOiXuvKdFdVwFE7jx1HqLJR9
	miOBkBbb41M+eVUrraszEukUOmkcPuCOnNRLZm0bV6mXzaG9xCZIVwYQXAKjfsrM/CxpB746ymm
	VQT2ye7rIhzaqkrMLkaNRV5qhdl1zBjbkr93kPXU31yejzUM0kxa5LZ+3ShfiQxbjF08/4GdnGV
	QhSfaN65YbPDeLQ90Bfme64ofgbbMFx9qfcLPaMXyoew+CFrG9E9n9sRvxQmJenpromDihRWPOE
	dpLDTkk+Y4UsmbLxDd
X-Google-Smtp-Source: AGHT+IGqJoEGKAy5pdzGQ5vfTGlTGC7Sf8azj/HmAmQ3MLhHYPNq0Q7D6d0vzIUbYHy0GQuzOlsiqQ==
X-Received: by 2002:a05:6a20:918f:b0:334:97dd:c5b4 with SMTP id adf61e73a8af0-334a856e67amr36168280637.27.1761242513080;
        Thu, 23 Oct 2025 11:01:53 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4c4d83dsm2734532a12.18.2025.10.23.11.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:01:52 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Oct 2025 02:00:41 +0800
Subject: [PATCH v2 3/5] mm, swap: cleanup swap entry allocation parameter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251024-swap-clean-after-swap-table-p1-v2-3-a709469052e7@tencent.com>
References: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
In-Reply-To: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 YoungJun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Stat-Signature: bfihcyqb3dtasgz4f6df58mjne34yobk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8A5B818001D
X-HE-Tag: 1761242514-696281
X-HE-Meta: U2FsdGVkX18jzzfZCwFZLEy8csuAqlyVrbVf0B+ffWRJwcjEfWH7+WFVO1hKPrn1929FCDqNt+rW98Oi18JxXMZJKKJovekG9kvfYvpzyvDihfY6MPQlmFe2E5Wod1iy9Wm9HXsnDd7/tH7hDOw8xB8+Dk6HHwbugcLrKjCJ+DKetN50JFwoeYuEcJS+QEZZuJAqwypqeB8GKeRfsn5gOKFhp3J/EGt6svaHN4CUcb8VISHef99ROTb8YXgqlj/To0pQ4yhpLLef1XOmkRHFoe6UKQJtqIsLTbo5UVSzmMAjrbk/mi3yh4VlhLeMdn9If4rpgACEbiVbc9CA/0hZxeEG1Y2BVNeTQzR5Nb2mhTC8UH2V7PQzRZraDmD89kM3gmBgmSDOuN2G/OuipfY1U3KBeKllpfpNRjZeyUBJ/9dv3htGJgfvDy4k73CP/8RGklqimlj9lW02/YL5IFqyrmXxV+XuBGU5ShIoRwgk+Eh3R+zKvpwTZek/NmSDG4+J+8V/fMdHgtFFVQaDjlZswtMGI8WrjUs7MOJZHFDBB7j3oPY1XklHek81YzUCELiRumrcsnPv+XqPU2K9Dz6wywWtmKHhj/yFtX2HKmxthJeKVy8kdy7ivh0L6drMHW2teSMnKHvd6ABrTElqU0z3YwP+/iNBvAyYiqg4t2q8yhtLD/1BXXrZWnH3CjePzJXZKLyZSbJRkG53icumLmESMWCqHExSNovldZHXDEkrc1E/1rqXZ/zF938ySnkK/Y+y23TYM6VCkZrq+wl2AkZgz9PSdB5gkAqvmzIW9O9y66QNppDXbUPuOXwizEJ9Xabw4MgfomsiuLBVptDD903F0lXWUfZ0z581Envpuixd2FFGcBx/ouOmMn9drvrNGCAT20vzd0y0/CSwqrFHRXjJ54IP4j7QQfVWQWqpqkjvDFB9UmvChiqLl6udxFDj9dbviI7r5Q0z0uKIgsmlncP
 tYYm7MH5
 83HsZaJhvk6NvL63P2aSej0UIPyupst2rbnqjHdwUpJIRAlY5VrXYYXoxQJbhXQbu1DbJHq7x3/Z4R+K4iDe5ChgFbJ7XpsbgIsLE064QZttedoAIMCK16mRiy1ufJM2lhZrtt9bFgnZtx4RSyNRrPm+j2qdXhbV0Yl3TovF9A9p1mUnDhkJNZIIJd3IQxrN+N/UlPsyU+BC/Ke3Q+TyMJF1yBiOU/l/zakWs8PXtHa/pzFgSpMx2L11WWn2YPNkExQJAndh4azCVS85f39nyM3/N14TkyneJfXAnw/45yCaPDtW3rAnnyqUrV79cw9a5rSBlYez4WTerDWNuYgwSsmAoP+YH9PKxsxvIh3ti83cOJKwuu0wjEbTmRiyQs/OMUrQEk91lvSA4iG776/6cDguyCqzFnKr5KrIkHGEXMdIHpf9aAKpwusGihpQzphK+OML5pJYtsU1r1lUXpSf4dCuFdtVOaDUL4XyFNvf9p3vnwVXfe+h0Txocgty9bLwvu+an3OfKMeJKrAbJajb9+UgdUdoRlWBr/PJZOv2H+rAgC4jqt3U7CleSXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

We no longer need this GFP parameter after commit 8578e0c00dcf ("mm, swap:
use the swap table for the swap cache and switch API"). Before that
commit the GFP parameter is already almost identical for all callers, so
nothing changed by that commit. Swap table just moved the GFP to lower
layer and make it more defined and changes depend on atomic or sleep
allocation.

Now this parameter is no longer used, just remove it. No behavior
change.

Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 4 ++--
 mm/shmem.c           | 2 +-
 mm/swapfile.c        | 3 +--
 mm/vmscan.c          | 4 ++--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index e818fbade1e2..a4b264817735 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -462,7 +462,7 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
-int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask);
+int folio_alloc_swap(struct folio *folio);
 bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -560,7 +560,7 @@ static inline int swp_swapcount(swp_entry_t entry)
 	return 0;
 }
 
-static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
+static inline int folio_alloc_swap(struct folio *folio)
 {
 	return -EINVAL;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 10682328d54c..7559773ebb30 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1617,7 +1617,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+	if (!folio_alloc_swap(folio)) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 781a70dfcff1..42e2b2759240 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1417,7 +1417,6 @@ static bool swap_sync_discard(void)
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
- * @gfp: gfp mask for shadow nodes
  *
  * Allocate swap space for the folio and add the folio to the
  * swap cache.
@@ -1425,7 +1424,7 @@ static bool swap_sync_discard(void)
  * Context: Caller needs to hold the folio lock.
  * Return: Whether the folio was added to the swap cache.
  */
-int folio_alloc_swap(struct folio *folio, gfp_t gfp)
+int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 92f4ca99b73c..c922bad2b8fd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1296,7 +1296,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					    split_folio_to_list(folio, folio_list))
 						goto activate_locked;
 				}
-				if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN)) {
+				if (folio_alloc_swap(folio)) {
 					int __maybe_unused order = folio_order(folio);
 
 					if (!folio_test_large(folio))
@@ -1312,7 +1312,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					}
 #endif
 					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
-					if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN))
+					if (folio_alloc_swap(folio))
 						goto activate_locked_split;
 				}
 				/*

-- 
2.51.0


