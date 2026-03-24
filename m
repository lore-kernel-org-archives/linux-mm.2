Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012BBE9A759
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4826B00A8; Tue, 24 Mar 2026 06:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385276B00A9; Tue, 24 Mar 2026 06:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C5D6B00AA; Tue, 24 Mar 2026 06:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E53D6B00A8
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:00:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B61151419D9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:38 +0000 (UTC)
X-FDA: 84580512156.16.1E7121E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3603A0020
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ioVEyuNs;
	spf=pass (imf25.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346436;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMuKfuquzV+spFFot1mSHVL29Sv9YlGmCwtjBrvWc2I=;
	b=K/a2uMKuDN5HEpygsIFnrq+x1MueBinEgGndOffzFORQ/v2mWzYuB51y7Cd/rrY4A9evRo
	Whv51jZYxohI48d0SXYV5MguRjcdf9jRvUm+ad6aYG2p/LTs6tT9dBw1ZiGpNPE50d7OEJ
	vIWB133/Ipnys7syjRZzO14cjnUju/Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ioVEyuNs;
	spf=pass (imf25.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346436; a=rsa-sha256;
	cv=none;
	b=JqSXhPalo2HrFs/F4uYtyYBZ59QVe9mLDb6FpVQFOJ1H07z8yGJJixOrg9uzUCoRoEQNCb
	fwQpz+jE5++pFnwM2xbq7+EiKSgWkBP6qTux6tewfdBawf1cJq5JuO1rtnwwZgsJJjqpdx
	v3r21FgoIm9nOfYURFRu3dlrMOrTBlo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D87C4454D;
	Tue, 24 Mar 2026 10:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1111C2BCB7;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346432;
	bh=XIeELIdTrhstFpbqKHyFqorwUxZ6LKcOcj+spwpUTMI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ioVEyuNsZawlKy8sLSV/94NrDwx53sYHeSInn6ovt8kw5tkgNTjqDopTYczVCsdNa
	 /XXGyWEQgQIIAd6SZOrily/E57NFVjXXoBZPze0M3+MSdl6mSKBMQoCGctnw/i+mvj
	 edMDWw8qAgeJ4zVKE7G7oNXt+m0KzRltvEYk5AqL+i2KpUBBmIRZSFzXSwZBC35pgY
	 LaBZMvVCm+G8Dxf/rXv6Jf9E8P6KVgvTV+JQSx2kpz7LDFUJMq2iMhB+bN/cVJu+rr
	 14vEpNGB1wyFw0I9LkB2sxh+DYFVQTBx+5ake0YFXt9E6L5xbX28V5luCzUDvai3LD
	 y5Ue2kvGLe1Hg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA72CE9A759;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 24 Mar 2026 15:30:30 +0530
Subject: [PATCH v7 5/6] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260324-vmalloc-shrink-v7-5-c0e62b8e5d83@zohomail.in>
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
In-Reply-To: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774346430; l=4123;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=KqZ1PvSQ5YdeKVCbQTHi48p4pEM47gXj7CPAPxehb3Y=;
 b=YQXCV+r7FoeEN9pxg9G8f0Y0NC/wtYTE9YQUW4iQaDD1hSwI5QnnHb+kEjCCFcLG5whwIHvxL
 mywr/WNhWP7DZ1IGZ/WiWkbC+uJS0nz800ngyjyCz5Uz6w/wpSGw3Fy
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: A3603A0020
X-Stat-Signature: w3ga5ryicktn81kgyysozi4r75ieaiyz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774346436-212788
X-HE-Meta: U2FsdGVkX19NIMF/WggCzIj3aLFttLLWrmeN/pj1FLlV8xzHs7htgaMB0i3z540iaF6YrFAEMqKsOW6a6R3eMVo8YXvGS8NR+3vH1lVJcd7zls4EqBDsBFdrhhsJ+YF1P/NQMOBFO5ikD3lrkpCKrgBIwQbFRdvco2dck+kaA8v1HA3riSLjVsS8nhnmMvIP8xjCJojqyGa647xe1VWS304rTH0DhNsO2Qq/Fw2Rfp+nFtFJfFR3RfPyCL+hFCsu3eT/VW2G//QS+brVrfY+LvXjlqbw2UrvLQ20AoPRhCW66ML+nwbv0E8WvDLlBmpI24yFdyeUIVklBSx8CTgojSYlnIgIfz3UvnTYXoBPHIbwhfmLI6Nlp5LAKryuvgJoaEJ6092Ww0bjBLclFOJuuOPV+8JqBwk2Lr29IwdUVND3ccv7JrB73lic2fzSJXX8PB9LO34vK/2IZ/kw9bogXJ2LLNPiDrpMy7nUN8IMEgQVDLMZWoreeVZVEdj/esi3oZq2ZVt1hnF+lIp7hoPzje3h85ohxCssoEnVIsXH3OyBRqLVVuUVpPonYEP/kwjq35rTiCwEtFlxh6YIMFJ4W621qXa8SFY0q+Hb5kzoJJzKKA03dpFQ6LXLlsja0r9N5X030XmCkNfaZqLPL9IQS71j50FaaMPZnZ4+3iNRrgeSp8zG8IQIQjy/EbcTI030mGwI6FFIfqLInFb7E3TAm4e96+i/l2HR7dydXm2durb79b5fqyAbv48cNO6yUSdUHdU7v4jKV77COdvRur0atofsM/HkhL/0/5/15+YNktOzMf81s0q/Wl/czhEilD0mK6HlIdXHtxehYu8nrMtEOO2naqNw2sSACfjTR+yEpyNOP6Sx2rDjXDay16acTAubOdALYgecDSAWHawYDNyvzr8CaO2VjWcOpKVwZ0RqnO9QTbLUm/jU+fGS9FaGSKY4StMBjss0D8h5MIgr5V7
 zhhbWQ4N
 f/hg9ctH1OnPbvC7/IV6v3J20oLxa7Mg6BtyO4dDFtjNtStfYXnugvpEdPoDoRQcwNa4EOPy6tZa8jvqPGySXSMFwoMSwHBxBpO4BOMZ/BvMXVpliV5oZj4tSOOpk23RRaSBFC+eA3FCqZMp5490gU+s8A5TuaAdgpkkqy+HTQca+BmJa0hXKUvfMrDWXkLMroYe2795UogVCWEY0W2GTIdtkdfcx/hChPOjOcWbLB1D7TMcsvVjiIhguw3/EBX7ICAeX0TUHQR06q7ZWjQhzsw71oLcptt9JZMYGBdsP/0HCIhgdRHIq3lJD8WhwVsjjeLLiRe/zc4Ul1lxgG/+fRLaRhNFILPa9Z2k+dGuPVb6npCPqVA7TB7evqFJclo1U0JlU
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
index c6bdddee6266..95d6676a8500 100644
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
+			unsigned long addr = (unsigned long)p;
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
+			WRITE_ONCE(vm->nr_pages, new_nr_pages);
+			spin_unlock(&vn->busy.lock);
+
+			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;

-- 
2.43.0



