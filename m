Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB008E88D8B
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 08:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3AB66B0092; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8206B0096; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7806B0095; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B22FF6B008A
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F3E1160820
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:19 +0000 (UTC)
X-FDA: 84620218998.04.0C7E8AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 21AC9160004
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C/IchYX9";
	spf=pass (imf08.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775291837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGihJYl+A9pvpFpUwARGJqYNZHaXst6PiN0CEpEbcHg=;
	b=qQWcsQHN4rFuq3N3bpr4Kzu7xS6a/pA6yWaXLnYpNUYS85jQ2acEP/1QKgP8h8a1Xy3p0T
	gQPUQtaBDlBJDXNjDvwY8MBNM6LF4afuer9ehb1YvvyIj24Y9hhI+pqNGQFMIOXn5zbDER
	E+koKisfgOMg6nNhMl3bhaZfC8NcsOU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C/IchYX9";
	spf=pass (imf08.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775291837; a=rsa-sha256;
	cv=none;
	b=RxjWB1lnQCTRDfxWBDi6J2Dzy1bS43YQ1UEjpkxZp2sJDrrzaXlzI5LzEE1z0+uqi4Wvld
	gLMJriUUvqZwri9e/G0V72zYCaOK3Q/7iOsQaN4tr+kDnSGps2bpjo0rakOqBMDe6rB3Gq
	OvK/I8qyarbU2OLZyWkhbRLGd32YxN4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24FA9444C6;
	Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01EBDC2BCB1;
	Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775291836;
	bh=XThFxJ8L8zzp8mH3ivNr+7GA22fgJiagDi51rDdmpPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=C/IchYX9uzAOieSJiu/dtX+taxIEQTU+iY/FWnYsM0OUwuMxt9IjN64NUE12Woign
	 X/NnOtPZZxSKb5tXJE2sddQdrYFfFurZYAxhBGYiM+bpjcvC3Xkrjn1UyfM5JgtZ7j
	 Gwtj6yjr5KcvTv/VhYEikS85EuYlt0jrKL7bJ7gl4PWhgNuYCy5+SxauFzx6emL76i
	 4c7e6VdN8GTrJfuzc3Q7Z8wcDSjZEWhIZtr1HuahKo25uxG0FWwwT3Yyhb9yG9psSS
	 I4Yx/9UYAgPIrSeVPFSQNI0lctooWyrPijyqBP2G+KN5qd3gU1Qp/V9lAd0e6nwY8M
	 NMuPPtn89aehA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3C0E88D93;
	Sat,  4 Apr 2026 08:37:15 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 04 Apr 2026 14:06:59 +0530
Subject: [PATCH v10 3/4] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260404-vmalloc-shrink-v10-3-335759165dfa@zohomail.in>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
In-Reply-To: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775291829; l=4129;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=NTcsJV6Fe2i65TzPLdK6tq0Gp/8YPdcZEqfefS9wmas=;
 b=3xy+2OFbgtn27Z6rXBw8u9PZX1QmZS7QrK5pPrcibCMj2J0VPpUaEYe9UCfbek57I+UsoCH7F
 d93ITXGkvMiCCoLQHn44KHjP+BxBycLKQs/ZYPJyFPK8e7aVmJ5Wa4a
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Stat-Signature: cnto6g9gxtzb5t1wku5sp71wy1jcp4h3
X-Rspamd-Queue-Id: 21AC9160004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775291836-207886
X-HE-Meta: U2FsdGVkX19XCCHvLyUuibHh+UobNwz5iSvW04pR7Dwx4+KAX96wQvthkHK18cO5K4xPGMB+eRKD5W9k9Yp15SWlgJY1TEbcS9DXs7mC/mdQ++qBNSPACdsIvJ8X1k+qpD8SdmhMaryRspp7m0+25zWlw+tXHkMh1a5nLw3OV2cznz8I2dyuY7pPINXk1AoWfvWyjcS2gHu/bHBmimrQFhOUa9NBgwYxs+MOPKunydYppLHKTUWnM6luGIDN0mZTaEdfmbOReCnv7fcy2cUFki0rXoJTCCAj4Y3gfwz1cS2Kz596dlNYLidKpfBEr8PqhuJJHuMGkb6dNJD52dhC7AQ0ow+SpKjwi+XFGaVkUBACngZXQByzVhrfi4N9/ulHyWCqr2vGbxMcZ1yAtW1T1hazJdG+prquBkX/5M3emGJHsytAPoMRUnTII4t0aaoCDV/tYILKVx4obcwoR/6U43btr0f48rzSMIEoYQYOJua2ymrTvB9yR/nj4B/s3o5O76oG58qfmIz+BoFn/tuJSDrejxBCVrAgaJU9lgh+/Gz9QLq9sGaWpo1CZNxskrJBvjAN+QrGg32ZwvcX9boa1CGcuLnAQGKtTvc3AKAqMZaRNJaL58B0yFu8AA/8zMmgHlL/io+J3SrUaTSRrQtYSLuDqnVSSeBL/24wRFqV9woiEmfBii6x5+7rl9fW1rGPjKfEYP/+2UtLljWcmqjfGyXUTjOAu62cfl57RvjMuqTzrpoGGLG7N6M9Fbkn8YdtHeTzzn1fcgQqsgvdQh4lTcMRzMrNAOdt3+Zvn4KYw8tjLlqvfOvoerUv5+zrUz5QlxO0Bxk853DLz8sImOjl0efVCs/0MDbtGk9+7GBxvpCNmzyse81yMSPbFXGm5pQnatP/v44vtjgo86UKCDbqW8TvK7RmnkVv+edQ2+mqJweBhjlUC4LOJrIeFIEEsYEWo0YL3CPvNQSYAa6EW5j
 hynleH2r
 Duoj3B2a0kQL1n40eHUJglO3rjR9uzucsatDeg2oqxc2LwWnwtDxQy2HcRKCvSVh1GxFgCT8QRVl46dgWvMJZEme1xf1C68Z9d1b5pPL0Cj8nsbObcwRT17/PE/pkyc/cU/ZDrvsxiCVjkM1FjzGYmruXNJQkjnJgMDa2th6F4nZUP3rAeL1kYLw173jCbxzLYHjlS+6ItabwrSiv38WMNa2YyRcMTgJYY1FlmX8sW17H7FF/fmIMDP5z+OpBCm5ZZs5rhWRSYBxJ6eiEUgAUmdISxW9ZmBP0ea4JpvFWlK/Jz52XFLXPkZAbp+/yB9zb02q3Wq3gTBlSN44hKB2Cjy5rlq/bvyjwa4/Wn4tBdPGP8mdzmhN2fYXZI9pBqqk/2Fio
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
index d0ebe16b584a..05b121845df3 100644
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



