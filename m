Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A682F531EF
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 06:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F656B0088; Tue, 14 Apr 2026 02:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029CB6B008A; Tue, 14 Apr 2026 02:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BC86B0092; Tue, 14 Apr 2026 02:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C95D36B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:02:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4267E1B7E03
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:02:50 +0000 (UTC)
X-FDA: 84656117700.17.708EAE2
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2B3652000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:02:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BfyKOZ2+;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776146567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWDQMxg7F3RGRGEN5/7/geP+dn+5ST349ef+WqrrB0c=;
	b=VeUfNbHMOIQznsqPTWWgQDEIWRrqLSHbiKkLuvLGdt7NMyyai8SULQ9ew+E43jEjjoZBoH
	68dFZO0wPm6ry6yzCUML4wrmnfVEyBigZ3sfc1LX3y9whQ7X0pEx8oBmFKLfHqMOJY/gsx
	NmZ/q8Dwv6ypommT3s1sJbtKb5wEJ9c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BfyKOZ2+;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776146567; a=rsa-sha256;
	cv=none;
	b=pu+iBOeA/Dq+m0hASwfNMpEMOG7D02V7cGpfseIUN32f8eHmoDBOXbZ9KVCKfTTFS4o1eG
	yYxQoa/1NrfPRJfHaMX2mXSehxUJ/XiPfDS/+J2fvfq8n8C6dsb98bb3gknxKISNRxHWbk
	hVYNBaFUPheNfdCBUsTCQVTcyWqgK1o=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63E3T2ge2557108;
	Tue, 14 Apr 2026 06:02:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nWDQMx
	g7F3RGRGEN5/7/geP+dn+5ST349ef+WqrrB0c=; b=BfyKOZ2+6dejLi0lHUz9/6
	1A7x7bikkroIXc4husKpyEsFgFdEcshAnlI6ENZsBdbjpK5ySW5YwJBoZglGpI2h
	1Q+mC/ZsSUdfyCYMVqGgmaboX94umqJ0/S9CLmwpG7MG1HHC294eqk0/0TzYEnJw
	GgtBIuU3AX6ZKSJs9gtf2sc0DClKkr56XPPSN9U5DyxwOWDItKwaIq07ZPYg9ns8
	89UxPebMmBpJysd+2Y0TTQRdoOyePeYhuUIWjvGxkL9Uepc0ovY0geCnYqs8Cpeo
	Qoy6JIPQayjJqpqo9RRH31FfTnW0PaSohBnEEuJ4+k0k2pfMh5ObJxcoUWkcT1rw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mha94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 06:02:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E4brfj003568;
	Tue, 14 Apr 2026 06:02:38 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg1mn86x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 06:02:38 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E62aFl24642294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 06:02:37 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D896F58063;
	Tue, 14 Apr 2026 06:02:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1AE558043;
	Tue, 14 Apr 2026 06:02:28 +0000 (GMT)
Received: from [9.124.216.98] (unknown [9.124.216.98])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 06:02:28 +0000 (GMT)
Message-ID: <5a3d2ed2-b440-498c-bc1e-bbf81ed37b04@linux.ibm.com>
Date: Tue, 14 Apr 2026 11:32:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/53] selftests/mm: hugetlb-read-hwpoison: use kselftest
 framework
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
 <20260406141735.2179309-12-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-12-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA1MiBTYWx0ZWRfX1f8NuTjeoRY0
 by24hVBqeyu/MNpPTtIPrzWIWiYDkPbWSMgJZIQ7ZU2MtrVaafvMXrUdZwGz9VP/aIZ1FbPQybF
 KXxq14aih8RJoeUViJPONgAfaItYAVhsUbd7oreS0GSvYjutoYHH5wgHFXwQ4ocCgc83FglEp0j
 UU713qfMv4fUREJkLWFz/WaFPyYZDSup4kUKSK8eoaVyVw8cS78PrupP49EgAIRxCbokkNF0oNR
 /mByGkwREzuNmHyLFtRJ3SdzK6UY/Ng8lkRWGeBM0xy28z9HVOxBjQgw0SyFt3dajbeHbocjCLC
 K447lCg+VuUmPnBwe7na3Wvq98q0k7cfV4IbGohlfIYgGwd5WDLtz43mRIwCIFfpQlvHEqWU0WM
 gIWoWW3LNCNNJ38DWxOGB6gtn3iskCqkiyTrZyW9gq/6c/MqG2m8W+l8nv0jl/gazABXKMNUb+T
 DzQ89/PECbbQkF8qebA==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=69ddd87f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=AftCF1cJF-XkbiQbcJwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: soB7GcEIEV8tgeYxKcoYSVFpksCHrW-Q
X-Proofpoint-ORIG-GUID: BAJwZIy_SWzZ99KDy5Y7Q6zJztwKKp3x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140052
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B3652000A
X-Stat-Signature: hfj913pepfuy6gx3nyn5ed46bs1wrx8p
X-Rspamd-Server: rspam06
X-HE-Tag: 1776146565-391953
X-HE-Meta: U2FsdGVkX19y4h0DVFiYhxIHIZmEEdIzkzwC6W9NpWuSpuxpeqVyMG8xa2oqDEIM9Puck8YPbwUUjpMSE7olcc00hvVQerpfPJ3YY8aDqPLCKBJqVvQmI6GloqcBy9/716UkiAwQp3welNKx8RLqL+0bGuGgWPwSZDzjHttQ6cMi0Nk8nHapKyKHOwZ3uL21c4RTtemxce2HateIRyApc4UDYx0bXnyKd57KqFqv/SHix1h8I5oQY5hXA1ANAiX2JocrMe/tplRUlK7yNryQrwl5wHtl3OyrTv6yxrj/nmlYMDORYxysD/rP9xlnnUEVuOhNpFW52WZvx+rvZt/XJcfX+SzDsEQEZw4w4Gh3urMJTZYH9AwHHEijdx39f1MJdqkasJcfKbGQisENjSMaAyXHwghLGHR538V+4Gvp/b1AI4lLUZ++cmuPJdXyEkuzo1rocJDG1Y5GynpxgNtKjekJqP3KBIy6L6uwhMJJpml/PZ2ebIgtDhSQQYg5YVWj3IVr6TpVZTg/MnNDy9JKXEJ75uK+uJ9QfTUFYHYlpSHd+Li5AGJ3yDgwJBVu/Xx+v0NS5OEt1lhrLxKmzNaZ24hrKrdgH3JXAgj3R+Tc6byQhnDmRtgDjTg4dmfLNXN+qBzi4lxfNXl8ppK2aLyq+ofYqpUgjGZAMJ4nu0HF1dT0Ms3gPwDWe7JxBLU3u9o36hqn1DQUSgOihxVSr2beSaPaAOh8V2kIn6OQlTdvjckoaM/4NbddNJ1EQvx4UeIm0GdA4YaO5ZXW4ZFvwLi8mWf2eLGe+TDLer9hf+hKDqlBu7lCRdkDFlLeEfsdJb5lbiOwfUq9L5P6Ii5JTZ5GV+Q0u5luXtsgP5G953JLZTb22UTRnYJYJ9W1zNMac/7VbCjTPBORSIqAxoCsqOxFafXofgLSDncGGdNLFe14iyV4LRN95rrGUEOzg7+7yA1NYc+t0yYhuWeDYErvbZc
 L8wvYnKx
 bRcGvdXeXOIyUd5EWgG8J37ysQV6xLF0Lac/I32eVzuf0P9mdk/MmC+8h7fGXc6QOOOvfjg9Aj0m8ajbkhMv0YgCUc5ZbkiuhHMl2Y05Sa94eqhCyNuc4V0WQXLJsMBxkO4nFB6rckC4p6y9I7yk6mu7VuPfHIClUqPRRnxXHznR0dxusiAQ/XhnOt7s/B/ymY3yEBNBiYKuuDhZpRcwqp2twL5l61TruIHNsE7K0brZwjFxCHssd25p7m3NpHtqwAEkbn7FRuRWd+MbIm1D1bzwXwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Convert hugetlb-read-hwpoison test to use kselftest framework for
> reporting and tracking successful and failing runs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   .../selftests/mm/hugetlb-read-hwpoison.c      | 118 +++++++++---------
>   1 file changed, 57 insertions(+), 61 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> index 6bbf15f78061..01cd5465e0f8 100644
> --- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> +++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> @@ -13,9 +13,7 @@
>   #include <signal.h>
>   
>   #include "kselftest.h"
> -
> -#define PREFIX " ... "
> -#define ERROR_PREFIX " !!! "
> +#include "vm_util.h"
>   
>   #define MAX_WRITE_READ_CHUNK_SIZE (getpagesize() * 16)
>   #define MAX(a, b) (((a) > (b)) ? (a) : (b))
> @@ -26,17 +24,22 @@ enum test_status {
>   	TEST_SKIPPED = 2,
>   };
>   
> -static char *status_to_str(enum test_status status)
> +static void report_status(enum test_status status, const char *test_name,
> +			  size_t chunk_size)
>   {
>   	switch (status) {
>   	case TEST_PASSED:
> -		return "TEST_PASSED";
> +		ksft_test_result_pass("%s chunk_size=0x%lx\n",
> +				      test_name, chunk_size);
> +		break;
>   	case TEST_FAILED:
> -		return "TEST_FAILED";
> +		ksft_test_result_fail("%s chunk_size=0x%lx\n",
> +				      test_name, chunk_size);
> +		break;
>   	case TEST_SKIPPED:
> -		return "TEST_SKIPPED";
> -	default:
> -		return "TEST_???";
> +		ksft_test_result_skip("%s chunk_size=0x%lx\n",
> +				      test_name, chunk_size);
> +		break;
>   	}
>   }
>   
> @@ -59,8 +62,8 @@ static bool verify_chunk(char *buf, size_t len, char val)
>   
>   	for (i = 0; i < len; ++i) {
>   		if (buf[i] != val) {
> -			printf(PREFIX ERROR_PREFIX "check fail: buf[%lu] = %u != %u\n",
> -				i, buf[i], val);
> +			ksft_print_msg("check fail: buf[%lu] = %u != %u\n",
> +				       i, buf[i], val);
>   			return false;
>   		}
>   	}
> @@ -76,21 +79,21 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
>   	ssize_t total_ret_count = 0;
>   	char val = offset / wr_chunk_size + offset % wr_chunk_size;
>   
> -	printf(PREFIX PREFIX "init val=%u with offset=0x%lx\n", val, offset);
> -	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
> -	       expected);
> +	ksft_print_msg("init val=%u with offset=0x%lx\n", val, offset);
> +	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
> +		       expected);
>   	if (lseek(fd, offset, SEEK_SET) < 0) {
> -		perror(PREFIX ERROR_PREFIX "seek failed");
> +		ksft_perror("seek failed");
>   		return false;
>   	}
>   
>   	while (offset + total_ret_count < len) {
>   		ret_count = read(fd, buf, wr_chunk_size);
>   		if (ret_count == 0) {
> -			printf(PREFIX PREFIX "read reach end of the file\n");
> +			ksft_print_msg("read reach end of the file\n");
>   			break;
>   		} else if (ret_count < 0) {
> -			perror(PREFIX ERROR_PREFIX "read failed");
> +			ksft_perror("read failed");
>   			break;
>   		}
>   		++val;
> @@ -99,8 +102,8 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
>   
>   		total_ret_count += ret_count;
>   	}
> -	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
> -	       total_ret_count);
> +	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
> +		       total_ret_count);
>   
>   	return total_ret_count == expected;
>   }
> @@ -113,15 +116,15 @@ static bool read_hugepage_filemap(int fd, size_t len,
>   	ssize_t total_ret_count = 0;
>   	char val = 0;
>   
> -	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
> -	       expected);
> +	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
> +		       expected);
>   	while (total_ret_count < len) {
>   		ret_count = read(fd, buf, wr_chunk_size);
>   		if (ret_count == 0) {
> -			printf(PREFIX PREFIX "read reach end of the file\n");
> +			ksft_print_msg("read reach end of the file\n");
>   			break;
>   		} else if (ret_count < 0) {
> -			perror(PREFIX ERROR_PREFIX "read failed");
> +			ksft_perror("read failed");
>   			break;
>   		}
>   		++val;
> @@ -130,8 +133,8 @@ static bool read_hugepage_filemap(int fd, size_t len,
>   
>   		total_ret_count += ret_count;
>   	}
> -	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
> -	       total_ret_count);
> +	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
> +		       total_ret_count);
>   
>   	return total_ret_count == expected;
>   }
> @@ -143,14 +146,14 @@ test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
>   	char *filemap = NULL;
>   
>   	if (ftruncate(fd, len) < 0) {
> -		perror(PREFIX ERROR_PREFIX "ftruncate failed");
> +		ksft_perror("ftruncate failed");
>   		return status;
>   	}
>   
>   	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
>   		       MAP_SHARED | MAP_POPULATE, fd, 0);
>   	if (filemap == MAP_FAILED) {
> -		perror(PREFIX ERROR_PREFIX "mmap for primary mapping failed");
> +		ksft_perror("mmap for primary mapping failed");
>   		goto done;
>   	}
>   
> @@ -163,7 +166,7 @@ test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
>   	munmap(filemap, len);
>   done:
>   	if (ftruncate(fd, 0) < 0) {
> -		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
> +		ksft_perror("ftruncate back to 0 failed");
>   		status = TEST_FAILED;
>   	}
>   
> @@ -180,14 +183,14 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
>   	const unsigned long pagesize = getpagesize();
>   
>   	if (ftruncate(fd, len) < 0) {
> -		perror(PREFIX ERROR_PREFIX "ftruncate failed");
> +		ksft_perror("ftruncate failed");
>   		return status;
>   	}
>   
>   	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
>   		       MAP_SHARED | MAP_POPULATE, fd, 0);
>   	if (filemap == MAP_FAILED) {
> -		perror(PREFIX ERROR_PREFIX "mmap for primary mapping failed");
> +		ksft_perror("mmap for primary mapping failed");
>   		goto done;
>   	}
>   
> @@ -202,7 +205,7 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
>   	 */
>   	hwp_addr = filemap + len / 2 + pagesize;
>   	if (madvise(hwp_addr, pagesize, MADV_HWPOISON) < 0) {
> -		perror(PREFIX ERROR_PREFIX "MADV_HWPOISON failed");
> +		ksft_perror("MADV_HWPOISON failed");
>   		goto unmap;
>   	}
>   
> @@ -229,7 +232,7 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
>   	munmap(filemap, len);
>   done:
>   	if (ftruncate(fd, 0) < 0) {
> -		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
> +		ksft_perror("ftruncate back to 0 failed");
>   		status = TEST_FAILED;
>   	}
>   
> @@ -242,17 +245,17 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
>   
>   	fd = memfd_create("hugetlb_tmp", MFD_HUGETLB);
>   	if (fd < 0) {
> -		perror(PREFIX ERROR_PREFIX "could not open hugetlbfs file");
> +		ksft_perror("could not open hugetlbfs file");
>   		return -1;
>   	}
>   
>   	memset(file_stat, 0, sizeof(*file_stat));
>   	if (fstatfs(fd, file_stat)) {
> -		perror(PREFIX ERROR_PREFIX "fstatfs failed");
> +		ksft_perror("fstatfs failed");
>   		goto close;
>   	}
>   	if (file_stat->f_type != HUGETLBFS_MAGIC) {
> -		printf(PREFIX ERROR_PREFIX "not hugetlbfs file\n");
> +		ksft_print_msg("not hugetlbfs file\n");
>   		goto close;
>   	}
>   
> @@ -264,7 +267,7 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
>   
>   static void sigbus_handler(int sig)
>   {
> -	printf(PREFIX "received SIGBUS\n");
> +	ksft_print_msg("received SIGBUS\n");
>   }
>   
>   int main(void)
> @@ -279,51 +282,44 @@ int main(void)
>   	};
>   	size_t i;
>   
> +	ksft_print_header();
> +	ksft_set_plan(ARRAY_SIZE(wr_chunk_sizes) * 3);
> +
>   	signal(SIGBUS, sigbus_handler);
>   	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
> -		printf("Write/read chunk size=0x%lx\n",
> -		       wr_chunk_sizes[i]);
> +		ksft_print_msg("Write/read chunk size=0x%lx\n",
> +			       wr_chunk_sizes[i]);
>   
>   		fd = create_hugetlbfs_file(&file_stat);
>   		if (fd < 0)
> -			goto create_failure;
> -		printf(PREFIX "HugeTLB read regression test...\n");
> +			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
> +
>   		status = test_hugetlb_read(fd, file_stat.f_bsize,
>   					   wr_chunk_sizes[i]);
> -		printf(PREFIX "HugeTLB read regression test...%s\n",
> -		       status_to_str(status));
>   		close(fd);
> -		if (status == TEST_FAILED)
> -			return -1;
> +		report_status(status, "HugeTLB read regression",
> +			      wr_chunk_sizes[i]);
>   
>   		fd = create_hugetlbfs_file(&file_stat);
>   		if (fd < 0)
> -			goto create_failure;
> -		printf(PREFIX "HugeTLB read HWPOISON test...\n");
> +			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
> +
>   		status = test_hugetlb_read_hwpoison(fd, file_stat.f_bsize,
>   						    wr_chunk_sizes[i], false);
> -		printf(PREFIX "HugeTLB read HWPOISON test...%s\n",
> -		       status_to_str(status));
>   		close(fd);
> -		if (status == TEST_FAILED)
> -			return -1;
> +		report_status(status, "HugeTLB read HWPOISON",
> +			      wr_chunk_sizes[i]);
>   
>   		fd = create_hugetlbfs_file(&file_stat);
>   		if (fd < 0)
> -			goto create_failure;
> -		printf(PREFIX "HugeTLB seek then read HWPOISON test...\n");
> +			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
> +
>   		status = test_hugetlb_read_hwpoison(fd, file_stat.f_bsize,
>   						    wr_chunk_sizes[i], true);
> -		printf(PREFIX "HugeTLB seek then read HWPOISON test...%s\n",
> -		       status_to_str(status));
>   		close(fd);
> -		if (status == TEST_FAILED)
> -			return -1;
> +		report_status(status, "HugeTLB seek then read HWPOISON",
> +			      wr_chunk_sizes[i]);
>   	}
>   
> -	return 0;
> -
> -create_failure:
> -	printf(ERROR_PREFIX "Abort test: failed to create hugetlbfs file\n");
> -	return -1;
> +	ksft_finished();
>   }


LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet


