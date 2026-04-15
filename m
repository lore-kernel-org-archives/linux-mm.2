Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF26DF43832
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B8F6B0005; Wed, 15 Apr 2026 11:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBBF6B0095; Wed, 15 Apr 2026 11:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302266B0096; Wed, 15 Apr 2026 11:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB116B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:18:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCD3CE413B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:17:59 +0000 (UTC)
X-FDA: 84661145478.10.D19DDFF
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id E53CA4000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:17:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Yh7V3KPJ;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776266278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dowXUfQQOnu7UlbiaKZmPHb5cgghiRsZLFzOWNbiThQ=;
	b=hXg/jUv/dlUYjwPan3kT8pYQtRLi79JQ5pEkfeUqFv7rUuaCAB3CAySJ61557yuqYbrCXj
	vSXJYEyIClxE2AbmbOvZrIAHZXBp/d8Ebd/pmGeqNW5o/SryvqfFC/HsMnqkjLFsw8l1Xp
	B+gkN6ILS9h6kI/w6rY42CNXTh61Osw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Yh7V3KPJ;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776266278; a=rsa-sha256;
	cv=none;
	b=aosev913myy8t9p8A0BnIHZxseTDLIz70yUKBHtw4Fx0t4tiq5TJdOsoJyKyjP0Ep7LsGV
	Kwrsks+YCIMqxQPtTFlSbQlLc4pGSAwPAxGDra4OUz4pB5nTiIGlsgULPJwRk+UJRr7eui
	cx6MnhV7fyc4/XNUQdQg55T/GPp6N/w=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cb40149037so641739785a.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776266277; x=1776871077; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dowXUfQQOnu7UlbiaKZmPHb5cgghiRsZLFzOWNbiThQ=;
        b=Yh7V3KPJ/WhvhjFexV35QtrYXSTQZUCeFsgI7CgKwzc8OfLSA/xX4QhRsULHoXsdSj
         5DQ9MoiFmqqsIBxavbprTupMrG58Ls1ViQ4s5qTAhd70PhwktQY9f04IoBPcB5QNU5VH
         oa7+M+cv3uUO9T1PG8CXxVc6FFl6vky87v8V4MMnwi7YYosLtk7n53MuXEusFab99Y4X
         pisDQy/RaMIukwr5OCMW9Q7Vji0RsP3yU92k1eQQ1h3ssB7JpuRncixAktdY/xCzwcEn
         dVnL7yav8/7QVaHu0Mi1RqYiZL1MyUhQkfvNCT1iEfgALjK25vE5QpO4u35EzTSyB2Tt
         /yYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776266277; x=1776871077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dowXUfQQOnu7UlbiaKZmPHb5cgghiRsZLFzOWNbiThQ=;
        b=RKpzKIpJ11nMIyp7mHsbixqKsKTv0bEtqA+0Gw/ED2/LsZMOxqt8jAFuZgYNQLXYbJ
         n2HDbHC7Vo/4zvy1M2sFJAoqlQxGV3Rsg6Ao19njyvedfg+4zsWO5WM1lotBkUhXnisa
         0rR6lVPS6Yc+1zK6m2wWUPUOmRoO1cPscu2O/E2drrmpA54BxN8dBPPcjojvQcpCdsmh
         r3veMgyE8S3idCfXfOgNBIvkrDFyNDVA7Zf7Xk19pyA8xXxIoWRljbnG9PzwUFWMGxDt
         BV9EMF1csRDNJqPCl6FZDTp1UZW8cDA3yVLVKZxd/JXg1+6q5tamNUbxF4TUMaBNRveK
         RCkw==
X-Forwarded-Encrypted: i=1; AFNElJ8gylblWO9NBNnDMydmOYK1Zfs2/VGlEsmHzhdJppiiA2x/j+JkiwFciSbpZrYYg0p0q5dkpiOeKQ==@kvack.org
X-Gm-Message-State: AOJu0YwxbxguoEUyIaKRm6/SdrLMvgjBqxgR1lNYbUeRYo2NJORF7MwL
	YFi3IUKlB6MUnVBJ6KS2KohoUqKpif0+ejD6fc0pkBznVZpAl65qxKYb7JozcBcLQ/8=
X-Gm-Gg: AeBDievqsf6Toi5OPzcaW7zgbx286TG5Co+FXTSeGDHv/6i2yNgaEMoxcz000ST/WAd
	lkmCxm01V3zrraDpYI+UVeXilGLLMolAuRMLb4OgH4qfW1qQMdXqGIxWIS5AKT1b59/wPpdLoV5
	U9BN8qcKD0UAjb5R3jtuHYT5o+RBsXoqtT/LNzxCDPCF/2cVquhndYkCp+/e5dS5/TdtBInG6Gz
	UrV3MYXuz8kUqJUMgf81iRHY7uJYIhAOpMD5GuoGQTg9mquMXLgk01qxZb8JTa1RqiyXBiGYo88
	LcW1S31IZViTwiRw0kb5I09GtLknfoN4C2N3WRWrMww1cM9n+Ygzuv9qJ+ODOmJNQBxgcnN8Zxt
	JwFtxxn+dH8mVFOz3JXwDqXv079R9JNi7D8C6eR9297BBLCX7LS6sPVJI6xeL6DPyTwtAG9s+UK
	VK8Hz8WhA5uJ33uvhnOyOK6Qr8vzNefO6ES4OOm+ZJnc86Unzz
X-Received: by 2002:a05:620a:450e:b0:8ca:2e36:18b0 with SMTP id af79cd13be357-8ddcf1b8f1amr3209217385a.39.1776266276487;
        Wed, 15 Apr 2026 08:17:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2607:fb90:ea03:4042:f7e3:e9e9:9e22:5a8e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e4f243a20csm136694985a.23.2026.04.15.08.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 08:17:55 -0700 (PDT)
Date: Wed, 15 Apr 2026 11:17:50 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ad-r7hwIdnvKsrh9@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
 <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
 <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
 <ad0iT4UWka3gMUpu@gourry-fedora-PF4VCD3F>
 <38cf52d1-32a8-462f-ac6a-8fad9d14c4f0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38cf52d1-32a8-462f-ac6a-8fad9d14c4f0@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E53CA4000E
X-Stat-Signature: bjo15afokb1wryszwsr4rhwx1c9wsuuh
X-Rspam-User: 
X-HE-Tag: 1776266277-120220
X-HE-Meta: U2FsdGVkX1/O4KZg3KcLR8uOe4VuhfLLqS2PxPpiyyiNgJ6tZ1heA6iIBKRz8E0FClYpDZe67kzP4ymEU6cfAWQK9oY9wXqi1yGvTC2O0YY+q0hFDOr8D25iwZmu6nRDLusbhpu2UDFvQWcmPt6v8TsN+4+xV9Ms2RifQRBT7fdKEffrsAxsul7MSk67iXj+OEUfcekX/2V6fYCBmNjmZZh1rVHBd7LPo/MQtb46pWSB/rp7ZE4rTfGKJklPovfGPkWREA7xeReajMnlOoM7lDr+zZ6F8uJFXPjpbje18LZK1xUtj8K/CKlbXa6j8tabvkPUbNT25wuCsOvFP+imJwQ+kKRQBYx83iVCefXTuKRYTHSKo/l88QpjLcxVVYbXwSAx+i8/ULBCf9qOYfCdJdkjvOiWJ8iKCgiuoaLzGipAOQ6AZ9LjDc/H3sZuyiqDZ98vZ52xBJTHW+7Q88vbypqYYHgRaWClfOU4BL1KyM9mKC74Q7KplBYqQaRYFRKuLv9FQSu8BG6k6TsQErPb8Z7Ngs8g5sBK/L5Pqh+cVc4FRQmUxZCkP4debec3Gmmre46hWXpL81tTvHfV+7yoLH2aHGENUoTUdgj0GcHtggiADVZQvPmKBkqmPfBxt98CVwWNV8el6YbUPeQ8qRPGx6qZJssjun+L52SiYKvW4k6dmifX4vMbpLq/QN8UmA7e26r3tNvQakO3/HdGjrwpf/3FNWlZ0O3JLNyKO6w+TiPVWidu6QcGHho/ar7s/f1osZsxlXiR8PzY8dQ/29W1a3lXZ8sjGMfG43D5PCF2XDIdOqATG3Qc23W5H8fHS6JWVhjiKIq7ztDjaKCqAQOIxsOy5rUXSvFjS0rM/dLSgkB4Q2Skn1E6hsxH+c6piJuSeTYcwMGNM1HkbwiZNaNBmCICgKYjw/m+TnQOtCt8nJbunUPoPpphfYSdfekUwCxj/LsHYfmCDkx3mx1e5Rb
 RCH0ByW5
 uU3dqwspo7KPneIfB+hPqoAeNbWpL5BQ+Rokm7kdz3hru/lbTZHey3xchIAKg93RbA3+FNxA2RzDnFgE4HuXbYw7Jh+TVT686l/GgbT7ATAWw8yXInCwxJRJhfjhgYMXW84GPwZZUPcTMylmBZO3CANI3a14tACGOS3bwiVaVFZMSbO6FHBB5i4ReQ66N+LMTlKOtjrOyzdtM6YpWVeHU1tiGNuuK/LEYgtK78p+D/BecuHdzzk+CoSOFXO4Lk2JBIcmRDMrrHrgvYpX1ZFxA4slM0oqo5LyIRCBEmjEJ7CtkxFb5RLuWICcqHUliTNi/4OEPPdcZANbr8gxu/wwqIwBHOtljpQgBCt30B5uOp2f7d2Xfw9PLriTTlllQRx49pKA/B9mnbjfgzgrK5zKWnI+vC+Akr0hHm6ZeKJsZ2n4GUagmb6IPSO+N0ni6aR6zn+FR92Wi+E8FbHjRTLwgSBEmPX7eJOOwL4/3Y07h5QA9iPA/UglFRVNZwAlfNHR/nafios3Up1LFvl61uqKN/AZ52Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 11:49:59AM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 19:05, Gregory Price wrote:

As a preface - the current RFC was informed by ZONE_DEVICE patterns.

I think that was useful as a way to find existing friction points - but
ultimately wrong for this new interface.

I don't thinks an ops struct here is the right design, and I think there
are only a few patterns that actually make sense for device memory using
nodes this way.

So there's going to be a *major* contraction in the complexity of this
patch series (hopefully I'll have something next week), and much of what
you point out below is already in-flight.

> > On Mon, Apr 13, 2026 at 03:11:12PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > This is because the virtio-net device / network stack does GFP_KERNEL
> > allocations and then pins them on the host to allow zero-copy - so all
> > of ZONE_NORMAL is a valid target.
> > 
> > (At least that's my best understanding of the entire setup).
> 
... snip ...
> 
> A related series proposed some  MEM_READ/WRITE backend requests [1]
> 
> [1] https://lists.nongnu.org/archive/html/qemu-devel/2024-09/msg02693.html
> 

Oh interesting, thank you for the reference here.

> 
> Something else people were discussing in the past was to physically
> limit the area where virtio queues could be placed.
>

That is functionally what I did - the idea was pretty simple, just have
a separate memfd/node dedicated for the queues:

guest_memory = memfd(MAP_PRIVATE)
net_memory = memfd(MAP_SHARED)

And boom, you get what you want.

So yeah "It works" - but there's likely other ways to do this too, and
as you note re: compatibility, i'm not sure virtio actually wants this,
but it's a nice proof-of-concept for a network device on the host that
carries its own memory.

I'll try post my hack as an example with the next RFC version, as I
think it's informative.

> > 
> > This partially answers your question about slub fallback allocations,
> > there are slab allocations like this that depend on fallbacks (more
> > below on this explicitly).
> 
> But that's a different "fallback" problem, no?
> 
> You want allocations that target the "special node" to fallback to
> *other* nodes, but not other allocations to fallback to *this special* node.
>
... snip - slight reordering to put thoughts together ...
> > 
> > __GFP_PRIVATE vs GFP_PRIVATE then is just a matter of use case.
> > 
> > For mbind() it probably makes sense we'd use GFP_PRIVATE - either it
> > succeeds or it OOMs.
> 
> Needs a second thought regarding fallback logic I raised above.
> 
> What I think would have to be audited is the usage of __GFP_THISNODE by
> kernel allocations, where we would not actually want to allocate from
> this private node.
> 

This is fair, and I a re-visit is absolutely warranted.

Re-examining the quick audit from my last response suggests - I should
never have seen leakage in those cases, but the fallbacks are needed.

So yes, this all requires a second look (and a third, and a ninth).

I'm not married to __GFP_PRIVATE, but it has been reliable for me.

> Maybe we could just outright refuse *any* non-user (movable) allocations
> that target the node, even with __GFP_THISNODE.
> 
> Because, why would we want kernel allocations to even end up on a
> private node that is supposed to only be consumed by user space? Or
> which use cases are there where we would want to place kernel
> allocations on there?
> 

As a start, maybe? But as a permanent invariant?  I would wonder whether
the decision here would lock us into a design.

But then - this is all kernel internal, so i think it would be feasible
to change this out from under users without backward compatibility pain.

So far I have done my best to avoid changing any userland interfaces in
a way that would fundamentally change the contracts.  If anything
private-node other than just the node's `has_memory_private` attribute
leaks into userland, someone messed up.

So... I think that's reasonable.

> 
> I assume you will be as LSF/MM? Would be good to discuss some of that in
> person.
>

Yes, looking forward to it :]


> > One note here though - OOM conditions and allocation failures are not
> > intuitive, especially when THP/non-order-0 allocations are involved.
> > 
> > But that might just mean this minimal setup should only allow order-0
> > allocations - which is fiiiiiiiiiiiiiine :P.
> 
> 
> Again, I am not sure about compaction and khugepaged. All we want to
> guarantee is that our memory does not leave the private node.
> 
> That doesn't require any __GFP_PRIVATE magic, just en-lighting these
> subsystems that private nodes must use __GFP_THISNODE and must not leak
> to other nodes.

This is where specific use-cases matter.

In the compressed memory example - the device doesn't care about memory
leaving - but it cares about memory arriving and *and being modified*.
(more on this in your next question)

So i'm not convinced *all possible devices* would always want to support
move_pages(), mbind(), and set_mempolicy().

But, I do want to give this serious thought, and I agree the absolute
minimal patch set could just be the fallback control mechanism and 
mm/ component filters/audit on __GFP_*.


> > If you want the mbind contract to stay intact:
> > 
> >    NP_OPS_MIGRATION (mbind can generate migrations)
> >    NP_OPS_MEMPOLICY (this just tells mempolicy.c to allow the node)
> 
> I'm missing why these are even opt-in. What's the problem with allowing
> mbind and mempolicy to use these nodes in some of your drivers?
> 

First:

In my latest working branch these two flags have been folded into just
_OPS_MEMPOLICY and any other migration interaction is just handled by
filtering with the GFP flag. 


on always allowing mbind and mempolicy vs opt-in
---

A proper compressed memory solution should not allow mbind/mempolicy.

Compressed memory is different from normal memory - as the kernel can
percieves free memory (many unused struct page in the buddy) when the
device knows there's none left (the physical capacity is actually full).

Any form of write to a compressed memory device is essentially a
dangerous condition (OOMs = poison, not oom_kill()).

So you need two controls:  Allocation and (userland) Write protection
I implemented via:
    - Demotion-only (allocations only happen in reclaim path)
    - Write-protecting the entire node

(I fully accept that a write-protection extension here might be a bridge
 to far, but please stick with me for the sake of exploration).


There's a serious argument to limit these devices to using an mbind
pattern, but I wanted to make a full-on attempt to integrate this device
into the demotion path as a transparent tier (kinda like zswap).

I could not square write-protection with mempolicy, so i had to make
them both optional and mutually exclusive.

If you limit the device to mbind interactions, you do limit what can
crash - but this forces userland software to be less portable by design:

  - am i running on a system where this device is present?
  - is that device exposing its memory on a node?
  - which node?
  - what memory can i put on that node? (can you prevent a process from
    putting libc on that node?)
  - how much compression ratio is left on the device?
  - can i safety write to this virtual address?
  - should i write-protect compressed VMAs? Can i handle those faults?
  - many more

That sounds a lot like re-implementing a bunch of mm/ in userland, and
that's exactly where we were at with DAX.  We know this pattern failed.

I'm trying to very much avoid repeating these mistakes, and so I'm very
much trying to find a good path forward here that results in transparent
usage of this memory.


> I also have some questions about longterm pinnings, but that's better
> discussed in person :)
>

The longterm pin extention came from auditing existing zone_device
filters.  

tl;dr: informative mechanism - but it probably should be dropped,
it makes no sense (it's device memory, pinnings mean nothing?).


> > 
> > The task dies and frees the pages back to the buddy - the question is
> > whether the 4-5 free_folio paths (put_folio, put_unref_folios, etc) can
> > all eat an ops.free_folio() callback to inform the driver the memory has
> > been freed.
> 
> Right, that's rather invasive.
> 

Yeah i'm trying to avoid it, and the answer may actually just exist in
the task-death and VMA cleanup path rather than the folio-free path.

From what i've seen of accelerator drivers that implement this, when you
inform the driver of a memory region with a task, the driver should have
a mechanism to take references on that VMA (or something like this) - so
that when the task dies the driver has a way to be notified of the VMA
being cleaned up.

This probably exists - I just haven't gotten there yet.

~Gregory

