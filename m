Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D04105A583
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83F56B0089; Thu, 12 Mar 2026 07:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EB56B008A; Thu, 12 Mar 2026 07:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B520F6B008C; Thu, 12 Mar 2026 07:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3836B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:13:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EF01C0586
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:13:00 +0000 (UTC)
X-FDA: 84537148920.09.75618B6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8341F4000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:12:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CkvJemL8;
	spf=pass (imf27.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773313977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFwb11X0zrrF96hDRnrNne+UfFUOQp/uf8JCpdTCVwI=;
	b=6XXcq4mn1Iv9ncwfmj1/8w305Q/M/zG0x6nAmNC9abBgzJOxtJdo5DHi8zzUNywwiIDcXB
	yfKTa25WhN/VU8ESJTAtJsSvclb52Ny81y3h1nYJdyi1ixoW4Ok6OMZt8N2w20uAqknrG5
	WlNDnlgOZ2ZVuaz0ox0NWcyVJNkuMag=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CkvJemL8;
	spf=pass (imf27.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773313977; a=rsa-sha256;
	cv=none;
	b=3u51imQkgSs78JA38OLOYfwKV6cwweQJvZzfVzSq02gpKhy4ggAUuBNyUj2fqCU93oHyzp
	JRO0yRU3m9YLztt2eeV/gnD4S9CA9tFNfPWS1GLrAbZRgO2tftsCsjuLqi3PZZciIhRH/d
	BgWnkrLUhNaQQR60z6i100y+CjUq7jI=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMWPq02279397;
	Thu, 12 Mar 2026 11:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qFwb11
	X0zrrF96hDRnrNne+UfFUOQp/uf8JCpdTCVwI=; b=CkvJemL88mOKrQnUYcuUw9
	v/lgsBx8TN5vdU6h/SIF8Ldu3K8Ug6D+Yp5oOpfuyZmsQt8w7UWAJS27LWxzO2AB
	qJiJZKWL+I2Ssbtc0opT3qdsA44BKHuwAaYqVM6g7nsQbGEODsco5l+huQ5I+xxx
	BZauCHcdzpBAr+cc4WxU22UEDZypALbDY+VCjW8DLlk/6wxbAXi1ZFzuAYIAmh+O
	k+3Slj+7c9xAMUhN9xjLSefjQUt4axPosk4bfZ0jp7bigiV9LjFIJtfSfaUqWV/p
	lktUd/dgHUAUJ+cXeQbwo7JBL0aKhao8/lM1CDSj9CGS2NQB30kI8Vv4JtgGvZwA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh91jb9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 11:12:53 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9aRxI014797;
	Thu, 12 Mar 2026 11:12:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8a1xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 11:12:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CBCoTr36503948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 11:12:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F28362004B;
	Thu, 12 Mar 2026 11:12:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A21220040;
	Thu, 12 Mar 2026 11:12:47 +0000 (GMT)
Received: from [9.109.204.116] (unknown [9.109.204.116])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 11:12:46 +0000 (GMT)
Message-ID: <71921cca-b890-41c4-93e9-957d3f647ffa@linux.ibm.com>
Date: Thu, 12 Mar 2026 16:42:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/15] arch/powerpc: don't initialize kasan if it's
 disabled
To: Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org, andreyknvl@gmail.com, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, linux-kernel@vger.kernel.org,
        linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, x86@kernel.org, chris@zankel.net,
        jcmvbkbc@gmail.com, linux-s390@vger.kernel.org, hca@linux.ibm.com
References: <20260225081412.76502-1-bhe@redhat.com>
 <20260225081412.76502-10-bhe@redhat.com>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <20260225081412.76502-10-bhe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: sK4H9fwZp-KLt_Uh6QEN1FURiK-VcUay
X-Authority-Analysis: v=2.4 cv=E6/AZKdl c=1 sm=1 tr=0 ts=69b29fb5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=20KFwNOVAAAA:8
 a=voM4FWlXAAAA:8 a=VnNF1IyMAAAA:8 a=e6XaAvPcIE9lEXRYuwcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA4NyBTYWx0ZWRfX/mtfNCEYEuc6
 WHnW4p9iVwWYhz47Or92vnI3HCFHwJtfujDrjNzVlJPrH+HNMFrM5rei+tcs68Z8xKbUMLW4OGS
 nCC3o1olVSQZigyKu8dPplVewbl+wRYHv9pug6m4GgXDTxjkx/bFrguphZ3UlQo8DTuZgOK7pT7
 XoX/Pn2toTKs0nsYAIR0bSRishOkQI7WvgwwfqCbulME6FSQeiA+c1uiCQVkk5pmlyfJAVn0xAp
 Pd2bmli4VyUJXDxXTGZdXRFpkSuVHPAXPQU/E02hIaN/9uTz9550KWyukcPEC/RWPfdtgQaWvnT
 dA5KdZMWC431ZuagttMr9l48fgf2ZsGNNBHZ778481DcVjv3LdLN4uwlF7NKiDY3IpRloCGz839
 sR9Hlsf9U+wi24kTc7YK1aOscBc/I0desU0vcau1oECfMdpaWfrggI5bqsG8fSprzOHFsV0rdAa
 5fL4EVBZVPzrPv5kKmA==
X-Proofpoint-ORIG-GUID: appgZUPYvO44oILc1-ob_bhU232DA-fp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1011 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120087
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8341F4000B
X-Stat-Signature: 6hgu1yfufyg4pzkpaotuqmmo6mz7cptu
X-Rspam-User: 
X-HE-Tag: 1773313977-368162
X-HE-Meta: U2FsdGVkX1+wdYR+EIl3dW06ySJutWS+UBZAFWLnxlrW974bS5Q9Yr3PA/SiYHda/eFn81+iB05blqTexEc/ODc8bIRcuiUbkd1vsn+OIzXpHC4wGo9sD4hkxuvZHzeMW+Yv3FeEksNEk5iPDq1PXPCZPe1yecDJHTwIcrIprfUyl5H382aLn/tM+9naVCBBUfKBpXiTwfH7XdjpxvB5094jnhU8zyBJhBlsx926QIG6T39GRrS9LUZkFRPd41kY1ntdN5TpB1CKFRAu1VMH72bCfatg8C15BDlYcPB+nSGnns6PvpKvAxXMKRs2tCr4jqpjRh79h5rcQ075J69jf+VnMy1bjMYALVfLqPUBh52sJHoOfPX8qw7RG0NbZHfB69nEmQnJUddhqTMWakCA/XK7BMGAMEUb97lnZYAo85fOE9DLYzmaGEsnTyTyAY57izNbtZQqupbuihV+v5Tc3WjTLLkcOE6ODA8oBSVdtavsQzBRR7J1jKsh3eillkyUG6Ev/NtHyQVAD0BaO23fGyFOB/kjRqkgst4iUbp6t/LnJ64eLBe0gB7cWZQTgC/D9uCMf/bwyd068xx4hJzILOnQdB9sKGVFz+Wu5JuahAuXQlZcgFhGmxEzqOKxgCadqBrd70YIho22LvdeycoUtC7fqcZcDR05qwuw648td0E9Qt0xYsYKyQFQLVpgBsMA9iEKAEI+1HJqoBHsH9anzqhqaJNEUjsB46TbYs+jiaJfOBtunYjV7mN6UlHntMRRf53DIU/HonMXol5ISwEB9+eCgVfrsOmO5Glx4lygRlh7vF/3Xu0CcLunfc9txD5KaYdbuGr2b1kABjK/ThSXkGFZuSEiT49M8PW53q8NJrnKaA5ZDDqjS4m9xm2r2wAL1R7ffzQRe7O2no0noKv5zn6XaGJ7XWZz/kasZGs0OhCNe4Lzblh6UOLMD/303J9G6OtXBc8WJzzwTqypygW
 ntdMFW0f
 05DhcqjxKSx8dfipUsdFckYCoxsQP3JBiWHsPC7oiGI/pm1mbiql+Acc2heS7806v9VZAtSpqXhUHD7/EXGwFXwxK/q5Nt3LSGXKgimKW/FEp1mAz1cAzftiM6X7Exd/WMXQJ/8wsw2nU2ZNWkyYixoyFMVEQu1GwEtL4AhS5wD0pVlPYQXZ4rUaFvWd8n1x2lYuxsVwyUOpZ1NKYQ215+KwVAxwe32nDDauywUGs0o+0S77XNmYPAJZQ5UxXdB3S7/W1rnajU7iOCzz6+nFAe9Yr/M/hbUemf3RKaPEFcPJUlT3dOMHVtIxKDKA9l/hcH03/Mp7Zxz2dmr68nLt6GxiIhY9woR9s/HXv1xWz1sMExkFpSxNAR4mHDMDByCafxRZ0i8cYP701wYpsLzK/Cv0155FeIgl9ddFfuSIJ2G5SdL9t69WSUnRSHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/02/26 13:44, Baoquan He wrote:
> Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.
>
> This includes 32bit, book3s/64 and book3e/64.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>   arch/powerpc/mm/kasan/init_32.c        | 6 +++++-
>   arch/powerpc/mm/kasan/init_book3e_64.c | 4 ++++
>   arch/powerpc/mm/kasan/init_book3s_64.c | 4 ++++
>   3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/init_32.c
> index 1d083597464f..0ea2a636c992 100644
> --- a/arch/powerpc/mm/kasan/init_32.c
> +++ b/arch/powerpc/mm/kasan/init_32.c
> @@ -141,6 +141,10 @@ void __init kasan_init(void)
>   	u64 i;
>   	int ret;
>   
> +	/* If KASAN is disabled via command line, don't initialize it. */
> +	if (kasan_arg_disabled)
> +		return;
> +
>   	for_each_mem_range(i, &base, &end) {
>   		phys_addr_t top = min(end, total_lowmem);
>   
> @@ -170,7 +174,7 @@ void __init kasan_init(void)
>   
>   void __init kasan_late_init(void)
>   {
> -	if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
> +	if (IS_ENABLED(CONFIG_KASAN_VMALLOC) && kasan_enabled())
>   		kasan_unmap_early_shadow_vmalloc();
>   }
>   
> diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
> index 0d3a73d6d4b0..fbe4c9a7e460 100644
> --- a/arch/powerpc/mm/kasan/init_book3e_64.c
> +++ b/arch/powerpc/mm/kasan/init_book3e_64.c
> @@ -111,6 +111,10 @@ void __init kasan_init(void)
>   	u64 i;
>   	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL_RO);
>   
> +	/* If KASAN is disabled via command line, don't initialize it. */
> +	if (kasan_arg_disabled)
> +		return;
> +
>   	for_each_mem_range(i, &start, &end)
>   		kasan_init_phys_region(phys_to_virt(start), phys_to_virt(end));
>   
> diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
> index dcafa641804c..f7906f9ef9be 100644
> --- a/arch/powerpc/mm/kasan/init_book3s_64.c
> +++ b/arch/powerpc/mm/kasan/init_book3s_64.c
> @@ -54,6 +54,10 @@ void __init kasan_init(void)
>   	u64 i;
>   	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL);
>   
> +	/* If KASAN is disabled via command line, don't initialize it. */
> +	if (kasan_arg_disabled)
> +		return;
> +
>   	if (!early_radix_enabled()) {
>   		pr_warn("KASAN not enabled as it requires radix!");
>   		return;

Should we log in the kernel log buffer that KASAN is disabled?

Right now, I don't see the kernel advertising the same.

$ dmesg | grep -i kasan
[    0.000000] Kernel command line: 
BOOT_IMAGE=(ieee1275//vdevice/v-scsi@30000070/disk@8100000000000000,msdos2)/vmlinuz-7.0.0-rc3+ 
crashkernel=2G kasan=off

Tested this series on powerpc Pseries platform.
So feel free to add:
Tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>

- Sourabh Jain

