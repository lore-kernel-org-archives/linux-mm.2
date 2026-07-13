Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EED2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F406B008C; Mon, 13 Jul 2026 02:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8F16B0092; Mon, 13 Jul 2026 02:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10B56B0093; Mon, 13 Jul 2026 02:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D32886B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:37:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57C8DC7F26
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:37:24 +0000 (UTC)
X-FDA: 84982796808.26.8B81C90
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf05.hostedemail.com (Postfix) with ESMTP id 37CEE100009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:37:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783924641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORqzhcILSzb0WYeG3AM4HeiE3bl2KpgokyMuxmxkFRs=;
	b=HYxGaC2jOfGGG7Na+JJ3YPLU+lt7GQYQe0UucDa53JYHS2K+ifj4mot7Xz+GbclN3ejnSM
	4eVpN6mUURohtX4cFG0Ae61bWvz/hK9JJJclk22geidooE0SvAHf1IfHt1i2m4xRimgUlr
	IEbwU50UWLKtvdSFo2naesvZawYC9h4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783924641;
	b=RrxwmHTHoyTNVJL0b7lY5ErhMr7zkoSDxwgbWL+z1xVFMfkSfXP3oh/1zt4OSi1dnQ+ilp
	07R2X1jwQIhn8VtfzxgxzavXVM1YFu+oG6CcXGuEIfY1np5BludN/jCV3tWHrpzua0o+EC
	RFXIu7fG4+4fH/pxcf50Yih4NFRdXDw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gzCR12mYzz8Xrrd;
	Mon, 13 Jul 2026 14:37:17 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 66D6b6Sd028040;
	Mon, 13 Jul 2026 14:37:06 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Jul 2026 14:37:07 +0800 (CST)
X-Zmail-TransId: 2afa6a5487932ca-652bf
X-Mailer: Zmail v1.0
Message-ID: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
In-Reply-To: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn>
References: 20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn
Date: Mon, 13 Jul 2026 14:37:07 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDEvMl0gbW0vbW1fc2xvdC5oOiBhZGQgYSBoZWxwZXIgZnVuY3Rpb24gbW1fc2xvdF9yZW1vdmU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66D6b6Sd028040
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 13 Jul 2026 14:37:17 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A54879D.000/4gzCR12mYzz8Xrrd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 37CEE100009
X-Stat-Signature: bu8mt3wb7ugs7wg9bi6a9x3g4uo5eeni
X-HE-Tag: 1783924641-1494
X-HE-Meta: U2FsdGVkX18N5dtPbUSejcUQDluSJIyGvzeBtRnC60z5QM+iEIRagYp93GNJ4d6SUxLzHSkx6W8S02KiG0BWxsmdSOrwYj/DGWnMOq2NbTfTZi/IxqA8N7Y4bsX8zGjG+x2N/MDhgW5dHb2bx1OYTZcgAyzbmLCu5RZv/mVwQAvHl+hZQfEVW0Rf/5XnupxxD8rZBaqZL3MgL+595Sle1KLvNwxV8w7POBKbNuT8epRdzMg+pN9iPdNmpgeOGKKTNBclly+FZq+iNYJ36eZKdXZBauUCnLFAB2uYA8k6w52LOOb9+dzKxk2/g+qfdaLYsIVQ/qtE5XPBA2UlvYfti1FwUqABQ8gGB9FcjbxvPW14zREhlpc5p69J6gRbG82H9bcrIo/PAEhUFmc4whU6zJBR/k27/jp1RDzcxoXQRrnwByMgJQoxqSxD8pektXxsQezDSWodDHifnNVC6hAP5FFBZ2CBlmyJcJytz25G38BXAzRvXVcPp2lGn15BUe7YFbhlg7E8vU13GurCxZDNPz49snAJSy0y2GyCH+6SqQ6BqyvqKQpIPiOkB9t4t6q0iVtrgiotQwVsOwtm1AZXFAMu9YrfhsPJ44yRVJ8Ax42iK6yxEG/lHmBRxS+Y+gcvADoedWDgt7+WDDK1wY89BXDezyWeXNWuQH/y6z3PgxZMNBoMa1HRz5QNAX+OU1SBrUhWu2ITFNafUXgHQRrS04OMJN6yJTY6JWhYP/q3KMNv6NBJQNkEuR3307KyUAGTHHPaMFz1SBA1/lF+cybwrG4GgXhYBGKjS4fhjFy2mOjSVScdTYf4dzOTjU1awBUpXXFwCbLhU8Lrl1+tQlclNvn4ZoTzR4qNdzLEdogy6A8iIPat4y6C0BNLSgQ4Q7Sl5InMrqrFJPETBamJ2m8JeOkmE/01QGNBzPOuQ3ux8fQttv5FCOGniO0RlBOPhR7fnDD1qsk7lqJ7Qd4d9uJ
 ymDsLDkP
 sjnbSBe72Tb3PupUqKZ2ihnmYNW4ixpqW6guobFjiJ8ztcVHk+7RZ2XXzP8C9KEfVMu8chs3k9HYs1RPsqxuc3s5on/jL/rkN9nq5Jq5Dvkg7P1W7oUlAtrS4Zj0Gax1MtQXDJIzFI/OCRVTPUPexhiuCqyRlXwi2MY9Un4oN/e/SsQJzmIihXd5Pq+ingenjBXM0w2W6kp/lo++TzcALuFYcgY/wmD0dsfqBZD74nHxNNFMFTfSDbKe2DpufZtMEsNsU8m9Z6jMX4UM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Both THP and KSM manage per-mm scanning slots using the mm_slot
structure. The slot is kept in a hash table and a list, and removal from
both containers requires the same two operations: hash_del() and
list_del().

Introduce mm_slot_remove() to abstract the common hash_del() + list_del()
sequence used in both khugepaged and KSM.

No functional change is intended.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/khugepaged.c | 6 ++----
 mm/ksm.c        | 9 +++------
 mm/mm_slot.h    | 5 +++++
 3 files changed, 10 insertions(+), 10 deletions(-)

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
index 83f18ed1c4bd..5de3e91d86b4 100644
--- a/mm/mm_slot.h
+++ b/mm/mm_slot.h
@@ -52,4 +52,9 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
 	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
 })

+static inline void mm_slot_remove(struct mm_slot *slot)
+{
+	hash_del(&slot->hash);
+	list_del(&slot->mm_node);
+}
 #endif /* _LINUX_MM_SLOT_H */
-- 
2.25.1

