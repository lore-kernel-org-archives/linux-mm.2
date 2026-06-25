Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2494CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA6C6B00CA; Thu, 25 Jun 2026 06:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91D86B00CC; Thu, 25 Jun 2026 06:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7EC6B00CD; Thu, 25 Jun 2026 06:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7266B00CA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:16:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF3FD167673
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:16:39 +0000 (UTC)
X-FDA: 84918030918.09.7773676
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DE9CEA0008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:16:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YTgJGiX7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382598;
	b=r0kBObHxQSy+Cwe/2mGk1qbXaY4PEXzq2s33WQgxXFG/AcxAHp9xWq4ysRTb/YpGl9KXoS
	J3LFIcgPAICONt2KsrsxU0wkNteqb3JB5iKdn/Zomvm6GWWCEiG+sHvuAG7fbe93evqr59
	bkf0VLNSf4QZZSLd1oe1Yi7tTdsug5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNtLwpUtBCbwlzY1FvJc65Jza7fCnLIGQublYFNRjfM=;
	b=vtvYpvHCKnRLQJTDdlgI/B4+5uOjnkaoxaxTPFsRj7ERSX9ox6W8PKF23IjJSoQSZiG4V2
	iYkepYRwEbIkdbyewQSzuLOD7jnXd8iG4HbO3x1pvMRl+7ZTfOzOv9XbSNvovszx/aXTDI
	Ec1COXiVZ3BRAd2YesNK7HlTa6Y+t6U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YTgJGiX7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E74C41B1A;
	Thu, 25 Jun 2026 10:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070881F000E9;
	Thu, 25 Jun 2026 10:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782382597;
	bh=CNtLwpUtBCbwlzY1FvJc65Jza7fCnLIGQublYFNRjfM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YTgJGiX7vpyvr1NvkO81NSfF9NRnSAG4Bm8DJZ7Y2R1T1Cw8wt0gR/PKCFkpXnPb8
	 FWy6JRJXrznxqNKGvKEY/OWYWpwJR8DaHKi9qLa7wQTNd9IggrblryapVC6sK366ME
	 8kqh4NT60QYoNd8798HmcKigcLQe4Vq3P3o2tC2la+DlAd2Om8Viun+FT9UHlXyNym
	 +Ipb+RgXazvoNwvmDp5qLDMA6Wt/bZFCtVZGjQ9meQE5aKM4H/IKPn+Cu8yf2Tfgek
	 pblBYNYclxI2Jm00S3zcHcXGsTUfwcbM7n7ha6kTtJXkIcg3I0bcrxtjJu0a2AOxce
	 HkybxcqPNGQMw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 25 Jun 2026 12:15:08 +0200
Subject: [PATCH v18 6/8] rust: Add missing SAFETY documentation for `ARef`
 example
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-unique-ref-v18-6-4e06b5896d47@kernel.org>
References: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
In-Reply-To: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1545; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=2xO30Rq3QXTxoSgZh5GHqcI6JrKIaWz8NtlqTYC+5S8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPP/COqKlKjyz/MXA1Y/ln7gilkEOsT25qZw22
 Rb6scm4wFOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCajz/wgAKCRD6UCkIqsW9
 0NcWEAC0tVyWWHIsH7WmwyHeTcRIIcSyA+jVURLu5J0VYFDajTnEyZ+As4AP3z2c3lUdJ6E0orl
 1PL9KegXdlRowzXbknFM1TtxCHxyv0r1NLU4LirMxIGrPVxVdS2cKzRU8a4gLhBmCdVNre1PZLJ
 4J/CxV8CpnFJ/NGp7bvsyrmDahOTm3RPr8VYu3NEWzN91Chnzo0WR4N3kHcTCaoaD9N7pfgkfXN
 SnkyJwR/QnqnMekRr2mxSexRHKKesWCkucCw4gV4EU8Ht7NiBUtUbTRN0DxmhQu3fYYAgMGTwh9
 DTTHtgGRJ073AyQSH/+7GS1nCzIoGFt0P0iEq0NlGdJEs7PIOVwNgKAF7Ld7Nw/qp05kjay6rgN
 2RIMd7ow1N4T0KveKCVRwhxBl6Af2jClTGzCRz2qO1grRMZM23A3Jnn70x713gbn6iSwTCGx0ez
 hCSZQA7KFhlo16eTeqjqI5pcW4TJlgxmjBlxZ3JwaDa6C7Is2kGZb9crSVRNsOIY8nP9tu71pWn
 6Zkkodq0JN43u0YjJzndrbhsXcoZQHsdTSexPf2zYG3OJ7yV8JfAvw+1cLWuyfCLaztHTz+PRwq
 xSjZ5qf2Tv3i0nNUbnvZoBqU71LWOHzACaLAoOpGekVZMfB9afZne9LP/W13DEjw/HUjuOCIOxu
 gEx8/vZmtx3o8YQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE9CEA0008
X-Rspam-User: 
X-Stat-Signature: ox5weya11uekfycyfr998wtam9oezbit
X-HE-Tag: 1782382597-101994
X-HE-Meta: U2FsdGVkX1+BrRSVvQFmCFLbzxd+0dEV65T9fCeFmXSjkDCgi1L7b2juxK5wWkn4oJq+kIKcFyV1MA+yIVh8m1ea6Vfmw4FKlZojW/X5UTx6Lpvfp4niYLIa7S13eo3QQz/elN7GBQ6kaib58GMk+zyUtXGNUDCgxv2CllI2WpQUgM+iQGa6yZJe3Twc406HkRg9rhY5NJOYQZYyyEkmbH/Ovoo/9167LOAzxBxw2xQh+Oxk0Vg5liTbTbsdj4UeGTbnkd/5JsRAIIisQwt/s9AhyCQjnkUzgQk32E/hNNDTXZmA51sneSQnXYVhUykXmh8s6qu/cd3SzdDL3S+ecpzzlk4g+7o8tYFN/SwZj4mMA+cVaN+poPqgZcv+HNDOc37bWexs+d/THoIURLP+xeOTHLJzQFyobQj+o/reKTvXPPZqALNK7DR8hRpka/Krd6JezuX8+1XeBETVj4CaEuqACx/QD2RHZAdK+g4U14lV7V5CIQnAWynP+r5YQoXsgtqJYa/xBipvan7lkbzR3BFuxwuMz4Nr7UtU44vt9KCYLwNzVGsuZHLrkVYz1uRNBBKUp+zSEoc6OEFpcFOvslyLuFsn1VZRI6cIxRRZJUDnAFQKrisD5Wh1tQDMuhwkHAXxS3bH/4GaQn3JunrUgRwEQOAsoRIMj3l/pVRS0AnymIXHz2Fzco6TqLYw4fbtfenwU3A5ZEdwDGQJ7pbv5dt5Q78gTtnQC/hrDVBithrtequs/984fuz5pz/8FEJNTa8sHwv7A+l6TxhHfszYlsM7sLSMUF8+3VxMegTR8n3vI5PxqJyfJvCAV5BZzn3FywaQlP0UMSJAmfA5Ubw/vryW5sk+KFpPtMyuQ+0rqgSs7izBvf18pjqLD1CRzfqbvVZjsjO6I8oeKX93123kyC0EvO+4xmAlPoHn0/K8NN7wojLpoT5v57kO2hZ5aTZUW2gwmxU8utHgzDswjYX
 ICLYTETt
 W7VDeiwU3uhxHc8gVHwmbA1Tk47XSWwo+ybcn2uuOBUlh9JvOjKRTBo/96KVuWA7ATL5x/0Xnen3EDOql51a49TKB3lW5EqzgGPhLSK0Mkcbwmx+UZOhHAEQZz0ggKHOeS5Zwp5pryw7ziPE59BG169hPqUdrhqGJSfoM3XsCv9jMwSrke2Pc1R0MdrgCI7IC8olQtqwyjT8i5YhBPZZVgKs8yZY65Q2EkmtNFFb33awaKUGffp4kag9e28iA6nRjuagd6dLJLRvbcsT7H2em0o8LUCLd8SpC/z7o7eKm7P+5WEZ8vpoFYWwWqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Oliver Mangold <oliver.mangold@pm.me>

SAFETY comment in rustdoc example was just 'TODO'. Fixed.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/aref.rs | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index fb7466a362741..d0865aeb9371b 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -142,7 +142,9 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// struct Empty {}
     ///
-    /// # // SAFETY: TODO.
+    /// // SAFETY: The `RefCounted` implementation for `Empty` does not count references and never
+    /// // frees the underlying object. Thus we can act as owning an increment on the refcount for
+    /// // the object that we pass to the newly created `ARef`.
     /// unsafe impl RefCounted for Empty {
     ///     fn inc_ref(&self) {}
     ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
@@ -150,7 +152,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// let mut data = Empty {};
     /// let ptr = NonNull::<Empty>::new(&mut data).unwrap();
-    /// # // SAFETY: TODO.
+    /// // SAFETY: We keep `data` around longer than the `ARef`.
     /// let data_ref: ARef<Empty> = unsafe { ARef::from_raw(ptr) };
     /// let raw_ptr: NonNull<Empty> = ARef::into_raw(data_ref);
     ///

-- 
2.51.2



