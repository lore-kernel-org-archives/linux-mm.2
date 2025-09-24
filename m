Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8D3CAC5AC
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 00:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2908E000A; Tue, 23 Sep 2025 20:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C478E0001; Tue, 23 Sep 2025 20:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95128E000A; Tue, 23 Sep 2025 20:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2C388E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 20:49:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63841877FF
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:49:04 +0000 (UTC)
X-FDA: 83922309408.05.5620BB2
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 999FD10000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:49:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M5mRsEM/";
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758674942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Yx0OQ9n8NqSm6LUBQKRZvBvcolX/CtMd/sBt68RO2rg=;
	b=5q/SD6WAz/PeloJwrLQ+pUCRur/Xxx3aa/PIt5qKoXl/3wT2yhg2XQwmjvgcQd3jx4O8mZ
	jIT4JP46vx+BSicatZBH0qsxC2svHL7sBNM7whFpCp6M1a2z14G6KFJfYoKJF31GrnH/pn
	cx4ekFl8sskc2V5P75LuGoy/aTCgJEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758674942; a=rsa-sha256;
	cv=none;
	b=AcQmFrwmTUnrTXJn7hdnkY9S444M9d9MnD43iXNU7OZkOaLPCTgYxHQsvNbMPhPvuGlDvl
	WfiohU+NpLj+agXhSH4l2GSRm7b152IE2HYBMNbduFzgN3d2PTt4WcO3tXg6i0f1rhqqj/
	SIyOcSpeUESml+HIMXUXuSDa6HFRiKQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M5mRsEM/";
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62fc2d92d34so9088326a12.2
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758674941; x=1759279741; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yx0OQ9n8NqSm6LUBQKRZvBvcolX/CtMd/sBt68RO2rg=;
        b=M5mRsEM/I1cVOfIWiB/HSPyX2j8E2OrTDp3ynwB9LPd0X+N24k0MSYSKGk7xK6gx9F
         juLhZShT24Xlya6URa38QCXMwDR1ITGV3aCHCUoAuPN/7Hg725cflP7kehZIS2wk41C3
         F9zwljbXjCNX41byy9rXfc6RF46cBlmXHgOEKQtWWwjoMPrvg8YH5GwUNf9U4KJOEXyz
         Ey/kPWS26HZoR3zvcq/Vgmp0rrrkIrkS7p/FAV2hNF76YhpMYjzsmp/guGzdgykUrFwD
         ctIpfQf6hovfLQlE97KSWepnlZlT3tEcbs98Z1zW/fWlUO4mmnyVywYEVYFkkI+Ux1h/
         oPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758674941; x=1759279741;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yx0OQ9n8NqSm6LUBQKRZvBvcolX/CtMd/sBt68RO2rg=;
        b=wCYW/lF5BqwoHlvsMwRhTUeXPrbEVftMR0GqhmOY6u7gP2YjRVLrAw7Mow5ISs5dQM
         CHgT0b+cc5OMGpsmYO1ikyfoeu2lXH9uHfkQn+m0b9PWe9iYn7D1gVY6/ae8KzRbI3Qr
         5C8xJNvK/GldnWIUpDS4BlJi7BofRFtNFiDyxF4xQIwh1W2/IQ9R+rmNk9e64eX5ZFop
         11FYtbR7RWjIqgxPjbD3OtqBCG0/la/z6mU3eBUYC+XBV4pAAzb3pOcLRqK61TXrKI/T
         MBsSgLU7Zg3KnKPeWk8YirH103I1gFwvC5kGpPh7samkZKg1wFZaEEFfruWV38NKjK1X
         A1Lw==
X-Gm-Message-State: AOJu0YykY5cbXtqTl8OpLQ8e31QfTCkNrC8FBnMUmgEUK2DrUB9fS7ru
	bvltrcf/L4+XXYhy96vO1Rwbi62ZHwnsizB7R4JzEthlH53Uz/fmUDYo
X-Gm-Gg: ASbGncs004JZ16UkudqCgK+xcCYCwM1jbEuSJYuflD85wTFFpqg0ErfxOSnG3SDGXWo
	YwArxJT/dOT2BbRYRqdYeAHbYTA6Lj9ZpsTzuXXRuekjlJU3n/O6FkSCs+dz2Lg1yV23Ul9wbwZ
	FyfD+AITfzv4YKGX64OEIkqNpa89yDKHj/eRU0MkLyxX7Jh/Rnhdy//kadF2Jhj+aDxaVr39crp
	zVflRxJG7+65h9mDlb/8LD6U7RmR8hhNO6X+ZvLpnGZhZVQg/FNkZRzCUbmlqLyXu9uXVepXS2f
	nnmN/q3WjivvY4gou2mbHwvC6oXvJfA5ylbd2VyXhkyy55Eq7o63aTNAUYqcs5sdtM8Isfn+O4+
	45TJLKVOg56hv564QpU4Mgw==
X-Google-Smtp-Source: AGHT+IGbAQdINWgnl8AoCEwIhyJCp9n0iy/5wcJ6yB0//hzqpZWasB1Ucm7rw6BPErGiUkwDujxV7w==
X-Received: by 2002:a05:6402:4551:b0:633:afb7:2e6a with SMTP id 4fb4d7f45d1cf-6346780ebb9mr3082534a12.18.1758674940905;
        Tue, 23 Sep 2025 17:49:00 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62fa5f14e64sm11645971a12.25.2025.09.23.17.48.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Sep 2025 17:49:00 -0700 (PDT)
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
Subject: [Patch v3 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Wed, 24 Sep 2025 00:48:54 +0000
Message-Id: <20250924004854.29889-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250924004854.29889-1-richard.weiyang@gmail.com>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 999FD10000A
X-Stat-Signature: w95g3dgg7ypbye84gtf9wb7i48mqh4y8
X-Rspam-User: 
X-HE-Tag: 1758674942-656557
X-HE-Meta: U2FsdGVkX19fYaJnPN95p85gwQw27IE3NVG5yiLzIgv/eCB8Ftsxs4/6GF/3bVBB9WSoos1SB956un6xkKDEnrHE30N1JLU1EVvYElEtXYQOmfBZc4OFmC2ZgvKm4VrXuLrBVGV1mMD16hrRrmuOxSv9MiOCXY0Yvx/LU8zu/vFZTIy39h4BvtrGqpbYIvqLmE2CARzJHNu5jQoYGKwC/i+j6m7ddG4Dw1qPcAId36BLkXO5tO9urj5PVRoaGPFoSoJIOmxpXTUp1ikYifgTp3pL1IiRMKM7erSz1dHpTjCBvPD7N1pm7sDBNMGlCdXRDO3ZxrlviGoCvvYTLlP3T0eoukPp3H/L/7T5XE8Fl4hQsBGEStIqe23DFG70gqSrb4lxxHk6kmL4AanqNDS+f4s2el/754A6JXXHmFwKfh+qQ2lHnlYEupqJWtaDpDxG9Sc1B/vNuMnvWl9UoSyeXKuD4PAIdi5bD2CTpfW8xP/DoHWpMkB0MXKk23/Vbe28ezA6dwZvaXq2S99WDr6r69ttaB/Z1P3hy4md1PshUI+icx6/J0eiN3RVyUQc8HTqKgLV5UJieFAJAPfHLim/lK8jy+NdtyGr5TvVnYYM50Y5EZV5uvbZDoG9xJDjLjwDcn8yFeVUAUeBwJ8eqtZHuWwXDILsCxrBz6gdARx4SSZvkqrSrwqvwwwGJlEHCXuNhG5VLci7iUD1Ufp4JtmfQSovy0645Lo8UaSrEvaQCwg3qPO3BbAg2WoDX1QcXBHn6TZwHdZVHK0ujpalN7Iv70YQ2JnsvuWcICRi1HvZCml3CmonEO+R8LF3KYOwh3puy3m8mf2TX38cKbiD5d8/73VcwylEjguDicuNrFAJZn9g9EzUM/fRIbVQlA7TKomtGbPSiREa6oLv7q/ZBUF6CYVYAtHKuznbcOP0S5O8YgIQYgLBZx0CpIwklKx2vJ+MCZ+UqYkzwacvrrpnNIw
 uFuSRdZ5
 Tq3ZL11HzHODvBtTtrl+KOPlTuW1KQBxQyq7flWm0tIQIpjeuJjBXe/NOmsFnCFoA6H6KGyPwDLPFz5iAbq8Ct7N1+B5i7GUwKdXGLXafq8rpchJDUGwTsG54aUXZhVOmCTmcEvYUpSbX9tIPp/0OtYvr6TphZkP/DHI1gF52jyDv5GcT/GMRgwBVNzNX6IUon+VPwbyCwi4re5Hz9Ifw8KlAWtLxN4a8/+O9I1sgEqxoAqmBJWwFLN7jrn3wfwcaKeLMLfpbbyreRJFgiQlA5zsU8cx0HcXp8PbocLQPkrRnSPiQYqkRQY/M3cYdfA9zyXHqwTmk1WYr2cvjPFtvYXDT4VEHw/kRQxs+bFGO/mWaw/lq0wIcBUf5RN/QDxpE3jhRoIHTDaX0EWGc1ExSTybash/v/8aArGz/8LX0ToH6thNg71/ZEsDi1ik0plIfQ1PQf3ByLaMzn7+iH6hpbNb6ceNDN6DmZAi7y2nz+1jUizXPdBXKxCQ4ycb3FpF+b7IGqwc9PejMueYv/zJqiV858gdj6Zhm75caSPFSY9Pbf1wNNKrVAEgChDVWzrBmGXNyDiUYF45P1tmUrjAWdeFyXwjh2ooTm3VGqoThgxjC/SevyQUD7WzHcnCco/CHVBsyKMnHG8wD0j6jpKG9C61OxBwZ9gDqPwm7dAUWJCQypBQK9zRz2y/R38ygS/nPJh4+Rwud0feKwwIvkg2Z6KsvE9q3YbI44ziAqy+9E48mNVFco6JP6KN2ubfLD+vjs8Hg485UwTSBoU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current code is not correct to get struct khugepaged_mm_slot by
mm_slot_entry() without checking mm_slot is !NULL.  There is no problem
reported since slot is the first element of struct khugepaged_mm_slot.

While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
is no need to define it.

Remove the definition of struct khugepaged_mm_slot, so there is not chance
to miss use mm_slot_entry().

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Nico Pache <npache@redhat.com>

---
v3:
  * fix a PF reported by SeongJae, where slot is changed to next one
---
 mm/khugepaged.c | 58 ++++++++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 37 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 204ce3059267..e3f7d1760567 100644
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
@@ -2394,7 +2383,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	__acquires(&khugepaged_mm_lock)
 {
 	struct vma_iterator vmi;
-	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -2405,14 +2393,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
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
 
@@ -2510,7 +2496,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
-	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
+	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
@@ -2522,16 +2508,14 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
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
@@ -2618,7 +2602,7 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
-	struct khugepaged_mm_slot *mm_slot;
+	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
@@ -2629,10 +2613,10 @@ static int khugepaged(void *none)
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


