Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB41E73156
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 10:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2866B0095; Mon,  2 Feb 2026 05:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190776B0096; Mon,  2 Feb 2026 05:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072826B0098; Mon,  2 Feb 2026 05:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E56E96B0095
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:42:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 873F41C05C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:42:42 +0000 (UTC)
X-FDA: 84399178164.04.083AFB1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98FF214000B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:42:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DyaABcRo;
	spf=pass (imf09.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770028960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7/UoGexj1ETkd/K5LXbRQhZcZhJWXdNgd3Wm1KnsOs=;
	b=EZqjLTTULPRquksit4IJZjp72VKh0k+8R6dB0m9TvSetImnhptiPa2Zt7rQotrJDD1CBtQ
	6SXnrDlL2WVjTRJMLULnsUuV/GCiSXceK/G8XNGj97KGIlJSWzHe9e8/j53O1FeqV9Qt41
	pkE5JC+fFpt0jihdQDRl5RgtFTBHEn4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DyaABcRo;
	spf=pass (imf09.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770028960; a=rsa-sha256;
	cv=none;
	b=uaARjnqfS+BTt91d+xWvYoadxCA3YwsFz0uxFX1pAqn0GZCGZoFTgHXNOgiwGicxP0/1vl
	4ICU8uJh6ijg3yLzdMsQI72J6ArcD+MxcnuK0dtA4dxZDa6JxRWMdWje9860bDXw9xM1Xz
	zWsXue14jgRPyKetiZIf1O+SUIjzn7s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770028960; x=1801564960;
  h=message-id:subject:from:to:cc:in-reply-to:references:
   content-transfer-encoding:mime-version:date;
  bh=HfbgfI4yoG07K2TM8oxZOyfmUnfK+HlfALUvR7rwYzE=;
  b=DyaABcRoJP802IiCg7eCg53wHNXoPsvFTUggbe1yRnafnnc7iv0G+UKn
   L0BB5mEiYa6R5t6HpwFPKBY2LSGL2tiwfdlJ+/6uX6tYeZxCYHpxLB4GU
   m848izSvVCQmkTYiXlxdV0oFUDyX2gBGK++QFiVqtvgJLrxNpTUgI5266
   yktDKbS6G/6qX+K5jF5+dDADgk/cMBEQCiq2Ag4+72Yms55yE1Nf4ZjVV
   pfV/tXwD+lbxlNDApkJD+fvfJEE45/FCBLLiwHpBb1k3KMvaHHtVw68SR
   U8URi8Q6O3LWwiy1MQgEb8ysbI6kRZdPNDHxjbfZQGxQkCc9Na3Yudgpj
   w==;
X-CSE-ConnectionGUID: yJQrCfwYRWGeBvM3McEWvw==
X-CSE-MsgGUID: qg6Ji9lZR2GcwrNZK4ACsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="70902264"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="70902264"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 02:42:38 -0800
X-CSE-ConnectionGUID: pV+IQe09Sm2wunR2/xlRUw==
X-CSE-MsgGUID: U+mXd3PfRU2BapCal+fMkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="213591322"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.223]) ([10.245.244.223])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 02:42:34 -0800
Message-ID: <d8c02e59a4cdd2d02b41aa5ce8dcd36a94fbba86.camel@linux.intel.com>
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
In-Reply-To: <ymg5yawktqtw7vfgt77iciqzxhjlsnqrwnjx3xmkflbjqbmq5s@jcxzcymqq2af>
References: <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
	 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
	 <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
	 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
	 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
	 <aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com>
	 <81b9ffa6-7624-4ab0-89b7-5502bc6c711a@nvidia.com>
	 <aX/AgHAZ7Tl4iOua@lstrano-desk.jf.intel.com>
	 <lbqqmohxpeynsrunbdyvod2fm4tinzq5coueh2mq6weubste5x@y4f5weqvwszg>
	 <f48e3d818c6e20d6ea7a7fbd6b1741f25df17a78.camel@linux.intel.com>
	 <ymg5yawktqtw7vfgt77iciqzxhjlsnqrwnjx3xmkflbjqbmq5s@jcxzcymqq2af>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Date: Mon, 02 Feb 2026 11:41:56 +0100
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98FF214000B
X-Stat-Signature: jp7u588rmhuyi5i3dp7ytr6k4iskuqoo
X-Rspam-User: 
X-HE-Tag: 1770028959-386036
X-HE-Meta: U2FsdGVkX1/v9YlnL3FRetWGYfYdDqvR2n1bXzgOc9fg881OCv+NP4azb+Kz79qcF9+YOfnI7yKVNpqmgw4Zws2uFgH/wUUm5zTdAvrLj+ijkgdF8vA1DVHCsI5AClgK6mfnNgH/Gx+yfCgYgrxzELq9e7hyJloF0iDR5pMVmjiYBDpe59NK03N5RNce3BxBsH1fKsStTPqrOyhtDR6nYboSK+/n3nhWR5Qg8NhLzWvwvsM1QOtthQVFZqx+ehd2cxJv5ErTL0rJUATUwVtB2TN72wGziDLhFrQc6VOrS1SEr1J+Tqpz+fz7OxDeH8sD9zT/Nl3Gyd6zdILEaact0wruvJQUFoKlAsdpm0Yv9Z8fWZ7thAF6ZgUzbNfC2F6WIfCh/yK71uRkFi9k0TzFiNq/HQ+W+85IE6SpDHFSqa8Xwh0o6jAF8kAbiaAzBo1q38g8Ll92ZQ/kMBUgr+QrAPS5rcftIoINw2ITENXiy1ZljJyzCYgq6YXf1TRJLdSqxVWZR1KWlUJqjzBnyWmtItrB775mMvOZmR6kFuLh3X9nEUC9xr/VaON6qge6qL6UxFxdfuNWQ881RUEdxth/erCbTNl2XFPA+Lr8fuCYJk1i4hX+zmm1erWYX6tNzHOd8fZ2rWweGQkQZT164/SKeEMPamFE8BPoVEci9HyaIlq7xtS5OZYmoW+PaKEiMKxzNCesDUIxh3tgkIFgT+nQD5VaHkrSas85kJbjbNOWjT3Tanm8OI9p8fwT0OoSwgFef467qC5PPVxhbaxvFpRlhNQtRtdCkPGtbUY4xGNZuGnW/ykVtXvKRv7Y6wIOgslODzK51UtnQo5HEQlhtE39LUBpZHGLRmMn00dRtOPPHE7ePV5T5hsyJHOkj0bfRMjNfuLld4YwQQliHW2/KrT0JxYlaymtFPTboauTEe8AUDNA3+GSRTE8Ycat/NPWG/2rQhdiHFgNQPpiOqLZ0ao
 jqZxsr1M
 VZKSzAHqxqZ+WsTAK71ZyVBOw43gGCIr/0vrRlHRhCROqNUZRi85zf1BHHJjCagbCxMiwyOTiJNXP2oKQTnzmDTA18F2MnlYxsaCOOfmdVl8SAdo5bat5rtiTlnQzp5hC/lQ2eh+1VnHpxv5avO+g9nw70J8EihP9g+WOtRixvJr4NWJ7Se87qllyFVwcuRHtULoRyosV58IcRByIAtU7CgyEmW7znYsEKbvSK4gODeUkw083XuTkjwpr0Uq2pshb1XV/laxh35OgbNEnwxgIR6P3SKCJBASkLM/z3cwgcU7YfzibsD7coEc02mNZYFGyijuSIWfXaEFIPTA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-02 at 21:25 +1100, Alistair Popple wrote:
> On 2026-02-02 at 20:30 +1100, Thomas Hellstr=C3=B6m
> <thomas.hellstrom@linux.intel.com> wrote...
> > Hi,
> >=20
> > On Mon, 2026-02-02 at 11:10 +1100, Alistair Popple wrote:
> > > On 2026-02-02 at 08:07 +1100, Matthew Brost
> > > <matthew.brost@intel.com>
> > > wrote...
> > > > On Sun, Feb 01, 2026 at 12:48:33PM -0800, John Hubbard wrote:
> > > > > On 2/1/26 11:24 AM, Matthew Brost wrote:
> > > > > > On Sat, Jan 31, 2026 at 01:42:20PM -0800, John Hubbard
> > > > > > wrote:
> > > > > > > On 1/31/26 11:00 AM, Matthew Brost wrote:
> > > > > > > > On Sat, Jan 31, 2026 at 01:57:21PM +0100, Thomas
> > > > > > > > Hellstr=C3=B6m
> > > > > > > > wrote:
> > > > > > > > > On Fri, 2026-01-30 at 19:01 -0800, John Hubbard
> > > > > > > > > wrote:
> > > > > > > > > > On 1/30/26 10:00 AM, Andrew Morton wrote:
> > > > > > > > > > > On Fri, 30 Jan 2026 15:45:29 +0100 Thomas
> > > > > > > > > > > Hellstr=C3=B6m
> > > > > > > > > > > wrote:
> > > > > > > > > > ...
> > > > > > > > I=E2=80=99m not convinced the folio refcount has any bearin=
g if
> > > > > > > > we
> > > > > > > > can take a
> > > > > > > > sleeping lock in do_swap_page, but perhaps I=E2=80=99m miss=
ing
> > > > > > > > something.
> > >=20
> > > I think the point of the trylock vs. lock is that if you can't
> > > immediately
> > > lock the page then it's an indication the page is undergoing a
> > > migration.
> > > In other words there's no point waiting for the lock and then
> > > trying
> > > to call
> > > migrate_to_ram() as the page will have already moved by the time
> > > you
> > > acquire
> > > the lock. Of course that just means you spin faulting until the
> > > page
> > > finally
> > > migrates.
> > >=20
> > > If I'm understanding the problem it sounds like we just want to
> > > sleep
> > > until the
> > > migration is complete, ie. same as the migration entry path. We
> > > don't
> > > have a
> > > device_private_entry_wait() function, but I don't think we need
> > > one,
> > > see below.
> > >=20
> > > > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > > > index da360a6eb8a4..1e7ccc4a1a6c 100644
> > > > > > --- a/mm/memory.c
> > > > > > +++ b/mm/memory.c
> > > > > > @@ -4652,6 +4652,8 @@ vm_fault_t do_swap_page(struct
> > > > > > vm_fault
> > > > > > *vmf)
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 vmf->page =3D
> > > > > > softleaf_to_page(entry);
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 ret =3D
> > > > > > remove_device_exclusive_entry(vmf);
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if
> > > > > > (softleaf_is_device_private(entry))
> > > > > > {
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 st=
ruct dev_pagemap *pgmap;
> > > > > > +
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (vmf->flags &
> > > > > > FAULT_FLAG_VMA_LOCK)
> > > > > > {
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * migrate_to_r=
am is not
> > > > > > yet
> > > > > > ready to operate
> > > > > > @@ -4670,21 +4672,15 @@ vm_fault_t do_swap_page(struct
> > > > > > vm_fault
> > > > > > *vmf)
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > > > > > vmf-
> > > > > > > orig_pte)))
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto unlock;
> > > > > >=20
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * Get a page reference while we
> > > > > > know
> > > > > > the page can't be
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * freed.
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 */
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (trylock_page(vmf->page)) {
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dev_pagemap *pgmap;
> > > > > > -
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 get_page(vmf->page);
> > >=20
> > > At this point we:
> > > 1. Know the page needs to migrate
> > > 2. Have the page locked
> > > 3. Have a reference on the page
> > > 4. Have the PTL locked
> > >=20
> > > Or in other words we have everything we need to install a
> > > migration
> > > entry,
> > > so why not just do that? This thread would then proceed into
> > > migrate_to_ram()
> > > having already done migrate_vma_collect_pmd() for the faulting
> > > page
> > > and any
> > > other threads would just sleep in the wait on migration entry
> > > path
> > > until the
> > > migration is complete, avoiding the livelock problem the trylock
> > > was
> > > introduced
> > > for in 1afaeb8293c9a.
> > >=20
> > > =C2=A0- Alistair
> > >=20
> > > > >=20
> >=20
> > There will always be a small time between when the page is locked
> > and
> > when we can install a migration entry. If the page only has a
> > single
> > mapcount, then the PTL lock is held during this time so the issue
> > does
> > not occur. But for multiple map-counts we need to release the PTL
> > lock
> > in migration to run try_to_migrate(), and before that, the migrate
> > code
> > is running lru_add_drain_all() and gets stuck.
>=20
> Oh right, my solution would be fine for the single mapping case but I
> hadn't
> fully thought through the implications of other threads accessing
> this for
> multiple map-counts. Agree it doesn't solve anything there (the rest
> of the
> threads would still spin on the trylock).
>=20
> Still we could use a similar solution for waiting on device-private
> entries as
> we do for migration entries. Instead of spinning on the trylock (ie.
> PG_locked)
> we could just wait on it to become unlocked if it's already locked.
> Would
> something like the below completely untested code work? (obviously
> this is a bit
> of hack, to do it properly you'd want to do more than just remove the
> check from
> migration_entry_wait)

Well I guess there could be failed migration where something is
aborting the migration even after a page is locked. Also we must unlock
the PTL lock before waiting otherwise we could deadlock.

I believe a robust solution would be to take a folio reference and do a
sleeping lock like John's example. Then to assert that a folio pin-
count, not ref-count is required to pin a device-private folio. That
would eliminate the problem of the refcount held while locking blocking
migration. It looks like that's fully consistent with=20

https://docs.kernel.org/core-api/pin_user_pages.html

Then as general improvements we should fully unmap pages before calling
lru_add_drain_all() as MBrost suggest and finally, to be more nice to
the system in the common cases, add a cond_resched() to
hmm_range_fault().

Thanks,
Thomas



>=20
> ---
>=20
> diff --git a/mm/memory.c b/mm/memory.c
> index 2a55edc48a65..3e5e205ee279 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4678,10 +4678,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> =C2=A0				pte_unmap_unlock(vmf->pte, vmf-
> >ptl);
> =C2=A0				pgmap =3D page_pgmap(vmf->page);
> =C2=A0				ret =3D pgmap->ops-
> >migrate_to_ram(vmf);
> -				unlock_page(vmf->page);
> =C2=A0				put_page(vmf->page);
> =C2=A0			} else {
> -				pte_unmap_unlock(vmf->pte, vmf-
> >ptl);
> +				migration_entry_wait(vma->vm_mm,
> vmf->pmd,
> +						=C2=A0=C2=A0=C2=A0=C2=A0 vmf->address);
> =C2=A0			}
> =C2=A0		} else if (softleaf_is_hwpoison(entry)) {
> =C2=A0			ret =3D VM_FAULT_HWPOISON;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 5169f9717f60..b676daf0f4e8 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -496,8 +496,6 @@ void migration_entry_wait(struct mm_struct *mm,
> pmd_t *pmd,
> =C2=A0		goto out;
> =C2=A0
> =C2=A0	entry =3D softleaf_from_pte(pte);
> -	if (!softleaf_is_migration(entry))
> -		goto out;
> =C2=A0
> =C2=A0	migration_entry_wait_on_locked(entry, ptl);
> =C2=A0	return;

