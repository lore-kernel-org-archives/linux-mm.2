Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3A0606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uokl7cT3
Received: by kanga.kvack.org (Postfix)
	id D5FB06B05B1; Mon, 23 Nov 2026 02:40:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37636B05B2; Mon, 23 Nov 2026 02:40:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74616B05B3; Mon, 23 Nov 2026 02:40:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A03BA6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:40:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 127861407FC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:40:38 +0000 (UTC)
X-FDA: 85465586556.16.7FBDBA2
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 28CF640007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:40:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uokl7cT3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795419636;
	b=e1bk6nHOX7BJ/IiTQSTTaOeGBUVUY7XxSkMuhkat2VJDTbAHaIlnNsGsYmvnIqkQ/YE76H
	2o5TqilLqHYmMI9W4OuyC8HnA2UGrXpqqN39Oi2qvy41fHlyZJxnLGaujO+VJMWHXmdBso
	ttu3Wy2xn9vNdl9urwZuZYDir9s8IHs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795419636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OSpOlJ5QU7jjdI5ogSU6KcCruhdHca3yQivXfMqClg=;
	b=J8OYUxWv3XhecjFff881WMHIJVwvU/inP9hr3xahnWRD2wwjQMkaVE7PGKr6qxft2YxaTN
	Y5t0oLtLMnin2tOhqlZHWaTJvYU7K57BcSZ4syOP4WQIUqtQPH8URU+1JZpaf8c5H/F4mE
	dMRvgFnU5GW/diJ3+j8+VNXe0DMy69s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uokl7cT3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3adc0ac3566so709066a91.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795419635; x=1796024435; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0OSpOlJ5QU7jjdI5ogSU6KcCruhdHca3yQivXfMqClg=;
        b=uokl7cT3c90Kx3wHcJQtQsdf4O/APUkWd9CWEfMCuEJMgSNIsibtWvLWxGKYY+EdFZ
         Nu25sSprNhkhGaZg3fCkdO9SytEz3FQ1ogc+1vy3J9H3MiiyXvvgguDrX1xCL59X7LYD
         sQhN8DCsm+e3payQQ8HLQleZTgEA1KaaB/A5i8xEsnPsiWpCRssRb46MXdKaEaa6YrcV
         MSxVcec4sBUHnrlzeLPZ4EVWfuVYxPhR1b4f0GapXPKSm7Uu72cwxPoTRogqmSLte9JK
         IQ3lE15e7eibkCqPPG22ktTLAZG0WwlvqBwi9BEEQlnc8UnvCK7T1ZeThyapjwlDkyWE
         9yQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795419635; x=1796024435;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0OSpOlJ5QU7jjdI5ogSU6KcCruhdHca3yQivXfMqClg=;
        b=NJBvuQ8m/kQg+fxFB2DJNhuRFAuV071c3F9BXmX+7knOCndtjDWAwY6VgPaH4ptmn2
         /NQWv6oc6Fi9odLcpsoRT2mOoLOM/qhhuNAefquT/KN9ewKmzioDasdu9wayuN3sQuPb
         1f7TihDyHoSdN04Mrqob/SWq7i/oK9LShLAXS5k24aF8QZWNgnxOZJrlnCteOwnpJRXu
         AzKfKpCssvPshRTjqo4GSmzOAD+fmbaGfEwGpP9zq8Skrw/yvV6KLCV5NrMVbfVjaiUU
         R8NyKAl1l+F9TK0u46tkoQtcf1MZkSchaf9JcHKAaE+tjTlmgD9pTiSLR+zimQo/BFHy
         A8dg==
X-Forwarded-Encrypted: i=1; AL+hErENl59jk2wJjVMZ1+Z06HhpB2lAOCIWUA4zUkG/xYvj64JaE9cRGtZ/6yOWn5tSuIHr/fHTY4PTFA==@kvack.org
X-Gm-Message-State: APuU4Z8RLz9sBZyjgFTZjI4KTiryc3cfDFyiJJaxV86a8HYZmSImVAey
	qbN/+6dNnGLn46+MQ5VasD0VlSDHw0EXeB6NBRBQ5nc0Jj1TkPw/vzUb
X-Gm-Gg: AZFdTZcTw0QHBslgLSqA6FuNx/iuo1pt/XiahyLdsyhBUJUyGu5/TNxVJU3rxOtAnHh
	uSxgReqvMhUtz3xrh1V1V4/lzyt2hcSFgK8mWbgeEq2tvxociYJmRHBEIjfqJiUhWEfpgCxN+zn
	edUomVGq1gD0103WuTNVhRO+YAUC8ESG5h64tTN8x4nnqpSqHrtutPFKCzJC2nuL7ifNmgxau4X
	b1UCOccX3LzbBy9t9pBMaRM4XcKAblNXNWkd7Z+HF6kyICh+WKU+FAsKVH1xcARjJ7rbQEcu4+B
	bCMAX/5YBxfgctZi+88jSeq21Kwyw0Llzm4nRY8PXXP3BEfwybXHkZ33uGyJGyuAobvY88/ZM0w
	voVPHHqmpFbeldGHJgKzyu0eQACCG2fa1KJWDml2SX/IkG1okk5SjSGsLCMKQPaWuvSf/yGrMje
	2ZSu/P6PRNYVrMGkZiel7hqlf/eDmAKgZNf7z/RLWz8xcxVhqkCcx+fD6p4GrbPEikozT76v/6z
	57uP06dYuAezRS3Hj2Lpu7TB2wcLl/MaALlsaiXch0Mmj+Dt2E/oyUKPwY8JVZYVkGI2BTEhHSI
	3AljQJadrLO8z5SwLViu9roqyOgOMebh4gRe
X-Received: by 2002:a17:90b:2f8c:b0:3b4:1997:3495 with SMTP id 98e67ed59e1d1-3b41c9613bbmr9155015a91.57.1795419634749;
        Sun, 22 Nov 2026 23:40:34 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad8ef99sm17103994a91.12.2026.11.22.23.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 23:40:34 -0800 (PST)
Message-ID: <a3ebfc1c-9c98-44a1-96e2-4d92daed4ba4@gmail.com>
Date: Mon, 23 Nov 2026 15:40:19 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/8] riscv: build crash_mem ranges from memblock
 instead of resource tree
From: Wandun <chenwandun1@gmail.com>
To: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 chenhuacai@kernel.org, kernel@xen0n.name, alex@ghiti.fr, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, saravanak@kernel.org, akpm@linux-foundation.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev,
 robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, iommu@lists.linux.dev,
 robh@kernel.org, baoquan.he@linux.dev, rppt@kernel.org,
 m.szyprowski@samsung.com
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021083011.2170525-2-chenwandun1@gmail.com>
Content-Language: en-US
In-Reply-To: <20261021083011.2170525-2-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ayminngafrn79sb8fcn34b73iusjht3p
X-Rspam-User:
X-Rspamd-Queue-Id: 28CF640007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795419636-450454
X-HE-Meta: U2FsdGVkX1/vfn8s34i+GuutD70R4YwG2JUVcH0kwWwNatkGjpVHvqJ0w/5zRAJFEbg7AS7eUhxfjUOno6lQ4xtI3xhNDXYDUV0w+kLUGWPFbArI4IHgC3UufJW9Bl27LTwZZeT3R8QWvUgclI7B8CUGPHcOXDKFNmiHFQuWAL4p8ZCSO4mbWnKgrCeoYuI1bonI4XthjkQ709C652o+x71IobbvOWizvSFrWqzwtr5ZethOib+Nzav4EwuvTUxG0sfrbrrQrQ5tVQyXI8Fod3vYL1I3CdiVJ50ZSUgKqrgUi8fpiEoNW0onSUNxv+cfCdvUiQ04Xns0noc3P0qOwJZ3C4lmPWcTxnOISgcz8+KtNWriyinhFHS0ivmlEs1SH15BI4BoOJQhc8K24pF91JFDJVD4zS04Qzio5OMUe10NbCQlZe11Amf/Mf0azmfOHrgESb9d0NfW1+t8tIaCSmCxZo4kz2QR0jvaS4Q9FIoJQHJnQwKOxqT+CpyruQIkcFANPf3ErSNOt58um6GZtVP5u3iXVQMYWKj7fY5FPXm68wpz/URqJ38B/nsg4YstaCK2uaHNSw3gt9ewJ6n4ktjmZGGlSMx7adopgK8ElXdHg5Nq/86Hhw55ZZyi/5eETtDBVh0cyRf39mZRLzZcqnuc5l2Yqq35Ry4+I8PlYUKj6aRnmWDw7yq9oF2ptxGpKqKMSXEjHirUG+uLUxMPXjLtm4TWP3UYHil6VXahhGR9ySKbZoig04JTybzx3VBFrbbepFitUow42Qq+RF7PPFTja57coAmraspNBdtqgZgZRbA+a06ds8Eqw/3tQR3PNuKoVtDuEKgM2lIPqMBMjevHJ2nv6uJ05zNKwFS7lp2B24zXyMEVIWRNqMHIksdvWL2k1EFaIbGAydWC/WRHsmCSouJn25l+DnbV5bVdNQrM6DWkS32AkUhy5OEOujRDdlNhP9lpEo96sQMnrrH
 1/TrtwEm
 v5asBIz6/vxiXMtYes6/EU681s8EgXgzGJImz+qJbZk9WT0jkWNeEw4sLfRk+lXl0pIh8A0+Zya79NcgF6SX1HtDaVHX4bhrZLhRUVdyXX6u0FYHku8yQB+PEkMLyEkBthidyroqACAlRBpt8Vcbtjjp/fz/fTs+6ZMCfMwNDgpHzhAe9XTyRpFTHRfruiDtMWlRot0kNErV5/vJNznP6FyxEpS0sSHWBz521xda2UBjg8cFmd5mzRlVJJNhPq7dbSTeIA0LhOZT39fjDDVRRL1j0HvOdDmpObQsGyl7GmGNTMEUST+zpwHu5Qh7i5cQ1uLacz/W3rdzlAltWn+DtKmDvBgV1+cooQ/PLb6S/OtOJHq8QqP3apaekFDU5FwHkEQcJ9pztLcyhnejD/UJhmKIPx1sn+lOES0eRNb7R7kxxsVAV/HfdvblPDSjyqhtFwQPuMg6nI3PEBeiZAfdUdzJi0lirnGppyUhqG2pCARz0vXar541btla2BKsOWotq2Mcg4NBz+YbcUIvUYc+xv8AbYCI0UHnUCjsLJ2TOfI7rlWJeHe3cbFmbbn7NMGyIh7AAdAx2esyQS6iOA2FKUk5XRtdK5IocHPgzrBs7H4VuJZHKCSDWMxuRpSycucHv8b82egrvXr+F2e3u2lgtbrk6/uJDN/9xJyrE/3XM+8bFfiJAJwBNnPQpC0+EpMA3nZldxzltubtmJQCqLPP/1gaG1vnnvHBFI78hqHGapZdpnh35v7o5PHI5E1RnlQFfbdPml29h6lD1x8l9z/2ocuA2SQpc1mEWPlREyvL9at1yezc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/21/26 16:30, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Replace walk_system_ram_res() with for_each_mem_range(). A later patch
> introduces MEMBLOCK_NODUMP in memblock, the reserved-memory regions
> marked with MEMBLOCK_NODUMP can be excluded from the vmcore by walking
> memblock.
> 
> for_each_mem_range() iterates memblock.memory, which is freed after
> init unless ARCH_KEEP_MEMBLOCK is selected. riscv needs ARCH_KEEP_MEMBLOCK
> to filter reserved memory from the vmcore, so extend its condition
> (ACPI || KEXEC) with CRASH_DUMP. arm64 and loongarch already select
> ARCH_KEEP_MEMBLOCK unconditionally.


Hi Paul, Palmer, Albert,

A gentle ping on this patch.

Mike has requested a RISC-V maintainer Ack before taking the revised
series through the kexec tree. Could you please take a look when you
have a chance?

Thanks,
Wandun

> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> Acked-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  arch/riscv/Kconfig                     |  2 +-
>  arch/riscv/kernel/machine_kexec_file.c | 31 ++++++++++----------------
>  2 files changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index e7891a2a89da..e21d0bab77ee 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -58,7 +58,7 @@ config RISCV
>  	select ARCH_HAS_UBSAN
>  	select ARCH_HAS_VDSO_ARCH_DATA
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> -	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC
> +	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC || CRASH_DUMP
>  	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE	if 64BIT && MMU
>  	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
>  	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
> diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
> index 26cd2a8bd0cd..808e872f4063 100644
> --- a/arch/riscv/kernel/machine_kexec_file.c
> +++ b/arch/riscv/kernel/machine_kexec_file.c
> @@ -37,39 +37,32 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
>  }
>  
>  #ifdef CONFIG_CRASH_DUMP
> -static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
> -{
> -	unsigned int *nr_ranges = arg;
> -
> -	(*nr_ranges)++;
> -	return 0;
> -}
> -
>  unsigned int arch_get_system_nr_ranges(void)
>  {
>  	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
> +	u64 i;
> +	phys_addr_t start, end;
>  
> -	walk_system_ram_res(0, -1, &nr_ranges, get_nr_ram_ranges_callback);
> +	for_each_mem_range(i, &start, &end)
> +		nr_ranges++;
>  
>  	return nr_ranges;
>  }
>  
> -static int prepare_elf64_ram_headers_callback(struct resource *res, void *arg)
> +int arch_crash_populate_cmem(struct crash_mem *cmem)
>  {
> -	struct crash_mem *cmem = arg;
> +	u64 i;
> +	phys_addr_t start, end;
>  
> -	cmem->ranges[cmem->nr_ranges].start = res->start;
> -	cmem->ranges[cmem->nr_ranges].end = res->end;
> -	cmem->nr_ranges++;
> +	for_each_mem_range(i, &start, &end) {
> +		cmem->ranges[cmem->nr_ranges].start = start;
> +		cmem->ranges[cmem->nr_ranges].end = end - 1;
> +		cmem->nr_ranges++;
> +	}
>  
>  	return 0;
>  }
>  
> -int arch_crash_populate_cmem(struct crash_mem *cmem)
> -{
> -	return walk_system_ram_res(0, -1, cmem, prepare_elf64_ram_headers_callback);
> -}
> -
>  static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
>  				 unsigned long cmdline_len)
>  {


