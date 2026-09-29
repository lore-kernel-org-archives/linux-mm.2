Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D68DCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86266B00A2; Mon, 28 Sep 2026 22:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B373E6B00A4; Mon, 28 Sep 2026 22:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914606B00A6; Mon, 28 Sep 2026 22:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62CA06B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:16:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01AC21203A5
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:59 +0000 (UTC)
X-FDA: 85265184480.15.A0289F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00301100003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N0zA444o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQYBEW5BOVeGSKg1JSm+Jbu0MaO/aDw0qcHTWXicndE=;
	b=gVoFEw+QvrLorTBnmGM04ZXOqj1I4+Z6zbcZ0fYY7XNf+7InW9jiT3r+oWMzSZfu7U4PKq
	+gkEIPXfRCNHbvod6p1G/LR7z9qqcSrnt+v5ONHOQ4bXJNfj2OJNsj4ARpIz4EBwBcZCOV
	V5OyUeuMoRPt3lqvtZw6F7BpJa0A5Y8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N0zA444o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648158;
	b=3xHTCZqn4vcG/gaXmJm6LlPM3qIoDOHrHrXTyRav3A4TcFeA3sT0uMY5PwM2cO9HBFlhrb
	6Nuzc5d+fx+WwDW9c0p5zwxZdk7jQh1aZsbcdfsR2Rxfb6Dt6JQbcLMnxU+M6lSPT5NNC3
	3maszUAplQi7SrJHqWTHkYyEuNjEYzg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82643447A5;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B1E9C4AF15;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=KcRjclGxWWucAqNsmHW4CsL7AkQm1OZEgwKhM/93SCI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N0zA444oJE/c3+6D/NwuEebtUgg7rR0rjI8mi1w7os0cZLCFi4dTKXNOm54VMHzhO
	 iwsTmDBo6jWwxrLXA3oCUsJZEFthsPU7AT7RhexEXOh2w53BEa0IYkJgBbcFxIu73s
	 YwFVqWcg9k0Qb/j7LL0nJHIvDu20EX2+sBjhL+IKUYNOcwSpL098I4iTv76t2AL6W9
	 D+tyyM8AkUuCSqzCJfcBdnAGweMvuTKNVhTnv0+Z90KI51CjqeJwhbDX3vqyiealUr
	 /2DQQO0RgkvShAlVxb5lzR9RED2xCvCsfl3oev5jAuvWp7T061Y4WaxcSvyTm4Zyer
	 tZASUWQVZiI3g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41701CA5FAD;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:15:54 +0800
Subject: [PATCH v3 04/11] drm/tyr: add per-file VM pool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-tyr-ioctls-v3-4-26955fb111d5@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=4466;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=2k4Kro5Nu9GP4ZaXjA3FSWjNswGDeb0O0Mq0nSMnSeU=;
 b=kDfugSFGH7eKdA5+2sLu99cdt5TWEtYM8IV+0Y/ncOgm/ISOJ7zGt4CcRwbDNwVbxi0+yDxxa
 QuLPwX8bPXRD4aVNIF2NbenIspWPdfUYSapQ+0AOrEb7nAotBZKCqu0
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: p3jeh4uh6pkxdyaoxmad3n61qdyu1wox
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00301100003
X-HE-Tag: 1790648157-641715
X-HE-Meta: U2FsdGVkX19A7UvfFgL80vbTxM/c5rQL7afd4YaTwr5FUIoFprN6+otVlMAWKi/Dt4RMOjPSfh7WA/KXkDPSZRFiUQoiDQSDK506dRKqnvpuv2AVMC+jwj1FO3hqy5wxo1ePE28AHYI27dutSs0LirJCzMhuj91fpr9nuXpqx8ZyRucfliPJUZYlMhkPUXCbcgXLe+Retz6dZM5i/Jls17enofvOVVHzB+FaQpTmY9yJstFQcj8uN9SUP6xGNy8aRoDvFbLliu4m7YBcTeDEFJYkaRSM6v1PgLCKLtf0cq5x6wvVXNkG0lxHX0Di/EIaMipFp2X8U0+oiqOz/3hx9+cnzKL/ItRosOVe2t3kz2VL+TrxLr9JEVebnr6ixpKLvjXXlpWFxTUdYuksCaIr5NS51UE33hcyl9ZynXIQ4XTSkK2rpt/D0eyTTQbIdla38pmFbYHaZ+RMTqz73+7oI6n9OzFnp84IG28SPnn/PwzR/20ERwifcuGSGD/jMsfYfPtGZCxu3sfAPQD6I49fe9l7wu60NGdX0YPut29sJHUbtjvPJelmV0wFAo3yTIoKcP2FK7Ab09qjyi8UvmPZjbVbSxgjEPt5RBozotjiT0EwEhebjgJFbdzAvzAO3ZXwdkSQWq1WtO1lyMYdLVENcKyHJ7/VCiVHwyoScQ4E2AjtRv0jBPHWLdJOj5XuvdaGhBQ2AQkiSGmUSMI34ycdNTho1bktUvAb4yYwL6WyRvFNDpXHlKRcQPrDu+gPCJHXyMbZtpfpu8Co97+VY2NJMAMPtf/mm9YWPaDMFN/k4fj1pK6SVWNq7brN6G8RfZ2uykuBsEg/czgP7N1XUg21uG0kLyy6dje+AK2nIMiPFCowjg0aq1sFLSAylmDKxzdNvgqEx8s9vZV1O/521jPLHD2x9CDE+nMU9J3n9lvYA1EMJm547eSJSTctA/RIfMkVENGXch48DiiQJXZXB4w
 XlT858Gb
 It4hUSQOsRyNObJY7rpUuFA2ZFQ/9WDpXnrBWdrjqcXAyWcQB1vniC9VOKQBxHi30iE9UZOWUFm3mN3JHb4Dp9itKqYAExr4dCC8zk/lxtI2nYcCkFvvaFXXgL1dET7mUs/KOOIQNuy98lyZgfuMFAvvOuPvZHdJgF6kaEqftO+qepwMvKA66gCU6UgBPI0z518m/3rODZUVoXl4QPLS+R2HEsP+3ihK9GdjlLrnVLoMDCrrpYkGbYlcWuMkgBPXE5Hd/hXqnRNbtPaEmO0kABkWnHzR1cFGXfergwB9pD1gna1LhEuewQtyA4DMS0FdyXEy5Wq/ZQlgw/wwLAV+HbI0bZNcpCmQu8xboNeEN1Wik00ebkzfFbpieIuw+c0fzIohi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Userspace needs multiple independent GPU address spaces per file,
addressed by ID through the VM ioctls as in panthor. Store them in an
IdPool (capped at 32 for panthor parity) plus an XArray. A failed
insertion kills the VM before returning the error, and the pool kills
every VM still stored when the file closes.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/vm.rs | 106 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index c5e307b1e2416..a2857820570cf 100644
--- a/drivers/gpu/drm/tyr/vm.rs
+++ b/drivers/gpu/drm/tyr/vm.rs
@@ -33,6 +33,7 @@
         }, //
     },
     fmt,
+    id_pool::IdPool,
     impl_flags,
     io::PhysAddr,
     iommu::pgtable::{
@@ -53,7 +54,11 @@
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
@@ -948,3 +953,102 @@ fn pt_unmap(dev: &Device, pt: &IoPageTable<'_, ARM64LPAES1>, range: Range<u64>)
 
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
+    /// Stores the VM and returns the allocated ID.
+    ///
+    /// On failure - ID space exhausted or store failure - the VM is killed
+    /// here and only the error is returned.
+    // TODO: allocate IDs with the XArray directly (once it grows range
+    // allocation, the equivalent of C's `XA_LIMIT`) and drop the IdPool.
+    #[expect(dead_code)]
+    pub(crate) fn add(&self, vm: Arc<Vm<'drm>>) -> Result<u32> {
+        let id = {
+            let mut ids = self.ids.lock();
+            let unused = ids.find_unused_id(1).ok_or(ENOSPC)?;
+            if unused.as_usize() > MAX_VMS_PER_FILE {
+                return Err(ENOSPC);
+            }
+            unused.acquire()
+        };
+
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
+                err.value.kill();
+                self.ids.lock().release_id(id);
+                Err(err.error)
+            }
+        }
+    }
+
+    /// Removes the VM with the given ID.
+    ///
+    /// The caller is responsible for killing the returned VM.
+    #[expect(dead_code)]
+    pub(crate) fn remove(&self, id: u32) -> Result<Arc<Vm<'drm>>> {
+        let mut vms = self.vms.lock();
+        match vms.remove(id as usize) {
+            Some(vm) => {
+                drop(vms);
+                self.ids.lock().release_id(id as usize);
+                Ok(vm)
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
+        // Kill every VM left in the pool. The ID range is bounded by
+        // `MAX_VMS_PER_FILE`, so this loop is cheap and runs at file close.
+        for id in 1..=MAX_VMS_PER_FILE {
+            // Release the XArray lock guard before killing: `kill()` may sleep.
+            let vm = this.vms.lock().remove(id);
+            if let Some(vm) = vm {
+                vm.kill();
+            }
+        }
+    }
+}

-- 
2.43.0



