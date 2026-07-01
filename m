Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3817C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EAE6B00AD; Wed,  1 Jul 2026 02:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40686B00AF; Wed,  1 Jul 2026 02:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2606B00B0; Wed,  1 Jul 2026 02:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77D7E6B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:34:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE8B4A0235
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:34:57 +0000 (UTC)
X-FDA: 84939245034.22.9FE06D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0147940005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:34:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcdE4sGa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782887696;
	b=BcscnIYu/wlVVsvYkjHvsaKE4MlF6BfgilsIcOCMIb9UwBxzsNHTCnEO/zSxDBLotwJqBO
	l8Uc+jdOMvYF/OAqjp5j67iPPM5yclY8V9CCP+Az78rDjoJ4jd2lD4iG86YcVnADdDiYwD
	MTVqu9OTlAomp/bWtuLDQDWzsVTn1bQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782887696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArEdv1dW3RnbP6iwECWGTwNieMpk9J9I1LK+vA9CFI4=;
	b=CRrh9I/ImHFUAUN/V7pD68ZY5CnY0hvp/LZ/QLcBtADgIur/8i/M5y+E/JlYFaf7hq14vM
	k7owHMHx16HJ+V/U77lyi6psBGrsnms7541j1TtTLyDII57D5DVx6AgSJ4naRtnBWtodWc
	S+LAfMvHo8cKSs45VwWUQw9DaLzIE0g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcdE4sGa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D84E43A97;
	Wed,  1 Jul 2026 06:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535331F000E9;
	Wed,  1 Jul 2026 06:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782887695;
	bh=ArEdv1dW3RnbP6iwECWGTwNieMpk9J9I1LK+vA9CFI4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hcdE4sGaKrMTw9Ez6cwQbV3LqQDi39agtcLpvIWBZ1Pr+ZnhZZoUrRNzUNqtTJJzz
	 12NlCUaeCZuLOVuLS4uPeI0KQDpvDiuFjdugeHQgUA5BQIMXwqNTyyI69A8zwfbPE5
	 OamGBpggYOoeFjTjcZm3OWG83fQ3kjGDpaEAoI6sVOpeXKbXyuPu8qqL+OrwoudhKv
	 ZjhPvzn1czfw47+FMyTR3h/kqLo5BudB3HW2toqFZNOK3Fc83LviibvJNiRbnzKH3V
	 rUWPg8Ruxvo99gr8C9UbwmeHha0GS1aZeuI4BmgBuqLcEt2i7dZeK74AeDYKIiFx5c
	 bh+H+tMpUEksg==
Message-ID: <ccb58e83-e854-4c09-9d18-36649eade774@kernel.org>
Date: Wed, 1 Jul 2026 08:34:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] mm/page_owner: clamp skip_buddy_pages() PFN
 advance at MAX_ORDER_NR_PAGES boundary
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701061101.344679-9-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260701061101.344679-9-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0147940005
X-Rspam-User: 
X-Stat-Signature: udbifzy6r6fd4f7tord58emro3ywq1rx
X-HE-Tag: 1782887695-895120
X-HE-Meta: U2FsdGVkX19IKTcYYpaAixjyYEOWXosYBuyy+lfrJBs9Pb3uj2z3aEKzk+8ltxuvU9Vdj4LzHBzRcgzhgoYzGlkMm8FXK2ReYwFwjFQMAdGxQ1jMKMBJJ+Y8ihs3S5vbzfzkZcqYd0rLsMN+i15tmNH79N4vPVGYULN21QyqxvkDveMVPsR1tWSLOWExFaTzANMRZdfGlRE3LfJrRlBHHMvW9RQTQUpFfHGMExPy95FyPw5EMFrdCO7PtR7h/kQQcrXh/0rJ1hDtbaa73fjfrul2ROuSvZoYy9uWbi5Vd9+x/SkmXBqDselBl1/R9dqbsECzSBDXpTqjK0DaIgKYH2vyUP+DTLlr3khGqmL4XUbs39mitSk29i416a2Wt/+5+3My0KR88DVNfAaAF8DY31XyuB5JjgFtj/DRVsN/OFZoS3C3qWkx5CKAj9s13EXWu+yESeOx7LDcJIb//jB45dfBzdWvhQDAHRH46b+HTYYCBbWPeuuO2YtmdIjfrEqA0ztZ1QfysatI1YlD7RBrOQ1JuKuudtbfhvLFI0Gkhzp7oqrWNTzFSqULzUkuOu/9X+9Ohxqto3kRBbLYmf+VdYM8gUyTwHrIqymNncYJBhx1NiQPYif3IdpBiZq/MgZsbAAPQ79o0iTtveacb94a/Bwr+Zm6YAwRNE8CWchy/pvCosl5S6D8sgVdCUQ57CaV8JPIDdKOfORy5r27M/VKM/KoQRErjS71MrKiSeCKmoKUoljWoXAQUU+PvhbAVqTAywLrmuwJusz9aPKZKa3kRibAw+9Vt5kO6U7HCpOvdpyhk1Hsue2VMUuTIp70YsioIgQkzob1ZmbRgpnzichAX9Fu+tSSx7PShRMQ7T83BGUTHmqRsvjopQEzNugJk8J3Fywnmk9b46cTYYSeTT+1cXnVk0Wc8dVafXF6cu2e0PqhRjM+UXGWfgF84xqs62LzZSIAj5NQXCZum5Sl9jA
 Fw0pJNi4
 DUqRPOWAvxv3ldLzu/kQIXyTu6sNhnLXLuTCCQLuL0qfz3UaZyO8X5S5vth4Z1qTDh1ETdKmRxzd9laOD6k1dAoqGokk8fJRojb/ldtHEuCxo0/R5dT72ozyApd4SoWSCnJmkLiNptu+CCIULhrlJAAWFS4I/pF8/tawS+d23HfBO64AVg8/tjT+KuyG/uOzWCBNEqvKNABFS49wwfPLDokmY9tA2eMTY+tMKu/cxvLgwwfXJy8mm0B9QYVNw0KXm3WwlZW1iHOXdYxGsYxt4BifR3ZuHs90xV78PitHCBQzPM2aTefTC1REo9+rbapOLhNVRoAmFMwTygvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 08:10, Ye Liu wrote:
> The lockless buddy_order_unsafe() read can return a garbage order
> value if the page is concurrently allocated between the PageBuddy
> check and the private read.  If this bogus order is <= MAX_PAGE_ORDER,
> skip_buddy_pages() would arbitrarily advance the PFN, potentially
> jumping past a MAX_ORDER_NR_PAGES boundary whose pfn_valid() check
> would have caught an offline memory section.
> 
> In read_page_owner(), which relies solely on boundary-aligned
> pfn_valid() to guard pfn_to_page(), skipping the boundary could
> cause pfn_to_page() to access an unmapped mem_section.
> 
> Clamp the advance so it never crosses the next MAX_ORDER_NR_PAGES
> boundary.  This is safe for all three callers: the pageblock-iterating
> ones already handle boundary transitions in their outer loops, and
> for read_page_owner() the worst case is one extra PageBuddy check per
> 1024 pages for a huge buddy block straddling the boundary.

I don't see how a huge buddy block can straddle the boundary, as the largest
buddy block order is MAX_ORDER?

> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Other than that, LGTM

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_owner.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 46a933f9c229..2e3880053a34 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -428,6 +428,12 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
>   * to skip less than the full buddy block, but that is acceptable for page owner
>   * iteration purposes.
>   *
> + * The lockless read of buddy_order_unsafe() can also return a garbage order if
> + * the page is concurrently allocated and PageBuddy is cleared between the check
> + * and the read. Clamp the advance at the next MAX_ORDER_NR_PAGES boundary so
> + * that a bogus order cannot carry @pfn into an unvalidated memory section,
> + * which would break callers that rely on boundary-aligned pfn_valid() checks.
> + *
>   * Return: true if the page was skipped (caller should continue its loop),
>   *         false if the page is not a buddy page and should be processed normally.
>   */
> @@ -439,8 +445,12 @@ static inline bool skip_buddy_pages(unsigned long *pfn, struct page *page)
>  		return false;
>  
>  	order = buddy_order_unsafe(page);
> -	if (order <= MAX_PAGE_ORDER)
> -		*pfn += (1UL << order) - 1;
> +	if (order <= MAX_PAGE_ORDER) {
> +		unsigned long new_pfn = *pfn + (1UL << order);
> +		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
> +
> +		*pfn = min(new_pfn, boundary) - 1;
> +	}
>  
>  	return true;
>  }


