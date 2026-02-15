Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D858E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B066B0118; Sun, 15 Feb 2026 18:56:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE566B011A; Sun, 15 Feb 2026 18:56:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E04C6B011B; Sun, 15 Feb 2026 18:56:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24C866B0118
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:56:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D4998CCA9
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:58 +0000 (UTC)
X-FDA: 84448326396.18.D7BE298
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8903D40004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fQ+sY5FJ;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GA90vH7vTXcOlZzqQMTkwTrlQuJt5mVzb/e2MKcB+g=;
	b=cSBs3oIfhlg7ITOU7DNE60DL80/jYXpOp9+7hH3TzCYxwzIVmfRkJCxnhzqR5PjnMpdOvs
	yaWj4Zi44/4OLKdIu8NYz8cXqFkRujH770wPIrKzfBkzvS7aYjAaxxWGLwRPKtiL71AIq9
	CFyo55WhaxBMCHb+IjU6pXeq5eKnoMs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fQ+sY5FJ;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199156; a=rsa-sha256;
	cv=none;
	b=D2mS0qNdLXFe1KZ8UigyaVibniRPKzQxpnf+RGymBgSx98/uzrUlQHlQWqwYRuVV5zL1+c
	hTU4gY3qU4egpMwbwBKqiBNIaeHlDQq+scDG15NWtxiq0+pZA3yQlNHtfKdSDIDEIh7+xw
	JnsJdIA1FiuYKthNCZBV1dn/7pkd9ls=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23FFC6013E;
	Sun, 15 Feb 2026 23:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FADC4CEF7;
	Sun, 15 Feb 2026 23:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199155;
	bh=wrhcSML+9BrPk1dlrkX3dG3Gv57kLOFA8v0YPzvxLbk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fQ+sY5FJdFK7C0bMKDMNQG//TkYOVO2Ma+pP2CqA0jHQ6Kjt5PMd3AHl+pMQZI+vX
	 T/dj3D/hKGzZq5zB1TgW2QBg3UZycnJ0SMt2QSQWpbTrPTNTCAqiUjStS/koUCbY0h
	 q7xd082mA9CIk5ClY4pTkcHa1SWkezlG7fuT+vmHU2lmNpMlmUdH1xc/j70j+vxGIa
	 qt/PRGHV01WoCxvgNhK82st7kTqCemWSlV6QBVTq2WhnJAwZmJXaOK4AMSEZkmXDar
	 hXYO2EYOXPVJNcxs/t6jRyR67CplbyDkJB/WcB/HSUsdxiZccQq56R6O5/n77YhiPC
	 IyA2ggG35mjOQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:25 +0100
Subject: [PATCH 38/79] block: rust: require `queue_rq` to return a
 `BlkResult`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-38-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2623; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=wrhcSML+9BrPk1dlrkX3dG3Gv57kLOFA8v0YPzvxLbk=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg+aD2Q5nTpLbFekOe4kY2SQW+CRM+wzayNW
 25s6DTXJzuJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYPgAKCRDhuBo+eShj
 dxAmEACUQDpqem2zZeoXicjw1rcXE/XDLpB4OxcbpJHvAtlXd8Aeb9D/hJe3GMCXRFn7Cf9loKT
 ZRWGAJSF7Lc/MHyX7/WAKCNkpAboNTpi2P3T0EkHTOVKJYNLF9dTlpXEsOEvEpzfXOx4pHB+4B4
 3RvW3jFJvNl629qfdyos+8dYi+SjXc7ibhRUjIrfplr1X4BYzgxeiVIZiXspMFkz15aZW/9Dzdb
 u99kjs6xhkzqw5xAM9qd6hExxH0igyyE10VPark7jPgsjbrj1jO2GdTZj3cmG9Jl8Q9EP1Y1zDl
 FCehWz2ZycZZsH5Xj91UulUhUbRmPujZlrBgnJ/J2rAqjHpGW/hmTA+GowYaxK1iA+zMRpe4El9
 ygNqT9CN/pnC4F+YOn+5df7L3i7+UBop86EOW1iyz59sGtsmh0o69MK24skCsoonQ+sGUovhEW+
 z5+bl7IFzWgffJNz/XCvM3Gp62t2dLHFfsJrlMa4aZQfuXLP1nZSEPAMmZwb/UXfD9nSBi57+Pd
 fSFtbGL7IEyAmyBjr/w1lBJ4pgZvyHgrzhjXfp3HwyI+vLDuyMGpGAaXetNTMCDrQJNhwfEvzxA
 PGHUZnfD5K+N0kzsylNrukF/W6731eIbtPimHorIODHsra0oI2Bn1+zEfGbFrFhshcgWYbF6YHT
 OTXZstg5sbfAyVg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8903D40004
X-Stat-Signature: tp1mmuzxbkbf617qygphe5ciyjag7399
X-Rspam-User: 
X-HE-Tag: 1771199156-351557
X-HE-Meta: U2FsdGVkX18yIDpBdtvjDIoD8tG4unHHaeqTOIx8LoCc/grUDnhfZjvzpg5ifvz6yVhBes0bazZliTv2Su0W1mg3M2mgWMxJzhPwv0YXbhPdQoyOv3qiCeqZF0ssVtuOhSBPZlZrHncp2NhG/6M+yDY/dbilshUyIJYAq1qWF6hVOxZHp2xxGdd1E9mJQIdfen3UWqV0lCv2xn0SQO+yaWXxyQx4ihx+ekBsvSHykRLkz1+UNpRYwPoWDMH6sveWQyZ+Sg0PuRcUc2QzSLWpv+IcFUYu1qGdEFtdfChbAW7OJcphMjR77n3vqHCyQdLxLxk8lSkJdP3QBODOxqktdq2OVvrnawwfewHTeTGWdQX+yEjyvZbTd1lwBD6z9cGsYnESiUdicxSSiVvOE03oOWvIVgX9Uz58SDhCvqrc8kRRnySzX4AmMZI2t4Ijr640O9Zado66PmLuLtsvpFj1/RMSXqrLUtEHsP+ljiwoycA0/jGNjDjErgh35QdfA13yeFi6boyTNnzOZ2Ne1aRAdU9QoyhWvalvNc8CjglW5KC1l5ZA6XPf1F+Q3ANwHEiVco789cvMAcr3LB4o0TxcZzH6y41WrzD3cou00SnP3TmhwxFS+OekdzkMSZTG37dBxGiykDZPbPiQQtiylNc+HoXeV9s9ITa84sEimyz1a6wEQny/cyouKRtoUJTz/ZWSBv/V4KO9ApAnPbYhsTv30d+gC03lvUBW8k6QM5UDkuYVqHtGGpkitqVydbVrilibD66yAa5abs6BYqKhoLN75Un8zHhYGBX611T6X+ba3AhSl+TepIzOnQ12ZdwQSKeJmAdoHw65Yt+QeQsEXv+SIUCRzRUFBHeRbJa3i3iTmQsIR5uonBzzAMuJJ2jqLdWkSvfYuGR//f9FbvJSp2Ff2EqmQKQCuvMi+YOtazB2Gy5RBIH7yGMaCddjvc3RFW277dpOL3SknP0d9P8KaWd
 nDBBjEt7
 pyAVc2iB2Pw2Jre42DZK40IW2ilgV/LrItQ7x1JGIg1rby6TfOXoZe9e/skwpVfSzQjlcjmnahkBQpZqkU845FoTPIc+wbM4Q/qZvOIMGZTK/CP+AgX+8wDNg7vulIAkxF6S50jsfRhinH1bpcAsiImYxoONoZbqTNTlJYgmcxDnzqaZf95iXgWJUm2B5OU+fc07rLD9wJYr+20loCGGRTnbUN5a3XsJhFL0EtbC9t7wfblQL3XoQf2AMelSRiBvWqOzeASGgAUxr4E07wJcxJgaVh+Fcj6gNEEi9LRYo+qgrw0uWLYhntkYnStx/VFXAbSvjQg6+OuR0F4lbZaD+ytYp+mU58bFNTZZE4DrycodZ9Tg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the return type of `Operations::queue_rq` from `Result` to
`BlkResult`. This ensures that drivers return proper block layer status
codes that can be translated to the appropriate `blk_status_t` value.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       | 3 ++-
 rust/kernel/block/mq.rs            | 4 ++--
 rust/kernel/block/mq/operations.rs | 7 +++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 034ddc06eabf9..55cbdfed25414 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -20,6 +20,7 @@
             BadBlocks, //
         },
         bio::Segment,
+        error::BlkResult,
         mq::{
             self,
             gen_disk::{
@@ -577,7 +578,7 @@ fn queue_rq(
         this: Pin<&Self>,
         rq: Owned<mq::IdleRequest<Self>>,
         _is_last: bool,
-    ) -> Result {
+    ) -> BlkResult {
         let mut rq = rq.start();
         let mut sectors = rq.sectors();
 
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index a898dda2635e5..02738f52389ba 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -64,7 +64,7 @@
 //! ```rust
 //! use kernel::{
 //!     bindings,
-//!     block::mq::{self, *},
+//!     block::{error::BlkResult, mq::{self, *}},
 //!     new_mutex,
 //!     prelude::*,
 //!     sync::{aref::ARef, Arc, Mutex},
@@ -90,7 +90,7 @@
 //!         _queue_data: (),
 //!         rq: Owned<IdleRequest<Self>>,
 //!         _is_last: bool
-//!     ) -> Result {
+//!     ) -> BlkResult {
 //!         rq.start().end_ok();
 //!         Ok(())
 //!     }
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index fb75d65f67071..17468a39af60f 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -6,7 +6,10 @@
 
 use crate::{
     bindings,
-    block::mq::{request::RequestDataWrapper, IdleRequest, Request},
+    block::{
+        error::BlkResult,
+        mq::{request::RequestDataWrapper, IdleRequest, Request},
+    },
     error::{from_result, Result},
     prelude::*,
     sync::{aref::ARef, atomic::ordering, Refcount},
@@ -62,7 +65,7 @@ fn queue_rq(
         queue_data: ForeignBorrowed<'_, Self::QueueData>,
         rq: Owned<IdleRequest<Self>>,
         is_last: bool,
-    ) -> Result;
+    ) -> BlkResult;
 
     /// Called by the kernel to indicate that queued requests should be submitted.
     fn commit_rqs(

-- 
2.51.2



