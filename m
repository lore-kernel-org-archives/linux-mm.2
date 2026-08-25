Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2FEC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 20:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D756B0088; Tue, 25 Aug 2026 16:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED996B0092; Tue, 25 Aug 2026 16:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC316B0095; Tue, 25 Aug 2026 16:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 046556B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:02:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72B4C1201DF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:02:06 +0000 (UTC)
X-FDA: 85140863052.09.2574878
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 791ACA000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:02:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O11Qfo6z;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787688124;
	b=H1Bs+Xq8fbV/hSzNkDLhzDiScDpmw4nVOL/IjD56lPAH0PT5FajjjnX/Wukv6lexlB7L5V
	G6cU4GVCmLv6zNvpQgZRPzGAfW9qxJXUuHWEq9jW2InqImaz0Tkjttn9E92ffX9BiCCRIA
	SLGiMznd0lk30bFybCm13n+/snpfb0E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787688124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgC6RaE9rPNtCOZeViA7+F7B8N1oxPij4qtWttjALzU=;
	b=HHBPP9iGSOat8zQDBw2aLKU96SM2oJH5N0+xCia1t899aSdgT2WWCeze9RonsHEecS6PIH
	b1W1E95eVRiajnOnCDqqmzjthx+6xTkzHPUyo7u4FPjgZ6BIgy6a1fsV2+iIEHA8Swghbx
	SSeWP+ypjLyDLzdEtZwHq7aWhisOuN0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O11Qfo6z;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C3FD41763
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A7B1F01566
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787688123;
	bh=AgC6RaE9rPNtCOZeViA7+F7B8N1oxPij4qtWttjALzU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O11Qfo6zKiAZw13/rC76tYwhlKDJ2SBviFLXUlWLO2Bh03ylDfdEBoRmkNHrbGswJ
	 xQWqVn5erSych8fHTQnRE1+Lx9tRhc2Auy+q9RlRyNHwQ3fwVxH4JNu7nwX+6BFOuy
	 Xu9v27yfU5L/mTRZo7/LHaZnwx/uySGhDUHx9X6gLLuKugCLuw/cIoP+sVd09KA2fB
	 Tq0dtRlB5v2Pzov+ZsnedA2eYbDjnVfhM7bBVhvzozwSmuCgjE0wuqsUe3YkmIWCC1
	 LQQOziv24e7iep1ULk/PGNoXYBRyPtXjR4v9xEgLkBYFsJaPwJ9PkvomIoJcgWpqcD
	 7Vxd3oJo6F7Pg==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a156627e22so2472901a12.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:02:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoHBpqLFfogJBw8UI9/AgR6IQEf83rRYXLWg6sfyEJWA5SaTfshbrU2T5ZT2WKNlQ9OozZ1IprC0w==@kvack.org
X-Gm-Message-State: AFuF++lGwBvuhl8azzX1jSiMlBU4gh4aHybZT39oXCkCcTouI5PT6lfZ
	jsAs3CDyv3+J0Df7YG0IH/2rGNcJYDiFEXYyiOurVbBPIQF0HpVC4sBBgERsH4ETtIoNZOe4Ir9
	/900yWa3MQ+5f4vrVurN84/OAgnv3zoo=
X-Received: by 2002:a17:906:fe48:b0:c15:a7b9:2ae1 with SMTP id
 a640c23a62f3a-c250acaa25amr202049066b.6.1787688121767; Tue, 25 Aug 2026
 13:02:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anJ45UK0MWvskzlK@google.com> <DKPL6YQLP6NT.1747A5QR1D8VH@linux.dev>
 <aoOsiMyfWbkCbV8F@google.com> <DKS0Q1CR4APM.3JMJWR7UGI30U@linux.dev> <CAO9r8zN7w9RaaiV7dmv+E5EVJnYs7b=iRbv1F_oQsOTJVva_yg@mail.gmail.com>
In-Reply-To: <CAO9r8zN7w9RaaiV7dmv+E5EVJnYs7b=iRbv1F_oQsOTJVva_yg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 25 Aug 2026 13:01:49 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO0BK_huGHosBC-62aSyZSBOwTs67_6fekjj9Y+akegHQ@mail.gmail.com>
X-Gm-Features: AcwNN1VdrPyy5L4xdXteW-P0GgMtEB8GoSa9rD7I0tJjBuZQBxKhs3VUPV9lpWo
Message-ID: <CAO9r8zO0BK_huGHosBC-62aSyZSBOwTs67_6fekjj9Y+akegHQ@mail.gmail.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED allocations
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 791ACA000C
X-Stat-Signature: iyhhdqhucyntn45ugti1ju57ywxyxyfp
X-HE-Tag: 1787688124-328123
X-HE-Meta: U2FsdGVkX1/mnJ27Xxg6yTmIyUmLvmBc1YXsCMspbiCaH/YiNV7xhu5KdYNwR6rBkFPbU1CB5LJd7yDLsR/2s/SVG/0I26gOrQm5mASL76C9onuUK02PV687Hi4fgopBwc6dX6nLCbxzgE4va3rTKz0ICKNGe5ETJ0KXy0+KUT07mYkmsKQjBPFk+gq7thMqd4idAwrgFSy0wFzUtymTyEhpXI5VyOyD4ZsQ+fy2Tt5Ju07APeduvuj5kLkfCNIkgZXo/FQPR5H3vmE2i/oxpevQfI5hHYFZ9lrfPGgxgNIeFlaOI+kTkfLQ9B2bvtu1kXxqEAupowzwbeED1JfgS+vU5JkyFqySAuyzPEN+EDmPtEPKAe0gW5roCF4wAcnzBp60eZYAommgIVHxUFAwDoJkVY8Tmz3L9wfYjY3Pe6MCHBjXAsupywskSbGi4qPBDL18kU100T/+g762njO3T3EKOiJ9Ru/3jjs11a2Mr7PP5qZT/EQA91gCuz1uJnx7wv2NEMjuJ/RJNlzCGNuibxx1BOCbB6Ln1DM/3ygvnSxkugcf+u1QCOYj4CG6773K6t34NCTcE85DUZRb7NEQCAgkKPeF0MTW6JuC/pwO7lgeFgn4kO4055StFpUkVTWaHZmCFj1iE4SRTpUP9D3reCHp0eky+fzojgCRcLdESHo4ELUNpXPmB9QNETQhc//LP+rW4v1sJJFaTjSbMkG1nn9EEBVYOR/xIco+edTwFUkpktktkh3biPvXKYdCEvKS0u4wq7LE0MzEVB9mNv8yqjYsazCP0Lht5/J73ob2DojCWsPvAgk+/pPMavga8zQSvn6c0DGtSp4sxm1a58FUFu57IxEzXgZwloF6fySk53U1e6/zliA7YVMBIVT3Z4Qyfco6Wy4djprvLtf9Oj1mkMWxFntc4XsjAKtBLuovEEHFYt65hdaAycNdsid8aBAHp/n7PTLtoPzCUsmHHyr
 KaZm+00R
 FHLABw6f+otq81x1sMY/pvaOf1NfHmsPDAgja/M4dpzfbkRtpE/ca+8OAgeSWdT6hZcaWbraIeaGWr0NFuqSggbTomEwkZeY4GOpR8OqAkDvPy2fZsZpnj6dSJzD036cr8xlfHGvfBpV+hesNMLLu4gMO2o7hRiTkrlavcshI9/61HekjV+cou28shOtOxMRZc2rv2LMjsfYGmd9W8Oqg+ZG4gbcSp9K+oLqmSeFV0/xTqjPyY3L5o59Gbo4r6z8SwmEaHGZBOkxFQBH0NndU/TLSKNykUoHuxqTCnEGBGbcL4vpsKRo2vEHbx5XN2WLTfviT1/pS1U6QZBZxZ8saQbKpQkIKtpPL6cTHMii1XEpx3hwUg2z5PplD0BLk9zimy7nN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 10:51=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Tue, Aug 18, 2026 at 4:04=E2=80=AFAM Brendan Jackman
> <brendan.jackman@linux.dev> wrote:
> >
> > On Tue Aug 18, 2026 at 2:55 AM CEST, Yosry Ahmed wrote:
> > ...
> > >> [0]: https://lore.kernel.org/all/20260805-shivank-gmem-migrate-v3-9-=
00d8bdec4e1d@amd.com/
> > >>
> > >> > I wonder if we still need a fallback case where a pageblock contai=
ns a
> > >> > mix of mapped and unmapped pages. We need to carefully handle such
> > >> > pageblocks:
> > >> > - For unmapped allocations, we need to unmap the relevant PTEs and
> > >> >   potentially do a TLB shootdown (if they were previously mapped).=
 Maybe
> > >> >   we should always flush the TLB for simplicity for now.
> > >> > - For mapped allocations, we need to map the relevant PTEs. No TLB
> > >> >   shootdown should be needed.
> > >> >
> > >> > Assuming unmapped allocations are always zeroed by the users on al=
loc
> > >> > and free, we don't need to worry about zeroing pages either way.
> > >> >
> > >> > We may want to track the number of unmapped pages in such page blo=
cks to
> > >> > now when it's fully mapped or fully unmapped and change its type, =
but
> > >> > maybe this can be a followup if needed.
> > >>
> > >> ... However, yes this might be unavoidable despite what I said above=
.
> > >> This was also DavidH's feeling when I chatted to him a few months ba=
ck.
> > >> The hard parts of it are a) the tracking as you hinted at and b) in =
the
> > >> general case that means allocating pagetables.
> > >
> > > I am considering a simple-ish scheme to avoid per-page tracking and
> > > potential TLB shootdowns in the freeing path (which prompted async
> > > freeing internally).
> > >
> > > What if we just always map pages in such tainted/mixed pageblocks whe=
n
> > > they are freed? If they are already mapped, nothing to do. If unmappe=
d,
> > > we map them and zero them. No TLB shootdown required.
> > >
> > > We also shouldn't ever need to allocate. If the pages were previously
> > > unmapped, we should have already allocated any necessary page tables.
> > > Right?
> >
> > Why would we already have allocated them?  In case it wasn't clear, I'm
> > talking about breaking down huge mappings here.
>
> If the pageblock is mixed, then the allocation path must have already
> split huge mappings and allocated page tables as needed (or the
> allocation would have failed). So the freeing path should be
> guaranteed to not need to allocate.
>
> Basically what I have in mind is, if you need to make an allocation
> and you have to fallback to sharing a pageblock, you split the mapping
> (if needed) and map/unmap memory. Now that might fail if you can't
> allocate pages tables, or recurse into the allocator trying to share
> another pageblock, etc. This can especially happen if you cannot find
> a mapped pageblock to begin with.
>
> So it's not very easy/straightforward. But at least all the complexity
> should be in the allocation path where failures are tolerable to an
> extent and the context is more-or-less known. The freeing path should
> be straightforward-ish.
>
> Technically you can still hit the same recursion case today if the
> direct map was PUD-mapped, you will need to split the PUD to convert a
> pageblock. But it's less likely to be a problem as the page table
> allocation is mapped and if you have an intact PUD you probably have
> tons of 4K mapped pages.

I think there's another lurking issue here. If we split a PUD mapping
to convert a pageblock, split_large_page() (on x86) will always use
GFP_KERNEL for the page table allocation. This is probably unsafe
(e.g. if the original allocation had GFP_NOIO or GFP_NOFS). We
probably want to use something like memalloc_apply_gfp_scope() here
anyway.

