Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D38AEB48EA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D126B0005; Thu, 12 Feb 2026 03:52:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAE56B0089; Thu, 12 Feb 2026 03:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC3B6B008A; Thu, 12 Feb 2026 03:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAB276B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:52:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C6BF567F0
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:52:52 +0000 (UTC)
X-FDA: 84435189384.20.78DC82C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8181514000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:52:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B5boV60K;
	spf=pass (imf26.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770886370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqbK9AJa/Wxu/mSk+QPCbSAHGW0QQJLkSOUt9xiDgLw=;
	b=ZQKlPFK+d2TZlHvYZNpQninvgei53LA1PrPiAiFnYvn2kwJZqu1cPgxdKbp4QnsGdC2Nkl
	/9v7nmJ/MOCvuAHrAVuO018HKhDBsue3OKNOFWq4INo+E5F8np1C47o8jQW5v7d2UNZctL
	VJ0AjtPxtPVF87tI8UQBVtlzv+JF/zg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770886370; a=rsa-sha256;
	cv=none;
	b=Q8JRvwNUyJ+1hIq5FBK5xPiUhWe+dDfFz7EEB9nrUhVGoQ03u3O0FySxW9W/tIoma0BtiW
	GIkqcrQ2xbRib3VZV8zMhieopkRtQHHbJf29yvqi0v3FHOjhRGv65tweGRBYut/9ptcGgs
	9I3k/FE/FMnn0T1hMrGCmDWUHrzzIho=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B5boV60K;
	spf=pass (imf26.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770886369; x=1802422369;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=NqbK9AJa/Wxu/mSk+QPCbSAHGW0QQJLkSOUt9xiDgLw=;
  b=B5boV60KiW7bvHqLUmJl6WOOuZXjuxg2LDIGV4LgQY8bXw9mTad2P9Sa
   g1PBSzbrFgw0FUY5Ioel3zVnIsoD73tHLB4yJb4Zbh0jiX8bvNpsQAuU/
   CKHfzqlY/mwKLoDu7t/+NZ5N7VN/2++S89Gw1EexOk8tyKni0yANCl3hC
   88V0tKxCRnbsyXaBuw3+stiW2c25h0dU5VQaztugwar+N1vrmeWW/hQOI
   6NyON0C2eiLar7HaitGHudEMZG0oy52MHkTaWZxyOd4gErB7EN81ufqSW
   kmvsTfH932TuN+FN8Siic/CNGzBvFd/EbBnD32SZbkazZaES8KzRZGw1p
   Q==;
X-CSE-ConnectionGUID: 9xcdMfUMTcKE+v5WPS2G5w==
X-CSE-MsgGUID: UUL7JslWRUK8wPO2Fqvf8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="72238077"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="72238077"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 00:52:47 -0800
X-CSE-ConnectionGUID: Or/IkaulSwe++x5wKKy2iA==
X-CSE-MsgGUID: wrtzGgAjRh2Jtc4ZZI7BmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211370272"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.245.128]) ([10.245.245.128])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 00:52:45 -0800
Message-ID: <cce7d407e4749023271d39653cb7cef78e1a60a3.camel@linux.intel.com>
Subject: Re: [PATCH v4] mm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: intel-xe@lists.freedesktop.org, Alistair Popple <apopple@nvidia.com>, 
 Ralph Campbell <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@mellanox.com>,  Jason Gunthorpe	 <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Matthew Brost	 <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, 	linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Date: Thu, 12 Feb 2026 09:52:43 +0100
In-Reply-To: <20260209173446.b76547c4028132f71de1b8eb@linux-foundation.org>
References: <20260205111028.200506-1-thomas.hellstrom@linux.intel.com>
		<89cb1d4744789702cd80dba8eb40dd50bf053b4e.camel@linux.intel.com>
	 <20260209173446.b76547c4028132f71de1b8eb@linux-foundation.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 8181514000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kw33tzzmz5ungbbf155jyrk195cuzw1p
X-HE-Tag: 1770886369-111963
X-HE-Meta: U2FsdGVkX1/0uGrJdr3ZnDRA9BiZsDkDFt4wA++BxVuiFfOgUGaVfhFr1vTSO6WbQUBaZInGAep4ZOtdRMnia3MAdIAcUWWar+YTI3CLnLIjCP3RPaji10MuuBGfB63LN84PVwvLNiDQsRyiSmliz/Z42pScXEQuXXlf2ZJKRaiYqBQnZvdS53QEoKpTymj+kYJ7FsFY+7nrffeD0GeTgpZldL66sGlG+yMxMJXv1cYn3rJLpNed6ZqpjFNy7dQq5jzgSUfjl6YvZHnWIXq4pGrZqrLFT1FNZxVVqCJTrDkmAvopGatlPH+d9hR8JQDnQeI9dxXzrKFXv6JvMCydYL8xgc95xFuG12IOwntWoH/4MXINeMsHzsZKmrx5fVDabJFkJPpCxhBl+6JO8tCty+o5FceNdf7Aznt1z64ski8jn1X2pIpoYo4P3zNXv/fw5RimrTqg+MzcVQGDAS2dylfa5ysU6m/SlhQhi2Rbs60sFTsTxFqWHW8FCvngL7t7Qfk2UCy9u+oauwCTEM6sj9/MAEJqClqGpp3f3alVz/p4gMuKaKpTsOrWFVot/OUi4H0HYrzuD/Sy/aH3CodKB7IRcjJjgR5o3CBQDyoH9O8OiTNmmL++dseHFnXvlU9URcjJKZJXUgv5PuqQYys5srE+nDhfxojCjCZFkVwq/O7TbmGpn2DcrFKPXlytMjIze+8w36smN4hTKK5t6zluOokoZuUQ8s0d8bwnNdbe4ZW7T5czPOtKif/4WdBJbk6ry/znRWAYpJ5iVSxH8qrIViuWonLVUzCSCP5lIAgy1B6Kn0gOWlsl3XyB0G+1Yb1u98I4R034FqyN1npuLvNF7sTLNELCOHwIFaSlA1Vtoenm0DO3kKEJpZC7aszEYr3TBFvrIIXabAH82evCMdC+hOB4q+RCXIR36KFOgIA6KfaiUqHHg51qOn544/R1tfI/WBtQaDDUjLBFNY8YofQ
 DJGk9cae
 UtFxltXxXbg5iHA+aJFLGYuWP6JmHv+RU/P+jwZDXDnivo2CktpD+5uFcWgS8z7kvZyRzdEMq7tMLF4lbusz412Mzi7KRt5bwVGlY6+qo6tSAvhLsxr0EuS85TppL1Q5LG/oaOuGw65CCb9EiL+BzclmClnINPMTJVEz3pUUHoX2KoeEr/XUqMajD4RGfYbbhJpJWKkRfCUoQPMIx++rXXRpNX+RV/hDZz1nWvHdXIK2CorXLXPbBhvaIUvqoWVpGMu3ix3QCg8Xwhz1jDK1aAaCdEwfbvEE7CnsuFWu02TrwEYrpkIv5Jz9SXYjW5uAPWzRu/PRIAn6pczYeIsB+29u+8Y66fKw5WuDAdI+fyeyH8op6hY4gp+XAMTJsfypz/SB5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-09 at 17:34 -0800, Andrew Morton wrote:
> On Mon, 09 Feb 2026 15:47:38 +0100 Thomas Hellstr=C3=B6m
> <thomas.hellstrom@linux.intel.com> wrote:
>=20
> > @Alistair, any chance of an R-B for the below version?
>=20
> Yes please.
>=20
> > @Andrew, will this go through the -mm tree or alternaltively an ack
> > for
> > merging through drm-xe-fixes?
>=20
> Either works.=C2=A0 I'll grab a copy.=C2=A0 It you want to take this via =
drm
> then
> I'll drop the mm.git copy once the drm tree's version appears in
> linux-next.
>=20
> Acked-by: Andrew Morton <akpm@linux-foundation.org>
>=20
> >=20

The drm tree's version now appears in linux-next as

a69d1ab971a624c6f112cea61536569d579c3215

Thanks,
Thomas


