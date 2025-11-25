Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91037D0E6E6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86A66B0007; Tue, 25 Nov 2025 08:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E086B000C; Tue, 25 Nov 2025 08:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B076B008C; Tue, 25 Nov 2025 08:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5E656B0007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:48:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C48085E28
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:48:25 +0000 (UTC)
X-FDA: 84149258970.15.33B6402
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id E4E9B40013
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:48:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=KA6X2gA3;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764078503; a=rsa-sha256;
	cv=none;
	b=y/oqIWO/ZkxbTBzG9oO1DEnsqoIrR/sa2dtdMvF5BWdBimY0mdelXDSWBGGogqmQRzZ7e1
	6sZ+4r1FkRHRyQhDprPzLAh2Db8y0Bp8GzGb5XDAKhOI6HwI4XG3SJpzcMEiYr8Iv5w+Qp
	ufX6ATQSXIpBexez0x62iqqLA0U+wts=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=KA6X2gA3;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764078503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHz/4vbgS6sTT3o3BvksbAxXi7O2n+1XRJhlBaRAqSI=;
	b=kTojOnb3gLXK3RnlnlCY8QTqjAEW3OjXu4rn+nfuFW5YayCQMgKMGVGcZvM90MI35we71x
	iaU8lnlSbMAhN359Tvo11dkuxoQFLOhc43J7jOvRyG79YPgNALCVz1LgB8D20PEubXIfne
	6PHaq8JapoTKPSWnquaYZvhYxpQieg4=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 04C1640E016E;
	Tue, 25 Nov 2025 13:48:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kh811-bYK1OA; Tue, 25 Nov 2025 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764078493; bh=KHz/4vbgS6sTT3o3BvksbAxXi7O2n+1XRJhlBaRAqSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KA6X2gA3VhjJRhvRHvwBHXP/jtHRH7U2BPitygYsS0EWwts1kzF84jsAgZGzYlKff
	 S3e64yn40czjGuTnHbutythMrFYbXsq1cM/bhMiTZpCiNRZS5XXUklnyN8uU8w8CAT
	 tV9tB9BHNcNkVskOD1SrAD5T50bTvZpS8Ke932FLzQb7PmjgEHvavujKEvJAkYbsMq
	 tdFVCuO/paFvPo77JaQcbAQ3I68njbqAiZTAOjRxg7ykuY3f3thrI1QgKMyU+UzOYf
	 bzO85ajCOaAP6hMxPovIz9izPK2Oks5TpMM1DPnKLvs1eljAloIO7CHV2zrTT6H+a1
	 pH2DnoynIS8T4UJwArTcaqw1UGy3Sl9qZptloMWZqMmbXOrpPC7IvmG6eGLTAQDAKB
	 +e4pCFypfJFHPhyaVaWPKQSEYbU3OOZIhub7uHabqTPHgLCkya6FuXvUew2oTi4ob/
	 Tc1gJ/EgZ13SgpXbbJXPBSXBDtxrWjsuzv0VcvSPxPi1PwbDtNM6Owe5yKKCgedh83
	 AsFLvSVR5nzOqH0uDU4gCYqpkNzftJ2aNxFMSo4dz1jGXJrmGKFH2Fv/0eOhYSCRAL
	 DafO/QK3DhY/v15yExEy0usZ/koz20Iut3v1vHLifCxrJhypVJToV5//v/UqRE779g
	 nNdKP4+uzSiI6qG/Mfb/1IeM=
Received: from zn.tnic (p57969402.dip0.t-ipconnect.de [87.150.148.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 4C30040E015B;
	Tue, 25 Nov 2025 13:47:56 +0000 (UTC)
Date: Tue, 25 Nov 2025 14:47:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, david@kernel.org,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v9 4/7] x86/mm: Simplify clear_page_*
Message-ID: <20251125134755.GMaSWzi-_vZwdkFcdp@fat_crate.local>
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-5-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251121202352.494700-5-ankur.a.arora@oracle.com>
X-Rspamd-Queue-Id: E4E9B40013
X-Rspamd-Server: rspam07
X-Stat-Signature: jqq9mso6yp1occcezz4s4mqdh3i1ni8y
X-Rspam-User: 
X-HE-Tag: 1764078502-774717
X-HE-Meta: U2FsdGVkX1/+I4qgTW12GvOC5ywhXXl+R3LDpo2VNDKE+V8sfUOyWkzQCR5muAqpbAjfA7hkzWwK1HokDG4DZiFm6liFXn32OJ7f/D9Ez+F5eEAVfQ1CFROBd2le5cyLvoV4E/6Pr5zc9fGZVOa9XbF1iFv8VeZW8Otj5aoohp/mkDFy4jpumJGYGIwGEmpynRqYSXTw5mYdrz46ViAK3rD02frDxjDMbjC22MzFDho9k9pvWL+aHmYYQdxDGXKsq+5RBV2n0jrUOh/JXT/cdj/jWvu8xZsMAXwfchBvMREmZnfbYvkWRJ6qXJZhqJjSymD7gfrel6oOfpjKYJgSYopul+/g1FjexQhRf5rzcwfzbq8H4ba8RHwKVyaNlwh3v3VJ/0VHBbtCnz5mi8Zzzz+xTaEh2NmwT1AY7mL08bbaEC4jcn4j2gl80NWx+8UkGg16AM395saDda+1Xhp4Qjf54TgBUFt5wTEpwosAXEChQMdUpaSZ4rW7wEiEda/UszmjmBbAGjTVQYAVZMAJ6bEAhNhHhFvbR1oZHqAop0NnwrY7j06TPwyvqXnEZNBYu1m1V/f6dDmrnJ5HJon+xu44zT1WU6agYgzXZ+poAD8OsaK0a80q5XI0b5b5fxmnp3d7lNcbC4ZqG09nKDf0Rf0oZ6ASx3T6/nJE/hpQctgrKSdJfbm415YmP8BB7mQEWdinrgiLaqbR6RyzM5LoAGkTJDel9E/xrgA7YAq/SRZLlgIuXT9frbZ9ikx3uYdi9Q20M205MD3lcofi4uef1ovdgap32veGYPLgrbQuD8G3KBK8w8OGHBz5ge2zXs13rXZ/YOweHloRE2Y8Unbmy52euZpzqfg5ncO/pAYM4gBoksvUHc/J9IUK9ihL1/MhWQAYnFRnhUQphmVAs6NK0Y6vapmqU0w/tLisrNOrfrU9DvWU7UiT0odTFoRhQY5/aCWLzOwPVnOph0LutEk
 Ize4Dw5u
 HvRbIDi5lWcNqS1b9+/Dc+usgdEwmZ/R27vlFCnUTSbj0RgfTVbUB+hc2elhCmnzLq+g40+a9JPydyTM5gNqpS/rKqHzvj8H30bievhFatAZczKYKjcOsEKLv2i12O2VkqNQeNh7RHjvt1s4DiD+KLaJHvT52jK3yQ3/VZGRSz4TDqBzKdfloQfUVRsmLmMsAoAc3HMXXviylYHHjXVt+YFLP7yiFhmjW3kBRwWpu//Rm+dHyfcbsDZidhYdPhCumYsjlXhfNYQQLoz5Lfwp8PVAsJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 12:23:49PM -0800, Ankur Arora wrote:
> +/**
> + * clear_page() - clear a page using a kernel virtual address.
> + * @addr: address of kernel page
> + *
> + * Switch between three implementations of page clearing based on CPU
> + * capabilities:
> + *
> + *  - __clear_pages_unrolled(): the oldest, slowest and universally
> + *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
> + *    to write a 64-byte cacheline in each loop iteration.
> + *
> + *  - "REP; STOSQ": really old CPUs had crummy REP implementations.
> + *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
> + *    trusted. The instruction writes 8-byte per REP iteration but
> + *    CPUs can internally batch these together and do larger writes.
> + *
> + *  - "REP; STOSB": CPUs that enumerate 'ERMS' have an improved STOS
> + *    implementation that is less picky about alignment and where
> + *    STOSB (1-byte at a time) is actually faster than STOSQ (8-bytes
> + *    at a time.)

Please put here in BIG RED LETTERS something along the lines of:

"The inline asm has a CALL instruction and usually that is a no-no due to the
compiler not knowing that there's a CALL inside the asm and thus won't track
callee-clobbered registers but in this case, all the callee clobbereds by
__clear_pages_unrolled() are part of the inline asm register specification so
that is fine.

Just don't assume that you can call *any* function from inside asm due to the
above."

> + *
> + * Does absolutely no exception handling.
> + */
> +static inline void clear_page(void *addr)
>  {
> +	u64 len = PAGE_SIZE;
>  	/*
>  	 * Clean up KMSAN metadata for the page being cleared. The assembly call
> -	 * below clobbers @page, so we perform unpoisoning before it.
> +	 * below clobbers @addr, so we perform unpoisoning before it.

s/we //

>  	 */
> -	kmsan_unpoison_memory(page, PAGE_SIZE);
> -	alternative_call_2(clear_page_orig,
> -			   clear_page_rep, X86_FEATURE_REP_GOOD,
> -			   clear_page_erms, X86_FEATURE_ERMS,
> -			   "=D" (page),
> -			   "D" (page),
> -			   "cc", "memory", "rax", "rcx");
> +	kmsan_unpoison_memory(addr, len);
> +	asm volatile(ALTERNATIVE_2("call __clear_pages_unrolled",
> +				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
> +				   "rep stosb", X86_FEATURE_ERMS)
> +			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
> +			: "a" (0)
> +			: "cc", "memory");
>  }

With that:

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

