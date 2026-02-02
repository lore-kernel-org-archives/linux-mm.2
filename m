Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E10E7314A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 09:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84586B0088; Mon,  2 Feb 2026 04:13:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07976B008A; Mon,  2 Feb 2026 04:13:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13AF6B008C; Mon,  2 Feb 2026 04:13:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C21D16B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:13:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69E1E5C3C8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:13:13 +0000 (UTC)
X-FDA: 84398952666.15.36C7BD2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id B20BD140007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:13:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BKBYT9K1;
	spf=pass (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770023591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXOTW8XU61f4CbGPL3gcpzwdMcHgirqYXw8QOj4FO6Q=;
	b=KtheC9hbg0bpE5XHGDhQ4Ug+bdCFemXy4184T5HkYNYVGrxf54ZMlFy1vVtUsEOKPpvM30
	wQJPCPitdzN/8+W2aAyBhkfALWQBYqQtI8EHji40uwkU7LVVub2P3j67GSYLxsb9J0hsan
	UuCoJIXeSNbqE2aGA2IHFx8QLNuNSKs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BKBYT9K1;
	spf=pass (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770023591; a=rsa-sha256;
	cv=none;
	b=ceuA7hDSfejkTYoA9bmPC9PqGD8JPB8ZzcHKt9aXEn//QxxoSNmREOkv11F0wfg9r7tUIe
	f9thLsv0KdxXp6YP6ql2E1pIH0i76JnOvekvXuGOGewDnkSsz4WEbrPRfVz+HplRqpbyqc
	Bt0zWX50JV6vkMGrTsmtR9MQZtXmCQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770023591; x=1801559591;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vXOTW8XU61f4CbGPL3gcpzwdMcHgirqYXw8QOj4FO6Q=;
  b=BKBYT9K1W9SK35gQS5SHPfoiYRH93XjNLpNZgcoj8wIjPQFIkw5c1bDJ
   87bT6ZBhLk8RDr0IbJsD4E2to8Kdj6xeNpfPcTqGQ15UfJanL6oeyqzNR
   psIqQDGVVfyh4gYTJq4bXTNGPSU1tx39aV763XiRZ/E83mxNbEF1I+Vjm
   ygUSdSIaHzZM+HeBiz9HhQxCv6aqNfJU65q+GgKlQOlvjHs3CqnBFdfhe
   nWOKJYFtHyObjGTf0MgMEgR2m4FuW4P6DEwUwAgbueDf8pECJZ1OmrWp0
   lm7WcIeoYwLFEKFAOJltxf1TqMdbDNdGL+drW3uYudr20rXYVaLHK8uKg
   Q==;
X-CSE-ConnectionGUID: DCGgZIMvQ9aJ9xoaUY5ZQg==
X-CSE-MsgGUID: MLtMKWe7RzadxeKvtnspYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="71160139"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="71160139"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 01:13:09 -0800
X-CSE-ConnectionGUID: +NriBRTqQlOEiLyPxWQibQ==
X-CSE-MsgGUID: TSSK///DRCO7TAWUDBX7mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="213570159"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.193]) ([10.245.244.193])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 01:13:06 -0800
Message-ID: <a459f147b461c6e6e806282956b7931f74a0aa93.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: John Hubbard <jhubbard@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 intel-xe@lists.freedesktop.org,  Ralph Campbell <rcampbell@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>,  Jason
 Gunthorpe	 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-mm@kvack.org, 	stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Mon, 02 Feb 2026 10:13:03 +0100
In-Reply-To: <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
	 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
	 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
	 <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
	 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
	 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: ofaqe5rog9yojpu9t3muqxjxfbjfxqkz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B20BD140007
X-HE-Tag: 1770023590-576242
X-HE-Meta: U2FsdGVkX1+nUToM+vyRue9HytGGy7TmvAsc/CTJJqOkGMAR+XTjxRj6SacmdTP+Mdu+96hEUPB63IWGitUbEN+e53f4AWg1rdJrtmPw+EJOf59pObEKrhxU9oC8Mm/xx+MPvfcwaEUxPiPHh/88R5omCpN8XvWS6M1CezEQ5qCDD36P0sZVN+YNR+/JDkOQBEZi/u1jqrX9d/JeBURQiII4UiHqsqPt4S/JoW7gZ/GpA49rckNJXMpoIhB6Q8O63hp/Yiem2z412WdgBg5NU6CjN8UPwXPWbiteqzV7aP17KqO0BVvXS6sy49KgH7xHlLiYRwfUZ/YoPExYb8NNeWAoh64vsUW9MeM0SvgkF+2wSAC4HvnqomzwKaB0TVDb+QfuCrIjh8ldhftIgb++02bCwrRMfaTDBMV80fTT8ZHEPGM9P6A7jDL5ifgw16V3g49PYipSz4v5DKoYeLVWUbrUQ2M8S5PQMjJPKzrnc/Vvz7AyjA9tAFdFds3i6Up8Y/MiF8CXZDBivyRuNF2Eqiyj90aF9Mnm3CE9oGWObw1cW+LaOnDUZCE7laXUurb6YD+ZNYQYv6pWcwPSwYU7QsELFWQ162ru6Qo0IPPZdyH5FGMKQg0vZw29GxBswCIhzuD59pTQb4svlD+Od7TbB4F4yHfGwrGMhvS4Y/ioUPDXE0Pms5jd3FU8u/iZNLEMdSpxtRvajmS+NCVZAtfbzDkFHRNG133mjPrt2QXOAa2BEqbacWf4r9ux0xTOACdh3oTpOVUpnd5c7inu5fDrS8xWoQdMS1mFHnh0qSGgbwT4Z42lWqRd3f9LunY9vcQUkjt0xDbQXA2yb4exDyqSVgZB/jf2V8nW6R5Rr7lE1xv82mz87tyVbjnXTSiAQN2NLHbWwrajtVordV/ac/RH8PxT4DqtMme3ncR5FFJ1Zlj8msu5rCAzCryHCx519GylrlnzSvtSHTk/sYM9//3
 O2P/1zk4
 5RpTvq4YmuslOqABdGw+9DawTOLOWHImmMMVei1kdUrhAAj20vvwYiGvO0FloY4gCzf8d58+PHaXBvlnybFgJAAdzen067DJ/ML6Hgzfwqg7+fUpZPBUtsoyqda0m5k+Uw056YhuNPnz5TXfNsG6gmDvLeCIePfq+r/aAG+G7q7VHLottSLlQYsv8pBL6wGLOJVeWjLc/KBWEdg0huZuIK78M1ETrFmXIMDvDDJQxcVRm0D8y+tqsC5EMRXDyLNvFWSkojigFQJx2h7sIXN73BzAAmN1UYEPNGLzs4JCT4EQ8Lnn0fEfyWvQvJ8lE5c7LC4h1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-01-31 at 13:42 -0800, John Hubbard wrote:
> On 1/31/26 11:00 AM, Matthew Brost wrote:
> > On Sat, Jan 31, 2026 at 01:57:21PM +0100, Thomas Hellstr=C3=B6m wrote:
> > > On Fri, 2026-01-30 at 19:01 -0800, John Hubbard wrote:
> > > > On 1/30/26 10:00 AM, Andrew Morton wrote:
> > > > > On Fri, 30 Jan 2026 15:45:29 +0100 Thomas Hellstr=C3=B6m
> > > > > <thomas.hellstrom@linux.intel.com> wrote:
> > > > ...
>=20
> >=20
> > > I'm also not sure a folio refcount should block migration after
> > > the
> > > introduction of pinned (like in pin_user_pages) pages. Rather
> > > perhaps a
> > > folio pin-count should block migration and in that case
> > > do_swap_page()
> > > can definitely do a sleeping folio lock and the problem is gone.
>=20
> A problem for that specific point is that pincount and refcount both
> mean, "the page is pinned" (which in turn literally means "not
> allowed
> to migrate/move").

Yeah this is what I actually want to challenge since this is what
blocks us from doing a clean robust solution here. From brief reading
of the docs around the pin-count implementation, I understand it as "If
you want to access the struct page metadata, get a refcount, If you
want to access the actual memory of a page, take a pin-count"

I guess that might still not be true for all old instances in the
kernel using get_user_pages() instead of pin_user_pages() for things
like DMA, but perhaps we can set that in stone and document it at least
for device-private pages for now which would be sufficient for the
do_swap_pages() refcount not to block migration.


>=20
> (In fact, pincount is implemented in terms of refcount, in most
> configurations still.)

Yes but that's only a space optimization never intended to conflict,
right? Meaning a pin-count will imply a refcount but a refcount will
never imply a pin-count?

Thanks,
Thomas

