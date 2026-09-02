Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F24C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044F46B00A3; Wed,  2 Sep 2026 09:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B246B00A5; Wed,  2 Sep 2026 09:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E716B00A6; Wed,  2 Sep 2026 09:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4EEC6B00A3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:28:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52ABE1C09A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:07 +0000 (UTC)
X-FDA: 85168900614.14.042F5E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 92819120004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+tYMlPt;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355685;
	b=YLDmEM5+K8Cmt6J5ShnwpaEvmP+bBGmjkZHm9wPm5NQ+IOV7fWMjZhRU0qxgv/irhcpFdf
	78anrIsrYzlH3zTbKzr19+w5s5YLL4cn78qXobRMxHwyxbePzHh6RWXucn8aHA+s38pdtj
	nyylB7yGq8nIupyGLrn/rdAyYm+xW24=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+tYMlPt;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHSGAuvtInu1rhm1zYqbkY0gUKKIuZH8RVv8W86t1CI=;
	b=uScEwv16AoVlOZZ3m9pCxdP+L43dcmzXALjyX6g1pts7E3RyQ7S+Qxa6aeqpfoR3ZmEPG6
	0QPvgAInCJB1n373FefzD8aw8ti4qruIJ1HDsLuGKnwnFSk0oDvEoHWonDkZLbZVtBkHYa
	2KHhy2GTBU7iFi8+QiJRs+xlbmNLJmw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33BA9600C8;
	Wed,  2 Sep 2026 13:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C42D1F00A3D;
	Wed,  2 Sep 2026 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355684;
	bh=xHSGAuvtInu1rhm1zYqbkY0gUKKIuZH8RVv8W86t1CI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a+tYMlPtBLTjjh8u4I0FUUTv+/ATr23STxu8JvEOsEC6BB2JLrQVwYo+ibZ8djmMm
	 VHref0lIdaBJb2xNwMdS8HjCFo/mDPXX11icCPyHj57I3Zu8+fu2IzzXLlVfp6IR1F
	 OMlIRrh4bV/u8vZuFYYwmo3DGulz2YelZt4eTqfJREz1Ev2yA5dmUsNFNQIrFZZ8pM
	 8ThXilZ7eMwbyHcSYRthiu/BW9VKB6fLjKcTjTBvPTjbav1e/UtbSHBgp/uSuQxqR7
	 w95LewgIlqCvuL5AyH05omlOOHJQXRI8WYE+wSU/UBvn0m21HFlnL668t0RgUZWfhi
	 GU9HNUd6fjGUA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:26:01 +0200
Subject: [PATCH v5 05/12] rust: xarray: simplify `Guard::load`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-5-d18adae40708@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
In-Reply-To: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2495; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=cfwTSDtHE61D+hAv0+T26KhcBz89hIRC5Ad95CVeQR0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQdaA3WUZjTsSciZ+SO9NZseZTE17fvIgVUS
 7/2O2oFwYiJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkHQAKCRD6UCkIqsW9
 0N2lEACRu02pSYdB4X0b63wrrITFo4OhOg2TPdse92x+5KfKfGKDppJb7bXIJJDBoju8vstecyJ
 9whvl5jPTyAvNMFuL+x0fDNgHq5O75raA0PfKMRLbyIj1PXP1YhgxQp1v+BH3qyhT536HEwKqOy
 wM8t5iym9EjYlBQmXKlDL+RZF6vjGBKkFSvze+ATeHfWmJxvFfgFg2MgAzR7dxRqaiz26kZCQy9
 yIo/wiuFqKq06cNyJLV2tTc/XHUzyjJH9g7hLJrAYueFElS/YirzAcpLj8FrRd61AR6RHVCAIvS
 LWfXLLrJlIdbeoh5CHV9fwDqt+KAAc2jnMMr+5CYMhfRs/L6rAltcBoBTrqCcJav56AIKwC/Zeb
 DIS6YN6o0NKgdQmVhY7pJqjWkNhzwVktGNByfaoFV2hCwJT84GfYjyKUBEvL2fIpAFMsXR+So1X
 jU7ysdOue364CTVO/lqLwRvP1+V9aU/YZzaCXNw6IOsHxeOVwA2VJNDwVlLwK7DDHihUxHJYp8v
 W1LwD4Im1Iij/LgRuAFg/XuwY8aUESgH8ul/nYnylvlgKATq0PBZvw9iI2g2CbA4Biwteni+qsr
 yj8HT77VWNvsqcDt8Kb32SLXfhLW1hunq6xoc4j82/rdS5Uad8lCLEjsixrc9i2hefZSA7NdaJ+
 AQgODgpC2vdQJJw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92819120004
X-Stat-Signature: 5kffzggmkdsp1s9r87hxdqx9aqp9bef4
X-Rspam-User: 
X-HE-Tag: 1788355685-292096
X-HE-Meta: U2FsdGVkX1/BCYmjnmiFlPOxjJixdEZ+oCYXmqtwdUEc5EJt+XFDPApLeha+lL6T1FzA9Hosqo1TNmgw2n5kSfHsOX7daTN3VXjINIP+4sqekNcFi5NyzeK2aW1MLNrwRz56YQDQX58AoLW/8iVofpIPUafwKHUz4nOcQq3tHZgmCXddLU4MUzYbW13XuXRgQhHwzxGZIxtNL9C8qqRDppOg1vWVkvlzw0Op8GoK22T6SYeEnFzCYg+ZtrYTf+rgfZJ1OyYKZBgj2qu5GOYTlALzQlKmzB1Q3/o73hh9LaQS1FWUt5dFJLvQeg67/IocgsfcSHkUozdqSwECHN6jd3I1aTP1X3DtKjjHLng03Bp24BK3dcCrp1/jGNwXW5mrJdXinYFWrpy6f31jeJBkn5RsaDSm8gNAef9by9ysV1CZFZSUREInc2Jhw7WQL/1FBF0Ok2Den1arQOiZUySSWilwtD9sr3yTwQ8P2VbwLHz1TV+sbl4Fwn2xvCgKdGRspnqAdMorjQ+pQ+mvKYkJBLs5+Av1/I9fbzxFGsxOOqPPVUug7FS7oyVg62F4/CfyrRunf5ukbLBucnForoYmocvuTGVm9CZISuEUrxeeuDCm3CB2MaaxFsxEwauuzPJuig/dKo5Y/zPDqUmUEWSSDwAj9x1KJ7PmiqAvpcMv0YBtYTpw1C4WMXeAkf2lLwuelUlLbcLZrFb3VNuP+pAw0gtz3kb7khZBuE+PPGLTK6yzyXnkkT+B226SMA0lbd8mpyt7T/Vg8EKkaX00X3763HSIku6iZ4c+sqYgm71pQvog5f4/hghbTLbPf4FeRY72KXCKVIBFQQs1/68x6njgYcTYPiSU2E9SIeQzuLsfyx92s3zrl1xT+2SwJF78jLIA+bcv0SEKY0L2GbTF1MrlH6/zionmw50nxHjClUdfuqjj5G4sP1YTIzCDZRNbRR1FPjDssxPNOIsEYzGgmBA
 rokKHjnM
 YWHNgKMpe/zCy0e3+0Qc36ax86MmkWtrqNtl3uktCOVcsR0v5MY+atLvZkkCGeLFLU67viN2/2M7mL9gpBF5RZpAM14G9ROZIY1oLF/uqAy69cRe2xnc4UJBaa2PXnfJijLHq/FtrrGeLq8sKeJlLMM401As0NICVO7Mw8ucqRJ/AbV84f2J4ex7hTPPgXEV9087NaXizZqKtKmAJy1guBOq+gS5+7sph8KkxYEayevemknNq877w0ZJGo5DS4s5UqCqb59CkJE5koi/ozeHaKSuBxeIYJ6CP/s+EV26oX/ZbCY3CMh+5fhBFvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index e8082df2b479..a14f874ad630 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -213,28 +213,25 @@ fn from(value: StoreError<T>) -> Self {
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
2.51.2



