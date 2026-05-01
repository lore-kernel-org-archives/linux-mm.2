Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B0FCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7431A6B0005; Fri,  1 May 2026 14:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3CA6B008C; Fri,  1 May 2026 14:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8A26B0005; Fri,  1 May 2026 14:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 493606B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:51:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEF2F1401E9
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:51:49 +0000 (UTC)
X-FDA: 84719745138.11.E2FD93C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2100510000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:51:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gr1siNtI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777661508; a=rsa-sha256;
	cv=none;
	b=i90qkdjfblfEurCLrjK0aKtKFtS0YaFNbUKq33NXcB34T6ZWtOQvIA9pTESCPWN3BVQsxs
	Nqsb5BTS4GZfiw1zHC6vTZP5Uo/MIDONkyvLcE91gq7xnhOKdNKW6kVYO5PpZgnX1W1PlW
	mLEzU/HJRL/pYBll4Lv1yAxG4EKlGp0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gr1siNtI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777661508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9gk88XSei8CEUKpF27m072iCP3lUCQmtmFhrRp1qb8=;
	b=1LA4jOWRmncFLh7WYR+6k7iEo50HXXqcS5odxcfM6d39HTPzK2VNKEwS5MSOALMDLcsNxD
	rIrgZQoS/iAfUD2KlBhcqccCZR8QWAPRS9z/6N1ewp7nB8n9QuMTeQfJX0EKuGzeYsyMoI
	iHkoIXlzFAzsrsDRumzwWgCWMrIT67Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30E1D43C7B;
	Fri,  1 May 2026 18:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159DEC2BCB4;
	Fri,  1 May 2026 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777661507;
	bh=SgxH2HyW4oS4NiVwuhtY5isslD3L87GImOQpAVBRjl0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gr1siNtIvuhyNyF2+IHVVnB28aTGvbbySnh6LT3C+b09uEvVEEWITbXV8+ZmvAZ8j
	 MwgF2miTZ91k+herq6g2XJme7fFCLUKOkKJMXRwa9MrCLEnIn2TSyEWYQQj1zyZLAk
	 GCl3Xn0C8uCd5FoufYENHyxiSCW2F3mgUs7trbHL5cVfZ9hR7yFG/S4YFPpFsjb95H
	 xgqbQd++isSyUcIOs4OEFALkpiJZ7q+fqc8j/zlDY/apKlN1wXi4CyaA6Topa/ezB7
	 QWf28ujz3I6rZKVgHmSFroWplJih8A9zXVCV7vWpCLJunYVX+Cp6Cb0w7BabNvw7A5
	 UiXF+fR5FmisQ==
Message-ID: <f900172c-341a-4956-b7b7-b297418be913@kernel.org>
Date: Fri, 1 May 2026 20:51:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dma-contiguous: setup default numa cma area if not
 configured explicitly
To: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afBxtIdWqv8pD8YE@U-2FWC9VHC-2323.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7cmgjwi5yjzfft9jergzisuky36xrfkh
X-Rspam-User: 
X-Rspamd-Queue-Id: 2100510000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1777661507-847498
X-HE-Meta: U2FsdGVkX1+Ok0JPJZdB6Siz3qHxx+GAzA+QvGCrUUM5LyEn7NZAk14PsuLL/YKooZwyiX273xSpfW8CR+xZFGrdAJzUouItHA2k0jCW76j73UBm1xHESQ6wuWVGeaDcf25xAc6EHg2rD+38iX1rAWX9SM8R9c/aEFF15PxUJvJMIlr2At7QK7OltuCi+sufxBrueWjDhKkk4rV3L+wK5UPmOjloFroUrdgjvAjVoJExZW9hutbwrVVlDDLltSJVOh1gc1mV3he3n1m9RqlXP5e6yswU/ckRbFT68dxtmZCjsywBsBPCMSrDtIVhkCXBTL2JUAdk8XdebF0X3DXZshs21eOYuvMb16L+ETeAOsg61f0r6N/GLW6N2uEly3Zt/8m0z26E08ruHFDEBwt+zWu9X4QJeuGWPy4Ajo+aOAysiWLgFH4qYNGDl4ibMfNphCxO1KipC1S+1SmSujLzvXtaVdNIWjCCMFREQUcq8JaKsGoOUJ4CYLvQTDx9xJXgT20/f3kl+m/jLpPqNszNAgcYJHNKdiRpmDWS+d0Uyg9q/s+ImlmwJtpxqHTlTes/xwonFxz/LrGkc/AwN4jOj5wBZe6/nxBzPEgSRRjV0o8RwFyDyDoYJaOWpck7Wp8Y7ZO8BYZ+51HbMpr+DtIvzeqKDoXJ4FGHnuWzNkW7UB6W9vcHI+a2hADj2+1B5yThh9JMiEwwnzV5g0QCZ+u4grZK3hMSuyq5AP00YfDx9qW22E3FF3fYhZq0d5mJf9Fici1thQ6OMKBUKll79gXI1ijjTPeVYbuQcX9DV/7ktdFL8mqjTUirPUnGTrbeIZQFdwfuXOdwXMzZ5FjYbMYC/7XwZV7ZnQrjm0RGsBkpy/CawD3ocC2hve9vTOkWz1/kvK/NfSo76N3V0lmvrDEWv7HwYgx+bCEhnmbBvAZzes2TPz/u+ysFe1vYvwSA9La4ki6v5tJyfTVq70Ubacp
 ZwUa2eh8
 7Mnz+Chxmbxsse6zNETmhLm5WC+ZGMUmx8mHSOvF1HmU9o7j25QyHIxtGMxIYGAB7PePUCzzEeSZFt+OV/hw3jkhjNQMg9cU1mTxgfH+7qMf96yHz0LfAaOXymUOZVC3JG/kVdjNnlfhdyMe34u2KRQgo8iFGgN1nzRbrdjNe1JUD40YSjgWEbeQxcH849SvH5WPgvAPsovYhEuY8VAnVTX8grh63G21VLcbKf9qDFs8ti/1OWQcuJw/Gsb5dyief64Q/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 10:37, Feng Tang wrote:
> Hi David,

Hi!

[...]

>>
>> Okay, so on x86 it is not silent, because they don't even have a default CMA area?
> 
> Right for default kernel configs.
> 
> In kernel/dma/Kconfig:
> 
> config CMA_SIZE_MBYTES
> 	int "Size in Mega Bytes"
> 	depends on !CMA_SIZE_SEL_PERCENTAGE
> 	default 0 if X86
> 	default 16
> 
> config CMA_SIZE_PERCENTAGE
> 	int "Percentage of total memory"
> 	depends on !CMA_SIZE_SEL_MBYTES
> 	default 0 if X86
> 	default 10
> 
>>>
>>> One thought is to follow the current cma reserving policy for platform
>>> with 'CONFIG_DMA_NUMA_CMA=y', that if the numa cma (either the 'numa cma'
>>> or 'cma pernuma' method) is not explicitly configured, set it up
>>> according to size of default 'dma_contiguous_default_area', while
>>> skipping the numa node where the 'dma_contiguous_default_area' lies
>>> in, this way the default behavior of platform with one NUMA node is
>>> kept unchanged.
>>
>> So, the kernel is configured to have a certain CONFIG_CMA_SIZE_MBYTES size, but
>> you go ahead and multiply that by the number of nodes? Sounds wrong.
> 
> Yes. I thought about that, and didn't have good solution, and used this
> given it's on a multi-numa-node machine, which may not be too bad
> regarding memory usage.

It sounds wrong given the existing config options.

> 
> Robin did concern about the memory usage for embedded/small devices in
> v2 review, and we change to v3 to not affect them.
> 
>>
>> The whole proposal here looks rather hacky.
> 
> I agree :)
> 
>> Wouldn't a default for e.g., pernuma_size_bytes make more sense, that users can
>> then overwrite on the cmdline?
>  
> This sounds good to me, if no objection from others. Maybe default 64MB
> or more. One good part is, all these setup is under protection of
> CONFIG_DMA_NUMA_CMA. 

I cannot do the heavy thinking here because -EBUSY, but maybe you want a config
option similar to CMA_SIZE_MBYTES/CMA_SIZE_PERCENTAGE that either controls that
these sizes will be split over NUMA nodes, or another one, that sets the default
for pernuma.

[...]

>>> +extern int cma_get_nid(const struct cma *cma)
>>> +{
>>> +	return cma->nid;
>>> +}
>>
>> Why do you have to store the nid instead of just looking it up from the base_pfn
>> in here?
> 
> My thought was 'struct cma' already have 'nid' member, and when CONFIG_NUMA=y,
> it may be useful to save the 'nid' info instead of NUMA_NO_NODE for the default
> cma area (cmdline like cma=XXG@YYG could make it on different node)

Ah, yeah. It's a bit nasty that we have to handle the default area like that.

Another sign that we probably shouldn't deal with the default area :)

> 
>>
>> Also, what is the expectation when the ranges would span different NIDs? (is
>> that possible?)
> 
> Per my understanding, it won't. There is a cma_validate_zones() to prevent it
> from crossing zones.

It's a bit confusing, because it ignores other nids.

-- 
Cheers,

David

