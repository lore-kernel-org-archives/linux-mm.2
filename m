Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E48CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CF76B009D; Mon, 28 Sep 2026 22:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97876B009E; Mon, 28 Sep 2026 22:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFC86B009F; Mon, 28 Sep 2026 22:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 915556B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:15:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2647EC037A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:59 +0000 (UTC)
X-FDA: 85265184438.01.AA51D84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BD7680007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rz16EmNn;
	spf=pass (imf02.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8M0oh2AqgxAI6ZpQRJJhghp96GjY8sQQ1ghn1+UQZnU=;
	b=UpHE7WcgTihl4/otOmtGzkpMZwSHSq+Vw7k8/foZCEo6DS4x/13ByCJ7yDuodU7nTlg71M
	v41D6ogkcc800tNqKuzTuiLr+AcB3BO0p7LDEZYXDtmFmOLa1KDZIgQDGZ4I7Fdt8MfCnN
	0o1zaTOyOlbLPUTw4i1ylGGDPsgGlks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648157;
	b=SnVek7XmGpZZsFPu+Kq4SeDZOYUIrMc6zeILrOTHq3uPoH6KoHG7vgIJ0lEVZAzCNbmmU+
	8vVzJfCjtFajJb+XsPOrBTnEyytgMK7yONt1+/8RYI/pS3HrHfUtJ72CLBvPBvyuQQYiA7
	QxfQ7ljBh1+Qidd3BYf/5OG7tqWI8I4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rz16EmNn;
	spf=pass (imf02.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94633601F9;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32F33C4AF12;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=Y+Bjb7lYNOXArFBTwJ5tEEIzUp4p6FTp653OpvMTivc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rz16EmNniSViHWXdNQLsRMPsEq1FS0gJ7Zr2KPVyIS591DtITnqt5sYbet7FD4xma
	 /IbfV8BwulSxoi7V7rBmE5zowXewZAac70Cx1QkHSi32V6DNLuAUI7t90tEMMykKbc
	 y0vow2nJ2xrNR9K5uOBNP5XwDBV7fKx7lrDHAuT6ZobOtmcSQntGG8gDHsxEw5UXW1
	 7oXV52SbCc6Zo3JI5nZ6Ni8PPkOvFPMJJHaSNetvSi3fbyl0usvWqAnmpLt/lE7K2E
	 fyAsHHfL2H5zBqCw/d0f9C6h/7tOSVLarV75XE4vCVfV4K3J6dQNWmKPWOPbWa+Gtv
	 ehdON+BO4qB3g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117B0CA5FAB;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:15:51 +0800
Subject: [PATCH v3 01/11] rust: sizes: add SZ_4G constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260929-tyr-ioctls-v3-1-26955fb111d5@kylinos.cn>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
In-Reply-To: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 driver-core@lists.linux.dev, Ke Sun <sunke@kylinos.cn>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=1808;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=5K5ZDtbb0No9pS3iRwCaB/ZkoyNuv4RA97gE66KsHmQ=;
 b=l3bdZ9ZK97meFn8m8zP4xbBKLXntFnscqTrboQul2MtghnL2aNeAsJbD2XGmryP2qCWeBvrYV
 OkGMDVCvBd/AtMsUU1mlOzQ4qaxkyNYi+AmvkcvEWS6DJT1bIP8mxhd
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3BD7680007
X-Stat-Signature: 5gs4z93xnaktodujna76598776wu9r8b
X-HE-Tag: 1790648157-939850
X-HE-Meta: U2FsdGVkX18zsa+9WhOXGJwVu6Y74+Yc5VcYC6bu3cO6J4qOA8SculrQjB/2RXV3eBMB0DJSG5d3aoN7lrAMX3DGk1aRnssdlpyTnM4T2EhqDa8cfCzdRvjlSjMPkMRQuq2UoIxhka3Y9bIndHTSgH3Jp+8mooclPonAziyIxpXtpXsXqXp+Gn8S5YEWhb0fwbG2+HKqDyXGWYeDUjdKDmHimfewhmuyaHl0BcWHtV1d0qGeFS2lX+EE0N/TVXNFhM+c378f8mz1yoqMqGjOcLhpHlpFE8TxMQ2H5u0kbCW88xRu8x1QvC2JzAJPvNpxrOp5X/Ww7E/vtZbaUv1x6J2QKsHK21BHlr66YKIbK6CQwETPx2saFwIYuzV6uszU0MEU/L2fgvlI8uljL5qCggWLPzMh7EPt7C1sHGq5C+RoS2S7gYaBWQrgSWhwlZQwqmH91eNRPiid3c4+skrj51rzGQGdpnJPERzqarJl/GxwYpdFLt8BK/AgRJ1sKmGWRU46Qob5af2npYxlH+5CzepsxW5LUnxSEtB7biaKrhO1XT4FhqGV+g44IKcfuNQxeI6dei4JTCVswpmpSlK8M0+YixPDhxVlNMAF7COzGWU06Gf/gk1qf7s68YdRDCjUOpiwS7soyvYVrxNxqU2bV6YiF0kYfXOvCCzHT1OgXTyA02wq1eTCcv+VdIPUOcTekvwV0UpED02mfgPr1W+eVLumaDrwYG8a5U3jrxCdgLbunOo8AVrg8mQTUGvTLdm0hNQwS7UbMS1CErsW6KDpw1PLs8ZulRMR/31FpVXROCR719n6Zr8y3j+5oHVHQwbZP5doaxQc8jUtmZjMfX7rIVrdgnJu0GeaxOVZ1MGjXl8Wi4NBiPg2Uq4SdvHKtm/9WTpquwW0NT0ivFJQI2vG3m70Viq/Hh/hWUQZV95OpKBuk8S3CxNDs+QzeIVOCBkxPNeCqrlmUzmdQ3fHWj0
 /futkzul
 Al14TLy1qGWKaL835ctjNozHS/xf0gA4Ay00y+WvcsqWZG6sY3h2rRTt6HfW0NpwoaHrwq3SOrkP/uncKleOIj+Wsa1y00tpcEX9u9b5VPc9Coaau2oa+SbqjW/4cN4wiuVj2PcwOqalIiEzoPNLMtY0wMoZvz3XCVooVco+dvQGqTtJMr/sUBEGjBNJeIMmM7s8lfwuoyCg0PKZGZJw8nikhbE4HZtuYCsK4WpERrC4RvJhcQerqd4bogjvJOl0u7BGhkJ5O8kPMrRPEd8cuUVX5hhLN/5+KvSk7SrtAYYvrEliV7ToZW8I/7rhKW0Q5YEAlUkWoz4BK57y4o1+1HKpN9H3cIkbpcIZV1FieEJ7BqZzLmlLH6q/64WgpdsmsZprbosQsjLDpWKb0qnhbq0s1LR5tBuC8sWiqhqlULY7qk2X7R2330tzI5ZTx+1kTuRRKoGGRQIstJRoU85BLaV0TKjAMEQqohVAEDQ/NkSF9Pt7w94dYz1YR6YeuT4HcWKaWFcrAvp9EXAoSyyWDtiXrwvZO5xZ2/do+tOgnSmNrDDTN+2WxjFGBIRVkZAJxu64d5X/qyu1Peh8YokGJE8wsTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

SZ_4G is used by Tyr when splitting the GPU VA range into
user and kernel regions. Add a LargeSizeConstants trait, implemented
for u64 since SizeConstants only covers sizes that fit in a u32.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/bindings/bindings_helper.h |  1 +
 rust/kernel/sizes.rs            | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 930e63290cdd4..ee99f470ae5f4 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -116,6 +116,7 @@ const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN = ARCH_SLAB_MINALIGN;
 const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN = ARCH_KMALLOC_MINALIGN;
 const size_t RUST_CONST_HELPER_PAGE_SIZE = PAGE_SIZE;
 const size_t RUST_CONST_HELPER_GENLMSG_DEFAULT_SIZE = GENLMSG_DEFAULT_SIZE;
+const unsigned long long RUST_CONST_HELPER_SZ_4G = SZ_4G;
 const gfp_t RUST_CONST_HELPER_GFP_ATOMIC = GFP_ATOMIC;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL = GFP_KERNEL;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL_ACCOUNT = GFP_KERNEL_ACCOUNT;
diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
index 521b2b38bfe77..0acc8733d2368 100644
--- a/rust/kernel/sizes.rs
+++ b/rust/kernel/sizes.rs
@@ -132,3 +132,15 @@ impl SizeConstants for $first {
 }
 
 define_sizes!(u32, u64, usize);
+
+/// Large size constants (≥ 4 GiB).
+///
+/// Only implemented for [`u64`].
+pub trait LargeSizeConstants {
+    /// `0x1_0000_0000`.
+    const SZ_4G: Self;
+}
+
+impl LargeSizeConstants for u64 {
+    const SZ_4G: Self = bindings::SZ_4G;
+}

-- 
2.43.0



