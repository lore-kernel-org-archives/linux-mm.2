Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A134606A333
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zx+nIfXZ
Received: by kanga.kvack.org (Postfix)
	id 4DCA26B05B3; Wed, 11 Nov 2026 14:40:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4668E6B05B4; Wed, 11 Nov 2026 14:40:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EC36B05B5; Wed, 11 Nov 2026 14:40:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD416B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:40:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B2C31203AF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:40:44 +0000 (UTC)
X-FDA: 85423855608.21.1ACC336
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 03FADC0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:40:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zx+nIfXZ;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794426043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9+U4iNiHz63kgEwzrgZfWzI7/jqnf7J3/4pv9aI/zc=;
	b=rVJei+hEV55ygFdxXRD7zBF1aPbYfA6PalhhnYTQUyoIy0gqUggF6XSZWfE15EMJA3VWLG
	q4FjKJGtPdeE5WsVeJ9YbBDLYjoySQccd+ovoQ2LfFjyvABVmj4vo3KrZyHyZB+IXq4HNH
	z0Y2a0qfKwM4Fqb2frMNLd/nn33BY0Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794426043;
	b=jjYQsatJ5wtRDFtW+125sGlHL1akfPKvgwSOTB63A0GY9ev+d94itmX9FyijTAlo5XAV+l
	xiiUKTSZscV6WKAuJ+td5v7bw0e/zeAssMKpuyoFEm3+LDzoQxPNopkb8j3F0ORc7DKcTB
	d0KtNufyVmsext8yMTMfo1x2y9v6ypg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zx+nIfXZ;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A89065541;
	Wed, 11 Nov 2026 19:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8279C1F00A0A;
	Wed, 11 Nov 2026 19:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794426042;
	bh=B9+U4iNiHz63kgEwzrgZfWzI7/jqnf7J3/4pv9aI/zc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Zx+nIfXZJ5nduKwV4Kohuy6/wPdBQ4ZIaJJqYxE+zuPQGTjFy0XKAB/vd5Nul6mWS
	 dfbb8UYEW+trGtamk7bCAjRFBbU/f9x+NGE3/pvTn1LX17XvYSldT9RNfsRDtbg5ZF
	 yMx9oiUTY1wuYeAu49os930Inq/rwkyDpMpahOZV4+zQhdZc6ZrMe2sWjWkNp9CnMJ
	 5gwC/xRFPp8FsEMGuA0isPQ0XSW15BK4OQ2abwu82gu1KzNB6abF6XDM+IDpfsBueP
	 tE2J47l2c9YtzO73s6ESRKnkVBC+VbnnD+c+f74bsv7iVifmphXZ9IdlkaBHomBLvZ
	 RDQpI7pIY1AcQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: sashiko-reviews@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6r?=
 =?utf-8?Q?n?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon
 <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mark Rutland
 <mark.rutland@arm.com>, Daniel
 Almeida <daniel.almeida@collabora.com>, Tamir Duberstein
 <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Onur
 =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>, Lyude Paul <lyude@redhat.com>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH v5 1/4] rust: io: require freedom from plain accesses
 for `SysMem`
In-Reply-To: <sashiko-outbox-209186@kernel.org>
References: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
 <20261110-page-volatile-io-v5-1-a91ef252c24b@kernel.org>
 <lAtM0NMr_K13f2Z2C_qDZsigOTH50qf6QuQZFFVh8k5-v2pkTO25UdKBCrSXWiHNHqhYUtZjNkwa-xsZraO9Og==@protonmail.internalid>
 <sashiko-outbox-209186@kernel.org>
Date: Wed, 11 Nov 2026 20:40:24 +0100
Message-ID: <875wy3w40n.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xmy3nkqxax75g3unedaaoj6owogxitqx
X-Rspamd-Queue-Id: 03FADC0006
X-Rspam-User: 
X-HE-Tag: 1794426042-651609
X-HE-Meta: U2FsdGVkX1+4m/NYSTQQ2WShq6PtDf5hO0vJmN9oW2WIJmB1Lx+nOEVt54JDY8p9VlNoMo2g1g5FbnROf5R/vdbQG7hqxgNeKwpz1ztGvbp4EmR/iwAnBXnJ3Sn1V47YnF6td7qbGqKzfYS1E0mMr3+Qk6g0A7syAyXJ81WAyN0gjZPx6B9LOZrMpj1FdZXmTs9X2lkNWHkBRTmjSiUfX0XZeACTxGv9bsZ53Au+muFcscX+uyzqp26xEYbyldUloZZPTfVlhLPo6r9Yw1bHEz3HJSbgL0p99IGLYW+MH9fSLcKuAGOLDKadbkXY5YwWsf2hqRGKzQLuqWK2j31uG0Y2812rXDf68j2XQ7iAlN/74Oydvh1h/jKGppA63c8Ly6BgXGT0Wm+0Vv+MngUygxSFfid2xAp/ijV/+sudl7vzYdD6QtmAUx7aYy33ei7yMsyW/IzlKQOzu5JFUaqwLGG3S2AeJYeSSjVBPtgovStDGK0JLLG/4dNyRZaVdx3wvriImJu5omDqwxJrJcmIPolvUCSUIBY4NVZj1BiA1InKvCu8AyIBogQ1+KxpQxkauXbQgPkdoNzD7qb7iRcaoKMwyqKuRAOdP6BPXnB9w2/K7faMBSa+HF5PyuZKNzxXRBuqy9xqrX2ZuV7YzCKrgyB7PQMO4gQEZR36jTAf+WHa7Ng3Q+xmJL6xqYOsMFBqWxA+fT6iEUG9KQ1IhoAiQULfNjjdxWGX4D9ODo8Hwypn9h6a1/lG1AAopGcbQ213b2HHbOucOW3kbyl70gStGxMPwYdQmF3pbd6yeq6JawvSf3CVbzG6c2dCyzxiobKRORjXgd26kDG13a1PPsfwOkCheAA0/xCKjJ3NT2tyoCK43i4LM9MjllmOvKpnhlNOwRuMWUyusN/61mitkYJUC+ny8Vf+dHo5v0A2+FpJ6ZDtpZtCX9bm5CpnTj4bY21OyAKIk/I9sluyJyKVhwD
 l8fUsUR1
 AoElJbIbO5hoyr3mx6NI/87IgBhyNNsEH6nLzTAZjzBoFp7dOGt1OHD7ylYWUYO62CuQhZGqntW0ygwFR0mDVGEIf/vU56DY37RqspKwLI2C7A0dfwxlr5HMvOzepPADfs3lySE1V3tXrp8t5aQqp/oR5flUfffvo5EgeaVxWqmhWq4/8TuKuPAoC+dPYDc2oDnfWDeLqXNJjFiQLySEeoBRyHHTVyL3z4ZhX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

<sashiko-bot@kernel.org> writes:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] rust: io: SysMem::new() no-plain-access invariant violated by
>   callers
> --
>
> commit 2301a5fd31bd2665dfd4001d0e9beab25a81725b
> Author: Andreas Hindborg <a.hindborg@kernel.org>
>
> rust: io: require freedom from plain accesses for `SysMem`
>
> This commit adds a type invariant to SysMem and a safety requirement on
> SysMem::new() requiring that no plain accesses are performed to the memory
> region for the lifetime of the view.
>
>> diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
>> index a877df11a03e0..3bc4be35e3554 100644
>> --- a/rust/kernel/io.rs
>> +++ b/rust/kernel/io.rs
> [ ... ]
>> @@ -1570,8 +1582,10 @@ impl<'a, T: ?Sized> SysMem<'a, T> {
>>      ///
>>      /// # Safety
>>      ///
>> -    /// `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be valid and aligned kernel
>> -    /// accessible memory region for the lifetime `'a`.
>> +    /// - `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be valid and aligned kernel
>> +    ///   accessible memory region for the lifetime `'a`.
>> +    /// - No plain access (see [`SysMem`]) to that memory region may be performed for the lifetime
>> +    ///   `'a`.
>>      #[inline]
>>      pub unsafe fn new(ptr: *mut T) -> Self {
>>          // INVARIANT: Per safety requirement.
>
> [Severity: Medium]
> Does this new SysMem<'a, T> invariant conflict with the existing
> SysMem::new() callers in Coherent and VMap?
>
> In rust/kernel/dma.rs, <&'a Coherent<'_, T> as IoBase<'a>>::as_view() is a
> safe method that wraps the buffer in SysMem<'a, T> inside CoherentView<'a, T>,
> while CoherentView::as_ref() and CoherentView::as_mut() hand out &'a T and
> &'a mut T references for plain accesses over the same lifetime 'a:
>
> rust/kernel/dma.rs:CoherentView::as_ref() {
>     pub unsafe fn as_ref(self) -> &'a T {
>         // SAFETY: pointer is aligned and valid per type invariant. Aliasing rule is satisfied per
>         // safety requirement.
>         unsafe { &*self.cpu_addr.as_ptr() }
>     }
> }
>
> rust/kernel/dma.rs:<&'a Coherent<'_, T> as IoBase<'a>>::as_view() {
>     fn as_view(self) -> CoherentView<'a, Self::Target> {
>         CoherentView {
>             // SAFETY: `cpu_addr` is valid and aligned kernel accessible memory.
>             cpu_addr: unsafe { SysMem::new(self.cpu_addr.as_ptr()) },
>             dma_addr: self.dma_addr,
>         }
>     }
> }
>
> Any plain read or write through those references during 'a violates the
> SysMem<'a, T> invariant even when no concurrent access occurs.  Similarly,
> <&'a VMap<D, R, SIZE> as IoBase<'a>>::as_view() in
> rust/kernel/drm/gem/shmem.rs calls SysMem::new() without VMap's invariants or
> its SAFETY comment guaranteeing that no plain accesses occur during 'a.

The last bullet of the safety requirement for `SysMem::new` is not
formulated correctly. It should state that no plain accesses may race
with accesses performed through the view, not that all accesses are
prohibited. I will fix this in the next version.

I will also update the safety comment on the call sites. The calls do
comply with the requirement, as far as I can tell.

Best regards,
Andreas Hindborg




