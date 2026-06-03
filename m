Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B22FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 07:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5C06B008A; Wed,  3 Jun 2026 03:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66856B008C; Wed,  3 Jun 2026 03:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955E76B0092; Wed,  3 Jun 2026 03:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80AD86B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:54:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD560402A8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:54:26 +0000 (UTC)
X-FDA: 84837838932.21.B8807F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E4C7B180005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:54:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBQdR899;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVEWQXkYyS1Sz1wvYDfa0kDHIfb6GACqf4EYG4ej3sk=;
	b=7yE2IzhCD1qbkfvYFsFTwZJC+UqGvPnySGup+SJyH5kvC0rhiX64536SIj80i574hcbmly
	gtiL8qnX4MzpyzWNgkGL2DTcjAhTZkw4Acw0P1FafVGeWTm9NVGwPNh3INpguBNfBTi0HW
	HW8FWt6gWBCnJLyVJZfAwCcATeXMVLk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBQdR899;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473265;
	b=DJ8wDohG8HFQbb2kSODkPy13LudnyPIRWevaBy6cbuIqMIzemJ1QNahttz4Mha56rA85OQ
	/pSfwSEhpW4dgtpmFT4YeAZ/4cHaI9Rsw87RoBFjAyQLmgjSdAZChABk4zdJoNPiErLGTf
	cwumRUrPyZgc9NbP+nectr9sGTrNAlA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DAD3041824;
	Wed,  3 Jun 2026 07:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA281F00893;
	Wed,  3 Jun 2026 07:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780473263;
	bh=yVEWQXkYyS1Sz1wvYDfa0kDHIfb6GACqf4EYG4ej3sk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iBQdR899JgjQykJRr6/veC3nzp/U3AzVBUI7qT+uQIgJJd7ZBW9l9QZchBrf66Lhr
	 0qI4HFuAOQqiRm2/77apvrCvt7IRTRHEa4wt717jm2i39+vV5nmUzsM/4cKYO+k+ro
	 FlZZEF6HcMNPQ0I1XgOiejr5bUf2bL6NeY1vMs9n7UyycHig/Zpgmhzzw44UbpfZW9
	 I/bhLe6VplTnVgMlkef6VbPnUZKT9CLdrT5guTrCNlMdH0XXLD086xrwhtinZEPUJc
	 uFZuS/vxmUWw7DT/VpxH4TKVP1lgwDqEDTSFIfHhw+UeQ6vQkeZ4rDROLg0pc8VPLg
	 IW18pcyKw93lQ==
Date: Wed, 3 Jun 2026 08:54:08 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: wangtao <tao.wangtao@honor.com>
Cc: Harry Yoo <harry@kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org" <baohua@kernel.org>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com" <dvander@google.com>, 
	zhangji <zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ah_VMf0ZJTRsrArV@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <0867dac0-bc48-4aa9-891f-2066a3eff989@kernel.org>
 <7319ad82f9ee4fc4b18b50b1842c9f99@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7319ad82f9ee4fc4b18b50b1842c9f99@honor.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: thbesdxb5mt9ogdsk9jhze9djhdpirqe
X-Rspamd-Queue-Id: E4C7B180005
X-HE-Tag: 1780473264-918670
X-HE-Meta: U2FsdGVkX1++ddSm7tdcmm+wxLI/xIlqUYythlBbZAKYg0vzYAijO+UwdrrQdIG1JiUG+NHYT4gpRUQKljkpfSCqoD1EuNXj+N4B3jACn3tAD7dF0PDfE4dCjYqonEwMHDXGp6zmr0VZGPLKU3JiKeUMNjmpsxsHuB/H6vn8J8b/+cXRM7KYi9RO923nrOrEJn+RNwgEAIGvErhjYJeqsKAMEtN32WLwOwVtGjnn9mUItsiXkfO0jHUMsrGlXWi128zczgIc6LUDz9lU/GtpoxV4ZG0w5rkZ40KYuTTRsBYHEybDMXWfuGv7bkgFVvKyDRRB0j5ccB6asp7NgaWeRqDdx2iTT9L25TaE6+dqBOvk0MJhF2ENSnC2fV+J0wQprijP4pTwxO+xt/KLHWWIz2L+B92+MD/8nuIgWBJbYvyCJIiEKsPeWI/g1n9UWYHNt5hMMWldSEli5haLrQ67gtexwaVdUA/3de/cbfE6jDyWS7OSYSLCBIarf9Sy+U5EvrYJaVDELoBmAYJrug7b0ieR2ybitQLCXI2vetCto5mUBR64QIMaI9JM8An72z2A4oanveGKKiK0oKTj8XM5G6Huyss3iLxQ6lpE5T182XGaTnHFxyRlhwfsc1nTsOi9UmdkV/A0Sge2YkDcVH9P1+yyLzEaQwGoO5UvoVPPL/LFiE3FKtstMCfEjBt4bCjax3Dyr2SliKmrmP3r1tF04OrAhwun9cy85iMpVztaek6a0G6NYbZ6OdYsWsQ6jvollNZ+nXwhNtJPg1dcEndPDa8VYPYHQIcte8AUWGeFCfxd+G4mprFuSSaQ5yzGo4Jy6cGSVt/771LBPenwHrCA1rfUZrX2bITHVPcHaJukkyjpAvz49b9u9j4T2CZCSpmcBWn4FRdGoMelsK4+0vW7qK6Pe+nNHFlfS4RaiuF2RmXIVXDAUzizR4hozUI4eS3mrm2yKaTi4yHDXvO//YI
 UGh1jMSr
 EHTa1jkvpJfM3rC5CFhICycgprdkM9lBrv4fZPz/dTKCIZjfsdq9J58UqLym9VpGd8AmmzoRY+4kt+2ktbtMAPRmKFUhok620cU5KRmBIdWSDDBmZFZlYFiT4DGeYeTiY/KqYp7l8y9S1wxgL06Z2IzPmgq+P5RgmNJfS5M0S2ct6Wvz7UXY8+6BZa0yIFRgqAxfkUGe+T89ZotwJ+tYcfOBeUCPq/yS+3TS+nHAsgnIHODEr4+EoWIeO86Tq7I3ypM0BIKbxcEOIlZtoaH12mxT7g4HdpXd+NbACfwoW0zChj90ZVu7AQZqPxH1PgOu4p/voBGJhmoCyf4mIBzhSYru6H6vmBfy9H/TS9WxcXNHh0bjaniKjhjMQ4tMKTKBXZUp2boC8ps2D2re26UjwPVJvht66fWHtO/wSanpISNOo/XfPbP9H9DXNFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 02:59:04AM +0000, wangtao wrote:
> > On 5/27/26 8:01 PM, tao wrote:
> > > Design overview
> > > ---------------
> > >
> > > ANON_VMA_LAZY defers anon_vma allocation until it is actually needed
> > > (for example during fork). VMAs that never participate in sharing can
> > > avoid creating anon_vma structures entirely.
> > >
> > > Before an anon_vma exists, rmap operations rely directly on VMA
> > > information, so no anon_vma locking is required. An anon_vma is
> > > created and linked only when sharing semantics are required.
> >
> > It is unfortunate that the design overview doesn't cover correctness aspect
> > at all. VMAs are subject to change (even before being shared with other
> > processes), and rmap needs something that doesn't go away across VMA
> > merging, split, etc.
> >
> > I'm not sure how the idea is supposed work correctly.
> >
> > --
> > Cheers,
> > Harry / Hyeonggon
>

Against my better judgment I'll address the stuff here...

> VMA operations can be roughly divided into three categories. The handling
> of ANON_VMA_LAZY is briefly described below.

I don't agree, there are plenty more VMA operations. But with respect to anon
rmap there are:

- fork
- merge/split
- remap

Your approach seems to completely ignore VMA split and the need to maintain
an interval tree to _multiple_ VMAs from a single anon_vma.

You may also actually split a VMA against a single large folio (waiting on
the deferred shrinker) and have a SINGLE _leaf_ anonymous folio that is
mapped in two places.

The lazy approach doesn't seem to address this properly. And fatally it
ties an actual VMA afaict to the folio and has to implement a VMA reference
count mechanism which interferes with the ordinarily VMA lifecycle to do
it.

The fact of us taking advantage of most stuff being AnonExclusive,
i.e. 'leaves' is something that my approach is exactly taking into account.

Of course also extending anon_vma is a real non-starter.

Also the below + the series ignores MAP_PRIVATE file-backed mappings which
is a pretty fatal flaw.

It also, as Harry says, has zero description of correctness in a way we'd
want and no tests.

>
> 1. fork
>
> fork duplicates the parent's mm/mmap. (exec creates a new mm/mmap and is
> not involved here.) This can be viewed as copying the VMAs with identical
> virtual addresses into a new address space.
>
> If the parent VMA (pvma) is ANON_VMA_LAZY, it is first upgraded to a
> regular anon_vma. The corresponding folio->mapping is then fixed in
> try_dup_anon_rmap().

And so we make fork, a very sensitive path in the kernel more expensive.

I also question the locking situation with the conversion mentioned,
updating folios in this manner is extremely difficult.

>
> 2. mmap / brk / mprotect / munmap
>
> These operations create, modify, or remove VMAs in the current mm. They
> may split existing VMAs, merge adjacent VMAs, or remove a VMA from mm_mt.

mmap and brk are not at all relevant to anon_vma, as no anon_vma is
assigned upon mapping. It's on fault.

mprotect/mlock/munmap/etc. might split, but I don't see how the lazy
approach in any way addresses any of that.

>
> When a new VMA is created, vm_start, vm_end and vm_pgoff are initialized
> and the VMA is inserted into mm_mt. Although these fields may later be
> modified, the following value remains invariant:
>
> (vm_start - vm_pgoff * PAGE_SIZE)

Err no it doesn't at all?

If I fault in a VMA at vm_start, vm_pgoff = vm_start >> PAGE_SHIFT.

Then if I remap it, vm_start changes, vm_pgoff stays the same, so:

vm_start - vm_pgoff * PAGE_SIZE

Changes right? And then that becomes essentially the offset from where it
was faulted in.

>
> We refer to this value as:
>
> vma_mapping_base(vma) = vma->vm_start - vma->vm_pgoff * PAGE_SIZE

This is mysteriously close to being the offset I mention in my CoW context
work...

I'm not sure what 'mapping base' means here.

>
> This value also remains unchanged when the VMA is removed from mm_mt.

Why does it matter what this value is on unmap?

>
> If a VMA is split and produces new_vma, the following holds:
>
> vma_mapping_base(new_vma) == vma_mapping_base(vma)

This is a roundabout way of saying we offset the vma->vm_pgoff after split.

>
> If two adjacent VMAs vma_a and vma_b are merged into vma_x, then:
>
> vma_mapping_base(vma_a) == vma_mapping_base(vma_b) ==
> vma_mapping_base(vma_x)

This is just a roundabout way of saying the pgoff has to be aligned.

>
> Assume the VMA where the first page fault occurs is called root_vma, and
> ensure that any VMA produced by split or merge holds a reference to
> root_vma.

But this VMA can be unmapped later? Or remapped?

Holding on to a VMA and treating it as some kind of canonical reference
with a reference count completely changes what VMAs are, impacts the VMA
lifecycle, and produces unwanted memory overhead in itself.

It also raises concerns and issues around lock order which is very
sensitive.

>
> During rmap we can compute the folio address using root_vma:
>
> vma_address(vma, pgoff, 1) =

What's the parameters here? What's 1?

>     vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT)
>   = vma_mapping_base(vma) + pgoff * PAGE_SIZE
>   = vma_mapping_base(root_vma) + folio_pgoff * PAGE_SIZE
>
> We can then use folio_addr to locate the VMA covering this folio.

I'm really confused by this, you're kind of mixing and match parameters
here.

What I think you're saying is that, if a folio hasn't been remapped, you
can figure out its address based on page offset.

That's completely broken for MAP_PRIVATE file-backed mappings which also
use anon_vma and also have to keep on working.

It seems that for the lazy approach what you are doing is essentially
caching the 'root' VMA in the folio. But this doesn't account for large
folios and split VMAs.

Even if you disabled it for those cases (which adds a ton of complexity in
itself), you then have issues with locking - the anon_vma lock has to take
a lock (that cannot be a VMA-level lock - results in lock inversion) even
on these leaf entries, or you break locking.

And we can't reasonably start pinning VMAs and using them as a sort of
proto cached thing on top of the existing anon_vma logic.

You also then need to, on remap, undo all this, which requires updating
folio->mapping on remap, something I tried doing previously myself, but
that's fraught with issues around lock inversion itself.

>
> 3. mremap / uffd_move

userfaultfd moving is not relevant as it actually updates the folio
correctly.

>
> If only the size changes and the start address remains the same, there
> is no impact.
>
> If the start address changes, the page is moved from (vma, addr) to
> (new_vma, new_addr). In this case:
>
> vma_mapping_base(new_vma) =
>     vma_mapping_base(vma) + new_addr - old_addr

You say above that the mapping base never changes? But here it changes?

>
> We first upgrade the VMA, and then fix folio->mapping in move_ptes().

What's 'upgrading' a VMA? You mean converting the lazy anon_vma to a
'normal' one.

As above, this is fraught with lock inversion issues.

>
> If performance becomes a concern, ANON_VMA_LAZY can be enabled only for
> relatively small VMAs.

I think you've got serious correctness, lock management and complexity
issues and it's all a non-starter as the costs deeply exceed the benefits.

This is one of the fundamental, frustrating aspects of the anon rmap - you
keep thinking that 'surely' you can do sensible thing X, but it turns out
you can't for various annoying reasons.

It's one of the reasons it's really fraught for somebody coming to make
changes, and one of the reasons why I am very keen on fundamentally
changing it.

And also on a not-wasting-time basis - I was already working in parallel on
a rework here, so I think the civil thing is to at least wait for my work
before issuing alternative solutions.

Thanks, Lorenzo

>
>
> vma操作可以分为3类，下面简单说明下ANON_VMA_LAZY的处理：
>
> 1. fork 从父进程复制mm/mmap；（exev 创建一个新的mm/mmap，不涉及)。
>  这可以理解为在一个新的地址空间复制一份相同地址的VMAs.
>  如果pvma是ANON_VMA_LAZY，先升级为regular anon_vma，并在try_dup_anon_rmap中升级修正folio->mapping.
>
> 2. mmap/brk/mprotect/munmap
>  创建、修改或删除当前mm的VMA，可能合并或拆分出新的VMAs或者将VMA从mm_mt删除。
>  创建一个新的vma并设置vm_start、vm_end、vm_pgoff插入mm_mt后，虽然后续可能修改这个VMA的vm_start、vm_end、vm_pgoff，但是保持
>  (vm_start - vm_pgoff * PAGE_SIZE)不变，我们可以把这个称之为vma_mapping_base(vma) = vma->vm_start - vma->vm_pgoff * PAGE_SIZE。
>  这个vma从mm_mt删除时，vma_mapping_base(vma)也保持不变。
>  从这个vma拆分出的new_vma，有vma_mapping_base(new_vma) == vma_mapping_base(vma)
>  合并相邻vma_a、vma_b为vma_x时，也有vma_mapping_base(vma_a) == vma_mapping_base(vma_b) == vma_mapping_base(vma_x)
>  如果我们第一次发生缺页的VMA称为root_vma，并在split或merge时都确保使用的vma持有root_vma的引用。
>  在rmap时我们可以用root_vma计算folio地址：
>    vma_address(vma, pgoff, 1) = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT)
>                               = vma_mapping_base(vma) + pgoff * PAGE_SIZE
>                               = vma_mapping_base(root_vma) + folio_pgoff * PAGE_SIZE
>  然后用folio_addr查找folio所在的vma。
>
> 3. mremap/uffd_move
>   如果只是修改大小，起始地址不变，不影响。
>   如果改变起始地址，将page从vma/addr移动到new_vma/new_addr
>   这时vma_mapping_base(new_vma) = vma_mapping_base(vma) + new_addr - old_addr
>   我们先升级vma，在move_ptes中再修正folio->mapping。
>   如果担心性能影响，可以只在较小的vma上使能ANON_VMA_LAZY。
>

