Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5935CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F2A6B012C; Tue,  9 Jun 2026 15:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140AD6B012E; Tue,  9 Jun 2026 15:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055D16B012F; Tue,  9 Jun 2026 15:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E71BB6B012C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:17:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AAB321207A5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:53 +0000 (UTC)
X-FDA: 84861334026.02.AF5674A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E22D6C000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BOpkIGy0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAPErZub35CZRx6cRiD4tDxfNHqt4EuvLpyZZOzwYBc=;
	b=YYdx78yDG6V3KMjAvm5UAbfkwTGtivTW0+iF3qqFnlqggKNoXddl26TWj+eQVf50x2qEI4
	5zEEjbJ1XSAhFl5DFinqI+ijP/TRrZ4RlT+GrUycSOWAHT1Xi9rnLucHGqy5iF1SJZBR+A
	8ZNT45zjS8AkdeFiYvQK5JgjTV6xIbk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BOpkIGy0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032672;
	b=UjSgQlmWMNPG6yvY+oX5T5FwqKu1yLRPh0W6cHz3SmhbEjFKKgwAfMY43tq0mkaGuyMncw
	W6jx0lJnOWyiOW02i3Sw/l72ZQN3yWZhI0Jm/IkazQrvy/BaotqjKd7UbcYlUqrB7n/iFE
	mU2pfPfTogKQ1ynqhJNEorEhTRCi508=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38F6F42A0B;
	Tue,  9 Jun 2026 19:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A021F00893;
	Tue,  9 Jun 2026 19:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032671;
	bh=dAPErZub35CZRx6cRiD4tDxfNHqt4EuvLpyZZOzwYBc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BOpkIGy0vWKfnVPuc32W+RgiwQEKWwVFlLjhaG3yLag7kuk3JZrioSTHUZazNEX9V
	 UYOWlrhQf01weTRZYF+AWKbbC8q2gM+G5u15fl51lLINl16hXrFlqkS7lgNRODpgE+
	 nOTTpXBhf+f30wu/FazulF8lUv3UGupacuXC1k9KlNDZH2AvDBjxupV1PZz/0LgBg5
	 UNxNy0Uaflf3dLD4ei4zWmAUPXm2HYky5KcP5wgkS0qfxeMAvZ4DuIdECWQL9Iic1z
	 cVDdL7uFG8iWEaAuzUCLfzeslTJtOUcRK8AvbyKyzUS8/RUKHTTAkfYS5iPQcz5zLa
	 IMb36Yp7Os6eA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:50 +0200
Subject: [PATCH v2 71/83] block: rust: remove the `is_poll` parameter from
 `queue_rq`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-71-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2480; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=xd/altTiEmLts+ET/xrl2RTBlfY83eAmYmlDKop0Y4U=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT027BJxlk5QPCxItS21m2vrFHxGANnDAgd3
 IbcDwh3OPWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk9AAKCRD6UCkIqsW9
 0LF9D/923dP0veZGR2zfMjDu/gMAkrMiM1R4hyi+SVGsVcewgN1D1luGHrk+H6j9V9TNVrzS3m6
 gAu8+oplAnEp2FcSumoCdp/D73QHljzxq14myEC0wZOTOWbipS6Luej/4wgrDTMJO+UdnzdaRAG
 tKWS5Rw8c55Far19Gncm90UVqlxCq9AoO48teIcKl1MVaXKxWKoIwLh9ditcZ/Qg+S/JHr2SFGm
 POz0yCG2RJFhL/2heewf+s22ZeNWiUR6MaamuAMoylXhwM91kP9LpEm8uFYPqU7ouq9olV85igQ
 H8j8K2posTmlHNBupPFh5/oMBvs849KJZGeAIF+V6iIgP3qE9bCtJSPhshNO9c7YO1OAsOdMNKO
 EOLU0Jc+EgcjqVQQmvW8Ze+pokll8AGRSI5y+BQ8eDqnhsw+eh3Ptn6EzgDBCObgcaDPXbMJtDJ
 LKdbN8DtBmwp9llutBwp6TGpT1ceS4Ph8/TYLzq+oPZPK5skpRNp9tFVRGrARV3dSMR/TX4jJzI
 /odctllp+jTuef2Z3pKiFTukcgCXrHCbsOuSnrQvkM+4m9/SGaGaqX1/PVHEjBG0kkuXEB3v6fz
 juSBiv5FucmvVh4zkjKh6Hen50NFyv70eNX1r4Wb+JJKe6Gc3Z4uQt5bqylYSF/DCZLDcoQxLwN
 8UH8FXhYWmjQsOA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 14fbda6qiu75pk6jaixjjtqcs3u87aaa
X-Rspamd-Queue-Id: E22D6C000C
X-HE-Tag: 1781032671-726057
X-HE-Meta: U2FsdGVkX1+CkgUDHVcQy+Xj2SP1zyUzTeKtfEAcmLUKd7r66T7wLC7MF7KEMsiV+nEtB9zqE58HdaNyAF5dGW8DVXVFRqqTh5OGZzqWK1x4qV/4u32B41h3QwwFdI6H34FvsQ/OZa0g1Mqbk+tuif77txgYklBQjqLKO3okfH2Q2p6dKwMNfyEIWN+LIOLqmVhLywOcA4/HBLdGHLtfDocCLAfc4Q4wzhd8F9a+RqfCSQ/EJgNjKMchr04650vTm1JGnj1X+i4oykmuJzTcBFy2gcTgJdRGwOqZGFWgpB91zvPXGuk1dRXhTbRIwYhRRH1/hqbByuG6s07DvKn9dnWyCQ8G+K3RYEvJ93PMgieNh/6rLW6SDM9r6UNoHqTea7fheYnRkME3dmOK9buJHjWA2PBEmuPlIuDp2MgKpSmf4HmUhq5F6JnxW0usSduNsFEEg1ufMTxps/T7nwORwZUAApKFupfA73J3tZonswFH+oAUmg4kN9mbsfz9Raz3jL/wn0hvlKFPSCHG9+WcR+8FO22yoDVdTJjeu9zU7c1/6Ynlyzc1k+w/Jipyu9gRRGgOIX0BmGCKy1dRmn8633FQ2YOm5MZ2hNMizX0ao+al+O9+R4qLhEEJxuc4Kwn262BUB1pAAI+23VPLZ0z0xDZ+Sk3ybS/7+eHu+c2Jz/cerHTunbOGmzT82OVEBnCIqTljVZpFvFIsGbavYnZgGjE+eqvx8Ac7mdlb0WZvNu1E221eqNSNHFcJRESwelbN3D9LWCnxsWfpE/Krcyt0KQKN1Xt6FK41hGlQXHDrSR9pLDMbyeYb/JlL/Vz+9eEIyD0P/KMBEWm8FyDbPTX/yaPDsPpA8f1d2J4u745BXkTefLHj+ywcsc3cWSaU2wVIvHwcFk4TUO8v0mosA/ztLxARrAJmGT6uInq0Gcji7L8M0soBTPfwYgAtFHWtPPzzn50biSP0qulXYHV5Qsc
 PjqbEZ/a
 i+VI0oj2OfVrDOZe5j2FbVULsDQBzxRJ+dQ5DqhUINTBZwXqlu6Eqsm6Z/qutOKs6ZOpSJtKtoj3SNt5b2kYB2OV7nznE7WF0zE2WtpXvdPvfuKXyAs62cIo5PyC0u5ha/Qk4qifNm6N4exlAhIQ5LP2aJFP6X0msMoogaa8om6Xcgc56GXaM6p76waYCSsyKOeOU0pXRcgWBXWYDPvpd04JCzM32VUGVo1BxK8EzavfxH30CPFeIxMMrEpcQDDzq/wUSyiMt6flDRbEENIPgos+YPlG2oJaIHpVWWJ6tADSAW0Seqtb53lwYO5Md2kZRB1jy5DzHQ6qvlkwW0XkmtpU/WaDnTz2XuKEtaSl6E88RY9nppfmQpZZ5qgK+T6RBLKQdgHO9S2dKWZlwsk18zVIg1FIjBKnraY44
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The information can now be obtained from `Request::is_poll`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs       | 1 -
 rust/kernel/block/mq.rs            | 1 -
 rust/kernel/block/mq/operations.rs | 7 -------
 3 files changed, 9 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 32af69bbf8f0..8e17b2b17a66 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -960,7 +960,6 @@ fn queue_rq(
         this: ArcBorrow<'_, Self>,
         rq: Owned<mq::IdleRequest<Self>>,
         is_last: bool,
-        _is_poll: bool,
     ) -> BlkResult {
         Ok(Self::queue_rq_internal(hw_data, this, rq, is_last)?)
     }
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index e8f0d03f2ff7..47e1f860c6ba 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -90,7 +90,6 @@
 //!         _queue_data: (),
 //!         rq: Owned<IdleRequest<Self>>,
 //!         _is_last: bool,
-//!         is_poll: bool
 //!     ) -> BlkResult {
 //!         rq.start().end_ok();
 //!         Ok(())
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 505e7d2b2253..d28af9a5e006 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -93,7 +93,6 @@ fn queue_rq(
         queue_data: ForeignBorrowed<'_, Self::QueueData>,
         rq: Owned<IdleRequest<Self>>,
         is_last: bool,
-        is_poll: bool,
     ) -> BlkResult;
 
     /// Called by the kernel to queue a list of requests with the driver.
@@ -214,11 +213,6 @@ impl<T: Operations> OperationsVTable<T> {
         // `into_foreign` in `Self::init_hctx_callback`.
         let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
 
-        let is_poll = u32::from(
-            // SAFETY: `hctx` is valid as required by this function.
-            unsafe { (*hctx).type_ },
-        ) == bindings::hctx_type_HCTX_TYPE_POLL;
-
         // SAFETY: `hctx` is valid as required by this function.
         let queue_data = unsafe { (*(*hctx).queue).queuedata };
 
@@ -235,7 +229,6 @@ impl<T: Operations> OperationsVTable<T> {
             // SAFETY: `bd` is valid as required by the safety requirement for
             // this function.
             unsafe { (*bd).last },
-            is_poll,
         );
 
         if let Err(e) = ret {

-- 
2.51.2



