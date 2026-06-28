Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 321A3C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 09:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D5B6B008A; Sun, 28 Jun 2026 05:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45E56B0092; Sun, 28 Jun 2026 05:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33A16B0093; Sun, 28 Jun 2026 05:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5636B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 05:29:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2F4914039C
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:29:21 +0000 (UTC)
X-FDA: 84928798122.17.61BFFE9
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 173251C0002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:29:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of szehawong@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=szehawong@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=trevrosa.dev (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782638960;
	b=cdgVACYwkTr26PxTOEzBQwo+ScmIsanH1NNCcoqVQu4yvwJF9+yzH/Wr3wzuJehWKO/JdL
	Roj9yhO+e2m4FY+XRIIIXkJZKzmd3tgciEgDnTrXdajJcYYKflDb8r8RK9ekbEUj0I4Q7U
	tBuDw+dLQ3e4mbQYghQK5tO2Wu2wtE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782638960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=msiQeoD9bE2+9m/GBRmkavuhnEjua8HjkhejH4gaLD4=;
	b=iOciYJ44o7eFQuPYZzipUXsyrqFRZgc6/OIIrcBIK63pM7bICGMOZAs6KU+BFJmINx5bw8
	hLgKwmBha2U53xWpvJitIN3VJQhEnz44YjuQB/QQzAIUKVS0IJ4mDywHvzOqhyD2V2Homh
	LxWei9p9iWU/Mz76bUEygbY0MD/NKi4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of szehawong@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=szehawong@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=trevrosa.dev (policy=none)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c8007ce809so11811625ad.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 02:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782638959; x=1783243759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msiQeoD9bE2+9m/GBRmkavuhnEjua8HjkhejH4gaLD4=;
        b=WR2I+HMEYiTDNTot1k8HTnIJfAHaLB9aU6pJmd8zjWR0NI8R+IdMTXooUCN3bLjuks
         t3iF+eW7iXPr0lPKvAEhBA1GIZdHK8cFuOPV86Nzc0QsLcfmPZXofICOWrxSlA2pL+q9
         lzjU4bgm8QTj6IZhSx9Ifh3CMmTf0U3dpPu2GmcfhXbe8pQxpK6cpCzHbtgy9t4QuZcG
         e9Du0nwqRS/1WlpNGqZUV/qDX74cN52+T+249C0p5NJG21g7+67ofXyvvqpaKqa5rrpL
         T4dx5Dp60RS8y3ibKSbWJlF8+bRa0jOLvQHzdjZxoxPn6TAKDblu/0WS3mnYOTreQ/M+
         3YFQ==
X-Forwarded-Encrypted: i=1; AHgh+RoTJYkV8TBuw20nwEZNbtHlzxRvo+kv21gsKJvY940mchNN/1kHeqgTwRdqjN1sl0a6kcINrSU00Q==@kvack.org
X-Gm-Message-State: AOJu0YybtD+prY4CB0/Xk988VDV0J5FZpxTTvMrh9Vi/7cDw3ozryBkI
	jodazudClITA5mvtxAxOcpS4LuBfovAsm/C6oYiB0AnCmnv2a0xxEom9
X-Gm-Gg: AfdE7ckyuSPXcQ7kPf+atuxPgq/FIzzSc9A9VDS7EoKhDmJIbVTBKPxno+5cIEUcWdj
	jgEVbYHGq8cHR0ub4mVB+qQ9Q4INCFMMZIAAYVKBcij+1pH+PeK/bxruyCOQZVdjhlIC9N2l0EE
	wwPJLy+QoJwO+MQx9l0z9ShDNtCl0oa4pjdG1uj2hb6RXey0iqErmOMW+B7eqfy9p7Ha0MuH5r8
	fK6OxRgkUy1ZNC+IIwaUE3/4qddyXy2ELxLLQRYA12tBi91ZTgHz9tspcUvtpIcr1CqkrsIY/nf
	Tot7FnvHggfDGa0lHd8VxaWl0XeP4xI9RyBoSFzveQqfMQ5Qtco4tKmceByMy9vLmh5Gn+cPR76
	SAmXDd69uZr+d4Ikn7Q5Dcsf2z5aGiWT1sa4nzTlV3WbmcLBOtWzIXl5Jj4mAfQAe26VtlUrtdn
	dqB6T9doK8MqED+Hq415CDbyii3rDhkuQj+DSMRT6zl6P1CJ9XjA==
X-Received: by 2002:a17:903:1ac3:b0:2c9:97a7:3288 with SMTP id d9443c01a7336-2c997a733f5mr55740665ad.42.1782638958963;
        Sun, 28 Jun 2026 02:29:18 -0700 (PDT)
Received: from trevor.localdomain (n119236170163.netvigator.com. [119.236.170.163])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c9b43aeb3bsm23041205ad.54.2026.06.28.02.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 02:29:18 -0700 (PDT)
From: Trevor Chan <trev@trevrosa.dev>
To: gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	ojeda@kernel.org,
	a.hindborg@kernel.org,
	paul@paul-moore.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	aliceryhl@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	igor.korotin@linux.dev,
	boqun@kernel.org,
	gary@garyguo.net,
	axboe@kernel.dk,
	daniel.almeida@collabora.com,
	shankari.ak0208@gmail.com,
	lyude@redhat.com,
	j@jananu.net,
	akpm@linux-foundation.org,
	acourbot@nvidia.com
Cc: david.m.ertman@intel.com,
	iweiny@kernel.org,
	leon@kernel.org,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	tmgross@umich.edu,
	tamird@kernel.org,
	work@onurozkan.dev,
	sergeh@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	liam@infradead.org,
	bhelgaas@google.com,
	kwilczynski@kernel.org,
	ptikhomirov@virtuozzo.com,
	elle@weathered-steel.dev,
	rust-for-linux@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v5] rust: aref: make `AlwaysRefCounted::inc_ref` an associated function
Date: Sun, 28 Jun 2026 17:28:53 +0800
Message-ID: <20260628092853.16550-1-trev@trevrosa.dev>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 173251C0002
X-Stat-Signature: 5oxxsbuaxef196dw3mwzek8mbxpsrf5t
X-HE-Tag: 1782638959-154783
X-HE-Meta: U2FsdGVkX1/w8rzZANVtv3tI6StnSu9hoHv7TdvWHsJIkQcBNf738t4jYQw+EC50nauaOqKA6niQTDXcM4ogLQ2N05UOcAu+9OfKy6nS35arH36q+Wa7sV/5anJkHavZ5qg1LzKDnDYJWU9tT28hBw3HhIwvWWdv2fQ4oZYFMsXRl4hnCSW64YkyuAKoMeVso7h4fIAN4W6d76PCZTvmPzl1KmmlHPzDszcS3dlMrCygEwlz4EkUP43CfZbH6KqrdDid9SoUpey5kbnNayIjf6PCBeacmuBH6iEAykVuCOuZDQOOhtzDWU/Ov1+SF+IQDLLY8RZ6K1NsoKVtvzhqHsr7LMvh6pdc67aQJADVNO7Nrx2x5RZVebDOoBO15/ffcVUMCtKEskPFc6K3P1PwtK1BttFd8lD8FtKZ6J0LigMz1P6xv0fYyVd3hKk0nCfTG8LNvulyvpIBf4CRtCiGaX9EFZkGgfQkWLkN7RjpT5xw9Q/zdKANfAoyM0dvs1cTC7swsA0nWhy9MR3E4qgDJOZAgE2xLzBUVwdUfj8UOevXpV7LJpgEhOcrEtgkpY7gQxxzPc5RrcDwKjI255WugrxfnLi33I0V3pWDKrwFmabe6Fl5usXqxb83jUP0fAJb0B3QMwg5qJI1Cl+palqzQNRgfeaxA4r+e7+KWhW6OM83HRovjCbMrI2KgZoDqphWVyGYEomJbxeOBtXYcBi4fyVXzZgKUmRKCEGNgITb2CXJAg2k1kW3+viSwznENcUTSgzPjsK/Taci0GYeZ6ZUVZS95iSwfUNYVny/SwNs11SSLtxqeKc3u4c3EZqZCZg+IUJzzPwpxQ8lGYt2TmmCQAbuFHubwv1wa9AjYJYyXas4LsI8e5BXBvneDIJAwwFo4rqkYUAqf89JFY0bxY1SzRXTWGTnpI8MWo1sHIAT4ye+xyWccD5jRIADyLcwgFvXvxWmyPfkC2zV9ucGuf2
 tuit6eB5
 0ILYbNcb3RUi8gFpO05Fg8it4BAonhLDnPfoZ5l2Qh4NELooGv6AzAVRvxIakCtUbLqpd4CIt91FIXc4W0TzvJYYcKrleqdKN85YqL/T2+/GvqkqMXjvNoo4BwJlQ5vLUs+2dVJ3TXZNUxN2zjUvDtzbY+VESBxSpFxnOTBHgjB/JlyuIerogU/ueYtKH2HSz/L7v2KV1XVIs1bS7xepJfMeYXPi1TipQ8axHFGZN60ICmkq+EXVOPbXkkpaW8Wkh31v3b2ilPwozzLw+SgL8f2bbtMrDdYDYD929sx6Mt4MWhkMjGkEVoKhplBxjaZjM6rkGOCb1GNmybQZKWVs6MrTgyTnO08wJzG7sqRKWR6zJjGoV6oEUq9bdYYc5p5k+DWwem8cT/nJPmivogiW5pkH7kLEFNToLQfh2yP1Q4/CrAELiSVowXKlqbar5lbZ03lqXQ2+GVgbgRT4t1x+J4PNko6oTUzdvbKwXRpULbIAebBNeeCLuYOaMhHZqGCbNlZFz482vKM+RT0vM/bizSED2vs3orC7+Lz6NMjTYW9+dHb9/lMzxZTFG3HXvVGC2v5jHOjds/FBx/WxPqW5/sc2imQ==
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
---
 rust/kernel/auxiliary.rs        | 4 ++--
 rust/kernel/block/mq/request.rs | 4 ++--
 rust/kernel/cred.rs             | 4 ++--
 rust/kernel/device.rs           | 4 ++--
 rust/kernel/device/property.rs  | 4 ++--
 rust/kernel/drm/device.rs       | 4 ++--
 rust/kernel/drm/gem/mod.rs      | 4 ++--
 rust/kernel/fs/file.rs          | 8 ++++----
 rust/kernel/i2c.rs              | 8 ++++----
 rust/kernel/mm.rs               | 8 ++++----
 rust/kernel/mm/mmput_async.rs   | 4 ++--
 rust/kernel/pci.rs              | 4 ++--
 rust/kernel/pid_namespace.rs    | 4 ++--
 rust/kernel/platform.rs         | 4 ++--
 rust/kernel/sync/aref.rs        | 9 ++++++---
 rust/kernel/task.rs             | 4 ++--
 rust/kernel/usb.rs              | 8 ++++----
 17 files changed, 46 insertions(+), 43 deletions(-)

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
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index b721b2e00b98..2ae2130d5bb1 100644
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


