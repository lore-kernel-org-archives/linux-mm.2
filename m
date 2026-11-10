Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7287C606A333
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lgJA/pqD
Received: by kanga.kvack.org (Postfix)
	id 926936B05C0; Tue, 10 Nov 2026 12:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D62D6B05C2; Tue, 10 Nov 2026 12:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E8F6B05C4; Tue, 10 Nov 2026 12:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE306B05C0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:19:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF684A0A42
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:19:28 +0000 (UTC)
X-FDA: 85419870816.24.1C59654
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EAF54180006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:19:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lgJA/pqD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794331167;
	b=2cWKJr00/gLEUcaHyfrWM7SoCTvZ9jf61WHRlfNtSKaZ33NVapWIqW0ztttpRnoTm+na8o
	l+ed+5qYveasKYYyk/WJNbPqG+fUWoyO+2sOK34ThNCqhZgEsIt3QGXmISVImZuc2/yVNV
	5fPENqOCxDG81qBNbHusAu/73o5Ziok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794331167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q08LJgBXqC70Kqo0f8ZLQKUivwcGqkAeqrOIIemSoaw=;
	b=Z9tWR322z5WNndqK62ZgLCFROB8jFPGQ8LmJ8Z2x2UfUhJHr1N7t+3O2S5Gw83rdQEkCoO
	p/ZnZRDcqZh8pBpddzPeCn+54Wdr1mr9cV1hfGtguZqnhORP+q3S7JnBC6PHRFBiM0JhDW
	NjUzO8iqMvmUCnPc2I2c85wnmPNPaPo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lgJA/pqD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30D4945603;
	Tue, 10 Nov 2026 17:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4F51F0089F;
	Tue, 10 Nov 2026 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794331166;
	bh=Q08LJgBXqC70Kqo0f8ZLQKUivwcGqkAeqrOIIemSoaw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lgJA/pqDt9ZXlQMB1lpweF4fOIjhAzvoQvaSENR1T918mJzYbS99/E+N+41gGzUee
	 /iMs1AedXwbAcNbaw5P59wOxnX7RN8qus55EB/UOIXZIYUQPTAEdZ3Ir2PfTGJVV56
	 qCcA+sz5pEFu0ijD3jwNCDajjm/fS0U8G/LW4AjzItVnOricy985GkzN48v/duEmBq
	 GzZ/W9y3VAkOYHLulVAgb+ahSFuU2xhFeQH1zF7HUlE7zSulE1cDIkfRNKp5lHZQt+
	 +sgCrDeCIafN/akMXdSL+Ibtm+hYj2quYExWcY5QwZKnLmD0Xi0vHlvyNkRMg0HekF
	 DrR39lPXZJkQA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 17:19:11 +0000
Subject: [PATCH v3 1/3] Revert "mm/khugepaged: remove definition of struct
 khugepaged_mm_slot"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-khugepaged-latency-fix-v3-1-6eea743cf9a3@kernel.org>
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
In-Reply-To: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7074; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0UZEhupM8Hvng7+lLXwSgnWUGWUT6iuTlrA4ZmSC5gc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+B4lW9PUemae/3M5kX6/S3sdbk/U3Mc1/qW+7M+EZ+
 0ZuXY+AjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExEgoHhr+jlvISzX047vwrn
 41Mqez915bnNCkYsG1bydtgdW13vtYzhr4ykjtuh5PcbbokVzPAOrc872tbfkh/5Z+LTa0qJj15
 psgAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: EAF54180006
X-Rspamd-Server: rspam12
X-Stat-Signature: 4zxamuf87ny1izp7n1rip9q1tiudz8wa
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794331166-586912
X-HE-Meta: U2FsdGVkX19W6jk/bHFIozizHc6MDvMSrnbWo/B6M1DAhCt+flD2ckgqKcv6/Ctw9HFDnQIpqhYgySXSlngSdmhhPdoNlKg30T75wz2fNduly3TuR2cWFPjh8dSjLri+f2U3HrNPmYCqEKeglnbERs1JV78QYOEfjTZeci8raI732DXBendwDc9Uss+9C2hCX9E3V9kkUz0+4XWbVm4OknnsLfqie51W+jaA7mKXvvxHabzEp6LMlGm/PygSeQnisyyhY8XZoZCcMeIKJ+pkAFVgAX2hrIKr0xPKpRKHkqqY0lG53YivPgZTQ2Vy8upPmsRiqWcX1PhhUQutf7HTEZvV4w9xCstTFFToiZy4H+dkQ2wuGGSXogY+Il+W3QbXGAnU8CnZTQxpVSfBiPszev3ceu78Dw4shqLG0VSLPCbQ2d46+hokdgpzgaTI5mxk0IdiPCKrz0jle+wUUt4fM49T9CEQp0aOoRoXQYDnj0MUUZfyh7FdDt/URiegscc9pICbpVXU/ZGxcFOqiV8ny1SKRPA7AESGqrsnrNHAJSbhdfLNz/+Qfocm1SMIfh71e6sGF5+78Nn/K1t8iJfTxYzL8NwnaxUmOIX1JcXKforPcM2MYW89a0HDUElsKg+Jsoq2mSAjYx0FOo8gLMBhuvLrf/JI0s6Z8GHq8k/Ep10u60TOEMS7cw3oIEzi1jU3FmU7Pdh76MyJLOxr56W9VyqiNYvCmE9d5UpM4KbuxZLKUM6muzJDjXx5fe/wZALBDgOuLnytTJqqt5SoqIgoBepKev0OmO2fg9G3X8sM/oWMpmmojfGJNwUN6189AVTSCr+gmTp+9mYrkMYooy7+nSR9rU/ukkb5Asf1Qy1sfFQMpb7LIDt9VzuEkI3zjD74c479XTPPB4OB5YLv7Bl4AcEZJKSaczepSC6Zahhi56grrZDrddm6HI0a15ujCWJbQnnRHFvPaubZUV9MYYK
 Vi4j4qX+
 bolNyZZu69AxabfE/pyuo2/5UHvtnpGCgS2XoughgdKKEDSuujZsPxaU9qNEskuitOhi3qpP8SHroQzGiy/aQd3LwX4Xw45inuqm5udCTT+rbklAz6U+Po5yPPYv5kAmEO4f1Rlw2/W9GbGSr3gHFIgqSIKlHUTPE7rQdEhviJfeauWbwnF5di149mtqZvoSLCm2ev1JcqqXwxQDCklrnd3mCDwyPAajt5mWx2hiZFtHUol/4Jigtet+uyd6CH94hpsTIQCRqXSz914rdi1R/D85RaWVY5JokApnkh5Pr+EJC4v3nwVHRvOyse/Iqd8cRPMlV2fIXrLZV2iZ8QGQyZlBm4ZGSAHpyIbCw0WpafjLGKQR1cVTmtRwTJ7FM7BJZCndjGsfR40BIg5yt/SLiY6jda+k4sKyuJzRZi09arSpJ88ThjO90mQ1m1toTucRFRalHYs/gr4kkyoF2eB/kc0LYwWsMTEpalKgMZ0gIWaNRYBfA6QQZaw3emA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This partially reverts commit b4c9ffb54b32 ("mm/khugepaged: remove
definition of struct khugepaged_mm_slot"), as a subsequent commit needs to
resurrect this type to store additional data alongside the mm_slot.

The stated intent of the commit was to address a NULL check in
__khugepaged_exit():

	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);

slot can be NULL and mm_slot_entry() is an alias for container_of(), so
this is container_of() a NULL value.

This was benign as there was only 1 field in khugepaged_mm_slot (offsetting
NULL at 0 results in NULL), however it was right to fix this, so retain the
fix.

It also unwrapped KMEM_CACHE() in khugepaged_init(). This was a mistake,
and was itself reverted in commit c14bdcc9f274 ("mm/khugepaged: use
KMEM_CACHE()"). Therefore, retain the KMEM_CACHE() form in this revert.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/khugepaged.c | 57 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index da91762f6358..aad8797f8d5a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -66,6 +66,14 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+/**
+ * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
+ * @slot: hash lookup from mm to mm_slot
+ */
+struct khugepaged_mm_slot {
+	struct mm_slot slot;
+};
+
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -76,7 +84,7 @@ static struct kmem_cache *mm_slot_cache __ro_after_init;
  */
 struct khugepaged_scan {
 	struct list_head mm_head;
-	struct mm_slot *mm_slot;
+	struct khugepaged_mm_slot *mm_slot;
 	unsigned long address;
 };
 
@@ -386,7 +394,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
+	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
@@ -446,20 +454,22 @@ static bool hugepage_enabled(void)
 
 void __khugepaged_enter(struct mm_struct *mm)
 {
+	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int wakeup;
 
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
 
-	slot = mm_slot_alloc(mm_slot_cache);
-	if (!slot)
+	mm_slot = mm_slot_alloc(mm_slot_cache);
+	if (!mm_slot)
 		return;
 
 	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
-		mm_slot_free(mm_slot_cache, slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		return;
 	}
+	slot = &mm_slot->slot;
 
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
@@ -504,12 +514,15 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 
 void __khugepaged_exit(struct mm_struct *mm)
 {
+	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	int free = 0;
 
 	spin_lock(&khugepaged_mm_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	if (slot && khugepaged_scan.mm_slot != slot) {
+
+	mm_slot = slot ? mm_slot_entry(slot, struct khugepaged_mm_slot, slot) : NULL;
+	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
 		mm_slot_remove(slot);
 		free = 1;
 	}
@@ -517,9 +530,9 @@ void __khugepaged_exit(struct mm_struct *mm)
 
 	if (free) {
 		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
-		mm_slot_free(mm_slot_cache, slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		mmdrop(mm);
-	} else if (slot) {
+	} else if (mm_slot) {
 		/*
 		 * This is required to serialize against
 		 * collapse_test_exit() (which is guaranteed to run
@@ -1773,8 +1786,9 @@ static enum scan_result collapse_scan_anon(struct vm_area_struct *vma,
 	return result;
 }
 
-static void collect_mm_slot(struct mm_slot *slot)
+static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 {
+	struct mm_slot *slot = &mm_slot->slot;
 	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -1790,7 +1804,7 @@ static void collect_mm_slot(struct mm_slot *slot)
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
-		mm_slot_free(mm_slot_cache, slot);
+		mm_slot_free(mm_slot_cache, mm_slot);
 		mmdrop(mm);
 	}
 }
@@ -2891,6 +2905,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	__acquires(&khugepaged_mm_lock)
 {
 	struct vma_iterator vmi;
+	struct khugepaged_mm_slot *mm_slot;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -2900,12 +2915,14 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	*result = SCAN_FAIL;
 
 	if (khugepaged_scan.mm_slot) {
-		slot = khugepaged_scan.mm_slot;
+		mm_slot = khugepaged_scan.mm_slot;
+		slot = &mm_slot->slot;
 	} else {
 		slot = list_first_entry(&khugepaged_scan.mm_head,
 				     struct mm_slot, mm_node);
+		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 		khugepaged_scan.address = 0;
-		khugepaged_scan.mm_slot = slot;
+		khugepaged_scan.mm_slot = mm_slot;
 	}
 	spin_unlock(&khugepaged_mm_lock);
 
@@ -2981,7 +2998,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
-	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
+	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm, or THP got disabled.
@@ -2993,14 +3010,16 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		 * mm_slot not pointing to the exiting mm.
 		 */
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
-			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
+			slot = list_next_entry(slot, mm_node);
+			khugepaged_scan.mm_slot =
+				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
 			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;
 		}
 
-		collect_mm_slot(slot);
+		collect_mm_slot(mm_slot);
 	}
 
 	trace_mm_khugepaged_scan(mm, cc->progress - progress_prev,
@@ -3090,7 +3109,7 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
-	struct mm_slot *slot;
+	struct khugepaged_mm_slot *mm_slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
@@ -3101,10 +3120,10 @@ static int khugepaged(void *none)
 	}
 
 	spin_lock(&khugepaged_mm_lock);
-	slot = khugepaged_scan.mm_slot;
+	mm_slot = khugepaged_scan.mm_slot;
 	khugepaged_scan.mm_slot = NULL;
-	if (slot)
-		collect_mm_slot(slot);
+	if (mm_slot)
+		collect_mm_slot(mm_slot);
 	spin_unlock(&khugepaged_mm_lock);
 	return 0;
 }

-- 
2.56.0


