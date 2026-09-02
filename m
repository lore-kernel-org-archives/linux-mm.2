Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C637EC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93816B00A3; Wed,  2 Sep 2026 10:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B676B00A4; Wed,  2 Sep 2026 10:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81BA6B00A5; Wed,  2 Sep 2026 10:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8030C6B00A3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:53:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF39FC0243
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:53:27 +0000 (UTC)
X-FDA: 85169115654.27.9AC8F93
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7D97F40005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:53:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="LyN2hMe/";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788360805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Xs7Mu6jnbGPV8UltG0ZSUs2j/TcJCLYMEpH07v+Iqg=;
	b=nxlApbq002kuAy4W9IOp8R3QAN7t9CVCS72DyeDrSo+frNjK7niOjaY45g4GcCIlIHPrP4
	ZPL0pvAXmVsmWv6c24k1QMjQcgkohhKT30eg3+bCI+hEmk4klUehctMPB99GJJNeH7oZi7
	4RjiOBQWQ60kYYIIIZu2BQjNv9DIOcQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="LyN2hMe/";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788360805;
	b=091gKtmYA9xdabMuWqsdSkwFgRH7+1MrYhfw61XTXkJZcOO/Rco6VCZ5Ukoup3GYzBdyfK
	2CD/KkJ0LNEEfsiJyewNhseOImRZnxFqzQ8edgZFTc0wHXAwYc5GdL3XyP/eTAbxnI+A3u
	QiPSYSeIP6eHGoufKnq5m3yTtQRZciE=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682CVtfI046984;
	Wed, 2 Sep 2026 14:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5Xs7Mu
	6jnbGPV8UltG0ZSUs2j/TcJCLYMEpH07v+Iqg=; b=LyN2hMe/qpHb7dbgo09vaj
	SlxO3cdJTT7yP2mv5NsUrAjIozgf5npqbpuUgh+oxFUJU9HLQ9LNI+IZpMJiFOKr
	aX8ThXG7vof+Ek2qbKODtAfzH0Bo1AI2hJk7UNFLX+tiIgMeCM4ZS3xHpRIUJKvd
	jhGg/ThNd7hKooVJUQ3MzaxSQZzkQnK8NlF63wKMR16Ssx+6kf7RKUMpC34BgcHN
	RkDkGXWx5SyRRmaCU1AXQYfG2+I/YZSTi5YlCLCdB/2luX9HKEC0pZ1/sFSjJT4S
	GT0aRB6qlapVWLb2ZcBbkQ2IbjhpeKy/soejKhXo074OFxwGo5nimWbgjsAOSstQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2tevgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 14:53:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 682EfIQS020342;
	Wed, 2 Sep 2026 14:53:22 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8hjcgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 14:53:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 682ErIgo42729956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Sep 2026 14:53:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FF3520043;
	Wed,  2 Sep 2026 14:53:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CABF720040;
	Wed,  2 Sep 2026 14:53:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.224.75.30])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  2 Sep 2026 14:53:17 +0000 (GMT)
Date: Wed, 2 Sep 2026 16:53:15 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David
 Hildenbrand <david@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: s390: replace page allocator calls with
 kzalloc()
Message-ID: <20260902165315.06996af6@p-imbrenda>
In-Reply-To: <apghz4XAgv0ro15t@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
	<20260902130612.41500808@p-imbrenda>
	<apghz4XAgv0ro15t@kernel.org>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a983862 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=iT-jVQeAxx133_sytAwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDEyOCBTYWx0ZWRfX3r5DrU+hPIcW
 +R/pcZv/kteCuUDX2LkaT6ApUjlBhLWtyovKwsaAQQoCGwbvcZDWmqnSSXphaVBMLn8tgVmCh0y
 RJBe5VAU3V5bEOioIpfs67jwI44Qu2A=
X-Proofpoint-ORIG-GUID: MZWJC2roP1BPdcqri1p0hvQ2eJSxf6mS
X-Proofpoint-GUID: MZWJC2roP1BPdcqri1p0hvQ2eJSxf6mS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDEyOCBTYWx0ZWRfX1jzB8OFQsNHP
 mjQXWPCaYr4kLevRUJ8A0C4QPOmEvs9DcOwbiDUAF0tIAMgGJnPR2eEmVCRJxzJBTsTBr7wyr95
 7s7iCuKdY4BcRNmF4dGL/yskgrL3qLP9Q5e5TjuiXzmleig4QBjQYjALbQer+FpVG/7uC6tc/ku
 UWodck2j3oE5uQ2t9eDlyw6guvf1fwL0H055vP1eV+PEc+vR/bvnS3ZEgqGiRn9ijCL4Xb226Sv
 ohoO/C6W5QBjLbf2e008GPpsDo7+y7A53ldHa+e5tiaFJSDdy6YwvR7nvYzJr4SsfFw8SUXC14+
 Pc3z3rM4FttqIc42CCCQWiV/XYeQ8+VBYa5ATVkR1z/HOy+xmhYacFkQB80BpTeyMO5qyaEzYtg
 w2rKsi85ctxTEqGCCi6jlMgo4XoWg6AF5PZq8VgJ4dKBYrbUCm/qqWkq3fiKoIkFgIetVSx55cm
 e5ua7KLfza1fnn7nOJA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_03,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020128
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ohg8uhxf744huiqmo1sfbi711cehf47t
X-Rspamd-Queue-Id: 7D97F40005
X-HE-Tag: 1788360805-293790
X-HE-Meta: U2FsdGVkX1/efWmov4pwq72yVa6Ex/+IhqhsLnA0NSOqL+3SmSkgYg4f6g9t/YvnfM2McwUrm8Ga/2/HkX+lDx+TxE+wlhZVnVySuevJcQmgcPA6c44HunswOye9J+zg/P+EZofNSoIKNut/MpdJeyCq4Ri5Y6HDdaGeHwgLTPqzTdWdh7J5mXzqrSmTRAZASDlFzQBdCrXCiOEAQAVSoZER2WM1n9MfYvnTE1PWCnUNJKdDMySdfCF0x/0DEqyf4ztY0IfkaZJUneGuQGxaZ8CsEmPk52lLmCVu8NCqt79STyaOyeCuKMCtSIJMZ7/pueR00QDjwxjaDCEgktcT1WTj7OxkvNbMtcTksNiYeK927QbNPkS4nthTNrwRG1VSWxSG894U978bf/WJwQQAsHl/Mibr4Qlzqbf6utcOT0X9bjSPCL6mNB6mQA6V1V243KDxaLLMsH5CuyiDfxFliquMbnIdhou5YnuRSOSl+EhFlSauxzEWS910l0HjK5KnmEmkCI/sX+g1p22LyW27BoV9uWgDdJc/uEVqd92/20638/N6w8Lw4AFgIIQjy0CWAPEfLICFk3QXRipjnC+YArmgrh9f7jYKVnl/56XV7og44ZdMNvERX99RLCuvVvU4yPgFcH4zbXg+2biT3kIFVvaC8wwoFDoxWDm5Hrt3mpraHxqD2xUv0VES7G6/+F0nZY0Di5T4fq2JLaUe2lSvimsQQVjuKTN18J2buC5I2LdlAawUrniutPWNUwBejstDYmcOjihb92n67cGBCpEI0jags9MVNWcGqM/IvsJi7yxC4A/ovPtXMXREcgKPvMszFiwhAqtNWlgdK1cNXPz7XzEO+20pnJazD+wHPkq2vWOtn8r5BZX28pdSnp1N6KV7KMAV6z9eRLGxiFoVZ5p/nqG3TxOuBDAdSIeRiu79VVu065+yjBbVIsu/i4eWeIVEOYcl/U5iGnquuJa6ra8
 X18JY9tS
 /vj7dRqJLmHeUkENdBx5vPUJODVbxnnYm5l+FJwOcqmwLdR+3W256iy0vU32cCswfpK9zGR55Nu0BF7ZlS6bMSSVi47lgsImlGNiZLH5NHWc0AiNr5tM/T8ElDeDHDl0sKN8qlmWqRQrJlnsGLcv/+ALttsaqZ+Ly2t5rO3S59it0d/REF6fOFxAS3d8aZLKA/WCXZWyKQbG8Xre18fPjH4McUM+Lc3TydsBlYXE3IRehVeMKMuFlLnrVQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 16:17:03 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> On Wed, Sep 02, 2026 at 01:06:12PM +0200, Claudio Imbrenda wrote:
> > On Wed, 02 Sep 2026 09:15:12 +0300
> > "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> >   
> > > This is a (small) part of larger work of replacing page allocator calls
> > > with kmalloc.
> > > 
> > > My initial intention a few month ago was to remove ugly casts [1], but then
> > > willy pointed out that Linus objected to something like this [2] and it
> > > looks like more than a decade old technical debt.
> > > 
> > > Largely, anything that doesn't need struct page (or a memdesc in the
> > > future) should just use kmalloc() or kvmalloc() to allocate memory.
> > > kmalloc() guarantees alignment, physical contiguity and working
> > > virt_to_phys() and beside nicer API that returns void * on alloc and
> > > doesn't require to know the allocation size on free, kmalloc() provides
> > > better debugging capabilities than page allocator.
> > > 
> > > Another thing is that touching these allocation sites gives the reviewers
> > > opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> > > another size is appropriate.
> > > 
> > > For larger allocations that don't need physically contiguous memory
> > > kvmalloc() can be a better option that __get_free_pages() because under
> > > memory pressure it's is easier to allocate several order-0 pages than a
> > > physically contiguous chunk with the same number of pages.
> > > 
> > > And last, but not least, removing needless calls to page allocator should
> > > help with memdesc (aka project folio) conversion. There will be way less
> > > places to audit to see if the user was actually using struct page.  
> > 
> > I have some objections to this series, but not because of what you are
> > trying to do (which is actually nice).
> > 
> > I understand that you probably wanted to touch as little code as
> > possible,  
> 
> Yep :)
> 
> > but now since you're rewriting the allocations to use
> > kmalloc.... I'd like them to be converted to use the __free(kvmalloc)  
> 
> You mean __free(kfree)? Sure, I can look into it.

yep :)

> 
> > system. It will make the code smaller, easier to read and understand,
> > less prone to future errors, etc.
> > 
> > In some places the whole code flow can be simplified a lot.  
> 


