Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA7BC982D4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3466B0089; Fri, 16 Jan 2026 10:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480526B008A; Fri, 16 Jan 2026 10:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FEF6B008C; Fri, 16 Jan 2026 10:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29BC06B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFD2816016F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:46:51 +0000 (UTC)
X-FDA: 84338255022.20.E247FEE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id ED91A1C0002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:46:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u9HsKiT7;
	spf=pass (imf20.hostedemail.com: domain of 3aF1qaQkKCB85GD79MTCGBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3aF1qaQkKCB85GD79MTCGBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIlza/EGnIT3hgfaEJFw0khZWhczs5SOkfu9nbXLDHk=;
	b=2gKXBM51VShlVCyn3JadJXLw5CF+IJLXXjqDhPk+25IFqMYPldnKFgnTND890nGtswN2Ob
	agoQqYrGzeX4fk+ovJhyC7YtknMp5kCuFQqQrcVyyLo1to6W8o4h2mqHwSy7J6RIF8sbb1
	E9fRtepzmv+oyq6C6PB4dm5oI3CRhOQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u9HsKiT7;
	spf=pass (imf20.hostedemail.com: domain of 3aF1qaQkKCB85GD79MTCGBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3aF1qaQkKCB85GD79MTCGBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578410; a=rsa-sha256;
	cv=none;
	b=peXYzImeOfKRaLgGfnYbiJDwtd7oHxMN+M3+ohGEHgKUqg6X5ZxURNNWt2tKRAQXC0wlfS
	sXtyCU3yWyt32NyoBfZ8HBOolTIYC0PNGzJ9OlMMFhQ24McfWD1T5nlplRzMBLDaa2HaYe
	LnvC5rOiK69H6n2B875jbe3igoZHJFw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47edc79ff28so14741925e9.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768578408; x=1769183208; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vIlza/EGnIT3hgfaEJFw0khZWhczs5SOkfu9nbXLDHk=;
        b=u9HsKiT7XDkNyPIzEim+Ya4IzphroMgIz2mjE/8M1S9wP49bu4yZUmKGfphxZqNBEA
         ZvztD6lrkEe+wnBGpKpv6MZlqYNMbAAGL2ZiipgQkNTc0hUZNqacCaQNfbSQhDcNdbge
         IhXmG4ZGIqW46vqDN4z5Z4eJjCMNy9DTBzt0NuAeXlboIQ0Y6b2qKsk4iB2+LCAO3lfj
         FFBcjBvU+no1vFHXZRnyveeJhBA9kaDc7prAh01l0C86Q80CxIdkoGQx1rJMLOO/GlU2
         pwiCFFX+UtiZF8jevVHuHdQVVKjx3DfYUcHxEBO4tBHxej7IGEZvoAkhuGhIW+gQn+6r
         b97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768578408; x=1769183208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vIlza/EGnIT3hgfaEJFw0khZWhczs5SOkfu9nbXLDHk=;
        b=FZp8uiqsR/mHDupDDDxhUBYngasXZqo5B+X90dz/tnzwsmOMZrcIESaj0QXnOxjX62
         yfAgEFQR0PST4bI0utdJbGX08nNxMpk9iQqkLzgJvdezrzXIEVAsSuCCo/dq1zrHnRNY
         hM6vIydHL1NZzUjNxUOevK+rBOLkLzeOJg1cZx33zQDQOBBIduPC8kYv4FeDVacDQ97b
         Zo/hAI3wMRnOxfWidXewNskP+3Kjg3SibUir1huNid/ZmmaQyWSqZO0LL0k3QCwXvWCz
         4peCNUiwivHd8ijfFvIEsHha0EafQofuRU6/FXpgH1TXxlDPh5vfFryZjT9U/SGeNQMb
         G4dA==
X-Forwarded-Encrypted: i=1; AJvYcCUenB3hVk6xUIbfNQ/O3pEPvq6w0IEBWR6ElahFcziSpkxoayE58tAfMX4YpA/YJ4HKYtp3NjM4gg==@kvack.org
X-Gm-Message-State: AOJu0YxKFAeNQVoDnAYtILI12xZ2xb/1suWV1y7XBwW8zwsVWZQCqJJs
	KO/1WPpksTsO8TxohJQcg/49+UhYn8eqWhjed3xXj7iKlQ6xXe7Gy0zjzldxsUvDYiphYu/Fuq9
	Y1hBToljeA18yCFA5VA==
X-Received: from wmpy3.prod.google.com ([2002:a05:600c:3403:b0:475:d804:bfd2])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b56:b0:477:79f8:daa8 with SMTP id 5b1f17b1804b1-4801e34307emr47609855e9.17.1768578408586;
 Fri, 16 Jan 2026 07:46:48 -0800 (PST)
Date: Fri, 16 Jan 2026 15:46:36 +0000
In-Reply-To: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
Mime-Version: 1.0
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=8262; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=qrwQQ5xsRj1H/N0Lbw6W36heDLQuKhlXvlReIJHGg14=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpal1mDrDeKeyvaU29qIbnCvyLx3rDZRhNGy+hR
 OG3G3eqsleJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaWpdZgAKCRAEWL7uWMY5
 Rm8+D/9n64VsnGt3hO31FzuNqa+W36tkyfYCTyC6MMFPCvX+o5hhbogdCWENrBQnnikEDar72kY
 BMtRrpL6uZZl9vBs1IKaoZZHlST/s4YZ/8V7G69kMwpC8+t2jel+1DbyxM72TQtHzbU1RKfBJzm
 WLtAbM90kXzh2Znzx0FUTbpJmiBPEHT42eG1waXGomyXKzLHv+BmiHZ8oJi/+PBtZgtUSWuZXEu
 s6rB0zy6e856mNjXaxtZyrt/P73f5gTTv2bf7Amh6W1DimBQUCf64rlD7pNSnQVFxu6MDTOeRYB
 HZjXZMeESXjfHN5Xi0Fb7ZSL7PIfGfbuYxDe90xome9wKcVmFtQxBbJUeh3JU+8jc+GPK1VSRqP
 EWQJkAZkePabVCxmu9YQ2VdgzkQHPHhc7NL/gS/H65CPow+piI7sL4u6nBD07A517WJmP+RZ28I
 qryZA/ge8Kfmr4w4EzrvLQsYvWezu9C8yWROxA1khFfolzpI4U3LZFUPKyGsINOU6dUC6NdsNYH
 ceCn6b1HN7Omu9q9k/QV3kmCBNsba35VPBLcrOzgdS3zDx+nv7fBbvQXt5vbsbt42XigNR4HlkK
 //MALI3yvqVBJ9y3oy4UUHgToasWCPUQvdsaw63w1pUo3uk11/y3tubvt9Lcl+5gdMt8EFUFMKD HQFt5FCcA2hhXXg==
X-Mailer: b4 0.14.2
Message-ID: <20260116-rcu-box-v1-1-38ebfbcd53f0@google.com>
Subject: [PATCH RFC 1/2] rust: rcu: add RcuBox type
From: Alice Ryhl <aliceryhl@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Andrew Ballance <andrewjballance@gmail.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: q4tw67kq9jodh99ick5fp8tfa5ry8ykz
X-Rspamd-Queue-Id: ED91A1C0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768578409-473110
X-HE-Meta: U2FsdGVkX19sT3S7UDf2jSunoW7x47ylS1t+NgjQgmzPR29wh2fNnm3MGRvQi+wPOzd4V0h+RH7qVWCEpleBg5gWZR4VW8InceG4fv2x/WyseoWy4PtXINmMszqgd3qtj7rKg8fm5/KxYG54boE2PZcGixiBTmL2X/EYOZunVce0oZpdW5p2yOummvCOnwCVfHdxSIMDsE0EZU3efRvYPh0SdgmpqdQIZd1oKW+S7mcp55TCyKQE+gUcKpp0Lch1Wr60vOufGr+/gaMSt7jR+NoOioyfepkxGl8I8zcIMEvVhD/UCTTReZPMRNxf9rlqSJI1lhmQHrTgUqrYvcptIBLZ/wup9965lhs3Dd9znB2j1AtaS2FDDtnZvdQsyGMobPHyGwTeKa9RO21OtI2pokh2Q096XNhYIZBeijl340CL6mkyrfxe1tGyTIsOiGqL2oU1bXKJb6mzs0wk6vk+R/15kWtOWLs7oXz3VopVvBTNOO/ibnb2ypd9vqFQtbPJBusSHoLL3mWZFsWH8Ouy0IVpfXWGV6UX0FS/RFLXibFKsT3A6s+gbQ7hf5Csi4Qz8jdHOaLhdOKHpg7s6+Fq5Jkd9tgfIxmleK6fLlWEtL5iRv/ZSwHe6Z9g8VKeJ3OYARyFcVJ2S4p63eh0LUb45wg3BGWB11EXzkEqd4+82uLFQ19Vxj1TMHFsIf3wBLWyTKv94olQP7NEW47HJdvX4HFZAEn0k+d9b99VLi/dtEo38OilzNgn9VqDuxZzeNFZodB33ivl8kgOSZoQsYfCGrg71mhzgx7e4WX+Thf2f1a8+sg6yQbrKl0IrjCWiES61o5nohQtQhICXkShIPKez8zSgcb43mGqXDsyjp2iil4XMtMVbfyfxhytzp7q25oBXyS6T8Vgj5T81RVG2jxiE9CZjKWG4gdoqpHfbKrAjNX/F89AjBXrcQ+5WfsSWlqnicdJHlr57u74J5iGrpg
 9PCegOBB
 H7Zr68l5/f13o65oNfJQ48Cg5nfDx6YYavZGJjGDeUJUB2cW30t8DmIa4PbcgoYueFsDXMOwXqEti33Mv6ZwDMC+EZJaUxiF3XUqKw4c9GDPYLSOzyVAPfyFQNto0muQJnlOwkBZAWFUwvw2kwIAOpwsdINIi0UCdd2FvxQviZLFQsXrnK8TJ+pYhq3oDRazPxSf4g6r4Ttvl90RTli1lA0KJsJtJv6pd560h3yf160hOhzrfs1xg+2t+RM/oKOM25d+70vMNOtYNrmEdh9r/D+Cmy+nJfrtS3M2YA1+7OwqtBtechusmRF36OpnfPbsQ1rSs1PHbKGsN41Az5O/qabb6eWVVnBdmqy5ff5Av/O+ehJ4iBukuQFdoVqWITuuO45Ofy76XSfEV+UtU/avw9ii3V5w88xiAXrtWep0amoSRzzgbDW65KBgNGq928k/z2NUfA9SZl9JdFEaMYJbB/xmGG6zuFmzigLZL5Rffk8uzzeOn2UP3MuYM7y2Jw04vAVpbERZEMiI7zESC+LFkvc+zo4AtbHqTihrDETKzo9UMiiz2BWCM/J6YwtCLItzhpGW4z+xr5qTFzahvhcsBzG3jenG3pM5Vg9NmRwukYEHHdwnsKxSjkDFDpIeuNJ1camCmC5Al01IUnyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This adds an RcuBox container, which is like KBox except that the value
is freed with kfree_rcu.

To allow containers to rely on the rcu properties of RcuBox, an
extension of ForeignOwnable is added.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/sync/rcu.rs         |  31 ++++++++-
 rust/kernel/sync/rcu/rcu_box.rs | 145 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+), 1 deletion(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index a067038b4b422b4256f4a2b75fe644d47e6e82c8..8d4b90383cd8d8ca7692586d13189b71c6dbab3e 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -75,6 +75,7 @@
 #include <linux/property.h>
 #include <linux/pwm.h>
 #include <linux/random.h>
+#include <linux/rcupdate.h>
 #include <linux/refcount.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched.h>
diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
index a32bef6e490b0eebdb93f2636cf10e177036a6a9..7234fe3e79ee920172c5094d2b0e46147e1d8313 100644
--- a/rust/kernel/sync/rcu.rs
+++ b/rust/kernel/sync/rcu.rs
@@ -4,7 +4,16 @@
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
 
 /// Evidence that the RCU read side lock is held on the current thread/CPU.
 ///
@@ -50,3 +59,23 @@ fn drop(&mut self) {
 pub fn read_lock() -> Guard {
     Guard::new()
 }
+
+/// Declares that a pointer type is rcu safe.
+pub trait ForeignOwnableRcu: ForeignOwnable {
+    /// Type used to immutably borrow an rcu-safe value that is currently foreign-owned.
+    type RcuBorrowed<'a>;
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
index 0000000000000000000000000000000000000000..2508fdb609ecc12a85a1830a84f58ddaf962d1ec
--- /dev/null
+++ b/rust/kernel/sync/rcu/rcu_box.rs
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Copyright (C) 2026 Google LLC.
+
+//! Provides the `RcuBox` type for Rust allocations that live for a grace period.
+
+use core::{ops::Deref, ptr::NonNull};
+
+use kernel::{
+    alloc::{self, AllocError},
+    bindings,
+    ffi::c_void,
+    prelude::*,
+    sync::rcu::{ForeignOwnableRcu, Guard},
+    types::ForeignOwnable,
+};
+
+/// A box that is freed with rcu.
+///
+/// The value must be `Send`, as rcu may drop it on another thread.
+///
+/// # Invariants
+///
+/// * The pointer is valid and references a pinned `RcuBoxInner<T>` allocated with `kmalloc`.
+/// * This `RcuBox` holds exclusive permissions to rcu free the allocation.
+pub struct RcuBox<T: Send>(NonNull<RcuBoxInner<T>>);
+
+struct RcuBoxInner<T> {
+    value: T,
+    rcu_head: bindings::callback_head,
+}
+
+// Note that `T: Sync` is required since when moving an `RcuBox<T>`, the previous owner may still
+// access `&T` for one grace period.
+//
+// SAFETY: Ownership of the `RcuBox<T>` allows for `&T` and dropping the `T`, so `T: Send + Sync`
+// implies `RcuBox<T>: Send`.
+unsafe impl<T: Send + Sync> Send for RcuBox<T> {}
+
+// SAFETY: `&RcuBox<T>` allows for no operations other than those permitted by `&T`, so `T: Sync`
+// implies `RcuBox<T>: Sync`.
+unsafe impl<T: Send + Sync> Sync for RcuBox<T> {}
+
+impl<T: Send> RcuBox<T> {
+    /// Create a new `RcuBox`.
+    pub fn new(x: T, flags: alloc::Flags) -> Result<Self, AllocError> {
+        let b = KBox::new(
+            RcuBoxInner {
+                value: x,
+                rcu_head: Default::default(),
+            },
+            flags,
+        )?;
+
+        // INVARIANT:
+        // * The pointer contains a valid `RcuBoxInner` allocated with `kmalloc`.
+        // * We just allocated it, so we own free permissions.
+        Ok(RcuBox(NonNull::from(KBox::leak(b))))
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
+impl<T: Send> Deref for RcuBox<T> {
+    type Target = T;
+    fn deref(&self) -> &T {
+        // SAFETY: While the `RcuBox<T>` exists, the value remains valid.
+        unsafe { &(*self.0.as_ptr()).value }
+    }
+}
+
+// SAFETY:
+// * The `RcuBoxInner<T>` was allocated with `kmalloc`.
+// * `NonNull::as_ptr` returns a non-null pointer.
+unsafe impl<T: Send + 'static> ForeignOwnable for RcuBox<T> {
+    const FOREIGN_ALIGN: usize = <KBox<RcuBoxInner<T>> as ForeignOwnable>::FOREIGN_ALIGN;
+
+    type Borrowed<'a> = &'a T;
+    type BorrowedMut<'a> = &'a T;
+
+    fn into_foreign(self) -> *mut c_void {
+        self.0.as_ptr().cast()
+    }
+
+    unsafe fn from_foreign(ptr: *mut c_void) -> Self {
+        // INVARIANT: Pointer returned by `into_foreign` carries same invariants as `RcuBox<T>`.
+        // SAFETY: `into_foreign` never returns a null pointer.
+        Self(unsafe { NonNull::new_unchecked(ptr.cast()) })
+    }
+
+    unsafe fn borrow<'a>(ptr: *mut c_void) -> &'a T {
+        // SAFETY: Caller ensures that `'a` is short enough.
+        unsafe { &(*ptr.cast::<RcuBoxInner<T>>()).value }
+    }
+
+    unsafe fn borrow_mut<'a>(ptr: *mut c_void) -> &'a T {
+        // SAFETY: `borrow_mut` has strictly stronger preconditions than `borrow`.
+        unsafe { Self::borrow(ptr) }
+    }
+}
+
+impl<T: Send + 'static> ForeignOwnableRcu for RcuBox<T> {
+    type RcuBorrowed<'a> = &'a T;
+
+    unsafe fn rcu_borrow<'a>(ptr: *mut c_void) -> &'a T {
+        // SAFETY: `RcuBox::drop` can only run after `from_foreign` is called, and the value is
+        // valid until `RcuBox::drop` plus one grace period.
+        unsafe { &(*ptr.cast::<RcuBoxInner<T>>()).value }
+    }
+}
+
+impl<T: Send> Drop for RcuBox<T> {
+    fn drop(&mut self) {
+        // SAFETY: The `rcu_head` field is in-bounds of a valid allocation.
+        let rcu_head = unsafe { &raw mut (*self.0.as_ptr()).rcu_head };
+        if core::mem::needs_drop::<T>() {
+            // SAFETY: `rcu_head` is the `rcu_head` field of `RcuBoxInner<T>`. All users will be
+            // gone in an rcu grace period. This is the destructor, so we may pass ownership of the
+            // allocation.
+            unsafe { bindings::call_rcu(rcu_head, Some(drop_rcu_box::<T>)) };
+        } else {
+            // SAFETY: All users will be gone in an rcu grace period.
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
+/// Ownership of the `KBox<RcuBoxInner<T>>` must be passed.
+unsafe extern "C" fn drop_rcu_box<T>(head: *mut bindings::callback_head) {
+    // SAFETY: Caller provides a pointer to the `rcu_head` field of a `RcuBoxInner<T>`.
+    let box_inner = unsafe { crate::container_of!(head, RcuBoxInner<T>, rcu_head) };
+
+    // SAFETY: Caller ensures exclusive access and passed ownership.
+    drop(unsafe { KBox::from_raw(box_inner) });
+}

-- 
2.52.0.457.g6b5491de43-goog


