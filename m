Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 072E1C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 10:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215E26B0096; Mon, 24 Aug 2026 06:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6F66B0099; Mon, 24 Aug 2026 06:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC9F6B009B; Mon, 24 Aug 2026 06:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFD636B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:41:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 611C8804C3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:41:00 +0000 (UTC)
X-FDA: 85135820280.01.8F949EF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 059F91C0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:40:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XOZpugly;
	spf=pass (imf21.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787568058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/T14l5efVCoI0cNX+jlXD2DWZPGJ826RLHgjN99Qbw=;
	b=sOMHJCnav+uBCVU/94xCKR1nafzzMdt/kvcU9ZVj5WNIGn/t8f/Xq1Bl27y74MIK+84G43
	ae4To6BcC5Dh7/VTRqTbX0wMz7BlgXpV1Sp/sWDU3ONe1z+/D37bVVWrrLn5JHy6akqxOe
	Os/w8PNavpn1LEAr9u78HrF41/CJ4cw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XOZpugly;
	spf=pass (imf21.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787568058;
	b=5bUeiVYz4jia/v17G20MN2NkvUAsSYi2AeVSq8lVae8L5qTlhh0tyz++VS9tVV5McCYl/k
	FTAlGu4iElFKwJOzVcYQG47uNW1wuW9L0tJrykfPXvhbvqQPjm/JozD5IIy0GyY27iv184
	KkCCsYzDamIIm4hZIZSzdGuqSW3JZcM=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O9VgPI1464568;
	Mon, 24 Aug 2026 10:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=3/T14l5efVCoI0cNX+jlXD2DWZPGJ8
	26RLHgjN99Qbw=; b=XOZpuglywHT95XDBkKH2XQOlca9MSJeRjAzN+AGZkRni0J
	GKKIyWOfrXPYglVth7B14eijjpKHCosOILho3RmiiFsnEMvIGm3L6ETwcgDpvHFU
	iw4AZYuTz6+hO9OLNw1MtIuOgE/g5QR2pOyWRpe8dtpPJ6Uqup8IaX2hWhJw1VnX
	/ybg2Se5FI9ted+4HDlTLUZ+oVV94xCJbmtSsweejythg9pM9vGPlSCuWQ8hvNuJ
	lbv6z8SczAZ9zhX82cc/Gkezik/Q6XQ3FT7iFQeS7HWmMRAXmoaoBqTEHJhKkl7H
	uACwheCeyVvXMzq79QA+0zyTaVRoXSSfgEhOLtpw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g7393rpe0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 10:40:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67OAQIXS006700;
	Mon, 24 Aug 2026 10:40:54 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7pfvwebe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 10:40:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67OAeouP49545566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Aug 2026 10:40:50 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7698920043;
	Mon, 24 Aug 2026 10:40:50 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 197B720040;
	Mon, 24 Aug 2026 10:40:50 +0000 (GMT)
Received: from osiris (unknown [9.111.89.201])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 24 Aug 2026 10:40:50 +0000 (GMT)
Date: Mon, 24 Aug 2026 12:40:48 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <20260824104048.11040Cdc-hca@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: aBBJq1sYD2QAF3RL4IeZXSVPpP4Tbh5_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA4OCBTYWx0ZWRfX75fqlJoYpcj3
 VuqvoN6MREkDOZWVmhgOKtEejDguKYrGKaX9WC9AmF/wtqG8x7StZnzXT4BcbYBgGA8UABHpXmJ
 6wSYvObgT69cn9Jv6xAb75oznLJq47zhjnY9977yWYApGudVgUctPn6Y7OJZjeoSPIwcU/Ea8De
 T6P/+lsJzcs/+pxENUZy4+DBpnsNlrj2KFAIUh97shE564PTUUDkneqLqxITgHTMijXVrVcO3ks
 O4TG0uke1SaDl06qgaReqwLzagGSiZCJFYDrOHd+6hLIHcFt9okYDGvg2KLD1rUAId/6e+yKooC
 6e+0p4zyRzxUjpEKWfFolIfU+3xYGIUwikgrUu6lKGTSY3giO5Ot05NH1X7pQ8tonVxYl1pmoI3
 6P4qtlRs0kAq1OfJllzCSCHmcrPeORSuWksFtBuok0CpQpGzyfLuiMfTKH3G/OTrxNJQrwNuz3V
 wwg/uL9ILC3aXn8wVNA==
X-Authority-Analysis: v=2.4 cv=Y/nIdBeN c=1 sm=1 tr=0 ts=6a8c1fb8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=sTYtNOhqI-yrCGmzPWoA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA4OCBTYWx0ZWRfX5Hr10v06l+bM
 vkQF72efrd/jPqOK1fLCWjVi1yDhxFlUin2rVbLlo5/YRl7U4igHaW3UBmquiQAI1ENXrabks0e
 R0f3d4+bbSCHpIsuJ8aeF4sNQzlPJuA=
X-Proofpoint-ORIG-GUID: 5v_eDg43mIjksVXOeUwea4TJK2IWPwVm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_03,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608240088
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 059F91C0007
X-Stat-Signature: fhncduzyaxyohigz6fmg8fwmi81h8wda
X-Rspam-User: 
X-HE-Tag: 1787568057-244880
X-HE-Meta: U2FsdGVkX1/mYHZ4Mr9DzDYOfEApMlpsQy6ZDsR5TxTL3wXWP5xPhIazgXEaX5C+L1nBnUjD2boalr9GiA0rmtvgGZGSSVdCzyOlPPIJgJv0MplRb3EWeSp1CAf/752Av7I69LBVSLdyaQiUG7BCD+QbRxBME7xhPUUewPZEZTqmAkS7UVLbcW9rg5DHrvY+qFVwjZkyp2nELrIx+jw6CvwhL96xYr3YpXXbBOFGXEtla5vKQzIWrhKCf+Fem8mgdnbXqsmNh7GBfQKTF268938LSaoVZbFLtIA59aDzkzOlzl9FKGbDMxZakEv2FBn3U51P7I7AjfeOqDu7LM9SOmzUWNa6+dwGwuTsx5vHfBVhpDQs3o/5Ic5EO/YOOGMSlFzqPYvmbsLeXPCzpaG/swB7AtQCSCgFGox7bgddZRreBDJbExN4DLO0FYxfvwfaWzJdWzmFK8w9eoUIZx3tMNScCVQ8oXB5yyG3pu7xrbcAZZNDJHBrYUNBXVtlKus5VW6briWh9rzQehEKO1Ds/QOg1bAsJ8R4SNIKr03EMjzOk+E9oQrddaXTcYnD+rQ8qru0hUHdiGCktfAK4Drj+zbTo7LL+h3xR50tijKH56bXDUJJAhcccemxUStXEqWjWpIDiaRnaufW/lmTIihU9AxCc/hFSUEUjYqQNJixUxi1AHib2ZXCg8IVGtYpRuc2Rf20eor2xf6mk9KzobGIxqpcDoGbCe6Ehx7NsGTt7ANc1GwW4a4Qp0lHw3cx6uPCEX1CGf63lKI3xOMnc0Hlok7ylQJ2a3Sz8o7rnZHNcxtQGaMslMikplAB9Ew2ss2xqnEDXSz2GHfVmNRu2JwbWG5kYevNeykZJbXwpvUsCqNwkbjyDb4JxQw85iD2hlHwWn2Tztm2jZPTOEtN6rNboNAAEC2dLP+2hvuVl51OevwkiiGcbe/VmoQfoWTNuUT9nNUMEsoA6BtsU19yGf8
 tl0mxvs4
 7KRoDcfpq8r1xbguYFoeR4TUhdlH1ZrVsaK7BCHvREY5weOtXJPU5Oc4/8drze+3TvrY2Blin534LmHYIOQj7NnkAm78gLa7lPKi2h5RnAQ52usy+EPB/VPe+HECgwON1gRx/bUe4zH99D6UKDRzGQMET2WBaOr8lWc+Sw1gXfWEfyB+KOl3TwmiEpHv+kbo9IoIJxZvfjIQBKQGRyyN5m7XiyO4aVCYDeu4MnVMIaS4QJwyGAWXML5OYaIwYUiQu58j0mvxz2gpalUUCxXiNbdAtMnGFZsaB7zdOATLzqAxXIdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 01:33:00PM +0200, Alexander Gordeev wrote:
> diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
> index 3b3ecc647993..dba236664da9 100644
> --- a/arch/s390/include/asm/lowcore.h
> +++ b/arch/s390/include/asm/lowcore.h
> @@ -163,7 +163,7 @@ struct lowcore {
>  	__s32	preempt_count;			/* 0x03a8 */
>  	__u32	spinlock_lockval;		/* 0x03ac */
>  	__u32	spinlock_index;			/* 0x03b0 */
> -	__u8	pad_0x03b4[0x03b8-0x03b4];	/* 0x03b4 */
> +	__s32	lazy_mmu_count;			/* 0x03b4 */

Why is this signed? Can it get negative?

> +static __always_inline bool is_lazy_mmu_active(void)
> +{
> +	if (__is_defined(__DECOMPRESSOR))
> +		return false;
> +	if (!get_lowcore()->lazy_mmu_count)
> +		return false;

I guess there is opportunity to generate better code here using an
alternative and using a flag output constraint too.

> --- a/arch/s390/kernel/setup.c
> +++ b/arch/s390/kernel/setup.c
> @@ -77,6 +77,7 @@
>  #include <asm/maccess.h>
>  #include <asm/uv.h>
>  #include <asm/asm-offsets.h>
> +#include <asm/lazy_mmu.h>
>  #include "entry.h"
>  
>  /*
> @@ -1012,5 +1013,6 @@ void __init setup_arch(char **cmdline_p)
>  
>  void __init arch_cpu_finalize_init(void)
>  {
> +	lazy_mmu_online_boot_cpu();
>  	sclp_init();
>  }

What makes this code so special that an explicit call from
arch_cpu_finalize_init() is required? This is really the last resort if
everything else fails. To me it looks like the code can be changed to use a
new static key, and add a generic early (pre-smp) initcall to allocate
memory for cpu 0, and if that succeeds enable the static key.

> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -59,6 +59,7 @@
>  #include <asm/topology.h>
>  #include <asm/vdso.h>
>  #include <asm/maccess.h>
> +#include <asm/lazy_mmu.h>
>  #include "entry.h"
>  
>  enum {
> @@ -866,6 +867,11 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
>  	rc = pcpu_alloc_lowcore(pcpu, cpu);
>  	if (rc)
>  		return rc;
> +	rc = lazy_mmu_online_cpu(GFP_KERNEL, cpu);
> +	if (rc) {
> +		pcpu_free_lowcore(pcpu, cpu);
> +		return rc;
> +	}
>  	/*
>  	 * Make sure global control register contents do not change
>  	 * until new CPU has initialized control registers.
> @@ -921,6 +927,7 @@ void __cpu_die(unsigned int cpu)
>  	pcpu = per_cpu_ptr(&pcpu_devices, cpu);
>  	while (!pcpu_stopped(pcpu))
>  		cpu_relax();
> +	lazy_mmu_offline_cpu(cpu);

Same here: what makes this code so special that this needs to be open-coded
into the low level cpu hotplug code? Everybody who needs to change this
code in future will wonder why the mmu code is so special that it needs to
be directly handled here, and then needs to understand the mmu code.
And the answer is: there is no reason.

Please use a generic cpu hotplug notifier to avoid that maintenance get's
more expensive.

> +static void leave_ipte_range(void)
> +{
> +	pte_t *ptep, *start, *start_cache, *cache;
> +	unsigned long start_addr, addr;
> +	struct ipte_range *range;
> +	int start_idx;
> +
> +	if (!test_facility(13))
> +		return;
> +
> +	local_bh_disable();
> +
> +	lockdep_assert_preemption_disabled();
> +	range = this_cpu_read(ipte_range);

Why is it required to disable bottom halves? A comment would be helpful.
Or a hint in the commit message - this is not obvious.

Also at least for !PREEMPT_RT (which is always true for s390)
lockdep_assert_preemption_disabled() is quite pointless, since
local_bh_disable() just one line above disables preemption.

I guess you wanted to add that check above local_bh_disable()?
If not you could as well remove it

