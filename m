Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A1FCD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981196B009F; Thu,  4 Jun 2026 16:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958A66B00A0; Thu,  4 Jun 2026 16:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895526B00A1; Thu,  4 Jun 2026 16:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 788D36B009F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:00:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40A6F161FFB
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:17 +0000 (UTC)
X-FDA: 84843296874.22.CEA9D43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 417E24001E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGPRnclD;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErazmYbt0dY2iWxeKQ4eTQoLenALnLYrFj4/sdzoSv8=;
	b=KY/1ukuUPziBtRzl7AlNN6cqERNrGYrLmyyxVSNnEaadvaBbFqh/CDpSWchWU544na3i3B
	9+8/5H7p5UUlkJpYd8T3Uy4xZKzih1ejcaSkuRP0M8rFZ1K4pTL/kUw5PnKtyzQbln+3Rs
	e8TXNtlpU/KW3wY12ufFMa1OD3wO2v0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGPRnclD;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603215;
	b=3LhvFiZoYQ0FZXF53hL53vgX04xBBuvUI9lFj3aChrhUMBFsgF3lQqlrm0cl8yNl+87DDC
	xDH1rQZpuUC/N6nWNyZ/91p3Wq3CW66Me5tsZr7tsI7STzmvZn1sBD3J6GM2OCd33Rcs3R
	uDhKNf0cZt9m+XQ8s/vlZk3HxG5s1ao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7862F43E9F;
	Thu,  4 Jun 2026 20:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4380D1F00893;
	Thu,  4 Jun 2026 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603214;
	bh=ErazmYbt0dY2iWxeKQ4eTQoLenALnLYrFj4/sdzoSv8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EGPRnclDRb7Z9n3MYzg/+aOk861bUXrEPXeCD0IpfKGvkZvGZJpWXXxv21qHrHTE6
	 Zfhc/lITsreP0PZ0Vw2F3dyoz0+3WzZCgzVRnRB/GQED2Mkf0XXhbrcA9di4hr/3P2
	 Ip6TkTrxUliNGkyuAJ1TxsrweGWcLHhQQeBnL8oolyYCxFJqi0yWxEaP8MTAulUebs
	 UPlWpxafvWN1CqGARcLZakFlWG5cODPk3HEa4NtDRbWBYnls5TEmURZX9W755QrO69
	 l8DoU2YSjP5mboEwABopMrXamnSmpTSOMcfoCJ0TeZYzQfctRnEC6YRukLyH4UtRzH
	 zG6K6Q36ZM81w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:07 +0200
Subject: [PATCH v4 01/11] rust: xarray: minor formatting fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-1-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
In-Reply-To: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Tamir Duberstein <tamird@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Daniel Gomez <da.gomez@samsung.com>, 
 "Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2328; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ZnsSmRIcKWyPnQt9XJSezr7E2APtrOKIkUlZBJgDeoc=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdjqik1u79zxxTS5iPXhIesPlF5+ES1kJPa6B
 cllYqDV22OJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY6gAKCRD6UCkIqsW9
 0Mm/D/44llvOJsB8w05qq4AFJIZ2dQ5QiIf7ylxkQxemH6eQEz6OmLBUQFpDQKj293/zgmGJrwH
 DHg2r5nYszcCQmqUN7AGK8n3XNql6jIXgVEf+z6Yn07CRb0mHnTuC3jDHlgP2ty1EiBkSyVJiYV
 HumYv9quQv3Y6JJ/rgVNrcWKFbjWYCoqvcc4TM23V0SdtWw8nUZ1g+FWKm8U86OAfuE5uWdUE3a
 QRc9Ez86w642m7/r+ZTQ2befa7Sb/Q5VpEYTLHCvF5B4Ts/AAAwrlneWFAWncbTK5yqm9mgXsi0
 ETbNTGD06G+Wh8U1zSoYLHwQGY4J7uw0YmYSKCwEzsktAHtk3JN+91suy7X1LArJ9Foy60W6Sdx
 b1SPv54GOLGFSnayzByQnpjj+j6DQxu29YHG8HTRxBM+d8RLSYRhj9/mnzWAS2G56krVuLnM59T
 LbOcC5PtvMAu8otev9wOVVlBqAxBkPSFgYaG59TaCs1EMTbNf9VM+X8Q1y5H/UiFkY5m0diHNWJ
 FeiQd+24c25yQu7WRrlF84lSJrDjsrjW+C4RTRXGI2sWkSJDCiP/sEqsmsSUOVm55gq6vONkeuk
 6bsx0I3/xAme5YJewuipS0ThYJUqdnStwsym6IMeijycAgbCr//UscgAsya0XZAe7Zokyf7h0gq
 Y3zuGVJR+u6FDEw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 417E24001E
X-Stat-Signature: io6cso3snrdod3tx78t8azyntxoitoze
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780603215-300455
X-HE-Meta: U2FsdGVkX19LN0MK7Ez6VZgnqpTtvbB/AcFJK6iB4eLERr6ZWIThr4Q2V+nM6hba2KUm+BSWrrKKLkPTBluEJKE15NJBxX31ZKCj3CqrOD03oiNpLmx7uJVVjufQYEw/txE3iZcXoiiLJMtFshnsXs9D0DLasOW83viZbAhiaVoU75sw7b6aHYchTPxSNDtGvau8moMf+eGckKEFQN9wVCgzmOUnPQUUbzccmj49bG5+vGy7k3s/+8MzozqrAKygxING+Q8hxElk7bnX3h0QemRmFiWVuuDQkEH/dDriyQgPX1G7N+nfCAD6qKoR9j7Sv6wFRg2A4UysA+3LtsLTTX/t2pjr6OiuJ9eqN74xlpAo7wYl+nzHdBYf8Z/6vrqtdJa9pThDYgu7gUnSoi0jH6FZ9+3OJ9WIst2xmcJYNe5YO/Ca0LVGoBqbP8irZN0nqmvi5ZMiRdPiffPTrcUy1OMtx2apza80eOjpcMkOA28ReneZ/wRZpvWk83+KJVhOaTvhCJZ8gmR7xsDXlS3/QHgM8iITmNntZ6Qads3cKR5g6FDnKXHdCZsODR/wlU6e3nEmignGSDGSzRJoM66eiH73uPbttz9lD8UUgFb72xxKQGZRK48AZHPuNVGDND3ejOK/NxsCPge6qlNpgR/wMxsdSVbISxuzj105OlmUpyRTCHRIKNPDxjM2qy49w5IqNEqcr4ZBjQdSsjDEoMX6ZMp30IlJk1w2vYjMB5s0+TSPLAyWYaZz0ozGACp2Z/90lZYCx5CWXHaZ+aj67qK2Y+7a3j+0+pvk9SooNWFV0s3vZtML9cLElTeO5CCphHgXhrfaljmozD5PE7lftQF/2ajhtpm7VlULRURIp+VxI1dtdk2aN38NBuuSj0hfqfLJfJzBSSq5vNuIxxCRzUFab4Oq2Iqy7hIAJ8sM4XPXK4fKdNj/pPA5iXr3G9TvyLuyFTpqvfCstUUZ+PINuIu
 /xw8TqiS
 D2BEFpbDhO1lrBLiFGWkQ7MK5eZte37n4ky0i418Y7COr2/0ukrnIStsO5ykhBG9XxPBcpFhX6TLgEzzn5cSUu2lj/cjeOTZXVlxvnCxbDEcFh9OMZUTVPm4slh5vITBQ86/LLpASVh0pFrWMrMLs4OmmOg/r2nrJgs+Sgbn08nd5a63ddtvWGsTErzkczE357A0SbKsxLEDPC9Zex0Ap1SkO7tq+cFX6iNQE1KqfsAKspgSXMnmMl04VbTrcxUJNVwFFzE7D+BY/jioyzlx7z3cgTKCkz1WZbzbrw9B7C+kxz0Mgm4R73ReYrcM4ZchIsSliKIcGaacZcBs81XDz1vUB6Vfd8+DiQBLI683s79GoQuY7MHXpYYfJUNoGyY0RCK+y+TFNsYwg16Yl0BNyjuDnwdJ2eveKVbW6fCjDxRltj7KpJz0h5m4pDIj8IsSp0dJW
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
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 46e5f43223fe..b80fb7a262d0 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -4,14 +4,33 @@
 //!
 //! C header: [`include/linux/xarray.h`](srctree/include/linux/xarray.h)
 
-use crate::{
-    alloc, bindings, build_assert,
-    error::{Error, Result},
+use core::{
+    iter,
+    marker::PhantomData,
+    pin::Pin,
+    ptr::NonNull, //
+};
+use kernel::{
+    alloc,
+    bindings,
+    build_assert, //
+    error::{
+        Error,
+        Result, //
+    },
     ffi::c_void,
-    types::{ForeignOwnable, NotThreadSafe, Opaque},
+    types::{
+        ForeignOwnable,
+        NotThreadSafe,
+        Opaque, //
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
@@ -44,7 +63,10 @@
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



