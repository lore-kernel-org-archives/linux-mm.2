Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB336FA0C35
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5381E6B0095; Wed, 15 Apr 2026 02:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F096B0096; Wed, 15 Apr 2026 02:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C7E6B0098; Wed, 15 Apr 2026 02:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34FA86B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:48:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E228FC1A45
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:48:10 +0000 (UTC)
X-FDA: 84659860740.17.5E57D35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 090AF12000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:48:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Wn6Hr/rv";
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776235689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCfDM/MK3nfeMalsuUCejEYgbVuWPS8f+Bt6LFEQrWw=;
	b=24y+5rUiCUiwiKCUI43YlnoTw+jS/HFyHKiiHItxEwPO+ZbRS697aUfMXwzkzgoMYa4xiw
	lpAk7YvGIC6J0/qtSUWvq/eGVZhRyxqowqxvaHNnZgI0zFgRxXKpoy2YiPLfNNauBLJseP
	wx2ZMUxWMeMGkNPM5N9Noxw9gBv4SF0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Wn6Hr/rv";
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776235689; a=rsa-sha256;
	cv=none;
	b=BVIUydPU/IJgUtL0esal8T7/9q1MfJ7UCCIuurqRFvIOObdpiR/hwUz8wzzTcL+US3JXZC
	6RtuDzwSy7hGoGjKZzsD5FaOSJTTv6RvjVOVvKNmkiM7EA5mhHG8sJUzCMq1uA1QChXYAY
	iiLUUvOWCQOSlacNBrAM7X4eXOoS5XU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C884D41A70;
	Wed, 15 Apr 2026 06:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1D1C19424;
	Wed, 15 Apr 2026 06:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776235687;
	bh=uO1fFgRaYkEaX03uIGSllbIp0KmN4e8uhrxbiL7j6JA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wn6Hr/rv7RQ0mjmBpBGnHzSLGoawtRWrJKf8Yulby+TTpp7z1W2m+/e3q+cBeZYn8
	 9EULstKmB1P1aIGBA/hM7NfdL90zPADnWSMrSZUOJgfBI2Y0gYKo15ZH/8SN+3BCpi
	 LFdpD3kIOkfmc5kLWHOPn/7qJv2G9rdoWFZcqmWwEJGa7DK0r7DBeorJlYNCKX5hcM
	 Q22Qw/tg/rR1esDPVyaYxqkxnFQnTVF5/bVWUROMriQiIMAWyo9xVZRAIqfM9NCvMV
	 JvPvhMbjPkTiWVz5ZUzK2DMWWd8bbim3aFcilo4uxvNCEcTYhNnaiu0tF2t4jRv/Q5
	 DezCa9n7clYBA==
Message-ID: <9c33afea-7a64-456e-aa2f-bdcf7459b567@kernel.org>
Date: Wed, 15 Apr 2026 08:47:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 33/38] powerpc: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
References: <20260410120044.031381086@kernel.org>
 <20260410120319.789114053@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260410120319.789114053@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 090AF12000D
X-Stat-Signature: pgfjky6eocfojfdb4qsqc8jxgnsdja8a
X-HE-Tag: 1776235688-906216
X-HE-Meta: U2FsdGVkX1/ZuUUSIQDFlmhy7h2UMKA4Nj3hb99Xd7ZRAPzmG/VLckP1LrfKLXNJVypYOf0HGynx1CYagh7F3bm9J8l+HOMGe46rQWc9MJXtTAs2JSQ9jOEVG7Nc2xCCOW0MyDAz/G20FRpCsSMuNpkvvu0/RvHeQKpIgLUGzXrytOKM2TkCG37793W7U5a8hyiYfPWhxLc2dpbfAgxLx/TXfrCUlBj8xFn9MAEyaLlL4Lx7xOWavbMZkacvtNXE1CzGS8LfRbt3YbpAM48OalEyOwXQIp/mht0DBjonAD3cKNKoBFKz4+eXG6qzsBwh6ChNBd3x4G+aqLDDyJbPVSt9suIgW9WbTTupZ/AiJ6kSmr0ZyMkmKYeubCjeX3++6qgEuR5Na6O3muPur7WVpxtAuFs+gPQ6ZO936PK3n8fdiwCOOYseriOBbiQkn4QjE0KIaJpsoD+SfFxo2MFmDNGB6RKqWuvQE+wqOx5JrS5zTn+nnyVCLGlmphN/x1IiIjJTQ9xV44ic5c73fVUP/N7XePY47MMtordxrKY29ark1V8Kff9KK9xZPAI6Q6KD5z75V70IcZ4SA7qcnDuZsF8KBEONjWDMiy/Kkr9EpZVtZUyrudFqL5E9PrRl1SJ7wmmCtNM+gb/4g1s5EoSQRne4XgPsPDNhd2Sm8x3lYthnrC4FnGjM52u2vxX8mGGY72oBo/owN2xx6ZMUq2phwAOy9uiqYU0TsTHpUeRcuYooRw8pIP1zDvJCJJydWyMnz7nJBtBLPpp0IsJRoJxkfLl9pG5q95d6Bofh4MR8h6XkS3Z1xSUJkUs3fMdRTtv6e/OpS/Ef8FfIh4U/+K0NLS5B7Fv2EGjWCF5iRI7RoHmbEgG5KQTsfZkWShhTJFzFUsnRbZZKXbJqihDdC7fK3Ehn1jy65lKkLZN8POxgzMnjjfwK8kx2Dh925YTVAbDgAhGEBc+kLFfQKV4SL9O
 0L0XenJ0
 6cEO5gcONVgG6FI4lwtY5W9PuWg7vqBS7iygUI3A9V/721mGb1L2amRWWoMFxIU4eLPz7rU9LtMtueTh01JKwAy+Ej3AYDEm02/qIwfjEktVoW3vbgmy7GNH9gXiILVF5U/h1bQQA4QFoO61wN5QLfqDF3iOr7eGewSbfh9s1kxXrPwT6Rjtw6xAKBL6OlyopokZjAFwbz0Ep15qXL8bGPtD/TMspSDayFm5TEoRHqdVi2tdqsxRFTpcqlFWxvu5NNXHA1WrKWasEWFCgToiMCGINVC1POasmUpmMlCznY0oPeMMeC9bhYuTsBGEEHYyqVozU3dpSIIQbtzehOBdPDpTy5BNEf6XWPuwplk5ipjUogB/1oioMVPTYb3Wn9YlzxRM3+GOpkLqVLrikDgFEtcm1NGB5cUdYSi27qElljNTj3bLHbQS23Gddy6A1vqDRi8J2TDKFQoIcK1+szJZQQxAbOkuar6VPDukaHN0Z9PD6ZlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 10/04/2026 à 14:21, Thomas Gleixner a écrit :
> The only remaining usage of get_cycles() is to provide random_get_entropy().
> 
> Switch powerpc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
> and providing random_get_entropy() in asm/random.h.
> 
> Remove asm/timex.h as it has no functionality anymore.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/Kconfig              |    1 +
>   arch/powerpc/include/asm/random.h |   13 +++++++++++++
>   arch/powerpc/include/asm/timex.h  |   21 ---------------------
>   3 files changed, 14 insertions(+), 21 deletions(-)
> 
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -150,6 +150,7 @@ config PPC
>   	select ARCH_HAS_PREEMPT_LAZY
>   	select ARCH_HAS_PTDUMP
>   	select ARCH_HAS_PTE_SPECIAL
> +	select ARCH_HAS_RANDOM_ENTROPY
>   	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
>   	select ARCH_HAS_SET_MEMORY
>   	select ARCH_HAS_STRICT_KERNEL_RWX	if (PPC_BOOK3S || PPC_8xx) && !HIBERNATION
> --- /dev/null
> +++ b/arch/powerpc/include/asm/random.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_RANDOM_H
> +#define _ASM_POWERPC_RANDOM_H
> +
> +#include <asm/cputable.h>
> +#include <asm/vdso/timebase.h>
> +
> +static inline unsigned long random_get_entropy(void)
> +{
> +	return mftb();
> +}
> +
> +#endif	/* _ASM_POWERPC_RANDOM_H */
> --- a/arch/powerpc/include/asm/timex.h
> +++ b/arch/powerpc/include/asm/timex.h
> @@ -1,21 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef _ASM_POWERPC_TIMEX_H
> -#define _ASM_POWERPC_TIMEX_H
> -
> -#ifdef __KERNEL__
> -
> -/*
> - * PowerPC architecture timex specifications
> - */
> -
> -#include <asm/cputable.h>
> -#include <asm/vdso/timebase.h>
> -
> -ostatic inline cycles_t get_cycles(void)
> -{
> -	return mftb();
> -}
> -#define get_cycles get_cycles
> -
> -#endif	/* __KERNEL__ */
> -#endif	/* _ASM_POWERPC_TIMEX_H */
> 
> 


