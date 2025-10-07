Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A2AACCD185
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 08:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399A68E000C; Tue,  7 Oct 2025 04:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370EE8E0005; Tue,  7 Oct 2025 04:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADD48E000C; Tue,  7 Oct 2025 04:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1909B8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:32:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CCA613BCCE
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:32:20 +0000 (UTC)
X-FDA: 83970651240.13.CF0F4C3
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id A1E451A000E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:32:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=poFK5QJq;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759825939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=708hk4v3K6U22ycgyF+Dfx1gxlMvrf8ku8x+RwSAqRg=;
	b=GhOTfF4UAC3oBDAS2gHbZKMd9as3xqRAs3V8+lC59xUrR1cCqUO+wX58L6oqUQHptLH/Rb
	vzBv0FgyhL7GKNJgZDeKtZYI/icEnpdiO5GAzbnghFQMKIiLaR0ZbVRAddtfcS9hE6FgeZ
	tkifcEzyZgRBEtlx25T1C00CuJd/o6Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=poFK5QJq;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759825939; a=rsa-sha256;
	cv=none;
	b=LP7JPNuTiJ0wMfpTeyUlYOh2uPIUhYOQ8h35Sw58WZGYENGU1aXtNTCna8VifYPjS4IvD5
	vaT3zo+6UL6cZexGawKsQMmr5YfupQPGWMQehpqJvm7Y1qrKoN9GqA0X8r4VZBw57lQuXR
	CljEq+TpG3XCVn8Hs0k0LhGgMgEVI7k=
Message-ID: <c89256b8-bec3-4bc8-8399-cb44794f70f1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759825934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=708hk4v3K6U22ycgyF+Dfx1gxlMvrf8ku8x+RwSAqRg=;
	b=poFK5QJqDXcZYwm/pfaHunbTVH62Gwx6FqZESEIDH0vgX6lQXYC8rbj8UPeUdHGaDODAak
	viQKiHuOefku37kxtGPpa8PnhP8iE+Kns9Tw5w4yDfaA/0yX0DrIOMyBYXpPosVIo31OEn
	ki2kZeCXxQKJMQWzEEYm4GgIgb8sFXo=
Date: Tue, 7 Oct 2025 16:32:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, david@redhat.com
References: <20251006144338.96519-1-lance.yang@linux.dev>
 <20251006144338.96519-4-lance.yang@linux.dev>
 <586f6282-ac7e-42d2-b132-0ba067623ddc@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <586f6282-ac7e-42d2-b132-0ba067623ddc@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pt7kxycnbhjyfw4ksb39btwagxh8zot3
X-Rspamd-Queue-Id: A1E451A000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759825938-17406
X-HE-Meta: U2FsdGVkX1+jChQSdgDZt3d2vSZrSXW5a7bmPP+bwHXNrSTkbclAlTDNBQowNfJFx0iR/kDLHsJpS/6dd8PmogFnxFOeVLgjHlQ8xMFtgLaTpkjdDFUOYe4nSrt4dh8muJhSo6YSEU6oQ6CQstnLIWNHAJf8yhIlzSfbB+WccQ1QiDZF8hCKFtyfPCmAJux3I213iuC1PxIr6Isv+8OMoVpv4GUpVSbBMn4LFIlm6gDR7tCGgc2fAHYUg/YsEM/BEg7mLuWwTiu4wyZ0ALi1z6op75txKctH6dgGvlHlj5sROAkOQAuSNCd7nbZik7FsFI9Toy0e+Jbtmc1lPpCEJea/G5ZD4QNoFq4N0DEQOeHXXAzCT3uRxbKnS5dKN0U0nboQGTVSLiv3WyM9tX1COVU5yNoINjYWRd8RD3vMx0buB0l3Gqnh5qtIIHLa/KIq0+IGcpv63qvJrpEMAnCfKEENVc2wwCPGczjhDdvHlrfvGeAQZ9XJ2LnlBRs2M7Clm0rD8tweeXgm0h5bHEC4a4PMXXfN5mPytUjX0cXA1UWr0ryN5PdhVP7l/6e3tN4j0CSo9sfljZzQqsoYCPNOm/h3FhQeHZLFxRSy2scVQW9bfJf/a8h5nZ5DRhpuxgU/FJmmmTL0Hd1fRXJMvmQ1w8LLwJQDFRIh8FOblQmHEQyl8TySGaOASfYK7xjAViNs6xv38BX1rksI4Drvdj5ERlTAc2QAlrZmrdVn1HMQdyDOZPcYWQ72zX1MeSZyuYP3O0JTc44ltVWJpM6XjWu3CsFKtZxZ/s8XTSa02Jk7HUyrKnJgQFYlpgfQY/tMM6DxKQzfQYVJJfa7pKqlx3mnZ0Lrz4GCc+RM1gMlWMbZ0knpuxNAKsbDZrPjpeDmroDtYBcW5u8UGbqd3JNRA9W+i44htvUnkCqmrId78PuxnGyaRKSRz4BhASqolY4023V64FtL4Qk6IO0F/j4rL1c
 riwOoyDN
 xPzYJOdbxEQzHlBgD3jaAOIJ6+29SuzAiVbbr1ThUdlQwK9Ll4tsPtKqpay98IQjNt1o9/F6Df5Na9pYa/1bMOWwyxk9Mvxx46dc/cL62HTMaCMei6IL43Gy14Rq0+d8Kvs212Be8zSoVUOQW90RXv2ym02kqhJqdaHmwpgpb/l6W/DlMLwiutcxhwt21XM9B7jiZSfOXBdueAKXoR3T2RuFdQLucoJUn2nbGYeiZMQWNUtFKcY2u0+z8USvMECEHFmP/OvRK68uDr99fZxmUGU/h5LM8O3J6BMASG3BvDa9dFPOMZQap2BD7Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/7 14:28, Dev Jain wrote:
> 
> On 06/10/25 8:13 pm, Lance Yang wrote:
>> +static inline int thp_collapse_check_pte(pte_t pte, struct 
>> vm_area_struct *vma,
>> +        unsigned long addr, struct collapse_control *cc,
>> +        struct folio **foliop, int *none_or_zero, int *unmapped,
>> +        int *shared, int *scan_result)
> 
> Nit: Will prefer the cc parameter to go at the last.

Yep, got it.

> 
>> +{
>> +    struct folio *folio = NULL;
>> +    struct page *page = NULL;
>> +
>> +    if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
>> +        (*none_or_zero)++;
>> +        if (!userfaultfd_armed(vma) &&
>> +            (!cc->is_khugepaged ||
>> +             *none_or_zero <= khugepaged_max_ptes_none)) {
>> +            return PTE_CHECK_CONTINUE;
>> +        } else {
>> +            *scan_result = SCAN_EXCEED_NONE_PTE;
>> +            count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> +            return PTE_CHECK_FAIL;
>> +        }
>> +    } else if (!pte_present(pte)) {
>> +        if (!unmapped) {
>> +            *scan_result = SCAN_PTE_NON_PRESENT;
>> +            return PTE_CHECK_FAIL;
>> +        }
>> +
>> +        if (non_swap_entry(pte_to_swp_entry(pte))) {
>> +            *scan_result = SCAN_PTE_NON_PRESENT;
>> +            return PTE_CHECK_FAIL;
>> +        }
>> +
>> +        (*unmapped)++;
>> +        if (!cc->is_khugepaged ||
>> +            *unmapped <= khugepaged_max_ptes_swap) {
>> +            /*
>> +             * Always be strict with uffd-wp enabled swap
>> +             * entries. Please see comment below for
>> +             * pte_uffd_wp().
>> +             */
>> +            if (pte_swp_uffd_wp(pte)) {
>> +                *scan_result = SCAN_PTE_UFFD_WP;
>> +                return PTE_CHECK_FAIL;
>> +            }
>> +            return PTE_CHECK_CONTINUE;
>> +        } else {
>> +            *scan_result = SCAN_EXCEED_SWAP_PTE;
>> +            count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>> +            return PTE_CHECK_FAIL;
>> +        }
>> +    } else if (pte_uffd_wp(pte)) {
>> +        /*
>> +         * Don't collapse the page if any of the small PTEs are
>> +         * armed with uffd write protection. Here we can also mark
>> +         * the new huge pmd as write protected if any of the small
>> +         * ones is marked but that could bring unknown userfault
>> +         * messages that falls outside of the registered range.
>> +         * So, just be simple.
>> +         */
>> +        *scan_result = SCAN_PTE_UFFD_WP;
>> +        return PTE_CHECK_FAIL;
>> +    }
>> +
>> +    page = vm_normal_page(vma, addr, pte);
> 
> You should use vm_normal_folio here and drop struct page altogether - 
> this was also
> noted during the review of the mTHP collapse patchset.

Right, I missed that vm_normal_folio() was the way to go here :)

Thanks for the pointer!
Lance

