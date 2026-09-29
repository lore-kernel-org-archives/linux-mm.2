Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B111CCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5386B00AC; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592766B00A6; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348806B00A5; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC7E16B00A6
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:16:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79C21C037E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:02 +0000 (UTC)
X-FDA: 85265184564.02.525AD6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7C13F160009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s4Ya6bJ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648160;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFKq+2sZj049+Ttmtp/KdWByrm89RVe8fd42AbbBYA4=;
	b=Ctsst0eCoXa/3w60DZVL1gWIF7N6JhzfzVpO9v01buz7XB0JuJkJd4AXkITk844WsTAB9f
	IRo6xKFqoidqpghGWm3PY+RH5dnISBEuielu4EN4tmbiNYkKNqbBEaZCF6/0tdmRJbXhTb
	Vp5pyY2uGEheMcsgyACNBvQZC4HFanc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s4Ya6bJ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648160;
	b=r6FcbVcA0KUfTWnfKSZHH47wCyRLh3PTu09YVT19EtoPaeNI22QRxFCosgHO34wLW+2+tT
	pmklLyN6XUU4wzmQaE3ktULE1ESd7ySPoYcZUigYe94Fyh2wKw1hKjv6IrrFrf08pQbRnT
	/2L85MO4sYC+FrAMqLDrJMtw2A63SqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBCDB447EE;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7C30C2BCC7;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=wqlbxrqFovLuNklwnRJ5gzd+1NF0CtssArS6R0Z/Sdo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s4Ya6bJ9m0cwC3vyYLxUpUh8UdNK8kJWB9lMju+zylAiGbQIimCn9608j/QHSKKD/
	 nuVcJPkEWDEA0ERzPCU7js1iQGZCgIPwFta/x1GK6EHZnknetbyvI//Ok1DBZnMXME
	 UFoNo+l56R8kedSCkyLBVyYcmDuRbtxOJlxsPaK1BurI0z1ufjuGdzcL4jNgqi/pJr
	 Eh/6YKXhKVrE1lUSuROacJQv6Calxe02R0F3qFNbwQreNPVDW2FfiJbtbWupw6Uht8
	 6rsPrTm6xd2vW0MitwMCFeLwRb6MuUOrCc56+fSDgA7RxAUdofvUGyLnMbS0w3WsBO
	 VO2kYG2uJfiKA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1443CA5FAE;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:16:00 +0800
Subject: [PATCH v3 10/11] drm/tyr: gem: flush write-combine BOs from
 probe-time coherence
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-tyr-ioctls-v3-10-26955fb111d5@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=9843;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=8yp4qx9NVGwmEfFZ8IylhuvBMIqeph0iGg8ZgHTyxLs=;
 b=gIh0pAfZweiLl9Pr1k4zmKDCwZjktAmzGAq3oOmMPIeAKb1Z2hoxZa8ut//OqR22ITDFe+flG
 /l5uqjhZoacA7xiTN7I95p8pX3wPCFMHtD1AGaahUyddyd9owB9ku1B
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Queue-Id: 7C13F160009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ktoi5exwb1jutd186u4payi8uttb5esh
X-HE-Tag: 1790648160-848926
X-HE-Meta: U2FsdGVkX18kjMqwGHCafYVtOG1/VfRhVuDXFOM4KTQDEzSciOJSfQgqt2JMbMwUnV8gftUetuVKgA2d1nxPj5a8k0xv5mZNdBvmvxSuZ19Sg7+vPF/uZtxBur4WsTLcsTeOFOTRu5OZJJpyxOWT+s6vwKYdc8iczjiK3apaMZHkJaKXN1AV9qEZ0mWpbCPQSdK5awEZadGDUZkaS/M4RSmRJO5vdYVkfb9TK6RnS9Hp1b/YgKV6yth7y3eAE0pmzUZfEfebcWNzRthVSg6H7hW3mKfwJEHJZFHgKwYIY+W6oICZ2go6qlu9WH+0KbFcP8GWd095zehy6q++28ruNZDG2x7lpVERq7GbFkICPunYxYuQTIvMQ+lY+FwqzB/eGWDM8eLS2/SsLHbT9/+LQWsO+i4IHHqqgC0eVkCZEEzwNS1dnz2oVmCrfV5IVoZU1nV+RI/kr0XIWAKaCFAd8csuM0L1C2IrPuE6U3nDU/vQDwXCJgy0jwLnCFMGoE3T5pz+uzyOf6IDgk9nu5FAeZAzzN4TVt58s5SYuf0FWgGQZbBFTgA10YEaFIG7iQH+glXlCKA/6nM+zMIjbauBxuCSnfZnb9n03U6zMyow6tLCt5R091eJruMyOniBC88lw9OS/6loXzTiGRPc6j6GeHjGVg4ApB79sVN1XbhDp+OsoTcCdq3ltQW5/izfx/Poj67TqGb/p7NmBQbQ8PVy/iMxJzQubViE2x6PEIn5/ci/IBYA/00lgc1aoAd26ScW2VCIOkzRw75QuShNeGiUQ15jRpsLM2H3JLVu3v98moU5u7Qa5BkJ97NXtzadIxSw66y+lTVBQOl6+ZkksrbObjdidxDgHXjndB0xanwdVK0S7tAJzA7P4WYLZ4k3KiCMesao1YcfJj79lobgkBOWaUEzLgvvFe6Ni8narWAiDb+0BHY+HxgBiTwih3RrC7fTH6QnRKRcQwgtokGkEhv
 ZJ3JrTJb
 +v/ILWaPmPxHtUriDGgaOz4PjVKL3E11I2EAifKc01EphxC4a3bxBW+6HlXBBckNq+0PMvd+vQmRADQa9RhmyXQe4XgBGwukuwn2tgX1yf2HcoYJLlN6mW/s9+QtCEOOTWB3Qk69MmLUHtPJ52sJk45Y1HgUCQ/Rzlvlt7lNziA+HthCsDoGUlKcPuNp21wCLPL+YdlSFTG1+/7i3T9MWbtaghvZAwnFP/9iGBLISzLVaLBc+5SZUD9pIwW49PKG5BMSqQ5gjlEaWomi4dPaUWaAp04tAn/0GuzUrs3ukxydP5Tr39qN61UoN/NbKgRT8pz835A0SydZDwwVvG6dGrpbrQb/tj80MI/6ewqiOP40CM7KUHeU7lT3Be95tIMChLJ4yxLBlug1IYnTx60n1dV0VPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sami Tolvanen <samitolvanen@google.com>

Tyr maps shmem-backed buffers write-combine, but the shmem layer
zero-inits new pages through a cached mapping. On a non-coherent device
those stale cache lines can land over later uncached writes, so the GPU
or userspace reads a freshly written value back as zero.

Read the device's coherence once at probe and map buffers write-back
when it's coherent, write-combine otherwise. For write-combine buffers,
fetch the sgtable at create time so dma_map_sgtable() flushes the zeroed
pages before anyone accesses them uncached.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Co-developed-by: Alvin Sun <alvin.sun@linux.dev>
Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/driver.rs | 10 ++++++++++
 drivers/gpu/drm/tyr/file.rs   |  5 +++--
 drivers/gpu/drm/tyr/fw.rs     |  4 +++-
 drivers/gpu/drm/tyr/gem.rs    | 46 ++++++++++++++++++++++++++++++++-----------
 drivers/gpu/drm/tyr/vm.rs     |  9 ++++++---
 5 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index 8baf88aee96ad..59a2a415a59c7 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -87,6 +87,12 @@ pub(crate) struct TyrDrmRegistrationData<'drm> {
 
     /// GPU information read from hardware during probe.
     pub(crate) gpu_info: GpuInfo,
+
+    /// Whether the device is reported as DMA-coherent by firmware.
+    ///
+    /// Cached at probe via `device_get_dma_attr()`. Drives the BO
+    /// cacheability policy in `crate::gem::should_map_wc`.
+    pub(crate) coherent: bool,
 }
 
 fn issue_soft_reset(dev: &Device, iomem: &IoMem<'_>) -> Result {
@@ -150,6 +156,8 @@ fn probe<'bound>(
         // other threads of execution.
         unsafe { pdev.dma_set_mask_and_coherent(DmaMask::try_new(pa_bits)?)? };
 
+        let coherent = pdev.as_ref().dma_coherent();
+
         let unreg_dev = drm::UnregisteredDevice::<TyrDrmDriver>::new(pdev, Ok(()))?;
 
         let mmu = Mmu::new(pdev.as_ref(), iomem.as_arc_borrow(), &gpu_info)?;
@@ -160,6 +168,7 @@ fn probe<'bound>(
             &unreg_dev,
             mmu.as_arc_borrow(),
             &gpu_info,
+            coherent,
         )?;
 
         firmware.boot()?;
@@ -179,6 +188,7 @@ fn probe<'bound>(
                 }),
                 iomem,
                 gpu_info,
+                coherent,
         });
 
         // SAFETY: `reg` is stored in `TyrPlatformDriverData` and dropped when the driver is
diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index e98eb0a46877f..526eb1d53de42 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -113,6 +113,7 @@ pub(crate) fn vm_create(
                 pfile.reg.mmu.as_arc_borrow(),
                 &pfile.reg.gpu_info,
                 UserVaRequest::from_uapi(vmcreate.user_va_range),
+                pfile.reg.coherent,
             )?;
             let user_va_range = vm.layout.user.end;
             let id = pfile.vm_pool.add(vm)?;
@@ -251,7 +252,7 @@ pub(crate) fn vm_get_state(
 
     pub(crate) fn bo_create(
         ddev: &TyrDrmDevice<Registered>,
-        _reg_data: &TyrDrmRegistrationData<'_>,
+        reg_data: &TyrDrmRegistrationData<'_>,
         bocreate: &mut uapi::drm_panthor_bo_create,
         file: &TyrDrmFile,
     ) -> Result<u32> {
@@ -282,7 +283,7 @@ pub(crate) fn bo_create(
             );
             EINVAL
         })?;
-        let bo = crate::gem::new_object(ddev, size, bocreate.flags)?;
+        let bo = crate::gem::new_object(ddev, size, bocreate.flags, reg_data.coherent)?;
         bocreate.handle = bo.create_handle(file)?;
         bocreate.size = bo.size() as u64;
 
diff --git a/drivers/gpu/drm/tyr/fw.rs b/drivers/gpu/drm/tyr/fw.rs
index d790b54e373e6..fc9e9d10ea921 100644
--- a/drivers/gpu/drm/tyr/fw.rs
+++ b/drivers/gpu/drm/tyr/fw.rs
@@ -221,8 +221,9 @@ pub(crate) fn new(
         ddev: &TyrDrmDevice,
         mmu: ArcBorrow<'_, Mmu<'drm>>,
         gpu_info: &GpuInfo,
+        coherent: bool,
     ) -> Result<Firmware<'drm>> {
-        let vm = Vm::new_for_fw(dev, ddev, mmu, gpu_info)?;
+        let vm = Vm::new_for_fw(dev, ddev, mmu, gpu_info, coherent)?;
         vm.activate()?;
 
         let sections = (|| -> Result<KVec<Section<'drm>>> {
@@ -239,6 +240,7 @@ pub(crate) fn new(
                     size,
                     KernelBoVaAlloc::Explicit(va),
                     parsed.vm_map_flags,
+                    coherent,
                 )?;
 
                 let section_start = parsed.data_range.start as usize;
diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 22a04c0b8a812..95e5537e7174b 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -63,23 +63,47 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: BoCreateArgs) -> impl PinInit<Se
 /// Type alias for Tyr GEM buffer objects.
 pub(crate) type Bo = gem::shmem::Object<BoData>;
 
+/// Returns whether a BO should be mapped write-combine given the device's
+/// DMA coherence.
+pub(crate) fn should_map_wc(coherent: bool) -> bool {
+    if coherent {
+        return false;
+    }
+
+    true
+}
+
 /// Create a new GEM buffer object.
-pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result<ARef<Bo>> {
+pub(crate) fn new_object(
+    ddev: &TyrDrmDevice,
+    size: usize,
+    flags: u32,
+    coherent: bool,
+) -> Result<ARef<Bo>> {
     if size == 0 {
         return Err(EINVAL);
     }
 
     let aligned_size = size.checked_next_multiple_of(PAGE_SIZE).ok_or(EINVAL)?;
 
-    Bo::new(
+    let map_wc = should_map_wc(coherent);
+    let bo = Bo::new(
         ddev,
         aligned_size,
         shmem::ObjectConfig {
-            map_wc: true,
+            map_wc,
             parent_resv_obj: None,
         },
         BoCreateArgs { flags },
-    )
+    )?;
+
+    if map_wc {
+        // SAFETY: `ddev` is bound for the duration of this call.
+        let dev = unsafe { ddev.as_ref().as_ref().as_bound() };
+        bo.sg_table(dev)?;
+    }
+
+    Ok(bo)
 }
 
 /// Look up a GEM object by handle for a DRM file.
@@ -88,18 +112,17 @@ pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>>
 }
 
 /// Creates a dummy GEM object to serve as the root of a GPUVM.
-pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> Result<ARef<Bo>> {
-    let bo = Bo::new(
+pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice, coherent: bool) -> Result<ARef<Bo>> {
+    // FIXME: use a Rust resv-object abstraction once available, rather than a real BO.
+    Bo::new(
         ddev,
         4096,
         shmem::ObjectConfig {
-            map_wc: true,
+            map_wc: should_map_wc(coherent),
             parent_resv_obj: None,
         },
         BoCreateArgs { flags: 0 },
-    )?;
-
-    Ok(bo)
+    )
 }
 
 /// Specifies how to choose a GPU virtual address for a [`KernelBo`].
@@ -137,6 +160,7 @@ pub(crate) fn new(
         size: u64,
         va_alloc: KernelBoVaAlloc,
         flags: VmMapFlags,
+        coherent: bool,
     ) -> Result<Self> {
         if size == 0 {
             dev_err!(vm.dev(), "Cannot create KernelBo with size 0");
@@ -152,7 +176,7 @@ pub(crate) fn new(
             ddev,
             bo_size,
             shmem::ObjectConfig {
-                map_wc: true,
+                map_wc: should_map_wc(coherent),
                 parent_resv_obj: None,
             },
             BoCreateArgs { flags: 0 },
diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index 9f4d2e23a3ab4..c9ef7c3ff1b9e 100644
--- a/drivers/gpu/drm/tyr/vm.rs
+++ b/drivers/gpu/drm/tyr/vm.rs
@@ -474,13 +474,14 @@ pub(crate) fn new_for_fw(
         ddev: &TyrDrmDevice,
         mmu: ArcBorrow<'_, Mmu<'drm>>,
         gpu_info: &GpuInfo,
+        coherent: bool,
     ) -> Result<Arc<Vm<'drm>>> {
         // As in panthor: the CSF MCU is a Cortex-M7 and can only address 4G.
         let layout = VmLayout {
             full: 0..u64::SZ_4G,
             user: 0..0u64,
         };
-        Self::new_internal(dev, ddev, mmu, gpu_info, layout)
+        Self::new_internal(dev, ddev, mmu, gpu_info, layout, coherent)
     }
 
     /// Creates a user VM, splitting the GPU VA range per `user_va`.
@@ -490,6 +491,7 @@ pub(crate) fn new_for_user(
         mmu: ArcBorrow<'_, Mmu<'drm>>,
         gpu_info: &GpuInfo,
         user_va: UserVaRequest,
+        coherent: bool,
     ) -> Result<Arc<Vm<'drm>>> {
         let mmu_features = MMU_FEATURES::from_raw(gpu_info.mmu_features);
         let va_bits = mmu_features.va_bits().get();
@@ -503,7 +505,7 @@ pub(crate) fn new_for_user(
                 range.end
             );
         })?;
-        Self::new_internal(dev, ddev, mmu, gpu_info, layout)
+        Self::new_internal(dev, ddev, mmu, gpu_info, layout, coherent)
     }
 
     /// Initializes a VM with the given layout.
@@ -513,6 +515,7 @@ fn new_internal(
         mmu: ArcBorrow<'_, Mmu<'drm>>,
         gpu_info: &GpuInfo,
         layout: VmLayout,
+        coherent: bool,
     ) -> Result<Arc<Vm<'drm>>> {
         let mmu_features = MMU_FEATURES::from_raw(gpu_info.mmu_features);
         let va_bits = mmu_features.va_bits().get();
@@ -521,7 +524,7 @@ fn new_internal(
         let reserve_range = 0..0u64;
 
         // dummy_obj is used to initialize the GPUVM tree.
-        let dummy_obj = gem::new_dummy_object(ddev).inspect_err(|e| {
+        let dummy_obj = gem::new_dummy_object(ddev, coherent).inspect_err(|e| {
             dev_err!(dev, "Failed to create dummy GEM object: {:?}", e);
         })?;
 

-- 
2.43.0



