Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A5CCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856F06B0005; Thu,  4 Jun 2026 08:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E086B0088; Thu,  4 Jun 2026 08:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7445E6B008A; Thu,  4 Jun 2026 08:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 645176B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:18:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB8161406D7
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:18:51 +0000 (UTC)
X-FDA: 84842134062.21.65FAC18
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id C553380004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:18:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DHzNzStG;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780575530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pv1Oyz2SuibchEQ+somLIZ/UIk84PCQQ/cJhhIFylGE=;
	b=f6wHg5PiaTmPvYOaHEXg7GzQAj3wfC3oxdOtmART+paKJRtCO2XT2pqxIrKccXF8/L8evb
	NDHjcL0EEsSPWgcr8LNHpKCbQENxIydBr8t+Y0v/i3zCx8vV1xE+HQcdDdO0zk4oMesRUz
	OF7o0UdUJTxgLhDFq4I6Gn7D/EpcFLE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DHzNzStG;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780575530;
	b=26WlYgFoei+6caI1G92eHqdc6TSLJkiDVKPqJ9y0iz7nx417mU7E+Yk+9rupR91GSf5Mb7
	rygIpb4xBy6GP/alNbZ70dXAO9XCAz0akv4jB/ebzlYd5r6EGPdIefwpsnAg6+1qXtylWv
	s5D86igqf3DFKK1GS0xlmbrPAlXF5gw=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b8a97b11so7714665e9.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 05:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780575528; x=1781180328; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pv1Oyz2SuibchEQ+somLIZ/UIk84PCQQ/cJhhIFylGE=;
        b=DHzNzStGiaofkV35lGYkIaLVYazKzi8lso3ar1i4Yyqz2jfMDIgbgk6GgFQ4oTnp3t
         9IRwnSP0eLPGdrru4/AwdGJ0OeHaoox62Bx4tkc8rg1B5WOzFwxWGZml5wKCphxfQVM4
         BEGgTJosGIyDZQACr5R7dGQokmv5FTQ0J+xwxmNxIyzohxbTqxXQCTgELpGFCTmZTPin
         TI0MPBzPgl61Aop7jz4dCQ2dZsAhKtrICse8dDdg/W2OLLnRibxH4SyKCSa0t0zMaNqL
         B7joXCgb26bEbnAIw6kEH6U68knJv1GFkaE2XJPrK+5c5JeSETW4i87KeI7pM0bnZu3k
         JLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780575528; x=1781180328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pv1Oyz2SuibchEQ+somLIZ/UIk84PCQQ/cJhhIFylGE=;
        b=nyIqFWYluJX1J6TqIQ6cJm7t/QS4eLJICd7HLa+JjAKlv62cdBYUnvYEBRFzKuqjSi
         /OOSvOquZyeFq2QHMLidin/llHyPRr9rQhxW6N6wep/kGdxgEGzU+eZ327wk4w3MnSId
         vP1lizrUD61HB6EJGksZ4JfXLx4Ok6nsmT+Pv1j+kmHj9n6QfpKQC5aOshlNPGMg+jOC
         D7Ikxhol6v12DcZgvMeGw+NedZpXyY7WEvWN3rIpVHsestZxeWcU6CT5GQRCmNdiOwY5
         kVUR5bJ0g5enXcATIq7vTOboBPQ8FwcCY1k6Pbccd2VZS2LBM4dQBxhnmiM/bnmOVX0E
         4rNQ==
X-Forwarded-Encrypted: i=1; AFNElJ/uVVgnVuC5Tx9+ERrfw3bCxl62K/9MD4wCSF5XtffGP7IOpqi/Cv09ca/h7+lPh4P4Z4aL091yTg==@kvack.org
X-Gm-Message-State: AOJu0Yy8DZbra0G3oj3mlnYGS+4LQDBndQMbBQbFPPv208na3tVwWRKC
	rRfHR8H5FfDBdi7y1Ua2exd8Z0ITnpac/W0fsQ9rRbX7KRhz5tDVKJ9GFU9kU7848kk=
X-Gm-Gg: Acq92OEa4ELKG0MZl+tdGA1j6qttpqKyAzOJLP4o9uomFXlUmom96GmJwaMCTfaXEr7
	xi1FVKdu0zMKC59DiJRrK190yJKh0QvBEluZyhud+/V9IPV0nSAM/TPuIMR4oasN2Sn5Ywi+utz
	mzhNrSjHbQHs9+AURzXXuYxIV3kj4W95Q/2QH4wvUZU/pSfz2U3UZlL3vBcSxsv7HFGKoMObzUB
	vx32MPo0TbFI/y+1Wmm34TUnzEgpyJw5vVp8ztbLCD7VCx1cpc7FkVNtj4gKMubbCTcZNx+KHFs
	TWewcHiw2b51bzST715Uw1wxO6c0peaSUfnu8Upq6wl68UE6o67KLiycN+8qf5JGZ3xto1+nIoL
	vyxwKkJd6nY/AftbAV7nZkjgWq0W+rM4uWIzXBDk3NaJnIaczj5Lo2gLTvqisfcAyw+1u1Ii6M9
	OxC0WjjGDiTwxYp6Or/aqpDLF2jUxynxM=
X-Received: by 2002:a05:600c:4043:b0:490:b2a6:8c2a with SMTP id 5b1f17b1804b1-490b5e748e3mr78263665e9.5.1780575527855;
        Thu, 04 Jun 2026 05:18:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::7:a76c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc140sm81382665e9.9.2026.06.04.05.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 05:18:47 -0700 (PDT)
Date: Thu, 4 Jun 2026 13:18:44 +0100
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
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
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
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
Message-ID: <aiFtJFqkpbZ9qFvM@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <ah_RcTU8SpQG7hab@gourry-fedora-PF4VCD3F>
 <aiDVMgu0viTIml8H@parvat>
 <aiE5DZC8Io4SNI3H@gourry-fedora-PF4VCD3F>
 <aiFSZfRlFPd7qlIw@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiFSZfRlFPd7qlIw@parvat>
X-Rspamd-Queue-Id: C553380004
X-Rspam-User: 
X-Stat-Signature: szz7catyo7eyxao4ujhrrdn5a63cm6fn
X-Rspamd-Server: rspam09
X-HE-Tag: 1780575529-261384
X-HE-Meta: U2FsdGVkX1/73jVpHDuFroHQzlSpv9TH3SSB4l3XtImZAyeP7Y65/TBCjFcagSgofOfmWpOZq2p6pXVytLPOEYBmHoj1SSznbiqJSZqMQ9WNKLRzQ5pHFAl/LekfurTeto3ZpvL73bJTIRSHaSbxXaYluhYZKeBs9xEi01EjQg5jtvoTiwyCLDcHvJwyS2EmNpUKUj63VOOpcczBj91FU2MYpygdVo1o/MAMC7fIv3+IaBVozC78c2Byhi2kIO+g45uPaIXn5wnZLSTNH7aPxnFuu99ZdouJf6JSNgi7gX68PF/8hMgbKkJLfc0N+fy2Lp16TlXuFQJNOIl5YuytEsLHKFixqx9BQOMhaFPjDtumm6+cbgaZuZB/9CicyjqjoX3p6TczdhqCK37Utzyli/xjwJ08CLtr8oCnT+g4rQLDcnBcjbQCwRDNeVxu88Gq3iYC2l58NepTJj0XSqHYHpLoKH0Op28XqlW8qLJhR/vRixUbsesVhqTeQTU+ziEIknzEg1WqkSRK4/3M45KWktrC29nJXlxNILqs0gT0SL3Kzy60tJWsTVoNYgWIND7IggjQPSV/d84SElRcHHMbnB1jNhRS5tr0aemB0qVZSDthikoQCUnq9m3Yzuv3HlOILXmoRyePp4KAtsRlyp0D+kRp19uJyMu41Mx9Qb6cFHIUlE4st5DGQC/TSZvh9ITm3C7coM+h/QhGbpZyvgxuJkGWs6JIVpHNBCjhGXrWoVkFFbjNagwhZzprtGfjsg36vZbL6YdDJxDK0wVLlGg/IIILCHEZg0ZiSr+mt717yChQvv3NNmk1XtsFjAoIDprXW1pDWVnTyP+TODN4VgSLjjaMD54AlSjWwtHE08E5JX87Gdl9htMdfyW+4SvyLQPMbZNaCxIgKYaMQhxw7fXGjefYJoND0LFKgEkUHnA3jEcaaXjCxg7PriNsNZUwMyIO+xJT6132ta4lAbmbatt
 hYGqMmlS
 xcG6WGdqNp51VIs2M5sG6YcMMclXEXekVoy3S7J1uCU3c5aJhLtnqJyyzyhr0BQJrcHF9LZ6pzKrvNUXOeDrUTlaLsClag4wnhVfiIvIOHRskQRnaVAObQ//hz/XNAgOhcs/lD9PeWY4eQPBpqgYO4iVOwllMdskjIsqrxOJauLJ1SFDZzVnjTYxwCyTJ0X3WbLDwgzHnzjQHJTQ0+eKEwprelMhrbU5UbagKtDChO/dSpKB7kOiVmrdVb7QMm7Wrbe9SIev+9tThlcZqeeOBixQelurUh/9hj3D0LpirRzDtQI9Uvy9meKqswrez3G7qZZvGb4dsonoSbMXGmUbxz0tKvVUdolfrnSb1nZdRIIPeCRKx6WrRU0YL7W2QNrj+X5byqvlnEJspY9uYuE4asA5DqFly4bRGTde+EPlwWsiG5MT0a0wtIzYpPscMU8JS4oAR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 08:35:19PM +1000, Balbir Singh wrote:
> 
> My concern is that __GFP_PRIVATE is too wide, I wonder if we'll have a
> need to support N_MEMORY_PRIVATE may not be all homogeneous memory nodes.
> Very similar to how not all ZONE_DEVICE memory is homogenous.
>

Can you more precise about your definition of homogeneous here?

Are you saying not all memory on a private node will be homogeneous?
   While possible, I would argue that you should not do this and
   should instead prefer to use multiple nodes - 1 per memory class.

Are you saying not all private nodes will be homogenous?
   I don't see the issue with this.

> > 
> > Agreed, but also one which can be deferred and played with since it's
> > all kernel-internal.  None of this should have UAPI implications, and we
> > need need to accept that we're going to get it wrong on the first try.
> > 
> 
> Agreed that we might get the design wrong, until we fix it up. I feel
> that __GFP_PRIVATE should be an evolution of the design to that point.
>

Possibly.  If we can't guarantee isolation without __GFP_PRIVATE, then
we probably can't merge the baseline without it.

> > Because pagecache pages are associated with potentially many VMAs.
> > 
> > The fault can be a soft fault or a hard fault.  On soft fault - the page
> > was already present, and will simply fault into VMA without being
> > migrated.
> > 
> 
> Let's split this into two:
> 
> 1. unmapped page cache is never impacted by mempolicy and should not
>    end up on private memory nodes
> 2. For shared pages, mempolicy would be hard, but it would need to
>    be on a set of nodes backed by private memory, depending on mbind()
>    policy
>
... snip ...
> 
> I'd need to think more about this. For now, my basic requirement would
> be that unmapped page cache should not come from/to private nodes.
> 

This does not fully describe the problem.

A file can be opened and cached as unmapped page cache, and then mapped
at a later time - at which point the mapped copy would share the filemap
page cache page.

Worse, because it's file-backed, you can have the memory faulted onto
your remote node - reclaimed - and the faulted back in via the process
accessing the file via unmapped operations (read/write), at which point
you've had a silent migration occur.

Basically consider

Process A:
   fd = open("myfile", ..., RO);
   read(fd, ...);  /* mm/filemap.c fills page cache */

Process B:
   fd = open("myfile", ...);
   mem = mmap(fd, ...);
   mbind(mem, ..., private_node);
   for page in mem:
       int tmp = mem[page]; /* fault into vma */

The result of Process A running first is Process B thinks it has faulted
the memory onto private_node, but in reality it's taking soft faults and
just getting the filemap folio mapped in.

If you wanted mbind() support from the start, we would have to limit
applicability to anon memory only.

Shared anon memory is different, as there is a radix tree that deals
with a shared mempolicy state.

> 
> I am open to this, I was coming from the blueprint approach of:
> - Let's mimic N_MEMORY with N_MEMORY_PRIVATE and then pick and choose
>   what features to change or make specific to the implementation
>

N_MEMORY essentially states:
	"This is normal memory touch it however you like"

N_MEMORY_PRIVATE (_MANAGED, w/e) says
	"This is NOT normal memory, there are special rules here"

So, no, lets not mimic N_MEMORY.  This is a "closed by default" design,
while N_MEMORY is an "open by default" design.  This design choice is
explicit to make reasoning about these nodes feasible.

> > This is informed by a single use case / device.
> > 
> > There are users / devices that don't want any UAPI for their memory,
> > but simply wish to re-utilize some subsection of mm/ (page_alloc,
> > reclaim, etc).
> > 
> 
> But then, why do they need NUMA nodes? Do we have a list of use cases?
>

So far i have collected:

- Network accelerators carrying their own memory for message buffers
- GPUs with semi-general-purpose working memory across coherent links
- Acceptionally slow distributed memory that you do not want fallback
  allocations to (so you want to deliberately tier what lands there)
- Compressed memory (just another form of accelerator really) which
  has *special access rules* (i.e. writes need to be controlled)

In most if not all of these cases, the right abstraction to reason about
where memory *should come from* IS a NUMA node.

- the network stack can be taught to check if the target device has a
  node with memory and prefer that node over local memory

- accelerators can be given private nodes to manage memory using
  core mm/ components, without worrying that general kernel operation
  will put unrelated memory on those nodes or do things like migrate
  your pages out from under you (unless your driver/service requested
  that).

the tiering application should be somewhat obvious / trivial.

> > 
> > I am trying to test whether, lacking __GFP_PRIVATE, any normal runtime
> > operations access private nodes removed from fallback lists are reached
> > via something like the possible / online nodemask.
> > 
> > I remember, maybe a year ago, there were per-node allocations happening
> > during hotplug and that's why I originally proposed __GFP_PRIVATE, but
> > I'm trying to re-collect that data now.
> > 
> 
> Thanks, I look forward to the next set of patches. Let me know if I
> can help test what's on the list or if you want me to wait for the next
> round
>

Really I want to get the minimized set out the door so we can start
breaking this up by feature (reclaim, mempolicy, etc), because trying to
reason about it as a whole is infeasible - and I cannot be the single
arbiter of every use case (I simply do not have sufficient context).

I'm reworking it all as we speak.

~Gregory

