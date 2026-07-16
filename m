Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CC9C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42C76B0158; Thu, 16 Jul 2026 11:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1ABC6B015B; Thu, 16 Jul 2026 11:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57E26B015C; Thu, 16 Jul 2026 11:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 915036B0158
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:34:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F28EB80114
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:46:40 +0000 (UTC)
X-FDA: 84994311360.11.6F4D784
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf28.hostedemail.com (Postfix) with ESMTP id 69197C000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:46:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wS1W7Jwe;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784198797;
	b=HmoLZQA26McwiyPxjhOSxE/DCIXJvzl1G9ilKj4p4am77p/kl/Jw0GvWdRoAh+/bLDEnsC
	E6Gm1ND376q/aVSXPBywAkh9VhKU2aiixkxACT1wbeYF8/fklnMk57Fqadlq44cZi2X7z2
	XE6qV5wRpX8JbvwrR4m5l6pzvpu0uI8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wS1W7Jwe;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784198797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2e24JcVi84RXCgGQTG7+PHh4Tj/SHur87NM9gxSnaA=;
	b=Y2a1K5TBA0EE60w5sF8QTBpfsYcyAeT2w3USF2pG9Rn1VPjw4TqAW99Qy3I5narpuaB9xW
	uWa+QB8wliPIX9mR22eu4yCIMEJi20K99vEoT7WuUj0p4mStXzpyYImziWoJZMc9ZBrfJW
	gwuM2vUxJFpSL31nTpEUmZtogCoaW/k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784198792; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=z2e24JcVi84RXCgGQTG7+PHh4Tj/SHur87NM9gxSnaA=;
	b=wS1W7JweTWegguOkn3GZiVxiZaCY9pjiaarls7ZBoyObIJ1H3kqhhbG9PE1uNUNglNCpf8DYwSaMaRFHGvII4j1+d/WKqJiEgdcGA0OI1S2fQf4XLZvpUVcUK1sjby+cZQH1siKWFswgF7u/h4pfSMlQXTUCt20tb1VLLDofMKw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X7E6b9Q_1784198789;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7E6b9Q_1784198789 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 18:46:29 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm: vmscan: convert folio_referenced() to use vma_flags_t
Date: Thu, 16 Jul 2026 18:46:18 +0800
Message-ID: <5f2c0400e6a58ad2e61cf355c310a37b208fe1db.1784197559.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1784197559.git.baolin.wang@linux.alibaba.com>
References: <cover.1784197559.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 69197C000B
X-Stat-Signature: kpjhzaipyppy8fdydfr7cxh9egs9d8b3
X-HE-Tag: 1784198795-85687
X-HE-Meta: U2FsdGVkX1967k6+AM4qPi9eOWAO69eybdOtb5OjBbGRqEZIGErvxZk55jK2kmIJ9LfiQzc55QslLmVFrlfv/Pb0d5EUBIS9ThmmVr0p88MkSMDEvihZb7ACtArm6z2vzOVdu01sKCGnQxM/bsuzVXSpfjWWJ3vByqQE5/Y3k4ZB7D8DDDkAT2LtRcleV7gtFX6OCYI9zinN9wvj/YqS9+RmPPWVCliTqOcPrnEu1uQBZRrxSN6Y9MGBzicUsdTe2RZmAIBcwB3sRZO40snx6np+9MeOZy/VuefDpN5hUBXzCC4pWQ367gK+jq7ok9QtKHkAXnEuPUqoEVPtvAewN+H3dZS7nuDlNe3EhCBZNHYizNer3WLsgOYMq1sffNE99zcJce5SS//s5bKA3UYwRd0SS0RunVRvyrfaAUb2eJF61IrxyZyvFw85izQ4hIQnVENEW1UIiPtD84KFKSbgGrD6ldaQazBRAzXNjjDcs/dV1V/Tlo5fOLRrRJ4+F6J7r4VrsYMJPYtJBcXeatf092iEL/sECJJykgXrOe1CdhyRELaGXLHqE8N0AD46Z0iOVWxZyCYIbQ3rcDZCL10lideCqFl9RiyyLZyoDF7x9/O9f9TQvwsq64PCHF6PA1N0XNyrqdwuwu1bBj+JNozldIqBJxEcJU0fhJZtaPo+MjOc/AAus6EWg99T10oDObPkKSdhRcpbQCkw1dQnHGypYYJoCwONbweUH8jnjuYzNqG/3tIyiLuDVbzDEo9+Dm79JvOsIVV6NcnyefpKz8tUuu3o3A2j2oe0lD0VFo504PB/IQzcf5v4L4gMYi5nu0pvcQsI5K/k72jqX5dGy7pxSXguj5Qsu0l+QNL9b2g9PtGtqmW7sCaCemWfG0ctLfBsXTka3PpW8Ux4K8FL/hf1hOYquoB5M21cTG+7XYzKl4kNCoHurXjGIRFvdxwC4gT57edKIi9CNF88jNjIvHw
 VGSAmTds
 5+tAMKey7OISIdb+VRacoBvlNFvZ1T15Cwykl+lKQLEqxTh8AwRzVBK+/1G8lhUxjbbqMi5LiahaX4HRH6u1tHlrnb6BtYplpuS7nuVBDLkCAhFmftOKbh+aUWToEickIE6flnlxVRRFAL8LV73vkg9wr2xcsBtz8m7aSuXKanyiroW8g4boC2T+kIRjsUWzu37yBX4l7+dMh+dzUUXn8f6P4gJnbCe4TNV6HGloZftGQNkF11FqKGyYO4sjl9fND8b/3hMhUK0RTZrxAUiIGQInkjNwFWwM/AF7gRiVz8Tl4Vds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace use of the legacy vm_flags_t flags with vma_flags_t values for
folio_referenced() and related logic. This is also a preparation for the
following changes.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/rmap.h |  7 +++----
 mm/rmap.c            | 19 +++++++++++--------
 mm/vmscan.c          | 14 +++++++-------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..e090aa09825d 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -843,7 +843,7 @@ static inline int folio_try_share_anon_rmap_pmd(struct folio *folio,
  * Called from mm/vmscan.c to handle paging out
  */
 int folio_referenced(struct folio *, int is_locked,
-			struct mem_cgroup *memcg, vm_flags_t *vm_flags);
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags);
 
 void try_to_migrate(struct folio *folio, enum ttu_flags flags);
 void try_to_unmap(struct folio *, enum ttu_flags flags);
@@ -975,10 +975,9 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 #define anon_vma_prepare(vma)	(0)
 
 static inline int folio_referenced(struct folio *folio, int is_locked,
-				  struct mem_cgroup *memcg,
-				  vm_flags_t *vm_flags)
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags)
 {
-	*vm_flags = 0;
+	vma_flags_clear_all(vma_flags);
 	return 0;
 }
 
diff --git a/mm/rmap.c b/mm/rmap.c
index e854679553b9..4085540b6a25 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -907,7 +907,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 struct folio_referenced_arg {
 	int mapcount;
 	int referenced;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	struct mem_cgroup *memcg;
 };
 
@@ -926,7 +926,7 @@ static bool folio_referenced_one(struct folio *folio,
 		address = pvmw.address;
 		nr = 1;
 
-		if (vma->vm_flags & VM_LOCKED) {
+		if (vma_test(vma, VMA_LOCKED_BIT)) {
 			ptes++;
 			pra->mapcount--;
 
@@ -947,7 +947,7 @@ static bool folio_referenced_one(struct folio *folio,
 			/* Restore the mlock which got missed */
 			mlock_vma_folio(folio, vma);
 			page_vma_mapped_walk_done(&pvmw);
-			pra->vm_flags |= VM_LOCKED;
+			vma_flags_set(&pra->vma_flags, VMA_LOCKED_BIT);
 			return false; /* To break the loop */
 		}
 
@@ -1015,8 +1015,11 @@ static bool folio_referenced_one(struct folio *folio,
 		referenced++;
 
 	if (referenced) {
+		vma_flags_t vma_flags = vma->flags;
+
 		pra->referenced++;
-		pra->vm_flags |= vma->vm_flags & ~VM_LOCKED;
+		vma_flags_clear(&vma_flags, VMA_LOCKED_BIT);
+		vma_flags_set_mask(&pra->vma_flags, vma_flags);
 	}
 
 	if (!pra->mapcount)
@@ -1054,7 +1057,7 @@ static bool invalid_folio_referenced_vma(struct vm_area_struct *vma, void *arg)
  * @folio: The folio to test.
  * @is_locked: Caller holds lock on the folio.
  * @memcg: target memory cgroup
- * @vm_flags: A combination of all the vma->vm_flags which referenced the folio.
+ * @vma_flags: A combination of all the vma->flags which referenced the folio.
  *
  * Quick test_and_clear_referenced for all mappings of a folio,
  *
@@ -1062,7 +1065,7 @@ static bool invalid_folio_referenced_vma(struct vm_area_struct *vma, void *arg)
  * the function bailed out due to rmap lock contention.
  */
 int folio_referenced(struct folio *folio, int is_locked,
-		     struct mem_cgroup *memcg, vm_flags_t *vm_flags)
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags)
 {
 	bool we_locked = false;
 	struct folio_referenced_arg pra = {
@@ -1078,7 +1081,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 	};
 
 	VM_WARN_ON_ONCE_FOLIO(folio_is_zone_device(folio), folio);
-	*vm_flags = 0;
+	vma_flags_clear_all(vma_flags);
 	if (!pra.mapcount)
 		return 0;
 
@@ -1092,7 +1095,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 	}
 
 	rmap_walk(folio, &rwc);
-	*vm_flags = pra.vm_flags;
+	vma_flags_set_mask(vma_flags, pra.vma_flags);
 
 	if (we_locked)
 		folio_unlock(folio);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 986dde8e7429..de62899c108d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -861,16 +861,16 @@ static enum folio_references folio_check_references(struct folio *folio,
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_folio;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 
 	referenced_ptes = folio_referenced(folio, 1, sc->target_mem_cgroup,
-					   &vm_flags);
+					   &vma_flags);
 
 	/*
 	 * The supposedly reclaimable folio was found to be in a VM_LOCKED vma.
 	 * Let the folio, now marked Mlocked, be moved to the unevictable list.
 	 */
-	if (vm_flags & VM_LOCKED)
+	if (vma_flags_test(&vma_flags, VMA_LOCKED_BIT))
 		return FOLIOREF_ACTIVATE;
 
 	/*
@@ -914,7 +914,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
+		if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio))
 			return FOLIOREF_ACTIVATE;
 
 		return FOLIOREF_KEEP;
@@ -2065,7 +2065,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 {
 	unsigned long nr_taken;
 	unsigned long nr_scanned;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
@@ -2109,7 +2109,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 		/* Referenced or rmap lock contention: rotate */
 		if (folio_referenced(folio, 0, sc->target_mem_cgroup,
-				     &vm_flags) != 0) {
+				     &vma_flags) != 0) {
 			/*
 			 * Identify referenced, file-backed active folios and
 			 * give them one more trip around the active list. So
@@ -2119,7 +2119,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio)) {
+			if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio)) {
 				nr_rotated += folio_nr_pages(folio);
 				list_add(&folio->lru, &l_active);
 				continue;
-- 
2.47.3


