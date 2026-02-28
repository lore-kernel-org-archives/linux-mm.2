Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1229FEE4EF
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 13:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8556B0005; Sat, 28 Feb 2026 08:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776666B0088; Sat, 28 Feb 2026 08:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674FD6B0089; Sat, 28 Feb 2026 08:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56B356B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 08:46:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF3061BFE5
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 13:46:49 +0000 (UTC)
X-FDA: 84493990938.28.6C0031C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62095100003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 13:46:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rgOOaLKc;
	spf=pass (imf14.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772286407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0EXJKQ8KgtoZoI2jIZ7waJGT1vVb8Eepe+V8HPryizQ=;
	b=5tsEwIGoyqpvaPcOLAUGDObLbGuXdjJBbq2Dwf/eCykapbRptXrj2cVqpWLY3njtQ0JAls
	NIbXfHdRf5KUVh3GZHxGYpjrgEE/roJvlcG+DkfxJ2hfSyk4esdb5MhW6MkBb1MdEQ9v6X
	b7OxYfN2Zb+2ZpafwGIOR9W51HWer6Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rgOOaLKc;
	spf=pass (imf14.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772286407; a=rsa-sha256;
	cv=none;
	b=wpQLPIY+zOc3+g3EYxE770Adm6s6gTJGzhIOBCK6DSiqDqUg2MWMjpV74TPLGdKg0HR4xY
	oVtGzfLYgNdgQfnpDR0CtrXvDS9LeUUfa/NhPkXnrTI2IDYOpSuXdE7FmhC5NJKS4J9sE/
	U3WUpe+J7YswC3No6gJQS4ic8uAtdCE=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SDjoPq2612896;
	Sat, 28 Feb 2026 13:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0EXJKQ
	8KgtoZoI2jIZ7waJGT1vVb8Eepe+V8HPryizQ=; b=rgOOaLKcnwkp9J35cdBDUf
	lCHPdkUzz5Vyzwb3HzWiwUg0zsFc0WXpScsOfZ7uW38Aex6UC76IMQWpQerTwxW9
	l8UrdT0EM4yrHSZAwdwN5mCWsqjpV1ePxBfqjrND6P1fu+GOsiwlybzpWv8QaJSc
	F4tUYexie9FTSeFKsvrQYj+wsTR/WmT1Nf3krpGnu7vXY8Kwba8NylOc1UcPgFMl
	6U2G1cFI12w/pCHjRgXSSmtNwA0SSkOeDuBU2GUHxOdsRI9q0d+0/lZfjZNwIgB0
	IjJ9xBcsEjTpie1HXiK+NoQ/e9cghsCr3NBysykbjMEQIi1LmB1KPH+y3sgSG7jw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskbgxa7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Feb 2026 13:46:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61SAjDH7004541;
	Sat, 28 Feb 2026 13:46:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfs8kej94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Feb 2026 13:46:30 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61SDkQQo43319576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 13:46:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E20B42004B;
	Sat, 28 Feb 2026 13:46:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40FCC20043;
	Sat, 28 Feb 2026 13:46:24 +0000 (GMT)
Received: from [9.124.209.149] (unknown [9.124.209.149])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 28 Feb 2026 13:46:23 +0000 (GMT)
Message-ID: <6a0fc7ec-591e-4f23-b0f2-aec9aea88621@linux.ibm.com>
Date: Sat, 28 Feb 2026 19:16:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: powerpc/fadump: CMA init is failing
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Donet Tom <donettom@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>, linux-mm@kvack.org
References: <4c338a29-d190-44f3-8874-6cfa0a031f0b@linux.ibm.com>
 <87o6lagljy.ritesh.list@gmail.com> <aaIDkB2xLABDyV1y@kernel.org>
 <87ms0th9xt.ritesh.list@gmail.com>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <87ms0th9xt.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 64-aI1JSamPa6-OAXTjSFOkfn4ujOU34
X-Authority-Analysis: v=2.4 cv=b66/I9Gx c=1 sm=1 tr=0 ts=69a2f1b7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=47IChveiNnVNrxUg3wQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDA1MCBTYWx0ZWRfX2DF1OSDfsUT/
 ZYtsLcbSEit8DeUesUF/nKYn3Esq4ytJOBtNbtLetsiUYJOOD3PvBtv61FTuQmESBLnSyYYzrie
 l7AbG8/mR4YA4Yi8JEDELsWV/eFgFg7rqZWuZYzWtwKRFnNA6zy8OPFEWmBT81DqOvl6O6h/7aB
 OrvxFmwY6H5hsjsNubJaNfqc13lPHHUKAUp/6oE6BbYwLECUutRlHP7rcK5CcU4Fno2m4vraF7m
 N3TZ6CWLk1mVbfzYI9oQb85A7cSev4vfBocvaKRwr5b4pqehKi5XyWK9n1chVg1z5Ey+T9kruQS
 SPLoJfoIi0x7hGdtprWo1ksvVqs9M1OXMIFkn7EBR2HQFMCrptcj5XjRjtrHFWrpuTRV/LrGirw
 w1ehCXAW6hBITQLj0jhzdb67OPX4rI47EDoXFZV7yNVxF5UCMLaFwK/yJFaAdtOZzC/nt4m613q
 zrqrGk5po2cVcDYLZYA==
X-Proofpoint-GUID: HnsQ0w4ztJoCl79kBZBod7RF8wisJzvH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_01,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602280050
X-Rspamd-Queue-Id: 62095100003
X-Rspamd-Server: rspam07
X-Stat-Signature: dzufn8ddm8i98mz6x5ngc6nwaepq3qw3
X-Rspam-User: 
X-HE-Tag: 1772286407-284193
X-HE-Meta: U2FsdGVkX191eayvj9M3i79NRt1Btb533gCt3TBX/jX9UULnpabkjM38Ajhz/3YvpBjYao+0gIplCX57wmCXhyrpxjPn3tr8Aa5Naf1APCWOOjXG/fs7uCMOY/iUEKau+j56bl6w41frm5OAbNz/EG+YCM1Xgf0SihELrdZ7dwFmc8phs78jhq8nxUcqOGFOHPPk6e8ghXR+NO2MwITenKNgvJV0ifQCPadpGdhYLB29mBu9pcSUyKUeP0FGcq3KWlW6gjP/2BrgT4LCX9dFNOMgkCPxmzhp2iJVKP1n0FtXBuueq/lMsp2pc7gq0VyxkKsy3BGFsFxX09mIIq1gdE/MNTzPZJSgP+H9s04GtXhilEQjOPN5AQa8VCHgxzIkAVc0lC7PDQQScXLxDKwGRi06oYTexXxYINW7J3LJnJyIGgu526a7dWG3ip5kCTFk0/SueZ3XsIBSK5YaBbZFGQkoBB9LYkRkdJP1x8tt+ePv5uP5uTZCv0xaSVF6ZSKFs3v/ust5kpbTSK+NO6uWzzwCyeNqJebAoh99OQ6n6w7Xb9P7qNdY/GzCA6F5l8nz2+bBmbhirBgHo+0eRdMtodYD6gq7P4FDsdoz2cNbEVtgduua6RtBdParmAbZSvtJQ73Q5+OqizfIWBfb7EMr7C6ROyynzuFimBlqAI84EH0I576fa8g5H3yCmFh/2v1CbUN6lji/U71Hzmm1wi3Tk3r0dih9sY1Aj1263juL9HMcPI79KzZ4Z3AvYNJJ2O2WpjxQpWi0Nm+FT2cTeWJiwF8KaeoiqnzOXpOpT6im9Jkt55XrcIP8mx3DYWMulClOkL106DF+8bH2pFOGv6qnKFXnR/+t+yYhyc9+pVGvhRVmh5JBRkIXRaspirS4zHgWSyq3nKCO8cXLE0PVBFunUCBwmrfXanf00SzQa11gHQSSZPnrDmE28lQiiOLBozlp2WFo1hV8QiOccacThDa
 7nKC5XK0
 PDn1EFUONnusfTrJJowpLLPAK87ouOhln18HjH/JBgLjTx2HxhauKl9DZSVY2Nc8TKQQHPusiycf/QcsewxF1W2GpQYzuXztPk9dgZkZIZPefhZFcVrURPBmxQ+OAR5eSymGYAoJDkDuJsczubMxAiI2/QRXlOO23j+l680gq5aCmOiKZ1Ky9BjAfQBpTxre1ItCHqaJCaTIii41l1zioosrxXubzZBWYgTUiPDJwwvZgc7hQ0MDJYY8Yukcru1jYs1wELfOvFitxb3tfnN8SpNaYKO4XLs5W2PHDU3AvCpbUyLXSxMq9sewGHjj1bKd9p1QUg6+rW/KsUTqHb/aaAaT12oH2iVdh0570HypjnQcShFUvNS9D0WQt6b0XL+suB/GNyHrCS+xwCcpPSa3/8UIYs1h0XZvZ/mV4wbDrXtmR4Q1SuB4jx12I/u+uHfUpQ7y7wiHYCtSlMm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ritesh,

On 28/02/26 08:05, Ritesh Harjani (IBM) wrote:
> Mike Rapoport <rppt@kernel.org> writes:
>
>> Hi Ritesh,
>>
>> On Fri, Feb 27, 2026 at 10:39:53PM +0530, Ritesh Harjani wrote:
>>> Sourabh Jain <sourabhjain@linux.ibm.com> writes:
>>>
>>>> I noticed CMA init for fadump crashkernel memory is failing.
>>>>
>>>> [    0.000000] cma: pageblock_order not yet initialized. Called during
>>>> early boot?
>>>> [    0.000000] fadump: Failed to init cma area for firmware-assisted
>>>> dump,-22
>>>>
>>>>
>>>> kernel command-line:
>>>> BOOT_IMAGE=(ieee1275//vdevice/v-scsi@30000070/disk@8100000000000000,msdos2)/vmlinuz-7.0.0-rc1+
>>>> root=/dev/mapper/rhel_ltcden3--lp12-root ro
>>>> rd.lvm.lv=rhel_ltcden3-lp12/root rd.lvm.lv=rhel_ltcden3-lp12/swap
>>>> fadump=on crashkernel=3G
>>>>
>>>>
>>>> Same issue with kdump CMA reservation:
>>>>
>>>> [    0.000000][    T0] cma: pageblock_order not yet initialized. Called
>>>> during early boot?
>>> Good that we added those debug prints ;)
>>>
>>> I think I know what went wrong, as part of this arch,mm consolidation
>>> patch series [1], I think the order of initialization is changed.
>>>
>>> With this patch the new order is ...
>>> start_kernel()
>>>      - setup_arch()
>>>         - xxx_cma_reserve();
>>>      - mm_core_init_early()
>>>         - free_area_init()
>>>            - sparse_init()
>>>               - set_pageblock_order() // this sets the pageblock_order.
>>>
>>> Whereas earlier set_pageblock_order() was called from initmem_init(),
>>> just before cma reservations were being made.
>>>
>>> start_kernel()
>>>      - setup_arch()
>>>         - initmem_init()
>>>           - sparse_init()
>>>             - set_pageblock_order();  // this sets the pageblock_order
>>>         - xxx_cma_reserve();
>>>
>>> So that means, pageblock_order is not initialized before these cma
>>> reservation function calls, hence we are seeing these failures.
>>>
>>> setup_arch() {
>>>      ...
>>>
>>> 	/*
>>> 	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM and
>>> 	 * hugetlb. These must be called after initmem_init(), so that
>>> 	 * pageblock_order is initialised.
>>> 	 */
>>> 	fadump_cma_init();
>>> 	kdump_cma_reserve();
>>> 	kvm_cma_reserve();
>>>
>>>      ...
>>> }
>>>
>>>
>>> So what if we do..
>>>
>>> start_kernel() {
>>>    ...
>>> 	setup_arch(&command_line);
>>> 	mm_core_init_early();
>>>      setup_arch_post_mm_core_init(); // and here we call CMA reservation functions ?
>>   
>> Unless I'm missing something these cma reservations can be moved to
>> arch_mm_preinit().
>> It runs after mm_core_init_early() and before memblock moves the free
>> memory to the buddy.
>>
> Right. I think, we should be able to use that...
>
> @Sourabh,
>
> I don't have access to the systems (travelling back...). Could you
> please give this a try?
>
>
> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
> index cb5b73adc250..b1761909c23f 100644
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -35,7 +35,6 @@
>   #include <linux/of_irq.h>
>   #include <linux/hugetlb.h>
>   #include <linux/pgtable.h>
> -#include <asm/kexec.h>
>   #include <asm/io.h>
>   #include <asm/paca.h>
>   #include <asm/processor.h>
> @@ -995,15 +994,6 @@ void __init setup_arch(char **cmdline_p)
>   
>   	initmem_init();
>   
> -	/*
> -	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM and
> -	 * hugetlb. These must be called after initmem_init(), so that
> -	 * pageblock_order is initialised.
> -	 */
> -	fadump_cma_init();
> -	kdump_cma_reserve();
> -	kvm_cma_reserve();
> -
>   	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
>   
>   	if (ppc_md.setup_arch)
> diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
> index 29bf347f6012..5ba947e4fe37 100644
> --- a/arch/powerpc/mm/mem.c
> +++ b/arch/powerpc/mm/mem.c
> @@ -30,6 +30,10 @@
>   #include <asm/setup.h>
>   #include <asm/fixmap.h>
>   
> +#include <asm/fadump.h>
> +#include <asm/kexec.h>
> +#include <asm/kvm_ppc.h>
> +
>   #include <mm/mmu_decl.h>
>   
>   unsigned long long memory_limit __initdata;
> @@ -268,6 +272,16 @@ void __init paging_init(void)
>   
>   void __init arch_mm_preinit(void)
>   {
> +
> +	/*
> +	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM
> +	 * and hugetlb. These must be called after pageblock_order is
> +	 * initialised.
> +	 */
> +	fadump_cma_init();
> +	kdump_cma_reserve();
> +	kvm_cma_reserve();
> +
>   	/*
>   	 * book3s is limited to 16 page sizes due to encoding this in
>   	 * a 4-bit field for slices.

The above changes fix the issue. CMA initialization now works for both 
kdump and fadump.

Thanks for the fix.

- Sourabh Jain

