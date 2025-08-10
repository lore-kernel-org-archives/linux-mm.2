Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8D0C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 16:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D008E0001; Sun, 10 Aug 2025 12:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F149D6B00C0; Sun, 10 Aug 2025 12:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03D28E0001; Sun, 10 Aug 2025 12:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDFB66B00BF
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:53:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8038BBA13E
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:53:46 +0000 (UTC)
X-FDA: 83761444452.13.5CD6B6D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28136180006
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:53:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="n06X/Jfp";
	spf=pass (imf06.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754844824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZaYkxdq57TzHEZWXDL3LSQ0gLrm6LZX0vgoYqN25PU=;
	b=zJm9JjBnrOGyjzMopC5voVd+BktbnXRQB8xkaP5rcpoZenT5ydRvlPrmB1hnMJiAJkW9Ll
	STj6LhGgA1SEor1LADff6YbwEaCXjmJ8SejC6SSdbiF6mqyOTM6F9LfqbVZfKtlBGXyfRl
	QjMFvrno1J8eL3tIyvlGQ70loChYFQw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="n06X/Jfp";
	spf=pass (imf06.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754844824; a=rsa-sha256;
	cv=none;
	b=LM5VmejeveucXFneBlkRD2d72hLFwecy+jjxmBdjARfwXC9lu/lwy4shT9Koo8Sy6kWWXK
	yVbdgwHbVRpUELjYo+1TqiGWlHGIS+nccrCVwHIqL9QGudTaJOBbRKx1h1fK0dAtyr7MY/
	7i//ysIZkneCIyk6w4S4IcPVYV0NpTU=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57A7m4Ra013467;
	Sun, 10 Aug 2025 16:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eZaYkx
	dq57TzHEZWXDL3LSQ0gLrm6LZX0vgoYqN25PU=; b=n06X/Jfp2Ihy0CJtKNl4IZ
	4HN469Hx+4PCJBqo0o+JmlQe58oiuXDQ7wWchz/+mK0NsiRLjU/6QVSbhGjNTrbg
	9ne7IGpIQJ6Pa0ue+6kgjjhgDL1rSlluMnIGmGoG2ITvioV4fbMTTEwHdIC/23Nj
	N4GoqCkCJSyBco1/jDESbiFRaqRgqukqZI6O1004i9f7WPyoQz14ex8elVzRjeH2
	MjLtCoOsNETlf3YVuI/lhfBEu8h3i0KAtt4Cvd9pokvMOWaV+fH7eH2OaHqCJWvD
	MaX5NMXhab4femDUqnmOQk92VzAVcRydYKiSNs8x0YN1MofKwKF1emZkxxNex4qg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrnntwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:53:38 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57AGrcXS013512;
	Sun, 10 Aug 2025 16:53:38 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrnntwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:53:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57ACLhQc026270;
	Sun, 10 Aug 2025 16:53:37 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh20tneh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:53:37 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57AGrbr330933520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Aug 2025 16:53:37 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09EFF58050;
	Sun, 10 Aug 2025 16:53:37 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B834A58045;
	Sun, 10 Aug 2025 16:53:26 +0000 (GMT)
Received: from [9.124.216.245] (unknown [9.124.216.245])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 10 Aug 2025 16:53:26 +0000 (GMT)
Message-ID: <d90d8aa9-0e19-4098-ad3c-1c8069167538@linux.ibm.com>
Date: Sun, 10 Aug 2025 22:23:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: check after-split folio orders in
 split_huge_page_test.
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
        wang lian <lianux.mm@gmail.com>,
        Baolin Wang
 <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-4-ziy@nvidia.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250808190144.797076-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEwMDEyMyBTYWx0ZWRfX1KC0HXYQxXPq
 NclwyjsVZJj94pW+rX5fg2EDl5hl7jqSs2GRX8JWror7aqSrqXmIHMkMO9HHwyvucoQE/zVSaCC
 E4gHTojazdKVRHUhSzvB6yctJ82TuORKOCU+7uobQc71i7A3uNGreSxk4D0oV556G5cU0XMvZOs
 8JZGtJy4GkW7BoAeP9taQcwS6fNWdUyECkHfUI0dUXEBg4VdfYsWW5+SDW/00vINysEyqxPupSx
 gxlCkpBhOn72qMYR2/LGdgcY7LN7FFBvX+aeXFHGtC6u2dTKzy0lJLow75Z5gk+YZ5qhsKlFO49
 06tqNxLpY4RVLq0cogNuM05Wa2WJa4MOIQIru9dTdUgJ/Qi3OstjtZTzgHbPFT0h/5imAjSSGUm
 Cwt23eSsFPT3sflm6QypAzo/RiT2+VxWILu2+T4mgDxEkpBrasNgn4kinNmb85EeD69BHCqV
X-Authority-Analysis: v=2.4 cv=GrpC+l1C c=1 sm=1 tr=0 ts=6898ce92 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=Ikd4Dj_1AAAA:8 a=99-7eeOMbBYPJQNDcP0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: kLZeXgm3d9BGfBZmCX8LZerUyXA6pVgp
X-Proofpoint-ORIG-GUID: Z6Z6lzQxBG4wubdRAKY4I1PN3o44dqpO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 adultscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508100123
X-Rspam-User: 
X-Rspamd-Queue-Id: 28136180006
X-Rspamd-Server: rspam06
X-Stat-Signature: 8sre5p9zsbpfqeexnape7ubcsqjz7kxr
X-HE-Tag: 1754844823-438348
X-HE-Meta: U2FsdGVkX1/L2GO3p/x14YGF1vhEfSRr+j4AAf767vcR6um+OIydq6dA9v8iix2dJPCOTtNaRHHYHfpY3fbQM/D4RGjP1Ha2dLSaVEC1wH9oKGco4xsZ407gcbjymxovXzFr/Mt1Y9jhwSgkIC04gjYAqxRqb3/1bZOSS30B89POqpBDKGR8ryeYHWd4v+J02vgX1eS3SGNQc1+EG9q5xvOtkHG3MfdZXTyusqk99u4rh+qlDGpGXqiZshA4D8ISv7pPPlEbrorj9kzUB9Eu8IQsUeKLWIYIWApmSOTBANJ9G2kL20s4vAg/wJRsbx9Bk2KtivE+4W3pO0Egz1BSmB3t7IqQA5xX3TmxJxqK+/7HrKEP88F122WvJdsUfbsx5LdirvhP1yMy3wyk99vRRAMZ9k+afSpnyOP7DM2qhls7VQcPHfCWRAmC5fjvgPnfU0InMBFe6hMZGwhrYFkxQ4AtwuYE+wgOHR6fz3Q5EdVxc7wwoAxYJlaLE7wJtnYhYQBZjDUkDKVo/hVSPkUscZl5nlDBMuIB5ns6VgFdpaxPD89IVw2Z/LS97OBolfTp5Dvmy8WPa6E4NrxM8n+iy6VDZ3rlzAxhcb3ajRi5/1+qKDHTGOhtNz+4bG0uGbX15GM8gSRmKs2gDnbrAmAzteQ/2M8Nnb3ZJBxzYCbfduh6dikM9Vjn2JAfs2VZpklzxjc+2XF98P7FnueKNfr/NOVkKKUfmkQcXJYPDWWgqh8fUJDFohzboYaMkhZz/2P4/rgeFoYKWO6UpQWkLue/AbPwJwa3DRPgr1X8zeRAqAB6IcbICcgNtLckXmwWH9D4W7EF2qNX7Sf7Hrza1yc8nYwwSvu2oRIVwZG3oNc8i8lElcUczznMC96B+FsIpa/6A312Nut77lmSUIcttqwMTLnPgVAhNpP2xvJT9lLEvh8xFBMV5pygGXaHWnGCNF/T/0V47cQAHoAa3e4KvF7
 LAU4nUni
 0PuKGC8i+O2/cxtwxuQP1xugxL5gEan6faFtqNt1EA83CHdIJdaFXDlWa0KPjWTql+l7xuv547KXSyMp/sa1gc00slNWMTA8fiOTzk86KVzGZ3u7ZlJrnDI4XOgl+bAz6wlnV9azkciFvfuyqpw9uDKtvjSddMJOnClvh/oymA+ZkDOFRLuNMxbOrLlXUsh6701/fnaVyHnoN17iGmixggYQqYp4L/LC30NGFdQm/CCA3RPlEqXMwCy1Vk9kqC/6mFnqxSRvSSCqj2Twm80zxQMSl4clXLjJPHDpmkR0EmrDEyjFWnFGGhulgUIOnvDqIb+2PxjSmqe1JbtU0fdwxKF3Seb2H1vMqnOxZNQaTPKXNMrdRFDJLhTsLSzlsqOfP/20C6IuhjFCUBOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/9/25 12:31 AM, Zi Yan wrote:
> Instead of just checking the existence of PMD folios before and after folio
> split tests, use check_folio_orders() to check after-split folio orders.
>
> The following tests are not changed:
> 1. split_pte_mapped_thp: the test already uses kpageflags to check;
> 2. split_file_backed_thp: no vaddr available.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   .../selftests/mm/split_huge_page_test.c       | 98 ++++++++++++++-----
>   1 file changed, 72 insertions(+), 26 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 5ab488fab1cd..161108717f1c 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -25,6 +25,10 @@
>   uint64_t pagesize;
>   unsigned int pageshift;
>   uint64_t pmd_pagesize;
> +unsigned int pmd_order;
> +unsigned int max_order;
> +
> +#define NR_ORDERS (max_order + 1)
>   
>   #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
>   #define SMAP_PATH "/proc/self/smaps"
> @@ -36,6 +40,11 @@ uint64_t pmd_pagesize;
>   
>   #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>   
> +const char *pagemap_proc = "/proc/self/pagemap";
> +const char *kpageflags_proc = "/proc/kpageflags";
> +int pagemap_fd;
> +int kpageflags_fd;
> +
>   int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
>   {
>   	uint64_t paddr;
> @@ -151,6 +160,11 @@ void split_pmd_thp_to_order(int order)
>   	char *one_page;
>   	size_t len = 4 * pmd_pagesize;
>   	size_t i;
> +	int *orders;
> +
> +	orders = (int *)malloc(sizeof(int) * NR_ORDERS);
> +	if (!orders)
> +		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
>   
>   	one_page = memalign(pmd_pagesize, len);
>   	if (!one_page)
> @@ -172,12 +186,20 @@ void split_pmd_thp_to_order(int order)
>   		if (one_page[i] != (char)i)
>   			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>   
> +	memset(orders, 0, sizeof(int) * NR_ORDERS);
> +	/* set expected orders */
> +	orders[order] = 4 << (pmd_order - order);
> +
> +	if (check_folio_orders(one_page, len, pagemap_fd, kpageflags_fd,
> +			       orders, NR_ORDERS))
> +		ksft_exit_fail_msg("Unexpected THP split\n");
>   
>   	if (!check_huge_anon(one_page, 0, pmd_pagesize))
>   		ksft_exit_fail_msg("Still AnonHugePages not split\n");
>   
>   	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
>   	free(one_page);
> +	free(orders);
>   }
>   
>   void split_pte_mapped_thp(void)
> @@ -186,22 +208,6 @@ void split_pte_mapped_thp(void)
>   	size_t len = 4 * pmd_pagesize;
>   	uint64_t thp_size;
>   	size_t i;
> -	const char *pagemap_template = "/proc/%d/pagemap";
> -	const char *kpageflags_proc = "/proc/kpageflags";
> -	char pagemap_proc[255];
> -	int pagemap_fd;
> -	int kpageflags_fd;
> -
> -	if (snprintf(pagemap_proc, 255, pagemap_template, getpid()) < 0)
> -		ksft_exit_fail_msg("get pagemap proc error: %s\n", strerror(errno));
> -
> -	pagemap_fd = open(pagemap_proc, O_RDONLY);
> -	if (pagemap_fd == -1)
> -		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
> -
> -	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
> -	if (kpageflags_fd == -1)
> -		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
>   
>   	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
>   			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> @@ -259,8 +265,6 @@ void split_pte_mapped_thp(void)
>   
>   	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
>   	munmap(one_page, len);
> -	close(pagemap_fd);
> -	close(kpageflags_fd);
>   }
>   
>   void split_file_backed_thp(int order)
> @@ -463,10 +467,16 @@ void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
>   		int order, int offset)
>   {
>   	int fd;
> +	char *split_addr;
>   	char *addr;
>   	size_t i;
>   	char testfile[INPUT_MAX];
>   	int err = 0;
> +	int *orders;
> +
> +	orders = (int *)malloc(sizeof(int) * NR_ORDERS);
> +	if (!orders)
> +		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
>   
>   	err = snprintf(testfile, INPUT_MAX, "%s/test", fs_loc);
>   
> @@ -474,16 +484,32 @@ void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
>   		ksft_exit_fail_msg("cannot generate right test file name\n");
>   
>   	err = create_pagecache_thp_and_fd(testfile, fd_size, &fd, &addr);
> -	if (err)
> +	if (err) {
> +		free(orders);
>   		return;
> +	}
>   	err = 0;
>   
> -	if (offset == -1)
> -		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
> -			      (uint64_t)addr + fd_size, order);
> -	else
> -		write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)addr,
> -			      (uint64_t)addr + fd_size, order, offset);
> +	memset(orders, 0, sizeof(int) * NR_ORDERS);
> +	if (offset == -1) {
> +		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
> +			write_debugfs(PID_FMT, getpid(), (uint64_t)split_addr,
> +				      (uint64_t)split_addr + pagesize, order);
> +
> +		/* set expected orders */
> +		orders[order] = fd_size / (pagesize << order);
> +	} else {
> +		int times = fd_size / pmd_pagesize;
> +
> +		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
> +			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)split_addr,
> +				      (uint64_t)split_addr + pagesize, order, offset);
> +
> +		/* set expected orders */
> +		for (i = order + 1; i < pmd_order; i++)
> +			orders[i] = times;
> +		orders[order] = 2 * times;
> +	}
>   
>   	for (i = 0; i < fd_size; i++)
>   		if (*(addr + i) != (char)i) {
> @@ -492,6 +518,14 @@ void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
>   			goto out;
>   		}
>   
> +	if (check_folio_orders(addr, fd_size, pagemap_fd, kpageflags_fd, orders,
> +			       NR_ORDERS)) {
> +		ksft_print_msg("Unexpected THP split\n");
> +		err = 1;
> +		goto out;
> +	}
> +
> +
>   	if (!check_huge_file(addr, 0, pmd_pagesize)) {
>   		ksft_print_msg("Still FilePmdMapped not split\n");
>   		err = EXIT_FAILURE;
> @@ -499,6 +533,7 @@ void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
>   	}
>   
>   out:
> +	free(orders);
>   	munmap(addr, fd_size);
>   	close(fd);
>   	unlink(testfile);
> @@ -522,7 +557,6 @@ int main(int argc, char **argv)
>   	const char *fs_loc;
>   	bool created_tmp;
>   	int offset;
> -	unsigned int max_order;
>   	unsigned int nr_pages;
>   	unsigned int tests;
>   
> @@ -539,6 +573,7 @@ int main(int argc, char **argv)
>   	pagesize = getpagesize();
>   	pageshift = ffs(pagesize) - 1;
>   	pmd_pagesize = read_pmd_pagesize();
> +	pmd_order = GET_ORDER(pmd_pagesize / pagesize);


I think max_order is also same as pmd_order

   nr_pages = pmd_pagesize / pagesize;
   max_order = GET_ORDER(nr_pages);

Can we use one?

>   	if (!pmd_pagesize)
>   		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>   
> @@ -547,6 +582,14 @@ int main(int argc, char **argv)
>   	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
>   	ksft_set_plan(tests);
>   
> +	pagemap_fd = open(pagemap_proc, O_RDONLY);
> +	if (pagemap_fd == -1)
> +		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
> +
> +	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
> +	if (kpageflags_fd == -1)
> +		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> +
>   	fd_size = 2 * pmd_pagesize;
>   
>   	split_pmd_zero_pages();
> @@ -571,6 +614,9 @@ int main(int argc, char **argv)
>   			split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, offset);
>   	cleanup_thp_fs(fs_loc, created_tmp);
>   
> +	close(pagemap_fd);
> +	close(kpageflags_fd);
> +
>   	ksft_finished();
>   
>   	return 0;

