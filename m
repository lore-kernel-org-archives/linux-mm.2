Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A704CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406526B0005; Wed, 10 Jun 2026 12:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDCD6B0088; Wed, 10 Jun 2026 12:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCA26B008C; Wed, 10 Jun 2026 12:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E23C6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:37:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 970BE1C0D8F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:37:40 +0000 (UTC)
X-FDA: 84864559080.08.5E0712B
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id AC0CB20007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:37:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fKUF4fOU;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781109458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYADJHUyTsZxeNPAhkpfIZ+IyBSWkrAmnBG2JAxdu0A=;
	b=6bSbAHj80CJi2KePCcKqYk35XF6KL+fui7STWPCVMCQ3nmTIxKKqU2dTDqCrwL0u0gpwHI
	lDRlDekcvWEtz0octe2Fc+ANVG8ohY1hYpkaCBHYNYENH+mEIOAmvkagcMpo7RyER8/3TQ
	z72EG2wsmMOfDX6hcaa6/JjUxMl22KY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fKUF4fOU;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781109458;
	b=V5bvJAO5vFmRZ2FIey0YXacsiKuOmMCGKREbDg1bFsX2EV58GUJeuz7L2JF6qs7lv8b+Qj
	dRUtFx6gTAT+w4B47uCpviTeQowxFX+6B5Anp8e0DzMVFKHXcfb6Le193iqYI+wvv/Hejb
	81qxRuttwxAqzoNiywVXbOzppeuz2Ks=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5176bbb9384so68995691cf.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781109458; x=1781714258; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SYADJHUyTsZxeNPAhkpfIZ+IyBSWkrAmnBG2JAxdu0A=;
        b=fKUF4fOUb6uUuhiBFt6nTh16YoKc/EAYmJrEysoqOy0Is7sWoAkRp9FfD2jRXE4Wpe
         LagxYwF1pEV9c1adBsZ2DmoqtM7eh30J+wb0zLIopPNb7pnLHPYoPEGTjtD0lMpUyS6c
         QYnA/EAlhI9kQWfTjKjC/Xc/AYe7I8e8WzAcahLTG2kDI9s6MT5PORaOYwnxKPahukiV
         eSyG7OmpasMQhmqp//Xxt6r7x2Z+AL7k8Spr/vZV5bEYWfJA1hd/iYZLlDeZxqXtx4qq
         dWNcrYPqw/GbZSlE6vfN/6eLqROQwa/tjfx9B8BGiVVr/Kn3e6rNk3BpbMUsKOrT/A8R
         kTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781109458; x=1781714258;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SYADJHUyTsZxeNPAhkpfIZ+IyBSWkrAmnBG2JAxdu0A=;
        b=YRqNvkazw1Aj81G0IRJuqCcjvVMahHpk+kWEj6gheV3ThvXgB2l64xjPwB0ShLd7Aw
         7gIK2WDpyySepgWnGlUz2YBEMtX9WvZGfjwuxHF3neKaZVVbA08YwOceifOYdMQSeqd/
         ynHtMFBqZcBArxQUrNU10b9wvOn7Fwg5tTFgW/WSGnbw5lI21pOPXkJAlSz7A6lS9quF
         7p/6A6h2t/iJIQaYE94IqdSzb4hFKjAz6PfYiD+4RqcdUhQ+PCE0Twgle2qAQ8OBkAFz
         X33X99PouHKzvEFq6yBWqOx29PdUvG19AA8F6BoKvdzSO7cRmy501i3IxtyiMzRkknfP
         Qs8A==
X-Forwarded-Encrypted: i=1; AFNElJ8t+3JXsemyxCQq/wSEOssNNzwuK+iacYlDKuMVlMoMGnLq5L8sTfklLZ9kPqb8TPR0fmKls0U43g==@kvack.org
X-Gm-Message-State: AOJu0YytdnRnEFO5+e1k6V26ucNKc1b/f37Ldbfz2xLLa5RFWZ6qoll2
	lDcA+GSuvQfXpxakapvpVntXw/yYS0egLsa6I6OCXJn27TzbK0TuWVQg950OzQHd3k0=
X-Gm-Gg: Acq92OHsbUtEJGgVak4S1ybCcqU12AnY9DqPTxKCvV5ywDPvOHLG0l+BlqEHPmEceeD
	TOnLyOKjNftok16bxOXYNTRvXC9qJCrQAp9nfg7HXwXTqiDo3Pk4h3DB3f/sqbk+gmwNZRgH+ZX
	j/eMfRo/JCRl4xq/K5RqUZR3E9w+EODnTsQ0GIptwR9oa2HhSVw3mMWX6BxBlBm+juhAz3tzDuU
	qXXn8l0vELx8rZhwbIPy586yV1szVuv8lLHzppFTAokx+QPXUwO2M09WWdXRkgPjtFHIQX17b+O
	YjZ3/JZVEZqELg0Fmf/ihcvtyLrWSUaXiakKNpy3oFOLCeWHwm/dRWXu+y1drz9lUUPr/GwuQHM
	GZbvvUlBR5HwyL17Eg661tVvOfrabWmfHSFth4XaM8Zuuq2Md8wumqSLc93A/cRSV0fzEknjDSz
	+dE/jtpNL7ue32MS7ZKrvres7J5Qf9ElWLXPXz8goJIxjXWNVjpJZW7C1zP1YS148sKV2WyT54N
	iWvgndy5VXU3b7pmQ==
X-Received: by 2002:a05:622a:6205:b0:517:85e1:38a2 with SMTP id d75a77b69052e-51795c22a42mr365134121cf.31.1781109457374;
        Wed, 10 Jun 2026 09:37:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd06b701sm233484876d6.34.2026.06.10.09.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 09:37:36 -0700 (PDT)
Date: Wed, 10 Jun 2026 12:37:34 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
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
Message-ID: <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: eog93eojgogyodmuerw78n6iaa15kkdr
X-Rspamd-Queue-Id: AC0CB20007
X-HE-Tag: 1781109458-30277
X-HE-Meta: U2FsdGVkX1+qvL/JLfSF0uIBB3GLk71c9Bb3CLMDkylUtJN0rmCVj7psaOW4cLe7+Y1nW3kQcacYqnJxvG2Jb0mQVjr5CfeQUUQub8EYF+O9g6SX97kclCrPP69r5ajF0+8B2690CLcQHSp7/9+xprC0i0A9FQqDnoOtaOrMGDsjx7HTmVq/7hd9wEBArXiHMxTjMTIuwfkhld1qwzCWrMKLiXyThRjs/HKJkee8zJ0EtRR5XRiHoStks1xvTXrjnsHGldSnTN25OHt4wfAavNW28WRQt+22/+/0xz4c6FJDD6H88PnazLwlmGxZWceB4vNERBLi+/mdd2ltIPvpAieLiJ/Ls0HvWv5u/4uD9JjzeI5reC8r7L7tch1M1CKDVocWqJ1cNyPVHTqolCnSHhv1hCK/JjGji7a2HjRwi4wITymrkJRZMQYlUKqo6C+9c9mImEoJtBRI2cU6xIQMF6MaiI9Mso0/+uvGEs+RjNg+G9FMPnayaLtWICIZGK/nP59jv8VQ9MIyBSMwh5Zt11T4sbkpHvLI/xhhhyABAwSj4RHTWTrNaxOjaBJATB09o4XzADz/UsCm1aScdlHjDvH7qrnOyq56CMShFArwtqQ9S7EpFxxNjiu3qFhHynJDksOZDOaOx904NXUn1geR3Wkh8AiWdBugZo83o75IyDXwwC39FWLYmmmp2H2eu9l2KGoohdYMQWbQUZbikjVKdtRCmsn0hjDpE0vwOYfZyaYY6ObcU77A2sMhFzsZveTXF1Stksm5iFnEIme7tJ9DNH/f2EV4Yzr54vVtsLWF51oebt5YUvAEWNP0BrgCCUG9PErf+9atzBHBuQn4aq+LhvQ0UsReLtd+MN4xKgb8kJ74C5BKrrbC/6D6gnD2qZgXqOvLtgPo859/J55oH36WnPis9Oohw77v1g99Ws9s9mWK5xwitm3ijRAKUIEetp8a6kZjRUk19ldZL8kWIyb
 iI54NBmr
 P8drRmCUeibRZk2rC8sonjOYe2s+uueUoE09mEcjvVZFlDwF1f25yFwF4y7Ki+YgVP286KlA5toBp6h9ttcrIYMrmzbrfLBpX6jbaCODKe+1DSZDLbQuD3/DZreWZHO3F4lSb/5XDmQpkXoO5jX4kBQlCdofHkyr0Y5uQQnBu1N44ha5jE6zE7n4TVYe6N5uohrQ4S/4jyd10cZFb1q4M6hKavRNfvaD+bEtx7+zBb2qxzzXLl+HO+wGRxspKN0xvD9av8rK5x0b1Wxeua2n3jYaL/SEJkn/TLX2iz3l+EVIB3XdR8fzXoAMuK+w9zoW7f7sczE6x725239jNu0VFRxuFslnfmeMGIffySQt9myMk7DxnJ8wbrGSTijNYq/EEDDs4HDm+EcdewsVj1SxbHbsfyWSIa34V/KKHkrZk8mTbhEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:00:33PM +0200, David Hildenbrand (Arm) wrote:
> On 6/10/26 12:41, Gregory Price wrote:
> > On Wed, Jun 03, 2026 at 03:00:01PM +1000, Balbir Singh wrote:
> > 
> > Notably: slub.c injects __GFP_THISNODE internally on behalf of kmalloc,
> > which causes spillage into private nodes because slub allows private
> > nodes in its mask.  I think this is fixable.
> > 
> > I have to inspect some other __GFP_THISNODE users (hugetlb, some arch
> > code, etc), but it seems like fully dropping the FALLBACK entries and
> > requiring __GFP_THISNODE might be sufficient.
> 
> Sorry, I haven't been able to follow up so far, and not sure if that's what you
> are discussing here ...
> 
> After the LSF/MM session, I was wondering, whether if we focus on allowing only
> folios allocations to end up on private memory nodes for now: could the
> __GFP_THISNODE approach work there?
> 
> Essentially, disallow any allocations on non-folio paths, and allow folio
> allocation only with __GFP_THISNODE set.
> 
> I have to find time to read the other mails in this thread, on my todo list.
> 
> So sorry if that is precisely what is being discussed here.
> 

So, I remember this being asked, and I didn't fully grok the request.

I'm still not sure I fully understand the question, so apologies if I'm
answer the wrong things here.

I understand this question in two ways:

  1) Can we disallow PAGE allocation and limit this to FOLIO allocation
  2) Can we disallow [Feature] (i.e. slab) allocation targeting the node.


1) Can we disallow page allocation and limit this to folios?

No, I don't think so.

Folio allocations are written in terms of page allocations, we would
have to rewrite folio allocation interfaces and introduce a bunch of
boilerplate for the sake of this.

struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
                int preferred_nid, nodemask_t *nodemask)
{
        struct page *page;

        page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask);
        if (page)
                set_page_refcounted(page);
        return page;
}

struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
                nodemask_t *nodemask)
{
        struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
                                        preferred_nid, nodemask);
	return page_rmappable_folio(page);
}

At the end of the day, this all reduces to `get_pages_from_freelist`,
and at that level we don't really care about folio vs page.

__GFP_COMP is insufficient to differentiate between a non-folio compound
page and a folio, and __GFP_COMP is passed into __alloc_pages_*
interfaces all over the kernel.

Trying to detach these paths things seems like a horrible rats nest /
not feasible / will create a lot of boilerplate for little value.

(I did not fully understand this request when it was asked, I do
 not fully understand this request not, please let me know if I
 have misunderstood what you were asking).



2) Can we disallow SLAB allocation.

Yeah, but I think a better question is whether there's a difference
between alloc_pages_node() and kmalloc_node() when it all just sinks
to the same fundamental code in mm/page_alloc.c

Maybe there's an argument for something like NP_OPT_KMALLOC (allow slab
allocations on the private node w/ __GFP_THISNODE)

On my current set, I don't implement any explicit filtering at all in
mm/page_alloc.c - the filtering is a function of the nodes not being
present in the FALLBACK list and only having a NOFALLBACK list.

What __GFP_THISNODE actually does under the hood is just switch
which zone list (FALLBACK vs NOFALLBACK) is used for the target node.

For isolation w/o __GFP_PRIVATE, we're removing N_MEMORY_PRIVATE nodes
from *their own FALLBACK* list and only adding them to their NOFALLBACK
list.  That means to reach a private node you MUST use __GFP_THISNODE.

I realize this is confusing, but essentially we don't have to modify
mm/page_alloc.c to get the __GFP_THISNODE filtering, we get this from
the fallback/nofallback list construction.


Ok, so how does this flush out in practice - and why do I call this
filtering mechanism fragile?

consider kmalloc_node() and __slab_alloc():

kmalloc_node(...)
  └─ ___slab_alloc()     mm/slub.c:4406   pc.flags |= __GFP_THISNODE
      └─ new_slab(s, pc.flags, node)
          └─ allocate_slab(s, flags, node)
              └─ alloc_slab_page(flags, node, oo, …)
                  └─ __alloc_frozen_pages(flags, order, node, NULL);

Slab silently upgrades the page allocator flags here to include
__GFP_THISNODE - even if the user didn't request that behavior.

This is exactly the kind of "spillage" I said was hard to police at LSF.

Without __GFP_PRIVATE, we have to keep an eye on what around the kernel
is using __GFP_THISNODE and how.

For mm/slub.c we can choose to do one of thwo things

  1) 100% refuse slab allocations on private nodes, i.e.:

     kmalloc_node(..., private_nid, __GFP_THISNODE)

     And will fail (return NULL).

  or

  2) Do not upgrade private-node slab requests w/ __GFP_THISNODE
     
     This allows kmalloc_node() to work the same as folio_alloc()
     or alloc_pages() interfaces (__GFP_THISNODE is the key), with
     the understanding that any __GFP_THISNODE user

We can opt these nodes into slab/kmalloc with a NP_OPT_SLAB
if the owner wants kmalloc_node(), with the understanding that any
caller using __GFP_THISNODE may get access.

That's the kind of fragility I was trying to avoid.


That said, in practice, I have found that basic kernel operations don't
generally target use kmalloc_node() w/ __GFP_THISNODE - there's just
nothing to prevent anyone from doing so.

So this seems promising...
And then theres arch/powerpc/platforms/powernv/memtrace.c

static u64 memtrace_alloc_node(u32 nid, u64 size)
{
	... snip ...
        page = alloc_contig_pages(nr_pages, GFP_KERNEL | __GFP_THISNODE |
                                  __GFP_NOWARN | __GFP_ZERO, nid, NULL);
	... snip ...
}

static int memtrace_init_regions_runtime(u64 size)
{
	... snip ...
        for_each_online_node(nid) {
                m = memtrace_alloc_node(nid, size);
	... snip ...
}

static int memtrace_enable_set(void *data, u64 val)
{
	... snip ...
        if (memtrace_init_regions_runtime(val))
                goto out_unlock;
	... snip ...
}

This is the *exact* pattern I said would be hard to police - and it
doesn't look like a bug, just not informed that private nodes exist.

This is why I'm concerned with trying to depend on __GFP_THISNODE as the
filtering function.

That said, the number of __GFP_THISNODE users is very limited
kernel-wide, so maybe that's an acceptable maintenance burden?

~Gregory

