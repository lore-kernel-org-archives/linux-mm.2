Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D66606A335
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iv1lPNlz
Received: by kanga.kvack.org (Postfix)
	id 9C97C6B05B6; Wed,  4 Nov 2026 09:55:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A726B05B7; Wed,  4 Nov 2026 09:55:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869266B05B8; Wed,  4 Nov 2026 09:55:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58A3B6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:55:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD856C078B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:55:04 +0000 (UTC)
X-FDA: 85397734128.08.973E79F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5FDE0100005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:55:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iv1lPNlz;
	spf=pass (imf14.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793804102;
	b=0oqSzMzlZeMIA86z3hQU7Kr8ev0NMd9V/vfQK3hrWFqntOC6PJIe+4lwvMerY3AeuV2gFB
	SjyXhWUDmPOnzOL/SMy1+XaooGGDqmI+n59lStywa2zsUi+nMdyKI7ss+OQe0n8uYfDI9H
	qkRBCT1gAxqNfesToza1OreIx/wnb7Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iv1lPNlz;
	spf=pass (imf14.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793804102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/LFH12Z4WZEglTbKhXQW4K9eV4VYPQ2vTkGE/YeZdw=;
	b=Lh1viGyBPr8sK/o9vPNvHms1izsRsLuiloRN9oGsxzjdwRh0JWJqr9tV3DnqTfzh/JZVQ3
	aN67DLz7Rte+3G8aDzREAPRfBxli0QvXUTpjrB6q4M8g+El1S/Y3gEGSjD+pebK/GFYVk6
	6Gys08XyS2NA/+WRLRU3S4FOqNsAflw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793804101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T/LFH12Z4WZEglTbKhXQW4K9eV4VYPQ2vTkGE/YeZdw=;
	b=iv1lPNlzqdRQKqVS0gds5uZzd8y0ySIgpkJmYDBeUZxI/rFKzbZtfS5BadY0nykY8zg2YI
	ysNCDr7RpUJ7d2x3UEIybTos9bcYhVaJUl6n7Xvg9hU5E9W21WHLWfN/SAClLQ8JSO+ejC
	rZkWnWyjS27XAgeylB+bmn5KGSI6JH8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-uSpoDsESN26o9ZZ-bHmvUg-1; Wed, 04 Nov 2026 09:55:00 -0500
X-MC-Unique: uSpoDsESN26o9ZZ-bHmvUg-1
X-Mimecast-MFC-AGG-ID: uSpoDsESN26o9ZZ-bHmvUg_1793804099
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b0a9de9c2aso130593a91.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 06:55:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793804099; x=1794408899;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T/LFH12Z4WZEglTbKhXQW4K9eV4VYPQ2vTkGE/YeZdw=;
        b=fEzV2ju8kz9W3eCXoKGQA3BKXmoav+GJRhIanYhK4p2JwafAc3EPSYDbhxOb4D4TPC
         vo2nb6ChFp9pRJEcNPaIQsivdnDNXloRYC2s/kD9EjTv1leJiHKwKMtXY5fvYLBpm1tA
         k2L2yciTkJREt7vTzHQCnhx/XCsbt8qTsozzd2oge0IRDFx4TPVXXAhELkPXuBjba68E
         JGmnF8gDaNausBm9cuusmz2fkcdczd1PvcZvwuXyutO3LjAWrHG316MWvcaq8hnFWVHl
         JcrkEqByApCF5S/EK1u/Kp2xacTjSQO5cwjKP0211UakpXXI7lBszVXkvTB3dChnRzJ+
         oEDw==
X-Forwarded-Encrypted: i=1; AKwUvBx4nm4S52FtZ3ktq0IkOYwfg5DCgeYwkkggSyu1mOtKmT09SjVFnWmBhM4iYBzBTFuntgk88ZkP1g==@kvack.org
X-Gm-Message-State: APuU4Z8latxYInn1yI1Ap2RNLoHxrtF4weP8zIE6kbNTQkTquS9PNELH
	n31vRglrxMGwh0s9R9IZrsD5rArRrbGKw4+1rPSn8rp3zjf1jBwyyg0lH4H8N3xEOlkMsvDkujN
	gdsylcz5eJT7pxUHp6yn3a1p5Kijus5UPQh0dS0Bi2MH5w0f7o84n
X-Gm-Gg: AYBFou1pC6z0CSu6Yrtpi/+zf6/sEm9cYldZXdTMX/nV9KEW9KmhPEkmtzQT60/kPqZ
	AdBsnvGpM9eqYKShwJbjNLnhaW4XkAEWbj3/HfyautZ+00jFob7TnmXswTVzTUnitGizlri2aLy
	KF8nrL4Kw2iXLGb3LG3FFD6SiXo5ZszHfwIrbFkk3NWMa/dVJ9Zh5fMlZXpU5yOk/bp6Ik3LQyV
	ldP0m7mFPzCHh6f1mOAJWGdtuQLu3blvdVSzjKl7Xo+TPlPnRHp8HV3Gh+QNQI2mevRUaviAEjj
	JasvKt/g56miIk2h+0VqeedqJH1RiLorXPge5lj/EGuGEO1G2DmPO3b+bQNAkMpKsJ9KZoMy/L9
	ym0BZ9CkCLjiCN8CgkCJhWNcB4rLGlSlG7BsVVd8a0zx/5RVjm/nlfYARwTgwG6Dw577flJEvjh
	jF/H/dzoWDTnH4D+jjZWgPNkrSabDU2nFa5WpcE97khtg=
X-Received: by 2002:a17:90b:48cd:b0:3b0:a970:caad with SMTP id 98e67ed59e1d1-3b0a970ce14mr563079a91.28.1793804098475;
        Wed, 04 Nov 2026 06:54:58 -0800 (PST)
X-Received: by 2002:a17:90b:48cd:b0:3b0:a970:caad with SMTP id 98e67ed59e1d1-3b0a970ce14mr563055a91.28.1793804097848;
        Wed, 04 Nov 2026 06:54:57 -0800 (PST)
Received: from ?IPV6:2401:4900:1f28:63e0:edae:927e:c670:b679? ([2401:4900:1f28:63e0:edae:927e:c670:b679])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b096994650sm2176379a91.2.2026.11.04.06.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 06:54:57 -0800 (PST)
Message-ID: <99670aa8-a33c-4a36-b8dd-66b02c6b6159@redhat.com>
Date: Wed, 4 Nov 2026 20:24:47 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a
 configuration table
To: George Guo <dongtai.guo@linux.dev>, rppt@kernel.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, chenhuacai@kernel.org,
 ardb@kernel.org, shuah@kernel.org
Cc: ilias.apalodimas@linaro.org, akpm@linux-foundation.org,
 baoquan.he@linux.dev, ruirui.yang@linux.dev, guodongtai@kylinos.cn,
 kernel@xen0n.name, graf@amazon.com, liukexin@kylinos.cn,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-2-dongtai.guo@linux.dev>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <20261029172956.20791-2-dongtai.guo@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CaEi1J_3tlteJ3U9hDQm0WMsnvPYW3Hx1w_LG7ggkuM_1793804099
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5FDE0100005
X-Stat-Signature: cabuhmfm6drbcbu1icrzouj1bdcmh46d
X-Rspam-User: 
X-HE-Tag: 1793804102-507681
X-HE-Meta: U2FsdGVkX19G+y/n+WfwvBrRqKrGB71LsdarnlEztMaB3AavGq4k+dJ+ytb2m2UkGQ1ipuU4a7msA9URoMU+BRrdjrc5jxQI6zPvL3Tfi+wnWZ3nWK6WGVQcurBzQUzt/nKBQvtpufZAWcjdhM91IrGlyVGrJavhIU1kmcaKBbpGrliWeMW6l4j47ztIDBnKdyBaOD9pxIwOX8m5v3vZtVPqxn+Naz4sbz6pnw1vp+xNOTvvNYVy+qzS0EfNz2QI7CduNWmytdd1iej3yALj+ENv+JJjpAnEriSMSEN+bH1BT99sxTTdXFdBkNJ+D6Ov0cIq7B/ubfI95L/KcsVhlDEt/rFEflZViIz89BtiPhmu2BW7oWLmpKQuJhcPtHkJ1so6eddegWc5GpISGhhRW0wo26bRRQhPWkJr+uJoWzA4j0EdHOfBHI9Qxw4eB5PLGbOyFtrJ6KoAlC0cw0BALwcVzcnSnpDPWH9aNrnPG6tSoGNad7Y0dhZHITvqTVGohq29jaDSjfkz4E5sc+L6TV5fz4KpDTfKGJIn3B0GZNfKxzJGvlZIxUyTSTG25SrL0NNDgfjrrwofQF5DPyYH7v91KbSiqhraHTbd3M2wG2c8R/QmxvLwjTBUchR6YE2SfJL+rAINY3J94yJ5s7GlHWtfm/+uMrD/2DNZQj56CJAxRp209SoRt7ffoI3TbTGNzMCDX+Kuj2V5N2jlQM2V13RjYFiDwfP6cOBJ5xVG4u+9ydgbhCANkNKnzdDHWo9tWpBTuNpq2zB+o4P/JIJglLdbELqQGuH7Grb0aOJh0go4eGkyUyeMyK49ypbWE2oAaqsfEhfD1KPTyiXiYuX9G+HZL2kLG3ds1VjLYJDk9VGo3yYgV8dU+glmwVmBn9BUDcUx3D92oBbzdHyiYgTVxT50OTQGXNHeaIgfNkGPJCpxCYGLBJGrkxsy+tXjahbRIhX8W9EpV0SJQghvsPj
 55a3iZKW
 WGCvzmdYML+mcloV11DsJC6ZapS41zz8mNqHXxHBupQfMMvpKRYfZydM+oE9s3mBLBRRQRzuTUta+sWIVStHBY6nNgnVcemApDYDqsGvvq7fph4tZSvdcY4MBsSg77SsVgYQWbIYTNspjqFbJpmzFZGEn4MGXuhdk2mFN4Zr4rXd21xAZcE0eo523kGbLP8QNRqUA3BVTAhOksFTAZ3LiolkIfTpDcS9kBWvEc2G4PnCsuiSTqJUmCHlGQ/ExlFozjQcJ5lJZ0BXqW/wuWwF1NKaRWXynff/FKc+9s7jXIgwNFiXUBTqBV5G3V18rVPG+II4u0WOk6Ulfq4nxAtTFUexGJqfxOjhfrlplK7T8UG4nDaoAGyCVvHScYcTwm+dItiLcodqhGnxjAvXmtwyqrFpuS8sOLbgsVTk00v3GoIlv0wKH+xf1LQDGRrdz1zD2Q3FG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi George,

On 29/10/26 10:59 pm, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> KHO has to give the next kernel two addresses: the KHO FDT and the
> bootmem area list. arm64 and riscv put them under /chosen in the boot
> FDT. LoongArch systems booting with EFI and ACPI do not require a boot
> FDT, so KHO needs another way to pass this information.
> 
> Add a Linux EFI configuration table for them, under
> LINUX_EFI_KEXEC_HANDOVER_GUID. It points to a struct linux_efi_kho_data.
> 
>   - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
>     Each kexec'd kernel is given the same EFI system table, so it finds
>     the same table.
> 
>   - In early boot, efi_config_parse_tables() reserves the table so
>     neither the page allocator nor kexec segments use it, and calls
>     kho_populate() if the table holds KHO state.
> 
>   - Provide efi_kho_update() to update the table before kexec. Map the
>     table during boot so updates do not require allocation or mapping
>     at panic time.
> 
>   - efi_kho_table_found() tells architecture code whether the table was
>     found at boot, so it can turn KHO off when the table is missing.
> 
> Only the LoongArch stub installs the table, and only with
> CONFIG_KEXEC_HANDOVER. Elsewhere there is no table and this code does
> nothing.
> 
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  drivers/firmware/efi/efi.c               | 68 ++++++++++++++++++++++++
>  drivers/firmware/efi/libstub/efi-stub.c  | 22 ++++++++
>  drivers/firmware/efi/libstub/efistub.h   |  2 +
>  drivers/firmware/efi/libstub/loongarch.c |  2 +
>  include/linux/efi.h                      | 40 ++++++++++++++
>  5 files changed, 134 insertions(+)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 0327a39d31fa..e409e4a57378 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -24,6 +24,7 @@
>  #include <linux/initrd.h>
>  #include <linux/io.h>
>  #include <linux/kexec.h>
> +#include <linux/kexec_handover.h>
>  #include <linux/platform_device.h>
>  #include <linux/random.h>
>  #include <linux/reboot.h>
> @@ -62,6 +63,7 @@ unsigned long __ro_after_init efi_rng_seed = EFI_INVALID_TABLE_ADDR;
>  static unsigned long __initdata mem_reserve = EFI_INVALID_TABLE_ADDR;
>  static unsigned long __initdata rt_prop = EFI_INVALID_TABLE_ADDR;
>  static unsigned long __initdata initrd = EFI_INVALID_TABLE_ADDR;
> +static unsigned long efi_kho __initdata = EFI_INVALID_TABLE_ADDR;
>  
>  extern unsigned long primary_display_table;
>  
> @@ -629,6 +631,7 @@ static const efi_config_table_type_t common_tables[] __initconst = {
>  	{EFI_TCG2_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"TPMFinalLog"	},
>  	{EFI_CC_FINAL_EVENTS_TABLE_GUID,	&efi.tpm_final_log,	"CCFinalLog"	},
>  	{LINUX_EFI_MEMRESERVE_TABLE_GUID,	&mem_reserve,		"MEMRESERVE"	},
> +	{LINUX_EFI_KEXEC_HANDOVER_GUID,		&efi_kho,		"KHO"		},
>  	{LINUX_EFI_INITRD_MEDIA_GUID,		&initrd,		"INITRD"	},
>  	{EFI_RT_PROPERTIES_TABLE_GUID,		&rt_prop,		"RTPROP"	},
>  #ifdef CONFIG_OVMF_DEBUG_LOG
> @@ -806,6 +809,23 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
>  		}
>  	}
>  
> +	if (efi_kho != EFI_INVALID_TABLE_ADDR) {
> +		struct linux_efi_kho_data *kho;
> +
> +		/* Keep the buddy allocator and kexec segments off the table. */
> +		memblock_reserve(efi_kho, sizeof(*kho));
> +
> +		kho = early_memremap(efi_kho, sizeof(*kho));
> +		if (kho) {
> +			if (kho->fdt_addr)
> +				kho_populate((phys_addr_t)kho->fdt_addr, kho->fdt_size,
> +					     (phys_addr_t)kho->bootmem_addr, kho->bootmem_size);
> +			early_memunmap(kho, sizeof(*kho));
> +		} else {
> +			pr_warn("Could not map UEFI KHO table!\n");
This is a Linux EFI configuration table, not a __UEFI KHO table__, so
IMHO; UEFI wording is wrong here.

> +		}
> +	}
> +
>  	if (rt_prop != EFI_INVALID_TABLE_ADDR) {
>  		efi_rt_properties_table_t *tbl;
>  
> @@ -1171,6 +1191,54 @@ static int __init efi_memreserve_root_init(void)
>  }
>  early_initcall(efi_memreserve_root_init);
>  
> +static struct linux_efi_kho_data *efi_kho_table __ro_after_init;
> +
> +/* Did the previous kernel or the EFI stub pass a KHO table? */
> +bool __init efi_kho_table_found(void)
> +{
> +	return efi_kho != EFI_INVALID_TABLE_ADDR;
> +}
> +
> +static int __init efi_kho_table_init(void)
> +{
> +	if (efi_kho == EFI_INVALID_TABLE_ADDR)
> +		return 0;
> +
> +	/* Map it now: the table is also written at panic time. */
> +	efi_kho_table = memremap(efi_kho, sizeof(*efi_kho_table), MEMREMAP_WB);
> +	if (WARN_ON_ONCE(!efi_kho_table))
> +		efi_kho_table = ERR_PTR(-ENOMEM);
> +
> +	return 0;
> +}
> +early_initcall(efi_kho_table_init);
> +
> +/*
> + * Write the KHO addresses the next kernel should use, or zeroes
> + * if it should boot without KHO.
> + */
> +int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +		   phys_addr_t bootmem_addr, u64 bootmem_size)
> +{
> +	struct linux_efi_kho_data *kho = efi_kho_table;
> +
> +	/*
> +	 * No table: either the architecture passes the KHO state some other
> +	 * way, or it turned KHO off at boot because the table was missing.
> +	 */
> +	if (!kho)
> +		return 0;
> +	if (IS_ERR(kho))
> +		return PTR_ERR(kho);
> +
> +	kho->fdt_addr		= fdt_addr;
> +	kho->fdt_size		= fdt_size;
> +	kho->bootmem_addr	= bootmem_addr;
> +	kho->bootmem_size	= bootmem_size;
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_KEXEC
>  static int update_efi_random_seed(struct notifier_block *nb,
>  				  unsigned long code, void *unused)
> diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
> index 42d6073bcd06..0fb0d4041d1c 100644
> --- a/drivers/firmware/efi/libstub/efi-stub.c
> +++ b/drivers/firmware/efi/libstub/efi-stub.c
> @@ -100,6 +100,28 @@ static void install_memreserve_table(void)
>  		efi_err("Failed to install memreserve config table!\n");
>  }
>  
> +void install_kho_table(void)
> +{
> +	struct linux_efi_kho_data *kho;
> +	efi_guid_t kho_table_guid = LINUX_EFI_KEXEC_HANDOVER_GUID;
> +	efi_status_t status;
> +
> +	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER))
> +		return;
> +
> +	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*kho), (void **)&kho);
> +	if (status != EFI_SUCCESS) {
> +		efi_err("Failed to allocate KHO config table!\n");
> +		return;
> +	}
> +
> +	*kho = (struct linux_efi_kho_data){};
> +
> +	status = efi_bs_call(install_configuration_table, &kho_table_guid, kho);

> +	if (status != EFI_SUCCESS)
> +		efi_err("Failed to install KHO config table!\n");
When install_configuration_table fails, the pool allocation made
just above using efi_bs_callis never freed, so a page of
EFI_LOADER_DATA is leaked until ExitBootServices, This is a minor leak
so mentioned here for review completeness.

> +}
> +
>  static u32 get_supported_rt_services(void)
>  {
>  	const efi_rt_properties_table_t *rt_prop_table;
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index fd91fc15ec81..9e0034c1260a 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -1057,6 +1057,8 @@ efi_status_t efi_exit_boot_services(void *handle, void *priv,
>  efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
>  			     unsigned long kernel_addr, char *cmdline_ptr);
>  
> +void install_kho_table(void);
> +
>  void *get_fdt(unsigned long *fdt_size);
>  
>  efi_status_t efi_alloc_virtmap(efi_memory_desc_t **virtmap,
> diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/efi/libstub/loongarch.c
> index 2b0c87dc9908..c2df097771e4 100644
> --- a/drivers/firmware/efi/libstub/loongarch.c
> +++ b/drivers/firmware/efi/libstub/loongarch.c
> @@ -74,6 +74,8 @@ efi_status_t efi_boot_kernel(void *handle, efi_loaded_image_t *image,
>  	efi_status_t status;
>  	u32 desc_ver;
>  
> +	install_kho_table();
> +
>  	status = efi_alloc_virtmap(&priv.runtime_map, &desc_size, &desc_ver);
>  	if (status != EFI_SUCCESS) {
>  		efi_err("Unable to retrieve UEFI memory map.\n");
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index aa15ff88539b..253e98bf9922 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
>  #define LINUX_EFI_COCO_SECRET_AREA_GUID		EFI_GUID(0xadf956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
>  #define LINUX_EFI_BOOT_MEMMAP_GUID		EFI_GUID(0x800f683f, 0xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
>  #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID	EFI_GUID(0xd5d1de3c, 0x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
> +#define LINUX_EFI_KEXEC_HANDOVER_GUID		EFI_GUID(0xc941b6c7, 0x7b3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
>  
>  #define RISCV_EFI_BOOT_PROTOCOL_GUID		EFI_GUID(0xccd15fec, 0x6f73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
>  
> @@ -1273,6 +1274,45 @@ struct linux_efi_memreserve {
>  
>  void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
>  
> +/**
> + * struct linux_efi_kho_data - KHO state passed to the next kernel
> + * @fdt_addr: physical address of the KHO FDT, 0 if there is none
> + * @fdt_size: size of the KHO FDT
> + * @bootmem_addr: physical address of the bootmem area list
> + * @bootmem_size: size of the bootmem area list
> + *
> + * Pointed to by the LINUX_EFI_KEXEC_HANDOVER_GUID configuration table.
> + *
> + * The EFI stub installs this table zeroed on a cold boot. It stays
> + * in place across kexec; the running kernel rewrites it just before
> + * each kexec, and the next kernel reads it during early boot.
This statement is only true for the LoongArch and on arm64/riscv/x86 no
table exists, so the comment describes a kernel-wide invariant that does
not hold.

> + *
> + * The layout is fixed. Changing it requires a new GUID.
> + */
> +struct linux_efi_kho_data {
> +	u64 fdt_addr;
> +	u64 fdt_size;
> +	u64 bootmem_addr;
> +	u64 bootmem_size;
> +};
> +
> +#ifdef CONFIG_EFI
> +bool efi_kho_table_found(void);
> +int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +		   phys_addr_t bootmem_addr, u64 bootmem_size);
> +#else
> +static inline bool efi_kho_table_found(void)
> +{
> +	return false;
> +}
> +
> +static inline int efi_kho_update(phys_addr_t fdt_addr, u64 fdt_size,
> +				 phys_addr_t bootmem_addr, u64 bootmem_size)
> +{
> +	return 0;
> +}
> +#endif
> +
>  /*
>   * The LINUX_EFI_MOK_VARIABLE_TABLE_GUID config table can be provided
>   * to the kernel by an EFI boot loader. The table contains a packed

-- 
Regards,
Mukesh Pilaniya


