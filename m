Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 116CA10A88F1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5341A6B0088; Thu, 26 Mar 2026 14:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4F86B0089; Thu, 26 Mar 2026 14:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D42B6B008A; Thu, 26 Mar 2026 14:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A99C6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:01:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9897BE301
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:01:30 +0000 (UTC)
X-FDA: 84588981540.21.E865605
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id CAC54A0024
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:01:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EBeFYv+j;
	spf=pass (imf25.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774548088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSUnD1397Zp9inDfLVskQJVGRWrzZd3vpYhC+uxeKwI=;
	b=VJea+iZ754jH5hiwpjSskXG8GwKs8lbiuFR8g2uvgq7/RyjOJh6xKNJep+ezMhNX0i8fpd
	F6gTV4EZCPCeJYEEdVll11Kulu9NWC/2NixsTN1Sji5fv6BWiFQc1dCMTxi5y5hFoP4cKc
	ZEsrKlRjfK+iscyKf93fq5KW8Zvjz6Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EBeFYv+j;
	spf=pass (imf25.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774548088; a=rsa-sha256;
	cv=none;
	b=s5FvjvMAX89R8p8y5ZoAEcNWSsp0IuKQJF3qXh7QWHA0/69WYnItCSLavUtH5ypJumZ0vC
	g72wQ20YDjgQ3VY1M6OoDwPaJ95KWFEaIqJvjXkslmVqjmLrUDl6JdZuxaX1t5x3oewOJq
	CNK14Su1/7wVHJqB65zBUrpA0tCzozM=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62Q685vW3481709;
	Thu, 26 Mar 2026 18:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qSUnD1
	397Zp9inDfLVskQJVGRWrzZd3vpYhC+uxeKwI=; b=EBeFYv+j/aODVnq9lrPG+8
	aNOZT5Bm/Ezk0JS3MdTI0H/lP7+pHbnVwUMlRA5C2WOTtjuq/uO9fsPlEiaMSR1U
	uMC4aU77pS63ldWAtbL98p0G36lqVUIG4oy+rVIQwpz0kgjYND8pNulejDrs+SyC
	qJs+o7k8g9+xbpwCELqd/D8N/lPwdel+qR7pWUkf72wE6NznXdwGEE70AMl+ZD8E
	3sYbK50hEpNPYPK+bUWuvY2h0FzdGNlC0J4UNLlvkJ5PEz4X+9Cty0cfDLo4SknD
	JlGpLFo/yfIeqQZSL6XVt+BstHeyyve7Gn19LIFEKulwvhWejMaMuFiqbOsE8ZnA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqpkcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 18:01:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62QGw9vJ004407;
	Thu, 26 Mar 2026 18:01:18 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d28c2buec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 18:01:18 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62QI1H0c13042414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 18:01:17 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC67058043;
	Thu, 26 Mar 2026 18:01:17 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93BE558055;
	Thu, 26 Mar 2026 18:01:13 +0000 (GMT)
Received: from [9.39.28.25] (unknown [9.39.28.25])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Mar 2026 18:01:13 +0000 (GMT)
Message-ID: <e6f03352-4f09-4238-a47a-6d4e84101a6c@linux.ibm.com>
Date: Thu, 26 Mar 2026 23:31:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] selftests/mm: skip uffd-wp-mremap if UFFD
 write-protect is unsupported
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1773305677.git.sayalip@linux.ibm.com>
 <ed23ff57a80881c9d087d22709862af40addf49b.1773305678.git.sayalip@linux.ibm.com>
 <457dddf1-04ec-4d1e-8640-b04997fac4f1@kernel.org>
 <0e9cea41-7c49-446a-b67b-256584960516@linux.ibm.com>
 <20260324165606.d75200ac0e5458a5ffb83d5d@linux-foundation.org>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <20260324165606.d75200ac0e5458a5ffb83d5d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: Wgdjz0iWAZ5Gq1bxAzv-z7Cif8__vkRg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDEyNyBTYWx0ZWRfXz7fQB5fcglC2
 y2SxH0yxzQZaQ1eeQnvSdKaa5MALDMceEq0+fjCDLfsKUVIv7kCQNETwTzkAzldnQiu9WJaMsrU
 8XEXbSdEUa9olxB/hGpFR01i8TtawRrDvSmJw1SU4ZbMSnePIMJdhQiznJKooVmx6o0INzPK91O
 euDSEoYCckKklrv1qf4D9vl33wHnmzJett7SpJshEWLjpFV4DdyQfpqJMxG63x8AFeTCgYGIc1n
 3LyS1Afg6iTqpLd6sM2erF9ayWujv2FVX/PROyoPeZyH8Sxwa4LxlfJiJC2pk9pRX52Zd4gLiQ+
 uBQxgFeJRvOfijdyUsubvOceiWJTMwW4FczLPcd6lCldLpUiV0tRWI28c4nLU8DNjIgACcLGFiM
 KB9tv+q9RGkdl9Va3dFFEegEBNHVyZTMe6wHeyjNMG9zahfv67Cpz3IIJjElFVz0++pMDfS3QHa
 smS66mFC8CO0DISw/ag==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c5746f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=YyDBODbz2JAAnCrYoEcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: sD7t1P8T7SXxYhdPnjCwUf4tl7Jf37vN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_03,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603260127
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CAC54A0024
X-Stat-Signature: uouan73qkzg7f88u49udjhqbn4fxcs5d
X-Rspam-User: 
X-HE-Tag: 1774548087-441099
X-HE-Meta: U2FsdGVkX1+BrWtgABwbx+JGYaKq9xg/UY5xFQeCFliuRDZSyNNxyMS5gdB/Rq+kpAP5HXnwjTtE9lb42Yy6CtK9jF46jNaZchKYjvTVQtXUX1Z2uNS7yOQO6hCb14VLTbGXuQ4kb9MVg/8Yk/rxOCIQHY9fyOyqjNslrphPuQaN8wUdBq199mGzjQ/zqJ7L+jiI6hwz3crcVwlkcEGwY/1BFaU0kaQlquhr2SY/oZ1hTl+s8PGAgQPFv3VNnxqvjuxFrK/TvDCw3+YQLK4dQ3COHiAsWhur6XQ5ViA03C9JBqL1WbrFeOB2xAnJ5FxxVjh3uXg+/T9bdIf5hsRyQ+IcVTHp1qu3uhcv+FnphPZDzOZbHKwUlU93HYcLNMis7KKKi+cvw5ha7vDXNkQwZe7eNbl7PnXTFVjEn7XWTBiIYhPeRyShGtWZdKY1vRZb3KjKQce6dHGw65hvulvZ3Q+KKKIPtk7oGJrZmuRjPlPyluLonD5zE2Dhz+A4AUxjPQhA6A9QEmGyCPx69lgQTXsHndhkKqzRpBaOjAldaCl0YHjzg3lT6IPU4OwB17fB1F3sRuzTao6Aqu7K+CE43ofZmpu+j6grFuvRhOM7If3VQnLWHQpWok8KLMBkz3DYiqZnn/oIK7Po0uAfkxFSXjowtRbNm4TmKk7p0r9GXnJNw6ksrobPAELzijKVaL94zOt/QmNrDDsWVA2jJxpxHOXIXFOK97zwsTunMxNUAUfSkvjHks7fJGNPJl4NLsoc2M7UjJ0poyeJ+VCIHpk7mwSLTKsnih19N3s7Biw/lqZzllROQVBb6EcttwBXaL9iLw9wbv7eFoVmz8NyMg0DtcAIv+ElINmcyVJNZZQVIMVym88eFaNz8wqHa0AWJ4xMRsBLG3kZYHoPJCciwyDBCZ1OFafjYtTNB6M8cJ+fttpNEuyKfqcrwTwTh80AsObz/DL3utDSMuJtEHTNii1
 Pxa3ebdZ
 En+Oe868smUwE2QhRbMTJg7XtUHchpuCrfvS6bqniAiloD7NApZqLiBy/Kz9iVa4c/52kwAhAhQDgr9+IhLUGbahbd7foY40ilPpL5cBba7hvo7Cb4TdOf7mh1l9BOxAIr8baTm2PNSrrBq9daXqtOHtj7Ro5uNFAcY0jOxiL0dwAFeXIFNwjz2cPXeXXdl5+LRM1sEjpIjJwa4ysPO+v/2PYKJ2aYqie99TuEA/D006rrYvbNJlLl2+daghpSXOm2RA8F2gYaCXI2+6h0Pklx53ohFXLJ6DlblJ6MZeSaUgLmFjczCJH0vtM1l9j/vh8UOwY9khrf05lFfqO1Yn0hVUDcH17TACchOfcS1VSttcMtHFrIeGFVAL12HlLsOPx5SpuTbkrKTst4KyS5W9bQCYJech+r7Vd6hFz+6sgu7S7wIJOnsusbslxgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 25/03/26 05:26, Andrew Morton wrote:
> On Fri, 13 Mar 2026 19:56:01 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:
>
>>> Because right now it reads as if it would be returning a bool.
>>>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>>
>> Thanks for the review. I'll rename it to
>> "check_uffd_wp_feature_supported()" in the next version.
> There was no next version.  I added this:
>
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix
> +++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -19,7 +19,7 @@ static size_t thpsizes[20];
>   static int nr_hugetlbsizes;
>   static size_t hugetlbsizes[10];
>   
> -static void uffd_wp_feature_supported(void)
> +static void check_uffd_wp_feature_supported(void)
>   {
>   	uint64_t features;
>   
> @@ -347,7 +347,7 @@ int main(int argc, char **argv)
>   	struct thp_settings settings;
>   	int i, j, plan = 0;
>   
> -	uffd_wp_feature_supported();
> +	check_uffd_wp_feature_supported();
>   
>   	pagesize = getpagesize();
>   	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
> _
>
Hi Andrew,
I have some updates to [PATCH v2 04/13] selftests/mm: fix cgroup task 
placement and tolerance in hugetlb_reparenting_test.sh, as Venkat 
reported failures with the current version.

Should I send a v3 of the full series, or just a fixup patch for 
hugetlb_reparenting_test.sh? Also, if you prefer a v3, should I include 
above fix for 
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported as 
well?

Thanks,
Sayali

