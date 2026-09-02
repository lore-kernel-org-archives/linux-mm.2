Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B3AC624D9
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A7E6B00C3; Wed,  2 Sep 2026 09:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2A66B00C7; Wed,  2 Sep 2026 09:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1656B00C8; Wed,  2 Sep 2026 09:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79ADE6B00C3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:27:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6893A3A93
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:48 +0000 (UTC)
X-FDA: 85168899816.20.8A8EA3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1EB6A1C000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z9/mA62T";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvrdQ1X2D5s1R4J+rxE40TWU2LjD4CJYJF+HOAohSg0=;
	b=V/kegfmBiKlW+Ea+WAp1IrRhL4QEZUjEm6+lh9r9/p+5nKR/alclJcfhRdKFyGGGt8qJgZ
	M5lK79+KgQIIpZ7uTsaqBm7KwrTE1M34z2olvEX5dBcphKJRG3+T6+txTT5cW/ZdxTfoqk
	O0gUj+RTvADiUtXKCe7CXmtB+xTx54g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z9/mA62T";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355667;
	b=WwMEaEmoOB4dPDs7BKcxClF/4SwuR+RfhL5nP87EYayvCQ4IbLj5pSsLBULfJOgFKePeEz
	4ZkULAifzmLqvopGnuHi57eTafeJvQoXNroF9tfb9iv9oR+ZSa6amJOLAwu9JyaRHKtyW2
	r1lyZypfnkZutVsAbursIvliIucQGM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64997411DC;
	Wed,  2 Sep 2026 13:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8EB1F00A3A;
	Wed,  2 Sep 2026 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355666;
	bh=rvrdQ1X2D5s1R4J+rxE40TWU2LjD4CJYJF+HOAohSg0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z9/mA62TsFxmdp6qOn6JL9z5lNw3p8Igcv8uQLBoLG25/22AsmTKxdHEyZc3J4n4E
	 vXFNARAodEVuC8SisiGBSUmqW9whWKZzDla7OSY9p/6iltuB2fwnu9Ym3kcEjDCSmJ
	 XeqnTM48BKunAlYgBaa1TGatN5AM/wNxTKVBGrA0wMjcWtScAkYUqs7uw6PpqygcxJ
	 f/juEYygRnoQdOCqAj7qBu2vWJrwZ2RdOtT4HtJTTb1ikMjDmHJMVi41vExedVK5NY
	 U6DoMZ8lrsO445LisxgZAr2ZVJBFuUNPGstRJ5am8ccxUdesAh0m+f5HIEr5BfqWJ5
	 qnmpxagCLXUnA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:26:08 +0200
Subject: [PATCH v5 12/12] rust: xarray: document `Guard` lock drop
 semantics
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-12-d18adae40708@kernel.org>
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
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2705; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=YsZRkENbIkLSyIXntyIruQahHQMq15ROVwQjNeshW1I=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQjltpaMuy9pxr0plzFO8VrPqBiBwDIEQ3/Q
 /LPI/ftfsqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkIwAKCRD6UCkIqsW9
 0OYoEACjwP3ewbl4zVUWZWh7Q57z4bSf5HmjEqnTenAVKH162Qu8PsggMNdwBjI+5GrSS4QC1f7
 agvP8MhuRkcIWon43Um4pPe1+hwNTAIZzsPPQRSA9LBn9aqQYYOiY3P9PaNR8zaepid8BTNXYNd
 uviGW1OvMbTMc+nXySoe+d4vyYskroiYCFSmND1vBGRpD16KAITSVoNqZ3BX9elp+JAqDYUhhQ5
 mYgAm6eGW2Mhw6MfFJH+IW8/WEbKDUpksipvvKBroclQDjnTA6C71klgIhWWji6965B8LEKiEvO
 PG24IEDR85SgOrO6MmIMNdlXDFExtKpX3/0M5/px8V5IXPqkzcg/y5KaoUB6M37JiFkg0PAxxQv
 8Hxfuknl+cM6kd4ZhljhOdvxNYrsQ5Ifyqq/bxUryevVYY0ZdfyOkRnwyQbDN6TC3G9rNUOiQjr
 jVUVP5WPSFjxl1dz6YO/LEkv/WnxhuwxbnWcUlZVE6yLyHwrDxxv+2B3cp+MgKgh9AVUXx8jh5y
 vFUcEPal/Exk5Qrg+Z8sxV4s/uqwiTVCcc4sQrnVjOdIffQhp2Ytz2lG0VPPqIqF2759WLuH+t6
 bT35o0iU4oifBYIvjcGYDkkHtnvT2sw/zn8M8TjRqHXlOtSqbSZQO3djX9El7lWJhzDhbCHkIEx
 t+kiqY0kTwiRcJA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1EB6A1C000C
X-Stat-Signature: 8ef9equqnq6pujydhoowsddqxdh6ibwf
X-Rspam-User: 
X-HE-Tag: 1788355666-787682
X-HE-Meta: U2FsdGVkX1+3NL4/6sLhML7Gfbw2lOYZkUKFXMyw2xHaU0BdReWIDctRshiigre2/4Il1fuKVj4qpYrTukoOm9nwoZeW4ivnFyxodPT1jJ0pt5Ayt3bz1dyZGOq7xHOnuMzbsfWAge66GKRzkaDDCTljYMYKwDXmVIwTj2TbRX3uQQRJQRzpkiLt9f7z5MtdE3vn/tmc9F30rf6gX6hg1haMbSGXARm9ekORYz2kJ7eZh+IHuok0mr7dSQIiK7HeYHITh8DcC2PY4sEG6ZwLSnMst/vv3LFgf7pWKIN0H3C5iaX0tQir0FbW7INgO/UJCEs+QDR08q8p5kHPUSwAGD/Qj6yyautQPLdhJ8CE1/1Of+iYEHrzy6FQJipoVVH8852DMqrvkJan3OTX59jV4ayGXxoW7O1bLD6rgguy3LL12q0keOzw76bZzLUwxwcbmdzN0QttHEnb8WbOJ05cYNzYMXFATtXbX2quVWNpzlT7PmE68z1O3oDLrDuIN2+XFQ6hHHofqqyCJgSoFbGDyn4lqPu/c6CzDC08+lOYVzQrwpaY/NuuUWS4w8FuqROCgo9LsG8iiHy1kGdXd6Z/Tm2LEj0ely608SEU/wEKP0llEP3Ft439rVp7Lbazh/M4YgNsfRqT6RPkoJkEA9C7Ttst2Iq2NrdGErwQGYlK66KVxEfJO2nyXnMbfS7z97TLiZ39FGnjNkC5Lc7zrJZJvTVtv99CvOyRIAXj0yBneZbxc+WXaxkzEQMsj+TQXlQB1bEJX7ukvx6hwz6GsoezjOVm+XMLD6cmqjULYhIjIX1uYlIt5jcPBDDTu8ffD73jfjWOHHodKzCyV7Zr6rvxMJRhbKbinPDUGIwcSItlZihFEbvOPqMbQlyG3LVT25O8o0cYpkUEDsfXPT8vYVZ7Yrcbj5d3lXKuruLEy97uBV8KXAdE9EW95lLyRCpXeZ7MVZUgyB5CiEYJjWXB/Gw
 M+WEa+9a
 lraAKgseH94S9CIPeM1TVSM2rpCI12TgNq95MvJ0cEIk0XlQfePOhYkhnB1VbwgPiN/mBGb2HAiiMKJdtzS8zViE2EtabBUdZ2/rdjeajWvDS74fC5sDozB5BY0rab6jUtWQFDlndqW5kptuPFqs14iwDur+mxLR5UN0LpCKnj9GlFxE1jFbBNY3kBFxsM2O181GNfMmh4jxDIIXB9700sclJwFIZwjnfFt3lAOB/U1VNvd9vVtgEWGl0vnhWwT0t7PRFuOcY0qLV6PFs0aaQDFq2ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`Guard::store` calls `__xa_store`, which drops the xarray lock to
allocate memory when called with blocking allocation flags and
reacquires it afterwards. A Rust lock guard is normally expected to
provide continuous mutual exclusion for its entire lifetime, so this
behavior can surprise users: a check-then-act sequence spanning a
blocking `store` call is not atomic.

Document the behavior on `Guard` and expand the `store` docs,
pointing to the entry API with preallocated memory as the way to
modify the array without dropping the lock.

Suggested-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 87123ab96a92..a11472acc661 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -242,6 +242,21 @@ pub fn lock(&self) -> Guard<'_, T> {
 /// A lock guard.
 ///
 /// The lock is unlocked when the guard goes out of scope.
+///
+/// # Temporary lock drops
+///
+/// Unlike a typical Rust lock guard, holding a `Guard` does not guarantee
+/// continuous mutual exclusion for its entire lifetime: [`store`] may drop and
+/// reacquire the lock to allocate memory when called with blocking allocation
+/// flags. Other threads may lock and modify the array in that window, so a
+/// sequence of operations on the guard that spans such a call is not atomic.
+///
+/// To modify the array without dropping the lock, use the entry API with
+/// preallocated memory, see [`entry`] and [`insert_entry`].
+///
+/// [`store`]: Guard::store
+/// [`entry`]: Guard::entry
+/// [`insert_entry`]: Guard::insert_entry
 #[must_use = "the lock unlocks immediately when the guard is unused"]
 pub struct Guard<'a, T: ForeignOwnable> {
     xa: &'a XArray<T>,
@@ -485,7 +500,12 @@ pub fn remove(&mut self, index: usize) -> Option<T> {
 
     /// Stores an element at the given index.
     ///
-    /// May drop the lock if needed to allocate memory, and then reacquire it afterwards.
+    /// If `gfp` contains blocking allocation flags, this method may drop the
+    /// lock to allocate memory and reacquire it afterwards. Other threads may
+    /// lock and modify the array in that window, so callers must not rely on
+    /// this method being atomic with respect to other operations on the
+    /// guard. To store without dropping the lock, use [`Guard::insert_entry`]
+    /// with preallocated memory.
     ///
     /// On success, returns the element which was previously at the given index.
     ///

-- 
2.51.2



