Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFB7CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64C06B0088; Thu, 21 May 2026 07:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15696B008A; Thu, 21 May 2026 07:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B316B008C; Thu, 21 May 2026 07:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90BA46B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:31:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D781C20BC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:31:34 +0000 (UTC)
X-FDA: 84791211708.12.E3CFCDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 917401C0011
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:31:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h54fycbG;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779363092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgcEVAFtzfJI8Cf0vEzf67Bbt1xOMLxTJHkePwLzy+w=;
	b=W2T2mz08Jy5YmKUvXgm1svPvqNe0IoahUwbg3qQvXzbVwsXqj8ZGgAtBZqHnjJMApnGwBW
	FCA7TgywauUs2Dzn4WHVSO51G04NSYJB0tAuFc6hwsiAQP2+c0SekdoIwXPww+/DcN2dBg
	B8suuc8BN0uPUHpv16CXt7R8czfu73Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779363092; a=rsa-sha256;
	cv=none;
	b=WG8E64a3YHK3mTFKmlzgHZbduphb+EJyQndIKgIzDL/+TQReZyq9SOmekpiKjq9g57GvjR
	Xf34T9fYQI2HVmG+ILXrypICMnm6VA2NSL/djxt/aGOFngHlT752Cfe2JfF+VwP6RiZGEG
	d268tlqVCf5a3X4AZuLmSIWiIh6miVE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h54fycbG;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F282860172;
	Thu, 21 May 2026 11:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D561F000E9;
	Thu, 21 May 2026 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779363091;
	bh=NgcEVAFtzfJI8Cf0vEzf67Bbt1xOMLxTJHkePwLzy+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h54fycbGyV4CYnDD9G31gs1NqKZCf6GsDTwOsJpicFFm08ykem90L0aJesvHhf3J8
	 EeUSveMNcPLxN5YH8hvASI9dtOtiOI3iIj8hdgMBZAOWbz49lPAzcBOhh8S//Kh/2r
	 EyNkhZ9R/N4gv5H1jUhh7vpyFI0C5dmYogHJQ2Ftm8kpmHHtDhSTXxKWZxSqNlpVKi
	 2qOUB7VxsnBpsXVEf0RM3eG+YtzD9wHzM9s5nLPvjkXCZwCff0jzFU7SCjBn026mIP
	 cLlbdJBTl2hV/xqAT/zG0kZ1RDTG3Qao7ZIBGRMdRhUWvKe4K99QuHx6n4GBLSKS0u
	 HeRTL6t2ecqZQ==
Date: Thu, 21 May 2026 12:31:25 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] string: use offset_in_page() in sized_strscpy()
Message-ID: <ag7pg__Dzs-tKfGw@lucifer>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-6-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090655.160282-6-thorsten.blum@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 917401C0011
X-Rspam-User: 
X-Stat-Signature: 3h938zjwzfb5raio8odwkj6cnuiyqhgp
X-HE-Tag: 1779363092-103518
X-HE-Meta: U2FsdGVkX185C5BLeY//XKzhNZZb6qxvrCTwNgLRQQdT0sdDmKy2W1Ce9AUbanPFJbJD8XGGqYY3bW6nfAsTVz/obwtDk4/ovsgcAqWCG96Gbz32PbHCi6MBNEmQ9Dm4lbloMdPWupRDIzf6dK4il8jaIDgBrbm0rIq8O8yCs53j1+ugg30+L+dY+dpqg0rTTTrLXN3DWg5ypQDuVXhsbAfrXXQwIwgd3fiDctrxv0Cp/cHvmyYtuqR2mYH7avt7OVjE4HlNJpML/9GomaSfNDjPvLxENeTAaN0llptRcN2vGnSYbQYUjfkmalrzYd3RszA6nlzuRvP4Dt283LDuKOmhWnL7cqbuJCjpygcw6nY8SOgkRbDyrqOnHSrBFyKdNf17f4HPctTxdob4u8ImjypCfwKD6PU9i5qMJw1Orp6ajQRDwcH+arwk9LGHbw9nktTv6BsN0u/nPy0BDiGK2kKPWW8hDoqqc3N5Oeo/7B38Fv/fheuK9YMkObhcONA1nksUr6Dhkdbrp/1eIesU8egLHr43bRDrKOMlKwYudw/JJwr0fMyRwPGwfFKtfgL0Jh6hkqpW5241/F/WYF7PanJxrF600IfLjAjRfzhtuzZ7dLupDctS2jQWT1iRM2leNPxo/9sVwWBsPZsQBQTxAF4TY08JkYVT1LkToTGggvrDoMrAU1Ib4x67fGoiG90RDltlR/0mymPY1lQtTaWWeFhjxryrvS2JhBi2OhrFVpeyUFwHM9W25qH5Z98R20XXrsFoBq27dmORXzMOOpCG+G2WAlCxBZI2dUW1/USh/HagEiQ6VcLekRLjHlrEbGalfsy6moEm+dWEpNKC6cafuxAsF+/dMBka32ou52+hXch6SR4yrxLNquQiBhrUYV5ZTLiK5jue/RlXXukGIrutGrz9vI1/ffBel8ChepqYoVf3t5b2T5VJp/Z95viOEorKw1xB+x7K6SwrCk1KobO
 mEp9Sack
 +fKhrFvaVd9Q2KSTmS95oR+FvxQ7HwDxH4nJNiKaQxlYhP+E0K5uoTFTmSxPAR7ABpjlYf7apS1IzLBNvUkEbMK0/liSpbdjO2y/AoNmk5wAwokNzdZ/kqwecDRZCoqftAhvCsvNdJuIOESr2+n7TAfeklnllymu/toIliVdYCodCCfWvBPPCmdYcjH3V7hb3jYuXRr//g5dpOGQ5XxvmMPS9hRKJPvhtfpI0+83J5EkaF4ld4HWnKT6GLs9Ftjwi9wLERK1Wv5tc6/67LDjQwMs0XA29bO518WRWQ0I8LkXUIaNvCIGTZXqGFJCRcyh3uOTpMTJoyQdu3gMzdMI8zkRbA2mlxm/yXh3IRKq34tY+3+3xClMzT/1GMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 11:06:58AM +0200, Thorsten Blum wrote:
> Replace the open-coded implementation with offset_in_page() to simplify
> sized_strscpy().
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

I feel this patch actually makes sized_strscpy() more difficult to understand
unfortunately, so not really in favour of us taking it.

> ---
>  lib/string.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/lib/string.c b/lib/string.c
> index 1f9297e9776a..7c72adc7377c 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -25,6 +25,7 @@
>  #include <linux/stddef.h>
>  #include <linux/string.h>
>  #include <linux/types.h>
> +#include <vdso/page.h>
>
>  #include <asm/page.h>
>  #include <asm/rwonce.h>
> @@ -127,7 +128,7 @@ ssize_t sized_strscpy(char *dest, const char *src, size_t count)
>  	 * since we don't know if the next page is mapped.
>  	 */
>  	if ((long)src & (sizeof(long) - 1))
> -		max = min(PAGE_SIZE - ((long)src & (PAGE_SIZE - 1)), max);
> +		max = min(PAGE_SIZE - offset_in_page(src), max);

This isn't strictly the same code, offset_in_page() is:

#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)

So this is now, effectively:

-		max = min(PAGE_SIZE - ((long)src & (PAGE_SIZE - 1)), max);
+		max = min(PAGE_SIZE - ((unsigned long)src & (PAGE_SIZE -1)), max);

So there could be some issues here with type conversions at least in theory.

But in any case you're now making the logic inconsistent (the next line uses
bitwise operations directly).

So I'd rather we didn't make this change.

>  #else
>  	/* If src or dest is unaligned, don't do word-at-a-time. */
>  	if (((long) dest | (long) src) & (sizeof(long) - 1))

I'm generally not hugely fond of this 'do a sample case to demonstrate that mm.h
doesn't need to be imported' approach.

Either make the change properly and consistently, or not at all.

Anyway, I'm fine with you just sending a v3 as a single patch moving
offset_in_page() to vdso/page.h then you can defer the use cases if you like?

Cheers, Lorenzo

