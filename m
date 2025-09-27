Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93649CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 00:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B688E000E; Fri, 26 Sep 2025 20:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC98B8E0001; Fri, 26 Sep 2025 20:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDC58E0001; Fri, 26 Sep 2025 20:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88C378E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:45:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FA8343F66
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:45:50 +0000 (UTC)
X-FDA: 83933187660.07.F264C67
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 766FAA0008
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:45:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aSuM5ldE;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758933948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CDNg+3k8YEV1iewYvnHtCnRi+L/Q+TBL3sW8ermuGNE=;
	b=NG3vMnEkq/kduBTp6BkPJC+OccAwlz4WtkEn0Fz3D061f7sL84GdLS1owCYpfoxGLKAfe2
	M2jlHNvEn81PtoMcN6HFSS2MP2JfDuGADIcaeF9vOekzER84w1q6OHgbXCdxA1BKUs6h1p
	bY83myV2icpWkcGyIL68pmQp1ocBow4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758933948; a=rsa-sha256;
	cv=none;
	b=H8nNHA6SfgwoPXCGKyaX4QBLuPvjVT1GpOg8aD3vhDb5xpgt75MTq4TRMk8bAeekIcTob2
	zaSqtI3FvWQge84qfKOAkLDDKYXn81rwhUxF47cRBNJsb7DsJS8HYYzZGNH428fXiSl6W0
	tqQG2CJ8ASKMES7sNqqyPw4Q3H98baE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aSuM5ldE;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63163a6556bso5974591a12.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758933947; x=1759538747; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CDNg+3k8YEV1iewYvnHtCnRi+L/Q+TBL3sW8ermuGNE=;
        b=aSuM5ldEhF6QIZxFAw6hvg+nui5fqFvZGE4QQRMxPYKDWFc8hUh3FTh+t7YK8BGXPl
         k8iBP2fvM/NeesYjiVffYYfYtY2K7GM+3tNr0IaSmoqC0f8nAhCmc1B97Utq3v7QEGlz
         XMapHMFdkad3PTcuKV4Fy+q0RCEI/s9zK5Gng33ksyJPbxp10eOzzqLZ2ENWALagVPOp
         IOMXejL7RDDc0rAQlJGzVc5AprMKumjZYpSnZA4x6vA2p6oia/0lyccSkUv+lwyvYO5V
         vuW7n036qj3hlnSLvF/SjjKwoUCLaxWj1VKVddbOj7255u1G/tAmw6c2Hj+AOXfTROLs
         QWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758933947; x=1759538747;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CDNg+3k8YEV1iewYvnHtCnRi+L/Q+TBL3sW8ermuGNE=;
        b=WJ+J/0RwwquBX0mhEo9aytfTkmiUUxqPEEpd45fA6WzOd0ohb1T3qdL1POBVPRaxsv
         Ak/p64rQ+hZhlAq7E4bcGoicUDVZl0u4GSN7RoVuk1gl2jyr3q+VOyTD10k50LRMWnPI
         Mk6cuEJHRTM+MIuBj++KYp5CS9UjzY2Q3fcOqC2wkDq6EEOtwrkRbGFSGUnDHWNSfGdS
         RQ2z10a6TfppOm/x9eeQmh6oqASwNq3aCKqRLDQlUTysXZiCuDNZkofxQ1vU3yT32koe
         NOvfLjPsd17L9hWimIXl6k2w1qV8fCnPiXkIdM3ilIpwJXRz3j2fSO+8eDa+aKHCYE+c
         rEog==
X-Gm-Message-State: AOJu0Yzzoal+FsOtE0xSugCPIWcRDzNAl9PjcDFrE58a3EdzY5NYFTkP
	pD/NCssH0ALzMROvyvXq7k3ASYPap8i24M8OkuNAtig2B9YYLOfEuEf5C1Ijuw==
X-Gm-Gg: ASbGncvZwm1KvxNjTBssxG5T8Mn77Lce70hPeuLOsDIIwcgOdo+lAziJ2EvcCNaAusF
	QF/TIhS3+mx67iFfUu3r8dyuubQrLQxObi83+DNr43KjSEEjqXv+KN077PsoXFAM8uXYrc95flk
	Ltfpbk74Kii1G4UkW3t1ctxPQKF5B0SOF4Hd3yWe9Fc+tPqn2FuEw1T3hmrrRscPmnhkcoMyfoX
	vqD7LvO2lAy5HpIF92hdNkjW6E9is0NkwPJCduDFd4H9QXTQHRjGsCWm08XO8oLTcx166q7ctj4
	ZZvAfH/IaXFQJy1v3zXj/9TatMegIVsI1OUZC9wZouQIczvO7JOeC0RZHP+et6APvQZuj4d9jwq
	/bGOOioW6LOSH/+wW1Ng73OORWg==
X-Google-Smtp-Source: AGHT+IF8rVuBw/E2bC3JgzNw7zXqqqNP3Y4/pPOXCrBuPpfvtXc+S9F04BanVfN5NM1MGFaJ4CHRuQ==
X-Received: by 2002:a05:6402:160c:b0:62f:41d3:ece7 with SMTP id 4fb4d7f45d1cf-6349fa1b9a4mr6174352a12.14.1758933946955;
        Fri, 26 Sep 2025 17:45:46 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634c28f1149sm1321018a12.7.2025.09.26.17.45.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Sep 2025 17:45:45 -0700 (PDT)
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
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	SeongJae Park <sj@kernel.org>
Subject: [Patch v4 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Sat, 27 Sep 2025 00:45:39 +0000
Message-Id: <20250927004539.19308-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250927004539.19308-1-richard.weiyang@gmail.com>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
X-Stat-Signature: 9a5wfona678p61gfjzxf13rxx1h4atxq
X-Rspamd-Queue-Id: 766FAA0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758933948-629147
X-HE-Meta: U2FsdGVkX1907YJEZxq08MmJhN64QkqGzutcvNHivVlWK+6Qx+6fMEOco9KiF4RA8yvniCEfYijo7MWwH0laLex4dNnwPwQeoQtZhXJ9IgqSehOCmPNd6vuWxVe1XdIavMfzwoIp6N4P0n01fJay9FADQTnV8Pb4PRYmvC6kglgNM1ahSkibB/XI70TtHRIpaVO0otcNgGlZvrJ2r3o9S9hxUkcm4PpFNveq2NMLYX9OhC4ngg3QT6jb4hMd44KU1d00NHU6Iv+NIXVcsahqKN8gDz2FXTAfq9qNsqb41KcoQRQzfb8K2BK9NSvyF4YOURVq8PfwzVsPUfEQUrlBZDFBHSkfZnq6UjF4yPYawibOaPD6JDNVqDc12Stx29EYZ4VbXc/Ce3QXFgaf15fINOxRBmiOWTCF9w0Y2AuHJxK42DpBgDSPn/OPA0A5pSg5EwStsjeHI0iFMO4kAn/bl8n51sGwM+HlvxCjTNeKwzKqA3ZpWRD2o2cJ4mhpXfSgIRWTL0FVpcnozfWFGDNphEvMN6h/YDOGuQXd0oU0LB+G/AyubMGT0KiobvBUcDbYL39tbz7nI+47gIqlHsjaAwVgVylX57yrLWtv9Eaei3C6N1qyD7lSqsyfM2loIfM8ZIinNqBqRrb64MwB89NkgcFcXF63yRq/2mDxd4ksUvn7pEKXse3GA4Lrt2Mc+d+mV0b3H1u4SFYZoBMsLWZcsMyipCAvg2t+cRA5qQHFRN4/ltdVBf4q91Y7X2j/y88iG7cQXZ5RC3jUk3IrMzDYOwjrQzUWSVmhy+w0N7osT6K17iuoJ7LnPvqubYJeQRVtaN1qljmQMblVcQFPEfOhMXBhYfTidkhzE8pgza0A04NTkORrFuflamApRFmFrH3hkRUCN6Hg0w4sWiuA1IqE4Sft71A6klml4pTJXG43D+jvAES0Yd5vB3KYOOsoggwZSiyTatpJ16VO/9TDZft
 jNxCHpzo
 WGw+bGjNG6oy6fp0VMLHB0wR8u9zCVofDYh1beE1RsP0jo79Q6M/ZOoqCYRZea1s6Nv5vLEarYrhzq2FgC7vg5r1AvpPYV+JJgUe3O/pRxWsnYVAOtTmm5x7GckhFIfg95aVChUFX1LLqN1a0YgEJnSHF7YVMvE+f5Dlmnuw8YQWmugEgEyA144e0cWbT5h7bUmilOOFznmkePkIrKJVIq4oWxpst0Ci58wjbJA8UT0JGW6HzNHat0IY2fNImGdRD0D4GHpq9O/LXwBD5hEVlsuPDh3EB/3oXiAevSyKx1vL39L3ChjyeyHkh4f6XAbQ8VrTqy7WmQlya2ZYRokw6wqhUXYVzX6sE9hbABvDuqLbAI+f8Ty7modNfQ+OEvwm8tuwMwyTNr/RDEJ9e613XIRWO3/zNutmKXI5cFd0iySo8FHmdYtAfwaa676fp1vQHx6qWVabq+x4xLGrsKUSZ15smg5m/3OceKRAj2Fhd4LdJP8aovnSM/rKiPaM822auMEnpnnAUXZNCDiIwfhRiDy0mUkmoqftyTG64qiSUDO4d+myx7mtNwDoxphm+8Xc8A67LvXum6lh6HNjlG2jOuKEXxRYMHkG7yMxdvtshCYzBeiDSmWWa2P69EKp/o29besVH9Pnl490HZnnU123UFKLUWrCT0LiDArZqaG2SOqKzEtHp6dr3pCwRLR5z6+nqT37iIDJN/Rht50IhDzNTI38xDDrSsCUw20BUynKuDBB0gNzXNGXaElO+6/f3JuWoGcqY+HiEm/2bEHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current code calls mm_slot_entry() even when we don't have a valid slot,
which is not future proof. Currently, this is not a problem because
"slot" is the first member in struct khugepaged_mm_slot.

While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
is no need to define it.

Remove the definition of struct khugepaged_mm_slot, so there is not chance
to miss use mm_slot_entry().

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Nico Pache <npache@redhat.com>

---
v3:
  * adjust changelog
  * rename the slab cache to "mm_slot"
v2:
  * fix a PF reported by SeongJae, where slot is changed to next one
---
 mm/khugepaged.c | 55 ++++++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 37 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 204ce3059267..67540078083b 100644
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
 
@@ -384,7 +376,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
+	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
@@ -438,7 +430,6 @@ static bool hugepage_pmd_enabled(void)
 
 void __khugepaged_enter(struct mm_struct *mm)
 {
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int wakeup;
 
@@ -447,12 +438,10 @@ void __khugepaged_enter(struct mm_struct *mm)
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
@@ -480,14 +469,12 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 
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
@@ -496,9 +483,9 @@ void __khugepaged_exit(struct mm_struct *mm)
 
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
@@ -1432,9 +1419,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	return result;
 }
 
-static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
+static void collect_mm_slot(struct mm_slot *slot)
 {
-	struct mm_slot *slot = &mm_slot->slot;
 	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -1451,7 +1437,7 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
-		mm_slot_free(mm_slot_cache, mm_slot);
+		mm_slot_free(mm_slot_cache, slot);
 		mmdrop(mm);
 	}
 }
@@ -2394,7 +2380,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	__acquires(&khugepaged_mm_lock)
 {
 	struct vma_iterator vmi;
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -2405,14 +2390,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
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
 
@@ -2510,7 +2493,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
-	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
+	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
@@ -2522,16 +2505,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		 * mm_slot not pointing to the exiting mm.
 		 */
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
-			slot = list_next_entry(slot, mm_node);
-			khugepaged_scan.mm_slot =
-				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
+			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;
 		}
 
-		collect_mm_slot(mm_slot);
+		collect_mm_slot(slot);
 	}
 
 	return progress;
@@ -2618,7 +2599,7 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
-	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
@@ -2629,10 +2610,10 @@ static int khugepaged(void *none)
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


