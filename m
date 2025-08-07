Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF84C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 09:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713C48E0001; Thu,  7 Aug 2025 05:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2EF8E0002; Thu,  7 Aug 2025 05:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591568E0001; Thu,  7 Aug 2025 05:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45A248E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:26:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FF7B1402A5
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:26:46 +0000 (UTC)
X-FDA: 83749431612.15.6893B95
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id E88A4C0005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:26:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b8oYo392;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754558804; a=rsa-sha256;
	cv=none;
	b=G/zNPm1Vva9X0/VCYgyYbDcwOjgtfDw4s5jllqK7nKvXic3HJuO3CWQP4PNkNpRZZZILrD
	KcTbRV+Wm2+9x7o9EDRtD/ptVV2P28xCjC7Dyp2m+/HzAcOpZwgxoM3Ww6/NH3YbnzZrjB
	we9WR8lXzB8QPa/S1DM/WKa1M7Jdyh4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b8oYo392;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754558804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HtBbpc8CX6/g0hj1osOlGVlIONmWAFXX5Df86apHsCA=;
	b=XInjnEkrpefhyb+RDmr9FaFYSsxQg65BaYmw4kZBhapaE8hKYfFfqMa4DkoXfS1aQP4qAe
	yOvMa7XrAvKMtglLsfsRxIoWE8T19FZ1B5gdg7oTtcsj377HkYhIH3gmGx/Leo5gqi6QPv
	d+F+RTtH0KswOJO41U8x0lR2GwvebJE=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5776kXBQ018719;
	Thu, 7 Aug 2025 09:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HtBbpc
	8CX6/g0hj1osOlGVlIONmWAFXX5Df86apHsCA=; b=b8oYo392JZ9KPdQfZvW1yg
	yXjL/mSesNZQpEPEZamzRgn9cqmfgfVfIfvgslaA/xmKAI/MCAOtUMDL718Uz4wp
	0Qf4LxCUGFrkArrXgje759XSj1CA/CLzY49s6L03zHPcXlGaVw8Qt2iwjN5a3xkL
	FKwIQpH8zDJJzOPtUg/vYHeOADNOUg4XMCgheg88TrNMPwrbFkPj5shov0R/Wxfp
	wF5KB3AGAAh9Khmpt9GdOGfmQJeCqbmbHNwYWag9T5kBKDWjEFWTlXJGhzZGZ0l4
	VL7dMByLxZw0lo0jHuT926272aHa5RY3UJr589acOV+opAq8a9qRDkBbFfioNY3g
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq6395nj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 09:26:38 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5779Qb46011519;
	Thu, 7 Aug 2025 09:26:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq6395ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 09:26:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57752CGV025910;
	Thu, 7 Aug 2025 09:26:36 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48bpwn7x05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 09:26:36 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5779Qaue30868028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Aug 2025 09:26:36 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 064D058057;
	Thu,  7 Aug 2025 09:26:36 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13F5C58058;
	Thu,  7 Aug 2025 09:26:30 +0000 (GMT)
Received: from [9.109.245.113] (unknown [9.109.245.113])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Aug 2025 09:26:29 +0000 (GMT)
Message-ID: <111d2351-3fb7-4011-af07-78b40874d956@linux.ibm.com>
Date: Thu, 7 Aug 2025 14:56:28 +0530
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
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250806145432.nygrslkiyvzulujn@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=NInV+16g c=1 sm=1 tr=0 ts=6894714e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=G4KbePK-NKx5Xlsl9MIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cs8q0z50iEOqbQtM-UroqxXp2SxZOBan
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDA3MyBTYWx0ZWRfX/BAtRJtTAZAy
 OFau9aI4q6cLNLf6CaQzDdOiJxXSzj0zDWX8uA3MhDBJcgFkPPmuPsStyh1iRylaDFpmJ7qGeAl
 OqGk3isXLliBEeR6X2Y0gKPGay5NP7CrDnv8XODhr5a1Xl3H4hHN1XBLzZJuDVIMdczVLu2AO68
 jsAnOuOack80drzoZpG4edV86LAhe07rGbwmc705Kip9AN059mayz2Mhs8ocZVo3AwVt8oWfPvK
 L2EwtJtMbKcgNLfG7YKwRDXRCUyNPHyly0gt7D5dp0xwNiYrV8B1cRY/RViaNLEfAvl0U/oCZcF
 XXKVm96edRuOnrOm75dvS0+QEUVfwSETOHyMW8BJecR2yFqxNRQXUBHb6xIvkQCImyvWXRJiZp8
 5l7o48ZOK9J6bxIasL5giV3yDRr4nfuxP8Gb6CR5QH79vz0fyL2GvqYiVS/4roun/Roz9fVT
X-Proofpoint-ORIG-GUID: A71PnRco0sTo52NZs3C2OQYx5jRa28hi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_01,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508070073
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E88A4C0005
X-Stat-Signature: pr1iwe884hkpkhd5jguqfd7sins4d5np
X-Rspam-User: 
X-HE-Tag: 1754558803-790095
X-HE-Meta: U2FsdGVkX19+jkMkVb+WyG5XuIoyS5CSbUXFABJQv+is6s0S8VmKu1kxiFhA9MU4mZdpkRssPx9SEmK8ONl6x11vg2lFbeSGhmoNnHo7m7nDfUqZhrXaIk3xykQfFuioMmHP7vfvslGXHdJ0bM482t9K9Ej5zd5o9w2AnV/sX6bN2/5E2aVZdgwrAuEZcomYP5oT5LJBrTKFQLvFqRQoYwlqTcOw8yNMzlTDjxmCT1a+FNk/ju7tv+6P+E0vloF7CAZU7iai84te+cFjclZTaFtKrk/GkZJi06AfLhSS5sdyBXEjcE/0o6U/GCHksBX/MlmsAwOwg+rHpzPKu4YKN7QT8+9XaWy8N3VxV3mVyyzpt+zHGTGqKWoW2MXj0XlXU7F5JKWRFa2tlsNwzpMtlIJuQDXNryvW6ch0/PwZbwqnXyxFbid7F9Fz/WyRxc0koQB5CCq6Txe6COY5jj7JLX/nY3DQh8qOTxQnEl6Eg6a/Id2Q5yEu91/bXAgf30ACuBAluPkZCYQA85wA4z7g69lBSdIEvTQn7JzbvG2X5IRbNR6HBBFGlowk5BvjIBQug7Nk5PwIiqjAwzKdvNQOMpo5iWZWDKS+yqbO7Zp/AWNlcydbRyCVXMBbiIlqNq3YmmRkt0+0SIFWR/ESAvpPnzlVqGl5K8+4R7+UBZKbNV3Lr36Gsq3LI7l3hd28/4/6R7cMtB1InUpQxT8pq0jT7LlfmBN5i1F371Wf5bc11QO5qvcTDn4F+zjqowR9dGZhYrqEQkBRWHijexWQIKengrGOzI+h5ljVCEVPLBcC4Z5Ws5kYBnw1Oehh6mfaAlwRh8lNA0qfE/wUdGQtpl163gPBbaoU4Yg5B8Itif81AJdD1h1YFdkW/Aq3P9FEhF8++kJoRtVQUiT8Q68vC9EWhn8bcLVBvHP/2E0QTZjYRyAEWwLwyVMRAMHsGf6uk/4uU0DtFgmJ/w6vg59bSaT
 T4IBW3E8
 rfnGsDmU7LQnu78J7Gna9taC5LQYbSSvjeXvB2iEk5WcF3702/teCC1pMapiKF3/xcaaMqrww0fIA1JQb2iGfkl/d10qTGGeMozedf5mXu/OPaigFYv+p3M8Bdx7x3U/ZuCBprd9I1k/rIg51fno6rIct8EMvWxFR+SlOelIZWyKbp69kWILD5P6/hwW9vCEQAt1XltJOpSViyOxI+2V91680RHdYipTMiFozfzTCgIBOtyS47nUnrCVJcWT36q40lOPoG5VX7rNVVfR5f0R5RGu6Si1/xRFVynLrgQOsouRh96iLLS1mcJRWd87qwFB3Nxcpx1Te8sVqQYogalJa03EFeJcRVO+SlMH/bBEu/FdRj2NMVd9fpkoN7AFSKSEoUvOhwBAFRoD5G6In/GuHf2jUKn6dKpvNyoPkUshndoTqpA2z/3a44PuV2FwO9vEXCzi0P0kd9mDMZFG+oJlvAOV0MlCl4DtE4F5uII6mqVr9xIsgy1JzdTiqvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/6/25 8:24 PM, Wei Yang wrote:
> On Wed, Aug 06, 2025 at 06:30:37PM +0530, Donet Tom wrote:
> [...]
>>> Child process inherit the ksm_merging_pages from parent, which is reasonable
>>> to me. But I am confused why ksm_unmerge() would just reset ksm_merging_pages
>>> for parent and leave ksm_merging_pages in child process unchanged.
>>>
>>> ksm_unmerge() writes to /sys/kernel/mm/ksm/run, which is a system wide sysfs
>>> interface. I expect it applies to both parent and child.
>> I am not very familiar with the KSM code, but from what I understand:
>>
>> The ksm_merging_pages counter is maintained per mm_struct. When
>> we write to /sys/kernel/mm/ksm/run, unmerging is triggered, and the
>> counters are updated for all mm_structs present in the ksm_mm_slot list.
>>
>> A mm_struct gets added to this list  when MADV_MERGEABLE is called.
>> In the case of the child process, since MADV_MERGEABLE has not been
>> invoked yet, its mm_struct is not part of the list. As a result,
>> its ksm_merging_pages counter is not reset.
>>
> Would this flag be inherited during fork? VM_MERGEABLE is saved in related vma
> I don't see it would be dropped during fork. Maybe missed.
>
>>>> value remained unchanged. That’s why get_my_merging_page() in the child was
>>>> returning a non-zero value.
>>>>
>>> I guess you mean the get_my_merging_page() in __mmap_and_merge_range() return
>>> a non-zero value. But there is ksm_unmerge() before it. Why this ksm_unmerge()
>>> couldn't reset the value, but a ksm_unmerge() in parent could.
>>>
>>>> Initially, I fixed the issue by calling ksm_unmerge() before the fork(), and
>>>> that
>>>> resolved the problem. Later, I decided it would be cleaner to move the
>>>> ksm_unmerge() call to the test cleanup phase.
>>>>
>>> Also all the tests before test_prctl_fork(), except test_prctl(), calls
>>>
>>>     ksft_test_result(!range_maps_duplicates());
>>>
>>> If the previous tests succeed, it means there is no duplicate pages. This
>>> means ksm_merging_pages should be 0 before test_prctl_fork() if other tests
>>> pass. And the child process would inherit a 0 ksm_merging_pages. (A quick test
>>> proves it.)
>>
>> If I understand correctly, all the tests are calling MADV_UNMERGEABLE,
>> which internally calls break_ksm() in the kernel. This function replaces the
>> KSM page with an exclusive anonymous page. However, the
>> ksm_merging_pages counters are not updated at this point.
>>
>> The function range_maps_duplicates(map, size) checks whether the pages
>> have been unmerged. Since break_ksm() does perform the unmerge, this
>> function returns false, and the test passes.
>>
>> The ksm_merging_pages update happens later via the ksm_scan_thread().
>> That’s why we observe that ksm_merging_pages values are not reset
>> immediately after the test finishes.
>>
> Not familiar with ksm internal. But the ksm_merging_pages counter still has
> non-zero value when all merged pages are unmerged makes me feel odd.
>
>> If we add a sleep(1) after the MADV_UNMERGEABLE call, we can see that
>> the ksm_merging_pages values are reset after the sleep.
>>
>> Once the test completes successfully, we can call ksm_unmerge(), which
>> will immediately reset the ksm_merging_pages value. This way, in the fork
>> test, the child process will also see the correct value.
>>> So which part of the story I missed?
>>>
>> So, during the cleanup phase after a successful test, we can call
>> ksm_unmerge() to reset the counter. Do you see any issue with
>> this approach?
>>
> It looks there is no issue with an extra ksm_unmerge().
>
> But one more question. Why an extra ksm_unmerge() could help.
>
> Here is what we have during test:
>
>
>    test_prot_none()
>        !range_maps_duplicates()
>        ksm_unmerge()                  1) <--- newly add
>    test_prctl_fork()
>        >--- in child
>        __mmap_and_merge_range()
>            ksm_unmerge()              2) <--- already have
>
> As you mentioned above ksm_unmerge() would immediately reset
> ksm_merging_pages, why ksm_unmerge() at 2) still leave ksm_merging_pages
> non-zero? And the one at 1) could help.


 From the debugging, what I understood is:

When we perform fork(), MADV_MERGEABLE, or PR_SET_MEMORY_MERGE, the
mm_struct of the process gets added to the ksm_mm_slot list. As a
result, both the parent and child processes’ mm_struct structures
will be present in ksm_mm_slot.

When KSM merges the pages, it creates a ksm_rmap_item for each page,
and the ksm_merging_pages counter is incremented accordingly.

Since the parent process did the merge, its mm_struct is present in
ksm_mm_slot, and ksm_rmap_item entries are created for all the merged
pages.

When a process is forked, the child’s mm_struct is also added to
ksm_mm_slot, and it inherits the ksm_merging_pages count. However,
no ksm_rmap_item entries are created for the child process because it
did not do any merge.

When ksm_unmerge() is called, it iterates over all processes in
ksm_mm_slot. In our case, both the parent and child are present. It
first processes the parent, which has ksm_rmap_item entries, so it
unmerges the pages and resets the ksm_merging_pages counter.

For the child, since it did not perform any actual merging, it does not
have any ksm_rmap_item entries. Therefore, there are no pages to unmerge,
and the counter remains unchanged.

So, only processes that performed KSM merging will have their counters
updated during ksm_unmerge(). The child process, having not initiated any
merging, retains the inherited counter value without any update.

So from a testing point of view, I think it is better to reset the
counters as part of the cleanup code to ensure that the next tests do
not get incorrect values.

The question I have is: is it correct to keep the inherited 
|ksm_merging_page|
value in the child or Should we reset it to 0 during |ksm_fork()|?

>
> Or there is still some timing issue like sleep(1) you did?
>

