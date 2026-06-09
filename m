Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0866ECD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705EC6B00BC; Tue,  9 Jun 2026 15:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD706B00BE; Tue,  9 Jun 2026 15:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3FC6B00BF; Tue,  9 Jun 2026 15:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1836B00BC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11103A0741
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:29 +0000 (UTC)
X-FDA: 84861320418.04.642894B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BBB814000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OCuQ//BL";
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hqK4pNL6S2JPG/y7ZeGzzjDNeUcKa36Uf2X4yV6K44=;
	b=XnDt5UGmaUoXlAdL2/YfQ1w1I/x8rJEt1+0CLfXvb/Q5xnu1he0B9rr5r2s8j/+m8FxPa7
	+IBzK0mwbMdOk8JWec5h50ktNMQrVhXXI3RBi98Nofs0oKGZP80JjuxUohSj7zf8a+3oFr
	h20bvGJpRPe9DFOd6RxPKYXLfhvelSE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032347;
	b=itxKgrOCt+eHBdIf+Z/DBRl8c7IIwnph/0mHc21L1rDBnORmM8F8kVV0vyHhoSbLXhZmGu
	IRzt8TXUR+3K1CBBVNZ23/NORBvPBkeMKqubvHMi5g5DXE37aQZdmUkE6e+KghC4S3u/+0
	/dQ7fbeGrOET4SxsutYRT9mWpxWJt8w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OCuQ//BL";
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FCD140286;
	Tue,  9 Jun 2026 19:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD2B1F00893;
	Tue,  9 Jun 2026 19:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032346;
	bh=3hqK4pNL6S2JPG/y7ZeGzzjDNeUcKa36Uf2X4yV6K44=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OCuQ//BLNvPCd7LUKo8DdrDPmpPEjSN9j54i865qFnGncdfHVKv/F835XUWzh5fmy
	 1JqGuqfN0CppEcDMWMOKkw6y5kScMLdiIu6c0TWVFWXh1zMNTmAWIc55NOsYCb+vaH
	 doQxW//kLze1PHhaTv32DdIJB9OTNJsV3VSELUTo4Rn/mVcD4nrDYWqyk2I/iKy8Wd
	 msbDktIdNVuE5R4eHhFgVlT4tfoSTIg5NcQ5Hl46AxYz6fWJsXTGuS9O9SHKbatsUB
	 /hZh+nP0fG2dcpB2BkxCTvQCgya+YTpvERbdLpOTXd0GsiM0SAatO9BdhX4vfMJS2G
	 A65ui9BiHP91g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:43 +0200
Subject: [PATCH v2 04/83] block: rnull: add module parameters
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-4-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3121; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=NlaHBwDAyKNiiMVG0I8yNPspfiq5/k+1/1/ufIcyrYs=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS4fPIeIol1rMY3VBolkA8u3anuZt9v8wBBi
 QcjjYrJYrOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkuAAKCRD6UCkIqsW9
 0HJ6D/4r6Srm+0SmXV4+YiMjaedQ8+3HXt5ttbJCmfe6w8sTEOmVS4RG3Ad9QUVLBtvt+SGICwl
 X40VacPNolbomVbsQJVcRJxX2TW6uuLVLT9l07xKio8sYaVcpPzDH+fwcFuGygsFCsH/O1j3OGh
 LrhgVvAG4wN3MIUXnb8lGwObPBrX1ep1DYt1UXSF6kjIyYxifSvvRQFvlbGBO9gSaoPbrPUJtuB
 g+zWGGFXFMp44VS22ZC5Go2OMIFtt4b4h+scV5r5d0c4pvf0/MermHK1kNeD9akvoL447uDrTn5
 AlBLrCDd3t70vrObkRGn6zzCT/SDFZPxlXOXT6HTDeGN+oOR0+LnR4pJzMJLg97b1ATobsnzINz
 BEwkx5fSncNaS8cHptLLk4+jPGES7hwmzSRE7G35rcoBMBOgYSi2lvAunsY0qFIZXe0wNYf+GaJ
 Azf0qrluNYhjkGZ7enOmevTOYJcHWM8N/sRH6/p8P30s+qbMus3yMKmVkxYYACBpdpZrzVQINmT
 9ksQpRsnzpJyABIgID+RNrNL4r++AWi6eevjw6K78gOrs31gbs7n55dUnATPUb+g9Bf026YXp9K
 qukh4y9TLviUUojh2BBgjMK1hm+T5LBsWEqf95Wr+on7CHJBLcBAwqokliJpr62JH+VR9XUyZyf
 6XZhZ0jatT97k9g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 3BBB814000F
X-Rspam-User: 
X-Stat-Signature: t5pgwmftdrdd1zu35hmxs779xt6wn8yh
X-Rspamd-Server: rspam08
X-HE-Tag: 1781032347-622960
X-HE-Meta: U2FsdGVkX18oNrGapDA/0OvxMZdFudblRILUSa0yi1xLyeHdztfaLE+mBBjzEH23fPBH88w6hgZOF/Q4ESR/mm3VEwCJMO/5aOUgr0P+50z2f2JHuOoIccFHeJX5+gQr8kkOhAJ1i06HdDXJQ5zwo57qxmnZv69ciO9kzQNr+yDISBqyPJ5t+OwU9AN8hvmNqF+Kojkm16D0ajCx69cE8pZ3qMvkpq1JrEHSH/qrY1h4QGQBPznjIBMAzIrK6fC43nsPwjREaDR2mt62jpZ2ps0ar3/3NlcgP11YiiVECbAmlRYFQoZIUPmkoIbH+EIVQKWSmwgjwscKcPPNQltqsGiHrDOg6Sx5TIPZ3RK6Af0i2eC/bIfzny9x6LVTiiGVQX9oamwzOGMtHQtrW+bu6YWuLRYuQr3leOolAW3chsIBu+YMfyQ3ykzxWVNl31URcisZ0nhmHYW6U94+nisRBKixw5VoECFIvFU8RrrCjBo27Ine/1c4Ceq4k6Azxbg6Qjjaaw/cRSAt0Onl5ljLSshufKdg4QOXHLzri2FZwEIc3t6ylxMF3328rsc6xKV6xRaa0LkF/MRicCsp0feDkUSyOP3Nib0pTvX0Eqlt/NjwkMiq0mBejwqZChlGY95iWBPTg1QeZG7JRCR7ZaqOqMYcIAb6IAvVtgap+gLbdf9m2kEqmDhXrL9ewEH+eL/gxhKSW1si9M3HCG99tl5xJK7YYCh2myZ7biuek8/uj1ycocwrCxT9vQhMTRDhegFKWeLdtSCGshHrTRv8fUEDl7GNHDOhkVsOvAXLvvHPbsVMrCPr/Z1uQUDjvxAucblo6K62VSCoN5HbsUjQGNSYWalksvpIZb1Ciu0hK6QU+I58mt20Zoh7TjWLs8denQjVa7TjAPutlR9Sm7d+YrUG9elW1zfCQhs2RT6ztODP8RIwUVVeEmNykV9gk62qS6zfozW1T57YPJTPHDVLI15
 hc8l8iBq
 ASz7mXJbH5PI5dlH0gaQUxkc3IBrm0TsW5wjJJr1dreQsbjs4ShDwovOM+nS0N5Qu0YrRAgO8aFEooHli1AsldDmOePoAL5gxW77vIer0sepFfkoxHD/7x6XAHbmqZ8EmB6H018kaUdVAdD1O1aBowPKr5qEpJR9SE5BcVPLoCE2sftt5QEt6ab4bUJZwHSvbe2K+ejuREIVSb5r1z7yclfPY9PUdgTxdW36sSNTtfzD+8RZBef26guyN0IpqLEVBcPoKAzT0V3+v5Kjdef1NouCowVbLim2qNOVzST6rgdJtmRm3q7XkyIiG006SSsQAvkx5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Module parameter support for Rust modules was merged a few releases back.
Add module parameter support to the rnull driver.

This allows the user to control the driver either via configfs or module
parameters, just like the C counterpart.

Please note that the rust module parameters do not support boolean values.
Flags that should have been booleans are parsed as integers and compared to
zero.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs | 50 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index d58d2c4c5f63..77ccc6850961 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -18,10 +18,14 @@
             TagSet, //
         },
     },
+    error::Result,
+    new_mutex, pr_info,
     prelude::*,
+    str::CString,
     sync::{
         aref::ARef,
-        Arc, //
+        Arc,
+        Mutex, //
     },
 };
 
@@ -31,20 +35,64 @@
     authors: ["Andreas Hindborg"],
     description: "Rust implementation of the C null block driver",
     license: "GPL v2",
+    params: {
+        gb: u64 {
+            default: 4,
+            description: "Device capacity in GiB",
+        },
+        rotational: bool {
+            default: false,
+            description: "Set the rotational feature for the device.",
+        },
+        bs: u32 {
+            default: 4096,
+            description: "Block size (in bytes)",
+        },
+        nr_devices: u64 {
+            default: 1,
+            description: "Number of devices to register",
+        },
+        irqmode: u8 {
+            default: 0,
+            description:  "IRQ completion handler. 0-none, 1-softirq",
+        },
+    },
 }
 
 #[pin_data]
 struct NullBlkModule {
     #[pin]
     configfs_subsystem: kernel::configfs::Subsystem<configfs::Config>,
+    #[pin]
+    param_disks: Mutex<KVec<GenDisk<NullBlkDevice>>>,
 }
 
 impl kernel::InPlaceModule for NullBlkModule {
     fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
         pr_info!("Rust null_blk loaded\n");
 
+        let mut disks = KVec::new();
+
+        let defer_init = move || -> Result<_, Error> {
+            for i in 0..module_parameters::nr_devices.value() {
+                let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
+
+                let disk = NullBlkDevice::new(
+                    &name,
+                    module_parameters::bs.value(),
+                    module_parameters::rotational.value(),
+                    module_parameters::gb.value() * 1024,
+                    module_parameters::irqmode.value().try_into()?,
+                )?;
+                disks.push(disk, GFP_KERNEL)?;
+            }
+
+            Ok(disks)
+        };
+
         try_pin_init!(Self {
             configfs_subsystem <- configfs::subsystem(),
+            param_disks <- new_mutex!(defer_init()?),
         })
     }
 }

-- 
2.51.2



