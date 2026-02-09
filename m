Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF474E81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 334806B0092; Mon,  9 Feb 2026 09:38:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3162B6B0093; Mon,  9 Feb 2026 09:38:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218836B0095; Mon,  9 Feb 2026 09:38:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1286B6B0092
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:38:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B729C1A019F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:38:49 +0000 (UTC)
X-FDA: 84425174778.02.EDB4751
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CB86F10000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:38:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ej84H0zM;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t71Ku+BIWBO4d8AbhI1PVeEyur5fv3A4SddaTcFqxMk=;
	b=eC0tA1yVJjl1sGRpjpDaFxwCkb+5EvLrUj/0nnW2ZtbecYncPlJJqWpzU239Hy3541NUWw
	22Ot/Kztv1gaYz1eRn9EiVtwv0KVmA+YRePUPkL+Qwj2S5enaFWiZMlv1mQ0uuDTO4cuiC
	GMY8GWefiLRp8IVqqrgO/YG3u0uQ10I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ej84H0zM;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647928; a=rsa-sha256;
	cv=none;
	b=dNUfNc/xSAlbzCUHFwDP2ezHdF44bFs1rGlp8JTfv2wn5sNd/9L4ODJuVUfARMpiWKeI8W
	Kggc38B1vxziSHb/AYvBwQ4EjQWgFQoTKmx7S9RpkE6wEX6D4ul07/JAur2g89aTv/F1lH
	mFR8Aejz8u+y2fjOaiDOEiGsTeDLxME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 086F644221;
	Mon,  9 Feb 2026 14:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7670FC19424;
	Mon,  9 Feb 2026 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647926;
	bh=IuZIeAbMbsdgaivN59tt1avMvbqBct88rIBvqOT1fR4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ej84H0zMEMGgPiMbNYWOo0DChrVkdP7DvC+nXkl3vvKX71T8AxtfNA8lGZqiX6vds
	 ReWeu7Hg0qUhCJFGdLXVHD9eO5jE9c7j1PvVrr5CrhkIxkBXm+ih5ylQ4gTq6q6/QO
	 RgERqiHV4Hn+XmdjDD0XOQaE5lDpmtDdKKt/ILzpzZWgjewqfRk3aC2qJI12LDzaeZ
	 0/OmXxf2Y5tE3x4xbZ6Thjw7e65CpneFW0dAuyZn9E9/z2PXQVQVb5Tf8QPshgs3OM
	 Pewd8FijlCH473aXx+2SQagSCXaE8Qxqw++NSgpHygGjUmYGDVeNqEY521s68ChpUg
	 JdHOEq/YOHbPw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:06 +0100
Subject: [PATCH v3 01/12] rust: xarray: minor formatting fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-1-f777c65b8ae2@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2161; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=IuZIeAbMbsdgaivN59tt1avMvbqBct88rIBvqOT1fR4=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFVZvzAtSDsr+CZ/ZQXchk3O+6YaG5edPjg5
 +kyPR0aS+6JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxVQAKCRDhuBo+eShj
 d2b7D/9i4AnYsinT630ZGFRy/Kh8bYrxUBt/LUmTe30OOzGERcX8Ib50IC1qO3zs69GiuFbqRFi
 9QiIaBN/0HodwyMFQAtubXEGX8gOm5kXkl+4cMPkQLDIJ2oKaL2TfPMtVcECwU260gOp4t5u9Jw
 LUDhX8V8RR/W1v8ca7+hnqjwauXgTZkNy3fquLEDQwM9tIt+jLCxljAbiTJeaGbOSg/Qp4fse31
 sgOgNzjJxhYqbSM0oAAPh0okko/NI9FXP5RazyAA3wSwVMu7ep7SUm9p6uVdDQXS8rYb1AGX8qd
 iZwB+5mmnE5GBrg0wGnWtWYuyX93FdjL85boyY3seBWIrgs4mHT3v6/NGDXxe+ftwWFruGucANT
 fNaymZGF+JgIawTniS/2g+uEa6c5G4qFNtuIQhWp5cawKpGEgF9r9OcfR2XMzcXugW1kdYv3bmn
 xf8gevt43sKknTy6JjKRi+wAkSo796bG5FV2k5r+lQs6C31hooZ7qVUNP7c+F8753wWcd5UGejX
 RKwmplbzFCh6mou5NQBraIYiSTy66YyxqLYro9HjYzE9FqPQ9bRCU5QXObA2Mre4dNT6YWILRsu
 FM0tWtdOIZOuDlL0lOmr+6DUXLf9OjO7Aa9xL8S8Km8QU4O92D0C11RM3ffiNhY436oiI5sIOfP
 301iZwvcnhfZaOw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: CB86F10000A
X-Rspamd-Server: rspam07
X-Stat-Signature: do8f39c53kfeoof8g7yicxxof435gh9t
X-HE-Tag: 1770647927-570517
X-HE-Meta: U2FsdGVkX1/r/UP4yCgUI414GX9TustkSsV7s8Y3JZ8uZ21F8BHR+dmFcpOFoNKJZntOjFOlPvlPnhwztS6aPRVk5a/9k63nL6PP6990lvnMyK1S75IYGdFuAfwGTRwxgz+05h2fMy0nZXUWK9fojCm8sHET3/5r1uLdt6CzOZITmaXv/AHhodgvKhe1Jh5Tqe9XEAyennaAzg2JQibcmCb+h7dm0l3002b7Zuyg3g8+bhsIhMKfK2pOYWGuX5t1SgFeZnJ7CzsbEMl5Aq/7+zaZEvO/sK1sfIAcGzPIXTSUtFLCVrf/7GKRYgoNa1zF7d29MN28V/7qPDLufO+DEIOJAoP2cnEYlcE577utjRjwxIISPc4Wi+qP5cpalZn8mxgzpfpN3wQPIs4thTdApQww9frBkg39rqrkW0qkikI8T98VFEvQiax+p9I5iujNSNYbFa3pWQMq+glvhJSpju9RrHG7IAhJ+ZrYW9J26R8yXDI4UMu0Bg7limkH5IJHCaI82CzO2KYdjnxJnMDUQvR6A5XGYp8JBu7J7v8sG0yqv/fU44F/brI+vi8PCunhs2l9aa140SWsjXQrAwBLQL1TVFFv3EwVyhJ8tTz+B83FNY51zSgstlt3a2XPp4EHOMdBvB6LfRNlwUj3baW1aFv9Kvg2NzSYQMAAbCSwIJw5i5Nz8X3Nc9YuTu8Sy5u/wylhZcOIhQzWKfY2NzPo94VnHDTdQn0Z5rxQOmEgaN7973AbFU3p045Vb+xKDxHkwOmVAMrgqpCv/p9k4G5bhQF/NiBSvZuhJHE23hvO+7Ryn4hRQJUYD5sTjGQ+7t5cZbbod6VVTxIjmEB7ZossJelY3A8G6W7PFtQAGU+6MRuogfhriD0pmzV8qpYQr+uZE7Y23IbsgELwPmH90f4TWhtgqCDdZ3glpbcBqV5PdMfd4VeMae96STtfBvJPknvTGDoZtkXt6aSnMKyTKKz
 f0VKumj/
 wy/9vOccfhJdnMWsG3x2EQXS5EFwU6ewGV4V6Glsuael9JJNSTPO9y4xXu2S0Jfqc4rv0CMLq/CNBVUZ1qpUrPngEZMJMGu8pLO9Ys8PoFNFGLwbZ9XjaulMOUmq8yKTeSY7rSUkx+Ino6yQlWoiceh/5U+ZVayChV1efPy45g1yjMmFTxBLPfcakSTf3nZL7vFgEppNm3VUIwu1QaAY2TAf23RBvzjiri0zJvlTrq+HoUndQeoJt6vySUJRyNEikxJIxyiRwphgGYdvAcvj/qsleTpqWjAtXn6iALKbZFNAkhTd1ZREP09liHs41KvfOUNXPA5XrRwpyuNiszNzru3Si2SyqB7DDlGztdv9j/XkKmJ9FwK9ui5dIaB8zvm1GXMjkm58rWiELeXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index a49d6db288458..88625c9abf4ef 100644
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



