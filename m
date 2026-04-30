Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B32FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 09:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2A16B008C; Thu, 30 Apr 2026 05:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073186B0092; Thu, 30 Apr 2026 05:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C3F6B0093; Thu, 30 Apr 2026 05:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D53306B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:34:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81B54A04FF
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:34:04 +0000 (UTC)
X-FDA: 84714710808.24.CDEE5B7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 007AD40004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:34:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SfYhUjEo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777541642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xfjjx5w6Yd5s80ZmirtxSUhg/tG6jXGwL44q6sgHG3o=;
	b=o3/JETx0zBMlKLOyR+nzCkB/cIWLiba5IWd1nwd3Sh9ITq9MD8zLJxz3q4xDgUapGp5PhM
	el3oi+IVyDBrUU/J42DjS9bI+jgYju6F/Ue9Fq1a2ooncXnj5ozeKXQohIN1JwIwZPngjU
	JuOkhMce0IYAf7y4Cd4ZxSG/DPlh3cE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777541642; a=rsa-sha256;
	cv=none;
	b=jkJ/z81IgR2zjMVvd4CPxg/3Hs7zzTVszMjpTU69vC5pAaaBLd6kP/GVC33zefH+r4u8w3
	to+XG5tlUpWDcMEKUAQW9zyTG3yapIiePevQKoZ2PhZSMySbdvoFn1xcfTl7dxOy/0gMhh
	dmOJPd0FeaXXA/EBma1VlLRw5t3PXyQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SfYhUjEo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63TKD6pv3160180;
	Thu, 30 Apr 2026 09:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Xfjjx5
	w6Yd5s80ZmirtxSUhg/tG6jXGwL44q6sgHG3o=; b=SfYhUjEoOWZjKF0SbDSRqK
	4H2g4EJKfLmeV+L34eGUqkpk0vfS4ThnwnNiNXFYpm743LD0OlAqABVqT6ntFAa5
	p1D5IXZdj5NDZo45ahVrxrk4tM+juq7BAksGK65CYPGyUXZT3HO1RcaG4FqgBjmr
	YXOPkpB70STdGKkOm+5azG27UEFVMarvB4Q3mSRGivJ7wHN00kwWO/0wlLR5Steu
	UzxwqT4/NqF1x6M6KOrexYG2oyAoFL3FiI6xytEff+CwCdgzje+6nMBpjDxeLP+2
	r5iIiiaq0VEaS4WqQtZJxoGQ+KWA5mRXH9C1xwHOlbT41Y2VIg4uogzUHm0s5QAg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn44y2uh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Apr 2026 09:33:54 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63U9Noda017008;
	Thu, 30 Apr 2026 09:33:53 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds9ehj756-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Apr 2026 09:33:53 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63U9Xqqt19661340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 09:33:53 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA86A5805A;
	Thu, 30 Apr 2026 09:33:52 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48CC658060;
	Thu, 30 Apr 2026 09:33:40 +0000 (GMT)
Received: from [9.39.19.41] (unknown [9.39.19.41])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Apr 2026 09:33:39 +0000 (GMT)
Message-ID: <ea79d13b-66f2-4a94-ba8b-e3b3bc8e384a@linux.ibm.com>
Date: Thu, 30 Apr 2026 15:03:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/54] selftests/mm: merge map_hugetlb into
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
        Lorenzo Stoakes <ljs@kernel.org>, Luiz Capitulino <luizcap@redhat.com>,
        Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Sarthak Sharma
 <sarthak.sharma@arm.com>,
        Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-7-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260428204240.1924129-7-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: rX7TwUIAX-tzM4LdbzoTQkCt3mUDb5V7
X-Authority-Analysis: v=2.4 cv=Ft81OWrq c=1 sm=1 tr=0 ts=69f32203 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=QibCLqz7JAqtIrobe0sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3jJpP9Y-djHcm38cCXBtjFFnTii2mGve
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA5MiBTYWx0ZWRfXwCYFPpdlPUaS
 nOHrG/Jw3vyxJWvV0TwQMpgAYs7VhEhLvi6dcMFJCJLk4xCyVSj5Y2/EG8krrKSFLx0GimiQpPa
 Acq118z5rkHQrtaSqyhtkXGEswdKx8PtNEQXdlrQtssREQQN8umh4OM/oc0k8DtjLFYPF4AMKQR
 BpUsaRg2qjBlGqrjhD2hUXMZiVdeN1zv4IUaDm+AipuF+7duT5M0/kdWiDb4WWahvN1jk54Zqyu
 PdEVrOka9f5e82uI8MSonLCMY1VAv+eJ6IA/7xsppsXRh3AAp7pi7jADopFPBY0OAQNSud/nYOi
 xMtjnNz4RI6REJ1YrsDlnZzZyqcC0Xi32S3A8q/5elIuLztC9+VR3tIaFzRAOBVn3kFgFBHGDd0
 OLS+Qmf8FB8zhZ+P658BAjk7SizbbB36CBlnFOsf7exgcZSd236rDGRQoHla9gzL9tMHVcdu+Xd
 TRiNO6f6bAWmX+AaQfQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_02,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0
 clxscore=1011 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300092
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 007AD40004
X-Stat-Signature: dkya1h3ow7xe8rh6docyupuy18iducq7
X-Rspam-User: 
X-HE-Tag: 1777541641-443074
X-HE-Meta: U2FsdGVkX1/Qy22gWMcir3+b2/5fvWw/2PsmY68O8jbEQMCKesPrBnDc2NluamieGxPFtxJa0EK1MVeCuwoLSt3USZ4K+9CojVSaUhcVp4gUIyOZEpBB+p4KRWQQAXYGUuX0DuaA6arU6CViYtRGRBGTRRGgBzSXuztWFUM05ujQNq0n5Cokd7jk+kVKzkUfQDfJlruWJ50chbaNMV3240C/jFaMvpBlp+zx7l71AUVOhUGyykxCjuE8wUQZg9z/W/vDc9YLDwqNUxsxnumwqzcAyC9AJAB2nxNHKwcJqxiYQvfxMe500patksosSengm4xVWiB9R7DOV7+kaba8YHVGZbxKwUdi3hT5raAnYiVpnRGtxdpqucjYsvFnO2px/yUyntIQyhS42Q5jfDscvUoxpkaRGkNT6hjrWEPwIhsBtsBJTKkUuRaM0PDgB/IUyNa5b+jua6WyA0eeRyY8Rjq0kIyhN8viKgAadpBgnfPb16BTqL/xXUPnsEbpYiwLBM6vFvQb+UUQrubA3j+e+XQ+3mRS/tMIc+lG1ozA4GhbKkXrJ2yCtxcTB6kwFKfTV6GuHs4hD7VErSxm6mfTRXFbYMSGB7KS5iVTJmaXW/oDyuc4g/K81Nrq2KqGCeLv2A1QgEuSJWMvoBwp7cNOJUHx7nf6AZMkxtTQ7cfyvdh0sNrjkn9391KdRpiipqoEabsggBm7Rv8iRbSIsevYsnEocQMBYesL2ZVwbpXJbh0iemkHNtWN9bmkccua94343k850dOYOZHlYw8+pNOF97CaBFTv4WyzuPgPir40dVAwCn27nJEb/Jeu0UUBJAPNT/iO66B0SfFrt2ZlmyJxrSg2jrlwD6jQX2vEX1Taj7xGFg6TOSYjaSbEyFPDmo71FOe5O+v138rhKn388av1CTX3jqVoxwvmSRSum6MVWtnBedNFQF4v8Wq0w9KZTT7mfLZLqQQAMoTjICCM5Xm
 bKN+IprO
 Iz/EATAnWDbotXCBqxCFnYnpovF9S9shCl5RJmCKrli+MZ7WQsUyUJuFUjliHqv6tra5WgN7eEALWemDGhCOoLJKv6ihTqCJyFyVHW2CtpVA95VIMPCzCTAGYAWyqne0kBc7wBdUlpdaARUiQSoG302rw0W045Gw+qzN1eeZpQG22Kw04dCilkCmyqL8rBs6X/bbM7HPn9VP6VKM65XlZ2p1d0dQXst3sOYtTIYyau2i+VA1qM9zURwIF1ZeGYYcU+kOkc+V1RgsN8CyajHcWZwV0PBFGgNtiM4GlMmhGe0lMOkeOgCOMfAgruiO4nHKYHOxc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike

On 4/29/26 2:11 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Both tests create a hugettlb mapping, fill it with data and verify the
> data, the only difference is that one uses file-backed memory and another
> one uses anonymous memory.
>
> Merge both tests into a single file.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

[]# ./hugetlb-mmap 1024 21
TAP version 13
# [INFO] detected hugetlb page size: 2048 KiB
# [INFO] detected hugetlb page size: 1048576 KiB
# 2048 kB hugepages
1..2
# Mapping 1024 Mbytes
# Returned address is 0x7fff5fa00000
# First hex is 0
# First hex is 3020100
ok 1 hugetlb anonymous mmap
# Returned address is 0x7fff5fa00000
# First hex is 0
# First hex is 3020100
ok 2 hugetlb file mmap
# Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0

[]# ./hugetlb-mmap 1024 30
TAP version 13
# [INFO] detected hugetlb page size: 2048 KiB
# [INFO] detected hugetlb page size: 1048576 KiB
# 1048576 kB hugepages
1..2
# Mapping 1024 Mbytes
# Returned address is 0x7fff40000000
# First hex is 0
# First hex is 3020100
ok 1 hugetlb anonymous mmap
# Returned address is 0x7fff40000000
# First hex is 0
# First hex is 3020100
ok 2 hugetlb file mmap
# Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0
[]#


looks good to me.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>


> ---
>   tools/testing/selftests/mm/Makefile        |   1 -
>   tools/testing/selftests/mm/hugepage-mmap.c | 111 ++++++++++++++++-----
>   tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
>   tools/testing/selftests/mm/run_vmtests.sh  |   1 -
>   4 files changed, 86 insertions(+), 115 deletions(-)
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
> index d543419de040..fa886ec148c2 100644
> --- a/tools/testing/selftests/mm/hugepage-mmap.c
> +++ b/tools/testing/selftests/mm/hugepage-mmap.c
> @@ -15,6 +15,8 @@
>   #include <unistd.h>
>   #include <sys/mman.h>
>   #include <fcntl.h>
> +#include <linux/memfd.h>
> +#include "vm_util.h"
>   #include "kselftest.h"
>   
>   #define LENGTH (256UL*1024*1024)
> @@ -25,54 +27,113 @@ static void check_bytes(char *addr)
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
> +	for (i = 0; i < length; i++)
>   		if (*(addr + i) != (char)i) {
> -			ksft_print_msg("Error: Mismatch at %lu\n", i);
> -			return 1;
> +			ksft_print_msg("Error: Mismatch at %lu(%p)\n", i, addr);
> +			return false;
>   		}
> -	return 0;
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
> +	int mfd_flags = MFD_HUGETLB;
> +	bool passed;
> +	int fd;
> +
> +	if (shift)
> +		mfd_flags |= (shift & MFD_HUGE_MASK) << MFD_HUGE_SHIFT;
>   
> -	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
> +	fd = memfd_create("hugetlb-mmap", mfd_flags);
>   	if (fd < 0)
> -		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
> +		ksft_exit_fail_perror("memfd_create");
> +
> +	passed = test_mmap(length, MAP_SHARED, fd, test_name);
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

