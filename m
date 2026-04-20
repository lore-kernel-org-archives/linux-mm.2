Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 278A5F5A8A1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB966B0092; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2C06B0096; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50AD66B0098; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 341AF6B0096
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD026140B15
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:22 +0000 (UTC)
X-FDA: 84679539924.07.4239B98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C874B40004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MGgntb/h";
	spf=pass (imf12.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776704241;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Nrd4LdgogK8Lvv8hVUNktFy16RpqyrRgwNOOZkbOf0=;
	b=BNvH6iBWuQ4NFH1GD0XwLmatQT0z+jp3I1NzvhHcZXCOfmooBRJGN7ixigVSaDCIHh9lXs
	4imKrtd90KM3rKlDTPGX9tIxzrYZdsKwaoJsyyrPu0F8cKDypvFhpAPuzc2TQ/Gu8E49Oe
	5u7Ovumbz9DB10B6+EHS9EJdj3TN0Qc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MGgntb/h";
	spf=pass (imf12.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776704241; a=rsa-sha256;
	cv=none;
	b=qppn0v5vN3fwbkNCGQFS09j4oRDki45cIbXnz/72uCYZZRtGiag9ACblG5TVl/cc0/Hmuv
	6oss8yWh9A28nsF3597CMIHzM5Zflv7U6gBAT66jPv6lYwC3YfdNltnNYhnyACMjuu+P9y
	eYQVlurSojKVrsO0FFqf2NUt8O4SEUg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 958CA4458E;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77AA8C2BCC4;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776704239;
	bh=nbDch8qNmD2PmZstQv8hUA2t+gwg++VjJaVGcevRf6A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MGgntb/hZjyH8zFsEhoIgu0Poy50IcMReG8HeM6hf7/6DegbrUYnjK1RdFa7m819M
	 11BSW0bPiuJsGP8U/C2pEHC4pQ9FDxvYErFap9cMIJMSKfCZ/6PNLEjvE6tUt+7xMb
	 CdpgJOrR+S1oPXbzYTDg1MNzm4PeqScKdv83aXUe9fG2u2UzO6Tno4Mh62MX8Z+xeW
	 /tDT3r/NxQ/zXlUdW33IOg+3U+LV/3n7R3s3Ae+8YPSDv/NoWyLd92OzlHBmFWFli0
	 o3OURGAcoJLY1AiMWD+fWR/ub2QaTw6dP79rQBI6+nvsRczB9GUXqHWvRIvx4vdw+k
	 pXNl7YNExctbw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724E0F5A8A0;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 20 Apr 2026 22:27:12 +0530
Subject: [PATCH v11 4/5] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260420-vmalloc-shrink-v11-4-cad80b00853a@zohomail.in>
References: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
In-Reply-To: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776704237; l=4129;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=Ejsyev6YtrpwqZdKS6VyLq8ONR7Vuz9iTkbUX2IIfik=;
 b=1ECGteSrYPla6KOiK5fuCLIGZFolTGbAggmuYhMRgyTz2b68KxaCzYCHk21qxjLyR0jk8l4Wo
 j7idhVf3TL1AmDu1Ct74v6u6hBrBU5exTMJfsMsVWolzBazYCHwhc2g
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: ac65int1dx9tod3b7f3zq4y9k88a5r56
X-Rspamd-Queue-Id: C874B40004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776704240-385693
X-HE-Meta: U2FsdGVkX1/iy32NHkARflfxwJkp4eT6g8UCGGnSyjKDLNn9R2WN2CQ18P7h99cZiXk4qeIErePRsRa/z9eNP3zDZbnJmSI2Yu7gE4fF1hkRQquEtuJPZWi1YOZ3ZcsqjvtOJsKn8CiUMdQSV8YcyG+Gt3sgjVwOhoEpOGfXASYghAcBw2Wl4N8HiOymYmd5Lu2mtjC1UFeZ5xnUxWle56+xhdaeHzB7E9JRqVky66iVe/skOTdo04U4eYMJ9skBYU48qm1WILpVGYj4IFl4MYB0XQGToFvxGgD/cqyeq0w5iMazOTS/QUxF2jQmxi9tC7iDPS6tBPQyAFNKCwb+UBuqVVOpZUrJumN0jYvXsX9Y0TrSfzUhzYh9yC352lnr8KNIh3RoYZ0efQq+ScgKe8Emkk56uuI9IDKaKdJ2UsuY3vgDW5K2pnmkTFLZZHpV85R+yL8No2dIHdTlES7sebTdgUDMdAEYZdXu+a0yxV9OW8eIu65SLB2Mr5tSuo0ZoYT5kksdDgROY/p5MC7grYV3C7HVXDcjlTQ4Qt8+7FApQscmiu9OX7mOTcF8A6eC/yArH5A+wqI/gdgy2Xv59vV52srLZwecWpI12A1C4L7mFO84y6nbE+6Efd5UlE0SRgJw/BsZ1HeiwgN0gm4I4MN8CGsaicPSuN5eHy161jP/ucaK9/e4QsxTxUjjEcwWyBYRl1fE+yrVMwa1ueY0K3+SlNnjfpV6XYiOpbxOa/216y5SVcDFQl1UdTraY1R8KCJkw94ODV82RSRW4Ozp8nhfMUWi9kIb7mF8PaQ27eX/19+HI8Ob4u9Kzeg59bMebEt1KNN3u1N5Am/ZjcqNDQ5s8WD4DHF37+KIQG2m6zoD+Ar8HfoaA9OMCIPM2LSpD71N8Y3kxz/ROLEBVIHS7T0MYx+JibWBGVD1aZ6mQ/FfDv/tioJTEZFY2kabjn+VznpBmjtg5L0NfIBwAH9
 YDy+19q8
 09OHjhLTOqvZAUQeai/gV2G7zv219iGnkkcDmYhf/RgLEI1Mkj57CZAnhjZcqrJBjKiND17aTbEBZ66YylctEmLk9UPYLQUepMYBUO8tK2igDTb4V93SKxi2VN6MvWqp/iQTG7CRyMUNHOJ7FVHS2R0jhCf6Fr9HDcqATJrDU12WiIUodlZYN8AiDID10KrRl3nutWlm9f6yInmqjESmt4dTLruestLxVt+mScrHJPpGJwdnbbRXRQinZnKqi2ahJ6e3EtMiLVUE6b31dzgphavFp7QNFtrQde5sWG2c0OZm43gsLcjyb+VgkHtnW7uEE4//XnDN4kqBI99ppXJm6NZEHrqNmaqISZiaf/8nKWnKb9IzB43ITo1U+eOU6wxQKFnP5
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
index 4cae531ac0ee..8c37bdaee85b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4351,14 +4351,62 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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
+			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;

-- 
2.43.0



