Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FAEF34C64
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 17:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930F86B0088; Mon, 13 Apr 2026 13:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2356B008A; Mon, 13 Apr 2026 13:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1DA6B0092; Mon, 13 Apr 2026 13:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8EB6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:05:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0990AE2E73
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:05:27 +0000 (UTC)
X-FDA: 84654158694.11.A3C4280
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0ECAF120009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:05:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jkLAp+3w;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776099925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AKXTVWdZGGDUzDswSpuJJ++/7lCF35yufiWfZYsxfQ=;
	b=E5T/mxaVWM/QLWRLdc9YWi8v1q8OgJ30Y+NFD1mJlGeY9aKlhGQDuFEBGUY8cYow4QdWc9
	TlcgYjXgZuqBQOwhKOLtNDbkBbh3llVpVrDFEvddpmjohhYnNKpgnJyTFfgdA+wTqdfO3K
	0/FohfTiw4d20W7wU48g8M1JASAEM7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776099925; a=rsa-sha256;
	cv=none;
	b=zFAjgKleiJoapbFkWRp+MB3XN4Tjk1EMmboQRBgs/dgicYaNMOoTQcgTcsXp6kMXk82WNw
	+Tbvd2DWGmhjeWWD4PCFemPDdKMIVAtV3bO0hNH8uTaMLr+1kFGUBh2l3DK7xEGp6se5rJ
	NJck2o+b8Dy9Hpy7mC1+6RF+40BuLyc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jkLAp+3w;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c6f21c2d81so350561985a.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776099924; x=1776704724; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4AKXTVWdZGGDUzDswSpuJJ++/7lCF35yufiWfZYsxfQ=;
        b=jkLAp+3wf2iPXIc6AjwDR0wZ7RLp4yo9rIdzvu3XtD9H+AJVPf/Vzlk/kQmFm/UfWS
         B0OBUbkIWzExeACkMZ7j5AuRxdUNj43GCCRw1Gx/fn7h3q9IzEBKP4wXrC0tfdbuzkzb
         uTtGdZoc+/dU73iwPOPntKqa2K7CD+/BFIBl2+a27DnW1eNftzA3+oSPh3zo4hbMrbHi
         jb7hRHtiYLBx/i3kJVUXOJHerpkRpXSO2MvSov9nBncJ80VEF+jTIkzCiwDFQAlHqGzR
         uvpmDgzJ36e0EY847aW+YJrf8LkiaJtVUY2v2Ai27C9N8mAQ7sorQgci13GN/1hjxOIN
         VeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776099924; x=1776704724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4AKXTVWdZGGDUzDswSpuJJ++/7lCF35yufiWfZYsxfQ=;
        b=aPmhiLEUZqwNCtY6tUVyP8l55vqN6BShrm9S09xT3J+JWA236BLpRJxu2IU//nvHTj
         p5B5NH0/UMaYMvJRwBI2Cvha0rvU+iWRVulsAXge9jmAU1bYNQPPSkg26TF7C/aqRW5+
         wc04l+d/h+eCIu/PrhEI9+yKUjJCWcrz1JSWgQ196BZze9xnI94MvY3P45WTrr6P0Hqq
         VNKRUYwSkGYyjHnPcBZMX7YMlaDcl83+UHzwFpPVH73wznuC7RfyAtrGN9+y1y5w2+ek
         cyhThPUTILh8CFLFTUz86okJWiFTGcigRmdj47fiLpGoa45GX1MuIJMTq0uQ33gac08s
         iEYw==
X-Forwarded-Encrypted: i=1; AFNElJ9y58u5A+ZWOY59FQMND3UTgOhZCx2RO5r77PPsdtUyNsjK/K7Q1enyAILDiunaMnKOIL+1tTc/vw==@kvack.org
X-Gm-Message-State: AOJu0Yz5m3OgpAHH9va51e69AgXRM+BYuDGa7g9HzqjK+6B8eThE9rhi
	QA8jjIO/L7X1RQWOGJFsRoP7lNQ3KNDGH3kn9OPuwxCBQWqsLo2KCJ41LeOC4U6eaog=
X-Gm-Gg: AeBDiesE1ksoGP4kIkbof+3GpjXu9YBYKusPR1v2/czHovhuKtdTr16jCJjTmZb2CXy
	7CV56dumzpx/68irW3cFIn11tX5kW4vT9Q3h8PbiIR6VeQ6CLqabpTuvtGk2+RpfqqMjRcjRLe9
	fK3NzqU3BLCJdf+fFPLleQX6Q6ahe/SSxJvpfsqUd0I9nQYzd8nrP//jnC9K/I85J1tGuexkZhn
	yVeHVvZP6UPAv1CrORufoKwKcEHa6jtc/GT6u7ltUMNhd0lULD00WcDknyHERrqS2439W0PRge5
	MWKLaYyxoocmRTJX/6Ot/fiySTNAG+9ML9xZfO22gCTjw5gbzkkTuRCjsr6eU9hTJoOGpb3t3lm
	18wuS8DoT3RdSMAOqc5/+xwumLRSyhp9W8s6ZOC8+htG6cR5f/gWs/iIfQ9g5j2Z8ozjVmiRjD+
	IaFUsbcn59XPsGmYztZbJnpwKSOnB/Ie/IEb8kTL+crYIdzUlZpL4nqQzoMvciAlYlKXBuG8UKH
	Sm9sBsTlQfQz9GIJb/sONY=
X-Received: by 2002:a05:620a:4688:b0:8da:358a:c481 with SMTP id af79cd13be357-8ddccb293f3mr2047470485a.1.1776099923608;
        Mon, 13 Apr 2026 10:05:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6562409sm912511185a.17.2026.04.13.10.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 10:05:22 -0700 (PDT)
Date: Mon, 13 Apr 2026 13:05:19 -0400
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
Message-ID: <ad0iT4UWka3gMUpu@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
 <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
 <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
X-Rspamd-Queue-Id: 0ECAF120009
X-Stat-Signature: 78sx6sei3asog9rnhsz3ijb639ep1ms1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776099924-730963
X-HE-Meta: U2FsdGVkX1+e7tigBH2jVuZeLz3Eye3+ui1u43vyJ7nJw+F57UiwXPWLhg/YhhPLIXz86p01qO59PsjmEaAiPMAsox+TacKTlhVlXobkvF3wYyYzCXm6oq8BT+tiRo5xcUsredtOuTc5ceDzbj8JUXxCH6g1CV+CRHbpV1Gv4rti8E7AXIkS260VMVszJwUmeYxkofHXzKnUq7s2GtCNWsS/LMOkY5ii8plkqrpdM8Zodu1gBSq+M5bZ20cEv6f5EQ3E6ZgURpyO6E6/ZQEDyxSKXrfW8V25/MiybBVmdCRZxtFW/2tP55kK5Oc52kjN88TrgACTze34f8jjm8rTMNDW3dQdME0hqmR8Vl0SwBOQF8A3ysIoOxNueD3MSqqK3YWNN1Qj0TV9Qaio5WJ059DJ3u2CY542VyBg8BqX26kjllC7WxdHViKyMVhAgpP0gaoIgSpR3ICUw3IfTJn4W6KpuAU/qfkzN61N+3i4gotIDRJEgspaXhNAHdcinNyMIhqD1Mvp74butVbhggStMO+HCOssJ/Xa1uds8Rcmsdk9ZhQ4xb2pXMvhZwT6RqSPCBO3DP4ZB5tDPN57D+40IHgY6dgTwy+8hd0KQM81kZoq7sDxfA8DXmh+OkRk1uYxrrwuVTHbONdMIqgbJHJjPmV86QHOJIJ8TheVLqp995wN37K8Znc9NJ3ZQbSe6PnqUt0ic7q2OEJONFYDEU/pCdZ2gEqJiM8RhI0bymDycncjscvdDrWqRkFZ0DGWAWPakEoBM7PAu6jbQtH6fSHo6PRqNCaE5z9c/WTbWMRN0o2lbv6U1Ja6nR6sKTAS8H12NqUBguSBGzyavsBdw7UUTwuhyiCsuCzL1+uXogB4QVwgEZjpCidD8nMv9rSOzc2zRBSKZTUO9cXu/2QqfQGk4e0To2kn6PvirTz/HijdtRb9OUpxcSsWPNX2j5lfb8AcURbWnalyZ2/TuJwfuzN
 U9TtozFQ
 MlyPaC6lAt3MN+4pbGgEPaFUzuhFQCYxNuX6k3Qr3RkGlD1uW5u4Ika6Hal70WeYOEoBBp2m0EKH5W2FpGWOJs1hJPfJRmZCbsxPzDpFzG19NZn+oDxuJlrVwYPo8gYiwTVH7syVqSJRq9cywlmapdLJec//u5fS7WWyufmLyQVhgD94yozy7/JQw0/+rJYco/UTL4QHKTM8OknX1vJvEX3gs11yv9v3DSa5hWUr63bvRTgKN+ILoWTbwvTwTor8QYw4eRKCwKBBF3kUGAzoISbuGHU+YAC2GN3W+xRsXeIsn7vkPm3+J/Dyw3WMK+nmgwyV+D+Ik9xnajYggR1ekK7kCIEShm0CcLvzx/+hyryeDCbY/vFQY/yuXY7LvFrlyACad3VQI70aeG3SaOLe3MYod6DMq74MDMEfXeO3E9F5AiNOG4TCIGHXJbVnYK2vFmjYsi/LdOR/95CE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:11:12PM +0200, David Hildenbrand (Arm) wrote:
> > Normally cloud-hypervisor VMs with virtio-net can't be subject to KSM
> > because the entire boot region gets marked shared.  
> 
> What exactly do you mean with "mark shared". Do you mean, that "shared
> memory" is used in the hypervisor for all boot memory?
> 

Sorry, meant MAP_SHARED.  But yes, in some setups the hypervisor simply
makes a memfd with the entire main memory region MAP_SHARED.

This is because the virtio-net device / network stack does GFP_KERNEL
allocations and then pins them on the host to allow zero-copy - so all
of ZONE_NORMAL is a valid target.

(At least that's my best understanding of the entire setup).

> 
> You mean, in the VM, memory usable by virtio-net can only be consumed
> from a dedicated physical memory region, and that region would be a
> separate node?
>

Correct - it does requires teaching the network stack numa awareness.

I was surprised by how little code this required, though I can't be
100% sure of its correctness since networking isn't my normal space.

Alternatively you could imagine this as a real device bringing its own
dedicated networking memory for network buffers, and then telling the
network start "Hey, prefer this node over normal kernel allocations".

What I'd been hacking on was cobbled together with memfd + SRAT bits to
bring up a private node statically and then have the device claim it -
but this is just a proof of concept.  A proper implementation would be
extending virtio-net to report a dedicated EFI_RESERVED region.

> > 
> > I see you saw below that one of the extensions is removing the nodes
> > from the fallback list.  That is part one, but it's insufficient to
> > prevent complete leakage (someone might iterate over the nodes-possible
> > list and try migrating memory).
> 
> Which code would do that?
> 

There are many callers of for_each_node() throughout the system.

but one discrete example:

int alloc_shrinker_info(struct mem_cgroup *memcg)
{
... snip ...
  for_each_node(nid) {
    struct shrinker_info *info = kvzalloc_node(sizeof(*info) + array_size,
                                               GFP_KERNEL, nid);
... snip ..
}

If you disallow fallbacks in this scenario, this allocation always fails.

This partially answers your question about slub fallback allocations,
there are slab allocations like this that depend on fallbacks (more
below on this explicitly).

> > Basically the only isolation mechanism we have today is ZONE_DEVICE.
> > 
> > Either via mbind and friends, or even just the driver itself managing it
> > directly via alloc_pages_node() and exposing some userland interface.
> 
> Would mbind() work here? I thought mbind() would not suddenly give
> access to some ZONE_DEVICE memory.
>

Sorry these were orthogonal thoughts.

1) We don't have such a mechanism. ZONE_DEVICE's preferred mechanism is
   setting up explicit migrations via migrate_device.c

2) mbind / alloc_pages_node would only work for private nodes.

   Extending ZONE_DEVICE to enable mbind() would be an extreme lift,
   as the kernel makes a lot of assumptions about folio->lru.

   This is why i went the node route in the first place.

> > 
> > in the NP_OPS_MIGRATION patch, this gets covered.
> 
> Right, but I am not sure if NP_OPS_MIGRATION is really the right
> approach for that. Have to think about that.
>

So, OPS is a bit misleading, but it's the closest i came to some
existing pattern.  OPS does not necessarily need to imply callbacks.

I've been trying to minimize the patch set and I'm starting to think
the MVP may actually be able to do away with the private_ops structure
for a basic migration+mempolicy example by simply teaching some services
(migrate.c, mempolicy.c) how/when to inject __GFP_PRIVATE.

the mempolicy.c patch already does this, but not migrate.c - i haven't
figured out the right pattern for that yet.

> > 1) as you note, removing it from the default bitmaps, which is actually
> >    hard.  You can't remove it from the possible-node bitmap, so that
> >    just seemed non-tractable.
> 
> What about making people use a different set of bitmaps here? Quite some
> work, but maybe that's the right direction given that we'll now treat
> some nodes differently.
>

It's an option, although it is fragile.  That means having to police all
future users of possible-nodes and for_each_node and etc.

I've been err'ing on the side of "not fragile", but i'm open to rework.

> > 
> > 2) __GFP_THISNODE actually means (among other things) "don't fallback".
> >    And, in fact, there are some hotplug-time allocations that occur in
> >    SLAB (pglist_data) that target the private node that *must* fallback
> >    to successfully allocate for successful kernel operation.
> 
> 
> Can you point me at the code?
>

There is actually a comment in slub.c that addresses this directly:

static int slab_mem_going_online_callback(int nid)
{
... snip ...
	/*
	 * XXX: kmem_cache_alloc_node will fallback to other nodes
	 *      since memory is not yet available from the node that
	 *      is brought up.
	 */
	n = kmem_cache_alloc(kmem_cache_node, GFP_KERNEL);
... snip ...
}

Slab basically acknowledges the behavior is required on existing nodes
and just falls back immediately for the "going online" path.

Other specific calls in the hotplug path:

  mm/sparse.c:           kzalloc_node(size, GFP_KERNEL, nid)
  mm/sparse-vmemmap.c:   alloc_pages_node(nid, GFP_KERNEL|...)
  mm/slub.c:             kmalloc_node(sizeof(*barn), GFP_KERNEL, nid)

There are quite a number of callers to kmem_cache_alloc_node() that
would have to be individually audited.

And some non-slab interfaces examples as well:
	alloc_shrinker_info
	alloc_node_nr_active

I've been looking at this for a while, but I'm starting to think trying
to touch all this surface area is simply too fragile compared to just
letting normal memory be a fallback for private nodes and adding:

      __GFP_PRIVATE   - unlock's private node, but allow fallback
#define GFP_PRIVATE   (__GFP_PRIVATE | __GFP_THISNODE) - only this node

__GFP_PRIVATE vs GFP_PRIVATE then is just a matter of use case.

For mbind() it probably makes sense we'd use GFP_PRIVATE - either it
succeeds or it OOMs.

> > The flexibility is kind of the point :]
> 
> Yeah, but it would be interesting which minimal support we would need to
> just let some special memory be managed by the kernel, allowing mbind()
> users to use it, but not have any other fallback allocations end up on it.
> 
> Something very basic, on which we could build additional functionality.
> 

I actually have a simplistic CXL driver that does exactly this:
https://github.com/gourryinverse/linux/blob/072ecf7cbebd9871e76c0b52fd99aa1321405a59/drivers/cxl/type3_drivers/cxl_mempolicy/mempolicy.c#L65

We have to support migration because mbind can migrate on bind if the
VMA already has memory - but all this means is the migrate interfaces
are live - not that the kernel actually uses them.

so mbind requires (OPS_MIGRATE | OPS_MEMPOLICY)

All these flags say is:
   - move_pages() syscalls can accept these nodes
   - migrate_pages() function calls can accept these nodes
   - mempolicy.c nodemasks allow the nodes (should restrict to mbind)
   - vma's with these nodes now inject __GFP_PRIVATE on fault

All other services (reclaim, compaction, khugepaged, etc) do not scan
these nodes and do not know about __GFP_PRIVATE, so they never see
private node folios and can't allocate from the node.

In this example, all migrate_to() really does is inject __GFP_THISNODE,
but I've been thinking about whether we can just do this in migrate.c
and leave implementing the .ops to a user that requires is.

But otherwise "it just works".

One note here though - OOM conditions and allocation failures are not
intuitive, especially when THP/non-order-0 allocations are involved.

But that might just mean this minimal setup should only allow order-0
allocations - which is fiiiiiiiiiiiiiine :P.

-----------------

For basic examples

I've implemented 4 examples to consider building on:

  1) CXL mempolicy driver:
     https://github.com/gourryinverse/linux/blob/072ecf7cbebd9871e76c0b52fd99aa1321405a59/drivers/cxl/type3_drivers/cxl_mempolicy/mempolicy.c#L65

     As described above

  2) Virtio-net / CXL.mem Network Card
     (Not published yet)

     This doesn't require any ops at all - the plumbing happens entirely
     inside the kernel.  I onlined the node with an SRAT hack and no ops
     structure at all associated with the device (just set node affinity
     to the pcie_dev and plumbed it through the network stack).

     A proper implementation would have virtio-net register is own
     reserved memory region and online it during probe.
  
  3) Accelerator
     (Not published yet)

     I have converted an open source but out of tree GPU driver which
     uses NUMA nodes to use private nodes.  This required:
            NP_OPS_MIGRATION
            NP_OPS_MEMPOLICY

     The pattern is very similar to the CXL mempolicy driver, except
     that the driver had alloc_pages_node() calls that needed to have
     __GFP_PRIVATE added to ensure allocations landed on the device.


  4) CXL Compressed RAM driver:
     https://github.com/gourryinverse/linux/blob/55c06eb6bced58132d9001e318f2958e8ac80614/mm/cram.c#L340
     needs pretty much everything - it's "normal memory" with access
     rules, so the driver isn't really in the management lifecycle.

     In this example - the only way to allocate memory on the node is
     via demotion.  This allows us to close off the device to new
     allocations if the hardware reports low memory but the OS percieves
     the device to still have free memory.

     Which is a cool example:  The driver just sets up the node with
     certain attributes and then lets the kernel deal with it.


I have started compacting the _OPS_* flags related to reclaim into a
single NP_OPS_RECLAIM flag while testing with this.  Really i've come
around to thinking many mm/ services need to be taken as a package,
not fully piecemeal.

The tl;dr: Once you cede some control over to the kernel, you're
very close to ceding ALL control, but you still get some control
over how/when allocations on the node can be made.


It is important to note that even if we don't expose callbacks, we do
still need a modicum of node filtering in some places that still use
for_each_node() (vmscan.c, compaction.c, oom_kill.c, etc).

These are basically all the places ZONE_DEVICE *implicitly* opts itself
out of by having managed_pages=0.  We have to make those situations
explicit - but that doesn't mean we need callbacks.

> > 
> > I would simply state: "That depends on the memory device"
> 
> Let's keep it very simple: just some memory that you mbind(), and you
> only want the mbind() user to make use of that memory.
> 
> What would be the minimal set of hooks to guarantee that.
> 

If you want the mbind contract to stay intact:

   NP_OPS_MIGRATION (mbind can generate migrations)
   NP_OPS_MEMPOLICY (this just tells mempolicy.c to allow the node)

The set of callbacks required should be exactly 0 (assuming we teach
migrate.c to inject __GFP_PRIVATE like we have mempolicy.c).

If your device requires some special notification on allocation, free
or migration to/from you need:

   ops.free_folio(folio)
   ops.migrate_to(folios, nid, mode, reason, nr_success)
   ops.migrate_folio(src_folio, dst_folio)

The free path is the tricky one to get right.  You can imagine:

   buf = malloc(...);
   mbind(buf, private_node);
   memset(buf, 0x42, ...);
   ioctl(driver, CHECK_OUT_THIS_DATA, buf); 
   exit(0);

The task dies and frees the pages back to the buddy - the question is
whether the 4-5 free_folio paths (put_folio, put_unref_folios, etc) can
all eat an ops.free_folio() callback to inform the driver the memory has
been freed.

In practice - this worked on my accelerator and compressed examples, but
I can't say it's 100% safe in all contexts.  The free path needs more
scrutiny.

> For example, I assume compaction could just be supported for such
> memory? Similarly, longterm-pinning.
> 
> For some of the other hooks it's rather unclear how they would affect
> the very simple mbind() rule. What is the effect of demotion or NUMA
> balancing?
> 
> I'm afraid we're making things too complicated here or it might be the
> wrong abstraction, if i cannot even figure out how to make the simplest
> use case work.
> 
> Maybe I'm wrong :)
>

Actually, quite the opposite:  None of that should be engaged by
default.  In our above example:

   OPS_MIGRATION | OPS_MEMPOLICY

All this should say is that migration and mempolicy are supported - not
that anything in the kernel that uses migration will suddenly operate on
that memory.

So:  Compaction, Longterm Pin, NUMA balancing, Demotion - etc - all of
these do not ever operate on this memory by default.  Your device driver
or service would have to specifically opt-in to those services and must
be capable of dealing with the implications of that.

---

kind of neat aside:

You can hotplug private ZONE_NORMAL without NP_OPS_LONGTERMPIN and as
long as the driver/service controls the type/lifetime of allocations,
the node can remain hot-unpluggable in the future.

e.g. if the service only ever allocates movable allocations, the lack
of NP_OPS_LONGTERMPIN prevents those pages from being pinned.  If you
add NP_OPS_MIGRATION - the attempt to pin will cause migration :]

~Gregory

