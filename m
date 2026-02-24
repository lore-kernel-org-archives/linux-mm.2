Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD78CF3C991
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB04D6B0088; Tue, 24 Feb 2026 10:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E496B0089; Tue, 24 Feb 2026 10:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C404C6B008A; Tue, 24 Feb 2026 10:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA6946B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:17:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6255E52F4E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:17:45 +0000 (UTC)
X-FDA: 84479704890.01.5662C91
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67470A0016
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:17:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bSXhL1t7;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771946263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRR0UdatcxmbKbTIzPfU9KNK92IFjxE56yfQbHXA4Ic=;
	b=CD29HlodfLUHBhVnUnbo4iGWBrwtYXGaWk3rYFdXbTw8ao99C9q8dhrLuYWomvb8nHpMjF
	KK9jeSi79x13fi6wtqJyW/UPPf7NShNGtyrR5jlY4RNWCftV5P8kxZU7y9omtF60yhtw7k
	1QOzqTiLo5+RYEQde/MmCMO8PlZxoNQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771946263; a=rsa-sha256;
	cv=none;
	b=lVzNm0oVwATCX4DjLmDpeg5Dkt5cqeNXOvu3lTNpPb4NqDon43u08hga17Py61gSQ6H7l9
	5aK/iNQlPRXTy9uix8joEffhpyyQ4RQG5O4mlmGKud9pyJkJzhX6skUKfDZ0Ub3zBZ48j5
	V/CJYNLmKDRQbWzjcR10BGSHWdPUnM0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bSXhL1t7;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-5fa26e497abso4307916137.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771946262; x=1772551062; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PRR0UdatcxmbKbTIzPfU9KNK92IFjxE56yfQbHXA4Ic=;
        b=bSXhL1t72wvKxUQD4xea3ibO6zjQe14HwQUzfiAJUCHCaBRilWtmdxUbdjvlgEIQ19
         bLmCr0EMO3MealJUsayT4cXdVM+gH79IVWJvuZ6MsDSe7mPEq3zi2xH38ndMduHIWhkf
         3IvjIacQ1lEncEYJ7jveotZrKg28ZPamdrJCqJTgjVkZKztMF8szdCnjTeqHBgunKPqW
         zo/0/v/QGVM3vShvdp6sneUNgTZRaRhANiYHjEnB9KsteBwptocFUGmvvarTt0Qb5ogP
         H6F1N3AcSr4eDMc0pEW/PdHPzJM8LhlwZqkkSKejjealnJH3FZo5znRLxH05yiy31Y06
         vKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771946262; x=1772551062;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PRR0UdatcxmbKbTIzPfU9KNK92IFjxE56yfQbHXA4Ic=;
        b=ax//OPhh/pgyHg2Cqb/7D/t0YqoNEUcAfbv35VdtcOTSeY7sTlJ/exEQ3rle4llgQP
         7ALpr/50q1yRvlkCDCOeUnqONCyTNuCvEKEGtSkBlTeL6RR/K88iTzfFLUyd/+6wT/dw
         9bB3lEAb353KgeicjUcvbVI6DlrUZw8OKLxBvon2QjU1XBA0n/4G47wRlwRFYpmtV/o1
         PPUlB8RQdSG8Jgmoe2yg/CamBNzG4ck6prUzTFeRnHuXghvcYDwdVRd+sR51NcHfZ+jJ
         c0OexTSNgc+Tv4mr0llBxV3OaFpD7HT1AHcI2SFkjIrRGJCkQYVZ6sdH4N8POQ9g9D0v
         dLtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMJA6gXUj4uv2XV9pkbZbESXmPzwUOl3tYDDjcAUp8ju13mxLFrfA3jY7RMVVWmrKbewUPn1ThnQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8tkqreiL7HPPNoWndyn0LiX6ePwKSYfrVrhqiuTCcrbLxyCtQ
	Ab65CcplJocxyoI5l1SmRnjeLfWr4olbSYuFH37mhEyDfcOIkjmKpWPkm3gRbSirb2o=
X-Gm-Gg: ATEYQzySdBVFFrvdR5OoUXwnamL84zmBsSBIbrA8umfFQQqGcPlXndg7lHhUA9NO7TK
	YdF+f5anzaTp9PN8JcWgz384JPlrEFmjmbqBAuSvKL8rLj4F/Z40wsVvgi6u47q6/3sIM7YSR9n
	LkBZhQ5/sDr6t5EbiMCm7BBp8RJTeOvMf998Kxu/OaQfM8s4/ArCYGlUeH/HvQvLEpu3Y7DdPQG
	qqYSMV3C6kjeJ56CnOx+YzpgDUIbhz7j0vBv7DniAfFu0aMRfhK/rPGpMRDDfAf64VuJA+wfow/
	MNCgbJ1sLjeprhdDnrkVwb1qqHRCVGQsJU48R1AauM89EEbQ5LGIYF3aZRsv7dksex+MhiUny+U
	HbDqUh63lrpQTZHRK/Sf9jQH125tcHArKvKdr/IWTYHGYfd41+BkOYAqKP7OGVfHe5cKwLC7Ws3
	kUjMd24h0mw34aM048LaILXjn7tAqiGMlRHJ1OyPGRoDBpakkjXw/Sv46NjDCXn0E3wLBPJfV5n
	9loVyGj8A==
X-Received: by 2002:a05:6102:160e:b0:5ee:9f7e:b3c7 with SMTP id ada2fe7eead31-5feb2ee49bfmr6174895137.13.1771946262205;
        Tue, 24 Feb 2026 07:17:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997c6911dfsm94624986d6.2.2026.02.24.07.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:17:41 -0800 (PST)
Date: Tue, 24 Feb 2026 10:17:38 -0500
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
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
Message-ID: <aZ3BEn_73Rk8Fn7L@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <fzy6f6dpv3oq3ksr2mkst7pz3daeb3buhuvdvcw4633pcl7h6u@mxjgiwpg5acv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fzy6f6dpv3oq3ksr2mkst7pz3daeb3buhuvdvcw4633pcl7h6u@mxjgiwpg5acv>
X-Rspamd-Server: rspam09
X-Stat-Signature: zerrkef9zpysy9jp3hc88j8zxtb3uzhn
X-Rspamd-Queue-Id: 67470A0016
X-Rspam-User: 
X-HE-Tag: 1771946263-91847
X-HE-Meta: U2FsdGVkX19h2SarVOZgfc4ptvKVMO1Gv3LdDEWLsy7zkIA7fzqv2IPNoMXxnY1kddDVde6WcuAK2VaFM5m0wCRhG2TLfedXwu8EI2dWEd75J/ufXh3s8QUbivj7LYzS9i1qXgTaUgwtsn196tIzcFvyoJ5kegP7n3hikaTEnyndqnudw8vSp+d04KbKjbqaE0lWPnCqnCmDXh1n/Mubrue/ZD5C5BerM9ChAFz9OYTG8xYIP8FCz4aE1cHK2+6+nGfrMLBqAbfJqXSt4y5oXiWR+dIgAzGskAHe/8FMlSBtlBxTz+1UhfYJWpA4OS8+2GVU+J1MkSDRJM++wSM0W4aCdaKMSK7yrtiGVCWLNBXZOQOJ8SoVjn6446zk0WWnqi6RCi8Bxk81hOXwXJgnHYbVotPpX10TR4tj0r8k32DQPGUW1QW/VoMQHTfLzSUi8nklI2dpMpQNWDce6MyHrZGXyMYLDmo8Y60jge+olgc2k2AdWzE5KNdxy/AU9deLvEFBOS127K7DyrIYgBr31OaFFMxSHPuVLbRnmiCRsA+3d4QATWbPbhc6LnhRwaLi6FcN9xh8M3BpTzspX/aVUhjxfuQZ6LfHMFsOSbb2lmH3XxR+cR6+KnaC3skH+/ztap6q4JnWhtb4Hh3coiXrCYotXvfJYb830/nb31vPYBT0+/Z9biQeBxJN0ArkqweutL87svrHfGGNV5odkq3YFsJ/haOHg/45KryW6bcwH+ayxap8ihA1ng0eIyDz7cRFd05NUoCcPYrNv/nEVo6dmKdrRs+slJ6b6vW7ae+q8HZpjdzSyPxV03evlxlLdmvknh3CdZ8aaV5fdJ9MUAkx8ZET9ZOISOrs7TqJzl09UT2BBG+mVqNC+ZmXx9oqB2FfJdpFUiZJK2Em789+H/IdRw0yCk/jI2Apk2q+3ARvnu8m/S5mObFU5nSbgbBH0rLCPp3sD+ibGhhCbHyZP1Z
 ncK+2MX0
 3DzlwlRtxQUDZA0yM5ut7C5BmTls+YgmO0XRlQ2g6qHrzdHQFt/CAgSCDzRAu+bh2gLKe/a63Dz1FIkyJ8ROfITOl19KT74pTSBdnLllCkd+5YcRPgLTWUhf6XOEQ2L4q96I0i/jYp0UU4R22G0TqMpa2A6SV7jbwo/BHEake6UWtQduRA2QuZp9np2+pMWplBXWPtDH8VH6phaCPKQFbuFVQZCvQNujTNaO1jYfk0wJPEpYki8dOr+dNfOSvyByDox8sFmml3pdB8/FCN9DIa440JU6NpNLK/ZMzfB7m/rLFTz0f4RqeCeZss0tCwkHWLt7q4ySx7YJY5aEjA089Xgl13Ao5B3j1ZvOSIJQkG4gdBogKhoXW497wkx2yYFfcd6pE2LiWcI10mMV2HAaQ7tOeqwJF1ddHT81PTkAnDeQpL88v79+HyWii/hKDiLXXE7gLCVUpQhrlpmI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 05:19:11PM +1100, Alistair Popple wrote:
> On 2026-02-22 at 19:48 +1100, Gregory Price <gourry@gourry.net> wrote...
> 
> Based on our discussion at LPC I believe one of the primary motivators here was
> to re-use the existing mm buddy allocator rather than writing your own. I remain
> to be convinced that alone is justification enough for doing all this - DRM for
> example already has quite a nice standalone buddy allocator (drm_buddy.c) that
> could presumably be used, or adapted for use, by any device driver.
>
> The interesting part of this series (which I have skimmed but not read in
> detail) is how device memory gets exposed to userspace - this is something that
> existing ZONE_DEVICE implementations don't address, instead leaving it up to
> drivers and associated userspace stacks to deal with allocation, migration, etc.
> 

I agree that buddy-access alone is insufficient justification, it
started off that way - but if you want mempolicy/NUMA UAPI access,
it turns into "Re-use all of MM" - and that means using the buddy.

I also expected ZONE_DEVICE vs NODE_DATA to be the primary discussion,

I raise replacing it as a thought experiment, but not the proposal.

The idea that drm/ is going to switch to private nodes is outside the
realm of reality, but part of that is because of years of infrastructure
built on the assumption that re-using mm/ is infeasible.

But, lets talk about DEVICE_COHERENT

---

DEVICE_COHERENT is the odd-man out among ZONE_DEVICE modes. The others
use softleaf entries and don't allow direct mappings.

(DEVICE_PRIVATE sort of does if you squint, but you can also view that
 a bit like PROT_NONE or read-only controls to force migrations).

If you take DEVICE_COHERENT and:

- Move pgmap out of the struct page (page_ext, NODE_DATA, etc) to free
  the LRU list_head
- Put pages in the buddy (free lists, watermarks, managed_pages) or add
  pgmap->device_alloc() at every allocation callsite / buddy hook
- Add LRU support (aging, reclaim, compaction)
- Add isolated gating (new GFP flag and adjusted zonelist filtering)
- Add new dev_pagemap_ops callbacks for the various mm/ features
- Audit evey folio_is_zone_device() to distinguish zone device modes

... you've built N_MEMORY_PRIVATE inside ZONE_DEVICE. Except now
page_zone(page) returns ZONE_DEVICE - so you inherit the wrong
defaults at every existing ZONE_DEVICE check. 

Skip-sites become things to opt-out of instead of opting into.

You just end up with

if (folio_is_zone_device(folio))
    if (folio_is_my_special_zone_device())
    else ....

and this just generalizes to

if (folio_is_private_managed(folio))
    folio_managed_my_hooked_operation()

So you get the same code, but have added more complexity to ZONE_DEVICE.

I don't think that's needed if we just recognize ZONE is the wrong
abstraction to be operating on.

Honestly, even ZONE_MOVABLE becomes pointless with N_MEMORY_PRIVATE
if you disallow longterm pinning - because the managing service handles
allocations (it has to inject GFP_PRIVATE to get access) or selectively
enables the mm/ services it knows are safe (mempolicy).

Even if you allow longterm pinning, if your service controls what does
the pinning it can still be reclaimable - just manually (killing
processes) instead of letting hotplug do it via migration.

If your service only allocates movable pages - your ZONE_NORMAL is
effectively ZONE_MOVABLE.  

In some cases we use ZONE_MOVABLE to prevent the kernel from allocating
memory onto devices (like CXL).  This means struct page is forced to
take up DRAM or use memmap_on_memory - meaning you lose high-value
capacity or sacrifice contiguity (less huge page support).

This entire problem can evaporate if you can just use ZONE_NORMAL.

There are a lot of benefits to just re-using the buddy like this.

Zones are the wrong abstraction and cause more problems.

> >   free_folio           - mirrors ZONE_DEVICE's
> >   folio_split          - mirrors ZONE_DEVICE's
> >   migrate_to           - ... same as ZONE_DEVICE
> >   handle_fault         - mirrors the ZONE_DEVICE ...
> >   memory_failure       - parallels memory_failure_dev_pagemap(),
> 
> One does not have to squint too hard to see that the above is not so different
> from what ZONE_DEVICE provides today via dev_pagemap_ops(). So I think I think
> it would be worth outlining why the existing ZONE_DEVICE mechanism can't be
> extended to provide these kind of services.
> 
> This seems to add a bunch of code just to use NODE_DATA instead of page->pgmap,
> without really explaining why just extending dev_pagemap_ops wouldn't work. The
> obvious reason is that if you want to support things like reclaim, compaction,
> etc. these pages need to be on the LRU, which is a little bit hard when that
> field is also used by the pgmap pointer for ZONE_DEVICE pages.
> 

You don't have to squint because it was deliberate :]

The callback similarity is the feature - they're the same logical
operations.  The difference is the direction of the defaults.

Extending ZONE_DEVICE into these areas requires the same set of hooks,
plus distinguishing "old ZONE_DEVICE" from "new ZONE_DEVICE".

Where there are new injection sites, it's because ZONE_DEVICE opts
out of ever touching that code in some other silently implied way.

For example, reclaim/compaction doesn't run because ZONE_DEVICE doesn't
add to managed_pages (among other reasons).

You'd have to go figure out how to hack those things into ZONE_DEVICE 
*and then* opt every *other* ZONE_DEVICE mode *back out*.

So you still end up with something like this anyway:

static inline bool folio_managed_handle_fault(struct folio *folio,
                                              struct vm_fault *vmf,
                                              enum pgtable_level level,
                                              vm_fault_t *ret)
{
        /* Zone device pages use swap entries; handled in do_swap_page */
        if (folio_is_zone_device(folio))
                return false;

        if (folio_is_private_node(folio))
		...
        return false;
}


> example page_ext could be used.  Or I hear struct page may go away in place of
> folios any day now, so maybe that gives us space for both :-)
> 

If NUMA is the interface we want, then NODE_DATA is the right direction
regardless of struct page's future or what zone it lives in.

There's no reason to keep per-page pgmap w/ device-to-node mappings.

You can have one driver manage multiple devices with the same numa node
if it uses the same owner context (PFN already differentiates devices).

The existing code allows for this.

> The above also looks pretty similar to the existing ZONE_DEVICE methods for
> doing this which is another reason to argue for just building up the feature set
> of the existing boondoggle rather than adding another thingymebob.
>
> It seems the key thing we are looking for is:
> 
> 1) A userspace API to allocate/manage device memory (ie. move_pages(), mbind(),
> etc.)
> 
> 2) Allowing reclaim/LRU list processing of device memory.
> 
> From my perspective both of these are interesting and I look forward to the
> discussion (hopefully I can make it to LSFMM). Mostly I'm interested in the
> implementation as this does on the surface seem to sprinkle around and duplicate
> a lot of hooks similar to what ZONE_DEVICE already provides.
> 

On (1): ZONE_DEVICE NUMA UAPI is harder than it looks from the surface

Much of the kernel mm/ infrastructure is written on top of the buddy and
expects N_MEMORY to be the sole arbiter of "Where to Acquire Pages".

Mempolicy depends on:
   - Buddy support or a new alloc hook around the buddy

   - Migration support (mbind() after allocation migrates)
     - Migration also deeply assumes buddy and LRU support

   - Changing validations on node states
     - mempolicy checks N_MEMORY membership, so you have to hack
       N_MEMORY onto ZONE_DEVICE
       (or teach it about a new node state... N_MEMORY_PRIVATE)


Getting mempolicy to work with N_MEMORY_PRIVATE amounts to adding 2
lines of code in vma_alloc_folio_noprof:

struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
                                     struct vm_area_struct *vma,
				     unsigned long addr)
{
        if (pol->flags & MPOL_F_PRIVATE)
                gfp |= __GFP_PRIVATE;

        folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
	/* Woo! I faulted a DEVICE PAGE! */
}

But this requires the pages to be managed by the buddy.

The rest of the mempolicy support is around keeping sane nodemasks when
things like cpuset.mems rebinds occur and validating you don't end up
with private nodes that don't support mempolicy in your nodemask.

You have to do all of this anyway, but with the added bonus of fighting
with the overloaded nature of ZONE_DEVICE at every step.

==========

On (2): Assume you solve LRU. 

Zone Device has no free lists, managed_pages, or watermarks.

kswapd can't run, compaction has no targets, vmscan's pressure model
doesn't function.  These all come for free when the pages are
buddy-managed on a real zone.  Why re-invent the wheel?

==========

So you really have two options here:

a) Put pages in the buddy, or

b) Add pgmap->device_alloc() callbacks at every allocation site that
   could target a node:
     - vma_alloc_folio
     - alloc_migration_target
     - alloc_demote_folio
     - alloc_pages_node
     - alloc_contig_pages
     - list goes on

Or more likely - hooking get_page_from_freelist.  Which at that
point... just use the buddy?  You're already deep in the hot path.

> 
> For basic allocation I agree this is the case. But there's no reason some device
> allocator library couldn't be written. Or in fact as pointed out above reuse the
> already existing one in drm_buddy.c.  So would be interested to hear arguments
> for why allocation has to be done by the mm allocator and/or why an allocation
> library wouldn't work here given DRM already has them.
> 

Using the buddy underpins the rest of mm/ services we want to re-use.

That's basically it.  Otherwise you have to inject hooks into every
surface that touches the buddy...

... or in the buddy (get_page_from_freelist), at which point why not
just use the buddy?

~Gregory

