Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD6CC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65516B009D; Fri, 25 Jul 2025 12:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16B66B009E; Fri, 25 Jul 2025 12:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE146B009F; Fri, 25 Jul 2025 12:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984256B009E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:23:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C103BBBD6
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:06 +0000 (UTC)
X-FDA: 83703306372.12.AD08D11
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A3CA140010
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YS5WfRs6;
	spf=pass (imf26.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/IVGkkPzURjGDJrhaXlQLfLTJbo3ezBGdfSaquSXrc=;
	b=DunKvQmvF1w0G/+X9tE8R5YL/OMsW5kEsqHOb6yyXz4DGBwKZcrmNwe9Mi5zEjyVP4p3mS
	j0U7T0LxHpXSxvZwA+7zaCiImek0REV/D7vuGj56SckzlI3s3QJiosOx7zX4G30EJkSdnw
	j0W2RxNLBOgQFx6mXQSK+xfXUTMNwgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460584; a=rsa-sha256;
	cv=none;
	b=ys8uBYYrRtU4vj9dmFIv/ICptbsdd2aa/R9MkYdg0Ne33mnaSn1WzJCOTWuTcTJEyOwGgH
	4HcJZqHS0DmZQNlg99J7edmILK0nU8l+7AD9Y/bWLNhuwPEtGX36xum9NmQ5GVBdphvg8+
	Ks9QuquLtd66jwGFmXgM2qCPLKJ6s0Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YS5WfRs6;
	spf=pass (imf26.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7e6399d0656so91960485a.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753460583; x=1754065383; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/IVGkkPzURjGDJrhaXlQLfLTJbo3ezBGdfSaquSXrc=;
        b=YS5WfRs6Kn02OUWGIOWbstUJn6nMWsRoZZJPtPlMMQgZvjckTVZ1hP5tOGNn/RMAdG
         4y7FibiVw6J+Fa+4BNNbnIRNL8aq+ijXAaEffcchzzGkGWlz1ON+Ve8aTOflvIl5+a2K
         Dv1N7lLutHpZCFijYLZKZBFASGW09fgnBq45GBrbdCdSUp+WnVzIh6u236vnftaYf/fX
         D1j02JrnFQ8DVzLhLD513X2MEjM1W7HoXwHqhxRt8azNQ/rPVnp4/9Mi7XQOKbS3FPuF
         jxgjjLqzEJexpb9vGw+JqBRsPHmocqjQrBkwbarFY2gOTbn151y19E8Bjh5rSSqM3zpB
         bD9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460583; x=1754065383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J/IVGkkPzURjGDJrhaXlQLfLTJbo3ezBGdfSaquSXrc=;
        b=DDFTpbrLTMw5udUPO7r14Dfnel92z9E5VXMsazTka5Ow/P3FXai/uUXN+iPvw8B3pD
         jVfHzf1lFoq2govJaQPJMPtl1PYkqUGtV/ZCNeXe6Yka8rszr35bzlMybyQjUMXveV03
         XrBQMeuctCOT1w+GCuseta4b6F09LfCDDTmzUzg2INLhoguaw5rFCIV6kmrAl+v2ITBW
         jYhBmPHGb8WYGOJik5tFUcUkXdwW4dR6EQFgMw4a7hVs1J4+hILgPugFuyV12rENihuz
         Kdo0/OsZ3T6G0Mq11iTtFBadTSF9daxwu5ni0tX6z8LdqMm+ibsDsSUU8IwqW/jehgzr
         1A0w==
X-Forwarded-Encrypted: i=1; AJvYcCUh/IHDr4NxvbmofYz8PUNrZC2kne0zKq9DGBlptc3pPF2Gsg5W5klTu76ShHF9Et5UFruRcApoDQ==@kvack.org
X-Gm-Message-State: AOJu0YzmfvQEVepiB8ovehF5HziuON5+yYNJj//4uM6uAouWG0pQP9Zh
	FXRWWjXc6Wd3p4moFfcw1Pp4oZCtk7meW1h/BmeBHNoDDJdG6gweUdn+
X-Gm-Gg: ASbGnctCwdmdz2Q1148zLW6JwHfTHMOVtzQJk/bTlzs61Ocw73qx5eaWHkqiD0P6vFF
	Umw4wXuLFN4p7cniI/7KQ3nK33t7OpSnS6tdbRyWfdcdLl6SKvKf8Y6MLLHcEH6Q1a1ajfGuSRC
	Z0A3nsw+4CWi3bVYhYkLfNR044GDuFPrlqjQrOrVA+3erAD9UjtILvXfwD8fvbw/TNPS8oVdC4L
	BbUz5pmcTkUCGLdzMwh725j5wSpM0vqr7dg6azUj9zM2S3V6xpZI15l286whhfTXp1G0RChMT9a
	Z9CpT5Q6yndfP+bICrvUvT43nYkXuVZvtMXXNz7E88uA0qdki/nHBIK/yoaTRm2yJr8I5zH8qGt
	5wDTyMDz7pJ7lzFvkehVw
X-Google-Smtp-Source: AGHT+IEgZsEiqpagnFsk8v4FDxK/dzmgVDM7YABO2TNliYM29fPVCH0Cz5kX2NK91wCLVnYNwD6yuQ==
X-Received: by 2002:a05:620a:a005:b0:7e3:3e32:e620 with SMTP id af79cd13be357-7e63c1be3demr198759185a.36.1753460583243;
        Fri, 25 Jul 2025 09:23:03 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:74::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e6438a891dsm13036485a.92.2025.07.25.09.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:23:02 -0700 (PDT)
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
Subject: [PATCH 2/5] mm/huge_memory: convert "tva_flags" to "enum tva_type" for thp_vma_allowable_order*()
Date: Fri, 25 Jul 2025 17:22:41 +0100
Message-ID: <20250725162258.1043176-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250725162258.1043176-1-usamaarif642@gmail.com>
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A3CA140010
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: sfm36zummsiw6d1njm59uuuhaeks9ppg
X-HE-Tag: 1753460584-223860
X-HE-Meta: U2FsdGVkX1+UTZ2r7Jm6y+i8nG9iZW0yhAogu1AhpApSIrQNgtzarmLbCy7P2SG2SrOk801FEbySYhxY2dxHf45wIlRHdTaChib7wBJF/z8K2zAxDzR/HwSJhMrm1YfGnsUH3keF89e67W8Hm6B/4VyNcSPFc4FSyJTFsqpdUivrfQz0MZAVH/ueIQDWEvBN3bsfK0pHv7V4dMW2ArIKYZAAVI2Qwn0vOiP8XyiTvttNAC3S6n4yJWFu/nwQF4xX3ZbhwUZlkievZK9MDCi3oQHFG2RJ+MYCIPw7RE7Ovdov7FUo7pD6v68+vuprwm93vK3FaQ0bdvjdwFd8H8yJljaRMzhIyTCCr7fkSf3wDhEDYOYNGiF8PR0PbB4tnFG+5QFL12uXRAiuvT7znLUOVg7Xn/JyY1OlN/qVRsPu8+sptdC+dHZbJYyHyCm1Hkbtv9rn4LbOTzg9Z+ouCVOyk1IjqUjpGRZPprM+Mw7pthoy7Wv9CdqXdnD7n0kwiwmNPCZRMhTMk2aPi0dmZvkUeiMFnfFQcWC3TUqrlFppbQFPJr+icWmSjcK1/vCjjD1HrorBEdfHWautQxBxKP5Ooflu+mz924VUgLOcHfGagTJ0M6Sh9tW0sdRx8g28efEhAmHcj2YVgkS02xpoB92mHnOXQTk0QDL2msAyoALv9OZO3U4TD8uRfkDSZg1hecUIhwgrOHuec6CfF8Iv7dKiCMOpBxNzasXKsENX0hQ9Oq8oiBKMdKP+GCJBHgnRQJMnL7hogeZX1tU1KzAXO9Wqwn1O4eyvPSHvQmjLBb8VQtUFGdxVI27wMkQlNYhoouEPUnxZEN1yns8+aEoPI25SfmAvXOBzEdoCKG8Jxa/zYgUnZ+QPHjkv0vlWFTTgiZjfBDbF3zZWMF0JB/jZmPhN4s0nhqT0STo/G40RYPC/NM3WhjxAdcyZbfi1EvvYJ7c97GUzCYfof5PObJ4X/yB
 l40Z1/kb
 SUasZTuN1TbhGYxbg4ndCeXTNTzR7KPk5FX6xxl2LNlkg0sn6uk2oeW3HwMVOHQe9+6Y8tHMKxz6gEkhvh8/eeOW/c//U8Ahzudf8aTGYS6xYLDRRO+W7vzM3cVQS41lESFVzv1KeMsqVlWQjuO38OGY1YlhKe8mj64uYU9pQvjYi78tc5R5TN31+pHaspfa8aS6DTr3CH3QMj4uSzKcLCh4jbW9augox8YxkvFc9Q8wkgKSh2dkbWfbNUQeKmeTbNW6F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Describing the context through a type is much clearer, and good enough
for our case.

We have:
* smaps handling for showing "THPeligible"
* Pagefault handling
* khugepaged handling
* Forced collapse handling: primarily MADV_COLLAPSE, but one other odd case

Really, we want to ignore sysfs only when we are forcing a collapse
through MADV_COLLAPSE, otherwise we want to enforce.

With this change, we immediately know if we are in the forced collapse
case, which will be valuable next.

Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
---
 fs/proc/task_mmu.c      |  4 ++--
 include/linux/huge_mm.h | 30 ++++++++++++++++++------------
 mm/huge_memory.c        |  8 ++++----
 mm/khugepaged.c         | 18 +++++++++---------
 mm/memory.c             | 14 ++++++--------
 5 files changed, 39 insertions(+), 35 deletions(-)

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
index 71db243a002e..b0ff54eee81c 100644
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
+	TVA_FORCED_COLLAPSE,	/* Forced collapse (i.e., MADV_COLLAPSE). */
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
index 2c9008246785..7a54b6f2a346 100644
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
+	enum tva_type tva_type = cc->is_khugepaged ? TVA_KHUGEPAGED :
+				 TVA_FORCED_COLLAPSE;
 
 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1532,9 +1532,10 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * in the page cache with a single hugepage. If a mm were to fault-in
 	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
-	 * analogously elide sysfs THP settings here.
+	 * analogously elide sysfs THP settings here and pretend we are
+	 * collapsing.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2431,8 +2432,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2766,7 +2766,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


