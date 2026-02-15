Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4CA3E63F08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544416B009F; Sun, 15 Feb 2026 18:41:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7706B00A2; Sun, 15 Feb 2026 18:41:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FD0C6B00A3; Sun, 15 Feb 2026 18:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED25E6B009F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:41:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E64EB5BB9E
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:26 +0000 (UTC)
X-FDA: 84448314972.04.A1F200B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 42BA120003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O5f/Fu5M";
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+sEwSp9CVuz3AVWLgi6NQsnAF84yBLYnvSIEsGPJjg=;
	b=ei7ayNsVU3rRL1rBgtsH2CI93ZALBONUg5TU6F+nrZcaKafJDaq3+K5/DKZXnsi1OzBzrZ
	pow8iBUbMsB1pkNC5ZXnuj7yeyJ/BqQ6/VtMOFFByrRrY81LgCbTVx6Inpb27ywIwJSHf3
	llh8xOTFnFKG2e3npiwMuDRNQbjN7MM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O5f/Fu5M";
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198885; a=rsa-sha256;
	cv=none;
	b=RTdYn04WkNxDF1zcR9CaRSnn9eom8ZBnxwYuqtpXcRjdFs4rQq1257ToPZv5Kez1l68TA0
	KJGgF0UyytO+y0/nqDXRxtaFxYZFXQ5DLkW5JrCleBUX4rXZb1/vWSDaNgBQqfn4ffSmO/
	3J/mf6KmVDxeEdH8jmx4RvNbPrW+m1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77E9340563;
	Sun, 15 Feb 2026 23:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAC5C4AF09;
	Sun, 15 Feb 2026 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198884;
	bh=t1ASQJfBzdDC92qEwscNrrmiCuGCWMUOPUsdRJYBsD8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=O5f/Fu5Mr1MpI9+DceCrppsOt8psR2zmL7tDTzmcftdQ82droIygIw3qEVSdA89T6
	 8QowxFsoEi6dOmlL43k5mzgEmmd8Td6sTcsrQSVYH2C3uq0SaFssB7lba16WPzLF9R
	 pU07XUhSftlvfzcWiMqHD34xGm8E1vly+l9DpiO9bNtB0QaYbVYu/ErUJoFJWebREv
	 yWsDQs5J5qHu/Q1WWAvW/xa6tHisRCxr4G0slgal/K5pN5nj/al/DmcUeWPAo2zizH
	 dpiKXSVu7eN1l1MulH7Im2A30QmXaTcpa/lJZ0qJ70Kmj7IiVvy2QByMbp1eGyqkKt
	 6FyckWmhmb0Sg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:34:57 +0100
Subject: [PATCH 10/79] block: rust: add `command` getter to `Request`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-10-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1169; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=t1ASQJfBzdDC92qEwscNrrmiCuGCWMUOPUsdRJYBsD8=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgkNOXP5tPUBMAf9BmZYuGDAbCtojzNtAios
 +8laK9Y39mJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYJAAKCRDhuBo+eShj
 d194D/4mIQB1EGLbNrOl+I/uS4wCtD6CzbRXmXcl5fFe92Xg2YsO6rekD3VJzEIABP7VCe7qKRP
 wyC9KwDV8OaosaLR2awz+ORVTzJXWo82qjUiMIyAjXz8esf4P9iapP4hVXk9vY34LNXQGC87V0H
 mDn2MaQcbXjd5riAooVucs9b2nJ9AFLI9Du4Mj1N23oKn8ghSYPkVz4/dibfpINwnuYqZimSlB/
 018p/1lX+xO/t1GESKTGSWUvBN+nImW651QYrVCOMXiKIQ7/I9SaMI08YLF3c92ex0FPsvRqUt7
 aHsYLVPCTduOZXdOG+MEmi45DjRUH+0NuHjRY8CtxLRWVc5AxGPVaJD1QZMfkegYDG4EgIqN1lH
 gd6HhCH64uOuuJnhY6tJpBZlVOiXP/wcUMu+Srf5DEqxl51YH5m33GeBoORPGQakjhCTge8iYlx
 WF1R5hKUTYs1gQ3NpNRFMrsBQBj0e+eu805gzj+ZUBPQUe+SZ/oxrA15hLHeOm6yngwleIe0y4F
 nl9AzTzV8Cw3cE6Ejx0m9WNZbxjxiCcKa5MaPzJchaymBQ4yvZS4fq8ylJ+YsRJPJcXoqorkiZv
 xpFAzJPcHId1f0zPP6AwbMCWXuX3APyh8UTjsuCWMsHNGWxIH9Zbqy4NvlWnTZXsFoAY4toT5JJ
 GfwScsfr1lGfJ8g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: 42BA120003
X-Rspamd-Server: rspam07
X-Stat-Signature: jy1khgdsubz9garbx51efq4n735erre4
X-HE-Tag: 1771198885-842615
X-HE-Meta: U2FsdGVkX1+IrSGIgrVRmsv0zH+GvFUqmM+cgziZYGhTGRUFQKreLhqUWdRKOYuYtDuslCRnq7lqQuY8f2k+Qt5uIx2E2XYpMU+UW7AbO7pr4mxjhmT6REG2/s6s+RylgyCPyvBFvFAa/yXnCrwBjejlsJwoRNH1mUyC5j+/nhCSSm8PJ+W36h1wxlj8OlJOA4f8GspLGte5AX3hbmA+sObrD3vshHl9iNgOFuYgddoY0JXVR125Iff0S9LBY0oqGROlzbdGpj7dY50RwMaS3RfR4oojp7e59JXrXiae22bnkvOplQHj9UL7+Dcc9jwAmd5ikKwL398QiNJIGPNKtWuZLOBwlYIwDZdSYKz6TsEamoIMG2rkyrB6ONPIYrG7iCDXsBV4s4x8TUBZ9yBiOH8XOXn/ltcz/YtQJhwtbMu/LeD6s+M7fq3VtGVlynGy46GBgqhqCPCxxVv9HuiSGlWGeVBJisSk9nlHnyjwnEcjW2pGOGvskF/YIOE8qawRhDLfbWiYcqMSZCc/zu6HaneV6oGqg/KXOMxPIjUnIO8CHvGpZb3rgm6q9ADCfTbs+frxwZ8ce+7KXJ43IuD+w3grIcTj498NRxXHNv1cJMPUxzRB6Xa2p9MuNe8sdmKJOActvUFxpsUJEGIAJ2oEzTvjKsSED5yFezjcu2gm861VCqj8tYC2YnuUPlmGFVTKTFAe5xvbxeB9EWlGrzctyU2VxM8pKg2u0fQl1GKfNuepmF/ifyCRl6y6jGSN1ekfoIHkWY6t1gUJEMEU+2zisTXVKRPo6g37b0GRXFw1sbCWq2nP7pRnk5ePlDMu1Oh5R6xCncZ34PT6LmreN89AXxSkGDG+drn2X1g+FYbQMypvu10mJkoz2Lcbf7wJ7AKK8iZ7hBHMHrdQgjT4/lUa1sOZvbtU3hZfEzR+QGSmbbOWnxtSoRqBLYHAyZmLyAvzsSLYp9PAlDb8KKEOUGs
 paqGhwi7
 IjeL0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to extract the command operation code from a request. The
command is obtained by masking the lower bits of `cmd_flags` as defined by
`REQ_OP_BITS`. This allows Rust block drivers to determine the type of
operation being requested.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index b49197a0c66d7..0dd329ae93dfc 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -78,6 +78,12 @@ pub(crate) unsafe fn aref_from_raw(ptr: *mut bindings::request) -> ARef<Self> {
         unsafe { ARef::from_raw(NonNull::new_unchecked(ptr.cast())) }
     }
 
+    /// Get the command identifier for the request
+    pub fn command(&self) -> u32 {
+        // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
+        unsafe { (*self.0.get()).cmd_flags & ((1 << bindings::REQ_OP_BITS) - 1) }
+    }
+
     /// Complete the request by scheduling `Operations::complete` for
     /// execution.
     ///

-- 
2.51.2



