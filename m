Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B03606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+7JbBMV
Received: by kanga.kvack.org (Postfix)
	id 2FDBB6B05C3; Tue, 10 Nov 2026 09:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5296B05C4; Tue, 10 Nov 2026 09:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212C76B05C5; Tue, 10 Nov 2026 09:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBA546B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:46:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16A8040937
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:56 +0000 (UTC)
X-FDA: 85419483912.01.894D357
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E0D9180007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+7JbBMV;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321954;
	b=8GSKSMrMBxNfMjMZOcuvygi+AYKSJ+mWLrqQ+s8Ve9MqqZQ/oBbYGqXVhVoFjjMFF29POM
	2PjRYdfOAGwrJB8Id0htnti3oGB5fy0iJVPiUaYmNN/bOi94VDu7F77nYZElnYFCOwEIH0
	tXLaq1j7uinhikO0pNsFjVdmViSGxBo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+7JbBMV;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qB8QIbiIHt/Gn3tRmcosaPIBr7WjlDser9SvjhxhbVg=;
	b=RroJDgie5vOmN8AaXPKsbmlcoJmF39dR/LFfLgGSech7mMW4t3kIumBnNlfnzQXMBbiH2z
	HnWodLKUoyqEzDAoa8Uat/CT25QilyS9FWwI0+M7x2tEXcwxR9Pi+Lthfm42OhbF7h0vA1
	tPEcdhj/7oiZ34DsUXuNvBdzuLe9QlI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6512640B6C;
	Tue, 10 Nov 2026 14:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7731F1F008A7;
	Tue, 10 Nov 2026 14:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321953;
	bh=qB8QIbiIHt/Gn3tRmcosaPIBr7WjlDser9SvjhxhbVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N+7JbBMV8sLscENyAhJtuedyeQjMmFFgfeEAk1r0Z8wp78yUAcB/2gdxwhNetgCDD
	 XdMN910RlK8ALS+je/3pQI7Rd8g9fhNeurI5F/+7etvJpx/+w8JMpb/xU4riKLQZ19
	 bRgDr2AXCSFIOMXO7odQz5NjfuLDD1NsvKH25IVXQ/VJbwUCmLAJk0cjrrxeXI5Xrm
	 14BsxL0q7oUwwIyOPEQC4Dc494C/P7R4Y8pMC+armK2CeJ/dWMmicLYp6WZ/r8/Bec
	 2LPUVba54ndaOrmMuMl1L+/VlL+Edxnt5/oP3HQ/6WSSHWwzNlZt1J+8M3Q5h/B9Xk
	 w0q9Z6JFwfcEg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 10 Nov 2026 15:44:19 +0100
Subject: [PATCH v5 1/4] rust: io: require freedom from plain accesses for
 `SysMem`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-page-volatile-io-v5-1-a91ef252c24b@kernel.org>
References: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
In-Reply-To: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6848; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Siw5eLJqotabo4QOvIdp7fN0xbzQlulA+dafqnLBH/o=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq8y37OtARtVww4XjAv40L0m0Z45DXmMaiHLLq+
 6x2gsjXQ8eJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavMt+wAKCRD6UCkIqsW9
 0ELBD/4vzQEimedxgnipj9APetdRFUKT1mPz+0I53BswuoS3vhHh4XYpYLYqD9nWpB91P6x5jEm
 8qi1sefXrG4rQGcZGa8rZtKQv51YZqaPCkMOJV9eY2YAiMC3eezINvJT/rVQkN2cF+baPbo2X8P
 IGUEVJ+zDm90SKEhwZDzlZ8QHfgFJRiTEjmmnFAIH1mTyHYI4pm97yaYg/Fa3x8dzwBAFrndfog
 AZFVhOgpAYKH/EX39TvY/kyOE3zCGLL3ONIvGHXW3wfygI6e9U1sUDz7uhqSQsKCPmmDvWd5vtT
 50tdcZ+2CVK7QrcorDCImPosf7ktSXEvP25xojplnoaQrO7dWwU4mrK/9yamfKBk3ZKDDZE5GfP
 AnH2DkMkISGYGwSKn/mPPTZAmWZg8npHEz2vV9mVouWLm6ztSn+XIejErfEbdcceQ5fG4yauvNT
 2ngsviLQdUWeG4bZefLYF7GUVOZGOcEbQbSG+988U3Ih5dU7Ay6xUcS9uaVl9XFujbbH4OCwtnX
 jp5TU1XojDBfelG1pBcmhJ8O4BmF/DnzrGIEWjxF56kec/DL0+YkqJlqlBM0DqHQigSloqNZeiL
 Jj+TK97k7XFQR835HgG7wrYHGwRJDFouP0LRW8DNab6XqpwOAaPXVJCgjTdUqDWstmbzEosUQ+d
 jJtu07lzK1qRSmg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2E0D9180007
X-Stat-Signature: z5pb5duk7xatr6xt8frheb6gtt4wcc96
X-Rspam-User: 
X-HE-Tag: 1794321953-452451
X-HE-Meta: U2FsdGVkX18oIFchC8WPMpRWNqOt+2FnBQPd7+GUgTlTxXN94nlNwgghjVNLTQMSfNLiW+RRjx1Y1gFyDl2/OYN+39gdfVkwCXs25uLnr3nwTX5a7zBN96/Bu+t5xLB1GPnCC5otAMCXvIZYDMe+m0PieHqK6EyQB6+WZf1vWWE2DICdnlc/Hw5YdJi8XuRT9UHBoHdwvOdZpmITMlPsOdd2uPWGT4Vy1oSUez/pwLKs1Xs3GLORTsvgPo8rg3Ey/n5sS5HsFJcpP5GiL4CqU4bXQG7+qagQCQnZVd7Hrx/49HjP9yUGRVTh2WekhZnIJ1LnvWeM6qTIYcOxMx1i1/XdQ5hQD6AwATcJEksmRd2WI1F+G/780/OUzDscKeuj3tvjxCRctboJJi+Vgn90Y8pfPVov3vy86fcxoT+hY9gsCt2t9kvQQoeL8Asc65Ni0EeX8rS6IsWTvmF4LJPwx8aIlIlSMRbXVPWXN6DpctWPvkz9u2jFMLWSUXSU1qxOjXTH/7nptvv3FgaL0b2EIbDQGfvyKdLQ2yR6UhpCbTNixBVqSufeSJvZktvhmC3ZIJHtMVVRmxLjfXnW8sv9P2510W9x0d7LxvhOop/iGBjsgwba/e1IvYYxZbvBRsQY5Y/y9l9yJ9WDPN5FVvHaHOIEVFy44hEHxAat9xkjc6kJzR1CnHFa/QhNLOPtO7xB4PNxjm1Lfja8O7ijLajc6GFfwk6+krgAk4JsjEkIY82SwvaTlp/Evn0louP9tBAEiQSRV/qP051k3+Rwco8lNDlCX67IuSZ6EeYx3mJ8U3OjaL/DcZ+QMSSHgv8OK4TaefUXb9rbLPkeR3UYOasSYjICM4BmWcBCmfySpZCaGfjXUHedRglvfEyTMIZm+C27J5Umzu+tFdyc5YAgVkTThhu+jSb6n8L9gaZjGoSiDjpmuWwo6Lps8g7n2XWl4LXABtGa+wXAUrihJ2F+xL/
 E9QHTrWH
 mSYNiIBX8LYaY4kEHryvh/vxl1gD8hXuOZztvT/JWj0RQQkfq8GtsHDx/3xEIrwuPuejxwGyw+DsyLPuM61pElOiBeGAkbAE5WBZsS6EWvMfRCfm7tnOxm+U1/Xteex9GHS1osnWjkXkq/09Uva45mjXXwjnCCTfhChzy6DPtWpW74PZI0TqxfIpMvCtYEFmuoC+npXWnw8Vu6efKcSZZDylJu7sJJGZLGf0FP99FmEDVsqFDTz8cvQrfmYr7pp1FZkp8zaYz2YHzXlAI8reFIp2adA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

`SysMem` accesses memory with volatile loads and stores and with the
kernel's `memcpy()`. Both are well-defined when racing with hardware or
user space, and when racing with atomic or volatile accesses from other
kernel code. However, if they race with plain, non-atomic accesses from
kernel code, they are considered a data race, and therefore undefined
behavior.

The invariants of `SysMem` only require the region to be valid and
aligned kernel accessible memory. Nothing stops a caller from creating
a `SysMem` over memory that other kernel code accesses with plain loads
and stores at the same time.

Make the requirement explicit. Require that no plain access to the
region is performed for the lifetime of the view, define what a plain
access is, and update the safety comments on the backend implementation
to rely on the new invariant.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/io.rs | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
index a877df11a03e..3bc4be35e355 100644
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -1452,7 +1452,7 @@ unsafe fn project_view<'a, T: ?Sized + KnownSize, U: ?Sized + KnownSize>(
         ptr: *mut U,
     ) -> Self::View<'a, U> {
         // INVARIANT: Per safety requirement, `ptr` is projection from `view`, so it is also a valid
-        // kernel accessible memory region.
+        // kernel accessible memory region that is free of plain accesses.
         SysMem {
             ptr,
             phantom: PhantomData,
@@ -1470,8 +1470,9 @@ fn io_read(view: SysMem<'_, $ty>) -> $ty {
                 // SAFETY:
                 // - Per type invariant, `ptr` is valid and aligned.
                 // - Using read_volatile() here so that race with hardware is well-defined.
-                // - Using read_volatile() here is not sound if it races with other CPU per Rust
-                //   rules, but this is allowed per LKMM.
+                // - Per type invariant, no plain access races with this read. Racing with atomic
+                //   or volatile accesses from other CPUs is not sound per Rust rules, but this is
+                //   allowed per LKMM.
                 // - The macro is only used on primitives so all bit patterns are valid.
                 unsafe { view.ptr.read_volatile() }
             }
@@ -1481,8 +1482,9 @@ fn io_write(view: SysMem<'_, $ty>, value: $ty) {
                 // SAFETY:
                 // - Per type invariant, `ptr` is valid and aligned.
                 // - Using write_volatile() here so that race with hardware is well-defined.
-                // - Using write_volatile() here is not sound if it races with other CPU per Rust
-                //   rules, but this is allowed per LKMM.
+                // - Per type invariant, no plain access races with this write. Racing with atomic
+                //   or volatile accesses from other CPUs is not sound per Rust rules, but this is
+                //   allowed per LKMM.
                 unsafe { view.ptr.write_volatile(value) }
             }
         }
@@ -1519,8 +1521,9 @@ fn copy_read<T: FromBytes>(view: Self::View<'_, T>) -> T {
         // SAFETY:
         // - Per type invariant, `ptr` is valid and aligned.
         // - Using read_volatile() here so that race with hardware is well-defined.
-        // - Using read_volatile() here is not sound if it races with other CPU per Rust
-        //   rules, but this is allowed per LKMM.
+        // - Per type invariant, no plain access races with this read. Racing with atomic or
+        //   volatile accesses from other CPUs is not sound per Rust rules, but this is allowed
+        //   per LKMM.
         // - `T: FromBytes` so all bit patterns are valid.
         unsafe { view.ptr.read_volatile() }
     }
@@ -1530,22 +1533,31 @@ fn copy_write<T: IntoBytes>(view: Self::View<'_, T>, value: T) {
         // SAFETY:
         // - Per type invariant, `ptr` is valid and aligned.
         // - Using write_volatile() here so that race with hardware is well-defined.
-        // - Using write_volatile() here is not sound if it races with other CPU per Rust
-        //   rules, but this is allowed per LKMM.
+        // - Per type invariant, no plain access races with this write. Racing with atomic or
+        //   volatile accesses from other CPUs is not sound per Rust rules, but this is allowed
+        //   per LKMM.
         unsafe { view.ptr.write_volatile(value) }
     }
 }
 
 /// A view of a system memory region.
 ///
-/// Provides `Io` trait implementation for kernel virtual address ranges,
-/// using volatile read/write to safely access shared memory that may be
-/// concurrently accessed by external hardware.
+/// Provides `Io` trait implementation for kernel virtual address ranges, using volatile or
+/// byte-wise atomic accesses to safely access shared memory that may be concurrently accessed by
+/// external actors, such as hardware or user space threads, or by other kernel code using atomic or
+/// volatile accesses.
+///
+/// Accesses through a `SysMem` are never plain accesses. A plain access is a non-atomic,
+/// non-volatile access performed by kernel code, whether in C or in Rust. A plain access that
+/// races with any other access to the same memory is a data race, and therefore undefined
+/// behavior. Accesses performed by hardware or by user space are not plain accesses in this sense.
+/// Racing with them is well-defined, but the data observed may be arbitrary.
 ///
 /// # Invariants
 ///
-/// `self.ptr.addr() .. self.ptr.addr() + KnownSize::size(self.ptr)` is valid and aligned kernel
-/// accessible memory region for the lifetime `'a`.
+/// - `self.ptr.addr() .. self.ptr.addr() + KnownSize::size(self.ptr)` is valid and aligned kernel
+///   accessible memory region for the lifetime `'a`.
+/// - No plain access to that memory region is performed for the lifetime `'a`.
 pub struct SysMem<'a, T: ?Sized> {
     ptr: *mut T,
     phantom: PhantomData<&'a ()>,
@@ -1570,8 +1582,10 @@ impl<'a, T: ?Sized> SysMem<'a, T> {
     ///
     /// # Safety
     ///
-    /// `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be valid and aligned kernel
-    /// accessible memory region for the lifetime `'a`.
+    /// - `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be valid and aligned kernel
+    ///   accessible memory region for the lifetime `'a`.
+    /// - No plain access (see [`SysMem`]) to that memory region may be performed for the lifetime
+    ///   `'a`.
     #[inline]
     pub unsafe fn new(ptr: *mut T) -> Self {
         // INVARIANT: Per safety requirement.

-- 
2.54.0



