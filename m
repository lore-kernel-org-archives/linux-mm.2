Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24335E9B262
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5526B0088; Tue, 24 Feb 2026 08:05:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5722D6B0089; Tue, 24 Feb 2026 08:05:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475C56B008A; Tue, 24 Feb 2026 08:05:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 349B76B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:05:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB25F1A0137
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:05:14 +0000 (UTC)
X-FDA: 84479370948.25.93AB140
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C1384000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:05:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OVtLzw38;
	spf=pass (imf12.hostedemail.com: domain of gor@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=gor@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771938312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wO64/dkjbW/dvFC/vqTXMyNPJLKJF7tJot1AAAqsBp4=;
	b=RKd+9qYYS1+cD215jFVPY+2m+mPcv227LgHndvDCww0EELJfwEH0He4gCN0dUSMU9XIqMi
	ESPRzHozwBdAeQl7WdjpWVLZ2GB4IGick6+ppCkPNZbVB8ghujNhL6cREdB2ziC+5gVuEf
	M7FP1hfzUoYCc8QCXDCImUkzaAK6eKw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OVtLzw38;
	spf=pass (imf12.hostedemail.com: domain of gor@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=gor@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771938312; a=rsa-sha256;
	cv=none;
	b=5lbYF3tqyTnB9Wqr2XE4f/R1lRalN/bB9VE1x+8RY3KgFfKb0VgWYD2ok2oVMUbuPeYB1i
	RM2xQid6wnil0rYR56V7lKFBTLYjPcZl8bugCXld8gig6uVQ/zCxsnosBz3K62xST+X4Qw
	0w+4whXoZCkDAoxDA234Ix44Y6lyfiE=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61O83maL2345992;
	Tue, 24 Feb 2026 13:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=wO64/dkjbW/dvFC/vqTXMyNPJLKJF7
	tJot1AAAqsBp4=; b=OVtLzw386cqqEN37RlRH6SOPVS0YfpM6+NNCREe1cEwYeg
	O7FA3I9ee7WboClZR71kA5J+WFSubxzJC+nE+aJypc3bjKqXgQCeDf/4qTy5SKhr
	ZhTaoJIPi9HIcvAtdUN8Ks8KIcJ6aB5ipwyzjSA7QQXQvsUl7hEtmuy7qpjD9ftr
	fR7lnjFAJTuRe3c0ZX+kDTM29i9GtoqMqLZWyI6Po6asx10ZCZTh6RU0HlnLZqjZ
	7z7LU2cq15D5/dVqRXUbKSvcly+RBU2lFfFWN9v4v/snifEbXfNrG+9nKnyuQnJP
	ubiYhIbCCpi66j+0hwlJSYXTRljAozQhlnGyLidA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ch858h0m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 13:05:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61OCQq3G013438;
	Tue, 24 Feb 2026 13:05:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdy118h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 13:05:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61OD4xLB57475566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 13:04:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63BDE2004B;
	Tue, 24 Feb 2026 13:04:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCBA820043;
	Tue, 24 Feb 2026 13:04:58 +0000 (GMT)
Received: from localhost (unknown [9.111.88.84])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 24 Feb 2026 13:04:58 +0000 (GMT)
Date: Tue, 24 Feb 2026 14:04:57 +0100
From: Vasily Gorbik <gor@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org
Subject: Re: [PATCH 1/4] mm/page_table_check: Pass mm_struct to
 pxx_user_accessible_page()
Message-ID: <your-ad-here.call-01771938297-ext-2808@work.hours>
References: <cover.1771845678.git.agordeev@linux.ibm.com>
 <68c2f6df2955033cbf1ccbd2b5c2816e72ac345c.1771845678.git.agordeev@linux.ibm.com>
 <20260223101335.aa3696d86341260e03989ac0@linux-foundation.org>
 <cfdc9b3d-06fd-4cc1-b946-076ff1479c66-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cfdc9b3d-06fd-4cc1-b946-076ff1479c66-agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDEwMyBTYWx0ZWRfX82K/iej59Gbi
 jcOJ4LV65vjd++THoXAxHcOdHzl9vxwXul+tKmMciocrWFcM4MzDCiFMma5wnoQRFwQzwk2EUBo
 owgONljOlgoxYQ/sphxEac8MzWSTdSTmmJ1euVadS2kLw2mK651rPT6pc4Y8JUKpz9+kA0i3Qdr
 0NjLoQ/uXZ4ylbetYJiJi3eLDnxuBmvkISzhb5p3iHvDssAio/iJP3IhtlhLBtIntIKgtZ9jvQY
 N9UvSFPPSWb+D7jqlrvouPooEObPd0Ls/OaMZsv0oPQpzoQWIDGhIC9pPsqz8KYKLAxWPGkOYqe
 xvgEJpXH9jQLtd4G6OrmHss4/N8DuG3FasVJOptPVsjLFxrmQpgI9vS48WGLo4GGfHF/pUL//u+
 dzDB3AI8mMgPzjh+Uue9Gm/engWga5K7G9IVgo/bX9fukaUzzkeWhv/HczqOxdZfsFvXjrwQOyl
 SfanzqqZBDLrB1sjlbg==
X-Proofpoint-GUID: -kGng4CI3unx1jXZ8zqVfjNMiflOOOSx
X-Authority-Analysis: v=2.4 cv=S4HUAYsP c=1 sm=1 tr=0 ts=699da200 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=Z4Rwk6OoAAAA:8
 a=8RkruKr-LY4rosFeA0QA:9 a=QEXdDO2ut3YA:10 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-ORIG-GUID: -kGng4CI3unx1jXZ8zqVfjNMiflOOOSx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 impostorscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602240103
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C1384000C
X-Stat-Signature: sti6i63x8r7ghekx6egziqgzxarzfjn5
X-HE-Tag: 1771938312-55562
X-HE-Meta: U2FsdGVkX1+7QNVoroLFEKoOoF5tk9w+kboHavR7hZTWAKS/aDfkmsWBHJ3apz/4ctYwtxR9aJhXbM3PrXG3uxdhOcWHbnwhl7uLjz2e56mYkyyDHZ6LUrbSccDEhR+yPr5byfoWO6o2JIhewVMWJLlQNt+E2vyuLNF5vtvIPYlU47+BoTjIEfeBuJGwWNfM3ek63B7FxLHbmjV3Qb8RCikxz9DCWCtgahp2mbl7ym1oZJTQvRe3TjUsOisxIWHYnjLA2J8+ehw+379h7fMn3PZsYDUX8WcW1Ghwzyn45cM8JAj10TVjJON/tneHZTEvZZFm1wjcxEZHipxtuLr8/MhcOSrg+BdM1LHFgeE7RzOLVfSKD6OMBwbwnmow4GrdiS0w1zsLY2lf+jXPv3LhefMYQZczVGEqMuhEXGUPYjDgbyzxu0IojVfj0cYDP7HobMa7jfVWjjuJuXEY6cJIyuA1ciOX3D7kp4y2vGrz5GjrxWs1TWO86D6wUnxZts1QMeff7eOmoeJXXNEgng90/goWiMjLcAvKfcmnwwuhibY7/JWy1AULlYwA3VBP8ZEhT77RfYNrn3mfQyB15+NR8RLiaog3zUICnq8XQdbPxkn032GI97pfePYm52cOvGClOCke9h/gWDi+8/E5FR7ojvg5bnl08O1yBWbOc96ko4yD5Ip0L0CDcBBTQg1EO0ORfOgGqmuHHyIh/AECmlvTDYtlS2Kmo8fTFOrzspAv9CvIN7O7RJIMwCSRY86Mr/LQYUM70rK4jrETO3MHfa774ToLmkckzG6HyKMDI3cSlixNRianpeU6d48dk6P8MiSILJYOPWiQEqXTJ5/vrxhh8yaQ4SkpInQP94Od3MKuQ4r8gZg7xeVKyb96z8lzQt/5kpmVFN63YgfuVx1ZR8qpHJWUk5ZSibAgH6+8MExCUmiPXZg15HBYT5UHh5CgFTFmWB4LVvhgxnvNRD3dYn0
 A7kGYrKS
 pjD5SKftYAgvbzGv3tU489Jq1wZMn1diG8NfbfmQ7MiQDOYThYaLX+on1GjxWaIcvbycAt3NYag0L4D0KrcUG981LI0Q4gd4f5Fc4tTWL2gpg+MS110yvWQ5OcLbEbP7rzrsf0MpIjgFCMy12s/5cz3wiz96wXHwgtys82qd4vv1slkE6NDlJvT97PNEb2OuLa2gSb31BQU5NB3dTeccp6KSU2e+MGz/TLchxg+yYYcUv57q355OXZY3EiIMBfMu4GVM9nvd17mPEEiDsnQaroik8a+NWtzbw66I1nxyrQoeQ4et1cdkyXHYlpfshD2SQD/mGO9rb9XpnkEU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 07:06:28AM +0100, Alexander Gordeev wrote:
> On Mon, Feb 23, 2026 at 10:13:35AM -0800, Andrew Morton wrote:
> > >  arch/arm64/include/asm/pgtable.h |  6 +++---
> > >  arch/riscv/include/asm/pgtable.h |  6 +++---
> > >  arch/x86/include/asm/pgtable.h   |  6 +++---
> > >  mm/page_table_check.c            | 15 ++++++---------
> > >  4 files changed, 15 insertions(+), 18 deletions(-)
> > 
> > Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Thank you, Andrew!
> 
> > I assume this can go into the s390 tree?
> 
> I think so.
> @Vasily?

I've picked it up, thank you!

