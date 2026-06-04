Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9701ACD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 08:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A603B6B0005; Thu,  4 Jun 2026 04:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10566B0088; Thu,  4 Jun 2026 04:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900246B008A; Thu,  4 Jun 2026 04:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EFC66B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:36:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14924406B6
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:36:37 +0000 (UTC)
X-FDA: 84841574034.12.190DD7B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19A47C0004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:36:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OWvZrvSI;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780562195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOxxBGCqGPcmxW8c5748w9UZojPmDniQUCAc18TCQK8=;
	b=BAe+Ffn29DHNbghqvHERPStpr2UKX62IpjS8GxWAaomzYnjb8vWHImieV5gxh737BWKTZH
	MznTubCIsGtY77h1LFaTRXCw2uqqU8zPKoGfpu7T+54+ww0mjQD1azfiS3nRlRVrhb8L7s
	9GRdQTQ6Sgyk+giDC1cg2QZpM2yFZ2c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OWvZrvSI;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780562195;
	b=7zoZ2euKWamUKghiGftevNvEOJ7qGojEENPm2mp1McN1BXxm14YwLZZoPTa7Ww7Gb23SIE
	JXz98hfB7LnZ/XtImFDs/lDd6l33bXfGcAAskNd8a+3bXPnAhQtX3ec7C6wcW5fnTnVLYt
	g/c0PBo4O74/XDNtPD8w7Og1dD9uKnM=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45eee266c6cso322334f8f.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 01:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780562193; x=1781166993; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GOxxBGCqGPcmxW8c5748w9UZojPmDniQUCAc18TCQK8=;
        b=OWvZrvSIVZmZrMSZw/+MsTO+rNHyLP6Nac45EF9Kwp82JI/eCjELkcOGzsmORBuk1x
         2Wfza3IrXj76sIompEICHAnLNx7eLY5XpAKo0zqD6FSlhygPGA8ICkVrX9aM4DJFOsHr
         a+LiTTLAXhmMNMjlFzuJtugR9znykqwSpF/bFWlkcRd7AHjudpz6EeOqaOmG5rN3jkmC
         Y9taj5FNxQYXZBg20ij8jq0/VAd7u/qeLoFnxSEtH7Djr6Ffs+uKIQ8++dwZBGRY6Vjk
         3HFomhjmAQefIYThh1lRRex/WCQ6l9Z/yDW7D9GZqst5TPAgNrAhl/+21V4VxLGd+5bb
         gz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780562193; x=1781166993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOxxBGCqGPcmxW8c5748w9UZojPmDniQUCAc18TCQK8=;
        b=Q8eIuI4kkseKgh6kk/co6Zu7m7g+M/rY+l0dNhiwmCDrhqFCKqqhHZClm90+qLGB54
         VHIFbiR44QJXDZxHebhCAmNbMLJWchMaAshJ5ugJgC7R7kx6yPrthg1+LpFErOfnaVne
         Vo8Qud3wbGZxvf2Zq0xdt3q38FxChIBDEM5uS7pvlH6E9isNBBggGOS/0KGQQC8DS0OI
         H1ZL5kiaxVOYPXiZP0u4Zz1qBG5uC7/4Nsgg5QAwgZ2I3WmZDKfY6yk/fAxpUs9evx6i
         HKYuBdBbTP4Eg5eJDWVeCbQp6V2BCAE8w2vS1RCCy3jcVRPyt7o4yAb74ETKP/1Hm3OW
         pVYw==
X-Forwarded-Encrypted: i=1; AFNElJ87UiQieeW+tO+X3iib8UdaH1+R7ZnqcgObQxHDq/Wo5d+qFzOOZp5SiF+4bdTOyucdL8thdQgp3w==@kvack.org
X-Gm-Message-State: AOJu0YzAQU1rWRARORz2nUY9oAPd36YglW2WlGbGogm9koF4saRm9XH3
	Abfd+Za+ClRFfHaFlUq/D3xh3fE51rcsfdLGZ4QOnxPQTLf9K9P0ZdnaBXtmOZ+EEno=
X-Gm-Gg: Acq92OGxgA7lqI49KbjIia3wVRhMdVZqf2+zsGi4MILULURtfNRrvp1N2EBSLSQEJIA
	eikSHWhKTOUStaz6+kSIAaKQzWB48E7XJdA2d6oHhrpII3EsXfKoRlpCFU7DiscjkDSkeFTliTB
	2vepWHm3LsI4yydjZ6Zd/4/YKD9UZ7rHBaYwOI35VZYK39QKzWlvhVcwkkLCJWtVXwckOe/Cixb
	HFxDPSSr1UZ+3wBt1Zf+9bGgTSsuq4I/K+qfS1Op1C2gU9TKVZDudT2ZMdlzE0R84E5Vab2dj8q
	2o36LjgCDmcDd0Ue2MtcU4TwsCVqV5nSLtRu9vCHXgEDED86ZPkBGb+iwcTNZnNY4t6UNvnjkly
	D18dYSp81ZbQ15RIt+eg2Eb5zeCiE8h4XBq5G0JYpfDlme5rdBm41LC1WIDvuxrXXthYN2Anie/
	Pk7Onm1f0ckdKnxyHXtcysZA8H6p/+eiRkAGK88vhZCQ==
X-Received: by 2002:a05:6000:4a02:b0:43d:50c:6f33 with SMTP id ffacd0b85a97d-4602194fc19mr9571400f8f.26.1780562192938;
        Thu, 04 Jun 2026 01:36:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::7:a76c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda363bsm1765818f8f.31.2026.06.04.01.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 01:36:32 -0700 (PDT)
Date: Thu, 4 Jun 2026 09:36:29 +0100
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
Message-ID: <aiE5DZC8Io4SNI3H@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <ah_RcTU8SpQG7hab@gourry-fedora-PF4VCD3F>
 <aiDVMgu0viTIml8H@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiDVMgu0viTIml8H@parvat>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 19A47C0004
X-Stat-Signature: dg6ihzmmqxcw1iqja87ijrfxyszhi5n5
X-Rspam-User: 
X-HE-Tag: 1780562194-414213
X-HE-Meta: U2FsdGVkX1/Ur80qTFaFHjBNRh3N6SYzMrGjrYAG2DYJ8E5tqtROOTxyp47bN2Svm7O6xfpCU1HOVKezT095XGsJRVlLYnw2+M7IeXAiwMEAcpNBx4wxZjU6hnZEuPtw+j/QL5WXcneCwxWS1NEu/2XeaNENXw3koqM3CJVHq5/kNubsVpH+riiAvsXWyIOkLvAwSiXPzJsBcP3feh+0aGH354cB49nZskeVZKrDkaz4iUh7/7hJQFO248YNhRQFF9DREaC93EQ/6R83SwSyHg4cBUReJJjqVsjmIVMqhEEeXkRoPqETq+p07crJ92cs/LD7GCHs2V43JlMF3Fl91IYDDubNPIP/b3a+bhY1pdbgeSqRi8IJOHt7IYoFQNvJNhXJtJcqE7HweUwNZK+nMjC4bviM4JFHIMUmourEaNAcClDQckaau11mps+4YklvYw56a7iT1DT2LI+owNmQnDSxNvfGpvOCtB28r8S1p8Q6J5Sz138Vgpe48hKsPCM+Bvzfh9C5Q8yHNf1RZ/ZdiqP7I80c5caMmKO1UiYJ2tVwXn83ya91NXLe5xr6u7s8rOqkCXkLHwzsocR+D2VmkpmhMb4WztPmV419+aeX3Az5uE3lU+2HEnLoXlP2Hk6AxtOCGDwoV7lzfXZ3NHU2bDquu4DUdqhFU0hE0aBqWhmQQT2RKy6c12N18v0wlb3csFEhj9aZGrOcIuwMxYU7fw1FnGz+XK7oT4ZjbjlccpWqwPPqaSqNFKSbXTlm+tjHtnsZuYIt/M+KxkPJCL6SdQp0IR0+anbK1M083dIUWv9bzWcBkHAafosMbhXJ77jBtXFQ7T4LHPiG9hI8SMkz1oLBkHwhPBMY2PytkQY8Haj6YlUqwFNggwMjI4ivNg3n4oxy58/Iq4WRqZwCvzXXq7XMB+4DnrwxenCYiwzPa6TXU6JQLWdZV/Bc42hGPGHQ2cHAkIIkifd78XM4fbx
 vYZCf4L+
 YxnC3v28f7mC9dCnbxpjOSo1VKzkd56MHzvzblTYqsGNUthsFINmZ8yEsGla67ZD+J7HC0wWlLD7JrqwTGGCYY4F/V1hZWB/hf7FRn7K51eQeh0xmoLRYOZHMCIqxH08ZNJtPwkye6Nspjx0qptiwDsWBZeiDS9ksyyCkCiy6aEeMdSAqQWGvc3X9yFQL24PsQRTrT6Nccm6KTXiESf2dhGnx5pBUiy/12yCjy0qrnGd/Cs+pYgqE/Jd2c6Ac00pmIw8WrX0QJHulGDBtSZ0PyAqtSBxVe0ErOhHgPF1OfVixNotiIofRJmP3zCJXsrcxa0x2/WY+wz2xNJYTbOCy1nsbne/9tphbJFpZRYuoSmqL3px4glUXeDD9TIkC07sOKDBSJQglnFiJ+gmjXiUOR05eTuLCXJlh5s/wtQVH4SZlBXTwCeDgKaJo5QUYOrO4PZ8t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 11:43:14AM +1000, Balbir Singh wrote:
> On Wed, Jun 03, 2026 at 08:02:09AM +0100, Gregory Price wrote:
> > 
> > Here is how the page allocator fallback lists and nodemasks interact:
> > 
> >    Fallbacks A:  A B 
> >    Fallbacks B:  B A
> >    Fallbacks C:  C A B   (Private)
> >    Fallbacks D:  D B A   (Private)
> > 
> 
> Do we want regular memory (N_MEMORY) in the fallback list of device private nodes?
> The assumption is that we have ATS translation enabled? Assumiung A and
> B are N_MEMORY here or am I misreading your illustraion?
>

If we don't have __GFP_PRIVATE, then probably not.  This is a holdover
from the current __GFP_PRIVATE branch so that if the preferred_nid=
value is a private node (which is a hint, but not a hard control),
there's a way for that allocation to land *somewhere*.

__GFP_PRIVATE would say "Only allow access to private nodes if this
flag is provided - otherwise treat that as unreachable and fall back".

(__GFP_PRIVATE | __GFP_THISNODE) then does exactly what you expect (only
allocate from specifically this private node and don't fall back).

This has the added benefit of not causing OOM on allocation failure.

Some would consider such a request a bug (i.e. that caller has a bad
mask), but I find the premise of that statement to be flawwed if only
because we do not have good controls over what ends up in a nodemask due
to the existence of things like possible_nodes.


> > If we wanted to change this behavior, realistically we'd be looking for
> > a way to add specific nodes to certain fallback lists - rather than
> > modify the nodemask interaction in some way.
> 
> Yes, that is what we did with CDM, control the fallback for
> N_MEMORY_PRIVATE, but there is a design decision to be made here.
>

Agreed, but also one which can be deferred and played with since it's
all kernel-internal.  None of this should have UAPI implications, and we
need need to accept that we're going to get it wrong on the first try.

> > 2) full mempolicy support doesn't really make sense
> > 
> >    task mempolicy PROBABLY should never really touch private nodes,
> >    while VMA policy certainly can.  Assuming we're able to support
> >    multi-private-node masks, none of the non-bind mempolicies even
> >    make sense for most private nodes (interleave? weighted interleave?)
> > 
> 
> Yes, mostly, but is that baked into the design? If so, why?
>

"Baked in" in this case would mean:

  set_mempolicy(..., private_node) -> -EINVAL
  mbind(..., private_node)         -> Success

With appropriate documentation.

This can be changed later if a reasonable design was agreed upon.

> > 4) File VMA interactions don't entirely make sense with mbind
> > 
> >    In theory you might want:
> > 
> >    fd = open("somefile", ...);
> >    mem = mmap(fd, ...);
> >    mbind(mem, ..., private_node);
> >    for page in mem:
> >       mem[page_off] /* fault file into private memory */
> > 
> >    In reality: This does not work the way you want.
> 
> Why not? Just curious about what you found?
> 

Because pagecache pages are associated with potentially many VMAs.

The fault can be a soft fault or a hard fault.  On soft fault - the page
was already present, and will simply fault into VMA without being
migrated.

You can imagine the following

Process A:
    fd = open("somefile", ...);
    mem = mmap(fd, ...);
    mbind(mem, ..., private_node_A);
    for page in mem:
       mem[page_off] /* fault file into private memory */

Process B:
    fd = open("somefile", ...);
    mem = mmap(fd, ...);
    mbind(mem, ..., private_node_B);
    for page in mem:
       mem[page_off] /* fault file into private memory */

If process A runs first, and assuming VMA mempolicy is respected for
file backed allocation (note: it's not, see below) - then the second
process will think the memory now lives on node B when it's already
living on node A (pages are not migrated on fault).

filemap page cache means file-backed pages are global resources.

Re file-backed VMAs - see filemap_alloc_folio_noprof in mm/filemap.c

struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order)
{
        int n;
        struct folio *folio;

        if (cpuset_do_page_mem_spread()) {
                unsigned int cpuset_mems_cookie;
                do {
                        cpuset_mems_cookie = read_mems_allowed_begin();
                        n = cpuset_mem_spread_node();
                        folio = __folio_alloc_node_noprof(gfp, order, n);
                } while (!folio && read_mems_allowed_retry(cpuset_mems_cookie));

                return folio;
        }
        return folio_alloc_noprof(gfp, order);
}

We'd have to hang a mempolicy off of the file and use fctl or something
like this if we want a file to have a node preference.

> > 
> >    I went digging and we need a few mild extensions to allow
> >    migration on mbind to work for pagecache pages, and the fault
> >    path does not necessarily respect the vma mempolicy always.
> > 
> >    You also start getting into the question of "what happens when
> >    the node is out of memory and you don't have reclaim support?".
> 
> Yes, we should discuss reclaim support, I think we should allow for
> reclaim. It allows you to overcommit private memory the way we can
> with regular memory.
> 

Reclaim support is feasible, but again - crawl, walk, run.

If we get the base private node infrastructure in place, we can break
things like mempolicy and reclaim support into different work streams
to enable support for these features.

Different private node users will be interested in different
combinations of mm/ service support.

For example:  compressed memory as a swap backend DOES NOT want explicit
reclaim support - it will need to manage its own shrinker.  This comes
from requirements associated with that specific use case (which I do not
want to get into here).

That is why this series introduced the concept of NP_OPS_* - so that the
owner (driver) of a private node (such as a CXL-enabled accelerator
driver) can tell mm/ what services it should enable for that node.

> > 
> > For all these reasons, I think the be mbind/mempolicy support with
> > private nodes needs to be brought in with follow up work - not
> > introduced as part of the baseline set.
> > 
> 
> I am not opposed to the follow up work, but I feel mbind() should
> be the fundamental work and user space API.
>

This is informed by a single use case / device.

There are users / devices that don't want any UAPI for their memory,
but simply wish to re-utilize some subsection of mm/ (page_alloc,
reclaim, etc).

> > 
> > I am arguing for #1 - the community has argued for #2 and "fixing
> > existing nodemask users".  I think we can ship #2 and pivot to #1 if we
> > find fixing existing users is infeasible or too much of a maintenance
> > burden.
> 
> Again happy to discuss this, I'd like to make sure we agree on the
> design. I am wondering if there is any experimental data to choose
> between 1 and 2.
> 

I am trying to test whether, lacking __GFP_PRIVATE, any normal runtime
operations access private nodes removed from fallback lists are reached
via something like the possible / online nodemask.

I remember, maybe a year ago, there were per-node allocations happening
during hotplug and that's why I originally proposed __GFP_PRIVATE, but
I'm trying to re-collect that data now.

~Gregory

