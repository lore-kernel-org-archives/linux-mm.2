Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BDCEA3C50
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77366B0005; Thu,  9 Apr 2026 07:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B278D6B0088; Thu,  9 Apr 2026 07:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A166F6B008A; Thu,  9 Apr 2026 07:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC686B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:01:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2637C140774
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:01:33 +0000 (UTC)
X-FDA: 84638726466.19.5632E5C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id 819781C000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:01:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H8S0gGFn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775732490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIMyBL9VKU3VOm9TAm9cZevyUsGgECvXVpjQxPXiBno=;
	b=f+CQMnByTuGC4l8VjzK8I4RE8ayLh6ODtP8AsQ4+HUZA2/ykqWYRftVGl4P9dyuAqavOLb
	ts0qZYEc1+3ZVsNPVgIumOZbGCQN0ri1Uj+/DeCXRfFFpucbTz7DRqClQxbixpOfOVysH9
	3/UMTlbrG5NVe5TmEPG7gu7rfQ7y5M8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775732490; a=rsa-sha256;
	cv=none;
	b=bNkq7AMH2VkSVc9NiMuHQWXRWYx6jr1qQz+DQ2q/U0IIhrScsH4sQQHTgYf1ODAJH/sazV
	V9u4bZO/uC2HUgBlKj9BTRaYvdePtKS7U7fD6NqBAXQyGUi8/ny3TNV+i+UHK7jyhWJT8Z
	Eh4Da9XHPpqaFOE+awQ7+Ce56sOFktI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H8S0gGFn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639AKV4R2210122;
	Thu, 9 Apr 2026 11:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rIMyBL
	9VKU3VOm9TAm9cZevyUsGgECvXVpjQxPXiBno=; b=H8S0gGFnV2e1ge8kS8kcQq
	Qt43vGcU1YFCsRxDLeMM/02AX6ixGc8/FARxK0NY3hoNK4dbNuedJOnAERnT3i1/
	a7w25l2GBR4j97KEE8mKocKiYLNPwv8I7YAQAvg1cZS6t5nriLBJDiRMO8Vt7ZZC
	aAPGh8kLQi3n+A3DWWSlLxPMsCbbfZfQhlkJ+4Q2DI1w0uQeisZyK0IeIuU+gjgn
	FhV/v48fBSJBhKC7Ce2Uk8DyOwN7VklBoyy8ZrR9Lgy6m5RIF9I0174OsK/uqlx6
	EX7vqacWzrBAvD15lk3Gd9PPCK3m1AF0q/r2kWFhhiJHYynA47OcSIgBeRUXCNUQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hkq6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 11:01:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6397uLM4018946;
	Thu, 9 Apr 2026 11:01:23 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9k9uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 11:01:23 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639B1NIK31261336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 11:01:23 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E940958078;
	Thu,  9 Apr 2026 11:01:22 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C31158068;
	Thu,  9 Apr 2026 11:01:15 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 11:01:15 +0000 (GMT)
Message-ID: <85b3ac61-cfb0-46f8-97eb-c83dba02a085@linux.ibm.com>
Date: Thu, 9 Apr 2026 16:31:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/53] selftests/mm: hugetlb-vmemmap: use kselftest
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
 <20260406141735.2179309-9-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-9-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDA5NyBTYWx0ZWRfX2b9BjQ4wVTo/
 WEGRAqqmJxYjHsV9JIl56tJYQW9Jev4Q2f6oGmLzQ5jFtS+2aYQW63pKX85vdh3F4v3d25rCJXo
 zSMHx25KOUmYE2bpdSs9d//4zMXVunYmy56a5UibicGR1jSJR9S3cYr/lsxO5uhoP2CntMSnndr
 jCrLqNnTflGC/MIHfSMupHcYwzPVARBHQH0t4lTMKuLKRrD8Fs5uUvKXP5GTwiDeEPypPjTuX2H
 GGeAlqYzs2XMlhva/U++Xw3HIBJ2SSL2GbPjB+wp+1ONdYYfyyo7kfbaZLBRKrkLV5AlC5T7Hsq
 48oZx7DCf1o8y3QnE7y9nhvtECU+dw3wpZ0MtTAFrbhFOEUnMNgiJwI0QW4W+8Xa9LdzdmZ/i3V
 ZNi6cykiKqqOQkJG2vFLV1f/n7aVxlOvh3zSMvDv2SqrWrB40iz/dDMVTrX/8JMMmLocjw3nGU4
 D00o+zTSzKRqv8vbdTg==
X-Proofpoint-GUID: jRYhCQLN8hKYG8nSPO3I2m3eqY8sTPjN
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d78705 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=7NxCnIlu8LxO6o6IPQsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 69WW6bf3RBaI6LryHGipT278zKZ93G8G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_03,2026-04-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090097
X-Rspamd-Queue-Id: 819781C000A
X-Stat-Signature: b38dz95zipxuzhn4b3dz4z8rb8if7hfx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775732490-840473
X-HE-Meta: U2FsdGVkX192z+co4X2K5eC/xv8P4C9P30zKlNLrZwHdzc6ScM/l2dZizBzFFG61ghyPLLqDDKEG3IQ0N0xoQ0J1FzJV7UYwlmXtyO+dD0Q+yykfpNeeYLiS2sj12V6OA/TXj5W86ky8CnIIRi//YqG5lIk35Uw3fTSvzCQXjVs88pmJSbkxqyNBGsyUujflKC3NVWRaTRpyLWDpLJTEoVuJlhztX6SjWJP0XMB0WZ1l7mCj3V5H93rqfAr1zE7vSQx/4ncb/+JJSUzfFs0d1ME+/FnuG1BDqKgsnHoEHaDH2yQMwWhpU/GsAaS48D/hg2rGwxLCXW45XKn5qmy05o6PvsJbbqAFQrU3X1kZnNFduLwf3jagXB8eoRAqRhsi5ED0mSK/sdkIRjRVHUCZIRcbhJ1EyQNFRXTBmuUFOzZ82qR3VPT4wasqtlfk+8b9ZX8qSry0UDrQ7cqLgv6pqYcSZfIjhz+wVHw6PdXc3Dcv8/4rwS3WqCL36d2SlFvzkzlwqaEyIySXJln6ZaTK6SWMTitlKkFTiJBSRbCeLr/fTkVfYY2ccfN6U4vsFHpGwk6mui9XYLg1SHQH2IsBapflgp8Ps7ZDzeGHon2UZ5yuIu0mEDBL6uXODKcTGFLC3zH+ibG6lhx46AwYGrcCnHfuvbckTzlglnKG3aNCHASQHsnEUHF7zgNj0JAUnI0EcXLDeOQ2AFh3WBFNdudVIOkVCCTQIwWMWZkCpE74bmzBWypmQSeOSpgQVPmVAwA531qyHzk3Ps6rejGtki7SVXgZcsBZ4uHr+E3vWmx6bNdVbrGjnF5rHBmqTQYnvTv/1EtY5uQlNGf1W2ms+k7L5d0SjDG0RFr5DYx8pgl6L+HPICTyp8Aw1vRjAnOuOxKqtEbOq/TR8hrWQBRWH2WlqXKS6pk7T94WwTQArO3L1hGelbVtamU5vnqKpfOxwklyyMH8jUGezMp0b6MIOdB
 lbbsWG6x
 tEcVUo6r44zpCF4rbjUyQXDpwfE0s9bHdbNzi6O9rDFraISr/jc9cLsNUYm40TsNaYCphGNwfM58dFmpa/bqEVjXvD+pDYTMtxi4LRVZwaDk0EKVum9Jhr3EvviSa6815xI40+eu55jvzzfyPy8FOSVJPW/S/QH6mjpfmpj8JwVJoodLhNINiKODIPwFcEgKfGJOto3MvkF2bJDEpOtY9zthb5EwpXw0fj05WHoRaSjAM1iIrYsKsaQ+CgHuJqj6Mc0bOKvPT8gVKVaYajq6k/5oqWi8vH03+9vfawjxKTxT7b3WZwwiKuZqQE1SqYSfpAAnKz1HHHrW7r+UVp9r9cosP+qGnDC591L728HQo4kA8WyUNk6be9egcMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Convert hugetlb-vmemmap test to use kselftest framework for reporting
> and tracking successful and failing runs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/hugetlb-vmemmap.c | 42 +++++++++-----------
>   1 file changed, 18 insertions(+), 24 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> index df366a4d1b92..485a6978b40f 100644
> --- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> @@ -63,7 +63,7 @@ static int check_page_flags(unsigned long pfn)
>   	read(fd, &pageflags, sizeof(pageflags));
>   	if ((pageflags & HEAD_PAGE_FLAGS) != HEAD_PAGE_FLAGS) {
>   		close(fd);
> -		printf("Head page flags (%lx) is invalid\n", pageflags);
> +		ksft_print_msg("Head page flags (%lx) is invalid\n", pageflags);
>   		return -1;
>   	}
>   
> @@ -77,7 +77,7 @@ static int check_page_flags(unsigned long pfn)
>   		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
>   		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
>   			close(fd);
> -			printf("Tail page flags (%lx) is invalid\n", pageflags);
> +			ksft_print_msg("Tail page flags (%lx) is invalid\n", pageflags);
>   			return -1;
>   		}
>   	}
> @@ -91,44 +91,38 @@ int main(int argc, char **argv)
>   {
>   	void *addr;
>   	unsigned long pfn;
> +	int ret;
> +
> +	ksft_print_header();
> +	ksft_set_plan(1);
>   
>   	pagesize  = psize();
>   	maplength = default_huge_page_size();
> -	if (!maplength) {
> -		printf("Unable to determine huge page size\n");
> -		exit(1);
> -	}
> +	if (!maplength)
> +		ksft_exit_skip("Unable to determine huge page size\n");
>   
>   	addr = mmap(NULL, maplength, PROT_READ | PROT_WRITE,
>   			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>   
>   	/* Trigger allocation of HugeTLB page. */
>   	write_bytes(addr, maplength);
>   
>   	pfn = virt_to_pfn(addr);
>   	if (pfn == -1UL) {
> +		ksft_perror("virt_to_pfn");
>   		munmap(addr, maplength);
> -		perror("virt_to_pfn");
> -		exit(1);
> +		ksft_exit_fail();
>   	}
>   
> -	printf("Returned address is %p whose pfn is %lx\n", addr, pfn);
> +	ksft_print_msg("Returned address is %p whose pfn is %lx\n", addr, pfn);
>   
> -	if (check_page_flags(pfn) < 0) {
> -		munmap(addr, maplength);
> -		perror("check_page_flags");
> -		exit(1);
> -	}
> +	ret = check_page_flags(pfn);
>   
> -	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
> -	if (munmap(addr, maplength)) {
> -		perror("munmap");
> -		exit(1);
> -	}
> +	if (munmap(addr, maplength))
> +		ksft_exit_fail_perror("munmap");
>   
> -	return 0;
> +	ksft_test_result(!ret, "HugeTLB vmemmap page flags\n");
> +	ksft_finished();


LGTM


Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet


>   }

