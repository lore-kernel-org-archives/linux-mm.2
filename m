Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A73CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691D56B0096; Tue,  9 Jun 2026 15:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6693B6B00CE; Tue,  9 Jun 2026 15:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F946B00CF; Tue,  9 Jun 2026 15:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 492216B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10D741C3013
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:24 +0000 (UTC)
X-FDA: 84861322728.20.71AB636
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 477AD40005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ID+9rl9i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9ybO/t8zOvRCr2bRBHoQTxr/dQJgA17JKTcxpSIg3s=;
	b=1/eajiA7k5dlDUWUqXQ9nJaaBZeUjzAa2Oa12IJ3hYQ1mDxRDha7geWzSoCHrkmm7jDZ/c
	1nu8UobJorXsnez5LZJFXD7jkJeuvbXBfHutpt8iihh1iMYppu1UdyJrrvlTlo5OB5+EbV
	YaRip2hAkdgZ9VScR9emZr9PhEMNDOM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ID+9rl9i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032402;
	b=rQxvi8dlbzmhp3vrg1F39TsVTpAQDJrTwc+sbhno5ikg0xUc8cAKjZ3kpfBgtc82JRY2Az
	S1U3WbG/h5M1DS5ioPfhob43uwGoB0TxBni5BPEwuT1dLLgREhfarQ0RTP5LBEsQxpSSPw
	+/BCchpGCU2zLu9v4N3gTJldxXF/ZrI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD7BA602CE;
	Tue,  9 Jun 2026 19:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9CB1F00893;
	Tue,  9 Jun 2026 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032401;
	bh=/9ybO/t8zOvRCr2bRBHoQTxr/dQJgA17JKTcxpSIg3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ID+9rl9i5FcVp4DSVY6a+jf6ixiMKI5GWzj4dZM8z3TyyuSTQ/lmM2T1i5l9+u98b
	 GlgxxBGXBxmGMysQbxzci7NbKQL0jEI9AzKOOD4egRna6tx7JQ7Dg1gpktL1N82g1v
	 k5SSzdNm2rD2uR8jVLQ+4Ey/lpiEzn9Zt7QsX4oi7+W63hc6KlHTUHIUc7mhXbqJYb
	 6wiwyUcjUMaFU+kjtxsbP7MjqRxX5b+UvHGP8qT870Ix6wvfZTxIt3vEV3TYTBKjEJ
	 5/ANL1p0rITS6eTWvkUkcZWrDZfLuWRR2DdS6ydQYMaquJyIxUn7cI3B3yKaNJz36g
	 0BkwYrWU9CVXA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:07 +0200
Subject: [PATCH v2 28/83] block: rust: mq: add Request::end() method for
 custom status codes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-28-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1413; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=cO3QVWHBp3bOOCRfL0F0a19BcOtYRij0a3oTZkjsymw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTOwOJ+Mxk74baYbuWET2T8HjDFCqOB+l0b0
 r0Fytyjv8eJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkzgAKCRD6UCkIqsW9
 0Jx3EACqq6sM1Fp2PN6SLigvCgaPbaiBkyHfgHxbnJcEjrYb2k+0u13lhvpIorRTR+3R62TV+WX
 /vBPhKnYOd6xObFSdUh1k5B0wEcyk2Zrp5yfnkOR1caJbTWxLdaks4KSPxWS9tbRdEorKs8J0me
 NowWypzsEXQ7s0MbXagvt7Xvm4cEXmSMeIbwKIesyDuEfpMM5ukqYjbuOX3gScAAB0SSKlerGRw
 OFKJdRvAZJ98xGMK4mWh917bVXcXM7vzqReCJ3sv+TBLHBGadx9bEEx/FSU4AtIUzWivyEpsLYH
 Uh9ntbu39dSC6fY9WX0vrIbO1EmpG3VeYS3X39MqsXBpNy2oyzdulzmwtd6goSEK2lvCwJXLW/M
 1CC5h/qmsIirn4D7Wa0HIXu7TUD6TR8/kULT0mBlHRtV93Wz5B2HmUU2PZ6FehGubZouGWl42E7
 MQO2zsb2s6YR4v0sBDtLrR38Bjufs4UHrAIxEkP/tK6hbFFfpe476bilYL0bFPBcz40Zx49rPBY
 xUioWLibTAF6J7imjQ52yI7AAOOM+M9sRW4nDooWS7kUvDSrQRsAnN0OeAaCo9gvh66otumNJqW
 6Pq5obt3DY/mWq0ctpr3BiEuz7ofHbpQ2HpsmQO5s0KRwM6AjJ2BmeQ7SrJaTw1m67uO+55Idly
 3tXDmex+9KNr7ew==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qygbkpb7bbyxgbsp19j6ibuthdn4nzxz
X-Rspamd-Queue-Id: 477AD40005
X-HE-Tag: 1781032402-715510
X-HE-Meta: U2FsdGVkX1+5CyI4orSOiNXwqwc2vcrx/MUXaJyPiHe6ZTc5EczRUVeZ9D38654+SN+4vd9t6vmlTvFRNmgFR/Zoq8sEscBQx7JoDNRLPNNQNFJQJSI6kxZ9KVFE76alUDkSjCI5St0PORAlI+hdRGQa6eW4kATe5e7/CBweYrimFqgjb8Zbkaow4CM8SN/Wls82RqcIvZc+GagHcYy37W61/zGKoDnW/RtpG4QvJ4P7CTwKWYw6EdO9lwSqtxsFajXCKtx6PF0DSizhrU/UoVOFkF/s/W3fUAWuPsIi3YD8uVwVr6hIGYVvFy1LtmvgIFyI5KdDDNeGvyAP87Kpbaw5LXvetngp0qH+opSIPoxPQWMzg1Hxy+14qFmF7dgBk0VLxx4dYoef8CTSFkqVuHjJsgf/Rd1Ua56+RoERl4BHHOcgR8Noz6YvfBwnLg42oUbIJqJKpVtyFcfsYi+8jexkEsBqw9ytrhPV/J2EkBp+aElV5WlO9/a59M+S4bJ6e8y1u/bxKYp48x6NTfN3B4O7TMNVDR2J5fZbsrX77zQU21ZwYTDc2emds8RbOwmXlzPsnm86axg9uAYriJv2SbYrtuRs8Zt9nnQTAr6PplG2M4Rt/ALJm5D0g8+9Rl5ND/qojWE274h4XKkn5GDG4AmTNlac8M8XeqbKe65Ox2OundlGEjyKUSKfVkdQwb9djn2e8hI9rQIZIhl+5cZgq+pkdQ1p5UzfibGPDoZ2SUV6xMLVTvEdrwGIz6Gs0eImyyiWEIuE6SLNdo3JxrzJYvfMm0Jlsjb/RnafotvMwgVvVMRuEYyCO8/N+H+8u2xlHSynpJR0SbfSPzDwBWKdrYQFlTvvWErLhG5cIj2PyH0eH/YFwO2LKebDzQ55se/E/DRaBjHwraySHPsjU/7CQk5hzhPgZPwciDsbkriuFfnuw0i2dSEmJVdxkUg26C1pQ+QqvdItt0N0vxvjQ+R
 npVQE2UR
 TZvtQ2rhhA42QmOfAF0ijAUr++24j9VQ/O3kB6BTUM6J0T6+4VMVRF7yIbxByhi90TtrEkxMlm/jM5OX+nu325P/BdLBMKemqqywz1V1HzoAG3uz4jxs4WIQ9ZXV48HGejP9jkKesDDpSLJMy+3ERD79go6Llil+fVj4Rul08pLCxJR9UnlPv6BxoqE2VN/t70BsYdtzUKwMcrin3XEQ5+FpHEnSuPPDKdnnOc4yi1jV3kVy9O1++GViTl/OPygmu/i66bBVdiCAqjbQWap29VlUY4gYnG77Zu2XTxS/6GsAfBfZrSzzH+ZqMgSRR8h0Ax4sEMF8MPBzG61StdZfAdqZvHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add end() method to Request that accepts a custom status code parameter,
refactoring end_ok() to use it with BLK_STS_OK.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 9e176f015ab8..c06907dfe5b5 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -336,13 +336,18 @@ pub(crate) unsafe fn start_unchecked(&mut self) {
 
     /// Notify the block layer that the request has been completed without errors.
     pub fn end_ok(self) {
+        self.end(bindings::BLK_STS_OK)
+    }
+
+    /// Notify the block layer that the request has been completed.
+    pub fn end(self, status: u8) {
         let request_ptr = self.0.get().cast();
         core::mem::forget(self);
         // SAFETY: By type invariant, `this.0` was a valid `struct request`. The
         // existence of `self` guarantees that there are no `ARef`s pointing to
         // this request. Therefore it is safe to hand it back to the block
         // layer.
-        unsafe { bindings::blk_mq_end_request(request_ptr, bindings::BLK_STS_OK) };
+        unsafe { bindings::blk_mq_end_request(request_ptr, status) };
     }
 }
 

-- 
2.51.2



