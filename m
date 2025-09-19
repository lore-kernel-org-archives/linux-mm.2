Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3A3CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4474028003F; Fri, 19 Sep 2025 03:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4D38E0022; Fri, 19 Sep 2025 03:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298E328003F; Fri, 19 Sep 2025 03:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 159B88E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:13:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD3D51605B7
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:13:00 +0000 (UTC)
X-FDA: 83905132920.08.82A161C
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 018DD10000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:12:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XYyrDlkC;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758265979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ye7V9uiu5zciR6aLOcCdf78aEW64HlV5Hia0QO7vhS8=;
	b=TWy79q2ScD2mT0Ap1/aa85FMhmJUKFEHXy1gr1+YW8uXBQGUo2oLCfBeC23bepUd58wC/l
	4mw8trjDrAx9Y3pDvPJRiyjUuWC2o3aXKAcRGqcDw9e4bchzNen4GOKaND3h62AZcx+L4L
	TyydTXHVeCQjXxpKyex6qBy1/vcKO+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758265979; a=rsa-sha256;
	cv=none;
	b=ngPwlpa5KDK/orLQAeeY79+bsQagArxbGl9GndwYXInl2JH31AyzfLOXGTZumOPhgLnFq3
	YHXq0/KwCXjE8iJ6tRgP07Oczd7VnVFTa/KqbAbdSBLkUm9W0fxqOi3Y6KtsnPtNzQB/m0
	poJTHjNW1hkDrHCDXaCStSPLySpwCsY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XYyrDlkC;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62f2b27a751so3230766a12.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758265977; x=1758870777; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ye7V9uiu5zciR6aLOcCdf78aEW64HlV5Hia0QO7vhS8=;
        b=XYyrDlkC5fWzxY/uszum9xX6pVJxSIM/9Y4fpwd1igZz7r8pKLn1iSwilSz/KKrD53
         ON0KvmB0XlECxf3vGVcVYu+FdpZjghbO4afxDogeyRPGsxYbG4l/VmmVrJF7t+9CsJcr
         JB/J/RAS15pFxEq/CIZFvDc+OzPHlxYRHsT6iU4vZJ6nNnZ8A7PPCB52gzLZgOc9FhDL
         q3NMUS5CaTx1xUgmkRgTmiE26WzIFeIt+sC3RxaqiHcM9y3afBXQtBMkOODwCU+BGoRT
         FdvLnrS3Ups3CCGYycdb2nWnOA4w+wjouZA9yL83LP0oD17VtZ5sxGg8QmHW8IbvKtnM
         io+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758265977; x=1758870777;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ye7V9uiu5zciR6aLOcCdf78aEW64HlV5Hia0QO7vhS8=;
        b=U+bNws9CRhiiQ8yeaS1A1iZxrJ8QEY5risp8Fd4JGRy/IO0BytW7/2KpPxpvwEK/nn
         dSst6Mdx1Tnv/bOb+O4HwJMGCqn7RKPRa7AHdE5FNwxQEfMP9wLjg5YaUdgmKK4hSuiq
         wC2OoGx+lk6XKJx97XwgF4PqmLYLTBL/HdRhKdZ9jI+cWR82lmoSgsy+815itvaDVRGZ
         oYh1gRLeIGzek4f6KFxCsbTpTO+5X8ta3e7W7RFbr+Llrg+GjqUHgHXmsJI9kMbJd91C
         L+MdKo+bFOv/NhiNdC00RbBh2iKQ1AZF4qBRsU6FD6OlIIOrzbLd6Jdk48Ckw/Qf4rdj
         3e4g==
X-Gm-Message-State: AOJu0YxaQGfMLoVWG1ntrIzUVfmiYxclTWAlmOGgKTi2SNPkf2U/7HWo
	hY5+EJz/nsEFjD2cMMhk1RIapKVXt8LG13VJys4pQHsm7d7g03aCK/aB
X-Gm-Gg: ASbGncsuLmeyg3mUMqtsGBsrKK+HxkBmE93ukvMctkntkN3WSul7az5u/zgKzCiJBc+
	SrpU9LZUO/X9kgTt1hXQrCIgmq8XixatFOXdA4kohIS+ee+G9ifYwV8bKHkPPp5mfTql24aAJnB
	Iq11xXT2N6pFhutnTnE3hBNCgOjT6mt1XzANGWgBICh/GUv5Jfm2HNY6uT1bX2ARYRZ7MT/yWNf
	Y3CeR6i8TARiDRPIP0vAdeSoabkAMqa1aBiFBJyUMnA6q4sxelTK/MRgOfeW5e0VTL5XI4pR6mw
	42Lrhh89kbixniCBkHr9fF3E7yxdqp9+F3cFy5VACuGn+GVWwnGBmeBu9Uvwz6097RCu+yFeNx9
	MgaN7RIoUkzHNKCUtaTh+jA==
X-Google-Smtp-Source: AGHT+IFuYKhTNkZo1zHT3n8goj1eAlCKYc0UGvUunYO7cTm74ULGsgKSHtvzrkUGFc8t744bYwmuGA==
X-Received: by 2002:a05:6402:4616:b0:61c:87da:4bff with SMTP id 4fb4d7f45d1cf-62fc0a6bf24mr1927706a12.26.1758265977286;
        Fri, 19 Sep 2025 00:12:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62fa6f03008sm2720147a12.7.2025.09.19.00.12.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Sep 2025 00:12:56 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: [Patch v2 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Fri, 19 Sep 2025 07:12:44 +0000
Message-Id: <20250919071244.17020-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250919071244.17020-1-richard.weiyang@gmail.com>
References: <20250919071244.17020-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 018DD10000A
X-Stat-Signature: yhfopfisi9xn9qqm9hzssb5x7gtbrz4z
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758265978-779966
X-HE-Meta: U2FsdGVkX1+Zv4ZBYEWY58q4s2Io9rJIQIxVbGDgNg+2PqLGrS2P02Naa9w94Kkm5hUxOhFlX9zeWDwIDX8AbNXTk4cQN0W5lVAet0BbjgBVJP6InMx7adIdErZjDY5jJmgp1Ntut2d5bA2IiqDdciYC2NkLgqT5vcFqoZSOTPdkYNM+kCgzfJBigIi11KLBFsHgiM+u0K/xRojTrAw19p8dww51nNbRHWBNh43irAAzTp4YodcHJ9q7nW4BBwYADcCBR5SHtVrwMlACnepEYgQwp6Fy3xver+I8ZqaCiTonSh5yU0xc9iNFgemMh//L4ln0nMaTJpUSj0GtwkQugOF54VZDFSG74mTVwPuQd/CQw7RlURi9zvmSDqT16mskCPbMkH90P9FjTOg6GsnWogzJdgBTDzviLnOdeZGAsQiBRVRKV7psSNFrXCKjwXPdgH/QqOTkAH2bSBsv7ydbYaESkzPNQ92+BS5BC4xQLlA0TXzLA2XOYviJnDYXSdLxUrMUQvIhdf9NBCpj+8A3ONX3VzuEFIbEmfAb8IB6QIAm7IIJZFp0UyS1+OvZJ0mfKXJtdQKEFILSkHqvaxF5D4nkAGzIeKM32MNZpHFyKUjcvBtoWwV/DDEDJX2vn0KzZH7KEhIbOnCoBqFVRYAFbheXZfo+j3rPqYRfDBl5knzaxj70CBvUYDkPfeLtPe4W3I+iZbJxpJZFzgg535S+C3HW56O1wEBVlk3cTrK/fQRsPtRMVjX2gNjfUIEBUH1SPYLwF85xvKPvUf/ine6SD+vf/WYowSmrSmu823WgiknkT5xkbHj3421CoJHEAYmCPV1nzQZlFZoUkm5JRQ4jGiEJwqpZVDJrHX3k0vw7CtcgqGw0jzkvt8H8Q5F0lw07AxMk/hYkS1EfOuG6y6GAmjgHg1CZAQ1GsD7PvkWBsxeVSLz88Kh9cxN9eVusAwrsZtdT2HALaW9fxpIstym
 5LZVOaxo
 1EmjqIjUtjojP6Jvtytd04yKn+Dy2zwHscnQrJb1t/JjlViM374E9jN18oTH4gVGujjFE2j3WOgLAwbcPTxHklmmLZYTy7fs3m1Nj5GvwE0ClgbDBFif19Fr/zHdn+NATeu+1YyA6BH7EXuz8P4PPX59OnAKm2oCMO71sth8BBnLqXhNvsiZT0KLg4oID02Fcms8q84b/1yEiNAT/m4B1j/utdiHAV5t0n6UMe2R9OP+8IDpXoTQ2Hu3SPNn+6QT23qNCzIpltSpclLff0LUTwlgaYyhQm7eGo/KG17qfeIERuOmTNVESA+6hE+NZkLeLFNAuuPgXwmEEKw0Jx/Z5QV0RP1edL6bJngt1jNwIJeogvQG1SJQUyIXaxw0uy3iXojmJUpavFOx3Fie0UPXxYmh12vK7dYe4sk4ow8VN4uwWfw+kAJZIFsEuP/hC/h9s0bgBZ1rHTHGAuzEwm3KbhLg6upzB9sjJA5hfA4f2B3m0u3SPVtkg5uJZ9QFZPyxQ8qun5kFknDt7coMLsimiXXPsn5LfgDJ6Dmk+Ez3h1/qpkQoUQZGk6ID9pzLP9ylx5HV2/tiIoUeD60fkulqPO/kVBHCB3JJURm9k0nug0LRNv5NrM5yug6A5GxOc1y2AXGigBcVL65FLWFhJurUIsJUU77FKDKIwU2MckdKgNVTD5ERw8oLI4xHjaYBP2o46U3/UUUZu8toXvApv3Yaz1UOY6LSGenTpNp+6AHkfHnpujO4o/WaTtUqlNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current code is not correct to get struct khugepaged_mm_slot by
mm_slot_entry() without checking mm_slot is !NULL. There is no problem
reported since slot is the first element of struct khugepaged_mm_slot.

While struct khugepaged_mm_slot is just a wrapper of struct mm_slot,
there is no need to define it.

Remove the definition of struct khugepaged_mm_slot, so there is not
chance to miss use mm_slot_entry().

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu.xin16@zte.com.cn
---
 mm/khugepaged.c | 57 ++++++++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 36 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e019ea2cbab0..88ea92c64bf0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -103,14 +103,6 @@ struct collapse_control {
 	nodemask_t alloc_nmask;
 };
 
-/**
- * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
- * @slot: hash lookup from mm to mm_slot
- */
-struct khugepaged_mm_slot {
-	struct mm_slot slot;
-};
-
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -121,7 +113,7 @@ struct khugepaged_mm_slot {
  */
 struct khugepaged_scan {
 	struct list_head mm_head;
-	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *mm_slot;
 	unsigned long address;
 };
 
@@ -384,7 +376,10 @@ int hugepage_madvise(struct vm_area_struct *vma,
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
+	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
+					  sizeof(struct mm_slot),
+					  __alignof__(struct mm_slot),
+					  0, NULL);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
@@ -438,7 +433,6 @@ static bool hugepage_pmd_enabled(void)
 
 void __khugepaged_enter(struct mm_struct *mm)
 {
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int wakeup;
 
@@ -447,12 +441,10 @@ void __khugepaged_enter(struct mm_struct *mm)
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
 		return;
 
-	mm_slot = mm_slot_alloc(mm_slot_cache);
-	if (!mm_slot)
+	slot = mm_slot_alloc(mm_slot_cache);
+	if (!slot)
 		return;
 
-	slot = &mm_slot->slot;
-
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
@@ -480,14 +472,12 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 
 void __khugepaged_exit(struct mm_struct *mm)
 {
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int free = 0;
 
 	spin_lock(&khugepaged_mm_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
-	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
+	if (slot && khugepaged_scan.mm_slot != slot) {
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
 		free = 1;
@@ -496,9 +486,9 @@ void __khugepaged_exit(struct mm_struct *mm)
 
 	if (free) {
 		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
-		mm_slot_free(mm_slot_cache, mm_slot);
+		mm_slot_free(mm_slot_cache, slot);
 		mmdrop(mm);
-	} else if (mm_slot) {
+	} else if (slot) {
 		/*
 		 * This is required to serialize against
 		 * hpage_collapse_test_exit() (which is guaranteed to run
@@ -1432,9 +1422,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	return result;
 }
 
-static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
+static void collect_mm_slot(struct mm_slot *slot)
 {
-	struct mm_slot *slot = &mm_slot->slot;
 	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -1451,7 +1440,7 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
-		mm_slot_free(mm_slot_cache, mm_slot);
+		mm_slot_free(mm_slot_cache, slot);
 		mmdrop(mm);
 	}
 }
@@ -2376,7 +2365,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	__acquires(&khugepaged_mm_lock)
 {
 	struct vma_iterator vmi;
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -2387,14 +2375,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	*result = SCAN_FAIL;
 
 	if (khugepaged_scan.mm_slot) {
-		mm_slot = khugepaged_scan.mm_slot;
-		slot = &mm_slot->slot;
+		slot = khugepaged_scan.mm_slot;
 	} else {
 		slot = list_first_entry(&khugepaged_scan.mm_head,
 				     struct mm_slot, mm_node);
-		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 		khugepaged_scan.address = 0;
-		khugepaged_scan.mm_slot = mm_slot;
+		khugepaged_scan.mm_slot = slot;
 	}
 	spin_unlock(&khugepaged_mm_lock);
 
@@ -2492,7 +2478,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
-	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
+	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
@@ -2505,15 +2491,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		 */
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
 			slot = list_next_entry(slot, mm_node);
-			khugepaged_scan.mm_slot =
-				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
+			khugepaged_scan.mm_slot = slot;
 			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;
 		}
 
-		collect_mm_slot(mm_slot);
+		collect_mm_slot(slot);
 	}
 
 	return progress;
@@ -2600,7 +2585,7 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
-	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
@@ -2611,10 +2596,10 @@ static int khugepaged(void *none)
 	}
 
 	spin_lock(&khugepaged_mm_lock);
-	mm_slot = khugepaged_scan.mm_slot;
+	slot = khugepaged_scan.mm_slot;
 	khugepaged_scan.mm_slot = NULL;
-	if (mm_slot)
-		collect_mm_slot(mm_slot);
+	if (slot)
+		collect_mm_slot(slot);
 	spin_unlock(&khugepaged_mm_lock);
 	return 0;
 }
-- 
2.34.1


