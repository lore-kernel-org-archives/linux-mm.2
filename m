Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 346DA606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4IDXTsb
Received: by kanga.kvack.org (Postfix)
	id 048106B05B6; Fri, 13 Nov 2026 08:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34216B05B7; Fri, 13 Nov 2026 08:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23446B05CD; Fri, 13 Nov 2026 08:15:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE1B16B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:15:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DFDFC0147
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:15:30 +0000 (UTC)
X-FDA: 85430142420.30.907E4B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5A35820010
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:15:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4IDXTsb;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794575728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Um/wRtJ61vyX9tnzXtlftcOZcq6BKKMsu9xqpI5NL8=;
	b=zU+zYBjJGWFcyXbsIt2QDL3Ci6gREgGG9RfhlSz7uQvkls/bcRc0JZYzpijANNdlSlMFjm
	OeW2agqCGyZUxOc0XddgqBEVERg8rtFdFGb36vUClK4BnVxOUn7CB/nqn/HmO6mzdJ5Tt9
	gbiNJenAGBCllwQgDSmOiFblt67q8zk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4IDXTsb;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794575728;
	b=eXlrQ+aJj5yb5UedgI4Ud7DRA4/FGNDZoKrAY8NqSJN5cfHN3QyBC3jVgVoRzAhB5TS4KU
	J7Xmgxu7pMMQJv28OI8CA8Ki5nMdXPqaAcmvLf9JHz06xZqGCJU+AWaRrKBP43xPhEK2zM
	yymtkuJ43VdmTu77vfDk73j2kRediEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 918FB43DB6;
	Fri, 13 Nov 2026 13:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B961F000C4;
	Fri, 13 Nov 2026 13:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794575727;
	bh=8Um/wRtJ61vyX9tnzXtlftcOZcq6BKKMsu9xqpI5NL8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P4IDXTsbEtw27yHgKxvjOLhm+9bR5+o6CkBGsLzKjQFdk+BZpEL6+EkHFt4Sy/XvY
	 JRZvLxryeT1cxJO4WM6o8p+y8OtD9zXKGdaKuSINweJsE9SgIUwF00TjSN6UjANisL
	 mfhdKJ3kzRRQPbv0RV4t51fnT7XLDzWB/C29694KcKDWyT926kNwpstPtOXkRsVH56
	 pn6iGvg7McyMJpIzTMP6bMKrCVg/B1nUFOyl76fAH8azMMbay2FE5Ie5XONFwMuIrl
	 p8x95tibKUVZNrf3qEZ9ENd1OfUm0KT4vWfhBzCMAyNnl8N1iH2PU716npyXoloTBJ
	 gVZTxYa9kR1Sw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 13 Nov 2026 14:15:08 +0100
Subject: [PATCH v6 1/4] rust: io: forbid plain accesses racing with
 `SysMem`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-page-volatile-io-v6-1-5603e527c919@kernel.org>
References: <20261113-page-volatile-io-v6-0-5603e527c919@kernel.org>
In-Reply-To: <20261113-page-volatile-io-v6-0-5603e527c919@kernel.org>
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
 Lyude Paul <lyude@redhat.com>, Abdiel Janulgue <abdiel.janulgue@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 dri-devel@lists.freedesktop.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9126; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Nc98J2rlEGFl+Qq2T601DfIEX/49/J0gHxiK4Vv1pDM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq9w1fNsY2SFtctfToxiCffHOxVZSzNMckcTfOV
 0mhF/m1ox2JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavcNXwAKCRD6UCkIqsW9
 0E9iD/9NwJ1UQrjW++nH4MULFRFqcVt4Sc/Z53priRz7k6GNztS/VaoHSSS/POZbC3JSMAkhBXj
 5JUnz9ugkajyJN0xIgHS6In8bnutJ+juhLqmT23rU0zyt3y/y4uUc1lo3vVk9WFPsAlLRDRFnhf
 RGXRX3fZ5NL3kNZL2v011pr1VMnZtVNM2RGnyC1C2G0BFzDOjK0asfpmMz8Pzc1pbl+43NClsDa
 99N7vT8yxQPb57WI4bMqNHoFwSF+x6MuAuz8eBB2Nj2FzcH0b4p2+cNSxoHurRiwqgS5WZaQ5LL
 xcrHzyx4ooEKPMnsm1aUTdgJN8eR4o9j6Cb4mPkkuy7tkOEg0q9HHA/LZ93v8Ppk8QBAu/AIyUz
 fcmAoTjLy/2mi8npe8Uh2lzBCoiwA+8Uo3L+PqzUxKiYK6/0A8fdiBbOZxdBzqSq36B5iwj0aZF
 0yBVHjv5ILaz58W3mJikhCPXGfR4jY0zzhCxBRl84gJKdoX9NpJD3W26pZdWStcNb+AJWjSGgKp
 u5fHBPcPXY+R0mryCZ25hL4zTazNM6SRoWJlOzqHrrrB8RJ2cjLD3WO9fscG7fSr3Er3BZBMGfm
 yCpCzy+0K44RIBn1xKo9xF5TefleKsCCtdf0SIVR9Ofc+kDxnyvN3qFtjOE7NbJcgNx/C2IepaU
 9JQtq7/oZeZLCnw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: i6cjskreefp1p549h1kjnt9pqreqfjq7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5A35820010
X-HE-Tag: 1794575728-46560
X-HE-Meta: U2FsdGVkX1+CHjAC4vyTtqZCZy6+RQ3klBvqD7it+xlQl2WLM87A0UWFpTxL+Ug7F1Jd+vIjq2dJaxxdsjR6jhDa2uSLuXp9YYU/yn98Eb1HOUA+5ISapvPzZ+uSIUbjYXk4E4WngTqVwiSbbGOSM2mJscMgREvYQZu6BH7DWMYpPKD3AVQmNutCXnOMugXiA33QMfLq7xn4vOlx29GWb6hPYg4YYG8AsWC1XkqGuoWt/bhZmqlVfnZw3mVZZl6mLRQ+knbghQYt6lLWDAGe7pYqng/0GRU3+eNuWX92ekGnYZD/v+uurc08w55jGhYCVPADpry3zoDfTGTKlxQ4ZkzSg8rJCo8QH9E4n8Ei9Aaow+KYVtlfPdeO0rQGi+WY1VCpfJfCIr3xjx/xpQrO6/rPsg+5NCrxIxXXetSkUsTNjxLxOs817x6JftRWGvclbbmqUZckxoUTKqOzfkYHjVPPoG36LzdQc7SxMsRJGHo+Z8PhyO7If3sY2JiDp/Ndf7IE+Rw96SIaDDYye6z1eqjKqqPVGx+3vRwAEJIRgKk1EfYs6whJ5LBeam6A9j/NQXQ+rSKMdpvm8uGA2BKnBrd7ZYgg1Qx/pnY4BGlhoD6cz7+exv9UbF5WycDImyihGyjV/vTLPSA5iZaAV+sJyRUJRLj1VYykdcKaJhvtzSWSEZNejbNrG49hkFNGSeWOb69XktgnDeUNMqzaHdcQ5o0LcwIUGXy69Nk7K8jv34k2+ih6SQdK1e4XT71BzgZIufXFnR3JW9JIS5A6JDhBYI6Anj5GmjDDpkvrk7s1yYPH089Zy10Fn80XKuAEQT/8XUxTROEviU/zYcAz/Sa2oZ2Ic4j9jkdRqUbz7xQ1abPS62eB3UncxcP6OvTKW/2fpsk6UZMFivU1cHkylrqwTEJ0esGaut5Sim7yiqG+1acPGxS2uIgm3NiHkU9bLiIlYIROMZbrS9yKte09LPa
 CewJbRmN
 1pMtPckXbHW7EEr4B2gZI795Uw4w0QVTX3oatdpsOWa0MEs00SxRcoq5zH61AMIzDWDLr/VDoFkDYuLDVajzNQjFwmskXAPDDNCDZoVMA7LFJ8EDEY9uHDbYY3NUeeAoLNDWCIvcFfeMB6lIW6GHzuyOEJWVun+Jb5q+iZgyAasEClmXAjFJBJOHWv/7TfK8LFUNrEbCkLXLDNcirmNA5x57OxUNg3T98DtKrKlht+phVWjF/fX7LBRDiSNikyNuBjVDxZJYF6zmpHBKDajoXq+0olzCWfKhckEejNVpwqc/C0Q3H4UOm83bNefviguw+QMxx
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
region races with an access performed through the view, define what a
plain access and a race is, and update the safety comments on the
backend implementation and on the existing callers of `SysMem::new` to
rely on the new invariant.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/dma.rs           |  8 +++++++-
 rust/kernel/drm/gem/shmem.rs |  2 ++
 rust/kernel/io.rs            | 48 +++++++++++++++++++++++++++++---------------
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/rust/kernel/dma.rs b/rust/kernel/dma.rs
index 580e1c3427bc..445b5859c60b 100644
--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -1237,7 +1237,13 @@ impl<'a, T: ?Sized + KnownSize> IoBase<'a> for &'a Coherent<'_, T> {
     #[inline]
     fn as_view(self) -> CoherentView<'a, Self::Target> {
         CoherentView {
-            // SAFETY: `cpu_addr` is valid and aligned kernel accessible memory.
+            // SAFETY:
+            // - Per type invariant, `cpu_addr` is valid and aligned kernel accessible memory.
+            // - Plain accesses to the region are only possible through `unsafe` APIs, that is
+            //   `Coherent::{as_ref,as_mut}`, `CoherentView::{as_ref,as_mut}` and dereferencing
+            //   the raw pointers returned by `Coherent::{as_ptr,as_mut_ptr}`, all of which require
+            //   the caller to avoid racing with other accesses to the region, including accesses
+            //   through this view.
             cpu_addr: unsafe { SysMem::new(self.cpu_addr.as_ptr()) },
             dma_addr: self.dma_addr,
         }
diff --git a/rust/kernel/drm/gem/shmem.rs b/rust/kernel/drm/gem/shmem.rs
index 24cb5343e0db..e55c3d16729d 100644
--- a/rust/kernel/drm/gem/shmem.rs
+++ b/rust/kernel/drm/gem/shmem.rs
@@ -471,6 +471,8 @@ fn as_view(self) -> SysMem<'a, Region<SIZE>> {
         // - `addr` is page-aligned, which satisfies `Region`'s 4-byte alignment requirement.
         // - The memory remains valid until this `VMap` is dropped; since `self` is `&'a VMap`,
         //   the borrow prevents the `VMap` from being dropped for the lifetime `'a`.
+        // - `VMap` does not expose the mapping in any other way, so all accesses to the region
+        //   from Rust go through views created here, and those are never plain accesses.
         unsafe { SysMem::new(ptr) }
     }
 }
diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
index a877df11a03e..00bab24d613c 100644
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -1452,7 +1452,8 @@ unsafe fn project_view<'a, T: ?Sized + KnownSize, U: ?Sized + KnownSize>(
         ptr: *mut U,
     ) -> Self::View<'a, U> {
         // INVARIANT: Per safety requirement, `ptr` is projection from `view`, so it is also a valid
-        // kernel accessible memory region.
+        // kernel accessible memory region. Accesses through the new view are accesses through
+        // `view`, which no plain access races with per the invariants of `view`.
         SysMem {
             ptr,
             phantom: PhantomData,
@@ -1470,8 +1471,9 @@ fn io_read(view: SysMem<'_, $ty>) -> $ty {
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
@@ -1481,8 +1483,9 @@ fn io_write(view: SysMem<'_, $ty>, value: $ty) {
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
@@ -1519,8 +1522,9 @@ fn copy_read<T: FromBytes>(view: Self::View<'_, T>) -> T {
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
@@ -1530,22 +1534,32 @@ fn copy_write<T: IntoBytes>(view: Self::View<'_, T>, value: T) {
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
+/// non-volatile access performed by kernel code, whether in C or in Rust. Two accesses to the same
+/// memory race if at least one of them is a write and they are not ordered by synchronization. A
+/// plain access that races with another access is a data race, and therefore undefined behavior.
+/// Accesses performed by hardware or by user space are not plain accesses in this sense. Racing
+/// with them is well-defined, but the data observed may be arbitrary.
 ///
 /// # Invariants
 ///
-/// `self.ptr.addr() .. self.ptr.addr() + KnownSize::size(self.ptr)` is valid and aligned kernel
-/// accessible memory region for the lifetime `'a`.
+/// - `self.ptr.addr() .. self.ptr.addr() + KnownSize::size(self.ptr)` is valid and aligned kernel
+///   accessible memory region for the lifetime `'a`.
+/// - No plain access to that memory region races with an access performed through this view.
 pub struct SysMem<'a, T: ?Sized> {
     ptr: *mut T,
     phantom: PhantomData<&'a ()>,
@@ -1570,8 +1584,10 @@ impl<'a, T: ?Sized> SysMem<'a, T> {
     ///
     /// # Safety
     ///
-    /// `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be valid and aligned kernel
-    /// accessible memory region for the lifetime `'a`.
+    /// - `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be valid and aligned kernel
+    ///   accessible memory region for the lifetime `'a`.
+    /// - No plain access (see [`SysMem`]) to that memory region may race with an access performed
+    ///   through the returned view.
     #[inline]
     pub unsafe fn new(ptr: *mut T) -> Self {
         // INVARIANT: Per safety requirement.

-- 
2.54.0



