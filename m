Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B97CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AB916B0095; Tue, 19 May 2026 08:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417B46B0098; Tue, 19 May 2026 08:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262D96B009B; Tue, 19 May 2026 08:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E019C6B0095
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:12:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AAD238C91D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:34 +0000 (UTC)
X-FDA: 84784057428.13.60755FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89A994000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcTfvcUc;
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192752;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QPCyv9lQJFyMVH80qHt8FfoNsvDGU0EEvK/lRPKUHE=;
	b=D8WWD67WhHdcywkYm33184M+Up1oJW/mzhR07LHnxDkl+idxOekz4o5eO91/DMvonx9aBk
	r/52yWfyxptNkNg999XLvDfFeGAMMa5HiiAu+HpSSJu+yqHvpe5FiCn3l/YYnBM4YXWOyR
	8raEiN/bmpzeGw6EDRuEM76fpCQYfag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192752; a=rsa-sha256;
	cv=none;
	b=opm9WtpGDceAfBKRTAwn7I65l4nBMEsYvmfnIguMQC+YjJzRD0KNIpAqykvEW3tdGxMuSd
	rZZNUlPJqjlhvUq23ShdlJCnA/NwdB4FgVu906LCEPcLsCCcotcg9UP2k+15TarM87VqeE
	4NS5UxVDXxmvGMdGk19824TdEwTC0JM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcTfvcUc;
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79C8844550;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58571C2BCF6;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779192751;
	bh=kzxOELvI03StZULzOSrGFtYm7t4tK35U/3bSVguwEnk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hcTfvcUc3fYIat2GsWZ1uo3Ku8INsqF7cLlm5zEb+MXleqnh9mMpllvrjJ37Q0D81
	 PJmYoAPIjx3t7SyPkqWCEwaHf987tyds4DaKO3fM4ClP9R1m9Ktuu+n3yenzYXo6pU
	 cFcK88m21uczd8b9qz50GOl3d5EsYrz1lnVrJEneFsKNx9gfe2S792D/stwxN1la0F
	 qxzfOJeGOr8XnUlfH0HEziVjImzx6i41in7yAvsfqHtaOHa9A3ihvTDA/Qz5yZtZyi
	 S1v2aVPqH7tZ6gqKgxfOWLMNvm/gTf+cbhkouRHA3RCpnDxTGMX1gsrtWyqvtmSJ63
	 gWCTJNQLqchfQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9E5CD5BA4;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 19 May 2026 17:42:17 +0530
Subject: [PATCH v14 4/5] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-vmalloc-shrink-v14-4-70b96ee3e9c9@zohomail.in>
References: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
In-Reply-To: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779192749; l=4186;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=JWwYna1z+im5GzJcD/lBquWI944uUkw7bLFPCe6kW04=;
 b=i6e63l0ACVS36Cc+z2Ha9I3XK+hOcrdvYWstKumceo/6PSgfVjaeLgOm2oVqdru5vl/VH2NPO
 Yzc3aJw8kYNCIF0ejwgbEVWmq4FK97XWCwH1aJ3qytSqXrs+hoxWWxu
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89A994000A
X-Rspam-User: 
X-Stat-Signature: g19u4m93f4yf7jcwdoabzmtmm9rucxu5
X-HE-Tag: 1779192752-786496
X-HE-Meta: U2FsdGVkX1+uAvbQefJK8r1AWs3yFBROZTWlZCfn+KHzow4UsvhgQzeaXCov5zOMj5kktGzQYxGNUQqHv5KOsvi2ACNWULsD2WBVcdXUmfZeXHNPwspF/OE0qBcKtD3hDCoPETQWcgI5na78sC+1XngHIkWnPZ8AmKM1OdcDwOuuKttJk5xsuFTkIgKOiBTDaTlXJHLvYjIJRMhLzwP8SKim6C5tkREQoSe8kmFOWDs5U4IUfVoe8w9/wuYKwoqWmFS85qtNgQjQ7wBPR4Ps/8Ice1Po1IdVfAw89vngZpyN8SoUyFWXRh1O5J4i66/COwuxivT4yfP21urniGJy4lohcGFhT5BP+Z7t1gjTRJrg2swrBH0Hqv3WmoSYBjrR9hF/OacmQFTexw73oKdHj3HtqBLKMJvaR9N+TQiLxP14jquTjSnFWOxm4euxuMYL29SyC7Ht89bBp2aMnXjoi8EuMum9mVJknfiK5zTJAKa6CRkQco9z/6TXU5Je/HN1go+CX7S5Jqn2mFcMV9i0rb2L7cpJ1rBGTA7cDdxW0OOWXOx8emnafhkikvzMp4l3VhSq0VCY/LXCOxa9FtdYnK1aMvNoXSbYZfHzECdhBqxe7U2sYBxR/IYQqMLSl02M9i/q1iater5srQNkiJ3nDjBWvJ16qbsOij4mDJghF2b7BkWbX7vUVP1sfv+XWrYTAnOrEcKnshF4xIORVPWSZln5QXOPrTGiLbMUDnCNu12O7LGkjAijyw1+TqlowYMtiye5GgCIv40nejF8eaQouHhS6rc1cjttQQjCws+9y0NRKj8L/GnwcRGQqmuDNd0LHbmiCJHEBYEpr0xhthlZ7tbS5M1ZNQURFG0QsBCM09uIgZJYgQh4pWtkkvcHeQTAcp+4zQI0G+7SsnOptMSi6NzY6SZtYGrABMhIZ6/Cq2xb0oZWfYZ5FoHlAWR51YtupfaVBNwAQBEMG2GzLL5
 S52ATeyv
 XW0a+5zHDXZENRlkUC164ad3mcZcTvhkFL11Q3HKFhXAcstrQYueBkf3ThSrLtT/Awz8/8CYJIhKbxq99mJZEc8zRRsMvLlIxJ6QdeykTge6BYbxESA0OZqUSOZ6qZjpyrGLv5if7KjCWFcn31OQ6pOJqtl3w2yL+ybumeuPvp6fwjXePfwn0xosKbwM67UYA+I01qhbcjhZcgZJmoD/U/Xbp8Gw3ffiykslyOdBuYtEm3b4U8C+KEo/xtL3ge8my2cjiWuGLVkvnmZdFoqCxyR/ceN2+7C4DsRrt1ni5ges57epMeymMUo3l/DidBQYE/osQvtLozGGxlYTBXMk79O5y3w49L/QXfchPUctuWwdE475Q52yO24RskjEsEF4rdXtjaCPndmElKoaKV2d+cQAqiMcWYF+TQdHd
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
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2f606cfade9b..12b750bb6d70 100644
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



