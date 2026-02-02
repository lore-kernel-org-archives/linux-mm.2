Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 019CCE7315C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329706B009E; Mon,  2 Feb 2026 06:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300EC6B00A0; Mon,  2 Feb 2026 06:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CE46B00BA; Mon,  2 Feb 2026 06:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2F06B009E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:44:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B461A1A0105
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:44:55 +0000 (UTC)
X-FDA: 84399334950.27.246204F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf21.hostedemail.com (Postfix) with ESMTP id BFE641C0007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:44:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HTKTsusy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770032693; a=rsa-sha256;
	cv=none;
	b=1KZueJBH1BVpPmnMyShqxLPIXrmrO8dEShA8tfXqoTQhogij029yIllRHFzMmzT17+SPi+
	Lg0AObvfUax8iKXtw6ovKnRWxhS0ZRmqVngM5p5GdWpFXWw2+2Fr1h3rE9Gj2VS9Kgh1ZS
	QYrWIe6Y6VLeDYjwHdFzDi42JJ94Wzc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HTKTsusy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770032693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CnG0HVhjNFVhTP4Z4vAEg6dftpKIgl/1V1pEEF2Lbk=;
	b=eXMVlnqae6IiD33vphCAZFWi5tTJhEAi/wwPUNN7nKBqTlcFiVPMWUw0ZGres5BRydko71
	0fMpHGIXusxWb8D5w0qYUvj2EeyUyJJwqsK28aUyDvV8ZLFO/mK2FDLPbNJznbUSSCfmZw
	PSxJbhVRLiO+MqHd+2Q4Arr1T+nd1B8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770032693; x=1801568693;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nTQb7GKlGehjxCC8oec5SpGDjSvZj+LFw8LcL2d9MxQ=;
  b=HTKTsusyeUQ1mTisNpJd05AtewWUBHWR8VzTYsV/580FxGEYDoZ5CnkX
   kO8ETw4vvcs+nR+kdxxvE3Z9FBWMMuZ9n/FSNXfdbL2JpFOqO4rxFAt2u
   SCrlrD+sL1JrhMZ43vnZVMIHvZ+GO/kuYfihAORRrnGDhNxOS8RY92GEF
   GKbH3bkV73K8H6wPHGdBhhZhvDHvbXdlSSrqOQVnYEYE5cTBKGSOgRXDt
   nHwqCXBsCGYs5ZdkbGAw8BhJl7UNQS0qdxeZrkxcN6ShrwMHMl3cRBGYH
   2B6LmxXYmK+/c/FUWCxdhfRVMTdj3ZaQ5TAWu4D434f6mduYqHXM3ePqU
   Q==;
X-CSE-ConnectionGUID: /9npnxKnQHmXl52BmoXd5A==
X-CSE-MsgGUID: nRTB82lHSySSSJ1MLoWCQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="75045200"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="75045200"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 03:44:52 -0800
X-CSE-ConnectionGUID: rjdZyjFZRY+cJ9W/htnPMg==
X-CSE-MsgGUID: wXk5zyqOTE+Glg4hh7d03Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="208605031"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.223]) ([10.245.244.223])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 03:44:49 -0800
Message-ID: <aaffa3f1bbb97e61d86c0e4ac474cdc8b983b85b.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>, John Hubbard
 <jhubbard@nvidia.com>,  Andrew Morton <akpm@linux-foundation.org>,
 intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>, 
 Christoph Hellwig	 <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Leon Romanovsky	 <leon@kernel.org>,
 linux-mm@kvack.org, stable@vger.kernel.org, 	dri-devel@lists.freedesktop.org
Date: Mon, 02 Feb 2026 12:44:46 +0100
In-Reply-To: <ewowxagab6ej5xldwsewfvg4wgpmelps2dgqj7efmcnhks4nqg@nqdhfedzlvjb>
References: <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
	 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
	 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
	 <aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com>
	 <81b9ffa6-7624-4ab0-89b7-5502bc6c711a@nvidia.com>
	 <aX/AgHAZ7Tl4iOua@lstrano-desk.jf.intel.com>
	 <lbqqmohxpeynsrunbdyvod2fm4tinzq5coueh2mq6weubste5x@y4f5weqvwszg>
	 <f48e3d818c6e20d6ea7a7fbd6b1741f25df17a78.camel@linux.intel.com>
	 <ymg5yawktqtw7vfgt77iciqzxhjlsnqrwnjx3xmkflbjqbmq5s@jcxzcymqq2af>
	 <d8c02e59a4cdd2d02b41aa5ce8dcd36a94fbba86.camel@linux.intel.com>
	 <ewowxagab6ej5xldwsewfvg4wgpmelps2dgqj7efmcnhks4nqg@nqdhfedzlvjb>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BFE641C0007
X-Stat-Signature: n373jdaudrywj59iejgrj8fh8h8pkzdt
X-HE-Tag: 1770032692-473696
X-HE-Meta: U2FsdGVkX1+/fiT6eTzW0xB+dwjGa8IVNfYme0moE2NGev8uxuMwKQplnoN0eb+2ZBffdhtpsJKKhhh03X9t7718eVi99evp2L0rW2NUTRibmyu/EoRjOaB1pDfz89liO5HSlCtj26pK6EzuIFQEHNDmCEuoZ/D2CvzLvjoHeP/qYBHbHK2ok0zCXS5bGlEW1uNF7OvHtqGc1+Roid5mA6tyiZMyuMJqL+qjDj7uL1pGqG++pXubormNxnzb1D4x37k1wzxF5WA2ImNv4bvQNM6A2bLEr59bW7EAlxBBlM+JyNaDhli7xVgRtxbAXaJ6TW3H918WLwtG991jXnOD8iGr5z48DElFUHohdYggSTYtcjL7lRwY2o2DVGd/0XhXDRykDERXNkPh/+naKMOc+eKypYRG8O0V4ZwSR+ukr5EmTgs2xLNcsfclcYQcwOE8ekRGaGDwOsVdEEH6tIru2XPJTqfk1bDQoJF/dcIv5xc4I7g51jsg43xlwZpJoHH78ZH2jJyYdhAQUic12Nfqis2TpVahVNy81NyO6XrS1qj0jPpplCTzX58r/XG0ld46yX0qI8jmngrXVuEpzRi/4XWBS/y/ZXsh4axwfcxpOb3qc4E2rWO1e5HmCCisnvp/q+SajOkLJklkDVKUTNR/IC6x0/T9YBiHLu77bI5V++5qJaElAXqRNPAF/hZAD73Y7EO+EXnwtUJ4/8AKTpQtK+ZvprR/0HxinEJuY8M28xdJTWuiKI0W+6r7BJutIqY8qrsiiJqDaQEVn2vFkKOQoN/3W0aLzrSF9aB48pS+7a2Fd/EfQU3RmlK5Z86niozJ0cm+TuSlYQV58IKxz6Vzh9HXeR811AkLq29XS/o4KQ+feFQJa1/URtVyZidqn/ulWsaiTnZRp21WwUsg/XqxaQG+hiji4ll3w5G0KT++WIuMCaYpidYr3UMHBrGgRT0EPf4vlPm5r4SI6LNuvN6
 2Ru5//M1
 oINKv8OzuVxn9Afmo8I5QzBhFuY2gKTXeN/ShGbMSkbS6sV99C+jZ0gnvdXJIhjiebdrA5JiV/GMr23MDKbK9ULxKcoIpnmR/JpwQxjJVQ83WaKeiaQcmJqZCUPZvndN2QgdIYgV6M0Vt07qzs3gy/VXzNdunC0aHGYvxEV4Pn3wXLPl+edfW1fGkL30jfHg2bGF6iNYYK0Wka7PF1wgeloy5FGAmT5f06qZjPKP7ZSX3DGhmVPeytntc54i0kMarrHeJbu9lF7OAYoL1UsDUmbQy1hRnsKwVrpsXKlMD9fMByP3rnLF1ied4TPTBdSdchjXFBV2PYyb1TTvTWFUq472DkgAHvp64/WF7QZeI+hcZI+2W7jEufcS+8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-02 at 22:22 +1100, Alistair Popple wrote:
> On 2026-02-02 at 21:41 +1100, Thomas Hellstr=C3=B6m
> <thomas.hellstrom@linux.intel.com> wrote...
> > On Mon, 2026-02-02 at 21:25 +1100, Alistair Popple wrote:
> > > On 2026-02-02 at 20:30 +1100, Thomas Hellstr=C3=B6m
> > > <thomas.hellstrom@linux.intel.com> wrote...
> > > > Hi,
> > > >=20
> > > > On Mon, 2026-02-02 at 11:10 +1100, Alistair Popple wrote:
> > > > > On 2026-02-02 at 08:07 +1100, Matthew Brost
> > > > > <matthew.brost@intel.com>
> > > > > wrote...
> > > > > > On Sun, Feb 01, 2026 at 12:48:33PM -0800, John Hubbard
> > > > > > wrote:
> > > > > > > On 2/1/26 11:24 AM, Matthew Brost wrote:
> > > > > > > > On Sat, Jan 31, 2026 at 01:42:20PM -0800, John Hubbard
> > > > > > > > wrote:
> > > > > > > > > On 1/31/26 11:00 AM, Matthew Brost wrote:
> > > > > > > > > > On Sat, Jan 31, 2026 at 01:57:21PM +0100, Thomas
> > > > > > > > > > Hellstr=C3=B6m
> > > > > > > > > > wrote:
> > > > > > > > > > > On Fri, 2026-01-30 at 19:01 -0800, John Hubbard
> > > > > > > > > > > wrote:
> > > > > > > > > > > > On 1/30/26 10:00 AM, Andrew Morton wrote:
> > > > > > > > > > > > > On Fri, 30 Jan 2026 15:45:29 +0100 Thomas
> > > > > > > > > > > > > Hellstr=C3=B6m
> > > > > > > > > > > > > wrote:
> > > > > > > > > > > > ...
> > > > > > > > > > I=E2=80=99m not convinced the folio refcount has any
> > > > > > > > > > bearing if
> > > > > > > > > > we
> > > > > > > > > > can take a
> > > > > > > > > > sleeping lock in do_swap_page, but perhaps I=E2=80=99m
> > > > > > > > > > missing
> > > > > > > > > > something.
> > > > >=20
> > > > > I think the point of the trylock vs. lock is that if you
> > > > > can't
> > > > > immediately
> > > > > lock the page then it's an indication the page is undergoing
> > > > > a
> > > > > migration.
> > > > > In other words there's no point waiting for the lock and then
> > > > > trying
> > > > > to call
> > > > > migrate_to_ram() as the page will have already moved by the
> > > > > time
> > > > > you
> > > > > acquire
> > > > > the lock. Of course that just means you spin faulting until
> > > > > the
> > > > > page
> > > > > finally
> > > > > migrates.
> > > > >=20
> > > > > If I'm understanding the problem it sounds like we just want
> > > > > to
> > > > > sleep
> > > > > until the
> > > > > migration is complete, ie. same as the migration entry path.
> > > > > We
> > > > > don't
> > > > > have a
> > > > > device_private_entry_wait() function, but I don't think we
> > > > > need
> > > > > one,
> > > > > see below.
> > > > >=20
> > > > > > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > > > > > index da360a6eb8a4..1e7ccc4a1a6c 100644
> > > > > > > > --- a/mm/memory.c
> > > > > > > > +++ b/mm/memory.c
> > > > > > > > @@ -4652,6 +4652,8 @@ vm_fault_t do_swap_page(struct
> > > > > > > > vm_fault
> > > > > > > > *vmf)
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 vmf->page =3D
> > > > > > > > softleaf_to_page(entry);
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ret =3D
> > > > > > > > remove_device_exclusive_entry(vmf);
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if
> > > > > > > > (softleaf_is_device_private(entry))
> > > > > > > > {
> > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 struct dev_pagemap *pgmap;
> > > > > > > > +
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (vmf->flags &
> > > > > > > > FAULT_FLAG_VMA_LOCK)
> > > > > > > > {
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * migrat=
e_to_ram is
> > > > > > > > not
> > > > > > > > yet
> > > > > > > > ready to operate
> > > > > > > > @@ -4670,21 +4672,15 @@ vm_fault_t do_swap_page(struct
> > > > > > > > vm_fault
> > > > > > > > *vmf)
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > > > > > > > =C2=A0
> > > > > > > > vmf-
> > > > > > > > > orig_pte)))
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto unlock;
> > > > > > > >=20
> > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 /*
> > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * Get a page reference while
> > > > > > > > we
> > > > > > > > know
> > > > > > > > the page can't be
> > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 * freed.
> > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 */
> > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (trylock_page(vmf->page)) {
> > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dev_pagemap
> > > > > > > > *pgmap;
> > > > > > > > -
> > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 get_page(vmf->page);
> > > > >=20
> > > > > At this point we:
> > > > > 1. Know the page needs to migrate
> > > > > 2. Have the page locked
> > > > > 3. Have a reference on the page
> > > > > 4. Have the PTL locked
> > > > >=20
> > > > > Or in other words we have everything we need to install a
> > > > > migration
> > > > > entry,
> > > > > so why not just do that? This thread would then proceed into
> > > > > migrate_to_ram()
> > > > > having already done migrate_vma_collect_pmd() for the
> > > > > faulting
> > > > > page
> > > > > and any
> > > > > other threads would just sleep in the wait on migration entry
> > > > > path
> > > > > until the
> > > > > migration is complete, avoiding the livelock problem the
> > > > > trylock
> > > > > was
> > > > > introduced
> > > > > for in 1afaeb8293c9a.
> > > > >=20
> > > > > =C2=A0- Alistair
> > > > >=20
> > > > > > >=20
> > > >=20
> > > > There will always be a small time between when the page is
> > > > locked
> > > > and
> > > > when we can install a migration entry. If the page only has a
> > > > single
> > > > mapcount, then the PTL lock is held during this time so the
> > > > issue
> > > > does
> > > > not occur. But for multiple map-counts we need to release the
> > > > PTL
> > > > lock
> > > > in migration to run try_to_migrate(), and before that, the
> > > > migrate
> > > > code
> > > > is running lru_add_drain_all() and gets stuck.
> > >=20
> > > Oh right, my solution would be fine for the single mapping case
> > > but I
> > > hadn't
> > > fully thought through the implications of other threads accessing
> > > this for
> > > multiple map-counts. Agree it doesn't solve anything there (the
> > > rest
> > > of the
> > > threads would still spin on the trylock).
> > >=20
> > > Still we could use a similar solution for waiting on device-
> > > private
> > > entries as
> > > we do for migration entries. Instead of spinning on the trylock
> > > (ie.
> > > PG_locked)
> > > we could just wait on it to become unlocked if it's already
> > > locked.
> > > Would
> > > something like the below completely untested code work?
> > > (obviously
> > > this is a bit
> > > of hack, to do it properly you'd want to do more than just remove
> > > the
> > > check from
> > > migration_entry_wait)
> >=20
> > Well I guess there could be failed migration where something is
> > aborting the migration even after a page is locked. Also we must
> > unlock
> > the PTL lock before waiting otherwise we could deadlock.
>=20
> Yes, this is exactly what the migration entry wait code does. And if
> there's a
> failed migration, no problem, you just retry. That's not a deadlock
> unless the
> migration never succeeds and then your stuffed anyway.
>=20
> > I believe a robust solution would be to take a folio reference and
> > do a
> > sleeping lock like John's example. Then to assert that a folio pin-
> > count, not ref-count is required to pin a device-private folio.
> > That
> > would eliminate the problem of the refcount held while locking
> > blocking
> > migration. It looks like that's fully consistent with=20
>=20
> Waiting on a migration entry like in my example below is exactly the
> same as
> sleeping on the page lock other than it just waits for the page to be
> unlocked
> rather than trying to lock it.
>=20
> Internally migration_entry_wait_on_locked() is just an open-coded
> version
> of folio_lock() which deals with dropping the PTL and that works
> without a page
> refcount.
>=20
> So I don't understand how this solution isn't robust? It requires no
> funniness
> with refcounts and works practically the same as a sleeping lock.

You're right. I didn't look closely enough into what the
migration_entry_wait_on_locked() did. Sorry about that.

That would indeed fix the problem as well. Then the only argument
remaining for the get-a-reference-and-lock solution would be it's not
starvation prone in the same way. But that's definitely a problem I
think we could live with for now.

I'll give this code a test. BTW that removal of unlock_page() isn't
intentional, right?=20

Thanks,
Thomas


>=20
> =C2=A0- Alistair
>=20
> > https://docs.kernel.org/core-api/pin_user_pages.html
> >=20
> > Then as general improvements we should fully unmap pages before
> > calling
> > lru_add_drain_all() as MBrost suggest and finally, to be more nice
> > to
> > the system in the common cases, add a cond_resched() to
> > hmm_range_fault().
> >=20
> > Thanks,
> > Thomas
> >=20
> >=20
> >=20
> > >=20
> > > ---
> > >=20
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 2a55edc48a65..3e5e205ee279 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4678,10 +4678,10 @@ vm_fault_t do_swap_page(struct vm_fault
> > > *vmf)
> > > =C2=A0				pte_unmap_unlock(vmf->pte, vmf-
> > > > ptl);
> > > =C2=A0				pgmap =3D page_pgmap(vmf->page);
> > > =C2=A0				ret =3D pgmap->ops-
> > > > migrate_to_ram(vmf);
> > > -				unlock_page(vmf->page);
> > > =C2=A0				put_page(vmf->page);
> > > =C2=A0			} else {
> > > -				pte_unmap_unlock(vmf->pte, vmf-
> > > > ptl);
> > > +				migration_entry_wait(vma->vm_mm,
> > > vmf->pmd,
> > > +						=C2=A0=C2=A0=C2=A0=C2=A0 vmf-
> > > >address);
> > > =C2=A0			}
> > > =C2=A0		} else if (softleaf_is_hwpoison(entry)) {
> > > =C2=A0			ret =3D VM_FAULT_HWPOISON;
> > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > index 5169f9717f60..b676daf0f4e8 100644
> > > --- a/mm/migrate.c
> > > +++ b/mm/migrate.c
> > > @@ -496,8 +496,6 @@ void migration_entry_wait(struct mm_struct
> > > *mm,
> > > pmd_t *pmd,
> > > =C2=A0		goto out;
> > > =C2=A0
> > > =C2=A0	entry =3D softleaf_from_pte(pte);
> > > -	if (!softleaf_is_migration(entry))
> > > -		goto out;
> > > =C2=A0
> > > =C2=A0	migration_entry_wait_on_locked(entry, ptl);
> > > =C2=A0	return;

