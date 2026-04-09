Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE18BE98FDE
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F050A6B0005; Thu,  9 Apr 2026 05:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD2A6B0088; Thu,  9 Apr 2026 05:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3496B008A; Thu,  9 Apr 2026 05:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0F4A6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:50:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77930B9C82
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:50:05 +0000 (UTC)
X-FDA: 84638546370.01.0E4FD9C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1E88A40010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:50:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K+vzRBGj;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775728203; a=rsa-sha256;
	cv=none;
	b=eYBRbVynz4UlE77v83nNqj4IS/Opemoycs3wX0ZJFAh64y4I2S02Bz6eQ3x/wrii8QyeRc
	9Z2iboLiV1fFwc9kKzYQvOPoPwmoU8PF5QtTRYxlJy0OzuvgGTiQzVKLJxPY3sm13746kI
	b6vg4OrQC7rYGOKm1AbSRvr/TnSPqsg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K+vzRBGj;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775728203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xy0aFwR9hSVE9FugkDv+q+eeKeSUlXGFf66m16wYZTY=;
	b=MUp9O7kWmqE+R5EsTEl9orOGKUMnGloPLUnniyPzZWTWifVK/1M0axeriX0IC7hyux7Snt
	2VvhgiPkwBknxmNaLvBOy74iEYIbpv35zula4ErcbwG6L08of3wx4nKo96ckXl7CYpp1X1
	LHam6XukxEbju8NKKxBXMTFsj13nLds=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638Iaujj2591197;
	Thu, 9 Apr 2026 09:49:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xy0aFw
	R9hSVE9FugkDv+q+eeKeSUlXGFf66m16wYZTY=; b=K+vzRBGjvv0GAIELRmHXmD
	AG6FzR/3WhCmO8/ju6+uAMrPbP7dUxcnUlxfbOHkx3Ze+dbfNZjTyJ0It2b817uz
	9VtfWlqv8A7rM3Fb5kiH4nREVPRyKUtiPIDfNIr4JUYg0rt7eWWV/n3rZ8uT7IPx
	O8fp/10P7+DsuvOOo9gt0G0c1carPsMhGKwSuxg0PkKQHRH/t4J0esZUSAWDMmb2
	lXND6DRl8SYzsVnf/eeFtBXlo9d4rDKIeV75Jc63J9TDmVBNjZwG1qW4B3yRdDPP
	C+7fNp0x0kxW/2lF2ClH3IDgc+TetEvioJGt2SjaDSVFwuB61COotbwfTpKekMRg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2ecbv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 09:49:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6397qZQh030062;
	Thu, 9 Apr 2026 09:49:55 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcme7k231-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 09:49:55 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6399ns7F21234386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 09:49:54 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 744FB5805B;
	Thu,  9 Apr 2026 09:49:54 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB9D758058;
	Thu,  9 Apr 2026 09:49:46 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 09:49:46 +0000 (GMT)
Message-ID: <eb94ebf2-cc19-4a1b-962a-98346d7b7b6c@linux.ibm.com>
Date: Thu, 9 Apr 2026 15:19:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/53] selftests/mm: hugetlb-shm: use kselftest framework
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
 <20260406141735.2179309-8-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-8-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: xVUArB0X5A1WkQ7OklpwXZUw-uOrUNTA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDA4NyBTYWx0ZWRfX3um++GYn/J4e
 k/DgGJjCM1y8fPjGK7gNbOtHEsHE5jmcxN2buo4El6zG96Exk+rR6WGBFy9t+Io9E/UBql4hU0K
 5SFZTOxnwwSPPerkd8DGIoOToaZTpQOdDo/N7BysKTlrP1hIRfXMyuCOF3kOPL01IOz5FrRKn0o
 hR/j0y4GixOIjounq2lf0a72RH7LlLUix8IZmMCqZ6W+nkV863yeza++96H0o6i1KSf7R21XMnU
 OwY7ubbPDYuuK0v7acedxmCe4kJZBJ9SaWMGG/XY3GlT9IF9WOhr3Tu2FrOv6WyBk9Auknj8gCU
 G46WeboS1YbkgDfK3cqXGtuaQ9IcaboxzHPH6yrgL+74Nd/xVpPPNm+JhDkD5D7ppGSMMqOqHZ9
 du+wCRQ+KGPExKXgTtRoEBhqKQzFTlY4xhtsPMoStsYqkgDGz6k24fxcl53FbvVyWtpew1dOBEr
 XoczcdN8WD70P/Iwmcg==
X-Authority-Analysis: v=2.4 cv=Cfw4Irrl c=1 sm=1 tr=0 ts=69d77645 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=rVzG8BGgQnyHgGzjHBUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: p7hSlYH4aeAOw0kLZuXNyaF_sX3yLzpg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_02,2026-04-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090087
X-Stat-Signature: 8yjhqqnhyi3a1p3cnzmpmez5w1hxi5ba
X-Rspamd-Queue-Id: 1E88A40010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775728202-824327
X-HE-Meta: U2FsdGVkX1/rClGyAFQUb7DiZsSgNg5U5hyuv9ppBKfWdzbQIEubIHvzbGj4mjQ4BPNQNG6KlTPDy0Dsh4k7J1B1FqU5Yl2m+B5Eif2C+9Sdn9bisWuANmCqw1iat3eNO5YvYItP5UqPgaDR4XC59gt1LelnfA4QoORrnfVcW4XMB1RHMe6GXZlIPmk5/qLR9uV/Ep//i2nRSRBLbNAha3dNn683t9vGtJtMZrldbhr3a6cidKcuACcDe6jShcbdORhopMDrPKfvQXlDMYiHyYWtKydkZLPFvAOiYR2prP9t0Nmzn7FHCXopxFccNHVZ2gs4QbSqH6xwxC0bKWUUSX/HfAQgEDOojs+LQViX9hZR/G/DCw18yi1eGEXjCjfF7VJPmg+TBAQjZbmVcUDv+r/Tf5wlz9wGg38pMROxS00wvQSOLujyj+JCw8ZlD56p02H5o96rB4jn0MI8pXQ6QdX9y0C+q+HdL5e9VyoBIJmCmE+RqvEzcJ52OafS5fFqAHFArqZcr30mwthjuSFFrjhZnf9zL4BGnszD7wZ1fBrGCC0ibWYjR1gon1wSXrCfyQXqNaeH6swpK9XlWlw52pTUl814eI22zh8CNaBCFYbjcLpV5D874JdiZ/B041UPLo+PSy+ZWAx2cVMK7m/bby8pbuK7imrN7RwpDnJ69jRGzNPrmo4DDVgVmvExZDlaJ3cdLTCBfcY1t4TZlkWL+yEAXboZH72/MNAxn1eTAoKbDolE1co7stJWJGOkJfSO9+jlpVE7n+UKt4Eco1F7R6YXPNiNYhG/vPguuL6oCv+bZYGd0PsGidus0wcug03xkjkGnY+Dq0iCE2PIx2i4PnUbRqnr78efhxwUQqS0cpZ1SKFjMr0Mbg==
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
> Convert hugetlb-shm test to use kselftest framework for reporting and
> tracking successful and failing runs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/hugetlb-shm.c | 46 ++++++++++++------------
>   1 file changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
> index de8f5d523084..10e4baa091f2 100644
> --- a/tools/testing/selftests/mm/hugetlb-shm.c
> +++ b/tools/testing/selftests/mm/hugetlb-shm.c
> @@ -28,9 +28,9 @@
>   #include <sys/shm.h>
>   #include <sys/mman.h>
>   
> -#define LENGTH (256UL*1024*1024)
> +#include "vm_util.h"
>   
> -#define dprintf(x)  printf(x)
> +#define LENGTH (256UL*1024*1024)
>   
>   int main(void)
>   {
> @@ -38,44 +38,44 @@ int main(void)
>   	unsigned long i;
>   	char *shmaddr;
>   
> +	ksft_print_header();
> +	ksft_set_plan(1);
> +
>   	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
> -	if (shmid < 0) {
> -		perror("shmget");
> -		exit(1);
> -	}
> -	printf("shmid: 0x%x\n", shmid);
> +	if (shmid < 0)
> +		ksft_exit_fail_perror("shmget");
> +
> +	ksft_print_msg("shmid: 0x%x\n", shmid);
>   
>   	shmaddr = shmat(shmid, NULL, 0);
>   	if (shmaddr == (char *)-1) {
> -		perror("Shared memory attach failure");
> +		ksft_perror("Shared memory attach failure");
>   		shmctl(shmid, IPC_RMID, NULL);
> -		exit(2);
> +		ksft_exit_fail();
>   	}
> -	printf("shmaddr: %p\n", shmaddr);
> +	ksft_print_msg("shmaddr: %p\n", shmaddr);
>   
> -	dprintf("Starting the writes:\n");
> -	for (i = 0; i < LENGTH; i++) {
> +	ksft_print_msg("Starting the writes:\n");
> +	for (i = 0; i < LENGTH; i++)
>   		shmaddr[i] = (char)(i);
> -		if (!(i % (1024 * 1024)))
> -			dprintf(".");
> -	}
> -	dprintf("\n");
>   
> -	dprintf("Starting the Check...");
> +	ksft_print_msg("Starting the Check...");


Do we need to add a newline (\n) here? The output is currently printed as:
# Starting the Check...# Done.
If this is intentional, please ignore this comment. Otherwise, it looks 
good to me.



./hugetlb-shm
TAP version 13
1..1
# shmid: 0x1
# shmaddr: 0x7ffface00000
# Starting the writes:
# Starting the Check...# Done.
ok 1 hugepage using SysV shmget/shmat
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet

>   	for (i = 0; i < LENGTH; i++)
>   		if (shmaddr[i] != (char)i) {
> -			printf("\nIndex %lu mismatched\n", i);
> -			exit(3);
> +			ksft_print_msg("Index %lu mismatched\n", i);
> +			shmctl(shmid, IPC_RMID, NULL);
> +			ksft_exit_fail_msg("Data mismatch at index %lu\n", i);
>   		}
> -	dprintf("Done.\n");
> +	ksft_print_msg("Done.\n");
>   
>   	if (shmdt((const void *)shmaddr) != 0) {
> -		perror("Detach failure");
> +		ksft_perror("Detach failure");
>   		shmctl(shmid, IPC_RMID, NULL);
> -		exit(4);
> +		ksft_exit_fail();
>   	}
>   
>   	shmctl(shmid, IPC_RMID, NULL);
>   
> -	return 0;
> +	ksft_test_result_pass("hugepage using SysV shmget/shmat\n");
> +	ksft_finished();
>   }

