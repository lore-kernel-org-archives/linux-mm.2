Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F35FE5209
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F476B008A; Fri, 24 Apr 2026 07:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C504F6B0093; Fri, 24 Apr 2026 07:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3E546B0095; Fri, 24 Apr 2026 07:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A01696B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:35:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A27E1C0704
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:35:27 +0000 (UTC)
X-FDA: 84693243894.30.CBA2F05
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1785140007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:35:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=c7TxfKjg;
	spf=pass (imf07.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777030525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaUHNWPSayIAoxwlfIlVDCNfQb1tmYIwvhyzCBu0cHA=;
	b=cRWLsR2608ebl3D3UJPNESD9/Q4mXDtegaEVLpMR0stxTuaiRV6vrHdsR85DRtm8t1qUz6
	wEFaUCCbfIwS7QAHIIDleYkzwfhY+iEbFPpHlpmK37kRBYGA8nbwtAXbBOlq9jWtFNqPd3
	xKRk+vL3KMvBfd57ZfNa2PhOw7/I7xs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=c7TxfKjg;
	spf=pass (imf07.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777030525; a=rsa-sha256;
	cv=none;
	b=VcdknPByRAgws/b6RxSRt/UG3VUyl4CamshpTK4mg8DUINKTc9qYqoRAKeFlLgzNvBUufy
	UiCn50+3hAN7YJnx1OWmAMZsu0a/WW+HsV17VuhMO8mWry8OygYy6T0GEvdE9Zdvqr/Sgr
	k3HKJJW0tg1JmPdhxXumo0QZGo9fbGM=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63NJmmFL3944257;
	Fri, 24 Apr 2026 11:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kaUHNW
	PSayIAoxwlfIlVDCNfQb1tmYIwvhyzCBu0cHA=; b=c7TxfKjgaWAbt13HX4LJ/M
	hunw8CSlRcWLqYz1JrEQyGFNZwTKprI6bhikDwLyn5/qU4IeAiJe6XX7Sz3QcWHU
	AQjNjQLawH5xpNcbtGzA0e8wcRmoW2MzI4Y0Otq0SVHaIOpBnj9aGNEUl+45yQVV
	AR66nxMNq4gszcaMc9EiEEOxZ4Qvo4ueYJounGTXZRx0zNOAczvrEw5XI4EOP3QV
	MXS6gtO/5LyRHXqY5ttKvrJDa8eMDdhDm0IGk5nz6aUAzposw3sYfcIudaNzaAfD
	9bAXDAlXaw7+ZAm/ftIRedg5jykUpwp8ut3CdBclsAkyCFhHQfL3dzs17l8K6B8w
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu3vnxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 11:35:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63OBKSVC031531;
	Fri, 24 Apr 2026 11:35:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dpjky2kfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 11:35:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63OBZHGE27263346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Apr 2026 11:35:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AF922004D;
	Fri, 24 Apr 2026 11:35:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CE4A20043;
	Fri, 24 Apr 2026 11:35:17 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.52.215.75])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 24 Apr 2026 11:35:17 +0000 (GMT)
Date: Fri, 24 Apr 2026 13:35:16 +0200
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
Subject: Re: [PATCH v2 4/6] s390/mm: Make PTC and UV call order consistent
Message-ID: <d0a495bf-c463-4aba-9192-c32b3d24fd87-agordeev@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <7b0e73e3c6f4000f9bf7cb161d8ca9a9f2312d70.1776264097.git.agordeev@linux.ibm.com>
 <20260423105409.10371Da2-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260423105409.10371Da2-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t3s94L5-K4QOEY_wKDbbGdt5D2BGdSrz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDEwNyBTYWx0ZWRfX1bdyTOTi7Fv3
 JJjvP5hGxQdlvY8bFZaOTDDSfBkYqpkUCiA3+UimJXHXSNf1IdU1pYAme/vFzM9SrWuY12r4WJK
 I+dUiXRWkcTCUpCdVo+/XEDji39fGBoe6Iqvcf6eBpyQEtGrmRdC6rTXcW/qBOwXK6LT3pjdzeq
 a5/dduev5U2VEFaUnf6LlbM1/RRyAlnVVH0eVYJOiSdxmfXjztqt3nawH/ngXktzw+NEo1e6Z+9
 9MZT9R2SXVmkzKKZbVXf5e1xMYrXZJxiUmlynTKpr+bhEFvRyY4l2qN8v0bYyuSrShQ7zAl3gte
 IaIDKcvxxoG0krjfYtj9rkfZydFCZ4VMoRcJujdVFZv2Mbu1kyTzx7aWAPsqj/V/yie6rRr5XOY
 vrnAKqUnpRk0h9//ke5ySVipZJdPX1n7yhP/LMF987tyOis0eQmfhyDISo0ojUzUytLV3+Z5ORm
 L1oaYM4mQq8oWCGi00g==
X-Authority-Analysis: v=2.4 cv=a6kAM0SF c=1 sm=1 tr=0 ts=69eb557a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=hBe9qfS21CEMvM0OSTcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: t3s94L5-K4QOEY_wKDbbGdt5D2BGdSrz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604240107
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1785140007
X-Stat-Signature: n481boitbqd6asdargm795dp7bsqqxit
X-Rspam-User: 
X-HE-Tag: 1777030524-304141
X-HE-Meta: U2FsdGVkX19xFJP+goh1TNUP6K92oOVoqvuOCKA4uTm/KK56BgG6IUd3YlUfs/6s/0MAKLAkmbtMFjG2BBcYv6FD2aLBscvbShK04xYSparDy2Q2a8LkNvhvdNOtsVks9FzIqb0yWPM5dusdO2EyZSrwVTPXY9oQ2BBpNdl7C/01LS1/AReo5Pf/u1nw7sLbaYaj987S5RByFpF893NOVxBVuBHSNQF6YV4DEdprtS6wZa5qsgn0w95rvBaap/UAM2iQGa27qFtc+mEveNthQ7db+n5lIheqdy6hccaoiPAkm/Xi+HHJs6NNuIpqH8ZQEBDN3melAL5YXFgBf9sc1uFQ/YdQ+HacuM1Q0uj2uTNa0pYm2YUbTweH5+eG/HxDVAk+dEEAEIPEeVZJKawMywqqwNfQdfSOBRdegX1Q/bd7ZEc9QQZLdPW7EsP5uIg7TUwGoDs6REsAB3xe9mj35V9uMhqFJV+zG9lhcV1MF+ZPUVjuGvHnKVTOKWPaVOiMxgqymZyOnwAOT+9Ui7f2d2DEMNO8Cex7OWq6Jtl3x7LHhbWqGYZzaESIm8VrSM77a+gmfyA3uzP+7ENgYYcDL1KjJI60mb+sLhN15vW+dWHzO9GeHxSfF4nGfDn17vycPyo6cTGP93dSfQshaJiM+m/iDU7GtrHJgo1FbNG0S3gvUnVTNb8w9q9pB3vW7VQbK1vUxKXNRJ4jXGzdEyUrunoZIITIVsDhs1WAvdH7II32VAoVX0zn9LJSxDsWoi3gHy/nsZ42JZ/WbW1bZuX8RrpfcjspD7c18PWKlN3AdP3GucYZupqcPwF44OovlDhYiQt4O+tRVoBBO7YFhX3yGNWgKIfnDIagNODVeEs6tq9HISpIfMlloNctfDlN+i5mNhTCBdfvVCuLVbW7xDuFr/1Wz8fR5G/7PCH1wFtJ48bARUg1HIJUhEOTi0V/HQmOKGUprnLPNxLz+Haxr9Y
 +lb7rSk/
 uSYUt98le6jgGZKfPzYF2HZcPaSeaXnO7dY5LBz/4C84bn5VLz4tY6bv4l39x6ga8P7hRnIzbpOiPF3GwY/HyTpAiy/x8574M0N2jSMY7exiD0O9FG9/II3iRIpocQ/I+6GQrLF108GVGfX1LBLKJOvdMbXXOL2JA1KUss2Ue+J1LDxNls49mmtwds/AyS8zfGrMIK3tOewt8AXbLHmymgXYzpLVpPNcSIOgzb+mZzK1LP9nthYMWEgZfWjhVcujvQIDkX3d+mmcsCdUR9iQh5yeUhlmfrSnVXZ3z9fYzefmeUetjZHGjWtg25kUlrgjIXhV/iOvPOmUw18JRSiYqM4jHnt2Yw2sM0ZSOy/0cxeN7R4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 12:54:09PM +0200, Heiko Carstens wrote:
> On Wed, Apr 15, 2026 at 05:01:22PM +0200, Alexander Gordeev wrote:
> > In various code paths, page_table_check_pte_clear() is called
> > before converting a secure page, while in others it is called
> > after. Make this consistent and always perform the conversion
> > after the PTC hook has been called. Also make all conversion‑
> > eligibility condition checks look the same, and rework the one
> > in ptep_get_and_clear_full() slightly.
> > 
> > Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> > ---
> >  arch/s390/include/asm/pgtable.h | 39 +++++++++++++++------------------
> >  1 file changed, 18 insertions(+), 21 deletions(-)
> 
> Why is this required for this series? It is anything but obvious to
> me. If it is required please add some reasoning e.g. in the cover
> letter or to the above changelog.

This is because changes to ptep_get_and_clear() and ptep_clear_flush()
look much more clean with this patch. Otherwise, I would have to move
page_table_check_pte_clear() before the UV check, which is strictly
speaking worth a separate patch - this patch.

It also makes sense as a cleanup. I would prefer to see it as part of
the PTC series, but at the time I did not realize it was worthwhile.

