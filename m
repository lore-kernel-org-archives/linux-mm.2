Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3792606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 01:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YbLNnzOG
Received: by kanga.kvack.org (Postfix)
	id 04E266B05B5; Sun, 15 Nov 2026 20:47:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026496B05B6; Sun, 15 Nov 2026 20:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E896B05B7; Sun, 15 Nov 2026 20:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB5B86B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:47:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D361408A4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:11 +0000 (UTC)
X-FDA: 85439294262.11.4AC474A
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5F96080003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YbLNnzOG;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794793629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QtOOOgTJEk0ghtIfvYKds3UPcto3kaLflQ2ByCpIHQ=;
	b=C2QzW+smi+gp5CUfiGORtcDfHepDnzKntxMzv5WdefElmtoiKgpa/3E27a04be7AiUofGQ
	lV6yV6DvqczCjI/OHl4ui6UTKtLsbU84oOhnOZLM6fwUSbgPU2yiS26ZUH+8g/Z86HsvMY
	dM32dgO8Xugk2p0IPxVyQyjeWnY1/lo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794793629;
	b=3+lDIM2mvHaFv1p81CFRGoQ+c4PdOfSG5F4gjn7yK1vrxAiglLHQXovoqX412oQMKAyNdm
	G+7kFjHd2BFp38DKzqDGVp/QD6/rHY5hZw1Po6o5X2xHs5T/oK+LVkIMuGLP0ukmG4GD49
	ZD6Vw3MBWdmGpj8zBs+dxgqjb5ZLZgg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YbLNnzOG;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DWRrwENmkaJP3hHecdwh0EFbZQASgLdcHnLDgfl/cBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794793628; v=1; x=1795398428;
 b=YbLNnzOGph4KVAnhewxJqNXw1ifmsZv2ZEW36G5YRi29xFfXqRi7yT7XVb2mzVVkaP0vBAIr
 uyTnpamZ38tGCLHp1v5kIqWb//r447NHp49j6DHMVvtF957Pbw+O3YK/QWtHiLLyVD3d40rNyBn
 CALXc1Fju8iVjWsYykQWAy1s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 75d66f80df2d3fd7;
	Mon, 16 Nov 2026 01:47:07 +0000
X-Mizu-Trace-ID: 75d66f80df2d3fd7
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Subject: [PATCH v3 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
Date: Mon, 16 Nov 2026 09:46:55 +0800
Message-Id: <20261116014655.310486-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261116014434.310003-1-xu.xin@linux.dev>
References: <20261116014434.310003-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s3phhqdf7tdibrjanfns5j78gwoqb531
X-Rspamd-Queue-Id: 5F96080003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794793629-47693
X-HE-Meta: U2FsdGVkX19S56rSjMwv9DFZ0JN0c74QuUgG677fnYZxqxtmANrW/h3papRx6UCnRVSOvPChHwfaJ9e0TY5f1ytOSnsMF/Xz/V/4IwuZSeQSUqcAMdt/oxgwQtDnrbi/qPz3QmTNaRNeH8RqUtMGY28FQCS7yXuB0c+tb6nAKshKP7dPRjmeUUmCp4+L+/qAgqTn113VEd/ako5PuXGdlVPHBU/MC4KX1kc58hV0DYKNWbaAeysVQ08st3T2zS0wMwCUi8dK7BYn1AhpGrBDo/WSh8fmo8/PsZ/PxncojVj4RuwewtLAnRaXdpEqbvvUL4FehJH3dAljjd+YHcV3WoG/pHPTriqGF0+QMpCps4VDX7VNd3o28mI37wryZ4Scziq/kXvaZRSmoQHYB9RHbMeRcaEq1p3mhUPZOnxeWN53o0nmchDqGO3svlcRFV/NvchIxkGYxjzHzvsABH19a7uhg8l8U13nSyWbD435bIb/VH40riJljuDRTEQcLl4Oj4ACMXMQM0gnxaWhrNBTFlwpftB5e1DunE7ltrB1THyZVRhX2KTVAisEPPteTJlFXAJbi43D93WJK9MDDnP8ShyS43lS/8Ha8MLdomoAGU2smJtsBgY3bmjSB3dhucwkuowIXR74MtBHd4IgwNwMUmv5mdYu5pl1rWDtIOK2VuXP4ZFXCn/zJpguv3YH0TS5B5MFgS+cbB0SsUXzXGVjmWFqciCMgOLdoapQPQw2SN0zyjS/F0GnjdANcFRt6YpgCqd/gXmHiSGNDTir9Ya/CUSeSH51OTJqjgEKJYfNSSEFA1Ze49BF3UE3ODmxdAXnmFF9iYAVyxiSTmsk1PDU6M8nZbnSxScNP40YD/NBK9zORbPJvNUhjsAbsIBjKvq2I8uiNO7LpSEtdge3RijIeiP/dADjuCdZ4KTJAS+jEiqL/pW9eKQQpMlt7o5pwAJF2w5ITrCKKR/mN6+4yIc
 mQFHLRrk
 jeIJCgoKnRKeY+r1ErQ9X2C+8YltIu/0KUMZCEZyo2La7gaYHATi9QUAY0Fyj3K/RjdweaoIgw2satHSBUVonC77cWbV8o7b5/EvXWw4me3uBRkMJWEi36aoHOjqG6FZfYEElFrvCktWCi2CKLQ+lP8Bz5x8s6+1HISsvG4EWPZ3VNLkCts8w74IlPEiTKx/gCLCSCSS6gHn7Xk+w2TaQhHtTK+1lqU5LKDOEADyfPo9jdDwvGjgKHkqRXjIrN8xFgZq7wq/SWqrY497sYmtVlhvNYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extract the new scan cycle check into scan_should_start_new_cycle()
and add the helper scan_get_first_mm() that advances the scan
cursor to the first mm_slot.

This keeps the exact execution order intact while making
scan_get_next_rmap_item() cleaner and easier to follow.

No functional change intended.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
Changes in v3:
- Initialize mm_slot = ksm_scan.mm_slot in the else branch when continuing
  the current scan cycle, fixing an uninitialized variable warning/bug
  (kernel test robot).
- Drop Lorenzo's Reviewed-by tag due to the v2 bug fix.

Changes in v2:
- Rename scan_begin_new_cycle() to scan_should_start_new_cycle() and keep
  it simple (David).
- Keep lru_add_drain_all() in scan_get_next_rmap_item() (David).
- Use scoped_guard(spinlock, &ksm_mmlist_lock) in scan_get_first_mm()
  (Lorenzo).

 mm/ksm.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 8db6743ece6d..89a3da4a4874 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2638,6 +2638,34 @@ static void ksm_reset_unstable_trees(void)
 		root_unstable_tree[nid] = RB_ROOT;
 }
 
+static bool scan_should_start_new_cycle(void)
+{
+	/* Check if the cursor points to the head. */
+	return ksm_scan.mm_slot == &ksm_mm_head;
+}
+
+static struct ksm_mm_slot *scan_get_first_mm(void)
+{
+	struct ksm_mm_slot *mm_slot = &ksm_mm_head;
+	struct mm_slot *slot;
+
+	scoped_guard(spinlock, &ksm_mmlist_lock) {
+		slot = list_entry(mm_slot->slot.mm_node.next,
+				  struct mm_slot, mm_node);
+		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		ksm_scan.mm_slot = mm_slot;
+	}
+
+	/*
+	 * Although we tested list_empty() above, a racing __ksm_exit
+	 * of the last mm on the list may have removed it since then.
+	 */
+	if (mm_slot == &ksm_mm_head)
+		return NULL;
+
+	return mm_slot;
+}
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2650,8 +2678,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	if (list_empty(&ksm_mm_head.slot.mm_node))
 		return NULL;
 
-	mm_slot = ksm_scan.mm_slot;
-	if (mm_slot == &ksm_mm_head) {
+	if (scan_should_start_new_cycle()) {
 		advisor_start_scan();
 		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
 
@@ -2670,21 +2697,15 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		ksm_prune_migrate_nodes();
 		ksm_reset_unstable_trees();
 
-		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(mm_slot->slot.mm_node.next,
-				  struct mm_slot, mm_node);
-		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-		ksm_scan.mm_slot = mm_slot;
-		spin_unlock(&ksm_mmlist_lock);
-		/*
-		 * Although we tested list_empty() above, a racing __ksm_exit
-		 * of the last mm on the list may have removed it since then.
-		 */
-		if (mm_slot == &ksm_mm_head)
+		mm_slot = scan_get_first_mm();
+		if (!mm_slot)
 			return NULL;
 next_mm:
 		ksm_scan.address = 0;
 		ksm_scan.rmap_list = &mm_slot->rmap_list;
+	} else {
+		/* Continue scanning the current mm. */
+		mm_slot = ksm_scan.mm_slot;
 	}
 
 	slot = &mm_slot->slot;
-- 
2.34.1


