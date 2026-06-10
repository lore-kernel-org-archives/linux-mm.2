Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCA1CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 20:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F8B6B0005; Wed, 10 Jun 2026 16:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF8F6B0088; Wed, 10 Jun 2026 16:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D176B008C; Wed, 10 Jun 2026 16:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7F46B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:02:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10CD0164493
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:02:08 +0000 (UTC)
X-FDA: 84865074336.13.308C096
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6BBC0A001C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:02:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=orhOjg0N;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781121726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fRTYdQA/O81FSYgvTZlJXnNKEg69vqikPwkNJLsajI=;
	b=4rCdRR/fyElWhLKDHTuVBEfnFSZsqjY2b5+54djAWSObxCLaBsV7UG4wzdbe7HcSx17GPP
	yASmMU+osRMu43sLxAo2P4rcFWzodAN0vn8vD7ZADUZo/WHuBjx4Bp4VAudXmjiWrd26UF
	mOnfEcEAaOoG5+z4e6924chgjslKHfw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=orhOjg0N;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781121726;
	b=UMmvH/RZaKir1OhDgN3G0zomaX01WfQlgy6/ccTKDFk9ZcWBsOSpl6UJGK4USUl/YBs4Xc
	fG1k7tsyfLpbezJiEXWtphGYdndcgPjmLMcDS8frGO1KRMf0BYFWRVhE4teQ1uY10jw4x4
	4Txf+oiFReLykbG6DmmZsYiU2EALEZQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=6fRTYdQA/O81FSYgvTZlJXnNKEg69vqikPwkNJLsajI=; b=orhOjg0NMFmX8bdRhl6M7//0zI
	bpYrC2Isvsy1bWLaFKgYMMmuEWFSi4Y/CYxJXlTZCVDB12fCOUHYP8wq8b3F5qs1WEbHCmAFbgQoK
	+Pjs1kdn+qRfT7GfDMMsePPpkCfhhBPEXLW6oZP0obyjRxqGWrgNs9odHX5Vo102TB/ApR3wxhlrZ
	OFGvOJ2sG4+ASnwTgpPif2dyKFYGekRc0MmHPgLM7ZaJmh5CuIaLDZ8xSiaf9Tv5tH9I80FmZvFMf
	5mqz8hXbO6NEMAIatYrsL85HCTBWkIu9Lpyxwn4HXs5KAALi2ZdcmauQwyE4alJpZ3uoOAq3u85pq
	i7LipLmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXP7j-00000000YqO-25DQ;
	Wed, 10 Jun 2026 20:02:03 +0000
Date: Wed, 10 Jun 2026 21:02:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
Message-ID: <ainCu2HZTTdP4skd@casper.infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
 <20a5a752-3ed6-4fde-96c9-e8369b15524c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20a5a752-3ed6-4fde-96c9-e8369b15524c@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BBC0A001C
X-Stat-Signature: q8uf3km59nt3hh8d9s6egnni7ufhu9h4
X-Rspam-User: 
X-HE-Tag: 1781121725-59747
X-HE-Meta: U2FsdGVkX19b3/IXOr2mEEgYCOilaA9g0yv6Uq5fo2TH3cr9oDCvffB+67ko3mtVl6gSN0ZNBHF8rqc4qhql/sDZyVl4FnulRBqKRLItnv4mlKpyI4ZlHNgRi+OG5TBS9Z0g3aLwfxBSrOqarKN45C0ZrLFIlep+HDtfd+o9bpVKj0ZDCq9gP4gOYHdqRXtfmI5+w5o+rSCO0A+ioIu0I3UBRQwt3qr4K2ghoUGr3Cc1xLPCW/K0xYzO2ZoDTQceTS245EipTmCHIXE6M0q0AVMqrTA22jb5mn8wy2NcqXvhxlS2//9BzHGr/Z6Y5dsdsyp4Xy7s5lN1q6LuqNMzR6IVuPcwIk2XwP5r1v6FYZhcXdXqV8ngQ3bfkP2Ya6k7L++BDJrZsjt2/as1FFWnI81Hrz6vReDltshOAWAXbzLhCLi/zKcCItcdilnw1MjCtgEJT9wxocE7EJE6N8LPLkTUS69SYYsv9kJLIyrreLFndybexlfWGPpxnwsFp13klo/jnVOgNDuQdrKv/kwIHeDyt1/aSyjjcE/o8cp+Qna0uIVqlEoy0myi5HE2eLeT10FrV0rBS3c9P9gaFe0p2+GMV6P2XgJ9mK5hvl7FA+nCXG6Lz/7esrIiDCqtn8ZXbVqXA+Jw8Xb+v4TukP+EjJbqFh6ROXlJarlYwr3a4oMjlYYHPCftT/SL2nlOZJtFWjLGi+QBggAj9UcLeCKCuSlxSMnbbaT6mBu4qfuwJV8/xKP/3YImspzn//Z/X88k8aLyTCAHizKdN2mAkAigEismmgfSZVTlv0ZuU6ND3VZWxyOe4kVNIPEItyYwYhtmj/tw42CrZW8oADK5GFwcGi+X7JDJH3t6XcYlx7Ppux1AJE3gA9lVCulfI51W7pYpoZP4yhsX4uJKA0iSb3a4bGH1QQYniH0Z4pqG8bMFgRrg+KI5K7FN+4R5jl64qKAqVnhetmGrgearUWvUmuT
 ThGaJNYc
 kJphssoGhEH5j/Ol4oliCqowO7nk4npq9tU61qVXTX5KjYfWCW1Sn7m6oW7o+sYuslRr2tfEcJwoYuxXuv+OpXUCL/nH9+CtZsQgNkHlVJaD7MVVZs47MK2SqWzmB0O9/oocuQPdcdabEZfeMq2DwekhqaqE0kguc1BQZJg1C1UJRraLU6CUVMUILHtR+cCoOXayqEO8MlTkiqqu2N4Yre2VkWOJ6VFQdtwdC4gUiiAvX+dcJWTl16R70sPAytaxtvS0i2TVWfVByZLWdMDMT/HEx5+pqSVyqYN+ynbUGZGqbQSc11jc+jz8vOw2Er6P39wqMts7ygcDVnutsAXqIMKxdjKs7j6AfeJmTN+jUR4S300NrcFGEAOTed58FmCSjsLry3NG+X0MRG6tonVTHRcK0Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 07:59:28PM +0800, Ye Liu wrote:
> 
> 在 2026/6/9 05:06, Matthew Wilcox (Oracle) 写道:
> > Pages don't have indexes, folios have indexes.  Just delete it.  This
> > script is going to become increasingly barren unless somebody steps up
> > to maintain it.
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Ye Liu <liuye@kylinos.cn>
> > ---
> >  tools/mm/show_page_info.py | 1 -
> >  1 file changed, 1 deletion(-)
> LGTM, thanks for cleaning this up.

Thanks, but could you explain why you don't just call dump_page()?
It's more comprehensive and will continue to be maintained.

