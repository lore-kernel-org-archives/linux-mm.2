Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB92CD37AF
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622396B00E6; Thu,  7 May 2026 19:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA0A6B00E8; Thu,  7 May 2026 19:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5365F6B00E9; Thu,  7 May 2026 19:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35F746B00E6
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:33:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C73531C1408
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:32:59 +0000 (UTC)
X-FDA: 84742226478.17.70EBE57
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8848A0002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:32:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b="TXkUciE/";
	spf=pass (imf25.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778196777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCMt4Wqtp340hUTxlyZxiVOiVlULGTbK7i1z5h8C21U=;
	b=loj15Fo0oRPziGOWv/YUctww7OH7zOL3YDj8pRZ/gmFgbsg5D449dEQmW/iDh2hQn7mpjw
	93ddbQa349UbjbK+jiJzR2DCbzcBSkr4Ks0L1QVtcaEAifpq8+T7lnf6EOUBjhihRTGmDE
	z7DlODA2B2VpxvgZf3OS88Cck0Ak/3I=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b="TXkUciE/";
	spf=pass (imf25.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778196777; a=rsa-sha256;
	cv=pass;
	b=pDZvBmQahzkSAgiz36+4rZF9Zha1/hc3BsziTWFUxhH9kVX48jfovCO4h6bsXV0KKYGv4O
	RXZ2olUfJkd3QZD8fBTWtoWPSP4FWiVZbuocU/2tTj6MXgoq7OZOrw4agLTjB5VujMbYy/
	TaN6T5+bBFDHehWLLkXg3SGSKMnw3Yw=
ARC-Seal: i=1; a=rsa-sha256; t=1778196769; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QBQGgnzSiXMZRek/wVE5S4DwcwZhlyUc607ZZuhr9U9a0Mr7rIYQeXY1TcBf+x+tIby3dX7O2LdnTZJmJpMIx9hvhGob9cIcNOlVESEy0ZoK74JTzsnpkUejKjeGl7XrA+uhrvVtxZLa4hopwDTVmJRtNHslI5cpAjm8w0Bc09g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778196769; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=oCMt4Wqtp340hUTxlyZxiVOiVlULGTbK7i1z5h8C21U=; 
	b=Wbreo7nBgKEmHWiQADc9Wu+HdVBBGtfl6kBsl4W3fAYzWvNRdZZ8sfFH+qCk1S9wo696r9i6T5850UWf/J7gSf3x9yS58rcPq+4CwAmnJ6uns5XPfRY3D8t+K8ofdqWB3cCPNw/DLohouaOZGfnAkmAMSYnAKd1sPY2Q6Mo7vKc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778196769;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=oCMt4Wqtp340hUTxlyZxiVOiVlULGTbK7i1z5h8C21U=;
	b=TXkUciE/cJKYDXsmS5Oe9NPWvT9tdlEtg/c64LaikWuN8aDow1v4IXdLT9fQdiEG
	PZZ9qUbhMa6xj+/qu4r+/levKLwnmHM/r6VNmXcqPfNviynQWu8YS83xs0QLVs2Gkep
	4bn1fri7SbgufExEbMGbbsCZW5DmeyxxFhmIA2Es=
Received: by mx.zohomail.com with SMTPS id 1778196767897434.22785911951655;
	Thu, 7 May 2026 16:32:47 -0700 (PDT)
From: Deborah Brouwer <deborah.brouwer@collabora.com>
Date: Thu, 07 May 2026 16:32:42 -0700
Subject: [PATCH 4/7] drm/rust: allow drivers to override file operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-tyr-mmap-v1-4-eec048a23c25@collabora.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2654;
 i=deborah.brouwer@collabora.com; h=from:subject:message-id;
 bh=snKSqFTk/LCWniRtE2VzwTiY0L106zF+84qJmJfsNZI=;
 b=owGbwMvMwCVWuULzOU9c7WvG02pJDJl/FSUjbJZszlCUvRzy/8xh163PDNgnH5E02fXkyvXlv
 BKVqdN2dJSyMIhxMciKKbKctTfqEa96b6Q7/38zzBxWJpAhDFycAjCRCxsZGY5xTLm8847Lppvf
 eBsSLq9JuakwcQXDHp7HK0qL63Qu+p5g+B/tbXzSdzv/vxUSyu7uL7WWarULa5kyzM8vceRaOtv
 iFSsA
X-Developer-Key: i=deborah.brouwer@collabora.com; a=openpgp;
 fpr=CD3F328C177AEF322D9FFF8379A829E70C5E7DEB
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8848A0002
X-Stat-Signature: k6kcanqn5kiy16jw9hrt7kmukgn8f9rm
X-HE-Tag: 1778196777-330418
X-HE-Meta: U2FsdGVkX1+ptnJ0WDULvYX4ZZqaMWOhKv8ERI3VAXqD7OPaOEMdvP1SSmnC2zmh7u4KxReF6eHApg9aES1DGslI8oW6iIMn6wLAB9IARtBPMuCw0Ga8JJW0mGcMfVeGfabv94JPuwTFEjTQQ6UDd0S5m5cOHNIfPtNcUzafgRuZm2IeciPcLG6P2uLwGPfE2YQIaGJtZHXlWYIgs5TdjbgpS2f2SntGZR8FIOTGmP9rLl9+9V2gZaZl3NfGJm52sbMDid78lXjl5gh7pWORC6mR9C+qrKz76a4B1r9HzLT9rM5adDugEOxiqjdwnG8khGIUDCNkmiBuQfu89JGjz+ha34L48upxmgTBzUhYFlVswV0eMxpADMPheOxgNYekwXksPHqhkqQx9PejNsnlfxVP14WivOUBIp/ZujkqMVLavjkdK5BkVYm9Fa+7KMPho33f9MtOaSYHURfbLcWMmJsF2lEsoAg1WdxYCK0jGrJ8h858/0/PiZNQjV8H27gg1ty2vAAGIjAL5jxd7Nh9B0YXFdjWggBahTeWVCSnZFE7g7nS8sDDvPTUXgcHB8zVZXfHzVjAKBYX0PO5vy7raD+wKOzQky+ouqHEOcIAhHCuJ1T/hXEdXUNmC9CSephrwlqrwMiKQVyxX4vasJuSsJz2Y6ecH5w7fYwY+dVcwi9HUATY/N3e9ugtnzf/OZ6VRSlBaxXhCtdaMLBXR9Lx3NW27nmcgrfxfGqd9+XdYvxnAcyRmkjBRpn7J0/XIbxeKm01LIGpqIcDEGdD+h3SMw6SIwvX4dW6SWzkA6ZHAJp5WOUkuKZUEnymDghIG/Y3HszDrov6JXQYuEN6En4aPKfXkGcmbFpioJ7NY9CUS0YiODR0Htsw8B+A2t4uqqIy92PT/k0APBkq0vzxras+aPbAiWV/AmIrFzwPUc9dgO/clVrE3FoXMGyQFSG81EtM1aZkxRg9T5BaiI4UaiR
 ADt6N3eM
 sfVnogandqP6/XuHz19QNe2nyGaBTELcmau++/hTS3cepmcO0F82d3v2w6jtnd7arCQ3HMY70tNSj+rUqFfZUqX7jurBbPzJvq57Yt374+xVgScTj3bbp/mJ1vlRhBy0Re/CPkNNIQy5P22QdZ/CN6lHFlUCuxU0qY2mqB0XpcesBT3H89/DE2fuM34FYYnPZ6T1sjeM+3UvG7gEdwc5kzQzF2XaoWRkXJ6BWysjfvagBiPJpJ0xDU9Lk5YC26N8y12DnBfjSPURwIJeqxvFGNRWGctdv+mdeKgwjJIzDSAUg+mq1YhGQpyhhTdAdkZc2w6gsXsGtwl2beJkczMrUibie0JJo4PB180Kg/9SN/aCb6ZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a Driver::FOPS associated constant so Rust DRM drivers can override
or extend the default file operations table.

Use the driver's FOPS in drm::Device instead of always constructing the
default GEM file operations internally.

Also make drm::gem::create_fops() public so drivers can build on top of
the default GEM handlers while overriding selected operations such as
mmap.

Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>
---
 rust/kernel/drm/device.rs  | 4 ++--
 rust/kernel/drm/driver.rs  | 6 ++++++
 rust/kernel/drm/gem/mod.rs | 3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/drm/device.rs b/rust/kernel/drm/device.rs
index adbafe8db54d..82760a9a426e 100644
--- a/rust/kernel/drm/device.rs
+++ b/rust/kernel/drm/device.rs
@@ -108,10 +108,10 @@ impl<T: drm::Driver> Device<T> {
         driver_features: drm::driver::FEAT_GEM,
         ioctls: T::IOCTLS.as_ptr(),
         num_ioctls: T::IOCTLS.len() as i32,
-        fops: &Self::GEM_FOPS,
+        fops: &Self::FOPS,
     };
 
-    const GEM_FOPS: bindings::file_operations = drm::gem::create_fops();
+    const FOPS: bindings::file_operations = T::FOPS;
 
     /// Create a new `drm::Device` for a `drm::Driver`.
     pub fn new(dev: &device::Device, data: impl PinInit<T::Data, Error>) -> Result<ARef<Self>> {
diff --git a/rust/kernel/drm/driver.rs b/rust/kernel/drm/driver.rs
index 5233bdebc9fc..79218c482fce 100644
--- a/rust/kernel/drm/driver.rs
+++ b/rust/kernel/drm/driver.rs
@@ -115,6 +115,12 @@ pub trait Driver {
 
     /// IOCTL list. See `kernel::drm::ioctl::declare_drm_ioctls!{}`.
     const IOCTLS: &'static [drm::ioctl::DrmIoctlDescriptor];
+
+    /// File operations for this driver.
+    ///
+    /// Override to replace or extend the default GEM file operations. The default
+    /// provides the standard GEM mmap handler via [`drm::gem::create_fops`].
+    const FOPS: bindings::file_operations = drm::gem::create_fops();
 }
 
 /// The registration type of a `drm::Device`.
diff --git a/rust/kernel/drm/gem/mod.rs b/rust/kernel/drm/gem/mod.rs
index 75acda7ba500..de7222ee0542 100644
--- a/rust/kernel/drm/gem/mod.rs
+++ b/rust/kernel/drm/gem/mod.rs
@@ -348,7 +348,8 @@ impl<T: DriverObject> AllocImpl for Object<T> {
     };
 }
 
-pub(super) const fn create_fops() -> bindings::file_operations {
+/// Returns the default GEM [`bindings::file_operations`] for a DRM driver.
+pub const fn create_fops() -> bindings::file_operations {
     let mut fops: bindings::file_operations = pin_init::zeroed();
 
     fops.owner = core::ptr::null_mut();

-- 
2.53.0


