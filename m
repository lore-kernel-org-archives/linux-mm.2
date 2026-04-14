Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A65AED7B95
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BE26B0088; Tue, 14 Apr 2026 05:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4CC06B008A; Tue, 14 Apr 2026 05:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3BB96B0092; Tue, 14 Apr 2026 05:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6FFC6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:32:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5762FE3827
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:32:22 +0000 (UTC)
X-FDA: 84656645724.17.38DEE44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7107A4000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:32:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tKSsMIMq;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776159140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbxVpZ7j2h2F+szRP5oZSoXIxH8XgFyrU3OmnHWUI/Q=;
	b=lxdksHj4hX4t0dj2I9Pu962agRnlGy82ehWTdfGxgqkhn+VglgJIrt5MrflqpzFkRFqvW1
	38jCds1Ipfe93orPAwS/WeuzX2eecpL/QbKB3iusWNUzapOeBXKUO4Zrh0JFsevk1+CTNU
	iK8bR+b6pyzWPd4cTCF0EAZwcekF+Gg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776159140; a=rsa-sha256;
	cv=none;
	b=h/wpJArA2sRRfe8kEPuWiEDqvNzbcJDCKkNy8Jdo34Ux4dPRYr7KAelmlc34iW6Dxd7zpf
	ALHQYgRTNHqBDYHIqY7t/KEIMogSTqUv+S8sIrLEfVi3CtXcUIzPBTvADga2CCLcH33H/y
	5GhjzrZAheSyfz3aBO429tZupK57VpE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tKSsMIMq;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E60E4358D;
	Tue, 14 Apr 2026 09:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0B7C19425;
	Tue, 14 Apr 2026 09:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776159139;
	bh=0aFYz/aQnGGNmqnVT+C9VpFJTvxEuJJ9c4YGNPdk2b8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tKSsMIMqq3z2iqeTKDSqKNNQnaQQmWHyLh4wAJ6J84EM9SwXlDmaioCOpNxXQ3Vd3
	 q0kuUBLd6AEJ76ejXj0rMuhkEXKy1NgpAQYBPV22xRKpb657yyeWg08TRlHcGpZwlo
	 ib8aVGXP00NyZOm0kcMytTtLTYKueQCublZaAGszOLho3e8KuSCZ8puQMoDbzqSXTV
	 WCJ1DerrYLmSRoqr64rh7qvqJfQtRiy2RleWaYuo8zeQsdESTsDcZDVb+CEeR7Xw3j
	 fE6dJIRkhBj0K5CbjzBrRw8ZHz/R7I0/Jw30AoaeMrmobYfrQ99SET39q7IGWlkMIr
	 ai4Vo1PPxBkdQ==
Message-ID: <fd59736d-a02a-4693-9e70-23c593c9dac7@kernel.org>
Date: Tue, 14 Apr 2026 11:32:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 linux-kernel@vger.kernel.org
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <20260413130633.knzkliyqvjhuz2kd@master>
 <1928b6b0-2ec3-43ca-a41b-e880d974af04@kernel.org>
 <20260414021219.wayysugpfbzirzh6@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260414021219.wayysugpfbzirzh6@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 5pfpo7qtkbcy95cih6ruatad9g4nsabm
X-Rspamd-Queue-Id: 7107A4000D
X-Rspam-User: 
X-HE-Tag: 1776159140-742866
X-HE-Meta: U2FsdGVkX1/gZQ0bqDdxjxqJb1ykdE7HqKOr6oVo9VXEfRRgyigDCwYyX846bGigSH4/enGP0s8+fpSwodmkIB6g5ZXWGWJShAMvyloa+HBgE8kbi99OXDz/IH06a4j3zv2QCMAl1dQC/Wc9A3nF3l2csMsGnmZ38TJoexmUaid9e6PrjlgTJP+Qst9Rastmq/S7eLk+WxrwgkN7l2nfZGspOzDfHq2TlRTm5q/GfSX/UxoxfSbakUKnpi4qBY0a7JYX1gpdmoFToQqHpFfEJsglHieq8cSNROOqjjBP1Zk1CsJOBc1m6JEtBKuuRSXUkfwKk5tdurl7tgJESC7kqFaAacz4EZvAtu1SdqG572+101yoghT5Er0XcEydkapi4UG7IEX7d5K8IqbNWT85C1BC7rLOeMnMS7jlq673y53oRNlSTcoXeAAOv0Mpq/KB1vWpaTvxOh/qGjWfgCoo+nB0E9BClKuOkbsBb2iQGUEKo0APSzZyjX89KUKV2xQzLBNt8u537IdI7vOTDzZWLe/SGi1iei3pTZKqKFb6DnBxwi9QmZSPjl42hLSohGz5A+bO7/ib8xazehTFxiBd+AS9tLHBdsg5LNfh4eIPOdHByAZEP6NlJnQhF9SJ/RWZCrWOE8Simaclb3j4u9TddPZZBOzYuALOXO4PZZjtLrdCbiQBOWrGuHBKdFTFE4le90VCKNbBs1ZKJZca2l1aBgq3mBnsWO89IGNVB+FMKqQj3Bap1GkfwqY1coqDEU1tbf/s85Z+KyXFHq5nRKKfqxVlCUj+VuEutugSvKMQ3INYm6n2h5T3E/i/F0+8F7PmfvcRnYPTqiPdgdcfP9VbQzn+Bq3GVob9jAUVqg7aEs8Y0/d8j9S3j71bjBI97A582bVLoCh9PuVLf1aLPLrqbDiWGbeQxk0PJcaEa1ebO1C6GsKYVUZ9zQiBk8mWIkUe9cQznJu8m2kUAmkyV2w
 aTDdOtIF
 dZxFYu4oL8nko5wqp7lfasmEPRkxGy68EjHA//b+fur2u6E2fMdU9QUamjDAJ27zkjp+nZztn50jDMt8tAtG+TpPLDXn50e9SaWJn+w8PKIfjYjJRfFiS6Gohp+U8dN0Ma0wli3ynA3YFb/LjcGQG/4k6r03kXp21FXiDD/XpgBvCYtkMXMqtNnkIacTli+IvaWLLZPZikyg+lP3tlryv+j2zJcuKJy8FwzXSqF/x0Si+TzIFhJ7rt0WGLalO92DFYMMaNkyito7HZNCwhNLjM4v/Ivb8gjyYBeFhfpuspylKRNWLRoav4tqGzu9OQokmdKViJ/hhcKHsnvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 04:12, Wei Yang wrote:
> On Mon, Apr 13, 2026 at 08:24:05PM +0200, David Hildenbrand (Arm) wrote:
>>>   With the last memblock region fits in Node 1 Zone Normal. 
>>>
>>>   Then I punch a hole in this region with 2M(subsection) size with following
>>>   change, to mimic there is a hole in memory range:
>>>
>>>     @@ -1372,5 +1372,8 @@ __init void e820__memblock_setup(void)
>>>             /* Throw away partial pages: */
>>>             memblock_trim_memory(PAGE_SIZE);
>>>      
>>>     +       memblock_remove(0x140000000, 0x200000);
>>>     +
>>>             memblock_dump_all();
>>>      }
>>>     
>>>   Then the memblock dump shows:
>>>
>>>      MEMBLOCK configuration:
>>>       memory size = 0x000000017fd7dc00 reserved size = 0x0000000005a97 9c2
>>>       memory.cnt  = 0x4
>>>       memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
>>>       memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
>>>   +-  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 1 flags: 0x0
>>>   +-  memory[0x3]     [0x0000000140200000-0x00000001bfffffff], 0x000000007fe00000 bytes on node 1 flags: 0x0
>>>
>>>   We can see the original one memblock region is divided into two, with a hole
>>>   of 2M in the middle.
>>
>> Yes, that makes sense.
>>
>>>
>>>   Not sure this is a reasonable mimic of memory hole. Also I tried to
>>>   punch a larger hole, e.g. 10M, still see the behavioral change.
>>>
>>> The /proc/zoneinfo result:
>>>
>>>     w/o patch
>>>
>>>     Node 1, zone   Normal
>>>       pages free     469271
>>>             boost    0
>>>             min      8567
>>>             low      10708
>>>             high     12849
>>>             promo    14990
>>>             spanned  786432
>>>             present  785920
>>>             contigu  0           <--- zone is non-contiguous
>>>             managed  766024
>>>             cma      0
>>>     
>>>     with patch
>>>
>>>     Node 1, zone   Normal
>>>       pages free     121098
>>>             boost    0
>>>             min      8665
>>>             low      10831
>>>             high     12997
>>>             promo    15163
>>>             spanned  786432
>>>             present  785920
>>>             contigu  1           <--- zone is contiguous
>>>             managed  773041
>>>             cma      0
>>>
>>>   This shows we treat Node 1 Zone Normal as non-contiguous before, but treat
>>>   it a contiguous zone after this patch.
>>>
>>> Reason:
>>>
>>>   set_zone_contiguous()
>>>       __pageblock_pfn_to_page()
>>>           pfn_to_online_page()
>>> 	      pfn_section_valid() <--- check subsection
>>>
>>>   When SPARSEMEM_VMEMMEP is set, pfn_section_valid() checks subsection bit to
>>>   decide if it is valid. For a hole, the corresponding bit is not set. So it
>>>   is non-contiguous before the patch.
>>>
>>>   After this patch, the memory map in this hole also contributes to
>>>   pages_with_online_memmap, so it is treated as contiguous.
>>
>> That means that mm init code actually initialized a memmap, so there is
>> a memmap there that is properly initialized?
>>
>> So init_unavailable_range()->for_each_valid_pfn() processed these
>> sub-section holes I guess.
>>
> 
> Yes, I think so.
> 
> When memmap_init()->for_each_mem_pfn_range() iterate on the last memblock
> region, init_unavailable_range() will init the hole.
> 
>> subsection_map_init() takes care of initializing the subsections. That
>> happens before memmap_init() in free_area_init().
>>
> 
> Yes. I guess you mean sparse_init_subsection_map().
> 
>> Is there a problem in for_each_valid_pfn()?
>>
>> And I think there is in first_valid_pfn:
>>
> 
> You mean there is a problem in first_valid_pfn?

That is my theory.

> 
>> 	if (valid_section(ms) &&
>> 	    (early_section(ms) || pfn_section_first_valid(ms, &pfn))) {
>> 		rcu_read_unlock_sched();
>> 		return pfn;
>> 	}
>>
>> The PFN is valid, but we actually care about whether it will be online.
>> So likely, we should skip over sub-sections here also for early sections
>> (even though the memmap exist, nobody should be looking at it, just like
>> for an offline memory section).
>>
> 
> And it should be like below?
> 
> 	if (valid_section(ms) &&
> 	    pfn_section_first_valid(ms, &pfn)) {
> 		rcu_read_unlock_sched();
> 		return pfn;
> 	}

Probably, yes. We have to understand if other users would be negatively
affected.

> 
> IIUC, this would skip hole and leave allocated memory map uninitialized. And
> then those pages won't contribute to pages_with_online_memmap, which further
> leave the zone non-contiguous.

Yes.

> 
> But we want zone to be contiguous when we have a hole like this, right?

Not if a subsection is marked invalid. That's why the existing scenario
is that it will not be contiguous.

Note that Wei reported that it was not contiguous but would now be
contiguous.


If you have a DAX device the plugs into that hole through
memremap_pages()->pagemap_range(), I think this could cause problems. I
doubt that this would happen in practice for such small holes, but if
they would be bigger, or at the start/end of the range, it could be
problematic.

-- 
Cheers,

David

