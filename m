Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D194F45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D046B0099; Fri, 10 Apr 2026 17:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6336B009B; Fri, 10 Apr 2026 17:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC3E6B009D; Fri, 10 Apr 2026 17:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E63B6B0099
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:36:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6809359C28
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:31 +0000 (UTC)
X-FDA: 84643955382.04.37556AB
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 58ED44000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SCW9JDcD;
	spf=pass (imf07.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775856989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JzMtJCfhE/cOyRCL4deN82RoA6oSUseqvroceFE1d8=;
	b=K78dKckgKvzA1HcHrXWHYFQGhTA1IO8rM3RFQ5WMqbWKEwvwx4LNBRPRiKdgMj6EBa6fmH
	JTFQ3TP5YT5Mpm9NbuJxAG4/VkelGXQI6YoFcq1Lk+QlvmfkRAr3ETmzKx5oSk8B2ARZiW
	L8Yw6CTXmeLZicg5zogvs18VlR7OKbk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SCW9JDcD;
	spf=pass (imf07.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775856989; a=rsa-sha256;
	cv=none;
	b=G0eIuEIueFSDnnS/VcE4FcPv/f/W2gw9g7FIg/YPA0JJoXkt3e1xFMuuhW1lqH0pQqdKQl
	X87xCBim2Au5Ov7nrT2f0rELncmby/hfOepXnSUCWDDFRzQmiE/xxDI5K0FSIIM/k9Rd2C
	VWlIbdRXHFjji3m6Hn7ZlvegbRJtiyk=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c757a9251faso968775a12.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856988; x=1776461788; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+JzMtJCfhE/cOyRCL4deN82RoA6oSUseqvroceFE1d8=;
        b=SCW9JDcDlSZVBD1QO0L8PvJk1f0t0yigCjR6tMgSzNwooolGtWZfB7FU79L+9gstJV
         wBNooCwhkEEfARJyaBdiN0UAqyBNm70O1tYMPdGF1Wu4SgTGsopOiYnCQFbX3Yhl8Ofp
         4tExJ9b/aMZpkktLAnjdY5If0KlkwK3r0+fN0lQ9Fm5lPBh971JPlaSMa/W5GkELfdbG
         SxQpHjO308FaCeb1UEgJAEPMRSSP6IzZZTQOp+u/9joMWvAqftHU01LM7Y0lznY1ZgZ3
         3KKK11chZ7aw494LRev8eSp+DAAwPQwKLR069sWT6jlhh3t3o76E6xRj5VsMRtqKURpl
         BkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856988; x=1776461788;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+JzMtJCfhE/cOyRCL4deN82RoA6oSUseqvroceFE1d8=;
        b=sJq7cB5uJHcnwbMsGCvLsff5M3R8NjOUgcM+yqG2wGpDaxMbhy1lZT6XXooampaNAY
         mQmL51m+CqB6QdZ2rxklSy/GB7gMyUnsUTr2pjhfhNOOfKTtr7IW31WdQhhNgBrBYRuU
         7UtSjcdC4GJFUh7yaGsOdyAl0CwsDN+N7J2Cp1px294FEJ/ua3WS+LKkhZy4WQY5vXBm
         nUaHlOkEqzOzTfG1IFDdTlF7rLFLoFZ7F2wzaAA0RIdVp0HVCiU5Dlq74HYYdoI1hEhp
         WVXjxglP5IJRPvvRX8e8Q7NxfSK3UbVOQDxKDyFSu4Bkz2IocZ6dC2FZY5s3AvYFQ+OA
         qIuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEqofoW4McbgM/+M1cp85Bd6Dq2KU11HHmi2mkfmZc98gCQxJMlyuTlENtUgURQ/RfBSJzYED68A==@kvack.org
X-Gm-Message-State: AOJu0YzGZUhT7CdrtLNBwY3H61Mf0CPLoauHumWrlNGxLLYtOTphs8g8
	ZEf7VbVJrlWGnlooQznC9sc/Uw1qVn5ZgkSlYf0v9EyuGqTeMCjqIdg/
X-Gm-Gg: AeBDiesJ/Ialqt1qIaaz0j1YfJAsdANFUN6BprGlv1M8CPqFBL1DCW4l2D5HuTHzp2E
	itFleVhSThlI3RwC4b8n95NypXBuaIoHk0zrHeuigKCDOq9tyhe4UBh4KGR9TfHwq1QvvzcGki2
	ZdfNDZ4O14+RHRyrU0hii5FPyzzKQv1CSQzt3eoBgM812ESL8GTs8ahWN17+OAa9tcjAlJjrgMl
	PYz+Rl9PDIcP8oxGr8A57eE2Ste4NrDTkoBmoNZEyLrOsucuPIWki9DBhURKHWNYNwM7fAG/Ln+
	oL7NqN4WQhx3Ko72QGdtg6+uW48/vhOXJ6CDgXHvhp5Szuzgfiepwst9ZnqxYkpn9RV0Xq1jeRy
	ggeGpelcRK75W8RHTbzLAnXD4hYt/Ff2iP41X5/HaPDAfOn95KaEo2BiUWtt7glRJW4RZ3npr5S
	p0L3bf0arygf9JvLl6ikD5X30FIeVGDxwFG8TDyQEXjk86C4k7VC0qzUM=
X-Received: by 2002:a05:6a20:2588:b0:398:a5c7:3dc9 with SMTP id adf61e73a8af0-39fe405dd2amr5667454637.49.1775856988108;
        Fri, 10 Apr 2026 14:36:28 -0700 (PDT)
Received: from mitchelllevy.localdomain ([131.107.1.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e3d41sm5111551b3a.48.2026.04.10.14.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:36:27 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Fri, 10 Apr 2026 14:35:37 -0700
Subject: [PATCH v5 7/8] rust: percpu: Add pin-hole optimizations for
 numerics
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-rust-percpu-v5-7-4292380d7a41@gmail.com>
References: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
In-Reply-To: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Boqun Feng <boqun@kernel.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775856978; l=10544;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=IyeQBCcNFTW60JZl2i8GXrsguuamIFDOED+ecW44t6k=;
 b=1sEnwXSt8TG44DrXsJ2xdTtZ9Hvqtj8T/1xbiPRQKEcLDvTwN0VJ1fuUJa/x5cbQVfQfLhG1a
 2UllwHEsDBTB8lfz/5JZy2p3OjK9kiS+VnYge4/oR35vnsTFhL0mRoI
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspam-User: 
X-Stat-Signature: 6uzsb63gh87qatfiowbk88fncqfw5uj3
X-Rspamd-Queue-Id: 58ED44000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1775856989-661201
X-HE-Meta: U2FsdGVkX1+pVgkUAIsoYfN2oJzYCx0LAKYSCyerDbEFJYPiRF1UDW1oCEWji1dC2AZWI8rTUK5qvh1kHq3tYI7plbWkV+nqJGF6pZsVd7pY4r6av6GwNjKhju3h0Idw9kazzP+2nm4kDHejIyN1hUXfw5rIZQMDex659hI0sD7FNI1rlYCQbS0rMHLB5dGSX0AZMdEbssyn3Qy6W0hyLzGynC+31oFIPxziXEGeWSnCVwBJEIcZeryqyxFSGuHs+yQvY0a5bQp1kLvqG+i9tPBzD+4W6pzLpCenGafQJ5GTVTMDED4IOc4g5AslFzOtVp1thV9qi3l18YmcihAfgp8tZwhUuTEXimOR0ebE2JxObkg1+RRMlpncL7O2z15pqW7PYHNuISeU4tJdynvw49n5lPVUT19u9PJxWoVdA0er+Q/z8IEqOd3Urn5z9CS+vZrSm0sLkxmBGKxY773+bCY/OledkVVpTx1HAOOPLdsfsINKJ+uW1nm7BUclb/ro4Wdx0jl5uPBJe7vQYbcut/gaIRqrAW8qgyVfps5WxyuavXrgWWprqN5iRpaJKorMzCoWxG0yszG885Mg9Nk9ODWieuMAP3xLgpDQKXmlBTY5q9ZLMvBNANAIBbY3eZjVKj6wWYrGNufbpNlnM4V+K+SUC385GjjFZSxVzRDXOWd1tNoOzzsc5q1Y1THhALbhLGoR56JISlzEyJSuqJtPfAdaszdJMuVIsmNNufwS7oxbW3P4hSX+IuOuuyebkqreFmuG9/Py6t/vRXMWts9MFxR34jPlZkEA5Tk7uoZfZaCgkiygqraM9stOWyQxzgZFXPKets5L1qGcEruGvph34//l0FnPk3gM0EctFgrNbHiT4HyOlhyn3S+E0v9/tUpGE5l1o0G70ool6BFqzLZB4Dbqg+wBvQ8A5MNn+dynAMDTefpg8D4JZ7D/OBz7sZcUQEzTWBkfgAyHD9F1PLA
 mil3qRO8
 60cogHGQoz9QkgAH5MiKLNWmkbHuzbP5T8Z58tnyvMvu24PgXJW5ln9of05kixM1KY/uVlYbGbQ9PuhQGd4GP/VANjCOvSqnER+PlsJ+Bs0SqdJh7da0ly/3S0Q2IKuzYU5NZRBpXUwpPXbJizzF1c1L/yf1IjkL+1ZkCm5fiBAA3ALrYg72Ay1LVkHuk0Xd7l2gamMq8uIO7RX+AxfFpekq3yqMQWlBA4BXuQvII/G6AlBgTqeJc6OQO+m/KYOban40ytwJi0XomChkPVfnUgrzWGTCPbL+CJxPvPllGPuOgzW4feYAPcradSzEUH5xtdL/+untu8hhxQFq8xcbYHUaOxSWvT/RJa6TeCqfD2OZtpA4Ukt3pCy2KwrKr4sYQEisdVuVAWD430ZmKfN+7dpviVHIbem6KuwvD0O1GJ2ubPg4zMqluJDjw8I1YrtqDdH/PkHlpgdsH0XsAQK4qMNZsqA4rjNEbrNprPlF1gTF5LzAxivXEyOysvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The C implementations of `this_cpu_add`, `this_cpu_sub`, etc., are
optimized to save an instruction by avoiding having to compute
`this_cpu_ptr(&x)` for some per-CPU variable `x`. For example, rather
than

    u64 *x_ptr = this_cpu_ptr(&x);
    *x_ptr += 5;

the implementation of `this_cpu_add` is clever enough to make use of the
fact that per-CPU variables are implemented on x86 via segment
registers, and so we can use only a single instruction (where we assume
`&x` is already in `rax`)

    add gs:[rax], 5

Add this optimization via a `PerCpuNumeric` type to enable code-reuse
between `DynamicPerCpu` and `StaticPerCpu`.

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/kernel/percpu.rs         |   1 +
 rust/kernel/percpu/dynamic.rs |  10 ++-
 rust/kernel/percpu/numeric.rs | 138 ++++++++++++++++++++++++++++++++++++++++++
 samples/rust/rust_percpu.rs   |  36 +++++++++++
 4 files changed, 184 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
index 72c83fef68ee..ff04607ee047 100644
--- a/rust/kernel/percpu.rs
+++ b/rust/kernel/percpu.rs
@@ -6,6 +6,7 @@
 
 pub mod cpu_guard;
 mod dynamic;
+pub mod numeric;
 mod static_;
 
 #[doc(inline)]
diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
index 40514704b3d0..a717138b93dc 100644
--- a/rust/kernel/percpu/dynamic.rs
+++ b/rust/kernel/percpu/dynamic.rs
@@ -28,7 +28,7 @@
 /// the memory location on any particular CPU has been initialized. This means that it cannot tell
 /// whether it should drop the *contents* of the allocation when it is dropped. It is up to the
 /// user to do this via something like [`core::ptr::drop_in_place`].
-pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
+pub struct PerCpuAllocation<T>(pub(super) PerCpuPtr<T>);
 
 impl<T: Zeroable> PerCpuAllocation<T> {
     /// Dynamically allocates a space in the per-CPU area suitably sized and aligned to hold a `T`,
@@ -162,6 +162,14 @@ pub fn new_from(mut initer: impl FnMut(CpuId) -> T, flags: Flags) -> Option<Self
     }
 }
 
+impl<T> DynamicPerCpu<T> {
+    /// Gets the allocation backing this per-CPU variable.
+    pub(crate) fn alloc(&self) -> &Arc<PerCpuAllocation<T>> {
+        // SAFETY: This type's invariant ensures that `self.alloc` is `Some`.
+        unsafe { self.alloc.as_ref().unwrap_unchecked() }
+    }
+}
+
 impl<T> PerCpu<T> for DynamicPerCpu<T> {
     unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
         // SAFETY:
diff --git a/rust/kernel/percpu/numeric.rs b/rust/kernel/percpu/numeric.rs
new file mode 100644
index 000000000000..13b4ab4a794d
--- /dev/null
+++ b/rust/kernel/percpu/numeric.rs
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+//! Pin-hole optimizations for [`PerCpu<T>`] where T is a numeric type.
+
+use super::*;
+use core::arch::asm;
+
+/// Represents a per-CPU variable that can be manipulated with machine-intrinsic numeric
+/// operations.
+pub struct PerCpuNumeric<'a, T> {
+    // INVARIANT: `ptr.0` is a valid offset into the per-CPU area and is initialized on all CPUs
+    // (since we don't have a CPU guard, we have to be pessimistic and assume we could be on any
+    // CPU).
+    ptr: &'a PerCpuPtr<T>,
+}
+
+macro_rules! impl_ops {
+    ($ty:ty, $reg:tt) => {
+        impl DynamicPerCpu<$ty> {
+            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
+            /// variable.
+            #[inline]
+            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
+                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
+                // this pointer is valid and initialized on all CPUs.
+                PerCpuNumeric { ptr: &self.alloc().0 }
+            }
+        }
+        impl StaticPerCpu<$ty> {
+            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
+            /// variable.
+            #[inline]
+            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
+                // The invariant is satisfied because `StaticPerCpu`'s invariant guarantees that
+                // this pointer is valid and initialized on all CPUs.
+                PerCpuNumeric { ptr: &self.0 }
+            }
+        }
+
+        impl PerCpuNumeric<'_, $ty> {
+            /// Adds `rhs` to the per-CPU variable.
+            #[inline]
+            pub fn add(&mut self, rhs: $ty) {
+                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
+                // pointer relative to the `gs` segment register) by the invariants of this type.
+                unsafe {
+                    asm!(
+                        concat!("add gs:[{off}], {val:", $reg, "}"),
+                        off = in(reg) self.ptr.0.cast::<$ty>(),
+                        val = in(reg) rhs,
+                    );
+                }
+            }
+        }
+        impl PerCpuNumeric<'_, $ty> {
+            /// Subtracts `rhs` from the per-CPU variable.
+            #[inline]
+            pub fn sub(&mut self, rhs: $ty) {
+                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
+                // pointer relative to the `gs` segment register) by the invariants of this type.
+                unsafe {
+                    asm!(
+                        concat!("sub gs:[{off}], {val:", $reg, "}"),
+                        off = in(reg) self.ptr.0.cast::<$ty>(),
+                        val = in(reg) rhs,
+                    );
+                }
+            }
+        }
+    };
+}
+
+macro_rules! impl_ops_byte {
+    ($ty:ty) => {
+        impl DynamicPerCpu<$ty> {
+            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
+            /// variable.
+            #[inline]
+            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
+                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
+                // this pointer is valid and initialized on all CPUs.
+                PerCpuNumeric { ptr: &self.alloc().0 }
+            }
+        }
+        impl StaticPerCpu<$ty> {
+            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
+            /// variable.
+            #[inline]
+            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
+                // The invariant is satisfied because `StaticPerCpu`'s invariant guarantees that
+                // this pointer is valid and initialized on all CPUs.
+                PerCpuNumeric { ptr: &self.0 }
+            }
+        }
+
+        impl PerCpuNumeric<'_, $ty> {
+            /// Adds `rhs` to the per-CPU variable.
+            #[inline]
+            pub fn add(&mut self, rhs: $ty) {
+                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
+                // pointer relative to the `gs` segment register) by the invariants of this type.
+                unsafe {
+                    asm!(
+                        "add gs:[{off}], {val}",
+                        off = in(reg) self.ptr.0.cast::<$ty>(),
+                        val = in(reg_byte) rhs,
+                    );
+                }
+            }
+        }
+        impl PerCpuNumeric<'_, $ty> {
+            /// Subtracts `rhs` from the per-CPU variable.
+            #[inline]
+            pub fn sub(&mut self, rhs: $ty) {
+                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
+                // pointer relative to the `gs` segment register) by the invariants of this type.
+                unsafe {
+                    asm!(
+                        "sub gs:[{off}], {val}",
+                        off = in(reg) self.ptr.0.cast::<$ty>(),
+                        val = in(reg_byte) rhs,
+                    );
+                }
+            }
+        }
+    };
+}
+
+impl_ops_byte!(i8);
+impl_ops!(i16, "x");
+impl_ops!(i32, "e");
+impl_ops!(i64, "r");
+impl_ops!(isize, "r");
+
+impl_ops_byte!(u8);
+impl_ops!(u16, "x");
+impl_ops!(u32, "e");
+impl_ops!(u64, "r");
+impl_ops!(usize, "r");
diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
index 5adb30509bd4..90f5debd3c7a 100644
--- a/samples/rust/rust_percpu.rs
+++ b/samples/rust/rust_percpu.rs
@@ -28,6 +28,26 @@
 define_per_cpu!(UPERCPU: u64 = 0);
 define_per_cpu!(CHECKED: RefCell<u64> = RefCell::new(0));
 
+macro_rules! make_optimization_test {
+    ($ty:ty) => {
+        let mut test: DynamicPerCpu<$ty> = DynamicPerCpu::new_zero(GFP_KERNEL).unwrap();
+        {
+            let _guard = CpuGuard::new();
+            // SAFETY: No other usage of `test`
+            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| *val = 10);
+            test.num().add(1);
+            // SAFETY: No other usage of `test`
+            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 11));
+            test.num().add(10);
+            // SAFETY: No other usage of `test`
+            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 21));
+            test.num().sub(5);
+            // SAFETY: No other usage of `test`
+            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 16));
+        }
+    };
+}
+
 impl kernel::Module for PerCpuMod {
     fn init(_module: &'static ThisModule) -> Result<Self, Error> {
         pr_info!("rust percpu test start\n");
@@ -228,6 +248,22 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
 
         pr_info!("rust dynamic percpu test done\n");
 
+        pr_info!("rust numeric optimizations test start\n");
+
+        make_optimization_test!(u8);
+        make_optimization_test!(u16);
+        make_optimization_test!(u32);
+        make_optimization_test!(u64);
+        make_optimization_test!(usize);
+
+        make_optimization_test!(i8);
+        make_optimization_test!(i16);
+        make_optimization_test!(i32);
+        make_optimization_test!(i64);
+        make_optimization_test!(isize);
+
+        pr_info!("rust numeric optimizations test done\n");
+
         // Return Err to unload the module
         Result::Err(EINVAL)
     }

-- 
2.34.1


