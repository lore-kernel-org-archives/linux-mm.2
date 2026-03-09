Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0594EFCD6E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F80B6B00A3; Mon,  9 Mar 2026 07:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6386B00A5; Mon,  9 Mar 2026 07:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDA06B00A6; Mon,  9 Mar 2026 07:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 059776B00A3
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:56:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9B05160162
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:59 +0000 (UTC)
X-FDA: 84526370838.16.19365A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B4A40A000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRIUkNWG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057357;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKfOdw0rtpU8pZtSCYHf2LHRi3ob+u1sPHWVt4qnD6s=;
	b=nrO7njQexxtZ5HVgolDaHbNrS81NmaNTF2V4VW7nYfVrOvk08mk8S1RhiTBOiT8rc1Qk0c
	EWpC6Q8DvNKHvdC5pGCjpxniArzalPC79/8BfdnhVK+RCzWDuu8FNScpbbMkU68C7l3dmZ
	2ou26ItE5K11/1SJrelhiMnJqi1yQss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057357; a=rsa-sha256;
	cv=none;
	b=bwXWfH5e5dXCp3zzVIBPqHMolzLJU5Oqk2FSb42IxiFEiYhKVOu3LWAsRMerKBJ9snD7QU
	TiMaZzOYlNWa+ElkTShtx2HSqS9iTulcg3+BbrwxrII5HTlePsX2AOOYZDbPpMElXGHEam
	GwCUJxv/O8gGEms5oY4eAgP3aMcL55U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRIUkNWG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F0604383F;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D3EBC2BC86;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057356;
	bh=Tkc2G5v7MJj/0+toMiZPKrDMqernsxUrrJDbe2DWPYM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sRIUkNWGsABFa8kdDDrR33aTDFr/sXXQOoLU63pncZ/FqAQzJYRvhu6qjK5UFcYlJ
	 6Qenp9K4h9HV3UMFvL/MslPrggOsM6rmK5ucf9Tbm0JEvyevEDG6roA0BqAOHg+Ew9
	 7uGjcT/OKSi72L3mFMVgTn8hwLjROUAOjA9Z37tUtbVMs4KSenJontUo5flAOWbNcM
	 J3gE3K2YIs+XC73DKFau0KJiw9U79kgy4WyuSVMhfWoUoDtGIYYoCtdgPdtAU/Np0H
	 l1AWbI+vXxyWfXZJD6soigm8fzdKlwNfZDcTzvrVxeEph7FbtKgLl/g2HjLOHIrkdq
	 hv8tT8ljnLHrA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FED5EFCD9C;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 09 Mar 2026 17:25:45 +0530
Subject: [PATCH v3 1/2] mm/vmalloc: extract vmalloc_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-vmalloc-shrink-v3-1-5590fd8de2eb@zohomail.in>
References: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in>
In-Reply-To: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773057354; l=2510;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=K+fKY35rqal1HjSu0w8XUZyvTIb7GSRojmpzX5n0cKs=;
 b=tMvxDF4NmGBn266aUsP+BKfmmmHzs/OZbd58axuJ2Mp3ZLEdgFFSuV5XELVT1XA29RKBD299L
 /+X1aDNpFovBk90VI4PO/fFT8dyB3TnaE17p1U4Enf3NXpoaaJacXwE
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4A40A000D
X-Stat-Signature: z3uskoxhs5by37rj8b45chbum5rwhuna
X-Rspam-User: 
X-HE-Tag: 1773057357-337011
X-HE-Meta: U2FsdGVkX18HlBX79XsYKSDY3XiVxL4KBxxJ7UTQFZCKwPW+HTUd3pxRSORcccVbkRjBAO/0hYuin4aNzEpzQh+eF6W6jBxtbbqEhMim2vD2ubkIEVyOxz7nSyxE5UErlgVIMi+9/eO9Z2gshNmlo66KDdV504ftOF5mq2emOmp4UDssPanPj+FmWEW+SdNZvcPmlU7C4YB08cYXNDCCZempinF6ayaXT7xv7USmEuE5CPbYB0P9CY8hfnENO3YniXaeGPtRnqUJysnMpIFMk85QF3HYUXIRL2qqoEunOTFGr2KTijjW02JFX382IVbTt72Lhln0n2ez+ra6yw3kWLYjtohggX+tqmM8TBnZjaBa+1UXWWWdJTGNRd4+zC+/DaGRYW5xD71BDnC9wnh5McXOp2feaHp2YnPzgiq8+NGqS/ziP+A6LNgEiKlZRtZqhxQGEfj7CBr4mtscSiTRemINI5daRIdyRP/ToOgDBYaahOHNDqm0krPZKe77ihzyM/kIv80VX9FBwr4vxbC8GXPmyvZxCxaG6gb+AtHfZZTGPgqTzfXSvuzdvjKGnpMsTtczgZiXbjV7J6NIGwzd7ivBGybW5LSQzI5TgojalrzSg1fm22JaGnzXGPPwhvxNKYGqsWNmDUAAl053ust+c+S8HDtfWg5PsblXuH6CNuqh/PPcHNKt99k+mceDULB3tZ8ptIqE7mP6pnvNamsoOip5b4NadOksK0ykPLLJiRgUXJO5X/1nJLIvcTpGjU3E4Rv7ht/3f5xJOTwy9yoqabd8ntgIvTBWMF6BrrmuyjEuWIE6fBr+L40MBenFFFMnnYS7Fn8mnhKinHTCNhJm+ukOWstpjxJrFWP+mhQK4533+BQtGghR/rXBBRIh+xcEDabPEPTWxIZfZkSIUQ8p4mjI1VoOUnicvwDM/6YDyxetURvyjhyoH+UkW1mGF9sy4pliuDX/f9VcF+3HBGK
 UBHwbjvH
 kAhwzJJFJRijJB/z7VGDo6U2594XhQIBQsqEwoRuH1RfLBUv7KEBCOm9MypRMVrlnVZnbFzQw7A7vSKdOAx0DLeFMwRQQs9qyCtcbB02NH5rc7La3tzLt41roRhOfrI61ELRU9IDPpeY1XZtSEMBbFDA/+XXPrncCVGm+JgcKMCD4X1flMTZ4v+WpU6urKmhMhZt52AguVyZvqK6l/rabb8m+19qK4DlyJyvBzegNmV2NIvB8XGYvnpkxjWCPbK+BCQrMAwqCezvEY7vtD+Pa3LPUGZDh2ouYBYs8/ntmJB0RVigHe47jTojqFs33L8QDYkFasNU6iqQqSmxyNCx2UuFyI6sxN7ho2SLEYC6qPFPBQ0krtNV79D/dnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract the page-freeing loop and NR_VMALLOC stat accounting from
vfree() into a reusable vmalloc_free_pages() helper. The helper operates
on a range [start, end) of pages from a vm_struct, making it suitable
for both full free (vfree) and partial free (upcoming vrealloc shrink).

No functional change.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a..42ae68450a90 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,36 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * vmalloc_free_pages - free a range of pages from a vmalloc allocation
+ * @vm: the vm_struct containing the pages
+ * @start: first page index to free (inclusive)
+ * @end: last page index to free (exclusive)
+ *
+ * Free pages [start, end) updating NR_VMALLOC stat accounting.
+ * Caller is responsible for unmapping (vunmap_range) and KASAN
+ * poisoning before calling this.
+ */
+static void vmalloc_free_pages(struct vm_struct *vm, unsigned int start,
+			       unsigned int end)
+{
+	unsigned int i;
+
+	for (i = start; i < end; i++) {
+		struct page *page = vm->pages[i];
+
+		BUG_ON(!page);
+		/*
+		 * High-order allocs for huge vmallocs are split, so
+		 * can be freed as an array of order-0 allocations
+		 */
+		if (!(vm->flags & VM_MAP_PUT_PAGES))
+			mod_lruvec_page_state(page, NR_VMALLOC, -1);
+		__free_page(page);
+		cond_resched();
+	}
+}
+
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -3436,7 +3466,6 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3459,19 +3488,8 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	for (i = 0; i < vm->nr_pages; i++) {
-		struct page *page = vm->pages[i];
-
-		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			mod_lruvec_page_state(page, NR_VMALLOC, -1);
-		__free_page(page);
-		cond_resched();
-	}
+	if (vm->nr_pages)
+		vmalloc_free_pages(vm, 0, vm->nr_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }

-- 
2.43.0



