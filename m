Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D30CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 00:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CBF78E0002; Tue, 16 Sep 2025 20:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3818E0001; Tue, 16 Sep 2025 20:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0208E0002; Tue, 16 Sep 2025 20:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCBC8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:31:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E46F9140384
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:31:00 +0000 (UTC)
X-FDA: 83896862280.22.26D4F4C
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0C2EF8000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:30:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="lxTGq1/1";
	spf=pass (imf30.hostedemail.com: domain of weixugc@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=weixugc@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758069059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAKa0U7jZSpuvuM4buIty/jYeCtOj2xsvZscq/9Zh0w=;
	b=QOQVaXYUIykHe7f5fD6ajBRweubsRcb8bY1x2tIAYAGVWbWwps0fhcw6iQDbgW7pbu+EYB
	sCnEgRWus/LFK7V3o7Cp9bLemz4BSW8IVTnciDMm6NdALWIygdhg7yZGandIvZHfDClYdf
	QwgokeCL+pGqzWmzzK+urttvaKPY+ig=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="lxTGq1/1";
	spf=pass (imf30.hostedemail.com: domain of weixugc@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=weixugc@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758069059; a=rsa-sha256;
	cv=none;
	b=rAKIiBj2+xiuSp90rKk35L3emCx+dmwQk2W7pCZtEMiKeZW1v1RE0g3lEsSTEaNLMofh6P
	aghpin2jcmlHlaw+kYhPgLtRR8Oj6CccGQlFV3nEpBFJOs5R9vA5jymsu+776lsAsoF9qk
	roTVQHz4nGq91pHcNMM5vXbaomE69bY=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-52af5df0fdaso2055311137.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758069058; x=1758673858; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAKa0U7jZSpuvuM4buIty/jYeCtOj2xsvZscq/9Zh0w=;
        b=lxTGq1/1jqFody+rWnis6vFkjZ9iykLP/mRqCHaqVO1XoI5NdDkFTyXjoTuEa6WpqY
         IcJo7h+wCJ4nUyj3+IJ2s6n7+W7FjuCL9kXrC7RClTzcuTDGcR4D9t5cgjssv71jykZk
         rlA8ySYFg2MrnoCaz8ZFYZRyfdzm5Fsap1XgoBNiXNKgqCN2ptQH7KAS6w2z3ibwKENG
         EWHR0ByBfzVP//O1ls4VGvA8S0DBJGvV+XSsgVqG1lAQ5mllE3l1Lj9M9T7uWkU9l7b0
         NBCnCxUxdJkYgfc/B0VJd86JtO77iYQMa1Q1rkk0gkLJhv7hHBk1wW0zlSpzfO+kb4ZK
         A1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758069058; x=1758673858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CAKa0U7jZSpuvuM4buIty/jYeCtOj2xsvZscq/9Zh0w=;
        b=AoUyVJIEe4U7hUiKFiyOec3MJ4l9pTQ085QbaFozfQnmgN90J6Xt/l7quF6wu1wz8I
         M5jhS0G4tdZ6LfTy9FjtdoWsL/xrw7qlY5ioJs525m9t+rTqSL4HfjaZZ/x18bIDutWy
         D08f+l+N3TGreJkaq6wVcVF+LChsmVMYNA4em2WGWET3BISrUCbQ5uJsyTaDEt5hgke3
         4caCC+0nikM5Gy5pAaBnqj8b4YEWET7FsTq8mFjgEBDogBjBd+ZAJVJn+lxlquV0Zxvt
         Aan8TxEy2Fng/ncqZtBlIzr3n9Y08mhTokKpkXOJIYAGvI/noHe+4mMWSDogcflgH4GB
         5ApA==
X-Forwarded-Encrypted: i=1; AJvYcCVlM8B6Edetr2bwdO56+RXODo+BYmrUtrARZhqkbROn3g77HwBSvIiqcVASoeVbHi5rZePEhjh2cA==@kvack.org
X-Gm-Message-State: AOJu0YyzglmB40c0hFIfjm7KA7AMA3xwijG+G0m7Ptmvd2Blq6fW412z
	h61TWmPcOs9bpnAJZIR7ipdKyQUKM2JJakE414BSCu3c3MbJnhCWGFgDTCZLyrh/tkCjV4GlsHn
	wg5OpFa0bwXtgmooSvLgvfEOytRprI0k68H2RnbMJ
X-Gm-Gg: ASbGncs1UXgejU9VTFXZwcKvo+NDInfgmxXnUtheqsa9wJnEFyFB4A1JLjuYaxKki6B
	FY36fKY0PlJKIrJ4pXn9avvQDGnHtAUWRQy6gG6585NQ8CqohLwa+KG5KMZWmR2JL5W5PrdmlvS
	H8GpK5w8PifR8Tv+UsT25jDzfeDn6dgG1x3TL/ADjdbSb/xni9GUYY/vSxpA+wORgBudZDPKoi9
	Wjg6TWtqfqBOoIE3mvsbc0qXyLMDjwHjf8J2g7+71VA
X-Google-Smtp-Source: AGHT+IGpcvzQc7vHHG+kc4oHBhDjO4zKXCvjee+xT79Ol/YyeJ/1u96xFdzMVFkD0elqQQ4hUMuBMrxsaBUf0oG58gU=
X-Received: by 2002:a05:6102:2c15:b0:522:b5e6:2f46 with SMTP id
 ada2fe7eead31-56d4d993fdbmr67674137.5.1758069057773; Tue, 16 Sep 2025
 17:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250910144653.212066-1-bharata@amd.com> <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F> <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
In-Reply-To: <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
From: Wei Xu <weixugc@google.com>
Date: Tue, 16 Sep 2025 17:30:46 -0700
X-Gm-Features: AS18NWA9y0jYxcd9ms5fIx1WiL1jSVSZ98u37raOtlChuyNgOvkjQE1POFTfnB4
Message-ID: <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion infrastructure
To: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>, 
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com, hannes@cmpxchg.org, 
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org, 
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net, 
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, 
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com, 
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, 
	balbirs@nvidia.com, alok.rathore@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0C2EF8000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: omk17fdwsu1k994o5qzcquj9tmf4xhnz
X-HE-Tag: 1758069058-125506
X-HE-Meta: U2FsdGVkX19zLFX1hPGTiiY7kePxl884aYQBs+GDSQZn829v/M3SaqlmBEFc1HGApHIyw1B416aCoMNGsX8tr+bw0cyi1XyeBA6dCFhHusSxkcwsnilefa73nG7s+2s8pfTKrfxShEj+X7xuwDyVRgw0U9sRr4E81TFxArw4Anw2JBV/QEJvZtLqbhcIkLSeqWDT4D9ha9pn5mVkb2w/g7oGidZkTvwv9OTAMZlWoYxyBhcvE2SXIt2hy8vEqPJX89+vsTVnOQieOes4gLj4qFRNXaBJEjFzt5kvBxyy6imtv+QAw45KQnNj6z6G/4fbGLMNeu0RTvjnokacygfidWgk9OB4ilFd8FnJYVNeZGiDqyY2RLcX9zrat1bjZf+bQRfP3y7JvaeSstVdWasdx4d7Wleq4zjzdS4Q6o0N5TJGSpfxtU92fYtFn1i4cS8NWJMnFejbX1m4R6XR3P/AKFx1j50C/bK1x3tCGH+Icrii7g7eOF7KHQbBvEjj6VI3BAhPojny0KOEUYAvMQM/XdNW3DmHxNno095eRbJ1GRHsico+XaiJfidQJbrlvZZFKBIDqb5QgNe3GqueSABeHSQARXJj1Q1UCGHkm1ofM6blpOOAJ5m0YKYJ90tZ5HHKww4Db054IJ9MssFb/UPIofjQx7WKD1FaSAV78HnJVViRSBPSrxJxjEcEE7bUJHcN/zouS125jAQTDLZNbvpvhJ8bV8Hk8ZViJnnsGIMDpoTZXNH+2LHAMDOFy6x8YZQ7/9zukCNnZNAyXSMY2U3Lnsu/rvViGN0sJhFftkwx2RnMs++VkXMy+MEVgCMqJZzi00L7AySUCqKRUXIAancrwRgom9q0U6zDIGKccKHwciXsyT9MGHi19PZ92BkUMmXBKi0rHdGwWBFAWgoXSIUn8C1+J54m4XV6JCa+AiL01kxpqJdNzzQ8DQk4AbMoSanEJcMfKRlAD2AWlxqB2q0
 xwQFUlUm
 d1ZiDHZmloP+8JAtV6pKacpJiJ7TlDc2SMg4txaNODfP+IC0tiQ8Tikk7rOTFA0FO82xDeWIcDvuTZNO88vw09Qe5W5qWGeVH1bIpXuAAA6aHxbaoSwivtavngKtt5McNgiPSFyVJkHodYeMDO08Zx0s2QSabsrANoShrlv2pAo8VCZxjYENiIOsBo2g25ccBSdOsqUVzeyezDMtC/OAp7AgRxsz75MCeSIFEExkuCHmk4XmA02jb+cTBPOf00iCTw81TCvczRc7Pba+mSV23iFLDHt6d1r+eDHXu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 12:45=E2=80=AFPM David Rientjes <rientjes@google.co=
m> wrote:
>
> On Wed, 10 Sep 2025, Gregory Price wrote:
>
> > On Wed, Sep 10, 2025 at 04:39:16PM +0100, Matthew Wilcox wrote:
> > > On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote:
> > > > This patchset introduces a new subsystem for hot page tracking
> > > > and promotion (pghot) that consolidates memory access information
> > > > from various sources and enables centralized promotion of hot
> > > > pages across memory tiers.
> > >
> > > Just to be clear, I continue to believe this is a terrible idea and w=
e
> > > should not do this.  If systems will be built with CXL (and given the
> > > horrendous performance, I cannot see why they would be), the kernel
> > > should not be migrating memory around like this.
> >
> > I've been considered this problem from the opposite approach since LSFM=
M.
> >
> > Rather than decide how to move stuff around, what if instead we just
> > decide not to ever put certain classes of memory on CXL.  Right now, so
> > long as CXL is in the page allocator, it's the wild west - any page can
> > end up anywhere.
> >
> > I have enough data now from ZONE_MOVABLE-only CXL deployments on real
> > workloads to show local CXL expansion is valuable and performant enough
> > to be worth deploying - but the key piece for me is that ZONE_MOVABLE
> > disallows GFP_KERNEL.  For example: this keeps SLAB meta-data out of
> > CXL, but allows any given user-driven page allocation (including page
> > cache, file, and anon mappings) to land there.
> >
>
> This is similar to our use case, although the direct allocation can be
> controlled by cpusets or mempolicies as needed depending on the memory
> access latency required for the workload; nothing new there, though, it's
> the same argument as NUMA in general and the abstraction of these far
> memory nodes as separate NUMA nodes makes this very straightforward.
>
> > I'm hoping to share some of this data in the coming months.
> >
> > I've yet to see any strong indication that a complex hotness/movement
> > system is warranted (yet) - but that may simply be because we have
> > local cards with no switching involved. So far LRU-based promotion and
> > demotion has been sufficient.
> >
>
> To me, this is a key point.  As we've discussed in meetings, we're in the
> early days here.  The CHMU does provide a lot of flexibility, both to
> create very good and very bad hotness trackers.  But I think the key poin=
t
> is that we have multiple sources of hotness information depending on the
> platform and some of these sources only make sense for the kernel (or a
> BPF offload) to maintain as the source of truth.  Some of these sources
> will be clear-on-read so only one entity would be possible to have as the
> source of truth of page hotness.
>
> I've been pretty focused on the promotion story here rather than demotion
> because of how responsive it needs to be.  Harvesting the page table
> accessed bits or waiting on a sliding window through NUMA Balancing (even
> NUMAB=3D2) is not as responsive as needed for very fast promotion to top
> tier memory, hence things like the CHMU (or PEBS or IBS etc).
>
> A few things that I think we need to discuss and align on:
>
>  - the kernel as the source of truth for all memory hotness information,
>    which can then be abstracted and used for multiple downstream purposes=
,
>    memory tiering only being one of them
>
>  - the long-term plan for NUMAB=3D2 and memory tiering support in the ker=
nel
>    in general, are we planning on supporting this through NUMA hint fault=
s
>    forever despite their drawbacks (too slow, too much overhead for KVM)
>
>  - the role of the kernel vs userspace in driving the memory migration;
>    lots of discussion on hardware assists that can be leveraged for memor=
y
>    migration but today the balancing is driven in process context.  The
>    kthread as the driver of migration is yet to be a sold argument, but
>    are where a number of companies are currently looking
>
> There's also some feature support that is possible with these CXL memory
> expansion devices that have started to pop up in labs that can also
> drastically reduce overall TCO.  Perhaps Wei Xu, cc'd, will be able to
> chime in as well.
>
> This topic seems due for an alignment session as well, so will look to ge=
t
> that scheduled in the coming weeks if people are up for it.

Our experience is that workloads in hyper-scalar data centers such as
Google often have significant cold memory. Offloading this to CXL memory
devices, backed by cheaper, lower-performance media (e.g. DRAM with
hardware compression), can be a practical approach to reduce overall
TCO. Page promotion and demotion are then critical for such a tiered
memory system.

A kernel thread to drive hot page collection and promotion seems
logical, especially since hot page data from new sources (e.g. CHMU)
are collected outside the process execution context and in the form of
physical addresses.

I do agree that we need to balance the complexity and benefits of any
new data structures for hotness tracking.

> > It seems the closer to random-access the access pattern, the less
> > valuable ANY movement is. Which should be intuitive.  But, having
> > CXL beats touching disk every day of the week.
> >
> > So I've become conflicted on this work - but only because I haven't see=
n
> > the data to suggest such complexity is warranted.
> >
> > ~Gregory
> >

