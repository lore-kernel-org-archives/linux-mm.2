Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A96C2FB5EA9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 04:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E9F6B0095; Fri, 20 Mar 2026 00:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF896B009D; Fri, 20 Mar 2026 00:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF096B009F; Fri, 20 Mar 2026 00:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACDFF6B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:06:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CBE38C5C4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:06:58 +0000 (UTC)
X-FDA: 84565105716.30.2BE715E
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4DAD820005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:06:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TF0XcbSw;
	spf=pass (imf13.hostedemail.com: domain of groeck7@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773979616;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grz9eWJ1ps3EBDuJN2bzyVHKIzdPvtiDT74qagFiumU=;
	b=tSNCpTTF/SN0OwbEWaPNDKUO2q77a4jn77P+S+iNCf3JiaGgjmwYV/ucQ6O/2+SB9MhmDy
	7mgw1mFTt7eJVPuOqv0bU+BFHDVLyuOtuYV1Kzj59Foc5tJXqLbmA43EQxOXXH4zroeBIQ
	jbOYj03fZThayKH5L1Y5q5QpccAODb4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773979616; a=rsa-sha256;
	cv=none;
	b=MTpGfRl9n/8GsmBazR1rUs7WnIMdMlDMKopa+V6XvNmBJAWKwisOFfs5XsK6CA6YlVdgNr
	dGBH4suTNyASzt+nUBMBDMvnPwfvHNlP9eAlYklD4C2iGNAXxWxZsqnmcAJwZjW8IzDfhk
	w+3AofAaZI0zv0u6+8O4eJV00a05cDk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TF0XcbSw;
	spf=pass (imf13.hostedemail.com: domain of groeck7@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-823c56765fdso913559b3a.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773979615; x=1774584415; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=grz9eWJ1ps3EBDuJN2bzyVHKIzdPvtiDT74qagFiumU=;
        b=TF0XcbSw9jC9M76ufdioVXZu65nu8Dum2s3fB54DIlKgS/TVyfZOuy3VncrDbVkFwS
         dQ+jf3SP9FJ7L2Q59P96BISkSGBtEuXsDdLUXJtwdvlQwFASjS6aPkRRlkb/ntNLQbae
         Qft2zjKHX1fjKjnStkQc/Yfx9cxV4c2jKeMgiuV5gDDR3XYKN8aEV6yFRQEnfp0L8AAj
         996Rfmz/66rWMy8QJWmf92dcFOoYaZSyyAkkqLd6tYm6G1+EI3IHvROImcN0N9anuWyW
         /2jsgBJCJBLRSJ8noYHIDO/9t3whhV7qgUPI/k9i/YDCwJhoxzqx5/4zJkj80bFQ5tEn
         LB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773979615; x=1774584415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=grz9eWJ1ps3EBDuJN2bzyVHKIzdPvtiDT74qagFiumU=;
        b=dhVe8aI24Y/rw30GHVaUmdNbMvqt5y2OlPR2L7BRuQqQ9UhDRzqPBplVgGzrMsHCV8
         syuzZx0PtpGhWBDiP6ovBKfAwJyzQw0w2Y4jIGBBB9muvQE2zW5iS8BTNWjol0+I+D4S
         nBHMFA8GG9WdIbNqZYs62MsceATA2HQ2JeW3ywOKnn1s+i7BqijzHt3a5uzspCXPLJfg
         6FJblEb827giLitTLTyVJTl1DDV154t2o+4H6ECcPJJuVFdapZdKhM/AMO/Fj15s1erU
         TKeDeaAPDAD2CZJrIF/y6BjysDgQ+yKyW4FDuSujaufJPMR/ipQXhuZQNj+Z7963nX+n
         mpIA==
X-Forwarded-Encrypted: i=1; AJvYcCUVnKEVVBq5P+v/RsXttJIRmqRok1xpU6Z0gEZU3jBCbmGVifOnIByMiOS/yu34fTtw8E32XC+kpQ==@kvack.org
X-Gm-Message-State: AOJu0Yyea/po+oGcdpfzNL3pkvBVoJ9/FcPVUHyDZiRREWD8oPmm9EHz
	UR0fLaUVTiOu2cUqWgxkLMQtxYwcGqte2mIPSXVgHBIsYCAB45Te5AW8
X-Gm-Gg: ATEYQzxc2PpUx9f+nD7WZI/MtSGSgEOsnJU3xjsXJ1jV9k/kWHXQuQaUGNeF8mrHePS
	y6a5A9XdKGcXsnll24M5wQTnlyOyz/a6dLv473JI6RhsiXSfJ6OQy+MtkHbASTUAUBeS8u8lFzl
	OVy1HaxabUWqFmKKgZ477NXXj19ZCiD37vMQM/BFdY0t9HLYDJrH2mTHBts9N91+bNEDytmE46I
	bLianS2PFeZU3kyEgm5GocYX7hf8YKWa90j5DVysBG+aG3pSeECh+Ry7RFy9HazJk7E681gGuLy
	AWrSJXyNEqliZqHv8ExbA1nipv5y+Gn0kQ6hCU499viKlDcTzLcCHMHAxsMiUnKeTGeryWqdXia
	FPStPXIPDmysBthtJZoVmfVZE6EhR8BIwhWFSFXEx8VbsZ8WcSzVINTvltag72JfMmoO6gdQJ6u
	fdlG1Qq1p8wSiPhOPhIUlwhna8Ap+XQRmxZh8f
X-Received: by 2002:a05:6a20:7f8d:b0:398:71e4:6282 with SMTP id adf61e73a8af0-39bce9b7e04mr1530953637.4.1773979614683;
        Thu, 19 Mar 2026 21:06:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443ccb56sm650198a12.25.2026.03.19.21.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 21:06:54 -0700 (PDT)
Date: Thu, 19 Mar 2026 21:06:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mike Rapoport <rppt@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Message-ID: <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>
References: <20260225065555.2471844-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225065555.2471844-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DAD820005
X-Stat-Signature: 781s55s346h1957ek97riicenhkxbsop
X-HE-Tag: 1773979616-937687
X-HE-Meta: U2FsdGVkX19qh8OamD7n+vXfQ2HX5zpdibeY5hrMsYy4zM/aea22rCdoavz/tsMSfCrPXTwERvmHG+kUzKDvNfzqu9hR1wu5RJPulliuUj/N2KKE55SMi00O4cTdsmrn4dY24LSO5Nw05nWmmVCpcW4C5dVyD2sdPxHrQ/lIWz976Ftg2+DJ42vS1ZYzbX5orEe6QefSgAV9BvcXI+oohOEdj6N1BrbapzS84ngRURmf1b8cktftZDjdTgavGGtDR2TAbjDGiBwWD+D154ht6qlM1WeYW6L+MGJkExbeutYitP5CpZScZX0+Jl3c1LUYZsyu0k/223mq6LSw3SLISw4/kt6II8kShf+wPVb++AX3XC7lyuZX1xjc3HHETfWdA5n1ZhHbxHAZIMOt/lrVZbgF67Aye/FHNYtlTSbMgJGPVYatVLYovnynMvKTekdcTtelwnhmjobb5zzHlTOi4SI9FDCZyvgNKIgHDI/Zf0rHNOuuSuuM8wyqlxNsryxj9pmgYgzw8C4yLQzWnYSV7Yw1/qA/AO5ooK1eLrBaxte+HLq/AbDTIsN26S0mHEc1EoQNV6Y2MCHVF6J35DYfEAGTTXaQ00r1CUscIjrgTffs5XfhovhmBga+xZhiiMQwf+Rp1Wm0kZvv/QV7IMfqt3zdUMntPrUQMjQEiJjv5cGpPzdJNkwHB7rw3+b84f5k8bPoIRWe69wO+31MkmwSUGCviwAv/os4BHvYuhiSNlglqS32Rv9VkisEHUCbFYo80XGLQmBXuUurVk5eEiCDEDuGBub3o/qS87pJNd2dk0ntEgmdfXFhTwxa6SGFCIqmyiLZhRaYYrr6dUs8O6ZgeS3rYbmp4PtQ8qCh4AIzgooF9u5LuuQMAioJywPd+96G5NdUaaqLRpAASaiulAjh+618GnsKWWw/kre6cdQNDXk+FZPe8YTakeu/o7w/763WMkMaDGra2EcPc/4MIEg
 qpRvDEI2
 KBMN1dfBQ6PWfMeGdn5BRndCxZVd6rTn+nMA7KNEuBgHIo4sjj3d3L02MYFKqrm2qmdBosLuFzGX0Ntcv5x1KS/rLdfZ7VGu3hFEzfi7OhOJRT8I3roWJgK5/uqtyxb9elHqDbugvALp5aywqCXWzTTJKjzwWdSxP22Ye08g6LepE7A4j8YLqzgQH+cbLZ3QBcpG3gAlE3xUggIQE7Fj7JzvjPs3V+UTatg9JcvJaiDSeEP8sfU+NpdcwTRBib0XRgYBUkXU6BmuYCkrqD6SoM4Ua++l2PkihVYt4aH9W0VE4/AhVluG0PlFKsWNrXN4BO4yKzLvlDO4Jl/DdQOIgCHSO+PtaPo0bV3ytKYvetbFTN3r42ZDY6RBHRqEpqEQlWIDYhAu80uDDUIMfm03+0NnuCcsf7l2zOrG/tvjecY4mfOqklh+U4xk7HegjNeVhIKbgl+DvrdOsvxnmwNbwZ/SxlT9krz//+bSm4qsaeDRmQxLfJkqarUbZCrXvyr4st/nhl/1SDSOsbbd8TdUOSCmvU3VihX5o3L6Y9YNK4AJbiqprONPk9fiosE1S5VFseegxwtufPB1L0ZcerufMivGOgN3EDuW9fsRU8o6D7T0BZtJz3uEy0HYKcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Feb 25, 2026 at 08:55:55AM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> efi_free_boot_services() frees memory occupied by EFI_BOOT_SERVICES_CODE
> and EFI_BOOT_SERVICES_DATA using memblock_free_late().
> 
> There are two issue with that: memblock_free_late() should be used for
> memory allocated with memblock_alloc() while the memory reserved with
> memblock_reserve() should be freed with free_reserved_area().
> 
> More acutely, with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> efi_free_boot_services() is called before deferred initialization of the
> memory map is complete.
> 
> Benjamin Herrenschmidt reports that this causes a leak of ~140MB of
> RAM on EC2 t3a.nano instances which only have 512MB or RAM.
> 
> If the freed memory resides in the areas that memory map for them is
> still uninitialized, they won't be actually freed because
> memblock_free_late() calls memblock_free_pages() and the latter skips
> uninitialized pages.
> 
> Using free_reserved_area() at this point is also problematic because
> __free_page() accesses the buddy of the freed page and that again might
> end up in uninitialized part of the memory map.
> 
> Delaying the entire efi_free_boot_services() could be problematic
> because in addition to freeing boot services memory it updates
> efi.memmap without any synchronization and that's undesirable late in
> boot when there is concurrency.
> 
> More robust approach is to only defer freeing of the EFI boot services
> memory.
> 
> Split efi_free_boot_services() in two. First efi_unmap_boot_services()
> collects ranges that should be freed into an array then
> efi_free_boot_services() later frees them after deferred init is complete.
> 
> Link: https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org
> Fixes: 916f676f8dc0 ("x86, efi: Retain boot service code until after switching to virtual mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> v1: https://lore.kernel.org/all/20260223075219.2348035-1-rppt@kernel.org
> * update the commit message with correct function names (Ben)
> 
>  arch/x86/include/asm/efi.h          |  2 +-
>  arch/x86/platform/efi/efi.c         |  2 +-
>  arch/x86/platform/efi/quirks.c      | 55 +++++++++++++++++++++++++++--
>  drivers/firmware/efi/mokvar-table.c |  2 +-
>  4 files changed, 55 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index f227a70ac91f..51b4cdbea061 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -138,7 +138,7 @@ extern void __init efi_apply_memmap_quirks(void);
>  extern int __init efi_reuse_config(u64 tables, int nr_tables);
>  extern void efi_delete_dummy_variable(void);
>  extern void efi_crash_gracefully_on_page_fault(unsigned long phys_addr);
> -extern void efi_free_boot_services(void);
> +extern void efi_unmap_boot_services(void);
>  
>  void arch_efi_call_virt_setup(void);
>  void arch_efi_call_virt_teardown(void);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index d00c6de7f3b7..d84c6020dda1 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -836,7 +836,7 @@ static void __init __efi_enter_virtual_mode(void)
>  	}
>  
>  	efi_check_for_embedded_firmwares();
> -	efi_free_boot_services();
> +	efi_unmap_boot_services();
>  
>  	if (!efi_is_mixed())
>  		efi_native_runtime_setup();
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 553f330198f2..35caa5746115 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -341,7 +341,7 @@ void __init efi_reserve_boot_services(void)
>  
>  		/*
>  		 * Because the following memblock_reserve() is paired
> -		 * with memblock_free_late() for this region in
> +		 * with free_reserved_area() for this region in
>  		 * efi_free_boot_services(), we must be extremely
>  		 * careful not to reserve, and subsequently free,
>  		 * critical regions of memory (like the kernel image) or
> @@ -404,17 +404,33 @@ static void __init efi_unmap_pages(efi_memory_desc_t *md)
>  		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
>  }
>  
> -void __init efi_free_boot_services(void)
> +struct efi_freeable_range {
> +	u64 start;
> +	u64 end;
> +};
> +
> +static struct efi_freeable_range *ranges_to_free;
> +
> +void __init efi_unmap_boot_services(void)
>  {
>  	struct efi_memory_map_data data = { 0 };
>  	efi_memory_desc_t *md;
>  	int num_entries = 0;
> +	int idx = 0;
> +	size_t sz;
>  	void *new, *new_md;
>  
>  	/* Keep all regions for /sys/kernel/debug/efi */
>  	if (efi_enabled(EFI_DBG))
>  		return;
>  
> +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;

Was this possibly supposed to be
	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
				       ^		     ^
?

Thanks,
Guenter

> +	ranges_to_free = kzalloc(sz, GFP_KERNEL);
> +	if (!ranges_to_free) {
> +		pr_err("Failed to allocate storage for freeable EFI regions\n");
> +		return;
> +	}
> +
>  	for_each_efi_memory_desc(md) {
>  		unsigned long long start = md->phys_addr;
>  		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> @@ -471,7 +487,15 @@ void __init efi_free_boot_services(void)
>  			start = SZ_1M;
>  		}
>  
> -		memblock_free_late(start, size);
> +		/*
> +		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
> +		 * map are still not initialized and we can't reliably free
> +		 * memory here.
> +		 * Queue the ranges to free at a later point.
> +		 */
> +		ranges_to_free[idx].start = start;
> +		ranges_to_free[idx].end = start + size;
> +		idx++;
>  	}
>  
>  	if (!num_entries)
> @@ -512,6 +536,31 @@ void __init efi_free_boot_services(void)
>  	}
>  }
>  
> +static int __init efi_free_boot_services(void)
> +{
> +	struct efi_freeable_range *range = ranges_to_free;
> +	unsigned long freed = 0;
> +
> +	if (!ranges_to_free)
> +		return 0;
> +
> +	while (range->start) {
> +		void *start = phys_to_virt(range->start);
> +		void *end = phys_to_virt(range->end);
> +
> +		free_reserved_area(start, end, -1, NULL);
> +		freed += (end - start);
> +		range++;
> +	}
> +	kfree(ranges_to_free);
> +
> +	if (freed)
> +		pr_info("Freeing EFI boot services memory: %ldK\n", freed / SZ_1K);
> +
> +	return 0;
> +}
> +arch_initcall(efi_free_boot_services);
> +
>  /*
>   * A number of config table entries get remapped to virtual addresses
>   * after entering EFI virtual mode. However, the kexec kernel requires
> diff --git a/drivers/firmware/efi/mokvar-table.c b/drivers/firmware/efi/mokvar-table.c
> index 4ff0c2926097..6842aa96d704 100644
> --- a/drivers/firmware/efi/mokvar-table.c
> +++ b/drivers/firmware/efi/mokvar-table.c
> @@ -85,7 +85,7 @@ static struct kobject *mokvar_kobj;
>   * as an alternative to ordinary EFI variables, due to platform-dependent
>   * limitations. The memory occupied by this table is marked as reserved.
>   *
> - * This routine must be called before efi_free_boot_services() in order
> + * This routine must be called before efi_unmap_boot_services() in order
>   * to guarantee that it can mark the table as reserved.
>   *
>   * Implicit inputs:
> 
> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> -- 
> 2.51.

