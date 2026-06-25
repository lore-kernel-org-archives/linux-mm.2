Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A030ACDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1606B008A; Wed, 24 Jun 2026 21:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66A36B0093; Wed, 24 Jun 2026 21:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1396B008A; Wed, 24 Jun 2026 21:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC476B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:42:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFF9A4053B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:42:16 +0000 (UTC)
X-FDA: 84916734672.06.5A7AE3A
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 258D9120007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:42:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=RsI3p3W9;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf29.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782351735;
	b=UbH0Y7opp0Z2Y3oR0nwWnUmVkD++PGVt1C4xLOgXyUitndRaHC2UIKOJA1/moj2CeYdY6u
	QYHJe91qXytbjtA20X6Ja4Op+B0Ybh+Jy8VL1fIqkWfTVbZResZouLx2LQ6lGFFbSLb9sG
	G2JAZcQES8gMw4ErKe/QmCXD5yvATCg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782351735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9YZdvvngxcUtp6hqFhBEeGgAlTFhxNj0jj5VAyk9NE=;
	b=jUdX2XicXevWbfT4xNQDkSvQgeVfOB/ana0yaVjf0+u2BffRSuD/RBwavyXDXzroyb8cQ2
	m42+EGGqGl4vwnge8trsWIKYLCXImgVeHffR7tVkHfMj/4hKzCMyQ4Q515O1pnY2zlSCU4
	0mtm2W3TYxTrYxl52jmIxr9mHsEaRBk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=RsI3p3W9;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf29.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1152)
	id 94BBD20B7166; Wed, 24 Jun 2026 18:42:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 94BBD20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1782351729;
	bh=R9YZdvvngxcUtp6hqFhBEeGgAlTFhxNj0jj5VAyk9NE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RsI3p3W9mw9+E4CmCmsQxQXq2R4z9L0WJxqdFRti7Hs+ajZex5t6lCfkSE/OIEVAI
	 1OIVFnLVrMUKurbFgAdWtLYMmuGsrmJYjWnJBdAskBjJEJE/wQtr15fw8k3wUtVgRW
	 3OpFhz4evVHJYTCo84xP6P/B7yj6UwQCnNSFVYZg=
Date: Wed, 24 Jun 2026 18:42:09 -0700
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org,
	akpm@linux-foundation.org, kees@kernel.org, tony.luck@intel.com,
	gpiccoli@igalia.com, bp@alien8.de, rdunlap@infradead.org,
	peterz@infradead.org, feng.tang@linux.alibaba.com,
	dapeng1.mi@linux.intel.com, elver@google.com,
	enelsonmoore@gmail.com, kuba@kernel.org, lirongqing@baidu.com,
	ebiggers@kernel.org
Subject: Re: [RFC PATCH] reserve_mem: add support for static memory
Message-ID: <ajyHcT2CnKkADfWP@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260618224018.117978-1-shyamsaini@linux.microsoft.com>
 <2vxzpl1hmmgn.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzpl1hmmgn.fsf@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 258D9120007
X-Rspam-User: 
X-Stat-Signature: 63inx6qrg89jymqt9j9dqwksrt6uf91x
X-HE-Tag: 1782351734-580789
X-HE-Meta: U2FsdGVkX19UYGZ3/+D4OmmXnzrMV5LSxLMZBoFXSrYfcLN8NPNZtvc1q6Jx5V/aBBUa0MP4BhalWmFBl2YCEUEsJ1rMVBGoH6qkgOMbyM+hmvHaMsXxpV92kcd1bZvmXli31AJszpPTKOMxNpHlVG4gH+4ILDjlKfbtyuyl41Bhgivwg6Zrl3DYSRbIvxvvaNCdFIKdt/8Ei017IKgIqy4yocIF/D3u1wzARSNPdXFNx8+Uim9qhPcI81ZS8LcdHXexBLyMFkNLVJSyFbY7eZUZZu4U/WS8gyEB7/mUAQA7g4d1C9pToAfhfvEsiR64/EvVd0fvhBDEgWQTX52765R/hl1tRqLNg7xyaNYa+n8te/ElXH/l706zLvdjLS/WQFC63sLH/g5stVnXz2KaDl2VXfyT3RHzzW9h1IpL+ZEEFFXrIRiCtZQC6pM25lYTnlsahN7CbMun6+UtljMvasPibwij4ZZ/3pcIO1XLWnYS9ElS+jvUXj+MPX03IhbttLIHBvnTxY2ZKXqjupgcXVGZCI6lWGH2SveQHyOzCg9wtNtNodsgX3ZxyjdUDMOcFOTqq14uFwPQDOoSvdmFukT6ZojNS2orsKsLiGzuBs9ZyRgf3g6Bg3q8ivI7B4Kix8QEwyXfv7qq7qSxbzw4ekyNiW3iqglNzRNjaxtI5ZTF7vZiVhAGcyX/WBFAKCkn3jF+EKG/vhQrhEJN0vuYHDIbyuUYPuOzx2IHod2AcAx/q3UHzuFPKRAVFUkOUUr6rJikqSF/VaTb8pckewGR+abGT632qAIWefdDT+DAu+CcADTmjAshA2Xve0b6jpY2260WEMInGMUeGvVrf5Phb1TD57ZZLCzqd0AwH2KtVVY7zdWNEP+6eQO0U9e5qyJ7gr1zfEURUnB0JPjUCzaeKAOzgzOCHDlhc2qT/gqpaRnbT6Qg1NOzynb2L3nsgNnLgrmRFO5dUwaYLy4kH9k
 zmNJzu0/
 JU8YNtI2C3ddKpIzWMlEVXEvLjXynQlIxswmWcO1czL0VdjNfymIMWspslMXVWMw+n3vhj9ULgb/Lv4XqxqPfBMzCHeyt3HkPTEzGsfyCrEBt514tLObSwpaaNqzoGuBU2p/2i3XDC2ZD2pp7Q5/sWYqyGkP0kn/30t6COZGV3ArI934m1E96lWhr6muT12KaHB2uipe/BiD0ZD2QTv0xQ1AmQp8Vvr3LaErWZ/C/tHDGlmMmCjRWd7tVUFKRDaFe5sQQn8Z7wJvr8O+v/U61AFU1M7WXzxXnkaxGTZdFsIOLRjfZSxLem34r9Ua5Enc2cKTnOdT45JyQO0MSIKS5wwlEcKeVUR0aysG6gNlbQ4XoVYhd6nfDalhxaxW26bagahPA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 23 Jun 2026 15:10, Pratyush Yadav wrote:
> On Thu, Jun 18 2026, Shyam Saini wrote:
> 
> > reserve_mem relies on dynamic memory allocation, this limits the
> > usecase where memory and its address is required to be preserved
> > across the boots. Eg: ramoops memory reservation on ACPI platforms
> >
> > So add support to pass a pre-determined static address and reserve
> > memory at this specified address. This enables use case like ramoops
> > on ACPI platforms to reliably access ramoops region across the boots.
> 
> Doesn't memmap= do exactly this? How is this different?

yes, but memmap is not available for ARM platforms
There was an unsuccessful [1]attempt to add memmap support for ARM

> I always thought the point of reserve_mem was that you _don't_ have to
> provide an explicit address, one is chosen for your machine
> automatically.

ok, but I am not sure if that was the only intent. 
> >
> > Also skip parsing of "align" parameter when static address is passed.
> >
> > Example syntax for static address
> >  reserve_mem=4M@0x1E0000000:oops ramoops.mem_name=oops
> >
> > Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

By the way, RFC v2 for this change is already posted [2] here

Thanks,
Shyam


[1] https://lkml.kernel.org/lkml/20201118063314.22940-1-song.bao.hua@hisilicon.com/T/ 
[2] https://lore.kernel.org/lkml/20260619062331.348789-1-shyamsaini@linux.microsoft.com/

