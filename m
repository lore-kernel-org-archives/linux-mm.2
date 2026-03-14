Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B53105F7B0
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132046B0089; Sat, 14 Mar 2026 05:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089326B0092; Sat, 14 Mar 2026 05:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05536B0089; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 809C66B008C
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 421F81B89E0
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:06:10 +0000 (UTC)
X-FDA: 84544086900.08.11332AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 047AE80012
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:06:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTHy3DZJ;
	spf=pass (imf02.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773479168;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wODKUDqIoCsRwr0nIJoq3+LWhTnB+tZAbvxW1S/p5Gg=;
	b=E7ENeF3g108H5FuRgeKwNcQYXfNSdGbpyonhhmv6JMmzHAMFfQRvD4PCPmuWlVrtN+iUBF
	AN5mxnrWod6oCk2/fehRyzp2xd6oP9pxo6TQmjFGIYoDnEva1VSjx9k/zFPVGdJ6h8NT2w
	sLRg34VAWAEJpwynzuk8SdyS//ZeVwQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773479168; a=rsa-sha256;
	cv=none;
	b=BcAU9+zMRm+OyHkT3stxzgygLj3RdCkEenFJlQI7DoQRTRxfP7Ba1lmjsPgZzA6B8slD6G
	MfRMtQgkZqKtHyW0FQEB53Kv4egz5kvRmhHjbv2fsKen+Cdic3M0SxOeUsRi6yVAr/N866
	RPAXzICBfrJcqO92Y53UwK3XMTSigS4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTHy3DZJ;
	spf=pass (imf02.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D52F3409E1;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B32B8C19425;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773479166;
	bh=4qZxeLqHO5fNZfDMKipa9T/OALGStFY6kMWH7o39vXA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WTHy3DZJ9mYjgPX5Oc1a+hIaBkpS3tYhLgnpt6A56nAagHEB5bK6W2lXigMcjFlFr
	 r/Id6iEUGjW+SlAET/U6y+XgIFhxH2SAwKUxn02q86/wuI1DBbER1OrvxHzBxmMikm
	 4X9RgCcXssY5u+glZPb6ifyhWN+WGru10A82Nv43hsIht0+ZkOVs4eUm6kuvnMwGkJ
	 ZXXVvSqDMnfZttMsjtTqOAmbJ3UWIrksQj4KPbUYZ9nvcEm6JgpvduUHDBCRyR9UYs
	 XBh5Mw6OopPq65qcLAfiLfSlJsMGNeLY0QnAPMbH59sN7OWllmsgKPK78uQhxkHwdR
	 4SUPnk8rWtWXQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DA0105F7B0;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 14 Mar 2026 14:34:14 +0530
Subject: [PATCH v4 2/3] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260314-vmalloc-shrink-v4-2-c1e2e0bb5455@zohomail.in>
References: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
In-Reply-To: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773479164; l=2543;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=qiLrg/KiMgMQgQ06tgY/qjWWfVqF7Moa3eb5azEQPMU=;
 b=JSgIl8t091y/VKSsQI5DHU6yX/zoZKbxLX6f33+kCAYEstK2d+ExBt3JJ42ubUxhPL/afLIXy
 9RqAAyIaL4iDI2wyTUIBa/shktn0Zf1G93hgQP/weRS+R2Zs2taVyZQ
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 047AE80012
X-Stat-Signature: q3snst3ioum1c8b58j9kwnp365cjyyrd
X-Rspam-User: 
X-HE-Tag: 1773479167-804579
X-HE-Meta: U2FsdGVkX18BSpg+rfewVSz+9TAhUHfHmCvBK50NFna8qKLuIY7tD1+dph66YgcumwwBjsiQwjJE0pyUBttCS2Mo4OC6Ih6idbjbhXjbXywQ2JqUUPCVH2ZrUAaWhCrhOp5Yqk7yBh97V26o6r77kWt7mWFbamItvPl3RwLg/d/VLofGU6z2G9IJ3/meuo9OYzfDUSxS9ALYn0kbqyNYumjBxDWyvgxgJ95OhIoF5aDaP6QdgMjy4vf4DpMPZ2jPd+hKq65hL1nHC/P4OAGf2/5UX1ukUspyTtwv7q6afdt1+DsosEtBuIOzBbg9lF63MwIEMRevFJEzWTB/lB2i9gT9w8llC5hSWRFqOmjP4dE3xcHKt7BJ1qsvgcBOolXkGTLBs2DeUYzYGEsqXD3aIz2isAuQBI8EfjK8ZjIFB22YnygkbJL7i+M4YgOqGog4NviclQBIWGBFdiJdUIUSHP8lU5vjkYxKdZtEei3k9s/SbCxyQbakoxQkLtDmCkLSouqA3z61lH6WkLhxKoUNafs80UGSi6nsqXz7J6F51Z+h72WpOUvFponLSKsc/FV1B3N62CbJFmsvhCTUlM606tRg362gTisZHJgGfvb9m0xnK6S+7vIO7dbGtYqPZFhHyb5YM3U2ou6xE7vXDNzDK0ZG4OHe5AP/xbHLtem2FRQytiS8Vpw06J5sBZDGkXd/sAoJI/fL61hF9HrQ6mlqD9AGt+U/hGXum3BxarSbLTPZGHEPwq1wqOO/tMJ58cluO0EbhXeHT9ZLKT8FxdnHD/YNYxHpq27FCTKZjmUrhO90pAZeMn6PqgmoleQVbKN/zbNlWVECrPE9A3ZDnrSYoInJMaGKRngtNdb/jD2Sk1wHwfo6iasKNIMhjewChx6RQXWejb2gsik7CT+ndAolhjm/lw3FISD1aYoN+nvA+zWNJZ1VG6kMsVfNu1x25JKWh9ZmtAXOdqescGtE/4t
 1MR7FXo1
 gsNiLiZ/RQZyP2T0r7G2vk5UyliSCRWts27Az4+G1alXt278MyHV+jb5Hg1nDwQ6aBPLNXd615Fv0pOCz/aAT1y5o++qMdAbI/GWdrpXk7Ms+6Jt58Ksa/F+njFdRRuEUSaqty9zZpqH8YEnKUBTD79oQILBpuqW2k0WN1HfWL2CwiSLsP8pL3i9McAmuPW934xJ1bQOWMeKXVZi4x6mgo3brnfBQ5PWNVjvwZFLXTpJUDFME+bnirixqzDtQFf2/1ULN8/OLob+nPVKKlm5RuIHKnuMce7q+ZAFo4NWnNvKhbfGLlrgGsf9SGPBE+8+EXfhD41RGccnY7NYLYP/2RdouA3fDcUNCLOEfvMizQkPKJx4=
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
freeing would require splitting.

The virtual address reservation (vm->size / vmap_area) is intentionally
kept unchanged, preserving the address for potential future grow-in-place
support.

Fix the grow-in-place check to compare against vm->nr_pages rather than
get_vm_area_size(), since the latter reflects the virtual reservation
which does not shrink. Without this fix, a grow after shrink would
access freed pages.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b29bf58c0e3f..2c455f2038f6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4345,14 +4345,23 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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
+		/* Free tail pages when shrink crosses a page boundary. */
+		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm)) {
+			unsigned long addr = (unsigned long)p;
+
+			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
+				     addr + (vm->nr_pages << PAGE_SHIFT));
+
+			vm_area_free_pages(vm, new_nr_pages, vm->nr_pages);
+			vm->nr_pages = new_nr_pages;
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
@@ -4361,7 +4370,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



