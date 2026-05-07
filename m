Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC77CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B9D6B00F0; Thu,  7 May 2026 19:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD826B00F1; Thu,  7 May 2026 19:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536516B00F3; Thu,  7 May 2026 19:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 392816B00F0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:33:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03DA71C053D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:04 +0000 (UTC)
X-FDA: 84742226730.06.55825C9
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0D92E140003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=bLnOMmQF;
	spf=pass (imf23.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778196783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTqw3jc94opHT2uoxPiQwEHdp0J+oq/GgnCRmE7vr4k=;
	b=Omme1qsNNbX/E//V4GIAtqWBiejH93jzlQPTX8Eb3IcwdWJzEgUDa5/JqRg1ggxkz65hMA
	YLpObhDIkUAySIx7IZv/k6M5IpxBIFr4/wsuSsMBnr4EftVTyPqrrSnxFC3i52jRnnxYyy
	iPtXLvsWkjnpD3D/ap0sKHHQdHTkOD8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=bLnOMmQF;
	spf=pass (imf23.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778196783; a=rsa-sha256;
	cv=pass;
	b=fUjYGSEwFDEYVs6xTGJi6k16neaJNt1x3U/sqQd6kOg83GoBrv/ipE+MFJuSApwUCPAXzQ
	qzaRlDwkP1WvBqZRgyB0r2U6s1+r6PgjfhYu9EkCjWU9JrymjUr+i2AeI0gVF3yLG9eYKQ
	LEIniKnVuDqcb/q/9R2OidFgvKzlJAc=
ARC-Seal: i=1; a=rsa-sha256; t=1778196769; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=B0gKagO8Brbvh2dtH5CQYZF2oKOX1R9r00JZZXK0C/iTD1gP7WcdolnilHRz+nxsadSp3JLoGQ2mJUqSLAjTB3vgmwVNPU8Ld/3d5nBpZ/eEFCAWvZyTe64YmfahP4hF+5xh2T9wLE389CqEouzCmhabS/BLxzCsWyg2ByRc2iU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778196769; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vTqw3jc94opHT2uoxPiQwEHdp0J+oq/GgnCRmE7vr4k=; 
	b=Nw9RcZPiylbkyhrkkXx1dRyClrdga9qu4TyCwlawcXmmCnQRnVSK7f8bEM41UYcaVCcC7pz55Z68aHKix9vF0Z68bksprpkN2X/6f8JXXVTdusgU07FqwrphEhQvyNMTIP3NyiXev8Crl/XKkdkrCMlJaY49D4//sQSHLuoE3ng=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778196769;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=vTqw3jc94opHT2uoxPiQwEHdp0J+oq/GgnCRmE7vr4k=;
	b=bLnOMmQF4ag3NVS7UO6/9eDpodF6H9woyCqEw7csrAXF8k9EjvauGMOcl61iA+5f
	xa79o6hQJ8k0sgn4VJl8ZQVugR1i1Wc8LjfnxQktMwz4bz9jQBb/70xOQJBbXAMLq46
	QFuTH9PRyGEdrFOJAt2+gpZMLN3209lJxN0iy27w=
Received: by mx.zohomail.com with SMTPS id 1778196766791583.476563743686;
	Thu, 7 May 2026 16:32:46 -0700 (PDT)
From: Deborah Brouwer <deborah.brouwer@collabora.com>
Date: Thu, 07 May 2026 16:32:41 -0700
Subject: [PATCH 3/7] drm/rust: add File::device() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-tyr-mmap-v1-3-eec048a23c25@collabora.com>
References: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
In-Reply-To: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Daniel Almeida <daniel.almeida@collabora.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 boris.brezillon@collabora.com, beata.michalska@arm.com, lyude@redhat.com, 
 acourbot@nvidia.com, work@onurozkan.dev, alvin.sun@linux.dev, 
 Laura Nao <laura.nao@collabora.com>, 
 Deborah Brouwer <deborah.brouwer@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1560;
 i=deborah.brouwer@collabora.com; h=from:subject:message-id;
 bh=LS72whzBPfI8wJ5XGKSFg2YZwraPxlufzrfYFanpH6w=;
 b=owGbwMvMwCVWuULzOU9c7WvG02pJDJl/FSXnnEoSj0v+Wfl/wVnruTPaf/gLX4m8/LJBe/f/a
 cYFOw6v6ShlYRDjYpAVU2Q5a2/UI1713kh3/v9mmDmsTCBDGLg4BWAitzwZGY6YKvGG9RQcXhii
 W3zB4vOz1xrsy18UJRiffv4+eadU+VlGhns2Zmv/hSrNiXAzEE1sdOJMLAlzOVi3hV1Gc975G0Y
 /+AE=
X-Developer-Key: i=deborah.brouwer@collabora.com; a=openpgp;
 fpr=CD3F328C177AEF322D9FFF8379A829E70C5E7DEB
X-Stat-Signature: hmhknxje7jmc9fnp38mtwj8u77sx7hnd
X-Rspamd-Queue-Id: 0D92E140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778196782-383556
X-HE-Meta: U2FsdGVkX1/DfODaJH3NuNGVYe1k/DOweRQNbtqUKMOC5oUVnLRtM5iJhR1kJ2pZmyAYkZaj4aFWFj5mbTgMhiI4J2ii1qVFuRd9y4XG+GLO9s0JIxFxl70rgS3uK/pUrohVc7kF9u1NrQq0OwqjZlhGZSBBYsis9QKQtxxnOocc8Ab8v1sab6OX6ZftAMm9O6V5ro9voOdRHYS4YtDFCeWj9Nl3c5WD5WnYju79Oe4w9Ubg/q6thxTG2FCHFRLSOoKoKOgr/Wd+XjW+6UIyIi7+bxSiWvBlqF16adIRWrR+Sb7aAgB7BwBpQ1laR7VJ2LrNkhleWlxD119+nu5/z+6kvfYC6IXpnfZ4AL83PUCS9WGvJ1WzQdUfOIzfYmKi9avrfdsf6Fqa1VTo7PUoiu34FoVZxgWSQkxgmvjazSfg+9ByWfnnimKeZ0/fLhONPOCYn/DROpY+pQPOoM3jybMDlJKAuCGiFcckL9fZmLLa6u3A1cboLlaxOLbskpT2cz+SR5a1wfy6cJYcVbNpfkfW4aMvgRxkgbrzu8E8eohJrzvVae/RSxya3EQsnvemWJlzp9Sa9buo1kQgrgnKHcwm3G/Zz5fIPRyxmQG6jQdC11YwQk0VpejmFpVRQne9+FF9RdUC1feVVv0nIEBsKp+zO22ZmpaadrVXRKqoWmcVV3vzcdWAvGlQXOVqucENoc0ZISeWx7BTn8PKqczOW8R7I62pN1sFvsPtjuIZWPgaSVyNQYaGYsRCKHcUVjdp/w3J3rq0Mo0ErzN2VCTRevBPjila8i5XQXAOIj4o/VH3WYaNQbPu4VKn73lf5duOrv/xmzfYmfU1WIDF1dh29VvtxZM5xMIU/5PobnJ8D7mP2cMg5Q2mluffCg/v3ycPbTM7L2nGeRGYdN7LA9mpkhsSBAngP8uR7nm2x0o3tjAeHN7CoLrQ1qCEV+BCzAP4omPi32Rqnh662hQcHDg
 wy1oarhf
 y+bSeIYc3hqtTmY1qVRCtc2GrnCkbXYDrOMyUi8iB+D4vmCqVACnY7CIwam5y0Xhu6Qkh85fMCBVnuYi/J0lO7UQyw7DxXSXlInUG5Q+MvxLgoceQpAJvP453rMiMS8EqgrIBPB0frawNq3T+9bU/WMqtt+uLD5sPdR/02z++Z4NEPEpluRVwl8eXdGyi/0wV4yu7JXaOro7osIy3o3gV7UKxS4i13A5jjalNn74bzH5s8e6ddogCvlqcZ0GGKk3cEndN7S1CZ6k0TJjjwl6Qyerr0k4NqpelC/HLiVowoTvVkMfU5+/YcmZOOjKY9R9MmbRZSWjCUgXgVtUQQyLpkr+HVXhyqc/Kc/Um+fqQ+1Ep+oU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper to retrieve the DRM device associated with an open
`drm::file::File<T>`.

This wraps the common pattern of traversing `drm_file.minor->dev` and
returning the corresponding `drm::Device<T::Driver>`.

This is useful for DRM file operation callbacks that need access to the
owning DRM device from a `File<T>` reference, avoiding repeated open-coded
raw pointer traversal in drivers.

Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>
---
 rust/kernel/drm/file.rs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/rust/kernel/drm/file.rs b/rust/kernel/drm/file.rs
index 10160601ce5a..5af28a9558e9 100644
--- a/rust/kernel/drm/file.rs
+++ b/rust/kernel/drm/file.rs
@@ -45,6 +45,18 @@ pub(super) fn as_raw(&self) -> *mut bindings::drm_file {
         self.0.get()
     }
 
+    /// Returns the DRM device associated with this open file.
+    pub fn device(&self) -> &drm::Device<T::Driver> {
+        // SAFETY: By the type invariant, `self.as_raw()` points to a valid open
+        // `struct drm_file`. DRM initializes `minor` for open DRM files, and
+        // `minor->dev` points to the registered DRM device associated with this
+        // file.
+        unsafe {
+            let minor = (*self.as_raw()).minor;
+            drm::Device::from_raw((*minor).dev)
+        }
+    }
+
     fn driver_priv(&self) -> *mut T {
         // SAFETY: By the type invariants of `Self`, `self.as_raw()` is always valid.
         unsafe { (*self.as_raw()).driver_priv }.cast()

-- 
2.53.0


