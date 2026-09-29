Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB2CCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0D2C6B009F; Mon, 28 Sep 2026 22:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0456B00A4; Mon, 28 Sep 2026 22:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B373E6B00A0; Mon, 28 Sep 2026 22:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BFE26B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:16:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F010B1C2A99
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:59 +0000 (UTC)
X-FDA: 85265184438.16.2A8BFFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EBD1740002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PknU8s14;
	spf=pass (imf12.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPxyRVxUkD8Td+9QwNyvaWaSg+CRoePkY9b5UHxne8c=;
	b=zRVuSQjwpSrhPfNmm/MWVDf11HejhcT9/1vxN2wmcHzDTEPfikEiA2z+CXDjCntQXjNG1W
	+cxzTNVy6zKDGeVnNxqcI2XIRq8AH1CcGnmD3KkBIsBuNeH125xK7UNAYeXIqth20+dJku
	mmbDCRLQO/Mtwhs6skQ/QNq+N9z6+jU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648158;
	b=aglJgfoGMdn3cipkHdpk4gDRL+cYwrtUIP8fyhhmObEQ4+G/WsWa4k+7EmTAeyvD1gRxM4
	1dvrklqj+jZwgpt/LF88PbyeUZRKg6VX82LPzAJwwP6ADPDylTfKbvxIxpjGqniIxj/ta6
	mU2P2gqloMSZb4AL3mOlrA/tDo2qH6k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PknU8s14;
	spf=pass (imf12.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E0C1447A3;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E099C4AF1D;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=SWfJYfIhU0ceNaMeMrQOIvNiAm90QJeCPkReTr2kGwU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PknU8s14fcei++6tRffW0OFoKPk/CGnBTTfyjpYoKPuLanizHP0M/VxswI400k5hK
	 oj6jDSh6tmp61i6rDAG8aJmAbIdR55DNiMghsGP40Obf6eSnpD8aMDNWQsv7PoW0HE
	 3WxiXGoqypkXthROl8blpQy7OD1U/mGJuvM5E619+QjezE6GtJ+urkhHUnQNnUWWl+
	 v85dZP81grTIXfTJ/ryv+ZQUrfcIOvmGMZyInZGI5nf4q2/muUzO0lJ7CDsextcwCt
	 Lq2PZxQpim8DaMP6kZYSNgQauGIW8NyZ5kskFLocO45QlrAhbYhQG63RWFOblrahQB
	 6pcWU6lHJG+Bw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31115CA5FAE;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:15:53 +0800
Subject: [PATCH v3 03/11] rust: sync: arc: relax `ForeignOwnable` for
 `Arc<T>`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-tyr-ioctls-v3-3-26955fb111d5@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=1389;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=E65clxOu/qjNbqNDrRBBfaWHB/W/gvw7JStoVkgnAT4=;
 b=oJFnuxY+wm2TofFGyh+923zn8gVxU3T30QNNCDbfLO3AvpyY9RdvRRZu/O77US4y5OgA+x76B
 x9aJfoqpCD2BYz1U5apadhb5wm1qteXBA+TUC/bvVSXLzU6hF5tMD/d
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EBD1740002
X-Stat-Signature: bze546pomfzoo8e1cxreohh6e7wt1o5p
X-HE-Tag: 1790648157-675040
X-HE-Meta: U2FsdGVkX1+druYYM6VVNA0FY1hZSBvaZ/F6cVM4KyWPhWED1WsiNsQ/q8XH8AcT4ALs3WyPIdi9+cNHXemzRHe6dRtMfbDo/Axupylxdu3VM68I5vW3M5MHIUYMI1ZP+MF5o6eLeKahCGT0wTTOzccGPdpLijCB18J7+bLzXEE5kPp31uhX4HJTTUCNSKmhVb7lWUZxKOUPHV7wGE35LIGZM3E1Yztb+1dIRABDntrPnckqTyd6OQGI99S9syElu7+o2DNnoSjlQYzkz3d7tkwIzYGkAk+EnvvQYUsQrPL9clN0SWrM6BLf6RL3HnLpju2aZuM93SJxLDKs4ilSHzPSLENsc/NuUgDKl2FL71CJArf9FNZlKDrYmWncyGlXQWhDeiovfS5O8621sLdGiS9AQWEE2WO+opZcw1QhNxVz7IjFg75MkwX8TEZiDiUWvPgoTfIVDqTFZXca/pvz4SGl336DVIo3Vg1Ai4nIseBYcVl9VuawxbU5eGDn9N+ifuiv/L73utOLzPb6+bnEYh5IB0jtV5/Aq1cR3dEcbkcHFRSwYxFwk8imAdgt1VHw2j/hRr8swfnA5InANU21aHXD+O8qujqxl9omumAyUqoTTdL9liF0IpdF805QAT2ti6riHz+LUHd3+l+2Nz+UdeWV+V9CAjsS5EjSzOGKdJR7tyPAh+aaZZeNJNXqXWDYdeyaCrHtIc52YiNmIgg9bt8PDszLgT5jLlzP5ZUcaBARpobmJuI0xlZQVnEM09efn+wRKU2VsdC8c9eWIjqHTMz5HnNLE0bAtrio4xa85W+xyEp/8Y71YEDc6J23QUufEdrqS3jA6Fj3A/tr1PfogULx/aG0hwAYIJ/3q5DPHEa0jUYB7L+XnfmYrMFzRSPlOqSo/oZ2YmiNrLGxkLZcn/jSG+vQD4Zl34hUgQ44KZD9vqBz5Sv7zhEJWW0qkWYWzJK3Lt12d3F9ccrcCHc
 +sMpVXUK
 A+J9wrUXCLJY3uINoRlwCavC03GgWJzo3itczQD5GR2lNP3CTlXvwRGtumyqDMD23CAkoszAK6xd1KGgcYFPt/2BJm3qv4aAT3ROoQ0RB1zGnBQlcV3aRSESi8A1xegy8OIXU16LqC6grwqIpYBKwMYYs0kY3aRkQ49jMA3MnzBjds9Y1Rwd2aCHQrldo5hffWQw5ma85+/dUQRngiXeKko1q7VV2QiHMRdrqWZrYJ8AbtTIa1DRYfapn0VGeBtT5ME+welYxyY1uoh7Wz93JH9ZCRmkJIjNbDNiyZm8VcbaJaf/4hlTdoZ6jngFQZ8unVnsl1RgkBRXIzCVYQ0bELwlPTuz+GYIQHsBQ6zl2MRUl8GAkILa+k7YLnjNxK2TlyI10gGJ20NA00hFz7I3pvq/39UKPh+9YKtLQKhgPa+1ih1KPiK71X+8RgMDvWHRO3rrSpn9sDAqn1j+W6ue3UOQ7fJ/Xh78pqSbxP+tBN4YdCds7nKrhJCHCoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Drop the `'static` bound so that refcounted values borrowing from a
driver registration scope can be foreign-owned by the XArray
abstraction.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
---
 rust/kernel/sync/arc.rs | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 8ae0fe6f19ec0..9b582a815f888 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -363,11 +363,17 @@ pub fn into_unique_or_drop(this: Self) -> Option<Pin<UniqueArc<T>>> {
 
 // SAFETY: The pointer returned by `into_foreign` was originally allocated as an
 // `KBox<ArcInner<T>>`, so that type is what determines the alignment.
-unsafe impl<T: 'static> ForeignOwnable for Arc<T> {
+unsafe impl<T> ForeignOwnable for Arc<T> {
     const FOREIGN_ALIGN: usize = <KBox<ArcInner<T>> as ForeignOwnable>::FOREIGN_ALIGN;
 
-    type Borrowed<'a> = ArcBorrow<'a, T>;
-    type BorrowedMut<'a> = Self::Borrowed<'a>;
+    type Borrowed<'a>
+        = ArcBorrow<'a, T>
+    where
+        T: 'a;
+    type BorrowedMut<'a>
+        = Self::Borrowed<'a>
+    where
+        T: 'a;
 
     fn into_foreign(self) -> *mut c_void {
         ManuallyDrop::new(self).ptr.as_ptr().cast()

-- 
2.43.0



