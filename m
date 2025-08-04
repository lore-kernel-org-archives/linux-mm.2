Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD58C87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6876B00B9; Mon,  4 Aug 2025 11:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780F06B00BB; Mon,  4 Aug 2025 11:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6485F6B00BC; Mon,  4 Aug 2025 11:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 533026B00B9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:43:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0900E1406F6
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:42 +0000 (UTC)
X-FDA: 83739495084.13.942A77E
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1E669100005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m2xUWebT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NZgFoJUXPNA//k4ADBS9TTEW5aX/1wCjASugsvaEmo=;
	b=tQA+5pZDDXSXyJ0i7cHa7qGSFiWsgs5aI3GODSz0+vHk2xGES7B5sJCVPvRfFjAd3XOnaO
	HDgR6ejjnkz+Ae90xE7sXkakq7P8URIR1Vm6KZfdtRV+VnNrqC3chqUz7KK8kN5LSZUNru
	JZNq3sxbvCyM19jjPW3z3kgR014hEew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754322220; a=rsa-sha256;
	cv=none;
	b=mgjcEiXXfVaIGAZEOHJGijkx0ntN/qxNJm6y1hx2P0aawQI+H9vCnnd7y80unjYs/cjBjn
	fml4QBL96aWyCQB9GMgElA2wtzpwDLG3fpePLqZF+EbiKu55cmXBRCpQhaJShd8FtN6+dS
	YErQHnAfbxfi8eUiwSbd9NqUKucBUwE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m2xUWebT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e29616cc4fso415361385a.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754322219; x=1754927019; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NZgFoJUXPNA//k4ADBS9TTEW5aX/1wCjASugsvaEmo=;
        b=m2xUWebTCO4luMTKUClr4tMOYnPrkZHZ/Z7ceWc1kBwStSCwYbT7AJ70gSI8z80HA6
         8mLzql354UiqaUDZsOmQugfCekf7D1qv4HX+Jmqu/ARyi+AcYXWDDOGyX6mlxY+tLuM1
         2q0sPdDlJMsGj3uB9+j9aoitn4Ztye830a0L1S3L0H9RVm1V3Tm9fwUNNrfsDMsV2jIx
         X2cRVfjBATQ5yDfgpkyOYbnUFThy+yGi0Op84vxRdNGoWSh2eqQAjv5CEkE6Hw5w/lUM
         4a5YSHPGM4LAYzJollrNHOby4+/8Weq6aF5+OoVadgU4DTJmBJovbjqURNk0016IMUPg
         x4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322219; x=1754927019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NZgFoJUXPNA//k4ADBS9TTEW5aX/1wCjASugsvaEmo=;
        b=cQW0knErsUlBAvfv5F2pYmIKdERWayXJ5a4ME7nT2b18JXKGdk+Mjf4RcL4q8ai89w
         dSSzdF1VnX1BZc7ZuZgCBMVyC0kR3hHuC0WQVT5BowqnI51+XbYAC7fv9n6irzBiSKwe
         Gusz/TyDlPQQzX4clQxBtWBp8JjdqJpEbs5xWnNiQ6c8HS69ef0hhgfsU3fzW+hg3p6V
         5GTBUrRRQys2JVdUHG5KkLKqCOgEWzXqRx3E7RTC/PpYc2k8Ueg/92ITBsUpVew4jIIU
         F3Uf29/eutCWhy67MGFfF2oUUs+9KsyxoiOHbJ7uKVjijZlhn2s0NU8u8x+zE22fOP4G
         rbkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVv0t3BXrfZlHixhVdOTkhd2R+ODEtVcEDdz/i4d01te4rz+aD3790hnkosLf8lKAS0w3oimoy3g==@kvack.org
X-Gm-Message-State: AOJu0YwNKGPo+vqYJPKZA1ARBy96cBwCs01FJU7y+L+TPIF3K8BsNnqx
	H7+DoZPoJX7IyuO6rF3xML60Hi0yO2Va50DdERWHRykv/+SehmceOc7Z
X-Gm-Gg: ASbGnctIx/2WhIfOIZP1FegnHGy39GogPcDQ6PN9w7Vxu5IpHtt0+fwM28+F/517UAb
	1LQBqUmsnUt3UeE9SXXQ7iGGdkod00Ol+EDAcOA4TnmiVIhrKrbA/Wu5PFDtk4nAibzKYW32WCi
	PDzHoM0CacwcJRsVQICgoJJlyeXOA2w65qEKuwlmYUWfXjFZp248g4MhgrlgaG3s3AL5qJY22kr
	3RA4nd8JBiYk/WynZPx1awXQYl8C1ctx4XeKAFdx8wr+Wo/Spl/xtvp0xP+ApdK7MGkM563mndK
	lcn8ufya2S+oqL4Ls5JDuHSORcqOhSos9op1UOG4kUoEfhu2xxIX4MH2h/hVcbcGvn/HGsuJeGc
	uQ2eeXtuLDPwk/uL+e5Ex
X-Google-Smtp-Source: AGHT+IFDNYpRCIHZf+T+f30UCiejvaXxvvT7o+L2UYQBp4noTzl1Vr697v2ADXthSDYYKiAEbDj8Xw==
X-Received: by 2002:a05:620a:430e:b0:7e6:9a29:eb68 with SMTP id af79cd13be357-7e69a29ede6mr1059577185a.11.1754322218833;
        Mon, 04 Aug 2025 08:43:38 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:72::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e69a1e522esm277231485a.0.2025.08.04.08.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:43:38 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v3 2/6] mm/huge_memory: convert "tva_flags" to "enum tva_type"
Date: Mon,  4 Aug 2025 16:40:45 +0100
Message-ID: <20250804154317.1648084-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804154317.1648084-1-usamaarif642@gmail.com>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kmzfoq7fxwinoafu5o3krmozxgbo3oz1
X-Rspamd-Queue-Id: 1E669100005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754322219-163011
X-HE-Meta: U2FsdGVkX19sXbvLsNmMmOgLO/D85b3IzlOGR2vTnVIhyoU9TkF34EQt2SPRS+tz/JR4DCgqRWb+pvGBgY2G7eF1FYWTK6yJ/84kOhCLtKJBLQ7fByzLXpG7aVyvaPipYNwXeH9gwoPfO507XfVY19LVXEecHYK0uj6SX8sB2qHpy7pAxQOdSVF87T70XWkcmWenQ3aJ/yWVxmjPit3/FrM8lhxP9dupU86tWz6/p9AGgXT1hWAzCY31I9q6Z/XgfVx9cNz00HTedXK9yZcVSRxi+x94c9PnKMwKqOFBgp354Pix6E24eaPBWH5far23GVDJXuXLhacTyMOTHPW7Pu3C/Tr1J5WMjpnKNY0Oroqf6oDnncu3nfVuXpcOOKNwCMDrn9M+2xH+FVS5JrzXFjtF5SjPbgfzn+1ZKoxQTINzzU/dqJfNWwzqAPANtbx6gzs7In2ZM4IpcLV34WJb9eyFggUUmoKpeRALZ9xjs7kk9nkG66tiGHmY1qlONrOunxT/iBccoBp7BVpEaQI3SiRm627o3GLpRC2T742cuAdkb8h1aeDKtoX8fvkkZ3vZoCOR0cJ4NVZO5NFuMqWxuEs36NyMD72Hiqyx2EPoxAbp0WUC7nYvFWvbn4qTo3+7bbsoJiDG9vfMDUKB+T+G/hwQ2BF9IQIgZUXfL34fvIxregx3a6GCX0H0mA3RgBrY5MPxJFOh8RT43morUNPVQEQidrv/nbuB67QnWuNxmzcfs1QBf7sZ3bzhnKnyKq96qQm4LWm5Oo/PP8yzxtP833U64wJHXOLJetjfV/amWNlua6MufgjUwLaj/lc+44XeqZJqv105MCtu/XqvY/R6xK1vLxyES5o4NibYjuwMlQkn2SpIhNtT0GtEE+GbFARA5tFXaYckIfVfrgboS0EivbtSDcoGy7hcj2RJLU+F9RxiRKeRKLO9TRRBsTXGgko3YJtoTJ3ujjNJv5q3Anz
 deQ9o/ug
 Cqi8yWScbXy8X3LJQ86st8E3wdZqBe0EiabvzdFWkmgt/Ve0HVD0Y2GScNIGw/c0DA3fPF5osjxST5d/+sOS379mNK9lqYSPF4ubJBBFXBRt0CVHkvvtoL52QhpnVN+iUDgpHyD9QV/fGNnAwzb3vONs6FyPkqQXcy46D5fgvfeu5g2JLd/mEw246XP4ur8EQmM1sIa2IDC39WS8vyRKjzAfFjOH1OL82/5jKfxV0Qv1sSQMRFzb4MuWI0FLzQAtRKDqOXZ/1Di5TypKFbQY06YS+uWF5D3fqiQTZ1SLKtZnL70iGukPkOADnJoTO92LAgDwy0uHukm+hLMKUoGKTwzCGrtwshbvZ3ai3e5D/RVOPMUCnCeTfwI1j0/GjXC8Ax9Fi3jqHMqY/YDKJ77MwGhF1PrHFazjB0J17XqtxVGvoRKDQvwMrQiZiPNFHW5VQPveDqfRIbI/plWCwdcP8pWgnIelrf1i5i7g/632wypIgnpjLCF7Q+VBWGD43wP8ni77q4hNtBBvlps2RZsQQAs0g04barGanGlMoaOxGjPIG7QBT61Y+pBLk4Ej35ZqXVa7ZZstBFyI4BLqoB5xPhOsTdWEHyiP2aC9FOOQVUyvapzMI6Hxqsgqo4NZa5Ga7w+od0s3XCCikNHvkvQBEcsIF0jRamsITxUew
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

When determining which THP orders are eligible for a VMA mapping,
we have previously specified tva_flags, however it turns out it is
really not necessary to treat these as flags.

Rather, we distinguish between distinct modes.

The only case where we previously combined flags was with
TVA_ENFORCE_SYSFS, but we can avoid this by observing that this
is the default, except for MADV_COLLAPSE or an edge cases in
collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and
adding a mode specifically for this case - TVA_FORCED_COLLAPSE.

We have:
* smaps handling for showing "THPeligible"
* Pagefault handling
* khugepaged handling
* Forced collapse handling: primarily MADV_COLLAPSE, but also for
  an edge case in collapse_pte_mapped_thp()

Disregarding the edge cases, we only want to ignore sysfs settings only
when we are forcing a collapse through MADV_COLLAPSE, otherwise we
want to enforce it, hence this patch does the following flag to enum
conversions:

* TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
* TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
* TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
* 0                             -> TVA_FORCED_COLLAPSE

With this change, we immediately know if we are in the forced collapse
case, which will be valuable next.

Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 fs/proc/task_mmu.c      |  4 ++--
 include/linux/huge_mm.h | 30 ++++++++++++++++++------------
 mm/huge_memory.c        |  8 ++++----
 mm/khugepaged.c         | 17 ++++++++---------
 mm/memory.c             | 14 ++++++--------
 5 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3d6d8a9f13fc..d440df7b3d59 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1293,8 +1293,8 @@ static int show_smap(struct seq_file *m, void *v)
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %8u\n",
-		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
-			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
+		   !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMAPS,
+					      THP_ORDERS_ALL));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 71db243a002e..bd4f9e6327e0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -94,12 +94,15 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 #define THP_ORDERS_ALL	\
 	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
 
-#define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
-#define TVA_IN_PF		(1 << 1)	/* Page fault handler */
-#define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
+enum tva_type {
+	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
+	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
+	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
+};
 
-#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
-	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
+#define thp_vma_allowable_order(vma, vm_flags, type, order) \
+	(!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
 
 #define split_folio(f) split_folio_to_list(f, NULL)
 
@@ -264,14 +267,14 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
-					 unsigned long tva_flags,
+					 enum tva_type type,
 					 unsigned long orders);
 
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
  * @vm_flags: use these vm_flags instead of vma->vm_flags
- * @tva_flags: Which TVA flags to honour
+ * @type: TVA type
  * @orders: bitfield of all orders to consider
  *
  * Calculates the intersection of the requested hugepage orders and the allowed
@@ -285,11 +288,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 static inline
 unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 				       vm_flags_t vm_flags,
-				       unsigned long tva_flags,
+				       enum tva_type type,
 				       unsigned long orders)
 {
-	/* Optimization to check if required orders are enabled early. */
-	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
+	/*
+	 * Optimization to check if required orders are enabled early. Only
+	 * forced collapse ignores sysfs configs.
+	 */
+	if (type != TVA_FORCED_COLLAPSE && vma_is_anonymous(vma)) {
 		unsigned long mask = READ_ONCE(huge_anon_orders_always);
 
 		if (vm_flags & VM_HUGEPAGE)
@@ -303,7 +309,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
 }
 
 struct thpsize {
@@ -536,7 +542,7 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 					vm_flags_t vm_flags,
-					unsigned long tva_flags,
+					enum tva_type type,
 					unsigned long orders)
 {
 	return 0;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..85252b468f80 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -99,12 +99,12 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
-					 unsigned long tva_flags,
+					 enum tva_type type,
 					 unsigned long orders)
 {
-	bool smaps = tva_flags & TVA_SMAPS;
-	bool in_pf = tva_flags & TVA_IN_PF;
-	bool enforce_sysfs = tva_flags & TVA_ENFORCE_SYSFS;
+	const bool smaps = type == TVA_SMAPS;
+	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 
 	/* Check the intersection of requested and supported orders. */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2c9008246785..88cb6339e910 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -474,8 +474,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
-					    PMD_ORDER))
+		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -921,7 +920,8 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 				   struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
-	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
+	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
+				 TVA_FORCED_COLLAPSE;
 
 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1532,9 +1532,9 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * in the page cache with a single hugepage. If a mm were to fault-in
 	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
-	 * analogously elide sysfs THP settings here.
+	 * analogously elide sysfs THP settings here and force collapse.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2431,8 +2431,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2766,7 +2765,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
diff --git a/mm/memory.c b/mm/memory.c
index 92fd18a5d8d1..be761753f240 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4369,8 +4369,8 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
 					  vmf->address, orders);
@@ -4917,8 +4917,8 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
 	if (!orders)
@@ -6108,8 +6108,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -6143,8 +6142,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
-- 
2.47.3


