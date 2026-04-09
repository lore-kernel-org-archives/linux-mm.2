Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C659F364A4
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A99A6B0005; Thu,  9 Apr 2026 12:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8807A6B0088; Thu,  9 Apr 2026 12:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7966A6B008A; Thu,  9 Apr 2026 12:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6586B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:56:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EADB55B7FD
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:56:22 +0000 (UTC)
X-FDA: 84639620604.17.78A9346
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 59FBC1C0002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:56:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=X+Rhl1rh;
	spf=pass (imf18.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775753780; a=rsa-sha256;
	cv=none;
	b=Z5/GUc+xobZSKcMXfMyuSYpOTpKw0cDcVMNWl8D6kUz2WTirZJS9ao6I/vAAkQKRDkSpqn
	UzCCg8ZWmcMfXCSCx0TbsmufKSg7Q1fO4EY858UzRF8Mk40+UlrsdyNzIn/G3WcPs9Kwds
	V186TiLD8p7O3jQX/3Ht3akzos2CMq4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775753780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvEphWIYTmaOsYyig1o+y2ujYF+NlxWZBxa7RIBpdl8=;
	b=oVWQtzKlCe1Tgk8GkfgUVL/kwckOv2ZbvmwIy9o+njlvUZvqw4bQirCkNyj1ULoEw41G7Q
	YkYMzRo4x/SkqnSu+LsheZWYwfZan5vtHQ09pSGV9kmUpRj636HuMho25/qk4hchfJaY+2
	DOhhCt0joTrGnmWBB5wuvuZcG3+d5zI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=X+Rhl1rh;
	spf=pass (imf18.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639AQUN22591197;
	Thu, 9 Apr 2026 16:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OvEphW
	IYTmaOsYyig1o+y2ujYF+NlxWZBxa7RIBpdl8=; b=X+Rhl1rhew7vjbQi7Z3+4l
	zp+a07MMUvkzo7YSTcKaXg/mPMac9hhC/f+Mu5W2oKUrjaw2CxJC56wlBgVF2iLn
	4bX5D4n274K0rvujuv6VBeJCVtgpsvsyOU6+jHyvM8p9HCC1dHb/DBZXh09owYi3
	HfSHDncYO1muOz/bH/rxE5BDox+RknMp1CwV9PJk24M5d1ULsfEsBRuw3YfJW9YI
	5/7sPXLF6ZuFNf+drAuyxvgU+/Uv3OBykAneDPGvHYrU6FLZVTIlSTtRa8yuP1b9
	thxIc7HJHqH/xZxnZHISs/29AGfEHP6mWVcSldzi3zIHB9xKyQ0jIa3OR3Mi2MPg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2ee4fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 16:56:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 639CmkE6019008;
	Thu, 9 Apr 2026 16:56:11 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9mfw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 16:56:11 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639GuBK930343700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 16:56:11 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0395C58045;
	Thu,  9 Apr 2026 16:56:11 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F7355805E;
	Thu,  9 Apr 2026 16:56:01 +0000 (GMT)
Received: from [9.124.214.147] (unknown [9.124.214.147])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 16:56:01 +0000 (GMT)
Message-ID: <22e3db13-1e6f-43ec-9682-6eda7fb7ed97@linux.ibm.com>
Date: Thu, 9 Apr 2026 22:25:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/53] selftests/mm: hugetlb-madvise: use kselftest
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
 <20260406141735.2179309-10-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-10-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: nXHmBfUFBa74AbhTU3U9NXvQFKC9UN5g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE1NCBTYWx0ZWRfX9Mgs1UO44P1l
 kLxrr7b5KWP/kHm3rsN75OEtbeK2jerdQlf67QqWwhEDj7D2zrsUmdVT28GTVUMMmF76sjhWF33
 3AjtreOUJrSdZ6ZNIFHZXNpONA3sPP269dov/fc4Ogs3stpJ5PuWGb7IWPV3hE19Bx+p2R1kNUz
 D7+DzNzUEBgpuKKc0a3ga3EF+xw/ZAOUIktHapWqBreaVCD3gbE5tDGwpBcqQmfty/VtjZDxGgN
 TwpoZHoDOxUIYhoPAJeHkelaw7wYMlLZ9NPcv5WaYcwLYYJqG6860h8bECPVrX/UGmkUrUUAs1m
 I0mHBh2F5LakJcf21PQWP4M7OuCo+6TC30QBhyj2hHlvHSAnS3bPGGKnsPi9Ck8ADk2Q9qZD+7d
 hEGZpJtBGc795o+uMMoVBTxf+x2L5KcHTotVBNBHaIFItOA26BMIHQsl6/NjyXrG/89wZD48zRI
 gSx33N0/+rqf8E2ID5Q==
X-Authority-Analysis: v=2.4 cv=Cfw4Irrl c=1 sm=1 tr=0 ts=69d7da2d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=DTDaNkLqmGNR2mV1pvMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: TNOrP0JNv1SJ8pTC8LEKA6-H--cbC-cn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090154
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59FBC1C0002
X-Stat-Signature: 4wx9kfnjpcrucfrz6gqgkdpoow813bsd
X-HE-Tag: 1775753780-157390
X-HE-Meta: U2FsdGVkX18uKYOpkwahm1WbngHAfWb5zpwqwqNmuvSy5Y6eSwly5JKRuyahMdHyQ2noqiYMkKgzh9cm9wy4B0yJ8b3rtEIMY5vmvoOFr72WK/b/4f9VOT2o/TMNmWpk3fMb/ZAT3rJ6AoscHTspyIJNKbFVDGyrXePaC8y/IFblRvbjLsNTd2hqDeCXYUoyVCkEo20v0igyhDFAp3IPoCpF7dY3/5JAH8knCxCuHT8kjBtrj3rTBdWp5aZFJ396oR14UNdAywAK6sKwpw6fwWLvE3+AX5vmlW45eg6seZfWxUiIDxkSNbJO7l+oHBzZwA1v1wpwaehgsRHDKif3cMw2/6Sz/nZ8A4pK79HkAepOfMWXNBxbWmDJLTrmr5ofSrIN/AUfX4VE2QBj9u8zL4av/50etKObvVu4ci4dIS3y1672AUWrALFsJKTU8OI76mxS1IyOsMt6kZvXNzQkfHGLV64cXxY+z7O5AU/99M4qvy5yLiJtOtDLdWgV/IpiWRn7Y/7B/hy/ljsUlXhmMn84rcdjtxFrAQNPJwI5gVoKrY3w3asz9h5600mmq8nUaXOYVJgEPaXpSmONxz1nhg0EN3RM4sAtI5GDuX2nM94T++0QfhMc78Zk9UH+O9MiKmSWvpfwIkYDJuuVkkYQF6B+DxXBbkUDfFvw/D99ysfjpQCA6K/u60FRe5JiDjxgIemrYa49b/Z1svRmjuw7t3JX8tc1bfnbye7FlQ30hRE5g0gwyrtu+lUOrrVsktTfPfgEr9DpL0rdvxOjpj2Y1tOybVRZ+C9mjCr326W7SIlPfbU0+YjwI+/EgXwCyAtH8sjiPHTp9QM7eumiAxsFdtM/3ecPoatsP40WcgzVjlO1DCVP85y7W7qh0Cl2G2HbNJKAARkkds5h8+tx3NZz7vRmct2CU+D0gHpTUMpVPAX73gAhxap8l3pyOu+toL5W49g6IhGP0N5FUT8rs9C
 8H4jVJm4
 CZ7Ldb9S38FyL+hGVksPIouNwsD9cvpyXzeYKPBi5J4fxYLABHqF+tKA3hJRReu0MbUKdHTuxzRpULp+4n2wtoi1lhRT3d5/wI8MYNUZQLiQxR4vdRgthzbzWyRe+gh6Sw1qyeBDqDpgDawJnhkO2TwrzwGZSIYj7ftgMcwVBsdSKxwa8DoUro9+4Pt+7e56gOBuBdcfN4RLu7KRNw2uqXyxLaqVmYqpir+rosMNJ/uZOncxghwe17TgpUzmLqS7DrE5iBH7A/sqQgNObfI3a1jH8zq++ivktJL7mRs9DRkqoHgp+BYLInD12BCR0CPqFTS+4tpMGJ2kdluAR4EnBGYk3WCpfQoQtBzD1TFENue2cv/Xn7hcwhT9hew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Convert hugetlb-madvise test to use kselftest framework for reporting
> and tracking successful and failing runs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/hugetlb-madvise.c | 204 ++++++++-----------
>   1 file changed, 82 insertions(+), 122 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 898cc90b314f..4c6c346a3af5 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -26,12 +26,11 @@
>   
>   #define validate_free_pages(exp_free)					\
>   	do {								\
> -		int fhp = get_free_hugepages();				\
> -		if (fhp != (exp_free)) {				\
> -			printf("Unexpected number of free huge "	\
> -				"pages line %d\n", __LINE__);		\
> -			exit(1);					\
> -		}							\
> +		unsigned long fhp = get_free_hugepages();		\
> +		if (fhp != (exp_free))					\
> +			ksft_exit_fail_msg("Unexpected number of free "	\
> +				"huge pages %ld, expected %ld line %d\n", \
> +				fhp, (exp_free), __LINE__);		\
>   	} while (0)
>   
>   unsigned long huge_page_size;
> @@ -57,28 +56,24 @@ int main(int argc, char **argv)
>   	int fd;
>   	int ret;
>   
> +	ksft_print_header();
> +	ksft_set_plan(1);
> +
>   	huge_page_size = default_huge_page_size();
> -	if (!huge_page_size) {
> -		printf("Unable to determine huge page size, exiting!\n");
> -		exit(1);
> -	}
> +	if (!huge_page_size)
> +		ksft_exit_skip("Unable to determine huge page size\n");
> +
>   	base_page_size = sysconf(_SC_PAGE_SIZE);
> -	if (!huge_page_size) {
> -		printf("Unable to determine base page size, exiting!\n");
> -		exit(1);
> -	}
> +	if (!base_page_size)
> +		ksft_exit_fail_msg("Unable to determine base page size\n");
>   
>   	free_hugepages = get_free_hugepages();
> -	if (free_hugepages < MIN_FREE_PAGES) {
> -		printf("Not enough free huge pages to test, exiting!\n");
> -		exit(KSFT_SKIP);
> -	}
> +	if (free_hugepages < MIN_FREE_PAGES)
> +		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
>   
>   	fd = memfd_create(argv[0], MFD_HUGETLB);
> -	if (fd < 0) {
> -		perror("memfd_create() failed");
> -		exit(1);
> -	}
> +	if (fd < 0)
> +		ksft_exit_fail_perror("memfd_create");
>   
>   	/*
>   	 * Test validity of MADV_DONTNEED addr and length arguments.  mmap
> @@ -90,16 +85,13 @@ int main(int argc, char **argv)
>   			PROT_READ | PROT_WRITE,
>   			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
>   			-1, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
>   	if (munmap(addr, huge_page_size) ||
>   			munmap(addr + (NR_HUGE_PAGES + 1) * huge_page_size,
> -				huge_page_size)) {
> -		perror("munmap");
> -		exit(1);
> -	}
> +				huge_page_size))
> +		ksft_exit_fail_perror("munmap");
>   	addr = addr + huge_page_size;
>   
>   	write_fault_pages(addr, NR_HUGE_PAGES);
> @@ -108,20 +100,14 @@ int main(int argc, char **argv)
>   	/* addr before mapping should fail */
>   	ret = madvise(addr - base_page_size, NR_HUGE_PAGES * huge_page_size,
>   		MADV_DONTNEED);
> -	if (!ret) {
> -		printf("Unexpected success of madvise call with invalid addr line %d\n",
> -				__LINE__);
> -			exit(1);
> -	}
> +	if (!ret)
> +		ksft_exit_fail_msg("madvise with invalid addr unexpectedly succeeded line %d\n", __LINE__);
>   
>   	/* addr + length after mapping should fail */
>   	ret = madvise(addr, (NR_HUGE_PAGES * huge_page_size) + base_page_size,
>   		MADV_DONTNEED);
> -	if (!ret) {
> -		printf("Unexpected success of madvise call with invalid length line %d\n",
> -				__LINE__);
> -			exit(1);
> -	}
> +	if (!ret)
> +		ksft_exit_fail_msg("madvise with invalid length unexpectedly succeeded line %d\n", __LINE__);
>   
>   	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
>   
> @@ -132,10 +118,9 @@ int main(int argc, char **argv)
>   			PROT_READ | PROT_WRITE,
>   			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
>   			-1, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
>   	write_fault_pages(addr, NR_HUGE_PAGES);
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
> @@ -143,19 +128,14 @@ int main(int argc, char **argv)
>   	ret = madvise(addr + base_page_size,
>   			NR_HUGE_PAGES * huge_page_size - base_page_size,
>   			MADV_DONTNEED);
> -	if (!ret) {
> -		printf("Unexpected success of madvise call with unaligned start address %d\n",
> -				__LINE__);
> -			exit(1);
> -	}
> +	if (!ret)
> +		ksft_exit_fail_msg("madvise with unaligned start unexpectedly succeeded line %d\n", __LINE__);
>   
>   	/* addr + length should be aligned down to huge page size */
>   	if (madvise(addr,
>   			((NR_HUGE_PAGES - 1) * huge_page_size) + base_page_size,
> -			MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +			MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
>   
>   	/* should free all but last page in mapping */
>   	validate_free_pages(free_hugepages - 1);
> @@ -170,17 +150,14 @@ int main(int argc, char **argv)
>   			PROT_READ | PROT_WRITE,
>   			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
>   			-1, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
>   	write_fault_pages(addr, NR_HUGE_PAGES);
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
>   
>   	/* should free all pages in mapping */
>   	validate_free_pages(free_hugepages);
> @@ -190,29 +167,25 @@ int main(int argc, char **argv)
>   	/*
>   	 * Test MADV_DONTNEED on private mapping of hugetlb file
>   	 */
> -	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
> -		perror("fallocate");
> -		exit(1);
> -	}
> +	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
> +		ksft_exit_fail_perror("fallocate");
> +
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
>   			PROT_READ | PROT_WRITE,
>   			MAP_PRIVATE, fd, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>   
>   	/* read should not consume any pages */
>   	read_fault_pages(addr, NR_HUGE_PAGES);
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	/* madvise should not free any pages */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	/* writes should allocate private pages */
> @@ -220,10 +193,9 @@ int main(int argc, char **argv)
>   	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
>   
>   	/* madvise should free private pages */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	/* writes should allocate private pages */
> @@ -238,10 +210,9 @@ int main(int argc, char **argv)
>   	 * implementation.
>   	 */
>   	if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> -					0, NR_HUGE_PAGES * huge_page_size)) {
> -		perror("fallocate");
> -		exit(1);
> -	}
> +					0, NR_HUGE_PAGES * huge_page_size))
> +		ksft_exit_fail_perror("fallocate");
> +
>   	validate_free_pages(free_hugepages);
>   
>   	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
> @@ -249,29 +220,25 @@ int main(int argc, char **argv)
>   	/*
>   	 * Test MADV_DONTNEED on shared mapping of hugetlb file
>   	 */
> -	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
> -		perror("fallocate");
> -		exit(1);
> -	}
> +	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
> +		ksft_exit_fail_perror("fallocate");
> +
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
>   			PROT_READ | PROT_WRITE,
>   			MAP_SHARED, fd, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>   
>   	/* write should not consume any pages */
>   	write_fault_pages(addr, NR_HUGE_PAGES);
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	/* madvise should not free any pages */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	/*
> @@ -279,29 +246,25 @@ int main(int argc, char **argv)
>   	 *
>   	 * madvise is same as hole punch and should free all pages.
>   	 */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE))
> +		ksft_exit_fail_perror("madvise");
> +
>   	validate_free_pages(free_hugepages);
>   	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
>   
>   	/*
>   	 * Test MADV_REMOVE on shared and private mapping of hugetlb file
>   	 */
> -	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
> -		perror("fallocate");
> -		exit(1);
> -	}
> +	if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size))
> +		ksft_exit_fail_perror("fallocate");
> +
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	addr = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
>   			PROT_READ | PROT_WRITE,
>   			MAP_SHARED, fd, 0);
> -	if (addr == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>   
>   	/* shared write should not consume any additional pages */
>   	write_fault_pages(addr, NR_HUGE_PAGES);
> @@ -310,10 +273,8 @@ int main(int argc, char **argv)
>   	addr2 = mmap(NULL, NR_HUGE_PAGES * huge_page_size,
>   			PROT_READ | PROT_WRITE,
>   			MAP_PRIVATE, fd, 0);
> -	if (addr2 == MAP_FAILED) {
> -		perror("mmap");
> -		exit(1);
> -	}
> +	if (addr2 == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
>   
>   	/* private read should not consume any pages */
>   	read_fault_pages(addr2, NR_HUGE_PAGES);
> @@ -324,17 +285,15 @@ int main(int argc, char **argv)
>   	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
>   
>   	/* madvise of shared mapping should not free any pages */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>   	validate_free_pages(free_hugepages - (2 * NR_HUGE_PAGES));
>   
>   	/* madvise of private mapping should free private pages */
> -	if (madvise(addr2, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr2, NR_HUGE_PAGES * huge_page_size, MADV_DONTNEED))
> +		ksft_exit_fail_perror("madvise");
> +
>   	validate_free_pages(free_hugepages - NR_HUGE_PAGES);
>   
>   	/* private write should consume additional pages again */
> @@ -346,15 +305,16 @@ int main(int argc, char **argv)
>   	 * not correct.  private pages should not be freed, but this is
>   	 * expected.  See comment associated with FALLOC_FL_PUNCH_HOLE call.
>   	 */
> -	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE)) {
> -		perror("madvise");
> -		exit(1);
> -	}
> +	if (madvise(addr, NR_HUGE_PAGES * huge_page_size, MADV_REMOVE))
> +		ksft_exit_fail_perror("madvise");
> +
>   	validate_free_pages(free_hugepages);
>   
>   	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
>   	(void)munmap(addr2, NR_HUGE_PAGES * huge_page_size);
>   
>   	close(fd);
> -	return 0;
> +
> +	ksft_test_result_pass("MADV_DONTNEED and MADV_REMOVE on hugetlb\n");
> +	ksft_finished();
>   }
LGTM


Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet

