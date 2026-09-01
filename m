Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1FCCC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA2B6B028D; Tue,  1 Sep 2026 12:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1466B028E; Tue,  1 Sep 2026 12:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7336B028F; Tue,  1 Sep 2026 12:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A64206B028D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CB8A40469
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:20 +0000 (UTC)
X-FDA: 85165678080.18.010F3A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E66D940008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RtNnEY7h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278958;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mz99eWq1invPFNouTi8ecn8aCY7wOTBsvojLW/naRpQ=;
	b=WSt+Lyg34n6PcnGjHhDRUutEYD+IVO/dVVZuPnmDQZL38X2fT9fnb9j30IG2hhd9sHRvss
	kIKJ8T0grLlaADVYOAlpMqoQU8IOHVjX+ZKYwX08vVKdzmnCyI3HtE9vFF+tRFFL2GXFBe
	zBqN4hlDrebc/bn21K7HHaGywEeQIGM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RtNnEY7h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278958;
	b=HQAahNxLzai4ebhOlDqu9ScA7HLHaFeOO8x4mMBtp7ykFrEqhnreazOfLz2lOnKTUw9JX8
	b7pnYV87UbBzD1KYz2Cbhz1RuEeQvqnKFXuKnnaPGPJl6zIRyYwoJ+eVTTwoFJELxRHHw0
	RlU1zwIsOWzQS8B7oiGXXDzXD7rfil4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7699435AF;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C349C32782;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=vVRTAJM2qAJtjzVNw7AfiDMOZQ6QUxUlTdr6404pWUc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RtNnEY7hoph2NGV04fm7KqnQgfxO8XyXwmiTGUGtI3nVJfe16N40RwZkDYLT+ksZO
	 2YY+rS0wl+a+/TsgI1fmeUZgiWHI+idrSNb+jMfzJSc+f7p5rqYHt+gtS1nGBEt+IQ
	 dRR3YQt/Hkm0k0lq+vc9whkbty2GyDmdKXMhfr+Hcreqfr/NlHeuETdjUGbqFSo39e
	 SNoFvcFY8ssqH8I5/kD0XGsv8IgmE43VcBeYNH6Mw5uGP91kgbiGcsWCMkvivJ5157
	 W5XF6Y7c/8MUnW/r6hyHIp1Bo/d4MA3WA5xjWPleDxXUVo51o6H1b21u9574RPh0Oq
	 8D6lZfwiTb+eA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CD2C624D7;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Wed, 02 Sep 2026 00:09:03 +0800
Subject: [PATCH 4/9] drm/tyr: add per-file VM pool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-tyr-ioctls-v1-4-e0fdbf8bd108@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=3857;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=GYNt5fASDjvzxxgWZLDWPIxhdkvjI20iaVSTTPTfRwI=;
 b=zNDRrCK4SuOMnUEDGOcfEfklYsW34X7DcrbeHuulWK+S9BJ2TEp/jQ1FknCrKMDLdreWsyCD/
 nGswWYrR5lrDce2bdKmuXNKhOd67JYC7lkzIJftaHcELHGgPGNrZ0Jc
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: 6eh8n8y3y1bjp7e4g6pw8rzcdabznn18
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E66D940008
X-Rspam-User: 
X-HE-Tag: 1788278957-244941
X-HE-Meta: U2FsdGVkX1+unqgZrZP62eYFs9hZLp0UMWMsHNqIndHO05b5T7NGjHCPBDb8O4tgfFlz590y0C4xqlOnIBHXOIbmJIAAzv1I220+1djbL+I98j+yIi9CDJ5M195CGMaWEyXiYNKFDq8/qdSvi9+NI6F1bsk/SWdXoQBau1GeGmOEdQ/DL0MwTx2PX1lTEc8J2qUHrvQb/pABibF3P0GYnVtFUtRtTkghlPoFd22FKyWE0DtoZUEkewWYSU6xFlifI0OUAE5QNBsoxZvHKRCuB/urd+wqB8EgIQWh9DKvR/gDPymkLRKCmxnCc9Mh51rWzCmUgB/FLZ53rqxa8fcA+blb3BzXqLltU9RqozkvVqKExwUtOhoAp++2/xu1/IkaRTYUWr4R2aRQbEysXWcfPzOmTtxCm8Tqvws/f0Yh1XmCYSkQ9mDuVHvl7Mad2VYXBncPhPsIeG3tFknQURyUcSSGGtkGt5GZplI0zWJfAaHbkujWStE9ULs6u++kzfoZDofeVpGNXITlNmAYyjEr/DL6KNPYHNjqeqluhRIPhj0TU6uKNpuAVB5TSrCrFx96dDU+48tef9qwQGx9fSpKBkiTuyeZf6mHqVjrNAuxxeHJHi/O2s6IcIPkadi4v1Y2S3oFxKSbZvwNSmxy1D+lQNeBIpZhLfdq7YcbLbUl5P78Yqzis2G4lbdctKu2Ifgo4HXX1tgaQX5Af+b7rLNSzHPfl5qi3DICdmQMZDyzLwDKRrHufMtklli/ZmFqybb9KiM7kK4O0NHUpAfzdBskpQWGlWjsOJof9DoKb9mejU4yIg7mKcjSHDBjjiN2/lep3Pvwm84jaeMsSHu39P2RYZ7IdEidZEM8dWqknVww46ejUtCZb+gS16Qu/JzNypel1gmo2PpOxIyOoyK+0yRp2k/AGMQW5bU+RzuHub7aEHg24aNq6gzgJbPSxnfNAFflNIvGo1NJRKFhyGPQu8e
 MhRH9RCl
 ivO3yYO9RnGH4o0p7XovkMM54h3qvttt6AvdbJp9tK85bd/znlQuy630CLYXEELI65KrVUlwX94GPJ2En4e8mvYNNyaThYTMYK1gP//KEv/NiPJcgWr6h8/eIfUQRbEOsTVyvrcqMxzD56lAHRMz+DdqGZHIO9giOpdXawNJe5K1K+qUs1uFPh3xXjknnd9OSGqaBu9KczwrZMNQGq/agTcF+yKe65ef02zwgCaT2sq+HO/BJM2JClfDngniVsjHaXbmrXA4Ov0PxqLeAH0lMEaQU1fiCbaO3/xwt+cvvryWI4+wIAeGyvTY0qWxoNDj9hiJ0RYtUIP5ZkxViz8WsMV/GcrQPIp2zduTcHVQDLOCZIqb/V+ro8GfCrrD1l/RGsHDH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Add a per-file VM pool using the IdPool for ID allocation
and an XArray for VM storage.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/pool.rs | 102 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tyr/tyr.rs  |   1 +
 2 files changed, 103 insertions(+)

diff --git a/drivers/gpu/drm/tyr/pool.rs b/drivers/gpu/drm/tyr/pool.rs
new file mode 100644
index 0000000000000..1745116930c3e
--- /dev/null
+++ b/drivers/gpu/drm/tyr/pool.rs
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0 or MIT
+
+//! Per-drm-file VM id pool.
+
+use kernel::{
+    id_pool::IdPool,
+    new_mutex,
+    prelude::*,
+    sync::{
+        Arc,
+        ArcBorrow,
+        Mutex, //
+    },
+    xarray::{
+        AllocKind,
+        XArray, //
+    }, //
+};
+
+use crate::vm::Vm;
+
+/// Maximum number of VMs per open file. Matches panthor's
+/// `PANTHOR_MAX_VMS_PER_FILE`.
+pub(crate) const PANTHOR_MAX_VMS_PER_FILE: u32 = 32;
+
+/// Per-open-file pool of VMs.
+#[pin_data]
+pub(crate) struct VmPool<'drm> {
+    #[pin]
+    ids: Mutex<IdPool>,
+    #[pin]
+    vms: XArray<Arc<Vm<'drm>>>,
+}
+
+impl<'drm> VmPool<'drm> {
+    /// Creates a new [`VmPool`] with capacity for [`PANTHOR_MAX_VMS_PER_FILE`] VMs.
+    pub(crate) fn new() -> Result<impl PinInit<Self>> {
+        let ids = IdPool::with_capacity(PANTHOR_MAX_VMS_PER_FILE as usize, GFP_KERNEL)?;
+        Ok(pin_init!(Self {
+            ids <- new_mutex!(ids),
+            vms <- XArray::new(AllocKind::Alloc),
+        }))
+    }
+
+    /// Inserts a VM into the pool, returning the allocated ID.
+    pub(crate) fn add(&self, vm: ArcBorrow<'_, Vm<'drm>>) -> Result<u32> {
+        let id = {
+            let mut ids = self.ids.lock();
+            ids.find_unused_id(1).ok_or(ENOSPC)?.acquire()
+        };
+
+        let vm: Arc<Vm<'drm>> = vm.into();
+        let mut vms = self.vms.lock();
+        match vms.store(id, vm, GFP_KERNEL) {
+            Ok(previous) => {
+                // Drop the previous entry (expected `None`).
+                drop(previous);
+                Ok(id as u32)
+            }
+            Err(err) => {
+                // Drop the XArray spinlock before acquiring the `ids` mutex.
+                drop(vms);
+                // Release the stored entry and the pooled id.
+                drop(err.value);
+                let mut ids = self.ids.lock();
+                ids.release_id(id);
+                Err(err.error)
+            }
+        }
+    }
+
+    /// Removes the VM with the given ID.
+    pub(crate) fn remove(&self, id: u32) -> Result<Arc<Vm<'drm>>> {
+        let mut vms = self.vms.lock();
+        match vms.remove(id as usize) {
+            Some(vm) => {
+                drop(vms);
+                let mut ids = self.ids.lock();
+                ids.release_id(id as usize);
+                Ok(vm)
+            }
+            None => Err(EINVAL),
+        }
+    }
+
+    /// Gets the VM with the given ID.
+    pub(crate) fn get(&self, id: u32) -> Option<Arc<Vm<'drm>>> {
+        let vms = self.vms.lock();
+        let borrow = vms.get(id as usize)?;
+        Some(Arc::from(borrow))
+    }
+
+    /// Removes and returns the first VM in the pool.
+    pub(crate) fn pop_first(&self) -> Option<Arc<Vm<'drm>>> {
+        for id in 0..PANTHOR_MAX_VMS_PER_FILE {
+            if let Ok(vm) = self.remove(id) {
+                return Some(vm);
+            }
+        }
+        None
+    }
+}
diff --git a/drivers/gpu/drm/tyr/tyr.rs b/drivers/gpu/drm/tyr/tyr.rs
index e7ec450bdc9c0..8c0c18c1a970b 100644
--- a/drivers/gpu/drm/tyr/tyr.rs
+++ b/drivers/gpu/drm/tyr/tyr.rs
@@ -13,6 +13,7 @@
 mod gem;
 mod gpu;
 mod mmu;
+mod pool;
 mod regs;
 mod slot;
 mod vm;

-- 
2.43.0



