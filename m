Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F5CCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A26C6B0129; Fri, 26 Jun 2026 07:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BCC6B012A; Fri, 26 Jun 2026 07:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644116B012B; Fri, 26 Jun 2026 07:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEB86B0129
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:55:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B724D1676EA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:54:59 +0000 (UTC)
X-FDA: 84921907518.06.1176351
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1085440003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:54:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDYJfRsw;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782474898;
	b=8o5kfeIt9ULuRgJeRUxn/4xpIpK4aNGe0fKnIuV/9Kk/Uj+iTIlBkjPWUb03t5h6nOtmes
	w3C5TOEyOFa+9BQ8Eu7+6vKAdtdARcmo4bTNu8vPw7dEzUOIaun5/csIbz+FMzcQjHpkfm
	/4NP1j9ivtYyn1BQ5bhxw9bPWNew+JQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782474898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tI6M6Y2nl4r0WViOFml8Atpt2yMNTJUDccu+Knxm3HI=;
	b=73BylTQjrq2e0IF0FL+QyFP3tjrqCbEUQfyQpEjNzxfS194eY1HhEQcA5ihyGogzXtwnaO
	+hdKCPs528V0/UaZlGOaa2DQtKn1Ur3sC52R375sNCSCKuVPIo8D3xQK2MyjroVEMPFNz0
	9Qh2+5QY511f/MdXvPgR2YBlMt6C/ME=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDYJfRsw;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59A2360098;
	Fri, 26 Jun 2026 11:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A8F1F000E9;
	Fri, 26 Jun 2026 11:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474897;
	bh=tI6M6Y2nl4r0WViOFml8Atpt2yMNTJUDccu+Knxm3HI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BDYJfRswmlllKsddWLlMEwcM95dTkCYCF64HPZ57pBzELZbt6jGAmmwVc66TTM2I8
	 3Tec5A5eq134VO8x4lpVU2IdVNs67nrqyt8fyg8fE5Bn9XtbdXao0gO113H0vAgkVI
	 L5lyzQwN4csTXnXlgSWtUH1yP2A6+R08NaiVbghIFZkSxtH8b7Qt7s2GOEcx/R9+ZM
	 DT76tQavBwrHC9hWkzwi3PM3tRxSffeOFhWE6iibzw3/BDvAO8l6XCA7dNfCbWY66R
	 vFIHUjkysHLcCL0KtnND/khDEFldMef/K3qxDplJpjerBcOFvJ44cvKG9CvaoPT0xV
	 Xrc6ROG/EnUew==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 26 Jun 2026 13:54:05 +0200
Subject: [PATCH v19 8/8] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260626-unique-ref-v19-8-2607ca88dfdf@kernel.org>
References: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org>
In-Reply-To: <20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org>
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
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1326; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=IpZr4FT6FvBjQrQQDya19Z/r3yR23B/8jNNyN7AG0Ho=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPmh7a/zRVuwRfdQ6Jwphd9HrB/PVCZ50OLsaK
 H9dvOcadCOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaj5oewAKCRD6UCkIqsW9
 0E/AD/9fh1ImpLa0wfs7Sz9/7ZOnEQUUeJqCH7og8Qo4iv0qdA+RBY/oO8FSq5vpQbQ13fY3Ayh
 DEgavk1z3cPYnuandw1SuuDrLQCxLOeLESl0BDoVxBj/yDzbm7szUpir2LpwCaENUs5GEThvdNZ
 umvXCC4H0gSO0/hFgyQdrAsF1zYGzD56WcIML0JIjVf99ajYtIrUKOdTbO08ex60k3hewtHYJYe
 vCz3gIAJNTxGsuumDy/14ym5oK3lmMcSYExXMxewTFyKYmSJRrJ7w8LxyJkvAGMO9gV16Y1BYKC
 9A+tHkKCtyz4UPm6VlqNYdQk5VGahhJD2eZM+w9I1FzO58egJeNurQxW5HxgUiMvUoP7CFxyfvm
 JdZ7qlWp6XAYCVvhOcxzgflQAUlliy3D12W0TdgAT5OXESzE1IcQ/BHtUdXHJtgEIofBOzh2mgo
 eoDwgwfOXFNDpuiT5TMPQiBC8s9daFRsyQccAlBRfrjfWHBcK9D0fQm2yaZiHL8P7PmcKEY3f/y
 nL77s9uXC1QKlyBIB323xezmeOacU/pGxOFWljZ1QREEtu0r4u7rznmrDD1WibWb773+RjFKs+m
 aFKQw3HafY3hrMdsDHOrXjFu150vSQ+BQV9BTq+xWQPW7XYMXFNBqH+Hu/rPL8EXMIg6Du3CrHG
 wz+vQ055rIQkcfA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: drad3ofpocknk56nqjgns9yztj3irwpy
X-Rspamd-Queue-Id: 1085440003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782474897-287567
X-HE-Meta: U2FsdGVkX1953lT8j3QgZqiOsInlRobMXfJBWUC5QYkjpzM1VsbAWG04nlGspRE+qbYcJTYTSFIR70zmV9++T08fe14Pngy6rC+FyF5J4gEyZIeapxhrvKLbGWOcG0Sqm3insxD69ub7Vpc/syA4Wh9Pbg6kM4SqmYe8gw0p2NFt1qQEUAEnpURTspMoIvw1aPo2EVSAt1u8EYgxn1csPmcNSNGMJLtEdv1LuNHq9y55I9KylL3KClXtxwVtsF2SqqCp438yWyUGsOijpZkVeo5pDmzrLM77n5Nya61khIZXSECGbMfcrGEAhArylC5kfJAWJRroKCfbIVgyhAeO1Aa7X50yQ2EAAOSFudAmpunVYLqDEMzFXitL3JG1Dv0VUjDGlGQMs9gOWb3Cg6W7wI8NEl3cnStrCqIQQ65FVweiEQg7zQQ0AgLDELpLkfUjdkyVu4BQALCWJEBxff1Yu1GvnW7Xb4BqKfUY6Uxy0ZlzK4wm1h8XBIMoGFcTGw0m7CD+zbuBr30+tBu9mNhrJc1i+hmLF+K7uj32mjTLa6xwSPx0jViw4mwt1ZpRr0SfbY3MCZRNmTpbxTacY7+hu2YPMAUrABDzh2x2Yx4EHiJ3V9jaFdAijG94cVdHLHfK2Qo8BBmIQu0ofn4op7qLGOFDc9sHVv5/j13/fPWSL1EXm0vFY1SQXIDjcXGLjkUktPs4UbGQrZnFcNLmGFy3e65TjZM0uQ6YSwHg1SIclkH8TLrc1WaZ73eEvYVv+Pn0iQ+aHqljnTIAyoULt7BM91uKEVc6UZUZXnQooBaLq4MewJwRjBityHnK7LGsBh/PzyT7fITMfMT6qjt+2r9OIkNX3fMmcSRQOt4uQzAoTntFc7+U23UBXc1E1XHBtlYrz7+Pyx1S0NVc5mXG7mELdi5V+ahtLGa+9kD0l2xpOeQsSc5Mj44RBjmb8B/Qjlbon8bvbgvEOLJ7OpKAIxB
 JNkjfFcR
 74fAImRleaSdZGMCQHuM0KrMgCXGW4YIb68V0xD+mDeReqb1rM2p1n0Xv+XgciwQh3RU2WmoGd+FLCHRAO+vgjy9e6rvzIt66bTcUM8z8TcBCW7jblMoqJ6ZmWxkTmqkJgb4B62gV4fFMOZCHn3CdTpbmzsnsbuJ6jU094UjlgGDbFfpgK71SusF+tBelMZPVmxdqH1gODEJa36dsTwRleNzWC7RUa9VNejpuHLfI0ekaiFEQoOdrfa6fB4zERXKfLw5JU53eJtoeu5VTV49ZyHwwlOoOeX91hIfxEiF6Jve4eyQltmgJymzLh6PUwLazNnI+qwBczlnr7wtLTlCdPJPCsXjsVhCgr9wn8jepM87gPhXdxxYfoJw4o/r3nsfvU99DmVo9SWkV/UiSdLGDB0w6FUyRmfex5rpgTJyMvDDQcPZYMkvvIU76Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

Add a method to `Page` that allows construction of an instance from `struct
page` pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Onur Özkan <work@onurozkan.dev>
---
 rust/kernel/page.rs | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 6dc1c2395acaf..c88fda09ead5a 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -143,6 +143,20 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page` from a raw `struct page` pointer.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be convertible to a shared reference with a lifetime of `'a`.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
+        // INVARIANT: By the function safety requirements, `ptr` refers to a valid `struct page`, so
+        // the returned reference upholds the type invariant of `Page`.
+        // SAFETY: By function safety requirements, `ptr` is not null and is convertible to a shared
+        // reference.
+        unsafe { &*ptr.cast() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

-- 
2.51.2



