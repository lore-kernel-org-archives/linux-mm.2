Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF15CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F92C6B00A4; Tue, 19 Aug 2025 00:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0D26B00DF; Tue, 19 Aug 2025 00:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BFD36B00E0; Tue, 19 Aug 2025 00:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16D326B00A4
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:04:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2F0B140219
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:04:38 +0000 (UTC)
X-FDA: 83792165436.24.E4A5047
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf05.hostedemail.com (Postfix) with ESMTP id ADAB3100007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:04:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=S2Ydt9u5;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=l54C6gbX;
	spf=pass (imf05.hostedemail.com: domain of boris@bur.io designates 103.168.172.154 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755576276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBb3k1TlFIxNXzTe9BSC026CGASpV1bEgyEuK5hRhZg=;
	b=PZIWVjVHpM+u5toBCHYDtgQjTtC93yPRWGweqrGO7M5QIZ4JTvMYMJJpmPDuOwFnIAl6dQ
	yhBOt5z2ktrTQCcn5azxjJk+bPbSMlybNvCDfPqF92t3QhyftEBZuZR0Yndl5T+MI5XQlJ
	fvQNggp7ClSpyRrqaSk4y2XtCFaQ5p8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755576276; a=rsa-sha256;
	cv=none;
	b=Fi7y7mYcgFOq8CsMkNw52882QJSOChkt5H30J3fMHBWdYa8QbYCWNnumE1DWNw5zWmz9Y9
	U7ejP0CRSkBJ+nQsvTOrYYlFI5XceiZ81r4cgs6xSS9JtVC19cGfkM4YkBIfj/y0+E371f
	70vWbt8DCvDTUG0OiAaAFFEx7ETKEcs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=S2Ydt9u5;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=l54C6gbX;
	spf=pass (imf05.hostedemail.com: domain of boris@bur.io designates 103.168.172.154 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 11ED61400751;
	Tue, 19 Aug 2025 00:04:36 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 19 Aug 2025 00:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1755576276; x=1755662676; bh=uBb3k1TlFI
	xNXzTe9BSC026CGASpV1bEgyEuK5hRhZg=; b=S2Ydt9u5RChxtmJE621UpDqapK
	+uCKz5d4XorNZa9/ROJ0AQM6kZ5e+7yxnc3jTRfMVu/Aa9YM6zG31se9CSOd4chX
	gmjLh5BiUwalYdq1qA3J5ljS4dSnJl91aQ48xc+iIoDbradqkQog/mAfMYMZPl+N
	bHc7CExDRcNrp8WF+1OGCIKO6I0N1pyg/ZexoRYxoA8jOe60lZDTHgFKRORvwEcV
	znTmUH67YGYfmmw+CMcQmsY1uHBG9MhDl454HzRQ41eOTrXM5t/Jee2dl0swP6Th
	YP1OuX6RQM51AzTQK48BRRtB56ypc+I+Lc1Z6Q3GbyDuCnqH52SUVAqlKOkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1755576276; x=1755662676; bh=uBb3k1TlFIxNXzTe9BSC026CGASpV1bEgyE
	uK5hRhZg=; b=l54C6gbX/rg6IsXM0nYanVj6nnjKELaA8di9B0jWKtTw5jHbj93
	tcUkWnHzSRnodnQojodJnQs7kuKQF/3X3SjTcLwzYWnXI2G1kP6p1+XUSzYVm2YM
	02r1MrrXZ+uIUO3r3rFAytAG4XliTSAeDed5ehoC6gRx6yiSIgEMh9zNkG6eSJLT
	wgzEKufMQl6tUze5ZsWZj4ArpO5eHzpaPD94qPCxlcv5wfQMTBJzRfSpOCITfQZ+
	bfPoVBokYXMyLDHFrD99l5WJ8Y+f7Tyg9EWKV4JioYxryHpbopa4WTwnjuhzzxWT
	VxIrK8bH0wmzzomLKWxKmNoDXxYY0k+W3VA==
X-ME-Sender: <xms:0_ejaCs74Jt248NrPZl-ZqGKHOVwoNb7FCmzfurS5nsdLQgm_Wb2rw>
    <xme:0_ejaM9p0O-gwqiUcvRs5Y7ZwrVtNBsgsOQ-iR3z53mJeWLkwfJX3TDj6JTPFfK26
    nj4bfGaaipDfPk-MKU>
X-ME-Received: <xmr:0_ejaM3Yn5LfNjpyVsgMomxfcc_Dplhs4sB0sVtlTf9oqUOgCBdHMZx9WNIgrxOja9IxXjmDMj0Fb-XEYTvHpbuhyoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheeggeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepkedvkeffjeellefhveehvdejudfhjedthfdvveeiie
    eiudfguefgtdejgfefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeduvddpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdr
    ohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpdhrtghpthhtohepshhhrghkvggvlh
    drsghuthhtsehlihhnuhigrdguvghvpdhrtghpthhtohepfihquhesshhushgvrdgtohhm
    pdhrtghpthhtohepmhhhohgtkhhosehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:0_ejaBiLbHc1kmaWR6VG6iDDnbFp89Xhn9VuOIMaB7PGJa7scODRog>
    <xmx:0_ejaMZHubobxkMM7UhNQkk7N9Jt7yjSQsNPUNd5KD_PfSWW_UCi1g>
    <xmx:0_ejaNWU11K446OLnkczrA1Cx8iaqxipJJV6P_KGubGkHykk6uKa2A>
    <xmx:0_ejaEFcS0VBPGrjhBIZBLj_9eQx8J22lLA2tDgwF8TscPv6w9fkVQ>
    <xmx:1PejaJrCoiAD0_6X7YpdrufBMImgf4ul8k-Q9IKluoIwsyR-y378izCc>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Aug 2025 00:04:34 -0400 (EDT)
Date: Mon, 18 Aug 2025 21:05:10 -0700
From: Boris Burkov <boris@bur.io>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com, shakeel.butt@linux.dev, wqu@suse.com,
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: Re: [PATCH v3 2/4] mm: add vmstat for cgroup uncharged pages
Message-ID: <20250819040510.GB740459@zen.localdomain>
References: <cover.1755562487.git.boris@bur.io>
 <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
 <aKPmiWAwDPNdNBUA@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKPmiWAwDPNdNBUA@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADAB3100007
X-Stat-Signature: 757pma5ophzapoomf6tcaync58h5shoe
X-HE-Tag: 1755576276-538057
X-HE-Meta: U2FsdGVkX19IMOnco5tMlFtIFy3HeejaTh5Vc5jyLO9X0m3Gl9OeROAVfu2L/IkZBWZjt2Q/ZYlS+h3cI9KvPd3PyxLdQlfHJmldsFkk5/fCaXoRZ4edDt8/TAv1nous8POz2nqc5rDKl8F5P9G9FElYWewJ8WLXSCiN1nI7+Tn5ABn1iYTOeDCpbTRGOYLtUS6yycKcXs5G4Na80gdTW57Fg2q+cpcQ3lmJviH0h7VhQcKmiraqBoKW1txAqDgsRjn+tsL6QUYVFLOIjW5v9Vy9T6sWX0G5oYYGz0MCMO61MMOXlKfWOYrddhqUaWbDnjxA9Hz0AsgufpcMcPNo7Ya6CzVaW/aert0ejpiRm6E/hRhSPxVUuvTuG1rtuiIWuwY2hrkWhFBkwzGypr8w2a9NO9eKc6xSgwvAOQLS7JLXF6TAjni0uOTkwYhH5eB18z7BQWke65zQaKCWjt4VcdzEPph9i/m5uyGA54biFH3SzzmT4WShUe6XAkmUmkf3ZU0yjalBET4TeE10ZMuioW49zS80WzqDmLDdB3dsROBTf2hHUTsq+aEEIFkLhqgZvSJQqDIKtOTAcNytJ9350glrhSZnENwKK3lHRz5Kfkx59LJhqXT+Lzbc+XcIsXZ6BJTKKQUpJZAgDYvbtVT9P0DWGeTgqa2jLTvDyKZHtpWQ+jZPFBz8N6utiRfMirdljLGuvdd7SQIrEdSVxhUO096BGAnK9z0TPn45CyaN7gS/cGI8M9kXU1Qircppoips1ylBQXL7LIknZunzYlfPwSqu2xy8ylAcsSn9LFJn0wT1szisK0LPv7Ik3mbuBPzZVjr/rvqGCcNb7i2RqkrA3+tNhULvcZaUHyVNB4BaKsXa3NkQ3H9st9BqJPzsvWxK6w00l+pPVzwC+w0zbf8NO+ZdcdFG56hb3MiEo8xez8Yqu7Di0CNSIFKQBnEYogWjbCU7r4qzdSzNg9dzOlG
 83ddNTGD
 izWuKCDrQRmPI3gmE+k3Vb6Vbi5yzuCFILoP8f7781JxpO+LsKpIPQ6CzSGuE8HJpUfHK6OeN7A2vx7t0EWLQVpgCTtYGRcQsQdNNJ1ve8RaDID8S7Iea7h0LrKu0M8xNL1lYqSXi6ybw8LFuWb5gP6MajVp5g2HmmU0EfbfvhOLpN64QGuQHp32bqKZlniWevPQtg57GKwpvOcvqCGD85HLTipd+o6Leie/n0yH7EjTPIyY3c+DIIiRrQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 03:50:49AM +0100, Matthew Wilcox wrote:
> On Mon, Aug 18, 2025 at 05:36:54PM -0700, Boris Burkov wrote:
> > Uncharged pages are tricky to track by their essential "uncharged"
> > nature. To maintain good accounting, introduce a vmstat counter tracking
> > all uncharged pages. Since this is only meaningful when cgroups are
> > configured, only expose the counter when CONFIG_MEMCG is set.
> 
> I don't understand why this is needed.  Maybe Shakeel had better
> reasoning that wasn't captured in the commit message.
> 
> If they're unaccounted, then you can get a good estimate of them
> just by subtracting the number of accounted pages from the number of
> file pages.  Sure there's a small race between the two numbers being
> updated, so you migth be off by a bit.

I don't think there is any over the top elaborate reasoning beyond being
precise and accurate with stats being a good thing.

In my experience, implicit calculations like the one you propose tend to
lead to metrics that drift into incorrectness. Today's correct
calculation is tomorrow's wrong one, when the invariants from which it
was derived shift again. We have seen this in practice before with
kernel memory usage at Meta.

I don't think this costs a lot, and it has an easy to understand
definition. Are you concerned that there is only a single user in btrfs,
so that doesn't merit defining a new stat?

Sorry to put words in your mouth, just trying to guess what might be
objectionable about it.

Thanks for the reviews, by the way.

