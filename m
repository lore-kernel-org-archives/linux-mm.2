Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AF8CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4248E000B; Fri,  5 Sep 2025 11:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854768E0001; Fri,  5 Sep 2025 11:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CA18E000B; Fri,  5 Sep 2025 11:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C47D8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:48:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D62D8579C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:48:58 +0000 (UTC)
X-FDA: 83855629956.04.C40007B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E43F40007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:48:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DRFTEJUz;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757087336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCfoUYLMC6HNsYLC2Cmci4imZfw/WsROhnMAP3rAWN8=;
	b=4emU1rybPFkg5vb1EEP5mRE/pO4pBAJJh/929bDr7P5l84U5OOxbnHo5fWwhHCoCN+mhK0
	kzA1JsgDahS2Ax2lGbsxyAAojWLJn2+9AUCb39HR7hkCEN5SV3VAFTGNkDsncUTNzia3go
	9D4Pb8B0q1H7dhZFadsXevh62I0+VSU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DRFTEJUz;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757087336; a=rsa-sha256;
	cv=none;
	b=bHZmIT4SfoKf0afymrEwEU4Wlj3ZmHC7BJnNYN2j6/zIwL3lfQVVptdzuPHnapTPd5VDH+
	CgeF6dwFvvmj9A47Vfs7Y5kSuWL3TVgbWS2alcy+jPmiia+okRspNj7cczCIV3FVgRYqa5
	TTCxROYsKDFF9gXZJHOx4KQ0tOfCFhY=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585AgQoa017948;
	Fri, 5 Sep 2025 15:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=mCfoUYLMC6HNsYLC2Cmci4imZfw/Ws
	ROhnMAP3rAWN8=; b=DRFTEJUzUMLxbxYuAXuLuwNqrzv8c+DrkFqe89wjY27c9F
	HPKmwnL0ffbZLOY3Rz5gz7HsHuFYQX6DqipN3T17S7pXXoPQ0OUX26rpw2bM2Ta4
	HCoGI8+peE6wgvdwt4ZhOwwGmSI9acpU5CBc496pJ6Kl9gzxQDChu/+1O6PlEWaS
	HHHSSQvfm9GSge31HtdVFwim+meO0SH5sOxV9j5RYTRpeOEqPos2duD1GYvhAUwk
	Y1ASxol3ifR8yNeQRkjgWqPhocL/iRqrC9el8+zCXSORnp/lvdaNXU7o8ETDqd86
	PWf/tQ2g4yPndZLt/k4Lq6iGIW8zebN60vYAGngw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usurhfn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 15:48:31 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 585FkhKr005421;
	Fri, 5 Sep 2025 15:48:30 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usurhfmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 15:48:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 585D0Hpj019442;
	Fri, 5 Sep 2025 15:48:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48vd4na0hb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 15:48:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 585FmRQ252298180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Sep 2025 15:48:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB1582004E;
	Fri,  5 Sep 2025 15:48:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EE2320043;
	Fri,  5 Sep 2025 15:48:25 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.48.240])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  5 Sep 2025 15:48:25 +0000 (GMT)
Date: Fri, 5 Sep 2025 17:48:23 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 4/7] x86/xen: support nested lazy_mmu sections (again)
Message-ID: <d3adc2a0-5888-411e-ac7c-9df45e3389c9-agordeev@linux.ibm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-5-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904125736.3918646-5-kevin.brodsky@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMCBTYWx0ZWRfX5iXkXHtPokV2
 s58RZ7e813edv+vWWoqJUrrtWQXbub6NiX58yP1v9mbmzE5GTo4wfrfFkR/YZ/MbCR+iaBSdaCX
 adCNlkxNA/nEsZ3agSOH3KgEWq38b6wGZtWAzoLq+mKBzCvbn/uEMkBgl3O9f5obeDeeWy94B3P
 LgKQGohc5o/PIli23EYmnTGZI+Oj8pYgiOworIhg3wrM4u606YHplewCbIn1zTW8AdxtJuUJDYA
 iMBC7cL5Ca1p2IQg+1kqXYCy73F3DoQq/aCn8/pSszhndcjXi11V8uX0tGswVehF3dhVd7AerLt
 JrqhsabJDFJw5fzoqnl1EhDRooO7y32BwqH5cYOjZy4q0rOcELXv53bz54YHJ9HbXtIGc4qdlip
 ckpxcnXd
X-Proofpoint-GUID: u6h_butZCR90wxuVu6ifBPi5r4KK37UM
X-Proofpoint-ORIG-GUID: HU44fewV-eZEBpYhS3NFrN8FS6mJ4q6n
X-Authority-Analysis: v=2.4 cv=Ao/u3P9P c=1 sm=1 tr=0 ts=68bb064f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=36QzpkCBnVJsay_x71QA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300030
X-Rspamd-Queue-Id: 0E43F40007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qrowu9y6cmfa46jnhsfkij3ntkqt6rd9
X-HE-Tag: 1757087335-903341
X-HE-Meta: U2FsdGVkX1+uB4ODCgWOcbNReFjjzU7/y44Jl/Pp22JLFdpBsMjcTuWMkolQDjgw2o1KrXxmh9pUosn2TEeMuOrk86GF7RGkRKCCc4860zwFQgFMwcsC2Jw1bQlGLFBz1bx7UprB5+A+IYr5l0fjb3/q8Vf7555FH+/Kuio+9PTPS66SgIMGGjfOYPQ7ONm4oVwCCvYl2m82y+4v9G7iRjdb8GHCUwQKu1EuzNxduPEDlA1QRzv3cUULwisjSTXr7eGbUMiE0jbnbiZuieP9ZKKsWmGOeueFtl3oydRfEsitKqAWogMYTXWuvCLqIwvWNP3x4MVaclwOezr5QSxrQLRlRr7IQ8jqGshh0gvrnFm6EO2T2FfKgfLSeK4To8Q56rsAPjAiBmIOgxHAl6LR0aP6mxjft/rehOtmdGw7daARHJ52k9xsBepeId5ZspRTBgz81YRlYHJBfsJxAfuaLStkb5MREnvi7JJHZI0EG/zacx1Z7OB8Vu164uMMCcJ43rUsX1uuWBmHxkQBCxfV7bzVuhcuBNY/pUyoTbKBcmRaB3ZLf3kC9nPNlG82IdfXPJFfCaP/oYFt/EOFVS23lh3Ew/Qm4kuXwl/bC02BlwPdw9eTMKGoGlQrsFOC3Hc7zc6pOBuI1SbdSwPV4ceYk1FuTYPcsMLKolOuAB8waaF+eATpKrBabDIv+xm0U7Gg0Ej8B1E+x7e6whqlU3wd+jPofpMuaQKlxUuEbRZSqBO9Wxrz2TVudKX7h8BkUw76sjB8e765qVUnV1w2IQsnhhyd0pDcP54OHJuX+rzh3SQN/Q6Du01wUgXLEdD7hkGG0TN0ccw7g4DtcSHRaAu/Lr5nq4B1ULm1A8r9fyX11WQvkHD4uhx6IkxrB9hImWhgFrd1TXa4tUZWmFk6FuN9jGebK2GGnHCb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:57:33PM +0100, Kevin Brodsky wrote:
...
> -static void xen_enter_lazy_mmu(void)
> +static lazy_mmu_state_t xen_enter_lazy_mmu(void)
>  {
> +	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU)
> +		return LAZY_MMU_NESTED;
> +
>  	enter_lazy(XEN_LAZY_MMU);
> +	return LAZY_MMU_DEFAULT;
>  }
>  
>  static void xen_flush_lazy_mmu(void)
> @@ -2167,11 +2171,12 @@ static void __init xen_post_allocator_init(void)
>  	pv_ops.mmu.write_cr3 = &xen_write_cr3;
>  }
>  
> -static void xen_leave_lazy_mmu(void)
> +static void xen_leave_lazy_mmu(lazy_mmu_state_t state)
>  {
>  	preempt_disable();
>  	xen_mc_flush();
> -	leave_lazy(XEN_LAZY_MMU);
> +	if (state != LAZY_MMU_NESTED)
> +		leave_lazy(XEN_LAZY_MMU);

Based on xen_enter_lazy_mmu(), whether this condition needs to be
executed with the preemption disabled?

Or may be this_cpu_read(xen_lazy_mode) + enter_lazy(XEN_LAZY_MMU)
should be executed with the preemption disabled?

>  	preempt_enable();
>  }

Thanks!

