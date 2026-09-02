Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31393C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD946B00B0; Wed,  2 Sep 2026 09:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E786B00B3; Wed,  2 Sep 2026 09:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4046B00B4; Wed,  2 Sep 2026 09:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8F916B00B0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:28:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79CBB1C0035
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:38 +0000 (UTC)
X-FDA: 85168901916.26.D5547C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 92F9EA0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lm0rohuP;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355716;
	b=PPLAqSeIHhpq87N7H9pRVASUCWeaXZ0x+V5Jfn8RSs8cBAJeG0ifEL2+wSjeg5ieDsFiOz
	MFZfwYhU2kHDf77PJGqdLwd/0O07a3PblIsFQUm5ujIR4fOTZHaGq1OE0gDnbEtC6Mkesm
	bR2FJyN0gcb6X2rgLZ67tc+rQCKbiL8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lm0rohuP;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dd8siENsqtHhQzXPZF0LKxm97fALr2t5Pd26+e10O2o=;
	b=JhE+29EYjr8GC7F2fvbpIuLUJjNmS5XGN6xHvjqlcqlfCK4sGFDrNSTCT7ggHp5oR6aVDK
	BscTPdn45+vFQwu2ded2zmSPW3VRwKWwjB8bZdwXbnW0LLOxFawI6wsB7pN2W0kz6XiJzQ
	HsHiprm1c8RffYvbTct1L4l83XMSUwQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE0ED43C58;
	Wed,  2 Sep 2026 13:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F4C1F000E9;
	Wed,  2 Sep 2026 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355715;
	bh=dd8siENsqtHhQzXPZF0LKxm97fALr2t5Pd26+e10O2o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Lm0rohuP6ISavxKdLUcodpGsLZ35LIfEfFgviN75v83FXuw7EgygD65gM6GLUyGZY
	 gDUftNOffZpkrhrXf4H0OLW7BoSl4QFXeuLj+M3LhJ+ZwIeQvNKdj6pgNPN7GBgZBX
	 FxiHHsWHlUfTuVSUyMly7Z/1mSWzTOFXHqIYSQJr2rnEa3W3VHxf7OB90QKnZU06y1
	 lXKYJtPkdUJ9yS6Vkaz+NCBaLnQ6ov27PGmV6JrJU792vLc8lTQEnwEJIHiySCHAhB
	 lrMc05SplsUftNtFpG7F8+Xk4UOgquQKVu+NPvf3jQho1uRyYd0cmtVRnNRksN4Ci0
	 5zW+xzYq4enxQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:25:57 +0200
Subject: [PATCH v5 01/12] rust: xarray: minor formatting fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-1-d18adae40708@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
In-Reply-To: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Daniel Gomez <da.gomez@samsung.com>, 
 "Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2371; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=+omDfc9TL/XAqCElB1ECov07Wz53Bjd9L1vrszIACpU=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQawZH0SGA2p5ke/OiKg/3VhhXiRaJhAB+XD
 XruU96yNTiJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkGgAKCRD6UCkIqsW9
 0P50D/4iu74xgFGoPRqYXhC28GSw5li89gEWBMELQwbtd37y7DiKm4hsVD/JbvDhAySxNOPcKhY
 3eKCjD3RcaZfmpBH71/DViwRdJ8tlHt8tTqzlA3ovdM9ck6v7Yfel55OaXcRTHm54+H7BXQSBnD
 5yMll5okuX3iDijeDKXWdrxUWoJl7hBUEjKK8vybks+uuNFVczRVeXkKwqyT3CyUrHVLn1V4KMP
 RdDBJFxj6OwrIZsiNfcMCudWMQUJG/onFXCx3U68Z+ehIkOob7fgN/VOcJNn2t965Y7sYPUMOoN
 O9//Evx9jynx2ZuRBiF/1UmgahJee8SFUjc9m14llAhhIO+M1PeX6z6hJQJqaldgm9Qdy6jqndD
 OxCyUPALpVpUdvb9XXFJNcxofJxB0BY687RxgRgEu0WztaPZ76QcnNawY2dW0wjdQQhHaHBmrnW
 dWi0dhVHd1pW2zd5mJInLzyJm598EsjCYyAHyRhx0aSmDEhiob9gW7Pwa9K5cGqIOkNu/+2ivLD
 nb3iy7mqO82EfMZUcRabMDSpPI4zLGis+bCLVosrvetRa73KwyXeS9ZIjr4ohalgkD6jn8nnpXR
 O6xbyhDUhDXsje6gCw634mB56nB51QY0Kij2FWVCTRI7wjuNo4UDQtNZJRRWye+JH6AroE8oK/n
 lp4H2sXM7jXm+Mg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Stat-Signature: rhaaedjm96ragwunrokwewyc6tuizwef
X-Rspamd-Queue-Id: 92F9EA0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788355716-443545
X-HE-Meta: U2FsdGVkX18gVsCO2JEwrUgVvhi/AQkL2ArIkacWckqqcSw0YqW/9KINHnKKv8BjctKH8NXc4Yw6pHVcxUw4gYO7azkZHI1h2gFoWGHU4poiwZrrW3+UyRDWrjWpEoCKRQncIq1OnYSrCUiWPSKQFiTyXuC/IKQuup941Ius725BJYYTwI0b7bRn6GS2Q4x6pgDTpCF87pbIvmYzlKI3GwvxhmSL8yp+XYB1zriqiJOo2eu7Q0IlIkrlbSSdWAQGmH+igHv75c6vipYvQD8mslPcUSgNQS5vja83RTZ2kWkJZcyY3qUPkTaV1r2IdTY4r/3bxOZ9QYO62OcwKpezWrKRbIizTqq0gBaB5kP47rNWjBj6LvNCc2ItNCAVUVJoiCUZTEkmYun8CJGtG0FO4os9/4J8C0tblaE1Fjn6EhObboSJcT+LCElW8cXtK8DvqGjPJhE7ve7BN9xXMwKvpuosI7JpfK2h8NEFvJRA8cuIIRIIG8kxyC2gm1T4sRD8lUtSOh6S4I/UdgweNRXjLt2Bte+bJp/KYEzzuSfzNRy0z6RR47LrrLMd+NKlTjTbWe+RWUeM9toLW4ulWZkxVEoTeCfj3c1wqdtNKJSnUOK7NncDP3063+0MexBUBSMkezfjzOJARhb7bs7TBsHfC5FE4TlA4GlBBiyHQwM/hPtC6nF4pEsNTgjdVKTj87nzjcwGJdIfHywGHpd5vnCbDhmxx9kjAz/6olxdtGbQGQPr+lL6jr/44cN25JDisxO86RM7tSxo7Osthlx9ApuaKBn4TUKcpP73cVXcDPTzgNmf0XN4pDG8JUDGT57BhQgDOSlTFTAh9+HGCRPyxqvqt5x86cTpoKuROmWHax5vbiE7uniNTRC3KLA6etxM87o6wlOs2taRCWKnLvVbr1mCCtZL/AVbXve4zPhklDszagQCJ2+sqhNUcwntIysKtgAYmdHwiotnIc4B5TU9imz
 phr1Y5CK
 iSZzAe+Twhd3Nw3sjfBYr2q1eJpX79hlc3kv8MjbALioOMt/ZyhiHUIsvQ4m4iEweWqwJ79BmkIR2yxNHL+2mm4ma8zLu94iuJD5p+daO1Ots+K/7MOfIxJHEuEutGLt4bj+ble/LZ55zlxXkPWkFzHKr2x2afSElXKfQvl63agnipoSmJScFSgDL+4hBfu75SCLCcwnQTBd7J9H85sN/cylWY0gd9cbJt8tD3+qvQy3gFGcHsdzhdWlNcDXvp8/h0Mx+Z1TZQ/+9wbt/8P/v/QGpShVdHqlSljbcoi7xFnGdLO+bZ7yFfRVxREU+MANVmNNWArB/KLfjoHVKrFEp3Jf5NovMr/dNUIxcGvPPoIQbY0l2Ds2Vu3bol5zcU1asyQ7AikyJjilr31lc1QTmw1rtfTVPByILfyu+HEmeYTv18rayzaebp6UX9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix formatting in xarray module to comply with kernel coding
guidelines:

- Update use clauses to use vertical layout with each import on its
  own line.
- Add trailing empty comments to preserve formatting and prevent
  rustfmt from collapsing imports.
- Break long assert_eq! statement in documentation across multiple
  lines for better readability.

Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Tamir Duberstein <tamird@gmail.com>
Acked-by: Tamir Duberstein <tamird@gmail.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 987c9c0c21989..02f93ae1f92de 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -4,20 +4,33 @@
 //!
 //! C header: [`include/linux/xarray.h`](srctree/include/linux/xarray.h)
 
-use crate::{
+use core::{
+    iter,
+    marker::PhantomData,
+    pin::Pin,
+    ptr::NonNull, //
+};
+use kernel::{
     alloc,
     bindings,
-    build_assert::build_assert,
-    error::{Error, Result},
+    build_assert::build_assert, //
+    error::{
+        Error,
+        Result, //
+    },
     ffi::c_void,
     types::{
         ForeignOwnable,
         NotThreadSafe,
         Opaque, //
-    }, //
+    },
+};
+use pin_init::{
+    pin_data,
+    pin_init,
+    pinned_drop,
+    PinInit, //
 };
-use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
-use pin_init::{pin_data, pin_init, pinned_drop, PinInit};
 
 /// An array which efficiently maps sparse integer indices to owned objects.
 ///
@@ -50,7 +63,10 @@
 /// *guard.get_mut(0).unwrap() = 0xffff;
 /// assert_eq!(guard.get(0).copied(), Some(0xffff));
 ///
-/// assert_eq!(guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(), Some(0xffff));
+/// assert_eq!(
+///     guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(),
+///     Some(0xffff)
+/// );
 /// assert_eq!(guard.get(0).copied(), Some(0xbeef));
 ///
 /// guard.remove(0);

-- 
2.51.2



