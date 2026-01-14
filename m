Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91AB1D2A012
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023466B00A3; Wed, 14 Jan 2026 07:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C9D6B00A4; Wed, 14 Jan 2026 07:59:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F726B00A7; Wed, 14 Jan 2026 07:59:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D52F46B00A3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:59:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9470A1B757
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:59:51 +0000 (UTC)
X-FDA: 84330576582.18.E180121
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C17F9A0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:59:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZjS9zsC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768395589; a=rsa-sha256;
	cv=none;
	b=0qRL7M2fEpBizIYnY0y8s1JnI1GMpbislrX5e6VD0jZ5NSXPIAkAVi9aVzvh9y6ThoE0Fi
	sZ/dxLzTbo6SJM+Y0mRYfLfqHETwLFN+cVMJ5Xh04aV7ze5fJX31WTo09jLhZK0p45+f+X
	ygfzwwvjqAKVQj5smGMrRHaSilE9z3Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZjS9zsC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768395589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f48I2roWUhnGIWnSdC0P/w+U+f9BWNL6Ct4VkcqaCFM=;
	b=xBjoCRk+ej9trjdVSRiF6iVxti1MpPCghg+7vcAUIMPXt0uTTEjdiqgqdeD++eODKWGKxf
	mg/lsazPYrg/fkJeOmEhbBbEaUuK6CEh5Abklk+WqF0Z78NOVBaXJbd0Pusosm2kBTkssB
	Ejw0hh9MIW8V8y7YScrFB0dyZdAdE1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA70B4415D;
	Wed, 14 Jan 2026 12:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F17C4CEF7;
	Wed, 14 Jan 2026 12:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768395588;
	bh=2ciTmIsSF6ir6Fs6b26xcjWBNYW3JUmbkKGuRcyQpPY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jZjS9zsCl13WtaMFQGlitZVCg2C6jZHZTbbylp9PT0iQ5yi0psg8M81wXlYXUH4i5
	 d3d+XtYyHVOzQjf9fEMATku1Kf+ZWMTvyI/iTWxhNG6OOQX+b/awgLPmuoDWUrsR1k
	 Oh9o7C0QREl6zUz2W5nKIuObxCotCYsBYXhgcjE2PqO3aMVNsnC8+B1zxin1nzFAuP
	 Tl8FkFtqGkB464MivgC9DqlJIrB3mM/GquDGxttTU7PIaDoQy5J/t2zbv7GfeAk0f6
	 OeEtt0cArfKOVVCAd9YhETcKP2hmMdvlWyVvQRSlx4NUtfKJLuBm60bBza1EE+G6y8
	 lgYpkjKoKN4yQ==
Message-ID: <7f9fa27e-261f-4416-9a64-414d8130e5cb@kernel.org>
Date: Wed, 14 Jan 2026 13:59:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap()
 whenever possible
To: Barry Song <21cnbao@gmail.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, jstultz@google.com,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Maxime Ripard <mripard@kernel.org>,
 Tangquan Zheng <zhengtangquan@oppo.com>
References: <20251215053050.11599-1-21cnbao@gmail.com>
 <aUQJEa643lQAGK6s@milan>
 <CAGsJ_4zwqbg889+CTtO8XLQZu+rFs-m6+kANKO78-TAf4zjjaA@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAGsJ_4zwqbg889+CTtO8XLQZu+rFs-m6+kANKO78-TAf4zjjaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C17F9A0005
X-Stat-Signature: emq5xh1xk7gotyew6ndx5utj3onfudd1
X-Rspam-User: 
X-HE-Tag: 1768395589-539263
X-HE-Meta: U2FsdGVkX19tjXI9aw9xGXCxPfTfGTtdIZNAKJ4QFhcWaEivYbERVOfrRwfARz7PlZ+8lndYpIamAEimd/yx+gROW/Ux5HYdQydFt+djdvh82tBe4fADYFgY/EuLry0n2DMFXKJJ0B5VNYG9KY/U9uubLVqw2ozkoou8z7JCtFifFRA7+ILvLv49wVaBt0ubwVIi+lJPJmUn2/Bp2WnKoql9fgW69cTTqkunqlZHPh2QuxvoY02v35XbUdWmJFOXVje5CLa5oWKHdtE2d8cipkjX26Qk7YJ7IRsplKmrafsbecgiYGxOJEq+8FZQSdvUKnDCUyLAY3rzwxuIJBPZP8Yxw189qoZd1lAnO8FAx0Fe5Tj5TTgh4uzrFIjVUyMyk1dIDql5ag/Zdu16hbBXaD9S/cfmZJf0H/E1AU9nrpdkmYy4r25QN6zAt3YL7uQvIYuimWJiKUSrJorpWi2H2AijoOhBVhzcmfPA5mmxlRqNH7A6DziuMw6Gua7LHBtLecypouPXoSZE05k5HnyFJsWvL5L6EoBLaHwS1/1JJWtlh3OafYFWXCZxjH9J0c74YtuRgNcSccVuRkIJsXSxRAyDny1uzzNU17QB44CAcnKS70EcLWlausFjcj3L12N6CYG+Yi/JE03pP4KQ+NgaD9QSX8+6Hiv/8cTW1JtzMSqwaOIXQ9iqmeN7LvRRzrdwVUI6eHjRrqL9dYYCEGNu3JG7PyOAGrjGdWp3v/+dC6SWcXQI2TIuMe6bmBH3VfQhUDqOu/fJ/ruVFZPc9VqKWnEZ2OCrZhgZjEOFvEBwkgL1+TXUndhSDFYijAdxH3ZEjxQFMFQ0NbOlmZYq6cc+++nlWPLZU/TAk6bv92x/kJpuk3GeYuK7UMYhgH3D5C/zUZn6yvOz01N7XGoZlGy4hOdPOK1xP/8SP2gSjzhehGTTNmc2gvX6CGtGUIiP3i64nhSwpBt1LbR8SKRMjEB
 gPhgCPQJ
 tAaBF6ekCOZLxGlq6DuJtkqCcqhawO4aRabgJGBRCutGUgX7OgKcNKWmvQbNNRQodcYrONNcXWOiVKrdstnVBRfPfa4dMTK81WMzO0fnGVOt0JhwKMQw17CnwBMahm1vut7AHDIrwDR6s1EOWe9/Mbx8ZXFgE/wNDWS/ehqxjxSolTvJJgEzzZeK0LIELbjDvaBKH8H6MSlIOkSJSdTpKUTkyL6sf9n8FoBLqGwZGZkGoWN2yB9v+8IbWRVMmpOZPOY5m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 21:05, Barry Song wrote:
> [...]
>>>
>>> +static inline int get_vmap_batch_order(struct page **pages,
>>> +             unsigned int stride, unsigned int max_steps, unsigned int idx)
>>> +{
>>> +     int nr_pages = 1;
>>> +
>>> +     /*
>>> +      * Currently, batching is only supported in vmap_pages_range
>>> +      * when page_shift == PAGE_SHIFT.
>>> +      */
>>> +     if (stride != 1)
>>> +             return 0;
>>> +
>>> +     nr_pages = compound_nr(pages[idx]);
>>> +     if (nr_pages == 1)
>>> +             return 0;
>>> +     if (max_steps < nr_pages)
>>> +             return 0;
>>> +
>>> +     if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
>>> +             return compound_order(pages[idx]);
>>> +     return 0;
>>> +}
>>> +
>> Can we instead look at this as: it can be that we have continues
>> set of pages let's find out. I mean if we do not stick just to
>> compound pages.
> 
> We use PageCompound(pages[0]) and compound_nr() as quick
> filters to skip checking the contiguous count, and this is
> now the intended use case. Always checking contiguity might
> cause a slight regression, I guess.
> 
> BTW, do we have a strong use case where GFP_COMP or folio is
> not used, yet the pages are physically contiguous?

It usually happens by accident :)

E.g., allocate 2 pages and because we had to split an order-1 page into 
two order-0 pages, we get both of them.

Using num_pages_contiguous() only might indeed be nicer, but then we 
have to add some handling for getting aligned ranges (start and size 
aligned to order) ... so not sure if that is worth it.

-- 
Cheers

David

