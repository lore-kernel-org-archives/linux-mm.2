Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899BCCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 08:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC7D6B011E; Fri,  8 May 2026 04:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD1A6B0120; Fri,  8 May 2026 04:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3866B0121; Fri,  8 May 2026 04:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAE846B011E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:34:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 454D4140766
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:34:50 +0000 (UTC)
X-FDA: 84743591940.20.AE63B7B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7887A0007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:34:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bwfXO99i;
	spf=pass (imf25.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778229288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/V0rwlVvP6N/7i96AXjq0iLslyPxp/phWPB7bqT10o=;
	b=VkdFptjwc5biDc6XUDPxMcYHkBp/IZepMhW6IztJmrABiyOJXupwD2os/VahynlIkHsCC5
	pRI+1zFBvp3i2IGC8coHeQwFBEe78nd0Ud+U0n/gqYJud/lJnsjx8cD+IZ8O71c3LwKF6S
	Muoiq964iVYRdJqjo1bpOdMPdeK4/D4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bwfXO99i;
	spf=pass (imf25.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778229288; a=rsa-sha256;
	cv=none;
	b=D+7x8759VoVo73n1ck8z7PgjbZX8a5/vpR8Y1/+wzEFrjJbe9nj6PEI2ZUM2w2tDwBrq64
	yfqNEB8cg5y4kWAUnAv5+EaJVA2knzcfWbPGEo0yEdxlgdiYIKaZfjhzX86E2FTiBYRRFg
	NVn0cpMdgjueRDlORlE0dnO6I1F+7Qw=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6481pWHJ001076;
	Fri, 8 May 2026 08:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Z/V0rwlVvP6N/7i96AXjq0iLslyPxp
	/phWPB7bqT10o=; b=bwfXO99iEar3BOwD8TaR0SCTpSwovDAMXOkZe34hWPPqAM
	jcWq9WyrxyWcrkSEVfy/Iqgo4zrF744RybexE5zPA8Vs/zOuFW6EJKAUeZCprWb0
	Zdv4Y0KP1tx/+K0RyaMcgwl7Y5I5mwtjKZBOE0feUQKMdL16pJnExp5GiKH4NGSs
	26GNedszCbsikeSgIQXx9tOa73oxWrXEwSdhsir6kTFYcelbEcrr7X9Y3irSppmD
	erw+LoTbjl5FEI/2vJ9xpGATDFGy8EATa4QJPPeTYlXGFDiA/4Kts9qHhF9B+Jgh
	AZ6atic3G/hvpVS5+0aU3x5fclaA6MRmMgc+9YBA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1trp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 08:34:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6488OWhe017462;
	Fri, 8 May 2026 08:34:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuywfgq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 08:34:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6488Yap129885106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 May 2026 08:34:36 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6FCE2004E;
	Fri,  8 May 2026 08:34:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E35A920043;
	Fri,  8 May 2026 08:34:35 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.36.7])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  8 May 2026 08:34:35 +0000 (GMT)
Date: Fri, 8 May 2026 10:34:34 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Oscar Salvador <osalvador@suse.de>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <af7d5142-261f-4521-8abd-39ef299916e2-agordeev@linux.ibm.com>
References: <20260504130434.2285053-1-agordeev@linux.ibm.com>
 <20260507093433.q5xybwumryxclnqy@master>
 <43815634-29d3-4fa4-b967-0e251ff32f73-agordeev@linux.ibm.com>
 <20260508010040.o7bypjnfceeqloeq@master>
 <4da2d354-808d-463e-ac85-5b1f3fd51618-agordeev@linux.ibm.com>
 <be6b10ac-7170-47df-b1fc-71098270c343@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be6b10ac-7170-47df-b1fc-71098270c343@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: yvYtRSDiaxp9bcv13EZwXbYOjcFwU-1e
X-Proofpoint-GUID: djMkVqanIwdlCx0yQ_e8h84ZNmHV7Z4I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDA4MSBTYWx0ZWRfXwVnf+ft5fQnZ
 qMIFYtPCvRKpMBCzIDhRvat2S1+thRIDPV73WUWLInXoJRbmVuCpYYVkPkjIgESAoio21p6tCKz
 Wvn+ecyK/z/OYMRfMYZP+QFnjA6gG/qM/YF33r+EzHMvBLlSiWgDRHYQogQX6x5DkX6nI0ECpc9
 xe8tGlW/b5uEVFQZYU26teaWxR7wpTIdmwP85+KrJhzhcIZo2pf2flOzXUvFlvb3C1nXzDkeQp6
 j3sj7+EqQ4K85S4PZAMJQDaArnPxr1N0/uFvtfO9XSY0g8Gaptx5JmJkKOZo3ooeBAQbUCfdil5
 xKphlii9onXYMwKDpWsNmSQLvCOdpUkxsLWfE36xLHZJxOBFEyxn/eGSMTJ+1eOPp4Blvc6kbXG
 L4nrfAmaGxj5w6rtahcRvcNOS/ky4rcXHaL/8Vlb6k0fg0GbH7KbwJtXtZrXjspXEMXKQIoyKMU
 SGsUhmHtJgMn8/0Kj+A==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69fda022 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=2aWb7pxy_uW5kUccelMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605080081
X-Rspam-User: 
X-Rspamd-Queue-Id: D7887A0007
X-Rspamd-Server: rspam06
X-Stat-Signature: ir9duahtqw55c9iuckqpzq5rzp8jj176
X-HE-Tag: 1778229287-901215
X-HE-Meta: U2FsdGVkX198IiixOXeWyKcXmWtHV4B1C9xA+1uLu/Bn9DKxl0eWM0tAHYRycz8AbJcDmeC4+vqG6sDvg2fpUQojNJkOVq7+kHJt8xJlBAKOEWRfQ0cYJxIeE2UyJnbt0F0ZsOvxvQXSvfMCk0jXpSBlbeDaEtcocyxRjSFj4yc7Et9fupbA7giYpEXkDg7+m+kgQrJ3O602bx8XHo2ksVl3EZWnEjLdbh71mBc2KHxtn/WIhfgE/lQ8kUn4UgYULsVv0gbUyuXZaLYk7hF9brTir6xT8EkBwO2wfDhlavH0lYTNzUj8O+THdl05udGieQsTRK+ZbdS1RE+hl7g4n2KZQljj3Grbdq6JfZvbSS5o7dr37+rEalh8tco0MZycwBBVoXW+fxs+t/QXS+SYgDMHx6YlGYkjepY5XevnrSTFu3rYfZ+kp3BBRmN9s57OGt3JekQogRJ46lPMF/M2lUFDVHw7CgEh0/WZWeE4cS7f4MowKL4oy+SSMhE5FZfIPA0GxZGKOihRkYYW3TJUvK9FpP7wLPhk4cbSHYjfFstRL1KQARuORfLu0vYIHjcgC3/i1sGhrlUen3tpnKnKLp+KSgEfTN7KOxmcy/GYl3kuwgaTezfY1o8m+gfbIUJrH9f78hCec3kgkmjvxQzuwx384v0U5HDzJeEedJXKR04HxVL8ZBfy8wi43kOaCVXPmLs/fqQDPeAwYbjj1Yn6lOBPRwiJlvS9jF8IVppWScpFu0laOGZvnSVf9HQSW8c5qGX7avpXzq8lB6smXJ6gqazWttXeeuKgJULdfa/sCuXxoJ+/ohVBwEXvd5VfNlK98ULlVImq4KpCF6I8d4gxbUlIBrxi+D7SrQ7rUwYKhyId3p9l6MZJpDSbjqqJzjWWqm/6S0hiB9wdLwPGlxHP5TLFeCytYiZDbErVmRZe7jRp13uI/yEp8NhoJdQBCZap9oRNInQ5dcIUCi8Rji3
 8BakM+S7
 v37O5jSZvvxYfnrDQ5NTb0Ngv6tvX+l++Uyjpvhwbq1ubCOMs03aK8AbZv0k5DIj2GJ4sUsN47mttXQZ7kuWKN4142T7pai+i7YeIW84lp08oB2KLRBQts5uemQ/C7wuC1PKM9yMaaNNVJGdwbg/S5nqwWtk4XyBnu3VvKoW7r+8yyPk6s0GboPF0A+wMN/mRHeMEOT1/l0gnEDtyrTsUeztSPcnLlIh1TTkPihUtmKvi38uHmrM8b+5Gs/iNm3thHjPsCBCR8ZWhiCGAB/ri40Ch+jkAB6ubHuCj6K0wuSuWC+JMM9xLX47zuEGKgOTWOd+4S2pbpvtgUvnJnfZW9OsoFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 10:17:16AM +0200, David Hildenbrand (Arm) wrote:
> >> So the rule here is:
> >>
> >>   * ptep_get_lockless() could be used for locked and not locked
> >>   * ptep_get() only used when locked
> >>
> >> Right?
> > 
> > Yes, this is my assumption.
> 
> I agree, ptep_get_lockless() simply makes sense to return something sensible if
> there are concurrent modifications (which cannot happen when the PTL is held).
> 
> That's why only 32bit with 64bit PTEs and arm64 even has to special-case it.
> 
> 
> We should clarify in the patch description that in the do-while loop, we might
> or might not hold the PTL, and that calling ptep_get_lockless() with the PTL
> held is OK.
> 
> I wonder if it's more efficient and clearer, to use the correct variant, though?
> 
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index a4d52fdb3056..36d97661a4e5 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -187,6 +187,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>         p4d_t *p4d;
>         pud_t *pud;
>         pmd_t pmde;
> +       pte_t pteval;
> 
>         /* The only possible pmd mapping has been handled on last iteration */
>         if (pvmw->pmd && !pvmw->pte)
> @@ -310,7 +311,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>                                 goto restart;
>                         }
>                         pvmw->pte++;
> -               } while (pte_none(ptep_get(pvmw->pte)));
> +                       if (!pvmw->ptl)
> +                               pteval = ptep_get_lockless(pvmw->pte);
> +                       else
> +                               pteval = ptep_get(pvmw->pte);
> +               } while (pte_none(pteval));

Looks fine to me. I will try and add it to the next version.

>                 if (!pvmw->ptl) {
>                         spin_lock(ptl);
> 
> 
> -- 
> Cheers,
> 
> David

Thanks!

