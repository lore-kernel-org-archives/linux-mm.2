Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20DC2CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 14:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE176B00D8; Wed, 13 May 2026 10:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5186B00D9; Wed, 13 May 2026 10:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB776B00DA; Wed, 13 May 2026 10:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 001E06B00D8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:53:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6231E120157
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:53:31 +0000 (UTC)
X-FDA: 84762690222.09.AC814D7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7A9D68000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:53:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mwadEz5O;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778684009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nkd0hIANHMErNoW+36L2RFIXXYiPCP2hqzvZ335Z8U=;
	b=smtQgbY2MAXRZRsfn9N/GnhTljVBPPkkkpcvY471p9Yl1K2sGDRLXMe+ITcGUtu4yQ7ws0
	J6mG+3VwaH0bT4JyrBX3xhS+Zg8KZpvOuYB3ps4qMKxoZ3nNkpKs+ODSIzkABHI+TirU1X
	RH4LRKsjeO8VKQpz0z5+mpjaP1yhy/g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778684009; a=rsa-sha256;
	cv=none;
	b=IGUcQ7ONwntifXsU1S3GiRJ10dELjaXZyKvGFLxMZLI+gZ9N8y1tVdzbbgJwwda0yiB0xc
	ruPufLxGGnreQvs/24JKxtUYaHxTlP4Znh+DIAd6BwhyAHGAKPKUVeWzI907mIjDwHk+V4
	bVY5FeF7ZbYSk4DL6Z8uW+OJIGn/5fo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mwadEz5O;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778684009; x=1810220009;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+nkd0hIANHMErNoW+36L2RFIXXYiPCP2hqzvZ335Z8U=;
  b=mwadEz5OybqYEojaGhJWJ2Q6Mx/1nZ6D+zBToueqGe3NTDziABrTAQno
   sqpkGf8QkaVPEhw92DMSFMjmGc4bQmvKjSr80qX5WFCZnXjNMstwfEHXA
   yIjB9dmGVtAIm2I0NrzAUV3W5vWAutnELtSX2763zcLs/G+etdccOY6XP
   dUbpSXCPXg1cSZJoF94DyFVVjXChd71mAzPJRdIHCOcmw4s7NuSy5Jug8
   G7rnCOhQJ/Bsh24DC5Iy8O2XXS360NzRSdz57xok0erGqA36tYxJmjgp2
   xZTjaT502w0fGGFYy5BDoW4VH4HA/nKsGwDPsXqHtC/3gomf72RkyiqC0
   A==;
X-CSE-ConnectionGUID: KuQRs5tiQ5254Ai+RkhdcQ==
X-CSE-MsgGUID: XeellDLURLCA4vy5CNTDgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="97039252"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="97039252"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 07:53:21 -0700
X-CSE-ConnectionGUID: vjFABCX/SsuPcYOxQxbOUg==
X-CSE-MsgGUID: X8kOSuBQQWCEnb4zi4I8dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="242112986"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO [10.245.244.49]) ([10.245.244.49])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 07:53:14 -0700
Message-ID: <d5e310c7f4506ef373c705180b33b9d5b2645b1a.camel@linux.intel.com>
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
Date: Wed, 13 May 2026 16:53:11 +0200
In-Reply-To: <d7cc273b-17a2-4b5f-af6a-0dc708c8cabf@kernel.org>
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
	 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
	 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
	 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
	 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
	 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
	 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
	 <1ce447ceea88bbe56c7d28654a51fc2856a7f986.camel@linux.intel.com>
	 <65596f86-e6a3-48b0-aa3d-2e608964e29d@kernel.org>
	 <c0b5b94dfb4d04a1319bfb110f326afd2c29d48b.camel@linux.intel.com>
	 <d7cc273b-17a2-4b5f-af6a-0dc708c8cabf@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A9D68000A
X-Rspamd-Server: rspam04
X-Stat-Signature: s1s3tfkb4zzb8nu4owuw31kfrahixc8x
X-HE-Tag: 1778684008-988745
X-HE-Meta: U2FsdGVkX1/3WySG776dKXSaLwXVkM3+yGuYVwlS8hYrNTM/lHZ3bXej7BqXdwDPq3cjQgJNrJnR4Gkvc5RdDrxKncrAw1ASOkwGTrGRyXKPi0FpjaAM0LowDjMLdZaj9TEKzu7UMrgNKfmQJ8HbPLKue4fTco29AvLFEPwdD9pNGpIy3gQUGfVyAfcdJDFjFS+j/jungAbTnT8vyk2yDYsbFkrB/ffBk811VGTGNJ4QFM23/5bHcjhhhRcTRR3lHwiYuyN10/bAft9hUr3aGwyZXs6X+dEhQ3zwRFP7VtnKfjIt8KN/2xzMwNNh7w/0P+AE16SyejYMSqgKx4Y+NjiYY247P9pJBDIkOaUC896f0l3Hv/HIOpvdKAomvD60lTNAt5jUN4x6tAvCUXweuaG9Ux+tFBXV/Xdb5NiC8RMeJiN3UJarHyrwKj2unMS36/oJelnFiYPWs0qg1reNePhx5IB1u1atFQcwAHrJzHJC7/z1VwIUAuQll0WNXGku+xiUOfRcwQBX9jxtGWOVWWcQotW3Q00E6EKolSx90MR/pocK0rAxu6fexbUqxATjzmoAIuBq9TzFeu3wF5geSjVxvaU2Z+TPhAMdLBk0gGrfyNDbGFMVBciirG8jUxwcX9zju12+0tjieHsC1Gt2UYIdeKRcHB1AbWpBwPON2Y+2tQl/wrosGfC4KoXSUw4sVLLm1XbRluDE0eCnSjaVh5y1WGc4LmXrRgp7e9/sBoW8ytbPQEdfGS2GdpUbHzt+spsmZjiXTkpu0S694rpso5aeMDCmD4yeXx9PgiJ2mB2RriRyyMKeS+PeBsGdQTf6BlW33m9yWIjSBAoKIPsgcsX5pO0iw5R/UjlfVI0EbzdW6wXbCprPVjO0vHDKTisO0npOmcbPpRsNnVAqs2IGp/AIOkg5qtjiA2sMWXzxlPSo7n268IqiXm2px8VYF2dvkYi6mqxO3A3eFjgV1nn
 lEV5IeMx
 YIVagIxKS4jWCSQ+xd3gAP+RlveM48X219bur6fheci6sTDJufBI9ASbaSwfNoEK7UDhLFp5eyOaLalUYCwWG4TWY6B7B2XGlYj8d4CKl9KBbHnEsNytP4q17t6YiYDdDNgD7eI89hUs8KKaaREWTzNK6kk085CSWo31cRaW7Xg4e2CaksOi4PN8znq0JfKR1BX5LJ6ZAy355XDvQa5WFLKV37hclm9hCvDD3GSyeLSnQ23XzlHv9IRMi+mxIkDWXY7mBMwW8ARlA6DYOOc/qgGxoJmu6HY0U0IYwn3EQpTghMA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-05-13 at 13:36 +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 12:37, Thomas Hellstr=C3=B6m wrote:
>=20
>=20
> >=20
[...]
> > One alternative would be a single large sparse shmem object common
> > for
> > all DRM objects, with a range allocator, but that also got pretty
> > ugly
> > when I tried to implement that.
>=20
> Does not sound too crazy, though.
>=20
> >=20

Yeah, I stumbled on finding a reasonable idea to connect a shmem folio
to the pool LRUs and the range allocator metadata.

Assuming a shmem folio is pinned using the memfd pinning interface,
would folio->private be temporarily available?

Thanks,
Thomas

