Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C58C0CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138856B00AC; Tue,  9 Jun 2026 15:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8E36B00AE; Tue,  9 Jun 2026 15:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40F66B00AF; Tue,  9 Jun 2026 15:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0A7B6B00AC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8BD01A0753
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:44 +0000 (UTC)
X-FDA: 84861318528.20.5BD1104
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C939D140005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWscA1Ru;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTMq75LVYGONeqD6aceZFLDHKDcK1Q7SK0j/d7sqNo0=;
	b=dMgybXOllZ9uzFpqL9M+3V35vMHFTJcRQ2pR8PPUL23t50ENPMJ+puVznCOg4cXXhJXAkE
	MuLYTJiKu2aUZin5wppjlfFiPRUh91NEUX+ViV7MZx4nGpEvp+K1Hln6++UTxmkYGlQr1o
	eXfRzR99aM4pAc3wa5DMDsW21KOFpP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032302;
	b=gfOf4JrepBNF14Gvbs1jICmisZpdap1agFe211EahZ0kdNgGXlghqMTG8YojzYNp6Wch89
	mYwVDj2Zv2W6NdT/mqN6tsDPPq6SIYItpRdAKyoOA2pCR/fvKb+l+RaJmIe5/2SO+smthp
	hOXHepoTn5n3RNh1gOzhyKngelAEq8g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWscA1Ru;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24CBA43406;
	Tue,  9 Jun 2026 19:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CBD1F00893;
	Tue,  9 Jun 2026 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032302;
	bh=cTMq75LVYGONeqD6aceZFLDHKDcK1Q7SK0j/d7sqNo0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iWscA1RuPcNWUzsAri0x7rO9uKR2nATOTwgMdkliYE9DcAtE72IIAJLsDeIhftwio
	 JnhJp/MlW7V+wTCacbdY57b98GVq2ddUnxCrnWEi4KctzJ8ENaaUVrc/37X8NP11m9
	 HNQkWQQKwF0mPjOexVkyNhIoAe7rDLeWi1OtUuyQl8WJjJK8Kxr2sherQ1/SYBfFyP
	 bJXYW0Gjq74pBTnh2Abmk2nUXM/RdeLEB4O7pjXNqFOaUeT7Aw2QX2QxDyVtS8PpnO
	 pK3O4Y6jwzL068fD3Foi0NDofU3aGNR9iFoLtxVX6WyvshYjH20iefhjvY914dZYyF
	 QhquVR/aCZuDg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:16 +0200
Subject: [PATCH v2 37/83] block: rust: add a back reference feature to
 `GenDisk`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-37-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5601; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Pgrl0umFQHfxEgGBhL3ORYr61hxvp3mCX9/WUL8WuTA=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTWPDkbTCiF4AD045KZczuURzT6Ht4dFueuB
 WWPpi9oI4yJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk1gAKCRD6UCkIqsW9
 0NUHEACfPdxlqQtedQBoWcauh+uupMtyzebSZu/9dyy/KhNqkuWRHfrh7tskkROLw4OetVFM+85
 FIRjRx5EzlxXdiS8XjDCiRqCHDO5mXxwUDG6mUJjAKEvbT/xPdM/ZFr3EHO+1VWOUkdt8tb2tWE
 1CCV2dTvwd2RqPLZxVJOMSn869PyQJGNBXNUAcTwUwFqGNccu/faYuwjpvNWzUQXT7rHdtL4ugI
 RplKUy3PWkgIEukdwtUd1YvfsQAEYpRRKLyvJqKYtM5PPwJNzRXRbXyEsd+65znGhMnYJgf66S8
 6QxRdnbSQOHoRXKA/XsvwXD5nNsJEbpceZurQyjKafth8w3D2ejKhohwfD4cRmLWnd6taUNgxRX
 /95y3Fy4RJ8pwbnRxq5pAX6DRHbIbzn6gxydhJJM97TsiYAEx7BTgx1v10ktqkdmrlo5xXyLsOH
 LMpvBp7w0Bdk3/Y+jqn1Vlq/CP01y5SkFejkmA7C9D6ejGbcZbYvABTEh8b/0lATzLaE/L7A3JJ
 WEw4YURvDp5LZ6M505NRA9l0DiYOxKu0OJm+HNwZxqjQ8dwpFjODFVMR/waJG+Wc1fQQzQ473NP
 nQgH0XyDErWgWKxHViVDUbu7i7XIRAyke4TIAbBl997x5fB8ErWdzZ0G5ozTPgleIcgnrdO7ZYF
 YDjGmpDibn2T6Sw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C939D140005
X-Stat-Signature: kk43fo6atmsao3gx3oswhjsci5dj83o4
X-HE-Tag: 1781032302-551217
X-HE-Meta: U2FsdGVkX1+96078JU/wEscApP1uZJg4I4VoeICIUHbcPe8YWxPQC/bjNeKiCkq0Z7PlNf1zM7U5cRoMxJ6DgELX6h7Cas1et/XciOi7SZrDsF3ueFO6PKTBjr5mYi+GgRLcY8vW2Gs+1TpEwy0bBIXZx8lQk5XI57xeUClaojHlZ+CZaxloJJB9WghmrQP+lAPzSPIuxIYQNqQezwdGkuMhV40Bq3mVTk+ctI5ujBZ4jPVlo8GYs/q//eSdhk8dOxJuF3oWKwXYJdf+Luv8+a2rAN7tQ44lYA6lSBukNl54loA3jPZkJnIFBCiGT4jfUfKYDgdYxKSnlV3QeR0K2MCxvSZkuLjKFMbT4zmG9UL0yuCgw57PmpmZWcqRKc773ttdOCwDcSA00g7GHDaEeQwWti0DATZaKn3laPGcmMdDOWhSwoZJufkm3JUhFlue1teOdz6Jph238GnkbZKVh4Pb1t1AQeNbUadBa/AMKwCPAsbWkQZehBNZLZSV9R3NPUd0Add6BmwHIGCGLVGCZDHe8dgGBOcFEA5ZvCd42m9zZjme5/iL5dGyrQ3IcJy6joDdPnjjlUc1KUn61VHuCdAe16hG9InU+JyrsmNsCH9y9N4ZC+b9xjGS9i7MmTqShgwUu0+riTU4ySUJNto2W6ije3wc+Aq0NlpTqBECXHQcr1+fO8uEFrO5HCgNBBiGksZ6xuYSLoOL4y7/kZEVwAEY4C/ghoyj2cE1OsANE0o6XuDUElK/99jSRaggamMxK+d0d7ZkTxTAM7i4RimWpTxSoANPOHJ1+C7Fp0jpHu8rFSki6SqhDGIC6oJrorHZumGz6Zc3zfEvwfrXqrVtb1wP4g/h8+AhCGRAc3Lct/lUtfttufPHWCnBZwVuiibDUeqDEhPL0SMab7Di+Myu8/Pj6w1Q6Ok/rLuRBgeMtNFcnuISNXpk6wPAgfetjJx6KOaObnjatpcQPXO2zsl
 HxzeyVpq
 /evx0NBXzl8sGUaGulc6APfxxC4zyWFfUhzl2io3uOZ++q51vk1Na6hHNjepZu6P8ERq9JVu169T+fPEGCfC6tdwbiECFjPDbxEq2H/im7J3seG1jQsVeCCOpYfB2Cpnw+XcNdNSpK4YO3apYNryJY/zOCrFCeeYXultFoNtnbvO4PR8Sgm6ln5xmGZFo9ilic/wWD+N/jEx3fMVzwaUOqWvbtYNaX0cIjxEwWyQyTvdSBcJBI4xIm4DZ9UkL9QVGrRmOSgefXUoGydqyJvIDhlJ7ljnKYTtPKFcmRKKT+SqepPMJOLogzCs7lOYanK4vs59Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During certain block layer callbacks, drivers may need access to the Rust
`GenDisk` representing a disk the driver is managing. In some situations it
is only possible to obtain a pointer to the C `struct gendisk`. With the
current setup, it is not possible to obtain the `GenDisk` for this C
`gendisk`. To circumvent this, we add a back reference feature to the
`GenDisk` so that we can store a reference counted reference to the
`GenDisk` somewhere easily accessible.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs  |  2 +-
 drivers/block/rnull/rnull.rs     |  4 +--
 rust/kernel/block/mq/gen_disk.rs | 65 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 504bb477c2d0..4df0b748596a 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -198,7 +198,7 @@ struct DeviceConfigInner {
     capacity_mib: u64,
     irq_mode: IRQMode,
     completion_time: time::Delta,
-    disk: Option<GenDisk<NullBlkDevice>>,
+    disk: Option<Arc<GenDisk<NullBlkDevice>>>,
     memory_backed: bool,
     submit_queues: u32,
     home_node: i32,
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 877683dba0ac..fd9b770965a6 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -134,7 +134,7 @@ struct NullBlkModule {
     #[pin]
     configfs_subsystem: kernel::configfs::Subsystem<configfs::Config>,
     #[pin]
-    param_disks: Mutex<KVec<GenDisk<NullBlkDevice>>>,
+    param_disks: Mutex<KVec<Arc<GenDisk<NullBlkDevice>>>>,
 }
 
 impl kernel::InPlaceModule for NullBlkModule {
@@ -216,7 +216,7 @@ struct NullBlkDevice {
 }
 
 impl NullBlkDevice {
-    fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
+    fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
         let NullBlkOptions {
             name,
             block_size,
diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 94af85fe1716..f51bccb0d2ef 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -21,14 +21,19 @@
         Write, //
     },
     prelude::*,
+    revocable::Revocable,
     static_lock_class,
     str::NullTerminatedFormatter,
-    sync::Arc,
+    sync::{
+        Arc,
+        UniqueArc, //
+    },
     types::{
         ForeignOwnable,
         ScopeGuard, //
     },
 };
+use core::ptr::NonNull;
 
 /// A builder for [`GenDisk`].
 ///
@@ -125,7 +130,7 @@ pub fn build<T: Operations>(
         name: fmt::Arguments<'_>,
         tagset: Arc<TagSet<T>>,
         queue_data: T::QueueData,
-    ) -> Result<GenDisk<T>> {
+    ) -> Result<Arc<GenDisk<T>>> {
         let data = queue_data.into_foreign();
         let recover_data = ScopeGuard::new(|| {
             // SAFETY: T::QueueData was created by the call to `into_foreign()` above
@@ -204,10 +209,28 @@ pub fn build<T: Operations>(
         // INVARIANT: `gendisk` was added to the VFS via `device_add_disk` above.
         // INVARIANT: `gendisk.queue.queue_data` is set to `data` in the call to
         // `__blk_mq_alloc_disk` above.
-        Ok(GenDisk {
-            _tagset: tagset,
-            gendisk,
-        })
+        let mut disk = UniqueArc::new(
+            GenDisk {
+                _tagset: tagset,
+                gendisk,
+                backref: Arc::pin_init(
+                    // INVARIANT: We break `GenDiskRef` invariant here, but we restore it below.
+                    Revocable::new(GenDiskRef(NonNull::dangling())),
+                    GFP_KERNEL,
+                )?,
+            },
+            GFP_KERNEL,
+        )?;
+
+        disk.backref = Arc::pin_init(
+            // INVARIANT: The `GenDisk` in `disk` is a valid for use as a reference.
+            Revocable::new(GenDiskRef(
+                NonNull::new(UniqueArc::as_ptr(&disk).cast_mut()).expect("Should not be null"),
+            )),
+            GFP_KERNEL,
+        )?;
+
+        Ok(disk.into())
     }
 }
 
@@ -222,6 +245,14 @@ pub fn build<T: Operations>(
 pub struct GenDisk<T: Operations> {
     _tagset: Arc<TagSet<T>>,
     gendisk: *mut bindings::gendisk,
+    backref: Arc<Revocable<GenDiskRef<T>>>,
+}
+
+impl<T: Operations> GenDisk<T> {
+    /// Get a `GenDiskRef` referencing this `GenDisk`.
+    pub fn get_ref(&self) -> Arc<Revocable<GenDiskRef<T>>> {
+        self.backref.clone()
+    }
 }
 
 // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a
@@ -264,3 +295,25 @@ fn drop(&mut self) {
         drop(unsafe { T::QueueData::from_foreign(queue_data) });
     }
 }
+
+/// A reference to a `GenDisk`.
+///
+/// # Invariants
+///
+/// `self.0` is valid for use as a reference.
+pub struct GenDiskRef<T: Operations>(NonNull<GenDisk<T>>);
+
+// SAFETY: It is safe to transfer ownership of `GenDiskRef` across thread boundaries.
+unsafe impl<T: Operations> Send for GenDiskRef<T> {}
+
+// SAFETY: It is safe to share references to `GenDiskRef` across thread boundaries.
+unsafe impl<T: Operations> Sync for GenDiskRef<T> {}
+
+impl<T: Operations> core::ops::Deref for GenDiskRef<T> {
+    type Target = GenDisk<T>;
+
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: By type invariant, `self.0` is valid for use as a reference.
+        unsafe { self.0.as_ref() }
+    }
+}

-- 
2.51.2



