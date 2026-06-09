Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F2A7CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756F96B00E7; Tue,  9 Jun 2026 15:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E486B00E9; Tue,  9 Jun 2026 15:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644C36B00EA; Tue,  9 Jun 2026 15:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 523D66B00E7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:14:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3063D164FFF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:34 +0000 (UTC)
X-FDA: 84861325668.27.2EF1D68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5991740007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dUOTO/5d";
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032472;
	b=8JrW697cx/1s6Y5qqnbg/4SRDPHnR5r8gmze+SqCJmMj3ny1qzyvNWvPnEwBcJnV3ZWH01
	AiHmcKhVHHSfKtBsTHvi9HM+os5pk3twyIUbA5gij3ePcjv0D90QSpLNhy0UHF1KcPE7HP
	VCWXWnGr8C5LSi2mLDLootWLJZg4mdk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dUOTO/5d";
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCdEZ68IJNlYPAWBV8MghxbvXE9NFFUFrCiuA8Oc9Y8=;
	b=4NrGs/06gsh2iJZARvOMdK5kZaLSgDqoyiKCW9s/XJD3TxfhpVJGM20aMPY7kXyyMAbWl+
	is1FNB5YSzxpfaS65n98uK3/sckrq6ArWZdGq0CGh+Ww7Nk+jDEhJQsHMwZgQEnu1a+zDH
	Zj8IPbceBJFnOJO1dO4pIyCEkrXhgxQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A398A409C4;
	Tue,  9 Jun 2026 19:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861FB1F00893;
	Tue,  9 Jun 2026 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032471;
	bh=yCdEZ68IJNlYPAWBV8MghxbvXE9NFFUFrCiuA8Oc9Y8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dUOTO/5dgtxbFMdbxqoipkYQeeWf8MyOeQdKWhPUr0eI7maU7Fi4OjvUNtNGPrfzA
	 VJyzqcM3ZAuTq+okb8Jf5Xqk4RghniTH+a5ursvS/slGyK4fY8WvJoM08LQ59mCwz6
	 cAJHfKOn1AixaoCzxEyYeVSg+ijkUwfDC6DkCyzmV/Q+Cu1yIVR6wKMuuBaTtXNUwB
	 PxqBv3/7ZLl16DL9aeX2HIKxNjPAt+s0UZFlWv4nn1tfj+FxIe6k/Vi3JcJEw6uDbG
	 0TW1ekT50kNXN4mxwC08P6YQs7JrrayFslQnpWJO2f1xZ4JqJ905syUyQHDq01ZYNK
	 L+ktlL75QCAYQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:51 +0200
Subject: [PATCH v2 72/83] block: rust: add a debug assert for refcounts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-72-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1313; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=dEPmlUxwcO+Z1aUp8x6Cur6OyCq6SpGxV6GyA9LbAqo=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT1t5B7OMznwXk8t33ak/UoKnSo82sNtKPE4
 l1ctAFhDBGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk9QAKCRD6UCkIqsW9
 0J9CD/9f9tEnTGtTO3lz4bba9E7Rk81Gu6FqZ3nTV+ku9eLPqem/tv5hDKXD6QLR6I0OuSqvaBY
 ty/gCLetdWBvzLW0dGdDvRlbMPNShJUycx24awKp0NF3w7c8KxZ54aVMelLfnVL1N+ZhL2T3P4G
 r5cYQPdu2/asYUvO2BM8cqe0hcWn4tn+0H5Q8iSsEW4gZkZTjbuvkaN2I0a5mIbdy47Qmmjbur5
 Q29HxY16fLW2NAPN6e1slr4/LWaUkhfggan73RC0kA8eGcSG4Y+4no49aqK8SYaPAhgk6ntbyY+
 MJZbIlepcJA07j8Lsi1JlKVtmiw/gmOMv8S+kZrQIfbSptnBHBiinuDt5v7wIXBKsOMpvdi48Op
 m3WvEEO6D+ClOMYhT+sO7OJwwS+9LBBMncaUmKOhCtyOFOlc/jxK7toJMQlP5sOJAmo9nhIUVDX
 By70DQOGP/Iz5xDcZEgkFrPz0hapvzSlXJGfg0+TIqTAPwreJV7P8Dvc8sNg3+nAi5xJQrAVL1u
 r3wpA+ug/ZZNExmQASxAruvhPt+nT/ZyVJMzabVkjYq62zCIK7VCBuqdIH/1zo/mchWvy3K/uWM
 q4kJCjGW2z9SJICFwfA9UUtG8vkTCI/qPTEoVjpqf3e8p+xnKXfAQmWd+wkOxsisgyobBEYRKsL
 vIUoFDMOIrrvLHw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 5991740007
X-Stat-Signature: 57u1599tcxfjq5eo4gcpjabdu58gh3ia
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781032472-220806
X-HE-Meta: U2FsdGVkX18s+K9O1FXNnIC8Jir98gjByt/Hr/sZxZcxRUaKVU27RsBxfgpUoji8x8B2sdnP/v59lkhS9pBTbWIMylT/AHGTDIP74/sHvRdYpVouAmlEVC+WgHROhiD+ZZKpaqd+xTHfRv/DRI4ctVJ6sg3GqSteNzRolqsIGFQpTYSwyyIuUVkClOkKXxZk6eqaMmD2wKhXILJMTqczolY78s5aQxbUlp/Wrj5I8UFJpybDubnxpSHM+WdDb9/vsWUXAOGIdfIc1etpIFifD/9B6WLothSHBTmLrHOGFsp90XzwVHCPGsyHtenXiLmtKLqFZFxYSvM/ZbhOKQMyh/Xj2hPtz19pPmxGc/yA2QDxCBm7cDYzptMVsPfmacxa6EFbEJYz8ih0fWosgy/D+pbEXhbXhHDB1cpIDZ3mAabRBV3JTWRqAtjGJpoiUQWu5ND7hCYenNb5BGmHBvM/49lR3Xcue5JgQ1ExdyDMyGQQzuuw2bmdNCgQAdoTKuLBfSMZ2A32Iv9bDthfK0Bi8hvJnyicBFT7l3D6KtEPYJ8n18+8xsblWxcZTmTAx77JNloRaa2kPdzWG/+YcnF22XKyh3w849pojLgk5hN+oqcW3teZ+YN3iO2PItA8nS1HtRF+lUV5IoyN/m6s9dZvxv99Fb95vbNmEYwvTT638CVJURrTTqBvHBVYfdDFKCBFkU5KcXA0mDV67Pc2Dfv/YLuGRv6aqu1bxlEABUTQoRerj9KxC7R/iYbOlmSnUyxEJh7OUjs7prSs2lE508f5+Z5rZS+s2KfRXnbSD+G4t0BaaBLsxotZE01YdewkbRDjA5HewtiwPIbxLyxLM1As5rn61ixWYBr2V7RhMGgBII7AhEoK4G4bBrL2tUO5f5eum6wD3QbEyP4Byt53xEIZNUHfmcEpsiQbwUpIfpHNtqFXzoSLxr3fhoGls2CxjlLh1A6L7rsG7y/DZNmUtGh
 QsQB6p6P
 waJ3L1vBbrJTDyYG2oPDihS4ukdspU9AzvvmmKKlWhgx0fSFK+yE/8N9FvbhSh1sitmUGJCVQ9J1SwoDiycTdTkCp9TnD6cxq/hU7ZmfSL+4K40AHw0fiUoA8wnya4pG183pYv5jN4V+WrUjH5Cq3qhGXgCkVqKmn/Unfou6Y0fFQ1WPYlxtwqSE5rlbCNijeiJWWtIyxuujFw8DQ1uzloP1PpAT6knBdDAceg1ntNluK1wLkISL3oBm/9jJlYUQeHOtx5Ak5OTpbKa72dZ50mJOr0F+1UI/HtM5aUB6plg97WFlGGwT76yNq7BoB2pXbOI3Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a debug assertion in `ARef<Request>::dismiss` to verify that the
request refcount is at least two when an `ARef<Request>` exists. This
helps catch reference counting bugs during development.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 9c451583e75d..05b167dfc6c6 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -619,9 +619,20 @@ impl<T> RequestTimerHandle<T>
     pub fn dismiss(mut self) {
         let inner = core::ptr::from_mut(&mut self.inner);
 
+        debug_assert!(
+            self.inner
+                .wrapper_ref()
+                .refcount()
+                .as_atomic()
+                .load(ordering::Relaxed)
+                >= 2,
+            "Request refcount must be at least two when an ARef<Request> exist"
+        );
+
         // SAFETY: `inner` is valid for reads and writes, is properly aligned and nonnull. We have
         // exclusive access to `inner` and we do not access `inner` after this call.
         unsafe { core::ptr::drop_in_place(inner) };
+
         core::mem::forget(self);
     }
 }

-- 
2.51.2



