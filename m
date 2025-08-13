Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0665CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AEC2900043; Wed, 13 Aug 2025 04:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186468E01B6; Wed, 13 Aug 2025 04:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C516900043; Wed, 13 Aug 2025 04:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFC688E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:00:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A21D0B7FAB
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:00:26 +0000 (UTC)
X-FDA: 83770986852.04.A824DFC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96633140002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:00:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of beata.michalska@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=beata.michalska@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755072025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TiItsnm1C8RdqDiVWIodTcy2C+DJkk1SN2rAIFN93kY=;
	b=OStGYC1ic4yoaZJw8GRA3cqnDr4xl6YI/7ft2i0SrmxccSJV/IGL8p5n8TX4Ol/I1XR7NM
	y7bAJh4PReeev2tLnh43w9a+u0Y+jVWtTCWt5F93tnkVYRP5Cj8Z2Xaeu6PdR7p/WF7Mio
	nwRNlr12WQoS9cgoHO6rPCcXP2Ms5j8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755072025; a=rsa-sha256;
	cv=none;
	b=oOZ0FM1xk2q/9slb8ZYyn18v0o7eEngSjRIpyPDztkIrCgxpXnocIR6z50E/8swluWKeFw
	jTX4GNR+8d5p6Q8lcYwksjeqr8NQrHkeNN84lU533K04K0LnuA5JpVCnkhTjOzChIT45qg
	q+JExvBSaaDcPXr1L2ojriQRjGyUTvE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of beata.michalska@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=beata.michalska@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5470C113E;
	Wed, 13 Aug 2025 01:00:15 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7AFE63F5A1;
	Wed, 13 Aug 2025 01:00:19 -0700 (PDT)
Date: Wed, 13 Aug 2025 10:00:04 +0200
From: Beata Michalska <beata.michalska@arm.com>
To: Tamir Duberstein <tamird@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH v2 3/3] rust: xarray: add `insert` and `reserve`
Message-ID: <aJxGBHbcCdHjTo-B@arm.com>
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <20250713-xarray-insert-reserve-v2-3-b939645808a2@gmail.com>
 <aJnojv8AWj2isnit@arm.com>
 <CAJ-ks9=BU2jfT-MPzxDcXrZj7uQkKbVm6WhzGiJsM_628b2kmg@mail.gmail.com>
 <aJn_dtWDcoscYpgV@arm.com>
 <CAJ-ks9kECSobk0NX6SXn1US7My028POc=nLmw0AHZGiRUstP2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ-ks9kECSobk0NX6SXn1US7My028POc=nLmw0AHZGiRUstP2g@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 96633140002
X-Stat-Signature: wypx9p3779gnmon33xpx9wth9zx4suoh
X-Rspam-User: 
X-HE-Tag: 1755072024-819493
X-HE-Meta: U2FsdGVkX19EPtGven7s18gQcgy68vHqc0qgXmQbgyBeuqscZNSmJoWTSln5rVNWV6ErY/SINW5tIuTzSGfPaqXsxPWA53uDaj+0o/edNppcZ4dJ5evNDkxTNvUTNR+yMNgn3txQEuMzlOptPf08ooNAUjbIthXfnNQOfGQlcYC+7B3oQKKm5Vxg3uEKzGPRAq4KBjdaxO1dAMVVZN8MF57jT3aT9vsHtXfMPS6bsuVAj9u5WBMeE6t9ZKuP4hGNfpafLHhrWVcWeezcup7hnjRc9iOsRciTYDbEyoVUlZf1aqVxS17WtqIHNa1uzUo9j+xLr5SMTUsM0XmQ8dt7yylA64oM+3i5k/DoI+SbdSUb+JdJ4Gph0YLAR3QUNlTUQ7VLOB6VgHJVI5CK/xtsP37jLx4UDwEFB3X23H+8v8q/XrY1vMQFna561wFJjPc5dLmGirLjIduRd14aZiPURRGIw8i/y0EWg9JtU9AMUqXdgkhXqXJMm5E+IUhOCAGp/wDsOdly5kM66JRK6/echtljIVA9rT/ZUw8MPqt1XPBtMKrpzd9HN9WtS7z+ih3w5WcW/FmjSE3Ar2TszYpRlevuIiVkABtxn1heIitshoE+u+SQRp51nkXrjXmfc3PQgksi1c3bGANqmOFHQpKbIx/gn8mX0/MhmnVYnCXtOvuzxekhFFijMItafIWVgd8vFWIGp6mYoVeKjDATcFr3HO3DGTw4/jklOZiHM2Og4oO14Q7a1vZAIZdzYUktxWbdANNBVK3CyTDO/ZIzf/EukqVdVDWiRy7DfgJ+AwUU92csiiYd+k3qPdYpkh/dOt0D9os/dCStA/G4hPpeLFucA5RdP9ozZgtQloFwMRyXLkGbCjUegELT8zQMT2xPcwxesRvIN2tHIXKtmu0/7KSWxdklmg+GJ1y1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 02:02:59PM -0400, Tamir Duberstein wrote:
> On Mon, Aug 11, 2025 at 10:35 AM Beata Michalska
> <beata.michalska@arm.com> wrote:
> >
> > On Mon, Aug 11, 2025 at 09:09:56AM -0400, Tamir Duberstein wrote:
> > > On Mon, Aug 11, 2025 at 8:57 AM Beata Michalska <beata.michalska@arm.com> wrote:
> > > >
> > > > Hi Tamir,
> > > >
> > > > Apologies for such a late drop.
> > >
> > > Hi Beata, no worries, thanks for your review.
> > >
> > > >
> > > > On Sun, Jul 13, 2025 at 08:05:49AM -0400, Tamir Duberstein wrote:
> > [snip] ...
> > > > > +/// A reserved slot in an array.
> > > > > +///
> > > > > +/// The slot is released when the reservation goes out of scope.
> > > > > +///
> > > > > +/// Note that the array lock *must not* be held when the reservation is filled or dropped as this
> > > > > +/// will lead to deadlock. [`Reservation::fill_locked`] and [`Reservation::release_locked`] can be
> > > > > +/// used in context where the array lock is held.
> > > > > +#[must_use = "the reservation is released immediately when the reservation is unused"]
> > > > > +pub struct Reservation<'a, T: ForeignOwnable> {
> > > > > +    xa: &'a XArray<T>,
> > > > > +    index: usize,
> > > > > +}
> > > > > +
> > [snip] ...
> > > > > +
> > > > > +impl<T: ForeignOwnable> Drop for Reservation<'_, T> {
> > > > > +    fn drop(&mut self) {
> > > > > +        // NB: Errors here are possible since `Guard::store` does not honor reservations.
> > > > > +        let _: Result = self.release_inner(None);
> > > > This seems bit risky as one can drop the reservation while still holding the
> > > > lock?
> > >
> > > Yes, that's true. The only way to avoid it would be to make the
> > > reservation borrowed from the guard, but that would exclude usage
> > > patterns where the caller wants to reserve and fulfill in different
> > > critical sections.
> > >
> > > Do you have a specific suggestion?
> > I guess we could try with locked vs unlocked `Reservation' types, which would
> > have different Drop implementations, and providing a way to convert locked into
> > unlocked. Just thinking out loud, so no, nothing specific here.
> > At very least we could add 'rust_helper_spin_assert_is_held() ?'
> 
> I don't see how having two types of reservations would help.
> 
> Can you help me understand how you'd use `rust_helper_spin_assert_is_held` here?

Probably smth like:

--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -188,7 +188,12 @@ fn with_guard<F, U>(&self, guard: Option<&mut Guard<'_, T>>, f: F) -> U
         F: FnOnce(&mut Guard<'_, T>) -> U,
     {
         match guard {
-            None => f(&mut self.lock()),
+            None => {
+                unsafe {
+                    bindings::spin_assert_not_held(&(*self.xa.get()).xa_lock as *const _ as *mut _);
+                }
+                f(&mut self.lock())
+            }
             Some(guard) => {
                 assert_eq!(guard.xa.xa.get(), self.xa.get());
                 f(guard)

but that requires adding the helper for 'lockdep_assert_not_held'.
That said, it is already too late as we will hit deadlock anyway.
I would have to ponder on that one a bit more to come up with smth more sensible.
> 
> > >
> > > > > +    }
> > > > >  }
> > > > >
> > > > >  // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
> > > > > @@ -282,3 +617,136 @@ unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
> > > > >  // SAFETY: `XArray<T>` serialises the interior mutability it provides so it is `Sync` iff `T` is
> > > > >  // `Send`.
> > > > >  unsafe impl<T: ForeignOwnable + Send> Sync for XArray<T> {}
> > > > > +
> > > > > +#[macros::kunit_tests(rust_xarray_kunit)]
> > > > > +mod tests {
> > > > > +    use super::*;
> > > > > +    use pin_init::stack_pin_init;
> > > > > +
> > > > > +    fn new_kbox<T>(value: T) -> Result<KBox<T>> {
> > > > > +        KBox::new(value, GFP_KERNEL).map_err(Into::into)
> > > > I believe this should be GFP_ATOMIC as it is being called while holding the xa
> > > > lock.
> > >
> > > I'm not sure what you mean - this function can be called in any
> > > context, and besides: it is test-only code.
> > Actually it cannot: allocations using GFP_KERNEL can sleep so should not be
> > called from atomic context, which is what is happening in the test cases.
> 
> I see. There are no threads involved in these tests, so I think it is
> just fine to sleep with this particular lock held. Can you help me
> understand why this is incorrect?
Well, you won't probably see any issues with your tests, but that just seems
like a bad practice to start with.
Within the test, this is being called while in atomic context, and this simply
violates the rule of not sleeping while holding a spinlock.
The sleep might be triggered by memory reclaim which might kick in when using
'GFP_KERNEL' flag. Which is why non-sleeping allocation should be used through
'GFP_ATOMIC' or 'GFP_NOWAIT'. So it's either changing the flag or moving the
allocation outside of the atomic section.


---
I will be off for next week so apologies in any delays in replying.

BR
Beata
> 
> >
> > ---
> > BR
> > Beata
> > >
> > > >
> > > > Otherwise:
> > > >
> > > > Tested-By: Beata Michalska <beata.michalska@arm.com>
> > >
> > > Thanks!
> > > Tamir
> > >
> > > >
> > > > ---
> > > > BR
> > > > Beata
> > > > > +    }
> > > > > +
> > > > > +    #[test]
> > > > > +    fn test_alloc_kind_alloc() -> Result {
> > > > > +        test_alloc_kind(AllocKind::Alloc, 0)
> > > > > +    }
> > > > > +
> > > > > +    #[test]
> > > > > +    fn test_alloc_kind_alloc1() -> Result {
> > > > > +        test_alloc_kind(AllocKind::Alloc1, 1)
> > > > > +    }
> > > > > +
> > > > > +    fn test_alloc_kind(kind: AllocKind, expected_index: usize) -> Result {
> > > > > +        stack_pin_init!(let xa = XArray::new(kind));
> > > > > +        let mut guard = xa.lock();
> > > > > +
> > > > > +        let reservation = guard.reserve_limit(.., GFP_KERNEL)?;
> > > > > +        assert_eq!(reservation.index(), expected_index);
> > > > > +        reservation.release_locked(&mut guard)?;
> > > > > +
> > > > > +        let insertion = guard.insert_limit(.., new_kbox(0x1337)?, GFP_KERNEL);
> > > > > +        assert!(insertion.is_ok());
> > > > > +        let insertion_index = insertion.unwrap();
> > > > > +        assert_eq!(insertion_index, expected_index);
> > > > > +
> > > > > +        Ok(())
> > > > > +    }
> > > > > +
> > > > > +    #[test]
> > > > > +    fn test_insert_and_reserve_interaction() -> Result {
> > > > > +        const IDX: usize = 0x1337;
> > > > > +
> > > > > +        fn insert<T: ForeignOwnable>(
> > > > > +            guard: &mut Guard<'_, T>,
> > > > > +            value: T,
> > > > > +        ) -> Result<(), StoreError<T>> {
> > > > > +            guard.insert(IDX, value, GFP_KERNEL)
> > > > > +        }
> > > > > +
> > > > > +        fn reserve<'a, T: ForeignOwnable>(guard: &mut Guard<'a, T>) -> Result<Reservation<'a, T>> {
> > > > > +            guard.reserve(IDX, GFP_KERNEL)
> > > > > +        }
> > > > > +
> > > > > +        #[track_caller]
> > > > > +        fn check_not_vacant<'a>(guard: &mut Guard<'a, KBox<usize>>) -> Result {
> > > > > +            // Insertion fails.
> > > > > +            {
> > > > > +                let beef = new_kbox(0xbeef)?;
> > > > > +                let ret = insert(guard, beef);
> > > > > +                assert!(ret.is_err());
> > > > > +                let StoreError { error, value } = ret.unwrap_err();
> > > > > +                assert_eq!(error, EBUSY);
> > > > > +                assert_eq!(*value, 0xbeef);
> > > > > +            }
> > > > > +
> > > > > +            // Reservation fails.
> > > > > +            {
> > > > > +                let ret = reserve(guard);
> > > > > +                assert!(ret.is_err());
> > > > > +                assert_eq!(ret.unwrap_err(), EBUSY);
> > > > > +            }
> > > > > +
> > > > > +            Ok(())
> > > > > +        }
> > > > > +
> > > > > +        stack_pin_init!(let xa = XArray::new(Default::default()));
> > > > > +        let mut guard = xa.lock();
> > > > > +
> > > > > +        // Vacant.
> > > > > +        assert_eq!(guard.get(IDX), None);
> > > > > +
> > > > > +        // Reservation succeeds.
> > > > > +        let reservation = {
> > > > > +            let ret = reserve(&mut guard);
> > > > > +            assert!(ret.is_ok());
> > > > > +            ret.unwrap()
> > > > > +        };
> > > > > +
> > > > > +        // Reserved presents as vacant.
> > > > > +        assert_eq!(guard.get(IDX), None);
> > > > > +
> > > > > +        check_not_vacant(&mut guard)?;
> > > > > +
> > > > > +        // Release reservation.
> > > > > +        {
> > > > > +            let ret = reservation.release_locked(&mut guard);
> > > > > +            assert!(ret.is_ok());
> > > > > +            let () = ret.unwrap();
> > > > > +        }
> > > > > +
> > > > > +        // Vacant again.
> > > > > +        assert_eq!(guard.get(IDX), None);
> > > > > +
> > > > > +        // Insert succeeds.
> > > > > +        {
> > > > > +            let dead = new_kbox(0xdead)?;
> > > > > +            let ret = insert(&mut guard, dead);
> > > > > +            assert!(ret.is_ok());
> > > > > +            let () = ret.unwrap();
> > > > > +        }
> > > > > +
> > > > > +        check_not_vacant(&mut guard)?;
> > > > > +
> > > > > +        // Remove.
> > > > > +        assert_eq!(guard.remove(IDX).as_deref(), Some(&0xdead));
> > > > > +
> > > > > +        // Reserve and fill.
> > > > > +        {
> > > > > +            let beef = new_kbox(0xbeef)?;
> > > > > +            let ret = reserve(&mut guard);
> > > > > +            assert!(ret.is_ok());
> > > > > +            let reservation = ret.unwrap();
> > > > > +            let ret = reservation.fill_locked(&mut guard, beef);
> > > > > +            assert!(ret.is_ok());
> > > > > +            let () = ret.unwrap();
> > > > > +        };
> > > > > +
> > > > > +        check_not_vacant(&mut guard)?;
> > > > > +
> > > > > +        // Remove.
> > > > > +        assert_eq!(guard.remove(IDX).as_deref(), Some(&0xbeef));
> > > > > +
> > > > > +        Ok(())
> > > > > +    }
> > > > > +}
> > > > >
> > > > > --
> > > > > 2.50.1
> > > > >
> > > > >
> > >

