Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16C0CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 332946B008C; Tue,  9 Jun 2026 15:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A166B0092; Tue,  9 Jun 2026 15:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220586B0093; Tue,  9 Jun 2026 15:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 105976B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:10:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0763165003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:42 +0000 (UTC)
X-FDA: 84861315924.19.62292D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F2F0A4000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lm1doXFR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7g3lYXs2grCtTPuxxxiBCjUGdtPSieCEyjdPX9TpUo=;
	b=ZVVeQVJK/C+wCbboRy5Bz/svUd8hhpJ48zc6kYM3QYD3MEFrYiyRdxbjkrGifh0gqzL6qn
	yLLlqug4bzH+G81QAwgS+wdtHelhh5oWXxqX/ORdK5XlVwgy7/ldsJdorrmPHG67I3Nq9d
	kflSgxelT1w9qEr4YBy6XTr/fp0/Qro=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lm1doXFR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032241;
	b=wXafvs90c9Ywm+Rqc20OP5Qar2MdBf7alkjnZHkB0hmQdVaVep2BOy+zcViZjL3KUadSVf
	mlZwm5xMw9Vkm+I4IQ0vBYIYiHB/wPBrXLK9cW6k7z9UUx/KbH/XFMWwInug29HDNSeIpA
	rKP9+H//cHViY+qAYCptggLVt38mREs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57655602D3;
	Tue,  9 Jun 2026 19:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B451F00898;
	Tue,  9 Jun 2026 19:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032240;
	bh=/7g3lYXs2grCtTPuxxxiBCjUGdtPSieCEyjdPX9TpUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lm1doXFR+4S/8kmMih5UCQi0ymkFJpYbFdiQ4qX5gYG0t+4lOjfYlBb4TgoD2nRjO
	 GTwRJXGjsTwXU8o4zK2wI28qJksbQVaW05XjXPDEktcjkR3z30IYnbVFTM1/oKOv8t
	 MnI+RmR2Q7V1c7JbjKAL6d1u19hu9S4WiPdhxfg2ry+sJikFqEW49XDa3wL4muXkah
	 vpX8HfJYx81CFuVlZkVNJ+NESf/fTdhMXi+W1NuIbUufSA6BNZmazZbjVhnsr+h+ar
	 e8p/gcX28taHZSurKCisc2oDXGkk1gRO/bxsoUYZHTDxiJ89WUbomMm2zJ5ND9cijY
	 U3nyLU577Amtw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:53 +0200
Subject: [PATCH v2 14/83] block: rust: mq: use GFP_KERNEL from prelude
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-14-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1117; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=s+4gufW3UhlqKWqsXkBFJk+U/u784ZMLj0EBgYGeaY4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTBPbl9h3oqRHD3qmw+YLlvzYSsXXClOB/ws
 R1mq9pxblqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkwQAKCRD6UCkIqsW9
 0KnlEACzvlyksB6u2aU1pLlwZ/fl8WaqAxGeKb94S1jgEr3YgSy44Du05LDxbJTqrljEY9Nw89z
 JfCzmr9MkUKrJFoBp6X6gVMw1lICFvyQw1eStDW86Z4pEJAeqQlqegnCf3bmCxi4Oi2ePveenVd
 QYmQ3M2//o3r3izL8vSGEMrcxWTWDaQyLy77WjI8ThjP10CwsrUb7wPwQi6Mrai76pZZoZP3d1f
 Gk4ghY/2l162hUvogAKsQboBvTdP0vMvdN0Qdlx2mACa7Z1EBwxIGT0WOVChatkbRrXPCVL0+f1
 UGRNkA4J0iLTdZ1HRQGsmbDzSDs4F/+nOMCJjO017Hi2dM94inwsm/eXoEJtryuLj7JC2fbQHgF
 ma50rc5KnKtYYuA4x/dNRz4OCwWjqok9TBht6fYIuhCXT11ZCmdUiZO2VqIqN/0WBRc6bhSNnjG
 sduuyzMviPUz7oITP214t2u25YFK3sAXB4X5y9BT9v5C1YfHc57kfpNJ13ALLgvhIQ7pWgDVWLp
 huVyio+8RPWJvvNe03euJ2nD5PCi14wActvblauFVVBb7Bor5eGmz8Sp/zAzT8RXQwQ/E7AzIPd
 24Ip+kB0VvL/Uy2Q6OsuQ+b1VHbSblRGX8KbOyXakb/krEyDBw65i0uFYG9WioBneDLlANLenZm
 rdFLIcZjtTAwNwA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: F2F0A4000F
X-Rspam-User: 
X-Stat-Signature: et5nernsc7u5znkp87oa17sb7a7k9j9u
X-Rspamd-Server: rspam09
X-HE-Tag: 1781032240-441897
X-HE-Meta: U2FsdGVkX1/hika9VYIQqDRX7ILHpyMFriwCYhY0ufoXD1hB0ROoimiklb5C8BRaE6SfOAj+LATk/RSv8x6OvUEjKA//Js5fWyamVPyBdMt4byJ2qrhePxSmi09I0n64ZSTUtmpT+6lXQpTJbHjYtue7t4VzbUROKPGw4J9nqGpBomwryHSbS3FMKWo/z2TG6rb03bkAYCemTNxbx+pxNfvaPFYGdiupnZ5JbMfxxud6YYsBcITTTYm1ituFQ4EcifU6KJHDluVnwFS8haHQMseIEDv1L22xKASEIeo04acO2m7A32s4ULw7I+q1xpwtSxVQyMDy2c2vqO48/rTS1Wqx+dw8fOA9IQYjZrq81OdMaWinKociZZPfF+8Mo7hHGLhcTmKDfPle4OQiNEqLjfiv+eZZv3PBkgQ+4Gb1aLXW3O2m5I4azwC37eDPcGF7ET54H+g0thDBcADSNX4pjNGPgsQlj28hIxP38xI+wp0vI4+v0BmBkBBc51z4UVmyXywQ7pU7FN+eko63nn/mJCm4sgnigRnReEnKecN/7mi6g9B2Q3tWS2g1mUKqPhBNOK1XOJ044AJMBs3sk60esczuoz3PWjHSpI4rlBm4ptzdNExcZgK7M7soAoua40IiQAJe8ijAWnaNtxqLmEo9lX3Po1BWpGpZhPTsumsddNaXhImsLN9Ckt9jFegTKn1sR89+yuxE0Phy2xICw56QVfFK9vnSQ/wkbfhlETVSsZ9puucOVpU24wRpX4NiSkuFZWOXlbCcTUD0xR3FMs/2fl7ZqTafDSwvHSHcqOnrHYqcIAmCfklR7fgu8Jdm8pgkTDn9dfGefbJsrjMcW3LLYDGtQ31DUojqviJmDkC01zUjc3ShhgcinIDcZleZ6Hke59mTpSiP0F8lgYrNs5joPp5hAytDnnMrBHT9h+yKA89hgDW0LQ7XzcX45+X37iN+Ust4TR2h9FyMiGvShZS
 HMKl68dx
 Y/LAYv7F22T3fVBzeMqRYlbM/U2jwIDca0v9aRLjOmr6Wz6k5yw7zkm4Vpt5Q2Gxxd5uMYA0CzijXsYgnyMzVaBPLQtbYqKveKLHrmA+hiYbY5w3ClJGf3uiWQjpiGOKe2Shue0TrivFqCZoLL47S4UZwABJUlPXU+CJ2x4PHKaoQ0dWtAWXOwYGpsu6k1ObUHsvWCrzF23oc867nc19kanI8yjYIFRWQi+pQlQSkDqgq45wYlCHhDimP9BuhfspEPKUbWeLig9U8TdvCLkYvHrs8T8uBYpak7Ld+Z3w6VSq5G274UK+61Gi3H66GPRdWN20OIsCxIrrYvGOFfQs8OdxOIZeOgvuzhri/MLGmA6qzdEsqSKIh+NFMThBEYHGTUr+fW1TuSVZKgSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the explicit import of kernel::alloc::flags and use GFP_KERNEL
directly from the prelude in the module documentation example.

This simplifies the import list and follows the pattern of using
commonly used constants from the prelude.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq.rs | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index a03d46d274a5..23660817df29 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -57,7 +57,6 @@
 //!
 //! ```rust
 //! use kernel::{
-//!     alloc::flags,
 //!     block::mq::*,
 //!     new_mutex,
 //!     prelude::*,
@@ -93,7 +92,7 @@
 //! }
 //!
 //! let tagset: Arc<TagSet<MyBlkDevice>> =
-//!     Arc::pin_init(TagSet::new(1, 256, 1), flags::GFP_KERNEL)?;
+//!     Arc::pin_init(TagSet::new(1, 256, 1), GFP_KERNEL)?;
 //! let mut disk = gen_disk::GenDiskBuilder::new()
 //!     .capacity_sectors(4096)
 //!     .build(fmt!("myblk"), tagset, ())?;

-- 
2.51.2



