Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B057AC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 12:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC05F6B0088; Fri, 31 Jul 2026 08:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97476B008A; Fri, 31 Jul 2026 08:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD57B6B0092; Fri, 31 Jul 2026 08:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3766B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:42:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A240E40422
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:42:27 +0000 (UTC)
X-FDA: 85049035134.11.5CCCD08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0D24140009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:42:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJbXDFTv;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785501746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NugrFrTA/7v5hxyx0UZKeNxtPasvsb3LIEGxXmF1B8E=;
	b=H2GPBfmIT7kNLxIhcJ2FxsBaXoaIAeCxF9pjlgDjIF1UmWXzmyu9ZvweIjWpei1yQLD7aw
	alutOKRpTThoFT/4Huocj8ci/v/dVkw6SfYC6Sn2tsKLs+q/0yVrcBKr06KHoqfTDTv2zj
	APhkT4B8ZOljBFjtgYdwRerqZx4i/VM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785501746;
	b=mLbpoUi3p9e6oXeQ7D6v1i5eLg+DjCLwa0TEqg1rUYGsb9LEGHUebp9WuUejvWF1p+mcVp
	kKJHM9U8yEZ1EOFJblcCR2AxJYakhGv++fb2ZI+R+UWf6ShbG1EsMXz26duRwoWkmNeNAR
	cyNcJvbapktG6oyzDz3POtWjMMY7mLU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJbXDFTv;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D40941784;
	Fri, 31 Jul 2026 12:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2421F000E9;
	Fri, 31 Jul 2026 12:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501745;
	bh=NugrFrTA/7v5hxyx0UZKeNxtPasvsb3LIEGxXmF1B8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LJbXDFTvzCp0WE7eBMdx9d372VnPGfXurClKU3AmH5LkiyZvUfU2oDHt7//l8EKwj
	 bwurU2Oet0dVHbzfGcddepMIsJfS89N+RMx/kTB/NNhpIDzgLrn0RyzVwc5yS3fuKE
	 qUr+/gwPn9daxCzbMn4g70aXje2TExoHdwuRv9DhRClrKYp03omrglyRc8Q3UzMrW1
	 DikHeVVi3aCiGa05Zf/PqWkBQwhtYgI83E1A9GVaaqIEPJtJyDvGgCVZqyoavKE6SJ
	 r+ICID7f2tILa5LQkUaXSdu84SJ/34zY/cuRJAhGLvkMgKzN3OLp4N4gFWD2+3oRRM
	 D17mvJYWip1XQ==
Date: Fri, 31 Jul 2026 13:42:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Juan Yescas <jyescas@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, tkjos@google.com, 
	minchan@google.com, dskiba@google.com
Subject: Re: [RFC PATCH 00/16] Page Alloc Hogger
Message-ID: <amyYB2biNSXTfYKt@lucifer>
References: <20260723074854.1013941-1-jyescas@google.com>
 <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
 <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com>
 <amyWt8XYlQJRJXmg@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amyWt8XYlQJRJXmg@lucifer>
X-Rspamd-Queue-Id: F0D24140009
X-Stat-Signature: bcyo7m79uipfeban3jqb19iswzurhom1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785501745-914602
X-HE-Meta: U2FsdGVkX1+1H11Kz0EAi8McHWI5ROqyyC+zSeo18Zu+UsJs7deBX8ek/yzaEOVBRdgxD4N3mYq8d7BP+sA0wNyDn7fyEShFi+Uae6Z7AAEtFZVFnKx3KHNotIj1bHUqLKGLAKLqGN6xc3balgga+IsTQN4WWEC0qNASt5ClLkZdQYn3iCrL90YCJqqViu2S4QhYKOLWprGqUqXbUGRU3VJyv4afZSlvM37pt84ZbSZszxqaJWk/zifrRuKVRSBSc7iYazRVzuUIOjB9GMcXi18I7rAp5PBaSFtm9vE8cvBHmXmdpKhJ9MR7VCtNawq13L1MVf81p9SQ1zdWTdGFgfx/AYBDWCe1OCFC11WVRB/692Y4NBVscjFuuTpM+dweaBYZqwesUDY9gCnL+Cv8N/8bpxBMiv1yU+djb/z6ehGvf+MR1nPjXt8Btn6E8jDCzypfYMuEqXSjiyjxqNgXBjV0Hv/YQVdW2Ni98DqkSKU3IxSHf7J7QIbSZ+nn7Ee3QsOHxvoBpazfDwaU+FBXIfVwRVc/8wKm/CbO4B0ICzFlo6zoet1Kzz1oQn2aYzSB/fsVyt7lfMfe4ctS2NogKfwgWvYR3+JdP+KvKmaI736WeaOKdzbx8V0BE35KzYd1/ztQHV8GQlW08BO/v77zGI19Kba0RcaDrxzdadwRjoqnIDG5p3pCh7kE+NZwzI4xh4f2w65uWJPcI4/yI1VqJfi+23xdQnEgxWoGVS1XV9vVpvmWearzpOa5iqJ27+YEm/ustxihUDZAtt7eo9d/VGsA4MbMBfX/NsOmJNp9diGo0kN3jaCxC9VniG3wgVWehBAJ2JTjh8lFb1fyM6tlQkyA3Kk4G3GAA51Dt1AKFP4h37QOqyW2ywj80Uhb6dWQTbSOYoy4S+kJA+RHpJ1XllwDv22i1GjdxIjGFTN8ywEzVRJaMI5h9bt1OuabyYsgyrhOkgaPtJVvQBNfVu1
 hdzYFcks
 vO2ZJvQRZTAG7KabwZAEn9wcNzPn2it9fEyIoxs/PhFeNyNZF9FGEyvluPa4SuXjDJYx/7Gl0U2vp9SJhhRhTnuydsn07QSH0RiE8aSGAS145mfgt1i1TzngE0MimigBdDsHpvmzRnp1hHrXtu8/yyAiavtZB1DvIGKlCIZ/V7EXO70mKdMGqUAUpuYV5kzWnZWHofEtLPYEo8S4NV2kpvXEj67p4knFGcVHrmvZb77NIvWQ9S91qFQJIlRzAJMLfXdIHawa5Y0Psu6inbVv+bVLMRJOXS04ol8SBbn3mbXUYpPPw53If5HE4EV9TwLrNl34Gk3gNF/MwFXb1qst60g6eNg3tZgspJB/Qk6t2DUY61azlbRGyQRtTHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 01:40:42PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Jul 28, 2026 at 05:36:03PM -0700, Juan Yescas wrote:
> > On Tue, Jul 28, 2026 at 12:29 PM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 7/23/26 09:47, Juan Yescas wrote:
> > > > This patch series introduces the Page Alloc Hogger. The Page Alloc Hogger
> > > > allows you to allocate memory pages from specific nodes, zones, migration
> > > > types, and orders directly via debugfs. This provides key benefits for
> > > > testing and debugging:
> > >
> > > Would it be feasible to carry this as an OOT debugging module? Would a lot of
> > > symbols be missing to achieve that?
> > >
> >
> > Thanks David for the comment.
> >
> > The only symbol that would be needed to have this module as OOT is
> > "migratetype_names".
>
> Hmm I could have sworn I replied to this :)

Oh I already did and my mail client was screwing up :P

My bad!

Cheers, Lorenzo

