Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2E0F8FA90
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 15:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1065E6B0005; Tue, 21 Apr 2026 11:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7A36B0088; Tue, 21 Apr 2026 11:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE84F6B0089; Tue, 21 Apr 2026 11:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCAC46B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:25:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88D5713C4FA
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:25:46 +0000 (UTC)
X-FDA: 84682937892.21.0A89451
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id F13BC180009
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:25:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FAs2zFY+;
	spf=pass (imf24.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776785144; a=rsa-sha256;
	cv=none;
	b=WG1iRasEumjyUS+c1uP4i1iPxOhYk1m/+rOuWeVz4GvBIb2uu1b7b1ksH5mavz7CK/Ng4R
	KyStVgzvNo8lKZ6qwK9SnSpyf9zaObEQiiOwzMsRW0ytWE3ZENZYLfjF3UmVTeILwdItWa
	mvPlOXIXRPp+K721ccOQ0txGI5OBr5g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FAs2zFY+;
	spf=pass (imf24.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776785144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1X9HPUunIQebJ9dADNmZa8MGaML1kJb/aSg0TZlqss=;
	b=Pt5oCFZm1oD5klj0QVjzT4Sx6q9w9xKGPWAw9elif9Z241QV/NQPmtRe3rYPMbjjEofsQe
	3/RydtW6TlmyMelQisOBtETlm++W00668G6/QvfUfrThJZo0sUCUdlModhwYMu0W/jyXuu
	3QI485PeF0plMy2oojfcTxN5iA3X+5Y=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LCfPbw2037844;
	Tue, 21 Apr 2026 15:25:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=o1X9HP
	UunIQebJ9dADNmZa8MGaML1kJb/aSg0TZlqss=; b=FAs2zFY+seMt5J/wyEvwcX
	J3Qs8AwdungWDk3ceTc+T4bf52oCVAr6pcSg2BEuFhAbv4HC2tLuNgFyIeZr+QLJ
	TQnT55zXAcFJmtfxkeJgd9xLQ7/mincVEMir+evb5W0ea9ZUOidUn/zHK+wFDIrw
	JWAibdWC0syZd+iTkgK8zRTqTNZdMofijb/NY5ONihNSI6ZgTB1MKhkVyx2oWIdj
	w7uhA2JyL4Jw35Ss+CKEOwng6W5CIb4tItaeiB/gNH7sFF/2SJHfjwtX11FVuBpL
	VV7EEsGVHIcheQEGKsvOjuFDnwGhD3/gYNi2uhQRLoc+omR3VBZiXbtRYOTrN48w
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2h9m78b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 15:25:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63LFKWUP013111;
	Tue, 21 Apr 2026 15:25:16 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmnsh15y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 15:25:16 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63LFPGGU23069246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 15:25:16 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3635D5805A;
	Tue, 21 Apr 2026 15:25:16 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EA1258052;
	Tue, 21 Apr 2026 15:25:05 +0000 (GMT)
Received: from [9.124.216.216] (unknown [9.124.216.216])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Apr 2026 15:25:04 +0000 (GMT)
Message-ID: <24cd6a95-1304-4732-9273-43c73ea858b2@linux.ibm.com>
Date: Tue, 21 Apr 2026 20:55:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 2/5] mm: migrate: Add
 migrate_misplaced_folios_batch()
To: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
        mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
        raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
        sj@kernel.org, weixugc@google.com, willy@infradead.org,
        ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
        nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
        akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
        kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
        balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-3-bharata@amd.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260323095104.238982-3-bharata@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: qy8g05uTAlspSHaPFCbZfBJNS4O0FSOV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDE1MyBTYWx0ZWRfX2lvX/8LD+K4d
 RxWH048hje3Sxp6jwSK9U+ofRWqaJ2KqvssfLkKvBIcoAAZ6VbGYdw99UcNhpmsEaVY+sZZr/5B
 q+7CxLE9JpALKcgc6JJJq6/lzY4Ipp21AD3fCATiw9eoioquHyE+latF7yEUg5n0H5ufgNI950l
 rn9rjhI8y/1qf5pFhEOHe8AO3WO5TRiNN7Hjqc1qTz9sf3UJ7zX0zlTP2WhPHrHdMXKpeJA97DK
 dYkdenDIo/am88ssDl66h6YegxX+lVFVEs68hOu7ND3ECfimi54mnt6Nh4lCSFN5hOjO5OW07dj
 g/myM9Uag1o0CKslaiYKPUAikeZ63nbJLFvy7xHByWHq/krqUSTr52cZRNO8CJw/XzMkDj5NyV8
 kSqcgW5ckIm+kiAjPi1YmO99WmYnUeeJMwTIQPC70WCwyrfVpSAWV4md7GbeqoA5m7efu9Fx/LY
 lF1jCtdn5kuHhlbFu2Q==
X-Authority-Analysis: v=2.4 cv=XLYAjwhE c=1 sm=1 tr=0 ts=69e796de cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=tHa68p0SAAAA:8
 a=zd2uoN0lAAAA:8 a=3BaletrFva9TSh3rlm0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-GUID: nRk-v5W9kOPmZ-0ggMcpCYROJyC80wZF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604210153
X-Rspamd-Queue-Id: F13BC180009
X-Stat-Signature: jb5tro47zeiah6z3msnbj38wi4g7yhqu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776785143-172820
X-HE-Meta: U2FsdGVkX18H3L1mY6D+GZdJgzsdhVuucbJz5FOWqP1rrU0QS74/NN/M6sAE5ZzbnbtxoK3IBVNmsxBm9BAiULR+VoAGHjAbp5dVFWR143Ct5iTZPzK3Zy8se36t4eKrd4HMMLC735KPBc7DaQa1VxV8HHGp9wgGjJUDh7wc0jzAoxl0p1RYxaMmD9wmHKinXNUixShNLxtCP/SO37I2lnwG7dGxmufs7un0MGWSGJjazinf6SPHXSauy2eHTrYEo32EOJdwoqje04v8upt8XceA0B1Ji4c13Ffpe5KNlI28ekhQu7eg/DlE+Hr9OsCDGZu9/c1jYBly9P8oSXSbnXO5aFr3rkkKX0DKT0f9I4h1LGUZT+NB22+6j59fO3TVpUSRA3mrzddRImO3fgWC/sCo8jzoCcCzm6v4GulotFTYRcBRtc97Bo5lEdB8udeeoNi8gWaSBAUDjFO1wZB/wrZ6QyijjT6mB93+svZO4SBk5L1AWul76/xdFzS1MymZ4qUD1aR8c2djDgkpYZililS0szhugP43iMmTHe6R/sKICarmKCnSK7iLsnYKbci6viz9xMRodMFGmC6Rb/1XyhlY01RXdgT06zCeW+6e96LT94F/wWrpDdAjxid8dy7XVfjkM8YE846gRNw1m05gdDVQcbAYNDOneLhSmHCD5bUDmTIt60Qcs3gno8LTQ4Cl4x/+u4hFqzTGzRpfAq7itlGvkqgG8eFJnxefzIPeBW10ZWN5UkwlWTMa124ebhaG5LVB5J8dtCOVaQtompPywZzqwM5TXHwbtw/hU1Ac5rlkHNIfIMBbKNl2bWv5HusDx3m7z025rKNCKhkx+Kt9PwtWrNkzUNn1tsGGrCwS5zHHVkJxoWaE2fBoM+10Pwr0vlAvzHdd+NpaiOFkAb8xotIYGi7w9nMZgRSPOP4Dl0cywFcZ7nGUJ9pwghsJwC4fHGecf5ZUyEsjbKoVL3L
 g9FjEvn/
 QEpVitYgGxrQyNEegZm9fCfaPdO40h8mnlUkMbRlJ4ixQg6yO33W74ZSKBIZsybc0kcgt93PVUu6bKyL6M9EwiQjR9jaJFh1FowRg9X+6tGkQtCPMF1664uKSZ47Pro+uVaSF4ig8Nqkzwz8freaGRlGTgJx1VKmZzkoxv4i2sAMG0Gbii27G0XBNGywtKB0SsrCRplXsg5nTOQCNvU8+ZJMGeqWIIsWpbv4+MUQIOXqJ1XmPuYa9NbW1RGQhLxFLV4qYmNLrEIvMJ4YUAY5HL/SA59+Yi3Ro5PcBtabk7wOSSy1SbT2TdjOwN5QzMyKTOIf0+4+8q2b3BovabSKdHvyA1YIUB7Wv4MQCqkATOj3vndxD2XfJ/9PbB1y4xyr474cCmpo6das+8lR1Hl7C/3U4c01pnVULB6t7FLUWw+LUzr8UiLG5QsG5P0b31Jn+BvnmzoczOt0nokkyMN2doLjjmwod6HnUxWVw+kgNhRGbAnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Bharata

On 3/23/26 3:21 PM, Bharata B Rao wrote:
> From: Gregory Price <gourry@gourry.net>
>
> Tiered memory systems often require migrating multiple folios at once.
> Currently, migrate_misplaced_folio() handles only one folio per call,
> which is inefficient for batch operations. This patch introduces
> migrate_misplaced_folios_batch(), a batch variant that leverages
> migrate_pages() internally for improved performance.
>
> The caller must isolate folios beforehand using
> migrate_misplaced_folio_prepare(). On return, the folio list will be
> empty regardless of success or failure.
>
> This function will be used by pghot kmigrated thread.
>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> [Rewrote commit description]
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> ---
>   include/linux/migrate.h |  6 ++++++
>   mm/migrate.c            | 48 +++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 54 insertions(+)
>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index d5af2b7f577b..5c1e2691cec2 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -111,6 +111,7 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
>   int migrate_misplaced_folio_prepare(struct folio *folio,
>   		struct vm_area_struct *vma, int node);
>   int migrate_misplaced_folio(struct folio *folio, int node);
> +int migrate_misplaced_folios_batch(struct list_head *folio_list, int node);
>   #else
>   static inline int migrate_misplaced_folio_prepare(struct folio *folio,
>   		struct vm_area_struct *vma, int node)
> @@ -121,6 +122,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>   {
>   	return -EAGAIN; /* can't migrate now */
>   }
> +static inline int migrate_misplaced_folios_batch(struct list_head *folio_list,
> +						 int node)
> +{
> +	return -EAGAIN; /* can't migrate now */
> +}
>   #endif /* CONFIG_NUMA_BALANCING */
>   
>   #ifdef CONFIG_MIGRATION
> diff --git a/mm/migrate.c b/mm/migrate.c
> index a15184950e65..94daec0f49ef 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2751,5 +2751,53 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>   	BUG_ON(!list_empty(&migratepages));
>   	return nr_remaining ? -EAGAIN : 0;
>   }
> +
> +/**
> + * migrate_misplaced_folios_batch() - Batch variant of migrate_misplaced_folio
> + * Attempts to migrate a folio list to the specified destination.
> + * @folio_list: Isolated list of folios to be batch-migrated.
> + * @node: The NUMA node ID to where the folios should be migrated.
> + *
> + * Caller is expected to have isolated the folios by calling
> + * migrate_misplaced_folio_prepare(), which will result in an
> + * elevated reference count on the folio. All the isolated folios
> + * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
> + * stat can be attributed correctly to the memcg.
> + *
> + * This function will un-isolate the folios, drop the elevated reference
> + * and remove them from the list before returning. This is called
> + * only for batched promotion of hot pages from lower tier nodes.
> + *
> + * Return: 0 on success and -EAGAIN on failure or partial migration.
> + *         On return, @folio_list will be empty regardless of success/failure.
> + */
> +int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
> +{
> +	pg_data_t *pgdat = NODE_DATA(node);
> +	struct mem_cgroup *memcg = NULL;
> +	unsigned int nr_succeeded = 0;
> +	int nr_remaining;
> +
> +	if (!list_empty(folio_list)) {
>
We seem to proceed even when the list is empty. Should we instead return 
early in that case?

> +		struct folio *first = list_first_entry(folio_list, struct folio, lru);
> +		memcg = get_mem_cgroup_from_folio(first);


I had a small question—are we ensuring that a single list contains 
folios from the same memcg?


-Donet

> +	}
> +
> +	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
> +				     NULL, node, MIGRATE_ASYNC,
> +				     MR_NUMA_MISPLACED, &nr_succeeded);
> +	if (nr_remaining)
> +		putback_movable_pages(folio_list);
> +
> +	if (nr_succeeded) {
> +		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
> +		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
> +		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
> +	}
> +
> +	mem_cgroup_put(memcg);
> +	WARN_ON(!list_empty(folio_list));
> +	return nr_remaining ? -EAGAIN : 0;
> +}
>   #endif /* CONFIG_NUMA_BALANCING */
>   #endif /* CONFIG_NUMA */

