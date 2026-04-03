Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1837E8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 17:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39CBF6B008A; Fri,  3 Apr 2026 13:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CAD6B008C; Fri,  3 Apr 2026 13:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C3E6B0092; Fri,  3 Apr 2026 13:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10C086B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 13:16:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0ADEF1B7A84
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:16:50 +0000 (UTC)
X-FDA: 84617899380.18.08BEF79
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 783481C0007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:16:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NajoZDuk;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775236607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NohWR1irjMQ2u8AmGUhis2y6lSL4Qqs49+8cKnjPScA=;
	b=o4S1wY4NF8Dp8YaaaqL5RwLiwEX+qPmZwMvKfy72FpL7PLexFo2hQcDMcKrdQB1lVVxQON
	/6ay4HOn9iNXcOrSQaK16XJLJybuF8oV5+VrlWftCO59uJgfX7Nu7WvqLmPoab1o4/2Vrw
	bW/Wv7BoII3YkB6tY3WcnXVypOc2Bvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775236607; a=rsa-sha256;
	cv=none;
	b=hUjf/N9Ey9hyzawb0XlUJiFRS+q90seuW5rjo8huLhtbObdebx6PNItfuBllxhQRnYcEUk
	uWvU3R/SFd9fgasT3YCbdAJYOJISeni6zCPv4Udoi0kP/f6/Y7j69DbXOFgn+H3E12fBYi
	3IsTn5hX77mOoh37ifLpIaTpGJzQnG0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NajoZDuk;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632LdVog3113759;
	Fri, 3 Apr 2026 17:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NohWR1
	irjMQ2u8AmGUhis2y6lSL4Qqs49+8cKnjPScA=; b=NajoZDuknduwv9R0SxWu6U
	gwjA+dnvY1Zz9V992Zw6PFGzc8NzaCC88rEWL1H38+eEAUEA/0kiqhj6VF5mgl7Q
	nX8EBKC19uF4YB8FHEBMr9XxjqhHW+wW/U7ykoOtCE8cDk+PZLqLFwx8C3jHIICB
	wgXLDVhD4DoDRdk4j898rG1qs/AxI2HV+YkcggZgDaRRlRXnBglhIWTIkxK2mUFh
	8PrYdtyPEHRgz5TF2i+JeqAS3+a0Em46W5YQMNW28CwjZ48uhRNIs+glH+hr3ymD
	lbvY5CvHs+AEx2gfBW7v7BThTqgXM7JLHouGk611vTt+JIAjwBPdJWXv0VfBkAtQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66np1k6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Apr 2026 17:16:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 633EtSXF022217;
	Fri, 3 Apr 2026 17:16:39 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6taneufy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Apr 2026 17:16:39 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 633HGc6D63308230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Apr 2026 17:16:39 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C0805804B;
	Fri,  3 Apr 2026 17:16:38 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3726358063;
	Fri,  3 Apr 2026 17:16:33 +0000 (GMT)
Received: from [9.124.211.212] (unknown [9.124.211.212])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Apr 2026 17:16:32 +0000 (GMT)
Message-ID: <dd044148-b40f-47f5-a254-ef6f1b86cb0f@linux.ibm.com>
Date: Fri, 3 Apr 2026 22:46:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v3 13/13] selftests/cgroup: extend test_hugetlb_memcg.c to
 support all huge page sizes
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <41fc5be38d4205b5a4aee8499631cf60a9026163.1774591179.git.sayalip@linux.ibm.com>
Content-Language: en-IN
In-Reply-To: <41fc5be38d4205b5a4aee8499631cf60a9026163.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 69vhz5yWDpv4Gm8HrOCAu_WeVf-f2gNK
X-Authority-Analysis: v=2.4 cv=KslAGGWN c=1 sm=1 tr=0 ts=69cff5f9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=kpH4_RMYAZ5BTZvzzSMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDE1MCBTYWx0ZWRfXz4DnOPXlTlXH
 ffm37kttd21y3nY0gDVS8P7Tvb0B+memDYJo2RmLEAyvaHQleMnpGT12s+GiO5Oy9PolWh/FOZ4
 dfdRopDciAZUNfdr+0QF8TNyKe49YN3hH7npCKLFc2+BLn6tKZS7CFH2hxx+Qsg6+BBU3Pv5gQs
 og2RrB4ADgtQzDyxwJc4afTVxJAhKwDcuDmWdUj7E72FF+COS7CPn2g2jfaJ4Y3p8QC7DuTUq2/
 kACnpXDz1pZ5qW498flW8dQnonRKL2aKxu9nAVuTY5NDACikdo4p5++iJjQu5ByKxOUQRPIk04S
 0rOn2tyVCm/7YnDp3PVH0DQTnWal18D0Ra618rrpmnoCtOu1jUUkBj0EJQe09zzbnxVDkltXtBJ
 QNhQH+3q+xQhS0foMgAXDPQUYoxXYnHHdTqkArvGUKIgUCrv4VWCW89NbuTgY+fdIKEtUWf1VDi
 HB6rxgHexuR9G50bKHw==
X-Proofpoint-ORIG-GUID: 7CF89Kh9ryTGIGLER7mfKFvRSvYinXz8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_05,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604030150
X-Rspamd-Queue-Id: 783481C0007
X-Stat-Signature: xfzb8ehrcbksmhmrk84i5ncym96npkn3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775236607-728242
X-HE-Meta: U2FsdGVkX18bcb1pNJgZ37jGv5JOdRufzsJksh4E+1P6KXX4qKXqd9yIQ5BTtUitL1lxBhzczO7v8M0Xs38OHXvDCNR01qF+tRMW/bAJfQEFwL/ADPJBYEZ52Y1ZZZSRdVfDYzNiX9JIJSYWZSubirL4W53Jq0klXGz12uxr1e2Bb6u/lQkyVSwwDjcksboNj38QpPatQgenyCk8XGA/o7dx7MJOtlo1974YS7aq+xGX+cYukUOzAJOjtq4pb3QRIEdRitHPmHfutwJWul10rR/HRnHTC8n/JceadyA/AmiRCndW5GXPlZ/ZnEzMzhnm5SfZmWhHCal1aDdbYDW38WmQWASi72Mbxoc8cHuAn77U/z6Wq8Tlv1891Jqs0fG1+aLNII5RF14RalSja2hFIF1Fg6v+OZ6wBBSgBP5rh7/3fzGQiE0fo8v8+QmHZ75rBHJeoaT5EaxYZexY52ITP/8b3I0udhlwUt+8uHxJXPrka021rsQqZOe4dE6qWELN2hbfbRvQiMagkqSVE6tn9ujQw0y8fojJEgAjoEDwmX+5HUofQN5/7JYQnmB+I4h49+ZNe2sl1sOqpCMUAewzm2gHQ/bvBjp5XERiC55u6Z7RVjyfEcVkH6O01Zi+TWuKy5ImoeOt4n2Z0PfaHbt8wAPlhP161BmoYZ1kZGvTrWOSGUofSdx9ZtU4KF3CUflDXD5sBWn55uuSL4CgsyVxNVtF2rOU5gM9jNiX/wSRYwyFzN1tVX0TAY5esNFhjLFM3qhwMdPxhZG3WPba7bQqz3PU4ur9Pq0uRMmPvanWE5d1Ar+/Kbzcodun9R3lU0Zf/TjEVU9ucr6TdjFndkXtH82NcrTjMPf+dua+f3KNtYmha7W0Yz37AzXnrPmBd7ZMXWWG9i7m5GvC7/vIfQyGLvLsd1JnN9vM9GT4lPbeAVAQ8a2Rw6SoRihNdo0pUeQaAJR5ypVcbGBAVfyAuL1
 MjAxllkN
 toVkZMwsHJYTbTbQwXQAXTgj5HsgcTEuB84Ja4AYoIj1tIgndqwJOEHqVPDmOcPSEZYyQRxghErK4yETGAv4irjZUcBJxxxa+ykg08JpeU6/ArKpRxj2XhPqoIdtcitJO2cPM+ulcw59f9WAWGW2dGL6moumwOJuW0kuGRZ5X7o7qtEftNLJBkj2KinJff0mKWbMw/1V3DTXfgZAqmvxDufiXkjsX5/5Y22zlWpIJ9cdaCl2xxQb+kvgmrTa7iWfayiIP1ozvRdnieOzIG9Bh3MP5XtcAwl//o6AudT2RvrLsXL51+Z67lu60aMKezDxS4J+/yTvUtTHzbQBHxJo9GKyKuEF7CiMnn+tcWQ6gIzbxJSc3Xtl+YLLw1aQ5imFupluB8FbVmw63mDfx0XT5KM+PFRj96LTQYUWcGVM93cpgKxaQxNGmf4Kocw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/03/26 12:46, Sayali Patil wrote:
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
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>   .../selftests/cgroup/test_hugetlb_memcg.c     | 66 ++++++++++++++-----
>   1 file changed, 48 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> index f451aa449be6..a449dbec16a8 100644
> --- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> +++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> @@ -12,10 +12,15 @@
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
> @@ -84,11 +89,11 @@ static unsigned int check_first(char *addr)
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
> @@ -96,26 +101,31 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
>   {
>   	char *test_group = (char *)arg;
>   	void *addr;
> +	long hpage_size = get_hugepage_size() * 1024;
>   	long old_current, expected_current, current;
>   	int ret = EXIT_FAILURE;
> +	size_t length = 4 * hpage_size;
> +	int pagesize, nr_pages;
> +
> +	pagesize = getpagesize();
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
> +	addr = mmap(ADDR, length, PROTECTION, FLAGS, 0, 0);
>   	if (addr == MAP_FAILED) {
>   		ksft_print_msg("fail to mmap.\n");
>   		return EXIT_FAILURE;
>   	}
>   	current = cg_read_long(test_group, "memory.current");
> -	if (current - old_current >= MB(2)) {
> +	if (current - old_current >= hpage_size) {
>   		ksft_print_msg("mmap should not increase hugepage usage.\n");
>   		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
>   		goto out_failed_munmap;
> @@ -124,10 +134,24 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
>   
>   	/* read the first page */
>   	check_first(addr);
> -	expected_current = old_current + MB(2);
> +	nr_pages = hpage_size / pagesize;
> +	expected_current = old_current + hpage_size;
>   	current = cg_read_long(test_group, "memory.current");
> -	if (!values_close(expected_current, current, 5)) {
> -		ksft_print_msg("memory usage should increase by around 2MB.\n");
> +	if (nr_pages < MEMCG_CHARGE_BATCH && current == old_current) {
> +		/*
> +		 * Memory cgroup charging uses per-CPU stocks and batched updates to the
> +		 *  memcg usage counters. For hugetlb allocations, the number of pages
> +		 *  that memcg charges is expressed in base pages (nr_pages), not
> +		 *  in hugepage units. When the charge for an allocation is smaller than
> +		 *  the internal batching threshold  (nr_pages <  MEMCG_CHARGE_BATCH),
> +		 *  it may be fully satisfied from the CPU’s local stock. In such
> +		 *  cases memory.current does not necessarily
> +		 *  increase.
> +		 *  Therefore, Treat a zero delta as valid behaviour here.
> +		 */
> +		ksft_print_msg("no visible memcg charge, allocation consumed from local stock.\n");
> +	} else if (!values_close(expected_current, current, 5)) {
> +		ksft_print_msg("memory usage should increase by ~1 huge page.\n");
>   		ksft_print_msg(
>   			"expected memory: %ld, actual memory: %ld\n",
>   			expected_current, current);
> @@ -135,11 +159,11 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
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
> @@ -147,7 +171,7 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
>   	}
>   
>   	/* unmap the whole range */
> -	munmap(addr, LENGTH);
> +	munmap(addr, length);
>   	current = cg_read_long(test_group, "memory.current");
>   	expected_current = old_current;
>   	if (!values_close(expected_current, current, 5)) {
> @@ -162,13 +186,15 @@ static int hugetlb_test_program(const char *cgroup, void *arg)
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
>   
>   	test_group = cg_name(root, "hugetlb_memcg_test");
> @@ -177,7 +203,7 @@ static int test_hugetlb_memcg(char *root)
>   		goto out;
>   	}
>   
> -	if (cg_write(test_group, "memory.max", "100M")) {
> +	if (cg_write_numeric(test_group, "memory.max", num_pages * hpage_size * 1024)) {
>   		ksft_print_msg("fail to set cgroup memory limit.\n");
>   		goto out;
>   	}
> @@ -200,6 +226,7 @@ int main(int argc, char **argv)
>   {
>   	char root[PATH_MAX];
>   	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
> +	long val;
>   
>   	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
>   	if (has_memory_hugetlb_acc < 0)
> @@ -208,12 +235,15 @@ int main(int argc, char **argv)
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

AI review question:


> > -	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, 0, 0);
> > +	addr = mmap(ADDR, length, PROTECTION, FLAGS, 0, 0);
> >  	if (addr == MAP_FAILED) {
> >  		ksft_print_msg("fail to mmap.\n");
> >  		return EXIT_FAILURE;
> Should the test gracefully handle memory constraints by skipping
> instead of returning EXIT_FAILURE here?
> With the removal of the 2MB skip condition, the test will now run on systems
> with large default huge pages (e.g., 1GB on x86_64). Reserving 20 
> huge pages
> (20GB) and mapping 4 huge pages (4GB) might easily fail due to memory
> exhaustion in typical automated testing environments, causing false 
> test regressions.

I’ll update it in v4 to skip on memory constraints instead of returning 
EXIT_FAILURE.

> > @@ -124,10 +134,24 @@ static int hugetlb_test_program(const char 
> *cgroup, void *arg)
> >
> >  	/* read the first page */
> >  	check_first(addr);
> > -	expected_current = old_current + MB(2);
> > +	nr_pages = hpage_size / pagesize;
> > +	expected_current = old_current + hpage_size;
> >  	current = cg_read_long(test_group, "memory.current");
> > -	if (!values_close(expected_current, current, 5)) {
> > -		ksft_print_msg("memory usage should increase by around 2MB.\n");
> > +	if (nr_pages < MEMCG_CHARGE_BATCH && current == old_current) {
> > +		/*
> > +		 * Memory cgroup charging uses per-CPU stocks and batched 
> updates to the
> > +		 *  memcg usage counters. For hugetlb allocations, the number of 
> pages
> > +		 *  that memcg charges is expressed in base pages (nr_pages), not
> > +		 *  in hugepage units. When the charge for an allocation is 
> smaller than
> > +		 *  the internal batching threshold  (nr_pages < 
> > MEMCG_CHARGE_BATCH),
> > +		 *  it may be fully satisfied from the CPU’s local stock. In such
> > +		 *  cases memory.current does not necessarily
> > +		 *  increase.
> > +		 *  Therefore, Treat a zero delta as valid behaviour here.
> > +		 */
> > +		ksft_print_msg("no visible memcg charge, allocation consumed 
> from local stock.\n");
> > +	} else if (!values_close(expected_current, current, 5)) {
> Does this exception fully account for memcg stock batching when the 
> per-CPU
> stock is empty?
> If the stock lacks sufficient pages, charging the huge page triggers 
> a stock
> refill that charges exactly MEMCG_CHARGE_BATCH (64) base pages from 
> the global
> memcg counter.
> On an architecture with 64KB base pages and 2MB contiguous huge pages,
> nr_pages is 32. Refilling the stock would charge 64 base pages (4MB), 
> which
> increases memory.current by 4MB instead of the expected 2MB. Since
> current != old_current, the test falls through to values_close(), 
> which expects
> a 2MB increase and may fail the test.

Valid point.
The current exception does not fully account for this
scenario when the per-CPU stock is empty and a refill charges
MEMCG_CHARGE_BATCH. This can indeed lead to a larger-than-expected jump
in memory.current and cause the test to fail.
I’ll update the logic in v4 to handle this case more robustly.

> > @@ -177,7 +203,7 @@ static int test_hugetlb_memcg(char *root)
> >  		goto out;
> >  	}
> >
> > -	if (cg_write(test_group, "memory.max", "100M")) {
> > +	if (cg_write_numeric(test_group, "memory.max", num_pages * 
> > hpage_size * 1024)) {
> Can this calculation overflow on 32-bit systems?
> Since long is 32 bits on 32-bit systems, num_pages * hpage_size * 1024 can
> exceed the 32-bit signed integer maximum if the architecture supports large> huge pages (e.g., 256MB on MIPS).This would evaluate to 5,368,709,120,
> resulting in a negative or truncated value, which sets memory.max to an
> invalid or overly restrictive limit.

Yes,  this can overflow on 32-bit systems. I’ll fix it in v4.

