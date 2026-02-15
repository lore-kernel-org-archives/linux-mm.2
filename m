Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0550CE63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC606B00A2; Sun, 15 Feb 2026 18:50:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7657E6B00EC; Sun, 15 Feb 2026 18:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659B36B00F2; Sun, 15 Feb 2026 18:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with SMTP id 905276B00A2
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:49:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A992E1C1BF
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:09 +0000 (UTC)
X-FDA: 84448319298.02.7E1FC09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DA92818000A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zx+uunxp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSfDUbka6E6zhSqZCaOquEpMrLslEzav8NrlIsxGqiA=;
	b=6YBFxE3S72oR+jpZzqPW/MmCChVyMm34ZXUY0m4y5ZiNn0upNISHz5pEOQT3YUKcJE7NeN
	1Jw1NgD8PAt84IyUUBekGB8CmsgTTkirGXpiqks+wD/OQISGgg9g1hMi9nMG3tdYS7d35v
	HLtXiywnvs1u0R5CsmS9+0Gx9y1fPcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198987; a=rsa-sha256;
	cv=none;
	b=Blgu3/wzZ08SVoMwfOIpLrLYDcPb68lFTHkgfNBDHoxcwYhGg7dWvB81BYWS4t4UL4GVtC
	a+uXO2YC9losfZlX2gpi5q7DWWCqCag6vatnyJY63J03bqx40E1/QaRskXH/4I99Vpd0E0
	ntf9mpmvL6BkVpl9s0y6A92lSnMmbMk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zx+uunxp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 693FF6013E;
	Sun, 15 Feb 2026 23:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33F4C4CEF7;
	Sun, 15 Feb 2026 23:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198987;
	bh=g5LW6csT032CGxKoiloM9/8wSOoZndfzpAjeHZm9vX8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Zx+uunxpUs5Oi9tE3v9dXqBlUuE1QYCwU1Ow40WRmAr9MQdSYJi2MpEhhs8tBWGtn
	 0d9tK85IAOB7Z9s8gs1vLmIGSR+CYv8/a9Pk1VHTp7cMi0bUh3RMWHcBQotO6hQAd6
	 4uRQEt6aqwvrVy75EXGa7oFP6GerMYfBVcTi11Hi+/z21i+wa+vPFKTv+lcUGOs/6B
	 cHgO6GmWStx5QtAphWF8If9g6H4Fumk2nPf+Ldc3RNOE4mbLelFsIHimENQK9cud8A
	 Tc7dt885RbQ+bZaBmQpbnQbWMBlLung72sy8F9AIGqDzASp+MIuph1eS7toRFCc7PY
	 QdJM921qm4+eA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:58 +0100
Subject: [PATCH 71/79] block: rust: add `Request::requeue`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-71-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1419; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=g5LW6csT032CGxKoiloM9/8wSOoZndfzpAjeHZm9vX8=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhc/Y1g/b0vvwu95fBzmEX7w8cu76KNhIq5l
 I+j3m5oTruJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYXAAKCRDhuBo+eShj
 d8KzD/41eNC99szTK+r357aOuZhjbUWcBfaAU6NcRV3rPS7DxRpqHPHuQC4LrldgEw5s2KplPUc
 qpB/YUxQFdtmK5WjxqzYnASzOhghp33LoecJM4JfsPhkQBI5V+Y2xu2C5yOrDvmpBTsijhB+Yf4
 Dktc28xWY5XcaEIwAw+6UWicjNjUducMp3Pns+bIAQqxoYwRenWTqbL/CInb4Gelz7PQc5urccy
 jDx3Nx3DtaD0cIqKKECShxBdkVE0YLz5kFTv9wm8VO/NbjPckXRQmfQ8+eAOzJMuUx9/YsBffAy
 rSdbIo6bv7bO01LmxuKi5A7mffoN8lEbts4empUi+Om9PcAzyJEsk6t2d0s2d7SKHM2TvE/ETQR
 3jwSjztJ1uR0fOJXYKjciDBETZ1BlyZh1frvzBBQGsM2qHi/gvbr8LaDwL8bBubiEdi6VMiBG0+
 9hOX74LuVZ4xVRXfOpcW4MSyjwBgsW7dcae4G8nvUaTuSrKDX7rYWBIBSJOUqNBdvpfpbHyVdfB
 M53RHvcf005IKbfO7vK2jK2TAq+S+RMsOrTw2guXnvHfEEzluOMI6nR/m3jGSIli6UqcvfyHbaO
 0bkPx31tNWCf59AgggQ0EvIhW7bTah8omTgcUWAodMRNJvct07//69Rj2BPjGGD+jEAi5JlISb0
 l9TNEwJtVbfy1jg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: DA92818000A
X-Stat-Signature: c8wkbeisa3cikx14br1s9zrw4j3wiwx7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771198987-248636
X-HE-Meta: U2FsdGVkX19CC/q6MlYyPS1Lw6XGjMtMYphbeQkMMq2W92Y5Py0yAkhxsLt02cspdFBisFVB6oCSZn8iIvOlGeFnqnBtngAEKfVYZWZJ+Yd3eT/o0HZlGG1zlyHfRZaXJs7sgPu2XYDfPuHFshYvVp5imQzT/n0qJSoM2vqSdwgyeNK0xK+xFFYHr6UM2rQfoJntHMDX2UAFs7NGzdRRqpep3HLio2N1IPNOzxN/jtAQgLMkYN0j+7ROHjQz/82/zZ6rCYkVPXAH589DXfxf6o0XolsyF7GhzXtI394oUOgIq6awx5GMEavAQhh3UdeqqjdWnyos2NMoDut+8/NBo9xfCjFrF6jJP7Bb1t5QEpv2IYb/oatpPtRDhTWV5ijosNah22OUKw+QRnWS+MnrA3jRf1BB9eRno4+CH2vV3HU+BpMcObPVQ+lt46kDuYKRCvJNjs2TiNxBO2k1iKeeVhTMkXon/0DIVrIDzwgBgCRtQql/22CUvQj6IhquJnsJj4+ntP6vtDvVLmDBDhfJCQnqCj2yXDyNY5wHQUbVUWPjKvFawh3A/xoJW7zCHg9IlbWWbOg4VayOpRe/uJLuwhKrQJSEuHtAYim5Siu5vIBMdLLe+bzrmeUX5ADu6hs41NcZiWnRXdwgP9xGjfi+4xv6UkoJZ7dKexJZi3/nzWyixtoCJMvkmhOgye6hdrut9PBrh3UbiDttTzGxpwyoq6ZrmzeU5l4bGbMnpYf36HI8rZmQ/7+qRKPXA+P6GmosUVltYZEZM00PZKQsQG0kQ//1EOZDHqy3ydrEIUUoXQTMtwPGGj9IjNwEO8JorjXP6a+/XH2RaBB+VlS99iG0het696JXjiiC00jolyxar4MmcUGqYOqWKrN4G3jqjVW87Q3GW+vArhPkhOX/VhQt846qM5YbV6dRdJTk1ZUhNo0y1hKYIhXM0TcMxpljWelSQlJRigcTHzT95ZJFZoN
 xt5hC2LB
 8Ok0mtQN5qkXE8dymRsKgCdRK99Ao7cPWUGs/kQM5R9Mpf0W7jZsqgyyQUO6Wpx10jQQ/G59MqpuUAXZ2PbrUflxivxowH3zt4HJR4O5M81/FsTxE6tdrHWjZsxxst6zKdV7FJssEBCXiAiOAGut4S+cpGLn2K9LmMfSfNQxHaFp333+O/tz8Ty6RMAkGyS42VJl3GrZfvwTFpMSJJMYsGEs7yaVcsLOjhB9/6KMQIcd1J9bpZLQ2s7mKcYWcHKyEwlw1ZZ4XAFGnqEvyEYPUSEhEt3M7nxAncZQ7eD52/jwlIA1npwA41E7WbIiit0P4vG7M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method on `Request` to requeue the request with the block layer.
Drivers can use this method to send a request back to the block layer
without processing the request.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index e2fafe7737379..af10dcbd3ffd1 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -75,6 +75,18 @@ pub(crate) unsafe fn from_raw(ptr: *mut bindings::request) -> Owned<Self> {
         // SAFETY: By function safety requirements, `ptr` is valid for use as an `IdleRequest`.
         unsafe { Owned::from_raw(NonNull::<Self>::new_unchecked(ptr.cast())) }
     }
+
+    /// Requeue this request at the block layer.
+    ///
+    /// If `kick_requeue_list` is true, this method will schedule processing of
+    /// the requeue list on a workqueue.
+    pub fn requeue(self: Owned<Self>, kick_requeue_list: bool) {
+        let ptr = self.0 .0.get();
+        core::mem::forget(self);
+
+        // SAFETY: By type invariant, the wrapped request is valid.
+        unsafe { bindings::blk_mq_requeue_request(ptr, kick_requeue_list) };
+    }
 }
 
 // SAFETY: The `release` implementation leaks the `IdleRequest`, which is a valid state for a

-- 
2.51.2



