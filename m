Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 333461076381
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07A36B0089; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68766B0093; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F76E6B0089; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56DBC6B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E630137F05
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:53 +0000 (UTC)
X-FDA: 84610641906.30.A7476D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 014A24000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JQfDdp7E;
	spf=pass (imf27.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775063811;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiYK1REAe/Hc12NF39DFwkVdIeR5dJ13ZamKc0euX0Q=;
	b=z788Qmva5upxPhX/Gkq3WM2rHmr0Rvp7CT138RpKZuwV+9XzFTwjyoFfJUFcjI3jB9zmas
	7O58vMPwA+MdMLt9SMsXvEUW9sUcUxVyQRwKcnlY+QOv9arXaBu3mOtCdR5IVj6ErHT0/I
	1cGDbB1mLd3rawkLRYwHrJDBEd96jS4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JQfDdp7E;
	spf=pass (imf27.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775063811; a=rsa-sha256;
	cv=none;
	b=ZeAjDKGJftXSJrwQiBk+YLM/nt/kL8BfbqUpzUtckZU5xQDpxP/nh0DhcM+aQXKCGTnTKI
	cNa2a8lCWnCC0nn/TdRBjWNYY7LGE0XcHQ0EATVyHBehKjtfXcA2yw2t++WIpcX7RCLex3
	542Jpq3D2HDuen+bfuf0j1zfChxoqfc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 101B942DC9;
	Wed,  1 Apr 2026 17:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC5CEC2BCB2;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775063809;
	bh=YIqk+GI3VlI39w15Sj/+hEGyGQSwUg0HivbIRY5c4l8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JQfDdp7ElxJsM6m31GkWVQXQnvD4o8S/nHjUCZGiNVe6OA+Dv8zgystD8j+OSG5T/
	 tHcC1WWFaWL6bacbxSNXYkG49tbafopteHPROR4ZgbNuA5231cpa52Fz/8N/EmuokN
	 wkO1z92rj1/WKaNh715KqyBHqcJpTbu4V0/QootmAik4rDBP4lhnhGDuzg7yeVOdgF
	 OHMDe3XXpL4CZ3fFBmLBmCq46j+ObHk1I/0xsGrclZvL5dSSbdN42SQxUoqh3bap+k
	 +3c9uaHKsc9LkHu/M00CQJT29OqEr4FpXjBWpX7RDfPKRauTkmtt5m76QZAYRBgv3G
	 SVQTwHVu2u38A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05F810F6FDC;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Wed, 01 Apr 2026 22:46:35 +0530
Subject: [PATCH v9 3/4] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-vmalloc-shrink-v9-3-bf58dfb997d8@zohomail.in>
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
In-Reply-To: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775063806; l=4129;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=3nMDP0UoKiSAVmLTEwwBC/svH7X4LQVEHStunnKNDUk=;
 b=jLa7+jV9wUcG1BnhTYe4qHrTaNnG3xfduH29EuCmCUKWjLhrU55aSyND7UWjYsRf/R4JNRiUh
 cuvBprtt72sDVTCcDtCv4hJWvg+8WPJuN2Uoyq3mpXsbOsXSMyUaJE8
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 014A24000A
X-Stat-Signature: kjo8pywh5w7bpszo1x5et3kjxsnh8f4r
X-Rspam-User: 
X-HE-Tag: 1775063810-415520
X-HE-Meta: U2FsdGVkX18knzXm/LV5F5CaWkxq030lb25kIbZz1KEyLiQ1g94lyA7SDO3mVhA5PCQDjrRz8kNAPhfi2tyghfxdqWheY2MVspY3Yju8aYRcNzcg8iDUsSD9c4U+zE23jH1x7ttOWuFVfdEity6p6EnTE8GeMkNP2ZugZfKVA+iNk6SFdnF3SLcquq9wcsPwsZzeN6QYKSwuXr9O1ijSF8yS4GTn3I8nUqpOgrMvhtujgzXLQCSM6YfYsPvEhcQJjQwg4E80IgyP9g9yhGLuiuIonh9+uqRCeHY9UmHdTfCPrZ3QdXFoJOhTsCK5ksf/oErU23dGGmw+nNpT7Y6vVEdZ2gsG/0YpkY9wxqCexud8eYgs6czIlxHqB49p8KNPSH2T925ZEdJTgZR2pyd6knygG2IeB/UUJ/cb58uOZpA1AW4Bb/XjrewQxHU3g1QDr3lPdnvX+o9wSmHK1ap+nin/32CRxn8aIDpifbYDvJ4yajCub56NIS26+yjj+TPSRktxIp+iH0QnpfZ4z5SdQ29wy7wtP9KCbl5nOxWRTJsUyaIQziEhKEDNEv36lXjC8wi+oAzp24CySsqmddChbVW7opGI37eDzg1xS81TejA3nWoY8/H5c5KBWPIkYbUBResSFQYuzt/X+AFA0EIac0asyiQaLkACxSmUsEnOi/a5PG1SfE+LXawbF08Zxu1FhP2qs0hJCSGZ+sA4Jp3RbNxjNdFRPi9l3CGOnZ2XIJF6YfhOlM0yJHTavRfqVTRZa3M7KLqsibjgCV6wfjmmlvk96xT2c7WzmVACNcHZzqiyY5SVsrx6NQfRayLgur5YsL86rV1CSim94+gha8DlWoOrbOj4n7gwpUQAKoIJvtGcwdo8GgU7ocxhHD6gTEWajikpmnttwoqXnWuX+EAyJU53nmO8Wfe9uUddB11blDTIfVIQ9qqkn1Qtr8fmi/rNC+PdHnpkRnppmyBPgSI
 YCNUif2p
 LQo6vUD65s1FvlDR0ke2OlhcVQCON5MNzPNbt04PUIiNweIVw9QmUFvdLfYi9exYL0trNTK6Jwfle9ZhBvLwGm1URKTJNa0pEICAf558RRgW6ptqMkmEOvY3ycWZHG9w0KzsDKDhjbEtzOmcAowC41BsWNS/PQdjtmngAKIoh8C9tTlKlXj6G41UHrtuTAR4saUYRHFf1nhDBK5Rs9+aPz8rJYFcuz0pcp4PCWpIzxiCMHo0MjuEMKwQ6KGnIN24NntIQjz/Ok/f8eoTZPi+gFIZM3wg3PijMPiaPjB+lM5xUMv7dF760/N9gXYa7zGY3x/NNU5WftRqcwjiKo7eVo2Y8b5BInIWfaJKHOjRuTSMPRLiycwU2ibDBZG8nKZrFNOHm
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

To protect concurrent readers, the shrink path uses Node lock to
synchronize before freeing the pages.

Finally, we notify kmemleak of the reduced allocation size using
kmemleak_free_part() to prevent the kmemleak scanner from faulting on
the newly unmapped virtual addresses.

The virtual address reservation (vm->size / vmap_area) is intentionally
kept unchanged, preserving the address for potential future grow-in-place
support.

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1c6d747220ce..a7731e54560b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4359,14 +4359,62 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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
+		 *
+		 * Skip if either GFP_NOFS or GFP_NOIO are used.
+		 * kmemleak_free_part() internally allocates with
+		 * GFP_KERNEL, which could trigger a recursive deadlock
+		 * if we are under filesystem or I/O reclaim.
+		 */
+		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
+		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
+		    gfp_has_io_fs(flags)) {
+			unsigned long addr = (unsigned long)kasan_reset_tag(p);
+			unsigned int old_nr_pages = vm->nr_pages;
+
+			/* Notify kmemleak of the reduced allocation size before unmapping. */
+			kmemleak_free_part(
+				(void *)addr + ((unsigned long)new_nr_pages
+						<< PAGE_SHIFT),
+				(unsigned long)(old_nr_pages - new_nr_pages)
+					<< PAGE_SHIFT);
+
+			vunmap_range(addr + ((unsigned long)new_nr_pages
+					     << PAGE_SHIFT),
+				     addr + ((unsigned long)old_nr_pages
+					     << PAGE_SHIFT));
+
+			/*
+			 * Use the node lock to synchronize with concurrent
+			 * readers (vmalloc_info_show).
+			 */
+			struct vmap_node *vn = addr_to_node(addr);
+
+			spin_lock(&vn->busy.lock);
+			vm->nr_pages = new_nr_pages;
+			spin_unlock(&vn->busy.lock);
+
+			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;

-- 
2.43.0



