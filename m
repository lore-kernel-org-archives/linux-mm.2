Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1D1C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4388E005E; Mon, 11 Aug 2025 10:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB9E8E0045; Mon, 11 Aug 2025 10:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1098C8E005E; Mon, 11 Aug 2025 10:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F05AB8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:35:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C05971DAD27
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:35:02 +0000 (UTC)
X-FDA: 83764723644.07.355027A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A829740013
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:35:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of beata.michalska@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=beata.michalska@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754922901; a=rsa-sha256;
	cv=none;
	b=P1hViihNjHLJ+iZbsN1N71FhB1I1nFhZlIMCO61q7+D0Gebkcv7bzrP2csmk0D6GFCLXKf
	SFMLV19FyHAZfVstvKfDUvZDr5v1VO9xnSvITU5psyrdBMCtFNqZKKgYHtq0OY2cfZVk7s
	JI7eG1QNRAopq8LWagCHuTvPTtG4XiA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of beata.michalska@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=beata.michalska@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754922901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y8yQGpGfxuflpSRic+ndq33kEZWVTin02G3FKBnZ6Nw=;
	b=ZfAEekpNNizROMUtuvTAbOkBjFjl3b+TU1gKQzoMaqsoWI9CvJ8CRNPh2svV8UDbsbqtW7
	cuzdF1/VIJe+lPyscdaYgwaWDEVTeOduMtxKH+3l1Z3EBL7OyGj8IIHfpJPUXAIc+jqXal
	3wJnIRcChWm4s3Sx7y99k5Sfsm+XTT8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BBC52641;
	Mon, 11 Aug 2025 07:34:51 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 602813F738;
	Mon, 11 Aug 2025 07:34:53 -0700 (PDT)
Date: Mon, 11 Aug 2025 16:34:30 +0200
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
Message-ID: <aJn_dtWDcoscYpgV@arm.com>
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <20250713-xarray-insert-reserve-v2-3-b939645808a2@gmail.com>
 <aJnojv8AWj2isnit@arm.com>
 <CAJ-ks9=BU2jfT-MPzxDcXrZj7uQkKbVm6WhzGiJsM_628b2kmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ-ks9=BU2jfT-MPzxDcXrZj7uQkKbVm6WhzGiJsM_628b2kmg@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A829740013
X-Stat-Signature: sgj6rdbun8rcobfbwtsdsxu58b84ipd9
X-HE-Tag: 1754922900-350474
X-HE-Meta: U2FsdGVkX19mu1EmOIzlrKhrZe1gMIH35aCN0lOfbabRk/oAS1VkDNbdXYXKWzlsdtarfHOuougEhoJFKmOmsPI1SwBZrXZYk5iFX3p3T4AXCHYbavE9+E31ixSb6nDS6kG8o3dP2DlNMCz7SWd/asABNJPtiquInx6khqPteOBbEiOIBm/RDFnoYBGNgVl+8Zuntm7wPDJ89X5j999IGeRag13le8K+uubngYzpvZXEY7X3gHuZo/342v2XiBEPQyokzNZ3qYEjTVpBpOGo5yJJpaimUv4O48dwW0G/VWc0H84Rn2PcvpC8cR7SrHKsOA369T/A27tbEef4anlURFAZ5FHMGkHA8NHYqDBlLixCHUxsChckGdEfBwZdKBd2iZUoMrL9K6RjTULbeYnF0DfKe5wCgDkKrJ2cDYOr8Wl71QZ9oaWSu4h6busGnCPu8d0Oj8JjoSRKi+WDz84EIiIV1nj6TnSXQXJE63mxhIxRiUNt97YxT1oYmhxUFwv1RtqUIkkmLfbZAFSMg7fuSzuKWBL0/w3AF5TA+VIm9fPXapetgFvmkTCIEJzxaHRt2TvulagYFpyCAH8b/zoQa7uuIH0s8AClpewtSDKYngt6RNvqxgxQRVN/nAaUF128AolmMBBfVq7/8zRhEgfMNqlF99I5C1Str789ctETcd1AdkXKC8MzTYn3R37rmqIpARSjr5CLqq5Q85rwP9jhnzze3+LAg9iFQvWvxoqzp89MLAAQianb+W/6+LBsOPzEUDrziugCObvbTda+wDOBcm1ChWKqdXxZ8qcY5p6rdHr504xMSZZcx4ARMNGrWCnHKb0bXlFKeD1nI6qUwoTtJqjYa4U4Cewfei5b442uDqPsOPAivJSnsvw6A1CoaImhCaOux8oLB8ms9weZWaTF5AH0N1b4hLPRIijEdoeB7SyIOz70+JCTjcj49vkub9/056Bd7uDC0qzuZDZD61O
 MGJijsUr
 ZsqhF3Q+yoRE+PbA31Oo0BM4FU1+1VGVZjXq4TyoGzIUsoOt9ID0yBCW/YAWlJJnv6gUReSswEL3glVHESNErT3ZXRtn9ZECnPvG7vzGREYDgIsDJhwykO+PvDvYHLOWusVgWCbMBd9QKZZ4G/lflUQ2mwLg2GDNWg1VUnmqWmlpjIpbA/2LPm1GGoJgLxFvHnB3mIl6a4JN6OQVGobh9NAvCE1+8Q+FlgXg2wEdqNQU7Sk4638vEuAagixliXi4i47Uo/KZ/xoxYVWocGJTK9ZHPSJ96pvYAQztBwgwS5ttn/qM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 09:09:56AM -0400, Tamir Duberstein wrote:
> On Mon, Aug 11, 2025 at 8:57 AM Beata Michalska <beata.michalska@arm.com> wrote:
> >
> > Hi Tamir,
> >
> > Apologies for such a late drop.
> 
> Hi Beata, no worries, thanks for your review.
> 
> >
> > On Sun, Jul 13, 2025 at 08:05:49AM -0400, Tamir Duberstein wrote:
[snip] ...
> > > +/// A reserved slot in an array.
> > > +///
> > > +/// The slot is released when the reservation goes out of scope.
> > > +///
> > > +/// Note that the array lock *must not* be held when the reservation is filled or dropped as this
> > > +/// will lead to deadlock. [`Reservation::fill_locked`] and [`Reservation::release_locked`] can be
> > > +/// used in context where the array lock is held.
> > > +#[must_use = "the reservation is released immediately when the reservation is unused"]
> > > +pub struct Reservation<'a, T: ForeignOwnable> {
> > > +    xa: &'a XArray<T>,
> > > +    index: usize,
> > > +}
> > > +
[snip] ...
> > > +
> > > +impl<T: ForeignOwnable> Drop for Reservation<'_, T> {
> > > +    fn drop(&mut self) {
> > > +        // NB: Errors here are possible since `Guard::store` does not honor reservations.
> > > +        let _: Result = self.release_inner(None);
> > This seems bit risky as one can drop the reservation while still holding the
> > lock?
> 
> Yes, that's true. The only way to avoid it would be to make the
> reservation borrowed from the guard, but that would exclude usage
> patterns where the caller wants to reserve and fulfill in different
> critical sections.
> 
> Do you have a specific suggestion?
I guess we could try with locked vs unlocked `Reservation' types, which would
have different Drop implementations, and providing a way to convert locked into
unlocked. Just thinking out loud, so no, nothing specific here.
At very least we could add 'rust_helper_spin_assert_is_held() ?'
>
> > > +    }
> > >  }
> > >
> > >  // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
> > > @@ -282,3 +617,136 @@ unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
> > >  // SAFETY: `XArray<T>` serialises the interior mutability it provides so it is `Sync` iff `T` is
> > >  // `Send`.
> > >  unsafe impl<T: ForeignOwnable + Send> Sync for XArray<T> {}
> > > +
> > > +#[macros::kunit_tests(rust_xarray_kunit)]
> > > +mod tests {
> > > +    use super::*;
> > > +    use pin_init::stack_pin_init;
> > > +
> > > +    fn new_kbox<T>(value: T) -> Result<KBox<T>> {
> > > +        KBox::new(value, GFP_KERNEL).map_err(Into::into)
> > I believe this should be GFP_ATOMIC as it is being called while holding the xa
> > lock.
> 
> I'm not sure what you mean - this function can be called in any
> context, and besides: it is test-only code.
Actually it cannot: allocations using GFP_KERNEL can sleep so should not be
called from atomic context, which is what is happening in the test cases.

---
BR
Beata
> 
> >
> > Otherwise:
> >
> > Tested-By: Beata Michalska <beata.michalska@arm.com>
> 
> Thanks!
> Tamir
> 
> >
> > ---
> > BR
> > Beata
> > > +    }
> > > +
> > > +    #[test]
> > > +    fn test_alloc_kind_alloc() -> Result {
> > > +        test_alloc_kind(AllocKind::Alloc, 0)
> > > +    }
> > > +
> > > +    #[test]
> > > +    fn test_alloc_kind_alloc1() -> Result {
> > > +        test_alloc_kind(AllocKind::Alloc1, 1)
> > > +    }
> > > +
> > > +    fn test_alloc_kind(kind: AllocKind, expected_index: usize) -> Result {
> > > +        stack_pin_init!(let xa = XArray::new(kind));
> > > +        let mut guard = xa.lock();
> > > +
> > > +        let reservation = guard.reserve_limit(.., GFP_KERNEL)?;
> > > +        assert_eq!(reservation.index(), expected_index);
> > > +        reservation.release_locked(&mut guard)?;
> > > +
> > > +        let insertion = guard.insert_limit(.., new_kbox(0x1337)?, GFP_KERNEL);
> > > +        assert!(insertion.is_ok());
> > > +        let insertion_index = insertion.unwrap();
> > > +        assert_eq!(insertion_index, expected_index);
> > > +
> > > +        Ok(())
> > > +    }
> > > +
> > > +    #[test]
> > > +    fn test_insert_and_reserve_interaction() -> Result {
> > > +        const IDX: usize = 0x1337;
> > > +
> > > +        fn insert<T: ForeignOwnable>(
> > > +            guard: &mut Guard<'_, T>,
> > > +            value: T,
> > > +        ) -> Result<(), StoreError<T>> {
> > > +            guard.insert(IDX, value, GFP_KERNEL)
> > > +        }
> > > +
> > > +        fn reserve<'a, T: ForeignOwnable>(guard: &mut Guard<'a, T>) -> Result<Reservation<'a, T>> {
> > > +            guard.reserve(IDX, GFP_KERNEL)
> > > +        }
> > > +
> > > +        #[track_caller]
> > > +        fn check_not_vacant<'a>(guard: &mut Guard<'a, KBox<usize>>) -> Result {
> > > +            // Insertion fails.
> > > +            {
> > > +                let beef = new_kbox(0xbeef)?;
> > > +                let ret = insert(guard, beef);
> > > +                assert!(ret.is_err());
> > > +                let StoreError { error, value } = ret.unwrap_err();
> > > +                assert_eq!(error, EBUSY);
> > > +                assert_eq!(*value, 0xbeef);
> > > +            }
> > > +
> > > +            // Reservation fails.
> > > +            {
> > > +                let ret = reserve(guard);
> > > +                assert!(ret.is_err());
> > > +                assert_eq!(ret.unwrap_err(), EBUSY);
> > > +            }
> > > +
> > > +            Ok(())
> > > +        }
> > > +
> > > +        stack_pin_init!(let xa = XArray::new(Default::default()));
> > > +        let mut guard = xa.lock();
> > > +
> > > +        // Vacant.
> > > +        assert_eq!(guard.get(IDX), None);
> > > +
> > > +        // Reservation succeeds.
> > > +        let reservation = {
> > > +            let ret = reserve(&mut guard);
> > > +            assert!(ret.is_ok());
> > > +            ret.unwrap()
> > > +        };
> > > +
> > > +        // Reserved presents as vacant.
> > > +        assert_eq!(guard.get(IDX), None);
> > > +
> > > +        check_not_vacant(&mut guard)?;
> > > +
> > > +        // Release reservation.
> > > +        {
> > > +            let ret = reservation.release_locked(&mut guard);
> > > +            assert!(ret.is_ok());
> > > +            let () = ret.unwrap();
> > > +        }
> > > +
> > > +        // Vacant again.
> > > +        assert_eq!(guard.get(IDX), None);
> > > +
> > > +        // Insert succeeds.
> > > +        {
> > > +            let dead = new_kbox(0xdead)?;
> > > +            let ret = insert(&mut guard, dead);
> > > +            assert!(ret.is_ok());
> > > +            let () = ret.unwrap();
> > > +        }
> > > +
> > > +        check_not_vacant(&mut guard)?;
> > > +
> > > +        // Remove.
> > > +        assert_eq!(guard.remove(IDX).as_deref(), Some(&0xdead));
> > > +
> > > +        // Reserve and fill.
> > > +        {
> > > +            let beef = new_kbox(0xbeef)?;
> > > +            let ret = reserve(&mut guard);
> > > +            assert!(ret.is_ok());
> > > +            let reservation = ret.unwrap();
> > > +            let ret = reservation.fill_locked(&mut guard, beef);
> > > +            assert!(ret.is_ok());
> > > +            let () = ret.unwrap();
> > > +        };
> > > +
> > > +        check_not_vacant(&mut guard)?;
> > > +
> > > +        // Remove.
> > > +        assert_eq!(guard.remove(IDX).as_deref(), Some(&0xbeef));
> > > +
> > > +        Ok(())
> > > +    }
> > > +}
> > >
> > > --
> > > 2.50.1
> > >
> > >
> 

