Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8395ECD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA52E6B00A4; Tue,  9 Jun 2026 15:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55926B00A6; Tue,  9 Jun 2026 15:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44C56B00A7; Tue,  9 Jun 2026 15:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1FD56B00A4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 902401A0746
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:22 +0000 (UTC)
X-FDA: 84861317604.11.54F8974
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3404C0004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BjLr6wq4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KilJT6sKvydSYR5+me7VI/DGNTEVkZbaYVToN0IHPfQ=;
	b=aTL8obn3yvHZv6sGG0GpHPtRL69fSEKnYs1O+4pYRkX19Vx7CpUBsByLhREA5DYvpIKEV5
	3pSagOl1CsaU1MSHRorrOrPz/R0SmPhmhGphB5I4Ej4v3vvfg6fBmzWRxxrKvzUsWMrqG9
	2oK64POnaG6R/B1frcX25ymk80aV4Ic=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BjLr6wq4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032280;
	b=k4KxiXd/IJyKj1HX5agZ2XQwXqGbmWFf+cE49M+B8+0mGKd2VWX+UX6ZeoAwbov6emuNxP
	U/b4nnMhIHFqApbuLzj4Ag/h1SRP2yxtVoiv+/n39FDPnATT4LJq6B3yCfVzzH5xSXlk0C
	jPdTFTBoFXlyn/IE6dM/JIy12hxMETc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65911602CA;
	Tue,  9 Jun 2026 19:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C241F00893;
	Tue,  9 Jun 2026 19:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032280;
	bh=KilJT6sKvydSYR5+me7VI/DGNTEVkZbaYVToN0IHPfQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BjLr6wq4e25sVTou0OaA6fD+9JF++b1zX3fzRdWtlKGizoHcOiMZQ7eSaLZkaQ/GT
	 qlTFftploMEN10YzFDj6Edo+qC4MJjG/cS7KqxpRyAgugcKFr1bAHTYjHFmhiZxIee
	 IlxcTGJBV0ZgmVmbWTjj4jgMP2krdboUiOMkxqG9mIMYBzPrYmcyt44gapjfWXziGY
	 5tkX0g+Ps3sNKE9uTRpBnvAYCAzQEGfLHiq60I8zC0e++1WYve+FV8N0az+ouabHUO
	 /OB1c8SRM45bd5k/jAqLzJ8GddId96lhURhdpoqgOpe04dFueNadbtUcjipLX8cOP6
	 MqpMgzu99sw8g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:10 +0200
Subject: [PATCH v2 31/83] block: rust: add `Segment::truncate`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-31-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1671; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=mBVFER4nWrZs+8ynhjMfZaNZazMthVQxUgWM919F7I4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTQNzHBxSzi8DrV8H8g1Ugz2ZxPBx/cKvwuy
 5a8kGpX0RWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk0AAKCRD6UCkIqsW9
 0Hw5EACkjHqDIlzn7uZ2gAggaV5oUwQ+rp2jrz3Nma9IjCrnBK4Q9p6cn/1CrpI8nyc7uVlIwbC
 5+Vn+PielpQcAGzBTH55vXrrepSbx+zx4Kue04PX0vNq2Q2lIVlBDPvGg5FajY03X3MtMtTEV6B
 UQSEKX7OUt7j0VUA+wwaLwxw6NZJFvQbIwsfqo7qFPSUakUotBvyxwP0bdpdulzWgxhUgjd4ppx
 nQqzGSG1Pd2TfvNDBubKFRLcOpbSQAtifywnvaNPTHWb2YVEDj541UArVxVoqOCMGJnrQWqf+Xu
 W9QjQoA/HEi8cQ3JMt3JBZlaIWjLT0BagtBWUhfyhaUL62UpsnYP+5WKag7xRI5J8No+Nt2yaQp
 S1pstT1rf7lbQmqjjjX6yEo4+XAiT77Uhc0eMF29yjfUJtfPcN3xs4nwosWa0WIbKr5cSnNH3Wv
 p/9C1a0gK2oCFoYlrkiasejuWjM5YCff8+uI5R90KnFWGrkpuw73yo0ybUed5y61Y0BYpGtk1KN
 t0BHh3h2x8DTu33oax6VhJoH4DKqunh/6ax+B4o8Bqks6KRA3y+KLhZpQTlY2/SobAzBnPH1QCW
 uaaA43Wzb2Uf7FBC7GR1tdXKuKsqs0Y85bpkP5PGeEpINnbwXwpuATZuvfQWVCLzmNYgLVvXgrV
 ts+xMNrZWroS58Q==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: z93g87h7m3nurc48cfwoqh5hicxwjeza
X-Rspamd-Queue-Id: D3404C0004
X-HE-Tag: 1781032280-501535
X-HE-Meta: U2FsdGVkX197XZ0BYpryEd8pBchWcQKgQySh/XNuqEPLLPuQSMLVwq3eI/tUVc4fvKSSR//ED5iN7aIlKyyQ+Wf6mq0AecpCEBipNloKXkyXKc35Da1K5+HsZLPtk1U1ezn9Q1Dd6ZLDu/mYl6+EcAP/hzeYvj3s6oPt7mhRZbBDTOOmKoeMnt92SpxR2JAoIopK4+rFtxDSBN9Er9Ae1yW1KyckAxL61a0gYB1xv2Kbga8Mixg/VstqaJZ55uq2NJ+pZ0gLxN/whL5DGZrW2YJv6Fx50+NwhaSAHjcoZrUeK6zFa6QwSjivJ7HCYcY0XOg2649SgRD5HUS4oR5gMipvrCouMMNuTFDXkp5MYvtjEmo1jseR07hER3EBMGlh9nxUrCLCXT7PMgMhLZspriEom9ibCEMCbf7A8Uw/3PbLgbdGVC0g/4fFEB0GFfVr3Qg8H9T3bFZU+AjwUxBS+BRrqwcuZbiHcbOrxS8oI7MxK1/Z49ESDUjm9Nx6NspKvc7Xe0P1zSy3PZ6ZACh3b2ijI58xRSRFjYAbFtvr8h6Yrg7d/aTYeOBrTyyzAQVnUqSwddW2+fZ1te9SknKsuu+UVysXaYf2FaCVtrigA9NZJ8VuBGpeoN+D5fz3m0uFq8EkZhdDf8jq7KD5aHeJlKoJsF8TP59S9zKveaFeA2deUJvX3bgswaHsbATMMLhamLqYZXvoXp1GGkqyw9GAAGkDJdM2s4O9pjNNV2NYwzd9MYRbuqaiDUGlAldnQR4h0M7jgRA7xLNwEUAc3AX9wvqM3YT2Fognp61CVC63lmCdyThQ2QgL1R3BEa4LDWykiOzCN729jLWbgn/r2Ss3rXnmt4H19ya2vaWKedi48cPgKfFrUdbrGZUuLyH/1a+01XnfUQmBzv/hobXhWK1DOh0X/QVeqdp6YuFeYL1jOouwok2tJw3uNud1arWAf4BIDLm2FVQV/DFRIMN04Bb
 /jkCaVCB
 TZ1scpxZrHv/ssFHrnPJtx3+kEDciHAC8ry3oBSc0CwkFI14joKJllK2ehZ7t9ATIAktxszP1fasUDdWTW62PZfSuH/M+AAoQkNrWlqtvLxyZc4wkyQbs9kyBlsTTCD+q4r4aiuLQsf0I8ZlmTsmuPi9eh775BN6j12xqXMe9PPFzbqJhIivk4vm2tFPECZkOTPeY6ISyeob2Z4WjYZFNbqLWhvgSk2AmOtvhMjgdYagVQ80PEDsh5xQbG1DvSDpcRsJnQnjkeHYqe6CXvyehrdc74xV3lzA8Qe/bZgy2YzZO6YyfMVuDpOOrxTR3O2g5nRNd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method that limits the remaining length of a `Segment` without
moving its offset. This complements `Segment::advance`, which can skip
data at the front but cannot trim data at the back, and gives callers a
way to clip a segment to a maximum byte count before handing it to the
existing `copy_to_page` / `copy_from_page` / `zero_page` helpers, which
already bound themselves by `Segment::len()`.

This is needed by rnull's partial bad-block I/O path, which needs to
clamp per-segment work to a sector boundary computed from the bad-block
range.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/bio/vec.rs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/rust/kernel/block/bio/vec.rs b/rust/kernel/block/bio/vec.rs
index 99ab164d4038..61d83a07397f 100644
--- a/rust/kernel/block/bio/vec.rs
+++ b/rust/kernel/block/bio/vec.rs
@@ -81,6 +81,18 @@ pub fn advance(&mut self, count: u32) -> Result {
         Ok(())
     }
 
+    /// Limit the remaining length of the segment.
+    ///
+    /// Shortens the segment to at most `new_len` bytes. If `new_len` is
+    /// greater than or equal to the current remaining length, the segment is
+    /// left unchanged. The offset is not modified, so subsequent copy
+    /// operations still start from the current position.
+    pub fn truncate(&mut self, new_len: u32) {
+        if new_len < self.len() {
+            self.bio_vec.bv_len = new_len;
+        }
+    }
+
     /// Copy data of this segment into `dst_page`.
     ///
     /// Copies data from the current offset to the next page boundary. That is `PAGE_SIZE -

-- 
2.51.2



