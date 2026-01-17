Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA98C98328
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 13:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219636B0088; Sat, 17 Jan 2026 08:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7B56B0089; Sat, 17 Jan 2026 08:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9C36B008A; Sat, 17 Jan 2026 08:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3BA06B0088
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 08:12:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78420139BE5
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 13:12:13 +0000 (UTC)
X-FDA: 84341494146.08.4813652
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id B989B40007
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 13:12:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zVzRD7EM;
	spf=pass (imf07.hostedemail.com: domain of 3qYpraQkKCL4epmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3qYpraQkKCL4epmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768655531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/Q6sSsKEIGtbP7mr4JWHCQZmo/e0ttTsHB6ivhULNU=;
	b=XRm8P3TDwWHwyTZZM8CAqBllFfxtOATJRhSZoKW4ghG/7JZX2VyOZi8Y5wk0BXM0Qel6yG
	0Yw8UdVQHtBWnqT5hhhZ0OBhl1gJJb8cFKdjCBfTeWgIG77js88s5IRhloLoq2s2yewz8G
	MOuPlA5n74xggGBNq/flxOIdgYzI5kM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768655531; a=rsa-sha256;
	cv=none;
	b=ULwptlamYYe+FpdQ51+0jFIAhpQO0XaVlZtM61pfPu4HKI5UjiwOWUpjo0OfRXts8c7I7h
	uT/Dj4QwXs8zXOS0oYzGST13YaA0w7zSSVar+RKxdseR5NxWoKUc2WaKAaxAfNcpQRavbA
	mj5orQXhw/G+FcDqSFVt8GTsq/weurs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zVzRD7EM;
	spf=pass (imf07.hostedemail.com: domain of 3qYpraQkKCL4epmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3qYpraQkKCL4epmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477c49f273fso28186975e9.3
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 05:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768655530; x=1769260330; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Q6sSsKEIGtbP7mr4JWHCQZmo/e0ttTsHB6ivhULNU=;
        b=zVzRD7EMJk+Lf2RI2azYR4AfZROThqQYx+m2D2y1y6r6MUnU7l+efT7lrYQ9CDlsEh
         guSJJZMczK6SrFAeF5MFehL1+MrvEwjWCprv07N5X14x8j+pQhbe5Wj+VLt97aceKHiu
         rh8uIxARLG1mgbt9BNNAKk0+260dkEnj/jfL5cKHntC8+XUqJ+JYm4Q2uEh0gYgXKSz/
         m5YF4Bu9BmAtvORTBbkRQBUA6G0jMYI+ZF3UTIWJtuJ2SZHVicJ2BX22vrASfX8Iw3aa
         tJx0Nvai6Y3uKB62GMwH+Fhr1UMjZbto2MlYxxVAEuh2pCuiBUggjpF8jjZLuTRwiFiM
         ZTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768655530; x=1769260330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Q6sSsKEIGtbP7mr4JWHCQZmo/e0ttTsHB6ivhULNU=;
        b=SO78aXCh3ubuAOK5QUZrJEUcJLfGdCOIQMQGb/xkXrFtsqUv6UT5qCetfQGX2GmWXl
         yuSCxqZpLXlty/Bf2akqp/pWXzWpugZGGDNYW5bP1ECuBF5y0jR2QCLseijtD6o+rMzz
         OjPSeKB3D5VApg0SAp+cWMLrEAkyRuazWoadsU/AQb+Q1ZhAPBPpNn5x/XbrJpe2APGi
         AByCXwRnEkVkX1xI5LX2A25f6Z8xX85/SZ44u9ArwovZNuOE7mu9+bmj7EnywVeqX0Bb
         jxUVJK8aGqHO6P6iOUcgSRVf32xWuTTagJLHAz4hxIx5S3o6jjvHOAyDqfIRBzeFw3YV
         MHGA==
X-Forwarded-Encrypted: i=1; AJvYcCUZ2uuN5rO9z6jJQfp8bEGsqNIIk/7RB/uF/bxkgugZxfAkKU/vH4rwEH4JKCPTwn8ZIvtqPaB90g==@kvack.org
X-Gm-Message-State: AOJu0Yw+1d7nkdqMW1/bkOtDsCzjmxGYBe7N54q2VBW13/rvYF9yE58Q
	j2DSR9MVd9rodSooZ+CRoDbiD4UnKfvY9J7xEByd8kxY1Px7hr6lzyjXaeV2DRE+Qe49vwqv/dE
	0AXzKc2GTru/SUNc2+Q==
X-Received: from wmdv17.prod.google.com ([2002:a05:600c:12d1:b0:47e:db37:5b61])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4586:b0:477:9ce2:a0d8 with SMTP id 5b1f17b1804b1-4801e29edc9mr73321505e9.0.1768655529859;
 Sat, 17 Jan 2026 05:12:09 -0800 (PST)
Date: Sat, 17 Jan 2026 13:12:08 +0000
In-Reply-To: <aWt8Ze-otTkexNIe@tardis-2.local>
Mime-Version: 1.0
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local> <aWt4muGXbe7lBmXt@google.com> <aWt8Ze-otTkexNIe@tardis-2.local>
Message-ID: <aWuKqLERqpNz9qtz@google.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B989B40007
X-Rspam-User: 
X-Stat-Signature: anungz5m77dsum5wrmwgrtcxxe4u7uoz
X-HE-Tag: 1768655531-512846
X-HE-Meta: U2FsdGVkX18uT/qB3ej/6KB1GWcXazwqiqllKtGZz8w+wZdFclxlNYv/BCUUqw/++ES6BpQB8imRepqKRVulXEii6nipn6KlEvMCFW3mClZrBKwrhRYoibNQxNoLYXnRL785BuQfr/IJd0t8S63ZqVLlflQOZxFyBZpoCt1GpCgwgMNJhCNcFdX6Lm9MUksAQbRBgZwujdHG4NRhdkOK/Snk9GGAMhj4qof28NMRV5EbMASuW7HJC4MACLC8Ss8IWN9+B5xyh2iPsQsUzfIhmrB0C2O117Vbqr0XTq4V7fi1mueQf5PJpOAhyBzedXtx7qTjJDbhhAymUi+4KK28br09N2yIVG9JecgY5/8sUQU7ELgpchuSFgQ0qc8tnXJiNkuUdy0jNirPfjHetxnBNqMde4sHRMJhbQsr8NRUFF2cZfhlVy8qq0NjWMu7kEpIzSAJZkEcGYhnPGGJvW8IN+/D8q7vEBKqWW7zZl7p8sVtpZWt+4eCFTQkpGOTbCW1wF1H8GCqfap/Ub5UC2aGWODNwShEYFuOVsXXtTvnopZSnxs7PGiKji3Ypz3UDnsv4ks8zBEbR+nt0vyOnFSR4HHn36MFniGsAGCa/44BLUZZii4Pwh8Wys92BlybDGLSgLucijgyE/84wEXv9T8B9LC2clJkaP3SjLE1qCVr16Pqb0gHD31RVvZJqNAW0rYWrhvbyubxnvkv8QzreUOQ0cOiUwEIV077gasJjQU4FR3inKgxb6u8chBnVB/N8UQoIvNxQFNNMUp/DTVbPYVLWwVJ+aSnGGKk+lx5vSH5yMsVWt5XDROuTe35qXAVINBGHxkroUWPgAVb43hJabk97uyx3UBqdI2pWuUnqB/5zxhYAHqSjJhlGjWpjq06a2MZ4mP9xWy2daVN1l5QkxkRh547g8FNZbQjtcwhwDdW9OuBu5m/q1o2TGHbbyQhwLSAJeiL2XJo2McugQR/bnD
 aj6szsYG
 JBziU0TqYzM4tNgH4xJkgQ9dvGinMnOId08QgIP3MYfQ7P+mfhDU81vBoWCy3W97sZFXMFGh+XQ17twJ85IKTzbcJuhvi0isgNIy0BQAemcEOD5YQ38qsvj9Dzw4COm5IRiBGhakQbVkYehRYg1q+C4jkQ3fGfoM+uuxJzPveYf3NnIH9fgsyc9m5P2tRTTCaqEP9/eGLACtDJR/JKi3mxsjTswrTwpkDBa1oxWUbp/G6F0x1KWe4koplBspKyTpigcWnnezTbdHRiB8OPeI7tGRj9fYJNGxqCwfyP4TBEjonBvKF7JRaLYX2ocFQB2GjTZGa76AdXpp3z4HSwZ2VbKMF9YEmCQz7bFO3jWBsXincE1G1mncGsADfxmPXJnWU+0aWIEgujYhpemh38DDI7FcgC/Cwyg4ZHvWy17Dgrmwl7ZphD3IvD2qjdC9X3OrGGlMjsXSNQkLU086RlVmzWVToLcg7RSq6qut67MRH5lpoVqvBSVUsShPYN/4mbNO3/5C8TZ/8AHBqGFOa5q3lgHcaJa03Mr+IsAkbfrW+g2IRZgGk97terYmVauCooG/RF8vmmAR75cjmzo1hZBjqpw81uxlNH3d+UCRKCV94aHwVTMvORwW5dntNdzq8qYYrSvodbQTR4m13X8faJlGTnwf4kukDiAa8W8n1zGsQg0OTbMD7TTkqyyeKjTJh5PcWr7SpY56XZ4Tb7z9BJA7aj4tGLUJBcgCzxxft
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 08:11:17PM +0800, Boqun Feng wrote:
> On Sat, Jan 17, 2026 at 11:55:06AM +0000, Alice Ryhl wrote:
> > On Sat, Jan 17, 2026 at 08:06:40AM +0800, Boqun Feng wrote:
> > > On Fri, Jan 16, 2026 at 03:46:35PM +0000, Alice Ryhl wrote:
> > > > I'm sending this RFC to share an experiment I'm looking at. This may let
> > > > us replace the range allocator in Rust Binder with a maple tree.
> > > > 
> > > 
> > > Thank you, Alice.
> > > 
> > > > An RcuBox is like a Box except that it lets you obtain a &T that
> > > > outlives the box by a grace period. It does not allow mutable access to
> > > 
> > > I think the `RcuBox` can be folded into the more generic RCU pointer api
> > > [1], e.g. Rcu<Box<RcuBoxInner<T>>> where RcuBoxInner<T>: HasRcuHead. The
> > > benefits are at least 1) we use relaxed atomic read for RCU readers
> > > which guarantees address dependency that RCU needs under LKMM (while in
> > > the RcuBox here, we just use plain reads), 2) we also support mutable
> > > access as well.
> > 
> > 1) But mtree_load() does use rcu_dereference() to obtain the pointer?
> > 1) "relaxed atomic" does not sound like something that provides an
> >    address dependency to me.
> 
> If you look at rcu_dereference(), it's a READ_ONCE(), which is the same
> as a relaxed atomic load, and yes in LKMM, relaxed atomic load provides
> address dependency (Please see the DEPENDENCY part in
> tools/memory-model/Documentation/explanation.txt).

You argued that we should rename READ_ONCE() to atomic load on that
other patch series because "atomic load" naming is better than what LKMM
normally uses. Fine, but relaxed atomic load is a much worse name than
READ_ONCE() if what you want to convey is "has address dependency".
That's not what "relaxed" means!

I suppose you can argue that the word "relaxed" means different things
in LKMM than it does elsewhere, but I looked over the doc you mentioned,
and there the LKMM calls said operation READ_ONCE(). The word "relaxed"
does not appear even once. If we're going to change terminology / use
new terminology, let's at least pick terminology that's not
contradictory with the rest of the world.

> > 2) How do you intend to provide mutable access? By waiting a grace
> >    period?
> 
> Please see the {read_}copy_update() in the RCU patches that I linked.
> In short, you don't wait a grace for mutable access, since in RCU,
> readers don't block updaters, but instead updater will copy the object,
> atomically update the pointer and then get an `RcuOld`,
> which you can either synchronize_rcu() or {call,kfree}_rcu().

Hm, ok. I don't really need that. What I want rcu for is the internal
maple tree data structure, so mtree_load() doesn't need to block on the
maple tree internal spinlock. The contents of the box would be protected
by a separate lock (probably via LockedBy).

> > > As for the progress of that effort, the Rcu atomic pointer is almost
> > > ready [2], I will likely send it early next week. For the `HasRcuHead`
> > > part, as you may be aware, I'm working on a generic `HasField` approach
> > > to avoid duplication of `Has*` trait and macros [3], that requires some
> > > syn adjustments from Gary and Benno, but they should be available next
> > > cycle. I will probably send the patches for reviews before that. Once we
> > > have that `HasRcuHead` should be easily to add.
> > > 
> > > Given the WIP code I have, I *think* we are not that far from providing
> > > what you need for binder.
> > 
> > Hmm, so I looked over [2], and I think my RcuBox is an RcuOld<_> rather
> > than an Rcu<_> under this model. Though I can't afford to pay
> 
> I don't think so, `RcuOld` represents an unpublished object while `Rcu`
> represents a published object, you can update an `Rcu` pointer to
> another object, which is normally how you update with RCU. But maybe
> it's easy to discuss this with updater side code in picture.

When the RcuBox<_> is an owned value in Rust code, it's unpublished.
It's only published while it's foreign-owned by the maple tree.

Alice

