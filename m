Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A2EEE6B5E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF06E6B009D; Fri,  6 Feb 2026 16:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2376B009E; Fri,  6 Feb 2026 16:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1636B009F; Fri,  6 Feb 2026 16:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9AC6B009D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:12:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64EA0D5AD3
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:09 +0000 (UTC)
X-FDA: 84415279578.06.FF0CFAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 89C204000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q8788c6n;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t71Ku+BIWBO4d8AbhI1PVeEyur5fv3A4SddaTcFqxMk=;
	b=N+laE/kYKBZBVpj0hZrEKIHmlJAeq4moyIAlnfMB6111eL4m8AgPSFcgsjxjmh/Lsbe00x
	sPWX4LsHO1WuDcMBfHaNE0n/QhsWlR3PPYrNthOpk6K6eUh+Kf4LnSmoxyWdTmw0nkrI9r
	Y+vbiD673Y9HsJW9taL5b/ZgWGhFybg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q8788c6n;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412327; a=rsa-sha256;
	cv=none;
	b=y0u7Ph4GVxlqaS3dmkZ/G31urXYQAo2+Au48310S27Skv74tYDgeUogw1IRr7m1AWEmNow
	6QQMEBx1CmMvYOrUg+zGJ12MeCn0g6GPZzsZzOGR4dQ5IPu1oz0yWdwtse5WTzwap09/RS
	uSww+7R6gnN/1SZx9cFw9F93ZWjSLBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE6B041666;
	Fri,  6 Feb 2026 21:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12093C116C6;
	Fri,  6 Feb 2026 21:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412326;
	bh=IuZIeAbMbsdgaivN59tt1avMvbqBct88rIBvqOT1fR4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q8788c6nMKGPWcNP4b2+qR18xaW8Tr47gxoIdCzt/HQ9QNbgn02ZkIsy0whEUEEmL
	 XmDup8ohqes/6Akzn/liPi022+7BlzIdHCUWXUCRzeRggwKBi6PWbjPjyf83FCnvgx
	 Dc3si3XQg1oA+tuExMpV2rN1rYidd/xwAhMFpmLYyiCwPg7+VyWmT4Mwuoi1DjdKKl
	 ugkeoaesoLobvTrG781Mlulr03iYw6i2v6tHW1Wq6YqBhYahXKzQr/8b18DH+h+Rm3
	 jlsKHW1CajbJj/0Rd7TLRMRQTeJRhi9WHTWvyq6b7+RqspA+YeMLKYxWW4lVNpD4Fy
	 2kBzkmOC6PLNw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:47 +0100
Subject: [PATCH v2 01/11] rust: xarray: minor formatting fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-1-91c41673fd30@kernel.org>
References: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
In-Reply-To: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
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
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljiegWf9WDKjbFzObfttbuYLpKDIPlIEsoq3
 +CZ3kDLd7iJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY4gAKCRDhuBo+eShj
 d7ggD/9afE2x+SSzohkJkdplmI+/vDaHHfcxt51QBr6DjxAKEAc4JG2ELyc4yuQ+qLvuvo0T2+L
 84en77vsujKqRfv2lgNkQn53NetFo6HwnLLPyUPfSXIMRctQ8L4owf0BR3XzWyl1nV0rGGgBqys
 4Q5rHf4RYBK7pA5uPSUvgEuzD74vemtTci7M3aybBCI+B+Emjn2Rqd0wqb3qY3x9WD05TuASXDR
 rRnoqC/oypLNz+34t8kv4zoH/aCvZkLdCdkz93epIP1opOEJeuRodV/vuuS6dis4NoQ+YEW3z1M
 /F2vx0aSN8+GLpkW7v5HKffRdifom0swnJt4R+0VxsRn/bSJtkx4557rw7McULZno4EtbaGLDOI
 Y9JFTLiOiGIxdTnxywukAQVLyUdWR3mJkRvow8A/S+kDpqfPhuy8Psf8YpPdz5fxHviizOXO9+z
 7eQv2lfdyG6Y+qcO6m7LvJUVYUV/MzMrwdnjtpYIsbKhdxT1FhVqee5gcmR6EP0HTDETgERT7Fm
 xdYsKfdwk2LdW7xACOjrM6Qg5K+ZTHlFQyaoKW7Uqd9g8zB8+qvZhRFh3lvCr5uZoO7tk3IA8TU
 DBcXItr+O/028jur8j1bXS4P5VDLnPu2SVWl3UBicUc4HkQpp8wE82KB/ppYA5KSGngX+lRDa3m
 M8yx1mttJZac7bw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89C204000A
X-Stat-Signature: dwyxg3a1cp6xqx6ghc4ni8ogsqa4umo8
X-Rspam-User: 
X-HE-Tag: 1770412327-481302
X-HE-Meta: U2FsdGVkX1+P9N8gYFOATIfMxJ9zRje0sWexLj648z8wqg6LtdyK8EmasiKmIyj1eK8BwsCxTSAtnWftTZVyGeaSvj1ENddSyTSSIw3TFC9WGWVoQTdrXLufQ3PWvLr/V0l+gI+pnyzfHcEhz8In8b6qRpcWgeDo5Y1dBOqmPAUAqnzDB3U6v6sbnCGYfHOKyrxTSJpgnOADLPjBz+H2vHc4Y7hpnKpHl5fpy9fIboAedZRt5nlrkoSf9349Hsxi6zRcxOyPk9SeFdpnuthBMqQEPkgKM87bXZ9n6uMxuU3/h4L/cwH/wpKKGUoQ83vn49IAE5t2UjsDOWBwmJggO/+M/pNqaJp+zFi2ud6CeDQynXfm7FpvU99TZOK3W3wtJqTo9hdCTOQn3Zdm4Lxj5fec4UrLzyyCH2DOz179VJ6aZLjNrDwCm4iYfUfbVfkwRIV/EiaQ2E/YD1+Pb6wJH2kLBhIKXlRoW1MlTPkKjXszf/baGbivLGs5Evtvgkv4N6wIz2OjqrNQFfxjMAVAi3iYT81q4dBXQWTefIR8+rLDa8jDrPaUwE1wpE7p6CAtbTsliioDZVEGYDRk1OaB6+XFCSkNJ/q4jZQWsz7emAk4/qtT9vAd12OkQBzD5kOh/0RUSneQ4CuriMgNIbd8z1iK4hZW/Uum30Z2XMpd+W9BdbO8q0lel0OIGWqjb48iBSJq61bY/vEcZ+paTKZ64peP7cMtk1jxP78fsLThSjvVWgceTV69iZDC2NY1dWYxL6Ds2g7oKayFX6jwk/JasakAUxP1Vbb1R9SwLwZlJgeDKBa3GqIHn6ahKk9tZDr2dbCqmzBWL2oXd3kNEkpzX8wFyn3OBMT19z0kDxifQzB+HqUZzr9Wnui6sP0RBPPrgFSVXW2nqL9swr0WLqqyJKxMRaKXN504r+HkP32FYxohxbbWxE/y81jjlsu68UxxYq6Nf08emmkaupiT0ng
 vRrVkX+G
 07U82DmKhVTfpfQKx6ewJ+Jj+r0ZKyARq8xHiMpbpvtKORUP5d9+M1dtKZepNsvxW67B9NfoEDxSair64fireGjfHMH/+7MnSeP5eC1H/BxLrBvcSN8PPkT/wbicBzKqWo2f1MBb3+BbAiMacKjRtJiyPu5o8Ocj/QT7bkJrlF3ZsICf+ON1gDy5UWv9d8XwcdxPJdcSDcbfWMHwE9Fuj/vFJO/h9juAZOIBabAuA99chyA0WW7KoxKvqHxRamvHHtA0VauqK/ZD+QWEYvvSu3Tz8/tEG8shWoGKxKDeIr6E+d8+lLU0CicNwvB37h1i95dgvwNHQPvbyXTRyMdsRua5yxg1TIeU6ewU76oWM01dUvXDJYuVM0wq+1ttDPaMqKTqqjEa3LSc7h8irc5Grj7RXUg==
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



