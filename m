Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D81CFCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3243D8E0014; Fri,  5 Sep 2025 05:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FCDA8E0001; Fri,  5 Sep 2025 05:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212C08E0014; Fri,  5 Sep 2025 05:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D88E8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:26:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4AD61DEE7A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:26:27 +0000 (UTC)
X-FDA: 83854666014.10.9F2EA00
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12C9114000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:26:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GE4xZQ72;
	spf=pass (imf26.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757064385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=375OoqVYSIiI76bfwU1woBufWlBhut6MX0NDbBv335o=;
	b=B2aioY3aV4c4LgLxTfAlj9oNgqERWqMvqYfscmSDUdnXIAZMEp5rJMNkqJ4ADUvdBGI64Y
	jglC+sXO5Kl7NFLm4CfoX74l38eYVH2jHZs/cudKWTGNBhJN8dozrOf1cla9uqFlBnJSOy
	ilbDAE6YWxwg4lItboGDcCMf6phpkWo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GE4xZQ72;
	spf=pass (imf26.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757064385; a=rsa-sha256;
	cv=none;
	b=GMM7QS615kBXJthr4GDh64aGjb5fB2sdQPy5ZHiIr/PSy+1/6AayviCCtU14hnxGyCemIy
	Q1gXb+Ga1T6HzSRMR50bnzEZrcZz6JUuNiS0em2UShm4y5139lCJKrqw+DFqpY5dLVwLNR
	3Vt0+36k5XjmK4wLNV6SnfdNVSrZomU=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5852CAxZ021868;
	Fri, 5 Sep 2025 09:26:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=375OoqVYSIiI76bfwU1woBufWlBhut
	6MX0NDbBv335o=; b=GE4xZQ72hJZF0/V6DgPxdSmpAdfoUChWM6SCI2DQspiZyt
	h5ya4RDwv8hvsdypzZsAx4CHdU+Ia/gKT157Ir1iTb86atee5FlKruBkBvCMFukl
	UjLXLmXTWmC8grP4TrgdZZAyVYKbSv+MSldAU/7fSz3eXD+oPbSJU92MEcGul8Vh
	w8iLFra2bviPQfevcPC31x/0QMw1TwVMi54wSEbBHXPegxJICxHSX3dX6NpGJ/0u
	3dqxRrV/B/kRB/3Hjpybpxcb3JZL2acA/w7ePBH/qvFPiOOT41CleE1fq9aUY3EB
	YErHzQ0/pngSiV77YWjky6+vbBegQH/ZsUb+nDsQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usurfgjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 09:26:23 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5855pAww014145;
	Fri, 5 Sep 2025 09:26:22 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48veb3rh2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 09:26:22 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5859QCie25821940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Sep 2025 09:26:12 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF41958056;
	Fri,  5 Sep 2025 09:26:21 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1B1058050;
	Fri,  5 Sep 2025 09:26:19 +0000 (GMT)
Received: from [9.124.222.158] (unknown [9.124.222.158])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Sep 2025 09:26:19 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------BoRxvhG5r54WLqmtSDTOR9DW"
Message-ID: <17307d75-ec17-48ff-b79a-d08106b53966@linux.ibm.com>
Date: Fri, 5 Sep 2025 14:56:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: split_huge_page_test: cleanups for
 split_pte_mapped_thp test
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        Zi Yan <ziy@nvidia.com>
References: <20250902162536.956465-1-david@redhat.com>
 <20250902162536.956465-3-david@redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250902162536.956465-3-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMCBTYWx0ZWRfX1H9Nr53FjA8q
 uYueyB9nMECu1OiYUq/nyuvIOGlZfvfhWF0Ckq41+e4xbU7cSrtBf6dQ0WJRqw7NbbO0B8L0SfY
 xCyELp+zuD+mMeKsi3hnAQhvi2f69QZc+dJVii8meFBQrfkvqvFGGaufrUeIu9RuursaQbIqqcc
 6L89ERLHfSG/3SEqXh0bBwutfxiWmVxZvUZDoJeaVjlIHBuze7APW/YsEANHZaF9d8v/tCSYKMY
 vkmb+XbJoJLmEgPedUp1DhDjXF6m0nH25iU1B9wwAxpM2OeE21agJy2IDxbh1Aj3/ymKLrbdT5v
 Thnzycyr2nI4csDlsVaR3CrvT5vJ9k58CNeOX48Xs9Xax0IGpL4egS3/hPPHVvzHpE6GMiq3LXR
 mdlQbf42
X-Proofpoint-GUID: ISlBaJOAcGQFv2czMF9s6ZHeZ0pVKnSb
X-Proofpoint-ORIG-GUID: ISlBaJOAcGQFv2czMF9s6ZHeZ0pVKnSb
X-Authority-Analysis: v=2.4 cv=Ao/u3P9P c=1 sm=1 tr=0 ts=68baacbf cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=r77TgQKjGQsHNAKrUKIA:9 a=Ikd4Dj_1AAAA:8 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=hEZJ7R0-utvY_u_M2LgA:9 a=QEXdDO2ut3YA:10
 a=7RxLTaD-BpJEkT8vOu8A:9 a=5d3Nl0t2EE9ai2oi:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_02,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300030
X-Stat-Signature: 91ocmhtd5qgqxa34e69g1f3ing7ara9s
X-Rspam-User: 
X-Rspamd-Queue-Id: 12C9114000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1757064384-188363
X-HE-Meta: U2FsdGVkX18pGufNmwkiZt2ktMS6K+CwCnPq6MH6OTnti3hK3etQXK52Bu1hEl2TtYmP6ip5xe95Ya81l4KTtwO8XEk23mrzKM7V6z9RKLyNxndsZdN11OhPnF8ikuH36MmaSmreBFsQcPjDGqncEP+++fPxm9aEob2Afzljg9Lj3wqe7U1DB0diwiKtF7MPKkxwdp82YpIYEyy9kGcpVxtv5llWCL8eMdMk2b9YLRNKcuHfkyeHCbEtxgzS4dUIvyjEmh9Fii/PHUQuPYm61iwI0ajWqNErFSob+CbkV0FtteNC2/4VLcGY2jW6R134XUUGYq6VvKJhjK8qvPymOxqijXHMarm4/gwMRHRpA9OIeWIWBbVpZPu+0av2KlcePOH88xBTYGQEFu87E984V9hCCirD5Da0ygcwxiYbfhlP05YWhm7dRBZc0a7BMaZGzF0HFJck7i3XjU41YEp/nj5aEe98swEYPFQfeurOqgwPr2/41TdlGB5T/Pt2C3LwYhRneW7G7YooZk+VfmoPW7oh+c1ceovL/57C8OHUs5g6WZJseg7d6p0we8T7AzHszkey6XU2ZMwOWbZ/oHWQiRGFb18PWPzde2lDX6tBJOgIN5O4bIX8xKBQDmXZXVr1EUG1Spvkq62T2EVvyauK8qxwpwM1SsH3yRxo89PYFRAQOQW7vtEexkL5OKAeSyidGHjxHuNUWRYt5e7xwHi/4aO5yNe6p7V6UPST1l6mvNewOdicui9nv/hOxVel0Laelm0eDyAMDlGOgQAPrOq/l3nQM3jPZv0CpMw1GbtdEcr0wJMgu+hH525PmDH3tfizi6Wf5Lnr0xdWYhv2grZqVRRCuqMD6hxYjokJd6Pqm1Qu9a0EmjQ+iP2Are0leClg7LeehIqxGLtCHmCZUh3qYfchoWNLqkVd/VgsqkhTa6Bx+4vp5oPDmslH5Np+N+nxhNARTQAq3fNV7kYDx0l
 c5TAS2BK
 MQLteh0roceamEsV7B9y6rWk9LwG+V+44j5nOsWcrevHRklasD7dG1zz7tknx99xY8AETiw1mMMAs/Mn3Rb/99mzyXp4ZgGI6iDzdcJrid2kCJKDatjjOF/JR9FuyGxBtwzZ97nDS5geYIynnTtbwSLC+Q6RFDFaxIvmK+ErQRYueqGl1n2orP0TElX2F2wwTr327XeKg464VqfXhjicBglmI2Ewe28PbQSmX5An8WqAPT/YqCv9ZMGYIr8q0zkLY7qnwCm1/FBelUXC7rqtIYRgdugLjPWP4rTJa+Wwp2m2wSJgCCnbUXL7JAOI3X9+DgYbfWnE4FKdaxIWc/RzhcrzTEC4Ddsl9xcxQd1QYwhwB0kWib1L4UqG2BwpxwyvKtwosP49nV1hOe79sSMHLgD6IlFB1EkuNKNn6ygCYsDuUzoKIkOwwl2SeikZzBHVB3MlrIVMOA/Nr227eFsoZZ8NocQCSGGBa51hKfUl6C15vEpz8URbePmXNyA2zKIISJ2fO/Rqmbgohhp10mjsYr0a9nQgeBwTB6T95VoKtpdYmL1spmBypm6QXXgCDZ6vQEAdOgYLerdcsXsStpkaGc4COivHDBxjcvh4RG33e9ldwx92HL3uE02zPXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------BoRxvhG5r54WLqmtSDTOR9DW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/2/25 9:55 PM, David Hildenbrand wrote:
> There is room for improvement, so let's clean up a bit:
>
> (1) Define "4" as a constant.
>
> (2) SKIP if we fail to allocate all THPs (e.g., fragmented) and add
>      recovery code for all other failure cases: no need to exit the test.
>
> (3) Rename "len" to thp_area_size, and "one_page" to "thp_area".
>
> (4) Allocate a new area "page_area" into which we will mremap the
>      pages; add "page_area_size". Now we can easily merge the two
>      mremap instances into a single one.
>
> (5) Iterate THPs instead of bytes when checking for missed THPs after
>      mremap.
>
> (6) Rename "pte_mapped2" to "tmp", used to verify mremap(MAP_FIXED)
>      result.
>
> (7) Split the corruption test from the failed-split test, so we can just
>      iterate bytes vs. thps naturally.
>
> (8) Extend comments and clarify why we are using mremap in the first
>      place.
>
> Reviewed-by: Zi Yan<ziy@nvidia.com>
> Signed-off-by: David Hildenbrand<david@redhat.com>
> ---
>   .../selftests/mm/split_huge_page_test.c       | 123 +++++++++++-------
>   1 file changed, 74 insertions(+), 49 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 72d6d8bb329ed..7731191cc8e9b 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -389,67 +389,92 @@ static void split_pmd_thp_to_order(int order)
>   
>   static void split_pte_mapped_thp(void)
>   {
> -	char *one_page, *pte_mapped, *pte_mapped2;
> -	size_t len = 4 * pmd_pagesize;
> -	uint64_t thp_size;
> +	const size_t nr_thps = 4;
> +	const size_t thp_area_size = nr_thps * pmd_pagesize;
> +	const size_t page_area_size = nr_thps * pagesize;
> +	char *thp_area, *tmp, *page_area = MAP_FAILED;
>   	size_t i;
>   
> -	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
> +	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
>   			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> -	if (one_page == MAP_FAILED)
> -		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
> +	if (thp_area == MAP_FAILED) {
> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
> +		return;
> +	}
>   
> -	madvise(one_page, len, MADV_HUGEPAGE);
> +	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
>   
> -	for (i = 0; i < len; i++)
> -		one_page[i] = (char)i;
> +	for (i = 0; i < thp_area_size; i++)
> +		thp_area[i] = (char)i;
>   
> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
> -		ksft_exit_fail_msg("No THP is allocated\n");
> +	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
> +		ksft_test_result_skip("Not all THPs allocated\n");
> +		goto out;
> +	}
>   
> -	/* remap the first pagesize of first THP */
> -	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
> -
> -	/* remap the Nth pagesize of Nth THP */
> -	for (i = 1; i < 4; i++) {
> -		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
> -				     pagesize, pagesize,
> -				     MREMAP_MAYMOVE|MREMAP_FIXED,
> -				     pte_mapped + pagesize * i);
> -		if (pte_mapped2 == MAP_FAILED)
> -			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
> -	}
> -
> -	/* smap does not show THPs after mremap, use kpageflags instead */
> -	thp_size = 0;
> -	for (i = 0; i < pagesize * 4; i++)
> -		if (i % pagesize == 0 &&
> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
> -			thp_size++;
> -
> -	if (thp_size != 4)
> -		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
> -
> -	/* split all remapped THPs */
> -	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
> -		      (uint64_t)pte_mapped + pagesize * 4, 0);
> -
> -	/* smap does not show THPs after mremap, use kpageflags instead */
> -	thp_size = 0;
> -	for (i = 0; i < pagesize * 4; i++) {
> -		if (pte_mapped[i] != (char)i)
> -			ksft_exit_fail_msg("%ld byte corrupted\n", i);
> +	/*
> +	 * To challenge spitting code, we will mremap a single page of each
> +	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
> +	 * replace the PMD mappings in the thp_area by PTE mappings first,
> +	 * but leaving the THP unsplit, to then create a page-sized hole in
> +	 * the thp_area.
> +	 * We will then manually trigger splitting of all THPs through the
> +	 * single mremap'ed pages of each THP in the page_area.
> +	 */
> +	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
> +			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +	if (page_area == MAP_FAILED) {
> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
> +		goto out;
> +	}
>   
> -		if (i % pagesize == 0 &&
> -		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
> -			thp_size++;
> +	for (i = 0; i < nr_thps; i++) {
> +		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
> +			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
> +			     page_area + pagesize * i);
> +		if (tmp != MAP_FAILED)
> +			continue;
> +		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
> +		goto out;
> +	}
> +
> +	/*
> +	 * Verify that our THPs were not split yet. Note that
> +	 * check_huge_anon() cannot be used as it checks for PMD mappings.
> +	 */
> +	for (i = 0; i < nr_thps; i++) {
> +		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
> +				       pagemap_fd, kpageflags_fd))
> +			continue;
> +		ksft_test_result_fail("THP %zu missing after mremap\n", i);
> +		goto out;
>   	}
>   
> -	if (thp_size)
> -		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
> +	/* Split all THPs through the remapped pages. */
> +	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
> +		      (uint64_t)page_area + page_area_size, 0);
> +
> +	/* Corruption during mremap or split? */
> +	for (i = 0; i < page_area_size; i++) {
> +		if (page_area[i] == (char)i)
> +			continue;
> +		ksft_test_result_fail("%zu byte corrupted\n", i);
> +		goto out;
> +	}
> +
> +	/* Split failed? */
> +	for (i = 0; i < nr_thps; i++) {
> +		if (is_backed_by_folio(page_area + i * pagesize, 0,
> +				       pagemap_fd, kpageflags_fd))
> +			continue;
> +		ksft_test_result_fail("THP %zu not split\n", i);
> +	}
>   
>   	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
> -	munmap(one_page, len);
> +out:
> +	munmap(thp_area, thp_area_size);
> +	if (page_area != MAP_FAILED)
> +		munmap(page_area, page_area_size);
>   }
>
>
I have tested this patch on a system with a 64 KB page size, and all 
tests passed.

# Totals: pass:34 fail:0 xfail:0 xpass:0 skip:0 error:0

Tested by: Donet Tom <donettom@linux.ibm.com>

>
>
>
>   
>   static void split_file_backed_thp(int order)
--------------BoRxvhG5r54WLqmtSDTOR9DW
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 9/2/25 9:55 PM, David Hildenbrand
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20250902162536.956465-3-david@redhat.com">
      <pre wrap="" class="moz-quote-pre">There is room for improvement, so let's clean up a bit:

(1) Define "4" as a constant.

(2) SKIP if we fail to allocate all THPs (e.g., fragmented) and add
    recovery code for all other failure cases: no need to exit the test.

(3) Rename "len" to thp_area_size, and "one_page" to "thp_area".

(4) Allocate a new area "page_area" into which we will mremap the
    pages; add "page_area_size". Now we can easily merge the two
    mremap instances into a single one.

(5) Iterate THPs instead of bytes when checking for missed THPs after
    mremap.

(6) Rename "pte_mapped2" to "tmp", used to verify mremap(MAP_FIXED)
    result.

(7) Split the corruption test from the failed-split test, so we can just
    iterate bytes vs. thps naturally.

(8) Extend comments and clarify why we are using mremap in the first
    place.

Reviewed-by: Zi Yan <a class="moz-txt-link-rfc2396E" href="mailto:ziy@nvidia.com">&lt;ziy@nvidia.com&gt;</a>
Signed-off-by: David Hildenbrand <a class="moz-txt-link-rfc2396E" href="mailto:david@redhat.com">&lt;david@redhat.com&gt;</a>
---
 .../selftests/mm/split_huge_page_test.c       | 123 +++++++++++-------
 1 file changed, 74 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 72d6d8bb329ed..7731191cc8e9b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -389,67 +389,92 @@ static void split_pmd_thp_to_order(int order)
 
 static void split_pte_mapped_thp(void)
 {
-	char *one_page, *pte_mapped, *pte_mapped2;
-	size_t len = 4 * pmd_pagesize;
-	uint64_t thp_size;
+	const size_t nr_thps = 4;
+	const size_t thp_area_size = nr_thps * pmd_pagesize;
+	const size_t page_area_size = nr_thps * pagesize;
+	char *thp_area, *tmp, *page_area = MAP_FAILED;
 	size_t i;
 
-	one_page = mmap((void *)(1UL &lt;&lt; 30), len, PROT_READ | PROT_WRITE,
+	thp_area = mmap((void *)(1UL &lt;&lt; 30), thp_area_size, PROT_READ | PROT_WRITE,
 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (one_page == MAP_FAILED)
-		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
+	if (thp_area == MAP_FAILED) {
+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
+		return;
+	}
 
-	madvise(one_page, len, MADV_HUGEPAGE);
+	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
 
-	for (i = 0; i &lt; len; i++)
-		one_page[i] = (char)i;
+	for (i = 0; i &lt; thp_area_size; i++)
+		thp_area[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
-		ksft_exit_fail_msg("No THP is allocated\n");
+	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
+		ksft_test_result_skip("Not all THPs allocated\n");
+		goto out;
+	}
 
-	/* remap the first pagesize of first THP */
-	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
-
-	/* remap the Nth pagesize of Nth THP */
-	for (i = 1; i &lt; 4; i++) {
-		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
-				     pagesize, pagesize,
-				     MREMAP_MAYMOVE|MREMAP_FIXED,
-				     pte_mapped + pagesize * i);
-		if (pte_mapped2 == MAP_FAILED)
-			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
-	}
-
-	/* smap does not show THPs after mremap, use kpageflags instead */
-	thp_size = 0;
-	for (i = 0; i &lt; pagesize * 4; i++)
-		if (i % pagesize == 0 &amp;&amp;
-		    is_backed_by_folio(&amp;pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
-			thp_size++;
-
-	if (thp_size != 4)
-		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
-
-	/* split all remapped THPs */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
-		      (uint64_t)pte_mapped + pagesize * 4, 0);
-
-	/* smap does not show THPs after mremap, use kpageflags instead */
-	thp_size = 0;
-	for (i = 0; i &lt; pagesize * 4; i++) {
-		if (pte_mapped[i] != (char)i)
-			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+	/*
+	 * To challenge spitting code, we will mremap a single page of each
+	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
+	 * replace the PMD mappings in the thp_area by PTE mappings first,
+	 * but leaving the THP unsplit, to then create a page-sized hole in
+	 * the thp_area.
+	 * We will then manually trigger splitting of all THPs through the
+	 * single mremap'ed pages of each THP in the page_area.
+	 */
+	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (page_area == MAP_FAILED) {
+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
+		goto out;
+	}
 
-		if (i % pagesize == 0 &amp;&amp;
-		    !is_backed_by_folio(&amp;pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
-			thp_size++;
+	for (i = 0; i &lt; nr_thps; i++) {
+		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
+			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
+			     page_area + pagesize * i);
+		if (tmp != MAP_FAILED)
+			continue;
+		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
+		goto out;
+	}
+
+	/*
+	 * Verify that our THPs were not split yet. Note that
+	 * check_huge_anon() cannot be used as it checks for PMD mappings.
+	 */
+	for (i = 0; i &lt; nr_thps; i++) {
+		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
+				       pagemap_fd, kpageflags_fd))
+			continue;
+		ksft_test_result_fail("THP %zu missing after mremap\n", i);
+		goto out;
 	}
 
-	if (thp_size)
-		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
+	/* Split all THPs through the remapped pages. */
+	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
+		      (uint64_t)page_area + page_area_size, 0);
+
+	/* Corruption during mremap or split? */
+	for (i = 0; i &lt; page_area_size; i++) {
+		if (page_area[i] == (char)i)
+			continue;
+		ksft_test_result_fail("%zu byte corrupted\n", i);
+		goto out;
+	}
+
+	/* Split failed? */
+	for (i = 0; i &lt; nr_thps; i++) {
+		if (is_backed_by_folio(page_area + i * pagesize, 0,
+				       pagemap_fd, kpageflags_fd))
+			continue;
+		ksft_test_result_fail("THP %zu not split\n", i);
+	}
 
 	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
-	munmap(one_page, len);
+out:
+	munmap(thp_area, thp_area_size);
+	if (page_area != MAP_FAILED)
+		munmap(page_area, page_area_size);
 }


</pre>
    </blockquote>
    <p><span style="white-space: pre-wrap">
</span></p>
    <p><span style="white-space: pre-wrap">I have tested this patch on a system with a 64 KB page size, and all tests passed.</span></p>
    <p><span style="white-space: pre-wrap"> # Totals: pass:34 fail:0 xfail:0 xpass:0 skip:0 error:0</span></p>
    <p><span style="white-space: pre-wrap">
</span></p>
    <p><span style="white-space: pre-wrap">Tested by: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a>

</span></p>
    <blockquote type="cite"
      cite="mid:20250902162536.956465-3-david@redhat.com">
      <pre wrap="" class="moz-quote-pre">



 
 static void split_file_backed_thp(int order)
</pre>
    </blockquote>
  </body>
</html>

--------------BoRxvhG5r54WLqmtSDTOR9DW--


