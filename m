Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13CE2CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2CE8E0097; Tue, 26 Aug 2025 00:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA1A8E0090; Tue, 26 Aug 2025 00:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292318E0097; Tue, 26 Aug 2025 00:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 197E48E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:42:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91D0BBA6A4
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:42:07 +0000 (UTC)
X-FDA: 83817661494.17.EAF2A67
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3778580007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:42:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EoUWD10r;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756183325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBclHgm3Lh2ugPggIHKdCvQwK8vlkCTM0jbL6HwIUMg=;
	b=fZ8YIHD/+DuWFwW677QOi1wTNaTKvWzI2eY+n4bpSQLZTVCrWdbOQ0ByVUDRWpBopUk4qg
	nrK00/wQLAVCOTuYgRhPNZE/w9IsoN4R92hQRw6LRaszSy2lHmcc1XUIg49//YkoFbpXl0
	1335tbbFuntlL2+rZ3SmxWVD0sGIIRE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EoUWD10r;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756183325; a=rsa-sha256;
	cv=none;
	b=k7fukB+LmZWDTiUve4ggQzu+jvqQofEWd8nBGodaqi0F9jY81URslMT+sbn9zUNb7IjpzE
	r38G6fWgMEgd+5quwgS/wM57KuzkurUEhjzjkGZAc8+df7Ywt3ndGAnrOhdZtjxWO3JkeE
	YsIhBvVREs8dY9qmVWR5ic2kdIPUj5o=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PK25lq020934;
	Tue, 26 Aug 2025 04:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=vBclHgm3Lh2ugPggIHKdCvQwK8vlkC
	TM0jbL6HwIUMg=; b=EoUWD10rCQVfcO7zp+8y1TYjZe5YxqW3IyQdWIZJQfbFxD
	+mnWGs4HbkPtG/Yd9SxvN4kThu5ebHuTwPprIptNY/1NsmCWPOK8Wq06NLI93p3R
	9dWUwBuzrJg2DsGQxPy7RQHtEhw7idqWVDSMWEurTLkIOzC1zeMhtcAL/z0qQpCV
	CKZ/6hYEQJfJ3mGzryk5WvWoOCuXqXk53DKz3tecdTwMFjBbRNQHuHI7TagkSr4X
	Jr2O7YPbLlgWEJENxXGEQ3UPRzcnR4I0cSYMZDsLzPA2FX8gqn2slaL0Vczb1w3J
	zZ6rGmfy2fpw2yQz4C2Sv77m+bJRV9vg3p5TaPKQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5hpvcd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 04:42:00 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57Q4fCa4017181;
	Tue, 26 Aug 2025 04:41:59 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5hpvcd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 04:41:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q40HZo002571;
	Tue, 26 Aug 2025 04:41:58 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qt6m8vhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 04:41:58 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57Q4fwhd33161890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 04:41:58 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65FC15805C;
	Tue, 26 Aug 2025 04:41:58 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB3DC5805A;
	Tue, 26 Aug 2025 04:41:53 +0000 (GMT)
Received: from [9.109.215.183] (unknown [9.109.215.183])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Aug 2025 04:41:53 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------0Pt9yvGBJB9IQdTgHWdrEW2Z"
Message-ID: <a7ae6db9-6824-457c-9fbb-d978a5b5a6d7@linux.ibm.com>
Date: Tue, 26 Aug 2025 10:11:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: use calloc instead of malloc in
 pagemap_ioctl.c
To: I Viswanath <viswanathiyyappan@gmail.com>, shuah@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linux.dev
References: <20250825170643.63174-1-viswanathiyyappan@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250825170643.63174-1-viswanathiyyappan@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfXyyLX+8NRUs69
 zBijqgB4Zdm/RR/c/csVLAPH7k/XzgV8TjOFxkWB1hjAxucO2jk3duQAQ4ubA/DK67NkfxrM/nP
 CAfy4EWPTWEAkpveaY+A2pIQwsz0wVBgAwZqRvuaUSbJMbjCu0rRZMVIMRNB4S8P5DGRav/f54C
 6OgBCSO5a4CC+jdEQWixvLOZGsXDLvdk1dPPcl4pHi9eeB/Lxy1I51+mop10tnGj/Vp16+/Xs4L
 1JxBX3uq1QQMsHVI+Ag/ZXxm8AdKorVYQ3yURF+kh9XPmo3HZfwAeJeNovRgSpCN3zAk6VoCjXo
 DQURZ8+QAQg9JRQCGcB/Sfpjem2R3AooZoVwtwaat592h4gPTa3zF9sl47IZiWsfKpPROv7tvf4
 ravwxXYD
X-Proofpoint-ORIG-GUID: NdqCOYCUBbNe4cwRDmGk0di1ZgQkLnUm
X-Proofpoint-GUID: QpZp3f3QrtASxP8nHvDyTThdnvQ3HMNe
X-Authority-Analysis: v=2.4 cv=Ndbm13D4 c=1 sm=1 tr=0 ts=68ad3b18 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=2OwXVqhp2XgA:10 a=r77TgQKjGQsHNAKrUKIA:9 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=hee1B6cvo4V6AN4efcsA:9 a=QEXdDO2ut3YA:10 a=TeYISNXaxCOhQ5wGVeIA:9
 a=_DwDYS9el2z8XPNP:21 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_01,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3778580007
X-Stat-Signature: 3cx11z8g8wrku9qp839g5whxzgyz6xhf
X-Rspam-User: 
X-HE-Tag: 1756183325-761792
X-HE-Meta: U2FsdGVkX19ifjuT3RCZNKgMzHWwN8xb0ajMuF6YZLe/NROZnB4nFarV0jSGrv+TO8C4768SsUaP0QaGXhlQhn3nte5dcuDxE9BybN+DBHSIUKgqy0v3HdtVokDokw0b+HwOuMWb9EUiZcyqiZ3CbgjekR0FaKRNxR0+pRdHKSmSLoXvaAtMmw1If1Nc+cOL60/MRUHvt3VIZaoCNP5iLEKBQNntpK3XXD8elmj9peVqGV5glV635hBY0CEHvuKL2wAy6nm8UExYrhRBLaytOhDcjSPWA9Qck4U+Psq6C3IWH2HoGNwUQU1MUI49MsuaJbIlM1+PV2h5si/Z8Oay5E5cTytC7/cA12MdGLqxYOnB7U1MYHEj6KfpUnUPpkMlm9aDYANF9QyRQ8p3wF9PRXV+xf6DV/jA8K3tNf5DxvFWtaYfpso2Rs9rZBVxO8eJQ+/DbCFjcJI9U8E3rPJk9BsDWQYU/CsNimj5xC037U3KUlhGTAMu9GHvW82u+prH9TZ58HqVBZh4Si5upCflCU1AlkaFHPSZtzxI5VVswtSaIOam79eRPvxpNqYsAcWe/td2rebfw0Ni/rOPQHqo8Jzr2OkFCIz89vF32xz2OVhf1qPICUZNNf3MakcZyJH1kFsEE7163C5RBbvQkAKsLEhAP2Pprj2P9NilpHKxVao+69QYnzTptV2C0Hw1I46NC0NOF6OmJJbKMTQLMAVhm9KeA7rtvR6ZMLq/In2sXLzyEz2rtiUIAheA2PcQqb9gzPKPqRUXEOT8ARTLWWpiZD1X98QMAsTeDB/Q1rHi701oy0lTscirpSz1Iswg+iaD8KRP0LgCCGM3EbaVCJToaLNoNRVsdGUggUEtqn47FdsxYh7qXQjgrg8EKI+xguQL109aGwU/oScF99iBHgvg02Lejiwo1JwMpJV00rl8cTv3Hnrb+5tWowfjqzvvk228RmNO4RJocl7PeWa/pva
 P7hGd4NL
 6E5zaGFKwL4Nn4mIhzF8t3MbjHiaPv2F8L4xBKmCXBbA+PvSWnBs2cfigEG11tCI1+KKfMHAQnBrTJKnCK/hsie5lRUj9/GvehVlXtepE1xpdvmxmuCx0f1ERPd6zJyysE+9+EZ9CRqF3M1z+gSzxOgCh+JGeC+J7EM8f3vGfrFbarxon/x5PcgLuxVP4bDpN32YppsfVekuH9/J8UjlDzf3vbhlA/P9ZBvd1fCQt2xtoeMCtbpr7xSj1hPk4g2lC5FIUG1WPs5g2Su5WSPNaXJFtMDaoW0HpwmIIoRg3kJLxAGDqnhR7CO6L/0P34SdDHkadQDBHkXhCYQkaRB2qYzUhzcgx7a5FK6LeZ11bv5SJtQEHoba9Dm3aIjPwkiw941SNWWsFJVIPHnDqiuNJdz/nuS6w6TlzN8msczo+SmgQrcfIaUxnylmhg0a4yrSzrqhmgkWqKQnZbTl39fJoJPJG2wl4QaD8w2ZR/YIXLCX0mc+BmzlMwLH4HjM9UBiScnBeEgATxb+WzbUbbQ1TMIWfNwBwlxgTmLp0CZ+lu7ZkadZkISgzXwPykYlF33B44A+46PPhuGq3d831NAp72yprtQBFkn2HxD6T8dqjuuCWFKA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------0Pt9yvGBJB9IQdTgHWdrEW2Z
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/25/25 10:36 PM, I Viswanath wrote:
> As per Documentation/process/deprecated.rst, dynamic size calculations
> should not be performed in memory allocator arguments due to possible
> overflows.
>
> Replaced malloc with calloc to avoid open-ended arithmetic
> and prevent possible overflows.
>
> Signed-off-by: I Viswanath<viswanathiyyappan@gmail.com>


LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>


> ---
> Even though the arguments are small enough an overflow cannot happen,
> I think it's still better to follow kernel standard practices.
>
>   tools/testing/selftests/mm/pagemap_ioctl.c | 24 +++++++++++-----------
>   1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 0d4209eef0c3..4e6b815e96b2 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -209,7 +209,7 @@ int userfaultfd_tests(void)
>   	wp_addr_range(mem, mem_size);
>   
>   	vec_size = mem_size/page_size;
> -	vec = malloc(sizeof(struct page_region) * vec_size);
> +	vec = calloc(vec_size, sizeof(struct page_region));
>   
>   	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
>   				vec_size - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
> @@ -247,11 +247,11 @@ int sanity_tests_sd(void)
>   	vec_size = num_pages/2;
>   	mem_size = num_pages * page_size;
>   
> -	vec = malloc(sizeof(struct page_region) * vec_size);
> +	vec = calloc(vec_size, sizeof(struct page_region));
>   	if (!vec)
>   		ksft_exit_fail_msg("error nomem\n");
>   
> -	vec2 = malloc(sizeof(struct page_region) * vec_size);
> +	vec2 = calloc(vec_size, sizeof(struct page_region));
>   	if (!vec2)
>   		ksft_exit_fail_msg("error nomem\n");
>   
> @@ -436,7 +436,7 @@ int sanity_tests_sd(void)
>   	mem_size = 1050 * page_size;
>   	vec_size = mem_size/(page_size*2);
>   
> -	vec = malloc(sizeof(struct page_region) * vec_size);
> +	vec = calloc(vec_size, sizeof(struct page_region));
>   	if (!vec)
>   		ksft_exit_fail_msg("error nomem\n");
>   
> @@ -491,7 +491,7 @@ int sanity_tests_sd(void)
>   	mem_size = 10000 * page_size;
>   	vec_size = 50;
>   
> -	vec = malloc(sizeof(struct page_region) * vec_size);
> +	vec = calloc(vec_size, sizeof(struct page_region));
>   	if (!vec)
>   		ksft_exit_fail_msg("error nomem\n");
>   
> @@ -541,7 +541,7 @@ int sanity_tests_sd(void)
>   	vec_size = 1000;
>   	mem_size = vec_size * page_size;
>   
> -	vec = malloc(sizeof(struct page_region) * vec_size);
> +	vec = calloc(vec_size, sizeof(struct page_region));
>   	if (!vec)
>   		ksft_exit_fail_msg("error nomem\n");
>   
> @@ -695,8 +695,8 @@ int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
>   	}
>   
>   	vec_size = mem_size/page_size;
> -	vec = malloc(sizeof(struct page_region) * vec_size);
> -	vec2 = malloc(sizeof(struct page_region) * vec_size);
> +	vec = calloc(vec_size, sizeof(struct page_region));
> +	vec2 = calloc(vec_size, sizeof(struct page_region));
>   
>   	/* 1. all new pages must be not be written (dirty) */
>   	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
> @@ -807,8 +807,8 @@ int hpage_unit_tests(void)
>   	unsigned long long vec_size = map_size/page_size;
>   	struct page_region *vec, *vec2;
>   
> -	vec = malloc(sizeof(struct page_region) * vec_size);
> -	vec2 = malloc(sizeof(struct page_region) * vec_size);
> +	vec = calloc(vec_size, sizeof(struct page_region));
> +	vec2 = calloc(vec_size, sizeof(struct page_region));
>   	if (!vec || !vec2)
>   		ksft_exit_fail_msg("malloc failed\n");
>   
> @@ -997,7 +997,7 @@ int unmapped_region_tests(void)
>   	void *start = (void *)0x10000000;
>   	int written, len = 0x00040000;
>   	long vec_size = len / page_size;
> -	struct page_region *vec = malloc(sizeof(struct page_region) * vec_size);
> +	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
>   
>   	/* 1. Get written pages */
>   	written = pagemap_ioctl(start, len, vec, vec_size, 0, 0,
> @@ -1062,7 +1062,7 @@ int sanity_tests(void)
>   	mem_size = 10 * page_size;
>   	vec_size = mem_size / page_size;
>   
> -	vec = malloc(sizeof(struct page_region) * vec_size);
> +	vec = calloc(vec_size, sizeof(struct page_region));
>   	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
>   	if (mem == MAP_FAILED || vec == MAP_FAILED)
>   		ksft_exit_fail_msg("error nomem\n");
--------------0Pt9yvGBJB9IQdTgHWdrEW2Z
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
    <div class="moz-cite-prefix">On 8/25/25 10:36 PM, I Viswanath wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20250825170643.63174-1-viswanathiyyappan@gmail.com">
      <pre wrap="" class="moz-quote-pre">As per Documentation/process/deprecated.rst, dynamic size calculations
should not be performed in memory allocator arguments due to possible
overflows.

Replaced malloc with calloc to avoid open-ended arithmetic
and prevent possible overflows.

Signed-off-by: I Viswanath <a class="moz-txt-link-rfc2396E" href="mailto:viswanathiyyappan@gmail.com">&lt;viswanathiyyappan@gmail.com&gt;</a></pre>
    </blockquote>
    <p><br>
    </p>
    <p>LGTM<br>
      <br>
      Reviewed by: <span style="white-space: pre-wrap"> Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a></span></p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20250825170643.63174-1-viswanathiyyappan@gmail.com">
      <pre wrap="" class="moz-quote-pre">
---
Even though the arguments are small enough an overflow cannot happen,
I think it's still better to follow kernel standard practices.

 tools/testing/selftests/mm/pagemap_ioctl.c | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 0d4209eef0c3..4e6b815e96b2 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -209,7 +209,7 @@ int userfaultfd_tests(void)
 	wp_addr_range(mem, mem_size);
 
 	vec_size = mem_size/page_size;
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 				vec_size - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
@@ -247,11 +247,11 @@ int sanity_tests_sd(void)
 	vec_size = num_pages/2;
 	mem_size = num_pages * page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 	if (!vec2)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -436,7 +436,7 @@ int sanity_tests_sd(void)
 	mem_size = 1050 * page_size;
 	vec_size = mem_size/(page_size*2);
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -491,7 +491,7 @@ int sanity_tests_sd(void)
 	mem_size = 10000 * page_size;
 	vec_size = 50;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -541,7 +541,7 @@ int sanity_tests_sd(void)
 	vec_size = 1000;
 	mem_size = vec_size * page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	if (!vec)
 		ksft_exit_fail_msg("error nomem\n");
 
@@ -695,8 +695,8 @@ int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
 	}
 
 	vec_size = mem_size/page_size;
-	vec = malloc(sizeof(struct page_region) * vec_size);
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 
 	/* 1. all new pages must be not be written (dirty) */
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -807,8 +807,8 @@ int hpage_unit_tests(void)
 	unsigned long long vec_size = map_size/page_size;
 	struct page_region *vec, *vec2;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
-	vec2 = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
+	vec2 = calloc(vec_size, sizeof(struct page_region));
 	if (!vec || !vec2)
 		ksft_exit_fail_msg("malloc failed\n");
 
@@ -997,7 +997,7 @@ int unmapped_region_tests(void)
 	void *start = (void *)0x10000000;
 	int written, len = 0x00040000;
 	long vec_size = len / page_size;
-	struct page_region *vec = malloc(sizeof(struct page_region) * vec_size);
+	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
 
 	/* 1. Get written pages */
 	written = pagemap_ioctl(start, len, vec, vec_size, 0, 0,
@@ -1062,7 +1062,7 @@ int sanity_tests(void)
 	mem_size = 10 * page_size;
 	vec_size = mem_size / page_size;
 
-	vec = malloc(sizeof(struct page_region) * vec_size);
+	vec = calloc(vec_size, sizeof(struct page_region));
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
 	if (mem == MAP_FAILED || vec == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem\n");
</pre>
    </blockquote>
  </body>
</html>

--------------0Pt9yvGBJB9IQdTgHWdrEW2Z--


