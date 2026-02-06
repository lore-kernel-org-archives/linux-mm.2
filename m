Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A32EE6B60
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7FE6B0098; Fri,  6 Feb 2026 16:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9596B0099; Fri,  6 Feb 2026 16:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CCCE6B009B; Fri,  6 Feb 2026 16:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1A046B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:11:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D1B9C182D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:53 +0000 (UTC)
X-FDA: 84415278906.24.F9EA4EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id CD4F02000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhBEKlTs;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+oMqxkPsm+SeIqFusF5Rf52C4m7bRaa8kb5aIAwKdU=;
	b=mIZilsGNRNlMxZJOh+PShEx136YqfbQ2T8DeUfsHMWo0K5B89EJ1+Oo4RxoIr6FRJFHSlV
	Ej1/tyE1vkvlopKH/Goog4mNpdedArmoTJjPttCQ/Q0RcfgdF9tJQMAFanaOFHWVYCXxWB
	g0PdYlYLp1Uf71lOrbQOa0WMUhhNF4c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhBEKlTs;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412311; a=rsa-sha256;
	cv=none;
	b=A24wyKGNWlbj6DAmTfutbJSs/L6ukPqe/4kiOqlJBSeqSDrEoQ25BWR1Fpvwl45oJqJ82g
	ryJmrg5i0erMQyI7+GxWcPnitwY0LgxAD0HkLHui0CKZzlA6RWYLqege4iUNUVM95ke8av
	SaF6riLmMd96tyRxbz+keCv/bCCXQhY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49FC66014A;
	Fri,  6 Feb 2026 21:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7702FC116C6;
	Fri,  6 Feb 2026 21:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412311;
	bh=2aA6TsP5TqOXxamqOrEM+ulf/tg/RPrxh0tZsqKQ8Qk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rhBEKlTsP62RAZDNXL4f6dTWS2K126rDj/IyPLRJ9fZW85Dhc0DG7jYthxD5w0iMs
	 azv0CWMNz2OaTIjSVyKOPoZn6wHpdz8xmO5Tfm0uGZD+9Jkddc2azvX+jFgX0fJ1ap
	 DMaQ5S2sebc4qRDD7FAfwPSIzixaAwphXH27Otk7KqchRQ5LGWaB92agMNmjW2EnRS
	 xJXG7gzfAJdjKjVBiGs8Y9o2LgbJJyuEUN9BrA5aQY9U86ITgX7eTMKW4AfIqFLPEj
	 +EK6tFG44dEQhQPqjuADRRkbk3zMWlPylpJsQrOGn0M9dSzxBA8BrRl0KKh/3o8ypb
	 1GBrfia7yZKPA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:50 +0100
Subject: [PATCH v2 04/11] rust: xarray: add `XArrayState`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-4-91c41673fd30@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3142; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=2aA6TsP5TqOXxamqOrEM+ulf/tg/RPrxh0tZsqKQ8Qk=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljkR6yFU74Qctxwfi+Hjmm+uCS+oAhwJVObd
 03DdYekpUGJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY5AAKCRDhuBo+eShj
 d7NJEACUN4BBgh5y31PGzMdcKchA+Aw6rT5w2nYg1DwlVMsSRzL7BZOOsYX0BrXCfJtsmRg91dM
 dLzCLv7Ar7zwcI80iJnrAG8sr+wg5wtepKUfDrTMbSyi6vJp4u+XfwqB4QS8iP36nQTIZ/ostYU
 7xwkrXbTLtNr++3c+mo0tU1yUB9cFSYFHcfOR+KU4OI+OaV0agbPhkCur+W+yFgaE+yXzsJfuj+
 /faayPfcGoTSrap9G3p78GaKxMKDiYTSVko8qtgbqoBvamPr7ZAokSztOfM/wLhu7lJD2CMAN5H
 f6FfU4KMs+gZXuHR3iyhDOVBXqpW60wdbvE4+etEFbY7FkY4SAUpXtLdgRb4YwW2M3lOOMUgFzz
 H5jeeUQhUFkib5dWWmahTU7iCe8BMDctvKP/BaK0M9y0g5FdyW2OVS75nG57V6rO/jsMUeM4b2Y
 ew/cD84r8n7LV1J5W/A5oiiPHXbSKQ+fHIJNSWxZ/zh+TrdED5Moo1ul2gBXJKJ2kguc1+Yx2+0
 xVBGydN2BIb8KXmQbJr5gL1gSGnuuk0iJCKmDKYCW5baQhMbYwxTc4yXO4hNY548Xc+BepwqoH0
 +Ujvysi8N7EqQPhESEe2AHlSXKCrLA/HEUHWrtdJlujsGqNVdWiTk+ZSXyZPETCnTzfxXLHjaT2
 O0AcmXow/xyhDvA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: odytk1jgsh4zcgktdop47oho6z6q45kn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD4F02000E
X-HE-Tag: 1770412311-359616
X-HE-Meta: U2FsdGVkX19y2Mz9gl5qFW20GspCnPQ8sALWTkFdas8pOG78fZM4UMK5sgJnC3NEEpFRY8hBNfXo0SOhC5yyoynHq1yjya9o1RkOWrUTdy3OxBIObOFyo6oxhlzGBG68r7kGETHrcYm3D55Objub83JPs+7lZB8ZS1wxKTw9jP2DGe4+oi8J4PGiyhgY9GnUqbibtm0ldPleJa6mdzAc+VM/AUu/jAhStIsUvOQMniNf2nfCWPrkwEwOxaZfA+4lYMwPz1usMSi0xxyzsLvpyhVhtFBcAQYnYTSBUqxP1V1ouHA5YbZzWhQD0ZV/ujbWKHLcgafUaEt8PstjMY3KE09fMynSU0KRQ0qqDrOvG7h0zyCA85sBXhtYePU6yFuX1jcL/pQ7vh7dfnW4yY89SEY3n7AKz+m1bMgoi6KqFCtToJk+sM1GFHteD9OJkoaBaYQB/2s5vPgtnn8HTRzf86mdH/t8IGsO40dIOrvA9wg2potZFo8KK0he+3/0GboO36sjhtvoxPPXuGQ7gQQKSvx6lJTx6Pgz9jtIzmlS3NkLmLRY+WUnkyAlXe2JezwDLwT2w9T/Rs8IzeJWkqlqBCRAgfDnbYYmO7Zm9gxO+aqrMGqrLZfQLI2ZlSIQH3MTV2DkA0XJoCmJ+Qqc1MsBWRYPlkid3ueVdGtLcZUQoKRjgQLhB2frtIoKAZnLrdgMdqR0QY01e6Iq3H0MItgoPW+GvBmpEvv7oU2glDHpEP9quDinVPHk1DspNViKhtAYDhkgELe59ik8YG/W/DU7NuZfUwbJNL/U7J0OvA/hzga/bNcC6YEge8g40ZKOPlqWXe3KS4rtq2v35ljAixgDY2IaZpmJsmI2sR0ONw/ZfAncrgH35pXfVXFVPBVLXl7JYw6QAbOfZZfZ01AmfF94R0Thxwe0D1J2ct+ROP+ZjGp1gAXOwHr1GiCA43LwSZmtbe9DhKHxXFOrMTK+JKA
 zOSBKHmh
 UGb4rHNSNBTX7+fNmagwPP9ReGav5dQeM1pQNCa9I2N7u22NR5G8jHFat/+r92pWjU+nS3jbx4QDoc6f3b5adpZYIulQ8mQa4sgh9aJ2JiFQgo4Yx+BqebhED6NSYRip+3I2mZc5SAG0AKZjGFcEtWvwjeKvXoUpdKA7qkijvllWvpO6HY5N6le41EEzEggqNJV6bOMTWQPIc+nyHUvbUcGihWM/8YYuB3lGLXxHaoTaPPAbkTS0Hraexq8zN3aMmfG9YHqNbqOPC6Wrt5j1K8u/I9yxWI4UhpQjBOVITp0LZNyFR3WAYF6APZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add `XArrayState` as internal state for XArray iteration and entry
operations. This struct wraps the C `xa_state` structure and holds a
reference to a `Guard` to ensure exclusive access to the XArray for the
lifetime of the state object.

The `XAS_RESTART` constant is also exposed through the bindings helper
to properly initialize the `xa_node` field.

The struct and its constructor are marked with `#[expect(dead_code)]` as
there are no users yet. We will remove this annotation in a later patch.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/bindings/bindings_helper.h |  1 +
 rust/kernel/xarray.rs           | 41 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index a067038b4b422..58605c32e8102 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -117,6 +117,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
+const size_t RUST_CONST_HELPER_XAS_RESTART = (size_t)XAS_RESTART;
 
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 const vm_flags_t RUST_CONST_HELPER_VM_READ = VM_READ;
diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index ede48b5e1dba3..d1246ec114898 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -8,7 +8,10 @@
     iter,
     marker::PhantomData,
     pin::Pin,
-    ptr::NonNull, //
+    ptr::{
+        null_mut,
+        NonNull, //
+    },
 };
 use kernel::{
     alloc,
@@ -319,6 +322,42 @@ pub fn store(
     }
 }
 
+/// Internal state for XArray iteration and entry operations.
+///
+/// # Invariants
+///
+/// - `state` is always a valid `bindings::xa_state`.
+#[expect(dead_code)]
+pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
+    /// Holds a reference to the lock guard to ensure the lock is not dropped
+    /// while `Self` is live.
+    _access: PhantomData<&'b Guard<'a, T>>,
+    state: bindings::xa_state,
+}
+
+impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
+    #[expect(dead_code)]
+    fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
+        let ptr = access.xa.xa.get();
+        // INVARIANT: We initialize `self.state` to a valid value below.
+        Self {
+            _access: PhantomData,
+            state: bindings::xa_state {
+                xa: ptr,
+                xa_index: index,
+                xa_shift: 0,
+                xa_sibs: 0,
+                xa_offset: 0,
+                xa_pad: 0,
+                xa_node: bindings::XAS_RESTART as *mut bindings::xa_node,
+                xa_alloc: null_mut(),
+                xa_update: None,
+                xa_lru: null_mut(),
+            },
+        }
+    }
+}
+
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.
 unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
 

-- 
2.51.2



