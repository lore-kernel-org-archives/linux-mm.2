Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807FCCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE416B008C; Fri, 19 Jun 2026 08:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F796B0092; Fri, 19 Jun 2026 08:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5844D6B0093; Fri, 19 Jun 2026 08:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30AF96B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:09:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A07AE8DD6F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:09:34 +0000 (UTC)
X-FDA: 84896542668.28.E0BFD55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6A01F1A0008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:09:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ag2I8MaZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781870973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIeF4o+oA+QhvxgydThWOk8fYvHRjOwSBeoChr1ofj0=;
	b=QVBuq0toXFgsEXPL5VN4H+GSP+r1T81UazzHBpVtTp9g7T+NfrC9OReQ8a2rVu7nWhDIyG
	PBn//jz0QXcd/f9uz0xo2eivLkFi44pFqMmp3JoC75N961SOEZPR8owqIlODIog1jfYgJx
	L/lnumP8RHkhxpP/yWNr4cz1OELU9tc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ag2I8MaZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781870973;
	b=69yFzHkW0zeR+IGrlGIZ6VD2JUsILP6fgCRcizqRqhOXLHtJYnNm8dLpz0hu+F1a4VsRrc
	IWLifahr+uKhfV8MFjswPtbBRe268mNe+idKg0GP6PN0W3x7UUz1QXrS5ct+Ipn5gJPHfK
	r66NtF9gmwUKPec2MvIIk5HLm56jO3I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 769B43541;
	Fri, 19 Jun 2026 05:09:26 -0700 (PDT)
Received: from [10.57.95.87] (unknown [10.57.95.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0D863F62B;
	Fri, 19 Jun 2026 05:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781870971; bh=CbvyzZMEqP1i/XApNRquWzgwjAyHus7dVHSaqyWp4bk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ag2I8MaZkwum7i4EHVhEwH48PbsBZo253L7NHnIqhmZ4lxMHgo2ziLEGuxVL/0kGE
	 uomZ83C+vrC+QPKfU5VHK+3ps78o0ZD7f/3qoAsQM7XmsK+536oAp48IKm1KqprHw3
	 U8pLutdMMFihL80+1nxiriPkxyS9IsyP+OQCeKJo=
Message-ID: <ff82a5b0-fe52-4b33-852c-10f3923999d5@arm.com>
Date: Fri, 19 Jun 2026 13:09:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/6] arm64: execmem: enable EXECMEM_ROX_CACHE on
 supported CPUs
Content-Language: en-GB
To: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-6-abarnas@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260611130144.1385343-6-abarnas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A01F1A0008
X-Stat-Signature: 4iwi93mrtopy7boxw3x8ixa9pg31ez1b
X-Rspam-User: 
X-HE-Tag: 1781870972-901034
X-HE-Meta: U2FsdGVkX19VYDQDIcQvReT4lZOL0Xb2xskP11neApemQGxZan3ecjOPy90ZeYRHltXQTXbTZw044KI7WpADwzOkhrAadHxsHxz198UF3wl+YOC80lrWjCvFnw9ccZ/c7MlnVkT2LisUGPif6PDs/KE5uroGbOZ3+8jFuA6WHS+jjwnV7XKXE0O/Y3a+OuDJciPph2cYYEOWj7pBlHpAxNKIpuecUBoKQaxSvKUrBoh9m4+CQu7uDxYQDbq4ZdwKm09hvvHmMb0Khl1BvamZJ1EmHxicgNJ4KwTn+U+edHqVrps13HbQnkqcQud5oNJQZakDpxHtDXyAGitGgJKUXMXk3D6Ql+erxxI8kYlQqMBzE4C+32ZqzWaUp+yZYoaxnZYWmSWq/Ua/C5GNnAGgR+Egz9D9XvEcLYy54DQiElCS4C07MzKqUeabU2YsttumQ5t1fIUc3zHHJchqpobspqpLJY8rLzv+zFeYIUuEbJTuklw431R0D9xhEuHcXFDHHLm5Dl2TfKUph04F3GRa7bhHrAFPP/Rymncn+mxJiQ0d8oh/9EkB2IEqP4Ht9wkP+ut6Ac2aXJcrp3B5424E+rkvHtqbdGPFO8ouG+zr6xU9WjxN71jK1x22Gkq0DFN0qNMEmiVk3xkicmlKZhOkHCqtCEJkNQGDcAtA/PK4DGLLHDB/kZeJKRZHpsrkRBvonU4rllM1NSVhMr70hTKDyuMyCXAViXeBcmSNa8jf97rQS/EvtqJrTovNyy0rX+XZYBGO9SWgcICB3AyntMt05LDXdHt//jsVx8XawcT1SMyjvfCf4FCGQGvanq5dlh+AZW071cdL4hg2qkBXd4qZr2WI4l9ZKG/BjNTLJs6DneO+54dfithjFlHWxcANpOYlW5cULrfCDlE7g8jatshVxiG8DF/Plu3xDGywnDEDzidA3HICnEAAbrRpn5VYJ88PrYSqCZwqhA2E1kx85zo
 YSd41jbG
 +OEkcE9imx6Piuwsk7MG2VFUE6Meay6Wi1zbKmDkW7Ggz1jOFtorx+PpVH4R9EZsjrDUVkI4pUcjXSgvomqLvUEtzOqZdoEEFWAWDq0pT8piz2+buy7y1uE++D1a5vhQq3OIkcyfGOB75CqfHPC8AwLqBZitB+vsJq8ECwaUSNoHiBp10f/6gqxxmZFuDYAGG/BiGTzbb6Wuehke0KYs/4lMje17udzhWcUWlRuDKqEwidz6P3+Qrbf+LcqO14ojiK4e7O1IsrKwO+h++5kou9lsP6K2j1u7Uyudk/yfdXgKMXP1rSTBkqYIlrX0Qy2tP0m1bjQpMyM7MKFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/06/2026 14:01, Adrian Barnaś wrote:
> Enable EXECMEM_ROX_CACHE support for ARM64 systems that implement
> the bbml2_no_abort CPU feature.
> 
> Using the ROX cache brings a performance boost by reducing linear region
> fragmentation caused by strict memory permissions (e.g., W^X enforcement).
> Grouping executable code (which is read-only in the linear region alias)
> into PMD-sized block mappings reduces TLB pressure and page table size.

Do you have any data on fragmentation reduction and/or performance improvement
in practice due to this change?

> 
> This is only enabled on systems with bbml2_no_abort, as splitting
> these large blocks to make pages writable during module loading would
> otherwise risk triggering TLB Conflict Aborts.
> > Signed-off-by: Adrian Barnaś <abarnas@google.com>
> ---
>  arch/arm64/Kconfig   |  1 +
>  arch/arm64/mm/init.c | 22 +++++++++++++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 38dba5f7e4d2..79c347ab841e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -285,6 +285,7 @@ config ARM64
>  	select USER_STACKTRACE_SUPPORT
>  	select VDSO_GETRANDOM
>  	select VMAP_STACK
> +	select ARCH_HAS_EXECMEM_ROX

nit: This list is sorted in alphabetical order; please maintain that ordering.

>  	help
>  	  ARM 64-bit (AArch64) Linux support.
>  
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 71aa745e0bef..8269d7747b84 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -420,6 +420,12 @@ void execmem_fill_trapping_insns(void *ptr, size_t size)
>  
>  	flush_icache_range((unsigned long)ptr, (unsigned long)ptr + size);
>  }
> +
> +#define MODULE_TEXT_FLAG	EXECMEM_ROX_CACHE
> +#define MODULE_TEXT_PGPROT	PAGE_KERNEL_ROX
> +#else
> +#define MODULE_TEXT_FLAG	(0)
> +#define MODULE_TEXT_PGPROT	PAGE_KERNEL
>  #endif
>  
>  static u64 module_direct_base __ro_after_init = 0;
> @@ -511,6 +517,8 @@ struct execmem_info __init *execmem_arch_setup(void)
>  {
>  	unsigned long fallback_start = 0, fallback_end = 0;
>  	unsigned long start = 0, end = 0;
> +	enum execmem_range_flags module_text_flags = 0;
> +	pgprot_t module_text_pgprot = PAGE_KERNEL;
>  
>  	module_init_limits();
>  
> @@ -531,12 +539,24 @@ struct execmem_info __init *execmem_arch_setup(void)
>  		end = module_plt_base + SZ_2G;
>  	}
>  
> +	/*
> +	 * The ROX Cache requires bbml2_no_abort because it uses large block
> +	 * mappings. On systems without this guarantee, splitting these blocks
> +	 * to make pages writable for module loading can trigger TLB Conflict
> +	 * Aborts.
> +	 */
> +	if (system_supports_bbml2_noabort()) {
> +		module_text_flags = MODULE_TEXT_FLAG;
> +		module_text_pgprot = MODULE_TEXT_PGPROT;
> +	}

Perhaps this is a bit clearer? Then you don't need the MODULE_TEXT_* macros:

	if (IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX) &&
	    system_supports_bbml2_noabort()) {
		module_text_flags = EXECMEM_ROX_CACHE;
		module_text_pgprot = PAGE_KERNEL_ROX;
	}

Thanks,
Ryan

> +
>  	execmem_info = (struct execmem_info){
>  		.ranges = {
>  			[EXECMEM_MODULE_TEXT] = {
>  				.start	= start,
>  				.end	= end,
> -				.pgprot	= PAGE_KERNEL,
> +				.flags = module_text_flags,
> +				.pgprot	= module_text_pgprot,
>  				.alignment = 1,
>  				.fallback_start	= fallback_start,
>  				.fallback_end	= fallback_end,


