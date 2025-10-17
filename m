Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7A33CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3DF8E0047; Fri, 17 Oct 2025 10:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1833E8E003B; Fri, 17 Oct 2025 10:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0228E0047; Fri, 17 Oct 2025 10:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECCA98E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:36:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B16541DCC31
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:36:24 +0000 (UTC)
X-FDA: 84007856688.17.5323BD0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0B3EF14000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:36:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760711783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cuKjCkzehuBLP/u773WqlHFZYm3QCk3WwLmJemwyh80=;
	b=JUhCrvwFwhuGj5gMHQandmr3tKh3L4HVdzeIjywRna+SVVWugZ8jiYKuHIX21XMOvKm1gR
	HuB5h8DWE+J2MXQsnX0xhRXKbraKmvfPAv53ByvrhdpbAwn/FThzmqTXKmqQWCvXzzNw/e
	zosEoeb8/bSClsoTYci7hF6Bos5CBgo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760711783; a=rsa-sha256;
	cv=none;
	b=vmv2VpTZXbJDjfqXRi+FW2EZnKQUgiHhYJpDr12TyX3sKsi1+aInq1P1qermaoliy3MZnA
	avL0Vik1+bDE41wF8VXpuOiqZQWPxE6wUrIIWvsHAwCGUK1zVIg/U7eRim19Gp0qdmoZyi
	GczYWPLqre9lJryJZR+tkGr3h6ato8o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cp6kQ1HMKz6L5Dj;
	Fri, 17 Oct 2025 22:33:18 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A2C5B1402FF;
	Fri, 17 Oct 2025 22:36:16 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 17 Oct
 2025 15:36:15 +0100
Date: Fri, 17 Oct 2025 15:36:13 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, Wei Xu
	<weixugc@google.com>, David Rientjes <rientjes@google.com>, Matthew Wilcox
	<willy@infradead.org>, Bharata B Rao <bharata@amd.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <sj@kernel.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<yiannis@zptcorp.com>, "Adam Manzanares" <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <20251017153613.00004940@huawei.com>
In-Reply-To: <aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
References: <20250917174941.000061d3@huawei.com>
	<5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
	<20250925160058.00002645@huawei.com>
	<aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
	<20250925162426.00007474@huawei.com>
	<aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
	<20250925182308.00001be4@huawei.com>
	<aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
	<aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
	<CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
	<aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam05
X-Stat-Signature: py5iw18hziua596drjfijygm68gss61m
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B3EF14000A
X-HE-Tag: 1760711781-405923
X-HE-Meta: U2FsdGVkX1/DUfp+WjInjc1IvapcA+uZrOuED3HqxRKhlpJyupNbpWt+vQ7BYCHeiFe/lLmuNJ04MIbNclFhkQDLRTMXU8HJy1coUceRVgL1EEQ3cwgwDueNlDMMggpDYiDb+N3qV6vmXgg7/Vzb70QXjHNNHn4g9+BUQswfOnbDQjXpaJTB0chR1qMG+fSWEvrOa6qp+ji4RUvt4oy7V2/mMYx6VCwKWoWwPjOBiU4etPx2r4v4RZWf2q90VePyLRSS3Y22Y6/zUX1D5IBQ8k0pLEDA+aR5pZiX6DjPpo8ePoz7ROWf+y8FEeIi9GeRScasTIIOFrDH3mBmQXR0FIxOPPkfr2glsbEBcpZPh3VqD4YqB/e2DOrUhwTkVpIrHQ2r5xIWQQKyMk65AVVhFO/9KQW6muUdpPvhUNahafHFkRt495k0PVMJ+kzo5iVxVGyTywmiphs0/zxsPaYa1xhcEPzaLh0lJcy6O1L2YS+qSj8YPYUzgI+edS6xV8uAsS34pyAOiyulCY98kxPRP88AunCIfKgWablNnNIR7BaAt2UXskEJ8USxEBwKkF9OgZ2HNdeV2GrYKIwa1hQnoFHmNCMqJrDUtZrbEtdgMMxTxpK/alXb9vSbIpnizjusWQaRLZcUWvHS7MsS3QRb2MlC2JJIn9hpUrN3XolzLqzsI73QjVj+Wpyspoe6f62vT/viaKyy8KLAII4HhcgyLban+g+05lcZIhOQnF5EBMG1C/qkLNNyNPM8whqSYXXHJsdgs07m3uWgsBKKoL+VsRqKBzAixYJ6/9ovxl1V37Za2nN+k3gFwccHPClmLnrHZ0toqMwDcbwfdifyWV0R6G+qtT1oz9Hot9uBo6pveauSlotac1iAvovbcLrS2tzssr7KSm4XiISXoqRdzV4Pn9J1k+Vz5/S9ZmQwj5k/co/sXWuzkCsFBWD0WX/mvY6KFHitoENxWm9syWpqJD7
 3KVl+zVr
 81kE5WFbU9g9PebCsRX8KVra5hXlQd1XXO6aiPyANosXL6+KDmDbRCJRZUky/xgn18eXwsEtKWhbEgwJkFAVbB3Eudi5/bN6k6D4AG60qc+tDNQuy+9k1m+IcFq/RZO0imlLDNExIoiHdqKsLVqEMCfdYzfaHuYewhx68AoZ2CI6BnCb5yO4AN4obYJi6vrfZ/FQpf1P+Sxj+wbyqKwOJUYMWOgIf1NZLe4ldVXvboXOmWSLAjmVJiFVyUuGKv2gZm6uSPMxM4PeZmGTxgZzPh9bz43sw4i0CrZPziA7JFlbygbUSOU8mVOWvUHHosOuXpZldmcvE3kW5wSr61ZeBRO82QwsV6eesMdumUnF5LHRpJoE+us8VELvMQIC09/QzWolCsVU99DMW7/gvuRyGKxaVpv5T4JKQTUddCFqfMrHmpCA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 10:15:57 -0400
Gregory Price <gourry@gourry.net> wrote:

> On Fri, Oct 17, 2025 at 11:53:31AM +0200, Yiannis Nikolakopoulos wrote:
> > On Wed, Oct 1, 2025 at 9:22=E2=80=AFAM Gregory Price <gourry@gourry.net=
> wrote: =20
> > > 1. Carve out an explicit proximity domain (NUMA node) for the compres=
sed
> > >    region via SRAT.
> > >    https://docs.kernel.org/driver-api/cxl/platform/acpi/srat.html
> > >
> > > 2. Make sure this proximity domain (NUMA node) has separate data in t=
he
> > >    HMAT so it can be an explicit demotion target for higher tiers
> > >    https://docs.kernel.org/driver-api/cxl/platform/acpi/hmat.html =20
> > This makes sense. I've done a dirty hardcoding trick in my prototype
> > so that my node is always the last target. I'll have a look on how to
> > make this right. =20
>=20
> I think it's probably a CEDT/CDAT/HMAT/SRAT/etc negotiation.
>=20
> Essentially the platform needs to allow a single device to expose
> multiple numa nodes based on different expected performance.  From
> those ranges.  Then software needs to program the HDM decoders
> appropriately.

It's a bit 'fuzzy' to justify but maybe (for CXL) a CFWMS flag (so CEDT
as you mention) to say this host memory region may be backed by
compressed memory?

Might be able to justify it from spec point of view by arguing that
compression is a QoS related characteristic. Always possible host
hardware will want to handle it differently before it even hits the
bus even if it's just a case throttling writing differently.

That then ends up in it's own NUMA node.  Whether we take on the
splitting CFMWS entries into multiple NUMA nodes depending on what
backing devices end up in them is something we kicked into the long
grass originally, but that can definitely be revisited.  That
doesn't matter for initial support of compressed memory though if
we can do it via a seperate CXL Fixed Memory Window Structure (CFMWS)
in CEDT.

>=20
> > > 5. in `alloc_migration_target()` mm/migrate.c
> > >    Since nid is not a valid buddy-allocator target, everything here
> > >    will fail.  So we can simply append the following to the bottom
> > >
> > >    device_folio_alloc =3D nid_to_alloc(nid, DEVICE_FOLIO_ALLOC);
> > >    if (device_folio_alloc)
> > >        folio =3D device_folio_alloc(...)
> > >    return folio; =20
> > In my current prototype alloc_migration_target was working (naively).
> > Steps 3, 4 and 5 seem like an interesting thing to try after all this
> > discussion. =20
> > > =20
>=20
> Right because the memory is directly accessible to the buddy allocator.
> What i'm proposing would remove this memory from the buddy allocator and
> force more explicit integration (in this case with this function).
>=20
> more explicitly: in this design __folio_alloc can never access this
>                  memory.
>=20
> ~Gregory


