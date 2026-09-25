Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52A4C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 21:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B685B6B0093; Fri, 25 Sep 2026 17:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CF76B0095; Fri, 25 Sep 2026 17:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B9B6B0096; Fri, 25 Sep 2026 17:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4BA6B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 17:30:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0036AA6CB6
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:30:08 +0000 (UTC)
X-FDA: 85253577738.14.6C8A508
Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	by imf09.hostedemail.com (Postfix) with ESMTP id 082DE140003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:30:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bme0JwRW;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.233 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790371807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fKh18UTHHYV9BhDkG+zBfHvGvhTQUS2inp00ECGTG0=;
	b=v8bnJE01VqyRjEsnUD3oLASTX0Z1ZIJXKz9Kyybj1SJ7diRGp3DgVe/cxcB64UHfQmnS4E
	GNnM98HXNo9SMMjve0tQe5dSL+LkB26kdUfoySR/sXaePJ/YzriNgfOh1LPzfIU807hyO6
	YGW50Z6FmOKP58FjjT46brMTfz/NT6g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bme0JwRW;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.233 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790371807;
	b=sVB1NYs9nAu5AlZ6WzSvOD4sdNINNvLxvh1j9Tn49xmuCsUtDRYt2Dcd11SXK642+ALwBn
	bjG6J54Q2MYq1eAl9A34QAB1DE5l6MGvh978J24p36Rgf9RV9WuFL5CSOp46WmhqLc7Jh3
	w1uF0x+WzAqWhkL/JDq5dlZ/rPzHqGk=
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93bfd70b08cso158576385a.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790371806; x=1790976606; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+fKh18UTHHYV9BhDkG+zBfHvGvhTQUS2inp00ECGTG0=;
        b=Bme0JwRWx5zRsDW7vdPx8rpd05xQ37aI0TtzB3MHsc6Eei8sR2bVGV0vXDZvMfBvB+
         iupZUJOd+lNkrhtNDa4MW1O0EOrmmKtpntniOEip7566AMb/1GDSsq1cm2xytfg0kSLW
         9CSyc/R0nCvhZNR9uq6wQjHp9pT9OVHyNLqvIHj6XP25TPdhASm8CrJgLLgul8KJBHyL
         2vR9/fb9ZaOJB+a4w7/ad6CcOg+ysS2HQ3dH0XH9v73YmMuICGQLTpE4LEE3ydQ77/Gt
         AC8ObVJuoD8jRGV/aF/V0lUbu8QFrPQFO8OgyaZ6cHhfE5jASbHIkI6b3P5jjWs9S36m
         P4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790371806; x=1790976606;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+fKh18UTHHYV9BhDkG+zBfHvGvhTQUS2inp00ECGTG0=;
        b=deBLmXn3d/G/k+jZhnP6qtf1TzKOf0DkHzHmDjge+/A083fDw0KM2MdWCc8/zbWhpB
         0esvJF6jek6YWDrr4FgsaGtuJFyRbvT0c4JA/SPy9j7PJR+nmAUbnCLT499p2RpBdlZO
         xq1vP9onjzB02pqj6M4qj3bz4aUcBU5b/em9BpPUYVFS8oq1UWNvteFPhXWYuo2FpzRB
         c4NpVgcwMhbTayq4qQpSQiC+AR8aY6c4DaBDTLY2yzRFYqM15k6VVFdFPnCojGC+LL8O
         lptA9oFCaUr7VugHhQQwTaBnm7E4FJ5FcS38Pe/nj3raMZgAbz2EzRFG1VWlTgEf2EeM
         +FFg==
X-Forwarded-Encrypted: i=1; AKwUvByF9kyD31h5sDYBcU9t+RWLMBMPn9RkKBE5QSIANyA2U01qQ8E0qhtLjFBbb93x/tyBJtDJjB2OmQ==@kvack.org
X-Gm-Message-State: AFuF++leRJH1gUTELoyCiVeDuElF5mymf8GkQiOaibITQwh99m1dGSy0
	7IFwyU5TbmTZ/7nU2kVD1eWpsm6LnCIy4nCFjPoOHur7omEuJqkyVNqfbOwxQJvzuQY=
X-Gm-Gg: AYBFou1C3lVetVXi5ZEq5Wu3MTP3lPk6iO64NSNXsMSt53PBaCTnGMTSWdOJZlKGKP1
	q3MxSV27gMrYYlNuElLOKRYWj0i5HtrFGha0OnkYPUkByZdHYIqLErYz8APPzBeem/tCoEAs855
	BC1kTrZuL0Ua4YJOx2yTH6n0j/L9u8SpWdzuvYddYcOSHeYb2w/hYWl4r28F5E+vM3KwyuJMnM6
	yKvmclj8Ztkylouj7CeVNDkhOPbCcGmKLHBnTn62JHfgC0R+jLvPJEvJ3o+Omq3M0TcUqC/PiPF
	4dm8pFqO9aG3+9v3sxxhp8Io/gD9LCSsNdQ4qT5zqKL/JWdMIzM/R6V0XQasBwaOaJyrCQODGZM
	mfBUCYEtyecV6pHFDSF6MJrZ/SRfe+KSWHsh8fVnwNQfXlZUMF5YTQU81YdOMgjtcUnrVL535Zs
	Dm8OFLi9e65kZd7MzKq6SxGUYDVnocRFj8ZwSHijavNYrknEbOBCbjSZa4mXPxt18tSpKDclHMU
	W6HKuxOjfN3Kddgc4rFOu0cM8VpppN8/ti4pMiSMPPsL42JSKPY/JmRi6rJcvL3Sg==
X-Received: by 2002:a05:620a:4109:b0:93b:f083:b269 with SMTP id af79cd13be357-93c4757fbe9mr592227985a.64.1790371805867;
        Fri, 25 Sep 2026 14:30:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c448f544asm272458885a.18.2026.09.25.14.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 14:30:05 -0700 (PDT)
Date: Fri, 25 Sep 2026 17:30:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbgZ1OGndQAsXJc@gourry-fedora-PF4VCD3F>
References: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araKDOz5bce52oyg@gourry-fedora-PF4VCD3F>
 <arbJ1LTzc7H4GL27@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arbJ1LTzc7H4GL27@KASONG-MC4>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 082DE140003
X-Stat-Signature: uah4nuxnqb4z4n44ruocwhqeeggwca9q
X-HE-Tag: 1790371806-604577
X-HE-Meta: U2FsdGVkX18aRnpSwT4pNZaWQjGCrD1h1ng3eGnEOHlYphtlCBUvf7xbaaQQhgYb8aW9AgOvv8P2xm88K7Mv4YBO7t2wvoh1iUmVw2AgX0xQc44mDOeV6sizyXafSKA+lhMeHcZLFVno3XIE7eMkogw+VAqGUjY9NpIN2q+Bt+OvtyZv4UapMNKs6UJn3nbn8PfvkJ8tv8IKMnEFBzd6ZZ12VRBbdD0GiYKOaNEQoQztZxhxGadWRncCZTNLbshCFbjUna2gFyIbRZdgDSNyI307wePf6/9jpch89taxOxRPPVaLA5+rosstlwoidIxz2PEwg+/7WQhYxTzPjKfVLQ3mCc9wIGvjRA933N7doDOS2OY20VpUVMAUN3WHd65AiH0e/IrjTSLIQnLDGm8QtcYgGui8aY1EeekwB0TZEBw9aFYkfv+iV+ATkJO5zmljzPToP6H0DuI681/gd1MR8cmJ2d3lR1hJt6bbW4uNM3PFT+2sYg1nwrbRd0sz7nXZhxgKrWQezJB7CkSdjmlbSZxey8FuX7wyIv9qyJL17GF2nMQU7Dh/Bqt5wMVarTIQlrYs3GHmft1dXlI9qRBrqeDb3Mwd7KnkjXo0zkczoUTYLj2BlUo0Jytel3WI2YeHxM0rMLzMyayydWkoOCmcQFpm+Dw5w4UJQ4CINVa+jXfZ08frR25zp2hSl8phGJrMddvM5kUjPt+2g/vWcAVGk9qu9HA+LMEKhPd67Xynp9Bgnw6OyiSVj07zocyNA4qqGIYVyyVt8KDa0tYmZcx+02IPf0C88c9Jkij0jYDVjNmFlqGmiWsYtCxmBfDVUC2qoofZC3WbIo6Qx9vkmWXNjdlZyvNPAlOd+uQ5M7NopU3ehhq2uOy3H4A6Mayx9D5mEH/OhSZbLcYwQN6j13IvPA9VdNzs6wbrXXIRc5UXiAnRM4qxPyNPBihZ2PiyK6Dz+qmRwXKAG3WDhjC+vMQ
 A2yqihoG
 Ab0QSO3tLciqYfRULOXG/A9bVGo1XW/+oTbDRaJoBb1chXEYXhlNO2w9pRMyYjNQOlX2Z7aWVgDrX3Mk7Igem4yLDvtal/eSsbz5Ax/qi2qH0XTzsvltEMK7P7i3yWHdX2Mp/AJKhfjcgBJ9nxlkGy5RxDk6aTivDhc5HFX05ABZC+0NYojQFv9qs72azWjuexWkkw+MIlnafZ6vp31rMO65WkP198UAEAnNNC/KLuq7nHF8FRu1VcdC7wPkSrSQim0dfLYI1YkmAeLmNLGTv+WE8MxcctOQWtdzw7MZ1MUix2iwXql4ZZZGckR1f5NpKD7ufoN3VXeI4jGKFosRuvkzWH8EogL0mt0q20wZ0qtSchP8u/6MakLJUzh3LYmPCdCC2zuEI3rmNYsc1Vazva5YrxDcEu2tBODyNoZDoBucSDP5HyxWdi+G40RO9LvC1hbr8Sdlepatsgy/eOrTLS8oLcF51i57WFXggE6eV5X2dQjp5oGiRU8X5FIZptp44Kcvirqommhc2tLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 04:44:07AM +0800, Kairui Song wrote:
> On Fri, Sep 25, 2026 at 12:11:55PM +0800, Gregory Price wrote:
> > 2) something has to pay the price of virtualization - period.
> > 
> >    No matter how we cut this issue, something in the stack is going
> >    to implement a method of virtualizing a swap entry.  Whether that's
> >    a virtualization layer that virtualizes every backend, or some kind
> >    of franken-swap device that lets a non-physical swap backend look
> >    like a physical swap back end without charging physical swap.
> > 
> >    If the history of virtualization has taught us anything it's that
> >    the overhead of a virtualization layer is *almost* never so extreme
> >    that it isn't worth the utility of the layer
> >    ( unless you virtualize the wrong things :] )
> 
> Hmmm... I mean there are tons and tons of projects trying to get
> rid of the overhead of virtualization, if you are referring to
> virtialization as a broad topic..
> 
> With careful design we can miminize the overhead for sure, and
> that's exactly why we need to do the design carefully :D
>

Oh absolutely, overhead is enemy number #1 - but we still deploy page
tables and virtual machines because the utility is just that high.

I suspect the level of virtualization we're talking about here, which
amounts to a single token representing many possible backends, is an
incredibly small overhead if designed correctly.

> > 
> > I struggle to think of a scenario that cannot be described
> > compositionally this way - and that is without adding any kind of
> > "tier" logic.
> 
> That sounds interesting, but I think this is already a mini
> version of swap tiering :D
>

Sort of.  The key difference is that the actual resource being consumed
has vastly differently levels of availability and at least an order of
magnitude (if not 2-3) difference in latency.  So while the tails can be
very bad, the P50s are generally not that severe.

We do this same thing in memory tiering - we treat socket-hosted memory
as the same tier, simply because it's not worth differentiating.

But we still prefer locality within that tier.  So i could imagine
memory-backed swap tiers having locality that is separately grouped
from storage-backed swap tiers.

zsmalloc actually encodes a mild version of this - preferring to
compress onto the node the folio is being swapped out from 

https://lore.kernel.org/linux-mm/20250402204416.3435994-1-nphamcs@gmail.com/

So in fact zsmalloc already has a tiering concept built-in.

> And not sure if the implementation will looks odd, e.g. like if you
> adjust that midway, you get different slot of different compression
> rates.?
> 

It is not an intuitive set of knobs, but then i also don't think it's
particularly complicated math.  But yes, there are some odd looking
configs.

> That data is very helpful info! But it could be very hardware dependent,
> especially with certain mitigations and hardwares, the faulting
> process may slowdown by a lot. This is the right picture for most
> cases, and for another example on one of our certain instance of VM, I
> observed this (high pressure, batch fault):
> 
>                     component                      µs/page
> page fault handling (directly calibrated)          ~1.92
> swap machinery (slot, swap cache, rmap, zram, etc) ~1.04
> lzo decompression                                  ~0.32
> 
> Kind of crazy that decompression only take a very minor part
> of it.  While storage based SWAP goes through SPDK so it changes
> dramatically according to the host, setup or spec.
>
> BTW CRAM looks really nice from the data of yours :) !
>

Funny enough this is exactly the data needed to argue that CRAM should
not be a swap backend - you're offloading the cheapest part of the
process.

The actual win comes from allowing the compressed memory to stay mapped
while Read-only, which means you don't have faults.  I'll call this
"ghost-pressure" - the data is in-memory, but you have to take a fault
because it's software-compressed.  Letting it remain mapped R/O solves
the entire fault/swap machinery piece.

We cannot safely map R/W however, as you could have catestrophic loss of
compression ratio.  (I digress, but hopefully we can chat more at LPC)

> > That shows up as stalls and PSI pretty quickly and can be dealt with
> > by monitoring - but I can see the desire to just have them OOM.
> 
> Right, monitoring is less effective from somehting that is directly
> in the kernel.
> 

Well.... I think this is probably an organizational philosophy.

We are pretty solidly effective with PSI + proactive reclaim keeping
our machines chugging along nicely.  I think this is where a lot of
confusion is coming from - because the PSI data is very effective.

> > > The second one is a policy change,
> > 
> > Disagree.
> > 
> > If zswap does not charge a physical slot, then it is correct to stop
> > charging the counter based on the historic definition - it just was
> 
> Hmm, but the historical defination is the logical entry, no?
>

I think this is the entire debate, right?

Historically I think it's clear that it is a physical slot, from the
time it was proposed it was talked about in terms of consumption, and
Johannes' original definition even said "physical" (for some reason
this did not make it into the docs).

The zswap-charging-swap was a function of zswap reserving a writeback
slot - which means it *was* consuming a physical slot and it was being
accounted accordingly.

If zswap no longer reserves a writeback slot by default, it's not being
consumed, and so not charging it is correct.

But if you read the docs as swap being a logical counter as opposed to a
physical counter, without the context of zswap reserving writeback, then
I can understand how we got here.

The question is how do we move foward.  Continuing to charge swap breaks
us, but not charging swap breaks you.  At the end of the day, someone is
changing the counter they're using (or methodology).

> > I would push back on tiering - this seems like more complexity than the
> > requirement warrants.  We may find memory-backed and storage-backed swap
> > want different solutions in the "tiering" worlds.
> 
> Hmm, I mean in general swap are page fault (swap entry) based, that makes
> them similiar and that's the common point?
>

As above, I think even in memory-tiering we have this separation of
reasoning about different logical tiers of memory (VRAM, DRAM, CXL) but
among those tiers we do not differentiation except maybe based on
locality of accessor (socket0 prefers cxl on its own CXL complex over
cxl on socket1's complex to avoid the extra NUMA hop).

I can see there being a differentiation here as well (memory backed vs
storage backed).

> > 
> > e.g. it may never make sense to give zswap/zram/xswap a lower priority
> > than a physical swap layer, and you may never really want to compose
> > them with one another, so why does it need to be considered?
> 
> Making ZRAM have a lower priority could make sense... Well I haven't
> actually see it being used that way, but first there are users of
> multiple ZRAMs indeed, and e.g. if you put offline batch tasks on the
> same machine with high priority tasks, and the offline batch task only
> want to finish their work, however slow is fine, and the user want to
> have lower impact on CPU usage from them, with a limited storage space.
> Well I have to say this looks odd and just a theory, but we have see
> too many bizzard usage of the Linux kernel, there are even people
> using deprecated GPU's VRAM as SWAP for CPU's RAM, and hey they
> still make sense, you can easily found popular community projects
> based on that.

This is what I mean by I would push back on a tiering solution.  We
haven't even figured this out for memory alone - let alone a component
that composes both memory and storage.

What's the chance we get it right?  I think unlikely.

~Gregory

