Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5322C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4488E0055; Mon, 11 Aug 2025 09:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBCF8E0045; Mon, 11 Aug 2025 09:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3028E0055; Mon, 11 Aug 2025 09:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF008E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:29:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DFE01A01C8
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:29:51 +0000 (UTC)
X-FDA: 83764559382.08.51C260E
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71425100004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:29:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHYQdHSS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754918989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXaMgSAfuwCmsibEmyzvltlY8Ba5+srgQBCYULlh1v8=;
	b=lnZ3vweoPiVL7gN8pT6N7T3gN+1RMYFpKLH91PyisvE9JWNloT+TE8D7BsX/1Cz4cT6ReK
	pYWZgFcDMxmzg3nrqOb7PxmLfCOLpSHf66cLjs1Zs3yJoKUNaiMK5LkZrjnzKqNsqBRkMc
	2COI8/4zkrxRfD+MHdOGsC1cdwRvmyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754918989; a=rsa-sha256;
	cv=none;
	b=kr6jZ9FJyFkJdElYNNJ9T0z7ZA4XE43tluiB0XVol94htTi5M7lMJ88tq1GeDfuDAUPNdo
	WQWQq2pwowETfAdHfTsms4Zyp9BuIDrmiCYlUCJrS1Sru+0yNeD2t48Opy4XWZwXQqCuPw
	OQG6sCc8VxXOnd1OA6UYEaFi0sEpSwY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHYQdHSS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 9C064A56E90;
	Mon, 11 Aug 2025 13:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E83C4CEF7;
	Mon, 11 Aug 2025 13:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754918988;
	bh=TgjO8kHAVKI3l7CYVMLzptQqzc2/jaFVmi388jyGESY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nHYQdHSSsQwSWCD3WrYy07OaO4m86uNO8iyi3aw6PA55zHLFltaTHVJUygKn6D2GA
	 Y+UmhsiLOJ3RptaWumnpZZT3EVrIi746eRRBdDKeY1WVcqoZsuatOyykNiQxQFNbGj
	 5nHPIR4LS3w7UJvKIMLUD8vkAXFafB8oYjzL/KUiL8zEt7xrg+Rn6jh0utGwwReCvZ
	 nPF5SQ7W2+epSEgJ26xHgkiO3gPZTnBluEWwiv5/YQfkNMv0tpyfPmv0Ra35lLUyK5
	 kv7xn3kkbcotz4S40rFwfiuHybfIoFUDaUYQL6m9MEoAiZm8Dk2UOzQeN1lk/wk6ap
	 yNI4p5nOvyF4Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Daniel Almeida
 <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@gmail.com>, Janne
 Grunau <j@jannau.net>
Subject: Re: [PATCH v2 3/3] rust: xarray: add `insert` and `reserve`
In-Reply-To: <20250713-xarray-insert-reserve-v2-3-b939645808a2@gmail.com>
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <iPv7ly-33WYOq_9Fait3DBD6dQCAn1WCRGwXjlPgNBmuj5yejzu0D6-qfg3VYyJfwu9uS4rJOu9o3L2ebudROw==@protonmail.internalid>
 <20250713-xarray-insert-reserve-v2-3-b939645808a2@gmail.com>
Date: Mon, 11 Aug 2025 15:28:11 +0200
Message-ID: <87o6smf0no.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 71425100004
X-Stat-Signature: 48h7uje79ioh78ecaez7y46kocebpous
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754918989-828594
X-HE-Meta: U2FsdGVkX18nsz5zNG0xhY4Y4vcoPoUKpIm/DoQAcYlJsy3UtmC7nVMaJOT3iojwP6YRsJ9bCX43dFy1xb79r6Wl7/C2maAFUWOIn8zfOF794RDLqnY5xgv7yHZJTKq3hpkAans2rxrQIx7HQ4e+9DzL5ILRVa80/EYHhw7iApy0m9uB2T0nCmEcqefSUzBJwhK4rqcQ+KMusK6wmD7iNIFURAVTTi0/vOKf7EyGD7g5e2GFahU5+i8W18EfcT5GFUw4mBybpmCTCGnnDHsNHgvllsNF05rl/RNr8fUz/SaE8NX6dIa808XwEb94Nvd0sKxAYTo/kHZwBF0/9LNSdovRr/gapCkwdthmZul/EwS5Estrn9Nf/Z0z/RSvyorfyiebXY9vy0oT8sMdF+4XKUnnHvLZRxuxqm0HfX7hxGkLtwuNAbTulASEAiKqaydyS9pW1KeKtQSLq3tCqBZkDXvrp+0vaabShbRkvLS+vMx4j/GREudWD93hOztITr7JC8sNf2+V/qUA+QnmRZZ2u8Wh6wXGgK9MS1TDJJgmZ1yQjwq/4tSOjZzqoxGv6nuQ1mGqNXd7XzF9Yc/BDqIdJedzDNuZqFwc+cIc5JhnUOyD8q+0XqPDJ0Z9Ad6JzPXv91qJQnHazbUuvCRXq5O4E3NKcf4yQMnyHsa6GayHjDGJnxWNaHTAUNLsYu6HII4PGmXaAm4Ap9IbFY+cJv91r6bvJsjikevR8TEYaP2f0ozTLzB75Ogoh20xA0xsm01QpLvi9KNqXetoN6gk/5nBJHSd3LU+I+b7FbV35uSigZyCXrEOhd7kobnTXM9JvgB9mMlzlay+eUVRUdtbwlsExoT/5vB0UcrXJRqfoNcKafBMIE3mkHSoQK6mHm8YOMgTQFdBIEvp0CQMojduskxrxca8aJ3ZsZjYUdsyDuCAej2eVQuGBRBymcbryLVfS6crW4M6s8RQTwybEI+Yiil
 z2hz1yDz
 Iq5cgXYdowbC/OOE4F/yzh/h3L4AyHMkMrkgXlbcD6GzDTTfdDoOmHqa6BxuPZu6FSTlzn1A++Sy0xJnxFNKKBjYkpadCS1cy5YZXjYoXj9HodBBXdUbr8rNMhst7pdI0+jKsY9CuSrDsFoQrd61hxiWMvQooScwb4U0VXnfzLNxcOec9iTZZhqQhgy8wagqzi6U3XpGBVSsBonnX2sTuutnDhE//ktPKgAgImM4Db2t3tjS2s8MWxiUVbQxpu6D4F7bFG5wxBMI+XTSRthBsJ5t7zQACB5Lb6+HW8iUqqqsQIAzZVUDprLqdsMvJXoAqhn4r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Tamir Duberstein" <tamird@gmail.com> writes:

> Add `Guard::{insert,reserve}` and `Guard::{insert,reserve}_limit`, which
> are akin to `__xa_{alloc,insert}` in C.
>
> Note that unlike `xa_reserve` which only ensures that memory is
> allocated, the semantics of `Reservation` are stricter and require
> precise management of the reservation. Indices which have been reserved
> can still be overwritten with `Guard::store`, which allows for C-like
> semantics if desired.
>
> `__xa_cmpxchg_raw` is exported to facilitate the semantics described
> above.
>
> Tested-by: Janne Grunau <j@jannau.net>
> Reviewed-by: Janne Grunau <j@jannau.net>
> Signed-off-by: Tamir Duberstein <tamird@gmail.com>

<cut>

> +    /// Stores an element somewhere in the given range of indices.
> +    ///
> +    /// On success, takes ownership of `ptr`.
> +    ///
> +    /// On failure, ownership returns to the caller.
> +    ///
> +    /// # Safety
> +    ///
> +    /// `ptr` must be `NULL` or have come from a previous call to `T::into_foreign`.
> +    unsafe fn alloc(


The naming of this method in C is confusing. Could we call it
insert_limit_raw on the Rust side?

Even though this is private, I think we should also document that the
effect of inserting NULL is to reserve the entry.

> +        &mut self,
> +        limit: impl ops::RangeBounds<u32>,
> +        ptr: *mut T::PointedTo,
> +        gfp: alloc::Flags,
> +    ) -> Result<usize> {
> +        // NB: `xa_limit::{max,min}` are inclusive.
> +        let limit = bindings::xa_limit {
> +            max: match limit.end_bound() {
> +                ops::Bound::Included(&end) => end,
> +                ops::Bound::Excluded(&end) => end - 1,
> +                ops::Bound::Unbounded => u32::MAX,
> +            },
> +            min: match limit.start_bound() {
> +                ops::Bound::Included(&start) => start,
> +                ops::Bound::Excluded(&start) => start + 1,
> +                ops::Bound::Unbounded => 0,
> +            },
> +        };
> +
> +        let mut index = u32::MAX;
> +
> +        // SAFETY:
> +        // - `self.xa` is always valid by the type invariant.
> +        // - `self.xa` was initialized with `XA_FLAGS_ALLOC` or `XA_FLAGS_ALLOC1`.
> +        //
> +        // INVARIANT: `ptr` is either `NULL` or came from `T::into_foreign`.
> +        match unsafe {
> +            bindings::__xa_alloc(
> +                self.xa.xa.get(),
> +                &mut index,
> +                ptr.cast(),
> +                limit,
> +                gfp.as_raw(),
> +            )
> +        } {
> +            0 => Ok(to_usize(index)),
> +            errno => Err(Error::from_errno(errno)),
> +        }
> +    }
> +
> +    /// Allocates an entry somewhere in the array.

Should we rephrase this to match `alloc`?

  Stores an entry somewhere in the given range of indices.

<cut>

> +impl<T: ForeignOwnable> Reservation<'_, T> {
> +    /// Returns the index of the reservation.
> +    pub fn index(&self) -> usize {
> +        self.index
> +    }
> +
> +    /// Replaces the reserved entry with the given entry.
> +    ///
> +    /// # Safety
> +    ///
> +    /// `ptr` must be `NULL` or have come from a previous call to `T::into_foreign`.

We should document the effect of replacing with NULL.


Best regards,
Andreas Hindborg



