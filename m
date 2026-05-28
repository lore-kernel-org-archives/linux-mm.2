Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2CA5CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 05:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F4C6B0088; Thu, 28 May 2026 01:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FB66B008A; Thu, 28 May 2026 01:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D557C6B008C; Thu, 28 May 2026 01:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C607F6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 01:46:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75C0B1C0663
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:46:16 +0000 (UTC)
X-FDA: 84815743152.18.1FB74D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D29E4100003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:46:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USTJwMyG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779947174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95SOoqGn6jyE0UfkDK15/NBpH9CmgAfhjJteJqSZdCE=;
	b=tFxzwFONMhczQuszqSovO/LDrxakK003oS1f7jt1PSDrH9H1WmvjSTQB6lnuxBKX7KKDPJ
	z9XFLcBJ4RVF1RaMaXmoFg3J5TDFpogO1AmqQ0HLhVscXZrz9TSPrxpLtb9fN6rvjH3zjY
	ZXAiVApuUzc20L/vM0NL4U/OyUdRBcI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USTJwMyG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779947174; a=rsa-sha256;
	cv=none;
	b=ZBLMmEtILO0Gs39e1Suzu/CzB2e1/MOdkLJr0UNkwK4AtDnhYPzqoNxgWXTk1EgaJcxqHA
	u2UKXDO0WjbXUPjV8/93vUpEjhSKOn0VW7AKNpcAg3eycaBwbl+RYoskHEwQtccuPfLfS0
	AM5+mHyJ3mXWE9HXRS6vQAjv+UxLgvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3794C407A8;
	Thu, 28 May 2026 05:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA4C1F000E9;
	Thu, 28 May 2026 05:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779947174;
	bh=95SOoqGn6jyE0UfkDK15/NBpH9CmgAfhjJteJqSZdCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=USTJwMyGvWXoMbf/S3Hkuw/RAJZlgHz1wf6Rv3/jmc2THf0cyKGDOtGKt9FmAlIO2
	 bEzFbeCt0rnDn/8rlPAlmhLya/lie2fE7s0Ml45wXgkLiE48k3nYrM5tUD//wtZoUe
	 Or1W+w7erYiqub4kaHP0qkQb3RECfdmHprx1Vj3YKxor8X2FJMM9b4kv+OtRUUTLhY
	 dmdFE+f1EYTQmxHd5kFze5j7kVMcZ/PDIzwqvicbpyNpYnweMPLgb8vUH92a7Ecsu/
	 AQ6G7A7Ro/8u63LF4IMK8XJnfB3/MXr6DrdO23eJ8HfBnbe96tH4zBoN13i1Sk2LFH
	 iU1t+RcUX53pg==
Date: Thu, 28 May 2026 08:46:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Liz Prucka <lizprucka@google.com>,
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: Re: [PATCH v6 13/15] sh: cast away constness from the zero page when
 flushing it from the cache
Message-ID: <ahfWnLIwZXJvbvNg@kernel.org>
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-30-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526175846.2694125-30-ardb+git@google.com>
X-Stat-Signature: 4p7qzqijdfq4jfujdmdkwckzrtc7traz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D29E4100003
X-Rspam-User: 
X-HE-Tag: 1779947174-884381
X-HE-Meta: U2FsdGVkX19n5WZAb8zSET/lHF8DyKk1t23WLeHNIIahrQ8ejtdGIt956eSPvVzmo6Bi3DljN26PCxQ2s0uEtJGYMiGU9UISNc8WiAXkw1iVQoRrIo/o9a08ZblRRujbeYq/cLLu2/wyHkaEHyD/xnaUf51af2oAn/ztPBsNMKGNTJY4sNJ2kkdt5S1zbvFWIsg4RcDvzZZWw7ULZAd0m0DYVW+riNpRmCG7m+M3DlfiKyV7MqS22jh4mWdmXCYPZLk5o6YN9NtuuBZ+eDJmCxV6o/U7jDhGfq5PmSl9cR0WZdWIaBVMDqxL09hhiXG21wbkxxUBuTSXD0Z+BPlTDb7sNAuq7eOb+CpJ8CE2hUHO5bozxYiVLxZhh9WVgYW7caa+MFq+Ktu4GSUsMhDkXfiiCigafzOxJ8A2ndcE3Lok2L2t3sDC8N6kDDYRi6F4jWaezF9wNZmjbZpVZ2hkwUos6TQPNsju4M/jL+e+4KbTtWfAINPDF1d9LkFDY+a85tuVjaRLk1q6Rvx131aKoeCl3/L7cBq3n/UV1FLwOkgC20u102ER0lInk1dLkU3sR5MSFgkEfti/vh3jQa2MNh+kqXoFb43LGDv/FpRCyxowPgtTrQlN65CfgBcmU3aOETkfAFqHxEkru6NUSynmNFmFsj6XTR9maranIw6TugdRAJqxAqUJB8ZY23gyIfR+QDHJEa2yt0r/L2+BFleb/KOCLAl7lg410VtVDdU7B/qBlwkbyvekYGCCMB2Idw1KHWnYE8AuRpT3u2GDidaVWQ7MrD62GiqWXaJxBhMb5BEuG878RYgFtSj1KQbNsKInfG+bam0J6czTWdJkZeSn+AOTPefm0nUpZ58HoeeCD890QosyI9ATFL0+2caZ7UEMuU75lvqeQmCFoxmuAhIuhutdHPGWl9kc2QUbSSjSdDuDdMxQF74QIUyEzHNBJUVNnBOwlq6XOQSZfI8fL9F
 Dm1dlRkA
 trcvDWGfY3/UNdzSLg1/tSrNvo03IYrDEJ9A1GXIgaEjyfczMat49EKdKbrj58BIvgeP/LQP06cFp7dKiucg1k3ycSa0l++bs/5cjWnNk7eAT7+iWYFER1qDFthZSB/uR86FklA/R0vH4TrZeerxOwyZvxhTgZE5f3wjYDA0iAenn3wuF0drheT+6OYZC0L3JKMZKDNagqQK5J0UU6va7tdHvW7vVpvnUbHncHSkPP4FXQwnHUFQgRJ8Vt3y3b7g86T90haega5Mailx0xPtUrweywxkz6pa8ITrH0FaBK/TG85ifL0o79XGhzMrM07LKfvCFqkH5AwUyA3/djioiGX6r8RmmVHd5d4sCFuptFc+c2HeZoHHYcpSRN7vTUZDmLXWOxdmRIZEoN1eEKPCIJa3Z5KDzxEKEBXJP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 07:59:00PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> SH performs cache maintenance on the zero page during boot, presumably
> to ensure that any clearing of BSS that has occurred at startup is
> visible to other CPUs and DMA devices.

It flushes the cache there because before 6215d9f4470f ("arch, mm:
consolidate empty_zero_page") empty_zero_page used was for boot parameters
at the very early boot.

I removed memset(empty_zero_page, 0, PAGE_SIZE) that was a line above but
missed the cache flush. 

This whole "clear zero-page" can be removed IMO.
 
> The __flush_wback_region() function takes a void* argument, which is
> conceptually sound, but given that empty_zero_page[] must never be
> modified, it is being repainted as const, making it incompatible with a
> void* formal parameter.
> 
> Given the above, and the fact that __flush_wback_region() is in fact a
> function pointer variable with multiple implementations, take the easy
> way out, and cast away the constness in this particular invocation.
> 
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/sh/mm/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
> index 4e40d5e96be9..acbb481cdbfe 100644
> --- a/arch/sh/mm/init.c
> +++ b/arch/sh/mm/init.c
> @@ -332,7 +332,7 @@ void __init mem_init(void)
>  	cpu_cache_init();
>  
>  	/* clear the zero-page */
> -	__flush_wback_region(empty_zero_page, PAGE_SIZE);
> +	__flush_wback_region((void *)empty_zero_page, PAGE_SIZE);
>  
>  	vsyscall_init();
>  
> -- 
> 2.54.0.794.g4f17f83d09-goog
> 

-- 
Sincerely yours,
Mike.

