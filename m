Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CE1CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E868E0015; Tue, 19 Aug 2025 13:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA828E0005; Tue, 19 Aug 2025 13:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C258E0015; Tue, 19 Aug 2025 13:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3FEF8E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:27:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F434C0140
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:27:02 +0000 (UTC)
X-FDA: 83794187484.19.A1BA124
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4143A180002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:27:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=CTwX9Kel;
	spf=pass (imf24.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755624420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8H1AUhw82rUJaLdt3KIbuTGoRdsNV4lrOzkPBNCmH6I=;
	b=IUcVyaej+PTkLAY6n6SP5bb7uos7zlpJpVk4YPWVP2gPf0JhY6NR70kpTFsHdv2SGKiI/y
	LVKLaVV5+IL4P/gIx66opTBrCyBf7+6rWJp4/TfLXP7GRaBQaXAjhhIi63FiE1yEyaC0XB
	KsQn9n3tiCqgnkAS51byJ9S8msEgyn4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755624420; a=rsa-sha256;
	cv=pass;
	b=lGkHjkIZQUA2CCjvy2sDiOCR2OLhypZbXleX+NknVEjEqIYyO3pvpC3oDepzklND6N041x
	jOYKKyidoKcXBivBiNWhmHna4YhBMPOgRwuumw1tAn6T7GMTyM9oPNHeoqDKZvwwiUgZ9w
	1r+Q5GSuiy5ZGOu3eFaeZWspV4F8KoU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=CTwX9Kel;
	spf=pass (imf24.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1755624405; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=S3IN3aAcDmZSX5XOn9zI9nGzhg0I/Q6/Ek2j0VqeNO90wCJwgLI/8Kmf1fbhM8NinSd7H7tpxeW4Ox5GI4tCNaZFyZCjvd8YSkY3/UWoDrwKFO2k2KMej1R9sxA1xke1dxiZxwMq7N6KOZwyg0VYwqNKp2lRKASf1TS1ZOn/QhM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755624405; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=8H1AUhw82rUJaLdt3KIbuTGoRdsNV4lrOzkPBNCmH6I=; 
	b=Z459QXTRQXKo9OCgocRgUVLzuf5jrme69cqD5Rt9dZKS0U+0jsG5cIKVetM0yDzC2dG7q3olhwIRfqplAhDB8tAGCZYqA0rixlspOs/U6JqMvgCsXh+NHIsnkLPjrbLZsVMPp/xDA08NGhr6z/MdtWfjysjm8nHO0Ttg0WILO5s=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755624404;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=8H1AUhw82rUJaLdt3KIbuTGoRdsNV4lrOzkPBNCmH6I=;
	b=CTwX9KelRwjpfOCA9ymNYTj688Rs3a3fGi5JrdcbKu5QN8OOnUk188KPa86dEeAG
	fF6+YEEMeAtWqvxN7ajveOZzxuKpeA9gWqismV6vBq2cFNhYct44BsAz+5qSO6jLw4r
	Om79WYA+LJgDsZ3qxgFt85KxNUsMxdUuWMiMrmIY=
Received: by mx.zohomail.com with SMTPS id 1755624402429375.09727788227974;
	Tue, 19 Aug 2025 10:26:42 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v2 4/5] rust: maple_tree: add MapleTreeAlloc
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250819-maple-tree-v2-4-229b48657bab@google.com>
Date: Tue, 19 Aug 2025 14:26:25 -0300
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Andrew Ballance <andrewjballance@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D5983002-4D45-4C39-BA70-9A7A7A7D0FB4@collabora.com>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-4-229b48657bab@google.com>
To: Alice Ryhl <aliceryhl@google.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4143A180002
X-Stat-Signature: kswzgrgsbezrxcjbcrribn4w443i5pjw
X-HE-Tag: 1755624420-893537
X-HE-Meta: U2FsdGVkX1+8Ezfs0FZdzcRpjfKpTIwrhZZifMWhdDyeYNLFKwjYX5DvthFFXp22nuBeJfn8ZeckzCyr0DQpimvxZ9GKWNQpR9pvVAzU9NoSNaKsRId+9ikN2KecLW2pZQeFLaFeFXH0GP+HEDttOIBeEnRu/MVZX45OH9B9clhAx0ArBW9ssavcXN0KnivxC/2JfheSNNHgx/EkmvYQRAV+6C5Tv2IbCRTBwHI2x0oDLlX4/tdP6xuNZ5hIroEndKl+bctMsmLFmvBv9VEHqd5zwV3/nybvnN4LaLIVMlA4yNceg4ToNPIKQda2X6mj3GJAo1oaCi6oZKcqctp3itmgfKhkGMgowKmUOQzWQ73Cy4a07SEJhOGZEW+GpBOxoeGPoYCL5lFA7u86ZnMMmSCoz42iMIwhq9d0YPxpnBwVII9JDKO74UNPd/hlJf830Rc4SkJ/B7GtrFvb9Gw4c50YP6hLlxpdvS/hY3S0TTv96okNjGIJfcLdkY6r0VAl4uDYfS20t9R8i0fAkzASVMfCUSBoOOoLH60BqYfXUtSSBEr5NVaEEvL9jbY++klMCT3A1FOwRZ++jm5RsZqzhDLDy2J/snX1m3vCrux0/sfsZid99pkJbVyLRyeoLPlnZsCfzIMcMY4Elcpi8+9JFKXqHunxxEqNHV3Pg+8fJIXjkS8STQD947U0h6u8D2UZ0RLIpvRpKI7TbQhWnTdz5MYwGkOfBZILIsFvCmznj7+aTBUXEo73Mqe+nPJtMzMem0zqKChVKQUHrUqaZA4k4H54aRGv0k4C3ijr48rLCNhSPpOhy4i322QK3OG/OkFYyxy10iIyUsuimJQimBZbemtfyBjtfiRtlHuTu4a5Aw3ec+cIKr61Qu5sTyUut4e7nhV8qwmHYPec9+p2EVQuE5+gwlKw8BSYTXYQf3drb+NZzPMqCFNxghresDggnTu3cq2n5iFHbQgkXprut47
 sJQoqK3H
 5sLwdjUbMToeWYqmCkNB4crpCd3Sw0882e7LcmcKRUad8SYd0/Kr541wrKVpov8VKE1/4Km1fBJ1cdaGwiDa6b3b67cWr4gO8C3EM7KeetcKM3iW8Xyz5l6075oQ6luE+H6rurqivPGlMb6RBF8rFlgsA1/YsjMzaH5H0p3XSBeNTDwCy5vsJGEafnv/3Be14mlia9cin5F6W2txwDFWF7NIbViMVcwkz/k1aFM472eA0AOAbNYdPSaTPSR6EcihQmdCG0hvbRLH/7Pg99gvbaVPGfm9Ukr4zp/8HBmvssgj9Lukyuy4qD2gYBCIprDaSJyXoZzMezIrk4/S3JRtUobe2CfJ3drGqxAMd2j+wC8fN+wrO4xivBCZcgUZIT79xLn3Q3JmxQZSSE/fvjXYRdvhrXNsLtaYgI2Md3TTKHWYzqmyzZ+2JVLCxG/x4FCRExw05wcog3FxkjLQKgnjx9XEtMuwhfMooR5VoB9L+SiYAllyaZnzd1JXLwOIlsOP2cs9vn74FP2pBwCq0avhuaKiNEZLQzL4wa3bgJ8LlfX6tXyWDsJaZ+4gBfvtqsYLmH2CRt7qP1D/oxtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 19 Aug 2025, at 07:34, Alice Ryhl <aliceryhl@google.com> wrote:
>=20
> To support allocation trees, we introduce a new type MapleTreeAlloc =
for
> the case where the tree is created using MT_FLAGS_ALLOC_RANGE. To =
ensure
> that you can only call mtree_alloc_range on an allocation tree, we
> restrict thta method to the new MapleTreeAlloc type. However, all
> methods on MapleTree remain accessible to MapleTreeAlloc as allocation
> trees can use the other methods without issues.
>=20
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> rust/kernel/maple_tree.rs | 158 =
++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 158 insertions(+)
>=20
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index =
17e4d8586ebad56aee87a97befdfec5741f147de..1a32960e6e721ca32ca45d8bb63fcffe=
deae3424 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -33,6 +33,26 @@ pub struct MapleTree<T: ForeignOwnable> {
>     _p: PhantomData<T>,
> }
>=20
> +/// A maple tree with `MT_FLAGS_ALLOC_RANGE` set.
> +///
> +/// All methods on [`MapleTree`] are also accessible on this type.
> +#[pin_data]
> +#[repr(transparent)]
> +pub struct MapleTreeAlloc<T: ForeignOwnable> {
> +    #[pin]
> +    tree: MapleTree<T>,
> +}
> +
> +// Make MapleTree methods usable on MapleTreeAlloc.
> +impl<T: ForeignOwnable> core::ops::Deref for MapleTreeAlloc<T> {
> +    type Target =3D MapleTree<T>;
> +
> +    #[inline]
> +    fn deref(&self) -> &MapleTree<T> {
> +        &self.tree
> +    }
> +}
> +
> /// A helper type used for navigating a [`MapleTree`].
> ///
> /// # Invariants
> @@ -364,6 +384,107 @@ pub fn load(&mut self, index: usize) -> =
Option<T::BorrowedMut<'_>> {
>     }
> }
>=20
> +impl<T: ForeignOwnable> MapleTreeAlloc<T> {
> +    /// Create a new allocation tree.
> +    pub fn new() -> impl PinInit<Self> {
> +        let tree =3D pin_init!(MapleTree {
> +            // SAFETY: This initializes a maple tree into a pinned =
slot. The maple tree will be
> +            // destroyed in Drop before the memory location becomes =
invalid.
> +            tree <- Opaque::ffi_init(|slot| unsafe {
> +                bindings::mt_init_flags(slot, =
bindings::MT_FLAGS_ALLOC_RANGE)
> +            }),
> +            _p: PhantomData,
> +        });
> +
> +        pin_init!(MapleTreeAlloc { tree <- tree })
> +    }
> +
> +    /// Insert an entry with the given size somewhere in the given =
range.
> +    ///
> +    /// The maple tree will search for a location in the given range =
where there is space to insert
> +    /// the new range. If there is not enough available space, then =
an error will be returned.
> +    ///
> +    /// The index of the new range is returned.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTreeAlloc, AllocErrorKind};
> +    ///
> +    /// let tree =3D =
KBox::pin_init(MapleTreeAlloc::<KBox<i32>>::new(), GFP_KERNEL)?;
> +    ///
> +    /// let ten =3D KBox::new(10, GFP_KERNEL)?;
> +    /// let twenty =3D KBox::new(20, GFP_KERNEL)?;
> +    /// let thirty =3D KBox::new(30, GFP_KERNEL)?;
> +    /// let hundred =3D KBox::new(100, GFP_KERNEL)?;
> +    ///
> +    /// // Allocate three ranges.
> +    /// let idx1 =3D tree.alloc_range(100, ten, ..1000, GFP_KERNEL)?;
> +    /// let idx2 =3D tree.alloc_range(100, twenty, ..1000, =
GFP_KERNEL)?;
> +    /// let idx3 =3D tree.alloc_range(100, thirty, ..1000, =
GFP_KERNEL)?;
> +    ///
> +    /// assert_eq!(idx1, 0);
> +    /// assert_eq!(idx2, 100);
> +    /// assert_eq!(idx3, 200);
> +    ///
> +    /// // This will fail because the remaining space is too small.
> +    /// assert_eq!(
> +    ///     tree.alloc_range(800, hundred, ..1000, =
GFP_KERNEL).unwrap_err().cause,
> +    ///     AllocErrorKind::Busy,
> +    /// );
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    pub fn alloc_range<R>(
> +        &self,
> +        size: usize,
> +        value: T,
> +        range: R,
> +        gfp: Flags,
> +    ) -> Result<usize, AllocError<T>>
> +    where
> +        R: RangeBounds<usize>,
> +    {
> +        let Some((min, max)) =3D to_maple_range(range) else {

Ok, I see that the returned range can mean multiple things, depending on
context. Fine, you can disregard my previous comment about this =
function.

> +            return Err(AllocError {
> +                value,
> +                cause: AllocErrorKind::InvalidRequest,
> +            });
> +        };
> +
> +        let ptr =3D T::into_foreign(value);
> +        let mut index =3D 0;
> +
> +        // SAFETY: The tree is valid, and we are passing a pointer to =
an owned instance of `T`.
> +        let res =3D to_result(unsafe {
> +            bindings::mtree_alloc_range(
> +                self.tree.tree.get(),
> +                &mut index,
> +                ptr,
> +                size,
> +                min,
> +                max,
> +                gfp.as_raw(),
> +            )
> +        });
> +
> +        if let Err(err) =3D res {
> +            // SAFETY: As `mtree_alloc_range` failed, it is safe to =
take back ownership.
> +            let value =3D unsafe { T::from_foreign(ptr) };
> +
> +            let cause =3D if err =3D=3D ENOMEM {
> +                AllocErrorKind::AllocError(kernel::alloc::AllocError)
> +            } else if err =3D=3D EBUSY {
> +                AllocErrorKind::Busy
> +            } else {
> +                AllocErrorKind::InvalidRequest
> +            };
> +            Err(AllocError { value, cause })
> +        } else {
> +            Ok(index)
> +        }
> +    }
> +}
> +
> impl<'tree, T: ForeignOwnable> MaState<'tree, T> {
>     /// Initialize a new `MaState` with the given tree.
>     ///
> @@ -480,3 +601,40 @@ fn from(insert_err: InsertError<T>) -> Error {
>         Error::from(insert_err.cause)
>     }
> }
> +
> +/// Error type for failure to insert a new value.
> +pub struct AllocError<T> {
> +    /// The value that could not be inserted.
> +    pub value: T,
> +    /// The reason for the failure to insert.
> +    pub cause: AllocErrorKind,
> +}
> +
> +/// The reason for the failure to insert.
> +#[derive(PartialEq, Eq, Copy, Clone)]
> +pub enum AllocErrorKind {
> +    /// There is not enough space for the requested allocation.
> +    Busy,
> +    /// Failure to allocate memory.
> +    AllocError(kernel::alloc::AllocError),
> +    /// The insertion request was invalid.
> +    InvalidRequest,
> +}
> +
> +impl From<AllocErrorKind> for Error {
> +    #[inline]
> +    fn from(kind: AllocErrorKind) -> Error {
> +        match kind {
> +            AllocErrorKind::Busy =3D> EBUSY,
> +            AllocErrorKind::AllocError(kernel::alloc::AllocError) =3D> =
ENOMEM,
> +            AllocErrorKind::InvalidRequest =3D> EINVAL,
> +        }
> +    }
> +}
> +
> +impl<T> From<AllocError<T>> for Error {
> +    #[inline]
> +    fn from(insert_err: AllocError<T>) -> Error {
> +        Error::from(insert_err.cause)
> +    }
> +}
>=20
> --=20
> 2.51.0.rc1.167.g924127e9c0-goog
>=20
>=20

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>


