Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73172CD4F49
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 10:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB1E6B009E; Mon, 18 May 2026 06:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2E76B00A0; Mon, 18 May 2026 06:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0F26B00A1; Mon, 18 May 2026 06:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD4886B009E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:02:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E5F81408CC
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:02:19 +0000 (UTC)
X-FDA: 84780100398.08.8C34215
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9BD51140014
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:02:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p15rCHeh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779098537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHnJLnrw34B2ApUcitI23lsxc5xjhpZYywRxwhIsURM=;
	b=ZbYKiX+zetfgWKvRZypY+0TUD6MvrPqLQYQtJowDJhlx7RCSYRJwSpE2fR4YQrypsYbRJJ
	+b7iHpA3HphSGZRZa5ZDQXwMV2cT6Rs10fXw6xDDQ4eFMvehGGO8WFGvtdZvdUSkmaC2bo
	bjWY5JNW2Cvj/dG6fijAoZI2ktuCiCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779098537; a=rsa-sha256;
	cv=none;
	b=1FOgTl72DKRSSRjCvIEdhaQRoiPYv1kWXtPDbQVYHi1m77Ah4QhY6lxvuPNuOtFti+VCcr
	89JPhBR2Uw88dAQKtwI2+U+dHnk9fcGWYmUfDKlupcDs1ZpjTADaeTGeAovfjSzUqN1REa
	vgWcQhyeDRbj+1sDZEw/ULdLRC/Sl8g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p15rCHeh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B750543686;
	Mon, 18 May 2026 10:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3D1C2BCB7;
	Mon, 18 May 2026 10:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779098536;
	bh=245OjriimBApEADiIG9W2/9D46Eaq2BiEAto6PMcNmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p15rCHehr95vaYiLupeX7YWH3GyKR55jTIISY6xUvjoiX1iaPu18zOGeAi9KY6vyq
	 xupW8s/cAMawEJOH/pGX+3KaYckC6KPiMuvCGwSgoP3j1infTztKgNtvihrm4GThP+
	 ZPYGLNeDo1F9piLXcD5Hs7uLMX7YvsIH6BoByYwv1ZBT/1mF/tRJrkTjWdTL2Q+GES
	 010sajgQ7x+ugf1/8/bQ2kkAvX8+7103C3xemAZQA4UTBJJ7DBwzWSdgtRzyNx9O9Y
	 e72A4qn6DEmuO/39oSBJdMdqdEzashtu2m69gzn6lEafTv8VghB1SWfq/k1ginhJ1j
	 JTAzRiMiK7K5g==
Date: Mon, 18 May 2026 11:02:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Andy Shevchenko <andriy.shevchenko@intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: move offset_in_page() to page_helpers.h
Message-ID: <agrgWscr26Kj5yk0@lucifer>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517123428.1181981-4-thorsten.blum@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BD51140014
X-Rspamd-Server: rspam04
X-Stat-Signature: 65my6rxhhrt3okd7hnps9psicxmjdzne
X-HE-Tag: 1779098537-179505
X-HE-Meta: U2FsdGVkX19zHvnuzQmdrrzqLp4B/GyAxOXJM+8L7LLh+rP8l0ceWnqf5RLE0WDtn4gYD6g6hLNUZz9ggywdxZpKjeqHEIx36EMrEAj2OajYUNekuluAfUbK2cfAiSmBF4BblDnzO7RF2EqMlMHrGkOADnlCYQ9Yq3VvehOQyQvG5LlYL/wx3/kCqDyt/NDK3aqsru63kfl0cOsV8Jey68UpzQV4TmZIXNI5xmwfUWJ0Ps/KiuwODnC6u+V38GXOnQdJ7s0XHYsTqBqFWT30HycHgzDTlOHOIVZ3YJ2un2qwvN14XXwxnaf0SYJ8IdWxxaR4RYZzixpW6tiyR6LjMVmgRvL3NZB31jtlIU7ivwr+py2P6lcbyykmEaJ0wW5XMRFxE0EHSSTKLe8irCk2u1+6QOpPvDe1U2L469aIDgcSpTbvLXWJr3vuDm0E/IbvhfJiAaY+M1eh6CUX0YwJG5bGCLF/MrfeOGnbnYjeX7w96ZQdCPq6lzFCO5lD0Ii3cX4A8TNcZyoy0cIL5I8xmWBMawvIqxjbPU6kCCMJvXDm/LpQRI6vxZWl8dP6WLC9lv8kUU8oTgZRCgToYnQhl+mVGEXXXNnQosTkwLvGAr92YaAEm6DU0diGpw9So1RDzMRHEa72FpL9NnCkbP35EQPc9i9TjI78Lg4375lBR7m5fyCdXl64lG24jzwxCb2NlP7feR2XByhL4+1KdUKgWHx/jPOn0YlZvHK+QL/gWt47aIBZQH/oo6e/QWY6G6BLrki9GtxHYif+Dw7ebVKLbAUQAMXpiOTTYOjF8GVc5oa2d+etQiQIR34P1f3rL8Ax+T9zCHeD/3olgootlegcG/z/q9094N4Anc309LLd/TYu7j5hZTFHlxytTsNTgO/IFz18JFb4j8yp9Y6FoNw8H3g3eXMUeNrr/OuKa/lLsRfo2pZxvKBUiwQ8lGQyPo/ctuzKv7Len5tQvX4IWfM
 /r6VG9qV
 8mCFfKmMkqxD4Uok277WqvaYlRPo6K2TSJCD1PH1vAb/71h7Fa8QBLhOcFswGUN9n7zzxUonWnI4eS2eYUK5Iq+Pny6wdAcw2W0/iKd1dAGAQkMMC5SopZWFG4dh/WkLfKXlZaHKPn6+B0HPthNbqqUn2VvUV9wcoKf9mL7gdvUzew8csqysz4xQokGflV515L4BFEUK6kuZpQxreEWoKtuzlLHrE1A5dDOO/bnLz6HsZdBprDeE6AF+YCweRhLUdfsgabN2tj2drllM8QFurWNMLYP/Ug0puH/Lz/CkxIYEgpBMDHMGjeN/EMCFQoFCidY/WfUqVDv9Ckn48TjfezExm8ih76PpMEd57wrGkQzXcuPXOuA35TyQmaiP31ve7Xr8W2HHwd6AFfgZ+/HIU+NJYKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Seriously, please resend this.

This is 3 patches with 2 in-reply-to 1/3, that's not how we do series in mm,
take a look around :)

Write a cover letter, and have all the patches in-reply-to that.

Was there not previous versions of this? I _seem_ to remember that, but might be
misremembering :)

Also I'm really questioning the value of this, you've not sold why we should
take this whatsoever.

'Add a random new header file we have to maintain because it's smaller' is not
really hugely compelling.

Also a _lot_ of stuff in the kernel ultimately pulls in mm.h. So what exactly
has the specific requirement of both needing this define and (somehow) doesn't
use mm?

On Sun, May 17, 2026 at 02:34:29PM +0200, Thorsten Blum wrote:
> Move offset_in_page() out of linux/mm.h so users that only need page
> offset calculations can include this lightweight header instead of
> pulling in all of linux/mm.h.

What's the motivation? What caused you to want to do this? Why should we have a
new tiny header with only this define? What makes that important?

Why is pulling in a 'big' header file such an issue?

This commit message is pretty useless right now, you're just saying what you're
doing, yeah I can see that from the diff.

You should use the commit message to explain why and what for etc.

>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  include/linux/mm.h           |  2 +-
>  include/linux/page_helpers.h | 10 ++++++++++

You've added a new file and not updated MAINTAINERS, nor indicated that it will
be caught by a glob?

Also super super restrictive to have 'page helpers', that's likely to be tiny
forever, why not just move this macro to mm_types.h and import that instead?
It's highly likely it's already imported wherever you need it, anyway.

>  2 files changed, 11 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/page_helpers.h
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index af23453e9dbd..bf49e52f749a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -17,6 +17,7 @@
>  #include <linux/mm_types.h>
>  #include <linux/mmap_lock.h>
>  #include <linux/range.h>
> +#include <linux/page_helpers.h>
>  #include <linux/pfn.h>
>  #include <linux/percpu-refcount.h>
>  #include <linux/bit_spinlock.h>
> @@ -3033,7 +3034,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
>   */
>  extern void pagefault_out_of_memory(void);
>
> -#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
>  #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
>
>  /*
> diff --git a/include/linux/page_helpers.h b/include/linux/page_helpers.h
> new file mode 100644
> index 000000000000..102a4f3c3868
> --- /dev/null
> +++ b/include/linux/page_helpers.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

No description of what this is for?

> +
> +#ifndef _LINUX_PAGE_HELPERS_H
> +#define _LINUX_PAGE_HELPERS_H
> +
> +#include <asm/page.h>
> +
> +#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)

Why are you only porting the page version when ostensibly folios are more likely
to be the unit-of-operation in future?

> +
> +#endif /* _LINUX_PAGE_HELPERS_H */

Thanks, Lorenzo

