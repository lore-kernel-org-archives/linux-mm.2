Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84811CD6E79
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 14:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81256B0096; Fri,  5 Jun 2026 10:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E589B6B0098; Fri,  5 Jun 2026 10:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E316B0099; Fri,  5 Jun 2026 10:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C52E86B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:04:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45CAF16022E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:04:32 +0000 (UTC)
X-FDA: 84846029184.11.7384BF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4B8DC160002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:04:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RApMYwO7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780668270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9phLvi9RaSkTbiV76v3B+9PIG1KyHFVOKkyTySAtm8=;
	b=EVKN1Egxe0RA5q+YPRPn3KC9wvnM0F4YDQdkH7rIFhSiSijDNneamc//AswPtp/cVnnFC3
	9jVdhmd6uESSsWZuoA6bBa690pll4bHMGDDEIlp2lzAz5eQSD9xNNrfba5C6ldVy5epwMS
	9HL1Mq8dFC9VFucrKES7HGXjw+OL8bY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RApMYwO7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780668270;
	b=IEBUy9ZMFSfrd/wiLhe/vFnHbsUOJRGoQRkYYxV08Pq6aMNhd1fDyrY4q98RTyYENueKgB
	4o6RmutG13XKFkndtbSSAMt4R90PC1LAdjIknPbDsEGkL7rILQrOkkt4ORJ4FyJL9A/wmY
	eBP1LLaHUHGR2mTWShgfbJTxGHTZlDo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B294D600AF;
	Fri,  5 Jun 2026 14:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C211F00893;
	Fri,  5 Jun 2026 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780668269;
	bh=n9phLvi9RaSkTbiV76v3B+9PIG1KyHFVOKkyTySAtm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RApMYwO7er3nWL423qBa8U7GezuFG85ZFI5QxfxdBRA7oxZOqr3+dUKOvKsQD42dk
	 MBm8gyp4fD+eznKQX2NuNl3PnC9qt/wtqr5m86YXCEdGRJMAhV26S4jY7Kh24jYkAq
	 GbrrIb2q4riaQyR41vegJ4WkCjoH4Em7/d4vKPqhCsKUoNi6h+Hyry4kG2iyFA90Sz
	 5aUMgBIh8jiCcjHLrtWhYi+Cg2DmYH55hjF80jg5xWdqKNdobAdnhkM5bg8xfUaHx1
	 KfNXPeeTrR8LvzTbFRWiEekhhKHP90RPEUV8lI5QIW3OQA8Ix9YzL1OHon50JAkz+m
	 /aMXpi8IlhVTA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 04B5BF4006B;
	Fri,  5 Jun 2026 10:04:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 05 Jun 2026 10:04:28 -0400
X-ME-Sender: <xms:a9ciaqlosAOgMQ-H7Bs3JEtceK8yxjIZyvfv12DxMpT8noa2LvH6UA>
    <xme:a9ciauTmf_0ZDts2yRwzgpvSn-ozgSSUasZ63qxsOL7UFns9IZhhWS3I7kz2NyySD
    srfWhMNvIgstAqsVM9nJB3Ob7qEmVRhMOVTtffqHmvrB1W3bPwETw>
X-ME-Received: <xmr:a9ciav5x9HVbnmYbLxkD4mit0JBd3O-U72si7DYB5phFmSYDmDoybYuX78o>
X-ME-Proxy-Cause: dmFkZTE0LZy4M50cfSktgTQFQkT6rI8G/Y5ximbMU42xvQT/+Sed7xjM9kNTsktTuSYDm1
    BIjZO7IzdASMlhBtV1S7AFMQApb37A8fKR9/AHBLIr/n9d/wlMaBz+PRGef2ki8mMhu9tX
    4JvIRsbSlNYDdkdzSA6KfbTuLTkSgs9bVuP2uAzw08Hls1twdxyz7y7v9YaBKujNxVJEjL
    G0EeIDtlTu2RAmmMKOAuCcjCCAFGKqDKV8vFzoNSBFeiSMcfD6JZu6gP3ORcpCyzteW65r
    25GOeoMN2WTRB5S4afaK+GExykd4IQTngu5itniecfIpXUhstt8v8txm3kk/kZVZbv1bqO
    ino+D2vIRbGMN+F1hRXDOCzUUZ2iJH07hy1zl3BcOJNvFSHyIe1wkLhZ97kGI/eS+3q0so
    mx/DzXcsnBDcWHgz6WWNinkDN6IiI48Vi289YaFfyxv8KArnYJOTUiWIfZ4GiV7IRl+0sO
    be02Isnlw5gQ6PVC39s4/Er7YAf9Cb0CT1xqHgh2ckzV1mpGiJHVHN4FZrGBoUVBJOBAcL
    t+ZwTOzejpgfVg0iqdMKpWeCjLU3a5n44cIPoA/RfgiZ4LMkRNHl2sJkaEZRhYj7pHjiJo
    ZVydVPBt8Dd6psI3xOgvfEiZQ/1XhhJ7y+n8Pv6AmgF9oUJpk/pxlIOaoAdg
X-ME-Proxy: <xmx:a9cialHZ--5RMQutJGNI-mXfgpahld13JBnKh_cXRhsUWb5rNGxwgA>
    <xmx:a9ciapGyCe-Jsr-DKFpFLGNwICjSfAj78LXIpdeH4ICgyDz8UpyQig>
    <xmx:a9ciartEuy8QyrrZg5xel2j7fyTUsmEiLyAvUGLc9pqqbxBhx36GZg>
    <xmx:a9cianI6wu3QjraoT0xkcrI8owwNVsdSwqYU2kw7PK0Smvh6B6QI7Q>
    <xmx:a9ciaizRFxuinjXkGL5XxgnHr3z8LABkzVb52CrBYIK0js_GkvR6y0HT>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 10:04:27 -0400 (EDT)
Date: Fri, 5 Jun 2026 07:04:26 -0700
From: Boqun Feng <boqun@kernel.org>
To: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,	Zqiang <qiang.zhang@linux.dev>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Philipp Stanner <phasta@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>
Subject: Re: [RFC PATCH 3/3] rust: rcu: Introduce RcuFreeBox
Message-ID: <aiLXaoGZVkiNEAgC@tardis-2.local>
References: <20260605133541.22569-1-boqun@kernel.org>
 <20260605133541.22569-6-boqun@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605133541.22569-6-boqun@kernel.org>
X-Rspamd-Queue-Id: 4B8DC160002
X-Rspam-User: 
X-Stat-Signature: 4e7h6m5ygc4xdbewedezcfnrdcrm9ynu
X-Rspamd-Server: rspam09
X-HE-Tag: 1780668270-141140
X-HE-Meta: U2FsdGVkX1/ce8gwx3wFVwlR6nXgyC0X2JU+cc9ii0LlUYb92OH6zL90NSHi4J29UbRpnLfWeiyWOgYM5ET/HFolN2J9HReAym1ifUEE6czAYw2Hrk4OOp1Yl2/xA6beSHFsgMnold/kew5EPdiD6UZmj1jLSXCvgm6gsANxuZ8c1JkjX73tu+HwHwby4+yvvm6MsquEpbMSW41hBZt49w+wX9XfEGMaI2iR0nw/XJrfRWXk5o3959UJ7cmlcKUAyWWGOi0lcIMe02BauoYu42HBFZCQQSTcqNCkKXBPyOV/ZalqtRsaQ/EGc08J4PAnf6CDc4z9LjmxpxlUxy6mWjC/o9tfToJsgJw5XLJqS+Injy5k2IqQBSzk8LbArc+mBr0hrGI8p+4MHzvyBRGBmWDQQ6segjH0xOsTm1cynf2og49/YEZQYEdkI+24r7Ohf7p9PfCSEjmi+DpIYsFwzn5KpuF2cSQBCiOHAsetZfiOGxHu74Z2Cutzjb4Vrnsj7wBwuCUeSyWk+zcpcN72O/EOJrq/OuixNJ6sLzD3nZmSjm8BjJPmUHpVZHoTiocXAFjW+ms8ojVBgvClzlALwGLUuefAh3d60vuaSq3vcFvLA/bd65ARtxpoVgN4U1deG1mCWvMR1FqAOi5p6GaJ/veEL3MrCLj8/lwtpyTv4u/j2E7sRTL2fFq2yqi/rYBHENHBWg1UMSwJA/Xis1FPG1axHLLUMOH4c6xZKShziQ20kqxheclHj0Iwf38Bz+29f0s1vmDGrTdJ8703T4JaRv8ZRW6sNwcGZ7qAKLDrLk7OaywxkavgJUlp63vr4b1yzRtzq9cVbuLeDRdoj3sENAwMDP12I18QhnZzut3+0roH39ZYD9b51cENFNuN4QzPqCSXQ0L5Kp5HZkmdqgEPzQaZMeDB5gyTcX9JPv40KGRJaI/ITWw7YLgTmBjg7oAxzXhYSAyHJRZeJ+R0QVz
 gmDvi4Io
 1n/eo1N3j5keb0J1H83i6l4pvvhyCEOVuUpf1qP13bvR0M4EevFJtGW6frm+pqR1wqStGxdC+Z1KicM/CzGe417hmEvulfQa4XqfLCZazbC5LeBW1z9cHBasWbdKO9sZSugtKfs9Ph5taGFs4jk9vEq/zsK+E2zg90uaiRHN2fvBbXCZtICivfx9dc3h9ZFJflS0y55O+cKZGM8nyS+nIQ77bh9LpY3JPK+ECKjJUne4M0Sh7gNmXNDDpF1KTjaAz0JV2kdZlkbQO4f8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 06:35:41AM -0700, Boqun Feng wrote:
> The current RcuBox will call the `drop()` function after a grace period
> inside an RCU callback. This suffices for maintaining a RCU-protected
> object:
> 
>   RcuBox::drop():
>     call_rcu(
>       |..| { // <- call back after one grace period.
>         T::drop(); // <- call the destructor of the inner object.
>       }
>     )
> 
> However, to support a different RCU usage pattern as below we need to
> extend RcuBox:
> 
> 1. clean up the object, and unshare it from future RCU readers.
> 2. wait for an RCU grace period.
> 3. no other RCU readers, we can free the memory.
> 
> An `RcuFreeBox<T: RcuFreeSafe>` is introduced to provide support for
> this:
> 
>   RcuFreeBox::drop():
>     T::drop_before_gp(); // clean up and ushare.
>     kfree_call_rcu(..);  // free it after one grace period.
> 
> Signed-off-by: Boqun Feng <boqun@kernel.org>
> ---
>  rust/kernel/sync/rcu.rs         | 31 +++++++++++++++
>  rust/kernel/sync/rcu/rcu_box.rs | 68 +++++++++++++++++++++++++++++++--
>  2 files changed, 95 insertions(+), 4 deletions(-)
> 
> diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
> index 7da6b8d22277..7c26591bb318 100644
> --- a/rust/kernel/sync/rcu.rs
> +++ b/rust/kernel/sync/rcu.rs
> @@ -4,6 +4,8 @@
>  //!
>  //! C header: [`include/linux/rcupdate.h`](srctree/include/linux/rcupdate.h)
>  
> +use core::pin::Pin;
> +
>  use crate::{
>      bindings,
>      types::{
> @@ -82,3 +84,32 @@ pub trait ForeignOwnableRcu: ForeignOwnable {
>      /// [`from_foreign`]: ForeignOwnable::from_foreign
>      unsafe fn rcu_borrow<'a>(ptr: *mut ffi::c_void) -> Self::RcuBorrowed<'a>;
>  }
> +
> +/// Declares a struct is safe to free after a grace period if all readers are guarded by RCU.
> +///
> +/// # Safety
> +///
> +/// Implementation must guarantee `drop_before_gp()` makes sure no future RCU reader will access
> +/// any part of [`Self`], as a result, after `drop_before_gp()` return + one grace period, no RCU
> +/// reader will be on the object, and it's safe to free it.
> +///
> +/// Notes for implementators: implementing this trait in general requires `Self` being a
> +/// [`UnsafePinned`], i.e. a `&mut Self` is not a noalias reference if `Self` has non-trivial
> +/// `drop()` function.
> +pub unsafe trait RcuFreeSafe {
> +    fn drop_before_gp(self: Pin<&mut Self>);
> +}
> +
> +macro_rules! impl_not_drop {
> +    ($($t:ty, )*) => {
> +        // SAFETY: Dropping `T` has no side effect means `T` is always ready to be freed. And an
> +        // empty `drop_before_gp()` suffices.
> +        $(unsafe impl RcuFreeSafe for $t {
> +            fn drop_before_gp(self: Pin<&mut Self>) {
> +                $crate::const_assert!(!core::mem::needs_drop::<$t>());
> +            }
> +        })*
> +    }
> +}
> +
> +impl_not_drop! {i8,u8,i16,u16,i32,u32,isize,usize,i64,u64,}
> diff --git a/rust/kernel/sync/rcu/rcu_box.rs b/rust/kernel/sync/rcu/rcu_box.rs
> index 943fe3e8974e..8f52bb472daf 100644
> --- a/rust/kernel/sync/rcu/rcu_box.rs
> +++ b/rust/kernel/sync/rcu/rcu_box.rs
> @@ -6,6 +6,7 @@
>  
>  use core::{
>      marker::PhantomData,
> +    mem::ManuallyDrop,
>      ops::Deref,
>      ptr::NonNull, //
>  };
> @@ -29,17 +30,18 @@
>  
>  use super::{
>      ForeignOwnableRcu,
> -    Guard, //
> +    Guard,
> +    RcuFreeSafe, //
>  };
>  
> -/// A box that is freed with rcu.
> +/// A box that is drop with RCU.
>  ///
> -/// The value must be `Send`, as rcu may drop it on another thread.
> +/// The value must be `Send`, as RCU may drop it on another thread.
>  ///
>  /// # Invariants
>  ///
>  /// * The pointer is valid and references a pinned `RcuBoxInner<T>` allocated with `A`.
> -/// * This `RcuBox` holds exclusive permissions to rcu free the allocation.
> +/// * This `RcuBox` holds exclusive permissions to RCU-free the allocation.
>  pub struct RcuBox<T: Send, A: Allocator>(NonNull<RcuBoxInner<T>>, PhantomData<A>);
>  
>  /// Type alias for [`RcuBox`] with a [`Kmalloc`] allocator.
> @@ -205,6 +207,50 @@ fn drop(&mut self) {
>      drop(unsafe { Box::<_, A>::from_raw(box_inner) });
>  }
>  
> +/// A box that is freed with RCU.
> +///
> +/// Currently we require `T` being `Send` because of an implementation limitation. In theory we can
> +/// support `T` being `!Send`, since the RCU callback is only used to free the memory, not dropping
> +/// `T`.
> +pub struct RcuFreeBox<T: Send + RcuFreeSafe, A: Allocator>(RcuBox<ManuallyDrop<T>, A>);
> +
> +impl<T: Send + RcuFreeSafe, A: Allocator> RcuFreeBox<T, A> {
> +    /// Create a new `RcuFreeBox`.
> +    pub fn new(x: T, flags: alloc::Flags) -> Result<Self, AllocError> {
> +        Ok(Self(RcuBox::new(ManuallyDrop::new(x), flags)?))
> +    }
> +
> +    /// Access the value for a grace period.
> +    pub fn with_rcu<'rcu>(&self, read_guard: &'rcu Guard) -> &'rcu T {
> +        self.0.with_rcu(read_guard)
> +    }
> +}
> +
> +impl<T: Send + RcuFreeSafe, A: Allocator> Deref for RcuFreeBox<T, A> {
> +    type Target = T;
> +
> +    fn deref(&self) -> &T {
> +        self.0.deref()
> +    }
> +}
> +
> +impl<T: Send + RcuFreeSafe, A: Allocator> Drop for RcuFreeBox<T, A> {
> +    fn drop(&mut self) {
> +        // CAST: `ManuallyDrop<T>` is transparet to `T`, adn `RcuBox` owns the object per type
> +        // invariants.
> +        let ptr = self.0 .0.as_ptr().cast::<T>();
> +
> +        // SAFETY: Per the invariants of `RcuBox`, `ptr` owns the pointed object. And we are not
> +        // going to move it.
> +        let pin = unsafe { Pin::new_unchecked(&mut *ptr) };
> +

This part needs to be:

        // CAST: `ManuallyDrop<RcuBoxInner<T>>` is transparent to `RcuBoxInner<T>`, and `RcuBox`
        // owns the object per type invariants.
        let inner: *mut RcuBoxInner<T> = self.0 .0.as_ptr().cast();

        // SAFETY: Per the invariants of `RcuBox`, `inner` owns the pointed object. And we are not
        // going to move it.
        let pin = unsafe { Pin::new_unchecked(&mut (*inner).value) };

Fixed locally.

Regards,
Boqun

> +        pin.drop_before_gp();
> +
> +        // `needs_drop::<ManuallyDrop>()` returns `false`, hence `kvfree_call_rcu()` will be called
> +        // and free the underlying data after a gracer period.
> +    }
> +}
> +
>  #[kunit_tests(rust_rcu_box)]
>  mod tests {
>      use super::*;
> @@ -218,6 +264,13 @@ fn rcu_box_basic() -> Result {
>  
>          drop(rb);
>  
> +        let rb = RcuFreeBox::<_, alloc::allocator::Kmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
> +
> +        assert_eq!(*rb, 42);
> +        assert_eq!(*rb.with_rcu(&Guard::new()), 42);
> +
> +        drop(rb);
> +
>          let rb = RcuBox::<_, alloc::allocator::Vmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
>  
>          assert_eq!(*rb, 42);
> @@ -225,6 +278,13 @@ fn rcu_box_basic() -> Result {
>  
>          drop(rb);
>  
> +        let rb = RcuFreeBox::<_, alloc::allocator::Vmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
> +
> +        assert_eq!(*rb, 42);
> +        assert_eq!(*rb.with_rcu(&Guard::new()), 42);
> +
> +        drop(rb);
> +
>          Ok(())
>      }
>  }
> -- 
> 2.51.0
> 

