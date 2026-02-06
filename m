Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71277EE6B5E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DACAF6B0089; Fri,  6 Feb 2026 16:12:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D777E6B00AC; Fri,  6 Feb 2026 16:12:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5F296B0089; Fri,  6 Feb 2026 16:12:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF1D86B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:12:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 463D35835A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:30 +0000 (UTC)
X-FDA: 84415280460.22.4770FAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 97FF64000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bE2lwnoT;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3XVaggNegpbwtq4LxsziVuwVfQ305FsRMMb3sMulqE=;
	b=kEpbqlh1SsgGS4f674mT4rWs7/upJ0oKEwZ5DrGTCVlz+Uubf4aNzGP2DHUADJF2O+tToZ
	s/nvvYmfkAkXnm80QbVaOtNdS2/7v0M4T+atbaEo9lUghHNM5XxUBpZFv4lBCVcrXLOWxs
	n4QL/gKxM0uVATFYlZIEVs8fhvgMUX0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bE2lwnoT;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412348; a=rsa-sha256;
	cv=none;
	b=FMFAgqQIQk0XWLgMe6ygAU48k4bB1lzxsjQb4o94EtPnpST7xpFWVUZNBESxkjEuHN106A
	AAva06JbTyiragmRIeCNCzZ4lB92+y/KxfF8pMkHFI0uaDqJmHJVzEgGkcOXVh2VKT5PqW
	2PbqUPmB4XnkhsCfXbgy3cjO3omk60w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E6A1601D0;
	Fri,  6 Feb 2026 21:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7CFC116C6;
	Fri,  6 Feb 2026 21:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412347;
	bh=hPUvMpxg3yU6YJ5+chgN6zUpPTceUM2JTPt9rO+kJpw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bE2lwnoTbUhX6wRjb9J+cLBcsVr5Jv5E5IbPpP5LHrrkAc3M9EkTMS6jB/oQpYagy
	 YW2PB1LY+7am5q+4DhB0AuNgSvbaxVQwZAGKTGVftSGBt0gHlJLYZyuqzch5Tgxs7M
	 YaLqwJekVNxJi2Ugs/FuuDtJfNi1JizIPESSS39whpoJXwRPo8P/xZpUVdHtnn2FZb
	 Nhog1+pxGIwx7ps3QbBat5j0m+nInoyzc/TCm4Nk3dStvUeuJ/4XHHmdeIRbaQnSWm
	 UtEVJsG+AKVuG5q68oMhic3BrmvqiPXgs4WS8so8WGbFaMmQ6VfT4c+LNdM70YDA8x
	 3JHAi6obCEqNg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:51 +0100
Subject: [PATCH v2 05/11] rust: xarray: use `xas_load` instead of `xa_load`
 in `Guard::load`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-5-91c41673fd30@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2487; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=hPUvMpxg3yU6YJ5+chgN6zUpPTceUM2JTPt9rO+kJpw=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljlPuwNO4ue3fT31Waz1i4XhwL+yr2R/wlfG
 z2Vk0o95fWJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY5QAKCRDhuBo+eShj
 dwFgEADGYbdE3AJj4qJmyXhExgAWxEZVRa0PBezxw0lLQ3YNuSBS4sxStLzhx/kxcGOxx+p2tYn
 IYi/BOCeUrZXx2NpOKuSSNE+THWW3FXR1Z95QQumYY/aYmIjLUwpGO8MMxS+rtgMrCaE8nZ2pPI
 5AYF8cw8Txef2zi5Cc6ugLnlHlYwSBOUm5uYQm8DcrbxLftoHirfdz4Ku8ar2FnmKCwAx2r/O/C
 wkNn9Y9N6q2zBzdMXNqLyK96tb1mGO3oX/eiY1eM3+prUfrYMaL/+lT4utWZnxN7ygFlpTY3dj3
 OIcAJWPllgGwoORsgGZz+vXaz6um0G7PD8VP04tUP7M4y0r7ujgc9ndcWfEhnV/u4DRKliix4Qf
 dHbK8iN7aszFO4to8BhY69mvUCf+ewQ6qVdG8TcLI3HeuvV4YPqxZyQrStpMDw1MXz7I2DOMBO7
 jDE3s+DtInSr/DbxUAakU+uOjEBw/tJZYFyKN5EEK31lbHTSMsqzBe7SbPP7Ss1S5mskwzvz1uj
 RzuzsmJALis/JfpgSJDha6AY97Oxmf1vwcZbEGrUAeOQIndg//9njSu/1m7cNZrkhncaW9OTRlP
 oUWYzmGq+Hz1ZyP7XM6nGGoO0jVKz2PLMRrIgd3PuxtvF6uANoiClQHHaPXFhrEfnhhxCRN3M3p
 f/4hPVU3lzkg8cA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: wd911zgr194grkrcixz3iztjhszn1q91
X-Rspamd-Queue-Id: 97FF64000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770412348-341894
X-HE-Meta: U2FsdGVkX1+Vw0eTnX51YacAKQ7d4xZFWawgPFkkpLVYJLT6oILBwdZSthbNduLVB5hE+Q3h2CmXSBS4AJDB86JIONXpw1PfKwlWftaTEGV1T1aqC2USV3xWJWjtL7OFyE2RnnXmlqE93R4oNGN0RIGcfUa2+5g2z3S6avpH+kZAMtb8pc5FDunO+tmuMreN6tmkxPr2p/0BJkBWGO+n8l0JHF71t34WoaV15L227BgGumamMUbbEAIKZYvpnucmKjEt8pfbT8vUipGrjJUYIGjrujLO4bgYXrsHhI6CcA0sJuryeS45eFXszdmsoA6WMVfuTkfhoLPalzVXRIhy8ZLoXgtTZnYjOZYkTNMtRzWKsP52TuJOgdqq3evN8NSje6f5aXwAoLoDO93o28LkNA3HwHlVAgKXbTzLn2q/81X5mH5e/LYSjAFuf0Eyee/ra+3bbtf4q7xkdbd52NeMnpbiteFmDPH+6Jk9nyeOON1Lyo2S79zO14jpwhLPvJb3FYFb60k7qpmFaOF/o14FfJYIY3GEK6uQkr96qF26WXDVRuIYi02b4FmMUsMKolJwkfbcSNP/X8DtpJNcDvqmoBz032XslxFUOIj4x1ysuB9riOabLnH4qf+i4XH89MXJh/ql1iFk63fJptvS21pth/LpbRloNg0kYG2R6haQWRq0Xp19Ky7L04Hqm2KjRa4mC6aeaS+olcmwxlQV91+fuPuBolAdOaYA9HVm439ATiMQ8n2S2oz9y0JlezISaNOGlV7T8789JjULnO1Faamermk0RY6bc/qBgyHb10LSm5L6gNra9uisFhgDya0B9LmnEdGSMqdndV2vAvwrEAgs3LpKg9WxUxEYyRyiNnYXw7CDM9oiUjgX1ADWoyqskyMd52SrBKbqarII+Lsv+NQYkmUdDkXDitrNWdsM+1xBcnskue0qYGr0Vt8Wd/6hRYuiBr7VHYMQ8P8x3BDIXQ7
 nlsPlro2
 9PBJ/WygnOV3ys8YrKFODDg2QV9w9kdnCqxYovtVCXWTyGfzZGaPuGX+Ao/Sne0B1AZOWIOITfb7WGhekx9jIP/JZqIYazW88RTmH5Isj0ovrXwrZzIeWvzsTEcxZtceJkI/F/QIUTKglUY21VsTJReS2hAAgtAQTWN7od1bcPjxbFn8QlXKvsQS3FQ3ZU5IhwnXfzU9CWwQnzXGfmFSIO3Bsdrp8sTOyb+SeHN5JNXY+MrLJgd3bnYEnZyp5ad/WZ2v65q1rUAbo2T8+IJ4tIrmdd1OxsDSaChOU6rtBeXo/NVxRUQZUQ6CdkNNFWOR6hX4V1JmgYH0Cq8xIWk1fY1PwI1aO8EP04Xhr1yUncUUEqjw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the call to `xa_load` with `xas_load` in `Guard::load`. The
`xa_load` function takes the RCU lock internally, which we do not need,
since the `Guard` already holds an exclusive lock on the `XArray`. The
`xas_load` function operates on `xa_state` and assumes the required locks
are already held.

This change also removes the `#[expect(dead_code)]` annotation from
`XArrayState` and its constructor, as they are now in use.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index d1246ec114898..eadddafb180ec 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -215,10 +215,8 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
     where
         F: FnOnce(NonNull<c_void>) -> U,
     {
-        // SAFETY: `self.xa.xa` is always valid by the type invariant.
-        let ptr = unsafe { bindings::xa_load(self.xa.xa.get(), index) };
-        let ptr = NonNull::new(ptr.cast())?;
-        Some(f(ptr))
+        let mut state = XArrayState::new(self, index);
+        Some(f(state.load()?))
     }
 
     /// Checks if the XArray contains an element at the specified index.
@@ -327,7 +325,6 @@ pub fn store(
 /// # Invariants
 ///
 /// - `state` is always a valid `bindings::xa_state`.
-#[expect(dead_code)]
 pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
     /// Holds a reference to the lock guard to ensure the lock is not dropped
     /// while `Self` is live.
@@ -336,7 +333,6 @@ pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
 }
 
 impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
-    #[expect(dead_code)]
     fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
         let ptr = access.xa.xa.get();
         // INVARIANT: We initialize `self.state` to a valid value below.
@@ -356,6 +352,13 @@ fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
             },
         }
     }
+
+    fn load(&mut self) -> Option<NonNull<c_void>> {
+        // SAFETY: `state.state` is always valid by the type invariant of
+        // `XArrayState and we hold the xarray lock`.
+        let ptr = unsafe { bindings::xas_load(&raw mut self.state) };
+        NonNull::new(ptr.cast())
+    }
 }
 
 // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `T` is `Send`.

-- 
2.51.2



