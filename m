Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBDF109448B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941E56B0100; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8123E6B0105; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D3A6B0102; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 374516B0105
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4E401DBFE
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:56 +0000 (UTC)
X-FDA: 84570848712.11.D3AFCC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D190910000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRQM8Fmq;
	spf=pass (imf14.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116355;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34syC9Xol2kvM9xrbunvlcFpBkyGtN6pegQa927O3rM=;
	b=wVmk69/zj+OJ0YhuGPTEVtVAa6Lk88g5ItdQGxwP6EPe0NLt1S/FHK/gvz0sMdBfkmcbVe
	EJz//wMzs1Ep2bvjnG7LSHJLJIEzqCZm+yYPCdF4cdm7yPmxXyM8tsrP+mTAe14MZhPQ8p
	k7vINIvyOXKkRB5MH40WP1FqVk1/ugg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRQM8Fmq;
	spf=pass (imf14.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116355; a=rsa-sha256;
	cv=none;
	b=EFFKolJX4kQMyT7jYh69aHz47aan3t94GpOHCTqJ6LrZZmi1mOfKEBz74WtAAE3IGlAtet
	b3bszLuobkig2wrgitd1D+tCbdwqB1gO2uXc5KxB7mkJH5zUPVT+JU7U1ReqMh65mQGERr
	EbwWlJH6pV5KrGdVmxhCPfcUUKKb6rA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACB2844592;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91129C2BCB6;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116353;
	bh=FL4KNiyxKIU/BXU9J94AmsqRhY7dSTdiUBUb9DKhYjo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tRQM8FmqS6OJuC2hsY/oOCOxwwwLxYgb4e+GbBrLAgdT1yng821eOz+j0jVPuE0DV
	 0rwHn89egQ8eeQWecTDoiIe0Mb2UnsOE2bKKADDfgz6TeSrgPB3DMn/A/PaKg8OlYf
	 tVRNcz1KfX1u6L5s1D8L+Kk7FljPFIU9JE3sj18VRz2/oHUSl7lRY5Lb6ecTuXygLb
	 o7imEPrBvhrB+BrfES9EYXFHYg6VGzZPn8XhDMbXB/K1T2UkNbbgllWaJmvRpcpYzL
	 StSHUizC7mV7ZRuoDPIgYxmctRy8mUMYN+Uhil9ZR4UGoeZw22DuSV59sPBRpN9hGY
	 ODJmuDLit1lWA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8957D1094478;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 21 Mar 2026 23:35:50 +0530
Subject: [PATCH v6 5/6] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260321-vmalloc-shrink-v6-5-062ca7b7ceb2@zohomail.in>
References: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
In-Reply-To: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774116351; l=3733;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=XcuDrqFqC2b82xJlkUNy90ghNCbi8jDDIdt9qyKsYoA=;
 b=n6RzlbrUuUJWWVesQJaNtsmVnVtThnwM2RLFCf6wjivYwpMyZX9PivawyFUS9wWW8zOyBDLmf
 OSHUB2TTzYPD6fRljbtUA0Hu0WnpVStA5qCI4m4kRMUKPt8fIhPk8xZ
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Queue-Id: D190910000A
X-Rspamd-Server: rspam08
X-Stat-Signature: o8idnr7d6b76h1kghabra1sswygbbdqu
X-HE-Tag: 1774116354-295590
X-HE-Meta: U2FsdGVkX1/1pCwPm46HVC+irLWMJc84UqL6ONkp5xIZPyBuD5Snm8IZ9t25V61PSJy8BguKNZ2AHspxfcFCOY6PiPojd8C7wkfSt7c09dMZGS4TbPqZXKaejYZgZ3IKzKn7f9xC6NWLI7FZqnahfyXyarKyybX+J+hNh2NsOPpGNZngEgnDEPKI8wSzG2eoq27b8xOdUqSWEXgDM+z+Qr0jRi3/odiSSYEb7itqfN86WB8YfslVRrP38ZhPgzhvy8uZUwPRr25REd0rJuahtZHo9g1ez7MkBVFjIRuW2LXW0kID8GaZ8zTD/KxcLjKF1wkfnzWqFMIS2IfFTDtzEpHVv18FQ/kng5P6NYBsMDCunVKASJruNyxnPP+KYcL2qTeOBX8G3VX29hOHZNN5i9mx7qmd/j/rprtaWwCBWwQO37ZUizibgmOkLMzKXAqAxktcmuem8irCs5qdPB5d9TxwfGLSkvFe9L7lNhfjsSGFH0KplzcIb3xTtnZPVUTZ8Pi/yG7teE3j4gJkWMHVPt63AWtPNGF68Xbb0TzhLhNGPtw1jJChLS99IfvaejNmr43rklCzGqzS2qqM11ZYGhNXhVyAyq8e+rotovxCwH0tjktDhP838ChHZQo6wKSPLEny2khLg6mzbAI3ItUez1x4/LKX/bj9RQzdrsZ8Isw9/c/NTfvFNwgPZRJK3nJvw2D+9LsmAH73XICT4XQUR6joH5U4xvFQQXqxEy0OptYAhzoOlf5/pdVPzftxd2IYQi46XYOjo5aKv4pFeGOwNuiZYgFtalDhMoURSEj6ht/WjRbH4F2NBhIRD1K9771SECkfLOvCIL8q9syKcODOlMYg0WnDczQctFko2Vp63BoOBdPiR3oKHUxCwtLFbnQEoI5ekPlIuZiyFxEryGU3CCdMHupMrnHAXObVzYWHECE4utwjFsc5TzvrmIEWaIn1CvjBIDHoxxI9J1VY+Ta
 woizu28I
 vS4TJoZ5Nb/nZ5G3cHwW/QLZMUJT1+ToQBZy/S9j/OQhsUZaSWTN75CNPD+WeU9ZRBhe2896Yj3xQd+sVlveM8C0DRPiHsUTZTa24XQJUXcO+sSm3idmP7S0cXCP6oweNr743Hy1dcwPwFKcFcIJBPwJQiiKK0bsfJF5WxPvrevzmkz4oWwiQYrLUV0Ss5cLY9qEfyOR8dGt47rloMIQxeLC184XTg7PzN2XQHFbXtazf6Ii4mnySbP90aolbVFGyJFV2jyTKw6C3sc7AWnYKxzO+boiTK8mRbmQixmyZQXFHCbLNpFhJiEiUtFemFVvUtOskJPgsZXTwLGKKAQMBLxESn+p+HffRWal3tBFy2wWvzfds6tY58dGaPMId9xhzZHFU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

When vrealloc() shrinks an allocation and the new size crosses a page
boundary, unmap and free the tail pages that are no longer needed. This
reclaims physical memory that was previously wasted for the lifetime
of the allocation.

The heuristic is simple: always free when at least one full page becomes
unused. Huge page allocations (page_order > 0) are skipped, as partial
freeing would require splitting. Allocations with VM_FLUSH_RESET_PERMS
are also skipped, as their direct-map permissions must be reset before
pages are returned to the page allocator, which is handled by
vm_reset_perms() during vfree().

Additionally, allocations with VM_USERMAP are skipped because
remap_vmalloc_range_partial() validates mapping requests against the
unchanged vm->size; freeing tail pages would cause vmalloc_to_page()
to return NULL for the unmapped range.

To protect concurrent /proc/vmallocinfo readers, the shrink path
updates vm->nr_pages with WRITE_ONCE() before freeing the pages.

Finally, we notify kmemleak of the reduced allocation size using
kmemleak_free_part() to prevent the kmemleak scanner from faulting on
the newly unmapped virtual addresses.

The virtual address reservation (vm->size / vmap_area) is intentionally
kept unchanged, preserving the address for potential future grow-in-place
support.

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7658fdc087d2..8b8752fc10e9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4345,14 +4345,48 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 			goto need_realloc;
 	}
 
-	/*
-	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
-	 * would be a good heuristic for when to shrink the vm_area?
-	 */
 	if (size <= old_size) {
+		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
+
+		/*
+		 * Free tail pages when shrink crosses a page boundary.
+		 *
+		 * Skip huge page allocations (page_order > 0) as partial
+		 * freeing would require splitting.
+		 *
+		 * Skip VM_FLUSH_RESET_PERMS, as direct-map permissions must
+		 * be reset before pages are returned to the allocator.
+		 *
+		 * Skip VM_USERMAP, as remap_vmalloc_range_partial() validates
+		 * mapping requests against the unchanged vm->size; freeing
+		 * tail pages would cause vmalloc_to_page() to return NULL for
+		 * the unmapped range.
+		 */
+		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
+		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP))) {
+			unsigned long addr = (unsigned long)p;
+			unsigned int old_nr_pages = vm->nr_pages;
+
+			/* Notify kmemleak of the reduced allocation size before unmapping. */
+			kmemleak_free_part(
+				(void *)addr + (new_nr_pages << PAGE_SHIFT),
+				(old_nr_pages - new_nr_pages) << PAGE_SHIFT);
+
+			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
+				     addr + (old_nr_pages << PAGE_SHIFT));
+
+			/*
+			 * Update nr_pages before freeing pages to prevent
+			 * a concurrent reader (e.g. show_numa_info via
+			 * /proc/vmallocinfo) from accessing NULL entries.
+			 */
+			WRITE_ONCE(vm->nr_pages, new_nr_pages);
+			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;

-- 
2.43.0



