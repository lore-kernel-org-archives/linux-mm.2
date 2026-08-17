Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B44C5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B620D6B00A7; Mon, 17 Aug 2026 05:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13536B00AC; Mon, 17 Aug 2026 05:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01446B00AD; Mon, 17 Aug 2026 05:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7C56B00A7
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:31:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF0C8A31BF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:31:29 +0000 (UTC)
X-FDA: 85110243498.17.AA95C3A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 23770100002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:31:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=r9Gk2fZB;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786959088;
	b=tVmNQvbpde6VK4yLpIJDRvblG/7Lf3+ScIZ2vMpYDWe7C3F9UUFETjKIwKZTSl7luqslaL
	UaV7X7iCWtPA8h0CbzJWX6usgaiEJ6MkL4XZLgPXPoHrTkre4EJyhsxRQ9gMrmUjjTOXk3
	nOsd9BFcJtR+/+nn21Stej2dyUcLoYs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=r9Gk2fZB;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786959088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BY2LkZEV75VdRKC+EAUB3TNiV4cpx9y+rtp1/41c53k=;
	b=kXnYThLfJLLZceGMwINuXf0ardCTXXd25lUY97w8XdlShJd0o94vFz7SO6Bl5kZB5hDLtR
	OHomi47kp2gqRCi/K3Umg4c3EowXP1sGHehjuWXMzvnqsvz3BnqgC//49/9wcC8C0iflVa
	YrRncdTY9VLvJqgs+qrHICX/s17Hr4s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=BY2LkZEV75VdRKC+EAUB3TNiV4cpx9y+rtp1/41c53k=; b=r9Gk2fZB9cfEG0VaSO5oI/fqP5
	g69PCBq5qcPnhfxiCYHfmNpdid+3WbPGyvqzvqCYtWzGtl5qLBa6gHRk0TGW707n6qhVdO3ZeM/Nr
	f6j7PKlzlS4WhMqfgeUEDKmmmNsxsRTIC9z/GCIY3peYbeTWdyi8xJWjxUxTVcRTb9eaaZjYHP71n
	G6Sc5apuxY3TU4sQsccFEHic/NQRS1XoHEwco1HpYK3OSrMvD2eemcJ6CYBlQtWM9sTGo/92tmyQL
	EiQaVyQqJUgZ04WpFVGEwE8xO21n9U+kp10Q7V7LYgN8kC/jYv+ramdKGwYaI8MJ1DwC+uSpFspAc
	LIJteWuQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wvtfu-0087yL-0m;
	Mon, 17 Aug 2026 09:30:34 +0000
Date: Mon, 17 Aug 2026 02:30:27 -0700
From: Breno Leitao <leitao@debian.org>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 3/3] mm: fail the fault on a malformed swap entry
 instead of retrying it
Message-ID: <aoLTWeyz_GldJwe4@gmail.com>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
 <20260813-swap-v2-3-4a625ccabdae@debian.org>
 <CAGsJ_4y7kQmZpfPQo8n5wRD2syHRj21XPvi6+OjVm_cXbfDLQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y7kQmZpfPQo8n5wRD2syHRj21XPvi6+OjVm_cXbfDLQQ@mail.gmail.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23770100002
X-Stat-Signature: 7y3betdmrtcc1jijgji3ymq9gfmu5qnu
X-HE-Tag: 1786959088-202346
X-HE-Meta: U2FsdGVkX1/qhYEvkNH6gwLNvNXkJGuiMC2kdk+26etnuV7ZZ4R6eDecM5CYplWuodNPk2gJuB4tZLpblYDNwYESUjWHMIQod0ob2m77XxrO0+8imPIx2vmRKT3VEQqHjLiiYP/XtAjU19wr9xe6OHEHvFWNgO1PU8syGaFBxp8mMTj6BU60bW+5s+ZjSJI6EX5M9v0wqpqXJBdQeBVWcAyeyaxXaAvLYEwMraiy8TUQ/fjzsRMGHTyjXo1QZTgvFiSW7wftlt4P0XWIQAbaV+va1FMAAEBS2QA/JM21BKaXMnu2ba5pIBcRJjXM7Uo8yXUafycuBkiMvuGN1sm7fh4APCpnoYRMr9JaTmDoCGOGhqVJWaibWYzaz0O4NB9PVKmFiMUP7/68hZgGqsAv8wOLMfbYRQH/a6Qd+8W8HRyRvTFdNQvVa31Ht15aq3csGtvFfI6XBkW+Zlf6cJFw+UUvuKuhlP2GsI7LSVYAwuMIU5Vgh/MFepAcNNmvNdWC7ln1aCFvR7j3c182zypiA9PmdUfv15OdTD0oKs9hGtQduk0zUpUfN7NDe22aJw2U/zWPny/E+tptxd5nyNct1CfzzNUnfc7Fy92vA38G/clPhwfKwWmr8sjIgkD6JDqod6mA4QK8jyiHhTXE3glk/IuBeZEp8uvMnAvKSXuVQ1g8P83zRyAVvd0Fytb+Dtsk2SJIg1KM6+3Vfs4ahkYO7DYtU89zrMVuPKfOhzH/zOAh/3kyg455U2+6D5svt5awkQjFQjjLUMZ+sBiupBMQPqGR8oaCyFvr8xe4GAlTZo7WiruZ2ymBsaNaCnx1OoJjRaeWOxfNFTvu6cRt8b/nUFDBJlE/FIF8ZRB5O6kLQxA2QLP5UXlmgya2XDbUrVhVbqYIMnwqSpmue3v8Xm3vPtUYFovqwwDoWlme9YCvtI8REyLcNSIg6g4tGtwgUMOxfPzM6AzO5eR1oLmKMaC
 +u7yVdVw
 f88/7jTFwzA/70iijJNjWF00t0ypoKqFeV7WmHnwBx5yMYBp8Wt0SFouFcEdJ75tbWHkR2HoTbnAkN3VB8dCC185PolIvORkyu6wQNqEQS4cVX0vFQNnz4Xze+T8l7kLPLjAWTWFgFw520cq6nfQPH8NAImTqDChJ8yT+oZyMqWM72sR50uo+CPV4zfapvy3YV14bIpptZNB/QdSqFA2LwXdfJtr5OUyB37E3RSaqu36R7UYB0+R9ke1vfhIsUBBP4mcM9vEXJQPIIVR1FcTruyMiTC6lWpv3L87vIpJWzvUE7Hg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 06:22:41AM +0800, Barry Song wrote:
> On Thu, Aug 13, 2026 at 6:02 PM Breno Leitao <leitao@debian.org> wrote:
> >
> > do_swap_page() returns 0 when get_swap_device() fails, which the fault
> > handler reads as "handled". For an entry that can never become valid
> > the retry takes the same fault again, so the thread spins forever,
> > retrying on the same fault.
> >
> > Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
> > called at get_swap_device()).
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  mm/memory.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 7201e848129a7..fa2b3d2ad3202 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >         /* Prevent swapoff from happening to us, and reject a bad entry. */
> >         si = get_swap_device(entry);
> >         if (IS_ERR_OR_NULL(si)) {
> > +               /* A malformed entry never becomes valid, so don't retry it. */
> > +               if (IS_ERR(si))
> > +                       ret = VM_FAULT_SIGBUS;
> 
> 
> Hi Breno,
> 
> Since you now return VM_FAULT_SIGBUS, the page fault should no
> longer retry repeatedly. Do we still need patch 1/3, which adds the
> rate-limited printk?

Yes, I still think we need it, for a few reasons:

1) A different bug could just as easily trigger the same message
   flood again.
2) I don't see a case where flooding the log with this message
   would help. If it keeps firing, something else is already
   broken, and the repeated message itself adds nothing useful.
3) From a monitoring perspective, I'd guess 95% of our log
   messages should be rate limited anyway, and this one would fall into
   this category.

You think this one shouldn't be ratelimited?

Thanks for the review,
--breno

