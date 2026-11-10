Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3544160A2623
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d92FgsfQ
Received: by kanga.kvack.org (Postfix)
	id 064276B05B0; Tue, 10 Nov 2026 09:45:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B9B6B05B4; Tue, 10 Nov 2026 09:45:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94086B05B5; Tue, 10 Nov 2026 09:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEE396B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:45:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BD0B1608DC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:39 +0000 (UTC)
X-FDA: 85419483198.07.2689CB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BFF3180008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:45:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d92FgsfQ;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321937;
	b=XOLs1l+dT0Vu7aGVzKe6kOgES7YGO9JnBDuDx4zwCtdB3iQvIsviVLNIXytfJ3bFsHKZnx
	5tHUXLfToW50UEl31z1h8iG7JyhEzzfOr6CDrfcsJGW9eXy8RIVbvR1u43HdEpo1ETXHAf
	GhQTuL174VYt6aCPgK+6BlLJo3/sB1E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d92FgsfQ;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPqP3AioUFfQKztBBWV3IZAPOrIVFlq4HM+xiknXRb4=;
	b=J9j+b1RwEiqIJT9LlyjjL55RUHwijlTn/lbR0yjeaNeYXjqlcF6MRQGNcYUB1drbgc3M4O
	bsIoqXQzrpNtIsP8gPVy/jSH9Yh1Lhyn80yM9Ufflp2X7sULXniaBoZESHX7HOEUZ5/+Lc
	yEVHwZISOlLDkcy+iHhM8rZkrYXXFjg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EFD9639D2;
	Tue, 10 Nov 2026 14:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EE71F008A1;
	Tue, 10 Nov 2026 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321937;
	bh=XPqP3AioUFfQKztBBWV3IZAPOrIVFlq4HM+xiknXRb4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d92FgsfQ06bGMIRNBBVMq++CZTOjMikIQlWl9oCUQKAZURpASTlq4Z6F+6Y55qQ53
	 TFDjAVtcmEcwCR/quqLIvgyzzlaVUNLseK8Cuzx0IP4uN9arM4rhYWQHBrwE70a0Xh
	 PJjE5M8TV/rEkU7o7JYVWRdWtzZkE6LNIbK9nAWFIdtt1/vR9XXihTbYFPItJGfzpl
	 C5vEYkGY6P5YWPbDhdB1yfbP4pHpOCIBWaQYrpiGlVDZaO5u1z8suH5gBcSdQzzAVk
	 6JhMMUhk5VarccDQ03OTalYm0gVddNWNfb204yQ3TwdLIjdKz7zk64+slhRAUeQQ1O
	 4mu+jhTQVo3Bg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 10 Nov 2026 15:44:21 +0100
Subject: [PATCH v5 3/4] rust: io: copy `SysMem` with
 `atomic_per_byte_memcpy`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-page-volatile-io-v5-3-a91ef252c24b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3338; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ZejpXXvNrU6pIH9Vpp03LpzkAZScISJJ50Lu4nFvg7c=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq8y38NrwaBIi3FYNgiPYhzvrryZVoOEERHn96/
 NBPqcWfqEuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavMt/AAKCRD6UCkIqsW9
 0EneD/4w6Y1oEGE5aD6xSAKHWCYv47PTVWmiGhedDPkieHTXGQBpadKBP2IHkYy6JdDJK6HibVl
 N9K8HYtNYMGe/vVcmrpiQPgO0H9cEIyPB58Fy07U34N5AiumBgwzQoNx976zBlAsoxniod7pB1I
 8GZ5YkoS/0cdYxrIM64zZ1Lx6/us5BN6t0c1HmNgj7DRtW4MC5zS+ZdIX5/2vLi+QWDpRvoaSrj
 w/7V6QbpRflEQQBTAvhsvZY1zabrOTXYAsfoYw0GOBidAtcJti2KJDY72f04aDGBNzFar5pcy3C
 29Cmh9dQ/x2IqVTFp7rPHJfM0AhEJrEIe8qR+YM1+RRA3RuFlJL/gBF7PRSLceMwy2Gwg1FZLkd
 olyWcGytdvG0zs/dxRLuS0fxGVkL1vvPUcVRbbm4VHwt44322BQvTTWGuk+uHKXoTTPHV4dCLDt
 vX8LwtlO7uCcWL76rbopVIAO0gnFQ5Lw61QFuIpqZEhq4xf65xDN77YfFYS7a6JwrFKrdWB25df
 c+8mE57hyPOspEYjZ4JN+jYJeyBIo4rshIaTdUtcut8xTzJBZ6kPwlpBHu1NXpmG7O64J9Jsa60
 sgBRnazS/th+CpJS3ENdS07gLYRiuFW7xmMEOVSd8ErSVbUFKn/DUfxcj80bTumOxwGYQ4VeBsF
 uWzR1608VBa1DEQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: uyntkysgxxzoiwj44gw81jjod8iko14h
X-Rspamd-Queue-Id: BFF3180008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794321937-831347
X-HE-Meta: U2FsdGVkX1/ZFBo+EAa7c2+dOQkyQVtty4MofCnMOOdvyt5BeLNENn0bzT+xD7jJ3vjR1bduSL+FmKum9zH77lfcZ3iGa/1LLKanHbN/V0l33Q7Aoz9DA5Pr00JCMc6PAYinP74/BGrGzrLGfQvhGpXx7BJWeRKYHDvYlQxcEHDqKZ5sbwPlTtlepAQlJIg9vws5tGrkbs9jh8Pb64ex+h44yo8M97yRy1wcw101HccXg7XYtcb1NOX3ItwYb91pUCtrrHJ/VZWdiQ6nfx2J6w7GnT5f7abw6v6OLgwQ+ZLU5ftIapv4FqXEP5jo59VmlGfb6nJ0NUxDBm54sPSyh4n+yjXwSh97g+zmYjz4qJt+qnawE7Mp8o9Bb1ivmJEQuNqMmQPea4mI5GrT6OjjtHHonFP7ByZfdZXuGXL3zHQtGsYkfXOcaI2h2g7GQkNx37GG3iS+VQSkHHP9IkyUNeYG5h/h2RPH8ygCNz803BZMR+kdvxg968aQqwUG58Tziy/W5vGBVLOQysDiod7QbH0aLWxg3sCzGriBXz2Un5H2ISWr4i0IEdxZwYaA2l+V5/8bdDf7AMWJC9eRJ+tGclSxMT3i+hm2wLhkpKRbSQMPXwX0jG+rKlzNWu1ADNPb9a5+3jEKKFIDxlOEpCcJeWvwyhkcEMxnnW+Vvwp/bP9SurE7qkSMF8z2nuS9/YMZGBQNePD7y4m/AvIzJvQfBGbuAFVfdbCBmMLNrsVR0QIGIoEs3Shj4UTZFAHmcc29mPZvkuRi33Qo5wajmV0H7YZ2hPtJnnmEDoUD0MZZ67cG20T7OJ0Sefv7xQJgLhg78XHz/oH+SHCMHsIfoI+yqCytUbbOddX6e/dgrKUDk+0NIDeT6nlJkg2zWlDB83v5WT04s3Dh7kIPz44qUKidPSk/k0k0k129DXeazC5m5934qHIfR04WEz+LUbZfoyJMsWixlFOY7QoXcSwawFp
 0+ZjMiZV
 3PkEBfRm4LX+BJQq03PQplgnm33Mu4TcUwVsfcqsMe0lcpc71+/QKzDIucguFvC8WEF5Qd5Be+75fp4TlpUTOOQq2s1JZTja6qwqEpTucUgNuHUeNLHwlWJSARyw7+UzgQ29FQo/JNWz4b/UfIIbgFEwPE51zx6eYnPmvZyC/Ve7zxDZ9cei7p9QPuQyBL5z1JPtaeC9Vrhb+avZUjL5UttMHbZhXITpqFsjlfV7/2J6rvQOEXOUYN/wRAWXcuqpmXDNHElMm6fGFXkxSojcJMIIPYOsxq4zryGn8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The `IoCopyable` implementation for `SysMemBackend` calls
`bindings::memcpy()` directly. The comments say that this is done "for
volatile", but the requirements of the call are not stated anywhere. The
reason the call is sound is that the kernel's `memcpy()` is byte-wise
atomic, and that neither side of the copy is subject to plain accesses.

Call `atomic_per_byte_memcpy()` instead, so that the requirements are
spelled out at the call site and checked against the invariants of `SysMem`
and the safety requirements of `IoCopyable`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/io.rs | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
index 3bc4be35e355..b51cfc04e3ca 100644
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -21,7 +21,8 @@
     ptr::{
         Alignment,
         KnownSize, //
-    }, //
+    },
+    sync::atomic::atomic_per_byte_memcpy, //
 };
 
 #[cfg(CONFIG_HAS_IOMEM)]
@@ -1500,20 +1501,27 @@ fn io_write(view: SysMem<'_, $ty>, value: $ty) {
 impl IoCopyable for SysMemBackend {
     #[inline]
     unsafe fn copy_from_io(view: Self::View<'_, [u8]>, buffer: *mut u8) {
-        // Use `bindings::memcpy` instead of `copy_nonoverlapping` for volatile.
         // SAFETY:
-        // - `view.ptr` is in CPU address space and valid for read.
-        // - `buffer` is valid for write for `view.size()` bytes which is equal to `view.ptr.len()`.
-        unsafe { bindings::memcpy(buffer.cast(), view.ptr.cast(), view.ptr.len()) };
+        // - Per type invariant, `view.ptr` is a valid kernel accessible memory region of
+        //   `view.ptr.len()` bytes that is free of plain accesses, so it is valid for atomic reads.
+        // - Per the safety requirements of this function, `buffer` is valid for volatile writes for
+        //   `view.size()` bytes, which is equal to `view.ptr.len()`, so it is valid for atomic
+        //   writes.
+        // - Per the safety requirements of this function, `buffer` does not overlap with `view`.
+        unsafe { atomic_per_byte_memcpy(view.ptr.cast(), buffer, view.ptr.len()) };
     }
 
     #[inline]
     unsafe fn copy_to_io(view: Self::View<'_, [u8]>, buffer: *const u8) {
-        // Use `bindings::memcpy` instead of `copy_nonoverlapping` for volatile.
         // SAFETY:
-        // - `view.ptr` is in CPU address space and valid for write.
-        // - `buffer` is valid for read for `view.size()` bytes which is equal to `view.ptr.len()`.
-        unsafe { bindings::memcpy(view.ptr.cast(), buffer.cast(), view.ptr.len()) };
+        // - Per the safety requirements of this function, `buffer` is valid for volatile reads for
+        //   `view.size()` bytes, which is equal to `view.ptr.len()`, so it is valid for atomic
+        //   reads.
+        // - Per type invariant, `view.ptr` is a valid kernel accessible memory region of
+        //   `view.ptr.len()` bytes that is free of plain accesses, so it is valid for atomic
+        //   writes.
+        // - Per the safety requirements of this function, `buffer` does not overlap with `view`.
+        unsafe { atomic_per_byte_memcpy(buffer, view.ptr.cast(), view.ptr.len()) };
     }
 
     #[inline]

-- 
2.54.0



