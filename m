Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1EE606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ksQ/zd19
Received: by kanga.kvack.org (Postfix)
	id 76B446B05B3; Mon, 16 Nov 2026 09:53:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B8F6B05B4; Mon, 16 Nov 2026 09:53:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6319F6B05B5; Mon, 16 Nov 2026 09:53:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCE46B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:53:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A86AE1C0D0D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:53:10 +0000 (UTC)
X-FDA: 85441274940.20.40743A9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id B30D3100008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:53:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ksQ/zd19";
	spf=pass (imf14.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794840788;
	b=WSOW2yQvhNGURsVidFD4PxjvMcSU1+qnFwHgY0dMms88fnCQAYCwCgIq+WE0rrybnr1/bN
	XNzVKpwRbE4l/xpDeKo/+PCVQ9v0S/XBPUKROQzrKr1D4LwByAJ0iERGY1JllyuSkGyQE4
	iDv4RqHs5juybTfFiFl8nuT9/3/0Vbs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ksQ/zd19";
	spf=pass (imf14.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794840788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzhLHauq6wX8slJmqH/D7Lca0l04NMZvOWVaeW+Dhk4=;
	b=t9jxeNG7TArkqAZEgFon+VzMCboO6zUm/PEX989kX3gmSEhLD1wh2vjExBiPDdyGzfjma3
	SDAHaw3rgU7vaRFSoYZNkKsdR7EC0HsvI5YBljFwd52PmPgCuMP+x7NMLrObx9QHEqwGcR
	bbnZl4POPvNvQcTAowYR/AKx+/6aDIM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794840788; x=1826376788;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=FzhLHauq6wX8slJmqH/D7Lca0l04NMZvOWVaeW+Dhk4=;
  b=ksQ/zd19XXDQ53Os10A8rKWUEDEPZzprjw1ZwIeY7DjRlCGgpD883yiH
   JyWPyisK6RIOGYGSTWgKPlJeSmD1oPnqULvxinpl7FN76ut4VB+0d/0Mz
   xpOYSt33z56YCYQNtvfaNXhtd4RAi7lIfXuK6qGOu2On51TzIqh3Qv4PK
   PvSpflwM0aMDh4/IMa6CfZA3fGZ9+vfDLoyvJoQGh0MlIWQP63nVaFQbp
   nHBok+G9Ygtrm6+gv83eM6JcjhD5ncUk6/Tq3xQx1VsMY/AzsHMez5YPe
   escTjYTIVXBBRCLaUKXnzCR3EQcQHT0SRizHQ3GVIY7oTQV4jkc9/bZAL
   A==;
X-CSE-ConnectionGUID: 4ZzZ9tbQQl+33wr3XA+o1w==
X-CSE-MsgGUID: Q09BLVjLS7WxbbUKNg6alw==
X-IronPort-AV: E=McAfee;i="6800,10657,11968"; a="3473943"
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="3473943"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 06:53:07 -0800
X-CSE-ConnectionGUID: RVsed9SRR6mHGYbHqTSNHg==
X-CSE-MsgGUID: CWFaW/ViQIG8kW8ZlcLLzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="9371256"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.245.189]) ([10.245.245.189])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 06:53:04 -0800
Message-ID: <58755e3cb51d534b749d70847a5478a40c1c10fa.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Matthew Auld
	 <matthew.auld@intel.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, Matthew
 Brost <matthew.brost@intel.com>, Mika =?ISO-8859-1?Q?Penttil=E4?=
 <mpenttil@redhat.com>,  Leon Romanovsky	 <leon@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard	 <jhubbard@nvidia.com>
Date: Mon, 16 Nov 2026 15:53:01 +0100
In-Reply-To: <6af3d5d2-4fab-4a3f-85d9-34564fca8ffe@kernel.org>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
	 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
	 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
	 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
	 <0b794f803517c27ea818a2e894761095300b4da4.camel@linux.intel.com>
	 <6af3d5d2-4fab-4a3f-85d9-34564fca8ffe@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: pxp6y3knp8girn4z9rteq95ucpnumfxw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B30D3100008
X-Rspam-User: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794840787-541518
X-HE-Meta: U2FsdGVkX1+hpuB+hdfwweqT2KqqfiljQ17GHm13hQGlHNDjdNadf1jzIN+XKDhKid2z5VAxOQqSU6WV8fAgaaaqSnU/4CkM7zPLdeovk7p7xEO8EilRYTIJ9S3RXa9oZDKpx6iV9KIWu+ngWMYkbgcUXOMUb75GBEtHZ9HE40Rx/6iuPaLUyNsy37tfvkUgSEQ+dvCY7DVkkdwXUQj8DCjgRicKKEre5OrDyfRKoNMv2zrMppyaPpvluI3Gq/k2I25C93T764+5tl7Qg108EeVWiam82fiez8yhucLkvxg+hrHzqh7ZPXVohJgVK9+4O1/CZeOqgjpR9TvXswq1aq8IE304FN3kbiwwCLaRW7M9PhYzv2CYFyXHCJB4oKKoNRaLxSgLYGADLdSOkTk86BAf8jz/fJyK20hx0W+KaTP0zxEz3xzIj+pXTeMC4Yeg0ZV+dm0QkUSLHqiWP6xYe+NBDJOeQjuYCAA8Pw9yX5YCaDbkuX8lqymYUsBd0jjD0xKuDUF1+vcm0CRo0+fDMqrm+UnthfTE2zRUvFt3q80mSfQ5CHvQIWeNCiKcLKHUpMuMKM0DlTr81reTLsc0X4fguJ7zn+MTkoMviJFchxXASzI1yDlqZcuMfST6Uy1DYm0PvoknGoTszwMNuxY6JK+AxGuT6pasclPUIZkhXxpIeDcKyGTyL0/zoifVH14Z+FQH3KvJneWA3ehnL16xYPcjamDLzPe2GmsIuIRd2cBFlgblwVRF3/LbfBsUytUq2rlaQxNZ5Oz9xvH0058A1m043rsZ/KAGbS7egP+NTKt0pf+M89HSb1PPW3XsLGsDwHtjC3D2qc9kqUBE6Tst3SEMcop3mEadG1IWczoXga+SPQXNZvpZ/YEGugfHvgN6iBQdktiSRycO4DtMlli07RymJ2fl2Y/6OZOViB1gKy8HdWZGTBPawhBWFNvl97Dr/oHim0NKPdzTriZS+1U
 EUupLYzM
 FI5T4jjDwoyeHWn2l/IlqQs2h9QySwKcsoA5z2vYFFK3h8M+g01feh1ImFqMrYVkHJZ5Hk2QpwCxh7/8c2arYkLAA8RfWenKBVuQe+zGaBf7WxAS2ZGNDMQZIrC0yPFu0MiSbDsjKdRT7P1hg8UsV+TZ7XkoMzqOoPGKsHgypEnKLOBrrzF2nGkQhSF17T8czfdacjcSpb79czZ/8D0Lq3e0FvHyT04TTdrbuZX/Je8PV7f4i4sQS5KKDEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-11-13 at 22:19 +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 21:56, Thomas Hellstr=C3=B6m wrote:
> > On Fri, 2026-11-13 at 21:43 +0100, David Hildenbrand (Arm) wrote:
> > > On 11/13/26 21:34, Thomas Hellstr=C3=B6m wrote:
> > > > Hi, David
> > > >=20
> > > >=20
> > > > There are two major problems with the current behaviour.
> > > >=20
> > > > 1) The work item executing hmm_range_fault() might have no
> > > > affinity
> > > > at
> > > > all to the GPU about to access the memory.
> > > >=20
> > > > 2) If migration happens, then hmm_range_fault() will stop and
> > > > retry
> > > > leading to excessive execution time.
> > > >=20
> > > > While perhaps Matt's commit message doesn't correctly describe
> > > > the
> > > > GUP
> > > > behaviour, do you have any alternative suggestion than to avoid
> > > > migration in this case? I think it's a reasonable idea given
> > > > the
> > > > problems with the current code?
> > >=20
> > > Adding fault reasons that hack around NUMA hinting such that a
> > > actual
> > > CPU
> > > accessing it later will not trigger ... NUMA hinting?
> > >=20
> > > I might be missing the "reasonable" in here :P
> >=20
> > Wouldn't the net effect be that content stays put instead of being
> > migrated? In both cases a later CPU access will not trigger NUMA
> > hinting except that the proposed change doesn't send content to an
> > irrelevant node?
>=20
> My point is that you are essentially disabling NUMA hinting because
> the CPU will
> no longer trigger NUMA hinting faults.

Yes, I got that part, but that's is only for a single scan, right? My
point was that we'd replace an irrelevant hint + migration with a NOP
hint. In both cases we'd lose the next relevant CPU access hint.

Granted, in the follow_protnone case we don't do that.


>=20
> But then, just disable it entirely. Maybe John knows what to do.

We can't do that globally, really, for these type of apps. But one
remedy might be recommending the app to mbind() with a no-migration-on-
fault policy.

Also the hmm O(n=C2=B2) complexity in this situation isn't really ideal. We
might need to look at that as well.

Thanks,
Thomas

