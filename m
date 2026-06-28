Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B425C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 17:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456C16B0005; Sun, 28 Jun 2026 13:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406DF6B0088; Sun, 28 Jun 2026 13:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D2F6B008A; Sun, 28 Jun 2026 13:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0396A6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:05:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6682B1C3322
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:05:02 +0000 (UTC)
X-FDA: 84929946444.14.9163B62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BDA9B120006
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:05:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBVRzBQl;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782666300;
	b=NXuJuwHws9CYGGG+dFhsise9ewy1LD2jjGpKHHY9RHsD9aFfZMW1mpAqZvQJegkAq9JUun
	a1bpp+rEVJdyJ71a9Wob4liiQnesKtHCYmUpL5qcB5SjyqU9OxR+F1J3uUc1jyP6ZFbdOb
	AzsFzP5PUYtivOAD3nXooOeQlwAvqIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782666300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ymacN+/8XLk9vgGgQDu7elYRViiHjsgkD4GV6NQOeo=;
	b=V7plmiGrQbXQzKP+XRg9fe4ba8YwYFSRhka8Bz1Bqq2uxroboGm8XwD53XC7gsdfsCWQ6A
	BeVmp0JZRLI8rj/5Jl6IcEq/eMGvMvKaPUc+n7IsZ8HeQZpDoyXUIJKJQArFWhEMFTWxAp
	1embMEOAcZ/2JMvll7FlFupZq1o5X5I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBVRzBQl;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC0D8439A7;
	Sun, 28 Jun 2026 17:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985881F000E9;
	Sun, 28 Jun 2026 17:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782666299;
	bh=/ymacN+/8XLk9vgGgQDu7elYRViiHjsgkD4GV6NQOeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBVRzBQlIrFuu2OUTsWUbIox+hZloXoDBTy2pGUmntedummE3L9kqa8ZfGuBBGr7Q
	 uYshUqMV/yFoM8+/atUm/RI/XgPlJQi2ba/siXveguUzhb5eUD1GhwSehIrTMQ/lOB
	 cvwjL5Ie+qOqKMYW4toDZ9Cua/RE+4A2QnlpX47+VMJgBhCpH3bzrfARSKFfNr/P82
	 YpH9wkVYtOFcOcnidfqvV7tq6hKjr8i6oGARSx3dyoJIihFOx4FJTENEu5sMDdEnxL
	 xrKnJWXOiCw3EdgO0u/3eoxXnSZNaPIiXM+PNmcjpyDwJMxvXUcVnriiFdfGJf5NoZ
	 Hj38E/WLv3Q5A==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/reclaim: add 'available' memory as an optional watermarks metric
Date: Sun, 28 Jun 2026 10:04:45 -0700
Message-ID: <20260628170447.88064-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628085547.21814-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a1ujjdg1tnx77ywwfgp1qfh95bcwdmt1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDA9B120006
X-HE-Tag: 1782666300-990803
X-HE-Meta: U2FsdGVkX1+3FkpNwP3iYRf+0N7BbzVV5Wyi3DXnd0shvBItC82VyrIqQPh9lDk+PVZvuu79fYq08sY5busn+XxuwRCYM/IsBSYkicJZzXxSP05046LjIq1XMmLE8a3oPR7egnXFkxbJYWuKs6/6gAZDiT+yPXm+/kxgodHgjkq1Cw0hm21fpmONthPxfuTvRQcCOr/UkbwLFrsdBHDN+4QIYgRPkqbQRyOqGg+rn29bUXwXkcGmmBtfYzxxXf97YhoJzCmly6D+suO6YsR64DwSTRsb92kgFB3uvRAn2aKQKAEZRRHYdLO1fiWSs222SYWBKcD8pqS9ruevurrdR+I7H2Qz+IRut1WLQOrcCE7vG+NPW3o0hyaGk9ledIAk2K147STfZBM5mV/beRw9KoBkRStXoWTxs2/WMZh6sjKL24NDBGkBX87H/167h9t4un03NAif9EEQsUBP6ho1g4StcGnuWMicUI89sKOaQ79aARFCC4nenrc/MTZWoubb/x4rG0m1AguVkyO2JZbaiE7LOLiO9XXDAIaNnAY3nMH5BInNz7enWNJpyIYZdwyve6qKC88iQWnlkNiSw7XHehUd3ObBnKCrO40sbabdEX+9z9APtP8d3/ZEXQ26lk5BIH929/fZzABGLJLjMhhyyGgqOGEpxqJ/5krTuG3cFqL2hJXwwKxkhvzP+eUWpt58jw+AjcG282e/QPzaTyBVMBTrItENwQa3KqgUorGDyQrfsE4JItsh91EZ+BDlYr9Nhklt97ivPkI4d/ggqe6pV5KxkPy2YsIihRsvL3CUqUxnTPK7fD1zZt8tdaAvk9SgZ3ptJABHAyG03cXYEgxq04up+QDTYbf52OhEEFmM1X5MtvVIbKZBKrWyo8VXcM1SrIvsjClBRm7u16ViY0YYjmAOoX4QcHcWdiALNl3B9h4r2UIe0mo/E+q79ltDXwFqzTSo4ya54N9T8lVEqat
 i8L+BfNf
 3xPEDlkGsZUmWWM/F63L6tdbHLguFXAUfSWpBVyoC4Rv+zkdIB3J0hz0DEihT5dFeKJoPoFooJRtCW6sWlx6ffoOm0ESteG7Kv0Xf09M7n9qtAJRcQaYMjgOcEXuTdUuFou3qVnmqRi0ldGKmmN3vrCML5XYeGM6nLqIYnpmmdLb8o95feXPNxHLBwXg9I96/y6aQkk8siRw/SgQMFUY4Mwgepbt8X+QEZFMTRc0I2z0lS8xl9D+InMCVm1uHXvWZ7JbRt5r94tPazG1ODb1ACPnzs6W469fZslVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 16:55:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Sat, 27 Jun 2026 15:26:43 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > > I will drop this patch. I think controlling DAMOS pause/rusume
> > > separately might be better suited for execution in user space (such as
> > > controlling‘quota_ms’ and ‘quota_sz’).
> > 
> > For explicit DAMOS-only pause/resume, you may also be interested in
> > max_nr_snapshots [1] feature.
> 
> Thank you for the pointer to the 'max_nr_snapshots' feature!

Feel free to let me know if you have any question for the feature.

> 
> > > 
> > > By the way, I sent you an email about three weeks ago (Fri, 5 Jun 2026
> > > 20:28:00 +0800) introducing a userspace auto-tuner program I wrote for
> > > DAMON_RECLAIM's 'min_age', and asking for your thoughts. I am not sure
> > > if it reached you, could you please check? I would really appreciate
> > > your feedback on that as well.
> > 
> > I don't recall that mail.  Did you send that to damon@lists.linux.dev or other
> > public mailing lists?  If so, could you share the message id or lore.kernel.org
> > link of the mail?  If not, could you please resend?
> 
> I hadn't previously sent this to damon@lists.linux.dev or any public
> mailing list.
> 
> Since I have completely rewritten it (the email) and it focuses on a
> standalone userspace program/daemon, I have submitted it as a new
> independent RFC thread [1] to avoid biasing this patch's topic.

Makes perfect sense.  I will review.

> 
> > [1] https://lkml.kernel.org/r/20251216080128.42991-8-sj@kernel.org
> 
> [1] https://lore.kernel.org/damon/20260628085155.20828-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

