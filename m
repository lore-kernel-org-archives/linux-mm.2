Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA05BF428C2
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4879B6B0088; Wed, 15 Apr 2026 14:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438816B0089; Wed, 15 Apr 2026 14:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326DA6B008C; Wed, 15 Apr 2026 14:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5A06B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:45:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A42A4140563
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:45:00 +0000 (UTC)
X-FDA: 84661667160.06.30913BB
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id A6CA840016
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:44:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="W/HUxjsN";
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776278698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BI+4MMhKwlqJVBTeBPlTkRj9rTN/wEgXw0QahwfBzo4=;
	b=TzldWjOdQpgmrq23WHUrfhMe2unXLtJjr+3pcDIObOe17VziAdb+XXl3E2gkyYc6LKI2eR
	jtNa8o+8VtJ8DH1CldRPW604pun5M9M1YBGZOvjopjYSkl0n3yQq1cQE8x3jQp66uAjp79
	1O5G6aHYG8BK5kZHXCbKGHFNxB6H8uY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="W/HUxjsN";
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776278698; a=rsa-sha256;
	cv=none;
	b=SJbXrNS+F5qlfBduU0nE+UpbX46JTkRdpvcnKtscgK9lPUltCe/lJj/s3RQ38e2OdxuYaa
	0xVBDgGz0P+OZAWfrgAkFZPy0G7jPWj6o2PS2gFIzVlgY1lUdk/MheP7Ge95hdsdVGGHMA
	t0TkTecuGod3avjrzjOSOFzY1PrsWD8=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-38dd575bca3so68327821fa.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776278697; x=1776883497; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BI+4MMhKwlqJVBTeBPlTkRj9rTN/wEgXw0QahwfBzo4=;
        b=W/HUxjsNUpdsyA4ALb4oalQqSmDqbCJXOU/hOMhS14wUW18Buu2BBz4Aouhji3jaN2
         Z6SDp3xhslnMKX+3Cnaq3BdP0B8WjlQeKg29d/qmwdkdpGGrozNYA6+7kMMPVf07Edwh
         Y9ExfQyMgs9WK1TRr/2LH6y0x4GbS0HqIb0/gP6qNszJlCe12F2wXfYqZ5xZANeeX+X3
         TC+iAg8kUxYD5qsrUxmwp2Wn+Bq+dDxEsBAyMhTEKmm2y+ndoajlTc27IHtWtXFM9iII
         57Pept2wUpB8AQx0PZNdRatd2pepwIEJJbnNMzY5PDL+Ucs+FR5Ke2XNa4ShLc0KMjcp
         WGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776278697; x=1776883497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BI+4MMhKwlqJVBTeBPlTkRj9rTN/wEgXw0QahwfBzo4=;
        b=HjHWeFmQM1DB4nxTK0mNHkFngPDFEhGfZ7mDFXN2VWH07to28CNG7pEMp7JjPQ3Beq
         H/oflKjujLjgs21RRtbCQ4wycoRONnRHNZeJ2EcCc0Q+VjNSWXopYcC+sZHaVpVaD7B7
         ZXIKH6FlaSiWjfBYONtUWz1MvCQeAkXRGDvtiQq3R/JmfVEvbVrRe0osIBEnBH1TU040
         Efgu9pcb3/czUss8g+n3JfAGb+Pr8D2a2PSgRVDyRbsSf+tV8Kkhn2j+Za8uTmiajCbE
         XNgiwtUsfhxKK0lSmM21FUyDQHCz51/oe11e2JjJneAEwLFe/yWVHzegyk5ybY56mJti
         n+zQ==
X-Forwarded-Encrypted: i=1; AFNElJ/vP9tWwf1ZaqEGN7OugLhB4p3WUnB6gwjk4kDxEFqlqDqtK1pkJBPih8r4/yHZRYvPBaV7x/2Sig==@kvack.org
X-Gm-Message-State: AOJu0Yz08Zkjku7v3dIVjiFLakKEv3RJ245U8/pzrYd/mqC+uk2f/5Z+
	9jhhDTDpE9WF2Kuls2L49xAHfiwM2iFb3qVIMbttp22MqkMGBNDDkPMS
X-Gm-Gg: AeBDieuNouP4Oak3dQexAELhTKgo7hSWSJV+thv5qbcLciGkttYvXcjVf8KKRmuO6+P
	oEgL3xVCEH0xEBckDkYyAh7qaW+NnxlLKQS1db+EPqJmOnsZHKDFuYopTivRM/qQaMPGuidwzG3
	ruoiMrwvA8rNLlu+hr+iH7ldIt7gtxp6TCg9HFu+0WGSIRXuvEtk60rwH5u6BirCM1ErmqKq+z7
	WtrIpxcms/uqDnx4txgHN2xJAyJDnZI+Q502IwSNmy43/SOln/IJTP0LO1F2Ogf+NsNEkxUoc3Q
	84rNLr2GSrjN0Saf9MiTV7IdSjP5gjLNd2TbJjORzuAKKxU4PWwGFqam0OkQb4q5cnV2i0Hk2fp
	UiKvgXipgaKv0skXCOVvNZ9JcG2qoTfph8krvZu3U4k1UmndUJzVxKefZdNKKmLyH
X-Received: by 2002:a05:6512:1151:b0:5a1:1de6:bc66 with SMTP id 2adb3069b0e04-5a40df9652bmr187844e87.18.1776278696262;
        Wed, 15 Apr 2026 11:44:56 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a40a2fbae2sm652303e87.63.2026.04.15.11.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 11:44:55 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 15 Apr 2026 20:44:54 +0200
To: Alice Ryhl <aliceryhl@google.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-ID: <ad_cpqx38LtQPlX8@milan>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
 <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
 <ad5yE0sgV1HJsyaC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad5yE0sgV1HJsyaC@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6CA840016
X-Stat-Signature: stjd7hxaojcpgayrttqx61s4takrh9ag
X-Rspam-User: 
X-HE-Tag: 1776278698-430625
X-HE-Meta: U2FsdGVkX19xOm9JMDO2V1VbwNiUiSVhedZ45a9sd3uVpZNL3H3JycuSiisrHulxtgbQVf0Iu9IqZoiQgejqiSOEaNx89Scn3La33arwSX5znr6V0fN6UrVnxVsQv0pHRnKYz9fPnL5MH2xNMUHyJEEeWlbyKGE9S/jd30nnIDZbBk5HNYJSNbK2xGeY8lD+dL9Xlvwp9rKgBhzC4JtSgzU/1BncsI9Gl4/7nnFmZOqIyVGOc/YK/CNvh6tTgJ67uX67lJOcdjwB0b5N4g+xi8Lc4lj7j2L73hcfPRxek55SGks6uvcU20CHn166Qi+Wpu3ZszfHt/e/m01fnli+SU80D01W4e0w8F6N9fv+aeXTxcPtRh/knipPFvFinz3xZvs1zdI6MoPQ5c3WhHvYvTPtL3qQDw6UtCTKioVHVGwRLlYdQfxqJykyzOQMOryfi6+wEu4F6rBKQZUxmY0o/L4CyxY0PsKLNnnaWEufqnHzZtPlbAOCnrUdY5lVV3w06mn8YPLNZl4vmjgJtwD/3rACnql2xEBUOI9n2i9bVdphej9Z6Y2j9yNLX5tuyLerR+qqqG7kwk7wJ+MwGLWTsKqm3bprKt+jvc86dAMEyjGvQ0d04/O4AckK8KUdUtd54deywdwt77Upt7CggFRqiraWkeuKz2xdv3GYg6xoM5qwA4K9N/bjdDAeP0YNV/pDtkr4GasBfyQ7Z8MrI67Uvk9PsqqQuNtsEBmhi67gWwbvkhxsocldghpfQm/d7Oe8N+pXqZ+cd5s2nAacA+9p4Jv1/McuNkzV7N8ZUHk9AHr7jWU3twayB5MFqp0KlrXs1fKiyJvkrS+bLaIPpC/A+52RzJypMW37YuSk0ZTC1+sYiK/bjr33K2zPO2C6akI26jVSdasuXj+kUpPALmTQW/LNR/NKjHYhGTB+LxAV7IfgzKwz/xIkZICic/80bnxSpNseqXDWBlmZfEJk4/f
 yCd0t7zW
 Cs7El3qv85/oj1MqRFhbXwwv+qCzpAML/1mxnyPoAl1iJ0B1FeYCGHOmDh1k0QCfkD6vCaF6vrXcrBy7fBxf6t1IQwWs1nvUSIjB/tlJTeKhgViVYssura1zkaVp4ggaMAbTTwzI6VO8uBJEPBz1L/WuRkp87/NBX8H41UG3SDl65zipeMJyKKKutW/ZhvXIXZ2LzsK3h5EDJHdhZ7V+IDJ75pB0YSjh9XPHm7xgSQgINDjCj389kXfcCpxDqS5rSKFbNAtq1kUNhHeaY040igUgbn07sgqg7inX/hdRpJJ0cArGfmq9EvbWUg1SXZbDIYjXNvwCLSsAbl9SoWUZvWj9fWSi5TJw0Owrdrfpbu/6hVBQcse9F/gXF4Ple5QfIg9kdXvBZRn1vGkEtuuHkj+V/dLYKnYnriP1HkvzbuUNdTROh7xKEnp0bx6UgqCwCaNcGDNn47GJLLl1BSqnLvvJsPIuGipteC9leZgwWunGH930GUvmJo+l/Nz3Fjh0amQJPPfGIQq9nEPT1JpayaClYdvKdiLPhIPUUCy1XHquzqP4UfQS57nvs8M3f+3qRLSwZGOjj5rf9XDBTohDk9u1EJGaK8QCo4svDHpIXAG0Z7pU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 04:57:55PM +0000, Alice Ryhl wrote:
> On Tue, Apr 14, 2026 at 02:09:09PM +0530, Shivam Kalra wrote:
> > On 04/04/26 14:06, Shivam Kalra via B4 Relay wrote:
> > > This series implements the TODO in vrealloc() to unmap and free unused
> > > pages when shrinking across a page boundary.
> > > 
> > > Problem:
> > > When vrealloc() shrinks an allocation, it updates bookkeeping
> > > (requested_size, KASAN shadow) but does not free the underlying physical
> > > pages. This wastes memory for the lifetime of the allocation.
> > > 
> > > Solution:
> > > - Patch 1: Extracts a vm_area_free_pages(vm, start_idx, end_idx) helper
> > >   from vfree() that frees a range of pages with memcg and nr_vmalloc_pages
> > >   accounting. Freed page pointers are set to NULL to prevent stale
> > >   references.
> > > - Patch 2: Update the grow-in-place check in vrealloc() to compare the
> > >   requested size against the actual physical page count (vm->nr_pages) 
> > >   rather than the virtual area sizes. This is a prerequisite for shrinking.
> > > - Patch 3: Uses the helper to free tail pages when vrealloc() shrinks
> > >   across a page boundary. 
> > > - Patch 4: Adds a vrealloc test case to lib/test_vmalloc that exercises
> > >   grow-realloc, shrink-across-boundary, shrink-within-page, and
> > >   grow-in-place paths.
> > > 
> > > The virtual address reservation is kept intact to preserve the range
> > > for potential future grow-in-place support.
> > > A concrete user is the Rust binder driver's KVVec::shrink_to [1], which
> > > performs explicit vrealloc() shrinks for memory reclamation.
> > > 
> > > Tested:
> > > - KASAN KUnit (vmalloc_oob passes)
> > > - lib/test_vmalloc stress tests (3/3, 1M iterations each)
> > > - checkpatch, sparse, W=1, allmodconfig, coccicheck clean
> > > 
> > > [1] https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/
> > > 
> > > Suggested-by: Danilo Krummrich <dakr@kernel.org>
> > > Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> > > ---
> > > Changes in v10:
> > > - Reorder vm->nr_pages to the beginning (Alice Ryhl)
> > > - Link to v9: https://lore.kernel.org/r/20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in
> > > 
> > > Changes in v9:
> > > - Remove READ_ONCE, WRITE_ONCE and drop commit
> > >   about show_numa_info. (Uladzislau Rezki)
> > > - Update the commit message in Patch 2. (Alice Ryhl)
> > > - Remove zero newly exposed memory commit.
> > > - Link to v8: https://lore.kernel.org/r/20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in
> > > 
> > > Changes in v8:
> > > - Strip the KASAN tag from the pointer before addr_to_node()
> > >   to avoid acquiring the wrong node lock (Sashiko).
> > > - Rebase to latest mm-new.
> > > - Link to v7: https://lore.kernel.org/r/20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in
> > > 
> > > Changes in v7:
> > > - Fix NULL pointer dereference in shrink path (Sashiko)
> > > - Acquire vn->busy.lock when updating vm->nr_pages to synchronize 
> > >   with concurrent readers (Uladzislau Rezki)
> > > - Use READ_ONCE in vmalloc_dump_obj (Sashiko)
> > > - Skip shrink path on GFP_NIO or GFP_NOFS. (Sashiko)
> > > - Fix Overflow issue for large allocations. (Sashiko)
> > > - Use vrealloc instead of vmalloc in vrealloc test.  
> > > - Link to v6: https://lore.kernel.org/r/20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in
> > > 
> > > Changes in v6:
> > > - Fix VM_USERMAP crash by explicitly bypassing early in the shrink path if the flag is set.(Sashiko)
> > > - Fix Kmemleak scanner panic by calling kmemleak_free_part() to update tracking on shrink.(Sashiko)
> > > - Fix /proc/vmallocinfo race condition by protecting vm->nr_pages access with 
> > >   READ_ONCE()/WRITE_ONCE() for concurrent readers.(Sashiko)
> > > - Fix stale data leak on grow-after-shrink by enforcing mandatory zeroing of the newly exposed memory.(Sashiko)
> > > - Fix memory leaks in vrealloc_test() by using a temporary pointer to preserve and 
> > >   free the original allocation upon failure.(Sashiko)
> > > - Rename vmalloc_free_pages parameters from start/end to start_idx/end_idx for better clarity.(Uladzislau Rezki)
> > > - Link to v5: https://lore.kernel.org/r/20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in
> > > - Link to Sashiko: https://sashiko.dev/#/patchset/20260317-vmalloc-shrink-v5-0-bbfbf54c5265%40zohomail.in
> > > 
> > > Changes in v5:
> > > - Skip vrealloc shrink for VM_FLUSH_RESET_PERMS (Uladzislau Rezki)
> > > - Link to v4: https://lore.kernel.org/r/20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in
> > > 
> > > Changes in v4:
> > > - Rename vmalloc_free_pages() to vm_area_free_pages() to align with
> > >   vm_area_alloc_pages() (Uladzislau Rezki)
> > > - NULL out freed vm->pages[] entries to prevent stale pointers (Alice Ryhl)
> > > - Remove redundant if (vm->nr_pages) guard in vfree() (Uladzislau Rezki)
> > > - Add vrealloc test case to lib/test_vmalloc (new patch 3/3)
> > > - Link to v3: https://lore.kernel.org/r/20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in
> > > 
> > > Changes in v3:
> > > - Restore the comment.
> > > - Rebase to the latest mm-new 
> > > - Link to v2: https://lore.kernel.org/r/20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in
> > > 
> > > Changes in v2:
> > > - Updated the base-commit to mm-new
> > > - Fix conflicts after rebase
> > > - Ran `clang-format` on the changes made
> > > - Use a single `kasan_vrealloc` (Alice Ryhl)
> > > - Link to v1: https://lore.kernel.org/r/20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in
> > > 
> > > ---
> > > Shivam Kalra (4):
> > >       mm/vmalloc: extract vm_area_free_pages() helper from vfree()
> > >       mm/vmalloc: use physical page count for vrealloc() grow-in-place check
> > >       mm/vmalloc: free unused pages on vrealloc() shrink
> > >       lib/test_vmalloc: add vrealloc test case
> > > 
> > >  lib/test_vmalloc.c |  62 ++++++++++++++++++++++++++++++
> > >  mm/vmalloc.c       | 111 ++++++++++++++++++++++++++++++++++++++++++++---------
> > >  2 files changed, 154 insertions(+), 19 deletions(-)
> > > ---
> > > base-commit: b47b4fa4c232ee36aae58630e9d6520e35d33f3a
> > > change-id: 20260302-vmalloc-shrink-04b2fa688a14
> > > 
> > > Best regards,
> > Hey Ulad, Andrew
> > A gentle thread bump. Will we include this in this merge window?
> > Let me know if you have any suggestions, I will resolve them
> > asap.
> 
> If you mean the merge window that opened yesterday, then it's too late
> for that, and I believe we agreed to not include it there anyway in [1].
> 
> I can try to look at it again. I guess the main difficult thing is
> interactions with other parts of the kernel, of which sashiko claims to
> have found another one [2]. I can't help but wonder if it would be
> better to reduce the vma size to avoid issues with other codepaths using
> get_vm_area_size(vm) and assuming that all pages in that range are
> mapped.
> 
> [1]: https://lore.kernel.org/lkml/20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org/
> [2]: https://sashiko.dev/#/patchset/20260404-vmalloc-shrink-v10-0-335759165dfa%40zohomail.in
>
Yep, the problem reported by Sashiko regarding area->size and vread_iter()
is correct. V10 does not address this. 

I am not sure that reducing vma size is a good approach here. It is
widely used and we might end up with fixing even more corner cases.

vread_iter() and vm-size calculation there should be fixed.

--
Uladzislau Rezki

