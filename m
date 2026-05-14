Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72549CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D791A6B0088; Thu, 14 May 2026 10:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A1A6B0092; Thu, 14 May 2026 10:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19B76B00CA; Thu, 14 May 2026 10:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0C3A6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:26:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60E5C1602DB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:26:48 +0000 (UTC)
X-FDA: 84766251696.12.BA7EB31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B3406140009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:26:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OzH7RFkV;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778768806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJ1VU3u7di03wGfEIfW8WoKCmxtIY35/BkXkYzqTN90=;
	b=OPDm7H9egsofZBZvRCm1S9vNfEfnIRvSz3Cp2CCCHySjyLHtT+hEQ15Acrlul45W3bykBn
	fkfTymq9SztZ38HoAdGUextanXplIy6FLyY6FAInCCQERX6utGNUQoSyuobfseDFZ4K1a0
	ga+RXU9espuZzW4eTWlAfmIQL3VwVmc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OzH7RFkV;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778768806; a=rsa-sha256;
	cv=none;
	b=uPM5fs7KMhDkqhYsz/BydLbZxtpUaqvFfI9x3lxQ0Qv0FtgjluG/JCfEBZSKGsffSn2kna
	0iuEpXqvmR9WlClQ/180Uomg1xTfh/HTJCuIFxwZ/NpNuPsNonZuHSPL+/lZrgovzCMDnp
	h5pmbvU8DVaWurK/elQgtALIWfyhbY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20A5C60132;
	Thu, 14 May 2026 14:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA83C2BCB3;
	Thu, 14 May 2026 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778768805;
	bh=wdU4t01p2N+3SdPkNhh5voaN25uhvmS7W5q3TIzmMXs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OzH7RFkV4ENIRU8JkpGeh1mV+DeWUK1kl3bZCJKkKsAn5f1qWrv/eu7dZa0XVgpVe
	 zMXC2xohdUNvVkiYPQqYS94ctD9tBccYKWY5e+VZAnpvAD5chPqYhGDrWy1rj2tKhr
	 yIU+vFoxiZsFvnz3ViwQ0luGRECUp7ITZBWEyT/490u1PuELXXw4Rv16vQi5vV8lMK
	 ac+ZaQi7usmdVVWjiQ76KP9FmS2EABqnqTKkOM1L7QyPUxy8rIU8V+xnTOesUjmZSK
	 NKE2j023QSqTCD6SFDQW8fAii5F1uN9iMsTXMCVlzBgcCo7ZBx2pxeoNepPLPf/gyN
	 Y7XiLAycwJDXw==
Message-ID: <d015da7b-fe08-40e8-b14d-2e012cce3684@kernel.org>
Date: Thu, 14 May 2026 16:26:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: kmalloc_nolock() follow-ups, including kfree_rcu_nolock()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Levi Zim <i@kxxt.dev>, linux-mm@kvack.org, rcu@vger.kernel.org,
 bpf@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Amery Hung <ameryhung@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3>
 <9bea1536-534a-4a59-9b5f-92389fb05688@kxxt.dev>
 <6wvjo33urd5i4jvbf6rwp7kwe3ppn3ktgmjk663hq2jxax65gm@kxljf3hkqs5e>
 <1315d145-49ee-412f-ad91-0f6c61c4c2c9@kxxt.dev>
 <2dhbxmhg4l35gupk3wgwtufsf735rnk4czmcoyspzckvexie3z@nswohkoipx44>
 <be7a2a06-cd81-446c-9875-fafb198caf78@kernel.org>
 <3aza75jldxj4g3o4kqdif3hubsnzkv53jvj52y2crohfxzto74@ofzzq2wfc4tz>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <3aza75jldxj4g3o4kqdif3hubsnzkv53jvj52y2crohfxzto74@ofzzq2wfc4tz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B3406140009
X-Rspamd-Server: rspam06
X-Stat-Signature: 3t6tk5gqx3gbg4wrx6m3hfpwo4t583qk
X-HE-Tag: 1778768806-68022
X-HE-Meta: U2FsdGVkX19D7SRXi0IBORr3UA9HAwyJCjNB024TDLxXGuIuJOU27AiU22fyRIhs5PhgJl9WVpD8F99jYG5XnBspEDZenHfyhjKo3y6MbH2+fNUZkzr+upSrPEfKm8U7Kf6YFfh4ck8mEbIOjY+jKP9pBu3Ykqj4Sv3HmQsL2mRyNLQeqyNsJ4CcLKH2GreVijcQcE3Xcm4OLilXsx/S+qEy9wZ4rSDPmRHrIH0hEU3WsnG6qA2b+Tkihh1vD9hzT9krqA5fhD1m6cqNj5d4rTJGDN33PXm+3Py0cs02bF25Ldl90taqaK1vhsNtskWX5Ll2VYn+wltINSBI26vZ4BvM+aV8bArd6hmUWGit894ZmBInoCV+NxQF2WEWGBdk59P4LMLovEQenSr+mBZ26q7+MahVuX3QzLeSC2D5QGmaTl6/Xb9vAZUfWcxxe6luGPn1Auj0GxXbtl+HSuXHiwKqpLAUPcCK+tfW2+emY9ba7s4S2WVjxvp8YjI+ou2bAoFKPDCWiHCtciNAwvlR8FZb7EftfNHgECFPEsfJrL9wQuxLPvYl1OXuIB4rSHAEOsUkp4TenEZl2avGTbacY5pFSpKHq6rzVVwZcsKRtr16iCGQKbx54a80rhWI6vYfwRGbVBs388QN9NRkqMPuFFMfcPD+UrusLPv0sHj/fvYfcsYFrGvxYLO9CFQAz1KuTCda6YVTDW1Z4ZTcMn/uJsNabwBwIyEF47BJbbh5eIj6/DkDLn8lVY8wQYrRSndRFFkIcG2+MVFLiDWGSMrJ9Mw312a4CmYNoB1AJDFBNYR4bO6ALhP4USHAuWoGtBRJUv5eYLGPxN3ZF6sOs35N133W9U84bQwgrNqUq/eBbE64lzci77JqQQysQC3ko8GBAYuR5qZyaWWR84YACZfqfuQhkExbAX2UFBJ3/ya13kBU5dY8PCOGN19XutH/E4eyVgboBGJKdMBGMjr52nn
 oayyx5x4
 2f+K0exzrl1b3i/rW8lnn5yRHOW5dFaekze/fZFq1OagANFZ6vtVxhIyD5Zvo5YSVfF4A4qBcCs05dMPJ6TJU4IoTHDWMS7EU5TuqwRWSktqkVurpoei6/A8CgK1EHCej6OKPC6Rk1VHt7IXIxdvY/xzgt6+gIa9CPGw1A5HP38Pm/NH7lSdgK8cKUQsXQZoZN0sXWgKGmgqVczCVh3nf6Ztk0Xty2sXAKMFyQBcsQuj8Esg7pyt4jpnL8V7z5aPdK3bCdXBFk+0swLLIaYxtct832TZbKGN18RSLmKIqmnq1FEC8DeqddsbdFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 12:09, Harry Yoo (Oracle) wrote:
> On Thu, May 14, 2026 at 11:39:50AM +0200, Vlastimil Babka (SUSE) wrote:
>> There's still the fallback to the larger bucket, right?
>> That pretty much guarantees that if we fail due to a local lock in one
>> bucket (due to preempting its holder), a local lock in another bucket won't
>> be locked at the same time.
> 
> Right.
> 
>> However if local sheaves are exhausted, we might need a shared lock (barn,
>> list_lock, slab bit lock when no double cmpxchg) and that might be held by
>> another cpu in both buckets. But should be very rare.
> 
> I'm not sure what makes trylock failure on a list_lock rare?

That we can retry on different bucket. But maybe reality is different than
my hopes.

> When the local sheaves are exhausted, we're relying on either:
> 
> 1) another kmalloc or buddy user on that CPU (w/ allow_spin = true)
>    refills the local sheaves or PCP 
> 
> 2) trylock on list_lock or zone->lock succeeds
> 
> Without async refills unlike the BPF memory allocator.

Maybe we'll need those for sheaves at some point? Hope not.

