Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E556CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D676B00A5; Thu,  4 Jun 2026 16:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B555D6B00A7; Thu,  4 Jun 2026 16:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93086B00A8; Thu,  4 Jun 2026 16:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9596B00A5
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:00:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6796A8CCFA
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:43 +0000 (UTC)
X-FDA: 84843297966.13.69BDFF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8D8BB1A0004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:00:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cySSMS0w;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzpE/Seo/CVQh6i9kKpA38HdPooRgCjlsYOlxSZWRAo=;
	b=wdDJ0Z7PYC8bsiaNhBxJNO3Yiy/d2QcjP8KBaqngP4UnlHG3zKrCoYw8wPV8dxpudJzvG0
	YimDK2MONmPImX4dRtvymL2k/lZgmasSh2rfOrnCqeZQozC31kimcuLwbcFbVhmvDSoq08
	vLl1qqPP6sxJJnj+BrFcmxXY4stInVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780603241;
	b=aubIYX3OyqXMk6yeyz4H0U8GR2Ej+M6pLkiqlKQoLGuhAyCczCu/AnSobYODesouIE6mmd
	En7GThmX7FJKlRfmAcn0kkgIPu68Rt6GoB32ZuU3wNKh2ab9V5EVCHIvIDR/3FFLXBlX2R
	wGym+8wMiUaBivkWhfkRc3h9ZNCRcQ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cySSMS0w;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D423E42AC1;
	Thu,  4 Jun 2026 20:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29BB1F00893;
	Thu,  4 Jun 2026 20:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780603240;
	bh=uzpE/Seo/CVQh6i9kKpA38HdPooRgCjlsYOlxSZWRAo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cySSMS0wQoYMLFZzNwdzKmfmDrtcSP/NCTMcBFjGrWbz/6X+Fz/vnrepqH5ta2nh1
	 lhCk9aTbZPsqiZNsvbjOpL4PQxz8kP+DABIXN56KvsyAjv59XHUSu7zIHiAoEbqhPm
	 1esZpcUGWk6ajslGpO2jjpcIxVt6RdEiE6v7A1RYXbUZ8oEM1XcBwgXVVBKTFf1wg7
	 A9AfnP56HKtTmklCWvGhwU/UpbvkpJ/N3Xx67srCiTyhHV1gejmg4wmO0SpwR+eOcl
	 Ac5Hdplhy87NTF5pJ+2+4er41Stu9yUF0Qjed+2CogvW7P+aqeNxfZXdaox+bkAki9
	 laeW5QIFtTTTA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 21:58:11 +0200
Subject: [PATCH v4 05/11] rust: xarray: simplify `Guard::load`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-xarray-entry-send-v4-5-965f6028790e@kernel.org>
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
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1921; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ezQhkpviZx/0cjtMqszOUvlxFZxlxC9tkEpF0/WvfOY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdju4CQhaBJkwad79lAfp/ue4pLZH7qUsiCm/
 +qQ25t3ElKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHY7gAKCRD6UCkIqsW9
 0PkLEACqUwe49HzCnXbMEXytmhd0EooYaXxjvSqDIcIDhP4BqsAGSFzbXsRfdR93yV15pTd5Btl
 JHv74i4b5Z0UVvF6rEXcae2n9TT/TdoVv/YNvAQPOxodV9+9pCG64KN4WoVJm882c8kllHD70qk
 tikJcRAEbjzyuVBJLcxZXzqkRiSG5Q9sGUHb/P9OacmoI9I/czaNbF+qmD7KqDV4zJwY1z2zni/
 lgoGOJFES7OBBQPeLRWZpfHgViKACn71Fetc6wyljzbj2iSwwm2pEAtOLFFNxtbPJub04IgQfeH
 S7TZ6+OE6b/N0Wsz4vVgOQB+gsSlDqG9cuvkgayZ8xasT1X6h3snzsh+VL6DXuzLnxAb083ktup
 Wx3n9CP4v6XAmNyDEf1KG9jQiAaQ+OqLjFyfshRwHn+2l0dL1YUlFd3O3ncsb35BJOj8QoTegAo
 soE0Crn8McmYMPM64I0llHlTFjJsVxwKrMVViZb1/fY5FQXsSLNOwWllgKwdCkSpGwQYgX/7WHm
 fxjoYCVj4oVoQ4kMayxYBlTYUrcfz355KKByl+Y4455Mel4QLQlngxC9hYIcQdNjlQohUFBwzQp
 n1fy6EZejVLk87xWLxOfnqFhP9BelJBmHncIW3inXaCP1jgOVFdU4IJrvuIvaVpR/Gq8hk8tBNZ
 eVEHfHszdt31wHw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 8D8BB1A0004
X-Rspam-User: 
X-Stat-Signature: n1w9wnx46dxf9smsq8iwuphjw8qukzbk
X-Rspamd-Server: rspam08
X-HE-Tag: 1780603241-19173
X-HE-Meta: U2FsdGVkX18nn63P56iqZKOOmxRZtjKL4raQOIqvWG0aCJAjzS1PP3BA3Wy6pCu1tmPJgQ1NVyFW9+BVXaQCWZGcB1rHRjSJ/lDzJfPoLdrurcATZgx8qbV+l6/7SHLHs5DneJfpt3IWIlGPwfixbFRzvTo5YGIcqESQ1iyfmGZ9gh4rlVnFQrta4RMPh9igAHaU95PO3jicIdr7cmR8WEBXs4GzlucvQa75/487ndpr6CzWThGndUXKvGxvl0YMgGnk8di/kqKT4thjM46y358F4IDxPLexttpdrXBVtSHhTXU/kstNr+pyxRbKbHvMlCneEGibpOGs3xkYgAv6lEk2Xueih/FPH3zDUzKI0knCD1AsDPy6xo550/U3sXLBqCcQo0dsgIERbE5IjEUWDuvPAL2Z4yAS9vAb/9lz7qkN1wYv0oWrb1saW0OHtz13GleKpgjpVdc/ViXCXYxBT/+qGVS+w0fakcN8RvlgAbSv67Kyj4Ovys9Xef4S2MWdS1DrA+qAqDJNqehyTBVkQyztlBaIMHZ41HTV1pZJMHfNYa/8mrVeUbHTuQDeaF97QD51REnNRikJWheo+B7KmmP6Olm4td8eiZs1eOnXPk+9KMuYbxijfpnHT91OYw1f/7Ypy2sCEtzKvLV0dOowFEf5ydugR7Yb+RzGr49Zu+8gmduyXiEuRN5BZc24pzmnTmnRvTIDdcNcFG3C+nN9HApcdZ3tjh18W/pSCkFlXh4WIgMxNlhdcL9RRh2rd39a7KS0l9NF/lHkO1iQF+fACshHrzVBKVC8I1LNQFaVLY6njKaZxhTmNm+Wq1aZS5vyGenX/BRIqxGXrBZMGeFYToP2KFOu1np5o4YYTn/rtUi1QCH+XcGnLOZyX1q4o7a4rfOUK38kpU+az7mdUuXLOYsPBAAv8mYeK+DPZ5eT5Tnst71Fi2R9mDJ0n7oKqhCo7zt5N1hPfJ6UpKNS7gg
 dgp4C63P
 i+QdeAmmFKXBy1jYq5LmS7ej0cjJPUEb493o8LnM025vfUaQXjNx+cQ1vWC9ABNpgNVkE2CdQjEstaDuaMbRqD0AxgObbkOyxgZJDh6yqrniwI0alInrPlKu9gPlNAOmlPTxi5oHBIFq5SzYU9IZf1xBvx2u0P3rwwKeESZnexxSgE9MsBz4HXX/5oHQzn3XztYJFy3cdSMxiV9lKlfpPVekze8EA3hRvbnGMPrAEO8MXNymqLJli1yC/kttE3chU9J3+fN1k4aqXVjEh9qxHf4XSOSvFMqYBMyaK8aMkQAh/LmLeA3PSIKoZZnwz5sgKrsye
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
index 05e6dc1ffe69..7da57c778669 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -212,28 +212,23 @@ fn from(value: StoreError<T>) -> Self {
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



