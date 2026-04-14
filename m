Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7152AF9D0E9
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 16:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55D96B0088; Tue, 14 Apr 2026 12:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07246B0089; Tue, 14 Apr 2026 12:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5BB6B0092; Tue, 14 Apr 2026 12:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6296B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:58:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3157856B5D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:58:00 +0000 (UTC)
X-FDA: 84657768720.08.16B512A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 53C821C0003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:57:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RdWMhD9a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3FHLeaQkKCMcnyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3FHLeaQkKCMcnyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776185878; a=rsa-sha256;
	cv=none;
	b=mjY2iSjugiLKGisW67JzqbrYVqGMbKWQ6ZAbkCiWQlfDs9NU23zq3w0/9Y6uUz0+SFD4YL
	BnrxZ3k7oG3Fh9xHW+3nIOYwOdvD2op7bIcId+9o9MazM0+vjwXWb3BLCmOM0xDsaXqOQj
	LWJc27ThacKqKmA6Uxxi8CWs7JeXgng=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RdWMhD9a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3FHLeaQkKCMcnyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3FHLeaQkKCMcnyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776185878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkYGbEc6QvWyzB+ejatgY30VNPQeVmDmmsT64e5J5sc=;
	b=fpncsDCZlk7LuyT5Xf5153eAXJF5lrW+uAet/PqBKM00jPL2TKuwuuF+Dg2OUWe8vHg9Po
	LXb8Z0QELf2EOcjuNO861EGVt3fVkcs/n8+At/NQ8YgqP2kZMB3rpPMlWwaXiyUT8aJ5Sa
	83aMnP5Mpw/0G2O1slKz9OwZvB/V2+k=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488d8deb75fso28124955e9.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776185877; x=1776790677; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UkYGbEc6QvWyzB+ejatgY30VNPQeVmDmmsT64e5J5sc=;
        b=RdWMhD9aY1NrpLBD+dLeo/q8RqucfFA0dpaRO4XleluuED3Muh/HHD5GFWNXKz17Hr
         +3G1euRNIi4Dw2xVvzNsvH0sAujJDPodC7LoCcJD8sPYm4SHko/TEBpANbMOkagtKaI+
         o9mNFUDNaVyzvEnNX0hZiB1Heg5+JegQfn+rxOTiVtYnneCPivTife8R7BCBtRUw55Gx
         wkZyhylik8Acq92LAIkBFv3bnuxV+99JYgry5tHWEEzVbbwm0novuSK0XP3GGI9wMqOd
         oX3hTSeRWNjjFH9oCspzFCu6A9rVYbKRIOg3Wa7fS2d+C0QFSS2zipxccCXKte3RsznC
         jv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776185877; x=1776790677;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkYGbEc6QvWyzB+ejatgY30VNPQeVmDmmsT64e5J5sc=;
        b=Fdw+CpDvVzPbUogDGsmnK4w8QSo6D5kffUKwNE8rS0GMISOl3A3UyE5Zz6x9PYxNII
         h7VdLUh5v5buvYayFjOvRRD8VaqziAJ4YqthIvWpmEdwtCQ3XH+VOlWXqiC7DC76cJ0p
         z19YkGkkWWEj/0CCoF7+p2O0vhxfsscnOiJbPN4JO4MRSEOxvDdF2782qJTlyl+du8bG
         7h+fLCoMUG52E4T8mzUW4qM80P+xK5xJJc2h2NJZda9w0i0pdJTMCV5oO90gPpgC11NE
         nRbEwUNMQzHXzxY5Jvk9yvF4JsjZAkdkVNZnjp1/9+D6n5E3gOpmU/V5+Kas+hgJyxms
         V+FA==
X-Forwarded-Encrypted: i=1; AFNElJ/3RQJb70eEN8ocB+RsGRT8PdTkU1t1Lmy+2mVWkgO2s5CnFPHod5Ihi8HX1S6nDmnzaB3wqnF7lA==@kvack.org
X-Gm-Message-State: AOJu0YzHv17sym1PzhXDZB/mmSN+FBlIfZ06HxzZc6fr7b40C+JsbTWM
	C4okvuehP12S0wO6p52NGvggX12DvejwkStysE9mx3rbghR3MAr9ttCYaxEDuaLbl3m10lqoCVL
	oNdAs1UjCYJIFvWecwQ==
X-Received: from wrfo7.prod.google.com ([2002:a5d:58c7:0:b0:439:cfa2:e197])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:674f:b0:488:a82f:bb9b with SMTP id 5b1f17b1804b1-488d68cb47amr264888155e9.30.1776185876348;
 Tue, 14 Apr 2026 09:57:56 -0700 (PDT)
Date: Tue, 14 Apr 2026 16:57:55 +0000
In-Reply-To: <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
Mime-Version: 1.0
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in> <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
Message-ID: <ad5yE0sgV1HJsyaC@google.com>
Subject: Re: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc() shrink
From: Alice Ryhl <aliceryhl@google.com>
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 53C821C0003
X-Stat-Signature: jsr5ou13myz8b85dc45c1qy78yiix6fg
X-HE-Tag: 1776185878-679108
X-HE-Meta: U2FsdGVkX19tv/a3iDXRKP2SSBioR+CJLeOViaNkmX3EYt+n5VwqSeIVlxofjW/lIUyQuGVTghRGH6KIs10YUomuvQ7OkrhfNI8YI0wPwVhqfms4la4fvyVI+W985f0vj6rGjY1EqD5B1YFElRvn6MQjHoHh2F5hcJO0wlt4FiTBkWk/D/tco1EBKBpaAo7rnZpBj+orfeOxevKmfcNeGN92dZq8D38/F2Og3ndYgt/2AdW7r/X0sbVpPvS3KBHqnDvDeJOPsGVydWkVMni4t6gmyzRMpmnuEYeq5UWncMMTssFT1yELFo3alJMXPNmbCqIFs0z/gOtqPw02qCN0UcKJTUMJGc1PBtc0SL14b9dnJQQ7ZnowySWxJGpLN7yW9D4k097Zl5jGiu2mNyeR+Xb0tDGJ4r6aZlTZPnBPJAh0wlx2gYHtvb2yqzJg4VnRqCrQ7UyWoqjx8/7M1kO5XNyAGtatYpLF1qjI/zO3JLmAg4C1tiqLjy8W2PXpDo/6fLr7GQy5sf8wDXUqmPMhne3KGxAfGF7pUxlQljDYmGdvotefy5mhshLrjR2sDHdRRlaTrqOsFVzrtscUG1UGugigG3XKxoi6NPmnpZeag6jTQZDfPGdbfr/qiDBWv6YIH7M91Cg8zQi+TauSQx4Tdf/HVkB8h+Cz02Q2a6TlbSo/kR+3+87FkfNe/qxI45GmjqT0iKaUMwmDC/l7JVVfq2vxb13AJfB3gPO2ZomT4tnnEzBfwU5ZaZtnuIEyWAS4kXjpzt8D1m6TjuaEfrSkHBv5vqY7Ce9QHEV634susk3qdhFjCvb5/qLc3gloOQEAFhSKl+By+z8vAzxvpvukdpQGrrLoi4Obfj/OIxDAOpGcOD8bqA/9CvY9iSD7cV+e9DKFfrHShLdoJsCVWKOOjIDEC2vGT831jdwPohLGfHYpxWJ8WzJZewgejh2RIzhMJQk1419tMhFs5zfQX5f
 CL/EjODU
 oBaf1QxEDmJhLCLgV0uEDsyzsct5/xiW25T9Q1aQZxdJmyo2cVNbT+1/arV27S8sEjYzU/roTyYPonJtF2Ud7kS7fGLvFmSoPYlNhSt/Y7n7WMpj2kGZZyomqQiHs4xmdx43fljvWi3L3mDTNzqNTYXnh7RBgeIPHzBUFgpXSULivbgyvEIeBUl1//FIx1QJ30yi0Hl9lD55CR4v+QD5n6KtAl+INs5KsZQyVsWZ0Sx12CBgxbClpLfotyK61XWXgvR4LrvYmRe8YrAUY/rfJ4q8aK93kY/y9ojnS7CBrFh41mVgVjuCqqsY0iUu74NWzvgHlnUOHwj7um37/p7YDy1er95LoXXCsVGmdC25ZAV1fZTgaD4p0uWoYGs2eqVNfG47XD04dndjGZjHqVz9wck4TUWknQVIn7/e2y7Gtxrbk96CfaSAo8lgb/u6rrCWqXIzIXOvtFTfkNyyu425mPN+w1WnH8oCnt/2hePqbZmKm6uTDVz4FBJcBHP21ZgNFRhkT4mDZHphDHglExLOpdWdxwND/WbMjeSBC2EAjipyRwLnIJYUPc9pYCFHfbJEHAO0XWJZHoyApAyaEOf9ykFpEIc5k5VzADWr4zQX8dqTTzV76QfgpAlxfpeNxO5tpDddINg6HPXsj6PcAhmSA4PLjVcLQujfui5TL+uDhaszDbF/Q4JCpcIL2WS3uGP4RsLrqVhz4r0fjwTipPv4nn6p607X+afIiNekX3ggpVwEN7nlricVk5zqen9Unn4CDIyjQqMpTLjy6fYA8YRIiYpY+wkrrmB/E0Q8CjLTeRye4TRqMaJ9Eprg/i14q9EAQaxvNmoaxS4E6WFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 02:09:09PM +0530, Shivam Kalra wrote:
> On 04/04/26 14:06, Shivam Kalra via B4 Relay wrote:
> > This series implements the TODO in vrealloc() to unmap and free unused
> > pages when shrinking across a page boundary.
> > 
> > Problem:
> > When vrealloc() shrinks an allocation, it updates bookkeeping
> > (requested_size, KASAN shadow) but does not free the underlying physical
> > pages. This wastes memory for the lifetime of the allocation.
> > 
> > Solution:
> > - Patch 1: Extracts a vm_area_free_pages(vm, start_idx, end_idx) helper
> >   from vfree() that frees a range of pages with memcg and nr_vmalloc_pages
> >   accounting. Freed page pointers are set to NULL to prevent stale
> >   references.
> > - Patch 2: Update the grow-in-place check in vrealloc() to compare the
> >   requested size against the actual physical page count (vm->nr_pages) 
> >   rather than the virtual area sizes. This is a prerequisite for shrinking.
> > - Patch 3: Uses the helper to free tail pages when vrealloc() shrinks
> >   across a page boundary. 
> > - Patch 4: Adds a vrealloc test case to lib/test_vmalloc that exercises
> >   grow-realloc, shrink-across-boundary, shrink-within-page, and
> >   grow-in-place paths.
> > 
> > The virtual address reservation is kept intact to preserve the range
> > for potential future grow-in-place support.
> > A concrete user is the Rust binder driver's KVVec::shrink_to [1], which
> > performs explicit vrealloc() shrinks for memory reclamation.
> > 
> > Tested:
> > - KASAN KUnit (vmalloc_oob passes)
> > - lib/test_vmalloc stress tests (3/3, 1M iterations each)
> > - checkpatch, sparse, W=1, allmodconfig, coccicheck clean
> > 
> > [1] https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/
> > 
> > Suggested-by: Danilo Krummrich <dakr@kernel.org>
> > Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> > ---
> > Changes in v10:
> > - Reorder vm->nr_pages to the beginning (Alice Ryhl)
> > - Link to v9: https://lore.kernel.org/r/20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in
> > 
> > Changes in v9:
> > - Remove READ_ONCE, WRITE_ONCE and drop commit
> >   about show_numa_info. (Uladzislau Rezki)
> > - Update the commit message in Patch 2. (Alice Ryhl)
> > - Remove zero newly exposed memory commit.
> > - Link to v8: https://lore.kernel.org/r/20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in
> > 
> > Changes in v8:
> > - Strip the KASAN tag from the pointer before addr_to_node()
> >   to avoid acquiring the wrong node lock (Sashiko).
> > - Rebase to latest mm-new.
> > - Link to v7: https://lore.kernel.org/r/20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in
> > 
> > Changes in v7:
> > - Fix NULL pointer dereference in shrink path (Sashiko)
> > - Acquire vn->busy.lock when updating vm->nr_pages to synchronize 
> >   with concurrent readers (Uladzislau Rezki)
> > - Use READ_ONCE in vmalloc_dump_obj (Sashiko)
> > - Skip shrink path on GFP_NIO or GFP_NOFS. (Sashiko)
> > - Fix Overflow issue for large allocations. (Sashiko)
> > - Use vrealloc instead of vmalloc in vrealloc test.  
> > - Link to v6: https://lore.kernel.org/r/20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in
> > 
> > Changes in v6:
> > - Fix VM_USERMAP crash by explicitly bypassing early in the shrink path if the flag is set.(Sashiko)
> > - Fix Kmemleak scanner panic by calling kmemleak_free_part() to update tracking on shrink.(Sashiko)
> > - Fix /proc/vmallocinfo race condition by protecting vm->nr_pages access with 
> >   READ_ONCE()/WRITE_ONCE() for concurrent readers.(Sashiko)
> > - Fix stale data leak on grow-after-shrink by enforcing mandatory zeroing of the newly exposed memory.(Sashiko)
> > - Fix memory leaks in vrealloc_test() by using a temporary pointer to preserve and 
> >   free the original allocation upon failure.(Sashiko)
> > - Rename vmalloc_free_pages parameters from start/end to start_idx/end_idx for better clarity.(Uladzislau Rezki)
> > - Link to v5: https://lore.kernel.org/r/20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in
> > - Link to Sashiko: https://sashiko.dev/#/patchset/20260317-vmalloc-shrink-v5-0-bbfbf54c5265%40zohomail.in
> > 
> > Changes in v5:
> > - Skip vrealloc shrink for VM_FLUSH_RESET_PERMS (Uladzislau Rezki)
> > - Link to v4: https://lore.kernel.org/r/20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in
> > 
> > Changes in v4:
> > - Rename vmalloc_free_pages() to vm_area_free_pages() to align with
> >   vm_area_alloc_pages() (Uladzislau Rezki)
> > - NULL out freed vm->pages[] entries to prevent stale pointers (Alice Ryhl)
> > - Remove redundant if (vm->nr_pages) guard in vfree() (Uladzislau Rezki)
> > - Add vrealloc test case to lib/test_vmalloc (new patch 3/3)
> > - Link to v3: https://lore.kernel.org/r/20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in
> > 
> > Changes in v3:
> > - Restore the comment.
> > - Rebase to the latest mm-new 
> > - Link to v2: https://lore.kernel.org/r/20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in
> > 
> > Changes in v2:
> > - Updated the base-commit to mm-new
> > - Fix conflicts after rebase
> > - Ran `clang-format` on the changes made
> > - Use a single `kasan_vrealloc` (Alice Ryhl)
> > - Link to v1: https://lore.kernel.org/r/20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in
> > 
> > ---
> > Shivam Kalra (4):
> >       mm/vmalloc: extract vm_area_free_pages() helper from vfree()
> >       mm/vmalloc: use physical page count for vrealloc() grow-in-place check
> >       mm/vmalloc: free unused pages on vrealloc() shrink
> >       lib/test_vmalloc: add vrealloc test case
> > 
> >  lib/test_vmalloc.c |  62 ++++++++++++++++++++++++++++++
> >  mm/vmalloc.c       | 111 ++++++++++++++++++++++++++++++++++++++++++++---------
> >  2 files changed, 154 insertions(+), 19 deletions(-)
> > ---
> > base-commit: b47b4fa4c232ee36aae58630e9d6520e35d33f3a
> > change-id: 20260302-vmalloc-shrink-04b2fa688a14
> > 
> > Best regards,
> Hey Ulad, Andrew
> A gentle thread bump. Will we include this in this merge window?
> Let me know if you have any suggestions, I will resolve them
> asap.

If you mean the merge window that opened yesterday, then it's too late
for that, and I believe we agreed to not include it there anyway in [1].

I can try to look at it again. I guess the main difficult thing is
interactions with other parts of the kernel, of which sashiko claims to
have found another one [2]. I can't help but wonder if it would be
better to reduce the vma size to avoid issues with other codepaths using
get_vm_area_size(vm) and assuming that all pages in that range are
mapped.

[1]: https://lore.kernel.org/lkml/20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org/
[2]: https://sashiko.dev/#/patchset/20260404-vmalloc-shrink-v10-0-335759165dfa%40zohomail.in

