Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE4DC44524
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 05:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D653D6B00A6; Sat, 18 Jul 2026 01:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14CD6B0141; Sat, 18 Jul 2026 01:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDEF46B0142; Sat, 18 Jul 2026 01:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0F76B00A6
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:33:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD439401AC
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:02 +0000 (UTC)
X-FDA: 85000778604.15.5FC3D48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99678A0005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LuAm/eZW";
	spf=pass (imf15.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784352780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siyOnS6l4OgE+SqBMQ+V/Oxq7Qn3CqbcWz13kbHYzvY=;
	b=ra7G0QwsddDwP7nmdwU9MqQsKdvVMEDz83bzLtPkeA9DO90IsLD0uNFyLRQTRktxIPSMgd
	2jDiQu+SdnGnZgftM2JXHi3XJPx/b+fQJHWBwmpxnqNqskEmKRU+LbfZroGDsS279dGfUi
	aZEvdLLEoW5ifR+2gz31mv21H0FALh0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LuAm/eZW";
	spf=pass (imf15.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784352780;
	b=NYptxJzTqLDJoVGF1kqU5AsSNZSmKkm0ov7jwqIUTO24A8OXQn8anIf5Kl/2fZ9yXKIFft
	aDPBPNQ5t6WwVnzaTuOVT7uROeLOl2eB5REjxqxzqJ65o0dyyfjZGFQtP2ZRqlU6ROjRlB
	OTqNyMc8BvJH3woJgY18DcYM1ytkcw4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F57645180;
	Sat, 18 Jul 2026 05:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015831F00A3F;
	Sat, 18 Jul 2026 05:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784352779;
	bh=siyOnS6l4OgE+SqBMQ+V/Oxq7Qn3CqbcWz13kbHYzvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LuAm/eZWD7/asTYwGGHjQla5wF7zdbYTWEDTOJizwNsZJLFi/sxjExNO1OJhUp1/8
	 EpTzxCSUXwpmLXkvJlQieQdLJiFgyDBDxZWXumLFrPWbufhiNw+mC4VW9/qFIPiTKw
	 K5dhTCG0HyCwbbNr9TIU+oApgo/vUxvXUhoRt2TBZ8Y5OwrUJUo/RifwjOFTzBWkGk
	 H9imvG+WKWk25X4xN3hk9v+pCznv7mhMQnbKGyZsn3+BX4BHfI8z+bHYKD2ki6B4LU
	 9VgHrpC2mXlmtwC6vEWyi4TNWeAPDxirEJfQGf7jGNpjOpPYgt/s6GE9PypnPvv8FL
	 A0a0gIg+9KuXA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 28E26F4006A;
	Sat, 18 Jul 2026 01:32:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Sat, 18 Jul 2026 01:32:57 -0400
X-ME-Sender: <xms:CRBbal0f4TF1GOEeTKlAucxG3TgzTOXYfgpLSEPu59HI6Tc8GITuNw>
    <xme:CRBbal7DE12LmkHccLlpQ820yjKfEAARY9Oe80AeG_xkxhn126MxlmkcO0KCFyd4L
    TSmMfk63SWs6t3ipV9tWTp23RzBwRBBwoL_Lor1MqkZIUdoddKwvw>
X-ME-Received: <xmr:CRBbahWgW9Xkr8UqRbTsHe-5_P0teLekAC6T63o_xMq9R0IABzgJUr6C2b6RfOxKNackkdYI_zV7NTTFQnXKZCN1MVtuFZGE>
X-ME-Proxy-Cause: dmFkZTE3j4lQBeju3HcweDJLEhgBazSdYdANC00q2qr0s4koYeBtdPShv70v8pi3tGI1gb
    rI8gxibm6pg/EQlIbC5FCYfXYVoSlDO/lTkmwnSzTVXyDHp0bfUhA0XAFwbqJvrGefhv0r
    XUnOrITJ3N4nqMI0h7+jzGq32g0S5vfV61f6E12mCvHFBAfvexQj6fIzJszAZ9rfBYqYfO
    T6OIfII3tTQkjZZVd1g1QAoU9kPbui+CHn/TMFHwriLkDlU60ZMdQktApUZbVe8QEyUYr3
    jVEpI07EG25Rz4jWtBQdqLQWlPbWtXp4KaGcuyKCPxFukwJtrryv/3hqo9da0SnjgWsXR5
    r634v+PE6k1OOxPqJGPC6mLQ2SHFvEjMbkLTHDB2JAngHD5Xb2TlmvMt5+deZLEFky8MTp
    +pZ6vDgd1ct7pb24/9mOaEE4bzmFLaxvMSjZqNWGE36StaJFzQ7OhQswbLfkdihoypCLJO
    wVah/j4nT8Tv8JoxYMGrX08FYk3Vu3BOCb5PlbFyBTIg+gmWbN7az9X0FdnG6gtttdtOSO
    ZfqnYHBkPgYnV2p1bQV0o85xip/4UU1y5gZplGT/oIUI0zqVr4nfnYtzGq9aRg4Pkk4A+b
    gMq2pVnWbONZT/jamHXyJA/y6YTQ11zB6QsVeP78ZsiyEKnUDmeC7sew4kKg
X-ME-Proxy: <xmx:CRBbavOR5w-PE2hjaET1N4mC_rEQwwAXGpoQV6--Xu6qZru9JXrrVQ>
    <xmx:CRBbai88NHAJBu7GuF625FZR16YZM_J2opngYukSyE86TOhFeHLniQ>
    <xmx:CRBban_tgKioVBwNrKAOkaex0m96IQEwTvjwWys4XCt3zC5MyM3O3Q>
    <xmx:CRBbaqqIpcuB7cwxNDqP7OpfgefvXVsdQy2-PXWB9jtZDaraJXJG5g>
    <xmx:CRBbaqIIw5gxJkKlso4-urSnPIlQAd_vIOUxQ8t-etRXm5ML03IbFEN6>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Jul 2026 01:32:56 -0400 (EDT)
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
Subject: [RFC PATCH v2 1/4] rust: rcu: Add RcuBox type
Date: Fri, 17 Jul 2026 22:32:44 -0700
Message-ID: <20260718053247.25154-2-boqun@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260718053247.25154-1-boqun@kernel.org>
References: <20260718053247.25154-1-boqun@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99678A0005
X-Stat-Signature: kep8pghmfn3nm7izyx56m1wofn47y166
X-HE-Tag: 1784352780-763027
X-HE-Meta: U2FsdGVkX1/Pwk1EYR5Jn12oXBG5q5pXe3ONZAzl/Pub8UIVsHoEijiEDVzIQUUEfE+DTegcZk2dVGpsvTTKD2gRiru25u1NqaddWt4lGg4SBuKctz5GSwlIRxLcHVIhHvGu7y2S/JtOEqBKXMswwHFHi+ukWXf/znr+O5vdoJ+wrO3z7GUFlZ/Zro0jr+G5W7sjNIf8TCJNI3TawIK+5jfD+Duw6k6t56elI4zh9BMCba1mLmN5U4VsXxp+Ew29jzH/JJx0ZFuT9naVieB17Bel6swNcrpp13S/XCyGwdDDLI49Wc5t4P+jCUFVpmQ8H4tmu3z17zalY219f/do6xDMMoSXTJyk7LyM9JeTSzvQ0pyXTpxyXPV30wrzUTlygTeL123uTQrSzkloYeinnr/RuE0VcYofOCBk209glyzt26X9edJ3rXBVTjr3l3XH8oFTTN09kVorKjJIrtxQi0l2tMNpFmYUK2/jOwVp1WpVbUf/gcx50r0ngb2++o8fyUHTi+/0CuF7LONcq3BXnzmitRYjBW2XefjUh0U3tpKEr3VERVjYMALqOQrv8l8MK6Yh11eLjA3fdw88bwC7eVnfLcLavDPo1/G/6ijzMXaYXlxZMPVV3/h/lRlXW5LM5w1AaYyDooNqpGiY4SBQefTnhkLqVDg9MUtLQ6M6w3FMFgq6sJ5/LGwHBXiwSeZyrjWuGCF/GEZ45ipWZojWRFXgmoBBwmTsqc1th7lcypH9SuXv7hcID+YxCp1+F75zg2eBS/GtBiYm7n3ijYNorVXuAoZQvLATaIvag7WaCgABZ7osMy60VTSzKgFRQr70fNfiS1dPJgCWRxD+1he8lBJ2zAGDJXbzjn0oSDwEpwCFRI88gZyeGSpwT4Gg40+tSXbPYbLXBNMi0xme5CvvWyJrwrYx8WNbwncFfbptEqjXRE+7hSbUNVAOaETN98hnNtovhs/I5CnMhV+7JKa
 xNNbf+ju
 CFHwjieZC7/bCOAjlDYYp/KoWs9nc4TiPPDeuVOnIMM+JTMF6ay1zlyU1QNkuxIG/mAMm/6XngPM0xvvI3HUGw+GQtXlb1ipDRb3ZRyiFSzSmEB02iqXmMLo7ysbRpYbz/e5B5X/nn6EXwV2+xNJbilpvOtP+OvnyVTzBNPyLaXIIuAqgbXbOzQ8o9HaNFqqvVuOF+nVaQzOB2LOTtkMtcGqm6y1iSB3OvJ+asF1/v18auX7DaPF1qquwkPKvz8Ve1bqVlgmvIxAwIjYy4IorXIwbCffuLYngkHWPEvbvBWq5XC9/73c9qANSxPxr1dy0GCtG+0salwVHdGFaAehQ91L7PHpyp3kbax03cPxdRmyYdWnXjaI5qkp2A6LJccvAC+fNBiUkCeZsV7YKv35hlkRcWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alice Ryhl <aliceryhl@google.com>

This adds an RcuBox container, which is like Box except that the value
is freed after waiting for one grace period (via {kvfree_,}call_rcu()).

To allow containers to rely on the RCU properties of RcuBox, an
extension of ForeignOwnable is added.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
[boqun: Make RcuBox generic over Allocator and add tests]
[boqun: Add type alias for Rcu*Box]
[boqun: Adjust the ForeignOwnable changes on `T` not being `:'static`]
Co-developed-by: Boqun Feng <boqun@kernel.org>
Signed-off-by: Boqun Feng <boqun@kernel.org>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/sync/rcu.rs         |  36 ++++-
 rust/kernel/sync/rcu/rcu_box.rs | 248 ++++++++++++++++++++++++++++++++
 3 files changed, 284 insertions(+), 1 deletion(-)
 create mode 100644 rust/kernel/sync/rcu/rcu_box.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 1124785e210b..3e3f1799a49f 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -81,6 +81,7 @@
 #include <linux/property.h>
 #include <linux/pwm.h>
 #include <linux/random.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched.h>
diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
index 2bae76d229f0..42f6bbc83f71 100644
--- a/rust/kernel/sync/rcu.rs
+++ b/rust/kernel/sync/rcu.rs
@@ -4,7 +4,19 @@
 //!
 //! C header: [`include/linux/rcupdate.h`](srctree/include/linux/rcupdate.h)
 
-use crate::{bindings, types::NotThreadSafe};
+use crate::{
+    bindings,
+    types::{
+        ForeignOwnable,
+        NotThreadSafe, //
+    }, //
+};
+
+mod rcu_box;
+pub use self::rcu_box::RcuBox;
+pub use self::rcu_box::RcuKBox;
+pub use self::rcu_box::RcuKVBox;
+pub use self::rcu_box::RcuVBox;
 
 /// Evidence that the RCU read side lock is held on the current thread/CPU.
 ///
@@ -66,3 +78,25 @@ pub fn synchronize_rcu() {
     // SAFETY: `synchronize_rcu()` is always safe to be called from process context.
     unsafe { bindings::synchronize_rcu() };
 }
+
+/// Declares that a pointer type is rcu safe.
+pub trait ForeignOwnableRcu: ForeignOwnable {
+    /// Type used to immutably borrow an rcu-safe value that is currently foreign-owned.
+    type RcuBorrowed<'a>
+    where
+        Self: 'a;
+
+    /// Borrows a foreign-owned object immutably for an rcu grace period.
+    ///
+    /// This method provides a way to access a foreign-owned rcu-safe value from Rust immutably.
+    ///
+    /// # Safety
+    ///
+    /// * The provided pointer must have been returned by a previous call to [`into_foreign`].
+    /// * If [`from_foreign`] is called, then `'a` must not end after the call to `from_foreign`
+    ///   plus one rcu grace period.
+    ///
+    /// [`into_foreign`]: ForeignOwnable::into_foreign
+    /// [`from_foreign`]: ForeignOwnable::from_foreign
+    unsafe fn rcu_borrow<'a>(ptr: *mut ffi::c_void) -> Self::RcuBorrowed<'a>;
+}
diff --git a/rust/kernel/sync/rcu/rcu_box.rs b/rust/kernel/sync/rcu/rcu_box.rs
new file mode 100644
index 000000000000..cb1fd422480a
--- /dev/null
+++ b/rust/kernel/sync/rcu/rcu_box.rs
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Copyright (C) 2026 Google LLC.
+
+//! Provides the `RcuBox` type for Rust allocations that live for a grace period.
+
+use core::{
+    marker::PhantomData,
+    ops::Deref,
+    ptr::NonNull, //
+};
+
+use crate::{
+    alloc::{
+        self,
+        allocator::{
+            KVmalloc,
+            Kmalloc,
+            Vmalloc, //
+        },
+        AllocError,
+        Allocator, //
+    },
+    bindings,
+    ffi::c_void,
+    prelude::*,
+    types::ForeignOwnable,
+};
+
+use super::{
+    ForeignOwnableRcu,
+    Guard, //
+};
+
+/// A box that is freed with rcu.
+///
+/// The value must be `Send`, as rcu may drop it on another thread.
+///
+/// # Invariants
+///
+/// * The pointer is valid and references a pinned `RcuBoxInner<T>` allocated with `A`.
+/// * This `RcuBox` holds exclusive permissions to rcu free the allocation.
+pub struct RcuBox<T: Send, A: Allocator>(NonNull<RcuBoxInner<T>>, PhantomData<A>);
+
+/// Type alias for [`RcuBox`] with a [`Kmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// # use kernel::sync::rcu::{self, RcuKBox};
+/// let rb = RcuKBox::new(42, GFP_KERNEL)?;
+///
+/// assert_eq!(*rb, 42);
+/// assert_eq!(*rb.with_rcu(&rcu::read_lock()), 42);
+/// # Ok::<(), Error>(())
+/// ```
+pub type RcuKBox<T> = RcuBox<T, Kmalloc>;
+
+/// Type alias for [`RcuBox`] with a [`Vmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// # use kernel::sync::rcu::{self, RcuVBox};
+/// let rb = RcuVBox::new(42, GFP_KERNEL)?;
+///
+/// assert_eq!(*rb, 42);
+/// assert_eq!(*rb.with_rcu(&rcu::read_lock()), 42);
+/// # Ok::<(), Error>(())
+/// ```
+pub type RcuVBox<T> = RcuBox<T, Vmalloc>;
+
+/// Type alias for [`RcuBox`] with a [`KVmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// # use kernel::sync::rcu::{self, RcuKVBox};
+/// let rb = RcuKVBox::new(42, GFP_KERNEL)?;
+///
+/// assert_eq!(*rb, 42);
+/// assert_eq!(*rb.with_rcu(&rcu::read_lock()), 42);
+/// # Ok::<(), Error>(())
+/// ```
+pub type RcuKVBox<T> = RcuBox<T, KVmalloc>;
+
+struct RcuBoxInner<T> {
+    rcu_head: bindings::callback_head,
+    value: T,
+}
+
+// Note that `T: Sync` is required since when moving an `RcuBox<T, A>`, the previous owner may
+// still access `&T` for one grace period.
+//
+// SAFETY: Ownership of the `RcuBox<T, A>` allows for `&T` and dropping the `T`, so `T: Send +
+// Sync` implies `RcuBox<T, A>: Send`.
+unsafe impl<T: Send + Sync, A: Allocator> Send for RcuBox<T, A> {}
+
+// SAFETY: `&RcuBox<T, A>` allows for no operations other than those permitted by `&T`, so `T:
+// Sync` implies `RcuBox<T, A>: Sync`.
+unsafe impl<T: Send + Sync, A: Allocator> Sync for RcuBox<T, A> {}
+
+impl<T: Send, A: Allocator> RcuBox<T, A> {
+    /// Create a new `RcuBox`.
+    pub fn new(x: T, flags: alloc::Flags) -> Result<Self, AllocError> {
+        let b = Box::<_, A>::new(
+            RcuBoxInner {
+                value: x,
+                rcu_head: Default::default(),
+            },
+            flags,
+        )?;
+
+        // INVARIANT:
+        // * The pointer contains a valid `RcuBoxInner` allocated with `A`.
+        // * We just allocated it, so we own free permissions.
+        Ok(RcuBox(NonNull::from(Box::leak(b)), PhantomData))
+    }
+
+    /// Access the value for a grace period.
+    pub fn with_rcu<'rcu>(&self, _read_guard: &'rcu Guard) -> &'rcu T {
+        // SAFETY: The `RcuBox` has not been dropped yet, so the value is valid for at least one
+        // grace period.
+        unsafe { &(*self.0.as_ptr()).value }
+    }
+}
+
+impl<T: Send, A: Allocator> Deref for RcuBox<T, A> {
+    type Target = T;
+    fn deref(&self) -> &T {
+        // SAFETY: While the `RcuBox<T>` exists, the value remains valid.
+        unsafe { &(*self.0.as_ptr()).value }
+    }
+}
+
+// SAFETY:
+// * The `RcuBoxInner<T>` was allocated with `A`.
+// * `NonNull::as_ptr` returns a non-null pointer.
+unsafe impl<T: Send, A: Allocator> ForeignOwnable for RcuBox<T, A> {
+    const FOREIGN_ALIGN: usize = <Box<RcuBoxInner<T>, A> as ForeignOwnable>::FOREIGN_ALIGN;
+
+    type Borrowed<'a>
+        = &'a T
+    where
+        Self: 'a;
+    type BorrowedMut<'a>
+        = &'a T
+    where
+        Self: 'a;
+
+    fn into_foreign(self) -> *mut c_void {
+        core::mem::ManuallyDrop::new(self).0.as_ptr().cast()
+    }
+
+    unsafe fn from_foreign(ptr: *mut c_void) -> Self {
+        // INVARIANT: Pointer returned by `into_foreign, A` carries same invariants as `RcuBox<T>`.
+        // SAFETY: `into_foreign` never returns a null pointer.
+        Self(unsafe { NonNull::new_unchecked(ptr.cast()) }, PhantomData)
+    }
+
+    unsafe fn borrow<'a>(ptr: *mut c_void) -> &'a T
+    where
+        Self: 'a,
+    {
+        // SAFETY: Caller ensures that `'a` is short enough.
+        unsafe { &(*ptr.cast::<RcuBoxInner<T>>()).value }
+    }
+
+    unsafe fn borrow_mut<'a>(ptr: *mut c_void) -> &'a T
+    where
+        Self: 'a,
+    {
+        // SAFETY: `borrow_mut` has strictly stronger preconditions than `borrow`.
+        unsafe { Self::borrow(ptr) }
+    }
+}
+
+impl<T: Send, A: Allocator> ForeignOwnableRcu for RcuBox<T, A> {
+    type RcuBorrowed<'a>
+        = &'a T
+    where
+        Self: 'a;
+
+    unsafe fn rcu_borrow<'a>(ptr: *mut c_void) -> &'a T
+    where
+        Self: 'a,
+    {
+        // SAFETY: `RcuBox::drop` can only run after `from_foreign` is called, and the value is
+        // valid until `RcuBox::drop` plus one grace period.
+        unsafe { &(*ptr.cast::<RcuBoxInner<T>>()).value }
+    }
+}
+
+impl<T: Send, A: Allocator> Drop for RcuBox<T, A> {
+    fn drop(&mut self) {
+        // SAFETY: The `rcu_head` field is in-bounds of a valid allocation.
+        let rcu_head = unsafe { &raw mut (*self.0.as_ptr()).rcu_head };
+        if core::mem::needs_drop::<T>() {
+            // SAFETY: `rcu_head` is the `rcu_head` field of `RcuBoxInner<T>`. All users will be
+            // gone in an rcu grace period. This is the destructor, so we may pass ownership of the
+            // allocation.
+            unsafe { bindings::call_rcu(rcu_head, Some(drop_rcu_box::<T, A>)) };
+        } else {
+            // SAFETY: All users will be gone in an rcu grace period.
+            // TODO: We are luckily since `kvfree_call_rcu()` works on both kmalloc and vmalloc,
+            // maybe a new `Allocator` method is needed.
+            unsafe { bindings::kvfree_call_rcu(rcu_head, self.0.as_ptr().cast()) };
+        }
+    }
+}
+
+/// Free this `RcuBoxInner<T>`.
+///
+/// # Safety
+///
+/// `head` references the `rcu_head` field of an `RcuBoxInner<T>` that has no references to it.
+/// Ownership of the `Box<RcuBoxInner<T>, A>` must be passed.
+unsafe extern "C" fn drop_rcu_box<T, A: Allocator>(head: *mut bindings::callback_head) {
+    // SAFETY: Caller provides a pointer to the `rcu_head` field of a `RcuBoxInner<T>`.
+    let box_inner = unsafe { crate::container_of!(head, RcuBoxInner<T>, rcu_head) };
+
+    // SAFETY: Caller ensures exclusive access and passed ownership.
+    drop(unsafe { Box::<_, A>::from_raw(box_inner) });
+}
+
+#[kunit_tests(rust_rcu_box)]
+mod tests {
+    use super::*;
+
+    #[test]
+    fn rcu_box_basic() -> Result {
+        let rb = RcuBox::<_, alloc::allocator::Kmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
+
+        assert_eq!(*rb, 42);
+        assert_eq!(*rb.with_rcu(&Guard::new()), 42);
+
+        drop(rb);
+
+        let rb = RcuBox::<_, alloc::allocator::Vmalloc>::new(42i32, alloc::flags::GFP_KERNEL)?;
+
+        assert_eq!(*rb, 42);
+        assert_eq!(*rb.with_rcu(&Guard::new()), 42);
+
+        drop(rb);
+
+        Ok(())
+    }
+}
-- 
2.50.1 (Apple Git-155)


