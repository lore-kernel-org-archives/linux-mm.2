Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD2CC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 10:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF236B0005; Sun, 28 Jun 2026 06:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0A16B0088; Sun, 28 Jun 2026 06:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F7A6B008A; Sun, 28 Jun 2026 06:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1F776B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:07:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 690BB1A037E
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 10:07:51 +0000 (UTC)
X-FDA: 84928895142.29.AFC292E
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id AA2444000B
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 10:07:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of szehawong@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=szehawong@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=trevrosa.dev (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782641269;
	b=U96qoa6xCaG4bLTw+VKiWTn6fsM47FU4jbd+HuxnzG+FqphAuIQ/RkF2xr8WI307HpVdU/
	2C/J7d6WSXSGnR4vymwdmRaaXE0qxR0WqYO/kJjIhrGJXS4xa/XxdCi6dISDUuH0rqWPER
	L0nQqszkYK3GkGkCbNCp4b0L5iTRPK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782641269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LQUKSUK9vdQ1Kz4RjZ18oZFcJVkdORoocJ3F5XrJ/Po=;
	b=UAV3NPCSkqSRYH6F3GMYlJQIyd0yiGxqIf08VOQ3rhqPf0QjP4KqfSkDlykxfCMtbEW7Qo
	LC76rHdMlftW2U+YDIrsFjLAdCniL4Q3ZnUMr79skbta6sZ5wO/11AU13QnXYe0+86vAPi
	kI2OICZUndMD6VP/JTH+BC9PIbIRVOc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of szehawong@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=szehawong@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=trevrosa.dev (policy=none)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-845b965c1c4so1178354b3a.3
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 03:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782641269; x=1783246069;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQUKSUK9vdQ1Kz4RjZ18oZFcJVkdORoocJ3F5XrJ/Po=;
        b=LVVwPpWNHfQSV1VJKflVJi7VLEw7ow7WpKXHuNN4gH4DGegS+fHWuH8/iQJzb69Uts
         39JL70x1v6EfQIhkxFAHO2Zsc5HQCW7cy9dQCYLe4ZbMAYlKl03mhQmRxZc2145YjN/S
         A2RrCX28dMHQhLIygS8huYkRXvNt1Iiik6DKHDNQUGqenaiI8ZRo55pfuDCEBWUPFEWD
         cY/zYp1LXna0eHzt39Hxc8yo10EFRdsrSfFSA9kprGDOPKGTRGGhnQ1NFQCdmOj1To1G
         Z12sc8AaITInW1D4MF3+CsLqb5C7ksomcXT/OmyOojvuqSPHZyRS7VZ77+W1TFcYxQgO
         /20Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpg8IO22Ob7Ml0+JKwE9CCUx2FdPsvbPrtX1ujM+DYJZDLN/t9NhiMcDLYECGV+aAhjdw69hNQ6VA==@kvack.org
X-Gm-Message-State: AOJu0YxeZc3+Nk1US+TgRICuFA7CjeVLI4Td0bzlk+T651NsUp3q8Hvw
	UmM6Mh4gyCjei7qEkIS2nEXFPrNHZQdsv8JoU63/SW4oFHA29vh945ql
X-Gm-Gg: AfdE7ckNZ9KcfAhwJxq+VTHRhUd9FHHnchjVtC4UErr0Q/34nSe1LGo2431YlZWYbEp
	3oSfFhfTPzyPh4qJ03qc/nec4dadjTXRlkutF8n0VTGsgnkPYISMidGZ3UBM2ao5cBfjG2uWJud
	N+vQISLJXbvQ8cv+dSh+zSRtFjKq8G56MAH03rPGZYdpzMcMynBtrvgzvOfoTFuCQjqTgckCKCL
	paAzN9iV7bb8Xa+h6JDUISAXfgjwUprtJIs5721a7Ub5Mms4c9KMl03LsdrE7+C8TGOjElnQcBW
	RKhLVo7/0MSaIxmp7weGE6BC2Nmot/T1W3A+NvXGwKW3CoKQLSpbxW9X4cPelTSsxxYTFXZiA6D
	tKbO6Q8qP3ky6N4vY/NIutt0/jOklEKX9My3bMhm4HC/eal6GCgv8UA9vzoX4I/85xb2woWjCWn
	nOvplq5b2oS29UqTRm0OlrDtyff71WTOcF4FM1FLmR7XHFhcdC7Q==
X-Received: by 2002:a05:6a00:929f:b0:845:c5d5:3743 with SMTP id d2e1a72fcca58-845d2475c86mr6541601b3a.28.1782641268305;
        Sun, 28 Jun 2026 03:07:48 -0700 (PDT)
Received: from trevor.localdomain (n119236170163.netvigator.com. [119.236.170.163])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845e3455bacsm1840491b3a.37.2026.06.28.03.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 03:07:47 -0700 (PDT)
From: Trevor Chan <trev@trevrosa.dev>
To: gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	ojeda@kernel.org,
	a.hindborg@kernel.org,
	paul@paul-moore.com,
	aliceryhl@google.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	igor.korotin@linux.dev,
	vireshk@kernel.org,
	nm@ti.com,
	sboyd@kernel.org,
	m.wilczynski@samsung.com,
	boqun@kernel.org,
	gary@garyguo.net,
	axboe@kernel.dk,
	daniel.almeida@collabora.com,
	shankari.ak0208@gmail.com,
	lyude@redhat.com,
	j@jananu.net,
	lossin@kernel.org,
	acourbot@nvidia.com,
	markus.probst@posteo.de,
	driver-core@lists.linux.dev,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pwm@vger.kernel.org
Cc: david.m.ertman@intel.com,
	iweiny@kernel.org,
	leon@kernel.org,
	bjorn3_gh@protonmail.com,
	tmgross@umich.edu,
	tamird@kernel.org,
	work@onurozkan.dev,
	sergeh@kernel.org,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	jack@suse.cz,
	ljs@kernel.org,
	liam@infradead.org,
	bhelgaas@google.com,
	kwilczynski@kernel.org,
	ptikhomirov@virtuozzo.com
Subject: [PATCH v7] rust: aref: make `AlwaysRefCounted::inc_ref` an associated function
Date: Sun, 28 Jun 2026 18:07:30 +0800
Message-ID: <20260628100731.64885-1-trev@trevrosa.dev>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA2444000B
X-Stat-Signature: jxhhtdacfgrjttyfwms3jqkdxkoe5y6d
X-HE-Tag: 1782641269-282892
X-HE-Meta: U2FsdGVkX1+DHZJxS5HvRxXlzw+LMR7TRaauAuKCFl78dd6MyUbjzkkMhZIQFpKxyi1Aoc2jemqyrSD3w8wS8XtNjf31paw3ne9nvsxlfdWsbSdxooiTMmDxDatN5E5idKJq9c6Iy89NoMyB7/AAxTd57S3r9RNFRLPVbzpogDj+wE5/3UxFytI/Yg9ifpKe3F5dfoawvoK3b+u66d8JszKgv53JnlHhhvRBZWOg99kG2NzoSDPBltyAG9B2fpxjuzGFx9dZWXdsVm5qNcoy/r6d4kEmr0z4mrNYMojKJKqCIsYKIEFSwriayvRlpdPikVWgIw3J791YzlfRbqLHgJo72FSr0RCSL0YbKDqifF/evdJuQoZozjFj04keLLprss2madg0m4zr3NHqlhp746mmVWNV5/EeFNCKYzOWKEUCOGbA8/4vsL6gYa8w2G3ez21fYwnEE00KVJTcSCQlDxf80WPks9fClhR3Isl1VjQfmTDugiR6i2CilWA1ZEV6ev8j6UWvF8mxVL/WomImlI9oIL2T4rnTnDrkAUs2Op4OU2x4tA91qH/tlI1my+cfHvFMmmbvLGGLIxr5F3Jk1Q5OV/RNRt2l6cJcb+6lqqIaIeXdZJ3IZmKdZSu12/vFnlmyy7A48IGfGDclpT8OFPOXr8sCKpXkMnsCEWOsBn7aukOM5efxHL37oge1n41qblQPFzqW4FG/kUjZFyoGZjN1eS7Dr7cBKx5m7mlCSFQ7UUac49giNZKmb9EaFBpTe3oLVn8V4Jz3cGxYk5S9GDbDUWq0xPzutJq58y1Pmxwnl26gnfEK9qulYNQQCmQY5wCNaUiAov7dw7qrT/Cp9qSAkBwmOrY54foBmvjULzIep8iZpVryfNPuHpwOw82UuqTJM60tS9qeKpe0+BPiDrzNgx0kJ6unDiWaTwg5yQ33EtJdB1XQEgC8D3/1a4n+Hp96cKCY7mE437r9kDb
 6bAjcjmr
 Ql0n6kVBabs+1rv43ZUhcsuFCLTQdof1CFnPl0YG0PIBkALz6UDf/ybiOC8HmwELNilERRywsCbCwPhF7Is0Mk6JwsgPeLx6s7p63e2aiultbtASFther/hX5y59Y27Hkl7eK0zbmXENteH6SbaUoPDvf9i0o5dX/wwV0NFpJ+a/SxzPw/Ax3MzBoMiIs03KJkk6dJfo9kVWQ6ZAKDzIgVMPAf0Qxh8/oT6ShlZcqqi2OL8NrkY4Eu3vI0BhvSH5iqL/vnetFSgFgbs4+tkbCOibmG2w3S0v4E24E9apZp0Sn3EBYUHCtf/42tX34pas6vP1fM4gp5XTAoJ4vqFhQVxfc/uiY6Sr65ElM3ZaeFziEKnASWNs/m6Yw/FXa7m0MtiAUJ8+9ywvs1CO7TB5tqLqDjaYWaMwl1bX6/ZUie7HNp+wW4qICQIl7VgHIF8KHlsLm6j8NWq3MarfeWX3K3l5rPTwh3Ny79h5G9272l9dGX0PT73cFxXjfMrok+sfqXfgUnS0IfBINQZ80cdvu848ex5wrmMgV3hWlZj29ffnk6GGzmLhJt0CUg1K+NEnYxPSUOEXllnkuSWhKpXRUdMYcWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`AlwaysRefCounted::inc_ref` is a function that shouldn't be called lightly.

To prevent accidentally calling it, change `inc_ref` to be an associated function.

Modify all `AlwaysRefCounted` implementors to work with this change.

Suggested-by: Benno Lossin <lossin@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1177
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Trevor Chan <trev@trevrosa.dev>
---
Changes in v2:
 - Don't word wrap the patch
Changes in v3:
 - Make argument name of `Empty::inc_ref` consistent with `Empty::dec_ref`
Changes in v4:
 - Rebase to new rust-next, change new implementors
 - Reword explanation for change in `AlwaysRefCounted::inc_ref` doc comment
Changes in v5:
 - Change commit message to be imperative
Changes in v6:
 - Change all the implementors
Changes in v7:
 - Correct changes for implementors that are conditionally compiled
---
 rust/kernel/auxiliary.rs        |  4 ++--
 rust/kernel/block/mq/request.rs |  4 ++--
 rust/kernel/cred.rs             |  4 ++--
 rust/kernel/device.rs           |  4 ++--
 rust/kernel/device/property.rs  |  4 ++--
 rust/kernel/drm/device.rs       |  4 ++--
 rust/kernel/drm/gem/mod.rs      |  4 ++--
 rust/kernel/drm/gpuvm/mod.rs    |  4 ++--
 rust/kernel/drm/gpuvm/vm_bo.rs  |  4 ++--
 rust/kernel/fs/file.rs          |  8 ++++----
 rust/kernel/i2c.rs              |  8 ++++----
 rust/kernel/mm.rs               |  8 ++++----
 rust/kernel/mm/mmput_async.rs   |  4 ++--
 rust/kernel/opp.rs              |  4 ++--
 rust/kernel/pci.rs              |  4 ++--
 rust/kernel/pid_namespace.rs    |  4 ++--
 rust/kernel/platform.rs         |  4 ++--
 rust/kernel/pwm.rs              |  4 ++--
 rust/kernel/sync/aref.rs        | 11 +++++++----
 rust/kernel/task.rs             |  4 ++--
 rust/kernel/usb.rs              |  8 ++++----
 21 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/rust/kernel/auxiliary.rs b/rust/kernel/auxiliary.rs
index c42928d5a239..75a61b51cf79 100644
--- a/rust/kernel/auxiliary.rs
+++ b/rust/kernel/auxiliary.rs
@@ -345,9 +345,9 @@ unsafe impl<Ctx: device::DeviceContext> device::AsBusDevice<Ctx> for Device<Ctx>
 
 // SAFETY: Instances of `Device` are always reference-counted.
 unsafe impl crate::sync::aref::AlwaysRefCounted for Device {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
-        unsafe { bindings::get_device(self.as_ref().as_raw()) };
+        unsafe { bindings::get_device(obj.as_ref().as_raw()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index ce3e30c81cb5..f41d01ea4595 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -234,8 +234,8 @@ unsafe impl<T: Operations> Sync for Request<T> {}
 // keeps the object alive in memory at least until a matching reference count
 // decrement is executed.
 unsafe impl<T: Operations> AlwaysRefCounted for Request<T> {
-    fn inc_ref(&self) {
-        self.wrapper_ref().refcount().inc();
+    fn inc_ref(obj: &Self) {
+        obj.wrapper_ref().refcount().inc();
     }
 
     unsafe fn dec_ref(obj: core::ptr::NonNull<Self>) {
diff --git a/rust/kernel/cred.rs b/rust/kernel/cred.rs
index ffa156b9df37..d53cbc792fa3 100644
--- a/rust/kernel/cred.rs
+++ b/rust/kernel/cred.rs
@@ -78,9 +78,9 @@ pub fn euid(&self) -> Kuid {
 // SAFETY: The type invariants guarantee that `Credential` is always ref-counted.
 unsafe impl AlwaysRefCounted for Credential {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference means that the refcount is nonzero.
-        unsafe { bindings::get_cred(self.0.get()) };
+        unsafe { bindings::get_cred(obj.0.get()) };
     }
 
     #[inline]
diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 645afc49a27d..ec44dcc405d5 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -449,9 +449,9 @@ pub fn name(&self) -> &CStr {
 
 // SAFETY: Instances of `Device` are always reference-counted.
 unsafe impl crate::sync::aref::AlwaysRefCounted for Device {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
-        unsafe { bindings::get_device(self.as_raw()) };
+        unsafe { bindings::get_device(obj.as_raw()) };
     }
 
     unsafe fn dec_ref(obj: ptr::NonNull<Self>) {
diff --git a/rust/kernel/device/property.rs b/rust/kernel/device/property.rs
index 5aead835fbbc..c39ccc1458b9 100644
--- a/rust/kernel/device/property.rs
+++ b/rust/kernel/device/property.rs
@@ -361,10 +361,10 @@ fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
 
 // SAFETY: Instances of `FwNode` are always reference-counted.
 unsafe impl crate::sync::aref::AlwaysRefCounted for FwNode {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference guarantees that the
         // refcount is non-zero.
-        unsafe { bindings::fwnode_handle_get(self.as_raw()) };
+        unsafe { bindings::fwnode_handle_get(obj.as_raw()) };
     }
 
     unsafe fn dec_ref(obj: ptr::NonNull<Self>) {
diff --git a/rust/kernel/drm/device.rs b/rust/kernel/drm/device.rs
index 477cf771fb10..0c70ec010bd9 100644
--- a/rust/kernel/drm/device.rs
+++ b/rust/kernel/drm/device.rs
@@ -363,9 +363,9 @@ fn deref(&self) -> &Self::Target {
 // SAFETY: DRM device objects are always reference counted and the get/put functions
 // satisfy the requirements.
 unsafe impl<T: drm::Driver, C: DeviceContext> AlwaysRefCounted for Device<T, C> {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
-        unsafe { bindings::drm_dev_get(self.as_raw()) };
+        unsafe { bindings::drm_dev_get(obj.as_raw()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
diff --git a/rust/kernel/drm/gem/mod.rs b/rust/kernel/drm/gem/mod.rs
index c8b66d816871..ee9e412066ab 100644
--- a/rust/kernel/drm/gem/mod.rs
+++ b/rust/kernel/drm/gem/mod.rs
@@ -52,10 +52,10 @@ unsafe impl $( <$( $tparam_id ),+> )? $crate::sync::aref::AlwaysRefCounted for $
             Self: IntoGEMObject,
             $( $( $bind_param : $bind_trait ),+ )?
         {
-            fn inc_ref(&self) {
+            fn inc_ref(obj: &Self) {
                 // SAFETY: The existence of a shared reference guarantees that the refcount is
                 // non-zero.
-                unsafe { bindings::drm_gem_object_get(self.as_raw()) };
+                unsafe { bindings::drm_gem_object_get(obj.as_raw()) };
             }
 
             unsafe fn dec_ref(obj: core::ptr::NonNull<Self>) {
diff --git a/rust/kernel/drm/gpuvm/mod.rs b/rust/kernel/drm/gpuvm/mod.rs
index ae58f6f667c1..1777f9cbd2ca 100644
--- a/rust/kernel/drm/gpuvm/mod.rs
+++ b/rust/kernel/drm/gpuvm/mod.rs
@@ -80,9 +80,9 @@ unsafe impl<T: DriverGpuVm> Sync for GpuVm<T> {}
 
 // SAFETY: By type invariants, the allocation is managed by the refcount in `self.vm`.
 unsafe impl<T: DriverGpuVm> AlwaysRefCounted for GpuVm<T> {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: By type invariants, the allocation is managed by the refcount in `self.vm`.
-        unsafe { bindings::drm_gpuvm_get(self.vm.get()) };
+        unsafe { bindings::drm_gpuvm_get(obj.vm.get()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
diff --git a/rust/kernel/drm/gpuvm/vm_bo.rs b/rust/kernel/drm/gpuvm/vm_bo.rs
index c064ac63897b..250e9339b30e 100644
--- a/rust/kernel/drm/gpuvm/vm_bo.rs
+++ b/rust/kernel/drm/gpuvm/vm_bo.rs
@@ -21,9 +21,9 @@ pub struct GpuVmBo<T: DriverGpuVm> {
 
 // SAFETY: By type invariants, the allocation is managed by the refcount in `self.inner`.
 unsafe impl<T: DriverGpuVm> AlwaysRefCounted for GpuVmBo<T> {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: By type invariants, the allocation is managed by the refcount in `self.inner`.
-        unsafe { bindings::drm_gpuvm_bo_get(self.inner.get()) };
+        unsafe { bindings::drm_gpuvm_bo_get(obj.inner.get()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
diff --git a/rust/kernel/fs/file.rs b/rust/kernel/fs/file.rs
index 23ee689bd240..8e5967afcd11 100644
--- a/rust/kernel/fs/file.rs
+++ b/rust/kernel/fs/file.rs
@@ -199,9 +199,9 @@ unsafe impl Sync for File {}
 // makes `ARef<File>` own a normal refcount.
 unsafe impl AlwaysRefCounted for File {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference means that the refcount is nonzero.
-        unsafe { bindings::get_file(self.as_ptr()) };
+        unsafe { bindings::get_file(obj.as_ptr()) };
     }
 
     #[inline]
@@ -235,9 +235,9 @@ pub struct LocalFile {
 // makes `ARef<LocalFile>` own a normal refcount.
 unsafe impl AlwaysRefCounted for LocalFile {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference means that the refcount is nonzero.
-        unsafe { bindings::get_file(self.as_ptr()) };
+        unsafe { bindings::get_file(obj.as_ptr()) };
     }
 
     #[inline]
diff --git a/rust/kernel/i2c.rs b/rust/kernel/i2c.rs
index 624b971ca8b0..1a9882a64c4b 100644
--- a/rust/kernel/i2c.rs
+++ b/rust/kernel/i2c.rs
@@ -425,9 +425,9 @@ pub fn get(index: i32) -> Result<ARef<Self>> {
 
 // SAFETY: Instances of `I2cAdapter` are always reference-counted.
 unsafe impl AlwaysRefCounted for I2cAdapter {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
-        unsafe { bindings::i2c_get_adapter(self.index()) };
+        unsafe { bindings::i2c_get_adapter(obj.index()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
@@ -501,9 +501,9 @@ unsafe impl<Ctx: device::DeviceContext> device::AsBusDevice<Ctx> for I2cClient<C
 
 // SAFETY: Instances of `I2cClient` are always reference-counted.
 unsafe impl AlwaysRefCounted for I2cClient {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
-        unsafe { bindings::get_device(self.as_ref().as_raw()) };
+        unsafe { bindings::get_device(obj.as_ref().as_raw()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 4764d7b68f2a..c955cbd884b8 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -57,9 +57,9 @@ unsafe impl Sync for Mm {}
 // SAFETY: By the type invariants, this type is always refcounted.
 unsafe impl AlwaysRefCounted for Mm {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The pointer is valid since self is a reference.
-        unsafe { bindings::mmgrab(self.as_raw()) };
+        unsafe { bindings::mmgrab(obj.as_raw()) };
     }
 
     #[inline]
@@ -93,9 +93,9 @@ unsafe impl Sync for MmWithUser {}
 // SAFETY: By the type invariants, this type is always refcounted.
 unsafe impl AlwaysRefCounted for MmWithUser {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The pointer is valid since self is a reference.
-        unsafe { bindings::mmget(self.as_raw()) };
+        unsafe { bindings::mmget(obj.as_raw()) };
     }
 
     #[inline]
diff --git a/rust/kernel/mm/mmput_async.rs b/rust/kernel/mm/mmput_async.rs
index b8d2f051225c..7df40777654c 100644
--- a/rust/kernel/mm/mmput_async.rs
+++ b/rust/kernel/mm/mmput_async.rs
@@ -36,9 +36,9 @@ unsafe impl Sync for MmWithUserAsync {}
 // SAFETY: By the type invariants, this type is always refcounted.
 unsafe impl AlwaysRefCounted for MmWithUserAsync {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The pointer is valid since self is a reference.
-        unsafe { bindings::mmget(self.as_raw()) };
+        unsafe { bindings::mmget(obj.as_raw()) };
     }
 
     #[inline]
diff --git a/rust/kernel/opp.rs b/rust/kernel/opp.rs
index 62e44676125d..84802f22b652 100644
--- a/rust/kernel/opp.rs
+++ b/rust/kernel/opp.rs
@@ -1043,9 +1043,9 @@ unsafe impl Sync for OPP {}
 /// SAFETY: The type invariants guarantee that [`OPP`] is always refcounted.
 unsafe impl AlwaysRefCounted for OPP {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference means that the refcount is nonzero.
-        unsafe { bindings::dev_pm_opp_get(self.0.get()) };
+        unsafe { bindings::dev_pm_opp_get(obj.0.get()) };
     }
 
     #[inline]
diff --git a/rust/kernel/pci.rs b/rust/kernel/pci.rs
index 5071cae6543f..0f16cf0da3d7 100644
--- a/rust/kernel/pci.rs
+++ b/rust/kernel/pci.rs
@@ -482,9 +482,9 @@ impl<'a> crate::dma::Device<'a> for Device<device::Core<'a>> {}
 
 // SAFETY: Instances of `Device` are always reference-counted.
 unsafe impl crate::sync::aref::AlwaysRefCounted for Device {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
-        unsafe { bindings::pci_dev_get(self.as_raw()) };
+        unsafe { bindings::pci_dev_get(obj.as_raw()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
diff --git a/rust/kernel/pid_namespace.rs b/rust/kernel/pid_namespace.rs
index 979a9718f153..381c9f980b1f 100644
--- a/rust/kernel/pid_namespace.rs
+++ b/rust/kernel/pid_namespace.rs
@@ -43,9 +43,9 @@ pub unsafe fn from_ptr<'a>(ptr: *const bindings::pid_namespace) -> &'a Self {
 // SAFETY: Instances of `PidNamespace` are always reference-counted.
 unsafe impl AlwaysRefCounted for PidNamespace {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference means that the refcount is nonzero.
-        unsafe { bindings::get_pid_ns(self.as_ptr()) };
+        unsafe { bindings::get_pid_ns(obj.as_ptr()) };
     }
 
     #[inline]
diff --git a/rust/kernel/platform.rs b/rust/kernel/platform.rs
index 9b362e0495d3..85068ae5a405 100644
--- a/rust/kernel/platform.rs
+++ b/rust/kernel/platform.rs
@@ -519,9 +519,9 @@ impl<'a> crate::dma::Device<'a> for Device<device::Core<'a>> {}
 
 // SAFETY: Instances of `Device` are always reference-counted.
 unsafe impl crate::sync::aref::AlwaysRefCounted for Device {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
-        unsafe { bindings::get_device(self.as_ref().as_raw()) };
+        unsafe { bindings::get_device(obj.as_ref().as_raw()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
diff --git a/rust/kernel/pwm.rs b/rust/kernel/pwm.rs
index 6c9d667009ef..6f85ddceb872 100644
--- a/rust/kernel/pwm.rs
+++ b/rust/kernel/pwm.rs
@@ -631,10 +631,10 @@ pub fn new<'a>(
 // SAFETY: Implements refcounting for `Chip` using the embedded `struct device`.
 unsafe impl<T: PwmOps> AlwaysRefCounted for Chip<T> {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: `self.0.get()` points to a valid `pwm_chip` because `self` exists.
         // The embedded `dev` is valid. `get_device` increments its refcount.
-        unsafe { bindings::get_device(&raw mut (*self.0.get()).dev) };
+        unsafe { bindings::get_device(&raw mut (*obj.0.get()).dev) };
     }
 
     #[inline]
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index b721b2e00b98..42e11458b77c 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -44,7 +44,10 @@
 /// alive.)
 pub unsafe trait AlwaysRefCounted {
     /// Increments the reference count on the object.
-    fn inc_ref(&self);
+    ///
+    /// This function should not be called accidentally; a type might declare their own `inc_ref`
+    /// function and it shouldn't be confused with this one.
+    fn inc_ref(obj: &Self);
 
     /// Decrements the reference count on the object.
     ///
@@ -126,7 +129,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// # // SAFETY: TODO.
     /// unsafe impl AlwaysRefCounted for Empty {
-    ///     fn inc_ref(&self) {}
+    ///     fn inc_ref(obj: &Self) {}
     ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
     /// }
     ///
@@ -145,7 +148,7 @@ pub fn into_raw(me: Self) -> NonNull<T> {
 
 impl<T: AlwaysRefCounted> Clone for ARef<T> {
     fn clone(&self) -> Self {
-        self.inc_ref();
+        T::inc_ref(self);
         // SAFETY: We just incremented the refcount above.
         unsafe { Self::from_raw(self.ptr) }
     }
@@ -162,7 +165,7 @@ fn deref(&self) -> &Self::Target {
 
 impl<T: AlwaysRefCounted> From<&T> for ARef<T> {
     fn from(b: &T) -> Self {
-        b.inc_ref();
+        T::inc_ref(b);
         // SAFETY: We just incremented the refcount above.
         unsafe { Self::from_raw(NonNull::from(b)) }
     }
diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 38273f4eedb5..a7711e1558c2 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -349,9 +349,9 @@ pub fn group_leader(&self) -> &Task {
 // SAFETY: The type invariants guarantee that `Task` is always refcounted.
 unsafe impl crate::sync::aref::AlwaysRefCounted for Task {
     #[inline]
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The existence of a shared reference means that the refcount is nonzero.
-        unsafe { bindings::get_task_struct(self.as_ptr()) };
+        unsafe { bindings::get_task_struct(obj.as_ptr()) };
     }
 
     #[inline]
diff --git a/rust/kernel/usb.rs b/rust/kernel/usb.rs
index 7aff0c82d0af..c039059c1891 100644
--- a/rust/kernel/usb.rs
+++ b/rust/kernel/usb.rs
@@ -393,11 +393,11 @@ fn as_ref(&self) -> &Device {
 
 // SAFETY: Instances of `Interface` are always reference-counted.
 unsafe impl AlwaysRefCounted for Interface {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The invariants of `Interface` guarantee that `self.as_raw()`
         // returns a valid `struct usb_interface` pointer, for which we will
         // acquire a new refcount.
-        unsafe { bindings::usb_get_intf(self.as_raw()) };
+        unsafe { bindings::usb_get_intf(obj.as_raw()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
@@ -444,11 +444,11 @@ fn as_raw(&self) -> *mut bindings::usb_device {
 
 // SAFETY: Instances of `Device` are always reference-counted.
 unsafe impl AlwaysRefCounted for Device {
-    fn inc_ref(&self) {
+    fn inc_ref(obj: &Self) {
         // SAFETY: The invariants of `Device` guarantee that `self.as_raw()`
         // returns a valid `struct usb_device` pointer, for which we will
         // acquire a new refcount.
-        unsafe { bindings::usb_get_dev(self.as_raw()) };
+        unsafe { bindings::usb_get_dev(obj.as_raw()) };
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
-- 
2.47.3


