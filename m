Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08ED4F88084
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 07:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507A56B0005; Thu, 16 Apr 2026 03:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEEE6B0089; Thu, 16 Apr 2026 03:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5816B008A; Thu, 16 Apr 2026 03:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E80E6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:01:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2504BAEE6
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:01:10 +0000 (UTC)
X-FDA: 84663522300.08.D206560
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79D28A0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:01:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eDBCBKzn;
	spf=pass (imf25.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776322868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpWKg8ZeDbqHc+7JPbph+/kdcpPxNBq7qyNbqivMtDY=;
	b=hiDo/+2VmQQi1aGn2KwoqnQ7OJWLabHwnYmtNtOIBpuQco13CvXBsSxFvIlpIJQqK2XmpQ
	pVexz0u2vlu0r3++A8BQbiKomxKJUlJEJFPVitOCxMTrurdLF+pUMef0qaMSFkuGpQL7CN
	eRK38m7WGUVSo5VLQENUzsFn3PCJvWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776322868; a=rsa-sha256;
	cv=none;
	b=ebou+aYBbF2t1acbH52MnukJn05vu2BpQrae/YMdc9Sj+iZS2UxT7wnD5sdhMm/ywe7mH7
	cMBXGZhAiEb0ztkVOy1KSiuYwh5oMInnIA1WGQTfsf0Xx9MiQg9rQ/iwDhxh+2M6TkkXOA
	WtCIDf/2kZtglVmQQBPhu1bTXgJDbBg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eDBCBKzn;
	spf=pass (imf25.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G6lfGh1804738;
	Thu, 16 Apr 2026 07:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=tpWKg8ZeDbqHc+7JPbph+/kdcpPxNB
	q7qyNbqivMtDY=; b=eDBCBKznNt3jY/kLAZsk7N4s8l7xfVjF9Ic4BOjhJ4LAXt
	etIhdlNOwtAWaxJI4Nf/aU4FZs1S+ooUOLIlFceqgVARZD6/CgyKQ/66C8hQ5v4Y
	DAdv4GmCyaaoA6K7ztS4lDwDwq3cU2oCB3muhJXZH3aPdc71TTkh3vxjFQb7pHvo
	56ccljwkNFXShw4BYTaLYeB9EPxMmVWGqAbGkPTrz6ym3hwyIosLM09ehyR1PHdb
	35+PV15F1ZwIy/q72ojh1xDehTeYu4Cc/9xsgOGQifToLSoJfSv59tkRyHC9r2bi
	YhT2K51OUhBrfnnF7LDgUpsG8qAFFGSBJXZ5Jlbg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89kbapj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 07:01:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G2iYuP003379;
	Thu, 16 Apr 2026 07:01:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4djbh93ch9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 07:01:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G70xgm27132348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 07:00:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4305320040;
	Thu, 16 Apr 2026 07:00:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CB1D20049;
	Thu, 16 Apr 2026 07:00:58 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.42.253])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 16 Apr 2026 07:00:58 +0000 (GMT)
Date: Thu, 16 Apr 2026 09:00:57 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] s390/mm: Allow lazy MMU mode disabling
Message-ID: <2a497bff-1773-4245-a63c-784ed8853b11-agordeev@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <24d843c5568a8b591cbbe16eca092e7f45d18cf5.1776264097.git.agordeev@linux.ibm.com>
 <20260416054405.10407B6c-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416054405.10407B6c-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i30Fjl33Inahe3fkQUhSbi2uCpwkt34E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDA2MiBTYWx0ZWRfX/2vOhPPcKvXc
 WK6/l1A12P8h3ZP2yfx/j2LMudfxp0UCndGSoqXkxgtmZHnVs9cxUp78MM6DaB0xH83+JzQO/Fe
 WHmONGSbdOQ3fMjSvuZ/V44KzMe5xDDi3D3smgAEH5BeVD1GIJluOzjKlNK5aP5DWmi3zoE+/aH
 I4LSO4RHkWbVBYLwHZjBRZwgzHByL2vC4SRKbnP2NvKICgycje8DNJS9Evt7l0fGY2YmWuG7vUG
 SClN+gejL3roR3e12Q1AcEETd9lmTkmoEaUmSPEx4zz9/wa4c4BHtohF4o33tdLrBNNErIKuUfS
 F+knZw7WiHWvCr+9n8wU/kTHuEzvpbzaAiDMdmB0Jqyl1Mv4RbV+DWZ4/d+t3TGvP2wFpK97+Ou
 48XidNPdeJC1SJUx/8EXyR3WU4kFLyMP6U9r+P8UjciQRR/nkQqgqipRCNwHtU4u20Fx6GHgQ7q
 9Kw++wK02bkPuc1q2fQ==
X-Proofpoint-ORIG-GUID: i30Fjl33Inahe3fkQUhSbi2uCpwkt34E
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69e08930 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=ov5kqanpoNFzf825lJoA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160062
X-Stat-Signature: twjntp19egohip1pyoshntm3f3wpaaj1
X-Rspam-User: 
X-Rspamd-Queue-Id: 79D28A0005
X-Rspamd-Server: rspam05
X-HE-Tag: 1776322868-76842
X-HE-Meta: U2FsdGVkX193wGAU1qP39/7MRLZZugTmtFoiXB61ZN0FM4+u5ckyN3Q2pZOk63Eio6Wor/Yip6potgqI05e6yivGrm+izfHtJ1PhZO76BMRDtr0NImD13kOgD38DlcJohU1v+7zIH+rpTHl1lQybOENOCy5tFbYGdV3eJ2uYeYOtmBj/mJn4/YPhxiezjnSwzJQDo27Vd5NM5AJe/cewJT/WL2HaCCP1s76EIHYS/ppjzxX2PQpVUIf/+FHpaR20550lfQ4rBp4IrG4K+EKlVy/Jp4ruzA36Kf897UEOC75kRgBtVfLLOSyR9h978q+mJj8sMna0wCMRKpes835wqvFH/B6VG80Rau1qeLm2lFfcC86Abx6ERI5N6OGrLhXj4uWOMiS83/gxHHLUulnd7xEbkB33pg2DJqYxWj9lQM135wO/f2qdWWQRO+nU8eG9jQWaEbXByUqK/N0K2aFZtxh0KoQdl8CfdQpDQKullaqjoXicA+CQyHL0lCNoTDT1WYDs3Gb1k6YKDGJK4XdgTWmBCMGT8l5tGFBNaQEH0ugWACfFNcja5EQ41X7Ovsj5mNEzYuGxs2LC8L3gVgI1nAQUcSc7oQyAiwoiv3xRP1tRpt3eME5Qc/9JIPzSDFreItcvraJS6DUw7ATmmnDPQDT7XQn7MZ81bZOyfTcyJYC3R3ozHby0fZOwrTiE2T2Y464QS99mIU4x3sCEK+uXcD3eO4PPF2bpjLosHuSxAmrpIAsYDkuDnJsd+gZH9xmyhKhas5xYFraKmMqoxnJeuyCVwyFtTFG4W/2IglCCxplIzC/sRCz1qFUTZ7jAOIDRQcYKTH9o8xDCoid/R7iaH1AeRmDlPiomcDXgWeNyI6yHffk6zFPKRSBeROk3rpA5siO5EZxyTlQMH0v62ToEZQczexmjOsz5J1lN1K2yySxfFjcDLm5FY1px1rLIKpcFc45Vb1mzeLh35w4wNvB
 huF+MKb3
 hNZRB90uQWiywKmj+LBFSRmBGtqaJTyUHumW1FzeNGWhBFI/ZsQiiXtG9VxnCjqDThR2skzFiZSgkMHyjlQhJVtPEZQ8gWO2Fa1irGn4zrNw6t/sIo1VF4Ih9ui2WkOqa/zeS2WqzNKxoRTrUtRZEQBbFlrlcG8l8dc+VGgyzcGuXK13yrr1ck5oP2ivcLVzvr1LvFoNinNuMkCYzk+gmECZGge9LkAOmlbRvtjf7jz+i1erfutzD1MLdDY89sLqpmpJpBlXgq/oS5R3sXKO3Oj3WxmS3WWpV4/thihmvIfzvZjLSvsILZ+cWMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 07:44:05AM +0200, Heiko Carstens wrote:
> > @@ -169,6 +185,8 @@ void arch_enter_lazy_mmu_mode_for_pte_range(struct mm_struct *mm,
> >  {
> >  	if (!test_facility(13))
> >  		return;
> > +	if (!static_branch_likely(&lazy_mmu))
> > +		return;
> 
> Looks like there is an alternative chicken switch available: remove
> facility bit 13 from the facility list via kernel command line option.
> 
> Unless I am mistaken: that should be sufficient and avoids adding more
> code.

But that would also withdraw multi-IPTE from other unrelated parts of
the code, e.g. from __kernel_map_pages().

