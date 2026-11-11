Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18631606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JUsFOj7g
Received: by kanga.kvack.org (Postfix)
	id 3CFBF6B05B0; Wed, 11 Nov 2026 09:46:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352B56B05B2; Wed, 11 Nov 2026 09:46:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4A86B05B1; Wed, 11 Nov 2026 09:46:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E246E6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:46:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0A041C35EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:46:34 +0000 (UTC)
X-FDA: 85423114308.07.FA8F10F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5BEBD40003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:46:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUsFOj7g;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794408393;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSdXtKdWvTrXMsVb12DWqGQH/qr+f46oTQHq9fzcLe8=;
	b=EelmHWE3K7bTrfa6yS6ZPcDVqiOFCewZIVR0/KZV3DHyyNIbphU8SaTJfGb3SW1YmMCMag
	yvImWxx1KSPWW6Rtn6fO+WCd6CNNMiNAUbrHWBleYTiMciPK6sCM6crekVJId4Q+O+nVyz
	hvaFE2t+qxfF0+2tiimxAdptxTDexgw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794408393;
	b=tEYo0rQOcKcKHvLo1wp/HCT8cO6XgI83CF3Ku8VRY834iuz27Ea0ZQ6lWXWmApzjeTqAsq
	QkN7ycAyXO0FQBkmbf8ZiF957U0W/8GNS+LTsmv+qcTQsiaM1z/2SMMZ+iuNDvM2lEV9es
	yhxkSpsg0+a00Ggx5sXZPYjSYOQ2gH4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUsFOj7g;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35D8463090;
	Wed, 11 Nov 2026 14:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0154C1F00A05;
	Wed, 11 Nov 2026 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794408391;
	bh=PSdXtKdWvTrXMsVb12DWqGQH/qr+f46oTQHq9fzcLe8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JUsFOj7gKFnXMte5Moh8g0rqEToRp9QDJzWed/YNJ82ysHGfR5yL+RJswmr6hoaj1
	 1o4KSHT5bGMQDLfFtO1/O1PyScY/PBNKeMiVMvhbQW343n7xRbZQ2qX3vDJNx/GHxe
	 LDrWXQ/k8BahR8lcKycGO8Zea7YLaTLp+//fcRmONXYbdnFO/HIJGTJaI79aEuG5dY
	 fGe2e8DDnzq3DHOr+8RjLTuJkYoIT62nUwt9V9X/9fVC1qAypUsx0HSVj0vlFdSlAp
	 ewjyeQ4d0L2i0NuXPUDQkVlJNLi9mADR61dzfezfeiJfk38r7MFvI3+3UQAhEx/6Y8
	 SWIaZ91PoAE/g==
Message-ID: <sashiko-outbox-209186@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/4] rust: io: require freedom from plain accesses
 for `SysMem`
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Will Deacon" <will@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Mark Rutland" <mark.rutland@arm.com>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>, "Alexandre
 Courbot" <acourbot@nvidia.com>, =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Lyude
 Paul" <lyude@redhat.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20261110-page-volatile-io-v5-1-a91ef252c24b@kernel.org>
References: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
 <20261110-page-volatile-io-v5-1-a91ef252c24b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 14:46:30 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 8wmqptj6a1t457ifh388zzd974jdbre9
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5BEBD40003
X-Rspam-User: 
X-HE-Tag: 1794408393-482467
X-HE-Meta: U2FsdGVkX1+mbRFwPdNKyGn0LpGrwxqf9zNYYXBntkRQYTgA+nyb3pRnMJ5avumeTzIFehA8O62J7PQtoiUve5ZEZMcAdXM/pBtC+5N2HhHJg5TuWqT00ufLsQ9xZ05dualXr04p+CBD2xwPMRfEdxUtnhUo/CbHYi/tRf1i4SPJLX1Otonm7067c+4ZgWB8HCEbsTTWiAyJwGEzK8tDms4uKVxj+HFGNpsVdANbYbM8Nmpyy08lsIp2c0oOIiblTBiJZQGt/itI4TLfGhowCyHcsxdfopMf/GtzCXWbV2xynkZbO4jM9n8IGOWzqYyIajmlxnoaUQ9/v1M1eOW2/21E3ESrhkHes4+sLs32jE+hJLzhp7qpPh2yVo9dnJ/FSi0rlKUvTmQfkEQwGdavjc8cYaVxgzMzu80Tvs/B3hZ8cvs2fO6MpWDh8FtMIZ3wkmd3p4fUznNjJLN9pdW9JEUfs1NKHBh1o41a+I5SYC+c5cdLj92L978KLwqKGVJES0dlDoMYrJQmOnQU1W5wZYIK+GAgLs4ZwyggTP03sUCMXGF3WBl27jQlCyNYW8p5bCcrBhIhCRgXOdsxk6mWrhaZAZ+buV8E1fvp+AWo/3KKyLsq//UeB2711KEqa+mqmgGq5z5F6/FxL3syEGEjg/UNWhs4olEcYmCUCsdfZyR1u7BMqgzQeV8S2hiWZ90/NtVZPSOYsbjwRDt8wy7LvS1+TaJvEOYp/Hj7StBrccEise7K0u8ca0B/AlZo0kIakYuSzO9aYst98DMIYmfD3rlDDtyqJZGo2PuYjvKBFWXr3Ni/kLKXV9973lCGkcL9iLaYILVWdNjnG5/dGMDI04+8d1Fw1g8u6K/A95lIt7xNFeE74VsT1+DgjPBcmetyK7zXNg5jiGZ9msacYfMFZcsEVAQXai9B7exS1IIKdWNIWWZf7ABbQocI9w19OUjXjk7RtENc++lXT+vDtxQ
 5Hw85Lqg
 os4WlKBr7eDuDzbdyTqszRaQkopctqqftqdz0a5XoyFL0RXPY+aQ2g1yHFWXrGMH9tKLJDN5x423byJG6myZnUBn75COi7GXUWy3gzKk7x9gqfQM5OIztLcaocISrvUZWO+cNosypDUaxVAQ8Njpwy4dUOwst42Q8H++2NpMQ+tUl5t1KViKn13V3mdIWTCxMvds74Iphw0ybKxNTPWW7LRgszNDn6YsgEd6lmV10DTh0y/Io3CkVNLBJEyRb1GOwgrSQ5/kVX6o72NfKgB0P2SxweOngsWyLBHQUWCKCwxRRENGTSDo8qWey51QhNfFPgg62/i9tXJey82lzbmR46FHDs/vp61x/d6Xg3azYGClDiNG9isehAQs1QYA77BQc/JeHmPWJIzVYIaqeaWd8ON74kIvSjJAMIRtzAKTodSfTGroexkUa3CpEvOMeLQ+i3HQtjzR+rgMumHVa2XmrCny2zFEjMJ0q3kb6BC+KFzFjnIxLBPLCPxhDJlUl1Iecrkhp6bsT0hKarHM8gvdhi0pXYVvvkSVORmaXrCTtUUgKiLkxn1k0VTP+Ntw7CPbsnOwkOWehXGPHOvY9s5SiXGFwSQ==
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
- [Medium] rust: io: SysMem::new() no-plain-access invariant violated by
  callers
--

commit 2301a5fd31bd2665dfd4001d0e9beab25a81725b
Author: Andreas Hindborg <a.hindborg@kernel.org>

rust: io: require freedom from plain accesses for `SysMem`

This commit adds a type invariant to SysMem and a safety requirement on
SysMem::new() requiring that no plain accesses are performed to the memory
region for the lifetime of the view.

> diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
> index a877df11a03e0..3bc4be35e3554 100644
> --- a/rust/kernel/io.rs
> +++ b/rust/kernel/io.rs
[ ... ]
> @@ -1570,8 +1582,10 @@ impl<'a, T: ?Sized> SysMem<'a, T> {
>      ///
>      /// # Safety
>      ///
> -    /// `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be valid =
and aligned kernel
> -    /// accessible memory region for the lifetime `'a`.
> +    /// - `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be vali=
d and aligned kernel
> +    ///   accessible memory region for the lifetime `'a`.
> +    /// - No plain access (see [`SysMem`]) to that memory region may be =
performed for the lifetime
> +    ///   `'a`.
>      #[inline]
>      pub unsafe fn new(ptr: *mut T) -> Self {
>          // INVARIANT: Per safety requirement.

[Severity: Medium]
Does this new SysMem<'a, T> invariant conflict with the existing
SysMem::new() callers in Coherent and VMap?

In rust/kernel/dma.rs, <&'a Coherent<'_, T> as IoBase<'a>>::as_view() is a
safe method that wraps the buffer in SysMem<'a, T> inside CoherentView<'a, =
T>,
while CoherentView::as_ref() and CoherentView::as_mut() hand out &'a T and
&'a mut T references for plain accesses over the same lifetime 'a:

rust/kernel/dma.rs:CoherentView::as_ref() {
    pub unsafe fn as_ref(self) -> &'a T {
        // SAFETY: pointer is aligned and valid per type invariant. Aliasin=
g rule is satisfied per
        // safety requirement.
        unsafe { &*self.cpu_addr.as_ptr() }
    }
}

rust/kernel/dma.rs:<&'a Coherent<'_, T> as IoBase<'a>>::as_view() {
    fn as_view(self) -> CoherentView<'a, Self::Target> {
        CoherentView {
            // SAFETY: `cpu_addr` is valid and aligned kernel accessible me=
mory.
            cpu_addr: unsafe { SysMem::new(self.cpu_addr.as_ptr()) },
            dma_addr: self.dma_addr,
        }
    }
}

Any plain read or write through those references during 'a violates the
SysMem<'a, T> invariant even when no concurrent access occurs.  Similarly,
<&'a VMap<D, R, SIZE> as IoBase<'a>>::as_view() in
rust/kernel/drm/gem/shmem.rs calls SysMem::new() without VMap's invariants =
or
its SAFETY comment guaranteeing that no plain accesses occur during 'a.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-page-volat=
ile-io-v5-0-a91ef252c24b@kernel.org?part=3D1

