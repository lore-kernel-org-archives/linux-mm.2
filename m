Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A627CD98C8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781AB6B0125; Tue,  9 Jun 2026 15:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732E96B0126; Tue,  9 Jun 2026 15:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FE86B0127; Tue,  9 Jun 2026 15:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 572E36B0125
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:17:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2FF612079E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:29 +0000 (UTC)
X-FDA: 84861333018.08.6E377D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2B97714000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NlrvzFZv;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4agbTirNlyUYcdjQT8pmN2Uz+Tb+GEZRsrovxY+04g=;
	b=edQRyDA4pTDFhCmw0HY3Kif6IRn1r/E3fY3GebItRYOlgn3Axar8mrwqibpXSeUfIHogKv
	2JdyWeV+czme5T/zM7hnMin/dUAP84zwsau+8Gn24QwDvLLedwfHOfHIMMp5ej2igQvfCS
	P8O2SqUiKqhLDFsK0dAbTGcUzRjP0sU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NlrvzFZv;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032648;
	b=ZoEe9QiEIdTu7Ojp7V+IXquJTWPyK56duJIDTn9U+IQM+Eqn+YZ1uzMhgeTaufveiAR7b1
	lwuFLq9QhTnah58g4Nw6BRSNwANDWSln8ObVVHpzPyXueaS6krXsRDbVdb/0PwxjPY7rz4
	sdL3JxYQh41v54Geebed03OT0a+IoVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76EC64024D;
	Tue,  9 Jun 2026 19:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF751F00898;
	Tue,  9 Jun 2026 19:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032647;
	bh=l4agbTirNlyUYcdjQT8pmN2Uz+Tb+GEZRsrovxY+04g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NlrvzFZvPGR4r0FNlUqsKm++UKOhHK9QP0yTaBU7RQVTO9eHAX6zE73w7SOEXOqzz
	 HbqiiTpXR9TGlS3R1TpzwnAtw6OLHW7j1knJpzQuF1e2fd/qEFd7Ucy//TBEc/0zG0
	 /85I1zCRbhg2xHXdMU4mUkMdbQBEOI611kkbd/C4oOPDg7eDylgpbUd/NxpHdeZ63U
	 xF4Z34AwNl4fAkpkmCVUBZLoKhABDFEbUZI+/VPNNgi1tPJErzbOhbadAj10o4G+lp
	 9PS5nNaobsnkaCbtJ/Pa8O3hsxb0Ft3qvZ3psLw2KYXw71L9zYW6exHzoYng1bQ8bS
	 rZNA+z5ZE6EZA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:53 +0200
Subject: [PATCH v2 74/83] block: rust: add `Request::queue_index`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-74-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1020; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=fop9S+9mzVcsTkO1rMOxG+AfrBnmsW7E8Z0RHs803s4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT3vhakzgq4tXf5rIzfy3B6X1NktI4mR2vyG
 W7qLn2llZGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk9wAKCRD6UCkIqsW9
 0Bg7D/4snWv9goqos2qzgRQYcA8FkUKrKYnV6R6LAk7i9bC3v34ZUm4z7VyF+eJWfWf7o9V2Er8
 TbQZy5aVqp6ptRU1JCmcHZifV+9oQ6ywjAbputtg8TgQHjUQ2c28RZzZdwJDHRFpT6qUYkeJ7lc
 5nWrAhMhkxiFs8f4jZiFnU3P63hgN3dyOWS5mrO41E13MtvQ0/Dq89IlRTRGvihZbagHHD1IKsA
 TSoIEhfng5ttW+FQLZft2CpwPoz8IjnlflIGn5JTM+adojBxi2le3/MYoso83fC/8YEMQC6f9zM
 sEeY0E03bg1r8Pc4KPyG1QHTsaQyO6/xpFZAR2hT0fZubKdABYnBt1ESu8EcWmU0XqZDbG+VGw0
 Y0Mb3xXr3s0mEZ6VnY3A8wBem47djoGLzkoiDukouoN40CfeWvBodvM5ZFb69nLL3imY+xE0b7k
 L1/cjFAzaR3sBLT0vCHzjSFo0HV8KzTzOtPlt77fSHtXRGfK92wysvVWo1ZUClsdTKXa/tAPfZv
 0v/lusk/BplPsNb9+xgGQvAwcjQ9rNu9ZE587fvULiyig1jEbu0RTZONQSjXLN6H2iinQ65N7NZ
 0MRGFoQqvNbkKm8pGOgr3vIvmgbIGYlT7iKFtWGmqA2AhYDsz1OhXxGaEgB2jfRT0rkCV7eydxd
 HtfYGWM0XD9snvQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2B97714000A
X-Stat-Signature: d48eurpa34it5pfbpmisd5izycja7my6
X-Rspam-User: 
X-HE-Tag: 1781032648-768039
X-HE-Meta: U2FsdGVkX1/UnMvH6ze4gs7yFEXESdYg3BxZIG8vnPUGOQC6rIxaWyIGaWYaGkdVA8AjOEQjXHgetalLkp7G8hdlB8lS4eI2g44K7kuS3tT3G+tY/1gY/R1L6Q4xif30YZtpOgcS03miS9Yi2zvb1gHHbGpv3j7sB933Q4e27T4Ng0bEN7nk4dWqWgCQRc8lA+HctefwqoLwPVre35Mf6b6Forxqbx9yQc+BskQoJF97grDEqk7BMwefiObYJbPYggb4AHml8sC2bMnfCb2qJVwxVYIw2amU/5PEl6RIhz1J7UoHJetcvAPUzaudmM+ueJX5n5zsUj6GRl9vb+aW1JCOqZXR2T8i+Nq/wRjSMT11jZNyOQmkj7b0OJMINUtVbPQizSgtW+5rmqql/7VYJBkbU1uEd6Tdv09/ZFHl/mSeBHYahcC/MKLBCC3irz1uPG0CoHTBH3GdhbVukWxPldpK3xxJfPkOExLOFmLf9/4XXrq66qg9zPApaCfy/XwMP5t3IXPpYB1bmGGjT/Kt0wqQDlSIs+9HNLyIukyVtXoPDa593NNx4TOBrzrRWMpdE+WoKEqwheAixRklEWTYyLBlQvqKLW+917sMG6iWS4nd9xohc7Nc9pEl4wqWcFg9DlIf8L96BFg4ltXh9i2R0iGIkHpt0xSzijc/ZZoOWttKyZ6LCssRf+QU/gREoZ/f+22wvwf/nOpGCLkouzPQ5tVNVKzYRbUnoIWM3DU9MS+rZqiYNG4t13Ej/tp/Il9s/DOQOo2wppu8MLiraKjlMW+H3YQQr/m0SFAqGrDohg9G4cqaCyY0MLlT+0jfZz0oL7aEoql4jfW5PxJ6WM2dvaQrDt/f0TKmjIv9kaS62t8VTtnin/3rMzEnsQLu3QqonX88n32PS/blfh5a4/JTAEltm8OYMuqhBG43bbhieTRmitARTqPpDoq99tUUQn6Q58iCemLkeiXZXTPXw8M
 GeReREL0
 vbHdWI/jKd+zbWybHt9Kij+CsbD+9embEp/wSzP5rFtQrjEUArmtI+P/SbyAgh2Gc4v1ldl72CZz60QH9NOTjCf+MkmvJmfeftdIINTgs2ciwoFeu4kSUzYqnLJmnMkMiyF/g2j3uYXuQY6YrbwU42hTgQWRVZo3/KpP8h+EOOsNRaHozpLYduIwdpaQR6IgfVjJrA9pRCSsEVtLmtU4Qtxb/erfkwt3OJnMqvnMdjoaROiyfOQ4DVIT3wJzDiLxIEZOaKDPMzRZmcdTjfuhtZKgxQbHBtkwZiK3j+Bx7KD67uCbA9T7/zKUscg/Zl2nSULPkkl2UsKYdRAayrtUEKEoxNVD56htX+7QT4KuWnOlKTdsXvURHMtkShqk7AsWT5XLYpFB+hlb12AU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to query a request about the index for the hardware queue
associated with the request.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 05b167dfc6c6..54b5202567f8 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -191,6 +191,13 @@ pub fn hw_data(&self) -> <T::HwData as ForeignOwnable>::Borrowed<'_> {
         unsafe { T::HwData::borrow((*hctx).driver_data) }
     }
 
+    /// Get the queue index for the hardware queue associated with this request.
+    pub fn queue_index(&self) -> u32 {
+        // SAFETY: The requests is guaranteed to be associated with a hardware
+        // context while we have access to it.
+        unsafe { (*self.hctx_raw()).queue_num }
+    }
+
     pub fn is_poll(&self) -> bool {
         let hctx = self.hctx_raw();
 

-- 
2.51.2



