Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68ED9E63F21
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8287C6B00B2; Sun, 15 Feb 2026 18:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7196B00B4; Sun, 15 Feb 2026 18:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E026B00B5; Sun, 15 Feb 2026 18:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with SMTP id 7EAC46B00B2
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:44:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C3A413C070
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:50 +0000 (UTC)
X-FDA: 84448321020.23.D06965C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77B89A0008
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0Xvw+Xb;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+N1Oir3FGnxMi3gAqRew65oSUNzy5rdijzBk34/ieIA=;
	b=07aYIk762G+zMUYSqbctSieasPtfNY4w1zTIBIxeRCY/DfnNDd8OKBHJ+BhTn2bMXOkfr4
	cTtHCpaCOGR2gs885QC+2eJMBvHT9gLYJ5AC6Z4qAe2QyQoHy5zZpZ7sBkVRLPcShIukb4
	/9kPTrML/4JClKPVvZTemekQt24B3DM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0Xvw+Xb;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199027; a=rsa-sha256;
	cv=none;
	b=KXKOPU7g1HYy7tgka8YxmpiamJ2XEA8of32pEs6PzqoUDipvEuZQGLKkEYKTrq+hVSUn3W
	AzksYriVZ7cVMbkZUcyjisf0E+V0m+vag2mAUqOvsjkaZmhoSMbAvFfcddypJ/jL0B2l37
	PfOoy/aFupQFLahIrREP5sKJ0fQNCbo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DDAA6013E;
	Sun, 15 Feb 2026 23:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD5BC4CEF7;
	Sun, 15 Feb 2026 23:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199026;
	bh=hyJWmGhHnYKgGumF3acRrYQ7yD9VZFPwyaRRW4uns7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=r0Xvw+Xbl4WyoIV0Fgvc4CnezN4AquFYJprwOMMZ4tW2FWDP8IEMP5IspVkvapRKr
	 eyQCXlRj9nuKYDdDqQr3EeH1EDajPMZ6uvg/8RHpfiYqBCE1AUpo51WkLT2mkQWzuf
	 8yAVDEjVXa5fUyolR1WoGZg95YCrxgWlLbnDCaI5uWYLA9l/ss7OYNKWrCggl1Bfxh
	 /2MC4rdaD8XO4sPI0pN414gUY+NUp0nhQwJPAaunICom5uRzXiXKtQa0eL2W0q5vxT
	 kJ8UlGWZDBAMe6iz/mIQmb//20aycZ9d1XVZvHVp5sNncJqa79a4o8+O28Mk8KfS6M
	 O2UdjgNGNAg5Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:04 +0100
Subject: [PATCH 17/79] block: rnull: allow specifying the home numa node
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-17-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4428; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=hyJWmGhHnYKgGumF3acRrYQ7yD9VZFPwyaRRW4uns7c=;
 b=kA0DAAoB4bgaPnkoY3cByyZiAGmSWCujcbaRtyQ+5c46GUtpYsZLNpV7VYMbAQXDEhY8owFWT
 okCMwQAAQoAHRYhBBLB+UdWv3wqFdbAEuG4Gj55KGN3BQJpklgrAAoJEOG4Gj55KGN3ydkQAInh
 m/4xDjaLWkap0qZVw4kdG+BQcpK/gQBOgCp5aQJ9g6jpMgw7xGymCSWaXegQ/45lRH69A69dmJ9
 YevW/afwAjaK0Gy8+719L2V0WxkeUUbqtPvQP0r6h+O7HwKOEXeBp4svcMpD78XGzcaixFcTM73
 +q3wrysM6xhIEIuFJxU4aPzz5XV6a0i4Am1u+LWbWUulfmD2VQzSH/qit7F7Al2Gh/xLWAaXsz7
 mbeJOcNYaEtkyMwGIuoAAwOjcikxVvUHrAGHDVKgXx1rY7xVSAsw+GdBe+/2qKgSKKxCmiLIVzM
 Qdj9jl32dxV7g7L+SGVXd/XxSziAAft+K4g/ZY9TIw1BGIl1SzTZH+oayKtrCtHyjV45KFZ+Mor
 3A1YvvKSQtwicHPmGYKsNR3neTKoLgAR9O8uHmNol4224yieRMP7lc8HkY6MNV4zI7b/UonXR6b
 WkRDZQmScebq/brfppkcJXOKGDu9tAWj9yp7JNC3fBMGFA6WmSxIXN+cF7/Qur2tofw7IKbsWuz
 EscfebPY9qQ/gPiYBQ21h0h/Wn0Tks5pLQ9TGjlsne3xZW9didm3pGauc/h3TFaEmIsjObi5vBT
 hlLepzDjKUpTaBBiRvm5KUtk7hxb4iqtjjqxihxO7H94YIe8K90FeU4QFctgIu785HWqX6gRMky
 2c514
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: zfrfah7q7y4o4ajqxhw1dxacwdhxhor1
X-Rspamd-Queue-Id: 77B89A0008
X-Rspam-User: 
X-HE-Tag: 1771199027-21302
X-HE-Meta: U2FsdGVkX1/eL3xsK5HY05aJq3sspikfQZ7AS19xgHGqG4eABVGN+orDhBFep6HMwTqYxbrvY6pnWi4zEfq08wEGrhPqfngetKodocZLloXCD6CaU3lt1iieDFsH9VKOSM2kaFC68J3g6M2vSb/JXIlXf6H14rJS5eK43sxZZOsAZvdi0wtFR9Onn1OTnDlmV/2RGgQtOivEOlPuQeShzv/wk3kCMLH3FNFYccUEBYs8e414oJ08CZPLZEYzYgK8UEe0XiHpAPoJMtfOkEmkuwYhuRQsL4rZU1CkoXHT2hPyNzkZ/Db/nUlh2wRBZj26yl/hPzo2RazKNu0EDx/sDn8SnaiIdQPEDTA3269jzi+jT/1XOCR3CAM4ImLk+i2aEo8Je1E3j63hQBFh/MEtszoayVNxyRKIUpNOI/897nAlZcn6W7swmNFRP0LmXe6t07nWIWwoi0V8KbXhIhs2ivm/b5Kbb3E6mD/HSRxI6xolIcwSgvltq0uRFtqeFDAwf3v9MQ7KUGFd9lXlW3P7jxSJLzeEnXfTsbdmX6kboIogbXIZ8TeofThdW0QGTFetio9ugPThfXWIr+Xr9JnMcTK2gI7BHYeXjB4CKu7yBl5qCq1jn6x1Kf7gpEnTDNXFNYBgiam40+X4ea5+eFZHQKVrl3n4T25y66wRKwYNVSDi0hySOXuWhMex3jqjA66sYyqwKuVOl9xFRIsLi9wo7PBckJTagN18fjj32zCyJhwmRI+dU5TqWkzFNFCbhrfDqaiDLOn1zqBWwbGNbIgBiYZL8I6jkH/4ZQGNQ9YhFhqxrp6Gq9X1NKByAbn+t8cS2hoL7usC+F2az6W9S8Ej2uieKzugnsgrJm2c5nTKXjtGb9QDhqyACnz2ptGQUPOdiTOL3GhOiTsV/TXxcjkiujP76dPyOy8rs4+AxlNk9fmDLD75S0/7fZ8v+uDtN/XipV9r8mboKoCx5CTUIG5
 aLkSOtiB
 xi7DqWuEnA6u1u9GR9BnQhgI5G/IKhS3FjUTrwnDtEySCwM2p7Alzd+9EgD2O8+7s8dwxehfp4zGiiH5+gDs7y9sD5mCJGKe9+d/Mu256ColxT2Qhnq4CNy5WPMC67LaGsQj+pcM/tgVhu9zrm5WEnvCvLQpGg+KA0GbBfmfJvr33tLZGWE7S/phWKLgf8c/4wQTt7a5L81bD1HIy2L6pT82EKZqworyYRsTPyD9MO2TjSiHG+hev9aIFCBYmC/2b9WLFGgcHttHWKvg2JHtEjLenTe5Zv821Ws2Wze7d1nBzDvtchW498BexBRDyFzzwtnti
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a configfs attribute to specify the NUMA node for rnull tag set
and CPU map allocations. This allows testing NUMA-aware block device
behavior and optimizing memory placement for specific hardware
configurations.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 19 +++++++++++++++++++
 drivers/block/rnull/rnull.rs    | 18 ++++++++++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index b05bfc23090c2..fe00617d2b679 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -5,6 +5,7 @@
     THIS_MODULE, //
 };
 use kernel::{
+    bindings,
     block::mq::gen_disk::{
         GenDisk,
         GenDiskBuilder, //
@@ -92,6 +93,7 @@ fn make_group(
                 memory_backed: 6,
                 submit_queues: 7,
                 use_per_node_hctx: 8,
+                home_node: 9,
             ],
         };
 
@@ -111,6 +113,7 @@ fn make_group(
                     name: name.try_into()?,
                     memory_backed: false,
                     submit_queues: 1,
+                    home_node: bindings::NUMA_NO_NODE,
                 }),
             }),
             core::iter::empty(),
@@ -167,6 +170,7 @@ struct DeviceConfigInner {
     disk: Option<GenDisk<NullBlkDevice>>,
     memory_backed: bool,
     submit_queues: u32,
+    home_node: i32,
 }
 
 #[vtable]
@@ -199,6 +203,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 completion_time: guard.completion_time,
                 memory_backed: guard.memory_backed,
                 submit_queues: guard.submit_queues,
+                home_node: guard.home_node,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -302,3 +307,17 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     })
 );
+
+configfs_simple_field!(
+    DeviceConfig,
+    9,
+    home_node,
+    i32,
+    check | value | {
+        if value == 0 || value >= kernel::num_online_nodes().try_into()? {
+            Err(kernel::error::code::EINVAL)
+        } else {
+            Ok(())
+        }
+    }
+);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 278f75d886fd9..fb3ce272d5bec 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -20,7 +20,10 @@
             TagSet, //
         },
     },
-    error::Result,
+    error::{
+        code,
+        Result, //
+    },
     new_mutex,
     new_xarray,
     page::SafePage,
@@ -95,6 +98,10 @@
             description:
         "Use per-node allocation for hardware context queues, 0-false, 1-true. Default: 0-false",
         },
+        home_node: i32 {
+            default: -1,
+            description: "Home node for the device. Default: -1 (no node)",
+        },
     },
 }
 
@@ -131,6 +138,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     completion_time: Delta::from_nanos(completion_time),
                     memory_backed: *module_parameters::memory_backed.value() != 0,
                     submit_queues,
+                    home_node: *module_parameters::home_node.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -154,6 +162,7 @@ struct NullBlkOptions<'a> {
     completion_time: Delta,
     memory_backed: bool,
     submit_queues: u32,
+    home_node: i32,
 }
 struct NullBlkDevice;
 
@@ -168,6 +177,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             completion_time,
             memory_backed,
             submit_queues,
+            home_node,
         } = options;
 
         let flags = if memory_backed {
@@ -176,8 +186,12 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             mq::tag_set::Flags::default()
         };
 
+        if home_node > kernel::num_online_nodes().try_into()? {
+            return Err(code::EINVAL);
+        }
+
         let tagset = Arc::pin_init(
-            TagSet::new(submit_queues, 256, 1, bindings::NUMA_NO_NODE, flags),
+            TagSet::new(submit_queues, 256, 1, home_node, flags),
             GFP_KERNEL,
         )?;
 

-- 
2.51.2



