Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B5FE10ED645
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0D746B009F; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98B36B00A2; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD9E6B00A0; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7949F6B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F73D8D7EF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:43 +0000 (UTC)
X-FDA: 84591368526.10.207059D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4D3FD140004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UAW6YGfI;
	spf=pass (imf26.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV6XLqmwoLOrpabjz8yT41s7KP3BMuxofPe9KWPmi5A=;
	b=TolZ8e71nwVelHY0Sbd7ML6YejA4OIhykPD3tBD2gybSO78MCs+rBeF9yxxFDndSj+wT4A
	zjK2ruM6HJlC9UmG2Wqe7l2nWctn7TSc0ji7sX5jcurvCfkRW72RocATXtUb7rPOeTBIgn
	qMxsbZd8ZPVcXGtRp4S9RZk7+wyzWjE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UAW6YGfI;
	spf=pass (imf26.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604921; a=rsa-sha256;
	cv=none;
	b=rXm6vcLsEVjN3bMTSvHtQ4lIRYvUBWx+sfLE0fXLVSCBVNXlAldrti2e0gSay+XhyBqnet
	g5Zv5B9q9ZDw0RDkppwHLGze6GIWL54FMz3nGSOIkEJxJ8biAgiireCKiN4HMNhhF9O4lF
	GGizMWpbnaVFWyTi7Ehup9T/FXRCDik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A6946132B;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C222C19424;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774604920;
	bh=6VrX9bhFglZF/oJnl60voFlMr8m+M0s8BuRej35uxeQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UAW6YGfIxnl3BAWfqOXI9gfOhdjgRj268DY3QAqYPuEx0MTpj01eMR+rkhWfYjPpO
	 PDmOEtf8Hb4j6tI7Cwm+oq1GUEwUdcq+mVcCxn9Ve3FmXEZAA4p+j1ZHBIh6pViz63
	 JeMU+CHQy9+3BxXxQ7TZ4BwDYhf3wL4ffUeEMzPEBodjPk0iGlouiVqx4Rc70ONAFW
	 8RUL2Y50MReCM3Lh+TAqKgrVku50yCo6FGqdqae89bFqLf9ah+j9hacbePLPNop4qF
	 IKu+QAqVZ13UazhHMxFmFGK3Q9Zd7PYc01wsLQgHAsYDNSEX0FlVrf3wMHuPR1mZOJ
	 TDAha71cHZAKw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1963910ED643;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Fri, 27 Mar 2026 15:18:37 +0530
Subject: [PATCH v8 1/6] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-vmalloc-shrink-v8-1-cc6b57059ed7@zohomail.in>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
In-Reply-To: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774604917; l=2771;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=4HOXJZyeFmBfI0AlNIxmjeDSGExIrgz5ceojgaPu1Zc=;
 b=3FTEEhaMk3fS0LVGGP93t/XcThQSZTfaK7fq45GzsrmP8QCFomBgVOwrXiCTLoVrHKeIDYRzD
 RMSM72jY5KjABvTbTF8K/WI3YztHJGTiwexkulsVWfOJ5+sqJY8QR0l
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Stat-Signature: qermrnw1mbgj3upa3netqodf8t1q7gh5
X-Rspamd-Queue-Id: 4D3FD140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774604921-572751
X-HE-Meta: U2FsdGVkX1+m5UrEEvZqTtgzCOn0gUlDkNelKEwsYEBS7CVb7d+Mg+HBohaU7hmAUMyi88Z0HgbhtRWAThLfAsUzIQ2Ez8GRglWo+w0wv0FpPrqPUUeSpJpARZgnrgQwTdEQPnpT3Ud9kEuXLm0zn9pMoCVnrIVqc9K9CHfxzWBMB5qOiC8J6Vb99lO8XTV05iYnFlJDPwbRJJeC361gYt7Ov5j7tg70QrNkqkS72KTm0LvvFsCpTFIS5gNMKJ+zYqx3Q0l9xbiC0P4yEjsnx8+y8lUtfZDWCzE0WSr5UlbffjPvnTeSwjkh9E26Oh5Mg410lWXM8Ey+wdamCWuqV7w3zgOkJbAfBchvc6UVRb9mvGQRzESZgGHaqa1dTR9/XBRBWf/52oLTBOmLD/veqIYC3YIWZYt+0ca7A20BBv82k63zl7PYS+lnNCwUlakntM7sdT2HKEzeZ2keYFP4+TAszQICCQBHe1zuqFtQ22ceIzzgpCg9+jaahmlBMioQFd4t4zvQeQI5Mb6OsPQli+um7XMK69l3Af7Bu0W+OQLuvM+mx4qkXyr6Z4jR3+clF+dVNSNeEpJw9fb6EzO9HGUoDJn5P2k4ElGT1mBgb9TnsIBNpfD+Hz7KXJ0/0avxr1pxj6iOWqDkdGQ6Ry7sViA15fDka2xsEhQg5x1qaiF1NjSAWQWiG9kuIA4vw3cAY/kIxCKz60sQQQulzjV0yMacRPA2Qo+1vsxJm3wSAnnOygagihQNJeN0StZ6bcAzsQI6dGbJ/xkCAAZU9MRgEaZjRSMW0oGKQ7WyqsYLif2pfO/XVahQCZw/jLfqdNHUNPpCPD72Tsk6gPr7DUXyecSnhOq1kPNdqjmrQ+UroXvGTq91JxW6l/hBm90qKXsz2CDlldN7FwPrZ2TJO2Qtps0IGyK+6QQ8QMQCpNxZ+D6Pi+xMp+DxmUjLR20TjWwgjjtvp878OXlzDrNT5nd
 9Y01XMNq
 VFgMLCrZB+X6Gsk/ByX0TUvaJLwgyv4QOIdzehhz8nBghKwrAAZfq+JGNMtqAj6nYQdim4Z4CWzdsmrq38yRA4NDhs7nv984vrijxAJTb98wBVqwzYCGmCbO3gkqQZSjym9LfYnp9VKp+AwyP1wn16JynHH0S9Qdww8ybHYn7emyDspt1QVZdJnrMmBBDWOqLAoduRl+ME8G/KpuEo9Ls67az0f8MB4OASAoxK5thQduDQMEb08iKUhXFeNtQaMEnnnvjozHGD9t0eVuCQ0yfnoQUK+0qQvvkLo4iQ1Kj/w8lN4jLB1hC2KSLVFYjw5TpVDQSgVNses52n/oA5yYlohouW9EYxsOlOmBFGAUeryj8VJLE/Hc+8uEsqdNTS31hekcr2LClKIYvHtw/Gqx57A9mPjD8ijQpFShkv2kOrELYEGsKMnnQsoGThPOi2T5tKMfNh/fs9FJAWIH3or9D1ZmJJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract the page-freeing loop and NR_VMALLOC stat accounting from
vfree() into a reusable vm_area_free_pages() helper. The helper operates
on a range [start_idx, end_idx) of pages from a vm_struct, making it
suitable for both full free (vfree) and partial free (upcoming vrealloc
shrink).

Freed page pointers in vm->pages[] are set to NULL to prevent stale
references when the vm_struct outlives the free (as in vrealloc shrink).

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d75151649c97..79a57955345d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,38 @@ void vfree_atomic(const void *addr)
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
+	for (i = start_idx; i < end_idx; i++) {
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
+		vm->pages[i] = NULL;
+		cond_resched();
+	}
+}
+
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -3436,7 +3468,6 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3459,19 +3490,7 @@ void vfree(const void *addr)
 
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
+	vm_area_free_pages(vm, 0, vm->nr_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }

-- 
2.43.0



