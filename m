Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBAFC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C606A6B008C; Mon,  7 Sep 2026 12:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C124F6B0092; Mon,  7 Sep 2026 12:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01146B0096; Mon,  7 Sep 2026 12:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0B46B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17819401FD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:18 +0000 (UTC)
X-FDA: 85187549076.30.1C8D84D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 353C914000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLmhoWjx;
	spf=pass (imf23.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYzE3xMQyIS1d8Q9bis23IfTXOnf9HD/aTT5yP41aQA=;
	b=2sIkj2309wCp2TP3XTha21yYHv3NZvQnGvNB3Cv+9WlbtM8Unl8faHY7s37Cg8RVseEbAH
	rC9lNa/VKimRJbPQAMsWdlr0sj/cByHV+2QmPkjb91fwQygH6h5C1te0hfD8xMj/nzhWnS
	hTR8c4QY+tN4rxZ2H8Y3B71LbcFJHzw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GLmhoWjx;
	spf=pass (imf23.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799696;
	b=n13mqZo6T3lITL8Vi5ntwUckfdM5oBYb3H2egObYNNLhonslMo9IUpS8HteDDVe4WiCz4j
	YpS7P3G5gzLTpbetLLvIygxVCg14oABvgkVYGfIlNTIG5gmRwpzr5fEkkH4I01dgfdJXkj
	vu3xeXzwGMtPiBkBJUrb82MAawEtGPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C043860207;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62E34C2BCF4;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799695;
	bh=WxqT1yF3M6tgWWKnYg9hdR2pSdYcRFC589aOlzkEKCo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GLmhoWjxwhNm5JQ1ezCbtiJaIrtLZo2Kg7WS91JNU4wuyw9/mfFna74o4ACU877Kj
	 nbTzDZv+M0xR3UeUMM4WNNtLDzCbO9tbdmvhSz9oCLySJzk1K+ytj4hDy83aWoBOiG
	 BLZdA4S6hGjKDvD86SyT59KvbAdaGrxrVZrQi5UgnrklNsUah4S17QqEOs80deO+II
	 O5IIK3uJabEXMREzHhNeMdNMh6soQnQ9nSmDe/Nt6lkvxIqqE4joPbtnM1RbXUgGLB
	 gop9CisYmZQNve8eYRa4dTRfsb/St9R5E4s/nxheleKAY5sHEU8yFjFrJMkgK4l5nk
	 Sug5eN/00n6Aw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D38BC79FA1;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 08 Sep 2026 00:47:48 +0800
Subject: [PATCH v2 1/9] rust: sizes: add SZ_4G constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260908-tyr-ioctls-v2-1-88bea777df67@kylinos.cn>
References: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
In-Reply-To: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
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
 Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 Ke Sun <sunke@kylinos.cn>, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=1664;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=so+WuqU/pYd8/dKzBVqpgAsW0XebT6xqiODTucEx6fs=;
 b=w3XcLqR1VQevN3qWcQai1GYtPQNLzv+aBbIvX1piwpdczwbSyazqpxKHZg94TivRfbzcvqI1m
 qgIWbCsMq4qCZW9sotv5Hu+943CQnyirsVV6qvpcZoE6vXbrJ4Cb0t2
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: wfb184iy8sm19y935jrgj8rt3qnpbsax
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 353C914000A
X-Rspam-User: 
X-HE-Tag: 1788799696-299763
X-HE-Meta: U2FsdGVkX18XeulnvVh+VeUWArmpivNFLlrNhp2lcr7E4fD1BER0vWDhpY0oUxMfznfHZBP6gJqY0wPbTSzuE3W30T1UPuv4Z0ruM/gLRSJZg5pg5TloqEm3Zyb7Ukc3fB67qfjLdrpkhnmfXlmTwzeCn1sbPkVDooCOKebs4euXYDITD6i9kiSPEr/8xwCFYBF4d7d7NG++CK4CjxtfxLDKesM2VGcDgHShmqqQZfbbfsjn1vYZDJqsrTzRATWJNPDcTGNbwod28BCAAmvo2A677AN2x+39WYNKBskGc6bbeV6kyHi0KeN/deW7XcpDiZ8glEVt7/aZcS6lkaeAea677e0QmChg0Fv/SiH4LkE17vt8Gby+lfxxEkAGNQn8H3yq5qOccPHGo8ncej7VQlTPfJ5z80AWaEb8DYq0TZ4WZ3wnxRxFQsAa0e5j4qxLiXs9aJUTbsuOMcEHlQ0ak62MFeHEQdT0MIhCrNfV9fwcI1rSOvj+JNgUpJNdJwAKbu0IndzDM/+TlKQvpLPMGAaMSnqAN88IjwZgh1V+AzfenyxlgHEXgH/wOgG9IV17VB+F6eu60xZzRtckFK5F1ni3wDZbD50krlQItMIkENBO0THKUKNRLWDb04yyj4d1iJcGSII2fzb4xxwh9upb5K7k1zt9WnZf5pkfkSi6+azFB1bQLqAV75Ou9LVrkyz2W7OcnAyjDV1NbQq8/NENDWFnu+u2X7+hAJuG+HS8XDDM2uEPDYXnNafmMyzzpxgG0GbQpnFLvSsfbGKkKThCrelIcyNEf14zRhOqaHFa2sgKob8mK+IiLtgZN2DtE0B+sfQWRz0pTGfjm1nv89VNel+3krzKkXbSxdOZ7k+FKRaEcCOVA9nza6ohvAPn2/X1R1IHOa2cC9ioXmJO9PQq8gp8hqkmwUq51vpSit7gtN4PvEwUYrjqspnzun/FVNuJ3qJR+1+sQR4UDhEdAXY
 6Xtfkzu8
 tm9QbBWe55M1Q3qspKydEo7aiMDmVONN+Xu3xnauz14A3Jzqu3LL7yI8Ac23zQ9yQBeXvti88iLc+VJK/k7bKJpLNTDBBoZGOrNCKPNPYIkdSDj0i3FJfWEZ7ROuTWC3FJSL3eXZsJNvx1KkKC4jAzwnU8w94eUZHtcMKIE79803xEwl8kfI+JSEmNraQkeSszVBCC8ZMZSbbarKu+jSDqi0jHHZEfGC/KTuswGfgP/JaOk5Uds+NgK+yx2ScuHPZ2VPWeRxRrsgdcSTffXS5XjYlx+o1lj1z7XWQc4BNadgSAgUHdVI9B1IAn9h+BlFkwNIbUcG6Lv0tkM983M+ngGeBIoRol0iIi/vbwuSDPWl2wT8DFO+PFjEdjElnHP11SKA5en7a2S40cMrKgoDg9KtgvDweeXqvcb5l4oeXyMnb/+NnCOatrF1ILBE8kvWSjydtEQmvi9iTqA1v+08QrookgMQ8S2F9ETHVhxQ0GuD+Kbe21dOUZh/1SV1YA/JWtUgP2EZI5rC9EKIAI4CHO4qucSJaoI82k37k1nYIX8XO9htj8WoN2zPGdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

SZ_4G is used by the Tyr driver when splitting the GPU VA range into
user and kernel regions.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
---
 rust/bindings/bindings_helper.h |  1 +
 rust/kernel/sizes.rs            | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 4b31aa7f432f5..9bbe1538d7c7c 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -115,6 +115,7 @@ const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN = ARCH_SLAB_MINALIGN;
 const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN = ARCH_KMALLOC_MINALIGN;
 const size_t RUST_CONST_HELPER_PAGE_SIZE = PAGE_SIZE;
 const size_t RUST_CONST_HELPER_GENLMSG_DEFAULT_SIZE = GENLMSG_DEFAULT_SIZE;
+const unsigned long long RUST_CONST_HELPER_SZ_4G = SZ_4G;
 const gfp_t RUST_CONST_HELPER_GFP_ATOMIC = GFP_ATOMIC;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL = GFP_KERNEL;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL_ACCOUNT = GFP_KERNEL_ACCOUNT;
diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
index 521b2b38bfe77..b236573f0792e 100644
--- a/rust/kernel/sizes.rs
+++ b/rust/kernel/sizes.rs
@@ -132,3 +132,15 @@ impl SizeConstants for $first {
 }
 
 define_sizes!(u32, u64, usize);
+
+/// Large size constants (≥ 4 GiB).
+///
+/// Only implemented for `u64`.
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



