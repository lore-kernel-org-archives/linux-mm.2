Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09527CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FEC8E0013; Mon, 10 Nov 2025 11:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377808E0003; Mon, 10 Nov 2025 11:04:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B48B8E0013; Mon, 10 Nov 2025 11:04:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 179718E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:04:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C437F1DF1C4
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:04:34 +0000 (UTC)
X-FDA: 84095170068.13.534F454
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3CFBB16001B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:04:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+snn06h;
	spf=pass (imf08.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762790673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNLQEol+Rgj9EsjEo0oxUq6WBGuTdteEqbMUM8lGLMs=;
	b=iILQ25aUh135gel2D3f+gZJEtsz91M3th5vdF5f1NtMmkA1GnY1Rl9aAlJFHX24+rmTxpq
	4nKpdMf9F5iYiyTgRmsh1DQyl/SujkF35gvNx8vd5dn8k3FL5waGb5ig2MVPlr3kZK0HWq
	tglLw81oj+1fFP3mi/RZQ74fHe66yKA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+snn06h;
	spf=pass (imf08.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762790673; a=rsa-sha256;
	cv=none;
	b=OhKCMOiHiTu6QKXHwT4PiWzGPCKPrPeMhgsac2ZQp81MUI5GKH6SvF/qNXmomjldggATKK
	wAqaHaXp5Tt5zTEtAmYoQTrjCR2kqlMWrfraZm2xMD5qP2NV9UWkdvRim1uI1yms/6s+QQ
	AV/rjV8HnZCMjHHeko9L44rctDNA3V8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 77FCB601D0;
	Mon, 10 Nov 2025 16:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087B0C4CEFB;
	Mon, 10 Nov 2025 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762790672;
	bh=LZ0mMsF76kmnDhMfcojZG4ktxujqq7jQuwle0KZTEXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J+snn06h+IYhepopRmbvt8zlgXQzsk6ymnBqQttXNsd2cAGH3KYMr8zVUQcNDD3jN
	 YM5zjB1ENrcxFa7Dqk6Wx3PVrpQxby+frFaLCEQhyY844KTRzFe3cH1bzE4S939zG9
	 BRsNxIlJdrRa+2ma2pfRfVTmWf0EW0ElZsxsen+ENsWYBCsImW1J5qDg3a1WCK3EUS
	 0gkrEzn+7zUIY5wxIZOro6siQoFX3EbehnqyyovCVg1VtrEibxGFtngGvt8jO6jrNE
	 6P+B9Bn9y1WKSAuSfN0n71SqtCZEZoQFwsKzA5DzDSPZpPS6MuFlDHu0a/58r3lPYY
	 oAS9LMgXZYuHA==
Date: Mon, 10 Nov 2025 06:04:30 -1000
From: Tejun Heo <tj@kernel.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Leon Huang Fu <leon.huangfu@shopee.com>, linux-mm@kvack.org,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz,
	laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com,
	corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <aRINDrnnI1HVvU1p@slm.duckdns.org>
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
 <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
X-Rspamd-Queue-Id: 3CFBB16001B
X-Stat-Signature: nm5pxho3igwzdk7bnxhycnbgk4d6drpg
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762790673-36772
X-HE-Meta: U2FsdGVkX184LfwFgPdtqgZMjEGLc9UHsATx+t00YmO6EPpavYyyV3PYFgb5C5S5ijGwaeV7ddzoEBVb2agnWLkN5WeoE3fEgc+OOYfChRiPwOgFL13IYPA2sCxFTp0dtbajUe54nZ0ZPoMYjQmG+ZVxoTibSCxJ1T4H6giduwMF03YkcLrwryGizAyIYMv5T01/FRUSBfp5H9Z7JiDbqjzxUWBTYIxxHolwBc4tFHchXMZeZZMNRTROndV6cqo/2sBTPTEyGDmoYdDI4FJb5OzQeO70PrNFgWiqytx2gvvnBZP6FKpvIwLiWdh8jsTNXxqzhilpIkrZQNO9R+irkmWarCXfYVA05L2lwA+NGGbrWc1WksUGli3AX77zPHQD0xowUAgb3gcFpaFmMrfFKpySLEI867oxbYd98JUXkjG/y7/6WLu0VkwuY2Tkx4NcP+HoijWWGsHSDFSZlOjTC3tTOkatsx1vVlcyUYDGNTwKjRTmkXKK4Okx4ErFGls9HdnIV5SMjlHWbtZjOgEWeQwUMqQC6WYDaqoVgH4tjS453hidCtPZNnWsmfpo79K51yQ1rq0ozHlbkLRm95BScWscfTiI4ArYxiXDwJe4Y8UrcvGcieqFqhcbsOP/ZA1vmBhGMd6n6OOJouOn2IOWxR3WKIRiTCUsLkz7Jzz25+pHSZZxfG1FAtKUj7iJ2Uax/lU3WcCUgFSDbdA8A02cYsYA85nZzs3DhroQsEZ0gH5tsZaZK9hfZP7EIRLWxfRZiPUcf9kM2pirATs/1NQGU72lyoHJOljbckeBT4ZhEc39BSMIqsCSRkeEdZZUU6xumzPZP8YFlRgwPCs2ZoPfxGVWLFS+W9dTgw/NbCCblyFlkHj/9s2/vw0Pgc0fXSV+A6Tubq4HwzIlw+wl6PtMkv7vjoMwIBzHqZDcG31+eeshn/FFEAoL/NULC2yCXv9oQSPlA0EynQ3k9sXCbA/
 bnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Nov 10, 2025 at 02:50:11PM +0100, Michal Koutný wrote:
> All in all, I'd like to have more backing data on insufficiency of (all
> the) rstat optimizations before opening explicit flushes like this
> (especially when it's meant to be exposed by BPF already).

+1. If the current behavior introduces errors too significant to ignore, I'd
much rather see it fixed from the implementation side rather than exposing
internal operation details like this.

Thanks.

-- 
tejun

