Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E6C8C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4169E6B007B; Wed, 22 Jul 2026 05:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C67B6B0088; Wed, 22 Jul 2026 05:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCD76B008A; Wed, 22 Jul 2026 05:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0510D6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:56:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FE1F1403F7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:56:32 +0000 (UTC)
X-FDA: 85015957824.19.A2076C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D58A214000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:56:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Thaeh4vD;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784714190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEkmbsohu70wSpeu9kL7X6w5e0YxqXmWzPLQ1TJA370=;
	b=600hBHcwB7zmIr3qa+jIjFOMxl1OhZu0ppDbdL/e+7Gk9wnt/rqy4x8fcMMg/CEj9fgff0
	RH8XL0akbbtHOe6Ro+dKXbaQDzBbsfc2mezeHJ1mYA2gSC3lojlWRIa52J7yu0sa8yR3YE
	i+ZUtqKgyA1Hwy4KV0LtUU64vih+x90=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Thaeh4vD;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784714190;
	b=tdvXo5hGJyfENRwmJn3uDsAWLiOrplS9O1TNfDZvmjdRVLhhlXbZOjXbklD9Hg3rBrBHYE
	tqq5ZbYe6CzDuvSqwM1fv0WkrVAygtepvO7R7i7H5FCF+XT5cSyx7yQGkfsQVfeE1A/4M/
	B1YqF+LY4zoshX9uapNmaqC1Iot/yDY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABD0C44FB5;
	Wed, 22 Jul 2026 09:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504EE1F000E9;
	Wed, 22 Jul 2026 09:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784714189;
	bh=tEkmbsohu70wSpeu9kL7X6w5e0YxqXmWzPLQ1TJA370=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Thaeh4vDN4ML6kySImSIFQXqo0elsCjKfQgz9DWNjlMi+hJ5c+8WEWhOt7n3J+C21
	 yM2sQxBRdZIzu0JozK8N2jlcG8kHE7+yDz2S3H/ME+95NaHe4Ygaw/y7gS6fISgr2I
	 xDbRa+vb//u1nFVzXI4Q+goD08fCNNdIoh9zL5IWUP5mIRBQ2aZ1y2S8Z1ucYleL3I
	 9gi/hGiaE6KQyeTlx4Svc+ZrBs+olFub5pHk+Q2D95yDK2hSKyt4CmiwRNgND39t1d
	 tkB4CUFoIilk6uo5VO+gscHioDKA6DxmgmWy3lw3b2irOPgMZfB/wzfJtG4V7lj5gg
	 f5WrjDdsXi2tw==
Date: Wed, 22 Jul 2026 10:56:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jiale Yao <yaojiale02@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_idle: call folio_test_lru() after folio_get()
Message-ID: <amCSiltZolhgtO3J@lucifer>
References: <20260722092642.1123347-1-yaojiale02@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722092642.1123347-1-yaojiale02@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D58A214000B
X-Stat-Signature: oqyt63grdk7u3q78txcaqery3fxh5653
X-HE-Tag: 1784714190-713277
X-HE-Meta: U2FsdGVkX19KDWpj9NgxzfzgoCEHgozo0mEad7R7Spo8okca9Wsw+rhlLjuCCcx1YPHfwLy98282Iqasilj13fiAnkrBSGY7XjJSWPlokxY3DYjcUWTRMV+wuaTk41Fu3B7TNRXsP4/qRF7PhRJLimWTAsr0+5jrA/N6+Dd9xsJ9R1P1KhfmElvEh7OzW3TFOF755F1s3RCtXL69lK6vPEnWdGgJky9URpql9vonRo9xeNZbYrSthoqktonk+rZfldVBza/bCVc7GNA0XVycPcAy6fWftorcP6MHZpBuyfuJ9Tku5l92aV9WXmJLKm66DF6UYSbMo0EIULoXzbLsBCoWtYkKYuUCWfmb3O3rK99raloeKUgDKnd4ACk8VEvaqHsDB3ybEKgiGOAiW9m1YSdVR/2f+QjGx4ISiNRw6S/3adM80VBxzq3J4BjIlUBNPYpDQwOJySGs77Lp3bYFZWLW36AQZ6q5y2XeoB6cJseVSivC3YfQEv+dkxETFwwEfe1puqROr7bRBMHrAHBRhdE1wyIrY8AX293OrMga59QpHu9ibD/I3shw631UhgRT35vDnU6pD4jeqpNYbGl7yr5HvBTaspNh8g6YhjAALuo5dH83cLujY1QANWhEkvH/juUo15uQs3zxEm72B11tCYgg8TkSf8BB43ESRStaDtIlvn3FH6Fg0PwNtQDMCg0CKB5BX7izOT01DwFHrR7ZDWHAP/2+Ss54U9SL9asxWkidHnyfUdRI9K4tzbD0jiQt+32VWMYdPBvFxsGLBacq8VqHVykls5Frbnk3GQRATvU6GC+ZCYhCiaT/oVCveDDCI2rCHc5DM3GIB5MSv8PESARTB5EoFbaoujxBbgeZgQsIG6Vh2x+FtuqZKbGxhxNNhxdjwujr2EEZTcQNrdtghUW1pSm+xVTZW2XwVAYCHQ7AhfV4rFb0LGwO8/lhqCcblNMq0zScY4C4mfHafih
 2loxOx2N
 VVTlkemvGWt+iMnJ7a7CVgh1awXXQPxRFgyC9IBua9ZjsnP8BqzB27w9WdpoRFVBbfgGXHfEiBBi333DB9zosl4bIIJQCqBBG0b9zJs4i9iaHEM7/xjqkibPedn4lwkTlKOSRg48vBQlfQhUHnEhhg+jd/K/590O8z07X5YeGlwd5NVTKH1gVyP3xXdcCG9KvS89/GD6Pn/BAMyDFGAPJ7hGKhufvMaq9Txa9rgDjuYcYPm9fJNUu5vitkVRpLleLyNsy6FppE7fdkSomGcpPS4hycqqKzl68J+AZKZkJ7OvcKEWJwTzeRHELGRDQJDRzyZsUjcMRDuSYh6tmBeBSd+QW+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 05:26:42PM +0800, Jiale Yao wrote:
> page_idle_get_folio() speculatively calls folio_test_lru() before
> folio_try_get(). The folio can get freed and reallocated to a tail page
> in the meantime. In that case, VM_BUG_ON_PGFLAGS() in
> const_folio_flags() can be triggered. Remove the speculative call.
>
> Also mark the folio_test_lru() check right after folio_try_get() success
> as no more unlikely.

Slightly strange wording but not sure why you're doing that? It is
generally unlikely a given folio will be !LRU right?

>
> This is a sibling-path bug: damon_get_folio() was copied from this
> function with the same flawed pattern. Commit d6b8b02a27b3
> ("mm/damon/ops-common: call folio_test_lru() after folio_get()") fixed
> damon_get_folio(), but page_idle_get_folio() was left unfixed. KCSAN
> (strict mode) confirms the data race on the folio flags:
>
>   BUG: KCSAN: data-race in ... / percpu_counter_add_batch
>     page_idle_get_folio+0x7a/0x2d0
>     page_idle_bitmap_read+0xc9/0x220
>
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Yeah generally this seems obviously correct (TM), if we can't be sure a
folio is kept around any other way to the extent we're doing
folio_try_get() we should gate any actual interactions with the folio on
succeeding the get first...!

With the unlikely thing changed, LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/page_idle.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index 9c67cbac2965..29ee18f0e8ce 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -40,9 +40,9 @@ static struct folio *page_idle_get_folio(unsigned long pfn)
>  		return NULL;
>
>  	folio = page_folio(page);
> -	if (!folio_test_lru(folio) || !folio_try_get(folio))

I guess this was meant as a racey check...

> +	if (!folio_try_get(folio))
>  		return NULL;
> -	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
> +	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {

As above, not sure why you're changing this? Seems unrelated, I'd just keep
it as it was.

>  		folio_put(folio);
>  		folio = NULL;
>  	}
> --
> 2.34.1
>

Cheers, Lorenzo

