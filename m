Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF69CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537066B0096; Wed, 13 May 2026 04:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E89B6B0098; Wed, 13 May 2026 04:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425DF6B0099; Wed, 13 May 2026 04:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 369206B0096
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:51:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE95A12079D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:51:36 +0000 (UTC)
X-FDA: 84761778192.02.91ACC94
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3AF5540004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:51:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dzDJWr6b;
	spf=pass (imf12.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gb6cdQvgIjVHP6q1cmpqeNRXvuWiP2WWdB4XYzroKVA=;
	b=mFpbmpbb5NDUlH1qqnI13AzNN0hZ5497lqJAX31kAglQ/xEDPa7pt/lv83gymYKstwCF3i
	Apf4caZq9TifMLl02j+boiwI47KH3hAJzAforaCkwfvR9ezgC372vDH0EM2y8W8GqLJaKX
	uhwxbq2J/yFR+73SChLGUghQd+/V9as=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dzDJWr6b;
	spf=pass (imf12.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778662294; a=rsa-sha256;
	cv=none;
	b=w45y5eCt6k1n0kGbeAnm5VQnVGSoHX1SpTRsdhZVKt3r5tzOxA6ed0jJqG4VDJmN9kc+rh
	Ph+E4hOLx1vZGjLoj+RG3MzlChKJEMZibGUvzvFJlrJWLPXeyh48VHvtuOT+2ynDp21ppe
	vtpUvNsSjfyfaWVrVG9IXz92jaQ3kCk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778662294; x=1810198294;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Gb6cdQvgIjVHP6q1cmpqeNRXvuWiP2WWdB4XYzroKVA=;
  b=dzDJWr6bdtuL8COpOmGh9perL1OmtTGVm65y0RmJJjxXdLRXgWP1M/w0
   MLV8GE7YC4R0sagWhMUmyRXq1ERHFs07+IU+2fIUnoUwbs4AWqp1p5c0I
   SFY1BCQ/25Oi3TpDAwXl6SUpbiN61uDhZbH89KFKj9FJNHweO7wYxJjM8
   9l7wyrnRpVizp+7wRkPJ/xNh3/yZieSYCr0ILxlIOR6OYi+RZCcCy9XL0
   y4zRUIYEj+kneyoO4eDZrSGVxKPTiahUrwCAgsd+ZPHEn+Bjxh+GoA5a8
   m6qV8iYVnjSOP6U5WugnkLBEYioCeseJRemsI0Mp6OS70vqvutxGJeKIS
   A==;
X-CSE-ConnectionGUID: g602GEnzS2u9uND1buk/QA==
X-CSE-MsgGUID: Q0ktBc0mQNCqmfy7+6InZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="79478894"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="79478894"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 01:51:29 -0700
X-CSE-ConnectionGUID: lxKHFfy8S8yGC7CiOwCOCw==
X-CSE-MsgGUID: hT7mcpayQQ+0Z7a3TAKHHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="261767495"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO [10.245.244.49]) ([10.245.244.49])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 01:51:24 -0700
Message-ID: <1ce447ceea88bbe56c7d28654a51fc2856a7f986.camel@linux.intel.com>
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Christian
 =?ISO-8859-1?Q?K=F6nig?=
	 <christian.koenig@amd.com>, intel-xe@lists.freedesktop.org
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
Date: Wed, 13 May 2026 10:51:21 +0200
In-Reply-To: <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
	 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
	 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
	 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
	 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
	 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
	 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3AF5540004
X-Stat-Signature: 6mgbnyaajpnebertzqygbcp59a9iekso
X-HE-Tag: 1778662294-122263
X-HE-Meta: U2FsdGVkX19OFCPseOl2l4618SlinS9e7HcQNqglkIkofguYo8kyUPuYlNc+i5jJgdukTHoxTdNAR5YlKin8mljT5xxiRTM+EG8A764+zyjYptPkMVYNHMXI7YXCIvh1uJc0MmGG4F/w38SfXY71O1b3GiR1nLMEmPYp5yVUlQ1FPhNadZ7/Pu/lXX3g758xps6a/eCr/KskGQOhK6fkqCuWgWpwxPxXHSzhf+FzXaOQjYp7rnQrjtkWiOKpfpw39OreyY4O3+s9YhBfyNjQCixfpsV/aT13rqtFiZsdLGC8yy65a1u2nk2+VVEe1NdoHkHQ84CvVUTB2iYaqFi7Ch9IYQfmHc/cGADdeZLio64XPZwCTSq3mDI7xOKbX6eF25nOhr0JRdyGDQK/5jlwOT4Kkw7AKa8/EPKvePciAhGp4b8PM9XZDAQNi7INDHN9UlueG4Jy+BZ4Nj+fd2cgGiCxsoNUtfmem/o2tmT0tl4kiV+OZ/4d8MMkh/uLrMM8N7jYX4LLt7t3k2qtE27Xuxf69uqF6JeMtJHvCN6+1AipVm5p0YPi6nDz4FRcFHr57DtHTeDSfbEJ8hKMouwA4ax641jihXZ87WIZeKro6IMxnclq7yqbv2VLDc6hguzeQrpFqLIegm3M7zQyD5S+hxLBMzUJ/f7sN7u2dzWlt85GET6Ask9xQEFTUxfgr0mHrsO9yspiEY1y9mRQIPpGVXRpJaVeyockyaWqVz0xlxM+1WtYAZt22RC3RabuEgWs7PClDXs4LwM9zp2YwZU18i3Pf61g//JowFFnP8gc6NMZUn7ckd0oApswpg0o/afT26JL3T9tp1UuKMqaxaamn+j6U2dtv9p92JPtqXx0/HaIbCDkP/7QatGcnV1KsehGbDyvgO1+TYYJ2mkdaBRIUTrYvDDN1+EiVkVrOZGkWW7mSK+TjKhjpDkTZJEdlwidxN/OsyIjt2iNHW4J0lQ
 JLYT899z
 nEkd6/7XWmZgVxucAwHNDstDkDwu/giAFcGAaPWwV01aoZp9q3xQNZJRtgp9h8/Ymr5aZDDsDeCVT0d+u0heL1AK4CqaXFx6mumTSYjf1Nh2mUc//2BCN2GsyxiyefIIjhCdVAsq1FHbcf3ieCR4B3Ml7bMKqIZqSIQ0jmmgUP3T0JcXqFxqk87MyqWoH8bYCtwkQZzo0eNFL2vlPn3he3yHwq7BZIXloheRsY9Ck+3yujoJb89DzdFuy++OWAlONTr8yHmBXJguRDozg/k7N7T0qpZP4+0e6JHCn9LPwangM8Ig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-05-13 at 10:37 +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 09:47, Christian K=C3=B6nig wrote:
> > Hi David & Thomas,
> >=20
> > On 5/12/26 22:03, David Hildenbrand (Arm) wrote:
> > > On 5/12/26 13:31, Thomas Hellstr=C3=B6m wrote:
> > ...
> > > >=20
> > > > OK, can eliminate those. Is VM_WARN_ON_FOLIO() preferred,
> > > > or any other type of assert?
> > >=20
> > > VM_WARN_ON_FOLIO() is usually what you want, or
> > > VM_WARN_ON_ONCE().
> > >=20
> > > >=20
> > > >=20
> > > > OK, let me understand the concern. The pages are allocated as
> > > > multi-
> > > > page folios using alloc_pages(gfp, order), but typically not
> > > > promoted
> > > > to compound pages, until inserted here. Is it that promotion
> > > > that is of
> > > > concern or inserting pages of unknown origin into shmem?
> > > > Anything we
> > > > can do to alleviate that concern?
> > >=20
> > > It's all rather questionable.
> > >=20
> > > A couple of points:
> > >=20
> > > a) The pages are allocated to be unmovable, but adding them to
> > > shmem effectively
> > > =C2=A0=C2=A0 turns them movable. Now you interfere with the page allo=
cator
> > > logic of
> > > =C2=A0=C2=A0 placing movable and unmovable pages a reasonable way int=
o
> > > =C2=A0=C2=A0 pageblocks that group allocations of similar types.
> > >=20
> > > b) A driver is not supposed to decide which folio size will be
> > > allocated for
> > > =C2=A0=C2=A0 shmem.
> >=20
> > Exactly that is one of the major reasons why we aren't using a
> > shmem as backing store for TTM buffers in the first place.
>=20
> What was the problem with that the last time this was considered?
>=20
> shmem nowadays supports THP (e.g., 2M) and even mTHP (e.g., 64K).
>=20
> For internal mounts, it must be enabled accordingly
> (/sys/kernel/mm/transparent_hugepage/.../shmem_enabled).
>=20
> Some distributions still default to "never". I guess if an admin
> enables it, you
> would just get THPs.

FWIW, the i915 driver which uses shmem "natively" uses a special mount
here that gives back THPs.

>=20
> If "distro default" is the only problem, I guess we could think about
> how to
> improve that. For example, just let internal GPU DRM objects allocate
> any folio
> size available and supported etc.
>=20
> Would that make it possible to just use shmem natively? (e.g., how
> would this
> interact with shmem features like folio migration, would that be
> workable with
> DRM objects?).

Currently the drivers that use shmem in this way use
"mapping_set_unevictable()" as long as the object is bound to the GPU.
Then shrinkers can unbind from GPU and revert that setting.

The problem, (as also stated in the cover letter of this series) is for
drivers that need to change caching of the pages to WC or UC. That's an
extremely costly operation so TTM needs to pool such allocations.
That's where using shmem natively becomes very ugly, because you can't
really use a 1:1 mapping between shmem objects and DRM objects anymore.

Thanks,
Thomas



