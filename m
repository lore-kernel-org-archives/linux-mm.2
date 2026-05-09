Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D57CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922A36B02C5; Fri,  8 May 2026 20:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA786B02C7; Fri,  8 May 2026 20:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837AA6B02C8; Fri,  8 May 2026 20:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7590B6B02C5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:08:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CD28A03EB
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:08:58 +0000 (UTC)
X-FDA: 84745945956.13.CB4061A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 824ADA0009
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:08:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wlGlqUAM;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778285336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q67lB5Va5n5+tG2Q/6P3h85KSyvr558seVunkEBDDuc=;
	b=Ic3dhywhrh0VBck9aoPxmF3t9UulzS4f9l5cCqouEiblLMQL6DHT+p6g+pmsBuqiLjMyOo
	7bw3oVP9B+6GYiWjg+CEmRQlz2Com5ehXSpeemPufbBWcSbxo9IxIq/QC58iq8P6AhZmkO
	ha5vb1Eg+56qoUY3t3NAGp8/RAFp8nc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wlGlqUAM;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778285336; a=rsa-sha256;
	cv=none;
	b=F5bGhp60vwHhFqshGUxSr5VChgQfI/JV27ASoMLX4IwCIplzIxHodBeSkswsHPBHolegMA
	nutj6bR46NO89eeFoD8SBrSWvW5R/GxUWbhrcbdtJ5eJuB57qqCa9UTzG7PlGL+R3lLccp
	vu4B416rCZBvlEGfNxBgmDoViJVrCbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D80BD6024D;
	Sat,  9 May 2026 00:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643D5C2BCB0;
	Sat,  9 May 2026 00:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778285335;
	bh=WW8aGjdZxQ2AkRvGAOjj3tjy79NbyCNFBA/cjvxOX8k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wlGlqUAM3BObcA2vsK5XlY/RqKam2AqHd9ge7408RqhKjxibWBdmA8HFtNgzVp9xt
	 nLgSla8IvBWb9UxR2GyITRirdKl4DANnwlj4PBEeAOeFEisHCYTh+JwkIRsbfVMDnN
	 vX5sfeJDPBlHvKvJjFuDgBpC7Iglxmo91qNkoISQ=
Date: Fri, 8 May 2026 17:08:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ye Liu <ye.liu@linux.dev>, Ye Liu <liuye@kylinos.cn>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/memory-failure: use bool for forcekill state
Message-Id: <20260508170854.a845bd71e7ebd5d2f6927fcb@linux-foundation.org>
In-Reply-To: <9d022499-2a77-f8c6-b86d-d9de838fac32@huawei.com>
References: <20260407020715.2269255-1-ye.liu@linux.dev>
	<20260407020715.2269255-3-ye.liu@linux.dev>
	<9d022499-2a77-f8c6-b86d-d9de838fac32@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 824ADA0009
X-Stat-Signature: 3b5g8zat7ehxfwi3s8sy5hrkweqq54ze
X-HE-Tag: 1778285336-309908
X-HE-Meta: U2FsdGVkX18RgZPC6HkfmbmMETxhcU1BFRf8xz9HHHO+8mThjcQOQkjaO1QCyt/3IIuVvLYTHjo0n2igjG0ToJNaIOA6NJ/yUAtnxsXxARpJleUcQBQ8QSMR6je/ZzYkzThEu7lfvrMIJv9v6bQsqOTR5y3qOay1q+8ztBzb7V20uHXRJQyHUTIxrS1oSJddQBsMszGfn6/UzE7f0haPmszbWvIMDtafE7+l4pSgP4TWsyZvioLpM3NCaXcfWygYMN9EOUXP82uYuK9rUfJeGmmyuHgZxRYZ3GLDno7FBWMWwKz6nobToGqtHdVh3E6lwUxZjAUretS7fkKfDfCxCSiYRCUtQUaLXpvW424sfxtZrW4PBd6fjCVQWdaa/+/co6KitT3AEc4dAuuy1PTbQC8PIc+PYQSL+5AhFwiHSBpYGe5TNfVREFny46FtHyhFwGeDdQqu4xzWWMM3nAFvngg1Ry0BQAlsGv9WI5ly2IUpdIuICZWMjY35Kk9genJlO9QuHoYRhBnvixXPK+NCvG41Hx8nPvqJ3vwjbarUTgoeFHdXx3HnWLw857FhQfX52nJIwUbX8QFLHOUydBD7CCSsu9zYp+1xw590Ax7/1xYSEhM9Nnw21MB1aWctkDF2606BKXvS7nTkFIBfSFhj370z5wEYPOlNi4sGxyPR65QFd4xDCQPpvBSu7UUfE8LlT9AD7dkc9cWQeBrhEXz6ryfw0846dmMyBc8CrsAOYJW7xhOjorxIjHwC1Ym2RCjxfYse7rAW11a/P2/AQ0lhE4V4I6HWtVsuD0NhWk0kXYb/d1ebTFbPbnhF7wYISgvL/hy5Nfgp89VHqUN9cK25EG+t7n03bhbb7WrUofeaDo573TNrE17vFSa+7Vzz1WPy/wUo8iaDt6xFr5dN1wSZ9bRzlnTpRpvhSdxo0mzeEqyYqQqfjihOhdmMVVbBQjcywImtviZgYKZfo6S5CG9
 TkpKfW82
 0lNoXxO86zINWz3958HAEYhWtd7tXLMV1rG3uERULe2owMdeXucYTHY6n8d3GY/iPbXJZ5FJ8TaAXrRoPidftgLoSi+NcNDp4ciCvj4S9FNBEwIKWi6QuX1W1x953/oTuccI0vBc8/AruroVOczVYhZWDmMiJdAWNsteuIiT8xUajx08s53p7sfO+12lO5JhgQ14plS6RgPoBl3ccqzhJ0UWCd6t3e546+IIBsYUAuviCjK2LRgRp8jHO1OYf4L5XJij8EG30oFD8owJ7zYQ+z/DV7mTjF2K9zeutFIn+FFPNeZkvQcGwjuLruOabXEyy7jHOWeXJvhYHcaLV/Mlp/YRYq5w0CpXu5v+66OfngeAidqhjlQcnnnCFEkpSagE1kZOo26qIdcn483s2Aa/jEe8Tdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 14:45:47 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:

> On 2026/4/7 10:07, Ye Liu wrote:
> > From: Ye Liu <liuye@kylinos.cn>
> > 
> > 'forcekill' is used as a boolean flag to control whether
> > processes should be forcibly killed. It is only assigned
> > from boolean expressions and never used in arithmetic or
> > bitmask operations.
> > 
> > Convert it from int to bool.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Ye Liu <liuye@kylinos.cn>
> > ---
> >  mm/memory-failure.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index d25adb390c3e..f355642bc2b6 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -459,7 +459,7 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
> >   * Only do anything when FORCEKILL is set, otherwise just free the
> >   * list (this is used for clean pages which do not need killing)
> >   */
> > -static void kill_procs(struct list_head *to_kill, int forcekill,
> > +static void kill_procs(struct list_head *to_kill, bool forcekill,
> >  		unsigned long pfn, int flags)
> >  {
> >  	struct to_kill *tk, *next;
> > @@ -1582,7 +1582,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
> >  {
> >  	LIST_HEAD(tokill);
> >  	bool unmap_success;
> > -	int forcekill;
> > +	bool forcekill;
> >  	bool mlocked = folio_test_mlocked(folio);
> 
> There is one caller in unmap_and_kill():
> 	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);
> 
> It seems flags & MF_MUST_KILL does not return bool. So maybe we should change it
> to clear semantic conversion?

AI review was wondering the same thing ;) And possibly a changelog
glitch.

	https://sashiko.dev/#/patchset/20260407020715.2269255-2-ye.liu@linux.dev

