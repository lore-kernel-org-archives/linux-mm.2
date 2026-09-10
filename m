Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6B3C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F306B0093; Thu, 10 Sep 2026 05:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6684F6B0095; Thu, 10 Sep 2026 05:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F166B0096; Thu, 10 Sep 2026 05:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37F526B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:01:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64FE880441
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:01:15 +0000 (UTC)
X-FDA: 85197258510.08.1CDD370
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D888A0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:01:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJ+XqesX;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789030873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7S7XXrE3nWzY3ONCdrsA6SEjg/y++hz7JJ/gIuPEcM=;
	b=MVZyz5IxsAP1MJvto9QslpZYckTfnX30tKRRfu7+Mcla0teLwfiHG/gE2XpODs4IuNVlr2
	35O40l7q8GJr2Nh2LANe+1IYG7tpx+D6Rp+wiiNB4hc17Um854j+nOrXkg2BfalnqcZBzk
	Dx7DMbUGcNvJM3HkZ9A+6TJdYxWJl+I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJ+XqesX;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789030873;
	b=tPrRbX1VCBiXVbajGZWkrW8Yn/NiCoZx57v3W6pJx43kPRqBOaIBlGevyw4Zbz96BzwWOv
	Cft2JSqkS5B9UrjuxWYxgK9AJUvtLdq5MH3VPKyfFk5Nv+RWHwUl/TOUBA/4eYg4FdoHfu
	9+8vQk8vdgwjCZQxznrBOYa1ZowaJxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80051601F0;
	Thu, 10 Sep 2026 09:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEF11F00898;
	Thu, 10 Sep 2026 09:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030872;
	bh=s7S7XXrE3nWzY3ONCdrsA6SEjg/y++hz7JJ/gIuPEcM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IJ+XqesXeR3rwnE8YiSGAMy74CDSFRf2vn9CkYC94FFki3qkJju9gP347J8asQYy1
	 Ba4hgpuYSs1N56xySaWeWTdoWQLbFuJf3QU0GE2gD//1hacXnchFL+XZyvbRWckVud
	 43sG/uMibp+/HuD70PSFtTf+xbxQVPfiBghz7yXppW+a0mFJck0q0ErSG4AKF4+lvF
	 0vsVu83SO6vFPFQOsm+r2wtgEisrUEHNUgPza4UklC7aewEaRRYDHU/lX2LBcIS0EH
	 tg9wd9zfGWKo6QLeDt2BSO+Vm3gjyr81Onnwto6R/eTQNwDvJtKQklRZ987kcoS4It
	 w4akeFg8drFyw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 10 Sep 2026 11:00:12 +0200
Subject: [PATCH v21 8/9] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260910-unique-ref-v21-8-e83257373062@kernel.org>
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
In-Reply-To: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
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
 Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, 
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1342; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=qsvOsH5eJ/6SOy/kG5D1q9n3SKwDVeax/chnlBoc3Xo=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqonGoab6vY8s20eqgiCSmL4uGzV7sGy2smNjbZ
 wuNFu6zRxGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaqJxqAAKCRD6UCkIqsW9
 0P2ED/4y0eQDwdjf1HYThRZR1AGuMa3kPD5Z55q5tNW5zGzFQWEjGOPwoKokVlha/nFjzxaddX+
 REzqMGWyTOcbuX/SXoeDCy0OhknY/kwnhAsS+xJxaARcFVrwakURX9JQs91mLwqDYGSNHC20cFy
 U+YgPREcQJVQzzJAGyOK/2PCUqC0bDxTjUWVdtTIV6RMUE7U89ulN79TUItTzt4bjrw4IpFCY6U
 sTBgSAf3wfNHkKD5JazKA3TyWPREJUNfqTAdSIz+f/hTa1qbLHcRQlL93CFB+9FmUxVCcCiaD4s
 q1z82eE61CdMs6UWpHhYDll19pW6abxVa5iNqq+WNxz2QYfYhOCzc4es7H+PiT+CbxrSaFTImWk
 x+XNqAwXFQ10L2uHjklUOUIcJ6KAmrBeXazqL/6UgXMRe8ISncWYSC9nAnITCrtOOr/puGiEF1E
 m5zLFhTnvBu7N0872U1cJqrESNiReM4HckNcw5GEOH9xOHRcoM2tI7B+gnogw7atqjMmWVEneMv
 6v/v0CDDBmwj1/jjMupa8FRmoz9xr3zMIOZMZVYMz7AtueK6DiKX5Rbg8srWyL7FalAf4ifRHJG
 i1JpqOo/KpwQCCRSzIlJYJw/LSWKs6dcfoLoD09ol2jQkAsfpqkEERGE/JQO8mlhgHR6VNnOdL6
 gKJ8ZCKmAm5v1mg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9D888A0007
X-Stat-Signature: sfk7b48hgid3g4up8j7papnrazs66c19
X-Rspam-User: 
X-HE-Tag: 1789030873-482371
X-HE-Meta: U2FsdGVkX1/CDuiCiBjDfarM8dRPKW7TfgAW96TLqC98NrcmC681TU0vSb4Uv7jo4TjNeRbTcIpFDwbHtA9f4zwDknn5MNWYox32ivSfJOq/SA46XsRaNsR2nj61EhapdB+S4lvztlDKBEkR81xkDzaR5bvOwI6xS1RHfAgg3/2in+jbn5TKhHE2umcuJLDI9AnodqpuXV3jR5sdRc+XeLlcyPXOmgutTpLLsHCLwCkLoRhpm+Iw0ClWDNutHgnj/tldp9tKkZQt1U3ck7kpJvfc32us5/0120v2SxIgxNwcNlTA76Tvt6LHrHBNQ3Eg12yIrKlzKJ2wY9mCNQSTWn+4pKYlw1hnKd13qi1xYDaBnYt6unSuYkChvRi+Q1qxi5dDlEKY56wx+tYnqJlYq+M5ou5X5L5yG5prGLRh6TleIHdUkPus6IuBGQNEDJbuleZ0tHwo44nQ9bHIYM+ivEewW7vjfYRHLOjjIwYozqM1B0j+Llv7qx9a3EPOja/jfhwMDruU52n7uWWCOESBaTsDLYxAWkEPmdYrLzh19IXU2Bn6K+RldWy5Rx3hhu7dyIUNlQaXD06AhE+RdE6KEdOFXqm0RD9By5ejTMH2WGXZ0U/NqZn3aouNr6a4gB2S2yfVKyXjAcaIZozwgYob3GuyqA25HRW6NqHAtwvXJlRdjCMlDj/qVe1KaVqbrBIWcUFsEwCys/ondfwTsaNbKxt0otTRHHSwqJpGwJypbF8Qldp+eErfTghnTn348ENYQ8QR3wOB24bdv+Gz7AZOQy2vNUWSGri0SH63vnxyP2UFvJ5f2pH0suk2IBHMu6gkPFMzmptlQmGZQLHw5bP0TSN0/YimjyuKzCNdHHIFiEDHjPP1gs9jwoiQHNR/rBhSOYg11QJNh67ngoY3RZR88nhhQHrdlasNiTBb7tWLkMjk2r1QAKYpgt8n+PMCq3Ai2h5bmJjQzdBcJuegD8j
 z34pQSvc
 3m2HUNf1MUByFR1N7jgfq+HUOSmFrywnyr4EVL4mmd8uKwfyh7B6CZYhok4av4TffbBC8puJTao2NDMqqVwGABcgIfBEaJmg25+v109+LIrA5VYOlSnHMePXh0gzBSdjzzPhPJa5MVQapxy5uuiw9KQik1wmzWA/XU9BxrMGoyGDmnzUlELkiV9VBnpVMfZNDMYzayFt6SXAN6gQn2jswvYCrh9i0Kv2baeWD2hb6smOkQGr2kjl+jgM74pxXgBo0LQnPKZpOBwzeSdbzQGYjpZfxr2wwuXwWJWBjudhLGqUjWh6UlNx6qBuAKOqqLt+xRwd7lWf7pkKAjqtysIn+i3Gtv4q6YRw7hfp6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

Add a method to `Page` that allows construction of an instance from `struct
page` pointer.

Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Onur Özkan <work@onurozkan.dev>
---
 rust/kernel/page.rs | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index a2610774c749..cd394b0656c0 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -146,6 +146,20 @@ pub fn nid(&self) -> i32 {
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



