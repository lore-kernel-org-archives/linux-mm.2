Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0640BCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373056B0088; Thu, 14 May 2026 06:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323CA6B008A; Thu, 14 May 2026 06:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212706B008C; Thu, 14 May 2026 06:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF656B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:41:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB04BC197E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:41:05 +0000 (UTC)
X-FDA: 84765682890.19.5F31BBD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf02.hostedemail.com (Postfix) with ESMTP id DDED980009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:41:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f6Guuqi3;
	spf=pass (imf02.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778755263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdUtbB1KKCUQA7QYGmM8hiQm9oKu3vwDYTWqyKgFU4Y=;
	b=zTppmAYduUzicYDYF4Hp5FnaCGjpQWZjkGt9+zGesd1GZBLywnAtrDC+Gv9a30SMCzDw4j
	8j/ZJ+dn/riX9Wf3Vecphu9HgchsaV5SuCLn9aJRB56G/pSmzorKCBQXqGljCBEPYZUDQV
	vsY5hovaAh3EElFciAWh1Uu2q215VsQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f6Guuqi3;
	spf=pass (imf02.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778755263; a=rsa-sha256;
	cv=none;
	b=oVWQ5cvIqCPjwF6nZgM82NZaXeQ5/ddiFLxmnrudZaDBx812J88fhLipP21XrTvYLlFa0c
	H5OcftqtN6BV0ZVpwqwc47Wejg8hiP6U9qREfhxVSzMUjHwJA0Js7fFHV1KaT2pjaQO7f7
	LKbuRmfZsrknGL2lRgN5K4F+GGbEJkw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778755263; x=1810291263;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=UdUtbB1KKCUQA7QYGmM8hiQm9oKu3vwDYTWqyKgFU4Y=;
  b=f6Guuqi3oezSpxrBUKs5EEBWgILimEO99BEpJ5fuxYXE20qDVimIWkAZ
   RocIW38Mx3xkNUkMA3YhkBcp++aMdvgDctbKBvCUjr5dbr82IkrVwGhx4
   BuHTjczIF2ISNL0W7A4P8MHmWB+gYmzUHs/Xbdwpczf4rs8cMCLj++QwO
   Z3fa3Sr8K/wRpidQesA+3Qar61uHmIiXIwQanFp7D6fll2E25zvZXivYJ
   xCypCYnNwfrVi1RRwXk+tIrGST9sMUMig/8y98QIUURoSIxfMKF/MK+rI
   yq0mlLDt5mrY54Lk9i5oQyMIHFLw/IPHuXYTOJ9puFVLadMWQoRlNtL3k
   A==;
X-CSE-ConnectionGUID: RaEky3M3S3WTexmgZnMLSQ==
X-CSE-MsgGUID: QWit7aV/TheNnVumNGYSEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="79408510"
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="79408510"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 03:41:01 -0700
X-CSE-ConnectionGUID: 8iaG3PHYQ6+GrAdKFrQALQ==
X-CSE-MsgGUID: vunfD7ioRj6XQNXNyLC5YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="237489377"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.245.244.244]) ([10.245.244.244])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 03:40:55 -0700
Message-ID: <0fd47baa4bf8a83e258f8cd74de3a51c056ae59c.camel@linux.intel.com>
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
Date: Thu, 14 May 2026 12:40:53 +0200
In-Reply-To: <ea5063c9-9db1-4314-a8d0-c693de412b65@kernel.org>
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
	 <d5e310c7f4506ef373c705180b33b9d5b2645b1a.camel@linux.intel.com>
	 <ea5063c9-9db1-4314-a8d0-c693de412b65@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: q3omcdopxsfpbgqwqdnfhrxbt5ixn4os
X-Rspamd-Queue-Id: DDED980009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778755262-928772
X-HE-Meta: U2FsdGVkX19TJUgdzV/oDF8RpMwweyO/G2Stj2TODu5JLe9QAMW6vff7CL0rfYmYwLKrkIkIAQZV+TBjXqtfyGZzCl194qsGvnuY1nZ2Ov25xhOIW7z/DHJyLJT5c3YJ8xE0OnUT5x1hyubQSMnl5s84Fbjs0UF6hoormBEExPW8aapM8Wu7+gDG2UVGHMKSlRjr0JiMBoV/c2gdnLsTbCS+K05jo2y/z8RPGPH8dwp3iBJcWfBZ57W2K6VscSWvpJSgiJyGZ+iY0ly0Jsf1nJuePR9kfvRTeRSxReEWJjMx2AYxqsohX1UTpiGyJt2V1k75pBbQmP18T8QEcZwJVwT5zr5f6vrS+TKO0ZFMCEm6U9ek+rY3bR/TrZSDpGNNzIDGi2n7dNkYolIfSun2xkfZ4wyioEzQFmaXgtd1owewzXg1ocI3rdVfLvreEAriBTMw4vU2LUu5oL8dvojuq7bmMPrCxkxRtSe+ob+cI/N5fEEmK9SpnDSvMWF/B5C/0eHWsbqYjq8LcS9GprNC5fx9Sg0bKqU1fyP8h4r8GYnUfq9UPWyhQU31XMnRQXudbwvPw06qzXWHS5UI/DCfGTnRqR3vDONPfXCSpn9orLaROR9EAapi/PLlSCkx9q9vt1R51+dNgPI93TJ6J51vB52BTfkaZlGXVi/jvvB3G+krs07dTUjePRWOS1oZL1RiYAYhwZrWdjR08Gpukt5uhLzH/XAnvejq34nwHbz4E7XEaraqQ2YBmQ95Rc8VzUbx+UX40w00PW/YJHgpj5LhI6chNYLBaiSND72/m33+XwBlhsOK6KFb9CC74FDKBqAbSgkD33NLJTfTKnUY6hgzEQFHKmBquW7xaGYIWMPJAM6Rp+1kSBKN04QHzIc1kDDKxEk6mBllsQk3PEv/a6wFILDDnkblMiCOMfpijuHeFw0Q0W9CSnBkJHtsqblukFUUZ4Ebx5F8dCh5j1Exy9z
 51kn541U
 Pjk2lXmQgVz5BNSZ9sWDyigTWyS1JBsBeaaoM69zdTBs/fcPMuROXy550t1IOGMz7tTrDcauRfCsQqrzC+TFdsYrobO98yzRyu/Uvi8Nmmd6D8gITvNDaIESj7uQQ4UFvcBp5W6vPCol70WTwfK6pYjVgAmfNcEeM+1DbSRqiH5w3yBY75LsjZZyfeuzuq0Q2/v4pR2BPogry8JVbCCd4nuDHyZeqk9TXZJBxGkkC0Ez9RSEUOfZvtXBVLt2JLb6tTmxDXEGGQwB5jHdyI65BPbsvRWQLpLp79hscseUfswgmdks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-05-13 at 21:35 +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 16:53, Thomas Hellstr=C3=B6m wrote:
> > On Wed, 2026-05-13 at 13:36 +0200, David Hildenbrand (Arm) wrote:
> > > On 5/13/26 12:37, Thomas Hellstr=C3=B6m wrote:
> > >=20
> > >=20
> > > >=20
> > [...]
> > > > One alternative would be a single large sparse shmem object
> > > > common
> > > > for
> > > > all DRM objects, with a range allocator, but that also got
> > > > pretty
> > > > ugly
> > > > when I tried to implement that.
> > >=20
> > > Does not sound too crazy, though.
> > >=20
> > > >=20
> >=20
> > Yeah, I stumbled on finding a reasonable idea to connect a shmem
> > folio
> > to the pool LRUs and the range allocator metadata.
> >=20
> > Assuming a shmem folio is pinned using the memfd pinning interface,
> > would folio->private be temporarily available?
>=20
> I think shmem uses folio->private only when the folio is in the
> swapcache
> (through folio->swap). So one has to protect against that.
>=20
> So you're thinking of a model, where a shmem file is essentially
> fully "owned"
> by a DRM object, and that owner could make use of folio->private as
> long as the
> folio is prevented from getting swapped out? (e.g., longterm pinned
> etc)

Yeah, exactly.

Thanks,
Thomas

