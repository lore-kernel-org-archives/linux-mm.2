Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE3F7CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C218E0011; Mon, 15 Sep 2025 10:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCDB8E0002; Mon, 15 Sep 2025 10:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB838E0011; Mon, 15 Sep 2025 10:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E98648E0002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:42:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C78FC06A9
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:42:13 +0000 (UTC)
X-FDA: 83891749746.17.4FBFD30
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E91A4000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:42:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m8NJI9pn;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757947331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otD0lF88c/W1mhXnZZlmqwcx36asc6J+ruH2BHy82vs=;
	b=Ny4FnwecABwyvPGZVLd23vbnzF/Pdu7WVH7XXJWtJbwn3UtNefx7kgkSbPn9Kz5jpDr0tt
	5OmWLbqUW2vHs0LfHe74SJPqvg/IGgTiQEMmkqJMIgRQu0oBMVgiZZ7rhfA3x9WWEWZF3W
	HE7WWnESia7p+Jzvex6EO3kdi3ITarg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757947331; a=rsa-sha256;
	cv=none;
	b=kXMwPawAXyQxuBWppIWQWPVRoRhU0UKl6T48+QyjpIkdE21G7jvMR42EGPs1j774npNBX6
	DtF2L6UpP2c1y2V2cQv6yW6vyjjBoZJUbjb1kg63YKJVTePOLqQmV/TOjsAGjPSvYyg64K
	6uk9+Seahvx8tQpI2+QCgEVZk+duBzM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m8NJI9pn;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <121a0947-88cd-4515-bf14-a2af9b69eb0b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757947329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=otD0lF88c/W1mhXnZZlmqwcx36asc6J+ruH2BHy82vs=;
	b=m8NJI9pn7LA1CV/E/15NfiRNHl0491YASPDwDn4YMfZP3tGltyzJLFHg+HiEf4XsPtEI1s
	h0OVkE2EOubpGiDYXx9Ycwl2n+i0QGGB2Bw2l++MvS+vszzPFGSj1ni4Q7I1hioL12BmpY
	X88TdsxVe7494tG2OsZwjvuzm/deTls=
Date: Mon, 15 Sep 2025 22:42:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 3/3] mm/khugepaged: abort collapse scan on guard
 PTEs
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-4-lance.yang@linux.dev>
 <59519b0f-af14-4486-9aca-4e721842d45b@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <59519b0f-af14-4486-9aca-4e721842d45b@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uo9ew67mi4qzdrgf6r6xm8hwk1fc6usr
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E91A4000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1757947331-171876
X-HE-Meta: U2FsdGVkX197WwZGpP7Scy5+yK4FYJT/ZTLxhBeaYWB/DZmPKaNTpxVxsrlMSaZSLGYD2RN5ov95ja6Zq4DrLNygneoJBdvGEtVBx8zaS36XcUOi+st1lO2sFRCBFQ4hs8Vma8e0zpECo8PCDEWlKsheCkxJjXp5eqZ8kWLSA2EUH//AmBhxGmDVjBF/HLwZNq4ooECLPmsZriNRs0UsNRMpmB9zdWtwGywrQCKnSiMY+IL9LxUcxblRlfXEytZIC6Da28S1KHOEdfhPf+MHBNtakY+N/kIq9ziz+HFOTwb4HtX8armjHeMPl3nzDXTIW/czQ84VPrBrfH56/00C219xw5QDxvUTaHoUn3u/JKo7leIcXwTJQveI07qMck63TDGJcOLvdFLEZjJYmrNVMlHtSbP5zU1ZYi4cjQHoN8cEuurEhzu5c/8A/vy2x7GELYh958qij7JS+wfL6gG4sA420m33aMxHyJg+QuwzrKCVA2to/WT2OIKKYvbv4tqWIGTsxvqFagswWc2wf5vLQe3sYCow3ek1Tp4Du2ML5mLSfWH8PANGOBgnpUxQyzpy7K2zHKT35AjuqQ5ByJ+EEggTuoR19jjGvFBs3Isss+1ZojLPD9tjlfhJMtP5PKMK0xlaiQsFXywKWG8VTXYKUmYGJXdzxjnXFGWE7wEySwnW6Eddoz6qPDhuWPYkz7To+iK7hOPJB1ePUW0K0z8dFfop0N2e6HkDcmMLObbBnmBfHSpiGA4D8kT+t5lqSC91SX0p5iDr9xUP7tHZZ9m5Bzht8+cF4/am/NS1OS4OBTkLecH1UzlT9QsdPMMen0xCotQgpeW0B508vd59THdHSc/Oyn3mIar5gMoVUyWVec53LyIB1u4qTBYeuKHnirVsEPoG8+5m+hwrlikKcO2Ks4A+RPLB4Z5jUNmR0yUhWqBL8TKK5CFxtFnMqaZA3edTu7m74k7cH5Hc5t4TWNL
 JAbsEJih
 1HGxAcARodVDa92gjpy33CsyYE0VdnzvADwzlPu3QRoeM94dkPsbZjuePR7knROIQbR2wZkMZSe/at2HoZd6hL9Rz6IXIA4NgLIh4jDYJeDWTf6eFNHviiiXC6wBIpHTmhAWDQM0Z8EX0DUz61psBbSI+etwW0Z17HkMp3NED8zwYiR/6uOULB9ymKQMfXH/Sw8Kgf07faSXvKlO09zh/VFvoehQ2mOFiAPe56GrVGW7gEmXCnsYLAkKfLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/15 22:08, Lorenzo Stoakes wrote:
> On Sun, Sep 14, 2025 at 10:35:47PM +0800, Lance Yang wrote:
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
>> IMHO, we can and should detect this much earlier ;)
> 
> No smileys in commit messages please... :)

Got it. Apparently, I'm a bit too fond of them ... Will remove it in v2.

> 
>>
>> This patch adds a check directly inside the PTE scan loop. If a guard
>> marker is found, the scan is aborted immediately with a new SCAN_PTE_GUARD
>> status, avoiding wasted work.
>>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index e54f99bb0b57..910a6f2ec8a9 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -59,6 +59,7 @@ enum scan_result {
>>   	SCAN_STORE_FAILED,
>>   	SCAN_COPY_MC,
>>   	SCAN_PAGE_FILLED,
>> +	SCAN_PTE_GUARD,
> 
> I wonder if we really need to have it literally called out though, can we just
> use:
> 
> SCAN_PTE_NON_PRESENT
> 
> Instead?
> 
> As it is, indeed, non-present :)

Makes sense to me. A guard PTE is indeed a special non-present case.

So, let's reuse SCAN_PTE_NON_PRESENT for that case ;)

Cheers,
Lance

> 
>>   };
>>
>>   #define CREATE_TRACE_POINTS
>> @@ -1317,6 +1318,16 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
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
>> +					result = SCAN_PTE_GUARD;
>> +					goto out_unmap;
>> +				}
>>   				continue;
>>   			} else {
>>   				result = SCAN_EXCEED_SWAP_PTE;
>> @@ -2860,6 +2871,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   		case SCAN_PAGE_COMPOUND:
>>   		case SCAN_PAGE_LRU:
>>   		case SCAN_DEL_PAGE_LRU:
>> +		case SCAN_PTE_GUARD:
>>   			last_fail = result;
>>   			break;
>>   		default:
>> --
>> 2.49.0
>>
> 
> Cheers, Lorenzo


