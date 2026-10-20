Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1688F60A2603
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a8hUwQ/3
Received: by kanga.kvack.org (Postfix)
	id B46CC6B013C; Tue, 20 Oct 2026 04:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF526B013D; Tue, 20 Oct 2026 04:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997556B013E; Tue, 20 Oct 2026 04:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 676336B013C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAD43A0950
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
X-FDA: 85342321302.30.717DFE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7586100004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a8hUwQ/3";
	spf=pass (imf05.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484749;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9o/MkU5MLlh8zpGuisq23yMQuzKyDuunYnnESbkWk8=;
	b=OvyMp3Z527+l+bVUsnuPkdbbbKjs3n3Kzp1c6wy3itkB/A2lfV6o46t45xSM5qwPagsppa
	qDAJUAVP3jtlOSBsDkfAhZPkFnp0KLqt9YC42PKZFUTxY6JyroXHSYh05gkSUdJJJweNCX
	il3vvYxk7iRtlCaFwW5H/uOu/wMugBc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484749;
	b=qv1abW9OmTpmXJXX4boYoyTvJ/Gu4k/0GMCXC0HlYboC7e77lRuIOztfL3plH2j6BwrnkF
	hHPBhplNFLxM2X2rt8i6XbafH+t6vV/9GRtWHKbNZBSeGvPaVd6MqioxZRCHqM4L/J4hxs
	LgK6VDU/a2gcEVxl3lYS5SM7kpSnHoM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a8hUwQ/3";
	spf=pass (imf05.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 547E760DB3;
	Tue, 20 Oct 2026 08:25:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484749;
	b=nJeN0lRc1Eg5772KNbgjGjVYEh9HEBFqLq59sK5f4sRruMTiSJUUyf7+CqFrIM5CjhCg
	 nTgxrQwO++E1wncvAYzwOb1J3EuOLkI2bUk7n3C1C5xiRMM/3FUOBlFgaQqFXn6ltDRFR
	 isJZ7kbm+p4D2n4FheQNwcmD73Z7DyaQrjlk7FEw1oksqnUxKbcGFSXqBln8MXJet5VFE
	 fOGhN1OW2gxuhjrqTmE/aCaiugLt+pFMkH5fMlYLMcLXbZwwLV545FedG2un0nxTfMBkT
	 fJC58WC390rayFCWMkB/zO20ZVuN2R0oOP+ymj6T1i7WBdMLFBvOjW4i04rqAfR9KQQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484749;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=S9o/MkU5MLlh8zpGuisq23yMQuzKyDuunYnnESbkWk8=;
	b=UFtTEjII4n9nRA6jUKoOZ6K+Bjxf9SHOSHE2sdpHVhjlLuGdgKHNkQyO8UTrZV7Y07Id
	 EpnzqpnwkfAHswGNxVvvlnACpjqwhCxrc0/ldFGsNX5KJucE26RwrbVh0j2clJ0WBGkj6
	 wVB3tf18K0nbr/A2PNII5HoyD91bx2zJnkV5Ivd9O/vCzg3Xln+bTdWm+ucibrCpF6oLN
	 eSI9Ow1TiFBi2GOFrIIu3w4kgPvr16ri302Swfo1X4GzTmhRdHTBBVPEBdTlYmhV1ZVPa
	 B/g5CiQeQYW2rQ/qBeqq+5A/MXy9jExruOcRVY9XPSFFrDVNiSiJHT1ng4Cvi9rOGrA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 71DA51F000CB;
	Tue, 20 Oct 2026 08:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484749;
	bh=S9o/MkU5MLlh8zpGuisq23yMQuzKyDuunYnnESbkWk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=a8hUwQ/3kvgHdj/FAqwBQZpGKP+Y2KlVwlfAmjzGb4xYFwvaL3z5aTnnbOHs60fYh
	 1Oku0iE/h8RvmnC0GkgnAeZVG5NdOmwCQ3MgtzDn2A4N93Nv0O2jikSAHO3Nh6k7Jk
	 nXo+E2Iqy1vL0VIP8evJwLDFaZTpkKoJvK1JZkLuaGeL2VHJ2C2g/99m/nukNAYaaS
	 0rniQZ4MbtxKsES4HxODv6OpQWKQDMQa5h4YXlyhVrXmCpkP3fuqqbsnZtaMroiP2g
	 TnvVUt1sECRTq+OYgWGWiKrB2uc1+fSM8/O5WlxFDEizk5Xabzbppzacmqdtn6H5iv
	 XMEZBHDJon5yA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C15F7430E1;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:22 +0800
Subject: [PATCH v4 05/11] drm/tyr: add user and MCU VM specifications
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-5-704de77da223@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=10916;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=gawdIs2Kzz9vZPukoRHj/fYocc/+sO8wHCAj1TnXMuM=;
 b=Zx5EcSvfglMc5/HaRNW6CmEyR2MmmATQ17snoxtfZ45mZGkmbpHVd5zonQgBKvBvMZ1f3NINT
 gnudFHAm1BxCWAaASksCXzNChPK0ojJySI9L2n0T0i6OaecbNMgAxsR
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C7586100004
X-Stat-Signature: er68gyy74d69gdr9gtmmj1iauks7qhsq
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792484749-116779
X-HE-Meta: U2FsdGVkX19+JtqKEkLvwinZgKreSPnNA4/HJY7M20QSs5eZXhiFe9ktufB5fTw+Hb1WmMbqmirY8NEMzZHkKtoQ++BtFmNSm+6kuXYTI9sT+BuqlOT4Ip2419oZZ6bNNyVOHPhWZ3/5VJZ8W164dASPfxOIUWq7jC+5wu4+Kz6fM7NVQflGTk7kIWIBkCLx7rkzNjLA8cM5tJ3Iit5coBSFAZebAyv9KTOhL0c3L9SjpNgaeNfTFiM0dBQ20ALZ7AswXOaV80M/Wg7abj3X1YcNvJD/+hiK/AeB3d5NlrJBteF1riE7DDKpm8NA3OQnRNScFwcx9lKNC3j6CM/YW6bq+ti1xJq1briIFIefzjn2SHEwLJcBCejthsibdsp5wu9Zxd7j0sIyyGC2ofGcWddV5V337jMXNyGWhgB9ydgrqF/v0oI2TMKsB8crSFNo8K6e20g5oRmnXMlHMxUg/NAG7iKhZSW0s7UP5MAqXieMB7+zHlT/iDLTGs0QkgI1Dmbqd40cMDojAGTBlG0YK9+OkT15Cr45zxVxICc5S+e8cHRJ1EfQBT6LQmGzJ2Dy45q7dM8uUT2xIWSPN/JQGEWwCoZ7vLT74TmPKTlBLc4H6Dgjewl+lScCiQiddTyHuj4v/o1cAkAh+fSQ7SYB3mzPsDprxh2b8LnXTHWsEvIXozbQmgVf1NGZg7S4tB4fwmwiNsEBwG1RBpy+ourdc8bFMabdNDJzhOpI5mETPL1g5AQ1kJfeAXpyGOm1zfyrd+LvQvSX5TdpObd2jV1Zs2x31fQV6oinCzH5qVk9TFYyP+pMOcV80mW7O6V6VQBdQX2Pk00mkg02TqFrezrZN9Gm6OR/T8RNvxxFT5RSwH68kawwGRvd3Z1QhhKLdD9cwNfwvDSPBb0cFaHMNfZcgCCa6hq0zL5KWiEqOix0DlXdqwbnw2q6CS0JNvwqfoEvPAE1hPcmV5vQyYf+HIm
 TfsE4RY4
 5iMS6F4YUfhV2JnGLhOuvqYTMRnpSj3N8C9ZysySaVExS/01MSGD01qUiHzt+MuR11919oUOY75ZwJ0P47zivSUyKoG0RdKiXZoL0qBNiRV5tsrtJ1qN86GEHcw/nJ4Dce/KR9uxVd0ErUuHADy5RyuKqL+ToBxIVaqJNHKhCAsJ2iJYPALgWnWEmX2oPCNTVaHdszK9iWs5Y6CCIbBOYKZ4QER71A6ajTdqx01UroE1QVfMfYK2lfwLc0yiYoL3c3sD+8B169eTC7Pkh7NiAnrfM2m/7i0/VsfpnnhJCCAHtXCYVNn/8SvtCKc2yxg2AMHurGlbQGg49Y8r96jayspY6cYPCa4Q902RkPWOOpUZEfEgz1IVoYN7suklkqqmUzNd3NIfI7KLPgSEF1U6VgrKjfiJmTq/udlaKf9m+igRA27Xpx+H2CXB6yxQZRyvNM2O2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alvin Sun <alvin.sun@linux.dev>

The MCU and user VMs need different VA layouts. Give each a dedicated
constructor: new_for_fw() builds the kernel-only 4G layout, while
new_for_user() splits the address space by task_size or a user-provided
size, rejecting oversized requests rather than clamping. The resulting
user range is what VM_CREATE reports back as user_va_range.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/fw.rs |  19 +++---
 drivers/gpu/drm/tyr/vm.rs | 159 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 153 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/tyr/fw.rs b/drivers/gpu/drm/tyr/fw.rs
index aea151ff1f934..81e8103368bc2 100644
--- a/drivers/gpu/drm/tyr/fw.rs
+++ b/drivers/gpu/drm/tyr/fw.rs
@@ -51,7 +51,6 @@
         KernelBoVaAlloc, //
     },
     gpu::GpuInfo,
-
     mmu::Mmu,
     regs::{
         gpu_control::{
@@ -219,10 +218,10 @@ pub(crate) fn new(
         mmu: ArcBorrow<'_, Mmu<'drm>>,
         gpu_info: &GpuInfo,
     ) -> Result<Firmware<'drm>> {
-        let vm = Vm::new(dev, ddev, mmu, gpu_info)?;
+        let vm = Vm::new_for_fw(dev, ddev, mmu, gpu_info)?;
         vm.activate()?;
 
-        let result = (|| {
+        let sections = (|| -> Result<KVec<Section<'drm>>> {
             let (fw, parsed_sections) = Self::load(dev, ddev, gpu_info)?;
             let mut sections = KVec::new();
             for parsed in parsed_sections {
@@ -252,18 +251,18 @@ pub(crate) fn new(
                 sections.push(Section { data, mem }, GFP_KERNEL)?;
             }
 
-            Ok(Firmware {
-                iomem,
-                vm: vm.clone(),
-                sections,
-            })
+            Ok(sections)
         })();
 
-        if result.is_err() {
+        if sections.is_err() {
             vm.kill();
         }
 
-        result
+        Ok(Firmware {
+            iomem,
+            vm,
+            sections: sections?,
+        })
     }
 
     pub(crate) fn boot(&self) -> Result {
diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index 6935e4db667b9..adbf8edcd5c6f 100644
--- a/drivers/gpu/drm/tyr/vm.rs
+++ b/drivers/gpu/drm/tyr/vm.rs
@@ -8,6 +8,7 @@
 //! mapped into hardware address space (AS) slots for GPU execution.
 
 use core::marker::PhantomData;
+use core::num::NonZeroU64;
 use core::ops::Range;
 
 use kernel::{
@@ -44,6 +45,8 @@
     new_mutex,
     prelude::*,
     sizes::{
+        LargeSizeConstants,
+        SizeConstants,
         SZ_1G,
         SZ_2M,
         SZ_4K, //
@@ -159,6 +162,92 @@ fn try_from(value: u32) -> Result<Self, Self::Error> {
     }
 }
 
+/// User VA size request for a user VM.
+pub(crate) enum UserVaRequest {
+    /// Split based on `task_size()` and the GPU VA range.
+    Auto,
+    /// Caller-specified size; construction guarantees `> 0`.
+    Fixed(NonZeroU64),
+}
+
+impl UserVaRequest {
+    /// UAPI boundary normalization: `0` -> [`Auto`](Self::Auto).
+    #[expect(dead_code)]
+    pub(crate) fn from_uapi(v: u64) -> Self {
+        match NonZeroU64::new(v) {
+            Some(size) => Self::Fixed(size),
+            None => Self::Auto,
+        }
+    }
+}
+
+/// Final user/kernel VA layout for a VM.
+pub(crate) struct VmLayout {
+    /// Full GPU VA range covered by this VM.
+    pub(crate) full: Range<u64>,
+    /// User-accessible VA range. Empty for MCU VMs.
+    pub(crate) user: Range<u64>,
+}
+
+impl VmLayout {
+    /// Kernel VA range, reserved for future kernel object allocation.
+    #[expect(dead_code)]
+    pub(crate) fn kernel(&self) -> Range<u64> {
+        self.user.end..self.full.end
+    }
+
+    /// Compute a user/kernel split for a user VM from the full GPU VA range and
+    /// a user request.
+    pub(crate) fn compute(full: Range<u64>, req: UserVaRequest) -> Result<Self> {
+        // Minimum VA space reserved for kernel objects (heaps, ring buffers, ...).
+        const MIN_KERNEL_VA: u64 = u64::SZ_256M;
+
+        if full.end <= MIN_KERNEL_VA {
+            return Err(EINVAL);
+        }
+
+        let user_max = full.end - MIN_KERNEL_VA;
+
+        let user_end = match req {
+            UserVaRequest::Fixed(v) => {
+                let user_size = v.get();
+                if user_size > user_max {
+                    return Err(EINVAL);
+                }
+                user_size
+            }
+            UserVaRequest::Auto => {
+                let task_size = current!().mm().map(|mm| mm.task_size());
+                let candidate = match task_size {
+                    // `task_size()` returns usize; widen to u64 for the comparison.
+                    Some(t) if (t as u64) < full.end => t as u64,
+                    None | Some(_) => {
+                        // If the range exceeds 4G, split it in two so CPU and
+                        // GPU share the same addresses (SVM).
+                        if full.end > u64::SZ_4G {
+                            full.end / 2
+                        } else {
+                            user_max
+                        }
+                    }
+                };
+                candidate.min(user_max)
+            }
+        };
+
+        let delta = full.end - user_end;
+        // Pick a kernel VA range that's a power of two, to have a clear split.
+        let kernel_va_range = 1u64 << delta.ilog2();
+        let kernel_va_start = full.end - kernel_va_range;
+        let full_start = full.start;
+
+        Ok(Self {
+            full,
+            user: full_start..kernel_va_start,
+        })
+    }
+}
+
 /// Arguments for a virtual memory map operation.
 struct VmMapArgs<'drm> {
     /// Access permissions and caching behavior for the mapping.
@@ -334,26 +423,64 @@ pub(crate) struct Vm<'drm> {
     /// Non-core part of the GPUVM. Can be used for stuff that doesn't modify the
     /// internal mapping tree, like GpuVm::obtain()
     gpuvm: ARef<GpuVm<GpuVmData<'drm>>>,
-    /// VA range for this VM.
-    va_range: Range<u64>,
+    /// VA layout for this VM.
+    pub(crate) layout: VmLayout,
 }
 
 impl<'drm> Vm<'drm> {
-    /// Creates a new GPU virtual address space.
+    /// Creates the MCU/firmware VM.
     ///
-    /// The VM is initialized with a page table configured according to the GPU's
-    /// address translation capabilities and registered with the GPUVM framework.
-    pub(crate) fn new(
+    /// The MCU VM is entirely kernel-managed: it has no user-accessible range.
+    pub(crate) fn new_for_fw(
+        dev: &'drm Device<Bound>,
+        ddev: &TyrDrmDevice,
+        mmu: ArcBorrow<'_, Mmu<'drm>>,
+        gpu_info: &GpuInfo,
+    ) -> Result<Arc<Vm<'drm>>> {
+        // As in panthor: the CSF MCU is a Cortex-M7 and can only address 4G.
+        let layout = VmLayout {
+            full: 0..u64::SZ_4G,
+            user: 0..0u64,
+        };
+        Self::new_internal(dev, ddev, mmu, gpu_info, layout)
+    }
+
+    /// Creates a user VM, splitting the GPU VA range per `user_va`.
+    #[expect(dead_code)]
+    pub(crate) fn new_for_user(
         dev: &'drm Device<Bound>,
         ddev: &TyrDrmDevice,
         mmu: ArcBorrow<'_, Mmu<'drm>>,
         gpu_info: &GpuInfo,
+        user_va: UserVaRequest,
+    ) -> Result<Arc<Vm<'drm>>> {
+        let mmu_features = MMU_FEATURES::from_raw(gpu_info.mmu_features);
+        let va_bits = mmu_features.va_bits().get();
+        let range = 0..(1u64 << va_bits);
+
+        let layout = VmLayout::compute(range.clone(), user_va).inspect_err(|_| {
+            dev_dbg!(
+                dev,
+                "Failed to split GPU VA range {:#x}..{:#x} into user and kernel regions\n",
+                range.start,
+                range.end
+            );
+        })?;
+        Self::new_internal(dev, ddev, mmu, gpu_info, layout)
+    }
+
+    /// Initializes a VM with the given layout.
+    fn new_internal(
+        dev: &'drm Device<Bound>,
+        ddev: &TyrDrmDevice,
+        mmu: ArcBorrow<'_, Mmu<'drm>>,
+        gpu_info: &GpuInfo,
+        layout: VmLayout,
     ) -> Result<Arc<Vm<'drm>>> {
         let mmu_features = MMU_FEATURES::from_raw(gpu_info.mmu_features);
         let va_bits = mmu_features.va_bits().get();
         let pa_bits = mmu_features.pa_bits().get();
 
-        let range = 0..(1u64 << va_bits);
         let reserve_range = 0..0u64;
 
         // dummy_obj is used to initialize the GPUVM tree.
@@ -365,7 +492,7 @@ pub(crate) fn new(
             c"Tyr::GpuVm",
             ddev,
             &*dummy_obj,
-            range.clone(),
+            layout.full.clone(),
             reserve_range,
             GpuVmData::<'drm> {
                 _phantom: PhantomData::<&()>,
@@ -385,7 +512,7 @@ pub(crate) fn new(
                 mmu: mmu.into(),
                 gpuvm,
                 gpuvm_unique <- new_mutex!(gpuvm_unique),
-                va_range: range,
+                layout,
             }),
             GFP_KERNEL,
         )?;
@@ -416,10 +543,12 @@ fn deactivate(&self) -> Result {
 
     /// Kills the VM by deactivating it and unmapping all regions.
     pub(crate) fn kill(&self) {
-        // TODO: Turn the VM into a state where it can't be used.
         let _ = self.deactivate();
         let _ = self
-            .unmap_range(self.va_range.start, self.va_range.end - self.va_range.start)
+            .unmap_range(
+                self.layout.full.start,
+                self.layout.full.end - self.layout.full.start,
+            )
             .inspect_err(|e| {
                 dev_err!(self.dev, "Failed to unmap range during deactivate: {:?}", e);
             });
@@ -556,14 +685,14 @@ pub(crate) fn unmap_range(&self, va: u64, size: u64) -> Result {
 
         let end = va.checked_add(size).ok_or(EINVAL)?;
 
-        if va < self.va_range.start || end > self.va_range.end {
+        if va < self.layout.full.start || end > self.layout.full.end {
             dev_err!(
                 self.dev,
                 "Unmap range {:#x}..{:#x} exceeds VM range {:#x}..{:#x}",
                 va,
                 end,
-                self.va_range.start,
-                self.va_range.end
+                self.layout.full.start,
+                self.layout.full.end
             );
             return Err(EINVAL);
         }
@@ -573,7 +702,7 @@ pub(crate) fn unmap_range(&self, va: u64, size: u64) -> Result {
             region: va..end,
         };
 
-        let full_vm = va == self.va_range.start && end == self.va_range.end;
+        let full_vm = va == self.layout.full.start && end == self.layout.full.end;
 
         let mut resources = VmOpResources {
             preallocated_gpuvas: if full_vm {

-- 
2.43.0



