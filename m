Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3EDEFB810
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9C06B0088; Tue, 24 Feb 2026 02:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87906B0089; Tue, 24 Feb 2026 02:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93426B008A; Tue, 24 Feb 2026 02:42:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 941A66B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:42:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5576758F8D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:42:06 +0000 (UTC)
X-FDA: 84478556652.13.C9CBBE1
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81E6D10000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:42:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FVIy3nip;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771918924; a=rsa-sha256;
	cv=none;
	b=VqMr7aUOtjrc/Buu47B6MlHFU9lYBK9QYQP8nniBsmdS7c7M+IQ2CeKjNgwZV4hHPUII+5
	EHOseF+V8H5WN+TGzIQUtkz1hmREqsHcXf9n+5qWMDXdPaWgMqM4Oj9hsjl2pjSdzONRm7
	BH25971IfFas5Em9UaBhT/OV437s8/8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FVIy3nip;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771918924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zT9YzPCoksVoJcqmXd6fTgUCdxBZDV84wumpFiQtY6k=;
	b=zopzwAf/qyEuiu008nkkjpOuQp5wWqqyGqY6SQgbTAn7wrHB2/u394hPmpJkLGkTrXyRGM
	w+lI8q6bDUHzRniFyWEfYrXXNsixJoP+eISSS4FUeMlQCwthlXxBK4fwoD3GvzG1ecpIvi
	ZRHuSCLPi4tAjCVY7eWjsYb9fKuuvS8=
Date: Tue, 24 Feb 2026 15:41:48 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771918922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zT9YzPCoksVoJcqmXd6fTgUCdxBZDV84wumpFiQtY6k=;
	b=FVIy3nipedxexE5diClbl4ElzKAAtZOOa1jRM+QOouuy4Ila/wvTpxKTG6+lnXW0BSIt7B
	S91FgziUudYDj92WoD7yogBCTn4fDNL/3zgUGaN7yMQV0/odGXTwmeC+czdT9arBC5ikEr
	bSWQ/jPqm4si68QkDREomezQfgFf7lE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <3efkqez23cmbwusugq34u5culryyi5emvocrxxdhxsgphqhx6y@e6kw4t3w3n5o>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <wprja2flkybpsmdpnihtxp4usbl4fdsayarg4sitnyn3leis5e@vdqas3zhqndw>
 <aZ1O82QsjwZVTvzc@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ1O82QsjwZVTvzc@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 81E6D10000E
X-Stat-Signature: p9e81xk4mhezixuazca4o3bknhnf8p7c
X-HE-Tag: 1771918924-454121
X-HE-Meta: U2FsdGVkX1+XkUEDWmIQIKGkV7vo9wmdg3wj+XoV2/Mu8KNVBNZkzhSnYiyWfCIozxFpWjWHEJJJKz8cbCYgs3BVx13rxrJVcburSNbJVcvdWKZdE3lP2nPgR9JJnRO+qTUSiIgwUeGbZdG0ncI4Sbw/6tOV+QeEOv31pJdB4NecJTX3PljCkjkMx5rHHVIZIQIdw6De1nll8HvddKI2jIcosZBkWb2gLomuvWP4+8GclsQExNkMOmL2NlhalWDvyeiL2ItvBUQbnDvjLrYq6J6xZmbEZ6EzY9OxT8FRG63xTE6BMHoe+7s/rTfubEWlxxij+lm/6W2oCFV+74cNiGpewhxtyrXC8EvXZzI8Ejq+tpLD/DzGdGePaCKB3cFZgQhVuFDGDuHxHs/7V6uydfN5Qf1+9mhFXHJPw0E/knAWf/cVCs6ww/GxNA7h2kSTj9noDAJ2vTBArZ0sLH6OwIgcPj1ZUbWnLgYj9jVIPHvI280d+x8OY7AoGfj72HhX8eeXGRNGb5mY5PQ57KAMBIwPKUFl20Wq2fEjoRDvtau1yknOViWOj3MK4q8LT4L3FUiUb2h3GtbA5Kgnw0RTecRcVRDp4RtG6H+dAi8kozz8Jz1/3MRIROqlziKjKPM06g71ymmOmijEPt/j44GUkYf7HyFtbNiF6WT9Mr8/uaJVNK+hh+lB10xPYqmfpHFls1fI/XE6mnfSW+hH89+RjJfK9maxitmzO4bk1g+c6Rub6HYcS0OUuszcazmd8mT13iE0EsCrvfTDKUuVqjDQdWAlSzybODBhqrFrmXTkASr+AG9/TWVLcyhEvngoUr8Wb0BRfBKeOi8UsKzePFgzGcQ9mLygwpLrPTd2a7Mtnqgz/eTMck7ZqTUb7dbJEzRNaJqaDnTnBEZvr5bfT2693xGYhI3vv/xw2w71ofT6ZCJSOIuP0ta1Zhro5WVl+5LkCl65uLY1+3juCbCVDtA
 LMbidJcw
 7wVezdNBfFiZrgPWQC5P5zzealjXOsEUVEexbU91uyae8uRAlMvS/zgvyP2qCqsk+q37vD+OThSrehpEc6vsVkZOPvGQf2FxRwJAGUY6706UAIkozxOtmWH+I20gQ/D5qf5NTLaUenjf8+6PC5mCUQgjl0C482M909LAHspxBaKysYbYZxhcuginoXQxZWLPXff7B6tlnfGn9J8A4XoZTcQ5jdwCbP5JI5GurKDaL+5SKKRaauzY2w3dlWd8OSY6jNdkN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 04:10:43PM +0900, Harry Yoo wrote:
> On Tue, Feb 24, 2026 at 02:51:26PM +0800, Hao Li wrote:
> > On Tue, Feb 24, 2026 at 10:52:28AM +0800, Ming Lei wrote:
> > > Reproducer
> > > ==========
> > > 
> > [...]
> > > 
> > > the result is that the allocating cpu's per-cpu slab caches are
> > > continuously drained without being replenished by local frees. the bio
> > > layer's own per-cpu cache (bio_alloc_cache) suffers the same mismatch:
> > > freed bios go to the completion cpu's cache via bio_put_percpu_cache(),
> > > leaving the submitter cpus' caches empty and falling through to
> > > mempool_alloc() -> kmem_cache_alloc() -> slub slow path.
> > > 
> > > in v6.19, slub handled this with a 3-tier allocation hierarchy:
> > > 
> > >   Tier 1: CPU slab freelist         lock-free (cmpxchg)
> > >   Tier 2: CPU partial slab list     lock-free (per-CPU local_lock)
> > >   Tier 3: Node partial list         kmem_cache_node->list_lock
> > > 
> > > The CPU partial slab list (Tier 2) was the critical buffer. It was
> > > populated during __slab_free() -> put_cpu_partial() and provided a
> > > lock-free pool of partial slabs per CPU. Even when the CPU slab was
> > > exhausted, the CPU partial list could supply more slabs without
> > > touching any shared lock.
> > > 
> > > The sheaves architecture replaces this with a 2-tier hierarchy:
> > > 
> > >   Tier 1: Per-CPU sheaf             lock-free (local_lock)
> > >   Tier 2: Node partial list         kmem_cache_node->list_lock
> > > 
> > > The intermediate lock-free tier is gone. When the per-CPU sheaf is
> > > empty and the spare sheaf is also empty, every refill must go through
> > > the node partial list, requiring kmem_cache_node->list_lock. With 16
> > > CPUs simultaneously allocating bios and all hitting empty sheaves, this
> > > creates a thundering herd on the node list_lock.
> > > 
> > > When the local node's partial list is also depleted (objects freed on
> > > remote nodes accumulate there instead), get_from_any_partial() kicks in
> > > to search other NUMA nodes, compounding the contention with cross-NUMA
> > > list_lock acquisition — explaining the 41% in get_from_any_partial ->
> > > native_queued_spin_lock_slowpath seen in the profile.
> > 
> > The purpose of introducing sheaves was to fully replace the percpu partial slabs
> > mechanism with sheaves. During this process, we first added the sheaves caching
> > layer and only later removed the percpu partial slabs layer, so it's expected
> > that performance could first improve and then return to the previous level.
> 
> There's one difference here; you used will-it-scale mmap2 test case that
> involves maple tree node and vm_area_struct cache that already has
> sheaves enabled in v6.19.
> 
> And Ming's benchmark stresses bio-<size> caches.
> 
> Since other caches don't have sheaves in v6.19, they're not supposed to
> have performance gain by having additional sheaves layer on top of cpu
> slab + percpu partial slab list.

Oh, yes-you're right. That distinction is important!
I think I've gotten a bit stuck in a fixed way of thinking...
Thanks for pointing it out!

> 
> > Would you mind also comparing against a baseline with "no sheaves at all" (e.g.
> > commit `9d4e6ab865c4`) versus "only the sheaves layer exists" (i.e. commit
> > `815c8e35511d`)? If those two results are close, then the ~64% performance
> > regression we're currently discussing might be better interpreted as returning
> > to the previous baseline (i.e. a reversion), rather than a true regression.
> >
> > The link below contains my previous test results. According to will-it-scale,
> > the performance of "no sheaves at all" and "only the sheaves layer exists" is
> > close:
> > https://lore.kernel.org/linux-mm/pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir/
> 
> -- 
> Cheers,
> Harry / Hyeonggon

