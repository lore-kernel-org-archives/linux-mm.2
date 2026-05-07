Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763D7CD37A7
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC726B00EC; Thu,  7 May 2026 19:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954BF6B00EE; Thu,  7 May 2026 19:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D596B00EF; Thu,  7 May 2026 19:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6934F6B00EC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:33:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31EB41C1407
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:03 +0000 (UTC)
X-FDA: 84742226646.16.825C877
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf19.hostedemail.com (Postfix) with ESMTP id 423621A0007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=MnkldRWQ;
	spf=pass (imf19.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778196781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/XdomGjzO6TaGgEy01tAz1U0X64Q5ShHRM2G3apMkc=;
	b=zkdi5K1FjrClTIBCY8E1SwNmu9ySrRK/5REqIS2h7kyYJTPrOo5diAvyFzVA8ksQfG41DW
	kZIwFUSOws4xGbPtfDtGKqTmehxah8ozIylhstnL8cLcEQRmsGsbrP0MOWo82ZwpPeFs6r
	9LrqRKFfWaGnBqy93YYszr5PJBeYyHY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=MnkldRWQ;
	spf=pass (imf19.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778196781; a=rsa-sha256;
	cv=pass;
	b=pfU4Ii8okYeCGCAyLHBcvD0eak5VRFGEVBLndkiMpzyAhtfWLPh9/FGTi+wDy+wAl6EuWD
	t82q020Kv9Lzu5Fv1aEGFwtPLHJh++J6HgtDM70ATtLeFG2LdSvnbMNOTLYeTat3A4uCBU
	DR4nRdr96GCHZ8mnfNZkG0fhT6FnRHA=
ARC-Seal: i=1; a=rsa-sha256; t=1778196773; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bcgmC243E3hWK2Dpd6PuZBK6ZXfBsMRUenWP9KMXpxJyBf6b4yHAfxdzZJ1Q/uDRhZoWn7TYUOBxN+U7/f+qbUjR/JvLKmh+CKXnOxFLUyEuRlGdaecIq42Oov9HIz7G24gLQXb1ypX8dk4CO6qiFnOks9iPEl0u6CitelNi2Qg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778196773; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=S/XdomGjzO6TaGgEy01tAz1U0X64Q5ShHRM2G3apMkc=; 
	b=FMgOvvI2V3lbJtwaSZOifCFMwBtTWdSslOy0rPbyjaR3nH1gZUcFIiWCT+br53HVdKEXXJuAR+eJplaR5zcYz0i5P+1W9clZZlUnqPLjOFjihOcvi+F0nwFWey9/u9ipbteH83LiBQNF4Hwe7mNqy5SmXmphnOkAOlydpSfJ69Y=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778196773;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=S/XdomGjzO6TaGgEy01tAz1U0X64Q5ShHRM2G3apMkc=;
	b=MnkldRWQ2SaV5EmkYzb4hVTOhXEMmlahW5t1Rs4qNf3tYm3UHu6xsvyWhTRkbwJ3
	p7Q+ddm5y71YyplBashEKAKx1MnCW2FObY2NhcDRuGpwWjOY80esMTYgKmBJT/HciiH
	q8AjFlC4GEj2MyTphHMbYVU0lrbHtkKrEhFsxlpQ=
Received: by mx.zohomail.com with SMTPS id 1778196771052376.342991168034;
	Thu, 7 May 2026 16:32:51 -0700 (PDT)
From: Deborah Brouwer <deborah.brouwer@collabora.com>
Date: Thu, 07 May 2026 16:32:45 -0700
Subject: [PATCH 7/7] drm/tyr: add userspace MMIO mmap support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-tyr-mmap-v1-7-eec048a23c25@collabora.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12374;
 i=deborah.brouwer@collabora.com; h=from:subject:message-id;
 bh=/jHhUub854UYefV++9aQ6NhPfxKrdfLhibAb8NJgRps=;
 b=owGbwMvMwCVWuULzOU9c7WvG02pJDJl/FSXnKxmL8peoZJ+xY+3RfLDz5fm6bQ372U6KBMm/P
 ygQbjG9o5SFQYyLQVZMkeWsvVGPeNV7I935/5th5rAygQxh4OIUgInwijD891jN7mx+wumRW+Xa
 ChuZLfOydPPkE2umeizTUrs342zGBYb/4QK8svdP1zJ6aFRyFPQsv1L8n68g84/fPX3lDXXxR5f
 zAQA=
X-Developer-Key: i=deborah.brouwer@collabora.com; a=openpgp;
 fpr=CD3F328C177AEF322D9FFF8379A829E70C5E7DEB
X-Rspam-User: 
X-Rspamd-Queue-Id: 423621A0007
X-Rspamd-Server: rspam06
X-Stat-Signature: 4y6f15i57xzioun6ytyg7ihjo9zerwar
X-HE-Tag: 1778196781-877891
X-HE-Meta: U2FsdGVkX1+3rAbBT7Np6CGnP9Kp7RoAOT6GtLueLkbx9tfbnzbPHu3dXQdSpPN2ai+4c7kMfwjP0SkvVLo2J6oe5nW/eNlNXIo3JUTxkUms/JIeRqInD8Ml2sYWFa5I8sTj6LN4y9Hl6zvVqCY1IWPigT2Z906WW1j/Su48V1VIfsU52MUgm8JUKdRdNYasNfDycRshiRE9wAlMFtOq3QQBUWat363/iVslmFq6XMuQM3man/8vAbY1qLlG/KYHAWYgrIFGjgsqoOZuLxG8iCUhb8NqG3PazVkJ6lAniIe7oxU4+jumbgjsZMiRQ0Ro/bf1jPldIgeTKaZcg6q3NjcpE0UAiJcOIxOfmFA7uqHwVVFM9pXQFhmPM5yhPBiMjIzJtTSTYjPRINTSB7MfQQkBgdReojRI75FpRxVe9PdpdvHJtuz8Th8zLUD+JiIE0dhjjKUqYl3gFN+bToLvULwqVWm+mTfpxmJSo0mG1Pg065JNNdaJd7svPn6CyXeyYwS76oJvuv6/R0CCVURj6q7m0bAUkmekI3AO2KUwx5zMQ2OHxGP3o9s4/ug0RHl7XwSJWG3kBGFIJ2v1vaaTWJ3YGKcwc+GTFnDOisjFVlzrXST6D8d0Asul3vy2MQr3wrYYWw7Jv/8YsDqQpCVuoTjRV+nyG67mVp/B4TMPSA4beAWEPVGVCEb0j7FOQNlMdYVytbos0HZv8qttPqqfd7XPvqKYxk7w2MhLfRgyleXRJsxp9/7v5Uu1fkOUTvxq+NYPdAzalIVo79mDjl0AtMSrmf7qE6gGES0jFVIMp7+aOHPI8plagH9gebUHF7tH3k3yXLnvhZw7xMRuyC8G63XA0Y9Ay4PJaMlJUiNy0JkxwNDcMxqzATB5q4LgOFmio00Ov9OvMMgxnYD4yx7xvxxToLExwoUW65HM1O+rI/77AL6Le1OhpTik2wZslxPmPcsvlqe2Bn84b9qjZ+t
 e0c0V0vE
 9wRw5t8aXjrpvrbcZqBk1Fc0edAnoX28RLbIRrLipSEa1VpWcCeyPuBLlX03o+KpYbp3Kip4Lemr61DSklmEOsu2qi4Zx4Inbo9gLOOMwQdEylwTeVW6G20CBhFOgbwXsupFNcZ0QnPHE2jlLwLkJjTJuRcg9Q0NVOXazN5jZFlVFl+8EUP+QRd2KGVnsHIr7+DnUx2dDyb2sQPPlPklqWIcrAa/cprrC6EYqkevVt9c8l+0p6RIPkqz+5cxC5yXcj1U0Pw3FbjluRN3JS0d1VeG90bRDU7/w4TrKhW93GCCrySGo+33V4F+euKvRi7aROYaBisHAHqaMpaNloZdgRElgSYBZ8WoabGqNPF36haz85PY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a Tyr-specific mmap handler for Panthor-style userspace MMIO mappings.

Build Tyr's file operations from the default GEM fops and override only
the mmap callback. The callback intercepts the reserved user MMIO mmap
range and falls back to drm_gem_mmap() for normal GEM mappings.

For now, support the USER_FLUSH_ID mapping. The mapping must be shared,
read-only, non-executable, and exactly one page. Faults insert the page
frame number (PFN) for the LATEST_FLUSH MMIO register with a non-cached
page protection.

Co-developed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>
---
 drivers/gpu/drm/tyr/driver.rs |   4 +
 drivers/gpu/drm/tyr/mmap.rs   | 247 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tyr/tyr.rs    |   1 +
 3 files changed, 252 insertions(+)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index 2ba0a22a225b..0d2965e3c9ad 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 or MIT
 
 use kernel::{
+    bindings,
     clk::{
         Clk,
         OptionalClk, //
@@ -42,6 +43,7 @@
     gem::BoData,
     gpu,
     gpu::GpuInfo,
+    mmap::FOPS,
     regs::gpu_control::*, //
 };
 
@@ -196,6 +198,8 @@ impl drm::Driver for TyrDrmDriver {
     kernel::declare_drm_ioctls! {
         (PANTHOR_DEV_QUERY, drm_panthor_dev_query, ioctl::RENDER_ALLOW, TyrDrmFileData::dev_query),
     }
+
+    const FOPS: bindings::file_operations = FOPS;
 }
 
 struct Clocks {
diff --git a/drivers/gpu/drm/tyr/mmap.rs b/drivers/gpu/drm/tyr/mmap.rs
new file mode 100644
index 000000000000..5698656faa8a
--- /dev/null
+++ b/drivers/gpu/drm/tyr/mmap.rs
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0 or MIT
+
+//! Memory-mapping support for the Tyr DRM driver.
+//!
+//! This module implements Tyr's DRM `mmap` file operation. Normal GEM buffer
+//! mappings are handled by the standard DRM GEM mmap path
+//! (`bindings::drm_gem_mmap`), while special Panthor userspace-MMIO mappings
+//! are handled directly by Tyr.
+//!
+//! # Userspace MMIO mappings
+//!
+//! Panthor defines reserved DRM mmap offsets for exposing selected GPU MMIO
+//! pages directly to userspace. These are special uAPI marker offsets, not
+//! hardware register offsets.
+//!
+//! Currently the only supported userspace-MMIO mapping is the flush-ID register
+//! page ([`DRM_PANTHOR_USER_FLUSH_ID_MMIO_OFFSET`]). This mapping exposes a
+//! read-only, non-cached MMIO page that userspace can poll to observe GPU cache
+//! flush completion without requiring a kernel round-trip.
+//!
+//! The VMA for this mapping is configured in [`mmap_user_mmio`]. Physical MMIO
+//! pages are inserted lazily through [`VM_OPS`] and [`vm_fault_handler`] when
+//! userspace first accesses the mapping.
+
+// TODO: When runtime PM support is added, userspace-MMIO mappings must be
+// integrated with suspend/resume. Accessing this MMIO page while the register
+// bank clock is disabled can hang the device. Runtime suspend will need to invalidate
+// existing userspace-MMIO mappings, and mmap/fault handling while suspended
+// should expose a dummy zero page instead of the real MMIO PFN.
+
+use kernel::{
+    bindings,
+    drm,
+    error::code::*,
+    io::register::Register,
+    mm::virt::{
+        flags as vma_flags,
+        VmaNew, //
+    },
+    page::{
+        PAGE_SHIFT,
+        PAGE_SIZE, //
+    },
+    prelude::*, //
+};
+
+use crate::{
+    driver::TyrDrmDevice,
+    file::TyrDrmFileData,
+    regs::user::LATEST_FLUSH, //
+};
+
+// Reserved Panthor mmap offsets for userspace-MMIO mappings.
+//
+// These offsets are special uAPI marker values used to distinguish
+// userspace-MMIO mappings from normal GEM object mappings in the DRM mmap
+// path. They must match uapi/drm/panthor_drm.h exactly.
+//
+// These are not GPU register offsets or physical MMIO addresses.
+//
+// Tyr currently supports only the 64-bit Panthor mmap offsets. Panthor also
+// defines 32-bit compat offsets, but that path is not implemented yet.
+const DRM_PANTHOR_USER_MMIO_OFFSET_64BIT: u64 = 1u64 << 56;
+const DRM_PANTHOR_USER_FLUSH_ID_MMIO_OFFSET: u64 = DRM_PANTHOR_USER_MMIO_OFFSET_64BIT;
+
+// `vm_pgoff` stores mmap offsets in PAGE_SIZE units rather than byte offsets,
+// so convert the Panthor uAPI mmap marker offsets into page offsets before
+// comparing them against `vm_pgoff`.
+const DRM_PANTHOR_USER_MMIO_PGOFF_64BIT: u64 = DRM_PANTHOR_USER_MMIO_OFFSET_64BIT >> PAGE_SHIFT;
+const DRM_PANTHOR_USER_FLUSH_ID_MMIO_PGOFF: u64 =
+    DRM_PANTHOR_USER_FLUSH_ID_MMIO_OFFSET >> PAGE_SHIFT;
+
+pub(crate) const FOPS: bindings::file_operations = {
+    let mut fops: bindings::file_operations = drm::gem::create_fops();
+    fops.mmap = Some(mmap_callback);
+    fops
+};
+
+/// C-callable mmap file operation entry point for Tyr.
+///
+/// Handles the special Panthor flush-ID mmap offset directly and falls back to
+/// [`bindings::drm_gem_mmap`] for normal GEM object mappings.
+///
+/// # Safety
+///
+/// `filp` and `vma` must be valid pointers provided by the kernel mmap path.
+unsafe extern "C" fn mmap_callback(
+    filp: *mut bindings::file,
+    vma: *mut bindings::vm_area_struct,
+) -> core::ffi::c_int {
+    // SAFETY: `filp` is a valid DRM file provided by the mmap callback. DRM open
+    // initializes `filp->private_data` to point to the associated `struct drm_file`,
+    // and the object remains valid until the file is released.
+    let drm_file_ptr = unsafe { (*filp).private_data.cast::<bindings::drm_file>() };
+    if drm_file_ptr.is_null() {
+        return bindings::EINVAL as i32;
+    }
+
+    // SAFETY: `drm_file_ptr` is a valid pointer to the DRM file associated with
+    // this open file descriptor, obtained from `filp->private_data`.
+    let drm_file = unsafe { drm::file::File::<TyrDrmFileData>::from_raw(drm_file_ptr) };
+
+    let device = drm_file.device();
+
+    // SAFETY: This is called from the DRM mmap file operation, so `vma` is
+    // undergoing initial setup for the duration of the callback.
+    let vma_new = unsafe { VmaNew::from_raw(vma) };
+
+    match mmap_user_mmio(device, vma_new) {
+        Some(Ok(())) => 0,
+        Some(Err(e)) => e.to_errno(),
+        // Fall back to the standard DRM GEM mmap path for non-userspace-MMIO
+        // mappings. This matches the default GEM fops created by
+        // `drm::gem::create_fops()`, whose `.mmap` callback is
+        // `bindings::drm_gem_mmap`.
+        //
+        // SAFETY: Called from mmap context with valid `filp` and `vma`.
+        None => unsafe { bindings::drm_gem_mmap(filp, vma) },
+    }
+}
+
+/// Handles Panthor userspace-MMIO mmap requests.
+///
+/// If the VMA offset does not refer to the Panthor flush-ID mmap offset, returns
+/// [`None`] so the caller can fall back to the normal DRM GEM mmap path.
+///
+/// If the offset refers to a userspace-MMIO mapping, validates the requested
+/// mapping parameters and configures the VMA for MMIO access. Returns
+/// `Some(Err(...))` for invalid MMIO mappings and `Some(Ok(()))` on success.
+fn mmap_user_mmio(device: &TyrDrmDevice, vma: &VmaNew) -> Option<Result> {
+    let pgoff = vma.pgoff() as u64;
+    if pgoff < DRM_PANTHOR_USER_MMIO_PGOFF_64BIT {
+        return None;
+    }
+
+    if pgoff != DRM_PANTHOR_USER_FLUSH_ID_MMIO_PGOFF {
+        return Some(Err(EINVAL));
+    }
+
+    if (vma.flags() & vma_flags::SHARED) == 0 {
+        return Some(Err(EINVAL));
+    }
+
+    if vma.end() - vma.start() != PAGE_SIZE {
+        return Some(Err(EINVAL));
+    }
+
+    if (vma.flags() & (vma_flags::WRITE | vma_flags::EXEC)) != 0 {
+        return Some(Err(EINVAL));
+    }
+
+    if vma.try_clear_maywrite().is_err() {
+        return Some(Err(EINVAL));
+    }
+
+    vma.set_io();
+    vma.set_dontcopy();
+    vma.set_dontexpand();
+    vma.set_dontdump();
+
+    let vma_ptr = vma.as_ptr();
+
+    // SAFETY: The VmaNew invariant guarantees the VMA pointer is valid and that the
+    // mapping is undergoing initial setup, so mutating VMA fields is safe.
+    // vm_private_data stores the DRM device pointer for the fault handler; the DRM
+    // device outlives the file and associated VMA.
+    unsafe {
+        // This VMA maps raw MMIO PFNs rather than normal memory pages.
+        (*vma_ptr).__bindgen_anon_2.vm_flags |= vma_flags::PFNMAP | vma_flags::NORESERVE;
+
+        // Store the device pointer so the fault handler can recover it later.
+        (*vma_ptr).vm_private_data = core::ptr::from_ref(device).cast_mut().cast();
+
+        // Install the VMA operations for handling MMIO page faults.
+        (*vma_ptr).vm_ops = core::ptr::from_ref(&VM_OPS);
+    }
+
+    Some(Ok(()))
+}
+
+static VM_OPS: bindings::vm_operations_struct = bindings::vm_operations_struct {
+    fault: Some(vm_fault_handler),
+    // SAFETY: Zero-initializing vm_operations_struct is valid because unset
+    // callback fields are represented as NULL function pointers.
+    ..unsafe { core::mem::zeroed() }
+};
+
+/// Page fault handler for userspace-MMIO VMAs.
+///
+/// Used for lazy insertion of the MMIO page into the VMA on first access.
+///
+/// Handles first access to the userspace-MMIO mapping by inserting the
+/// corresponding physical MMIO page into the VMA with non-cached protections
+/// via [`bindings::vmf_insert_pfn_prot`].
+///
+/// # Safety
+///
+/// Must only be called by the kernel fault handling machinery with a valid
+/// `vmf` pointer.
+unsafe extern "C" fn vm_fault_handler(vmf: *mut bindings::vm_fault) -> bindings::vm_fault_t {
+    const VM_FAULT_SIGBUS: bindings::vm_fault_t = bindings::vm_fault_reason_VM_FAULT_SIGBUS;
+
+    // SAFETY: `vmf` is a valid fault descriptor provided by the kernel for this
+    // vm_ops.fault callback. Its embedded `vma` pointer and fault address are
+    // initialized for the duration of the fault handling operation.
+    let (vma, address) = unsafe { ((*vmf).__bindgen_anon_1.vma, (*vmf).__bindgen_anon_1.address) };
+
+    // SAFETY: `vma` comes from a valid fault descriptor, and `vm_private_data`
+    // was initialized by mmap_user_mmio() to store the associated Tyr DRM device
+    // pointer for this VMA.
+    let ddev_ptr = unsafe { (*vma).vm_private_data as *const TyrDrmDevice };
+    if ddev_ptr.is_null() {
+        return VM_FAULT_SIGBUS;
+    }
+
+    // SAFETY: ddev_ptr is non-null, properly aligned, and was originally a shared reference,
+    // so the pointee is valid for the lifetime of the device.
+    let ddev = unsafe { &*ddev_ptr };
+
+    // SAFETY: vma is valid (obtained from a valid vmf).
+    let pgoff = unsafe { (*vma).vm_pgoff } as u64;
+
+    if pgoff != DRM_PANTHOR_USER_FLUSH_ID_MMIO_PGOFF {
+        return VM_FAULT_SIGBUS;
+    }
+
+    // `vm_start` and `vm_end` are behind bindgen-generated anonymous fields.
+    // SAFETY: vma is valid (obtained from a valid vmf).
+    let vm_start = unsafe { (*vma).__bindgen_anon_1.__bindgen_anon_1.vm_start };
+    // SAFETY: vma is valid (obtained from a valid vmf).
+    let vm_end = unsafe { (*vma).__bindgen_anon_1.__bindgen_anon_1.vm_end };
+
+    if address < vm_start || address >= vm_end {
+        return VM_FAULT_SIGBUS;
+    }
+
+    let phys_addr = ddev.mmio_phys_addr + LATEST_FLUSH::OFFSET as u64;
+    let pfn = (phys_addr >> PAGE_SHIFT) as usize;
+
+    // SAFETY: vma is valid (obtained from a valid vmf).
+    let pgprot = unsafe { bindings::pgprot_noncached((*vma).vm_page_prot) };
+
+    // SAFETY: vma, address, pfn, and pgprot are all valid.
+    let ret = unsafe { bindings::vmf_insert_pfn_prot(vma, address, pfn, pgprot) };
+
+    ret as bindings::vm_fault_t
+}
diff --git a/drivers/gpu/drm/tyr/tyr.rs b/drivers/gpu/drm/tyr/tyr.rs
index 9432ddd6b5b8..f1c7c46dfc3e 100644
--- a/drivers/gpu/drm/tyr/tyr.rs
+++ b/drivers/gpu/drm/tyr/tyr.rs
@@ -11,6 +11,7 @@
 mod file;
 mod gem;
 mod gpu;
+mod mmap;
 mod regs;
 
 kernel::module_platform_driver! {

-- 
2.53.0


