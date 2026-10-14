Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D22CC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27D56B008A; Wed, 14 Oct 2026 03:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD87C6B008C; Wed, 14 Oct 2026 03:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7256B0092; Wed, 14 Oct 2026 03:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81C906B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:28:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CEC1120456
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:28:19 +0000 (UTC)
X-FDA: 85320403518.12.C9036A3
Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8D0E5100003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:28:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a75adkaw;
	spf=pass (imf14.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791962897;
	b=mr3NGDN83OzI8BumjXbVMPBDXRobkldkOgtBma0ib+OjUmWtu0IowuyrXW7bQ1XNuLl/go
	r4wpHqRZMr9Y04w9dLzqHX5+i7cWwkUwiWIvAwwyg+ddFODr+ncLw2dhG22JNhZ2mIzld5
	JYe9xVwiBeGoq1/mqX6Y7XvSY0SCEXA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a75adkaw;
	spf=pass (imf14.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791962897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKdAh4DSPDajzvJegyN5GGao4FMUHTTyQLWPRHfK9UI=;
	b=SgL2Rci0ttNtOral56gXMZaGkSC9cVGuRoHnSjKfAB0IR9kOIcsTEnzC1hg7hBcMzeUBih
	6jRo1K58QGqGb45bh8ori7Jf2AHVcDW68bleRTaD6aFkUJ/zSfcaWBpdvXfd73mmsD2Y/s
	gXXa78EM0XAZ8cjaWDQxxgYC+2UHgtg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KIpg8DK6yUzBXoPal9V2gzxOahvuwx1OXybBEt4rIgk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791962896; v=1; x=1792567696;
 b=a75adkawqXP1Wd3mjMkZBAH1Byun3Cp8eshRphipu15Nl8UMxMXZ34RhR4CYRG4vDEq2b+/p
 oT/8UEiMPr364720dPZy9Lx6ApLKI6GY2+fwxbd4SHIrDs5rGIIxoqesjZ6ITOO8mCKx8QGrK/a
 0HLHkMoAfDgEE3mddAyzlCR8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d0234dd56ab13b63;
	Wed, 14 Oct 2026 07:28:15 +0000
X-Mizu-Trace-ID: d0234dd56ab13b63
X-Migadu-Flow: FLOW_OUT
Message-ID: <bdcf2425-c0cf-48df-96a8-7ee1d23125d7@linux.dev>
Date: Wed, 14 Oct 2026 15:29:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Uladzislau Rezki <urezki@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261009063619.112313-1-hao.ge@linux.dev>
 <20261009063619.112313-3-hao.ge@linux.dev>
 <CAJuCfpE9VfgTw2ZNMJTEVh41H_R+1RY_MtzeMuZNCD3BFm-Piw@mail.gmail.com>
 <as5epHFQF4iE_VQK@pc636>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <as5epHFQF4iE_VQK@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D0E5100003
X-Stat-Signature: eoxqyjnsexussrc794tt3weye6otihwk
X-HE-Tag: 1791962897-458649
X-HE-Meta: U2FsdGVkX19VuRNEz9TassX2Yvtj5YT6XG/mSbIgCwltKoOAqKfCfP9ZeFi0pifi9o+y9M/ZDAtYRvrVmX9tinZE1WVOXndiTLvsz//4AY6X4CndZz187D/B3HKn84ko3NxXPvlZo6n4vtEBAfZIc7CpUCbqwagLKvJvUn9spE6IEBC3CLSliKCA8cKs+uWLgI9ArXJj8tmwN/mvwjIFCbk9/pBM+AJIEJTEjrFqQj0CiWtS8lV90QTJirpez68Z1MFrC5yNOIf2qkve/TRyTfqsc/TQGrIcQzXNjt54VdPwdRlpyhQn34+19++V1XNdm4NB+AGb7kHKzwedK8D2z1RJj+wWgBx+FmBESN66WALtdha+xuTadIbt4BHLOEGYEKYghP+gxJuS1jjVWe3E5UQx2tZbLYjU4ubvkKcgtZxh/ds1FVxuNJPoffy7XGuiX0LhuUvDECYa2SqfrFOGiXtm/Pp+a0xk/Nt7P61zuPbD0bamWby9CSd8PNN3iDKnke02RKQBTq8M4eb/yg3vCaim+EIAgvRcHuwCsbFx9BC+uC3hb/FEuyXSZAo3J6bwDpDUvdDu0awKc2xzorePUSHW1KQT4oaGmIYLXdXbUxjvcNUj4IfakpJ7gIRHwZdeTcDFPkquohgzPw42bX5aLnZBtxLI0upexAqzg+8j9nb/0pK28uREfnaYmerHDN4vIg5atkdv6YEZF6j73r3Mgws+J9jlhyLSAq17SRB/3/0qycoWxUcGPSuffY2FKKcuyXKdx6vpH5v+iAp/t43KAAeoEHHQI+VASMPd95XJCfXY5kIU4+uRI70GK0eckl5ZPerGOKvDOLD9I1Ij+UC9E0MA5PBogYKZiVqGVN4GeaKQ5xHWYMKU05+2UH3CLllBZPvmOLYpoiT8TiWDewzH17EfjS+FOuf2ai4pbMFnDxfDXdRMC/kecvowOX+YYU2qroT8ps+bPkXvgQPZ7pn
 HnT3RoUu
 cwddYmmQdaqw0CY63rKboBfgqaJpGQ8L4L8vslp3c8J3ZGGABxoV3+MYCxKUoevmveA0mnJOqhRpnNiZx2co3XXNJeMAP04Xkrl3XS+Y6TPvxOJs7C0WDPDUSC5IIwSJwHLE/PehNGCRBLQ3iOiF3Ay1dHL5yuZ72DuJ/u0K9f2vf6jgRSiKbuxqfZE5QZdYjTFO9a3NQbL6/jw8WgalQxq+IC46RoPXkUh66nqdVAuHAGuQyjKCYsRD4lKO0aXnzE87kXNHUz+FMVSrBypLsICYbnxr6f8x/nTZSMzWtBUUkHUfOu9yEOzt3MOz8dGOCcZPRFItZfJPPEVLtXC2w/V7Nm5LZiXmPLwVvTUOxpPXdPgSqsJDcPMDIuG4V0i13UqhPCZt1jnr2CqUqAV2rQPS2uMT6FWHOdS2RNEadAveC00c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Uladzislau and Suren

On 2026/10/14 00:39, Uladzislau Rezki wrote:
> On Tue, Oct 13, 2026 at 03:23:14PM +0400, Suren Baghdasaryan wrote:
>> On Fri, Oct 9, 2026 at 10:36 AM Hao Ge <hao.ge@linux.dev> wrote:
>>>
>>> __vmap_pages_range_noflush() and friends can install some PTEs before
>>> failing and leave them mapped, and the kernel callers do not agree on
>>> who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
>>> roll back what they mapped before the failure, while
>>> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
>>> __vmalloc_area_node() rely on the mapping functions cleaning up and
>>> do not call anything like vunmap_range() themselves. When the same
>>> range is mapped again, the attempt hits the leftovers and fails, with
>>> a BUG() in vmap_pte_range() for huge mappings and a warning on the
>>> small-page path.
>>>
>>> After discussing with Suren and Ulad, we decided to put the rollback
>>> into the entry points of the vmap API rather than into every low-level
>>> helper. __vmap_pages_range_noflush() undoes the whole range it was
>>> asked to map when it fails, and vmap_page_range() undoes its range
>>> for the ioremap-style mappings.
>>>
>>> The rollback is __vunmap_range_noflush(), it only clears the PTEs,
>>> no TLB flush, nothing has touched these mappings.
>>> vmap_pages_range_noflush() drops the KMSAN metadata when the data
>>> mapping fails, and an empty range bails out with -EINVAL now, which
>>> used to BUG_ON() on the small-page path and map nothing at all on
>>> the huge-page one.
>>>
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Suggested-by: Uladyslau Rezki <urezki@gmail.com>
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>>  mm/vmalloc.c | 44 ++++++++++++++++++++++++++++++++------------
>>>  1 file changed, 32 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index db669103dc66..e1b376f57dd2 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>>         if (!err)
>>>                 err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>>                                                ioremap_max_page_shift);
>>> +       if (err)
>>> +               __vunmap_range_noflush(addr, end);
>>> +
>>>         return err;
>>>  }
>>>
>>> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>>                 pgprot_t prot, struct page **pages, unsigned int page_shift)
>>>  {
>>>         unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>>> +       unsigned long start = addr;
>>> +       int err = 0;
>>> +
>>> +       if (WARN_ON_ONCE(addr >= end))
>>> +               return -EINVAL;
>>>
>>>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>>>                 return -EINVAL;
>>>
>>>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>>> -                       page_shift == PAGE_SHIFT)
>>> -               return vmap_small_pages_range_noflush(addr, end, prot, pages);
>>> -
>>> -       for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>>> -               int err;
>>> -
>>> -               err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>> +                       page_shift == PAGE_SHIFT) {
>>> +               err = vmap_small_pages_range_noflush(addr, end, prot, pages);
>>> +       } else {
>>> +               for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>>> +                       err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>>                                         page_to_phys(pages[i]), prot,
>>>                                         page_shift);
>>> -               if (err)
>>> -                       return err;
>>> +                       if (err)
>>> +                               break;
>>>
>>> -               addr += 1UL << page_shift;
>>> +                       addr += 1UL << page_shift;
>>> +               }
>>>         }
>>>
>>> -       return 0;
>>> +       /* Undo the PTEs installed before the failure. */
>>> +       if (err)
>>> +               __vunmap_range_noflush(start, end);
>>
>> Would it be too complicated to track how much was actually mapped and
>> unmap only that portion?
>>
> I think it is possible to vunmap the range which is already unmapped.
> i.e. in this case it is better to no to track anything as soon as a
> mapping failure is a corner case. Also it is more reliable without
> extra track logic.

Thank you both.
I take note of Suren's concerns. The worst case is a single PMD where only
the first page was installed, __vunmap_range_noflush() then loops 512 times
to undo one PTE, plus 511 empty ones.

And tracking the exact progress would require vmap_pages_p4d/pud/pmd_range()
to report how far they got. That also puts counting instructions on the successful
mapping path, while the saving only pays off on the failure one.

So I agree with Ulad.

Thanks
Best Regards
Hao

> 
> --
> Uladzislau Rezki

