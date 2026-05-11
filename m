Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9023CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AABE06B0096; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981426B008A; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9B56B0099; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDA56B0093
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D246EA0615
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:42 +0000 (UTC)
X-FDA: 84754435164.22.E105C23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D60C040003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ln4eiZ25;
	spf=pass (imf07.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487461;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0XM36saQ9aVmWC/M6L8bh21gjKj6WiHYv5hYUUV+AA=;
	b=8kfoJDK9nxFbGE1r6e1jvzrPCg/8TGyi+mftzstHEae1j/lVHBMyq0EW2EOjdGbMZA3fCX
	JIsq5YqPfr0/AbcoJ6uwZgL9PqrPUBe/CdwaBndqZ3q+db8jWMz/2gGH4HgCVwq1TLK2XC
	ZQPYXoMaOD2lJSq56O6p+kizfGu6beU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487461; a=rsa-sha256;
	cv=none;
	b=0Wi0pmojNLI+KG54jUfWOezAEFx4ZgmTeMwXO8fiG15iSUpnM6jSRkVoPGhLRU92Qta6l4
	Zi/kydeGkh8Hneft9L8uchghxRC/7hC8raz0d7kspfJau4hRBN5vFbsUPs+EdR7V/7814i
	b8drLlw+C9dKdyYx3iIeeDh0AfnnExk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ln4eiZ25;
	spf=pass (imf07.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1180944593;
	Mon, 11 May 2026 08:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E81EFC2BCFA;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487459;
	bh=Jqo4TED9HuG8bs7dY11fJ4mAkfZHK71BmYBSb5ttQFU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ln4eiZ255dCAigpndUiO6CBmguaCBYc0uQdSF131tnTVsWp7NzhtCJvNBpGZZ5Ueb
	 cUhu5tgKuAHtZ4+p3rNYlsYZAuEit5JlGl2tbR/OxUHEOUF49zbN4PZp2baft1G4+J
	 DfqKZDmNhb0+mLdTnlj81sVio+cxD8T/PAtb0acxwnsqC9+yPsJXdJ7vbkvXPU51yE
	 QA/FPwLzGA4EDMtIM7XoGxJVaVdleaDdWKufxONZK1KJcDLBvw18aWy5Q2cPnh/aHK
	 ObFALLtoqj/b2pIQKHkHIZ+aaVi1r6wMNg1aBlZAJM5blWQ806YNHcrkfJVzvpT3y+
	 4nfLdKZldyoAw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F5FCD3427;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 11 May 2026 13:47:32 +0530
Subject: [PATCH v13 4/5] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-vmalloc-shrink-v13-4-643b7ec277a9@zohomail.in>
References: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
In-Reply-To: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778487457; l=4186;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=kfU4/ZakIo7xbcyPX++3+x8brIr6bumOe9FreCdlhcw=;
 b=TTJiWOsE2EtDAJyIAtXtdpX8KAZsIwiXDx+fVJTX1dZyfgXV3Cx3PWQo3KytzqtmqGVvL1UIK
 cnVIekZEibgBnJuuefw0JzJfQwZYSJt8hVkWK71B72PPVd1ZtVo9tE3
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D60C040003
X-Rspam-User: 
X-Stat-Signature: oi4ncnhhmq81a49r7bomk371wa8o58hy
X-HE-Tag: 1778487460-839751
X-HE-Meta: U2FsdGVkX191H/Bu3qND1CZuAnZGK/ydgps9m5u6YZ9Mo8Z4JlxbgU2YCknVFkmNuw/FU0d2jGgDaestg9FuspflUZRSTxTfJ1ZD12oPOXh+oSlY4j3kF8D0dct82sHNpD7lL08FOJrMJC/ColofQABSk4snAUWQ7VnENHoIUkqnvQj+NF7KLsvffRYCjKbEAGInPi2TBTvDSDv5oUGiV6Vav2an6zNcJ32J3tmuJy1yT3rGq0Sf2wPHCJspvh+GPJKfINggp3yLif1DKEpAWiSlB84DALKWIBd2ScmBcibd7tJcOFgneJQQaajpUI5GZZpEZZm0rjksfpXajmEx+JGS4jzdQkitn1Z4nfgDmPfBBuJlx3nHbbur+yTy8tSCHhegIFXt+lqDWp6Pjr4M2T3rWSHWV+vHHALqChWqfeIzPrr/9chpDQrjG8ZGmql/+zb7Hlyaf4JBBHefikQOe/YfIoLQb6gPS0aqun3nNkaf9f4H/aTjYxwkfiVyp1/MGJlc/eHACzg6/BCStHBHtAMMiX10KFbXWj9otB2N8QyNaNYLFXPhs38wVx57aE1045RVi39DmegmDr7NYjrdbo83s6OOmq4wxAA10vt5f3IDKvMmkWE38JTx2u0llJI6TilwtmpMXavsMITht5TTGy1AWwTBIHk3E7bsn0i+yuZbegBSTVgHTLfgdc4QwZ0gEvtkWOkW/vtCHv7T9Kj8CizJuWHpkjsEqWVgi2qnhdJ/QOLGn0Pmfmbzg8MBurGsuSv+Ccgs/Y+esZtGXrrwu+ejeY+LeGNeWcB4SAl4lVrUvR2VRyjMGkRcG8n147t6LWeNEQyAQx/DQfSc04OvuIrnUpfY4qKuX6Mk0J9aE58TefOGiLkPiL75iLJXoAjRdgm5vETzOfNjpxHe9xLAetctuXsiDW5So8INklZYz8gihrVpR9lfb0GXULvMJuxlvpG/lFZ7QjSbPDB6cEZ
 NCqtHAPc
 ibLiaJ7f1qq7lyQq1aSjXMGsds40srod2j5eWDn7d2JB746q8E/nR/cw3OX6C0lnMSVQq/44zXJ8xPjKrK4pp9rqbRpjCVxXeXeLJHogYl10tSgn2vgQCzp89bWvJxftS3c8zd0ZX3ZhjOwGmSg8l0RbQxqhVW1cJtZgwAD7gh0yW8ggvsZIY1+RO6EeiTxg/OrTk9/ixqm6SH/4jmBMnAziaSGr72aUz04n0mV4sDQyNmVEYx6xJV/ufdfpXuP7jbrlophaBYDdPbD4lk8iNhROI9cU1M+oDadORyCoxLHXp70uN8c8tmUYce3Qni8c90uMzc/3JVSQ/ngyubg5VECQ94pRlw+igqX3tvM4BM3N6TagTfw4goV5vvrl+jA33zIPX5GsTn5DFN9d+DqkZ15Jgm1IzEz+ptwWQ
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
index d69174afb171..4baa951c901f 100644
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



