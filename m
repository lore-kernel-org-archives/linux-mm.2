Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553A7C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6496B0096; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACE26B009E; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E0E6B009F; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82B706B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 050481201C6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:18 +0000 (UTC)
X-FDA: 85187549118.30.584E3DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E94B880005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrqOjbmp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799697;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+L6V2ZbqOPyQf/mFEM3lGEBL7WqRrGU2zjT/oqexZY=;
	b=3kynj8HYkcLp9hgllZKuGCXQx1h6LApgXUjtbRXYbebTvQXRMCZYn69BZ8GCU6rRkaTvfn
	cysA9sBYFROwpyJhvvme47lxUIYGDmG4hZ4bNlDLb+apXqz+IpiAPSzz/3k4Oj4MJAD4cd
	+kH+iZCzDMzHa8GAnI8giAul+LTqa6U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrqOjbmp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799697;
	b=FKFy0u5YBzM3DFy7cYv8Tsfk52zQbUkeV649WrjM6MW313JpWYcIqRjzJdXf+ARKG5/Wcn
	7UCuslsiS5OUqxRrWi3bF40pOz1z6O1YfREC5/gC89UZJaur42wqSrphSWqd15ROqGC4oy
	FNJmiIQ/RHcQ4FW8WqUUI15r0PxTYOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2DE043F68;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0338C32782;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799695;
	bh=TlVDi0TxMxxZeN20pGON06eoA/EsPc4W/j9d+dr0EhM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rrqOjbmpmqhDnPZQ0rqFifLFA1QDqx8VSp7Xw6zgQw360DA8I+CAfJKeMYotSeExN
	 cWt8u/DpXUOFptrj2d8OvYJQFR8v5AmwMzj9qAGJwo66ki+o4coY6jXsnACXPmbYdD
	 A+lYVk63Bo5/uFF3DpJa4sqjJtDOmJnphLMfva70KbJ5n4SoE9Yi5d8nzG21k76E1m
	 nLwCAN29qjSPTjcUvU0HOa5QoeZS0xSCldT6xelKPok+y9f+Hjvp3aVtZxKWyBOE/h
	 ZjmKIBWr54s6dchB/CWxK2UtTj0mJ2bn732+eUjHZr8ThThqVMecJ9Y1qsIIzQCsy6
	 XRMi3CB+Mk7yA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A13C79F99;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 08 Sep 2026 00:47:51 +0800
Subject: [PATCH v2 4/9] drm/tyr: add per-file VM pool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-tyr-ioctls-v2-4-88bea777df67@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=6892;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=E5fAToBpW3fHYqXQ6LGiOZHomFP/OX5vReY6bzJsSvg=;
 b=/QTBTvhX2T9UgC1tr/jeIEsYz/XsFx949EuBDEIsCSIpGS0QvOWaEgti35ACCW4yDWb3TyIiN
 cmwwPpJeyItAczO/lPVp4oRzhYzxwsRNOtPfoGmGNyPagUZbuQnAzCk
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E94B880005
X-Stat-Signature: mqseks4x8ftd3ndg3oih8dad9r6mwoms
X-Rspam-User: 
X-HE-Tag: 1788799696-929625
X-HE-Meta: U2FsdGVkX1/fJ2FKeNX88fh8RZzhRgh/LuzT2eT+QKt6lJUmUw/bFTPsNTtjSvRL891c1lMko9OYFosos6g+tytzFxnaFYXbVmJJ5FtxJP0wcYL10ShVLteGigEDupA/QkBrskWb4ytRAwMWJ19+Va+scsaYr6z/PLb1fmQo0apD4Lv5e10DG7mM2pRAqgHneVgvbR2GfuhfDikApYUlCmeZoB0h4tb+eOShXK/Zyaxp9F2e/NjH9IQV2JJ1DS08Nz3p+lbYTWQ5CxWSHu9VKXpu+ces6C1RObsId1e5Z6mb7JaMR912qNJuwcZd5dfVCc1MQB9xwPJZ1L1GMBQFU5iafL1cG5bKKgDm8ozvA6z791AfIBVkUMxhsGHMSkkLyREVowXAqFy6MAMYvwxJ1Z0iSJvQxlmnhWMG7Ngt5U6eTwftmhV675U7E5ZJdBTMFzmU6a6W3ZGSMqSRS/IqN32LMAflYT9N6wQMZS5+5NxYwpwKEW4NkXjrqrrpDiq3uo574PXnyDTD8NVkXeP/VoScpYTwM0d0/otno99O6xoL/KIqrDAfzusvDHm51/HN3jmTtwcjovrdk5zcr0JKw6YVFOFyMKtorCgUV4ETd7On2WOg4vdveX/LAso6+p09Nfiln9Z8jZVctnn6K5wiG3/T29DgLFI+pRJXpKUFaX0QzBEskivZbvdDUb+unkeQUpA/5/XZvh3oD7BXxy0uUn8wqA878vY1QvIqqmZciAIKhR9TmxCuG2S6xVpk/zJh/BhSGPPICSTQje2EjRsiI4bjIdvbdddk9z/DwBvSE3+Zir3E0E/2pkDttsk7EPmVMVdZh/IlN1zFShWj/HqrFeOevd+v5Ixofbn6F/tz74iDfkCMDuQGJ2KxZAjZgHh3x+2B6uBNc7jlpsZWrEXLrhW9y9aRkGfj7B3HfuZT2WYC2+FDD3t/xK8ITbRIETrnTERTtr5RiAweMqx8w+e
 xFUGwymk
 6LDTfOf2PkfesMv8nAW1AwqXfisEyNmXGLJ86zie7CpXRiPcpNox7O59aXRi8WF2+zyRROUYsYSQJk9n6wWGIOeu8hQyhqLG1SQDYM3fJCf3IHMWfPO0b7dP40f9soHtlPFMfT8JsD5sd+H3Mp2QCNI7uuiThrvwy8yMVVh2ALdZ+ZeGwRR3HtzJHDBcDYTfTknt1R3pCoyn4WjwxZnFRYJ3lfndZbEAufiStS7C3AtgeI9sCzYN56MVZLD3J+peGQG0ShqGnXpR4skKoe8lcoA1h8viYWGEYklssIh9R2UXgb2z0hIyFCdNScnKCte+B5Vv5+WKj/AY6o36AydCKewUciYf7hfcsCS+D0+niTbiue2snaRRWVb1nx0N0DNX2dF3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Userspace needs multiple independent GPU address spaces per file,
addressed by ID through the VM ioctls as in panthor. Store them in an
IdPool (capped at 32 for panthor parity) plus an XArray. Each VM is
stored with its VmOwner, so it is killed exactly once - on destroy or
file close - regardless of remaining shared references.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/vm.rs | 157 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 156 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index c5e307b1e2416..ae58135eeffdc 100644
--- a/drivers/gpu/drm/tyr/vm.rs
+++ b/drivers/gpu/drm/tyr/vm.rs
@@ -8,6 +8,7 @@
 //! mapped into hardware address space (AS) slots for GPU execution.
 
 use core::marker::PhantomData;
+use core::mem::ManuallyDrop;
 use core::ops::Range;
 
 use kernel::{
@@ -33,6 +34,7 @@
         }, //
     },
     fmt,
+    id_pool::IdPool,
     impl_flags,
     io::PhysAddr,
     iommu::pgtable::{
@@ -53,7 +55,11 @@
         ArcBorrow,
         Mutex, //
     },
-    uapi, //
+    uapi,
+    xarray::{
+        AllocKind,
+        XArray, //
+    }, //
 };
 
 use crate::{
@@ -154,6 +160,57 @@ fn try_from(value: u32) -> Result<Self, Self::Error> {
     }
 }
 
+/// Owns a [`Vm`]'s destruction: the VM is killed exactly once, when this
+/// value is dropped, regardless of how many `Arc<Vm>` references remain.
+///
+/// Callers that only need to use the VM take an `Arc<Vm>` via
+/// [`VmOwner::get()`], which keeps it alive but does not kill it.
+pub(crate) struct VmOwner<'drm>(ManuallyDrop<Arc<Vm<'drm>>>);
+
+impl<'drm> VmOwner<'drm> {
+    /// A reference for callers that want to use the VM, not own it.
+    #[expect(dead_code)]
+    pub(crate) fn get(&self) -> Arc<Vm<'drm>> {
+        Arc::clone(&self.0)
+    }
+
+    /// Transfers the VM to the pool without killing it, leaving only the
+    /// shared reference. The pool reconstructs the owner with
+    /// [`VmOwner::from_shared()`] when the VM is removed.
+    fn into_shared(mut self) -> Arc<Vm<'drm>> {
+        // SAFETY: `self.0` is initialized, and `forget(self)` below prevents
+        // the outer wrapper from being dropped, so the taken `Arc` is moved
+        // out exactly once and nothing is leaked or double-dropped.
+        let vm = unsafe { ManuallyDrop::take(&mut self.0) };
+        core::mem::forget(self);
+        vm
+    }
+
+    /// Reconstructs an owner from a shared reference.
+    ///
+    /// The caller must currently own the VM's destruction.
+    fn from_shared(vm: Arc<Vm<'drm>>) -> Self {
+        Self(ManuallyDrop::new(vm))
+    }
+}
+
+impl<'drm> core::ops::Deref for VmOwner<'drm> {
+    type Target = Vm<'drm>;
+
+    fn deref(&self) -> &Vm<'drm> {
+        &self.0
+    }
+}
+
+impl Drop for VmOwner<'_> {
+    fn drop(&mut self) {
+        self.0.kill();
+        // SAFETY: `self.0` is initialized and we are in `drop`, so it is safe
+        // to drop the inner `Arc` now that the VM has been killed.
+        unsafe { ManuallyDrop::drop(&mut self.0) };
+    }
+}
+
 /// Arguments for a virtual memory map operation.
 struct VmMapArgs<'drm> {
     /// Access permissions and caching behavior for the mapping.
@@ -948,3 +1005,101 @@ fn pt_unmap(dev: &Device, pt: &IoPageTable<'_, ARM64LPAES1>, range: Range<u64>)
 
     Ok(())
 }
+
+/// Maximum number of VMs a single file may hold, matching panthor's
+/// `PANTHOR_MAX_VMS_PER_FILE`.
+const MAX_VMS_PER_FILE: usize = 32;
+
+/// Per-open-file pool of VMs.
+#[pin_data(PinnedDrop)]
+pub(crate) struct VmPool<'drm> {
+    #[pin]
+    ids: Mutex<IdPool>,
+    #[pin]
+    vms: XArray<Arc<Vm<'drm>>>,
+}
+
+impl<'drm> VmPool<'drm> {
+    /// Creates a new [`VmPool`].
+    #[expect(dead_code)]
+    pub(crate) fn new() -> impl PinInit<Self> {
+        let ids = IdPool::new();
+        pin_init!(Self {
+            ids <- new_mutex!(ids),
+            vms <- XArray::new(AllocKind::Alloc),
+        })
+    }
+
+    /// Takes ownership of `vm` and stores it, returning the allocated ID.
+    ///
+    /// On failure - ID space exhausted or store failure - the VM is killed
+    /// here and only the error is returned.
+    // TODO: allocate IDs with the XArray directly (once it grows range
+    // allocation, the equivalent of C's `XA_LIMIT`) and drop the IdPool.
+    #[expect(dead_code)]
+    pub(crate) fn add(&self, vm: VmOwner<'drm>) -> Result<u32> {
+        let id = {
+            let mut ids = self.ids.lock();
+            let unused = ids.find_unused_id(1).ok_or(ENOSPC)?;
+            if unused.as_usize() > MAX_VMS_PER_FILE {
+                return Err(ENOSPC);
+            }
+            unused.acquire()
+        };
+
+        let vm = vm.into_shared();
+        let mut vms = self.vms.lock();
+        match vms.store(id, vm, GFP_KERNEL) {
+            Ok(prev_vm) => {
+                drop(prev_vm);
+                Ok(id as u32)
+            }
+            Err(err) => {
+                // Drop the XArray spinlock before acquiring the `ids` mutex.
+                drop(vms);
+                // Kill the VM and release the pooled id before returning.
+                drop(VmOwner::from_shared(err.value));
+                self.ids.lock().release_id(id);
+                Err(err.error)
+            }
+        }
+    }
+
+    /// Removes the VM with the given ID, handing back its owner.
+    ///
+    /// Dropping the returned [`VmOwner`] kills the VM immediately.
+    #[expect(dead_code)]
+    pub(crate) fn remove(&self, id: u32) -> Result<VmOwner<'drm>> {
+        let mut vms = self.vms.lock();
+        match vms.remove(id as usize) {
+            Some(vm) => {
+                drop(vms);
+                self.ids.lock().release_id(id as usize);
+                Ok(VmOwner::from_shared(vm))
+            }
+            None => Err(EINVAL),
+        }
+    }
+
+    /// Gets a shared reference to the VM with the given ID.
+    #[expect(dead_code)]
+    pub(crate) fn get(&self, id: u32) -> Option<Arc<Vm<'drm>>> {
+        let vms = self.vms.lock();
+        let borrow = vms.get(id as usize)?;
+        Some(Arc::from(borrow))
+    }
+}
+
+#[pinned_drop]
+impl PinnedDrop for VmPool<'_> {
+    fn drop(self: Pin<&mut Self>) {
+        let this = self.project();
+        // Kill every VM still owned by the pool. The ID range is bounded by
+        // `MAX_VMS_PER_FILE`, so this loop is cheap and runs at file close.
+        for id in 1..=MAX_VMS_PER_FILE {
+            // Release the XArray lock guard before killing: `kill()` may sleep.
+            let vm = this.vms.lock().remove(id);
+            drop(vm.map(VmOwner::from_shared));
+        }
+    }
+}

-- 
2.43.0



