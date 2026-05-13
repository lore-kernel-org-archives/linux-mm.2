Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2CCCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3CF6B0005; Wed, 13 May 2026 06:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D4D6B008A; Wed, 13 May 2026 06:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3BD6B008C; Wed, 13 May 2026 06:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFC186B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:37:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C97AC2ABB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:37:14 +0000 (UTC)
X-FDA: 84762044388.19.6E35132
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf06.hostedemail.com (Postfix) with ESMTP id 813A5180006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:37:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=epHfz6Ia;
	spf=pass (imf06.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778668632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxjfMH/H3au7DOcyqElNJ36t78ne1+5k8Gh44S/bASU=;
	b=w82iI2sZrESi8pAlvLPNR45UUdsOyfZDDoptFcT13pfRbVKd6mtCS/X68XlhUmclZM5NfI
	VleCVRe1AysF8PDxRU3V/VxO6LY1Un/HqiegiQMK9v+Nzenu0OGoFjpjLJtzfdOGN6vWJV
	xSBIfY1EAr0Gez0MS7/1QRZ8U8ER5CU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=epHfz6Ia;
	spf=pass (imf06.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778668632; a=rsa-sha256;
	cv=none;
	b=jZe8t4FxE04APnzUMvl6ZufVTKWy52EsgZzfQX/rGOV8b3/d8OFrt5SXi45QeAOh7ViQp5
	0afhKKUtXB2jAhkS2DQ+v1Nl9zrD0CWg+9R470btRXkukLoTGC6wWMFNsZyx+JhFZW+kOM
	H0Ux87uAl4h72OOoSqjt2+a6zqYmMTw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778668632; x=1810204632;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BxjfMH/H3au7DOcyqElNJ36t78ne1+5k8Gh44S/bASU=;
  b=epHfz6IaIMZAQG2Jfvg+g9HyvYEWAt9c+I4cJ7JbL+g98it3rB0t2aNH
   +MFDCkFi+EoitqYeD5q0sBfQ6IXy8zQs62k6VfnCSzpzleMHYjS46yu/U
   bq3zPfqxoq9H8Wg5lrPltQ+p+vPvNezTxByUJc31gvbHvz3yN6seXzH3e
   SULEUZt87Bx9JiitrIUXqq9tlyDJJKcbr8qp21qQNaERPog7+3DXowbCP
   hHkXfz2QKv5rg0ek0AxKvizzqN1Iatx2ihkTIEn/dr1U0zOFH0f2pXD9w
   C4wl4XeJIGPYMqyhurfodAqkJC+xNW4QzckTH7/pvnw/5tH/QVXGA9ZqL
   A==;
X-CSE-ConnectionGUID: S2LMgTdvQsG0BO0AWFM0IA==
X-CSE-MsgGUID: gTiBC60bTjSkiV2GQl5gCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="105051546"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="105051546"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 03:37:10 -0700
X-CSE-ConnectionGUID: tg4Gi978RJefcU6sBiWAiQ==
X-CSE-MsgGUID: 7s6mhKSbQj2Zwhr+kHYyOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="242401523"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO [10.245.244.49]) ([10.245.244.49])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 03:37:05 -0700
Message-ID: <c0b5b94dfb4d04a1319bfb110f326afd2c29d48b.camel@linux.intel.com>
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
Date: Wed, 13 May 2026 12:37:01 +0200
In-Reply-To: <65596f86-e6a3-48b0-aa3d-2e608964e29d@kernel.org>
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
	 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
	 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
	 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
	 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
	 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
	 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
	 <1ce447ceea88bbe56c7d28654a51fc2856a7f986.camel@linux.intel.com>
	 <65596f86-e6a3-48b0-aa3d-2e608964e29d@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 813A5180006
X-Rspamd-Server: rspam06
X-Stat-Signature: p9kc7t8re5gwkinfqk34ix9ziazuaafy
X-HE-Tag: 1778668631-183498
X-HE-Meta: U2FsdGVkX19Vdvg3CEMsDfNzL+rPM3/0u/nJ2Tdzs9IoPIGFMrlMmBnd/3RHXsJvQCYlPsKu7vSMbpJkGD8dKOqXL3wuBaRulPPMwVEgI4KfmoJqTh0OgkCOU2oOo5V0d2dDu8BL4ja1wrSp3g0j2S/z22sI4ZXWoUyflj/7cOEbKbjrpY89LgqqDbd7aOW/D/LFY+UP+rs4Xhwf3z8SVpKOT9Tx0/RlIZOe7nOZ4ejBW+YBbrqQaz+BAG5IaQsNYeH81zrcxUQEb2bx+RTUwz/7CALdo+UgOI3yMNFQ5KRawvCxVKUCVZUBDd0JeANAaNB0Jj7zLz7kaA66A/RR20oBCvVzQIyWkDJZOGcDjwHzsF0FjEAdOX04AH9Gvv8ocb0C/2WuGwcLlpjqHGB7t/lSCeMMHNW7EePKs8/IMxcfDYYKTdbiR3S02lPEWK/hv07RmZ6B67/MBDr2YMBkYHkPkynCyZrVv4zvvepMNzTLy0qeQ2Sx7Ap/Zlt+7pDdHPjf77PthoXQCvEkuJ14v4YBjRBH+1Unr8Igq0ZceoozvbA73E4HKIKdz0Sn82ytr0MjJxzuFzN/kKf/nmGu8IEPgbMV/QT83auDMkULgaMuK/7EirI8nPUiPCQnKirdl+26l7NDo8+7mCUWG9bG1tqbBylDf59zx0xPJUWR9ioMsTAMuPP5fwcbMiKnegiymqdARZ2DPVH1GJJ2dh8xqHpbqmAaxUA0ZzH/MPjFGLXD90d6be4Mb7sdEK9/NIp+cZdtZQ7LbTIth9ZKl2wYUugNeudUbE7VjgXpwvnHbspP4H/5hWF0nWHL3MOeKpkux4o2x0tjIRx9X9mZD7W2JLetm4lo9Po95CAbDrRI+80aiw3GyeP8s+4GJkTjQ2YF5hax33/W7Q7gk2am4CackTKpPAD0ig48cUDQ3/IjZwYCwCSQSdbLdsTbFhlFoQU4ZEIvkmAbT7HOG5FdbfF
 +2RmlP04
 RKzkBUEepWA+Rg2LUs5BGz8WZ4/E53qu2ecn26eDSwEQaZ1gZSWivvdiX92X/budTndqwrG/1QzAOigSyqfMyw66KxQwWLilOxdVj6rYBk9JnUuUr1jO3V2NKETzMXGkkDP/Lx68vjg2+DxRXnyWqK8mZLKF/ROucZ47JCTJtyeAjElkGUOhI3ORrHJNLpcFXu5V7qlBPCdWBADW01UhROXFMp1TrfjHUKK2qNPKUbSnSinmYGa32frjSv9dcJgvIs88b1WA+Ht8cSR7Il6Js4SDKbniSZG6df5pnpLhC3KiglqyH944Adu/saIXLCTSzIBBcPJvvPxsS1I3S/1Kc1ZbtAVCS53DgUeRVp0g07KEmZ9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-05-13 at 12:03 +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 10:51, Thomas Hellstr=C3=B6m wrote:
> > On Wed, 2026-05-13 at 10:37 +0200, David Hildenbrand (Arm) wrote:
> > > On 5/13/26 09:47, Christian K=C3=B6nig wrote:
> > > > Hi David & Thomas,
> > > >=20
> > > > ...
> > > >=20
> > > > Exactly that is one of the major reasons why we aren't using a
> > > > shmem as backing store for TTM buffers in the first place.
> > >=20
> > > What was the problem with that the last time this was considered?
> > >=20
> > > shmem nowadays supports THP (e.g., 2M) and even mTHP (e.g., 64K).
> > >=20
> > > For internal mounts, it must be enabled accordingly
> > > (/sys/kernel/mm/transparent_hugepage/.../shmem_enabled).
> > >=20
> > > Some distributions still default to "never". I guess if an admin
> > > enables it, you
> > > would just get THPs.
> >=20
> > FWIW, the i915 driver which uses shmem "natively" uses a special
> > mount
> > here that gives back THPs.
> >=20
> > >=20
> > > If "distro default" is the only problem, I guess we could think
> > > about
> > > how to
> > > improve that. For example, just let internal GPU DRM objects
> > > allocate
> > > any folio
> > > size available and supported etc.
> > >=20
> > > Would that make it possible to just use shmem natively? (e.g.,
> > > how
> > > would this
> > > interact with shmem features like folio migration, would that be
> > > workable with
> > > DRM objects?).
> >=20
> > Currently the drivers that use shmem in this way use
> > "mapping_set_unevictable()" as long as the object is bound to the
> > GPU.
> > Then shrinkers can unbind from GPU and revert that setting.
>=20
> Right, but mapping_set_unevictable() only affects folio_evictable() -
> -reclaim
> behavior. Not other properties (such as folio migration).

Interesting. Does that imply that a shmem folio can be replaced
underneath without additional measures? It looks like most DRM
call sites imply that mapping_set_unevictable() pins underlying shmem
folios


>=20
> >=20
> > The problem, (as also stated in the cover letter of this series) is
> > for
> > drivers that need to change caching of the pages to WC or UC.
>=20
> I assume you mean "To be able to easily maintain pools of pages
> mapped uncached
> or write-combined".
>=20

Exactly.


> Can you point me at the code that changes the caching of the pages?



x86 implementation is here:
https://elixir.bootlin.com/linux/v7.1-rc3/source/arch/x86/mm/pat/set_memory=
.c#L2556

TTM calls it here:
https://elixir.bootlin.com/linux/v7.1-rc3/source/drivers/gpu/drm/ttm/ttm_po=
ol.c#L249

And there are actually shmem helpers that do this as well, without
pooling.
https://elixir.bootlin.com/linux/v7.1-rc3/source/drivers/gpu/drm/drm_gem_sh=
mem_helper.c#L212


>=20
> > That's an
> > extremely costly operation so TTM needs to pool such allocations.
> > That's where using shmem natively becomes very ugly, because you
> > can't
> > really use a 1:1 mapping between shmem objects and DRM objects
> > anymore.
>=20
> So you would require different caching attributes within a DRM
> object?

The way the TTM pools work are that there are separate pools for each
allocation order and caching modes. That would essentially mean
allocations from a single shmem object would be spread out across
different pools, and we'd loose the 1:1 mapping between DRM objects and
shmem objects.

One alternative would be a single large sparse shmem object common for
all DRM objects, with a range allocator, but that also got pretty ugly
when I tried to implement that.

Finally, (and I think that might be what Christian was getting at as
well) Without CONFIG_TRANSPARENT_HUGEPAGE, we'd only see order 0 shmem
folios, right?

Thanks,
Thomas



