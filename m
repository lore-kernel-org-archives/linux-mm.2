Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 211541090237
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2896B04F6; Thu, 19 Mar 2026 11:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762F36B04F8; Thu, 19 Mar 2026 11:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A626B04F9; Thu, 19 Mar 2026 11:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF186B04F6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:09:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F33313B4D7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:09:55 +0000 (UTC)
X-FDA: 84563147550.06.2BE442B
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1FD724000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:09:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Zv5wOIyu;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773932993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fU4+lilPbMb3EqzTb9SzQ9ED33oth0C4b6/QPTs5sDk=;
	b=aQZoO6BWnvJpdioI6JPDSRELbqH8bNP7rq2FOKrtFv15zWUSdUKibgvEPrKoqead2lo1dv
	frWLz7QLdJCWOBCHExnZfbgR0KSLYhSJ5KKpS8YQ5mqZL9mxMvG+8qJqQkRSIKUSDmlrDU
	qJR01i0DaV1HHyfJWof1zY5pgjTPmAg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Zv5wOIyu;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773932993; a=rsa-sha256;
	cv=none;
	b=PJdEL1WH6GH6IrLPlDvPEYWn+AQm2PqD/YLwWeqch2NP8x9gn+oxonc6c752R9lj8vqMkG
	1FvhXT7tqM43myXMmD/Jw3GXkH77YbizBrxMlHJyduTK/D8WZyaTgKILgCqZZBJU2AuKlN
	wKwv83N/I+RbSizyN4MdPruVAfc514A=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd8d97aa2eso145779185a.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773932992; x=1774537792; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fU4+lilPbMb3EqzTb9SzQ9ED33oth0C4b6/QPTs5sDk=;
        b=Zv5wOIyuJtbhtpXFh4ijE+xb7wcNXMo/HK/7sTtpcbfi49kvx+Iv+ejgYCp4nzNrky
         f54ce+WjIt8GcVoGrB0aPVaGjuYNJzo8y8Kkpp9L7tlRo0FQXbj6TVLLzyIIZlrcDtFk
         vUW3vOZ72AGN9tXZUyrD6P8gaLiM2jfBXKelE4lvgD0qK8/1j2mjOwGzlWINDcYOHhfX
         toQpPf2qJG8re13xHloH2Lq6YWZo0jhzwvcmTBZOaUoQrkwuV7wzH4oNsy3zmybm03e/
         XgmAt3FwmvFiHVdlF5Zr18sZ4ieU9gXBsFhNgXKImA2vkn3YwwCTTBp1hIPqKHOVCDLL
         RAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773932992; x=1774537792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fU4+lilPbMb3EqzTb9SzQ9ED33oth0C4b6/QPTs5sDk=;
        b=he6heQvJYl4ErpAxO4GesAPA851QVrq4DhiiIHLi/rVUdQvDBLkCg134jXWsO9P+eY
         8GDs1v0ao1zO4vg1fiNVawDaqjJoob7b7IC8tzUd+9TUzMaqNbkj/r7E8PFz5R/AadYA
         yiCieqYtXZ+XiAs79T9zolRTe1vGlHQofCdRQlB6QMRtzMIgabkJZ2TI/apQBRkELdjT
         eKEVGWqrSP8Pe0PEoMgUiCiw2IPeAn5lR3merAtnSmapyjhI9YJKPfusIk6qK93QU1sf
         6RpYe2aS2qHxbyvL4IIhRMCXS+tU37AGzZUZezvUhPAntmwnJHBo930f66c1k7j2eseP
         Tv6A==
X-Forwarded-Encrypted: i=1; AJvYcCVTXJqToJWRKUZOCFZkOmkMlRGkwIt+NoJXEO9dfBeNw/k0lTsZDit60eUUDC6q/mMt2Or74iItyQ==@kvack.org
X-Gm-Message-State: AOJu0YyA2u2RQ02DoctjPqqknDGM3H9TDV+EH/JQ00epR0EM9BHZlG/2
	YpSn+wyuYvJZrDGgyRDPWDqt06wRj8bv+y39p6p4TcFLsfiqKiKPVuF/16uoTNi6jDU=
X-Gm-Gg: ATEYQzxPY6qclvlQenjoxmiqw4hY33msiFeLcchBlCcPlAvwzCT1AwLQEgCb6GaZIbg
	GPTzOza+6ejDBUU/a0rVqkVXBZ/bSijoXal7KxYMVr+F+trXd5jRXQO5o9D7Ysnomg5CY5vg7ay
	/nFhZpGIlU8lMGeg5O+X5WBDRhnsm5xD+EBa9cDZVm+kK/GXiamIDbg51lIs3GaPW1UGAiEk9Qr
	73QB2iRb6XeXo7xLPkmx9Ijv8sFLb+cJOb8SK0uKKvaHuYeGUUTvNSHPhETDjaK4ibOWWcpkJmd
	yLsD+/l4bWqpR4woMkqlqZ4fOoaW3PcVzcnIISImm4cyxGP2rjPWUnDq7xa9BtOjGXhhfL/MvvQ
	1htOOgIOvWUcXLSE6bBEIM1lizX6jfPm3E17Lz4KwDREJ68wME6OUzoPkeszNUse871Ap4agBSu
	s6mmE/RR7GVNbbQe71QxCBsci8/d7YGptGsEiyeEV4qtb2tMLXILKyp0yfxzSv77PFMGYOkpdah
	gW0gjnM8g==
X-Received: by 2002:a05:620a:4050:b0:8cd:af31:b421 with SMTP id af79cd13be357-8cfad2c5236mr1047066785a.34.1773932991754;
        Thu, 19 Mar 2026 08:09:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfad1b1154sm524775785a.35.2026.03.19.08.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 08:09:51 -0700 (PDT)
Date: Thu, 19 Mar 2026 11:09:47 -0400
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
Message-ID: <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
X-Stat-Signature: woozt8pfsfao77m8qm5qurbducyihcj1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FD724000C
X-HE-Tag: 1773932992-812590
X-HE-Meta: U2FsdGVkX1+8YgcT7q13uTSguFDTb4QZ6AT7dnPr/kE8gFt8IZcP8UVzkw1OJ1aRfYuXSHleA9Q04oyBpNyBsXjc3p5wjKqQc7LihCsUKAHfF2H6SNihf0LhlGOthsF5N0vhhUu6xktuxQybVh8ox86vSugo7WBob7+G0ul5XY7hsC4EYw2xVmLG4NyzxSb+5x7tN0Uc0jxsxTey3vVGTfHVLzqq9nnQkr8PjZLry0FTIUYa1vWFibgSVFZIcWXk2h8hDs9ppHg9L1y6/yA5xzK3TNPu4NzPlaBuIRwdnCmzPxOdVVpetwz9rIPoCZIsHHqjGXwNCP092LxaXTcIhcxw0I/LV1oAbPhAKswVHaGcXHomELBz+++dWAdZo40vpE59gzbH6vWD/WPYXbkoU2lCoI3AdzyvdG/w1dlWJ8SLP4Lo6f5/p25lWKe1esXK5WulMVsu9CsjvVCLEY44efldcEuEncfyDmlkWbQwsvDbr7Y/cqOT1N0T/kpdEFVYT0dJqOjHtmbyo+o3/gjCg2BdwvdCcFgMwRswQRxCpDnWO2xJDzrI3338L8YOsPBlc0YqXlTj7t22r7nzlkLo8LBNM1GsotGYc5L0n1uGDyvRaknm3d0XsJOOupXYAQOyOUxEq5oPjaxt/N1QnBS49iQNAa7yQCOqzbPhpMI80YRU+6INTZiIJp2GP4L9OQDiEl9grFWonZqzBFHmOTX0NW4roKQGL+8IQe66GL+8vZs2MCBMu39n2CNJIh3B9tChmxwR6OtFKoJ/AN2RGBNhDoeH9gak+1LKqui6UngsFTMdZiLop+Hm/8QoTIDKe2oRyllyrI9LgUdPIquSYzrJZH8lFNa8Gu9Xj+ZZQwL4DeUfF5GSdoqoY0neasPqsywxWr9ztrkm8q+WUx8Z0JHFsjiSQjZBKgdIdYtXoYsa1pLzOiEfnAiRc/F0aY4hNLyAPcL2FhnkdGCXQKsHUtc
 mm43wFPP
 pZfjFo1EeGQAmD7fytGDC7AQbdif+PVnKJkJKgt2NrLyBa490VmeHHFrE0Kl/zoVHi0ocgt4ecgVcomqVksJE8+y2t3N00bcER1NXJ/wGT162LHNQTUZ6YgrfnG29+3J3Xu+AEdjylrvQva1l+ZjrncJHSKFev3IWFiT3ST+jFoGICpkmLERnu2N4gTFqlvbH2A1VNB/9CyNZgT7hTC5C/3fRUj8AIOPijom4+2EkHvmpIImS7Hc7dub3cWukhVoabmlpdua2oVh36id5RlYRyMfi8cr9o61qVKaurlXTJa5wR5LiWQKKSA3xkU3yx9CJqmp8/WqhSUX8pp1xJMCTCGbqgM5H9U/I1vyqTmFwHS4n6+g++flSYrZJn8LaODEAxG+eC6eEZRwC+gJsOj4b3f7TmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 02:25:29PM +0100, David Hildenbrand (Arm) wrote:
> On 2/22/26 09:48, Gregory Price wrote:
> > Topic type: MM
> 
> Hi Gregory,
> 
> stumbling over this again, some questions whereby I'll just ignore the
> compressed RAM bits for now and focus on use cases where promotion etc
> are not relevant :)

A more concrete example up your alley:

I've since been playing with a virtio-net private node.

Normally cloud-hypervisor VMs with virtio-net can't be subject to KSM
because the entire boot region gets marked shared.  If virtio-net has
its own private node / region separate from the boot region, the boot
region is now free to be subject to KSM.

I may have that up as an example sometime before LSF, but i need to
clean up some networking stack hacks i've made to make it work.

> > 
> > N_MEMORY_PRIVATE is all about isolating NUMA nodes and then punching
> > explicit holes in that isolation to do useful things we couldn't do
> > before without re-implementing entire portions of mm/ in a driver.
> 
> Just to clarify: we don't currently have any mechanism to expose, say,
> SPM/PMEM/whatsoever to the buddy allocator through the dax/kmem driver
> and *not* have random allocations end up on it, correct?
>
> Assume we online the memory to ZONE_MOVABLE, still other (fallback)
> allocations might end up on that memory.
> 

Correct, when you hotplug memory into a node, it's a free for all.
Fallbacks are going to happen.

I see you saw below that one of the extensions is removing the nodes
from the fallback list.  That is part one, but it's insufficient to
prevent complete leakage (someone might iterate over the nodes-possible
list and try migrating memory).

> How would we currently handle something like that? (do we have drivers
> for that? I'd assume that drivers would only migrate some user memory to
> ZONE_DEVICE memory.)
> 
> Assuming we don't have such a mechanism, I assume that part of your
> proposal would be very interesting: online the memory to a
> "special"/"restricted" (you call it private) NUMA node, whereby all
> memory of that NUMA node will only be consumable through
> mbind() and friends.
> 

Basically the only isolation mechanism we have today is ZONE_DEVICE.

Either via mbind and friends, or even just the driver itself managing it
directly via alloc_pages_node() and exposing some userland interface.

You can imagine a network driver providing an ioctl for a shared buffer
or a driver exposing a mmap'able file descriptor as the trivial case.

> Any other allocations (including automatic page migration etc) would not
> end up on that memory.

One of the complications of exposing this memory via mbind is that
mempolicy.c has a lot of migration mechanics, just to name two:

  - migrate on mbind
  - cpuset rebinds

So for a completely solution you need to support migration if you
support mempolicy.  But with the callbacks, you can control how/when
migration occurs.

tl;dr: many of mm/'s services are actually predicated on migration
support, so you have to manage that somehow.

> 
> Thinking of some "terribly slow" or "terribly fast" memory that we don't
> want to involve in automatic memory tiering, being able to just let
> selected workloads consume that memory sounds very helpful.
> 
> 
> (wondering if there could be some way allocations might get migrated out
> of the node, for example, during memory offlining etc, which might also
> not be desirable)
> 

in the NP_OPS_MIGRATION patch, this gets covered.

I'm not sure the NP_OPS_* pattern is what we actually want, it's just
what i came up with to make it clear what's being enabled.

Basically without NP_OPS_MIGRATION, this memory is completely
non-migratable.  The driver managing it therefore needs to control the
lifetime, and if hotplug is requested - kill anyone using it (which by
definition should not the kernel) and either release the pages or take
them so they can be released while hotplug is spinning.

> I am not sure if __GFP_PRIVATE etc is really required for that. But some
> mechanism to make that work seems extremely helpful.
> 
> Because ...
> 
> > /* And now I can use mempolicy with my memory */
> > buf = mmap(...);
> > mbind(buf, len, mode, private_node, ...);
> > buf[0] = 0xdeadbeef;  /* Faults onto private node */
> 
> ... just being able to consume that memory through mbind() and having
> guarantees sounds extremely helpful.
> 

Yes! :]

> > 
> >   - Filter allocation requests on __GFP_PRIVATE
> >     	numa_zone_allowed() excludes them otherwise. 
> 
> I think we discussed that in the past, but why can't we find a way that
> only people requesting __GFP_THISNODE could allocate that memory, for
> example? I guess we'd have to remove it from all "default NUMA bitmaps"
> somehow.
>

I experimented with this.  There were two concerns:

1) as you note, removing it from the default bitmaps, which is actually
   hard.  You can't remove it from the possible-node bitmap, so that
   just seemed non-tractable.

2) __GFP_THISNODE actually means (among other things) "don't fallback".
   And, in fact, there are some hotplug-time allocations that occur in
   SLAB (pglist_data) that target the private node that *must* fallback
   to successfully allocate for successful kernel operation.

So separating PRIVATE from THISNODE and allowing some use of fallback
mechanics resolves some problems here.

I think #2 is a solvable problem, but #1 i don't think can be addressed.
I need to investigate the slab interactions a little more.

> >   - Use standard struct page / folio.  No ZONE_DEVICE, no pgmap,
> >     no struct page metadata limitations.
> 
> Good.

Note: I've actually since explored merging this with pgmap, and
rebranding it as node-scope pgmap.

In that sense, you could think of this as NODE_DEVICE instead of
NODE_PRIVATE - but maybe I'm inviting too much baggage :]

> > 
> > Re-use of ZONE_DEVICE Hooks
> > ===
> 
> I think all of that might not be required for the simplistic use case I
> mentioned above (fast/slow memory only to be consumed by selected user
> space that opts in through mbind() and friends).
> 
> Or are there other use cases for these callbacks
> 

Many `folio_is_zone_device()` hooks result in the operations being
a no-op / failing.  We need all those same hooks.

Some hooks I added - such as migration hooks, are combined with the
zone_device hooks via i helper to demonstrate the pattern is the same
when the memory is opted into migration.

I do not think all of these hooks are required, I would think of this
more as an exploration of the whole space, and then we can throw what
does not have an active use case.

For the compressed ram component I've been designing, the needs are:

- Migration
- Reclaim
- Demotion
- Write Protect (maybe, possibly optional)

But you could argue another user might want the same device to have:
- Migration
- Mempolicy

Where they manage things from userland, rather than via reclaim.

The flexibility is kind of the point :]

> [...]
> > 
> > 
> > Flag-gated behavior (NP_OPS_*) controls:
> > ===
> > 
> > We use OPS flags to denote what mm/ services we want to allow on our
> > private node.   I've plumbed these through so far:
> > 
> >   NP_OPS_MIGRATION       - Node supports migration
> >   NP_OPS_MEMPOLICY       - Node supports mempolicy actions
> >   NP_OPS_DEMOTION        - Node appears in demotion target lists
> >   NP_OPS_PROTECT_WRITE   - Node memory is read-only (wrprotect)
> >   NP_OPS_RECLAIM         - Node supports reclaim
> >   NP_OPS_NUMA_BALANCING  - Node supports numa balancing
> >   NP_OPS_COMPACTION      - Node supports compaction
> >   NP_OPS_LONGTERM_PIN    - Node supports longterm pinning
> >   NP_OPS_OOM_ELIGIBLE	 - (MIGRATION | DEMOTION), node is reachable
> >                            as normal system ram storage, so it should
> > 			   be considered in OOM pressure calculations.
> 
> I have to think about all that, and whether that would be required as a
> first step. I'd assume in a simplistic use case mentioned above we might
> only forbid the memory to be used as a fallback for any oom etc.
> 
> Whether reclaim (e.g., swapout) makes sense is a good question.
> 

I would simply state: "That depends on the memory device"

Which is kind of the point.  The ability to isolate and poke holes in
that isolation explictly, while using the same mm/ code, creates a new
design space we haven't had before.

---

I think it would be fair to say all of these would not be required for
an MVP interface, and should require a use case to merge.  But the code
is here because I wanted to explore just how far it can go.

In fact, I believe I have gotten to the point where I could add:

  NP_OPS_FALLBACK_NODE  - re-add the node to the fallback list
                          do not require __GFP_PRIVATE for allocation

Which would require all of the other bits to be turned on.

The result of this is essentially a numa node with otherwise normal
memory, but for which a driver gets callbacks on certain operations
(migration, free, etc).  That ALSO seems useful.

It's... an interesting result of the whole exploration.

~Gregory

