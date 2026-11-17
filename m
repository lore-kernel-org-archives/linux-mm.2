Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE32606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F/HxyvAJ
Received: by kanga.kvack.org (Postfix)
	id 77E7B6B05B3; Mon, 16 Nov 2026 20:52:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755A26B05B4; Mon, 16 Nov 2026 20:52:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D4B6B05B5; Mon, 16 Nov 2026 20:52:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 440486B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:52:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABB61C02CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:52:36 +0000 (UTC)
X-FDA: 85442936712.23.056FD9F
Received: from mta0.migadu.com (out-123.mta0.migadu.com [91.218.175.123])
	by imf26.hostedemail.com (Postfix) with ESMTP id 92565140003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:52:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="F/HxyvAJ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.123 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9FDV9LumLwaqMr3fWi1CRMLzPuNQVlo3nMvXwW4siU=;
	b=mGxPnI/K9UX5lAdKX65NV2Sz/FcPOI6wpQd7cpYPRgB2Zvqwl1ri/DDDrgVOTerOgqsnWU
	p2EHesChS/to3/OFYcXYEqKbLGukOpo6ooAlwFzyiUsSaEfk4pWLYkrKiKahxxKQ0ovzIQ
	ORqJOZbgaSubFvBuio6qsVIlU2XBcy0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="F/HxyvAJ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.123 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880355;
	b=JvejJV+FzSclhkDTUKHqc63FGX5DG3HbwtE326jMLYNCFPB+ySBxLyqTfV8bf54izSxq12
	G43F3PPsSAyEGGDNCUtw4N3iLFTVFmzNuWR8XIPm6HQzUHhDGQaQfV+zUkcQtfpcRFO1E7
	g2T9t0gduqLMfSOJhE00O/k5R6V6lb0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2O4eEcW1l7j4Rs7t0E8EUthAkAbvzAeMUpu0A8UhMSc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794880353; v=1; x=1795485153;
 b=F/HxyvAJcB8YtJNg9x94+tZqUz2sQeFdv/Odm7E5qzW8ansC4ROhk6rHTK65ruoW9Rag0e3f
 S5kbUsk/gWwfLSx+ofPuRryDJqa/3FAAWv4adU0fXCknlID3fYGkGEREVVqJ65pVHqCRiqghmKi
 TbJdONBE1sCeKrH1CFmiDSjg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e29ae49de9410c07;
	Tue, 17 Nov 2026 01:52:33 +0000
X-Mizu-Trace-ID: e29ae49de9410c07
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Subject: [PATCH v4 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
Date: Tue, 17 Nov 2026 09:52:25 +0800
Message-Id: <20261117015225.618954-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261117015009.611551-1-xu.xin@linux.dev>
References: <20261117015009.611551-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92565140003
X-Stat-Signature: r5bqg6m96jos5wp4kehb3oggy9awmjiq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794880354-972475
X-HE-Meta: U2FsdGVkX19kRybg3WksfRE93iMIWzFXoN3TGkCu7TQIqs/JIXDbP2/JoxhYgSQVAa93PZQthZD5XnNCYIBxpedE/XRPrukIjaw2MYWF/WGrYRQNbFNm2LFTapWQuEks7IHKuf5mBTUo9GNZKQq8zd855Yz6ZiewvF1GyRNXDaofwX54bQWsW+jkzA3rQJ+Eg0Q4b1R6E/IeUzLub7opylZDGUs5/4/uXgbsBoI2ILZ+k9sB6KrgBNPTxexnXHOfirbb5dL02BD9Qqgm9hfm4ngWwA/ZsWk+tKFx6+DGfPGTcpgz544gZ+Adq0LlXXJgPVgIUchgMPOQsDsGs1m1+F/4IYBfMovv5hyEXLpnQpZukDlWaJNW1pr8+Xa5oflkXVeTW4eOMERflGybsk+zCdLq/LtniGe1/BPHqfV9i2xEzj9hQG752oTh0j01Qt5WHqqC97iYdLa0hwLHs7Menmdwlt54sUypAtEgAEdCI6fr1rVSjT0HW3h2Ibygq5Zj7/HAlbiNSFsOMZtpIiLYnhZeYDw13EczYqtPcHBNoPDxtQrp/SLpsjnN5HVnEPAIRIfvgwg1WUo8DPD3hWviwNwUFBBGPa7y7Ru0nUA1GiksVg1aev4BLD+WRvymUvGeW3gq1Gp2oxEpDQtSP0u+20xn4K+tYg8C/ZWh1XLpMLFdDUSM/KoH9mncvgGTFLhOxBtDF8p7NFOgQrM6zRqXqNUKBK7MOgOQT/J0EtIGEXmJRixIbRCl6hk+hbXJx2SHTNzYwuKrxj7gUOWxEesG3Ny8tRqkGrNkmZzitzyEixfHoOlJpaVOQvg7rU7V7x/bB+u2zWPXZaMF1tlvEY2yhDaegAJXId07HXIrxZQnvo7Lq5cKKCoIZ/mMVOzfChC/KRJ3DGk0kBijxBS6FZ0iJIgH0GrdFe1oxrI8ajhHOo33qZGPuTk6aecg0MeKyJXgI3bFGx0YDPXZ49Aw5I6
 vxC5huR+
 AiUJEHFVhrUXu8h7wws593tqQScXQsw6p7Yefxd7aTP1RbwvBF30q+lqM/+do3DQa1VOEZ1QcQJ1fP5NuScnV/ZHF/TISDAXVEsqpv8Svtsh5WVN7E9zy+IV0/EsAFipP+S7diUEg6lPgPn5nEIC8Cri/Vx8b4SZYm2p4VWgptch5jSCxbQnAufwAJi58LKHhhHU3IiTMscaDikS58/c51g27f+wDFci5IedodIIAMy9733he/l7OSfY8OYGrHM6+MvHsfJVw4hvUbRnajOrliAPzjejgDczyOp9Ewp4TCAXwgwM=
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
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v4:
- Drop redundant comment in scan_should_start_new_cycle() and
  update the comment in scan_get_first_mm() to refer to
  scan_get_next_rmap_item()'s list_empty() check (Lorenzo).
- Add Reviewed-by tags.

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
index 8db6743ece6d..80d036baa88e 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2638,6 +2638,34 @@ static void ksm_reset_unstable_trees(void)
 		root_unstable_tree[nid] = RB_ROOT;
 }
 
+static bool scan_should_start_new_cycle(void)
+{
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
+	 * Although the caller scan_get_next_rmap_item() tested list_empty(),
+	 * a racing __ksm_exit of the last mm on the list may have removed
+	 * it since then.
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


