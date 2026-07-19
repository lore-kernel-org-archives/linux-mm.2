Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE0B5C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 09:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748A06B008C; Sun, 19 Jul 2026 05:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9066B0092; Sun, 19 Jul 2026 05:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F5A6B0093; Sun, 19 Jul 2026 05:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36C786B008C
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 05:02:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0724A056A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 09:02:01 +0000 (UTC)
X-FDA: 85004934042.22.FE22406
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A33E10000D
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 09:01:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxYrqDE3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784451720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GE4nZxrWNILr4LFFRjNo6DdTk/Sh1KEFBm564eW9JxY=;
	b=LhNAhyUXF9E/6NOJWjaDUZhBiX3KJSXa2b4qVLgv+jMKZmgo229szD40W82VVtlW4LpC4A
	eFcvhmwb9MqhsSLsRgus5c2VmwtmwGGwMo3uvXS6DhNJe8kk2UJcxheeI7sjszTaLfNBbY
	YsMYgDoLZ0Wk+DDoBvlp4HTWqn3ItA8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxYrqDE3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784451720;
	b=63/B2+vDpp8/s0kyfMsm7ud/IVr15PMThaMrongMkU1rM1AHMvaKwAjKnA78fLK/uRbr85
	I7lcNMWy6jfFD3DnHuR2qzkizaOnvoNXcuPMAzZZUu4gHCsR/osYLC9GG44PwhRZD3TYjN
	UOPMOVRXbs6hNWxWv/P4G7R/QAiT0D4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 845C2600AD;
	Sun, 19 Jul 2026 09:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232671F000E9;
	Sun, 19 Jul 2026 09:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784451719;
	bh=GE4nZxrWNILr4LFFRjNo6DdTk/Sh1KEFBm564eW9JxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RxYrqDE37oWsZLMfniRw2CAsWoYmOTNiL0RXsV18c8RcXGAzpdI+ErM4J5RUVWkqD
	 JSymOjJOB+Hzx93sAkLLIsAgD3fHlZMLdclIHL3gnRh7mxZ4H+TKGizwC4Qz2W2eL7
	 fSurb44UXOSGSxdhWFIPu+iYcsiHD4F+v6VBhWVoKTEdorMS5F11FuC2feCgYx8VrZ
	 DY5gsGOwtzRi7UZZr+qwj776f4RE1sp05dFNqYngsJ/67jRpF/rdAyo2CIlG7bmE17
	 caFEFeR4uJM7mHzdZ8d8unE9EtpvW4ts/VljZzgC6JgbIiewxk7y/pSr1Sc9edmEfQ
	 h00A/dh2KsbRQ==
Date: Sun, 19 Jul 2026 12:01:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Huacai Chen <chenhuacai@kernel.org>, linux-mm@kvack.org,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] LoongArch: mm: Expand modules virtual address
 space to 2GB
Message-ID: <alySgaaQen6ZtwSo@kernel.org>
References: <20260717075715.25513-1-yangtiezhu@loongson.cn>
 <20260717075715.25513-3-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717075715.25513-3-yangtiezhu@loongson.cn>
X-Stat-Signature: 38dpnfjnr4z5ox7terodbzr5f3agmh66
X-Rspamd-Queue-Id: 1A33E10000D
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784451719-831749
X-HE-Meta: U2FsdGVkX1/LnzPgCUKPhNsGzvT6P+Rb5Peod3yIsJWJj6v1QbrzO32JHsVJ/MxI3KcZqUoP2ZfaRg0xdl0yhCP/aNi+3HB5bfFyps+N52FANrEBPuNHJczI6PlGASTi6+z8V2jrlDdMcKOCD6rSkFUutYsMTdzc0ot3kG7QkMG0cZuN2dD9bofnwGGGvMf82IUg4/WlMTtDT34z2Gjs4Ps6YUZkGb+U/kFp08BWsjr1JgMhOJeZGn+OvpjOZ+zlxQGhhcn+94vyij3lZA3i26YYXyIAZR0mksaOGS0/nj+EYZJechuElpmvs40mYowLfq5sqeuRgPaVjKK8R2QizfM62X/7zZTskmRXccuANMrYTNfC9s/tyJ5nxo2+GcqEohtUH3M4tWuz/7sv7kJWXwNijycGOrgHdR74vjS/Lx5Gt9VRIfTHC5tActjoIaWm5y7ZmxyN+lfHGkOt2m+N/17MFJtGTtfPi7rwQEoH98bw0QtfroO3NowrqwqGf/6wt1RsgB6su807RWBovnvCa9MdxXTnV5zKt017MexwmSH7df78ODkWHqoJyEKAeEyYQWk2TqY3gFgbg0N62TgXUcBi7mOoG+HBtU37cwB1TzCoiI15g2TJKtGyHU0gyYNflx6miWgjpM8lSLHjdkOqr17pVWHNf/AbxFTvGXUbGKRcJPlIcwBQBmtbULSMHqFKw54ITSjUklVpCb76Vy0ALozzfzjG4aQxEGGCnA6qaLlKUFv/DlUplPsXJwMZ7tHxLWWRcwIldrLk1WfxeZYsXmB8kX8aBJdZdLekGkc0biv2rK3uAYENr02ZpCehT9xmW96auyXINWTcrH+ubBiypXUTl0bqPUcxNHw2mF8KY8YoYLyGw63Na7AxyrxHd1iibFac8NCDQDszLNrXpAc2oZd4qYNm+zsG0F/YgOcS1PGo6Fm4EWyir2aIXm/wsYBjFvSj2+3bSEWFVqBX1jO
 KFLmtokU
 iZBigHBxK2obCCDG2YQ/qY9GpkXKL0lD8Nw1Udzgu/tz7vTnIBB8DFX+MNjgMn9D2bSsAq0Ugz8WKURrDJ4+sFbO44LP688Y8DsDQfaQ1lDtH8NPyh14jiQn/8JZ1RL02HqWUJkVtVpsS55GxNgjMprw+YwRcVnLScg6XT/G2S4EqfGxXgm3zn5yPwKhPulSn1XyW7MO2yrjK072vm43Ni0dOkEahTQqr/5fJSTKRYkVxusm21dTiMasxBqtHaXQb1MDl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Jul 17, 2026 at 03:57:15PM +0800, Tiezhu Yang wrote:
> Frequent "execmem: unable to allocate memory" warnings are observed
> during kernel module loading when updating the latest kernel.
> 
> This is because the modules virtual address region on LoongArch is
> tightly constrained to 256MB, while ARM64 and RISC-V are natively
> configured with a spacious 2GB region.

The constraint follows architecture ability to address kernel instructions
and data from modules code.

I don't know what are loongarch requirements, but I remember that arm64
added a layer of relocation support to allow 2G module address space.

> Expand the modules virtual address space to 2GB for LoongArch to
> eliminate these allocation bottlenecks.
> 
> This change only applies to 64-bit kernels (CONFIG_64BIT), 32-bit
> kernels (CONFIG_32BIT) are entirely unaffected since they do not
> define separate module address regions.
> 
> With this patch, there are no "execmem: unable to allocate memory"
> warnings anymore for 64-bit kernels.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  arch/loongarch/include/asm/pgtable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
> index 223528c04d73..e5952ecd6a73 100644
> --- a/arch/loongarch/include/asm/pgtable.h
> +++ b/arch/loongarch/include/asm/pgtable.h
> @@ -96,7 +96,7 @@ struct vm_area_struct;
>  #ifdef CONFIG_64BIT
>  
>  #define MODULES_VADDR	(vm_map_base + PCI_IOSIZE + (2 * PAGE_SIZE))
> -#define MODULES_END	(MODULES_VADDR + SZ_256M)
> +#define MODULES_END	(MODULES_VADDR + SZ_2G)
>  
>  #ifdef CONFIG_KFENCE
>  #define KFENCE_AREA_SIZE	(((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 + 2) * PAGE_SIZE)
> -- 
> 2.42.0
> 

-- 
Sincerely yours,
Mike.

