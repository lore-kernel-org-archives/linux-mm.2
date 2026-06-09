Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 842F0CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6F46B0134; Tue,  9 Jun 2026 15:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAECB6B0136; Tue,  9 Jun 2026 15:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB516B0137; Tue,  9 Jun 2026 15:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD5FF6B0134
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:18:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BA291C281D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:18:17 +0000 (UTC)
X-FDA: 84861335034.13.AB50A09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C6FCC1A000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:18:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Avj6ZWt9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uscdNJwwl8XqBYBhj9sseM+ELakppynPqvLUaYkMsEM=;
	b=VKbeTULk8hz9mV6os775rnU9b/nAlICJ17SbvfjSXMGC+2hf7sSlc0R1L7z0nGziFIPVtp
	reiNy40oP52jYrVTw0RRwT0vwftTKI5lM2ZtMNpVuDI4ka67YzkdD53KRbry1COFet3T7Q
	pM+aSTlI7Jt2CPQhsNghkLzDq6VSeSk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Avj6ZWt9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032695;
	b=rHICmLk+jgkBOkB+cOcb7s0XBo8iWdqOncn9mifH44VXnefpYbwQA2pO4fbekV0EIxTrNt
	uqg/KDpImMW78bBkIT4RryAXYYShsyB2n4nDtYCzihfXQYTGGRDlMTrnp77fyYiO32zyVr
	XUf49lLPkEGPeoJfXGnmxOIW85ns5CE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A3B043743;
	Tue,  9 Jun 2026 19:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7501F00893;
	Tue,  9 Jun 2026 19:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032695;
	bh=uscdNJwwl8XqBYBhj9sseM+ELakppynPqvLUaYkMsEM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Avj6ZWt9pyUdKva4jyLrRWrEGIc5qrLQcx1ciDPuZRvwlPxdmI+rdUb48SJ3Cytjk
	 U529xgXBl/pmejgxhzzGCvpCLn8XYDOIKug3ZUHdtGbztugR3slzzeLs/NScyu2Bua
	 0GWaP64jk/bcpXYC51pJynhkoMj/t5VdA3viPk9JiqVFuIgBTA26EgN7fxGUYKDdYv
	 9JRcuLKV6Eo0u7OWd0Wv4us8J2/Sd4IPpq+UAD9fE7m/ptbvJt/bkZFBBFJ+7yjH5V
	 a0XELaraRhArqjPXP+zACi/VPsIv05NW2S/1OQOV9zmmVy9Tg2jyy1T/lPF1lS7ARt
	 QVQH1dK4yF5QQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:45 +0200
Subject: [PATCH v2 66/83] block: rust: add `TagSet::update_hw_queue_count`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-66-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1334; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=lmxiQlFN4F/4ZyV264h2eAjCgTfWmHi9M8lfy1C7H1w=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTwVD2rB/lbhBXJY9WqF8y/XOfulLI3AS2U/
 50nQzCG89CJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk8AAKCRD6UCkIqsW9
 0KpZD/9Etz799ndlt+Bh6QO59f5AYdztn2sHE5grM0Rq44vTgyQrPIcUtZ0k7gHcl9ORVH+I8wI
 JsLwUzfhmM0YMr8e42dMLGbaZizg50DtAgDNquDXaDbTyyBa3eVSrcgzEEX3BYWDnr6aHong4aQ
 iXz/x6pvWXstmacukGPKrcoHwL3bqLa57k8IotdrqAhkoNhEMe36n90krLBxrydyPWzGira8QQr
 NZkPon5yJR4rb3yCTn1JC76RZ1l3lUATCz0Ht1Z/rcyHHM3SFkWp6tiOh6YG7+eHtxfrczoVVtV
 9KsMcvW2WnxX65N/96qL4kFSh6h01gOkJ0Ip1E23+onzt3VyGS4S8Xjs3s4wXP92hXnO3s+/dOv
 J9INh46w8FRpbHngW+g7ncoGB284Nyek22DW5F72WzkRwyB4sOevBaxuTxWDgatBH8U/qwyunUq
 NjmaQBTOjui8AEBizBKibIcF0hlGFW/v9aUg8dDAKnSHapcT7KhUixSwaiuZCfgJQtZgkmpYFhx
 9iWpJ22epXsC7zkmsWm6yCJRrDdDXqufL94+6QSEeu3PAr5lJZjsc3L9oRdCQTxbV2QvP34Q4/L
 Wupt5tIpG/XJv0eb+1kvVN+E5vJ23uQUHgOCByzlxPxVKG1qGqlWyN/sX8Jed74UiEd6ln3Xnz6
 pgSBJ+DnvEbhkEw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: C6FCC1A000A
X-Rspam-User: 
X-Stat-Signature: 8q67eg8y4zxea5bifyj699uh8hmwjjpi
X-Rspamd-Server: rspam09
X-HE-Tag: 1781032695-712298
X-HE-Meta: U2FsdGVkX19GqQG8SKPfv7Jflf3m+LhlUvfNSEO01BVT3Ikw/W8hstTmcz8E7bzURt1VOAcSdCc7s6v0Sdq5ze752HvM1aHF1CeSFPFN2yTBO243ddrvfrIYy+sn/4DBZfd1RQ1IqwdNHpAi6QCln2yn9/f+QCa9fOVQnp7pogfniYDpQPFop8lSUQ2/Zc1IwxVuaoWbbnLNvKzmGMDIEofHI1RTZFKWlNM7aoUSHRvOIk30pulSky2BvkPdO4TWSWMCTYV9YlAEuImGeFFlXPAyXTqFm1b9tf2l/bP3qPd3/pPEmUoObdsJgZ4lZD68feCRZfbphQUglnozQELBh8hap8t2edao+di3FxfQk7Kl0wnmSMvDzZSZU4Fl54eIiSnv+224EBUpyRMyrYIxoty1tiTbEXjLT3U+QRTrv8RD2bWjb93QIAPWSGpRP6dcVdTo8annwCvLWB5ZwUeTkzGF31Si5ktVKkYiKBVfVIktIlPEQEje/hLHrAA5VrFdE1kNdZsH4Cu9WAQfOOxg2RdravqqmuM1sh3zDLCKmkxKwBnJf/mgh6gxCLtsQ41kTRZeJmo9IV6jg+FdKNLUDPakmkyOWGMSz+ZAjmWArazT5bG6+GW5w//u5T8eUhpKFyqvYtFCydIpf+x/BPS9Mhgkx6HYuULrF18FfRFswfSZEeWeoUJoBqc5kaZgvqINowNoa7Be7Xb1J1gPCeHvlyMiXRwzcVHFxRUUZtDyEerI7eA1SpGrSKW5UIM0D0OlCZj7JCEYG/RkQ9ZqVL3oU8f1rc2keNKaPg+gEeVvhmcLMgzmD659MErU83AImkjHWE5hO1OZ2RP8h7ndxWnFJpPDY0Q9Uys6ASWZ7hBfpm3Ag9S1bTdulmP4PDFGkPfhDdEYASpPUYsvfk2Q88rZhKlruGuRrLQ9Z6vlz1vxY/y67aJReussznJxfvDaR48sh343Sv9Hs79fwMcTw6j
 1grYSCVS
 2v5onv+XBJJ2bSxqNbqwmwg3b9SG9mjL/dP8ywWA2UVOkMy+YW4kn2mS+KNAaEWujgtmeGs0uz9EvTuSApgSWw0fowXabRYluidWk4uX2nAWNP6Ctp2xU7fDCmFOspPszwx1k/4r+1xRFMSrYWyx0TOrTymAYK6eULI2iZq2oMEVizizG2tvJ/Dl2ykbFBtMa36YxKGe4ddEuRBPOlbZK+N0Do6rBCAMEzhYP1euuaHgMp4ou6k099EKeV/5qtEoTAW2uMk9LZGgHQPP53p81AwJlCsTcST7zkY3TP5IWtAEU5dnAQfgX7S89LxLM7Kr6YCwrq4TSCQrEJMem3+F+aNgtbGUJgN5219X/oAf47tXSWJPuj7Yt78pdNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `TagSet` that allows changing the number of hardware queues
dynamically.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/tag_set.rs | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index 858c1b952b00..e89c76987b54 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -170,6 +170,20 @@ pub fn hw_queue_count(&self) -> u32 {
         unsafe { (*self.inner.get()).nr_hw_queues }
     }
 
+    /// Update the number of hardware queues for this tag set.
+    ///
+    /// This operation may fail if memory for tags cannot be allocated.
+    pub fn update_hw_queue_count(&self, nr_hw_queues: u32) -> Result {
+        // SAFETY: blk_mq_update_nr_hw_queues applies internal synchronization.
+        unsafe { bindings::blk_mq_update_nr_hw_queues(self.inner.get(), nr_hw_queues) }
+
+        if self.hw_queue_count() == nr_hw_queues {
+            Ok(())
+        } else {
+            Err(ENOMEM)
+        }
+    }
+
     /// Borrow the [`T::TagSetData`] associated with this tag set.
     pub fn data(&self) -> <T::TagSetData as ForeignOwnable>::Borrowed<'_> {
         // SAFETY: By type invariant, `self.inner` is valid.

-- 
2.51.2



