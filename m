Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7D510FCADC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30BCD6B008A; Wed,  1 Apr 2026 16:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCEC6B008C; Wed,  1 Apr 2026 16:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2DA6B0092; Wed,  1 Apr 2026 16:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10DE36B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:39:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A90CDE02BE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:39:30 +0000 (UTC)
X-FDA: 84611152500.30.5BA4AD4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A469160010
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:39:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SfY0K0Sy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775075968; a=rsa-sha256;
	cv=none;
	b=Jlyc8OAiO/2ppf5DI/zPNTd7R6Lk+kjzxUfGskW5c1XcSx1yL+nwT5QaaBDi/+Z95pm6yw
	Q+K9X4rhwje7c5bx/lsjrdMCx8WEtpG0w4a4lcoa+Kg1C972ocWK4ugzAMD39zfpeDfAcb
	XAbJ9Je/mZMq3h+jfm2KoTkCIrHhJco=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SfY0K0Sy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775075968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFyDQYWvHXwDNnSeTet24tb62Td7pIMgSR2cvMwnqm0=;
	b=Q0G7lU9igvkKt1ZS87qjecMdIR9/Sc/Yb3GDlUf/IKyT9hyz3svdvH973g3etmLZNXE8M6
	/IlN4wedTjiIxuIM/GTRoa6FZz35uxD4TVdUiet/c9C4jnRdAq34keH3D0IfvVf2FHnEMG
	PUH0KC3aCZJF/J3P9GVO40E/NfAZu8I=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631C9VAc347700;
	Wed, 1 Apr 2026 20:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=uFyDQY
	WvHXwDNnSeTet24tb62Td7pIMgSR2cvMwnqm0=; b=SfY0K0SyD27k0V+7cbghlC
	aXnox0s+UDp7GGzrXymXSJqJZXlMM7tSqsx6mfndrALV4MTdBVMPLlOfBAe7Fl4y
	7Crq8ad2Y2Ld2K1j1gYUOqHmP7xL7pu6Khz+68+F4qXRnIYdjMcEVhZkF9wvM6KO
	lAfGvWobyQteZr3iyQsaU4gqPcK1CjLwLMWFBuJs6ll8Q5Nh+uYwMK0NQhyhKXdf
	aZdXIta+bjTuG+bPctgF+ciDMr7tFpw5DL5Q2jCn09U4JXLdMikAiOschlrS94SI
	9Wopdd/5dmxqvHGkA/NGp6Z2GQxsxLTi377C+aznMhrgtXAw7CCrrAs9Iprt1Csg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66q3a42t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 20:39:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 631JEPTf013936;
	Wed, 1 Apr 2026 20:39:18 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6ttkqap6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 20:39:18 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 631KdHA826542624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Apr 2026 20:39:17 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B2D558056;
	Wed,  1 Apr 2026 20:39:17 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5820B58052;
	Wed,  1 Apr 2026 20:39:12 +0000 (GMT)
Received: from [9.124.211.138] (unknown [9.124.211.138])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Apr 2026 20:39:12 +0000 (GMT)
Message-ID: <066a146b-7dbb-408e-bbc0-542bdcdd6681@linux.ibm.com>
Date: Thu, 2 Apr 2026 02:09:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v3 08/13] selftests/mm: ensure destination is
 hugetlb-backed in hugepage-mremap
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
        "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <3b6ffba238a4b59de891acf896fa25d7d3193228.1774591179.git.sayalip@linux.ibm.com>
 <ee15d52f-45df-415b-b0d9-3d267d147e5c@kernel.org>
 <b590a17c-13ed-45f4-9f51-ac662d00e7bf@lucifer.local>
Content-Language: en-IN
In-Reply-To: <b590a17c-13ed-45f4-9f51-ac662d00e7bf@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: iEvn9nC1rSRKV0ItDH2S3_8hPM1sN2Gd
X-Authority-Analysis: v=2.4 cv=frzRpV4f c=1 sm=1 tr=0 ts=69cd8277 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=Ikd4Dj_1AAAA:8
 a=VnNF1IyMAAAA:8 a=qGJu50tjSwPfCeBw4LkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: AChZenxUfvcSqwrWgHOKOoPV2SQ7V8qV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDE5MSBTYWx0ZWRfX6gTg3Qo/OC+a
 NKUxDvTwjJq7HSy8zeYs5FwSJqy2nfjLyOJ1cCP4DSeby6GrSlJvadrKGU+Qbyjb9robLiFWrbh
 AfVWHrnhwKcgY7nJxFq4ZciZ8Z1RtmqPUIhykLM5m1M2AOvxd5Gw9ff4HUshbr13R0r0roTc1/g
 psm4h0oxItvrGm3ahpR4SxWU0QTpqvFMdltwB1ep5y9MfK7dJ5m0V1eQc7MeVoYNMrqPQxySBFC
 D2F1aA9BcU2i9ErzTf2Ds/Zft9olYL/729LF4Yukw8JpiD9m2l061fEwnrSxpVyH9jvObqhlqc/
 vA3RV6tMgpRxGpUB2ld0GCPbZ9dexbt/VAQaC/p3r0rE/6ix9xoOSxeeQi0LS6TTnlPu7rMsxBz
 RrDpEWw8SwosrHyO2OTZqtEZazxUbiJ6TPTqm4nff9NroFGZgnXf6F8iNkBtjzwqwl5SdvwBF1t
 9Q45lo1MM4p7oA5rE+g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_04,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604010191
X-Rspamd-Queue-Id: 2A469160010
X-Stat-Signature: ke3fi77pox6sgug3feaa6mmiwnwpeshy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775075967-327611
X-HE-Meta: U2FsdGVkX1+KnyApoekpAmJry/VxZhq2CskU9uq0Y/GoX01yJQTE64M/17+jdni1x4DAfnvYBecEVzb/sR300FSujzbG3GRCQcpGczQQlKy0hXLadqJVPTCiUFp/98H2j47879Rh30e6c/k7aOho2P9VH1ldOaGtuzrQXJc5CeUxoLpYf+ulHqKFOpBR3oFjEmpyNUt1GgSQwRv181xOjdJXlJTAqeW17mMNPFPJ1lZE3FKaVd/crQPUiWObDTwj21OqFIv06IlCLRl4Q+E3YT+KMIa81uZaQpx2ml37mQY7MdpjbR9iLHHAMlWink6t+FQKSLWpCweYV09afV4QALk32/teD48A8fa2ls+7bRsgVaETZlEN37b2ZxxyztLaDTX5l5lBVqP8L8VoFhOK5+lQiFtWjM/gd1ZB4QtELxqicGyewIRpYr5wQtL7oVwK1+ECLbVCmM0Ki9QOMoWdSL/tHdV4pOrsYpR8Qsy5Yxt9vxNTOs0BZ9p9Gd3FqJ1J1D0JvOzlV+cFePAG/sh3gJ4H08ZyqWKtgI1tHPs7EkNgAv5YtD25iMbgH/A8zF98XNtBRqcPv9FXd7WD8bG2Xhq1rO+NV9/x0p/6XzoQVbE7og2OnvtoBd5pMUUiUC6uNQagJY4hk50AB4upXqgm7Gbecqiy+LkvfCaAUd9+/hfH8rQVMV5qxKOvOkxbGSPGn6Np3ZViDeDSQvXY1Svi/XBFJvb2nuaxaFS7wSOSS2iWRAa2QIJ9gc9OCs3wiNeykHV0jll8O94HRVI+da8zeXzMPoufyPkV2ELxSxTnHD/HSPaLdi5CREeiX2V9ymReGwWJMJWshIUBzL6dS9hFjkGqHbP3eBlf4xXqB9n+rG3Ia74h94vXV66YZMppYLpPZZa8zs9VS5jlUJD34CaJShcK3LkIM/tHMUwqO3AZAmWVrUlPrJ4IWGqqzYpCpzYssZ3awbdsrOxhM1akvZc
 8fJ8vBCu
 BIFHfycfxDZquEyC3n81ogC3XsgE3AXORSdKWZ1F1G5POyoYmU2V4e+KO0bLPNDR7mbCRDmWTP0MFGLf1j4TzmgreAn5y7cjaJ/JbMUCawdRI+Iavu61rSdtxc4LKKYHb4+eU1n9ZJjjzJi06Vul8JVmV+C5PUP2bikpA4P6F0gK8ErC2ozIiPmmC6mmxdKdbnrUbbZoJU/KWP/xq9D6SKghnKRoBKo/jHs1fnJU6hs9N37hu82k9b/4hoRdNc2jni/ng6smiiisI0mVnDTiSyYx5yoZ9GA1XRFkSdtc5QiwBtsKbrt+RaWFRtctkT16Tq2AJK5ETzif68PbGhD/Zp0kdHgbUwpyfcN64NkmrKowFiBxva/lLtpdudA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/04/26 20:10, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Apr 01, 2026 at 04:21:55PM +0200, David Hildenbrand (Arm) wrote:
>> On 3/27/26 08:16, Sayali Patil wrote:
>>> The hugepage-mremap selftest reserves the destination address using a
>>> anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
>>> while the source region is hugetlb-backed.
>>>
>>> When remapping a hugetlb mapping into a base-page VMA may fail with:
>>>
>>>      mremap: Device or resource busy
>>>
>>> This is observed on powerpc hash MMU systems where slice constraints
>>> and page size incompatibilities prevent the remap.
> 
> OK so digging in:
> 
> mremap -> ... -> vrm_set_new_addr() -> get_unmapped_area() -> ... (in ppc arch
> code) -> slice_get_unmapped_area():
> 
> unsigned long slice_get_unmapped_area(unsigned long addr, unsigned long len,
> 				      unsigned long flags, unsigned int psize,
> 				      int topdown)
> {
> 	...
> 	/* bunch of checks */
> 
> 	/* If we have MAP_FIXED and failed the above steps, then error out */
> 	if (fixed)
> 		return -EBUSY;
> 
> 	...
> }
> 
> Is presumably where we hit the issue.
> 
>>>
>>
>> That is weird. An mremap(MREMAP_FIXED) is really just an munmap() + move.
> 
> Yeah the weird bit I guess is that we _still_ invoke get_unmapped_area() but
> with MAP_FIXED set to indicate that we want the specific address, so it's
> subject to the above checks.
> 
>>
>> Are we sure this is not some actual problem in the hugetlb implementation?
> 
> It seems the 'slices' check sees if the _target address_ has an equivalent page
> size, presumably hugetlb-mandated, and fails if they're not equivalent, so this
> change is just accounting for that.
> 
Yes, this change accounts for that by ensuring the destination is 
created with MAP_HUGETLB so it has the same page size as the source.
> 
>>
>>> Ensure the destination region is created using MAP_HUGETLB so that both
>>> source and destination VMAs are hugetlb-backed and compatible. Also add
>>> MAP_POPULATE to the destination mapping to prefault hugepages,
>>> matching the behaviour used for other hugetlb mapping in the test and
>>> ensuring deterministic behaviour.
>>
>> But then the test suddenly requires more hugetlb pages, no? I don't see
>> a good reason for the MAP_POPULATE, really. It will be discarded either way.
> 
> Yeah I'm not sure about the MAP_POPULATE being all that important here.
> 
As far as I understand, without MAP_POPULATE, memory accesses would 
trigger userfaults, and since the test is single-threaded and has no 
background handler for the uffd, it would deadlock. MAP_POPULATE ensures 
the test runs correctly by prefaulting all pages, but please let me know 
if I’m mistaken.
>>
>>>
>>> Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED |
>>> MAP_POPULATE so that both mappings are hugetlb-backed and compatible.
>>> Also use the macro for the mmap() calls to avoid repeating
>>> the flag combination.
>>>
>>> This ensures the test reliably exercises hugetlb mremap instead of
>>> failing due to VMA type mismatch.
>>>
>>> Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>>> ---
>>>   tools/testing/selftests/mm/hugepage-mremap.c | 11 ++++-------
>>>   1 file changed, 4 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
>>> index e611249080d6..48c24a4ba9a7 100644
>>> --- a/tools/testing/selftests/mm/hugepage-mremap.c
>>> +++ b/tools/testing/selftests/mm/hugepage-mremap.c
>>> @@ -31,7 +31,7 @@
>>>   #define MB_TO_BYTES(x) (x * 1024 * 1024)
>>>
>>>   #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
>>> -#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
>>> +#define FLAGS (MAP_HUGETLB | MAP_SHARED | MAP_POPULATE)
>>>
>>>   static void check_bytes(char *addr)
>>>   {
>>> @@ -121,23 +121,20 @@ int main(int argc, char *argv[])
>>>
>>>   	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
>>>   	unsigned long suggested_addr = 0x7eaa40000000;
>>> -	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
>>> -			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
>>> +	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>>>   	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
>>>   	if (haddr == MAP_FAILED)
>>>   		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
>>>
>>>   	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
>>>   	suggested_addr = 0x7daa40000000;
>>> -	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
>>> -			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
>>> +	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>>>   	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
>>>   	if (daddr == MAP_FAILED)
>>>   		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
>>>
>>>   	suggested_addr = 0x7faa40000000;
>>> -	void *vaddr =
>>> -		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
>>> +	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
>>>   	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
>>>   	if (vaddr == MAP_FAILED)
>>>   		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
>>
>>
>> --
>> Cheers,
>>
>> David
> 
> Cheers, Lorenzo


