Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599E9CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C7E6B00FC; Thu, 25 Jun 2026 03:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313AC6B00FE; Thu, 25 Jun 2026 03:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C5E6B00FF; Thu, 25 Jun 2026 03:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAA9E6B00FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:54:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E24E1C33BE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:54:27 +0000 (UTC)
X-FDA: 84917672574.25.A6FF698
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9A7D120006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:54:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UzCdDwJa;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782374065;
	b=NkDpxjWkWRNLdBxGfFsiE2rHBWtCM9Gi/X8v17O4CDsJaDx+H+Ms1ZeosNh21wdXDDBoH4
	VtbHMJwXQsAwWZ78LeIZ/DsMSBl40tyX/bvfmLp0PnDGfTLCDzCfgZxMlF/aPgWz5Ltk2R
	ASsWdVvVxgpxPRpMoiZBNxWsnNno/wM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782374065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WU+cwzv11oA1r4PZBo7/cWtaeUDfFADOwM24rd5Wf4E=;
	b=HTavc5lukXI1g8AfIC6KVLMfE1Rw7KtuXQS0Zb9oPVWl1/33vrMlidY2MUto3HZ9tmGOqm
	ciozi31pc4Ii12L5aqQyDwON7w6pcezlxglm96kmriAOAX3grbbhSyuTniVnSDTA7I87pi
	NJ1uWnLTSMijgeLKkqjLvrTQcOE20Sg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UzCdDwJa;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1D2E4190E;
	Thu, 25 Jun 2026 07:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0E1F000E9;
	Thu, 25 Jun 2026 07:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782374064;
	bh=WU+cwzv11oA1r4PZBo7/cWtaeUDfFADOwM24rd5Wf4E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UzCdDwJaMRxT6Ty9dADQAfJYjrRCDDsxaL9K5BGYHTqPC3Y2IxTqkLlkB3sja1m4a
	 bfprmOkTsujYkG+v7SThudFa0sqX2htXOGFfvC08rNrNtOImKwhlXWd+/B3HRsQwYV
	 g7466d4qhvzZ3u/1T7TG1ecvxubZ72BjEbDFGObYvbsYMt+904cMY0y3SpFFlXYoHJ
	 WNkO4QNAjplhqOrNGWwlZfu+PZnplMloPU/T3jVLvHK/nTMuITCjvoWouhfs/hub6x
	 5VJ2xntNkzgBTwkXkUOZA2q1SaU5SC/NIYhYM/vVJHwa9wxqSnRBSGIhggzZE8f174
	 FH6lZpWGsxS3g==
Message-ID: <a4fe8ba6-2ecd-4bb9-95a9-27f9f1e87d2e@kernel.org>
Date: Thu, 25 Jun 2026 09:54:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Dev Jain <dev.jain@arm.com>, kernel test robot <lkp@intel.com>,
 akpm@linux-foundation.org, ljs@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260625042853.2752898-1-dev.jain@arm.com>
 <202606251341.jfIr1D7m-lkp@intel.com>
 <2fd3688b-b4d0-4a2f-8d49-4d4b9c512c66@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2fd3688b-b4d0-4a2f-8d49-4d4b9c512c66@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: x8895eimy3wtb5dkrq1de9dww9a8973o
X-Rspamd-Queue-Id: 9A7D120006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782374065-380813
X-HE-Meta: U2FsdGVkX1846CHD+CKrps3PqUiyNRBA8NyBVivxPcX3yN6bZhqnFItEd2XCGl6Kas8NIuJ/FN1hEbNcslSVMwTRopn81hbvek4twLfT1QzUmHR4TOAKbUEuF7OyDMRp4mpesg1O04+hd9vbESm6NtfmgXQcTm6FAP/6HrE96/XeDGm7PX8OgU7Of9cT+jQ2r959mEQhV8jQj8xSfEmZvoinCT7zcuZ3G8aY3eta4nvA3jt90rp3A3pcRbnantiJkwKVSeHjtfKfBLzUmEIA5hx4M7ZwDJepRw8vRotuuZ7NaWbrPnmwiISVhDla9TdsQoQf+9x1IITL1440xAtVqJnujRIGUPTWvkwF5/QTZ/DuDTTR/1aewzOF2b6mUI4sdBHSxeZbow/vGfABKff4QPXIRymbEnqHBAWpwEPCF8LLowt59ywgGO7GbVGpUXR6snUdZYiCaSQ/QxFBBycMest3EH6Lgryz/LteL4C/MHxtc7GyFLbeWhSVbahks3jKkPoIA4tZl21WeUWxAo5oh+ntgvjugklqHo80AEiagvQq1Z0Q4kuRVPsVj0QIdhxaKRRTqqVbb3voF1tBIhuQdWGsBbfmS6W+pM92/4uw6goWmCq7/lr0FGjaOUH+AnDoyWW7M9gg+tPgnHGbfAojqQ9cc0lK+ztaNaRBlHWlg9YNxV5fM0l1B9f4gyxke4NSXH1YIXIE2g1TRACFyOw4S45xAWfxYx2w6XupopGf6MwYIz2tCfTQ4Ts1WPnTKo9Mkr/4tPxaG/YhKep61MkM6iYZE/e3C1WowdI8ZnKB3KHBbAUBgMy9c4wkIVtIbMb+iPjHQyPPwJ0eL6N2KppKTh/bZAqSCn9zOGCvcxn9pUIIz7WVcrYywfaVi2ygqDQU7qXmbcyCiQEQL/HG4urZW+TSwQ7OfCr3kKWEFxGdjwKUFYNdD4kR4vG2cRjzHjeJyy/4bTKOucmFpq3Vzwg
 LRtyCh01
 46/HZeQRh+IXsW5ytk/sI3RQ9ThZJhjNqenudRSLnftUhO974Y7aFL5LYNeEazsxO0BV9z0eq1+V81rA39QtLRLOtekYDUeTuzgM2iQoNKUIKy5v99JW6OMVPCIW3Ice1GhE2z/O8mg8f+ty1U0IQS2uDpH14dm1gaQGPBhF2r9aLy3F0bTWfqelO3dF+FwCLxUq3eJvgdgcWKrWdu+asfoB2ii9EMuTn6Iqu3DGiRRJ29q1JZtFFJsN5lT6PtjAIl/ylZBDHimxT3vy+egMI0O+FO3OFHFVhc3jszMplnjxYTt9ZcGAkY1TqlFs2SFrmynG9kR5iffhPvEvmGC0GZ5EIVdUvzWDy+kaoeSpdcGbE2xQ3omIcqf5Qsq8puDsKCfgKU53IoeFxMhRReUHnyvIm1NZW4LuMluMfBsYEU4QZY1t03d6xkd78EzUXHMCrJZmOy6dOLCbJFb2IveLL7YqiakG9MLaXXJdyxQ5NK2Wc8bWjvwSrDAj3fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 08:59, Dev Jain wrote:
> 
> 
> On 25/06/26 11:15 am, kernel test robot wrote:
>> Hi Dev,
>>
>> kernel test robot noticed the following build errors:
>>
>> [auto build test ERROR on akpm-mm/mm-everything]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Dev-Jain/mm-rmap-use-huge_ptep_get-in-try_to_unmap_one/20260625-123050
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
>> patch link:    https://lore.kernel.org/r/20260625042853.2752898-1-dev.jain%40arm.com
>> patch subject: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
>> config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20260625/202606251341.jfIr1D7m-lkp@intel.com/config)
>> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 6cc609bb250b21b47fc7d394b4019101e9983597)
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260625/202606251341.jfIr1D7m-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202606251341.jfIr1D7m-lkp@intel.com/
>>
>> All errors (new ones prefixed by >>):
>>
>>     2100 |                         pteval = huge_ptep_get(mm, address, pvmw.pte);
>>          |                                  ^
>>     2100 |                         pteval = huge_ptep_get(mm, address, pvmw.pte);
>>          |                                ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>    2 errors generated.
> 
> Weird that I need a stub. This should do:
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 2abaf99321e90..4661f88eee55b 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1261,6 +1261,16 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>  {
>  }
> 
> +static inline pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
> +				  pte_t *ptep)
> +{
> +#ifdef CONFIG_MMU
> +	return ptep_get(ptep);
> +#else
> +	return *ptep;
> +#endif

Without CONFIG_HUGETLB_PAGE, folio_test_hugetlb() == false and the compiler will
never end up actually linking this function.

So probably you can just let the linker deal with that

pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);


If abused, the linker would complain. In you case, the compiler will optimize it
out (and be happy) and the linker will never start looking for the symbol (that
doesn't exist).

-- 
Cheers,

David

