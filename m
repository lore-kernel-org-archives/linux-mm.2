Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600B1606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 06:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gTyrKRnm
Received: by kanga.kvack.org (Postfix)
	id 495166B05B2; Fri, 30 Oct 2026 02:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425B56B05B3; Fri, 30 Oct 2026 02:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9576B05B4; Fri, 30 Oct 2026 02:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0839C6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:46:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79FD812058D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:46:32 +0000 (UTC)
X-FDA: 85378359024.05.0135977
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13627140005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:46:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gTyrKRnm;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of pavrampu@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=pavrampu@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793342790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Id8QGQONeVdgPpx5xV+Lr+vBDN9+KhzWpQXCGhMj0Vs=;
	b=SV4N8Pz066QYLtHV88cdaXfDi+SzeYUVNfD53xWKS51TXLpAl8A+gvFsuGadG+eTnYQEFo
	qYLbgi0VrxYY9ivaHrhu5ESSCWyicAkdiCy6o527IzB70OX5EAaRWmFmOV6Yw7BzL24cf9
	yJUas4GgKgquJlZSwGs/IJrfI6twIXE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gTyrKRnm;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of pavrampu@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=pavrampu@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793342790;
	b=ECu/Gew5/KR2cuC3o58+NEH+Y6Qc/h+MJW2MohFZQ0YWcS2heoCCH/GPxZqGI5TmKyaTXL
	3aNimOgNEmX6BR+9nmGoHBm4LNqeuNcbMqqSgfSkYoZkXKD42c3VHxaV112KgW1gM7jHCL
	tT48zrXasPO5Qi96eydROO4xQuIdRqQ=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U5EOhF865528;
	Fri, 30 Oct 2026 06:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Id8QGQ
	ONeVdgPpx5xV+Lr+vBDN9+KhzWpQXCGhMj0Vs=; b=gTyrKRnmpTiLND7XEfHqOo
	TyTRYgZkDeKdKW7lXz7o/p0qDHu5pM67VvggXUAAJrj2abE/yxHM2++l5jqR5Zjo
	jYI9wt4g6YUBQDKPUJXbFSiJD/bYnIhjoSS42d5t2tPiKsFYgfhqQLgTmimUgQ/M
	admhuQY6/I1iH1ak1paNmhbrMyuVl2PPS49K257r+3dMnHs3ques1xCS+x/3SAxV
	NYMcdVhjRjqQ+WQBnkTG5TWXATqyUoHizXTnvct4Kl5JiAVhCSMXnZKJAbt+w3qa
	R0ZEsjrCvP7MUTD6vd/GRU8BoYu74nr1TJVmzJPCfMhiR+dcUFi4eA8oU6+HhDyA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hmeaysea6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 06:46:27 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69U5YuEt070120;
	Fri, 30 Oct 2026 06:46:26 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hk55pja9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 06:46:26 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69U6kPfY64881096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Oct 2026 06:46:25 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DB2058059;
	Fri, 30 Oct 2026 06:46:25 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A48658066;
	Fri, 30 Oct 2026 06:46:24 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 30 Oct 2026 06:46:24 +0000 (GMT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 12:16:23 +0530
From: pavrampu <pavrampu@linux.ibm.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Madhavan
 Srinivasan <maddy@linux.ibm.com>,
        Venkat Rao Bagalkote
 <venkat88@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        David Hildenbrand <david@kernel.org>,
        Muchun
 Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang
 <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCHv2] mm/huge_memory: set the mmu_gather page size in
 zap_huge_pud()
In-Reply-To: <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
References: <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
Message-ID: <7628b0e9814084298ae09abad0b5ac6f@linux.ibm.com>
X-Sender: pavrampu@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: gGY-rwakIoXDooIUogKTtF0LgTnN6YSW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAyNiBTYWx0ZWRfX+v3beX+bO7UL
 mShVCHmwjlOQIjARv+1JbU3Q8Y1xvq0pMQT05BUwMWkXdzdlJKXsCY/AOhpKmPFObyv0M6c1ses
 0oVfTAzc2+iz0u++74zLyDwkr2SKLb7D7MaTQtbXsgbGeDCJ5/7CfbacZu3gn+JUNfWddwTP4fg
 PMw5VXqfuBg8NZJB/7xq5CTSz+oTUY4jP3o5UCiCoZVSX6NIc/efmWWApyMV0zRSK9dN/553MXE
 9vsHKG9ukEeV37Byi6GpmQgzxy3Ta7PZCYokQlkbUomoPKeVwc4pLl+48Ya5usoqvVdj4g40s0w
 mhuxmBo1fnwqD5Sz3oXUT9F90sFd5xGMmznYwWrX0X1dRNSKFhq5A6JZouiBqUSGFiiutFb2oLH
 ljWjOZjti+EkPQqITh2hmqnTBWK7hXcPLD4aJEdUsKayn5IHYg85CCxpq7PvHiJZ6effWCo0xmz
 tGz2bimsFA+/vBpsv7w==
X-Authority-Analysis: v=2.4 cv=Ms3HeGae c=1 sm=1 tr=0 ts=6ae43d43 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=968KyxNXAAAA:8 a=VnNF1IyMAAAA:8 a=T-xRWpmrxNWT4oxTfLkA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAyNiBTYWx0ZWRfXxTRjLDtP7dbK
 BzDxsU5s4ReIcrhMajyytxMyJd4MMBJUQfrS2urnaeXd4zDxCZ6BDzFTcjsaLlwUpP16WtN05iw
 HG5FsK3w2dhcX4LOwYLqoDC5endnV/Q=
X-Proofpoint-ORIG-GUID: nuh1h1ZEP6xnxA7x_sHTi-kj9tjJC_4t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300026
X-Rspamd-Queue-Id: 13627140005
X-Stat-Signature: yw87wpkrq18uzk3rfdm48rpmrpixs58g
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793342789-582016
X-HE-Meta: U2FsdGVkX1+SL7HfO6NQiIlCOHFgB8VQr74/tLApW+hMFCzJPXL195IOhyr9ZwjgHkm+NhDJ14JH0h128zV39o1b3W06TLmLmas7koBAGfHqxUXkLss9oTliWKpwWNFHcAvp/VadKNjTAQCKtFttASAkDe7gbfoDeQYJEuzA7TJD6yjxYBWQqHbnfodTDaKVHDYNZ09stolYH7zvnMwJ6v7I+IzFwfbCBd+5eIeIX/Mor6Vd99CxxzrulFcNypxJ+twZS2GNZjng3A8YloPn4qmYvY/yazSBr/rpgufCV6i/pjeDZhyewOgCuV3z4IhcEwFHabWnUQfbC1C8EpdZ6csV2V2Mw56Nc9NKqRnUFWjugq4BD/MOkodhRSy6gJ0vSflp0Ix9FT0Qt1xOT/fDJbrbXYb8z+SQUBdoJl0fyKkA/9JvT4qL1fpLGZrGh1+P/0RZtqxcWshdqpMAYSgtiWPOex76vS+blLGXfRvMxXd0K2rNBFjiYnA4L8LVLMPyQ7M2RwdeDxGjQouuNJt5+hljsiXrsY6DtNJ7MFvppcY/rm8NTtwZklRTx/oQ73oNzKL2y8S2mzy66yJ/IhHCr7BCbn99u3r60cuXh5fcTgQoURKOZ0T1n/44+9f0T0BDSD9FQy9g6LqdKrV7PnXBB2KXE0yOnkwVwSmdOjFuLlg3ZYSk9kVjr1Q7p2JgeoY+Wj2YTthRmQR5VMFztB95ay5X6cp1aCAiJEK3RslJJw9j2yChP3JqYZ4Pis/PrxBXZkZJxjNo6hQPbHTpRWYSyXh7gfY0sWaWID83/QONx0NBOiqcEIkMgG36WZWM4Bp4eS4oC0lXvfhBrO2pnz6rPnSeHEyNsR1UFODdhS9fZ2dMawgYQgYFf+WDXx+ga4IPSfhB0MpKLEghzb6W9kgrxJIAivwZVddGiw0SNI8PgnFrgQ10SvCd4s9IkViMSIkyFQjhQ9M5kqbvwtsOToD
 jqwr1NKZ
 0tXfrwRY0Sud0spWkBXDeFHWlATYMa3AMm09nGMkwXrgyo4dIlDpJIWPgiPRUt4KDhvj9ikHyVZgG/VOUALLApojofOl/de7E97hN2KgZK2i09wxGlNm766UtXy8BrjFAJIDnuDesMsst8ZrJGJNLjYzU+Hd1YdTJem4DRA8pPbtZX+W8gsCFKANgVsy3rA1VV5xxnvzKnFjRNl49EhCATXkVTFz35VEWZvza8mB7p0pC5cK/vElsNgPg10Za0Pb+xuD/yUSmj1bVk8a0K8TlERPMQzeprDFH1dCPjp6xhkndA9luWLegPkCKs+35l7tW+JcGZFSi8pw/8c/jgOXEOSxP4ggJAVts+tWW4x/rJ0HGOjtflXmHJ6RasTDLN3HzaEErnpPwLOklGcJpinrb1jdKL3P1ZmqYr2coaWj/kjROlX+Gtk09uCwtPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-30 05:37, Ritesh Harjani (IBM) wrote:
> Unmapping a device-dax mapping with 1G alignment on powerpc radix 
> kernel
> built with CONFIG_DEBUG_VM triggers this warning on every munmap:
> 
>     WARNING: mm/mmu_gather.c:176 at 
> __tlb_remove_folio_pages_size+0x38/0x230
>     NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
>     LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
>     Call Trace:
>      zap_huge_pud+0x170/0x2d0 (unreliable)
>      __zap_vma_range+0x1604/0x1e20
>      unmap_vmas+0xa0/0x1f0
>      unmap_region+0xb0/0x130
>      vms_complete_munmap_vmas+0x120/0x310
>      do_vmi_align_munmap+0x1ec/0x240
>      __vm_munmap+0x148/0x220
>      sys_munmap+0x28/0x40
> 
> To trigger this - it is enough to mmap() /dev/dax0.0, touch the first
> byte so that the whole 1G is mapped by a single PUD and then munmap()
> it.
> 
> PowerPC needs MMU_GATHER_PAGE_SIZE in which mmu_gather needs to record
> the page size for which tlb flush is needed. zap_huge_pmd(),
> zap_pte_range(), change_huge_pud() etc all do this already. However,
> since commit:
>   dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
> 
> a device-dax PUD maps a real folio and zap_huge_pud() now hands it to
> tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE). At that point
> tlb->page_size is still whatever the previous user left behind, which 
> is
> 0 for the fresh gather set up by munmap() and so the check fires.
> 
> Fix this in the same way like how other similar paths do.
> 
> Fixes: dbe54153296d0 ("mm/huge_memory: add vmf_insert_folio_pud()")
> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
> [v1]->v2:
> =========
> - Split the 2 part patch series. Patch-1 is now superseded by a 
> different patch
>   from Muchun which he already posted [2].
> - No difference in this patch from v1.
> 
> [v1]:
> https://lore.kernel.org/all/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com/
> [2]:
> https://lore.kernel.org/all/20261029063601.1961415-1-songmuchun@bytedance.com/
> 
>  mm/huge_memory.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bd44d58e8684..7e589a2fb02d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3040,6 +3040,8 @@ int zap_huge_pud(struct mmu_gather *tlb, struct
> vm_area_struct *vma,
>  	spinlock_t *ptl;
>  	pud_t orig_pud;
> 
> +	tlb_change_page_size(tlb, HPAGE_PUD_SIZE);
> +
>  	ptl = __pud_trans_huge_lock(pud, vma);
>  	if (!ptl)
>  		return 0;
> --
> 2.39.5

Tested on Power10 (ppc64le), kernel v7.3

Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>

