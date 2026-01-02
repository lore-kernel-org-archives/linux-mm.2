Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F5EFA3729
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 15:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06FF6B0089; Fri,  2 Jan 2026 10:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4CE6B008A; Fri,  2 Jan 2026 10:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3B16B008C; Fri,  2 Jan 2026 10:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9964C6B0089
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 10:02:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FB581A0419
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:02:48 +0000 (UTC)
X-FDA: 84287340816.06.82C5BB1
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D28A40016
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:02:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NkFvluiX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767366166; a=rsa-sha256;
	cv=none;
	b=g5zOn/sZSv6Ga5uN9TpWK/Umy7wdCr5fMvSoo6C3y7sDH3eORDFvm5KI+TIjX+3VvahVz/
	2AOGf9XEqJJDUrUipXlTTiXjK82HxL6jSP5g9Nm9QIfq3zk/Ov6i+LH1JtgANBqejOE3Ze
	Y9w3X7jiy9g45i2L/QTE6u1wj6bjudE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NkFvluiX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767366166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78CrL/Yw4CkwTi9IrweGEIjAaqdTs60nsqudaIitNH8=;
	b=NJyDH32HdGF3Az5gCD42Ml1Cv6GpZ3XnCK2xwOSouCOJUVil5D5k2H3W7RDiUI5zSS3o8w
	38ntJeljzgukuFyTjefVjeD4juJoU20aQqpt2jN5713pc93lMWseEQVfy8ub3xVXnjXzTj
	VpZ6G4pDVkBPNvZCh4+JQo9HHJsoExg=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42fb5810d39so7822772f8f.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 07:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767366164; x=1767970964; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=78CrL/Yw4CkwTi9IrweGEIjAaqdTs60nsqudaIitNH8=;
        b=NkFvluiX3hDPAp+eltzLUbsHyD5LpDgKqhHUk+L2MitskjV3oHvilTLEn90plvoHSK
         yad3BjNI8bW9vah+acA25XNus9f0t8PGv7GZjE+q37qL0q9A9fpoXFJ24Hj9bKqMCXpI
         riHarJlTwj3fDpiegqtUnStXtyuTK2ppZHq1Fk6ZQxKrxX5PX9YrSTWd0JM+cfwmmNme
         m1VdYDzjzBgBYB18JAFjuIcNUrgrF0ohmL6S1O5pfSbhEHdOxepQR6GqCGJZ+A/troW/
         yw+LOHMEJ4shn8T+qZA9LaR51QR7uVHwZgmPu1cpRzGOFXKdQKOLAb77PCX9EZfUh+el
         zuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767366164; x=1767970964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=78CrL/Yw4CkwTi9IrweGEIjAaqdTs60nsqudaIitNH8=;
        b=kJJVUz4mSM4bjnXrjficzS+WeydF6lvwargNiONXX3gNr3Q5F2PZaMzewjfZXVzdII
         +b5QleptTPuH212d0IzPAqUA2qtrWc7kQsH3JEqIBj9f0/cNhI/yRo36tZQsG7IJYC7w
         S9KvE6BT1N8qeqOuOd2NUES4dYHiLezhwRck3y+8GOw6YfkEQXVJdxPbgLa66WNGi1XT
         gtCLMmOkRRHX6qAwzRXtd8sx0RY2b83nHIbcGUl7A/05IyAE/9xGXQJwJX52/GcteU7b
         velkB5yRbQH9Xc5Gm2UgXa4vQ8wg1iev/OI78cV3YuKcF88oStIF/Uf93fsTLPb4Sris
         NlHg==
X-Forwarded-Encrypted: i=1; AJvYcCXtnRK9xJk6mkV/gohuI6FKsLGQ1aiFn3/Qld9gBdrNSTsOmBhNqwtb4E6Eh1RNc6fePzCy86kC9g==@kvack.org
X-Gm-Message-State: AOJu0YyNoHSKzm741ZsrbmV81yGPt06uojmE8Tz1wg/wvsJhT+gOleeX
	cfVr0uBkS49+OFEAXx4DAjgvCHesu7yYUgmsaw9UoxWKupdxgF1xtx4C
X-Gm-Gg: AY/fxX63uaisdn5oHruw+KRtWaxEK/TIJQxl3luiHhNroAqLvoip5rkSo6IcoBzPcoL
	64mtt20t5aYXPBZXGhNRi0OwyZsPqF5+lag+vW6l+qFRAOtwCR7FRAAT69GeJnoqokcdBrbZZMh
	YewU9s8zXpCUV22NYGm8HsyKCBzSgg7cDaQ6swIpr+gq0GsEM9Kd2eRNzfvOLqHeJxUVZ6KU603
	OX9iMY+xuzB4Z6z+K7j2GKZMS7WLppGd1jokyWpV1GWEc5iKbreybk7WEJuibK3m34FccTYXKvF
	NWORlygp5kAwG3ws6r9PCvKTIFt8hMktGUXrPIwDrXWksEnnsL2akjdXkpVGhe3OfOHVN01337m
	WqPaBszVWQyTBIn/ItdC3GdXWRoCIVIGiNE8dqL1/bwdVuqRmO7CyIAbnMfZyeFCpoxwstOQ9x0
	A7ZOjBPeYFiWEu3mF7XFdfSGLlsvhttlScBQKfV2tvbOymNvg2uNqx1jT3pTXbw6yzYqE0pftyM
	iIlPEM=
X-Google-Smtp-Source: AGHT+IEZFYOymrxwaTRBQeTahdxbTMALR1HgSw7tJQK4/p6xOuUXwSUyCfnvrSyrvze7klp4JV9pqQ==
X-Received: by 2002:a05:6000:1865:b0:42f:bab5:9533 with SMTP id ffacd0b85a97d-4324e4cb9e0mr45530420f8f.17.1767366162677;
        Fri, 02 Jan 2026 07:02:42 -0800 (PST)
Received: from ?IPV6:2001:16a2:c8d2:2b00:183a:1350:d3a4:d89? ([2001:16a2:c8d2:2b00:183a:1350:d3a4:d89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea82feasm85809097f8f.24.2026.01.02.07.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 07:02:42 -0800 (PST)
Message-ID: <2b315095-2393-45d5-b0bf-ea9fbecd2607@gmail.com>
Date: Fri, 2 Jan 2026 18:02:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] kexec: history: track previous kernel version
To: Breno Leitao <leitao@debian.org>, Alexander Graf <graf@amazon.com>,
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-mm@kvack.org, rmikey@meta.com, clm@fb.com, riel@surriel.com,
 kernel-team@meta.com
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
 <20260102-kho-v2-1-1747b1a3a1d6@debian.org>
Content-Language: en-GB
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20260102-kho-v2-1-1747b1a3a1d6@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2D28A40016
X-Stat-Signature: 5fboikgefk1acy9644pqi86zimoodm9f
X-HE-Tag: 1767366165-524942
X-HE-Meta: U2FsdGVkX1/Al/c/suaCxaZMfwz9mfsY6SvlJA0KnhFnDR6UFavNHdfs9VSFLaolWwHIRWSdefE4MBwlo7beImPMnxnHAdLL9tJ5DzQLhLSWtDoxLUfbPGW5XuQeQrvm5cqeBzEx7RkpUDf0V8MD2dMe0buLBGPz+6g1VzPlxBzd3iOCkb9BhiZM42nDqTe4fn+DDeSp1DZaMzIOCc83nW3dLwz07FsG7vXgecKnu9zUCtqdy+LTUS8Wd06HkKdQBSTbs67Ox0u9Jw49bOYebxtr/+13pG3RNmhkpFL/DnPKZqFW1as/KCh4auTjoJmolsMvv8ocBOFqpMdH5ihKfvoQsGCvmDREXmfBIXpBmv0bQsTFrSbqTsfWlEOSKUudJZF4RYnovXh6+p6pYce9LXFTavJ8zOuJK8a12myyi0EP4T0klQFtM05pfuq2yKWCk5rFturkmMHvTVs5rmbseiVMgboIZSn9tY1HO/aiRfUcKdy17WhiGST+5v9h6f87nXNkyzqVR2eDpiqXxeK8akBUCQnk5R4/XCqytl2oycSX1eD85xjXZsXzRWIzPoKpVwOdmmjrwAZCP0LmsZliPNA81RqMWlYvRF86F81KmZPPkcIVDhiZ5DyVa+xC+KHuYmIY1nGLA38KYF4+tp4soc78I0MW7a8XzX8CoB6jQvyY1L0g8Fu3Xkg6QiqyAJUFGuqWlXr4DoHHWSg9t1AG2U+1GBqodR0q8pxGtB0acPPAUwkkfsAmwmkFU+crk2bxnlt5T7Tci/D7/T2PGEVxT/2igkIW4356Mpx87eCnOvkchhh5wnY9qHpPSOSiv+OoCiFeF0AMjPMO+ORKyCvaiXGbXsm5xgb7QtSKZbqcLwFeF05bH5B3l5UdgWP6BtW6b5ADR1S7OlUlC+jNPDStg40vY00tKKe7fiVq2xa537s/FXq7kXcZ8NfDEk2i9QrKBz/BIIjprH3IJYgxRkQ
 IkuLT19y
 Y/Kd4BowwRLqXvoRyXy8ouzwkC6O3sB6fjdRgT0bbK8+nSRbRmD0f+p+dwIyqEBlH6NJAtcQLEE/GxOIjYXzYbunvCX8VPVBh4Xvf5fL1ioAE4KFu+vbNgmCKBWL2GOXYXkhA5SfuVb2TQd9XD9GSzHQectKMG4/fqrWBlCKOxugzhBxsPx08Qzt62wg6J4dv5LYUyP2+vnpedAYP4EpAF0Ss47ARhmh+SivrmjjOgqygtAwm6rSYZK0JM1Bp4JYj1UAITgmSt7XYQSCTMa5xyvgJXe1AwwW4wWWNDo7CjhKPh4sk3a3jCdOm0NSRYgeLOqXA3D555M6XWfBsE//jdDYw4gr2mxpoApnExvZeB8qIupuW6qP7RQQNqiqmMXlDtQ9nq9XFcDJab6YTTLHSfSxmetwp7ACkxngFJvmeKgn/rfF0P1kv6/m/4avxM5n2u8Jh3g//V+kAlxk0daMH5CqvBXaPAi73Gh3Or38cmIPFJ2ciVh4v5GwLGIhSoXDMrspNgV5N4QiEQU6TtQnai6lLDdWdIOod3nxfNcsPusvSBiKMchUqydCVDvVUFvHQ4VjI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/01/2026 17:53, Breno Leitao wrote:
> Add CONFIG_KEXEC_HISTORY to store and display the kernel version from
> the previous kexec boot.
> 
> When enabled, the current kernel's release string is saved to the
> "previous-release" property in the KHO device tree before kexec. On
> the next boot, if this property exists, the previous kernel version
> is retrieved and printed during early boot.
> 
> This helps diagnose bugs that only manifest when kexecing from
> specific kernel versions, making it easier to correlate crashes with
> the kernel that initiated the kexec.
> 
> Disabled by default to avoid overhead for users who don't need this
> information.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  kernel/Kconfig.kexec               | 13 +++++++++++++
>  kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 15632358bcf7..b770c68a3800 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -94,6 +94,19 @@ config KEXEC_JUMP
>  	  Jump between original kernel and kexeced kernel and invoke
>  	  code in physical address mode via KEXEC
>  
> +config KEXEC_HISTORY
> +	bool "Track kexec kernel history"
> +	depends on KEXEC_HANDOVER
> +	help
> +	  When enabled, the kernel will store its release version in the
> +	  KHO FDT before kexec, and the newly booted kernel will read and
> +	  print this information during early boot.
> +
> +	  This is useful for debugging and auditing to know which kernel
> +	  version performed the kexec that booted the current kernel.
> +
> +	  If unsure, say N.
> +


I think we should make this default if KHO is enabled, i.e. not have a Kconfig
option for this. The cost of storing the char array is negligable.

>  config CRASH_DUMP
>  	bool "kernel crash dumps"
>  	default ARCH_DEFAULT_CRASH_DUMP
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 73da00aeaa99..06d99627bb3c 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -21,6 +21,7 @@
>  #include <linux/page-isolation.h>
>  #include <linux/unaligned.h>
>  #include <linux/vmalloc.h>
> +#include <linux/utsname.h>
>  
>  #include <asm/early_ioremap.h>
>  
> @@ -36,6 +37,7 @@
>  #define KHO_FDT_COMPATIBLE "kho-v1"
>  #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
>  #define PROP_SUB_FDT "fdt"
> +#define PROP_PREVIOUS_RELEASE "previous-release"
>  
>  #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
>  
> @@ -1253,6 +1255,9 @@ bool kho_finalized(void)
>  struct kho_in {
>  	phys_addr_t fdt_phys;
>  	phys_addr_t scratch_phys;
> +#ifdef CONFIG_KEXEC_HISTORY
> +	char previous_release[__NEW_UTS_LEN + 1];
> +#endif
>  	struct kho_debugfs dbg;
>  };
>  
> @@ -1332,6 +1337,10 @@ static __init int kho_out_fdt_setup(void)
>  	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
>  	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
>  			    sizeof(empty_mem_map));
> +#ifdef CONFIG_KEXEC_HISTORY
> +	err |= fdt_property_string(root, PROP_PREVIOUS_RELEASE,
> +				   init_uts_ns.name.release);
> +#endif
>  	err |= fdt_end_node(root);
>  	err |= fdt_finish(root);
>  
> @@ -1455,6 +1464,25 @@ void __init kho_memory_init(void)
>  	}
>  }
>  
> +#ifdef CONFIG_KEXEC_HISTORY
> +static void __init kho_print_previous_kernel(const void *fdt)
> +{
> +	const char *prev_release;
> +	int len;
> +
> +	prev_release = fdt_getprop(fdt, 0, PROP_PREVIOUS_RELEASE, &len);
> +	if (!prev_release || len <= 0)
> +		return;
> +
> +	strscpy(kho_in.previous_release, prev_release,
> +		sizeof(kho_in.previous_release));
> +	pr_info("This kernel was kexec'ed from kernel release: %s\n",
> +		kho_in.previous_release);

Maybe s/release/version everywhere? It might not be a release, but no strong opinion.

> +}
> +#else
> +static void __init kho_print_previous_kernel(const void *fdt) { }
> +#endif
> +
>  void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  			 phys_addr_t scratch_phys, u64 scratch_len)
>  {
> @@ -1527,6 +1555,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  	kho_in.scratch_phys = scratch_phys;
>  	kho_scratch_cnt = scratch_cnt;
>  	pr_info("found kexec handover data.\n");
> +	kho_print_previous_kernel(fdt);
>  
>  out:
>  	if (fdt)
> 


