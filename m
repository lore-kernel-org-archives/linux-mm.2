Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0212606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=h3IiHOrW
Received: by kanga.kvack.org (Postfix)
	id 2A5B56B0939; Wed, 25 Nov 2026 03:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256986B093B; Wed, 25 Nov 2026 03:42:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1466B6B093C; Wed, 25 Nov 2026 03:42:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2F736B0939
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:42:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79E0AA8B34
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:42:33 +0000 (UTC)
X-FDA: 85473000186.22.6083984
Received: from mta1.migadu.com (out-125.mta1.migadu.com [95.215.58.125])
	by imf23.hostedemail.com (Postfix) with ESMTP id 60DFE140009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:42:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h3IiHOrW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.125 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596151;
	b=ilqxYRYKzmuFdcattjxXe8nlp4B83smU6eiDW7dQJ+Mp0B00Wf1CAhBBPoRk4IWB2CDDzs
	yadEk+YOLboY3gVbswchF1ot0IcHTAGrOfB2zN1IT2Rmr/+zmhBtzdo3lQhPaqZPpodooY
	IwFMnvaZTui9WfUW9gqZy4z6CI/EDEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZSvh4Qwu0h8OJdR8+MiT1ZzApUDwrQReChmK7wamOaE=;
	b=PBgt/sPLmMAH3/BRijGhyuridyibfDArsZ0MNGzemSTDkshTS6zljshtlJN1l1WVXwMtAX
	f5vM0gyX+Bfh5YENa8HpQfue44XSld5clLVlvB0/iY3kleLNT/wgjzQmKnWlNSgnw+siev
	6fTNkD2bVPvODueGKmQ9aT5R+NGYRqk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h3IiHOrW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.125 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sJ/2ZbzaqcfeCaxGMm3EfPm8Ar39j5+iRnGJrB7nvUs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795596149; v=1; x=1796200949;
 b=h3IiHOrWRs95/O+DTtGWrpA7RlLiQN4DX9yNaBXtQn4TeFCQXUAVhGZN/LP2F1S4OOJxgXVe
 TFkSbuc1YQlCNGGMVHT9jlv6GbgMYgqWOSsa0vDmMwTwVCqksQy6SbCcLH1o4ptvAmtxXOUuGDB
 MfTeTiatzOffL46ErvwqHVdw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8fa35624655c959f;
	Wed, 25 Nov 2026 08:42:28 +0000
X-Mizu-Trace-ID: 8fa35624655c959f
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: david@kernel.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	akpm@linux-foundation.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/mm_slot: introduce mm_slot_next() helper
Date: Wed, 25 Nov 2026 16:42:05 +0800
Message-Id: <20261125084205.345860-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 60DFE140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oe8uah5pwqia7jr7qhnxru3ag4tyhhqa
X-HE-Tag: 1795596151-191712
X-HE-Meta: U2FsdGVkX1/O/g0/DfHLmAxwm83VUc+0UU3YDjpMKjnhu9aXghP7NRGPGOiiQSK2azR494VwsarsZLS5OajmFsW7ZVpddAnc7K2RCt/Ha9qO7+9ks7MXqjpFPs3gMBGq6vA0X9R/8FM1+a0ZNCe3kk2icNClohSpWhw1GmY8ienkz/gW+Cxj002QSfxtKUzjBcCNk6Klj75NE9MdonWhb6FMC7RYmAuRQjgpDHSX/r5fHLJpIgPt9MQbGPbWos255bSWwrakn63O9WM91LlP4ceRmdgedRaw2sG8yLIOMJ7hk/sFRabg0dFXTVpNRO9fWJvkgVpBCvVz787tOmzezm0mVdE91YyZ6fhIpkJXWLvdloRFi8EJ1gEjTwVQz6KBOnT+EZFIAYoX9JtYDFn7HiPbWijQJw/ml6G6fE0vYAH9mBA+sjHCIPqFWWDu1giuIFsC4HWeZIjiAAbm+4HMh0I6PaN1gKZw2KlNBl4CrQiqj02+rZFfyz92+Ud/hwQo5mnKtY1or3qNDqZPftClLyFEvuGqODvNPmRYzAq6feRkOcta55yzrcQOeX3VAFML2qh2Rtp5AZEIK2xLmOpwnw+ZQmLSoFw2fnaaYeIdmTqwxrE/sRN3+ArrJi10AmRfNSrPSpzN6x5EgrjELqL6qeKwPtdGTQX49OenK3OaMXBDa9RUoj8vSWOzR8JYrYsD3rEIP2RGhD5ofD0PIlIpEaFL5fxeFhTBqKgGVGvFG7WBf1IaNkC/TK2kG8aDdgZ251IKBl62yqTMbie93o7PEs3fYVcMaG68uyh8XrrtKTQg9aB0+GmhzuBTXt2thRvwnGP0ScFR+dINlKaSqLbyiDBDb12XXWfSbrKZF1SIC2b804v7NgvDAOSrp6KQftGIoqwz4IZCdrcx6oRhJ0oI6dF/X4agkcX+62crBasVWBhsYiGjF81X0eA2uOWYo2DO2hGKi84upPqgVKvwEzY
 /rsc11R7
 /or+kyXBd4+F0BXq70xYzeapulGHiezrkgCVmkT+xW6pAEfF0ZW6aRhkOpOB0tHiRT+i6gjrmtaLUHJGxu6mMdrL1obeLAk2t29GV8TihmfB75KmBa3UhrBjVKZ3dOtYe5IgpA2wG9LZ925WUiTpF6le70uFXxkXwt8gtNMgy6xOxs50cqPDAhUQn35J4uMUKCxQdaEHbLvmOy6ppGeWkaSAZNLPlRGgTLT/SOlXbDb+OGbj1bhik7PulUcq+bja3SZgLWwXyy0yuE85FuAVGprPVWnGHGaN/MiwhosCtbcYqB0pLYrQ+UPWWWdudcGfUxWLe7PZsW2NdjKAF7GYQaHZMktFCfOAQlH03tC6rpTAaLqwbxC8Kv0TchmfLVeQfuEvXxx7IAPUD0Kb9PAp76rcUOBA+WPsnl97Wsf1p0EXJkg4dBd9EKZ0xCK8nu33EVgX1L8zcOMCCLRfjuRZEImvKWThAaCaWWj3jnyAL2ZM/Dv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Xu Xin (vivo)" <xu.xin@linux.dev>

Add a generic mm_slot_next() macro to simplify getting the next
mm_slot container entry from the list, and use it in khugepaged.c
and ksm.c, just for cleaning up.

No functional change intended.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
 mm/khugepaged.c |  5 ++---
 mm/ksm.c        | 18 ++++--------------
 mm/mm_slot.h    |  3 +++
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4ceb1b16c03c..0a5c78d01159 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3074,9 +3074,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		 * mm_slot not pointing to the exiting mm.
 		 */
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
-			slot = list_next_entry(slot, mm_node);
-			khugepaged_scan.mm_slot =
-				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
+			khugepaged_scan.mm_slot = mm_slot_next(slot,
+						struct khugepaged_mm_slot, slot);
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;
diff --git a/mm/ksm.c b/mm/ksm.c
index fd2d212cae79..11914f649a73 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1217,15 +1217,12 @@ static int remove_all_stable_nodes(void)
 static int unmerge_and_remove_all_rmap_items(void)
 {
 	struct ksm_mm_slot *mm_slot;
-	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	int err = 0;
 
 	spin_lock(&ksm_mmlist_lock);
-	slot = list_entry(ksm_mm_head.slot.mm_node.next,
-			  struct mm_slot, mm_node);
-	ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	ksm_scan.mm_slot = mm_slot_next(&ksm_mm_head.slot, struct ksm_mm_slot, slot);
 	spin_unlock(&ksm_mmlist_lock);
 
 	for (mm_slot = ksm_scan.mm_slot; mm_slot != &ksm_mm_head;
@@ -1256,9 +1253,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 		mmap_read_unlock(mm);
 
 		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(mm_slot->slot.mm_node.next,
-				  struct mm_slot, mm_node);
-		ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		ksm_scan.mm_slot = mm_slot_next(&mm_slot->slot, struct ksm_mm_slot, slot);
 		if (ksm_test_exit(mm)) {
 			mm_slot_remove(&mm_slot->slot);
 			spin_unlock(&ksm_mmlist_lock);
@@ -2647,12 +2642,9 @@ static bool scan_should_start_new_cycle(void)
 static struct ksm_mm_slot *scan_get_first_mm(void)
 {
 	struct ksm_mm_slot *mm_slot = &ksm_mm_head;
-	struct mm_slot *slot;
 
 	scoped_guard(spinlock, &ksm_mmlist_lock) {
-		slot = list_entry(mm_slot->slot.mm_node.next,
-				  struct mm_slot, mm_node);
-		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		mm_slot = mm_slot_next(&mm_slot->slot, struct ksm_mm_slot, slot);
 		ksm_scan.mm_slot = mm_slot;
 	}
 
@@ -2789,9 +2781,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	remove_trailing_rmap_items(ksm_scan.rmap_list);
 
 	spin_lock(&ksm_mmlist_lock);
-	slot = list_entry(mm_slot->slot.mm_node.next,
-			  struct mm_slot, mm_node);
-	ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	ksm_scan.mm_slot = mm_slot_next(&mm_slot->slot, struct ksm_mm_slot, slot);
 	if (ksm_scan.address == 0) {
 		/*
 		 * We've completed a full scan of all vmas, holding mmap_lock
diff --git a/mm/mm_slot.h b/mm/mm_slot.h
index 9b09b68e5742..303da2cef759 100644
--- a/mm/mm_slot.h
+++ b/mm/mm_slot.h
@@ -33,6 +33,9 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
 	kmem_cache_free(cache, objp);
 }
 
+#define mm_slot_next(ptr, type, member) \
+	mm_slot_entry(list_next_entry(ptr, mm_node), type, member)
+
 /*
  * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
  * functions because the hash helpers (hash_for_each_possible and hash_add) rely
-- 
2.34.1


