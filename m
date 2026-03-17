Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9803F3380E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DE96B0088; Tue, 17 Mar 2026 04:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DD76B0005; Tue, 17 Mar 2026 04:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DA06B008A; Tue, 17 Mar 2026 04:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D05DA6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:17:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 731DF596CD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:17:41 +0000 (UTC)
X-FDA: 84554851122.01.190F0D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 96F1318000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:17:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rbi4/LDN";
	spf=pass (imf16.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773735459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkCimjeh/vtI6FJp+wpJJIqG3YJuOd+Kn2bwa/KyLEI=;
	b=O1XsazvQ6/h9w4Duv//RrDp5qyIeZFS5iD/1bHkqiNx//46bZI+BzePgpRTv8GDN55iCsc
	AHNJ3DrJUdJqxxD2xNyLypWgH05yNoddAGZHolJnFTUF2m4/IQ4Yp1CUCwPr4JDm6hmfIe
	iQOCYGHK/nXp5Tb4ChBIhcpYl4MdbC0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rbi4/LDN";
	spf=pass (imf16.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773735459; a=rsa-sha256;
	cv=none;
	b=8bRNTZOmy87Q+KTRcmNUP+7dXRl+5eU015/L35rlHZESFfz3DkPQHjDTutQAB9uTMyY3J3
	VEm1aupc14kZ+79PAUOmfd0iWNZDFQvZTU1tv/nuFg8qvfMWDmPLkFu1HxH6K1Tils6ZYd
	lnvQcmYdR6d92aUwwadDdgeOKONSU6s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 082BB60133;
	Tue, 17 Mar 2026 08:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7BDCC2BC9E;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773735458;
	bh=k7MxutspFB0C8aBYZ+Cn6E/z5wK6f9LqrZ6dx5IdwE4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rbi4/LDN1bSr5gDxvdfcnNb6t5Youim7kzKt4c3F+c6g+9uSi2XEEA+IVZvdcgENz
	 wA0HipJ7wBJX6slVr1w+1S/iNns+nr6/SMIfXh4yuo8ZIewcmx2TpVGLNzJ7zSyndi
	 DdrVx/f4YwV7x7xmhRg/sAbJ4G1XwgK/2l8SQJ2YSym5WcLXnj8xCtVZLSmMRbIiOC
	 P1xyyXIJ6URnZOE8gIe5WZQf2wVgg29riZV71zbTcd9W1NvB3vfstVmZ87EzzHFTv8
	 WEWNd/kZgL+Xgkba2PhBOdCmH/L7LdOR3dU7Mx0N6Zd6LXB5ATYIOfPu1iwo0ucy5b
	 C8Ip/TNL6Rv3A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9521EF3380F;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 17 Mar 2026 13:47:33 +0530
Subject: [PATCH v5 1/3] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-vmalloc-shrink-v5-1-bbfbf54c5265@zohomail.in>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
In-Reply-To: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773735454; l=2682;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=Y7LaORkgehK4lKdbYmYreDeAD1S2R1PpyepoUGhj4EQ=;
 b=s6l1O5XrvfxrHoFwKEGesRMgIGpBIDNBbqv8cm9CXTCul4vnZf75J2fgg+sq40Vf7HTRxXOLj
 n8FBz8SjNGKAZvUEWq0aKtDU6RIzCoLj9bHAuV0DRAXJZbnw9v6dhlY
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: 6xpxws7iz641adwjowunbnoc95em7n4e
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 96F1318000B
X-HE-Tag: 1773735459-377214
X-HE-Meta: U2FsdGVkX18Td5nInsSw5cgERfu1jXZaldALrz6Bxs9sI+pRfc9iYpSzgK/nLyuHY43QTd2CSSi1VC+Yvg728w5W6Pr6jxVCag7o0a3vPsA1KKeWgNdVtcImug8PDdYRHnRlPLzUfJglDxEOqJT12ZSRh3T+hYzz5RsydhfbpA1Cx8SqKgL7p83Op6bpTkN8hQsxSgQ45lJ8yPLmNVzFzV2e15jGEUL93v4hGmx0zWhZSv4f1G7erG6gTF5ChVdBdu4WzK1BkcCCTHkSQ48lM1eO+6oDCltcHdS3VpWid4JV0uNTgq5wk/MAPAMSzbmw/YtxySZxe6tPDp0Q3s1AsJnTUwlNZa3zsAOmzeXKwa1kWuf72zzb86+ZrOILRqMYksF89A0gYfd7pVPgQL4sTXraL2YTX5vqMOejoyTjH7t7EGA75UDmZfCplYJebQ5JrecMgLnqQnYcqWIGIUN2zDDZrb9BUltk3mreNbmKyBbe0ouZz1lXkJy498QtWHXJr+1tsxEc6m1OkgTqZ23pvBiX32tQcOYq2/TnD5KY8VHfHouCMWAe62jtVGMV3Zd+rZ4mU6AizW5MDZOWSeD9eP6rQRgAn5gjtjCBBmmaDkbw1GPU82Pru44VnbsMR2Qh7M6rVCA34AbDc6H5SBDcIIXOrCbgh9lZ2Jq9o6ztJ4vA0MttkuhL47Z2C10Z3M3jC/hTcZSUz0XnUBgRuvINn5M5ziYNySCnSGrSyn0BhpXeyL4+ihCggHdg2SnSFLtqWAdAt2ECKaecNkAogDyVlIY20W3XiT89+1FX2Xjlj+Z0wI8Q72D5htWRT4mNZQhV6kgYImqh3LowK/eMq3h/1fgSD/kZNw1Pj6yt4xH24GJmQMT9eqWdrQQni42Db6wNSNtlMiYmDfkA/dp9fMJ8jRNJpXNEaYYxgBoESPcrHWpjO0phkC7esRIoJdKNY/34GFCIrqJ/dcR135H07cR
 lYO8mRrG
 A+XGcjTdDVA34WwgXYzCdPv1HpZQflfv/GKxEEHivckT+azMmVMtZE5/9x9k+Cz2Sl5Ae59vYs5nIrig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract the page-freeing loop and NR_VMALLOC stat accounting from
vfree() into a reusable vm_area_free_pages() helper. The helper operates
on a range [start, end) of pages from a vm_struct, making it suitable
for both full free (vfree) and partial free (upcoming vrealloc shrink).

Freed page pointers in vm->pages[] are set to NULL to prevent stale
references when the vm_struct outlives the free (as in vrealloc shrink).

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a..b29bf58c0e3f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,38 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * vm_area_free_pages - free a range of pages from a vmalloc allocation
+ * @vm: the vm_struct containing the pages
+ * @start: first page index to free (inclusive)
+ * @end: last page index to free (exclusive)
+ *
+ * Free pages [start, end) updating NR_VMALLOC stat accounting.
+ * Freed vm->pages[] entries are set to NULL.
+ * Caller is responsible for unmapping (vunmap_range) and KASAN
+ * poisoning before calling this.
+ */
+static void vm_area_free_pages(struct vm_struct *vm, unsigned int start,
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



