Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D27DCD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689076B0088; Fri,  5 Jun 2026 06:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660AD6B008A; Fri,  5 Jun 2026 06:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EEE6B008C; Fri,  5 Jun 2026 06:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A31A6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:34:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D7E5C340C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:34:39 +0000 (UTC)
X-FDA: 84845500278.29.F222DB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CC52F4000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:34:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvGlW61y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780655676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7JQf8IUtRGP37hIV4LYjpS7Iz51JvjpcMlTL4+STF0=;
	b=JZXDvNL6O43uGtmR4wbJmTRgXXk6S/puSnroehMtaEHfEgax13bzUhUFb36OOKSKXO7C8d
	NQMuw+J0YJB2agi6zMzddqexUqH573ZhZQIdlClEt1yNHrBCCY7g/jinezA6SeGjGYwdEX
	mRI1mmgeEBoSlegiZsNjWtG9flWrcoU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvGlW61y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780655676;
	b=Y1yLy53JrJn/dMdOr5euJcE4Rs5bglu5mDZWp5RMYnkMvlo5B3pplJ4zdWmIZE17YhlwCo
	dFvkbEkXlU5gXCyUXI4bPzhoxB5A54kdFYzM1/D9R2Nu+JnNYnIp/pzfKQfdPlrz5sxT3O
	xMEuqzUIoUp5MhOdV4xeopH/7mc+mFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BE37601F1;
	Fri,  5 Jun 2026 10:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CFE1F00898;
	Fri,  5 Jun 2026 10:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780655675;
	bh=+7JQf8IUtRGP37hIV4LYjpS7Iz51JvjpcMlTL4+STF0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IvGlW61yjtcZvNvfpsz8yYcP/YVEMZHbe342EhS45RnmQwwoDZs+vt62/lmCuslC7
	 O5TlQ7DD5SZqj3LobjPRTEJe717h6ycoIFa1S65p4beAOngF4wngZqGA67ARGikh5X
	 KljHOYUEIm1PzUhCpRdAdjIX0U4ZHiajCpWu/vSiLHgMXRWUsNFp304/0oFs/cTaS9
	 jfP8RkvLLbVjhGKfi2hI1VPyuMw2vKVtIqz2y+QpWcsTadrr2COguCRyAWzEOVTytk
	 6voLYSlN0m5a6ryoKi4kgtbMbqSXcbE6bpjWW1JNrZGB4KGH6T9J8ieFdOxBzBlOMT
	 zM3daR2QHGDTA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 05 Jun 2026 12:34:14 +0200
Subject: [PATCH v4 2/2] rust: page: add byte-wise atomic memory copy
 methods
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260605-page-volatile-io-v4-2-0e217d9bf11a@kernel.org>
References: <20260605-page-volatile-io-v4-0-0e217d9bf11a@kernel.org>
In-Reply-To: <20260605-page-volatile-io-v4-0-0e217d9bf11a@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5384; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=DX8++9L27SP2fzIpUixQUyM6WiazGqLQWDakH66n1oU=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIqYqBtBaekmbf4rV8ceuwFuR1DUVbhBXdQxvs
 6JRnWUKVbyJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiKmKgAKCRD6UCkIqsW9
 0Dt4EACDRgLGFbSSmO6aZi4d1MvDVtc6UJr49O9Mj/u9i9d6Z8lMYIlaXwuVqPrSOJSzQ9EOPv4
 QEb8KWZvGyZ1ZFBZsAHk85tnp0/vHY3d0RKRraMJv1gHnUd+a/bYu9+Dur9T0T34CaVCCXYR6Ox
 HNg1BUkyztNBystgcH8amPU3O42Oz/7ZSrueGexznPiGb0FaGN68v6WycMhZDDWZqWOm76J07zr
 0GMRNY5QX86FBsfpSLYXd4wZ+/tRACuEjHRozKWsxdbsnm2jGuyZISaHSoiqg6rDSL3Sk8N//r2
 JGWPNL/spaaC9tH7HjHuU4LxW2/aluG14bZUtoSIqZaTuI2l6rlDvPnJbbQ6ttXmogkJrrCQN9x
 uj4hZKNFURbI0jtLaUdLPjci+uS1Uxrw1eOq/YbhxhC0eHCbOPyszWvZS5tavW+TNvDAkQtEC3V
 ywp9MRaT/G5hSIYruo5U3YWFOR2b9I1vKOFtiT+ex+EkwV0arqPNHi7uzXC56fM9VJ9v9JkmrK0
 hOv0tocKxONG951TG+S8k7r8Vbxww4fiMLrO3oDJZfZx628DOUpqzUBJRrWAT0Adu1Y3+R3yTh8
 E5q8qwZX+yZLgr3qw9ui+6qY7rk8UDnE7dKYdgQLeRu1WTaGypp/mNSH9v0ihZDVBIQHNlDDpu0
 6XihUunKp3R/1Gg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC52F4000C
X-Stat-Signature: 5tp68i8qte1trm96o81159t3y56hwtpe
X-Rspam-User: 
X-HE-Tag: 1780655676-378405
X-HE-Meta: U2FsdGVkX1+aCpRn+ZOHy1rXrFQR3E8cJsYqaJvDvHUFvcn9n+l8igw4UwrCHZM/tzehumFMN10kU6MxMGVeW6MJX8t2BLn5uFHYwGJW0w90cKvguu+NGEAXGpYsxx/BgwyAJH5XAm7DgRWqdFqAOjb9W6pYMtrtuKzgEie86Vd8MmopTj3UWXFLOfhoTvgdH+Ax1hC8cd1PmoLzTzY/G/JHqRVT3ajdJy6rM/IlrEVbnZWX14NSoGnZZDu5T9A1Q6IG/1bQ0rNG3Jquz+fgAeR4iTs7sgEnHW/bFclVFrGNuPe4j/4xOjR+VOo9awqBkl5JjGMY5JdU/QU/BH9H4DCM5q6h835E3TfsWJaM31MzfrhuJgHr/2bHlmhGKHpbL1cqhy4I7rYxoYACRePZGBCxZg9PTy4mUKWe5DtxjYkAhUd5DqMZn45yg8q6pTekY84LCcjkbEvia/YhE0W0LY5lsRDRgGcOLPmqVWS91jAStSxGz8cxoUPl3Fwmf5rbcYKmlxuHTHDj2P+NxIOPBWTVJ1eTYgaieki3IAQucr1LKcH7TJEp8CAtbom4KVXuWc9soqbd8Dx1SSi+htvDht8b6BrnIlckc8ZmwGYE35MYOyq4XGurZcYAdcfGQN5kguBxfpHpcWRA7Lnt5koQacewc2MNkxjoevX0B1TVGKLc+8BuNJ5jQ2lV7hzbljhJ5kcNkJvq81SzqGXSVcpv7GvVOFNuy/dvBCbD53gsG88k1cwY1kxsm5HjH/ZcVKHRtSgoUjijCwa8bxNXusvC1g45Eew5itD+zKAspzsTEyy53R+4uRcbmyKXO0SAXW0NPXW5dnjhnhybMdYYRoQX7/DTjNUXt0bR9pB6YtCVkSKyB4ntevZjYgACRPwOp5lL87kAKAQK+RUKR/5cdFnrEbWT2fyPyVd/E013hDKoDmtLMfsZ1100TglW/j/opWNbZpCpmz2bMd/RQF1feg+
 U3i17syd
 lyY0nSnihO18+/EhZsPLDxbF135L6i2yX+1jxAuNaZelXwWyqLp9VPJd39E5WUSU7xFWhnZyXwCEjf/6yEmAyEu3qL6GlEg/ZJk85MZU/sgKHg8eqyRuC9IPoqr1qcewrrgK8tyGYp0qTyjEfee3HeuhLZcchNJA3hGFTKcg4C8FMBivGqDdex3EZSVhJlKpOk9MRBwOerxr6ZWFxoZ6kWqVcQCbm9XSeSlC/CN/o+uyvFDNOa1JwUj9tQyd85U8EMeXa9LbOrtZYhHjku3f63wRwucjmD9QaNY8R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When copying data from buffers that are mapped to user space, it is
impossible to guarantee absence of concurrent memory operations on
those buffers. Copying data to/from `Page` from/to these buffers
would be undefined behavior if no special considerations are made.

Add `Page::{read,write}_bytewise_atomic` to read from / write to a
page using byte-wise atomic operations layered on
`atomic_per_byte_memcpy`. The methods are asymmetric: the parameter
buffer must support byte-wise atomic accesses, while the page side
held through `&self` only requires the absence of concurrent writes
(or of concurrent reads or writes for the write variant). This
follows the intended usage where the page is private to the caller
and the parameter buffer may be shared (e.g., with userspace).

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index adecb200c654..7bb201442679 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -296,6 +296,38 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
         })
     }
 
+    /// Maps the page and reads from it into the given memory region using byte-wise atomic memory
+    /// operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
+    /// outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// This function is guaranteed to perform byte-wise atomic memory writes to `dst`, but it may
+    /// perform only normal (non-atomic) memory reads from the [`Page`] `self`. Accordingly, the
+    /// safety requirements below ask for byte-wise atomic discipline on `dst` and only for absence
+    /// of concurrent writes on the source page.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    ///
+    /// - `dst` is valid for atomic writes for `len` bytes for the duration of the call.
+    /// - This call does not race with a write to the source page that overlaps with this read.
+    pub unsafe fn read_bytewise_atomic(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
+        self.with_pointer_into_page(offset, len, move |src| {
+            // SAFETY:
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `src` is valid for `len` bytes.
+            // - By function safety requirements `dst` is valid for writes for `len` bytes.
+            // - By function safety requirements there are no other writes to `src` during this
+            //   call.
+            // - By function safety requirements all other access to `dst` during this call are
+            //   atomic.
+            unsafe { kernel::sync::atomic::atomic_per_byte_memcpy(src, dst, len) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and writes into it from the given buffer.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
@@ -317,6 +349,44 @@ pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: usize) -> Res
         })
     }
 
+    /// Maps the page and writes into it from the given memory region using byte-wise atomic memory
+    /// operations.
+    ///
+    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
+    /// outside of the page, then this call returns [`EINVAL`].
+    ///
+    /// This function is guaranteed to perform byte-wise atomic memory reads from `src`, but it may
+    /// perform only normal (non-atomic) memory writes to the [`Page`] `self`. Accordingly, the
+    /// safety requirements below ask for byte-wise atomic discipline on `src` and only for absence
+    /// of concurrent reads or writes on the destination page.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    ///
+    /// - `src` is valid for atomic reads for `len` bytes for the duration of the call.
+    /// - This call does not race with a read or write to the destination page that overlaps with
+    ///   this write.
+    pub unsafe fn write_bytewise_atomic(
+        &self,
+        src: *const u8,
+        offset: usize,
+        len: usize,
+    ) -> Result {
+        self.with_pointer_into_page(offset, len, move |dst| {
+            // SAFETY:
+            // - By function safety requirements `src` is valid for writes for `len` bytes.
+            // - If `with_pointer_into_page` calls into this closure, then it has performed a
+            //   bounds check and guarantees that `dst` is valid for `len` bytes.
+            // - By function safety requirements there are no other writes to `dst` during this
+            //   call.
+            // - By function safety requirements all other access to `src` during this call are
+            //   atomic.
+            unsafe { kernel::sync::atomic::atomic_per_byte_memcpy(src, dst, len) };
+            Ok(())
+        })
+    }
+
     /// Maps the page and zeroes the given slice.
     ///
     /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes

-- 
2.51.2



