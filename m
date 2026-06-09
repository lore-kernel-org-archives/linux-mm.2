Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20624CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88AFF6B00AE; Tue,  9 Jun 2026 15:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C826B00B0; Tue,  9 Jun 2026 15:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751866B00B1; Tue,  9 Jun 2026 15:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 660F46B00AE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 352191A0762
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:50 +0000 (UTC)
X-FDA: 84861318780.24.56F6D2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 68ED040012
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FyL0vqob;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4Z8AHRxPgKpZNYlJlm3R0WTIJzVY9sjt95caEWA3FU=;
	b=gOGNEDcnte8LUBgUZ6FiJnWsRCCuQM4dkU3KFzhT6attNoFWOuVDiI97W0MvqiC3XKYht7
	bymZCNVjpsib7yy8+0C/7o6G0G6qdoci1ftawkJ25LNpeyR1A/+EJuioBvPNkNcpnwg3LQ
	AEBCPidmH85qBwAxAQX51+s2MUDmwa8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FyL0vqob;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032308;
	b=p5fXWygxBni0fsCROgsysc5AK5RqcBGj7sGrL0l3L9n8j1q31A54pXzFzBhVWurvrHDmdA
	ffKhk8Vb3GSkDmcHenz09TQXoioNQM5c153q6XrryyZaC9g/kqz65lvRLrn+DDuKDzZW4F
	q/PiSiTYVnTTp7U7hIr+BV/nrgf38ZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B743F418B5;
	Tue,  9 Jun 2026 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BAF1F00898;
	Tue,  9 Jun 2026 19:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032307;
	bh=v4Z8AHRxPgKpZNYlJlm3R0WTIJzVY9sjt95caEWA3FU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FyL0vqobNgq2bJN3QVgiuWZUEWwnm69ZsAY5sgnbeMg4yqz+QOfCMS+26Svt+DOpq
	 Cz3uYdyQ8aG1yRMMpq6b/gMhMLkX9LIgeIXYkv9s2y0WxY5dPPKTDvbldzIKegimJ0
	 9aVRSnJM3R2DAZUsUXxX8o+y7dZ47IEIVzbiDSB0GIcIn7THLwe+LVLojJJg3BqONc
	 BhShP9FKlzUrT+jbgTYNIlWeGZafiIRtdR+RuJn3JCP1iw/9kqMFnLxOuxOR+55ipu
	 wfHxFLfyiDEizPOJqe/qTl3/uMDVaEkjzlSSa8Ijzf9PLHvVHCtJassHUiUktCISQY
	 KBMl9pVHvvpGA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:41 +0200
Subject: [PATCH v2 02/83] rust: block: rename `SECTOR_MASK` to
 `PAGE_SECTOR_MASK`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-2-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1073; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=7twqnJezwG7YFrJ5o1U16sXUnbxUjCBfg374lo5njEE=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS2jkBlMXprmSKrEyFaF9EB3OxN7q7deJAwW
 z8X8xGygpOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihktgAKCRD6UCkIqsW9
 0KohEAC0G5926iVZdDlAI/QAadxwjGDcLBe6MxfhB04nVnEWPurh4URtNIDfql0VvjgnK5GoOGI
 vUvYMWMait7VM/0VSbi5NUNtEktgdyfc01g9BNEEmEjc8fXmQKhaD88Gy/qmNvpga+KEu53mQQ8
 AnAGw3F+t55amoJeOaRirIwlRzmj6VY42w+7Msrcs1/AEWaRsOnA9UcO2SzlgswDxWRFdN2LGUq
 N675ReEzy0SX3LF5dTJEdOqdkT4mNbWuSS9X1JhjxwDjVN825N8NL75u2K2yZxETb8d+qs7qAIF
 CkycmdpYuK8Lpbx0cnoryLdKVVGWfVhRvxBXHJLJWTUIf7NAeKkBxTaOABSkoqwDJAyY0S8iTaz
 hShmSJlT5PlhDfp1CJSA2rZyHgE6Ij2n6EhewL22FU91gvQp+PZauBRRg0xXX+X3ZQ86WQRUCc8
 GcDnCpI2BP0fdkLsXuXFO5Qp+yfDmiGTPvh3IKul0AB9EUEOMOfXq/4hf6E8MBacORz2XNjCsl+
 wZj1sd7CA4P2Su0LqkYz0/8f5E7LYbxXLKfSyp2fGuGZGXzZZTGVd67X8iQVs9SknplyNNkj+iQ
 Tngch73oPcV4Varpq9ZaCgtSYfO1NX7Os7BBsOm+s3/JoCT7WKdATreu537hhNSwTcQv43zxAJw
 8nxoutHdmOPcWEA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 68ED040012
X-Stat-Signature: r7ucexi7sb9b1p7scz8ww4dqw7k9iqjy
X-Rspam-User: 
X-HE-Tag: 1781032308-583771
X-HE-Meta: U2FsdGVkX18kuR0AqcGA7j8j1N5gUKWJ2+7x3xoaXF1O7JfjkBvQyeQd9u0pdW0zRLVzdiamB5Ra42VLPiSQ/yCoPcr3fYHwk9tCy9maZB31A+GTlRS4N3ykxswU64Ec75kdnN68GmruS9wXtI7Vxt6C663nUL60hWpMvPvdMN4zL+qONNqCFUlcblUoG6qxCCtZgTak+Gzly7X69fV2Sr4oduxEmThS7l7dapQ3WBRrZSTKa+9eJsTTfn2bxWFfu/kxjDIhQY4CQ3WeoSmZY9Hf/57cBaKiUyVD/r338Hb0bq9fcWj9d1+3kKRz5ahOx7kcl1z6rG1PHv6hyfvRqqwVyrfo6RO/9V+K4MejQ6WvZWgezucGgeHxpnQaKjPrjWl/A0k/Ri5wKCWzHVB6i6qCWlOxGG8PxDBP7DPob5x/o3RfN39n3zR7SiXk/IMps9plomjIzfieHMmR+5MxUhoAFGfeoHVkXEiudd5qasZHg49ftESYNHRbvBiSwsTFy6zduO/DCs7EpF4qMMIiAdPFZlr/9ZXJJO7bOo+ftsE99JEKUZmUlfCir043HIHuohcVQR1J5jFWDkWWKFrGhwGbEOgdNyJhjN5uy0NzobfWBUX3gL5wK+PZNyJU//2Sd7JaYOUwtOP+X3p7k6wh2jX8ZuUMk/w0bshby3Vf2ZLihD+mwKwyYBYmrjREUavQRXSphKPa++tFRgQPHSG1/Ka8JHl3+IOmGWFvt/xaDvBC4DYuZ/RqrX9+PcL7cl3F7PTZ/tckyZewn8Co+s56y0CE42ij2MW3G6mgRGnGNVi0VvO0jd7tNanaN1xTDeyGO2/m9zUKoOQOyPRVlmwW008/c+BvihNv/wvsdPh+4Gdnq9Um8xPgGyLeq0Eu+cNjjzGJd8QP3VTS26ghk5ayaN0MzK5UjygjpKLEqdyoC9x1Q2dI62TDsCpqo8qyON6hEtMpi0U66Ucwkqw59ZP
 Uo5bIh51
 exjsuYws76SGXMpAfvnRS4RP/xsh+Aaf4tQL25ptJVpgNje4iNqnsUGibpHNoZj9jYGZpFc1eb3u4Ci1QTLIaLRwjfR68BntTDV6RyRT4zKxNHOiqHTVekWqpov1tjQla3QPJASzBW0ziZx/dMOFwVGYNAnX35eyc1Mk4s2WSEo4U50U3hVUFayTq7beN/Fq6OT38KKTL6+VaObEEx4fMSVD+emhdaUipEMiDC2bV4ngX8TtR8qerDPFAF19ScIFlxHWvUoOxofmzmywuCZSabJ+yLy+5hYFV6MXvvXIhozmiB1PRwnYjIitcQCgRyqPzLiYeqpm+LV93jyHcakMkf3B87r2DGY2JQVWgSHY03+a1SH3LCfNSZfxSIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The constant exposes `bindings::SECTOR_MASK`, which masks the sector
index within a page (`PAGE_SIZE / SECTOR_SIZE - 1`), not `SECTOR_SIZE`
itself as the original docstring suggested. The misleading name made
it easy for callers to reach for it when they wanted a byte-level
sector mask.

Rename the Rust constant to `PAGE_SECTOR_MASK` and fix the docstring.
The C binding is unchanged.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/block.rs b/rust/kernel/block.rs
index 32c8d865afb6..b120e83d9425 100644
--- a/rust/kernel/block.rs
+++ b/rust/kernel/block.rs
@@ -4,8 +4,8 @@
 
 pub mod mq;
 
-/// Bit mask for masking out [`SECTOR_SIZE`].
-pub const SECTOR_MASK: u32 = bindings::SECTOR_MASK;
+/// Bit mask for masking out the sector index in a page.
+pub const PAGE_SECTOR_MASK: u32 = bindings::SECTOR_MASK;
 
 /// Sectors are size `1 << SECTOR_SHIFT`.
 pub const SECTOR_SHIFT: u32 = bindings::SECTOR_SHIFT;

-- 
2.51.2



