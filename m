Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC387CAC597
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 02:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB55B28000F; Thu, 18 Sep 2025 22:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D658E0008; Thu, 18 Sep 2025 22:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9B528000F; Thu, 18 Sep 2025 22:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9FFF8E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:45:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92EA51401C0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:45:26 +0000 (UTC)
X-FDA: 83904458652.01.421DEAA
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id D0822180007
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:45:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kkZnUCqS;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758249925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEd4CRxp0Qy3iytKkYSUgyoNAPH5uPPdhfTDAiqFt+Q=;
	b=4bxqlw/uVSWoNWP1z6+OTFPqGnvJfICaaPJEHw0NJAdR4RxdcSY7ocGE0me7GmLD1iEPR7
	pss//+Q/GmpS2NRxFzg3n427ZzH8Hw6T97kBXdZ+I9lUubW6+3Vs9AbXp3GY7XDegUNrZi
	BlcseL46R4aso4nTJyWOlJpIXl6FWJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758249925; a=rsa-sha256;
	cv=none;
	b=7kujdij60DcK+IryFDiI77FYUMXBuE/6yEM1yb2/ndSIyOUCssAaP8WzlWrJeDxNC1ljDy
	QqHNUsQIIZvSyp04FWM2m7XaDNJbS6X5rQCvdoS2azOrozu4cw/GOUmcerVaiyu5tIkTZD
	gJ/0E6y6toCnh7TjWz5alcBMkVSL95c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kkZnUCqS;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <20e0fb73-3476-4b1c-959e-c1af38f8e1a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758249922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pEd4CRxp0Qy3iytKkYSUgyoNAPH5uPPdhfTDAiqFt+Q=;
	b=kkZnUCqSVKS2D7eOJzEGuV3v+zGK9iIe7bTiuC/CxNG5peUXCkMg8QwHhrIUCzAA3fPGtj
	H5dS3iVmdASVXo6qgjNsHY2nKaNPMk5MXf8dk4yu9aiRvB+36+Nq6NC4YvSuED6HU0WwFj
	/DE5F2zJxguD24b6ukaUVsKcEQQp55k=
Date: Fri, 19 Sep 2025 10:44:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, kirill@shutemov.name, hughd@google.com,
 mpenttil@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <6BAE5498-D0AB-40F5-85F8-B92A05CA72AD@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6BAE5498-D0AB-40F5-85F8-B92A05CA72AD@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0822180007
X-Stat-Signature: sze8smrthnzy1hk8474bksbho83ioyu5
X-Rspam-User: 
X-HE-Tag: 1758249924-147518
X-HE-Meta: U2FsdGVkX197QevHkR7l9TLF452D2QPKPVzn1OIfscyAWVkAF3Ymz/so8CEWNllG4iv2LEy22fnGr6puBfpcXtIb1Af3PTMbI+0hpSC8IY5eUlrFR4nK7AYk46wojA77ZxiRw1RjlPYFeGGXenUqkM7JOwfeuwIaK9OQMYxmY3bEwfCAMwdCu57yO08KiNYAfSuTYt4KxqwR9obWej3ntU8DHxZiujilb243Nsnq3XBW6r9iz7wBYmcoNvSWrsOSOrTtWhj7lIIfemhva7tWALASb/h27+2Ub+Tl9vs5xhknCccmZVdQ9NjQmybrJ9KOzgRsvm/F8DmrwVgpUNyIRlts2sKXtvDCzRjzLlUmy7j9fy/Y37STYVP7XcDJhUSIeUxcA/ujWRopS5URycVr3yHuQ3wxyuehfFTZJfkKGDYzKlnm6H4Di0HleJ5k7Tv66IpjG66i63CFjiJEofComChfoXaagXQTSh4LgX3qiQnBP4OllB3WwUc3gurXw/oNiRn+S6E/gM5pSLGo4GZpAryJHXQu7hqNjefwDpotkFvUCe4JEFG/4Csh/JpIcM1ntHLbWb0HQIrUqZOIkFttg+M3vLFUAJjJFRc6W4UBeOxmiSUc7imyB7bT+xg7yzfh+x5iutguJZD3Eb95VXxJolg1ILt+uFUHsS+twfuxM+kB4n/yiL48XyODumx78y1J4e4viIEL8YU6Oh77EBrJyPYHsYZVeVKiYy5Mlh/xFd6rzJpv6fxtlRbFjRlrjTLDVb+ZtaJLryboIjl9gy0R7JrH0VpaYc8SA9KFzMIMXIs0rnSc1rd3eTRgSd1hXoOcYxA1v6MG6mqvzWzzrwLTitd2GhSmOdkB0+WyO/lRWBt+SqJKxY2nNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 03:12, Zi Yan wrote:
> On 18 Sep 2025, at 1:04, Lance Yang wrote:
> 
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>> lightweight guard regions.
>>
>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
>> encountering such a range.
>>
>> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
>> the special marker in __collapse_huge_page_swapin().
>>
>> hpage_collapse_scan_pmd()
>>   `- collapse_huge_page()
>>       `- __collapse_huge_page_swapin() -> fails!
>>
>> khugepaged's behavior is slightly different due to its max_ptes_swap limit
>> (default 64). It won't fail as deep, but it will still needlessly scan up
>> to 64 swap entries before bailing out.
>>
>> IMHO, we can and should detect this much earlier.
>>
>> This patch adds a check directly inside the PTE scan loop. If a guard
>> marker is found, the scan is aborted immediately with SCAN_PTE_NON_PRESENT,
>> avoiding wasted work.
>>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 9ed1af2b5c38..70ebfc7c1f3e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   					result = SCAN_PTE_UFFD_WP;
>>   					goto out_unmap;
>>   				}
>> +				/*
>> +				 * Guard PTE markers are installed by
>> +				 * MADV_GUARD_INSTALL. Any collapse path must
>> +				 * not touch them, so abort the scan immediately
>> +				 * if one is found.
>> +				 */
>> +				if (is_guard_pte_marker(pteval)) {
> 
> pteval is already is_swap_pte(), would is_guard_swp_entry() be a better
> choice here? Save one is_swap_pte() call.

Yeah. Good spot! Will do ;)

Thanks,
Lance

> 
>> +					result = SCAN_PTE_NON_PRESENT;
>> +					goto out_unmap;
>> +				}
>>   				continue;
>>   			} else {
>>   				result = SCAN_EXCEED_SWAP_PTE;
>> -- 
>> 2.49.0
> 
> 
> Best Regards,
> Yan, Zi


