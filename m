Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1EA2CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 10:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6FD6B0317; Mon,  1 Jun 2026 06:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADE76B0319; Mon,  1 Jun 2026 06:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB3F6B031A; Mon,  1 Jun 2026 06:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F38596B0317
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:43:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A2BE161D75
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:43:22 +0000 (UTC)
X-FDA: 84831007044.17.65D2586
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id BA79F16000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:43:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F8Byp1c2;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780310600; a=rsa-sha256;
	cv=none;
	b=yiO9KQ8Nl/6RYSX6H58EKiy+WfZ1kHs+LomoQ08T3LXkzZzbudUvd0zleL0yXGOm/R488Q
	zfjm0X+jE/1KnxWfnLMHLrZGhPgB/vpONj9cL3/ctrmr1YD5hFtnOJDZn3g0V2EKXFxRny
	3qkgcFa85NZjtlv4KoKA5OUw7789sAo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F8Byp1c2;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780310600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfHfXoVYENkxwmj3NCbefgONe/D1FVurRR4OnxrKFd8=;
	b=XITapHpdvPuhicmBLIUQImwjBsTvTwmLb7lyo75Veu7FK/xC2QA+yAH5xmRQJ3KqkRhbf3
	cQG9MWM+vTiHM+tnDK0nBVkdCVrOyc+jE1F+2NdYFMM1gcgmPxNv1sdVL1b78bpzdWq69k
	Uy3xAcL3fc0zE9NlUHa/Xpfk/qEGGAU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FA3F2696;
	Mon,  1 Jun 2026 03:43:14 -0700 (PDT)
Received: from [10.57.94.8] (unknown [10.57.94.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5FEA3F905;
	Mon,  1 Jun 2026 03:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780310599; bh=M9JAdG5DV/7YdqUDPO7phO8QpaY+0Cm/rOxjWCg5rg4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F8Byp1c2fESYbQpuqvr4AlWD6wXTjIviMOELOHMH97zUW2cYZrKpsdEn1LfcD6kXz
	 UJIy+EgpBQi+xkE4miNGCmjzdHMfaUipsb7TkmxOblXjY1f60mslkBJ2kiKuhbuSA2
	 1yYR+XdZ5mwIByNNWcqVdJfgqcvs2DD6HSpBSnVM=
Message-ID: <c0eb50f2-b0da-4d5e-9a20-09c2391cd3f9@arm.com>
Date: Mon, 1 Jun 2026 12:43:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/15] arm64: mm: Don't abuse memblock NOMAP to check
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
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-27-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260529150150.1670604-27-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA79F16000D
X-Stat-Signature: ec44dcqapaardyzwanse9fpz6btxxn15
X-HE-Tag: 1780310600-623864
X-HE-Meta: U2FsdGVkX18+MAGLuy8HgXax9q826WtDfgfmZg/PaDb6GAVS7GRC04aXlpg+YB7/rgE0+tAHSIazXydsgw3f7CupwJdR/ozaLN6Yh7EkLDeeD21A2zBR6CdoxM7RdgzxiiI/QJFTfXZrVnaM0onTF+Yox9T6CZws5zH4VzVZDUI8234B96RgA0Wg9qsla7vGQvchpjQwDwj16w9qvYGzWyMlk84mZvainuQN8Fy+fScWq/Op7Um+LYH//WmsQmwtrwpcJqHX+x1/aHb/eeCwcl2hhZoN6hoq4KFpNJ+Pav08yYQIfPiI/eVj/9ZE4VrDB4nPKMetDEnxFafGT0GFync3VSCyJ128WP5UwGxScPH5RPU6ykX7b2LjUpdpHH9dVGe6DKujfmYEs5g8bMeLyzoUS1+B1/4268qaY6sx87HJ5XHsum+wfjHRlxaShTc3WQhU+JhfjVEt6tSQcQkKwfFpYsaPK96vQHEiVlQjMCiybZLNXej1GHFu8h/So6UkPs0QxXNLFt2BjA05okQAkzczmY7beQ2sNntBDnpIs+Zz4zBEBX/KxOxrxy8YVu6Hf4E8lWqlLldndLDSp6k/TaGiOzOjW80A9QHuGcSLJ/17nSHhD+VcY7Opzbj9n/shv4HLbtM3XcC8VxQbvscZHezmCS/KAhNDmYdtWqLNWOKdU59mdxtKEUImZMG0dLV4w3qauXM7v0o8N5UPl117PDFitm9h2I5WBHY8loeqcQK4aaYmBJdS7Hlm0S3OYtoiB8qT+3c/S90RaX817wzIkBNcQL1Hg1k5/TNop0OJI6iCqgzvXMlCYGc2jLcSz9LUvbEmzt2WbvgLZNZDrNKa0s2hRlu688pYDYx2KHviVHcAyFMH+kw7L/Gu2NBa9zJetZKnyEunUJEIGpykVhJ7KYT0aALKlUpUlh9UGixrxJu4s6eXwv5PM080j8O1dS2HnUmEfhoNbzxENkkrKav
 08ChB2Z/
 TX5LAfRRKFmVwWhCr00+CtKfXV5G7vv+FUsTb6aNeGAVNmoKRnMQTTAK4MYwDTzNNfaRxhGR3na9c3TpRyqGVDR1XlnVrY7Iovcoj7GVYwRBjMFdKLQLhn6BJo4U27kKXffCrRRAYHLwGg/QHbDfCR/XhEf60XWdAKU33zK63D8wROwhDvqgqAy7yPAI+aO9TPXl2EEtScJfaLcBNIajfgbIGn/mIzmF0oi3R+PYoGQTvTOV4fQpSIagrXHhrnLEyzTQxhBlUY1KW/+1uNpu9ELUBqKC3N3VEwx+5i30efEuRBLWBaM1lAtjGA4igUhGGBrVRVBqcO4yHGEfgcnj/K18U34ZuvVzOIhja6eZ0SSsdbBX5e+ARLDqazG0nsIlpUA8mYqlT3AEG9rQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/05/2026 17:02, Ard Biesheuvel wrote:
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

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  arch/arm64/mm/mmu.c | 26 ++++++++------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 971996e46fd1..dcfca5667e5c 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1164,12 +1164,17 @@ static void __init map_mem(void)
>  		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>  
>  	/*
> -	 * Take care not to create a writable alias for the
> -	 * read-only text and rodata sections of the kernel image.
> -	 * So temporarily mark them as NOMAP to skip mappings in
> -	 * the following for-loop
> +	 * Map the linear alias of the [_text, __init_begin) interval first
> +	 * so that its write permissions can be removed later without the need
> +	 * to split any block mappings created by the loop below.
> +	 *
> +	 * Write permissions are needed for alternatives patching, and will be
> +	 * removed later by mark_linear_text_alias_ro() above. This makes the
> +	 * contents of the region accessible to subsystems such as hibernate,
> +	 * but protects it from inadvertent modification or execution.
>  	 */
> -	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
> +	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
> +		       flags);
>  
>  	/* map all the memory banks */
>  	for_each_mem_range(i, &start, &end) {
> @@ -1181,17 +1186,6 @@ static void __init map_mem(void)
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

