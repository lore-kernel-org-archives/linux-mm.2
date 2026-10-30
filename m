Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6407A60A261A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IJq8a19B
Received: by kanga.kvack.org (Postfix)
	id 451EF6B00EF; Fri, 30 Oct 2026 12:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD356B05B1; Fri, 30 Oct 2026 12:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5286B05B2; Fri, 30 Oct 2026 12:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3BAB6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:55:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8052116079A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:55:31 +0000 (UTC)
X-FDA: 85379893662.15.23E4250
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf23.hostedemail.com (Postfix) with ESMTP id BDBD7140002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:55:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IJq8a19B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793379329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgnmbS0qtZzofNOhBfAuY9e9ZGW0X9MHEKQwmV+gFd4=;
	b=rCbGkN7oeNiaKnBE2rDgM6LWiBVvRiiJhppysTvwcD/q11bxj+r0FxQ/tITLBHeaxH4Z1c
	/uq5ZZdbo5Q93ndRkUSy5Pr+eokmreeAsR+GULipzpi3RWdyGH/Pu+4S2KvfTdzyqsI8e5
	tR/mp0INj0PRCB38nxAC3Z0ZKd6I+20=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IJq8a19B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793379329;
	b=7J6iWSVanB1NaJMYKMNxWHqXSzaCtyyOdhwmJQmcUJe125GP/otGrGCiuAAsGKEVB2iL2D
	BLxnYbYaHxpy2ejqlcWXEJMB72WDWnbfMCMjd76IiK0G683n9ImxLXH+I752s7XIv3Ns5j
	s8qsrSy5ouGtOjQA6e/Q9KvRXzJDze4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793379329; x=1824915329;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SfRf/e5D4fJBitFkWiH24F7RsXJMv4g9Vd/EK7VDuik=;
  b=IJq8a19BnnHbJ4doMozr3nbAg0y5Gau7yXjxJD7IdUDdYnHNPVFIweNi
   iWvGZEmr8RsWtOKIMSfkGp+U2VwTbHZT6X60msIeR7fWO1LreDOysmbdt
   BgPqoIhC8uPWqYkyQHRHb4Tqyos2KgVF2Z2FKzhiT0NJjFkR16kyKB8Th
   +cnIkvJ/oRQWUlem0g0u3eTMNUI68sCOoSbop9jQuus+ehQe7ZJzJ6lXf
   mjDeq8m4E01PgYr13PKG2tSKnOkO1yHhgR+f8BjjQaxZv0zR5l3MdXSIm
   pqckvPHAdO5onSzEyoyFYKRJl0J/uDP2eo4eplEuf7ya8FYWQkBzLl0QJ
   g==;
X-CSE-ConnectionGUID: Wlh/rmxgR8aTkFyYGBPKRg==
X-CSE-MsgGUID: vi4xa7y1SyieDFyNoUTIQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2241150"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2241150"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 09:55:27 -0700
X-CSE-ConnectionGUID: rhDb9+csTMmsZXY9RNR4aA==
X-CSE-MsgGUID: CmQR+n7gRuSQVAfNnNQelw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5487915"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.109.99]) ([10.125.109.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 09:55:27 -0700
Message-ID: <7efb942eb0f4fb81528e1a97e7f73996a95988ee.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hugetlb_vmemmap: Fix usemap overrun on nodes with
 multiple ranges
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador	
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Frank van der
 Linden	 <fvdl@google.com>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, 	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Mohini Narkhede	 <mohini.narkhede@intel.com>, Pooja Jain
 <pooja.jain@intel.com>, Doug Nelson	 <doug.nelson@intel.com>
Date: Fri, 30 Oct 2026 09:55:26 -0700
In-Reply-To: <0611C182-4A76-4751-A04B-0849EC31DAD3@linux.dev>
References: <20261029212137.3141875-1-tim.c.chen@linux.intel.com>
	 <0611C182-4A76-4751-A04B-0849EC31DAD3@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDBD7140002
X-Stat-Signature: srnb856bn354jykws6o6zb8yrqhkz77j
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793379328-323277
X-HE-Meta: U2FsdGVkX1+hxnd8u3eStayu8FxriNdF7tpLnfOnJtCVVtLiz/dIr9bPqE2DqXGCNGbgenhG7xhOjgtu0GPPXyvl1t5/Icm6/2vIgW1snS0w2+3qpk4af2KhVNSt9Jd18aB4iqNpaANODTfzyRCJejyPglA+3BNv0ZSSHWiEjT3S3sE7sBsH3hzaaIqCbjWdMLdnZsn+/PK0ohfPebhfh7T4x2P9qVglHNwiW60LnZFyC8cTA2KUAqPRiee2QtOZaINtOlzC3RJe9u93vrvQ7xsxbJijzA9bU6RzhLZP6VKY7+qdZkVYMtCGLE45UWP3Fl6l3K1kcy3fGD/lkF7MRuYlh1XoWGajTkQVbBpFlE6lKes2onVBFl/3oYybdxeA1XR/aGUhzXzgrW8x/NlEhwumM1fhV+KMw/EJeAc/sULhtunFpdfhtUSXUcBU86ohKnO5wN/ofa34zMc4nfoRCEuOGE2L9S7G9/VMlAhHVzZrnajd6tj+CG7NS3cxKveLm0aI7HHqnRRrvNSdCDn6PAEBT39ZeGYnYfmEy8N3gio6p0z5Z7kdGPa1AcI0kWnYlKFjL3cqwQl4q1r6f0hwCOnlKfnk+YL/vEsS7/m2C/IYm21o7v8MISZumPlVPt9JrHuPvuCRqMM5lxRBoWM8LclowjraPUl0P3z5LXKeGMqyLj9jOs/mPqcc+H/td54dvUC01lAl1fvRj/UNKRng+dfLBJo/ukeBZ/s5VufwYfZspvPnzGHl9FJ7vHMgDyc1Y86Wx5i4kMjgqAXTQVgue/G2kybdQJ2GbbtrbAb0KlZHS7xwQ2sPmSBS2/RTajBz/6hktAYo2ikJ3VhvgQVDnXl4/xNHTNGwUXTlQniwQmLsl0rmfrOw7NEmQLMnREkpj3J5bfSK/MRmXNEqj1xVgCWLg+wPFQS6KtSvsD6GOJ0kS02RRTLkUKGa347alF+T1J7wMbvUN/P9qpssl+/
 +RjeFism
 MCg3tloc85irmOXXPC+5gNrUbRQqh7Yf2Hv/iRZdJKb9+tf3hNV/q7BplFaRvdVIcgmG439kHzVsAbOzESjQe4e2p60kE7W4DZeyv1LNq0W8ESmt57x/55Ln74yMJNmCU3BVhpliK2c5SxYArWzk5/LzKnQwhjKPZvilkLsgpQTFfG4I1bN1OfzzjkotC+0/Vw7t/zCqJ+LDmLe3whsLuIIxEDNKHLYSsORAv1jHe9qdYqJftK/j9M/zLiGy//CH1Gcg1ALr7PLHrSRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-10-30 at 13:32 +0800, Muchun Song wrote:
>=20
> > On Oct 30, 2026, at 05:21, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> >=20
> > sparse_init_nid() allocates one usemap slot (struct mem_section_usage)
> > per present section in [pnum_begin, pnum_end), and
> > sparse_init_early_section() hands them out in order, with a BUG_ON() wh=
en
> > they run out. hugetlb_vmemmap_init_early(nid) however initializes the
> > sections of every bootmem gigantic page on the node, including pages
> > outside the range being initialized. If a node's memory is split into
> > more than one range, sparse_init() calls sparse_init_nid() once per ran=
ge,
> > and this takes more slots than were allocated. The same happens if a
> > gigantic page straddles a node boundary.
> >=20
> > For example, with this SRAT layout every node has a small range below 4=
G
> > and a large range above 4G:
> >=20
> >  Node 0 PXM 0 [mem 0x00000000-0x2fffffff]          768 MB  (low)
> >  Node 0 PXM 0 [mem 0x100000000-0x80cfffffff]               (high)
> >  Node 1 PXM 1 [mem 0x30000000-0x5fffffff]          768 MB  (low)
> >  ...
> >=20
> > In 128 MB memory sections (x86_64 SECTION_SIZE_BITS =3D 27), node 0's l=
ow
> > range is sections 0x00-0x05 (6 present sections) and its high range is
> > sections 0x20-0x1019. The low ranges of the other nodes are 4 or 6
> > sections, all smaller than the 8 sections of a 1G page.
> >=20
> > Node 0's first range has 6 sections, so 6 slots. With "hugepagesz=3D1G
> > hugepages=3D400", hugetlb_vmemmap_init_early(0) then initializes node 0=
's
> > 1G page at 0x67c0000000 (sections 0xcf8-0xcff, in its high range), and
> > the 7th section hits the BUG_ON() (seen on v7.2.6):
> >=20
> >  kernel BUG at mm/sparse.c:268!
> >  RIP: 0010:sparse_init_early_section+0x9f/0xb0
> >  RAX: 0000000000200000 RBX: 0000000000000cfe RCX: 0000000000000020
> >  RDX: 0000000000000cfe RSI: ffd7e1d09fc00000 RDI: ff252cb28ffb3f50
> >  R10: ff252cb28ffb3d40 R13: 0000000000000d00
> >  Call Trace:
> >   hugetlb_vmemmap_init_early+0xe1/0x140
> >   sparse_init_nid+0x56/0x370
> >   sparse_init+0x192/0x2b0
> >   free_area_init+0x7f/0x690
> >   start_kernel+0x64/0x540
> >=20
> > Here RDX is the section number, and R10/RDI are 6 slots apart: the star=
t
> > of the usemap buffer and its current position, which is the end.
>=20
> A detailed analysis.
>=20
> >=20
> > Pass the section range to hugetlb_vmemmap_init_early() and only pre-HVO=
 a
> > page whose sections are all present and within it. Ranges are disjoint,
> > so each page is handled once, in its own range.
> >=20
> > Skipped pages are not marked HUGE_BOOTMEM_HVO. Their sections get a
> > regular memmap from sparse_init_nid(), and the pages are optimized late=
r
> > by hugetlb_vmemmap_optimize_bootmem_folios().
>=20
> Thanks for fixing this.
>=20
> However, the master branch has already switched to section-based vmemmap
> optimization, it has been already fixed. So this fix should target the
> stable kernels (6.18, 7.2 and 7.3).
>=20
> The change LGTM. So:
>=20
> Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks for the review.  Indeed the master tree has the section rework,
so this bug is fixed for current master.  It just needs to be
applied to stable 6.18, 7.2 and 7.3.

Tim

>=20
> Thanks.

