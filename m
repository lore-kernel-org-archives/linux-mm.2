Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431EDC624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455D66B014B; Tue,  1 Sep 2026 07:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BE66B014C; Tue,  1 Sep 2026 07:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE366B014D; Tue,  1 Sep 2026 07:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 05CE86B014B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:17:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85375C03B7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:17:09 +0000 (UTC)
X-FDA: 85164941778.05.DC7CA33
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 323881C0005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:17:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RdK4W4Ok;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788261427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=heZuoH5WNq7Ky57sj0mge+ooE7iNQyWbPKcl/3fcmoc=;
	b=NbyJ6LEGPT2IuJokO2T26ScO5C+8ez76QIPCsfuzLAhK3GCm5EZbIdaquEyLsXH3TLfVvD
	10BW8OGtuAtqtj8OlZ5/nYyqjRreSEDyMbZMp/0TwgVdE/d+zZMf59b+Rsr8EYcw7uH/l9
	XTdT6L8/N7X4h4+evl7RSwnG9B8URcs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788261427;
	b=CJflFYyu7HV/EFFRoJLjWewXFhAbAU3tbwsI8JbEZGfm8DzyIAn3DBCo88GmGtEF+B+4xR
	+R86m0d2GhZLIcWBD21BKbtqAjyqX2q3vUeI7eUfdt1uTcBS0EkR5mJDsR+kqziFtlGyMI
	m7m1tma6w7qOsKgbW+4klhANCSrjCi0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RdK4W4Ok;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AVc1X4009568;
	Tue, 1 Sep 2026 11:17:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=heZuoH5WNq7Ky57sj0mge+ooE7iNQy
	WbPKcl/3fcmoc=; b=RdK4W4OkRDy82b847YJzW5eKGwrIooerZHxla8TPKiMgy6
	T65VI4rotYSpYzGjfaq2fZbIXGlIi/94ihocaL2Uxc/o8lzqICtGVTC9nr06dNOh
	z0162RN1D8bqf7hAJwNuvEInqBrW/wOPib/NA1tN/DNzdtW0W4Bsw2ReXRvUl5Y8
	M6o/jd+D/M9x9iAAKoYKirtJd43rKpq5RLM0nYmlDSFpiduAOE93o55G9BI3R67r
	ix+3nQP+QEtSnI+JWn2BS6mRQN9j1NZNyeA61UpETNSso8FAJBom1ox7mdbP6lji
	7P8JtT8uPmieo6TNAvgCHw/w/Jp2xayHuGCkksVQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbnudq8jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 11:17:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 681BBHjQ017948;
	Tue, 1 Sep 2026 11:17:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gccey34ew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 11:17:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 681BH0hh29884816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Sep 2026 11:17:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EF2A20040;
	Tue,  1 Sep 2026 11:17:00 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3AEF20043;
	Tue,  1 Sep 2026 11:16:59 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.153.37])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  1 Sep 2026 11:16:59 +0000 (GMT)
Date: Tue, 1 Sep 2026 13:16:58 +0200
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
Message-ID: <75462b8e-b190-4870-8fd6-22d1e4d89139-agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
 <73a0a916-b39f-4ebe-bffe-448928b13bef-agordeev@linux.ibm.com>
 <20260826130257.21444B1a-hca@linux.ibm.com>
 <87a3147f-e993-4629-b0dd-a54aefbf20b1-agordeev@linux.ibm.com>
 <20260827081156.3869103Abc-hca@linux.ibm.com>
 <b0d59b27-8d15-499a-aced-e5b247ed40c1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0d59b27-8d15-499a-aced-e5b247ed40c1-agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: hs7d3-6MQjDp_eiwbGAR4xcNOQ5WnlGb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5OCBTYWx0ZWRfX88u47uMfQfrZ
 LP6rGMlUTZdkv6bl6RQXjd1K61ljd+zk4UqKb/icLllUzxE6MGIubLsiqS9WDqfBiaeaGTipJ+d
 K0XyJCx6BgVABWJQ3mPcggCnDK0paaz2oXJUGIC+0ty2uDLHZp8/FsR7h2OYeqewdFaB2Vm1M+Z
 AWIF1k4WtZKqd9homuU0YB5T0S0UYMEuokdyINW3kDwp+SY0pcr2oF82RE1+hpItE1Mf+lQIO16
 0WqBvCwcmQHCnUBd8sX8Psov85nv+JOfJS4lemeisMRYhr9oiZmD+QvHz6EsVQ3Fu2kUp/vZruZ
 YQjZQH1nJIqtlCghZ47M+EUUlfCOF+u57RSWsOV4AlXK1GJSJ1oFWVsVsjlKE1n6sU7m9tUes0w
 fZv2rmQ27QiNXV3T2S5ejsd0JSkitFFRWXxjL76NOmY9JBGHA11B/J32KEFZ+0JAQqtlb5g0mNw
 wEHe+DvuqhefedqyVgQ==
X-Proofpoint-ORIG-GUID: n5-Zt-cctCU9bxLguMqemFjkB2ILLHhd
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5OCBTYWx0ZWRfX5FuK/NZHr8/C
 Bz0H9ybnmkvV5su8dM9YoQdjUwGUh7Fm5nBTpc5Ql9aD3/HDq8NetwX+9q/d8t74vjijdlgWucn
 EHTkZxrGYwxeFtf1ImCXcd56+C4EazI=
X-Authority-Analysis: v=2.4 cv=B92JFutM c=1 sm=1 tr=0 ts=6a96b431 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=pcEAdAQOjQnE0BrEI2IA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010098
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 323881C0005
X-Stat-Signature: cwszhiei73umhwkmipik4dkyqi74omoe
X-Rspam-User: 
X-HE-Tag: 1788261427-729121
X-HE-Meta: U2FsdGVkX19CyVYmnQ8lfPSn9ffOQp7h/5FujgW8l6GV3h1vIr7etJDKQ03NrT16gUaJbUeGnSc73aKKmnyGOlswD5nlfdZY1939WH1SFOJBk7psC1Il9VW6ihIf39v8FE/3BY+xtV6Xv0cbb10dR2etosvWAiYp/itKFQiXiQr/kpZO1RK1V7wZGOj49432FT/i6/bncvrypcgcLkLvOCp2RSQfH4rhvqAXv3oJE2TeyLGZmD7qHIMuYjGaBWsb4zVFQbbMCRvRDO6IjJ70xND/SAf4kf9biVDSOUSB/BofpuhPpYIbXGAZ6NlTXwodAUj6kPFSd1QI9MDru426HQmHnzoi9iuf44RFxWU1nZFSFYvYh8962RGvBe5757VaKOTqhrbbMd+d5JYI5pWlmD+7/PAcwz98q7czER+LoQNQa2FsCX+oyAo54Bi5NVpKAY5WIdz4QWUdSus9kQx/lrOnuRAdM/seMkAMNVn/ts5o6qkLfPpR4eHhVy5FV3cnwWIvEV2K3RtcpM6n4ylh0mnbBPSkU3k5jWQIEOpKAEMpux+Lpw6sAHBOfXVh6KW7uCqJqJnOFwMim6c4Q9c7PBPMFxVShKElvT9P09iQlvt7iwd23yeImNjX6XrK2irgHYhC6mvqrRImv2YXCadtYYX/PjD5ahR8oszAxkOANGZYUClDmRxn5VP3PkyeAyBCkg29yeFudnVz3EOGlFR9r/7sLVAlOS8ZDkGAEihCWgUVqMoWYtkz3jKWqOtR4HEDQvU02wxJpefbF9WBvBF6dZgwsLByo9749eYjjuqcaY080RimAGgo0Sx00S81EjKGZFi/HskrOA2688jE81vYXA6P0lhdx/v8f6oMy+1VSdWnM7/C+sIFJfFzOfrRitR3U6gfLuoHSH+I/eL4tEoVSFstENYrlKRv1ts8S+BIXYaX2Vgi5cfugR6IMkg5q305MFPzQcoiOMhvNx2B+Rz
 XfS5Y1pD
 WqLJcXNlp64LPbfzRc1YrujSlXvoEieoLl7N62PP+pxgFPcw0OhN2mXuxgjyS4RNpEPEIAVGhcEgHMsRwcItyGSwZs3NswXmrOeN2ZQLgphn3uCYVyIYmg/YnXjgQVNWAr+296Xhpz7CkBfQyRCn81GC62pb1ArwkvkfbQazRNWZYbXgZ1MDNEg9e5qj3AZkJ+T+jdDn8HMHcPyUeyEEv4hL7UJm5HbBrSBhwhsgb1M372TNgDCp38PKFwh9DQHRHqkEAq8nPfx5HJyl+nzgB6o8SsDoCG+Jznw9LK8rphFS/wsc0HRe8TipDxtpxMXk98nNyk5KklbpaLBNo5j69TXQ3rWHE0quq+C+3niGu6KUdVG8WlSuFd7D5qAxocnljIiQ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 01:40:01PM +0200, Alexander Gordeev wrote:
> On Thu, Aug 27, 2026 at 10:11:56AM +0200, Heiko Carstens wrote:
> > On Wed, Aug 26, 2026 at 04:34:25PM +0200, Alexander Gordeev wrote:
> > > On Wed, Aug 26, 2026 at 03:02:57PM +0200, Heiko Carstens wrote:
> > > > Would be nice if we could avoid the not so obvious local_bh_disable()
> > > > and local_bh_enable() pairs.
> > > 
> > > Calling ptep_get() from BH context was certainly unexpected, but the way
> > > local_bh_enable|disable() pairs are used is actually straightforward.
> > > This is a slow path anyway, so I would think the simplicity prevails in
> > > this case.
> > > 
> > > But again, I will try to avoid that.
> > 
> > I do agree that ptep_get() being called from BH context is not what I
> > would have expected too. But then again, nothing prevents people from
> > doing that from irq context too, no matter if that is sane or not.
> 
> I am currently looking if any interrupt handler does such a crazy thing.
> If not, I hope it would be possible to nail this requirement with the
> maintainers and e.g. add VM_BUG_ON(in_hardirq()) to ptep_get()/set_pte()
> implementations.

I did not manage to find any code path that does something like this.

But few archs call ptep_get_lockless() from the hardirq perf handler,
bypassing the per-cpu cache on s390 and (as I read it) violating their
hardware lazy mmu mode. If this is an issue, then it is pre-existing.

> But even with BHs we have an interesting situation: calling ptep_get()
> from a BH while in the lazy MMU mode is actually a read hazard. IOW what
> I hit looks to me as a bug in generic code, and one that looks very
> difficult to fix. So staying with local_bh_enable|disable() would be
> still a good tradeoff.
> 
> > Imho the "final" version should either be implemented that it can go
> > without disabling bottom halves, or, if that is not worth the effort,
> > even disable interrupts, just to avoid other surprises.
> 
> Yes, that would be the last resort.

So leaving local_bh_enable|disable() while adding VM_BUG_ON(in_hardirq())
could actually work.

Also, I do not see how the code could be rearranged to avoid BH disable.

