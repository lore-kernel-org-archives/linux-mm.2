Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23AF4EFCD6E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC376B00A0; Mon,  9 Mar 2026 07:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75F16B00A3; Mon,  9 Mar 2026 07:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA076B00A4; Mon,  9 Mar 2026 07:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5156B00A0
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:55:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DCF9C0339
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:59 +0000 (UTC)
X-FDA: 84526370838.29.346D57E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5D58940005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JzmisWH2;
	spf=pass (imf01.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057357;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vioSG5etgARAF/MCS31qccE2CTWZpsVHcUbeAdVD07w=;
	b=q9z4yIHJC2Za+Klht/t4jdig3xM8mLDE+ijN03P81okpaEIcq7eZvhd3zSF6ucm4UqJyUr
	L/rZyAyeXq2ohfKoG4yJS5f3tPk+9BACa2zLM8ar5kF2oVcqx4lWb0goPZAzEPxJp5glfT
	to3liXdMKjJZlpNJgwDFO2Gpd1//zBo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JzmisWH2;
	spf=pass (imf01.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057357; a=rsa-sha256;
	cv=none;
	b=REPJrzL5DiN89t5UyMrGv5qw/BFU4s+vOdVqnoudzhbGx4DsoLrEteLz+/+p11RHP5tDMC
	lx8lhRgYxfg7f4LdtyTGwEHoAwbt9DQ2YqX2y00JrTgUWALLNp8prRA5VVL34vGe6H5q1G
	Yb6IYyWj+JjlWBrUanOgf9O5E4Xd7/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D409E60131;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89907C2BC9E;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057356;
	bh=3Y8n25DOYo0e+ho5griIfe1BRl4kOFl+j4nscLRC4B8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JzmisWH2aRfp/caW061bFd6BhZ9DvkEet1qZK1U1ldiBolCA97Y5vrvrGjBZucCvp
	 MEulNMLz1/OgsQgnFuh90yVa0Wx0L5fc/c3n4HbwA8/Xwat8e9bn+mdmfdgsFISTvM
	 wR+NNhOzIvpb0iX0QgnHob8lJbizCpF6KTQtXl0q0e6pAN+iObQj0SxKkfZ449b25x
	 L3duVqLuLiFyTVo9wSUrl2ZiCV3j2eqNQzAFC13bB5c8uSYaTij9Pg0XMEwh0wiP7j
	 oVDgVEaAsKAT9VsMjNh47VXfGu9SkdEVKxNGog9C2O+9b70ceYvM440iK/g0jNhTrq
	 Bd1qmcPeilagg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6F1EFCD9D;
	Mon,  9 Mar 2026 11:55:56 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 09 Mar 2026 17:25:46 +0530
Subject: [PATCH v3 2/2] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-vmalloc-shrink-v3-2-5590fd8de2eb@zohomail.in>
References: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in>
In-Reply-To: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773057354; l=2543;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=Y6w6SdmqyOX+lKwpSwN3cQqWUNCycwjirQc9nEik+Gw=;
 b=L/WqM1MJYwB7vVbM9AOGxxZTpnHqTAxqZxh0e6lKXHQvPLuZXyjB0b+6gFXrLrBkH/mTyqQkL
 aS9B5mwSnayA6paU3NhhXeQ9aA0U2x05yDdAvgHLU3Oya8ycfErgZZd
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D58940005
X-Rspamd-Server: rspam08
X-Stat-Signature: ou4co8dth6frh3xkruu5gxfb1qu7sf5i
X-HE-Tag: 1773057357-592240
X-HE-Meta: U2FsdGVkX1/cgh6vSXGvO7WDSCchVtDMHgO+IuPdkKRGtrPp+4oTpNpGlKg0xbvvOkKSJY+IicALuc4a2ogu8ejzCfzeHBALpWjMGG+qrxXzcYSb4qpgtwNKXTZ7Ay4DM/O02VU2EX5zDaTtE+WoBTEUb1fUT7RYANQvlgv4CPBLsGukMrQGjGHeANH4S3BvoqBAQXT1vVzv2YrL0Njm1fl1OvHXAt26MwSs6i0ZUU39RomYsNQx4o4E6Q2ddfUq39cHSu6sGgJOP0abK24PD+7qRY0wBM0lNBt8i5Nfec4Fg2kYIRK3ivZqU6bGhdPl9uJNlLg/6yX6Er57tfzj7oQlyjCq4t/u5kKCfopYJEFvVROrzqvTfO+wOpuOAlJviYCnehNjc37bDvck5JEpV/6Duti0TeU4u3EHfONYenzCGUGW7FuFLitL7AyJBhMaqhzIjiq2Y0nLeuIY3Qrj/IX3cl8Fx73cyDw9Fd98ngxd93OxHwluGmMyjPnC8wFCdrf/yEqCE/K0B4AWl6kqyayH49yBDMzLbX/WaoL+ZyZDgypjIhCPC+M1noj3rFZWf/0Ra0S6yKFq2MevpHoqjtnaLEOJeTeX9BmjakxQo3K5/VLFcFlO/3WL+BOZHHGGmWlGIlyWlQBEDXrutwWBDoeDnuCcqyTZZGvs+cqpeM9vyeO2qEi/lMnO6YTXShpFkl/uLgjTNgPiK+TGIG72jgPDrkXV+iAADx2YlYdDOkGYuQggJ/VUBnJRgR+2/or9aZ/Kw8HlVBjT+Cc8YFexbHjfENHL4F0s98sf1I7xgL2UwUo9SXhaV8sFzim2ovXxouQjqDE3fU6WWi7egAG7GPyNZAR4O7j+rCLmAlyYK2au5QlBNvvOiSsoN1cD5crDTm+OSfw3MR5VT5oxNc0zihESQQxdGcb7DyD+69gO5QWk0veFZcwt4BX5kTITiAgoFpLfWHhxHzV2IbGOSXS
 Bj4SmpUg
 tWhHoCtg4c+Qt6goNYuNh3FPfh7aZDpPXKUr/s3O3BeYxdReu7uRI6qHnr9+rBt9JBPBPIJKBBWcknje1EeviZXF/htp30HIMmBSB6LOcj+DqTFijr04/oyfc+eDOPTmo6LkOZwgLpjRonF9JiEJIPT37ed8Bhb8KpgsOZcYrhCTWxSheMzpDgVhY0XBjUzu7T+tRVVHEZn8ezh+QCUoV6wW9ZpddURTo9w/11heFTEz/G71clJVQ9WWNWaJR6bx/+Y2OTQUQgmj2IHYSoJHlnaBxh+qB5B4/L16BFlurcZdztxaGvwVtLeKdCxw2+HW3Juxpe3AJCMcj/YAElExJfXTtP5PrX5QejF3Jwa+tdA63nXw=
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
index 42ae68450a90..114e0bd1030e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4344,14 +4344,23 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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
+			vmalloc_free_pages(vm, new_nr_pages, vm->nr_pages);
+			vm->nr_pages = new_nr_pages;
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
@@ -4360,7 +4369,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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



