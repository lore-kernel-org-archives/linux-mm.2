Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49E0CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05846B009B; Thu,  8 Oct 2026 05:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E5E6B009D; Thu,  8 Oct 2026 05:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97EF26B009E; Thu,  8 Oct 2026 05:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7426D6B009B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:43:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E71CC1404D1
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:43:14 +0000 (UTC)
X-FDA: 85298970708.11.B76706E
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E330100003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:43:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=PbgH3VY5;
	spf=pass (imf14.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791452592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJNnHPGG4mNQooWPuJ2KoNzlsArMHoPuRSotZ7wNxxI=;
	b=vcRuR93nAb4APFEMlFf2uDaYeRBMOAb40gsA6X5360scMqqyXsO4t/z0xIIWc6pwIPWaj6
	n4V6uo8Dvp7rboLfssTaJo7K7HC2zi/WJf6q64ifBO58dPtYpltk0zRfhwvadDv/Krj4Zf
	F12AhEOVSAVGtSEXON/TikYsT+s+lXQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=PbgH3VY5;
	spf=pass (imf14.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791452592;
	b=A2NtILEQNu5bw+b0yufMzwuDnon6Z89Own9f/odOAll9WtE70QorrB9cgRV+lB30RuOlst
	eBqDfuviIy3czg1ZmFng9WdYC4e7uX66HqkJz+qTgA+fOvU/0Y4H5ZYWV9UqrXkJZC9+Xq
	z86+MJdW8fhX0lHXOkhpEhJxZzcda48=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261008094311euoutp028ec7cb1d130d6d302681fcb497c4fa03~chKPwIctN2642326423euoutp02p
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:43:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261008094311euoutp028ec7cb1d130d6d302681fcb497c4fa03~chKPwIctN2642326423euoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791452591;
	bh=nJNnHPGG4mNQooWPuJ2KoNzlsArMHoPuRSotZ7wNxxI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=PbgH3VY5H2lL1x3cW1EYzRMsvXBfnGZD66HPLDIegw38L8M/Ylhmpg0gnsFxXzm12
	 rXoJE1UUssw/hNOLBLOVEna1pFXZnwlpFoCFFYrzfy+1UpkiLGMWksbKaG4In8YiGQ
	 fs97ketcN/775lV7DxP2TVq9KZ/k2Xat6DOpVv+Q=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261008094311eucas1p1d640b4ffd81730e0ee429aef7e8412b4~chKPgpifp2015020150eucas1p1J;
	Thu,  8 Oct 2026 09:43:11 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261008094310eusmtip1d8898c71d330dd4bbb9e00e90ce133cc~chKOulU4o1455814558eusmtip1R;
	Thu,  8 Oct 2026 09:43:10 +0000 (GMT)
Message-ID: <1813f0d0-1e0d-4cec-8132-cf1f8731a8e6@samsung.com>
Date: Thu, 8 Oct 2026 11:43:09 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/5] of: reserved_mem: several fixes about reserved
 memory
To: Mike Rapoport <rppt@kernel.org>
Cc: Wandun <chenwandun1@gmail.com>, robh@kernel.org, saravanak@kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <asc6brs_g0ky0wOM@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261008094311eucas1p1d640b4ffd81730e0ee429aef7e8412b4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261003080438eucas1p2bdb68c248ecad088559285a4f736bfe5
X-EPHeader: CA
X-CMS-RootMailID: 20261003080438eucas1p2bdb68c248ecad088559285a4f736bfe5
References: <20260920092852.614973-1-chenwandun1@gmail.com>
	<arJA6fOMetzoBhDH@kernel.org>
	<060fb694-ba1d-40e7-8a18-f32d5a4039ab@gmail.com>
	<CGME20261003080438eucas1p2bdb68c248ecad088559285a4f736bfe5@eucas1p2.samsung.com>
	<asC3DBvtlcO5AVsz@kernel.org>
	<5dccea9b-a9e1-44f5-84d9-bc9efe04edee@samsung.com>
	<asc6brs_g0ky0wOM@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E330100003
X-Rspam-User: 
X-Stat-Signature: 5mgzsiknjbiauwdpq19tqrtmtr1rdjxc
X-HE-Tag: 1791452592-923817
X-HE-Meta: U2FsdGVkX1+s1XQW+Q6m9ml2YWAoRJEM8oxsXCczj7u2stFqVOyAV7XbFRnDymBQEUa2AXk8jpdf8lh9IntxRQnih2ZTzwlpW7xEDrMJGq1zCUJ6+d8wdeI0qXhT2MIQ3RncRVigwtGSQNmLjAZr3Xi+7tWylhkWB8XHiL9hf//VMKHEHo3piqFJ2bVgCtVjBeQrMmSV6HldC1H7xQynj/TbqsUSJtOMCPLs4X+HLHq7XcOD2jpw57aoF7SIgU8Rxt+Jb/1nIk4qGoLbAfm0+T9yQxhaG8leWGOmu8obLldJAnrGuc1VJgc2i2Ag5xD5Q/htmWN7RqgjKnJmyMNGIsJnX4IpXAKjz/HQ1VMwTx5oQozHZDMG0yu7+yjVLahCOAsD8xuIeW9sc07Q/KYaD9yCpfJgVAWPydF3wxXY47B7kX7cguCu6jf1ESPtRr+X2GjKOq9DpKl/eWPbZ8NlsAjZYEs/E76wUfMbWwCZvO0hEuRP5hxiAb4eevIzmyihrrGT3uDM5pB7NoArTIy5ydfB2poIvP+DP71jjz3mIp7nUnnQS7o6RXJzvOU1gjCnY8n65NJS+TBQqam3VILr0un3R3jeIOSi71vsEYRJYf5N1CkIB7dm0DqngQxS4ZxcCiNbkRnvO2INpQLDYCl5HR+MgQm1w+ro/sxqu+mC7kmjgx248Rw+JhLbareLSUT1shs4WKS85XPADogIxjXUQQEWGbMUejsaXVPMlbvb0K7LeH/JWRmu1eaEZuzLeVc2Xz6m1UEi5roH/9b3Ao9SvtScRqCb5RvgUJvlYOVCAq5T2odzTIe9dw6LzJ2syG1oXdNZqdQa3rOPeBjdyGjVDqpNfdOfwrwIAguqe6zoGietKjjudifgsnVorQ77nu3NmqkCsm1uHmsdvZlj4HnFi0YiT2BIy/yT9nrXsuqWr5LEcjP2q/f/RVijK/rjMrdvi8/5NMlDDgTfEBafMBs
 +Y3rrqgp
 AEe6anCp39dAxhuHbJdO58IAtQUT7lfd/EWrJIOpdRlL85u1pB8bMkParc1Epwi0lVlmrnX0CTDi2NYPj9c++J8m31cCF8Y5FnnPxl38Q1SayIYtis9KrliigNJy1mXzV8NTrY3ulILJFJNDylsmvIGdc+SF9iu20jf9w64vVbLQFggQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.2026 08:38, Mike Rapoport wrote:
> On Tue, Oct 06, 2026 at 03:26:21PM +0200, Marek Szyprowski wrote:
>> On 03.10.2026 10:04, Mike Rapoport wrote:
>>> On Tue, Sep 22, 2026 at 05:24:32PM +0800, Wandun wrote:
>>>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>>>
>>>>>> This series fixes several error-handling issues in the reserved-memory
>>>>>> initialization paths.
>>>>>>
>>>>>> v2 --> v3:
>>>>>> 1. Rework the mechanism that checks in the late scan whether the early
>>>>>>    reservation succeeded (patches 3-5, suggested by Marek, thanks).
>>>>>>
>>>>>>    Patch 3 adds a new memblock flag MEMBLOCK_RSRV_RMEM, which is set when
>>>>>>    the early reservation of a static region succeeds and checked in the
>>>>>>    late scan.
>>>>> Can we keep this local to of_reserved_mem please?
>>>> Probably not. I do not see a way to keep this entirely local to
>>>> of_reserved_mem while handling the issue robustly.
>>>>
>>>> I previously implemented an approach in of_reserved_mem that records
>>>> static reserved-memory nodes whose early reservation failed in a local
>>>> array [1]. However, the early scan runs before paging_init(), so the array
>>>> cannot be dynamically expanded. If the number of failed nodes exceeds
>>>> the array size, some failures cannot be recorded and the issue remains,
>>>> and that is why Marek said "partial solution", although in practice
>>>> having that many failed nodes is unlikely.
>>> Even before paging_init() there is memblock_alloc().
>> One can call it, but such memory cannot be dereferenced/accessed for example
>> on ARM64, because it is not yet mapped in the linear map.
> Can't we use early_memremap() for it?

I didn't know that this is a valid, allowed use case for early_memremap(). If so, then
this is definitely the best approach, as it also removes the horrible two pass
initialization introduced by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how
the reserved memory regions are processed").

I've backed such refactor with LLM and it looks very promising:

https://lore.kernel.org/all/20261008094125.3197971-1-m.szyprowski@samsung.com/


It works fine on ARM, ARM64 and RiscV64. :)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


