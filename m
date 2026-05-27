Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C24CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A36B6B008A; Wed, 27 May 2026 02:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7549F6B0093; Wed, 27 May 2026 02:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A056B0099; Wed, 27 May 2026 02:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 559D46B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:36:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE2321A053C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:36:41 +0000 (UTC)
X-FDA: 84812241402.27.D1A9885
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49021100009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:36:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHQAcGUB;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCYw52Ypb7xQX0kO8kViRmw2Z3wdmHts7vjGzI2WQJY=;
	b=RtENxJpex6VR5ZjgFDTJw94pCQy6Gg+6KfqgwRabz9uqnaB9Ks8mEM/suyyctL2YEA9rka
	/HBw1ejjPnBqUuC2RG/c/oCI7lAGLY51nKAd4ijmHCr/WHjg1oTfi6FqyGEq24D4Ea+YJP
	MDlPisrEt+MXjKovSjCoED+M7KHtY3k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHQAcGUB;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863800; a=rsa-sha256;
	cv=none;
	b=oiU6kX3coIaTZRiIqGd8GsA/bcOxcC9IvsYHB64ASNCC0NVcOFz/Z+v5mQ3eBd6USX+53K
	jDBfs35rkF0nWc9Ckgg7OtA3xYQlZe52xvhQlxoB/yvqzFTeug3yxx43eOp+mGs7o5VofU
	dMEmm08M9CJcbCP4uvrou0o3icJGk6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFB52600AB;
	Wed, 27 May 2026 06:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781671F000E9;
	Wed, 27 May 2026 06:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779863799;
	bh=gCYw52Ypb7xQX0kO8kViRmw2Z3wdmHts7vjGzI2WQJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DHQAcGUBwgB8r++5b+u8t6he4piY98f2C+ooZ42Cjn5JEMqB2k+s8i6IrfWbn5Kyw
	 i4MUxRdM0GbmXZEnXQDd3+tOlkEJpX6MS0tSn5s1PIcRObBmxvcn+a+7LtDw68KHs/
	 RWGQJ5gpvar9WX7zYh8ZljpDaHohGZ7687rQ5FkXGe9D4s1ckLwOLip493w31V63AP
	 s0bnjVQXh+exvnZoeKUavREiUlSA9Q2fpX1U/FQ691u8XPxt1B2nHkxHNIIU1C90gS
	 zphholAUmDRbUDo3HB4ekiS0k//8EbY9wuxbfsXIxGi0bd8rK34QMTw3i/L/gS4wZf
	 tamT3UBC7x8Tg==
Date: Wed, 27 May 2026 07:36:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, nao.horiguchi@gmail.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, linmiaohe@huawei.com, hannes@cmpxchg.org, jackmanb@google.com
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order
 has_hwpoisoned folio
Message-ID: <ahaNtdwdLvHxFCg4@lucifer>
References: <20260202194125.2191216-1-jiaqiyan@google.com>
 <CACw3F53U8xNTHJkdJMo-74_t0a2dX2cJtQOjpjizU8=UNLQRqg@mail.gmail.com>
 <ahXFPh-a_Zt1Q_r_@lucifer>
 <ahXVuBoNUeEvLRrb@localhost.localdomain>
 <CACw3F51tWMjcCX-xkfUEKb+nUo+O_Q_gpAi+UhiBL+8i+T8MQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F51tWMjcCX-xkfUEKb+nUo+O_Q_gpAi+UhiBL+8i+T8MQg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: wcdp7dqxyqk8419jui7cq1yzknrptf1n
X-Rspam-User: 
X-Rspamd-Queue-Id: 49021100009
X-HE-Tag: 1779863800-188210
X-HE-Meta: U2FsdGVkX1+NfRM/qi773z3alAoT19+DvrIrEYIRvmxfmXdG7ovZaD49HmZXNI7GAK0IsdyeZ/+OHfoCuCXOkB0gSg52Z7I0eU1JmVU+KjzBGTNnnX0OEPhvFQPC8pOsDUtXXuT9Ln/p6Pyktkbq5n9TC3nicFtDtazYqlaXJeCL4OmvmJutd7muKGHWg+WiuhRWQFB7FzIV0ZttHl169Q2Sc7cbW+EvExj8nzVe84EoBdc/9dn3vJqWx2U+UQQU3+7gHLQp0qtrBnvoF/VJjCnABy9U25kBIwPqEcL1bz4UkOEKohq2jMrLTXWui2DKsy4u5Rm7VRlhohP9MoKBtMHtDOGc4mIF9GKWU+B5XoowfOcKwmSNgyf4U7g1nJD4e2l0TmIidpkNWWusYz0QaAP5UrCAzb+IWDhUJvhrNKuxE8gwwoyZUtzKeEk61WofF/3QRrAMobKkBC9Z+stU+fslnjLK9dQsfj869RGdvWSQLpF9p0vE6Gj2vtoOl5Xc//79D+5Y6uS+k1khkon+Us2G41DhhPtovFrtVU3qWL1wtF3MJVqgfUBlW54BFw/4ZxNTtYZwjsGLeOHI1qdasKkmOIuYR10y3fsxffUwDiObtoBcI+dwmYd5wOxIIiBGkoIwu3i5kK9n8mqfvyiMAvRNLduqtfHLWOyTUKoTzTTgUN8BbPB3Be4iJzU1iU7qCETEISd3GJ8dN9Eeb41eIvpjbpwqKPSdGuZp1+08r5EpuPcWNUWJbTiuJPyDQF1PQbbwPKOuQq0F33ZHEPW6j/WAypr7noa3LiCL0HiOvI23JVx3dhoK53vWh9i+a5t7EZKzIxRoVTMj+db/QmFNnokydUibpZXDRSGdIiKk4zKZpVdNeLf9E3mDvC+eXCwc2fibCLUI+VtIMVk8H2+HtbJfpIVJHVw2mJxWoCmJ+anFtuuxLBxq99C0ovJ6Zc1by75YQXlre8VQ9BrQFhG
 AUmlXQrL
 g2rcewHGzn13wZa/+cRSl+mrLKKpihuE9TywT79pd8x3SxCJtrY9Ff0PIEBSYmUvQ3nX4O/8fAUkM+MHlfVxA7tRe6geFNtVxPCtMS71wSbrJlhXYiI5NsM6TlEjZjlPhCFpbfjHesr87G4j8wP2ChrhJYJoaFy9KkIQ6CtBwOIoDJqYP1p7nTwnuJb26sVhs0Tw512LpoHSdjH495gTFQIRqcHojfZt5XWPHnCh2YeAUI50wLT+u87T51T6QYFS+my7aXg9opGGVi+cGp56P0kGg8p5nHIPnOgBCvoykEYEqtyYlcsdycTsN6B20DTzA7syKyGRXw6bC2rmQ/Rns3+Znx4SI9C+jrOOol0zW49VA/yvX4sx7CAw7qlFBcFGMyVNoSnq01Y2FaEooWbEAEfoo5KuMjd0WPfSJsGYO+Mtckd+pXtWZw6D5EXDiEk3LuBDtkzrDY6xTRMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 10:00:06PM -0700, Jiaqi Yan wrote:
> Thanks Lorenzo and Oscar.
>
> On Tue, May 26, 2026 at 10:17 AM Oscar Salvador (SUSE)
> <osalvador@kernel.org> wrote:
> >
> > On Tue, May 26, 2026 at 05:09:28PM +0100, Lorenzo Stoakes wrote:
> > > On Mon, Feb 23, 2026 at 03:17:57PM -0800, Jiaqi Yan wrote:
> > > > Hi Vlastimil,
> > > >
> > > > Could you and other page_alloc.c reviewers share your thoughts on this
> > > > patchset? Thanks!
> > >
> > > Hi Jiaqi,
> > >
> > > I guess you are blocked on review here, did you intend to return to this?
>
> Yes, as long as this patchset is useful to the community.

Yes it is, thanks!

>
> > >
> > > I'd suggest attempted a respin to get some movement here as clearly this slipped
> > > through the gaps last cycle.
> >
> > This fell off my radar, I plan to have a look this week/early next week.

Thanks Oscar!

> >
> >
>
> By "respin" do you mean I should re-work the patches on top of the
> latest akpm/mm-stable or linus/master, for whatever the changes in
> mm/page_alloc.c and mm/memory-failure.c since Feb?

Rebase on to mm-unstable would be easiest, we're late in the cycle now (rc5) so
this will probably have to wait for next cycle, but doing this early makes
reviewing easier :)

You can either do a v4 RESEND or it may be simplier to just send a v5 where the
latest version is just the rebase to avoid confusion.

>
> > --
> > Oscar Salvador
> > SUSE Labs

Cheers, Lorenzo

