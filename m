Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DDB8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054316B0088; Fri, 10 Jul 2026 01:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B366B008A; Fri, 10 Jul 2026 01:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83206B0092; Fri, 10 Jul 2026 01:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B84596B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:15:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29EFE8D795
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:15:50 +0000 (UTC)
X-FDA: 84971704860.12.8A0BB52
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id E07841C0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:15:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf18.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783660546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=s5QVqV3D09WaKODrMKO33vwch8m8P9rIR6jwwVBnMwo=;
	b=fnMtDsfhtoLvTrV+k6i2o9eAsCxUcGoJTYHImXGSTXSeozFc263WqbJVcFc3Wloi/17AKK
	wbM5peo3QAQA1JS6PCSkESYF6+40d4ruDeQxsXW0PXiGEWfQaAyrzKTMRlEcy5hsyA1m3J
	BZKtaHUPTbs7m1FmUGxPlzDTcG5+zAg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf18.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783660546;
	b=cR5fHwf6R6xJsqSgSiX29q+t0ccnLDg8EnbZTb6uvMqAa+TkwlccMy2tiDsYz4sfJK2StR
	DQIyxCjFGdh9od67Ovd6oNHQH9ITA5LowE03j5oePRe64RkoFMSfFEYmrEIzMVFNQiiemO
	86DpmVW2ILwQkq9VfABC112KZgE4XWE=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gxKmF3clWz5B13Y;
	Fri, 10 Jul 2026 13:15:41 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 66A5Faux005801;
	Fri, 10 Jul 2026 13:15:36 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 10 Jul 2026 13:15:36 +0800 (CST)
X-Zmail-TransId: 2afc6a507ff89bb-a3a62
X-Mailer: Zmail v1.0
Message-ID: <20260710131536564mY9CDv7aP2dKPiLFXbrBv@zte.com.cn>
Date: Fri, 10 Jul 2026 13:15:36 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
Cc: <xu.xin16@zte.com.cn>, <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
        <baohua@kernel.org>, <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9tbV9zbG90Lmg6IGFkZCBhIGhlbHBlciBmdW5jdGlvbiBtbV9zbG90X3JlbW92ZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66A5Faux005801
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 10 Jul 2026 13:15:41 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A507FFD.000/4gxKmF3clWz5B13Y
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E07841C0006
X-Stat-Signature: a6rob1qatqkphtkb1ezrxm618aui1gje
X-HE-Tag: 1783660545-830563
X-HE-Meta: U2FsdGVkX1/rgtO7GrKTytOsA6wKCDNYVhfcau7G8anz5HLCRw93WFh09PxEA3+dV4hqojHQiDzHvFAeFeRk0v1zTkHwtc9QAIG5KTDm4K9y2gtrT66VagSvCrfxezxedUFDzhPZUUPbx9Vli2HoVSh2MLPgRuF0Twd7BdP6bkkO0wFZPJ13IWMihwqTQQ8K4i0mqR8xNv1zn3xR/ZS6Vffv19z3QrZB6Zc3gzE3mali//CPn4UOIhP64JlRzfciZdgXzpuxGoBVFHZtathQ8evRrP5xFAOmmDi1xspwb9Wzb9C7Wj2GBDCuczSqP60t9T/duxJTPZJHu/DKLj7s6NwVLCjIqF/nmVr7qd3rYgllwlPqICSZbkU/4HTw5cDaKhpPENbtpCDb1cPOLjXTO9j/W81f0A1HasCbm474LXSd6IADnPCB8tmP8W5TaJ3DsF3sOd+sKTFHE3eqFCnDhpc1sNT3ZdLwIcRH3kJHLUVTAvMpFnS2Rs69qlB4RXjyN/YQaw7zlSSAvUMtJm+0zSG9VeL3FPFAC3NpSGCwqdkwnw4JUeBcVMYYQiHe888HyuIKLKxSCmHIiVJ9goU/pnxmSvuFq5mjI/sbjZHM4EYOgKY4JE42LX+2O4uW+eM8m28CX9STEF5Tcstb/7vtXz8ChQkTXkwshqxnF+fnax2cHLbOzbw4SvM3MlpfcmRPN7UrR25WF82+3gOOnZ2o8QiG8PH6t8GHOMbpTF+qIDZwVXPsUBMdjsEXesx7xn2kGlZvKxC2g67tiMVHfl3GRhMwmpva9+VmkorvVRPuCQpopWk/PAoKJbfG23LO68vgQ9eb9FBiSn2NEZ2FHFBkDtFYmBH6z2dT6yyPjJhxnubbweMiNoWzi82YGRGi2/sjzOxjeXyuVEM0Q4zbYGZ294ueIdtGg+o3co58Ony1TARTYHRZ0wgwUM183nChm5DeDKWYbmLfC4C4kRxW2oI
 WwlT7cnu
 k61z7LXXSgN7moi8P7+YP+AWlfEP48GEw6raNIIeKRIdgvngVr2JuEZLPKeXDx4R5LZMlfJ5+bUYn+ojtcGCU6LMTrrwVqQ3QAj8EQGCj6jliTjwvB02/JKuFlH+ls8dpmXya3r57VTbpV7J0U8n3ZtCE4EBJuB36i09GdnyDUxiTmi+3XAVbnsn9rYDuwfduSPbunIon7mSb1yO6t3GLba3+kWv7u1r6Zh0NCrLA6PU1O5rybQv6X4CKFXOYM1s6ygalGvCaPXNhB75L+qbFjvVOX66EcBodToEcWnEWS+w/EQh+WnJ9qKfP+CocvK+sr6/8iG9Mp58lLGpvoBjDqAcW3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From 69923b1aa7d702eeea7364a95d7b05ae82ebd3e0 Mon Sep 17 00:00:00 2001
From: xu xin <xu.xin16@zte.com.cn>
Date: Fri, 10 Jul 2026 12:29:57 +0800
Subject: [PATCH] mm/mm_slot.h: add a helper function mm_slot_remove

Both khugepaged (THP collapsing) and KSM manage per-mm scanning slots
using the mm_slot structure. The slot is kept in a hash table and a
list, and removal from both containers requires the same two operations:
hash_del() and list_del().

Currently, this two‑step removal is open‑coded in multiple places
across khugepaged.c and ksm.c. This duplication makes the code slightly
harder to read and maintain, and creates the risk that future changes to
the removal logic might miss one of the call sites.

Introduce a helper function mm_slot_remove() that encapsulates both
deletions. This reduces redundancy, improves code clarity, and ensures
that the removal sequence stays consistent.

No functional change is intended.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/khugepaged.c | 6 ++----
 mm/ksm.c        | 9 +++------
 mm/mm_slot.h    | 7 +++++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 58e14d1543ec..5f6eb1bd9a67 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -606,8 +606,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	spin_lock(&khugepaged_mm_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
 	if (slot && khugepaged_scan.mm_slot != slot) {
-		hash_del(&slot->hash);
-		list_del(&slot->mm_node);
+		mm_slot_remove(slot);
 		free = 1;
 	}
 	spin_unlock(&khugepaged_mm_lock);
@@ -1802,8 +1801,7 @@ static void collect_mm_slot(struct mm_slot *slot)

 	if (collapse_test_exit(mm)) {
 		/* free mm_slot */
-		hash_del(&slot->hash);
-		list_del(&slot->mm_node);
+		mm_slot_remove(slot);

 		/*
 		 * Not strictly needed because the mm exited already.
diff --git a/mm/ksm.c b/mm/ksm.c
index 2791ce5bd44b..443dab513da6 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1257,8 +1257,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 				  struct mm_slot, mm_node);
 		ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
 		if (ksm_test_exit(mm)) {
-			hash_del(&mm_slot->slot.hash);
-			list_del(&mm_slot->slot.mm_node);
+			mm_slot_remove(&mm_slot->slot);
 			spin_unlock(&ksm_mmlist_lock);

 			mm_slot_free(mm_slot_cache, mm_slot);
@@ -2772,8 +2771,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		 * or when all VM_MERGEABLE areas have been unmapped (and
 		 * mmap_lock then protects against race with MADV_MERGEABLE).
 		 */
-		hash_del(&mm_slot->slot.hash);
-		list_del(&mm_slot->slot.mm_node);
+		mm_slot_remove(&mm_slot->slot);
 		spin_unlock(&ksm_mmlist_lock);

 		mm_slot_free(mm_slot_cache, mm_slot);
@@ -3116,8 +3114,7 @@ void __ksm_exit(struct mm_struct *mm)
 	if (ksm_scan.mm_slot == mm_slot)
 		goto unlock;
 	if (!mm_slot->rmap_list) {
-		hash_del(&slot->hash);
-		list_del(&slot->mm_node);
+		mm_slot_remove(slot);
 		easy_to_free = 1;
 	} else {
 		list_move(&slot->mm_node,
diff --git a/mm/mm_slot.h b/mm/mm_slot.h
index 83f18ed1c4bd..bc3b9ae8fdbc 100644
--- a/mm/mm_slot.h
+++ b/mm/mm_slot.h
@@ -52,4 +52,11 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
 	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
 })

+static inline void mm_slot_remove(struct mm_slot *_mm_slot)
+{
+	hash_del(&_mm_slot->hash);
+	list_del(&_mm_slot->mm_node);
+}
+
+
 #endif /* _LINUX_MM_SLOT_H */
-- 
2.25.1

