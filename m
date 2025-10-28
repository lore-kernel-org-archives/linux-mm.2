Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC459CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1161880186; Tue, 28 Oct 2025 13:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDE98013F; Tue, 28 Oct 2025 13:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1EDE80186; Tue, 28 Oct 2025 13:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E150B8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:03:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89296C0535
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:03:01 +0000 (UTC)
X-FDA: 84048142962.03.BCFA219
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E72D140005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:02:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=T4Qh1Rsz;
	spf=pass (imf23.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761670979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rYwLUjpm2frIOnf2ALh2+geT1TNaDczTmp0yuBS+00=;
	b=lFW9uMqEG3+i1bXZetDBAlpTJby8b8ka89wp1xD729vSRol6nWVaIPyxqJqZ3nZUSFGbCU
	xFyp/wR05AZYScJLEKQHlJZxCKRgJ7aiWdDF+yPRBzMUC1bWASpcoE7rBiZy97y54bFkoz
	KtSZEqnb2BEBcjQxRWRHbps43PC0kJY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=T4Qh1Rsz;
	spf=pass (imf23.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761670979; a=rsa-sha256;
	cv=none;
	b=HWZxf1eLIGHJfrhbXdEDvZHajwUhHpEN/Xmupk6OyEqXQIOiyOXgpYbshJ+2ZFWUJ6aLiS
	UT9DjJou5p8fdNiReXZDz20YuyZxRhXOQceBtkZ2NFqeWLB+dcSzbQgCwEdik4dkRXV6mm
	swE823Pb9ksTpoYzh9ChZ451Vpn+1o4=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SE4Zdg010062;
	Tue, 28 Oct 2025 17:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=5rYwLUjpm2frIOnf2ALh2+geT1TNaD
	czTmp0yuBS+00=; b=T4Qh1Rszd2Xuzu6BLvFm7PSB2/jMKLKL7slecAcScAlFXF
	HeHN05uNvH9Xg6waw+2XzaQEAeO39KpvLeLTyLgvIkgBxjVvTp1pfKQ+ti8Xl5Nb
	Ja125AkvIMGYHGB114T20IB9PL3aBdimEsDIDoTahbjSwapI8cERaOO6CdIMEc7u
	kPJF6mjZfYYYhvNE1ryKgpu9YxA2XYXSn/9EuRl+eJF60k3PW1VksUvsRiFRNuyR
	fzMuMHZikE7epwkvdKJkoXToSwgIx+mIXEfD6A8l6RvT4qYG0Wvc1MOBWqj5LXk6
	J9aADJwconJgjJLw8LajV3JJ7ZNGEmtl9BO25yLQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0mys5mcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 17:02:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59SGxhdW021584;
	Tue, 28 Oct 2025 17:02:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a18vs48rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 17:02:55 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59SH2ri354133178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:02:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 712962005A;
	Tue, 28 Oct 2025 17:02:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E156220043;
	Tue, 28 Oct 2025 17:02:52 +0000 (GMT)
Received: from osiris (unknown [9.111.93.226])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 28 Oct 2025 17:02:52 +0000 (GMT)
Date: Tue, 28 Oct 2025 18:02:51 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Luiz Capitulino <luizcap@redhat.com>, osalvador@suse.de,
        akpm@linux-foundation.org, david@redhat.com, aneesh.kumar@kernel.org,
        borntraeger@linux.ibm.com, mike.kravetz@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] mm: hugetlb: fix HVO crash on s390
Message-ID: <20251028170251.11688Aa3-hca@linux.ibm.com>
References: <20251028153930.37107-1-luizcap@redhat.com>
 <50d815a1-8384-4eaa-8515-19d6c92425b3@oracle.com>
 <20251028161426.35377Af6-hca@linux.ibm.com>
 <5c72e064-9298-490e-b05a-16be6b5590b7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c72e064-9298-490e-b05a-16be6b5590b7@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1ENDHsCyHQ3klid1w60ZurPA0m-AtDhQ
X-Authority-Analysis: v=2.4 cv=ct2WUl4i c=1 sm=1 tr=0 ts=6900f740 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=8zN6xJiJR_NKaynfo1wA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMCBTYWx0ZWRfX9ep+NoRBYWRo
 gKwTlXWufTlc3j8/k9M239Tmdmp5ofeAJISYw0bNCPqjOKUMjjZ7VNacK/jxvh+8Pv8L8wAb8DZ
 Olck4hfxaAgV+s8VtN4jHNhqpttJ9uz0aiZupuSc/l1Baf85ULa/YGDIsbrhL0pKMrROjom+UdP
 lLhGJZylrZbsA48rLh0ojrK80C4axam0ys3y3QTHWfHtxeuXKtYCKN5oB7mafPsQfEe/MxYtyqP
 22t+5C5HgRPPgH/1wHtwunW00sTzkXbtpDNk++UAVJ0FVE4S5tagXImF0f7ZOMRJiVSbmJw3pBH
 Pbwb8xgu90BPoys/nDNdcky1jXJjp6GoiOFTqHa0wONJSoK4AqOEELgTAjRYotEgIHzb2wGd7mY
 fGFlV4GWcNeXysS+h11sMi7fhXCH7g==
X-Proofpoint-GUID: 1ENDHsCyHQ3klid1w60ZurPA0m-AtDhQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250010
X-Stat-Signature: kjc8agfe3omnfrxq5beha4mkpymkrnak
X-Rspamd-Queue-Id: 3E72D140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761670979-605764
X-HE-Meta: U2FsdGVkX184B8PJQbbNEUSUMDT3UNeVOtNLLzspB+6cNBIVcaQ1+hOap8cs3EA+NCfudQoArZ34rgLu6BGP6XLNEmF7zGJo8lUB9kIpdukNBgUiAYZ3xGzlDgLzFImCZFTkT0RV+zE6JKv9yB65+mdOgWArWbnZuoZxZfG4oq4jfBRe7tL7wrp5jn90tx6nIku+4G6jk+Zkj7a5JQYZK3UR/6G4ohKNtMqc/MsXPD0Tejw8Cv7NKmjBYrqz/uyw6o7Q/B+1YeElRyd8xY2yfkFFj8vrOwU9FNJVs7F+NpWE11OtbLbdzUnYF3ixr3SiqGlDGy9pyfT2oYk2VX/cXggo2E36JGfaGT31konB60LBdAOKMC61iqZtM1rFCcOnY9fNpgqwCZXJEi3mE3YEy8krLiqgy3Hv4WpzMMcS34hbUi6gmIzXopVn9I8rlKfkDEr8EDGaHX0I8zqLAdaA3zvNEHKJjSj+V8fCRV9HHTv9vuUn8T3l8lmIIG1JhIc1zVzoA9hb5N0IVZAMGjPkHXxdtbNb19r9pDNtD8LlCRud44FOd1z3jXGQ19JIKwYebitIEleJXbGov7uMPM1ibK4T6ZKxZl+1Dd0TLL9wbLB/nefJ5Vb9fwDS+uWPC4G35b1iSy2ADKT9r+ZMcHI2M2gKARNn2xYTsd+xH9KWPcixuCEl1AtYK7A286dRNIEq+utoBF1a2fzHXwsFLtp/M3HS8yHhCUmFD/7BsRl9o+h4RIzMTrCGnWfdfA6Xr5XXaMrpe1Qnu/ghp/lQgGuM2SXFRNkDO9AEz6aw2FFZa+UegrnblJ4QsKdvQGDO4wstbtuMESkTwHr3bjtbvepxFfH0rC5mRZFBiWfzbM/x87qwPcS0olU4QpDLpIKiE/0uVqM+R+og2/Zu4GK3XoGVhrdyEMG+1QG/P51XBCby0KWd+LRZtJEyCHfUmMZuOTlAyMynqPOL1yuKmcjV3B5
 KxgMnh6L
 P0iwaP6P+OYEHWm7MPEODU68u6GsvVMcg2Q+EOkP7fPN7V147N9wW0v9OHD5pe70Mgwv8ytBaaOG5hfV0nVZaWZH49HUQoVerry8wFiLhKoG+Utb6g6JWhoa5mjLuiPrQe4rMS4/ud6DG4+YJgWOH6Vbc46hN3RKHxX93VRSQEtoJkDlcnwgKCBDE5JpRbhtuGoelEII48gUYirBNrmR2jU9ir+g2uQW5/iXUGCk7wQKXeMbQRsQTf1u9QbBYS+OGNQ986b30HRPo/Abt87UZfle9zRwRaG6EjDBu3FlQBWpKyLuxJ+iTL0EASA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 04:48:57PM +0000, Joao Martins wrote:
> On 28/10/2025 16:14, Heiko Carstens wrote:
> > On Tue, Oct 28, 2025 at 04:05:45PM +0000, Joao Martins wrote:
> >>> +static inline void vmemmap_flush_tlb_all(void)
> >>> +{
> >>> +#ifdef CONFIG_S390
> >>> +	__tlb_flush_kernel();
> >>> +#else
> >>> +	flush_tlb_all();
> >>> +#endif
> >>> +}
> >>> +
> >>
> >> Wouldn't a better fix be to implement flush_tlb_all() in
> >> s390/include/asm/tlbflush.h since that aliases to __tlb_flush_kernel()?
> > 
> > The question is rather what is flush_tlb_all() supposed to flush? Is
> > it supposed to flush only tlb entries corresponding to the kernel
> > address space, or should it flush just everything?
> > 
> The latter i.e. everything
> 
> At least as far as I understand
> 
> > Within this context it looks like only tlb flushing for the kernel
> > address space is required(?)
> 
> That's correct. We are changing the vmemmap which is in the kernel address
> space, so that's the intent.
> 
> flush_tlb_all() however is the *closest* equivalent to this that's behind an
> arch generic API i.e. flushing kernel address space on all CPUs TLBs. IIUC, x86
> when doing flush_tlb_kernel_range with enough pages it switches to flush_tlb_all
> (these days on modern AMDs it's even one instruction solely in the calling CPU).

Considering that flush_tlb_all() should be mapped to __tlb_flush_global()
and not __tlb_flush_kernel() on s390.

However if there is only a need to flush tlb entries for the complete(?)
kernel address space, then I'd rather propose a new tlb_flush_kernel()
instead of a big hammer. If I'm not mistaken flush_tlb_kernel_range()
exists for just avoiding that. And if architectures can avoid a global
flush of _all_ tlb entries then that should be made possible.

