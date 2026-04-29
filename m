Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E22CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7670E6B0093; Wed, 29 Apr 2026 09:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E506B009B; Wed, 29 Apr 2026 09:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C9F6B00A1; Wed, 29 Apr 2026 09:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB636B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:51:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03B981C0198
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:51:47 +0000 (UTC)
X-FDA: 84711731496.28.BEA3FCF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 02018180010
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:51:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gX6jMWWv;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqk/vbnimW0wuDYnJIfvubH6gxgbLhYzeZKE1huaELw=;
	b=0acJGFkc9CwE5xp2lo8U+2fjbvxnQzs5eooszFE4WVoe+t7RkRPm1aGg5tsSECqbHIbZK4
	fyHY/gkPg8jbazK7w9Y8K0ZhJLYoSe8DBRuTLfKN4sm9AgBVbU+M78Acabf5NHsusjvyM5
	F0EvsnVcWk8BiMcAoRsypi4rKRuJDt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470706; a=rsa-sha256;
	cv=none;
	b=Qi7rc0YiYVJrQeTUxNXzsiQOyfmZq2dHJPGtXoLSOludROHhgwFJgRbYpG7IauwXrp4V+Y
	RyipcFlfN1F91QhMDEuj7Yeg/fYAZfDzgXnCvj6018JNa6CsAAqlwGh5A6KEOH8B39YOw0
	DjTxERUbuqWsnIqHa1gmK3226MsmTcw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gX6jMWWv;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45D0E2574;
	Wed, 29 Apr 2026 06:51:39 -0700 (PDT)
Received: from [10.57.62.76] (unknown [10.57.62.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88EC53F62B;
	Wed, 29 Apr 2026 06:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777470704; bh=9ELD/DjcFqzDnlav/KpHjVLh1+VYuwo61V/4bESQjnU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gX6jMWWvzRfAvmOAyHfw3oN8bG5OkDuYdKN3FuWWM6nhaa2QUnNyeU/dyUa3NlDBi
	 VXs6MpNaq7hopQBIK1wh64NZPzPhrdUFDqsIC1BKYJuqTwtkmHUbCfAApjLUnpBUHb
	 gwlcI8mEEm00HYzB+UqwukBUQ6gsicOZH89qCdnE=
Message-ID: <8a315ca2-3754-4a66-990e-55b85191aa6e@arm.com>
Date: Wed, 29 Apr 2026 12:54:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/15] arm64: mm: Don't abuse memblock NOMAP to check
 for overlaps
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-28-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-28-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02018180010
X-Stat-Signature: 8k86d8kuh9tbxwj7caxue5ja1kggjr3u
X-Rspam-User: 
X-HE-Tag: 1777470705-120666
X-HE-Meta: U2FsdGVkX1+t2fYb6fP7m1GYTHWUlD/dPUyTUpE2hBaZfgsOXdURM0du/H5/jZUUT1URrgIFcGwPgYpkBzQcwt+iI9td+r56NkWVXosVVBJFQXbA1Xbk0MbGlSDWfC3Be+C8EjIYH4TuFd/qIzJQLIbhwJ9my/Ju2JxDwmeZuhhZ0yjBFmPGBpOP2+xhXJDf/ZvmRFwsYiRsKnYU65al/EWuGVaokPjT2FD3LmUo8z29sQZOpx4aEoqZ9d/2aM2wGvAJG2dOktm5RohyuR6tn9TmCPvBlm6qGU9vjM7nX76L8VV+iJwbx2LWSf7MbXunXy7uOoyL/H2xkaUPaX3r9EWUPtwX7nmPbzc4dQ75B/zO8hvfZH8R4Ubc2v9Asb2XH3rgwipGFmvfSUdV4vTnD44vPzSQ3VoMB4nwE8k7SmM7MgrAyZk9zOSo+pmC2W26ry08NN44gfy7bmNi+F2/5GdFYUGkAi1BtU8UYbdDLlOrvltELUKIajn/iaYU7xgm7Z9LHH9twnnea8H4T/NYn0xgqDyoCqp0opil1KfDZHUsx160/1gvsYA657v9K+s68cvM3/xviLUhq/V+AUxFlF3Yr1yTZiaRu2S3DMmtN60/FuudFs2Mk2U5bLYuIZDx63G4+w35YGqqNNqKmZ+8VBpL3/uFhizEoKNLtRwGIduTVt2LtNyHXc3ZkXEFwHiNmQ4vG+nuBahjvMLBpvdy0MC6gPEer3WBgD0eU/kiyOmb4hO6OyEp3Qlw4mfXopr6E/vX3RfCmHeqHepcVDm3qwUEosQ8KAlb+U69Ok67aOFuUUK+cqfkeBolpT+1BiMfFgt4FhHcJH2nOlOOH47T70u1b8KtflKIQexoMlYgzDoFYVZ9A7zdzSwSZNfUdNk0dYyo9nhQnaZSN0/vZBaYmXEdPSPVpvQC1brUARPlx3sRqXDTPMjydZPO2+w72a4f0SrZj+LUjLIR1/dTx83
 HdejrbFp
 ivNKtDGzSm/sUvmuv7Axk+mAUQbpKZlgdWp1o9qUiAPF+NWd1VA1obzmJcGDXKyjp2o83G26EjnlQ0SyBdSgif6KSfV60O6EOtCiVrxwKvv4Gp2j+tbHvUNp/6Wy06ExTF2cxTOLt5W3f2tysdkt+ctlxvL7SGllGv1Ll+h6TQZLB6nwl/00jem+sh+/KdXrAEkbGlLT1ulv+O5j0Qti02I6OpPmtQth7XHat8nr50S8huTx+JuV/i8G1frTdQ3ay8iy6dPHVAsiMv9YiDy890vo6/m/R4IuNj0qR+UJqWytNt+h0YN8aubxY4PfScoC7TXbnLJYrdr6YbYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Now that the DRAM mapping routines respect existing table mappings and
> contiguous block and page mappings, it is no longer needed to fiddle
> with the memblock tables to set and clear the NOMAP attribute in order
> to omit text and rodata when creating the linear map.
>
> Instead, map the kernel text and rodata alias first with the desired
> attributes, so that they will not be remapped later with different
> attributes when mapping the memblocks.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/mm/mmu.c | 24 +++++++-------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 5e2348b15783..1a4b4337d29a 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1148,12 +1148,15 @@ static void __init map_mem(void)
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
> +	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),

Is it now necessary for that mapping to be tagged? If so, it should
probably be called out in the commit message.

- Kevin

> +		       flags);
>  
>  	/* map all the memory banks */
>  	for_each_mem_range(i, &start, &end) {
> @@ -1165,17 +1168,6 @@ static void __init map_mem(void)
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

