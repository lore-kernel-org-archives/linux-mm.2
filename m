Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AA8C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444186B0093; Fri, 18 Sep 2026 12:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B2F6B0095; Fri, 18 Sep 2026 12:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B636B0096; Fri, 18 Sep 2026 12:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01B876B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:23:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C6DCA62CE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:23:15 +0000 (UTC)
X-FDA: 85227402750.08.582A502
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id B8D94140005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:23:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=U164ZCfS;
	spf=pass (imf09.hostedemail.com: domain of oberpar@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=oberpar@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789748592;
	b=r3JudNiWwI0BkUY629LPvIN1nFjrd8FWFxfht68XNAho4Ivw2imfl/PhIJLAIb5eu2qSLQ
	YkFv71Ta2ZMuVqmVx4vVN6gVX1UyX9nIFE09dVG0zFDagMlf2oxI+D5mpFl2YQXtXAI+N9
	7rmqqvtJ6Ac4wc/hjN5KW4+9qif7uYs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=U164ZCfS;
	spf=pass (imf09.hostedemail.com: domain of oberpar@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=oberpar@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789748592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrSrPGh89ZBDJ8ImJt+nz22I+rOlaK5hWlIv4GDrkKo=;
	b=HoVeA/hD5IkP2gWHK/+EMMk+0nJBrTYr0DHMa2a18U8EoLB6M8BwX7NU1zKFmScghSst2t
	S+I9I3qmtWaS0v79og9/sti00+w8Sw126FwMyc9DpNKsrpvF+fN+EMqoe6PkUBQBTjpzkB
	k5VBaz/Xe3dWPp7+bj0rGaJKhknvbfM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68IDVZm71393547;
	Fri, 18 Sep 2026 16:23:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IrSrPG
	h89ZBDJ8ImJt+nz22I+rOlaK5hWlIv4GDrkKo=; b=U164ZCfSbTri6NhwgGdd3A
	OoIYNbQwf6mDGk/ZN7w8Ru+s+GGDPi7jYOhlIoGDlMrqjEqWYq92ruppUAa9NUwO
	CG0fsRs5JefNx1W/Hdsrh4qtjwKMQ8v/5GrtRvuNbpFFKBxE28bvz/3Za8P0bzhq
	P1gkqz8uUaNTxWXzufHcxsdRQ+0jmi98abs178Z3ffGngut6hFVqyrlR14A+H2e0
	2XqfAstr4OqhE6z7mksk7I1jcjnV5YAZtWYtu1Bot1F9D+A/n+m1iqsUGJILvbgl
	+eLk77feKSajb86IdZm2kzBFQmDS5rzm96q8jyIXCe9ZvuDcdA8Oo5BSBCEVSf9g
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf5h770-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 16:23:10 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68IDO2Fh771897;
	Fri, 18 Sep 2026 16:23:09 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gr5ffg5yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 16:23:09 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68IGN8YI31982158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Sep 2026 16:23:08 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A5B358055;
	Fri, 18 Sep 2026 16:23:08 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 498C45804B;
	Fri, 18 Sep 2026 16:23:06 +0000 (GMT)
Received: from [9.111.192.138] (unknown [9.111.192.138])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 18 Sep 2026 16:23:06 +0000 (GMT)
Message-ID: <bf57f67e-4a51-407a-b869-b9d78a9875b4@linux.ibm.com>
Date: Fri, 18 Sep 2026 18:23:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/13] s390/cio: replace page allocator calls with
 k[mz]alloc()
To: Heiko Carstens <hca@linux.ibm.com>,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan
 <vneethv@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
 <20260916130613.15587F91-hca@linux.ibm.com>
From: Peter Oberparleiter <oberpar@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20260916130613.15587F91-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vTyVM8gFf2TLxGe0RjdKNlWme4FkyRm6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDIyOSBTYWx0ZWRfX12DmjXrEm5MR
 h/AvVcvlh5F9Jzcx3msRny4416tysM3XT+DK1T4EAg1Tc8kI2m3sAh0MCVEE5m2jJsOzsor/lWm
 LhlGoZjGMZlGoTfMOpXBVOkV27ORGEo=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aad656e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=IRwR5hotAdJOlb6Xvy0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: vTyVM8gFf2TLxGe0RjdKNlWme4FkyRm6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDIyOSBTYWx0ZWRfX9VrQ2GokdTf/
 ij01HjXDQRKd9KcreIiqI/fXcgj3CFh8IV3Ywtcj5oFBp9ClR4zc1dWxHF+s+wNUqCODODzn0pz
 62Hn7XGiwhK8ouluqvAn2U2Uv3R9hZ4nUA1k/ozSdmbdM3yLAouP2b7TjU+za74QNUP/SDs2kuV
 +TzM3unuJpH/QCI0WNt9zWl+flvufd6ShlibskDDOwZ/Wgrs7g7sEiVXHUAAMsiGIykrOcfZkZr
 aJYf1nfQqrxhYuQcle7w8QKFUsrgFS4tU2c6lyp9aiDUNFOues2xArRa4Dh+hp9pRGjSdWg2S+y
 3Z97elu/WJo/mNnyWwADDXckyafk1reo63sgpjQ+FSiVjXUxVdlqeiU4eSitu4SDZeNzQe6busz
 pjpvKbW7ZS+wbhuVrz+xIv9PsUoHOGDu0h9PeCq1L05AK5Bult0pgC74RcUO75w2eNGm7Hyaopl
 jmnErCQwD70LaaCERwQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1011 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180229
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8D94140005
X-Stat-Signature: ze68agy1b8zzrrfnwnzat84gwd5spxkz
X-Rspam-User: 
X-HE-Tag: 1789748592-343320
X-HE-Meta: U2FsdGVkX1/YQcv+8zyCmuqlASW+1e2BIu87uqu40VBSOFVIBzuO1L5tpAz1f9xxIOyHsCVf9+4Mm6xQKmKHtIvW8jGKY+78vcVPT22f18fZuA/R4XAGlqeBwOeWWQCIZYcO15PehWjQkos7HHMe1ihIawmpWawBjxm4pyokVjMWhPi9O3rS5JVYWcfMgOnZ/PnbtMx/l08j6YcfJ/whowpJKQTcuyKcbyeF8eQhDhnqJC/jfMdlog3pTxUsc3+GEQ84/6hk1NA5ECOKsZ2KPJtP+IoUx9A+YG92hUcz9RsYO81dSQaRC9Lbx/5i78C9bw489dywV8Vo73kP3ELPrLDpJC+3cmHg2YS1upLUYwFohMnRM80qgaX0NfYIzU+oDkCDV+drCxRl8hywUESi5mUyGAxT/mkGjdcbXI41ouhVSOUbdnQtATpJwSkSOfCYHYYSXK82BKBJlHSVM7xCvZgdJVeecmJD5HJ6wBjiXPjeMAa53SePwhxLWZEhy6j8TuQYq/z0VqzIlrZPXP3N/4i1ULzFYmgn9f/AoYELr6DJFcUAbDttAKWKM2lvBnf44uP9BxsWbs2yFpBzoYnma9pYa2sw9qqBXlJx4I4T3khXmAidgA0EOS/IjzPwxsCpJ3bjoCu8YWrzrRpoBZQDcPaYcB+Uv44X0+D0ER3vj/hw7Xzqp0xJTQK4vF38ZweXvPzuvrUSfgWxyYe9cWLBEOqYcTaCLRPt1CoNkDIMwaNIG/Nzo9U9rZKbb3WFM6m2x391xNm+2hIiVUzLmctcljZD0HkZ+OIdiCjumy0iz0jxQPjxbFFF6H2m8DB6pTc4ziEQfsKzJzC+dkVAnjumqXm+f0fh5e4dusE4VUsjdOkM98bwWMsL+E5PMmeWhDirfswruLdftsdP/Mn4GJcjB6AZLKt9ISvGS6R4gID/QHboSeN4T9+qz5+JrAKqSt6//N4fYnBIzFh9H43mtMu
 GmrrC8E3
 ZPMSs/VJe7kO4zRxgK2XPioIMRPw9DyOnP3giQ5GLhpQjSelsq1zdTFW4uuDxKhFZXX243v2+4NyS+41mkb/D6Q6mD1rJp2eubnZlP8v5qJIzp632Qt8s38WyxuqsJ/jc22Roz1lVG9qVKbr/c1EvRAFPXJ2VtR0Y6mxw6Zfd3RKSU6KgGg50ea1cEJcLe0fvT+8ulcuw1s9X/OfatnNJg08B5e/iieRehz2dFiLn0b/y1nGKys8seWu6Okdl/b9QV1/Nf6xeAzLELTBz3oIKjMrvrrDWulGSKeERFDRBuyZwskw+Hx54AHvS5dvmXLXtnPeK7vQ5vbqoAyNYhWY6vCU5uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.09.2026 15:06, Heiko Carstens wrote:
> On Wed, Sep 16, 2026 at 03:03:07PM +0300, Mike Rapoport (Microsoft) wrote:
>> The saga continues :)
>>
>> This series covers CIO, QDIO, SCM and IDAL buffer allocations.
> 
> ...
> 
>> Mike Rapoport (Microsoft) (13):
>>       s390/chsc: Use kzalloc() for CUBs
>>       s390/chsc: Use kzalloc() for the SEI work area
>>       s390/chsc_sch: Use kzalloc() for CHSC requests
>>       s390/chsc_sch: Use __free(kfree) for synchronous CHSC requests
>>       s390/cio: Use kzalloc() for CHSC work areas
>>       s390/cmf: Use kmalloc() for the CMB area
>>       s390/idals: Use kmalloc() for IDAL data buffers
>>       s390/qdio_main: Use kzalloc() for the IRQ structure
>>       s390/qdio_main: Use kzalloc() for the QDR
>>       s390/qdio_setup: Use kzalloc() for QDIO buffers
>>       s390/qdio_setup: Use kmalloc() for the storage list
>>       s390/qdio_setup: Use kmalloc() for the SSQD request
>>       s390/scm: Use kmalloc() for SCM information
>>
>>  arch/s390/include/asm/idals.h   |   9 +-
>>  drivers/s390/cio/chsc.c         |  20 +--
>>  drivers/s390/cio/chsc_sch.c     | 300 ++++++++++++++--------------------------
>>  drivers/s390/cio/cmf.c          |  11 +-
>>  drivers/s390/cio/qdio.h         |   2 +-
>>  drivers/s390/cio/qdio_main.c    |  23 ++-
>>  drivers/s390/cio/qdio_setup.c   |  14 +-
>>  drivers/s390/cio/qdio_thinint.c |   2 +-
>>  drivers/s390/cio/scm.c          |   7 +-
>>  9 files changed, 150 insertions(+), 238 deletions(-)
> 
> As far as I am concerned:
> Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
> 
> Waiting for IO folks before applying. Thanks!

Looks good to me! For the full series:

Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>


-- 
Peter Oberparleiter
Linux on IBM Z Development - IBM Germany R&D

