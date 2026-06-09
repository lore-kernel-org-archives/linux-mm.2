Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6466ECD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C822A6B0005; Tue,  9 Jun 2026 15:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58F66B0093; Tue,  9 Jun 2026 15:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6FC96B0095; Tue,  9 Jun 2026 15:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4C326B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:10:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45A0912079A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:48 +0000 (UTC)
X-FDA: 84861316176.13.5E500CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 656C24000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dz4cqmJl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViEAmKmawxcF7N2WCFkvitTjmdUVh88IGEYKrsZa4rs=;
	b=GvCGh8O0G6Y2fOWpJyx5QWk5lRJjWo0eW/4Q5ES2FeXvaPq12F4pzkmugABbtkO/0Hn5I1
	PpfbLsyoypNX/iDCSDniTjiMPA4L4UczPUpSnYMxUTvDUMvaCT1d/50oPAtF7uqE0ffYR9
	ncKa9cTS58CbXO1AAZMScFXd6sQYXYQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dz4cqmJl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032246;
	b=G0A3AruUf038mhhj+qtYGoX3qow3qN4vckVZjNFEtCx7zjidXLed8aNC2iHsFkziorjuRJ
	3EHHEKH4Is0LmXeGL2yQODMfl3zA7dhq0sGiRakdTvPMK3IFLJj45zYaar9WTf2+Su8LE/
	vOFCbxzrysCeZFwvCANRRyRbhW3/hBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3CA9602D3;
	Tue,  9 Jun 2026 19:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7DC1F00893;
	Tue,  9 Jun 2026 19:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032245;
	bh=ViEAmKmawxcF7N2WCFkvitTjmdUVh88IGEYKrsZa4rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dz4cqmJlGK6zP1GJh8CiPq58n1tvdzDUWuVqpvqJF83oQPnB2lhpcMK1Re1PTMp8n
	 W+Tfe9M9q/+WpSZE0J8Zsw1M4i+EXly/2tqH4GDRNUz30ZxVUImUfW9qiTCD4F66tp
	 VHldJTtRunXv1ARJB8J8gXzUQy3k9u9Rx5CucVgt1SFADAh+8w3WIxebdYeGLLtdAW
	 W7Ta8dhN1wz1x2ZIexM54QH9ifybplFHKE49uDjQ+q9EoBv+vK2xXmUsN07JCGcL5x
	 NzH7/G/zrmcJPXemmxdQSdviLFCysSDnKAUvwi8Ol/fllT+LHQ5Qv9omDYKQVFrJq3
	 RSU0pk3Bt/xrw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:59 +0200
Subject: [PATCH v2 20/83] block: rnull: allow specifying the home numa node
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-20-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4728; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=bVLUGu7Yg0gIIoubIKQz4YBEP/nNvOd82422m1mRrnQ=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTGbf6fmgZgdL2qiDikI8Dlf9jeRNjBJ2UPJ
 UzTC72Je16JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkxgAKCRD6UCkIqsW9
 0J1rD/9EI6gaU8QWYs3K+I+msNoR8AihBwE6+XAin0W8lX+Fh2dpKy2KgPS0aDv3XhPrVQVApMc
 CeW3HxCugLxc42a0yRckCX8VLxWGm873dyJdDq/N06Vy0wQf65U22ubt9BKzjMPs6bjHguDd8mK
 IJAVG3SlTVU/RnsCOnJitaVqi3BIc07MzbXdbX956GIIdaAsD0/KjUqTGWIoU9VXJFUWavG+uG1
 fkfGJGCPH54b0WBCgOvrV1lzVfERmYGQ7I//4z0ZUBp17Iq0SgXwSpqLAm7iI91F2kx63LT6X7O
 51Mr2gtaIcmO433FOh082r47ymS63Xwh802eJimAyOL2pwbZHA11DTjSq587JCN4DTHkUU1AwZM
 DLpL5Yrr6BQz7JkRAKdqpmLxip4JGZczzaCc7W/lV6/e5aTl+KsWdPKR3tRmryh7Ify+/lo2pK0
 /hd1dUgVc7GzOehIvxoMETyGagOW2cpc1bkID57Rk5XFpeZSi2L/aM/z8WzWreDE3H3G44vTQpi
 uFStrF7v5ihgAR2f+DHyTP7DgFBuCqKl9Aa+pAj+HUjFFEOaA0PwY+oNxWt3ABrfLmCOW8MCq/P
 Y5Rx3N+9hGz8fsnacW0kRXPdvnlqrZ00rz8LAZtPwaJTpn3F6xc1Itomhod5p307PhVOPXPUR21
 OmL/ScaWsC86CUg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 656C24000E
X-Rspam-User: 
X-Stat-Signature: s1xggywbp544eu14pbykbgzh3g1iaz9u
X-Rspamd-Server: rspam09
X-HE-Tag: 1781032246-279567
X-HE-Meta: U2FsdGVkX189dpQOGXPw9M5sGF0O+xzPRbfmcCCNOoU3ou3xRWA3r6w/PRazR0cLUaI/ICiCNDRNmOPur657p9D+F0RpfqH3SScHE9147yQgrwNmbZ94tpqCkK+UBeSAA40OlzuwO3tLsBpD+nq3LLfSTlBkEu4xcRCJZGIl51iv/Fg6IHyEZe//EwXmXUFLnt+By4/YDcW0/z6y+Ys1J3dZ2IncFPEQ37XSrK+SWchKMQ0nX7BNfQ1SzEiRVglH/aGQrYMYX6Go1LRkE8Lu3jfyLi6s4I9yLS6GfD6JaOwE1sSuqMOhRMO04wZK+RnHUiR1xuhs8YQkzQSu7VCuGepTowKuiOZLw1xn/PxM7V78ncKP6XDKJq48cKkDkZYd/3J1oR/+jKzNfOwU4D7r95vqf6XB9UA/qrVFIoJOjpHfopMKFxbuJIsrTm+vNSBesBHmaLRRdNB/s8+iGdKQeTIE7xB8EcKOjuQa37ydUdzC23s8C8xVZTMJw4H7cgadTAxwdMrA01XkMplFZLbE9Jmz7Bc29R33isZZeytpdHuE0tqseBg/aCVTHKdgDEEZ1imkXycKP6NCJuzTJKLvmTp9eOh6gyAj0u2BYHwAWDhyriKzsBbGtDZMeuzXVRp9djIVDwd1xbxMJGlxhOhoCX6jh1AhNAoEQ2MfYI9R1lJ6d64i2aw13e/f7isJncnCgyC+7MYReqfRecZq6DnYqOACFTh4fPRuJlsQlP/wL2tAyaNlOvqIM9FcBen+Rq4MEeTUPfe30mOO3Xk0PpJQLV2qaQWQJZgAGEntumGz55kKfCq8c1jIjizXJwWbZGYuO5BfUw303nijPDSlcDdvRS+iHvwbYCHkUmP/IEW6LukYdFazRB53Bgug1UKTY00Elx5qfL/98uAR2j9KuCZ2fA2JycqOmAEVYrxBpXZQpR6JlGHud2f/XcNqzQr9Q3FNTkr/+rb2xtrCWfEdJyN
 rTP4VX65
 TJ6vBqO59/VYkAo5TFu0Uy3VpRkPftBFTdriDixXQ0LQoeBi5PDrRbW2ZFjqXXc30PHnIptm60J4hIgxmSIDM7MUpHN8Z5WCjSf2/bh2RFk8T20jguujV08gZLjhVWf6RAuJoSYffLLw//BJPtGJnfKkUaxmu8+R81geKkPci+jqPLYmKv5t+4Ravb310HMO8BXpWYJ1BefTRsVsKN6PrsYZr5JiSXm6x1w2Agwf92rDJGNfgdxP13vIgToBaH777fl/O1/cbBHcM2PkkzxAP+gn1KfNd+vywsLZlSpGdBUN66E4RkqudIOWDk1tqSjdNbxhZ
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
 drivers/block/rnull/rnull.rs    | 30 ++++++++++++++++++++++--------
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 71b38373be33..2f3fa81ea121 100644
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
@@ -91,6 +92,7 @@ fn make_group(
                 memory_backed: 6,
                 submit_queues: 7,
                 use_per_node_hctx: 8,
+                home_node: 9,
             ],
         };
 
@@ -110,6 +112,7 @@ fn make_group(
                     name: name.try_into()?,
                     memory_backed: false,
                     submit_queues: 1,
+                    home_node: bindings::NUMA_NO_NODE,
                 }),
             }),
             core::iter::empty(),
@@ -176,6 +179,7 @@ struct DeviceConfigInner {
     disk: Option<GenDisk<NullBlkDevice>>,
     memory_backed: bool,
     submit_queues: u32,
+    home_node: i32,
 }
 
 #[vtable]
@@ -208,6 +212,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 completion_time: guard.completion_time,
                 memory_backed: guard.memory_backed,
                 submit_queues: guard.submit_queues,
+                home_node: guard.home_node,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -288,3 +293,17 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     })
 );
+
+configfs_simple_field!(
+    DeviceConfig,
+    9,
+    home_node,
+    i32,
+    check(|value| {
+        if value == 0 || value >= kernel::numa::num_online_nodes().try_into()? {
+            Err(kernel::error::code::EINVAL)
+        } else {
+            Ok(())
+        }
+    })
+);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 6323327d4a5a..1d0faf524f5c 100644
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
     memalloc_scope,
     new_mutex,
     new_xarray,
@@ -93,6 +96,10 @@
             default: false,
             description: "Use per-node allocation for hardware context queues.",
         },
+        home_node: i32 {
+            default: -1,
+            description: "Home node for the device. Default: -1 (no node)",
+        },
     },
 }
 
@@ -129,6 +136,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     completion_time: Delta::from_nanos(completion_time),
                     memory_backed: module_parameters::memory_backed.value(),
                     submit_queues,
+                    home_node: module_parameters::home_node.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -152,6 +160,7 @@ struct NullBlkOptions<'a> {
     completion_time: Delta,
     memory_backed: bool,
     submit_queues: u32,
+    home_node: i32,
 }
 struct NullBlkDevice;
 
@@ -166,6 +175,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             completion_time,
             memory_backed,
             submit_queues,
+            home_node,
         } = options;
 
         let flags = if memory_backed {
@@ -174,14 +184,18 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             mq::tag_set::Flags::default()
         };
 
+        if home_node > kernel::numa::num_online_nodes().try_into()? {
+            return Err(code::EINVAL);
+        }
+
+        let numa_node = if home_node == -1 {
+            kernel::alloc::NumaNode::NO_NODE
+        } else {
+            kernel::alloc::NumaNode::new(home_node)?
+        };
+
         let tagset = Arc::pin_init(
-            TagSet::new(
-                submit_queues,
-                256,
-                1,
-                kernel::alloc::NumaNode::NO_NODE,
-                flags,
-            ),
+            TagSet::new(submit_queues, 256, 1, numa_node, flags),
             GFP_KERNEL,
         )?;
 

-- 
2.51.2



