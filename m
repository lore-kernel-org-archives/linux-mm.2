Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4DB8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4746B00A2; Wed,  1 Jul 2026 12:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BEB6B00B4; Wed,  1 Jul 2026 12:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491BE6B00B6; Wed,  1 Jul 2026 12:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 130C36B00A2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:33:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B64C1A0446
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:33:50 +0000 (UTC)
X-FDA: 84940754220.10.BEF93C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A73AF40002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:33:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJrnNlL7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782923628;
	b=3xylV89uOGev7984FT1fx5v3Hg4vu8X2A5nxtuyR9HyjZ5ovxD8AcrnQobb8czJ1edR3Ec
	0lPosZvsEgml9y8b2tbUVm7FRfJKZz7xLDJZ7KTpWvDNcsnYActKeDS8vZdujlsDivs/Lk
	CtSFjbHK1JZv7l7dy9V3sUI3bZN9w/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782923628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlSosXq4Ezqh92z0bDbyTWTwDYN4DfcajsUxP9yJzOE=;
	b=k0fURGfma6KiTSchCxwqbwvjf/8GtJEUzm0i4AyzskwKqCoaUbM9J96/U6NTe0v8HCOnOb
	EQ/cFlqbLjF+TXEZN6qC6lyT4TJ4OLeAVeKq0wRaNzun7YAHo8AlgW7eFgIPbCBScAJF6V
	zbu7c0RmObW0e9i645/aPD2KjdHlOwM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJrnNlL7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F16FC6001D;
	Wed,  1 Jul 2026 16:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BDC1F000E9;
	Wed,  1 Jul 2026 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782923627;
	bh=mlSosXq4Ezqh92z0bDbyTWTwDYN4DfcajsUxP9yJzOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DJrnNlL7Z/m8vxwcgmD5SdPAkttidBQgDgZYJFWQqAz5vPFneHCPRzCAkDg34TE+t
	 GB1rrWISmBuEiwEnKVLsCjpjtRNJ+Pm9KxyKTacU5f4m33xZEn7M8WJ7htMiVfmsP5
	 VsP0RFGAwebesSypdFclnHAtvJhrdrvJKxbP6bw3mDN1THAkNhrjhwhVqiMTFvry7c
	 N2Q9aLwI6NrDaT4Oj7cOrr8+kbXTc4xlqHiC1jITF1Z5mFlZdqbP//ulmVwEQqJ8o/
	 LGtbJmx7D3w6hBvm/1LoHFznhMoTjdFNQjw0DRH6byZ9ojfs/o9rCapQHozhncUiTn
	 3oXCkwzlL+/Tg==
Message-ID: <d267004c-a09e-4f04-9635-d1acc579d89f@kernel.org>
Date: Wed, 1 Jul 2026 18:33:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: set PG_has_hwpoisoned only after new
 folio head is established
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 yang@os.amperecomputing.com
References: <20260701134622.3152896-1-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701134622.3152896-1-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A73AF40002
X-Rspam-User: 
X-Stat-Signature: rdg8sfnqqxmxefdy9qf4iofpo4aoxjbd
X-HE-Tag: 1782923628-646729
X-HE-Meta: U2FsdGVkX18jAIUoxj7nDe4mB0JqXQyyWL/fQ9JtEvkDawYpepkvgDjKLkePdsiexYzojVFULQ6ywbWMSaa49PcK424Pdyi/yvlR/czRX9WefMPPiMWNmSNlHKK1VJQluPg0AJoIW024w0EEVbsGbXmCfUyfznV3fj084og9W9f7y0spX2dA+HGp1qgcjmV1+FAjOSQjAGtZLDVbX4riKnGgWOxN1CPIGl6rwalfkNKXx8oip0iuSo668XtoXuXbL/ZfGL1w85nky9cp6imYTA+7BcBOQAe3CvhfashYgEK2Q2aZ0D1+lEXCTwmxF4OZv3B8j0uK44A9BAAzLCznr49Jehf6SeMStpsIrPk3vegHBpDCx5B+iKXvKYxLZpDR/sssrofeKkbRxS6NdbAScqxzQJ1gzZlP/oNbAHnsD5SPyLCnrMNaQKuZYESZXyfegwBN9LVTuN6wfZXWHjzW4eNpg7vMILlSj1GvR7lUcX5YXf0R30HNWBodYfUBnTs5uaeCbuglxB9rPmAZ+tTIQ10rlisxitBy0snA1ddSSsOwLkphAJ57b8P0S4e1+q+/rPV9faXYwIz+hBJbIS1ZJT6Fqbyoq1TcDX3Z5SMaCIV8JNckcGceHKZ2UBDOxntTcbhcJ2of9xG3ljbaJnuLXLTmdOAGpjQ9vxbAnlBfUfJGWBp5zwtTJ0jZ/S2d2/SDeZ+Ov0rUEfJ+8oGk5KbHg2XkVImGDM8ASh/5cmLiBuwmme2KqOHUnHdiRpaS5epL0fNYwW6eTpGutdQwz2IAnAYE+ybYKzpruRq6ZwKS7FB0SMjWOpFXq9OHLeeb24ixrLVemvrvzjFCA5/nxmkOIxBlrhVipu0lLvZx64i3kJgpj7tdnXmzpFO8mD00lNXQqllyyTMSjjG31iKPr1rTK5pQ/cP60JduZ4utu+MGub7mRqPEgKlHOsFNoyAxFfoksIXN1s2x3MJ23jASa5N
 uMuNUaG8
 CcFqYULuICjOKVdFEC1mlfcqdfm3a1WLrfbSls4Y3eNPVtDF58nj0WP/n6l4UEdSZ0Mixe4m0ElIGV11aKhrRnfQrGrHIIQBxvjn0eqc17zdmNvwlG6205M5qcnkB7/rIfKK3TG1Ihf7TQRvSNB5DdCcDNLuhSc1Jx5hDkIMuDOXbMdx4rjMGKEzfRfPwuHbIsYgqfGCZSibqSew9TX8oamVSx0nueSAroo4lr6lyX9JQ451py8pAWaLP+keYDnZiM+LK3T/1X1jlXjJAuyt0+o8r0lP79dpLIv2L6f8QqTL0QUIDM4mbz8fSl/EkMlM6wHtgIA+02SloIor/BWaQVZheBofS5On4EvIAxnI1yyXIZSzcT9uVFEfe3kBpijr9Nldy4qpPUxvTVo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 15:46, Rik van Riel wrote:
> __split_folio_to_order() copies the hwpoison state onto each new
> sub-folio while splitting a folio to a non-zero order.  It did so via
> 
> 	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
> 		folio_set_has_hwpoisoned(new_folio);
> 
> *before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
> turn @new_head from a tail page into a proper folio head.


There is some grammatical issue that makes me wonder whether you are talking
about the present or the past.

"copies" ... "did so" "before ... turn".

Should it be "does so" and "before ... turns"

> 
> PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so folio_set_has_hwpoisoned()
> resolves to folio_flags(folio, 1).  With the new compound_info-based
> page-flags layout, folio_flags() asserts the page is not a tail:
> 
> 	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
> 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
> 
> At the original call site @new_head still has the tail marker

"current" call site?

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

As Lance says, after we do the TestSetPageHWPoison() in memory_failure(), we
call try_to_split_thp_page(). Does that already suffice, even without the
MADV_REMOCE.

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

I prefer the shorter variant from Lorenzo.

> +		if (handle_hwpoison &&
> +		    page_range_has_hwpoisoned(new_head, new_nr_pages))
> +			folio_set_has_hwpoisoned(new_folio);
> +
>  		if (folio_test_young(folio))
>  			folio_set_young(new_folio);
>  		if (folio_test_idle(folio))

LGTM. The folio is still frozen at that point.

In general

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

