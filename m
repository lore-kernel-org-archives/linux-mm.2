Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 699FCC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701B26B009B; Wed,  5 Aug 2026 03:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9FC6B009E; Wed,  5 Aug 2026 03:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C85A6B009F; Wed,  5 Aug 2026 03:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22A4F6B009B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:52:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8A4E1203D9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:52:34 +0000 (UTC)
X-FDA: 85066448628.15.D11FA5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 24B0440009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:52:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dj4to2eP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNcg4yLRrAMqVvjh7xGpP76Z6KvGkJyHkRJKm8OCgRY=;
	b=baiTo1sO6bLMOIQ5yOhFEGULqIBUkq9elt1+Elzyw9EFQFr63tAlj+OAxpxbq/kIOV+2UQ
	u5Wrbr0hbbo7XJAnmWNwbb0Y4/47jhPInV8TFzkYynFg2Cq8c6ZDz0yAJkP27S/XqIO+CW
	cBTNOCYmL1Z+qvJy3k7eZxoUSb57Da0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dj4to2eP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916353;
	b=44KBlj7i7JfKZ1H6cfLdrgHeAnNGsifKLCqIOYCfQb59rpXWPxWo6EQD2ssxra8yKvVed/
	WLaj6eRf35zWRftNkvWo1/EVZUFl3KpkRiRD/GSoebsRoJfl1uszbJkCgy/Ryqobb82+/F
	zGihcpsx0sy4FY6asY8ga04+g3eL3rs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B454660A6A;
	Wed,  5 Aug 2026 07:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A271F000E9;
	Wed,  5 Aug 2026 07:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785916352;
	bh=SNcg4yLRrAMqVvjh7xGpP76Z6KvGkJyHkRJKm8OCgRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dj4to2ePMBKxrHS21YueJj81YBvWMmm/zU4B6OTvdGDkTfFp1jwM0gD6RdcKfxGtc
	 PhQq2bw4OGCZxVghhLaRsKjkiPE0ihI0JyxRB4Sc97q31ueKUeQWhvJwJcmVEfL1lM
	 Ynbxbw+z/um1SJYU9jOV32JojP1BxGUIJ3O9qTyFH3RtyZ0VSYHOnIZGHHltBR95c+
	 QYuKxnvSdNIV+hx8vNDOH3xMxpSpfI+09zXkMl7ANBx1/aVeTB22kL9ucuT4Z1wcB4
	 ldYvkVT9eyqfzL3+L8FPelecfDynCcvGFfeM1cWDuUbupTItSpAFtozClYiQ+3W3Jm
	 dF80eOm2m1jpA==
Date: Wed, 5 Aug 2026 08:52:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, 
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anLmaVE5PSh6qmNz@lucifer>
References: <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <anIXr4Kbn59Ac31Y@lucifer>
 <69f4cd9c-bd6c-4e5d-b8d1-a7be8408a57a@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f4cd9c-bd6c-4e5d-b8d1-a7be8408a57a@os.amperecomputing.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 24B0440009
X-Stat-Signature: hd98xtajjez4x64ktq91asn3hry7p3or
X-Rspam-User: 
X-HE-Tag: 1785916353-141981
X-HE-Meta: U2FsdGVkX1+/46/DWXWcoorxAwoiavcHwSzclWNVJXAS4fBIyGmN7aqpBMDlSbGuU5c5SpAvWxN56tVHO3asN+zhT1SeBlQEW80EdYZTiscZmh3rHLJ0SiDx18OsnmqG4cNGVPXL+EnZZ8zMAp7bzLjEnAxJtfZ+MNaR1aZfouW7HCj87E6gvG/u+UXvSCqsdJZm6vLYTNcgzjGMy8VcC2SUiBxHR2uStkoHkZySBtgXjdyOWrCTvlqzWbK1DgidKIuyBc1fJ91yOydAnCVh/578a3YlcJ02d/tpS5NMgTWVBIz+/z5iNUMsJr2LI3sPCcXKWZBgsRfg/tI0lBrRU0lgtEXI6QVDsMw9c6Bv/G3xP8C4tzAmOLX3F3rfgs8tuuBRXUFSryAXYfB1HrX/gB+Fid3jJVJKGtT/HbUK63C/OmJvF1e4yxnRepL6A0PB0EWEEKavMhfee5pS3QOT6x1ncF/UfKEIICGxjV3Zfwlo9joviYCWsiRzgkwRGgLj2iEfst5zlXwUOIFiBjqEDUxvNmSxiMolIMXiOgvPhZXko1zlYDiI8qrpGsTEKbcc3umyzPKHnbLcTfuahUtobKPmxWUs1uCuAuhVJI1OBwT/UZ7ZXULI4WlUEjSvOYhqLbC3olrs7YmZMGNPidxNrf9M7i1wC8WC8GuhLBaZhGW8Qf/g3Q/w4uDb+KqBhrU6TXSEQSFm03GJKZKKg9/xnoeTQSdClXbwMF4KAxH0Oo+k8op8W6vLGciWuk558gSPOY3JD/PSN0JFPrfffhSYjg1Z0o+NvPAxyj1VQVCTUkm27lYDoEw8dxoUcfQ6TAYffGcguTacSyQK9Ca6cW0zA7RFOGpmQp1Se9uxXnp5TZbfC7v3sXrAGDtOP+gJ8I1BJoq6hPAlhJ3Qgy3PGd20MBROdsxeYrWjyDwjRd7a6SJiQw7/0GsuQmhGqjkAS+d8Xbh3uTo9yxQM5aiYDMe
 z3gcBkh3
 33JTWow8vqgvcGxG8BHCZksTmGsl3pvDQ3vEi/qFY0EMWOxifeOohz0cL1NxbxwNB5PAFd0LgAmaJODFseC/UmUJWN2r7PVdLZzLXx0uTWzX7PisS3RNLMlNjSHGQYB4hkDPr7FkpekV36HJ+SILNFbUP5xT7ICtqfr2iXtyrpcqqxhzg+AIIWOCzQMWWyIu1Gj13cCOqUjyyP/H0OuCfIufHcWknrw1FRbyzChlQP6VOkTHkBwgRWsh2g3orOd4daTp8s4Moc7tUDpbKkzOJ/MKiBiUKSXwRP+s/h7FNqsWiRWsE7EhsbMRcYNpR+u+Jxbfd/qAm/98ZBe6iip5L0LfUgDUSXbfCY3J47YKr76ylW9YPpUaKD6pc15p/uMRIKguXCtR7dC3ZhY7XYledOL39Wbut8oJMUPoaP6Fzcx42DcbcMBQbRE1sYAihmtp/Wp5CJk0UJV4yLJ370IQKXviGyNS+hpfq23P6mSi2emV0+YLljgMKqtYfeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 02:51:54PM -0700, Yang Shi wrote:
>
>
> On 8/4/26 10:23 AM, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Aug 04, 2026 at 09:30:08AM -0700, Linus Torvalds wrote:
> > > On Tue, 4 Aug 2026 at 09:27, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
> > > > We certainly do not want to replicate that approach. We are using the per
> > > > cpu page tables to avoid address calculations in the VM that other
> > > > platforms can do with a segment override.
> > > Right, and I said that that's ok as long as it's a internal
> > > architecture thing. Not a "this is how the VM works".
> > >
> > > Because people really have wanted to make it a "this is how the VM
> > > works" thing. And that is very much what I object to.
> > Well :) it fundamentally changes how mm works - now we have a whole new set of
> > kernel page tables and PGD's that we have to think about.
> >
> > And the series either tries to hack changes that fundamentally alter how
> > vmalloc works or will add its own duplicative kernel page table code to do the
> > same kind of thing.
>
> I don't think this series fundamentally alter how vmalloc works IMHO.
> vmalloc still works in the same way and the page tables share the same
> contents (except local percpu area), it just needs to sync up kernel page
> tables when the top level is changed. This is not new, x86 has been doing so
> for years, see arch_sync_kernel_mappings(). The patch just added the
> implementation for arm64.

Your patch fundamentally changes how vmalloc works (!init_mm) as I pointed out
in the patch.

Your response was essentially 'OK I'll duplicate the code' which was not really
encouraging.

So either you have a variant of vmalloc that works on a brand new type of kernel
page table mapping, or you have _yet more_ duplicative kernel page table code,
explicitly the kind of code that has caused latent races and issues that I've
very recently had to address.

People have repeatedly treated the ordinary or garden variety kernel page tables
as 'never go away, nobody else touches' and rolled their own
walking/manipulation code which I'm now having to fix up, so I'm really not in
favour of going down that road again.

For instance, there's a contract that kernel mapping manipulation and race
resolution _has_ to happen on init_mm.mmap_lock. I'm not sure exactly how that
will interact with the per CPU page table concept.

arch_sync_kernel_mappings() and friends are different - that's about
synchronising kernel mappings across process PGDs, you're proposing an _entirely
distinct_ set of kernel page tables.

Core mm really does have to worry about this stuff even if only one arch
implements them.

>
> >
> > So now core mm has to worry about TLB coherency and synchronisation, how this
> > might interact with things like page table isolation, and a lot of other
> > headaches (and I'm not really convinced they've been thought through here).
>
> I don't think this series changed how TLB is sync'ed either. When we
> invalidate TLB entries for kernel (i.e. vmalloc area), the TLBI is sent to
> all CPUs, it is unchanged.

The v2 change log which was a laundry list of 'I didn't think about X' (which is
understandable - this stuff is hard) really doesn't fill me with confidence that
you've thought everything through.

And inevitably you have to worry about TLB synchronisation of these page tables,
as you're essentially inventing a new class of page tables that have different
semantics from everything else.

>
> The series does change how percpu area is setup for ARM64, but this is
> already sort of architecture dependent.

The diffstat disagrees with you :) you are changing core percpu and mm for this.

>
> >
> > IOW - breaking fundamental assumptions about kernel page tables is inherently a
> > whole-VM change (See [0] for instance for an example of what can go wrong).
> >
> > If Christoph + Yang can provide compelling data that advocates for this change
> > AND the core mm and arm64 communities agree to move forward with this, then
> > things are different.
>
> We shared some benchmark data in the cover letter. Kernel build is a quite
> common benchmark used by kernel developers. Specjbb and MySQL benchmark
> results are considered important benchmarks as well. I wish I could run
> benchmark on more ARM64 cpus from other vendors, but I do have limited
> access to other hardware.

I understand that and saw them (thanks for that). But can you also run them
against Mark's series?

>
> >
> > However, I think the best approach here is to find the least invasive way of
> > limiting the change to the architecture itself.
> >
> > Mark has put forward an approach that eliminates the exact overhead that this
> > series aims to address but does so without having to fundamentally alter core
> > mm assumptions (v2 posted at [1]).
> >
> > So that seems very clearly to be a better alternative to me.
> >
> > Ultimately we need mm and arm64 maintainer agreement on the way forwards (or in
> > the case of a truly isolated arm64 solution, arm64 maintainer agreement).
> >
> > The LSF session was not encouraging ([2]) and as an mm maintainer I'm not at all
> > happy with this myself, nor does the arm64 community seem all that enthused so I
> > would against gently suggest to Christoph to be a little more open-minded about
> > the the proposed alternative which he seems to have dismissed out of hand.
>
> Nobody disagreed Mark's approach also achieved good result, we just thought
> the series can do better. I agree there is always trade off between gain and
> cost, this is why we are seeking more usecases although there are different
> opinions.

I'm glad you raised tradeoffs, absolutely agree :)

Your proposal incurs high costs in terms of maintenance headaches, so it's not
'which is theoretically quicker based on instruction count' (a poor metric
anyway), but rather an assessment of overall RoI.

And every series must be considered on its own merits, nothing is guaranteed to
be taken.

Let's see how the alternative stacks up based on data please.

>
> Thanks,
> Yang
>
> >
> > >                Linus
> > --
> > Cheers, Lorenzo
> >
> > [0]:https://lore.kernel.org/linux-mm/20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org/
> > [1]:https://lore.kernel.org/linux-arm-kernel/20260804170503.3513916-1-mark.rutland@arm.com/
> > [2]:https://lwn.net/Articles/1073395/
>

--
Cheers, Lorenzo

