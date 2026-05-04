Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D558CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 18:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E606B6B0088; Mon,  4 May 2026 14:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E378F6B008A; Mon,  4 May 2026 14:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E2D6B008C; Mon,  4 May 2026 14:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C5C956B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 14:15:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 650A8120273
	for <linux-mm@kvack.org>; Mon,  4 May 2026 18:15:49 +0000 (UTC)
X-FDA: 84730540818.23.63D3BEE
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF488C0012
	for <linux-mm@kvack.org>; Mon,  4 May 2026 18:15:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NK209QFv;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777918547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7AxjbTHGPsMAyrsBsYDmRyehECKmp5QQoteG0VQ1/8=;
	b=czV8SHvcIp5cqv9rkrtzIFKSZurRBfoWd5QEMTBWU0zWnFaxlymLfjIJ6jrR3ag49WZf4G
	Onj9RyXQEjVi04FoeuVucuvrADNw01htogYj1U0fHudk6T70e+gO+Q5NphqhX7pnw3S75I
	LDuovLAUPCN0+glW7WhFYQXJJavTy9o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NK209QFv;
	spf=pass (imf22.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777918547; a=rsa-sha256;
	cv=none;
	b=xPIc6fFjk1QuRCh2MN04IKRC5KvWu36AMEGqhZOhuKgtB5w+D/7NeNJQDcStSKGq49Zd62
	XDkieonJHV1hI9IBDHrLzlx1s4WjnsX6gq8QaGx6Gy4Z7ffv4tSOeP+rlPXPvFEpFo9udW
	IwiIXv1vyxmFwxhyZr4MBxojcIhZsU0=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6448AWoY800514;
	Mon, 4 May 2026 18:14:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b7Axjb
	THGPsMAyrsBsYDmRyehECKmp5QQoteG0VQ1/8=; b=NK209QFvQZWW2zC6lk1vGd
	meDkkVnEu8o7rLoa8fFu3hUXa0u+bO12CeMYTy9jBfKdzLCm7USkSKA2RsCH+QpB
	t8bVsdDnhrFpI2zIndL/5WQHetxcuoXjVYQIxbhKANI0rR2Wvrx37fetWa8JEcH6
	bfW7QgGxwx9LRb/L2YQio8CZi3c40tBO60yF5+N0qI01BVxL49KlWYCj4rPyAZ5b
	bumLMDpSZwBylGW9oscbegk0nz3ssbJ9SjeXMnf1lfw04JOCWCHo8V25aP3XqZU5
	qtZ1S2a9WzuZ634BhKL+6quSfMpYEFOVAYeIhfIkOsqfWbd9wSJ6xNtf/EhssuYQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x4gay0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 18:14:45 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 644I9fkf010629;
	Mon, 4 May 2026 18:14:44 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y61u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 18:14:44 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 644IEi2V25953010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 18:14:44 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4FAA58050;
	Mon,  4 May 2026 18:14:43 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16FAD58045;
	Mon,  4 May 2026 18:14:29 +0000 (GMT)
Received: from [9.124.220.160] (unknown [9.124.220.160])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 18:14:28 +0000 (GMT)
Message-ID: <2fd0aca2-4be3-4cab-aee4-b513ba67103e@linux.ibm.com>
Date: Mon, 4 May 2026 23:44:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/7] mm: migrate: Add promote_misplaced_memcg_folios()
To: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
        mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
        raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
        sj@kernel.org, weixugc@google.com, willy@infradead.org,
        ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
        nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
        akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
        kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
        balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
References: <20260504060924.344313-1-bharata@amd.com>
 <20260504060924.344313-3-bharata@amd.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260504060924.344313-3-bharata@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDE2NSBTYWx0ZWRfX/VgNTDHHBrH0
 281rBH6NJxXY4gcaa7Z5sv5OU4g1v0/qMpRlfKyv1+4xoeA5mD2ajN2lXdrP3M7WxOPlraLcSxi
 G1eJ89nKe703hNy9FU69RinHJAJv/TXNOwsiGlD1jOLd3kI1uxhptVVra5bHQcHRoY4S3P0mmEB
 3uB58slE/RLvEXh5Qv92A7XwMPGP4tMCP03xCJOSb7Qc+nB8v9Vq3eht4Chu3v3xL9GIqBzqtAq
 lRNKKTPX+OiOramFdAcoMcmjeFwaYWSXq1CXdYCESRh85Yfnyj3C/gP2tvVsdIQYfAPbXByWiV5
 DTp8zeCdImyWeuOsqap5/8yLjiVE98cWT21d+lJ1damI0GChtzyrEvIySj7jXtNOcelBj3mQayG
 7udmdV7RImlvgDkBuwgkbzGqB2sdbhzIdo6Be7rZMLBYOoXNFsk1sc7oVnum638+WYre94hbvxi
 frhGAIKUywo7vN9RTvQ==
X-Proofpoint-ORIG-GUID: 3yiR4vJUqFV1fOrE47cL3UXTFk9ndbuv
X-Proofpoint-GUID: 23y5OMO7Gu22B1mOGFOOnu-TpK4dzDFg
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69f8e216 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=Sx_HE5-t1wAX4gnw_kYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_05,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040165
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF488C0012
X-Stat-Signature: z9cxkicqmwdshnggwwmshxnaw1rjhckf
X-HE-Tag: 1777918546-659254
X-HE-Meta: U2FsdGVkX1/Kvr1f6C/KYLKIDWR+3QmywRLWuVwpnPK6paNDDhHSY4zbMkW2LIydUiK/VLNXwOQpPxdYIpj3GP/hONQleOBO6lv9wE1oZAUcO/XxloVT8uqZXkTJAv1P6YftI5Y1TPOHWaCQCSveFnwgyPugmeuS2QJSVoUerNXLW0mNEg6WFcqokeCxIKl248MLJt2MgIgeRRCTHHJMBr+LLNmvA3rV1Qc+JLrbDVqhq5vO1bynLmlOYe5MlwvChS+JOGoN7pICwljwlC4IkeZBv/uFib3J3qQi+W1+OgnqiKuWLJoKLld696cUB9lQJmW8ZEPq9SRdsZmNBk1k1fqyml74tcOiNygGhHGBR/jV126/PSrFga+s3cgVe4DlOmfJnuA9VFDZP6c3L6oBh5q/me/trgjCwCEM67YOnDsLFFrfvBk9t8VO8KEUlh8h3yZSecubUEU2Mw+MYaNj2bgM/Wom/IX4qS43Bf3pUT0go3Ij5Jv4S/6cyVsfbT/qNSXg59VNNW3j/9ma4iyUNaKwVO7Mc3GlEeW638+o9kZxtwtzroB3syWkxE4UnoXMtl+8PaVlJuDAT6RRES049hS5/MoV1Pfu+07s9bIKBQ8jZysIy2eKWszBcggw/TrcxX+wp+oUGeYoKLctbAlNs8rFno11RdRdPE8aPpl8X57h3dUFrRTHfQc/L6mQebw5GoYVy2QPIl51SEtmnGF7zBH4Q2zAxVV6LgGhRIX9OCK3TvNMfHITfhW4BPFogUxXJLp6IR5mvB6jpyCdiTEcYqyDRw1PncMg2GzBbJbTquDQOFdYuej4/Dg6Ff7/fmFhvf/xA+9aVK/E7qJJaNnytFl7uwHp0SAJzMimkfThRcdQCWtW3yaKjLOir3cEYg7Zy9Lz9zAdJ55aJOmvLXXTwp/juG56tZzoW9+vwH6rD1axmJzf5s5Fj2zsy2BvUZz2fQ4YZm5PLO4VSl7UZP+
 2fEku9Bt
 OUQhCT8y9kJ4TtXXxblcr2us0K/+VTUkBxIvU39/bVAQYFq3vc32VhesuJfXfIBT4QVMV+5lvKLnMEc0KV8SQN9xCsFiLGNWjXMF7bYbeYtEwXwdMyhZudppv0CEcyQyb8m/V6KO/vRpbS3QxK4pouAORkxea1nofZo5nFAafoBYeumvoZiZKVYeIlTkfXCYNC3zNYyZ3e9iqvMMtB6JLrHZUvCIrRiDqJakx7/EncMJ9SBkdP3VSw+NqI2hQGH/XopokWWb2fUL10Vo/Jc1SAGC7IGS9MP7qlO/BRRfgJWRPSP6AOym0LPUQFqxWQn7eP8WHHdBIU7FwAKXPHRtC8ZnMSKp0ITI0BIDe5krRV4ktkOPUL838o4M/smEJhTpbMvLm0SAtEvxxb39ss19QWOHHOAdAmIbCqGXcKA507XrCL+JLhXBm0u2RLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bharata

On 5/4/26 11:39 AM, Bharata B Rao wrote:
> +int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
> +{
> +	struct mem_cgroup *memcg = NULL;
> +	unsigned int nr_succeeded = 0;
> +	struct folio *first;
> +	int nr_remaining;
> +
> +	if (list_empty(folio_list))
> +		return 0;
> +
> +	first = list_first_entry(folio_list, struct folio, lru);
> +#ifdef CONFIG_DEBUG_VM
> +	{
> +		struct folio *f;
> +		list_for_each_entry(f, folio_list, lru)
> +		VM_WARN_ON_ONCE(folio_memcg(f) != folio_memcg(first));


It looks like the indentation might be off here.


> +	}
> +#endif
> +	memcg = get_mem_cgroup_from_folio(first);
> +
> +	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
> +				     NULL, node, MIGRATE_ASYNC,
> +				     MR_NUMA_MISPLACED, &nr_succeeded);
> +	if (nr_remaining)
> +		putback_movable_pages(folio_list);
> +
> +	if (nr_succeeded) {
> +		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
> +		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
> +		mod_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(node)),
> +				 PGPROMOTE_SUCCESS, nr_succeeded);
> +	}
> +
> +	mem_cgroup_put(memcg);
> +	WARN_ON(!list_empty(folio_list));
> +	return nr_remaining ? -EAGAIN : 0;
> +}
>   #endif /* CONFIG_NUMA_BALANCING */

