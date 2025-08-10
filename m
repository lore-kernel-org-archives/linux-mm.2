Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A54C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 16:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FA88E0007; Sun, 10 Aug 2025 12:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666F08E0006; Sun, 10 Aug 2025 12:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CE78E0007; Sun, 10 Aug 2025 12:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 440F18E0006
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:55:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9ACF59610
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:55:54 +0000 (UTC)
X-FDA: 83761449828.03.49FBDD6
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8397A20002
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:55:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Wr2Gi8Xa;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754844952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5cZnIAl7D6khCXJ9qDCiBDoxcLSRZ68O/xsxu5WVXs=;
	b=yD4VmhKH7VrqMLpMs30xPkeFb3mAliwZkwmJTGrEU/9h7vSrIm8Zatg6m2TZy4SUghZAnI
	OvS5Z7ySHVlwFWukDEdrkDxCekFMC0JATLuQZJKiC9ZBR1+XSaqcp0QBvGs5BU7lRCUHxo
	C0Faqj5DnZtToYAoyWxtnb4W86l2Hxg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Wr2Gi8Xa;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754844952; a=rsa-sha256;
	cv=none;
	b=g47q4TnUC109Z/atIjuFM8dbj59KwTU1kOhoS24e+0LI8es45RXuZz9rPN/Ve9fTe8Y3rF
	RBBHpL4fDJB5hyAE2zslms2XTWi61PcRFljLn0stbrCS/Zsg5FojkC07uahaWlgctbwguk
	SpLqNx8gzt1aV4HP8rHJPUnD8NkoOrA=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57A5aP0L017895;
	Sun, 10 Aug 2025 16:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Z5cZnI
	Al7D6khCXJ9qDCiBDoxcLSRZ68O/xsxu5WVXs=; b=Wr2Gi8XaMNGJ8plXxxshPT
	a43X5+p/bqv9p/baEwchlvzStyPITPamfpjnJjYv56Ise4heBUcyq0cLx4+hLHbk
	qL0lAhSIyaez82pmUlfWyKQEjB2Sub5q+BgCMNZeQRdGMqRP75r4D7sq7yAxklrE
	TSJ08wtvMSeuzY67r2En2krcNhzmd00a8WxTdBMfC5UF9ZRDvUHgl4QciKPzRJrf
	xUyDrXk81JtncW5K+qhZJYFon+tGUVFTsLpYmFS0qlTmgJQONCtKmWZousItZOwB
	3xnNy5bwunQ9Fdamw+B/fxsPfVAPAIWIBNYX7JQXGRvcliVmuTCDTqm8xYYfp4vw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrnnu18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:55:47 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57AGrcXU013512;
	Sun, 10 Aug 2025 16:55:46 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dvrnnu16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:55:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57AEi5Q0017588;
	Sun, 10 Aug 2025 16:55:45 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ekc3a6jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:55:45 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57AGtj9l32506432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Aug 2025 16:55:45 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19ED958045;
	Sun, 10 Aug 2025 16:55:45 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE17158056;
	Sun, 10 Aug 2025 16:55:36 +0000 (GMT)
Received: from [9.124.216.245] (unknown [9.124.216.245])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 10 Aug 2025 16:55:36 +0000 (GMT)
Message-ID: <24df1782-29de-4ae6-8ca1-560e1208442f@linux.ibm.com>
Date: Sun, 10 Aug 2025 22:25:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/huge_memory: add new_order and offset to
 split_huge_pages*() pr_debug.
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
 <20250808190144.797076-2-ziy@nvidia.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250808190144.797076-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEwMDEyMyBTYWx0ZWRfX0bo86AIEb9/h
 y5nqKcFnEgc/yCOp/tkSrPwadJ7vT7KOtZuhVL+xzmk3eGApWdHG49A9ea3KDLNWTbbIwLFV6Xs
 RI3kTIeb6sU8tVxVi8mTy4KKT4xIqNEV/CEQ0aWMSUomWVX+Vnlm1+M1boJ1c3hr//F1EkMxoNz
 uC7pdk1nD57cjftz3U5Fuxw28Y2tw2PoK905xhF9zmu5G6sReogZxVvG3YEhHEFn5ZLtEXtCp8C
 isMKcZOUYN5z8CSEDvcTLXcTgZwQVBnLhbKqZm6ZS+O4PSDQG0hSXnPrglWNFpVWzOuYr5tdMS+
 DUrEfYYziiAoYrDZQ5DqaDszKu02bPsjHCS2s8OgAJkrlrDdPhpjVFtqHRl43+XNAO/9ez6Hs5f
 hKpOK/1/2E26dMDNst3+8aT5PW4JsldHHA42LTLKGt/pIS8rFOSd2Gm+C1qQPo0GV1ACOQVQ
X-Authority-Analysis: v=2.4 cv=GrpC+l1C c=1 sm=1 tr=0 ts=6898cf13 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=PAhIe5FWX1Uh35W7_zUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: oDBoKho5lUfV8fWSHNW3-b74h_waRfUr
X-Proofpoint-ORIG-GUID: TQaPVa09PJpvjP4fXjwr5JGK8mJnWLjc
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
X-Rspamd-Queue-Id: 8397A20002
X-Rspamd-Server: rspam06
X-Stat-Signature: sbanbt3xirxxaqzgr8155kng1fsz9iut
X-HE-Tag: 1754844952-522869
X-HE-Meta: U2FsdGVkX1/otfARLxKDD0evkNw1GhfnEmfZSAvgwqBVrvw4NY5KUAaawAM5o0toWI3cIix847OvBp0F0/Wkfu0rFV/3baxuEO0D0GUMHbp7JLKb9sfN8SZ3oIAp2MaaT3UaXRU0YfpqV+DYxhC3H+bO14rssngvA4VtQIhy6LNY84FkgKCPtzcOOrc8AdBJYolDfgmG1SCSef8lVSMWjxtT7wAIee/qGREApbHlE36cqjCpC1UuwdyX3C7y6vBjevCOdEGH9NhtZ3qmZ8/78xP7g16j/ppEXVqJJjrIcvcwWpjM1/uevecBoEjqts7XSWZkS5WD9L1Xk/krdfbogRTKsPUA5JYO8vgnbQYIfoKbVOqj0qRmXVt/UJUIe1292hpDtideyM40cfF0u0fBUn+ECfyNo7CdUbfbTHp/mEFwMPr5hDAwyuBzZLDO//3gLiw9FTMxpxuGhvjks+hh6hyqJ0oeZoFokbJczV07AKAEpssQecc63KnUOXI8q76qldGwl5/vNVM7K/NI+aihUKmVPzXvMmDkFtxi4hivF4bayNBdLyZtqNYbtRZ3WIkFdz73Hq/5WZB1VaTsHctH7akrv5/uDaX2y0ZA3eHeD8sc8kLCdTKhEzDjXd/vFVFkKtB69tMM4lbO7r0JRX8GmNcL/wnahWoslLhZBDPnZdh0pHdt+9Wrxnc5sSqxzRk1ylt9xVzkJ8ZGN3rwe6S9cy/gNcBxD4XyqXBzcfLg5vqEVtSY87HewFO2/lbGOnHJkS/LnLcbbGX3+BFYjmlL6M0j1EaHfyIkP7q6VXLB8XSSCUrOUhFdQAaJKydSIHdRoCofZNVeMm2gGdf0TLZGu+1eaE1YQkVwgOj9Jyh1PwzDnnN+P0zWqs8D4FyK1DvhQ6h4hwljTI0FS7MYsYl7H9rWyx9eaCRoVeU1g7bdJslX6rRr/HpM5hea4lgNI8nKmnSuDK2VZap2kLuBSit
 mFEgNVxY
 +rbBMNOuabz8eKR9Mo/ALsOdE0ebKjSC5PgjuPfL4dzvnio8zTz04Z8dMDmecnQLjOtEDNizpsHhrKG9Cyz5ZC9G0NJzlec6yxSVvFmkIy1pIe2rnmKl36sSNtoWjtqPDb3RS+qRkx0YvNtA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/9/25 12:31 AM, Zi Yan wrote:
> They are useful information for debugging split huge page tests.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d..ebf875928bac 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4327,8 +4327,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>   		goto out;
>   	}
>   
> -	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
> -		 pid, vaddr_start, vaddr_end);
> +	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
> +		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
>   
>   	mmap_read_lock(mm);
>   	/*
> @@ -4438,8 +4438,8 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
>   	if (IS_ERR(candidate))
>   		goto out;
>   
> -	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx]\n",
> -		 file_path, off_start, off_end);
> +	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
> +		 file_path, off_start, off_end, new_order, in_folio_offset);
>   

LGTM

Reviewed by : Donet Tom <donettom@linux.ibm.com>

>   	mapping = candidate->f_mapping;
>   	min_order = mapping_min_folio_order(mapping);

