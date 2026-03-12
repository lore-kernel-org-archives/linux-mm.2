Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C83F106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 22:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D2B6B008C; Thu, 12 Mar 2026 18:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04586B0098; Thu, 12 Mar 2026 18:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31B46B0099; Thu, 12 Mar 2026 18:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A18746B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:45:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3372AC1C05
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:45:34 +0000 (UTC)
X-FDA: 84538894188.01.43F9DC1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id E41CF80018
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:45:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=p64AnWj9;
	spf=pass (imf30.hostedemail.com: domain of gor@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=gor@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773355532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2G9U3elAqhs4zYdHUN+a5FlSCohzSKh6Zqf15xFcDmY=;
	b=jW5oGw2AO4NB5XqpCgujq4M/r/ry2x/zvl584RviwZqlbKy6fo77JlxCZ3SkIJZtFbzAdj
	STp7ebUrl1Jgb6/svk+U5j8ZBOZiKhAfbiBqK1a9C0cM9knCmB8G8+pJeY/KOJ2cCzy9lg
	iGbrWOD20ICB3YoIduLLSP0HKyCClTM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773355532; a=rsa-sha256;
	cv=none;
	b=XtW9RB9ipl65FnoMKcONM5PcliaXihl5jwY/GzgtLm9CKcjnhcGyy76N8FJ6WIIyrCXwFr
	TNijnhYAe2hRX3rMwQ0xgWut9DRIV/tUMQJYeFMqS91Lg/MQGhYYiZnjSWs/AeW4h28tzN
	NYofwwUqCe48+WkA7MDRhBDiQRjywf0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=p64AnWj9;
	spf=pass (imf30.hostedemail.com: domain of gor@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=gor@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62CE0fjC2303568;
	Thu, 12 Mar 2026 22:45:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=2G9U3elAqhs4zYdHUN+a5FlSCohzSK
	h6Zqf15xFcDmY=; b=p64AnWj9ExYqW1NUdqJX+6EKpyhBPbsYkxGr2rNi7udkzR
	mPCsiiV6yalNQ+ERMxdk4VybWmqsREOMYu+eyWqXU5IJFyzZDCA9Q31KRToz25Gg
	FCvQctEzhW1SQfkGaU4aQ64qaJx3Ao5+8/SdpENY+Rw7ctcI0MTNW0f35gL/HyRz
	kt/L08rVcGpwD51pcGqDA7wD3KaaCN80iKqZ0ZmQazF/M5LAa08lsu7uOxya0FlS
	mPTu4pQSePVHOm+xTgKSZJ7y7hMvDCwoWfhk54mqIGTWtHul8J7XTp++1MZzyqk9
	3jQSApEJiPrwqknlxYVyjDQfatCzBDc2B4jYNpOQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh95vxum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 22:45:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62CIP52a020779;
	Thu, 12 Mar 2026 22:45:20 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha9maan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 22:45:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CMjGTg62456198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 22:45:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 831612005A;
	Thu, 12 Mar 2026 22:45:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B82792004F;
	Thu, 12 Mar 2026 22:45:15 +0000 (GMT)
Received: from localhost (unknown [9.111.83.60])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Mar 2026 22:45:15 +0000 (GMT)
Date: Thu, 12 Mar 2026 23:45:14 +0100
From: Vasily Gorbik <gor@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 1/4] mm/page_table_check: Pass mm_struct to
 pxx_user_accessible_page()
Message-ID: <ttbt5ve@ub.hpns>
References: <cover.1772812343.git.agordeev@linux.ibm.com>
 <ca77f3489453c2fe01b25e50e53b778929e0dfc5.1772812343.git.agordeev@linux.ibm.com>
 <ttbskgg@ub.hpns>
 <20260312135757.d65e8145d9d39e1ca5bc9666@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260312135757.d65e8145d9d39e1ca5bc9666@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDE4MSBTYWx0ZWRfXzYRyN5/1wkHl
 8TfaTg+WwEhBWaLRIUn8c4VotmT0v7+i4klU/zanb5KBhYOXSHC0b1B/j/R3HGjKYUZ7s45ArYd
 NOvg1rRYgpbBTsTSzStU2GfcOF8G6g9r5NIH3Ay6umGVXWebvdBzD2umTIw/i4lL9fnZX/rm/LS
 q8ADIDgvF2JE28rH47n7d1LIvoOGZsaPMIWW4yMAceSvjfyJUiHo3Orl4Czwv+DwdF/ShQj5MEy
 PQCd3owMZzIBLkO9kkEJvcpddzy6lwRK9QdRrOuQ5uyJ7PyobTUQkWGv54wpy9KbR6RdyNSaOju
 4GrOs39BpF82PGy8Elt9tAWVpqNFO4lqFGiXZVjprTXbpAm7MnCxbJX4r/aynfyyeQdNkYNJz9J
 me0U1FKHzQ/m+q7ldI+/6IrHu7F/83TRpceZnVCRxh7ZU9AsQa044ocDKAsqi9S+LFGRxTR6529
 rP0JdbrQZYTAyaV6t5A==
X-Authority-Analysis: v=2.4 cv=FowIPmrq c=1 sm=1 tr=0 ts=69b34201 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=Lr05aJhEBrfB6ZlMEgwA:9
 a=QEXdDO2ut3YA:10 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: _i2x_4G56o4Oof-KO5vWXCMuPGh66yzn
X-Proofpoint-ORIG-GUID: _i2x_4G56o4Oof-KO5vWXCMuPGh66yzn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_03,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603120181
X-Stat-Signature: b5gn5fuz69ku9h7qrxgpipgoxrx587tr
X-Rspam-User: 
X-Rspamd-Queue-Id: E41CF80018
X-Rspamd-Server: rspam12
X-HE-Tag: 1773355531-497316
X-HE-Meta: U2FsdGVkX1/xhqWYyWEz+PdIn4C8iZBCX+PN5yfZ9JYUozvF+xi/HFF26Z6VwN40KVZUpDOpQVi2KvZfHRkUkyM8SV8EK6onT4Ja1d/6WS//KuLxkIOG+zuVaFt2e+yMGIAgkx015/qGkYNeaC8fDtWjKfCYhNUzT1k5Cd3wav0ZBcu4rLWSRDH4dww/CZ4T2rOMIP/pPvgwrKoPJbIbvVGosVhRFfjAfq2cRIyyUK8isT8sI6x/mg6PBDmhBZj5dzGENnngfEJBUMVSLl+GW/lzu6rHkfIGFTgYpVdLD7bxSnXwAAzUtfhQTP5sBRTFmSTz6K9CpQV3XtLKdqmidhYPXYzwEsDTfBV28er6byAZhGRCHeHYAg8WYSdx99yRFUfdfKSgQaxb1l0OAmk+1C811C2qupOMrSNJqV8dh1hsP6eIAP3FWtO6UcQ0R8enSeZ1SQ6Tmfp0dQUhkhIguostfIeahYp/Ps8Y3YWCh2tIvtoUjkghTkEKGZkJEqkK5xfaAySbRv/VX6lytAF6OWiTJLn/JWmyxEIcyeOkgmB2uttToXjkvPpUJhJPcYFwRxUC4nE6H3LnUt87xoQZROkY1NX8/SPVoKciGNqpURuayI17E6fo24SB3zoRixox9i2fZ5j6j57LgREuLQT7Bw2LD9nE2+4NFz79KZBfdIpC0sXOX0NyJj+wU9TK+o0GeIv9N8Cnn25fnMXROUEgP35Xj13szBDGzuIRDwfjOh/35EYZb75imdPosTXZsCszW6Phfb+u8IMBRIfyF9PrmicNkZiUnWQqJPlXezJ82zOpGmhbt/kcJV2ULzCULecWXqrHTjnXu20fOtB6D46+gubmi8iWyqQsyf8XUq+1KgjtSOYtm/6MxPzq7ERKLcal+zZWwmILr8/560TtUlOsmADfwRAeACOF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 01:57:57PM -0700, Andrew Morton wrote:
> On Thu, 12 Mar 2026 16:02:40 +0100 Vasily Gorbik <gor@linux.ibm.com> wrote:
> 
> > On Fri, Mar 06, 2026 at 05:16:30PM +0100, Alexander Gordeev wrote:
> > > From: Tobias Huschle <huschle@linux.ibm.com>
> > > 
> > > Unlike other architectures, s390 does not have means to
> > > distinguish kernel vs user page table entries - neither
> > > an entry itself, nor the address could be used for that.
> > > It is only the mm_struct that indicates whether an entry
> > > in question is mapped to a user space. So pass mm_struct
> > > to pxx_user_accessible_page() callbacks.
> > > 
...
> > > ---
> > >  arch/arm64/include/asm/pgtable.h             |  6 +++---
> > >  arch/powerpc/include/asm/book3s/32/pgtable.h |  2 +-
> > >  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
> > >  arch/powerpc/include/asm/nohash/pgtable.h    |  2 +-
> > >  arch/powerpc/include/asm/pgtable.h           |  4 ++--
> > >  arch/riscv/include/asm/pgtable.h             |  6 +++---
> > >  arch/x86/include/asm/pgtable.h               |  6 +++---
> > >  mm/page_table_check.c                        | 15 ++++++---------
> > >  8 files changed, 24 insertions(+), 27 deletions(-)
> > 
> > Andrew, may I get your Reviewed-by or Ack-by for v2 so I can take it
> > via the s390 tree as well?
> 
> 	Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> 
> It doesn't look like [1/4] changed significanty since v1?

PowerPC page table check support landed at the same
time v1 was sent, so v1 was missing PowerPC header
changes, which was reported by the kernel test robot:
https://lore.kernel.org/all/202603050830.LXQcUa5Z-lkp@intel.com/
Hence, v2 to address that.

