Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E96DD0E6EC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 15:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF176B0005; Tue, 25 Nov 2025 10:05:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480276B0010; Tue, 25 Nov 2025 10:05:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F616B0012; Tue, 25 Nov 2025 10:05:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1B06B0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:05:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A1111401BD
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:05:30 +0000 (UTC)
X-FDA: 84149453220.26.9FE5881
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71EE2A001B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:05:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oTotP3cK;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764083128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ardSa1fh2pHETKiwXzwSN9Th9brxN1pF2dM3Ndqaang=;
	b=IlWwyJ560Ycig7gxBB1lRfWcVyDs9ttRbKqRs9WTcCtVZWV8Fnzx8AKwwk8hr3gQqXWBUc
	78DPIoUUsxP86dhUiK+LgQd9KzSGEc+DOX2KrI0+SQqbAvL0Rcdt6RAv0jQzNpcxLuistq
	Zg3Yl+IGRw5j/OWRVZpWBbk2mfKWtE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764083128; a=rsa-sha256;
	cv=none;
	b=ThFZmJxO8yduqWvymxsCVZRpMrmIMayG8YpNJdk0A9UwuAWg2Ui4knXQX1VEJdoO8F4LSe
	4p4QQ2c/zd+r++AHNkPYZBoekhMAC5EWDJco6FT+b1v7WWcoc41/F0tm2xS2v43vI5ZiR0
	vYFoevHNa1eE3JNhr1x5nFJrWFX/YIY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oTotP3cK;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b2ea5a44a9so567493285a.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764083127; x=1764687927; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ardSa1fh2pHETKiwXzwSN9Th9brxN1pF2dM3Ndqaang=;
        b=oTotP3cKWnFcjGCHHKc9X+TLIXkjo7gD1TOHUbovin6JcMJEM5n9Dp/EivLB3lhfs9
         FJDEFCkugSdev2NARnMnsUdfyQ3n1bgYJUc8cyYoiX+8NuFTiPbQ9iVFioWEeHvetEMq
         JwihxvAmWh8qXUh/NmBIfhOldUzE4sw3BidmbZGhqlrSAONCyo2/T5/Gj+JWvgBjscgZ
         yl+0Xu57O1lasGHLdZcWCDflNoRP/sA39HjNQVPj4bZfK72cVYM+/EcA2rU3qkWPXD86
         N0eVW1yD0Y+MoYsWhkhg/0X9SRQTD4NdGRQh2bVtDH171fU3DRuF376RmZ5wSc48SSPw
         M0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764083127; x=1764687927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ardSa1fh2pHETKiwXzwSN9Th9brxN1pF2dM3Ndqaang=;
        b=IsMfIJjHMiqxrSTFSapKTR4mNztrNl/4XkraJeKcPZn17lGUFfi+dzoAFXa/N4StqK
         Uy5yAUoy2cHqpVGjdLFY4gG9QVjRTg4BwmfsqHfCPzCBm+CYWjUUb5jURGos+euR40km
         glGqqe2JKcMSUJxdZi+QCt0ff7WXibZ9hMd3zd30HAmVmoaYYFFV7YxkCBKn5kp8JxCq
         WwuoVNklhhXDiePqym9V//m43ahY9D4u3u6FJWjFrqwxLvXITcTtYIxoYEmtWLl0rGJE
         YK7ptikNUNijzg49KxiF5oviXciHHSgtd8/3OEQsztHOWtcmzn1p0dyUjHO5NgwzRPJb
         ID1A==
X-Gm-Message-State: AOJu0Yy0ndqydYQ9/0pPed3X4EUQ5v8bZNP4qs7DM39jvwAaNrqp3psA
	V/6DPTMokERt61NGDIFTcaJIYUvXfZixpTi5NPKbtOjNmrSi9n9oEazgDLIQL/OtdHQ=
X-Gm-Gg: ASbGncsB7xLDM/HHcCuyn95ACsrtQ+5VBlKBFFD4fI0i3Yb1fXHIqhlvGd/TxU1atkD
	2fiLnRl/E4rso/MlNOJSGmIQrhqzk6lrkGTlNmkBIsNnxYhVuxF7BMa6eOHuR9KcX1HkD02i4fh
	vrvBV5I/25BlEnO1oiyRg1hvANVvwqMvlKCAC21ATP7tg7K6WYXaCMeNif6dXSR3dbBCp6gtJ5s
	iIkUAqo/R7D5IQ3NXuRKJIN+30OBjS4sBuUXOWwUTo4dARIq+F8kAq4Zu3euMLD5XM6X/zoHf4b
	QIePUidXwl5tYIpxJDSQDE5GfIqDivpPIyXlVXEPq5HMksXWlmU9JKgLDrYp3OStPX8nTs5NPmH
	ibawETFldtoJfpfuEOCQ3wxlRXvUBQpZxnsnZBUxb2fnTB+t7d/GEMmMTECn1kGdbNxBXNzNOTK
	aH3M2421ODgq5RataiWNGnUNGuQcTdXIJEs603aZ+4r5xSUUa5iM+lMuxl3BhmU4pP+paoxQ==
X-Google-Smtp-Source: AGHT+IEFL/RZ3x9jACD+3qnEV8d73oOLgzxVvrrp/q6V+1ebLXwAT8RkswYTT3oWsjpBiQE2LKDSqw==
X-Received: by 2002:ac8:7c55:0:b0:4ee:1e63:a4e0 with SMTP id d75a77b69052e-4efbdb25399mr46248441cf.74.1764083126842;
        Tue, 25 Nov 2025 07:05:26 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3295f2f6dsm1195203285a.54.2025.11.25.07.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 07:05:25 -0800 (PST)
Date: Tue, 25 Nov 2025 10:05:21 -0500
From: Gregory Price <gourry@gourry.net>
To: Kiryl Shutsemau <kirill@shutemov.name>
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
	ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com,
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
Message-ID: <aSXFseE5FMx-YzqX@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <h7vt26ek4wzrls6twsveinxz7aarwqtkhydbgvihsm7xzsjiuz@yk2dltuf2eoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h7vt26ek4wzrls6twsveinxz7aarwqtkhydbgvihsm7xzsjiuz@yk2dltuf2eoh>
X-Rspam-User: 
X-Stat-Signature: 779ane1gzc5xrcckadx1f4e1ijxs4ze5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 71EE2A001B
X-HE-Tag: 1764083128-139688
X-HE-Meta: U2FsdGVkX19QKP2MUiohUJIlqpq3cZOO6FF0kmXGTXu0zrCs86lYW4Fibz7HbdFs2eJMJ06Z67/MmgrQdRNLSrsBfl3NDQg4p91K6M9UDVvkMGySfCS3v5Tk7Xyat42QVJYVDUIh3lflkvAkkWVdxQeI4w2jQvODdNEcxC/DwF0urngyexomijD34Etl4XW+i62ETh4Rh6kCQ92/npripqRgdHiM8TXUUR1eGtNGqLRgVJpmfjIXNi7ssPh17PLuBQNZqiMAH1hV9J2iOJli/300yENRfTLJdd+S8oGHnyCES7j5b/kF0nGJKwnqsEwIDcFDFh3Sz98AsJ9fNBOeWl8IO27l8WD1XjdMJItgoCPaTKJ60MLA6WXeD/0cisW5a9oSKvp/hZ0XCtzOIyPTdZqP/7WNSqQ8BrVlfE7uoN7bX4nSDhvxgPtbre3oQU/3DO6SO4tB+h9vVu4sucfatL/jThAULAWXKdYM0RQPkh5CAi0HvK1OmwVdMBZ3mZu+g8vUBHTHMZ790uYhXlzGKeCjn31qb9McwQlBznGGVZg5uV4j9VlDpEgfYDAfVmqPpxKCtqJpa+5tB8wM082mGzxEA0K8PJmk1iClYZB1MI5SImdmPrY/qsginekTWCWMLDEDlqWa4ut2Yh+tXhgrVh1SBljrKDdacOr6Q5Yun8Yt1V2Le6yFy4ZSCzionU8R5uSOXQuIdfH9mABCmEYpe78OgTzFIlPG4W4qRN/pUNyokTuNKvq9vZbntVlPcEpaJdLuxTqXuyjWzw1QWdsBiMmf72m8LunYSfKrAHZyPE8bOcAykQYJLM6hkIarRPTJLCGz/kyoTR9xz9P7K5hYDWtsfuZeR2sJQWZsTw2LdTV3U0ZymPSZ4/JYJLz0T+F+l82YOtDXVUB3cO9p4l45Rx67Yrg78MZkNcgCACV1OSNtM2bOHPCjj5bkw9GOYsYNPcljDHvSKpoZAVDkTVm
 kb9av/Ux
 pz86RLvviK47l0+ULw3YJEtcCHlSM8FFRLxDrqqRSo12kCLYXoUKbbln88rfjsrRcOwlwUxE+ySjMMGMR7zIUWTKZEPGxeOktxKdUneolJ5Ydsl3GoOE/yzJ89cZZHArSSfu6hPf2hNmKNTydClvcUXFRUQVe/nFNhmSG0V13hICe76wCkjpfuFhN+UdZQmZgxDY/YmQgDX7AbxfWiWVgd+YOh1MwELsHbe6w1moskG7/L9Bn02MkB/RPLJQcJxkrj8wnl9I9WyXdQJ6tPko4QOl5VX3ukatu9dViKPO7g5T1ObIDeqn8L5gl2YmhQMwkQ/VU6KpLZVDqFdT4NMPGQTm2HNRg5hrzk7wVm9PBE0njA5C5DOmC8y3q1Vpc9TeuYdJBSWw+t2h81+jzDlUfYyKZbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 02:09:39PM +0000, Kiryl Shutsemau wrote:
> On Wed, Nov 12, 2025 at 02:29:16PM -0500, Gregory Price wrote:
> > With this set, we aim to enable allocation of "special purpose memory"
> > with the page allocator (mm/page_alloc.c) without exposing the same
> > memory as "System RAM".  Unless a non-userland component, and does so
> > with the GFP_SPM_NODE flag, memory on these nodes cannot be allocated.
> 
> How special is "special purpose memory"? If the only difference is a
> latency/bandwidth discrepancy compared to "System RAM", I don't believe
> it deserves this designation.
> 

That is not the only discrepancy, but it can certainly be one of them.

I do think, at a certain latency/bandwidth level, memory becomes
"Specific Purpose" - because the performance implications become so
dramatic that you cannot allow just anything to land there.

In my head, I've been thinking about this list

1) Plain old memory (<100ns)
2) Kinda slower, but basically still memory (100-300ns)
3) Slow Memory (>300ns, up to 2-3us loaded latencies)
4) Types 1-3, but with a special feature (Such as compression)
5) Coherent Accelerator Memory (various interconnects now exist)
6) Non-coherent Shared Memory and PMEM (FAMFS, Optane, etc)

Originally I was considering [3,4], but with Alistar's comments I am
also thinking about [5] since apparently some accelerators already
toss their memory into the page allocator for management.


Re: Slow memory --

   Think >500-700ns cache line fetches, or 1-2us loaded.

   It's still "Basically just memory", but the scenarios in which
   you can use it transparently shrink significantly.  If you can
   control what and how things can land there with good policy,
   this can still be a boon compared to hitting I/O.

   But you still want things like reclaim and compaction to run
   on this memory, and you still want buddy-allocation of this memory.

Re: Compression

  This is a class of memory device which presents "usable memory"
  but which carries stipulations around its use.

  The compressed case is the example I use in this set.  There is an
  inline compression mechanism on the device.  If the compression ratio
  drops to low, writes can get dropped resulting in memory poison.

  We could solve this kind of problem only allowing allocation via
  demotion and hack off the Write-bit in the PTE. This provides the
  interposition needed to fend-off compression ratio issues.

  But... it's basically still "just memory" - you can even leave it
  mapped in the CPU page tables and allow userland to read unimpeded.

  In fact, we even want things like compaction and reclaim to run here.
  This cannot be done *unless* this memory is in the page allocator,
  and basically necessitates reimplementing all the core services the
  kernel provides.

Re: Accelerators

  Alistair has described accelerators onlining their memory as NUMA
  nodes being an existing pattern (apparently not in-tree as far as I
  can see, though).

  General consensus is "don't do this" - and it should be obvious
  why.  Memory pressure can cause non-workload memory to spill to
  these NUMA nodes as fallback allocation targets.

  But if we had a strong isolation mechanism, this could be supported.
  I'm not convinced this kind of memory actually needs core services
  like reclaim, so I will wait to see those arguments/data before I
  conclude whether the idea is sound.


>
> I am not in favor of the new GFP flag approach. To me, this indicates
> that our infrastructure surrounding nodemasks is lacking. I believe we
> would benefit more by improving it rather than simply adding a GFP flag
> on top.
> 

The core of this series is not the GFP flag, it is the splitting of
(cpuset.mems_allowed) into (cpuset.mems_allowed, cpuset.sysram_nodes)

That is the nodemask infrastructure improvement.  The GFP flag is one
mechanism of loosening the validation logic from limiting allocations
from (sysram_nodes) to including all nodes present in (mems_allowed).

> While I am not an expert in NUMA, it appears that the approach with
> default and opt-in NUMA nodes could be generally useful. Like,
> introduce a system-wide default NUMA nodemask that is a subset of all
> possible nodes.

This patch set does that (cpuset.sysram_nodes and mt_sysram_nodemask)

> This way, users can request the "special" nodes by using
> a wider mask than the default.
> 

I describe in the response to David that this is possible, but creates
extreme tripping hazards for a large swath of existing software.

snippet
'''
Simple answer:  We can choose how hard this guardrail is to break.

This initial attempt makes it "Hard":
   You cannot "accidentally" allocate SPM, the call must be explicit.

Removing the GFP would work, and make it "Easier" to access SPM memory.

This would allow a trivial 

   mbind(range, SPM_NODE_ID)

Which is great, but is also an incredible tripping hazard:

   numactl --interleave --all

and in kernel land:

   __alloc_pages_noprof(..., nodes[N_MEMORY])

These will now instantly be subject to SPM node memory.
'''

There are many places that use these patterns already.

But at the end of the day, it is preference: we can choose to do that.

> cpusets should allow to set both default and possible masks in a
> hierarchical manner where a child's default/possible mask cannot be
> wider than the parent's possible mask and default is not wider that
> own possible.
> 

This patch set implements exactly what you describe:
   sysram_nodes = default
   mems_allowed = possible

> > Userspace-driven allocations are restricted by the sysram_nodes mask,
> > nothing in userspace can explicitly request memory from SPM nodes.
> > 
> > Instead, the intent is to create new components which understand memory
> > features and register those nodes with those components. This abstracts
> > the hardware complexity away from userland while also not requiring new
> > memory innovations to carry entirely new allocators.
> 
> I don't see how it is a positive. It seems to be negative side-effect of
> GFP being a leaky abstraction.
> 

It's a matter of applying an isolation mechanism and then punching an
explicit hole in it.  As it is right now, GFP is "leaky" in that there
are, basically, no walls.  Reclaim even ignored cpuset controls until
recently, and the page_alloc code even says to ignore cpuset when 
in an interrupt context.

The core of the proposal here is to provide a strong isolation mechanism
and then allow punching explicit holes in it.  The GFP flag is one
pattern, I'm open to others.

~Gregory

