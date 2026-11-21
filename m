Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA6D606A338
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4cOQVAC
Received: by kanga.kvack.org (Postfix)
	id EDAF46B05B2; Sat, 21 Nov 2026 08:12:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64736B05B3; Sat, 21 Nov 2026 08:12:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05476B05B4; Sat, 21 Nov 2026 08:12:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A67C16B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:12:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DC36120478
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:12:28 +0000 (UTC)
X-FDA: 85459165176.29.46E7B01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B98C8000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:12:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4cOQVAC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795266746;
	b=ZSfKPPD07raM/ZX6GMrrDVTTg4LUBzI4rwjJlNOHxc5v79JuSFWqzVEriJ9MJLRGLN+0Xf
	P/kB66CLL6d8mX+Fz7hA7ZgFBEkT3Zi605Z9aXpBpuFJ/HDQcxtRjPUnr37bxlpq1uSvJC
	ZgBXtOysn1nNvafKrLtWVKwGJxq4JGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795266746;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tG2O8lcKA0krtpsXmpzXhy24XJSH8+i5P+aN1LNdUAw=;
	b=EwKzyZPapJMz2XNtJBRP96jeXBBWIznTJRmfLz14mNS0aCDGy9683/Lwu6EDef+39mHETT
	WLC2G8WvrVNYTsJrchon0GP9cmsNEJzi52pnHD3D1yNKU45SHmVYeK6doRw+6r/qfjwHh9
	+T/Jgy+/ocC1jlLsaJI/9lDgY96EGp8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4cOQVAC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC2A245C27;
	Sat, 21 Nov 2026 13:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807941F000D0;
	Sat, 21 Nov 2026 13:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795266745;
	bh=tG2O8lcKA0krtpsXmpzXhy24XJSH8+i5P+aN1LNdUAw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M4cOQVACo2JzYdSPRGw92krIaTaw9UdSalhdGYDevjTyugPYTow5ENHfpq2+hugoM
	 VwCP6JnrmZ3MxM03QJmhFI3M6/7a4//NxzYtQSL44FbGIx4B5Lzqn5rgYd1DyExUOc
	 D33JDbZ6i3Ph2jA9lbSX828FejHqgTbKBjba0cOoIfTx8oIdYXUPibn0FX+i1lO1nQ
	 IqUToJzDxp7goNtZBBfnZDSwnqI7dsmrnR4qcYN734QLWIVMMSGXlnaUieLE8jwKOV
	 IcYTUy+FoXlcFG9FRM8QfPfDLmZyrJzI5jnlhY1MEIDmwNsT+nFIsovMFQSb2BTKIH
	 XXzYWqnVOSrVA==
Message-ID: <sashiko-outbox-227048@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/12] rust: mm: add abstractions for allocating from
 a `sheaf`
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Tamir Duberstein" <tamird@kernel.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Matthew Wilcox" <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org
In-Reply-To: <20261120-xarray-entry-send-v6-8-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
 <20261120-xarray-entry-send-v6-8-1f69d7385f70@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 13:12:24 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B98C8000B
X-Rspam-User:
X-Stat-Signature: ayerm6puzo99jmsy9ef9t9g1erpr3yyi
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795266746-37603
X-HE-Meta: U2FsdGVkX184djjZU+6ACEJhX+SRC9QQmNNzu2cgXy69CHgfJPsKRWL7twF6McqWpzSVAK0cUVZhQyAIZfMei5IH5B6pZW3k1xiYhCP/yOEyeVM9M84y1bi+CXEBdJ0ih+wRmxljTEVu1VdTxN92xrX8WokVXDdVKJa5nbWFlb/umKLPmvvJWZro9cFe0TFQxhJJxx40ZdnOZrsehLqZb2glEEsl6srbwaluALWQMEYEsrhn88TcDZz7r9qGbBDNQMAdfCU/vujw7/PjqHIK6OvDXh5TSjH87WVyP81krrkb2w3D+tVvARAmG7oA+Na0Wasjxk9npDVSiS/HBiD7XdYSSQA0c52FUq7mwRwtT/L+Y/ONleifsXQcoamaFlGzCd/Jm6dHK2GLe9/D7vsV8PJTfwDU6cM5oesADh1QTF2uUabWlXICFJ1y/q06En8hfsD90ITVB12ZwXY/1sDlkKUlGtzEnpQt/gQj8dovDZftN5UxiExmgK5mhIUFrABxxO3bOUmzT6d6r9er86ZdoVCm1DmD0XB8r5tpCGjFGnZnW1Si8Y2tYR1d5oLN92LAR5vE1VOjWiFUChIId/XQ62DmADigKVbCAheGJExLTP6Ksj+nMsUOTSokZsjM0TDYbRXybTz5PNr6EGyv/vx9yLCqR38lMKsvj2lrBZXmayyayyjrtDtgVvPTTWZCWSO0uvNRj4hSi+8RNmbtwx+/d84sBjF2k+ip0lKDisfOxDGiXKd4G04EqijTiIZEmRc8ig+canviMHjgNgRVfnZTEyHOQTr5iFzRR8d2pOUDbk7x06Yb6AUQE9FIgbWHTX7KLUl4G0B1AH/PIlzpjq8O1CzNi0SFAlD7FPp3Z47kcxqsYyKeSiKOoFNPFqFinNwOzBkYY1s+LyyiS869n+EocnL4NUEtoi2V1AYPkjytqn9Y7+f3YgY+kIXeuc9yd6TVTu+mynM3TuKR8D/wdiN
 +wmaVeLs
 GUyVy/UXFcct0ciBiOrDTaHP8lEA7rHeGbjdjOwoS08cDeLTQ6o7eb49AD4boXyN8fvbTNcRKgjU3aHIYlJtque0k9B1kDeViOZePfJNTPpaBPqcEzbF2wfzxlZa3Of+e+tpjN+hJzSZz3LRJqV9OYWUgQRR21ZPKuKWipzFsNFRyQsRehMlQKGJNI0uZMRgFbvRfP+K9w7F6brRESbTybhdq/nmjqv+N49OCCKg4IcFkIshaStgip6LeR60fR8M+2uM7mNCFEoB5UNFmDPpL4rsqO8gsDRU+WlW+C8rKGl82+tMtEQyrL8deY4AGuA9gVIu6CcIpiDAIHm+FBfuKnWUBNsqD4lLlld76OkvVLX2VTzD23/kWcsc37WPWri1p3Tfc1vj0tGLeUCyUyX0uY0YS41ULGR2fZddjv1/xoIuuFjPKb16ZFzoERxupXnXtq1xd3kCz8Gye5OoeGQLBqwzrLXDvfwVsPuLuDVRoHMgIDPEtCU6VWbg0IiOJezdQh/jyz0glZaWhKq5V0/F4e0eDG1b6rDNtkYkLEoLn7i82uAVyLt0q+dyluVKIDMs7wGWt2H+ybS0R5vCE5VTsk3Gd9aglEqJRhZzrY56IJVVwYKbXXmP3Tog/geJl5i7pcWeMsq/ckE2qZhbiK/VHh4/oMk63Ibl5Q/pVdWZXIgUj/SzGEQhPLujnChrZ10BgbW1S0aFx6qNft4uv4vLbVLCNPggASXMUkbNShricjcj0C9lgEZTgUB7jLs0BcLAasLirco946MZan04g2vFgE30gQ3zdAxIsMi+Vn3RR9tQNXg2OheaQINxDKhzwTV8Mn6VV
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
- [Medium] rust: mm: Sheaf::alloc() bypasses alloc_hooks() by calling
  _noprof directly
- [Low] rust: mm: missing #[inline] on small C-forwarding methods in
  sheaf.rs
- [Low] rust: mm: imports in sheaf.rs do not follow kernel vertical
  import style
- [Low] rust: mm: direct call to internal PinInit::__init() in
  Sheaf::alloc()
--

commit 5e97f4874e1bec1246089d6fb000afa8148da652
Author: Andreas Hindborg <a.hindborg@kernel.org>

rust: mm: add abstractions for allocating from a `sheaf`

This commit adds Rust abstractions (KMemCache, KMemCacheInit, Sheaf, and
SBox) for pre-allocating and allocating slab objects using SLUB sheaves.

> diff --git a/rust/kernel/mm/sheaf.rs b/rust/kernel/mm/sheaf.rs
> new file mode 100644
> index 0000000000000..1bc0c3dca900f
> --- /dev/null
> +++ b/rust/kernel/mm/sheaf.rs
> @@ -0,0 +1,483 @@

[ ... ]

> +use core::{
> +    convert::Infallible,
> +    marker::PhantomData,
> +    ops::{Deref, DerefMut},
> +    ptr::NonNull,
> +};
> +
> +use kernel::prelude::*;
> +
> +use crate::sync::{Arc, ArcBorrow};

[Severity: Low]
These imports group multiple items on one line instead of using the kernel
vertical import style from Documentation/rust/coding-guidelines.rst (one it=
em
per line with a trailing // comment).

[ ... ]

> +impl<T: KMemCacheInit<T>> Drop for KMemCache<T> {
> +    fn drop(&mut self) {
> +        // SAFETY: `self.as_raw()` returns a valid cache pointer that was
> +        // created by `__kmem_cache_create_args`. As all objects allocat=
ed from
> +        // this hold a reference on `self`, they must have been dropped =
for this
> +        // `drop` method to execute.
> +        unsafe { bindings::kmem_cache_destroy(self.as_raw()) };
> +    }
> +}

[Severity: Low]
KMemCache::drop(), Sheaf::alloc(), Sheaf::drop(), and SBox::drop() are small
functions in the kernel crate that forward directly to C bindings, so they
should be marked #[inline].

[ ... ]

> +    pub fn alloc(&mut self) -> Option<SBox<T>> {
> +        // SAFETY: `self.cache.as_raw()` and `self.as_raw()` return valid
> +        // pointers. The function returns NULL when the sheaf is empty.
> +        let ptr =3D unsafe {
> +            bindings::kmem_cache_alloc_from_sheaf_noprof(self.cache.as_r=
aw(), 0, self.as_raw())
> +        };

[Severity: Medium]
Does calling kmem_cache_alloc_from_sheaf_noprof() directly bypass
alloc_hooks() and leave current->alloc_tag unset when
CONFIG_MEM_ALLOC_PROFILING is enabled?

In C, kmem_cache_alloc_from_sheaf() is a macro wrapping
kmem_cache_alloc_from_sheaf_noprof() in alloc_hooks() to set
current->alloc_tag before slab_post_alloc_hook() runs
__alloc_tagging_slab_alloc_hook():

mm/slub.c:__alloc_tagging_slab_alloc_hook() {
	...
	if (likely(obj_exts)) {
		...
		alloc_tag_add(ref, current->alloc_tag, s->size);
		put_slab_obj_exts(obj_exts);
	} else {
		if (!is_kfence_address(object))
			alloc_tag_set_inaccurate(current->alloc_tag);
	}
}

With current->alloc_tag left NULL, CONFIG_MEM_ALLOC_PROFILING_DEBUG triggers
WARN_ONCE() in alloc_tag_add_check() on allocation and in
alloc_tag_sub_check() on free, and if prepare_slab_obj_exts_hook() fails to
allocate obj_exts under memory pressure, alloc_tag_set_inaccurate()
dereferences NULL current->alloc_tag. Wrapping the
kmem_cache_alloc_from_sheaf() macro in a __rust_helper in
rust/helpers/slab.c would preserve the profiling hooks.

> +
> +        let ptr =3D NonNull::new(ptr.cast::<T>())?;
> +
> +        // SAFETY:
> +        // - `ptr` is a valid, non-null pointer as it was just returned =
by the
> +        //   cache.
> +        // - The initializer is infallible, so an error is never returne=
d.
> +        unsafe { T::init().__init(ptr.as_ptr()) }.expect("Initializer is=
 infallible");

[Severity: Low]
PinInit::__init() is an internal trait method not meant to be called
directly. Following commit ea7da3116015 ("rust: treewide: replace
__pinned_init with raw_[try_]init"), could this use
pin_init::raw_init(ptr.as_ptr(), T::init()) instead, which also avoids the
expect()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-xarray-ent=
ry-send-v6-0-1f69d7385f70@kernel.org?part=3D8

