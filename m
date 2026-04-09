Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D79F31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75FE6B00A2; Thu,  9 Apr 2026 12:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFFF6B00A6; Thu,  9 Apr 2026 12:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79F96B00A7; Thu,  9 Apr 2026 12:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 902A56B00A2
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:06:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FE3A13BC6E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:06:08 +0000 (UTC)
X-FDA: 84639494016.07.08997DB
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id B6D7640012
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:06:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QtfspcZU;
	spf=pass (imf17.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9/cn/pHh2ANtpRfJNmFv3SzGkD5P487Xz3Ht0tGRVo=;
	b=ZsZpVHD9aT4yCHyfE5PruzQbh8ecMkJUFoze9wUd5C5dAqGRyKUvSBfic8fmMSqJ2HKbFc
	Hy90KAHihkn8MCumoULXsgjMrBg++ZiolO1xTGWagzYwuujD571bpyjYuTSqsEyXorOhZy
	gkt+4qo5TtfWomB7Kmwosdnx2uB/NxM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QtfspcZU;
	spf=pass (imf17.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750765; a=rsa-sha256;
	cv=none;
	b=ZosMGjQb/pP5M/4mJIGY9x+MlAz+IQb8e/qXZQYDGLqveMlMhIvMdwsXLHJ62zpGtNAPVw
	yTqCeEeT5MMGfY4FgJZKfMypiZMOGBuBNBTRC5p2nYmPgVrsBj44RNpD6+BiBfxg5AxBeO
	uiANt6CEDf2yDDvRawfttYWDLyTM1m0=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639BUb1B2302702;
	Thu, 9 Apr 2026 16:05:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=v9/cn/pHh2ANtpRfJNmFv3SzGkD5P4
	87Xz3Ht0tGRVo=; b=QtfspcZUSJ7aEpHh1q/H/frF7rae01Y9F0AiPN2KpVib0P
	J6tD3jRxHfQ+iEm+35qKbS2ja9NBRTXAR02msyK8Jwq9Z73+8U60gVuWreQ0h93P
	owqMlMh/DYt+NLUeRBUV+yLgnvXHx3Z3fC7qKKGIW9Bs4ZycN7luuRC9u2YvxuYk
	Aruc4b3rv5lSS+6oZ1YaANqIz+Qh12BwWvJsaW0jM08Nko5qfC8gKaGQWeup9ZJZ
	8Dh7ffjr8LdY6sU4MHlYVhM6u8i/rmYxSAUicgnKq8QoHG7vPIuP6z5uhNlNNsgg
	4svPmLf2klOEVuytEhQ51kqHnsfZHn1AHWfk1lYQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2fnvnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 16:05:57 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 639D2JU7026646;
	Thu, 9 Apr 2026 16:05:56 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg84973-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 16:05:56 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639G5ubj15467064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 16:05:56 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED3F558045;
	Thu,  9 Apr 2026 16:05:55 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BC8C58050;
	Thu,  9 Apr 2026 16:05:42 +0000 (GMT)
Received: from [9.124.214.147] (unknown [9.124.214.147])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 16:05:41 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------w5Re72xlOSDNTL4e3D7I06hK"
Message-ID: <4e364241-aec6-4d28-a878-4fe25f5fcf44@linux.ibm.com>
Date: Thu, 9 Apr 2026 21:35:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/53] selftests/mm: merge map_hugetlb into hugepage-mmap
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
 <20260406141735.2179309-6-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-6-rppt@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE0NSBTYWx0ZWRfX549dMju1kazC
 ft9kO1PLU2dxAUbXkUHmYH3o/Tnka2ZRnVa3hLCxvUkerf0goqlsUJTrOHVUNHeKDI/vYHpjKRm
 H7j4n1+2riDVy+p23nTEXhbB6HHMguTrIFcV24L/Als29Ut+vWH8Z5E7aPfgoRmJhddpcJYXdr9
 9BjtxGF0CNPkg3cAhG+9jdAq1zE6WZYC9aUur/RzG1okA77U6kr6zgIH9QLsLTMqA9xerotLOxr
 PhGP5EQNviNnqGxOUFKKI5u0Wo8qFae3S8btTzmJBNrEk00gAlA/bYuHuouYEwLfFMyNM/tL+fW
 M3V7SwisXjOuv/vLwJafU4W+bmFkd2rHu1tS0BdhyomsQRySv0SwOVdAGWeVG4/Quw/3FAIwfhq
 etIbK5hYuSO11HXRQr8vqP7Eut5d1uQ1a1Ui0PZfZlXp9QWUJbAFxNrLgR7vJa7PoRtIhGeRj70
 grw43ecxdg/PImuS4og==
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=69d7ce66 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VwQbUJbxAAAA:8
 a=Pb4HPqFOIDni9GD7aDUA:9 a=QEXdDO2ut3YA:10 a=1XO0QZMn3ycMq4Qhi_0A:9
 a=iC62NzquHVTkGabO:21 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10 a=3ZKOabzyN94A:10
X-Proofpoint-ORIG-GUID: ctHCE9C6g-e8DrkldsJRY1NxkroCrMd7
X-Proofpoint-GUID: U0MG4QgIUJiae3FOTQNFmwYPXxeGX00L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090145
X-Rspam-User: 
X-Stat-Signature: pisia6fdmoct4cxfgiy7fwei8ychorgf
X-Rspamd-Queue-Id: B6D7640012
X-Rspamd-Server: rspam09
X-HE-Tag: 1775750765-77550
X-HE-Meta: U2FsdGVkX1/TlHslYeihQ/NCOjNOPda9rJXhvwjNP7rXd2sfPhXbjmyywVGN1HKn6iGctwQ7qklt4ptW/xxFKL9o4ElCXKI2uRfjxe2JYYsZMLBH+6jmjOoiJV5aGvbo8ECVSMhiVkavkVj21JNWJYRN9NE2ebPsTYM4GAgqBfpn899fV+QSBTuZXIfI/14OqNzywpwNMoHJuzcPIEknZY9SFFfYLejJLgs8LazYAK6PosumZLmOa5h+eee73VJ62iLVSliN9e1cAXmK3Kf7eXfuzDcrMFE2slbpebkRCCaNXf+N9XDxJ2jdosmUhrps9HaG07DT08hPVt1iL3Vu08agKTcRi6FqhYz/9QIMYFSh+VWt7pVNfubp+qhledIsgxmxFi4vhzWQ1NKTtahDZCGsXJynESUo2lB75oGWu9YW5N+9PVof4/sVz4Er9REV1VoQ7IZMriCY5mZg6rCevp1OtKBW+HLZo7HOL11Kf16rHv7yUAbSqadk4Pb35SGauJ6IWn/vHSzV9nqangO7Q0/p+bLtJ430GSxg0dDF6CTcSv+w5L/QI46j1wDoYvZc0b0MFIX//rO/vT2UNkj25UgxdqQxzLINnmFa55JcHupVgJVFlm23NaijBXMKrNM6kEWrShPdFIkmylncRnRwzQbM7ElqwPLYX9ZYNxEklkgyPu4toHSCzeC7LYZ2rq1aXTeDlmPzgkRRIxCAEAfLU+c/dHEY8q3ue5JoP33Vdd8b444osWT31DrhX2qphJz6Ah69glIMRQbQArBrTN8XqT11ml6lDm7n+SPI6fySFjG40NEjUzUP8TimystRscLSPj58MmPy6XA9+Wj6MkFI95u7AJoZUhParjdzRAvngtSZWXTGDRvl3PATuqw0aCtIosXRfXrfHQ6Pddh/7PsWA7RTNLlYIosRrGa7TkYdhdCMsdv2JipIRBsCyVK5N5asM0dC4jDNQl+b6nsrrl9
 qSmPlXWT
 xVDDWlbFehULDvwUUcGZdWiRtI6YPWoF4XAhMNQF3AfP3STfQeN5xfOwtBGi/dAgxUHGv4ccyM4UBdsByRmfuWzFh3HvFqXMie6hIFGivj1FWZ1Ze7+2/ijV7Cr2DCbuoiZhRqlmzW32QAfHUU75iave1Ly2Mz6Ee2agcL+sZhFwubh8CG4l3TEBuSWEPKG+fZInIfSOWvC+UAzLowBK4O+jy2Vr3qTzmGsZyCAijhL+odOhg02mPYLRvTVIJDGUnrBAZoUUPWtS0ieVYyraG0SLlwPUJlqHHs0ou6KkOsJPUK0pE802gCwyfSXaTFgm0gfMiftQ+wD7NSLSSfSWLO3RxOY0nM8xD0lh0voBL8CMAz/nBX0oC8tg8U2SHiEEkL/zOQK2TBriLNl9UNJ7xBYtVFrpjEVLdmX+KHUwqgOsjdojaCAnNXqgP3EvDUPzfN0FpecqW8zj8juk4xQTBj9f0QsVSNQTO7f1Q7lPzpVLV0m9MpGL2TpdwDZ3PrrNqIA0zExPM0PmCVWiyHfeJP1XihDsW/zqEHR5OUS+4nFYi3vGVDE2iFB1WMT8NV/KHjY5lOkjQJWCt/xs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------w5Re72xlOSDNTL4e3D7I06hK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mike

On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)"<rppt@kernel.org>
>
> Both tests create a hugettlb mapping, fill it with data and verify the
> data, the only difference is that one uses file-backed memory and another
> one uses anonymous memory.
>
> Merge both tests into a single file.
>
> Signed-off-by: Mike Rapoport (Microsoft)<rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/Makefile        |   1 -
>   tools/testing/selftests/mm/hugepage-mmap.c | 113 ++++++++++++++++-----
>   tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
>   tools/testing/selftests/mm/run_vmtests.sh  |   1 -
>   4 files changed, 86 insertions(+), 117 deletions(-)
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
> index d543419de040..de210043045a 100644
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
> @@ -25,54 +26,112 @@ static void check_bytes(char *addr)
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


It looks like |mmap_flags| and |fd| are not used in this function.

> +		      const char *test_name)
>   {
> +	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;


The same flags are being used for both file and anonymous tests . It 
seems that test_file_mmap may be broken.

>   	void *addr;
> -	int fd, ret;
>   
> -	ksft_print_header();
> -	ksft_set_plan(1);
> +	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
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
>   
> -	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
> +	fd = memfd_create("hugetlb-mmap", MFD_HUGETLB);
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
--------------w5Re72xlOSDNTL4e3D7I06hK
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi Mike</font></p>
    <div class="moz-cite-prefix">On 4/6/26 7:46 PM, Mike Rapoport wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-6-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">From: "Mike Rapoport (Microsoft)" <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>

Both tests create a hugettlb mapping, fill it with data and verify the
data, the only difference is that one uses file-backed memory and another
one uses anonymous memory.

Merge both tests into a single file.

Signed-off-by: Mike Rapoport (Microsoft) <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>
---
 tools/testing/selftests/mm/Makefile        |   1 -
 tools/testing/selftests/mm/hugepage-mmap.c | 113 ++++++++++++++++-----
 tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
 tools/testing/selftests/mm/run_vmtests.sh  |   1 -
 4 files changed, 86 insertions(+), 117 deletions(-)
 delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd27..cbda989f6b6a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -70,7 +70,6 @@ TEST_GEN_FILES += hugepage-vmemmap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
-TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
 ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
 TEST_GEN_FILES += memfd_secret
diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
index d543419de040..de210043045a 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugepage-mmap.c
@@ -15,6 +15,7 @@
 #include &lt;unistd.h&gt;
 #include &lt;sys/mman.h&gt;
 #include &lt;fcntl.h&gt;
+#include "vm_util.h"
 #include "kselftest.h"
 
 #define LENGTH (256UL*1024*1024)
@@ -25,54 +26,112 @@ static void check_bytes(char *addr)
 	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
 }
 
-static void write_bytes(char *addr)
+static void write_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
-	for (i = 0; i &lt; LENGTH; i++)
+	for (i = 0; i &lt; length; i++)
 		*(addr + i) = (char)i;
 }
 
-static int read_bytes(char *addr)
+static bool verify_bytes(char *addr, size_t length)
 {
 	unsigned long i;
 
 	check_bytes(addr);
-	for (i = 0; i &lt; LENGTH; i++)
-		if (*(addr + i) != (char)i) {
-			ksft_print_msg("Error: Mismatch at %lu\n", i);
-			return 1;
-		}
-	return 0;
+	for (i = 0; i &lt; length; i++)
+		if (*(addr + i) != (char)i)
+			return false;
+
+	return true;
 }
 
-int main(void)
+static bool test_mmap(size_t length, int mmap_flags, int fd,</pre>
    </blockquote>
    <p><br>
    </p>
    <p><font face="monospace">It looks like <code data-start="70"
          data-end="82">mmap_flags</code> and <code data-start="87"
          data-end="91">fd</code> are not used in this function.</font></p>
    <p><span style="white-space: pre-wrap">
</span></p>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-6-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
+		      const char *test_name)
 {
+	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;</pre>
    </blockquote>
    <p><font face="monospace"><br>
      </font></p>
    <font face="monospace">The same flags are being used for both file 
      and anonymous tests . It seems that test_file_mmap may be broken.</font>
    <p> </p>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-6-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
 	void *addr;
-	int fd, ret;
 
-	ksft_print_header();
-	ksft_set_plan(1);
+	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+
+	ksft_print_msg("Returned address is %p\n", addr);
+	check_bytes(addr);
+	write_bytes(addr, length);
+	if (!verify_bytes(addr, length))
+		ksft_exit_fail_msg("%s\n", test_name);
+
+	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
+	if (munmap(addr, length))
+		ksft_exit_fail_perror("munmap");
+
+	return true;
+}
+
+static void test_anon_mmap(size_t length, int shift)
+{
+	const char *test_name = "hugetlb anonymous mmap";
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
+	bool passed;
+
+	if (shift)
+		mmap_flags |= (shift &amp; MAP_HUGE_MASK) &lt;&lt; MAP_HUGE_SHIFT;
+
+	passed = test_mmap(length, mmap_flags, -1, test_name);
+	ksft_test_result(passed, "%s\n", test_name);
+}
+
+static void test_file_mmap(size_t length, int shift)
+{
+	const char *test_name = "hugetlb file mmap";
+	int mmap_flags = MAP_SHARED;
+	bool passed;
+	int fd;
+
+	if (shift)
+		mmap_flags |= (shift &amp; MAP_HUGE_MASK) &lt;&lt; MAP_HUGE_SHIFT;
 
-	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
+	fd = memfd_create("hugetlb-mmap", MFD_HUGETLB);
 	if (fd &lt; 0)
-		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
+		ksft_exit_fail_perror("memfd_create");
+
+	passed = test_mmap(length, mmap_flags, fd, test_name);
+
+	close(fd);
+	ksft_test_result(passed, "%s\n", test_name);
+}
+
+int main(int argc, char **argv)
+{
+	size_t hugepage_size;
+	size_t length = LENGTH;
+	int shift = 0;
+
+	ksft_print_header();
+	ksft_set_plan(2);
+
+	if (argc &gt; 1)
+		length = atol(argv[1]) &lt;&lt; 20;
+	if (argc &gt; 2)
+		shift = atoi(argv[2]);
 
-	addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED) {
-		close(fd);
-		ksft_exit_fail_msg("mmap(): %s\n", strerror(errno));
+	if (shift) {
+		hugepage_size = (1 &lt;&lt; shift);
+		ksft_print_msg("%u kB hugepages\n", 1 &lt;&lt; (shift - 10));
+	} else {
+		hugepage_size = default_huge_page_size();
+		ksft_print_msg("Default size hugepages (%lu Kb)\n", hugepage_size &gt;&gt; 10);
 	}
 
-	ksft_print_msg("Returned address is %p\n", addr);
-	check_bytes(addr);
-	write_bytes(addr);
-	ret = read_bytes(addr);
+	/* munmap with fail if the length is not page aligned */
+	if (hugepage_size &gt; length)
+		length = hugepage_size;
 
-	munmap(addr, LENGTH);
-	close(fd);
+	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length &gt;&gt; 20);
 
-	ksft_test_result(!ret, "Read same data\n");
+	test_anon_mmap(length, shift);
+	test_file_mmap(length, shift);
 
-	ksft_exit(!ret);
+	ksft_finished();
 }
diff --git a/tools/testing/selftests/mm/map_hugetlb.c b/tools/testing/selftests/mm/map_hugetlb.c
deleted file mode 100644
index aa409107611b..000000000000
--- a/tools/testing/selftests/mm/map_hugetlb.c
+++ /dev/null
@@ -1,88 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Example of using hugepage memory in a user application using the mmap
- * system call with MAP_HUGETLB flag.  Before running this program make
- * sure the administrator has allocated enough default sized huge pages
- * to cover the 256 MB allocation.
- */
-#include &lt;stdlib.h&gt;
-#include &lt;stdio.h&gt;
-#include &lt;unistd.h&gt;
-#include &lt;sys/mman.h&gt;
-#include &lt;fcntl.h&gt;
-#include "vm_util.h"
-#include "kselftest.h"
-
-#define LENGTH (256UL*1024*1024)
-#define PROTECTION (PROT_READ | PROT_WRITE)
-
-static void check_bytes(char *addr)
-{
-	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
-}
-
-static void write_bytes(char *addr, size_t length)
-{
-	unsigned long i;
-
-	for (i = 0; i &lt; length; i++)
-		*(addr + i) = (char)i;
-}
-
-static void read_bytes(char *addr, size_t length)
-{
-	unsigned long i;
-
-	check_bytes(addr);
-	for (i = 0; i &lt; length; i++)
-		if (*(addr + i) != (char)i)
-			ksft_exit_fail_msg("Mismatch at %lu\n", i);
-
-	ksft_test_result_pass("Read correct data\n");
-}
-
-int main(int argc, char **argv)
-{
-	void *addr;
-	size_t hugepage_size;
-	size_t length = LENGTH;
-	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
-	int shift = 0;
-
-	hugepage_size = default_huge_page_size();
-	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size &gt; length)
-		length = hugepage_size;
-
-	ksft_print_header();
-	ksft_set_plan(1);
-
-	if (argc &gt; 1)
-		length = atol(argv[1]) &lt;&lt; 20;
-	if (argc &gt; 2) {
-		shift = atoi(argv[2]);
-		if (shift)
-			flags |= (shift &amp; MAP_HUGE_MASK) &lt;&lt; MAP_HUGE_SHIFT;
-	}
-
-	if (shift)
-		ksft_print_msg("%u kB hugepages\n", 1 &lt;&lt; (shift - 10));
-	else
-		ksft_print_msg("Default size hugepages\n");
-	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length &gt;&gt; 20);
-
-	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-
-	ksft_print_msg("Returned address is %p\n", addr);
-	check_bytes(addr);
-	write_bytes(addr, length);
-	read_bytes(addr, length);
-
-	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, length))
-		ksft_exit_fail_msg("munmap: %s\n", strerror(errno));
-
-	ksft_finished();
-}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index e2dc9ac87bfc..61b450032af8 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -292,7 +292,6 @@ CATEGORY="hugetlb" run_test ./hugepage-shm
 echo "$shmmax" &gt; /proc/sys/kernel/shmmax
 echo "$shmall" &gt; /proc/sys/kernel/shmall
 
-CATEGORY="hugetlb" run_test ./map_hugetlb
 CATEGORY="hugetlb" run_test ./hugepage-mremap
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
</pre>
    </blockquote>
  </body>
</html>

--------------w5Re72xlOSDNTL4e3D7I06hK--


