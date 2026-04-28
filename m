Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1109FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 12:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248E76B0088; Tue, 28 Apr 2026 08:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9B06B008A; Tue, 28 Apr 2026 08:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9546B008C; Tue, 28 Apr 2026 08:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F159B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:27:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 927241B5A2F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:27:35 +0000 (UTC)
X-FDA: 84707890470.02.D31FF80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E5F2A40004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:27:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtFCNgTA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777379254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+nw3VMRR8gk+12f/ytlqVALMzBItCfI1AiNwTibeto=;
	b=ZyrB+Y34eVOyX9rVVDbW5NZQl6eEMFfTgw7A1cofVYxN3RXpDj14lFffyGbz2PPsgvZHU/
	zB76Anye5ZbwtP6ASj2YYLwz52CPDLTiDdqwewHMJC/eg/RYPT7U9nX86nLhuHDcMGFOcQ
	dHL1I5cLWFH+n6OMCDz9B4eOSJY+hLg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777379254; a=rsa-sha256;
	cv=none;
	b=aHxTpuJJJUpgcc/WM6Wslt1y94ECJaF+5PmeoRjvp2fLXzOx87tStzaoufcfvz5Q/9iMjy
	VvRpEaAaMeBNwVURmtHTmFZpE/jySww4F/ZDUhXeh2zpIwWUphi7UFoFYdRkEjQrX7/9yB
	mM05IkLJALNM2Pl7ttylFo0dcKw+QHk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtFCNgTA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC82A405F6;
	Tue, 28 Apr 2026 12:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0504EC2BCAF;
	Tue, 28 Apr 2026 12:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777379252;
	bh=oXW2BuxDEEJJgDVSv85Sq/XrKA16JupO5CMfYwPGdtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TtFCNgTA2p/mjwznidoIND1qLBGVv3UQduA0gVwAsewf5q1TlbcO5jwTODxHc5JoN
	 h1RCw0V5QVuBkeotKfTgdSjuW5CO2ySjpRm4tI+y7L7FuAqaa7Dp9QQ69H7u8Ehn7i
	 IC7yJnJQPhLrycdgF17ueA+2wox7S8UIsB00pQqIZomyw2wX/EU2MWDh84xmHzN0sV
	 DJ7XTFv3JBHxH6uuIy352oeNt9n8HWU1MprKg+AIjkg/gVuoVf2oa5dWa2tLl2fAmA
	 c0QmFGBXbzw9Lt5wv4wdPuEWr6Ri4UVEuxyRnGA4fOBleln596cayCqahje7lwUg0V
	 cLm2ZHZXfE+BQ==
Date: Tue, 28 Apr 2026 14:27:23 +0200
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
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Message-ID: <afCnq17NWvM4T4vC@kernel.org>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427153416.2103979-19-ardb+git@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E5F2A40004
X-Rspamd-Server: rspam04
X-Stat-Signature: krupbw53ujccbia55mw4gndsd6zjowdq
X-HE-Tag: 1777379253-68157
X-HE-Meta: U2FsdGVkX1+o0Jtb+bBGFnpR+pR8X2Ahfoia++oPmfoDGr3WyCCDzdte16Vi6xd+7EQbklij0NzU5rPezBObwrhanLs5ioz8puMYRdKO1wp/xtAJmEPI5CS+xN2nC0QOg29L9BEOC49wzFSAvD4p4dnS/PjEutU/01d0/btW5WYUXF4wheOxvmJZeI3xC5Cfacjp2JIjZBRVc2M8rpIiHyUDmh4yuQdbgmZLm0jIXXWSo8TIawxzzzXCV57A+bMhvdU8062XSbrTWZFLdWR8mAKLIt3dyB5QNqPnGUcK1EZT6g+4Oe9IcoRUAG9MoVd0b6n6RuPTqixruvjE/wUWuNx9l5bDZTiq6V2LgKUsgFg7ArqfyEgvroNDvr9BMap5s68vcOKAH3tJ1DgWzdccXPAf9gFC56X4HRJv62lcjWst7zLM9ELj0EsPfmxd2CiQpmSSlCELHeeD0UilH6s93Ps75iagIhZPn6JeSt9vhQxsCULZJJP/HHhHRv9sfJKvCqjQ0R5K1l2nIFDQp/Nsc/dclIqPp+SWV7fPgSG3JnrIbHEcc2rLWR3SZwWMVhp6OwjPOFG6vtirPZy8v7skJ+DdZCMeApeSf4RMTS+N5EvVzGJ1NyfIOgCkHz07B9ARGyySzzF3sPJJfhifpLgdifZMztdKkkzzC5GLxgJEFXNl0i/7srH5OZN5la58BnXoYkB3Ec5GlktCpg6FN+r17lIQLjJ9UTSl2oRrUYsV2iU1TrlgNMqGwhW4LHahXiYKiGBPuS2CnioD9lmV5S4rMjzPnGg1j0lD755OKf3jaVvdoOYWn+CJE/jLtRhhurBk6EJ7//Cv7X/5MK3HzSq3wueks845bTsb9U7sououGbJpAcXc+KliJnTEgDMruG2CZj/yo7luWdAincOhygb0hQuIWmcD92gz/tYho+YW3Qfr29rdbm5HLiPAeNbKvQlPnC4qNLINS3s+ULYW6v/
 bpLm7Igp
 5t+/Piy96Nmf45n+OlvMPj4KFdtO31f9CWdIr1ZOUI9ejPIDSTOBttBXwLr+OP7E6vUkQyGUcbLAu0ObbFso69VGDJ0/aCepxNTDRqOoIu/X53Y243RyVqSdNv0jF467+uAxKzZMuzllDclz/OipOxa9GUya7dBV5TcpF3HK/CYSNBLeJNX0AydF7Wt4IX6y6nKikjEySPGrA54yUOZQW6sbisQpjusaO9HuJNvwdnvZsTMhX0ipVlvfDkSQm3zOk/PVZzwWBhObpMKbgURxrZqu/jYqH8y+6SvylaSCNwDbd+GVU8VGsRbJkvbUS/g8JyQ6G/k3bArp7RQBH7T25wdR8LXQJXzGmmMUND+XfqYpdjVGeeysz/x/YBGZhlrM3xAtngOVyT5F1gktGKp6TZYk5Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 05:34:19PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The empty zero page is used to back any kernel or user space mapping
> that is supposed to remain cleared, and so the page itself is never
> supposed to be modified.
> 
> So make it __ro_after_init rather than __page_aligned_bss: on most
> architectures, this ensures that both the kernel's mapping of it and any
> aliases that are accessible via the kernel direct (linear) map are
> mapped read-only, and cannot be used (inadvertently or maliciously) to
> corrupt the contents of the zero page.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..6ca01ed2a5a4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
>  EXPORT_SYMBOL(zero_page_pfn);
>  
>  #ifndef __HAVE_COLOR_ZERO_PAGE
> -uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
> +uint8_t empty_zero_page[PAGE_SIZE] __ro_after_init __aligned(PAGE_SIZE);
>  EXPORT_SYMBOL(empty_zero_page);
>  
>  struct page *__zero_page __ro_after_init;
> -- 
> 2.54.0.rc2.544.gc7ae2d5bb8-goog
> 

-- 
Sincerely yours,
Mike.

