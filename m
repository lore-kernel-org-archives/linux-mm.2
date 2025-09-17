Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 148A0CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B188E0060; Wed, 17 Sep 2025 12:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F20D8E0002; Wed, 17 Sep 2025 12:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F958E0060; Wed, 17 Sep 2025 12:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF918E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:49:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0187213B719
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:49:51 +0000 (UTC)
X-FDA: 83899329024.22.37C4428
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id D954C8000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:49:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758127790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eqbiEJjd8mG/bJ9pwp3CC3dDE6YmjT1c56ycIwS7cNQ=;
	b=P3E02FkDcYw/mjjQw4Jv7x+e7/ZJngGLJjXknAPaJlDYHEXm68L7nB0USuqXDJAHlL/vH+
	A4MMCmiU+1PS1LiXVJR6n3OQ85nuc4iGMZFp/VuTn+UahRrzWum1FhnYT+xxl4nqjk1Gx9
	9aX/eQpwa/wcREFb/Ry1e6gnIbWDTWU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758127790; a=rsa-sha256;
	cv=none;
	b=VZj6kF4vyVg/jZAGUTLoGZlANHs9ZA+58TKXJyCZv5P2akBXKM/y+3Nyl3BTelZWhuE+AI
	Cql+FxR/Ovi+VRQPFup86KRZ8otXdh0RRE+YguknXUoVJIMdsa+4XVgDd4riq5Q3DoAvBr
	QedTKUtEHSJZH3zKdiwS9uqXVyQaRUU=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cRl6R02Rxz6M5JT;
	Thu, 18 Sep 2025 00:46:55 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D28A314020A;
	Thu, 18 Sep 2025 00:49:43 +0800 (CST)
Received: from localhost (10.203.177.15) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 17 Sep
 2025 18:49:42 +0200
Date: Wed, 17 Sep 2025 17:49:41 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Wei Xu <weixugc@google.com>
CC: David Rientjes <rientjes@google.com>, Gregory Price <gourry@gourry.net>,
	Matthew Wilcox <willy@infradead.org>, Bharata B Rao <bharata@amd.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <sj@kernel.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <20250917174941.000061d3@huawei.com>
In-Reply-To: <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<aMGbpDJhOx7wHqpo@casper.infradead.org>
	<aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
	<7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
	<CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Queue-Id: D954C8000B
X-Rspamd-Server: rspam05
X-Stat-Signature: ycyx4hjisyrtrybig3pex697bzcejabs
X-Rspam-User: 
X-HE-Tag: 1758127788-351570
X-HE-Meta: U2FsdGVkX1/3+jQPxBTk7wrdCexHn+uKyNvIbIzA+epwwFdfWsyPQnCGMU8JXFRYyLWytaNBIXTMv9zaPj9Gd8RGf3moLuCxaUJtkS40JlmFbS+XOXAJdumJi7ow2Z6q9KTe8kpf/WBia2aKt9c65+0JuT3izDpiPZcSw6kz8GoestQ4yb/xi0+iebGHMLoDPK1t4HBIeTe3M4Bqu9DDkHCD5535Y1eAXsiZYoXfkIM6Uw8PYfKeGowkzavcff2G3s3CHY6E8BfXLBLDiTOtBFghIye6YOBm2RhKKrN+809nj+tLqjJstgSdvJ+GnaLEDmPPUCnvKhK9bk9ANoVIgGx/ZOyd+JczvNrdsQtmQFRx82W7m2wwqMuFHyUKjMpujIOJ2lRV1D28uX4/SZ11VVO4U00uVrqodwGTq+gqmvviQhmUwC9XGrUOcQlw35GAY3hdzEdPPZpFI9OeKO4IkohzQPB4+pJ9usXYX+lXI4FM9/xk2eY51CVOKYitLmCrRNzYhorIrDPebwPl7nR9vHuNiIxu3zGuUYic15diMheAkbwwdXCllhSjnWWTPhL3SbSL0GgN1bVpUS9SK/uLcSOf7JdScAnpkp9JAztVvP/Boaej02odyF+pOFfDNrI8yzp8lhAQH0Lbc5YdWCTngTn2veUrFckxlj36lgyjxl1P/ZR7lUapAkMROZwjlIalmnrNPbBAeKZxolhqb82uwEx1aXAxZtT/9/46yAXevGhOKraSoua4wcw5CFVd0AsX0dMH6kj6awBVInoF8MdapbNyrY07ExOxyb/Je+N/fN1iPsWnp96pBZ/nea/yh++xMVbDhwXmss+kOKUU3IdvUMjjcbzoKzH95iTYHgkZzI8YThzom/FlSaRuSSQZ/gcguLCsIKsiBb9KKM3OpnkwBhhM/73ylns0A9NJ8r7R/tPMfpiDXMEyfFFqVLvapo4Cg+pqsTLoNxLFRsGNQv9
 QrHzL2IY
 mrVFBK3f7bg8WAmvspDckq52xUm7c7uMy7wRrCGNC0y8ZMagRnTD77z3wE8zanRPk/4xEAr0RWmTFuF5+2RPlquZkiOPK5TegPqOz5dMcjqndFNSVw1bUPeBpwQhsZhR8lXWZloy9ViNHJbXFgsF7o1k2sKnl3sUm7eJrxU4WOr7DZCxCwdBwo6JTO3GZjx5uY/AghxHULiaWSVjr0qyJS/3CnPbI9jlsraKJiKX9jrVaVcLD6JgLAU9KUqMH4hUdKUWGAf3Ghk7KFanozyf8IL9zd0SW+n2v/KJ7ONtyWV5aSYNVbSce29rouPnDxRojMWa2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 17:30:46 -0700
Wei Xu <weixugc@google.com> wrote:

> On Tue, Sep 16, 2025 at 12:45=E2=80=AFPM David Rientjes <rientjes@google.=
com> wrote:
> >
> > On Wed, 10 Sep 2025, Gregory Price wrote:
> > =20
> > > On Wed, Sep 10, 2025 at 04:39:16PM +0100, Matthew Wilcox wrote: =20
> > > > On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote: =20
> > > > > This patchset introduces a new subsystem for hot page tracking
> > > > > and promotion (pghot) that consolidates memory access information
> > > > > from various sources and enables centralized promotion of hot
> > > > > pages across memory tiers. =20
> > > >
> > > > Just to be clear, I continue to believe this is a terrible idea and=
 we
> > > > should not do this.  If systems will be built with CXL (and given t=
he
> > > > horrendous performance, I cannot see why they would be), the kernel
> > > > should not be migrating memory around like this. =20
> > >
> > > I've been considered this problem from the opposite approach since LS=
FMM.
> > >
> > > Rather than decide how to move stuff around, what if instead we just
> > > decide not to ever put certain classes of memory on CXL.  Right now, =
so
> > > long as CXL is in the page allocator, it's the wild west - any page c=
an
> > > end up anywhere.
> > >
> > > I have enough data now from ZONE_MOVABLE-only CXL deployments on real
> > > workloads to show local CXL expansion is valuable and performant enou=
gh
> > > to be worth deploying - but the key piece for me is that ZONE_MOVABLE
> > > disallows GFP_KERNEL.  For example: this keeps SLAB meta-data out of
> > > CXL, but allows any given user-driven page allocation (including page
> > > cache, file, and anon mappings) to land there.
> > > =20
> >
> > This is similar to our use case, although the direct allocation can be
> > controlled by cpusets or mempolicies as needed depending on the memory
> > access latency required for the workload; nothing new there, though, it=
's
> > the same argument as NUMA in general and the abstraction of these far
> > memory nodes as separate NUMA nodes makes this very straightforward.
> > =20
> > > I'm hoping to share some of this data in the coming months.
> > >
> > > I've yet to see any strong indication that a complex hotness/movement
> > > system is warranted (yet) - but that may simply be because we have
> > > local cards with no switching involved. So far LRU-based promotion and
> > > demotion has been sufficient.
> > > =20
> >
> > To me, this is a key point.  As we've discussed in meetings, we're in t=
he
> > early days here.  The CHMU does provide a lot of flexibility, both to
> > create very good and very bad hotness trackers.  But I think the key po=
int
> > is that we have multiple sources of hotness information depending on the
> > platform and some of these sources only make sense for the kernel (or a
> > BPF offload) to maintain as the source of truth.  Some of these sources
> > will be clear-on-read so only one entity would be possible to have as t=
he
> > source of truth of page hotness.
> >
> > I've been pretty focused on the promotion story here rather than demoti=
on
> > because of how responsive it needs to be.  Harvesting the page table
> > accessed bits or waiting on a sliding window through NUMA Balancing (ev=
en
> > NUMAB=3D2) is not as responsive as needed for very fast promotion to top
> > tier memory, hence things like the CHMU (or PEBS or IBS etc).
> >
> > A few things that I think we need to discuss and align on:
> >
> >  - the kernel as the source of truth for all memory hotness information,
> >    which can then be abstracted and used for multiple downstream purpos=
es,
> >    memory tiering only being one of them
> >
> >  - the long-term plan for NUMAB=3D2 and memory tiering support in the k=
ernel
> >    in general, are we planning on supporting this through NUMA hint fau=
lts
> >    forever despite their drawbacks (too slow, too much overhead for KVM)
> >
> >  - the role of the kernel vs userspace in driving the memory migration;
> >    lots of discussion on hardware assists that can be leveraged for mem=
ory
> >    migration but today the balancing is driven in process context.  The
> >    kthread as the driver of migration is yet to be a sold argument, but
> >    are where a number of companies are currently looking
> >
> > There's also some feature support that is possible with these CXL memory
> > expansion devices that have started to pop up in labs that can also
> > drastically reduce overall TCO.  Perhaps Wei Xu, cc'd, will be able to
> > chime in as well.
> >
> > This topic seems due for an alignment session as well, so will look to =
get
> > that scheduled in the coming weeks if people are up for it. =20
>=20
> Our experience is that workloads in hyper-scalar data centers such as
> Google often have significant cold memory. Offloading this to CXL memory
> devices, backed by cheaper, lower-performance media (e.g. DRAM with
> hardware compression), can be a practical approach to reduce overall
> TCO. Page promotion and demotion are then critical for such a tiered
> memory system.

For the hardware compression devices how are you dealing with capacity vari=
ation
/ overcommit?  Whilst there have been some discussions on that but without a
backing store of flash or similar it seems to be challenging to use
compressed memory in a tiering system (so as 'normalish' memory) unless you
don't mind occasionally and unexpectedly running out of memory (in nasty
async ways as dirty cache lines get written back).

Or do you mean zswap type use with a hardware offload of the actual
compression?

>=20
> A kernel thread to drive hot page collection and promotion seems
> logical, especially since hot page data from new sources (e.g. CHMU)
> are collected outside the process execution context and in the form of
> physical addresses.
>=20
> I do agree that we need to balance the complexity and benefits of any
> new data structures for hotness tracking.
>=20
> > > It seems the closer to random-access the access pattern, the less
> > > valuable ANY movement is. Which should be intuitive.  But, having
> > > CXL beats touching disk every day of the week.
> > >
> > > So I've become conflicted on this work - but only because I haven't s=
een
> > > the data to suggest such complexity is warranted.
> > >
> > > ~Gregory
> > > =20
>=20


