Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB32606A885
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 08:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZymTR8c6
Received: by kanga.kvack.org (Postfix)
	id CFD0D6B05B3; Sun, 15 Nov 2026 03:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACF56B05B4; Sun, 15 Nov 2026 03:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA406B05B5; Sun, 15 Nov 2026 03:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2ABA6B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:01:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 266A51205F0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:01:00 +0000 (UTC)
X-FDA: 85436607480.26.BC9BDE5
Received: from mta0.migadu.com (out-95.mta0.migadu.com [91.218.175.95])
	by imf17.hostedemail.com (Postfix) with ESMTP id 27EBE40006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:00:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZymTR8c6;
	spf=pass (imf17.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794729658;
	b=u2efdwYKmzJwiV7d+pOLHVyHSSLkUBttMaJyx55u5mcjn4BU1eSTWA9LJeu8tpYxJ+Tuka
	ujo9zC1To4LwAUKHTzYm4vMYw8dzhNQdPJSRay1Ey2QF29iecsBzsbmUe64So6irg9D56f
	LffEbPuAxXc9d3RXSUTFyxz0M47s86Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZymTR8c6;
	spf=pass (imf17.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794729658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60gsrEbAuJheAzPFFTSSLkUWfF1qdMXOYWZtQkOXi6g=;
	b=PrpTMoEwERu/3iJWTYb8ltxprneAxQUyQ3Ria+xPhYu3RFTDeP5YnyO7xy9/0q5J3+S5HE
	qAxOpp2gzY09+E3gAPHSLrAQAc9Aa/8mUdEwMMQwECkBgQyF9nPFem8NlR7BBLGlXIxXRs
	Drlh43HOEruOOr8HRZn41pSNAPIQir8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LNnxampF1hSfK2nrRVdNwXWnI4MpuaWWr622AzfxeHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794729656; v=1; x=1795334456;
 b=ZymTR8c684kM9FwzuUp5zPC5YO4vsYRMv/T6Au3x7vpVPdhuI4FKr9CRPjtUQ4QAGj2l3NFQ
 fULjfxof9/4bYc71ZgSp3MQCPkkth4yb/dnNqbjHDEnGTAGgPg6svqBVzmtq4zafU7uI8YcPN9y
 /VHh7yfsgB/e3UxWWJT/k3uY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6126331626ea888a;
	Sun, 15 Nov 2026 08:00:56 +0000
X-Mizu-Trace-ID: 6126331626ea888a
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Subject: [PATCH v2 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
Date: Sun, 15 Nov 2026 16:00:49 +0800
Message-Id: <20261115080049.132515-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261115075832.132109-1-xu.xin@linux.dev>
References: <20261115075832.132109-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27EBE40006
X-Stat-Signature: okdway1xeztxjxqizftmbzsuwgd5nibe
X-Rspam-User: 
X-HE-Tag: 1794729657-258631
X-HE-Meta: U2FsdGVkX1+PhhWz+BtU/xn8emBLcChvkXdI9NdysKIvlkkdacouG1YD4jRfZUZ+kYs3uKByr8cKmzBqItZhUhTaYLs/EA3X0FXb/Q4KGrn2Gda+siiW4oC0JaWrjafyIwcKEezmy/F+6l6K6CGHet0K2m5q8zFBz4m2mkIXUqBbUD3yyF/Ras+3nIB1MyaxpXRXKpmQZDxQAyWUdvnP6RNhvEERhAKhGaAc3FEXIWeQV/pMPC4vvSBKPtQOtU8dyczJBIvRSk6XBwWUX4CLw5fTH52PAznrKohBOx6qfL9Sg0UoLyScpAzBaaWOAkzNSmi/zNB/hqStOcuLyieKGnFh9tNhe5izFDOFmNHQkVoYX0IFBT/SV9evE7EWiVhiV35fm6j1w57USOSjm5k3lL+ZmEFOBVfI9x8E3RlQ5C75gYe/wcZSVa/CI4Ozi3H9mtOvRO+iWL5F9zu0xCze7D/GKyVjrYefDzYptk5RgIb6k8JlxU9X6shMG9GHtJpBIq/R1duWfBPySc8w/nw5gLhUn+PjA5+oQKsyp3DUxLCm59RTFQICjlzIYWRzMF1/ARHiXgLzNl8pXbb/j0EYZO62vq1ee7uwlKJzigWO6024L7b0GJwVqun8j1Ig65Yi45ftFCmHwODGa6AF5nkVD+DTRzyG0tKKNsyNEGCIuccUqkyoqRyfNfrG4z2ayd96De2nHiMTbE/B7fDJ9p5EPOohyEreojnIpg4HeIqVCOhu2zeHDm+VKBX9WXs8lwj88rF1uHObIVVzAsPkPB9YKHmV6daQPZfA4xENaJDT9ZQAJ7rTb/eEtaBbVyShdpg/zXtU8sfmQx+lhxVt4YQjMkCOKc3nNsZAn9a8zf0PxlBSPF0nyBJYja1qrNSkY0SYCIRyx3z6m1ckRyx+ity6erfdXfwHmPeoep8Hv3nGUkgwZ3X4wvBTxNszVKufSh3qmcamHs5s1Vl2rj56Sng
 0g4FcXOI
 xgG7wgqqTr6XbkTV5ptX3qvSqhyv81rhezhhepb3n8WceH7fcjfpHxMymsL7Ur2+Yn4Ciaqg30S6HhhvzZHqyKGssfqgQZKFJpc46k6d1rgGoXndj/C044fSJIJL9S8PdBHgJQIqW7dT+2TjXqTsIOa62UBrZj7c4eik7uRLAdZCn1rLkCvk0/gbRophSiqjUZNBPjsm174Srzzb19hbHFmcG0pNZN06/t5px7E+E6H/Wl6IsEYUnVcPEhSlKSdzk8rY6M2LXJHVCGz1n2V56miHYmf8Re72YXHjpWZvZX5RDqyY=
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
---
Changes in v2:
- Rename scan_begin_new_cycle() to scan_should_start_new_cycle() and keep
  it simple (David).
- Keep lru_add_drain_all() in scan_get_next_rmap_item() (David).
- Use scoped_guard(spinlock, &ksm_mmlist_lock) in scan_get_first_mm()
  (Lorenzo).
- Keep Lorenzo's Reviewed-by tag as the changes are minor and follow the
  suggested cleanups (please let me know if you prefer otherwise).

 mm/ksm.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 8db6743ece6d..337fcc9c6322 100644
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
 
@@ -2670,17 +2697,8 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
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
-- 
2.34.1


