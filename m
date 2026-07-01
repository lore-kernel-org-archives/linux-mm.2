Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EEC6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601816B00AB; Wed,  1 Jul 2026 10:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8CF6B00B2; Wed,  1 Jul 2026 10:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516F76B00B4; Wed,  1 Jul 2026 10:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29D246B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:52:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 906A0403D0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:52:51 +0000 (UTC)
X-FDA: 84940499742.20.4CEC364
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F1269160012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:52:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+voNpCR;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917570;
	b=mtG2xt2n9ZxtFpw1ZGcHCxxPHO2jWw76ZrTfbFl6rKe4etM+IHkxBFqbqHwYa7tXxoLv4U
	005poE8zKwxKVsWPgQq9lP5kKFHYwIeZvB7pWuog/gxI7WIEMUw0wvLZ6RZFBZGArvPZUN
	F1+niTCsVVFrXU/EtP0wbNjbfdoXKp0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PMuOMB8oQMmED+VTExnHBYgDYKgq3h680UUULi7v7E=;
	b=64HvvI9l+LU4jMnDJ1u8a0XdgYkXxU7Kh1ZBEer/cPOzwbXJEUhEYzWIcDMw5YhDWgkJjN
	wrFBnWCTPC4V9u/hKp4nRYIM0z9mAQ/U7WwZup5dVRK4VKc3O0RLyZKP/pEJiM2G+aMdOo
	iHJSS3ebl3MYr9bu+dlx532I6a2LDDQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+voNpCR;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 901C66001D;
	Wed,  1 Jul 2026 14:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59BF1F000E9;
	Wed,  1 Jul 2026 14:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917569;
	bh=3PMuOMB8oQMmED+VTExnHBYgDYKgq3h680UUULi7v7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I+voNpCR/OqqBEbboBbDgUgzg6w4E8OX8t8BJTRz5LxscDmx14gIg/I+GTT6Go5En
	 xx2WzMwLjKG3JNp6q4LBxu6tdzFx4KlJ5XBdV2I0QIu25zFI6yIT+YDI6V9HvJvH54
	 rrwWWOxGiT/mXdpoXHWZLZDHD+ifZBOtNQ9HJ7ijbKe/IWJNoxK39ao5l58GHwg4m1
	 4V0HEmZzX67RlkSyc1YSIOZdh4HRKHfcnA7+Mx6rIpbMVU5ekq3jcHW9KzQ9OI8ugN
	 /ezRHMhgA/qgykeOF39lwG0X/4hBHUi/p5RB7YXXmWvKpQxTfFmWNGvaeXuC5EasgC
	 7RMG5tbjD6v2A==
Date: Wed, 1 Jul 2026 15:52:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, yang@os.amperecomputing.com
Subject: Re: [PATCH] mm/huge_memory: set PG_has_hwpoisoned only after new
 folio head is established
Message-ID: <akUoqvmGtSMgD0QT@lucifer>
References: <20260701134622.3152896-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701134622.3152896-1-riel@surriel.com>
X-Stat-Signature: zoixmknubmtat8mwq9mkyda9uisjwzxj
X-Rspamd-Queue-Id: F1269160012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782917569-540904
X-HE-Meta: U2FsdGVkX1/cSaOM7hCXZqvuQ1wnQXJYP91C15bUXASEX3EnBVpk+aQYnQku4yOnDShTiPA/pnK7SlL7fWq1cZUrwl3uYUzeuwnqQtvrFcSqVHedmUSRS5UWjLivzD8O22A49bennNTogRD6vxFEbQlj2Og5mi7vIWy2DD8PLqOt/kTzpxHoQyY3ELYMokRAd9LaH3d7wsjS9yzt+A9E/B41SJmtybpZ74pHziwj9rQl5NUfNIkthkELMWOEA3mEiuB1Hyn8gHFlUkRBiBgMe6uAc7ISrP5v2UUHXX7G9zE3NtTjed1rxg5tinl3pcOYHAg/3sD4gS1/o2Ms96ZJtIR2k5fmDjrsEfi8RPgFS6UdoBZlvBA2Hh/YeRgz01p8HAaj5Co5xklxZVW++0O+st2gOqBzB/KT/XBHee3Juq216jW7L59yrGuM2Ymgn0WkCvauEHYFuPERyL4cyLERlzThiMi1gbdDHpwKR2B9wozGBiMsiKAMsHz+njjFWbG0Q600GYpXN2DTBXfTVsYJVJUcra7KkAfbWKtU/4jE8SBVxCMNMEWAGbQFvUHJlfZ9SqJgVjepoMHyQSIo5u8WNlKocPKMCpeH5svVcQRlJYMZS+cmzZwv5ZZl1dqEqcPK3aq4Xxs+DC//A+NBRiMmrkz7VzhgafrqwGhSNeGNlojp8bzKnncIuQ1q5FxIj/OGyWTcpEYwAi4y2MvFnm9Fi5Sudi5ELQ/ADf6sCamQRM9u5hroThD3ij6Tt6RKAzQB9Cir0TKcNo4A8n/LoFP3Lr6MfC8uplY95+LqxO/UadbhnwXQ9DbmmD2qVwtg3IJNuGmcqn1iP3bevyQRCEuCcNjRR04AYP58wzZVu0w7vMR3BnazmZ04wuONcSzam95TQQXDrJQgpZ4RxRYBOYYlFSVmOfxUzOBSij/whOQW32XDdjUPhhrNaIvg7fxndyP3UjF7qFvXagHO4vJfTeP
 m4ZSDmsz
 VSKHHKzBxpQcz4zse63GbLd1LvIBlHQGablRJSPFTQYVz5P3MXyEDK8PGjDCkhYn2fSZN3zmiZkMCBWGjVRENtt+GcbK6QA9DNnhgv+sDjkyfEu3pNYrKgEVjvdEaHQCCxB7j5+AE++Z6bQ79Atx2VsZVyiHLWplh1SOs0eX9LeAzQ5xkfzZMZ/fGOTW7SsICHoO0CNtVo16lXfmbsy89Hpdc1dfsQVbKmDX2pedSyjMHZh8/kGIOdE0UCwXw5cESekBmVyEWZtzc/6oQyCx+UQLB8Eo+EpBF07SMj8fQafvztzclOli40dk9ujPQy2ARTAUr+1TvzxeZ0jxA60qI2AABTfnJwcqzTDi2WGqj6/bpEwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 09:46:22AM -0400, Rik van Riel wrote:
> __split_folio_to_order() copies the hwpoison state onto each new
> sub-folio while splitting a folio to a non-zero order.  It did so via
>
> 	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
> 		folio_set_has_hwpoisoned(new_folio);
>
> *before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
> turn @new_head from a tail page into a proper folio head.
>
> PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so folio_set_has_hwpoisoned()
> resolves to folio_flags(folio, 1).  With the new compound_info-based
> page-flags layout, folio_flags() asserts the page is not a tail:
>
> 	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
> 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
>
> At the original call site @new_head still has the tail marker
> (compound_info bit 0 set, PG_head clear), so on CONFIG_DEBUG_VM kernels
> this hits:
>
>   kernel BUG at include/linux/page-flags.h:354
>   folio_flags+0x82
>   folio_set_has_hwpoisoned
>   __split_folio_to_order
>   __split_unmapped_folio
>   __folio_split
>   truncate_inode_partial_folio  (shmem hole-punch / MADV_REMOVE)
>
> Reproduced by syzkaller: hwpoison-inject a few subpages of a large shmem
> folio, then MADV_REMOVE (fallocate punch hole) on the same range, which
> splits the partial folio to a non-zero order.
>
> Move the folio_set_has_hwpoisoned() call to after
> clear_compound_head()/prep_compound_page(), where @new_folio is a real
> order-new_order head folio (handle_hwpoison implies new_order != 0, so a
> second page always exists).  The flag still lands on the same struct page
> (page[1] of the new folio); only the ordering relative to compound-head
> setup changes, satisfying the FOLIO_SECOND_PAGE precondition.
>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Assisted-by: Claude:claude-opus-4-8
> Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order")
> ---
>  mm/huge_memory.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..ee7ecb3b45c6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3587,10 +3587,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  				 (1L << PG_dropbehind) |
>  				 LRU_GEN_MASK | LRU_REFS_MASK));
>
> -		if (handle_hwpoison &&
> -		    page_range_has_hwpoisoned(new_head, new_nr_pages))
> -			folio_set_has_hwpoisoned(new_folio);
> -
>  		new_folio->mapping = folio->mapping;
>  		new_folio->index = folio->index + i;
>
> @@ -3612,6 +3608,18 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  			folio_set_large_rmappable(new_folio);
>  		}
>
> +		/*
> +		 * PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so it can only
> +		 * be set once @new_folio is a real (head) folio.  Defer setting
> +		 * it until after clear_compound_head()/prep_compound_page() have
> +		 * turned @new_head from a tail page into a proper folio head;
> +		 * otherwise folio_flags() trips on (page->compound_info & 1).
> +		 * handle_hwpoison implies new_order != 0.
> +		 */

This reads like an LLM comment...! A ton of noise and unnecessary detail.

How about:

		/*
		 * PG_has_hwpoisoned is on the 2nd page, so set it after
		 * compound head prepped.
		 */

?

> +		if (handle_hwpoison &&
> +		    page_range_has_hwpoisoned(new_head, new_nr_pages))
> +			folio_set_has_hwpoisoned(new_folio);
> +
>  		if (folio_test_young(folio))
>  			folio_set_young(new_folio);
>  		if (folio_test_idle(folio))
> --
> 2.53.0-Meta
>

Thanks, Lorenzo

