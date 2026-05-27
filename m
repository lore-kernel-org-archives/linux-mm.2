Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10721CD6E43
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364836B008C; Wed, 27 May 2026 05:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315F56B0092; Wed, 27 May 2026 05:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2035B6B0093; Wed, 27 May 2026 05:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA2D6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:38:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9426816136A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:38:29 +0000 (UTC)
X-FDA: 84812699538.24.43DBAF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA5BC40008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:38:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fr7UQCUm;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779874707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EPgL4FAe9Q1HpUW4tud1I2dVamBDFhNI1A3ygm0Wgw=;
	b=RhskurME9Y4GYhMR8ioThRxNYJLBRzIro5muR/wheE0a+YHW6KXpR+to8LUKVS73KsNA9w
	fldpzO0wmy2npkho/ufLBPPRr5sFzqGzgZfEpZpXRm4mxMnAkXxlMxqvOG1mtyfRyasQfb
	D7e/9Wp1FHYxd0kMzR99ChDBDeGJabA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fr7UQCUm;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779874707; a=rsa-sha256;
	cv=none;
	b=HJui085mq+a9nOsccZEaqDwLwt7IrCcNwwkRT053Gacuu2Ltldd5rfXxwsIWninUIsHkvN
	6rnvDE47KUoWKQCjmXYzwmgVC9JpnA76qF/RtoB2NpkDRlehSY4AmqjGtsv8rN3r1rTlUU
	KafFrVgMUmcSnknhuITVT5zCz9tjMx0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81CC94406B;
	Wed, 27 May 2026 09:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8211F000E9;
	Wed, 27 May 2026 09:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779874706;
	bh=5EPgL4FAe9Q1HpUW4tud1I2dVamBDFhNI1A3ygm0Wgw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fr7UQCUm5cprOrQGU5TbDClX+R7dEqRJjoGjS0k5gjydzKuG1ACoNftI/UA+F9ZYV
	 kUAjPhUGoVpcUj8H4cLZ00oBUZK5oxIBiyuxLccRqsuZPv8L6vnbNO6e5AbFUsmP9O
	 hRwUh+bWssxFUwT9RMOkWFh8U0sQ6pY/o6w/hkJRkSaESagT8LptRA8x3Y6kR6O2Z/
	 BryXQg098y6OJ9ZI3SMWHBpn8H0MU7+hO95viQNGdondhORmhsxy0aY1XgSfmfWjVo
	 LgyOBf7KaZ/RLeZLaociiRSH30fkZbJGbXxZVcFCRxRM/JvjIbfEYFdTcCXGWYVypC
	 Mhd7NZs0NEfyQ==
Message-ID: <f7f35169-f77d-4678-8797-a2ad00d89e6c@kernel.org>
Date: Wed, 27 May 2026 11:38:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20260527070239.2252948-1-hch@lst.de>
 <20260527070239.2252948-2-hch@lst.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260527070239.2252948-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA5BC40008
X-Stat-Signature: m8eszhe51r8j1u14c86st8e97zm6osar
X-HE-Tag: 1779874707-693463
X-HE-Meta: U2FsdGVkX18Bz6OirpyHYEEFDCTBd9clAOBUSMudiZM5hQMLDeBqQpzq67QfPpKS/zr8GsW92rsgipUev/MPEMTbmA+ew7uDPlnGutDj7KbYm0E899E7KevjKWTO9j1lLBu7P6igNgJZ4lAyXJcbaBc0yxuhP8Pcbw1WqA55tPcV+B8CvkOdU/23GCKnNRgROLHIwMnHwWehckoyc7gZrj5/Xn13oxJdK4VQ+wg1y9qKR9YVSoD/K9wJsWfATQ4Vj6/0Ax0g+VP+Y4ltFpHe6K8CWCX62g9gwfpQwE4WojyOW8VCICq+6tujRMklZF4lL3j4DJ/uRuPXyPdLSn1qipOdsMf9TwGBDqDks+VSntcD87eoT5jlBb7nuRszZdO23D82jwOoh3qoV4iDy3rwfRj8l45ghY24E0gX/433E+TNXkuX0gbM5LAcwA2tsfLKJ6IviGdyOXiFynwVSJO38WGX8vpRD/wNzhUTlXradttY5WrnPH+DVRKcRx3Wl7QFqozxWyq9Oj22iQ2XuODL2GBEi80bst5wOluPKjdWh6AIRHLL90qb4RNXQL/YVk20mmpAex9mLhNXDym895p6PAMWSsAJi5+s4mOF1idrJkrYs5dU5m91KxgG/6MtUaeFT0UKqjJ+bSOcgEQmCj5KDbrlEITBRHX4jgNiJLZB1vuurvw1fJx4+1mTXHeC8MMA2SahIR6/TcTBPrhjdS5ncmqOH84hBlCj8RjBNWzIohpxJcducLJc8HWMxvlef3nHdtPMevlUjAW7YYwNSIIpie21+Wez9dMMG+2eAUFy57jUpOI8OyxhjpRD2Ez4wiKNlvJH4aSvsQiTbcEemY1OKbHqI4fIuL8aLqoQMGkOdStLK5TplBXmVsbNa1kry3EW7VGDVbRz2vRxklFryzO0eHlIv0t8AVHt1bekwRKrZFjk1Q7Xa3VXp6tHxLKXZFHIoS+fTZARhbM79ztwM6N
 V3NRSiNo
 KtruuC3VPNexhS95VMq65ouuTBW6QXbRjmyr7tgSG0u4voQY9NA/8XLap53rxDSJ3sXSpx5QqOOyGkluQACbhzBOsOAyIX9EFz6JPq7ueNz0APyINJ373R4sBIuYd9SdiY8jgr/vwC3Zq8wXGbO/xl7r+N7AX0F17FYzjRddBsseua3SsctjgCRLKQkXp/96APW3uqAqXZCqquqhWXaDrn71z+WwqTyTyeGBb/3u9l7Ll+FTeJESooPN2WEr1TAQSTpDyIwWvi6ZZrMmiqPHNJpcSztHcXxTqfvxU54CThGKHISNDJk5nUJCx26HhvncZanjrxXQEKL12EvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 09:02, Christoph Hellwig wrote:
> The kmem_cache_alloc_bulk return value is weird.  It returns the number
> of allocated objects, but that must always be 0 or the requested number
> based on the implementations and the handling in the callers, but that
> assumption is not actually documented anywhere, which confuses automated
> review tools.
> 
> Fix this by returning a bool if the allocation succeeded and adding a
> kerneldoc comment explaining the API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Would 0 / -ENOMEM be more like what people would expect? I guess both that
and bool are better than the current API.


