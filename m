Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB87DEB270B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 19:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD6E6B0005; Tue, 10 Feb 2026 14:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AA26B0089; Tue, 10 Feb 2026 14:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CA36B008A; Tue, 10 Feb 2026 14:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 630306B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:54:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 950A513B970
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:54:08 +0000 (UTC)
X-FDA: 84429598176.30.6D9331D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3E3BC0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:54:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d1UTD7KT;
	spf=pass (imf22.hostedemail.com: domain of tamird@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770753247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gmme+HsT8PRM+pCnvV616AXhlG38S0SdWN48Sjzid+4=;
	b=AXMyIsCg/vsYbIilVxH8uYnHD7TfEKQwSPRTcTEK13ZaOhZ8NAy8QA8PNgaB1j4j+5cMb5
	p7Y7uofRoiExYZ8W/ez8WK1y/K4IJGkUJSOLXnEj7D+jaa46QY6/WPbRF9RngoFPBV3lYO
	37XLBHhnodmXGB+7nH9sqILyJhjz5gE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d1UTD7KT;
	spf=pass (imf22.hostedemail.com: domain of tamird@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770753247; a=rsa-sha256;
	cv=none;
	b=cTneXaXbYxWSJQzqVRfoBbCdAbwShgNBgpYDFwSmEFlhmpwcbGeFCZTtr/OEnu3App0DFr
	BaczhOKzeuO30xZDm9DGin4IMwoI3RMhouH0QhIdg0PnxyjoPT5JYKjga8vdYl7YybLErh
	kpifGnnj52bG3zrkA338r+DobxZkfkg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 721D744513
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDBBC19425
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770753245;
	bh=rfXEyqIrDHyrzS+eIZXLL/nqGWHyUSEscNUumSMxSv4=;
	h=References:In-Reply-To:From:Date:Subject:To:From;
	b=d1UTD7KTB4CkcLdRb64+SSf9kxATKD+moA8hAtETPuRNM+LRDypx53hMVjz6XuCL6
	 vDb1gGq8bJLvZzKt1LQQjVe8qQOBhq0yqwSUkEqLWR7TdIBtfngaUrUHLy3myRfWqD
	 rN5WwL3a121uvf9I7UOFHVUi03ni6Pky/oa1EDBjCMjpyxQFXpxRaEgqs37vCtqKeR
	 QshC40FRR5CudQrq+bhdH8uxMYXoC85mVcrCz3dFnwj9uCPVlCq0+QdQuCD3/NmVKd
	 lr9uQfyXo9XDWxGbCMkJQknHjGqytIndCi1cecNcOFcAGJ0gqqDcQqc8mUAxDd5Eo7
	 9sehp2Meyj1BQ==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-382f9211cbfso41150201fa.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:54:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUyWcai866wvQfcH9xOoiDoWdktzYjf2sBBOG4SZrimFJHc+kZihgWDeUoPrbbou7pxQZMY4gmnBw==@kvack.org
X-Gm-Message-State: AOJu0Yz1Wg4C6kso+TLmgiTvsftoNsTBCbPwgDYD1rVc4KI7fCo+MApt
	rwKYaCE8jyDDZ3RxV9fVPhUHOgQqE3arqEhdRojqxp86dQmgMy1MD+s6i8qrS5KbHSvm7VaAJAN
	XpA8ZxD6lC+unvbYVrmCeqcUqdYAWwAo=
X-Received: by 2002:a2e:bc10:0:b0:385:d78a:1f34 with SMTP id
 38308e7fff4ca-38703055079mr214791fa.17.1770753243639; Tue, 10 Feb 2026
 11:54:03 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org> <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
In-Reply-To: <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
From: Tamir Duberstein <tamird@kernel.org>
Date: Tue, 10 Feb 2026 14:53:27 -0500
X-Gmail-Original-Message-ID: <CAJ-ks9njGhT85pgUSahki989Y9vn3XOBNO5wxB8wE+KvbL00wA@mail.gmail.com>
X-Gm-Features: AZwV_Qhd-O5disfUdXHYeoc8tMIXKrEn06Ut5qaMpJq38pAn-iSAamGwNgY1AVU
Message-ID: <CAJ-ks9njGhT85pgUSahki989Y9vn3XOBNO5wxB8wE+KvbL00wA@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 9csza61ktyiy51fmoydo7xjy1w81er88
X-Rspamd-Queue-Id: C3E3BC0005
X-Rspam-User: 
X-HE-Tag: 1770753246-974206
X-HE-Meta: U2FsdGVkX19TmRTh+7w8ksIphN+3XAEot6VasvfN8CXybIuRP7cLtN+iyYTUxe9/IyF50FoylCxVciYs/WlCyQTYMCc1hrDc0uuG+W3bsh1m71cSr+ndHh/OGxwgYriBH2Ee13WHieigz3R1St/mRkURrMQfZCi2nY8zxwuQBB9wt4JO/mdEX3Novsx/z9PKNZaRbJgF+GO3TESAlAhy1hzpkUOZGN2OhSy6BAGlA4t5meG3s/21YkBhLBZ41BMW+VNoyG7OwhnyivZ2sOzvI6882IGIrW1RlLDq8BztQoBSL6ptGt4Nx3Gw0JlRkbRZh095x0OLmZxvr7aBcK4vDihESkMlxSQzJ0mI7GpJcwtDyUPIXGs/19ITRXZfDifD1cDAPrIo4LiMPhuJ5+KSIcSE1p5aRGUXvL7fZXb1nQnmFKIGsBFNiUC4MeFN7ZW2z75q8EQIXsReCt+WVqhLEYfa1trpRwoNt09FJdunsHosFFRMDSzTQOPrnXQbcR76iYyqYuplvZZePhaStsilSFcw3eHuZAYTUKxf7ORXbWvBoMHBkKX4a1q0GnX5doEkaMlMqycqkZ8GwllAlRG3qXWE1bOox8EJXubpTyVFleRIq9Yhq6O5G1KEJ+r9XfxTkVNxxpnPDXd4NKzSMIGMTn/O3xKOaw/5ByfDV2w8Sbfpk32/oBZQX0CXwlg0bqxE+F/o+nLt4+/PBrXKYPWFivAMy1T3FgWz1XVPpHiOSJj0qN6B3yznC4MvtXKA1Q5rncg8SrKg2fadCMeFvRWhHC5r++nQdC//xVKEFefnMJtQkAf2PeP4s+2Yhz0KrdUn/c1j2NijzT0ODXGah0E1O4SJQNysV7SXbHDsOYscmrH5yxrWCVlDaOTg/ZphuepbkqoOY1ry8xry4kDn09VziIIS6Rky11V5xLeuhevGA45hpST8bFyxvEx2qzkAkQuwkidNiP7Cry6p1WcQys8
 jiWL2IER
 tHdfjsqMQzxPUU/iYvh7acK6Mgn6Yufsxq9hRg+4HhHs8DK0bWEfJ5/+G3Hp8T5KZ5iXxPH19QHyUMqeGFToWbNqliKIlmOxvvuCGA6zub9GbRSg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 10:16=E2=80=AFAM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> * Andreas Hindborg <a.hindborg@kernel.org> [260209 14:39]:
> > Replace the call to `xa_load` with `xas_load` in `Guard::load`. The
> > `xa_load` function takes the RCU lock internally, which we do not need,
> > since the `Guard` already holds an exclusive lock on the `XArray`. The
> > `xas_load` function operates on `xa_state` and assumes the required loc=
ks
> > are already held.
> >
> > This change also removes the `#[expect(dead_code)]` annotation from
> > `XArrayState` and its constructor, as they are now in use.
>
> I don't understand the locking here.
>
> You are saying that, since you hold the xarray write lock, you won't be
> taking the rcu read lock, but then you change the api of load?  That
> seems wrong to me.

This patch doesn't change the API of load. Andreas is saying that the
type system already requires the caller to hold the xarray spin lock
when load is called, meaning acquiring the RCU lock isn't necessary.

>
> Any readers of the api that calls load will now need to hold the rcu
> read lock externally.  If you're doing this, then you should indicate
> that is necessary in the function name, like the C side does.  Otherwise
> you are limiting the users to the advanced API, aren't you?

The existing API already requires users to hold the xarray lock.

>
> Or are you saying that xarray can only be used if you hold the exclusive
> lock, which is now a read and write lock?

Yes - except for the word "now"; I'm not sure what you mean by it.

>
> >
> > Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Acked-by: Tamir Duberstein <tamird@kernel.org>

> > ---
> >  rust/kernel/xarray.rs | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> > index d1246ec114898..eadddafb180ec 100644
> > --- a/rust/kernel/xarray.rs
> > +++ b/rust/kernel/xarray.rs
> > @@ -215,10 +215,8 @@ fn load<F, U>(&self, index: usize, f: F) -> Option=
<U>
> >      where
> >          F: FnOnce(NonNull<c_void>) -> U,
> >      {
> > -        // SAFETY: `self.xa.xa` is always valid by the type invariant.
> > -        let ptr =3D unsafe { bindings::xa_load(self.xa.xa.get(), index=
) };
> > -        let ptr =3D NonNull::new(ptr.cast())?;
> > -        Some(f(ptr))
> > +        let mut state =3D XArrayState::new(self, index);
> > +        Some(f(state.load()?))

This can probably be written as `state.load().map(f)`.

> >      }
> >
> >      /// Checks if the XArray contains an element at the specified inde=
x.
> > @@ -327,7 +325,6 @@ pub fn store(
> >  /// # Invariants
> >  ///
> >  /// - `state` is always a valid `bindings::xa_state`.
> > -#[expect(dead_code)]
> >  pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
> >      /// Holds a reference to the lock guard to ensure the lock is not =
dropped
> >      /// while `Self` is live.
> > @@ -336,7 +333,6 @@ pub(crate) struct XArrayState<'a, 'b, T: ForeignOwn=
able> {
> >  }
> >
> >  impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
> > -    #[expect(dead_code)]
> >      fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
> >          let ptr =3D access.xa.xa.get();
> >          // INVARIANT: We initialize `self.state` to a valid value belo=
w.
> > @@ -356,6 +352,13 @@ fn new(access: &'b Guard<'a, T>, index: usize) -> =
Self {
> >              },
> >          }
> >      }
> > +
> > +    fn load(&mut self) -> Option<NonNull<c_void>> {
> > +        // SAFETY: `state.state` is always valid by the type invariant=
 of
> > +        // `XArrayState and we hold the xarray lock`.
> > +        let ptr =3D unsafe { bindings::xas_load(&raw mut self.state) }=
;
> > +        NonNull::new(ptr.cast())
> > +    }
> >  }
> >
> >  // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff=
 `T` is `Send`.
> >
> > --
> > 2.51.2
> >
> >
> >

