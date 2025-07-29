Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC845C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ECB36B008A; Tue, 29 Jul 2025 04:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59CD46B0092; Tue, 29 Jul 2025 04:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2526B0093; Tue, 29 Jul 2025 04:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 344666B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:25:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E9A0160531
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:25:40 +0000 (UTC)
X-FDA: 83716618440.08.093FA7D
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf26.hostedemail.com (Postfix) with ESMTP id C8CD2140002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:25:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgFv3EQl;
	spf=pass (imf26.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753777538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayHMReTRhSApabUBizHIE8nDhonkKA0wIn9XppY4bmY=;
	b=iwPYAz9pGU5dS43dI4xW5k9M4Zooh53Fybst7iW8xmcvHCdH/QpEbKS04FsSvnWyyP6G+G
	RG/Fz4vABOF3JfpRYcCBwXoHkDsurMrqAjkWS7vF+ZLSSbyBdgRTxDTic1NaIW41Bh2sgT
	Bor3X8p+Dlptj+zpZFnKfvexNIPQ8hc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgFv3EQl;
	spf=pass (imf26.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753777538; a=rsa-sha256;
	cv=none;
	b=pQOwzC9R2rjd6WSwoDlq2hHfaMDv/VeFRAcdZS1CXHL81Z/QAHZ/vEpa4Ideji5D6TrPOs
	/zkvXGv5pSRK/X1Op9aisj7aqm7vHg4e4H0nChkQiLJsuf5e1U5GY+VP3+9SfhtJcLMapx
	o1y47qmz6jdtDeZ4XRcMFd9aZkiSEHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 015C4A4C64B;
	Tue, 29 Jul 2025 08:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E6FC4CEEF;
	Tue, 29 Jul 2025 08:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753777537;
	bh=trWv/O9N9LVzYZbp1eqr0+k5qTUNtSEiwyb6DFcx67E=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=fgFv3EQlY2wrAjec/GhEM4fnwhqVwAKfjahNRyiU935vDwY3emdOPuRrk9X9AKLSg
	 s3Rn1wg4oPcHkCeIfvw6M6G6S+5q8eMJfhPVoISggyYqYc28O/G2vFvdiope7kGL0c
	 bVF9rKCTQfZkCWeRz1tJqijdXfI3pJ6VlsGvv3ItNyu2dxhll0drtkRGjoJ6/d+NEY
	 mb1Ucmy5cwiYT9XWxoXLKkiuDzvjXqJ4tjms0Frm4orwZyRTsGRLwJuI4u1vwB+/Lh
	 IPssxQRMSYVGTJ1O0vLgpotwkf90l5gSsFUKhbYwMPoBW3GxOVNKbBdP2FxA/hu5Qs
	 DpQZZ96LN58WA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Jul 2025 10:25:33 +0200
Message-Id: <DBOE907J16WH.1IOU3M11RX5SH@kernel.org>
Cc: <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
 <linux-kernel@vger.kernel.org>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Alice Ryhl" <aliceryhl@google.com>, "Vlastimil Babka" <vbabka@suse.cz>,
 <rust-for-linux@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Kent Overstreet" <kent.overstreet@linux.dev>,
 <linux-bcachefs@vger.kernel.org>, <bpf@vger.kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v13 3/4] rust: add support for NUMA ids in allocations
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
 <20250715135827.2230267-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250715135827.2230267-1-vitaly.wool@konsulko.se>
X-Stat-Signature: cc457kixjpzydjkuhk78g7rezg3qsz9d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C8CD2140002
X-Rspam-User: 
X-HE-Tag: 1753777538-781729
X-HE-Meta: U2FsdGVkX19KC/I+gI3/3D9jCVUQtvJo+jmRvm9yaYuUQ8pb8M5IRXyAD4nGwX7470/Ake8IhGu0TJluOJKt535+rE5tTM5BNo2uUQuHgBJHVOumByvgBG9B9QCyaIf4YU8P4lmifUQtatKnxAbRwaMs94y0J0ARMHiKLYKOQbOIekVsKmW9KvBHpL+j7XolpAdrSzbBR5tRKHRT6sA8NSrrxrE+vIPn57Til8iGu7p7wzXTn0mez3Ck1u4TuC21WjAmxu7e2+YMnNBvbgzJKZwpdG9uS9wFGgDkdEZ4ehUsr3AbLViKm3PjREqy+/msYhsdKUXNcpBcXSDBnThFjIa65mB6F+TiRFfZ3wYerkNVfJot5aTgFWLmIGsIldZ8tk1NAKVNAt6a8diQtRoB4e2dM4+jYmwYpLgIBZHFZdmRcLVvFGLHCkF3/H//FonZrJ44wIZXeym1tE+7avTpANLljsM9LgzdrrpumdSNO+v9dJgI7c4FC0L3sigOMeEX/JFoq1FuBHAPmWfHD6J6o85N1mQi9bh2i/ea+rOcCqOM0gVSbecPWXbNzZ+MNYyNhJ4olFpl5YD+SzxF0vgYpv09a2pPLwxpL3jOiIIhnic9brkGkHEJVCZ2mjNGd3d+QUnk24DcE9uF+iUmimkwU9XKUw50HLRZcaL+BfaH2VPiAH6cckpyYaKi3sR7Sq8vM0nOrQRnctXChBGRX9Eza3Z+/aZGf/l6nu6oQ6Y8mBBJ6LtWpZZsQ3/aikdjoaozptnxxEmZquegDM+zH7TJ/3PbsDwrQIUvXX9ch9m0NmnfAd5jXyBgac4b1d9YT5s1q2QmTDZdthO41nP/MkqKamQpAEN662fSJaL5ZfT2lyzLv3U0Fo3PPV5StzzE7SLV7iNvrAaRasZYBuEKjzvmZVX+DTWqWBm5zfbshPVlM+gKyk4riydIHiC+cA1kYH3SXlg+Wbxiy+J1Cl8nZbH
 l5s+A6RF
 tbt2tAvXBRHUYIImCQ064oM5sa9j7e5GcppVh32Q8TWeuvJI8rSqBXcmTbf+m/5Fqq9e0n/MdfjJ4XFzETyoDKEaWT0Ppxax6NblE7c9EPI6TMwnM+xPID/DLtWkjg5ak/supKjaYtkiIoj12XBWCr9bHlKn5+ZB3emEvVoH3ChIk5TCGmJOFqV3V9deW0+MzX2nstniAWszXfpPUeVrRpcFZhIQ6AoPXKxeq6wZ1nEToN6ml5I/ec/HE5HRkCq2KL6V8V+ZIHtO6XMIV0aWO1RvUBWZQV/iqCyH2TtJ3Vp3fLhdQGMnOKbk5HOvBgY2jnj9jKRdzLxzROcw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 15, 2025 at 3:58 PM CEST, Vitaly Wool wrote:
>  pub unsafe trait Allocator {
> -    /// Allocate memory based on `layout` and `flags`.
> +    /// Allocate memory based on `layout`, `flags` and `nid`.
>      ///
>      /// On success, returns a buffer represented as `NonNull<[u8]>` that=
 satisfies the layout
>      /// constraints (i.e. minimum size and alignment as specified by `la=
yout`).
> @@ -153,13 +180,21 @@ pub unsafe trait Allocator {
>      ///
>      /// Additionally, `Flags` are honored as documented in
>      /// <https://docs.kernel.org/core-api/mm-api.html#mm-api-gfp-flags>.
> -    fn alloc(layout: Layout, flags: Flags) -> Result<NonNull<[u8]>, Allo=
cError> {
> +    fn alloc(layout: Layout, flags: Flags, nid: NumaNode) -> Result<NonN=
ull<[u8]>, AllocError> {
>          // SAFETY: Passing `None` to `realloc` is valid by its safety re=
quirements and asks for a
>          // new memory allocation.
> -        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags)=
 }
> +        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags,=
 nid) }
>      }
> =20
> -    /// Re-allocate an existing memory allocation to satisfy the request=
ed `layout`.
> +    /// Re-allocate an existing memory allocation to satisfy the request=
ed `layout` and
> +    /// a specific NUMA node request to allocate the memory for.
> +    ///
> +    /// Systems employing a Non Uniform Memory Access (NUMA) architectur=
e contain collections of
> +    /// hardware resources including processors, memory, and I/O buses, =
that comprise what is
> +    /// commonly known as a NUMA node.
> +    ///
> +    /// `nid` stands for NUMA id, i. e. NUMA node identifier, which is a=
 non-negative integer
> +    /// if a node needs to be specified, or [`NumaNode::NO_NODE`] if the=
 caller doesn't care.
>      ///
>      /// If the requested size is zero, `realloc` behaves equivalent to `=
free`.
>      ///
> @@ -196,6 +231,7 @@ unsafe fn realloc(
>          layout: Layout,
>          old_layout: Layout,
>          flags: Flags,
> +        nid: NumaNode,
>      ) -> Result<NonNull<[u8]>, AllocError>;
> =20
>      /// Free an existing memory allocation.
> @@ -211,7 +247,15 @@ unsafe fn free(ptr: NonNull<u8>, layout: Layout) {
>          // SAFETY: The caller guarantees that `ptr` points at a valid al=
location created by this
>          // allocator. We are passing a `Layout` with the smallest possib=
le alignment, so it is
>          // smaller than or equal to the alignment previously used with t=
his allocation.
> -        let _ =3D unsafe { Self::realloc(Some(ptr), Layout::new::<()>(),=
 layout, Flags(0)) };
> +        let _ =3D unsafe {
> +            Self::realloc(
> +                Some(ptr),
> +                Layout::new::<()>(),
> +                layout,
> +                Flags(0),
> +                NumaNode::NO_NODE,
> +            )
> +        };
>      }
>  }

Regarding the change in the Allocator trait, we also have to consider
the Cmalloc allocator in rust/kernel/alloc/allocator_test.rs, which is ther=
e to
support userspace tests.

While we're planning to remove this (see also [1]), we still have to consid=
er
it for now.

[1] https://lore.kernel.org/rust-for-linux/20250726180750.2735836-1-ojeda@k=
ernel.org/

