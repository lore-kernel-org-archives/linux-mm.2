Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790CCC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7192F6B0115; Tue, 30 Jun 2026 05:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0786B0118; Tue, 30 Jun 2026 05:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2406B0119; Tue, 30 Jun 2026 05:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6636B0115
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:34:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE24AA043B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:34:55 +0000 (UTC)
X-FDA: 84936069750.03.0EFC07F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 58F3D40006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:34:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cebxASRR;
	spf=pass (imf04.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782812093;
	b=yfYTGmZeULDEbJuxIMbKJatp3deBEuzevcYRQazpDnmt6VD5MI6YP+qr21c6fGjgzETesw
	9tmcPRd7Ie/GqFiqB3PIdXEQ9M/DVkYm0Y0ItilneS69b8dZhDa/SbilUzuDplc4LzR9Ca
	kR2gzjpfE/80WicL2pATLVmjrK3WgrA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782812093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FenPuDP/WxCTQU7UzdjqpiqHT2NmDzjGMLRxQu2kEzM=;
	b=5O9n68kTD3QnXoYmEeRJVhn6/IHluyyS8JcuFB1IFE6h1jVrxQNaduL6o9YU2elmlS7nDm
	ZO5uQlZRQtFeBdtZNNOSoEcVhO13qGCfUpuRVmsdoQ1Ak54dNKfCkQp5x3jN+NmVRAMSgo
	hJ7bgd2nHu8fFHLzzpfwyhIOCA8peUY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cebxASRR;
	spf=pass (imf04.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U5mKCC1075952;
	Tue, 30 Jun 2026 09:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FenPuD
	P/WxCTQU7UzdjqpiqHT2NmDzjGMLRxQu2kEzM=; b=cebxASRR3hxKiQx5DNfFDj
	t+BhIzIMZO7GeRJtarPlx77XZtqvZuacbpOyMq6lUjTW+Qf2wReh5qcNAmp7uOwN
	dc2PaiI0RyNTAG0AynK0qyQluSYjcwPpAbx+ubRIQGF/Pv6zKpqHSGTB373xuM5H
	MtpjnBrErqMxVxYM4zGlNpqzwZN0Irwn+CUfmiYneGlr6Xy38sZ2MterTvWKeG0i
	FYOSMVKxAI97EENEbXAtbRGnwingnWeKvrJsCACA5qHIkTFyOUegO3cJcasR0vrp
	P0MvZpLuXsBLFTbObnFzsk34Y7cm3ECVkku8npjJBi0r5tXE7jpi28PBvyJLFLnA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26q9wp0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 09:34:42 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65U9Ybxf009711;
	Tue, 30 Jun 2026 09:34:41 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4f2tbh9dpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 09:34:41 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65U9YfPA14877204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jun 2026 09:34:41 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F3135805D;
	Tue, 30 Jun 2026 09:34:41 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0BBA05805A;
	Tue, 30 Jun 2026 09:34:35 +0000 (GMT)
Received: from [9.39.22.200] (unknown [9.39.22.200])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Jun 2026 09:34:34 +0000 (GMT)
Message-ID: <d8fd276a-0666-4fdc-b7d0-cf2557a52cb7@linux.ibm.com>
Date: Tue, 30 Jun 2026 15:04:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH 2/2] selftests/mm: fix ksm NUMA merge test for systems
 with memoryless NUMA nodes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1782365671.git.sayalip@linux.ibm.com>
 <8540b58ef1fdbc2e5cb2f9fe28a2d2a54a5bc6a8.1782365671.git.sayalip@linux.ibm.com>
 <8663e05b-0e54-4c1a-a7d1-94e49f2ca178@kernel.org>
Content-Language: en-IN
In-Reply-To: <8663e05b-0e54-4c1a-a7d1-94e49f2ca178@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA4MyBTYWx0ZWRfX1KZLq28ZpPUp
 iaPtkFprvQfLvPVnEOIhc7t6JRk1/3w+9ltv2FysZZu7hPtK+P5jhnekugkad7snIpolRe7zjCY
 dDDN5j4qkLhjFB86d21QE8CWhW0FCBJ/CWRJWik2SzSyj0KR+3H9dzl8zOIDo+P7PR9t0ZK3Ec0
 UQ+JrvjOXB29OiRmGYK8GTmg8jnhcFbAyTuxYHj1yRNv8BDDcpvIeO7yLdnvraGZyBs116mGjkB
 Aj22HKAO/+7kNHr0KPNYSc490Gc57+7KflsDnz3eZz99FY/SzRhRe0WuRJywFuTrevdof+vJUYN
 yOSo1eqLHs6/LjhyZ0Hg2gaNBHr3A8t6VR7dzOvmW2jSeu8NtaqjB+9pGlJYT1BhA0nfbF7x3rp
 CYsa/5aUu4tKPNfbvkDp0IU4p9ANjGCb2LWa9fcDvf4lse9ag+Ilcj1q8bo9KTjan4XxnJa1SfE
 cpf9C3aIMcGQ19vToEQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA4MyBTYWx0ZWRfX66AGScQ+2mJ5
 S1/AdZZQAGOCBhI9nPSiDAvSY6N2oa3Hf2F1+S0hPHsecvFyBkAqb8Z8hKccCeaIFpFIDoFosFz
 Ltqnn0mAR4Dy7/kW4vEKstD/pNjX3WM=
X-Proofpoint-GUID: RvQEWbbQd5VsrPDQ1YYdV4ORmXVRvDgL
X-Proofpoint-ORIG-GUID: xxAhTBi4VCx0rALIorlHuqnNvfsmQMYi
X-Authority-Analysis: v=2.4 cv=WZ88rUhX c=1 sm=1 tr=0 ts=6a438db2 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=4BRzb6RNsxKkEMCgDAAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 phishscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606300083
X-Rspam-User: 
X-Stat-Signature: xk4q1ym6z67ia31yxy4m93rks6c6twuf
X-Rspamd-Queue-Id: 58F3D40006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782812093-630099
X-HE-Meta: U2FsdGVkX1/imK2AfkD5OU07k5BEHKTtTLIq+nMp8kGPZZ54FtRoUeu+/C75cO5T/IrOsQiZzGfzTVM1XyA0BAgplb8N8TBEII9t9U2dQDOxueQH1F46q2eoEJ3ZMFMW98dTGNMeyVk8Anxr+eMt5xZCf/YiCijS5vMiP3gEiY4fMIvuw4p6Uq4KANA8YUv0ZA0wB/aor+zO78W3rjsDrvSJWqu8y+nzg8/5+xyTUveG47uAlkv6eiA7LLGSKySy2qvUl52ZVx8oIejb+WghzD9N3FkPtqLg9d1Zkmip2+Zj6HXE6WC9/WRJwkpp9UjSZOSlzkbE9/TW8Zwmct9S61rjA4nspAj8IP2qPX5Q1obE4lL/SDDyLLNlECp0e+qQ+1QPGgguE21gitbrc/0EC5B04CNSoXPtUI99gnq/dnTlxY49urqIgxSKo5lwM5BC4ijK7H+VaGco2cUz+X6B28dHtVSJIdcuJQll/zOwOsw1x4cA4mU4RWzFlMbOMcBSZuF42pydrQ7RUhK+1gOVg0uokRdWZG4nKFDGBdsHBMko9zY0+J5g1JLy0FEnrqRSBQaCz08Q7i3epAvQppRRvXIpBKuOrYFlllVMFORrqcUgOP0ziQZAfUngeJ9KL6wkuM5Ak/CtDJocQpcsTMUFxfZo6W/4XWMf7HM75VMR+dt6PpkAkujWB+4ZZYQO8NH+HEveoH34jaD/b6eBMQ5LMWWNjlCSrgfJlmwB3Ls3mc8ptVibMHrSf5ru/wLDgfRxm1NDzuwZ7S8fiUYHXHGkhIu/XUzFkgorS2bLUcbRrBNIJO6KnqfqW410U1ZMlv5oyPv2mnGmTMHS+K8/EV9PAwRkuVHytv9arYN3BJ6/2HiDiCtp6ovjP7DuOaSw2CmLlPzpQ6LZuDjw7t7I+NsbvxSEuUGsOWSAxv7MyLUhiZNr4ybFAgmynrILZkvduzT7giDFZJ+hsDQIAGVQhrm
 /87qXXRx
 g5suUmj6ax2SxdDCHWXT04sMcmKOfxUssQKCJjFs42rbMoVXsU6bGzsLFnmL3OdKRSW+invJseScDgFXGPlXQKRG0l9XigXjvKOrEul+gpCF0+XDl/49uDwyi2/TRjWB/sIlCizfXlPTu98htEYLue1Sc/BtlKCmLPR1AgGsOb3HS9LMPviy0U/pwqhMNUjN8MWYvT9FKQdVD8sQPzSYsRS11fwuJt1Z+pklp2cTPhYItdZG3jsGD/ClQSn+ox8X6v9F+XzlfhTsP8a96vG0S+vImqpqGR59zLoUjatJKUyyzAInIZ5Th1VzBVX5LhxugRv5gd83plfxXUy1BHVgUKq1XHpSr3bYuPQGU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/06/26 21:25, David Hildenbrand (Arm) wrote:
>>   
>> +static int count_mem_nodes(void)
>> +{
>> +	int node, count = 0;
>> +
>> +	for (node = 0; node <= numa_max_node(); node++) {
>> +		if (numa_node_size(node, NULL) > 0)
>> +			count++;
>> +	}
>> +
>> +	return count;
>> +}
>> +
> 
> Can we instead build upon our existing helpers get_first_mem_node() +
> get_next_mem_node() ?
> 
>  From 432774fb50237519c1c041e402fddfdf4b35aa2c Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Fri, 26 Jun 2026 17:52:21 +0200
> Subject: [PATCH] tmp
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   tools/testing/selftests/mm/ksm_tests.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
> index a050f4840cfa3..2ebbb544c6711 100644
> --- a/tools/testing/selftests/mm/ksm_tests.c
> +++ b/tools/testing/selftests/mm/ksm_tests.c
> @@ -440,9 +440,9 @@ static int get_next_mem_node(int node)
>   		mem_node = i % (max_node + 1);
>   		node_size = numa_node_size(mem_node, NULL);
>   		if (node_size > 0)
> -			break;
> +			return mem_node;
>   	}
> -	return mem_node;
> +	return -ENODEV;
>   }
>   
>   static int get_first_mem_node(void)
> @@ -455,8 +455,8 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
>   {
>   	void *numa1_map_ptr, *numa2_map_ptr;
>   	struct timespec start_time;
> +	int first_node, second_node;
>   	int page_count = 2;
> -	int first_node;
>   
>   	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
>   		ksft_perror("clock_gettime");
> @@ -467,17 +467,19 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
>   		ksft_print_msg("NUMA support not enabled\n");
>   		return KSFT_SKIP;
>   	}
> -	if (numa_num_configured_nodes() <= 1) {
> -		ksft_print_msg("At least 2 NUMA nodes must be available\n");
> +	first_node = get_first_mem_node();
> +	second_node = get_next_mem_node(first_node);
> +
> +	if (second_node < 0) {
> +		ksft_print_msg("At least 2 NUMA nodes with memory must be available\n");
>   		return KSFT_SKIP;
>   	}
>   	if (ksm_write_sysfs(KSM_FP("merge_across_nodes"), merge_across_nodes))
>   		return KSFT_FAIL;
>   
>   	/* allocate 2 pages in 2 different NUMA nodes and fill them with the same data */
> -	first_node = get_first_mem_node();
>   	numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
> -	numa2_map_ptr = numa_alloc_onnode(page_size, get_next_mem_node(first_node));
> +	numa2_map_ptr = numa_alloc_onnode(page_size, second_node);
>   	if (!numa1_map_ptr || !numa2_map_ptr) {
>   		ksft_perror("numa_alloc_onnode");
>   		return KSFT_FAIL;

Hi David,

Thanks for review!

Yes, I updated the implementation in v2 to use the existing
get_first_mem_node() + get_next_mem_node() helper as suggested.

V2:https://lore.kernel.org/all/878cbc1dd24921d55049932dcd5fd6ee517557ca.1782811071.git.sayalip@linux.ibm.com/



