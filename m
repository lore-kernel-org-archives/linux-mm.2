Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14CFCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0306E6B0092; Mon, 13 Jul 2026 21:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC2C6B0093; Mon, 13 Jul 2026 21:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FB56B0095; Mon, 13 Jul 2026 21:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B44F96B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:26:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41B34A01D0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:26:35 +0000 (UTC)
X-FDA: 84985642350.12.60AEBE5
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf20.hostedemail.com (Postfix) with ESMTP id D8BA71C0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:26:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf20.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783992393;
	b=oPYL5v9tTYP2HZAFHFZwHzalZs9FuDx7FTUj7+ely4OkCwNemsfbFQnJ7C1lv9+5b3Mwmg
	Wsm38QO7x0V1ygGTUtXQreWQOQ2NaZJXbbhf4EQ3LkBsrVp63fnKH8XbSotFr5veWP05eL
	DVFR40sTn9OAVCXs54FCqjETizxepKI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf20.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783992393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kj/Guzt/ZLzjbXxS0ieYKeez4ypIoZ0kKmKW59xAaO8=;
	b=13Xu3R2v1RIRyc2Dc83r15s1mcCDKIMFsqCyFjyvMyovRty4ktV/2lDCqhp8kS3HEqpk9Z
	RPWbbrnIX+7uVg7Du+ZDVI+jaHx0ySO7LgMSqhIViTbZxbMLlPnpAB9ctjswcY8XV9JraT
	JFsFnzBJ9v+JkCVJdEyvXOokkOs3UAQ=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gzhTv3MWlz57KTp;
	Tue, 14 Jul 2026 09:26:27 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 66E1QLL9093958;
	Tue, 14 Jul 2026 09:26:21 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 14 Jul 2026 09:26:22 +0800 (CST)
X-Zmail-TransId: 2afa6a55903ed48-9f808
X-Mailer: Zmail v1.0
Message-ID: <20260714092622583ayzGzGYSjAareKKHt_T91@zte.com.cn>
In-Reply-To: <202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn>
References: 202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn
Date: Tue, 14 Jul 2026 09:26:22 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <wang.yaxin@zte.com.cn>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYzIDEvMl0gbW0vbW1fc2xvdC5oOiBhZGQgYSBoZWxwZXIgZnVuY3Rpb24gbW1fc2xvdF9yZW1vdmU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66E1QLL9093958
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 14 Jul 2026 09:26:27 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A559043.000/4gzhTv3MWlz57KTp
X-Rspamd-Queue-Id: D8BA71C0007
X-Rspam-User: 
X-Stat-Signature: bwhjffwt464jt7oj7bxysxka9jhca5p9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783992392-171113
X-HE-Meta: U2FsdGVkX1+evxzfVxBxL30OBui6XfojQF+Rc22LIJXvA/yKNlCDHgaaDB2t1biiROipJSK1OorjgHhN039eeY8TYeKe/m4RY0gWK97YV7nMQUd8nznOYKX8UxN1PO8OPvoAnTpABDl5khsdlDEIMEKO0sWmk64Bx+jwopol1kFd7Rd/ugh56Ult9lbMHoBTqrA+axN0YFqt9pJckWc96MD/zX+cqj7RhjELxnwz+6JHGAwInaNI375ah+CL57y6+Qhnl+JIWPO/n6B5Vk4ZIFcV0m3+8fyxBZvXExi5UdJaB3kcmTm0bviAYm5ue+kq1r3UqDNIamPANtEPwHAwU4/M9v32XwD1wzLNwVqPPotqZLT9YHr4E4AWvdVxLpPjUbxf96egxWP1GMxWgFI17Wu7OI7HDwGvKeiO9fW+6oraly+SS5UnAHXzSK5uXo3izanY4Qja6XySD3i330yeg9zG2KDwWNC8Q0DO46Dj7FCGgom+ZMN88bOJ1GsVLDqVs0AC6WSSnQqJfwm1cxffSzFbsJpI9AGWazbONGsN51yhdPiBuQCAwZt7CCHyEipPWii7w/BnfOCOZbNbK+wa4N0HN6e9lW4cLm0XZOQVFM3y1XXj1GSacNS7YDdsdZrA2Ut2wSzZjUXWgJ48px4XOhSzuavpr3UMNKG4DZmqaOIW/UfMuA786kehQomJCjn7whfUVJX8OQeq166V3aKk77a8MQRXQKREFAbEgAic6kkUFWGDiIZB6Iun3uTGsMQKFe6aZj1iyeizsrnMBg02beb3gs1nvot3dRSemDOniVVx8gCxNz29M7vLnjhfO0M09Aa5Hx66u6qzUhxjalhMrBSCM443SHf0+FOKrVjXE2vltY9QMLI5m7LnvfzcNMply5tDGGAaMqxcivv+HilW93FYAXHJRHoRifTntY5vhJ+PoWpGtnWkRKTNT1N7xjhyvH7sFOzZUJtwsfDwj1w
 kix7YycH
 ohzYIWsGIkRE+4i5FTOBQEpefBjRKmiq4rWYZZxrsIU5rl+NZoNtiL7pOAXEiY97A9JsGLnU/QWpVWmnFZZGhlQUxS7eDkpgtAZbJra0pQAt3WKhXWoLgTCvRFb6vNPyt5oyoaBo9eFooyU5Ak027ideRE2IDCbeN9qoOX4LhprMaDoIrg4xSUmmHV/ii2Z9fLLfS4gao8ssL6Z/uLQeimheqwuLjStkZbDTEa2zZd9oxQvuk8ooCeJxM4hWZCpKhN03rW8BMTmc5aa77itXqyV616oK/yNmKcN5H1V5QXpRh6ZiidB4uUDqIyczGfCf2Sy8a8hLxEF/Xvzf96u4dtuHJxw==
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
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
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

