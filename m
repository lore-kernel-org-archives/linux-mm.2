Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26948CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5B26B00DB; Tue,  9 Jun 2026 15:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DB06B00DD; Tue,  9 Jun 2026 15:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3106B00DE; Tue,  9 Jun 2026 15:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69B176B00DB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 109F140775
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:59 +0000 (UTC)
X-FDA: 84861324198.03.8838A92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4903780003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kfcOINeh;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032437;
	b=Gf6C/XQ/8MeD+I4TvUOTJRFzm+pVsQVGAAeJpzGqfNKl0bvXGZCx3qcRtCRTOGKJ2GDyNG
	FN6+xRGQjeYUfxjYgWVFyPmr+qo/4LT9KP8Pb2MlFkvxrLBeUXJJr6E5Y5PaGzhA33r/Lx
	rtGb7chK43vLYSbEkOa7MWDj4h6YugU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kfcOINeh;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75VKKvc6NJYD5SbM7TBq2nTJ46z7L7NmdWlGRZUewiQ=;
	b=i/VzG0HNTsvqHAF+b1kk/Z4QW5nqltj6HJeYqIwx9L4ArHjs/VOWNXjtWnGvi5VGwesw03
	I7Lw7JZW8dHCik9RvVr1UOCRcXXbwdXF7BT+0UBBTHwSHxwKPupbEBUxOAqHLEv4SpQgPn
	xMfO7xF6hq/mzUD2CfoN4VT4S4tBe6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D498A602C5;
	Tue,  9 Jun 2026 19:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3FF1F00893;
	Tue,  9 Jun 2026 19:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032436;
	bh=75VKKvc6NJYD5SbM7TBq2nTJ46z7L7NmdWlGRZUewiQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kfcOINehWKcp3xHtTXGSLHWSOG52K0OZctFq88FEdbCXodQGd98cSiTeLARe08H/I
	 WZdb4CcyA44JkRtJQOnH/HoVzi84FyydSlaaxTVzXONcu7HTe4IMNMs9m192s1V4OF
	 1QhvpFsnOU7Th4JJa/thaqDZrlpgAfjaUMzEFoGsvpqs0Hm/qDgndrXyKY8tDQy/IQ
	 xQElXKLaImnBu5kviUwfTySaGPDXwGWQfFcjblEEUttXyW68n8jo2WCSM1ZxyGYD6y
	 W7ZYebArVcSCDN5wNYEE3mToENk/qla4+cSl5PVFg5tTDZe7McNe4oS5YEC6wJdRqE
	 Co35lL4onwnaA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:48 +0200
Subject: [PATCH v2 09/83] block: rust: document the lifetime of `Request`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-9-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2300; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=WeYmUyzlnXNFxatIkPpAFWbysNLEuc10mgSTySvU0tw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS8pbk0dWGZmS3+sy2e+s65BD8zbm6UgUtCy
 OvQvHcZviCJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkvAAKCRD6UCkIqsW9
 0GOND/oClSp+fyePfjxASjbnzpRkbpOcYzsPIfJIFLzOEbuxRBKqUBX5gb6z9iM9ekAtle7EjDm
 LgmLhm0/UWbN/qEG/RzRfvXrZkkzRon67UBiFRqCaTGOdCAYMbrJSuUyxdCsf3Tr3lU2rundNb3
 ZxcH9LxUz0Bt2ojKj+vWsVfflJtJzKjap3viiFj8LecPgipAQqexSqDuIn8JC4hOFb2MuvCMuBY
 1j/QRQ/ZH5DxEfl9E172ZsadOzLm4CNgQeHRznsTqMcqi5iLdG6u1SJ6ReQozO53l0/faq7WhdV
 BF/L0lwriH76mvPK9gueQ4jM0vFUhD6CwrMwHHvEzgq1oSJNITpx9or18C6Dr7o2/AssXrvOz7I
 hc1I/qc5eslTGSkvxp1ftgksTj+cp0ckdVu9Hoo9Ok+UaB7cUHnFxEpmvRj7/x1Z0AiiFimQaJl
 uyLRyDmCazphHvIP3oZ7CwYBfed03bT6/5vKQfqWZQ3nZCShOG6Lq2WKTKkN4NCBGng4/TOdJ3q
 prIb/yRoyDjqzavaK/zyHafEQsUdcKTbO1lzIhC7McNRlpKUf5bt16+nGRdSXbEgfVPiKRd3c60
 vARab+Z3NoVCOPqseBUmafgMa3ay/XiiOb1f6d14r9Jv161VFFrwaww5vGDsLalB+c7IHagEWly
 JokXC674ET8kROQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 4903780003
X-Stat-Signature: pq4hqe4zjpx9xmf4c6hehc35r5iinkkk
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781032437-829901
X-HE-Meta: U2FsdGVkX19dBo4JjctkFQCI0wX/VcNsgIoDyOHW/YOoSMRxUKBCHpBbYe/K2/R6GUYYNsL8OZdpwo7CtojjAqsrmSE4iiOk7Ihd/4vmIbl72DJFqCAHlvmmpw09QjGiwuzAaoZmrvyTvkzzUZb1/LeL/e8F+0GLJOiHUJE6EzvXGkNjxqGmKRO06GzEK/l1pXCNJBdDNNgJk57RJXyJaypBFujkU6342NaHGJ0oBjnBZbdGzuUZiUQm2e7f21vHDPsp+IVVIUZbTUUxaKHzHVUCHAzu9Ut1Bw+KVrow0B3/JmPBcODlFq46kDNAB5ff+jhH60eRNSGvkFHIwSrrSIHuSzYSgdRwGCUOQNs5zl3O6n9ehN1aTsS4MCTFs6/CpsS1PxDqoI9QOh4si8rnU6ZLaewLe6kcY03GQRh1aTxew5rn0ndi0SwIV3xQZZizqsUh0fFdbjdfMxUD1cKlvvesEcRPx7qZqvrUP0OEY23OAwZVTCPvuqtEaF9I8oFQGD3DdXI6FqnYyzq2E+MZR30WBRjYlP4sH5hCxPOUWe5M/yVBkR9Lj9yP0re/znYF2/KbCU5SarBKZgl7h9OafX1e9wo+h2FQkYTJ5j4iKo2xlqBY2FfuLmMhg8r26vJDIQu7uYoLIixbXv4Co+3ElzU0qq79ZcJCGxQ7JJI2LWb2g3hY1BRAAOvmIF+prrtn0CgWql149nI7Uytt48b1FAwk5B9iAes4x0v4nVgXj7/y19EUQkYPrYhvt2TXLPbf5m7tyGMYakkNgcR1C3gazu9gahIbMJG1xxKl9smp4GWElHrYmaliCZYcYQ/iaYWwV/WEJsqvomr7SSpR9F+FWKvxyInsPJbTAuxBe4CtliTWRbdRatZmJbZij1UXqAw4N62M08QpybYSUudL0NdyvJvRUZ6dZigPUb6C/eeUhAeb+Qnaa5tvUI6tyHJUUGYnsN96Ypnwf6vj86zpWPW
 eA/YAnbv
 R2X0WJr4KUtojyi6mHo01qN94iaDdPn3Pj/y1pyju4NLdTpokDr7wQYGCazp/5AUiF22LByJ2ID6GFWyLPhZG5HTC24f8e5LQZRytYx2TpDRM4d0+ADqKvAME2CwZvf3izILJ5XKvVL4toz4KjDvF9uNkDQharKQTQ5znbeMgzQ9Jr7g7M8O+fConRNFJ/dyPowth4cpVCOJ51glUQrz+SCvcpxbfP2yAuXly2TgS+/D3xQ9+nEiw50gCdmsh4FQsSMurFz+CFgeOK761Fa5HVy1BS/toKECneqbhcNxpJPuayLuZwYBsSirs3p4T/m2ctTeR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The `struct request` objects backing a `Request` are not allocated and
freed for each IO. Instead, a fixed pool of requests is allocated when
the tag set is initialized, and each request is reused to service many
distinct IO operations over the lifetime of the request queue. It is
easy to assume from the existing documentation that a request, and in
particular its private data, is fresh for each IO.

Add a `Lifetime` section to the `Request` documentation describing this
reuse and its consequence for the lifetime of the request private data.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 1882d697dcf3..a6e757d8755d 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -29,6 +29,24 @@
 
 /// A wrapper around a blk-mq [`struct request`]. This represents an IO request.
 ///
+/// # Lifetime
+///
+/// The [`struct request`] backing a [`Request`] is not allocated and freed for
+/// each IO. Instead, a fixed pool of requests is allocated up front when the
+/// [`TagSet`](crate::block::mq::TagSet) is initialized, with one request per
+/// available tag. A single request allocation is then reused to service many
+/// distinct IO operations over the lifetime of the request queue: when the
+/// block layer needs to process an IO, it assigns a free tag and hands the
+/// driver the associated request, and once that IO completes the request is
+/// returned to the pool to later be handed out again for an unrelated IO.
+///
+/// The private data area of the request, which holds the driver defined
+/// [`Operations::RequestData`], shares this lifetime. It is initialized once
+/// when the request pool is allocated and dropped once when the pool is torn
+/// down - not once per IO. As a result, [`Operations::RequestData`] persists
+/// across the many IO operations that reuse the same request, and a driver must
+/// not assume that it is reset to a fresh value at the start of each IO.
+///
 /// # Implementation details
 ///
 /// There are three states for a request that the Rust bindings care about:

-- 
2.51.2



