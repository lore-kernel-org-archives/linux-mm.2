Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FEEBC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34FB96B008C; Wed, 26 Aug 2026 09:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327DD6B0096; Wed, 26 Aug 2026 09:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D566B0098; Wed, 26 Aug 2026 09:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E58686B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:03:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3336F403AF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:03:09 +0000 (UTC)
X-FDA: 85143436098.25.DDF1DA1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id B5F8A1C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:03:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XPLXQ3Cg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787749386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMRKDXv7zJrMTk4ZU/ByZDo8aqYydWKomBzL28qTgeM=;
	b=jwWgTqGrM1AnXMLDkLtbgxlQ2X+nuIC412A5/TPtbkuS0k+fowCmiKkp/Ovth9l+cQ4hdZ
	EgKG6Ozw7YOE4cda7IGKjKdp80KJ5J34f0Zk+d7eFCBMKALQInfod0SE1sbS3d5RSYy3HR
	VJjGB01ncicrPgY4abw2cONRq2e/edY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XPLXQ3Cg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787749386;
	b=u3uqUQIrAXIa9oVIU3KvYD1Tk5QNmS1rgpGSlLroVfzq6yr7oF8anGIHLOFboa/DXyRS0J
	EOnoGu8mTAWpp+21F1s1nHtunpJwfs1qptjxal5R7AvnfByDA82bWBcKmo7K0XV+eWYw5w
	sF++Sgh65WLLhOiYgRVhT/LJGgeHMic=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QCW01g4003177;
	Wed, 26 Aug 2026 13:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=cMRKDXv7zJrMTk4ZU/ByZDo8aqYydW
	KomBzL28qTgeM=; b=XPLXQ3CgOWdmvWnPmITwczH452oLNOlcV/ad8/2k7sD6bG
	wQFjUeOvTttjdpF7RXC6nRNbYjN6wfxDiy8FDRsIX7pIrT5dKqZ2chMU2S9iRi1a
	j1wufvCYCLa1x7AG9hQF/zacfdanmxtd9PaW/F0NSFqX+jfqYfh9bBkTPtt7SijL
	VcA7tzPCTEHZ17H5yzShtFVlHQ9dCP74hEoKZIlYgvdlUYugIiPTdeN4Qqxr6J6m
	Yxj/TIbXymWQaXv6gF2UnV5+Lub/dnVuMPewtKSiSCvdMAJc72iExXADGGYCMR4k
	KhukO2VaxBFWlxeHUtxYFooKsgbpxBd0VR7Q9xsg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g4xrcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 13:03:04 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67QCuMSe021707;
	Wed, 26 Aug 2026 13:03:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7p3qa7q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 13:03:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67QD2x3U8585572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Aug 2026 13:02:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82D132004E;
	Wed, 26 Aug 2026 13:02:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 269EE20040;
	Wed, 26 Aug 2026 13:02:59 +0000 (GMT)
Received: from osiris (unknown [9.87.128.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 26 Aug 2026 13:02:59 +0000 (GMT)
Date: Wed, 26 Aug 2026 15:02:57 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <20260826130257.21444B1a-hca@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
 <73a0a916-b39f-4ebe-bffe-448928b13bef-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73a0a916-b39f-4ebe-bffe-448928b13bef-agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: mnaS2EKAjP2YugpbjqZ_JV0viUasngna
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDEwOCBTYWx0ZWRfX7dNqLIMl3+vy
 HKPq5xcApPY6LG90f966XljN0vExanHXKnw3n2i7RjL4lXd3UKVm2CzgT6kefqPy3jnplyAtwYg
 PuOwyi1S6+Zj3LqYSZ/p4uCx3JYHzj0=
X-Proofpoint-GUID: NOqIbWVbZeH7yRovwr2leQYIUW-EgfUw
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a8ee408 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=WcWu7VMip6P6h1v0TZ8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDEwOCBTYWx0ZWRfX64rVuzt7PCA+
 GeD4I9v+CUdWarQxrHoDHukvxbrNmkjxfGyytEEj11RsymxRq1XYin2Vop8Kmtw41X1QiWPQnAZ
 WpYjllVGnkYrQF0WZ1F4qMupF25GU7ZJMuuVuFLjnizScLhrod8bagmtYNOPUEuXQ+eHPiGZ7uQ
 /+VPfODxKMyH/QGHNHm1wI4I+YJMMUk7Hw8M72+rdztcxhbAV+2nGJSFNSD4YyDsa6XS8+gGxu8
 B4CB5J9xP6XmZlxOVTD3o9bvc0imKEOxoOqi0wMt5dJaekQ+mPhsXiOkO6GhiVj1az6tuZpKNCO
 sLfFzQqFLyYXjjLpMy2IxQOmGCjJsreyay+yZJrUOgUiTmh3nx34PLmC9MXx1sCn2vaLwXZAHCF
 pjuTImSG1U/rzpI7BtStwVyKNSIVB9Q4KzRmsHP8JieYTjZMHySl5w+2GbrIVlgX1NWFih7Grh7
 drMddB//EfmV6Ckry9g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_03,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260108
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5F8A1C0004
X-Stat-Signature: hruki35u9pc3m7hztnzzfno8jfbfy7gp
X-Rspam-User: 
X-HE-Tag: 1787749386-786064
X-HE-Meta: U2FsdGVkX18r5xjhVZ7WUO2orqDKmvjrLRo+kh+99sgO898gTxP7ClTZrwhEnSXfK2pjLBjFiSpAgBd8tia5jgqftktWKGsXcv10bNjOMi3+U4j6ktayGgWfkx8pkHVV/5EvzL/Gmt2oonDO/ksrO5c+jF1tC5rVUMt93QgBdFskhuNN+A/McBYstZzdWQUAJS/Yq0zDLQs3H9tbWSowXSK9ZU7NtTQe93ALJeRobSTdjgHSu6W7aFRhFLi1sFfJb2FfAd4DpTfmQF2yuR43qSAIQSrm6e4M5Si6jbsp3TOXncqhb4+qWHiVwj8c1VEKwUHy1cwrbYqMtI+KrbZIFF56JBdk97xfWMFuKwOE5CRr0jh80DO6VC/0mDBdh808T2Aiy5SbqfgPwJ0gGMtpbPQ+ed3uqE707NP81qDICso45gLh4vOAz70bzM+5p2TbPIeOuvsRbJ7Ib70bkFuKbhbTYZHZvzCnRw/pYdojAv4vAv9fa5qZ6Ra88LT3+yRK/JvCmHnQDZNp02Jf6gUc/Y0WjWnHMMOoOFoBM/xFRB1qZtCOmTfve6nm18uk4dfxld15LLYC8VKShIyG7IT8x2ALy090cE/tiZb2pSkVNShk1kwr4N+CH3vaABlajJBxZfxD5DyR/2rKGuT6NlOVR4QagVrvr6DAwHjOkpkVPxAk2xtJJuxWiS5fmVL35BQJvGMV+XWiIu83lijUNX8s8sxMoLyEkHcubYMrmAG/hMZkncX5Elcg4pLpmPctEJcC2nX5X0N9ZAOtWW6fuAsVCWFdCkoXXBrB0cuMNxHCLz+e4dUfMUi34XPp2gU2fYjsqGPkTaTatcaORQMXbhg0Bo/0WjHxzQO/9hHxrx7Fp2F3w3Cjkjf481o4SHO22ph+cqBrFHht6jcW8qNproTYk6f67FWQQ3SAzE/WOPV8zwnNqTk2/Iu6l1ZrgwKpMfWEZpASGUBEYgiZ1LfLMtx
 C1Lt2TNF
 tBynTop9vX/VTIwlCxZywGda3Ra5gUWQCIQXXKkfqHvnpDy+HuW7IaDZydawL/29GpKOS5cccju1c1nt2S4/dqPAltjOFJYM0mQz03ZfHx3UI+n1Gq0OVYj5gDhDnP8ot2CtArIz3rwf8N8uzRBroJv/GPYmUqViYz0QwUHLyaFVooAqffI9jKEj0iAEtCo2+WXJy/qACGihP9jLQUZMoBzdGukN467K71VYcBQ4+tDBjgLKO/JIT5eHwAdCCC/KGi9E8B8Kz/80CKF3ATciQVyhPpT1AfPE64APDHlmO6uQ/vblJ6aSzljcBbFXPZgjoaKqbj85a1bpXos6lYYPYhwLaQ5i01t09sscbkLD7F1p2vBp0ahI9LiLvzR0LLSv21OchnISYdRWAzbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 02:00:35PM +0200, Alexander Gordeev wrote:
> On Mon, Aug 24, 2026 at 12:40:48PM +0200, Heiko Carstens wrote:
> > On Mon, Aug 17, 2026 at 01:33:00PM +0200, Alexander Gordeev wrote:
> > > diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
> > > index 3b3ecc647993..dba236664da9 100644
> > > --- a/arch/s390/include/asm/lowcore.h
> > > +++ b/arch/s390/include/asm/lowcore.h
> > > @@ -163,7 +163,7 @@ struct lowcore {
> > >  	__s32	preempt_count;			/* 0x03a8 */
> > >  	__u32	spinlock_lockval;		/* 0x03ac */
> > >  	__u32	spinlock_index;			/* 0x03b0 */
> > > -	__u8	pad_0x03b4[0x03b8-0x03b4];	/* 0x03b4 */
> > > +	__s32	lazy_mmu_count;			/* 0x03b4 */
> > 
> > Why is this signed? Can it get negative?
> 
> For the same reason preempt_count is signed, I guess.

Check again, preempt_count is now unsigned and 64 bit ;)

> No, it can not get negative and it is very handy to observe
> a disbalance in a crash (I did hit it indeed while debugging).
> 
> > > +static __always_inline bool is_lazy_mmu_active(void)
> > > +{
> > > +	if (__is_defined(__DECOMPRESSOR))
> > > +		return false;
> > > +	if (!get_lowcore()->lazy_mmu_count)
> > > +		return false;
> > 
> > I guess there is opportunity to generate better code here using an
> > alternative and using a flag output constraint too.
> 
> Will try.

Guess that will be quite ugly code. Just let me know if I should
provide that code, since I coded up such a mess already several times.
> > >  void __init arch_cpu_finalize_init(void)
> > >  {
> > > +	lazy_mmu_online_boot_cpu();
> > >  	sclp_init();
> > >  }
> > 
> > What makes this code so special that an explicit call from
> > arch_cpu_finalize_init() is required? This is really the last resort if
> > everything else fails. To me it looks like the code can be changed to use a
> > new static key, and add a generic early (pre-smp) initcall to allocate
> > memory for cpu 0, and if that succeeds enable the static key.
> 
> I had exactly similar variant, but failed to resolve a race when a secondary
> CPU callback was called before the CPU0's one. Probably, used a wrong event.
> Will look into it again.

early_initcall() should do the trick.

> > > +	local_bh_disable();
> > > +
> > > +	lockdep_assert_preemption_disabled();
> > > +	range = this_cpu_read(ipte_range);
> > 
> > Why is it required to disable bottom halves? A comment would be helpful.
> > Or a hint in the commit message - this is not obvious.
> 
> When an interrupt arrives in the middle of enter|leave_ipte_range()
> the chain pcpu_addr_to_page() -> vmalloc_to_page() -> ptep_get()
> decides ptep_get() is called in lazy mode, while the per-cpu state
> not yet (de-)initialized (AKA inconsistent). That led to crashes:

So, I don't know what exactly lead to the crash, but I guess the
problem is an only partially initialized ipte_range struct, while the
lazy_mmu_count has been incremented already? Isn't it possible to
solve that problem without disabling bottom halves by reordering
sequences in enter_ipte_range() and leave_ipte_range()?

Would be nice if we could avoid the not so obvious local_bh_disable()
and local_bh_enable() pairs.

