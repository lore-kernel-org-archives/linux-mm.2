Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED341061B1C
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223686B008C; Mon, 30 Mar 2026 15:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4C46B0095; Mon, 30 Mar 2026 15:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA6B6B0096; Mon, 30 Mar 2026 15:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 013496B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:12:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98E811A0885
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:12:52 +0000 (UTC)
X-FDA: 84603676584.25.02C4F49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E401B2000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:12:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C3AQJAlv;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C3AQJAlv;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774897971; a=rsa-sha256;
	cv=none;
	b=fmTLbIteyFgKtWx9WlhAsNiIB2okAcZCp9vZerYX254kMnEAWv/1k6AO+Zp+54bxxAiF12
	t+k6ikfWHfwCiUL1by/n0gWHP2TmrfEDr4+7hFVvXh00cyKb3Uh+nLFFJBuAqJRSMCScTi
	GSzOoaByjNtzcZRewKcLpSM/YG2juP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774897971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUkWXz6u4osFE3xlmL0ZLRlwwSvSv3nrAwI8WBRr9ag=;
	b=A/cwzn3M+E0ukiQ6aRcyLjW9y4VehZlTavZRJ3yxq6dL/ecN5cNQqwOnAVr88S4mKFGgt3
	2rcEjtzNaFfyYMCpLBLn+AEkFatGIvXmmVk3yV/EHk4RCxdEGXIP996QHNzuuSihDG9d12
	eswy6GBvgMDZUTpIQIoamssFspPOEIg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5618E60120;
	Mon, 30 Mar 2026 19:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2987C4CEF7;
	Mon, 30 Mar 2026 19:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774897970;
	bh=3rXlGsF8ymrugLH80xcx3Ct8PSSNv7QSvq+RmpflxFo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C3AQJAlvn/BqlYsA9TFsGxxK/t56KYXVQP2uARTwNNQ7W+adbja6i7WVJo1MEm2rU
	 m4/K3JUqYI6qBwO7+PZNXo9bDsMfpwMhax0uo8m+g5eadQRz+nQgQDNIm18QP2qfe/
	 F9vg6mvXIx4Dxdsiiy2ovhaPG/Tt0xeU3d0z7smQ=
Date: Mon, 30 Mar 2026 12:12:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the
 pool.
Message-Id: <20260330121249.fc2cce8d2fb78ff2c68d3645@linux-foundation.org>
In-Reply-To: <CACpmpodFvA_DMmXBmgZfE4A=VnH3+0rVfmAr2qKP8o738qafbQ@mail.gmail.com>
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
	<20260317014802.27591-3-kanchanapsridhar2026@gmail.com>
	<20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
	<CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
	<CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
	<20260330115141.997e29f96223da1e22c0f375@linux-foundation.org>
	<CAO9r8zNRcSBdBthR8Mk929pT2z_Ew_vc8_nLJns-2FygSX630w@mail.gmail.com>
	<CACpmpodFvA_DMmXBmgZfE4A=VnH3+0rVfmAr2qKP8o738qafbQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E401B2000F
X-Stat-Signature: hwaadtncs353opsf6jmp3k6nuu7tbo46
X-Rspam-User: 
X-HE-Tag: 1774897970-678099
X-HE-Meta: U2FsdGVkX1/ODBGgiSmAu30VfXM5cQAro88uWkkzEiXFa1fYXxYpCWMmB8fXjV75zbtzTiOxdbL/T8/ogtAzzCrXdGxTRZSP+iQt6Je5ATI6WUBOg/pi/6MHeBLOoEwVEBd58n8DXMikmzGUnDkrrIPfP42bhLFOhmR2uq+dDUGHgFdQ1LCxL15p/lq8CpuVEI3uweVCnpC8C+dfyyyvZ4DbcqQKa+fO5Y1uz058ElRiCV3ZK2oobPvkbMNvHoHWMSroR/71kvEgSqas7UzTfGU7GvrnV/42HM6WYQ/IO6X+Qzr51cuZcuj2aoAsUVQPhwrsbQCfeydbRubnvMDiaul5bxv5SyQwlxGLKjzc2vI5i5xb7W9k1Rj2UYbbvmEo1wehbB3Je/txsglQ2/pFQIzTdgc0IQP0bAr9544hZFuqsve4Lv9u+T8m5pouAqTLMxnFkDJq7Vw9SYeaUlf3Jno6xSJtKARefnFrPP91iW5DsNjjmljXiQ1mIbYhtjjmUIhc6EwyQVozzOCs2UdaPcFPvxhg21osZ5mHKAxRqCbuSqUFc/gma92B2qaAURM2708LhYtrwZ/JEGjZmz1ePWZI/PRfEmP9ztAs1MQVHIyQd3qb1skU+I2As89+TqYmYF0hcKvSnaIno0y/QG/yjSsW/z40Dc+zLTSfYyP7f49Z9MN6v/V5+3VXDKdPGdaOqMb6/6S3LLI/UvftvuKh2Ein/Ug0w5osoFBg0+ySPrw6vUMeOs552+D6YA9g39dXZdvnu+PUdvJHPC7FvxMms89Foey8u2oAmKG28GlmbyjP20ncrHD19KXxpAmS3omM7isnQErrlFwJq2PYLK/tTLjbTlMHX3MAhqwQ25sPd5U5Q60l35GRKPB4PJs8b1aTtu42lozBNWz5P87nXVBS++4WLlck9T5HeBjLYARHGTtxV1qo0mxlwX7qCVTRqu1sP8/Xj36joeZbxMUNWEa
 v7Bo83mn
 0//w/CfFJZPTnNN2mlE2OszArsTUAXSShG8D68NjKqZ+XvtTbxpcWco3jHcXbgbqNaQ7oX7+Vz89n7YOBLmo1oQ5YMhrlqIvS16fJea5I1yz0YhRI1dhWuq9sdv+SBfb1EbjAmS3+ub6grdLxDOsHofFEPxlVoaeh08uYyih8dLaMzlrTbs4R/3hQtf/k6k9fAjCx8qO7P1q3Xk+yhbqag6vX9aQx7tL5QGgMQRtg5vaetehgowHdAx3eNll9J8NZRp1EUHi0jUbLvzML9HgSmSS5uk+m4n+mcrEW3hlSeUHOaydYMeL6Mlc/j41VYTfA4zlpRdrajxHYVrtfwbA14Oiv8GwwwWCw+/kdTzCXsT6sidDyur8DFzq7dw6E9gwpb3Y3LW0KzJUX2pRK2tceINufKZfLC0Ix8jZZl+59h0CbTfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 11:59:04 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:

> On Mon, Mar 30, 2026 at 11:52 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Mon, Mar 30, 2026 at 11:51 AM Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > > On Mon, 30 Mar 2026 11:32:07 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
> > >
> > > > The patch looks good to me, feel free to add:
> > > >
> > > > Acked-by: Yosry Ahmed <yosry@kernel.org>
> > >
> > > Thanks.
> > >
> > > > That being said, it might be a good idea to resend the patches (new
> > > > version for rebase + Ack?) to get Sashiko to take a look,
> > >
> > > Yes please.
> > >
> > > > hopefully it will be able to apply/review the patches this time.
> > >
> > > I expect so, but I don't understand why Sashiko is having trouble with
> > > this.
> >
> > I think it was a transient failure.
> 
> Thanks Yosry and Andrew! Although, when I get the latest mm-unstable,
> it already has the v2 patches :)
> Should I still send a v3, with just the Acked-by added to patch 2?

Yes please.  Just to retry the Sashiko scan.

