Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6820ACAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 15:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563A38E000E; Thu, 25 Sep 2025 11:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5145D8E0006; Thu, 25 Sep 2025 11:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403528E000E; Thu, 25 Sep 2025 11:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 278718E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:01:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD055589F0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:01:11 +0000 (UTC)
X-FDA: 83928085542.30.BC53489
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 55589140014
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:01:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758812469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L2VZMaI8H4SduB5mW2rT6I2nKRE53Z5dd56Ku5CZC1Y=;
	b=nAvYyRvoO/j0G0iafz+MDymJjHm0AGa+4oDGUKMobUqNLPpj9ITItuCqsDfcCO6yc6f/1+
	TT7GM32Cf5jwmUlIqKFyxHlKGH14nqQrnfd0u9eOqGbwfet+LB+WTPCS0nANl2+064bFEL
	Og3jGBRiCkGYBdwppXK5H8lAx4MckYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758812469; a=rsa-sha256;
	cv=none;
	b=HCHzI1bDjoIxbo4zR22ZaLM9G7+rsBFaxkUu97uyC3HyXeSYTpFpLQIST8pdaQF/egs5o8
	AQpylN2ufudmeBtLdyxFmrHm2WiWnpmBF86IV+E5K8VvTrGu1p49mjox0AhvuAxA7IK9Ne
	c/qb9IWLmcWbMmUNE+3Gt2xYExfPNzk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cXcK72fQHz6M4l7;
	Thu, 25 Sep 2025 22:58:03 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id AD7361402F2;
	Thu, 25 Sep 2025 23:01:03 +0800 (CST)
Received: from localhost (10.47.28.112) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 25 Sep
 2025 16:01:02 +0100
Date: Thu, 25 Sep 2025 16:00:58 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
CC: Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>, Gregory
 Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>, Bharata B
 Rao <bharata@amd.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <sj@kernel.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<yiannis@zptcorp.com>, Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <20250925160058.00002645@huawei.com>
In-Reply-To: <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<aMGbpDJhOx7wHqpo@casper.infradead.org>
	<aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
	<7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
	<CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
	<20250917174941.000061d3@huawei.com>
	<5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.47.28.112]
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55589140014
X-Stat-Signature: gjgrmphhrt5fw6ezp86aeydpfitdteb3
X-Rspam-User: 
X-HE-Tag: 1758812469-687003
X-HE-Meta: U2FsdGVkX1/BH/c6D5l9Z+7AM147IXTgqoVF5gO4Co79Cqeao4DTqIf3/rFZESvSNcRfpp0o3hzYtDpXMAed3hSjM/H1xE1xXsOLHbBXzq5rxliSN301CsVuj80lNcpuhWJpQneNjwyTxd6ZOVN2TL17geDtNzOv7luODh6+e2li2S/7UlAidDwqq42trwF0jX7cZEXvXzfsZE7z3668AvS72+7g48Svy77cHdy8ATGJkTdr7kVRmtfqkE6QJ9d62ecuggqa0hi7KrQPKxxiZFYM9ohsEKUfRDVlEGgY4sCxrjt54OKZmeqHMKfkD2UYHXCMIJIPWlYtt0DRQW79qJktuRbXmqnAc0bh/egfAEM0ZQ9RBiGzzcVdEECEwgMtcY/BTIhR2e3dg8tnmE9+exAT3hXwAUV1Mk4f6gWZ2RaDSjtW6VPUs0edb9k2kVFidcZtTNHx+VU2EJGB+Dru1xMkjkN8CvVQU5qP3OiJ3j9Gm+RKml0gx2k32AwkkIz7eXmPKYzVGoIVuZ0dvX1icmbPLMnheomwcEZx40v4Ou3EOOMS1d3kGYvN/XOXWHHfub0DeDPwwtjtOo6ibUnhWKjxaD/5kP61Zg9wE9Uf9o71YWjKbqZAMSciQyZympukxjcZl3vDv4q+UZrpyVJbHZlIW6kUkJI+7sAU3SaJSO1qvC/hMtkI7O53UVtN2zDSiUVk+aoa8YZBZ/e34HfmCMhQAiFH6D8Q4Q2PmSTd2GmvWFGF0GSGtMkSdWR+Qbg0rExvEcUGYReEQSNQGZK9KDdkxOJ4BnRxO+LZI4aOVmkJsSTe+DzItWOZz/4ItKfUP7VxHoJFsPdSne/aALXlnJ7SNLDD1IbYDCxqdPhWKwVB9TbEk/h+lT5aZjAFHDodJ6M4axv4EqXzU3XyYLTQa+PhJ1NvBs7pj+4i1KzJfsDGV0VsISBB5JDJEt5r9i85hWNkaqAETjOpFHhYryA
 z59+PSjQ
 e0ZqbDU2rF7rk2NHlNtb9151J65LqD+YF1mqDyKjgsCBXMKgVY7HNYnQ6VShjlAm+LYSPvt3q92DKa2VF55a/Fmb30F9EtLyacli9uKqJUWQEy4DrD9uKO2MY7y7baeGObR+Po5iLNvE0t1yBtq+ZnezlsAbdXq3kMxbbwolUJk8gqfNwdYQyAOv7T++Y6KRM38WlRDy/U4O1z8pifnjuA/RDw53cszjJ+e1rP1LdUt32Rt4giBSAbDX4Ln+tXnuSoX1nCGN0D0wkmwDQxZCoiWQlLyJexTHq6uaA35ngFjelpYl8nFFZ43INFRJuiJ+jBgOkjPFiJ45s8hFBA9rNU95G5IBdAcJWqrCeQypxg05x7GX5LxxosGG6tZBU59lu4VyIsDgVzI8PD9UbHYIUn3+RE0yGmxABcualabG7DJ+hDyQMKYzCublbIp0293oRmvkQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sep 2025 16:03:46 +0200
Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com> wrote:

Hi Yiannis,


> > On 17 Sep 2025, at 18:49, Jonathan Cameron <jonathan.cameron@huawei.com=
> wrote:
> >=20
> > On Tue, 16 Sep 2025 17:30:46 -0700
> > Wei Xu <weixugc@google.com> wrote:
> >  =20
> >> On Tue, Sep 16, 2025 at 12:45=E2=80=AFPM David Rientjes <rientjes@goog=
le.com> wrote: =20
> >>>=20
> >>> On Wed, 10 Sep 2025, Gregory Price wrote:
> >>>  =20
> >>>> On Wed, Sep 10, 2025 at 04:39:16PM +0100, Matthew Wilcox wrote:   =20
> >>>>> On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote:   =20
> >>>>>> This patchset introduces a new subsystem for hot page tracking
> >>>>>> and promotion (pghot) that consolidates memory access information
> >>>>>> from various sources and enables centralized promotion of hot
> >>>>>> pages across memory tiers.   =20
> >>>>>=20
> >>>>> Just to be clear, I continue to believe this is a terrible idea and=
 we
> >>>>> should not do this.  If systems will be built with CXL (and given t=
he
> >>>>> horrendous performance, I cannot see why they would be), the kernel
> >>>>> should not be migrating memory around like this.   =20
> >>>>=20
> >>>> I've been considered this problem from the opposite approach since L=
SFMM.
> >>>>=20
> >>>> Rather than decide how to move stuff around, what if instead we just
> >>>> decide not to ever put certain classes of memory on CXL.  Right now,=
 so
> >>>> long as CXL is in the page allocator, it's the wild west - any page =
can
> >>>> end up anywhere.
> >>>>=20
> >>>> I have enough data now from ZONE_MOVABLE-only CXL deployments on real
> >>>> workloads to show local CXL expansion is valuable and performant eno=
ugh
> >>>> to be worth deploying - but the key piece for me is that ZONE_MOVABLE
> >>>> disallows GFP_KERNEL.  For example: this keeps SLAB meta-data out of
> >>>> CXL, but allows any given user-driven page allocation (including page
> >>>> cache, file, and anon mappings) to land there.
> >>>>  =20
> >>>  =20
> [snip]
> >>> There's also some feature support that is possible with these CXL mem=
ory
> >>> expansion devices that have started to pop up in labs that can also
> >>> drastically reduce overall TCO.  Perhaps Wei Xu, cc'd, will be able to
> >>> chime in as well.
> >>>=20
> >>> This topic seems due for an alignment session as well, so will look t=
o get
> >>> that scheduled in the coming weeks if people are up for it.   =20
> >>=20
> >> Our experience is that workloads in hyper-scalar data centers such as
> >> Google often have significant cold memory. Offloading this to CXL memo=
ry
> >> devices, backed by cheaper, lower-performance media (e.g. DRAM with
> >> hardware compression), can be a practical approach to reduce overall
> >> TCO. Page promotion and demotion are then critical for such a tiered
> >> memory system. =20
> >=20
> > For the hardware compression devices how are you dealing with capacity =
variation
> > / overcommit?   =20
> I understand that this is indeed one of the key questions from the upstre=
am
> kernel=E2=80=99s perspective.
> So, I am jumping in to answer w.r.t. what we do in ZeroPoint; obviously I=
 can
> not speak of other solutions/deployments. However, our HW interface follo=
ws=20
> existing open specifications from OCP=E2=80=8B [1], so what I am describi=
ng below is
> more widely applicable.
>=20
> At a very high level, the way our HW works is that the DPA is indeed
> overcommitted. Then, there is a control plane over CXL.io (PCIe) which
> exposes the real remaining capacity, as well as some configurable
> MSI-X interrupts that raise warnings when the capacity crosses over
> certain configurable thresholds.
>=20
> Last year I presented this interface in LSF/MM [2]. Based on the feedback=
 I
> got there, we have an early prototype that acts as the *last* memory tier
> before reclaim (kind of "compressed tier in lieu of discard" as was
> suggested to me by Dan).
>=20
> What is different from standard tiering is that the control plane is
> checked on demotion to make sure there is still capacity left. If not, the
> demotion fails. While this seems stable so far, a missing piece is to
> ensure that this tier is mainly written by demotions and not arbitrary ke=
rnel
> allocations (at least as a starting point). I want to explore how mempoli=
cies
> can help there, or something of the sort that Gregory described.
>=20
> This early prototype still needs quite some work in order to find the rig=
ht
> abstractions. Hopefully, I will be able to push an RFC in the near future
> (a couple of months).
>=20
> > Whilst there have been some discussions on that but without a
> > backing store of flash or similar it seems to be challenging to use
> > compressed memory in a tiering system (so as 'normalish' memory) unless=
 you
> > don't mind occasionally and unexpectedly running out of memory (in nasty
> > async ways as dirty cache lines get written back). =20
> There =E2=80=8Bare several things that may be done on the device side. Fo=
r now, I
> think the kernel should be unaware of these. But with what I described
> above, the goal is to have the capacity thresholds configured in a way
> that we can absorb the occasional dirty cache lines that are written back.

In worst case they are far from occasional. It's not hard to imagine a mali=
cious
program that ensures that all L3 in a system (say 256MiB+) is full of cache=
 lines
from the far compressed memory all of which are changed in a fashion that m=
akes
the allocation much less compressible.  If you are doing compression at cac=
he line
granularity that's not so bad because it would only be 256MiB margin needed.
If the system in question is doing large block side compression, say 4KiB.
Then we have a 64x write amplification multiplier. If the virus is streamin=
g over
memory the evictions we are seeing at the result of new lines being fetched
to be made much less compressible.

Add a accelerator (say DPDK or other zero copy into userspace buffers) into=
 the
mix and you have a mess. You'll need to be extremely careful with what goes
in this compressed memory or hold enormous buffer capacity against fast
changes in compressability.

Key is that all software is potentially malicious (sometimes accidentally s=
o ;)

Now, if we can put this into a special pool where it is acceptable to drop =
the writes
and return poison (so the application crashes) then that may be fine.

Or block writes.   Running compressed memory as read only CoW is one way to
avoid this problem.


> >=20
> > Or do you mean zswap type use with a hardware offload of the actual
> > compression? =20
> I would categorize this as a completely different discussion (and product
> line for us).
>=20
> [1] https://www.opencompute.org/documents/hyperscale-tiered-memory-expand=
er-specification-for-compute-express-link-cxl-1-pdf
> [2] https://www.youtube.com/watch?v=3DtXWEbaJmZ_s
>=20
> Thanks,
> Yiannis
>=20
> PS: Sending from a personal email address to avoid issues with
> confidentiality footers of the corporate domain.

