Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99033CCFA19
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3418E000F; Wed,  5 Nov 2025 18:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CED8E000E; Wed,  5 Nov 2025 18:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85CF8E000F; Wed,  5 Nov 2025 18:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D468D8E000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A29C7B9CF0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:39 +0000 (UTC)
X-FDA: 84078079638.15.FA6A82E
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id B17C61C000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eBHU4AUg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383757; a=rsa-sha256;
	cv=none;
	b=LQGo+Lsi+leN1ItPSW1j6I19TFSD6ve1VsCYqKlbHlDPpStwiN2uPBrJLHpfZIXV6bd7Cc
	bTCpcoYpVvwaQWhDsl0lhZjMgckIckF+ic6w3+hYZO9sAEPZSgtdqZZNFLnhLhdXGzZTdK
	ogRC1bvEQkYD0HnrGFzKNDdxbF1jRf4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eBHU4AUg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kN9/UL7jFZa5RKDycC8BJ8oS9HZfDBeA7oqBiSHbTHc=;
	b=5MJQBCtnb3QCzVWRvR7DaJl5yCq3jxKFk4qNVYctKOW0FpjO1LTkriApodtqaGY70hwcZC
	FsUnyADej6nev+JqFjJOMAhQjEvoG6gPXYskxURtmvuanV7Dt7wWxhQd8JtF9E+95o9FlX
	22u8GVDNdkwc7Ox94O7pRqiLhvGZaG4=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-294fc62d7f4so3472165ad.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383756; x=1762988556; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kN9/UL7jFZa5RKDycC8BJ8oS9HZfDBeA7oqBiSHbTHc=;
        b=eBHU4AUgpkOqeJ81zuxkpD43OJV3jyPYOIjg2ME/9/eI6qPCRBlcNuRiQx7aLIrKOa
         u2/X8AoZ7GOnScEVxRVAlUTbSLkQuWH8AYuByHr6TABtO39RspLBIc8sQsVq3bXFG+uL
         uHYIAJniefuRUEvt7agIkRpqCGDUDmJY5UeoOVWnAGkX5Sa12GqCAPhu7mXK9QQGvIhV
         qV0OAgm1P5tQUZPsXaTjDc/K2x63xqu5MLE/1XWtJCvXz7mM458Kt3kn66z+WsKUR898
         c12wcej6CCU2pYv6dq6MV9rQWG626iCckEfBItBlQWk87zWyKwS1741DBgjzs/rYkB56
         I1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383756; x=1762988556;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kN9/UL7jFZa5RKDycC8BJ8oS9HZfDBeA7oqBiSHbTHc=;
        b=Hoh8iJrqBduzL8PCRlUvmk5abWCgFgP5XOO8704qR9ERWhZUfHGbl6ICWAmsHxJBdG
         5aPrdVjE3htgkW3vP2m3Yxb/QgJFJQCoY+D+rFIQBn5viFi/FDBVYJzTBMJs3VhD8834
         zJOOYs51rHLz6bH3suIzNtHHayoNZp2xTp/cjj8NpXENHqFTVq2+kbEcpw2V38Y5j29b
         6Fdjhhf+UNWusZ6FiReYC0VrtOfyQUEzYK9B7+A4my8wEjKU/A3GSQ1d7iytQbv9rTTs
         tlUn6C6Hm61cstbQI/Hjn9AfZLQEY3GyW6QyDPxS6EtQyjISJJ5vyJ0iFyeCscAKME5n
         21Jg==
X-Forwarded-Encrypted: i=1; AJvYcCXy6EqYj0aNbtf55K9QBc6HKy4x7RTdNrS9j5JNfuDKlJ5nZI7Q3D621Nw7W6JxGB9GH3oNwINVyw==@kvack.org
X-Gm-Message-State: AOJu0YynTI4r6GfV3BSOgVSi1WzbcgusgqnYRArr7zICKfJKMjEYse2o
	9TX3dxsYf5qxLC+5+rIbCzfeiY26RJQKgofNS6enKcoiUr+1/6KA2vTf
X-Gm-Gg: ASbGncszgGGUfsm3GIW2rmPPe5x2s2YxmuBr0ALZiD4arFbF3LAFzqYZP3Xt6V2pA7/
	ex4SrTWarwpCdFS9tTy29D2UlH1EXampTVXVy6rTpOb5RiOecrwZ4qYXR8xTThJbdk+DEtsObBS
	RM23KpGMjaGJwM1L57VIJ1AT1vxM1/WaVDApAMiwY6E6bOQIejl7Gs1lShzarlalHlEX5AVN2a2
	+9B1mpAOMTmpMSjKYSvJiJK2LXjwhLaHNJGza6SCz6fJ6YLzZa4VhgldcusUtFczPDZkkNq+a+H
	/xf7K4pOOsrmpVVyLjHPJKRMRWFfKKD1t36LabydPR++LfLFdb+qv3uSd+kotRcIPjzJo1XscsE
	g2ElfiFeGk71dkA6INJ/zANtlbqZir3iv7nkiPXeo/jQhbiKtDUIPvh39ix8p0fG6V06A1j1zeq
	jaLSlGzbQvXnO6QONnw+k1dLM8jyvM+oAGgQ==
X-Google-Smtp-Source: AGHT+IFQkxzoaevtRmWsYeKKLp4dhk9UzDcwkiSO54MpJYOtGliGQSf/Idp109RNMzxqYIG9F5TfdA==
X-Received: by 2002:a17:902:ea09:b0:293:623:3260 with SMTP id d9443c01a7336-2962ae9b937mr61526055ad.57.1762383756270;
        Wed, 05 Nov 2025 15:02:36 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:35 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:20 -0800
Subject: [PATCH v4 8/9] rust: percpu: Add pin-hole optimizations for
 numerics
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-8-984b1470adcb@gmail.com>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
In-Reply-To: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=10554;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=N2+WVoODdmEMs33Jmf91+GyS5dqY4IkppGnGifhlfUw=;
 b=Z2rvF5hwLPBTS4udKgnmGgDRG4sF6Te7a0VTPOZNeZ9aQJCrtJODteQuQetfsAi6BEb6zjaF0
 IBremlr6jdEBRfajV62taxvmYwsiKbLAK9s6VdxCrwqQp8iWjg7VVVT
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B17C61C000F
X-Stat-Signature: tqh85zfhpzuu5d5srfa7ns9qkd8fm5aa
X-Rspam-User: 
X-HE-Tag: 1762383757-368529
X-HE-Meta: U2FsdGVkX18HIdMz2Z4XeyTXgYBBGb15NheUjBrBh6Zh4HfFO/f/cgLediGc4WCYXA8hUbx+F33Xh4IrtOZyEtS7kHIYzOX6taYto/cHtPyH9I2jFnrrf0o2hCsjD+QPfxrqd85cW/B/HtHK8m3gEV7dLZWFN74O/Ldd8kvfC7edaTNJthgckSoAvwbHE+7K0Y9AuJ1v76CJ0b5og6h0+sE3cieTq554enKu/wZ5gDglqTZRieHaBXUJxFNALTgWVNw9fTNsknIr+CjtMdyaPvOdsPpJZDA1VHWKfLy8nNf8uknyiY/rB00SkXdKWkJLvW1i9qGxUNODNZrTtxoHV7xpFN/L0ijaC8dM/GR/17ElbJiaorJBepFCo68SRa2Mh79YoUbU3Ew2E7n+huzx5cPBMmCBxcF3msGwGVyEsVNbCu9MCjCNotCH/Qcwon46zY3W8qKnCoMkwE31YLD0UcovvEdk6+QhgjHYREkvtwfRKkThBmeUnhhCRMumJOf1YcSd0DN0hf3ozokao/+r8gnUeWrAIQA/gk0n+4kkHQJ/rigFUtbqeV6GfVFbQv4NAXxZX7UqHmAlEY0aYz1jWCTDdvGMcjklI0bhkyvr3ZZvsQ1xzHpKmazMOUTOULJr6Ywx7XGSijsh0tLQ/KPbXbVQS0kEGlk+MJQt7v0MkNmhmuc4j/IOI5BmSV7aeO3Q/Bn20KhmslPRsTsgJCAhkj6NFEX9mr9KtyhDBnb8/HbpN6+pJfkmaKfkBuhdGHim1cG8k728mA7Tozj+oGjtcDTiho8M+pmdKHcUg3VUsQWMBVXp+C49A7AtyoTNduvu28pzdTY4GJaut+0+RGcci5C1utbroI7AgLRlCpzB60KOkyolRfgSRvwHyGUlzKfVrajA7HW4Scljv9Acj4gaOPEBkTPGmRDhthUuYljNvPQZIobVnHswTzUc8dxbibUdllew5dfg5PKveMfggHP
 waYYT1zY
 DuJ1CmHUhPt6UG3ArI4C2WPTkal33uJxSENJ82Mo6oqbPCIRsU5CwQBdJYTMQ+/44TO0jAc/5oYGwj1I2LOwA7ZlvkYqlnW/tGK6RxAaaLGDwEM6F2R3Gn1OOdL6JGoGIINi7L57UPpXSgkx4rNtS8guzWpqY7sa9Dw08+1px/beYKJW9FMXT1ZHf0HINAgiisvjJ+FvQYF+7KkemUz4WfxyZMG2b0n1X56vwKabXV6CqsaB50iq0WDKMPd2BXopswjTkloWzBwhq6cjEW1VBPGz+/AbyDMXZ6s5SMwWPJ6DYWdLiFKQu9+16CqHmI9qNpwWmwWFBHhAg9K1QS1Q6xSvK6qSdMhtIqwHUhPTNZXSQRj04NBIKBmbyWOA2OOoVVwPseShp7QqM7UkdjeGbvGeXNBCMOHJJd7C8Ghf7wRmti24GPc8BkEbITwrl+PIHWgTbPHSPS/ep9Hg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 2db670c87fae..c1148cb36eff 100644
--- a/rust/kernel/percpu.rs
+++ b/rust/kernel/percpu.rs
@@ -6,6 +6,7 @@
 
 pub mod cpu_guard;
 mod dynamic;
+pub mod numeric;
 mod static_;
 
 #[doc(inline)]
diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
index a74c8841aeb2..99acbf6363f5 100644
--- a/rust/kernel/percpu/dynamic.rs
+++ b/rust/kernel/percpu/dynamic.rs
@@ -18,7 +18,7 @@
 /// the memory location on any particular CPU has been initialized. This means that it cannot tell
 /// whether it should drop the *contents* of the allocation when it is dropped. It is up to the
 /// user to do this via something like [`core::ptr::drop_in_place`].
-pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
+pub struct PerCpuAllocation<T>(pub(super) PerCpuPtr<T>);
 
 impl<T: Zeroable> PerCpuAllocation<T> {
     /// Dynamically allocates a space in the per-CPU area suitably sized and aligned to hold a `T`,
@@ -119,6 +119,14 @@ pub fn new_with(val: &T, flags: Flags) -> Option<Self> {
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
index 000000000000..e76461f05c66
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
+                        off = in(reg) self.ptr.0.cast::<*mut $ty>(),
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
+                        off = in(reg) self.ptr.0.cast::<*mut $ty>(),
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
+                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
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
+                        concat!("add gs:[{off}], {val}"),
+                        off = in(reg) self.ptr.0.cast::<*mut $ty>(),
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
+                        concat!("sub gs:[{off}], {val}"),
+                        off = in(reg) self.ptr.0.cast::<*mut $ty>(),
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
index be70ee2e513f..31ab3fcf5c6c 100644
--- a/samples/rust/rust_percpu.rs
+++ b/samples/rust/rust_percpu.rs
@@ -28,6 +28,26 @@
 define_per_cpu!(UPERCPU: u64 = 0);
 define_per_cpu!(CHECKED: RefCell<u64> = RefCell::new(0));
 
+macro_rules! make_optimization_test {
+    ($ty:ty) => {
+        let mut test: DynamicPerCpu<$ty> = DynamicPerCpu::new_zero(GFP_KERNEL).unwrap();
+        {
+            let _ = CpuGuard::new();
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
@@ -208,6 +228,22 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
 
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


