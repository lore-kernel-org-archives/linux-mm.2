Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE54E9DE6B
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6CD6B0088; Thu,  9 Apr 2026 05:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596E36B008A; Thu,  9 Apr 2026 05:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486536B008C; Thu,  9 Apr 2026 05:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36C7D6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:04:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE70DC1E50
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:04:17 +0000 (UTC)
X-FDA: 84638430954.11.0F4C7CF
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B2EA10000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:04:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GawDvfh0;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775725455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRuj7KznoikSTmL2aPPH26e92KL8/vXZHi1ZBjPLNSk=;
	b=MY0hz+uzf3xQ32Rx/lsnco7qNLEUHhPVlOtKPyqvLPO2ninpFzgE2d8ba5D+NVD2NJgoYY
	YPJQRq8cy7Dlb7TlHRUrxM83GA+7j4vG+zcWgrcnQef9ltbDHwbZ3HTGYftiZnjnXSR38M
	U47hH93ts19lUpkru4YKfSg/JdKWupo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GawDvfh0;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775725455; a=rsa-sha256;
	cv=none;
	b=RfKMgjDjHHoQEGmZLDLlH+gV8dLUjG4TMP2YRTK5XlDG2ARbj9uQjWoZHvv/si56UOlC3m
	dbPCtCSe7PqpEhIu9gWB4aiQCT1kjRiijkzvqvDtgeOlyXKrW8cYyaQGGYQdGbFWJJhLR0
	cNCnS4H84J5bCA0uc/jbULkjNdsLwyE=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638JCp4d2516358;
	Thu, 9 Apr 2026 09:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HRuj7KznoikSTmL2aPPH26e92KL8/v
	XZHi1ZBjPLNSk=; b=GawDvfh0TFogqAXG8f7bNM4VHN4oIwmmmvZ6Qnryo8iGRh
	ienqWaqou36ulWERk6wFzJsnvcMU2j7x8acBaQV0taXgi8MHiimjUg3uNETiDIDF
	cGkiMB+swT7HBJCBbxq3Y4G36hc7bPLMUThF5t6bhkgwz5shusMDU/vCiKPv1q1J
	lWrySkf5oxRJcpEPE1G0bj1DD9zhn517Z8kI4avnqw1TOZ6Y86ZKk2PcFL54AHb5
	PRYhj9tHOBCsg8nVJllssjDKFDmuUaKkVD1iA736t+vlSlMch4ZRGf936WgkfKEd
	K3EYVmnHqcJlKZK7s1bkjb+rPKHDxgv44BD1YqXQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2g3avw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 09:04:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6397vYqT013827;
	Thu, 9 Apr 2026 09:04:06 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmf4awtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 09:04:06 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639946ta34669074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 09:04:06 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 601D45805B;
	Thu,  9 Apr 2026 09:04:06 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4B0158058;
	Thu,  9 Apr 2026 09:03:57 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 09:03:57 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------uGaPtK1tzST1xWSar09lgc1I"
Message-ID: <7a6a6912-87f7-4a8c-925b-f9b9848964bd@linux.ibm.com>
Date: Thu, 9 Apr 2026 14:33:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/53] selftests/mm: migration: don't assume hupe page is
 TWOMEG
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
 <20260406141735.2179309-4-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-4-rppt@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KeridwYD c=1 sm=1 tr=0 ts=69d76b88 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=rlPHAZ1KW3o3l-f_mKwA:9 a=QEXdDO2ut3YA:10
 a=vO6svISg_lu9jOKiBMcA:9 a=ZZEEGfxkCmjLWy6g:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-ORIG-GUID: TTEysIKSCgx2oPwW9P3AAAlxmmt4Zmy7
X-Proofpoint-GUID: Kt-S7C6L-u9M3RyB6Zz5yn1qABU3uwGf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDA3NyBTYWx0ZWRfX0vMKwh+HZpgg
 eYSTCoAiaxSG++pKtD1X6f2lGRfUZ22zO1Te0odbU3dg/95+SGAwAV0ojuNQUOuRd7sJKEIUUCR
 9r41m4CYXXlWCCkC1moxUegAISIdMrQ3bR4mxUG0waPFl07rQiKN6ac/Irnss9MmqIca6t9Co32
 w2mpH1RosjUPGcWsY7bhCGZus8Z5QQfQaQ3LV/fYA4fOrycuhrW+HZpyEFmcS07bXUNWniCm0WT
 QiwBOAKCzmTfXjX7uSjzcmgH/l82VqTggPJDcyQ1QC+4CxF88QUjKLrluQa+c52ho7e+NPL+Vd4
 9JmF1aNar9RsO2xzGLJb458ZJo7NBKOzD4XZs0isZrR5JcveqWjz5whax4AZPsV5HuIe+Joqrc3
 Ubrjrwgw3sBEDNEtPPrdwceJPtZVXCGkV2qnDJ3Yxv5rR0jjVFgwLP1U7fb4oxtW1mvOwhVtw3s
 0YRh2skve0BjNldn+Bw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_02,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1011 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090077
X-Rspamd-Queue-Id: 2B2EA10000F
X-Stat-Signature: 9qztjpynfatbab6atd4xxww3h3j63xx4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775725453-396270
X-HE-Meta: U2FsdGVkX184I5tWzbNKIiFr3bVN5eV1qI9SvrRFlqx1RUPgYV1JufzwiSt2WYFmWji37Jom6JylDiHaFshRNpL8ULN2T873MVO5OXQ8SL1z6d4lh5yXTVd64cGThUn+fwfHoNRZCEAumz9hwi22lHNsmTK5bscHiRHvu2WETxKWwXYXCJxSGl+tRKuGlqxKmOOmelQ7M37WtwFDQDQGT0XaC+oz4HdBcoYKbH3wxz/dyfPBKLuAvavO1wgUoZMeMM+fbjo3qvYtAzPDMU1Z476Iu1gqTfHoZxDL1Ex7hpZLfTKF2TLQUO22z/BZU9h/LKof/Eim5qSsme0fA7cCmsC0IhDNXlDz9XlchLaY+6GpJotSMF7rX9iTsfkVgAASMtKM2EOs0Udsms3nNe7C7u53+6cto0+AvtjyWhfDT7w8lVqzwDLf90Osmp742NOACYWTPYypJQb66B+lvkiHfmtonf0dP5gTYLyE/3W39mf09opVhAwAlR3i0Jr7LwFx9KKvhBvlqPyjsbG5p2PaobAqueoJlWGaBQU0SuGX588StqAv12gJn4mg80S8Wqv/MfygFDQovJpzYPbXGI3fj19R06tFyYTU2r8gN9wcpSvMZnKNg66j/gLyVsQ5Umj9ct3gi2Bj5YUSzWWuvUnwPnWUc4fd1UAuXN0L3hPXHV3R3l8aNCmM3jJE76cJG4/0C19pFTnXb8z/20GQmLNttjRcogUVemi02S9/XMTHK4VDqpY1thxXB6wRqsAniD9Ae4dRWJPC6xHC7yJhIED0zC1tOIkGHunIkoq4Rk0LT9sWGRLWqjuVn3CxVrZv1TxidF28c0xuDUmL7qlhVk5cui1ieglS5gmOtVVfrzRrkhVvnlSqK/Ls9TUiyvhCIZO/Ac6rv0Tdt738+eQWnQhCIWrBslVIECX6LNRo9SkKb+MwtFzBBRMYJy7aRp/3qnzGajgHaapDwTLTlB7egO2
 SwsOVWey
 ifW5nwCFRQP1PYNS41RZ5/I9NDVxPIxMYa0FJ65ZZdIQeDGJ4VZFhLmIaPuMmaGzI0ZQGK31s4/lHBCiHCZXoYfap0AbztLZ4WrH3hMso0Y+FVlfykg9hGXbQRKAtVHALoST1q0cSXaIdzCpHpNHj3zogqrGEniJd9hGTh0806pdmuvg50fQDs/8PvfR/u3pBknFGQ6adpI+qzw9rv1F9gXZtDyeX4z6VWZTBK341q+5Kifbh0UusSGhB45UmUUePW6tR889yOv3o7byhQT4AAljPnBwSLZv8AiC4ZYv59OlNNsYRPoPrhDu6U0pw1UEM/RnjC8/XGfx4/xB/1//nfeX8owgAcOMg1ejE9M+gaGSvef3BiLJY+dJhkV4oCb+duA6R8krY1a6cFfi0r9E61sUwpu9whYj1frEjHJhSA9BZx90lwWwaUFbomg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------uGaPtK1tzST1xWSar09lgc1I
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mike

On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)"<rppt@kernel.org>
>
> migration tests presume that both THP and HugeTLB huge pages are 2MB.
>
> Add dynamic detection of huge page size with read_pmd_pagesize() for THP
> and with default_huge_page_size() for HugeTLB.
>
> Signed-off-by: Mike Rapoport (Microsoft)<rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/migration.c | 44 +++++++++++++++++++-------
>   1 file changed, 32 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 60e78bbfc0e3..e3c2f831e15a 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -184,22 +184,27 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>    */
>   TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
>   {
> +	unsigned long pmdsize;
>   	uint64_t *ptr;
>   	int i;
>   
>   	if (!thp_is_enabled())
>   		SKIP(return, "Transparent Hugepages not available");
>   
> +	pmdsize = read_pmd_pagesize();
> +	if (!pmdsize)
> +		SKIP(return, "Reading PMD pagesize failed");
> +
>   	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
>   		SKIP(return, "Not enough threads or NUMA nodes available");
>   
> -	ptr = mmap(NULL, 2*TWOMEG, PROT_READ | PROT_WRITE,
> +	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
>   		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
> -	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
> -	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
> -	memset(ptr, 0xde, TWOMEG);
> +	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
> +	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
> +	memset(ptr, 0xde, pmdsize);
>   	for (i = 0; i < self->nthreads - 1; i++)
>   		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
>   			perror("Couldn't create thread");
> @@ -215,6 +220,7 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
>   
>   TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   {
> +	unsigned long pmdsize;
>   	pid_t pid;
>   	uint64_t *ptr;
>   	int i;
> @@ -222,17 +228,21 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   	if (!thp_is_enabled())
>   		SKIP(return, "Transparent Hugepages not available");
>   
> +	pmdsize = read_pmd_pagesize();
> +	if (!pmdsize)
> +		SKIP(return, "Reading PMD pagesize failed");
> +
>   	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
>   		SKIP(return, "Not enough threads or NUMA nodes available");
>   
> -	ptr = mmap(NULL, 2 * TWOMEG, PROT_READ | PROT_WRITE,
> +	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
>   		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
> -	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
> -	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
> +	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
> +	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
>   
> -	memset(ptr, 0xde, TWOMEG);
> +	memset(ptr, 0xde, pmdsize);
>   	for (i = 0; i < self->nthreads - 1; i++) {
>   		pid = fork();
>   		if (!pid) {
> @@ -256,17 +266,22 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>    */
>   TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
>   {
> +	unsigned long hugepage_size;
>   	uint64_t *ptr;
>   	int i;
>   
>   	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
>   		SKIP(return, "Not enough threads or NUMA nodes available");
>   
> -	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
> +	hugepage_size = default_huge_page_size();
> +	if (!hugepage_size)
> +		SKIP(return, "Reading HugeTLB pagesize failed\n");
> +
> +	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
>   		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
> -	memset(ptr, 0xde, TWOMEG);
> +	memset(ptr, 0xde, hugepage_size);
>   	for (i = 0; i < self->nthreads - 1; i++)
>   		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
>   			perror("Couldn't create thread");
> @@ -281,6 +296,7 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
>    */
>   TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   {
> +	unsigned long hugepage_size;
>   	pid_t pid;
>   	uint64_t *ptr;
>   	int i;
> @@ -288,11 +304,15 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
>   		SKIP(return, "Not enough threads or NUMA nodes available");
>   
> -	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
> +	hugepage_size = default_huge_page_size();
> +	if (!hugepage_size)
> +		SKIP(return, "Reading HugeTLB pagesize failed\n");
> +
> +	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
>   		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
> -	memset(ptr, 0xde, TWOMEG);
> +	memset(ptr, 0xde, hugepage_size);
>   	for (i = 0; i < self->nthreads - 1; i++) {
>   		pid = fork();
>   		if (!pid) {

This patch looks good to me.

Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet

--------------uGaPtK1tzST1xWSar09lgc1I
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

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
      cite="mid:20260406141735.2179309-4-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">From: "Mike Rapoport (Microsoft)" <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>

migration tests presume that both THP and HugeTLB huge pages are 2MB.

Add dynamic detection of huge page size with read_pmd_pagesize() for THP
and with default_huge_page_size() for HugeTLB.

Signed-off-by: Mike Rapoport (Microsoft) <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>
---
 tools/testing/selftests/mm/migration.c | 44 +++++++++++++++++++-------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 60e78bbfc0e3..e3c2f831e15a 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -184,22 +184,27 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
  */
 TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 {
+	unsigned long pmdsize;
 	uint64_t *ptr;
 	int i;
 
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
 
+	pmdsize = read_pmd_pagesize();
+	if (!pmdsize)
+		SKIP(return, "Reading PMD pagesize failed");
+
 	if (self-&gt;nthreads &lt; 2 || self-&gt;n1 &lt; 0 || self-&gt;n2 &lt; 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
-	ptr = mmap(NULL, 2*TWOMEG, PROT_READ | PROT_WRITE,
+	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
-	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
-	memset(ptr, 0xde, TWOMEG);
+	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
+	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
+	memset(ptr, 0xde, pmdsize);
 	for (i = 0; i &lt; self-&gt;nthreads - 1; i++)
 		if (pthread_create(&amp;self-&gt;threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
@@ -215,6 +220,7 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 
 TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 {
+	unsigned long pmdsize;
 	pid_t pid;
 	uint64_t *ptr;
 	int i;
@@ -222,17 +228,21 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
 
+	pmdsize = read_pmd_pagesize();
+	if (!pmdsize)
+		SKIP(return, "Reading PMD pagesize failed");
+
 	if (self-&gt;nthreads &lt; 2 || self-&gt;n1 &lt; 0 || self-&gt;n2 &lt; 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
-	ptr = mmap(NULL, 2 * TWOMEG, PROT_READ | PROT_WRITE,
+	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
-	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
+	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
+	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 
-	memset(ptr, 0xde, TWOMEG);
+	memset(ptr, 0xde, pmdsize);
 	for (i = 0; i &lt; self-&gt;nthreads - 1; i++) {
 		pid = fork();
 		if (!pid) {
@@ -256,17 +266,22 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
  */
 TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
 {
+	unsigned long hugepage_size;
 	uint64_t *ptr;
 	int i;
 
 	if (self-&gt;nthreads &lt; 2 || self-&gt;n1 &lt; 0 || self-&gt;n2 &lt; 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
-	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		SKIP(return, "Reading HugeTLB pagesize failed\n");
+
+	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	memset(ptr, 0xde, TWOMEG);
+	memset(ptr, 0xde, hugepage_size);
 	for (i = 0; i &lt; self-&gt;nthreads - 1; i++)
 		if (pthread_create(&amp;self-&gt;threads[i], NULL, access_mem, ptr))
 			perror("Couldn't create thread");
@@ -281,6 +296,7 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
  */
 TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 {
+	unsigned long hugepage_size;
 	pid_t pid;
 	uint64_t *ptr;
 	int i;
@@ -288,11 +304,15 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	if (self-&gt;nthreads &lt; 2 || self-&gt;n1 &lt; 0 || self-&gt;n2 &lt; 0)
 		SKIP(return, "Not enough threads or NUMA nodes available");
 
-	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		SKIP(return, "Reading HugeTLB pagesize failed\n");
+
+	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	memset(ptr, 0xde, TWOMEG);
+	memset(ptr, 0xde, hugepage_size);
 	for (i = 0; i &lt; self-&gt;nthreads - 1; i++) {
 		pid = fork();
 		if (!pid) {</pre>
    </blockquote>
    <p><font face="monospace">This patch looks good to me.<br>
        <br>
      </font></p>
    <p id="b"
style="overflow-wrap: anywhere; font-size: 13px; font-family: monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Reviewed by: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a></p>
    <p><font face="monospace">-Donet</font></p>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-4-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------uGaPtK1tzST1xWSar09lgc1I--


