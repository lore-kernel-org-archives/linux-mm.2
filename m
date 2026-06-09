Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADEB6CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221866B00A2; Tue,  9 Jun 2026 15:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2276B00A4; Tue,  9 Jun 2026 15:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8956B00A5; Tue,  9 Jun 2026 15:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFABA6B00A2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACABB4077C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:16 +0000 (UTC)
X-FDA: 84861317352.06.2F37867
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0453E4000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:11:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UbhsD/Lb";
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032275;
	b=vRfh5eoLcsqkCOZpzfRzcFgkGdRbkp52LmXo13Lq+bld3cRhgjBtJMc91bFaieBGHKkOPV
	bn1pmiZE6Uglvh/0wqf9Q18TTl8iDZZlXuToTJLP1HQYLOoYaeet6RTE1x5WexNbRWDTYX
	eFjXsyp3qIj7YtcsFvZnU5esgVw/y4M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UbhsD/Lb";
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgBQwxbMweV6Zkbj2/J7QySjjyAJfiQJ6Oi1laC2E2E=;
	b=b+I5S5NPK0oEI5GTaj3IGeRRhjv1Lt3uSfKybTd318fPLXnY+L6ufJzkHo1NpIkEXtWVUM
	hMPrZ6Xpap0CnyhpTv0CXUxhuCfD2WHutiCWp1bAqVwdYxl99Wa61sRH+wPcsBMDi2HibP
	qQ/VkQ7/OfedARLPk0xTDYPUyJBUD3Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 923DD602D3;
	Tue,  9 Jun 2026 19:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA321F00898;
	Tue,  9 Jun 2026 19:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032274;
	bh=DgBQwxbMweV6Zkbj2/J7QySjjyAJfiQJ6Oi1laC2E2E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UbhsD/LbUCehg1QTO7E5Unt9lyPSrvNa7/2GuoaAkStPWOTqPv2ABuVxIOA3fMdGz
	 PUmt65Gh9wmh+FDCTdDSm6xGptUyjtZfAh6ushZmjXEYaFbKoNQ84HqArEiiu/pGgO
	 IzE7/CCC08113x9AP/PMci8kj5k/PelI1CBIvTY72zPpiHxaN3k9++cT7G2BFljOXx
	 5kDtjFj+btkuK2OeAiqRyrihgMOr2ydXNQhu1kLWjW7edaFcja0gIf/iQq8e5vfP9i
	 wgQ4IzeN03/FI4i4ZCxBQyvdta6M5wv8rs1Q2zUCPw2/7Fgdq8QfRIGwixJEmrWfiz
	 HPjudMd9DXgRQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:44 +0200
Subject: [PATCH v2 05/83] block: rnull: add macros to define configfs
 attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-5-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10514;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=mkT4eThBe4It8KWqsiOtBJt/DANWdnHxd0qXiVgZJI8=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS4cw7+kfXwUnAvj3tdI1tU/JIPYwTDkhIsj
 0/J6tjx/T+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkuAAKCRD6UCkIqsW9
 0MZID/4ymdYkqB7ckKLRVkyTg+DrfULQJOo33DREmgb9MUDfl2wUZ/DkUXOCE01NnuGswQZjgbL
 dKGyJQQBAMDis8nIFLT33hauvbtk8OerUfQwTJv0RLgjFVKK/h3rWpZngwnM64b8DTjwYnOW7Dy
 chJISfMmP/raWJa/87NdX9ES8DxjfPRD4uuoSKPBceZFiYQkQVThHd8zCrSrvdQBqo4VdtLhAZ5
 JtnFr9220oUuKE5iYa1CboZ1/eiGdCBNYRxToFBRirop+UVeZAR+07wqYBZjNjfYgBuD8uudK4K
 p7mSFt3CDKVCTclJ0X+XnBelhsPMLosVjcBO+ytI6MadUXzPxg+2TSgkIHMSkJV4I3yJroqZI2N
 wcmkDk9XWBp6/I20EnJwDqhAkzlkXMECPjd5CQhDC3wZIqN3XmGWsmM95MqQPH9pWKfClmJKfyn
 1lBrz6wjnn1QMNqvOCDZgiSHP0BMqutOQ9g6MoQdNoDIh2FSHYxbjMnA37YPm+N50MNeEDWsm6h
 bqDP7wDHNuXJQAomQg0dknkgdRR4q6bxe9kugzIUNc6CatP9dMKxytHJR7BW7WmJFwXRfgV2Fmq
 t2ZizLRiNVaJNejR1mBk7VZM+LrbMJa3Vg3DMQ0imfCu8d3Uwchte0SN6zDpVLkDoGU5CiK/r9p
 qAL5XeLz/iM9UaQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 0453E4000C
X-Stat-Signature: zqxg5jdymoour1q7wibabygc7msnat1y
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781032274-499878
X-HE-Meta: U2FsdGVkX1+pT/TrtZz/4WGBlAnBnDhxc20YVLRqISyBGy1Z19dcNjofq3GYw+X39ST4c0vNgCi8muG7pw88bPEM52yGYyr3fr3vg1mhMoGQI+FnHG6pj5pavHymoqRuSe1AKs7aE7ffZxmQisQUWivYNxnPnA9bJoz0ZSxAsE0mm7zZjJcPHloULZWSl9gLq5HVuCRZNPr3Wa/+khMkWYM0x+12OzgcyuumSHUGUPtKno1YuoADDMbETxPe8vVJQZuf5z/AyvbZQjbY3FY85FJnKMlOFKVwukDyaTEp0XKnnaInXrJdOoNrmuc9Y7S+LLCF1MQyewa5h/9eHyLE/lXspRXGyG8RG1+uK8JKdNT2Eu9/MyPK/xPuFsfI+nz59mY0ZhFSvCKu0SXbCMWR4mnmv+N/HqD9+H4HJXpw3SxukBTKrezu/yGiqdrVzm4QDzGSvnFyfSdg3dETGEChs7vTobMhhTMA8TwiX0JAv+dIy53oHRkEOkzB8FwDnY64EWy9Fjb3yPPTtY88K9t7pvn0IY09GxrfO/rQ/Lu2Hh/xpJRNWaF41y5wkV96Rw7q5uQ44BulyyrEQOastzKxSF7AhcXMdMgn6Am5VNAp8spV6guefx92m8Yu3m5Uoq7wa6jBzEwnRRqTnCSvZ8re+JWHiIO+MM+T0nPhgWSP5xWe2mwYMMbKYJ7CJL9GeyXzNR/5TrU1AxqlfzkONdfialbepCac1K8S/+c6IBEkx29y0lanISG52Q9G/MVG2KgZ9cSmvo937pjHk2rBRuqcTQtcCarAuinj9aVjLpr1a6atF6yaS3w0mcBuPv4RrQTHwCcdJIC2V2f8Hon7LOhSKaFdU6JihrpuIobjt+Y3v0DXLzXdKhgDOOerR2OMRjlLsqaCRuInHITNulU7/TZltFo2Mto1fgonf/Cu/emxq/mJxlrHL811hx/JabZXjxjMPqmdA/XKuhHa3QtILUZ
 /wcOU/M+
 t/lYvhTnLtuomaV8vg/SMXFaJD4nP6H99r7BUi7RaH61ssnUnOPOZ+MKYszddxlRa7LeUWn9MzfuWKLaV4XuO9e31igXaY65cxz8lhFAXcpkfH5UaaujjIu/wBrHnWuVQb5r6ph7wiQSoP9TZ/fwLUlyrCWuhmF58oUIePE3UNCPrPJyOaILT/dF4rzRO+ghATIPAPPetTDOQ6S/4/wi6IJE00hnDtBtT23Ggqe6PFc8uEAGHryd/GLkRgFcBy/1XYzoc+jPfWa8FwIpFXCkl5aUX44+I+8kU482RsswqMh8Vz8qNLJIrQVDfsvfqB26BTU0W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Defining configfs attributes in rust is a bit verbose at the moment. Add
some macros to make the attribute definition less verbose.

The configfs Rust abstractions should eventually provide procedural macros
for this task. When we get more users of the configfs Rust abstractions, we
shall consider this task.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs        | 134 +++++++++---------------------
 drivers/block/rnull/configfs/macros.rs | 143 +++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+), 98 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index b165347e9413..fd309fc17e66 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -1,18 +1,39 @@
 // SPDX-License-Identifier: GPL-2.0
 
-use super::{NullBlkDevice, THIS_MODULE};
+use super::{
+    NullBlkDevice,
+    THIS_MODULE, //
+};
 use kernel::{
-    block::mq::gen_disk::{GenDisk, GenDiskBuilder},
-    configfs::{self, AttributeOperations},
+    block::mq::gen_disk::{
+        GenDisk,
+        GenDiskBuilder, //
+    },
+    configfs::{
+        self,
+        AttributeOperations, //
+    },
     configfs_attrs,
-    fmt::{self, Write as _},
+    fmt::{
+        self,
+        Write as _, //
+    },
     new_mutex,
     page::PAGE_SIZE,
     prelude::*,
-    str::{kstrtobool_bytes, CString},
-    sync::Mutex,
+    str::{
+        kstrtobool_bytes,
+        CString, //
+    },
+    sync::Mutex, //
+};
+use macros::{
+    configfs_simple_bool_field,
+    configfs_simple_field, //
 };
 
+mod macros;
+
 pub(crate) fn subsystem() -> impl PinInit<kernel::configfs::Subsystem<Config>, Error> {
     let item_type = configfs_attrs! {
         container: configfs::Subsystem<Config>,
@@ -164,99 +185,16 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     }
 }
 
-#[vtable]
-impl configfs::AttributeOperations<1> for DeviceConfig {
-    type Data = DeviceConfig;
-
-    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
-        let mut writer = kernel::str::Formatter::new(page);
-        writer.write_fmt(fmt!("{}\n", this.data.lock().block_size))?;
-        Ok(writer.bytes_written())
-    }
-
-    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
-        if this.data.lock().powered {
-            return Err(EBUSY);
-        }
-
-        let text = core::str::from_utf8(page)?.trim();
-        let value = text.parse::<u32>().map_err(|_| EINVAL)?;
-
-        GenDiskBuilder::validate_block_size(value)?;
-        this.data.lock().block_size = value;
-        Ok(())
-    }
-}
-
-#[vtable]
-impl configfs::AttributeOperations<2> for DeviceConfig {
-    type Data = DeviceConfig;
-
-    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
-        let mut writer = kernel::str::Formatter::new(page);
-
-        if this.data.lock().rotational {
-            writer.write_str("1\n")?;
-        } else {
-            writer.write_str("0\n")?;
-        }
-
-        Ok(writer.bytes_written())
-    }
-
-    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
-        if this.data.lock().powered {
-            return Err(EBUSY);
-        }
-
-        this.data.lock().rotational = kstrtobool_bytes(page)?;
-
-        Ok(())
-    }
-}
-
-#[vtable]
-impl configfs::AttributeOperations<3> for DeviceConfig {
-    type Data = DeviceConfig;
-
-    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
-        let mut writer = kernel::str::Formatter::new(page);
-        writer.write_fmt(fmt!("{}\n", this.data.lock().capacity_mib))?;
-        Ok(writer.bytes_written())
-    }
-
-    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
-        if this.data.lock().powered {
-            return Err(EBUSY);
-        }
-
-        let text = core::str::from_utf8(page)?.trim();
-        let value = text.parse::<u64>().map_err(|_| EINVAL)?;
-
-        this.data.lock().capacity_mib = value;
-        Ok(())
-    }
-}
-
-#[vtable]
-impl configfs::AttributeOperations<4> for DeviceConfig {
-    type Data = DeviceConfig;
-
-    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
-        let mut writer = kernel::str::Formatter::new(page);
-        writer.write_fmt(fmt!("{}\n", this.data.lock().irq_mode))?;
-        Ok(writer.bytes_written())
-    }
+configfs_simple_field!(DeviceConfig, 1, block_size, u32, check GenDiskBuilder::validate_block_size);
+configfs_simple_bool_field!(DeviceConfig, 2, rotational);
+configfs_simple_field!(DeviceConfig, 3, capacity_mib, u64);
+configfs_simple_field!(DeviceConfig, 4, irq_mode, IRQMode);
 
-    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
-        if this.data.lock().powered {
-            return Err(EBUSY);
-        }
+impl core::str::FromStr for IRQMode {
+    type Err = Error;
 
-        let text = core::str::from_utf8(page)?.trim();
-        let value = text.parse::<u8>().map_err(|_| EINVAL)?;
-
-        this.data.lock().irq_mode = IRQMode::try_from(value)?;
-        Ok(())
+    fn from_str(s: &str) -> Result<Self> {
+        let value: u8 = s.parse().map_err(|_| EINVAL)?;
+        value.try_into()
     }
 }
diff --git a/drivers/block/rnull/configfs/macros.rs b/drivers/block/rnull/configfs/macros.rs
new file mode 100644
index 000000000000..30bb32238457
--- /dev/null
+++ b/drivers/block/rnull/configfs/macros.rs
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use super::{
+    DeviceConfig,
+    DeviceConfigInner, //
+};
+use core::str::FromStr;
+use kernel::{
+    fmt::{
+        self,
+        Write, //
+    },
+    page::PAGE_SIZE,
+    prelude::*,
+};
+
+pub(crate) fn show_field<T: fmt::Display>(value: T, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
+    let mut writer = kernel::str::Formatter::new(page);
+    writer.write_fmt(fmt!("{}\n", value))?;
+    Ok(writer.bytes_written())
+}
+
+// The lock guard is passed to `store_fn` so the powered check and the
+// store happen atomically. Releasing the lock between the two would
+// allow another writer to power the device on in the gap.
+pub(crate) fn store_with_power_check<F>(this: &DeviceConfig, page: &[u8], store_fn: F) -> Result
+where
+    F: FnOnce(&mut DeviceConfigInner, &[u8]) -> Result,
+{
+    let mut guard = this.data.lock();
+    if guard.powered {
+        return Err(EBUSY);
+    }
+    store_fn(&mut guard, page)
+}
+
+pub(crate) fn store_number_with_power_check<F, T>(
+    this: &DeviceConfig,
+    page: &[u8],
+    store_fn: F,
+) -> Result
+where
+    F: FnOnce(&mut DeviceConfigInner, T) -> Result,
+    T: FromStr,
+{
+    let text = core::str::from_utf8(page)?.trim();
+    let value = text.parse::<T>().map_err(|_| EINVAL)?;
+
+    let mut guard = this.data.lock();
+    if guard.powered {
+        return Err(EBUSY);
+    }
+
+    store_fn(&mut guard, value)
+}
+
+macro_rules! configfs_attribute {
+    (
+        $type:ty,
+        $id:literal,
+        show: |$show_this:ident, $show_page:ident| $show_block:expr,
+        store: |$store_this:ident, $store_page:ident| $store_block:expr
+        $(,)?
+    ) => {
+        #[vtable]
+        impl configfs::AttributeOperations<$id> for $type {
+            type Data = $type;
+
+            fn show($show_this: &$type, $show_page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
+                $show_block
+            }
+
+            fn store($store_this: &$type, $store_page: &[u8]) -> Result {
+                $store_block
+            }
+        }
+    };
+}
+pub(crate) use configfs_attribute;
+
+// Specialized macro for simple boolean fields that just store kstrtobool_bytes result.
+macro_rules! configfs_simple_bool_field {
+    ($type:ty, $id:literal, $field:ident) => {
+        crate::configfs::macros::configfs_attribute!($type, $id,
+            show: |this, page| crate::configfs::macros::show_field(this.data.lock().$field, page),
+            store: |this, page|
+              crate::configfs::macros::store_with_power_check(this, page, |data, page| {
+                data.$field = kstrtobool_bytes(page)?;
+                Ok(())
+            })
+        );
+    };
+}
+pub(crate) use configfs_simple_bool_field;
+
+// Specialized macro for simple numeric fields that just parse and assign
+macro_rules! configfs_simple_field {
+    // Simple direct assignment
+    ($type:ty, $id:literal, $field:ident, $field_type:ty) => {
+        crate::configfs::macros::configfs_attribute!($type, $id,
+            show: |this, page| crate::configfs::macros::show_field(this.data.lock().$field, page),
+            store: |this, page| crate::configfs::macros::store_number_with_power_check(
+                this,
+                page,
+                |data, value: $field_type| {
+                    data.$field = value;
+                    Ok(())
+                }
+            )
+        );
+    };
+    // With infallible conversion expression (direct value)
+    ($type:ty, $id:literal, $field:ident, $field_type:ty, into $convert:expr) => {
+        crate::configfs::macros::configfs_attribute!($type, $id,
+            show: |this, page|
+                crate::configfs::macros::show_field(this.data.lock().$field, page),
+            store: |this, page| crate::configfs::macros::store_number_with_power_check(
+                this,
+                page,
+                |data, value: $field_type| {
+                    data.$field = $convert(value);
+                    Ok(())
+                }
+            )
+        );
+    };
+    // With check, no conversion
+    ($type:ty, $id:literal, $field:ident, $field_type:ty, check $check:expr) => {
+        crate::configfs::macros::configfs_attribute!($type, $id,
+            show: |this, page| crate::configfs::macros::show_field(this.data.lock().$field, page),
+            store: |this, page| crate::configfs::macros::store_number_with_power_check(
+                this,
+                page,
+                |data, value: $field_type| {
+                    $check(value)?;
+                    data.$field = value;
+                    Ok(())
+                }
+            )
+        );
+    };
+}
+pub(crate) use configfs_simple_field;

-- 
2.51.2



