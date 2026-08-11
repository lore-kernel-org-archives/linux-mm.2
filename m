Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D9E5C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717286B007B; Tue, 11 Aug 2026 14:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFA56B0088; Tue, 11 Aug 2026 14:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604D76B008A; Tue, 11 Aug 2026 14:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 453116B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:25:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D89C38017B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:25:34 +0000 (UTC)
X-FDA: 85089816588.16.F2FF304
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 292D914000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:25:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIhcDAYe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786472733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzEHSNLlFFddqM0RmRWXac6OXQ9KylFr48Naiw2MWzw=;
	b=Z3rKHgUvXZxAp6P7ckm3nCGy3bPcEXNA/kik0fXJc7a3/eqCZzwMYYAWOWkWWW5Ffe5x5B
	hd66A4dmD/CGR13Hmp8w6gFuDM+Q2oLXLMATug+ZfVm98kArj6l/QMwTayuZbRj00Pql64
	OMNURxHYeVlrqORTsE3Ujr3zh4WLjPY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIhcDAYe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786472733;
	b=GCnobTsNd7Yp72qSm34QmAX+1mbcWi75AkOV8Ro28YAVZpDMCTUra0b3Im2ihPeC8sYdBl
	AXrPjRPQEQbZ/F8qg4YQ3EzkuedvikPrG8k/aOT5/r4y8zmUxu91QYzYyMJ8nc1FGlDxGM
	4lKlLCDwJPy0cK8MJcu72CvnUkzKGCs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F6B1600AD;
	Tue, 11 Aug 2026 18:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A21F000E9;
	Tue, 11 Aug 2026 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472732;
	bh=ZzEHSNLlFFddqM0RmRWXac6OXQ9KylFr48Naiw2MWzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VIhcDAYePqtFLgfzasw4wXTHFqX7QLjsgw+8Xahc7vZQBHUmG3k+ZmedgiZPx1d83
	 C4D5pZkRTQOy58gEwv2VLx7/KLj20rGtLltcU43iY8kMQGjGy+ZS8k20wysBV8Xm0n
	 ZY58FRYF/EcBEFmtl7t78x8rWVOXiAweFVyE7Fb7EhUiFKjVTTJQXqvXf4Ju5zU+BX
	 jpZDq5GD/ZMgIqJePeqpY4Ddadqxgn1F/oWOFA0Eu54LGY/70Xlxes4ooegy6Sf40x
	 9+iqIT3/dajsBUoK9G4/czSEa0AGlSrfbv5WAUVN1CK7+fqAT+mecs37pfDlBq0Z3S
	 1JEzzoC0VOQxA==
Date: Tue, 11 Aug 2026 19:25:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Juan Yescas <jyescas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, tkjos@google.com, 
	minchan@google.com, dskiba@google.com
Subject: Re: [RFC PATCH v2 00/16] Page Alloc Hogger
Message-ID: <anto32QfDfX9MRpC@gremlin>
References: <20260806011048.517229-1-jyescas@google.com>
 <anRRLwa3N5bVCHET@lucifer>
 <CAJDx_rigKu_kwWCXy4dUNbqoA9b-T3U3Va4QX5-4=zn9yO4maA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDx_rigKu_kwWCXy4dUNbqoA9b-T3U3Va4QX5-4=zn9yO4maA@mail.gmail.com>
X-Stat-Signature: mmj3hojyspax7n77mi8f15w7xb51y791
X-Rspamd-Queue-Id: 292D914000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786472733-484645
X-HE-Meta: U2FsdGVkX1+PkvU21itrz80SZWmpmyzvsqVR5j4CmTG05Cz+or9f7Y9GYzyh5UAuGihSnHJA6iNVsX5lQlHdINVp6o7f/T24xtTgAwvarIPDOZk+lj2bsE7qcesdMampA/QukdcWmGN21hDahj5eQYyaLfePAJhMIgxjY7t67KXkXSOpuk/iFAnSNg1tezBr5+hUb2/FDQAQ3K9OHkNh+F8HS9z+kAC16OxmUBkGcQRHvpTthHnDBdB9sCcga6pmQ2Tvlxu/8xbqTEhPuNVZaFkFhqCHthJXBRLxCu4ZZUEapeXHOz9aWoD5rgI70lk59bns65L8MjsO727+MdeMxJT4v9jYZgyfs9FdXH/5co3cgVpr1rLQLYAsvKkyFHSXT82w0AjSgeMHx7bZu491ObzFMrlt1cig56hyo4mQFd73w9z3BHy9FLX/Id6+wqHvEr0BlwoD6G+RHyPIShKwYahJf/yi9+Q8yTiXYGx4zX1ogXxXBDf/g+DUHw26exUlHKPw5r339Z7tk1aXR+k3zBwtU/hLxxPf8WkIBM3ZelYfJNsYVQZwKN4NmQjixEXWmys1b6OQmuTk91nOlEJz5isVBoWTmts7AX4qIraRvy92Q4YW3shk6HE86A/LFEmR/G74lI5npIrnMcP3HAJ8gAM4yt2zsYsTpWzAlAQhO4pfUgnuS1fvL3MKmxvrOXOdT8lkNexLHwTO8XL/d+TFIOEvQqb7CCBGxbFiYEoFdYoC9O++fNtraqhQHv47A0qqsSjMf3ROzNDLKWxjPHPKsHxWe0NcSTBaTMqMKSE9ndgtM6lXs5zCguEBUZvTMGoJZl2+p5/j/q3zbmUm10jDvlF5Wldf2qzWQ0ra9XzQbq1HAsr673xPg6bGjebtTvGLi7CoSxqhOtHGu9u1gkaGDX42P9WPJnZdlKNdp3KnPLHuen+wjQKgUZphO7kNh22aHLRvuRQQC+6nX3hjZSY
 iy8LVmuy
 nbnrwGp81QmNVdPg80O9n/bTtvWc0sqOEy4btfKWa2xaN99Lzy0YFjOlnOHLaCcmsZL9Qqy5ovx5kyYtgQjdO2RqsikAApZf+eiSZ/fiugfN7Fxw30X91mrLxgKP3bTnr2nmVxlewtpv0ACPlCv32s2ttkz8JQwC6fQ6I/tDA7TsE68R6lPX1mRS5NBx0Hbue1K4WerxBL+LwfcxgVwclgDDKMQVSJWoyOsMgx6ujaFdMzpiyYrA5B5LqqxMPyuLGcKqHN7JxCHGEwg0nGnKkxSOWwlhb5cGD8A2+qZKcX3z08/hMYm85UyZMJ3Ma64DphUbxbT2yeEiEeDpeRdoSaR1MKR2VKXgOE/rb305uZIfCglkRb7/dJLf5gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 11:20:54AM -0700, Juan Yescas wrote:
> On Thu, Aug 6, 2026 at 2:48 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > Hi Juan,
> >
> > While I think there's possibly value in people not re-implemented their own
> > allocation injector, I don't think there's value in having this be part of
> > core-mm.
> >
>
> Thanks Lorenzo for your comments. Apologies for the delay.
>
> > I really don't want this to form part of any contract or to be blessed in
> > any way by core mm as it exposes internal implementation details and I
> > really want to avoid adding extra maintainer workload here.
> >
>
> I understand and completely respect your concern regarding maintainer
> overhead and internal boundaries.
>
> Do you see a way to provide similar functionality without exposing the
> internal implementation?
>
>
> > I'd suggest keeping it as an out-of-tree module as David proposed
> > previously ([0]).
> >
> > Alternatively, keeping it as part of tooling (e.g. in tools/testing) could
> > also work.
>
> That would also work.

Yeah David and I are agreed this would be the best place for it - it gives you
everything you need and upstream while keeping the separation we want _and_ it
allows us to write better, more thorough tests (and I see in your reply to
Andrew you are planning on adding a bunch of tests which I love to hear :)

So this would be great thanks!

>
> > (This is no comment on how useful it might be for debugging or testing
> > scenarios :)
> >
>
> Thanks again for your feedback
> Juan
>
> > --
> > Cheers, Lorenzo
> >
> > [0]:https://lore.kernel.org/all/97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org/

--
Cheers, Lorenzo

