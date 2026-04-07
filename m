Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D7D0FEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959986B009D; Tue,  7 Apr 2026 08:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A4A6B009F; Tue,  7 Apr 2026 08:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9166B00A8; Tue,  7 Apr 2026 08:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBC06B009D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:13:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21013BB015
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:13:08 +0000 (UTC)
X-FDA: 84631649256.17.283AA45
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id A671E10000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:13:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=glgXtlKx;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9Rjl/2FypYtJRATJktQ2F/Wjw6qbjbKb2kazb+K+eA=;
	b=zqGkQXMsHZregO212fLnOYDaTlvPyTDsc8VfvV3neyqQlyN81zsRyvoezCjmslpBNSDVVp
	yVHEY+0CWGJv6m6/OQ0F4E3dfVs+bVUwL7Ub7RES71rNN9kvx6yUEfy9UgHVSUxNgRhSIc
	kDOcfbtgHs+4AxYTEgAxxkb1fUwExCg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=glgXtlKx;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563985; a=rsa-sha256;
	cv=none;
	b=kTNVu/vuEMBt4V/N/6IhyISxI5krDRCUc80iZ+srLbaH6gllw4KGazrC0SdeoR901+yrsv
	G+6SUPL0ZRciRg9UCXfxPMdx8SSBNIXmKtUOoHYWNYkpkgufCKSG/AQYxO+cIx8vm89SCO
	5AqDifx8PrGXD1yYXDKV4Ky8fo90OZ4=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 636Llk8W2297410;
	Tue, 7 Apr 2026 12:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=f9Rjl/
	2FypYtJRATJktQ2F/Wjw6qbjbKb2kazb+K+eA=; b=glgXtlKxuoGJz/svviTcPD
	pxoVSvZtst3jPDE/8bQy+QAhCK39xNXMouvzc5R6Ookfs64iAgTbMepJUXK+r4LT
	cfOXTcyxjRbjGcuvaSl9n5cD1QWcmqCZoZpOtfefjr9DGZuwaazzbeDhr4UKNBFy
	4trRh/RHr1tXKPkSnh7pah1I76+fBSrq1HYq+QH8KE54CQpPh8tBLzBVUBUM3LWb
	9yYx4qeULbZYdGSphzwX5nDVQbd8lnf8QwJiFGbe+CgqG+OdQTP+ubAaHBJOiUdA
	yuF8VrP587Gi8eXYYvc0E1J2FiaWKAiBbsgE73jtXHlpxS6vfWwtJkIU9iHWo7ig
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2fthbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Apr 2026 12:07:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 637BMXhV019113;
	Tue, 7 Apr 2026 12:07:50 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9b129-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Apr 2026 12:07:50 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 637C7nkI33096362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Apr 2026 12:07:49 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 975775804B;
	Tue,  7 Apr 2026 12:07:49 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6458158059;
	Tue,  7 Apr 2026 12:07:44 +0000 (GMT)
Received: from [9.39.22.34] (unknown [9.39.22.34])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Apr 2026 12:07:44 +0000 (GMT)
Message-ID: <53758376-14e9-4b52-89de-6d68e8c0c6f8@linux.ibm.com>
Date: Tue, 7 Apr 2026 17:37:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/15] selftests/cgroup: extend test_hugetlb_memcg.c to
 support all huge page sizes
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
 <fcc9eb99566af8f37e63924a77dc633c5f200417.1775466330.git.sayalip@linux.ibm.com>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <fcc9eb99566af8f37e63924a77dc633c5f200417.1775466330.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KeridwYD c=1 sm=1 tr=0 ts=69d4f397 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=OnH-2HpHgaBoKrgXaAgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _Yc1ZjkGqeJWOo5dZWrc8kO9K4BwHWcq
X-Proofpoint-GUID: kPQ1rpvp1ZJu1sNFeEirtjwQFQsrvGUw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDExMCBTYWx0ZWRfX4x464uJZ4ocp
 PKH7r0+oe+nLTBo/pizyILwSl9wzhG6FzPbNsBtGIlKS2jvGvKZp1mR5HxBsRR4erpU42GNn3qc
 lb6ilHwf8Q+S0VSXmHW7YJaE9thwnzpHOc2uFklBz0jjHeQ1wLcr2KXon8O9EM5TpHOFk9iMurI
 2v2T6epXGCsAlrJVpfk3QlDbmMc5UfAIuZEvbwHN1ZN1CQx5EIy6csg7E81sJ+/HC+qoOxwSK8j
 lJVzOXQiNc72xmVIejSRiAoj+mTmIL6AkPSYcR3Tyy6wTplckY2DG6UdF2go0hsuVAJzUGsgwU3
 1S3RKUAFXSeOM+AcMcB6cpfux/GaWj+x4xIRuqYQ4vv1gKh9Idh404zst562RsJ4nswfBq3xL1r
 JnC0Q+G5KYN53h9SW7g6nKmkG9nZ6gz/PrvmIScMt5UgAydhuMOPFBoI4UUijv0fiPPkTCR1pNe
 gXdeoiPsiAH78eNwvUA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_02,2026-04-07_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604070110
X-Rspam-User: 
X-Rspamd-Queue-Id: A671E10000F
X-Stat-Signature: 4xnrbb948g5phc7kkf7sajux935k6pyt
X-Rspamd-Server: rspam06
X-HE-Tag: 1775563985-792803
X-HE-Meta: U2FsdGVkX19U5uJbEtCLqoftYG1DuPM9S3Vlq0k6x08B2c5YAL2saG8QqpzpRn9qMA7ibkeBlRcQTpW47MikqvcpPezPuwfkDtlhY17fGKhJ8wDPRJlDVesrMqwrrAwjgMRsrEUfyQD4QY+UbpDaAxoNuXUvKgcKtsrFbLjrR8IqGrHur2yIhDy0/90suoc65QB2I5bQELO1aj55NOaJ3OfBdMjQyQ1UNp8b78LUHctzXi7zLH9RcguMpjhsF9hs+Ko2vvr9Ia7Whr4GtWaEAXvDoz/wBWtHyUPVN/l3juITyejJ4W3wMJ9c6vgxk4DdtyrZa6Kby/4oARVCRRMfTBfr3uEgRZRPl4HUydrt/dOMPuyetQs9IliK1wB+6LW8URPeaMvv/r/xM+5lU9BmR7+jhX1ggkFpSKk89W8QTDrjv/XOW8tCf64fRIvtg0/jPsdqbsgxf/bSRhj7byruzUdDk1UAwscnuquit7JH7EPjMjdUNTvHtsmoSQ74On76lfLFJc9zyalSkllMfCsKxiak+J2aTFngsxiuKVgLzo2gS/JTiYrE7xAOhgl9uGz7qc+EGrdo7hQ+BlMYCAxxQdk7CoPVnNNy+7cW8Ag2/4hJsm872eWAoAyEkJ16BgPY38mFYJAurXB3TsYpVfU3u+VqDcmZx46e7RTGH7PXINnM75yBsS/+9DyLLSITisNvb2ZLwODH/Tk8u6f6CIlg8jDCJdst6kQMe5qec5ds6sprnABT9tlL2LRGWIJeeNph46W343iK/wDYusorCAwYW754X5TNs9zPvtLbZ+g9jLg3nNf3AcG/Zn8UvOHEICaYbmjO6HYo4iSsoXDTNr3BmokaIERRniXS7ufaRDgcQ+74hwjLSYPbN/4UjWEpRv3w/zNSNvNyaaUvFM2oXIdTDrchx/JatEHf3SEunposfhXj/i+sH2h9cfpTAL/uM1kf/M1iTZzI2m7VvBXV0cT
 1xviY8Tz
 ngqBGIyk/o8Gonwg2WdMtG81h7ndEf83riHbgzxs8cI7k7fzOaTqZZ+d6Rp+sS5BYzbTLIsuXzZiYNkFEuOUj6wyX/ia+dU0T+c2jn9Hy04E1AAXLw/JBBwqLEobqxSnAWwSKtzj16vqfxBFABs5t91hcLqVkbk0Npp/19ZoKwlJ5HL82ZN/pqXBpFO3CYtZOQa/TXUEzaSeBuMspJObwX9x+G0G9oo7Ocno8E/y5p+yxn0bI6ZXZePKqhLJ0zw3PGOSs56IL6+y7ABDAzMRA/C8J1ep19iWoA+XCypmOhVeY6W3nqTLNTr+f9piW+7itQ5J5GOK2NTsSYKsnXR4QF6guw7PJI9mcpYXo+2PGnRTStV8Jl/B1HMRD4512qPmfJFFCuUttw1la+pVSGZRibLfuFZygFI+MnbHD8eXbtG7oycGTrzcpU6OpTKY/VjW/NNRR7vapy8cm2cY79beLg+nW+BN+wsAbNgP3sVzhhG9XmRQC8beb585I5kE25BaN+J+g9alKr1HpYUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/04/26 14:49, Sayali Patil wrote:
> The hugetlb memcg selftest was previously skipped when the configured
> huge page size was not 2MB, preventing the test from running on systems
> using other default huge page sizes.
> 
> Detect the system's configured huge page size at runtime and use it for
> the allocation instead of assuming a fixed 2MB size. This allows the
> test to run on configurations using non-2MB huge pages and avoids
> unnecessary skips.
> 
> Fixes: c0dddb7aa5f8 ("selftests: add a selftest to verify hugetlb usage in memcg")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>   .../selftests/cgroup/test_hugetlb_memcg.c     | 90 ++++++++++++++-----
>   1 file changed, 68 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> index f451aa449be6..e6157a784138 100644
> --- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> +++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> @@ -7,15 +7,21 @@
>   #include <stdlib.h>
>   #include <string.h>
>   #include <fcntl.h>
> +#include <stdint.h>
>   #include "kselftest.h"
>   #include "cgroup_util.h"
>   
>   #define ADDR ((void *)(0x0UL))
>   #define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
> -/* mapping 8 MBs == 4 hugepages */
> -#define LENGTH (8UL*1024*1024)
>   #define PROTECTION (PROT_READ | PROT_WRITE)
>   
> +/*
> + * This value matches the kernel's MEMCG_CHARGE_BATCH definition:
> + * see include/linux/memcontrol.h. If the kernel value changes, this
> + * test constant must be updated accordingly to stay consistent.
> + */
> +#define MEMCG_CHARGE_BATCH 64U
> +
>   /* borrowed from mm/hmm-tests.c */
>   static long get_hugepage_size(void)
>   {
> @@ -84,11 +90,11 @@ static unsigned int check_first(char *addr)
>   	return *(unsigned int *)addr;
>   }
>   
> -static void write_data(char *addr)
> +static void write_data(char *addr, size_t length)
>   {
>   	unsigned long i;
>   
> -	for (i = 0; i < LENGTH; i++)
> +	for (i = 0; i < length; i++)
>   		*(addr + i) = (char)i;
>   }
>   
> @@ -96,26 +102,33 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
>   {
>   	char *test_group = (char *)arg;
>   	void *addr;
> +	long hpage_size, batch_bytes;
>   	long old_current, expected_current, current;
>   	int ret = EXIT_FAILURE;
> +	size_t length;
> +	int pagesize, nr_pages;
> +
> +	pagesize = getpagesize();
> +	hpage_size = get_hugepage_size() * 1024;
> +	length = 4 * hpage_size;
> +	batch_bytes = MEMCG_CHARGE_BATCH * pagesize;
>   
>   	old_current = cg_read_long(test_group, "memory.current");
>   	set_nr_hugepages(20);
>   	current = cg_read_long(test_group, "memory.current");
> -	if (current - old_current >= MB(2)) {
> +	if (current - old_current >= hpage_size) {
>   		ksft_print_msg(
>   			"setting nr_hugepages should not increase hugepage usage.\n");
>   		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
>   		return EXIT_FAILURE;
>   	}
>   
> -	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
> -	if (addr == MAP_FAILED) {
> -		ksft_print_msg("fail to mmap.\n");
> -		return EXIT_FAILURE;
> -	}
> +	addr = mmap(ADDR, length, PROTECTION, FLAGS, 0, 0);
> +	if (addr == MAP_FAILED)
> +		ksft_exit_skip("mmap failed, not enough memory.\n");
> +
>   	current = cg_read_long(test_group, "memory.current");
> -	if (current - old_current >= MB(2)) {
> +	if (current - old_current >= hpage_size) {
>   		ksft_print_msg("mmap should not increase hugepage usage.\n");
>   		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
>   		goto out_failed_munmap;
> @@ -124,10 +137,34 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
>   
>   	/* read the first page */
>   	check_first(addr);
> -	expected_current = old_current + MB(2);
> +	nr_pages = hpage_size / pagesize;
> +	expected_current = old_current + hpage_size;
>   	current = cg_read_long(test_group, "memory.current");
> -	if (!values_close(expected_current, current, 5)) {
> -		ksft_print_msg("memory usage should increase by around 2MB.\n");
> +	if (nr_pages < MEMCG_CHARGE_BATCH &&
> +	    (current == old_current ||
> +	    values_close(old_current + batch_bytes, current, 5))) {
> +		/*
> +		 * Memory cgroup charging uses per-CPU stocks and batched updates to the
> +		 *  memcg usage counters. For hugetlb allocations, the number of pages
> +		 *  that memcg charges is expressed in base pages (nr_pages), not
> +		 *  in hugepage units. When the charge for an allocation is smaller than
> +		 *  the internal batching threshold  (nr_pages <  MEMCG_CHARGE_BATCH),
> +		 *  it may be fully satisfied from the CPU’s local stock. In such
> +		 *  cases memory.current does not necessarily increase.
> +		 *
> +		 *  If the local stock is insufficient, it may be refilled in batches
> +		 *  of MEMCG_CHARGE_BATCH base pages, causing memory.current to increase
> +		 *  by more than the allocation size.
> +		 *
> +		 * Therefore, Treat both a zero delta and a batched increase as a
> +		 * valid behaviour here.
> +		 */
> +		if (current == old_current)
> +			ksft_print_msg("allocation consumed from local stock.\n");
> +		else
> +			ksft_print_msg("memcg charge batched via stock refill.\n");
> +	} else if (!values_close(expected_current, current, 5)) {
> +		ksft_print_msg("memory usage should increase by ~1 huge page.\n");
>   		ksft_print_msg(
>   			"expected memory: %ld, actual memory: %ld\n",
>   			expected_current, current);
> @@ -135,11 +172,11 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
>   	}
>   
>   	/* write to the whole range */
> -	write_data(addr);
> +	write_data(addr, length);
>   	current = cg_read_long(test_group, "memory.current");
> -	expected_current = old_current + MB(8);
> +	expected_current = old_current + length;
>   	if (!values_close(expected_current, current, 5)) {
> -		ksft_print_msg("memory usage should increase by around 8MB.\n");
> +		ksft_print_msg("memory usage should increase by around 4 huge pages.\n");
>   		ksft_print_msg(
>   			"expected memory: %ld, actual memory: %ld\n",
>   			expected_current, current);
> @@ -147,7 +184,7 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
>   	}
>   
>   	/* unmap the whole range */
> -	munmap(addr, LENGTH);
> +	munmap(addr, length);
>   	current = cg_read_long(test_group, "memory.current");
>   	expected_current = old_current;
>   	if (!values_close(expected_current, current, 5)) {
> @@ -162,14 +199,17 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
>   	return ret;
>   
>   out_failed_munmap:
> -	munmap(addr, LENGTH);
> +	munmap(addr, length);
>   	return ret;
>   }
>   
>   static int test_hugetlb_memcg(char *root)
>   {
>   	int ret = KSFT_FAIL;
> +	int num_pages = 20;
> +	long hpage_size = get_hugepage_size();
>   	char *test_group;
> +	uint64_t limit;
>   
>   	test_group = cg_name(root, "hugetlb_memcg_test");
>   	if (!test_group || cg_create(test_group)) {
> @@ -177,7 +217,9 @@ static int test_hugetlb_memcg(char *root)
>   		goto out;
>   	}
>   
> -	if (cg_write(test_group, "memory.max", "100M")) {
> +	limit = (uint64_t)num_pages * hpage_size * 1024ULL;
> +
> +	if (cg_write_numeric(test_group, "memory.max", limit)) {
>   		ksft_print_msg("fail to set cgroup memory limit.\n");
>   		goto out;
>   	}
> @@ -200,6 +242,7 @@ int main(int argc, char **argv)
>   {
>   	char root[PATH_MAX];
>   	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
> +	long val;
>   
>   	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
>   	if (has_memory_hugetlb_acc < 0)
> @@ -208,12 +251,15 @@ int main(int argc, char **argv)
>   		ksft_exit_skip("memory hugetlb accounting is disabled\n");
>   
>   	/* Unit is kB! */
> -	if (get_hugepage_size() != 2048) {
> -		ksft_print_msg("test_hugetlb_memcg requires 2MB hugepages\n");
> +	val = get_hugepage_size();
> +	if (val < 0) {
> +		ksft_print_msg("Failed to read hugepage size\n");
>   		ksft_test_result_skip("test_hugetlb_memcg\n");
>   		return ret;
>   	}
>   
> +	ksft_print_msg("Hugepage size: %ld kB\n", val);
> +
>   	if (cg_find_unified_root(root, sizeof(root), NULL))
>   		ksft_exit_skip("cgroup v2 isn't mounted\n");
>   

Observed intermittent failure on some systems, particularly with 1GB 
huge page size, where the memory.current does not reflect the expected 
usage.

I will drop this patch from the series and will take a look at it 
separately.

Thanks,
Sayali

