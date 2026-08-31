Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA6B3C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894656B0088; Mon, 31 Aug 2026 06:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844CC6B008A; Mon, 31 Aug 2026 06:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733F86B008C; Mon, 31 Aug 2026 06:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC1A6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:29:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6DB71C1FAA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:29:00 +0000 (UTC)
X-FDA: 85161191640.25.0337A84
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2CCB214000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:28:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=JYkRuxX8;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Et4TbARV;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788172139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXHuqEMVd5r9Kb5uP27u7BqXJjMjwilyDDUTebyzQX4=;
	b=pxeyyyMN73Egh9OY8Tm1lou+CSkk1BUccj6QRCnkg2Bo0pjv7SGFJn9gKjpNaFxayr6D09
	PAJ6car5k4SCrBJUvnTon3LcZ4/+U9LUmuF1KTHThelRW5KaWl0eWeu6Z99OUcOzfbISfJ
	/Gy14/l+nDG60S5unIc6WUy7o4+2MHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788172139;
	b=EfmYDQhmgxM+kX6IH4VAsTiOkQ+MnFkEE9adxA0+C8H3DQPDMbVR7MqszOnnARRyPYgDOz
	3SI9mU/pn3ycc2o9sLY0Tj+4oPgbD/eqlsS8RRO3mVKSrBgqCIdvzeq8j+oSGz4mZ5S0Vt
	TPiYtu/XHZmWj9brp3DO4CDI7T9Rm+Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=JYkRuxX8;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Et4TbARV;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Mon, 31 Aug 2026 12:28:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788172137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oXHuqEMVd5r9Kb5uP27u7BqXJjMjwilyDDUTebyzQX4=;
	b=JYkRuxX83aiixALIH7LLrCuWfxOud3Br3FSshGL4xI3IdQvN9XSlMmu9UxGk6/A+5+c3DY
	Jfjy372gb3H7iLhwTdYDIiMBaXVgA6tz3qpal8gd1kBPJv60QkaQAB63M7EFco488RsIOJ
	MqFH//swaz9C0f5YOfAD+ftkHb5S2K6VvnOMLNn8u73TWwCYKqODgm/J/eGAWBg96bbOvx
	lX3QdIYs+VDnTM5Nc4ZTahOywMtiGqmYNIGFMQH6WKeFCHNX7EOUlC3KU2HhXJlcFxbnrP
	e+WMcoP0ACKGDnt0Y0WjylGZK4jJ2tSIoxyrhassfnyNylw59XtGAAh612xgBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788172137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oXHuqEMVd5r9Kb5uP27u7BqXJjMjwilyDDUTebyzQX4=;
	b=Et4TbARVJGmOcZqp3pkQLXcVtfr7mVUu6imjMFJX/FcsrC3o9JIydz2OmEjj6aIWUr1Lev
	ICbpUTmyuxiUdpCQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Hugh Dickins <hughd@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in __mod_zone_page_state
Message-ID: <20260831102855.TOx0U8Vi@linutronix.de>
References: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com>
 <apNjw0HRyr1Oj7q4@linux.dev>
 <apOAF5CPFWUUH9du@linux.dev>
 <a2288e73-5001-2104-1e7a-2b383e7edd61@google.com>
 <apO7GDwIgyhdn3t7@linux.dev>
 <4793259a-00da-ea31-8cbd-a6cb5bf48692@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4793259a-00da-ea31-8cbd-a6cb5bf48692@google.com>
X-Stat-Signature: 74y8oeqh4jc4hz8bw3pdzdm6b53kz3qj
X-Rspamd-Queue-Id: 2CCB214000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788172139-204642
X-HE-Meta: U2FsdGVkX1+xZfSg8v6ewPhFOgJKQkzoM1LQbFLZzlvciIw2CZ5bDfUFWxZLPMeEWwaLhfl6gdfaX/tNWppHSph5leN5ff6I6+ZvSam63sD2DJH2ofne4ghibwORNK8ky0CBR5urRI+QuTD/JphJBp6oj6QjDxsIF+vk7N+tEQMYOS+wkMLDzdTQQkLtusiin61sQagW6xqpSx4menlRj9TJOSY+QsTa34Cf6IbHpwCjg5TWvJvpJIGnFO4FvwLdTsYOxHpQzRgksaZe5dFz1L5NTjxE7tbBd3ejgrzlU3My2sD2P86T3/y6bHKScq+zHWLpqRQUAYRU2g5s3zXm0lHvECal1wGt4hTFzE7VDnQIvS3gklI+gKLpUJw57dE5UItZDZkqrFP6i42sDivtXbJiVocTS8UzV7TDXzovjxKzDZ2Mfufuk1uJt7E4091zhDiHMkCCVpk2pq0rc9QDZBd0SUK5jDx6p2YtNtTyVKg1Gx16lB3tQX87lp/raOUgpkFE9p4Q3RGlLZVcVdI0zFsXUArYcyZSAblmlj7LuP8FU0s5dq8etylq3gfCLvALNy0dpTze0faPVp/AhmgYKVWBw+35X/FosX1CY8+HknHQ9ybwsIhamKfwzmG5Me4SEAK3C62UyUBcgBESsd17sXXESwooKlQDnmsFcGELI7zDx8d7dpdn+qhleYTCyJSo77cOLPfKdigEpSHgWLeSIS+JXRaNtDrzxaIZ5rI4nyO5rdXk+pllPbLXvicxpeyjZQuFbU22lIeET2QJgxdnHNvEE/GrdsmF7d58lkhcHfO3/ypDcCVhxw341SXfCfbCVQFrC6c6PjiGAhAhy56gCbVfdZha1bWaaFC/ECuOqjkzrOT3rJ6iIbbis0Ywgp8QKsHiY6qUDhfITbTJQRJtsVKZI/7/Gtm0I0xmQs9jU0jsdYMSPfNP6eLs1WWa+wz5hrUE9msbl+lxp+8dgmN
 Aub75gjn
 zrdrfR9wHISPrAyDCddvVSmMjY/gCdDXf1ofn4ljF+NGu9SdoEou32sE9AD6FQHn/7AT4Rl4j1P1IVYAxQ8vcNAVwBkvybJANi3dpPHeh0INLEJ0nJ+Pe6MWjkLx7syUozInix05XUkKXj6/LN/6MXDHx0dwz82pQXBOSQdF9EDc6TyRHjiWJ6N52bYhVTBDFdUOwxg4BWM7ignHJmG3Vn2+zs+bx+2kDu7pQ/5d/5yZMYO035/W/KiFtkRhJdnZEv6w0fuoLBWamRr445NSN0QXNrI7B0SmjC4veqZcQT1riolWdWfvclv8ayFViKRZnUNkxMyGtYNiQ9TGlZNCw4f43cO/BKY+NfptrlAOzattEPcKtUtW1LClb8T+OyNY5hQcIEAeWVZcHzIEyCyyMU2zWj6JqmtYrk/1E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-30 10:29:46 [-0700], Hugh Dickins wrote:
> Oh for the good old days when we were allowed to say preempt_disable()!

I'm sorry for taking this away from you.

> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -141,11 +141,16 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
> >  
> >  munlock:
> >  	if (folio_test_clear_mlocked(folio)) {
> > -		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
> > +		/*
> > +		 * This runs both with and without the lruvec lock held, and
> > +		 * mlock_drain_remote() reaches it fully preemptible, so use
> > +		 * the accessors that serialize themselves.
> 
> I'm very far from being a good advisor on PREEMPT_RT,
> but I think that comment about lruvec lock would be wrong there.

This change would eliminate the warning on !PREEMPT_RT and not cause any
further trouble for PREEMPT_RT.

Given that this it might mandate for

    WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_VM) &&
		!IS_ENABLED(CONFIG_PREEMPT_RT) &&
		!!irqs_disabled());

in __mod_zone_page_state() and other places where
preempt_disable_nested() was added. The counters do rely on disabled
interrupts not preemption.

> Hugh

Sebastian

