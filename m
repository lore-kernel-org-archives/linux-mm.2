Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D34BCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89DA76B00A1; Mon, 28 Sep 2026 22:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3C36B00A5; Mon, 28 Sep 2026 22:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2686B00A2; Mon, 28 Sep 2026 22:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 290196B00A2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:16:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32249C0376
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:00 +0000 (UTC)
X-FDA: 85265184480.24.2F07EED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D5EB180004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMAKe7lf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+glEgPUaMq/IVUolJi4og9sx3JSPGF6OV2zZoaC1lTw=;
	b=Uesie33JB+akQJZeIYY9G3k4MfPNfDM13kgMlikJmAafqtHBYT+KQeQwm0HH/WAi19s3ck
	/FINXHDDVk+d1HUuXtPKT3ICqhIlGqfXVm2DdZWtO0ZRgCpz5QbiAbeIO+Ex5dIOeTy/EL
	CooRBsiivowE5eC3ws/GLf9zNcAHFiU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMAKe7lf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648158;
	b=z23N5QfzWIH4wb1hjZpNOQ1yxLfZnVwd8Q/BOidsdOFuyXZmUwv69ulAU3LwX4kvWdTdwY
	R8qLvsMvyPlG2u3UkKlhNKkNyRFQskdPsfOXXj2q3CuUiarOm39qX4JWn8UVvYsnFkozWY
	uRGsf5Wk3Hm6ZPGMr1jdSKMOk1qeK7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA4AE447C8;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AC40C4AF4D;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=4fCA01lVKFUQcPLwCosahsFm/a/A5bH2c66xJdLxhxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DMAKe7lftxZRvc4CM/LOqN5J6tJJPxXeFN/La7EdjfeuzswoI2CyUbjcy75d0BvbG
	 6I7myWQe06wBb62MxaNJvt2w0u9pKacjoSaH10yFZUhnC8OTuJmczh6bKP0THD7UK9
	 UTsdG81EwUMm1ZSOjJBXRv71wGXOVleJ9RHfu6cGl8FiSqstsJcFEcFIxcPwqmCSrS
	 RZUBWuluvbtrOzR+0XduDx/powj47nc69gon5GM5tKK4Ap7X3VlN1AzLw7rbhJImcU
	 A2fUUZduwl+hxd8O6mm5x7cDJVX1UPdh48LjEYz2XPuw1RNLzWit9rTw7F7ncsr+HA
	 HnAPmLARN1e1w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64053CA5FB1;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:15:56 +0800
Subject: [PATCH v3 06/11] drm/tyr: add BO creation and lookup helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-tyr-ioctls-v3-6-26955fb111d5@kylinos.cn>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
In-Reply-To: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 driver-core@lists.linux.dev, Ke Sun <sunke@kylinos.cn>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=1988;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=ZYb1XxhHAj4Uxqn92uytJJHTXG1ZVMUU2ITsdjHTgjA=;
 b=+6O6cKIGlAEi7wJ2xrjWJUVcJyAGE4JI7VGHVXVC45nRwLRPFOstS/WH7ffTqM4wmAbl2qgQp
 0wL6g38yR6PAYXBqWY6EpZx1G0+qLDnztLYkdRIgQ+c2UcVycdAYJ9W
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: whdbfdr1j3bsi35etu8ifuxq168c9wjx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D5EB180004
X-HE-Tag: 1790648158-177306
X-HE-Meta: U2FsdGVkX18IrozLJHGiL01TgMGbabp2RYhWNvmxW56vdlIXTChWIxZa5QbsqYaKzIhI6qwJ6UFkdBxo9JJU0KbfzjwCWwgWMqvfXrqhmJqmZkyc7Z0gcAVq2swyT5428UhuyPq3D9nftpIJNqvZEWK3DZ+c9nLwRBtXCG1rvZ0nFDHuhiDPzcZokVdiuYdnetpcsFkIp8YsZmCmDuGFq9xlgoNbQOQdw0hZerUpT7Iwsa+V+xs1Xr5Ezb+gyWpVaGgDrZJ98hoh5ETzpyMycSj3PQAs871AXbo5HmGpiM/8q4VLjc3MzilRt5LuoeSynOlwiQl/tU0zc6eb4wGfoDeJ57AAxXXBvkf7jv45U3hXsVxQCCv3agElOMrATvSKtnQWGS6k9wEfjyS/l7TZLtuXMAFKmzOlaa77jsdfEJbbyNWvNG9tl4pGC87QLMRCwkwE+zWX1LpWUFkszIb3t+v6jZG00+jgTVQiw5mjyAg/bDVllTa00U9HCrsoPyLzOeHWep0yw+crZKYjk4Kkfl1iPEQBnZhZiUvS0nrfnZb61YIPZD880eWxKWl1yZKBwR0eg3sIkFZoLqREYdV//BRLWLrCAW5ZBXpSdvBhYxlZfqi0YhiZYYZh6g0cFrrvvw9x+Qr7mX043oPpNhyKakbtthi0EHIsBwrG3fbGJNBR4wx3m6mRqAbHe8CYJRhRfFcXkefK9MMwpYj7Dv13u+nc46n9TQieRyQM91kS/Nc5Pt63si9lbo54BwRTdSVZI6VjN8e1nfCyZaUlzxev7dinqsrWXygxcEn4qSM9EbXoZEU3Pw6g06UEj1BuNfzJoSym0kDpbKhfuQVORHTnpDs6VBUKEv1g4UfRW3w9WV3uXsYkdrnUzDQ+ue8ppioBZQrj3hEEMECAis0gYLkOG6JFh1H0s/bXmwA2pfsaufgTso//twEsFqQ0BUs6VFvaIabTHW1oW49xPaYEtfw
 V7pdCE/5
 xkpZpi6k2SqnV8W/eah8cnv8PoKCBjfTt+UvRTme/Uj27qPxAlCgCFWZ0yLnmOtF5zyRoplS0JOfjxCDsPSp7jl2QTitA4s328qwEy+4dQ672Wlc81MkGJmMl82qol5oDZeLmz+w7AJBbJxXqu/ueyqgk1xQf1PyA0uXKKt+7tG1YIhLpEvBud+MxdHCVwMSacEhi0XgXLG7Rcr86n2Ib2n8Xd0WAG7htMhnsYZP/I3+tXwLTcid3TtSvLjPA7KrBWFeqdbIaogHNyWvkbl0uCCBni+TKvaH9f4CBqmsKz2H80WtO/bveUmqMJ0a79ZX/kGCG519k2yM9p+XSmwqsdcnACFG9EnN9F1/ACa3sEd0kBv0erViJOQsBV0JOH2zINGne
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Add helpers for the BO ioctls: new_object() creates a GEM object with
the size aligned up to PAGE_SIZE, and lookup_handle() resolves a handle
for a DRM file.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/gem.rs | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 3bf3787f5c3fd..0e0989a48678f 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -9,8 +9,10 @@
 use kernel::{
     drm::gem::{
         self,
-        shmem, //
+        shmem,
+        BaseObject, //
     },
+    page::PAGE_SIZE,
     prelude::*,
     sync::{
         aref::ARef,
@@ -23,6 +25,7 @@
         TyrDrmDevice,
         TyrDrmDriver, //
     },
+    file::TyrDrmFile,
     vm::{
         Vm,
         VmMapFlags, //
@@ -53,6 +56,32 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: BoCreateArgs) -> impl PinInit<Se
 /// Type alias for Tyr GEM buffer objects.
 pub(crate) type Bo = gem::shmem::Object<BoData>;
 
+/// Create a new GEM buffer object.
+#[expect(dead_code)]
+pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result<ARef<Bo>> {
+    if size == 0 {
+        return Err(EINVAL);
+    }
+
+    let aligned_size = size.checked_next_multiple_of(PAGE_SIZE).ok_or(EINVAL)?;
+
+    Bo::new(
+        ddev,
+        aligned_size,
+        shmem::ObjectConfig {
+            map_wc: true,
+            parent_resv_obj: None,
+        },
+        BoCreateArgs { flags },
+    )
+}
+
+/// Look up a GEM object by handle for a DRM file.
+#[expect(dead_code)]
+pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>> {
+    Bo::lookup_handle(file, handle)
+}
+
 /// Creates a dummy GEM object to serve as the root of a GPUVM.
 pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> Result<ARef<Bo>> {
     let bo = Bo::new(

-- 
2.43.0



