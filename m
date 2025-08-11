Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931E3C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF5F8E0058; Mon, 11 Aug 2025 09:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7458E0045; Mon, 11 Aug 2025 09:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD568E0058; Mon, 11 Aug 2025 09:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFA568E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:43:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83AEA1401FE
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:43:07 +0000 (UTC)
X-FDA: 83764592814.24.00B82EF
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9541F1C0005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:43:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lu9MisXG;
	spf=pass (imf21.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754919785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2uF7vPpkuTtX/qbaQwoJviWpFHx9vCm0V6L9tSQgUI=;
	b=2EqH0B19p4fJW2/WkR5ZdyeBFO9Ilc15DX5kiSVSKIPqxWgUNNRqUposjRb9srjB2M4TBh
	rVM1mUq2iySd+4o3L3mWqH92q9PmLB01M8xptp/vjv/HqzkvoHx/1GKbXz0FG8MUhEvKez
	yYXYZoBlJPzvsqXZtSNNSYlYvIt1Lh8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lu9MisXG;
	spf=pass (imf21.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754919785; a=rsa-sha256;
	cv=none;
	b=cXAlFFqYVV95fnMsiR4C2+Q0F/MYPY50I2/ymlBA0Sxg1ghR/C3UrbsD1BbIh00/dkrDno
	wImPVST3tBe9qy29j33SjV9XavxpMkTG+PuSAlM3UI8Mh5/0WseaoFqT5V8DEA4yEXbzwi
	vAOSEfFo+662ZnPVH4kWcs5NwDMFTgU=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3322e4ac195so33352161fa.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754919784; x=1755524584; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2uF7vPpkuTtX/qbaQwoJviWpFHx9vCm0V6L9tSQgUI=;
        b=lu9MisXG0hK8BQ8IxQusnpaYk+eyOedf5qHhye161c1VnOz5wBL/EhdTzD8Ury+F0w
         e31Q2ogeUQvyLWTrUAT+//iKIHqbLUJg8p5In4vADtBDtbK6IYiTMJFbE6ogZcl1DKkN
         Ai6/x8hSRyFMnvrQabtwJZQDMSo8tXYuia3U7aoCKOI68HM8U0D9qMM8RC5QoqshbvR2
         6ZQkSh5nJNtqKLyBJhmIUXO78mUYpyALlFJcFoxw2ynUTdO60K0yx1azTvwbYnTDiaQF
         uzQlMWqBzetGUt6hzs1Irb+ztx9h0Qf8FE5bWKUJPFLV6RhIWRqJYNgoQAfSdzQLjWSZ
         /zkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754919784; x=1755524584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2uF7vPpkuTtX/qbaQwoJviWpFHx9vCm0V6L9tSQgUI=;
        b=j9KYxfmxkuTsMnQd1Fh6CGXr7M0OAGyNl/KKvJSKVy8O5d4IVTOQFkr84UoHDrIWjw
         gXBnn2oMGBEdTFATa7a64Z8VjT4jWNIyLjXk8EHjF2qlu2QAiZkipIUx/qLi3sOnXm31
         GzK7iaipAffZHHltJF4hPglzppBzetx254htEwVlxiZcqavY5rwE1lmx85E4et0KnSnH
         K4ATgStfu2bh5Dr9kJwP+tceZOFktGNN0SVb1lLg5fKBokT/aNkVJc7MsZJC7i0Hbwlr
         aUU0ftR4Sf+G9yKMS+RO7Qy34pj+UM4l/yZW5GTy6L4RV4A1BhZCAp2MfYHRL13Ta8Xi
         /3+g==
X-Forwarded-Encrypted: i=1; AJvYcCX+CMfucPRP2LO0k/+VLF+qUQHgKaA6HABomZ77+3a+flGAIauvRoDrMtdcggAauzKS65RplN63aQ==@kvack.org
X-Gm-Message-State: AOJu0YwF9HY73U0v9TGZ+bEw9DKiQGs2RaMERxHGgAkeUzg5mmR3J1mH
	QbnZJWYeWk5UeZQOX9jFqSC98bvhFF/OS86kIgFI48ggB5rQZRfiXa1A7KUnNUyePAGJxTJrRC5
	XqYJ9l9TJzfr67mnHjOH9qtmGjzdoBNM=
X-Gm-Gg: ASbGncs6OL8I7gbc/Uxc/kvJaVnvicP14R6wIChISojHKcQejye5jbaO+OoD+rMI3gZ
	Vxd8FtadT0k4beJgZzCoExRuvP2jxeWfvPziLuStblPa5nTyQip2PnL3qCwv9Sl6FHuc3IHHhhe
	FiUqYMKL44Np/Rx//xQySSmE3v2HHkso1ZL5NHHt26oysL87Cjwdn0ocyu7lKRzXH/TMhJ4ow2f
	8lOyvoQeWwyHNAdnGc=
X-Google-Smtp-Source: AGHT+IEol4/14g1RdFTVWvKKfnfbHDYflaB3EmyktN+uy3kEuQJOPffANVEaEm6xSj3auWaeo5zGZxx39z1GzBXm49o=
X-Received: by 2002:a05:651c:222a:b0:331:ed39:6a2 with SMTP id
 38308e7fff4ca-333a2107c71mr28463591fa.6.1754919783604; Mon, 11 Aug 2025
 06:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <iPv7ly-33WYOq_9Fait3DBD6dQCAn1WCRGwXjlPgNBmuj5yejzu0D6-qfg3VYyJfwu9uS4rJOu9o3L2ebudROw==@protonmail.internalid>
 <20250713-xarray-insert-reserve-v2-3-b939645808a2@gmail.com> <87o6smf0no.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87o6smf0no.fsf@t14s.mail-host-address-is-not-set>
From: Tamir Duberstein <tamird@gmail.com>
Date: Mon, 11 Aug 2025 09:42:26 -0400
X-Gm-Features: Ac12FXwkTewa4VnDdAm-sjbFCbNz-t0XSzJ_IMvpOUXuMOMHXyVuYMlS2C03l70
Message-ID: <CAJ-ks9kTacXO_PbcH8c-60Ae88vJ_w6_pbmXLzOpzTKgRjiXPw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rust: xarray: add `insert` and `reserve`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, Janne Grunau <j@jannau.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1tbke7ddbfh6m4s875atcy1bz7fqkns8
X-Rspam-User: 
X-Rspamd-Queue-Id: 9541F1C0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1754919785-995773
X-HE-Meta: U2FsdGVkX1+ekC9396oj+y6LIgWLth/Bp27RnXS6M65c05VEP6Ty0qGxB5CXG4KNFSSG8eg8c1MHU6f63xrHro0QFgUZnBNVLrCvCLxukkh1fgGu3ePD9lq2rf3kr/awEl8QcDWbTMEBx0Zn9SfhnvB6k88hCSQmzfHiJ8DupIWjrSgOtQmoSfOdIZ7VRtj2/Q404kEfa7OuxPSII2svbKPmkaWHrhI9Ml9Hg1YlxpZx8S811HoTo/sIfP+nW3A6vI281XsIVGe04HfVZjfqC+DCluCmcQ+lJVX4mKEPJIqpbqmnpYII28zhqAZQ1Sojyhzod9c9x8jLuaHr3uKvk3hOdNJD9R4DNlxbHvZ5vSgoRahGEioXzqmK0mADslXh4HTMrw59JU/HoPV63K5vv7Lmj/WlgIqos/VRfXgsIsBVR8HNc4e36oGT6KOfbzGRt1h56a2pvwitkssejRO2e+6kHva+DDxevNGE4favNM2limTrxqJFej6Nn/aLZW7Dg2M9//WIJvgrW7V8BWoA2ysiDnwg7+E8HKnpzECFBV8/n/4jGYBNIBkC9RCz1CHEO6rDvKp6OuV275bL7XJNZCSbNo5PIq4MgTqtEs+gQ/WGuqSw4UinjMVK5YDwOxKHu3mlUFCjF77Hg+ePO7uK/qEZCLSqP8+hW7r9sWq+kcaiC0MkZoxMasNzYBem2ybd4ixlwOuGNAEChd1P3wcwZobV0Rs/Gv7YH1vdhkiu/lEfRVtrp109aHa9Dp55KN4I/g/ewdYZE0cjXDyCDAZ2sejN2/JPjUOz0ZhG6UYxsEHsTHdDE3oiw59rs5ztiwOG2Er0U3DNFiZ9V0j2aoNiFgAMqzbt+6PLuC8Ao5AU7hc6RwCdUcgoEps0o6AP9D6CRdcNbeTfxtttnSfumQQan2qcDpYv3UKymdZ58dIkT+w9xl4J5jSkJzqkIk4f2aacvwQfu6g6tSd+vUuawCb
 9GCpTCQ+
 RmYZsdAg5aEIR0ZPMjauHbgbdopF9rpYkjZltGTVRFxEo1pqnxZeC/BASybvmkwhHVksa+g1u+7Vp3eDFx9eB+n4A9psDZJdnZxhGUSTAd+Ga+H98JM91wtLzQ4se0tllLfxm+6fii3RE5QiyY/C5jRNQ+tbqTIb0Pq2K5Ltlx9qoe036pOKI7CVgPJrKFUda9ZzJTuT9SQYWcGD5fyqG084nhTMiVBj6Q1AydK6dmzS12AOAJ1gILEpWjCHVE4fuaVJ6Nu8DRnLNkOgIe/HIrjfi3ej7EONclnYZAJsjc1p63qqbHfeRJ//V3jPWTJJkIY1M80dGn1mCwTZ9h8ni0fGQv9duvtafyQsSbsqInOzIbiaOk8su+9CRvGXyKkily5nf7kuzu9S2u7GTnMUx3UmhayTIJckR9AB8VXqMqEB52YGfuL449rWH6nh7Z0KCg1bOWiXt7q36Nd34Bx+RCZ9nZFd46F/KHyTVTX0rQztOnyeufuHfGL9pVvN4uDTzNBZxvLLdnWmlolyzC+HMkghbQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 9:29=E2=80=AFAM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> "Tamir Duberstein" <tamird@gmail.com> writes:
>
> > Add `Guard::{insert,reserve}` and `Guard::{insert,reserve}_limit`, whic=
h
> > are akin to `__xa_{alloc,insert}` in C.
> >
> > Note that unlike `xa_reserve` which only ensures that memory is
> > allocated, the semantics of `Reservation` are stricter and require
> > precise management of the reservation. Indices which have been reserved
> > can still be overwritten with `Guard::store`, which allows for C-like
> > semantics if desired.
> >
> > `__xa_cmpxchg_raw` is exported to facilitate the semantics described
> > above.
> >
> > Tested-by: Janne Grunau <j@jannau.net>
> > Reviewed-by: Janne Grunau <j@jannau.net>
> > Signed-off-by: Tamir Duberstein <tamird@gmail.com>
>
> <cut>
>
> > +    /// Stores an element somewhere in the given range of indices.
> > +    ///
> > +    /// On success, takes ownership of `ptr`.
> > +    ///
> > +    /// On failure, ownership returns to the caller.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// `ptr` must be `NULL` or have come from a previous call to `T::=
into_foreign`.
> > +    unsafe fn alloc(
>
>
> The naming of this method in C is confusing. Could we call it
> insert_limit_raw on the Rust side?

I think I prefer to hew close to the C naming. Is there prior art
where Rust names deviate from C names?

> Even though this is private, I think we should also document that the
> effect of inserting NULL is to reserve the entry.

=F0=9F=91=8D

> > +        &mut self,
> > +        limit: impl ops::RangeBounds<u32>,
> > +        ptr: *mut T::PointedTo,
> > +        gfp: alloc::Flags,
> > +    ) -> Result<usize> {
> > +        // NB: `xa_limit::{max,min}` are inclusive.
> > +        let limit =3D bindings::xa_limit {
> > +            max: match limit.end_bound() {
> > +                ops::Bound::Included(&end) =3D> end,
> > +                ops::Bound::Excluded(&end) =3D> end - 1,
> > +                ops::Bound::Unbounded =3D> u32::MAX,
> > +            },
> > +            min: match limit.start_bound() {
> > +                ops::Bound::Included(&start) =3D> start,
> > +                ops::Bound::Excluded(&start) =3D> start + 1,
> > +                ops::Bound::Unbounded =3D> 0,
> > +            },
> > +        };
> > +
> > +        let mut index =3D u32::MAX;
> > +
> > +        // SAFETY:
> > +        // - `self.xa` is always valid by the type invariant.
> > +        // - `self.xa` was initialized with `XA_FLAGS_ALLOC` or `XA_FL=
AGS_ALLOC1`.
> > +        //
> > +        // INVARIANT: `ptr` is either `NULL` or came from `T::into_for=
eign`.
> > +        match unsafe {
> > +            bindings::__xa_alloc(
> > +                self.xa.xa.get(),
> > +                &mut index,
> > +                ptr.cast(),
> > +                limit,
> > +                gfp.as_raw(),
> > +            )
> > +        } {
> > +            0 =3D> Ok(to_usize(index)),
> > +            errno =3D> Err(Error::from_errno(errno)),
> > +        }
> > +    }
> > +
> > +    /// Allocates an entry somewhere in the array.
>
> Should we rephrase this to match `alloc`?
>
>   Stores an entry somewhere in the given range of indices.

=F0=9F=91=8D

> <cut>
>
> > +impl<T: ForeignOwnable> Reservation<'_, T> {
> > +    /// Returns the index of the reservation.
> > +    pub fn index(&self) -> usize {
> > +        self.index
> > +    }
> > +
> > +    /// Replaces the reserved entry with the given entry.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// `ptr` must be `NULL` or have come from a previous call to `T::=
into_foreign`.
>
> We should document the effect of replacing with NULL.

=F0=9F=91=8D

> Best regards,
> Andreas Hindborg
>
>

