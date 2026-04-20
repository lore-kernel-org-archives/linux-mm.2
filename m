Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086B6F5A8A0
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338DE6B0093; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E88D6B0089; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189D26B0093; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06B9A6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 780401A0A9C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:22 +0000 (UTC)
X-FDA: 84679539924.22.B3EE838
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 859E140008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=POh7sWfi;
	spf=pass (imf07.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776704240;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vv6pxbBldgn/6ph8BGuAi1oLH15Wk/JcrNCDyfkdm2M=;
	b=LwJjDNGorFSz72l/Eu+theqqDzW0TfnD2awCsc0gq83DTY/WeSQplh85WvYCcZnEcygKkk
	O1LzJpV1xp6+LkJD+VO6K0lZ2YToZ8Z295enqg98Hhtu4z4AErhUdlnCGmN6VmwIOjG63d
	2kRt3mF6moaEIgJjztaqYHlNO5EOuSA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776704240; a=rsa-sha256;
	cv=none;
	b=M02qo2ANWJYkQVEg1eo22hMl1mribuC8jJD2OWy2CMs3GvgO7DxWAPhEAVSJDYJDNaxO2+
	leryaFqq8v44MzaCjPF+B9A9hbOgZ7kiPYMr05t3zYRt5osk2d7Pg4hNDQdDgUl4p6Mazb
	EQqESSpSFH06HWoJbziHaqlM2M1DLW0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=POh7sWfi;
	spf=pass (imf07.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A08F960018;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5303BC2BCB4;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776704239;
	bh=Hxuog2BmUcTqw6bS9yn1IjX0sLkh6OcGVS3NvuQmjvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=POh7sWfiDFTWSjGmVavICCOIcpMsIzbqU+gIe3gf0zY469ERPsvaHNxGvWFbRznF3
	 KV+wcwGTh0acakMVWxQIAeJzk8K6A4fTEC6Dq4D/Vbmsm8xy6fsU4clrw1IHJoqwNK
	 7syHajwgV7Kox9tkohxwyysj3ora02XDy6OsvyI8Fln9PlmK4r3qDW8ACwAM15Nicb
	 u0K+xrMpBy/KNQumrxEHbmsiFDlJH9zmKh/Umm0YHY7qB6CgJM7oKG0s8Or8+7qSqt
	 snESboYpdk6SnVxYAlYG0CwxYpVkPeYGWL9mLxgQl1u3OdJvy9UDy5SWt4U3i5ZM0E
	 3XYjSKCif8mZw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441E3FC72A4;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 20 Apr 2026 22:27:09 +0530
Subject: [PATCH v11 1/5] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260420-vmalloc-shrink-v11-1-cad80b00853a@zohomail.in>
References: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
In-Reply-To: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776704237; l=2828;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=qdjFLARIuW0yV59j3BOJKhfJswD1cYSsPkOQAeYYcb0=;
 b=H+aLkKkXS5ScY3IL1HjHJWS1PLqK1I8XL1RIFNUE+1qoirXLIHM6jy2v0QeVn/yBzOfvsNyZo
 kiSdXB3lDfuBxdLYE7MOV6MUvzd45zLhHo9DS9BsDG25WkprwYDrrDg
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: toz5zu1w3t4afghg8ts5rfduyx1mj78u
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 859E140008
X-Rspam-User: 
X-HE-Tag: 1776704240-6429
X-HE-Meta: U2FsdGVkX1+WcfPCJfnbsIwBW7yzvo12WuQZCmIcUBhjUCc4RhOViVfVBJucDyIOziHcIMpH1VzdCo2zcyoeB48lcfx0KXyWwhpvSmpcO6WK7Ix+oJg5VRItR1lai+FKze/iYKTZ19Qttt6TI4j8jxKAR7Elwl7YOy1eGWp6yRzqa/wfGrWj3CEelJMR2wpqeMmsLz1ZgPULNuVgzJGsL3qD5BjaeqnndpjyJxhqe1NkegwKtyKKsXMWQhXcCOgHRxeIqYl8N3dVoyvUIPOWF1Pq0YBUl2U8zpoeESIP4H221u7ba2sHHz/Kkf0NJYslWUSbCRM+Nb1c9TWCJtKnL4ogFb1bYF5C1dl7d7jVPLik5I+zdsN/6ZveXcVUXM5HSWwcUTamXhp15MHkbVHQ+wuFVD+jBabEzPjiNpuKso+2/kl42ZCCAX1Di0wZTcEMJFiDXDAgR7+xnKpX6/bak9CmFe1LfYf9YVYfMNvzxhlvsRrLoqDngYe/cKmQyJMM52jtRwuYYxSX/H12NI2rSvzCTGYb/wtUqJIVb91I6xw6VhnI2E69JcTNHmBq2VHUifJVbYtmMJZFfwAJX0jNHUCZ6JpZl3AHOLWGFDTi03pRGUtDNjNeRhy+rr06RVGT9UVoTUgTQhpt26nkRw/2nOcRfUyuELk8NJ1yppgKKO078siG/m4/sH5kyisI2wfqT7L4N5AwYRCIoqPLejSAbh0tFRK0bA5dtPcclMhZLKmD1SsrTb9AKFa9WW+pxo9Lhiltd7aJoDnUAvYzFBgVo6aEIVXEoLs5GNcBY55cwcj/B+s/FLgmxrU6fNibgnzgmQhKNg4G3G1tnNHM+JUOmJDFA17l9XoicllVKHkEEV0v6BOxnyVf3Ihj0nafyzR7VxLplrJAg1l7iIqvEDUQfuLwEisWtA3iBMdOjq2NY843zv9tlxn6goMKREUH6Jj4G9TIBNN3+ML8Gt2X+Jf
 IdYctHbg
 UsT21dByDkMTccPIcs/jfJpQ7VpSJSc0+Ggd4d2sN9RUMoszUpOyHbRUrOM9Jc4E0u2ZUnkCsMaVWy7z66nmhnB0d79tdUo6q4mP+IGHq978EcjMHCCMtqNd7zgTTvMdZ9edZw2Jeye+ZbNxmPYXJw+ulgktxq3HSdiUMvSl0z41x5VcPIbtEsz4QzSCZt2uU6/xK3txXmYf7GYawX0ahnh6bJgJoFbSDLW0V10Ei7V5Fa2zJ5rkyMg2Si24xevRAz+51oTTrHssxtkfwgB4YLASZllHNol36AJfO3fZ0GDyyehOz5CGQlnMAj3jEzUhQwrJbE72FXUVP3far1Nhex24+5vNQMZD+er9/pj0fb3LPk5GLg37imflORFKMFApwqdZ7hCGY8QDWv27YhrbSFygkgmkPFZJCZHkxN7bU6dBmIcxZYn/6EdXuWB/D/cU4OjhcbMk63D+u6vE=
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
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index aa08651ec0df..f1be263fdc58 100644
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



