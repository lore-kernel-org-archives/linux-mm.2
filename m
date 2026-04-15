Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE470FA0C36
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0356B0095; Wed, 15 Apr 2026 02:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2909A6B0096; Wed, 15 Apr 2026 02:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F106B0098; Wed, 15 Apr 2026 02:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 049196B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:38:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D3E6E3D64
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:38:40 +0000 (UTC)
X-FDA: 84659836800.02.FE426B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 81EBC140006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:38:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CW1zPJNS;
	spf=pass (imf09.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776235118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4IWqjLAxrBh670kFtitiIgXoOH5Wk9dWJgsH3Z8snA=;
	b=pXGAf0G/JZ153pD+FmQ5iIEm0YjZhD67RwSxMy1bd5VHgH5B8ixXJYoklE4NkIAe+ys85n
	4o4taxwrd3u4j/2FCZVKrGv9jr0QYBb4MyLwn4qUhBlXsS01F0P1q8amrmGrjE5GBLG+mR
	b+jX/LFdA5VjQbUAQ+nbSD65F7VIeBI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CW1zPJNS;
	spf=pass (imf09.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776235118; a=rsa-sha256;
	cv=none;
	b=FkgzL+qpaR63qCRdrXLxGvKbDCmMiwf59cIAeN4Ra7JLDJinfnswdWRp/Sknz03is7HuIe
	46ZfMB3Q0OjOS7+9KGdM0fBkbkr7O3EMIfCVwi6a4q7fGtW5qA3UyWcVUiF3xERvFb7xQ/
	pYwvjSQHQUEDBoOaX4U43tXBY9/Bv5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 540C64369E;
	Wed, 15 Apr 2026 06:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4603C19424;
	Wed, 15 Apr 2026 06:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776235117;
	bh=oJA3I+zKvq9KD+ojZoVICzDS05lI3MCnC5Rlh6cn04Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CW1zPJNSJCGtniBmy6uyWDY71JAL0i4dK/N5qkFlNYs3kz0wXN03HHuHTh1S4hKQi
	 e2yWcwq5RclCcCVX6A0Lopstyv1iJwvVwNRsKmdSs6NBxbKPvhq3apDF5Mh9EQ73Js
	 q6/zItY3OOkWbN+i3+Ng0jCLJkMAwhrFhYQnM+LI0mETHNwewJwuPg1EQX95XcPKNN
	 j2R4mf89jj4nr2TUgQRoKIUpiIuUlriELzBuol0ebMztd/ZZRtnQ1qtW+tQ2/QgIAp
	 oYZF1auoZqP0e9mHU9TqSeeI5ff2Bxo+lnB6gCW6VWEs5KrEifF6NFFvP+OSWCop4o
	 Cz3scEaJinP/g==
Message-ID: <f6e6f630-07f1-46b4-888d-324a62a41070@kernel.org>
Date: Wed, 15 Apr 2026 08:38:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 32/38] powerpc/spufs: Use mftb() directly
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
 <20260410120319.723429844@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260410120319.723429844@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81EBC140006
X-Stat-Signature: zmykrhaiceebjumhguoacfxyy4tiycr4
X-HE-Tag: 1776235118-824371
X-HE-Meta: U2FsdGVkX1+5uh64J9l+muLnih48L6f+YUBMQ5y7bt7SmiKhO/VOeqwvGoHiJTmg8RzqzrmhQaSNigq+MJr4BFt6NgNv2OcEKY2Nf89Umm/u8AcEecU1LOTQgozAIwHlvuj4N6MYq1mj6EIVOirabNXOnvxKq09f6U3AGrUPP1ZprMWe35crEKIAYd9rPf09S7gy9Odw7UYodcdEjCC0NDix2scMhp7kep89pPVZ/NVHka3KqEvdcdGz+eplCyXwg4wGGLfxmWxud6kbHjP4r9q7Aa4K5DvMe5n2ggkdYF7EsuMrNwKQ+D0xFs4ddZZXX0I4BBKlkPM1HknGUefSUzmrEWAKWsp16cYNRfr6PVsDC2Z6UvHYni8y+h6uPfX4aMlFzOv73gSJU3k/OAqzwKECwxyY5r0hQ7UYY8clVrfoxU4bBDDs9WABkALbyS0D+LWpEK0anbC0726BsA0woZC28oJgGkDKEM1uiB16mC+kgLdIXM5OU6wHc8yHhvlUNdrReYQoOwlqZTCOCM5SXaU46lGBM+O3dSmXHXiIewubWNknV01cZg8AwxDsAuoYSgVb/q8dLs3thHjusMMyLatEa8jSEpfa+qyAFSe7kYGLu+5lpsbYqv4TKJzt0+WaMs9d4nXpd81wuy/Rbz/uzjF/FzwfZVOBeL4j9UIw2lPUtvvDtua3sziOsjey/t49Y7L+PKsz1QtJ+cROVWpOIMTrqC3UPWH6/Ot64ZDsQflfmx8dCqFKFB6hwPYEpKhOjAU7nc90F/cvYWQ7LGOSE+dH1tbBuJJ8HiP0NVfMA6LaezxNtCqHxOg40UOR1LO7Ca8a8/GIpyHmVPg5etID4C77DXSJUYEV0KiDBH31LcKFuSJFePDgya7ClK5/46j3jVP6imDd+97JMjBMUWJi2gNRUsk8WlQCzJdNNqZNxR4BPswfZxlhZ+Ky1Qbuh3mB6ouWJ6tqcYNtC5u/aId
 rjzOGgG4
 dBVacPV0VuxvwuQWGwkP2Tdp/j2qrEs652uuUwwA3gfJQtrWW4bhbBYVpCdezTf9Q4fwtf4qna7LcTu5Q8VflZHnik8BN9Tb1Od0eqMe5AtxM8zF0iIC1nQQpdzKl9LhdH98ELNjqIYpks7g59spxhUAyLKZoGilYae1l6xf4Rwx04vj0Lgty1pQ3FzziloSw0AUjuL0gKFozE4A2LwgxmMMwNBzIEhEcLItGDxVzL6nvlV970fLBJQWDUuBujXEVBhHTcmquWzXMFAUC0/5Q1Ylb16CgOSKKO0F7JaXh9Lyq1bHfGe2LPgkUB9tcCPqZI5LGaKJNyfBtZiQuoZP25y4XBOMwVsE/b2pfYdtetmUmHHdFMZdo7YizimtdIKnGTzygoCbaQTvbLzQdYvlW6+awCG1F3O7NVXk8AD1MFzfKQ59WM5mDe6S9WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 10/04/2026 à 14:21, Thomas Gleixner a écrit :
> There is no reason to indirect via get_cycles(), which is about to be
> removed.
> 
> Use mftb() directly.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/platforms/cell/spufs/switch.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/arch/powerpc/platforms/cell/spufs/switch.c
> +++ b/arch/powerpc/platforms/cell/spufs/switch.c
> @@ -34,6 +34,7 @@
>   #include <asm/spu_priv1.h>
>   #include <asm/spu_csa.h>
>   #include <asm/mmu_context.h>
> +#include <asm/time.h>
>   
>   #include "spufs.h"
>   
> @@ -279,7 +280,7 @@ static inline void save_timebase(struct
>   	 *    Read PPE Timebase High and Timebase low registers
>   	 *    and save in CSA.  TBD.
>   	 */
> -	csa->suspend_time = get_cycles();
> +	csa->suspend_time = mftb();
>   }
>   
>   static inline void remove_other_spu_access(struct spu_state *csa,
> @@ -1261,7 +1262,7 @@ static inline void setup_decr(struct spu
>   	 *     in LSCSA.
>   	 */
>   	if (csa->priv2.mfc_control_RW & MFC_CNTL_DECREMENTER_RUNNING) {
> -		cycles_t resume_time = get_cycles();
> +		cycles_t resume_time = mftb();
>   		cycles_t delta_time = resume_time - csa->suspend_time;
>   
>   		csa->lscsa->decr_status.slot[0] = SPU_DECR_STATUS_RUNNING;
> 
> 


