Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2C0C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA386B009D; Fri,  8 Aug 2025 10:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963526B009E; Fri,  8 Aug 2025 10:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803BD6B009F; Fri,  8 Aug 2025 10:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 681F46B009D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:26:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C259858455
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:26:00 +0000 (UTC)
X-FDA: 83753814480.19.0A636EE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4FBDAC0003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:25:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q9TPlsC+;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754663158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NG8/+w/52idpKiJVVKZI/m2F7CfWPBDXpzCJ/SudBs=;
	b=M+hKfvCmvjs3aTwMxOcnwMahF7JWIShDpQ/oBSZYqpVxeKmKqm0W1PQSkhaEeQ9uaMrC4r
	82pR6E4kzjXLbq1aF3+ewZRewYZM2uNm/6JEhq5a07ipycGFUhxl3rjG9w03S5zBf2piyB
	tgsL0t4E+0pkll4+vZuF8z8JppMiJKI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q9TPlsC+;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754663158; a=rsa-sha256;
	cv=none;
	b=w/OaW0+DEHD5krb9mcD49q7SdoIzGt7wKg5OGIFzkbzZ5E6PBd2yYHGu9jPvwUwVLB9QxA
	sSvXZeodddhJFLcT4p7c2iuQA3OvVmHiM5o5RACSzo+MlbG2UG2rXP/7CGmhB2KlCwyKG8
	mY0XcSz+pW1f9ygXW2xcqE0mO3N2tUQ=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5784flYJ012384;
	Fri, 8 Aug 2025 14:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7NG8/+
	w/52idpKiJVVKZI/m2F7CfWPBDXpzCJ/SudBs=; b=Q9TPlsC+gn/lUJHJcpd0Li
	Gap4wvFYnsq6h4AikW/L0SMzezlEgPd5ppqGiXnyOcUmnffY2UeLhplu0ijYcPtc
	tAsVHPc8S20rA7jVwx7XzERjx/iZl/nAN3nFlryRDL4oMCmq72D4w0xlH0HDg6V3
	oHv3jrUnkmu9W2lqibTk7eRUyZdvZGP4N8vmwEwk/xrGu6nEdabJStcmI7O1594N
	YJ5Dqsp5Xc3XriUo+ddsxrWyTBlKUhWFBqf44oqYqSUij85OVjq9/+dxf7s8zyZg
	XS9Rubl/PrPfNIMIeWk/Y9flD7QkqexfpW4oXJhpXSaOxXdmJW6t3gexvuJB3gdA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq640hrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 14:25:46 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 578E4W3C009844;
	Fri, 8 Aug 2025 14:25:46 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq640hra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 14:25:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 578B71AR022687;
	Fri, 8 Aug 2025 14:25:45 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwqnyxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 14:25:45 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 578EPi3S24642140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Aug 2025 14:25:44 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B0555805D;
	Fri,  8 Aug 2025 14:25:44 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D195158059;
	Fri,  8 Aug 2025 14:25:38 +0000 (GMT)
Received: from [9.109.245.113] (unknown [9.109.245.113])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 Aug 2025 14:25:38 +0000 (GMT)
Message-ID: <c237c703-3ed6-4d7d-aaff-bd6291f9220f@linux.ibm.com>
Date: Fri, 8 Aug 2025 19:55:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] selftest/mm: Fix ksm_funtional_test failures
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>, akpm@linux-foundation.org,
        Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, shuah@kernel.org,
        pfalcato@suse.de, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        ritesh.list@gmail.com
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-4-aboorvad@linux.ibm.com>
 <20250804091141.ifwryfmgjepwrog4@master>
 <20fb853c-7d79-4d26-9c8a-f6ce9367d424@linux.ibm.com>
 <20250805170353.6vlbyg6qn5hv4yzz@master>
 <e9079694-1e30-46b6-97e7-b79be01c65a6@linux.ibm.com>
 <20250806145432.nygrslkiyvzulujn@master>
 <111d2351-3fb7-4011-af07-78b40874d956@linux.ibm.com>
 <20250808025804.b7cv47gcq2yscka7@master>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250808025804.b7cv47gcq2yscka7@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDExMyBTYWx0ZWRfX2pIhAuhRAYIw
 veiyNyiMhbz5xNVYUaMjnYk6lwUYWMlt3GprENzigfyNRCS4HUsfo0xPumZTg5y6+CjWQvt+Oo/
 jwCzFS+K0yzd4kmcmwmmdfy8Ed0IHxGiPE7uJkK2+sELwCloyaDdPv1zYwiKI3MGn8jQUglqmVU
 DjFhcfm/loV3nUJAv8/kou1ID3m+RpN/fSoU1nki9aQ7G1dgGdXLJYwBHGGlvJa21xVtV/sorZh
 7JiSXvSDHWQaryMf4bWBFvoGJZHcN/+PPJ1cKd+1kYDfd2VAX9rm7itbzDp36wKNBdydDITtqWS
 Z7wQmazprLMnSXf64jN27shROygrFnkPEPadM+t+FXd8QAp6+I8sSllgqUlhlcdYOvfB56q5YoQ
 bdFsB2b9fkRKPwX46VubyoIgq8D82l4yeb12vIclFwTXILu6jVXXVmfev0Iubv9G8JATXraj
X-Proofpoint-ORIG-GUID: ajx5j68b4sziG6t_CyVZ2iyhE7AMfkxU
X-Authority-Analysis: v=2.4 cv=LreSymdc c=1 sm=1 tr=0 ts=689608ea cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=1k-Y_4iKrBSBoghwKMkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: HpiSBDbHRUtx0WfmyQLVjmtXEHVUYkAW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508080113
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FBDAC0003
X-Rspamd-Server: rspam06
X-Stat-Signature: 51dnoj8yphbtknzxr7hqiccc5uo9myca
X-HE-Tag: 1754663158-760854
X-HE-Meta: U2FsdGVkX1/OwFe1H0SinWSOpIv59tBnTeX47rMqysVwVwqumooYh6pdv2NCp56x74xnu68PPAy9zPnt+j+I6Ij0Yay0YC5rj+Ks63oY50aT4n3X++ZruZhgZNRepoxd0+NWY2L5z9PdGfZeHg7zCYlrG0JmgIMF/wUlRwStSJV+tN/A48TABsetPAjmq6F8aYYs6eJ51wfcLXk1vPFRSbKQ/IvxFePC+/vpUBBiCLc/MMoYJWF1I0cXTQ0ryYi3pGaET2NuQED7RaDVWDaHKNY516aI7F0DhaRT90hrz71k5IAKTerHQxQB6vzV9Mo44Y7bsW7BVcidMbSqKQk9tnY1/2xUPQ7eiZySu2ZxbfZQcVq6gdQonm7rq/Z8vzVNGlFmTCU509Q3kpThIc0s/M7Hns0+8e0A9/QOR1yCUwCHG6dlCXF15GpMftaWiop3fa1t45YWW05xWkoyUCiTgCSTA7yKsW2KucAN6zDCqUtEe1HibsBuWwuWHnWDY9Zd4TGdzDBwZlkYju4PzDevi+GNMx895SkS4WtgSoLoxzA7ejnmXsdl/VLgahBTYA5OqAib01QnMyUKFjqeyawELDj6tZfIt6gbuDRKdVeDhj5pjRZVW2qf7O342T+yWXkuve59XUZNR7xBKAmbu21++FLjB34EpEvQOXjORdG3u5ObTN6YxWlh2QYiNf343O+VRg4lS26iJIHJX5Yx9qxrzL1lTHDU5CvrcaSqFexGbxLgjZTQMT3yuClO98db346b1pSjpvYrWe/66LnqU9SqxNI7QDRluVzU720/y6I8vZVMwcIIZoSOeTlMrcbsh81px/QahWtYgVXhR26+BnanP7GtQZT8/GkYJ3v+KCk49a5JoeGYRiN7m4fkOAPh2AaxTsDn2oCKEe0n0vFOyrgadPnJ9xZPXk8GyrOrPN1hyYaUTv24IzDm26ARdks0MnoDDMV5gXb7YyMAPxZeIjj
 xMTcmiUy
 IJaLqWPQDi5RIBHlAgBXd43GRQVX6hs5tfd2gPyEzAVEEOZ5Z/ZibSbbqdYsobb7/NP0d5sYtykZzMSVkuywrK+Zn6D0pbpatbB/XJbg9py7OIfSToFZSVMeJdd4u+Nj45BZiTF8vTSIpRJ3sRK7Riwaj6XBDQDWuz6lmL7A4CzKLveY2NnCLIagBJgV49G0ssl29xbArSPvzJ8N2ZnnltoZ8ZSlKx7i20IkVbZIknrL1Bw2YEzK0BULY9VEEX+e9YLutsR+pYrl9+f9X1Mc/iQgU1RufzINIJndGoiyRzJY6NV6eWk8xp/2R665SasHjImng9RgALDyvWYj4HZ953P4SLy9vs4BUVbdNIayGt/Lei7pkuJ7G57C3Vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/8/25 8:28 AM, Wei Yang wrote:
> On Thu, Aug 07, 2025 at 02:56:28PM +0530, Donet Tom wrote:
>> On 8/6/25 8:24 PM, Wei Yang wrote:
>>> On Wed, Aug 06, 2025 at 06:30:37PM +0530, Donet Tom wrote:
>>> [...]
>>>>> Child process inherit the ksm_merging_pages from parent, which is reasonable
>>>>> to me. But I am confused why ksm_unmerge() would just reset ksm_merging_pages
>>>>> for parent and leave ksm_merging_pages in child process unchanged.
>>>>>
>>>>> ksm_unmerge() writes to /sys/kernel/mm/ksm/run, which is a system wide sysfs
>>>>> interface. I expect it applies to both parent and child.
>>>> I am not very familiar with the KSM code, but from what I understand:
>>>>
>>>> The ksm_merging_pages counter is maintained per mm_struct. When
>>>> we write to /sys/kernel/mm/ksm/run, unmerging is triggered, and the
>>>> counters are updated for all mm_structs present in the ksm_mm_slot list.
>>>>
>>>> A mm_struct gets added to this list  when MADV_MERGEABLE is called.
>>>> In the case of the child process, since MADV_MERGEABLE has not been
>>>> invoked yet, its mm_struct is not part of the list. As a result,
>>>> its ksm_merging_pages counter is not reset.
>>>>
>>> Would this flag be inherited during fork? VM_MERGEABLE is saved in related vma
>>> I don't see it would be dropped during fork. Maybe missed.
>>>
>>>>>> value remained unchanged. That’s why get_my_merging_page() in the child was
>>>>>> returning a non-zero value.
>>>>>>
>>>>> I guess you mean the get_my_merging_page() in __mmap_and_merge_range() return
>>>>> a non-zero value. But there is ksm_unmerge() before it. Why this ksm_unmerge()
>>>>> couldn't reset the value, but a ksm_unmerge() in parent could.
>>>>>
>>>>>> Initially, I fixed the issue by calling ksm_unmerge() before the fork(), and
>>>>>> that
>>>>>> resolved the problem. Later, I decided it would be cleaner to move the
>>>>>> ksm_unmerge() call to the test cleanup phase.
>>>>>>
>>>>> Also all the tests before test_prctl_fork(), except test_prctl(), calls
>>>>>
>>>>>      ksft_test_result(!range_maps_duplicates());
>>>>>
>>>>> If the previous tests succeed, it means there is no duplicate pages. This
>>>>> means ksm_merging_pages should be 0 before test_prctl_fork() if other tests
>>>>> pass. And the child process would inherit a 0 ksm_merging_pages. (A quick test
>>>>> proves it.)
>>>> If I understand correctly, all the tests are calling MADV_UNMERGEABLE,
>>>> which internally calls break_ksm() in the kernel. This function replaces the
>>>> KSM page with an exclusive anonymous page. However, the
>>>> ksm_merging_pages counters are not updated at this point.
>>>>
>>>> The function range_maps_duplicates(map, size) checks whether the pages
>>>> have been unmerged. Since break_ksm() does perform the unmerge, this
>>>> function returns false, and the test passes.
>>>>
>>>> The ksm_merging_pages update happens later via the ksm_scan_thread().
>>>> That’s why we observe that ksm_merging_pages values are not reset
>>>> immediately after the test finishes.
>>>>
>>> Not familiar with ksm internal. But the ksm_merging_pages counter still has
>>> non-zero value when all merged pages are unmerged makes me feel odd.
>>>
>>>> If we add a sleep(1) after the MADV_UNMERGEABLE call, we can see that
>>>> the ksm_merging_pages values are reset after the sleep.
>>>>
>>>> Once the test completes successfully, we can call ksm_unmerge(), which
>>>> will immediately reset the ksm_merging_pages value. This way, in the fork
>>>> test, the child process will also see the correct value.
>>>>> So which part of the story I missed?
>>>>>
>>>> So, during the cleanup phase after a successful test, we can call
>>>> ksm_unmerge() to reset the counter. Do you see any issue with
>>>> this approach?
>>>>
>>> It looks there is no issue with an extra ksm_unmerge().
>>>
>>> But one more question. Why an extra ksm_unmerge() could help.
>>>
>>> Here is what we have during test:
>>>
>>>
>>>     test_prot_none()
>>>         !range_maps_duplicates()
>>>         ksm_unmerge()                  1) <--- newly add
>>>     test_prctl_fork()
>>>         >--- in child
>>>         __mmap_and_merge_range()
>>>             ksm_unmerge()              2) <--- already have
>>>
>>> As you mentioned above ksm_unmerge() would immediately reset
>>> ksm_merging_pages, why ksm_unmerge() at 2) still leave ksm_merging_pages
>>> non-zero? And the one at 1) could help.
>>
> >From the debugging, what I understood is:
>> When we perform fork(), MADV_MERGEABLE, or PR_SET_MEMORY_MERGE, the
>> mm_struct of the process gets added to the ksm_mm_slot list. As a
>> result, both the parent and child processes’ mm_struct structures
>> will be present in ksm_mm_slot.
>>
>> When KSM merges the pages, it creates a ksm_rmap_item for each page,
>> and the ksm_merging_pages counter is incremented accordingly.
>>
>> Since the parent process did the merge, its mm_struct is present in
>> ksm_mm_slot, and ksm_rmap_item entries are created for all the merged
>> pages.
>>
>> When a process is forked, the child’s mm_struct is also added to
>> ksm_mm_slot, and it inherits the ksm_merging_pages count. However,
>> no ksm_rmap_item entries are created for the child process because it
>> did not do any merge.
>>
>> When ksm_unmerge() is called, it iterates over all processes in
>> ksm_mm_slot. In our case, both the parent and child are present. It
>> first processes the parent, which has ksm_rmap_item entries, so it
>> unmerges the pages and resets the ksm_merging_pages counter.
>>
>> For the child, since it did not perform any actual merging, it does not
>> have any ksm_rmap_item entries. Therefore, there are no pages to unmerge,
>> and the counter remains unchanged.
>>
> Thanks for the detailed analysis.
>
> So the key is child has no ksm_rmap_item which will not clear ksm_merging_page
> on ksm_unmerge().
>
>> So, only processes that performed KSM merging will have their counters
>> updated during ksm_unmerge(). The child process, having not initiated any
>> merging, retains the inherited counter value without any update.
>>
>> So from a testing point of view, I think it is better to reset the
>> counters as part of the cleanup code to ensure that the next tests do
>> not get incorrect values.
>>
> Hmm... I agree from the test point of view based on current situation.
>
> While maybe this is also a check point for later version.

Are you okay to proceed with the current patch in this series?

>
>> The question I have is: is it correct to keep the inherited
>> |ksm_merging_page|
>> value in the child or Should we reset it to 0 during |ksm_fork()|?
>>
> Very good question. There looks to be something wrong, but I am not sure this
> is the correct way.

ok.

I am going through it and will come up with a fix along with a test for 
this scenario. I will post it as a separate series.


>
>>> Or there is still some timing issue like sleep(1) you did?
>>>

