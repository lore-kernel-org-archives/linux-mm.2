Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BAC6C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BA26B0292; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316A26B0295; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201956B0299; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6DEA6B0292
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C09D5804BE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:19 +0000 (UTC)
X-FDA: 85165678038.11.DEAB86A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 91CE820015
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jX33c9XY;
	spf=pass (imf03.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278957;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtppRdw7TipZz+3QwoNbnLj4cuUecMzZllIo67MEJbY=;
	b=tNtPvkzOWofO8OfRBVYQQWjjUeOaxYOKLygaxFfWLgEwqDqeDtL89ziFfMKp/RD6/49qeK
	LnPSg9lxhoI+FI25twToIqVoWGSvl3AhTCwUDUZzUufn+Trgz+DmS6kgpBIAtiMvJ0E31c
	u7TA84gmV4Z7Pfc+yQYxsSN8Db3rlpY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278957;
	b=RF8wsc1vbVdo5JCr7BrEW1GEjD6zkQTWNJy7jIAOt29je7lZeMjeG+CH/mpG1l2Eimu9GQ
	Y04yp/VrVsj0dU1NG0FtK7YS4OksoTlTQqQo7WVC47GyrVKqFuvtX1bWV5I7kpz+Y2lEFm
	x6OZl3BDWU+gKRgB6l9mRaQ0s2djEzs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jX33c9XY;
	spf=pass (imf03.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89ED0435A1;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 522E6C2BCFB;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=HCzDlkK0nf8Z76dEe91GoDU2vHhNj6rRuUesVWHafOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jX33c9XY5g4KGOiSmG2AnOP383Z/xJUqQrbv1Wkj61BWYTJHfz9wmsSFslCWuBrKQ
	 7tk8Jgn796rG3a5yBrMbnXcq5MzA32kq7dyo3MyczCnzIjMB8hXbLcK7kdEQhFO0YO
	 vt/t0dLjZ6DqGXJu29XVtu9hQX4BFkmK9CPFh2grBP9L0DJODRfkx+NO3pzdQYau7P
	 Qwx+uhtrEmbO3LZvbdxa3eTsNcSjHehgYj/WmlgIa8D+G2n4JX9voc1VdsZc4i7Rkr
	 ms8gN8lfztRTF9Cle9nzY6x9UN0ZTYYCTUgS0dtc/h2QZhNzpnlY86lyq7ZS2lXjZv
	 0L/+RmXsLn0ag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34902C61DD6;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Wed, 02 Sep 2026 00:09:00 +0800
Subject: [PATCH 1/9] rust: sizes: add SZ_4G constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260902-tyr-ioctls-v1-1-e0fdbf8bd108@kylinos.cn>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
In-Reply-To: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=1486;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=dYFc5/veCaNNg8MQU+9cuPLHHyO8FGpKl5rFntX1WcU=;
 b=665RQwJmoeo0nrNVmNip20fm5N4zGkoBukodL5WY0TTyTfeVY/eNtHvU8BWWPfC/6vzciEs6k
 9wfe94ky53RBThFvDgMjbDYxxCtTUb/RhJlfk4M+oPk0Kzj7p0de1UC
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 91CE820015
X-Stat-Signature: 7am1h57d18onbwfgpair6qm997kc3s18
X-HE-Tag: 1788278957-556771
X-HE-Meta: U2FsdGVkX18eEEGpIS1ZYu5rLqVdJPhWjWEd7jAVjkRTMST62ONxUapHUXyiTqFPlMAXzoPb3ERHrFuJ+IR91v1fE4e05izRoSqDn291TUTY0Ex22w+nomfpWfsXg1CtQkVz0OJIYpv4toF2BYVfRlqadZQYgHHCV2dPc7yDjFGEq5wTR9AlKFnApxbpTdIkgB1qzCWl/ZCranorDau08idty6UwASvOMZ2QrIPG0CZgc/WsAFv6vIEfgaLJnMTp7uJJwWnoRI7HiDsW1ocf9r8KgFKB9G0jZ+jxm4gVFQFzqtoPtKQsL+pAHRw21O5NQGWGh0BzR2rBKnVFN5n2q5dBL9Tpgn0sECh1d6OxmcFh8GMWlAbDK+cfxbwvVLSJDOCcMyUEbTjhBdBSX49Az8W5L1M99LxNBUowGl3uTHHuY5xiK4Of4hCBHNCjlqKnjY75AhUdmXDoMirYTS6ijT+KRXo1Q3xRG7d48abXLsD3HgYmqasCxhSEV0bvKNw7LFuZ6VsM0W9N7+BBeUbobZAcxPJin91eu0KjGOHtRBM4hkF7U3Z0U4vzTPyB1kCLtvMJCNKiYh+7ZDm3Lpm1LzsCa5M+SVuLZ0gHjpDdtyiaNJRD8AGeQqB/JsuATpnqwo1sqLo+2QUQULJZFKJZlXO61l7uZTvEzpugf6YDx+G3LO91PFZaLjzGmfVG/ukQzOUJyMNpG6KJf196eoT4S55oX5NrX64iocF04hv53I2+q3BqeWYB38L2ME47HT508OZ72AGJCa1klFivZAt7ua1WZaEvPf/D8Ig7B9XDtKVvBAEkIWYpFpOlXdaS/2jDD2ym3tfzeuwY3VeQVeVwN1tI7FnUASmYWoF52Y702pbeASBMmxS9wgcFtm2x8nJocO4ZrMwp5UGMVRID5XScJNiAGrI42q3X0xpFXVKjdNIB9hFt/Re9kbr61L+wcmJeUkjPOcmTSZLOXl4FnwA
 oBRDn/L7
 eUKcWQapSbRGVeh6TXcM8K6zp4vZEczhkBadu1BO8x13w4LWr6xGsAyIuSfmJXq2+mO882UVF7p+pOLvNyXywOzVzYNI7mVkEi7vz/aFKJsTNbVWkAyGunjQ1YeBvggaqlxEV3H7/0TtPzIuZv4lNDQLoe6Bb5TiDSTS8bbpk2WmJS1qUkb6lZ0GzFJ4ZEnboIfq5KiwjJIrakd9ZXHCh7nQh8TuMygOW+oa7qNqEAgae6sCY74eGcuOR2pZSgHW7qCaQ1djuOTqj8oXbvb4mM8Mi+9Fwa99gDZ+xP2Brm7Te7vtpqZpOYqGiu2v0LpecSQIFjxD3VK5nQdvTevHIAiEPRgbJPBjyvZlmPElm5j6zn8DZVsFvNaBmd81XFZMQdL99JLOJF+G1TsQpeLZ/a7dZsxsL0T8v+TupCoQMs9y21g+NyRNvSHnTsrURtR/JhaR8
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
---
 rust/bindings/bindings_helper.h |  1 +
 rust/kernel/sizes.rs            | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 1124785e210b3..3c37993991b1e 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -110,6 +110,7 @@
 const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN = ARCH_SLAB_MINALIGN;
 const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN = ARCH_KMALLOC_MINALIGN;
 const size_t RUST_CONST_HELPER_PAGE_SIZE = PAGE_SIZE;
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



