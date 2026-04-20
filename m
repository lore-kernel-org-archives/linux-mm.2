Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 999C3F557F1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 09:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32D46B00DA; Mon, 20 Apr 2026 05:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0ABD6B00DC; Mon, 20 Apr 2026 05:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21246B00DD; Mon, 20 Apr 2026 05:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3CF66B00DA
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:21:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C27E8C887
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:21:10 +0000 (UTC)
X-FDA: 84678390300.07.CC45D71
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD66340006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:21:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tTF+xQJr;
	spf=pass (imf17.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776676867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKIpZn4Z6HNwKgKCXXRXU9z3btcBfrbqvTy4OZCcTRE=;
	b=5YIbqUYoT3aeJ5aXS58SVn5tzXUxp6bd+v0z5GuljNiFOJ1nRUMdj+4dPaTMcj0t6MmIY/
	W7x1XiKPfRk9GDeVwUvQA88DVePTIPOsU69QJ/z/U+IcGdhU1HacwOH2BLWrUA0UoIfP6G
	Z8xLJ2hyxbcnZ/pYnlopZi8h5ue+5SI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tTF+xQJr;
	spf=pass (imf17.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776676868; a=rsa-sha256;
	cv=none;
	b=rfbduYbdFmgHhqD1VW8kiv+O/6kFHuV4GoqTqot3hDyLkFSipCiHnJzwieVYyJ6VAbGvAY
	C6T+cZQSJFNFsdyMOpnWRM4vTS+p65J/1rRyPwStXH5T+YXXTDsLmzfcK3Qn2FR4i/A+C2
	MYcDcOwJI+Has3cXlAEkwIGylIeUXBU=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JMWVXJ3299164;
	Mon, 20 Apr 2026 09:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xKIpZn
	4Z6HNwKgKCXXRXU9z3btcBfrbqvTy4OZCcTRE=; b=tTF+xQJrUkmtCDqV1Io5Qh
	8rRZsnt89J+lZmMHtHBhnN+fdrd7Lq6jA4+wiABxMychQ4BWdWo8X2ccr+P7Eui3
	ExxMkstVyzKV9r+lXUYqF/VeWmhciuWz59girwZvGD1hDRvMjqrgr8sXrzjzeR/K
	P8546QsVjwxnZuZ7NJW1fbhlh6ls9z75WMiCga9uG8DNikVybdDiKHgoyyZmH7EL
	fVbaQN7lIRGaviY7/G0u3hZ7k0k3bRn9fr+NwLzqRJGemobCbJp4ZH+ybcB2VJyS
	a3F7asc4oTDYrKS+iNyfQ0AZqEZfTr/1DJ/v66/GOjMEfRWSXBuHIXWhbZqSXeXw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2j6f36m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:21:00 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63K9KNAe024725;
	Mon, 20 Apr 2026 09:20:59 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmn9jv4mg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:20:59 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63K9KxtP64028954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 09:20:59 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF98758053;
	Mon, 20 Apr 2026 09:20:58 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF5AC58043;
	Mon, 20 Apr 2026 09:20:50 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Apr 2026 09:20:50 +0000 (GMT)
Message-ID: <5e4fa215-224c-43cf-a0e6-0d91e09a4a3b@linux.ibm.com>
Date: Mon, 20 Apr 2026 14:50:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/53] selftests/mm: merge map_hugetlb into
 hugepage-mmap
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
        Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-6-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260418105539.1261536-6-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA4OSBTYWx0ZWRfX82vrr/jEobg2
 oy8lJnaKjHX4QSnAJg5Cj5Mvrwauq+GPRLyPQkbJNtW/zWCFK8Od7qfAT2Llfp4Dvvr0dq3SQXj
 MNssb/XAsBhV7KK4Im8uORiBrjkNe3KFFu4FR5es6mmxfTLpmGeWLZscaevB9E2oyjmmzm+Cgyq
 Tq+v1PB2tYoRkI1wDFXtpSO3ljHl78YqGHG1WZfWVBIHvNBshzOxrffSsdvJ44gkvqqmV/W96e7
 xhhPAhvjYsrVvBmnTy5F9xp5rkfw1c4KIHdXCCa2FGSwWaHi+hr/FmTRMJ53gTtf7nyY5l7xhXi
 IlA12FVVjrO4AzDJOqC3BHqbtj/HmLWBGWhyTNMXs90JwUyZRPHnNqjzJsF9rZymSjA74E1KM/3
 oFr6l+ieSvqB3Ol9ZyfghlYsc/9ODhpcdcdjrl0xgBcvFmdqyYlWXe4GMTkv08Hcaw2UygnYF0J
 3MH06F2VE5wl0g7OifA==
X-Proofpoint-GUID: B9gR-6UoTiw-1r4QBMS6E5QOEa816wFE
X-Authority-Analysis: v=2.4 cv=SOJykuvH c=1 sm=1 tr=0 ts=69e5effd cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=Pb4HPqFOIDni9GD7aDUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: CUgS_hdT9focg2M0BHV4ZbsLsAYwlQps
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 phishscore=0 suspectscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604200089
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD66340006
X-Stat-Signature: uwmncp69pnrujip43g8o63joz9astaj4
X-Rspam-User: 
X-HE-Tag: 1776676867-332940
X-HE-Meta: U2FsdGVkX18Wi9vz/pcufGw/5cNcGfMNgdLs2gbtSbSOdQJTrJy8wx5nzC+uS5hgm+fnGORXZ5fP+tGvjwQMiDaMb876Yahbi2i9KN6IgXNi8LuTOimX8UXmTwH9Qn3QWgmCl5j30hD8xfKXC4tBJZsCfsDKLsDxrJEIXqC1+AfsaO7ebPXUS6MT2RFNE4hIQuX/xDX7m3TUyxr8x/MJfOEaNVYXf0+pDKkqim+cfINlL6QgH+ATs7R8rOW0RlFEVJqkQ2iDnV533uyVQk+UjsMJh0FKsgwD5ZAscSZLLooICMIT6ehTZRUsw2Zsn3X15sFWUl4E1qaqhaSlUJ0mwTpXPjPeTS2+MOJIdMwdz/xh+g07Ugpg0D2Y44qJM3z7Axs1v0t52g2nYQWuUmfHS4qy2VkYHzBqMkeugqW6ccKak3UlFFgx0csi4S7ihk6Iu75BHi7Q0QO9KXAiUaWK/F1QAomX1ojxCynLbzoMpaT8LdDmRhMlQBGCncy5Xw8NK4yzFslgAv3sgq2u0eFJeq8z0GirwwG0WYgp2TkcGTAGChnwN59q6tVlPLumU186NyUyQEgrTlWEzalLoC+Wv9bdOmxi3VuKaewRLO/ldnvFNO6hZmDyrALf3yRpkiVppSms87xGjgc2a2wNLtMcpByY6Md2hbz76xVycK4e1l8MZijJcbbrRMATRw6hc3u+Nm6zRbrnNC/D6coPuo7//Ho11PiqKBMXmfus/EhUrzWo0j+FYXvivuA9wJ/6PdGJe55q0+TNYQc+iqm/1MgFV/Zzbsr86DL07PZ+huY5fo+9PBfHzj8G36OLhXdALMlEWKR5pPhIVhyCScajxOGsah7B3zveuFjZpEGho081fqz15ZIC08L9M8WzfT67Gn0LRRpfK6dFAAmHykH7B/hrzRlWqdRuWZt98W2l+C4iuxkbujjwhM9nf5Cizx2z3Ivv8ocu2g61QrsUEm6ajdj
 j3qACOu7
 3/68DWX0RIKqehMqayPq1YzeSOt5B/5CvU40I6Mr3r/MLzirLzBlguyaAR2QOSFxpcqj4JQh60sxas3tAuZMaV3sFg9w6MpsMfBmzV6NmJT2gMK5jaIUx9rQcWU7Lzd1PlJ7q596AumJmMx4N6xWmuysPclAINNCaaullxLiQsh2bFpZ8M4xKOmjxb8Xc9WKm/1sKBHM8Ldb0qrcRACCXEThUp7HPMakujucVdc7LzfNa2/rA3VBaUOYfzPQdph8MmEWDWBm4Mz3ZQ2TH2+Rv0hrfv2ZoM384L/KHz4yjfn4knfW8glqCe+7+hW61s1+Fyyp4ws9AQV1Y79w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike

On 4/18/26 4:24 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Both tests create a hugettlb mapping, fill it with data and verify the
> data, the only difference is that one uses file-backed memory and another
> one uses anonymous memory.
>
> Merge both tests into a single file.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/Makefile        |   1 -
>   tools/testing/selftests/mm/hugepage-mmap.c | 112 ++++++++++++++++-----
>   tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
>   tools/testing/selftests/mm/run_vmtests.sh  |   1 -
>   4 files changed, 85 insertions(+), 117 deletions(-)
>   delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index cd24596cdd27..cbda989f6b6a 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -70,7 +70,6 @@ TEST_GEN_FILES += hugepage-vmemmap
>   TEST_GEN_FILES += khugepaged
>   TEST_GEN_FILES += madv_populate
>   TEST_GEN_FILES += map_fixed_noreplace
> -TEST_GEN_FILES += map_hugetlb
>   TEST_GEN_FILES += map_populate
>   ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
>   TEST_GEN_FILES += memfd_secret
> diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
> index d543419de040..f4fcc7c45875 100644
> --- a/tools/testing/selftests/mm/hugepage-mmap.c
> +++ b/tools/testing/selftests/mm/hugepage-mmap.c
> @@ -15,6 +15,7 @@
>   #include <unistd.h>
>   #include <sys/mman.h>
>   #include <fcntl.h>
> +#include "vm_util.h"
>   #include "kselftest.h"
>   
>   #define LENGTH (256UL*1024*1024)
> @@ -25,54 +26,111 @@ static void check_bytes(char *addr)
>   	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
>   }
>   
> -static void write_bytes(char *addr)
> +static void write_bytes(char *addr, size_t length)
>   {
>   	unsigned long i;
>   
> -	for (i = 0; i < LENGTH; i++)
> +	for (i = 0; i < length; i++)
>   		*(addr + i) = (char)i;
>   }
>   
> -static int read_bytes(char *addr)
> +static bool verify_bytes(char *addr, size_t length)
>   {
>   	unsigned long i;
>   
>   	check_bytes(addr);
> -	for (i = 0; i < LENGTH; i++)
> -		if (*(addr + i) != (char)i) {
> -			ksft_print_msg("Error: Mismatch at %lu\n", i);
> -			return 1;
> -		}
> -	return 0;
> +	for (i = 0; i < length; i++)
> +		if (*(addr + i) != (char)i)
> +			return false;
> +
> +	return true;
>   }
>   
> -int main(void)
> +static bool test_mmap(size_t length, int mmap_flags, int fd,
> +		      const char *test_name)
>   {
>   	void *addr;
> -	int fd, ret;
>   
> -	ksft_print_header();
> -	ksft_set_plan(1);
> +	addr = mmap(NULL, length, PROTECTION, mmap_flags, fd, 0);
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
> +	ksft_print_msg("Returned address is %p\n", addr);
> +	check_bytes(addr);
> +	write_bytes(addr, length);
> +	if (!verify_bytes(addr, length))
> +		ksft_exit_fail_msg("%s\n", test_name);
> +
> +	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
> +	if (munmap(addr, length))
> +		ksft_exit_fail_perror("munmap");
> +
> +	return true;
> +}
> +
> +static void test_anon_mmap(size_t length, int shift)
> +{
> +	const char *test_name = "hugetlb anonymous mmap";
> +	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
> +	bool passed;
> +
> +	if (shift)
> +		mmap_flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
> +
> +	passed = test_mmap(length, mmap_flags, -1, test_name);
> +	ksft_test_result(passed, "%s\n", test_name);
> +}
> +
> +static void test_file_mmap(size_t length, int shift)
> +{
> +	const char *test_name = "hugetlb file mmap";
> +	int mmap_flags = MAP_SHARED;
> +	bool passed;
> +	int fd;
> +
> +	if (shift)
> +		mmap_flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;

 From what I understand, selecting an alternative huge page size using 
mmap flags is typically used along with MAP_HUGETLB. Since we are not 
using MAP_HUGETLB, would this code still be necessary? please let me 
know if I might be missing something.



>   
> -	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
> +	fd = memfd_create("hugetlb-mmap", MFD_HUGETLB);
>
In my test, the default huge page size is 2MB. I passed a shift value of 
30 (for 1GB huge pages), but the mmap call failed — To support 1GB huge 
page sizes on a system with a 2MB default huge page size, I used 
MFD_HUGETLB | MFD_HUGE_1GB. With this change, file-backed mmap using 1GB 
huge pages started working. Do you think this change would be needed?

-Donet

>   	if (fd < 0)
> -		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
> +		ksft_exit_fail_perror("memfd_create");
> +
> +	passed = test_mmap(length, mmap_flags, fd, test_name);
> +
> +	close(fd);
> +	ksft_test_result(passed, "%s\n", test_name);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	size_t hugepage_size;
> +	size_t length = LENGTH;
> +	int shift = 0;
> +
> +	ksft_print_header();
> +	ksft_set_plan(2);
> +
> +	if (argc > 1)
> +		length = atol(argv[1]) << 20;
> +	if (argc > 2)
> +		shift = atoi(argv[2]);
>   
> -	addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, fd, 0);
> -	if (addr == MAP_FAILED) {
> -		close(fd);
> -		ksft_exit_fail_msg("mmap(): %s\n", strerror(errno));
> +	if (shift) {
> +		hugepage_size = (1 << shift);
> +		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
> +	} else {
> +		hugepage_size = default_huge_page_size();
> +		ksft_print_msg("Default size hugepages (%lu Kb)\n", hugepage_size >> 10);
>   	}
>   
> -	ksft_print_msg("Returned address is %p\n", addr);
> -	check_bytes(addr);
> -	write_bytes(addr);
> -	ret = read_bytes(addr);
> +	/* munmap with fail if the length is not page aligned */
> +	if (hugepage_size > length)
> +		length = hugepage_size;
>   
> -	munmap(addr, LENGTH);
> -	close(fd);
> +	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
>   
> -	ksft_test_result(!ret, "Read same data\n");
> +	test_anon_mmap(length, shift);
> +	test_file_mmap(length, shift);
>   
> -	ksft_exit(!ret);
> +	ksft_finished();
>   }
> diff --git a/tools/testing/selftests/mm/map_hugetlb.c b/tools/testing/selftests/mm/map_hugetlb.c
> deleted file mode 100644
> index aa409107611b..000000000000
> --- a/tools/testing/selftests/mm/map_hugetlb.c
> +++ /dev/null
> @@ -1,88 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Example of using hugepage memory in a user application using the mmap
> - * system call with MAP_HUGETLB flag.  Before running this program make
> - * sure the administrator has allocated enough default sized huge pages
> - * to cover the 256 MB allocation.
> - */
> -#include <stdlib.h>
> -#include <stdio.h>
> -#include <unistd.h>
> -#include <sys/mman.h>
> -#include <fcntl.h>
> -#include "vm_util.h"
> -#include "kselftest.h"
> -
> -#define LENGTH (256UL*1024*1024)
> -#define PROTECTION (PROT_READ | PROT_WRITE)
> -
> -static void check_bytes(char *addr)
> -{
> -	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
> -}
> -
> -static void write_bytes(char *addr, size_t length)
> -{
> -	unsigned long i;
> -
> -	for (i = 0; i < length; i++)
> -		*(addr + i) = (char)i;
> -}
> -
> -static void read_bytes(char *addr, size_t length)
> -{
> -	unsigned long i;
> -
> -	check_bytes(addr);
> -	for (i = 0; i < length; i++)
> -		if (*(addr + i) != (char)i)
> -			ksft_exit_fail_msg("Mismatch at %lu\n", i);
> -
> -	ksft_test_result_pass("Read correct data\n");
> -}
> -
> -int main(int argc, char **argv)
> -{
> -	void *addr;
> -	size_t hugepage_size;
> -	size_t length = LENGTH;
> -	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
> -	int shift = 0;
> -
> -	hugepage_size = default_huge_page_size();
> -	/* munmap with fail if the length is not page aligned */
> -	if (hugepage_size > length)
> -		length = hugepage_size;
> -
> -	ksft_print_header();
> -	ksft_set_plan(1);
> -
> -	if (argc > 1)
> -		length = atol(argv[1]) << 20;
> -	if (argc > 2) {
> -		shift = atoi(argv[2]);
> -		if (shift)
> -			flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
> -	}
> -
> -	if (shift)
> -		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
> -	else
> -		ksft_print_msg("Default size hugepages\n");
> -	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
> -
> -	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
> -	if (addr == MAP_FAILED)
> -		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
> -
> -	ksft_print_msg("Returned address is %p\n", addr);
> -	check_bytes(addr);
> -	write_bytes(addr, length);
> -	read_bytes(addr, length);
> -
> -	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
> -	if (munmap(addr, length))
> -		ksft_exit_fail_msg("munmap: %s\n", strerror(errno));
> -
> -	ksft_finished();
> -}
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index e2dc9ac87bfc..61b450032af8 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -292,7 +292,6 @@ CATEGORY="hugetlb" run_test ./hugepage-shm
>   echo "$shmmax" > /proc/sys/kernel/shmmax
>   echo "$shmall" > /proc/sys/kernel/shmall
>   
> -CATEGORY="hugetlb" run_test ./map_hugetlb
>   CATEGORY="hugetlb" run_test ./hugepage-mremap
>   CATEGORY="hugetlb" run_test ./hugepage-vmemmap
>   CATEGORY="hugetlb" run_test ./hugetlb-madvise

