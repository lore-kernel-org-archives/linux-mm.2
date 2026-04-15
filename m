Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD7CF4213B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A2E6B0005; Wed, 15 Apr 2026 14:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA9B6B0088; Wed, 15 Apr 2026 14:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10276B0089; Wed, 15 Apr 2026 14:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AFB1D6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:29:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 551DCC206A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:29:55 +0000 (UTC)
X-FDA: 84661629150.06.DDDBABD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id F1F6E140014
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:29:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dcNqt17a;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776277793; a=rsa-sha256;
	cv=none;
	b=hjJ81wEhJkS5daSoUYZwdDv8thC+oRTmpDe1t5owgEJSKT7SQByBziRv6tsIYu3wP/q8Kv
	X757wd9i2MU7nuJwTvwaH1cGANCRsVUGZp+Hcu5eEWoxntXx6rkLrt7XKhPcSNQx3Fp7Bf
	JlflJiJeHXuI7j+p29ixc8dFz1jP4ac=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dcNqt17a;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776277793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysuxxhBOs7Q/SpbPCarUGh4KvquwtYWoqAHKzJHvyUQ=;
	b=m2xQjO0yUzn3hPOpH8JGfhWzdsZo4KuV9JaFTHk1LiaenDNrfuxmKzJLS5mWXmTBKsPAwD
	0tPGJUNbuqRIEZhEtShHWO0V8YE0nk4awCi2Y2BNeGwLbuOhsQ8bnrWnZBUZQCttSYy7hh
	2ZKc0I0m5+lG181FHTbZQKTn2GewuWQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ysuxxhBOs7Q/SpbPCarUGh4KvquwtYWoqAHKzJHvyUQ=; b=dcNqt17alyFxH1S1ctenquQ+7c
	tZCOk/c+zmo8HcTNGyudOA3ald7aVA7SzB20gziYcUlOQV9VtAcApo76Gkhh1vc1rU8L6+j0tRui5
	lMrYU6Sx6VN2kzdOnP6r7R8EjJ8SjARILsmUreEqvsUKjPxFkz+Mn6KPkL3nHQ2s9wzKi/iWZVY5A
	VSiKTdEGEvQQQChkuTwmkX0Ii9QiamC60Sj0uGpDH8rfUc+3+UdXVgsfFq+PlymcURCHJiIKW7Y7F
	mQpqlDL7GA2XVHvzWl+k5m4dIRAJvW4A+JLpYG03zGWuAhAcHA/pvIiI6xTHGCWIY3+9BnU5edjLR
	SfsGk7nQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD4zm-00000000HMg-4AGE;
	Wed, 15 Apr 2026 18:29:51 +0000
Date: Wed, 15 Apr 2026 19:29:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: Add page cache reviewer
Message-ID: <ad_ZHr3vDstqXvV8@casper.infradead.org>
References: <20260415174039.13016-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415174039.13016-2-jack@suse.cz>
X-Rspamd-Queue-Id: F1F6E140014
X-Stat-Signature: x1he43pbhoitzz5ittsa3ej8pd6rs5sr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776277792-753244
X-HE-Meta: U2FsdGVkX19A9EapJP8oB1Q0nywxr0Pwk60n89NDeDntMgBWGICebCU72qHcpJdtX0bbrmUSByscGuycyzSxjuoeMk5urIm1PDo3qv2s97mFpE2JPFh6sBX4/qClZbk3vk72HhvWGi9BN+Z8rXVlmAZxg7whyXXOZYsRsKcXvDOWhbQUCiH7wDWtIeGAZzX4YlmBflJZmuXtSaqdXgMqB6A8jx2hruvp8G7MI4nW3BhOIHLCR+60sNe7A4JitAX6xIMzai8+K2T5Kr4KUTSE6JhiwC5F3Ro/uYNNtHgFJuPqNklU56xym3Tod3y5KkaiwegjGiZ7GooO0tONAWjWKGyqEtTT7YNbdc/EdPngde74VttjBdCobUBGevHFEGH9hD3d8wDqHrBMK44YwkBvvj8aH5SAChQxPVj0i5rA1jALgm1yG/vTtuMiCTBF2cZxcNd/GdnoymfMeVfpHEKQaLjenLFE/8r80R844vNynNccaLBf3ZHTDbWvzNviNUUPIWllrR/fOtfeqlzNwdxJxuh2DLEy9B9K4BqO3ZhqJsr/dadux4bZ9o0GgCx0eddJRa4zPo+Shs5Q2Z8xHqbwNPoirOkIsGSzj3yWTRWFYgHcwk9+qoyVvAo/Ga9kR53VTD9HN2+lF1EwQdZVVKNEtMSRmeB7JPRcrEhC0yoZ16KiF/8I/lCZk6N54r6VcJcyIilaG+6uFYn03hY3t0Gw/iU3FSUWmjEmjWyyOZ0u3JZsq5RGlOgGSEuUCDgvLZuAsv77OlcaD+F3G20Nka2d72ugJy88KkwNePV3FZNtsDdzSrqhUXYKFloUDfMy4mhF4QlFpdJJaEbqzt5u17zxjbBuCrqia94H/2Z91DA9CUK+sdtcblPOOboQF2W7uMHVAhhiQuDGw6jj2/hLMl/fVL1OcgoTnpGc3VzvDk5NNH4hP9BbGezEHx9AHCJY1JHQZphFvBLU2MAWYJnPGD4
 97km9Cdh
 i1V7rBRvYn3l/nUX7kWxPVgWixrSFa5EUTNsMzXGTNjFKlCuQzHjqcWpLZT8tStvvLFDzPEihNO6a9tqMm0AGr9JoVtupA8UJnf39kBjbuIhpz635E++gzv0IuNW2APwJQnHCeHFctFDN0VS8OKWYG/ydKW5Z0yRtn7xUQacZ5DP68K1VpzkM8WKfZmKzRqyCHTZgGaoBT2d1gQQTmnGVaikwPKTKzuxF1jo+OfQx0Oq176+AXE9UHQ3ZGzJdKIdOxjm0XUsjSyAXEY/rj42yToGZtSVab+9ZmwNiKTo+EKJ9wP2+XrzZcUFDJAk7PFacfIukj6YNFN5H9wHb2Cy0WDaq5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 07:40:40PM +0200, Jan Kara wrote:
> Add myself as a page cache reviewer since I tend to review changes in
> these areas anyway.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>

(if anyone else is reading that wants to be M or R for the page cache,
let me know off-list)

