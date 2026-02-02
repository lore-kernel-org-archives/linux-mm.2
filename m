Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60689E7DEEF
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB196B0095; Mon,  2 Feb 2026 09:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867C96B00AD; Mon,  2 Feb 2026 09:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A3C6B00B4; Mon,  2 Feb 2026 09:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 604C96B0095
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:07:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 327DAD35E2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:07:31 +0000 (UTC)
X-FDA: 84399694302.20.644F104
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6823C120018
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:07:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CHf20sv+;
	spf=pass (imf29.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770041249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOZxQYpt/dEjPvSnLHHJ1aY2dhZAufm5Wt28vAIFGnQ=;
	b=l01mtoMf5dj09lbQyn7V3Q11bdlaTMWC2SQ+65HUv3gfkx7WMMsUkxehsvyVOFQ/f15N0j
	1KHRP/0lB5kK9j741Z8/rZu/EIfdmu5s0c4uDGY2qYWFh2KwORJFNP4k0JU9VtKBoxlDpO
	lJ6LmGXP04ZDB7FBomuuO1iafKKYXmg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CHf20sv+;
	spf=pass (imf29.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770041249; a=rsa-sha256;
	cv=none;
	b=WFzX7vBmDAeZ4FYSOYWJvkCfPdd+8j6NqE1Izki1hu2suBDC/5giWLL1EBeykSiLvReOzG
	0kXkx4Ys4LEHewfr5yFTznqFkuGLVqsKLKcrQqvYNY5gycMljH1m+jJMsp/0v7ILkEP7wd
	ddgSQzbIpG7sf2KwNgKrXLZ1LM15z7E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770041249; x=1801577249;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ZqzrDhj1EDilGK9q5axYNOV/YZlmUYC0LduGT2R5lv4=;
  b=CHf20sv+5pmjqk6d98Bo+GhXuraJZonVChQOxsiw5B7N9WiwGlhaBJ8O
   9kHWSS+REy62uhRrjri7Ksf3+YxmTRIw6+y5/dZ+Qviv64cns7R5khG5d
   chLp3jDDK+qcnSIeoA782w8Q/M1Zg0zR8omroS2szGGzyCcDOBvdCnZrm
   Fr/jj3sgzSisEBhT1+3avynqXbzw2RVABsXHRi6mrys7MOaKB1D3vzqfs
   nWZdf8aQUleGPv/JJ0sO+3I4GGqGKItRSxDx19l/WB8YgpuD8D2QYSqGd
   TlpqDC0XfPkOMlIcoBHYb8ryiliBKufYPSg/cMcnfveC2EuPiNImz/mmg
   w==;
X-CSE-ConnectionGUID: bgCZKKfSQAOaOgHD6DTOIA==
X-CSE-MsgGUID: 0TBqEgb8S2ubHIH0t5+oUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="70917878"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="70917878"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 06:07:27 -0800
X-CSE-ConnectionGUID: cKEYfzuTR5u4KYjUt9zLbw==
X-CSE-MsgGUID: fsCbwpmqTpOP4g2Rlt202Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="214476189"
Received: from rvuia-mobl.ger.corp.intel.com (HELO [10.245.244.242]) ([10.245.244.242])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 06:07:24 -0800
Message-ID: <43d010966fc99ca480f365220ae8c3615e538b07.camel@linux.intel.com>
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
Date: Mon, 02 Feb 2026 15:07:21 +0100
In-Reply-To: <nvajpou3j7osyx553ktafdc3qx3v6hisygho42swkzm6xdbwvt@bg6d25otpqj3>
References: <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
	 <aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com>
	 <81b9ffa6-7624-4ab0-89b7-5502bc6c711a@nvidia.com>
	 <aX/AgHAZ7Tl4iOua@lstrano-desk.jf.intel.com>
	 <lbqqmohxpeynsrunbdyvod2fm4tinzq5coueh2mq6weubste5x@y4f5weqvwszg>
	 <f48e3d818c6e20d6ea7a7fbd6b1741f25df17a78.camel@linux.intel.com>
	 <ymg5yawktqtw7vfgt77iciqzxhjlsnqrwnjx3xmkflbjqbmq5s@jcxzcymqq2af>
	 <d8c02e59a4cdd2d02b41aa5ce8dcd36a94fbba86.camel@linux.intel.com>
	 <ewowxagab6ej5xldwsewfvg4wgpmelps2dgqj7efmcnhks4nqg@nqdhfedzlvjb>
	 <aaffa3f1bbb97e61d86c0e4ac474cdc8b983b85b.camel@linux.intel.com>
	 <nvajpou3j7osyx553ktafdc3qx3v6hisygho42swkzm6xdbwvt@bg6d25otpqj3>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6823C120018
X-Stat-Signature: 7zjsw4h1o69tfumef8z1xj3z5wgihwhc
X-Rspam-User: 
X-HE-Tag: 1770041248-751184
X-HE-Meta: U2FsdGVkX19Vdmo3GwzMT8dgykrKvpvV0XuIeiqG+hTJLJrO4P/JW5Lo3xVr7iKPklRTdwnhvE2ve4iiuLplhOSuoOKXDhPWgwYxXVRB90CQE1abGReTvJXhpPRvEkEJDCVP8jCj2X7oDPq3Qprh/3ALV5wtddIliYM+IBIm26Ou2HqK3nJ+szonF/tXmctWN6RyvMvWpFnPMpV28TMWYvMGNr+pstcegdEu//i6h2F0Dg6He6AX6JjoJprpjJC4ASnzuUBbsloECsNzpPLLToU9bj+oMJGqfGrVbucEchsOvuYl0/QDIwjbORMEF0u6OmHkfgFu4YqAbUSEvgdI7QqQanm8/5OENl48yarTEKRZcRWZOgijCOBiEogUJdnbVZRxiDxDWRhDK8wHviK5wkTbWDmwRqrtpbOEGDpCTaOIU9rNRFmBLh6j57OSSZkEbdNMy1gGDaVanIiExTOumcEYU5AR/2JrNTZ3NLpLejaYcrLyiqmH32/F1M+sPHRAxWLuvbaqSnycAc3EHH0O2cuC83+WxyYBYU6kQKktiZZ55fsa+05hMf9uyhLnz0JxkiEeOXUclmraMcB4DeiNsxgidaC/NwP+2kGuISpHCryaou9iKlVdE2oyaEKsH5ty2F3skKXee2+79XuEC//BX6FwyfrVWCImc2RUvY0WXsD+YeUibvn8qdEHCzNKapvRTWZIR5Vs/FwfT69DQbv4i6hzLmQlFSVEO2suoGOly8Mzh+8LD7RhBBdvndlvSl3yHcKJM4gWS678+w19VbBijcQ3onXnEHtFEY0Yg2DG9f3K7AmrpPCtftvIlheiHdSJSws7GVzSVFIFGMW/v/XNLe0tOqkVIIy4eCdWUJKS6Z/4Tvm8K4iIMJhhHst9LLilXBRmvdUsHsy4jsENAAYJaGy45LkAWQwCN+/QzVam0lh/u7ymujCQm1XTqZFd3i9S0jr1S1tnktvxRSABCKQ
 pOfKtpuU
 jUar6kmUkw23HNo7/Hb0FznLWKiGfkiIwjo92Yn3C4VRTzZ1t+Pss11YXU7jdbm1iJ5MLZTVnboR0hA3VN+fXB22XXEzF1kR5PsH2oIrK53f0Je2txKH/hwQtkcke0+ZuwZXcjmPHZBOByoifCmg5zzhONF6oLx31xboOtEWPEy0z7u5EJ4MdTnxgxb3NR2NPN33UB7Frm1WbvABK1c9ECdLgNZutAFz8ROjyBPKAChtJT6GU9aZsiqFeaJBN4I4c+fkviinvH2MCfXP9Qu7r6msMMzaGnfwQAM3cZoWWztbocp+5ThcK5Zp5SQOY3BGJtgZKdvvGGTNUONf3yvuU61J+NWb30vQS3zj024/BGUJ8iDk1cl+RzRPp2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-02 at 23:26 +1100, Alistair Popple wrote:
> On 2026-02-02 at 22:44 +1100, Thomas Hellstr=C3=B6m
> <thomas.hellstrom@linux.intel.com> wrote...
> > On Mon, 2026-02-02 at 22:22 +1100, Alistair Popple wrote:
> > > On 2026-02-02 at 21:41 +1100, Thomas Hellstr=C3=B6m
> > > <thomas.hellstrom@linux.intel.com> wrote...
> > > > On Mon, 2026-02-02 at 21:25 +1100, Alistair Popple wrote:
> > > > > On 2026-02-02 at 20:30 +1100, Thomas Hellstr=C3=B6m
> > > > > <thomas.hellstrom@linux.intel.com> wrote...
> > > > > > Hi,
> > > > > >=20
> > > > > > On Mon, 2026-02-02 at 11:10 +1100, Alistair Popple wrote:
> > > > > > > On 2026-02-02 at 08:07 +1100, Matthew Brost
> > > > > > > <matthew.brost@intel.com>
> > > > > > > wrote...
> > > > > > > > On Sun, Feb 01, 2026 at 12:48:33PM -0800, John Hubbard
> > > > > > > > wrote:
> > > > > > > > > On 2/1/26 11:24 AM, Matthew Brost wrote:
> > > > > > > > > > On Sat, Jan 31, 2026 at 01:42:20PM -0800, John
> > > > > > > > > > Hubbard
> > > > > > > > > > wrote:
> > > > > > > > > > > On 1/31/26 11:00 AM, Matthew Brost wrote:
> > > > > > > > > > > > On Sat, Jan 31, 2026 at 01:57:21PM +0100,
> > > > > > > > > > > > Thomas
> > > > > > > > > > > > Hellstr=C3=B6m
> > > > > > > > > > > > wrote:
> > > > > > > > > > > > > On Fri, 2026-01-30 at 19:01 -0800, John
> > > > > > > > > > > > > Hubbard
> > > > > > > > > > > > > wrote:
> > > > > > > > > > > > > > On 1/30/26 10:00 AM, Andrew Morton wrote:
> > > > > > > > > > > > > > > On Fri, 30 Jan 2026 15:45:29 +0100 Thomas
> > > > > > > > > > > > > > > Hellstr=C3=B6m
> > > > > > > > > > > > > > > wrote:
> > > > > > > > > > > > > > ...
> > > > > > > > > > > > I=E2=80=99m not convinced the folio refcount has an=
y
> > > > > > > > > > > > bearing if
> > > > > > > > > > > > we
> > > > > > > > > > > > can take a
> > > > > > > > > > > > sleeping lock in do_swap_page, but perhaps I=E2=80=
=99m
> > > > > > > > > > > > missing
> > > > > > > > > > > > something.
> > > > > > >=20
> > > > > > > I think the point of the trylock vs. lock is that if you
> > > > > > > can't
> > > > > > > immediately
> > > > > > > lock the page then it's an indication the page is
> > > > > > > undergoing
> > > > > > > a
> > > > > > > migration.
> > > > > > > In other words there's no point waiting for the lock and
> > > > > > > then
> > > > > > > trying
> > > > > > > to call
> > > > > > > migrate_to_ram() as the page will have already moved by
> > > > > > > the
> > > > > > > time
> > > > > > > you
> > > > > > > acquire
> > > > > > > the lock. Of course that just means you spin faulting
> > > > > > > until
> > > > > > > the
> > > > > > > page
> > > > > > > finally
> > > > > > > migrates.
> > > > > > >=20
> > > > > > > If I'm understanding the problem it sounds like we just
> > > > > > > want
> > > > > > > to
> > > > > > > sleep
> > > > > > > until the
> > > > > > > migration is complete, ie. same as the migration entry
> > > > > > > path.
> > > > > > > We
> > > > > > > don't
> > > > > > > have a
> > > > > > > device_private_entry_wait() function, but I don't think
> > > > > > > we
> > > > > > > need
> > > > > > > one,
> > > > > > > see below.
> > > > > > >=20
> > > > > > > > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > > > > > > > index da360a6eb8a4..1e7ccc4a1a6c 100644
> > > > > > > > > > --- a/mm/memory.c
> > > > > > > > > > +++ b/mm/memory.c
> > > > > > > > > > @@ -4652,6 +4652,8 @@ vm_fault_t
> > > > > > > > > > do_swap_page(struct
> > > > > > > > > > vm_fault
> > > > > > > > > > *vmf)
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 vmf->page =3D
> > > > > > > > > > softleaf_to_page(entry);
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ret =3D
> > > > > > > > > > remove_device_exclusive_entry(vmf);
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if
> > > > > > > > > > (softleaf_is_device_private(entry))
> > > > > > > > > > {
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 struct dev_pagemap *pgmap;
> > > > > > > > > > +
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (vmf->flags &
> > > > > > > > > > FAULT_FLAG_VMA_LOCK)
> > > > > > > > > > {
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * mig=
rate_to_ram
> > > > > > > > > > is
> > > > > > > > > > not
> > > > > > > > > > yet
> > > > > > > > > > ready to operate
> > > > > > > > > > @@ -4670,21 +4672,15 @@ vm_fault_t
> > > > > > > > > > do_swap_page(struct
> > > > > > > > > > vm_fault
> > > > > > > > > > *vmf)
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0
> > > > > > > > > > =C2=A0
> > > > > > > > > > vmf-
> > > > > > > > > > > orig_pte)))
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto unlock=
;
> > > > > > > > > >=20
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /*
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 * Get a page reference
> > > > > > > > > > while
> > > > > > > > > > we
> > > > > > > > > > know
> > > > > > > > > > the page can't be
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 * freed.
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 */
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (trylock_page(vmf-
> > > > > > > > > > >page)) {
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct dev_pagemap
> > > > > > > > > > *pgmap;
> > > > > > > > > > -
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 get_page(vmf-
> > > > > > > > > > >page);
> > > > > > >=20
> > > > > > > At this point we:
> > > > > > > 1. Know the page needs to migrate
> > > > > > > 2. Have the page locked
> > > > > > > 3. Have a reference on the page
> > > > > > > 4. Have the PTL locked
> > > > > > >=20
> > > > > > > Or in other words we have everything we need to install a
> > > > > > > migration
> > > > > > > entry,
> > > > > > > so why not just do that? This thread would then proceed
> > > > > > > into
> > > > > > > migrate_to_ram()
> > > > > > > having already done migrate_vma_collect_pmd() for the
> > > > > > > faulting
> > > > > > > page
> > > > > > > and any
> > > > > > > other threads would just sleep in the wait on migration
> > > > > > > entry
> > > > > > > path
> > > > > > > until the
> > > > > > > migration is complete, avoiding the livelock problem the
> > > > > > > trylock
> > > > > > > was
> > > > > > > introduced
> > > > > > > for in 1afaeb8293c9a.
> > > > > > >=20
> > > > > > > =C2=A0- Alistair
> > > > > > >=20
> > > > > > > > >=20
> > > > > >=20
> > > > > > There will always be a small time between when the page is
> > > > > > locked
> > > > > > and
> > > > > > when we can install a migration entry. If the page only has
> > > > > > a
> > > > > > single
> > > > > > mapcount, then the PTL lock is held during this time so the
> > > > > > issue
> > > > > > does
> > > > > > not occur. But for multiple map-counts we need to release
> > > > > > the
> > > > > > PTL
> > > > > > lock
> > > > > > in migration to run try_to_migrate(), and before that, the
> > > > > > migrate
> > > > > > code
> > > > > > is running lru_add_drain_all() and gets stuck.
> > > > >=20
> > > > > Oh right, my solution would be fine for the single mapping
> > > > > case
> > > > > but I
> > > > > hadn't
> > > > > fully thought through the implications of other threads
> > > > > accessing
> > > > > this for
> > > > > multiple map-counts. Agree it doesn't solve anything there
> > > > > (the
> > > > > rest
> > > > > of the
> > > > > threads would still spin on the trylock).
> > > > >=20
> > > > > Still we could use a similar solution for waiting on device-
> > > > > private
> > > > > entries as
> > > > > we do for migration entries. Instead of spinning on the
> > > > > trylock
> > > > > (ie.
> > > > > PG_locked)
> > > > > we could just wait on it to become unlocked if it's already
> > > > > locked.
> > > > > Would
> > > > > something like the below completely untested code work?
> > > > > (obviously
> > > > > this is a bit
> > > > > of hack, to do it properly you'd want to do more than just
> > > > > remove
> > > > > the
> > > > > check from
> > > > > migration_entry_wait)
> > > >=20
> > > > Well I guess there could be failed migration where something is
> > > > aborting the migration even after a page is locked. Also we
> > > > must
> > > > unlock
> > > > the PTL lock before waiting otherwise we could deadlock.
> > >=20
> > > Yes, this is exactly what the migration entry wait code does. And
> > > if
> > > there's a
> > > failed migration, no problem, you just retry. That's not a
> > > deadlock
> > > unless the
> > > migration never succeeds and then your stuffed anyway.
> > >=20
> > > > I believe a robust solution would be to take a folio reference
> > > > and
> > > > do a
> > > > sleeping lock like John's example. Then to assert that a folio
> > > > pin-
> > > > count, not ref-count is required to pin a device-private folio.
> > > > That
> > > > would eliminate the problem of the refcount held while locking
> > > > blocking
> > > > migration. It looks like that's fully consistent with=20
> > >=20
> > > Waiting on a migration entry like in my example below is exactly
> > > the
> > > same as
> > > sleeping on the page lock other than it just waits for the page
> > > to be
> > > unlocked
> > > rather than trying to lock it.
> > >=20
> > > Internally migration_entry_wait_on_locked() is just an open-coded
> > > version
> > > of folio_lock() which deals with dropping the PTL and that works
> > > without a page
> > > refcount.
> > >=20
> > > So I don't understand how this solution isn't robust? It requires
> > > no
> > > funniness
> > > with refcounts and works practically the same as a sleeping lock.
> >=20
> > You're right. I didn't look closely enough into what the
> > migration_entry_wait_on_locked() did. Sorry about that.
>=20
> No worries. I'm somewhat familiar with it from updating it
> specifically so it
> wouldn't take a page reference as we used to have similar live-
> lock/starvation
> issues in that path too.
>=20
> > That would indeed fix the problem as well. Then the only argument
> > remaining for the get-a-reference-and-lock solution would be it's
> > not
> > starvation prone in the same way. But that's definitely a problem I
> > think we could live with for now.
>=20
> I don't follow how this solution would be any more starvation prone
> than getting
> a reference and locking - here the winning fault takes the lock and
> any other
> faulting threads would just wait until it was released before
> returning from
> the fault handler assuming it had been handled. But it's been a while
> since I've
> thought about all the scenarios here so maybe I missed one.

My thinking is that it would be if theoretical racing lock-holders
don't migrate to system, we can't *guarantee* migration will ever
happen. Although admittedly this is very unlikely to happen. If we
instead locked the page we'd on the other hand need to walk the page
table again to check whether the pte content was still valid....


>=20
> > I'll give this code a test. BTW that removal of unlock_page() isn't
> > intentional, right?=20
>=20
> Thanks. And you're right, that was unintentional. Serves me for
> responding too
> late at night :-)

So I ended up with this:




diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..84b6019eac6d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				unlock_page(vmf->page);
 				put_page(vmf->page);
 			} else {
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
+				pte_unmap(vmf->pte);
+			  	migration_entry_wait_on_locked(entry,
vmf->ptl);
 			}
 		} else if (softleaf_is_hwpoison(entry)) {
 			ret =3D VM_FAULT_HWPOISON;
--=20
2.52.0


Seems to be a working fix.

/Thomas


>=20
> =C2=A0- Alistair
>=20
> > Thanks,
> > Thomas
> >=20
> >=20
> > >=20
> > > =C2=A0- Alistair
> > >=20
> > > > https://docs.kernel.org/core-api/pin_user_pages.html
> > > >=20
> > > > Then as general improvements we should fully unmap pages before
> > > > calling
> > > > lru_add_drain_all() as MBrost suggest and finally, to be more
> > > > nice
> > > > to
> > > > the system in the common cases, add a cond_resched() to
> > > > hmm_range_fault().
> > > >=20
> > > > Thanks,
> > > > Thomas
> > > >=20
> > > >=20
> > > >=20
> > > > >=20
> > > > > ---
> > > > >=20
> > > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > > index 2a55edc48a65..3e5e205ee279 100644
> > > > > --- a/mm/memory.c
> > > > > +++ b/mm/memory.c
> > > > > @@ -4678,10 +4678,10 @@ vm_fault_t do_swap_page(struct
> > > > > vm_fault
> > > > > *vmf)
> > > > > =C2=A0				pte_unmap_unlock(vmf->pte,
> > > > > vmf-
> > > > > > ptl);
> > > > > =C2=A0				pgmap =3D page_pgmap(vmf-
> > > > > >page);
> > > > > =C2=A0				ret =3D pgmap->ops-
> > > > > > migrate_to_ram(vmf);
> > > > > -				unlock_page(vmf->page);
> > > > > =C2=A0				put_page(vmf->page);
> > > > > =C2=A0			} else {
> > > > > -				pte_unmap_unlock(vmf->pte,
> > > > > vmf-
> > > > > > ptl);
> > > > > +				migration_entry_wait(vma-
> > > > > >vm_mm,
> > > > > vmf->pmd,
> > > > > +						=C2=A0=C2=A0=C2=A0=C2=A0 vmf-
> > > > > > address);
> > > > > =C2=A0			}
> > > > > =C2=A0		} else if (softleaf_is_hwpoison(entry)) {
> > > > > =C2=A0			ret =3D VM_FAULT_HWPOISON;
> > > > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > > > index 5169f9717f60..b676daf0f4e8 100644
> > > > > --- a/mm/migrate.c
> > > > > +++ b/mm/migrate.c
> > > > > @@ -496,8 +496,6 @@ void migration_entry_wait(struct
> > > > > mm_struct
> > > > > *mm,
> > > > > pmd_t *pmd,
> > > > > =C2=A0		goto out;
> > > > > =C2=A0
> > > > > =C2=A0	entry =3D softleaf_from_pte(pte);
> > > > > -	if (!softleaf_is_migration(entry))
> > > > > -		goto out;
> > > > > =C2=A0
> > > > > =C2=A0	migration_entry_wait_on_locked(entry, ptl);
> > > > > =C2=A0	return;

