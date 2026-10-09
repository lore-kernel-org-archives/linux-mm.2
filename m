Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6421CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5066B008A; Fri,  9 Oct 2026 07:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EB36B008C; Fri,  9 Oct 2026 07:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FE86B0092; Fri,  9 Oct 2026 07:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7926B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:03:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC2EFA7C66
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:03:58 +0000 (UTC)
X-FDA: 85302802956.29.06409EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46093180006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:03:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXtBu0RT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791543837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4mVTD0NTqB9D7Gs5A6eFeOnRu4d7xcFVmW/D5Mtxo8=;
	b=sZ5oZDqDZ6P1m9tEuE0z19TL+fKLKnMVnI65VvS7NNvdXYoVO8/97dPVyU1MKU6+ywYVxX
	mIXYk1TDand3U4ICfGSa83rHWqzCcOUw6LJc9ar6JhTuBcuNwHpmYHYE9+zTzBBSO6nPmm
	H8ebWTfWulWCm3RvTkvfFEq8f7I/Oow=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXtBu0RT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791543837;
	b=f8xV3MyyfjJYathfrKqicYHMaZFmmZcJhnj0yR2Vpr1gUDtDzVe3XOdu2gAkiymIxxVzhA
	JM311oxGpU8kfTRZvHHoD40Tu+Gp9z5ilmTngzvhd66VBZsiOFKp6fal1cQ6gfujotJgxq
	HlkH5CLxCm6GdVcw21s/21PUrGP+Ox0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A42F60DC2;
	Fri,  9 Oct 2026 11:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400341F000FF;
	Fri,  9 Oct 2026 11:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543835;
	bh=o4mVTD0NTqB9D7Gs5A6eFeOnRu4d7xcFVmW/D5Mtxo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HXtBu0RToAts+Aarg/9eCHojiplI8SRWAbjZJ6AzKBdxw0FKyNvaKXojId2Nkjqww
	 t1ASGTPG2Y07P6986jcR6c3eTgzGuL+YOiIfDKKGcdRlGLJ2RBI7qGbvU10yvOlvmU
	 pYD6V4Vx8/j2m2xJU7i77Wq0cNDoCBUv2swu++strIRjoqi3bH8gxmgiPAZDEukJaS
	 hzyigALZCBtHoIiqHQfLQ2epmRM/lFsg70SWMAGAcUjVLfJGLUnA7N1tDhlRPwIu54
	 qajrwZQM+pH18Bv3X1rr2USxdSJT5+mXmMmMArjxj7+uelh3AMReqU9q1ArVGfffSS
	 zHQHc2ZMn6yXw==
Date: Fri, 9 Oct 2026 13:03:45 +0200
From: Harry Yoo <harry@kernel.org>
To: kernel test robot <yi1.lai@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [harry:b4/sheaf-size-round-up] [mm/slab]  ddf56dfc79:
 will-it-scale.per_process_ops 54.5% improvement
Message-ID: <asjIHAeuL1ilE4sn@thinkpad>
References: <202610091451.beda4ec3-lkp@intel.com>
 <asi-kgXfHJt6Gjp0@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asi-kgXfHJt6Gjp0@thinkpad>
X-Stat-Signature: 84ofumx7q3p6jry5dnmea59ay5moe85j
X-Rspam-User: 
X-Rspamd-Queue-Id: 46093180006
X-Rspamd-Server: rspam08
X-HE-Tag: 1791543837-924467
X-HE-Meta: U2FsdGVkX19SmlKWgIZtJ7Y0QCY/JzKx3cI0PyVEefFXxnlPhxeRa2zPEs5br8wxB9/ef73gLzfzzHejTL2oZomOw9E1sKdGE5b04ritMvr6+GeW5RzZPbjqT82nOX29TH2CPdRU3sVxAMH5aHl3VHk9NDoMqk8lyVvS0EDu2EZz3TnMmtfUibDp13FMaUwiZ/VBEvlaGw4Hv59EmDF887oxK4k0pHlBkWjliZoRfU8E0soYIwr77FEEtOpAVS/uALRD6k9pZiBf4OvLx1TCfCXMwVHeZDNAd8FPDznybfqRiohcPGHEEkzxuIgQAMzTU9r3w54HEolcYuPN1cHMJrokumEhPScHjDBOmU/XU1LrP7FTjzyh/R+R9HIZJwu9nL5bScJBQXRP/qYqrXHXN9IAnJBIkGGZYZu9IAkkaM0mnZZ2Lru4PZzVAR+QFjkmiSZ1zUIoM82ZOrXAYqK8wdSD0jzqbpHBuHLwwolYWLPEneE2o+TYXFuysJXpfw2hcqGcCodCpex0WqL66/oveNyGtYsImYgqA5RV4Dqvuv0XdiVyvY7YUBAxWjXm1r4OEyHyVokwsj48//qmXgQfo4ZZeaDVT95lV3pi5HoS7QwhTo5q3T5s8TVfZIHGytl8t87ZxbPI0ZPylREuxlYg9bMemDyITbetvsgzMwo2JpBLVMH80yK6neuTkrHFzXXbXvd8FpTQ9eXLgiOKn1GLES6OXnrlYKcC3g1KZAe8ZA6lgzXa506cxvVoHkllabr7JcuwV6qbWHAFdfOPbuFIUK3LDRVvmoXyqqgYA6fe+PwoBQEtWpHbo31zDCJp0wd0bLIA6yVGiKdKgmYbABnmI0qysQgiA+oIuxfjNul5NoYE0Mr/xNUhFg6gzb0320u/X/zTJQMDcGHkEl1S11/5HB7A5j9H27Tk/GuaDlZriGdPpaNgSmOeOMBNHL/XJUXyZS4ty8HNq2USdtVwVY6
 AmBm6kpn
 51A+W44OlYuooDr5IUOFxSbQyltMFQftOtzbs8qqroeEn9UbTAovekzX5K1qXMUB0c61yJsTgSegc9fClW1xDJlNWAOHbstCq9S/UwZ+Lt0ytaIWAXme0WAvO0XEATrHecDmOGUJE0Dn3oX3r41skK089zVPPez2vo3J+6r5gwz7ya2Kz01hRVGbYLr0oQurzRCV/J9+2wHOAzn0Cmi/LhuSQu/tueGVUhEclpyyK+/9w/C3ETUt9ivxcz0J73z8FVjB9zMLCmgyMijEkYct9grCs6EwNKW5ttoVlUsqYiBE/OFqehMfquD+vrS6qxcdVNWch0ZPssgf/UhG8iU2ytRG/DvTP3ObPLe8LrK12SnfbwPxaM+f85Q8wGHU2lPsy832IQSn/kAnsBtl9g6sd3RedzgB1q142/wC0xwTkGPpf5gCuAY8x3cP+IXmtcJ3LbU2H73PWmDCEJ9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oh, Vlastimil mentioned (off-list) that the performance should be
re-evaluated on top of Hao Li's recent performance improvement [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git/commit/?id=1b87ea06a34b213e45e3e0c4effd5043f15046ed

Ideally should be rebased and re-evaluated on top of
slab/for-next.... :P

On Fri, Oct 09, 2026 at 12:41:21PM +0200, Harry Yoo wrote:
> [ +Cc slab, maple tree folks, ... and Suren :D ]
> 
> On Fri, Oct 09, 2026 at 02:39:02PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> 
> Hi, thanks for reporting!
> 
> > kernel test robot noticed a 54.5% improvement of will-it-scale.per_process_ops on:
> 
> May I ask if there's data on slab memory usage for this experiment?
> 
> Performance improvement is nice, but only when we know what's
> the tradeoff (memory usage).
> 
> I think diff on Slab:, SReclaimable:, SUnreclaim: in /proc/meminfo,
> and in addition to that, ideally diff on per-cache slab memory usage
> (from slabtop or /proc/slabinfo) during the experiment would be nice
> to have to make a decision :-)
> 
> > commit: ddf56dfc79f5734d7b3aa8ba81f195d52b3e5823 ("mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity")
> > https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git b4/sheaf-size-round-up
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/commit/?h=b4/sheaf-size-round-up
> 
> Oh, this is a b4 branch that I pushed but did not submit to mailing list
> yet because I wasn't didn't measure its implication on memory usage.
> 
> The patch removes under-utilized 244 bytes per sheaf on maple_node cache
> by not skipping "rounding up to the next kmalloc size" step for explicit
> sheaf capacity.
> 
> Copying and pasting the patch here:
> > mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity
> >
> > calculate_sheaf_capacity() calculates the size of struct slab_sheaf from
> > the capacity, rounds it up to the next kmalloc bucket size, and then
> > recalculates the capacity from the rounded-up size so that no memory
> > is wasted within the bucket.
> > 
> > However, when the user explicitly specifies args->sheaf_capacity and it
> > is larger than the capacity calculated by the heuristic, this round up
> > step is skipped.
> > 
> > This wastes memory for maple_node cache. Its object_size is 256 bytes,
> > so the capacity calculated from the heuristic is 26. Rounding up
> > increases the sheaf size from 2 + 26 * 8 = 240 bytes to 256 bytes
> > (kmalloc-256), yielding a capacity of 28.
> > 
> > But since the maple tree cache explicitly specifies a capacity of 32,
> > the final capacity becomes 32 without any round up, and the sheaf size
> > becomes 32 + 32 * 8 = 288 bytes, which is allocated from kmalloc-512.
> > In other words, 512 - 288 = 224 bytes are wasted per sheaf.
> >
> > Move the round up step after max(capacity, args->sheaf_capacity) so
> > that it is also applied to explicitly specified capacities. With this
> > change, the round up behavior becomes consistent and the sheaf capacity
> > of maple_node becomes 60 and does not waste memory anymore.
> 
> It does it increase memory usage for sheaves because it's reusing wasted
> memory, but it could end up more memory being used as each sheaf
> now caches more objects.
> 
> > Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> > ---
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index f9b56cb439e709..4fa551bf02cd64 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7895,17 +7895,19 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
> >  	else
> >  		capacity = 60;
> >  
> > -	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
> > -	size = struct_size_t(struct slab_sheaf, objects, capacity);
> > -	size = kmalloc_size_roundup(size);
> > -	capacity = (size - struct_size_t(struct slab_sheaf, objects, 0)) / sizeof(void *);
> > -
> >  	/*
> >  	 * Respect an explicit request for capacity that's typically motivated by
> >  	 * expected maximum size of kmem_cache_prefill_sheaf() to not end up
> >  	 * using low-performance oversize sheaves
> >  	 */
> > -	return max(capacity, args->sheaf_capacity);
> > +	capacity = max(capacity, args->sheaf_capacity);
> > +
> > +	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
> > +	size = struct_size_t(struct slab_sheaf, objects, capacity);
> > +	size = kmalloc_size_roundup(size);
> > +	capacity = (size - struct_size_t(struct slab_sheaf, objects, 0)) / sizeof(void *);
> > +
> > +	return capacity;
> >  }
> >  
> >  /*
> 
> [-------<8 end of the patch-------]
> 
> > testcase: will-it-scale
> > config: x86_64-rhel-9.4
> > compiler: gcc-14
> > test machine: 256 threads 2 sockets GENUINE INTEL(R) XEON(R) (Sierra Forest) with 128G memory
> > parameters:
> > 
> > 	nr_task: 100%
> > 	mode: process
> > 	test: brk2
> > 	cpufreq_governor: performance
> > 
> > 
> > Details are as below:
> > -------------------------------------------------------------------------------------------------->
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20261009/202610091451.beda4ec3-lkp@intel.com
> > 
> > =========================================================================================
> > compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
> >   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp1/brk2/will-it-scale
> > 
> > commit: 
> >   675a745c61 ("EDITME: cover title for sheaf-size-round-up")
> >   ddf56dfc79 ("mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity")
> > 
> > 675a745c6113e420 ddf56dfc79f5734d7b3aa8ba81f 
> > ---------------- --------------------------- 
> >          %stddev     %change         %stddev
> >              \          |                \  
> >   70440501           +54.5%  1.089e+08        will-it-scale.256.processes
> >       0.30 ±  3%     +35.9%       0.41 ±  8%  will-it-scale.256.processes_idle
> >     275157           +54.5%     425248        will-it-scale.per_process_ops
> >   70440501           +54.5%  1.089e+08        will-it-scale.workload
> > 
> > 
> > Disclaimer:
> > Results have been estimated based on internal Intel analysis and are provided
> > for informational purposes only. Any difference in system hardware or software
> > design or configuration may affect actual performance.
> > 
> > 
> > -- 
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki

-- 
Cheers,
Harry / Hyeonggon

