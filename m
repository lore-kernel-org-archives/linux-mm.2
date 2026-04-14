Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F3BED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3626B0088; Tue, 14 Apr 2026 06:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18ADC6B008A; Tue, 14 Apr 2026 06:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A18D6B0092; Tue, 14 Apr 2026 06:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFD666B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:23:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86C8413B0C3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:23:16 +0000 (UTC)
X-FDA: 84656773992.17.680EA3F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 179DE80008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:23:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=n2da2o0g;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776162194; a=rsa-sha256;
	cv=none;
	b=YlstD0uHR27aAju5W/gwq2BOalzheGMush6K7EOryRDoC1XGe9vYVoC6ZIcOxgwJyU88lr
	SoZDOFaQzV5psMTpoccg7YPnydmWU+NDJuZWcS5W+KvYhzTNnM1bqskRDT2MqP6UHnfwOG
	xj8gfng0B4WMeEViSyZS0JFpq1KoYXM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776162194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FihMCdbUY/b/FdnKbYCNmnTUdtxsqCs/gl03zVa9OcM=;
	b=p5CycNZd6+H1stdl7XNveZlRTzhvW0PwjulNlEFU+zL5JKy344fzCZsd/7LGr9FfWXUjry
	rEVouBh3mDCeXJlAXfbwkEqqggxGPwUxcTqe+4ScDTX7a7u79B+TcsWLgzy3jZU5jFfdmp
	+rxVLZYnau+LbXpO9Ffskh1BUd/Wyow=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=n2da2o0g;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIqvj1860578;
	Tue, 14 Apr 2026 10:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FihMCd
	bUY/b/FdnKbYCNmnTUdtxsqCs/gl03zVa9OcM=; b=n2da2o0gkxNGhkK10y3iDy
	6oqlXR9tYHiVi0A5UzKP3g0qhGG1whsKyGkSn8+pd3xqpAbT3AB4eqn+huZ062bO
	XM7oUF8pj3rGl/P/alH337B1MX8Qry+f+iiudzqp5zZ2MujpxpneYhj3ak2QSZj/
	UXN+q2R5BOQMWTcr4w0rXNSKSupVSDh5d9nslB+qIHU32tUVgaNxubMEb5/Aojto
	Q5Aej/2dAJJ6kdeyvzxJdd64wdBzE8Jp8znmmKZKAhmQHn749w+1XCAWszA4wbOT
	H0jyFV/DntsD0NpUsbz9nwY1Ui+qoxdsspsQ5/m9R3BBWD0LErLERNzUR3r9Si4g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89pa374-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 10:23:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E605g5025862;
	Tue, 14 Apr 2026 10:23:07 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujgtep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 10:23:07 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EAN68P66716032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 10:23:06 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9E7758053;
	Tue, 14 Apr 2026 10:23:06 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9F0258059;
	Tue, 14 Apr 2026 10:22:58 +0000 (GMT)
Received: from [9.39.26.89] (unknown [9.39.26.89])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 10:22:58 +0000 (GMT)
Message-ID: <939e47eb-c9a7-439e-a29b-9e47cf929ad3@linux.ibm.com>
Date: Tue, 14 Apr 2026 15:52:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/53] selftests/mm: protection_keys: use descriptive test
 names in TAP output
To: Mike Rapoport <rppt@kernel.org>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-16-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-16-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: FyERWf2s-5YIgrN_-T-E8DWjFXb2jsjM
X-Proofpoint-ORIG-GUID: R2g7pKoOr5bAFxwrgfPZXC0tZLbJCqOv
X-Authority-Analysis: v=2.4 cv=WbE8rUhX c=1 sm=1 tr=0 ts=69de158d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=HsfyH7dA0B6ikMpfNBUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA5NiBTYWx0ZWRfX1J0uiTo4qd0x
 tm0u5/q1PR4Ct07E/bDQcFeOyBatVubZ0ENGMCYl54PT5BsQYc/jL4Uw0v+zD0NSPD1IBFx5BZ4
 scaSM1etaoRHPY8GmjONMGjHo6WkfMSm+YWC6UCtAZHJZPtjEJra1JkPCABri2mhLHe3O5sDDfM
 hJSB9sp0ysNmbHuGtveF2QPmmaVmkMGUGsf/PmFcYH+rVlMtE7QkZLu3CWZqK3S+XpTA9iEiZkg
 zP5cSZjTEztLQTxH3GJ8bBfpJHhXous07sGh/DuTQEEnuU8BwJ4/cnMaIULRBDpHHDSsUIh6BtA
 tUc6jqRV8V7jelMdoAJLGL+TGtTsjbya6UsYyhfoXtsMfCV/eFwaYpDFsvBUYXTQj+Kx+MzQ2E8
 a8yuYvuzymP+/aj4dQWFp+ToUTHY1CUETAj1xnqk9yZi6nXqAIv64XrXrNgYZLJbMQbskZvvlj2
 Xjc6zZPURUoE2+pTc1Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140096
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 179DE80008
X-Stat-Signature: zaeexbj5k4tupkq3bsjw7awp686r56zn
X-HE-Tag: 1776162193-24062
X-HE-Meta: U2FsdGVkX1+pKiTYHy4XSqOkH5KhxzvsyjzPBLl94/i5ZE6borbgF5GIdfLS8ZUWzYzrzfBozxPfU59+K5PPZjrYMQ6FnJbB0Xz7FF/W4bf+K/hFgKSktAoOv6WxpX2ABVgg6+N2ANOwsnRQ96Rzq/yc9/H69ywCUEwiTfAxAB8JseufLILCOzuo5xA8F+LkOGesiFN9F/wbRk/s8AXbqzBM+yFwQjJSMCx147aMO7QNDclEa4SaAKWucTLtOQiZZiz6IAD6t6WcOmeM746qWcXPZr3iMmPcqfi8As4urFPFDI8Dvtjsj34dvf8NpCarLeSgVK+EqMoMSPeZqMYwIm8cykl1yGUOQFxzgzxSVN4SQcYev7ocCwsr/zKiQ7r23Q/GpdzhJBFL2cRJWJA1Ilx/koGesvC0eiuRCUgrP22JHJnN2ZBOhb9Mf2NzqBGTQtZml4lP4rZhOTApk4AMFDhhCATlqCy2ryQ7HPBvacjuT1sLyrV6ORB/INo6GTjTQTpKjVStrxGgH7sxqppD+jgn5NmeDUUkTDmQ3ccu3+272VJFI81eZWG1oes8H4ZW1b7Y2/nwItAP566gAXZo5waPmrAS82B5/izWpycp3b4sQxwIZklKXawHa0fQQqLz+zoLTrcLi+lPgTMDs3GQTRrY3cmDFOUoUh4sz4OsTmp5qYGKecV+QDDH2nlZQXvSX0jwwag4r/5wqSuxzNVZMMtqfs1Ou2WO6KxfAGcBiBYtCpw3CxGYQBI6POmUVrbxa157zRbNHawBcvYxS/4wW/SYwjSsw394XZQRd+p31Q8rXVUi9n+JiB6Yq1M8OK/k3eHC8FdBVJnVe5uJryqPgvXLBsg5+Eo3FUItpIT5qRGUqv/qTZXNeMwTdHRGgsQqFLe6g+8JDqsElkI5YrRjyAxMoe/sEoxoP1wA1qC1zRJYR2pgriMqQpsutxYX+IA5FjizH5OLOr72jiU/ykc
 4XapZSiK
 BECE2q5bLDxWGV2Rg9GAcjMCeOMBl7M3aISOX9ILbNRS87PXCNsnvSFH26dsEpoirlBmqZgV8+q707Cep1w2GhcgQFxLB5jLmjVTi1+LJv/R4XuzjzgL5Qk4U5GFZoU7yGk+OoyaWtHYGXRudFEcJgpV4hK8RCpzxskAxpphsXxd77P3RxCkKC8zKfZkYdwOIACaIoABnC13HAg+nHBM1cC2AiWu0LTIydrt9ZqNewVj3U3HvtI8Hy35IKlf36sp8I5oYVVLIQo6UTCdRo8uuS+bH1TmJk8cBEGtiQ548CYIseQ+z2zZUxef5yM8m/2wqKCdjbEGAJ5tZgOWieY/FJwwpxASZKriqA+P9B9e3oyRrs7Gc2jTfqNH6r7MyzpC/sLD/Gd7Qr2l9RB6gEjvf91fqLssO1VLWDtpn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike


On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Replace the numeric test index in TAP output with the actual test
> function name.
>
> Use a structure containing function pointer and its name rather than
> only the function pointer in the pkey_tests array.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/protection_keys.c | 55 +++++++++++---------
>   1 file changed, 31 insertions(+), 24 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index 2085982dba69..80c6124e8378 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -1692,29 +1692,36 @@ static void test_mprotect_pkey_on_unsupported_cpu(int *ptr, u16 pkey)
>   	pkey_assert(sret < 0);
>   }
>   
> -static void (*pkey_tests[])(int *ptr, u16 pkey) = {
> -	test_read_of_write_disabled_region,
> -	test_read_of_access_disabled_region,
> -	test_read_of_access_disabled_region_with_page_already_mapped,
> -	test_write_of_write_disabled_region,
> -	test_write_of_write_disabled_region_with_page_already_mapped,
> -	test_write_of_access_disabled_region,
> -	test_write_of_access_disabled_region_with_page_already_mapped,
> -	test_kernel_write_of_access_disabled_region,
> -	test_kernel_write_of_write_disabled_region,
> -	test_kernel_gup_of_access_disabled_region,
> -	test_kernel_gup_write_to_write_disabled_region,
> -	test_executing_on_unreadable_memory,
> -	test_implicit_mprotect_exec_only_memory,
> -	test_mprotect_with_pkey_0,
> -	test_ptrace_of_child,
> -	test_pkey_init_state,
> -	test_pkey_syscalls_on_non_allocated_pkey,
> -	test_pkey_syscalls_bad_args,
> -	test_pkey_alloc_exhaust,
> -	test_pkey_alloc_free_attach_pkey0,
> +struct pkey_test {
> +	void (*func)(int *ptr, u16 pkey);
> +	const char *name;
> +};
> +
> +#define PKEY_TEST(fn) { fn, #fn }
> +
> +static struct pkey_test pkey_tests[] = {
> +	PKEY_TEST(test_read_of_write_disabled_region),
> +	PKEY_TEST(test_read_of_access_disabled_region),
> +	PKEY_TEST(test_read_of_access_disabled_region_with_page_already_mapped),
> +	PKEY_TEST(test_write_of_write_disabled_region),
> +	PKEY_TEST(test_write_of_write_disabled_region_with_page_already_mapped),
> +	PKEY_TEST(test_write_of_access_disabled_region),
> +	PKEY_TEST(test_write_of_access_disabled_region_with_page_already_mapped),
> +	PKEY_TEST(test_kernel_write_of_access_disabled_region),
> +	PKEY_TEST(test_kernel_write_of_write_disabled_region),
> +	PKEY_TEST(test_kernel_gup_of_access_disabled_region),
> +	PKEY_TEST(test_kernel_gup_write_to_write_disabled_region),
> +	PKEY_TEST(test_executing_on_unreadable_memory),
> +	PKEY_TEST(test_implicit_mprotect_exec_only_memory),
> +	PKEY_TEST(test_mprotect_with_pkey_0),
> +	PKEY_TEST(test_ptrace_of_child),
> +	PKEY_TEST(test_pkey_init_state),
> +	PKEY_TEST(test_pkey_syscalls_on_non_allocated_pkey),
> +	PKEY_TEST(test_pkey_syscalls_bad_args),
> +	PKEY_TEST(test_pkey_alloc_exhaust),
> +	PKEY_TEST(test_pkey_alloc_free_attach_pkey0),
>   #if defined(__i386__) || defined(__x86_64__) || defined(__aarch64__)
> -	test_ptrace_modifies_pkru,
> +	PKEY_TEST(test_ptrace_modifies_pkru),
>   #endif
>   };
>   
> @@ -1735,7 +1742,7 @@ static void run_tests_once(void)
>   		dprintf1("test %d starting with pkey: %d\n", test_nr, pkey);
>   		ptr = malloc_pkey(PAGE_SIZE, prot, pkey);
>   		dprintf1("test %d starting...\n", test_nr);
> -		pkey_tests[test_nr](ptr, pkey);
> +		pkey_tests[test_nr].func(ptr, pkey);
>   		dprintf1("freeing test memory: %p\n", ptr);
>   		free_pkey_malloc(ptr);
>   		sys_pkey_free(pkey);
> @@ -1746,7 +1753,7 @@ static void run_tests_once(void)
>   		tracing_off();
>   		close_test_fds();
>   
> -		printf("test %2d PASSED (iteration %d)\n", test_nr, iteration_nr);
> +		printf("test %s PASSED (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
>   		dprintf1("======================\n\n");
>   	}
>   	iteration_nr++;


LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet


