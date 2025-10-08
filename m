Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B7CCCA472
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67338E001F; Wed,  8 Oct 2025 08:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19298E0002; Wed,  8 Oct 2025 08:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DE08E001F; Wed,  8 Oct 2025 08:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0E358E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:47:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7432859577
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:31 +0000 (UTC)
X-FDA: 83974923102.19.182A073
Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7CF1E8000B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=d94HbiTA;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.148 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759927649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zjv8cFRBo9Unx3PUTFt2Dg057u0swwLrQZWxNbSWj4=;
	b=BpalAoqo5s7Wt/t4OqNs8+sQQHxlkRrjxcEwg+9Wy92vd3LSBPGZZY3CruDPp9soA1d3h3
	lk7H4gUQey3NR99F0tcYl7msC3O8QcRLrJIouZEpyhKOVfmb3b+kN5dYS+zePSP8pRgv8O
	gTwpU+AOFJmXJ6yjn1Hm3wkE7ItKqIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759927649; a=rsa-sha256;
	cv=none;
	b=j4qg3W/0woqmikhQSe+G+k/Ecbn1vUqF49rJ0ffEkKdhT2walk8q7P2f477dtRdgu4U9qF
	7u/baxUjBvdxp7qnxDD1NZWmdZEI3bnP1F2MpmBhReHlQMfAOV63bHcAoI4jrEBSLl79Is
	m2bYvBH6DdzrG9tlMMlNqKwmVCcnFMY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=d94HbiTA;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.148 as permitted sender) smtp.mailfrom=work@onurozkan.dev
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1b:3715:0:640:1185:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id 1F57CC008F;
	Wed, 08 Oct 2025 15:47:28 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id LklD46OLveA0-F6jyaQdz;
	Wed, 08 Oct 2025 15:47:26 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=mail; t=1759927646;
	bh=9zjv8cFRBo9Unx3PUTFt2Dg057u0swwLrQZWxNbSWj4=;
	h=Cc:Message-ID:References:Date:In-Reply-To:Subject:To:From;
	b=d94HbiTA+/qglKjJNUP8UVu3bp8xKNT88f5lgUR+fkNWhAJlK+ztEZp8TWsToIzAw
	 MhBlPnbG3663GBUWrs07fyw2dKY3CHazNA7NRMOHgF/ci1zgL6+7VvLLhPLp2R4uVI
	 Iko7lWPUHDqcjZXLTjT99r3iXrE4YdTbi+G4E+kU=
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: rust-for-linux@vger.kernel.org
Cc: ojeda@kernel.org,
	alex.gaynor@gmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	linux-kernel@vger.kernel.org,
	acourbot@nvidia.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	corbet@lwn.net,
	lyude@redhat.com,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH v2 2/4] rust: xarray: abstract `xa_alloc`
Date: Wed,  8 Oct 2025 15:46:17 +0300
Message-ID: <20251008124619.3160-3-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008124619.3160-1-work@onurozkan.dev>
References: <20251008124619.3160-1-work@onurozkan.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CF1E8000B
X-Rspamd-Server: rspam02
X-Stat-Signature: xjdiphrc5ra1hi8drreodmmk6bkew361
X-HE-Tag: 1759927649-130551
X-HE-Meta: U2FsdGVkX1+5YeHPFNMy1zk1icUuu/hAmt+P1h1FRoDRVSX1xUQWJ5ck8IouZQvQRJ7rxc7gVXmuPuxqQZIapmBagIdlNs7KPQ3xxarE7AAlBeGVKzv7F/Z+x+2PzKmRzYVBMoLnz+RyN6/Y3+gJQdOmIn87BR3s3LXHn+Sq49W9DZSMDGMwYNBwtqH4DFWQaUE2maJ9tY3Qbfucxu91J3F9l5+EaSGUvllYqFs8EcrAb4hoVGSzF6+vMXflkG6OBBCLAlu8U5mjEgCruCE6AXjCBC6eLZqZGwkrZWt/4wDDbid7qq7NZ8gxyKFaPseHTdeiQ8/Vsmgf7Pd2eIWdOn48H1F1/UGqoxAhQ1yVi+v8IY7NdN8JB0K1PVgCX47BI5YNuwVsOpeBiThxi12IiFBSH/QqS7FOVJ7hdS05emik/Smv8jo7nh0BFydxOuERbWJy7InmUmR9jDUxjHHL766Um2mpUXK7YuPSbw9uDlyr7jkwk8YtzGYZSxSXG3MPAP6yBRxHVgelqcPlAu3YL3ltHI65bVUWwKJ0lrmHMhwhP4W2pVSk7LaI8ozja9eu1RYF3UIGHhPbKjU6ocRwSGlBUD2N0FUZ040v17ft4TZiCNG4UcN8nC+UTGG3VwHWO8JKmKbsixUzd4/WfecH6iLa0brM/PPy4KDOOxZIbhJozZLrRHl8bO783teBeh/vpwxAgV6sguaocwfDR8aBYcaTVwPwRZRUAQ3CA6V4RSXmz/HuIYBwby3IwtRpuc0VAPMWN8jOlLygDJqycUULNLmUhHBM4v/5njRPl7xdy4lBzmuMD8ymG/eN/sWeIAK0pwPe4Cntaa87eQHQbr7b4iYK822e5Nj8Jukf1vVoEZuMICE9aim7Wph2G88r3XJsOHPPWK7M0CYXHPqFVz72ZyQi/HRV/PtYI8Gk5W08CEs+uTx1zOFlPqBqnUGQ+Sm2FruZ5BK1yghA/gZyfEi
 aDC8wTtZ
 NNy9wjY3w3T6X0ryQWEB2aZcndzx0tTjFa07fRjm8ruf0lLBRUYVaFxujW4oUfB4iUsk+B+rG6ld/Xv0hH4lHTgblx18heGzksLhKw3ujKm+loNRzoaWnhnU1uZ0UIvzHhV6TWewemifm1hNN2tZRmxPXU9gNvTbHVI6GiIEr9uP2t+Ydx1LkZ5AjHFQiPEM/PYUo/fFWxHrCBfb1tGRqtTxWdchv0A2+5OkoNHq/aFNGVT4m/Piv8KxrxXYWADxiWT19v9p89R7+vdC/VEn49CUcWDzF9lqxmIIKwKsgu6dyi0owhH0n4GNX643tlE1fefDW8s9yD9mvX2i/lbbIzoE8c8FthtUiTlMLtxoYgupX4jNiszzUeL6BKNCm+MhsgZ10QeUKJKPJXWJlvn7SjdhM4QYSfJsoMDnoGVQVR1C8JSqAtUzzq9WcFDnRu0H1GdSpWVN//SUcdVPxSp7P9aJGa8dlCkrEuupI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implements `alloc` function to `XArray<T>` that wraps
`xa_alloc` safely, which will be used to generate the
auxiliary device IDs.

Resolves a task from the nova/core task list under the "XArray
bindings [XARR]" section in "Documentation/gpu/nova/core/todo.rst"
file.

Signed-off-by: Onur Özkan <work@onurozkan.dev>
---
 rust/kernel/xarray.rs | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 90e27cd5197e..0711ccf99fb4 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -10,7 +10,7 @@
     ffi::c_void,
     types::{ForeignOwnable, NotThreadSafe, Opaque},
 };
-use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
+use core::{iter, marker::PhantomData, ops::Range, pin::Pin, ptr::NonNull};
 use pin_init::{pin_data, pin_init, pinned_drop, PinInit};

 /// An array which efficiently maps sparse integer indices to owned objects.
@@ -268,6 +268,45 @@ pub fn store(
             Ok(unsafe { T::try_from_foreign(old) })
         }
     }
+
+    /// Allocates an empty slot within the given `limit` and stores `value` there.
+    ///
+    /// May drop the lock if needed to allocate memory, and then reacquire it afterwards.
+    ///
+    /// On success, returns the allocated index.
+    ///
+    /// On failure, returns the element which was attempted to be stored.
+    pub fn alloc(
+        &mut self,
+        limit: Range<u32>,
+        value: T,
+        gfp: alloc::Flags,
+    ) -> Result<u32, StoreError<T>> {
+        let new = value.into_foreign();
+        let mut id: u32 = 0;
+
+        let limit = bindings::xa_limit {
+            min: limit.start,
+            max: limit.end,
+        };
+
+        // SAFETY:
+        // - `self.xa.xa` is valid by the type invariant.
+        // - `new` came from `T::into_foreign`.
+        let ret =
+            unsafe { bindings::__xa_alloc(self.xa.xa.get(), &mut id, new, limit, gfp.as_raw()) };
+
+        if ret < 0 {
+            // SAFETY: `__xa_alloc` doesn't take ownership on error.
+            let value = unsafe { T::from_foreign(new) };
+            return Err(StoreError {
+                value,
+                error: Error::from_errno(ret),
+            });
+        }
+
+        Ok(id)
+    }
 }

 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
--
2.51.0


