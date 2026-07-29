Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374EFC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 07:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0FB6B008C; Wed, 29 Jul 2026 03:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062C66B0092; Wed, 29 Jul 2026 03:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E948F6B0093; Wed, 29 Jul 2026 03:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B47A86B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:27:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 314C51C0C98
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:27:50 +0000 (UTC)
X-FDA: 85040984700.16.90AFF52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 84EF140002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:27:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfCFMt3a;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785310068;
	b=Hx2GoQtqXG6j7axEPq0o9xu0PK/beWxjELx6IsZVy07hqxB13JnU7CLQlzJ+IJlmdaYlPU
	Z0b7djx5VaLbppDeCfcmM0zX+ceeTMan4LadQmIfcYhfKWwvpLPSLire5KcOxIsxwxgFEl
	/2SdCijC4eMpLSx6vc/8ebOTNxBjKwc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfCFMt3a;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785310068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMLFXkadCwxEfw0rBQugjdfmJxtKD7ElRGvTcKQtf5o=;
	b=V2IwRF13BveDMKt4K/OdJEsZkkxSm7u3wHai1JoQCkBtxBVccvdvH6+5kFwVvLXhNovMn+
	7VsRsXp+jcFGoiWvHCqpKflscO5XD0OAiIoovCgDubvAAziIavYj2atWHXhF2PJ+odb7Oi
	jdr7ZevD0EFirnM0nt/Q4KKqDH6IEuA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA905600B1;
	Wed, 29 Jul 2026 07:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A781F000E9;
	Wed, 29 Jul 2026 07:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785310067;
	bh=WMLFXkadCwxEfw0rBQugjdfmJxtKD7ElRGvTcKQtf5o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cfCFMt3arl6Ze9Vm/iPJm7z5GuGCk0+cqQ2IF2p7mT/J2DNQm//mSQT6DxLIMw0/2
	 yopPIXnFd3UBK1w61IWeTvclsAdfm9/Jc/MvdU3tPbOIeKS1EUP998PSl55uCbbphh
	 tI1fdHzNmynpx6/kpvvZ3qZa0s0oU9S3j7Op0grWtnrISR/n7tV+/gG7bRf+Lav4BO
	 MIV5oVO3xZPoqTYb6jbgrLPs/9OA2ppCQz8IZ6sziXkcXnVcwT5fhNmcGRs/WNeH72
	 B1OkDrQ3y3VyovD6O8bWZtB2f9WCCvz7/r1rh/2s6j+CoQActkfdp8ubqPsUf6rwZ/
	 /1pX1TR8rG7aA==
Message-ID: <6a7a1079-891e-4ccf-b7c8-8a050bc2ecaf@kernel.org>
Date: Wed, 29 Jul 2026 09:27:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Barry Song <baohua@kernel.org>
Cc: Will Deacon <will@kernel.org>, Wen Jiang <jiangwenxiaomi@gmail.com>,
 akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 urezki@gmail.com, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-2-jiangwen6@xiaomi.com>
 <amiabgyHSz3ZYY5k@willie-the-truck>
 <CAGsJ_4zgFk1iaQWisYMOR4iFxonwDskRt3Gte0cEts1q9hxibA@mail.gmail.com>
 <3e5d7992-2f5c-4adb-a027-f8d266da40d1@kernel.org>
 <CAGsJ_4x3PO_fXCNch_Ca2hKn7BjgvLzzr+Sdg+devRUCjgfa7g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4x3PO_fXCNch_Ca2hKn7BjgvLzzr+Sdg+devRUCjgfa7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84EF140002
X-Stat-Signature: 93gr8e5ozuts4q9crkxggoxfhyky9tjk
X-Rspam-User: 
X-HE-Tag: 1785310068-711927
X-HE-Meta: U2FsdGVkX1/d/T1LNKyec8yV2AvGBrHpO4sP+nmtRQxs18brpHdWQKWbm9Fp4zszrwCAbQa/6UuQ0EcYzfqIEld/n2mQ5ulWlFCI4KhIXHmmnJQXJwMHe9UcJSiID3IU60JZg9omG3S4WSWJhbVTR/4SkbFFZvJa+GiXnjLTpoQUbDp3/to/0PuvTTaqJQ6kX8nPQUH4xJfa44rT8m9VuRHu6gX797a5N7CxZ8+a4mtCR+UPU1ojJS80v67ZIP8ZxBfuPISRqS3Bsnhf+qr4iRj2sHTfil9YDIb8WbUVf4OItARKaohY+JLkJAHqpEyhPyhSoFsheEEb7m06ZqML6S0qyd1GzA46QOLQToFv5r4b9UCt2urPOtHokEd9GywGrRqDDbG6D4JvXhF16e+221rHUxdkDuztuPvTP9y/cbyJw9iorZ1EkTK5lvLmSHJtH/vVJAaU690uDTQi0ihK9GTgaZjKLQ2anMCoAAynF2+nTJMXSXC0yTSloHBrKX26eA4eFe+r3toQQiOu2F6z8+b0nVHCvCaQd2ip09rU4k7P0KsTTLmDHcSt+zz4Lg4Qkmx/S7NGTaKu7zjzsITxic2VCXJqpm1GtjyyYjW95Ua1e1cdVdCiXE1APc1oMhY3KkhyGZx6wHUht+la78qnT7FUAPn/7M1yeTrznH/Ri5ESfdn7xwjO9CwuNo2LqnyzUU3XhSouinIsMWJX9+EuREJusR1sIcloI+o/KG9JZv0blQFQO/w9HQX4j/LcwPKC+n6XPzlx2WFgs9Od2muGKHjyhF92upRgG8bWvYMQwF9Z9NDXPMesTT7F8QXgdhcEohC9dGbiIVGK+51xWm1HRM2RWLs7TuZhln4GIQE9Lkb/yoGNuUGFBqTTjPaVUuvwPt5bSvyLCvKXlB2j7coQ0msgfAOBwK9kF9o/XeVtiRB+XyTlDSCoinB4k+VLoZqcJbfbA/kIOwaJeqHRjU/
 WU1PUMH9
 8OqsSqm438JDYRpWIjYcy9hn13GRl2GuCZ6EB/cgJAXDPQHJ4vN1bjVGylCupRoiRb13XafVjkd4s3UV61rkIx+GgMMjLHv89LscAU2g0MzL6rUO/9voyUfYffUBzYeo5+DXDxUbtJXTykPPCG8PqDr6ywGyI72V9dCuBtXHl21HKj4EPmh5TpS7X4JwYlOU5uHMOaiHZSnpv3/SbJVj5RCj3eB9Pi3RTspM6bwi8TWXVfoBIBNwVHCJ5a/L/u5ztIR94xymGBMXcKf8di+5ma17QHL0Pg8gJ0DE3KFg3FAS4w9G1v/Xws7nfg9wl5c8FkHXziQ4YflHYdcYS3lkD8+ruTJ2MNQvev3kzMzSM7MROhI+sJGuPaGVuwrK3Q2JPyrg11SVklnsf2nEJ7i97j8fA+kzzEJJugqWXgt5XfErm0StvnuZZ0hcojftz6a2SBsSD1RrzqrSpu4EMQxp7QnCBPYFNb4mCYEXxrYE0vpMrqpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 09:10, Barry Song wrote:
> On Wed, Jul 29, 2026 at 2:46 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>>
>>> I agree that coupling hugetlb with vmalloc is not ideal. As I
>>> explained to David, this has been an issue for a couple of
>>> years and affects multiple architectures since 2021:
>>>
>>> https://lore.kernel.org/all/fb3ccc73377832ac6708181ec419128a2f98ce36.1620795204.git.christophe.leroy@csgroup.eu/
>>>
>>> where `#ifdef CONFIG_HUGETLB_PAGE` is required by `vmalloc`.
>>>
>>> So I'd prefer to address it in a separate follow-up patch
>>> series.
>>
>> It's the perfect time to sort that out now :)
> 
> OK, looks like I'll be working until at least 1 p.m. again
> today and tomorrow. :-)

Did you mean 1 am? I hope not :D

No need to rush, we're mostly done with new stuff for the upcoming merge window
either way!

-- 
Cheers,

David

