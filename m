Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D903CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 10:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4EC6B008C; Mon, 18 May 2026 06:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D026B0092; Mon, 18 May 2026 06:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA656B0093; Mon, 18 May 2026 06:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A30F6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:24:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0609D14091B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:24:32 +0000 (UTC)
X-FDA: 84780156384.23.0F5477E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 49F7B40002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:24:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pSv2y11n;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779099870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fx+ePPNuEYAGsCItD9weYpWAlNiZqA721iNmo/gjnY=;
	b=PIqR174ffiEKSMGu15AjmVcnkRulYSQYnWiv7lizg6tTD3r2G8wPHCaa+JllHFAjVZERl2
	dMmiazNDy9jsnHv+Y6QaxNrRuFWkphczykmmA+muxoVF2Ew3JOXdj5/lJDwRoUbanQ5jQ7
	FUfTBtiGzquQtwOSJn5f2MKnWWQLGfg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pSv2y11n;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779099870; a=rsa-sha256;
	cv=none;
	b=XuqbwY/VdHYre+dm0lr82ejyDFFWo3Lreq2YS0pVm+CrwWuyX0Adfu7AoE6wLcSMtN6nFm
	wSKAIYp8U5OrP81NygvE6zIbpu1wKBaT2mm8KRd5hbSDTb9KQf7ZsDiW2gWFnF7FkbpHQd
	/QEHi5HnXpsLa6CUZonsTSMw+jXhV88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A16A43CDD;
	Mon, 18 May 2026 10:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56A7C2BCB7;
	Mon, 18 May 2026 10:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779099869;
	bh=6Y5stbvQWHXLcA7XjV23eIeFyPchwtbQV2KWt9Ea000=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pSv2y11nGB9K2eENajyD7rPgFnLZs4LLW/VdcTdSMcaj+qLfHahfeHz9JYVwSvyt1
	 R/ywJTAJv+PAlXbwsEEo28us5H4IyGKs+aPOhFNoo+EH/zcKJLRUMc7DYQmwn5exzj
	 ZYW2VRhLwdoJ9AXAz6xCYXbNhks8bU1AlM6bJRc1WY0yfM7YimdLQ2gvNilYuxZm0/
	 a7W850FWlz87m18MFFFgew5f9Hu8avQSaNQgsziBIf8KxgKV2+2immEyR/NhtGNzvx
	 e/k0AXGqAnVw4bhzUEowPYMzz34cXIx2EinWcFA7JKh3uN9dF4HW890zaQDX3JAA9u
	 MkA6antazQf4A==
Date: Mon, 18 May 2026 11:24:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Andy Shevchenko <andriy.shevchenko@intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
Message-ID: <agrjr91mgYGVpixV@lucifer>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
 <20260517123428.1181981-5-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517123428.1181981-5-thorsten.blum@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49F7B40002
X-Rspam-User: 
X-Stat-Signature: of18gfz64uo7suojfbuerasmq4wfrti1
X-HE-Tag: 1779099870-975088
X-HE-Meta: U2FsdGVkX1/EEwXWJIYywDygNZaGAWlOLFEArpzsnCNNohGU9eQQVl7LzM3E6aaHGirvvR3IMtwccuskXLpPCc/KQ9wlGiFQZaGtHjVcoRNATeaLHM2PGDJbi6WnQUx1SKau0sO/fVL0I/sjQ7BLkJIkI5iFy2JaFisVIq3PR5VLA1YZ1B+EFPw37o/LPA7xUmE2u9Us+h2mlAn87HgcidG70l8sTcJGF8AlJOt1pkamP9pzDmm7uUwuvoJKG05ZWMnqItKUYbTdEh3vo5zwVU3xG8+8BrchNs54a/1eaobK63HO87jXVRecdjJ1YShqynEASWRaH5zxe3FLc3ec+t8gX8ZpqRsSUgF5FZ9vcf0KaaSW651ID6d2DN52w66aG9yVH4iWD+9wsIhxpBl8wPBfUa2/r3Lbqq3f8nRzdfR2+IGB0tU6F/NMO3DYoj7b42YVKw+xAM6YPWsuXGa+Z0qECf2sN/L48kEomjQAZc56I9nMgyLTH16rS7OvWjZE59F3NpCHm/hUTKWT/H4q169bXW5MnLo06pMlxTl7/jMOty4yAGtYjnY6792hr1WxZF/92l5zRlQrGzv3buG1OimJtmK4wUMUYQS4MbUvIH2fbUlJLR/YMpNWfvQX6xtFn0AdztgTIX20XBXC3SrXWqvYoH4TaGc4rS27HT7gpGEg+Udz/Th0lKc3kyUS2z0JLO9a9H+zlaRNfo9NgVnAZ/EThIrFhRvTkQxkKljCoSxP9bMDZt8PdD2BCUvLdLHwbQYD87a4mmDXLMQfCSpz5IXeKaN6nBy2lkTjzv63nRtTCFJjYmqA5WyO6yJ2q33htjOK+wDdByBJOwItTU5fJB0RbSc9JaArgrIv2qkcHjEBKu1h1P4adZoBheWhGlt1NW3bigQDw/QFNQccAvU7W1gE+8mHwfSH0Kf2eRJA8uT6xSkD/hh0690NbiIutGwXn330dT47T9ojN75D5o/
 Va49K0Af
 UdMBUPPvjlZI77vJhxpz4Ddv2DjXIOTTx7H1HUt7aLTzjTB3C/HiGQrBUfx+rhFWR1MOf2qYZdvZsiaDLkQMTqtFJU8igBaYpE4ypqz/9f83BrNX4Qv8zv/49WFSUHtjzgKiOH6eLFd2ECm6IZRBKb/vC/S8W5Q8A6IWMeg9MHqMz/WEhmiq72CpRIsXk513pB8XCaZs1lRmw87NMgAfXitEdpV/9LvyjqzvRoz44ysu7KybnhP2QhW+FcFOubesb0Wf3XLQfdQMwTDPSTj9HDJsGcL5VjH+c68KieBhsI3BOn4yvyuLEnePB+Tq2Tm9qvM+Ub6ekv+fJRUxjIIxfQICF+mqYF4te7eFQZ0CJhwXvbcLQaChglT7q15MlIplZ9CkbAAjQ17+lLQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Why is this a separate commit? It's tiny, I don't think it needs to be separated
at all.

On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:
> Add bytes_to_page_end() for the common PAGE_SIZE - offset_in_page()
> calculation.

This is a totally useless commit message. Again you're not indicating why it's
needed. Please look around mm to get a sense of how commit messages should look.

Also it's so common that you have exactly zero callers updated here or
elsewhere?

I see uses which are all pretty specific. I wonder if it's really useful to make
this its own thing?

And it's untyped and etc. etc. yeah, it's a no really to this.

>
> Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>

Was there a previous discussion that led to this series? You should really give
some background somewhere (like a cover letter, and if previous revisions were
sent, a history of them below the ---)

> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Again I'm really unconvinced you need to do any of this.

> ---
>  include/linux/page_helpers.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/page_helpers.h b/include/linux/page_helpers.h
> index 102a4f3c3868..981731faa1fc 100644
> --- a/include/linux/page_helpers.h
> +++ b/include/linux/page_helpers.h
> @@ -6,5 +6,6 @@
>  #include <asm/page.h>
>
>  #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)

I mean another thing about this (and yes this was existing but since you're
proposing making this rather special it's worth raising) is that it's enormously
un-typesafe and 'p' is vague, what if somebody put a (struct page *) here?

It'd be better if it was a static inline function, maybe there's places which
use this already that require it to be a macro but perhaps not.

> +#define bytes_to_page_end(p)	(PAGE_SIZE - offset_in_page(p))

Here, since, you're adding it, there's no excuse at all for it being a
macro. And you're implementing something just as horribly vague as the other
form, it's not obvious 'p' is meant to be a pointer. Page begins with p too :)

Anyway I'm not really convinced this is useful.

>
>  #endif /* _LINUX_PAGE_HELPERS_H */

Thanks, Lorenzo

