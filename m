Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C43FCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D626B009E; Fri, 26 Jun 2026 00:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BEE56B00A4; Fri, 26 Jun 2026 00:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACEB6B00A5; Fri, 26 Jun 2026 00:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06ED66B009E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:42:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64C861C2283
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:42:49 +0000 (UTC)
X-FDA: 84920818458.30.2921690
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 71A1F1C0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:42:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Omt1UEns;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782448967;
	b=1EVbNUKR51b5p5L19t+jRPg7NqRSr/VIOS6QSg3TKboEMVKOwOYCmcqvTvEN/42zIkXc8o
	+E1/+64UMklwgYOPtPns9dqg6TpcdR5D3GXf6hFbg7s0k8quExEYitV1TN55Ad2Kf4wADO
	EXrL1cQT7a/JYw3G1w6W+1H/Vqbi7LM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782448967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zPIH/xNB/JkteHgy2QtBeL6oUek9C9A8mya468P5WQ=;
	b=Fh0bW7KjIFgIe0Eh9SJzrnUrOPuv5xZcL7W2fzb18TZcl6qWbxXP5RCw+ancM0qt3FQgQi
	usb2AN2yUhlM5LC9c2q9Cf2MBzThgugEH3k0a3TfczD/JmzvkjfeyYgWZ/0NzYnXb6ASIH
	GFiatjLOvinFsZcjRy0cMZ3dAU/cZPs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Omt1UEns;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7FB82BCB;
	Thu, 25 Jun 2026 21:42:41 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32E823F905;
	Thu, 25 Jun 2026 21:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782448966; bh=jm0W1HK2v0EV8GOom2wsH9OJKWlaesJ9dgMzcyqKEhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Omt1UEnsa3O5EvFoZTeggyk3IRsLZKvm39+Eue4aqJ688x9dxZQxFhgZP2iqXBRdu
	 Tut8EOm7Ii0Hh7/X8+sGBUI9N3GlJPjexaQMMvkOFgR24mPipoVbKBJYImtyINRVJ4
	 J7rt0tcmQ8vm0K7Fsxz0+HGMUfd8yHUcse9/Rzh0=
Message-ID: <3875df90-760e-49c5-ac18-c43fc7ede133@arm.com>
Date: Fri, 26 Jun 2026 10:12:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm/mprotect: use huge_ptep_get() for hugetlb
To: Muchun Song <muchun.song@linux.dev>
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, mel@csn.ul.ie, nao.horiguchi@gmail.com,
 ak@linux.intel.com, j-nomura@ce.jp.nec.com, pfalcato@suse.de,
 dave.hansen@intel.com, tglx@kernel.org, jpoimboe@kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, david@kernel.org,
 liam@infradead.org
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-6-dev.jain@arm.com>
 <28f75d0d-de54-43a1-b46a-fe3dd1188929@linux.dev>
 <c807eac2-7b72-4b16-b4bb-b7241d35a991@arm.com>
 <A7E52D3B-8673-49F9-89F4-06FB2165FF06@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <A7E52D3B-8673-49F9-89F4-06FB2165FF06@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z317dm6rwimy75t1gjix9meb4i67yx1x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71A1F1C0005
X-HE-Tag: 1782448967-796699
X-HE-Meta: U2FsdGVkX18Sxf6t5mtPg+m7iTb5aZlHW46XamlpUG/YapPhU5HWvL5aKFFIZgGnBGO4XIRH/SYNDBi9eIU/RSWb6GpMrEaIpEQb23VLlZhwhBuDQoWT5UGF4pP0wVVq5okXPpbkUBUSwGHcSnR3zB87isZNlc+A038zM5UChEB38SISSiJhWVn25Pe5fNCG8sKLqjy+SEQneG9k9Y5MHSGwMXK0XqkxBM5Wy2uu3/un4q9u9GyZs3VOIeH438P5hVtrIRvfKPTb95Cw4VxnE2ud+FXYlHIYcaUPYbuZb3px3/ZL+bzH/DELWXEEauKOT6/ERvS+rXI2fk4pHO9p44KOr/ox+xrtBOGDYWBJpGtkMsIYj50+w3Djzthh8mD7Zppr2orzZMIj0mTo+RlEi9XUgm70b8Dpd4kCUcV6TPEGiOTYZXjAnZRMqc1cbwdpQKp02CyIJqLwIbkOEGDc7As8kyi/jQ69gs0AeHFeE3imsJ6lciQQhzTi+dgw3b3eUtHX4nzwFLIC0j+6/RQESrBB4huUiux0omRwlFsgg8wTDwI6rAhLd4ep2mhN7P/30uXxsNN1P2lGsTRx5rrPTGFVei7iNUAeCwyXRYg2DYZP1HO1bvWx6GOHtDGe2DG7ypbr7q0gHaoSdBm8g+8tPoxxsEk8/QkG192U0N56BeBlUlBhi8es42FLKBdNULnJPWDz5DbQLnynTqZpi7vtfHEhRF6TSWNuIiys+3iamENXuqI1y7HxCUo8w0R2JC4bD4HsVUA8u7REbaqWKEvd1PkDVwXKxgMObZfGdKjDDWl0kCkCxxFnD/wHCxcgWwmEO8xLrtRqMZG5olAI7z64WQPKN765b4tGee393Ym1s+EEM7p5maiDATbhEKQgyPMQ0gUZy7S8bRRU4nTeXw1ikKYokTzhLqzI4rUxwoKSI/1bTMcwW67wBHav7joUdf1mHH/4OeGVbeRWTW77x6z
 ylRHjMv3
 9/qfpsR6bqXRSvUBQoLp0RBy7iS3v5SAwa1YS8RFJITYJi5b4MDv7lSA9mNSFlouNER5amRJy878aew9TQarSVb22UZTJfKkbBweN5U711TLvYF7QLZMVHKWTIod6bDrZRQ8Kp6N4Xo9/uY96d80h2S8h7UmXLwrUwbp2V+RgvguYeNQdbLpgw7/sS0wV/7xVgWE/9ZMZJRkDE8o+gVhgDfpfjaGu/1lw+Wrytp//2IApbZJLpX62es+6/yA+HMNpL9MJjvVsVNKUDszNuViRHKkb6Jsxrh2rdA9arEpDCLOQbPbIDGwvkzVcnSJinDHkTDd0vH0umbritvgwSX58z4WhEY+WDftj00E/Tp9haKZN90BKSAlrXVDwbKeGKJBws31oyGaslBT66xSYwYKrZl/haNAWH1z+UQA3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/06/26 9:51 am, Muchun Song wrote:
> 
> 
>> On Jun 26, 2026, at 12:08, Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 26/06/26 9:10 am, Muchun Song wrote:
>>>
>>>
>>> On 2026/6/25 19:29, Dev Jain wrote:
>>>> prot_none_hugetlb_entry() is the hugetlb callback for the early
>>>> mprotect(PROT_NONE) PFN permission walk on x86.
>>>>
>>>> The callback passes the decoded PFN to pfn_modify_allowed(). For a
>>>> hugetlb callback, the pte pointer refers to a hugetlb entry. On
>>>> architectures where hugetlb entries need huge_ptep_get(), reading that
>>>> entry with ptep_get() can make the permission check use the wrong PFN.
>>>>
>>>> Use huge_ptep_get() before decoding the hugetlb PFN.
>>>>
>>>> Currently there is no path which can trigger a bug: huge_ptep_get() is a
>>>> simple ptep_get() for x86, and the prot_none walk occurs only for x86.
>>>> But use the correct helper anyways.
>>>>
>>>> Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>> ---
>>>>   mm/mprotect.c | 8 +++++++-
>>>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>>> index 9cbf932b028cf..23779632d18bf 100644
>>>> --- a/mm/mprotect.c
>>>> +++ b/mm/mprotect.c
>>>> @@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
>>>>           0 : -EACCES;
>>>>   }
>>>>   +#ifdef CONFIG_HUGETLB_PAGE
>>>>   static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>>>>                      unsigned long addr, unsigned long next,
>>>>                      struct mm_walk *walk)
>>>>   {
>>>> -    return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
>>>> +    pte_t entry = huge_ptep_get(walk->mm, addr, pte);
>>>> +
>>>> +    return pfn_modify_allowed(pte_pfn(entry),
>>>>                     *(pgprot_t *)(walk->private)) ?
>>>>           0 : -EACCES;
>>>>   }
>>>> +#else
>>>> +#define prot_none_hugetlb_entry    NULL
>>>
>>> This is very strange, because we defined a stub as NULL for a helper
>>
>> I was following pattern elsewhere, search for ".hugetlb_entry" in the
>> codebase and you will find others doing the same.
> 
> Okay, I understand why you want to do it that way, but I would still
> recommend not following that format.

Okay then I'll update v2 with the below diff.

> 
> Thanks.
> 
>>
>>
>>> function. How about  the following diff?
>>>
>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>> index 9cbf932b028c..4d8c1551fbce 100644
>>> --- a/mm/mprotect.c
>>> +++ b/mm/mprotect.c
>>> @@ -716,7 +716,9 @@ static int prot_none_test(unsigned long addr, unsigned long next,
>>>
>>>  static const struct mm_walk_ops prot_none_walk_ops = {
>>>         .pte_entry              = prot_none_pte_entry,
>>> +#ifdef CONFIG_HUGETLB_PAGE
>>>         .hugetlb_entry          = prot_none_hugetlb_entry,
>>> +#endif
>>>         .test_walk              = prot_none_test,
>>>         .walk_lock              = PGWALK_WRLOCK,
>>>  };
>>>
>>> Thanks,
>>> Muchun
>>>
>>>> +#endif
>>>>     static int prot_none_test(unsigned long addr, unsigned long next,
>>>>                 struct mm_walk *walk)
> 
> 
> 


