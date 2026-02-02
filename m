Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EB6E7314E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 10:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA5B6B0092; Mon,  2 Feb 2026 05:51:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867C06B0096; Mon,  2 Feb 2026 05:51:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774456B0098; Mon,  2 Feb 2026 05:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63EAE6B0092
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:51:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE15616090B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:51:16 +0000 (UTC)
X-FDA: 84399199752.25.E1C4AD5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D0A140006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:51:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nwkp3GgA;
	spf=pass (imf17.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770029474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CU+EqcrQo41HxY+mJmIJYrt/CzhgHVJ/Cwyd+zcgbdA=;
	b=NzZ8248z3UOJZiMbWAWBk+m/bWh0ecNe6SoNdl6ZZn/S1Mxp6w9WWVnUva2S/uNZLPdEPX
	NqjsAH/sGViI4A9bxifSYOWmBIDbBNw8GWbLLP/Bc0GwLfBy1MyI2G55oD5aPCfOAkreu4
	zllWUSrRGTq9zrQWhNlXdXGylaWABMY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nwkp3GgA;
	spf=pass (imf17.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770029474; a=rsa-sha256;
	cv=none;
	b=WlMTj0dZPsZvk8oLjVuV5Ffe3hyosU0zfoIIxWRg+3HwiCvY3JJNigLIzBfBxJDHVmWEcE
	95JrpbMJ6/K3Jc9/bZanxwKRjLabmFi90aa3HKSadOK0B0skGvaYQaGHtG7Ru89pMfsPHu
	xkx+qk2su3ufetJS/NgKk2EF2hiMZas=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770029475; x=1801565475;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=CU+EqcrQo41HxY+mJmIJYrt/CzhgHVJ/Cwyd+zcgbdA=;
  b=Nwkp3GgA8Opl1Qcjvar+8WqI9EiHZpzcLA6I8XEBOPI1z1cxy3wWdPta
   eV5uzQQuP6RyaqCOaYDGuGpy7Wf3jEBXXZ6a/C3R7F8jtKAfd70dUXVnG
   jj0BpRlDsOj69JefknSRlZsfje5CH1GIPeoY3dtMUfp3h3ydBS0ViIRfi
   q5b2wsal6Syb0o/SVggspK3ha0oxDJHevDIG8eEVfs+502v0iyDqM1zyS
   baHwTtlytEytZ/Ev2mOa3CHqmhxM9bmbOPNbrdkCmNtaU+kvzYQ4thiRP
   7Eu8z37JfF+qYYn811EOYHAPml5AW70Hfqm6bxS/F+QuTbCzbOR1Weu0W
   A==;
X-CSE-ConnectionGUID: lTh/3Xi3SleOjOfRPn9cKw==
X-CSE-MsgGUID: +DUYilXlSwa6Obcyt5cZbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="81497367"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="81497367"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 02:51:13 -0800
X-CSE-ConnectionGUID: bdUGNwPTRgCA1JyWkJ5CRQ==
X-CSE-MsgGUID: VxeTC3hDSnaok3tgirY+DQ==
X-ExtLoop1: 1
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.223]) ([10.245.244.223])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 02:51:10 -0800
Message-ID: <6a6e054bb6efe76c439b3329702829dbc75b9060.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>,  Andrew Morton <akpm@linux-foundation.org>,
 intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>, 
 Christoph Hellwig	 <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Leon Romanovsky	 <leon@kernel.org>,
 linux-mm@kvack.org, stable@vger.kernel.org, 	dri-devel@lists.freedesktop.org
Date: Mon, 02 Feb 2026 11:51:08 +0100
In-Reply-To: <nm4qa6fz2kecodhtt7yfcnfx77ik7pr7332amfqvgyhgs5xwqf@v2v6coz5genz>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
	 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
	 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
	 <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
	 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
	 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
	 <a459f147b461c6e6e806282956b7931f74a0aa93.camel@linux.intel.com>
	 <nm4qa6fz2kecodhtt7yfcnfx77ik7pr7332amfqvgyhgs5xwqf@v2v6coz5genz>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Stat-Signature: 3rr88ii17p9u47tn4nh9s8cd6pikbis4
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D0A140006
X-HE-Tag: 1770029474-710421
X-HE-Meta: U2FsdGVkX1+GAgfKjiK9qHaCFlVI0+MBs1wdh/bGEez9axv+aQUPYwjRwZG72t1lJx9UnRt6mchlKBbsepU6DXx9MwVHZjs9BUoVEeEVOLvzLxodZeXuu/TR2YFCX1lnBwrLN/YI75+N+NYkvfQ27C+GpazX9VHw1EmJx9Ux01yezmoerIDlwJVlMh9Vc/oiKveh1sFoZpgmSn9VbLZzyxMKGibfQCQC9vAkFhyAiQBf7TsePqOqkFP/Udy4vt5bi+qlGFjSccSzEl+DC3Kih2bfnmup/YqRqBUvvOhaqXiAOJUpEK/918HnT+6iynFb8we7CatVDLMV1AvYbiRhzMuO5lGgG7wlu4BfeMeIaacZZyUtSGtqv1/CdAmuxatuVsBafNcnvB37arhkZhtxBb0yn8rda/Ji5G7UgOX/EkCjxoMckUfKLvYC6V45/AW79rTo3CyG1obMAeDDNm2w1XxaVfCp7/QizJuf+ZH5SIJSVzn7MzEb7iSYi3g2GJojYZCx4X6+wC2ssP1BxH/K4RUQeRUrSkyAaE852tAvwze2p8UgQUVzvYiuxwuhdGHI+M9OPC45Ec94jq48p+lGFKLDCGZ8pXnoPEkj+f+Qr7qOGFAzchbGYtfkcK+qBnlHg0ArXKqvEyNtNn8kQU+30DLpbp+iF2A7yFr1NYiTscUx8kFixgssgghU6nxtNFQUpeB9vbveu4LOWc0BT6k+ShuSumgnS8bsjPnIc2myZeHYHYsuNgbdy/6dZudxHfPLg4DrCwhobOgqoS+Bjc2hO1fWnK7BCfaPdnQzCyx2JbgUgUqltE4DnSsIE3zCGoc16kkxpPUtxnliOajqnvblm+y4NuIVdL7N7gGZmpf2q+0aqwnQlvyIi/IkE7uGZGq407v52No1vwGnlGi1Eq7Ib4Ft/gMJJvVj71WAfllOBLg9MD5Jd7DvuC4LULH1hjR6HHgeGGzm+KehLUPSf4d
 YMsiDGpr
 m3vKbHG0g3ZMfSXWEvd5uSoXfe/o4klnIcWKoDwwIsrlZhagpxZY65Wpt9LRzZFdKWr68WZAXzGz6bDSmTS6utSRUJd8qZeCTu3ZfSJLyxPY+twDsCXB2OHsN++g3YLIc+PqEv4LzKyjdjZk11exORIcwwlpc3Jf+KUvQXLA6ga+0lAdRQ9O+j58CcEKmbCZS5qHkphtUeYTbpdiiZREICIbX3NMgA/4azHO7h3KWxXZY5AIbgEQC//4bnFt9BWenTx/ZO8BYoQyuqIjj23ONjLylUdF7hRmVS3WhyCHmp4H2OBxJ1RzWbQkS8vLQAzpIGaL8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-02 at 21:34 +1100, Alistair Popple wrote:
> On 2026-02-02 at 20:13 +1100, Thomas Hellstr=C3=B6m
> <thomas.hellstrom@linux.intel.com> wrote...
> > On Sat, 2026-01-31 at 13:42 -0800, John Hubbard wrote:
> > > On 1/31/26 11:00 AM, Matthew Brost wrote:
> > > > On Sat, Jan 31, 2026 at 01:57:21PM +0100, Thomas Hellstr=C3=B6m
> > > > wrote:
> > > > > On Fri, 2026-01-30 at 19:01 -0800, John Hubbard wrote:
> > > > > > On 1/30/26 10:00 AM, Andrew Morton wrote:
> > > > > > > On Fri, 30 Jan 2026 15:45:29 +0100 Thomas Hellstr=C3=B6m
> > > > > > > <thomas.hellstrom@linux.intel.com> wrote:
> > > > > > ...
> > >=20
> > > >=20
> > > > > I'm also not sure a folio refcount should block migration
> > > > > after
> > > > > the
> > > > > introduction of pinned (like in pin_user_pages) pages. Rather
> > > > > perhaps a
> > > > > folio pin-count should block migration and in that case
> > > > > do_swap_page()
> > > > > can definitely do a sleeping folio lock and the problem is
> > > > > gone.
> > >=20
> > > A problem for that specific point is that pincount and refcount
> > > both
> > > mean, "the page is pinned" (which in turn literally means "not
> > > allowed
> > > to migrate/move").
> >=20
> > Yeah this is what I actually want to challenge since this is what
> > blocks us from doing a clean robust solution here. From brief
> > reading
> > of the docs around the pin-count implementation, I understand it as
> > "If
> > you want to access the struct page metadata, get a refcount, If you
> > want to access the actual memory of a page, take a pin-count"
> >=20
> > I guess that might still not be true for all old instances in the
> > kernel using get_user_pages() instead of pin_user_pages() for
> > things
> > like DMA, but perhaps we can set that in stone and document it at
> > least
> > for device-private pages for now which would be sufficient for the
> > do_swap_pages() refcount not to block migration.
>=20
> Having just spent a long time cleaning up a bunch of special
> rules/cases for
> ZONE_DEVICE page refcounting I'm rather against reintroducing them
> just for some
> ZONE_DEVICE pages. So whatever arguments are applied or introduced
> here would
> need to be made to work for all pages, not just some ZONE_DEVICE
> pages.

That's completely understandable. I would like to be able to say if we
apply the argument that when checking the pin-count pages are locked,
lru-isolated and with zero map-count then that would hold for all
pages, but my knowledge of the mm internals isn't sufficient
unfortunately.

So even if that would be an ultimate goal, we would probably have to be
prepared to have to revert (at least temporarily) such a solution for
!ZONE_DEVICE pages and have a plan for handling that.

Thanks,
Thomas


>=20
> > >=20
> > > (In fact, pincount is implemented in terms of refcount, in most
> > > configurations still.)
> >=20
> > Yes but that's only a space optimization never intended to
> > conflict,
> > right? Meaning a pin-count will imply a refcount but a refcount
> > will
> > never imply a pin-count?
> >=20
> > Thanks,
> > Thomas
> >=20

