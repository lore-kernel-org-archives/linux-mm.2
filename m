Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAEABD41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F71B6B0099; Thu, 15 Jan 2026 04:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B506B009B; Thu, 15 Jan 2026 04:43:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1306B009E; Thu, 15 Jan 2026 04:43:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA6E6B0099
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:43:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A73DB14022C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:43:16 +0000 (UTC)
X-FDA: 84333709992.06.E13ECF2
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E1EC40003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:43:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768470194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0hfvZiDHXINAX1rRd3gwn/pob6YXXFw6V2LgoemlQOM=;
	b=kM3gwO+ib25sXHPRRq8gigGwGxWDNVyyQhYdVJpPJZp3y6d6vBMKmJeovGtj2SnNwkdD4x
	YTZW0B66q3k/zQaNOzncAJiT+FwuyETa+kmtAp32kcf/C6u6ZI3eOsV4wGgT0XC63qqe+u
	3/jl1iB/47WH4UKAjvTxMOalUYvrr8E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768470194; a=rsa-sha256;
	cv=none;
	b=WEwmhpYhTf7to4MOIGxj+mJ7/Vw21kVlGw96adDigNkmohur6ZqqndJpyCP38AgIdIumFJ
	VUvTB2sqPnOpMJuA/Y2XlWvlcWvypYGPhQBstnRuH6jtMqOw4419HTXQ1qWEtFKmTT9JCj
	3XnZNgMZcvkYMdUvfp7LVjJ060z7ikk=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwBXX5uutmhpJNXUBQ--.773S2;
	Thu, 15 Jan 2026 17:43:10 +0800 (CST)
Received: from [10.22.77.56] (unknown [123.150.8.50])
	by mail (Coremail) with SMTP id AQAAfwBXruuntmhpi9oTAA--.20716S2;
	Thu, 15 Jan 2026 17:43:03 +0800 (CST)
Message-ID: <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
Date: Thu, 15 Jan 2026 17:43:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID of
 CFMW
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Mike Rapoport <rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
 <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
 <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
From: Cui Chao <cuichao1753@phytium.com.cn>
In-Reply-To: <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:AQAAfwBXruuntmhpi9oTAA--.20716S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAQAGln+JMEtAAAsE
X-Coremail-Antispam: 1Uk129KBjvJXoW7CF1Duw1DCr4DKw45GF1DAwb_yoW8AF47pF
	4SqFWvgF4kJF1xGFs2vw1kX3WIqF409a17JrW7CFnrur4F9w18Jr4ayr1F9Fs7t34kGF1r
	XF4Dta4jqw1DXaUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspam-User: 
X-Stat-Signature: ujg6qzcyqhm5o758cfmkjasifxxnp5fj
X-Rspamd-Queue-Id: 6E1EC40003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768470193-413680
X-HE-Meta: U2FsdGVkX18xtJi11Axq+LjbUvCuWDYrBEPUydDsCg26CBaS02bxw0O832wGiFT4K1E8ZvEOnUbNPCiVg+k7uKEb4okkKOgLW5NuXCPuwloRimUEIUx5yqtXDAKpSAOjwWCxy0xp1YjVOFSB2Lkex6fixbuE2jRPy6iuQZZ6ISTa+6b/Wnm5Yz/3CIZuYXOKicHdNCinae7lhc6kpXpCwNHb2qP8k34UzUPOjyNug1JHt+HLZPO4D8PQ1zGhSm/fUdvQn3v2GJQ0j7ZRg17C2yVYSWIsBbnIVDBUbiQX7vsKU1lJZ/OkMUQ6E/BdhRO++xD0+mwHlkApcF9Wu4IgccGUzak8yYzoiCkGu2PEp4TH2aFiqZmt7kRPP4Hjg/Mxb4/qAPC6awXHKxU+upF/zFwxp3pOOn6jp7pz3qE4q+KdBlgl+XMrtJ2NyRdhQz8Lr7r3v3smVtvgfq31+jvjKt6K3BNUmcTR8atXfjsWP4/J7QuHiWl6E/2Qxw3kXXATN8tlyNG1cnHgYGJWTtWyl/Gk5fGEb/xtu73gpQRCYAV+x/7TAGEU2SG+tPvduZw+67e4vDlfj/BmuXFJ26zWT4JHA0DRs4+lP+P4P+2kLFEKOwBDPPofTTXDx1lXoKYyNeCH8JXR4//gKr4Lriki0lamlRW0PYKoGKYggacaEa5asku4Zin0wm8O0KBctr58LyRseyZaL0gzCwPIYqslgT90D9HI7bHy5PJIdBrlYs7Lj8jBDDE1k29xL2746I0UeUgyQVwbB918QqOCer0K/WRzxhMcZsuwLIZ7R/cSv7DrDDB0RCLwSt3weLLAzX0RuNM4b1011TmGxKL05vNzVGCBwDHSNHgQ+ggzp2NTEC81Ed6kRrQV4dV4aH0Pm6yI86WK/kltAatnQnTky8i2K2qz+mwl6uATXMu07BLMwEq0t3wloCwaKqFyLUql/R5MVS4pvfko6OZRx4BgeJl
 q1cTEaT+
 dREFezz+8j0x//sHkRTyrMly5N36CU0THG066dS5UR36Z3uUzIo3waqRgoAB6N2eK63V3rZqswWOOcIHdHd9NGteh9lI5ePyWYPrwTeUQbLYGLCK0yiN9x9dW3ASxWDSTy6L8uviFSHRkIN4KBVfYUkbD7Ud8JCuvkhpe9cfthpG0MoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a CXL RAM region is created in userspace, the memory capacity of 
the newly created region is not added to the CFMW-dedicated NUMA node. 
Instead, it is accumulated into an existing NUMA node (e.g., NUMA0 
containing RAM). This makes it impossible to clearly distinguish between 
the two types of memory, which may affect memory-tiering applications.

On 1/9/2026 1:48 AM, Andrew Morton wrote:
> On Tue,  6 Jan 2026 11:10:42 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:
>
>> In some physical memory layout designs, the address space of CFMW
>> resides between multiple segments of system memory belonging to
>> the same NUMA node. In numa_cleanup_meminfo, these multiple segments
>> of system memory are merged into a larger numa_memblk. When
>> identifying which NUMA node the CFMW belongs to, it may be incorrectly
>> assigned to the NUMA node of the merged system memory.
>>
>> Example memory layout:
>>
>> Physical address space:
>>      0x00000000 - 0x1FFFFFFF  System RAM (node0)
>>      0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
>>      0x40000000 - 0x5FFFFFFF  System RAM (node0)
>>      0x60000000 - 0x7FFFFFFF  System RAM (node1)
>>
>> After numa_cleanup_meminfo, the two node0 segments are merged into one:
>>      0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
>>      0x60000000 - 0x7FFFFFFF  System RAM (node1)
>>
>> So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.
>>
>> To address this scenario, accurately identifying the correct NUMA node
>> can be achieved by checking whether the region belongs to both
>> numa_meminfo and numa_reserved_meminfo.
> Thanks.
>
> Can you please help us understand the userspace-visible runtime effects
> of this incorrect assignment?

-- 
Best regards,
Cui Chao.


