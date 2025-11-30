Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8B0D111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 08:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0776D6B0007; Sun, 30 Nov 2025 03:52:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025836B0008; Sun, 30 Nov 2025 03:52:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DFC6B000A; Sun, 30 Nov 2025 03:52:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D73EA6B0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 03:52:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32BDC8AC7A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 08:52:26 +0000 (UTC)
X-FDA: 84166657092.26.F5E9BA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 775334000B
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 08:52:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Dfs6iEG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764492744; a=rsa-sha256;
	cv=none;
	b=UPy9p3cIpvhqNOZOJZKnN82YsrvwJWIuQpQD6B2CJl/84RyeUxHYlWh5pFS0x6PMyZn07J
	A0Kq+JOEFHFoVZEsH3mEEndWUz7r6GXdmMeIenV6qGugM9DI/ZSw4ha+V73ZE1Q9l8wrxg
	E/wKfixIyFgM4//5YqWQuFn/Tx02Sy4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Dfs6iEG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764492744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEl8h/SHK48Ec9+63cSfiJL8apQfIQh2CxysIKOTrLI=;
	b=O3QeufLTU03SqLqHBmTCj+pjhSHvXObYw6cxN90MYkgO79h3iMXulEh3VMnelj1AQqS40R
	2vpO621WIszsDm3iFh0hkcCrohzC750UWbZpxHrybThuN/JXwiklEuU/McEJpJDBztL5Y9
	LDOZv5y3M1WWYfPEFLvsfXYHaJ5X6Xw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ECAF4070F;
	Sun, 30 Nov 2025 08:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98D5C4CEF8;
	Sun, 30 Nov 2025 08:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764492743;
	bh=GDfpz+XHBgaz5Oe6M3Qx04ZeGNYSuRXkIueya0mVaMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dfs6iEG/Ea2gytBgh62gwoEMtevcbfEdafzwJqBjEx5i0w0fohwgiNdgaGqYo6EPn
	 g8yKhJcPthPnzMguLO+AEmkTVX4TTdC7pTxDzHRk1BlLat6TmhsqYis+nyCpgKG9lh
	 1NaHOamVKTDIhCZC+Ct+d5TldBjf5myxhBI0LHexiUFJyed1+oNpAPovCLPbvOAEVM
	 wkuZzxGR9CSkGyooyVDbNYeXJXJMDb9HfswH3v9SCTQN/wHVJUGXywE/5rM/kRcs0q
	 mnbkQ6jbslWupbWE3lswF8HNjO0KwlKi2M5hkvMVLWfdyhro69/6CAz9XLqUIkxm/F
	 7/jAmiAv49R2Q==
Date: Sun, 30 Nov 2025 10:52:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org,
	changyuanl@google.com, graf@amazon.com, leitao@debian.org,
	thevlad@meta.com, pratyush@kernel.org, dave.hansen@linux.intel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
Message-ID: <aSwFwMVyFcPlOR10@kernel.org>
References: <20251128173257.969322-1-usamaarif642@gmail.com>
 <20251128173257.969322-3-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128173257.969322-3-usamaarif642@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 775334000B
X-Stat-Signature: nb1astknnrta71in1q31jbczottzzq9m
X-Rspam-User: 
X-HE-Tag: 1764492744-972510
X-HE-Meta: U2FsdGVkX19KSek5gfWDLk2SLjW4xUtP5IhK+QHYB/19pWvxtZwzFQxMeZqqtPbuMoYCSpWE3fPGct6nzMY+CsABAba/6mIJCs+xEYqPMmxYjjFvA5ThRkYctAJFfypx68zLjqgXAheB+NmRvpUKBagzb2O2NIO1bR7vvz8aJEZ79sh2nof6+l9HSrMFk5SEC+vMo1SU06eil69+Jd01NR5/Garklj95NzSi/Ci7e2geTh70LC4Gan1telRjYgHd7znIiS3Bswo5JLfZ+173T+b7NVnuO9v+S0JpRtGKaTvab+5XNA5GDna4BoazjM7EalJv/SCDAGF5BRgIsc8O4pEaqZX01DDku69Ka2WPtkMDEg9p0y4uVCNltcAePoUOSp4LwdCRgEhv7GshnHfIi+nSUiCBsyKc1BW7g3qUA/zYMaRiA64j/dXSv/2Jec2FcU5bnP2/HzDEAi+lq5t5FtYvOeGx76XCdMplqDVPQVPqodEPqqkSox8xjqINb82HHbrCbQTmoPZ8Pe+7n9cBxC8nK+pzDxTsbsfEvmcmacOfILYMt/cKEKK+pU/ehxcO5o1Q+dLbAmdxcyKWq5HuQxkpGZkFz75fjJMXq9tEY/eiD2CuuB60KoI9a2lMs6E8ZLBJuvYoN/2wzEP/oSGmfKBeeGoNu7yioU0xeubsr1/x0qT3uZYz07yqnp2YIonTRlaOHaFSk/Q9mqKgkiOTt3h2bH1G3EUutInKBkCc0kyOko0pHgMQds1IXYrxQwwI//epglEvFvnsgnpT94vlfUoAKsDHZmkblnoddT3G/e3fUJYmbgu/rQFMsrDYB1d9niD8zAPDcL8JjzutEmfkq+FFgikTI99ngfcKNJGZr54LofaQ0dezuzJkMamEhryErxwyXeo4JiixH8cZ/wBxtyz+tdMZaVGvhcaLSi9RnNCLshSsAlAMNHneCvoSXIUsSygPpSWlnEf2G01SQdv
 yGaCGu7/
 4ucCnlmqmUQt3eFO+UKsz5/w1jyAyELoFSkQyXIdO6Tk7nIsmJs6haHBV7YT4CfjlgZTadppJRuOyS1PQczfiGK4yLwU1NQm6mRvX94USTRq//LAUItPxv8A6dQGhMZCvpBFIbKPr1XNsyvrexgU55ZRZNC8FS9U8Iq2rdythOGOKowWN57+/uBQ2SmiE+PH5GFGfAxU8N2CdwxzeW+35ZUBw7pYqVBmVs7g8sk5n3/UNyOhipNhGG/hE4eO9/xiW22T7w0FuCKBC8MjMV8fsjLNe6y76+z5yA8FFPltXVD14Mmk/RCtVrq5O7qHEvaf0Yr+0nN2OGv/xX/FGxZEVkaO/esXHa9iJ8NiqyWHxCqwfOrk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 05:29:34PM +0000, Usama Arif wrote:
> The scratch memory for kexec handover is used to bootstrap the
> kexec'ed kernel. Only the 1st 1MB is used as scratch, and its a
> hack to get around limitations with KHO. It is only needed when
> CONFIG_KEXEC_HANDOVER is enabled and only if it is a KHO boot
> (both checked by is_kho_boot). Add check to prevent marking a KHO
> scratch region unless needed.

I'm going to rewrite the changelog and queue this for upstream:

The scratch memory for kexec handover is used to bootstrap the kexec'ed
kernel and it is only needed when it is a KHO boot, i.e. a kexec boot with
handover data passed from the previous kernel.

Currently x86 marks the first megabyte of memory as KHO scratch even for
non-KHO boots if CONFIG_KEXEC_HANDOVER is enabled.

Add check to prevent marking a KHO scratch regions unless they are actually
needed.

> Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
> Reported-by: Vlad Poenaru <thevlad@meta.com>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  mm/memblock.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 8b13d5c28922a..913cf322eb89a 100644
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
> @@ -1126,8 +1126,10 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>   */
>  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> -	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> -				    MEMBLOCK_KHO_SCRATCH);
> +	if (is_kho_boot())
> +		return memblock_setclr_flag(&memblock.memory, base, size, 1,
> +					    MEMBLOCK_KHO_SCRATCH);
> +	return 0;
>  }
>  
>  /**
> @@ -1140,8 +1142,10 @@ __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>   */
>  __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> -	return memblock_setclr_flag(&memblock.memory, base, size, 0,
> -				    MEMBLOCK_KHO_SCRATCH);
> +	if (is_kho_boot())
> +		return memblock_setclr_flag(&memblock.memory, base, size, 0,
> +					    MEMBLOCK_KHO_SCRATCH);
> +	return 0;
>  }
>  
>  static bool should_skip_region(struct memblock_type *type,
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

