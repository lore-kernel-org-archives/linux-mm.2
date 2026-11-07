Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FD47606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLchhquA
Received: by kanga.kvack.org (Postfix)
	id 52B3E6B05D4; Sat,  7 Nov 2026 17:56:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAD26B05D5; Sat,  7 Nov 2026 17:56:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1A96B05D6; Sat,  7 Nov 2026 17:56:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 151316B05D4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:56:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A0F5160414
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:56:57 +0000 (UTC)
X-FDA: 85409834874.26.33B9499
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D7FD160004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:56:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLchhquA;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794092215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wUwXJNx8JD7Fl9dgQdIfo0QjeGVmxmT1LPcE0XUKqw=;
	b=eL8ddrE3yUARtQ/aigXHktCgTFEtPYBZf1gwOTUlN1Y9FMM+u/KoaC1dhzxYVFb0/dHCer
	LhY++pBeT+PKf3Z3yMjdkr7X9FomQt7EZrVrXPtTt0kSC/bFgYqzlxxufsktnBj/m2P/FT
	Ig2KjCOYOfawQlieZOLcgFsMd3VbB4g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLchhquA;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794092215;
	b=Hl2W7dOnGEyGwzp316XaQM+rhBODCwUXTed1CIHtRXT177gHqicelHBHhFt888tymcMJ5t
	fnKfwcQV/H0lyKIejLyqYhESWiTKdveroHKZz0/8Eve4MgoRZVLmRbaw3Eoes573+y3pUK
	UuFvaima4ET4jaj5qGYBvqdAfa4NM+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA48F60E02;
	Sat,  7 Nov 2026 22:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345101F0089F;
	Sat,  7 Nov 2026 22:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794092214;
	bh=8wUwXJNx8JD7Fl9dgQdIfo0QjeGVmxmT1LPcE0XUKqw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DLchhquAjxZ4d+JYytrasILc/gJMBTIr4SAHeTcBr6036pTK4jVv0PePY54yGNLWd
	 1Bdzm6yxhulvRkXT+gvnNFsNVRIvr9u9g/Df8pR0CWlzj4o4aoWrCA6DS+jybjuIEf
	 O4h7WB1YW02o4Y3AzzHqKxW5afsZrJIfyVN7zpBllKgSVbziqn0Sth185PcBx1+dgj
	 2psPju/Om+1RcnzCadXIFmXSPjieZrAFPsj7ARJb72ku/8V1mvHlAGrVOymyBlCJ5H
	 i/tN//2+7oBX/ex30ytKRj+o8fsT59k20qiT3QVQyMhf51WYf3l+FMCa4f4tlyozA7
	 iWD8B+Cjz22hA==
Message-ID: <sashiko-outbox-203373@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.1.y 1/2] mm/damon/core: skip applying scheme if
 region split for quota fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261107224800.340250-2-sj@kernel.org>
References: <20261107224800.340250-1-sj@kernel.org>
 <20261107224800.340250-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 22:56:53 +0000
X-Stat-Signature: xk6ufk91dqddgcc3mdzyxd31pbx3n41q
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7D7FD160004
X-HE-Tag: 1794092215-464438
X-HE-Meta: U2FsdGVkX1/AXbxd6iEZPDsmPU+y0FJxGufbbcQF0fTaCd+EgGlTlDiq+/8X/W+XacJ+y1umtEwwtEAB5R8kzhOTUSU0NJEM2TQAzEywF++48TKJWIUVAM45RHskh7JMm+nc74nZ5XCLuIJIWuu0te1/jo9uqA5qLulg8ImY8cqScM65lXWAOwJxG4vwDD2aWZSCqtXncFFsMTeCp72rASr0PWiSy9IwIKuol8k+k1t+vsWt3wQUeV3I7YXrhMFF5NUDPkJ4B9fH+Ty3UUV/umLrxUcGkTopn+TaH1ZsdwyhHYOmd3o/aO3C3WZI2j7atqfYCcJWYilK5Z2k1pMEYLGWxFxZLVUBme5d4/EFCsH5QvZ41/f/Mdf1tK7DiJhICI8NYuKHyPBEBNLxSyDaFHNYi9NahTF0N0XVHoGI7OEqQnWKdHB8W8ynCXL1P0ChDy7phCgmyufL9z0KJWPqL/KaugH1aHjr89xaN69UGPneWllbaaxNy2gP8EvB+Rlo7VsP6YMPLKOmuNRqWxGd3xijdNzh1t50WC8jhNSFsNtx9HPUYmMMCTwrmOMzp4stiS/KOuJ0RbH10Yfmzb3WIL0rV6NpWhJWOmCF0ka9AArsmfYE903HwPIgn+AVyguXFKPZKl9+bIJTHOrhIRvv2EAeTyrdqm54Y51TRESnyPrtIVEsddzu/jTVidXBIN5L63HjdBmPp5S61IaIDLZBXB6cS54W7x/1JY9bkaRGzSuJODkoABaLtnhqrxfEvaItXm7Web1bE9Rf0dkMPqIiGmmPLaNBR6+GtnT4sspRWOQSBRwkLnYPTSiTDl/kJ1rZQ9zGdpcvSEDZ6EqyHm4334vafkMm3VGfCDWTD9Hksfw2XqLabA1sced/FgvdFyypG4xpQ0/RFtNwXrqBmoP6Efb6aHO44osTqsl7fGrjKvTBI8tm0rbhEXSQYBCeatsTXByFmWkyfYXVMUQHpjS
 QdZOHqtv
 1/p+9LtuIzsmoK3kmmJOIUBP7HJBp2f3ouZAJd4cJNZ+n+SOfGwDx2cS2iOHlvYQLpU68ahrFosvz4Lhzjx2yr4wPKYsqk7hHu7KM9FZs/1bFZR/mi/MTRzz2MQCIYp+lPolxjfOV8jCPzaWmQ9/Fxz5e7dLFUpmaUxzItM/E+0PuG8rkh/D63lrwjc3+tCM7UfKOLd067CJTcPqwLBPMO4fweRTjBseIMwrG8K+UU2Mby02x4ZQkTsUQOVx6PU6rvWwPi13pW1g8CLoF0D3qaBJ+HxUq65ii6ySYgExrnGNjFa+HOlvXWxK7udAvHqWvtLFcroXRG5qC6JzEf/dFbQQeDnO/6uQeRuKd09dLpMZvdgFJF45UeZA5uXnz/+2dNlkYC9BjL1mres1B29oKQYCSKMJnhdwIxX41XxHAm+74eg4oPdfbKf+V0+dwJF3UOmY9fnVp9B0iZTwgly8XTgMHFLRKSENIjfJ5dyhxg78LRVSkD6+v4xo7mT6m2DkMjT5LS4ZCEpsCVOgcTY5+S9qee2yJyO4fDK6xD+tjJCChpAB3v16nvl/JiDwcRVkZvO7xhHv48jfDve0ixqg6kvrtVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/damon: inflated tried stats in damon_do_apply_schemes() on
  split failure
--

commit 2d405ecddea503227b3b4138fe63cbeb95dc50b9
Author: SJ Park <sj@kernel.org>

mm/damon/core: skip applying scheme if region split for quota fails

This commit changes damon_split_region_at() to return an error on memory
allocation failure and skips applying the DAMOS scheme in
damon_do_apply_schemes() when splitting a region to fit within the size
quota fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index f0da5cb2b88a0..9206737d05ae7 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -810,7 +810,8 @@ static void damon_do_apply_schemes(struct damon_ctx *=
c,
>  						DAMON_MIN_REGION);
>  				if (!sz)
>  					goto update_stat;
> -				damon_split_region_at(t, r, sz);
> +				if (damon_split_region_at(t, r, sz))
> +					goto update_stat;

[Severity: Low]
Does jumping to update_stat here inflate s->stat.nr_tried and
s->stat.sz_tried when damon_split_region_at() fails?

Unlike the !sz path right above, sz holds the non-zero remaining quota
when damon_split_region_at() is called, and update_stat unconditionally
accounts it:

mm/damon/core.c:damon_do_apply_schemes() {
	...
update_stat:
		s->stat.nr_tried++;
		s->stat.sz_tried +=3D sz;
	...
}

Because c->ops.apply_scheme() is skipped and quota->charged_sz is not
advanced, any subsequent matching regions in the same pass that also fail
to split will repeatedly add sz to s->stat.sz_tried.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107224800.3402=
50-1-sj@kernel.org?part=3D1

