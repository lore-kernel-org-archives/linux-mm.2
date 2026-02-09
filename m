Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C43E81BD1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE84C6B0096; Mon,  9 Feb 2026 09:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FEC6B0098; Mon,  9 Feb 2026 09:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5B16B0099; Mon,  9 Feb 2026 09:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD2616B0096
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:39:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94A0E160196
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:07 +0000 (UTC)
X-FDA: 84425175534.02.7F6D262
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC0AD8001A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:39:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L35vImqr;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3XVaggNegpbwtq4LxsziVuwVfQ305FsRMMb3sMulqE=;
	b=iU+rpUPz0CTx5sUclX+1dptfblU2F0LRjMcrDACMRJ5rpMsZeju6pLrLn7WRsn7HP+FXj+
	h4mJJeZXjUbjLgrX9nhrkEZXoqXod+AlArv1QaKR7SXmnrs7sDG0P48WexaMpqjUMwxHVK
	ItaoPO7gh9OT2cCXkn6j9efatt0JOys=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L35vImqr;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647945; a=rsa-sha256;
	cv=none;
	b=lWqK7Pw+xpPJ8F0dlaPD84M6hG2qhaC+2TfWMncLl7AcZ95gYN9pSUeieX+PcBEpo20zr2
	M0zthfBmn62LymzC6f5s8JLfdEdlqwvO1j2DJPnQXRyiAFsCd0du47x0I/JY/3uXU5V8uZ
	trSxp33ZLN5p+ifIMtoRJKcGPWZPHr0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D703F441DF;
	Mon,  9 Feb 2026 14:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB47C19425;
	Mon,  9 Feb 2026 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647944;
	bh=hPUvMpxg3yU6YJ5+chgN6zUpPTceUM2JTPt9rO+kJpw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=L35vImqrNtEsIYbz0XKnuOtX8nsW6acGFOYBDJpFKeRNY3s71iAPwhas4hXmvRsrm
	 fUnTzOwPUKWy6mwIjyYM/GJQBfrTw8BDvOwTg81cXK0bGCqTABDXYCCJabUz4snejs
	 8GfEBKTGa6Sh5jhmRiaoXuMq99uN0npnM7jXIDgyLIBbWOrBWVcqbmjyZDsU2HgDSK
	 LuNrHzoUs49Q2KsmGe0CgFE/4MNezLeEDQ6RTZYed6e1anXBiSXLDBp3ErhxT3vzR5
	 ydLTbir9G2edTPnS2FdVabJ7jHVRJxu6mU7FSgVDHyDkdLnOd1gTxQhAAwQNtphl2Y
	 AhCUwBfJpHNaw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:10 +0100
Subject: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of `xa_load`
 in `Guard::load`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2487; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=hPUvMpxg3yU6YJ5+chgN6zUpPTceUM2JTPt9rO+kJpw=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFZFhygcsP92+CC/iGZ/yyaRbPPG+QQI1WSU
 gLT911IMLiJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxWQAKCRDhuBo+eShj
 d2zRD/oDbAVgfgHXeRmBddcqnK4VqTy56UmL/gr82qWgR5P3fipSqmnmxnrSoE8pQBBd/bAtADt
 YgaB/4g53dINi8fCUbJ4Q3sXtImvJjn7pPenPU977QBqf3rla5HIyXEzQedjtj04MLFpMnUz9ed
 eHZ9/pe3NbZAc47xhNeoeAJrrkhOKQOBYrbHrHJ1kKb0iIwOziicEBVzZ9SE1EireZ+ENGlUjKf
 nI4uJ1SEEWrU0qvSmttePZZr0ffv1oVUeBcCHEOtI0oy6Mz9sMj4uEgkE5ixhKkItsC7Ebz3ssG
 o6JjPUs29vsmYOBHA2taOsswLKU924EXfw/QadLhFCHa+pFITxKYj2eTK899mShqfNunqF8GYyv
 W0TkAZLFRRcKnTwbrSTsCzpqzRaNDprv8tvbSX74iFI62a7WHiLg/Vj+V2LYsWQdHu/bbDfrFzs
 Bgb0IdWmYdRK28yQs9D5W3WpMIrAbqAQO5JHsGsKgeDovzaiiDpJYnhF+Ko1KyiQVYRe0CpJ8EZ
 Z2drb8mSKhfEd+W6NirmXEYLkbACwoDeaW3Vya0XG61wvEwtY6OxMk/pR6FTxPhbOhUfCJQAb4G
 EOx/PgNbFCu/GhsxYIwmyZpG0ZmDUsH/7CLINow74TjDXV43F7xjeUmaTOHEi828iBdO1Yi280u
 1O2mVrr2mtqx/Fg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC0AD8001A
X-Stat-Signature: aoajfp1ghxpqjqow69ctjzyyozy4odq8
X-Rspam-User: 
X-HE-Tag: 1770647945-570295
X-HE-Meta: U2FsdGVkX1+K3vhz4VlB5+9hFhtl/gxL1lVx0IVeJ2Z6ekwWl9IgVrmjqVwwRjq0WmOMj+1bTJPI5KO82zic+6USuc86tih4eArETFTFp4o8O8pktWm10b+t7kthZQYWmuItb2FgCe4b+aPFTN++NelwQ+L43ud4PgFhqdCPVxzUfCclKJ11o/CFyjRe3bZVw4+NNnM9b8J3X6xS0DedE94VrY3WJe9/BB7u5814WzVs/9hwUGXkGHRZ1hIIN/wyOwyxKnO4G1RPakQ7AVPUrGExIDEXeUZH6/4fDgCjRACcTe8bQP4ZbdLNYp4WU2zFPrrZHojSp8QCxUbUJQkR6kQ5zAyG9xs9MULqx8mRLtEqGMRbAdRRoZJhGR/kyf235C9RHXfP4DOv2mAM+fMvZC6Z+geVRuEkz/hMUYJl4cah/fSjw35RqSKRKHoukd+utlzKSo551v8oOTr11MNBSGbr9VBjRRAk7ydbOFfOyjG2NWxfnWAYTmOUU4O4fnmwZVeZzFRUjaRYQii0zhyCAn1NI9tBLB0XZY0X13z6CaemP1V+1Tg5uxDeu57/q2dh5YsRO+mrOeOTaCl7XlhZoC4R96vwrdyn6Nu2+Pth/QR/K58Q3EQU7awnMKxDhxlvqaQ3ReqMcCyTehe/GeviqzBDxwXUJ8VdKE+74HdUCq+vsfHmJ3cROeEUNI856iGn0/34n43I7AGUbvunQfCg75ObwtkDT4ljkRWgP0AuCpoy9Sp6VnuTSSrwLlvQoxjM2rjoK9H/Av58F0Oghc0iopLBFIgq7oIppKlBNVliUTFELCDqaTW8CxZ+saEmOFhmFwQ6invjkZNqatMsWMNRxszx6dCpUStP0UAR2Ece5HvhmrQdvHLsKtwmUmfigKmKNkwHA1Qa3V8u+A+kA1xDreXjnMykLnkrc35qGYAMLtSJJqA15ri4iFeZMreEOypoPlFn/Abgr3L4XZPDIta
 GPf5uB79
 fRyEgTjgaFVT8MxNO2SsGN+X6kxZ2bX0ZgZZc+TM18cJHAypre0gfjGqzEv15xvdlU4TLSZnM7SJvVd6xuENhzdQ3cpW+Rf5metc5qFN0HpwHMnmZyk0W6cGtCMUKGRYRW8rQ/RRrb/hlnKzLBC8nX8qwXsBmkUsWLCPPdek1Ek5ZWenqb6boEgq1c/xAKBrs2PHBJkznDdP+pk6RxNvsOl9WxnWyIsIsuyFNVTxoi+2SrJGFlM9rkTV4xHWqIlb2mLSh47h4Tnt+Kxvm2lfpMD0ynjwiSTqjexAK2LLG9+RBxdjnsboSj+eRM4GhGqCrUwvXLD5/0Q0ThQ77dnBKCuVDrrbawCpqpcfvkEp0kTRC5Dc=
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



