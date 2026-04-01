Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72F2B10F6FDA
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C396B008C; Wed,  1 Apr 2026 11:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE60D6B0092; Wed,  1 Apr 2026 11:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD966B0093; Wed,  1 Apr 2026 11:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 965C96B008C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:26:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B72E13BCB3
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:26:23 +0000 (UTC)
X-FDA: 84610363446.13.40DA7F3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0BB0B140009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:26:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RyvOPtCr;
	spf=pass (imf09.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775057181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ns+W8zI088VkUl5ff8iLclI6vAEGjQ3WPvtozSvzT9I=;
	b=bQnKH0KfC3LNbkm8nJiRDMBmsslqfXCpkOye2jcukc65DGm0xEW3UMGPfHNcaFvH/9nkR4
	EkiuWLBY0IFeAydc90eULes6l9HNabq2OBgksa6OyrB9g769WUv0n54xh5AkIgJSmf0sTo
	q3YGjsyPBz159WLbJBlik0tJ9r8GHWc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RyvOPtCr;
	spf=pass (imf09.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775057181; a=rsa-sha256;
	cv=none;
	b=ZTpSQqhMb6HAJiB0VBJCKfNkB+Ske4kiFm5hHLQz3r8bJyVNa6Skz7cbz4VzaH6jPAn+RA
	1olmbdqoBFH3rxjy/Hk0cEF8Tnq29etqskRpTsXju9salJpeq6RNF9RttFLntOmgC+GgfU
	hsUAsBqxRhNZUl1hH07PyKKu4kic1HI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E93711F91;
	Wed,  1 Apr 2026 08:26:13 -0700 (PDT)
Received: from [10.57.77.192] (unknown [10.57.77.192])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37AE93F641;
	Wed,  1 Apr 2026 08:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775057179; bh=wgI+SVOkvgIgOkHOsP10HpUziCGVii7hr3xefXc2Vxs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RyvOPtCrsaxhbwyyXJ9/sJxTBCYbXkxvMc+iFf5L1/ntPvY+woD6bO16mABcc9fzV
	 TRRjRLZAcc2Nn8wIqx41NvyZRgmTLLMoST3hzqBUZIzl1WOZ+HRkzq+Y0o3H08c2yb
	 TuGDO7ocWaI0p0OlB0jJ5cAO9ZDJxmYha4jc0j0g=
Message-ID: <75f65aa7-4f89-4ef8-8941-51b1d54d1ad3@arm.com>
Date: Wed, 1 Apr 2026 16:26:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dma-debug: suppress cacheline overlap warning when
 arch has no DMA alignment requirement
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-mm@kvack.org,
 harry@kernel.org, vbabka@kernel.org, akpm@linux-foundation.org,
 stern@rowland.harvard.edu, linux@roeck-us.net, hch@lst.de,
 Jeff.kirsher@gmail.com, catalin.marinas@arm.com
References: <CGME20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72@eucas1p1.samsung.com>
 <20260327124156.24820-1-mikhail.v.gavrilov@gmail.com>
 <6270d4f0-85e4-496d-8db4-87ccb791ca4d@samsung.com>
 <c9ded35b-fc10-47d8-bfaa-cecb4fa91add@arm.com>
 <CAHp75VdrGk=foAzQBJNRNDZ1yfFY8p-tC_ApM8_gN4EehpmN_Q@mail.gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <CAHp75VdrGk=foAzQBJNRNDZ1yfFY8p-tC_ApM8_gN4EehpmN_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BB0B140009
X-Stat-Signature: dfskjkjmi71iw4gahkz4inc3uj3ewe8x
X-Rspamd-Server: rspam06
X-HE-Tag: 1775057180-423295
X-HE-Meta: U2FsdGVkX1/SuAZkd/joKJohbwNQADiz7fsNvKPpE/U4QcI98NfvZJJRuc15DAX16twy7mRA12tSqCTiLNuLDuxreYrw5w2cJGTS0DhnSugT7OpyY1+CbKZd3rRrHM3AVTS4GgMkipIRNeM084FVKrIgaUw+Q7JAY580mkqGnSRKXNF0Mx5HIBKM60hTcASmJ7q7B2oSBDq2aazh42SlWGf0bmcRfoSsPGMG7gnkQf/+kxhx0TJ68p4pYIRv9pFUOgbASawJJiqsnNqPXobHKTuxQ/evN3Rt5wZMFfl6JcTTgLkjmzSaneHfFB8O87yGja7XH1AuOVvcwjbHzePltNy7TpDkNxNLCxFXgnDiC+cEFoXKE6exJaZE6j37jc51CcHPANUyPtckJZB8RqiNRLzhUMKiPOIKk9u2XLylCihFgV/pGRm8zoPYgEeEaU7Mhy/02GN4GgMZlPW14EaHFbkoJCyuCYXGgTWTtsESAKdgUHcE/Bc1sdoiWA8ZMkRsTbJ3m3Y6kBnFHWdvPHv8qXIYj2lr0J0krYk31TuDMDBHQs009HuS9u4o9GJdNN1c9y9AnxBRN5BQHfa1IHYA7R2JpBLyuC2W2V0UKAoUQtw7z6aQCkEdTZxtuOIauFKcMWF61KZos3EdRpHcW7HkX/EdSsVRJBRhaEOOVDsdNsVik79fIi7caQKgtRHRxcmKfcC7JuN06+vETGd8TXzQDiFMvuL+xfXVK22RA47OGR/aP6oJBdh1/ic9+pmQbkaskCAAHhCWLsRFyiEpxqeMNW7vEQo50jVfz4rzfYIQLR0Vfjq3WMUSScEfQUYgwhONa/3huUPNq9dOqxigXafAYv+rNkSdLEiFm+rY9yeUzbY15juCPD3s8xXmL4ua6M1XXWEwgPVCLpb2MhMYsHKxUMuBzMBUENA0M46KYy5EB3n1PaUEd0r6nGfOdOtlrybqZfZMLBoFv8e4g1ruXpB
 TS9zo3fi
 qFVBwK6XmU95X5PYeCHQlccSKzBGPzelEwuT+P6J3Za/jvrsfiAKAz3X3/d86kxVpnJGbN8p4qHQYudC/2H3qek0xUWCk4rIxanL7PJeVPw9tu042zMeM6HywnRysNgqmWFeoCDwNLYFbDgog1GmaydF+ItHPcDnVk77940UGiep+6lv776pk0N8jCQaI/NLauXuxHvhCfes2LBjm33BZsF4e5FPfiHDw7xOho1rAhBNR3ASaNlMaa36f1N07BLUS7LoYInHmiA2XXZixN+zSrJVbAJPOyThtgCiJjBlh9bp5nG9GR+TArPc5P6u4b3le2TOem+pWSKQHbzsX4GF7Gh7KB1g8jE/nSfjCr1cTnPTRXEUqU5UIHLbj6TtVPDFJgavc8ltm10Douq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-01 2:25 pm, Andy Shevchenko wrote:
> On Wed, Apr 1, 2026 at 3:11 PM Robin Murphy <robin.murphy@arm.com> wrote:
>> On 2026-03-30 8:44 am, Marek Szyprowski wrote:
>>> On 27.03.2026 13:41, Mikhail Gavrilov wrote:
> 
> ...
> 
>> TBH I'd be inclined to have CONFIG_DMA_DEBUG raise ARCH_DMA_MINALIGN as
>> appropriate such that genuine false-positives can't happen, rather than
>> effectively defeat the whole check,
> 
> I dunno if you read v1 thread, where I proposed to unroll the check
> and use pr_debug_once() for the cases which we expect not to panic,
> but would be good to have a track of.

I had not seen v1, as I took the last 3 days off and hadn't got that far 
up my inbox yet - I guess it's at least reassuring to have reached 
similar conclusions independently :)

The fundamental issue here is that dma-debug doesn't realistically have 
a way to know whether the thing being mapped is intentionally a whole 
dedicated kmalloc allocation - where we can trust SLUB (and 
DMA_BOUNCE_UNALIGNED_KMALLOC if appropriate) to do the right thing 
across different systems - or just something which might happen to line 
up by coincidence on someone's development machine, but for portability 
they definitely do still need to take explicit care about (e.g. struct 
devres::data).

Certainly some milder and/or opt-in reporting of 
potential-false-positive overlaps wouldn't be a terrible idea, if 
someone wants to have a crack at it.

Thanks,
Robin.

