Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F66DCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 07:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9866B0088; Wed,  3 Jun 2026 03:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E6B6B008A; Wed,  3 Jun 2026 03:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4076B008C; Wed,  3 Jun 2026 03:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6676B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:02:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37F6F1C036E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:02:17 +0000 (UTC)
X-FDA: 84837707514.09.6F89A12
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 22B82140018
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:02:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IMArmQpi;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780470135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as8GUoU4kWbY2J9d2zC/fdPvz19fGbLVGasT3ISIBEc=;
	b=iANqt2RLxezxa8crNN06Tusd3d3nHAV+XAgYFcaOquQUJ536WPsxlGznwEtHMxj3e5gHsA
	thEfsem/HcTcqizHXvIxsB23TNqqNzgAtLQ8OXMrdxgqwbAmoW5RAcEXHLwFOcvczeytVh
	DmOY9fhXWmBxCVDwAX8sLF01ZPR6d5Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IMArmQpi;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780470135;
	b=7M61OzFLg5azi1cNcEohDwIkxrYmPY4swnWYU0z6gEX008S084E3pRQMg5EAphysGUZ683
	i6/0+ArulXniqYcZWgWqwXLAa2JmUAlQ6FICQjiTQ5TEzRhUYunM6RrL5ee6xT8bqxkqN8
	5q4peOGsGnWEFKGdATVS2JEqH96PNNY=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490388fd0dbso121492625e9.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 00:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780470133; x=1781074933; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=as8GUoU4kWbY2J9d2zC/fdPvz19fGbLVGasT3ISIBEc=;
        b=IMArmQpiKglp/itDFotFPWZy4GCC+/wCLr1ZTvBq4Ic7sVNWjnj8IOMfrPzVohmQKr
         bS3aX79kYwocxpnMyEgOh8qmc8YHcgYWQM2O6deUH4CDEngOSCQlGt134qlIUhk4osb5
         JelIk0jUZ0DXi87+oGfEL0IUrIebuFL4/rc7e6T4sgFXr8WwBFH0nkh1G/raHf/nrYsz
         aGmtQNTyLD0gcEzzcNcnMANpfv9lbOIvM6FTgCbwOFHj0KkZ1Hi5SycDm8Cyta9H6bXq
         fYETTk+WaLJtjEzNnOIn+9w7bOInt2H7bfYjw8JKiXnUevkYqFv66vkvpDl65du06fzD
         zAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780470133; x=1781074933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=as8GUoU4kWbY2J9d2zC/fdPvz19fGbLVGasT3ISIBEc=;
        b=eDN4YradgfZBcQ01MGrLKuDv6cnrWbuxFyITZLm1348fOMPBps3rbxSwmlYFjksNWj
         5fm0tYeCPHTaR050UEYrQuNQifjrz1yX84O5p2wzTg9o8cLNZDzBiQAU84TemEOjgn7v
         CGObPKmA5Rrf+DEibaX+SGsvo8way3E51DFqoUxO7W7ibZmknUo+i/DNHnJ1Q23RNe3u
         OWrDczSwTY/ha39uDUcxmhkDfIhBEGsyFgQcrhYq3RHYW8VgtDeZpq2vYqeytnQ/LMlw
         Ku71AjYAQwQ1PHp9fxh5XIlZXS/PDxoiet8SkGnz+Dp8hWQb7D9g+nqKNiDwLymouZjC
         H5Zw==
X-Forwarded-Encrypted: i=1; AFNElJ9AAx9ccIC65Tdd4jVpn0YTf7mVIgsV4dWoUe37v14ZoM27ni67XkXK4vCO692gTnXgSIFmAY/wbg==@kvack.org
X-Gm-Message-State: AOJu0Yxzf/SU6y3rJ6VGdwZCfTCgkjfpMc1VNfcyUev5g1LkYu5npYh3
	r2HL1uuFlcIHheKcWchP09x3h3G+WpC2L8IcYo4R1CR+w2yv/oFGaPtc+L45Fv0wkqk=
X-Gm-Gg: Acq92OGGbvSF/+ALxjTMqfTIgVnGHapGoTSgiShj43VKoEJvBSLvG96oyNymMe1BfL8
	jXQb4tRnZsyebIydgZCabDl2z/VYDLO7/jueFAT4iXb1O7iSPE3OiDDrN0YRAsBEGNy2XqYRlnz
	Wf41GjapZ2rvxiIIXrKTLAyxb1SsxyZP8vYuLyy8a8FVmO8+64wC3tAVcIaA1dqAPRw2kDE/oY5
	Q/KoQU8YRd8MJ8nlVcyq1+5mROc22thQP+24cpXDaT7dPRs0++AFaTH8WbCWNTEzRjQAd22eQtC
	1qnBja7GR6HfiWQqZFbThh0ZeE+Qu9thf+MBAd7IFZqP00DN6j2At3nzreRQ/endmGv2geRgSo4
	p29ttNkko3/fP9JUvqc2Ce3m5CqBxJPSvC6i/sInHzfo0xLDr4fLJXs5BPK/r53ym+Y1HcRNP+u
	6girElIOOgaPVuw9QIVqo0ETpcO/+hslBEaS5DHu/9vn55ug==
X-Received: by 2002:a05:600c:83c8:b0:490:47e0:e13f with SMTP id 5b1f17b1804b1-490b5d1cf3emr36644555e9.3.1780470132845;
        Wed, 03 Jun 2026 00:02:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([149.107.71.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b7c6b966sm16631885e9.2.2026.06.03.00.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 00:02:12 -0700 (PDT)
Date: Wed, 3 Jun 2026 08:02:09 +0100
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
Message-ID: <ah_RcTU8SpQG7hab@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah-0CyZurn5D1ezY@parvat>
X-Rspamd-Queue-Id: 22B82140018
X-Stat-Signature: k3ye17kpmmya7khn14pt1eqpggmsxprn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780470134-599366
X-HE-Meta: U2FsdGVkX192iyKhb/5LHOFruJYN8ZWigUgG29ThMPcmoq2O9rtlUVwTVEHGhVPQKFgRjEPa8onyTFrtgTa6ecju4/iQ+Bo5efCXifrjRG3GiIeVwUUSAQLuKsbpvhVmnbz6ZBLTc1NJcDh3UJtn1JQUeMhI/fx7av/FH6Lj0VBKK/0rf61+86wrq3h8XSolU6qJWzz8r2yz9b/piavXzMgqCEpV99ucPI0EexIVv1D1sOiFT5XXzmUjKblTIllsEKHrjC+eA3dwsnh3GNcCAffIjleXmA9qGPYMOKTu7S910WgjhP8CRLndrVU5ziDiexXAvCLxti0ovJswPknQx+FM/aKjkpPpC2CdyNmXkAiQlr6/Ek2yx7TGUpUWQEzgD4C5nM6/WGCl7rsayVe1JWU9z/k/7n8S2pHBJ+5M7o2B/2D9VRL+DUr5gwzktLq2jT4NwR55yrDIUzoxvbtt38y48tFlbPYNfdNJuma7ynUYVz+Nfw0VCNTTp5OSqLnfHaIfDSA7PGimuggUEB69475wfEDFvkHS/HGH2wz31QJIf6J41HUYgIFZVlnoe5195KETNfzy6o+7qjhl6tIDt8c6zb57ehu/lkyZ2/YctYdvn5kDlUP2lW5HQpw5tg7WO9wL3ZDVqzZJ9Fm5xpK1WTKVSPA30hc+YlWIl6vdrTfUhqn+9H69SrrwY+Gd+fLxCs/lJo/m3h5xN5A8EnLSUdCmKIGimhWf1XFcBKcI68UZy9nGy3WMmT+dwbOswTkmxVDehFgff4ALEOxX28p3ccsnDSlv5CBQpdKM3K3QblMA+JpXkfjgWrNMWxCS/v/oWrblWEuEyVWkSorIdap0n1iYDfANJPlTmIS1csdD+vD/Yz3LmrySh4geiiFdM8vcwdHG/cY61DrVGPcBfp1RzB9oNi+kpFNLPu11LxYwolQ4mkXSslO/a1xLA5TdBXkzORbUxMGMSW/WdAynJth
 yyGP8qbk
 0XE9YbZXcfdSCXDbo10YiFzj6U0NkDVD5J7ADx1jMPi1d/gIjYFw4iboG4QWNepmOTw3RC5NVorULTzl0SvizNj0PWve5xhStv+fV7x83b7hBADp9xNllu1nCLtEdNiMlsmRi8wG26GB8oYmJU8mIBPh2a36sboI71QeXwWf4lRZ2NjgOHpze9z1CE4TLb0dqEiCal/1dr5nmOUYdeW89TXv3Uz+tudVZcbL4/DjlIlSa97xQmeGTdK3M4cmKfdU9IEP929LCfXjj5okSGvhaEH+wp+tUCDqPwYeMcwjgvziEkT3bEUI6c/7qI9nSXHHgea63TfTnVmCzNRcdPGp2wpedpJPi1aEeSx437HRktW8vnUysgZSufrgfRpPP62lmVQj0iOHWubV1UNAc0efq6HDyNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 03:00:01PM +1000, Balbir Singh wrote:
> On Tue, Jun 02, 2026 at 09:57:48AM +0100, Gregory Price wrote:
> > On Tue, Jun 02, 2026 at 12:16:50PM +1000, Balbir Singh wrote:
> > > 
> > > I was think we wouldn't need explicit flags and that allocations would
> > > happen from user space using __GFP_THISNODE to the node or via a nodemask
> > > based on nodes of interest. Is there a reason to add this flag, a system
> > > might have more than one source of N_MEMORY_PRIVATE?
> > > 
> > 
> > There's a few things to unpack here.  I discussed this many times on
> > list and at LSF, but to reiterate.
> > 
> > 1) __GFP_THISNODE is insufficient to enforce isolation and otherwise
> >    not particularly useful.  Additionally, from userland, it's not
> >    something you can actually set.
> 
> I was thinking mbind()/mempolicy() is how we get to it. It already
> accepts a nodemask.
>

First let me say:  I want to enable mbind access to these nodes.

But let me caveat:  I think that needs more time to develop, and
in the meantime, we can enable the /dev/xxx pattern somewhat trivially.

First let me address a few things about mbind/mempolicy and how it
interacts with page_alloc.c, I gave this overview at LSF but I don't
remember if I posted it in any of my follow ups.


1) Fallback lists are filtered by nodemask, the nodemask does not replace
   the fallback list.

Here is how the page allocator fallback lists and nodemasks interact:

   Fallbacks A:  A B 
   Fallbacks B:  B A
   Fallbacks C:  C A B   (Private)
   Fallbacks D:  D B A   (Private)

Lets say you pass:

   alloc_pages_node(C, ..., nodemask(A,C,D))

So we get

  Fallback(C,A,B) & nodemask(A,C,D) -> iterate(C,A)

If we wanted to change this behavior, realistically we'd be looking for
a way to add specific nodes to certain fallback lists - rather than
modify the nodemask interaction in some way.

I think this is out of scope for the first iteration - so supporting
anything other than mbind() from the start is just pointless.

The only feasible mempolicy you can apply is single-node bind, so
realistically you can only support mbind.


2) full mempolicy support doesn't really make sense

   task mempolicy PROBABLY should never really touch private nodes,
   while VMA policy certainly can.  Assuming we're able to support
   multi-private-node masks, none of the non-bind mempolicies even
   make sense for most private nodes (interleave? weighted interleave?)

   I haven't worked through all the implications of a task policy having
   a private node attached, but the longer I think about it, the less it
   makes sense to just support this outright.


3) Introducing mbind support is not just a simple nodemask on a VMA,
   It also implies migration, cgroup/cpuset, and UAPI interactions.

   a) migration:
      
      mbind/mempolicy can and will engage migration when it is called
      with certain flags.  Migration has subtle LRU interactions, but
      the patch set I have at least allows this to work.

   b) cgroup/cpuset:
   
      cpuset.mems rebinding will cause private nodes to be quietly
      rebound to non-private nodes within a nodemask.

   c) between A and B - we really want MPOL_F_STATIC to be required
      for mbind to be applied to private node so that it is never
      forcefully remapped.

      That's a UAPI semantic change specific for private nodes we
      should really take time to consider.


4) File VMA interactions don't entirely make sense with mbind

   In theory you might want:

   fd = open("somefile", ...);
   mem = mmap(fd, ...);
   mbind(mem, ..., private_node);
   for page in mem:
      mem[page_off] /* fault file into private memory */

   In reality: This does not work the way you want.

   I went digging and we need a few mild extensions to allow
   migration on mbind to work for pagecache pages, and the fault
   path does not necessarily respect the vma mempolicy always.

   You also start getting into the question of "what happens when
   the node is out of memory and you don't have reclaim support?".
   The OOM implications jump out at you pretty aggressively.

   Moreover other tasks can force the page cache pages to be moved
   as well.  So the programming model here just kind of sucks.

   Works great for anon memory though :]

For all these reasons, I think the be mbind/mempolicy support with
private nodes needs to be brought in with follow up work - not
introduced as part of the baseline set.

> > 
> >    for node in possible_nodes:
> >        alloc_pages_node(private_node, __GFP_THISNODE)
> > 
> >    In fact it's the opposite semantic of what we want.
> >    THISNODE says: "Do not fallback back to OTHER nodes".
> > 
> 
> That's why we need to control the fallback nodes carefully for
> N_MEMORY_PRIVATE
>

My point is that __GFP_THISNODE is not actually useful.

If we go by nodemask, submitting a single-node nodemask is the
equivalent of an empty fallback list.

If we gate access to a private node by __GFP_THISNODE... this is the
same as just providing a single-node nodelist (putting aside the OOM
implications for a moment).

And it doesn't even buy you any new filtering ability against existing
nodemask iterators that may already utilize __GFP_THISNODE.  i.e.

   for node in online_nodes:
       alloc_pages_node(node, __GFP_THISNODE, ...)
       /* Alloc per-node resources */

   This pattern is undesirable, but completely valid.

So overloading/requiring __GFP_THISNODE is just not useful.

I will follow up soon with a new version that limits the private node
interface to just nodemask and fallback list controls.

I need to test a few more things related to removing normal nodes from
private node fallbacks before I feel comfortable shipping without
__GFP_PRIVATE.

> >    The semantic we want is "Do not allow allocations from private
> >    nodes UNLESS we specifically request" (__GFP_PRIVATE).
> > 
> >    __GFP_THISNODE does not actually buy you anything here, AND it's
> >    worse, in the scenario where a private node makes its way into the
> >    preferred slot (via possible_nodes or some other nodemask), the
> >    allocator cannot fall back to a node it can access.
> > 
> >    __GFP_THISNODE cannot be overloaded to do anything useful here.
> 
> Let me clarify, I meant to say, let's use a nodemask for allocation
> and __GFP_THISNODE gets us to the node we desire, if that is the only
> node. My earlier comment might not have been clear.
>

My point was that __GFP_THISNODE is pointless and reduces to providing a
single node nodemask anyway.

The contention over __GFP_PRIVATE is a bit ideological - do we want:

  1) A hard guarantee that allocations to a private node are controlled
     (__GFP_PRIVATE implies the caller knows what it's doing)

  or

  2) A soft guarantee (fallback list isolation only), and needing to
     deal with undesired behavior that's "not technically a bug"
     associated with existing users of global nodemasks (possible,
     online, etc).

I am arguing for #1 - the community has argued for #2 and "fixing
existing nodemask users".  I think we can ship #2 and pivot to #1 if we
find fixing existing users is infeasible or too much of a maintenance
burden.

> 
> Why not use mbind() API's? Do we want to gate allocation/privileges
> via a /dev?
>

We want to eventually enable it, but we really need to treat these
extensions as a separate step from the base so that the UAPI
implications are given proper scrutiny.

In the short term, /dev/xxx and driver-local/service-local control
of a node is still very useful.

For example, for my compressed memory work, I have found that if
implemented as a swap backend - the kernel can manage the node without
any UAPI implications at all :].

A driver managing memory on a private node could do the same.

~Gregory

