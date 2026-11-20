Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731D4606A332
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bV3LASHj
Received: by kanga.kvack.org (Postfix)
	id 904816B05BB; Fri, 20 Nov 2026 05:28:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4D86B05BC; Fri, 20 Nov 2026 05:28:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3706B05BD; Fri, 20 Nov 2026 05:28:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 498826B05BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D078E160EA1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:21 +0000 (UTC)
X-FDA: 85455122802.06.CD9BC46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1A2E340008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bV3LASHj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170500;
	b=5/eXoxv9hqkwD4LeBSlJITtX76jYafG9waZpCECQohYoeMY3ZptPOz/ti1a5qFiqyEHwZ5
	3fn8klMU3YwHfvqPrHloMgqVKJdDlaRQsd5prdBX1kifrz1nJ647ReCCX3ByymnQuSUim/
	iuIl3ISK9x+ISUObgp35svLPvYNCJ2k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHveAKTEDN4NYdhUSH387fDwb3sUmTakUTnrExxlxOU=;
	b=0kx1xVJRwzikruEZpjpdz0Flwh+AWDBCUa7fYT1SvOclPcNfGG33U0UaAZGUHWpH8v7etX
	K4oInOQuhArma5YXk1hHzoI2ZkCl7OOslK74iomsdMGPnm0MkipwWfEPu7o4laQLm3EUCp
	2nYDQJGheY0lDoGDqouB9IAeBWu3eao=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bV3LASHj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3A47622CB;
	Fri, 20 Nov 2026 10:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A934F1F000C0;
	Fri, 20 Nov 2026 10:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170499;
	bh=cHveAKTEDN4NYdhUSH387fDwb3sUmTakUTnrExxlxOU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bV3LASHj59/nbCQaNlM2I/rYH3SC3+IM9mHeTzxpbKK6ugAXrOSSKYaMhl302lMzr
	 pgEQ6hWmn3H8ASXBM1f63fSRTnHr0He5lkk8/de+opK3Z1ChTI9g1WrnLrKH4hz1JD
	 o0CrqBdUPZUA3nR366hVL4d+i5gM/nlIOLlh1F+EPPBaUC3nudPhT6r9T3NZNMK+CN
	 C30I8XbhipA3esRH/s/zFAfqSOrxkG/RamrWT/ue0g2gIYU3KgvhQN+NIu244kePPF
	 n5YXwJhrs5ez/w9sYXmChEfii0HPFe0ZNnep39xvcSRBwK9CDtfPof3KXSB28LPPjd
	 X4gDCMbBOXZgw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:01 +0100
Subject: [PATCH 02/11] rust: sync: atomic: add memset
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-2-66f8c4c62822@kernel.org>
References: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
In-Reply-To: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Mark Rutland <mark.rutland@arm.com>, Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2104; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=yMzl9aHIm/fpa0K63eozFcBZNRxJnn4Ax+IoHBwntAo=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCDCWnbNdCWH2u+lRuEr6lnssP2hxSh+2uYU
 QQ/LE9Jmy+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAggwAKCRD6UCkIqsW9
 0JCLD/wOhxCyQLejQqbVhExA4vV2s6iiCH7eR0E8w91k8BeojNAz/PCrUJLLs/9gArQG4rLH+cJ
 tRAJz+eVW126g7aLZB4wGqB4T2q85V9agT0VVCt2X2cPWDLuzX/zfOnLE090Sfz4ICcgOJKbmOg
 lLbx2hzWsGrG227sNHvTuK/Ks9JAxtMfApGARqwcNsaiIeoRKAACvP1KK36ZsqyJrpUq83Ndsmc
 jKwrmh3tyLX/cVERQar3WWfaiangmyixb5LJjv2bTdIpUzYag1W8nVKpcZyDy6EmaLp+l4NZHic
 PLR1WF3OqvUAaNGizlEFvub8vtfk29cGjG7+Ukp0abmtCSsB9OsKWKl7w3vMcOKxoIQTxw20APx
 O/QrjxHzmppaBCIZZgfQgjVeasBAKzWVOOHAEYjVS2MOZVdmHZhmcgsxahztJ47AdGabgFaNGXL
 jXkBeuRO1PLah8tbGtrPZ+YHiy2BedYUeKT17iB2vYFB5CM1l36k4NQDuP724VzsHdxKFs5CupH
 HvZxjsltABJPEgfx8oio1vUGIaPM/tT3tA+TAV1OXaD389CAT1N9rMapKdWzDUGeRP1oAJFMFHi
 oLj+bG+EOzHwP1YAHkCyCtS4fp14OqWi39B+vP+Z8NlU4/Xm/RPFs5hVm6MH5BkmyrAXwMCtbBJ
 5l8h1mvSnX30zxQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ie7tj7661u1pmx8i3ssy4ytmfjjp61af
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A2E340008
X-HE-Tag: 1795170499-241771
X-HE-Meta: U2FsdGVkX18C8yt/rV5A4FPiv8G7IuNJU1JzK1n6VxUkzryIWTDRLPBUlFHUh+GLqBHL6gk5dXfXne+4UtS/CMdsRJWEh8mpxGnyhLiojsVn4gl3P8xHxofyn+mKpCVlbRTEKevKQE9OIoMI97IC6v3cpLYiz8I/K/fvt0Q8MxYtZJKwRDcCEjO0WJ2R7u6jmsRTJgMQBq9+AUN5dX1dlYk4eCMvPr1CJadZdyF/UNxSHGtjR8boFyzE2JXYZKDTuKwqkW/HDu3OSRDSL+RYwYT6EcNykt/j7TQNTy6117+qL2HfENwe64/BVj6kbpFEsj+XDgwlJtA6ocAd/inthpQ+n1c3uLNVPYf4g1mxNCZ1WOrYQ5QA6eTEF0UmiqkxJVy3Br+3ggkyGz+QiQ8HW7Qi1o/UkQW4rDL+1aryTD/PD8n8fbv+IAWpxyt9gnp/tp4iNZvWH1wdzP14sH7AA49w0x8h76FDNHrsaiCV5caPRQKyyB2hzc2hIx7pDh904fh7CuTkIoSZ5HN9vKgvU99NuCqNUXaEviLhmfPB9y4/a7f8nDWYFhEfDE+co5uGQhtXBonUxbLaI+M1F8QilZ5O/TVKbr3ZkIIxDuyh8/mgbE8t/wvbeLnrRBHFtkMCVHKNHkfZ87eytGqRKc0bQm4ZgWaDxvRsf0sko7JZ5nyTAimM1eKwxESoryyp0VZRnc7QHPwbmdtw/9ZQLVFjEql/Vf7LuWhU26KTwiKLM55JtDA4mdsXln4A8zUnLyoCmVu8/9sesNKyMSIKbHDI2wRyxpqc4BbmBotB0pK+1ekLqH554vGUsQ1I+hRI80lnBZJbwW9QlEyMrNgWPxVtoqCUQMTiEGLW/TxUNvj5dDZ91gV56Aig/wIPeTzoK0c7fg6dFLahQm7Ty7sJJxC8ZRX3Ef9JT6Tlzuo0n++pODGY2mlWI+M6mbQLBiUKOSy8cCaz8Ud+FgMFq8f/9Vv
 AYNu+1lc
 2LQh9HmdqY6oIsSbXAuD+k4MMAoCihYhF9aavdYO02Z4M6zIl71yZT7cNMzxJtYDheRszHihO7is5ODrG6t5BNKSyTnejuCcmz7pmI/l89Hm6i46K3XDej83OmEcxgDeSbeODnJyAol9nYuHBQD2HTv3chffdpyf3WgPGB/8hFXPGXWY5WHcedJEs3D9pSurwxLp0eKffVfOJHyPjERTIEGHXrqBRVGRvpaO3Po6wy4tH4BnXtpTRIcHam+yYaErjgNP66UlGjgcb8qBv0G8z0FyLjX621CZlDa11A3W6JkDpNkA0auL+JVgbtN7voLU62RTP17t3tauVkNDE8D/fHF5JqxtIjWl3xW+KeZEpPaAktD2T4Pf5Z5OM0uN4jTZxQVRXVjowvJF5+kKSZBwBzyvq6nujIP0p1Omc8SPVTViy7E4w2o3FbbiS+S1ZA5sbcgCZHmSrqS/M3g6XO6giWuqUYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add `atomic::memset()`, the byte-wise atomic counterpart of
`core::ptr::write_bytes()`. Just as `atomic::memcpy()` is implemented in
terms of the C `memcpy()` function, `atomic::memset()` is implemented in
terms of the C `memset()` function.

This is used to zero the data of a page that is subject to concurrent
accesses.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/atomic.rs | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
index d25627fa6557..ca4ea8cadae1 100644
--- a/rust/kernel/sync/atomic.rs
+++ b/rust/kernel/sync/atomic.rs
@@ -884,3 +884,28 @@ pub unsafe fn memcpy(src: *const u8, dst: *mut u8, len: usize) {
         )
     };
 }
+
+/// Set `len` bytes at `dst` to `value` using byte-wise atomic operations.
+///
+/// This is the concurrent-safe counterpart of `core::ptr::write_bytes()`. Because of the atomicity
+/// at byte level, when racing with another concurrent atomic access, or with an external access
+/// (from DMA or userspace), the behavior of this function is defined: the memory is written at (at
+/// least) byte granularity.
+///
+/// Implementation note: this is currently implemented by the kernel's `memset()`, which is
+/// implemented in a way such that byte-wise atomic memory store instructions are used.
+///
+/// # Safety
+///
+/// Callers must ensure that `dst` is valid for atomic writes for `len` bytes for the duration of
+/// the call.
+#[inline]
+pub unsafe fn memset(dst: *mut u8, value: u8, len: usize) {
+    // SAFETY: By the safety requirements of this function, the following operation will not:
+    //  - Trap.
+    //  - Invalidate any reference invariants.
+    //  - Race with any operation by the Rust AM, as `bindings::memset` is a byte-wise atomic
+    //    operation and all operations by the Rust AM to the involved memory area use byte-wise
+    //    atomic semantics.
+    unsafe { bindings::memset(dst.cast::<kernel::ffi::c_void>(), value.into(), len) };
+}

-- 
2.54.0



