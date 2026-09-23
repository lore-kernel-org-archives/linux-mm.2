Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BB5C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9E36B008A; Wed, 23 Sep 2026 11:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092436B008C; Wed, 23 Sep 2026 11:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEAEC6B0092; Wed, 23 Sep 2026 11:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D066A6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:03:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6755CA019C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:03:28 +0000 (UTC)
X-FDA: 85245345696.14.903B22B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F1D040016
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:03:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=legRpnlw;
	spf=pass (imf04.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790175806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPMS68PrdsNZ7gxMuinRUE0IfYfyKMgfUfdMr4QVRdc=;
	b=JMzDDFbq+TA6KDQ/i1XZm8Y8u4bMyiqc3JaJSBx3pd4o+wT4SvopDLqekm1Wh+nq0OgdWH
	KD5mQ1Qx86tDD4LPQXUUDGCYJJGWyQl/waEtMqx8dtL7/tVEpKEm0UeNZWDnXhFdFZsc5Z
	W4fraTkZQepU8noKm+ug+38/825/ZB8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=legRpnlw;
	spf=pass (imf04.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790175806;
	b=p9lDCprt4kaheg2SOlWv+fUvuaNuFnE55fMyOLYNYjt9RbaDMGCVd7yBXL8NMluhMMNAJZ
	J0ayEYV8bvogO2IeAERMzGZ7Uv0HAD9g2Tpy/YmsQCpE/2jOxIg6f/TalGCT2wBtiKXYRb
	e2U2PuVnHBnC2eWkWCI4ozVPsStoJ48=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8ZSiX1729315;
	Wed, 23 Sep 2026 15:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=EPMS68PrdsNZ7gxMuinRUE0IfYfyKM
	gfUfdMr4QVRdc=; b=legRpnlwwBNFRcTq/CZDs8TTt1LOY8ZALejjsTBirCrBap
	jsyVl+trUUzyqVEB8KlhRVZmzG1I9+gP7nHuVWjM7R38Czjhon0nCDw2et2wkPXW
	hjYJzJnznMlSScMmXY9HnBJbCUROYJK1c21U5FJZm1ne/wVNJLnotz3Z4Npvqp87
	kRq142raq84vNlGDsYHQpARJXMYTDRjX44oNW6q2F7XWJqlEmHr0eMMNNEaENOF7
	irM1oYV34LCGw2+Um971AUwXp3oJa6ajeQD9JopIFo3hLq26TSOECXvFjoHc8G0z
	sFo15txgDgNzY3CzU1L/ayXY65X1bDZHjUP+a7gg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgqkf58-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 15:03:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68NCLOTW008015;
	Wed, 23 Sep 2026 15:03:21 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb6qhh5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 15:03:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68NF3H9Q45678974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Sep 2026 15:03:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 969D42004B;
	Wed, 23 Sep 2026 15:03:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20BE020043;
	Wed, 23 Sep 2026 15:03:17 +0000 (GMT)
Received: from osiris (unknown [9.111.16.152])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 23 Sep 2026 15:03:17 +0000 (GMT)
Date: Wed, 23 Sep 2026 17:03:15 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baoquan He <baoquan.he@linux.dev>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Pratyush Yadav <pratyush@kernel.org>,
        Dave Young <ruirui.yang@linux.dev>, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH] vmcore: convert mmap_vmcore_fault() to use folios
Message-ID: <20260923150315.9636E6a-hca@linux.ibm.com>
References: <20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu>
 <arOa28u0tRZ-jGYi@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOa28u0tRZ-jGYi@kernel.org>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=G+OJgNk5 c=1 sm=1 tr=0 ts=6ab3ea3a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=tmzvjasgP5eedGtlEQQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA1OCBTYWx0ZWRfX/qSUEZ3ICfbP
 7iWCMIwXU5aJvSlo+TUNfSx/zcug0TQTOx7H1zGwf4+35SfwQDbGypwj+EfDXa4pjvxwrTHwywa
 aLMiZ7JeoxTII636kNUW8fw+7rL19TZEJiSnOOGrfENYkcyI/cPBlxDXnAtLX2Rw4ZZf2k1qH5+
 Nii0arC9pVTp49hFkzP+rzL2Alm6JEZYQORsRHW2r/jdPMXwzMtrafxX9acwKjRe8Kisgi5gcfs
 DMD84THhbs/RpPrGeO+mYOFjQS4F+85CpurAM8dvfIu1SFqHiL7t8In/BWSkl40s74TEb9ZGgMl
 bGoEKzESMgf11BkvY8/CJUMQMnd85vJoGzVtEOKqPGJyUWHAdfiPtGyKBYmcV8HMBNi2UFoGjoY
 Q1qnt2CVX+ph5r7n1aE2/ArbJMhaCbQ9RPkN99SJ+E15r8o56d4ZImMCY5Lf86yJUel/07ZOBKm
 32lc7ubpUXFyIkLCh+A==
X-Proofpoint-ORIG-GUID: 4vjiCbd2QrgeY-ClIPHd8SPJDf4qfF44
X-Proofpoint-GUID: 4vjiCbd2QrgeY-ClIPHd8SPJDf4qfF44
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA1OCBTYWx0ZWRfXzOYLA2lYxR2S
 pq1L4QWw/Hp6whvGa3TuUfsA494gdgXC6XF4Se6Ux5rEwrn+jSscBHwUT1a3BVjBeu+bApkvb5M
 DnE8RqZcdeWnaTvcqjmfo/TcDeKKetA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 clxscore=1011 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230058
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F1D040016
X-Stat-Signature: 8m8ngh1uqxaui3dbncatbtjje11fcga8
X-Rspam-User: 
X-HE-Tag: 1790175805-343055
X-HE-Meta: U2FsdGVkX18PH5sDWvb3pihsfSOJWvOXn+0G4iWgteDkYSuwXT43p/EUhbyaGWtmSSuZaH/BeSEHm/4ZUd5K6plcs16rDHgD1fGn6kkHrElAjUqavzYAW09cQHgT/qtN2b8Zqg55/0iq/vYgtQXrlBML7ChpmhrggNRERbGCxUrUAM6ExNMLdIdD6WRtOtTVdesFDWxCLRXMeeu4jpnqsE0w1fTBZQWU6dZkqAc8NAAjoie2HlFVqZmZtBr9b68YhXr1l8SpRYBGPvxCdi8N95I8S3s7lqLHVZYmbLELbeVlxx7bLU8TV56YZAhmhBTHM2bO5BSgSxdw4luxqiheXj5urr+Bv28FPJvuG/ghX08n18oKAqplFoQuUsQd72dscyWpOrYL4p7nwsR2iRT+DIjuOkFBw4ParYOsv/8bXdhkL/jbQJd6ZXBB0+sADLDYZ0SErcJrZgmtETo1oQORubeGMrz2/cvjkAFgWqHp2NhGvg3lIhhSgr0UQ4kuofs7zDaYJsy+Mwo0Vwq6DgFPxZxQcZi07Gi/kX2vn1wOXhpKk0fEkJ6DfJGaXPvVv+4FPsle04OLlTzWWdllXZ4Q5+shFTavT4SAQhiQc/c8606Ii1Br1iiCNst4aByyLVm57g/4MuTpSTefcR+AKwzY6PSud61eOuSTr4ZfTNbI16G8k/7Rv/o8e5d2WTC5iwPPqFJJTMKs7uRvuv6HL9FFUIhHSCMkqR8WNb0rz/fFbkH4HCX36h0u1Hwsrer30kRFqetGwlWAsiHeFduqfQs/a+QIWFCFWt7o9/ZZsbL0W3hhH3+Kq4/Ut+tEABR/lFZKvGRueyaGeBZCZ5RmRUTEKTET34FngoYAL3StP0UhzAKiPHWk82QCH0YwmMYRS5/3G/dkMmaQ5ORDC8SSXwH+C8jVEvqQyTvGe3eQJk2byVvdBYvId9kdxr7hkwCrkuIKnie/j6ae4M7YGk0Q0tq
 ICIT9r7y
 KjN9ItzNIfu2Z5Q5cpMj/16id28d6ACy6UPbAz0G06POWCqi9CiUOBMOV+47MKq3IkEtO3BJxz3lebfgXAB7C35JnC+gaPdmDKSxXD5fec8hcJazE6+qia65O7BWJGBwUYs815FD8B/jVYW5nzqPhVPJF6u6+TytPmvlo8dmcp8t+GIBF2Px0XF2szu3tA+vqg6crBRAkHQq11w0e6dM0xSFTVZjYHUlgVJjtpAADyEEy6JbTkZ++fojERjgLb+zi7sKKzrIKbDwQg400BwBRoxPLJpNkAOW3Fil2/Zdap4CNC2XXs5FzAI7H2wrJeTUgiip6z/hGHP5GUQFwUeJveH2JgVvynus7Wa8ZPo4cprgSxljNvey0VY3UJlRrOgkSmyQb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 12:24:43PM +0300, Mike Rapoport wrote:
> (cc s390 folks)
> 
> On Tue, Sep 15, 2026 at 07:42:15PM -0400, Tal Zussman wrote:
> > Use a folio for the page cache page the s390 fault handler reads the
> 
> I tiny bit of context why is this only relevant for s390 would have been
> nice :)

It is the ifdef CONFIG_S390 just two lines above the context diff of
the patch; but I was wondering the same and had to apply the patch and
look at the result. :)

In any case:

Acked-by: Heiko Carstens <hca@linux.ibm.com>

