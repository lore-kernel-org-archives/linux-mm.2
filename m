Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AC2C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C25D8E0002; Tue,  5 Aug 2025 02:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A528E0001; Tue,  5 Aug 2025 02:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188128E0002; Tue,  5 Aug 2025 02:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09D108E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:09:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5316C5DD98
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:09:43 +0000 (UTC)
X-FDA: 83741677446.19.9E86CDF
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id DAF5B140002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:09:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PCyEjKdV;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754374181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZIUdYnSrH8hLHLCb8+749ChGGZ8R8KtKeM+yeFqK6M=;
	b=AFExFqSCmR2sIXRZwzABbT9EfZgtxuSfRQvDTprd2qt+WduvAfldHRdijzCi6jSMcNXhv7
	8Gywo6NcgwHkNVFtGa6sQT2IV1juNpiIUUqAB7ix6H4Haz1PhdPam5YFgvX+GyeN9BytpS
	6j0DZM29b3Cv6QaQ9qxAuRgxmNf6o78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754374181; a=rsa-sha256;
	cv=none;
	b=ehx2vQq/qpJ7pHhvxpfjTWmFhWDjLafFzWDZqHsChGKUCaJplyITUzWeemriNyQcpYnXpE
	WKTpSzBWliYiAxy0kIcd1QmfBsRVzciRzkBF1cHweskCr+RnLu6eouw/9iHFBGdJKyMmBC
	NDBrDMehdZkP6l6f0QAJbXB9Yq3lx+Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PCyEjKdV;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5754twoK000914;
	Tue, 5 Aug 2025 06:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=KZIUdY
	nSrH8hLHLCb8+749ChGGZ8R8KtKeM+yeFqK6M=; b=PCyEjKdVzoiKo7aeakZCBD
	dTtxSd/6ikCQAd/elqlWw/JDFE3i/qLg9FPEWM3MXUBDcLVODJ3da1DtZyNlZLCt
	PJg1nPYoti3+TEwYu2F2bKv6Q68DrVat19dAA5HQZTlSnKgq/CdSitHvvhsCHBS9
	Rvxx26efTAqktt5ODblTPJtJs5MOFevZ55e7/t2vAf20PuoC5J6SEwPNeoN5BbJ1
	SQhKtWKi4THkgIgO0tktTSRHk+C6eFARkU67zMsa349ajaZxfa1wG3GS1ICSYjMx
	vm0aZQkJ5c7c1dqNKaEQJFlbHtoHv28/w7vSmXFJFX7KwuKtp/h5o4pJ3RP3IQQw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bbbq07wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 06:09:32 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57569WLr013800;
	Tue, 5 Aug 2025 06:09:32 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bbbq07wf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 06:09:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5754fB0T006873;
	Tue, 5 Aug 2025 06:09:31 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489xgmh2dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 06:09:31 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57569UgB22282868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 06:09:30 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 754B35813E;
	Tue,  5 Aug 2025 06:09:30 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71EF858124;
	Tue,  5 Aug 2025 06:09:17 +0000 (GMT)
Received: from [9.109.245.113] (unknown [9.109.245.113])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 06:09:17 +0000 (GMT)
Message-ID: <20fb853c-7d79-4d26-9c8a-f6ce9367d424@linux.ibm.com>
Date: Tue, 5 Aug 2025 11:39:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] selftest/mm: Fix ksm_funtional_test failures
To: Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, ritesh.list@gmail.com
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-4-aboorvad@linux.ibm.com>
 <20250804091141.ifwryfmgjepwrog4@master>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250804091141.ifwryfmgjepwrog4@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k3p7J4adTRlrZ9ZmUW45SmpQ7mAGp2RF
X-Authority-Analysis: v=2.4 cv=M65NKzws c=1 sm=1 tr=0 ts=6891a01c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=0R2oKJRu712hfJE7rpUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: aDV2fjvZ8eW6TQSfXuRrIfKTplaaXBqG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDAzNyBTYWx0ZWRfX0Zx4ttLZjAVU
 MkjHC9a9E8hxGzo8KaSa/xD5kERSTjlpLOEGXz+LwvGVu9ypduqLtuTSLO5wAtsNC38EaLaoxn9
 jGPGGwSl7oVPr1lriJlIVPWFmYvLpJBLDxWCZmvCLtz23b00//y4Io6jTJF1ppg5dqZj5+N7Dfe
 u7UxmqJBiSuLLlNTOPo4hRUdjoNwoeG4XJR1S65Oeu2sZ4ev4CCt9toK02E9/wHHAjlsSGKg1AQ
 8xXnZVffvG21nJmOx68m16pKWYy6TRWsznfAN0hCSnR0KoGobD3zO42BIfPv00En1Y0cao60Ud1
 qJAZNVTQ2RXAEMkfdYp5wUPjeO9qvWt9i92VEbscnusnoc/iuT9SXjP2doH/uNjQ3Rb4iA9zkQu
 P/zzPLVUmAwqq6Ihgj+Rl5/TdFRucHTt0z09PBgyYyqbFsMThb7ezLTeoaXpW3R5Evp6Gf/G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_01,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050037
X-Rspamd-Queue-Id: DAF5B140002
X-Stat-Signature: m31yxzfuijec3tnj67yifi4uxhipyb7f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754374180-154476
X-HE-Meta: U2FsdGVkX1/c5ZdSxS1V9E61ql84ECYS6sDhcQNroRCl8eb0tDRsuSJ32BEJ/X3C3dt5VlB5n7crJuL1qDyXPD8vpOSBn/bMmTBA4KBd6hofJXhLJxhp5pnLvfCMdD3hDJPBQJbGAmiwukhz0M//3MtqQiyp3zyCdaLyHiKzyXG9iLWl1jra94DmRHNEEScT+NgaikC+Od/eWlNcOJo1oQrdt1ccr77FwharrQ/VmdlwnBUBOWwHaJsACp65AyFE1Ke+O2YYNJcVw7erXsgZDJJ9WMA7tWnHZD2AH8g1QKdQPhl39j9xE1PlIX1cdzVmOfgxbOFafShEa3UALAmKbzMG3QCTTWCnEVF7BODiuV0IPN4+/KeMvFGHO2x8KTozv5LEmAUtTaLIpOEieXsJXhpCnmRrmg5r0NZXiUXC2a8YVF1OjQOnyX0zyqNMjMVtBdmFQ0f/lF5QvKErHajfH+M16DONgp6QhLWNT0x/eMyW1GXoYQrh0mF1s0Vu0BHdGJ6MvPm8IOw6rBUNhiu+eRHkiSDM3Wt3+ywgL7Q3c1Geg5YPFMnFsKEoKwgrCQa2XPQCzzUFVnY6xXB984efWdgTlJchFaZOeNl42KNLdsuBBQtwGaDYZTCuwlZLwRIAlWblTqB0LLb3EQWdDIleKxI7qm2RhWOMGi0TFyAp34CkYnEcZHRmUQCmmhDiVh3z29HcY0kgtNdwdvVdZ7Th8ZLc8gW/PRyeKZT20z6qzhCBeAH/woMC9wKVEjGRKzX674m4lhCnDQzaURyTI9V+M8OXzqOJ0+EHvkjI95CSSVPkK5euhxwqbrcaTHQ7pC3tOcDOO42tzOIc5uIOZKRL4BRF8jwfF2qTBr+hMclgABPyj6SGVVCsymiw9bWyeRfCmtLb3BS1LaBb132C3ZCmTiI0y3fWKkkczac5+epElqVTBdkirYd1Zj650A/qauj1v4r06hvATNFBc83de+E
 AJWIdeAq
 0XiqKkNhiZ/KxTZ4EJaHxAj6qH/15DonuumqPVDPMOSiDxk0tOHeKNGvRdE0Qhcfll57/gZIyuLKRjyVNn470TKDzg3E7DeHFFYXxLE49JlcgRs5Bh8VhVmwuAJ8bU5ir3x62IYkWsagsf3wmxZQbFvgdgvFPAXTZ7bk5f5dG0fgX4J9ADodPy6kbOPq64/Rt779i8fa/QAjs0oDQgNeC2RxNZRrI5XSrzEWQIPJvb8AqaGPnQ0VCZN5y+lqC7qnib0N7qxykODLN8PWVXEQqyl5RqJ7StQdSW0l4LyQQuQ5CEF3JEzopxT+e6o9Eb6aVoxvSZgVjo3udazx20ZOGS8ZECIB2cXiMDnlwlf87T/5tgoUA4j4YK+rCu8sNZGwu2hjx3t7K7EHBrYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/4/25 2:41 PM, Wei Yang wrote:
> On Tue, Jul 29, 2025 at 11:03:59AM +0530, Aboorva Devarajan wrote:
>> From: Donet Tom <donettom@linux.ibm.com>
>>
>> This patch fixed 2 issues.
>>
>> 1) After fork() in test_prctl_fork, the child process uses the file
>> descriptors from the parent process to read ksm_stat and
>> ksm_merging_pages. This results in incorrect values being read (parent
>> process ksm_stat and ksm_merging_pages will be read in child), causing
>> the test to fail.
>>
>> This patch calls init_global_file_handles() in the child process to
>> ensure that the current process's file descriptors are used to read
>> ksm_stat and ksm_merging_pages.
>>
>> 2) All tests currently call ksm_merge to trigger page merging.
>> To ensure the system remains in a consistent state for subsequent
>> tests, it is better to call ksm_unmerge during the test cleanup phase.
>>
>> In the test_prctl_fork test, after a fork(), reading ksm_merging_pages
>> in the child process returns a non-zero value because a previous test
>> performed a merge, and the child's memory state is inherited from the
>> parent.
>>
>> Although the child process calls ksm_unmerge, the ksm_merging_pages
>> counter in the parent is reset to zero, while the child's counter
>> remains unchanged. This discrepancy causes the test to fail.
>>
>> To avoid this issue, each test should call ksm_unmerge during cleanup
>> to ensure the counter is reset and the system is in a clean state for
>> subsequent tests.
>>
>> execv argument is an array of pointers to null-terminated strings.
>> In this patch we also added NULL in the execv argument.
>>
>> Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec")
>> Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>> tools/testing/selftests/mm/ksm_functional_tests.c | 12 +++++++++++-
>> 1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
>> index d8bd1911dfc0..996dc6645570 100644
>> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
>> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>> @@ -46,6 +46,8 @@ static int ksm_use_zero_pages_fd;
>> static int pagemap_fd;
>> static size_t pagesize;
>>
>> +static void init_global_file_handles(void);
>> +
>> static bool range_maps_duplicates(char *addr, unsigned long size)
>> {
>> 	unsigned long offs_a, offs_b, pfn_a, pfn_b;
>> @@ -274,6 +276,7 @@ static void test_unmerge(void)
>> 	ksft_test_result(!range_maps_duplicates(map, size),
>> 			 "Pages were unmerged\n");
>> unmap:
>> +	ksm_unmerge();
> In __mmap_and_merge_range(), we call ksm_unmerge(). Why this one not help?
>
> Not very familiar with ksm stuff. Would you mind giving more on how this fix
> the failure you see?


The issue I was facing here was test_prctl_fork was failing.

# [RUN] test_prctl_fork
# Still pages merged
#

This issue occurred because the previous test performed a merge, causing
the value of /proc/self/ksm_merging_pages to reflect the number of
deduplicated pages. After that, a fork() was called. Post-fork, the 
child process
inherited the parent's ksm_merging_pages value.

Then, the child process invoked __mmap_and_merge_range(), which resulted
in unmerging the pages and resetting the value. However, since the 
parent process
had performed the merge, its ksm_merging_pages value also got reset to 0.
Meanwhile, the child process had not performed any merge itself, so the 
inherited
value remained unchanged. That’s why get_my_merging_page() in the child was
returning a non-zero value.

Initially, I fixed the issue by calling ksm_unmerge() before the fork(), 
and that
resolved the problem. Later, I decided it would be cleaner to move the
ksm_unmerge() call to the test cleanup phase.


>
>> 	munmap(map, size);
>> }
>>
>> @@ -338,6 +341,7 @@ static void test_unmerge_zero_pages(void)
>> 	ksft_test_result(!range_maps_duplicates(map, size),
>> 			"KSM zero pages were unmerged\n");
>> unmap:
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> }
>>
>> @@ -366,6 +370,7 @@ static void test_unmerge_discarded(void)
>> 	ksft_test_result(!range_maps_duplicates(map, size),
>> 			 "Pages were unmerged\n");
>> unmap:
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> }
>>
>> @@ -452,6 +457,7 @@ static void test_unmerge_uffd_wp(void)
>> close_uffd:
>> 	close(uffd);
>> unmap:
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> }
>> #endif
>> @@ -515,6 +521,7 @@ static int test_child_ksm(void)
>> 	else if (map == MAP_MERGE_SKIP)
>> 		return -3;
>>
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> 	return 0;
>> }
>> @@ -548,6 +555,7 @@ static void test_prctl_fork(void)
>>
>> 	child_pid = fork();
>> 	if (!child_pid) {
>> +		init_global_file_handles();
> Would this leave fd in parent as orphan?
>
>> 		exit(test_child_ksm());
>> 	} else if (child_pid < 0) {
>> 		ksft_test_result_fail("fork() failed\n");
>> @@ -595,7 +603,7 @@ static void test_prctl_fork_exec(void)
>> 		return;
>> 	} else if (child_pid == 0) {
>> 		char *prg_name = "./ksm_functional_tests";
>> -		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME };
>> +		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME, NULL };
>>
>> 		execv(prg_name, argv_for_program);
>> 		return;
>> @@ -644,6 +652,7 @@ static void test_prctl_unmerge(void)
>> 	ksft_test_result(!range_maps_duplicates(map, size),
>> 			 "Pages were unmerged\n");
>> unmap:
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> }
>>
>> @@ -677,6 +686,7 @@ static void test_prot_none(void)
>> 	ksft_test_result(!range_maps_duplicates(map, size),
>> 			 "Pages were unmerged\n");
>> unmap:
>> +	ksm_unmerge();
>> 	munmap(map, size);
>> }
>>
>> -- 
>> 2.47.1
>>

