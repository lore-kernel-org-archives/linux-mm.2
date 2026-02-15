Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5E7E63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4286B0105; Sun, 15 Feb 2026 18:52:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD056B010A; Sun, 15 Feb 2026 18:52:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5FA6B010B; Sun, 15 Feb 2026 18:52:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with SMTP id BCDAA6B0105
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:52:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15EB11B4E1D
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:32 +0000 (UTC)
X-FDA: 84448315224.17.7B05CF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4593DA000B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P6gN1JoY;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBZ2Qzu1Hacu5K8IGyGQRIxOr9OdYL9YpAGjcKw828U=;
	b=Nc93hoQqtGhMSjKJg3SmAipirnl/SYGWPhJOdLixChNXVtRDlePOVNn48bNFli8iECbYVV
	rwQVKmuBvsYWxC3+PGJrMy/IPbyrhw798LFPW6skI1Is3rgqRU96eN//p7bN/bDI0kRdhp
	5PwfwKPDKzxbbdSQ4RJdQte4wNeAhIk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P6gN1JoY;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198890; a=rsa-sha256;
	cv=none;
	b=jgwJt4LO2KRa44DI2IdGQwoWPvmXu8Y7IBhgNbi+1oK5IW9XZscB61VU6ECd9j353ngCHC
	DX79fndje/I8307ik1zIEirAOAG10eBg5XGcBGVwOaUW+YAiBxo7iOlis7p25qKe/tAjIr
	i4nV3z3GEct8Llmt+g4es/RF7ulg3t4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F69340741;
	Sun, 15 Feb 2026 23:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F001DC4CEF7;
	Sun, 15 Feb 2026 23:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198889;
	bh=vHPgpZo5uXgA8zL+qju/AiVs11m7b10tJPDeLW3U++M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P6gN1JoYAil+b2m0a49hptXFxRbU6gEBpaZDLQpGcmkMNRl+ts2wQ9IGltjdaNsE2
	 iHtDP2IDj3SmgZ54TEEtWor4vbjebwuI/6hFw19GH6mKDkyZ5/MgUHV6fb4GGfNk0a
	 xj/p1b2YXIqEcyrLvelc5oC9oRgPZ0LqRgbsXEi4sBF0DJGBovK/t4K8s573ejI5Yl
	 BcQmzROO/AjjnmLo/yornM1A4/oLXUgDFODgqyKCOCTkPW6JlVFoWEiiKGUapcH0oY
	 rpAnGQKoWtCLZMIMHJTEW7jK9xXoDyS/WNUfFbAo1Qy+oAlVBeNulHMiJKsExOCnIS
	 uL0Uz256tvb6Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:54 +0100
Subject: [PATCH 67/79] block: rust: remove the `is_poll` parameter from
 `queue_rq`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-67-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2486; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=vHPgpZo5uXgA8zL+qju/AiVs11m7b10tJPDeLW3U++M=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhY2K0RYlJtYPGe5XGp2aD/s5dSMAoJeH2Oq
 zb/CAzQM5GJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYWAAKCRDhuBo+eShj
 d04tD/97m54PJ4Emn0i+4TXowMxdpppLVqZy2LiOwftpAsi23l98iD5eWe6aKOpyCgEHEXyfl5g
 Wq1XPUnTt8oQHgE4tpBPLAz8pzNke4DqN/w9WpvKODlITv3lJETQ3zHs4n91c3xL+ROO3F0W5OR
 w4v1vVMgv8hBmLr/8I4xlPGkyDWtkgEDjOGfqpRRvZBz27n4zfgkdT5ZPhHpjr8R2BteEGWu7v9
 R9iax5z1Wt+Sayzq7xXtL0uvd9Rs9Z5HW1nJpNllcV3yh36PdFibMYsi43OhC/kS8geCMoUY6m5
 lYDSHBw06dwiSzX2ZqIluikI9wtwZficu8hOzUeX8BIgidJNVZCFIfsDsDpyJSEnIFJJR49FX9H
 bBdURz9wVMzYy1AillTxxBKXbevqVQNEI1x+TzT9bEte0o1sLcriZZJVafiNVPGUoFXxAxcWQbJ
 kwTJdtofcJM26rXiDwYwOio1SO/9gpryZjduJrumk4x5OiVIvO/NS1pFuGBRDyEf71kkpz0yo18
 TUS3kp81o1NS4kZOad6+f83YVFW2gh5mZNfhbjWDin8MUToyhBJI483FD1Id4cNXA9pwr+HW0X7
 Vs/2kVPNqx5hQkKx8DpD/90WbWKLxxAMtD0qnsB4mF7+s3zzBTrn+N7v5HNwGUCHpstS68xrxTN
 cm8xLRqjLYfocmw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: 4593DA000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 7jzdrrhmj3caz85qe3aqsstny54spcxh
X-HE-Tag: 1771198890-469525
X-HE-Meta: U2FsdGVkX19z44Uqc4DLBHpALT2bhOJP8qDCHmd+HjIlPtydpZOMQ85VquZ+6dtj51szW65D118/CaytJ8C2sVoHRKeoJgYJy+paX6Z9EwWyPklcsQ32RZ1lJvh3QHXrOgX0O3O6JpB40QV2myJ8f6ASNW2o7NJ6ENNSzSfSA7Y5/AX5VtV88a9M2xgziIYaNK/a9KoTPMJD+GnJxjwMoUbxaBB1vXP/bxaG5ucu0UCn+QQmDqQ6P/IQWvxyl8AM0N4Go+KZNabglxIIM11m+peoF77qnZY3kSvHPjsqHR4rNQIYPvZvW5ZhG+Q2uk5Ztom7U905Z5Tbo9h/s6+/BsMBnzQ6G27jBHnuhUljZ6ZMv86XM/sXS43S0MSAwJnC4bVKwfdOzxQp/IiHn9/+ZqRy1EwgCOeHo4BXGr0f2Kt6oO8QY8agC/+jzIAU159reteC3h+Q1noC8ob4hoAB/Y3dAuTZNgHKu5sFuZIzKbE58YhpdbCoCqeonz0uLC+EiVYo3UUyGukAqEDMI9IPTA0lLvdrUNLmUyKuXw9RnLC6WFP/FmvejUu+3PUsDZSXAg+QnIfqvnSqcqYTI67lrzE8V2M0IofJu9/n50AZVUqDMGr+jb4PEKSRaY6SSjG434UbOBQNNHW0d4jRhtseuM7fGLDKfrsfYlEpZWO2nn7KN7q6WMPN9fhYbtYwVTf3+unZIHx7Ea9SiKJjvilbHCA/HyY693F1MHJ3CG8gDiKk3TjExwXv0SOTi3kpwVPXUNk2IyGbwpmQXKlGSaDVyZ5IbsdEk+zN35lJe6zskj5SuttoJwJqR9/aliQzb7MNGG7YNhZDifEl6a3RP4Ljs0dUioyV04jkq5awTeVtWOsazWG4G4WJhMd+AxvWrilHa3StmCrvrOvJhmpxSkj233ie7tYW5EMlkS7K4rSU2M81c6lgB7Wvbj748gQQJHJnSBRmDBiaLJNzX3Fx9tD
 MqglrHn6
 FzxiGdfTxi0PhSjpp4Qa39LzOcqpaC3cpNomk8HKbHk6YvVbH+z+9W/65F4eK5/jaLcJDmN+kx+KHtXo1FRg5AgkHHOeq3Ux+2suc6lytf3e5sqooL/d+KfOzk7YcrNxd/Em/3FMtQyL2UXf3fiOTTXmhNvH4zPTA9kwPNaIsVgpRePL6lU9FyZ/rgkiqBMyrTP5UIlpWZAZl4dLcvz6WHYIaoXrd9h6QUOwMcTxO8mOXEVKLarApZ3o5Zh6QGYXAJig7/yN2rgfJVeWVn9c/nS/KjxumOqE/kxsQLye+CFCHDtj77YUoYKPtvQKcZaCrSUv6D4bVU5o2nedYjG7oFU+SuTMxQrQxKPooBnkGSbHItVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 592fbf5790fd2..db856f03b78cb 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -907,7 +907,6 @@ fn queue_rq(
         this: ArcBorrow<'_, Self>,
         rq: Owned<mq::IdleRequest<Self>>,
         is_last: bool,
-        _is_poll: bool,
     ) -> BlkResult {
         Ok(Self::queue_rq_internal(hw_data, this, rq, is_last)?)
     }
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 786c32f2cb56c..02d75acfddb3b 100644
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
index e4de6db807e18..efead98767196 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -67,7 +67,6 @@ fn queue_rq(
         queue_data: ForeignBorrowed<'_, Self::QueueData>,
         rq: Owned<IdleRequest<Self>>,
         is_last: bool,
-        is_poll: bool,
     ) -> BlkResult;
 
     /// Called by the kernel to queue a list of requests with the driver.
@@ -188,11 +187,6 @@ impl<T: Operations> OperationsVTable<T> {
         // `into_foreign` in `Self::init_hctx_callback`.
         let hw_data = unsafe { T::HwData::borrow((*hctx).driver_data) };
 
-        let is_poll = u32::from(
-            // SAFETY: `hctx` is valid as required by this function.
-            unsafe { (*hctx).type_ },
-        ) == bindings::hctx_type_HCTX_TYPE_POLL;
-
         // SAFETY: `hctx` is valid as required by this function.
         let queue_data = unsafe { (*(*hctx).queue).queuedata };
 
@@ -209,7 +203,6 @@ impl<T: Operations> OperationsVTable<T> {
             // SAFETY: `bd` is valid as required by the safety requirement for
             // this function.
             unsafe { (*bd).last },
-            is_poll,
         );
 
         if let Err(e) = ret {

-- 
2.51.2



