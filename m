Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67DA5D3B98C
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 18:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE306B0006; Tue,  9 Dec 2025 13:20:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FAF6B0007; Tue,  9 Dec 2025 13:20:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4F66B0008; Tue,  9 Dec 2025 13:20:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59C696B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 13:20:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0783C0290
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 18:20:31 +0000 (UTC)
X-FDA: 84200747862.13.2C61E20
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1EF0C0003
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 18:20:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JJGh0Eon;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of fvdl@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765304430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evmg9WyrD2HkygF7wnhCaOCmIVrkIj1I8JvCf7Jiv9o=;
	b=t7yjQ0iTfzJeF1/RYqQ0FKiBVqs3jaG+sgKQDazN0nm/mW9KvAXxO1mjOTGPrOgQ648yFY
	3uUnUuPBCI+I4hc/ubA1RkhqgqdW0czK0s33ZIWmcZ3shReuxyg8jJM9R6fbuDwUtG3/aP
	iIDC/zs+jt11/38MNbzjopfJyEEY0k0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JJGh0Eon;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of fvdl@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765304430; a=rsa-sha256;
	cv=none;
	b=PPqSDWHadMReInptHB8N0lC4gFkW7ACCxzOlWvelk1a1PeO4D+i17H2PPWzZYPJEO4dHMj
	F+9WqQfu4n5LjJ1c1qynfgIga5uYrNeI9pS9NVe5OQ4baTil0iFdTrFlNlTyREPB67KqX2
	OzmYtxmdKjSom9yxdPxuhSpuERl/DLs=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64969e4c588so708a12.1
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 10:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765304428; x=1765909228; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evmg9WyrD2HkygF7wnhCaOCmIVrkIj1I8JvCf7Jiv9o=;
        b=JJGh0EonpeJuKNdv/NSuo0V46m6PiphlDulAnQmxoeuZHiFzmu2ljz/7oQnXCfxjgq
         nG0st5QDyInyLeWykUnDyQOC5Ckg5LwJyaco+boTJJtMy+F9SkUkxjCa13TfAh8oHN+h
         roQnqccMvIFASNlofh1ViOrINJHOzNB5RJEwlOpn8WG31DAGI1P5WIFLA7qv+8hKmlgc
         hVg6vAY0hO6dbOmwg2OOzu0yOgE2G/KY6XY0uvDP/3t1lJLWWt/y0pzipLyDDh39/JyR
         HVhuJPwzRj8hr0eYMMlaU/l0CwqLlDY6xO1EtZrJdQK+yf9l4BGwiz+bf+MzxzcMPUxx
         XJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765304428; x=1765909228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=evmg9WyrD2HkygF7wnhCaOCmIVrkIj1I8JvCf7Jiv9o=;
        b=THgQN7y9t+iNxgTwMz794KUss69y3fUj0zJ9a6S8oHY7+BORpXDS0dX+UXD4LigLZJ
         jIdwLn8DO5VybvDPua0Wa7EIioL2mCo3gP8oLzrd6DhC0opDG6QCr9VtvOa95mDoxgEa
         yRn0jNb4VOL9+v6cwmAfFILpA3NVqXlcWfFnEoG7Ih1jYwa+T5beqcZq4Hub8wv5ObOf
         yanz6d12cstxqY7GjvglS/EAxcSDXy6O/jSQgQmNIjGijiPyVlCpnQRJ+rSC/HHvRQcy
         kSNTBgPNHaRPmY0KsZOvMk6PhzCyunQtmgYmIX6ZNPLsxnwDp56aXcaNbrv3Y8RwnQAN
         +n2A==
X-Forwarded-Encrypted: i=1; AJvYcCUgWzvmxlNmi9GmCRl+gQp6C5qGC7Er02fb0eiNdZM4lZJUW/8sRm20Sh+cfJl9SlFzjojvHLhekA==@kvack.org
X-Gm-Message-State: AOJu0YyrjytFUKGaXT0+i9Xp4LkSBu/2y/VbJvOOyMF7Wq2vBNF53wjb
	ZeoBk99VJgu/pKliO1Ved3Hrvv8cdjT/SbsztWeg2+AADqFopGHB71I2IZFZ5FE1PnBab5tEug9
	LThLQLvdfjwoEr3AjGipzczYvVusIyQWBQuRr3Xvk
X-Gm-Gg: AY/fxX6EW/XU0YwSKPwvDvHJhV/EXZiwqLI97m5rXbJIKkMseIQbn4ohu+Yty+LkY3H
	deZ8igGv8ybdVezGx+9tqPjI9glFZXwA0EGOOpvLiJAXgRjosc2gtdEXHLAwZDnc6bg5Wv8ZY9D
	V5aqIu/FhgLa/dvfXROOKxt+jbxgYwCq+f5zsCX2MBQDfZRCnnSi9OI7u7J4/mTV3+Hp6N357wL
	jLTdGl9Pp2/jSC4DGAfhKI9psoGUhOpvTMWBZPeWIJMcKu39fL9N+iW4OZ7Y6Hd2feEcxse
X-Google-Smtp-Source: AGHT+IGua9KoMluY3zejeC3C4N+kgaL8dARViDU9ow5MyTiyFYNRtdVfy/9pEYEg+/C25U3TBmJkhcigAjHtb0SZb7k=
X-Received: by 2002:a05:6402:1602:b0:643:6984:ceea with SMTP id
 4fb4d7f45d1cf-6496c45ea0cmr74a12.13.1765304428077; Tue, 09 Dec 2025 10:20:28
 -0800 (PST)
MIME-Version: 1.0
References: <20251205194351.1646318-1-kas@kernel.org>
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
From: Frank van der Linden <fvdl@google.com>
Date: Tue, 9 Dec 2025 10:20:14 -0800
X-Gm-Features: AQt7F2r1NndvV55ZUE81wu9xsLiEjLpVzmQRQozJzmow2POGkCNA76ncwaR0Tis
Message-ID: <CAPTztWaWnurc=9fOBpPO25JoZu6PHU6c7AYNJbE+xdWV4gwskA@mail.gmail.com>
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap optimization
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: hwcbhho48no78em441zigq4h69u6waqi
X-Rspamd-Queue-Id: F1EF0C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1765304429-512187
X-HE-Meta: U2FsdGVkX19lYNGIZtNaequvUMwYGljDgSRPCzu6XZf4OLLWM3KEmO2E74dgWdmBEboB/g0oSFKJQJpi4uk5cnt5X8WbR0mFJStyI+FcFhjVeRQ2GS8UcuAy7jGGoBN7n92Oc+03Zg5B3v6XZmcmNa38U/E8T2Nw2LJ2/r5FKLxqIDzNdB3/2CJxztVoiWIi4XEUrhugC9k+GHT1ki4MIg9sQDtTybLzmrYmcuYkX+l1zra/vTACGHM9fKfm3NvGTkQ3q5DOiyoP0k6CcOzauVq8ejKevr64k06aNtFcvbGaBYqE7wmP/fD1N0a71f9nqcQyxwBzGf/732+a/OP243LkwbeEIi16eJIUIC1sKtF/zoizEH7MX6dzNKxfKbHcRPpOEbzyjqtHgeyfgy7Ig7HpRPB8JuT1d40dXvqzR3RfoA1knOVOO+0JCb5EAtoWvpG8cAiYW1BCy5dUnhYiRdXQ86DUobQ1+nwAHmvr6Kk0K93Ap9iE3VlzguX7Gxs60EnMIX7fBrQbTMmL8qkAcmp6zQwPs1v5u2kfysSIoN5HftDrtwoEa3kEuM9e8IcQRPYdLZmPokhbywVWrNB4lZ9+jDnxTUgq3x2JzlVvNEWH0A8oYLLNxhFuBpa4XGdxKB4n6K8yjWN9zIjjTPQh3WK9A2cV0Rx2SaztRrGGsDYvmnSc8YW5SfCsNVcabkLWv8EXO9aIYFKdT3xlCr8FoU8Q2xubPtiRy1isnYIV0oCA5kB7qdC0j72ZDRzTWkOC/n/OIvnOb4vA4dGRMtEk1C2WPCQqtXmHoSB3QqdPpBDg4HqUNKEorQNFpBCahPzrfs2jEba4yy96K9o6vaHc9Em6jScNiWaFn5gDuWznxr1KKXODua9o8UGuTTjuBws+a83r6XIV7x7auoIBqmHKAHaapKZD1U9G5jXdeZknmmz/kPJtOC3dvqMmkYM6B5fwCXGorskTxr3acMvxsqb
 qNpJvTC6
 9XMc0uvKAD2XEBy2m8I3GIEttXGHEvSKM0OXBGtA1x/6wNMPtAl8idBE66zOZoO/UKMVJh20Xj6l6bZwm2ysNGsoTTi1/z3dJ4+Vu9Ki6JRzkB1NqZlqZIN6Vbyg1HGg9TOw3TLuaBun7ECdDQc5dfFFroUqeRwWtEXFn8F9JvYiFwFR4AxlH1VxuGnpegVz/tToivMuNti/N0wd2NWPr+SJcY/+ZiAKEX4ZQz9HdURJ31NuNmjPu832XiyjBQsg+n1P3VD4pfL30qmuc/EZJxKUcN8UmveXcSvsGIaAxK2p15Y8Abdjx+UlJgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 5, 2025 at 11:44=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> wr=
ote:
>
> This series removes "fake head pages" from the HugeTLB vmemmap
> optimization (HVO) by changing how tail pages encode their relationship
> to the head page.
>
> It simplifies compound_head() and page_ref_add_unless(). Both are in the
> hot path.
>
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> and remapping the freed virtual addresses to a single physical page.
> Previously, all tail page vmemmap entries were remapped to the first
> vmemmap page (containing the head struct page), creating "fake heads" -
> tail pages that appear to have PG_head set when accessed through the
> deduplicated vmemmap.
>
> This required special handling in compound_head() to detect and work
> around fake heads, adding complexity and overhead to a very hot path.
>
> New Approach
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> For architectures/configs where sizeof(struct page) is a power of 2 (the
> common case), this series changes how position of the head page is encode=
d
> in the tail pages.
>
> Instead of storing a pointer to the head page, the ->compound_info
> (renamed from ->compound_head) now stores a mask.
>
> The mask can be applied to any tail page's virtual address to compute
> the head page address. Critically, all tail pages of the same order now
> have identical compound_info values, regardless of which compound page
> they belong to.
>
> This enables a key optimization: instead of remapping tail vmemmap
> entries to the head page (creating fake heads), we remap them to a
> shared, pre-initialized vmemmap_tail page per hstate. The head page
> gets its own dedicated vmemmap page, eliminating fake heads entirely.
>
> Benefits
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> 1. Smaller generated code. On defconfig, I see ~15K reduction of text
>    in vmlinux:
>
>    add/remove: 6/33 grow/shrink: 54/262 up/down: 6130/-21922 (-15792)
>
> 2. Simplified compound_head(): No fake head detection needed. The
>    function is now branchless for power-of-2 struct page sizes.
>
> 3. Eliminated race condition: The old scheme required synchronize_rcu()
>    to coordinate between HVO remapping and speculative PFN walkers that
>    might write to fake heads. With the head page always in writable
>    memory, this synchronization is unnecessary.
>
> 4. Removed static key: hugetlb_optimize_vmemmap_key is no longer needed
>    since compound_head() no longer has HVO-specific branches.
>
> 5. Cleaner architecture: The vmemmap layout is now straightforward -
>    head page has its own vmemmap, tails share a read-only template.
>
> I had hoped to see performance improvement, but my testing thus far has
> shown either no change or only a slight improvement within the noise.
>
> Series Organization
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Patches 1-3: Preparatory refactoring
>   - Change prep_compound_tail() interface to take order
>   - Rename compound_head field to compound_info
>   - Move set/clear_compound_head() near compound_head()
>
> Patch 4: Core encoding change
>   - Implement mask-based encoding for power-of-2 struct page
>
> Patches 5-6: HVO restructuring
>   - Refactor vmemmap_walk to support separate head/tail pages
>   - Introduce per-hstate vmemmap_tail, eliminate fake heads
>
> Patches 7-9: Cleanup
>   - Remove fake head checks from compound_head(), PageTail(), etc.
>   - Remove VMEMMAP_SYNCHRONIZE_RCU and synchronize_rcu() calls
>   - Remove hugetlb_optimize_vmemmap_key static key
>
> Patch 10: Optimization
>   - Implement branchless compound_head() for power-of-2 case
>
> Patch 11: Documentation
>   - Update vmemmap_dedup.rst to reflect new architecture
>
> Kiryl Shutsemau (11):
>   mm: Change the interface of prep_compound_tail()
>   mm: Rename the 'compound_head' field in the 'struct page' to
>     'compound_info'
>   mm: Move set/clear_compound_head() to compound_head()
>   mm: Rework compound_head() for power-of-2 sizeof(struct page)
>   mm/hugetlb: Refactor code around vmemmap_walk
>   mm/hugetlb: Remove fake head pages
>   mm: Drop fake head checks and fix a race condition
>   hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
>   mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
>   mm: Remove the branch from compound_head()
>   hugetlb: Update vmemmap_dedup.rst
>
>  .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
>  Documentation/mm/vmemmap_dedup.rst            |  62 ++---
>  include/linux/hugetlb.h                       |   3 +
>  include/linux/mm_types.h                      |  20 +-
>  include/linux/page-flags.h                    | 163 +++++-------
>  include/linux/page_ref.h                      |   8 +-
>  include/linux/types.h                         |   2 +-
>  kernel/vmcore_info.c                          |   2 +-
>  mm/hugetlb.c                                  |   8 +-
>  mm/hugetlb_vmemmap.c                          | 245 ++++++++----------
>  mm/hugetlb_vmemmap.h                          |   4 +-
>  mm/internal.h                                 |  11 +-
>  mm/mm_init.c                                  |   2 +-
>  mm/page_alloc.c                               |   4 +-
>  mm/slab.h                                     |   2 +-
>  mm/util.c                                     |  15 +-
>  16 files changed, 242 insertions(+), 311 deletions(-)
>
> --
> 2.51.2
>
>

I love this in general - I've always disliked the fake head
construction (though I understand the reason behind it).

However, it seems like you didn't add support to vmemmap_populate_hvo,
as far as I can tell. That's the function that is used to do HVO early
on bootmem (memblock) allocated 'gigantic' pages. So I think that
would break with this patch.

Could you add support there too? I don't think it would be hard to.
While at it, you could also do it for vmemmap_populate_hugepages to
support devdax :-)

- Frank

