Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF1ACAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 09:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A1F8E0005; Sat, 20 Sep 2025 05:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00E88E0002; Sat, 20 Sep 2025 05:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917CF8E0005; Sat, 20 Sep 2025 05:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 808A48E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:02:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0EC811B094
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:02:32 +0000 (UTC)
X-FDA: 83909037744.07.4B2F01E
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id F38AD40005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:02:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MPiIqZWI;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758358951;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hyTARRRWG2OsD6nalitLDnC2TVw2fWAmobZDB8mrABg=;
	b=bbA5bRWNwEBxhlqT9huLV3CFDyW7ZIG4EyAyobH8+AXI4iLwJl07RYSVAaN1oCQikBuL6F
	VmroqigHP3cIJ80fFyrKT4CPDWbo74537rhs3lMjD/W1TNI5rJdHXe5uQetQasmyhJ0glj
	eAVjpN7MMo04KxCdFWEArjeeAuiiDeo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MPiIqZWI;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758358951; a=rsa-sha256;
	cv=none;
	b=yE38NrChpz6hhjj1kSkoo5Ny0JMcLMC1JznzybW5uW6h0xtyfwCbE8V5Fimy3JQmC0cr2I
	AKEFzNXoa2v+mjkkteqJcWwJhQvM/fDJBtqzmqVmnlfu5UjxARMaIFHQm4r7mgVc3r160G
	kCF+4p0mkrAHwrxrQT60XpgLqeproEo=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b04770a25f2so458598966b.2
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 02:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758358949; x=1758963749; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyTARRRWG2OsD6nalitLDnC2TVw2fWAmobZDB8mrABg=;
        b=MPiIqZWIr2w6M0Vw5aDWq7aBDviiSUTaEvjo4kr13L5631jkP5Wn16vXCzbO3EIuL5
         U7vHke3S59HqriDc9GU//7GL+9YBC348mvWCS9ZrK8fYVMQv/zKF5KoCv6WclrdFTybX
         WXmz3+2eJxtLw3xlEJYKCiO7vAFbtR+XoAd8rCYa1TZD/WfpWCEzV6lOpF7xb/DcRxHS
         E2xU/E77yOifgLDgagJqXRWXBbTSZc3IDXbqjDI38NAujTcoZWiKLLg+9lefvcbvEdWo
         fruT8O7hJ1l8zPkT3bwemC4tucJ/KKtc+K74Qj3RFfn+dmIG1DW8DZvOWeSKHPFFnwhe
         YMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758358949; x=1758963749;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hyTARRRWG2OsD6nalitLDnC2TVw2fWAmobZDB8mrABg=;
        b=GSe4e0l3f8tjfSoK5ojbsUN4ZbTXn8mHH+hvnYXd1AG5LS2LoXb37JqJJhrhLmub1q
         L6c3Hc2W1rlbymfrbGPNFhB7LDoKep7fzn8uH1sSeiNRibsjPZIYUtnCKWrXgEPvuln+
         sl6I/nQaEOoVnyQiYmgw6iaxJmU7QICeVtbgL60XnqVorQCm3hx+4w7iar8S4cFx9qIO
         s/936+218iC7/bTUoMLgJTpk38bqS+yhkTyDnaEmLPotkJHXMB8fLtDsG+6gnTHBlK7w
         lt4twGDPQEOAmGtzLzLemyqVB8PflgDKbcmHeMLdIQO5xih66217prSkivDl+w2SBobz
         dqdw==
X-Forwarded-Encrypted: i=1; AJvYcCVUPYjM/U/25jMCszD7P8HTu8Fx5NiwCC2a5WMH6rEZZqgcRT8TLB1mU9BDMn0RYjRt+d+FnE7f2A==@kvack.org
X-Gm-Message-State: AOJu0YzfVbLK+I0Pl48J+cDeIjbxnERlxo5wJNYiNn1yJBycxGm+ugZU
	Ddv23nb8QjNUjXKoLwo0YeVQ0ryfrWv+2CxvSVrL3HuFdLOMQro+suFi
X-Gm-Gg: ASbGncsXG8W1Lm2TDuBjXB/ZUcOlZuApsZTYLcD6UBNqTKrp5DZ/2ULBeP5r25D6QtO
	W8LmBJSQUM87v3buvGfOTJQxW653folkJW2IBOmx83Cg2slojSH3Q1k463A+QgeN488+mnidosH
	gDfEbGxSRbypOKv6PDJXQ+QZ8HSClaQopdHLIdEtB3om7uB6vK+FWoIJFpJ3COl7DaRpAH4PnFa
	BdFkmWVEjxErEKXRZMwZeTFkb0C9rdaD4/Y4s6FsjEWpVtX33bGHc+JFtQNuMyMbByIUqf5O0e7
	Q+VOAia9e3jBMdmxfh55O5w4cuUaL1h/rq/NiOW1Uul5xoNmtCtpfvVbl0BRtujHMK99I2Y987D
	Hocsa2UlAAD0FJ9uXK6+vcw==
X-Google-Smtp-Source: AGHT+IEo+VIyWFD9iOFcj64I1S+5r3U4VL4Ub1XjuGJNb6i8UBZM1iHUfGsH0kWDhm988sVNri/EHA==
X-Received: by 2002:a17:907:97c7:b0:b04:8358:26fe with SMTP id a640c23a62f3a-b24f32c9141mr635985966b.34.1758358949420;
        Sat, 20 Sep 2025 02:02:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2954c269fcsm24695166b.9.2025.09.20.02.02.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Sep 2025 02:02:28 -0700 (PDT)
Date: Sat, 20 Sep 2025 09:02:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
Message-ID: <20250920090228.lovkrpwj23bqdamj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: F38AD40005
X-Stat-Signature: pzyftig3o8sour34sjxwy4kprn35ezjz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758358950-647012
X-HE-Meta: U2FsdGVkX1/YbX435Lek+du2JGeKOM4aylSTNynDIe9pf75SBj0MPHoS0U6MserUApbAC6xNeHWjog1ucqY0xOekMnU/ZbJ6o9S4HgSJ4DeDdV9YbYt+TiVhh1S9LG6d5u0ZbgqTD7luJRt7276VZAOhhGHBrNzS9e5pUTkdSf7IEZmEt7oeyHzvaBKXrgRYY0GvbOnAvM419QqI4LmDdXoqd9sIpDL223s3btKUgL/s9fWg6z3HXgErLfzXIkbDOwNc+TWFMAEfNC3XfSebcQUI0GMmyVaa+ZoZlXjHbRINK6KhqNuEms1r68JDEp47G98xbudO096LmpHFFS69bWFUij6eP2eEczIrNyb3lbJ2auNw69qphU7HqxKhUXBn5S0MQnyxW/85Z9iAGeDd140QxmjhVXHJCXLPOkKYSK1F2OH+XodeCQNpk4zqLs3Q3Brmvb/YVS+ERsORfQ/vf/DlfK7kvpl9SqRaXrQhXc4xVQ+Ky8wnN/4/5a37iTUIJNS3702qi8g2hvWm5QoPZpp04em9DdTrxJtm5OkSfHaiHGn43VlNnXDwuqhZlpg/VgQg/4x7CnRAKD4rSldRRo8lHjuLCfkDcCQX1wK8KHmHD3c4VjbeZybB8qWgbI/JKaR9cTlJgSpUKhlV02Ge4z6zTd9XCW+eBSX880c47crS7Ldu9BWLLQsWuhNBosigZXDkl/5Kp8RukieTBMnkZYi2L4zI+/DwCpUTLUKk0jOAWx0AXN4wKMaoNOvnovOscHZp2gxkGuS8nYeZe9/+BGvuRyLxylf+8cKqpw+X5koRxEYRRx9HZLAnK2YGI2ROOZ+1t+VsY8/XjqaLywD7bOl1YvvLEG1W8aI6im66GGCLye5NEOZS9Ka2Ol9h7CGX8EDVHfjJN4zCy804VJoNSxFeBB/+h7tQEJcy9fPePapFqMI+qBtCxLp69miPYWvQZkTB24Vl8313KYUAw4g
 Pin60xHr
 9Zhp2pfyaWwqCxEsOXXIoC7ua2YSlxEcEDT7V7yncaliR1rWOJdkWY3GmpN4OpXdUs/ckPwVOvfjTR3p2jTWumbWwVWgXfR5u8xDT+UC//s8QOGh48x761QrCwoU2zsQsNkuB3hRvHWhYTxn4cSXwYTpbjRTIpFD1XCsrPuzPSl4imaTLkKWIoqerYFGDTeDmNSoM8LB+vpZD3Trp7vnyXPTFZyc2udisu+PKLkZqOVX1LWncsaDUc57hWHIszEAX/Ak+vBLaAN+iI1NPlqU8Fg5mF0/emSO3o3ZzwRSMBBlYDAsCpVFBZBmmnO4QTRdlwAm580uxq2E+1Ta5/4+uvidvu09ED9ECYg3n956EhiYtrhoEg505wDSrYTj4TOXbaivyCneTKeVXEnT8oPg3aLmWS9gX07ctz14COGuisLJw1LhjVdz7pORQ+N7zJU2CTztJQ8rRVUFbXjAnmrX+wHvuz9S5+xHQUocSLS1EiG1CrO9lVOS+CX+25U93swlO1aJtEVlQYC8l48BmuOs+g6PKgxypjl/irGxUdMPRmsJJzdDCdVpnbUJk+EyVrf3yIwZQEW9eY/sReEJF3AFbubX36zoy7AKsC3HPOBet/mXuxwkNkp/Qdqgw0d+oXLAJRmgyZfqkJDEKNziM+oTIuGaSbRlTNDLhawXFElfwkZYVEFopghET+aqiNtyUHcVdiT1a322PlKuTgV5QkxJBkhCpkm5SOSJJ3xUaT50XvkxxSfjZb4BaElgIXkcvjEz3CvBYW6TebmQS6gIDIMj0D3S9EVHUazy3/ShrmRmtk3ds3K9cY1SKxjmcNqCKnfYXcVJDSkrKV8M5xS8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 10:21:56AM +0530, Dev Jain wrote:
>
>On 20/09/25 6:24 am, Wei Yang wrote:
>> When collapse a pmd, there are two address in use:
>> 
>>    * address points to the start of pmd
>>    * address points to each individual page
>> 
>> Current naming is not easy to distinguish these two and error prone.
>> 
>> Name the first one to pmd_addr and second one to pte_addr.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>>   1 file changed, 22 insertions(+), 21 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4c957ce788d1..6d03072c1a92 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>   }
>>   static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> -					unsigned long address,
>> +					unsigned long pmd_addr,
>>   					pte_t *pte,
>>   					struct collapse_control *cc,
>>   					struct list_head *compound_pagelist)
>>   {
>>   	struct page *page = NULL;
>>   	struct folio *folio = NULL;
>> +	unsigned long pte_addr = pmd_addr;
>>   	pte_t *_pte;
>>   	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>>   	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>> -	     _pte++, address += PAGE_SIZE) {
>> +	     _pte++, pte_addr += PAGE_SIZE) {
>>   		pte_t pteval = ptep_get(_pte);
>>   		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>   			++none_or_zero;
>> @@ -570,7 +571,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   			result = SCAN_PTE_UFFD_WP;
>>   			goto out;
>>   		}
>> -		page = vm_normal_page(vma, address, pteval);
>> +		page = vm_normal_page(vma, pte_addr, pteval);
>>   		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>>   			result = SCAN_PAGE_NULL;
>>   			goto out;
>> @@ -655,8 +656,8 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   		 */
>>   		if (cc->is_khugepaged &&
>>   		    (pte_young(pteval) || folio_test_young(folio) ||
>> -		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
>> -								     address)))
>> +		     folio_test_referenced(folio) ||
>> +		     mmu_notifier_test_young(vma->vm_mm, pte_addr)))
>>   			referenced++;
>>   	}
>> @@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>>    */
>>   static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>   				       struct vm_area_struct *vma,
>> -				       unsigned long haddr, pmd_t *pmd,
>> +				       unsigned long pmd_addr, pmd_t *pmd,
>>   				       int referenced)
>
>Will this be a problem when mTHP collapse is in? You may have the starting
>address lying in the PTE table.
>
>Personally "haddr" is pretty clear to me - I read it as "huge-aligned addr".
>I will vote for naming the starting addresses everywhere as "haddr", and use
>addr as the loop iterator. This is a short name and haddr will imply that it
>is aligned to the huge order we are collapsing for.
>

So your suggestion is 

    pmd_addr -> haddr
    pte_addr -> address

right?

-- 
Wei Yang
Help you, Help me

