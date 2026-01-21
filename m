Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE987C4450D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCC46B008A; Wed, 21 Jan 2026 07:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184386B008C; Wed, 21 Jan 2026 07:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0739E6B0092; Wed, 21 Jan 2026 07:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED0D06B008A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:10:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99268D33B2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:10:58 +0000 (UTC)
X-FDA: 84355854996.11.F649F78
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id EAA0FC000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:10:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JFIbAubY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3T8JwaQkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T8JwaQkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768997457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ziR3r9m7pUVvYH96OZBkYpK+ngyEyWi7rW5109gK7C4=;
	b=Jd5d+KXsYTBkI0OuTr0GrPTt0JpN1EO4GJfLASaLM1TxYBpj4pk3UtNX5HI8jDf6rUSJV/
	De+8FZs67rjaSOHN9+zlq8z1th8Ka6kXvABoQV/hLh9H90XLt5nURjuFzCGzxDj2y3h/P5
	6La38AVbj2KhA1XKUajIRWw2dq6tfTs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JFIbAubY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3T8JwaQkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T8JwaQkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768997457; a=rsa-sha256;
	cv=none;
	b=K7kjD0+3CzyUNUOdfi8MtT+21RqB+MxMnQH/YfqPA8ph5Ck3VA4KoSuEQLACBFnHzBxwkW
	J7YOgDd4P3A8E9dXW9ECaqPsdbSlI6XdMy8ruXCB8+BoBGdUZPSXPPT6t3CvMbTVcImATE
	VoV8irUw09CsjE9J0ynilxGJZUCbsgE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d62cc05daso46897915e9.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768997455; x=1769602255; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ziR3r9m7pUVvYH96OZBkYpK+ngyEyWi7rW5109gK7C4=;
        b=JFIbAubYfevIPy5bGvo0hwHTk7Irsnxk/duDZvq/GJ6tOiMkZlQCrWOFSsMApblt1N
         H2eI3hhE+mIYiG3vvloP++y7PDFpLIYsT3PWlmHf3d3yZ2r0GVZeT9SXlJilCPNxQHoM
         ECzexaOlqsH0lS3/maq2NCvrLnwWH43F8Ku/w7eIexv6JbP/chW/mfzC1Wf/nN8Dv+uQ
         KtA3w/0fK9/C7wes5ixH8xvZblqOHgPNi5QS/1wK36wjKg8I9jU6PBcf+HY7TjRNZ5C5
         SxzzeYtEnspKC3wbmexS+EhyjRBhJGFgGHHjUVzi1YJej3S73ZlficTW09SSnJ15Silx
         fMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768997455; x=1769602255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ziR3r9m7pUVvYH96OZBkYpK+ngyEyWi7rW5109gK7C4=;
        b=GcUH7buCh5yfUKo0zCOXURiwX1h72I6lk0hcbfMp2aD7ApZGkpYfDAUWKbn1KSL8QB
         84gIbA06qL7W+L6XefO/kCIc2Cl8DGqTdLouQs1vmhZjU/Y+SEoKdbhBWOZmLNkdB5z3
         tu53N5y4z9iU/lMv4hsH1sWpoiLj19I/5QZXPZXRPGByoVMRx9QgvAPp6TmoeUVYHCrG
         vNSJEF5zWe8NPSLLA7C2KC8yZQewBf2oCFxQosNGU4A9OcFcbiNnmf7ytJ9/egVq8vK9
         /3Skg+8pUmqbSZgUNoL5x2XTIzRi3UBzNClrvCvH7c+m+tKIM2tWY0CpNfC02i6fnHbl
         mKcA==
X-Forwarded-Encrypted: i=1; AJvYcCVlU+jJa1evm9wD+DkVEtRLRAZDM3R1cTPji1u5aAPGQq/Ef9GhkvPLZqUdIuU+H6Ep6m9DlVUZqg==@kvack.org
X-Gm-Message-State: AOJu0Yx/eS6BrtrBE66jHZFoQM01RwvDmRzvFjyLrgOdIdW2RX1ahkOM
	PaZRc/aOVCEOPO4By8IDl8UElSBFnMcXpETNuPH2i5X6scKG9IK08Y/sMw8bK+zxJWMka2/ENip
	QabsOsTGtyGzwhUi/cQ==
X-Received: from wmqh8.prod.google.com ([2002:a05:600c:3508:b0:47d:5dae:74f0])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6388:b0:477:9a28:b0a4 with SMTP id 5b1f17b1804b1-4803e713cc2mr75064445e9.0.1768997455476;
 Wed, 21 Jan 2026 04:10:55 -0800 (PST)
Date: Wed, 21 Jan 2026 12:10:54 +0000
In-Reply-To: <aWuV858wU3MeYeaX@tardis-2.local>
Mime-Version: 1.0
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local> <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local> <aWuKqLERqpNz9qtz@google.com> <aWuV858wU3MeYeaX@tardis-2.local>
Message-ID: <aXDCTvyneWOeok2L@google.com>
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
X-Rspamd-Queue-Id: EAA0FC000B
X-Rspamd-Server: rspam11
X-Stat-Signature: fxkiuky1uj39ezi5eysth3oz1sae7w1f
X-HE-Tag: 1768997456-820299
X-HE-Meta: U2FsdGVkX1/VC3ogt9SnQ9+qIUEkUcfnqYL7UUtuuuzo4QC5JZEoql97vEY4OlBZkgUQ6FDcBdHUrK3MmRq1Uza3bbEX6j7c6M0/fZcJfKqSyx1/de1nU++Tc7EZ+d6ZgEhisOwFhmAHcIGb9mKXKB7ZDzuknE2ofAO5Frf2uQZIs5oiE+hSLz8sDqASTRCBnNPtjB5vjlKuuWMCIDB3Ji6+949FzSilrIaw5uzpTddtI5Cadk7rbexNnuKhIDyZgPu5R25kfTfkhK6ODNhPepVtPA9KuISzbjKR2ezU+WvILFgNYq28+mxTDdhxpPxRkv4KYtqnsOk056viM6ZoUjleCGpI+9HQA8fvX4HesRVUAV5p2QYHzL/BM8EKI4kWcPkhsC1o2kkxVf3dfYSSkk2Je0rHOohJlARHg4otxQjwtADf+ry/hkjCc+cMZXYJxu2mtfsJ8Z4r89iUkosv0TP0BN6IDUjootdD3KVNI3ZA68DBWlLsg0kcGBJw+HI8vJpgjsinlqcFMYAw6t7mna7Kf5zo+e5p7TsVNk0GupHXfH2U1smeaXvMtI8Gezoqi8P7mVhATRmjcAWbKkVKKjFQmIBZ9XUl6fkFNn9+0x5vnGm9XrHB7P1TptRSSYWKopYaTaem4vCOCBCwwhsFNeyRcgrviG+PlzSuEtzhTmpP9Xr9+dJkUuhf3bz2/NJa7J4MI4JL81GAHOmCT9YnnGRVDr/RTQsO4eL0hp+ZRlg5FYoXogpIYnBKJlPniEzPU1edd4bOKToBp3MLOqviXMDOfPuABvtGN1tjehsK5WFgXFEYFzZa0tOTuenctabqb8k3fXF/a6JbMm5zl6yI/Jqlh6TXMK8JODqVOUr6JV0mpgZxdL2UmpL0I3eMMgbpzndi6w/BnpSjLhI/CglgluIPTeL1obZkXUtHbgoOdW7eW5NxFGvOM1PpqZFMwMXtAe+koFVT5ntn8dqHVc7
 yrXKVRqq
 yByQ2JMxCuHPo2vZrvCChY4jP5Fi/mxTyXLXg2xe/NGcyudlInXP9Hm8l9dgv42ZF6d3WA8R0ikKNBPkrsZSROr08SpQM/IlAzVwgS08X6nasaAnBIm+ZYMsAeiSqnPm9E+mPZqHDTOtImXbTlA6JmYmsqtq4isH5Dd5ZV5oefhWsauJ0zVxQZJsuYzzwCCuhJGeye2440nLwkKNZTjZVpcT6IpnMFYssdp9OuFbBcAph9KJw9QXy//bffViY+289ce68qmRscRWiJbCPxaMloyw/BJhYnNrYamrqA90c44GppDsyE7HDPqvu/CajXuikjsFGaRxDaHKW2ZpedNjQkGeJQBzZFk8MqefsaYkuUILzDo9OmcP1xMvB5MO3ZgkQ5i4QWyZ0DcRSdEYsiw8M6zVNJ9cNVbE9VG1jn3G6vH/TZ66fjGnvQfNybQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 10:00:19PM +0800, Boqun Feng wrote:
> On Sat, Jan 17, 2026 at 01:12:08PM +0000, Alice Ryhl wrote:
> [...]
> > > > 1) "relaxed atomic" does not sound like something that provides an
> > > >    address dependency to me.
> > > 
> > > If you look at rcu_dereference(), it's a READ_ONCE(), which is the same
> > > as a relaxed atomic load, and yes in LKMM, relaxed atomic load provides
> > > address dependency (Please see the DEPENDENCY part in
> > > tools/memory-model/Documentation/explanation.txt).
> > 
> > You argued that we should rename READ_ONCE() to atomic load on that
> > other patch series because "atomic load" naming is better than what LKMM
> > normally uses. Fine, but relaxed atomic load is a much worse name than
> 
> To be clear, in that series, my argument was not about naming, it's
> about READ_ONCE() being more powerful than atomic load (no, not because
> of address dependency, they are the same on that, it's because of the
> behaviors of them regarding a current access on the same memory
> location), and we want user to specify the intention more clearly.

Expressing intent more clearly is fine with me. I still think it's weird
for us to not have READ_ONCE() when it's a primitive operation of our
memory model, though.

And I also think we should consider using an implementation along the
lines of what I shared for our atomic_load() or READ_ONCE() or whatever
you wish to call it. The perf impact of helpers makes me sad.

> > READ_ONCE() if what you want to convey is "has address dependency".
> > That's not what "relaxed" means!
> > 
> 
> Also note that my previous reply was explaining why we don't need to
> call rcu_dereference() from Rust, because implementation-wise the
> LKMM relaxed atomic load provides the address dependency. Depending on
> what we want to do, we can limit this address dependency only to
> rcu_dereference() and make it a special case, this means we disallow the
> address dependency provided by the "relaxed" in normal cases. Or we can
> add a Consume ordering (a type alias to Relaxed) that makes user to
> explicitly use it when they rely on the address dependency. I think
> either would resolve your concern about the name of "relaxed".

Yes, I suppose that would resolve my concern about the name.

Well, I do have one partial concern there, which is that the wrong name
will show up in stack traces as long as helpers are used.

> > I suppose you can argue that the word "relaxed" means different things
> > in LKMM than it does elsewhere, but I looked over the doc you mentioned,
> > and there the LKMM calls said operation READ_ONCE(). The word "relaxed"
> > does not appear even once. If we're going to change terminology / use
> > new terminology, let's at least pick terminology that's not
> > contradictory with the rest of the world.
> > 
> > > > 2) How do you intend to provide mutable access? By waiting a grace
> > > >    period?
> > > 
> > > Please see the {read_}copy_update() in the RCU patches that I linked.
> > > In short, you don't wait a grace for mutable access, since in RCU,
> > > readers don't block updaters, but instead updater will copy the object,
> > > atomically update the pointer and then get an `RcuOld`,
> > > which you can either synchronize_rcu() or {call,kfree}_rcu().
> > 
> > Hm, ok. I don't really need that. What I want rcu for is the internal
> > maple tree data structure, so mtree_load() doesn't need to block on the
> > maple tree internal spinlock. The contents of the box would be protected
> > by a separate lock (probably via LockedBy).
> > 
> 
> You mean after `load_rcu()`, we could access mutably by a lock? You need
> to hold that lock and the rcu_read_lock() while mutably accessing the
> return of `load_rcu()`, right? That is basically using RCU as a proof
> for existence.

Yeah, that's right.

Alice

