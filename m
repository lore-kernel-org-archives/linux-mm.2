Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF5FC44521
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 05:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2694A6B0143; Sat, 18 Jul 2026 01:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218636B0145; Sat, 18 Jul 2026 01:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092896B0146; Sat, 18 Jul 2026 01:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACE436B0143
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:33:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E2A9A0956
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:07 +0000 (UTC)
X-FDA: 85000778814.04.C2C0A97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 20A33180002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fU1ozw21;
	spf=pass (imf16.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784352785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YumMbTuFN39udjMu2dZ9HB8drw55p7kF/M9QUGWthnc=;
	b=xL9dTX2qZcs97nIyfN0+RbQu16Qz3zH3OlCofN/zlXyvvofeEAxZmcTMKgJMtq+OOYyDo0
	R3Tg+XIIYbl3++TB2peKWXEkEYW0fGGIXkqicdjc3mZrv8PGoo4wxcoqIV+Z54CUcVwXEj
	4U7ilNU/x4Gd8Y1bq31bbldBWdZkGLU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fU1ozw21;
	spf=pass (imf16.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784352785;
	b=x+3r/tK+9t33/aG4ZMmogURUKghrGAm24egLz5C0+7WEypFJoDB1dK/Gzo4duTqh6egtrx
	ssKrit0cB6qEm498hvAv7SI0aqggm6FEfhLJlWY5Aqb74pBRfpBRdse361vjzYeAuKOiy1
	wU5DVlMQX+5Uq3jINKdt7eQvs/yA2Do=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1210600B1;
	Sat, 18 Jul 2026 05:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F02A1F00A3E;
	Sat, 18 Jul 2026 05:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784352784;
	bh=YumMbTuFN39udjMu2dZ9HB8drw55p7kF/M9QUGWthnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fU1ozw21g3OiLiw32hofDBp594Bnbsf4fggg3vRf2B3N20vySW14GDyXM3Zd/55Ok
	 BmJK5lEN2a99FJFR76Qi3qYkDMDW3cHPMF8Bvj8jMoQV9iSH4/6LBnBLYjyOC79N5R
	 xJMGDMUaJLqd4falmtUhigxSUtYOVjqdrtuzz+7aYaGkqC1atbUT8mFPrGJ6UE2Y0z
	 RxaOO2ZGETbyVDjQTdX9lP7YHALngdas1wuaWSXYQ2PeB39r8ikeVge1fjNQ8Uw7L3
	 VuX21L+Cz0hlaj+NgKXsQ29XGBGKGJ5NeRxFeU9ygADtXeSGVUXNqV51RZqQOduFFk
	 SaAbYGWIhwReg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 910F2F4006A;
	Sat, 18 Jul 2026 01:33:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Sat, 18 Jul 2026 01:33:02 -0400
X-ME-Sender: <xms:DhBbatM3cbC7GrwtQUl0vocmFrHvculOiFCpIsBBbGD6YAOE3OC2Xg>
    <xme:DhBbapwxMJfbKkCXXwpVS8LswofOh42yBgmjkIXFquKH2JLgBdvuj_hkT6ikp-Bh2
    aPMC89sZ-u47djPsXryZlegfuaq-9k26SH2z9e1wnYKVRriEt1Eig>
X-ME-Received: <xmr:DhBbantEqoOjClhPKhdV2QArNaDA5R_SHjWuf-9deQkEKQ5SfQ8d34TAMDjWuu2uJZFIuzWEK5tuMeMglPaMsoxpDFFKytgC>
X-ME-Proxy-Cause: dmFkZTEe1tEuSFJRyejgcADWwC1Q31VcIulMbzlwxQxSwM7p7NELQtXxoL4t9u3P3h6szL
    wb7v4Y1Nfd9PJf44pRYto2n4BU3w63GmouT4LNR6cMb94hByhC4T19UClHqFpzwzazj5Vf
    A8YkKW1UUR0TJ8dV49ki0VbHb8uMKM6KId0g8EWioE2qFZQpDctdLDeip2hFqPq5d3ACH5
    qO7/M64UwGhfkVp49Uw1mz7RUEmunGbHxCq20xcQsFHR4VpiWV6KRY8BvJYxsbWtxpbsKA
    SwMJCFL53Iue2y6cUSY74fyEj9Wo66A5FNIdAV9MLOMsDNkZ9FUjwGTU+R2pAhU2dl3BiV
    3I6CxXPrsaR7ob/+XwDdwE1bYBvmRiUsRk7/rUs+UYDvdKLKB7I6Eu1kIAIIDcE1+a4imU
    YHcJetBuL/vOAIOYwH6aaoJDy+GJIhenv+zw/dHzAIgAqqJYpd3e5O78/+ODcs2txRksBs
    Ewqmdqb5NZoKU++D/70ThHKygiJvh5+z3zklLGIVDfh1OjUh01ut04C68MFuC2qz3KMABj
    JuDPLErNsJpKDu8I1saGiCQEKmgO8R0Vw8A3yJBeComoPpSEVZJI3K6KXgBdSdFOGDn2KY
    d8uzNvMiS6CBun5S29KMsO3+5Is6UApvD+5wrf+PGpBpTm2rIsuZVK74ylLQ
X-ME-Proxy: <xmx:DhBbamE1H_E4VSkLK1ClXlVpr0JFDhePHIbXv02ng2wMqlt_5daqrA>
    <xmx:DhBbagWmIV_OnQrFhiITWokgAMxhQslsij1XL2GTuOLTBnzokRR1kA>
    <xmx:DhBbap1B9dUEAnsuJRdSaUz-kBKiOpySNcbwKBTWwRanFsTCi9cZHw>
    <xmx:DhBbanBNaDl4rQ1nSlCQUGKlC-43JV1X2DWRbkqeO7gWjwbvnSXuYQ>
    <xmx:DhBbavC0AmwD1PztAYBUfpPwWmatjtViYgpBBU9U4LhJmhkJvlbb7Hhc>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Jul 2026 01:33:01 -0400 (EDT)
From: Boqun Feng <boqun@kernel.org>
To: rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>,	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,	Jan Kara <jack@suse.cz>,
	Lyude Paul <lyude@redhat.com>,	"Paul E. McKenney" <paulmck@kernel.org>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	Matthew Maurer <mmaurer@google.com>,	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,	linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org,	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [RFC PATCH v2 3/4] rust: rcu: Introduce RcuFreeBox
Date: Fri, 17 Jul 2026 22:32:46 -0700
Message-ID: <20260718053247.25154-4-boqun@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260718053247.25154-1-boqun@kernel.org>
References: <20260718053247.25154-1-boqun@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20A33180002
X-Stat-Signature: byp71hr9mf9y6ydqyx7mhj55n18erf68
X-HE-Tag: 1784352784-659869
X-HE-Meta: U2FsdGVkX18aBvUgGiJtXVd4OrXsh29LaPSVZ0WGpMW8+sdytTpLyO3Aaxfsyl3AvA7T/Ys4/A50UFu3IkhMrtKihxHzvgic+ch2V1SU9XiTUDf3KLUpO1Jqon8DcULJhtKHd/eoFr5ZxZR9l+sE+ifFOryH+n7kBJT1o4BpgvaXXgBUc53sig0LpS9arhARbG8EH8HTcFw6RREviCyjhhXzKxkhoRba7FiuZxEZ5M8qECBEBGiBHlqjN8t3olMrthFc99Jk0woCIXLJ2tMil+qo4vP6o8GA8+pnaBDPPaOwaDMo3ydm9/vIXGLGdkfMXWchgbSAN8z23jgWILB5uiAy3IAAvhImX1UMA1C4E0vw+8mXpXM6jn1veFzMViUPlByva45w6wzSZEyHjg1ShT51jaP8XAkS9OMU8MjVNV3aIp/dhyQu9L8b9vlnt1RO+W7JMFKFoGF7OLuy1+gbtmjFBhU74O/L1GDqTlm3w57IZLiflo0AM910coFrSF9b9kfR0o4nVM6am/pAOphhB9DvmB7XEgYjE5cKRuL9uw18kZIlVRQQEIk6X/Dvukfh3ZhiHFjb/My4rVsl2qbgMq/Pl29IUlTfQsSkJx0bA1OXFYgMJvbTegTdrbIrs40Wlvkw40WmMLxu6TYlaZ1fCkMDvHMQuL2Q+yeYHI2Wt/ID2TzV5RxRq8+DV+zl32ZzxAiGqhVxqFu7JzvkXvfnLNulv5ERPCSdsMX+riEiQpr927kvSitn5+NPZwkIbAQ7h4yICWSavW+7M2rHJETQD7JulsY5Noqu1bXJcpUkeyz8DXcgWhnp2ZZ2lfMAZKiucb7FjY2bgRjJhv0oEjGPuXcn7DRt2z8MxdzZhNyT6e3pKVM8Q1UC6yochKyE0HhWz18MgkGz5Wc+cfAycGIq/4wlRQPC27AUHe3EjhC09UNXPn/Yaz4+T0IrtTMSTb6kySZ2oLBTjEQld+62A6q
 g4Y4dbeY
 Nn8sVLmUJfxcy+tTXWVuKMLamG7CIIEz6Dui9srDSLkefPFHTcucECqNjBN+jpyKLh0Sh++te0HsIluqZWwGhj4feM6j+zSVapwOI/E5QoJaypkIKf+t/X5ZA/OFXyMtfPfEBfSvskabHmprgM/SED3+5+1xZH9ivp+jjC9gpXEGZVRcVb5mf4+XFoTuUOBHm444lZsvVh6iglzkPmeIIKWRIZyqJtC1X2lVVwXeSnA68qshfAR+GSFKAYT1esCQgfRG1BQJCQSQtprbUW5YRf9mWXPNESt7JLkWT72dLwdfEnFD/jHuGlIboJm3z6+tYUv4TrbngXbbGPvk8mG08py1Q9yrrAw6iZgcdhZW6vpvkCTx5n4EyNKgy8w==
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
 rust/kernel/sync/rcu.rs         | 34 ++++++++++++++++
 rust/kernel/sync/rcu/rcu_box.rs | 72 +++++++++++++++++++++++++++++++--
 2 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
index 42f6bbc83f71..e781a5044de9 100644
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
@@ -18,6 +20,8 @@
 pub use self::rcu_box::RcuKVBox;
 pub use self::rcu_box::RcuVBox;
 
+pub use self::rcu_box::RcuFreeBox;
+
 /// Evidence that the RCU read side lock is held on the current thread/CPU.
 ///
 /// The type is explicitly not `Send` because this property is per-thread/CPU.
@@ -100,3 +104,33 @@ pub trait ForeignOwnableRcu: ForeignOwnable {
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
+    /// Clean up `Self` and make it ready to be RCU freed.
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
index cb1fd422480a..ab4e9b2a4444 100644
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
@@ -223,6 +225,56 @@ fn drop(&mut self) {
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
+        // CAST: `ManuallyDrop<RcuBoxInner<T>>` is transparent to `RcuBoxInner<T>`, and `RcuBox`
+        // owns the object per type invariants.
+        let inner: *mut RcuBoxInner<T> = self.0 .0.as_ptr().cast();
+
+        // SAFETY: Per the invariants of `RcuBox`, `inner` owns the pointed object. And we are not
+        // going to move it.
+        let pin = unsafe { Pin::new_unchecked(&mut (*inner).value) };
+
+        pin.drop_before_gp();
+
+        // `needs_drop::<ManuallyDrop>()` returns `false`, hence `kvfree_call_rcu()` will be called
+        // and free the underlying data after a grace period.
+    }
+}
+
+// Note that `T: Sync` is required since when moving an `RcuFreeBox<T, A>`, the previous owner may
+// still access `&T` for one grace period.
+//
+// SAFETY: Ownership of the `RcuFreeBox<T, A>` allows for `&T` and dropping the `T`, so `T: Send +
+// Sync` implies `RcuFreeBox<T, A>: Send`.
+unsafe impl<T: Send + Sync + RcuFreeSafe, A: Allocator> Send for RcuFreeBox<T, A> {}
+
+// SAFETY: `&RcuFreeBox<T, A>` allows for no operations other than those permitted by `&T`, so `T:
+// Sync` implies `RcuFreeBox<T, A>: Sync`.
+unsafe impl<T: Send + Sync + RcuFreeSafe, A: Allocator> Sync for RcuFreeBox<T, A> {}
+
 #[kunit_tests(rust_rcu_box)]
 mod tests {
     use super::*;
@@ -236,6 +288,12 @@ fn rcu_box_basic() -> Result {
 
         drop(rb);
 
+        let rb = RcuFreeBox::<_, alloc::allocator::Kmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
+
+        assert_eq!(*rb, 42);
+
+        drop(rb);
+
         let rb = RcuBox::<_, alloc::allocator::Vmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
 
         assert_eq!(*rb, 42);
@@ -243,6 +301,12 @@ fn rcu_box_basic() -> Result {
 
         drop(rb);
 
+        let rb = RcuFreeBox::<_, alloc::allocator::Vmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
+
+        assert_eq!(*rb, 42);
+
+        drop(rb);
+
         Ok(())
     }
 }
-- 
2.50.1 (Apple Git-155)


