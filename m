Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E54CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153E16B008C; Tue, 19 May 2026 08:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128006B0098; Tue, 19 May 2026 08:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33A76B009B; Tue, 19 May 2026 08:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA2396B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:12:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 954A61C01DC
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:34 +0000 (UTC)
X-FDA: 84784057428.04.D6C1E8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D4071C0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ovz1yWUW;
	spf=pass (imf21.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192752;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gb6jFUHN1a6126MJ0XsCk9+oJFZLfQkvJJYpwILBaQo=;
	b=SM/OK9EQWSNOTHp7EiFvLDVWegtJ7AsYJanpT+AmoJx6YbBgYL6KJMSA08fGwP5YD0sYcK
	I6DGJV141YIoAOzJFhXgyhjv/HF9IDAAlg3q5gUMJKC3kKi/xRD7GRQG5GaS2hXGnTFFtr
	U+g5lMiyeiUPUicPKYcSKg4o2eDV8sQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ovz1yWUW;
	spf=pass (imf21.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192752; a=rsa-sha256;
	cv=none;
	b=lwkaVyp/Buso8rJDIvmcJLEtBp4sTPdkBOrAsXp1k4bLXva6f+2Z1Mg07oHLMg9P+v2gjL
	DJqUEEqa+xvbpt3IwjzmpMoRpRwAgcbPh/f0Ujj2VHmjmD97uvOa9+e9i7xymR/xF4GRtg
	wkg6RYguIKgDMd94+kZvyB5WzK0DJoc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5514D4421D;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30406C2BCC6;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779192751;
	bh=JjaSFuYe7b6lS86dH1GkDUShlw+lnlW94v+/M0gOE9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ovz1yWUW9o31ZcoZahosrguXg/SML9syMt9vNwgc5+xX21XeINHAeA2uD1KEr3jud
	 egn8EdxnlvSjlA/bpGhg0Zfiz6hc5FkQZguM9Z4CJ51S57h7FE75K/y6ipzgVP4xPP
	 e+/H1XZkN80jWLatRtxOFu4SGTE9RM/8Eskx+cG2UnPVxCHwFGD+hgdtu5QPCV0Nwr
	 MkjXyidq1ICtEoyfeMTvXKUE1MT5jKYw/3qx5ujGX6vD+uLdmp3KvT8L8NYZTo0+H9
	 CTxDQ1BitQI2cn4i8lXWvhvspsvKoBV98VPH4+oFGTc/n+Ose4Z0wDAMehPcgtfDhG
	 MszCcoz3vAp+Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C6BCD5BA4;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 19 May 2026 17:42:14 +0530
Subject: [PATCH v14 1/5] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-vmalloc-shrink-v14-1-70b96ee3e9c9@zohomail.in>
References: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
In-Reply-To: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779192749; l=2470;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=bztRoZL7KG5/gkbYV0tpM0YC0DnlnM8KHP5WxzHQxJY=;
 b=LK61kZLrhgYetzYF6yc9h/2X8RSsJN1fh4jgcEDRwFmB+VRZ+bGS2RFhvjoQgx/h2KAwBmidK
 A9nE6+VpMvJA6bGQMEDUe0wu11CyThjN7CW2KJmu2JT0Cak/3RP60Hu
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D4071C0007
X-Stat-Signature: irmprwgfz15xh9gdj5ssbafrxgyb6awh
X-HE-Tag: 1779192752-454907
X-HE-Meta: U2FsdGVkX1/KYPsfciA9ZAwBqq6yP6ApGSrWCXTuYK9IzLwLBnAOVUv6BU2odej984sPkqQj/ZduHL24cN3w0+lsg/Qdt/GNdLAOi5NSvTvii9VLgSFDIrrQEi7y8M0zBz76jsBCr27unk/gRoiGe8nR2JB+NVOUxunvnQSV8NnjyeVaetAcdIwBIbx7tmFkNSKv8teIqFHrGpyN8umrt99/p1z6Gpk09ZleNm3tuUPCPQcaj1YWS19/Tp+Y9WUG941XvP9RCDUmjCuGWzTrFCKnR7D/ONJRtDD/c9Tffln3XT00W8F8Ti1xKTEUnx0jPSw0OBS3IqHaQFRdDfsAWZetaKycEGiAoyLkMAT4rb1K2YJE6IF9Afw7v+GN9kKyOCowcR6nFB+hdCaTO+aJn7DKnTQsZTreYMBgaxBdgELDShzUHxwzhGe4CeONBzLS4dgNT7/LmomNrDlQ1LBsJieAE0Pkod1W1HnrwmYOD/NZ+7QaiZMh4LkNTwS4oyecOXI4u6HF84+MJiqN/m93qGw5ITDjBKpKxpG0R/yVo/QkS0u82JZqmCCBLjlRO04aNPWxE+y9ZO1jysf903A+o6uQTxUSxx5PEe9b2OUHnM+B0B2NBpEKKqBcVyNM80kUJlGZEOktCPE/07qclGuI9SIwcrKvCNyxopX6WOYfkjeq6OoOKbiBZbYJP9FtAhubBEVEG2tJyENOxQmxPUCncT0k5I1Xkh2ETb+f1lRkusM47sUm+AtopWU4Tn/svKmiHnZmwK3SiPmc1r/2WOmoGcgkqOPdknOVud3XqhTqe77mVlcAksOwG9YkRB/4y6+xHeqYtA8lcRSr+K6Jal7BIy1A3GbD1h4/23QIPCyeuCOai8u6X61sRFQvFQZtlCFj2B6qBcnIV4Vxt8aYJ652d4IgdmU+yhejeWsoZ0u24aanUpp8bVtcbppCbrAxeB61Xh48oi6CCtwHvlqQQ4p
 8nGQoF11
 bqFCLlfB79cLLD46kIx7f80P8RbDt3FlX2abRPxZzg0JMFvFL6MYrLt3/bQFkFxUaXL9G9QlOGgYv/2HXNHTQ8EjugozIsIqLBRWtHe0UIfEX1zyZMKFiRhuHelRsBQNqCNNh9ODuyEL0hNELGvJaH9DTDQn8fGnjxf7AmY07F8dLO+Qc1xn1kyXoPmVhEczjp6eXWuF+mmQyfLZmeR4b9tJ1yWYByPjjgYUcEzAi34UWZw3eTlHTilXcb9dY40uIlBAa16uboE6qqIWFD6DKfZ7/Hu/YgTbZcHQoelSKl6NPUk1t1iIa19XNfJiMrR4bQahQd+ifjVmSpiUgFyROPvXS5twjBk9pJ4i96fMaQP9MCvldcMykXtuz0jGH+888d/HcePGhxa/m/aF+jOSQbUVfAEqls/1eDa+gGGh/PeT3wMk3IW53hg7iXhMkQo6Qiddf14LGXirtLOR56NDRN7BKN5OJje3woqf7iAVS0d7OUZDgWOrJItCzsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract page freeing and NR_VMALLOC stat accounting from
vfree() into a reusable vm_area_free_pages() helper.
The helper operates on a range [start_idx, end_idx) of pages
from a vm_struct, making it suitable for both full free (vfree)
and partial free (upcoming vrealloc shrink).

Freed page pointers in vm->pages[] are set to NULL
to prevent stale references when the vm_struct outlives the
free (as in vrealloc shrink).

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index eabb86b13b7e..5555601b9529 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,32 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * vm_area_free_pages - free a range of pages from a vmalloc allocation
+ * @vm: the vm_struct containing the pages
+ * @start_idx: first page index to free (inclusive)
+ * @end_idx: last page index to free (exclusive)
+ *
+ * Free pages [start_idx, end_idx) updating NR_VMALLOC stat accounting.
+ * Freed vm->pages[] entries are set to NULL.
+ * Caller is responsible for unmapping (vunmap_range) and KASAN
+ * poisoning before calling this.
+ */
+static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
+			       unsigned int end_idx)
+{
+	unsigned int i;
+
+	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
+		for (i = start_idx; i < end_idx; i++)
+			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
+	}
+	free_pages_bulk(vm->pages + start_idx, end_idx - start_idx);
+
+	for (i = start_idx; i < end_idx; i++)
+		vm->pages[i] = NULL;
+}
+
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -3436,7 +3462,6 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3460,12 +3485,7 @@ void vfree(const void *addr)
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
 
-	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
-		for (i = 0; i < vm->nr_pages; i++)
-			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
-	}
-	free_pages_bulk(vm->pages, vm->nr_pages);
-
+	vm_area_free_pages(vm, 0, vm->nr_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }

-- 
2.43.0



