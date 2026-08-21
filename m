Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE29C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBA76B0095; Fri, 21 Aug 2026 07:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D28C6B009B; Fri, 21 Aug 2026 07:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F916B009D; Fri, 21 Aug 2026 07:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E68A6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:16:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDB6912040C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:16:56 +0000 (UTC)
X-FDA: 85125024432.27.D791DCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2B4BD20003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:16:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcysFdYC;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787311015;
	b=hSS8x9GXdAofje0e1d0W3OIRDma0XGpYDn/nvzsy2SnSFFI0daaY4CU9uWDDq2WLiW8Euz
	wc21HxtkHvrFNBZJE2zjher6dVJdD2igNztpPEA0Vvlrn/QM9NFj/Twj+nJKtCrjxIrzIz
	7M8CBzEUNLP0ug2zEYU993ZYFDF7LtA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcysFdYC;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787311015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGFY8Wph74poQlCTeXTgQZO9xVvJ3OIvs0GGQOMzH3Q=;
	b=MOHptal2rfjJsxsLy+DYsjQ7IeXE2CqMRfv4WmvLCICUl+Lk06n2to9xd9VmuflyZIU/w+
	mY1wJK1C/xWY/gMdMtSrcEjM5IvakVjl7F1e+CmtwKusheXvzAgTIFg/VOP3kFLG7sBYBm
	ay08DrCY5GtvxqurLK+BbQBnx11bPro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5699440B29;
	Fri, 21 Aug 2026 11:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E841F00A3A;
	Fri, 21 Aug 2026 11:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787311014;
	bh=KGFY8Wph74poQlCTeXTgQZO9xVvJ3OIvs0GGQOMzH3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VcysFdYCHpmHmNN303g7tSxdzlAD5viQ7gg07COrdjH1qKdMKLD1rXDSQpIeKQG44
	 0HKd5IwVWfRFpcBrp6o5vtlGMKuZdnNT7qzgre0ka42vw95KdE7/3utBxu3YnlWYtD
	 qZ0iKZbdSUA3nY/F8ZoCIDWJhXlbYtUkGcgDUQbJiB6xYpf7xOfla0Bali1PC9c3nO
	 aTC0yVinIJMrfqwAo/Nei2J0JHb8R1eQjt5QOVakeB7Seio9MDxDTo56SfYkd2Pta0
	 fV55wmMRpK+zMXkW+DgqBmPMIB8ATiM5ETVaVSMLB/dYQY/elIwTrlImMAiIVr24Wl
	 8dRtX856/c/cA==
Date: Fri, 21 Aug 2026 12:16:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aogxgLSLNixXvuUR@gremlin>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <aogQ6iDA7RkuTtDG@gremlin>
 <aogYm0fKNsYVyBM8@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aogYm0fKNsYVyBM8@tiehlicka>
X-Rspamd-Queue-Id: 2B4BD20003
X-Rspam-User: 
X-Stat-Signature: m3uz5fabbszympshfq46oneuodr4kzz4
X-Rspamd-Server: rspam06
X-HE-Tag: 1787311015-139574
X-HE-Meta: U2FsdGVkX18nAcjMMm3d5dmv3O2m8q90NjXOU9+RZKasFNRKzK99XHRxS72MidM3B7+Q9MvpnDfNSzENWMarZFzMVV/Egh4T76Bie52U0HvGbhDls06AveIzMeDDQ8K8WiRqEFfmRLJE3YHxaPslde/WsHXB5Lm3qQjxwsEMquN5jJy03Vq9EHFFoqcZEm94y7oeBkVGA4Lyu7DmEwDnJjebAz6gqv3ISWyycWpd+JXKb8igWnhpR6g9q4eAUVzN3W2IIYn1rWyGyMve+NPwWwHNhMDf7dQxX0L76MTlQpPTBf5xNKnz+ne2cXU1PA4iD/OHUcxcm1d4DdryrqxHA8+6A5s36Iq28I1eXHpWcm+ptXM3dd9oJ/1sOiXMaqg3BX51MSt4Pqg/sbK8eHncZtrGqs7pMpa1mVL0j1mQKQFJGBR6PeGBB1vKjZkGJNKHWHylZ42tv+2o+kJD7AGaZr2NdsJXCqX5wTmEHUjGvx4B1OeiF7g5pUdNg6Wt41KQqCDU+1PfDugo5OGLnjjS1mnXiVPsf5/A5VoIXyB0g9xKuOkJViHS/zNRg7FzPp12GpjLZsqr9nP6X4GJg2ReQ7Vjz/t98hlQhdggFTRkALxq8IvqOASBcB7vKFfT+Y3tckgbzF+qcYX0g639f10DCJ2NYNBYzqRn1Ivfq/AAM4BHaTypFwBioyHAWsGerOcNLuzoYVtoIKNQPkLmrUqIjQYleoAruBwRYcCaxstiCVMJZ8W1pXYGsUO3e/n0wSvGKI2cfx0ZAIrusOEVW7vqZsuMx7SN8QolPy/pmP0KVVOaH0tmqr/dN1K9TyXBN0yaHFxnI6KjmM+MYPQQNL0LnEyUKE16o42ogGMLTh81Op8I0cMXajOnzdtCHAcAbmkp29OXN3UZ5dCDojsiyYA52g5NRwsvDT+tyw7omuBAYNqOM16D4N9zjEkW+7KrTcwMkntClTi6Uzw8UYJWZK4
 MWuRdR3q
 24EGQuBlWafqBFkq4Ba7a15RZU62zmYjX1Q8pFa+EOSDgSRhvHIKCWoVjCR6HoLirnnbO9g7aYMi5V/9nxVY0HQrYa3bXzOx9zR6ky0XjynqgIl+0LSnWPRHu6Sox95yieyAJ12FRax7eulPkVtJaAsfPGtE4/E6vA6URHIH9baFnO9i3KEuYwTEgdyEG1lIeWb4w3ksBVbQ+nLxjbIV5w6OGHm+81xkoxNejjhUaugTSQDneJRigeOwCxcJNiBe62CNu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 11:21:31AM +0200, Michal Hocko wrote:
> On Fri 21-08-26 09:58:52, Lorenzo Stoakes (ARM) wrote:
> > +cc Roman for suggestion.
> >
> > On Fri, Aug 21, 2026 at 10:31:06AM +0200, Michal Hocko wrote:
> > > You are explaining what but missing the most important part _Why_ do we
> > > need to have this addressed? Is this just addressing Sashiko review
> > > refernced below? Is there any real usecase where the current behavior
> > > matters?
> >
> > This is exactly the issue with these 'unrelated to your patch but' suggestions
> > from sashiko.
> >
> > You end up in loops:
> >
> >         AI generated patch --------------->  AI generated review
> >                   ^                                  |
> >                   |                                  |
> >                   |                                  v
> >                  AI generated 'unrelated to your patch but'
> >
> > And _at every stage_ reviewers have to do _additional work_ (with ~50% signal/noise).
> >
> > This isn't sustainable.
> >
> > We already had _too much work_ prior to the slopgeddon. Now we have a multiple
> > of that.
> >
> > Roman - I really think we a way of switching off the 'unrelated to your patch
> > but' stuff per-subsystem would be useful.
> >
> > Maybe we could figure out a way of funnelling this stuff somewhere separately
> > longer term.
> >
> > (I have I think 2 slopped fixes to rewrite after the previous what like 7 or 8
> > this cycle? So forgive the grumpiness :)
>
> I wouldn't blame Sashiko on this really. Yes it points to a theoretical
> problem. That is fine. But we should encourage people to not blindly

I mean it's not only this case, it's a pattern I've been observing for a
while.

> follow that lead and immediately jump at fixing something that is not a
> real problem. Quite honestly I even haven't looked into patches until it
> is clear that the usecase is sound. We should enforce this more and
> leave patches lingering if they are not sufficiently justified.

Yes this is a needed change in mm, but until we fully transition workflow
any patch might still land.

And I still find those kinds of suggestions deeply problematic for reviewer
workload.

If you had a person repeatedly say 'hey unrelated to this series but...'
you'd very quickly ask them to stop and if they persisted, >/dev/null them.

I get that passive passes are too expensive and it's not that much more
work to have sashiko point this stuff out, but it's not that much more work
for _it_, it's substantially increasing workload for reviewers.

As I said on a recent call - it's fine as long as you don't care about
reviewer/maintainer burnout.

But I do so :)

> --
> Michal Hocko
> SUSE Labs

--
Cheers, Lorenzo

