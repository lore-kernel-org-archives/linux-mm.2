Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209DD106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4557D6B0005; Thu, 26 Mar 2026 05:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406376B0088; Thu, 26 Mar 2026 05:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5446B0089; Thu, 26 Mar 2026 05:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5806B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:54:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BFD513C07A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:53:59 +0000 (UTC)
X-FDA: 84587752998.06.5EFDF45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 178A4180005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:53:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eWem/Bwm";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsNRFi1J+mpq8rgpOJnYCIIR3xkLcQVrzfDMhAr+p+w=;
	b=uojMyJFPUZ5eef/jaaMljSIo3hU0331/vlvR2WipyHOTB6wbGrMMQ9NNlj6ZNAVdXQJTJS
	cqMjcMb4IprQKmWhLY5Ig0xx8+9+GRwXDsSNsZ3IdxYggicYOmV8HyJ6hWkGgjlKgnjVxZ
	azZI2CXX/LASfOpXDe6amqGEgKK6nM0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eWem/Bwm";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518838; a=rsa-sha256;
	cv=none;
	b=H2Ms17qaI9Nb0bqF5Uht0oEB1G5ASeQDOaoO8iOlxrkDqL7RLsjEPMQDw65ZTgFzIkDHhm
	91s1i5CWtYYkzvHmTJa/qzjEKdTXYA8GBWojD25uissOnbpjb5xKK0rtgxHaNGmYYaZ5On
	5Hv9ZjvJlBIYkWuNXf/WCtY3RGu59Uk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80B2E60053;
	Thu, 26 Mar 2026 09:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1191CC19423;
	Thu, 26 Mar 2026 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774518837;
	bh=3JST1h1w+4+F1RTqYqedp0xzauMee97MVTq/QWistMo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eWem/Bwmp1XCRrRsQXwUGDy4l94/ozbhmpiaCTcmkpXW1/L7mpVOUJ9gi90xWqitq
	 JCRUj+O4pLBG5KCdDfTFIw5A6nBYFs2LWMTk5RqA+G/RbMFaGmqDzHLX+RDR+JEwTm
	 szptenKBVF5Spv1fs634JKY5qWzjEpekC963DxJD9tVt6o8pdnbJ7Laj0ulHelQQo3
	 M49q38ec8DXsRKWEm13Ei/J9976cdst9nAiQjXwHETdqxcGhljvyqb+QlbDFhewoMU
	 hoPij3qwAgmFIUO75xzIgWMug7OuyBG8wt1kM9/3bc0LDPGcy7rKL58ORJ9X6jftFJ
	 QKLLsv61kexGA==
Message-ID: <72934683-0409-4e6a-9d34-daabade131eb@kernel.org>
Date: Thu, 26 Mar 2026 10:53:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
To: "Chen, Yu C" <yu.c.chen@intel.com>, "Liu, Yuan1" <yuan1.liu@intel.com>,
 Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
 <acEkfaycrJI-kWjk@kernel.org>
 <168ab3c0-c44f-4d48-b7dc-33196b7ba6a5@kernel.org>
 <IA4PR11MB90092536DE2D9DF404E3B3EDA356A@IA4PR11MB9009.namprd11.prod.outlook.com>
 <cc8ee2c6-a169-4cb1-9c16-e76ae08fcc58@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cc8ee2c6-a169-4cb1-9c16-e76ae08fcc58@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 178A4180005
X-Stat-Signature: d93g33q7fatgbmd5gwanxds9mjs5oohn
X-Rspam-User: 
X-HE-Tag: 1774518837-606442
X-HE-Meta: U2FsdGVkX1+uxoNggS/XQsZx/2j1QvcMn1qlSmpWzV4KNc7sfHUJenhUBHjihiMukX07FWoAuMjWCXfNS1claD/n2w0xnqfJosJCbAol46yGPAV4R7D9TB5wFsO8TImvp1ujbld9YpMDbsa0uG16RkNSb7WxSlxlBw+0QnsiMom78ySpHVXkpmbYYFs97BSL/5EeccXp4Jyw4l3FeycKu1QFuwcpMNKyHq+mbCmUxjhO8BcDkDLLnFXQ/iO40m7lMPuHsl5jtu+X+xpHT4HX4LIRjGHGGmVasSVqtKoohLSuFfprlSDqkFW4DhJKilev9Lz7uzApePSmq4dB5DIZEpw2qYPBtiq5NxJEJJMXBlLbzuAG1gEC/zqOeOSe0IbwFM57K/QIgBeJ/PpptZGwbev53WmutPAYmv6zCtNlmpGhrK/HEYrIvtL8RGbBPYR6nFMDGVptER3uvAAPL/iaT2BboyASi1Tgt4d/gctw9j9PpJuzMKX2/P6P9X9bTEWIo4HifbDwFi1Z39ZyJnfogp+B0UohNNK+yahRypSjwgi2vsGdAPsdvx1LxglqBPWzzDBJYKGM9DfWLCFFkIpauTo4bF17/LgPkBMp1e7zsDMrEIq8YUphn2yrnt8ICByDYSVqbgwzkNUiYpJCaBV0RNQmqq5yJDYkRVBWw9qBvgDB7Dy7h2pjGllL8sXuJkWbVSYyluh8pc6j3jJerMqoKPRfeTGlYtXRhFDa/8dAAv0osv+1uDYxCTWNt2CGUaOTewkML05w/+L9rTL5iJW6tQy/qpO1ECMK1c2NvNPKkyc81dYb1m1CcuUxxZyp2uZS3Oh/acmELQxUbPxZwIQYq0bEgGZsyAqejtzYEUJ8GwIj7G3BVZQqvf13IJjAU/C5nTSJXw59uGL235k7HiBb4zj2ICyPOlPOzNWOAzldWj/iGfozJEYAj7+CxUmqyq7RCgRjleuLHkxL2TLacW4
 vCUOV8r7
 BxmIoZtyEtcrdt4J/Jyth/Gsgenv3p+EInwwZabrZRhAWlDpxcGfZtGFAcY45Nm4qGizl+ontPmWrqmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 08:38, Chen, Yu C wrote:
> On 3/26/2026 3:30 PM, Liu, Yuan1 wrote:
>>> -----Original Message-----
> 
> [ .... ]
> 
>>
>> Btw, can we introduce a new kernel command-line parameter to allow
>> users to select
>> the memory block size? This could also address the current issue.
>>
>> Test Results as below, memory block size 128MB Vs. 2GB
>> +----------------+------+---------------+--------------+----------------+
>> |                | Size |    128MG      |    2GB       | Time Reduction |
>> |                +------+---------------+--------------+----------------+
>> | Plug Memory    | 256G |      10s      |       3s     |       70%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      36s      |       7s     |       81%      |
>> +----------------+------+---------------+--------------+----------------+
>>   +----------------+------+---------------+--------------
>> +----------------+
>> |                | Size |    128MG      |    2GB       | Time Reduction |
>> |                +------+---------------+--------------+----------------+
>> | Unplug Memory  | 256G |      11s      |      3s      |       72%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      36s      |      7s      |       81%      |
>> +----------------+------+---------------+--------------+----------------+
>>
>> And I see the UV system has already this (Kernel parameter is
>> uv_memblksize).
>> I think if we can introduce a common kernel parameter for memory block
>> size configuration?
>>
> 
> Is it possible to turn uv_memblksize into a generic commandline
> memblksize without
> introducing extra parameter?

We don't want that, and it's kind of a workaround for the problem. :)

I think we would want to only account pages towards
pages_with_online_memmap that fall within the zone span.

We will not account pages initialized that are outside the zone span.

Growing the zone and later trying to shrink them will only possibly see
a "too small"  pages_with_online_memmap value. That is fine, it simply
prevents detecting "contiguous" so it's safe.

We can document that, and in the future we could handle it a bit nicer
(e.g., indicate these pages as being just fill material).

So indeed, I guess we want to teach init_unavailable_range() to only
account towards zone->pages_with_online_memmap whatever falls into the
zone span.

That could be done internally, or from the callers by calling
init_unavailable_range() once for the out-of-zone range and once for the
in-zone-range.

-- 
Cheers,

David

