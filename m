Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CAB2E63F1C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 01:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43906B0111; Sun, 15 Feb 2026 20:00:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D856B011C; Sun, 15 Feb 2026 20:00:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9108C6B013D; Sun, 15 Feb 2026 20:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADD16B0111
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 20:00:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BA52140B58
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:24 +0000 (UTC)
X-FDA: 84448319928.20.B8152F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A992A20007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mn0Sci4k;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HP5aRzEoyuN72rj0GVPgjCdfTlp5xsDwbqKA5gO0pM0=;
	b=RviGOLb4mM5jMRggieEtlNFuPhyxs6jiQV4ZvqILqFhXc8A6be8e8V8L0DKbxq1fv18n+v
	R0j5yEVQmbxGrtKikF8QnaTsPIjfLFT0b74UqpmEKByqcVzaqa2K3mIF6lVkgym3AvPIqW
	JPTeT11glHNyZCr4GAKAiJGYN/6wD74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199002; a=rsa-sha256;
	cv=none;
	b=W+pxXAqCPYwuSZGzeyBiyhPPpur1daUKdOixW20Hxu1tVz8aP+bNdhwlSWFeQzHHbHpjnH
	deTdFPeWKYwQbeUnQH0S0GmlCmSDK1jnpMcyWnXJepUmNxHR6Uabb1Y6uZOWJhwffSyxYQ
	+zM449q8XoeFaGuQCwtpFl27+OVpabo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mn0Sci4k;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37EB86013E;
	Sun, 15 Feb 2026 23:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90CDC4CEF7;
	Sun, 15 Feb 2026 23:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199001;
	bh=u9tAIyBFICh0h8M21rtuVjobkuPmRcCa8Z1Q+dHSvbY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mn0Sci4kIejuXJiTiTwdIfMXc3NqoDFy3RaGKisDg44zwaa3hSX3aAZrmGMOb1eec
	 7x+6SC3q5Z+9cLM/tkFHnalMzYwYLe78vwFaM0XEAnZ8+1lB9viOpgzktWVz+80QZT
	 QSjgz6a5F8xIzO2TJLivOQ5kXo3xCpVQyZLa6f2X+coFC2pTG1ODGvT4GWK+/K94jm
	 7ynXUlozo6wQAqE2IrfGh6EGsOkn0s0GY+hz9LRGPMxrlT0g5oNpLLgDmCImMpcnly
	 IONfgmAV92usz5sE83QOlBGxkJo1gjwtb1SDOuheDJ6JlmZ5L6opBfWPB60UCYcCWV
	 yH9X/rnEcjlJg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:36:04 +0100
Subject: [PATCH 77/79] block: rnull: add `virt_boundary` option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-77-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4488; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=u9tAIyBFICh0h8M21rtuVjobkuPmRcCa8Z1Q+dHSvbY=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhhlk7rsPagv2Uwv84amFbhOdhB2bAscIG/l
 qV12jhD6D2JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYYQAKCRDhuBo+eShj
 d39FD/96ZYUm8hNRgfOmyMX5tCjDFNgsfNiS40He5tLPYN/6WQj6DrGgYwv+z1pGIP5EDiWlZ09
 laL9bCVVPzdOdm+xGHJM3oRPpcjUgp3vfQlfL1sMp1+gebfGvFcb1pRWX7kDloy/79czcjq8ZZZ
 Ew2ZOAAd4zYAA8N+l182+vgq8BWrVmS3t/zpZaIvqxD+TjtM1RhHdgQnlEbAEF0CWMBf9GE3mJ0
 v8H29/X1YY1Qx+tcEyZ6y0J2cIFtmGzkMTSOMZVs2edeuuBCFYlnHTNDNVqAXxp7iG7CdqFbtiY
 fxkRP8jEYWWY+GGJJm6Vx4Hsgbwph2axGY1gT+jwIj8zxjIUbteI3xdD8ODOACOLRQjnzF2NG0G
 nzRtBJa3Ioc1hCdZPK8Ji3+re+kKP1h0aQ9mArwvdEcp7gnkeUXwTn6fFd6DUE1CSDuKr2p82z2
 MHFJ3Bc/BSVGBr/tK/GTTEMg/60SSV0z4YUwBDJHFvJ2AkOblvrgm+xvS3mzdYKXrwfc/T29YyK
 3TkuOp/0brAa6hgft36PbxJ0BU8NNFnhDc9FLu2y69Wubmb1BobDHlKRuxuL8+fbCePwd6eAAtp
 SCc2W5iseGlDBlHXIR9WqgzbOkp2HJCUcxX2S6O4WUSXTGW67mJKb56Ha8shPJq/utfHM3KDuH5
 CBlxRfFuSrMvDDg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: A992A20007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: iudeoxmqa4nran4squzt4qpbpaj7mb46
X-HE-Tag: 1771199002-607823
X-HE-Meta: U2FsdGVkX1+J+DDbSr024QfSFrYQ2hY2OU4L5WfKbikxHPXX7nKRtZNdx9mYaxtqWChpQlX4grOd3you3raWYGPiQVlPntusZ88SvBy6TcdF6FOcErAKEhbWbjp4gaM1C3xo4Llj+QLd2nZK+AWOO+/VlAyiberzqAwHc8xRvvnrjfpqZvZ8inevxoTgaywla0YCU1PZxEkmGfKzaw7d802AMOWqr1OSYRwhpo4kb5cGUOqtx1tzMcBFfStMeowK2nD4GqzS7jQg8FDfxKlmCgx7895t+2iazAb/4cnqX4DeChuKcIEqyFZ/wM9SpF7CquvmlhEzEwpnHBAeQ3ztW2nWOiLgqDoAj2I54xyGEC18rMpuvbx5LUOIDqc92izjcg1hNv+QgiCe9Wxsswu4WR2xxlKRxrAXkrOOrz7cRjF/ThymHJRwoRmakI4RM5nQ/fxlY7GQ4moqwroPnLSoltdw2lV++YPfEjfmd1K9nY685yvnEa2JwpiKYs/drrtiVz3jbzr44rLEExUkOhDAM3233LXDETlWAijj76XtbBjTS/fu4thW89zLdR5ZHjROEhugJuzEpT3IDNJo7SJpHAqfAK5nn3eV+opk/BwHz7wLugYiu4i4KYcQceQGKuWRyRJzFCIjxZuHjAMxbSMBQ6gnH2DCMvdx8BtJTBCBvozYaesbSmCxDZZCl86TXhZH/hOcUg9kKN65IrMm+CwkKE9p9rImA5lVhCdlcp/1miD9kTpnKXxLMe3SSLczlfH4JjxatcKcHdnfD3jM6oO1jc3BmHx4vLzbtiQ64WN7I03KoIT3lsICOZPo1PZoNAMB1Bk+5PQ1cEiTa4redpaYaLuGThZQbtGlzXM5oeJ3OXgrqm3RX1ZVuu1KP/zG8Iowp8QTtU43CsJPwGSBKVua3PfQnoV6/kXoAvnAjWHjxdgBvNrwYMejrXOT1j7MJuB1jv8PtagE/4mcT5FfVNf
 lBPzSmLd
 CdDGIMO8mzokeSqsr3uEkTZ0jqNAvKQES1Y1rQXhNwFfyoAKwOrl3tKFK+mf2xxe4vqHXW2ZGGfoOcaPjHu5QSGEUoKRxZ7MUVLJlgmhPzihhuZ0z+p7G4gCSIG1izEj7yJuEX3r5Vx2mxXHH9Nb47VHRjP2iJ4VVBTzGcexCV13+P4Wr4wnS1LVbobBELn9KPlKk+kLFKXbpZFMeEqOsJKqqVGndi2cig8Jl6BD/QZa9Rqkw6+1ZOS5cqBuUWeKLbz6Bc3gpyqISk0ehPxLoosGTE0iU3q6eq6JVfTcDltf7VCGFUajPCZE47eddKdXCr9tgTV5dOIl6qfCDqDKsUwlgvkc0/SSQOeuu5GnBvY+3y1I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a configfs attribute to configure the virtual memory boundary mask
for the rnull block device. This allows testing how drivers and
filesystems handle devices with specific alignment requirements.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs |  5 +++++
 drivers/block/rnull/rnull.rs    | 17 ++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 9eaace8b4257e..8b9ad8a1a243b 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -123,6 +123,7 @@ fn make_group(
                 poll_queues: 27,
                 fua: 28,
                 max_sectors: 29,
+                virt_boundary: 30,
             ],
         };
 
@@ -210,6 +211,7 @@ fn make_group(
                     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                     init_hctx_inject,
                     max_sectors: 0,
+                    virt_boundary: false,
                 }),
             }),
             default_groups,
@@ -293,6 +295,7 @@ struct DeviceConfigInner {
     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
     init_hctx_inject: Arc<FaultConfig>,
     max_sectors: u32,
+    virt_boundary: bool,
 }
 
 #[vtable]
@@ -351,6 +354,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                 timeout_inject: guard.timeout_inject.clone(),
                 max_sectors: guard.max_sectors,
+                virt_boundary: guard.virt_boundary,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -629,3 +633,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 }
 configfs_simple_bool_field!(DeviceConfig, 28, fua);
 configfs_simple_field!(DeviceConfig, 29, max_sectors, u32);
+configfs_simple_bool_field!(DeviceConfig, 30, virt_boundary);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 495a810f4f4e1..dfdb56bd76f52 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -28,7 +28,10 @@
             BadBlocks, //
         },
         bio::Segment,
-        error::{BlkError, BlkResult},
+        error::{
+            BlkError,
+            BlkResult, //
+        },
         mq::{
             self,
             gen_disk::{
@@ -53,6 +56,7 @@
     impl_has_hr_timer,
     new_mutex,
     new_spinlock,
+    page::PAGE_SIZE,
     pr_info,
     prelude::*,
     revocable::Revocable,
@@ -210,6 +214,10 @@
             default: 0,
             description: "Maximum size of a command (in 512B sectors)",
         },
+        virt_boundary: u8 {
+            default: 0,
+            description: "Set alignment requirement for IO buffers to be page size.",
+        },
     },
 }
 
@@ -287,6 +295,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                     timeout_inject: Arc::pin_init(FaultConfig::new(c"timeout_inject"), GFP_KERNEL)?,
                     max_sectors: *module_parameters::max_sectors.value(),
+                    virt_boundary: *module_parameters::virt_boundary.value() != 0,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -342,6 +351,7 @@ struct NullBlkOptions<'a> {
     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
     timeout_inject: Arc<FaultConfig>,
     max_sectors: u32,
+    virt_boundary: bool,
 }
 
 static SHARED_TAG_SET: SetOnce<Arc<TagSet<NullBlkDevice>>> = SetOnce::new();
@@ -414,6 +424,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
             timeout_inject,
             max_sectors,
+            virt_boundary,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -512,6 +523,10 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             .forced_unit_access(forced_unit_access && storage.cache_enabled())
             .max_sectors(max_sectors);
 
+        if virt_boundary {
+            builder = builder.virt_boundary_mask(PAGE_SIZE - 1);
+        }
+
         #[cfg(CONFIG_BLK_DEV_ZONED)]
         {
             builder = builder

-- 
2.51.2



