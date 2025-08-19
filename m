Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40E2CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9EA6B009E; Tue, 19 Aug 2025 13:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1CC6B00A0; Tue, 19 Aug 2025 13:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70ED96B00A1; Tue, 19 Aug 2025 13:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 620446B009E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:08:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B9531A0180
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:08:25 +0000 (UTC)
X-FDA: 83794140570.01.BC19F56
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1BE4E1C000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:08:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=XjbU2AhZ;
	spf=pass (imf18.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755623303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZuWypb9o6TWzJDYuIS9Mm8KX6jmMLg2t8BrCr8mAis=;
	b=f4ydZBh5RcFhn7mkwh9YToymAzwyNXclknFULQ78t0C9Qx8zFrj9xtTvZ1vaWHQP+nz6Iw
	EAN1vmIf9Xb9pRPF7LpV3MkwDtvB3hVRAtYBMCcctZpUmEtqQbQpjuEusuPlrMH9TWgXXR
	3RjzIqVNQcGQeFKkdqzn74N8gvGaRZ8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=XjbU2AhZ;
	spf=pass (imf18.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755623303; a=rsa-sha256;
	cv=pass;
	b=4d8cMZl8F0SiZhaMH4vTIXH93lzNNzQSNTW5CarrXiLs8oRwm+nvTVPUdo8g+85S8hQTKb
	JPZVQxi6voKZ7uhnNpl7lGk3C19wvzWOdgmcw9y5XyBWTkD1PBV5SYoJXX6m/tAjwJWMoK
	6+lDs7gMb8QvccmYF9aqNY7XuHeBLmo=
ARC-Seal: i=1; a=rsa-sha256; t=1755623279; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bj6v7CpUIl7GsgxzqQpEFZBdPMTV9r5q6ZoKYNMG/rJPYDEvjztZyDVXbRWp2nkmp6p6Tqo4x/ZfS18KahEWW875A6bw897bsmj9kkQ8KSSSa/wwz0lfR1gsDXU3lXaVyQ9kfZvFUqfL++UPqDAfURHwKSwf2rC0Hy3dAvMldV4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755623279; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XZuWypb9o6TWzJDYuIS9Mm8KX6jmMLg2t8BrCr8mAis=; 
	b=FZVv1TnAGoqJ5mbGR93om+IEd3MMzpacgtgFmXw18P5a59U/1zzJCWfDoUERA2EheX0ShD6C2wvDF9LyvGJJe1RVturkGP8iNz/B06x7AT615XkJ4Btjlc7VTTct9q4Kmahg4lYYE3nzC569H4H/2ArsAOByWWLIR9dh4rJBADQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755623279;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=XZuWypb9o6TWzJDYuIS9Mm8KX6jmMLg2t8BrCr8mAis=;
	b=XjbU2AhZAmCaeiA6MP6w3oAOsToUXnu/d3OAdCZoP3ftxvFvaUgJmlDBOph4VbbJ
	RfQfkXc1iwyFqMCKbSgPBxz7Le+lW1cZClqvQ/4Sk/TukgCOwwRNU/Dp1FrwLoo5PLL
	JT4iW3aX7g/qg10Ht966VWbjPmnIUncdDox3QKjY=
Received: by mx.zohomail.com with SMTPS id 1755623276764350.2469431796113;
	Tue, 19 Aug 2025 10:07:56 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v2 3/5] rust: maple_tree: add MapleTree::lock() and load()
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250819-maple-tree-v2-3-229b48657bab@google.com>
Date: Tue, 19 Aug 2025 14:07:40 -0300
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
Message-Id: <38B2DEA2-774D-45B5-8923-C5330B975FB9@collabora.com>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-3-229b48657bab@google.com>
To: Alice Ryhl <aliceryhl@google.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 1BE4E1C000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e1wb7hp5hgq57n9jwiuh87pmewbkzt46
X-HE-Tag: 1755623302-5536
X-HE-Meta: U2FsdGVkX18NFPexH5Kxv2aagcq7a/FlQpuSo4J954q8bti9vGc3l9lx4P7minHCutv36lZCKoSQ+Yh05P+msIgx0ZfVaAneu4bP6BSVmXyVxfYD/B6o0lc3DoKIics4ja4enpWwPz2IC6db94L/RM2+EZtRuE9a9MBqHCEp3sMPKFD9VHKyryE5isYxk/KAaRpdgeH5mzm8mnYb8IWZndyiNusDTmxH7adwM5H/7sLFOWx4LIGySURst5f4J+otPemKE6DG2zs/ZzZH8suUq2TfzQaX380ncgSraGsefPzodLV2DWVeeENs90fX9NkiWpxqQLo32EPITjpv2E9qAyMAwsKyjhBxkUiixjSS1REEKbsDCqDWCkz3NKrVWtvLM8Rzy/PXk2ckYUIWriT2UGRASSRT4TstGlsmcd9g9mEjEudhiVlwyULgfqj8oOnkmqXmnUAcjmkGLlv5B7JpEYAOeQOqNM1zL+S8XjCOt5jlW0latFMdSdjYbpxt4h2J6CScELEqSL4bIntBZ25yS2KtLyUPrdSzni0TMsYAaFnJIa5mMUTE+jxTm9Zf2qhD461RM4HMDnDxKYv8Jk6PUihVrXC8ccm9FjL9oyZRLSrVVTzfdJPKngqn6Biw+VDMPoMa+PceTHbYFG3BUtCVbrfYwncBClzcizjXUZ5u5Ntp0baJfgZQz24+/VrJ1TH+mqCIMU/UlkyQAf+SS4iqfynLF786Wfy4aZCBY0dAidT1B4y06Bo/q28KYUB8jo7fxzEiD0sP5lkSXVBBN3DtZv3v90/hHKu2UbM2khXv5y3wpFsnWrYmNRTvklDy37H2EfdRoJz3eio1CCRHcfikNkprdT+zPePA7APBuIq003X8CeJ3Nq9xRTHVeqMxX+UouewSq8/9YfUWvqgoW113vq8IfTjW57hCCd7G8ilhFhDF+ppQGe1bQiEOWIyasr+V3OFeTHM/ei29DLgQSoQ
 5fDd4nUn
 10or3KpUn5jOfztjeDis5dk5qCmjSzMRLCsX8EJJ8MQDdlTz7ZwyJkiMJSj04Lo+UZ4o4U989rvryefSiDh9+/vI9QCWjR79S6aolQmSvKJw3PupN2Ai5g4BlgcoOzFa19HBOJAYJN2mRaLEElBIRQ7xqm8wHgZJhO0hn2Mll/9R+61W+H3j+SEB9Q4XgHi/syXdYqkZ/1yxApYk58Bhsa14pLtAOZabhFGp4RH9tO4TcZSaORE3az9pQPsS11WwVGdCpgwOyZyn6OG4rS2hovPoIFbTkDfxAv8b8n1M2URORMfXkOChA2GQ3cCGYvKYf5tiSHH3QBZhqSBas9jmahPxL8TZmVjOhr0w22tCtnRM6Ukpnw5+0eM6jCbMrm4R/r1pwix371l9nV3U/YUw7T+DF7QIi1iwUzOy2NFu/GYa4TXJ9TjQgQX1ykN/N3tmEpSdAqUbP6Yl81ewwAdhnWGwHIMRo1FxcFBTCYgjPrUV0lL9aAtLfgXO2s48ctURGEYqPrxx+EnWBdSX5B29FJSXNNWjKCSA07ShCNnFrjwsURrWNTK3de3GPj1NHo8HqqfphPq6GwHJBN3w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

Overall LGTM, a few comments below,

> On 19 Aug 2025, at 07:34, Alice Ryhl <aliceryhl@google.com> wrote:
>=20
> To load a value, one must be careful to hold the lock while accessing
> it. To enable this, we add a lock() method so that you can perform
> operations on the value before the spinlock is released.
>=20
> This adds a MapleGuard type without using the existing SpinLock type.
> This ensures that the MapleGuard type is not unnecessarily large, and
> that it is easy to swap out the type of lock in case the C maple tree =
is
> changed to use a different kind of lock.
>=20
> Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> Reviewed-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> rust/kernel/maple_tree.rs | 139 =
++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 139 insertions(+)
>=20
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index =
ea1bd694213b73108732aecc36da95342aeafe04..17e4d8586ebad56aee87a97befdfec57=
41f147de 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -220,6 +220,22 @@ pub fn erase(&self, index: usize) -> Option<T> {
>         unsafe { T::try_from_foreign(ret) }
>     }
>=20
> +    /// Lock the internal spinlock.
> +    #[inline]
> +    pub fn lock(&self) -> MapleGuard<'_, T> {
> +        // SAFETY: It's safe to lock the spinlock in a maple tree.
> +        unsafe { bindings::spin_lock(self.ma_lock()) };
> +
> +        // INVARIANT: We just took the spinlock.
> +        MapleGuard(self)
> +    }
> +
> +    #[inline]
> +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> +        // SAFETY: This pointer offset operation stays in-bounds.
> +        unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock =
}
> +    }
> +
>     /// Free all `T` instances in this tree.
>     ///
>     /// # Safety
> @@ -263,6 +279,91 @@ fn drop(mut self: Pin<&mut Self>) {
>     }
> }
>=20
> +/// A reference to a [`MapleTree`] that owns the inner lock.
> +///
> +/// # Invariants
> +///
> +/// This guard owns the inner spinlock.
> +#[must_use =3D "if unused, the lock will be immediately unlocked"]
> +pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
> +
> +impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {
> +    #[inline]
> +    fn drop(&mut self) {
> +        // SAFETY: By the type invariants, we hold this spinlock.
> +        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
> +    }
> +}
> +
> +impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {
> +    /// Create a [`MaState`] protected by this lock guard.
> +    pub fn ma_state(&mut self, first: usize, end: usize) -> =
MaState<'_, T> {
> +        // SAFETY: The `MaState` borrows this `MapleGuard`, so it can =
also borrow the `MapleGuard`s
> +        // read/write permissions to the maple tree.
> +        unsafe { MaState::new_raw(self.0, first, end) }
> +    }
> +
> +    /// Load the value at the given index.
> +    ///
> +    /// # Examples
> +    ///
> +    /// Read the value while holding the spinlock.
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> +    ///
> +    /// let tree =3D KBox::pin_init(MapleTree::<KBox<i32>>::new(), =
GFP_KERNEL)?;
> +    ///
> +    /// let ten =3D KBox::new(10, GFP_KERNEL)?;
> +    /// let twenty =3D KBox::new(20, GFP_KERNEL)?;
> +    /// tree.insert(100, ten, GFP_KERNEL)?;
> +    /// tree.insert(200, twenty, GFP_KERNEL)?;
> +    ///
> +    /// let mut lock =3D tree.lock();
> +    /// assert_eq!(lock.load(100), Some(&mut 10));
> +    /// assert_eq!(lock.load(200), Some(&mut 20));
> +    /// assert_eq!(lock.load(300), None);
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    ///
> +    /// Increment refcount while holding spinlock and read =
afterwards.
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> +    /// use kernel::sync::Arc;
> +    ///
> +    /// let tree =3D KBox::pin_init(MapleTree::<Arc<i32>>::new(), =
GFP_KERNEL)?;
> +    ///
> +    /// let ten =3D Arc::new(10, GFP_KERNEL)?;
> +    /// let twenty =3D Arc::new(20, GFP_KERNEL)?;
> +    /// tree.insert(100, ten, GFP_KERNEL)?;
> +    /// tree.insert(200, twenty, GFP_KERNEL)?;
> +    ///
> +    /// // Briefly take the lock to increment the refcount.
> +    /// let value =3D Arc::from(tree.lock().load(100).unwrap());
> +    ///
> +    /// // At this point, another thread might remove the value.
> +    /// tree.erase(100);
> +    ///
> +    /// // But we can still access it because we took a refcount.
> +    /// assert_eq!(*value, 10);
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    #[inline]
> +    pub fn load(&mut self, index: usize) -> =
Option<T::BorrowedMut<'_>> {
> +        // SAFETY: `self.tree` contains a valid maple tree.
> +        let ret =3D unsafe { bindings::mtree_load(self.0.tree.get(), =
index) };
> +        if ret.is_null() {
> +            return None;
> +        }
> +
> +        // SAFETY: If the pointer is not null, then it references a =
valid instance of `T`. It is
> +        // safe to borrow the instance mutably because the signature =
of this function enforces that
> +        // the mutable borrow is not used after the spinlock is =
dropped.
> +        Some(unsafe { T::borrow_mut(ret) })
> +    }
> +}
> +
> impl<'tree, T: ForeignOwnable> MaState<'tree, T> {
>     /// Initialize a new `MaState` with the given tree.
>     ///
> @@ -303,6 +404,44 @@ fn mas_find_raw(&mut self, max: usize) -> *mut =
c_void {
>         // to the tree.
>         unsafe { bindings::mas_find(self.as_raw(), max) }
>     }
> +
> +    /// Find the next entry in the maple tree.

This is not in the commit title.

> +    ///
> +    /// # Examples
> +    ///
> +    /// Iterate the maple tree.
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> +    /// use kernel::sync::Arc;
> +    ///
> +    /// let tree =3D KBox::pin_init(MapleTree::<Arc<i32>>::new(), =
GFP_KERNEL)?;
> +    ///
> +    /// let ten =3D Arc::new(10, GFP_KERNEL)?;
> +    /// let twenty =3D Arc::new(20, GFP_KERNEL)?;
> +    /// tree.insert(100, ten, GFP_KERNEL)?;
> +    /// tree.insert(200, twenty, GFP_KERNEL)?;
> +    ///
> +    /// let mut ma_lock =3D tree.lock();
> +    /// let mut iter =3D ma_lock.ma_state(0, usize::MAX);
> +    ///
> +    /// assert_eq!(*iter.mas_find(usize::MAX).unwrap(), 10);
> +    /// assert_eq!(*iter.mas_find(usize::MAX).unwrap(), 20);
> +    /// assert!(iter.mas_find(usize::MAX).is_none());
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    #[inline]
> +    pub fn mas_find(&mut self, max: usize) -> =
Option<T::BorrowedMut<'_>> {

Should we drop the =E2=80=9Cmas=E2=80=9D prefix here? I think that =
=E2=80=9Cfind()=E2=80=9D is fine.

> +        let ret =3D self.mas_find_raw(max);
> +        if ret.is_null() {
> +            return None;
> +        }
> +
> +        // SAFETY: If the pointer is not null, then it references a =
valid instance of `T`. It's
> +        // safe to access it mutably as the returned reference =
borrows this `MaState`, and the
> +        // `MaState` has read/write access to the maple tree.
> +        Some(unsafe { T::borrow_mut(ret) })
> +    }
> }
>=20
> /// Error type for failure to insert a new value.
>=20
> --=20
> 2.51.0.rc1.167.g924127e9c0-goog
>=20
>=20


