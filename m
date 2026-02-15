Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89A33E63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092676B008C; Sun, 15 Feb 2026 18:48:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A426B00A9; Sun, 15 Feb 2026 18:48:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87606B00AD; Sun, 15 Feb 2026 18:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58BBB6B00A9
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:47:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9C86C2CEE
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:36 +0000 (UTC)
X-FDA: 84448315392.30.87A87D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3AE524000A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L77sVJGJ;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUQnUa0ROO/JjHU5P97Sz+lTQkLkTU2aMQWFVnPjMBI=;
	b=VUWr0wz8rtUYKurxQHtIjCJhcJFwOP5eqLCx7kvzmrxtY6nM0kmvOdxUHVGDKoImEvXYuR
	mVL8U4hltBmvjJfl8fvdvGeSixyTyImTkY7Jde7KHREOc6mO0rqaeJjyomu3tauxGKOfPq
	dwIGsIR7VizHt60NOYeOTYxATYopaY0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L77sVJGJ;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198895; a=rsa-sha256;
	cv=none;
	b=Gsb0Cf70/XWQ34nkjAitQATTHF27OfKHLQz2RMeiaAvi0nvHkXygJaxnPcEAzkhY63L9If
	ghDeGgpxxS/GLZ/sMjen2qOBfkBbhtg7UO2bHllhPBe9pB9fOGo4fEQps8qCI6VPkjpHM2
	FMPK6qIR6UJh4sNRZQFdepPXyS9jO/4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B97206057A;
	Sun, 15 Feb 2026 23:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036A0C4CEF7;
	Sun, 15 Feb 2026 23:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198894;
	bh=acRR0LGwJ+y2FUW7GXjH8dY8YE5jwTLkAI8WFKvdvS0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=L77sVJGJj5AWUp/VBo02FiIgfdQ5aGIMLXeURfrgkHpVzHAQnM6emwYJGi8nBy5YN
	 t/GKtv+Gjp4xid2JjZNhlyatNgOb7mH2RS/eft1GgYfaCaNmM5Pu0G5H72jxN9OzDG
	 w3F+cBlWWqSGMa2nmyzVu3HC3NcLLbgrNITUhjXaDMbfjbs0/zfLPxlVedLGGXOYux
	 yuOqqPmQnqKFkIMfuLTpSHndjtU+rmQ+oJt6Vb9TQ8EyO0+6j3IyO1ajTSVacikhD9
	 jqrMgSgnKrf/+Wnt77SiDoOTx6nCqE0qyFMpSpuSRDVPfRMoJqNX2Z706Z7jnpWmVD
	 l5SOvkxYC5D5w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:34:58 +0100
Subject: [PATCH 11/79] block: rust: mq: use GFP_KERNEL from prelude
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-11-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1071; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=acRR0LGwJ+y2FUW7GXjH8dY8YE5jwTLkAI8WFKvdvS0=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklglP/KMsdGWPNdgIxkYpZcNKm6lzoIdY5t40
 tyXldVLppiJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYJQAKCRDhuBo+eShj
 d9xOD/9FOygg/84nz9+W8W2ER0YJsvYemP2aXeb/lR7sW6F05uvwWohT2XxSYaSLDGF9vFZeAD1
 hFVl9PzB7B+uzt+uZNFcjaB+bdmOI0mHU3orIn3M8rnrF3u0v8Kfde2uUiLXVglcvGw7QpyJOEu
 QfHPsmTtsQhxtmMf3EdNBhYioH7d3kAUg521/kYeZlr+SF/rlyXgLWGyZ2kZrG6UI+iBE9U3bv2
 7pV//iJSSizhA75X6E4l4eCTHgvfSKo/4gDmSM97YQq9wTHfDUIYXzH0psvShnnWyNSoUWthLn5
 Ka4nBngHT9e0jBZo2bu/WUizXidDTYl3kze8Ur1GDXIT5wOIlAypakvPe4Uv9cEba1PftVtAoqY
 xvxWf37mkn5PQPazg0xs+Mlyu+9GmFGokhtxA304Br4V07pwcix7JGNpWNOQGCnzb3HbB4vDjjR
 5GKbbztCE7IaQ1RI6xKpTXL/+nPBgDCOo7qBXhBPKIDFiy4T2CAFZjFKOGoh3XAXkhRcMm+iQXi
 Ng5c0mmdcJLRK4e2sBs8p61im4GeUsYwQXXIiOWsRr15rwNpVzyjZHawhzJ/zT54QgBtFQ0jTOh
 LH4gIX5WigNLyJb+sT6pkoWj5AukpenSB4cKMxYLmkv5Q/AvLYidf8bNUs/kPcFx651A38xcX0n
 5SgmfJP+zdDT4WQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3AE524000A
X-Stat-Signature: z1bs4owqoguamjanopdphy4id5tpwksd
X-Rspam-User: 
X-HE-Tag: 1771198895-663560
X-HE-Meta: U2FsdGVkX18vXElQ7XlEuA6TgsWkxSKMTP24q0RvY/1fYUwjA74M36w42tr2TvZDJKJOPUYSTOxOmq4EptswV3YAKjkprlP8uEspBNh4ymuXjgAg9ztaRHxYUjYjMBrlWISAbBAIMkOQ3rQZcscMXN7xSpYg57WgKuwV8Wbk5guD/P7PH7LQDiEPx1uLSxVpYitNBbFyib9IuV2YX3Qi8QYqVLZkpkaI9Q9PErHxZERQXpikAUPD8MXvVk4KFvS8nnYtaJRodpS4W3qp9Kw1KT83HCkaMqWVuY/AFaKN1emxO5WiNi++R5gwVe3GDsVr0EghaL/Sl9Fus6YidSr4EVolloHFqv3t3Wn9bhD0ZZlm9IxXB35izO3AFVravw93OMFjV9qeRNZDuzi5dOZEO2lox9l9ZhOEIt4rYWrMEqjxv5F8Q2X+BclcL1jJzzk0sCJ6JF7oStiBam8Fu5o5ezbWgQxptFbRDs0zk5W8hehCjJk0txWzDpDE7y7ougX/WahC5Vn3XRz03QIU1whjareaRb/NN//PUQ9DX65QLBi4Lg3tDob5aCkOmfigk84t6Rvj2uQGLVUQT/WXrIaqRE15oF365+rjSZDsA2AQKORHKY/pz6Jx2C2ek5fBH66Vaj70H5mUjpR4mDA0sfNmGJ5rClGnsV1ViDbF9H/JabZTUiY029ohEYUya9Bb/lZMUmUuqGK1Ex4zTP8HXDqRhAOiX6sjjzceMlCthjcytnp9LKseM359G7zpPnKd+65yaD0bsC+9/6zsMADbgpUGJNWaYkZ0U9oECRBeneOKFNI8iYNv3n060X5cQwlM1gqW5RgbBxF4R4u3j/LOqilc48J9RZiTiepjwfMgHighg/T9aAkD8hDaW7BcZDCnko8IdV92qQ4cCjLO9j36x1OW/6Tt9vqi6T9ATdL7rvbRGnK/vgsHpl9mtDKn6o0ueuekWQc5cjn2iLHXtHMvKJo
 zLwi+WPI
 iuB+l7FAG82iWL+CupS/fWDqQUxkrdi12c68ZdUemurVQU2DtExk/aKDHvN+KOTHwwVogKb5c24n4Pn5vrIVjhgKeKizDWC4qF8oGdlFaTgtz77wza2Hi2a98r6e42TyBnvGVhec3jX439lMOfWomc12TiRj+CKJd+fOMbz0CBML/MMXMi7kIdwWkxxPbk6Cq2+Loi2JkdSajpppFcgXyfUeR97Kn+umc8PasRj9Z1J/Qq+JXyw56XJnz5Anee2x6jbgye/hUU8EFOBYnLuvXFJNHHU7g6ZoDYveDTx1ux/LYKm4ikshfnI+Dk6W8knW/HC8yb5Bqw+31OoFOQuT+x4wFU5njlcx3aLcxiJEysNtC+tA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq.rs | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index cedaf85ba0b1d..884bf18abbba5 100644
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



