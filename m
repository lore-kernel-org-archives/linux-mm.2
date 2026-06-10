Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB842CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 06:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81006B0005; Wed, 10 Jun 2026 02:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37136B0088; Wed, 10 Jun 2026 02:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946FE6B008A; Wed, 10 Jun 2026 02:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 831FC6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:52:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E5F7408CC
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:52:22 +0000 (UTC)
X-FDA: 84863084124.20.6A707EC
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 54021140008
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:52:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="CQ/+jwHl";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3ogkpagkKCLERcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ogkpagkKCLERcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781074340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Nma+8ZLl/ANIFmPcb7oIzPV1qmhLMChBX+uzNBOMDo=;
	b=mc+3QvYZlJJKE4q++ZqpI55QrQ1p8fJqdB+ZbX7rBD3ffRbXhe9bFfpz8lVxY8kH0GOE8b
	9PUCtVVb9788i+XAzTbsWYJKatoHfg0YQi+8PSk2xOsJTwALU55Q9UmOMVqQQ2c4G4iwA2
	RvqhVkhoIUERynZ0kg3goKkzen3j+Mg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="CQ/+jwHl";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3ogkpagkKCLERcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ogkpagkKCLERcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781074340;
	b=LPK45k47tVEQIlM7YpUN+48YGPtOrgBG2TXWk1b04/ypMEEMVUqYXMzKzmrg/AODAR/z0e
	HSLVLO+T26HyMCMoR2xkduF58/h73vm8JDIHCHhpGSDn1mC/4zRHZGr1ZRs0xjlFoYcopn
	5bEiyK0W2hbEwfynV0OwCoAZ7WG0ZUg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b37e1f48so51439055e9.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 23:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781074339; x=1781679139; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5Nma+8ZLl/ANIFmPcb7oIzPV1qmhLMChBX+uzNBOMDo=;
        b=CQ/+jwHlEWdL60WjuYJxu4mDhjxjt1KBcQjQyiWSrqGWhB85G3Jr8Rz/zyqfyYeMHe
         jy2e91NA/Bf1WV72B7BkxNggInumg+q60fvgpKQ3AviV2GZZxoeROMATuqKpmHNVH/s/
         8b/8Ni86yIMruUfooxVAoSSiMzwJoPN7+etKQJLH83Lhx6WNxT5LU2yrrrwOnfo/CILK
         fSyvAe2VecdMEN/IvJcNBMssX+NRc7vRyVJLWordr1i557jJuLh/OBYdjeiZJJlN2GGE
         ZnZigUFRd5G9cnovUJuZOkx86MofvDSyb4/MWKimwzXogstj0PJMPP8pPBlpT/dLqPzQ
         4A4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781074339; x=1781679139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Nma+8ZLl/ANIFmPcb7oIzPV1qmhLMChBX+uzNBOMDo=;
        b=PqAYu6WSxsWII7XhjUUMk+TAkdzmgrDZbITbYkhmQ0Rx6zvR5kg+aqhO3KdWUK2jlj
         mtU2Wu7kkglVTXK4Q3dnaiEOMOuo6x3kLt78RZ+bcKomBdBXV/Iz9sCZBrX/nGnAC3te
         gWoVnOJKGgZOH/9yV5xkeZLKCjWsq0O3zinecAGdaAM76RJ25xa46JLlwliDtuvULivz
         DQgAX7w8yDUZk4DHCh69WBz5Ozn4rMBg9DQP7XWyu7db2Xh8v4vb06Th129+V2s+WPi5
         gk2MD16IEI9LopxNrFEJfVsN81g1snZj/zE5cDfz6INZnzPXknfvOoynv+w7bPR6+iVw
         ZQwg==
X-Forwarded-Encrypted: i=1; AFNElJ+c7XdMvDUUsIoZUzK3Ri8vFIDwAPzhTcUOsdYxCq3u5lioduB/jglGLE1Y5n7QX45h19fY3nVAvw==@kvack.org
X-Gm-Message-State: AOJu0Yxon/00bX03jL7bEKVjLxoZdD9z17+mJrPYvdW/RRqm7RhrMw0R
	+mB3xdZ9G2Vfx+IXzr0+rjs5LjGrh81zm28/Jslb6oUiMuUcbgY4FXL2c8ZBCinfNpKuy3Hcox7
	n00dqdjlIqjZr8iWvhQ==
X-Received: from wmbh23.prod.google.com ([2002:a05:600c:a117:b0:485:3a14:a74e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1908:b0:490:b5d0:598f with SMTP id 5b1f17b1804b1-490c25b5f6cmr386696345e9.13.1781074338597;
 Tue, 09 Jun 2026 23:52:18 -0700 (PDT)
Date: Wed, 10 Jun 2026 06:52:17 +0000
In-Reply-To: <20260605-page-additions-v2-1-03f04c8fdbbf@kernel.org>
Mime-Version: 1.0
References: <20260605-page-additions-v2-0-03f04c8fdbbf@kernel.org> <20260605-page-additions-v2-1-03f04c8fdbbf@kernel.org>
Message-ID: <aikJoacZW5JMEx74@google.com>
Subject: Re: [PATCH v2 1/2] rust: page: add `SafePage` for race-free page access
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: byy1db1txzux1iaraci1poqn93umio9d
X-Rspamd-Queue-Id: 54021140008
X-HE-Tag: 1781074340-532423
X-HE-Meta: U2FsdGVkX1+v1vkrmMPhDJ5JMzRwjxqpapjhAinxverZdp5CEFOgZDPKok4LwjoGsi7gIiQhsCg/ihDEtqCH3K8VQsL68MepvAdy4anS1Cnc5PB+KXd3Dn6K+hTWgcI1PC31ZkR9MZicg+FLBXdZ4i4A7mPZb1hGpOtK06Q5QS2Ckxb/nMOTDRRUSenFufoyXQLPevhUTCVhLd/J7TfXuJoCY6QsHvXXRS0ld0t97D63aQSjrHURiq263u8odePqi32uVg5bFUuOiaZfnRBay79VAH5IxkskOEyz7jroZO7BgMvGSE4QhEPHn5rIK5wIWyO5govV158N6+ad3Ftybb1hABHSSwfzZQuqE0iehzUPfShUxqWNBAy50ScihxnZt4uO0XiOo3wBEdgctffOd5hYYXp2CSwKKK3v9zb+WrEaGnpxfWalSD+ddrhVbUQiocNqn3RnRjYeo/UMQe6I5OzcV1UYOp8JJ7PyT2JOHjvtaGHIYQpq2sU5hI70C1VtTDIAGfyvtAUX6676IPTub4tkMLjxC+GxbFI78jSKXhHJfwbyyM+fA+SXEBhOX80TIBINA85u1dET/v27BOgLa/lXIFOd8YMkpG/LSBuY4321Xo50+hsIAiFA8qXmVS0Hypd7xYANe6ZCgcoKc83tD5Olbdo0G66Jg4pSTfywuQ4XKVmbhOIragmQ9EhgA702TaKVQiMuxBjbIvvwzDRrpDn99GLwxMhVS2uHTyPqTlwz22wTRSfEJHQIppJLDspTowOc/1ytmg/ygZK5jBSJrwfolg6eam7cPelQXfmGe89Kvipn8fwSvCVEZhfaTY5++rDR+lsN685YN2UOkRZtAdXmWOPUmapEQy4IBa57uophW91Jwzye+jGFlWDbwSd9qXfkEZK+x7ARGk18utGEAdEmx4OGRxAgAT7nBfeIewJXGsEiRp8O/QpkGF8W4c9BsaYINqkDwPXEowm1tOW
 dJBFH8Ui
 Y3uKRhqPe6Iu6T738erfWv3KN4k86yYN0rpXA/yurj7Pjmqhjr8bQxfPcC81E492LhK4ia0R7c2dFWSDX5CZtGrU9vw6OfBxEbp1x7iJ+a8Ib3k4nnKKFUfEQlM5AhTJxpDbDcjFZ/i3fu2XxqD0+6xfHZIeuv4+8VvUSTbFnj4NotawxfEECB7ufNTdZIpESNVHKFczNzld5lNHoZMA259etK4+m0FPVt2SN4WyoJBnQplXMq/fIx8dDofmeT5vTEl/JdgFBZwNMyyIj0h7hnNajFnBHRr+IRdR1+sjpel7dlWeuhJhcZ2kyeO/2bqCY/MVRZJ/qqjGYqkUns7pFScjAq44pDv0JmpHjkdr5TjaNbQxpl5W6KOV5ejSMbUtqKOt4XF4jNP0mAlrpGSyz7O0NV8TXDQLGj8gxGVHUQ+Hek6P5wc7ZnaZeoHEZLcViGoe8Y9W5RUFakocc8MlcQjRQcnWZQjYRyepL2J2gUCmXi1W4fsVuY+jEYdIm6HMoCNrddJ7WHnR0yo141KfFhQnvcUc0THNEk+z6vpvpTFb6V1lzP0QvAGVYq/nBpXw1zTf3aTJySXHGnEwXTJ06qQQysgTFKtu4kXffg9nHn8TCrxigztrB+UTWVlsZK67Wgjyq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 02:49:14PM +0200, Andreas Hindborg wrote:
> `SafePage` wraps a regular page but adds an invariant that the page data
> area does not incur data races. This means `SafePage` cannot be mapped to
> user space or shared with devices, and it becomes simpler to directly
> reference the contents of the page.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Perhaps it should be called ExclusivePage?

>  rust/kernel/page.rs | 73 +++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 62 insertions(+), 11 deletions(-)
> 
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index d56ae597f692..f143b42d1bd6 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -8,8 +8,10 @@
>          Flags, //
>      },
>      bindings,
> -    error::code::*,
> -    error::Result,
> +    error::{
> +        code::*,
> +        Result, //
> +    },
>      types::{
>          Opaque,
>          Ownable,
> @@ -20,7 +22,7 @@
>  use core::{
>      marker::PhantomData,
>      mem::ManuallyDrop,
> -    ops::Deref,
> +    ops::{Deref, DerefMut},
>      ptr::{
>          self,
>          NonNull, //
> @@ -193,14 +195,10 @@ impl Page {
>      /// ```
>      #[inline]
>      pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
> -        // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
> -        // is always safe to call this method.
> -        let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
> -        let page = NonNull::new(page).ok_or(AllocError)?;
> -        // SAFETY: We just successfully allocated a page, so we now have ownership of the newly
> -        // allocated page. We transfer that ownership to the new `Owned<Page>` object.
> -        // Since `Page` is transparent, we can cast the pointer directly.
> -        Ok(unsafe { Owned::from_raw(page.cast()) })
> +        let page = SafePage::alloc_page(flags)?;
> +        // SAFETY: `SafePage` is `#[repr(transparent)]` over `Page`, so a pointer to a `SafePage`
> +        // with ownership is also a pointer to a `Page` with ownership.
> +        Ok(unsafe { Owned::from_raw(Owned::into_raw(page).cast()) })
>      }
>  
>      /// Returns a raw pointer to the page.
> @@ -401,3 +399,56 @@ unsafe fn release(&mut self) {
>          unsafe { bindings::__free_pages(ptr.cast(), 0) };
>      }
>  }
> +
> +/// A page whose data area follows standard Rust aliasing rules.
> +///
> +/// [`SafePage`] has the same usage constraints as other Rust types. Thus, it cannot be mapped to
> +/// user space or shared with devices. This makes it safe to reference the contents of the page
> +/// while the page is mapped in kernel space.
> +///
> +/// # Invariants
> +///
> +/// The data of this page is accessed only through references to [`SafePage`]. While a shared
> +/// reference to a [`SafePage`] exists, there are no writes to its data. While an exclusive
> +/// reference exists, there are no other reads or writes of its data.
> +#[repr(transparent)]
> +pub struct SafePage(Page);
> +
> +impl SafePage {
> +    /// Allocate a new `SafePage`.
> +    pub fn alloc_page(flags: Flags) -> Result<Owned<Self>, AllocError> {
> +        // SAFETY: Depending on the value of `gfp_flags`, this call may sleep. Other than that, it
> +        // is always safe to call this method.
> +        let page = unsafe { bindings::alloc_pages(flags.as_raw(), 0) };
> +        let page = NonNull::new(page).ok_or(AllocError)?;
> +
> +        // SAFETY: We just successfully allocated a page, so we now have ownership of the newly
> +        // allocated page. We transfer that ownership to the new `Owned<SafePage>` object. Since
> +        // `Page` and `SafePage` are transparent, we can cast to the raw page pointer directly.
> +        Ok(unsafe { Owned::from_raw(page.cast()) })
> +    }
> +}
> +
> +impl Ownable for SafePage {
> +    #[inline]
> +    unsafe fn release(&mut self) {
> +        let ptr: *mut Self = self;
> +        // SAFETY: By the function safety requirements, we have ownership of the page and can free
> +        // it. Since `SafePage` and `Page` are transparent, we can cast the raw pointer directly.
> +        unsafe { bindings::__free_pages(ptr.cast(), 0) };
> +    }
> +}
> +
> +impl Deref for SafePage {
> +    type Target = Page;
> +
> +    fn deref(&self) -> &Self::Target {
> +        &self.0
> +    }
> +}
> +
> +impl DerefMut for SafePage {
> +    fn deref_mut(&mut self) -> &mut Self::Target {
> +        &mut self.0
> +    }
> +}
> 
> -- 
> 2.51.2
> 
> 

