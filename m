Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C281E9A75A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D3A6B0088; Tue, 24 Mar 2026 06:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477996B00AA; Tue, 24 Mar 2026 06:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A186B00A8; Tue, 24 Mar 2026 06:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1875F6B00A7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:00:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55ACB1419B0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:36 +0000 (UTC)
X-FDA: 84580512072.17.5087B54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29112A0023
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNOhBgb6;
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346434;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV6XLqmwoLOrpabjz8yT41s7KP3BMuxofPe9KWPmi5A=;
	b=T6CijHJ8pwGKu9vdwiIp6ZVNduQJTvPPtN4Uqy5CsleRWsoWSP8aFeBI7y8C3G9nz+nFf7
	7vg1eG5exQRW4yTNdsZymE5yFhYWyCA++LGfzexjc//07QEleYa4e8GQqR2WLs41E+nDJ5
	xTQmE4JqxNgsMfRFf/PUhE7ikDWM48U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNOhBgb6;
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346434; a=rsa-sha256;
	cv=none;
	b=aqCenMu6948/ONmYoF0CqxMG172JQAeXNI49VtZZvAJ94FtwFF9srs4uPDf7Itm+Iv5EfZ
	HLFnLcPW7PwQaRymNUSq5FFeIpIi4YA4fM14I1UH+HTOk4guDj6/QsJibe7qPSR1LNsN9i
	rSZ6Fd1M2G1Ofyvinkh3/a5pChYn/lY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCB224098B;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A87FEC2BCB3;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346432;
	bh=6VrX9bhFglZF/oJnl60voFlMr8m+M0s8BuRej35uxeQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VNOhBgb6I+1yGSQ5AOUmtTmFmJw3OJLaxv9bw5EmkX8IP8WfuN+b0dD6YIXAl8zdq
	 pX+0fPbXOqlapQGVHzrDpFC9UFaR4pudTDfT/4kELZIrxdXWN3LnYpezZpyR/Ru1n0
	 f/Oty7JskPl55+xkTlZO3XNMpfGW9PNaoyHJeoFWiLRAU+pOOMsgtifE8mrduwZy5Q
	 5nVlLpvSYzUsfUizaaqzGuO6bQWyr5UUoa4INSY21SsBeOWowskX2f5PR2gre31S9K
	 h+bccmkV4WEMBQbpFLFZGkkyHFd2j/hjAw0gupYdgKpHYd/T9aM0UOiAXom2waZkCE
	 t639SGYYzS83Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F4BE9A755;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 24 Mar 2026 15:30:26 +0530
Subject: [PATCH v7 1/6] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260324-vmalloc-shrink-v7-1-c0e62b8e5d83@zohomail.in>
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
In-Reply-To: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774346430; l=2771;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=4HOXJZyeFmBfI0AlNIxmjeDSGExIrgz5ceojgaPu1Zc=;
 b=F+YbrJjMIrhbbW7TDW736w8J1y1lGyqEohEcZY03q4o/K71b02N0sWnHE7fL+CRP+SEr1BNex
 oLMttuFA6mWBEunvkqyL8uEa9AEODGLFOXycFokBtr0R5HLzuvfad7n
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29112A0023
X-Stat-Signature: 9kksb1deg6ckueb3o6bf1gn5qcqytaos
X-Rspam-User: 
X-HE-Tag: 1774346433-52482
X-HE-Meta: U2FsdGVkX18xyfPKnpX9mmL/4tIPbFPprNeTR/ehHvwU4+NmhM/3njJa09+ZFVJCDCy3Rjcp5t2DW60y42jnlubq7cXI/cCqTs1WmvivBq4DYf8NtyWPm3Zi543fphSwTHQZElZ9FnqBSB0Si/3yPToicL65l98N6ztoYQMxSs1wSYVeJfB13I51z9kQUGZXvyzvjwmENtY+cE8pKTUCLYsodhTOcB/uSHPSrQHcEpZW1OGXEObcAoINyGML85kfJwmvt+h+8Ky7vL1f5f+dNozx8/pzxfJRnxBhN88Lj72+PHVKjDUTK5iZUxKQ6aBm7TVQGig+oRczvU/hryr/wXg9fmMevWs4hNHxaDM6r5qCxetPZD89OQEfH9Nbj87Zvgw5gT3NACAz28DJL7FNI/2N7Bbi2yqaC51hV+SWHn4DhFfd8xvSYVSHXDBWph5PMx6kctGr8P3lNnr7ETsw9wchAeIF4+gYnguknbweIm5gA5tPqrbxU1LPbnJhY/9d29de0B7DZ/hreg1D4Gza1+2vWQxGqbWZr0+djTSCwTYuwNkCB713gXfCOVs+SNukXPGKkYHLpObnjsDqonXBQ6bT+/JHvFSB+70x5t6DFWg3wct7MvkKfTtpk7vDZ4WqXoux8IupZbLwC9CH/4oG1xxjMOHJbtK8dXqDR5PVh+a57SF75BlsvAjy1jn2boaFgQKCHLWyOWOfQIasWl18K/woT2xiMA9xbVQxs8tePyB1n7OxZZtwgMJYbTQFQyJMkCOaAXDPtL0+XSUi8d37x2NRwx+Tyl/MG1e9dhZbDYJuXMV81H4OIvREp96Osj7gvL8Rz9eweeWIDYslT+9op/KInnr0kVlYYmQhxlUOJn6N0McoTbtJrd4cGOrScShByUXvwRkF0SBMff2aagrLBG4oNDwynR4zIaR8ifhGWz6QuncijXPR+lckaUXIXGneuYcrcges7P9S4hReb99
 AlWBpitu
 Hm5n83zJwI3IVycoDag+KAg/kVsIM/O9hUV1aAmq5NiDI5aRJM3OdgBaVDN4xku8FtNzyWeMW7+0Bv6JlzQsWoR1lio6AlF9o8YvEZU297wiZAo7qo8E8jCNRVB794G8WjViW2Cy8+4tjr6KPHfhZczW+kYpkFsx/K1rXGhhDsuopRO8Pgptw3rcLIs+WhctxIxXmX23m2Iw+dZcFTYGvyUbVuW/aLV4KXKUM/wyd4t3oo9gODitb2ncfDfoYE2s5sdxLy6XX3HcdymLgvu7e4a6ARs1nMvVYgF0ObmQcVe4zxqzSm2IYjsqKpSWqEs3/F6lOKkp7QefIIzUBJGsAIk5foBKlcMEC3BheT6tFVXFv9uhUM/IIY1mKPeoGO1pu6yyAFY26rITTRXEbEE94y5HEm1OG1UYGt1iWbP0Sa+gvmj8WeAyRZbFQFPybaH0nunRvYBuXCBz0iiCCYuWAYbUm+w==
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



