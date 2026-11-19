Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1215A60A2609
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bglFMkmA
Received: by kanga.kvack.org (Postfix)
	id 1FFC46B05BF; Thu, 19 Nov 2026 11:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7936B0661; Thu, 19 Nov 2026 11:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EDCF6B0675; Thu, 19 Nov 2026 11:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCF236B05BF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:20:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AE32140AA0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:20:23 +0000 (UTC)
X-FDA: 85452381126.04.3AA9D29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6904F2000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:20:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bglFMkmA;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795105221;
	b=MVon5HP5EaeyIdtTZ0cwcmEvl9pVSacCD4qMR9Hd16qCaOV1zdMBnzvBu4NHwfza6Py0cT
	jtN6RnV0UrELRVmWh/Sl708YsaMYDxTJsFyPpbxOUDq4FnKXUlYZUyuk3RcZC1IvLGNk+s
	G6hXBA+/TkEU1/iFnOo0/JdgjmQUZ3U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795105221;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zi6T2HrfKAceSD5hPDfGBVbj8J+LJ/tnGZcu78/MXaU=;
	b=cBKl5mvC24AnEhuF3xcWjMLPaR0+NGdMqgXRwDCunFQ6w4a52k4wm3L+l2R6nBLR/gDoi1
	m4loMVnX/hwZOADW+vMwQnFhPRu9YqfXf+QMSvX5phYfOpR7oFjjxcJP3kl+BGe8NGdLFi
	R1fsBG+djSbkyxFeCAiUppIDEvQtBt0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bglFMkmA;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68162423E4;
	Thu, 19 Nov 2026 16:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187371F000C5;
	Thu, 19 Nov 2026 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795105220;
	bh=Zi6T2HrfKAceSD5hPDfGBVbj8J+LJ/tnGZcu78/MXaU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bglFMkmAVxbaWd0EVSNyluMzR1LeXtiXve0N6gGtZMD2l1r5p7+nYP8jBxFkjociN
	 +EyAEsFhCTxmh7VYI+NcFJE/z4eEYkDB2Sb335ZouLcSw9jrTRZSksk55iBY6t5XTj
	 buezM301GiWoSBj2cxenjqEXzIYqX4DfI4df+NFv6ZhK//Y8FeMze+llI8Bz9yQAT4
	 c/KjjHRs/4MENTVKTG1HpaFkQvmhy5/T+FlSt79mfgVqYMCHBJKBEgJiX5KNe6A59X
	 tgHpTu706/8cJwM6uU/4pImhCC4tU7N4GMeno1nhtz5+qquqI84aAbKCUTGbQsKeYC
	 /Nom7rBEdGd5w==
Message-ID: <sashiko-outbox-223511@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v22 1/6] rust: page: add page kinds and make `Page`
 reference counted
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "David
 Hildenbrand" <david@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Mike Rapoport" <rppt@kernel.org>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Matthew
 Wilcox" <willy@infradead.org>, "Danilo Krummrich" <dakr@kernel.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir
 Duberstein" <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 =?utf-8?b?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, "Todd Kjos" <tkjos@android.com>, "Christian
 Brauner" <brauner@kernel.org>, "Carlos Llamas" <cmllamas@google.com>
Cc: "Igor B" <igor.b@beldev.am>, "Vitaly Wool" <vitaly.wool@konsulko.se>, linux-mm@kvack.org
In-Reply-To: <20261118-page-ownable-v22-1-d63ff73f4075@kernel.org>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
 <20261118-page-ownable-v22-1-d63ff73f4075@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:20:17 +0000
X-Rspam-User:
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6904F2000C
X-Stat-Signature: 1w33dy65orogkctaqz7edeixawmemt3i
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795105221-423263
X-HE-Meta: U2FsdGVkX1+EE1Rediiu/LtiCA0/KCqLVR2jCafjODiEfqBY1t5tSF46Si3y3GvZ+ZULHpSD9V+IwDEC+pjIAnvTUsuXEltqaa6POnmqn1HzkaE3O/4EpDEGmArH9vPrYq7avxFpPtdCPMonlMhxwBVmszwbAjBiTjoJqaMDORjrFx1+PtWPHwOFJDhOc0AOyVeEZVMJNNmH7wlpz4/ez3LedCynB5SZSHNVWw0o9pFV9fhzSOTkX4UF8krLpMrE+wgo2Rjul9KlRDbTFBiyiP4WggRW+vYkQqx1hp9KLBqXCK/qGHhg0UGU3wrJ4sQk0wVNyXIaQ0bCYFeazVCd//TmrfxlIA5ZHzoKXAPP1pS7x0zc5XPv6QU4V6Nqi8pdU2owsb2n6/M44S8fXE2qpcbntHpTiasUHeBxfvo5DRsODffpyR/9eonYm8jwzq5HllVKsw9vtORhufgXBd4trDd1vPtjvLPDkPYXezxdzz4/qQDqbDb4Jwhss4srB+gSXM/dFxH0qFxOAjUqQk0ZWAvvyjRujtVuzQ6+j8dRUSVm0RL7CvjW0GR3MfM1YFQjEyu3JTn94B2ESGrINSCWBflCXbI38JCoK84WPEeCQiFKvBLccSTt2bZtgysfDxJRq2LXMzma0lb3lKHI6jmI+NSyMayPxjyChH8Tto4xHTiSy8JO53FJqjgHVNLO+gafYeESIn/hpWr3gESoS550XOQfCh2kp2bYGgsSMAnR7f/UAvKsMJp+saq5Uh76GdKR6zV7O+oskQHAoCxVwX44+cs6X0JOxJ4+ahZhXdi0f6cgT/9mSh1oJbqtw2K1dGOAgqA8x6nHxkMrCVojNM/HVGElOwu9onGw9RyYMDnm3FC6dckRdnRMODcApUMKS4xRrUww/XCMAwyJqtyAo/qMWq9MAq9UZf0fRnPT40qi8qUF5vYK6ujuojnVMVz61UneVhlmwHejUoKieiBscEC
 FgoSR4IG
 w25QFVObYWKul60Sg0DLRqPEqLjWGaUbsRBzhcv8XI7ORDLpUOR0aYxY0WyEg/RuNpGt1ucK9i2S1pHmUHRzrsEtB7FKIi+ua6sv+nk9J/T43FWfgoSjgTKLWxLUgYrM87YNd5JmuGxF+lOGcwMZZYObz/SojNuc7olqhDMpw/a64qhML6aRv8jmntCuewgVbWOPF4XX0eAqvDkIUL+/Ef2u9hc1rSZ8f49CITR+XO2DEEbtw11zkTM/oBP4lXNesnnkqQKBTKw38T2/XHgqUMFbvSByqQWPp5tVehxN+7Kq5RcyIbYjGpLcDPlLX0RnPRg+f/NydKxmvSitCqDaO6hPV9cXitluVTe1dauhUX3djuYu9ZCDlmAvgaUUrNTH5zoIEJM9b+8Q71TrmYiUPosEZVDaZzS78ItBuVB57+7m47KYyVEdo1TDNYrKTpjTRgNgWrdX1oyv63ysN95e+rTTtQN3uNKER4oW2/tRPZ/uGqkLf22B7eevVXlj7LlUD5qAp3mwbGwC7zd/R2DGH6xsKwKf9HjNdb4JhEDxUVxT+mCpuv12BRlW3aMpg/xbn9XqJzBQa1Ndm9D7LxtcK8+rn0C8dmgGHtXLOAzkiQrGmeFBkqpjFRX6+7SYTNzEUoWM4uwG3n57lslcZ2BDqdfNKFZnBKdV6c4vmcHNZCZszpKQ1U8ndI8mvHlrqjzMJxh/yrGS4RYcnG2T3iC2jhHyLlTQO1QUMHB5A0efoPw4oJ2OIQpoxSRs5eju/vMexuJjUwv6IzvalfKuuRkL0S0KxnldioH+zM/PLmhe32hVf8s8E0SDDwF7O+2LFsWKoBClb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] rust: page: missing #[inline] on Vmalloc::to_page() and
  Page::as_ptr()
--

commit 36a035122eaf9c7ebb69272cab04826c581553f8
Author: Andreas Hindborg <a.hindborg@kernel.org>

rust: page: add page kinds and make `Page` reference counted

This commit makes Page generic over a sealed PageKind trait with Base and
RefCounted kinds, implements RefCounted and AlwaysRefCounted for
Page<RefCounted>, and replaces BorrowedPage with references to Page<Base>.

> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator=
.rs
> index cd4203f27aed0..bf20714156c53 100644
> --- a/rust/kernel/alloc/allocator.rs
> +++ b/rust/kernel/alloc/allocator.rs
[ ... ]
> @@ -202,20 +205,19 @@ impl Vmalloc {
>      ///
>      /// - `ptr` must be a valid pointer to a [`Vmalloc`] allocation.
>      /// - `ptr` must remain valid for the entire duration of `'a`.
> -    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> page::BorrowedPage<'a=
> {
> +    pub unsafe fn to_page<'a>(ptr: NonNull<u8>) -> &'a Page<Base> {
>          // SAFETY: `ptr` is a valid pointer to `Vmalloc` memory.
>          let page =3D unsafe { bindings::vmalloc_to_page(ptr.as_ptr().cas=
t()) };
> =20
> -        // SAFETY: `vmalloc_to_page` returns a valid pointer to a `struc=
t page` for a valid pointer
> -        // to `Vmalloc` memory.
> -        let page =3D unsafe { NonNull::new_unchecked(page) };
> -
> +        // INVARIANT: `Base` has no invariants in addition to the validi=
ty of the `struct page`,
> +        // which is argued below.
>          // SAFETY:
> -        // - `page` is a valid pointer to a `struct page`, given that by=
 the safety requirements of
> -        //   this function `ptr` is a valid pointer to a `Vmalloc` alloc=
ation.
> -        // - By the safety requirements of this function `ptr` is valid =
for the entire lifetime of
> -        //   `'a`.
> -        unsafe { page::BorrowedPage::from_raw(page) }
> +        // - `vmalloc_to_page` returns a valid, non-null pointer to a `s=
truct page` for a valid
> +        //   pointer to `Vmalloc` memory, given that by the safety requi=
rements of this function
> +        //   `ptr` is a valid pointer to a `Vmalloc` allocation.
> +        // - By the safety requirements of this function `ptr`, and henc=
e the `struct page`, is
> +        //   valid for the entire lifetime of `'a`.
> +        unsafe { &*page.cast() }
>      }
>  }
[ ... ]
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 1c0796ea229f0..b2a17c86e7de0 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
[ ... ]
> @@ -185,19 +192,22 @@ impl Page {
[ ... ]
> +impl<Kind: PageKind> Page<Kind> {
>      /// Returns a raw pointer to the page.
>      pub fn as_ptr(&self) -> *mut bindings::page {
> -        self.page.as_ptr()
> +        self.page.get()
>      }

[Severity: Low]
Should Vmalloc::to_page() and Page::as_ptr() be marked #[inline]?
Vmalloc::to_page() is a non-generic wrapper in the kernel crate that
forwards directly to bindings::vmalloc_to_page(), and Page::as_ptr() is a
one-line accessor called by #[inline] methods such as Page::nid() and
Page::inc_ref().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118-page-ownab=
le-v22-0-d63ff73f4075@kernel.org?part=3D1

