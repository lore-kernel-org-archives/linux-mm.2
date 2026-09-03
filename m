Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3BCEC624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69BA6B008A; Thu,  3 Sep 2026 16:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D410E6B0092; Thu,  3 Sep 2026 16:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57456B0095; Thu,  3 Sep 2026 16:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A43166B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:48:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21F061205EC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:48:49 +0000 (UTC)
X-FDA: 85173639978.16.3904907
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id A8C8718000D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:48:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Rj71mU+H;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788468527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Du1gRA36J1zj7kF4LQrKEJ5dJV/B/IFUJjgHMfdrnXY=;
	b=1wt1+P0q4GkSJKlMK+NzuIvfycD/kwKM7pVeVA8zNigpw03WwY1O7shIbglnuZj1jL9j6j
	IpauBelZ+u2S/oDGnxNteL7XtU0OJ191PrHvNucydn1QBWdA5FyoMe1GmQylMeuH6ntDYi
	WHc3SnWDyLNhd6Yfxq8FT7tYTVL22Mo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Rj71mU+H;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788468527;
	b=gqhS2fldlaEWgG8dZrNILOqGKEtzn+mUYkl9tOW06TcodHRRHapQriX9E8OWQBfQCxG0J5
	9sLFcq2XUBtg66xtduyQewjYeuMdVAwTgJ/VVsYgws+PLIcuf/MispbEviDDXZ5u9w+BxU
	AxqrVzFERpwA6/lKJxbanxPyCv2LvC4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Du1gRA36J1zj7kF4LQrKEJ5dJV/B/IFUJjgHMfdrnXY=; b=Rj71mU+HtoUJyHUY+FEf++U/6Q
	rYCK02wjC/WDCmMc9VfVB9QzKni2praHxmrf21jn82TgYUELJSsod8L1Jc3B29b+XHPcYlH3ZXwpV
	Yf77Co01UtaFMBAkhwEPUwWcWka6mGSjAWBkEJ5/Hi+S5pHlKE0bol12QXwM5lNjqKPwvTkLSQo69
	/7TjdM9l4Y3ghRpjEqJOUMKpBZfDZm4LbkpBpWauMEylXGfgqLfZ0QHT8NXssWHt7JnIqgT0OxOy8
	1PWg15tzA8DAP9kWAn9KJj89dqIfQKsP6im59fKpRxeJCiCod27hGXtbn+jVawxxVGkuJJXzwEcG3
	oq68VlLg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x2EMR-00000000aD8-0e8i;
	Thu, 03 Sep 2026 20:48:39 +0000
Date: Thu, 3 Sep 2026 16:48:31 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, 
	ljs@kernel.org, david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
Message-ID: <aalhqe37szvcitr46c4fk6xcjtjjzm4zfm7ltrno2spipvq2q5@7svyjfbegb3s>
References: <20260813193433.3318288-1-surenb@google.com>
 <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
 <apVhzM2501wSiGGg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apVhzM2501wSiGGg@google.com>
X-Stat-Signature: e7jtepwshegpfncu6d4zsp3y19cgwnrr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8C8718000D
X-Rspam-User: 
X-HE-Tag: 1788468526-361467
X-HE-Meta: U2FsdGVkX19X66PSFY/oNowfq4y3Lyj4VO2IqRb+Hj26JgjfKj1wLbz63WOLxixJycRWpYA82aXYMCKyG6b6SQ7OQBCmnIA3YwTbW/oP4zUa3z2+o3AdLzZE66aTGdXqGXS0Pe/nEB7rXbsXm5XLZ68kh7tfnX7iOBmWew3kydXUC+OA7UAP6OZGyoOqyU97maktEWIZQFnKGxCWmorJz5GJLn9MDYbPGi5QlyksM33Wm2dtUWa61n7cb8piUw9seHpiY6BxMcRfgh3aMfqsF6CaR3UgV8Lhj80V0txtTVTn7sr3XjqJ2/gxpnEkhyJgw6bhcil0+LRC3hQTKlYlAERCjYVDCWRJayCXUY7KEDp1YKVMJv35N/zjEFdAwMIJ5wkV5rzpj2oZLffLA4dMNmz8bwZtOiGSMGdM67rr/CxRQqx7Wy0/vzVgdxVGPafUgr306Rl3UAmos+SfVAbFdsAZrpc5lMS56VNgHa1Vl7/6CSYRR4c1niCO3jHdVztR0Svl8HGaBvIftzRWCz6izT9NJ+WXU5F2pAfWQeimopywwjQpc8F3XXoxErB1tcdAGl5vJYXqR3ZOi3zvquoAlywWPiOY7h5QuVxkU1Fl5Cs9JPGu6fopJAcda5+pM3rEj6h4rf1XDk78bDllmr45J82IW1TVYvTgjm3nH/EiCcc1an8aue1JVrE30LJmV7c4MHovEflJdaIJvBc6fcw455opgSKeF0XuvOrSTtgowovkhZ/wbGSmFRNs51D2BZD+rE/TshwYjmPIiXRS4OD8XEA2bvuY1ccJE7fmTn48Vxk0Nw3ub3Yd7hn2TbyOAlvO6VO+UtoK4xZbln4rOvKL1JmeijpaLxjh7BcU7tW0qT2Jd+9vLhsqJqfPu8dyvNbfXbGtR5pHBKmLaEDOVnDc04Lv6iEqsbetAC5q3ELMlXgeRer4kJ/3pdJLpIQc/plp378wLGYDkbteEWu9axP
 /FOHbLSV
 5Ow1WHKiyXN/7gNjVYJj2TQTTrGBz/r8L5Oi1YtfxM/S99JTGilRkiouEKCOg01HaQQFfMd/Toe4RU70mNWnteHZgQXVudjDYIgvJWsT58CAu+j9Rapz8F/Lp9dKiZz53/1IODZVtLjsxeHgzG/hN8G3KSzv9DyLg1hC0IiPJ8AsK2LI46Nddo9AhuHVUynniGTGDTqfo2wd+6AB2hdE0b+ofVae40ptqJDZu06bAB19k96ieMY5BiOW4Tp4AjvkXwgPnoYAKq4ocb8gQT0lWicFzr7k83ad777mBXlKeUlEcxoA2yjyYzJvw8WWihqdfUjjU1XxqK6DoX3FTl9GvFom4x98RzbJFL/RfbZKZYpxl1U9GGgYpQEklKCey0hJY8MHgr2xp3He9Vod6MYKlenJwcFLwDFzjS5U40p6I6m+MKyxgJFX7Gf2EZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/31 11:13AM, Alice Ryhl wrote:
> On Sat, Aug 29, 2026 at 06:56:25PM -0700, Andrew Morton wrote:
> > On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> > 
> > > v2 version of this patchset [1] was written by Dave Hansen and per his
> > > request, I'm taking over this series.
> > > 
> > > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > > of the per-VMA lock users now that they can rely on them being
> > > always available.
> > 
> > It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.
> > 
> > But it applies well enough and is adequately reviewed so I put it in
> > there for testing, thanks.
> > 
> > AI review might have found a couple of pre-existing binder bugs:
> > 
> > 	https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@google.com
> > 
> > and a small rusty thing which you might wish to attend to.
> 
> The binder bug is not actually a bug. When using VM_MIXEDMAP and
> vm_insert_page(), the vma takes a refcount on the page, so there is no
> use-after-free even if free_page() is invoked without removing it from
> the vma.
> 
> Adding an INVARIANT: comment to the Rust code SGTM.
> 

I think you are correct about no UAF here, but the page isn't exactly
pinned to the vma - which is what I thought you were saying when I first
read your reply.  It's sort of misplaced in another vma by an mremap().

vm_insert_page() will increment the ref count, but if the vma is
mremap()'ed with the same size vma (ie, not expanding), then move_vma()
will relocate the pte and the old vma will be closed and set the
binder's mapped = false without a change to alloc->vm_start.

Binder now thinks there is no mapping but the mapping has an address so
it can't map anything new.  You could get around it by replacing the
vma, but I don't think that leads to anything interesting.

So we still have a ref count that's okay, but now binder has an
alloc->vm_start that's stale and a mapped = false which leaves binder in
a bad state (one might say a bind).

Thanks,
Liam

