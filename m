Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F457C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC176B0092; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338466B009D; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D4B6B009E; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03AE46B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C24FA01EF
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:18 +0000 (UTC)
X-FDA: 85187549076.24.442A1D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8ECC01C0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdyYYfo6;
	spf=pass (imf18.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPxyRVxUkD8Td+9QwNyvaWaSg+CRoePkY9b5UHxne8c=;
	b=vYQAO8j9yVkhBRCGX5LcowdYWZWOEYi0EK9uHgMMqAS2kUt88QAwVLObUH1mvGktisY42I
	PHR7FAqI2foIHTy35i9pNPqaTFGhnRKgJ3Noj7kGOnNfQ5jZ/t5XEgZs5EOEECx8DkFaBf
	0un+/bRxm8BEduooaAjSYTdjm9uEnpY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799696;
	b=40hqawxwkEWiaG2SeW55NKyzJBlDFxAkPbVv8n1NqsLWFTG/XYT12Hgh9t4TY8/q1KMOdx
	+DtARpgs7XRyGfAINnkNyXRbsETAkO8nkAp7Lr686PWO8zJt+KGeC3WIITlLerxJtyVjzH
	+OJQf8KtJ+aw8g5lwYBzUzFjKRpMm9U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdyYYfo6;
	spf=pass (imf18.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1AA343B83;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 882C9C2BD04;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799695;
	bh=SWfJYfIhU0ceNaMeMrQOIvNiAm90QJeCPkReTr2kGwU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gdyYYfo6ympMHjvgiFpwAKnU3kXVjM1uvnukbRGTsAPHYmyW8/1iVrbmboys2RKja
	 tBKJNCTHkhBEXhVpCpBADp/AV/sDgyK7HKFb5wbRqZ0kR+mNYzksc8e+I8BCiNxA6W
	 5euqlXCiqoc7AL0+RvVNNYY65DzBcDCJFasc9Vw5kgtMx+x7UiNVvNF1irLiE3Gk9u
	 oQ5LN72w36XgArE53hrlaRRV75wC7ScqSY6HbyngRCIlTq/FFnEsLucF/VkVacFk20
	 Iuohx+i+2D8YkLgbn9K5o9JKVS8YF+0DVBncNlgwjW1VXX2iI2sLTGvUO9+34gt5fV
	 Fqvk0lM7XAC9g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72702C79FA0;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 08 Sep 2026 00:47:50 +0800
Subject: [PATCH v2 3/9] rust: sync: arc: relax `ForeignOwnable` for
 `Arc<T>`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-tyr-ioctls-v2-3-88bea777df67@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=1389;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=E65clxOu/qjNbqNDrRBBfaWHB/W/gvw7JStoVkgnAT4=;
 b=MUGHhOu/L1W8PlCpFLL38urACrHixCRiftGKCn8Otv2NxdConIIXRvD1Ykvxj2WGQejyHWiFX
 Ekf59qcvlzkAOxJxuDCwj7VDvVlSMLlwndY/CSRCVJX9QHiM1yLd55k
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: 8iimgcyc1a34mp46cjiu14ktsu66ef76
X-Rspamd-Queue-Id: 8ECC01C0008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788799696-924042
X-HE-Meta: U2FsdGVkX18uZ5O6RCZh6PbRUqqiMOUANUIydvHngpcNHJ01R1/aBiUe5ozXmQqGubkjK/yaz3M0JuNzj6eXaUAQJiNizcST0zWi4DMl4uJZV5CQmZEG22NUQqa6MkQ2d+L1L26STpglvTqefw0PAei/qCu7aEuzLJkZKsdMMeVWOlvc2MKVxy3T6xtwcOvtcyZcqJY0a0XBEATtMN5pzxzBObcvbfDnAIFuFpxW4brKIOW7aiT5nXV+RuM5as1Mh+8AZ0wVsxOPTFrDHW/A3A0FGjt9L77eseOrnW1lx3WGv1uhzgg5tXy67oIvD+rnWPWq4t01Ithuea61RFCbjMhkw6OK2m28S4ynVy2HJlIBsDTgbYT9vJttOAWBOsNpYi29n/5TEqDmwjD9ZO4j7Rv9dMF2MPTxuj4nC8P8p/C1+OIdMJaWCuXX+wpSMDz+BJ1CWmyIMRO3JcFcS6E8vx34fI/+znoq/Cg0nwU0KZbqcUO1Tfr9V2VHV25qjQbDeeiHjwtvEyzAPmYWMLwwHY7N8Yp/XYTQ7Z3s1vsiZYkjBOnEfo03dOvJUbZ9IZHnyoslcMc61odyC12kvmmd46j5EC524nBOXvaxat3kvYzr3dtVq0bNCAT9C71IHp6uHwEs/ypX4nc05VRX8PEAgUghqg5hJ/kPYHXoCHluPlMa/byYtt95dYzhRViegE+Vi4q9HfBizE4fWx80Eog15Srj7IY5UnnB7DnDMnjbXoMdx8Vq4IeSuspxYVVXu9KQXyR+k/9omuxKtFys/G5FRIPPfUUQdLMgPwU9fcfFUL+Jj78dnquI3werYlgrZ1aRhDj9vVcSCl5xNsmn5yqMJ4p5ShVCoqXvBcA324uO1J7Ogg/rY743CbCR4K5eZqXUVmmpPqWgdW8c6rpQ0IPwqHYxzmd+uqmvaS6sxZTnprUonRsO0QB5YugPIz6XTCH0igzb2VkkI+vAnAKS5gg
 xFvAjDUk
 rtJ6n+SgkOBa3GicivGspIgRnMJp1vtEmtiYf7TJcX2JVxRrxNBipheBFKn0g4A2bSvB1X+keMcgDZA0lcfblscugIPJ9EO5XF+PZfqvzTIbxyWi4lZ3AYj0uYY93Tna4uOw5pYWZRvWXzn1oDOE61NKthEkUZzAJFZ5K6xJca+jpa055866O/9ivV1q/689y60z1I2CgqjLCvX3/CeuaWnsKOTY0CCnR1qLuOthAT8BmNWKNqit95rXFgZK7sRJJvlMpZyOIzal9z5SgHMz0AYpp8wv70OWftO8MQqvKP62JS+tmUYoXQN+j+cv43+3wW4nBNwg8VbeIoRPnPyHXvjpSLwzEV5LCpDZeck0Ul1/Yt582EaTWVk/51SPlxGM06MsXQUM6vbALCpQXoqo+oGLXoYaMRzkH8IdtrD5isgB6Vf7Mpg9Tc/wQCmggzyQrUMFsgJg/yLVfPcZbeoc801ds6cg5g7dxKNriGT1HcXXwZofO76UsorKXMQ==
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



