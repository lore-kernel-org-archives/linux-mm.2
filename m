Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1D1CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BAF36B0005; Wed, 13 May 2026 04:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C266B0092; Wed, 13 May 2026 04:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A3E6B0093; Wed, 13 May 2026 04:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1396E6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:32:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D541FA05DA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:32:00 +0000 (UTC)
X-FDA: 84761728800.29.D40B2CA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id E1A5F2000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:31:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M49MIAtH;
	spf=pass (imf13.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZJkT/g0zb6Dz/LDdBa4OW6hLocvpFV+/yTxfZlXiEM=;
	b=BRzGm4rlDld1B8QQere5ABmB10ULvwFFOPthISaUHpXV/31Ofy+HWadtyk/XBSkp4L9gqg
	MnSGQxY7cTs9V8V9p7kstkpDc24DWvQ9l5Bu+FltT0fNCxKtvdEuA9ngUQhTZhK8aGBofK
	OZaFiOiGG60vVl2wnBeNE7oNdNSL45w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M49MIAtH;
	spf=pass (imf13.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661118; a=rsa-sha256;
	cv=none;
	b=y/uGJ/mEbs2jujEyoJ/Xfcti4wjP8odph7w94sFL0blV0sWzV0tO2O50SDNu5nbHFzh8Om
	pm4z2uPX797sBzh0ff8kktccgkiuHZuNPpIwJnn1QXBz79QM8MD2X0XDqy9ZClNgWr4DEI
	NAsc1d5/b9m4X+OAh9Lyc2dp/cByNgs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778661118; x=1810197118;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=w3N7ovtfdrXvSPC3SyFkABxeYzl70HsVKnN1MgRa4Is=;
  b=M49MIAtHkn1zfb4Q45EVDjIb/Dry0Xn3fTHMRscs7m/adbqpwoxIeNQk
   KPOJH3aH0Nqzt7vzJKFxwGEFGyf6xoBMjSVAo9kaBKeQVqtEvRb7O40dV
   DfU68nFiX/ExRNBs6QhHw8BUUBzZNqBBBeVRMo+ctRByGBcnvWwRWUy4b
   ZPlMDKJm/dHUASmuesjpr5aTLy1/+0FdlOWpNBEx1droEN1o8O1NJ89cY
   +yQtJJGjTAJoBGtNA7Xe+qaX99MC91cla5jW/IW3dvS4XGhx6PAv1/GQt
   Fq98NfCcfVjWty20bMsONZU7auiulN6KT5XpwOkpCOcSJpMWbhxO9Mn8e
   w==;
X-CSE-ConnectionGUID: pan1GDZXSzaL3iUeinDU5Q==
X-CSE-MsgGUID: Pnn6CmSUSOyS70DHIlIRgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="79477234"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="79477234"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 01:31:56 -0700
X-CSE-ConnectionGUID: wn1YwuwwQrqVza82LHbydQ==
X-CSE-MsgGUID: noPPLi1GSd63I02KpUCjFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="261764851"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO [10.245.244.49]) ([10.245.244.49])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 01:31:50 -0700
Message-ID: <68705cec43ab43088327b21c9d9318036fb2a255.camel@linux.intel.com>
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, "David
 Hildenbrand (Arm)"
	 <david@kernel.org>, intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
 <ljs@kernel.org>,  "Liam R. Howlett"	 <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang	 <baolin.wang@linux.alibaba.com>, Brendan
 Jackman <jackmanb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>, Zi
 Yan <ziy@nvidia.com>, Huang Rui <ray.huang@amd.com>, Matthew Auld	
 <matthew.auld@intel.com>, Matthew Brost <matthew.brost@intel.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann	 <tzimmermann@suse.de>, David
 Airlie <airlied@gmail.com>, Simona Vetter	 <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Date: Wed, 13 May 2026 10:31:47 +0200
In-Reply-To: <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
	 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
	 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
	 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
	 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
	 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: gmour17heaye9d9x8i9pgcc148o4ho7m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1A5F2000F
X-Rspam-User: 
X-HE-Tag: 1778661117-819072
X-HE-Meta: U2FsdGVkX18/iWDnDyBiFgdLBKRU0WfTEAQ+IiZMD2CKYQoT2kNLi/G9WCKUeduqAIb6Zf2wt2SH2pg8JPon1Y4scF3Eiu3RlEJAzbO3BS4zL0F1az7ekixRS22+JCtGPuuM8FprePK42g6ZlLMET8ZbTcIPlTAmLOskSYSnH4zUHKmNsTgcU0jAxuLPQJcwQBZXrmFsMFOLwX15s2VLUWbXnwaMrfb+pCy35OE+IRAKUotNqocPf9ryT1UQ2pKu8zbcHYgdECV1sWv3CNN4cJYSA2ZzpY8XEleDdllxGldiJpFow2f4Fsd895EDzj+mspOW3rCCjuCVVovTOphLJLbZFwlEVatPK2mEEzxL0Gu1G7/X79gUeCRNUhKim7VGZ0HEFGZnuSvn5W8ELeNyuu3YnPk893XiQxd26Y+hp0GoA6zY4HTUJ5OJDewqXY3HQ0d2eNZOdsJTdptKvf1KDH01/89EQ+NYgTS6QNcRaCDHoB7cibIZmMGLNnEegDhBMtDfjQioH5YTgBvTZpH1i73YbyicA7lBT4clv6MGj0kblLUJiTK1XUu1WGOIuYIhiGPtxgl5jIz2Ox/3xcqjbhQ59BqX89HnS901J1DbsQrMpwICxDp1pBnuUL6IfxPob3q/Ps7V+JSi0Xe3MFKXgvUI+u2O/aO35gTrMZJwwZmzDn1tcEAuP2bmIJfCtsgCxBCXdHSxs6O/hnFuYqYJ8psVSZA8HU9RYr+OcEHpPx0bsNMezP3izOp6xlVAWZckR/WmaoZYUpKrsWW278OgdLWqzfGSb5jEchW05NtjJ+R/aH0NBMHW+ZSSq3clMUKxA/Pv7DCrEsDTKDF3Ne0r9AgnNSoKg3TDd62/+kFr+Zjkgf7E99EHOX0ZFaSIuPmjQk9BiIMKP/dc3wDFT/dbb5NL35ul9o72bqbq7HCZpH4nFoIDfaw/RQliCU0WFFiCmu7GnuJx7gpxFAhyqa8
 dNM8WkTk
 AswQr2vdj/GatOEIWpdVWx7xPbJQr2t9DsQZY2xWtpeWmaFRk2yHa2gqeUPNx5+ORRZvhzZSwrdImAXqiJy8CpMb8JQPCQXp9N1rWwLMR8mZ2A480ZHGH3emhZKcOO5pLngpbQMxQ6H128ciJRHCrvOHGOJKewpGKqsQO1J7aIMZ1NCw4M8fsEdA4VLjz9u0lR5v4wZFYcx6hfcBwl9ETEN13z3GGIt/AnFLifW2vab4Gyzrya3nsN3h6hI9v/gwTS1Uvb2+wdXVJE9KsCWSPfysdo3XjZZXtVYdRa8mklEtTEMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David & Christian,

Thanks for the feedback. I'll respin this to see if I can come up with
something that is more acceptable given the comments.

A couple of questions and comments below.

On Wed, 2026-05-13 at 09:47 +0200, Christian K=C3=B6nig wrote:
> Hi David & Thomas,
>=20
> On 5/12/26 22:03, David Hildenbrand (Arm) wrote:
> > On 5/12/26 13:31, Thomas Hellstr=C3=B6m wrote:
> ...
> > > > > +int shmem_insert_folio(struct file *file, struct folio
> > > > > *folio,
> > > > > unsigned int order,
> > > > > +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pgoff_t index, bool write=
back, gfp_t
> > > > > folio_gfp)
> > > > > +{
> > > > > +	struct address_space *mapping =3D file->f_mapping;
> > > > > +	struct inode *inode =3D mapping->host;
> > > > > +	bool promoted;
> > > > > +	long nr_pages;
> > > > > +	int ret;
> > > > > +
> > > > > +	promoted =3D order > 0 && !folio_test_large(folio);
> > > > > +	if (promoted)
> > > > > +		prep_compound_page(&folio->page, order);
> > > > > +	nr_pages =3D folio_nr_pages(folio);
> > > > > +
> > > > > +	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
> > > > > +	VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
> > > > > +	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> > > > > +	VM_BUG_ON_FOLIO(folio->mapping, folio);
> > > > > +	VM_BUG_ON(index !=3D round_down(index, nr_pages));
> > > >=20
> > > > No new VM_BUG_ON_FOLIO etc.
> > >=20
> > > OK, can eliminate those. Is VM_WARN_ON_FOLIO() preferred,
> > > or any other type of assert?
> >=20
> > VM_WARN_ON_FOLIO() is usually what you want, or VM_WARN_ON_ONCE().
> >=20
> > >=20
> > > >=20
> > > > But in general, pushing in random allocated pages into shmem,
> > > > converting them to
> > > > folios is not something I particularly enjoy seeing.
> > > >=20
> > >=20
> > > OK, let me understand the concern. The pages are allocated as
> > > multi-
> > > page folios using alloc_pages(gfp, order), but typically not
> > > promoted
> > > to compound pages, until inserted here. Is it that promotion that
> > > is of
> > > concern or inserting pages of unknown origin into shmem? Anything
> > > we
> > > can do to alleviate that concern?
> >=20
> > It's all rather questionable.
> >=20
> > A couple of points:
> >=20
> > a) The pages are allocated to be unmovable, but adding them to
> > shmem effectively
> > =C2=A0=C2=A0 turns them movable. Now you interfere with the page alloca=
tor
> > logic of
> > =C2=A0=C2=A0 placing movable and unmovable pages a reasonable way into
> > =C2=A0=C2=A0 pageblocks that group allocations of similar types.
> >=20
> > b) A driver is not supposed to decide which folio size will be
> > allocated for
> > =C2=A0=C2=A0 shmem.
>=20
> Exactly that is one of the major reasons why we aren't using a shmem
> as backing store for TTM buffers in the first place.
>=20
> While HW today can usually work with everything down to 4k it needs
> higher order pages for optimal performance.
>=20
> So for example for AMD GPUs you need 2M pages or otherwise the
> performance goes down by ~30% in quite a number of use cases.
>=20
> Everything between 4k and 2M and above 2M is still preferred because
> it results in better L0/L1 reach, but if you can't get 2M the L2
> reach goes down so rapidly that people start to complain immediately.
>=20
> And that stuff is very specific for each vendor and HW generation.
> Some have the sweet spot at 64k, some at 256k, most at 2M.
>=20
> > =C2=A0=C2=A0 I am not even sure if there is a fencing on
> > =C2=A0=C2=A0 CONFIG_TRANSPARENT_HUGEPAGE somewhere when ending up with =
large
> > folios. order
> > =C2=A0=C2=A0 > PMD_ORDER is currently essentially unsupported, and I su=
spect
> > your code
> > =C2=A0=C2=A0 would=C2=A0 even allow for that (looking at
> > ttm_pool_alloc_find_order).
> >=20
> > =C2=A0=C2=A0 We also have some problems with the pagecache not actually
> > supporting all
> > =C2=A0=C2=A0 MAX_PAGE_ORDER orders (see MAX_PAGECACHE_ORDER).
> >=20
> > =C2=A0=C2=A0 You are bypassing shmem logic to decide on that completely=
.
> >=20
> > =C2=A0=C2=A0 While these things might not actually cause harm for you t=
oday
> > (although I
> > =C2=A0=C2=A0 suspect some of them might in shmem swapout code), we don'=
t want
> > drivers to
> > =C2=A0=C2=A0 make our life harder by doing completely unexpected things=
.
>=20
> Yeah but that is the requirement the HW has.
>=20
> I mean we can keep torturing the buddy allocator to give us 2M pages,
> but essentially we want to get away from those specialized solutions
> and has more of the functionality necessary to driver the HW in the
> common Linux memory management code because that prevents vendors
> from re-implementing that stuff in their specific driver over and
> over again.

For the code at hand, if we insert an order 10 folio shmem will split
it at writeout time but spit out a warning (if enabled) at the same
time. For this particular use-case, I think it might make sense for the
drivers that use direct insertion to cap the page-allocator orders to
THP size (2M).

>=20
> Regards,
> Christian.
>=20
> > c) You pass folio + order, which is just the red flag that you are
> > doing
> > =C2=A0=C2=A0 something extremely dodgy.
> >=20
> > =C2=A0=C2=A0 You just cast something that is not a folio, and was not
> > allocated to be a
> > =C2=A0=C2=A0 folio to a folio through page_folio(page). That will stop
> > working completely
> > =C2=A0=C2=A0 in the future once we decouple struct page from struct fol=
io.
> >=20
> > =C2=A0=C2=A0 If it's not a folio with a proper set order, you should be
> > passing page +
> > =C2=A0=C2=A0 order.
> >=20
> > d) We are once more open-coding creation of a folio, by hand-
> > crafting it
> > =C2=A0=C2=A0 ourselves.
> >=20
> > =C2=A0=C2=A0 We have folio_alloc() and friends for a reason. Where we, =
for
> > example, do a
> > =C2=A0=C2=A0 page_rmappable_folio().
> >=20
> > =C2=A0=C2=A0 I am pretty sure that you are missing a call to
> > page_rmappable_folio(),
> > =C2=A0=C2=A0 resulting in the large folios not getting
> > folio_set_large_rmappable() set.
> >=20
> > e) undo_compound_page(). No words.
> >=20
> >=20
> >=20
> > *maybe* it would be a little less bad if you would just allocate a
> > compound page
> > in your driver and use page_rmappable_folio() in there.

OK, yes it sounds like a prereq for this is that the driver actually
allocates compound pages. It might be that the TTM comment about *not*
doing that is stale, but need to check.

Would it be acceptable to export a function from core mm to split an
isolated folio?

> >=20
> > That wouldn't change a) or b), though.
> >=20
> >=20
> > >=20
> > > Given the problem statement in the cover-letter, would there be a
> > > better direction to take here? We could, for example, bypass
> > > shmem and
> > > insert the folios directly into the swap-cache, (although there
> > > is an
> > > issue with the swap-cache when the number of swap_entries are
> > > close to
> > > being depleted).
> >=20
> > Good question.
> > We'd have to keep swapoff and all of that working. For example, in
> > try_to_unuse(), we special-case shmem_unuse() to handle non-
> > anonymous pages.
> >=20
> > But then, the whole swapcache operates on folios ... so I am not
> > sure if there
> > is a lot to be won by re-implementing what shmem already does?
> >=20

Still that would alleviate a) and b), right? At least as long as we
keep folio sizes within the swap cache limits?

Thanks,
Thomas


