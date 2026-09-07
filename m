Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2906EC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C3D6B009F; Mon,  7 Sep 2026 12:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4703C6B00A4; Mon,  7 Sep 2026 12:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA2A6B009F; Mon,  7 Sep 2026 12:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7C556B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BEC5A3E6A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:21 +0000 (UTC)
X-FDA: 85187549202.04.DF7B1B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 680BB100008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKajOxCJ;
	spf=pass (imf14.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799699;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfW75DgXhfukIA3YcrFMglXiRVZVBqhxZYxTpMkhxtQ=;
	b=umCy1/wmMrpHihYyILtQy41GtHt04TDsfRCz1c4okRv6CPvIto6kIGmEZ2EN9jgt7YlaZ6
	OBraJmUxNI3Py+Vowx/YuyPlqFs33KJA0yrj9cXv7iQE0DlMYwrS/uqQ/3IoUAANtSje1D
	yN8Zj1zvXRNhjzMbU4sIoMhpS4xEuis=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKajOxCJ;
	spf=pass (imf14.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799699;
	b=h8R7zmj2w5hnbmqB6Q/AAYMopx6aXrKToPAn6Ru9PYvOKepFkU08Nntzc0lB5fKKy7CIn3
	pAABUiyW868zAZN2JawCDmvr86X54Q38KRPhD5PLVTGM9WlhzObvlojTK1/p2MA7jIRAfI
	fBuydIeTtTarRbdt7vJIcZeZGhvUFew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32EB144505;
	Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 108F7C2BCFD;
	Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799696;
	bh=RHfi2Li1pjmMjxsYwpNPo8HFOzZ5whVa/VYLYlScFng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HKajOxCJZ6bomQ7sisPJKqTgVQUZJITdpnbK6kEA0GmvItvUnDLKGHWurfsjv8Mak
	 OT5+G0P8ci+N3fRDSfHp/4wIXNXvleSQxE+Lcd8kBf6MDPB2ZgU2xdf9DLBclhkKwd
	 wx0vaKz7yNS6I5nZvndNAhMMOomyasrhv1JFmVEk2ZMrU0x94cokb3BWUEjP+Dirg0
	 pfQ+EOFOfvycFfTOs0p5pcOzZAqgVsQouQBvwHnd+I0t4a0hkuFKatQfSyfmfOviiY
	 CVh0MXRBFHJvJJjTyF3SYG5k/9CA6uDPtlsFaZWBXdIYvhPQSAo+hYES3G0WSmgy+w
	 dTbuH30IaU6wA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04E4C79FA0;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 08 Sep 2026 00:47:55 +0800
Subject: [PATCH v2 8/9] drm/tyr: add VM-related ioctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-tyr-ioctls-v2-8-88bea777df67@kylinos.cn>
References: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
In-Reply-To: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
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
 Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 Ke Sun <sunke@kylinos.cn>, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=20871;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=NR7nG2eCm80Nj4zxT38X9areFR+kkKPJPCASC1CIpKU=;
 b=vx3xtGKuUUse+QSolc01zw3arz+ZEynOpi2J1KLI1QdTqWjgcbuZJgATg09VFjH6sV/PAgJcG
 gyO1NQXTOmlA0kHF84dxkci/7N42sNH0gmQ4hWc6hy/yA8fnvPw2y6a
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: hdeuujhxakuy91qkry3yffeeeyfce1wm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 680BB100008
X-Rspam-User: 
X-HE-Tag: 1788799699-777860
X-HE-Meta: U2FsdGVkX18z8IcjwX6Q7c3t5nxJ9M+Jx6l5Uxoma5aVg1kCWgwkRySCQge3WCa0XOCiBJEdytSVRneYgYUsknJeK6xrAqABNMItDHf/PxA6XcXHrv2k+0QYy9gq0yHis9BwZELMG0lHDefYdZL/zoPqI8I/zAVfhBnfuATxlAqiHBe4q9DeGrmprmol300m/NWYeM5BSo/Hv5HjLPYNh8sobpQr4AWSHb80h5ukkwqoLB2VIzIApyFZ00+4/Mr3CKzBmg5h5PpteOhR69jqXmMwbb/l8fW3cAdCYEbavilDonQUSLnaNFkVILPDzrlRojFmDOb39xs1PtkcWQey8lBp19wUPgjLgyx71WNXA2LdOfKwXnRlfLJwpPfuPMVSIKV7bhe0vlr68q5M2mQZ6PxajwnnR3R7rcsd1s6VCf2lLIPs+gp8LKfJbNUoEkhsY4/oihk3jTp3CSPVVrGSiaGVXpsNZGwE62Om1Thg5WH1QpuQmeaYlLqlSySlx2Mg5Dnd5ML9cIQZ2qHjSMAVYsTFj+vEuvXxKKpOlLNS0PovjBc/+121blPI2XZmAWG+DAohYKmQpuNDgvtw84+sJLSiDmVuooEoUqJgU01uPbcLM9IgTzXXg4LyjvtzT00fWCmph/jKuGlpHcRq7ftC100cnIQ3M3XfavJa/i8IZ7KDHd/x2Fk2w/ySBHizlF25MJGuEZKfC5nDeNVaemFDcbyCcKTaaxWoC8FarWezrIB8KcZzC5roScgpDI30Q5w8Zr+r4Bd7MOcmqHwdHQkWZfGZyWC5XBknobsJFdhJpSYUdHpv6jSVgmbVbn1rtmVqbWweSwkfY88b13NVupGuaj8WJ25WoERKW87b0WbEmHtR8+51NLGz7jNerdKfVx5NNwV4PYj7daVRJmJPe4vzyc0wHlva/o1tIY22/UDcr/meC0E+/dZ3l0N4jDPRAf6QsjttLrZO+jPuVIhNgNC
 DSnK+nyQ
 KfvglTEh4sdhPLEVQuxWdBEGyd8A3nPgfNABODQIR6V/YwD3O7hG1dU0isj+0SoAZIv6lPBzt36s3sumwsuLIQ2fVTwUEowZ9IfoF1NZ5wuCjuRA/OHaQAfoOGMnUTW7HrivQyCAIFocM2WnAAqTFhM621ZILzKQUTIslJjVXePFkyfwdQjmWxCYfiliSAYs4kDpQtydzdaHSmUMLndUeofjFERSja3pGcrZD1oCtu/UIjkakkszDubLyCrItw/JpR1z5leVXEbvCc9ePeOOFn3m6ctmbMoaz8NtyEl+7ASkP0BD28ymxA6vw2ZOGVGHZIAw5inSID43UUKN+GkErVkNb9wkmmXysSyk7Oj/soMjS5LV2f0yEPX/Lz/wA/N8dJi1o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Implement VM_CREATE, VM_DESTROY, VM_BIND and VM_GET_STATE. VM_CREATE
gives the new VM's owner to the per-file pool, so an aborted creation
never leaks a VM; VM_DESTROY takes it back and dropping it kills the
VM immediately even if in-flight jobs still hold references (matching
panthor: such jobs are expected to fault). VM_BIND runs synchronously
for now.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/driver.rs |  12 +-
 drivers/gpu/drm/tyr/file.rs   | 308 ++++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/tyr/gem.rs    |   1 -
 drivers/gpu/drm/tyr/vm.rs     |  78 ++++++++---
 4 files changed, 369 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index 791c105ce626a..5757956470afd 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -33,7 +33,7 @@
         Mutex, //
     },
     time,
-    types::CovariantForLt, //
+    types::ForLt, //
 };
 
 use crate::{
@@ -72,6 +72,9 @@ pub(crate) struct TyrDrmRegistrationData<'drm> {
     /// Firmware sections.
     pub(crate) fw: Firmware<'drm>,
 
+    /// Memory management unit for address space slots.
+    pub(crate) mmu: Arc<Mmu<'drm>>,
+
     #[pin]
     clks: Mutex<Clocks>,
 
@@ -163,6 +166,7 @@ fn probe<'bound>(
         let reg_data = pin_init!(TyrDrmRegistrationData {
                 pdev,
                 fw: firmware,
+                mmu,
                 clks <- new_mutex!(Clocks {
                     core: core_clk,
                     stacks: stacks_clk,
@@ -206,7 +210,7 @@ fn drop(self: Pin<&mut Self>) {}
 impl drm::Driver for TyrDrmDriver {
     type Data = ();
     type RegistrationData<'drm> = TyrDrmRegistrationData<'drm>;
-    type File = CovariantForLt!(TyrDrmFileData);
+    type File = ForLt!(TyrDrmFileData<'_>);
     type Object = Bo;
     type ParentDevice<Ctx: DeviceContext> = platform::Device<Ctx>;
 
@@ -215,6 +219,10 @@ impl drm::Driver for TyrDrmDriver {
 
     kernel::declare_drm_ioctls! {
         (PANTHOR_DEV_QUERY, drm_panthor_dev_query, ioctl::RENDER_ALLOW, TyrDrmFileData::dev_query),
+        (PANTHOR_VM_CREATE, drm_panthor_vm_create, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_create),
+        (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
+        (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_bind),
+        (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
     }
 }
 
diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index 933a365cb016e..dceaae6fb9717 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -3,37 +3,60 @@
 use kernel::{
     drm::{
         self,
+        gem::BaseObject,
         Registered, //
     },
     prelude::*,
-    uaccess::UserSlice,
+    sizes::SizeConstants,
+    transmute::FromBytes,
+    uaccess::{
+        UserSlice,
+        UserSliceReader, //
+    },
     uapi, //
 };
 
-use crate::driver::{
-    TyrDrmDevice,
-    TyrDrmDriver,
-    TyrDrmRegistrationData, //
+use crate::{
+    driver::{
+        TyrDrmDevice,
+        TyrDrmDriver,
+        TyrDrmRegistrationData, //
+    },
+    vm::{
+        UserVaRequest,
+        Vm,
+        VmBindOpType,
+        VmMapFlags,
+        VmPool, //
+    }, //
 };
 
 #[pin_data]
-pub(crate) struct TyrDrmFileData {}
+pub(crate) struct TyrDrmFileData<'a> {
+    reg: &'a TyrDrmRegistrationData<'a>,
+
+    #[pin]
+    vm_pool: VmPool<'a>,
+}
 
 /// Convenience type alias for our DRM `File` type.
 pub(crate) type TyrDrmFile = drm::file::File<TyrDrmDriver>;
 
-impl drm::file::DriverFile<'_> for TyrDrmFileData {
+impl<'a> drm::file::DriverFile<'a> for TyrDrmFileData<'a> {
     type Driver = TyrDrmDriver;
 
     fn open(
         _device: &TyrDrmDevice<Registered>,
-        _reg_data: &TyrDrmRegistrationData<'_>,
+        reg_data: &'a TyrDrmRegistrationData<'a>,
     ) -> impl PinInit<Self, Error> {
-        Ok(Self {})
+        try_pin_init!(Self {
+            reg: reg_data,
+            vm_pool <- VmPool::new(),
+        })
     }
 }
 
-impl TyrDrmFileData {
+impl TyrDrmFileData<'_> {
     pub(crate) fn dev_query(
         _ddev: &TyrDrmDevice<Registered>,
         reg_data: &TyrDrmRegistrationData<'_>,
@@ -65,4 +88,269 @@ pub(crate) fn dev_query(
             }
         }
     }
+
+    pub(crate) fn vm_create(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        vmcreate: &mut uapi::drm_panthor_vm_create,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        if vmcreate.flags != 0 {
+            dev_err!(
+                ddev.as_ref(),
+                "Invalid VM create flags: {:#x}\n",
+                vmcreate.flags
+            );
+            return Err(EINVAL);
+        }
+
+        let ret: Result<u32, Error> = file.inner_with(|pfile| {
+            let vm = Vm::new_for_user(
+                pfile.reg.pdev.as_ref(),
+                ddev,
+                pfile.reg.mmu.as_arc_borrow(),
+                &pfile.reg.gpu_info,
+                UserVaRequest::from_uapi(vmcreate.user_va_range),
+            )?;
+            let user_va_range = vm.layout.user.end;
+            let id = pfile.vm_pool.add(vm)?;
+            vmcreate.user_va_range = user_va_range;
+            vmcreate.id = id;
+
+            Ok(0)
+        });
+        ret
+    }
+
+    pub(crate) fn vm_destroy(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        vmdestroy: &mut uapi::drm_panthor_vm_destroy,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        if vmdestroy.pad != 0 {
+            dev_err!(
+                ddev.as_ref(),
+                "Invalid VM destroy pad: {:#x}\n",
+                vmdestroy.pad
+            );
+            return Err(EINVAL);
+        }
+
+        let ret: Result<u32, Error> = file.inner_with(|pfile| {
+            pfile.vm_pool.remove(vmdestroy.id)?;
+            Ok(0)
+        });
+        ret
+    }
+
+    pub(crate) fn vm_bind(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        vmbind: &mut uapi::drm_panthor_vm_bind,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        let async_flag = uapi::drm_panthor_vm_bind_flags_DRM_PANTHOR_VM_BIND_ASYNC;
+
+        if vmbind.flags & !async_flag != 0 {
+            dev_err!(
+                ddev.as_ref(),
+                "Invalid VM_BIND flags: {:#x}\n",
+                vmbind.flags
+            );
+            return Err(EINVAL);
+        }
+
+        if vmbind.flags & async_flag != 0 {
+            dev_err!(ddev.as_ref(), "Async VM_BIND not supported\n");
+            return Err(ENOTSUPP);
+        }
+
+        let count = vmbind.ops.count as usize;
+        if count == 0 {
+            return Ok(0);
+        }
+
+        let size_of_op = size_of::<VmBindOp>();
+        // Stride versions the UAPI struct: reject only undersized strides.
+        if size_of_op > vmbind.ops.stride as usize {
+            dev_err!(
+                ddev.as_ref(),
+                "Invalid VM_BIND op stride {} (expected at least {})\n",
+                vmbind.ops.stride,
+                size_of::<VmBindOp>()
+            );
+            return Err(EINVAL);
+        }
+        let stride = vmbind.ops.stride as usize;
+
+        let total_len = stride.checked_mul(count).ok_or_else(|| {
+            dev_err!(ddev.as_ref(), "VM_BIND ops length overflow\n");
+            EINVAL
+        })?;
+        let mut reader =
+            UserSlice::new(UserPtr::from_addr(vmbind.ops.array as usize), total_len).reader();
+        let mut ops = KVec::new();
+        for _ in 0..count {
+            ops.push(reader.read::<VmBindOp>()?, GFP_KERNEL)?;
+            read_padding_zero(&mut reader, stride - size_of_op)?;
+        }
+
+        let ret: Result<u32, Error> = file.inner_with(|pfile| {
+            let vm = pfile.vm_pool.get(vmbind.vm_id).ok_or_else(|| {
+                dev_err!(ddev.as_ref(), "Invalid VM_BIND vm_id: {}\n", vmbind.vm_id);
+                EINVAL
+            })?;
+
+            for (i, op) in ops.iter().enumerate() {
+                if let Err(e) = vm_bind_exec_op(&vm, file, op) {
+                    dev_dbg!(ddev.as_ref(), "VM_BIND op {} failed: {:?}\n", i, e);
+                    vmbind.ops.count = i as u32;
+                    return Err(e);
+                }
+            }
+
+            Ok(0)
+        });
+        ret
+    }
+
+    pub(crate) fn vm_get_state(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        vmgetstate: &mut uapi::drm_panthor_vm_get_state,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        file.inner_with(|pfile| {
+            let vm = pfile.vm_pool.get(vmgetstate.vm_id).ok_or_else(|| {
+                dev_err!(
+                    ddev.as_ref(),
+                    "Invalid VM_GET_STATE vm_id: {}\n",
+                    vmgetstate.vm_id
+                );
+                EINVAL
+            })?;
+            vmgetstate.state = if vm.is_unusable() {
+                uapi::drm_panthor_vm_state_DRM_PANTHOR_VM_STATE_UNUSABLE
+            } else {
+                uapi::drm_panthor_vm_state_DRM_PANTHOR_VM_STATE_USABLE
+            };
+            Ok(0)
+        })
+    }
 }
+
+fn vm_bind_exec_op(vm: &Vm<'_>, file: &TyrDrmFile, op: &VmBindOp) -> Result {
+    if op.size == 0 {
+        return Ok(());
+    }
+
+    if op.syncs.count != 0 {
+        dev_err!(vm.dev(), "VM_BIND op syncs not supported\n");
+        return Err(EINVAL);
+    }
+
+    let end = match op.va.checked_add(op.size) {
+        Some(end) => end,
+        None => {
+            dev_err!(vm.dev(), "VM_BIND op VA range overflow\n");
+            return Err(EINVAL);
+        }
+    };
+    if op.va < vm.layout.user.start || end > vm.layout.user.end {
+        dev_err!(
+            vm.dev(),
+            "VM_BIND op VA range {:#x}..{:#x} outside user range\n",
+            op.va,
+            end
+        );
+        return Err(EINVAL);
+    }
+
+    if (op.va | op.size | op.bo_offset) & (u64::SZ_4K - 1) != 0 {
+        dev_err!(vm.dev(), "VM_BIND op not GPU-page-aligned\n");
+        return Err(EINVAL);
+    }
+
+    match VmBindOpType::try_from(op.flags) {
+        Ok(VmBindOpType::Map) => {
+            // Once the VM is unusable only MAP ops are rejected; UNMAP
+            // stays available for cleanup (see the UAPI docs).
+            if vm.is_unusable() {
+                dev_err!(vm.dev(), "VM_BIND map op on unusable VM\n");
+                return Err(EINVAL);
+            }
+
+            let map_flags = match VmMapFlags::try_from(op.flags & !VmBindOpType::MASK) {
+                Ok(flags) => flags,
+                Err(_) => {
+                    dev_err!(vm.dev(), "VM_BIND op invalid map flags {:#x}\n", op.flags);
+                    return Err(EINVAL);
+                }
+            };
+            let bo = crate::gem::lookup_handle(file, op.bo_handle).map_err(|_| {
+                dev_err!(vm.dev(), "VM_BIND op invalid BO handle {}\n", op.bo_handle);
+                EINVAL
+            })?;
+            // Validate the BO window before mapping.
+            let bo_size = bo.size() as u64;
+            if op.size > bo_size || op.bo_offset > bo_size - op.size {
+                dev_err!(vm.dev(), "VM_BIND op BO range out of bounds\n");
+                return Err(EINVAL);
+            }
+            vm.map_bo_range(&bo, op.bo_offset, op.size, op.va, map_flags)
+        }
+        Ok(VmBindOpType::Unmap) => {
+            // Unmap must not carry map-specific flags or BO references.
+            if op.flags & !VmBindOpType::MASK != 0 || op.bo_handle != 0 || op.bo_offset != 0 {
+                dev_err!(
+                    vm.dev(),
+                    "VM_BIND UNMAP carries flags/BO refs: flags={:#x} bo_handle={} bo_offset={}\n",
+                    op.flags,
+                    op.bo_handle,
+                    op.bo_offset
+                );
+                return Err(EINVAL);
+            }
+            vm.unmap_range(op.va, op.size)
+        }
+        Err(_) => {
+            dev_err!(
+                vm.dev(),
+                "VM_BIND op type {:#x} not supported\n",
+                op.flags & VmBindOpType::MASK
+            );
+            Err(EINVAL)
+        }
+    }
+}
+
+/// Reads `len` bytes of array padding, rejecting any nonzero byte with `E2BIG`.
+fn read_padding_zero(reader: &mut UserSliceReader, len: usize) -> Result {
+    let mut buf = [0u8; 64];
+    let mut remaining = len;
+    while remaining > 0 {
+        let chunk = remaining.min(buf.len());
+        reader.read_slice(&mut buf[..chunk])?;
+        if buf[..chunk].iter().any(|&b| b != 0) {
+            return Err(E2BIG);
+        }
+        remaining -= chunk;
+    }
+    Ok(())
+}
+
+#[repr(transparent)]
+struct VmBindOp(uapi::drm_panthor_vm_bind_op);
+
+impl core::ops::Deref for VmBindOp {
+    type Target = uapi::drm_panthor_vm_bind_op;
+
+    fn deref(&self) -> &Self::Target {
+        &self.0
+    }
+}
+
+// SAFETY: `VmBindOp` contains only integers, so any bit pattern is valid;
+// the `#[repr(transparent)]` wrapper has the same layout as the UAPI struct.
+unsafe impl FromBytes for VmBindOp {}
diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 2523d05de5527..e5030b645527d 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -76,7 +76,6 @@ pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result
 }
 
 /// Look up a GEM object by handle for a DRM file.
-#[expect(dead_code)]
 pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>> {
     Bo::lookup_handle(file, handle)
 }
diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index db9e2ccc55056..bd23f75a5bd8a 100644
--- a/drivers/gpu/drm/tyr/vm.rs
+++ b/drivers/gpu/drm/tyr/vm.rs
@@ -54,6 +54,11 @@
     },
     sync::{
         aref::ARef,
+        atomic::{
+            Acquire,
+            Atomic,
+            Release, //
+        },
         Arc,
         ArcBorrow,
         Mutex, //
@@ -173,7 +178,6 @@ pub(crate) enum UserVaRequest {
 
 impl UserVaRequest {
     /// UAPI boundary normalization: `0` -> [`Auto`](Self::Auto).
-    #[expect(dead_code)]
     pub(crate) fn from_uapi(v: u64) -> Self {
         match NonZeroU64::new(v) {
             Some(size) => Self::Fixed(size),
@@ -182,6 +186,38 @@ pub(crate) fn from_uapi(v: u64) -> Self {
     }
 }
 
+/// Operation type, packed into the top nibble of
+/// `drm_panthor_vm_bind_op::flags`.
+#[derive(Debug, Clone, Copy, PartialEq, Eq)]
+pub(crate) enum VmBindOpType {
+    /// Map a BO range into the VM.
+    Map,
+    /// Unmap a VA range.
+    Unmap,
+}
+
+impl VmBindOpType {
+    /// Bits occupied by the op type in `drm_panthor_vm_bind_op::flags`.
+    pub(crate) const MASK: u32 =
+        uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MASK as u32;
+}
+
+impl TryFrom<u32> for VmBindOpType {
+    type Error = Error;
+
+    fn try_from(flags: u32) -> Result<Self, Self::Error> {
+        const MAP: u32 = uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MAP as u32;
+        const UNMAP: u32 =
+            uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_UNMAP as u32;
+
+        match flags & Self::MASK {
+            MAP => Ok(Self::Map),
+            UNMAP => Ok(Self::Unmap),
+            _ => Err(EINVAL),
+        }
+    }
+}
+
 /// Owns a [`Vm`]'s destruction: the VM is killed exactly once, when this
 /// value is dropped, regardless of how many `Arc<Vm>` references remain.
 ///
@@ -254,12 +290,6 @@ pub(crate) fn compute(full: Range<u64>, req: UserVaRequest) -> Result<Self> {
         const MIN_KERNEL_VA: u64 = u64::SZ_256M;
 
         if full.end <= MIN_KERNEL_VA {
-            pr_err!(
-                "Invalid VA range {:#x}..{:#x}, kernel VA min required: >{:#x}\n",
-                full.start,
-                full.end,
-                MIN_KERNEL_VA
-            );
             return Err(EINVAL);
         }
 
@@ -269,11 +299,6 @@ pub(crate) fn compute(full: Range<u64>, req: UserVaRequest) -> Result<Self> {
             UserVaRequest::Fixed(v) => {
                 let user_size = v.get();
                 if user_size > user_max {
-                    pr_err!(
-                        "Requested user VA range {:#x} exceeds maximum {:#x}\n",
-                        user_size,
-                        user_max
-                    );
                     return Err(EINVAL);
                 }
                 user_size
@@ -487,6 +512,8 @@ pub(crate) struct Vm<'drm> {
     gpuvm: ARef<GpuVm<GpuVmData<'drm>>>,
     /// VA layout for this VM.
     pub(crate) layout: VmLayout,
+    /// Whether the VM is unusable.
+    unusable: Atomic<bool>,
 }
 
 impl<'drm> Vm<'drm> {
@@ -508,7 +535,6 @@ pub(crate) fn new_for_fw(
     }
 
     /// Creates a user VM, splitting the GPU VA range per `user_va`.
-    #[expect(dead_code)]
     pub(crate) fn new_for_user(
         dev: &'drm Device<Bound>,
         ddev: &TyrDrmDevice,
@@ -575,6 +601,7 @@ fn new_internal(
                 gpuvm,
                 gpuvm_unique <- new_mutex!(gpuvm_unique),
                 layout,
+                unusable: Atomic::new(false),
             }),
             GFP_KERNEL,
         )?;
@@ -607,6 +634,7 @@ fn deactivate(&self) -> Result {
     ///
     /// Only called from [`VmOwner`]'s `Drop`.
     fn kill(&self) {
+        self.mark_unusable();
         let _ = self.deactivate();
         let _ = self
             .unmap_range(
@@ -618,6 +646,15 @@ fn kill(&self) {
             });
     }
 
+    /// Marks the VM unusable.
+    fn mark_unusable(&self) {
+        self.unusable.store(true, Release);
+    }
+
+    pub(crate) fn is_unusable(&self) -> bool {
+        self.unusable.load(Acquire)
+    }
+
     /// Executes a virtual memory operation.
     ///
     /// This handles both map and unmap operations by coordinating between the
@@ -729,6 +766,17 @@ pub(crate) fn map_bo_range(
         };
         let result = {
             let mut gpuvm_unique = self.gpuvm_unique.lock();
+            // Check under the GPUVM lock so a concurrent kill cannot race
+            // with this operation.
+            if self.is_unusable() {
+                dev_err!(
+                    self.dev,
+                    "Failed to map VA {:#x}..{:#x}: VM is unusable\n",
+                    req.region.start,
+                    req.region.end
+                );
+                return Err(EINVAL);
+            }
             self.exec_op(gpuvm_unique.as_mut().get_mut(), req, &mut resources)
         };
         // We flush the defer cleanup list now. Things will be different in
@@ -1162,7 +1210,6 @@ pub(crate) struct VmPool<'drm> {
 
 impl<'drm> VmPool<'drm> {
     /// Creates a new [`VmPool`].
-    #[expect(dead_code)]
     pub(crate) fn new() -> impl PinInit<Self> {
         let ids = IdPool::new();
         pin_init!(Self {
@@ -1177,7 +1224,6 @@ pub(crate) fn new() -> impl PinInit<Self> {
     /// here and only the error is returned.
     // TODO: allocate IDs with the XArray directly (once it grows range
     // allocation, the equivalent of C's `XA_LIMIT`) and drop the IdPool.
-    #[expect(dead_code)]
     pub(crate) fn add(&self, vm: VmOwner<'drm>) -> Result<u32> {
         let id = {
             let mut ids = self.ids.lock();
@@ -1209,7 +1255,6 @@ pub(crate) fn add(&self, vm: VmOwner<'drm>) -> Result<u32> {
     /// Removes the VM with the given ID, handing back its owner.
     ///
     /// Dropping the returned [`VmOwner`] kills the VM immediately.
-    #[expect(dead_code)]
     pub(crate) fn remove(&self, id: u32) -> Result<VmOwner<'drm>> {
         let mut vms = self.vms.lock();
         match vms.remove(id as usize) {
@@ -1223,7 +1268,6 @@ pub(crate) fn remove(&self, id: u32) -> Result<VmOwner<'drm>> {
     }
 
     /// Gets a shared reference to the VM with the given ID.
-    #[expect(dead_code)]
     pub(crate) fn get(&self, id: u32) -> Option<Arc<Vm<'drm>>> {
         let vms = self.vms.lock();
         let borrow = vms.get(id as usize)?;

-- 
2.43.0



