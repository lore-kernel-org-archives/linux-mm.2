Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2E8606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ptq7qIFf
Received: by kanga.kvack.org (Postfix)
	id 33B7C6B05B2; Fri, 20 Nov 2026 08:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313036B05B3; Fri, 20 Nov 2026 08:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229576B05B4; Fri, 20 Nov 2026 08:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 032B56B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:11:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B2651A0EF9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:14 +0000 (UTC)
X-FDA: 85455533268.26.DCDC376
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B2E101A0006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ptq7qIFf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180272;
	b=JdLVSreVKXzX6pjQ6te8M4tSs7Ur6oDupqu0G5WpwjpjX1GQga3sea3tfRNWHhLm8bFpib
	DAn99EOoUHQqezVCLOxFrrNHOJAjLckATgDbMPrnMn81piCdORRDntfC0e5SR4IdHfWtJG
	y5LQ9u03alFi5YGWj124uvnyJkJJTWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+b67SetJCKoOq6HPFCZ+dRd+4Za+7CxQKhQ+b7IQ2N0=;
	b=ETPKULhfV7/vrg93RJVP+K68FHNc0Ajz9t+Cnm1J3xpKpM3AHOJjMeCtUkxw23b6UpCaXM
	GFX+ScXVP0ooSqybxLRx1V+6m3P3M/HHwvTfV644CdE06si5M1R703Lk/RNLuOBI3cajuO
	/UU60qlkK+nyDwPmuUC+TQI3RqwlCEE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ptq7qIFf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A1B34111D;
	Fri, 20 Nov 2026 13:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917C81F000C4;
	Fri, 20 Nov 2026 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180271;
	bh=+b67SetJCKoOq6HPFCZ+dRd+4Za+7CxQKhQ+b7IQ2N0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ptq7qIFfkPNpvJnfaRDnA31wzDuqbrOyjKa4gqxJ6yun667Wz6V1LOWxLS6OK+aTK
	 1lRUqGEc4VESVDH4xxG1ha7mYOWqkE+7prrDjeqwAhcX6Y9k2hvzWZyTRYalJkrvA2
	 JEqso7JGyI4YUrlTAKy51sxyKPO4sfOQEcdcsx6BKf4gleyWxGn5ECtrdj4ltasYp9
	 fMSB7dRNQR2eWzYUI1HsIRhpP/Df7H362e3WLXVEfHW05/9qrakPwg2QGWaVBtRg4l
	 onVgjENPbCjlEblE/QyDuOIQHiONgLBN8XQ+zG0HnKebF3dFas3YozBZoesr1L2Re8
	 WLZEGCokRrBnA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:16 +0100
Subject: [PATCH v6 05/12] rust: xarray: simplify `Guard::load`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-5-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
In-Reply-To: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
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
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2477; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=d0rtVC+HSo0Vi0sBV4kpNh2AbvNEJkRxW50q4wxsVeM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbHCtNGa0jo0ST/zXruZoCrOK+bQmB9UVylF
 6aY7C26+9+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGxwAKCRD6UCkIqsW9
 0CklEACZohQhZKz38cjO5nz9zaGBObG7WbQQ4qIvSQjQyjN1Ei+ETjw6A8K7qLJd7CTExFg4MyQ
 4rfsUVoPKMb5t4xCvsiNRIcZdF6XckWaXrtJRM/lloUb77YA0yDCEbY1aIIbiWigFU4slxRhXsL
 68mrqFLzNcXmdKvomI5clsH6PjeMcaNbHK39U7fAI4wud/dtTVQzfX329JLp3MXszdgvQXGYZUe
 b/pi26d6Js4eiYDtxmouaTlilEyLdMS/1ZxnLmx0f3f8RL5yR2SFsctWepac5YdJPgwO48tLzzy
 KKMMTExDh1svWdwZxgfLmfZXGapBJO/Cl2banPV0z8fxgEyBOvwRmvqoYGcMFaF4H8F9wLF3OR5
 MM9gf1Oy0FIziPSzFZwnBlpRf1hSQ6T7j9EXbmzMPXXOolC1j9M+hGC+Re6/nytEWYRzMraMn8w
 ZeKdGHH0kvA/3W6Nr9YY+wrOv00ob+fdi6usnhrv0OvhjWc4S+nXCihkOHLySLQgQ7ksEJ9almI
 oBLUGoUyB7X4OIf8JX2VAsQOrr6Ow1d13JeX30CSopTxUgG7L+x27uQDx+1UaLQpLVqd7xS7+ZY
 Pt92mpNItTt43cJaJgsafVreTZfqjCWn0xBCV7bKa4ZpHOWdMVqNrSCb+LvSjL2V7DqTnYLI2Am
 VC+IqB36m0N9OcQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bfauugkdrwj5o46j5sxstypos6w6qos9
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2E101A0006
X-HE-Tag: 1795180272-286011
X-HE-Meta: U2FsdGVkX1+QSbgfy6rZu8Mi7TqGyA7za8dxfE9YM5ldO9IguZbRbDGh0Ol92WmD2Se0FQowtUnLE+/q67ie7tgJfcbCJ/FJjhSfNaMUOE7bKwp6Apu3GqbT3vPWsHzmfE1sIs0+M1Cl/JD/KvRzuVLGzD9kiBws+QQfJILUxd9rZf91Pw72xHwEruw2dxjFh4ms/6+kDrqlAff6FiM4Vo/gKiADfn2BSRrhGMk2ThoVoTAtZqRN6gUlC//fKpaCvkDzNk8MHwYAsQ+MeIsiv4uAkIxVG7nY+eCkYY7X1bVpYwMDqgtuM4dhJxpDS18cKUW1RnLdhM3JFQ81vjlIn1TP/eGAfRpEodzYhNyKC6nG12p3sThY24H96mCN7Hi4FXy5dug1yNM6kGKSkZ2aXvTToxo2LVaKldBMrZCa3U88gR2wTkxZ1reg9dSxU4Bo/KcA90581Drd6WPLtjlagaNg/cJvxvKyOxxe6SEV6DrZ5gMEMglXkn8SgZITnKS26WR1lzto4dlisDw9HRLHfdDI7gvqrI+54/9kdG20IPtyJtL8d0/x0R7xVNA7fBXyTHPjT6mXJ1v7puqA888NtVpJAE0zhaQslC7/8fwXIPbvrymTuoDYKb+dz9LYzI7GUgbi39UWOs8/1tRHWl0cXZ18B31Bailk29cC6xieIRujqZUapt+FT0WlBBNF/PWytgaL788cz3T/8aSpkx92XeEfXHU9+V14OtLPB4krps8qorr4hNikcACSnww/B6I5armoZh9gnJ7f0hXU0d9oY2RQ3ATjDExih75C5n+px6Njknm7nLzi2fRNOvuXZHNTXkRwC8JnFuflFAhHPLn0yYOq4jiHrQI0lMYvHE0qePvwB/3jxPItk9yG1iGKQAPYM1ls0z0Ul0Rzu8pGBurC5gdj2DnNxVgZak8M+yT7MR0oKlZ5uYJAxKM9a/RTQuyNqepj0xI6cTyuV1ohyRl
 XucNAgU+
 /rhwUnNjlxsD6B/L854d92v5kblhB3RKg8fkccuWowGuetYs6paSgbTgprxs8JSrFpwy0z3XWfDJsU4cbVHiPBuIcxepMJ4JzECQbRITuBskqVqEvJbNsG2Jh1kUajqgg78HF4YoMtTfZHTFfDDIDfpsrA0ErtyuMUlRcM/gaRxfOHNrOQXvFSoIXxnKvQ51nLr/FSX6+MCyPQ2X3lrvAV1V5spmhkzb7J6T6FG7oagjwpgHyM6xXZEZUMGWf2DIZPAICjWBARlr8VvvavuFAXVbPe24OW7wWuVu24x4vIVs6TPJpt0XMTImYZ/EFr73nJ/XBNp2bO5mPH7xSFP8AB/1a/ibL0q5FbTyN3gn08w5jGwmaC6l+VR3wdcIEAO2gOjPnveNEkPwclxz6241H+k3pWvI3X3xehTRsNNsL95I2fhyC5p3G/yMlwV7iKAcsidv2y83UGJ617tXm5MBRcTivFcJofkvXSjfa7XmPXMy37sKVLyJhxmhU/8PFhM9T5vwL1s94aGZChMXCKzapzLpkCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Simplify the implementation by removing the closure-based API from
`Guard::load` in favor of returning `Option<NonNull<c_void>>` directly.

The closure-based API existed to avoid passing around untyped
pointers. The following patches add find and entry operations that
need to store the returned pointer in entry objects and pass it
between internal functions, where the closure style does not scale.
Change `load` to return the pointer directly, establishing the style
used for the rest of the series. Pointers are still only converted to
references at the public API boundary.

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 183808971683..94386678ef81 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -214,28 +214,25 @@ fn from(value: StoreError<T>) -> Self {
 }
 
 impl<'a, T: ForeignOwnable> Guard<'a, T> {
-    fn load<F, U>(&self, index: usize, f: F) -> Option<U>
-    where
-        F: FnOnce(NonNull<c_void>) -> U,
-    {
-        let mut state = XArrayState::new(self, index);
-        Some(f(state.load()?))
+    #[inline]
+    fn load(&self, index: usize) -> Option<NonNull<c_void>> {
+        XArrayState::new(self, index).load()
     }
 
     /// Provides a reference to the element at the given index.
+    #[inline]
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
+    #[inline]
     pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
-        self.load(index, |ptr| {
-            // SAFETY: `ptr` came from `T::into_foreign`.
-            unsafe { T::borrow_mut(ptr.as_ptr()) }
-        })
+        let ptr = self.load(index)?;
+        // SAFETY: `ptr` came from `T::into_foreign`.
+        Some(unsafe { T::borrow_mut(ptr.as_ptr()) })
     }
 
     /// Removes and returns the element at the given index.

-- 
2.54.0



