Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343F0C4452E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 13:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839CD6B008A; Wed, 21 Jan 2026 08:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7976B008C; Wed, 21 Jan 2026 08:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9486B0092; Wed, 21 Jan 2026 08:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7456B008A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:21:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA629160286
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:21:52 +0000 (UTC)
X-FDA: 84356033664.16.791B66E
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 138D81C0008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:21:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NezgELxr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 37NJwaQkKCKcHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=37NJwaQkKCKcHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769001711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WWsQUZNrYfiIWVn7HrRDJlzmTvsFg0ts6AaOLpup2w=;
	b=VPDjxrWbwUsqedYMe//0bFC2HkKyxu0RrrO+pkmYShGfG3ljScHr0nMuu5WImlmVp98K3L
	2ou6g6P0QLtWK0aH2JYPV3/GK5tuEY/AhBNC6v4C4SOqp1xNzwh4d2zKY9AoKlVYuOanx/
	oS9NMP/8wJb6B7EDrXINluNr5buAZLI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NezgELxr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 37NJwaQkKCKcHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=37NJwaQkKCKcHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769001711; a=rsa-sha256;
	cv=none;
	b=yB0YQP+YGFyj+6BR8BAotV/5UkY9QOcQf6h8oqsk1+ZG7x+crpCInVNKHhZRLPegNcXhwR
	5yJqO++e1uG+d9o7MJNYq4PgKTjWTPTC/rn7i6RtQqPJgT3ex9HOfgp4efAeZLnWjeBgfQ
	xpypImmrmQ0uV7LZ+2yupVa302RrEZk=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430fdaba167so4467366f8f.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769001709; x=1769606509; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/WWsQUZNrYfiIWVn7HrRDJlzmTvsFg0ts6AaOLpup2w=;
        b=NezgELxr//Bq2YpcEnaTvNnYdk7uHJferZ4sn0ikWFyrWz0bCUppJYIOBm4cAdvXlj
         8xeQY6z6LZC7+pfeJXutIETT24Fm4yvvQxvaCPDeI8HV+7zmot3VDVPnJtqTyYniADGU
         WyoUahtTBFl+l68TlzI5hGlxaZBe5joQQZaH175IbbytwNaTqzxIHuEMHRsHp6/1akbh
         3r2yBwupwh4uk5AbbZpR7evi7UP8HkmlKEVNASe7GD+oLYgCKoiP7qXCtNn8bk9AsFT+
         wuFoUOpe0g2mPAgLSpytui1tjsHJl0Opfik5M8uppYUnhCoVWAdiZCrlqhCvqM605TZ9
         HIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769001709; x=1769606509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/WWsQUZNrYfiIWVn7HrRDJlzmTvsFg0ts6AaOLpup2w=;
        b=D6tJQA7G6VjBy46Rhx23poPbYPKR8hrlAo1FELG7qiaQUnh9ejGRyIQRFhVKApTq8f
         kbRiAXfAOBP3pyzzLwUdV6TqNyR+Z5lTP7yb0qXIvnLIWoqjp3GkTFQxiTYiB0qOlglB
         ai9zyu/nII7T8c9A5MESaVKYNB+9ErgFE9DwWzok5alQXvCFPshTVYjPMLt84vTM3s/q
         35ncgplsKkgQaUEg7wsI+51izuMlyJ8gLYBaQfDdAsav2ZIj5fLxxpgdLAWMoCwT+B57
         u0VryqtD//b96b8A5QobewL8TRqeEllJHVYnh8WSRnks0VFsiKKfgqyiE81Q02KlL71k
         nIZA==
X-Forwarded-Encrypted: i=1; AJvYcCVfP0FbVZctFucdLtvAhJAQBpG0rUos+BxNoXIpGm1w40XMBNGHppu2H7v+7i2eRfIH1O7Mx9sO8g==@kvack.org
X-Gm-Message-State: AOJu0Yz6pBcmMvwQPNX+xm935QoxuqDn3ZAc3RAhDf1YTN9qt4qJM5a4
	agwTXXwCUjLtJwf1BtKYrg2W9hMK3fDp4p8nDyDM14Bluf51dUkCJvEVNjlAtRzFnOVyEnuQeqo
	cYI4GuQ3rFo5xC5KrIg==
X-Received: from wrbck4.prod.google.com ([2002:a5d:5e84:0:b0:435:8ddc:d1f9])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:3109:b0:430:96bd:411b with SMTP id ffacd0b85a97d-43569bd47e7mr27556618f8f.58.1769001708212;
 Wed, 21 Jan 2026 05:21:48 -0800 (PST)
Date: Wed, 21 Jan 2026 13:21:46 +0000
In-Reply-To: <aXDRHerRiM7TzACy@tardis-2.local>
Mime-Version: 1.0
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local> <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local> <aWuKqLERqpNz9qtz@google.com>
 <aWuV858wU3MeYeaX@tardis-2.local> <aXDCTvyneWOeok2L@google.com> <aXDRHerRiM7TzACy@tardis-2.local>
Message-ID: <aXDS6rNbsWhDVGK9@google.com>
Subject: Re: [PATCH RFC 0/2] rcu box container for Rust + maple tree load_rcu
From: Alice Ryhl <aliceryhl@google.com>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Andrew Ballance <andrewjballance@gmail.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 138D81C0008
X-Rspamd-Server: rspam11
X-Stat-Signature: b7za1r6ok6468ipt1s1a6bnpbjocptyj
X-HE-Tag: 1769001710-669594
X-HE-Meta: U2FsdGVkX1+A6J8Xg0hyoUy+Qb6kQZkRcfA85+EcZKUBUm2hyriaXzVWlQK0ras4NDynzrmxQXjqM3ejIVshv88bB7ESMeak08dViypRZ8zKT16lx9VW3KWxX3c1L3Wmhe3FZL8Gf+SdyOeSupBjUvxUrFygTrATMTWBzkPk1gUwvJlXU4psxpooGPX3ORFQXCh2gUuNZUYbCJ2c7uaKfVPfTRPvKXHEHkC9kTjfckikw2gY5zqAk1QtAOyrdZoCgzbVSp2ReVnM01w0l0DTTpjZVkgGpCKxt23Yt/Gxs8E9MyDoItT81q3uCAc67SpC5sRpFlOtzd13ECA6jsPCMaHyNJMwR3FipyWHlST/MiAwEiFt/T9pq7Om8AXk71SJWePTy0PXYnaufgMkN3OY1dFi5B0DVyJI+Q8V9jJF3iTzDEp09GWusRj598/wHGRv00EiVX/N8lOB63N0Mi6Y8qF2nQxGzlaoOZUB0L+uZNhC9gCvXBSOPtSQzVPaFjAp4dfzawhylm1YKHXtVyg4FvQCZ6tm8ENVyWrI1yYRIDRf3IYcQgRDN18IaU1rzDw1ZSd4jI/HDakrTIrs1Bc1izrPZfN/hdMMkz8lOtvgDUT9U3kGYVpEskcfUORPoeqQo+MDbjYywpqQPDu/ceQ9cB4by8Q2OGzzv/SDurlrhjeOGtNsQkqkCjxOcC/SLyJtMSdjRUCqX/6feXyJ4d0se+AXmyEbfI4jbcU+IRc8FCEWtb5p04qHGwmhnD21vKrodQfR9jDtPOik0MxZ78YM9eykviioF1VKCKRh7v3vL+nv+IWxH1+gkwJBY+Ra3VUR5poFEJYqrBru5V95rs/K1yZGRBw1iQ+wm97otZ8MRbnxwqyRUBONsvVxry11LfkugnxVmhrC/B4c6qqlg7v0cjdBJzOa3vJ75eyXk0hVcxuqZMODzPlk6hAvbNm3Ms9zhkiHZFKmUmUY3jiSOEa
 I9GQo4/B
 lKejUCaZNkgzifc3Vj2swFhIyGJ94Gfa6hUXWH3vHqmkvoc8n4q0cJZVkpzLs5sj3SHZmC/Iq1ZTFzCeGRJM9n5yT/zepiLu64J87nhE4QWKlXZc6MJMU45LGSTE5tYf/0KvRd/tFJvgv5lDjISyPo55REWkksCA8AKpNlZ0iEfo6Dppp3zMCNUQumzH4zzbncEevO160mAWF50z/aifRodZErS/kGt+0rnFr6sH0PxH6CVzTGz0g+zwIt8Cy37pX11tX/hB5ePw0LwNS2t1ZdBdswq/knJDjtEoORn9qLtj5QOEQDbcUZMkZBRX4gUKzVXwCjfr10lO0F7SMtgMKCAVZlvyPDNjeZL0hKerPadsByzeUtLdzeCkeT8CHbREQ+8OdWGWY+yfNB6NoAugY2RAtzXISixKOC1KJJ7N2zzfrG8hHzDO586q+wJhqUnjXOUjqm4iWdWUi9yZquzON5eCIx5hJXnI5vRoguxyiO67XmdCkAqYJFu55jLLG+eTEJMlR6zi1WhPcKICvjef6YPJVkCh1u1aATfklmhSlGKtJ/TGiPABipVQ6Q3PjA93GYTrqrn69wCAkwxOWASe9yOBnipz7P4xMHZyfgWreQ1/m0LZcvm/60l5tFDK2k4kC0XATgQh8FV2E7RWWC1kEetrtp3akLhBrytoXRV3d4GzjrXkKSGoNWf505Q0AkK+uOv9WT3u7gjUBVjMzav8ZTFYDJYBj5TkjGZpq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 09:14:05PM +0800, Boqun Feng wrote:
> On Wed, Jan 21, 2026 at 12:10:54PM +0000, Alice Ryhl wrote:
> > On Sat, Jan 17, 2026 at 10:00:19PM +0800, Boqun Feng wrote:
> > > On Sat, Jan 17, 2026 at 01:12:08PM +0000, Alice Ryhl wrote:
> > > [...]
> > > > > > 1) "relaxed atomic" does not sound like something that provides an
> > > > > >    address dependency to me.
> > > > > 
> > > > > If you look at rcu_dereference(), it's a READ_ONCE(), which is the same
> > > > > as a relaxed atomic load, and yes in LKMM, relaxed atomic load provides
> > > > > address dependency (Please see the DEPENDENCY part in
> > > > > tools/memory-model/Documentation/explanation.txt).
> > > > 
> > > > You argued that we should rename READ_ONCE() to atomic load on that
> > > > other patch series because "atomic load" naming is better than what LKMM
> > > > normally uses. Fine, but relaxed atomic load is a much worse name than
> > > 
> > > To be clear, in that series, my argument was not about naming, it's
> > > about READ_ONCE() being more powerful than atomic load (no, not because
> > > of address dependency, they are the same on that, it's because of the
> > > behaviors of them regarding a current access on the same memory
> > > location), and we want user to specify the intention more clearly.
> > 
> > Expressing intent more clearly is fine with me. I still think it's weird
> > for us to not have READ_ONCE() when it's a primitive operation of our
> > memory model, though.
> > 
> 
> But in our memory model, it's exact the same as atomic_read() (see
> tools/memory-model/linux-kernel.def and search for "atomic_read"), so
> why do we want to have both? ;-)

I've been saying Rust should have both because I've been repeatedly told
that they are different. If READ_ONCE() and atomic_load() are the same,
then I retract my concern.

> > And I also think we should consider using an implementation along the
> > lines of what I shared for our atomic_load() or READ_ONCE() or whatever
> > you wish to call it. The perf impact of helpers makes me sad.
> > 
> 
> I'm not totally against that, it'll actually help Atomic as well, I also
> hope that we can use `asm!()` to implement the cases where
> `{read,write}_volatile()` cannot cover. However currently I would rely
> on helper inlining to resolve this to avoid duplicate implementations.

I'm in favor of using helpers to begin with. I think it's probably worth
to do atomic_load() before we do the other ops, since it's so much
simpler to implement that particular operation than the ones using asm.

Alice

