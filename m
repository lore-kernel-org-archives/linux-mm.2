Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71714606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K8Y6HmxH
Received: by kanga.kvack.org (Postfix)
	id 9579D6B05C4; Fri, 20 Nov 2026 08:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F736B05C5; Fri, 20 Nov 2026 08:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D256B05C6; Fri, 20 Nov 2026 08:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1116B05C4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:12:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07CB640F0D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:12:21 +0000 (UTC)
X-FDA: 85455536082.05.020FF0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3BB0CC000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:12:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K8Y6HmxH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180339;
	b=wkMoCQsnIhmfESC7DgTKRqrcqSHgqmMfhfaqhIOEm7OVXUkd4YjpT3j+vZE4UQQEMDAkPQ
	S7IrqNZInfbNgNsB+bfJ+CdNWyyGzGSbklSssyeQxzcK2uqOIneGIF6oa8RnUCoxDbM0HN
	pdn2WEPwhyfOcpgqqMzcb9aS/fs9Sls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQRVZtFPrMqjM9Ljx1LpACPKsfPqrLTfGvTwOAaf6VM=;
	b=Pc9KTsSsQmJq1UyX1+/OlFfxiz9Ps6PNBthzBNw5pzUT85y3rpd+DRDdNr5eq+ROcru+oB
	Ud5Z1M6tPsqlNomPyH3tNnwmeFunQS/8pYSoRzkp1mcDEKo2a1DccUSSAy3S2CslEy577r
	TJpdK4UlJWpjwONUfSuYzFEtk6VdrBI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K8Y6HmxH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CEF346A25;
	Fri, 20 Nov 2026 13:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93B51F000F2;
	Fri, 20 Nov 2026 13:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180338;
	bh=GQRVZtFPrMqjM9Ljx1LpACPKsfPqrLTfGvTwOAaf6VM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K8Y6HmxHZMw6CRCt76N2VnBiocP7PdwOweU372toBpijYOmqfquLIXI6SpIVKqPt+
	 iAHE1SM5ggVRzRSe0d0D8m1hUS92Br0JtIatpyVufiMlghY5KHI2YvYVAl1KCkok3M
	 CT76RY1K1H4On5pjq9GXyfmEDSBRWOgooAyrTpFpD8CmaJYKH7wTyTbjIj4Skjx4gF
	 JBLYrf1a7cyhWms+QQgiS8W7be1SREmCKbV7EFNQA6yus+2yAdHmmRtEe6euK/0hwG
	 mcz6bZr+Vxmua7otNJ9Q52wHxE9qLhwmRKzQQptVuKNC7Xa0SjhCBCwPhguE/+vFSe
	 qQxP3nN0Vhadg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:23 +0100
Subject: [PATCH v6 12/12] rust: xarray: document `Guard` lock drop
 semantics
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-12-1f69d7385f70@kernel.org>
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
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2687; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=zxQB5t6KyCkOL62Gnm19op5IEY8zItut+0e7/+ELoII=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbOnSzwO7iDduN3x24CkdhLSPxGyiPH8AA16
 LkANH/1YVmJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGzgAKCRD6UCkIqsW9
 0EPrD/wLNAFwqxhPpX7DPbFMm92L5tSl+9alv+9E6ikSO21MrTTD3NQID03bsXyti9bI/SdZNrf
 pB5eFk6oGU7QEPw6FkUka5ZfNVatNLOk750e5xRnz3DFN2WP461SEYP+y4y04g0ZKAKMBQYU9gf
 RCx7/UG0SP/MwTTk8Y3Q3/Yz6sPagfXTKNugCwUvk3kTjtZZgIT4uXD2edkyWoSSF2FlYKA92I0
 6SqgpKA/mEyhE7ukhrINqWMj+KyRvuG1I2/aaXeLlOrSMCfeD22RqFpTR5Mwh0adbfWkxZvvbyt
 RkLSA1ow7cVLWxI2tVUPVs8U7wf/hqBJyVtuZ7BSmLi62pTyhZ5KpQMF8uQQDnZVVXfyGZAmobE
 sUfCaG4r9crR0wfyy3NonGCkbCLb1I2Ik6pa1qnAvGhk3439reqO6oX2YF2G2oa86gwyB64drXm
 cRcagdr+UedVE417C9CuCzpCEPVT0XeZ7924R4UPMfAFUxOvQ+EnEuAtjOKdRMP0I9hbpqPXIE9
 zDtE/Uz/jikFu5QjNEkVGAw2F6uBMEKckgPJgP01LUoGKRXyLOjxXUrKy0Ff0EReWHVUgNwWyRB
 EwgtBaFW1pkeGaq+AAaR/yMCCueQKBkrgR0PfiedO5Aps/yjKZg9cp6T2CU7WIt94pcIRa09IJK
 JIPTB7dPztzIxEA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c5899b7rqtpxqexiwq85j5iez77xya1y
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3BB0CC000A
X-HE-Tag: 1795180339-619258
X-HE-Meta: U2FsdGVkX18S9DBIjGxqPI0fdkf8k6pVLezaUwz6U7OhLaDNMCk/zzKeRoZF76WlFgWn1OSKr/KW5eNpB5JLotFGp3ZSQ6XIaNDLKu70PF8OgklcAZp78R2Bxxr7KdAKa7+XhLexQ8ePuCbeoZO1N2eDkl22aamxxIjQGekXi0HVoVPyNLiWVTsxpwWsl/5lL3Mh6tQhirA68eJvI48eQrinhGK7j4xhEGYzlXOrPQIMdLgCVT469aXr3GRbbaxCVP0wIgwDQvk/+LY7i7L0RoV9YcHCLI0mZCY22Cpu3OZ+rMdqauM4BH2k7gzvvbX42ylmETSYEktLfHZ0eR5k09cMs/bmXCvI6GZH3zHnRZiTGP19XOlVN20X8w+VHohj3H+DebrqaZ/Of3tlaRB4S3ju/afGKCe3sdJZP0FrRsnA7Y4AHutowzuJwHDpq5Yrg+8M7hf8ZuEN7bfTiZOyzDWJ2N+eZiE/39U+jogmyqnsQQPS44pEEgJwgxkNB5ozelZYjZDFAvHO+boX/ugTvZ8qCZYQ3poj3vwDGh45Ch872twBb0Io3/JPng0WeBS0lt35cykDWhcMEhL/lhtpgTP/hn84cTpk8YGt2LRUGJQ5mEDU/ERHgR8YVI8vJpsOEtDPOlT8RAx5E7iRDVQj9rl8r9JFlG/7laSZSzE0EYKgyz3vY7bZTmq/x6Xpfg8epUpXT66dICzgLBhjOsqPtgcSOs/O0BH7/lDJSz1DrAyD4DwVax4m2epY2n0c2v86dVfAWiHa4ZYaz/3EowZwxQM2ej+ue+E8lT6lDRif0EvH3yUv8WyHsdLkTqANlhhkhJGLBy79DRa9N1gUOdzPLrRunCJXBWYkLgmyq53+OhVCZr8h6bxIQueDlGBxO56BKt8QDO/1IZBKZReLXGXQujIiqMojFSI6NsyFo9c4R15aSeUzj1kCV+G8oe9qNm2/bt7x2EaaX8tniL9e/NG
 eXQVOTRY
 MR+jcPCAtwJ9Jxh7tg5d2OVqzuvDJV56my5dg1aX/OxzgMZJPVLi85aTjArrfk1tuojroNpREr8twFUZMGD93BGbD+eSPQIjNAUIjxcg+lKJ81yG2NWw9OPPOD4OCHvXKBFQPJKU7WtUWPiivKQj8Wy0bIBf3773RzovzuzJl8whziRO9mdjYQ7GhHT1M+b/GX9gFEkYlUSyIZrwkQ0beS6/eMIK9tKyqqKcihwshemZBKjZrn9yOVI+nxgsw3LIS/EuSJcLPzL53EEVaDPdTIzGvrvDwJeSZQE0ix9yZdHbVnsDANz3hU3rFkmaeL7UZ/vZaglLYIyKgkXQScR73pVVgvrMkxgks6fgOSL/pyjAAFM/baQCOQ538GspWYXycVM708lXWc/GqbTV242TWzqBIrAdzYzIUri0RFzwQ1VrOw3MlytjF27rGQW0CUbFKA6X2+0qeHx9Jite/KB49HUw8vNzN1FkTA0KWBAnqCexHFUJjDcF8qBVQvb8liCwK1nq0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index b13d06f9b0df..20792b09c126 100644
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
@@ -489,7 +504,12 @@ pub fn remove(&mut self, index: usize) -> Option<T> {
 
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
2.54.0



