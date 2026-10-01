Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D37CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B7A6B0092; Thu,  1 Oct 2026 04:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62CEC6B0093; Thu,  1 Oct 2026 04:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51CCE6B0095; Thu,  1 Oct 2026 04:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26D566B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:01:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A25591C27CE
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:01:06 +0000 (UTC)
X-FDA: 85273311732.08.F4F40D0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3AC0FC0005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:01:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WvUyfFJK;
	spf=pass (imf10.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790841664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MTva56L4+MD5F+jwR8XlVy8f0pKRk7aCi8mRoUiY0w=;
	b=JC8YwGg9vISre7QYRheCu6SRR2vj2iilm5Rj2aC2x99EWP/fK1lTBV9ruykvyPD+q2FAKT
	KEEUTqHl8GEOqETuE4MUxBamOdBX0z/AiUH/n/CC+FyIAhC+C58tAT5jRQ9CEGU/oHkIAJ
	R5dBCWduGHQUhZpDbyc9ES67C+s8n38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790841664;
	b=UwDm1CE3y8+g+m4dFzFdKblxLsZi6YQ1yUb8/QPTD/WzATpKU7tLqGbok8jKFQX8gA3zQL
	TzI15bub1LUrYkhU/wWEufshp5TZfGci2RxveObvfx6ue0X7CcQApCTdymAkgBxnnxENhx
	qQCfXz8g0zbW+vzF169a9lyahtKU0qw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WvUyfFJK;
	spf=pass (imf10.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69175Xug3446209;
	Thu, 1 Oct 2026 08:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=+MTva56L4+MD5F+jwR8XlVy8f0pKRk
	7aCi8mRoUiY0w=; b=WvUyfFJKFW0VDbmrHYWDGwwFB5wCgoN9X0fs973me+S9S/
	qthidMoseVBJmpR0BdS1VeLZVJ6mLBBhJwl/if+/uPekWefVnZrw5Q0SYNjIC6TD
	DN7UJKAPEb6k3e3SaGJ0pn5SOXJ4IvIZ76riKCaY1N/bBoWvSXAsqB5/Qp7sK3ui
	l59XkNk4tagBBnhULN4Py4TXgiQf7MAnzZ4aogTM//GfSPhBRkyQBK4uobAjGSoe
	5VrqKa7Xv16W6OQtDtIF+waFmr6mINPX9WDA5wbr5sDCSTEPoZ4Zdw+DsReQkoR2
	oDHz6YDwpRoFF3lscoNgGtD2fChqbtyizG3x8QZA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qrhxbc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 08:01:01 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69172VwZ520704;
	Thu, 1 Oct 2026 08:01:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0hfpfrvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 08:01:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69180uNQ38797662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Oct 2026 08:00:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E072120043;
	Thu,  1 Oct 2026 08:00:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D6D520040;
	Thu,  1 Oct 2026 08:00:56 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.54.207])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Oct 2026 08:00:56 +0000 (GMT)
Date: Thu, 1 Oct 2026 10:00:55 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <b66a61a4-a532-44ba-a1c6-26f02193fb05-agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824104048.11040Cdc-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzMCBTYWx0ZWRfX6YkfKWEpBcwQ
 N2xtb1Zed75UiX/0yLNPdPQE96ozCdqKrFZHX/6ymzjryvv/daZNPMdeaQnxgFwHnckyHhm3NOa
 Qv9LHLuGwBZ238IfOmW9PKzH7M4ZVNn0MnBYRrMckVVE8mL/aYMKH4LXagsu5wi5Q6izOYdBQnd
 P1AuYkstpiJGwkTpkfHfF+F2TeXPrfjupHcu0t1ch9SLsw81nFLMmNPkq9BlsILeuoG51t/y6S2
 j1hEBQo4HLq9NAWedmxUKmzWctC8gJzsf/Dam3pjWBRmBrKPwnBFyf+1yY73IInOAFsetjMG0hn
 MUiEr6JISkKZuUZA1uTdpDKMnK1Zcf9Vx7BexLsIjgN8pKlIJlBqQXosKSVQ4aPyszalJYMO/aF
 8wzcOHl+ce6RRq+wqykxuNdoIokl6NjqXhVRs+HrVJr0iaBGjrNAQbGNlcS+kDkY+dGbuY/oGPS
 +YiLDdFYJORXuPr2o+w==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6abe133e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=m8Li7VA48kL__Rn2agMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: TK7xsE2_XFdNWioSpWUiuMdbLcLFSrY1
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzMCBTYWx0ZWRfXxyXQgnjU9D0X
 tHuY+PHhFc0+n146WPgAoCn5CXGMkEz1Xcon9MFTMa/vr85rvUu+TYqhuXHR0vgHIurZX6X4FGL
 H+EpDwZzW7oLW3wfVHrtJk35nIoyOqo=
X-Proofpoint-GUID: snOW1WwzWZreqGa1tdD562TZ2vVp2wdG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010030
X-Rspam-User: 
X-Stat-Signature: kfweqkup7fmzxt3dchqsso5hbq9eetpm
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3AC0FC0005
X-HE-Tag: 1790841664-301727
X-HE-Meta: U2FsdGVkX1+TcfLKiYoKCJSw8TPCjpTYNXfbkK79fvqfNr16BGdDe4H2KFthq0uISfurcpOhE2J0XeFyjgLewyu35BtCR3oKSPdpsR5ANMd8XNSEVpA4dYG42B0m1/WAl17DQwujALf6BuVTv6QNKQMzjruNcFOoBK7F61Ov1OnLvVNX4XKlj7fXAkkDuKnH415/VpCzT10d5ekxKgyKpz6i9xnbjcsp7cs/aeTmqHUwqqytRjNBr400N+Op49esANm/xmalAQKCBHJ6GrEU2RG03UU5EjIFjPl9E6DnqqcMpLZDCW8Dp7SEbG1Lan03PEfV0VRv6Givqarn2hFHfl8q+g9nWun407dy/hN6/EgQfqi1KEh1C8763WbOP/LnbTvrttn6UF10hiZeyf++3/z+NJltzsOOTaBdxuIfVqCZT5cJfGmBZj85eI2z+BV6ba57EG3+SN92Rv6aIvIjUoUVXDzoqH1cEIcuIoGOwn2UWrI3cKSgQjxrH8jpvu2eBuoznkyY5MiJbTsNJnx5fvGJFY+3yN2bmyONa4cHhLsrUsyoYeCBq1vH4OnAJM9gvun6aBf4m53ZfN3lnwvCeN8JRbJIo5P/Y5via+Pv+iaGtuFnUiUIURyR1tmFI97Bw91QU0ogjv3lNZL6V4TE/1YfPWH0iHxcS8akgZw85uq1TtNY4dLhXuhlm9ScBM48SK2nOalXDKRmWynPpH94+2sbiyX7UjLMEsLdboAIKAllVf9HH+uafo9bSpBuRxEqjKTsh6cp0H0mNcTQkABzQlOR0Mfxb8IpsPFnZwFFux0bWgas5yhr51G66VI2WDvOwrE14RldbB5g2CKzdz13a9YuqZgB2fP8UXKJWZICiceVsAHdnwa/HLIA44/Qy3o3vf23guVTUERPMEKVoCNxm4wFZ/zzc1ufSusXh/0OGuzWpFxZMQW3BqHOQTtLP3A98TeikzZNSzXTVBHushI
 l4T6a+R4
 sWiPloWkMqUQjHxOFo8amSxjh8dCb6lEviXdN+sDw0ooSWMU8//Arfs8JUB0yIioB8e938wd760ghaP7rZYYUhhpYnm/gvgVcMfGajHQviN41vhXJd2oqqao20IHSIyIRa3DOodo51VVgVBIsTbHfQ2Qc69RktA9pgAYhDdUpw9r5Z+86OgRsP8Vtg4c+2R2C+zBi3MK7GgpwSb9sP+0uUjaKlfkHiSY6BxO1k8arRc9tytP2Xm8szHIf2JqqQciDZ2AKeUTgLVWorlvsODFk6ISure3yPQp0p3OZtkNuBnqTpyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 12:40:48PM +0200, Heiko Carstens wrote:
> > +static __always_inline bool is_lazy_mmu_active(void)
> > +{
> > +	if (__is_defined(__DECOMPRESSOR))
> > +		return false;
> > +	if (!get_lowcore()->lazy_mmu_count)
> > +		return false;
> 
> I guess there is opportunity to generate better code here using an
> alternative and using a flag output constraint too.

It is only CY and LT instructions that make sense for me.
Here is what I came up with:

 static __always_inline bool is_lazy_mmu_active(void)
 {
	unsigned long lc_lazy_mmu_count;
	int cc;

 	if (__is_defined(__DECOMPRESSOR))
 		return false;
	lc_lazy_mmu_count = offsetof(struct lowcore, lazy_mmu_count);
	asm_inline(
		ALTERNATIVE("	cy	%[zero],%[offzero](%%r0)\n",
			    "	cy	%[zero],%[offalt](%%r0)\n",
			    ALT_FEATURE(MFEATURE_LOWCORE))
		CC_IPM(cc)
		: CC_OUT(cc, cc)
		: [offzero] "i" (lc_lazy_mmu_count),
		  [offalt] "i" (lc_lazy_mmu_count + LOWCORE_ALT_ADDRESS),
		  [zero] "d" (0), "m" (((struct lowcore *)0)->lazy_mmu_count)
		: CC_CLOBBER);
	return CC_TRANSFORM(cc);
 }

As result instead of gcc code:

	lghi	%r8,0
	lt	%r1,1032(%r8)
	je	...

We get more or less the same:

	lhi	%r1,0
	cy	%r1,1032
	jne	...

The only benefit is [zero] "d" (0) could sometimes avoid LHI if a
zeroed register is already around. But also the KASAN coverage is
not generated.

Does it make sense to go ahead whith the alternative?

