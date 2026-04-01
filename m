Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F340310F6FDC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF3686B0095; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC73A6B0096; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E7E6B0099; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 940996B0096
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E55301A0154
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:52 +0000 (UTC)
X-FDA: 84610641864.08.E05688C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD1611C0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r3TyOWoa;
	spf=pass (imf21.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775063811;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WkyJvXVNYWJBSb7V0o8Vi82dkV9bgTsOU75ZNVgBotM=;
	b=4SKWaQo94uxGc0EkHCdYzFpR5jSR9Btf26OejkdJsiU8s50Q1H/1Mtz5o4ItY40tu4Y0So
	oJhfL6jSGl2i4BUah0OB/8N0zo29TcCpkVxRaRxcAnuV75O03WVoSKm659SPE3B5o9OxMk
	NPEPAqCnaTmRJy1vgHXOMa1mZR0bbbM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r3TyOWoa;
	spf=pass (imf21.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775063811; a=rsa-sha256;
	cv=none;
	b=xOQ/hpdx4cRSa2dskg1FmEnncGegGO1ZTqTYNW3omtZ+YPGwoE4rjkZsWZEM0jAl0PTTdC
	1Tv86ycZq4VDVEb8LfIVgsBHT60dbbl8w/vBB21KnQP8Yhn588feEWB/LgXZYqBJGfKINV
	xnll9KPAgit8cDwsCaYXwHeAEg1XxPA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA2A142DC6;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C404AC19423;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775063809;
	bh=g2XGgGei5/9K901lcE8j/TYckn3BeFqUsM0mB2rJlX8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=r3TyOWoa+zluNcik/LoELjg8BZT6qRfY/Qfkj0+XovMfqSHjlBg3baQmWN9p/wZgC
	 EEPaJFGJiWIM9RXpacgHSWzC8MxBgoght9QG4wyukbjMbXcnRQ7U3I0UhrPQ/R6a5H
	 3fy/XpMn6fQeO4oHVVrSsy1dM3p+fBHvHw7XGNOe7xvXjHPOAe5ffXfcYFJUECGMOa
	 NicP2aP+0RGF76diAOE9wKMCIeRddU/sHzVmzUT8Zqe0EOUUv1Xpnh/u/BZmuT89MZ
	 Aoj8P81XLDsR9WircFZneW4Dqpn3Jo8gKKT+3BxKgVOsKG0Hzs92Sq6vLWPx/DTfs7
	 udMA4FWNeY3Jw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEF61076386;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Wed, 01 Apr 2026 22:46:33 +0530
Subject: [PATCH v9 1/4] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-vmalloc-shrink-v9-1-bf58dfb997d8@zohomail.in>
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
In-Reply-To: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775063806; l=2828;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=8O2oBTeVmP5owdpoE0RYwkP6QcFE0K1KL1uyRgBELyY=;
 b=6jid7SK6D0wuU3u+YB/vxMxjWUUdmWgQlWnWXgP2sZYsn6O9DV3Pny1JVzjbhgPQYpWaz2/h7
 SjtzPGetQTGDRuV/FuPOpmtF5AQQvhO3F4fDvJKo4sTpMbKK60oyFMF
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: DD1611C0005
X-Stat-Signature: sm4m1dj8krrsfrkbgfzq7fhxh1nnnddk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775063810-450388
X-HE-Meta: U2FsdGVkX1/RleUH4DiaXFTMHyDeoeG5Y3llQD+6L06F9pNFs0//kKVJ2kCxSNSFxslaUrqwR37JB1SMdTaanSVt2Ge/GzgWBCQxB6NUsiQOOl99knOqlK/uceACBeVCmCZuZkUsyKewjY//hvRN86jFeitvnq8IS9643/fXVfE5yVTbXFQqm8/12vc/Yqcsbe9emcH7IxMFmTSxMyXeMl4iVEsNcu3lRim2tHu3ZiDgAmOtZjXaqB+yukcCbU+JBYfmUyZIRy9Ng78OpccAd2B1b1z8zhwo73hWSTcUwBzOb8dzuigLg7yJ3s7CRVKGxCv1fJn5TI0hmbKtuaN00j0NPVN6RNjrLS+O/eNe4aS3uLPvywW1SVQ6Vh+TqrnQwm3NRCf7nuO14WZaAoME7wQ2DGHOSK4RC/3HCKScwyfTASWJaYrAGqqO7hA/CT5/TjCIfxw4K7RYwoXP1Tmcs36JoVjlfpDtBnQleIDTLLjpG6TnadO9r3nel6e7ewu29Z6oOhOGA1VKwel0/n9QlyVVJoffxK8wnmOXAtJQsvEGVr5HHNJ94azc2Ims9ELh1UI5ycDC3EKR59FNjQhWz8n8LlGJ38cHTMujQosrZS0pANx+9Ks3LnJIiQxKTjih5NlOOTZ+v5ag+aan/Fda1iY6mJtJvcPYMaJaji54qZ3tKJTLNYlOhI8gv4j7iYctiyrGPEIHKcfMdymSzEKg0uaqh4B0DDClySZAC9hP690/cG9cfdwu2yhfyK4ZEenwpRmAiuagV0xHWjVN1fYWvWkaNJOAXqWLLU032rsN8le8tDdfFMVRtC8s8M8VDcn5lcLVoGtMmIqp+T0KU1v2KLIi/agWmQ+JN5WWQekZy8/n573SJNZDqVCmdZ4j2oXjfnFbWKX5/xJ/TThOJB31yP4IoBRA3yEmB3n/x8uRBXHrHL91N3NaTUKAdQwZryO3BEIu2AxBkKurgy6L3Yo
 Y0cMpxi5
 KSudr58a0nrPYQ2dCjywlQlbDMP9hixpwOsp24e4myHMNwQ0ppq0MfG7/SFJrolBhZh9lVC1Wd8g2Ih300FGY38Kio2DiXSZ55CdUZEbqF2gD77sq2AZLlVd8LWxr+AxGRmpQeRcwvxoLvbKLhXG/MQOCXCAqzzusfZn4n1aE+148L6FmseNzqEq2+bT5teuL/abwofVXX1vMqSdpr/UwfHED5dIX4agITwLv1evLBumGZJgNmrF0Njq5idpqaSAG9og2UBw4WbI88WTkSedT2xllbf6tiHLKcvOSdAyQgbYpSnCQ1ymjw8ovAGIWin3cmNRhZ0u4TZ3ROarJ9xPcNLD8f08+MDSW3VRDIx2tZxbgVzbP8eczpR5boapBNa+UGPJUE/gmlC3Ti2YI0mdR8ZTw0NaoJ3FIbSFcewYK+47SFkbJaQiAeTL4jMaYr+AAsqyQlc5pgT2buz0=
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
index 57eae99d9909..fe8700270139 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3424,6 +3424,38 @@ void vfree_atomic(const void *addr)
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
@@ -3444,7 +3476,6 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3467,19 +3498,7 @@ void vfree(const void *addr)
 
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



