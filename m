Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE6F606A336
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ID1sc0xC
Received: by kanga.kvack.org (Postfix)
	id C09226B0140; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0676B0149; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81B86B0140; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD616B0147
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D649416094F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:53 +0000 (UTC)
X-FDA: 85342321386.24.0A620B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BFAFD18000C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ID1sc0xC;
	spf=pass (imf24.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484751;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZSBbpXCPPOyIW5DCM93p6opBVKDT+z+pzOs0o8DC6c=;
	b=pNFrr0FTRkwbvZwd3cH+uO1Pv5vKrpY8KbDecOwEMdFmnaMgbkicfE1s5QYW4DaRSSwwH4
	igTOw6u2LwA875K0/qUUF5RadnfPKdvE730tHMe3nrZ+qvNkF4jFEXn1z9KpkbtTOM1M/O
	WnZSuLS4tbW3o9DenGwUX6Cd6vJbJBY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484751;
	b=hqf6TbXwk2M/HX1Dr2jumMm5phTWQutLoIKnmtARkThN3rdLQdNG4+2hM1ZSB+EOtMwFZX
	2qOQFaItBd/BVecS6okweH2Clt+IvNNJsIoLLcwUEZSg84wXRaxo0bpvobIWKxd1TIMzVC
	8j7qyL/ycIP+QudX1mJOxcHFuGmqoWU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ID1sc0xC;
	spf=pass (imf24.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 539BA60DB9;
	Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484751;
	b=2+sWqdBEVEqwS98+UfXbmW1x53BaAWnZHW6m8mfmrEWwww0royRNnJRTlcT6K4ZDVk2T
	 IZN74obuheuPlwiQXscpGDrLn92xd9qe3+tcQmDc6n4qQWdwWXFNVcXH4wfkk3eI56VSG
	 loVZKf245sLcNDmMwzIz9AoP16Nj9vcuPZe7LI9qh0CxdNYx1Chb46FpBviiwJDaG45YF
	 pq5lCZmcI5fMuG2O18Ql/1qVT5zZT0izHSjQxQLMrbGQM49DmlN7gO1CVUE/HzgPHceuw
	 rFUfSmpzepDiJFAdRNE1WhobRKpqJ+QhFM0Pgnnifh/s03/f9JPtr7zeBRtYaPHNCbQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484751;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=xZSBbpXCPPOyIW5DCM93p6opBVKDT+z+pzOs0o8DC6c=;
	b=i745tetahXk71ccIgXrUKULdVcJFIvTT8MnSU7TCZEk23aIudMDEjAx3SwI5ycusk2iv
	 bTQyNG1Ee9YPPQZB5s7LpNIlxYxj4lgoQ35FWRaKPdPiMW2xKIA566C1aqUn686HruYI6
	 t0Fr/H1+QUinhsmcD840Eg8Dn6C2pFfvp1RJ1eilr2R2Vn/kQW3AZ2BZM1w12P+KQBT3q
	 p7TsNW/bpX3fAogRmfSTzyoSfheCR+mVO95SsdDv0FCc88HSCg3LxS64T7xOlvOj8T6xc
	 WiV1ebUzF+XW/Pd6//F7mw4COOiynXhO7snX/3MPUfeZkB/x9aeOzgATk4V8s1MmnTA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8576D1F000D3;
	Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484751;
	bh=xZSBbpXCPPOyIW5DCM93p6opBVKDT+z+pzOs0o8DC6c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ID1sc0xCpIZ0+cEFmUoZhiYhgf0mcGT9I2MmfVZgpTpR7lCJ3ljnqAKOj9Yor5bmz
	 7OVYMEa4gyKLa0lGNUBAnOJrqhjUjSzQ7QvwVPOU/eDXmNS3GTQgfDe+y85K1y6MFt
	 ayRpV0u+rPhMrP5CLabhhfZlE0p3MIQNVD3DfA+5Ey9XCV1aayHG3/eQcrjUdVsrJo
	 LlRJLzRc1GwfOiYuaeNtLXQLeEuruaV+4MkierkzI8xOkgZAdQPPXSan2EcoPwXTKg
	 7kxWwRZuphYAFxdNG2oJbXWcV6arI16S9AdmJb62Y0czScayAOcODUIs0N2dKHKPOS
	 l5cXOxhEUjk4w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E6665430F8;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:27 +0800
Subject: [PATCH v4 10/11] drm/tyr: gem: flush write-combine BOs from
 probe-time coherence
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-10-704de77da223@kylinos.cn>
References: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
In-Reply-To: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
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
 linux-kernel@vger.kernel.org, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=9726;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=PQV8IyoWvZ/wyECdqBdD8j2r1IHBGqizGurXR8lStHE=;
 b=REKwwK8R4sMhKtXMMVYYhVgSvD8opzYGeEZPHRLY+PWA1inGXX2jmzz83q0cgKEgTIWVzQM9G
 0Rale4/IdsnDXeyY3A8eAmffpPKAlS801yvWeWEg7Ld/Ng9vi8hZW9a
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFAFD18000C
X-Stat-Signature: eiidkudewqm94es8jrse8wrfmtkeud5m
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792484751-381503
X-HE-Meta: U2FsdGVkX1/FLoMxBTr1oF+UiZmQdydS0dg4/Ob+fGicnHBwrkkQ3u8r4NznaeX2C2hlt5PjGe2NKin1v3QUaZH2XKAde7tCISuZHR0WU43rzo46fPB7hJg8aL4MMTDEd/exWJLHcjNc3l49jOBRq5O7Du8n+NugRBiHBN4IXvRvGoX37D2dUFOP4+kfs7VtqYvGC4MgnLLw1rSSlB+Bj30/27TzSHKlDgRYjOU/S/X6vYbP3UpBqBcJzscnivKkXFqgRlOrS1smb2Y3mMZobFQTpn3nNGSDMS6Xj1Wk5PhOphP0E/dOnnh0O1calUAOntOIVVbKrUYDcgQNQBoDuOx8k5i5IWi/7Flw8wqKFyaBD8IH1IoY1Y6yb/JlEKXgaJ+ZtKU8Lv2NXWkC3ZOyoxbQHw6GycsClczAte46JpbVxtJoTVWbjzCKGtDPmJLogXh1BUFYF+BtGLfK1kpxf1WyI+T3wAmaB7VtG+jm9gwV9MzJWHdim0RPOhJ/5EW/lhfvrCUWppzWnKVRmxnFYSdAGlyxe6/HXalePjIJPbz7C5RzZXOEr1qwikaI7iXx6tr4YBrfh4amW196KXrYNmJbN2w4PRsHk9wcvsRIFsMkP4e76w3S/4fnWre3K704Pz6apeJmqKnBS/Byj7aGN60CwKljx+86XhrGbV6D00DCpM8cR3nzkUSusYYOCDazGcawl1ODLxAxuzb1horiRJVFThu5yAkqdlqtObZ5Yf080ihXDb11Kzjl5wRI5/ydVD+7P5ab7nv1uY8z/n+XwUCjbbitgfB3gLRMcwIsEuvEflFbGiSgjGm2TLrIaMgDl7FiSCOPffdUHJpRPdYFN/N70XgtngG2qE8H86XiCdmB8i/mVVAOImolS0Sc7wnY9/Buf8YiElm3CJKbVdxfJolKoSI/Lbyiner1b5d/S+jw+UllTLY6TUXS8vTh8nZHMCPm9ztubqr9JL8GrAS
 9YJ5FfJc
 II3cEltKHDYj6q5YgBLLmPcPguMnGd0msIyuJXbXWvLe1FIjld03cyoiAuGJ+RPg37BLa+15+nuYniOfr3nvDPHTP85nPy/TjhD/iUwCGkzaINKN1NL1u5M1ufeiC9CFzwiy9w26o10B3fdL6ebBjeNRFXgO47sBec2PAbjEJUD/TjpsZF7SNPGVvcppZzEH9O7rSETKgVQEwnjU6xhLrKoLwAqIMW3RIrVheY0aNAiOirjxKChIjFDm3j+hjDJf76zdxfQPXAbrZXPqervUZV01MEMUN8Gx8DKd7EAgWgGP+oRZ+Xc7c/HEpxkYQ9g4Y6xQdB5qEeumi+lagPmY+72balcT+3CoSXckqD4onKQBewjCGty+uagNlYByl0cNnYF4sai6TZWOnsNfNg35RXoFWHVyp2GVO6PewbScdGilmtN5cq7f8jxlYA5gu2gvlcFWwgA30SihAjmc7Fmk61uh0oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Sami Tolvanen <samitolvanen@google.com>

Tyr maps shmem-backed buffers write-combine, but the shmem layer
zero-inits new pages through a cached mapping. On a non-coherent device
those stale cache lines can land over later uncached writes, so the GPU
or userspace reads a freshly written value back as zero.

Read the device's coherence once at probe and map buffers write-back
when it's coherent, write-combine otherwise. BO_CREATE fetches the
sgtable at creation time so dma_map_sgtable() flushes the zeroed pages
before anyone accesses them uncached.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
[ Drop the map_wc-conditional sg_table call, now fetched
  unconditionally in BO_CREATE. - Alvin ]
Co-developed-by: Alvin Sun <alvin.sun@linux.dev>
Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/driver.rs | 10 ++++++++++
 drivers/gpu/drm/tyr/file.rs   |  5 +++--
 drivers/gpu/drm/tyr/fw.rs     |  4 +++-
 drivers/gpu/drm/tyr/gem.rs    | 34 +++++++++++++++++++++++++---------
 drivers/gpu/drm/tyr/vm.rs     |  9 ++++++---
 5 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index f4f31b24180b4..633d1cab3cea9 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -88,6 +88,12 @@ pub(crate) struct TyrDrmRegistrationData<'drm> {
 
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
@@ -152,6 +158,8 @@ fn probe<'bound>(
             // other threads of execution.
             unsafe { pdev.dma_set_mask_and_coherent(DmaMask::try_new(pa_bits)?)? };
 
+            let coherent = pdev.as_ref().dma_attr().is_coherent();
+
             let unreg_dev = drm::UnregisteredDevice::<TyrDrmDriver>::new(pdev, Ok(()))?;
 
             let mmu = Mmu::new(pdev.as_ref(), iomem.as_arc_borrow(), &gpu_info)?;
@@ -162,6 +170,7 @@ fn probe<'bound>(
                 &unreg_dev,
                 mmu.as_arc_borrow(),
                 &gpu_info,
+                coherent,
             )?;
 
             firmware.boot()?;
@@ -187,6 +196,7 @@ fn probe<'bound>(
                         }),
                         iomem,
                         gpu_info,
+                        coherent,
                     }),
                 )},
                 _: { dev_dbg!(pdev, "Tyr initialized correctly.") },
diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index 9ffb42f0d8851..d4d6a6742b2e1 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -113,6 +113,7 @@ pub(crate) fn vm_create(
                 pfile.reg.mmu.as_arc_borrow(),
                 &pfile.reg.gpu_info,
                 UserVaRequest::from_uapi(vmcreate.user_va_range),
+                pfile.reg.coherent,
             )?;
             let user_va_range = vm.layout.user.end;
             let id = pfile.vm_pool.add(vm).map_err(|e| {
@@ -253,7 +254,7 @@ pub(crate) fn vm_get_state(
 
     pub(crate) fn bo_create(
         ddev: &TyrDrmDevice<Registered>,
-        _reg_data: &TyrDrmRegistrationData<'_>,
+        reg_data: &TyrDrmRegistrationData<'_>,
         bocreate: &mut uapi::drm_panthor_bo_create,
         file: &TyrDrmFile,
     ) -> Result<u32> {
@@ -284,7 +285,7 @@ pub(crate) fn bo_create(
             );
             EINVAL
         })?;
-        let bo = crate::gem::new_object(ddev, size, bocreate.flags)?;
+        let bo = crate::gem::new_object(ddev, size, bocreate.flags, reg_data.coherent)?;
         bocreate.handle = bo.create_handle(file)?;
         bocreate.size = bo.size() as u64;
 
diff --git a/drivers/gpu/drm/tyr/fw.rs b/drivers/gpu/drm/tyr/fw.rs
index 81e8103368bc2..b24560ae10a4e 100644
--- a/drivers/gpu/drm/tyr/fw.rs
+++ b/drivers/gpu/drm/tyr/fw.rs
@@ -217,8 +217,9 @@ pub(crate) fn new(
         ddev: &TyrDrmDevice,
         mmu: ArcBorrow<'_, Mmu<'drm>>,
         gpu_info: &GpuInfo,
+        coherent: bool,
     ) -> Result<Firmware<'drm>> {
-        let vm = Vm::new_for_fw(dev, ddev, mmu, gpu_info)?;
+        let vm = Vm::new_for_fw(dev, ddev, mmu, gpu_info, coherent)?;
         vm.activate()?;
 
         let sections = (|| -> Result<KVec<Section<'drm>>> {
@@ -235,6 +236,7 @@ pub(crate) fn new(
                     size,
                     KernelBoVaAlloc::Explicit(va),
                     parsed.vm_map_flags,
+                    coherent,
                 )?;
 
                 let section_start = parsed.data_range.start as usize;
diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 14f3e182b98e2..fad0720ce7123 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -63,19 +63,35 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: BoCreateArgs) -> impl PinInit<Se
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
 
+    let map_wc = should_map_wc(coherent);
     let bo = Bo::new(
         ddev,
         aligned_size,
         shmem::ObjectConfig {
-            map_wc: true,
+            map_wc,
             parent_resv_obj: None,
         },
         BoCreateArgs { flags },
@@ -94,18 +110,17 @@ pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>>
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
@@ -143,6 +158,7 @@ pub(crate) fn new(
         size: u64,
         va_alloc: KernelBoVaAlloc,
         flags: VmMapFlags,
+        coherent: bool,
     ) -> Result<Self> {
         if size == 0 {
             dev_err!(vm.dev(), "Cannot create KernelBo with size 0");
@@ -158,7 +174,7 @@ pub(crate) fn new(
             ddev,
             bo_size,
             shmem::ObjectConfig {
-                map_wc: true,
+                map_wc: should_map_wc(coherent),
                 parent_resv_obj: None,
             },
             BoCreateArgs { flags: 0 },
diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index 597e35f864f64..576b2123a08ae 100644
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



