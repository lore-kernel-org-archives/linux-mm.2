Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B2DC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048346B008A; Tue, 25 Aug 2026 03:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B4B6B008C; Tue, 25 Aug 2026 03:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29BE6B0092; Tue, 25 Aug 2026 03:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF6DF6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:50:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43A751A0343
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:50:41 +0000 (UTC)
X-FDA: 85139019882.06.2BA28FE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id DAF1F20007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:50:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=c58WFFYK;
	spf=pass (imf03.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787644238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8M1RtMP5dGDh7WaM7pLyX+UNoVUR6vtG5dGbHWHRrz0=;
	b=7AiisUytD+dCDdqTPXtiIZiDKvZK6CzaK4zyhTuJffTOzXJueFIzxhzrP7k0PUk8jO9SAw
	/+SDbA5G7mMKOdqU6p6mybAKBNbr0eNhCPHPtaoHtNMgZhRz+jpAF8RvXh/k+NMTkU77zt
	0syV7cJmY7yvpwHpX2+msFIQ9fiDkCk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=c58WFFYK;
	spf=pass (imf03.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787644239;
	b=Itp9x3Gg0vFBv4qjSaOSkPtp4gLSxja67vNS2a8Zg/7RA+mLE4sEiTbmJ2k+VSP/Vq8BVy
	3PKsES9OD34+R/LL806ETTziINBz2hdQnHx+9CG3t5vmoAwRwF/jmdB4HoiNnE1oZDlGVE
	/ioeSyg8SJYuwqbyEqQMUO6tfS6bVWY=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67P2WC062619881;
	Tue, 25 Aug 2026 07:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=8M1RtMP5dGDh7WaM7pLyX+UNoVUR6v
	tG5dGbHWHRrz0=; b=c58WFFYK9KM178PdMhMSiBOgXiSkNVmR4zI6/FiW0pfetO
	Qn0EICfLuEB2+blm1HU9Q0rPbm51ucxRcJf7jxA2wwkM8IQWZunOAb/yAfmEZUcv
	h1GyFbYOsw7uICwEjp1LAoODpoOFUZJ6DszkQWyy9Vn5QVS6KzuQeYh8DpQwIa8i
	zSeBTC7kM+xGWFv+8TMN0DTzwTrrwgP447/GRHccUcb95nn7vQ0Upy2OuN9OkBV0
	7+FKUcsEFeAdLa1t58R6W+FJYmzMCskn5Im1UDqDPeMYKVxBVD181eYdjsVbuFDY
	62eUePdxhnrlMGeQvkPXIlOTzjSEpy/4UVkUZHlA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g726eepc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 07:50:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67P7fJbJ015238;
	Tue, 25 Aug 2026 07:50:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7qkh2urp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 07:50:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67P7oWCw53215572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Aug 2026 07:50:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6709120040;
	Tue, 25 Aug 2026 07:50:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE67620043;
	Tue, 25 Aug 2026 07:50:31 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.94.220])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 25 Aug 2026 07:50:31 +0000 (GMT)
Date: Tue, 25 Aug 2026 09:50:30 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 3/4] mm/kasan: Introduce helpers for lazy MMU mode
 sanitizer
Message-ID: <c4ea355b-9807-4a9d-8f90-246b4e650684-agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <52c9be0cf71a8896a5d76c148c38fb24a2005dd9.1786956464.git.agordeev@linux.ibm.com>
 <CA+fCnZfMkPDVyy0t9W-3d55M2ba9wXoRyzj2EWWYLEW=QO3zWg@mail.gmail.com>
 <20260818120130.1411942A70-agordeev@linux.ibm.com>
 <20260824095635.11040Be5-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824095635.11040Be5-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=TfimcxQh c=1 sm=1 tr=0 ts=6a8d494d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=UUUDspzaHmeMqvLuHH4A:9
 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDA2MyBTYWx0ZWRfX1UHCLV5+e1ku
 Bgn8RhOV7C6kM93dO+8ZojEFJxd3UxNobEmy2rwhytC1uQf9w9+9o88eWRIR3m+FXdMYpAxtc/g
 3jIYLqLjXuVFEOeYLLkZkIF9hKjrvls=
X-Proofpoint-GUID: cHEBOSUK2gjUGPKucThiW1yn6xPnJ6ye
X-Proofpoint-ORIG-GUID: QUiBDcHGUMJNuhKLd6qzRIM5vSKsBumz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDA2MyBTYWx0ZWRfX5XNKnD3AcB/l
 60zzrpu3M/nJBAHn1S4j77pylmm2Xv3rLRsy8PoSsYbPmmJzM1P1hoRVSaPppyLrV6I3VRxtnvC
 Qyvez7nqN9ADdnyFMj//rnSfACuWt14MrGZ841V5Ao0xKjXk7wwEU4XOp+OfefjP2JHXFLJjwsw
 j8oz3tZ8APPuNMCeNElUo8uy0jUf9Fj0hlDq0Y6VZ9aeFuzGpDyqvuNDkPtBss1V0vx+b0sgItO
 CbrFZts6mH24N6J+a9Rix2nmdPnhPPLF/tF7t+165IpYGijcCQDHB674W9WnKyWASMV+DLFpKCy
 i7+mPGaV9neTj4e7cexQjKXoHQZg7blcC+XqkCU5DfyWUqLkrMin/pPimkZa7tJ8d6GadSXSjVs
 IhvJlzVRSWtqZ+z45I+OmfUL44AOZf/zVA+OO5R60eJ9aXoZn/QpbPVeC6Yo97F/P24fskG1lDD
 NsehB+v/fYx1i/CGJlw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_01,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608250063
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DAF1F20007
X-Stat-Signature: kiw9px33yaob8ua5eouj9oy6cbnjyrc3
X-Rspam-User: 
X-HE-Tag: 1787644238-476889
X-HE-Meta: U2FsdGVkX1+uqUrndPlNTBWitwE0F5c1sTJAfFjYHy+NdSqJEcSNdC0aCcK3xJYGzgqnCjDZVpLgOt7Pa69cQDRW6V9FZNPpO7NmODJZWqzmyUoIbT4ONsfbuPBHeRsTtC749qm225q9blL1b33mkDrLkVvEFvORR7SDeWnpMwXMaQMnDujna4FXu2iJUxAZvtTVmpV8HN7X6IXC/PLAy6CY0d/INMiu6T5xxKBkXZC3EAVinwFb6pCsV69aBh/aSFqGzp/J1qQ6hv9nRLjIA39pH2drby5TnGKOAsT1s671+v5RjUEF8A0LaKm/FByYpqREh6mLFS2n2h9JqCFEhvrXiM//g2K36xhafHFgCZroK/+Kcz2qDC1aZ6PXrc0JkPntTxTvcZ8XIpxJzO5Wo6kYosgU/htaTSyn0NxZUstssD0kHeq+GkM9CZwmTKGZUeS53IyVBxVy0yP0dyvvzop+oPdnhJf8V1mcJheVdFN1usNUJ1f+NA5dbeBr/O/61j0FP7zrXiPZLXMZVHYaAwLkZlWOBE2vHTZTz2y6UWKhWsZT/74uMbaYPkwc9OAf0c3sGWrdl8mcYQLu1TQxMraxhAz72sPMSAARfWosfGs+xsQkdilP1THOPEpwVuvm4WoE2ET3TNFsupcQnJaksqxp39zBrLTM8oIRW6NY5//Lbk7LU7f6X1VMWWD6zFRC6POWNfD3lLlzyA432qn2BS8WHMvFirPi8kvnDy17P9clrBdBHlCSEiI/rN713Ug2T5R2sqKECSnpefvxEw8DsU2occ7sTFfGJhwcfbfQNSQgJUuK6ef4KXTHQS9NaAlE+WmzLWVyk7BWid32LALgU3tx0FY/OxMhrm7mwyIrVTZbfcmPoYUmwaAy2WnRp104yW1DW4SBQFhzlrbROKknpvcfI2krgta0t8tkqZQbCu+6mAtkU0zlYyTpAbMxAyMCqI++zx4P7kd/k754ByS
 q+EXu/L5
 raU9fMxBmn9+aXZl6EIjXONos7GbhGoBsJ4Pc9iDQ/8VHDBhiH05bjhOwbL2hWxEQ57ZMSx0khMPd1kHalqv6JIvGnIqbUdT9ISIaGaJbZ7m78C98Y/oQxOJSxImSfJ1zqM4k3reffK80Akwe0HdIVHhydiDG5WAo3rM1dfECk38XDJ9TWW6AhuJqHwuq3g7qTzCO70N6w8JwAc241LJp2qjcS89KBB75gpkTElVbGwgdOrJKQOlHN9SyTwMNMmkHWdNEUTUQfWyaDHB66/VQVhCaChTcHR+eRdjTZZO1U5yH1VeAN1EXoa0LNVkK3r9BniXM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 11:56:35AM +0200, Heiko Carstens wrote:
> On Tue, Aug 18, 2026 at 02:01:30PM +0200, Alexander Gordeev wrote:
> > On Tue, Aug 18, 2026 at 12:11:34AM +0200, Andrey Konovalov wrote:
> > ...
> > > Hi Alexander,
> > > 
> > > Should all this be limited to only s390?
> > 
> > The idea is to allow any architecture to opt-in. Once [1] is accepted
> > this may look redundant, but I still see the benefit in having it.
> 
> What would be the benefit if [1] is accepted?

Just another mechanism for verification, and pretty cheap one.
I would dare to say [1] does not rule out an invalid access completely.

