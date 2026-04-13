Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9854BF34C4E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4816B0089; Mon, 13 Apr 2026 09:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAAE76B008A; Mon, 13 Apr 2026 09:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0AC6B0092; Mon, 13 Apr 2026 09:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFCD6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:43:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 554EAE01E8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:43:37 +0000 (UTC)
X-FDA: 84653650074.13.0B7124A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf11.hostedemail.com (Postfix) with ESMTP id F307B40012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:43:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mnIW1wS1;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776087815; a=rsa-sha256;
	cv=none;
	b=7BBCkLyM5v3gfUcQsNi4X2XnmJNGKA/VYdIfkSFREiAtKj+OUBGzZfAf6ty/omaw8V0Ovz
	my5iFf1bmRQk+zIpin1ScicD4x853v1yrlHlfHJLme29daiAwWwhEj17gTe/fS2FH4yQI1
	/feO2EThu3PaZRWshWsdGysWSra/Ae4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776087815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=saf5SXp3wlvOnOLzLMjfVdHAFSBVv9+8L7w7kLpMC/8=;
	b=rQyiS8zsin2Jdk5ehnxzLb3RtqDynVuax8LMqpFI0xzEhc5cVMObg1zofMhe9yZUx8SiQM
	EfnnIxxUK9AnjmrOsIWg5Fa/TwoCVN5Bpe7Rr4BVYU17H0LahgWRwNw658TQE3rmztDRus
	EajTaZKXSj2H1oJwl3qDpiK0hQO4m1c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mnIW1wS1;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63CKECrY3021224;
	Mon, 13 Apr 2026 13:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=saf5SXp3wlvOnOLzLMjfVdHAFSBVv9
	+8L7w7kLpMC/8=; b=mnIW1wS1tMvmc/4IdmfuUvRlSHB9Nn6BjP6lB47IZD5use
	LIBd47QC5BwPpinJbYEGM5Izkas6xM2/lz89P6OL6A6GVZ5fTvIuKviJ+LeLFb4+
	VYFH12S9Q2RysppFnJVbEWmNK+IutW4e3RIA8Q8bHEF81PBtmHTkD51Y5ZwEremI
	Ip4CpQjq7L0IAtqz7fN4pvKVajk+gZP5PqVr4xwKQyCZJQ6CXbMi0mMopmmcOhvY
	IQjoP3SP6qhydFbGAe/SDpxup0dS4fn0BrOpeW8pKOa5JXvct2ULXdikDHo7tKy6
	hacASYLAJhtDAqPEDi1xZZZM9XToiGidp/aojFlQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dfbqkfskv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 13:43:28 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63DA4meW025781;
	Mon, 13 Apr 2026 13:43:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg3b1d3wy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 13:43:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63DDhOt553019082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 13:43:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CF512004D;
	Mon, 13 Apr 2026 13:43:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE32D20043;
	Mon, 13 Apr 2026 13:43:23 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.52.215.75])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 13 Apr 2026 13:43:23 +0000 (GMT)
Date: Mon, 13 Apr 2026 15:43:22 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
Message-ID: <896b3d93-8e60-42e2-b8bb-d3d4e8c99927-agordeev@linux.ibm.com>
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
 <665a19a0-47c2-404c-bd2b-482ab51b8f64@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <665a19a0-47c2-404c-bd2b-482ab51b8f64@kernel.org>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=I+9Vgtgg c=1 sm=1 tr=0 ts=69dcf300 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=yNaC3uHPhY_xAc1mEpIA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: l9a5izobHhmuJWMjreMWf-1yG0SVJluB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEzMDEzMSBTYWx0ZWRfX/NimbRRhGaFD
 Jjy+q0LVUcC6dU1MpAjKESCfvT9kNOxcc47zp9DjfkwDYbHX8DktSB55qnzUjOXpCa6g3uJTaZW
 teNGQCyWRLriO7ZYrqSlogIsW1PwGItZYXRtyvU2UxgDsdGwnMNtT63jhIDAkZQ9J4KQjPwwbx/
 7wwNp57YRbVNQqvkO6Vce9Bde61f5KWspkNHqi/5Ka9JC7+zaXsyg4B73fPT6/rQM2K6LZhZn/E
 P3jxkXLDqDLQKWXJQKk5n4q2nHBNGT1tJoWhPMBKlZtxuulPZlbUA8nTNDdARp2Q13OpUu+wpdV
 PefhH1KrSmLrsC8mN96/50r+T8xuA9btJq6pgpTajcpb+iAo9iVQRbWMtIO10qprKvEyCs/RPK8
 cMiQHhFxggwVIyxbUSJayKt99zfeu+Wouc+Zp9ytxVPdJLGb3LOZTpEVLcaFiX0I2+cYPopRovr
 Arq1RcgMd+aksQbMS3Q==
X-Proofpoint-ORIG-GUID: l9a5izobHhmuJWMjreMWf-1yG0SVJluB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604130131
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F307B40012
X-Stat-Signature: qfserrcsjam5gre4ukfswfwdpp1afsro
X-HE-Tag: 1776087814-360407
X-HE-Meta: U2FsdGVkX1+2Pklh2MFeDgG+NYgtXK0g0GMPb/YIak0kec4tZdJswfjOnezheRiocp0Es/JL+1IryBJHPPWNki9X7jmTW47usUHSU80uqVF5rMbKbVR7uShsSg4nq6FkhLYd3bk2hFLvluIxdEVrZqrTUTdiGkrBzkloAS3yWjumpMXJBv5AnJLllPXQRfBfPOHeT239zEpYMQ5MP4xME0WZ2roblLGeKj6Iosr355Ew13LtHIIsv7BvYKjLBqENtymf34ZASJk0X1Lv4tCwYsx8zvJ8HBd4bvu9T8cO2wllNxEriCqrya1isK/rkcT4Ac6aYTM5Ao30zOrf/eDvL4PU3hE9s4x1nq2HJ+YmpY6EBK5ZKNhUT2SYcuHYNtCaSJZ3UxlYDyInH3pfFl2x5FinbuEr2AJbKSE5yLoHiCrYuwXAMJkctBknB52qhu5oL2c0wf0Q9ozepq5AzuP+VJzC8BXeaVFuw22rpgP7LnBf1e8qmeK1Dpe42E/+jF4bvFUc5LDEjz2+msMz5xbHXHI0kPgc05zrP6Yh4J2AXQv1HU79TfYEldh0ZOTPayvJhe2wdRAhrqKTdFzJDP8xblJAvuK8Aleq9lUCtHreZc55lbMAuHiyPnIQl+OPdbiMJXC03HrO0r6olCcLhsvgesdZCFjYhOEyc70AiIeDEKlQavu9gze9rAlgZHJubFAUeceTj9xJmPjPcSS9R2QspefPpqMw3HicgBTQARl9DI7bstaHIYD1FOuEgxtHVleH1TzwvvYD608i7i1TG+L5rITiDVhuX4xW+AsKo1X88mHNT07pYSWRlvroGZ/G8UXZnlUtKe4jFhvyAOo8V9h5CF/fH0IyMb8/AxumvBdPVEXNmqFdjudvwlWbknyeyCHlbERHUwfc4lD8c1gCm3E1KPPAKh2xYnFptk18mVjlckE0xwaDuAj/9aoKbQW/UuVoVz5O+UZxEmeARmu5s9/
 OlPeoLUo
 gtvx30alnnZfZBpgxWEJaE8GxYIwuE/2RZ5VRJdHjBsck0QjWG/B9xF+MBJOAg7n3HMv+hpim7WloGALisql/hezOhcVjKSJ1RtjtBWI3t/guBwmFvA+eM7tU88k9Igu50U+xXLT4/Q8p13NCENpw+Hb9VMKscf26rVyZGfJ2sNtRCTb1wl+oLakxcsr4zKjNFt/NROrvPhN5ljW52kgv9rs+wEw9jf+x2ERXGRrg6XclOYezytP7QTgQWv7sYuz27vEtbppAceyWygePk6VLEjbi+JRu/KY8WOxiNEqAoVBhAtsZySWEFRTNGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 11:11:22PM +0200, David Hildenbrand (Arm) wrote:
> >>> + * lazy_mmu_mode_enable_pte() - Enable the lazy MMU mode with
> >>> parameters
> >>
> >> You have to be a lot clearer about implications. For example, what
> >> happens if we would bail out and not process all ptes? What are the
> >> exact semantics.
> > 
> > The only implication is "only this address/PTE range could be updated
> > and that range may span one page table at most".
> 
> Probably phrase it stronger. "No ptes outside of this range must be
> updated" etc.

That turns out to be bit more complicated. The below cases do not fit
such a strong requirement:

1. copy_pte_range() operates on two ranges: source and destination.
Though lazy_mmu_mode_enable_for_pte_range() applies to the source one,
updates to the destination are still happen while in tha lazy mode.
(Although the lazy mode is not actually needed for the destination
unattached MM).

2. move_ptes() also operates on a source and destination ranges, but
unlike copy_pte_range() the destination range is also attached to the
currently active task.

3. Though theoretical, nesting sections with interleaving calls to
lazy_mmu_mode_enable() and lazy_mmu_mode_enable_for_pte_range() make
it difficult to define (let alone to implement) which range is currently
active, if any.

All of these goes away if we switch from for_pte_range() to fast_pte_range()
semantics:

/**
 * lazy_mmu_mode_enable_fast_pte_range() - Enable the lazy MMU mode with fast updates.
 * @mm: Address space the ptes represent.
 * @addr: Address of the first pte.
 * @end: End address of the range.
 * @ptep: Page table pointer for the first entry.
 *
 * Enters a new lazy MMU mode section and allows fast updates for PTEs
 * within the specified range, while PTEs outside of the range are
 * updated in the normal way - as if lazy_mmu_mode_enable() was called;
 * if lazy MMU mode was not already enabled, enables it and calls
 * arch_enter_lazy_mmu_mode_fast_pte_range(); if the mode was already
 * enabled, the provided PTE range is ignored.
 *
 * The PTE range must belong to the provided memory space and must
 * not cross a page table boundary.
 *
 * There are no requirements on the order or range completeness of PTE updates.
 *
 * Must be paired with a call to lazy_mmu_mode_disable().
 *
 * Has no effect if called:
 * - while paused (see lazy_mmu_mode_pause())
 * - in interrupt context
 */

Thoughts?

Thanks!

