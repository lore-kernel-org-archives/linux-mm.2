Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC8E606A89B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XoCuh1Nq
Received: by kanga.kvack.org (Postfix)
	id B65376B06C4; Fri, 13 Nov 2026 08:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D456B06CD; Fri, 13 Nov 2026 08:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C4A6B06EC; Fri, 13 Nov 2026 08:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74A7E6B06C4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:15:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C0EDA7FA5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:15:53 +0000 (UTC)
X-FDA: 85430143386.03.50C4477
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38CAEA000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:15:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XoCuh1Nq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794575751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNs9dw0Nqnz0km07lR3zmY7OWw3VLUamfMydRJ6ooco=;
	b=REF3TQvx/TEQeIn80IUxWLQIGG8cP02OWzXB3B4UvmnqLJ1MuWW33uQHLksWbeLOvnzXFO
	1WwcsGter64mf0SAVrMXDX6IeMehOGI7qSxid4lSRPnrw2vVDh/Z50kq/Ya0kYCvixH9sd
	YUi2Grzz3P9ILJoygOjoHc1TSbPQSGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794575751;
	b=6PWZ4zYyY1+JDnnyg/geM+z+ODYtvVigccMXkmH8ihIAMD9aQORbaRC9lyaCUkThZFi6We
	HyH8gCSciB5w4lPBfMBSisyZwS9k8fGR/0uuLKXuB9Ji8w77Px4uTt/6WPBPIgyhYCsqHh
	ueGn67ZJ+CzaDew0ZBc73eQMLAVDjf8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XoCuh1Nq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85A7E43D43;
	Fri, 13 Nov 2026 13:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AC31F000C6;
	Fri, 13 Nov 2026 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794575750;
	bh=sNs9dw0Nqnz0km07lR3zmY7OWw3VLUamfMydRJ6ooco=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XoCuh1NqReZMqjey+GrCXaEVV4Nv2H7hbTMiOCaBmj3GmT7pX5LJxaZrzIAtLFdVu
	 hu0uWOARjZeaLAqRrqMPMRa2MQAnwvY5gQx50p838auRLqMPkdDp7Nc0E+NJ/EjXnD
	 OwFDEeYNM5hDUpsv7Bht3pSPSKZ2onEbn1QX6hi7ITzg9u+ivQ/RgYI100wSnc5JEe
	 EmXraWGKgPYH9HRXeAxwfHjkYp2dgrQMPJA4/Jxi4Y33GyIejkQYYXBC9Ko9KZHh4p
	 zOS57ioFbJYcPh8f9WoQ40mQPU05G6Wp0ZkWabvMe+UJ/oZi7Vgxoj5SjSthiIY2Lv
	 V1hwS050nqltw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 13 Nov 2026 14:15:09 +0100
Subject: [PATCH v6 2/4] rust: sync: atomic: add memcpy
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-page-volatile-io-v6-2-5603e527c919@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3231; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=DSGQymeDaea3kRkiaM87A7fK2NEYs8mzxM5Kac6zHvs=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq9w1gZrqtPndda5c6hmyhLNbXu27i8QRfJbWRW
 MFne6F112uJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavcNYAAKCRD6UCkIqsW9
 0Pf/D/wOBz4O/7yniG2g93HD5S7Pzc0N7KIJ9yetlKf7ttB8N8LdP5ytENVKyvWgoipsdR6bcqh
 XX92iOmGMfk7LOcpaaZ3DAMTiErKGKvf2XDJDSSTuT3lOAnEURSZolnZ4PHcMyacN/mKVObM6Rg
 VLx0VcQ6goHYkXzL5XAdipLm7rcDXLIDrfxh1q34qzY5TNtIwNEhmqwoSYgNMz6G0p6XUFpLZv+
 mJkEFylqLFWuh4L6b/9n2yvP91+7q77CNUdWkTqs3rc7/YlzYjEb1PoateSjsa9Wfsxa4D/LXOB
 S3V3Sf2+uIS+XwSenWFvqXNycT9QRIDbrkReHqHfzBxMs2dQUv60MD/wSH5CgD/71d7SFOpJC+k
 5r/8zUkSPjI9u9LK3I4cYkzYNjjkHzLEK7WClQP6U0iOCw3pGzOHly+zKXQvguwY5MPfs6dMQ1m
 MIZkLTSD7bhISMWc9wwThGuFPE7aEpwhLTYlf0P0N5eOrpBgYZ0Z0aYBa657RF+hxsjSMWXMH7U
 HByp3tJa0TyNoASoRHsiS9W/YyX4jdQdkYT92ySmQ2fhGN4Ck9nmcuggSwJ/bt6INGKb2XbOIcs
 7sAycD5KIvsvQZ93nIFGRAJHiu9l81gH3FAhVo55ngSQ+u+h7EsZBKeOIr+hxH3GqwPUjcUtWIY
 tGt1ORNKwkeKkNA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: y6ordhsrt3agn9zxgmijo81cwagf5min
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38CAEA000A
X-HE-Tag: 1794575751-175186
X-HE-Meta: U2FsdGVkX1/Asy2vQ7wZLupWK3lay3xaANvbNdRYpOhLM2efnLYT4klGOksoda+LZiI1vER2U1SHjtE/9Ev01k/zuxJBTgQJp600zvKx+QkNJ48Q1Mhf0BOofNdVF2sjaP1J2ZKJ81ywb60DUMEWGOLll5+I4xB9QXoNXbJW+a6Wk3lLazRXeGOEws4l311cSFxINwlc9sHMgPqDxFuiDyJCd5S3p4tDTSvjT+B9yGmZaxWVdZi/me6CVlHbHk+eCKYkrchuikFKpBv1iEgpNgVlJiWDNzt/tXVbls/2EXpprvno66WXMW1MxqbTD7heWcvru1SbsudoUKYRNZNdutYoWYxqKj9LVwLQGWVSOz+XI6Zo/euWG2zJpJuXxt1t//4ypCy3bOQxXR2eqihQK7KyNI+B5babvDjpU8/iMziJ/T2hFxRZTs9M5I87CSQhUGbZ0PvGyBuTsM77R4kzBqvwEBeYjaQEjTxZayhsAkPKlcDFnnUMUHUr9HQrHexT8upNeLIezOrZISlQFltkJYIpr2MCKXP/hXBQ2H+4uMOePQrXmf9Wm+Kfx0Y7cRHtD4+fIqsAmXnCypKMFI5h9olo+wOvqYWJVffM+8ma4qcUk51FM9MthQkQKrNDzj+Vw2a/3AZyEKR3MvUHDuijUsE0S4tj4+4gxb1Mffj6RXEYwaPA7keyrvqadv/l2qCqXjQFY0Rl5MY3cEP0XdxkFbjWUDRJPY/fewbo2yqpYxktpkjLIMkemWwqphdY3bmiUIs34nVClS7IP2EeQzVZ3qIWFTiC2WWhOu7oOHh0rQr1dkjbfYYymQqJDcEqAyWOYtZWvSbg3lOREIxv8tTCmivAIVEX0TT2KZSmLQ+XNWKhggexbISZttKe84Jwiw8wmC71yi0T5T59yJOBGYI7CG7WeG9lLAPWndTp7NWEtu6m3UG8XWBql2iFLGAIZUacNi/70i56uRzNbmKS5K0
 yitIffiE
 XulEgMw/bNGOY/fSV4RVUK1/vPehG283N3uBYeT67Wspr3potWseBnp5ljESTaMvWuNdOSQMdJ48lyh7y3XsU1ZOymVO0nba0I1zgxdE1OXPoNHTcu2yUiaZRD2Gve0dKSgfDelCSpD6aA7bqTAvxJrtCa9/Dhl9sztZiG8F4Eq4eYZ8NDBajJKIpbCxPl6ijvM1KqCxIpTCbSJNcexkerqyobD/L//8Tn1oHzOg78kbTD99NHX/8YDONd0QZgSZc+atZ/p05Qhsb9Rbr6139xHujcvMUrLp8MdUvrL+WeKVKcOlH1juMBHaGjZgdG5LTT44wePXu+xWtto3E0ydFeA2xs9Me9EMh+l4K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a helper to copy `len` bytes from `src` to `dst` using byte-wise atomic
memory operations. This is the concurrent-safe counterpart of
`core::ptr::copy_nonoverlapping()` (the equivalent of standard C's
`memcpy()`). Because of the atomicity at byte level, when the copy races
with another concurrent atomic access (or when a normal read races with an
atomic read), or with an external access (from DMA or userspace), the
behavior of this function is defined: the memory is copied at (at least)
byte granularity.

The helper is the building block for higher-level copy operations that need
to remain defined under racing accesses, such as the `SysMem` I/O backend,
which copies to and from memory that may be shared with hardware or user
space.

The implementation forwards to the kernel's `memcpy()`, which is
implemented in a way that byte-wise atomic memory load/store instructions
are used.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/atomic.rs | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
index 6d27898add42..d25627fa6557 100644
--- a/rust/kernel/sync/atomic.rs
+++ b/rust/kernel/sync/atomic.rs
@@ -848,3 +848,39 @@ pub unsafe fn cmpxchg<T: AtomicType, Ordering: ordering::Ordering>(
     // per LKMM.
     unsafe { Atomic::from_ptr(ptr) }.cmpxchg(old, new, o)
 }
+
+/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
+///
+/// This is the concurrent-safe counterpart of `core::ptr::copy_nonoverlapping()` (the equivalent
+/// of standard C's `memcpy()`). Because of the atomicity at byte level, when racing with another
+/// concurrent atomic access (or when a normal read races with an atomic read), or with an external
+/// access (from DMA or userspace), the behavior of this function is defined: the memory is copied
+/// at (at least) byte granularity.
+///
+/// Implementation note: this is currently implemented by the kernel's `memcpy()`, which is
+/// implemented in a way such that byte-wise atomic memory load/store instructions are used.
+///
+/// # Safety
+///
+/// Callers must ensure that:
+///
+/// - `src` is valid for atomic reads for `len` bytes for the duration of the call.
+/// - `dst` is valid for atomic writes for `len` bytes for the duration of the call.
+/// - The memory regions `src .. src + len` and `dst .. dst + len` do not overlap.
+#[inline]
+pub unsafe fn memcpy(src: *const u8, dst: *mut u8, len: usize) {
+    // SAFETY: By the safety requirements of this function, the following operation will not:
+    //  - Trap.
+    //  - Invalidate any reference invariants.
+    //  - Race with any operation by the Rust AM, as `bindings::memcpy` is a byte-wise atomic
+    //    operation and all operations by the Rust AM to the involved memory areas use byte-wise
+    //    atomic semantics.
+    //  - Copy between overlapping regions, which `memcpy()` does not support.
+    unsafe {
+        bindings::memcpy(
+            dst.cast::<kernel::ffi::c_void>(),
+            src.cast::<kernel::ffi::c_void>(),
+            len,
+        )
+    };
+}

-- 
2.54.0



