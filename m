Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DA3CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 21:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082F66B0088; Sun, 21 Jun 2026 17:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034276B008A; Sun, 21 Jun 2026 17:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C3D6B008C; Sun, 21 Jun 2026 17:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0DFB6B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 17:50:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CF3D1A04FA
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:50:20 +0000 (UTC)
X-FDA: 84905263800.04.904AEE4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id DB0C640010
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:50:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YeC02q0E;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782078618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHjL6tTGiIVQP9xrKQ7bnGqOGrPMpxzLYz91PzYOyLU=;
	b=yAzjbRkTS720miBUYXE/sS/NyA0lXqYRtQGbyxSzSHTv67fGHCafAZ6WVC+Wybnkk+tpFd
	e3Rs6MtIzfKxN+h8yZoDO4W9JOcQERtw9hMriBOYUMLi1S4f6pvkCbTjLXjNoHVDw04IrR
	DQhGbz2oo8HYlADRFOcb58UVrsZ+M5k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YeC02q0E;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782078618;
	b=WIE+vsB3XHdJvSTsa4YJI+6FUcF5qwbFeo1sXYuLXeOqJZLM512y9J82beRHqoO8M2p8fB
	6Zo4Yin6y2yjEkrDjMww8kYFVCRJAMA/E94M4X50VlCigIYEFDtkzV7a07/ZVWIgR902xm
	cSIe1N7TXa+6zoVAqHMh5E1gcALaJjE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fHjL6tTGiIVQP9xrKQ7bnGqOGrPMpxzLYz91PzYOyLU=; b=YeC02q0ErJJLrHt/SGR8KJ8GBr
	L43eSFqSy6W4kYgnK/hH+AgkKNy+kg+/i7tYqPAhGfl6HISUGdKjAj2xyjP6sMHz4McjLfENOFk9M
	itXixbOuxuJmIodnR3/Dp+gHUK4fPNZHBh7PShK/SlH8zSXyJsgeG7KMtc349+pVUO9EfgaGfOIS/
	zhOiRr1VeHkvEHDPojJKHs7v7Gf+lH6ZV7mNXP2OX4jBadZFPMnpkEf4AAxcerCpfjK5TRxpodfHW
	4iRtzscvj5hA5OYGQKnYsdyVjyNF88SeemhQeqAL+QYk72vQM6bckkBWhlnlSNf/8s9auAW6dcP4O
	1LALhF1w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbQ3F-000000033NY-3wfs;
	Sun, 21 Jun 2026 21:50:02 +0000
Date: Sun, 21 Jun 2026 22:50:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gladyshev Ilya <ilya.gladyshev@linux.dev>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, ivgorbunov@me.com,
	Liam.Howlett@oracle.com, apopple@nvidia.com, artem.kuzin@huawei.com,
	baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
	vbabka@suse.cz, yuzhao@google.com, ziy@nvidia.com, pfalcato@suse.de,
	kirill@shutemov.name
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
Message-ID: <ajhcia0BKmTS6FQG@casper.infradead.org>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
 <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
 <839a2ea2755fdddf5af773e006237b07c9e261df@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <839a2ea2755fdddf5af773e006237b07c9e261df@linux.dev>
X-Rspam-User: 
X-Stat-Signature: bfoeretsktdq34ku7cbm1o61rcf6nqg7
X-Rspamd-Queue-Id: DB0C640010
X-Rspamd-Server: rspam11
X-HE-Tag: 1782078617-323126
X-HE-Meta: U2FsdGVkX18RgnW6dCncCoB84iImIbcy69ou6Y8iAYo0D1jDrEOdYLRdxu9HRAnPRG0f549Lr1WyNm52OjdFQG9rwKJXfSln11Cvioh4D6ZyRlTsnMm+xn1haORnhfjJMM8Z5x6rOR2I4eSVBa1OGf35DaE7SG7djv7rf0Ai0L3vSs89iYyReMKTUyVnIjCRrp20lVY1V1MdfHAZuAInhXQRGCg5CxpIlqqAXritCVglsEK5TwyvAzLk0ECV/kCzG3UWsDh82Cb18ml+NZGiQv6xc/qbQYA64s0f4XgKIpaAwvcC8aKKsibtURxxiDe0+x+wJaAkF3Zk6q0aUSIi7dD50cPTrMa34aBIWQwbizETuVoiNs9Ez3VoEnyKSh2EjD/apZBss6N2WIgOdr99UMGi/58UI6ZaVb2RuRWyL+CDtTITjkOxssgkhZv0td2oydP1I2AJngw4L+tSRPYP2ew9DAmhCmxIXEhEA8bs7tE48AHo80g1HC5Of6l6u2eQT82K4V+8SP5LevpFMjGM4jxVuoBda2lzWu9JX4h/0ETcVg9mOr0q8wkKKUVtbWWffQM3GFdrGm5aoqf9YCHUcHmb7EPuQyDVmkElIpOaaNELZxEX093Bv+A3J92QdqL7Yph42zNNFNpQn8aWjrneWFmKxkqHpnYC6BLqQjtPpUOeFCAp55ePP/wjxdqgimLI3M67LhZ/BcRHOV0f7RZOdSBSGT/i8p1VuGfupqoKXR1D5f+ddhnnXOIHahzidrsotENwSZ/IfPVQKLtsT8WjGfiSohFyM5jZ9NVU+mlsfvcswJ3kch+C3eWEhkBST+u6P08DIqlgXiQro1ZzgmgbbCDrxvE6PiUgLqamOZUrENuCnbYO1bKY9Xkj7Uuw1hpq94BhUdBeDUU11Ez4+KeAX94ngo23Ta6wSK8rZ8QpCSf9OaryyZioLlGScYHGhf9Zz1N8IU7tFRdvobeqgDb
 1Da9VAUm
 hlO6CtpPpMp1ACKFWAWDm80qWGkkna4jT6dN+l3k5oMpBlKn3Nls5XdCQBLdWvHt/X2lltMH7Ci0Y4ZqKQl9gbMAUX0NnwQAU0cirLO/afvhLPfs246s+rHaXpd4QvvOIVzJMlLg4X8CuMlMZEVgDA+SsoxZb29KW7s8Ro/HVQl/XZZMSvA7hEjTpL3fe9qbj3BM3W5jRJVaBJO94LpVo/+1MxoFo19soczfKLQg4zHz5GZG57NJTbJpk5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 21, 2026 at 09:34:47PM +0000, Gladyshev Ilya wrote:
> June 21, 2026 at 7:46 AM, Linus Torvalds wrote:
> > 
> > On Sat, 20 Jun 2026 at 11:19, <ilya.gladyshev@linux.dev> wrote:
> > 
> > > 
> > > T2: optimistic get() [0 -> 1]
> > > T2: put page back [1 -> 0]
> > > T2: calls dtor for type X, returns into the allocator
> > > 
> > Which optimistic getter does this?
> 
> If I understood you correctly, you are talking about the scenario where
> an optimistic getter took a refcount on the stolen page, so the validity
> check in the XArray will fail. And this scenario does indeed work normally.
> 
> This "ABA" happens if the optimistic getter successfully gets a refcount
> on a valid page, so the full T2 execution looks like this:
> 
> T2: optimistic get() [0 -> 1]
> T2: re-checks page [OK]

I don't think that can happen.  Or maybe it can and we need to add
some barriers.  The page is always removed from visibility (whether
we're talking about a page cache lookup or a page table lookup), then
the refcount is decremented.  I hope we have enough barriers in place
to ensure that the refcount decrement is observed after the removal of
the PTE entry or the XArray entry.

But I'm not sure why the folio_put() after a speculative get avoids this
problem; why do we need the recheck to be successful to hit this race?

> T2: *normally works with this page*
> T2: frees page [1 -> 0 -> FROZEN]
> T2: calls dtor for type X, returns into the allocator
> 
> ... T3 reuses the page, T1 wakes up and conflicts ...
> 
> T1 basically needs to sleep for a veeery long time to miss full T2 & T3
> execution. 
> 
> > I didn't go back and look at the series, but isn't the rule that the code does:
> > 
> >  - optimistic get
> > 
> >  - then check that the folio is still valid (*not* using the page
> > count, but by re-looking it up elsewhere, typically the address space
> > mapping)
> > 
> >  - put the page if it wasn't valid
> > 
> >  - if it goes to zero, there's no destructor inherent in that
> > 
> >  - everybody who sees it go to zero - optimistic or not - does the
> > "zero to frozen" cmpxchg
> 
> The problem is -- the zero you've seen and zero you are trying to CAS
> can be different zeros if the page gets reused fast enough.
> (Or couldn't and I am just confused :) )
> 
> >  - only *one* of those will succeed, and *THAT* triggers the destructor
> >
> >
> > IOW, the transition to zero is not special per se and has no
> > destructor. All it triggers is the "now we try to mark it frozen"
> > phase.
> > 
> > At least that was my mental picture.
> > 
> > Was I wrong? Am I just confused? Wouldn't be the first time.
> > 
> >  Linus
> >

