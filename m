Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B101BCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1816C6B0022; Thu, 27 Nov 2025 00:05:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158C86B0023; Thu, 27 Nov 2025 00:05:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096016B0024; Thu, 27 Nov 2025 00:05:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECB5C6B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:05:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34BBF13BDB0
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:05:50 +0000 (UTC)
X-FDA: 84155199660.11.0BA6653
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A2F6AC0009
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:05:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H4jAdZwu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764219948; a=rsa-sha256;
	cv=none;
	b=Czz51vFSBnEivx8ndQRPXOmU+LDx8+yg2j1MV7iquBduQTXswz0a63YAhlc5ZXThWPC/iZ
	2tlxva/fpJB1Y9bm0hvNHtthJRkGhaDA+PI3CERWOSJVngA/63vjFhXEyGC7v0U0XRvD0q
	af8NkKkFjIOWDgJ1e7uOuk16fC/LdIo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H4jAdZwu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764219948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysL48WmHMu6ZVfYX+/EYpRVkz/nBDb/kZFPfAI4Ic1I=;
	b=tZKycJvqURVmX6scAgdC9e8fu5Tvho3qP30H6l2uUI1aeaQMjCO48vaWFqrTF2V8Iw4xi6
	ZRYLZBv//A+2fmYhqS5zbtVA3cNklYcBllmYk+3/JwK8T4CLBFFPBMYyH70BBkJkpOSDQ9
	e8kSoRmhgg+Xp8/6CsZBZgcud/WpYNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 330DE60182;
	Thu, 27 Nov 2025 05:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0DEC4CEF8;
	Thu, 27 Nov 2025 05:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764219947;
	bh=Nl9RwO91yTa5covY+c2/N9Gq4s0OvI/oEAchPUaaHrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H4jAdZwu3Sd4OjszEkHlJtz4SnzwWGXrgyaOCalfAVVClCU29XQXAC0JKogFFq9sq
	 zfgHOpWN+oVfBr555kCBzeAzfAliqANmAe++un6WB8Y+mQrKzT4hnA6Qa70HJJfMeK
	 HRqfMJRPLFbLVti/I2v4I3InHPGzVtf5Nk4mlbdxVdU4vBr+VA+q+U233XhVyKEcvy
	 4pPBwgFCPs8W3b3DDj1JrtQXgL4RIZDYN2/MohtkNtNmhQSjjqNEdgRWJDAjyaCCxn
	 3d3gNFgh07WSRkNajVcF4mcWMFN0cgepD2nu7HJzgcVbgkp5heeYUNsq1PtZm+pO7c
	 VSh9U+RbFsZbA==
Date: Thu, 27 Nov 2025 07:05:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, changyuanl@google.com,
	graf@amazon.com, leitao@debian.org, thevlad@meta.com,
	pratyush@kernel.org, dave.hansen@linux.intel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memblock: only mark/clear KHO scratch memory when
 needed
Message-ID: <aSfcJIwxglEc-cjJ@kernel.org>
References: <20251126072051.546700-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126072051.546700-1-usamaarif642@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A2F6AC0009
X-Stat-Signature: 1tgter3xrirrba3esdd7ekosmesqk7n3
X-Rspam-User: 
X-HE-Tag: 1764219948-370856
X-HE-Meta: U2FsdGVkX18CDkk6+E7YaqBK7dT6rsDoMN44R++GcqgW2LnVdFUTHfYpuq3qMGmYHTPm5ssxBA/Ts1WgwPEkBCyViIW8c5tKMXlCARBCAQ4QBpxH/uBCjbrsPJWT0eZ9KK+5G1dtCe4yH9sZyr1N6U16DxMigoU6j7R2qnTVmRVQ8JCc00Mq3aApfRInRxaFXFmbdE9MUZqkZUQJSr++4vlHOM0R0Ccok00gujnZ6MJ5CJEXgNlDvohT4OQbSG/PA3DnQQQsEeE05EmgVNP8nF8qB4h7qKtBi1m5mgxAZqyjjg56fSKf8VBRvEOaPDAFnLUuCgW19kcSF5sKkPl9YYUvtUBTBM1Eg8Oak880lvEViX5TYt4Nr2i70THhoWvKat0cqxUserdXV/HGxsxE2UplevEfRt663aQz5WlDXEYJ9XvNuXDh5jxrOtpK2PLe+Fzik9yGhGFUnwcNOHDyPDOmPsOr43KfiG8SYmqf5HT5uQP6dyNQ3aUvR1v82geH0jbYEopGKUpzS9JsZUZqvlC7aL85tN0oLyrbfHlrJMVHt4FUVzw0uzN1HxW5hYWQLVINqAkV2OLZ90QB/0+iu3QgOeroCmSfpEUIHyfZ1/lkjJLVM+ffjt1M+LmSoTaiBkTH0/dWKb9xSAOEg7EIemkJRt31QaaVzbM7+QnjSZSmmd+zQwvGqs2d5RWClkVlHFk0s+WDxvYCFfRqKBqIWIpO4r+d6wLJN2dxkJGtz70sI0DVX41i4cGsacOz5FffSUyheAlM4TORS2WuSMY7GrkOsEa6GPP1xL7CJOoDs8Rpvc3Fm1C36ANewDlspMm1rV7YRyrd9co3qpA6jKz2EQ2fBVEpkwKJJ9iaT76wynbtVEryba7Bb7B9xvQiHhN5HHk4sWzlnYDIKZTP5ZYTQ1d+kvHEEDKNxgCLhiktBbKDNORDWxM802a+HwNxzXkCvYjlwPd8dNBDrFPSryK
 ARdtrK/I
 klieagu3hPjqHlRmvpfJ/M2iwtvH6VcesrMeBr56YuZlxfkCRrqwEIqrk0HVuDJsuOOWCQEpoXDX5nQq6YMCvsfbA6jArWUeGke68Iuk9NoL6dbetb8G1wchteGwCeRRAudGoaeTgz5FNfo5QEw2T8Kh1f62gSUl0Y3jtxzJn9OCdAUKxTHzppJ8brQx+fxaFiCn/3HcivqmKD5dGHAcojvZMobbQBuT+i5VjHIX/QJt6nVXE6rjn22gntcanwNaHrlzn+yC5+hVpHIMXBFeISgzBV/a70Nuo/pGakF9MTa5+wfmXB2yRuYBoJ4ny/KVEQzhDDeAMbv67G9DMK2DYjPREbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 07:20:51AM +0000, Usama Arif wrote:
> The scratch memory for kexec handover is used to bootstrap the
> kexec'ed kernel. It is only needed when CONFIG_MEMBLOCK_KHO_SCRATCH
> is enabled (selected by KHO) and if it is a KHO boot. Add checks
> to prevent marking a KHO scratch region unless needed.
> 
> kexec_handover.h is now unconditionally included for is_kho_boot.
> 
> Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
> Reported-by: Vlad Poenaru <thevlad@meta.com>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
>  mm/memblock.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index e23e16618e9b3..5c85d575bb61c 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -20,8 +20,8 @@
>  
>  #ifdef CONFIG_KEXEC_HANDOVER
>  #include <linux/libfdt.h>
> -#include <linux/kexec_handover.h>
>  #endif /* CONFIG_KEXEC_HANDOVER */
> +#include <linux/kexec_handover.h>
>  
>  #include <asm/sections.h>
>  #include <linux/io.h>
> @@ -1126,8 +1126,11 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>   */
>  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> -	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> -				    MEMBLOCK_KHO_SCRATCH);
> +	if (IS_ENABLED(CONFIG_MEMBLOCK_KHO_SCRATCH) && is_kho_boot())
> +		return memblock_setclr_flag(&memblock.memory, base, size, 1,
> +					    MEMBLOCK_KHO_SCRATCH);
> +	else

else is not needed.

> +		return 0;
>  }
>  
>  /**
> @@ -1140,8 +1143,11 @@ __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>   */
>  __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> -	return memblock_setclr_flag(&memblock.memory, base, size, 0,
> -				    MEMBLOCK_KHO_SCRATCH);
> +	if (IS_ENABLED(CONFIG_MEMBLOCK_KHO_SCRATCH) && is_kho_boot())
> +		return memblock_setclr_flag(&memblock.memory, base, size, 0,
> +					    MEMBLOCK_KHO_SCRATCH);
> +	else

Ditto.

> +		return 0;
>  }
>  
>  static bool should_skip_region(struct memblock_type *type,
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

