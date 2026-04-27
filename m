Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8D1FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247B96B008A; Mon, 27 Apr 2026 16:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15CBE6B0095; Mon, 27 Apr 2026 16:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17BE6B0099; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE7A36B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 620B38B3BD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:29 +0000 (UTC)
X-FDA: 84705463458.01.DCB9D12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3937D4000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZ1Cu5ct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777321467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aezdgkwE5r7UwIIXltjuZHXxQGykvVIe+XIAMZIBoHY=;
	b=KT0YQMXNckrZWjp1WeaUINmttY/UYxL2jKxqhAaKiSa6fxcACVUhG31wStHYsAepcgkK5c
	dN0S3VcvcNded6j4G5YYdz/JghXjGIz5hXv2bWU/U0aCfmzOtXDDaMEhNvk6bunPuLia9s
	N3gBLCoe/V2cu2XgpGv8gu8652RKja0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777321467; a=rsa-sha256;
	cv=none;
	b=XJHlzKYuEUFtKfUQ6VG7EqO1+KWQk9Fkhr3iCQUdBAKmMVqass1BwV5TAtM7JeyrQ8JigQ
	M6CYGFwRUOzkCHK+kuUvJX53HN2k58VIQiWcCQhS5CgMquJn93Od1jdexghTHMLp32p88Z
	3bhiWYhRaVBt2Bz6Lt+xEU/DyxWtiLc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZ1Cu5ct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 356AF43F17;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0ED5EC2BCC4;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777321466;
	bh=/F8v5Oh0txeIev8z2jZ0Qvbb6TLvh7Meq8C3Y2ZodlI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XZ1Cu5ct8bjSpN57GpUzhxspGWdwT/LBzZfThyR+Uf4ZGvk1zMrvMraXZ5jcAhLGr
	 +vOw5rhNKV2vLEHVmOYa4ZZrslTRt3AuS7yk/vsZ0JaFBVLLOBACdGU6dCaP/STPDK
	 hoQMm1MoRIuihogKJb+wtgKTrbWfHmiJH1PcVlLNOvrbeVkjf1uCJnmyfYFLFf6fkJ
	 1pEU+bYB2maPiAORLtJuVeZkCcfUbfMeAOsYVxBZPvv/+lio9OXv00Bj6vCYBDAAbt
	 fGNhXVtuv6hIoctl/5KhCJ60zYd9v4ZxMX4uvbkldnFr+c0ys4eKd4KT8p6wkSloLV
	 lZkxyILwtpelg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06480FF8874;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 28 Apr 2026 01:54:19 +0530
Subject: [PATCH v12 4/5] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-vmalloc-shrink-v12-4-3c18c9172eb1@zohomail.in>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
In-Reply-To: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777321463; l=4129;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=5NJsZJhr4gxLdNkrGrcBoAv03CvvDNrlYCw3Jjj+FFo=;
 b=MyOLz6qbpCthFvegsA2v+ZrsVHbTI7LcbjCvhYHTrQiWSnDquffPxjeOpeRjoWlNN33niXLX3
 DPYYLQbB9RhChU6zUQXVVXuNJixa87jFnfg44ArFOtDTxE5naseWcGJ
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3937D4000A
X-Stat-Signature: jwomqs3x6xy6m9x8utr68hhirmby9qp1
X-Rspam-User: 
X-HE-Tag: 1777321467-584443
X-HE-Meta: U2FsdGVkX1/a7TmkeiiOihlcIEvTyJ7jnp1wRvPWLdavU18yIN8+RLaiq2V48wSKjAieUOFgZwUgFr/D9q/meLhE7FKR2ORPvY2tvdQcrUdGxvOuVAUA36QCfN182ylRtoKy/ZqpjL8hjamRJemWytl4RTSvzL5ySdstPXahLxb5WZHS2ceXyO5EUTM4n1kgzzzQHff4Z23uyULX6yoCnqvjIJ7H+AlIDN63Flb9uJBxN+mLHyi4I/YaU4TxUE8FkvJkB/VVL1Y1avbs4szYFIii8Ko1OzkN1WrWk2AwDac1j2+uzdg/tkEl/SaJRZvd3/QoM6a9tqjLKmIfLTu7vE5DEovx4Y6pY353VyALGma1MJbuJ0QIKN+J7FE9gtxmwqEzkbimr7jF9+Q9xafmsBpzfvHaBweanYeCnKy6AnKeAoTe7vcr/gbCH7LoS3zZWZQau8wwSn8y68+NCOuZ0UP+qk4pam76h0lLJTehyDfIOC9kXKrglbHGoL0dEziERiAseAb2o/QFQalSRTZSx0BxxIhxdjblz26Bweu30o3hQvtZS2gafiZQIJcL6xdTk4TnCma5S+QjiJgPpeWMOi0PYd48lv/8Wp+Vq7B66z3yas8dDEHpn6XG/rqJzKHTbuJppDJHfMvRFvNGct9ZuMhZcE9OnjHjwnvDcxd5eJCZw218vyLzOhn8xJuh8h4Qvg1p+9K0VG11l7AIwPuquvJwjP2Y9ncUAeoJj57XQDsvUa7Kta8hI8R+8XMfKNT9JP8FaOFUAlF9NhQgqMzsBLseVq3AZRTOt/5NeOqhwtmvcDBPrPO8RchXFfyJMtCiz1kzVFbP2mD+JRD5IMnVVs4b0uCV7q39x+tjBmpWHnt5vJoIDd7W/cyGO/yTolKMOLg9hTmNlYTYrySrZ7zJcgSj2ZqG92FSTMQhQS2Cb0VQt3hzwpA3WAj8sIkFNWkwWPNmzhiHQa646u2UU6a
 XS3s7Nmw
 Hx7dCdTYElK4Hz83Vo8GdXbIDaplnCzk4iSxQNaY1AQq4fD0tBYmKUsPjAXD4+FSKzvhP1Tk6eV+jcf0zIyjrim4Flb7FxVEFLep8RoHo9QHBiycV266yfvofIveThj2aRgr34XbPug30g4XIPk3bwnnoj04/m8KLr3yvl0PH0wT2QAXAOVfzRaB9KZZOIJEGZXvJl/eFSIfvpTPA0tjlYMMekQiwTLKmh+YFx0DC6BjfAi1U6af/SPjLnGd2XHtdKorIqIB5u88GHyE6h/wqhh5lHMrSYVEjz44dDhb+uZMOmUzPwYDzm7rDRxqgM0lIHG/+qm0zLR2gIq3af/PP5qyeSQQVbHkC5cOkzKA7SoFqQGJmvovdiDvgrqWrbzAdZO2T
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
index 65e0a23efb3b..9f810d306db9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4346,14 +4346,62 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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



