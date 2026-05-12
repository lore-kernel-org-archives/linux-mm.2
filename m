Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70A13CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979AB6B0088; Tue, 12 May 2026 07:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A666B008A; Tue, 12 May 2026 07:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FD46B008C; Tue, 12 May 2026 07:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74B336B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:31:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2456E8CD02
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:31:23 +0000 (UTC)
X-FDA: 84758552046.27.3BCBE5E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E435100011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:31:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Hnqofbwv;
	spf=pass (imf05.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778585481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvH/QiLaIgjeY03YGXTUG/+CnGQktzhb1zHqgcRyBLQ=;
	b=NwMXGZKwee6iV3jzZm5bm1gyDYK+HlIS5/Uga4UOmmwkO8v3lsMopNcJUIhq5B1eiYRhLe
	MXfBsS/S3KKlztowpkaanF5YpbZMixvU6Pvw4JjfJTMXX6sa78BKMTjPwEvr5UPuqdIeLD
	XiJ1Uzi3K38WRVGBbxXOmE74rRZAr7E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Hnqofbwv;
	spf=pass (imf05.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778585481; a=rsa-sha256;
	cv=none;
	b=ENl8o/g2T3TdW0CVFh9CZwiX3lSFdI2nGSLHSqBHnRcSfd4QU+ippypUhRUNDG5ku2sukb
	JeZM8DJlEuCz1gY0Z39MJZ51RosEKeU4bwek5IAoWFLbxMQFidLP54qkUVOw7EQ06NnZ+x
	qjYc/nskEg51feb3HctKXop1RJjJWSU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778585481; x=1810121481;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=V6Uv9TsQGyM3BpUljm+Hu+p0og4dIdrPBdVttzvu94U=;
  b=HnqofbwvE0xHCXFa8HTWBilcP/S37RgQedIFdmmFK3cbYqufta2jmqLT
   12QH29kT1PC05X6pqggkdOZRMkupoGT1gKrZR2DDTeOrvlDdaFjft/X1s
   brf1zUKQOoUFuYZSInEqY8oI9YJeOv0cekPAF9ju0WSvCJ/i9uDAE5q6D
   ActQRmY07EnUJpEVJyk/skPfgDMd0vuL4Q5uY+Ymxc2F4Ye0pi4yU44+a
   3mSyN4EOzRtdXSwXFUrJYPzPelDcTlJfZXPf/I80A5Xk7wS5RxfcK6RF+
   o+MBIqh7UEsG9L71icG25q2i4qgUB5cTWGkGw1lTYrut8ziVj4cT6aV61
   w==;
X-CSE-ConnectionGUID: z0+Kz2LIQRClFEfjlMgJAw==
X-CSE-MsgGUID: PEe13uTLTCSrRSUxQguZ2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="83106067"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="83106067"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 04:31:18 -0700
X-CSE-ConnectionGUID: QPACu6dxSXW/7GV7ONnHHQ==
X-CSE-MsgGUID: 1AekJlt5QxutbES8KnsWgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="236760144"
Received: from vpanait-mobl.ger.corp.intel.com (HELO [10.245.245.172]) ([10.245.245.172])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 04:31:13 -0700
Message-ID: <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
 <ljs@kernel.org>,  "Liam R. Howlett"	 <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang	 <baolin.wang@linux.alibaba.com>, Brendan
 Jackman <jackmanb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>, Zi
 Yan <ziy@nvidia.com>, Christian Koenig <christian.koenig@amd.com>,  Huang
 Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, Matthew
 Brost	 <matthew.brost@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>,  Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, 	linux-kernel@vger.kernel.org
Date: Tue, 12 May 2026 13:31:09 +0200
In-Reply-To: <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
	 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
	 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: 4drea33gdiig1mps7dwi16wkxsgzrp39
X-Rspamd-Queue-Id: 8E435100011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778585480-123450
X-HE-Meta: U2FsdGVkX1+0q+VEk1FeOBcJQIot1evzdsNjUbzgNcn2KaA7sqc60HivLT+gYKDeAT76a+U2sN81HVaHbnA7PUlfr9b0prZTUZ8dL/6gizpydyli5p8KAWvW74aWTBFZfeMPwHuXqnXunvg3N2F2Hw77UHXpQYfAFEx6XwzKyA/gMp1AB91dwjts0NW7J1JibtYuIANtRIinSQObMINU4RFF5dTqW20lrAtpHzvc7FPAzeVk+mr5H66vDOitgfTolEELX4C/0iHQtsElMqogspKKkzyhwYC6KfUnckz54KTPKmGzMhJ/mdbHQGOSYBL2kHqlnvV/lfIvyhRQf3dPxBDk9giWmCflG3qdAB4UBuTPzbZgMS9kfq8hq7Qf/aCRTFRBoGi42WYZz2hZ4HsAjdKmvgs5lJIHLdhK1kr+fgiCq2UEkKc/bQRaulROPAHhKtWw4fWiSSlSMX4Ou9Qogm/NIChZVEhPTd/ydO/FZmgDkStlfT0oXo5RLucd/jX1TeANuKifiDNcOXq4lZ3bN4y1wbQMwZT3n6ojO+dBNdbV51RUzKKDspdXrVPXyBf46MTt+GkaubfmxBsDg/KRkHYlqwl7QbY7m7qTMejgcrdal3veJlaVwQZZDS0xaEE4ugtcWK51eMoHplkNPnsWJN3IOFQJEh9Jn5E1ErErcGRDLkRdciY1B6xb6dbIBjrNk40vLbyywmWWhSVdkm9pCLXNzrPDo08WTF+woZZTjH7cVvAv9xmYhLVk9aTnxl1TIbjQDPHhX3w+LE+ujtvuobqQCC8L1eaMaeQEtoDzkzABql/ROYlCOrvXsxr+2gw8exlWvKilTodwYdDEQyAuUvY2O9x2BKggIS4NFHCagbLQ4b0x9ymLxf1M7pk9G0vvSQUleKLbfsfbg/1S9KJaK98lAtC3hVyHxkwbTf6p6csXT9f3oSq78qagFwAKfkXYEttNdgrs3P7c2Ktxwsf
 fehSa4rL
 xQ4o3FvSW0MVDAWb3+6R3K+BdwhPomARG2+9PGrbBKrRl7eHFVB6Vm8KdJj86hqpESQ3A4Ps8jwdZxNnkC4aZpLKTynQlVetTU4CUOPitWnVZCVi/sxrJUaMjcAe8OSZJyfHAal5qfh6XLQRCbZvFvwM9/MsBQHzmPF0IgUCP+ATq0yqRdcbUmzcmQ5FudtePHAAK089HFdPuHcYblMD/QXsXs0eAEo1CypBs6DVyayPez9m+Z09qksQ1rxe0lwmr6sIuBz8/1GOorCmpNE2PU7G+MfNX+UjU7/rOJIYvU3BjFawSGX4J3OMQBjYKobHpKVSWfZHoRK0R2kyMDehN7f1I2NVMugcD4ynXjIary0nhIAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thanks for having a look.

On Tue, 2026-05-12 at 13:07 +0200, David Hildenbrand (Arm) wrote:
>=20
> > =C2=A0
> > +/**
> > + * undo_compound_page() - Reverse the effect of
> > prep_compound_page().
> > + * @page: The head page of a compound page to demote.
> > + *
> > + * Returns the pages to non-compound state as if
> > prep_compound_page()
> > + * had never been called.=C2=A0 split_page() must NOT have been called
> > on
> > + * the compound page; tail refcounts must be 0.=C2=A0 The caller must
> > ensure
> > + * no other users hold references to the compound page.
> > + */
> > +void undo_compound_page(struct page *page)
> > +{
> > +	unsigned int i, nr =3D 1U << compound_order(page);
> > +
> > +	page[1].flags.f &=3D ~PAGE_FLAGS_SECOND;
> > +	for (i =3D 1; i < nr; i++) {
> > +		page[i].mapping =3D NULL;
> > +		clear_compound_head(&page[i]);
> > +	}
> > +	ClearPageHead(page);
> > +}
> > +
> > =C2=A0static inline void set_buddy_order(struct page *page, unsigned in=
t
> > order)
> > =C2=A0{
> > =C2=A0	set_page_private(page, order);
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 3b5dc21b323c..45e80a74f77c 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -937,6 +937,111 @@ int shmem_add_to_page_cache(struct folio
> > *folio,
> > =C2=A0	return 0;
> > =C2=A0}
> > =C2=A0
> > +/**
> > + * shmem_insert_folio() - Insert an isolated folio into a shmem
> > file.
> > + * @file: The shmem file created with shmem_file_setup().
> > + * @folio: The folio to insert. Must be isolated (not on LRU),
> > unlocked,
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 have exactly one re=
ference (the caller's), have no
> > page-table
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mappings, and have =
folio->mapping =3D=3D NULL.
> > + * @order: The allocation order of @folio.=C2=A0 If @order > 0 and
> > @folio is
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 not already a large=
 (compound) folio, it will be
> > promoted to a
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 compound folio of t=
his order inside this function.=C2=A0
> > This requires
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 the standard post-a=
lloc state: head refcount =3D=3D 1, tail
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 refcounts =3D=3D 0 =
(i.e. split_page() must NOT have been
> > called).
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 On failure the prom=
otion is reversed and the folio is
> > returned
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to its original non=
-compound state.
> > + * @index: Page-cache index at which to insert. Must be aligned to
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1 << @order) and w=
ithin the file's size.
> > + * @writeback: If true, attempt immediate writeback to swap after
> > insertion.
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 Best-effort; failure is silently ignored.
> > + * @folio_gfp: The GFP flags to use for memory-cgroup charging.
> > + *
> > + * The folio is inserted zero-copy into the shmem page cache and
> > placed on
> > + * the anon LRU, where it participates in normal kernel reclaim
> > (written to
> > + * swap under memory pressure).=C2=A0 Any previous content at @index i=
s
> > discarded.
> > + * On success the caller should release their reference with
> > folio_put() and
> > + * track the (@file, @index) pair for later recovery via
> > shmem_read_folio()
> > + * and release via shmem_truncate_range().
> > + *
> > + * Return: 0 on success.=C2=A0 On failure the folio is returned to its
> > original
> > + * state and the caller retains ownership.
> > + */
> > +int shmem_insert_folio(struct file *file, struct folio *folio,
> > unsigned int order,
> > +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pgoff_t index, bool writeback, =
gfp_t
> > folio_gfp)
> > +{
> > +	struct address_space *mapping =3D file->f_mapping;
> > +	struct inode *inode =3D mapping->host;
> > +	bool promoted;
> > +	long nr_pages;
> > +	int ret;
> > +
> > +	promoted =3D order > 0 && !folio_test_large(folio);
> > +	if (promoted)
> > +		prep_compound_page(&folio->page, order);
> > +	nr_pages =3D folio_nr_pages(folio);
> > +
> > +	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
> > +	VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
> > +	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> > +	VM_BUG_ON_FOLIO(folio->mapping, folio);
> > +	VM_BUG_ON(index !=3D round_down(index, nr_pages));
>=20
> No new VM_BUG_ON_FOLIO etc.

OK, can eliminate those. Is VM_WARN_ON_FOLIO() preferred,
or any other type of assert?

>=20
> But in general, pushing in random allocated pages into shmem,
> converting them to
> folios is not something I particularly enjoy seeing.
>=20

OK, let me understand the concern. The pages are allocated as multi-
page folios using alloc_pages(gfp, order), but typically not promoted
to compound pages, until inserted here. Is it that promotion that is of
concern or inserting pages of unknown origin into shmem? Anything we
can do to alleviate that concern?

Given the problem statement in the cover-letter, would there be a
better direction to take here? We could, for example, bypass shmem and
insert the folios directly into the swap-cache, (although there is an
issue with the swap-cache when the number of swap_entries are close to
being depleted).

https://patchwork.freedesktop.org/series/165518/

Thanks,
Thomas



