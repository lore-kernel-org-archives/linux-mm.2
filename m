Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C5CC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B49D6B0088; Wed, 26 Aug 2026 08:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265C26B008A; Wed, 26 Aug 2026 08:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154706B008C; Wed, 26 Aug 2026 08:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF7A76B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:00:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0693DC035D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:00:47 +0000 (UTC)
X-FDA: 85143278934.21.34D626B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5DEC4180005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:00:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Pqrf08iF;
	spf=pass (imf16.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787745644;
	b=quQmfMuuQDM00wC3FCev68jnAw0eY6LqonRd6758oJHzY5I2Hn8CKBEicMqIW0DFf4PztZ
	ldb2UEjdTJP4cvykAFlvIcdMnV7LYNy7AZysl4pteKt/+1A9svskS5vNMn68iLDmK90bGx
	qxCBxCJzhEh1der1oYB+NSyrcN9oklM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Pqrf08iF;
	spf=pass (imf16.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787745644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Lte/JG73+5z86dGkC+agEMMyLkjgi7tuAML+5SoenU=;
	b=ntbdO7DrOgylYkKHz3gpppmKzsZdFLYp1GEtpOhJ2KKsUQO6xBNObe9/y410KJfAQMMwOk
	HWPSmkXy5IIZQeY/fdgn9YGH2R7zLSJvG00HqC3xjRdC5uQtmaVmcBxlzNIVBEDm/PGsI1
	frIHr2eqeM5kHqv+/rgBL2juVQ59nKY=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QAVU9d3739157;
	Wed, 26 Aug 2026 12:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=9Lte/JG73+5z86dGkC+agEMMyLkjgi
	7tuAML+5SoenU=; b=Pqrf08iFyU0Txg7bl1UXE29GGewN77RVV7ev3tDNxjVrUq
	TtVb9E2LkCSG5npOn3JYbLByKVTHnmmGTSusnwTQjDkTcv+W93xmMtpi+2lsxXDJ
	x7jh0hYxe/BnMiJmmBwhEc8MFxElr8PUiA7HjvdWFN61tMax+TCcLwYWQFNQgwFT
	AFgPTZJoUGNyjWBMv+N4p8pdRU1gOEjr/3yTjI4js5EzW85LwsxsQ3JZht5gLG+e
	HJMQEJJ30LUcWQInodopVewsnKZsmdGjWTFqcWtFspU4z2qn+141ulWIoiHGSUtJ
	qU7WjhZ3s7x0WI1KLmvcEhA4lDUMyujzTfTUQxbw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g4xech-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 12:00:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67QBuMbj027452;
	Wed, 26 Aug 2026 12:00:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7rsy9ghy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 12:00:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67QC0a4I45351204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Aug 2026 12:00:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C067420043;
	Wed, 26 Aug 2026 12:00:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97F2320040;
	Wed, 26 Aug 2026 12:00:36 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 26 Aug 2026 12:00:36 +0000 (GMT)
Date: Wed, 26 Aug 2026 14:00:35 +0200
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
Message-ID: <73a0a916-b39f-4ebe-bffe-448928b13bef-agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824104048.11040Cdc-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: EB78NUWuPZ_duP5qC6CvmhT3sdHvrnXc
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDA5NiBTYWx0ZWRfX35fYzacGE6vM
 sTpgk2sZI6d6tdheEo4xvmxLVBuvnCIkhKccnb0g7tj56Jzel3qGi1I2k5M6yk2njZcft+/ZxaV
 GPbHpAT2tbtQ6wDxCNWx5NBbfJOhAM0=
X-Proofpoint-GUID: _e6KY_kDphJ4zMgcsekTyrnXocFdBCT1
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a8ed569 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=YzGQrp0F13CB_97CXrgA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDA5NiBTYWx0ZWRfX/JuboW12LqpG
 8lRZgu0LqWEx/zm4VEtasa+x2DYDutyLUsRYazAygjWSJ5l7z40UNXBLDXHvxNwiaS2hiadW9RP
 Nv6gYnFneCkEuWkBAH3bj4Pji6oqj7VmHdA9zCoiGumZXP4mIT7yOflByO0FB99IGO/1IOE1RLh
 euVHFmUbiX8Q/ZXyH3wuvPyxmOsHESysiJGiqq/YD+wm2Y5VEKninQKWzO+tnvlBxq0gM8A4flp
 T+Cdu74vz08RC2epooXJNC2eGiDvYOVgP23q9Lcl7YOt89CCXgMpqnx/k6Ux2bU1OoOzdgBNA6G
 5p5Qmr72Aux8EEAn8V3c6AWsPXAGKHi/xte2ikeXvl8Qa6xcvxUcwDKCnuUwsk8croA6iDod44b
 KtcMN97kQOxUEXrHlJk5woLlCr1OYvnBHPFI8JUUgXgiHZRH/H/gyxApriUeS+Drtj+bd01gjxV
 GF5/APlWuTDP0tkbrug==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_03,2026-08-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260096
X-Rspam-User: 
X-Stat-Signature: qy4xpoc4df571o48tunb88dtc5i5rpuo
X-Rspamd-Queue-Id: 5DEC4180005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787745644-191274
X-HE-Meta: U2FsdGVkX1+xWjTUsnn0UEFsgPhDJRQQEqq03ZHtnTpxlki2+n3FtOSzbaXh1XvFiU+zbu/Q6+spbvzl0FnukV/WuocwRBw2wnitF5HmaZU/o5B3Js+M4Omy2dovkWRZM0t/i2xYTuRo4r1tjpOJ99DlU1LmPNJxSJjAAk0fPc0Sm18t5YR7IpwReZ/myk0X01u1OOD+um3vPyBZAWhOKGpJSSbLwnJSxhNRujTS7iZ3+ZCdfzjgRZF+aKSdcJrJg2S88/ae1RD9hgekZ5Z4dYKeLGsfY2MIq8bTzdBWqCtov5jwPhAgKdhCchmrYpyeiMcZ2ikZ++x747htief/E/+nFrH5y50f3zXD+TsJCe2ZVXrbi2YiE66XbvcPTcvngqaDuuSqLKTpFM2f4wOjROVaEdD0GFiTguXx2sTZtEVDIFZWJLZCFcRrfj9n/7TcoVvpPJV5kysb3SXkm5aZMk//FNE/7HH+9boDwSK5An6GVC2kC2DS9STr9Ylu5nlX4NFgtx9U2qhoM7+XjdXmgAndrzwI58mUnF2fD7EcRwe0s3TN/VnKUqOpGJ85o+n1ElO6weLLkD2/vtHSV07T7OEAcy940A5Gakpnml1d7ZQ979McD8QmExigKwsySUuKPFBi07EL+UGtsYlbDcBbBGAhaTfRi3Is4pETq0pMJFz1k1HV6pvkLTUa7rcnb4nHSLEgqEOYebEmKN7jqxYTGn8Kx53Vl38JhHIAyekV6HFfstlH6TKKnrY+nyNFf1Ucb6fMmvf/8d/3qCXlXfQhLknKJltBVmMnoP3kO3ePA/VLWDcG1aoRFNu+KkQysU+qaoH6gLPRMALNb2+mEXLcLjCPNwYzdc7bGi4b/smZDn5kv6C9bB6TH3Wiw6t8w1bc2x06EzwO1kKZz9/yHxA1zkXReE2qVjmXoFBGNHH/m5fwWsywRy/GrYaPZCZ6ws6UnOEcaxfQIW8JcTPvrji
 tibvmQH0
 CZUxfjmYa1o9OyDZAq8Pmq7ILY4gaFjoXc/zFv0uWO8sHbmoDhFLzRjEiBRlA3S3TQBKwTTHZPsdMgI03CK7Np+aFTeZ/ye3nDbQ/3pQ8r1tynELu5qQYg7o2EEw06vJWPSFfiQUcOH6dzry4ijKCc1Z2CHtekJg31oS2EfhBkG9YRfANqLiLjeN/gKhNlEYRQcNemSxTEM2Axm08BuV0zLz0mlg0yARRFazwvL2KhJxCL0zJR9Id4/3UJ3oA9fMRlcZ/CLZS6411Xhs62/43bwIqPvltNPVFX+dlGJDN75+ZKw6jyL9UEuRAvHPkLGOxZFyjdC6ZPIzGGdMpABE4sDE2oYvr22o21dBw54bW7ED4RGwlGKDc6YZV+njhKRvDJYdVPrkFCc8d+3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 12:40:48PM +0200, Heiko Carstens wrote:
> On Mon, Aug 17, 2026 at 01:33:00PM +0200, Alexander Gordeev wrote:
> > diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
> > index 3b3ecc647993..dba236664da9 100644
> > --- a/arch/s390/include/asm/lowcore.h
> > +++ b/arch/s390/include/asm/lowcore.h
> > @@ -163,7 +163,7 @@ struct lowcore {
> >  	__s32	preempt_count;			/* 0x03a8 */
> >  	__u32	spinlock_lockval;		/* 0x03ac */
> >  	__u32	spinlock_index;			/* 0x03b0 */
> > -	__u8	pad_0x03b4[0x03b8-0x03b4];	/* 0x03b4 */
> > +	__s32	lazy_mmu_count;			/* 0x03b4 */
> 
> Why is this signed? Can it get negative?

For the same reason preempt_count is signed, I guess.

No, it can not get negative and it is very handy to observe
a disbalance in a crash (I did hit it indeed while debugging).

> > +static __always_inline bool is_lazy_mmu_active(void)
> > +{
> > +	if (__is_defined(__DECOMPRESSOR))
> > +		return false;
> > +	if (!get_lowcore()->lazy_mmu_count)
> > +		return false;
> 
> I guess there is opportunity to generate better code here using an
> alternative and using a flag output constraint too.

Will try.

> > --- a/arch/s390/kernel/setup.c
> > +++ b/arch/s390/kernel/setup.c
> > @@ -77,6 +77,7 @@
> >  #include <asm/maccess.h>
> >  #include <asm/uv.h>
> >  #include <asm/asm-offsets.h>
> > +#include <asm/lazy_mmu.h>
> >  #include "entry.h"
> >  
> >  /*
> > @@ -1012,5 +1013,6 @@ void __init setup_arch(char **cmdline_p)
> >  
> >  void __init arch_cpu_finalize_init(void)
> >  {
> > +	lazy_mmu_online_boot_cpu();
> >  	sclp_init();
> >  }
> 
> What makes this code so special that an explicit call from
> arch_cpu_finalize_init() is required? This is really the last resort if
> everything else fails. To me it looks like the code can be changed to use a
> new static key, and add a generic early (pre-smp) initcall to allocate
> memory for cpu 0, and if that succeeds enable the static key.

I had exactly similar variant, but failed to resolve a race when a secondary
CPU callback was called before the CPU0's one. Probably, used a wrong event.
Will look into it again.

> > --- a/arch/s390/kernel/smp.c
> > +++ b/arch/s390/kernel/smp.c
> > @@ -59,6 +59,7 @@
> >  #include <asm/topology.h>
> >  #include <asm/vdso.h>
> >  #include <asm/maccess.h>
> > +#include <asm/lazy_mmu.h>
> >  #include "entry.h"
> >  
> >  enum {
> > @@ -866,6 +867,11 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
> >  	rc = pcpu_alloc_lowcore(pcpu, cpu);
> >  	if (rc)
> >  		return rc;
> > +	rc = lazy_mmu_online_cpu(GFP_KERNEL, cpu);
> > +	if (rc) {
> > +		pcpu_free_lowcore(pcpu, cpu);
> > +		return rc;
> > +	}
> >  	/*
> >  	 * Make sure global control register contents do not change
> >  	 * until new CPU has initialized control registers.
> > @@ -921,6 +927,7 @@ void __cpu_die(unsigned int cpu)
> >  	pcpu = per_cpu_ptr(&pcpu_devices, cpu);
> >  	while (!pcpu_stopped(pcpu))
> >  		cpu_relax();
> > +	lazy_mmu_offline_cpu(cpu);
> 
> Same here: what makes this code so special that this needs to be open-coded
> into the low level cpu hotplug code? Everybody who needs to change this

This is just a follow-up of the boot CPU initialization above.
AKA "Do not use CPU hotplug events".

> code in future will wonder why the mmu code is so special that it needs to
> be directly handled here, and then needs to understand the mmu code.
> And the answer is: there is no reason.
> 
> Please use a generic cpu hotplug notifier to avoid that maintenance get's
> more expensive.

Will retry.

> > +static void leave_ipte_range(void)
> > +{
> > +	pte_t *ptep, *start, *start_cache, *cache;
> > +	unsigned long start_addr, addr;
> > +	struct ipte_range *range;
> > +	int start_idx;
> > +
> > +	if (!test_facility(13))
> > +		return;
> > +
> > +	local_bh_disable();
> > +
> > +	lockdep_assert_preemption_disabled();
> > +	range = this_cpu_read(ipte_range);
> 
> Why is it required to disable bottom halves? A comment would be helpful.
> Or a hint in the commit message - this is not obvious.

When an interrupt arrives in the middle of enter|leave_ipte_range()
the chain pcpu_addr_to_page() -> vmalloc_to_page() -> ptep_get()
decides ptep_get() is called in lazy mode, while the per-cpu state
not yet (de-)initialized (AKA inconsistent). That led to crashes:

    [    6.784258] Call Trace:
    [    7.784260]  [<0013d8935c3fe9dc>] pcpu_free_area+0x11c/0x3f0
    [    6.784265]  [<0013d8935c400bb6>] free_percpu.part.0+0x1b6/0xc70
    [    6.784270]  [<0013d8935bd8931c>] sched_free_group_rcu+0x2c/0x60
    [    6.784274]  [<0013d8935bea9196>] rcu_do_batch+0x2f6/0xdd0
    [    6.784280]  [<0013d8935beba0d0>] rcu_core+0x270/0x4e0
    [    6.784285]  [<0013d8935bd0a4b4>] handle_softirqs+0x294/0x800
    [    6.784289]  [<0013d8935bd0b020>] irq_exit_rcu+0x140/0x200
    [    6.784293]  [<0013d8935e26d994>] do_ext_irq+0xe4/0x330
    [    6.784298]  [<0013d8935e28c25c>] ext_int_handler+0xec/0x118
    [    6.784303]  [<0013d8935bc9764e>] enter_ipte_range+0xfe/0x1a0
    [    6.784308] ([<0013d8935bc975f6>] enter_ipte_range+0xa6/0x1a0)
    [    6.784313]  [<0013d8935c4432ce>] zap_pte_range+0x9ee/0xef0
    [    6.784317]  [<0013d8935c443a44>] zap_p4d_range+0x274/0x710
    [    6.784321]  [<0013d8935c44411c>] __zap_vma_range+0x23c/0x450
    [    6.784325]  [<0013d8935c445078>] unmap_vmas+0x1c8/0x440
    [    6.784329]  [<0013d8935c4a8f46>] unmap_region+0x196/0x320
    [    6.784332]  [<0013d8935c4ac174>] vms_complete_munmap_vmas+0x734/0x990
    [    6.784336]  [<0013d8935c4aec74>] do_vmi_align_munmap+0x2a4/0x3a0
    [    6.784340]  [<0013d8935c46138e>] __do_sys_brk+0x5fe/0x750
    [    6.784344]  [<0013d8935e26d3be>] __do_syscall+0x17e/0x3f0
    [    6.784348]  [<0013d8935e28b882>] system_call+0x72/0x90
    [    6.784352] Last Breaking-Event-Address:
    [    6.784353]  [<0013d8935c3febea>] pcpu_free_area+0x32a/0x3f0
    [    6.784361] Kernel panic - not syncing: Fatal exception in interrupt

> Also at least for !PREEMPT_RT (which is always true for s390)
> lockdep_assert_preemption_disabled() is quite pointless, since
> local_bh_disable() just one line above disables preemption.
> 
> I guess you wanted to add that check above local_bh_disable()?

Exactly.

> If not you could as well remove it

Thanks a lot for the review, Heiko!

