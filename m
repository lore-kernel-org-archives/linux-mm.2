Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11CBCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6BA6B0177; Fri,  8 May 2026 11:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296936B0179; Fri,  8 May 2026 11:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3F56B017A; Fri,  8 May 2026 11:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 063016B0177
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:03:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2613A0184
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:03:48 +0000 (UTC)
X-FDA: 84744572136.01.72F6C23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1BE888001C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:03:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dWm7f/4Y";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778252627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xqi+t2S8bWuBI+lmZfv0DLDQPE9yHqQarZErY3arIQ=;
	b=1vtY6fLKgudanApXmAEYhTnE7uY2227KP0cYzRbk46LlDalhIRiRfGToxoQLpV6oaLXUK1
	UB7nLeTLDeNO7Lgn91icgFI3+dHzY/ULt7R9KP+ZWL2J3GFHuMDVUylWUfJ/fN++HybLk+
	G1/YTxMr1fT/wKSKJ1Qn8kBcaN1xldg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dWm7f/4Y";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778252627; a=rsa-sha256;
	cv=none;
	b=NZ8mxgFrP+UArGAJNYxVlypJYQMkhgPTgqJYQubjSuSPplqTvYxVqkfVeCfus7m3xrPOpC
	FPiY53XNwwlYTDWXTzChkOl+9dDviAajMW+8onT1jKdqjBiahNHlEbvw01ct07xuPdawlk
	HakbARtC94HUZRTuz2w7szVDPYUvQUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D8C261337;
	Fri,  8 May 2026 15:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3298EC2BCC9;
	Fri,  8 May 2026 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778252626;
	bh=/xqi+t2S8bWuBI+lmZfv0DLDQPE9yHqQarZErY3arIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dWm7f/4YhEkoV89JHb4HXlztE3GYoywZdD/GDe3nQLAz78X6KuzxPJU5qPGdXENvC
	 H3ytTh90wVwGo+quMZZO3CUvDuqgkXdQYYrcwdXXldL3HtJH9WcQxvynzbUEFP1jzo
	 OMrmXESr1ryU01xq0jgVnuypCHc9O8K7tAqTjnwVRyGJZNtOXaVScZvZZcIo1OfZrw
	 58zvy9CIegVaeCJQ8VVF/KmWrHMEwuDBaA5vftgSt2aKHeHXXOHJAFEPhEOjHH0Ei6
	 lmPYgxdMmqtiAQuIn1z1zwZQAecmsPK9bdGdQTLedQN4AARMPgjfludsMagPrQ6nLw
	 YNR1yySBEi5xQ==
Date: Fri, 8 May 2026 16:03:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chen Wandun <chenwandun1@gmail.com>, akpm@linux-foundation.org, 
	shuah@kernel.org, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/mm: add MADV_COLLAPSE sub-PMD range tests
Message-ID: <af37QMPPJPkOeMJM@lucifer>
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
 <20260507070558.3064142-3-chenwandun@lixiang.com>
 <bdc711fc-c625-4696-b6bc-28461c0c80f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdc711fc-c625-4696-b6bc-28461c0c80f2@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BE888001C
X-Stat-Signature: 61ar8pq9hdzki4r9nb55ye8xa7a3ssrw
X-HE-Tag: 1778252626-90753
X-HE-Meta: U2FsdGVkX1+1jmehG8ToUMqS4CF7n/sFOOAl6Vg3+rcxOQe2Tk93VZ3oey03o4E/j2wuro6aZ615JsT8lOrbpRoue5NVzf8MgfUJR1I5YVqxgXMBV1naTtnNyKQF8SkiqvCtOUGyRgjJnJssisnqJ9u6bRbewa46Z2tj1G5+rvmG32usQXNvYG42toiahLysFeqK50I6f64+C/L95WzdLt0hZxphohgTvd95xuYeSJR5eyezOlKuhN1c6K572qrnUOKICJc9SqXQsOSj40sbXAEdWCjr8NrvOizHaw+GA/ddJdZL5JHlZlum8OKV0E1an8wDFaCsPdiamFBxdT2tempvr0bRSyGO9rgZZ0dJVLhB4z30/4R0Gm6XRz9vmu0aFRXnNyWLpnXpWT4/AHs6dzb/EsPo4HAeaYW8a2E9I6+UirSXYMF3OF164SKtJi+ZyFB+Z9hWjHV6HoQ26dj/0quyYI/KPWAlp2/lLYZf9tBlZSj3c/qIQSBe185bvxQBuvMcFZeskipTHODdyoesKzSsAuXx15ddQCYW4X43a2ZyBYKyrDI84y95DzFzy3koCYr70JpoPFCjbMGPWsAIadgc6/Fxl9JhW6dBVuLjky5u2DEuqRT7Glrj+MSRETU2PFu3xvoKv25RGBZ02+b5eKijDxx7E1JbNjql8HYgYJaKH7UHmK90yUkuePrZo/anbt5BfPwzsLgqRQC4Ir/9l7a+Pj93J7+7IHfWcJKRitk6J0HgfnAZB7QhgtC4WppKMtSUEdoNIhZHfIOngi3ml/Qf9ESR+xifIxzyUjVP1t46uDEvBHP5ppVZCxHJk2PCs+ZfUsJNpJK4OjUeFf+0a3K26barafNXUnJbgl6EBZD61IQXrLO5s/bmlFHd1/dwjUd0mSfZsdaBeoXesQHdEAUxRqj++2O5fjBUXvG6GZphYj5f9H/qniSrAvsDscZmlWyW5R6sr3IIB8pmNS8
 rTg+kYnY
 CUNtvo+Jz6D6WzxHqozWbXZE0VXRfSBSobG/ECOKSMQWsz/PRus0UUEUD7FIfxlz5CaeFRoQ2dSSsaOOV04j+6oPVdFqu6jCOIBEnfpAoY9DUqw0M3w/zXp/RdWXQ4bSUILEiC5zUMANQDzwz7IX+u0UhHbOsN+e3hZw6u1fr7u5ycuTy5b06mRQCjwPx5twlokGSSLX1PuIS8dMqZfRKKxR/CaMSMEyG7y2vrkey2CblvIo1YRN+ZF7RMe9LXtnYTNNeJq+Bro1k/5sGJlJmn4wxv7Euhy1PhFtFl2sjv6Hgl1ZKJMtI5es2IMyIcb+4mcuq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 02:23:41PM +0200, David Hildenbrand (Arm) wrote:
> On 5/7/26 09:05, Chen Wandun wrote:
> > Add madv_collapse_range to verify the fix for the spurious -EINVAL
> > returned by madvise_collapse() when the madvised range contains no
> > complete PMD-aligned window.
>
> Do we really need 141 LOC of test to verify a "userspace is being stupid" scenario?
>
> Nothing was really broken, it's just a suboptimal return value, or what am I
> missing?

Agreed, drop this please.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

