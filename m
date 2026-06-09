Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EF9CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C606B0112; Tue,  9 Jun 2026 15:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424516B0114; Tue,  9 Jun 2026 15:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3628B6B0115; Tue,  9 Jun 2026 15:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 266A46B0112
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:16:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7B4F1C2655
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:16:35 +0000 (UTC)
X-FDA: 84861330750.01.3403F1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D3034000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:16:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eA1jDN6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ceBxrKoS+wJKiaFN4cLOiMODjlL/11h7U+S96uTWBDA=;
	b=3/n0fwo3kI/wKFe2kVhet7GHO4qDFpCrkPS2B1oNcpKJH1j20gqwzMlD43yBshCF66R/k9
	Y0Q1p1PkvBeFKap2nTY3uEF/0sEZFOft2QjGrf4/rCQn42IuV9kIPgnaEqmvAGaAntwSc8
	/JvYCRvGkmNoWE+9unM1IekOvbJjCms=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eA1jDN6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032594;
	b=tL2hnKNzspme6N+Nr/9fAYcvhvP/MG7KpJCb/S149STMA8oyzHt562Lms3qOsnAuG8nC3V
	lfgJwdD+TR3vgqBvoFTUxCgSW/kQ03m8VDHdTKqwwiJ57tSY3qBPAeSt6jZkEtsCAxXgAz
	fHaA7Aksi0nDK+OCeMJ/okvvsHDsaqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56F3E4030B;
	Tue,  9 Jun 2026 19:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12CC1F00898;
	Tue,  9 Jun 2026 19:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032593;
	bh=ceBxrKoS+wJKiaFN4cLOiMODjlL/11h7U+S96uTWBDA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eA1jDN6YyELOCOa8X5oEIDSxxoh5dC0rltB56ExFbZ7xhWcDACGDg+vg4eMfLW1ET
	 NWoBCbja/8RFTQF+QMnfmLVWDfx3MldlTK4JaZEbBX5aeM10MzN5AYbRpvSC1NCveN
	 DViSi/M/y3DpyqKYQf7Kn4PprdZIDbKCsCfZdufaul72qH6nYaIQAMzNQeohzPmVFE
	 /H2PKBIHT6sci1oEEKP5vYHfAxKY8VmVAqBYVYmc3DNRDkYGXIaxAL51qBa+I9O/2y
	 0+MUdzBiLK/kiZqXF994Qoz+611BRXTEZmZeFxy/cKKQheDoZTvuD4cmaLNfkZNwVH
	 SK72mVDE7jsjg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:28 +0200
Subject: [PATCH v2 49/83] block: rust: add a method to set the target
 sector of a request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-49-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=998; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=3a7iopDDpVfSb79+JJXmsLPYQF2HcbnYwDnDegNwY+w=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTg+ZmtVXy+AJz3uWxsiQGOSHwamJdP+GKsj
 3jamG5JdFyJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk4AAKCRD6UCkIqsW9
 0OdoD/9PtqqOjDx+7cpfrfEDQvEryz7mcRZz+rSjYP/0BQE+XiVpvXAUCDvPnbakbh4lpNSp0VY
 5TOPyaxt7f0nx6Y5KkuI9jpjdRMzDp7V2DUB71Gx3N7A1CoNfPojHm7qXu82Jgu8LkUGRkYf+vS
 eutgaL12rgKVIr+eD4tH7q/gqnKRhltLWxX+xpQruEQU0VTjEg4EUwMxxBfXp1bKMJr+k2khdsC
 0gMw2N1TN2bxlIwlrhhfg4ev14b+4VFLIqcx2MjGd46RopjOKwEWCnOmbcdH3E3XSWKtaFk009z
 AxH7CgutGjDiXF6MWMNqau2JgWEPSvjh8UHDHhrfy+Ut6KXVbl3nGrO9cBTkR00GX1UzUqHhqz9
 yNTKz58qbnFNbQzdyJp4wxhOu0Kx2g8IW07gVOwMDj30VzUUAYHs9cw/g4TpxX+HElDNqS/wHn/
 APr0iZ2wWuFoGmaC6+q9vEHvU7fuIrGzrzWa/fr6jd4RsnHQxbfoQw4CLFFGqkHyI7ZZCS89ak9
 9mdwJ4B+6sfUwCexGx9msOrWewmkVUvqyol8OvrpYevPG0rvmXCkMZ+2fzZK6zw9QeVDzBq0c/i
 5qKwdLNPIQRC+5Dpy0/hyuG5YHG8PAZLYEZ8vjXYa06A0woFUj+FAVOnL7aoMyVIa0GXk0BH60l
 HEgqudcUfq/MFbQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 489nr68snr6txwf7uux1ezyeh9jup7jk
X-Rspamd-Queue-Id: 0D3034000B
X-HE-Tag: 1781032593-225793
X-HE-Meta: U2FsdGVkX19SDbMQ0gv3i4EGM/E/KdGy8H3/A+HpJKq6DPzDgSaQC0IXxBRGivmhGsX09ey68ZNsd1DDj+dke7SpfF94FjyYBQixi2B0frExfXsI8/fBdUXyUbO8fu0ARJYdz4imhQild3/SNspQ0K8QkIvzXr94E5Rl8dJlJF2H57pp2xjYVH0dXC/caeWtGh1hKBe0gIrJnUf0Pejl2nfp2RbA8Stk8+mImMhB8GcqfQPlWtsFn6xLa8rZqXH2/axZs/abmkg8RR/TIpyb2WRVkexK3Qcx1bSBI4M6N9JSDzlaZSuBFuVIZCT2NuicKkGhl9WeJ3pjSTvf1qaQAHb4WQWx/2kYF92y6zVA67IYLpU/sJ8nESQiWGvtfhnBqPJbcrfkXB7MI4G1ZUgWTBRTZK3cFPd0mvHkJlwaXKCF7gTveOfcrWMiVUSDmwNdTZn6k75kMzm2UBW7sTrddlIirDJUk3KeKmVGBt/fxSS2IVRq5ZHsNotSj/x8KN+AyBJwELK7OR86gXpo1B4cwczLsUoMLfs3xc9fBlK8uxfbOwy8shAhXtnCZRHo0fDwt9QRbD2RchEGDtLiyMGN6NO6X8qaJTlYiaWI9oGkxOAB8xbtbTf8EYuHttkBMy9X7HCMt8bBvr5yQeceyggxnUvAcXROJ6LEfCtj/EZnDNjrQSbgYl1HJUd6weGvxGy6sz4t91CJcH9UGReiXwLAohfeNIwK+2/gMVo7aiL/yrSnGP78GvLXEUcbekuPwerU+vPB9NsZCvUI+6tSAbb314tpTfD0KyXomIJ2VAoD9ycBbaMMWC1RNDulHu06P4Rpgh/3SAeEuzY02y3Fr0EAsYdHRWSATM0609okhsrMVrv8uUaeVQm8d2keaT0vipTZcPOEyc+xwlKl/Nzzp6Lr8dVfl9CGBwK03Dwn0yJQapCeI3LGZQnK3rxbOyodqOdTuYKht+cyqdMGZFiqMuE
 uNthy22+
 C2C4j8LNM69uMz+al6oMwsGcVfZJ9Ot6NskAvfOD6ANAb5Tu3pv7CzvfDh/s0UhEcap4dttHtNYdOYA6tweV94AT9bjqI5PHfGi9yi4UQcihMqJfeuoAMwHWtnJ30fqVIBsM5pViuL9kYCIULAgjI3vViIbxDeygKsYkIoNuJVXR2uffyZ7twIiZ8pyaUWjw8mhZL2AMVLwHiTH/lJVq2py8FYaocXc2QBzYW2+UJuv7e6l2cZqxq7/czD0h/fc/9Ch6b/H/m4MefBRyrtbtWR/zA5gQKIiWANycbgLCWWFH9EchT1UiP0Kl42CUnz4rQEvKwzlWihq+N8i7DNVhScTrw6LrwsNYQAbMy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a `block::mq::Request::set_sector` to allow setting the target sector
of a request.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 63e248970ab1..66ef2493c448 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -336,6 +336,13 @@ pub(crate) fn wrapper_ref(&self) -> &RequestDataWrapper<T> {
     pub fn data_ref(&self) -> &T::RequestData {
         &self.wrapper_ref().data
     }
+
+    /// Set the target sector for the request.
+    #[inline(always)]
+    pub fn set_sector(self: Pin<&mut Self>, sector: u64) {
+        // SAFETY: By type invariant of `Self`, `self.0` is valid and live.
+        unsafe { (*self.0 .0.get()).__sector = sector }
+    }
 }
 
 /// A wrapper around data stored in the private area of the C [`struct request`].

-- 
2.51.2



