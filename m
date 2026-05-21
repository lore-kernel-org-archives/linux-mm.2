Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF49CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0BB6B008A; Thu, 21 May 2026 07:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B156B0096; Thu, 21 May 2026 07:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B316B0098; Thu, 21 May 2026 07:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2CDD6B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:24:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 724391C04A3
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:24:28 +0000 (UTC)
X-FDA: 84791193816.18.84C8EC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8D525160009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:24:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Jp808FfH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGsNvB3fuNc9H1D7trF0TK1admzTZ+TbGNNWBjF/RHw=;
	b=MnybjhtYLXWu6irVNuLr6i59XpWHlRWyMBMUL7vYMA0efGhqZg31J43KXJOw6g80BYEAiz
	quAFZ9cPQx0k2CCz58M7JIPAmIKIHxzaGFMUW5N9ShspYJaf5xebzarJ42MonXfX59w4jH
	V+iNPJpPSQPD2ndSvTqoKIvm+uArg70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779362666; a=rsa-sha256;
	cv=none;
	b=4Wsu3UR+ypMMNupUBuVhjjUybwQA04eWjyL1PT9F4FWTvUSJERP9EqSQr7Y/eKAxh0y54h
	ekxh3nAfxxbrR++Nc0cyONagolc6uwJ7z4CA5hGTmV741Z9ve60xE5S4DcKzWVwvpE70W3
	jtqfAJllZBeemtwfax6ApVyZSrkGpb0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Jp808FfH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 727763D76;
	Thu, 21 May 2026 04:24:20 -0700 (PDT)
Received: from [10.57.91.212] (unknown [10.57.91.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC2C53F7B4;
	Thu, 21 May 2026 04:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779362665; bh=YUoIKZ6fjqCMA7Nsur2Z6SraVqMh2aFofJ9GzDnYzjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jp808FfHIf2INAyNUKjyzFUDdoLUap7tdKuaWXl/u4wTfkRyOswfekFS1kCxGiUyH
	 wnDgqh7JHFp2HxVALetvKZYV93X1ts82Px1WEYektmnKkpF1jkJWcRv/b2OsfAUkpF
	 9Q3XkDfhEXL6TjeFsp5oAm5RuO2Loah1MmBnB0QU=
Message-ID: <60542cd7-d01c-4247-8957-8423b54ae99d@arm.com>
Date: Thu, 21 May 2026 12:24:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] arm64: mmu: use range based TLB flushing when hot
 unplugging memory
Content-Language: en-GB
To: Balbir Singh <balbirs@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, catalin.marinas@arm.com, will@kernel.org,
 david@kernel.org, anshuman.khandual@arm.com, dev.jain@arm.com,
 jhubbard@nvidia.com
References: <20260521042426.2128731-1-apopple@nvidia.com>
 <bc96d822-bb68-4945-9f74-68f77e389ac6@arm.com> <ag7fy4Q9foBBlUcd@parvat>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ag7fy4Q9foBBlUcd@parvat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D525160009
X-Rspamd-Server: rspam04
X-Stat-Signature: rxc79hs94f931ibyba1s3qpp4qunzsy9
X-HE-Tag: 1779362666-731730
X-HE-Meta: U2FsdGVkX1/Vl2d0DMO3k5vJGuX4p3/W4SdgASTUdst7ponV40uBPvhdDQ6maNlOHX4NWOYP4V+LGGmadl9EJRQsVj/8+K6ncVIP4hl2VHatdGK/43IiAR8UoZAKBvzaGNxmBuPpYXHkb3tgYg+5iJqN+17rGgjjoKDbXoSv7CWeou5Xa80QfDunDqwYqPxwCapPmhnmg/6ilkLb78B1Nt87MFuGWF/Jq4jaJBqd1xDnC/u6jmw3fWahlV6Ws9NPBj72fUNm7OzOP9ouvf0J2+LKg4guiDWaXHT3+mnSnFy+4MzyvmRj+AABvsYjxbDoRJt59IQnB2l4v7EEURFTzFeXKBlMQljrOT3IbnjJYgdxr0KlYZgFiah5E9KCEZs9teohxuVkAU9kZYLJQVFbH5FJPlrtEB3eTXCePKX1qw8EtwSwJ/cFKoQtsrflvR93PJneGr+2L0I3imBqxAW4UXNfNWOpFymNOfbWAcfpzBfKSrwFKCv0ZfKuLdR+sM2M1YjauD98PgsCkKVRth9gRcbBhInWaj8NCNTIPdNfJ98gIG79PQfV01nmQ4isfvaLmvvj8E7JHcZ5R/5qbyAo1yHRmApBcJDlEBbZXbw78ikbiPpdddtkJl28ioHW5uiG6bWXozEXCEqpevXge51xVDqePurHRP7uAzs8ryzIXJdFljclXTau9HwKM8XG2VIK+b01tEw/2j4N7yvliySBtOXaTb1XAWyP0dm6a62Kjx/9JbmVfYgICbgNH9iXIlwCPvxVRJb/8LQH3HKWnZ0GOk8jcH8swBan1M4eRKZ/nbFHbqy5oitPAhigMp7PB5wp+5UBv7we8VuZAPf/R0uqn0GlhrHfjMrvEOQNdIAAJg+GRuap5KrEQ1ALjYPN+P+WWVyfUwP+cg2s6fCjwVUI/6J4/kUngszhkbN7llPMJ7Rc/rZkf/2Uppncwa2DINi66qqVW3dudw6gpURgKFB
 R5GrW7MA
 94YH4IJY7E1LlfMjK/oW9VZxCztWGBLvPq4Z6cpACL5DHneroT3i/yfe+QfAEgeQmu6Y5NtG+ro9bdxCo3DHdfwG7kTbOLLkPB58rzUTPsL3xcVjV2yx4jFHS2lbavZxL5b6fbrkzXfKiXGG3Z8uS3H0s8mkYGK+RDLshFD6IIA37xq1MyHC21+KaJupMHJk4AZgUcG/laamo3W+kWkG2am9JuJ4mv40k5DPxBfwkika3BXfU3S1C7FS7X/4CF41Xvm3P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/05/2026 11:46, Balbir Singh wrote:
> On Thu, May 21, 2026 at 09:50:04AM +0100, Ryan Roberts wrote:
>> On 21/05/2026 05:24, Alistair Popple wrote:
>>> Hot unplugging memory on ARM64 requires a TLB invalidate after unmapping
>>> the page to be hot unplugged from the direct map. Currently that happens
>>> one page at a time, meaning range based invalidates cannot be used. The
>>> result of this is that removing large amounts of memory takes a long
>>> time and in some cases can trigger an RCU stall warning.
>>>
>>> For example on one system hot unplugging 480GB of memory takes ~1
>>> minute. With this change the same operation took ~1 second, a 60x
>>> improvement.
>>>
>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>>
>>> ---
>>>
>>> This is an RFC, because I'm not sure the change is correct as it frees
>>> the PTE page before flushing the TLB. I'm not familiar enough with ARM64
>>> architecture to be sure this is safe, for example I don't know if HW
>>> can update PTE bits such as access/dirty in the page through a stale
>>> TLB entry.
>>>
>>> If so this would open a window during which the page is free but could
>>> still be written to. Likely the safe option would be to collect all the
>>> pages to be free on a list and free them after doing the range based TLB
>>> flush, but wanted to get feedback on the approach before implementing it
>>> which is the goal of this RFC.
>>
>> Hi Alistair,
>>
>> This patch doesn't apply on v7.1-rc4 because it conflicts with this patch:
>>
>> Commit 48478b9f79137 ("arm64/mm: Enable batched TLB flush in unmap_hotplug_range()")
>>
>> which has a very similar performance improvement, so hopefully it solves your
>> problem?
>>
>> There are two paths which use this logic; unmapping the linear map and unmapping
>> the corresponding vmemmap. In the latter case, the memory is also freed, so we
>> can't safely do the range optimizaiton there since the TLB needs to be flushed
>> before freeing the memory. But the linear map is the big, slow bit so hopefully
>> it's sufficent for you?
>>
> 
> I assume vmemmap path is for tearing down the struct pages corresponding
> to the physical memory and vmemmap teardowns taking a flush should be
> OK. It is worth checking if the issue is already fixed.

Yes, exactly. Assuming you're using 64K pages, I think vmemmap is mapped using
base pages. So you'd get 1024 struct pages on a page, so 1 TLBI per 64M of
memory that is being unplugged on the vmemmap path.

On the linear map path, it's a single range tlbi operation to over the entire range.

Alistair's patch is doing it per 512M in both cases, but is unsafe for vmemmap
as currently written.

> 
> Balbir
> <snip>


