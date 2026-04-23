Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46243FDEE27
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D23C6B0088; Thu, 23 Apr 2026 13:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583586B008A; Thu, 23 Apr 2026 13:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471DE6B008C; Thu, 23 Apr 2026 13:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35DC16B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:07:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD4F01A039B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:07:26 +0000 (UTC)
X-FDA: 84690451692.10.21172BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id AC118100010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:07:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dhpe7vYk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776964044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3I6tH1K2LZqlufSuXP6tj3OhMPP7NY3Zvi4kdZfFVdo=;
	b=O1thLOybluU+d2qdrACTf6CY2XDMHpObbqX5kmnmHbQmjzcXxKGj33YZqGHr1SJcR5bkFL
	dXhXmWEEWZ4S2foLMU8q7QO+pqOQSkAPDlT/DKxuWmDk6HxhBs96PtKTyeSuQduNBkntC9
	v9k23+H8YzlJQu2a8XRC6slJluvDvWw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dhpe7vYk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776964044; a=rsa-sha256;
	cv=none;
	b=58CaMqkqdNuvR9rrUTTQWjSjyeASIdGnFmv8Kr9zWCmUkYbvKVtQ+XYH7i7Zkb8IJtQK3K
	EYkLiOMZLu43WzsBovbhOY8OBVQJRh37jmN2wpt8Q4j6zXRwTNEHkDrcu9dDFWWfu8eSGu
	b/zZPhTQJ1RIrNII9qUtuZ8ZNMutLI8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C2A3860139;
	Thu, 23 Apr 2026 17:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2351C2BCAF;
	Thu, 23 Apr 2026 17:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776964043;
	bh=Od5rIDJoLXjhMgFvJFtK+2TZl45gHONpbL19GnF0G+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dhpe7vYk/JqpgDEqiWhM3OH5iR/5fSGBbpzjJi5NIcZPAsKvc8rYiOPwg1JG+6rKk
	 q4zk9a4X7wInOcqyhRNVjTJDWfMQDF4EDMg0EVfIWA1Sl1qcVelRJ0h7HEuVabxdBw
	 nxaoKR4bAmbk/abX3qnzp1UwTJWbF1E1NIdVfT2jXmLWjx0x13PtF8Vo6wdiFK88Ti
	 WIva38uLD10/9NAfrNnBrj6lPKcdaayJDm0X7y7THTNBrB72XP1B9vvAeQuD5odThh
	 k9Y5+DL0oee6R22sAA/8PWu0WQ53I8BEcIC1XenS9XIHY5F8+4YiCGyJw3+wY7z9Hx
	 g13MjnPP4OZKg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id D4CA8F40068;
	Thu, 23 Apr 2026 13:07:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 23 Apr 2026 13:07:21 -0400
X-ME-Sender: <xms:yVHqaUKxKRh28AnA77MfEsDvy8Hrk0ARcYOGtkVvN0ql0991gEOCAw>
    <xme:yVHqabNbNSR1GkknYCzXAnHX_wiHr9em7Ak37t1GN8lOTDJcmyfI6TFim8Wfh0DCH
    kNaC6WeRuelqORPCnIcv8dMCGkyqxn5yCqksoPcozarrL23sv0oikI>
X-ME-Received: <xmr:yVHqacb-6CcVEv_L6gMhVssRYKaYlhsdId-brAAXYfkQg-djOMtnpgJer6qnzvGMT4zWho3adaAM9QHOShlhIi_fNrpo-BDh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeijeejudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnsehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnheple
    evhedtudfgfffgffehtdetjeeugfegfeetueeiieeiudehudehkeeitdejgedvnecuffho
    mhgrihhnpehtrhgvvgdrmhgrnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihht
    hidqudeijedtleekgeejuddqudejjeekheehhedvqdgsohhquhhnpeepkhgvrhhnvghlrd
    horhhgsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepvddupdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopehjohgvlhgrghhnvghlfhesnhhvihguihgrrdgtohhmpd
    hrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtph
    htthhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtghomhdprhgtphhtthhopegrnhgu
    rhgvfihjsggrlhhlrghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepohhjvggurg
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepghgrrhihsehgrghrhihguhhordhnvght
    pdhrtghpthhtohepsghjohhrnhefpghghhesphhrohhtohhnmhgrihhlrdgtohhmpdhrtg
    hpthhtoheplhhoshhsihhnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:yVHqaXwSsa-EC2yJb4kePyKBURNtWROSm2Y68-wQ_Jmcycxfh73ykg>
    <xmx:yVHqaYFUCvYL6V-pQWE_ax2xz5i65aLFWrLaW5yqWy7dNHZQ0_x-3Q>
    <xmx:yVHqaSqSD20Rqon3yXtaTvyrCoppcdsW3s6BxLBHhGdK-slV3Ck2Uw>
    <xmx:yVHqaWz82TIirpMlXrybiOvnf9SNW2D03U_jv_ROpBwbm3lp5XOT9A>
    <xmx:yVHqacwp5YVvJNqeoU3Z_Omk-3Xas5FVdsCKNeDccpOrD75PzvLuqN0U>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Apr 2026 13:07:20 -0400 (EDT)
Date: Thu, 23 Apr 2026 10:07:19 -0700
From: Boqun Feng <boqun@kernel.org>
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>, Timur Tabi <ttabi@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v2] rust: maple_tree: implement Send and Sync for
 MapleTree
Message-ID: <aepRx2jgIKmoRp-r@tardis.local>
References: <20260422202813.2990181-1-joelagnelf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422202813.2990181-1-joelagnelf@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AC118100010
X-Stat-Signature: 7wojxazktmhoupxde874pxycr4qoq4d3
X-Rspam-User: 
X-HE-Tag: 1776964044-865178
X-HE-Meta: U2FsdGVkX18kbj8tYNJqnSKJwNZV4Rv+qaCZhhr8H4joSlQhSvMpA3+ZNgFKETcf3WZWJ7zSBO2hriKxih/nqdWl9nDmQokH1SVP/oURIrSZPnWCCU8fSN5Xv6M+pBb36+HztlEJ6rdnqamWKGYLvqAHLZtctwjwu4AFQ41GkQoqW++mPgH12KYqsdk4+Cv2qevbxbRbrXAlJmTfgAiVBzDi0TrgnyassccZ9lm3zon1bFWPTcj7I9WlEEeXbfKms5Ub5a64rR/hK2RmnMYeT6lcpOBGMIOVCrvkwUq8wpnWz6uaIvlahFPlEzCnJBR8hD9jdPaXtN9SuuTVbY2nibfsrlTTIKMjVHzlZbBoHTZuxGuQ2NP6lq3ZcTwHJkU3tRNho2H28toNmJm7j4M/Kx+caTmPtDXvHFiVQSVHtQThYdzftovIDPrG0NpfSQi+nS+scJ/wS3NfEqE+D0jcSoIwLCScjwULJfqA6Q5v+2v+FFQNjlzh6Icx0vB/RgcYGE796wrmWvRMj/XOifQoUSsGkLGxUT6auBXNyUT1j10r4IadAHwYpEutpwJsqXVnuAh32JOoKj9T2+pG/Y5hAo8qRX6Mh0tGse9OtoXjjUUxCiOxianhyvWJAFI3EYLAedFuyK/EQ4vnz8bxqxIilefaK2fjjWo6mDN3pGDw0ydMw44NnE3ejtxvyiLvn2y/W+Ecsof2y6EWRTnk2p0oJHaIRI66+7UJ4tdbxDyGgGcbJfyWlRU6KI6EqvsJykJwFDP5KxZb+eZFYJFPXpjNPsWyxnQYU9BmFTiPVru5k7V1sitjzl5XvWwI99/4/vWZuXeE6akp80DhR3oysGd/PRmq7WBtrI5MwDOanT+H6A4u2olYsrVqmywYHfA3f0USwW+8UA3pg3GQV+dxuEmlMawRvJTPAHgaMYI2o7eO3V6yVygva8sYbA0KaRjxKztYflPg4dUwYWszK0xOwr9
 CMVzWDRF
 HIvF2pj7pXg8pDrJdY9gPynZj+dj7vgWhHWwbaxW5JklH0v10FG7hDSHCmB1uV60OZaigcsPGzc1OhLsn5CeyzDzGWCXn3zLuYtRcU8jP5RkhWfZIXnpRjw0wztbWa91yaD8ODrkyODFVKzsDSbnN1xciqJAB2+WJGExeg56NbmL4GqSmSYqPILyptiGDUN6mZnxzHDeeygWnUkpS2Ot2u6xK9+eAp0ZvJ5ztEYKsgZT2Gs7AtOkVDHC82CnUVgYFFmbaTN8gVBz92OzxpO9xMPwXZMCh1IqDbGGJpNyvpQb3t+d43ZqBYrBUKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 04:28:12PM -0400, Joel Fernandes wrote:
> The C maple_tree struct contains a *mut c_void, which prevents Rust from
> auto-deriving Send/Sync. Following is an example error message when using
> MapleTree in nova-core's Vmm.
> 
> This propagates up through MapleTreeAlloc to Vmm, BarUser, Gpu, and NovaCore,
> causing NovaCore to fail the Send bound required by pci::Driver:
> 
>   error[E0277]: `*mut c_void` cannot be sent between threads safely
>       --> drivers/gpu/nova-core/driver.rs:77:22
>        |
>   77   | impl pci::Driver for NovaCore {
>        |                      ^^^^^^^^ `*mut c_void` cannot be sent between threads safely
>        |
>        = help: within `MapleTreeAlloc<()>`, the trait `Send` is not implemented for `*mut c_void`
>   note: required because it appears within the type `kernel::bindings::maple_tree`
>   note: required because it appears within the type `Opaque<kernel::bindings::maple_tree>`
>   note: required because it appears within the type `MapleTree<()>`
>   note: required because it appears within the type `MapleTreeAlloc<()>`
>        = note: required for `Box<MapleTreeAlloc<()>, Kmalloc>` to implement `Send`
>   note: required because it appears within the type `core::pin::Pin<Box<MapleTreeAlloc<()>, Kmalloc>>`
>   note: required because it appears within the type `Vmm`
>   note: required because it appears within the type `BarUser`
>   note: required because it appears within the type `Gpu`
>   note: required because it appears within the type `NovaCore`
>   note: required by a bound in `kernel::pci::Driver`
>       --> rust/kernel/pci.rs:294:19
> 
> Implement Send and Sync for MapleTree. The tree contains no thread-local
> state, and all shared access goes through the internal ma_lock spinlock.
> 
> Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
> ---
> v1->v2: Adjusted comments and imports.
> 
>  rust/kernel/maple_tree.rs | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index 265d6396a78a1..2400c905270da 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -16,7 +16,11 @@
>      alloc::Flags,
>      error::to_result,
>      prelude::*,
> -    types::{ForeignOwnable, Opaque},
> +    types::{
> +        ForeignOwnable,
> +        NotThreadSafe,
> +        Opaque, //
> +    },
>  };
>  
>  /// A maple tree optimized for storing non-overlapping ranges.
> @@ -240,7 +244,10 @@ pub fn lock(&self) -> MapleGuard<'_, T> {
>          unsafe { bindings::spin_lock(self.ma_lock()) };
>  
>          // INVARIANT: We just took the spinlock.
> -        MapleGuard(self)
> +        MapleGuard {
> +            tree: self,
> +            _not_send: NotThreadSafe,
> +        }
>      }
>  
>      #[inline]
> @@ -302,19 +309,29 @@ fn drop(mut self: Pin<&mut Self>) {
>      }
>  }
>  
> +// SAFETY: `MapleTree<T>` is `Send` if `T` is `Send` because `MapleTree` owns its elements.
> +unsafe impl<T: ForeignOwnable + Send> Send for MapleTree<T> {}
> +// SAFETY: `&MapleTree<T>` never hands out `&T`; all entry access is serialized
> +// by `ma_lock` or `&mut Guard`, so `T: Send` suffices (`T: Sync` not required).
> +unsafe impl<T: ForeignOwnable + Send> Sync for MapleTree<T> {}

If the design of MapleTree API is to support having multiple readers, I
think we should add `Sync` bound as well for future-proof. I.e.

unsafe impl<T: ForeignOwnable + Send + Sync> Sync for MapleTree<T> {}

Thoughts? Unless you have an usage that be broken because of this.

Regards,
Boqun

> +
>  /// A reference to a [`MapleTree`] that owns the inner lock.
>  ///
>  /// # Invariants
>  ///
>  /// This guard owns the inner spinlock.
>  #[must_use = "if unused, the lock will be immediately unlocked"]
> -pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
> +pub struct MapleGuard<'tree, T: ForeignOwnable> {
> +    tree: &'tree MapleTree<T>,
> +    // A held spinlock must be released on the same CPU that acquired it.
> +    _not_send: NotThreadSafe,
> +}
>  
>  impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {
>      #[inline]
>      fn drop(&mut self) {
>          // SAFETY: By the type invariants, we hold this spinlock.
> -        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
> +        unsafe { bindings::spin_unlock(self.tree.ma_lock()) };
>      }
>  }
>  
> @@ -323,7 +340,7 @@ impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {
>      pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, T> {
>          // SAFETY: The `MaState` borrows this `MapleGuard`, so it can also borrow the `MapleGuard`s
>          // read/write permissions to the maple tree.
> -        unsafe { MaState::new_raw(self.0, first, end) }
> +        unsafe { MaState::new_raw(self.tree, first, end) }
>      }
>  
>      /// Load the value at the given index.
> @@ -375,7 +392,7 @@ pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, T> {
>      #[inline]
>      pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
>          // SAFETY: `self.tree` contains a valid maple tree.
> -        let ret = unsafe { bindings::mtree_load(self.0.tree.get(), index) };
> +        let ret = unsafe { bindings::mtree_load(self.tree.tree.get(), index) };
>          if ret.is_null() {
>              return None;
>          }
> -- 
> 2.34.1
> 

