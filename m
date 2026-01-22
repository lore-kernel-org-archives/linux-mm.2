Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E96C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD4F6B011B; Thu, 22 Jan 2026 03:44:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3548A6B011D; Thu, 22 Jan 2026 03:44:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2871C6B011E; Thu, 22 Jan 2026 03:44:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 150BB6B011B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:44:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A725EC09E5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:44:49 +0000 (UTC)
X-FDA: 84358964298.24.5E1C957
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A7DC40003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:44:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xVxOOwda;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769071488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDpjBA56UpKXX0RpCliwDF6LnVmLT09CUYEpTS3IAnM=;
	b=Qf1pGG4xKA/z3HGe+A+BJxkY6Jjhc6Iuq04FFrbiYZsHv9+G8jrwLZtk3v/krxD8JWhPmc
	3LW8YTSB0+nMrYbtaFFli7cFto1pVoG/TQQXcobviT3TbjUBA7OcbSTs6Khul3wdQ3isZX
	4tfTynI6Cik5zpwGHuwZjpDfT7RT1TY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xVxOOwda;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769071488; a=rsa-sha256;
	cv=none;
	b=iQQ+L3zufzh0wvJdwlYAsjy4L5TJjXnzQPD1dUuOl0knvK3jXfo+D5Zdrwn/hlYZ0+xSmy
	MfnJ1ysORd/FSTZ22ZZAL5RwVyXkbEUEX+Z9HNWHH8REZhR5K3YBWtL555WKoH1n+wJHIn
	s6vVshlQbMnnWmeSGJDAuCHWk1NoHHQ=
Message-ID: <d9d569cc-127c-41f8-b16d-d6e11ba7b43a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769071483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LDpjBA56UpKXX0RpCliwDF6LnVmLT09CUYEpTS3IAnM=;
	b=xVxOOwda5jznK+jwyc6xIB0HOEPChs0qQ/1VykeGm/guAcD0Md7lhQkKBupy7FYG0W1ATK
	inN2d3OpwXCJKw0pf+YPIP6q+AK1pDQ5wdDTXZYFo5TrcsCmytsV+WupVyJEmAkVAlFsHt
	UvooVn43fq0gN1Tt/fn5gk7lEd0Jdb4=
Date: Thu, 22 Jan 2026 16:44:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH V3 2/5] mm/khugepaged: count small VMAs towards scan limit
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>, Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-8-shivankg@amd.com>
 <829b62c8-e3eb-485f-8d7b-01419c841cc8@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <829b62c8-e3eb-485f-8d7b-01419c841cc8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: eziekyephpxiixwcwenetud87c4ffuyq
X-Rspamd-Queue-Id: 3A7DC40003
X-Rspam-User: 
X-HE-Tag: 1769071485-282002
X-HE-Meta: U2FsdGVkX1+/7dhbbD5ZySQrlTwt+07lGv7hNobr0DGShNmLZRgaCdGmxPZiWkIEt0FTH+rvKazTYxVDqWbufU7th3C7ZXkqKW1NaBYh5SrjMArmKjdZUo2d7Kh0RxihM77fJeeRwUVIAqKpTn4pOrhbZ0ws55n+Jkv3AMLdIpyLR4t1eef2QYeuoNsYV/RhRsRFIenaBcEED2AvIjcC4GFolElPDSdUxuqjO24ZBpQXM1lWnKjtk/4sxHngDEsEEoytusLmY1M2GpjzSEXIGW5eIhRHlO3ftJvSP5kHSRmOxtF7bBS+dJbEOzL/2JbSh4ar0ZoL2F4Qfl4SomRdV43h9iJE/yVrEMHqS9yWJ9kIYe0EKXPutc6uLSUVVPmFfZQNS1jweR4eB+ZwtKS9K2KjNcHUpmWaHJnQL6m1ZTfbCQQhLc6ydW/bqScw18PTqGqrg4OOGcSrj7VggNOXDHtyLKjyWWgjyvky+F8fFPCfmDlWPrdiYYd5rCl/gr5vh0p2NZV53uQtshH4TgYx0dfJewHlyZPNTM+ZMuSwl6SjM4fLQVjq+mJEw/k1GPVkMc+d0FbhfWYNeVQTBq2bz9h7LrIepjKidnfJogppreoqStR2lnXuP3pnZDw1ElCMc79BCq4O7LbyRGk9zIGseVKWjONfbFnUX6VYeKs29IOyt2XvyjOsXgJnvHVP1LWAXtjj5zHx9lMtAc7iJxecoh/EJggXewUD8nP8LUdJ0X+psGhfraPnXMtaxv4yoKUca8prPHMHT2tln+dQizRjVAKQiLULd86UIXCaFh1vTpWy1C06AsCkEPDV57LA7PATLuDO8L2awSowHfZQ1SopocCPMEG+vSCLKV0Hk6Evi45TFZFIzI4q2jgsp/Hf2tJ2NwMnP+XlrpMahvf6PZLTfA2JXu/mIsfMlbqwx6bbi7SC9fXCX2qSMxZHPzBHS7SWxPk8JyHyXoBMA9hLthZ
 qj2HACxN
 A6JRQosScMuGegEc3XpZ0oPkNe3nY3G8Y8/brGq2cOwT3hDZhizCSMnw/5N/TshbfEjZJkfi1n+3V6PeFbYk/pMEooQW20urUix1xuuU0qkfPP3+HT4tdOFbbKf1TiVf2Mu5JfXkqNN/A+wNVNGvfPrw9YZIlrLmg8x7cyPsf3qd3LTbEeUHlIMb1fRTMIMC4rmEXb6KSFBoo/iQUi8X4BVTVM1qzphURLEEFCu+SZjR48J1aOHSk9FTqVcBlih8NNpKc9q5a5AfOB7GKhA6x11WebuOKzl2wttbBSNKYWrGxDfBRg4PpcvQTYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/22 15:32, Dev Jain wrote:
> 
> On 19/01/26 12:52 am, Shivank Garg wrote:
>> The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
>> amount of work performed and consists of three components:
>> 1. Transitioning to a new mm (+1).
>> 2. Skipping an unsuitable VMA (+1).
>> 3. Scanning a PMD-sized range (+HPAGE_PMD_NR).
>>
>> Consider a 1MB VMA sitting between two 2MB alignment boundaries:
>>
>>       vma1       vma2   vma3
>>      +----------+------+----------+
>>      |2M        |1M    |2M        |
>>      +----------+------+----------+
>>                 ^      ^
>>                 start  end
>>                 ^
>>            hstart,hend
> 
> Won't such a VMA be skipped by thp_vma_allowable_order()? That internally
> checks, apart from eligibility by sysfs, that the extent of the VMA can
> map a hugepage.

Ah, you're right!

I was worrying about a case that doesn't actually happen.

Thanks,
Lance

> 
>>
>> In this case, for vma2:
>>    hstart = round_up(start, HPAGE_PMD_SIZE)  -> Next 2MB alignment
>>    hend   = round_down(end, HPAGE_PMD_SIZE) -> Prev 2MB alignment
>>
>> Currently, since `hend <= hstart`, VMAs that are too small or unaligned
>> to contain a hugepage are skipped without incrementing 'progress'.
>> A process containing a large number of such small VMAs will unfairly
>> consume more CPU cycles before yielding compared to a process with
>> fewer, larger, or aligned VMAs.
>>
>> Fix this by incrementing progress when the `hend <= hstart` condition
>> is met.
>>
>> Additionally, change 'progress' type to `unsigned int` to match both
>> the 'pages' type and the function return value.
>>
>> Suggested-by: Wei Yang <richard.weiyang@gmail.com>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>
>> Incorporate comment feedback from Lance:
>> https://lore.kernel.org/linux-mm/6b408736-978a-4d40-adfc-97819951c3a6@linux.dev
>>
>>   mm/khugepaged.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 984294a16861..93ce39915f4a 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2403,7 +2403,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   	struct mm_slot *slot;
>>   	struct mm_struct *mm;
>>   	struct vm_area_struct *vma;
>> -	int progress = 0;
>> +	unsigned int progress = 0;
>>   
>>   	VM_BUG_ON(!pages);
>>   	lockdep_assert_held(&khugepaged_mm_lock);
>> @@ -2447,7 +2447,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>   		}
>>   		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>>   		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>> -		if (khugepaged_scan.address > hend) {
>> +		if (khugepaged_scan.address > hend || hend <= hstart) {
>> +			/* VMA already scanned or too small/unaligned for hugepage. */
>>   			progress++;
>>   			continue;
>>   		}


