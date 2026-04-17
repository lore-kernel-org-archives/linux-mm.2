Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5A8F8E49B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA906B008C; Thu, 16 Apr 2026 21:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1766B0093; Thu, 16 Apr 2026 21:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A7C6B0095; Thu, 16 Apr 2026 21:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0524E6B008C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:11:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFFA5BC0F8
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:34 +0000 (UTC)
X-FDA: 84666270108.26.BB5FBE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C7F47A0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=pfwEavzJ;
	spf=pass (imf25.hostedemail.com: domain of alvin.sun@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776388292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ey3+e1mAEOncTF0L3b+7cTAK4TJYwM3lJWLsWJF1E7Q=;
	b=Y8eSTJQYHCtjVKOG4QAnfc0PxNMiHCvBi0YZMGh72QiMbgK74f+5QVRGvMjdfTr+mwRSo5
	RmZgugvvF1Ow1xEgYHVPs2cuMKV/aUk2MHuIx8onVs2W95IOTpBdwWAQ8ThFyNLe3g72jV
	oo7SPb3f6jlWCIh7sfrm3V5bjx7Jp3M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=pfwEavzJ;
	spf=pass (imf25.hostedemail.com: domain of alvin.sun@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776388292; a=rsa-sha256;
	cv=none;
	b=PoUUDBJrMAmONGTNImcdQpRJCbCK4R4ivA5FDKFXFEpZ1V5nAfYsLL9pxTdCkdeVKErww6
	UUUVwc/qjIbebFtwDLWjJqqQSIMGrvSlzljFE86Kl4nsoPXs1aPDXYSwHLQxqNZxPjOIia
	qRJPPUQIr6YnIpOZjz4sXG79CKCUT1A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 501C3445B9;
	Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16CEDC2BCF4;
	Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux.dev; s=korg;
	t=1776388291; bh=HK2c+z8dRuFsYNATe7JRBa5cKQyu3FlazejUuvyOuq8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pfwEavzJ72Cb4tU1vMmW+uXzNsJX5JN95bWz+EZTvCqx3jfME/SrrCvzDrIwjwv6M
	 n20lcaa5rqsM/HLdEFldiS8HaRF3BPxh1f05XLfo7YKj2DHU0JcGPpXR5W27U2OSk+
	 7rPgCARP3SP2oaRgwaoE3AvHZ42sXCRLU0k2H2vs=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C288F8E49E;
	Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
From: Alvin Sun <alvin.sun@linux.dev>
Date: Fri, 17 Apr 2026 09:05:54 +0800
Subject: [PATCH 4/4] rust: xarray: Add Guard::find() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
In-Reply-To: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Tamir Duberstein <tamird@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776388289; l=1408;
 i=alvin.sun@linux.dev; s=20260317; h=from:subject:message-id;
 bh=HK2c+z8dRuFsYNATe7JRBa5cKQyu3FlazejUuvyOuq8=;
 b=c/lPoOZ1Arte0C/QoYrkBDlhgjCZ5b99pHUmEM6OFrj/WdCEt52K0YfvGN8Z06RSSMFQgpDdo
 JBKPQrDSNehAxdqNGVcwXaYyiVDut1xvEu8f1PV1IxWItviywlhjFt6
X-Developer-Key: i=alvin.sun@linux.dev; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for alvin.sun@linux.dev/20260317 with
 auth_id=684
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C7F47A0004
X-Stat-Signature: ubh6myio1y14h7taxjh4rmgp8dsmrb8o
X-Rspam-User: 
X-HE-Tag: 1776388292-470287
X-HE-Meta: U2FsdGVkX1/YFQNuqm5El54HY2ZzpF9quvoSi2BjN7sGZoIW4Es9cNX6mNMlwEPHLqrVqZSeCcNRjkI6v8BTxdCPaCucIScn1UhNw5+dmJnyTeDGge52/qFcpx93RY7IlftnTsG4iLtrP/32qoZuURuFcYhsa6xNHG1oM5CdawkcryfgRmejAQLyyrxxpjNyvEreJQq2fD5K2+gVTVixWKATPW1+nbjJCt0aS/zV54FbbSYbiS2rUSJJ4P8SH0fps8fB9PYvTZybNeShuOGVTDTYmIl6HQnPw6A7xjWc2/Fym+nZuZAOVvELpcjCzAtyMZ5p1vu6noWhRKYp0se3K2bCQDavpTOvE14zRzgqSFAyoZh1zbFURgUXNwK5O4ClGkzMHiSBv8L0Reb1fuS1/aVg4VaSsB8fuhfb26kcVdKZSEAh9oEwkb5Wep28k/WbKJS9EQtl4RXttsVMkZsTgTtgLpWuqH56ifSlCStGhM2TVSSUwSh326OkYjY9zi4EJTa78cohP9EOMUzWmRrbIsK0qTgJP8rbWK/MjGKwBd/VzT8SxORwtRAM43enGuDv7MaEPaZfgH27ksBpO3VYLyZ1XDGRYd2qUlpRA8Yr30YC6+JGQUr7/ofrS7/4qPaTx8EVltd/jXA0tz+JNEAaakTw/6o++bvcF3CvDD1nl8RMoAUX/aWVkaAeMjZx9xUc966+cxfuWtlkUZ0O0FNv5SVGm5iKa5V8MnaJq+26joyBRt69K7F1Y4LoASjHaPx/4oR/ae0+H/Lshth7DLQzeXDlLt+lo9rorzoeJW9BiM7NeBWoSyCuLDA7h7TSLCZIe1ONLnll4uczxoroBTciuS5QPncm1RLM/5xFlLMNdEsLq8NfceoI8C1kjveUWmSFQ+F/FAxPntvsPjcvCbCZn/I+RZrqVAZ54+E3TB5vX4oQHU5oC15vZf/wfGpnI5yVn1hAxQHyBWv4DAepBob
 A0Uze6Ei
 M6oT3hmyKDujDKK6KEcksKDtLKVo1JTuMFgubtlAagUAtLsNULeoVYO1AeFfwkstbaFdcJhjBNY9g269CqKiZPByvV17fNIH3XaqEyh2zpjYU/zxkhoPLisd4ee/x77AyXfIriaNp3ABFm60ChXIRrq8i1oQnOrAT0Ajp71Mp0c75IPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper to find the first present entry in the XArray.

Returns the index of the first present entry, or None if the array
is empty.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 rust/kernel/xarray.rs | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 235fda0e394ba..e43129d032d9d 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -217,6 +217,28 @@ pub fn remove(&mut self, index: usize) -> Option<T> {
         unsafe { T::try_from_foreign(ptr) }
     }
 
+    /// Finds the first present entry.
+    ///
+    /// Returns the index of the first present entry, or `None` if the array is empty.
+    pub fn find(&mut self) -> Option<usize> {
+        let mut index = 0usize;
+        // SAFETY: `self.xa.xa` is always valid by the type invariant, and we hold the lock.
+        let ptr = unsafe {
+            bindings::xa_find(
+                self.xa.xa.get(),
+                &mut index,
+                usize::MAX,
+                bindings::XA_PRESENT,
+            )
+        };
+
+        if ptr.is_null() {
+            None
+        } else {
+            Some(index)
+        }
+    }
+
     /// Stores an element at the given index.
     ///
     /// May drop the lock if needed to allocate memory, and then reacquire it afterwards.

-- 
2.43.0



