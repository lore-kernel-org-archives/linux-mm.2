Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E90C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893316B009E; Fri, 25 Sep 2026 15:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843A86B009F; Fri, 25 Sep 2026 15:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70CA96B00A0; Fri, 25 Sep 2026 15:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8B26B009E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:38:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B09F816070F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:38:43 +0000 (UTC)
X-FDA: 85253296926.16.362C838
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B094C0003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:38:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VkAqExSG;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790365122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2/3P/ncvXaLVl7KGX2gZTIQey7db7s4qj3v0yId24U=;
	b=xjEfPhZJN97WyyAdO83ctg/Z6FmK1FFynEUqdSjS+GE83DbXMl/brJSGlY2yD3ztkJ4BzC
	4AqvUkIzAj03ppp+yk6v0yDmfT1YP5bIhlsd5Wg/H8G/wMuGvZ2zgiiApXM0J/+9EIALPy
	ayRiWx94IF5WZkWJrR3I4vaODr0IBaM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790365122;
	b=BBNXBTtuhhfOAESI0N6q1H71rDuX2aobkdC5RKNYHp7/bwPTuUm5YOxsLHgSr7+ClmXaoD
	vQ9Hs0er1ee0cbCuJY85CKCMPc0htWy8nZkNpLSEvREMF8KvBkdjqvjffZBv2MINrZv+4k
	xCBYvuWDoOkMFMlHSYuVcL3d2mWa9x0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VkAqExSG;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+2/3P/ncvXaLVl7KGX2gZTIQey7db7s4qj3v0yId24U=; b=VkAqExSGdwwYS7RFpcA/cRi79R
	YQbWo+0cBIgoiUR8+9o9npEctmtZ+cJGQ2l7QoLyaT02A2YSOFp+Hf9biGjOq3iLYzj3n4Met/nzV
	a+kEr/qfNIHmc72spr+IxYDzThNc0UGlnlUSBOEOr7uusw3JbAHrQFT7Vm2Tjp/mQflS1ajaS/pwO
	cFbP/7sGaz4mxkzT2eEcBEfMTEgG9ZJxIAn5NyJ1GNucqrR6nNR4iMM7YWlF1XeHkRnRZ7MPo8wVT
	p8T9wPZk0+9/sWmZQkE4Jm0C8PV5KZ9xxoYYv+cOJMU2nyT548trWbYvRPGSWgFCPVzJXxaHloAt5
	4racxzMQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xABkU-000000099jO-08nr;
	Fri, 25 Sep 2026 19:38:22 +0000
Date: Fri, 25 Sep 2026 20:38:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ilya Gladyshev <ilya.gladyshev@linux.dev>
Cc: akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com,
	artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com,
	david@kernel.org, Liam.Howlett@oracle.com, edumazet@google.com,
	harry.yoo@oracle.com, hramamurthy@google.com, ivgorbunov@me.com,
	joshwash@google.com, kirill@shutemov.name,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
	torvalds@linuxfoundation.org, vbabka@suse.cz, yuzhao@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
Message-ID: <arbNrVX20f2WDJjO@casper.infradead.org>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B094C0003
X-Stat-Signature: 9dzps36okj86575rcb7ug75d9p63bprh
X-HE-Tag: 1790365120-942987
X-HE-Meta: U2FsdGVkX1/TMBIVWXjMEtU6uPERZuBiulTqBTKYCKHcWNvASjxkKF83xiZZfjUWbKgo8DZ3GLOd4kX7roOqXn5zwTJPJEAyW+gqfJn1tsZ094vSa45KyLBVIJsJjPEN+z5SXS+iFx+EC/4XpnS6vOrj+GQLnJI9sIHLIp2+sQqDqvN1XfcxCs1DkSGS+Lq2scIzwYUm04D1A852tYA7x5xuNLoN5xQ8BJvzr9LRPhEDrZK4QAogXtdh8q8W5XoZfKa6wGyMGsWD2M9p9vrASzGzZNj0ZbWlosSItfF68D5tk7rqUhGllHkpny0Y+Ij+8HrKN2jYzaHBZbSVxf95cS+uaGlKU3TNlGgKKQWHP6IZQB+Ym6NoyMZYRaTzVLM0BBjob6xXWnfj4ASMTMxPxwUkE5kIuRfuWFKZtczy+Lz9fqHj0ImpJIwSWvprwuzIV7NJl7IOK4q2DlWUeyym+QJm6fumW5rmZp3vVLFCUyx5BrvH0l8jeDdlgZbttL3DK++D3+I0bKRwKUK8w7qIGc4tQUwudNyCBwDqrCpiJPkiCgC9fk4ulp5eKAUhzONnvN2VBWxc7GmiYLh7sAGDE2FAh/J6gfPE7PwKEWDuKQkTKtZsO5i6H0tZOVw+0oFwVTU7B5qSl0MBSCSVAvtND1MNzXHLHuh925X6qnAope8sbFErHzwZAOvxNz3+dzLgA8+NSOrUWJsYl4eUnizkrZXPB1sjxktPCdRLAeLjN6w4qrxy5aeoOaVbIS8KPexMFO8ixzASnEbG7xB4GqzS+mBc+ycKOsG4loa1QLLrYCOm2aenVTfVnZUS62mcnKFtlRkPN1TZ/rIan3wZ+eyDFcllXt46oDOoIr8fohZb0JhONB3Tg7g5DigdrvEKv0zJO2jwtqXOLd8Blj/uSl+rWDXK+mjrY3hL1EkftK+/k1tj9etojXk+yGWYvnAj4QeYXJo1jzWU0j+t21fw7Sk
 JowTgq0G
 fG30Gk89XSvjt9oGXoXWl7jYzY4HLzOxrIeRT1jyaYnHzUsUvE9Q3Nuux1zncQPOYWbBaR7JrKFwxTOrIsBvR96K7so+Tr5qndf6WrMuxTCCZCVwcp64JeAN+QAY25D0r0kaIr5J1T3ucfkgtu5TJiL+WSQffEJW6/GIpgXIDsvysiCtivc7yCN57kEmr4hhYC90ojONc+PrlsPLBiPvlubz1B6SWiPXHjEIwSogqFOiy6HiiQ9ksOACR6EEjViSO+7H1I2UYXQpfwUuCIxgxxIe8/RTZSzZdiXwRqFaLysfjdhunRhnGDTqG/fd6310sF22oJ9P77noi6zC464tqIlJnaHZyATU+NhlxKI7zyMBsJERfw6XoOh29XRzPaE0XNjijpChc/2Euhgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 10:50:10PM +0300, Ilya Gladyshev wrote:
> This patch reallocates the refcount value range:
> 
> (1) refcount < 0 means dead refcount (uninit / frozen)
> (2) refcount = 0 allowed only as a temporary state (see below)
> (3) refcount > 0 is a regular reference count
> 
> In other words, refcount is now split into "dead bit" and a 31-bit
> counter.

It seems to me that refcount overflow is now a problem.

We can deliberately increase the refcount on a page by stuffing it into
a pipe.  Over and over again.  See merge commit 6b3a70773630 and the four
commits on that branch: f958d7b528b1 88b1a17dfc3e 8fde12ca79af 15fab63e1e57

Unfortunately, I think the discussion that led to those commits was
conducted off-list because security.  I wish we had a way to declassify
thse emails after the fact.

> +/* Most significant bit in page refcount */
> +#define PAGEREF_FROZEN_BIT BIT(31)
> +
> +/* Page reference counter can be in 3 logical states,
> + * which are described below with their value representation
> + *        state              |         value
> + * (1)  safe with  owners    |   1...INT_MAX
> + * (2)  safe with no owners  |         0
> + * (3)  frozen               |  INT_MIN....-1

I think we need four states.  The first two are the same.

(3) frozen: 			0xc000'0000 - 0xffff'ffff
(4) temporarily overflown:	0x8000'0000 - 0xbfff'ffff

(we don't really need that much space for temporary overflow; we could
have something like 0x8100'0000 as the boundary if that works out better)

>  static inline bool __page_count_is_frozen(int count)
>  {
> -	return count == 0;
> +	return count & PAGEREF_FROZEN_BIT;

This probably becomes '(unsigned)count >> 30 == 3'.  If we choose a
different boundary then something like (unsigned)count >> 24 >= 0x81.

>  static inline int page_ref_count(const struct page *page)
>  {
> -	return atomic_read(&page->_refcount);
> +	int val = atomic_read(&page->_refcount);
> +
> +	if (unlikely(val & PAGEREF_FROZEN_BIT))
> +		return 0;

... use __page_count_is_frozen() here?

and you need to adjust folio_ref_zero_or_close_to_overflow().
try_get_page() can stay as it is.

(Thanks to Pedro for asking me annoying questions about mapcount
overflow which prompted me to look at this again)

