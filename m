Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BAD4CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5A96B03E2; Tue,  2 Jun 2026 04:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56E36B03E6; Tue,  2 Jun 2026 04:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D396B03E9; Tue,  2 Jun 2026 04:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 967AC6B03E2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:33:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 147671208C6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:33:05 +0000 (UTC)
X-FDA: 84834307530.25.A63BC64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6859240008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:33:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhPA+n+i;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780389183;
	b=Vl843Rn+vGH722gRvlJ25/3yPyFKsXh3/IhymdtXlm9+EqpKYiZnSnwziftfGBrIcHiL05
	t3gLIJHE/2c+1A2SObBu436mQkFtqN6YPO6VMiQBZh5WiarDt3pBUglWK0qK5TxwVpQE7C
	J47Q6Wz+WwYu8PpiFCh4CyxXuS1CtPs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhPA+n+i;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780389183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ImCYU+TtOZg2vTfWZSd4fkm9BzeEqJiDqaIVmGVhX4=;
	b=sw8qkPvZ1JAHV7pyoOQbISTf6NbJlk89HZdITHLp1QkDC0KYX8lxuzBbawhtgEbtIzjy4M
	7pBgglfK/Lq7kN+sEMiO/JqwFV+8GzsaTkvLSTAHkeNoBZejK1MVMSyl9qw15XWUVT7M63
	9C/LJtREecb380O92mUUQhe1K9QkEbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BD62434A8;
	Tue,  2 Jun 2026 08:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8A61F00899;
	Tue,  2 Jun 2026 08:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780389182;
	bh=6ImCYU+TtOZg2vTfWZSd4fkm9BzeEqJiDqaIVmGVhX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VhPA+n+iHPnrTiQhiY+2njrnPuAKPmUMA1XLzg8zXiDW8Ur1i82vNx+RfsJaHbG/V
	 t7LbB5UhCxBdzaJgsH+Lvuq6RDqn9YeoBU8syoFnxCx8408jaBxPSYzu4Bo0magd+R
	 qUqAb6faRwucvYUwiOcr8ToMu/106/cWUy0iiey2TdjOO8+ez1b83N0mMkwbwL6mGH
	 odmbpkrqwFdeEaR3JsP3SgaX86XCV0HQFNbu3Ac0xCeTVpcwjH4xS+y5Oe5DYue6pW
	 xOhvUH3gY8D7rkv/tpgMPWHflYIBNWAxY4wlaO8LVww9UXDrQLnYP/FAT47uclaej+
	 pk4ioZzvUkOSw==
Date: Tue, 2 Jun 2026 11:32:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>, stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>, Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 6/6] userfaultfd: build __VMA_UFFD_FLAGS from
 config-gated masks
Message-ID: <ah6VNjfXXx-3Nh9l@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-7-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529172331.356655-7-kas@kernel.org>
X-Rspamd-Queue-Id: 6859240008
X-Stat-Signature: r1tt6hp55cgjtpiz1pzf58mpfnydt74k
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780389183-856976
X-HE-Meta: U2FsdGVkX18K98W5FbsY21/q1+cwL+AQXDpS+P/WynPDrVCY+YPmeKWdBTJmADQJvPFjUNguLO8fgPZqVP8cWFPdJEDx8u61Xcj/QFT+q3Y3+UFdL3McA6bvr7JPedGeIBhH5lybYgHHWKGF3wOwtB3P34jzDcM207xsIxmleBh3kqNYYeysGX6bUe0DyTDswk9p7p0fn8Stw+ByvlV43fdDIXeeKAGWs307tNsUf7UdOdm9eAn8UmcrgBq+0NlWSFijTgeoo6eTEVcQxn+OlrZCJVTeCdCxnJFQH4HuzUnrIwIeD+37NFAN8BkWJG0H6ggZIjklYoN7pwWGAP9zp0rUarEYJIBox12wLTjHY7feKbPAXSVoRXUrq/hE3z0nuYw8cBXKktLx8y7prhvYDPcEZdKEAAMCKzK9x/0Gx8chnh7kUqEQfnEex/jK22Poas41oONWAWFIPsdNJHSqx0nNb/ggmXcjQEZ8bjFZJkTJXVCfbWYQ1P77PzBxwNdXgbRhE0wGBzKSEIvcCUn5mU7D/qZIpVrKrLAMtOQXNpJ7KG6g81BBuJfr6OkZJi+DCXXtpEwUPOH6PfTvo+yHhOV4M3Q+X9kMLVkPoQ/X9xOI/iIulsdXaKnBWRvUtMQL8cJUYyaHI2BJ4UKPqYD6t4GCrLd2TxOs5z83vm5wuSNrJcwUCreySLCfMTN60Y/BFGouiOt0Te+CuUHFxOX0Zcsvt0USgq3K+gVB1KRtgA0Ctnt4/XSTRxhlfqIKlABXJEJWkv/LwFmV6iI1bAqs+Juxa5E2AiN1pE36B/XXLYqCJXbdJJPHlMMzdKp446GU5myjvw8h3AIXHIRJ/ZwX8z9RAoyKwjv1HjB5VKqtY660j/HGO5rVqrOk1YV2raGEqecYgStcPR9N3hikHqWtXXVC8QmtSNQ2XAfbXG/4HBaOlVrxP7UF151KNXDFZsJOiDHpgfw3IY1P1wY9Kg+
 nIHKPF0t
 TD3vzq0ewJvgFDUZ3r2Jt1NJ+saELWkUKqZcL8mBaNiC16rOekvKoEsTnFS/1UWr1yhvSPzeHrf3pg8aJVzCi0bXeTccgDyds148SJey5is0afaZ49Ozo0sMS2Y7fjUo28m51jA5yZplZ6TPXGpljxxQwWO6PBKGdgJmwQEv2m176zTuyQzp79AXsL1HSXngRdTn/qekjKkaBlpf2TCN5tHZJkFtfZR7unXEepjqA44jZSxuncD15tzlxRH++Eun7veHYRBeovwJKeO6sUuvuU8viXdeP6wCHxzDoRRSqOf1+VK/8l5WYLnhQb6/E41Czqr9+CJZutXWIatQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:23:30PM +0100, Kiryl Shutsemau (Meta) wrote:
> The VMA flags bitmap is a single word today: NUM_VMA_FLAG_BITS is
> BITS_PER_LONG, so on 32-bit vma_flags_t holds only 32 bits. (The bitmap
> type exists so this can grow past BITS_PER_LONG later; until it does,
> anything declared above the first word is out of range on 32-bit.) The bit
> enum nevertheless declares some bits unconditionally above BITS_PER_LONG --
> VMA_UFFD_MINOR_BIT is 41, with VM_UFFD_MINOR == VM_NONE on 32-bit so no VMA
> actually carries the bit.
> 
> __VMA_UFFD_FLAGS feeds VMA_UFFD_MINOR_BIT to mk_vma_flags() unconditionally.
> On 32-bit that becomes __set_bit(41, &one_long), a write one word past the
> end of the single-word bitmap. The compiler folds the out-of-bounds store
> with wraparound (1UL << (41 % 32) == bit 9) into the first word; bit 9 is
> already in __VMA_UFFD_FLAGS so the mask happens to come out right today, but
> it is an out-of-bounds write all the same, and any high-numbered bit whose
> mod-BITS_PER_LONG position is otherwise unused would silently OR an extra
> bit into the mask.
> 
> Rather than feed bit numbers that may not exist on the current build to
> mk_vma_flags(), build the mask from whole per-mode masks that collapse to
> EMPTY_VMA_FLAGS when their feature is unavailable. Add
> mk_vma_flags_from_masks() for that, and define VMA_UFFD_MISSING / _WP /
> _MINOR alongside the VM_UFFD_* flags, gating VMA_UFFD_MINOR on the same
> config as VM_UFFD_MINOR (which implies 64BIT, where bit 41 fits). An
> out-of-range bit is then never materialised, on any arch, and the in-range
> fast path stays a compile-time constant.
> 
> Fixes: 9ea35a25d51b ("mm: introduce VMA flags bitmap type")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-8

Can you ask claude to produce more concise changelogs and better split it
to paragraphs?

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h            | 39 +++++++++++++++++++++++++++++++++++
>  include/linux/userfaultfd_k.h |  4 ++--
>  2 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0f2612a70fb1..485df9c2dbdd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -496,6 +496,21 @@ enum {
>  #else
>  #define VM_UFFD_MINOR	VM_NONE
>  #endif
> +
> +/*
> + * vma_flags_t masks for the userfaultfd VMA flags. VMA_UFFD_MINOR is gated on
> + * the same config as VM_UFFD_MINOR -- which implies 64BIT, where the bit fits
> + * -- so an out-of-range bit is never fed to mk_vma_flags() on a build whose
> + * bitmap cannot hold it.
> + */
> +#define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
> +#define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
> +#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
> +#define VMA_UFFD_MINOR		mk_vma_flags(VMA_UFFD_MINOR_BIT)
> +#else
> +#define VMA_UFFD_MINOR		EMPTY_VMA_FLAGS
> +#endif
> +
>  #ifdef CONFIG_64BIT
>  #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
>  #define VM_SEALED		INIT_VM_FLAG(SEALED)
> @@ -1238,6 +1253,30 @@ static __always_inline void vma_flags_set_mask(vma_flags_t *flags,
>  #define vma_flags_set(flags, ...) \
>  	vma_flags_set_mask(flags, mk_vma_flags(__VA_ARGS__))
>  
> +static __always_inline vma_flags_t __mk_vma_flags_from_masks(size_t count,
> +		const vma_flags_t *masks)
> +{
> +	vma_flags_t flags = EMPTY_VMA_FLAGS;
> +	size_t i;
> +
> +	for (i = 0; i < count; i++)
> +		vma_flags_set_mask(&flags, masks[i]);
> +	return flags;
> +}
> +
> +/*
> + * Combine pre-computed vma_flags_t masks into one value, e.g.:
> + *
> + * vma_flags_t flags = mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR);
> + *
> + * Unlike mk_vma_flags(), which takes bit numbers, this takes whole masks --
> + * each of which may be EMPTY_VMA_FLAGS when its feature is unavailable -- so a
> + * bit that does not exist on the current build is never materialised.
> + */
> +#define mk_vma_flags_from_masks(...)					\
> +	__mk_vma_flags_from_masks(COUNT_ARGS(__VA_ARGS__),		\
> +		(const vma_flags_t []){__VA_ARGS__})
> +
>  /* Clear all of the to-clear flags in flags, non-atomically. */
>  static __always_inline void vma_flags_clear_mask(vma_flags_t *flags,
>  		vma_flags_t to_clear)
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 3ec8e1071673..68edac4dcd78 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -23,8 +23,8 @@
>  /* The set of all possible UFFD-related VM flags. */
>  #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
>  
> -#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
> -				      VMA_UFFD_MINOR_BIT)
> +#define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP, \
> +						 VMA_UFFD_MINOR)
>  
>  /*
>   * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

