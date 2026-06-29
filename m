Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3119AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 03:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39796B008A; Sun, 28 Jun 2026 23:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA476B0092; Sun, 28 Jun 2026 23:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00376B0093; Sun, 28 Jun 2026 23:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 862A06B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:57:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C3E71C66EC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:57:56 +0000 (UTC)
X-FDA: 84931591752.24.1E1CBE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5F87C100005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:57:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N2DYghzd;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782705474;
	b=gt/wo/IXzj06vKo3Zmjfz4+xh3R4V4pTEUJsESIyBckzMsHfKqf+K5ae+F8alOIOsnLBsW
	8bgWjSLTP6pGGXyt4lgDdrfwThAVkb+eMgEnJb61sS7tngxkB6cJfkTIX8sAfLIZx5eKYf
	N0EA6U6pWNACHMKTyH34CJ/CnBwAAQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782705474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BWTqCcdFd79kNtuHH2+5DlGXwn4xidZaCYPnEXjfjE=;
	b=xxNq+VxGK2jS7IpwizEJvVDcJbbSe6pkg/Wop5X43SD2fmrviRtr62VkRIiimkuxMwItbl
	IIHORgRNvtkfYIy6TQMBhQqP6D0rJYTn3El5fXXeYojYTXbobA8DXX0oNmxUGWnVXD9Ug3
	WsFFojob9194V9NBwtO7LnAT1dbjgjw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N2DYghzd;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A53160054;
	Mon, 29 Jun 2026 03:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC3D1F000E9;
	Mon, 29 Jun 2026 03:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782705473;
	bh=9BWTqCcdFd79kNtuHH2+5DlGXwn4xidZaCYPnEXjfjE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N2DYghzdbvdXgZTm52RVU2UGpV07+Ip2Nso6dcrYYqVrV9u+eHpXODG7N7T89K7i3
	 Szurg24QtNgh6dBwx0J2eDz5Xw3dpUDFoauW/SDL2F/NZr4o6WmC3Ofyzznk/3CuTK
	 +bQ4MLHElZHhvZ7/1IYfObLUQuY/AgtibbpcZfb3bAKFYbsBK5Ky/f7gnAD62xzfiR
	 JtCbn6rJBZKr++McrYCT8rd47qxWfw7NzElwAPYUOM1MDx+Gq4JtFs6cdhS2+SzKBN
	 6YUuwKxTTcDY7T0JFJ420aiIIH0WXpcyyckFttDVpNZutUjhCh1ywg3vycdVOD/2lq
	 RwzycfEhZII8g==
Message-ID: <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
Date: Mon, 29 Jun 2026 12:57:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
 <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kkwj78zobtmb7fk3uudy8bngdfe377an
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5F87C100005
X-HE-Tag: 1782705474-421574
X-HE-Meta: U2FsdGVkX18izWPl1MmlMAQYdty5qXkeoilDC9FFEMHh+TzEMdig2ojwCDwtk9VOkJ0b8p25IYMIIFo+BeHulTWVvItE6wPLM1QX+AZpgMgeTlXJE3uDXnYB/gOlaSKRKerLJexgIx2ZHkeFFniqmPPHAyeNuNE3wrgl7fvTtIfiKJLqlUPVzB2FcVNC4l5+C5eIIod/C1Km2NFNDBURoa+OsmKuxfLA+HCEuJ5XTtJwuShb4fm2h7XE2d5ztzI46qPnkeQ/afBDCFWgL7546n7Qm1wgkxgplbMIbF6KDmeI5o1BdL0jWHx3WFOCaa45LrVe6jVRQcGdsTNYa7+k+KZ1gHimTuxAPB8M2H/0c0Q3s7G+kdNtf3nOaF7+bhjCB9FU7DZwv/1CmX44E1HejaOFCJkoqEUOuHqdHu/Z7deiyb6WFLSZwfmznNck8XhVXkaXk4BrnVa+T5lWTnP09plvXwRLVdaKhfOG1qXxlenMSE00+BVGMlLr0V68eq0Jvrl33VJW2Cu/70kW5LwOzvegsOG5ldGtj9lqZCSHWftU7OQ5hzuW/3XoR0FoRUaeuJ7kHzL308/zRZpZCJS5wgkEc/a2SA3vw0LW0XpmfqLUMYdEbdtryIk6fqbRYIEAPjJ2i3BF1tEjpfa9WQvkTjONdP7pv1evk7EqG2CelgJ0766gqrJ0BypO7Xhnn20zE9qFIeSTKxEoYPc+sDNZfOzSgspikhd3hbmVd3Ti/bRjlGWiysp1hzVK6Qypudk3izcvLrNBHJNtvh4BXuLIN0rgL1WQSjTTQLMQuskRYJCl8ctCu9PuX5Z07DlQYnVe2GvoVUoqEZuut4R5qgi1GwisyobLwAeqleJWGlxG2Sr4xeSZoSyFgws5hFNXwmxryeISLQXoV+bh+fgOTplmgw6hhg4+E9QNEKVp4vsIHKdJ6sPtVTQR/BvqmWOCVlc/xfglCQfet0WABDwUd+3
 s7g9UAtG
 cLNviuMoP3uGZUoCRwKfD/jPOonj5npO5+bGIPSyZq0NtFTChq9AQRkq2Q8z3YDsjinrqxNiZ8eIQRLW+TAvfGk2qhII1LnZ4IcvPCiXDzRynLWuZkCytSlnvdxuzdt0fHIOelm8ZZpop+smV35PB6zaPlinL5/lAhyDnOtMy3N82cth2tuAVE45ncxMzfd3CRcn47e0xRFlAwD6ZtyKwdNBwmL/iC3B2cNcLjmdRgAv4PyoMwf1soaPACrJHohbLxp5kj3FkmxsXvt7WaAWWMww7FOfJLizlGPbJ45RuPMtpSqaq7S/C654FGKSyTOPCYmAVOS+WF/0c5I0AC6D/4LvH/M/SWQYZfsiZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


[ Adding Kees Cook for SLAB_BUCKETS conversation ]

The thread:
https://lore.kernel.org/linux-mm/20260625230029.703750-1-shakeel.butt@linux.dev/

On 6/29/26 8:37 AM, Suren Baghdasaryan wrote:
> On Sun, Jun 28, 2026 at 2:22 AM Harry Yoo <harry@kernel.org> wrote:
>> On 6/28/26 4:47 PM, Vlastimil Babka (SUSE) wrote:
>>> On 6/28/26 5:23 AM, Shakeel Butt wrote:
>>>> On Sat, Jun 27, 2026 at 07:58:12PM -0700, Shakeel Butt wrote:
>>>>> On Fri, Jun 26, 2026 at 07:11:33PM +0200, Vlastimil Babka (SUSE) wrote:
>>>>> [...]
>>>>>>>>> Fix it structurally by removing cycles of every shape: serve the array
>>>>>>>>> from a cache strictly larger than the one it describes whenever it would
>>>>>>>>> otherwise come from the same or a smaller cache.  Every reference edge
>>>>>>>>> then points from a smaller to a larger cache (here kmalloc-1k's array
>>>>>>>>> moves to kmalloc-2k), so the relation is a DAG and cannot contain a cycle.
>>>>>>>>
>>>>>>>> This will fix the problem.
>>>>>>>>
>>>>>>>> But this will waste memory as we need smaller obj_exts array
>>>>>>>> as the size gets larger.
>>>>>>>>
>>>>>>>> We should probably create a new kmalloc type to avoid cycles instead?
>>>>>>>> (needed only when memory profiling is enabled, though)
>>>>>>>>
>>>>>>>> That would also prevent recursion even further.
>>>>>>>
>>>>>>> Yes but I assume that would add kmem caches even for users not using memory
>>>>>>> profiling. Anyways, I think that is a separate discussion. Am I understanding
>>>>>>> correctly that you don't have any concerns with this approach?
>>>>>>
>>>>>> Umm, the memory waste is a concern?
>>>>>>
>>>>>> Minimally I'd now want to only do that size bumping when allocation
>>>>>> profiling is enabled. Ideally that means both configured in and not booted
>>>>>> with "never".
>>>>>>
>>>>>> We probably should have done that already in 280ea9c3154b2. Because AFAIU
>>>>>> memcg-only obj_exts array don't have this issue (or maybe they do have the
>>>>>> [1] issue? Harry?). But if memcg-only should keep avoiding the same size
>>>>>> bucket, it can keep what it was doing and only memalloc profiling would do
>>>>>> the strictly larger thing.
>>>>>
>>>>> memcg should not have this issue as normal kmalloc caches do not serve memcg
>>>>> charged objects.
>>>>
>>>> I am wrong here as I went back and see d8df600b67d7.
>>
>> I was confused too :)
>>
>>> (8dafa9f5900c upstream)
>>>
>>>>>
>>>>> So here we can do dedicated caches as Harry suggested or make this size bumping
>>>>> very specialized as Vlastimil suggested. What do we want long term? Orthogonally
>>>
>>> Maybe long term we make kmem_buckets unconditional and use that.
>>>
>>>>> we do want this fix to be backported easily to older stable kernels. I will see
>>>>> how does this narrowed down size bumping looks like.
>>>>>
>>>>
>>>> BTW I think we need something like the following, right?
>>>>
>>>>      if (mem_alloc_profiling_enabled()) {
>>>>              if (obj_exts_cache->object_size <= s->object_size)
>>>>                      return s->object_size + 1;
>>>>      } else {
>>>>              if (obj_exts_cache->object_size == s->object_size)
>>>>                      return s->object_size + 1;
>>>>      }
>>
>> We should not add mem_alloc_profiling_enabled() check because,
>> then we're not fixing this issue on SLUB_TINY, when the caller specifies
>> __GFP_RECLAIMABLE|__GFP_ACCOUNT without memory allocation profiling.
>>
>> `if (!is_kmalloc_normal(s))` check already bails out when it doesn't
>> need to bump the size.
>>
>> So Shakeel's original code will work fine.
>>
>> We're only pessimizing memory allocation profiling and
>> SLUB_TINY && MEMCG users, but (as Vlastimil suggests off-list)
>> it wouldn't make much sense to enable MEMCG on memory restricted systems
>> anyway. (IIRC even raspberry pis don't enable the memory controller by
>> default...)
>>
>> I think it's okay to fix the bug first, but we need to address
>> the memory wastage issue sooner or later if companies (Meta and
>> Google I guess?) are deploying kernels with memory allocation profiling
>> on in production systems.
> 
> Sorry for the delay folks. I just got a chance to read through this thread.

Hi Suren, no worries!

> I think adding a new KMALLOC_TYPE would be the cleanest way to fix
> this recursion problem once and for all. This size bumping and the
> special case of SLUB_TINY are quite confusing.

As mentioned by Vlsatimil, in the long term, using SLAB_BUCKETS
infrastructure would be more straightforward than new KMALLOC_TYPE
because (I think) the kmalloc type is decided purely based on GFP
flags and we need to somehow work around that. SLAB_BUCKETS provides
a nice abstraction to do this.

Luckily, SLAB_BUCKETS is introduced in v6.11.
Unfortunately, SLAB_BUCKETS is optional.

> We could define that> new KMALLOC_TYPE only if memory allocation profiling or SLUB_TINY are
> enabled to avoid new caches when not needed. Does not seem too complex
> but maybe I'm missing something? WDYT?

I think we need some enhancements to achieve that with SLAB_BUCKETS

1. Rename SLAB_BUCKETS to SLAB_BUCKETS_HARDENING
   (w/ SLAB_BUCKETS being a transitional config for _HARDENING)

2. Make the SLAB_BUCKETS infrastructure unconditional,
   but the decision is made at runtime:

   1) actually creating a kmem_buckets vs.
   2) falling back to kmalloc.

3. kmem_buckets_create() creates kmem_buckets only when
   SLAB_BUCKETS_HARDENING is enabled.

4. SLUB decides (not) to create kmem_buckets for internal use
   during the boot process. Use the kmem_buckets for obj_exts
   array allocation.

Side note: this would unconditionally add the kmem_buckets parameter to
the kmalloc slowpath. Probably it'd be worth introducing a dedicated
entrypoint for kmem_buckets instead.

> If it is more complex than I imaging then I'm fine with Shakeel's
> approach as a temporary fix.

Since above requires quite some changes, I'd say let's proeed with
the fix (since it's one line of code change that fixes a bug),
and then see how we can make SLAB_BUCKETS changes as minimal
as possible for backporting?

-- 
Cheers,
Harry / Hyeonggon

