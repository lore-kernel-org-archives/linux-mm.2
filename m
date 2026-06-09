Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A67EECD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161866B0092; Tue,  9 Jun 2026 15:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1391B6B00CE; Tue,  9 Jun 2026 15:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04F566B00CF; Tue,  9 Jun 2026 15:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E90616B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A129714064D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:18 +0000 (UTC)
X-FDA: 84861322476.23.B94EFAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id BCF12180006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALQ4MDJ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SB8unmwrAO9mUO9xf4AbinL27K1XIFUUebCtsNMw1k=;
	b=RpFR+pMun+DtNbDtdBOLfmM/mjlNJcW6cGa0ShlK69N4lbLHlO+2aKiRx5yLqdM9QyU9up
	uZVrwn9O+NAWF7FKRpB5zkjoNBzux5qzuYwlweqK2JMaBfP3H9QixoSuTcIohQyma1nHPI
	jCzWjing3WGpFau06xk3oyTb2k1/iPg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALQ4MDJ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032396;
	b=MYXDuwBpiyIGYQuNOmY2LGbqJ/H+wmrCtpcZngWyrF/SaRWMSGIMZBQvi3pa4vcIsUwHaI
	VEBMxoNk32Zwge0yIv7f1y7wP2Mo7MTVUrAEkOt8yzxm6siQtC6/8d6uyf4R2ZmjnYZW65
	bc2lJRjleZSWmn/W6ypKCsbQQWPmK5E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F1964418E;
	Tue,  9 Jun 2026 19:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E211F00898;
	Tue,  9 Jun 2026 19:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032395;
	bh=+SB8unmwrAO9mUO9xf4AbinL27K1XIFUUebCtsNMw1k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ALQ4MDJ39UaQi4Xcs0/po7LiGIPPyP5hBFLR0xeILyrKkWGyU2T13VYHajc/84m52
	 lOhsZ9Pl4J6iG2SNWK3KrVrLIWeN70xM8JrHv8jjZT95NKJylLX/a4NyuzVsKmkpHy
	 POtU8lbn05to8Jz8D3CVT0tNcIvCqSXxWURs/EBmyeax80BEVIpQpdZOhEPfZzpDqL
	 mJTh7ZGuFe0ZL8NckFGbZBnqNXKJqtCawKadfffdzXFCSMQuysSbS65b+HiLlW7FQG
	 AbfFHuLz0h+ogiRgdj9JcjXHUzXrvhVbruVMLTmR9JpVPmyh0exfPcItLKtQlu2Jcq
	 2Ee86TSyLLBJg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:40 +0200
Subject: [PATCH v2 01/83] block: rust: fix `Send` bound for `GenDisk`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-1-82c7404542e2@kernel.org>
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
 rust-for-linux@vger.kernel.org, Yuan Tan <ytan089@ucr.edu>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1957; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=j94rzYXVcMOYMwkP1BfZKPpHsVdQeUm+yqM3C4KWNns=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS115ZnPcBcAbPrOuPuRVqGsLxm3lnTlZcjW
 axvRMhOjeuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihktQAKCRD6UCkIqsW9
 0GV+D/4l9Bq3nvQRAYx6wrVRSnUhKN8gQ453qln/Ip/dk0q8mtRhyZ0Za/ISiSc5OIZp+4G3xPb
 2d0KQ6dpftTRPG0isURFnasRIjo30OxcCpEH2ICK4N21I/RiyGMOqsAQMteSdFPQPRWgh9HiJRz
 hFfXXLzIdGxd3T+tpvOsfMnYe4PI+JS8C7gO/8Y6s+jimfh3vU+oKyHs89kOsEShkPnQfDSx3fZ
 x50Plys3MjPb5vaimaBRtnziqYsi9IkRmhkyzDKXl+RSZ+Tl6xCWucnlzQoBkxTrWld6IYjdhkA
 aTyWkcib7SjvbwEQqu43KtlhmHL/CAoNPgXSh9uNz+6n+KXwSzZSxoVWb/5A6elZZeUtcrcgvw2
 aB4OrN4TnINzJBneIGB5REjg0Do+AFBoJKPtP5BYa026fLRymtQVd50v6eUlvHvNLgNli9X8QFu
 KJiurZBg81YdReVkJQezYm1dgGfyPtZxiRhPgN8UbxJPxXMHE+1s4jnnVM2ATmmdAfGbR+Ugrgz
 8B/32qMGDi/1zCDNIrR1WnMQ7dyDus5zLM6m56VLTtW0nGq1dLGwiDsK+Mzh6rIszwtFkuo/2G4
 Glk/yxf5td/ojCS22TRv4n+bUDGP3zuQU8u77H2mjPPIKLfJCY07oq0xFlM3a3zLfhXlsVJjHbb
 K4TkagJxdHac3MA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BCF12180006
X-Stat-Signature: ywis48wwhxhnic6d4bpp1qf9ynec6ttt
X-HE-Tag: 1781032396-76738
X-HE-Meta: U2FsdGVkX196A7tN/6Z73FPvSqRdg//2sAuzDekiLju3GrjvqY4cCzUrYHgznp7NMgr2F8KibQEzHo9WTTGjdGQ7BJ7Aq/MfhknH4kLX4CTnboNBrADKKLR17lwBII1jAVpIDOmQzsVeR5y2S0xyaZz2AYORie234l2rvr9ToBJUOfZQnIuP/QZ5u+DFtnXfpB/rFu+sAcCbIZfj0j+uxQd3qVm0qsPH6W6kqjKOzWyWcFI/bSn66oCDNB+Q9V2iSiOKQIPe5Q0mTqO6eUO9P9HymueNZ1C3Feq0N4aXVeFUQ/IXU8Hmv1z0H6kRQezQ/53Zc6Uyi4Sys4fLuaQHIFGpnBBN8Lq223DtM3xSmf6jP+qqCDAcm5W2Si3zuHOl4mI4PZlOw/pD5gJjKkudCvsw+5o7TneDWJHZvyjo2Kyptz+DMRgbII9SB9kPTHtOZgzWnqWbQvLMEJBEfvg2PpNi3bMeS+tArhrzfXu44SaST32KwxyMqymr4YYS+zb5cO1YhKqWoxcwK/6B19AzUYwdbcnR1HZNMP9vxuV50gPZNaHK4oE42DboVY30tz5XoQ+iTiQRhMEj3qUWAX8Ve5qyfIv0OxdOD7d2PNMzMfBy5F0CwqzccWRSgo5jtOJIsKZjUqytjqABP6QpCe8m1fClV3Nm66W/N3pkOZv5/3LDXOa2C0su7llC2WgYdCbBiOnZoiyRicu+NgMLpEcCRGZXmzsTfEhRYHN+C/ehVl8KP1WRoOBSvF1lbHVCgTW2diwVJ2n3azpg1ur+xS7VfXuIbf+SP5ID4L5mE0Cw4MrjsZc6iKJfoyPpvRh75N/4G2QnZzM9OsD0y/IiYyMIDxu0GAOsg6vbCNqK4RvDE5+exvxtf4ysiE9HCElwrE+r8onk4hLJBSNAo0yNJXqtokS4Hwsb4BEOGtpOcfkYBZyzvU2I/e6ef4SUI65KqgCQfN/oJ2UOhHdRF+IaSmR
 rA6hvj46
 Ua4Dtw80f6y2tFX7Q/7YL9mvsN/Y1VigLVFBO2ZElGHSawnSwYRueQywY3S7O1j5FxGaGuXCVizA7fbPc686dJ9pZ3I+ZhjVSGPWrtpx13lm9I8zpeCjISvQbZknlBm4TAyf9qfMN1lKnl+3vcqHXUoBb2iukd6+jtwDcI3scB3D4052CXnac2vMPNaI4woUcsb9TXRQsLCU2dOaYQwT6Cc8XRxgZlAB+llDSlWEbLcohbK35qEz/2QNbBvq5izzr57bkXP/cqJ8cQGbcx22wwP4ni0FDaDsu/o3sGLBf9ZY3g8iIGFVyeHX+x146XWcJX8Lm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The `Send` implementation for `GenDisk<T>` was conditioned on `T: Send`.
This constrains the wrong type. `T` is the `Operations` implementation,
which is typically a zero-sized marker type that carries no data, so `T:
Send` says nothing about whether the data a `GenDisk` actually owns can be
moved to another thread.

A `GenDisk<T>` owns the queue data `T::QueueData` (stored as the
`gendisk`'s `queuedata` and dropped when the `GenDisk` is dropped) and an
`Arc<TagSet<T>>`. These are the values transferred when a `GenDisk` is sent
across a thread boundary, so the `Send` bound must constrain exactly them.
Bound `T::QueueData: Send` and `Arc<TagSet<T>>: Send` instead.

Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
Suggested-by: Yuan Tan <ytan089@ucr.edu>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---

Please take patch from Yuan instead of this one, if they send a fixed
version [1].

[1] https://lore.kernel.org/r/8839ddc5ff54bf454d508cde91d27d00fc3e2dd8.1780633578.git.ytan089@ucr.edu
---
 rust/kernel/block/mq/gen_disk.rs | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 912cb805caf5..b36d24382cc3 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -199,8 +199,14 @@ pub struct GenDisk<T: Operations> {
 }
 
 // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a
-// `TagSet` It is safe to send this to other threads as long as T is Send.
-unsafe impl<T: Operations + Send> Send for GenDisk<T> {}
+// `TagSet`. It is safe to send this to other threads as long as these two are `Send`.
+unsafe impl<T> Send for GenDisk<T>
+where
+    T: Operations,
+    T::QueueData: Send,
+    Arc<TagSet<T>>: Send,
+{
+}
 
 impl<T: Operations> Drop for GenDisk<T> {
     fn drop(&mut self) {

-- 
2.51.2



