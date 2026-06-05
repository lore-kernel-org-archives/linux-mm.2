Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66942CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8E96B0096; Fri,  5 Jun 2026 09:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C286B0098; Fri,  5 Jun 2026 09:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15CEA6B0099; Fri,  5 Jun 2026 09:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0189C6B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:35:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6D7512010C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:35:59 +0000 (UTC)
X-FDA: 84845957238.02.E70BB42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C85C1C0014
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:35:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lXVXqKQU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780666557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KosL0D3Q2eEjvojKVK/tB6tB4IEDd35FarHmws6fUs=;
	b=vaXm+ki0tkLmlxBS3sGuEfn5gQGEhY4rCQjDULZlfmiQwAQHQTqGWolIDW0h8c/+uQjlyt
	m0AR3N4iltMz1tquHRH4EYX1WbaTJzKBVXRMBiRNRBSO3nhSjf81iFPuVGy+IBPX9jvaf/
	IiT3689ZKhN7vlCPXZYeR8Q+aZfaAvQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lXVXqKQU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780666557;
	b=OwJvqdtufBs256tpskJX6IeZfKy7cGvpYI5NztQDk8wYosXwa/UWw8A0JPTWBx+EmuH9qc
	afw+0ikA6ecWO8NFeRxyrDmy9ZYmqeK8DVxhsGmWP9HHrLbYm53X8NDDjTc8X9HeEkpJX2
	9xjUYFnhow4Xk7wXG5j+9DckCgyEsgQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A11143B4C;
	Fri,  5 Jun 2026 13:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618CD1F0089F;
	Fri,  5 Jun 2026 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780666557;
	bh=3KosL0D3Q2eEjvojKVK/tB6tB4IEDd35FarHmws6fUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXVXqKQU/sP/FRbSGZUw52acvlgIharWh19NaZUaft+jpptgVn7wpE+l1Py6LbksH
	 5yW9iK06yCralSUxHMWDfgKlmDZyubI6ImpHprLY0j4elpQCyEuw/GDHfv5YdmvhSc
	 6YICmB+FjlBC2e5GHGz7uViHP8MCXuRunpGroN6HKOo4emRSL8mj3znxf8spKEIASW
	 lRjM9FYzCbmSmFPW6nW2Jpyqn619h5P15VJVsTeQyqkj7vc1+tK8SCpBTz2lsKnvVw
	 0C9YUz5wZ0diAnzZRNCY6cTFwLFg6WDDVhfbvLWO12unifOEjP1oYtNp5NZBUF3NBI
	 o+v2fwOmPz1jw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id AED08F4006F;
	Fri,  5 Jun 2026 09:35:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 05 Jun 2026 09:35:55 -0400
X-ME-Sender: <xms:u9Aiatz7fC6Uiq7nZ1R7wx_ka2cqH0N3cI8uGYyXu3Etp_dWRdSD_A>
    <xme:u9Aiaptl3u8DLV-U7aiymh0k4SSKdgFmH6iXLNnKuasD3jlbXrO7ucnwaKgHWaza-
    YKLWrt4LJAFerutk3UUTPBgfVK5aAuYNO1J-LOJ5f6fbadZwCRArg>
X-ME-Received: <xmr:u9AiaunPvBDojcieXkzavLY8XaQ7CEilWFmqDcGmb4iNuQ_Pp1zV-hohNsg>
X-ME-Proxy-Cause: dmFkZTEiXmK80I+r4b+5zY/r99GUAlO/A1JeBVvrzdPJND7AxnXROcGIdrV5+IW/GIICbk
    HTeSUzo2jG7T3ubuXDYawvMsJmw7SeRzXaVjmYhKpesaWDi/jHlBwDSw7cUJtOL4Zml+HR
    MdH91GjghnCvkbpZdNzjjo1bSZDmeAE+i20ut4ugSeq7SenIcQ9DZOfghRt4xUUc5uh5PM
    SgAN181ZxF1oco7PoJ9ho3wb1kPOXsEzQT5UZv0CFFx1JIqpGEiANmmsdwoALURinC3es0
    +e8I9nc2247wfagtNBtbgyVV8BvBRc03DGsTzzDlNTrxNmxxQ9+IH7k1Xg1Flh6mzaY9AF
    F1Rbx4zjkpU7Vu9L15KSs/58k3UtTFycBLbXnKzW7G3Az8oIg8YJ7B1llLRzq9ZQymYw+g
    2fPji44Zl+dmnKR9uYe/gkEuH7gJ9937pSdsAM+jHiIhPy6/Q3Ya1wrMQnGQgK/yBtLMlz
    YUObbhrUwbZHNvplmabTTmM68ir7kNT02nLZMMPNC7GcsuPZ3JhN9G4NGFO8U2/zbN2LhN
    qlb41qjjYJSqfOr+cv1dH5tLNyYc8aMoVJZIMB9KUDldh4Ho9IlsJ2x/ZYZJl0fSmk1QXV
    FZ7uk0R3q0t0R5NcBwbJCLKAGRtG8d3QOaxly+IElSGTUJZLozO/dAinufEw
X-ME-Proxy: <xmx:u9AiamD4UDmWZULEwOXX6kUa4m-RKPJ2gKC2_ZKbWvh3GfsjPdxQcg>
    <xmx:u9AiavRlA7NXvc3k10piDayBpU9e26V10MWj2hj9GdWq45ID2KK_Vg>
    <xmx:u9AiauKXezEOmm4JIOljUPJuLHZhmnboER_EqJTtPjIELzrCV948Ng>
    <xmx:u9Aiag2sTvHw_Kg1pJMquodYYQRl4UHFTWF1xbSlXGyKhGYlfVd0gA>
    <xmx:u9Aiaity2fCjPhfZZs-zW4F7f6ioSM7Rlfw4g_SidPxLEeReZhpzrY0w>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 09:35:54 -0400 (EDT)
From: Boqun Feng <boqun@kernel.org>
To: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>,	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,	Trevor Gross <tmgross@umich.edu>,
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
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	maple-tree@lists.infradead.org,	linux-mm@kvack.org,
	linux-media@vger.kernel.org,	dri-devel@lists.freedesktop.org,
	Philipp Stanner <phasta@kernel.org>,	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [RFC PATCH 3/3] rust: rcu: Introduce RcuFreeBox
Date: Fri,  5 Jun 2026 06:35:41 -0700
Message-ID: <20260605133541.22569-6-boqun@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605133541.22569-1-boqun@kernel.org>
References: <20260605133541.22569-1-boqun@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: scdfgcc9r8r9ktepma4fayirwoxhn11g
X-Rspamd-Queue-Id: 9C85C1C0014
X-HE-Tag: 1780666557-992533
X-HE-Meta: U2FsdGVkX18yRUWpxzqRcYccOpaFjviYsK/2xSxWGy6WPWofTDo/ZUSfXVGTWhA0NW/HAnEQcUZzBvmJP3iWjPBhF999jLlLFlQEyNxjUf7wCogXSq+eGVtnuJZJbOVRbq8bPB+hTaQPE2ivrj1kLA0Wl7umjUnpJoonEH3xjY1+kIChwbh3c/bKcLEZJ8VdvOFDc1tUzDWw6ZUqTBWkzqQLz0titHQh+FTmp5/QYaM1D3JT8Wg0/cYFmNDXWJeeUBR5agPgEzkSaHitSecHIH02hfeU51dW2bAciVM8Pbp3VJ+suoCbpc3m4kbCaYHAvUaYbMZpE6aQYmpqxY54Pyn207/MC6QcB7beUk2+vv2TpIPk6mIqqUmo9wmwNU88PiN5PiBT54erVceNEP2g+AWYL78bokdCguoZSRBA1eDTrxU/vODXAuc4CCg8LvlfGAshdXMml2drlPi50eDP5smINCxiz9b7xhx/h1cGdSQAePZaAt01IlrL1X9RhXdyoE7Cm4x9e8G7xWSjAFY5y1IOsU5cbvh3Z2d34LT7aKX4xwp8dLZZ1kaSDSVPVR/HCmlBR98qpMDMEleDtJOxbLgvqu0P4TyPerAzQbAoxY6/oMFSzVm0pz75/yZSg5Vhd/FSuKdXK6mJMxjSraQQro0BDEop4ahhVAfs6aF3WTTXqfTB8/nvK/7vcNyLs5puUxv+2WpQO2hFDH4aZ/VkmjUrw/q77fh4XXmjbcGxBOiZNyrGeTllfKqhKYBPzQ4UFshNgDj0dICDSb7bR5uddg3FMOLbqtCJOIA4NhnPt5i0OExTAN5XHmfs8nRoIgj9Q85pTsI275fDehioaZQe+Zp8vTsWty0G0ywqSxJNWkF3QngpG3cEf7dXZEtdS+neE2QRku/RfxReoZOwFSOfYXmru7zQ/6WevqDUQqsYnW21pW5SrtN3iRzWYES/phXE1Fup4ieDg1JCGHJDn1p
 OpENTggA
 Hf408QdCnXYesH4cN5bH3Bn1Vad/Ao732zqqtPA+ASTSeZ2hJZk225iP34eYwVQn3PxOlCjFhyQVYgp030dRzNo81qm1SrgauHdHyhJgNvxQmnlz5l2CedYOrDJeZyrHj7sX93pMb1eXuSa+okNYRcTmmLjw9omjoAvbiiBfef7TwLD0d83X2rgZCG31VjaW4VyrdQK5qSNir9U+hHmbv29DQOFID6eJ6WCQwUPoOhCTU+lrseE9ik+9NCBovCvw0ZpTE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current RcuBox will call the `drop()` function after a grace period
inside an RCU callback. This suffices for maintaining a RCU-protected
object:

  RcuBox::drop():
    call_rcu(
      |..| { // <- call back after one grace period.
        T::drop(); // <- call the destructor of the inner object.
      }
    )

However, to support a different RCU usage pattern as below we need to
extend RcuBox:

1. clean up the object, and unshare it from future RCU readers.
2. wait for an RCU grace period.
3. no other RCU readers, we can free the memory.

An `RcuFreeBox<T: RcuFreeSafe>` is introduced to provide support for
this:

  RcuFreeBox::drop():
    T::drop_before_gp(); // clean up and ushare.
    kfree_call_rcu(..);  // free it after one grace period.

Signed-off-by: Boqun Feng <boqun@kernel.org>
---
 rust/kernel/sync/rcu.rs         | 31 +++++++++++++++
 rust/kernel/sync/rcu/rcu_box.rs | 68 +++++++++++++++++++++++++++++++--
 2 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
index 7da6b8d22277..7c26591bb318 100644
--- a/rust/kernel/sync/rcu.rs
+++ b/rust/kernel/sync/rcu.rs
@@ -4,6 +4,8 @@
 //!
 //! C header: [`include/linux/rcupdate.h`](srctree/include/linux/rcupdate.h)
 
+use core::pin::Pin;
+
 use crate::{
     bindings,
     types::{
@@ -82,3 +84,32 @@ pub trait ForeignOwnableRcu: ForeignOwnable {
     /// [`from_foreign`]: ForeignOwnable::from_foreign
     unsafe fn rcu_borrow<'a>(ptr: *mut ffi::c_void) -> Self::RcuBorrowed<'a>;
 }
+
+/// Declares a struct is safe to free after a grace period if all readers are guarded by RCU.
+///
+/// # Safety
+///
+/// Implementation must guarantee `drop_before_gp()` makes sure no future RCU reader will access
+/// any part of [`Self`], as a result, after `drop_before_gp()` return + one grace period, no RCU
+/// reader will be on the object, and it's safe to free it.
+///
+/// Notes for implementators: implementing this trait in general requires `Self` being a
+/// [`UnsafePinned`], i.e. a `&mut Self` is not a noalias reference if `Self` has non-trivial
+/// `drop()` function.
+pub unsafe trait RcuFreeSafe {
+    fn drop_before_gp(self: Pin<&mut Self>);
+}
+
+macro_rules! impl_not_drop {
+    ($($t:ty, )*) => {
+        // SAFETY: Dropping `T` has no side effect means `T` is always ready to be freed. And an
+        // empty `drop_before_gp()` suffices.
+        $(unsafe impl RcuFreeSafe for $t {
+            fn drop_before_gp(self: Pin<&mut Self>) {
+                $crate::const_assert!(!core::mem::needs_drop::<$t>());
+            }
+        })*
+    }
+}
+
+impl_not_drop! {i8,u8,i16,u16,i32,u32,isize,usize,i64,u64,}
diff --git a/rust/kernel/sync/rcu/rcu_box.rs b/rust/kernel/sync/rcu/rcu_box.rs
index 943fe3e8974e..8f52bb472daf 100644
--- a/rust/kernel/sync/rcu/rcu_box.rs
+++ b/rust/kernel/sync/rcu/rcu_box.rs
@@ -6,6 +6,7 @@
 
 use core::{
     marker::PhantomData,
+    mem::ManuallyDrop,
     ops::Deref,
     ptr::NonNull, //
 };
@@ -29,17 +30,18 @@
 
 use super::{
     ForeignOwnableRcu,
-    Guard, //
+    Guard,
+    RcuFreeSafe, //
 };
 
-/// A box that is freed with rcu.
+/// A box that is drop with RCU.
 ///
-/// The value must be `Send`, as rcu may drop it on another thread.
+/// The value must be `Send`, as RCU may drop it on another thread.
 ///
 /// # Invariants
 ///
 /// * The pointer is valid and references a pinned `RcuBoxInner<T>` allocated with `A`.
-/// * This `RcuBox` holds exclusive permissions to rcu free the allocation.
+/// * This `RcuBox` holds exclusive permissions to RCU-free the allocation.
 pub struct RcuBox<T: Send, A: Allocator>(NonNull<RcuBoxInner<T>>, PhantomData<A>);
 
 /// Type alias for [`RcuBox`] with a [`Kmalloc`] allocator.
@@ -205,6 +207,50 @@ fn drop(&mut self) {
     drop(unsafe { Box::<_, A>::from_raw(box_inner) });
 }
 
+/// A box that is freed with RCU.
+///
+/// Currently we require `T` being `Send` because of an implementation limitation. In theory we can
+/// support `T` being `!Send`, since the RCU callback is only used to free the memory, not dropping
+/// `T`.
+pub struct RcuFreeBox<T: Send + RcuFreeSafe, A: Allocator>(RcuBox<ManuallyDrop<T>, A>);
+
+impl<T: Send + RcuFreeSafe, A: Allocator> RcuFreeBox<T, A> {
+    /// Create a new `RcuFreeBox`.
+    pub fn new(x: T, flags: alloc::Flags) -> Result<Self, AllocError> {
+        Ok(Self(RcuBox::new(ManuallyDrop::new(x), flags)?))
+    }
+
+    /// Access the value for a grace period.
+    pub fn with_rcu<'rcu>(&self, read_guard: &'rcu Guard) -> &'rcu T {
+        self.0.with_rcu(read_guard)
+    }
+}
+
+impl<T: Send + RcuFreeSafe, A: Allocator> Deref for RcuFreeBox<T, A> {
+    type Target = T;
+
+    fn deref(&self) -> &T {
+        self.0.deref()
+    }
+}
+
+impl<T: Send + RcuFreeSafe, A: Allocator> Drop for RcuFreeBox<T, A> {
+    fn drop(&mut self) {
+        // CAST: `ManuallyDrop<T>` is transparet to `T`, adn `RcuBox` owns the object per type
+        // invariants.
+        let ptr = self.0 .0.as_ptr().cast::<T>();
+
+        // SAFETY: Per the invariants of `RcuBox`, `ptr` owns the pointed object. And we are not
+        // going to move it.
+        let pin = unsafe { Pin::new_unchecked(&mut *ptr) };
+
+        pin.drop_before_gp();
+
+        // `needs_drop::<ManuallyDrop>()` returns `false`, hence `kvfree_call_rcu()` will be called
+        // and free the underlying data after a gracer period.
+    }
+}
+
 #[kunit_tests(rust_rcu_box)]
 mod tests {
     use super::*;
@@ -218,6 +264,13 @@ fn rcu_box_basic() -> Result {
 
         drop(rb);
 
+        let rb = RcuFreeBox::<_, alloc::allocator::Kmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
+
+        assert_eq!(*rb, 42);
+        assert_eq!(*rb.with_rcu(&Guard::new()), 42);
+
+        drop(rb);
+
         let rb = RcuBox::<_, alloc::allocator::Vmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
 
         assert_eq!(*rb, 42);
@@ -225,6 +278,13 @@ fn rcu_box_basic() -> Result {
 
         drop(rb);
 
+        let rb = RcuFreeBox::<_, alloc::allocator::Vmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
+
+        assert_eq!(*rb, 42);
+        assert_eq!(*rb.with_rcu(&Guard::new()), 42);
+
+        drop(rb);
+
         Ok(())
     }
 }
-- 
2.51.0


