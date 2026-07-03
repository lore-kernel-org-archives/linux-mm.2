Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C46BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 05:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3606B0100; Fri,  3 Jul 2026 01:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB7C6B0102; Fri,  3 Jul 2026 01:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0F16B0104; Fri,  3 Jul 2026 01:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 810F16B0100
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:30:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECED912042E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:30:47 +0000 (UTC)
X-FDA: 84946340934.20.CE83F2D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5200100009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:30:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gRZT5Ayc;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783056646;
	b=EJ3usfb6lhlIjU6fJatbwpeCG5ZQDu9RQ/EESTYMikxVNDOf7T0pZA77VP67DmUYHCmikw
	Ra83HidHjUCyrz5PLUZQdLu320BWtd/uc7BcTwuSf9UCSdLKHUDOWfso9RaUjWAAW+yZHs
	6qAH2lcIrqlQxEYeAJhLduBuj5DFL+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783056646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmNFIi7RnnrypKskw6fwxOk6ivWwb+ik3iVKHlwrVrI=;
	b=v8Ape54CecMUXFoZTp0rdPcJjYE/dMTQg1qk7KOMAbJjX/om910dkSvpsSdYMmWSrE+dwL
	sSEiMiVvUbSlaf8N+0R79bqHtpgnclWbYm2B2Ccsg78EibIb5FC5R20uE8qgnFjlazBEeR
	wfERbyMDb2YJfFGXwWAMo1jx5GQAax4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gRZT5Ayc;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19BAB1D34;
	Thu,  2 Jul 2026 22:30:40 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93E953F673;
	Thu,  2 Jul 2026 22:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783056644; bh=x/FZbZRvlfgDKJ87XGqUbVjYmJN5YLYtikgDpbbk+3s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gRZT5Aycj8nb9nzE9CkfCAmO1Pk+zt96vwJ0a+6cKk6Wn/mIV1tYxcrUG/53HkHzj
	 hn2MLdJulVDpzweQyjtnhqxSXAs3RDgKOuCTNjnCpg+4zOinXDuxDvU/Xyloz5ww/k
	 V36SggskoTyyC6c++z8jGDd4uZBRW8buLuFGqQZY=
Message-ID: <1ef238fd-232c-4b8a-b28d-cd20db57bcfc@arm.com>
Date: Fri, 3 Jul 2026 11:00:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] mm/mprotect: use huge_ptep_get() for hugetlb
To: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-7-dev.jain@arm.com>
 <f1bef34f-987a-4a47-99fb-acdeda1c072d@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <f1bef34f-987a-4a47-99fb-acdeda1c072d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dqpybaxwudzhz3j6mfa4ocah9up15gpu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5200100009
X-HE-Tag: 1783056645-415404
X-HE-Meta: U2FsdGVkX1+shLIuy5o8E0UZpIMV8EB4ouV4CQxqPdOQm69gQPDG6XV+xWcRf+AoRTn+RtPuSO5ZBYEhruDMx3z0bWo3vFjA6SP1vAFy0a6ojNnw3XoCfyZ44ppVI1PjpKxLg89Ed1F80XpdTvoNp7/i1EZGA9F9rEZrOiS6BtPjkCsxOqpJQj5yCZQlrhRYpVf3Kk6fYtxN29OZc1QgPIMliLXCfF/9djl6Y0h7ysuGTeZNmP5OqOda/CO+dFqHCpLuNKMASiWrOSMGnJ1d8scZey/J822PpmQaXda6Z1bOJsgxCcUqeFhgFFgo5RKz8gb+CCNqWcrzGNoes6eI3kDQHzt34Ohc6ILjLefDn7ta5IMbq+aYrhOOof/nSrxzp4+kliw3AtVHFe6ohXJ61MmbudqG51eapFQ/fjyb8sBr81XGiXQiJRShzoVurGqEIJE7dTQqEkLlwuYLkHovmaZeqciygeVtfSpTUQXw2yZUlQ+gxSWtt/UjfyjvhTV5jYGtAao12WQYPnKnlLq5hm8LGpz3dKryR8U57CQvyvLqEv11e2R5fyhT1y+oDimGyW0BoS0dhJroUwvZ/9SeE8ODwfp9k+ljM1++LkOvcA0gffoab7MsTSC+k+N0NbXF/3ocJRHjpmru1Jsfo50bgMA7ehf9sdpii+yJCXDglGEJs+M/0mx6AUHmryc1fc0eWWXTOFPMhLf5+aVyNAAU4otSy3Ji5tTzruUFHZ/5HZIQChNfrTJ4kWgp1lZmbdwun++ja26zXRidCRzOWWPebswtZitSSSdCpQARIqwqIdfdvZlqzjtGP/XzO8Dzr6sAkBtzqA2Ge5WdE+O5EhNpscbKzXnXAjMa6GZb72Urb0ZB+6zkJLq537S5L749cAFdRU0rWDB5ea2yXYA5ic0TfCTF0va6Tgx944m3XoY1hWYh9VLICjVFJCDwPDHD+sFjNVwyHSydqxu6D5As77g
 zxmBoWli
 /D6c1mpeKQfCEGKmiz/NKFK2N829avdKmpK6E2ZRLo/h0IaqCbvtyqhfUqAt6Goy/NLfsgTfZinC2277ARj03Vsgm7SgKDP3Pf8UzOromQME0GzJUGBGkxmVRuVnwpO/60Vn41+quCXjVgyWucn58lYshWfzbAI5UUcNuxVbG8gPb1p0uSGya/3BVIIcGp0dTa1NfBbpVBscShItiQ3DJLrCzuEWyHkpRNap/CtHYc0vbU1BFbeW2Uh+onWRQUiEUPV6y6hjsCOMOM9JV/fkzrkuUox+sGOPZv4ByemyPmUm2Vqq8/pR1ED5gWUq7e8dVwITRq/PD6TEZ8GLqM0w5ShhYZSbPv2nImjFynr+d/JcGsn+Juwp3nbYjji06VB07gUsbA+zD2PAq7daFVap8WikaxncmNyuXakq5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/07/26 9:17 pm, David Hildenbrand (Arm) wrote:
> On 7/2/26 07:13, Dev Jain wrote:
>> prot_none_hugetlb_entry() is the hugetlb callback for the early
>> mprotect(PROT_NONE) PFN permission walk on x86.
>>
>> The callback passes the decoded PFN to pfn_modify_allowed(). For a
>> hugetlb callback, the pte pointer refers to a hugetlb entry. On
>> architectures where hugetlb entries need huge_ptep_get(), reading that
>> entry with ptep_get() can make the permission check use the wrong PFN.
>>
>> Use huge_ptep_get() before decoding the hugetlb PFN.
>>
>> Currently there is no path which can trigger a bug: huge_ptep_get() is a
>> simple ptep_get() for x86, and the prot_none walk occurs only for x86.
>>
>> So no need to backport - use the correct helper anyways.
>>
>> Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/mprotect.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 9cbf932b028cf..23779632d18bf 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
>>  		0 : -EACCES;
>>  }
>>  
>> +#ifdef CONFIG_HUGETLB_PAGE
>>  static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>>  				   unsigned long addr, unsigned long next,
>>  				   struct mm_walk *walk)
>>  {
>> -	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
>> +	pte_t entry = huge_ptep_get(walk->mm, addr, pte);
> 
> Nit: can be const :)
> 
>> +
>> +	return pfn_modify_allowed(pte_pfn(entry),
>>  				  *(pgprot_t *)(walk->private)) ?
>>  		0 : -EACCES;
> 
> Indentation is odd.
> 
> Can we just make this readable?
> 
> if (pfn_modify_allowed ...)
> 	return 0
> return -EACCESS;
> 

Sure I'll do this.


> 


