Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B72C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975266B00AE; Thu,  2 Jul 2026 20:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905E66B00AF; Thu,  2 Jul 2026 20:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753046B00B0; Thu,  2 Jul 2026 20:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33AE36B00AE
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1D7A8C46D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:10:45 +0000 (UTC)
X-FDA: 84944476050.01.9CAA511
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id DB37440007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:10:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbEBmt4Y;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783012243;
	b=RKO9V9jQS1GQZSk8pZqVI9Ma1iHHCG5uD3AtmLlOobiXsRx77SUsmBLP99gqz/pEXFjvEI
	s5ttiNfSFnfdca6tUPIBDj9rVtcyU8vOmotTaej/oon7VNI4Mv+O24IIxsXcDc1GaTKvlU
	W9bl0eHMj25EWC0GUH+HydDNHrHjflQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783012243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xorju1sGREsaS0alss0ZLCkm1trA4Ie63B/WdAe3Eec=;
	b=Ta8N5A6+1godtjVpsYoS9kYEzmt8u9Zx1SQJ1JumgDDHCV8k1H63aXwA0otjeygPEQtUVp
	XnzRA91iJNcK5K+/aQDWgvCndZAjfWz6HD/cB4zZ0u0njbVzc/ln4LAjT5qpgPjq29+5We
	T3URlIIhc/dwwgSpu9Ifqge6kp0UhCc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbEBmt4Y;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F750601CB;
	Thu,  2 Jul 2026 17:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B151F000E9;
	Thu,  2 Jul 2026 17:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783012243;
	bh=Xorju1sGREsaS0alss0ZLCkm1trA4Ie63B/WdAe3Eec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nbEBmt4YAKFWXgMJW4cVmb3lR0AmCP5iy63EPU/G3I4jRHRLXU/oXmSaykjCzPpVf
	 Cyjg4gJda4khxlrIM+cRX/cEnECQv0ioU5h1Cc/lhey0rP8E5HA0Y+X80Pe/4iSUSq
	 nRueQIyDONghCcYvKbbO+zVK2NSL6dpgzAV8TCxOX+cA7+JUsW5gPTz4UpuqG7rVnh
	 VJq2jx7Q1LTO5kmk6rtgZynhl1WDVWnilTUZxPaCKtRa6yAQ5p+BVYNYvgqxRRTI/o
	 egklfT9tlxccC5S+DQip15HWDRgB9om2m7y7UDNBmEiuimhBGQI39W6xLweJprKJWC
	 hEnTkVRb48Fbg==
Message-ID: <756f3fb7-5129-435f-a84e-a2af48e323ab@kernel.org>
Date: Thu, 2 Jul 2026 19:10:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
To: Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Usama Arif <usama.arif@linux.dev>,
 chrisl@kernel.org, kasong@tencent.com, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
 <akTJsCTKZ5hMBf5V@lucifer>
 <20260701164613.008aa13cb6187ec9597bf652@linux-foundation.org>
 <akY_L-yuaCXBOXb3@lucifer> <akZis7j6xSjl8K_D@kernel.org>
 <akaXQyFlZi82SePE@lucifer>
 <b110c415-c9bd-4e70-ba49-107e355477f6@sirena.org.uk>
 <akaawVcQ4D4XSOKs@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <akaawVcQ4D4XSOKs@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rwaeppdxf4wfq7dpwtqyysu7tz9yh4jt
X-Rspam-User: 
X-Rspamd-Queue-Id: DB37440007
X-Rspamd-Server: rspam05
X-HE-Tag: 1783012243-508302
X-HE-Meta: U2FsdGVkX19p+AwdPOuB65HlWEg4h7lpTdo4DiTLVr0CJwuF1T5xKGLXSHmWC9aZTUzLLT74vYfkhLFymNz+1pWjTiYcBI0Xk6QSHTEOuTZxPQcRh0jRv0AQeUZ0ipPQCwBn2cernOj39FuhXoUT6vbfGf9bYhX0pxw/aHPykFD6M2oTXBZcbHeBgOlIY0ZydYYbyjlo+KYDhoxvQ8/rU5FigBnpoxc1F94b1WPslfzDKivIV8Diy/Vk9X3AuIrqe99VTbnAQiSklWtUKDfkpPu0IAOGpZeszVRgvRYLvqQ0Y7GRkHt8ZUzUw/eB1iJr4aKHd5fPo96mV+2DUBbxBJfkgKctH0cDa63/JV6JbYtoDXz9jo3DrxuwDI0gw5lz5Mzn2tDHEg5VS6e902Im776v2LvIuWKsmi1UN9/TXc4HMzVc93ri2DzaTWZi3KClX6YfJ3Xs7ZMEV9C24aAtwRAAPog4Zg4XjL8NqmPZfV8a65ANH1gZmcnqBrT1eB7nyWY2jPuuLROl56Wm2fZ8ha33fUfigB5U+HdcMsQw9PfpF0Jd84fEjM8w9C0obM7vLQhxz7Jgz2T4rYRzfWEVO71RvyYtRpn0aQIiKUCtk/zkm6WmBKvQx347CqGiy4Rqss8r6MYrmDSsiI6VR3p2sbedomjNbwL+HfDLnTAAXHygUsfzp7LFxAXvvirWzLff1fegyAeMAnSZ1Aq1BkPM8ocJYeFWPAqDKgv0yD5XJoeg4kVh8ZFAE7W6VBFQpFMBgLrGXijNVRR6pQpJXwxAWK1C0dy1wPF+lPXGjR1fVV6P+JZnTnIvoykPwWWcMUMnclXiD+3feMEWoI+atsLr7iFHE4VOc7bimiGao9ktxNelFXAoHdBIi9QczhhAjAZJ9ftT75qpoVTT9boHVgA8LeLuO+CEuMC/Jbq9epU0d2kC2IWFsR6TYfLIfVtuRP9cCcdQYUxcov2wB391vuQ
 JRNXbMl6
 dbzNiu3SPB2tj21vL1JB6KyJxUhDjjMew0DfJUBKY61WlB2ts7w7R2l5C3TvXq+ZLRGG0zJGs+405UwA+Qgq1pw3F/q7VQ5+CcJ9Zv8cYBUw2GzL6PdubKoYGGjt0ziLcgJhWF6Nd+limpkjBqsuol6ofodeRNOPfZomJhJrfhOZVcNesg/DgSfpMCMREnlpEQDCmFos/97u/M66SlLT9ywr6gdoD7mlmnu776k99bm+PuPaRpO9SHxvWKUZDqube8/xc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 19:08, Lorenzo Stoakes wrote:
> On Thu, Jul 02, 2026 at 05:57:34PM +0100, Mark Brown wrote:
>> On Thu, Jul 02, 2026 at 05:53:48PM +0100, Lorenzo Stoakes wrote:
>>
>>
>>> Well we're very grateful for what coverage it has :) and that's nice to have it
>>> work with email like that also, makes life simpler.
>>
>>> Mark - are you running tests based on mm-new? I'm not sure where things stand on
>>> that?
>>
>> I currently test -next, mainline and stable plus my own stuff.
> 
> Ack thanks!
> 
> I guess in the long run then we can figure out a way to not necessarily even
> require mm-new at all, and instead let our CI try to handle as much as it can
> before -> linux-next :)
> 
> As that'd be the nicest way and help reduce confusion about branches for
> mm-next.

If we go the for-test route, we'd still have a branch where people/bots/tools
can do more elaborate tests when throwing stuff together. I still consider that
reasonable, but we'll have to see if we really need that.

-- 
Cheers,

David

