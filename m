Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40973CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88F26B00C2; Tue,  9 Jun 2026 15:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A603D6B00C4; Tue,  9 Jun 2026 15:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F516B00C5; Tue,  9 Jun 2026 15:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81A7F6B00C2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52F6E12079E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:45 +0000 (UTC)
X-FDA: 84861321090.13.A8E9245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 93B4C16000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dy16hqjQ;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9SH0w8iIvKNdd0B99CMlOWkeY6yYgzCEx1TAgow6z0=;
	b=dfUlB/WjgB3t+bKj3VI5LYx5NDgM15BsgXNa8n++hvvixtjwVYjzt6diOgjD6UiOs1N5xT
	LusR5DaxMTWaSV/mw2I4fCAuwaWHdKZ0LwHmKo8+mbKETY+ZUzZ1gSwhCig7/atL482Mgd
	1ENnFl3pdjFA5KO9Ionpa7HYJGDz1Hs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032363;
	b=533Z9WaFUpa+Yye/n07y5rOKOTnUeEhbaaTK1SiMWN0GOJnDsYL4n8mY1NEl1T1kvIV5YR
	BYBWY7liZCNIGhfQcBSLBudbzjj72frDFkLgJSh+t/I59Lhp+YLc17FTnYsVecfyJuhqt3
	5d0u3OLq+hK74+h4Lzi1ZGkqku8wWBg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dy16hqjQ;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A142602D1;
	Tue,  9 Jun 2026 19:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EAE1F00898;
	Tue,  9 Jun 2026 19:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032362;
	bh=z9SH0w8iIvKNdd0B99CMlOWkeY6yYgzCEx1TAgow6z0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Dy16hqjQw2Mog1tvdwcHBgxNe6GgyDQM9lfuJiH/uSL8HAFAWfLPU6tA8x9VRqQwd
	 k+3SzKdu754K2Qb2Vyyl+iCqoQz5wlixX76y9mxsGH+LOLu23YCNSnl2t0wBebYnRz
	 oF/vaWFXAdOFWQX3Zl5UAFkKbK2R5pR9gPPIkKpTpEpNhwjhrh0XOrnay2hDQYlF3m
	 BIi2jA5ulZsvWpQsOrZmxd2LWCfCbHRd5+N3kYu+LV783dC4sl4qhmAHF40BN7rfBB
	 Jjg+bT3idl2VsnrwL9xR2aaZUsQu3DLq1qcvG9nTflg/a20RuBa7EpB/Rn6NLLWVh6
	 Q9NcMxrDuw+cw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:58 +0200
Subject: [PATCH v2 79/83] block: rnull: allow configuration of the maximum
 IO size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-79-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3966; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=JQ3kG/WGGmu6/EYTDHQbX/u4S5Z3d/R/pgMZd3cP0HQ=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT8rNaIp8s3qv+4COUoMMnibZPjUIMIFeJDh
 oso6l2MqniJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk/AAKCRD6UCkIqsW9
 0PsFD/4xE6M+uoXN4PZ2IfrksGAEmNVSk7zRi9n1KitGIRUO+UXtc5+N2QRfjVe6sYx7Tp7EqAs
 RWiPCK8XoQeu59WSbcfLQ6Uiw6+OnhcWG4IDQbZeiAmkq5lLXGEMMjjCFXyVE/P2oXHqkSHL65u
 mDxAorO3h2M2aPim/kUBZ+OYSg4flgEeSi6cQlnv/O5PjQwJpDiQVAs4n5gcq6M39Iayt3dZWgv
 JO4rZFnYQNdCiVv5rO4clM2Y0y+V5YHquDcJvYq0Oq3PkNhSh8qeJ63Qe/2H/6rhoc/GaNlzGQp
 o2UVDDj3YdOvRIiUJrbMTZeTzySTO6BhLPRqXnreFIoK3Ek7loiI2whFBNS5OiOa8lqgwuWg5WS
 ZDcru6GX3keiMByCTYc5cBeicOZE7LVFuTxIk/kpX85QvuOc2Egr2xcgF9za/QGg2hTJ+zF/Ary
 OWqTvc335xTd7d6HXnj0Ab2Guam7+eCfzPNROf3FkFhh0fFO+T3U6AKk7/s73rIttGmhrGCX4sl
 HNulUFvD1lcl6anYjUPepd7whnquIe0VJKe4iy06/U3LG/vQo7Y20FXtVs9roAu63NfhByKGIaY
 bJ6U/vhYVBd/Edt5kZth5o2Zv2P/vSkHHDxXS8uwwqkdeevhuVh8vvI/I9K/xkmHUlm97NHGq0S
 /IRjhjK6XdwyWCA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93B4C16000C
X-Stat-Signature: o7b7oe8sjc1jjg5ks5eaznmd393unyuw
X-HE-Tag: 1781032363-290613
X-HE-Meta: U2FsdGVkX18AzIEn1luYnmmoqlnfvcY1RF7DuRdZdACUo5B4m+uvnEIZhsroceUPI5bn815hli9PK4xB+WZ7xfphUCSNz9S9m2GU2XqSb+ray+ZjjGoDAdEvYtY/NnnKeg0/iLxn0fLpZFC5F6fjH7tg5rrqYAempuQrxNCXqVdylqcTslH8rLbQay5EeKOY4r6CwQhYYraLtQk1tlR//+e+o055/3BMIXx9chhatuv4Mlvy6t72ON4rSEsosQcleWJLnQoSJBQj9s5ucSMQtutZxrVd7r5QI4al66/C6PHhAmk1laWAt4GhtpGVpO3D/CVWu87DcRsiwse/tJNwMh9/45j45lw70Quu1h4y7Kkq8/+xIWq3uVSEdOHKQCWHM2I9z0LhVWyQtU8oraWvBtcwto0FJEto3AlSzv9Nc0Rs2tnpe7Gh6IIyYZpZr69Ztj7ev3YrpYVQfLyeebxl84tLpnWkWYehBRQYbNvd5s+dZ1YXScq8yNk3518B6Pzf9UWQaDKR3B7b6yxhnQFTtBAugS3yBagdaL39FE8IoaBiRjogUkYc3nnYebT98lnUSP5ClIJk4smoca08wy3MlW6F5oRl5v8a9LH13UfYSQGGpCdegQhanI0gbnawZgbUxBd83RbWgTWifTP8bDmOojqR8KJDlhOphIdgENU1tX+RW2S2rnLXhqfjRtzTPF8TAvI13SGZVFLNM2YkNXFa7U0sV/xTghWQ7Ipd14muWL6CLQzZX7k0WE3AUbgg+Bf7rEF1FWJFrarKd2BvgE4SwJk4pD/dQIvj/ARBAkQYYycdr+vqeQECffIoMTlujsnmEfFpINDzh44oX3bZW5hR+cfMMsOA3fT2dL12X/jInsyf8kwurtPag61FppiOPCwKekbtuHZHNGl3LaQL8suXEPsBBW37A17cX/YTbhyyfAh/gA+D4OLY1ZbGXKaSgyA/rCVPOjwI2LyVLjxXcRi
 xiaL8gs0
 dGFzekBe1F/bVvE1NNV32CFZMKlNF3Z1xTrTNRy6BTOaWguELFvvYjA+jNhW+YIAfaG1n1aupti96KR7wBohduqgk+1ZltiaUT61JhZQMjwO/hfPGqGBECi2zwbUO2kn07pAtiSNftPw1PODdVxHHUewwXtyK8WbcpdxYRVCOmTCWhpvQx4386bhg+U5eD0gYXlgibWkNntiYNdUTVSsEnqOWeycrgxNKPf/kfhRN8RHppgOKogA3yu/wTT4Y/pLeAQc3NK9AsLOSA2XTj1YGkGlsOX2jFP4ODV6hofNBbbizQqRi7rtXXptkuooV9lOz8Sb2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add module parameter and configfs option for controlling the maximum size
of an IO for the emulated block device.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  5 +++++
 drivers/block/rnull/rnull.rs    | 10 +++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index eaa7617e5ffa..5ab217e43e2b 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -132,6 +132,7 @@ fn make_group(
                 zone_append_max_sectors: 26,
                 poll_queues: 27,
                 fua: 28,
+                max_sectors: 29,
             ],
         };
 
@@ -219,6 +220,7 @@ fn make_group(
                     requeue_inject,
                     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                     init_hctx_inject,
+                    max_sectors: 0,
                 }),
             }),
             default_groups,
@@ -312,6 +314,7 @@ struct DeviceConfigInner {
     requeue_inject: Arc<FaultConfig>,
     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
     init_hctx_inject: Arc<FaultConfig>,
+    max_sectors: u32,
 }
 
 #[vtable]
@@ -384,6 +387,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 requeue_inject: guard.requeue_inject.clone(),
                 #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                 timeout_inject: guard.timeout_inject.clone(),
+                max_sectors: guard.max_sectors,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -612,3 +616,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     },
 }
 configfs_simple_bool_field!(DeviceConfig, 28, fua);
+configfs_simple_field!(DeviceConfig, 29, max_sectors, u32);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index f909360ec70d..15b8c365b9fa 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -204,6 +204,10 @@
             default: true,
             description: "Enable/disable FUA support when cache_size is used.",
         },
+        max_sectors: u32 {
+            default: 0,
+            description: "Maximum size of a command (in 512B sectors)",
+        },
     },
 }
 
@@ -307,6 +311,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     requeue_inject: Arc::pin_init(FaultConfig::new(c"requeue_inject"), GFP_KERNEL)?,
                     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                     timeout_inject: Arc::pin_init(FaultConfig::new(c"timeout_inject"), GFP_KERNEL)?,
+                    max_sectors: module_parameters::max_sectors.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -352,6 +357,7 @@ struct NullBlkOptions<'a> {
     requeue_inject: Arc<FaultConfig>,
     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
     timeout_inject: Arc<FaultConfig>,
+    max_sectors: u32,
 }
 
 #[pin_data]
@@ -487,6 +493,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             requeue_inject,
             #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
             timeout_inject,
+            max_sectors,
         } = options;
 
         let memory_backed = tag_set.memory_backed;
@@ -548,7 +555,8 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             .physical_block_size(block_size_bytes)?
             .rotational(rotational)
             .write_cache(storage.cache_enabled())
-            .forced_unit_access(forced_unit_access && storage.cache_enabled());
+            .forced_unit_access(forced_unit_access && storage.cache_enabled())
+            .max_sectors(max_sectors);
 
         #[cfg(CONFIG_BLK_DEV_ZONED)]
         {

-- 
2.51.2



