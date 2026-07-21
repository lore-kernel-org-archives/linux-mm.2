Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13527C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F436B0092; Tue, 21 Jul 2026 11:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020676B0096; Tue, 21 Jul 2026 11:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78926B009B; Tue, 21 Jul 2026 11:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C11AC6B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:11:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52DFFA01CF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:11:37 +0000 (UTC)
X-FDA: 85013123034.21.A62C160
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9782F1C0010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:11:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AWfmGqL8;
	spf=pass (imf18.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784646695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlmkIlI/0ZYha/er7EZ84MmkZCiwZXbwdDI7LTwrjs0=;
	b=pgBS8fOi3loDd1LAOa09KZA5CKBiiI9j9/5xOtHMdKCUM1Bc8DMww89w7KGzOD5gJsyrE2
	HNMaSw1rt0rvi5jr+JkgZcw4sxrSNyQdJXzcqjQpW0ifJ14WAFDT+XUPz+v69Lt8UGgpKc
	hWoSA0ad99UD9uUOA5zZLUUVWB1f49E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784646695;
	b=vSrPdF/u2Kjo1UMQJ39My15GY+cnYPhJyojQ5AMVlbRq2WHcQ3LiFgtBMMhABoIAN6euCA
	xeAH3XwmN7ijJIlDuhWimcXA/L2kpCUhgCtRmS1Rv24IHdZ4RoYEz4wnfz9qa2siYOFlq8
	zyr5cj6uHldP9iN3T+fKQEtN1IuGVaw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AWfmGqL8;
	spf=pass (imf18.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5DBA43C9E;
	Tue, 21 Jul 2026 15:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CE71F00A3A;
	Tue, 21 Jul 2026 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784646694;
	bh=XlmkIlI/0ZYha/er7EZ84MmkZCiwZXbwdDI7LTwrjs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AWfmGqL8yS617Go8Z6km8FnvSkHiDdc6L8CbGJA/0U32k1eIHPo85iPNL9i12xBm5
	 4wq2AZPUqXiMLOxwrB8KGKCXdEqpzhKlFVjcQ3wXfzRHo9XGf8PlFC22DRPfM7k3ip
	 VSUm/7GKjSTaCjzjjdPT5Z/Gpj/PvWGiCxtghkQVquZBmd1UpXGEuqpj89QcOGhq9b
	 GmqHdPF204W3n+31wTaWe6nvELLtr6BwxheTu+PWc6vMg2j/ojrPzNqE+Vf2I/xXaO
	 qqixl6f79FqbDMJ0RWqzDIMD5ghInp5QfOA6ZTmGWd9mNgg8W868UCqeDa8WKoqcfe
	 FjEIqWNE/AnSg==
Date: Tue, 21 Jul 2026 16:11:28 +0100
From: Will Deacon <will@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, Catalin Marinas <catalin.marinas@arm.com>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, linux-mm@kvack.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH 3/3] arm64: remove early_ioremap_reset() call and
 __late_* macros
Message-ID: <al-MIFXhVs2Yol4c@willie-the-truck>
References: <20260708170647.362562-1-ekffu200098@gmail.com>
 <20260708170647.362562-4-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708170647.362562-4-ekffu200098@gmail.com>
X-Rspamd-Queue-Id: 9782F1C0010
X-Stat-Signature: m6z3tfe9u4c8bc3m98kz7aroia9m1nnb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784646695-715926
X-HE-Meta: U2FsdGVkX1+dXdJ3y4bTOMFTioaGarBdituZstGXD0qRZo7QNQIfclHkRm1C8g0kKBC/1UkfHscr14Cj02m39dPFaM7f5Z++9WibK2nY3+ndbGyqlDDbwYeYrN1Gb7SFF8Jq9uE/ZxpTP2jtGNVCSYpfx+jvoXBTDpZ1MdC5t+3u10eLx0O6DETWa3cMBvJqidFW6rPQFAre4WEq6p8uzCyWOt/NavIB8uCKRttS4/coa6kDAqLIb3buDXcIRQ6nbLz6KtBE0c63LATPgpHVK4d27ulsB9SJgIbInYG05z6lSXJtpDVDLgU2Fkp7liKy6i/hFhK5xFM4Z3PIrVWc/ldW7BfvwIyHf7X90qooW3ECz+2VPhqUEFCl2IecShndC3gMe5D+oBbM0tzUu4Dax4MERe4Jy25iINhyitElsazEnC/LJStgNXVk2uzO52GD8bb29j/sRGrY5X6JH3rnLUbH1dfjEZZqDpnDqeSTyavwRiMdDeu35Jnnf75LC8+0L9GldQH4HHdnuDWFj5/AC5pZCzNTeNfhfo6TXDOnDLe9+1bqCERXAx8UtkL7rQfrkBFmTe+yjhrIajyhT83PTqeVzPKcO9z3V+caXWOoZ5wNMZ0J3vcjB+ZrET5cH6UbgA7YqMUgSMauawSE6Q3o+ZNT3m8cYe3tXhFvypcHkvTWi29/06CwP5JS2u5WTVKcwiT0c6F3plEaDXOmOEeUSbFt1BNe/M+q6Lw78G4iUcskd/1QAI2kZcxUTp+WUgfGWLMsRUz4nH4r/zoXGcn/Ctng+wMrTUZ5yptMwOeDdY9hckIVKoWReNJIgyhDvgnBzwDxEeEWu9Icx/vy+S5QhLTMcG9/VZvKPGqwFJw2msHchVW71tybafEhWFIyotCE7rBqo79Js3bAYvGSMiT6mbCpi7NTB2lzhw6DkTSX1pxSWtG2UDOdNu6j47sMrg1v8FdJjH2WDmu3HOperW2
 F5148huV
 cwu7maULRYWZPcLvSFlYLKh+WiyHAlB7/TutKKIP6AZhMKwSQ96ss9gmfoYVMWDvZ+mSnC5WsCChOGYlPFIiwTyZnedSjUZVtMUCTIjuZ29Y2eNmHMcnDVRg84VnYgR+T6K4OUq+q39e+5NXarXrsVAoeafmpL0/U+H9jTomMDNw5kJV1R1ebdI17iA2XV+4p0930lfqanAUkupn6o4BcdwGTD/QttKgqRONjJ1mAiD8VPfJwOgvEJA50gnWDksJDFnbKdJq3C4dR72GrjQETsjvMJSmLp5G8amF+29xxlTSIJrhI+T/JDwn3zi6t/PS667MsQREtDWXgqDQyhvJnlP5RD2zUEx6h7/9f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 02:06:47AM +0900, Sang-Heon Jeon wrote:
> On arm64, __early_set_fixmap(), __late_set_fixmap() and
> __late_clear_fixmap() are all __set_fixmap(). Calling
> early_ioremap_reset() changes nothing. So remove the call and the
> macros.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  arch/arm64/include/asm/fixmap.h | 3 ---
>  arch/arm64/kernel/setup.c       | 2 --
>  2 files changed, 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
> index 65555284446e..abd9800aabf7 100644
> --- a/arch/arm64/include/asm/fixmap.h
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -110,9 +110,6 @@ void __init early_fixmap_init(void);
>  
>  #define __early_set_fixmap __set_fixmap
>  
> -#define __late_set_fixmap __set_fixmap
> -#define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
> -
>  extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
>  
>  #include <asm-generic/fixmap.h>
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 23c05dc7a8f2..29c6100f0c50 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -347,8 +347,6 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>  
>  	request_standard_resources();
>  
> -	early_ioremap_reset();
> -

Acked-by: Will Deacon <will@kernel.org>

I'm assuming that Andrew will sweep up all three, but please holler if
I should take this one via arm64 instead.

Will

