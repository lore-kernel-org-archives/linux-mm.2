Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 457FCCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBBC8E0005; Wed,  5 Nov 2025 18:57:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193C78E0003; Wed,  5 Nov 2025 18:57:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7E88E0005; Wed,  5 Nov 2025 18:57:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 004B98E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:57:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A40B11604E7
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:57:56 +0000 (UTC)
X-FDA: 84078218952.27.C361F00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F1B4080010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:57:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JmhHw+Tm;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762387075; a=rsa-sha256;
	cv=none;
	b=sgvHZjnUk26iVlBQMr+QF9qWETzQVJRU2RE9muF/dpeh1Q//Q9NzJTEn0gEwhNv4IF5Ue6
	TIzK4Y7LQ9ePxFkhSCeT3wRhi4cOrMjPrEcNon6mTaawdMK4GB0gUA0M+uitynPEfCE9el
	tNrlCJoPWCV2g81M+5mfEzPXM0J/Cm0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JmhHw+Tm;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762387075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+htYTo9KW5vmSLnBQ1+nT1mEEZoMYC6ZICdoQxeSOo=;
	b=D6G5cjnwbkgw3m1mWr/PdKdrt6Tv24RrctNEhAtZxkYCHD8LtGJdUcVxS/coIadYbH3gjU
	/OXUlHbdiX9xsjHmBVKxA+NWQ+ng1STLuRt+LJIAAOAYpQTMurFo1HC6IWJTl6dQ93dh5h
	CGZeF6ZYUmc/J+z5vaQPeAvWKlZlO6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B81160222;
	Wed,  5 Nov 2025 23:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68760C4CEF5;
	Wed,  5 Nov 2025 23:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762387073;
	bh=2Y3mQFTXDjBIqGVv4+kIDxm2f6jAQbNAnGy7he78Hts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JmhHw+TmiZ0zvjghAeXmox4sDcO/3+eSl2QW8OHdnfRmWJH6i/l+yb+rvx/TZKerN
	 CHU/H+43D/+hM0VrHf9mxhTR9KZ6oaQFsnaYQ8tYxHllE4XkNxaUSpL950mH1vf7NP
	 +dyRxJGUsHAKLbwgNVrgSfxL0baSDJuz6xov0xUw=
Date: Wed, 5 Nov 2025 15:57:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix folio split check for anon folios
 in swapcache.
Message-Id: <20251105155752.fabace52f503424c64517735@linux-foundation.org>
In-Reply-To: <20251105162910.752266-1-ziy@nvidia.com>
References: <20251105162910.752266-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F1B4080010
X-Rspamd-Server: rspam07
X-Stat-Signature: j9mk7iyh5sjw5kgms8stss7fjj43ta81
X-Rspam-User: 
X-HE-Tag: 1762387074-377840
X-HE-Meta: U2FsdGVkX1/hpmZ6UwQIHR98ZGSPtkVTeelN7blxBryLIGOYmdO/Johuql3P3u0dIO7fr9MmFIjAEh/L0XWdr6ZpUuEvtQLBSYbTbPccahlfOOCg1mT72NRsT/1L8UKZeKMNbRi+0nm0D5NE3n+etJOIUsOlzCO8O27bzNGbUssU0WvSLIToHQo7Ts2JfVX9xVj+UYtMYO7zz9wSkEEmfL2REreDZq7jN/bCStyZanz1QUUZKY2wWCtit0n95GS7/n0mwZj7fDzdcnb5iWCeQjXT8U3NPFeMBHbp5DiU2gkKO911cBP6rbSgskmR4sewD8v4ZJQyLRkytw5EN/D1S2kTM77tNaTb2hcs87kLf0m/bgO3Owj/OW5S5vXfBLqqnOZEnqNUkGT3D7VBumH+WxoJdi2dZ0BhGpA2JmyKBMO3cSX7vxnqpFRtnBf3/MPwnCf/1VEzc8M4/uMmzl5S8E6l3pcT0TgtTLRFfMoqpnGT/qlAUDgu9Rk0UpN9rbm1OEoIYpBkgCz9s40OyvkQI1c1xdbIAT9tLp0LUMf7nMQ8KSccOm/WISorrU3MLVBwfw3hcebrSGcHQEPeiiLMh3UIvTRCeYqT4WVijfplTSkmrcNdy6Q+GZhc3JaE4vikbWhZDrZE2c3w8yYqzzUTSYNjqCTyGcIFuXW2u8lnvT6oLRU4pqXBYqsFm3eL0qx/2R+GvqsrAg6fxoyPAp6JtwR7Ab+Lu8jDUlLOJgG0WsdMkhVml1J6mGvwjdoZ7IxH9jBoiZ4k0TEzJ+9bzNSD8oPoCJXwcMCxOHNEGQ4QXWNbiosnXeP2NijXfxi+66IjARuAnc8LNUI5IiU7YYLjYWP9MgOMxWbn3vu0JiqO2ulfR7gHcv/exzh6Fheg1optOI89Z1/pV1HbMoc7hw37fkDeqApy01pf3EvmiPN+SJWzRIr1GY/pPYDe6FCRFwfh+BwCMuZJ5jiyyMEcf1h
 ba5TEni9
 pCH1H4bKr9bYy5FWmKfvGFWGf5U/qFzht5gTPHYVrG1fNcopGeSqZM99uGidYqrO1xfXxPfhNBWx5BzlpEKa280vWh819xkUU39uhiOU/pSVwOL/ht5MCYsD3qGz/rRI2rRHVoqIurmujl6axRgXHcoxK3BvguFZ/JWxphbofxWdwD0YmsEFvgVrvo9T2tv0LzGSrgh9tc2L9mC4gnceltadA0/kdt+zDO4Twgo/Cw/uYo0gF26qlub1GWd+21+qHt4No8eExwZaCk5Qx5ov4JbzFAE/GjoSlWIbz6UHSy1WyhbcZTEPPFef1BvqhIjJY/QFtkOlQBS0kkxuf6C7DbYk0GaDq4hjv67Vf1h/mvSAoMTwaJxauhEiu4+tX1DD4TlH3624VpxqEYSGSvAzfYXFCmyVUEHafIfon
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  5 Nov 2025 11:29:10 -0500 Zi Yan <ziy@nvidia.com> wrote:

> Both uniform and non uniform split check missed the check to prevent
> splitting anon folios in swapcache to non-zero order. Fix the check.

Please describe the possible userspace-visible effects of the bug
especially when proposing a -stable backport.

> Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
> Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Closes: https://lore.kernel.org/all/dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org/

I was hopeful, but that's "from code inspection".

> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>


