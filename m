Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E39CAC5A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 12:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BFE8E0005; Sat, 20 Sep 2025 08:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD868E0001; Sat, 20 Sep 2025 08:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3868E0005; Sat, 20 Sep 2025 08:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0228E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:43:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25A171D8DA9
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:43:03 +0000 (UTC)
X-FDA: 83909593446.09.FD32F69
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id E4A3580011
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:43:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IKg7aAFg;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758372181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwT6WLsca0cExAFMnQuLDNi7G4kZxd7/STjhVcD78V4=;
	b=7u/dixIEdKSGbCkttlqTQmoSpdO2C+qJyy5QuWCwVu8Gp03v3nYYr1gD7ld4LlN/qbJt1L
	xOePa5GB2sP0HM/iUnOyFKyHrP/kofXqCD4+ZHzkUeNC8CgfIw4RlwkP1JpuVeftLWAwTf
	uTAREEGfDbaWDjOSsbR6EiOuJT4Ntl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758372181; a=rsa-sha256;
	cv=none;
	b=6MbraBTbFKin9P099N0Nxlz689IUkchff2EPzroW3p9FQ1ok+iRViQPyO+RszgTMZS0VJw
	MCj0uemQ0FUalGxxYPKhs1cBjmeN9tKLDeaJJ85tqI7tfshDwTrIHDaKJ7W0NilLir9B0L
	4tNds5gy8gJvRU566M2OlE34JROE3hw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IKg7aAFg;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <05363b2b-f6f2-4743-9620-7f906ec16138@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758372178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HwT6WLsca0cExAFMnQuLDNi7G4kZxd7/STjhVcD78V4=;
	b=IKg7aAFghezFuw7KeSxCIg6yZO+Q1G33y4WDFweN6wBd+B5n8ZcJwfkHJNqT68INrw5fW5
	UX2s9a2wlgJ5Yl7XgMBSA5C1yz49F8i3jhugjfeDF6buVUmuAw4UxMn85Vcqqak8Tc0xYL
	yyRTa1/LuQyLyS4KHxAxgXTduyrw9c0=
Date: Sat, 20 Sep 2025 20:42:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com, baohua@kernel.org,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, dev.jain@arm.com,
 david@redhat.com, npache@redhat.com, ziy@nvidia.com,
 akpm@linux-foundation.org, baolin.wang@linux.alibaba.com
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <b1a8925b-8bb6-43b2-81e8-abb377905d48@linux.dev>
 <20250920090023.52b4mupfa6dkhtnz@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250920090023.52b4mupfa6dkhtnz@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E4A3580011
X-Stat-Signature: 1pnx3ouwt83w1en7cethbk4ienzie9om
X-Rspam-User: 
X-HE-Tag: 1758372180-672724
X-HE-Meta: U2FsdGVkX19mlsDyIcOOA88Qns26tMYrDQirxNKDJoRDAj0TmnQcvgUAafCQvS3RCHWZkj9Y4UHtwcfnHcYHKFvQpcFIzXXN1nj6I195cYtrLhfxxO9liUXb1eKXI+4tnC1V2sjGM4gxUHmtjZHiHGSbgUClV+Sx+N3xDja+42jliPn53kiMXvwYCJOWC2nO0jy7iJcBEB9teYyOeYqBiloFFu3JeUlxnHc+9gQAd2vilSzo16rl4lQn5SAao+dPbI+XEHmQRe4ck2KRxYIGmULSv6z8FJy+KNx1nCJvIuXLIN2d5p3ghw9MIpCf/6y2RRYQeXceZCJoxng1Al84dQSEB1PjAWTaPU/mtVLY0zGLL/jk4r/KFwWf+ixDcavP4cz0U6gxueJAuOttM9VmuMCB4t7XS5QCh2DyVgJPoTNGYMVBfogyQlS4Ks3+eVTvIWWnEEURHkotNOR9CVGF0JM2cBE+bCZi2X1H5QSiAwX1nIcXIsp6ND6ThL5gyt+Yvpx1CNK/XnjxLF/qtdl6I1akaPxOIKmrozcwCf2Hc+qQewxU9L7psHeF6sXN1eC7trQae5jEbdHIVSIUBMBzAgOY1Ru64vrrsSoC+NxNnyLYGLHjTezfhp07IboFJ208PlfPN2xSGHqcIycUO2GlJ1QlDVipUri7Vqr3vqZW8igy38cYbGDSHE1OLaQnQU+XQln//PGe+AO1Mn26T3+uEXl7udSb52Hi8/nfddaeEDHrZUXHyeqrhG4a/El+vT/cDpVYJOMKt1GOwPaK8OqovjiXbkxn70GxJ0FAi1Ijs6FdVzTXNziAjjlfBJ21Nr9aYHX0GHrOP9UtAC6NlMCuYRznPCzJroThlMYkD0/4oK8OxWLi+rgmaPydYyxOssZzZoC/1TBds4wjjHol+qgfuYZ6g9EBfI/BaKkzfKkDluwe14UWEpor67uNS9ZZw3AQvHM84qp2RBCuIAJvtsY
 +Vavq/X0
 n9n/f29X+l2S54Z3htCC61L0/oPnqKOJq2pUcpUYcb07aWWLmjoE3TbI7wv+G57Xzx87f+Glj9cSap0G6XWeFwd58uN/M3DgOae6bKS66hygTJ0lTv3D2XzxuFzUzmuTWfealwtDOiYHRqp8vOjn6ZzzzSJsWj976RWtCrhE8ytgUtS6AGAXFub91SESEkU+fN9DKXUyyE2kHj0U68xC8RO3vstfjTJZoF6+ZHu3JTctkmp3VeIcrC0sD+kgImhaKHnpmF8CZvEFmpb6cwq26omfFGdi7bv5G5nMNfvaar2GFwd3xBIR3QdbxZ4Bero8WEkJRtqD1O0grQU6UAlGHI21mDpSzj3xb2n8a5mdhN61hkY74Av0B8sxXVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/20 17:00, Wei Yang wrote:
> On Sat, Sep 20, 2025 at 12:30:52PM +0800, Lance Yang wrote:
>>
>> On 2025/9/20 08:54, Wei Yang wrote:
>>> When collapse a pmd, there are two address in use:
>>>
>>>     * address points to the start of pmd
>>>     * address points to each individual page
>>>
>>> Current naming is not easy to distinguish these two and error prone.
>>>
>>> Name the first one to pmd_addr and second one to pte_addr.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>
>> This renaming makes the code much easier to follow, but just
>> some minor style nits below :)
>>
>> Acked-by: Lance Yang <lance.yang@linux.dev>
>>
>>> ---
>>>    mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>>>    1 file changed, 22 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 4c957ce788d1..6d03072c1a92 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>>    }
>>>    static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>> -					unsigned long address,
>>> +					unsigned long pmd_addr,
>>>    					pte_t *pte,
>>>    					struct collapse_control *cc,
>>>    					struct list_head *compound_pagelist)
>>>    {
>>>    	struct page *page = NULL;
>>>    	struct folio *folio = NULL;
>>> +	unsigned long pte_addr = pmd_addr;
>>>    	pte_t *_pte;
>>>    	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>>
>> Nit: could we refactor this block into the "reverse christmas tree" style?
>>
> 
> You mean sth like this?
> 
>     	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>     	struct page *page = NULL;
>     	struct folio *folio = NULL;
>    	unsigned long pte_addr = pmd_addr;
>     	pte_t *_pte;

That's getting closer. The formatting would be something like this:

	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
	unsigned long pte_addr = pmd_addr;
	struct folio *folio = NULL;
	struct page *page = NULL;
	pte_t *_pte;

Feel free to change it :)

