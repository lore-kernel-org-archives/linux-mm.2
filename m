Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B8AC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1DC6B029F; Tue,  1 Sep 2026 12:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BA86B029B; Tue,  1 Sep 2026 12:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DDE6B029F; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA4E46B0299
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D9D11C207A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:22 +0000 (UTC)
X-FDA: 85165678164.02.E6F016B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 228B21C0018
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B0VQyxh6;
	spf=pass (imf20.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278960;
	b=HvqmKrtGUUgwn++xuYtLiv6JpIVebP+36N22xbCwWk5tD4akRVKaZvsIO+hVUZ72zphkeC
	A9C9B5atQ5lEsnDRU0Up2m8yIiJcj2WM0YWvKSf90zPBe4cuDBn0STixvSVQvusB3LcDd1
	ic757JLxgsmq/97Bk1+hNOSrIFSFhJg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B0VQyxh6;
	spf=pass (imf20.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278960;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8OUsND8/xA3NdlrXYgdAVq9e9mlZqViNdMBfXLr1Pw=;
	b=6PKN9iE9qK10l/AVBQ2dOFjvgxpUhlGo8+Oks6rnb0vFnJtOIl0WpanR4zLJVgEUor/aJS
	x4HxQHy0I6WxgyM11lsp94fRuWsixRLYV5wIH5VCrUuLykXlIUCYjEktkr+xlJs9IEHqGi
	VKOWU3NPqfPpWr15+BRJOiQq96Fqd74=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3AF4435E5;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD29EC2BCFF;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=cw3f2x1GbJSqzOgRbTGfEjpybb2q2g41K94Jc4NVQoY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=B0VQyxh6iyr398tRYC2jM8w1XrYic3fuLJc1A75Jh1/X4iDfDOJPwOSDfOQAWHSz0
	 wYFnO2SJH3Oj/M9GxnPZ6h+gKTY8Rj9JvXqVI6PhjCjc8MMB/wRo+rZQtzBhrIXwHj
	 sJteaJd23Rf++uZa3YUVNcDWvzVwiF2RSXA4293f8W+EdCwZBnE5r+TOslrFGogZN2
	 xEPa1F1P7uxEKqlh/9BlJQnx0WsUUgP1lgrQu/YvYLf2EuE924+jR+/Tcnu9yxwAj9
	 EgWv3tOoWQYhMYKIyh3Kp+p4dcmWcWzGLAqtHa0s0FU7zbsO+8dOA6PYIIasYxZ9rk
	 hpilQIk+hcbqQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75F9C624D5;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Wed, 02 Sep 2026 00:09:07 +0800
Subject: [PATCH 8/9] drm/tyr: add VM-related ioctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-tyr-ioctls-v1-8-e0fdbf8bd108@kylinos.cn>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
In-Reply-To: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=16278;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=A0Lnaw5c7egAHpTai8vWjw5a256cs/YFCe2NaCe06hU=;
 b=faNpv23p7LweACexfwrogN/u0AX0wg8LVFWtZoLPYXi9bZUQWR3NvkGY8YWQYU4x3kNgCwG+w
 TI6fGCmSqU4APwvuuhQYBTlGOz2KnLP2cDtvZIsZeX+3ujjazndE/Cj
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Stat-Signature: txp78i7idz9pp415ra8x66b4w9nxppeq
X-Rspamd-Queue-Id: 228B21C0018
X-Rspamd-Server: rspam06
X-HE-Tag: 1788278960-152083
X-HE-Meta: U2FsdGVkX1/1puYyVLGlmdLBW6zC94dkgAbjHHM270UUQglbz5g96EQshzcIJSsyv0KtXSiYckPj5zykPU82YcAtocTg3o7XuTOKFTSzsAdCUYR8heTOgHFAYS0i887n7FRcInRTIITfGzzyc2dhAOmPuv9KGQK1O8TVWK1JF3DfliFcF9KP8olQtCbfYrvdSnMeQYnxl9rBvgNNgyQutZ7Nb6h5zKPI5XUahyE34erHGCmqm5ruKNGIfnqTeOtHSG/U+uWNQ8uA5ZGV9mgh6KbbFl33SfVMIFKG/Sk1tmWjiNtP7Y0fwUFJy6alq5/yZJUq+KfIGLPKKp41xG3AJIAmOUGdmvwffY7nb7nMeHwbckAqGYhZYIrF1OLl90t6VZXHAtBrMuMZAI/TeHj1AQBkGuFjSQg4f5F+Ln8Pvk1gT5DFlfIX8XUuHiO//ka8gbJJ+aFFWm8SFxRqZbTBNjg5BUP2O1axC8oVuDYBvELSKdsTxi5+deWCEZ0PDF0GIwJuRl9hJqK628UFfA3GtFiMfN0ySSwS1TZarb0ad3tdf3CqV+GWqT8mqXzKB6v9T6Olyod/8dUX9L54lc2dGREyVzoBy6tzPEQndYS6Rn1FHIr2yQsKD3cRMjwvCoKSQKhMXa8vkjeCN42fKOIldpGSVviQ/JLdYjfTpB3sbVfMy88aa7bR+TW3h8oYvynQrbmdKK0M7q9asyVtt90cirAQBymp+pWJE8NZPx9pdovqcudLljUy7hwj9A7PSgtzHJ4j0DIuxj1Yve9kBfpzdKplGfXl2ZL2rYwMhg0ny6MdcgQISL756+UPHPBF/V1xzFT2mt8RqJ0Q90fhN4I4Sgn8NBVmbtz6HlDqiMVgUJ0qIEVA1M2IKWUGO2b6L8mOuBo2lrdCtdolh6kDf7Rh4ZUxGA09IhSF/MrpwSnc/ZiUAM0DJoDZO8pY3dSVuXwtLXiACN9gJduI1BE1oAM
 JyNSoT6b
 pTWKqZ1INpaHz8vMh24eiemKOTi6dLeK+Hlnn14LBWa56eshJjT41GcA0b2ROzeIar7Zd3VBZoTagjpUMIBku4JlLAoZT9bNiuUGmAe5L4eYQ7/g8/wbO7IAJwLWhrA1fduI1InCp409dajJQd1iRb0YeHncgg4ddlDgeXNw3cXiip2DWvgQc1Efv6LjJnuoraaEOrmhcvqpvx4BtMR01I/50r9+gduZ3xXDRHp3pqVqTB4PiRPV2i9GUh7IcqJ4LGxDED9hLKpBanpf/1PAFnRYZKVww2R4BnTSwVIUBuZzZGMAqpZTQs7S/1xMUoPHS1mzQn4ODLwQXK6h6KWv4O/JPuzf4KYw9XOuaPesb+QBTpZ5mDRLNN161bxYUfPR7HMy8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Manage per-file user VMs.

- VM_CREATE creates a user VM and returns its ID.
- VM_DESTROY destroys the VM identified by the given ID.
- VM_BIND maps or unmaps BO ranges in the VM's user VA space.
- VM_GET_STATE reports whether the VM is usable or unusable.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/driver.rs |  12 +-
 drivers/gpu/drm/tyr/file.rs   | 324 ++++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/tyr/vm.rs     |  24 +++-
 3 files changed, 346 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index 94bc85635725e..b3145526ada06 100644
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
 
@@ -164,6 +167,7 @@ fn probe<'bound>(
         let reg_data = pin_init!(TyrDrmRegistrationData {
                 pdev,
                 fw: firmware,
+                mmu,
                 clks <- new_mutex!(Clocks {
                     core: core_clk,
                     stacks: stacks_clk,
@@ -207,7 +211,7 @@ fn drop(self: Pin<&mut Self>) {}
 impl drm::Driver for TyrDrmDriver {
     type Data = ();
     type RegistrationData<'drm> = TyrDrmRegistrationData<'drm>;
-    type File = CovariantForLt!(TyrDrmFileData);
+    type File = ForLt!(TyrDrmFileData<'_>);
     type Object = Bo;
     type ParentDevice<Ctx: DeviceContext> = platform::Device<Ctx>;
 
@@ -216,6 +220,10 @@ impl drm::Driver for TyrDrmDriver {
 
     kernel::declare_drm_ioctls! {
         (PANTHOR_DEV_QUERY, drm_panthor_dev_query, ioctl::RENDER_ALLOW, TyrDrmFileData::dev_query),
+        (PANTHOR_VM_CREATE, drm_panthor_vm_create, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_create),
+        (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
+        (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_bind),
+        (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
     }
 }
 
diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index 933a365cb016e..157bc40e1cac4 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -3,37 +3,70 @@
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
+    pool::VmPool,
+    vm::{
+        UserVaRequest,
+        Vm,
+        VmMapFlags,
+        VmSpec, //
+    }, //
 };
 
-#[pin_data]
-pub(crate) struct TyrDrmFileData {}
+#[pin_data(PinnedDrop)]
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
+            vm_pool <- VmPool::new()?,
+        })
     }
 }
 
-impl TyrDrmFileData {
+#[pinned_drop]
+impl PinnedDrop for TyrDrmFileData<'_> {
+    fn drop(self: Pin<&mut Self>) {
+        let proj = self.project();
+        while let Some(vm) = proj.vm_pool.pop_first() {
+            vm.kill();
+        }
+    }
+}
+
+impl TyrDrmFileData<'_> {
     pub(crate) fn dev_query(
         _ddev: &TyrDrmDevice<Registered>,
         reg_data: &TyrDrmRegistrationData<'_>,
@@ -65,4 +98,273 @@ pub(crate) fn dev_query(
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
+        let ret: Result<u32, Error> = file.inner_with(|fd| {
+            let vm = Vm::new(
+                fd.reg.pdev.as_ref(),
+                ddev,
+                fd.reg.mmu.as_arc_borrow(),
+                &fd.reg.gpu_info,
+                VmSpec::User {
+                    user_va: UserVaRequest::from_uapi(vmcreate.user_va_range),
+                },
+            )?;
+            vmcreate.user_va_range = vm.layout.user.end;
+
+            let id = fd.vm_pool.add(vm.as_arc_borrow()).inspect_err(|_| {
+                vm.kill();
+            })?;
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
+        let ret: Result<u32, Error> = file.inner_with(|fd| {
+            let vm = fd.vm_pool.remove(vmdestroy.id)?;
+            vm.kill();
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
+                "Invalid VM_BIND op stride {}\n",
+                vmbind.ops.stride
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
+        let ret: Result<u32, Error> = file.inner_with(|fd| {
+            let vm = fd.vm_pool.get(vmbind.vm_id).ok_or_else(|| {
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
+        file.inner_with(|fd| {
+            let vm = fd.vm_pool.get(vmgetstate.vm_id).ok_or_else(|| {
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
+}
+
+fn vm_bind_exec_op(vm: &Vm<'_>, file: &TyrDrmFile, op: &VmBindOp) -> Result {
+    if vm.is_unusable() {
+        dev_err!(vm.dev(), "VM_BIND on destroyed VM\n");
+        return Err(EINVAL);
+    }
+
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
+    const TYPE_MASK: u32 =
+        uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MASK as u32;
+    const TYPE_MAP: u32 = uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MAP as u32;
+    const TYPE_UNMAP: u32 =
+        uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_UNMAP as u32;
+
+    match op.flags & TYPE_MASK {
+        TYPE_MAP => {
+            let map_flags = match VmMapFlags::try_from(op.flags & !TYPE_MASK) {
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
+        TYPE_UNMAP => {
+            // Unmap must not carry map-specific flags or BO references.
+            if op.flags & !TYPE_MASK != 0 || op.bo_handle != 0 || op.bo_offset != 0 {
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
+        _ => {
+            dev_err!(vm.dev(), "VM_BIND op type {:#x} not supported\n", op.flags);
+            Err(EINVAL)
+        }
+    }
 }
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
diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index 76c3d60bb2fe2..610bab69c1a55 100644
--- a/drivers/gpu/drm/tyr/vm.rs
+++ b/drivers/gpu/drm/tyr/vm.rs
@@ -10,6 +10,10 @@
 use core::marker::PhantomData;
 use core::num::NonZeroU64;
 use core::ops::Range;
+use core::sync::atomic::{
+    AtomicBool,
+    Ordering, //
+};
 
 use kernel::{
     device::{
@@ -437,6 +441,8 @@ pub(crate) struct Vm<'drm> {
     gpuvm: ARef<GpuVm<GpuVmData<'drm>>>,
     /// VA layout for this VM.
     pub(crate) layout: VmLayout,
+    /// Whether the VM is unusable.
+    unusable: AtomicBool,
 }
 
 impl<'drm> Vm<'drm> {
@@ -496,6 +502,7 @@ pub(crate) fn new(
                 gpuvm,
                 gpuvm_unique <- new_mutex!(gpuvm_unique),
                 layout,
+                unusable: AtomicBool::new(false),
             }),
             GFP_KERNEL,
         )?;
@@ -526,7 +533,7 @@ fn deactivate(&self) -> Result {
 
     /// Kills the VM by deactivating it and unmapping all regions.
     pub(crate) fn kill(&self) {
-        // TODO: Turn the VM into a state where it can't be used.
+        self.mark_unusable();
         let _ = self.deactivate();
         let _ = self
             .unmap_range(
@@ -538,6 +545,15 @@ pub(crate) fn kill(&self) {
             });
     }
 
+    /// Marks the VM unusable.
+    pub(crate) fn mark_unusable(&self) {
+        self.unusable.store(true, Ordering::Release);
+    }
+
+    pub(crate) fn is_unusable(&self) -> bool {
+        self.unusable.load(Ordering::Acquire)
+    }
+
     /// Executes a virtual memory operation.
     ///
     /// This handles both map and unmap operations by coordinating between the
@@ -649,6 +665,12 @@ pub(crate) fn map_bo_range(
         };
         let result = {
             let mut gpuvm_unique = self.gpuvm_unique.lock();
+            // Check under the GPUVM lock so a concurrent `mark_unusable()`
+            // teardown cannot race with this operation.
+            if self.is_unusable() {
+                dev_err!(self.dev, "Cannot map on unusable VM\n");
+                return Err(EINVAL);
+            }
             self.exec_op(gpuvm_unique.as_mut().get_mut(), req, &mut resources)
         };
         // We flush the defer cleanup list now. Things will be different in

-- 
2.43.0



