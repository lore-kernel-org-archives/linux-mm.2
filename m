Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62529CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7799B801B8; Tue, 28 Oct 2025 15:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751B380199; Tue, 28 Oct 2025 15:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666FB801B8; Tue, 28 Oct 2025 15:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5619280199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:37:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0A0159773
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:37:20 +0000 (UTC)
X-FDA: 84048531840.16.CD91EDA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C9FBC0003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:37:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UUV2eGqD;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761680238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcOgXcqOFnMC08vCFQWhhNNhOigL3jq+jhyzDJAMb48=;
	b=xPwOhrPg3inYcKJlVpn1FO/KJNTrmsjwpvKZwwCJ4zWYygA1n9zTd02IjDOsSyKtVnR4qt
	AR8tl1cJJma0n93YsbPgLlYZew11IrK5SOKluY/eJwVO0fVqXkCqK4BH5wHgyKvYu8rDm3
	rdEzLseuRyJqiWM2FrJ3Jc0GsCFOjqs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UUV2eGqD;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761680238; a=rsa-sha256;
	cv=none;
	b=KZlcelPe1h80fUfjIzZtZ9oxpjXmsPKHEAJ1AQNR7Tn7z+Eu+9pecOfliGVs//AqQ4CIir
	xnwE4fBLKCzJ0MQ8QYLtdgjsCXWAkYNOwPFSXqFn9+cYPlq8WMicpTcXregmTwWSAEKX6R
	JiccxGpjLcNdVaM+WMh2DvPXgmV2c0U=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SDbXo2018371;
	Tue, 28 Oct 2025 19:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=fcOgXcqOFnMC08vCFQWhhNNhOigL3j
	q+jhyzDJAMb48=; b=UUV2eGqDCdRk71FQY5mA5lZyUbCbIv2NotsZzhjNqJdP3a
	zK9AjqfArJYOHbJ4W0+bu0iHcaJqs0Jp0QaRZH6NgujGjQVSM7iXTn5VwSRm2DYW
	+7frje1vhvcSZtF3h9vdt2ZRcxSO9jbi9lkaHjo75/hbAg0x4H62SpXQvmmOJSmp
	GU2BhcoHR+7Naq7KUqngh89MpGkIx/bviJwCC/URqE7X1SfsLaK8etEFpCBh+sn0
	Hd2wNIBSo+iRuc9a71lSLgJrcuuMlttIifP9rh1mvXBjfLHcXiIwnenCobIZ1Qj9
	Dw8cg2to9R789K+EhuO7c+bj4VeAQbCFklObnoIw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p81xey4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 19:37:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59SJLgqt030817;
	Tue, 28 Oct 2025 19:37:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33wwg1gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 19:37:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59SJbAki37159282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 19:37:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8832E20043;
	Tue, 28 Oct 2025 19:37:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB8F420040;
	Tue, 28 Oct 2025 19:37:09 +0000 (GMT)
Received: from osiris (unknown [9.111.86.120])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 28 Oct 2025 19:37:09 +0000 (GMT)
Date: Tue, 28 Oct 2025 20:37:08 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, osalvador@suse.de,
        akpm@linux-foundation.org, david@redhat.com, aneesh.kumar@kernel.org,
        borntraeger@linux.ibm.com, mike.kravetz@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH] mm: hugetlb: fix HVO crash on s390
Message-ID: <20251028193708.7213A7e-hca@linux.ibm.com>
References: <20251028153930.37107-1-luizcap@redhat.com>
 <50d815a1-8384-4eaa-8515-19d6c92425b3@oracle.com>
 <20251028161426.35377Af6-hca@linux.ibm.com>
 <5c72e064-9298-490e-b05a-16be6b5590b7@oracle.com>
 <20251028170251.11688Aa3-hca@linux.ibm.com>
 <4f522b65-1ab8-4725-8da7-3f071e7919c1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f522b65-1ab8-4725-8da7-3f071e7919c1@redhat.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=fIQ0HJae c=1 sm=1 tr=0 ts=69011b6b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=f0Pcmk6uCRRijeZF_SEA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: ZIIeRTfL90xSM42Fi60shxNf7BZy0dhp
X-Proofpoint-GUID: ZIIeRTfL90xSM42Fi60shxNf7BZy0dhp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAyNCBTYWx0ZWRfX7+qngpRd+nhm
 /sp757299cAtgUe4mlSUay8+yRs9JiuYNSihUWaB9g8OQ4lFb7tsSQdGTqjgjMLApRrCiEOb75y
 FYXLVxaAgLS2Qm/kMkQJpZ2viAOH+ODIGJkVMF5N7K6XvLxiYJB2vH+Gnv7Pp6S96aOoujozU0U
 Xm4Q1WeAAYDaODGNh4T6MfV66OVPP8Dnu4nwpdf+SL+29TmLrAz7TvmcZWQ/Y/2xlwmKLUiar8K
 bb47GRSkWpc9qIAXETDyv6QGlZwJGkxIDUq9+4EZJKMgSjCrRpuTRf1RX4HujpDdjs6RTm6UngO
 sEamq2O4vHD3ikBMncC8glIbvdbfixV5MIKMPw1hPgzGRQae4USiv1Xyb0U4xx/C+LiLt3WbRYU
 fygbAbHeYtGxx22TffGyBpoH3QgoEA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250024
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C9FBC0003
X-Rspamd-Server: rspam03
X-Stat-Signature: ugoapog8k5rgsrpwtacpaw4t6w5e4gnk
X-HE-Tag: 1761680238-947720
X-HE-Meta: U2FsdGVkX18YKA92GxCaj6Dj4CtY7Uhzdy83aaF5MDoJPXN3Ro5R2gYludQ25e4R2+eBJgiVa0jKuM3x6+bFp/9O9yvhtdNPgX+NSAd03+ZlL5dM4S/CwXhpg6E6fnlLbxEf3Vlm6b5/OxLbjQYAv1DoKzBhUyAi7USF4zvz8a7k9nj30JeNRKu2udDIlj9UiCrkFyj00JRSCMZ3RUFYoOJVe2B2wM3/zyT+tIxs1F1TRHtGO+BRdwvg/vsuwJb9uaKbElY5H3KBB3F7NXBashHM4DOtTlpvph8ETg1tznTHo5UT0kxqMiqDim4/8ZGX+bcP5wUeljae4V5SUJ3olkACD5xV3CCD7negcRwjPwpokmcipT/UU0mK0Aj8SCjlR99hl78LM2XTcTzibeSBcQSkbBKvCE3B4+iWwrhjI59GRYC0vSzvK7Jbdzzz6wf+OC62LsCPUe4xa8MHgrhWvbctsawE/Ir7RRpHWDXIfg7Srn/iKi7Ip/QTL0erMWeVcUEwfL8AHSebKmWZxtkkR7uJfqopjQSXNUQ2Dtmg2eCvdJEQLZr/rOjFJ3sRbMAEYWRg5S3w71ryaJn48aGi5bxz4wtLTnNV+3Q5/aHJ0Q7bF7k8g1PH8Ur8vk0mgb76RLI9V4OSMQ8btg8rN12tzZpz9YcUbJBprFCzwAen4mjEbNye1+vtgPn56wHz+xr7qklENaz2SLFWcSk5iEfAvGrOOgIriIymnxeQoTWZHWTcehAUrZfHnG1RALNlQKVfhUVbgWmRE5jZPBMEdCdmFJ+ALWOHQRr3A/VKlKdJDzQkGo/HkJNH1dRxRQZ3BN7hn/uyg41SZRS4YIwu9w50BJOkE83eHfImuwmXn0e2s7/e3/SBoKCLWrTzGPNymmTC7t2PYUgP3u5jpV2igus2NRNjPqxB0vx7Bf+N7QciIEL6puETdW6dB9av7f1MvcHfaa8oy0gXJguXlOATjoc
 EfT8RhOW
 Ks7/hGPqDirujMmsQ4CcJTRTn/zJv2GqLGJFuUS8y994Dm1MGNxYA7lb4ifQ18TVDMQHQ+xODTofPrENVkQeFx6rLlXHnL7hSYX/t240MLW0hvi/TKjq8SVqUwzyieibQunVkhm7/sdlmaltKoNw3n6PaIDAvpcANuOy0NllSdayrUmj6/28Aq4aw5i+zdcTaQk3APXRGgnf+t1qlk5zyrOgkd+LRbJT1o2p0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 01:15:57PM -0400, Luiz Capitulino wrote:
> > > flush_tlb_all() however is the *closest* equivalent to this that's behind an
> > > arch generic API i.e. flushing kernel address space on all CPUs TLBs. IIUC, x86
> > > when doing flush_tlb_kernel_range with enough pages it switches to flush_tlb_all
> > > (these days on modern AMDs it's even one instruction solely in the calling CPU).
> > 
> > Considering that flush_tlb_all() should be mapped to __tlb_flush_global()
> > and not __tlb_flush_kernel() on s390.
> 
> You're right.
> 
> > However if there is only a need to flush tlb entries for the complete(?)
> > kernel address space, then I'd rather propose a new tlb_flush_kernel()
> > instead of a big hammer. If I'm not mistaken flush_tlb_kernel_range()
> > exists for just avoiding that. And if architectures can avoid a global
> > flush of _all_ tlb entries then that should be made possible.
> 
> Should we take a v2 doing your suggestion above for now and work on
> the tlb_flush_kernel() idea as a follow up improvement? At least we
> go from crashing to flushing more than we should...

That's of course fine. I guess for stable backports a small fix is the
best way forward anyway.

