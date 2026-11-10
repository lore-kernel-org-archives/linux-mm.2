Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF9760A2628
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MGMx1MEc
Received: by kanga.kvack.org (Postfix)
	id 657BF6B05BF; Tue, 10 Nov 2026 09:45:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F856B05C0; Tue, 10 Nov 2026 09:45:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E0B6B05C1; Tue, 10 Nov 2026 09:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 229A46B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:45:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4D5380914
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:45 +0000 (UTC)
X-FDA: 85419483450.09.9E19B53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AE41910000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MGMx1MEc;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=An+UoRcLcybFqNhUI1VVYZuVSsp+y+lorKmzt3et7Ns=;
	b=XnLW6M08Q9eiJ7jg7XIKZk1Xp8x0kykwoWC5SqVmWlPYy6M4XzMGCiZIcfdyt9sMUnKc29
	ZJR3+JUifHrqNrjofGEtI0IeXZnrSeejCPW5UgDyDg93u0Zu603SsMJlUy8Hm3rQKLz8Mx
	YzGgtwMO8StiCJh1z01mYIgZX0Urvd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321943;
	b=20YUh+8FqHfezNch0d6BNZMIZIlV2+pp4F2o8DHH3HRISCOmI6Ydp08Gcg7jfsyq09Sbjk
	tyqpG/IKnIpHJ1bGKT41ZL3druDSx13Hw5dAbpG//Hv7zZPICUyIufDo2G30k7mTwYdyGB
	rQZhPRDxGfDTzCTTCibYslItKc96Pxk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MGMx1MEc;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D42C40B6C;
	Tue, 10 Nov 2026 14:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B861F008A1;
	Tue, 10 Nov 2026 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321942;
	bh=An+UoRcLcybFqNhUI1VVYZuVSsp+y+lorKmzt3et7Ns=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MGMx1MEcAJ02/s0uZKDaJPBGmlNnl7Xe5abC+V05BkKzNvOlPRaRgXr/qjLtzKBic
	 6+lQFkBXjcHNgbXJ55Js6Gl5KeqEAJbz57XF0OKtxX/Of7+BXdkT+CMBrP10Mj5/L9
	 RIIhJne3dh1syLZu3Lhpe6Olsuf6AGFnvz4rrTA/wWNPApf4d0FwLlXJ140fnTqmyk
	 36V3TbugSZ1WAtGIVOHN84kX5e8qHyofRilwd8pjC7/PtqiZ5E4j1gCJhCj6ARPSpn
	 9I9sp0028Ed7JDHwSvsz6wknf6RP1Sclsh0pK+50bN6Vc8ScwO/ydC+zaMs9oBFV0z
	 5ZrdWHshIRH/A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 10 Nov 2026 15:44:20 +0100
Subject: [PATCH v5 2/4] rust: sync: atomic: add atomic_per_byte_memcpy
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-page-volatile-io-v5-2-a91ef252c24b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3203; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=tp52aAy+Z9rAYPQRdCxlgmWEe36E+phNN7n1uPpdvBk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq8y37IKKLgvx5fqPNBPuoiU4OEBMG4lqThQRZP
 lvpw/uEHfqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavMt+wAKCRD6UCkIqsW9
 0BOdD/9VeKOwu5P6ufuouj286hXDgR1+enxQQwIIjBFPmpdiJ59HrJFYd7YHhHlJW00gFgfzb8U
 6m1K7p4or46AkJqBHSJwJ+3KvowOvVzsrG7ZJKY3Z3U3ecjUFRzOwZQj6jVBddVNXjLdepxPQK6
 2mHh3aAaEJ5/GFg3LeSIKJrYjg2DO52aD6Lsj6v16mYdBYZttxJUWZ4GV4FZ7Jlj6qCBhFkZDzs
 XDti1gKrv0rpkVRKzK1bNgFX9K5JzG1dv/gTcf2GPyp54QAsz9h7IdQM60Iwj9cxVgYEy6w0RxH
 Ij/zQ8YT2Ls0qSnBVldf43gOoNRRqDAnM4jwd0OESLXa9C59q1WMANNAIHMXxEF/x+63VYvKxR5
 59uI/VQ8Xe9C67YeZ8pWZnO2XqKq3YzUk2/utI54CkV4gTpysYHSqluH8+nHQMRXxpOLCP+0JA/
 thyhckgKTGWKOvsLVY8jJkIXbbbGXGBJ+JtkGgDe7V1NglzyrjAY59xsHop4ZBKGZSS43jvJCtn
 NOKTt++5YkVvI9PBK6O6kM9iQvKIAgwFF+Yky8fgB6ntVlp+L1CmXLa/TkQ3DFoN/mqvLITwLx0
 uJGH7tK8lSv7qbrt8xeh21vsd3R6An4Bi8JCVTJ5d2zTo3UiJILb3VZqs/qWmPKnlz8paxcbOfv
 KwskIu09jtvi77Q==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE41910000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: k5zo3snrkjynks8gr6fo7hwhdwssi9en
X-Rspam-User: 
X-HE-Tag: 1794321943-960741
X-HE-Meta: U2FsdGVkX1/VCOcj+STVuBzmiaJMnpG6pqgD6g4sz1gwV0hLJb9Tu9tRE86fV6+EA7fRSfdDGaPnJsiB3sA3eZKtpCQ6z6gnDylBVlnRHJfE2L9efWQZOpQnb5ZEn/GxbgQSucC9nxAlIlY3ykSkm4AMxxvohKbxyzrnQ2h8yD561FJGcl4mwl1rUJPpKz7DbHabXAGefq6MxSV3/W39bsPx5FGi/HiVnfWy0x0vZ9oPz6W2aUyOYBH/BoU38HLrr9N/6QDskc0mzhDT5POFxYgbrVQxISKO7XB0XRt5cSb/W3VG3wngY8EdQE4oA+NFHv2uxu7z66i2WB5MOJ1TFbmtpuqYo/UnDPWAuhso8zHUYRqXtsJjrlIsSHIBeeLW896YeedACyODBiVZJJxrBRF6UOnpZ0+xbRBjy9g7G0xMpRFxWAUupZhQLNcrbOl6+CA3Bx8gZGu8SB/I+wSFdrsIXrtoX8vmJ21Jjc9cSGV74mZAFkAIg1Ce1hpRkXRPB5LtFTlwRw2inQwaaHLj0UZuY5QJAvpLVobdll55Szsm1M6T041s3y5FNuhwd6cEcFjRScZHAIn1eO1q/FI3eQN1g4IG2hTWzndM7o5RtPuoNKpYhqs+jcB+mr6VK1upv7lgqtFAyeSaqVoGb8uxmKKwiNmQ4KdlPszr25aIn0hoFYMCWI1Tpj6V32tNY7FsZsYjuxLXpHp2YgBumFki7iWAfhFBi0hymdqDbSwedRDwQCpgs/H9DF90yddYc7GjghMe0H0pw8aXo0bfdI6hOqclBEcmC57y+wA2s5adLt1vtYA6+xnGSXWGXH9l1TwdFap2QLofWs2cdO/bHoBRb8ZSYlt3220Bna6RtBaI/v+lqhmwcs3u/CgrnxlV3UZh+nBooLAOtR7tui8KSNE3kEmvHvz/uKPwb9yE0N6vqyZZG6Y1/103euNhAX3y9b60wjZJtFjHjiGEzuKfd0O
 P8vqWGRF
 PhPk7NomWEhAz5jvogsy8/QllSJl3hs+XNZzgNajAbQeHAvbttrWSlfhjqwKTurF8YrHb9Kpr7AfLZeX6gOOGrWT5y1fr0/ueWgd8+3zsCRZn9My1dLauKyWPV0CXotrVZKoi23rX9IJSmsnDH+R9uapvEjZ2UQA62t0dtsZco/nWoZ/Lkzfcj1ViG9a304+NW8K9chcZt4CM/WKXxsnoSZs6IvG4Ay278vGd2HgPWZ+w1Sz1iV+G6Mv5L6hMitfXdbnh1euuBsE3OmeMtxeZ3WohjTWCWOxltEHMYVF1plh4iIp5AC8i8/vHA8YGnPHh4Z+sWxF/Pv7IEf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a helper to copy `len` bytes from `src` to `dst` using byte-wise atomic
memory operations. This is the concurrent-safe counterpart of
`core::ptr::copy()` (the equivalent of standard C's `memcpy()`). Because of
the atomicity at byte level, when the copy races with another concurrent
atomic access (or when a normal read races with an atomic read), or with an
external access (from DMA or userspace), the behavior of this function is
defined: the memory is copied at (at least) byte granularity.

The helper is the building block for higher-level copy operations that need
to remain defined under racing accesses, such as the `SysMem` I/O backend,
which copies to and from memory that may be shared with hardware or user
space.

The implementation forwards to the kernel's `memcpy()`, which is
implemented in a way that byte-wise atomic memory load/store instructions
are used.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/atomic.rs | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
index 6d27898add42..cbcb081d8674 100644
--- a/rust/kernel/sync/atomic.rs
+++ b/rust/kernel/sync/atomic.rs
@@ -848,3 +848,38 @@ pub unsafe fn cmpxchg<T: AtomicType, Ordering: ordering::Ordering>(
     // per LKMM.
     unsafe { Atomic::from_ptr(ptr) }.cmpxchg(old, new, o)
 }
+
+/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
+///
+/// This is the concurrent-safe counterpart of `core::ptr::copy()` (the equivalent of standard
+/// C's `memcpy()`). Because of the atomicity at byte level, when racing with another concurrent
+/// atomic access (or when a normal read races with an atomic read), or with an external access
+/// (from DMA or userspace), the behavior of this function is defined: the memory is copied at
+/// (at least) byte granularity.
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
+pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: usize) {
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



