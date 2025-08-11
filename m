Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5759EC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5DD8E0051; Mon, 11 Aug 2025 09:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7238E0045; Mon, 11 Aug 2025 09:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6FA68E0051; Mon, 11 Aug 2025 09:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C50B58E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:10:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95DF6C0110
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:10:39 +0000 (UTC)
X-FDA: 83764510998.24.B1BCCD3
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 285DB40015
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:10:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hnP6+3qq;
	spf=pass (imf27.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754917837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wjRZSeJyNW+5ttKbH2ZBkdz8rcwxf8fIlvPdNpBzzA=;
	b=BzlFDq7c6DzsQ7MvtuKOp3t7D8VzI52vzh0sUZ5oO94lHA2Ah7vh2r1jKacEI5JBKDNIS/
	b9RY8DBNvOaD6+pdTW754R3zKU27ogksmVkFnNfMoZcoksVJ6aUnYP2Uz+l6zpU43FIJdV
	OLxkvkKp/GpjL811yHt1k8LDEo4egYI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hnP6+3qq;
	spf=pass (imf27.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754917837; a=rsa-sha256;
	cv=none;
	b=3TKJyQcevsWiFuwak/CORBN3hDY633HRfCj5GHBvrnUSACIGgj2/oDiNf4asVJlz+WoQUd
	RznhSq8nmlThJuXF9JyintiqRyYL6kZyAoAJAPWID6T+qKpPJWBe1pPwWtVNhMIEQjHrOH
	ChU3jgRnFl8la9TogkgcR568ZlKlJuo=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32ca160b4bcso36762231fa.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754917835; x=1755522635; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wjRZSeJyNW+5ttKbH2ZBkdz8rcwxf8fIlvPdNpBzzA=;
        b=hnP6+3qqJiVmqj3GqGPS4ilGFnzDlSA5F6Y9V8ITfTUs9teEba3nLs5G/KDoRkNWfc
         hQ0+b8BgZbgXn/cXQhvLPpGtiT+QSGHai6ljURUu7qObR7CtrgCSlzadBxmncdKkFB03
         aefQUSEazFtf875f3MUjmnQcAxYoTB7gxzw/5mpZreGMe7YSieWipNEFrww/vl4HRslv
         zgtcjaRMzSuFiMB7+yE8TRdBhqe1VuEQhDqhspruMQRUt46SA+6U4pX0Q4BkObZ/T9Aq
         5ku0SSd24+H51hTH2aTDKmjx7z6Yw+/PYezO5Nu9XexrqtV1yjkkIqZlZw0KfkySmC7Z
         fQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754917835; x=1755522635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wjRZSeJyNW+5ttKbH2ZBkdz8rcwxf8fIlvPdNpBzzA=;
        b=srk3qDMeuNSOFSHpY+2QC94eP3xwrNorAW13DVgAC3Uhmj7D7KHZydj+GPeIQWzzvy
         WFzGM/IlBrlq0OeHzSuazqyr7iYAPTraRowq0wAQnlJcu8vfTgA5jnpwsmooFTgm9iFg
         1wNq+vLXHlc9u6DknwSCwIEY79TYNKcI5A6JlY5/eLnNNCEEZANk9H5oxa6IJhdp5ORl
         p1VTFznGFaGzWnjRBcAGDuu0nwIBas39A/8FrhzOnA9510cpppxrICtwiemydHBdlMIO
         XlSnIOCaW1b95yxDP9wU0LH+SuLamxZvyhA8XAEghjpe1o4ocTT0mse45POJqYFZxy1o
         OwiA==
X-Forwarded-Encrypted: i=1; AJvYcCVD9D6w4o8fkYi6Go/CMJcfVcentBoDw//oAvZC8ED835u3K3MIG0tygXFsUSlgDCiROTFJJGNaVw==@kvack.org
X-Gm-Message-State: AOJu0YwaJGQlMyoFCpsA/YbyJx3ZcKeyyZm+f9gic6eE1cHHkFgcpgdK
	aD8xOQmRVgHVAQWDK+SjAyKTUIzxsQeHlxmMUP73FKTpXbcbSEnxGNu4XFO8tFGyUnQxR+nlGb4
	NEQyerCzVwbUjAda/wW0oJF/jiMe2xNY=
X-Gm-Gg: ASbGnctxuBRkij9rHbbJfkbjDd9zkbnqSQeJ12SLbieczXwbZVc8fRX5YZq96o6Wf/z
	8FJWZ2sAlz/TmECe6YKg0GPWmoz6SViYD4Nldy8uEzUiwl/sX4PLn9zHrRnuFHsjVMraCAxLGa3
	64vg3T5qjnW9+FZfPe5XR4RISIubm9w9Ae8O2Eniazlzyem4IWkUBMJH2p4jcDmDJ1QUA0TvLfW
	gv3kuY4
X-Google-Smtp-Source: AGHT+IFhwguXrETFSYk+GfysPq0bG0/CaAaeZ+uytQzxymu/tLCMjbyfNZAPxhd33JJ1OuI89/lKq6V8bKcMzG4UQ/Y=
X-Received: by 2002:a2e:b8d6:0:b0:330:d981:1755 with SMTP id
 38308e7fff4ca-333a210d629mr32639241fa.6.1754917834576; Mon, 11 Aug 2025
 06:10:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <20250713-xarray-insert-reserve-v2-3-b939645808a2@gmail.com> <aJnojv8AWj2isnit@arm.com>
In-Reply-To: <aJnojv8AWj2isnit@arm.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Mon, 11 Aug 2025 09:09:56 -0400
X-Gm-Features: Ac12FXxsjq3gMeUfH06sJFBwF4JoZUe97Vj4GSS1AIW6BuPCHKoW2IveFFO1_ac
Message-ID: <CAJ-ks9=BU2jfT-MPzxDcXrZj7uQkKbVm6WhzGiJsM_628b2kmg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rust: xarray: add `insert` and `reserve`
To: Beata Michalska <beata.michalska@arm.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, Janne Grunau <j@jannau.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 285DB40015
X-Rspamd-Server: rspam06
X-Stat-Signature: 87oscau4y39en1193f53qo3ucohejijs
X-HE-Tag: 1754917836-141872
X-HE-Meta: U2FsdGVkX1+POyZ+mk8Tzyn7Wytk8zc4xoO169WBW7HL9tb5chY1S7mDYHmiuYZT00fPlPiX1CfYouflLzvpcpIx4y0MeXBCScxehheyW0bSjMAQeiCNqyYZ0VA+oWv77zJyaqBFotGea0JqEjiYQEH6khP7k3aspI4Zza3/LVdZcoNjLTikUVjXf7e9yGtotgRfRj+cpnOjFUzLDfT6CIlGgiHVhvqpXbfnH9mNHXGWVwOjKfk7w8YeGQIbRhjRldMnnVr9M6/g5dYxxwvLNYEeZhprVkFMV/qdH4SReS97eztCT3i95dsl/4OqPAgiSAjCVIy36ozxE7KCD9ZLfk1DAOC5L9FKeI89aQ6vxJDE8BPypNF+8Axwby6QKGH8FRPlPctDR4PrfBrU1cumFu+gizNh1auJr5ob12oK05cyUvvO6iv5YS+0pTERPWaxSpYKHcRZFw2f+3rRzyeTPlWsMomzYKBcaGWOESPwdG9KYKidGOGmZgzbUW6BzmRd6aU9SOZ43Hhj3UyYOG3i/esPWwZQ7liJeSAYd3tZ7NnO2rbEjim+Q2+Kc2Nho/Aypn12zj6n6JTT4gLlBZ0i83UEhy7aPogSPsGYexT+KINSt3Xp26pbHGQzbJf4dfS8L1YBzHk98FrsW+EQTji/FAICBi4pSiCojx1zs3Z9hrkabdKxpJ9qVPFHox1iUjp0Jia9ZZx95FiUqlnoscdGulFbdfPXD0Tk53TX1cpdnofTqCokWVIOokeHN1/DYvrriUI4c1QiQDF03fWVqgI/SsX+18D9QKr6JNDiYtI5+EezwIsQ5l9tZ9H8M2IEqFMSehaYAVONRJHg9wT9UcxnHJ4BNhT3YnY+PnwhGANI9I0PBjCAxE1wsb5cqKiPsI/JPKUe0nQOg6lzjL3HabI2w/Zqdb+J3SwSwj/WSSMOxyvHGe+9B690fvjEHZlu4luaTeXt8N2rgWM0Zh8X4w1
 P+AbMK26
 7xexO9M+VEtPOX9qJ8TO0Sm7OsavAzSTzaI4BcrFJjwP4glaVdC/Q/6APwbfYT+WMFKphpjBE5ucdXW9KRBDWTox1WHUBC54O0pXXvOEZuly1mfM9fQM88bB38GWNgDWKgjiJNt8ApnSZwWOIeTWRLIj6T/IALMiVoMx1Yk27o0GTsuxTrX/yL4YKbequ+DR3VF3z4aa2KVw7e/4ysqwCkohW5hQZgPAOpJDuRY9+iV/8FtWYJpkq1X2yrBhOPJ0q0qdk/GNQ7kvP+kK9NbDHyHuEvmLlVgPrNt9YAdOiY0LAeqrzS6iKCE5Ywp/mLkfknzVjf/NO83JMrZI6wT5i/QLEk3/gB/jFoaanfSQ3X7oy8N5FMtOmZvlIvn2SgzmM49cfVe0Y7p03A2a4iDHQFqI6qOwTnRPS00pE8IZm/7+64b92xrk4tbHYgElFnKvajtdy6IUS8ntP1pljjh2gluMMlRsrK9VhB6oSYxLlHfFne4ua8s16ZoLTCH/TjSoD4lw1iNx9LWCaFX2bm7VDOMUInsLdTjCsBxneI6Hb5+hPqWYadBGvY/5GkTF3Bu7TyYzvnTg7sqv0iIVxWMnXbRqwQ7YA7KtAOG4G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 8:57=E2=80=AFAM Beata Michalska <beata.michalska@ar=
m.com> wrote:
>
> Hi Tamir,
>
> Apologies for such a late drop.

Hi Beata, no worries, thanks for your review.

>
> On Sun, Jul 13, 2025 at 08:05:49AM -0400, Tamir Duberstein wrote:
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
> > ---
> >  include/linux/xarray.h |   2 +
> >  lib/xarray.c           |  28 ++-
> >  rust/helpers/xarray.c  |   5 +
> >  rust/kernel/xarray.rs  | 494 +++++++++++++++++++++++++++++++++++++++++=
++++++--
> >  4 files changed, 512 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> > index be850174e802..64f2a5e06ceb 100644
> > --- a/include/linux/xarray.h
> > +++ b/include/linux/xarray.h
> > @@ -563,6 +563,8 @@ void *__xa_erase(struct xarray *, unsigned long ind=
ex);
> >  void *__xa_store(struct xarray *, unsigned long index, void *entry, gf=
p_t);
> >  void *__xa_cmpxchg(struct xarray *, unsigned long index, void *old,
> >               void *entry, gfp_t);
> > +void *__xa_cmpxchg_raw(struct xarray *, unsigned long index, void *old=
,
> > +             void *entry, gfp_t);
> >  int __must_check __xa_insert(struct xarray *, unsigned long index,
> >               void *entry, gfp_t);
> >  int __must_check __xa_alloc(struct xarray *, u32 *id, void *entry,
> > diff --git a/lib/xarray.c b/lib/xarray.c
> > index 76dde3a1cacf..58202b6fbb59 100644
> > --- a/lib/xarray.c
> > +++ b/lib/xarray.c
> > @@ -1738,9 +1738,6 @@ void *xa_store(struct xarray *xa, unsigned long i=
ndex, void *entry, gfp_t gfp)
> >  }
> >  EXPORT_SYMBOL(xa_store);
> >
> > -static inline void *__xa_cmpxchg_raw(struct xarray *xa, unsigned long =
index,
> > -                     void *old, void *entry, gfp_t gfp);
> > -
> >  /**
> >   * __xa_cmpxchg() - Conditionally replace an entry in the XArray.
> >   * @xa: XArray.
> > @@ -1767,7 +1764,29 @@ void *__xa_cmpxchg(struct xarray *xa, unsigned l=
ong index,
> >  }
> >  EXPORT_SYMBOL(__xa_cmpxchg);
> >
> > -static inline void *__xa_cmpxchg_raw(struct xarray *xa, unsigned long =
index,
> > +/**
> > + * __xa_cmpxchg_raw() - Conditionally replace an entry in the XArray.
> > + * @xa: XArray.
> > + * @index: Index into array.
> > + * @old: Old value to test against.
> > + * @entry: New value to place in array.
> > + * @gfp: Memory allocation flags.
> > + *
> > + * You must already be holding the xa_lock when calling this function.
> > + * It will drop the lock if needed to allocate memory, and then reacqu=
ire
> > + * it afterwards.
> > + *
> > + * If the entry at @index is the same as @old, replace it with @entry.
> > + * If the return value is equal to @old, then the exchange was success=
ful.
> > + *
> > + * This function is the same as __xa_cmpxchg() except that it does not=
 coerce
> > + * XA_ZERO_ENTRY to NULL on egress.
> > + *
> > + * Context: Any context.  Expects xa_lock to be held on entry.  May
> > + * release and reacquire xa_lock if @gfp flags permit.
> > + * Return: The old value at this index or xa_err() if an error happene=
d.
> > + */
> > +void *__xa_cmpxchg_raw(struct xarray *xa, unsigned long index,
> >                       void *old, void *entry, gfp_t gfp)
> >  {
> >       XA_STATE(xas, xa, index);
> > @@ -1787,6 +1806,7 @@ static inline void *__xa_cmpxchg_raw(struct xarra=
y *xa, unsigned long index,
> >
> >       return xas_result(&xas, curr);
> >  }
> > +EXPORT_SYMBOL(__xa_cmpxchg_raw);
> >
> >  /**
> >   * __xa_insert() - Store this entry in the XArray if no entry is prese=
nt.
> > diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
> > index 60b299f11451..b6c078e6a343 100644
> > --- a/rust/helpers/xarray.c
> > +++ b/rust/helpers/xarray.c
> > @@ -2,6 +2,11 @@
> >
> >  #include <linux/xarray.h>
> >
> > +void *rust_helper_xa_zero_entry(void)
> > +{
> > +     return XA_ZERO_ENTRY;
> > +}
> > +
> >  int rust_helper_xa_err(void *entry)
> >  {
> >       return xa_err(entry);
> > diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> > index 101f61c0362d..a43414bb4d7e 100644
> > --- a/rust/kernel/xarray.rs
> > +++ b/rust/kernel/xarray.rs
> > @@ -9,7 +9,12 @@
> >      prelude::*,
> >      types::{ForeignOwnable, NotThreadSafe, Opaque},
> >  };
> > -use core::{iter, marker::PhantomData, mem, ptr::NonNull};
> > +use core::{
> > +    fmt, iter,
> > +    marker::PhantomData,
> > +    mem, ops,
> > +    ptr::{null_mut, NonNull},
> > +};
> >
> >  /// An array which efficiently maps sparse integer indices to owned ob=
jects.
> >  ///
> > @@ -25,29 +30,81 @@
> >  ///
> >  /// ```rust
> >  /// # use kernel::alloc::KBox;
> > -/// # use kernel::xarray::XArray;
> > +/// # use kernel::xarray::{StoreError, XArray};
> >  /// # use pin_init::stack_pin_init;
> >  ///
> >  /// stack_pin_init!(let xa =3D XArray::new(Default::default()));
> >  ///
> >  /// let dead =3D KBox::new(0xdead, GFP_KERNEL)?;
> >  /// let beef =3D KBox::new(0xbeef, GFP_KERNEL)?;
> > +/// let leet =3D KBox::new(0x1337, GFP_KERNEL)?;
> > +///
> > +/// let mut guard =3D xa.lock();
> > +///
> > +/// let index =3D guard.insert_limit(.., dead, GFP_KERNEL)?;
> > +///
> > +/// assert_eq!(guard.get(index), Some(&0xdead));
> > +///
> > +/// let beef =3D {
> > +///     let ret =3D guard.insert(index, beef, GFP_KERNEL);
> > +///     assert!(ret.is_err());
> > +///     let StoreError { value, error } =3D ret.unwrap_err();
> > +///     assert_eq!(error, EBUSY);
> > +///     value
> > +/// };
> > +///
> > +/// let reservation =3D guard.reserve_limit(.., GFP_KERNEL);
> > +/// assert!(reservation.is_ok());
> > +/// let reservation1 =3D reservation.unwrap();
> > +/// let reservation =3D guard.reserve_limit(.., GFP_KERNEL);
> > +/// assert!(reservation.is_ok());
> > +/// let reservation2 =3D reservation.unwrap();
> > +///
> > +/// assert_eq!(reservation1.index(), index + 1);
> > +/// assert_eq!(reservation2.index(), index + 2);
> > +///
> > +/// let dead =3D {
> > +///     let ret =3D guard.remove(index);
> > +///     assert!(ret.is_some());
> > +///     ret.unwrap()
> > +/// };
> > +/// assert_eq!(*dead, 0xdead);
> > +///
> > +/// drop(guard); // Reservations can outlive the guard.
> > +///
> > +/// let () =3D reservation1.fill(dead)?;
> > +///
> > +/// let index =3D reservation2.index();
> >  ///
> >  /// let mut guard =3D xa.lock();
> >  ///
> > -/// assert_eq!(guard.get(0), None);
> > +/// let beef =3D {
> > +///     let ret =3D guard.insert(index, beef, GFP_KERNEL);
> > +///     assert!(ret.is_err());
> > +///     let StoreError { value, error } =3D ret.unwrap_err();
> > +///     assert_eq!(error, EBUSY);
> > +///     value
> > +/// };
> >  ///
> > -/// assert_eq!(guard.store(0, dead, GFP_KERNEL)?.as_deref(), None);
> > -/// assert_eq!(guard.get(0).copied(), Some(0xdead));
> > +/// // `store` ignores reservations.
> > +/// {
> > +///    let ret =3D guard.store(index, beef, GFP_KERNEL);
> > +///    assert!(ret.is_ok());
> > +///    assert_eq!(ret.unwrap().as_deref(), None);
> > +/// }
> >  ///
> > -/// *guard.get_mut(0).unwrap() =3D 0xffff;
> > -/// assert_eq!(guard.get(0).copied(), Some(0xffff));
> > +/// assert_eq!(guard.get(index), Some(&0xbeef));
> >  ///
> > -/// assert_eq!(guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(), =
Some(0xffff));
> > -/// assert_eq!(guard.get(0).copied(), Some(0xbeef));
> > +/// // We trampled the reservation above, so filling should fail.
> > +/// let leet =3D {
> > +///    let ret =3D reservation2.fill_locked(&mut guard, leet);
> > +///    assert!(ret.is_err());
> > +///    let StoreError { value, error } =3D ret.unwrap_err();
> > +///    assert_eq!(error, EBUSY);
> > +///    value
> > +/// };
> >  ///
> > -/// guard.remove(0);
> > -/// assert_eq!(guard.get(0), None);
> > +/// assert_eq!(guard.get(index), Some(&0xbeef));
> >  ///
> >  /// # Ok::<(), Error>(())
> >  /// ```
> > @@ -126,6 +183,19 @@ fn iter(&self) -> impl Iterator<Item =3D NonNull<T=
::PointedTo>> + '_ {
> >          .map_while(|ptr| NonNull::new(ptr.cast()))
> >      }
> >
> > +    fn with_guard<F, U>(&self, guard: Option<&mut Guard<'_, T>>, f: F)=
 -> U
> > +    where
> > +        F: FnOnce(&mut Guard<'_, T>) -> U,
> > +    {
> > +        match guard {
> > +            None =3D> f(&mut self.lock()),
> > +            Some(guard) =3D> {
> > +                assert_eq!(guard.xa.xa.get(), self.xa.get());
> > +                f(guard)
> > +            }
> > +        }
> > +    }
> > +
> >      /// Attempts to lock the [`XArray`] for exclusive access.
> >      pub fn try_lock(&self) -> Option<Guard<'_, T>> {
> >          // SAFETY: `self.xa` is always valid by the type invariant.
> > @@ -172,6 +242,7 @@ fn drop(&mut self) {
> >  /// The error returned by [`store`](Guard::store).
> >  ///
> >  /// Contains the underlying error and the value that was not stored.
> > +#[derive(Debug)]
> >  pub struct StoreError<T> {
> >      /// The error that occurred.
> >      pub error: Error,
> > @@ -185,6 +256,11 @@ fn from(value: StoreError<T>) -> Self {
> >      }
> >  }
> >
> > +fn to_usize(i: u32) -> usize {
> > +    i.try_into()
> > +        .unwrap_or_else(|_| build_error!("cannot convert u32 to usize"=
))
> > +}
> > +
> >  impl<'a, T: ForeignOwnable> Guard<'a, T> {
> >      fn load<F, U>(&self, index: usize, f: F) -> Option<U>
> >      where
> > @@ -219,7 +295,7 @@ pub fn remove(&mut self, index: usize) -> Option<T>=
 {
> >          // - The caller holds the lock.
> >          let ptr =3D unsafe { bindings::__xa_erase(self.xa.xa.get(), in=
dex) }.cast();
> >          // SAFETY:
> > -        // - `ptr` is either NULL or came from `T::into_foreign`.
> > +        // - `ptr` is either `NULL` or came from `T::into_foreign`.
> >          // - `&mut self` guarantees that the lifetimes of [`T::Borrowe=
d`] and [`T::BorrowedMut`]
> >          // borrowed from `self` have ended.
> >          unsafe { T::try_from_foreign(ptr) }
> > @@ -267,13 +343,272 @@ pub fn store(
> >              })
> >          } else {
> >              let old =3D old.cast();
> > -            // SAFETY: `ptr` is either NULL or came from `T::into_fore=
ign`.
> > +            // SAFETY: `ptr` is either `NULL` or came from `T::into_fo=
reign`.
> >              //
> >              // NB: `XA_ZERO_ENTRY` is never returned by functions belo=
nging to the Normal XArray
> >              // API; such entries present as `NULL`.
> >              Ok(unsafe { T::try_from_foreign(old) })
> >          }
> >      }
> > +
> > +    /// Stores an element at the given index if no entry is present.
> > +    ///
> > +    /// May drop the lock if needed to allocate memory, and then reacq=
uire it afterwards.
> > +    ///
> > +    /// On failure, returns the element which was attempted to be stor=
ed.
> > +    pub fn insert(
> > +        &mut self,
> > +        index: usize,
> > +        value: T,
> > +        gfp: alloc::Flags,
> > +    ) -> Result<(), StoreError<T>> {
> > +        build_assert!(
> > +            mem::align_of::<T::PointedTo>() >=3D 4,
> > +            "pointers stored in XArray must be 4-byte aligned"
> > +        );
> > +        let ptr =3D value.into_foreign();
> > +        // SAFETY: `self.xa` is always valid by the type invariant.
> > +        //
> > +        // INVARIANT: `ptr` came from `T::into_foreign`.
> > +        match unsafe { bindings::__xa_insert(self.xa.xa.get(), index, =
ptr.cast(), gfp.as_raw()) } {
> > +            0 =3D> Ok(()),
> > +            errno =3D> {
> > +                // SAFETY: `ptr` came from `T::into_foreign` and `__xa=
_insert` does not take
> > +                // ownership of the value on error.
> > +                let value =3D unsafe { T::from_foreign(ptr) };
> > +                Err(StoreError {
> > +                    value,
> > +                    error: Error::from_errno(errno),
> > +                })
> > +            }
> > +        }
> > +    }
> > +
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
> > +    ///
> > +    /// On success, returns the index at which the entry was stored.
> > +    ///
> > +    /// On failure, returns the entry which was attempted to be stored=
.
> > +    pub fn insert_limit(
> > +        &mut self,
> > +        limit: impl ops::RangeBounds<u32>,
> > +        value: T,
> > +        gfp: alloc::Flags,
> > +    ) -> Result<usize, StoreError<T>> {
> > +        build_assert!(
> > +            mem::align_of::<T::PointedTo>() >=3D 4,
> > +            "pointers stored in XArray must be 4-byte aligned"
> > +        );
> > +        let ptr =3D value.into_foreign();
> > +        // SAFETY: `ptr` came from `T::into_foreign`.
> > +        unsafe { self.alloc(limit, ptr, gfp) }.map_err(|error| {
> > +            // SAFETY: `ptr` came from `T::into_foreign` and `self.all=
oc` does not take ownership of
> > +            // the value on error.
> > +            let value =3D unsafe { T::from_foreign(ptr) };
> > +            StoreError { value, error }
> > +        })
> > +    }
> > +
> > +    /// Reserves an entry in the array.
> > +    pub fn reserve(&mut self, index: usize, gfp: alloc::Flags) -> Resu=
lt<Reservation<'a, T>> {
> > +        // NB: `__xa_insert` internally coerces `NULL` to `XA_ZERO_ENT=
RY` on ingress.
> > +        let ptr =3D null_mut();
> > +        // SAFETY: `self.xa` is always valid by the type invariant.
> > +        //
> > +        // INVARIANT: `ptr` is `NULL`.
> > +        match unsafe { bindings::__xa_insert(self.xa.xa.get(), index, =
ptr, gfp.as_raw()) } {
> > +            0 =3D> Ok(Reservation { xa: self.xa, index }),
> > +            errno =3D> Err(Error::from_errno(errno)),
> > +        }
> > +    }
> > +
> > +    /// Reserves an entry somewhere in the array.
> > +    pub fn reserve_limit(
> > +        &mut self,
> > +        limit: impl ops::RangeBounds<u32>,
> > +        gfp: alloc::Flags,
> > +    ) -> Result<Reservation<'a, T>> {
> > +        // NB: `__xa_alloc` internally coerces `NULL` to `XA_ZERO_ENTR=
Y` on ingress.
> > +        let ptr =3D null_mut();
> > +        // SAFETY: `ptr` is `NULL`.
> > +        unsafe { self.alloc(limit, ptr, gfp) }.map(|index| Reservation=
 { xa: self.xa, index })
> > +    }
> > +}
> > +
> > +/// A reserved slot in an array.
> > +///
> > +/// The slot is released when the reservation goes out of scope.
> > +///
> > +/// Note that the array lock *must not* be held when the reservation i=
s filled or dropped as this
> > +/// will lead to deadlock. [`Reservation::fill_locked`] and [`Reservat=
ion::release_locked`] can be
> > +/// used in context where the array lock is held.
> > +#[must_use =3D "the reservation is released immediately when the reser=
vation is unused"]
> > +pub struct Reservation<'a, T: ForeignOwnable> {
> > +    xa: &'a XArray<T>,
> > +    index: usize,
> > +}
> > +
> > +impl<T: ForeignOwnable> fmt::Debug for Reservation<'_, T> {
> > +    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
> > +        f.debug_struct("Reservation")
> > +            .field("index", &self.index())
> > +            .finish()
> > +    }
> > +}
> > +
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
> > +    unsafe fn replace(guard: &mut Guard<'_, T>, index: usize, ptr: *mu=
t T::PointedTo) -> Result {
> > +        // SAFETY: `xa_zero_entry` wraps `XA_ZERO_ENTRY` which is alwa=
ys safe to use.
> > +        let old =3D unsafe { bindings::xa_zero_entry() };
> > +
> > +        // NB: `__xa_cmpxchg_raw` is used over `__xa_cmpxchg` because =
the latter coerces
> > +        // `XA_ZERO_ENTRY` to `NULL` on egress, which would prevent us=
 from determining whether a
> > +        // replacement was made.
> > +        //
> > +        // SAFETY: `self.xa` is always valid by the type invariant.
> > +        //
> > +        // INVARIANT: `ptr` is either `NULL` or came from `T::into_for=
eign` and `old` is
> > +        // `XA_ZERO_ENTRY`.
> > +        let ret =3D
> > +            unsafe { bindings::__xa_cmpxchg_raw(guard.xa.xa.get(), ind=
ex, old, ptr.cast(), 0) };
> > +
> > +        // SAFETY: `__xa_cmpxchg_raw` returns the old entry at this in=
dex on success or `xa_err` if
> > +        // an error happened.
> > +        match unsafe { bindings::xa_err(ret) } {
> > +            0 =3D> {
> > +                if ret =3D=3D old {
> > +                    Ok(())
> > +                } else {
> > +                    Err(EBUSY)
> > +                }
> > +            }
> > +            errno =3D> Err(Error::from_errno(errno)),
> > +        }
> > +    }
> > +
> > +    fn fill_inner(&self, guard: Option<&mut Guard<'_, T>>, value: T) -=
> Result<(), StoreError<T>> {
> > +        let Self { xa, index } =3D self;
> > +        let index =3D *index;
> > +
> > +        let ptr =3D value.into_foreign();
> > +        xa.with_guard(guard, |guard| {
> > +            // SAFETY: `ptr` came from `T::into_foreign`.
> > +            unsafe { Self::replace(guard, index, ptr) }
> > +        })
> > +        .map_err(|error| {
> > +            // SAFETY: `ptr` came from `T::into_foreign` and `Self::re=
place` does not take ownership
> > +            // of the value on error.
> > +            let value =3D unsafe { T::from_foreign(ptr) };
> > +            StoreError { value, error }
> > +        })
> > +    }
> > +
> > +    /// Fills the reservation.
> > +    pub fn fill(self, value: T) -> Result<(), StoreError<T>> {
> > +        let result =3D self.fill_inner(None, value);
> > +        mem::forget(self);
> > +        result
> > +    }
> > +
> > +    /// Fills the reservation without acquiring the array lock.
> > +    ///
> > +    /// # Panics
> > +    ///
> > +    /// Panics if the passed guard locks a different array.
> > +    pub fn fill_locked(self, guard: &mut Guard<'_, T>, value: T) -> Re=
sult<(), StoreError<T>> {
> > +        let result =3D self.fill_inner(Some(guard), value);
> > +        mem::forget(self);
> > +        result
> > +    }
> > +
> > +    fn release_inner(&self, guard: Option<&mut Guard<'_, T>>) -> Resul=
t {
> > +        let Self { xa, index } =3D self;
> > +        let index =3D *index;
> > +
> > +        xa.with_guard(guard, |guard| {
> > +            let ptr =3D null_mut();
> > +            // SAFETY: `ptr` is `NULL`.
> > +            unsafe { Self::replace(guard, index, ptr) }
> > +        })
> > +    }
> > +
> > +    /// Releases the reservation without acquiring the array lock.
> > +    ///
> > +    /// # Panics
> > +    ///
> > +    /// Panics if the passed guard locks a different array.
> > +    pub fn release_locked(self, guard: &mut Guard<'_, T>) -> Result {
> > +        let result =3D self.release_inner(Some(guard));
> > +        mem::forget(self);
> > +        result
> > +    }
> > +}
> > +
> > +impl<T: ForeignOwnable> Drop for Reservation<'_, T> {
> > +    fn drop(&mut self) {
> > +        // NB: Errors here are possible since `Guard::store` does not =
honor reservations.
> > +        let _: Result =3D self.release_inner(None);
> This seems bit risky as one can drop the reservation while still holding =
the
> lock?

Yes, that's true. The only way to avoid it would be to make the
reservation borrowed from the guard, but that would exclude usage
patterns where the caller wants to reserve and fulfill in different
critical sections.

Do you have a specific suggestion?

> > +    }
> >  }
> >
> >  // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff=
 `T` is `Send`.
> > @@ -282,3 +617,136 @@ unsafe impl<T: ForeignOwnable + Send> Send for XA=
rray<T> {}
> >  // SAFETY: `XArray<T>` serialises the interior mutability it provides =
so it is `Sync` iff `T` is
> >  // `Send`.
> >  unsafe impl<T: ForeignOwnable + Send> Sync for XArray<T> {}
> > +
> > +#[macros::kunit_tests(rust_xarray_kunit)]
> > +mod tests {
> > +    use super::*;
> > +    use pin_init::stack_pin_init;
> > +
> > +    fn new_kbox<T>(value: T) -> Result<KBox<T>> {
> > +        KBox::new(value, GFP_KERNEL).map_err(Into::into)
> I believe this should be GFP_ATOMIC as it is being called while holding t=
he xa
> lock.

I'm not sure what you mean - this function can be called in any
context, and besides: it is test-only code.

>
> Otherwise:
>
> Tested-By: Beata Michalska <beata.michalska@arm.com>

Thanks!
Tamir

>
> ---
> BR
> Beata
> > +    }
> > +
> > +    #[test]
> > +    fn test_alloc_kind_alloc() -> Result {
> > +        test_alloc_kind(AllocKind::Alloc, 0)
> > +    }
> > +
> > +    #[test]
> > +    fn test_alloc_kind_alloc1() -> Result {
> > +        test_alloc_kind(AllocKind::Alloc1, 1)
> > +    }
> > +
> > +    fn test_alloc_kind(kind: AllocKind, expected_index: usize) -> Resu=
lt {
> > +        stack_pin_init!(let xa =3D XArray::new(kind));
> > +        let mut guard =3D xa.lock();
> > +
> > +        let reservation =3D guard.reserve_limit(.., GFP_KERNEL)?;
> > +        assert_eq!(reservation.index(), expected_index);
> > +        reservation.release_locked(&mut guard)?;
> > +
> > +        let insertion =3D guard.insert_limit(.., new_kbox(0x1337)?, GF=
P_KERNEL);
> > +        assert!(insertion.is_ok());
> > +        let insertion_index =3D insertion.unwrap();
> > +        assert_eq!(insertion_index, expected_index);
> > +
> > +        Ok(())
> > +    }
> > +
> > +    #[test]
> > +    fn test_insert_and_reserve_interaction() -> Result {
> > +        const IDX: usize =3D 0x1337;
> > +
> > +        fn insert<T: ForeignOwnable>(
> > +            guard: &mut Guard<'_, T>,
> > +            value: T,
> > +        ) -> Result<(), StoreError<T>> {
> > +            guard.insert(IDX, value, GFP_KERNEL)
> > +        }
> > +
> > +        fn reserve<'a, T: ForeignOwnable>(guard: &mut Guard<'a, T>) ->=
 Result<Reservation<'a, T>> {
> > +            guard.reserve(IDX, GFP_KERNEL)
> > +        }
> > +
> > +        #[track_caller]
> > +        fn check_not_vacant<'a>(guard: &mut Guard<'a, KBox<usize>>) ->=
 Result {
> > +            // Insertion fails.
> > +            {
> > +                let beef =3D new_kbox(0xbeef)?;
> > +                let ret =3D insert(guard, beef);
> > +                assert!(ret.is_err());
> > +                let StoreError { error, value } =3D ret.unwrap_err();
> > +                assert_eq!(error, EBUSY);
> > +                assert_eq!(*value, 0xbeef);
> > +            }
> > +
> > +            // Reservation fails.
> > +            {
> > +                let ret =3D reserve(guard);
> > +                assert!(ret.is_err());
> > +                assert_eq!(ret.unwrap_err(), EBUSY);
> > +            }
> > +
> > +            Ok(())
> > +        }
> > +
> > +        stack_pin_init!(let xa =3D XArray::new(Default::default()));
> > +        let mut guard =3D xa.lock();
> > +
> > +        // Vacant.
> > +        assert_eq!(guard.get(IDX), None);
> > +
> > +        // Reservation succeeds.
> > +        let reservation =3D {
> > +            let ret =3D reserve(&mut guard);
> > +            assert!(ret.is_ok());
> > +            ret.unwrap()
> > +        };
> > +
> > +        // Reserved presents as vacant.
> > +        assert_eq!(guard.get(IDX), None);
> > +
> > +        check_not_vacant(&mut guard)?;
> > +
> > +        // Release reservation.
> > +        {
> > +            let ret =3D reservation.release_locked(&mut guard);
> > +            assert!(ret.is_ok());
> > +            let () =3D ret.unwrap();
> > +        }
> > +
> > +        // Vacant again.
> > +        assert_eq!(guard.get(IDX), None);
> > +
> > +        // Insert succeeds.
> > +        {
> > +            let dead =3D new_kbox(0xdead)?;
> > +            let ret =3D insert(&mut guard, dead);
> > +            assert!(ret.is_ok());
> > +            let () =3D ret.unwrap();
> > +        }
> > +
> > +        check_not_vacant(&mut guard)?;
> > +
> > +        // Remove.
> > +        assert_eq!(guard.remove(IDX).as_deref(), Some(&0xdead));
> > +
> > +        // Reserve and fill.
> > +        {
> > +            let beef =3D new_kbox(0xbeef)?;
> > +            let ret =3D reserve(&mut guard);
> > +            assert!(ret.is_ok());
> > +            let reservation =3D ret.unwrap();
> > +            let ret =3D reservation.fill_locked(&mut guard, beef);
> > +            assert!(ret.is_ok());
> > +            let () =3D ret.unwrap();
> > +        };
> > +
> > +        check_not_vacant(&mut guard)?;
> > +
> > +        // Remove.
> > +        assert_eq!(guard.remove(IDX).as_deref(), Some(&0xbeef));
> > +
> > +        Ok(())
> > +    }
> > +}
> >
> > --
> > 2.50.1
> >
> >

