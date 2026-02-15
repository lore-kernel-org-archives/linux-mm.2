Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBCAE63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6046B00F7; Sun, 15 Feb 2026 18:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89EA76B010F; Sun, 15 Feb 2026 18:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0386B0110; Sun, 15 Feb 2026 18:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with SMTP id 684896B00F7
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:53:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCE565C49B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:03 +0000 (UTC)
X-FDA: 84448324086.21.B076905
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0CA2EA0007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h1auz/5i";
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYhRwSgQ2S39+P8OP6QpI1GEeIx4ODF4QSVt1jyW850=;
	b=4NyhYgh4Aa71HNRj/F/DzarbO9lXpwiFM233ahJLFOTvj4+cJFkhx+RjmWNUmQIt+/+OpZ
	8kd44bJGqe+4S92jvN0mVS48O99K5lG1vpnpQ94s6j6Xn29iWUk1XtjFiHmDk4HHHp4083
	sGpW96NzMbOyAP5Jn2NyGk3I0lA0e+Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h1auz/5i";
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199102; a=rsa-sha256;
	cv=none;
	b=5ZLjHezfjArT5izZaQZMCsfYKY+Autqz4vQbYvhMotjr8/3XIjL4fcgIjJSpaM/GSLFaLb
	W0s9IygvtL0rTwcYNJjwFzDOlzxSVFr0UA3znfcpIKpACz2MHj3FgZZxLc/gUs6GJdvlDZ
	4NVo7HYI5Zqs8RZae5Lq3Tqg10A/o4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 382D940227;
	Sun, 15 Feb 2026 23:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD2BC4CEF7;
	Sun, 15 Feb 2026 23:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199101;
	bh=GKW86kl+p+OYSwPf2Q41uaeBW8CpLNtmUrapwK7eNLU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=h1auz/5iRD896cAXZlpHR+dDUEYCUYbZsj1fP3hBtQQzpz9B9cop2T0CTRCeiWlh2
	 s4/rS0fdDTV+lx4uRgfCELY/PxZUTSr4/pR7/WjlKCxEniFHNFoZY+egEQRsGC1BhN
	 6LutD8eT+I7lepVZCB+CKaSCo+78K3+FZInA842/v1H5babY27xW+ymrTouYTZsYFw
	 gKccYcmwjjc/HZ9pbmmkqm4+l3mA9JVGowdU48IG0K8UhNBh9CQJrg1o8pxnR/q0ZB
	 f0WTIsyja+tR07ChjAN6VRS/IDLFvdQljKX5ZrXTF5QA3Hn/nJebLHHK9OL9lAUkPS
	 olq/lZs3NEzUA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:33 +0100
Subject: [PATCH 46/79] block: rust: move gendisk vtable construction to
 separate function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-46-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5340; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=GKW86kl+p+OYSwPf2Q41uaeBW8CpLNtmUrapwK7eNLU=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhFsomGNwQiKqCjwEzFCcRjle0tp7r1mEuBz
 PnfAoH6wiSJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYRQAKCRDhuBo+eShj
 d/nNEACRmzsCoK43XTYTgBY9N9dFJ5DpDKa32BQG4qau8nxvTPXcN7Tm1y7kgYUafBtt9fSDNnO
 nJvRlCSsXQ2XqmZzUhlywwUrmfqqQV/67m6LCTdre7MLyfOpPM79MuAofV4LymRfqnMuhwX35bo
 /nuJ6oDU5LEj1O0jnZSwxFHquBg/o7g/KAmSitrKqdjKuu1gWlZxTG+qAUj6efPjfOEzXwkvV0i
 lWda+EkMTJl6SK3eq+6ymSY4adKHrtTYqoCgINxS4uAXxLXwV/19Zb663PJhFESxCmSJimNzt4g
 AGsJbVd718TSMKQZWr9ZI7yB7Y9+ptrmSiY7pHwzCwhZJsexQZ1TAKTPN2d2L9hyEsDyKwkdyJH
 7pSOWLOuGEDH4ZnXL+kfA2vy8gJ/7b4zUyGeQCgTvEWWL9a0AaKbacyM+wU2TFrcF0LhvzIEbRV
 CUFhDEGmRxmvaqnmmN6jCgO9zEIgGrV2kophX22Pzy639HDEjtWoU3XJWw1UydyDhiBKyP6Sfgh
 oUXsg68nFb/MckFOA1p8PrbjI5Tx4udUny7Ap0uIctqGN+AG1Bk9tQwx1TsQy3pBNuFffC7OrDq
 6Ec4pqI/CyuVhXnpb007xuCJYDoa679rMhRKEOHkcBzuZT+7j9SEMtn5qt8F9IUXGzX+BbI7+nB
 feQtdV6gwpBTHQg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CA2EA0007
X-Rspamd-Server: rspam07
X-Stat-Signature: sfxnx3w7todoe3qpcpfethf9d1nbrweo
X-HE-Tag: 1771199101-707259
X-HE-Meta: U2FsdGVkX19zWFJALOWmaasNjlPzmZHzDE/yIPAz19UTg8O9s5PUG37rTO0Qpa9YV6ZdMfvuDCHWNrg0UiSWLkADNwW84XZtR0EOuCVEl3NfI49WnKXLfTmM7BVvovOupsw07lmjf1kYwE/d05pxXDnyQmKrM9czXJ0NtZYVnk0rO0J54yREIJtBxgsBxXPmu+wTGuO7xDy0LjEWUKKa0UzrJTrU5264YrnMjw+VYvwKed/zbpngdk1CYE1w3GOHrd77U0InUhpQvOIAyzKkjHMDfxWeiadyTpQL36o62Wpk5WwFTvy03EwaZdkb9Ux39iqjpcG08bi06suzAsymBP9Z6MwNmO1MBRu68JFQXQvwgo/91Ywbx5UB2uk+B9JhvRVzQ+ZtzizgYzVS3vdTlQdr64UdLWVLT7PLOqu8jC4tEj/3vYKU9YpXE6r6qjd/esm+q6zJKloNM/JNDx1ll0ei9VnbD4l+n9lFgS5LjUD22QQauQHjZqgQ69rSQ41HOlE/Z5LPnKKcuahx23FNqIAFzJRJXKl4/0hkDzsHrfwZv732YHysbpJxyl9N5S8l9lsVhC5t+0UbjgkE1guHZ4RxwXMC/y0MMm2AYuURUauRLiu8J3ZxLbP81lWDFNBMZJIPrUN9jSXAAMwPZ50ln2kKTVm311AsHDX3xKMQcPs/RRJoB10EgK+gSGB54O32BuMwOJTnempJsRayvXpkMVyF7i8T1OB+DFW3Zo24aJv4yNI8J/80xnF6fSD0WGNwjjzhAJqHEpu1pWoiEpDz0J74LiLuOOBMB3+HzGmtbw9FjjcXdy8Yoy9wdbDpx7EdSPue4/6taXUtj6AGXc7+Fe+CSV3srsJqj0/nvlXGIL4eCKmEAmGhhAueng9ZpcRu8sH9vY/W05B/VhOiwr3n4luyRv0qsPujvCr6sFY40deTunFaB5UV/qvvPWOpt56GFZMqBm4kG6Iv+Foi71P
 KVVWALbO
 xwkt0Kt245NlinuBalvVBNV2QGM7yQ9shmL7No6w7Mjx17A3cMoBUhEqbDNx2kgDen8n0qtr54NJf8ReWEAUs8GPCxXVptiSoIhTH6lUt+xTYOAb+9nZlqlp8YzaZlq2IAf3NcVEoRZskX/ni3DayRSFFtRLVZfrQ+rehtxnawkMfbOPfWhLx/o49Bv0qLNm7HfUzaoqD0IuuwgfQ0s62YVopCEqiz33NRClAs5sv2tHxjpLPNlxryuDiUN0PbKheFM+hEp0aLy8VgtTBKuWwZfpYTMrX+nJdqP6+ElFu90KKjKAbOmOaFbHUzwxq7nUxoqI/KQMWdfeRBkpHEWVbQrPk+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the `GenDiskBuilder::build` method to move the `gendisk`
vtable construction into a separate helper function. This prepares for
adding zoned block device support which requires conditional vtable
setup.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs  |  5 ++-
 rust/kernel/block/mq/gen_disk.rs | 66 ++++++++++++++++++++++------------------
 2 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 90f2ecb454285..5dfe7b48af63b 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -266,7 +266,10 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
-configfs_simple_field!(DeviceConfig, 1, block_size, u32, check GenDiskBuilder::validate_block_size);
+configfs_simple_field!(DeviceConfig, 1,
+                       block_size, u32,
+                       check GenDiskBuilder::<NullBlkDevice>::validate_block_size
+);
 configfs_simple_bool_field!(DeviceConfig, 2, rotational);
 configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
 configfs_simple_field!(DeviceConfig, 4, irq_mode, IRQMode);
diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index fbda2f572e17f..eb980079530bd 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -17,20 +17,21 @@
     sync::{Arc, UniqueArc},
     types::{ForeignOwnable, ScopeGuard},
 };
-use core::ptr::NonNull;
+use core::{marker::PhantomData, ptr::NonNull};
 
 /// A builder for [`GenDisk`].
 ///
 /// Use this struct to configure and add new [`GenDisk`] to the VFS.
-pub struct GenDiskBuilder {
+pub struct GenDiskBuilder<T> {
     rotational: bool,
     logical_block_size: u32,
     physical_block_size: u32,
     capacity_sectors: u64,
     max_hw_discard_sectors: u32,
+    _p: PhantomData<T>,
 }
 
-impl Default for GenDiskBuilder {
+impl<T> Default for GenDiskBuilder<T> {
     fn default() -> Self {
         Self {
             rotational: false,
@@ -38,11 +39,12 @@ fn default() -> Self {
             physical_block_size: bindings::PAGE_SIZE as u32,
             capacity_sectors: 0,
             max_hw_discard_sectors: 0,
+            _p: PhantomData,
         }
     }
 }
 
-impl GenDiskBuilder {
+impl<T: Operations> GenDiskBuilder<T> {
     /// Create a new instance.
     pub fn new() -> Self {
         Self::default()
@@ -109,7 +111,7 @@ pub fn max_hw_discard_sectors(mut self, max_hw_discard_sectors: u32) -> Self {
     }
 
     /// Build a new `GenDisk` and add it to the VFS.
-    pub fn build<T: Operations>(
+    pub fn build(
         self,
         name: fmt::Arguments<'_>,
         tagset: Arc<TagSet<T>>,
@@ -141,32 +143,8 @@ pub fn build<T: Operations>(
             )
         })?;
 
-        const TABLE: bindings::block_device_operations = bindings::block_device_operations {
-            submit_bio: None,
-            open: None,
-            release: None,
-            ioctl: None,
-            compat_ioctl: None,
-            check_events: None,
-            unlock_native_capacity: None,
-            getgeo: None,
-            set_read_only: None,
-            swap_slot_free_notify: None,
-            report_zones: None,
-            devnode: None,
-            alternative_gpt_sector: None,
-            get_unique_id: None,
-            // TODO: Set to THIS_MODULE. Waiting for const_refs_to_static feature to
-            // be merged (unstable in rustc 1.78 which is staged for linux 6.10)
-            // <https://github.com/rust-lang/rust/issues/119618>
-            owner: core::ptr::null_mut(),
-            pr_ops: core::ptr::null_mut(),
-            free_disk: None,
-            poll_bio: None,
-        };
-
         // SAFETY: `gendisk` is a valid pointer as we initialized it above
-        unsafe { (*gendisk).fops = &TABLE };
+        unsafe { (*gendisk).fops = Self::build_vtable() };
 
         let mut writer = NullTerminatedFormatter::new(
             // SAFETY: `gendisk` points to a valid and initialized instance. We
@@ -219,6 +197,34 @@ pub fn build<T: Operations>(
 
         Ok(disk.into())
     }
+
+    const VTABLE: bindings::block_device_operations = bindings::block_device_operations {
+        submit_bio: None,
+        open: None,
+        release: None,
+        ioctl: None,
+        compat_ioctl: None,
+        check_events: None,
+        unlock_native_capacity: None,
+        getgeo: None,
+        set_read_only: None,
+        swap_slot_free_notify: None,
+        report_zones: None,
+        devnode: None,
+        alternative_gpt_sector: None,
+        get_unique_id: None,
+        // TODO: Set to THIS_MODULE. Waiting for const_refs_to_static feature to
+        // be merged (unstable in rustc 1.78 which is staged for linux 6.10)
+        // <https://github.com/rust-lang/rust/issues/119618>
+        owner: core::ptr::null_mut(),
+        pr_ops: core::ptr::null_mut(),
+        free_disk: None,
+        poll_bio: None,
+    };
+
+    pub(crate) const fn build_vtable() -> &'static bindings::block_device_operations {
+        &Self::VTABLE
+    }
 }
 
 /// A generic block device.

-- 
2.51.2



