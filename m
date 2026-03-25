Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DBE109C036
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728AA6B008C; Wed, 25 Mar 2026 12:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9916B0093; Wed, 25 Mar 2026 12:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7EB6B0095; Wed, 25 Mar 2026 12:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEEA6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:20:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11D9113BF1C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:20:25 +0000 (UTC)
X-FDA: 84585098010.19.323DFF6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 876291C0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:20:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kZZDIXt7;
	spf=pass (imf18.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kZZDIXt7;
	spf=pass (imf18.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774455622; a=rsa-sha256;
	cv=none;
	b=UozidwHuspQgoUbRSJj5p4iWkHTgIOuEGAtJiAezYd872nzipIvwnAcBRd9XHzsx3YNGMj
	hGOLAHw8EpgOX9SsFkGSR2w7tmICOT8cdNpFRpSGbTB+ruJxKUWyHLmUJH41VP66eV3WEN
	DTTU1qJ5a41402m9FJb6sddmVTh/uyk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKAdTMpd2psr2ZVs6jscsxEONjlFsUjOIx1eQLvo0Qo=;
	b=Krz+b0UFkTiOMFxamBvmpBkO24rVVmgpSu8eXReWCw2iyTM7o3a8lA9EDhreb/LimH1Miv
	qHXmYRMIQSNXcr6KwBaSuJcMAngqCCCpAnSzF1Btdd/J4ZnR/4ugum7VDTRVyD2B+hR2Ka
	bDdfm7ocggNGrN0LK260jfrwIJXhbvg=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62P3O4Td3189918;
	Wed, 25 Mar 2026 16:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UKAdTMpd2psr2ZVs6jscsxEONjlFsU
	jOIx1eQLvo0Qo=; b=kZZDIXt7cHCuMOVJ5Tnzo7drzXEGX8T3gKWeO0sHNCrlAV
	5Aom1awBSMrGmQXDOWDI7j4drjKNdYMMM5I6HvtR9jiEqizg4z8JlYLnh+eR6dVw
	EDb/OvbIzhgXesFl2tqOsbyK3j9xRJZ8L1fDA1BzGoQkbqh+bND9A7FTabOwijDW
	GIu+y2KaTRczF9ZEvxSrpLUjht3QJN3elNgodi4BFqophfk5rnYgXWlqn73O4vJL
	7sY30K3PXoZjGnOaYUPBdAkqAVV067YI96YtSgswiV+hjhTnsiiXsV9ZUxzL0szJ
	PrUAw+YtRUgt17xwTMEV8h4UUkT1RNYVJMUUvs4w==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kwa1b7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 16:20:06 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PFIJAJ008732;
	Wed, 25 Mar 2026 16:20:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nnq94a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 16:20:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62PGK11h51970504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Mar 2026 16:20:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 767D020043;
	Wed, 25 Mar 2026 16:20:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A9DE2004B;
	Wed, 25 Mar 2026 16:20:01 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.52.215.75])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 25 Mar 2026 16:20:01 +0000 (GMT)
Date: Wed, 25 Mar 2026 17:20:00 +0100
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
Message-ID: <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yL58iBxIX8XO1NVeYsxW9NJdtgDshetF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDExNCBTYWx0ZWRfX+V4Qloa/gD73
 8QOTBINLCysTn37RJK+r1HJinZJCZDCY2V6eGnQ/9nakaijuobBPzo3EvAeLR8D0+R7lZ1v+1mr
 CKcccZ0bp4oSACchVpUty4hdVtqxEVkoO3pjAOf/TyvhzPPsd19/+IOhnmhwyvwsRlalxtlBOL0
 L+e0lrj6AeUaU8M6/+WZbcwvZGGaRn7WTILGi+d3NSxBeqAP5BioMZrafcT1FqK3o5gAHbpNPEG
 n67VaZyp/EhqC+5M/+eQ3qWG751zuN37ZAXNRs4kLSsO5x9sNv1OqHCvlSu2r+DB8BNSHR8OtgK
 4aOXhYJFu5BokNFkCgx3pBvetwRTxPRQcFQN8+Lr7kQYiz47rhkb35JAJCXRYp/6E5bYRvO1GLk
 qDfqDWJgbrKdRA/Sml0cA1wZTOPx6CIEjxFDqrxMXqeWt5hGnQKhgQ3H3+iZxClsl4JWJDQU7bs
 d3el5u81Yl7BAFtc1OQ==
X-Proofpoint-GUID: yL58iBxIX8XO1NVeYsxW9NJdtgDshetF
X-Authority-Analysis: v=2.4 cv=OsZCCi/t c=1 sm=1 tr=0 ts=69c40b37 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VemTcPfm9ugi35iZvo4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_04,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250114
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 876291C0005
X-Stat-Signature: 9frunaz7jmamkodur8n9nhb4eomf7h5c
X-Rspam-User: 
X-HE-Tag: 1774455622-630133
X-HE-Meta: U2FsdGVkX1975BJX7E8F0clP1FWz7gKVm7okB+0eWH670wGAEuhpEEug0s7keh6ldHzC2q4QkUZg28+KQlLJHnXtxDzztjTkK7eqiTXJfgmHNSKP2XJUldYka2KT/0ENU1Hby6C1iYOppzlrbqTKaIxkyr8eMW44MDwJxjA75dal5K8gXTtzFycZ3VmFwlBT/jIYt81jisV2ppmpV2rbc/jO3IKUdRPu44Z33blLV69LIF5g8704PWeHnEBmDlQeOMCrdOQJBBwtoUlgdd8MTLPf9Uc7VtlG8K0cErmklCI3DQ0t9emJrhaM2GD4HcwzlZtPookd3Fm79tW6Wq6EGfjd3afjQ7YRAOfvlNWH6FiZFtXeVBenAjaQp5fP+eikM9B/nsZLx2jAj/5BrEcOnWCb/fTnFmvBnOTnlxyshBqjg+DFLYNzDOC5JKh8Fd6n4UF25iqluAoWnKfHJG3O37pQKbRnhMp+6duf+lh2f8TSAeVnY3fzijkdYpbWpxW4hPjCC3CFhttBM8ob7vJoGfL/idf0cWAXC8KohF8m6WU0Q7HJwQ04f12rW5qSwGj6LBz/mH+g89Dojtqyska0tW+woe+bDWTUE4O8zHTcmneKdoBMeB6knwOU0JzCS0VxQjuH6z9TPYw3UMDWsKJnA9ZrZ9B4v7fkOIliW0ie4dAUn/6JPWj/n3WbD450k37CnmB6dTXaG/bpHuEvdFghrCtZNAHVyQzg1yUKoB8KkxOP+FioAegZkHN3rcU/AlkAvN3RtEgyNXd/HmjfJwSEqZN87FDw6oQjeSIFAvt82CylSCmaQ8+8FIj5ruZRMGiGxPX/VzexlbZ4xinOVWZH35Q8xjZ0qQG1aCH39BND6wjSCMzztc7ZJC2fpP5lt0MnJLKYtATz8IOHuUyEm+BxI5pjxa9a10CiQ4YUQjRk/BZjjBt8P2tiUGsoV6zDqG6H9SRMT++4fT47TFNCcZY
 N/7U5Gds
 SzqzE8L/6Ku/vADzoa93ofNgfrvzWxoCOGNC//pm+WOoFvHZZRh5sFDx2FxhU1/pVETyegel/c+ikAwfG9Ig9fQR/w8OD8CHYSaOkrV7YLyDNl95vBsqb7ueHHmvNAhuEpy0VgtTLyFq5WmoP1kIxAOKG8+a5v3UiI4iUWowCLrHefsxao89FJOfhbG7PaHlBcJ9yTYF92/PduG93UxgpXr2h0VBZ3wcvc2AF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:55:23AM +0100, David Hildenbrand (Arm) wrote:

Hi David,

> > +/**
> > + * lazy_mmu_mode_enable_pte() - Enable the lazy MMU mode with parameters
> 
> You have to be a lot clearer about implications. For example, what
> happens if we would bail out and not process all ptes? What are the
> exact semantics.

The only implication is "only this address/PTE range could be updated
and that range may span one page table at most".

Whether all or portion of PTEs were actually updated is not defined,
just like in case of lazy_mmu_mode_enable_pte().

Makes sense?

> > + * Enters a new lazy MMU mode section; if the mode was not already enabled,
> > + * enables it and calls arch_enter_lazy_mmu_mode_pte().
> > + *
> > + * Must be paired with a call to lazy_mmu_mode_disable().
> > + *
> > + * Has no effect if called:
> > + * - While paused - see lazy_mmu_mode_pause()
> > + * - In interrupt context
> > + */
> > +static inline void lazy_mmu_mode_enable_pte(struct mm_struct *mm,
> > +					    unsigned long addr,
> > +					    unsigned long end,
> > +					    pte_t *ptep)
> 
> It can be multiple ptes, so should this be some kind of "pte_range"/
> 
> lazy_mmu_mode_enable_for_pte_range()
> 
> A bit mouthful but clearer.
> 
> > +{
> > +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> > +
> > +	if (in_interrupt() || state->pause_count > 0)
> > +		return;
> > +
> > +	VM_WARN_ON_ONCE(state->enable_count == U8_MAX);
> > +
> > +	if (state->enable_count++ == 0)
> > +		arch_enter_lazy_mmu_mode_pte(mm, addr, end, ptep);

I will also change arch_enter_lazy_mmu_mode_pte() to
arch_enter_lazy_mmu_mode_for_pte_range() then.

> > +}
> 
> I'm wondering whether that could instead be some optional interface that
> we trigger after the lazy_mmu_mode_enable. But looking at

To me just two separate and (as you put it) mouthful names appeal better
than an optional follow-up interface.

> lazy_mmu_mode_enable() users, there don't seem to be cases where we
> would process multiple different ranges under a single enable() call, right?

Multiple different ranges still could be processed, but then one should
continue using arch_enter_lazy_mmu_mode(). E.g. these were less obvious
than traditional walkers and left them intact:

	mm/migrate_device.c
	mm/tests/lazy_mmu_mode_kunit.c
	mm/userfaultfd.c
	mm/vmscan.c

> -- 
> Cheers,
> 
> David

Thanks for the quick review!


