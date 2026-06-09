Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1708ACD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4206B00EB; Tue,  9 Jun 2026 15:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAF06B00ED; Tue,  9 Jun 2026 15:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0DA6B00EE; Tue,  9 Jun 2026 15:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5826B00EB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:14:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29CF31C3039
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:45 +0000 (UTC)
X-FDA: 84861326130.09.C000D3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C13C1C0008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m6F0lnJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yh/dWdgKvT0zkP6Uc7e51/m9fxvSh52AeREuWUz3HD0=;
	b=uG9jET5WnHtfT2+c5c/8GFjOs8K3vaQ1/9PzL41aNxOvo602AruieIVlq+ejT2V372fVnb
	3DazIeYa/g/G/KLwt8u3Z0FYd8IuXGinVAwXFCUONMwbvJO/cr0YhnHE0UgS49d/2/TID2
	r73MC/GiHVjiSuQp2mPcU0lTl9Jmc30=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m6F0lnJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032483;
	b=Tkn1jH4NwwMYcbMJB+AefOZcnpVt3p+Y/+iaiqjTBA+xQ5JUPaIWxGs+18Ho0jtk1qk0NR
	Y0FJQQn1Uj9f7iCgKJD6ruvOLOQY8S3Wu6WDAMyfhFbUEsqNvW81WR8BCilEvfOwMoRBAK
	5TVpa3xmQH9T6dcabUz2uzfAratwYkY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 004B9602D0;
	Tue,  9 Jun 2026 19:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EC61F00893;
	Tue,  9 Jun 2026 19:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032482;
	bh=yh/dWdgKvT0zkP6Uc7e51/m9fxvSh52AeREuWUz3HD0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m6F0lnJAGS/NLRHer47scYdfbR7jhR0fJPP8y9mzicldIup+EVOxTgoiHv3hOReei
	 iNCg0ypYBdJTCsIg5js6JoOQE0YWIezzBCRQM2w95OIieOipKY1xsA81zzAaTzH81Z
	 iJW1UEHtzD7v1ZHHjKK7py8KD9lHnDvUiNcGOJQVnUsCPdLqAWoCbjNbDBYcmMEcvC
	 Yy5rAilaH1QQM7iYFNfMZoTsRIld6dZXm5eNZv74k+fZmt+bV0hKPbpQ5bfVnbX+4L
	 /j+UVHQIR2nsWsMHO+F0slrgeSE5y0aOfn+bStGbRixytYc/7CudYimCUwlmIbI1gp
	 FVTSpmMZ6ZNWg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:26 +0200
Subject: [PATCH v2 47/83] block: rnull: add queue depth config option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-47-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4312; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=RiK2MFDfZueTIoC29KqxTo1erC5StZym/slB3abdziY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTfmemXeroNyNXumJBaGxIPH3vPurRUz3Bt/
 aFVV1AUQoiJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk3wAKCRD6UCkIqsW9
 0OVPEAC1vgGJz1ZISUXdjGr19xkHpGJq9tLAlpJ+QS1EMUsAC+PCYIi91hDyDYZIJ5Xi/ppekge
 4RvZDlVOQTvD8UzQMx14InQPciiuSo1izTTyv8VCBoaNLpL6/stmmZpRwqOoGDwZcAcftl9e01r
 oB157JRV7quK8BuYsE7TpkDqZpw0CP6tqrRG+iCCAdQ0/nwmIiHLQnQfJsqSl3+uz0KbzimP2fX
 txU7vr9Ua1zV9trOfeq9I6td5NXKxdiCHqf2UUMO3qNG8/d+E/lNFYxbPj+v7Z4v/+Mo0ih+uF0
 eL2C1Hdq2DngCceeMc/FytdwQcs9PUr9EF4bqOHdr0dyavntauC335TpOPjuWwP954JGl2nK8i3
 PE3kg1gIq9TDzIowvz7aN/a4n9PMCeMcyDPUKlf0M4yX/BsDSfUIjyXeEaP52idAmtxPFUb/JIw
 HeXak9dimV1Yp56H1JQ8c86LJq0XrhLiGZxQeIW/69R0UCy4HqP7PN+XwP2K4fk0ake1G4djGi1
 TWdTJaB/02NzQyC1ZFR2fkhVf2fVZf/x5hYLA25MEskOF5JVY4YerRa0x3iAV0l8BF94zYDDFQ1
 QWZgXeq1/j/N/wTiyHPJSNSfefCKl40g+4pCjN8n30UEHVvYVeG47NJwvrwn4v6Ag6nT5EjTpde
 cInJmkYZ4C2fsWw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ybr9wn3icot68jxwgoc8eg9is4z87ham
X-Rspamd-Queue-Id: 6C13C1C0008
X-HE-Tag: 1781032483-981410
X-HE-Meta: U2FsdGVkX193Yg/wjQt1JrCQv4A9ZO+tdP6PlzcYSnQ3+m4IiZHwB4qmdK6VtQ7NiTLVH4AZjbuG3E4nNAX2JLYbsfrmf7WpmMtUz3Em53G8GH8emnZ/B9ZHpCSR+r05M5rStzbab6wOU53PdWoytCsljuZBb3ZYFnD6E6o8r9V6RUzxePrBaNqu0TlHpbKRDOSQnJblCZyG4aMmjEJl/S0VfDrjoAg7vRx9rjT3m5gdR+mVV5Oc3PCSlCsNHK3YM/dN3oPdHmA3NXWi1zZMiTddR6Q8wUt5ZYIiWYHPzw7JIUqvZRI3jgZoUWM65IageMneBPbWdZw7/i+QIjqA5GCrHicxXQ+jd3r+ggLwYFXGBY705p5fr+LuT86tqbTJyq1258pnegKifxw3jrCC3bAvH8gNtS8greu5tOn3dKalK3Q5yV9tmmDDYAYHxHGsK7G5zcgTXD2nexcEa+WYsMvhY12N6oEzVWGBLk19hS2W4PiDMH4I6mTRO1M0H/AmiFUQE1jvEGpfJMdxzoUWMGTd8HaTFXIIA3HRi3Qc+z2rwLMv5s8pM41IXMLHwQR+R3V5zbQOEpyGaoUFhdRPZrRh8D4qY4KulxYifzXgsAo6MIfw7nq3nCPgDoZkppj2b1BAexHwgE1oNxm+X9eQUjOXwGjLOMsv56oNx06bgqxYlNI4TP9WnISkRfNxaCB8fbexU7Tu6OdjbkqNsN1LsLV5O4Px0d3VfDXP+Lh0bIHZy9p+WPobo5pZBWPHPV0yWA9KC52AE8/HnFP4gDMMVvEhlL5bSDpyts80UlD8z7ihumSseVleIAuKkKFATQa9oybWqhTpOxLgtgbOT3ysaAkqkdWQU0xclJ8PBw4jckYwEMXmaqCnN+vN3y1fBf3CROAnSg3Cdx+w0Xx9sYdF/V4qHD4tZ1KdtejYMsT55e2IzWTp5j09BNQPY1hFe1heBsNhziWcrjFEV91ZSMq
 IFUk+9uh
 oboqJuJeF78bD1Js/Yi/nLxab98959PO7rl9tgSsrknxI05QNTXhgrqiD+53mhkk9qSmnoTEUVp++SAnSjooISZm6gor1hpUhD/0gkxfXGjJhT3S5jenPYMS3+CeC3/sLQE1dyS1VqgVsi7Xn1IROZh9iWEFzYZsy4Pxu40DDOBxZaE0kzxLRbZrboBb0XljHBoObt0WPxYx+dXXqNNYVF9TvgOSZ/CgqCrZZN/4iQNrI73/z1vAfi+GcsswuGzdRTyNpQhiVv8Kom222gRT+VoXChzSFsySh5bkOMHzT8gheOtlr8Yylvud/hitEQanEvwA5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a configfs attribute to configure the queue depth (number of tags)
for the rnull block device.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  5 +++++
 drivers/block/rnull/rnull.rs    | 11 ++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index a84854e7c358..2dfc87dff66a 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -118,6 +118,7 @@ fn make_group(
                 mbps: 16,
                 blocking: 17,
                 shared_tags: 18,
+                hw_queue_depth: 19
             ],
         };
 
@@ -153,6 +154,7 @@ fn make_group(
                     blocking: false,
                     shared_tags: false,
                     shared_tag_set: self.shared_tag_set.clone(),
+                    hw_queue_depth: 64,
                 }),
             }),
             core::iter::empty(),
@@ -231,6 +233,7 @@ struct DeviceConfigInner {
     blocking: bool,
     shared_tags: bool,
     shared_tag_set: Arc<TagSet<NullBlkDevice>>,
+    hw_queue_depth: u32,
 }
 
 #[vtable]
@@ -274,6 +277,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                     blocking: guard.blocking,
                     memory_backed: guard.memory_backed,
                     no_sched: guard.no_sched,
+                    hw_queue_depth: guard.hw_queue_depth,
                 },
             })?);
             guard.powered = true;
@@ -447,3 +451,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 configfs_simple_field!(DeviceConfig, 16, mbps, u32);
 configfs_simple_bool_field!(DeviceConfig, 17, blocking);
 configfs_simple_bool_field!(DeviceConfig, 18, shared_tags);
+configfs_simple_field!(DeviceConfig, 19, hw_queue_depth, u32);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index bcf6a85f1cbc..491979daa50e 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -147,6 +147,10 @@
             default: false,
             description: "Share tag set between devices for blk-mq",
         },
+        hw_queue_depth: u32 {
+            default: 64,
+            description:  "Queue depth for each hardware queue. Default: 64",
+        },
     },
 }
 
@@ -172,6 +176,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
             let blocking = module_parameters::blocking.value();
             let memory_backed = module_parameters::memory_backed.value();
             let no_sched = module_parameters::no_sched.value();
+            let hw_queue_depth = module_parameters::hw_queue_depth.value();
 
             let shared_tag_set = NullBlkDevice::build_tag_set(TagSetOptions {
                 submit_queues,
@@ -179,6 +184,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                 blocking,
                 memory_backed,
                 no_sched,
+                hw_queue_depth,
             })?;
 
             let mut disks = KVec::new();
@@ -209,6 +215,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                         blocking,
                         memory_backed,
                         no_sched,
+                        hw_queue_depth,
                     },
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
@@ -264,6 +271,7 @@ struct TagSetOptions {
     blocking: bool,
     memory_backed: bool,
     no_sched: bool,
+    hw_queue_depth: u32,
 }
 
 impl NullBlkDevice {
@@ -276,6 +284,7 @@ fn build_tag_set(options: TagSetOptions) -> Result<Arc<TagSet<Self>>> {
             blocking,
             memory_backed,
             no_sched,
+            hw_queue_depth,
         } = options;
 
         if home_node > kernel::numa::num_online_nodes().try_into()? {
@@ -297,7 +306,7 @@ fn build_tag_set(options: TagSetOptions) -> Result<Arc<TagSet<Self>>> {
         }
 
         Arc::pin_init(
-            TagSet::new(submit_queues, (), 256, 1, numa_node, flags),
+            TagSet::new(submit_queues, (), hw_queue_depth, 1, numa_node, flags),
             GFP_KERNEL,
         )
     }

-- 
2.51.2



