Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C25606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jsi2k6DU
Received: by kanga.kvack.org (Postfix)
	id CEA366B05B8; Tue,  3 Nov 2026 03:28:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73B26B05B9; Tue,  3 Nov 2026 03:28:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61F36B05BA; Tue,  3 Nov 2026 03:28:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89CF06B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:28:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FEC780337
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:14 +0000 (UTC)
X-FDA: 85393130508.11.0853349
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 70D70180003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jsi2k6DU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvY0AiutF4T/EB4hRLo3HpPGeukYkdDeEJ/iU+h1ORc=;
	b=8qRSWV7KOUBFBTx5ogKr198yQYznEuAFA+u52Vs25R6SwXEeYA/A9i9j4eQZyFuwr6JQYc
	3bmpUIT3iPpxLHCqp8qG1R/UM+OTffBl1wUcmts//TjIQswmoXpx0dYl3YbE+WJMysmq8R
	j3IGkSwlOspOS5v+5Y8WHKjlyMsBUVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694492;
	b=fqbxWuvGA/bAUfxBNwntma/njrTZ7zgoDn0SV9Qzctunu0KQeiuJzfn4TTkDtLzhFWQSXW
	DwjwXSoB8crqPnRwIh48nJCVKCASSUf9cekw00gn+YTE0lpW+cmNC3IGZ1eSTPW3XmgGFX
	BXLBtZ1w40n03EfG2QGxZwBW8usYs5c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jsi2k6DU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10D24605EF;
	Tue,  3 Nov 2026 08:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55461F00A18;
	Tue,  3 Nov 2026 08:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694491;
	bh=OvY0AiutF4T/EB4hRLo3HpPGeukYkdDeEJ/iU+h1ORc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Jsi2k6DU7Oh4aCzLUoyqdjj7G7J2pWq2gAvAERDaWugLeCNd45aEyJUjjH1j3DIZ/
	 4WK2D69zuXf0TH9ivA4uU9EhOPCOuxAd/uwOLvAb1rTsiZq0JdKIbHch8U79SWHR9/
	 TQjwjIApWZVNqq7wkmW3QcGZEer2VvcsJ24gorf/qPVJPaBaRru6Sr6+kR/04yj0Vr
	 JoK2GPJHqpPFLmyP478wap5BJcXtgqU2I45bSkryz3AbK+7/vJMy9asK6uLB4fzk+1
	 xK0QKeLbJ+lljB2lGISxrOsqQ7AiLZyoyLJ+shsQF9Easzn435NgEVR/yPaR+yHlJO
	 7ouc47z0RzQKQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 03 Nov 2026 08:27:42 +0000
Subject: [PATCH 1/5] Revert "mm/khugepaged: remove definition of struct
 khugepaged_mm_slot"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-khugepaged-latency-fix-v1-1-a07ab16ac860@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
In-Reply-To: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yonghong Song <yonghong.song@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6851; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ty70DWaf971lvzzena0vW+gJxafYRNDAfLReCqRuH9g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJezuaZ6c1iubrVitX2xWq/2QVdm4KCPmW9fvta6xbnY
 qnbNya96ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBElsky/C9i1kvb4+hrmTtl
 j6N6SdyECTMOH1MJjA1jYSvdc8FTwYPhn1n5q71Kv1g29y++f31Z73vXaxvEX3g2HmY8eC206t7
 zt2wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: kxqb3973e85sbigb4auaw85khe49fgbs
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70D70180003
X-HE-Tag: 1793694492-762482
X-HE-Meta: U2FsdGVkX18TlHVpDUeZc7EAN/nJyQ0IS0QqvQnsgJ90Lbre3F8wBzH++O80/MwJ6oTJX+IEMg21UoW1XGQxGNz4n2sfC4fpYaj6wRanFypADJCRMC7qYCMzaWJREmZnvSL0qpYDQgLJpBdAKGvFWcrpfvnKEnDKmIcj5A9QfHZqLmLHcOhEz/zIp9YyvxY1rcsmLAIfDxMiPv+GJlfGVtCmYuLbGbCRK5LAIN4TvH4EvSdfct7l7HweY6xTG5/Ryp+iFVKdZimVl84bdMkyogyn6gXwdomqrcJlv3QIalz4AjLP4dXDB5Y7ireuw5lKHGOQ6QFfZKBThBTWu6tpj7K3FPpeINfRR7ZAqErsbBUeO8PW5T+H47k5LbmpzKRF7MwetSln8XT+uU/MFV3F/XJP5EagKeQrhosJbf8KSDL03T0hlElkn+rLLc8CsIbU0auova2q7j0pOQydggRTS14UTMULr81IDnp/XWnGYCu6XMcxM3zjUWD7++Kz+2BJE7wcYQ5KKqnXKGk95rto8iQmhM5Av8Cxzv9UptKjEA/USqI6vUrDUV6nWlH7vVIJkohOdALBPZYoJga8ZTW3e/7BffAWP7KZqLWfMt8WqarqKi7oMZv/521mpx6Xymc2WWjeTyLYBxpjcIquYWmCIlzp7Tx+Qx9qRWS6ckHxJOZ38nTtbxcSFweMH/uutq8VJ5gf45OrPc9idInUbiS2UpDMDfaj/wORrneVuXuC/ilz5/uBjp1P2TSy2cB/eH5OIrtGUjRbmQPbi5AUr+Iilz/sgVNsM78ljTUMICFbUbPH9YJxb31xqga/+WT73QJKbdAxy/gDguB0dOvhJtpf+mUdr/+0KzzzQVLGExSv86kSes+h5DGuvb6oFhkLsHqS/7fa71o1MFlIDqvcwDAa+Yzg5mdlBcUp0GwZVUHgVBd60Kly5gRxnc5k9PD7vLh5muRYH18zZBWL9pOkJQN
 Jvi53SSv
 32iOBlaj3HPYkPlrS3BcDNpVyrHJqGkupFBcgAOoDHnyvw3pL8arPPCAprgPF1Jj4DxDjaGL5N2nm8yH+nynymn9gyBaN12i6Hq234gHcOKAf7buH9KoR7X8cMTak3oV6koSZ5l9embWdpxRZZ+lNP24YLkMY+mNdl/bAVY7r6wi5CevlvEIcqph9aDbmw/JV+ekKvOIaYrIVI1dRkGD7cFSgLCt5NIs+Sd6yZ07CIiSRCZEabT7uHc4cj6SNpQ4w4t2vrjORsBu1Qz7hvJKA6/Y7j5vnnM/ASBfw
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


