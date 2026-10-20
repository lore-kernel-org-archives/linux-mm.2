Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A75460A2622
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QLBTMGo9
Received: by kanga.kvack.org (Postfix)
	id E2BB76B013B; Tue, 20 Oct 2026 04:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC6A6B013A; Tue, 20 Oct 2026 04:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB226B013D; Tue, 20 Oct 2026 04:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4D9D6B013A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 158FB8091C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
X-FDA: 85342321302.16.1A97FB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DCCA04000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QLBTMGo9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484749;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raq1lTLyZFkyEP1xVlPd0xytE0KyV3iNoTs2UjZZjVs=;
	b=5EcmQp03gPTlf2BfZ0W4Ph3E+sduo2tDECBrcGCP4R3yFIfTtbEzOGC9QbCr4RCxMEmm80
	6vml1IZJuAUs5ffvyJBfXiaxGwLkzNix4n3BgZQt9K/Kfck6FXSmdRgyMBo1UwOJsCGZkW
	Sp2ZFpcCYXX+GRZ/3HrV0jBCEmkCaVQ=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QLBTMGo9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484749;
	b=ZX3/M0XhU54GZ3rk8wK2UbwotZuwIQ2Xc78Nh5WCfZLL4mdU8lggObPgnwoM8ifHeMzgon
	gXKSPhnhWKy2nMO9+JbG9+CB648E+NkcNjPV3srY87yAl9qfwR+Se5sXEpf1O3dwt7tgs7
	uHLs6GRa0Jx3grUEh2S+VAlFRalKJeY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 115FE43DB1;
	Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484747;
	b=YwaemslX09BQVOdv70Nzn2JOUC3MkBu+kT3z0lTStT1vXFZRG728JUSPxSBLdQC3NE1v
	 C2V3wfh9NQRaNYH6A/FPoOw4kWnuBl7r/eLOyJzWNqHJDKZbB0taMDT+ciBiWPIbjCPqa
	 1uE+Pv0Zxca9BhyY08/dscny1aoEPwUbyleDMpYg/g8WAO4hvJDexTLYBRiXD9JoUPTUU
	 2rZ8vZMee/NiuPcZ2ELEzh0gtSXF2w23L2SrFOq+k+wC0CHEakNglQtQSA1TA/6ib+vq3
	 KjexnwQ3MR+TBRYBQ4lJ+y+yRLs9j8UpIGM45LqEE10Evzt3EyB5btCNm+FtYfsSaFw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484747;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=raq1lTLyZFkyEP1xVlPd0xytE0KyV3iNoTs2UjZZjVs=;
	b=e142vOP2upc5wJwUz/rCS6eD2XmtRMN49pMc6Fzm1Oe6dzfI2ATNlvcHZ71wZFCh3yIf
	 A2uvEN8iYCu50KJpAYBxi4H/wsf/KxfFQNweUN01oix5lQlYwdC0fS0EI6J4sGPKyn2tW
	 AyGhi7JTMD8Gbd27QwM5Sn6c+6HsCOHn59vcJaHYF7icJytv0/2rnuBbcyL4QFG6/WmjV
	 WPJk+w6FHPwVz6UGBS21cRES9njBCgCTyURTfroxhaPcw6aNHjnMY6y7cXni5MCgrabtA
	 /XinPZuOH7GLvO91aA7hH0i0NnfcGobPZU3V0MEP3Ftja2kRjVKfVV+4f3wA9cNoV6Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 45D361F000C9;
	Tue, 20 Oct 2026 08:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484747;
	bh=raq1lTLyZFkyEP1xVlPd0xytE0KyV3iNoTs2UjZZjVs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QLBTMGo9WebiStFeGJZ5Q2MlfzjapKaEtqNQjdGVczuzsfrZQzj9jOAgBfK7X0EgL
	 Clm6Y/TKiUTqznLX/57lyUGvA3U0Jbjd66FsiLZ0yq0yyAg3fJaHlumn4rA6VVH+gj
	 X5P8PbG3DKHs9cjv2tweGGgBWcu6BTsGYUpa3SFjalzypPaAh5kJPgGlNa4qjGte0W
	 pl43o63mWPXXWX6TylZbb7GAx0okesBd+ZplPbKqP/chFl+MwWf/SMrV52yMSDJKzw
	 +kR/S1mtp6aFw0uOMW9O9ABVgfJxMuv28fu8oStwuEBQFSz3avnQBaaS20CaNWtlf1
	 gSQfpGR19jOIA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B8575430DC;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:21 +0800
Subject: [PATCH v4 04/11] drm/tyr: add per-file VM pool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-4-704de77da223@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=6136;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=rJMDF0E+r5CboO26qM5Av79VG6Xqis2m0v/SvkplpIY=;
 b=o8eHUnvbgftKrmserToYOPjYqdYw5svjt/W7B+4ZCNdVZW9SKp0WIFIA/p2BzF5VSPGuy/PgN
 S12ippHW8iRCiV9PEamc8sQWo1jZsgV/Ec28IJnLIDblWQEl15ddZcH
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCCA04000B
X-Stat-Signature: 4p8bahybwyhkke6xyb9z8e4sm5kzegmo
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792484748-650494
X-HE-Meta: U2FsdGVkX18y/oEEJB8oDlsoDhPlSrd0Vr4FGcMbJpphyeeYoFablwWnfmsVGv6aHNPLBX+1DzOO7qJ7ajyFkSwiazEbv4Lv4+BN/hwxgjYczaYpVAfrCEnhucQDIrksxlstX5LbVi9tDhsUJgwLIaTKhu0jLrQMn58BwZ+7pPb2OFKWQBZtNDzhSSJjrKOdn7bwGThJu4kw0QflPDdis0Bfc7bv4eqEq04ggQM5VGjjXOPRpLp4ASK7ZBKvfXqriBb0LVrunnRH4xBqPfseZ5uTxlVltq998MgzC8jgrgG7lOGUVu0aiOq6RLfPsYA8byk/EoE5F5fyQJ3BypFacDr7vsejOSbcYvrwldsB2NAl75+J/XviNVACGeSnmCS5E6UZS/T8l4SLiu4S8IzlgaS12cqyoKzppxshEZYC26rK2K/IP/M796fCEcIsmSNOLt0ARMGw1hHxwk16aW84UZbNAstkHnFszNMbhRTuwJHnA9NTtjSRXZ2POUGOd8mZoxgPJu1AMEUdLem78uMTdhBYnQ/koyyeRPX8YMgI6TjXBTMrkeUY+Y/OLqLzcXjWnpkGNrv7i7vnKcsLWXFvjcmhQd3n87W6RkNg3HVfdb1g3xBgrcW0xgIEWaoQAvh9Q8cUeLM98DiycMzb2AGr3/SzJQds0d4JztPzalZTCFa1ldurdRyp8yyUMCFxBsCiPaNBcHCVYaDZafqPPUCTpt8MxrG5bzYUPW2cHi/CELylS0JNKMTSi6g77TLIjrUs1JsE2859uwCHDOUAXW6ZxbyJI82m68XjUhdDQXR0eTvOXWFUkckmGJ6Ye+GoCZH6Q1Dl0ifCYdEQnA1C/7v/LefHogDdufuSpx77LcQJY7z22pEt5ITEmgyNOUXWO7fo5NMwTXl2cQPDS88AZBifWHJ55bNn9j9Gdrt7sYCjisnpubJFC0+Fa4A6oFlgZ7AZwGPaVCSu25i1s1sCgM8
 +6P6J661
 U1qbW/EWZjuxutCZF5Pj/y88EAPqC66fgKMZYC8fUogozB+mAtOvhNMlKpn6bWDSgD4vUWtkJwHGn8yRJStcnWANjcKw9fhCj8XoSWvWRJw+4wUKeFZd9T62CntjfVKIikTGRpVHAr0Ug8jnlByYoVdTotGqCLl7h9xScDO9ccvNxd/YS/E6jWga/fc7KUubdoZ3ZGMwX3FP5Z3wsxWnetOcki2rcY137MLk0IXY4JZRfC6tOk74rQqcEV159IizEsGF0eNXv8HZpJAAHTwaeFoNJ1ib8nD7OPrxr+haimvg0Ds2VzIURU+BtzsNM1iCUGzC2Q8HjyAUwiLnlJCRI5rOei2prVjNTW7Kce/e9xOzSrX+lpXT+xt9GvJgj+PC58J0U15M8FHP/TdwYjg1qR04/1rV75/7EcIR5SalmZrYrw6YAbmBGNVtrkitPEJkgUTVe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alvin Sun <alvin.sun@linux.dev>

Userspace needs multiple independent GPU address spaces per file,
addressed by ID through the VM ioctls as in panthor. Store them in an
IdPool (capped at 32 for panthor parity) plus an XArray. On a failed
insertion the caller tears the VM down through the returned error, so
an aborted creation never leaks a VM. The pool kills every VM still
stored when the file closes.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/vm.rs | 138 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index c5e307b1e2416..6935e4db667b9 100644
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
@@ -948,3 +953,134 @@ fn pt_unmap(dev: &Device, pt: &IoPageTable<'_, ARM64LPAES1>, range: Range<u64>)
 
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
+    /// Parent device, for error reporting.
+    dev: &'drm Device<Bound>,
+    #[pin]
+    ids: Mutex<IdPool>,
+    #[pin]
+    vms: XArray<Arc<Vm<'drm>>>,
+}
+
+/// Error returned when a VM cannot be added to the pool. The caller
+/// owns the teardown of the VM in [`AddError::vm`].
+pub(crate) struct AddError<'drm> {
+    pub(crate) error: Error,
+    pub(crate) vm: Arc<Vm<'drm>>,
+}
+
+impl<'drm> VmPool<'drm> {
+    /// Creates a new [`VmPool`].
+    #[expect(dead_code)]
+    pub(crate) fn new(dev: &'drm Device<Bound>) -> impl PinInit<Self> {
+        let ids = IdPool::new();
+        pin_init!(Self {
+            dev,
+            ids <- new_mutex!(ids),
+            vms <- XArray::new(AllocKind::Alloc),
+        })
+    }
+
+    /// Stores the VM and returns the allocated ID.
+    ///
+    /// On failure - ID space exhausted or a store failure - the VM is
+    /// returned in an [`AddError`] so the caller owns the teardown.
+    // TODO: allocate IDs with the XArray directly (once it grows range
+    // allocation, the equivalent of C's `XA_LIMIT`) and drop the IdPool.
+    #[expect(dead_code)]
+    pub(crate) fn add(&self, vm: Arc<Vm<'drm>>) -> Result<u32, AddError<'drm>> {
+        let id = (|| {
+            let mut ids = self.ids.lock();
+            let unused = ids.find_unused_id(1).ok_or(ENOSPC)?;
+            if unused.as_usize() > MAX_VMS_PER_FILE {
+                return Err(ENOSPC);
+            }
+            Ok(unused.acquire())
+        })();
+        let id = match id {
+            Ok(id) => id,
+            Err(error) => return Err(AddError { error, vm }),
+        };
+
+        let mut vms = self.vms.lock();
+        match vms.store(id, vm, GFP_KERNEL) {
+            Ok(prev_vm) => {
+                if let Some(prev_vm) = prev_vm {
+                    // An existing VM at the freshly allocated slot means the
+                    // IdPool and the XArray are out of sync: the stored VM is
+                    // a pool entry, so the pool kills it and the caller's VM
+                    // is handed back for the caller to kill.
+                    let stored = vms.remove(id);
+                    drop(vms);
+                    prev_vm.kill();
+                    self.ids.lock().release_id(id);
+                    dev_err!(
+                        self.dev,
+                        "IdPool/XArray out of sync at VM pool id {id} (stored VM conflict)"
+                    );
+                    return Err(AddError {
+                        error: EBUSY,
+                        vm: stored.expect("VM was just stored"),
+                    });
+                }
+                Ok(id as u32)
+            }
+            Err(err) => {
+                // Drop the XArray spinlock before acquiring the `ids` mutex.
+                drop(vms);
+                // Release the pooled id; the VM never entered the pool, so it
+                // is returned to the caller for teardown.
+                self.ids.lock().release_id(id);
+                Err(AddError { error: err.error, vm: err.value })
+            }
+        }
+    }
+
+    /// Removes and kills the VM with the given ID.
+    #[expect(dead_code)]
+    pub(crate) fn remove(&self, id: u32) -> Result<()> {
+        let mut vms = self.vms.lock();
+        let vm = match vms.remove(id as usize) {
+            Some(vm) => vm,
+            None => return Err(EINVAL),
+        };
+        // Drop the XArray spinlock before killing, since `kill()` may sleep.
+        drop(vms);
+        // Kill the VM before handing the id back to the pool, so a VM is
+        // never reusable while still alive.
+        vm.kill();
+        self.ids.lock().release_id(id as usize);
+        Ok(())
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



