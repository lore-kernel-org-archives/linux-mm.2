Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C62EACCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303808E001A; Wed, 12 Nov 2025 05:15:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB2B8E0002; Wed, 12 Nov 2025 05:15:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1BB8E001A; Wed, 12 Nov 2025 05:15:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 018288E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:15:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ACB411A043A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:15:12 +0000 (UTC)
X-FDA: 84101547264.02.B341F02
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id A41E840007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:15:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="crD/lrQy";
	spf=pass (imf11.hostedemail.com: domain of 3LF4UaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3LF4UaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762942510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=73I2FUGpROBWvvc1rEHs+Shl3zJLhmBgQPZT0bfkTyg=;
	b=i0uNFZqS68mIrEko7kxICNhTJ1gPVSRO6UVcSch1SFKrWDruoEDkDY+91HKheF7LrvL6Pt
	MQpenuh1AK2z5H2fFRBc6Oxud5Yca5vNlYdoncnnd2K0KeLLDlar90yQpGf4RgaVfpXHIl
	oJDXR8hBIrAsmlJa5xsSypAND01kmyQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="crD/lrQy";
	spf=pass (imf11.hostedemail.com: domain of 3LF4UaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3LF4UaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762942510; a=rsa-sha256;
	cv=none;
	b=k2MMj5n/AYq7hucerNOasg2IxKxcLSonN4Vuz+YDDzD42zLvUnOhbhOR7jzYnVNyaEr9Aa
	3XHTKqOVnNwAcAjxKB/uD+nnRd07rpTQuFOAYFdSoLT3yHJk+cWRQq4Mv9V89tZO8bDm1p
	kBbJWPNbQhfblG5m3QnwcXVjqk1XDgQ=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-641632b8825so730918a12.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762942509; x=1763547309; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=73I2FUGpROBWvvc1rEHs+Shl3zJLhmBgQPZT0bfkTyg=;
        b=crD/lrQydlvfxWCarI7/3VbyLY/ZxM3m/nfbH3BsM2Hfz4l6K/JLi2M9ZiYKOez9ea
         xGcGKfm7OzAmhx72lMLzZt+vMcvxsHoCp15FNbdiwgLHohjBZDRKVN3JRfvZ8vULjJin
         CnE9EdnlpQtXjWm6wM8V1B8KOp65w4qrsMy8Q4YszeebRWGe0O6HzfI8dMpUHvt/mygK
         4XKTKX9tOX36mtGIt0zFO62AC0SvM4H/QG1YOrs3PnUXEmkUnOUBu99lNVFY5Hj7jM4G
         H1RRQLUWhmRUJktiFJ8ijcLYj1K0jiOBfXW01MOkRhYKCbVHN2vgbJpzrRD10xxe6aTo
         i9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762942509; x=1763547309;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=73I2FUGpROBWvvc1rEHs+Shl3zJLhmBgQPZT0bfkTyg=;
        b=VL8L/BnYYKG9F+pCqlGLAaalZqFgtzDsWQfD8TEdci9Hy5UR9uQJCyDtKKSGpOkVl4
         kFQ5oOLC9JDjWBfcMabAtHs6XXrv7EzKAN4DjwCPQc3SpjXHvkDVF2mu6MLzPze1V0Kj
         6BUBqAEorJOOcM2RwAfHATFhHzTp2lZSLK1wixFlzQb0njS3zXODfVLhyvTKnnffcTCM
         MlBVgJgiwMYNZllo3xjJ89edmYKXTsMB94+mdCWn2QYtAujfEt8fdOn1xGz6WEPC/YEU
         sMD+mT37k7fqWSUPptl8MWwhlmLa9aP1Jm5ql+Ak3F4Uv0YhI+Ujq9J95mNWVmQMyxT1
         BRqw==
X-Forwarded-Encrypted: i=1; AJvYcCVqeZNR8VNWWWBeYK/pZKBI6sg5R+SS3+Su8T+wbJ8Ekeptkn0dm72259aAA9n+5fFOFNQB8Rj53w==@kvack.org
X-Gm-Message-State: AOJu0YxZGiI+uNLP3sL058Q6wsf/HXn4w9GGIOGZFh4THKgurm/r88VJ
	iJ/Y5dmPvYmDDf66nSJ77KizQxnfOLwhSm6Dwifgfc2oMQmXt20utMONH1tT/ngKrOFydj/bxCq
	mVHsuoD8EnQxSROS8GA==
X-Google-Smtp-Source: AGHT+IFqKjM6hhCMFPCGk+2Jpbz5Hm1iHGXFKauxgdFMLZ34a2nCz7aZdsSy/MowpmbykFK42/F+adtGbWZpHz8=
X-Received: from edg25.prod.google.com ([2002:a05:6402:23d9:b0:641:85b3:f437])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:26d1:b0:640:fa38:7e4a with SMTP id 4fb4d7f45d1cf-6431a49a8cemr2140719a12.8.1762942508817;
 Wed, 12 Nov 2025 02:15:08 -0800 (PST)
Date: Wed, 12 Nov 2025 10:15:00 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIACNeFGkC/0XMTQ6DIBCG4asQ1p1Gx/pTrtK4EBiVpAoFNDXGu
 5fWRWf3TvI9Ow/kDQUu2M49rSYYO6coLoyrsZsHAqNTc8ywzNOBseCG2MknQU9ZgyhvJLXmaeA
 89eb9wx7t2Z5eSzLj+fyTgp1gVoGnYBevCNy4BYibI019gErLor5jrfPyLlb8+rILBMpOk4mCr dU1b8Ar5O1xfACweRVgxwAAAA==
X-Change-Id: 20251111-io-pgtable-fe0822b4ebdd
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=12178; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=ZXrOBFdyf9TG39sXS6oqK5q38LX8QtvFEFyq+TKtdgQ=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpFF4nbVQ48kgpUcJKNVdzu9LCeXj0vRdE2I+Qv
 qo/Vy3hpOCJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaRReJwAKCRAEWL7uWMY5
 Ri6kEACJ1ErD1ff8rRfLJ/E1cEo3ogYuuSXdi9FVJi7KwZMw0ryDRadjy26jInquoxCCfu2qrS9
 P6iY4wBtKDX+vOHETQMKq8nOmDOhDOB0nEEEPsnPD6dMTE+fzf6AOgO9xbpgbH9ZyYZIxbJPOtu
 nNlG1p3mvjEbL56gmynSEyunQkDjE3oOPUC9w2nozhVlLQEG/8deuKcR0dk2tF1PNG+2GRRGTB9
 YgpwbCf8mWn/eIS7R1bUMzLHnLX10EbWTQVeG2MdPgMe/HzrUzmhnbFNSaRpmeiuUdYpqMwYdlN
 mXWPIVOB+qhqCR8rKwfOEBraN2N/xFGFqLpWUecNUPO5/8TgAM27a2fVJQchwqxdqVEQsIiiLrZ
 qYQ9WjW94fhJvg6SIPUmJGlA0YFZbGVFOnQhBb0x7+i2Q9HFjHisL5XcPBoTCia5oUkQLEUhTB/
 Y0BXqipcIUL79CmELu152HEAl3LqSN9Oc9brq7CYPgNs4HjA/HZO/qj1MLk3iEEBy2f8y7ZMGMR
 IshBN7Kox/QxntpwacoOYZZCcJ6ScKG8qMcsA8OQAjOhO0idBw8egPuWPKFcy7U+uOe1w5E/Nhp
 fA6Ca+tiJaUZQK8oyZerF33kS9pOps9AEY4gFHLdmGSvP32fRejNa/56LKZ7DbPtAyzqgvszjIr OFZWcZQaNThXsdQ==
X-Mailer: b4 0.14.2
Message-ID: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
Subject: [PATCH v3] io: add io_pgtable abstraction
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: A41E840007
X-Stat-Signature: c953mqbdtnknrukaj68pii9pjpcw3deg
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762942510-723575
X-HE-Meta: U2FsdGVkX1+yGK3NzwTsY8he93DKuebfZDQlT6YrrRdQovnGTIDEje5F9eeBmM4AvRpyq0onAaYC3dZwjx3kW38t8I+Om6DHnhKNnTj3ymimp16SvBqlOfXgpXF/Z3JexXrsak/MsbClnjb2n5rpTkdfE3IGXK7FEbmFXXbICyj4ODtOEJNChR/q6+M9rWpJVv824LM+reuCNG788NX9rK/yY3lMRqkSs3dXeBxXkP82Zi0nlMB96n21siQMZEeq/H3gZAZKlK9mps3Bzgy/2NU4b86rE825OGW7wNATIo/yjn+tWI++izdrTHFYhISso2ZXIjpmhD4H+d/d+O3uwk+1RL5T0VAg6+8D+DQQaDFRPek3T+xLZGUz34ZbUB0YnS89DDGHRjknttZq04QaA7fg92o33CdofePUxuvOSMjh3PAVmFQMNvz/KCoTV/+pfVBtjOhre1qGA0TSNtTFqmHDKy7f/4GyH0Pshthq2DO7bDx5gj4s3MHQGTzI8IqcbhuLUWMo5bTVmVmKg/b7uiuitm4rsK3k+z6DBoboj2RW86gnYM4F48OtvN+BR/k+G8mkEh4A7RNgk1IpAJYSRvFDEa77uCMD+9TSDHlUmHgZ1wq5UhSxAiHeccfnosNJc8GGNTINbngnNDoHQNTnjJNB1uMffiW2i7chl+mQe12/DxGiLuWyjo8E6Tu9DFrjL3R9D82KRZKre2qSb49onPj5THYvk52CWNa60Sixe/cWPT+9zMaPyVI2zHmJDsR+2zIqZbjK2bXO9UCXlJX1T9FgcyZImvknZhj3y01V1tYJk/v5n6eDcE+5n4ZFz1xi3PIXOC9DL3lCZcS275JnqpLReSwHk2nLtNUg2/i+8yfepOQt+P2Oj854Ouc3/c3jxsNJr9NUNvU2DEuoIEvBugNfm0VcZCDo2YufFiy0yf/hV5C6Q3bu1MoCqAXvm1AzrTcP3BW+FD4oj8rUeb1
 ggQj36ia
 ruclia/MoYgZqrh2NrpLVll7HFKBbWnS89WPRqnR4mm5lJCHooD+9BJn1SowCeUZk48OkWRxZ+HYgdGdO1gk+h6qicHHcpnvPZlzrXsdvYSRUd9/BgREuH9OuH+oZeULj+lfW43QFcbnqq7zRVCEJyGUMnz7MORiWvqs1uAwgNVahOs9WnaPBKCYyWI8bCyrv7iQLP1oiMQtlIcF0cTRRM9NMMk/p+gqM0ewuP0QZQEFV5LMsWsRB5i7YZSog+PRfL9GcX2bOXiOStzCq3AeKkPo1gAc82TurS40L7NPIoTSbqQGm+ZH4MqbOlhkvDdAGDgwWH30gam4a5sZPUuXI1DOup7/637PTGJWExFkvI5pEKqvVGny4iA5z703FsTIQ2Jfq25gOvyG1UlX8mu2dNxznS+YnxVCe6hK4XPfYCSMWywc29QjLB3YJqTyDiclxmK9GKeCKuCSM5JBmJ3JYADjGR3vJsisbR7s9SoSDumdjwXmwI6dJqby1d5HkrsLYzR0WT5ALml/vw7dKYoZJlyU1h08YMZ3LhcnBRY0+g43BHG5Py9A2NXILwwrHDJ5vqghedMAJrDIIXNdh4XZjPf0Y88OiCE7ZnKP0/LhGn5CVPKqM4ID407B+IeP3yx8DsPb3GM55K9uxK+we560myBapIZr2u4EQ3M+iewPRwAzL/5UUKuqh+oBMgz9N91uon+QubqecWSx+wUbH17mxNW8LQCnBhVioMlqxsGb3XWF1RggzrGmVxHggDdNKFn/7E5g94drzscTj7WhzAaEBEDIhsaT3wxNwRT9H/EeP8sz90TTu4qpkHjhqR1Zu1TIz6DNoU29lIhmjQmqadb1+821H6DqBa4iTWngIglxWuCMBKCLoFjhT3JybbjUDxnY0jYG9XD/aHctmxI1tXGe4THBp1Jhj24KjD1MWGqaMbALse3av1TXGNSNTUt1mLu7ewkS2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asahi Lina <lina+kernel@asahilina.net>

This will be used by the Tyr driver to create and modify the page table
of each address space on the GPU. Each time a mapping gets created or
removed by userspace, Tyr will call into GPUVM, which will figure out
which calls to map_pages and unmap_pages are required to map the data in
question in the page table so that the GPU may access those pages when
using that address space.

The Rust type wraps the struct using a raw pointer rather than the usual
Opaque+ARef approach because Opaque+ARef requires the target type to be
refcounted.

Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
Co-Developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
This patch is based on [1] but I have rewritten and simplified large
parts of it. The Asahi driver no longer uses the io-pgtable abstraction,
and Nova never planned to (since NVIDIA has its own separate memory).
Therefore, I have simplified these abstractions to fit the needs of the
Tyr GPU driver.

This series depends on the PhysAddr typedef [2].

[1]: https://lore.kernel.org/all/20250623-io_pgtable-v2-1-fd72daac75f1@collabora.com/
[2]: https://lore.kernel.org/all/20251112-resource-phys-typedefs-v2-0-538307384f82@google.com/
---
 rust/bindings/bindings_helper.h |   3 +-
 rust/kernel/io.rs               |   1 +
 rust/kernel/io/pgtable.rs       | 254 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 257 insertions(+), 1 deletion(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 2e43c66635a2c9f31bd99b9817bd2d6ab89fbcf2..faab6bc9463321c092a8bbcb6281175e490caccd 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -56,8 +56,9 @@
 #include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/firmware.h>
-#include <linux/interrupt.h>
 #include <linux/fs.h>
+#include <linux/interrupt.h>
+#include <linux/io-pgtable.h>
 #include <linux/ioport.h>
 #include <linux/jiffies.h>
 #include <linux/jump_label.h>
diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
index 56a435eb14e3a1ce72dd58b88cbf296041f1703e..5913e240d5a9814ceed52c6dc1a798e64158d567 100644
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -8,6 +8,7 @@
 use crate::{bindings, build_assert, ffi::c_void};
 
 pub mod mem;
+pub mod pgtable;
 pub mod poll;
 pub mod resource;
 
diff --git a/rust/kernel/io/pgtable.rs b/rust/kernel/io/pgtable.rs
new file mode 100644
index 0000000000000000000000000000000000000000..fe05bc1673f9a7741a887a3c9bbad866dd17a2b5
--- /dev/null
+++ b/rust/kernel/io/pgtable.rs
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! IOMMU page table management.
+//!
+//! C header: [`include/io-pgtable.h`](srctree/include/io-pgtable.h)
+
+use core::{
+    marker::PhantomData,
+    ptr::NonNull, //
+};
+
+use crate::{
+    alloc,
+    bindings,
+    device::{Bound, Device},
+    devres::Devres,
+    error::to_result,
+    io::PhysAddr,
+    prelude::*, //
+};
+
+use bindings::io_pgtable_fmt;
+
+/// Protection flags used with IOMMU mappings.
+pub mod prot {
+    /// Read access.
+    pub const READ: u32 = bindings::IOMMU_READ;
+    /// Write access.
+    pub const WRITE: u32 = bindings::IOMMU_WRITE;
+    /// Request cache coherency.
+    pub const CACHE: u32 = bindings::IOMMU_CACHE;
+    /// Request no-execute permission.
+    pub const NOEXEC: u32 = bindings::IOMMU_NOEXEC;
+    /// MMIO peripheral mapping.
+    pub const MMIO: u32 = bindings::IOMMU_MMIO;
+    /// Privileged mapping.
+    pub const PRIV: u32 = bindings::IOMMU_PRIV;
+}
+
+/// Represents a requested `io_pgtable` configuration.
+pub struct Config {
+    /// Quirk bitmask (type-specific).
+    pub quirks: usize,
+    /// Valid page sizes, as a bitmask of powers of two.
+    pub pgsize_bitmap: usize,
+    /// Input address space size in bits.
+    pub ias: u32,
+    /// Output address space size in bits.
+    pub oas: u32,
+    /// IOMMU uses coherent accesses for page table walks.
+    pub coherent_walk: bool,
+}
+
+/// An io page table using a specific format.
+///
+/// # Invariants
+///
+/// The pointer references a valid io page table.
+pub struct IoPageTable<F> {
+    ptr: NonNull<bindings::io_pgtable_ops>,
+    _marker: PhantomData<F>,
+}
+
+// SAFETY: `struct io_pgtable_ops` is not restricted to a single thread.
+unsafe impl<F> Send for IoPageTable<F> {}
+// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
+unsafe impl<F> Sync for IoPageTable<F> {}
+
+/// The format used by this page table.
+pub trait IoPageTableFmt: 'static {
+    /// The value representing this format.
+    const FORMAT: io_pgtable_fmt;
+}
+
+impl<F: IoPageTableFmt> IoPageTable<F> {
+    /// Create a new `IoPageTable` as a device resource.
+    #[inline]
+    pub fn new(
+        dev: &Device<Bound>,
+        config: Config,
+    ) -> impl PinInit<Devres<IoPageTable<F>>, Error> + '_ {
+        // SAFETY: Devres ensures that the value is dropped during device unbind.
+        Devres::new(dev, unsafe { Self::new_raw(dev, config) })
+    }
+
+    /// Create a new `IoPageTable`.
+    ///
+    /// # Safety
+    ///
+    /// If successful, then the returned value must be dropped before the device is unbound.
+    #[inline]
+    pub unsafe fn new_raw(dev: &Device<Bound>, config: Config) -> Result<IoPageTable<F>> {
+        let mut raw_cfg = bindings::io_pgtable_cfg {
+            quirks: config.quirks,
+            pgsize_bitmap: config.pgsize_bitmap,
+            ias: config.ias,
+            oas: config.oas,
+            coherent_walk: config.coherent_walk,
+            tlb: &raw const NOOP_FLUSH_OPS,
+            iommu_dev: dev.as_raw(),
+            // SAFETY: All zeroes is a valid value for `struct io_pgtable_cfg`.
+            ..unsafe { core::mem::zeroed() }
+        };
+
+        // SAFETY:
+        // * The raw_cfg pointer is valid for the duration of this call.
+        // * The provided `FLUSH_OPS` contains valid function pointers that accept a null pointer
+        //   as cookie.
+        // * The caller ensures that the io pgtable does not outlive the device.
+        let ops = unsafe {
+            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, core::ptr::null_mut())
+        };
+        // INVARIANT: We successfully created a valid page table.
+        Ok(IoPageTable {
+            ptr: NonNull::new(ops).ok_or(ENOMEM)?,
+            _marker: PhantomData,
+        })
+    }
+
+    /// Obtain a raw pointer to the underlying `struct io_pgtable_ops`.
+    #[inline]
+    pub fn raw_ops(&self) -> *mut bindings::io_pgtable_ops {
+        self.ptr.as_ptr()
+    }
+
+    /// Obtain a raw pointer to the underlying `struct io_pgtable`.
+    #[inline]
+    pub fn raw_pgtable(&self) -> *mut bindings::io_pgtable {
+        // SAFETY: The io_pgtable_ops of an io-pgtable is always the ops field of a io_pgtable.
+        unsafe { kernel::container_of!(self.raw_ops(), bindings::io_pgtable, ops) }
+    }
+
+    /// Obtain a raw pointer to the underlying `struct io_pgtable_cfg`.
+    #[inline]
+    pub fn raw_cfg(&self) -> *mut bindings::io_pgtable_cfg {
+        // SAFETY: The `raw_pgtable()` method returns a valid pointer.
+        unsafe { &raw mut (*self.raw_pgtable()).cfg }
+    }
+
+    /// Map a physically contiguous range of pages of the same size.
+    ///
+    /// # Safety
+    ///
+    /// * This page table must not contain any mapping that overlaps with the mapping created by
+    ///   this call.
+    /// * If this page table is live, then the caller must ensure that it's okay to access the
+    ///   physical address being mapped for the duration in which it is mapped.
+    #[inline]
+    pub unsafe fn map_pages(
+        &self,
+        iova: usize,
+        paddr: PhysAddr,
+        pgsize: usize,
+        pgcount: usize,
+        prot: u32,
+        flags: alloc::Flags,
+    ) -> Result<usize> {
+        let mut mapped: usize = 0;
+
+        // SAFETY: The `map_pages` function in `io_pgtable_ops` is never null.
+        let map_pages = unsafe { (*self.raw_ops()).map_pages.unwrap_unchecked() };
+
+        // SAFETY: The safety requirements of this method are sufficient to call `map_pages`.
+        to_result(unsafe {
+            (map_pages)(
+                self.raw_ops(),
+                iova,
+                paddr,
+                pgsize,
+                pgcount,
+                prot as i32,
+                flags.as_raw(),
+                &mut mapped,
+            )
+        })?;
+
+        Ok(mapped)
+    }
+
+    /// Unmap a range of virtually contiguous pages of the same size.
+    ///
+    /// # Safety
+    ///
+    /// This page table must contain a mapping at `iova` that consists of exactly `pgcount` pages
+    /// of size `pgsize`.
+    #[inline]
+    pub unsafe fn unmap_pages(&self, iova: usize, pgsize: usize, pgcount: usize) -> usize {
+        // SAFETY: The `unmap_pages` function in `io_pgtable_ops` is never null.
+        let unmap_pages = unsafe { (*self.raw_ops()).unmap_pages.unwrap_unchecked() };
+
+        // SAFETY: The safety requirements of this method are sufficient to call `unmap_pages`.
+        unsafe { (unmap_pages)(self.raw_ops(), iova, pgsize, pgcount, core::ptr::null_mut()) }
+    }
+}
+
+// These bindings are currently designed for use by GPU drivers, which use this page table together
+// with GPUVM. When using GPUVM, a single mapping operation may be translated into many operations
+// on the page table, and in that case you generally want to flush the TLB only once per GPUVM
+// operation. Thus, do not use these callbacks as they would flush more often than needed.
+static NOOP_FLUSH_OPS: bindings::iommu_flush_ops = bindings::iommu_flush_ops {
+    tlb_flush_all: Some(rust_tlb_flush_all_noop),
+    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
+    tlb_add_page: None,
+};
+
+#[no_mangle]
+extern "C" fn rust_tlb_flush_all_noop(_cookie: *mut core::ffi::c_void) {}
+
+#[no_mangle]
+extern "C" fn rust_tlb_flush_walk_noop(
+    _iova: usize,
+    _size: usize,
+    _granule: usize,
+    _cookie: *mut core::ffi::c_void,
+) {
+}
+
+impl<F> Drop for IoPageTable<F> {
+    fn drop(&mut self) {
+        // SAFETY: The caller of `ttbr` promised that the page table is not live when this
+        // destructor runs.
+        unsafe { bindings::free_io_pgtable_ops(self.0.ops) };
+    }
+}
+
+/// The `ARM_64_LPAE_S1` page table format.
+pub enum ARM64LPAES1 {}
+
+impl IoPageTableFmt for ARM64LPAES1 {
+    const FORMAT: io_pgtable_fmt = bindings::io_pgtable_fmt_ARM_64_LPAE_S1 as io_pgtable_fmt;
+}
+
+impl IoPageTable<ARM64LPAES1> {
+    /// Access the `ttbr` field of the configuration.
+    ///
+    /// This is the physical address of the page table, which may be passed to the device that
+    /// needs to use it.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that the device stops using the page table before dropping it.
+    #[inline]
+    pub unsafe fn ttbr(&self) -> u64 {
+        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for `ARM64LPAES1`.
+        unsafe { (*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.ttbr }
+    }
+
+    /// Access the `mair` field of the configuration.
+    #[inline]
+    pub fn mair(&self) -> u64 {
+        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for `ARM64LPAES1`.
+        unsafe { (*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.mair }
+    }
+}

---
base-commit: ffee675aceb9f44b0502a8bec912abb0c4f4af62
change-id: 20251111-io-pgtable-fe0822b4ebdd
prerequisite-change-id: 20251106-resource-phys-typedefs-6db37927d159:v2
prerequisite-patch-id: 350421d8dbaf3db51b1243d82077c5eb88f54db5
prerequisite-patch-id: ac0166fb3cd235de76841789173051191a4d2434
prerequisite-patch-id: f4bca02c77c40093690b66cdf477f928784bdbf4
prerequisite-patch-id: 083d1c22b1a7eb0dcae37052b926362543c68e8a

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


