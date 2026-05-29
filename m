Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F7CCD6E4F
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0F96B0005; Fri, 29 May 2026 04:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB82D6B0088; Fri, 29 May 2026 04:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5BD6B008A; Fri, 29 May 2026 04:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C42656B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:28:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A21B407C8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:28:41 +0000 (UTC)
X-FDA: 84819781242.23.365093A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C4E440007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:28:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XYY9kB9G;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780043319; a=rsa-sha256;
	cv=none;
	b=U1RaA9uiUHHO8CgzJmCJpBhaYXSK0/oNtXetib3nVyEjWY86TP+geuy+/PMgllmIwLzsG/
	YDOlN/5RArBRzXFVzyaQk6lwl6XR+N+AP4NPx+PBM5dNuSq+VExHmYcUJCIsbO7Rh8oY+/
	dxY5gkvFmXTLvNd7IhC4QEzRbghFgmM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XYY9kB9G;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780043319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCFSp7C/E6gmxsu0aTPyzNbuRDQ/RBTaLjuQipPAzPo=;
	b=s88V+iYzSagEchke9NMPx8BWNU+0n1uFUc+bZKcOqQR8rir9HbrnVdT7YN8dntTPiJ5FCn
	T736khAteAjxQzOBx78x5dh9cgjmeLWXCWwctDadivfcc4ehk/SjMcMpFJTcj9X1hpBh0P
	7gUO+ztRq0tTK+d2y6vaEzBy0yYJpaA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A19FE201B;
	Fri, 29 May 2026 01:28:33 -0700 (PDT)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51F163F632;
	Fri, 29 May 2026 01:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780043318; bh=HxDE/v275kzieWm+smiZqa4yjNgD7FuY1p40zCPFJh8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XYY9kB9GX0DEWsQN+Oj7ZxBosVWDp3/KI3Y5O5DSe8+4geNHXgkk8LulhMaD4MsWA
	 Nccb5VsdP0UL8JIjPxBgRordOXz3Gl/86u7LQqEBCbv412ByXijVU4uD+broFZMSHy
	 cGpZhrwOcstLiYiLOi2GfzJ7aoGgzXegNpL7uRks=
Message-ID: <87ed7239-1622-4cb3-af04-2390f2b549e3@arm.com>
Date: Fri, 29 May 2026 10:28:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/15] arm64: mm: Don't abuse memblock NOMAP to check
 for overlaps
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-27-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260526175846.2694125-27-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C4E440007
X-Rspamd-Server: rspam03
X-Stat-Signature: 4pwxyazrdxfonpynj6y3t6c717e7nnb4
X-HE-Tag: 1780043319-417337
X-HE-Meta: U2FsdGVkX19wxx7mzQ390ikZ5vYNEeZSKhsDpAqp3f5ccb8nM/vY9J5l5DfLxHwfu77L4M8i9IbQgaaVVVrncOc7oROTnRT+NQekpx2WwkPxgustb6js4NccuDI34mLUPaQ33mGZgWBpbU95v52IbcSCb37GJisIkqPrGtkD6Uoc8H874ItdIjMtvBMBB1Ivtmm2/whUJ7gmp3rETdEssvLrQy2TO/d2V87xS7F1PMrBBx9MftRuClpLXah6nSqzaIqjwSEQX5Gfw5VGs9+3CVZKhCbsZ+DovYjJRIg9DOzw2kgjVyXtWhPip03BT8sRhwqW1+3jXn8CfrhdLkpsAKSRWyQGUhFjwRkuUTCYYilk5ZAiuVhO1/6tkpVze+0r4Qd9E35HQx93eLcmCD72tjWZqNFgyZXDU/Dq/9Tc5Pms9rwwsyxIzKxpByi2LN8pOGT6OqFMwxvvG9mLMa8tqRfv2mmHhkBlQaK1dJtVpD5N8NZ6HPvl1EWFUvcIzV2aUaVqmp47mwulElTviF6p8GachulH+0i3lPrHWz7oVqbsgwKur+5LvEqJX7rRgIDCrIn+4BO9AC9t9kjrnuK/Q2uIvx0eBlUwxEmn6v2JCZPRa1nXB8kOQFnj0Bv3HK1DLrlIamxZqcQ5IAQHzblWHwBvR6IcFAovWq6iJsvN8kZOqmY+kWumWhEBNrt1yIWPEIzTpl6LapFDSA8lrjxmvbrco5TKnrD0fQmvV0pKT/BmHPGoYvIe+daGsNs/fSUZvLE7knldqCRPrPSkDq1KtTFAXbY2/OP0KDbpdf/qMRWJAGP0TKsWXZ8riF4oANumzTmAeYxIkHNDbfRHL5MKf9FsqIwf9O1p+1/1rZrT8Q1jGxc5UyADHfmGN2vK3FKFsZPIsv7wYO5VHLnSylzqrPqK2dSWDzSL/ADSwfR39po0flUtc8vkpwV97kRllr8ee4HEBb20GP0br5Gkod/
 WN3tAttL
 I8LfgN5c0/II0HIVGPBMUpc2kBxiNAhYfMYUqPnR1ZxKPqSghkEDF89qy0ErXu35YhetBmhIlZ3MX7foOEfB6MhXicpeNv3KWIjiNaoomxmuFndMMMJj3JgKw0kQhreeJV0qr7QaLLvTdbCY+bPi3/dht7Lc+dD2DFE1klF2BHhsB3kEWy/yUd/mUNBSrVfaZ42MBnm9Ow0cn3vmeWTyB4IqGmKKPaiLiwjqm+7/zmYAx6fAxwZwHHeFqkAgm/DWFaIL4xY35THFHYyz56NvoSgL+f8cQr0RLOWhn2EspfjCdxSx4UHKnh1vnSzZn3G5Zbal88OuBFnS49aE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 19:58, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Now that the linear region mapping routines respect existing table
> mappings and contiguous block and page mappings, it is no longer needed
> to fiddle with the memblock tables to set and clear the NOMAP attribute
> in order to omit text and rodata when creating the linear map.
>
> Instead, map the kernel text and rodata alias first with the desired
> initial attributes and granularity, so that the loop iterating over the
> memblocks will not remap it in a manner that prevents it from being
> remapped with updated attributes later.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/mm/mmu.c | 23 ++++++--------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 04cc579c7a15..b20c76b8381d 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1164,12 +1164,14 @@ static void __init map_mem(void)
>  		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>  
>  	/*
> -	 * Take care not to create a writable alias for the
> -	 * read-only text and rodata sections of the kernel image.
> -	 * So temporarily mark them as NOMAP to skip mappings in
> -	 * the following for-loop
> +	 * Map the linear alias of the [_text, __init_begin) interval
> +	 * as non-executable now, and remove the write permission in
> +	 * mark_linear_text_alias_ro() above (which will be called after
> +	 * alternative patching has completed). This makes the contents
> +	 * of the region accessible to subsystems such as hibernate,
> +	 * but protects it from inadvertent modification or execution.
>  	 */
> -	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
> +	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, flags);

Isn't the loop going to remap the range as pgprot_tagged(PAGE_KERNEL)?
Maybe better to use that here as well just to make it look more consistent.

If my understanding is correct, we should also amend the comment to
avoid implying that the permissions we're passing to __map_memblock()
here matter - the linear alias is going to be non-executable regardless
because of the loop below mapping everything RW.

- Kevin

>  
>  	/* map all the memory banks */
>  	for_each_mem_range(i, &start, &end) {
> @@ -1181,17 +1183,6 @@ static void __init map_mem(void)
>  		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
>  			       flags);
>  	}
> -
> -	/*
> -	 * Map the linear alias of the [_text, __init_begin) interval
> -	 * as non-executable now, and remove the write permission in
> -	 * mark_linear_text_alias_ro() below (which will be called after
> -	 * alternative patching has completed). This makes the contents
> -	 * of the region accessible to subsystems such as hibernate,
> -	 * but protects it from inadvertent modification or execution.
> -	 */
> -	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, 0);
> -	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
>  }
>  
>  void mark_rodata_ro(void)

