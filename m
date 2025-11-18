Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59EA9CED272
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14C96B0029; Tue, 18 Nov 2025 05:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5716B00AB; Tue, 18 Nov 2025 05:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4036B00AC; Tue, 18 Nov 2025 05:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8882A6B0029
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:36:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D44C1A04B7
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:36:59 +0000 (UTC)
X-FDA: 84123374958.20.4F2518B
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 379751C0003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:36:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lGXZ36Sb;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763462217; a=rsa-sha256;
	cv=none;
	b=gv1eDdFvqHrh7ss2vGu592iOBpS6BMfT1a2EWWJEk4lCqiOdPPW8ybwAjrwbj4J5m6WlS0
	ZoaCC1ksrMFoL0gmX+QRo9QbW8f/zpldy5OG0CyfINq9Genww1x9iNNwCQdWqcqCI8stNA
	9odMCv5hG+DJefOTQJiyC4Whqn9Fs/Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lGXZ36Sb;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763462217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QW3YrzLI1OSdQK0hkzbyW5ur3dKrb2BxfDVA3CM9uI=;
	b=eTU42A+kQqzrb5irIrtLiiDvFzPRq2PrGXqkSYHQsB5SI8fueeFak7/7OtxU7jEb6sjhkY
	Z1GHh7QmmFd9NTD7EWMNqwccfYyw3MnXjfEfao+mH0i7u9pLuQulGP0XYLpWv3oI/brgMP
	onWzCew8CWNcXyhssa4xYE27qQWDi3M=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so23947635e9.2
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763462215; x=1764067015; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3QW3YrzLI1OSdQK0hkzbyW5ur3dKrb2BxfDVA3CM9uI=;
        b=lGXZ36SbE0knyCwcGfOIyA4ivT0yfeS7NTUy99FGaQXnpJdl1MtvNcHZ6HtXSSoDef
         Z13Xy+ClrV7kTuPs2OTCkzVx0uVF06tvMAWQjYLUzmUk/9huuTKyXCNhFmBc5n0BfZgq
         50661tmK2vQLlbkl2Oh3a2Hrw76/16s+bhUfrV+/SmnxC9kouIcq0JpDEz/GCreV+ftu
         194+2DzPbtwfPJtywZ52ATmj90gLQzutWckMlPJfBUBhLJ2YT01GMFfw/aAPpIYH7Sw6
         bf2DqbGWVGd9wD4twHN4W2OEn9jTF157yo4z6XgC/mjGuAHIbaIs9o5L+4/tCUInF+fs
         3DkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462215; x=1764067015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3QW3YrzLI1OSdQK0hkzbyW5ur3dKrb2BxfDVA3CM9uI=;
        b=ewiRc6q5WQipLWkxfTuyMORM4tPPz/ONwbGM1VM14qO4WeSvR01v8BONeGEjpuyQ0f
         /cFM9uQ8D40S1xDS60QzVER84EUpH07odhin2zIzh4rGxOnfm0mn/MbDjLxbkp3dpXLw
         I8BQAfucXCCqndxR5OjjbxPPcR+WAOhEmC7I6+cIubJr9wmSEqHUtGKomUUWds5blkzo
         qF1LdIwYIemS8hK5qAkwLz2LGNASN1x7ZwxWtKVPe1UrsH6ICWIQwdMckMPLbPsysrQr
         YL2nrPeAu3ZlQtsh9h8MaRfQv4ubvyQPSKfJL80j8pPJ7t3cDeuBayI1SP5A/NiGviN5
         Mq5g==
X-Gm-Message-State: AOJu0YwbQtDsRvVbi6ctR98JXVN1UQtd8fPh6cX1fhXhWWe5WXtsMO2J
	pWk8h/M4bwQbMAovv9AnXJp8XyBYGEUWZm3CCMitTQ//rS74Yk3YMfJFrtvlmxes6JI=
X-Gm-Gg: ASbGncu1LfHsAxvN5fI6FiTKKLBL3l0XRQSYE72hTo6cEkX4EypsbGcfhiuLNFb8lir
	cFVAZU8VrjfoUwJaXUnvUnX1Ep8BL7z4r8VgEGnDGb135k6cMcsuYDAnoCjql5gL4byZbbQvBqo
	j6ySzmOpCjmJIKTHrYXbM6OoygSI7psDypx1UQtEpm5CnDKQg6EQjmCN64XmQk0/uLenB6d/zoP
	EZdqX/bydja2qr7ynuru6fMGS7UB2Eib2ZaJiUtevcBjEg5T2Oiox7MkNiE8GtCyNVbMSOQoDMs
	+C3gzR5k0fw8ahNvBkrISV500DpGqvzn1JiGzuj8axfaNviLY7MP8TNNNTXKHX2cbVkpxyrAHs5
	ylYUvlFuJwqozA2Ae/AXN3AdCwpQonLjKWcu9ot8A9VGpgVPsKPWUo+IyGf3LqxTy38PzkPIzvl
	/KzRX9gYDS
X-Google-Smtp-Source: AGHT+IHcPSG42oTSue/l29JNxRqWkMjwCuc7Im45XklO36HK61beZa9KMPscvjf0ZVFq7e39VGxhYw==
X-Received: by 2002:a05:600c:350d:b0:475:dd59:d8d8 with SMTP id 5b1f17b1804b1-4778fe4f716mr149402675e9.8.1763462214605;
        Tue, 18 Nov 2025 02:36:54 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::4:7772])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4779527235esm219825575e9.8.2025.11.18.02.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 02:36:53 -0800 (PST)
Date: Tue, 18 Nov 2025 04:36:47 -0600
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	rientjes@google.com, jackmanb@google.com, cl@gentwo.org,
	harry.yoo@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
	ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
	oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <aRxMP_wDRxJIhIiB@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <aktv2ivkrvtrox6nvcpxsnq6sagxnmj4yymelgkst6pazzpogo@aexnxfcklg75>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aktv2ivkrvtrox6nvcpxsnq6sagxnmj4yymelgkst6pazzpogo@aexnxfcklg75>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 379751C0003
X-Stat-Signature: scqdjxsz3a1ccqit8wcm18c9e7d8f18x
X-HE-Tag: 1763462217-487410
X-HE-Meta: U2FsdGVkX1/llaZjPvDE5tdCUQm1/N0uovHlThn/KcDkqyuB+8NYkav6Ad4G8WlKqrdtx0koZHkjnbrnrVtg+2IguzqxzuH8YKi9JGgwVvM1TC1ZVJA2MvS3lrHezJruM8tuJL8oYGxqzil+rRIUZIAozHGiwpSt+Wyjm4xCRdRC/m8j0Pi+k5VMh0J5BrDkmBdknTojhDxnHsgnMWl7g22OM36a4fvnVJnz7SHmhnulRt2xNYUEaCbIiWeB+v1YqdHPyBb3JRaCtWs6W7PXY6pobPNznPRaXIrwLodGBpYFuU1FR3XxueSUmlsWqdLUmQIL00czYeOXjk1FrBHhKNic1jsEPMAmIfRdt17AYXiHLyEbmpdh+m3dLnrTmYeuE/+E59nRWUR19sKG5zB8oTrhbgoFCIoL4fDXVrgbsNv1OdIMJlnGEcncK9zYEmrYo1TB+VueclHUyiCkGhAP5p8HFasuqxGLmHt+6wJbVnWIxEjushsOguwdwTeWpjCMtFVAfVvrg1w9ORSPp3jDqRAEUjPHLy00YBByNDTDNZGg6SEVptq56BCutDrWLV2rZpVZxW6StBWa34VL6XSIJEaM25o1WUUrPb1JGeB2QnIJagbLP/quCNG6YQT7RTTFxGXpreksvd5XPGBIOKbr29awxa/nI3HSR+NjtgQC6Od1zTkndnxcyCBjcVs9znTTn4YjO5Dl2fpKgtiICWveBw2qiYNju5okPs2EJtjfmO6/lKpEYMRxsB5645xU2wZOFq3VOZjcxZdG7XitvXNUOiI0mLb/iL5jGLEYITGeJ/Fhlvnj23sa6vaxEQ+oLGiwqmazSzvn0tWMzIBmFBY8zUZCKi+us2MMINW1xe6TmirKsz2JW/HbdKLCrzBrx2y28SMFUJbYPlZv2iJ2B+U/LdjYMMNug9x8cFrRvYpP5gX/2VxmMStJAw235hk7f5pEyZnnFqVqy4tkjHNu3gh
 3guqPpIV
 /zPFTB3e/hNsMhfc2fHFpDN7Wyocv7KtOSk0KEruiMMN/naL7vHlqon2x8qVT6VGUcJlGpNsJVxqxUcETErG1FdfpomcOa3ur31aExl/nhVLP/ca84qIiT5/JKDA+CPh0LPmQHYpO42/z5wPjLPjkA5cJE3eoALdrsNrKX7ST//n0CBDOGFn405+eI3G1+mO6aal/IEfqytyU8E6s6LqyFuuhUsgjqoYWzIXTIQBB5LZKXJCnSigIg0ynEr9YbJiQbJ85TkXKq5+7Z41As3IuCm+eCyoi1ZzNRiq85MM0y1+0cxX49bdZz/CmPUlG2abWJb8hegji+lPLMzPFgn2OnFnujz9axjT6oq2So8PpVYtWmvXNWZWhkcUfo5j1nz43CQSfHw073sXRI0niqoj+s8dmgZnYsLv0hoejmUkQDK4wykfCbOmy3KwL+/ht9FqZGODualLFaA+KurJvDjn+riecCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 06:02:02PM +1100, Alistair Popple wrote:
> On 2025-11-13 at 06:29 +1100, Gregory Price <gourry@gourry.net> wrote...
> > - Why? (In short: shunting to DAX is a failed pattern for users)
> > - Other designs I considered (mempolicy, cpusets, zone_device)
> 
> I'm interested in the contrast with zone_device, and in particular why
> device_coherent memory doesn't end up being a good fit for this.
>

I did consider zone_device briefly, but if you want sparse allocation
you end up essentially re-implementing some form of buddy allocator.

That seemed less then ideal, to say the least.

Additionally, pgmap use precludes these pages from using LRU/Reclaim,
and some devices may very well be compatible with such patterns.

(I think compression will be, but it still needs work)

> > - Why mempolicy.c and cpusets as-is are insufficient
> > - SPM types seeking this form of interface (Accelerator, Compression)
> 
> I'm sure you can guess my interest is in GPUs which also have memory some people
> consider should only be used for specific purposes :-) Currently our coherent
> GPUs online this as a normal NUMA noode, for which we have also generally
> found mempolicy, cpusets, etc. inadequate as well, so it will be interesting to
> hear what short comings you have been running into (I'm less familiar with the
> Compression cases you talk about here though).
> 

The TL;DR:

cpusets as-designed doesn't really allow the concept of "Nothing can
access XYZ node except specific things" because this would involve
removing a node from the root cpusets.mems - and that can't be loosened.

mempolicy is more of a suggestion and can be completely overridden. It
is entirely ignored by things like demotion/reclaim/etc.

I plan to discuss a bit of the specifics at LPC, but a lot of this stems
from the zone-iteration logic in page_alloc.c and the rather... ermm...
"complex" nature of how mempolicy and cpusets interacts with each other.

I may add some additional notes on this thread prior to LPC given that
time may be too short to get into the nasty bits in the session.

> > - Platform extensions that would be nice to see (SPM-only Bits)
> > 
> > Open Questions
> > - Single SPM nodemask, or multiple based on features?
> > - Apply SPM/SysRAM bit on-boot only or at-hotplug?
> > - Allocate extra "possible" NUMA nodes for flexbility?
> 
> I guess this might make hotplug easier? Particularly in cases where FW hasn't
> created the nodes.
>

In cases where you need to reach back to the device for some signal, you
likely need to have the driver for that device manage the alloc/free
patterns - so this may (or may not) generalize to 1-device-per-node.

In the scenario where you want some flexibility in managing regions,
this may require multiple nodes for device.  Maybe one device provides
multiple types of memory - you want those on separate nodes.

This doesn't seem like something you need to solve right away, just
something for folks to consider.

> > - Should SPM Nodes be zone-restricted? (MOVABLE only?)
> 
> For device based memory I think so - otherwise you can never gurantee devices
> can be removed or drivers (if required to access the memory) can be unbound as
> you can't migrate things off the memory.
> 

Zones in this scenario are bit of a square-peg/round-hole.  Forcing
everything in ZONE_MOVABLE means you can't do page pinning or things
like 1GB gigantic pages.  But the device driver should be capable of
managing hotplug anyway, so what's the point of ZONE_MOVABLE? :shrug:

> > The ZSwap example demonstrates this with the `mt_spm_nodemask`.  This
> > hack treats all spm nodes as-if they are compressed memory nodes, and
> > we bypass the software compression logic in zswap in favor of simply
> > copying memory directly to the allocated page.  In a real design
> 
> So in your example (I get it's a hack) is the main advantage that you can use
> all the same memory allocation policies (eg. cgroups) when needing to allocate
> the pages? Given this is ZSwap I guess these pages would never be mapped
> directly into user-space but would anything in the design prevent that? 

This is, in-fact, the long term intent. As long as the device can manage
inline decompression with reasonable latencies, there's no reason you
shouldn't be able to leave the pages mapped Read-Only in user-space.

The driver would be responsible for migrating on write-fault, similar to
a NUMA Hint Fault on the existing transparent page placement system.

> For example could a driver say allocate SPM memory and then explicitly
> migrate an existing page to it?

You might even extend migrate_pages with a new flag that simply drops
the write-able flag from the page table mapping and abstract that entire
complexity out of the driver :]

~Gregory

