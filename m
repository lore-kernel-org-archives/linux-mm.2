Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942D5CA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B8E6B008A; Fri,  9 Oct 2026 23:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC8B6B008C; Fri,  9 Oct 2026 23:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D9E6B0095; Fri,  9 Oct 2026 23:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F106A6B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:10:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CDB71A06E6
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:10:49 +0000 (UTC)
X-FDA: 85305239418.10.CB39E0E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id AB324C0003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:10:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gHGcEDFt;
	spf=pass (imf22.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791601847;
	b=66Ljt/SXrjtdoQ3MGu88/PceV76sQFjHyGmtSdX/z4GE5uxzhzWNARnpUQw6Vf+9CgkwoO
	omAAGPPdAHVL9aRPVDwEl/TAt+ofyUQ85eJbCadXSfwD/mquP92t1aGweUxwf9nZ251P0I
	A5mEBiCvoiW5d+d+jcYFFzu2ys57FI8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gHGcEDFt;
	spf=pass (imf22.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791601847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBo3sJEODtnP3NVCGB9iUPQRQxcPlnbM5JA6/Xcx3pA=;
	b=R67e6pTMrWNw4JFipu93c2CKt0ohZhl7LEKKnqsNd1ZkB1ItgdVI1viE7/WNUJqMeQiUgX
	5qO816szhiFA1B4FYucIyC8qrhwMp0dkucTqd3+nCr+PY8uCroZJRQo4h8oLvd/4Q0KYvo
	rR+doJXzvVrjqyq4PFrZbkiDTWN0PQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791601847; x=1823137847;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bVpuCD+EEZtnTq1oyDHFaTpdSs9eU79YhNwzhyjvIh4=;
  b=gHGcEDFtEVOke+uiRM7ZBZf4yME3kBUWjOD+8/z79g1JWFX1oz5amoOF
   mC5Pq8TWjCfy06XOYYLWMyfgOASLyjxF732oVd9FoZb5XJHTIoOgpAhLQ
   oOAvw83i28AWJH2q77IQOJLgbNqTu6Dkao9Zue7cMH5v6/GQ3RazoPv48
   bX6Ahtqe6VE43ajdasB075r0dHb36chuidxQimqRocSKCzQIj85/FSDnI
   LjdKsFKx6EP7dS47iDg7zRpDt965gr4XwBKt4+ixjUNX8CuYEyLgj2KXj
   7tmfQ5GC8sCYqHkKEmfb8dh+BstuSxhH7qpkJYiLGGXR0iA9IP9B1DYi6
   A==;
X-CSE-ConnectionGUID: t1W52NnPSP+RIIuDJ2dcDg==
X-CSE-MsgGUID: o0QOrzx2Rx+24s6DGhay9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="289235"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="289235"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 20:10:46 -0700
X-CSE-ConnectionGUID: l/p3fCV8TeqJxJx4GcL7bw==
X-CSE-MsgGUID: 91kFolfjSxi5/SIbMZm+Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="2283965"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 20:10:41 -0700
Date: Sat, 10 Oct 2026 11:10:38 +0800
From: kernel test rebot <yi1.lai@intel.com>
To: Harry Yoo <harry@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [harry:b4/sheaf-size-round-up] [mm/slab]  ddf56dfc79:
 will-it-scale.per_process_ops 54.5% improvement
Message-ID: <asmsrokhdpPbongD@ly-workstation>
References: <202610091451.beda4ec3-lkp@intel.com>
 <asi-kgXfHJt6Gjp0@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asi-kgXfHJt6Gjp0@thinkpad>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AB324C0003
X-Stat-Signature: dnypuj1sumo3twwdre4cs5wbqc5n7xqs
X-HE-Tag: 1791601846-156603
X-HE-Meta: U2FsdGVkX1+yJVptRh9TG4ZVr1yxtKvqUY1NYdiRslyo4PSxOaPxSgPUtX62Ws3wAu2OvVTsDJ39r/TFn9moQ7Aq+VkpthwyW+HwigkTf4pVRoK9wixU3GS+FvKUgTUYV1VoaoBIPk8GzmAAr3/xdEqbNYfpoDOirV4shb8oA3I9rKBY4C3yF8i+NDmM3ct9jogm+PlfKgQ9YvGl4Nd51d8+OC2eL9lORucklyBLYgFGTq67PeL7bRuTmhG6M3Fzpv1E1CabNHugEHCq18nrNsa4aBWqXC3r2FymRKUGj4bn4npLnKKCNTD2qy11spjw7uutFTH/tS2jVG6Z2+Qy4+arjSELXK/jXuo/ZE3zkeav0+ZE3Fv2perqRgsnzhv6bN31UvNxOoImm3I+3sAVuoz27gpZi+zgFDap32cyD07+J3ADoY9HHaipMCNxA1UbRU0jOiadHc+VLq+WFmpBwT+SDJ37EYgaqJg1BRKO91l+jWw783DyK0XyEhd6IdrYxV6Uxj1eoJk6lABIVFg8P0BPvx8nIg9By3WlsSq2npcOfvH7ohTXTi4p9rpBUJ3BJ8rHp+xiKvp1Uh8YVAoBgnRDWrgiGnTudXPGnTJdPpPnGOb1amNgfzscuWyjHS1BQnGai21hEQ/n2OtWFzn+qmVHFSdN/IhGP2Z6sJWkPRZTPLiHLenC2qgk20oNtslWiYwzHnh8i8DF4SJpUvLn7C99+H/k4XIGWjFO8a62t6MA5udUwlLFaJquN+6/BS/w61gGNKkQznG9CT4aiQos1lX6tH1m44OSyKpnWO4e2inD635/8wmIWMeGfGnKgGH0dN36ymAhHqhwyuoMaMDFxIH5MbjtCwFbVmqlLdxCES88TKQH5PDRXQPtWxP0Tcz1Kw3iujdFn6wBh9aFIkM6B2NCq/A1FBaqCRAKbZvz7Xvam51A9erQOIbh8onKbIOObshmUsR79ZcAzeRZUYs
 rN0RWTlI
 dk05Pk3d2lHaAx6o9iN6JD/zmZJGbMGt6TTN4wts/l1JwYec5UsoWfc4zGZaJlTxgbEsA9540JXTz0InktR+EfEWI0TdPm/Q87ZZkTWMVDtgfwfI9txmb1y8qT+Dos5RwUXO8EWT2fUt6zdyd9g9QjP9WkttLk6B6jgzo74q6uNOt4ce9uYqgV5Cg+aupmEVXNglp26suurW2EcX7DwzWZjdKi5Gfz2R+YnwPdR9x42ZBiModqIciQZFzs2wO80wlGCz2zeIHAuqeXX3fhvENI9S/2MB2Kss6axDD5by6yQR7i9UKxpiaRXKOpJmb2PQWVJAlFaP6M7pY1DLh6YjPqlZtcyejvH2GbJRQyBu28KOX5+0yPapbYVAIZ8rIIR6tStm6uF+YP80KSXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 12:41:18PM +0200, Harry Yoo wrote:
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

From the full results already collected:

meminfo.Slab: +37.9% (979712 → 1350738 KB)
meminfo.SUnreclaim: +46.2% (806254 → 1178980 KB)

Note these are system-wide, not pure per-object overhead. We don't
currently have a slabinfo snapshot isolating the maple_node cache
specifically.

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

