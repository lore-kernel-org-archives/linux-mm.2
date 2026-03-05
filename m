Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D083DF30924
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140BA6B0088; Thu,  5 Mar 2026 04:37:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE6B6B0089; Thu,  5 Mar 2026 04:37:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C176B008A; Thu,  5 Mar 2026 04:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1F196B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:37:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5616B13BBA1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:37:47 +0000 (UTC)
X-FDA: 84511507374.27.0B96253
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD38014000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:37:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ClRqvNJG;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Af5E6FFleJVUdIdW603Ifd4KTAOlcs3DoZ91Qrtt1tw=;
	b=ybxnB/zyK0Wge3KCuE0HWUzZ1TycO+ILVq1MjKY4FTX6IkqDEEbpPHhIndOBmnQkOUsgsd
	RvFLB3F/dxLkXrDu8zqVnKY2UeliENe/zAQlsrouOBou3YWBkSHLSMzFd9WLWGgFvG9vwQ
	KNoKPJgg1SVYEqMX9fgG78vNZqwLnN8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ClRqvNJG;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703465; a=rsa-sha256;
	cv=none;
	b=MUnnJQJB4Nc39Jylwm/JnspYjvzbkoCRDVu5UHcmz6+00Q9r3+sShBKL1lFa0Qx5JNawsB
	reUwJhP8kCSUcmfVg+YL8aCpGeVgu+dsFK9syoXz4Tiuq7esGWRmhL+qotJ6kKNALi3olv
	5zm2Z/KONVR14IzSi+1fC1H9J73lOt0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E7C943530;
	Thu,  5 Mar 2026 09:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C169FC116C6;
	Thu,  5 Mar 2026 09:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772703464;
	bh=mgPM1mHFVly8+cjoFn6c0+f0uafjEJY9N6ljA5LcoQc=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=ClRqvNJG6Hr4Ddpk6VvMH/oe3EFyw1GkQg7Mq8waHTAJ22IN9J3nolDIHHKxjPXFX
	 9yFjoHocq8eHZ+KIV4+iR2Zq8aKW2bup+o60ATT/IbzTpFCz3LIxdStLKVOSqODbOJ
	 VUdHpKsYiKpQGXohn8UvvS1+N39y6LY0mP/JxWUgXY256c3hYQQm1DyX8KEcMiKBsV
	 sUeVVzvqYcXoWz5nBtfD6P7B5L1iS8HVR+2Xfrg63X7fUxPmV9ColRxgyB7guiHlPy
	 lJWRwwj4CrMBHpAj729EtYMkGulonRjAMLhosOBwAm74wch9ocsDNtbXTfoa8jjXFq
	 hFeAXYTyTHfKQ==
Message-ID: <94662f0a-62f7-4929-8ee7-e513a33f7b74@kernel.org>
Date: Thu, 5 Mar 2026 10:37:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add co-maintainer and reviewer for SLAB
 ALLOCATOR
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20260302101345.36713-2-vbabka@kernel.org>
 <aaVpbl7Om6aImsMo@hyeyoo> <aaVut1GXyhPBXQs3@hyeyoo>
In-Reply-To: <aaVut1GXyhPBXQs3@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BD38014000A
X-Rspamd-Server: rspam08
X-Stat-Signature: juk1gxeaocaew6zf1cg4akeqcap55nea
X-HE-Tag: 1772703465-656695
X-HE-Meta: U2FsdGVkX1+hnCUNd72EVK5DuEAREFT3TpSM9hMvAe2RKubZ5GFkqTHUBdo+FhWeOm81G/q7gQm8uQbvILIVgbXAyNGnLAnToF7SWw3ZgaPEIAS1ERtSVRnfmfEoCP4Glcto9ixOYMEJwP0l0QhOMS6uZXfszMqmoItZUxo9+E7ZOWW6tiInsENY5JDsl40F6XBfp+Mcsqagqlbwv3Kk4epKyoZ9Vxeb0gdFScNiJ8OFqISAL+UAA3eDr9AU1qSuv3jJEl2IYoWDkEidJIl+wRk4rssUC/n3qENsQTzV3XVGHEgJ27gSoULUwCMnp9RrizpGvqf6qRZyYyylo6o3GDVWrZmW+2CANPpO+n571Z5ftol/k8rXucbbf2VfksBwfoXGVfg3ebOQS1V7vYVEfMraI01i7X2GCDXWsieTmXC+m/ANTqW2BcCVnobcMntx4ydwV/oljWZDR4s4EYKAZeWAGwryIsBVQmN7b0diGODMFUOlR2Le3gaXt5YyP4MSZrVuqpiAyQMc+IicJjWpRzIg/hbwhA0itY2njRqzCI7/q6y+NYZNQE4nEGlYUiGRzTtC/PVJ5a+8rtQrUlJE5QHf/YeZgGeCFTUr7XgkkIcXwv6az2OX6F+G8I0V2uNwzKuUae1P6eFQrpn7drz3fKP2wbXR4HUtH9B/7++/XT4SK7W4LnvE6NEaVhyCMd505csyWXFQMGKxEOw1oUr3pWBQH2aE5r1kvzAlgKYKtlhRA4Do5SA3Drxhqz6gSVA7PPFE5aFGmkwf8yoSB5TujFBhE7ITf1PNwTR3U+W10qoxPSAb3j0YqgI3EEkwPP7PML8mV6TgKOPG2swCBJ3o8SVPHyTsOTyKkhCCm8nHBAcbiW6HcGR2tabUBNSzigejClU6CjGKUh1gsrwCrnTVQjxu+D5fehL6VstTorHrK1PBSTbRR4FKNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 12:04, Harry Yoo wrote:
> I'd also like to thank Vlastimil, who has given me kind and constructive
> feedback ever since I first started contributing to the kernel, five
> years ago.
> 
> Back in 2021, I was a curious computer science undergrad with little
> experience in kernel development, who decided to do something fun in the
> kernel and sent a few patches to the slab subsystem. The first few
> interactions with Vlastimil, who was generous with his feedback,
> motivated me to keep contributing to the kernel as a hobby.
> 
> Through the discussions and collaboration we've had, I feel I've grown
> into a better engineer. I'm glad that this growth has allowed me to
> give back to the community as a contributor and now as a maintainer.
> 
> And this is all thanks to you, Vlastimil 😉

Thanks a lot for your kind words :) But it's not "all thanks to me", really.
It was apparent from the beginning you'd be a great contributor :) Cheers!

