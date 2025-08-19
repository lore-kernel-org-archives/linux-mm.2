Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26427CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 12:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC33D6B0124; Tue, 19 Aug 2025 08:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B176B0125; Tue, 19 Aug 2025 08:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7BD6B0126; Tue, 19 Aug 2025 08:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4F36B0124
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:45:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 464321A04C9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:45:44 +0000 (UTC)
X-FDA: 83793478608.12.BCE9996
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6972440011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:45:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="R7gQ/qs9";
	spf=pass (imf12.hostedemail.com: domain of 39HGkaAkKCLUVgdXZmtcgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=39HGkaAkKCLUVgdXZmtcgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755607542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skXDTS7YtkP3PtgVwdRJaBi3aX6SDOh3FcH34RHXW94=;
	b=40kyaZ7CXiYruAq+iHcALJuVrTnpVJNyZyYGxFkNT3bVhvxLvfZNFu8tWqbNKRUFjKyuRL
	1fVL9KKMIMF9SsXPWpO11/hfsb3UlRe9wp+glwt1LjhrDckEA3B+R7lXuP21IuNzOuISOU
	QsR/K/Zvcvuzsj7uR4iZYoCxWVAQyMc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="R7gQ/qs9";
	spf=pass (imf12.hostedemail.com: domain of 39HGkaAkKCLUVgdXZmtcgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=39HGkaAkKCLUVgdXZmtcgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755607542; a=rsa-sha256;
	cv=none;
	b=L5uZgcyscPOblKzpHkSE1LUykqE+2R2PH97ZRuIdCay0tQ76EE5kWE8Dqj2GyjW8KD/9Bk
	6eS3hHpbs6xbyLjp62jbp6G+PUO5oBdnzX9rvMmaxs57Wm5jfxlgsjr/R00m6ARDHAU/uI
	XNgamLojxSU3nDIKaaugRBneKnBUoCA=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b05d8d0so32523735e9.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755607541; x=1756212341; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=skXDTS7YtkP3PtgVwdRJaBi3aX6SDOh3FcH34RHXW94=;
        b=R7gQ/qs9zH9Z5yCCJCgUMDVaA0ESoAsG+S3N2WN2QswoYG9E8I7MlGQVbIidBez/dC
         hqomlEU+wxyv8ZSj/BjHQhP7mgilj3QMaghkl2LTx/U3RIPmNRj9w4IBHWa4Wflp8x+b
         hfYpkQn+HRrctqzCxCqis+LLhrKXdE2hfCjiS1rnRLY6KxS1wh9cmPbP6nCl+SrVSwof
         Y5IahLa/9V/2PXo+Tq4jxoCrvgP1LAH8KQ7uqaK6jInu654y7o3Ut6rARAEQGNhawsiD
         r0sDRTkVg8nCaIDpP0bQ8YKVxKX2L1abiarVF9+7xZQYLXbx3i6jAyTDMmhKrZ9DxRoO
         TUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755607541; x=1756212341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=skXDTS7YtkP3PtgVwdRJaBi3aX6SDOh3FcH34RHXW94=;
        b=SrbKrp/ZhH2uApIdc8LnFji3fnv9VcokH/H4j7wRfC23tkT72Fi7oEE4Qfrf2Aj0Lx
         N3+Thkuubl+IDZl5whGYN0nIQbOiKZ9HF+jtEfi+id8KXueIfV9BtEdfTEIODrngHWYo
         B+OYgQKPFBFE4eGLufqKAOQOONjVbUYVNxEsPyTwAp4V3KSjhtiw/qxHNbK9OlfuGC0D
         JBEa4oTX6E39nzAaBTTEh/L9FvwnttP+rye/2T4l9vyovOtRhfy+silrJWP174L7X/kq
         rIg7Nd0JI6XoF/GqugkJd9x1RbROhQerS8RVS2lDcTq30vLSY0W4sfju3KwQhJ1sfwTg
         cxdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSM5QtjhmliAvutpfIidmWTL8t6V460SbuMM3czY+fJHA/0J5XH+d7K+gUknLWoJdSQgo1n+KyDw==@kvack.org
X-Gm-Message-State: AOJu0YysG1BTb3P7IZKLK2G4vrmt7WwnKJvK4+J69V3Z+PJ9KjszZXvh
	SLTpP/IrvxvLa5C+hJUVfHhVJ3ZApnVAbrvPcMh5rTdU6WH+jJSdI9AIEWZ+mYze0ZqafSqBogi
	fx97nK6lXAq17OD1wYQ==
X-Google-Smtp-Source: AGHT+IGIDBx+bC32aprn8tj9w03RjuRfJ6vo2Z3jPtuwKYnkQLN4JvNoi90LWbeGxOCwVfKIUq28TPReZBsoQd0=
X-Received: from wrob15.prod.google.com ([2002:adf:ee8f:0:b0:3b7:838b:2a7d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:18a8:b0:3b9:55a:9d0c with SMTP id ffacd0b85a97d-3c0e00a1623mr1805506f8f.3.1755607540947;
 Tue, 19 Aug 2025 05:45:40 -0700 (PDT)
Date: Tue, 19 Aug 2025 12:45:39 +0000
In-Reply-To: <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com> <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org>
Message-ID: <aKRx8xsY8CpzbeEm@google.com>
Subject: Re: [PATCH v2 2/5] rust: maple_tree: add MapleTree
From: Alice Ryhl <aliceryhl@google.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: n8mttm4d7h39sp7mjna8jjznro7x4e7b
X-Rspam-User: 
X-Rspamd-Queue-Id: 6972440011
X-Rspamd-Server: rspam05
X-HE-Tag: 1755607542-988479
X-HE-Meta: U2FsdGVkX19P1OAtCxYtmzBLooNn7vHzXqjvWPxKdh/pWJpqt57uFF1JHB5gYzytq4Q2dyd8+thymow4QvrpKYJKITdUisD/q1AwmDwbSBwqYCytMLwst1seak/vc5+m5lm6BbanOs/D37rHPl8FJABV91W5e3KwxFJ9nBkFJMx8WMsgfYthwguzqefp26fSwsmFP5XWRbnx/mgJTt4JhLaPhVzVWDoOQ2/LbaqyjNJw9/koRxB72gxsynR6MOvEL1bwHMGkMYZ/sGULeV0uoPgt7IQQd3XTET3AOCA9mDZ7MS8rHq1HPC2sYSOmuQ6R6a/YyXE6fg0WyylbLTXtDnoOCpAfKBOgiXYOUOEMi2QcUAcid4QuTvHAMCDTeQ1m9m06Gwi2acRLrm9mUS9CsU6nttRldKLcZHj9UYJwQCZkwnWTd3kjdlwybv5QWc+TnBlHmgmh6RYNMf4RXDsrgfyE138K1wuO23O66FwQkolXCNg1OCS5ATM5EwZZ+7HcTF/Mz2d/y4P49ENuzxH44YMBNT8zO1isCag4hXWaeAZpSgnq54QnBAY3YVwYqFtcg6sw/hC4go32pZqweBQSexjoU1J1UsaKdE/a0CA74SAo/MTi0G8TwL69hPmGNq77g1AWDt7042/4Z67BH8PKLAZI47GYxVGiWScLZ623bLPHflnPJ73u9QKSyRj3bGAlsPusclALZgBj5KbNIpKF1b6g7C7AryGYav76OfoXaUzhOxiwOyknyrc+A/o7z93ztddfhAGp8ux2GEQIJT/nQ/WvN0mWOb/l7TGzmgcL2uychPpkQ0AOQMAOAjJU68EtSnEQBid9SzYLM67K5OIlEUCj8poIlZ5aKLgVT52FtmH4EjlXRHUiLkbcxxRzVAkdWSU0hnNqJMmUh82G7pVSblKqWTpYH5L+tcdg7j642Xm+vcmcF8J1cK3eeGDuV9dKEtP8T8ZvlWInwCCmzx3
 505YJCqO
 WjuVIRaIh7zUnfvZtzDrBr8FjySvdApNR9Q6ZnTmL+1OiZd46JafeBXMsTYj+C7x27k7GH7L75+t0nsRyyZBcfRt81K5XIwB+sgnWGmKJUVLXHBX6/LEhWqZuxwwqQl4HDp08HYVxTJHtU9GDieguc+5bb8/S3imq587pcphN19J2zvL7a4q3w8l8TT2HGVvGlq61Kj9juaGeUrWvpHHhrQ297Yplf20uAkufePtcEWaJmHmOJYBKuHC7vd4j0oUWkx4ClJ8/+isKN6ZQDjp6BzzG4oWSxAE0cf4AaisLWUqx2KofHdOVrGSmc/aP1hGg6UiqCLnRC7uTq1f3fm9Sm/qbnqyotaL1GRcSEBaUUG2I+dLUtjvpxNuz7mGuPcw5N55lSm2j65iMLWjMn12bTL6qa4FsvWJXZW6mcKO9fIYupWVEJDOF11G6SpflDiQcJAwlpWUpacWhmYppYSaD6qhIXLYycFyM6huWivM7zIX+K9oWOXw7DO0VM6Bj/bhyGQJ8rGtjA42kuwt9xyPmfZSeiGGN4VXDqrDWI1bfDNX86azhwlEgJBfiCuJs3+1b1HrglRQwqbRpCE9CugUrxemZ73g9f/mtngYGA/CBSCgWJMVaLD98aGV7U44SximX1MEF0xhwdjTCxz94KlgraE2xeTi2pPHOT4DcijvL7oun36VH2LxdO96zEGED7xpIehsejzzOak9V1RxFfvL7zx6mrQ0j89Flpxs6sh5JVHZKz2fhIeFWyplEAL2mqTt7aLwVGXuB5qWSostwV9DB59blovrAMG6LxVjfbMUyzmB97Z+CofLgyplJyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 01:30:30PM +0200, Danilo Krummrich wrote:
> On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index fe168477caa45799dfe07de2f54de6d6a1ce0615..26053163fe5aed2fc4b4e39d47062c93b873ac13 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16250,7 +16250,9 @@ L:	rust-for-linux@vger.kernel.org
> >  S:	Maintained
> >  W:	http://www.linux-mm.org
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > +F:	rust/helpers/maple_tree.c
> >  F:	rust/helpers/mm.c
> > +F:	rust/kernel/maple_tree.rs
> >  F:	rust/kernel/mm.rs
> >  F:	rust/kernel/mm/
> 
> A later patch adds a separate entry; is this intended?

Ah, no, this isn't intended.

> > +impl<T: ForeignOwnable> MapleTree<T> {
> > +    /// Create a new maple tree.
> > +    ///
> > +    /// The tree will use the regular implementation with a higher branching factor.
> 
> What do you mean with "regular implementation" and what is "a higher branching
> factor" in this context?
> 
> Do you mean that the maple tree has a higher branching factor than a regular RB
> tree, or something else?

This is compared to the alloc variant of the maple tree from the last
patch in this series.

> > +    #[inline]
> > +    pub fn new() -> impl PinInit<Self> {
> > +        pin_init!(MapleTree {
> > +            // SAFETY: This initializes a maple tree into a pinned slot. The maple tree will be
> > +            // destroyed in Drop before the memory location becomes invalid.
> > +            tree <- Opaque::ffi_init(|slot| unsafe { bindings::mt_init_flags(slot, 0) }),
> > +            _p: PhantomData,
> > +        })
> > +    }
> > +
> > +    /// Insert the value at the given index.
> > +    ///
> > +    /// If the maple tree already contains a range using the given index, then this call will fail.
> 
> Maybe add an error section for this?
> 
> > +    ///
> > +    /// # Examples
> > +    ///
> > +    /// ```
> > +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> > +    ///
> > +    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
> > +    ///
> > +    /// let ten = KBox::new(10, GFP_KERNEL)?;
> > +    /// let twenty = KBox::new(20, GFP_KERNEL)?;
> > +    /// let the_answer = KBox::new(42, GFP_KERNEL)?;
> > +    ///
> > +    /// // These calls will succeed.
> > +    /// tree.insert(100, ten, GFP_KERNEL)?;
> > +    /// tree.insert(101, twenty, GFP_KERNEL)?;
> > +    ///
> > +    /// // This will fail because the index is already in use.
> > +    /// assert_eq!(
> > +    ///     tree.insert(100, the_answer, GFP_KERNEL).unwrap_err().cause,
> 
> A lot of the examples, including the ones in subsequent patches contain variants
> of unwrap().
> 
> I think we should avoid this and instead handle errors gracefully -- even if it
> bloats the examples a bit.
> 
> My concern is that it otherwise creates the impression that using unwrap() is a
> reasonable thing to do.
> 
> Especially for people new to the kernel or Rust (or both) it might not be
> obvious that unwrap() is equivalent to
> 
> 	if (!ret)
> 		do_something();
> 	else
> 		panic();
> 
> or the fact that this is something we should only do as absolute last resort.

How would you write it? The way you write it in normal code is an
if/else where you handle both cases, but that doesn't map nicely.

Alice

