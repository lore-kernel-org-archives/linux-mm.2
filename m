Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6029C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 13:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C20B6B00A0; Wed,  6 Aug 2025 09:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772D48E0002; Wed,  6 Aug 2025 09:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661846B00A2; Wed,  6 Aug 2025 09:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5DB6B00A0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:00:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12A70818A7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:00:58 +0000 (UTC)
X-FDA: 83746342596.07.A1567A5
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5BEC3C0013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:00:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IzumBXAB;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754485255; a=rsa-sha256;
	cv=none;
	b=v+jfTNf3WZ1IDoAlbaPs10LO9YjyT9fUGrifgz28Bxl/cc8SW1NQQMkVVE9u5DNorlOt4B
	7FE91Bwyce6X+ATZpVJcYMD+wL8oM4Rcav79jxm4F+Pw+Qly7L8QoQyzvRGbmby9Ta4i1d
	Vvfs+tgiigeKFBXSPUm7U3gOsxnWEgQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IzumBXAB;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754485255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljFgOMiBRVtDLpOpWjFAyrQWXwloHyc0+prHUNBM090=;
	b=1RjRBLEeqyinlq/4lJNFi8M+9PyuuzyRa3j/UXDiHqofdmtxjMv3JnlHFsdE7ibczKb8sd
	6ErlEVwXrk5QuvBxFNwhwoVVelFQUtDnFxpsT9Sq8aruXy9uO1LwgsK1JCa7AcBEQoRGlw
	Sd01nxZ7rbqHQY7lbNswlESTCeMGsws=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5765S2kI031191;
	Wed, 6 Aug 2025 13:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ljFgOM
	iBRVtDLpOpWjFAyrQWXwloHyc0+prHUNBM090=; b=IzumBXABAXx9aECP6SUKzU
	jE7T0QPVlw4j4Uku8BBojVzEk1h59sNumrV48BJbJ+s5g5nkR5VT+SmJNYRl/Zyf
	BVnCVZ+/iKkB2HBtToLHCsHsuHUixpRcsBp3QK8AYeg41EmrI6DwI78dzHmYM95H
	J4t5zgVa+XGio93grbTV6YccfM5lcPWQj/nxO6v8M27p3/wlrs2CdU77qbPV7i8a
	1XI3yuon/QNdu0IOdL7XbjXtNUBLfqKvoHbRPCYdXrpIRDZ7nmQHtBSBD4K0AHxm
	0c7M3AUF7hM6+RXw15gN5ZTHJM4nIKQEhllWkSQhWAs4cYpjFhs5h+XPK26NBTcA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq61v6ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 13:00:48 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 576D0lrP028162;
	Wed, 6 Aug 2025 13:00:47 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq61v6u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 13:00:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 576CLlCd022661;
	Wed, 6 Aug 2025 13:00:45 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwqbnnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 13:00:45 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 576D0iYI26215072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 Aug 2025 13:00:45 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8E2758057;
	Wed,  6 Aug 2025 13:00:44 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CEF558059;
	Wed,  6 Aug 2025 13:00:39 +0000 (GMT)
Received: from [9.109.245.113] (unknown [9.109.245.113])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  6 Aug 2025 13:00:38 +0000 (GMT)
Message-ID: <e9079694-1e30-46b6-97e7-b79be01c65a6@linux.ibm.com>
Date: Wed, 6 Aug 2025 18:30:37 +0530
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
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250805170353.6vlbyg6qn5hv4yzz@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDA4MiBTYWx0ZWRfX6uhDhzTX0D6p
 zzENgYWe4Cw4S+bLugiRnD2j1vGgk53ulaVl3JNfY7BLso8v/cf4QMd444xqr8of0S6mIUk+iyT
 0C01igUqmT7iZG8Nh8pigcVbQUSHH2dskD4EUYPERHRluunAJtlQnlXZk0xnBlIn4kqadgCUrv7
 sMZnHe+HSjbCtNWOlvY+86nSRbI/GNZreo98fBEpipGlp9b29QDRVdqM+vUZ1LyBrwSFnM877sy
 Z/v41s6iIDKYYacfxwbyBGgS47w8Ho2KqlZ/UENBJ120UH0Ex/GTc77ztVNAqqum6/BRqKWw2h3
 Mp6Vd0qm6e4WSE4JwrrLUg5144BuDIFimppmUjplFd7Qyo4cYw/xAWdWRgH8OnJCqQICXrNAJlF
 27UJ98BsGofaigFTpj5s5fswxWplQijY8uCPVOk+82q97WkMa0gDxHQqjHm/33OWpIPAr+V0
X-Proofpoint-GUID: 2SoYs2zepIRjTMqSQfHJPiZSDc4oaCAF
X-Authority-Analysis: v=2.4 cv=BIuzrEQG c=1 sm=1 tr=0 ts=68935200 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=zGy9US7bIuLH9GykFbwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: -g48qCyw9tYgyzPSZx840atRw_MtDf5i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 malwarescore=0 phishscore=0 bulkscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508060082
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BEC3C0013
X-Stat-Signature: cy6pyon45hi1ykkmqpukt3u7enw4e1tk
X-Rspam-User: 
X-HE-Tag: 1754485255-900484
X-HE-Meta: U2FsdGVkX1+FN8MxqigI/WgV4+Ww5JaCJY7jr/tIrFVw9+zRwVEanSoYYRw4gHjukTlFevGReP05mIKHwlhO3vXJWIjRJP2y/MHAnzo1dR+C3TbuKDjUgAD+z/bQx0+GABjULUfGK9+OygMNg7vzGXlTcEEx8bOAMVF5/BmqPBE4axWOjsI3Jg/WvMlB2UzAc2Ke8+Z4p6L7ToxwXQkvdozctUmO9PJmyKjSOf/mLDM1TpbBKRm6hMPnL/WmenWiA4NXH6FI7HSq6DWJXCbAyRk/p02YppXOzTXTez+e7MMWkgyvqxPZYUyMpGKE6gE6CYEFywQGHwTnb/el7C5gNbsPChNme+z59EYrLq5Sh9n2GP9MO+OujgQ9MajhI2xsVCNJ5ZXdgJpLkp8HAvhlqkLsjb9XByKNGdU4Xed/R8llwnaDst/V3AKOZ7BQPsC0TS0Lv8mu64OEGo6zdW81h0UEipPXczUMFwO3KrNiVGdjH0rtxvnbmFdxi0quUgVsekLmKMe6sui8bgaFgNx+OSfCchnI4ZH95FQ7IPzdOgOtNXI/gAaIgKsen4Z+F0ZJKpiQ4YpxnfcnDjPqwyTkORx88bWds4rxZ1mUFJjiMWcvFupVcwzUwIVa13qwr0qbCl9Sezj3mQoEjrDvBJunwEHXupSvZa4pHjal3A9mSmirl7ZnJlHWIYWR01V+typRouKpyPhXWqvv/Tk2Tq36JIp2LTe87S0Aqo++gaHo4Qy0TdLmSoRovhsO3VBftLkTdhsoYyVe751ZTRg0Cj6VjTqdS2XQ282cs9aseVoZGkq8A68yV9f8hoVfpJx2nL36RD2MomMG7FTLcI5oDRegACEfN43QYjZX+Hy0FZRgCUCne8feeV+9f4zLzO9hSCpLM5RhcWDYULFtNWBrSVnzP7bGd2JxAVCBXw3EuOpInbywxttusdCkVeeM5rvzb0KbkEELRWYiEYf4TrWkW2l
 EvuD1+LC
 uRO5RCbEK1w54p52gl3jn21a1AZQQR8xqxvuk+4Tux3IiVEm3xJjmrGNSQ5PczouOVCKYKp06UKHFW34TFYtkQn2Htrqe4YvR4MZ76ozYmxAnAKGJ0PKMc9Tkdb6Jn8tVC7DxKPwgheoczqZytc5xhTFagX/i5k7NetJotc2euV9MLFjyQiEB2JGyvIbUfzW+q1D51Noa3CTLN2O6Egimh4mJTMjUjrtYG75pu2EWmMUXfI9CMmQoBVYaHEkVU6IyVzO7lRQJxpxyMhxcRiWNCyscF1GizYQuSBXhC1YMWMuGS6tvr7gPKBA96uAHj+e3CriR2a8hHH6YL6JMR8jIiCwyMKLQwD7wi5ji9Oa9SVGn7ERBf4wetRNZVhsbjuXVqg4ClPXmBzaZgR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/5/25 10:33 PM, Wei Yang wrote:
> On Tue, Aug 05, 2025 at 11:39:15AM +0530, Donet Tom wrote:
>> On 8/4/25 2:41 PM, Wei Yang wrote:
>>> On Tue, Jul 29, 2025 at 11:03:59AM +0530, Aboorva Devarajan wrote:
>>>> From: Donet Tom <donettom@linux.ibm.com>
>>>>
> [...]
>>>> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
>>>> index d8bd1911dfc0..996dc6645570 100644
>>>> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
>>>> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>>>> @@ -46,6 +46,8 @@ static int ksm_use_zero_pages_fd;
>>>> static int pagemap_fd;
>>>> static size_t pagesize;
>>>>
>>>> +static void init_global_file_handles(void);
>>>> +
>>>> static bool range_maps_duplicates(char *addr, unsigned long size)
>>>> {
>>>> 	unsigned long offs_a, offs_b, pfn_a, pfn_b;
>>>> @@ -274,6 +276,7 @@ static void test_unmerge(void)
>>>> 	ksft_test_result(!range_maps_duplicates(map, size),
>>>> 			 "Pages were unmerged\n");
>>>> unmap:
>>>> +	ksm_unmerge();
>>> In __mmap_and_merge_range(), we call ksm_unmerge(). Why this one not help?
>>>
>>> Not very familiar with ksm stuff. Would you mind giving more on how this fix
>>> the failure you see?
>>
>> The issue I was facing here was test_prctl_fork was failing.
>>
>> # [RUN] test_prctl_fork
>> # Still pages merged
>> #
>>
>> This issue occurred because the previous test performed a merge, causing
>> the value of /proc/self/ksm_merging_pages to reflect the number of
>> deduplicated pages. After that, a fork() was called. Post-fork, the child
>> process
>> inherited the parent's ksm_merging_pages value.
>>
> Yes, this one is fixed by calling init_global_file_handles() in child.
>
>> Then, the child process invoked __mmap_and_merge_range(), which resulted
>> in unmerging the pages and resetting the value. However, since the parent
>> process
>> had performed the merge, its ksm_merging_pages value also got reset to 0.
>> Meanwhile, the child process had not performed any merge itself, so the
>> inherited
> I assume the behavior described here is after the change to call
> init_global_file_handles() in child.

Yes


>
> Child process inherit the ksm_merging_pages from parent, which is reasonable
> to me. But I am confused why ksm_unmerge() would just reset ksm_merging_pages
> for parent and leave ksm_merging_pages in child process unchanged.
>
> ksm_unmerge() writes to /sys/kernel/mm/ksm/run, which is a system wide sysfs
> interface. I expect it applies to both parent and child.

I am not very familiar with the KSM code, but from what I understand:

The ksm_merging_pages counter is maintained per mm_struct. When
we write to /sys/kernel/mm/ksm/run, unmerging is triggered, and the
counters are updated for all mm_structs present in the ksm_mm_slot list.

A mm_struct gets added to this list  when MADV_MERGEABLE is called.
In the case of the child process, since MADV_MERGEABLE has not been
invoked yet, its mm_struct is not part of the list. As a result,
its ksm_merging_pages counter is not reset.


>> value remained unchanged. That’s why get_my_merging_page() in the child was
>> returning a non-zero value.
>>
> I guess you mean the get_my_merging_page() in __mmap_and_merge_range() return
> a non-zero value. But there is ksm_unmerge() before it. Why this ksm_unmerge()
> couldn't reset the value, but a ksm_unmerge() in parent could.
>
>> Initially, I fixed the issue by calling ksm_unmerge() before the fork(), and
>> that
>> resolved the problem. Later, I decided it would be cleaner to move the
>> ksm_unmerge() call to the test cleanup phase.
>>
> Also all the tests before test_prctl_fork(), except test_prctl(), calls
>
>    ksft_test_result(!range_maps_duplicates());
>
> If the previous tests succeed, it means there is no duplicate pages. This
> means ksm_merging_pages should be 0 before test_prctl_fork() if other tests
> pass. And the child process would inherit a 0 ksm_merging_pages. (A quick test
> proves it.)


If I understand correctly, all the tests are calling MADV_UNMERGEABLE,
which internally calls break_ksm() in the kernel. This function replaces the
KSM page with an exclusive anonymous page. However, the
ksm_merging_pages counters are not updated at this point.

The function range_maps_duplicates(map, size) checks whether the pages
have been unmerged. Since break_ksm() does perform the unmerge, this
function returns false, and the test passes.

The ksm_merging_pages update happens later via the ksm_scan_thread().
That’s why we observe that ksm_merging_pages values are not reset
immediately after the test finishes.

If we add a sleep(1) after the MADV_UNMERGEABLE call, we can see that
the ksm_merging_pages values are reset after the sleep.

Once the test completes successfully, we can call ksm_unmerge(), which
will immediately reset the ksm_merging_pages value. This way, in the fork
test, the child process will also see the correct value.
>
> So which part of the story I missed?
>

So, during the cleanup phase after a successful test, we can call
ksm_unmerge() to reset the counter. Do you see any issue with
this approach?


>

