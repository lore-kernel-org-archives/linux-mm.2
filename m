Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E927CC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A546B0095; Fri, 21 Aug 2026 14:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2AE06B009B; Fri, 21 Aug 2026 14:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940B16B009D; Fri, 21 Aug 2026 14:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71BC36B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:23:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F5C41201F9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:23:43 +0000 (UTC)
X-FDA: 85126099926.04.4551A31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C0DE540009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:23:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kEproVlo;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787336621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5b7cFHm6oxeq9qapqN+UDtp45+mElz3GDxCrkZRNQXQ=;
	b=gw5wuWwK5OZoJfV56f3XFEzJxFwrWqfp150/NiD0LgQ8nRlBMIeByLFlzP3AwgEqpk9/eD
	9DQ4MG5NDa5US26kRV1Ax4gUr9T+BgOReZfj72znOCrWdjopyesr0BA01oIADmCdLrBomP
	kEqPeYkruERuBTWEw+j0/Q7rTv7rvWI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787336622;
	b=cxUNNk9STVtlhq9H3IbSZn21pD/owdmfYYY+IOzpTkM3gZGe1MRJoitKL5v2lS4fKSe2sp
	2suIdT0GKEbpUDXCOiC0uPTx49ufF0B3kVN7JV4FJ/CXCn5wvfgBbNATbasw5jFaiho+8B
	R3s8EE2KA/Mo2evCufwGW9j2RdZZRuo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kEproVlo;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EDD140B30;
	Fri, 21 Aug 2026 18:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354E31F000E9;
	Fri, 21 Aug 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787336619;
	bh=5b7cFHm6oxeq9qapqN+UDtp45+mElz3GDxCrkZRNQXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kEproVlofcbeK10ETFJo/e2EXWUuvC1gLuBkqBhw6Vrq39uN0tEkd0A3ZlPixzmRc
	 PqWR7iYi3ltMuIWXeQeRfClL32kNr8JJ34A3wdUbyiB7OPfnH77MXXr6r/JlZORJti
	 q6ApQO408oqqyl3z3tjYh39XLpq90vCGBRKM14sZeNYZUE2F0bPnqp3FVC7WnPhKPp
	 YQShYuMgNUQqZmGsNryzAw4ocm1mKL5DCae8+P+ch03aIgtfL+G0lLeoCD8zz9bwbJ
	 VeXfzxqy/OeLZ3vFBgbjckwgrOdxca8tPX8t0FDlYou+q6eKHkf469oaiNjvSVzQ8D
	 g9HTpPZr3Xzrw==
Date: Fri, 21 Aug 2026 19:23:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/madvise: use folio_trylock() in the cold/pageout PMD
 split
Message-ID: <aoiWZjgcitp0nSk0@gremlin>
References: <20260821150912.183976-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821150912.183976-1-gourry@gourry.net>
X-Rspam-User: 
X-Stat-Signature: 3cqhhsia78sftpcwck5tgerz9s38edme
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0DE540009
X-HE-Tag: 1787336621-38755
X-HE-Meta: U2FsdGVkX1/+D97VFErsf0sENOR2vaeqRJ+iFlYTKEIlL0DLbfauVNdrbyChOrM/hbu6+bl54NytbKL5SsCXP+cFRhHw49eNJXxy0YOAhTWv8/WaqQ8LhZRXMFTKN0vmO7uPOS7M8heN9NqKgqASllmfqqUppfelNfg+OwARRU+Dykf1R280P9KzrniuGSKLb13/PDN47qUzPjbSn626+58g3GEPM04yC1Nu4m0JGQuyaODnZT++/jsDSHnjJCK82Rra0oXtZXCnc2BiZEoB7MHixG0HvHf4iTOsF0sxW2KTO5dkRMKuQfNTJsW6CGlKukQos4qg7goC+MqOl7TAFMKwCnfVZmv9LPexTK1GCyn7nf0+9TFAri7xhA1yyM/Hc84Z2424/+eNEBwEnamsEn/HsJ8HiH2WbcEVL9gNg7TCG69gzOEZ1UQor33j7FMqkRZkNDkpCKX/aoYzp2Tw62IvnvbzGBKKbIfdI4SMXH0GkGnGY2vjn0yHkqDrQ2AIq+utsclOX7e18eZJLESDPuBBdJOmLB16lsDHWQ47clOEIXZP0vh7QSPJ3lhJyODq+pqAuy3SNu5wreoIu69TBgfG0MuueNNT2ZnbwItm2wDUkATdCqkzOR1W2IL406PbHT5TWh64iq2Ua5GcdW2nirASx8XhX3wR1JsfS2DHZBcE5O4k6LUHyTFumqqcmMvB7+rghPL+O2i8oAU7HkoI+SYFaPF3qp4bpUA9PZ9QcW5JiGv4nSCxiPpyLYm4UUo69zathUw+2nxZSosECPOUBHd5Wkh4q5FK+3DA4f1ONklT30ewH30B3Cg6LpG5vJUFAVwU5yLB1XSk40sDjFrZGGR8YAK4NNLxeCVog9eEb4G0NLQwN8TLShf0DeDc+pFY+DLf3yE8VkhRFuap4sEsLSpQKmAKzJZOqeTLMeZSSrLiuvL8l/dWyRRDcb3oeo1i4hM8D3oq3USsdJJrL9U
 QdV7AXSH
 OKnho0uvydxKQ7sctHjhgvQOYtOOmUfiff2O1IzsTU1QX0uWwgb2DjiDUoI5eqOSMRRmiw+YBBTOSW1S2LWTMaLsBbCGZuF244WAWqY003sT/gbD6ra+w2mu7TiBJYHUN7tqFiL22HI1LKzUPd2nDaSL0dmXqHfISqX/SaZRyMitWgGtjB9tW6jMhNGm9MgLiixf6G6clCP7m52NoqWwYT7deUY4OuFpC6HDb3P2EBAqigY3NK6uEWst0J+CHa7LINPujoPQgbiWqA1ZcISI70mooQpwI4Tr1hGnfB1SzaQQxWEos7flsi9jC4+pI+PC45jIM+NUFYdflsfSnDmhIgtJuMz7se1Y80AiJ8zWgKBt+I3gGTxGPrdYRVhoVN4R4KzVu++z42I+IaQEZhh7DNp9/XlmEPBzG5suN1llYpNJsz2Z9wZMR9xmZNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 11:09:12AM -0400, Gregory Price wrote:
> MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
> madvise_cold_or_pageout_pte_range().  Two threads doing that to
> the same THP create spurious failures.
>
>   CPU0                          CPU1
>   ----                          ----
>   folio_get()
>   spin_unlock(ptl)
>   folio_lock()
>                                 folio_get()
>                                 spin_unlock(ptl)
>                                 folio_lock()  <- blocks, keeps its ref
>   split_folio()
>     folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
>     -EAGAIN

Hmm, but doesn't converting to a folio_trylock() introduce entirely new spurious
failures due to folio lock contention?

>
> CPU1 cannot drop its reference until it gets the lock CPU0 holds, so CPU0's
> split always fails.  folio_trylock() makes CPU1 leave without ever taking a
> reference.  The PTE branch of this same function already does this, as do
> madvise_free_pte_range() and madvise_free_huge_pmd().
>
> Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
> of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
> /proc/vmstat:
>
>                      thp_split_page   thp_split_page_failed
>     before                     3186                     860
>     after                      3200                       0

I am _so_ glad to see an actual reproducer used in a sashiko bug fix. THANKS. :)

>
> The short before count is rounds where every thread failed and the
> advice was dropped for that THP entirely.
>
> On failure the walker returns 0 and nothing retries.  The PMD path becomes
> best effort when the folio lock is held elsewhere - same as the PTE path.
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/madvise.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 07a21ca31bad..bd9119880ef2 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -405,9 +405,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  		if (next - addr != HPAGE_PMD_SIZE) {
>  			int err;
>
> +			if (!folio_trylock(folio))
> +				goto huge_unlock;

Doesn't this violate lock ordering?

From rmap.c:

       folio_lock
	  ...
                 mm->page_table_lock or pte_lock

So now you hold the ptl lock _before_ you obtain the folio lock?

I'm not sure if it being a trylock gets us out of that particular situation? And
I'd be reticent for us to violate it... unless I'm missing something :)

>  			folio_get(folio);
>  			spin_unlock(ptl);
> -			folio_lock(folio);
>  			err = split_folio(folio);
>  			folio_unlock(folio);
>  			folio_put(folio);
> --
> 2.55.0
>

--
Cheers, Lorenzo

