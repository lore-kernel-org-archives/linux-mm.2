Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED11CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 12:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22F16B0162; Fri,  8 May 2026 08:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4656B0163; Fri,  8 May 2026 08:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA346B0164; Fri,  8 May 2026 08:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CDD8A6B0162
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:58:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D62A1A095A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:58:49 +0000 (UTC)
X-FDA: 84744257178.11.F33EA2D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6EB5820005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:58:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r+j5yaDt;
	spf=pass (imf03.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778245127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RFiXXPJN/OJi/iHv/ttKXlQoSpN4Bq91g4pSFUydmk=;
	b=A3nwCVe2ouPVg7hzcCohCGyKxxULS83m4bYSV6rhJNcMXieeuEUVuN27qE9xT+rd8q+KRW
	rY5YGh+EBe/4huYfhtwIYLxpBD5g0RK7RHG+Ico/4JtUz6WYlbkLIGsM4S8n+gcTaPVok1
	pv8FfTLTlvcxf42vzsiv8m49Q/srTYI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778245127; a=rsa-sha256;
	cv=none;
	b=EM7uBFMaL8bzGGmKVTljPrPQ5tHVEK2sxi2prPcaLNEGldwCHAFB9xvdEgqGpxdRXSIKbA
	T+qVpb51yDAE1IyYH8bpV4JtnwK94EbP5MSjs/oI0TzYvX6zZZ1b9WP6DIKliGP5+mb7KE
	YpO9Ri1pbSGTnrLqZ8JXymkZGSe7vMU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r+j5yaDt;
	spf=pass (imf03.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC4E41BCA;
	Fri,  8 May 2026 05:58:40 -0700 (PDT)
Received: from [10.57.63.248] (unknown [10.57.63.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 971823FAF5;
	Fri,  8 May 2026 05:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778245126; bh=TiKhoCoPO98zTUsSoH6ycKjpKEeWG8GNabh01/32pHI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r+j5yaDta12HPpsNHgUBKXv/cU1pyVuYEeBcBBLD8ZsUbfqX55hHELTeSACRS3x4w
	 dVOsfrYDsd9bOj9kG3y13BMTLvuyttjkD5nPjMC4/QOVGogIrmxIYhItUzcrEV9Aa1
	 FurFNj/Vc7jflNbtIOrQAhOP/DQDuwXQSy4qqyXs=
Message-ID: <59d05fdb-bb61-4d92-8df3-45aa3f9f7bee@arm.com>
Date: Fri, 8 May 2026 13:58:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dma-contiguous: setup default numa cma area if not
 configured explicitly
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Feng Tang <feng.tang@linux.alibaba.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Liam.Howlett@oracle.com, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Christoph Hellwig <hch@lst.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
References: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
 <6dd52f8b-7092-4d02-ba24-f8b55409b7b6@kernel.org>
 <afBxtIdWqv8pD8YE@U-2FWC9VHC-2323.local>
 <f900172c-341a-4956-b7b7-b297418be913@kernel.org>
 <aftiQuHOA0t2lfyP@U-2FWC9VHC-2323.local>
 <a5660e22-b1f9-4dcb-a190-f3dc5253c570@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <a5660e22-b1f9-4dcb-a190-f3dc5253c570@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6EB5820005
X-Rspam-User: 
X-Stat-Signature: 646p7ow9pm6wwyar6unyb9ftbbzrshs3
X-HE-Tag: 1778245127-463342
X-HE-Meta: U2FsdGVkX1/ptWdtwSprrwsnAW5MClsov8cKIYi4Hoo59pX8RbRJjlViEMxgG+6UCfEyTmN2/PT62JGgu1NwxPZgl7aojUpA3ePlQb6MrFdhbz90B3Hpw2ODVvh6I3txo2Icu7JafAGc484/Ubo3Uwu8MulNUBHPbxLLr432zhI3MwKDEKwhuOeqdKM1gI2f5r/Rly43OgyIvkucL499Jugt/ZERqy/lm5Lz5L38591J3j5K/ihy5ZHZN5F98YQ3pZv0S0pwoM3l1t4FT/zqZfVqAJjd2lcAgF2CsmtZvF/HSEo1u0ec2cLp6ckfxnlJLttVfTtBOzglhCNL3B3usJL9sCLEwVAH4Yc1QV3XKGvUOAR7lZAUGzDYQDCnDWGqz2G52UFvb9Lm0aAqWnxQMI19go2DL7Ql3/GUkoHn+Ja4A6L+WIgLNfQZrbTfaEHatTNi31QfbhrYhLrlobBtEO9bnPXfnWJfSbaZM0GYXAnhoohsjxJL3kXkCb3brwmFDju/ue1puNW0wap7K80KeBHZIQazp8SwWmCtry9qtHuhqLWgfUcyfwiyjPKFCv0qgnvCQh5lDE6b3vpbYonME3/bwYDYxjJcJlH3+ze3voqqPhKTm2mIU0WTDc3MiTxpNNEECUiS8E5PuetFCW8z/x85O7mUbszH3qNnWUVDd/W2H8TILKdlS6p5dcHsuJnuyz546cLCBuSa1RIxW3INPaum9A2oh+MbZrlL8F6A+/2FdZOU7r3Mvljvlp1+PCEumTfeQKbw80RBJ2WNraJrwSpUd6rcueg+JlcDxNQ9Du/lEU7aENaaYO+fykvvyQivmVOGanTPgR0SjniorhrE63jd5kwA5ZpmLK1LJrVpFnyqB9sM9IqBktVhs+TEYnPsAAQnkLuw0BH+c54bmD2yxE3zwhzYA3CXSbZvR/xWIrQ9dI+ONZ81C0xtfk0LsciUeCKOTQDQsIckqAUzxVz
 sZSjnCJQ
 MRoeLacZyasVbdeK21pDq3kZ4J70nS9rYl8UOpeSfWl+et+b8jt2UlMeuQOJVsE2QXgKzbdTK42mnRkgRnUVYjE6NDFKJEfQ6pVplbMpt1fh7iDJ7XrL3zOZj6aNhyIS0dUfHqTA+eyHpDCUOvnD2gHTQ9zyUQSeTaVdGLv4xlbRP/FxRpZkf9vAtMIQ9LpPOnEAW5wjsIakrHJ9JKFrmK+mLhXV52LLPoy+Z7gq2cg/HAlo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-08 12:46 pm, David Hildenbrand (Arm) wrote:
> On 5/6/26 17:46, Feng Tang wrote:
>> On Fri, May 01, 2026 at 08:51:39PM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/28/26 10:37, Feng Tang wrote:
>>>> Hi David,
>>>
>>> Hi!
>>>
>>> [...]
>>>
>>>>
>>>> Right for default kernel configs.
>>>>
>>>> In kernel/dma/Kconfig:
>>>>
>>>> config CMA_SIZE_MBYTES
>>>> 	int "Size in Mega Bytes"
>>>> 	depends on !CMA_SIZE_SEL_PERCENTAGE
>>>> 	default 0 if X86
>>>> 	default 16
>>>>
>>>> config CMA_SIZE_PERCENTAGE
>>>> 	int "Percentage of total memory"
>>>> 	depends on !CMA_SIZE_SEL_MBYTES
>>>> 	default 0 if X86
>>>> 	default 10
>>>>
>>>>
>>>> Yes. I thought about that, and didn't have good solution, and used this
>>>> given it's on a multi-numa-node machine, which may not be too bad
>>>> regarding memory usage.
>>>
>>> It sounds wrong given the existing config options.
>>
>> Yes, it is confusing.
>>
>>>>
>>>> Robin did concern about the memory usage for embedded/small devices in
>>>> v2 review, and we change to v3 to not affect them.
>>>>
>>>>
>>>> I agree :)
>>>>
>>>>   
>>>> This sounds good to me, if no objection from others. Maybe default 64MB
>>>> or more. One good part is, all these setup is under protection of
>>>> CONFIG_DMA_NUMA_CMA.
>>>
>>> I cannot do the heavy thinking here because -EBUSY, but maybe you want a config
>>> option similar to CMA_SIZE_MBYTES/CMA_SIZE_PERCENTAGE that either controls that
>>> these sizes will be split over NUMA nodes, or another one, that sets the default
>>> for pernuma.
>>
>> Maybe a CMA_NUMA_SIZE_MBYTES?
> 
> Maybe, I'm hoping some CMA DMA people have the capacity to provide input.

But really that _is_ pretty much the idea here - we're effecting a 
kernel-level default "pernuma" value, which just happens to also be 
CMA_SIZE_*. But in the process we also need to tweak the "pernuma" 
behaviour itself to work as a default, since quietly forcing the current 
opt-in behaviour on single node systems could only hurt them - multiple 
default CMA areas on the same node offers no performance benefit, while 
reducing non-movable allocation capacity which could well be detrimental.

Indeed I am rather assuming that actual NUMA systems should have enough 
memory that this isn't a big deal, but I don't believe that's 
particularly unreasonable. End users should still be able to override 
with "numa_cma=0:0" if they don't want it, the only potential gap is if 
distros want to ship kernels with DMA_NUMA_CMA enabled for command-line 
opt-in but _without_ this new default behaviour. For that we could 
perhaps add something like:

config CMA_SIZE_PERNUMA
	bool "Default CMA area per NUMA node"
	depends on DMA_NUMA_CMA
	default y
	help
	  On systems with more than one NUMA node, the selected CMA
	  area size will be also allocated on each additional node,
	  so that most devices may have benefit from better DMA
	  locality without an explicit command-line opt-in.

Thanks,
Robin.

> 
>>   
>>> [...]
>>>
>>>>
>>>> My thought was 'struct cma' already have 'nid' member, and when CONFIG_NUMA=y,
>>>> it may be useful to save the 'nid' info instead of NUMA_NO_NODE for the default
>>>> cma area (cmdline like cma=XXG@YYG could make it on different node)
>>>
>>> Ah, yeah. It's a bit nasty that we have to handle the default area like that.
>>>
>>> Another sign that we probably shouldn't deal with the default area :)
>>
>> Yep, in v2 I didn't touch the default area, while Robin had a concern
>> that the v2 approach will bindly add an extra per-numa cma area for
>> the node which already has the default area, which will hurt those
>> small/embedded devices which has limited number of memory. Adding
>> the nid check is trying to keep the behavior of one node device
>> unchanged.
>>
>>>>
>>>>
>>>> Per my understanding, it won't. There is a cma_validate_zones() to prevent it
>>>> from crossing zones.
>>>
>>> It's a bit confusing, because it ignores other nids.
>>
>> I might have missed your point. Do you mean one cma are could have
>> multiple ranges?
> 
> I don't know, it's confusing :)
> 


