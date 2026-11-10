Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627D2606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NfCGhUWd
Received: by kanga.kvack.org (Postfix)
	id 6B2B26B05B8; Tue, 10 Nov 2026 12:17:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6632E6B05B9; Tue, 10 Nov 2026 12:17:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A506B05BA; Tue, 10 Nov 2026 12:17:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28B796B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:17:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B79021A0A28
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:17:52 +0000 (UTC)
X-FDA: 85419866784.27.88C961E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58B6614000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:17:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NfCGhUWd;
	spf=pass (imf09.hostedemail.com: domain of gerald.schaefer@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=gerald.schaefer@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794331070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34QYw2n+GlRTBEJeFEQ+DjmyCUzXKovo4AvPkqRFd88=;
	b=8UL3+Xok/UczZGoyFHWPG8bWK7j3mgeh37P77MvKnwLs+xtGXWo2Md8LGgmLLRjtJaU/gg
	2F6+fuGZ40Cvna06ILBlk1Qv8xIDZoqdFyza21zJ1cVzyZ2lV3z3cjv5z2OLR9aw9bwn7h
	8o3J1QO2VTEok6msh9qec/hZBXLZS00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794331070;
	b=Dp+ZK3ituMrr4v14hNzHgH+S4BrnH5ZB8MYfT3ykpxtDz41KV69P2F8Nk5USlJN7pDzPfR
	69B/IFEgdxVK404VNE8UWX+1VH5IYxnSzZ+cSsq06EYvAGScA13XOBvuB1DLqU26DT/ql+
	5uBdCjYnJ/2/aHHz88KpWgv4+yhYXwc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NfCGhUWd;
	spf=pass (imf09.hostedemail.com: domain of gerald.schaefer@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=gerald.schaefer@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAFEKvv2596191;
	Tue, 10 Nov 2026 17:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=34QYw2
	n+GlRTBEJeFEQ+DjmyCUzXKovo4AvPkqRFd88=; b=NfCGhUWdZTwtX3fY6/fnNq
	2EDJZIEkB592SOtuDgQsQl3pbC5oa7r5WQlV/k09jqN7dkem6I/QsV/UxbaILOHD
	ZyVemLBMb1LWi/Pa3fikdMQsQAKnYhgB9sEra83YWE9mt+ex17r+n2ndB1MexmfP
	RP98zI/7kDaRYLycYE90slZLQOaVyFUkLVGVWHM550DCQjMq1heDwgOKY9oP5hqy
	OLnHwrG7KwWASAgwOWRudyjRU+pUsuJEOwiUsM7Pqh2qTsycBieAqFYFG4zYApEb
	iq1EBEUpr6m3fHhfIZ6cngKk6w9+uZCBSTsimdDeSCPro9PT4DU3BDwvPIUFgtzQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hssdkp8th-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 17:17:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAF4uCM1880658;
	Tue, 10 Nov 2026 17:17:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hv332126v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 17:17:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AAHHCR933554746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Nov 2026 17:17:12 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 606B320043;
	Tue, 10 Nov 2026 17:17:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 789A420040;
	Tue, 10 Nov 2026 17:17:10 +0000 (GMT)
Received: from thinkpad-T15 (unknown [9.111.27.248])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 10 Nov 2026 17:17:10 +0000 (GMT)
Date: Tue, 10 Nov 2026 18:17:08 +0100
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
        chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
        linux-mm@kvack.org, chenhuacai@kernel.org,
        ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
        willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
        riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr,
        kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
        baolin.wang@linux.alibaba.com, Nico Pache
 <nico.pache@linux.dev>,
        "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
        Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
        linux-kernel@vger.kernel.org, nphamcs@gmail.com,
        shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
        luizcap@redhat.com, kernel-team@meta.com,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v9 06/32] s390: mm: add PMD swap-exclusive helpers
Message-ID: <20261110181708.1713b836@thinkpad-T15>
In-Reply-To: <20261105183940.2236717-7-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
	<20261105183940.2236717-7-usama.arif@linux.dev>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=POqaavqC c=1 sm=1 tr=0 ts=6af3519d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=4g41d8trx35e7M10UtoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA2OCBTYWx0ZWRfX1nyYYnc9Zf8D
 du45S4a7FrRkSUAtDI5KOSQkCeSLN7Dq5lGlGHiyOYcNoRKzMZ12WLAmCqRKYJytxdHGdBK+5/s
 q5W3D8T5Sjy5ZtmsKeK4DHmj0LGOB/LPQRiBmH65Kkw3VTPtyb8rfTnRoZ4wd5x1jwDsVZVD5tN
 IWulXnrZ6qf+EifdiDDzvCfZg0OvUCV8DDxgEAltllo2oibYbsD9AdBdvFWfcQA2cCTLVCljNi6
 PpfApjXSnds1TWNTsxtXmSeBNJnxM82ctqFLudVfIanF/G09qFPdhWwmjrrqWGOO1GgI5KTDhUM
 +KZPFwpBXiH+JEwNNrV0cuVmG8sGX28PJj6Ynpw+BnsStkJDu0MFVa3jfz3ynJERH2nYHOyIdiD
 AHcndrIogjpdztYsOlhCJ7jLdjgLg4uNtb3kBlOnQRcyKgKG6HMAvsGqV8ixdV0H6K65K0cxLAD
 ZzqRV4ri5mzlZQdZzEw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA2OCBTYWx0ZWRfX+QdIRFNLmalI
 +GtJJhShocEC12dtfgMuBqXcn6yA0+CEeWr9W0mhis45wuudu3V1VWLKMaD04NMEvcJ4rmyedw5
 hENC38dcFaU0mwtbLghTYC/IYDQKu2c=
X-Proofpoint-ORIG-GUID: chnieGMiAe7hH-KPCsz8GCzo2Y3VSnMa
X-Proofpoint-GUID: Q4vxBTk2HZYJiPc3lOJwR1sDo2ByQqUk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611100068
X-Stat-Signature: qc3zsbzokgjki37e8yxad9attzdyuuya
X-Rspamd-Queue-Id: 58B6614000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794331070-388448
X-HE-Meta: U2FsdGVkX190k4egRk/1BvSfm+o2tIqR0cnvN1wGARPQfxDJ/xQnR0FvKFvaYgdjF88VsqP2Yaw9NIWwgESBlhJ/EMdOEQRq5x220ygzEbZwfqCHmkvyG2KemrNgJWh28PRljWJbf/BPgRMw7Tyws7oehHfDhLSYPnkGgM1/jnL8nKHwGqpLo4dugaZZA1URINQrTh9nooVgffpfoEgaosX3dvk1laUStVFHa7YsLoxsPbWCYjSo++8kGqzFohupfVX71V6aealzM9Jh7fjqsdPz4m46cxSg79GioNN31ySKegUSt62ZI2ueUt9VwZv0UGWzu5No5NzmDBkHvkUS3DQHanyvQXjxi2JQ9kAVcSjAsDcHx98sJNGk9ne61vXr22IAzOASDloKn5mYzX6PWC4MSZQmK838yOYFfP6OMCz3htqWQrwviQ+cy6X4EInnN5HtIZHxkd2KddY6SOlnGe2q1gUJrtqP2sIrcRk8JCzvN8lpg2GAQ3BR3xsWzXqH+raLohRjvS/M1kAQfPnJzJLPgRf6URzUn0Mc+Seg22VYhoufwAGMhklwXRd/AB9/L+Yx8lFvVtlzymQcsVHUe/tnDyi5ta9IViLFl3ZFjTo33zINnLH4M9gOec9nHsuHlecQ0hS/R4IEp4fXrvkNOm9cJREcJPN37dkRllLyX9TAv9iJKD+fTrj/R+s5pBjcSmxHmLc7yDZ6S28yU+oN4YQxdispprrdqwDNxJPEVrlpUXPvvN64FuzWzFZMJxDK65wdvYFK9dSLF9UazjYT3V6eGTmlQAjjynaSVO5KfCf06qZsKGzYgBl9VlL4zvFoZTepUihtjLSHWrZ6GF/eh23CnYeyUgKV6dOu41XgqiXUQ/zwzifOPhSWxpsqsp8haHwNJ+YkD9DCm4LL9rfMFmE6ZQwwwSF+MJ3qTfs/gg55IXmxPps7HNx/J0R6wMIFBEYF4L4MlUrCIHVrelb
 VMu3RFky
 4+OgJ2ZHj2qoYArPtKa+HX6iz5SFU8P8P81b2FEV6GeYdAOjGaUN7YKzk3rpHRLQXoxGrCD20nar6VWS2ItOVppvVUCMHH6qq7Ycz1ZjXzXTj1srlL0S62XeiQ1ElyrJ73/a3LwwXeGKvjKme+QiA5S4swfJztjjI/Gr9rUjqygRBoCUn99w3EmZF0PYhGD2KzjeSRn4b0cib6+VaYiJOavIzp/9Xq3eL6kxU73XJQvdsPATnVKDLU0aRb72wNXVkZNGp3WUkiEq8zvjVI4qm1OxWMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu,  5 Nov 2026 10:38:50 -0800
Usama Arif <usama.arif@linux.dev> wrote:

> Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, which makes PG_anon_exclusive have to survive in a swap
> PMD and not just in a swap PTE.
> 
> s390 is the one architecture where a swap PMD is not a swap PTE in
> disguise: it is an RSTE with its own layout, converted to a fake PTE swap
> entry for the common code. Give it its own exclusive bit rather than
> borrowing the PTE-format macro, and document it in the RSTE swap layout,
> where bit 52 was listed as unused.
> 
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  arch/s390/include/asm/pgtable.h | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 2d5c2ab06de98..2c6b5205ee3bc 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -333,6 +333,7 @@ void setup_protection_map(void);
>  /* Common bits in region and segment table entries, for swap entries */
>  #define _RST_ENTRY_COMM		0x0010	/* Common-Region/Segment, marks swap entry */
>  #define _RST_ENTRY_INVALID	0x0020	/* invalid region/segment table entry */
> +#define _RST_ENTRY_SWP_EXCLUSIVE 0x0800	/* SW exclusive swap bit, see mk_swap_rste() */
>  
>  #define _CRST_ENTRIES	2048	/* number of region/segment table entries */
>  #define _PAGE_ENTRIES	256	/* number of page table entries	*/
> @@ -893,6 +894,21 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
>  }
>  
>  #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +	return pmd_val(pmd) & _RST_ENTRY_SWP_EXCLUSIVE;
> +}
> +
> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +	return set_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +	return clear_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
> +}
> +
>  #define pmd_swp_soft_dirty(pmd)		pmd_soft_dirty(pmd)
>  #define pmd_swp_mksoft_dirty(pmd)	pmd_mksoft_dirty(pmd)
>  #define pmd_swp_clear_soft_dirty(pmd)	pmd_clear_soft_dirty(pmd)
> @@ -1900,15 +1916,15 @@ static inline swp_entry_t __swp_entry(unsigned long type, unsigned long offset)
>   * Bits 59 and 63 are used to indicate the swap entry. Bit 58 marks the rste
>   * as invalid.
>   * A swap entry is indicated by bit pattern (rste & 0x011) == 0x010
> - * |			  offset			|Xtype |11TT|S0|
> + * |			  offset			|Etype |11TT|S0|
>   * |0000000000111111111122222222223333333333444444444455|555555|5566|66|
>   * |0123456789012345678901234567890123456789012345678901|234567|8901|23|
>   *
>   * Bits 0-51 store the offset.
> + * Bit 52 (E) is used to remember PG_anon_exclusive (_RST_ENTRY_SWP_EXCLUSIVE).
>   * Bits 53-57 store the type.
>   * Bit 62 (S) is used for softdirty tracking.
>   * Bits 60-61 (TT) indicate the table type: 0x01 for REGION3 and 0x00 for SEGMENT.
> - * Bit 52 (X) is unused.
>   */
>  
>  #define __SWP_OFFSET_MASK_RSTE	((1UL << 52) - 1)

Nice, you found the last free bit in s390 RST swap entry, and made good
use of it. Bit 52 would also be free in regular RST entries, but as far
as I remember from PTE SWP_EXCLUSIVE, this will only ever be checked or
set for swap entries, right? Otherwise we should also document and
reserve for regular RST entries, but it should be safe for now in any
case.

Also did some basic tests with your series on s390. Couldn't see an
increase in throughput yet, but my swap device was way too slow an a
bottleneck itself. Verified that thp_swpout_pmd counter was increased,
system runs stable, found no problems so far.

I think this series could give s390 some considerable benefit, besides
swap throughput, by saving the 256 IPTEs (PTE invalidations) for each
1MB THP that doesn't need to get split before unmap and swap out. This
could have a positive system-wide impact, not just for one guest.

Great job, thanks for the effort!

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Tested-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

