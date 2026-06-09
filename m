Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2520CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228136B00F5; Tue,  9 Jun 2026 15:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7EB6B00F7; Tue,  9 Jun 2026 15:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE066B00F8; Tue,  9 Jun 2026 15:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F19496B00F5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9EBF1C281A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:12 +0000 (UTC)
X-FDA: 84861327264.03.245F5DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0ED99180008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILJ4ZGV3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64hvSmLNolq6thR/XE1WahjnyPiD4J8xEpWXph8IhxU=;
	b=oaPHjveYvj5K+n103508nvFjqMfIWqO5PjeEykcsWITUj5keTYMCShY09u3xcQb7kEXe2n
	W1w+9n/BIDuvctmCCeISEEoCYAJtU9ceaobKSOlOBqCgnOlZGiYwWK95rYcoKHVUFF32H8
	qDlLMlvYSPyCJck0gGWdYmnKdlDghvU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILJ4ZGV3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032511;
	b=xJ6ZrYbbInASERRSOp50ZyHytC0mLyJ/qbL4vBK3DLlq+O51zXBOtJHaMQYglEV6m16tCm
	H+u3KzuqMZ4Tfa/otNsDhvK0AEweEervhQRHvsxDKTbVe4Hglk20rpekiR876ngzp2pPQ7
	eN3InqxvYPMsEWQGrUDsHSiiuWvlmUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99ABC602CC;
	Tue,  9 Jun 2026 19:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4970E1F00898;
	Tue,  9 Jun 2026 19:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032510;
	bh=64hvSmLNolq6thR/XE1WahjnyPiD4J8xEpWXph8IhxU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ILJ4ZGV3IqhZKH9TQnw/S+0cy9b56XT90Qwagujd3q8x0Dr0hMVaLhsl/3XdWRHVq
	 E6koHy5xCOlv8iDzC1IwtRwNRrWU412XAyZNC8ne/hwGDhILazbZ8i3t09gJpDalis
	 wJ0JqcmxEp07yCSIsELbbLuyWnexgc30pw09eSenYfYBeYqqBKkesHqwHL/6pKdmsb
	 4Sbo+qipLgem/kIYtOsmUWP+yPGyjBPF5WBQ5LvaCYixLpsvj0//8c6ssvZYqUxK/J
	 s47/hjd4zM0UDTuo3X9bC5ZK1Bv+5XlqZ0pa4vGdSaN99upOFsPJQfyX19HJGdE77r
	 hnZc2RwqC5h6w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:42 +0200
Subject: [PATCH v2 63/83] block: rust: add `Segment::copy_to_page_limit`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-63-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2086; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=5+GUPrHafhi7e06njalxCX3qEtJzRjQWZ+jqQPaKrWg=;
 b=kA0DAAoB+lApCKrFvdAByyZiAGooZO2hozbAw63hLJZ4uFn9jmNCLHArRdSgJaa5AlVUL8B6Q
 4kCMwQAAQoAHRYhBFeK2cjZZnYmKsBqhvpQKQiqxb3QBQJqKGTtAAoJEPpQKQiqxb3Qx+cP/2/W
 ms5Tmyn1Z/jTN07+FyjyTUSksEZV2eNtSnPfn+USQ3MWIf63EoTMejbL93puBw4G9QuRs9mezAZ
 jdtRrCILq3VtPqdFtdYRIrjZzeSHKZy9u2l+9QmI8uAIkMl6TwHxswM1XjGYB09WNl3jvTpysFa
 QLVzHdICSrtPOK1TvUCJUs3zA92cxKEY84XPRVpGh1jnWleCYI7ZEtiuzlLseEIFgGhv3oSguWL
 xdEKUluwi/j+kLqo1LMR856+wcpzl8ujsESFklsm5nBW6Wd1AygX8RFUTzD+DuemwWhAhiCzeO+
 JEdcwfO3MNzTi3roXxSHuglsRaol4BJO5dV+JXx/q37ns0vuxc5dBdJ+4xh1w4IL3az5kB6Gdsi
 DABd7XeiTBCf3ZUicvObJ+p/w1jBtoZ5TE2SU5UH7c/DDnoBlF5/WIXJwkKWUvq0Mj1xQ1U1EF8
 mfH26FpRa5F4Ol3QOooJVp5hJqtthHVXlyjJqdOuWi+A/PDtqQ1LUNuEALgRDO/ec+C13MDo1ZN
 MpzCaFWHq3AA0UEJ4qtTLO8TToZ6QmTvhMgYFDelcOErKCXqcpFViSa3qcKH9aMY61sNysMxuUE
 Ay2NQVXelzeffKyV8c8Lg2+DWJhhwbCwUT/XKAJ/4at764te4+OUcIfOUzMrcxMjfiNzpP9Urm6
 +DfSb
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 0ED99180008
X-Rspam-User: 
X-Stat-Signature: 83jgas1hy4dsszo9r8szzwrwykuuh6yi
X-Rspamd-Server: rspam09
X-HE-Tag: 1781032510-984566
X-HE-Meta: U2FsdGVkX1+qrRw/+95L3OeCgKfPPSBUSOt5lfG4fB3/VxcYUVnaLeEt8oL7MWOD62Z9AzpROAakk+Ekas5SvbhhbmX03U4u4LCyFV/TMhDz5YNyAskQCCZf8ECIXne76UjLRTwfowePxuXy7srUMT1k2K5LgoFszcB2FtLLenFvnDq2LwSLM0CYDaINYHWu0zcZnhP2tj1cxjE9K0FphBmmandzPqzB/luO+mll0X94sW4xMK2UHxn8pF3ly9ZOy8JRaUn7bJ/nV9Y2NIsxPC/BM3Sz7sLOyVUuR/jbhOvVKArEwlXoIr12zNaTYueTb+4+jZT1QcKlmKEPL5VL/jVfIwvHKjs3CaYhMVpD21wQ3YHSAzzOhIXYgf2R8ecWVpOYHf1dZpBUBT5nEWHDCS83tJrA3jKonpDhGWethEJm2x/5sdI/aExqCbUsljx7KjPZberdQji8Ffld/rkBtoAV9uHkmS708JXmSWic+xbqzjkl49a/6Df+vxQXzYjXAgNfkD0eaZEcDBJuXr6KJzpLLmkBSKwkEq9r91fJ8VsIFU/In2xZEY+NaHBc1n6WHwpnxoRNURw/6n13fHajdaDoWiDzaJ8i59DmdM3+CtHhxlAEpV/LMw1w7piFiHhFMryMH4dan14epUTveb1il8t46YiHAvwDkCTaIpJPufUiA6QPZILVVFu3JmuIlLRqJlSkr8JoP2V3VjenECZrW0W9S5mxenYbv4ulc3qeQ1tNxaVUdCczAcvKvG2fVN4LmU1N6sFDOXnHiFwJr9UleM15oRL4WDKQlIHIjd8Aj13w9Ve1aWpAGb16go8DH7gmUg++2p/NkZiokOl/rGZyqb/bW2V2kfWN8NFex+Dj6S9sIGhTnLRTOXRM+H1Rwb50z+WVcsSby1n2joGwsqvM+ARqIVAimVGJuWqKnAxgEzSFhv9aNISXiXKj1iTa3BGQk3QF9c8/rhhvo2T7GFZ
 VPOUVMsz
 u9Z4xfGhOdgwOrCeG1e94mRZuG22HOBi8UJpC7LTTWJEEVgsVTdCYR/tuUDr1H2JJPfjCL5LADx4XnLir7xghPIyBWfuer4fBkeDqThuWPdLWWQbYKpWj4qQbLT+L/kyX/TIH931OasAh5PqaHd9siiDO4k8OhlXsrkeggxrSqizoZikiz6iteRF3DcWunMClDG0nx3CuZ8FRSntl4EnqVCQoWv0MtQ82zP0/bT/qz+S2/EbiZn03DkPJPIORUz6ta2kW+qESeYR74KvSIkqnfbIGAirWyFgj2wIj0O80PIjXLR8z82el10UQ2kNDFGU/b1Z8/ydQ2St6/SgXadz8faUMGTN52QPvZUn+MT/n3J4D3a8Uf8j79CKjxH7b7Dm+uLv4HR8mDBJWJrtZCtXpF5wWKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `block::mq::bio::Segment` to copy a bounded amount of bytes
to a page.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/bio/vec.rs | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/block/bio/vec.rs b/rust/kernel/block/bio/vec.rs
index 61d83a07397f..82e89a1d17c3 100644
--- a/rust/kernel/block/bio/vec.rs
+++ b/rust/kernel/block/bio/vec.rs
@@ -102,13 +102,38 @@ pub fn truncate(&mut self, new_len: u32) {
     /// Returns the number of bytes copied.
     #[inline(always)]
     pub fn copy_to_page(&mut self, dst_page: Pin<&mut SafePage>, dst_offset: usize) -> usize {
+        self.copy_to_page_limit(dst_page, dst_offset, 0)
+    }
+
+    /// Copy data of this segment into `dst_page`.
+    ///
+    /// Copies at most `limit` bytes of data from the current offset to the next page boundary. That
+    /// is `PAGE_SIZE - (self.offeset() % PAGE_SIZE)` bytes of data. Data is placed at offset
+    /// `self.offset()` in the target page. This call will advance offset and reduce length of
+    /// `self`.
+    ///
+    /// If `limit` is zero it is ignored.
+    ///
+    /// Returns the number of bytes copied.
+    #[inline(always)]
+    pub fn copy_to_page_limit(
+        &mut self,
+        dst_page: Pin<&mut SafePage>,
+        dst_offset: usize,
+        limit: usize,
+    ) -> usize {
         // SAFETY: We are not moving out of `dst_page`.
         let dst_page = unsafe { Pin::into_inner_unchecked(dst_page) };
         let src_offset = self.offset() % PAGE_SIZE;
         debug_assert!(dst_offset <= PAGE_SIZE);
-        let length = (PAGE_SIZE - src_offset)
+        let mut length = (PAGE_SIZE - src_offset)
             .min(self.len() as usize)
             .min(PAGE_SIZE - dst_offset);
+
+        if limit > 0 {
+            length = length.min(limit);
+        }
+
         let page_idx = self.offset() / PAGE_SIZE;
 
         // SAFETY: self.bio_vec is valid and thus bv_page must be a valid

-- 
2.51.2



