Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DCAF506FF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 06:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BAD96B0005; Tue, 17 Mar 2026 02:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9925E6B0088; Tue, 17 Mar 2026 02:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881BE6B0089; Tue, 17 Mar 2026 02:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2366B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:00:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11EB113B0C9
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:00:44 +0000 (UTC)
X-FDA: 84554506008.27.C31055B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94E39C0003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:00:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="A/HXc1Yo";
	spf=pass (imf22.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773727241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Yjg5g/Ahc6j34B08hDY6aKdtXUYcqbFsbEYEzxC3OU=;
	b=BL16oUWnhR1Nq3XjEwB3/cz13Z+XrMl314IXygMqsHvOa1bN56AVf+asftxdw6FB4Kapft
	FCs0sOCLgb8LDi+ilQ/qGk0fyKd7DyIujucoFTuZwj2hjn/TqOtXqLjsyL8c+UvU1nw1y0
	9a5nzbmDAmZVGhzfxOCemXZXE/MWLzY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="A/HXc1Yo";
	spf=pass (imf22.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773727241; a=rsa-sha256;
	cv=none;
	b=4D+3ECbsWzD0vYcRolH569hNRvpuW5lgmyWAok+oKmSIZsKJg5m2A5U+8mbNAT3faMzZd1
	cX3/PRYmcuvQL+VZ/RejAOUhIQ0lHygHgUZwablTRJhqxaeCei+/ON3sy1xG0ltbX1VUiX
	lBcSRRL4Gex3DHBFxOMiU7tb2RMa7uQ=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GNNRLK3931551;
	Tue, 17 Mar 2026 06:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5Yjg5g
	/Ahc6j34B08hDY6aKdtXUYcqbFsbEYEzxC3OU=; b=A/HXc1YoYpQ8e0y0khcJx7
	YkJ1bo4JF3HC7EyuqyQsPGg0tVAynOUnVoxW3sRGBuQIGnLOHD4KFYg6TyzT/JJs
	RTXRW3emRR7IeCRym7NjxelfxZW8tIzCNAY3UNwml6l4SEMnKE2a0aUI5Wvb+xbC
	rX+Ii+6WnDueAhBDu41lq7K6jig1/z4UbfkVK7JcRubNz9WFC1Xy0+LsyKYfeS6c
	htpjOG6es0mDIeKkIA/UFFY1M647NOIKsbmuOPJqxH5mu0JgZkE6GgztZb4/gegQ
	xl1n3NSdAsp+wcr7UxknXAWLIB6eeX4MLHxbDytBWm8wmJsHbaztrVzbc8CSp1KA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvyauas9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Mar 2026 06:00:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62H5sKeJ005412;
	Tue, 17 Mar 2026 06:00:32 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwj0s7xyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Mar 2026 06:00:32 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62H60VbG30409360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 06:00:31 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFBA958052;
	Tue, 17 Mar 2026 06:00:31 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B945C58050;
	Tue, 17 Mar 2026 06:00:26 +0000 (GMT)
Received: from [9.109.249.251] (unknown [9.109.249.251])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Mar 2026 06:00:26 +0000 (GMT)
Message-ID: <cf815c21-138e-44c8-986d-d8496503ee32@linux.ibm.com>
Date: Tue, 17 Mar 2026 11:30:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] selftests/mm: fix failures and robustness
 improvements
Content-Language: en-GB
To: Sayali Patil <sayalip@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko
 <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1773305677.git.sayalip@linux.ibm.com>
 <20260312150526.3662b2717b9a91776a2e43f5@linux-foundation.org>
 <1f944b56-acb6-44ee-8cc2-6031fcedaeaa@linux.ibm.com>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <1f944b56-acb6-44ee-8cc2-6031fcedaeaa@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA0NyBTYWx0ZWRfX+UdZtfvf5grV
 4145cssHg2Zlpgr4ZiB8zKRTrq5yXg7hPMvdvqWjwhroyurTRe1ut+wD0PuJec0919RNjAIREbE
 CoiKtyGwKHQwWEbClIC93aJ8ctkSiEBYQhrXjdw5+cB03EEc5bqsE/Cbw1PPSqgRSm31WP2k51n
 YzG44mJR2QNhcArUOKMCYffu/pnQ7+0EQm0zYwYGKHzaHFoQxMq5rpJcZ1cBlmTK2T4gDv6JLvZ
 pEwn/0LeqEYaRY8bq/tgEMEwGqH2N//4sNRWd1wx+V6j7DWL3Y6nIiT1cRrWMB3uVMC4QUkPvmE
 YXxb20OXEsZxEFgejEooJL/hMzBsSTulYdYJi+N2y0uRqVQX9c3XCMVBkPEzSBA5TU/dKDP1AAX
 AemShboyQQmrzXojp0TkMdW+n3pDzpGbsIkfH+aPPEpFF9xbv7kCEno+xk6NAsf+eORcCrwGsda
 Q4zIXMSr2uqFG62sbjQ==
X-Authority-Analysis: v=2.4 cv=GIQF0+NK c=1 sm=1 tr=0 ts=69b8ee01 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=v5kZQaA_ZERCB-NnuxkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: cRTqZndxSEC7CgUEAR5nuNwsEFknjtV0
X-Proofpoint-GUID: aPR9dRKlnxe4-p9tKIl3u6q1blr5e4HN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170047
X-Rspamd-Queue-Id: 94E39C0003
X-Stat-Signature: fddrhp4xwjhuieditdhou4wny1n5gc4t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773727241-368003
X-HE-Meta: U2FsdGVkX1+waYH3tdUkFeqVgfTLzZ/ohz/+cz/LUE1Tjymcel2aIdkLLYFVpH5xIucmG75x2g/XpURPOPjKLKgg0BxvfGwpl+jIUsHALMkVfn7OHKhCC2I7wy07t6FhmRPqxVw8YzhOiuZjNyWebiJ6EXcrRX+RNplBmKL9xBDzjY0CrxXzVZzPHJF5xjjZcff66nqg9Spvf758VBDUqX6cAu7GmMlJwu6sxSHKHT2B+2wFnjEpizOKwbVY1REAQknU2M/sWoso+2ygtpi/eyvlTlgd3adhYerNd9jU5W5xE8fLKxNHRZ2LLMCef7jIga9IaXvapmgycR5uIuw6pFm0pkdc2DIl80b15muEhrIxvwFzLCkHr0mlrbvCfAMIp+XPUkvJWpkJ4vaHfj9SnDdj3GmvUxzgBG8IBjytbFJLQNf0hLQA8EvoVvyCYtLUHpbwxosgL5eApZyuN+IEV2EYp2LluC89hh07jM4zQCCfrjsq/KX3L9P2sc/uy4hP5MErutuqaovKkGzVEi6DfHK9Ll4mcydWiu9qGbFRNXmmA53RJNti5yVv0hgYE2Nv7dbRc0WBjjgEXIvP8T2YPOHbVM/86pcOzzD6pq8xL3YI+pJFWm/h6vMKIMPa/h/jhhwenV2uLgi/2j5dW9VtbxXbN0+4I1Wj6O1dRt3Dgy6QfaWfu8D670ynL7E/r9LOHsybkF8ZDTt0WQwLSNM3NFkzFTvxonaoWtcwP7CwNHZgG/CVfA9dufWoHKzb5x3s41wPADcpBm3KUETGlKr7+Y6ZGpI1jkrFWoIp0WwPXynn95gE/NSoBN7rcvxC0HzZGCvVoPYhWLhkjnpJkGBHfl5F46vzmzzDfx+pU9yyp0otmjCj3HXVi0bzwGGhZz5YtnVUIgFXsUNfKDiL/+v0+LnmFhPOnZ5qgTZ1XcCc3vE5s3mGboBPcTI627WytcxZZyGze47R4FIRum+Jv9e
 GIqN2d5m
 gAOjTDny1plHKFt/0tCqvwkeIgRDAJAThRrbQOqVjjnoMm1xl8YiORMIizCPW/szscecJJO7emMLX/CJNhycmM89lQATLoX7kRGQpgdu6TdNb0weiCSuog2ywaFWEDmz3ZVL+om78UcT8L8xSvgMALJWfeqXiVj3xoc1ePu0C0uHWV2DLA/mrHSNhhP+A7fssdcGOitBXs6Gpe/0BpzFBVVMf0sHRXt2wYFOB7HKyNMTWMprmlfRSdq2xgarTYiVkuD+x2hDpINFRWJm14nhWkU5fkpZ/mdQ0Cs7YpoK393X+gDaRtQQgdLLwwpjWF5Mo1a9o+LwechFhD6AdIHvpNLbl8Yyt3tSqJhO71yzYBvNTvKfXUuROwawHix7DzlN+rS4909eDBWdpAWyQTqJKPbntqbY6HzwkxUNLzcKBTJtdxyvYoYsI3sAdPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 13/03/26 7:46 pm, Sayali Patil wrote:
>
> On 13/03/26 03:35, Andrew Morton wrote:
>> On Thu, 12 Mar 2026 17:55:27 +0530 Sayali Patil 
>> <sayalip@linux.ibm.com> wrote:
>>
>>> Hi all,
>>>
>>> Powerpc systems with a 64K base page size exposed several issues while
>>> running mm selftests. Some tests assume specific hugetlb 
>>> configurations,
>>> use incorrect interfaces, or fail instead of skipping when the required
>>> kernel features are not available.
>>>
>>> This series fixes these issues and improves test robustness.


Hello Sayali,


I still see, below test failure. Apart from this, everyting else is 
working as expected.


# # ------------------------------------------------
# # running ./hugetlb_reparenting_test.sh -cgroup-v2
# # ------------------------------------------------
# # cleanup
# #
# # Test charge, rmdir, uncharge
# # mkdir
# # write
# # Writing to this path: /mnt/huge/test
# # Writing this size: 26843545600
# # Populating.
# # Not writing to memory.
# # Using method=0
# # Shared mapping.
# # RESERVE mapping.
# # Allocating using HUGETLBFS.
# #
# # rmdir
# # uncharge
# # cleanup
# # done
# #
# #
# # Test child only hugetlb usage
# # setup
# # write
# # Writing to this path: /mnt/huge/test2
# # Writing this size: 26843545600
# # Populating.
# # Not writing to memory.
# # Using method=0
# # Shared mapping.
# # RESERVE mapping.
# # Allocating using HUGETLBFS.
# #
# # Assert memory charged correctly for child only use.
# # actual = 11 MB
# # expected = 0 MB
# # FAIL
# # cleanup
# # [FAIL]
# not ok 12 hugetlb_reparenting_test.sh -cgroup-v2 # exit=1


Regards,

Venkat.

>> Thanks, I updated mm.git's mm-new branch to this version.
>>
>>> ---
>>> v1->v2
>>>    - For "selftests/mm: ensure destination is hugetlb-backed in 
>>> hugepage-mremap":
>>>      update FLAGS definition to MAP_HUGETLB | MAP_SHARED | 
>>> MAP_POPULATE and
>>>      used it for mmap() calls as suggested during review.
>> That was a really small change (below).  It's better to wait a while
>> (half to one week) before resending an entire series.  So as to
>> hopefully accumulate more changes.
>>
>>
>>
>> --- a/tools/testing/selftests/mm/hugepage-mremap.c~b
>> +++ a/tools/testing/selftests/mm/hugepage-mremap.c
>> @@ -31,7 +31,7 @@
>>   #define MB_TO_BYTES(x) (x * 1024 * 1024)
>>     #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
>> -#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
>> +#define FLAGS (MAP_HUGETLB | MAP_SHARED | MAP_POPULATE)
>>     static void check_bytes(char *addr)
>>   {
>> @@ -121,23 +121,20 @@ int main(int argc, char *argv[])
>>         /* mmap to a PUD aligned address to hopefully trigger pmd 
>> sharing. */
>>       unsigned long suggested_addr = 0x7eaa40000000;
>> -    void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
>> -               MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
>> +    void *haddr = mmap((void *)suggested_addr, length, PROTECTION, 
>> FLAGS, fd, 0);
>>       ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
>>       if (haddr == MAP_FAILED)
>>           ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
>>         /* mmap again to a dummy address to hopefully trigger pmd 
>> sharing. */
>>       suggested_addr = 0x7daa40000000;
>> -    void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
>> -               MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
>> +    void *daddr = mmap((void *)suggested_addr, length, PROTECTION, 
>> FLAGS, fd, 0);
>>       ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
>>       if (daddr == MAP_FAILED)
>>           ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
>>         suggested_addr = 0x7faa40000000;
>> -    void *vaddr = mmap((void *)suggested_addr, length, PROTECTION,
>> -            MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
>> +    void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, 
>> FLAGS, fd, 0);
>>       ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
>>       if (vaddr == MAP_FAILED)
>>           ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
>> _
>>
>>
> Thanks for the guidance. I'll make sure to follow this approach from 
> next time.
>

