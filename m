Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 873CBC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8435E6B00B9; Wed, 22 Jul 2026 11:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B056B00BA; Wed, 22 Jul 2026 11:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730976B00BB; Wed, 22 Jul 2026 11:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4291B6B00B9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:40:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C295D80225
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:40:15 +0000 (UTC)
X-FDA: 85016823990.21.C6917DB
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id E27564000E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:40:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n6txXZvl;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9WM+2MFVnedGDWLPttsIf94o07ITbEUNNq93LWWdyQ=;
	b=4xh54sdEPnNcPlYvqkQ7UuW+X0TWKgWi+iXrEC4Ur8YZjDij9WK3NP78Zb/032JV0CmA6j
	3zGSAHYVS5dbeWVJx7aXuoEdrCyLnnpzz/OO1XB54XRPYjfpDjow9QkOKQ9OlwSfyon+3/
	9ZafBYdSf0MX41ShTr7eCm8oqVsCXig=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n6txXZvl;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734814;
	b=wwSD0ApWNt2LCMIHef5GpQWNUXMTUNmIHTGxTugfqiIvnQKEAPRaoPbVw4Jx95Ds69Raaa
	FttpHsoWF2HkvF3k1MjZYzeZT4l1/75z/tDSiGRMucJnlWZVPUfaRyd59myfOSE1NYdxXk
	RrJtA5O0PoltEcuygeVPqg//we8R4Hc=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e6391b114so723500985a.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784734813; x=1785339613; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z9WM+2MFVnedGDWLPttsIf94o07ITbEUNNq93LWWdyQ=;
        b=n6txXZvlDrrAhxeynBi9VtYEdtDJx5gYrDCIreTRDV8x+pUV29Lmk4lB4z4kTmv/g0
         qYrC0ldvhQlsafoPOEizFIJkVavyWTAoVPPG2WDY7yuCXaS3OmNAQnmfgKYQcU05t/JJ
         n8t8CmebATgnxotQPIXMLrISmLhFwnvUbS0Bun0ArPf5THRThX9TGUG25uJ4crPUfbb3
         NKlbjhxUE4lsaC87UrpxRb8VDJxw7DWiDGNjPJ1JNVbEOjiE5cHE1OJPYPdHVN7Ol5cs
         EotBRwMjgoLhrm4gHDJY6bYr8KuN2Cn9RRyb3cMyVJyeFy25jGrIA5Yk+prIlnSQPccO
         zw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784734813; x=1785339613;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z9WM+2MFVnedGDWLPttsIf94o07ITbEUNNq93LWWdyQ=;
        b=a6OaDz8UhX2dULcAFZnIqaUvFqMCxzK/wXyAvDk+ctp9Mtuu5ChMdPFJ8aLQCXaX+Y
         ZQtbwYuJ69r7NYui6l8Zl7JC8MR9BSbhKKrj01GApLXAiXgfq2A9qF+K9nNEbFV7kfvt
         hHaNMnuZv61nTq4udrxEWez17BRtfzmzbbZqAlfnRP4MWWmUTzmcmrrqQdDVmz2t5v4E
         IzJ22y649rMg6X7M9sHV/NB/8IOOJ0Y/ai/YhiFJsuvMUc3Xgo+pM2hTCo+/xPfv8jeB
         tSsq7ZEU2p4HLkvnUWF2OqnIif8IyqB4bvcUHv75aquNaSSRxmm4lEZ8vSfyrlsiNjw6
         T26Q==
X-Gm-Message-State: AOJu0YwsxDp2A0QNP9e+OczGBUgFMQxBaeW0CjMmKgQnhtLSew9LAX6y
	QbwPi60nN6EV2dqyX6SvHQ1Hal3Jbcr+aaqYbKdOIOJuzhi7B4/IhES0veI9/cz/xCkIyWLt92u
	TPzR3
X-Gm-Gg: AR+sD10WFdqeYqiDzcEbvUP7GMh2dVKxDlq2tHJhfTBBBXUZWngNJqasxcvEy5hpyCw
	rnRYWKEzf0AugtdiVFnh6DUbyLGA2GqAEcLgREE6k9YNDkbHQKFmMM/pbbq/0yylAveFbEiy678
	MzmzxNrXyyI78EO5xet8fKYyiML1B/kjYrmBw5HBBNdory+BuE0jHYSvk9rOCpaJMcR1OYRHwuk
	Ql6+usX2merw7C6kVoImH8DViAzp7sIMOTu2UAyc9cB4tynRb4ww/Lgra978OBguiGyYrbgdAGk
	qrCmQrGifiRX1fieB/ySXydpADwvyt6f+ewvptR7umNiFilG8Ilc+vscqeU/8aZPDPCJH+nuJL3
	fh7QTDM8zbbaKTP+YAmadwfsFRaCMcllnmzc2Z8P0b1lL6LzqABzTvcwScNv1ms9jBpPZu48ToL
	MU9YsuyFfH2wU1oO2QHRGOnZRCCze5nByA1rnYwYixAbkB+cMXO+SUYLZkrA==
X-Received: by 2002:a05:620a:371d:b0:92b:6805:9175 with SMTP id af79cd13be357-930b419d330mr2368159885a.61.1784734812726;
        Wed, 22 Jul 2026 08:40:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f68a9c76sm190317885a.13.2026.07.22.08.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 08:40:12 -0700 (PDT)
Date: Wed, 22 Jul 2026 11:40:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <amDVQopyvolxfX8K@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <amDL80BSEP6u9XfE@MWDK4CY14F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDL80BSEP6u9XfE@MWDK4CY14F>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E27564000E
X-Rspam-User: 
X-Stat-Signature: 1f618h9wg8uk6qzz4sozyxwsniuzb88f
X-HE-Tag: 1784734813-462682
X-HE-Meta: U2FsdGVkX19nbA/lyTFx17yWLM6uA2OrGfejdGh9lLLlbGWdUYK2Di+pD8Bvdc8ugpJg/iQrT7DoUvZHChZHx5XKxI+QZVp5+6dg0hZxkDkjPBYjwXOsgdhZVgW78SNgF9xIxAfLHyZM6ul0+db/S3gnqRH9m9ZzueUpUmHarlbn0dymzummE1T3IHb4RKS7bi0hSqFiS2qERVfjCjosNzmC4g/UwhI3H2yg3+kchY/Zh9Cs1uFVQ0iALddTCpee+lLwiJCp9ClEYU4KETMYeGtckZ8Dziny2kGSmJzk4FoLW1GyjPc92pWg6OXp4fMTiJMd1oj6jI5q2BHOeg/3HRHk/tf3yGlOTDdgjHpNAJ6Iv5jUIInGZb78Fbzla9YgNwPjNlFMC/uO2LUEd8kN3wrsau1ErD9KTiSEq2xfWj1yUqdYBlvXbG3hbQHOPLsA2mr2fRE+yIVY2FlyGjLn8FjBjZIE1uj1dmTUO8P+gTDh4A76NqMTdxfv4M73jMTljwGhbm9zR/qtu70CVdXyg0iCq/dphvlz0wAQALewpVD7xV/gvUFZltQshXcheNDPlp101UDoJXCG3NVFw/ULQXhQxIp79OcSopmPJQxy3DV9wDyqad3oCT2I3jdjJIK9adCnLaILBhzdnS31qdzl8pi8Nzaga0GRQpeVTA//7VeXiqZbLc5nwlFWuJQu3dgoTYpNP5nZ8iGBq8A3ZS/PygnEumD3YX1RzLFoaMlIhOTAqhDt3K1dXXvLRVM9egVW1QNwwFVWY5oUa0gCHqUTPZe5+ic78lS1GO/APut+HfkBuynwIAX0sC7N0EPDq2zgGZ5aZ9FGQb1cAnJf4Tk2JXxxLCBdIGVyCK1vqQOwvQK1JuXf9wx/73nKnNv0z3c2NW5Iy9MhCmsnt+MkExOx9jYBRR6z1ugQ40tyYz9UIL7zLxTNiS1sCqDQ7S5VMd+y/X25cgKINfWKqwAmEZm
 U/0NGfbh
 mh9gNtmaAI2VzOYWfCt21m3nTLDFyfX9mWJqv3EI9yuYofpdhgM0rSMzPa1/B6KImiQpJ0ey3atM9xIltmbYgXpcwrrRdgfs60ppyWzuLPrixZpujBcBqnrceCh+EoLFD2xGml/nT1Da2v0K6rGpToOZAyszthjMmHE5Rwjz1+ZqqwuDqBRxA82m4M1bPwZ9rDuuMgI9J538yC8JBBRNPWbabAdoiVgwmWMgpgO6jK8ITex842/JBzGE2yVMKBxljz57cru3uGVSlSRcmkIWPF+GerOVH5RqDkrlTixhpU6YnDhq95gqsNUbQRegU7yjidqzj79cNO40IEr925ougpbUhHUlB5Ym/akn+kVj9oJGQBDHqSTEuXwNZeNy4kALTgdT3Xmfxp8S4wvAhTg5oL3PUZH9EzXbfATd9lQCnywj5Wa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:20:00PM +0800, Richard Cheng wrote:
> On Mon, Jul 20, 2026 at 03:33:54PM +0800, Gregory Price wrote:
> Hi Gregory,
> 
> I applied your series on mm-next and give a quick review,
> not thoroughly, still I have some questions below regarding the design.
>  

Hi Richard,

Thank you for the read.

Just a heads up, this was based on mm-new because of some recent work
on Brendan's page_alloc.h cleanup, but if you managed to get it applied
then maybe that's made its way forward already.

> > The goal here is to flip that dynamic, isolate by default and then
> > opt-in to specific services that the device says is safe.
> > 
> > Isolation at the NUMA/Zonelist layer provides a powerful mechanism for
> > memory hosted on accelerators - re-use of the kernel mm/ code.
> > 
> >  - Accelerators (GPUs) can use demotion, numactl, and reclaim.
> >  - Special memory devices (Compressed RAM) with special access controls
> >    (promote-on-write) can have generic services written for them.
> >  - Network devices with large memory regions intended for ring buffers
> >    can use the buddy and standard networking stack.
> >  - Slow, disaggregated memory pools which aren't suitable as general
> >    purpose memory get cleaner interfaces (no need to re-write the buddy
> >    in userland, can use migration interface, etc).
> >  - Per-workload dedicated memory nodes (disaggregated VM memory)
> > 
> 
> For accelerator part, take CXL Type-2 as example, it has its own protocol
> CXL.cache, CXL.mem which is the rule they need to obey during memory transaction,
> Adding more rules for them since they are NUMA node confused me, I wonder the reason ?
> 

CXL protocols simply state how to do the memory transaction at a
physical / transport level.  It does not make any statement on how the
operating systems are to make sense of these devices or what constructs
/ abstractions to build to actually manage the devices themselves.

This series is not necessarily attached to CXL in particular, you could
just as easily carve out memory from the general pool onto a private
node to ensure it only gets used for a particular use.

In fact, that is how I have been testing this with dax/kmem:
https://github.com/gourryinverse/linux/commit/f279e741d9c3643597525bfab916b29b95cb635b

> Because NUMA node, at least for me, representing topology/locality rather than
> something with ownership or capability or rules.
> 

The NUMA abstraction representing topology/locality is a construct we
(the OS developers) have decided on historically - but there's nothing
that dictates we can never create new useful abstractions with it.

Consider:
    N_NORMAL_MEMORY,        /* The node has regular memory */
    N_HIGH_MEMORY,          /* The node has regular or high memory */

These have nothing to do with topology or locality, they are node states
that only have meaning in the context of linux mm/.


To make something clear - there is no *requirement* for any particular
device to use this abstraction.  It simply enables a cleaner way for
devices carrying memory to re-utilize mm/ services while ensuring their
memory does not silently get used under system pressure (or some vagrant
in userspace doing `numactl --interleave all`).

Ignoring all the CAP bits entirely, if you just took the base series
your driver could re-use the buddy allocator without any special logic
AND have confidence that your driver is the only possible user of that
memory (barring some truly obscene bug).

> >  - isolation via a dedicated zonelist:
> >      - private nodes are omitted from FALLBACK/NOFALLBACK
> >      - added ZONELIST_PRIVATE(_NOFALLBACK)
> 
> I saw the reply in patch 5, so in fact there's not only one
> dedicate zonelist, but numerous ?
> I raise the question because zonelist was supposed to be a
> global, unbypasssable thing in MM design, but now what you
> are trying to do is to seperate the whole global list into several
> parts ?
> 
> Can you explain why in current design you don't consider to support
> something like ZONELIST_PRIVATE[n]={0, .. ,n-1} ? that's my imagination
> of what a global zonelist should look like, no matter private or non.
> 

First let me say that there's nothing that prevents us from doing this,
and we *could* make this the default case - but this decision was
intentional by me.

Having them all present in each-other's zonelists by default creates a
number of implicit opt-ins that are unclear:

  - any direct zonelist iterator now iterates all zones on all private
    nodes, even those nodes do not opt into the same services

    e.g. zonelist iteration in reclaim that targets Private Node A would
    attempt to reclaim Private Node B as well.  That would require and
    extra explicit filter.

    I ask: Why do this? Just isolate in the zonelist, and if there is
           a desire for intersections - make it explicit, not implicit.

  - fallback allocations can now occur across private nodes, even
    if those nodes are intended for different purposes.

    Obviously you can use nodemask to tighten the allocation target, but
    I use `numactl --interleave --all` as an example of a clear case
    where intersected nodelists may not give you the behavior you want.


So for consistency - everything including zonelists have full isolation.
This way all interactions with a private node must be explicit - always.


This is actually one of the problems with ZONE_DEVICE - and you can see
it in this patch set.  Some of the hooks in mm/ for zone_device only
apply to PTE cases, and are absent from PMD cases - only because PMD
mappings in ZONE_DEVICE aren't supported.

That kind of implicit behavior is quite bad.

That said, future improvements could include something like:

for_reclaimable_zone(ZONELIST_PRIVATE) {}

where we loosen this isolation, and formalize a filter, but I would
like to see the usecase for it first.  Loosening the isolation defeats
the entire purpose of the series, so there should be a strong reason to
do so.

> > Allocation Isolation
> > ====================
> > page_alloc presently controls whether a node's memory can be allocated
> > on a given call by 4 things (in order of authority)
> > 
> >   1) ZONELIST membership
> >      If a node is not in the walked zonelist, it's unreachable.
> >
> 
> So a device gets hotplugged in the system will get a dedicated zonelist here ?

Yes.

> And make sure it obeys the device's own protocol if it has one ?
> 

I'm not sure i follow this question, can you help me understand?

If by protocol you mean the CAP bits (opting into reclaim, demotion,
etc), then yes.  If you mean something else (CXL) then I think that's
orthogonal and unrelated.

> > Private nodes:
> >   1) Never appear in any ZONELIST_FALLBACK
> >   2) Have an empty ZONELIST_NOFALLBACK
> >   3) Only appear in their own ZONELIST_PRIVATE(_NOFALLBACK)
> > 
> > 1 & 2 mean all existing in-tree callers to page_alloc can NEVER
> > accidentally allocate from a private node.
> > 
> > An allocation must explicitly ask via a zonelist and a nodemask.
> > 
> >   alloc_flags |= ALLOC_ZONELIST_PRIVATE; /* use ZONELIST_PRIVATE */
> >   __alloc_pages(..., nodemask);     /* with the private node set */
> > 
> 
> As I stated above, NUMA concept was quite naive at first glance for my
> limited knowledge.
> 
> This is quite alot to add for NUMA node concept, I'll want to see
> more explanation in v6 and learn from it, thanks.
> 

Sure, I can expand on it.  I think it's not as much to add as you think
though - it's simply adding the concept of isolation to a NUMA node.

Some more explanation below, but if you think there is something i
should explicit spell out in v6 cover, please let me know.

---

I agree that NUMA as a concept was best-effort for, comically enough,
somewhat *Uniform* memory access - instead of *Non*-Uniform memory access.

The current abstraction quite nicely handles the case where all memory
on the system is roughly of the same calibre (DDR4, DDR5, etc) and
roughly for the same purpose (general system memory).

But it is quite incapable of handling truly heterogeneous memory systems
(precious HBM attached to the CPU, GPU's with HBM over a coherent link,
hardware-compressed memory expansion, network devices w/ memory, etc).

If you look at the history of ZONE_DEVICE, what it fundamentally does is
slaps an isolation mechanism on top of NUMA nodes because the NUMA
abstraction doesn't provide one. 

The problem with that approach is now you have to reason about a node
having both fungible and non-fungible memory.  It creates the need for
something like migrate_device.c when a properly isolated NUMA node could
just use migrate.c directly (with a coherent link).


One example of what isolation on the node enables:

A Private Node can hotplug memory in ZONE_NORMAL - which means it
can be GUP pinned.  That means driver support for GPU direct storage
is simply `alloc_pages_node() + pin()`. The driver doesn't have to
worry about something like SLAB accidentally using that same memory.

All without having to rewrite a bunch of mm/ in a driver, and with
having to do some kind of heroics with ZONE_DEVICE that causes even
more special mm/ interactions.

That only comes from adding an isolation primitive to a NUMA node.


> > Isolating private node folios from kernel services
> > ==================================================
> > We implement filter points in mm/ to prevent operations on
> > private node memory.  Where possible, we even re-use existing
> > filter points from ZONE_DEVICE.
> > 
> > Most filter points are one or two lines of code:
> > 
> > Combining ZONE_DEVICE and N_MEMORY_PRIVATE opt-out spots:
> >   -     if (folio_is_zone_device(folio))
> >   +     if (unlikely(folio_is_private_managed(folio)))
> > 
> > Disabling a service:
> >   +  if (!node_is_private(nid)) {
> >   +      kswapd_run(nid);
> >   +      kcompactd_run(nid);
> >   +  }
> > 
> > Disallowing a uapi interaction:
> >   +  if (node_state(nid, N_MEMORY_PRIVATE))
> >   +      return -EINVAL;
> > 
> 
> I'm not sure of why do we re-implement more filter and basically
> doing the same thing ? Any unavoidable scenario ?
> 
> re-using the exisintg filter would be nice if that's possible.
> 

We re-use (combine) existing filters where possible.

We add new ones where ZONE_DEVICE did not implement filters due to some
*implicit* filter already existing.

Two clear examples:
   - reclaim does not target ZONE_DEVICE
   - ZONE_DEVICE does not support PMD

Both cases result in private-node filters that otherwise would have to
exist for ZONE_DEVICE (and if ZONE_DEVICE ever grows PMD support, those
filters will have to be added).

> > Bonus Configuration: HBM device memory tiering
> > ==============================================
> > echo 1 > dax0.0/private       # make the node private
> > echo 0 > dax0.0/adistance     # highest tier
> > echo 1 > dax0.0/reclaim       # reclaim active
> > echo 1 > dax0.0/demotion      # may demote from the node
> > echo 1 > dax0.0/user_numa     # mbind()
> > echo online_movable > dax0.0/state
> > echo 1 > numa/demotion_enabled
> > 
> > This is an HBM device which is treated as the top-tier in the
> > system but for which memory can only enter via explicit mbind().
> > 
> > It can be overcommitted because it can be reclaimed (demotions
> > go to CPU DRAM, and reclaim can swap from it).
> > 
> > If the HBM is managed by an accelerator (GPU), the mmu_notifier
> > allows it to know when reclaim is moving memory out to do
> > device-mmu invalidation prior to migration.
> > 
> > Prereqs, base commit, references
> > ================================
> > akpm/mm-new - for Brendan Jackman's mm/page_alloc.h work[3]
> > 
> 
> Still thanks for the work, I learn alot from your work as well, thanks.
> 

Of course, and thank you for reading.

If nothing else I hope this series helps folks understand the page
allocator better (it certainly has helped me).  If there is anything
you think I can improve or better explain, I am happy to discuss.

I am planning a larger publication of all my research sometime in the
future, but I think code is more impactful and useful - so I am
prioritizing that for now :].

~Gregory

