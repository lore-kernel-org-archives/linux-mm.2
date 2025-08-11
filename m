Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F42CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 18:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B454D8E008F; Mon, 11 Aug 2025 14:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D4C8E0045; Mon, 11 Aug 2025 14:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BDF78E008F; Mon, 11 Aug 2025 14:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86F9A8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:03:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 202921402B5
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:03:41 +0000 (UTC)
X-FDA: 83765249442.09.A4F2EC1
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0FC6E18000D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:03:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d9Rf7Z1n;
	spf=pass (imf24.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754935419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d///4wuoQangGNst6fYpzsgtPxISb9SbCVVJE+l8aHU=;
	b=zVDKt3F8/nRaArkk/0u4lEur1twe1p62uKQYaEDXRs8ijoYDlilurOmY2w2NPMMUvPfIUZ
	y1mmD7YWsq6d+YOoyiqp02YMWFjpbXZfdPclrXuGBhYe8bM+1/lgmUSBnyXap2pVU2HIHl
	hNFkjkW+j9HKdG664BLrKjfBYNc2lQ4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d9Rf7Z1n;
	spf=pass (imf24.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754935419; a=rsa-sha256;
	cv=none;
	b=XJ0W4tzyTn4RJDIw32BSSlUe4Kv9T9sc8tv99spDXzfrEykdbL7WaHiNpJEvZGRtcMkbE1
	NRRd5+ccJstThIg5jhr7Xd/PlE9wPT5lT5THB+PR255CDHy8koGhQ7msnXgRbtYKQW62eE
	sAXheHVpSczg7ieWjow5+aURjHFFebc=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3324e2e6f54so52010111fa.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754935417; x=1755540217; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d///4wuoQangGNst6fYpzsgtPxISb9SbCVVJE+l8aHU=;
        b=d9Rf7Z1nR9mECcemGJwTZ+51C/zCWfykZH4zljj7iI+NecifftHzDRunk6r6O+Zo0y
         p2Eosxm0UqdHxyHPXrloOeWD/Id9v7UADgJfAHnzbBE5L6YVKoxe/TD2CsDcuTqHPEHb
         7mnaTaJqNs/rjRpS8N8J7FbCjnfwO+yIPYmol9tkfCPPtfe3uBljqpU1uyxxVqHZW1ZO
         uuZxhTMaXM7/QM0NJ1OvfD6SVD7Sx9Ed/MaJ/IvY9B8gC1g1g8kwyID/qKkc+aijbWPB
         P2/UaAOM0ZSj7qpXW6CLDGH6onstnN9XGrfKtURHl4VYqWhbL5zLK8UeeR+wTu3QoCqv
         y1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754935417; x=1755540217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d///4wuoQangGNst6fYpzsgtPxISb9SbCVVJE+l8aHU=;
        b=TpISeWyB7gtDllTexa0zttxCwqVkDRiGznHDbVqA/OYqF+wz4z8b19a8KDCThTZtI8
         Yg0xUUAeG+zZy077cjmv0uvQlQie6oFmTMAaythCv7tfrt+0Owx8HzA/6tMogc9n1c/+
         nkJJzgeScNvWMNZq8s6A05jaNHgRvfhxgwbhGIBy6NJS+t/i3dsuW2kcQ3y/d7+De4PE
         BC6auOeZ3CDZuvuD5VHXVDvudi+yj0vOw09rTQaKHJK++3BUkODLwl9Q8BtAYdBgFywt
         e/KJ1nUah6BnruihuuX7+GhmYjzP+THWEtf7BM75aTBUXUhvA5nHjukq5pkUuhwUwWfR
         qImg==
X-Forwarded-Encrypted: i=1; AJvYcCUzMbZeMEaBKuxKMAfD3nrVJMbQLEQf++eAc2alzyWhNS5sB0n30w4aPVoH8wCVyTmExVRMvsv4DQ==@kvack.org
X-Gm-Message-State: AOJu0YxG6BOAcZ6Wy//Uv3RsK0At0E3oO1flXcE138EI1Fgc9k4uCXja
	HWhpJ4s6YRbHG1rlgYJv5hbd35c8zJdAnihwwoTD0xPn+IEiwyF0xi1IYyFGYuXFBwh9lzflr6T
	6UhY1yPTuri2TwYs90JtmZvwSu12ex94=
X-Gm-Gg: ASbGncuHD/SLlD1SRHF2FqweAdmKjPLlP8av0q//QX3sFJ3EZVClzzumskfCY66WANL
	nvQkPB8so4hNHHYyLHs1Pw1KrwmnBbjifG9dNM+PS6GcSgv8IrKMVulbOICwmKOME/gX8eGhJmx
	MOTIsUl+TylOzy+wbb6cC55N/UllEjwCG9r6Cqi6xcGlBcOUuRIZOcUctPuhWJRrto0VND+e9r0
	L3o6tNv
X-Google-Smtp-Source: AGHT+IEBGMWFwPBvVKkHkPwEpE2wMzzGocdD5JdNJj56rt+2ZuB0UWbX44hvIpNbmg6xFrgD/0gijWRDGE/YtO1Eu00=
X-Received: by 2002:a05:651c:19a0:b0:332:13d4:6f6e with SMTP id
 38308e7fff4ca-333d7ad9f94mr1663741fa.2.1754935416777; Mon, 11 Aug 2025
 11:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <20250713-xarray-insert-reserve-v2-3-b939645808a2@gmail.com>
 <aJnojv8AWj2isnit@arm.com> <CAJ-ks9=BU2jfT-MPzxDcXrZj7uQkKbVm6WhzGiJsM_628b2kmg@mail.gmail.com>
 <aJn_dtWDcoscYpgV@arm.com>
In-Reply-To: <aJn_dtWDcoscYpgV@arm.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Mon, 11 Aug 2025 14:02:59 -0400
X-Gm-Features: Ac12FXwh33fn1ZAGbWU8KHUjxEVF-ovI5P2-O31Ri2jQBQmGUO28sNFAyHxqAe4
Message-ID: <CAJ-ks9kECSobk0NX6SXn1US7My028POc=nLmw0AHZGiRUstP2g@mail.gmail.com>
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
X-Rspamd-Queue-Id: 0FC6E18000D
X-Rspamd-Server: rspam06
X-Stat-Signature: dtord316b8uqyg6a7orz4oc95wi398yi
X-HE-Tag: 1754935418-776568
X-HE-Meta: U2FsdGVkX18u5Acv05mfMcGx4nrU7sv7fkeJu+HQ8pZeSVVrPOUZqzWOe+dgQosj/kOhACFtSK9OaAHFzKxV1xQRefT39czDyg17MfVCqrBqYJ9wqffYGcvZqrZ5i5b94a+vf6sgr/cf3jpfHxEGNacarFVnsZVd/3STqYxnqQlFglsgyALM0IToOF/hT/ZwXiKu1jMrNJran6LU1GVFnMXFOEIcGk3Xj33yZfriEzBfpTjJq1RrrGSswhAPQ3EGMr1w6VL6Gt2SLCTGr5nPTaYyrJ+KuQe3OribIAPEBX/rRomU7Nf7ZkBEBb1FvjH00MddZYEiG9z81ZvFgGJMwRI9IPgtSEhqxhKqH2j3gBU3cJVShk1xkRi2lPJ8bHkQB+qclDun5ZQ7Gr76pCngX1n3zXw4B1AVDkcW1UNsKIUAF1HpzRPXGPw27VrMkos9MGX029qXOztju5mEg34soiXGIdSrfVVWYA5vkJu5KAzjOX5UXqwQmbwKBj3Otfg5EXmQvJiT21UmgLBD82LEh8kmss0QpsnAaDhKtyhxEytVC8xMefU+Tx6i2b/y0/xU5FkCLBR26rxMdwndXq2vCIApE+LxXemiC23k4sfbNLvpvl7yaqVbUYSM3iMoHHl4BpGUUdqmNGZAmRw8s7B9z90R8jL1vxyWEkR2xNxRK5NJCYzPFssRBakyCvkliVQOlie7+Q8zt4Y9bd4Hg8oetEVrm+sGU6AbgKSihWL9cxSjM79w38I+4pLX+AE/JmZ0quH1DKpNyrnci7JdD2n7DYouuMXVwJNDpdJHuREwDJ3ww2NuYk+RttntNd31ftCjQbSzT3AZ/LMrslszxr3OCwRLG+VyttIGe68rWqt+EBnTCzDnxIelHDUs0Z/U0I8F66vTday1m2SI4B1x0/AdmQz3mI86LucL08iAZnRfsUCAl3DO7pIeRr8z21nJH9FvfL3dA0DcB/VqTFKJ0kI
 VcKWZ6F+
 zgn6swYS1SkSWDjjwc8gx0N3BDqkOCIIq/D/E0E183UICyaHLSnbPyyhXrbTR+hwQKAtbnQdL9qpa8uU49HhDTuM1ZcokN18rZAkyhYB8mdqjwLjFzDspSZxdQcbc+c76jJ4n3goZIn+UT5YlUFxgAs5zC6dFaPBpYcjJrYRFjuu22XISBnf57SPHx3stHRXFWGG5s0Rx0CeLaZCOicqp2tVdqWIKvKUyy5d3uP3DOERRwH3zu9RWkoBSijqUFIU3JLz2930OZiU9+sAaQuZTixNf23swt2pFgl6684HRWXSkMq4+bTVMpGr18Td1HlTdIz0tHGrQ/HcQ2n3rrbk9DVx8oXhcanBAQ9AyCNCZ4wYuv2VJi9by5KSRi+d3blJP7KvMipbd4w6e3BKq2GrndWOFJZIZ7U5VWGctnD09CGp6UWUSh2BRSM6cRH/RJoIrlF5vcII/XPW30ztmxYqaeaKwcyJUeLcPcoFFj7735awAsDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 10:35=E2=80=AFAM Beata Michalska
<beata.michalska@arm.com> wrote:
>
> On Mon, Aug 11, 2025 at 09:09:56AM -0400, Tamir Duberstein wrote:
> > On Mon, Aug 11, 2025 at 8:57=E2=80=AFAM Beata Michalska <beata.michalsk=
a@arm.com> wrote:
> > >
> > > Hi Tamir,
> > >
> > > Apologies for such a late drop.
> >
> > Hi Beata, no worries, thanks for your review.
> >
> > >
> > > On Sun, Jul 13, 2025 at 08:05:49AM -0400, Tamir Duberstein wrote:
> [snip] ...
> > > > +/// A reserved slot in an array.
> > > > +///
> > > > +/// The slot is released when the reservation goes out of scope.
> > > > +///
> > > > +/// Note that the array lock *must not* be held when the reservati=
on is filled or dropped as this
> > > > +/// will lead to deadlock. [`Reservation::fill_locked`] and [`Rese=
rvation::release_locked`] can be
> > > > +/// used in context where the array lock is held.
> > > > +#[must_use =3D "the reservation is released immediately when the r=
eservation is unused"]
> > > > +pub struct Reservation<'a, T: ForeignOwnable> {
> > > > +    xa: &'a XArray<T>,
> > > > +    index: usize,
> > > > +}
> > > > +
> [snip] ...
> > > > +
> > > > +impl<T: ForeignOwnable> Drop for Reservation<'_, T> {
> > > > +    fn drop(&mut self) {
> > > > +        // NB: Errors here are possible since `Guard::store` does =
not honor reservations.
> > > > +        let _: Result =3D self.release_inner(None);
> > > This seems bit risky as one can drop the reservation while still hold=
ing the
> > > lock?
> >
> > Yes, that's true. The only way to avoid it would be to make the
> > reservation borrowed from the guard, but that would exclude usage
> > patterns where the caller wants to reserve and fulfill in different
> > critical sections.
> >
> > Do you have a specific suggestion?
> I guess we could try with locked vs unlocked `Reservation' types, which w=
ould
> have different Drop implementations, and providing a way to convert locke=
d into
> unlocked. Just thinking out loud, so no, nothing specific here.
> At very least we could add 'rust_helper_spin_assert_is_held() ?'

I don't see how having two types of reservations would help.

Can you help me understand how you'd use `rust_helper_spin_assert_is_held` =
here?

> >
> > > > +    }
> > > >  }
> > > >
> > > >  // SAFETY: `XArray<T>` has no shared mutable state so it is `Send`=
 iff `T` is `Send`.
> > > > @@ -282,3 +617,136 @@ unsafe impl<T: ForeignOwnable + Send> Send fo=
r XArray<T> {}
> > > >  // SAFETY: `XArray<T>` serialises the interior mutability it provi=
des so it is `Sync` iff `T` is
> > > >  // `Send`.
> > > >  unsafe impl<T: ForeignOwnable + Send> Sync for XArray<T> {}
> > > > +
> > > > +#[macros::kunit_tests(rust_xarray_kunit)]
> > > > +mod tests {
> > > > +    use super::*;
> > > > +    use pin_init::stack_pin_init;
> > > > +
> > > > +    fn new_kbox<T>(value: T) -> Result<KBox<T>> {
> > > > +        KBox::new(value, GFP_KERNEL).map_err(Into::into)
> > > I believe this should be GFP_ATOMIC as it is being called while holdi=
ng the xa
> > > lock.
> >
> > I'm not sure what you mean - this function can be called in any
> > context, and besides: it is test-only code.
> Actually it cannot: allocations using GFP_KERNEL can sleep so should not =
be
> called from atomic context, which is what is happening in the test cases.

I see. There are no threads involved in these tests, so I think it is
just fine to sleep with this particular lock held. Can you help me
understand why this is incorrect?

>
> ---
> BR
> Beata
> >
> > >
> > > Otherwise:
> > >
> > > Tested-By: Beata Michalska <beata.michalska@arm.com>
> >
> > Thanks!
> > Tamir
> >
> > >
> > > ---
> > > BR
> > > Beata
> > > > +    }
> > > > +
> > > > +    #[test]
> > > > +    fn test_alloc_kind_alloc() -> Result {
> > > > +        test_alloc_kind(AllocKind::Alloc, 0)
> > > > +    }
> > > > +
> > > > +    #[test]
> > > > +    fn test_alloc_kind_alloc1() -> Result {
> > > > +        test_alloc_kind(AllocKind::Alloc1, 1)
> > > > +    }
> > > > +
> > > > +    fn test_alloc_kind(kind: AllocKind, expected_index: usize) -> =
Result {
> > > > +        stack_pin_init!(let xa =3D XArray::new(kind));
> > > > +        let mut guard =3D xa.lock();
> > > > +
> > > > +        let reservation =3D guard.reserve_limit(.., GFP_KERNEL)?;
> > > > +        assert_eq!(reservation.index(), expected_index);
> > > > +        reservation.release_locked(&mut guard)?;
> > > > +
> > > > +        let insertion =3D guard.insert_limit(.., new_kbox(0x1337)?=
, GFP_KERNEL);
> > > > +        assert!(insertion.is_ok());
> > > > +        let insertion_index =3D insertion.unwrap();
> > > > +        assert_eq!(insertion_index, expected_index);
> > > > +
> > > > +        Ok(())
> > > > +    }
> > > > +
> > > > +    #[test]
> > > > +    fn test_insert_and_reserve_interaction() -> Result {
> > > > +        const IDX: usize =3D 0x1337;
> > > > +
> > > > +        fn insert<T: ForeignOwnable>(
> > > > +            guard: &mut Guard<'_, T>,
> > > > +            value: T,
> > > > +        ) -> Result<(), StoreError<T>> {
> > > > +            guard.insert(IDX, value, GFP_KERNEL)
> > > > +        }
> > > > +
> > > > +        fn reserve<'a, T: ForeignOwnable>(guard: &mut Guard<'a, T>=
) -> Result<Reservation<'a, T>> {
> > > > +            guard.reserve(IDX, GFP_KERNEL)
> > > > +        }
> > > > +
> > > > +        #[track_caller]
> > > > +        fn check_not_vacant<'a>(guard: &mut Guard<'a, KBox<usize>>=
) -> Result {
> > > > +            // Insertion fails.
> > > > +            {
> > > > +                let beef =3D new_kbox(0xbeef)?;
> > > > +                let ret =3D insert(guard, beef);
> > > > +                assert!(ret.is_err());
> > > > +                let StoreError { error, value } =3D ret.unwrap_err=
();
> > > > +                assert_eq!(error, EBUSY);
> > > > +                assert_eq!(*value, 0xbeef);
> > > > +            }
> > > > +
> > > > +            // Reservation fails.
> > > > +            {
> > > > +                let ret =3D reserve(guard);
> > > > +                assert!(ret.is_err());
> > > > +                assert_eq!(ret.unwrap_err(), EBUSY);
> > > > +            }
> > > > +
> > > > +            Ok(())
> > > > +        }
> > > > +
> > > > +        stack_pin_init!(let xa =3D XArray::new(Default::default())=
);
> > > > +        let mut guard =3D xa.lock();
> > > > +
> > > > +        // Vacant.
> > > > +        assert_eq!(guard.get(IDX), None);
> > > > +
> > > > +        // Reservation succeeds.
> > > > +        let reservation =3D {
> > > > +            let ret =3D reserve(&mut guard);
> > > > +            assert!(ret.is_ok());
> > > > +            ret.unwrap()
> > > > +        };
> > > > +
> > > > +        // Reserved presents as vacant.
> > > > +        assert_eq!(guard.get(IDX), None);
> > > > +
> > > > +        check_not_vacant(&mut guard)?;
> > > > +
> > > > +        // Release reservation.
> > > > +        {
> > > > +            let ret =3D reservation.release_locked(&mut guard);
> > > > +            assert!(ret.is_ok());
> > > > +            let () =3D ret.unwrap();
> > > > +        }
> > > > +
> > > > +        // Vacant again.
> > > > +        assert_eq!(guard.get(IDX), None);
> > > > +
> > > > +        // Insert succeeds.
> > > > +        {
> > > > +            let dead =3D new_kbox(0xdead)?;
> > > > +            let ret =3D insert(&mut guard, dead);
> > > > +            assert!(ret.is_ok());
> > > > +            let () =3D ret.unwrap();
> > > > +        }
> > > > +
> > > > +        check_not_vacant(&mut guard)?;
> > > > +
> > > > +        // Remove.
> > > > +        assert_eq!(guard.remove(IDX).as_deref(), Some(&0xdead));
> > > > +
> > > > +        // Reserve and fill.
> > > > +        {
> > > > +            let beef =3D new_kbox(0xbeef)?;
> > > > +            let ret =3D reserve(&mut guard);
> > > > +            assert!(ret.is_ok());
> > > > +            let reservation =3D ret.unwrap();
> > > > +            let ret =3D reservation.fill_locked(&mut guard, beef);
> > > > +            assert!(ret.is_ok());
> > > > +            let () =3D ret.unwrap();
> > > > +        };
> > > > +
> > > > +        check_not_vacant(&mut guard)?;
> > > > +
> > > > +        // Remove.
> > > > +        assert_eq!(guard.remove(IDX).as_deref(), Some(&0xbeef));
> > > > +
> > > > +        Ok(())
> > > > +    }
> > > > +}
> > > >
> > > > --
> > > > 2.50.1
> > > >
> > > >
> >

