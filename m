Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75797F433D4
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B243B6B0005; Wed, 15 Apr 2026 21:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5566B0088; Wed, 15 Apr 2026 21:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4356B008A; Wed, 15 Apr 2026 21:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB216B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:25:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B7551A0744
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:25:05 +0000 (UTC)
X-FDA: 84662675370.04.88E94E3
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 52211180004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:25:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VXTOvnYo;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776302703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0GVcI8Mcl8O7u/nlxfa5xhicBajYIQOeBkH2STJXfY=;
	b=wq9RLEVfIhV5JW1rV4SV6P/J1wl1oSrVCMn98JqFs2yKDTFnWQX6FzEDUZlECNG5hTusjP
	BpYxRXc/OQiOhvmd4GNdhn+FZxhfp/l534WykCEk0myLrGJM/goqtcsQdq8juX05JNy0ds
	GwHnQ6j732IHK4bRDeD0lT0Y1ehjGGw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VXTOvnYo;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776302703; a=rsa-sha256;
	cv=none;
	b=JjKWKNHYQolovIrjs+3n6zuaQ7Htw8mXWGvlBd5iBFeeyXOsSxmFDZFbVlba5QUABGAMuu
	jN1IO/h3yBEoudTjBpU53JKLs0ttMdKymWkLa30LF+E0gmFhjBkFOH7NqgG4DwyJO+58Ep
	MzY+xX4Wy+beRgbHheu9fpL4O6sHvaI=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50d880e6fbbso2000221cf.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776302702; x=1776907502; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L0GVcI8Mcl8O7u/nlxfa5xhicBajYIQOeBkH2STJXfY=;
        b=VXTOvnYoKMYdHSxLEL95g9Mw2463sKY+gUJWNE/sEnUrL7KP3u4lRxetG8OPtvSKu2
         f4CQykHTKJrB45kNZx2uocdZZ9QZlgLKrxB/2DNtWAUPhMYBiYtHYRVP9+tIYGGDN15m
         G7G+jEbW/UUMLMJ7+/ND4clHRAxu0L5asLtA/R2e0HMrLo/Hgh2zI92Z9TFC3qdlivxN
         hv5NWu1wYpp7ihSab+REkk2CaQ43lGDUVAFkn21+CWtoFCQwWG9T7KcL1tAwiFKRLDXt
         kBw4RWBm13Z/nDDIZHvsWfcPnubN3P6lC8TQG6NAO0IA0nLTx6IqXJhlFDTcXM7RYfmg
         tLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776302702; x=1776907502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L0GVcI8Mcl8O7u/nlxfa5xhicBajYIQOeBkH2STJXfY=;
        b=S1gNLRKKKYSVZHcAg250yZhb7fJVt7umpZZag2vfHe74UDs5yj/z8brdSN0mtyBwHP
         pXkxLcvxmRwYXlwxPkH+2uv2Aj5Kai61fkSZyn3WNTSORTDEMv15NS/0UpC2/d+AQ11O
         ItOLhpRNsF6xYa5Tceev2Npg0XA1xVz0bX/LWci7o0s2pYlVK5w3D308B9ZHyrmlPdWK
         qzbLmTBqGDvfuLjSdfrFU2vsFhILXfGz0ySxXJruAYbEjR+JXAlxnKYQKgXUsbikff5A
         JFa3z+Iq6FdK0vo4c2P7XaMvBzAo7YkxaodaIm6j6U7NDxOCepgvdV4sfs91q+aw2fSi
         nOuw==
X-Forwarded-Encrypted: i=1; AFNElJ/budeS4c1mw951bu89UHXPYKlI9rSCbGk9ZPJtVC0kvnsNOcv22No66XqYCahXDTaDMNaPxzLWKQ==@kvack.org
X-Gm-Message-State: AOJu0YylYaY/kOZjwwhGYbEGDJoKP1ZKyQZwtKYQOdCoVgV/+v/iK2/3
	9pvuN2mhE/NxFFYAyV6m02jsQBriwFEwTAfc+SrIsbpWyKHb5oCqg14NsnbviPH14Lc=
X-Gm-Gg: AeBDieugVfFKYwXQp39GjIJi8EYVEf/0/XEVNGj6XYZh/ZDhT2zTz79XMir7arQjfrP
	ml5mROoYWKp2EqxO50SwpiE9vBpFIgmyfnKroGf4M6YT9Mk9bLN8U7JrG9k7RmjQicySNiEu4nK
	e+Xsnij3OaA76qzQGqyhP8ayU9q0m1flBlW0NLQ38No0rgOPPcHXAoBaQ2DT66TSYRfbf7nwfPZ
	iSH7zM44pAuYgqqjaZUIRCGUGlJbCTdgqydY5ZW0mbTeHwtD1JmbK1p4PNx2dJ/sKVWAt4SWreI
	/olohn9HCPcO7LYtjMEapTanTQTuE9+rPMnnub3W3YCpJDUa7rSdXWSCAqGrQj2ztBvOMYV1U5L
	uAqrYF2PFIQ1rbj+gLN52ONo735M8oEqx0zB4NYgLlzWO7Sa8BZVwfn0V12IN9OayI+wGbcCb5B
	yFnbthXVtwXdFtAyDy6Qjr4GFDJ53dwdy7B+0Ft6eLrWfnvTAl56Bz3kyWc2A9k7a9vfCuFiUKk
	i/2yDv7+ruOVW0osIQrWB0=
X-Received: by 2002:a05:622a:d1c:b0:509:1b5c:fe25 with SMTP id d75a77b69052e-50e24b8e774mr23717671cf.23.1776302702216;
        Wed, 15 Apr 2026 18:25:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-28-184-130.washdc.fios.verizon.net. [108.28.184.130])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1adbcf10sm24957831cf.10.2026.04.15.18.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 18:25:00 -0700 (PDT)
Date: Wed, 15 Apr 2026 21:24:56 -0400
From: Gregory Price <gourry@gourry.net>
To: Frank van der Linden <fvdl@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
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
Message-ID: <aeA6aNDpQ-U5UJCs@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
 <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
 <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
 <ad0iT4UWka3gMUpu@gourry-fedora-PF4VCD3F>
 <38cf52d1-32a8-462f-ac6a-8fad9d14c4f0@kernel.org>
 <ad-r7hwIdnvKsrh9@gourry-fedora-PF4VCD3F>
 <CAPTztWajm_JLpp9BjRcX=h72r25ELrXeGkOXVachybBxLJGS=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPTztWajm_JLpp9BjRcX=h72r25ELrXeGkOXVachybBxLJGS=g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 52211180004
X-Stat-Signature: frxzpy7ni64kfgxh334f1rqhenm9ic7t
X-HE-Tag: 1776302703-689590
X-HE-Meta: U2FsdGVkX1/r/GDY55yCFwxWbDNqHdBaRWvN0ISEnf4VoFdfaOVro8V5UkY68/lE3AzzeJQ4XHzBp9C41azu2+lVxCyZFGHUApcoNtmupp+5jPbH0GwoU1Chrbd4XRnXoPsVi/8p2VVn2k88k2a4b+BKb5O3qmPey6OI2MAyH45jDF+gxi93AV81qnIkNlyWf/ppwOhDxx2nD59VgU5qJGv2cmkVoclKmW9frKyaU1N2+3db/f3UQ7GFhhSFQg/vp6jU3A36r1nMpbK8na55jQfE6KkoRZM3cq+XUwX7+6xXtOAf+PbY+YwO9ZTOOmTeQLI4J5XOAvli9TsNLKhvKPV+F3if5eeKDvpYHQu61elJwXOLdyWkBIJBGj1w+XuLvu8IKAI2fobX2R4tI733WU7mL/vgCdjSzNZcf3kHpPgspoIWzCx4wbb1PTxyHF4uGSgwNgmB55pt0Pe343zXXcXVCL26LJIWKyGchZ5skBccc0jGyd7rbqV8X81EvnvkqHJPZNfdbpBQzGNxFBgZ1SWYHE7RkTvwe5gNuSCrArJiWkRNIjJ8HmbUg/aKGSCyq9dOj01Vhk+uzFzhBMN9oAa5BLakxgrdXoNd5Jqc2Ax89wngxUng7wwp+SCj3I4CqJVTyOfUarN/IQoh6xVE4HG+d8yRHrosEmaxE9qfncIZ74xrreAKljyNf1CNZEhZMNWabZMOFdvawm9VbBrazDTNSCPlUNPgND/bL92muaUtAC39pJPDQ1OrqAsqm/Qt0gNadSzZCFJ+Aw5uE/ntJSKWHrO/MZ+IwugntaB5MbcsrBQ3oC/Aw6imYGiw9Xtih4K1JRlVX80Fqe/DIKA38uIcAU1ZvrGT6/LzHnFSmxg602BmJuIakX+zXmctziYWYhbE/QuHN9jCKswsnGwnGOnqUX0cpiS+qQCScsll6aarp1mn/hk+zeT+SwDQsl16JAdLmmmDjLTEhzPyZ+2
 XYApvU9z
 mIJBufPwEfTCgHTsVQtafCC9kC107q8VBG6FGuu07gqtTW82+Bh9U8VxUPqPLwhwBg2/zXTFxtBR9JK1Sq3VqyQSkrJq5CUfxOQG3pIYVfqeirGds/2Z5QOVy7gwQaHpOAsxXFW7kp8ISJ+DtHl/qGZBiYVKqmjeS6/wbvFyQo8QHfnwJwIo9aC9u1tB9ssDWlwKbbQ9pu5OiLbRinN4Pl6U2mjDWtn4fjSVXWohPKW3hqB4+dex0SbZ3BKEsuVljF74zgRTiB7O9KP7sQSZ4wyyFlIsTdqEqH0z76d1HCScIMlYDjImU1eVlwCPXUHJRRR+ICPWeuLStl3FliHDpg6H4gc6SfSCvqw5ihTd9zX1Xx7ntJN7QJ3Q0gUSqTvOaTS7MJGdijMckW6YqP6+Brh2TIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 12:47:50PM -0700, Frank van der Linden wrote:
> 
> This has been a really great discussion. I just wanted to add a few
> points that I think I have mentioned in other forums, but not here.
> 
> In essence, this is a discussion about memory properties and the level
> at which they should be dealt with. Right now there are basically 3
> levels: pageblocks, zones and nodes. While these levels exist for good
> reasons, they also sometimes lead to issues. There's duplication of
> functionality. MIGRATE_CMA and ZONE_MOVABLE both implement the same
> basic property, but at different levels (attempts have been made to
> merge them, but it didn't work out).

I have made this observation as well.  ZONEs in particular are a bit
odd because they're somehow simultaneously too broad and too narrow in
terms of what they control and what they're used for.

1GB ZONE_MOVABLE HugeTLBFS Pages is an example weird carve-out, because
the memory is in ZONE_MOVABLE to help make 1GB allocations more
reliable, but 1GB movable pages were removed from the kernel because
they're not easily migrated (and therefore may block hot-unplug).

(Thankfully they're back now, so VMs can live on this memory :P)

So you have competing requirements, which suggests zone is the wrong
abstraction at some level - but it's what we've got.

> There's also memory with clashing
> properties inhabiting the same data structure: LRUs. Having strictly
> movable memory on the same LRU as unmovable memory is a mismatch. It
> leads to the well known problem of reclaim done in the name of an
> unmovable allocation attempt can be entirely pointless in the face of
> large amounts of ZONE_MOVABLE or MIGRATE_CMA memory: the anon LRU will
> be chock full of movable-only pages. Reclaiming them is useless for
> your allocation, and skipping them leads to locking up the system
> because you're holding on to the LRU lock a long time.
>

This is an interesting observation that should be solvable.

For example - i'm pretty sure mlock'd pages are on an unevictable LRU
for exactly this reason (to just skip scanning them during reclaim).

Which is a different pain point I have - since they're still migratable,
they could be demoted to make room for local hot pages.

> So, looking at having some properties set at the node level makes
> sense to me even in the non-device case. But perhaps that is out of
> scope for the initial discussion.
> 
> One use case that seems like a good match for private nodes is guest
> memory. Guest memory is special enough to want to allocate / maintain
> it separately, which is acknowledged by the introduction of
> guest_memfd.
> 
> I'm interested in enabling guest_memfd allocation from private nodes.
> I've been playing around with setting aside memory at boot, and
> assigning it to private nodes (one private node per physical NUMA
> node), and making it available to guest_memfd only. There are issues
> to be solved there, but the private node abstraction seems to fit
> well, and provides for useful hooks to manage guest memory.
> 

I have wondered about this use case, but I haven't really played with
guest_memfd to know what the implications are here, so it's nice to hear
someone is looking at this.  It will be nice to hear your input on where
the abstraction could be better.

> Some properties that I'm interested in for this use case:
> 
> 1) is the memory in the direct map or not? Should that be configurable
> for a private node? I know there are patches right now to remove
> memory from the direct map for guest_memfd, but what if there was a
> private node whose memory is not in the direct map by default?

Presuming a page was not in the direct map and it was in the buddy
(strong assumption here), there's a handful of things that would
straight up break:

  - init_on_alloc (post_alloc_hook) / __GFP_ZERO (clear_highpage)
  - init_on_free (free_pages_prepare)
  - kernel_poison_pages (accesses the page contents)
  - CONFIG_DEBUG_PAGEALLOC

But... these things seem eminently skippable based on a node attribute.

I think this could be done, but there is added concern about spewing
an ever increasing numbers of hooks throughout mm/ as the number of
attributes increase.

But in this case I think the contract would require that an NP_OPS_NOMAP
would have to be mutually exclusive with all other node attributes (too
many places that touch the mapping, it would be too fragile).

There's a few catches here though

  1) you lose the ability to zero out the page after allocation, so
     whatever is in the memory already is going into the guest.

     That seems problematic for a variety of reasons.

     I guess you can use kmap_local_page?
     But then why not just unmap after allocation?

     If never mapping is a hard requirement, if that memory lives on
     a device with a sanitize function, you maybe could massage kernel
     free-page-reporting to offload the zeroing without having the
     kernel map it - as long as you can take a delay after free before
     the page becomes available again.

  2) the current mempolicy guest_memfd patches would not apply because
     I can't see how OPS_MEMPOLICY & OPS_NOMAP co-exist.  A user program
     could call mbind(nomap_node) on a random VMA - and there would be
     kernel OOPS everywhere.

     That would just mean pre-setting the node backing for all
     guest_memfd VMAs, rather than using mbind().

Something like (cribbing from the memfd code with absolutely no
context, so there's a pile of assumptions being made here)

  struct kvm_create_guest_memfd {
        __u64 size;
        __u64 flags;
        __s32 numa_node;  /* Set at creation */
        __u32 pad;
        __u64 reserved[5];
  };

  #define GUEST_MEMFD_FLAG_NUMA_NODE    (1ULL << 2)

  if (gmem->flags & GUEST_MEMFD_FLAG_NUMA_NODE)
      folio = __folio_alloc(gfp | __GFP_PRIVATE, order,
                            gmem->numa_node, NULL);
  else
      /* existing mempolicy / default path */
      folio = __filemap_get_folio_mpol(...);

Which may even be preferable to the recently upstreamed pattern.

> 2) Default page size. devdax, a ZONE_DEVICE user, allows for memory
> setup on hotplug that initializes things with HVO-ed large pages.
> Could the page size be a property of the node? That would make it easy
> to hand out larger pages to guests.  Of course, if you use anything
> but 4k, the argument of 'we can use the general buddy allocator' goes
> out the window, unless it's made to deal with a per-node base page
> size.
> 

Per-node page sizes are probably a bridge too far, that's seems like
a change that would echo through most of the buddy infrastructure, not
just a few hooks to prevent certain interactions.

However, I also don't think this is a requirement.

I know there is some work to try to raise the max page order to allow
THP to support 1GB huge pages - if max size is a concern, there's hope.

On fragmentation though...

If the consumer of a private node only ever allocates a specific order
(order-9) - the buddy never fragments smaller than that (it maybe
spends time coalescing for no value, but it'll never fragment smaller).

So is the concern here that you want to guarantee a minimum page size
to deal with the fragmentation problem on normal general-purpose nodes,
or do you want to guarantee a minimum page size because you can't limit
the allocations to be of a base order?

i.e.: is limiting guest_memfd allocations on a private node to a single
order (or a minimum order? 2MB?) a feasible option?  (Pretend i know
very little about the guest_memfd specific memory management code).

~Gregory

