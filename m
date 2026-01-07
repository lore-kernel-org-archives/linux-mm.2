Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FDF8CFD64E
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 15:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22FD6B0088; Wed,  7 Jan 2026 10:11:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C36B6B0093; Wed,  7 Jan 2026 10:11:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6336B0095; Wed,  7 Jan 2026 10:11:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEE36B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:11:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E3BA1A03EC
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:11:07 +0000 (UTC)
X-FDA: 84305505774.12.861BD83
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3EAFE18000E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:11:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sXJ6gRet;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767798665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83t1pAOt8yOT3Zw4e2JFI2c6S70UZlJ3jNLvxb6zq4c=;
	b=6duYN3k8bh9WGM1qox5ojitm1Lafr6yQi6PASxNVMP2dme5V6wNqW9jrttUWREvFVgL7/R
	1U/qnC8TPTHmt4TS+lw1Cn40kd/PltAsVj1ossr/VVVGYZX2KaCWe5+Mxpl58PKaQjWtd2
	lZpYJ0jf5inHceOAZiOlNRBfytQ5XCQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sXJ6gRet;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767798665; a=rsa-sha256;
	cv=none;
	b=WliEvYmfP5L9kUyICo403bBG5pZ6w1SH/IsCuV8Z+S6DKu7zOicjpkwhcAAp1BkRW7Kg7Q
	VX/WeIq4hO+Bx6LHnTqCegzibxQDNF/F/ZwQ/UPcdX5JaDzhmde4xfYZqnYxkEUuIMe55o
	0vcf5ERhovHx7/SMd3QTSKBR4nywcCE=
Date: Wed, 7 Jan 2026 23:10:48 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767798663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=83t1pAOt8yOT3Zw4e2JFI2c6S70UZlJ3jNLvxb6zq4c=;
	b=sXJ6gRet9RU9qXuFlg7/YsB1x2vN3Qk523bP1YM83LTrURjdNu27SBlXo1s+UCsd+2E9ku
	2/BmCO254k3tIdvbBdqg/HcXC84b9HAzzeEu1IYYnaUY5xgxJgQ0yDLN+K6UO/ppiK7FNE
	/6Fv2d9baUT8DyYSW/2pNOIIxlPSmps=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] slub: clarify object field layout comments
Message-ID: <h3t66dtapxvm4fwm7rrappffipb67kofq24x3dlwjmrte5m4ef@awbg6bhc54je>
References: <20251229122415.192377-1-hao.li@linux.dev>
 <0a2474ae-013f-4c9d-b70e-5461367abe6f@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a2474ae-013f-4c9d-b70e-5461367abe6f@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: t99eopqwr63fhxig3ptgde4ugartcwtw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3EAFE18000E
X-HE-Tag: 1767798665-418209
X-HE-Meta: U2FsdGVkX19rho4Lb8q/UMS6J5tEc1LySgBzILiDkclep7UnxhCNEEZ7JaaRCtaIyeUwrhcLBqGo6LUngEODGso00880hvxvHKqoqqHdE5Xlj/4b/KnnZWjEdVc25L7KY9L0xTklKU1FDwKChvXtSzd3qGPGcy8IiJo/m7eJzrmMAj6bgGfGsM/IMGbyG+yKA23VRHsyB/koyngHOjRDvGHQiMKO92iH4RKFCMs7V+3BjhSp/qCCIN17xCTMJ8y6TWXBch5gSxNTsLlfUQBFPGsD8t+L0EC6Lcwd8Kx5VDQR/vEpbdlBSYtZ1v5beM/YiOJvdPhxEN6dkwen2nQ6A8MMRJEeqDng60ayJInWHffouu5DMkcCuoV3P2ScAJqADPQwYWQjv7IDvSWVWLaSbtpZ0z3oI4KhZ9gxE7yhpdEVuTvSnFYWD2Xne+MBqryt+/iHeqNKOnu+kvPzFc0jkuDI7A5kAQWT1QC+OP3avOdwAQd5CDW+EWTgj0BVvg0/ivSaK7c4zgjIxMonVAztKYHnQs/PRPAFS+lQtX+U/XnKSUoyYnYFRp5fGIr6Z7V4o5IBZ2ulaCJpViOJWugiYl6zruAlp4LuSj6FX5ghq52VzV6aUO83S6DJp60UOYlgb6dEqUENINX9s2Q2/k34EhKODuuU1lpBVXfmHqPCYxiGeSCr27Xf4lzHIzIRAdNUebPS0MhOs/Hj2sLDpzzC92EPaaj58b9SGeM2LXdfdu179Kt3W6hHY4pByCcW9mh88tY31rj/rMHUsnTDZfrHE3SyaKUmhuOTkaW5Kd6DOaS1aRNNxhnnhY4g9hFQdO6XVT1tS6sVc+ogkMEBWlZ8ha8lxrApxplToIAlrSZmUaBLlkwlsWCyHpq4+amHA6uKaWRqy98It75ytB2sVw3YfkfCpE3h04dXMYxhEeySr/7QwZC7a7qGpr4ymPLLzArZQnOl6dDkMvUwst2WaH9
 XNOPSBXt
 EqDIJT0UTMB2S8ZcQrMjUAXVn/nctBmDx+1iITm9Kh5nfCfm0NuQbFEfyAwksm0F9FrDe+30BwNr2KdMoCgZgmEK0hRY1kZaCnQEEw+Y7T9sQr+uzaT/g06qCkQb4KhBU8qpo1f2Nuz8Om6S57DoKCsr7ZDMno3UlO8XI68DOVTsy7NAjLfs5vtIxf47JMoiOTa82dng7THpLHXdMjuRq5YeBav5xPL8I6a1lf6SaabRmLveA6SbY8szOf+K39AqhcE80
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 11:35:49AM +0100, Vlastimil Babka wrote:
> On 12/29/25 13:24, Hao Li wrote:
> > The comments above check_pad_bytes() document the field layout of a
> > single object. Rewrite them to improve clarity and precision.
> > 
> > Also update an outdated comment in calculate_sizes().
> > 
> > Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> > Acked-by: Harry Yoo <harry.yoo@oracle.com>
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> 
> Thanks, that's a great improvement. Adding to slab/for-next.
> Wonder if some ASCII art diagram would be also feasible to add, if you feel
> like trying :)

Great idea - I’d be happy to give it a try.

-- 
Thanks,
Hao

> 

