Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 162BDCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D96680199; Thu, 30 Oct 2025 10:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B16F8E007D; Thu, 30 Oct 2025 10:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0CA80199; Thu, 30 Oct 2025 10:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38DB08E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:56:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1551138EEC
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:56:33 +0000 (UTC)
X-FDA: 84055081866.16.5384DB4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8EE00160008
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:56:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=L1pfcBeR;
	spf=pass (imf08.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761836191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Les6f//qwBT7/Erw4za969+5qvX/0Mzpxi7KAFPadnA=;
	b=kGn+gV3nd4bxTy22tEtKwB/40xoqhBx6jadWvJWqJhB82Gamiw6Dtec08YP8zIE6FEyZ+B
	RYXcDlhDJu0jdcPsFajV1iu6IMr87lYotoEpzs8oeupcjKHdSQe4xmolsWNzyGM3Qf7TQy
	Mv7qQqJK1oJQPNr+qtmFws4WD0Fx5Wo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=L1pfcBeR;
	spf=pass (imf08.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761836191; a=rsa-sha256;
	cv=none;
	b=Ni5a0Q1QWvPow9GM3TJ2SoIeyi2mJEWE6i5sDzEs+4/gR1FRz84VU6DfRxTV/BpDgWuCH1
	CqBk97AcEs2MloSvO19/NLFHgoxjc4kuTaDKKi/8Hq4POFrZpuuW+OdebMn2je1Qmirxut
	mLYs2H554fojp0OibNeYRSsyEfZ4fsQ=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UBTrpW008927;
	Thu, 30 Oct 2025 14:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Les6f//qwBT7/Erw4za969+5qvX/0M
	zpxi7KAFPadnA=; b=L1pfcBeRBc/hIV/B3J72+7YGIwGLymjDNzecm8E+Qus3LN
	h+q+8857ji/E2khKKqlmrjYTA8X2BNcM5s8xunVFqMvV8xu/8+KxnLQpukXebuiW
	iCrPdPadePejoV55KadFDvbQggdU09YoT4cWRJFVCKUHlhhYpRC1x+QwITxNKgU3
	uIQNqQhwFdkDgV019xHMhmZbSGYWV58TVB7WKsMDnWhZqvFMlmS1oGrmr4yvlh+4
	wGWpv6dPUjZGWIhnxluH7HAhI+AOsqx2B3CZPDQv6QyYtDn3VkZ5Vgr8QlhU3gUD
	a2FO5W44+BgeUKXq0QU1khkHLn4d80Pc8BO+9W3A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34afh1w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 14:56:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59UD9GNh030817;
	Thu, 30 Oct 2025 14:56:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33wws9sq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 14:56:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59UEuNC048890168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 14:56:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B523520043;
	Thu, 30 Oct 2025 14:56:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63E8F20040;
	Thu, 30 Oct 2025 14:56:23 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 30 Oct 2025 14:56:23 +0000 (GMT)
Date: Thu, 30 Oct 2025 15:56:21 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@linux.ibm.com,
        joao.m.martins@oracle.com, mike.kravetz@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, gor@linux.ibm.com, agordeev@linux.ibm.com,
        osalvador@suse.de, akpm@linux-foundation.org, aneesh.kumar@kernel.org
Subject: Re: [PATCH v2] s390: fix HugeTLB vmemmap optimization crash
Message-ID: <20251030145621.16837Bd6-hca@linux.ibm.com>
References: <20251028211533.47694-1-luizcap@redhat.com>
 <6bbdf4ce-10e3-429b-89fc-ef000f118fec@redhat.com>
 <20251029104457.8393B96-hca@linux.ibm.com>
 <9a8254b9-92f8-4530-88e8-fca3b7465908@redhat.com>
 <20251029124953.8393Cc7-hca@linux.ibm.com>
 <20251030153807.0a835fee@thinkpad-T15>
 <bdd4ea3a-f326-4eb8-866a-52b1ea2bdc5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdd4ea3a-f326-4eb8-866a-52b1ea2bdc5a@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eJT-qssreGV4OP2Nrdb-clNTopJMWB1z
X-Authority-Analysis: v=2.4 cv=WPhyn3sR c=1 sm=1 tr=0 ts=69037c9d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=byvkRpKd6ojhK890NEcA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX/aNxGWQWVx5c
 Q/e8N/+TAYD1DoLooorVyX7Wqk3cr7aZOB1WNj3KaFmJ4reeZ8/JxL2z8SrQL79CvVKfvw7iTJr
 Bw24SnuOirymBobzMMTGFsH2AGlyys7DXe3fQByUuW65oYsEQSdPnrE1V4IkhXYTioqlKhof1IJ
 RnDjpN4xdyekSrpkH36gh+y2e6HB3a2WuG8pDAwCjXQKYMY9WlslqDIUuOANyV+9S0xByRhDk8v
 lzXbhpwYs2TyEzJ1KzTKBgx+PYoRamifbCRbCaX4zDsa6Ds7yMWdW+memuEIwHlHFWp8chqkWa4
 Ya4515iA81bSMMT/5GAXZyDwAdKb6XtPNlSrVcL1rt/EROMDO2NDi7p4OwpFWxvZt0hvRligFnQ
 6a/YYPeXtyzTrbHv5+Uz59GCDEHiEg==
X-Proofpoint-ORIG-GUID: eJT-qssreGV4OP2Nrdb-clNTopJMWB1z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_04,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8EE00160008
X-Stat-Signature: qepri7n1strn44kq4mm69wtodsxb6hh8
X-Rspam-User: 
X-HE-Tag: 1761836191-282466
X-HE-Meta: U2FsdGVkX1+jnA1mZ/IaCXVZ1gAMmY4rWoVBenABNcUOj5lZu87yN5wmkNmzB2DhmzMVLTJqZBTcvIX0i6EiADOyYGqHBU/3KXPT2R3K7h5LYiPwsRAR6nA2GHtOCkPwg5a8i8M7xbhbcAw5ehvlr1gYW+pcO2R+d8iOJnOKyCSy5847KPuPbO6hEVbiMDeN4zMpG3zQ7Ti5DSzLr8yvXSIBMzG04DBxtaB+q20iYdRaHDL4ZYRXbZgDsQ4Hz1C6b6WC7B7dhCT2ShSTD0GZNX+mhYxypkj0XliCUZqBB6aXMKInoaJpbfAduXt0gGaI4feEqTbVGlWKEDROl6IRPRJxfBZTAF/qdT+nms7+z3L9c8O6Nk0NxoDDYkXr1MTZRXzMaZXIHmljXFP0zAAhkiK8rUgeY3TDReIiVDX+nImUsDhbV++JTZcPy7yEcq8jKeKkran9G9AFteXhXsYC1o2wKFBuhUQxVp6q/HUALF8CJ0+mEFgfqDSyvSXZF87ZR88o6qaPBhMaow5kEmP5HDhCD3dQnUm/0UjwSeLbGm7sJiZ97dMRxyA0uK8PkpHpIuk36W4dNKRMb1URan6wHgilsCI1MJqQVOQb8z/08VTIU4U5etXOm6m1NgZx7j49icLzqrKlRz7h9V09236CSNGj+ITGAAiITROlSXBeyY1vI8zbcCEwpB8YyUM6/9Cb7A4u7J0xIdk7Byc/qhXlLERFlDKjNxgHVkXSm2npL9H31ekl93pUT4TIydXnr4M8gf9guZlBwURxc3NpPAXXweu8T8T+gUiUUiSR2OT2kzVhDCj7FYuIcyscOS+Ud0VxlI0j5Ff5/xDcdgysv6ngsVtfN/Tx+3LNkOtPKRVGj/VqsZp76sB+ud7WrpvVKH4g7gaD5W7z+CSJhAHVI4n58q+Q0yoGf9lcj2yCHo6Zdvfn4sXwMFWiXhqWBj95wTER9UkEpvZegQ0/LOxjF7m
 IjFc+QeN
 fFQxMPcXnjvuX3B7SK4aWwF35o1WbIQut87ROI4/7s3ADPKhPZrHmGx+dBsf7qxjKijuCJcQKYDkLkGy2OYnn5QIzpmQXOgVnKstYF40ISRk2oDKH2CA9uglQ/CapkYcuR0aF77uQC4i4qsyNz3Y2h5ne7VojTlF5/ht2M85g3n3uTOqWb17c3A4APmN9rRE7XzlH7ouwfcr5HyUTZmGyTPkyWNEwLcku6K8Y6AI6sRqzpbeGrt8T7iL4CQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 10:54:47AM -0400, Luiz Capitulino wrote:
> On 2025-10-30 10:38, Gerald Schaefer wrote:
> > On Wed, 29 Oct 2025 13:49:53 +0100
> > Heiko Carstens <hca@linux.ibm.com> wrote:
> > Therefore, we should disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP again, for
> > now. Doing it right would most likely require common code changes and
> > CRDTE / CSPG usage on s390. Not sure if this feature is really worth the
> > hassle, reading all the drawbacks that I mentioned in my commit 00a34d5a99c0
> > ("s390: select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP").
> 
> OK, let's do the right thing. Do you plan to post a patch? I can do it
> if you would like.

It is already in your inbox :)

