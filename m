Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93EC1606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GIx75u40
Received: by kanga.kvack.org (Postfix)
	id A767B6B0621; Wed, 18 Nov 2026 18:36:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A007A6B0624; Wed, 18 Nov 2026 18:36:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8E76B064C; Wed, 18 Nov 2026 18:36:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1E66B0621
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:36:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C14E04036F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:36:26 +0000 (UTC)
X-FDA: 85449851172.09.A151AE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2D4CE40004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:36:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIx75u40;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795044985;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjLsSOIr/siE9vLyjj3T/fA9dZiVI79ryqI5Nemwx54=;
	b=pTXsPCk5oY19+s6gtv2SjpUsFmEW45xLnzvYvGSiWR9YmmrGgr0gJTbNzxljb/ADVoXRIg
	j3X0ECQ7+j/DoPoGe2MUIBZQ6XruYmbzpK08yj3l2Qav9N7NMa2NQ+yQZJd/2OnTWr5v64
	Tga+Sjzu90tDFXuHeR5U6EX15GrT/R0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIx75u40;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795044985;
	b=YBxkZO7u43eXdTPnxJlkhtpnZXIczzOQBzxjmYYM3YEAIwmTjtSR/XLUyQedYaWW7thuzD
	VfiJmjXaMP6MSUWZGif716uEIvJknPfp4MzQudKTals9psOuEt88bTYsZbn+X2ODnTYcqq
	hKCzoB9kp1WyUzNROkw/gSOqoTXU7TY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6390F642A4;
	Wed, 18 Nov 2026 23:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365001F000C5;
	Wed, 18 Nov 2026 23:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044984;
	bh=sjLsSOIr/siE9vLyjj3T/fA9dZiVI79ryqI5Nemwx54=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GIx75u40SfLIQwWO1iWzxAaZAkG0rf2WJVME0NmRNLAatm2WKza4wNWnysDWQ7Nax
	 ZgcLEyojahD1UBDofhxAWJ8szVz+PIWEvsDh0rL4+2mNi4F7Os9bumdaEdlXPLHV8e
	 q7KoBYW6cjUJuJaD9pZsiDY1pq6m69Uilp2V4MkIGswN2u3bqPW0UvE1tkZ7qTESOE
	 aaJY+vfaDiYKembC50ptn0ImWKPcz/Yj2ah+Evj9TYKCULIKX80pFTTG8cJVF3G65V
	 lvp+Ht9CqnKkVNsZjW/iPdeRH4MLJZbxEPhpnk2nvGOX15hTqatelDwSuw2cm/RxJY
	 yLEs7UqoM/1Zg==
Message-ID: <sashiko-outbox-222196@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] rust: block: add bio segment iteration and request
 accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vitaly Wool" <vitaly.wool@konsulko.se>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Jens
 Axboe" <axboe@kernel.dk>, "Miguel Ojeda" <ojeda@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>
Cc: "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir
 Duberstein" <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R . Howlett" <liam@infradead.org>, linux-mm@kvack.org, "Igor B" <igor.b@beldev.am>
In-Reply-To: <20261117233211.3137168-2-vitaly.wool@konsulko.se>
References: <20261117233211.3137168-1-vitaly.wool@konsulko.se>
 <20261117233211.3137168-2-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:36:22 +0000
X-Stat-Signature: h3johd5765q7kscxyw5czeqk9g6zii9d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D4CE40004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795044985-898695
X-HE-Meta: U2FsdGVkX1/Z/2fgb2AKiy2aIozCalGwYwnE/WFK6/7eT6+d212XcNGre0dTb0sz0PkGyAqGnMcgLjkMQ8HcNZ/3dhYa1NUv8+jf60uEmaxM9mnOyEIWvoM3//ZdSOY0+IACsBKXM0enM+nplYbm50aAoajo8kV4ZKwzjjMR6RsKF2tfndomNT3faFnIjZ/wF/SILh4X1TGIxNi4hBDMa8id4OEXb7EFhtFnNYxKLGxRYe78IXjKP+NE/Zn4tkTOYkjUlBFbdSelrieVXDE8yFosc/gREl7rzESoYYmHZDUOjFqRF6Ic//2hmCqvXP1nvoCyvUTjngZSvkOK8RlE4fJbP/dDytDHS2YPb99EMVYpG++FulRQsjrjUwb7DMsMWeQNNMMmD+1kFt6uh5guMyqs0sc9hy7xDlzRb3HF6dxpUXjWZNuMlRdPjYK1+IH89BmRsixlTgH6nWGZzc1LAAMLmqS2ZLwRqz8t3447QkkUVsVHIcskRxyOgS9wQZK82E7fS5F0rvQCEBxHJCwV76M1j7W9E1iIcHcczSRd/mkTH2vNmhLcgAIcRYAPQ3T0O8uYliXM0tOjfYMHn+A5V1PaWQJZl7lxMa894PIFQXbbU/v9wKgv6RLaiZdU8Sl/KsRmKzWymuylc8RmK0K9Hj+xhEjQO9cEZEgx7uW2ygqwg3KY2HEIqkYTA1oOsCjblDgjKZVfqmcGlvtzVm+6oq7QbPh36NDd1ZihziX4BFnRBQo9fuqlI9QYImZKMwIZ7bqNW5eedeh095/ChGSkES0lfJ05gYAI1kgET2AkMNut9nBtbyuspH+0PlLygwySpjlwuV6J/BNzIG24oYq+bg/rOoU3CynrpZajPzcLVWz0+x5JPOsx0gD2xg2BWLPCljmJlIq9OxRiWWbCOg9KBsYttr9FpRjcyfpsfkoAFWAnqtBKxair4+SaSnsvoHxf4lDpRadm3sStK/mIlgQ
 UjgxL+N9
 Bvt+DDzoIyE8/vj7w5NO2+kT0cd/tuPwK8iOqjdwu2Z6NRBmNc66zS2AiK4gtHDk7DhpI7CG2LDrEVg2zfjEm7UqicFNGlAFbdHWOAfpmseMYkFcVXDAvxP8yuZ1YYV5VRA8nLdtKLiu/N7cAljpTPKkjgHxlof4W9f18jG+Qtx94UHZrvvLmp/44bWb94ShA9Voo9NzLp83LhpiSuB5ZDtHijHJSynctNl9nGPBdwxf+wwyvoZonbM1JJcLYGo1uOEB2LVatIIkYf/SODHXwFDoWjl/SEBWiZikVunod1kUpP0JWGDbu4MxlInut5sxBEJ8587o2xkZZU3wypD2s7CfbxzdETYg8iRnjw9VTE7TuOy/BmF0NO8yY48wwbn1KCMb+mD169UA/ROZE2zKmXK3p37LVUFWgMkLGLvlHWpvpQr2EjNq507UjkYCp5g0TlrzYYk/D5lxTDsXr83iEeAgM+ah49UbLLyfedI5xE0XDVNYaqvGTsKn+pM4EZDfJog98w9RmUPM9G8FPlVvZJA+AF6gELHyCOHsdpAQRkBDwj4vCWUa7jCfHG6JdAcEys1Ga
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] rust: block: NULL bi_io_vec dereference in
  SegmentIter::next()
- [Medium] rust: block: unsound safe Segment::zero() and copy_*_page()
  safety docs
- [Low] rust: block: wrong default block size in discard_granularity()
  docs
- [Low] rust: block: missing #[inline] and Bio::from_raw() INVARIANT
  comment
--

commit f73d6ca145fdbea749b64ff55a7ec48747dee38e
Author: Igor B <igor.b@beldev.am>

rust: block: add bio segment iteration and request accessors

This commit adds a Rust bio wrapper and segment iterator, request
accessors for command, sector, byte length, and bios, and GenDiskBuilder
helpers for configuring discard limits.

> diff --git a/rust/kernel/block/bio.rs b/rust/kernel/block/bio.rs
> new file mode 100644
> index 0000000000000..183f9ae6d48d9
> --- /dev/null
> +++ b/rust/kernel/block/bio.rs
> @@ -0,0 +1,253 @@

[ ... ]

> +/// A wrapper around a C [`struct bio`].
> +///
> +/// # Invariants
> +///
> +/// `self.0` is a valid `struct bio` that is part of a request owned by =
the
> +/// driver. Neither the bio nor its data pages are released while a `&Bi=
o` is
> +/// alive.
> +///
> +/// [`struct bio`]: srctree/include/linux/blk_types.h
> +#[repr(transparent)]
> +pub struct Bio(Opaque<bindings::bio>);
> +
> +impl Bio {
> +    /// Create a reference to a [`Bio`] from a raw pointer.
> +    ///
> +    /// # Safety
> +    ///
> +    /// `ptr` must point to a valid `struct bio` that stays valid, and i=
s not
> +    /// modified by anyone but the holder of the returned reference, for=
 the
> +    /// duration of `'a`.
> +    pub(crate) unsafe fn from_raw<'a>(ptr: *mut bindings::bio) -> &'a Se=
lf {
> +        // SAFETY: `Bio` is `repr(transparent)` over `bindings::bio`, an=
d the
> +        // safety requirements of this function make the reference valid.
> +        unsafe { &*ptr.cast::<Self>() }
> +    }

[Severity: Low]
Since struct Bio has an # Invariants section, Bio::from_raw() should have
an // INVARIANT: comment explaining how the caller's safety guarantees
satisfy those invariants.

Also, in the kernel crate abstractions, small functions and functions that
forward to C bindings should be marked #[inline]; none of the new methods in
rust/kernel/block/bio.rs, rust/kernel/block/mq/gen_disk.rs, or
rust/kernel/block/mq/request.rs have #[inline].

[ ... ]

> +    /// Return an iterator over the single-page segments of this bio.
> +    ///
> +    /// This is the equivalent of the C `bio_for_each_segment()` macro.
> +    pub fn segment_iter(&self) -> SegmentIter<'_> {
> +        SegmentIter {
> +            bio: self,
> +            // SAFETY: By the type invariant `self.raw()` is valid.
> +            iter: unsafe { (*self.raw()).bi_iter },
> +        }
> +    }

[ ... ]

> +impl<'a> Iterator for SegmentIter<'a> {
> +    type Item =3D Segment<'a>;
> +
> +    fn next(&mut self) -> Option<Segment<'a>> {
> +        if self.iter.bi_size =3D=3D 0 {
> +            return None;
> +        }
> +
> +        let sector =3D self.iter.bi_sector;
> +
> +        // SAFETY: By the type invariant of `Bio`, `self.bio.raw()` is v=
alid,
> +        // and `self.iter` is a copy of its `bi_iter` that was only adva=
nced
> +        // through `bio_advance_iter_single`, so it is within bounds.
> +        let bvec =3D unsafe { bindings::bio_iter_iovec(self.bio.raw(), &=
self.iter) };

[Severity: Medium]
Can calling Bio::segment_iter() in safe Rust cause a NULL pointer
dereference in SegmentIter::next() on a discard or write-zeroes request?

In block/blk-lib.c, bios for REQ_OP_DISCARD, REQ_OP_WRITE_ZEROES, and
REQ_OP_SECURE_ERASE are allocated with nr_vecs =3D 0, which sets
bio->bi_io_vec =3D NULL while setting bio->bi_iter.bi_size to the non-zero
byte length of the operation (and REQ_DMABUF bios store bi_dmabuf_map in
the union with bi_io_vec).  Because Request::bio_iter() and
Bio::segment_iter() are safe functions and neither checks bio_has_data()
or !bio_no_advance_iter(), iterating segments of such a bio calls
bio_iter_iovec() with bi_size > 0 and dereferences a NULL (or non-bvec)
bi_io_vec pointer.

[ ... ]

> +    /// Copy `len` bytes starting at byte `off` of this segment into `ds=
t`
> +    /// starting at `dst_off`.
> +    ///
> +    /// Returns [`EINVAL`] if either range is out of bounds.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that this call does not race with a read =
or
> +    /// write of the same range of `dst`.
> +    pub unsafe fn copy_to_page(
> +        &self,
> +        off: usize,
> +        dst: &Page,
> +        dst_off: usize,
> +        len: usize,
> +    ) -> Result {
> +        self.with_mapped(off, len, |src| {
> +            // SAFETY: `src` is valid for reading `len` bytes, and the c=
aller
> +            // guarantees there is no racing access to `dst`.
> +            unsafe { dst.write_raw(src, dst_off, len) }
> +        })
> +    }
> +
> +    /// Copy `len` bytes from `src` starting at `src_off` into this segm=
ent
> +    /// starting at byte `off`.
> +    ///
> +    /// Returns [`EINVAL`] if either range is out of bounds.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that this call does not race with a write=
 to the
> +    /// same range of `src`.
> +    pub unsafe fn copy_from_page(
> +        &self,
> +        off: usize,
> +        src: &Page,
> +        src_off: usize,
> +        len: usize,
> +    ) -> Result {
> +        self.with_mapped(off, len, |dst| {
> +            // SAFETY: `dst` is valid for writing `len` bytes. The data =
buffer
> +            // of the bio is owned by the driver while the request is in
> +            // flight. The caller guarantees there is no racing write to=
 `src`.
> +            unsafe { src.read_raw(dst, src_off, len) }
> +        })
> +    }
> +
> +    /// Fill `len` bytes starting at byte `off` of this segment with zer=
oes.
> +    ///
> +    /// Returns [`EINVAL`] if the range is out of bounds.
> +    pub fn zero(&self, off: usize, len: usize) -> Result {
> +        self.with_mapped(off, len, |dst| {
> +            // SAFETY: `dst` is valid for writing `len` bytes. The data =
buffer
> +            // of the bio is owned by the driver while the request is in
> +            // flight.
> +            unsafe { ptr::write_bytes(dst, 0, len) };
> +            Ok(())
> +        })
> +    }
> +}

[Severity: Medium]
Is Segment::zero(&self, ...) sound as a safe method, and are the safety
contracts on copy_to_page() and copy_from_page() complete?

Request<T> implements Send, Sync, and AlwaysRefCounted, and
Request::bio_iter(), Bio::segment_iter(), and Segment::zero() all take
&self.  Two threads holding shared &Request<T> references (or a bio with
multiple bvecs referencing the same page) can call Segment::zero()
concurrently from safe Rust, causing a data race.  Moreover, on
REQ_OP_WRITE bios the segment pages are read-only source buffers that can
point to shared kernel pages such as largest_zero_folio() in
__blkdev_issue_zero_pages(), so writing to them via Segment::zero() or
Segment::copy_from_page() corrupts shared memory.

Segment::zero() should be unsafe (matching Page::fill_zero_raw()), and the
safety requirements for zero(), copy_from_page(), and copy_to_page()
should also require that no concurrent accesses race on the segment's own
page range and that mutating methods are only called on writable request
buffers.

> diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_=
disk.rs
> index 0fe640f3aec63..57d5431654303 100644
> --- a/rust/kernel/block/mq/gen_disk.rs
> +++ b/rust/kernel/block/mq/gen_disk.rs

[ ... ]

> @@ -106,6 +110,25 @@ pub fn capacity_sectors(mut self, capacity: u64) -> =
Self {
>          self
>      }
> =20
> +    /// Set the maximum number of sectors (512 bytes) the device can dis=
card in
> +    /// a single request.
> +    ///
> +    /// Zero, the default, means that the device does not support discar=
d.
> +    pub fn max_hw_discard_sectors(mut self, sectors: u32) -> Self {
> +        self.max_hw_discard_sectors =3D sectors;
> +        self
> +    }
> +
> +    /// Set the discard granularity of the device in bytes.
> +    ///
> +    /// This is the internal allocation unit of the device. Discards sma=
ller
> +    /// than this, or not aligned to it, may not free any storage. Zero,=
 the
> +    /// default, lets the block layer use the logical block size.
> +    pub fn discard_granularity(mut self, granularity: u32) -> Self {
> +        self.discard_granularity =3D granularity;
> +        self
> +    }

[Severity: Low]
Does a discard_granularity of zero default to the logical block size or
the physical block size?

In block/blk-settings.c, blk_validate_limits() clamps
lim->discard_granularity with:

    lim->discard_granularity =3D
        max(lim->discard_granularity, lim->physical_block_size);

so leaving discard_granularity at zero causes the block layer to use
physical_block_size rather than logical_block_size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117233211.3137=
168-1-vitaly.wool@konsulko.se?part=3D1

