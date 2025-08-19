Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E484CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75808E0001; Tue, 19 Aug 2025 07:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25B48E002D; Tue, 19 Aug 2025 07:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14D78E0001; Tue, 19 Aug 2025 07:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBC6B6B00AA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:30:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61BF911835C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:30:38 +0000 (UTC)
X-FDA: 83793289356.21.EABE47B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 29ACC1C000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:30:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RexACkbX;
	spf=pass (imf21.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755603036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6B0VsfGtsf5mgI9cSxJU39nn0HxYpFSQTf8cjY9o6A=;
	b=OOAsXpc8r7IsiSl/iAdyEhDvFp63rPYKA8L+E+QX0Aeyxod1Iz8h0KtCG5tnYfih1yopyp
	NQcS4pf5yyMT+vzFSwB0HoIPpjV8ys88jZhx6VbX0rcnqwm05D4+bsa2Nzbk3CpJA0aNLk
	2zg3sjW47L5bZHhD6OaFjcF1TnLjMYk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RexACkbX;
	spf=pass (imf21.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755603036; a=rsa-sha256;
	cv=none;
	b=j1bhsmkDwDoQPQ04n02kqrtZK6LvaAZ0l/NmrDXdSKnsrnYqIiETO5ijnBqi3XzV8bH7Dh
	ocsw034gwPxtS8YRXOmY0fZg2G6OjNCWoR2xhHwMELwJZzxdK0XMtp6dYUGUTWboh2Mrrw
	CTmpi0m4s1k8DYY+6gZNbXeMa9fs8N4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0709943EDF;
	Tue, 19 Aug 2025 11:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1849EC116B1;
	Tue, 19 Aug 2025 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755603034;
	bh=Vn9psqnVgnpwY9G5jdAtFOUJ6BM/owHxclMeS/ox6iU=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=RexACkbXj17mOzIVGarK7hH2S2AeLR8/EL9ZbUF7VOTPAnzRfskLPgaYG1ZDPRZj1
	 dMqI77G7fNGJsCWgXceF0i4H7gha7lZoSOVPcZZ89fZ93zVxrQrIe1qiLyY30J2AhJ
	 wa/CwTXp7re/GKien7Sc8aiLHAnOx23j4FM3eSzOjDsmLo0m+/IOpFCpQndeyUZreP
	 7MLWia0+he8a++29rVHH1UkMXIlY2gzv5IN9wSMxot9OXqIXdPvuE4X50tMrfwf+Pc
	 UF6kZ9f7aRmQ0ZKwRNkw1GAgVAR/3KMxSrWS1bb9WhC8EpqnF2RzC5EVXTi10ZH3fk
	 k4lM623rrHzCg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 13:30:30 +0200
Message-Id: <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org>
Subject: Re: [PATCH v2 2/5] rust: maple_tree: add MapleTree
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Andrew Ballance"
 <andrewjballance@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 <linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com>
In-Reply-To: <20250819-maple-tree-v2-2-229b48657bab@google.com>
X-Rspamd-Queue-Id: 29ACC1C000D
X-Rspam-User: 
X-Stat-Signature: x9bqqb6j4nmubhj3dhuwzagcuekcbpz9
X-Rspamd-Server: rspam09
X-HE-Tag: 1755603035-861840
X-HE-Meta: U2FsdGVkX19nizdpUuTHSRdBhAYQmlci2cs2elDvSrSEgFei+F2f4ZqfcYtFQqq+ea2/yN2vV68++W1SU5LMfU70lmX1DYzowGvUrk56pHLZC+9IkzzPDqa+SlkVoMapUV+PMPdOuUVPJ4C+WZjBcpVDzxYxGMUwDYxLiqCkbG9hIy+ZFc++XWnWTGL0hToEWv4GlFFpZwUM+bXwgI/isNvkUCYA0my1NGvlrDj6WKix8H0lM9EhCg0Iw0igGI6+Q02GNhA7cS2izzHMS4Ky4Jm4M0dmec6CGSgEmOl+jpi3tCvVc13oW31ar1I7218cPZhX44cv1A+7tnDsAmBpeNotBRicHsK7DMLon2qlvdOtQkvJlc3K84QZmhZ+NbpK54Xe4k8PKMmEZeJWtU1mUCK5mBSv27oZYJibcaKaNfPdWEPQ5O72Zy5SzOlbl+Q43b5kQaPw2ZJL9hTBxbhFpGqAlQWSGs/5i8FYKJQydk79PoDkgIiOAUHvyStM5J3j8vVD1JJKb+3R3LZAmH0rsqunRIaR+YMSJS1FOt8K1XaIVzwXNdhudHSNfkwaf/qo4p4+cMP+PpR/gVAaBUwk5OwK6RNK+fnndKwTzK1/pg3WmYdpPlqmPzaihUgONE+EJUyst6gqpgPumdunpXUVFwKnTSy9wypLWAccZC0IGRpiZmZI45rtfBGVuojvi0wj6eBpv5s1KtMc4+lZgO+LZIy6qfDGyvWU/39viMoS+gVuXbG6LJuG5HQ4UhG2yhOX7/zL0J4rxSoI5a4myM5zEDRpsUOkGMsn5RaRPtKeQBOlHdGWOBjdVPJNFFLU1HbjN/3swi+SEW9H/J+lmw7Oqdj2IPL3PAgO3W2qoZO+fAJXFhGMfd6ZcwF0Nfg13wrO8DX4kyq6+ZGjvoN0KT7djnIE1gPmIXr110idEMUzc9mXJGIpacRnfU3UDwPYLoi+VUtFolT2IghTMqBsS/x
 5GDjzC8Z
 JiS+CDXB/Bjx9SpgE5T1NbAMkzkza8NQq507o5jsXhriBdJmGocnKZYDLsmydp1MvIpwT9xHHlVeiP7J/+M4tKWbDfTJy5wvpsyZvtdfjPBeomsfuybqIrb7D02VxZ0f3/SdRoZRr4iDLBsL37KeF4xv4yhpJ693NdxFWrVeigZH0IYBI7gOdy0bmYy8s27NXa9rQEtyPerOmOMIp+jSJtbxxEGKJEiPaUuxEfmhln2Wfp3uS5o+yDYNM8PpbyoP0Y29IgOb2G5BCY3cryN7H+XEuUvVUB1jnmUHnJ7R5Y6fHOuEp3qV2Kn0DVzZ2SXidDL8ZeGH0nsOw3HmqDo1I0F9Qz2Wgwz07TzRYRBMIqNSXY+dQ4HnxUMGtDlKLRIjYciVoUUrUIm9OzPWDNAcXoeTh7gV0qb4rQRJsLPi4cEfNtHSpgJTObS+L6TrH4f5luPtrQ9mSCm69x1a3ZeYi28M96FDIdhshhoGU5dXFIo3+eq1TBX2uikTriSTG/X0x3saK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fe168477caa45799dfe07de2f54de6d6a1ce0615..26053163fe5aed2fc4b4e39d4=
7062c93b873ac13 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16250,7 +16250,9 @@ L:	rust-for-linux@vger.kernel.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	rust/helpers/maple_tree.c
>  F:	rust/helpers/mm.c
> +F:	rust/kernel/maple_tree.rs
>  F:	rust/kernel/mm.rs
>  F:	rust/kernel/mm/

A later patch adds a separate entry; is this intended?

> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> new file mode 100644
> index 0000000000000000000000000000000000000000..ea1bd694213b73108732aecc3=
6da95342aeafe04
> --- /dev/null
> +++ b/rust/kernel/maple_tree.rs
> @@ -0,0 +1,343 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Maple trees.
> +//!
> +//! C header: [`include/linux/maple_tree.h`](srctree/include/linux/maple=
_tree.h)
> +//!
> +//! Reference: <https://docs.kernel.org/core-api/maple_tree.html>
> +
> +use core::{
> +    marker::PhantomData,
> +    ops::{Bound, RangeBounds},
> +    ptr,
> +};
> +
> +use kernel::{
> +    alloc::Flags,
> +    error::code::{EEXIST, ENOMEM},

I think they're covered by prelude already.

> +    error::to_result,
> +    prelude::*,
> +    types::{ForeignOwnable, Opaque},
> +};
> +
> +/// A maple tree optimized for storing non-overlapping ranges.
> +///
> +/// # Invariants
> +///
> +/// Each range in the maple tree owns an instance of `T`.
> +#[pin_data(PinnedDrop)]
> +#[repr(transparent)]
> +pub struct MapleTree<T: ForeignOwnable> {
> +    #[pin]
> +    tree: Opaque<bindings::maple_tree>,
> +    _p: PhantomData<T>,
> +}
> +
> +/// A helper type used for navigating a [`MapleTree`].
> +///
> +/// # Invariants
> +///
> +/// For the duration of `'tree`:
> +///
> +/// * The `ma_state` must reference a valid `MapleTree<T>`.

I'd say ""`ma_state` references a valid `MapleTree<T>`", other wise it soun=
ds
like a requirement.

> +/// * The `ma_state` has read/write access to the tree.
> +pub struct MaState<'tree, T: ForeignOwnable> {
> +    state: bindings::ma_state,
> +    _phantom: PhantomData<&'tree mut MapleTree<T>>,
> +}
> +
> +#[inline]
> +fn to_maple_range(range: impl RangeBounds<usize>) -> Option<(usize, usiz=
e)> {
> +    let first =3D match range.start_bound() {
> +        Bound::Included(start) =3D> *start,
> +        Bound::Excluded(start) =3D> start.checked_add(1)?,
> +        Bound::Unbounded =3D> 0,
> +    };
> +
> +    let last =3D match range.end_bound() {
> +        Bound::Included(end) =3D> *end,
> +        Bound::Excluded(end) =3D> end.checked_sub(1)?,
> +        Bound::Unbounded =3D> usize::MAX,
> +    };
> +
> +    if last < first {
> +        return None;
> +    }
> +
> +    Some((first, last))
> +}
> +
> +impl<T: ForeignOwnable> MapleTree<T> {
> +    /// Create a new maple tree.
> +    ///
> +    /// The tree will use the regular implementation with a higher branc=
hing factor.

What do you mean with "regular implementation" and what is "a higher branch=
ing
factor" in this context?

Do you mean that the maple tree has a higher branching factor than a regula=
r RB
tree, or something else?

> +    #[inline]
> +    pub fn new() -> impl PinInit<Self> {
> +        pin_init!(MapleTree {
> +            // SAFETY: This initializes a maple tree into a pinned slot.=
 The maple tree will be
> +            // destroyed in Drop before the memory location becomes inva=
lid.
> +            tree <- Opaque::ffi_init(|slot| unsafe { bindings::mt_init_f=
lags(slot, 0) }),
> +            _p: PhantomData,
> +        })
> +    }
> +
> +    /// Insert the value at the given index.
> +    ///
> +    /// If the maple tree already contains a range using the given index=
, then this call will fail.

Maybe add an error section for this?

> +    ///
> +    /// # Examples
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> +    ///
> +    /// let tree =3D KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_K=
ERNEL)?;
> +    ///
> +    /// let ten =3D KBox::new(10, GFP_KERNEL)?;
> +    /// let twenty =3D KBox::new(20, GFP_KERNEL)?;
> +    /// let the_answer =3D KBox::new(42, GFP_KERNEL)?;
> +    ///
> +    /// // These calls will succeed.
> +    /// tree.insert(100, ten, GFP_KERNEL)?;
> +    /// tree.insert(101, twenty, GFP_KERNEL)?;
> +    ///
> +    /// // This will fail because the index is already in use.
> +    /// assert_eq!(
> +    ///     tree.insert(100, the_answer, GFP_KERNEL).unwrap_err().cause,

A lot of the examples, including the ones in subsequent patches contain var=
iants
of unwrap().

I think we should avoid this and instead handle errors gracefully -- even i=
f it
bloats the examples a bit.

My concern is that it otherwise creates the impression that using unwrap() =
is a
reasonable thing to do.

Especially for people new to the kernel or Rust (or both) it might not be
obvious that unwrap() is equivalent to

	if (!ret)
		do_something();
	else
		panic();

or the fact that this is something we should only do as absolute last resor=
t.

> +    ///     InsertErrorKind::Occupied,
> +    /// );
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    #[inline]
> +    pub fn insert(&self, index: usize, value: T, gfp: Flags) -> Result<(=
), InsertError<T>> {
> +        self.insert_range(index..=3Dindex, value, gfp)
> +    }
> +
> +    /// Insert a value to the specified range, failing on overlap.
> +    ///
> +    /// This accepts the usual types of Rust ranges using the `..` and `=
..=3D` syntax for exclusive
> +    /// and inclusive ranges respectively. The range must not be empty, =
and must not overlap with
> +    /// any existing range.

Same as above to the "failing on overlap" part.

> +    /// # Examples
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> +    ///
> +    /// let tree =3D KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_K=
ERNEL)?;
> +    ///
> +    /// let ten =3D KBox::new(10, GFP_KERNEL)?;
> +    /// let twenty =3D KBox::new(20, GFP_KERNEL)?;
> +    /// let the_answer =3D KBox::new(42, GFP_KERNEL)?;
> +    /// let hundred =3D KBox::new(100, GFP_KERNEL)?;
> +    ///
> +    /// // Insert the value 10 at the indices 100 to 499.
> +    /// tree.insert_range(100..500, ten, GFP_KERNEL)?;
> +    ///
> +    /// // Insert the value 20 at the indices 500 to 1000.
> +    /// tree.insert_range(500..=3D1000, twenty, GFP_KERNEL)?;
> +    ///
> +    /// // This will fail due to overlap with the previous range on inde=
x 1000.
> +    /// assert_eq!(
> +    ///     tree.insert_range(1000..1200, the_answer, GFP_KERNEL).unwrap=
_err().cause,
> +    ///     InsertErrorKind::Occupied,
> +    /// );
> +    ///
> +    /// // When using .. to specify the range, you must be careful to en=
sure that the range is
> +    /// // non-empty.
> +    /// assert_eq!(
> +    ///     tree.insert_range(72..72, hundred, GFP_KERNEL).unwrap_err().=
cause,
> +    ///     InsertErrorKind::InvalidRequest,
> +    /// );
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    pub fn insert_range<R>(&self, range: R, value: T, gfp: Flags) -> Res=
ult<(), InsertError<T>>

