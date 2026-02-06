Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8181EE6B60
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABE16B0096; Fri,  6 Feb 2026 16:11:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D8E6B0098; Fri,  6 Feb 2026 16:11:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACCB6B0099; Fri,  6 Feb 2026 16:11:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38AD86B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:11:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C18A158651
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:48 +0000 (UTC)
X-FDA: 84415278696.15.A776F2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC58FC0004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:11:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="elL/ARi/";
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlfP32EsaB2Z28RrAKtVFFdwVqFnS9XkanbAiC9ELK8=;
	b=T7UqWMNaxtxMHVEnUHPWSZnlTECBSS/hhrfjfh/gZHYgT47k6c4Hp7SXYLOR7nhkgeOsYi
	cLfhtz7nZpBNK+5u1fhMfFCVSAHMb4J/PTcsDmb234rDTLv376TNGsgk3AAhYERsiGwIvr
	1qa0Wp2LjavAgY7uZczaFAtO2JM8AI8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="elL/ARi/";
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412307; a=rsa-sha256;
	cv=none;
	b=Skq4FXvtTeOwveSxEmcRQss2dScJq5eAM3amf2K63O+DQjXTggFTUvVpphN1YVrdwHpqjI
	Iha1xsxjiS+UxnwclsqloOBPeEu62W4DUZR2uRgCOgHlSOA9CyL1SBsNyGIngySHVjpFXM
	swKtAlNUrALm+P4/D91lEQHPczYJsDI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F163D4428C;
	Fri,  6 Feb 2026 21:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5747BC19423;
	Fri,  6 Feb 2026 21:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412305;
	bh=SUnEj4f1l9mHuLlzJWz0dNzh+/snH5Ql51wel6NI7LE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=elL/ARi/Mfy6/8OMFNs8uiRAErlt7a0EsxsJ96Y8ZVMEUAaysUtfZY2sG6o5ng67K
	 3V1pS2IbXdWBX+Eg9MTVdG0W5b6W4i69faAmQKVTOgvL9Q35sjaD7kLroqd8t3ZGgK
	 7QJq4sNIooVcA27haeMPsZPq+ORT5o+xPNqHjLLNDhT9vw5Y9bIVLoTjLovOpDK1fd
	 tp8RupLbxnAVDk/51MnYgE8W5OhZDiOr/VTUHPKQCVbj499SnSe4EH9MsPQwguBqaZ
	 CYRmNLiw8z9HcwnNdxOYYTlRUEYx20j9yssvpQEbaDh/Wo++umBNHfF0x9oCHZ9tZg
	 Ru1hGf12XWPtw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:52 +0100
Subject: [PATCH v2 06/11] rust: xarray: simplify `Guard::load`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-6-91c41673fd30@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2076; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=SUnEj4f1l9mHuLlzJWz0dNzh+/snH5Ql51wel6NI7LE=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljmYZEvBGqQzuxdMlWfzFpY+l8tlo4gbcojX
 j4SxFfq6vqJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY5gAKCRDhuBo+eShj
 d/jhEACk9AnNcXcMjo9QkvvewgUgKs55e+8UtqRMLkwtnf1JovlHrP0FgBD3dAp7YpEIT2jfiiZ
 yIINVdEkcxkz6fGc3CigphLMrBcvmc/HMVCD+Tdv/bs48oEJlEzuSWjy192ko7PkXukIr8/YqVU
 L4aNhXo4z0xRfMMzQpxQVWgS4AeUcGMRF8txn16M1hZPOl0+iZuWfuaRqk9lQcYjFReFcMqbana
 w6PaI3C1MfNSbtLKRpBelVfKz8oJeysR/JZy9BlNnOBpA8W/iJzHua8iYh81VsB3/6Rt0XTEfJF
 2r8kUBsUUOeDwfWn4h5vSxFDqvaKDre+Q8zk3vCCTiaT7snf9JpLnuJ+laCwsPkdPQdC0uCgMis
 2wd9F3+rOrcSGbFD2xR/j9HmvZ5PcUKLz9W2cEUwZ/ljm5liiUs5Ef3tjhZ0R+hO10+OJ/3mfKa
 QTorR+MfYJpVUkk2713dvuD/BaKrSzSS1PebsCShqovjUsGt7zwYWBJdXtFbaqsg8V+Pv+Qof26
 jsTwB2Kiy7CbN5xWJaiF+XwU1TM9QmbALEuY+N/3VDU7jR3SmQBgZhFUpHty3554DslLC4TPyGm
 JJFYMn07uAzgxa0Aujy3IvMOZhTwtycNUtGQNu1OUZsAWoUAuYxwX8DcZ6w1uA62vd7ues2FMOD
 upjfZA9Vog25OyA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: DC58FC0004
X-Rspamd-Server: rspam07
X-Stat-Signature: oh75z87jt4b4yi6t8hkks8f96t5esaci
X-HE-Tag: 1770412306-394069
X-HE-Meta: U2FsdGVkX18RFub5jEpUEjVIt1XF9exHbwZtVORSFYnWptnDegIPwDm+q/YkEn39h6NhYEAKKZpnSHvrGC9TBlSpVinIub6Xc77NVpQcoJH44ruKYEsYlSjlSVpJ5O3nJdfLEXk3Daypp/BhYVwV41LAWtdEkFc6f3Dtxtr9LWkNVzh/aIgeS2Cne+7zsTi+E+UO7v3bXbI9ka+t0EBa3Ukjzc8W6rTvfB/cM1ll/z5PnR0AJlzXUP3AvFaY/sznL7qRtRxEh3v32BfGjWgi8E5qplZiSwytOktFFcsaqROQ9JZtqiQ71bYzoaqXJl2AsTmk6UAc8KfSFWbkYjO0asXHhjRulbskhgUMqiPQkQULyWsqrHcTRDOk0CaDEW3iM48HxPD54FwqbZQJvgaXhXwbR5OgtnCeqy2eqykPmRbAh3i9UgYgc7bfUzxngRSroFx+/B/NvQK1BR5/mrNZFE8VKLy1VooAH+uY22/Z58zn3pE1ZY5TemUyz/snOSCV71zrFe85sDPh8Eli0iVrFE/1gugeZWjRyrIUMloFYMlL6RD4L9OFMGC6k7Gn2E+oePOHxnDzamHu2ASjglsZluVGM6rPJnpZ31QRi1+olbPSH1k/k5cC84SVB1qpzmwlw8OQqaNMewIkhTj4/V/Fo+fpu9RzS2xTtiSR06JYMzLocTObhwo6gFvlr/TbPjl6v9hwI4d6N4ZzfrdEJdaKto2CmgHyIYelAFnCW/F9Yd78EiTc1V8VgppWnsFcfP6MN2Q2sycvKwmBLqEJNNdC0cm5H0qwXKJooc8XSbGzLYvLFb0NLBj0NMDsvnPHQ9LIs/XOZy/WPsHMNRR7JQ7YNIxyGrpknnWROYDKr9ta1st5bGoVe23ckoquCvypFIXdswLYEX/RUj2EIpQD7hD5EmonWR+e0AGusLBUZNyd/gAcqSlzboARZtg99kOBYhphuuKglNGvyB6mDRy2Pq6
 qTDQubuZ
 lGVc093ZEJhNh7iJCHegr+RF+wyDrMq6gZfhX9seEwGlCH0it90Mkce13tf2kSNj4kdil7sEnEJt5Ln+JHhQPYfeMlkr5eZkSg2xbDn8dZ1SvdYkCv9tNqftWcUqRxlg2yw0d8j6TVU7kKCaNnxvdYvNyj7sZd7/IbpoS+WXi/Y+/zEx5E1warlGqCDZ+CEvBPGJAnKJkWhBgxSUvLs6ZWEHlnP8ssU/xrz3hDKU8jQ3PjsO8bdyCm6MqsDpCCyRRehVeFEjIV/y6IWrpw8ChBnS+xtmq2Kij8h7Uzx+VuqrGeysr+vIrsok56rBFNzL9OzVY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify the implementation by removing the closure-based API from
`Guard::load` in favor of returning `Option<NonNull<c_void>>` directly.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index eadddafb180ec..e654bf56dc97c 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -211,12 +211,8 @@ fn from(value: StoreError<T>) -> Self {
 }
 
 impl<'a, T: ForeignOwnable> Guard<'a, T> {
-    fn load<F, U>(&self, index: usize, f: F) -> Option<U>
-    where
-        F: FnOnce(NonNull<c_void>) -> U,
-    {
-        let mut state = XArrayState::new(self, index);
-        Some(f(state.load()?))
+    fn load(&self, index: usize) -> Option<NonNull<c_void>> {
+        XArrayState::new(self, index).load()
     }
 
     /// Checks if the XArray contains an element at the specified index.
@@ -242,18 +238,17 @@ pub fn contains_index(&self, index: usize) -> bool {
 
     /// Provides a reference to the element at the given index.
     pub fn get(&self, index: usize) -> Option<T::Borrowed<'_>> {
-        self.load(index, |ptr| {
-            // SAFETY: `ptr` came from `T::into_foreign`.
-            unsafe { T::borrow(ptr.as_ptr()) }
-        })
+        let ptr = self.load(index)?;
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        Some(unsafe { T::borrow(ptr.as_ptr()) })
     }
 
     /// Provides a mutable reference to the element at the given index.
     pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
-        self.load(index, |ptr| {
-            // SAFETY: `ptr` came from `T::into_foreign`.
-            unsafe { T::borrow_mut(ptr.as_ptr()) }
-        })
+        let ptr = self.load(index)?;
+
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        Some(unsafe { T::borrow_mut(ptr.as_ptr()) })
     }
 
     /// Removes and returns the element at the given index.

-- 
2.51.2



