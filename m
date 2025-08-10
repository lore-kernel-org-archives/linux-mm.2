Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D088C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 16:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71F06B00BD; Sun, 10 Aug 2025 12:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49526B00BE; Sun, 10 Aug 2025 12:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38C56B00BF; Sun, 10 Aug 2025 12:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCC206B00BD
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:50:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 430415954A
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:50:15 +0000 (UTC)
X-FDA: 83761435590.06.BB901A6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E208180007
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 16:50:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hY98JF3b;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754844612; a=rsa-sha256;
	cv=none;
	b=1ZHZdXhMyHhOVoOqJa+v4BrW1lpNnKq2hZjkPtcU6SYYE8QC/jn/SRBvouEOVc/Wwf7M7a
	87zZSKfURk82XYGF8qKnqNwjGEM32m0sobk2KMEXte8wjKLONruTCGdeN1fN+9TyMGponP
	l03TE2ySruM7l/hG7X5G0yr3N215YoA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hY98JF3b;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754844612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnYQL5Yk1Pt2iFo15ApPacITklfJKgoKX7PfLbLJd9E=;
	b=MxUhpiCzL9wL1JeQxUll3GBzIa7HGUWQgVg0ng4zEjB4rg1iXiEer/VtNs7TTTF5bxXIPy
	AlpReHSgXyvU5APBxJmnCSPA+RWpH+0WaWm5wLBvyJ9+L4c2BuNjeyfSMAnrs5dvExfaXG
	yqIgB4XHC9yhg5ULsWoM4DaNcBeFoqs=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57AB0HnT022969;
	Sun, 10 Aug 2025 16:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rnYQL5
	Yk1Pt2iFo15ApPacITklfJKgoKX7PfLbLJd9E=; b=hY98JF3btHUjAgNeP71gQQ
	jwPkfT5O+Eln6iwS5228d0/B1um4IFdnf8TUo5maIDdlK2GBxTnHhQZYqAsVWdVJ
	jMomxX/euWxnY3h3RrruPlvuuU2/rkIG29vV2RB15q7GdIi7XXxVecVZuPGLmyEW
	18kZFtFityqTTedHBJ9yIokZ9pr+WzbkMUu+xhjMu2YpqX2XDkGqcmupg+Eka2Hz
	V+OyzmyzkvXvqSc869LmS70fSevuLhdai2VYd3pCsytquvRRB7W0hAdWUWEpmiuv
	YsdRlfy2SJyx++gpeoc8st3rZex+ayvuGapANnHaqWOog3PHh9/HVpdI3OUTLZHQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwucwv7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:50:06 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57AGo5CW006037;
	Sun, 10 Aug 2025 16:50:05 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwucwv7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:50:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57ACE2PW026279;
	Sun, 10 Aug 2025 16:50:04 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh20tn7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 16:50:04 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57AGo4j717433118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Aug 2025 16:50:04 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E5F658054;
	Sun, 10 Aug 2025 16:50:04 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C448B58045;
	Sun, 10 Aug 2025 16:49:55 +0000 (GMT)
Received: from [9.124.216.245] (unknown [9.124.216.245])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 10 Aug 2025 16:49:55 +0000 (GMT)
Message-ID: <f7cbe7ee-35e2-4659-ba52-62b6b932c192@linux.ibm.com>
Date: Sun, 10 Aug 2025 22:19:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] selftests/mm: add check_folio_orders() helper.
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
 <20250808190144.797076-3-ziy@nvidia.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250808190144.797076-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEwMDEyMSBTYWx0ZWRfX980C3vR34l7C
 GiYFFrGmMMlVp7LeFFWFqZli1+8xA8iMoQinM2vN9ibpbNx5SGeLcWq5u8ghCtnkoiPeCwNzVLx
 a/HnTDRZULVgiIUdxDbtUCFZecDh9JzkoSltN2+QEvYbLBrhrTCcY6x5pdO0+Ex3puLYUmAmRpC
 +Y/qYSA3OlqTeE5qKL64wtfQwtRW/pvFQFM8Jte9X1Xkg0f/kaNQ5fcI3OkTUGvRxOiipcqAnXt
 QuqkjQ7j5uIXlekZhKVXQXfY7GsPto5HLQAAvhCRx6JmZgsvsru33TQxVFGzeaKC8zNzVflqLWB
 VOAfAnjUO39kgGQMt/+uHg0CnlvwWNu5N7Puoyd0dkTSami+zPP+2UGSLTbPRVI4O+AsL0NuMbf
 4C0a/hJF4JQfS00ggIZGUEs+M5prrwgqbZkYEj8v1W2X2kqFURHcsjxxhEMsblPPgkoIhcid
X-Authority-Analysis: v=2.4 cv=d/31yQjE c=1 sm=1 tr=0 ts=6898cdbe cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=Ikd4Dj_1AAAA:8 a=h_jtaqhVJtM5NzTXNHYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: KzsxtGyBukxEBsUHg540cpkVSaTz4Z5y
X-Proofpoint-ORIG-GUID: mp0N7QTIOyH3pOhTMOtc60gqrVosNdqo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508100121
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E208180007
X-Stat-Signature: kz6u1nmtmb8b8ra9ou4fg8n3meqyzaua
X-HE-Tag: 1754844612-773767
X-HE-Meta: U2FsdGVkX18by8cILsbHH3NTBgV4MX5ewZyEoXl78fGLRgEtL498anANHL/lYm3hcArdhgIUnkpZLRBRGe3RoLJeaFLzOfgxV1xdcaq99bTGhCuZCgzPWApDvbjGrBuTqf6+PKMMn6n68L6E3LKwaTEUbBd7TXa6DNPlRYYvTE8tm+pY86jtUZ27RRcBh+9sr7X9FR3cwAwW3KmWtkfUw4kpsvLRWUA2Px51x+yMZhR4H+/qke0YGHDsBkoHf1N8hCGy8njpihn0+ryD7yJHffjLNHdlMnzDeLVgVzCzpEAvRLhz9GEI/xKz283xoWInjUPOyqVC/AAhJeEPr0L57IwTS0STu5PlFhy+ydQ8b3/TDlQaS0RpKHNTWpiQE6hs5FirX3aJYNz32rPeD37m/N0h6MXhHnE4jTD0dDR9RbJcPvOa5ZN8+nkz6GurrtYAN6fDKT37xVOsuhpyo7RhuMN1Q8lHvLj5YulLIYm1P9wXyVNBG5o/kWfNeKOCUY3PoxX4qyCc9MbuY5Vc0U5d4YNTCvCXB46Sq9MJy8qm5lzVLBrytJ6bWwFPn3kXhKLx55M5LoMfplh9yYYvxw8see+57HcGSEJv3EwM/b8aRgweBV3V2zyM8t6FoISMLabHLBMhIZnGjmL9kB5oYLMzm/YbJ7EnWOE8+3/QhKG9Xe8Ur4mzy0qZ6VkB9mLjAPx+5lx4C6fPF2NSmfZXADAmS+mJ7tClbN5rNtRXlWTkfYlZIp3PaHiXkZDoZ1PYd63v1arD/nIHCJfcC6/27K5T4bkaKvYBaNIpYPh2+XYVF8fk86FWwcmA6d2tkxHmVvGm2tk278NZ+TmGUv6U49yMax9YuwXyRsKRUEgHxkw4x6Ee40msRCKRqTByUMv2JOcCOQfKUqNx2zORQhl0ANVyTYdK7wxNDUYw63HDfbMBRpsPE3pgtwfXZ/MWMYi6lTOUFg/RUomY823H7wNkp6u
 8+sMcKrS
 RkYvuetMbmPWockBmNaCLRBaWF6C4LFxx8nmwQrRRCn4hWwZdcw411zNiKWoi9DrPM/61jxqrNPSr+VTKTpmmiHOSBUnTTaHDc+fVV+Pr7rPJLRyZWuavSl1wJofVQBPbLMlKXkcc4wQKa3NRslO84CnFmrekIktY6+f2karESRDxXhNPcwyHIlDsjhVNRZlyGvJHWPrBmLR5Wl4iURIllgzBRt7vN4alYkv15lQq766CA/w1X1IfdsDdfoq6f9mFbtGvQaE7hXoUP5N62SzIKX/IE0Y6cDdGRjl8DoJTTKFnpq+B4cVOg+f8qyYThvVjW++0E/0T7T5QAD0b94a0CUBzHRMnunUNEPPoVDtvuoOOf1qgN9evHqQ7yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/9/25 12:31 AM, Zi Yan wrote:
> The helper gathers an folio order statistics of folios within a virtual
> address range and checks it against a given order list. It aims to provide
> a more precise folio order check instead of just checking the existence of
> PMD folios.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   .../selftests/mm/split_huge_page_test.c       |   4 +-
>   tools/testing/selftests/mm/vm_util.c          | 133 ++++++++++++++++++
>   tools/testing/selftests/mm/vm_util.h          |   7 +
>   3 files changed, 141 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index cb364c5670c6..5ab488fab1cd 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -34,8 +34,6 @@ uint64_t pmd_pagesize;
>   #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
>   #define PATH_FMT "%s,0x%lx,0x%lx,%d"
>   
> -#define PFN_MASK     ((1UL<<55)-1)
> -#define KPF_THP      (1UL<<22)
>   #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>   
>   int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
> @@ -49,7 +47,7 @@ int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
>   
>   		if (kpageflags_file) {
>   			pread(kpageflags_file, &page_flags, sizeof(page_flags),
> -				(paddr & PFN_MASK) * sizeof(page_flags));
> +				PAGEMAP_PFN(paddr) * sizeof(page_flags));
>   
>   			return !!(page_flags & KPF_THP);
>   		}
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 6a239aa413e2..41d50b74b2f6 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -338,6 +338,139 @@ int detect_hugetlb_page_sizes(size_t sizes[], int max)
>   	return count;
>   }
>   
> +static int get_page_flags(char *vaddr, int pagemap_file, int kpageflags_file,
> +			  uint64_t *flags)
> +{
> +	unsigned long pfn;
> +	size_t count;
> +
> +	pfn = pagemap_get_pfn(pagemap_file, vaddr);
> +	/*
> +	 * Treat non-present page as a page without any flag, so that
> +	 * gather_folio_orders() just record the current folio order.
> +	 */
> +	if (pfn == -1UL) {
> +		*flags = 0;
> +		return 0;
> +	}
> +
> +	count = pread(kpageflags_file, flags, sizeof(*flags),
> +		      pfn * sizeof(*flags));
> +
> +	if (count != sizeof(*flags))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static int gather_folio_orders(char *vaddr_start, size_t len,
> +			       int pagemap_file, int kpageflags_file,
> +			       int orders[], int nr_orders)
> +{
> +	uint64_t page_flags = 0;
> +	int cur_order = -1;
> +	char *vaddr;
> +
> +	if (!pagemap_file || !kpageflags_file)
> +		return -1;
> +	if (nr_orders <= 0)
> +		return -1;
> +
> +	for (vaddr = vaddr_start; vaddr < vaddr_start + len; ) {
> +		char *next_folio_vaddr;
> +		int status;
> +
> +		if (get_page_flags(vaddr, pagemap_file, kpageflags_file, &page_flags))
> +			return -1;
> +
> +		/* all order-0 pages with possible false postive (non folio) */
> +		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
> +			orders[0]++;
> +			vaddr += psize();
> +			continue;
> +		}
> +
> +		/* skip non thp compound pages */
> +		if (!(page_flags & KPF_THP)) {
> +			vaddr += psize();
> +			continue;
> +		}
> +
> +		/* vpn points to part of a THP at this point */
> +		if (page_flags & KPF_COMPOUND_HEAD)
> +			cur_order = 1;
> +		else {
> +			/* not a head nor a tail in a THP? */
> +			if (!(page_flags & KPF_COMPOUND_TAIL))
> +				return -1;
> +			continue;

If KPF_COMPOUND_TAIL is set, do we use the same vaddr, or should we 
advance to the next vaddr before continuing?


> +		}
> +
> +		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
> +
> +		if (next_folio_vaddr >= vaddr_start + len)
> +			break;
> +
> +		while (!(status = get_page_flags(next_folio_vaddr, pagemap_file,
> +						 kpageflags_file,
> +						 &page_flags))) {
> +			/* next compound head page or order-0 page */
> +			if ((page_flags & KPF_COMPOUND_HEAD) ||
> +			    !(page_flags & (KPF_COMPOUND_HEAD |
> +			      KPF_COMPOUND_TAIL))) {
> +				if (cur_order < nr_orders) {
> +					orders[cur_order]++;
> +					cur_order = -1;
> +					vaddr = next_folio_vaddr;
> +				}
> +				break;
> +			}
> +
> +			/* not a head nor a tail in a THP? */
> +			if (!(page_flags & KPF_COMPOUND_TAIL))
> +				return -1;
> +
> +			cur_order++;
> +			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
> +		}
> +
> +		if (status)
> +			return status;
> +	}
> +	if (cur_order > 0 && cur_order < nr_orders)
> +		orders[cur_order]++;
> +	return 0;
> +}
> +
> +int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
> +			int kpageflags_file, int orders[], int nr_orders)
> +{
> +	int *vaddr_orders;
> +	int status;
> +	int i;
> +
> +	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
> +
> +	if (!vaddr_orders)
> +		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
> +
> +	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
> +	status = gather_folio_orders(vaddr_start, len, pagemap_file,
> +				     kpageflags_file, vaddr_orders, nr_orders);
> +	if (status)
> +		return status;
> +
> +	status = 0;
> +	for (i = 0; i < nr_orders; i++)
> +		if (vaddr_orders[i] != orders[i]) {
> +			ksft_print_msg("order %d: expected: %d got %d\n", i,
> +				       orders[i], vaddr_orders[i]);
> +			status = -1;
> +		}
> +
> +	return status;
> +}
> +
>   /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
>   int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>   			      bool miss, bool wp, bool minor, uint64_t *ioctls)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 1843ad48d32b..02e3f1e7065b 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -18,6 +18,11 @@
>   #define PM_SWAP                       BIT_ULL(62)
>   #define PM_PRESENT                    BIT_ULL(63)
>   
> +#define KPF_COMPOUND_HEAD             BIT_ULL(15)
> +#define KPF_COMPOUND_TAIL             BIT_ULL(16)
> +#define KPF_THP                       BIT_ULL(22)
> +
> +
>   /*
>    * Ignore the checkpatch warning, we must read from x but don't want to do
>    * anything with it in order to trigger a read page fault. We therefore must use
> @@ -85,6 +90,8 @@ bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
>   int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>   unsigned long default_huge_page_size(void);
>   int detect_hugetlb_page_sizes(size_t sizes[], int max);
> +int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
> +			int kpageflags_file, int orders[], int nr_orders);
>   
>   int uffd_register(int uffd, void *addr, uint64_t len,
>   		  bool miss, bool wp, bool minor);

