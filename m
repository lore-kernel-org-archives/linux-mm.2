Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90483E81BCB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35866B00A9; Mon,  9 Feb 2026 09:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEBE06B00AB; Mon,  9 Feb 2026 09:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02176B00AC; Mon,  9 Feb 2026 09:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEBC86B00A9
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A33E2C0616
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:50 +0000 (UTC)
X-FDA: 84425177340.24.8DD5754
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C56BA1A000C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNMvntLz;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlfP32EsaB2Z28RrAKtVFFdwVqFnS9XkanbAiC9ELK8=;
	b=YCWFeoFXLhi32lYt58EEjD9wdWq3r4fjrTQA8SII4+J+MULRYwhMhi0Jxlj9ZfOhRMMTtb
	9RqEf3TXuD3MsfzIOwrqJWAG20NvYfQt7XtUM4P1yoqoGH7Jws9zwumvpbbTxf8Fglb7c4
	lO6FeQLtdSXcoaUCWwqk+xfN/WQFmnc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNMvntLz;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647989; a=rsa-sha256;
	cv=none;
	b=SjQRI6lNMsH9K692FIcZ343DMdvl8viJFTUl9t6gycyuP+HqHO90HuZERr+TH0TWI67UKh
	LVXqT6ct5f0jVnNS9Quajm77dIUssdarV55yJ3m9xpgWZoed5TR1Gi3nxgaM6gadvhfWRn
	IbKUAqHwM+ORreExAjwWiDAAVDj/rME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D381E435A0;
	Mon,  9 Feb 2026 14:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A21C19422;
	Mon,  9 Feb 2026 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647987;
	bh=SUnEj4f1l9mHuLlzJWz0dNzh+/snH5Ql51wel6NI7LE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GNMvntLzZ2YxBuqe49g3RUNZCw6QPe0fv8HqUkyAajaigNKTo50KAkjyYvbdCbgPC
	 Ow0bOv8NCQOrPKJUiXzlg6w+tFmXrHx9MGDCtGalADkaZk3jX5QpGXqxlfnCSpfWLq
	 u43MgZRFVnV3M2AcH5AbrYFFU4wPIoo7VlGwR0LjITIk5J4+zlAkAmuQxsxz9bhsyO
	 wKyvORoVhnS6q5TAy+J3W3DF1FrVPTD09nceFC0kTYUien2RPzfa1BXJ0PqNighoeG
	 6DjJJcGVCtqV7xiKpKEf85eE/qzvawVTXt/AP3bFdMSysLgGEYtt7iUGGkQxlAtd56
	 kLDDvwXNSJUQg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:11 +0100
Subject: [PATCH v3 06/12] rust: xarray: simplify `Guard::load`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-6-f777c65b8ae2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2076; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=SUnEj4f1l9mHuLlzJWz0dNzh+/snH5Ql51wel6NI7LE=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFaKdOChhRuevCXo/AyFuqJpjt9pI2F9DYSY
 GB02zlFWYqJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxWgAKCRDhuBo+eShj
 dzDZD/92MQDGevDXbOVb/99y5TakQLCirDQL22LaLohFi7zXhh3Sk30nKFNQWW2EI02c/GE3R1V
 Z6EDG5Vp5Me0WyCQecPlnATdKXOdn2r34nc0rhIO20n1Jn89B4QAUB++YtWLTwT4vESv4B6r6qU
 Ms+5lXL2uAdKHD2EZc9F+I89JzMRJ6CGdhn48XsdHTXufxLGo2gmtKGVE0hTfGRAW8nyhlBbt3l
 dgZSoEmEOZFV5EwStKxhoNh4K1DZ3xGgjbJK+BPVBNRTU+BEC3z4T5lQOOglFuegkiu2BIBwQ3O
 5w/MQWZlBbYrrcQd/CGdSLmTmhOoZouxKvyJc/OK9OOuXmacPuaZZjAdPL48sVDBeEF2FimAU1l
 NUpA0UKfsNRTWFRlGTvl6keLMEPRDA0UHNZhwntuZI7efvLcWDFAwgikoNsZPeW69NV5Ug7a8W8
 YIWjGbfYE1GwF5Ewsl56Fxjo9NaEP8X2EbDEtNcEvpLmXSfE2NOKwsr4EiwIoSBbUqUi5fyQtRg
 FDQJmqz7iGKIkYEh3ufL0aB/XjVrf9Mi1xhn8pbYlT2YqScSYAZTHQnLlsc3b79IMc4M+xn9qrF
 UK9jaydcY0Z2kUTpBMERJPQew4QWcfB9ZmFK+KcyMk5RfEE3CQ1BcrZHUhYqK0ZgClNrm64x0Vp
 L6BjmJfPZxCL7uQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: n6nd3g1hdc6s6mwdgazonzzzkwyg5aoh
X-Rspamd-Queue-Id: C56BA1A000C
X-Rspam-User: 
X-HE-Tag: 1770647988-597330
X-HE-Meta: U2FsdGVkX189GCA7+OeyngRFESZTFAaDDL7YGITQYcpGYsDoBNnws6flP8Ue995LmjvLYhhTDKCX2PloyeSObJSPaGbw/bZi4LqMvJghMMCpToSAQt2b0NfxZ01YwGPesXWNgV27icLwjAB+UCRY5Jn/kHVCSp/RTdurf8HfCqGv1U/l9gqV4x/m3HE9fmuDezohtug+CWVbQIA3wai7jgcitV4dbBygx56nUfETTRoSxy7yBHo7as0lagQUnQzKHaE0Ndgxl1B0UebrFNPrEfmGPDnxd6dxR1gZTCzpLJk56H0JJa98O9PqKFBJBXRdTIhGW+K0ZB5VhAS17Nzpv5jNhq2HIXNW/7JwkLV6Gd2EJggRX5KzJIE5KNM8JuMc0RcrILh+mL1bX8p1lbRspmQTvO2IAwxyGPhDJGakDYBuYKUOmqiEEmhvhJ9BdVZD4a+GG+yOVms7VNwNXOUz2w2cOte0dltj5edYETRacKIKUh+zV2GyKrrJ0L6MypFISY/JGmJwKu70FQMXdEYXTzKKj+qQite/3g0lZsn3qmTZOy9cfMhiYgHeK6Lk52/fuczr3U09auVBmcrTI8OixuxqPxFzwv0PdAD2hGSxVGKklaOxebgdGbhN+GZWAI/Yhb4MFR4f7bO8FqkNdZ/swgI7EkIDV0KT/VLU8QyRAlRwmVskbbgXplVGdP4lkVCDEGQJ4ihYuRsaNju6lY2096oBEP4ttFRI9muH7QDDX7OehSgaTl5LuJUD6MUhXakluSWqmKjddlJM7fW8GYMzPJK8/rFLfM5JmztrrWaRWfCVAvFfKq1Zu4xmnNBBhExAj7Sb5yeGJqDI7RJq6svtFRWlrBWML70Z1cb2e0AJhu1N+n9Hy+LRCWDilYJMJDEfNtW1ITUDUFYKqZ9PGsR3yi5ajrprn4P9+oAlINY1prSj4OodP9zVLsBHKnDRdkROeJ+fYsUL6axmXI1OgHv
 ic2ICEHb
 vDP/cnvV/QRWMC3YQbThSjSx9ds9Sa3oFoeEqvKvbtLecyCmEE0RTqPU5c88kQHhotj8dCrzcCqBjiaTP03G8zUTEtfYpq9Jj9Jrzt4MOrfWYjx+kCW8m7MKbAIodAFa82LB5GGxx71gfDflPOm+yROQX71dJlbtvzjrbHzdz9TfFkL0P710rNLcHBBzWqtkUN+DuY8B/zvuBjGyztaZi1ISB/cEQ9m2Yx6v/1gucVJsuzvNoxRkWYpJqPtSDWP2JmjW3g2gZClgAofzF6doSeFVWmzT38O6SO3MFV5rUFWS1lKlbbdhkBOmwk0ae56Rcks8E
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



