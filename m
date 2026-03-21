Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C607109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9765F6B00FD; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FF56B00FA; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A8E6B00FF; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D35F6B00FA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35CD61A03E1
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:56 +0000 (UTC)
X-FDA: 84570848712.21.20E7927
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4F962140006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ifXqZ9gr;
	spf=pass (imf09.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Th8jt6FHVr1TrqFJW2URV52XC2KdVPsfJ4Ts5FNltU=;
	b=PZeolcJ4WKIjXpwcNXGjJXOAZ9JuUC2jB/2yUD+nf8/Uf5oSOfsx5lMghQYz9lSKRgqjJT
	+sZ5XtP56Am1HmrdyFuMhX+9nmE66OaM2E/McsR9mnqyDZbAFoVxYBYXlnDiNXnwOn1eQQ
	MIKHh5mQD4Jn42feJZ2GvnDMhFp1SNI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ifXqZ9gr;
	spf=pass (imf09.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116354; a=rsa-sha256;
	cv=none;
	b=lPtXuk5r7fMYH5SqCKtYeXADQrYpnKUiKGVXIHVX7KgMsfngiBtvOpbflLjpwW81DiAQ8I
	2+8C/tASUJbC5oqjWrN1N63VvZ0JIV7mC2Cys/fTUE2r8CWW7L1gQzhPlFsDrDQ5TrJjPW
	YW3bAAU9FzfKJUYZWchg/00NtaVlXeo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B18A4600AE;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D6CDC2BCB0;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116353;
	bh=1q9ZbSRou3kZy0bVZall4fchWN5XHmjqwgrNK0kmHD4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ifXqZ9gr79xAqOtFHJ4E7O9+UUMY0J/I3p+9nrsAG3x/hBN4w8qnSbHgch4uT1uBK
	 ozj7t0A2GRZctnTRusqFMZ/kcw91HS/7faSwlvfx0EUWoftCoY05GhpHjyWbmI8SPr
	 lQ4aeIXam8/af8fc3S8v67nUO3VJyk51Rz914cgGoV2M9QD9eHS7UUL2vpkJpbcAgH
	 wGJd0HgIO9EHMh4x0c3jR5SRYUxA8rxxY3yRtSGgBwh7gDnuoqTIoEGPM1E3+fNLbw
	 uasEGEa4LXl/V+cW3isZIfCK5vxUVZD8QLT5W0LVPyNmN1RYF+8L30bs1uyzzk9tNE
	 72T5MnnSnF3Sg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF2E109448B;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 21 Mar 2026 23:35:46 +0530
Subject: [PATCH v6 1/6] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260321-vmalloc-shrink-v6-1-062ca7b7ceb2@zohomail.in>
References: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
In-Reply-To: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774116351; l=2771;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=H130FITdP+gd6htRVApNT365j03KxXWr+CTNaNFiPA4=;
 b=uGx5cc0zWuNS8y3W1NbEacOLTPyrdZLL7S5/yLfUTJOFkmM/1kItTiCIB2t76BpqeE1eGdUNi
 7JwPlwnRLO9AA63cg4NH9GKVOC/IZDQd9zmjyQFsgPTc5ygKm5h5cf3
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 4F962140006
X-Stat-Signature: zf3jjrz9xa4ofirxfwiasss4s8pnmt4y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774116354-741922
X-HE-Meta: U2FsdGVkX19d/XLmX9ZCcG7NAoEshvZwocxCa9UdgKjWe1h3tHxceKcmVFqxyjhwFAFfFIEoDmz7SKmdEqtyPuD4ccvqoWIAQ78znTrMS2taNzQaZ+QjvfVm7GllpczBU+b2pdtygAJfgboQ9xMTaa6nvovQfUiUN6T/VJO7zZM7HL031x6yz7LR4yhhBcpo6wYR8ffm+MjbU2XTFPJAsKL8kFY5AFQWDkZ48bxs0PThfoQ101MiSQzxDetp3lcKSLfkfPvRBHeNE/EWwLKjKGySYSOQYDcs+R5Rhfzy35AwXlLSUafUec6fiDrFDRpc5+qYqj4MRcjyhAA0IKkpqctrOiHn5NPOJGceS3NFZ5fNT0BD2B/i7qz4U+i3yrtxdBI3YxP0HQzPwOtc3Z58BNGMgUQ5hA2cSvovAJwZsdSa86KrVwCZ8XLxhR2R5F14iN3unDMF6y9dW47NxFFiC7+Z4FM//2AbCf0gQ8A6uR6bJWGTvTI0M63KvMF7Zv9aUeFFfPpFKLDlQSRbCS+r2IK++AnzQAvRm3hyeVa6jJwoFyXZVhZYa2z9geV17/OFSoknYWn3XZPTmbKKDfq9048wUWiTijDESsMChbKFMbuGSeX2FwnK88B1Or0+lSN6ILHF2SmQXrpSjrkTRmayBVZP/7+BTgG1gy2M62dgK9/1ic9ml1k6DBOTDj0CVQEqsIxKc2bAb2M/Z4MDnCmCfW9do3ce+u+4DwL6lcEXkJ5wc28vkE5KLjcLTbanL0xNeyiYdDXeaUp0iM/tIu2n38BPvlTWulISvDVBq86uAqg2RoeCqwrmpMtgRHV4GbLbUGbkGoLvpeGPvtPaBPr0Tw/8/mRP7JnuXIM5LJ3JUMcknZM4H2zj9sdjvS9ub3Jo+Mi7t0PnDSr38msQxntoN44VuS5QPImedgoQ+7TkMiyykCW0/ZJ4LTmrrs7Tn3RYIlVamOlosCnx7KNqIWI
 zvysBBVC
 /1gd1qobSx82zRgzhDdOA7JVqZGLmUyoZ/YvEoAlf0Y/nefDXBnGGjNeE8SrzzycQvIcGkg3JN/Xz0lR6wUKqZPZBbG5gqEvlCf7I3azrJj3lB4zh5jMJv93/eTE/qbpk0rzyPhwFRqkm/kz8TjH0VBUKaJOxWWjGMQKIy6MRIi2N0wvfUzso4PRJM0GX9CWq6uPZZbgA5zp4y8nH0V1Ds4pbGAto6O7+GGJcLCUlVMpBlaEskS/iSTpXo9UjCDMo7lOQmOy1Iym7sWjZvnBVGibRrURFwvEoCHKJpyxBbZ9mVRO4jYHbitY2TrXPU0DwSOsID4aR82PzKaKtHHQhknyDvOsdt83QzjGSt6rWrRlbqr7nRYCpUnQXXzp+4ySmo30LTlzu/Aqe47FyvhvploJZfMjXnm37RCONgCQyNhSx1db1hGVcY7v/TLRALqnqHGiB2z3htWffEETTwOpeA7uzMg==
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
index c607307c657a..3977398e56e4 100644
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



