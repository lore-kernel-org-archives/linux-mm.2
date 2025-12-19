Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5AAD767CB
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 10:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270186B0088; Fri, 19 Dec 2025 05:51:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2142C6B0089; Fri, 19 Dec 2025 05:51:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2406B008A; Fri, 19 Dec 2025 05:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDB396B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:51:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6863D132A3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:51:06 +0000 (UTC)
X-FDA: 84235903332.30.0BDF28F
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5D8334000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:51:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d7yGJY2F;
	spf=pass (imf07.hostedemail.com: domain of 3Fi5FaQkKCNc3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3Fi5FaQkKCNc3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766141464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SFDmnD/AtD5C3m0av9uWzqAF9ygVuagC6pCqVMqHXtk=;
	b=UoL/FxXUfh3ejnFAQf/gL93JMOOy84UPAri7eLembLU3r1YrmlkjnGCKvmx9nECzBMS95Q
	JzBtYat8L5ViaKiAbtknwARHRzyExZltaxwR0ViS081u/nOBcM/aOsvUyaZAqvX0cWf1ke
	bY1hX5bskPbSOij+y8+MeU7AZFo+yvM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d7yGJY2F;
	spf=pass (imf07.hostedemail.com: domain of 3Fi5FaQkKCNc3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3Fi5FaQkKCNc3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766141464; a=rsa-sha256;
	cv=none;
	b=tMX+2joAPEgGBH+rfLfiIwjxEZ7q85aswShUsEAxLrwWYfScirs3uYo4W7oE6KWtMQFZPT
	wUHwvzeuTGwYdBOC/k3ZyP74w2lpvN3lCRZ9r/NJDpxxGmi84S6EY3d2tKtn06SpDxfh7b
	A1AiQ3hjbisIcFZGJxZx/af80aItFg8=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64b8dab21easo891958a12.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766141463; x=1766746263; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SFDmnD/AtD5C3m0av9uWzqAF9ygVuagC6pCqVMqHXtk=;
        b=d7yGJY2FU+dAV/xxav2WORHzTkHvC+0RMM+YHciJrdJ4w2e26h+Xs85Pf7CcT/AdJj
         hyo6gerKiE6lwVCrLZTjsKtwTMO65HT/fVxKiO3Lc2+hmy+vnT08VPl3LS13IUziTaOa
         OeDXvVx3vTDe3Xm5pFBPfZxyOw7sPQaWa7yWyw/uUqvvUOVIyO0u+tkW0AWefhPo+XTj
         R9CWegCaxxYGI8OYGyFb5jBdfZEDIwqKBU76u3aMSorj5j8e6DjHZNMEd+vcogR4OmUx
         qRh78QyoOR1S4IMzwpxMIDVEDArvQJ0Hb86O3idrkizwoqxlww6/CovpVMTvOxlDAuoV
         2hNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766141463; x=1766746263;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SFDmnD/AtD5C3m0av9uWzqAF9ygVuagC6pCqVMqHXtk=;
        b=UveeLJOfZBRYAUgE6yYmrAB6k0nGpDwr1Cc3424GW81uvSz96oP2hX/68x2Vg1VNPT
         xWXereAd6YpvQiU1crLOF2FmhpHuYfAPeXvRESy+wH9/V92c9Jsyz4FdB64PXKA9oZ5k
         sWdgT0pIE5E8Aqc2YEcL8R2e/P0fRCZu3UZyJiTbdz3366s3qawuL20ZmTTnfu+HyVRj
         G+xeRgpoDoQ17ok71AIFrDbgHxSBirYZSyaBPsPekoK01tyX+X33X4goPJH/pjujKqW8
         uE1BQU1qkA+GBICYkmFhUh7A4dE4WHiduRAbbgSSX6PE1BTcutKw22boqkHIxKu1Trlj
         RSeA==
X-Forwarded-Encrypted: i=1; AJvYcCU1jKCadfkdzKcG2XXa3Qn+2EQe66DENlvYBzxcorBeZGq9EFsHbyXXL/DACtlIoQrdyNlBGp1MKA==@kvack.org
X-Gm-Message-State: AOJu0Yx85cY/SGtySHvkyd6VuVDeMZ0GZRX/d1XNkPNYu9x9w1lBYxV/
	rVDMgpr5v88QJAPTPwAVDSCWKf7a8DKiAbZBL51q9UUz7WAorzumRJzxGafmk0FMLGwY1SpcEfU
	q2EO8MRRcTz5yJiDNcw==
X-Google-Smtp-Source: AGHT+IFsvIMhYISekbniT1OSzrzjnmd5mPLV8E2NfHuR2lYU97/cV3bhT6AtyekwFUIJjn5ib19avNkmSSr8epA=
X-Received: from edrz22.prod.google.com ([2002:aa7:c656:0:b0:64b:7f74:4879])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:518b:b0:64b:a1e6:8017 with SMTP id 4fb4d7f45d1cf-64ba1e68459mr975873a12.27.1766141462593;
 Fri, 19 Dec 2025 02:51:02 -0800 (PST)
Date: Fri, 19 Dec 2025 10:50:52 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAsuRWkC/02Oyw6DIBBFf8XMuhjAR6qr/kfjAnBEEhULlLQx/
 nupdtHZncmdc2cDj86ghzbbwGE03tglQXnJQI1i0UhMnxg45RVLQ4wlqw5CTkgGpFfOZYmy7yE
 drA4H8zpk9+5kh49ncoZzCVJ4JMrOswltFuucNcQpBt/waHyw7n08Eosj/evk/52xIIxIShXHW jYVEzdtrZ4wT1bo9n3/ALIK0x7SAAAA
X-Change-Id: 20251111-io-pgtable-fe0822b4ebdd
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=13538; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=uJYCNjJzEYtBk/2iSJnBj1R9WDR2GzMN4fV/t+4RXcY=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpRS4RncHCV4nyS//y4EAx+bwRMSgTWZLk3H0zY
 of/WRAd/OWJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaUUuEQAKCRAEWL7uWMY5
 RtMKEAC6EBqe0yNbvKxSik8ZGeRpxMHrK4icFxX/DE/flKsK+rF6gcXEMnGCo4DJ8Me8RcHPdzn
 KD6njKVO9AB9ewjx/iC9dPVJkKAwrYJloVv6DbBcBFULOfxuyafoPXV5nFlSoDo4D/pVRVEoZiU
 Hl0NGVLsYEvOgQ9ifWdNqXF31WtvQ5mMFzK7qpA86xYRKFkH6TEZkxGk7Vb10wHj2ahbjBsK1Y8
 JWpLgu9/Hx1IRttjhBjHqNvnnktOVwyzuLr2VLQ1UA6SXqoOu1vfEThdH/vvlLIvOR6a6h0jH6K
 breiZA2kdB0+1A8uzQFqJAqfC6wksrgjsHqRUQmRspta5WjKEENBuoB/1jwBP7y6t6ovgQcrJqS
 RlLYbLKKCOaqvuLKbHV2hD5qbvlA14sQAXLilTeZl73v4gbLcxBxTZHbC2tkcFWB3lscqFz5i/H
 1iGviEq/qenzMz88SSDev8C12/UhQ4IayJRWI+r41hS288PtA6ch2Dwk3Q8OvjxsnZjYNgOqRBr
 +1fkIINIVU4a0jETQhEBAn2zAHP667lHUAXkqIBXzXMNpMLd1bdtHeRXHmNlqUFJIzxDwCx5twL
 NebLAoc93N0D+PlrUap4jNl1LndvIU1aO02vNu9+bfGf8FACSs5IgtNbzzrLBDn1eB3DU1ZmSwh gpc9YvUiqVHMuVQ==
X-Mailer: b4 0.14.2
Message-ID: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
Subject: [PATCH v4] io: add io_pgtable abstraction
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Robin Murphy <robin.murphy@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D8334000B
X-Stat-Signature: r84b9g8ys6kdu4jbu8qfxjp5hznonrp6
X-HE-Tag: 1766141464-400098
X-HE-Meta: U2FsdGVkX18E9z+3OOEs9TQXwZcG/SzMHxCTV/pZRrFC4YX3WoXP7Pn2XRxpTs5/rbngF+vNKvEZ3fZwUqP0zkxciH9Vg4A00wTbwmUTRvMposRk736GGHRo5u1svC2Q2e6LFdMDgX0W5mRnOpm1of8KnrQ/JSovJgO8T1ItMj+vKyW/U39TeWKKwM1QbAVm7qI7cQgJbx8nauUUKUB/PoUcf68wGFda4n5SvjJxSkyKlCjIJXVNpicWnZBJ6INSxHIgIETsGaxgKS86NSq9v90ZY0eWf0fY2W3o+FMIcYhle6WjIVvQ8H+FuHNEdqodDLdCQW/bOWaNI6t2yf+WLUBz34+BXD1j27umUdsfuw7yXGpcSWm9IHURedoZcqjSy80G5nvteQv/BOdaYNIrNcyA2M4F0RKlFi16Rcs9RSwzDsp2Hlu7KBzuruOc/+zvsHoTh4ar0VxEGSPJDhfHdvXSOryQ5kkXDKtbPr5E+Qvfchc0b5gbAyn7CP+xj8Z5BKPuXZQ1zeToL5KRbQoBHKpJvZDoNltffIEtJhWfr8AiUmhW3Irflvfyo90bLEW+ArVas5GT8CQ20BsYCJ/OtemkZM+QqXbArzsyigg8duUmHsc5xmXbXYQ71X4sTMbPfSrPzx9sgQQdcykvnJ1ta1zXnVFMN3rJFTTrJyYw1hhglFyoovu+PDAEBvOpcCc73gOHRtzQV2OElj9orGN7K0kOHlBiny60TDFECmfgDM6WK8es0Ni/tf1nu8GxIDXwDpydh+R6oWSh19GXtIufPIDYfYRvVdN/hzXFzNs5ovgjWMri49k7zNY7WPngy+una7EpWb2Lcq4qvUnMMPYDqjfvjNclTOsQ65QQ1irBLiMKMqYwW0mHBTbA/PSRwCAZY4KQliZ/ABuXIJbUgg2WCJMuu9o4FV+By1RU1lxcsv9f+LNZ4OYjIbeQlWBxc5EfT82wYoimH7g+aNxIswI
 Gg0xiUyd
 BeQDuvjCOoHHaXTdvHtrXZhbRNTBlDt0OtYlHpyx2mwNwepOLcZwxV0OmRHCxVmWfHh2gts98Afy4S41LT4mgYtIQtFhBSLjfLQhLiSX07ftccovSPzhUxEPZrGANsuE34CZFtC1Y0QXYOpEH3uhUY+TWAX8hgHPv8XGlKOS2N8vM1d9mH943+v026GHHSMb1Kdq4EIBeZ6/1sKZy5i/RC09E3xYOfIzURUm6ZO3mLI6sY6XU/WpcqJ6NQYNJJhzGUdHJszpLCnDwhTjdv7GADypUQ6ICQ2CL6qiPD5fPuCBmvU1svrLTHBaf41+toUoP4Hc14/Oitx3gZKi0kMSn/Ypox9TWO8HabLNGtGUdsNpGhazL4kTJNGYJDo8P1o7ZzekVy8pa9GjTBBBgJuVmkXiIsJmQl8jLaS2GSUzumsAFOzQOK5Ul3L1M1S1q8xr/fMOd0xodoVxSkSfADMjyo+nfEMMFrpyXk1BpE3mNhepgiuTucLgKnI5gY50ai6K57FShydIoCP1Uud1JgRp4dmkmIBGZ5xhM6okaf35TRUDhrHsomiBa6bSisPmIOgjR28CaSNOOwWm0CCYz/sM1h8egDviWwInOlGeQsocIqYDNMImZX+lqeX7h6pz5Mn+2XMOV2VUq5Mfhrg8ptZg7nsOVRxlniPRsswFoEb44eR1F19LUc/sgT4xvOlnX57iAInkPDsg+iZ2sonJ3o1bMMr2qhEu/Fl1icssJLvfcMSLErjPz1G/gDMmrHMJ+Gr1+3lIm3RZlY/9r3Erm/6HCrRnXdk7MvxU/fN7kAUL59dXlKEkTLSE+bXTt7EsBEtYOlNXdCSm9/Cy/RrFtsyZ0aDDUBUTVcBMgyzYUgiHzYMHzX/UHjqvLQTkOg/UKb/5NJQMIiaauSU26qra0VLk/0s7too/n+mZDIFkQ
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
Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Changes in v4:
- Rename prot::PRIV to prot::PRIVILEGED
- Adjust map_pages to return the length even on error.
- Explain return value in docs of map_pages and unmap_pages.
- Explain in map_pages that the caller must explicitly flush the TLB
  before accessing the resulting mapping.
- Add a safety requirement that access to a given range is required to
  be exclusive.
- Reword comment on NOOP_FLUSH_OPS.
- Rebase on v6.19-rc1 and pick up tags.
- Link to v3: https://lore.kernel.org/r/20251112-io-pgtable-v3-1-b00c2e6b951a@google.com

Changes in v3:
- Almost entirely rewritten from scratch.
- Link to v2: https://lore.kernel.org/all/20250623-io_pgtable-v2-1-fd72daac75f1@collabora.com/
---
 rust/bindings/bindings_helper.h |   3 +-
 rust/kernel/io.rs               |   1 +
 rust/kernel/io/pgtable.rs       | 278 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 281 insertions(+), 1 deletion(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index a067038b4b422b4256f4a2b75fe644d47e6e82c8..1b05a5e4cfb4780fdc27813d708a8f1a6a2d9913 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -56,9 +56,10 @@
 #include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/firmware.h>
-#include <linux/interrupt.h>
 #include <linux/fs.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/io-pgtable.h>
 #include <linux/ioport.h>
 #include <linux/jiffies.h>
 #include <linux/jump_label.h>
diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
index 98e8b84e68d11ef74b2026d8c3d847a127f4672d..88253158448cbf493ca200a87ef9ba958255e761 100644
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -10,6 +10,7 @@
 };
 
 pub mod mem;
+pub mod pgtable;
 pub mod poll;
 pub mod resource;
 
diff --git a/rust/kernel/io/pgtable.rs b/rust/kernel/io/pgtable.rs
new file mode 100644
index 0000000000000000000000000000000000000000..11096acfa41d45125e866876e41459a347e9afe6
--- /dev/null
+++ b/rust/kernel/io/pgtable.rs
@@ -0,0 +1,278 @@
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
+    pub const PRIVILEGED: u32 = bindings::IOMMU_PRIV;
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
+pub struct IoPageTable<F: IoPageTableFmt> {
+    ptr: NonNull<bindings::io_pgtable_ops>,
+    _marker: PhantomData<F>,
+}
+
+// SAFETY: `struct io_pgtable_ops` is not restricted to a single thread.
+unsafe impl<F: IoPageTableFmt> Send for IoPageTable<F> {}
+// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
+unsafe impl<F: IoPageTableFmt> Sync for IoPageTable<F> {}
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
+    /// Even if successful, this operation may not map the entire range. In that case, only a
+    /// prefix of the range is mapped, and the returned integer indicates its length in bytes. In
+    /// this case, the caller will usually call `map_pages` again for the remaining range.
+    ///
+    /// The returned [`Result`] indicates whether an error was encountered while mapping pages.
+    /// Note that this may return a non-zero length even if an error was encountered. The caller
+    /// will usually [unmap the relevant pages](Self::unmap_pages) on error.
+    ///
+    /// The caller must flush the TLB before using the pgtable to access the newly created mapping.
+    ///
+    /// # Safety
+    ///
+    /// * No other io-pgtable operation may access the range `iova .. iova+pgsize*pgcount` while
+    ///   this `map_pages` operation executes.
+    /// * This page table must not contain any mapping that overlaps with the mapping created by
+    ///   this call.
+    /// * If this page table is live, then the caller must ensure that it's okay to access the
+    ///   physical address being mapped for the duration in which it is mapped.
+    #[inline]
+    #[must_use]
+    pub unsafe fn map_pages(
+        &self,
+        iova: usize,
+        paddr: PhysAddr,
+        pgsize: usize,
+        pgcount: usize,
+        prot: u32,
+        flags: alloc::Flags,
+    ) -> (usize, Result) {
+        let mut mapped: usize = 0;
+
+        // SAFETY: The `map_pages` function in `io_pgtable_ops` is never null.
+        let map_pages = unsafe { (*self.raw_ops()).map_pages.unwrap_unchecked() };
+
+        // SAFETY: The safety requirements of this method are sufficient to call `map_pages`.
+        let ret = to_result(unsafe {
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
+        });
+
+        (mapped, ret)
+    }
+
+    /// Unmap a range of virtually contiguous pages of the same size.
+    ///
+    /// This may not unmap the entire range, and returns the length of the unmapped prefix in
+    /// bytes.
+    ///
+    /// # Safety
+    ///
+    /// * No other io-pgtable operation may access the range `iova .. iova+pgsize*pgcount` while
+    ///   this `unmap_pages` operation executes.
+    /// * This page table must contain one or more consecutive mappings starting at `iova` whose
+    ///   total size is `pgcount * pgsize`.
+    #[inline]
+    #[must_use]
+    pub unsafe fn unmap_pages(&self, iova: usize, pgsize: usize, pgcount: usize) -> usize {
+        // SAFETY: The `unmap_pages` function in `io_pgtable_ops` is never null.
+        let unmap_pages = unsafe { (*self.raw_ops()).unmap_pages.unwrap_unchecked() };
+
+        // SAFETY: The safety requirements of this method are sufficient to call `unmap_pages`.
+        unsafe { (unmap_pages)(self.raw_ops(), iova, pgsize, pgcount, core::ptr::null_mut()) }
+    }
+}
+
+// For now, we do not provide the ability to flush the TLB via the built-in callback mechanism.
+// Instead, the `map_pages` function requires the caller to explicitly flush the TLB before the
+// pgtable is used to access the newly created range.
+//
+// This is done because the initial user of this abstraction may perform many calls to `map_pages`
+// in a single batched operation, and wishes to only flush the TLB once after performing the entire
+// batch of mappings. These callbacks would flush too often for that use-case.
+//
+// Support for flushing the TLB in these callbacks may be added in the future.
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
+impl<F: IoPageTableFmt> Drop for IoPageTable<F> {
+    fn drop(&mut self) {
+        // SAFETY: The caller of `ttbr` promised that the page table is not live when this
+        // destructor runs.
+        unsafe { bindings::free_io_pgtable_ops(self.raw_ops()) };
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
base-commit: 3e7f562e20ee87a25e104ef4fce557d39d62fa85
change-id: 20251111-io-pgtable-fe0822b4ebdd

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


