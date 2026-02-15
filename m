Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CE1E63F1C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 01:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3A76B00EB; Sun, 15 Feb 2026 18:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98666B00EC; Sun, 15 Feb 2026 18:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DD96B00EE; Sun, 15 Feb 2026 18:47:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 920706B00EB
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:47:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FD848CBB0
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:47:03 +0000 (UTC)
X-FDA: 84448329126.16.670CEB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88EE5A0009
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:47:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p6yFBLnh;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7Xi/VBvzXpptpfFDpWRMt0NQNBzR99PzgIqGuomrjE=;
	b=LirG0mLrh71wKmBa2IhEeVTSP96DGOU9gzqQQErFIF6Bb3ncmJcHzhh/XZ9gC0HcNX7Z8d
	S01aoGKuUINaKTkBuprsjRTtsuZwt/wynrx9Ph3Kr+RauNjPtLpmQaO3LSN2LJ2grCGGj0
	bOjA20RdgH0QdirxK458Ds2N4jLRNVs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p6yFBLnh;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199221; a=rsa-sha256;
	cv=none;
	b=FwDxqkmp5JorlYQqHB7eoPF29RvQqvTTH7tQH+tJRDTt0QoJo4H9kDjm12I/hvdEHwDGhM
	fs20EAelwqRTYWsVbiAy1aAd99RsGk0Vaya8qnMw40gkKOjK144QTvaDS0MevSwWOvuZ52
	MM0BeTUNxBB9CTARmexJTrO03e7xUlQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19AA561118;
	Sun, 15 Feb 2026 23:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89508C4CEF7;
	Sun, 15 Feb 2026 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199220;
	bh=+9VoTKjKEOvBExxZyNph/soC3n95VmzkDwZhpUL6gGk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=p6yFBLnh1+UCZDBzNagelOCQiAZTy6t9bFvCt3DfPY2kQjp89cxxnx/WqzR7uPkja
	 XtFGPzD709kaFS8rYUarJHVM5GG9Ji4D/BEmVk7PNzGqp6vPNfsy+s1KPD1tzNyA8/
	 kUp2P3pl+lqLRVQCboXDNycR9wZdV5J7kDe9/J7Pzji3+YlPfufknDWmzv02HHD9Rb
	 Oy6tumJ0FYF4Fy+rwaPqkV8EERwiTTka5MsM6Z2EXPPqyza5mQ+q53Nl+f4snLPddz
	 vNh/wt5/YsJA2FppjhCbiJIX11xf2/8kjwATVyvsSIAj+i1PGPC8ofwodRrTys3fVZ
	 v/AlL1tiw4nZw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:02 +0100
Subject: [PATCH 15/79] block: rnull: add `use_per_node_hctx` config option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-15-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4913; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=+9VoTKjKEOvBExxZyNph/soC3n95VmzkDwZhpUL6gGk=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgp/QnG7POfeQUiu6svmmlJXvglJFlTee9SK
 tUtnVeNTJqJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYKQAKCRDhuBo+eShj
 d/YcEADDBnyhEHkcnKjgjSOfCTFCpflKQjLLvFu6y+3h6U/AAMU78Ooa0UWjtF/iAX3ljz+Jw38
 +38ZE28EZIEB3oKXNFlW+Bu5c0Gl+sGHnDr9pWorObN7SOuzgXrqT20MVvUCfmBT7ZvhaSOJ1cU
 kdaZrlwcTmlB+TeD2Zf2MDIrdSgwoRdbRj7MjtFnWmmUEYeXBlAriFw9w6MTmNg5cuIu86YyV8G
 SMwkCgo8520RMC1HPaIMdnfafpsaSU+wwlOLWWmqRBGinA/yFpC64y0UjskOCk7PlsWYkKKrBXw
 N/sDKTZ8k9e1d/LTJctLsOKbdd3neRxwbJ+l+UNtu8qzgZhQR/CKepJxeHk5csYXyKosM7lZ8VL
 iBexxDt3LaW/TgzxQYlKqAR6cgVpDxCqLPGXN6N3lILjfobVN17IIIBMeS/dMaU9iIPUzRpE9c8
 xFVesd0gonPwZU+0MngZ71gXTW7zoeG9UsufKNxQRc8KqmHik976k+KwoPxL34GdAd3iOsLBtgB
 cBqPbCD77dmJumgXnYPM4PXREAE748c76L66EeBrq1bJ/cEfek3j0jT+dOVA8Iro47s2HwJm7NN
 YGi/5HKi90LE3zlnMj+ayAvpkvKnvl3sYgkmwFijBqbX0hz0Wfiwa/tJJ3EzCpbKl94uhHlcPY/
 HGlnL5hJHMYoRiw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: df74wcqj8asygig4pkrz38tqikfjdoum
X-Rspamd-Queue-Id: 88EE5A0009
X-Rspam-User: 
X-HE-Tag: 1771199221-348276
X-HE-Meta: U2FsdGVkX187F4yN2IWYYp0cuTXvvdq5jxcZNN8Omkf1tcY7hGbD7C6c/lWNm473aMQ552FLS8cXf8lIaoI8BqIop100Sr+6oMU6ChSsvxLM/g/85YcLZGINQQWPRXKUKKe3a6bxAb4x6YSJbLPz12eolWJAJqNxN9fqWeFcMACuJVq8vOPBZbwwHG4UMK6x8q4ewQX/tTa8DIAbxpwX/sIyWT+NK8uHDvGfOTNG+2dOG0YwlescTNm+7El1rubmTwyYn+fTnOySjdfR5BPWMkQnhjHLWQMCKKEB8o0N6blowY3x+tfwfE7ZwmWNSdLc113VebCXCfr5wWAP8aSHJMiq4zV9Vw0FpDjgNkYDoubmB+LwwmhAz9LQdwikYesPJkFhS479Au1lgmYUeb5kmZ5emXpVxbaYw99tzgZaiVsVlzYTIpsEZ3+YhyJio1EH6I/plHlAG2UdoSl0AnJ1V4E5dmwj4uF9RC93gbczzdrXABkR6WtV4iushzY9tcQWWljWsp/TmOcxCJM4sHyPEjqcPVzCGxveO2M/pWWqUViwi8APWMFZo17s3iUNTcXcdaKcpFmWH0ngf9zDiu1pvb1phj/rypS3loOp0MSE2Qx3gOsAZNnuEAcznoIX0wjGF8xb94Lek4fETtYwglK3eKxlXDQqyY/n/ZDndRS8K4YvqmQ5wNh03suMtIEa0Ga3ngIUoKhTOqu1llGCSPpAuwaNQuxKINhPiIFGfd/rVgkEynbApa0ryxm1Xqf8zBaw1ZZJD2kcsEuOCMHI7Mj94KjfavcxJqd4/DG2bDqTowCxtbRxLos5O3HxLAebMcW2yLWnKuFlWZhONkdiepaPsWjs+TYaAAHpfC087vtpNndwtEXW88B8z7rU44sSx1/0f68NWXgsoGIBe/btCzE2deOtKjqhBuqZ0COv/YpI4HwYY1Pyycr2xSMSI9f2zrOc8jQ6IxFoj623jFPEwGU
 Zf/t2q/W
 DRs6smdhiz1SXrGTmdFP98YKL78dZIJ3jb+9zQ1LEGJFzFhKqVovc7lUQR52eTk5KWGk19DBiKaipctoQWMWEfKD9NX9UHiWCsCYi2r0PKGP9/rGoxjAlewIb1/M+q6TSmhdZ3unOIxex1y6tWjyRELfvBpr4tioFRcPFrpFgC5cH2Q3qoGmcyxYT96sRad+1cXINGesR6yVxg88FKFom6EGatUtE/jwIQMrZPc7ZO2bF5Cwqj28JcUGnRPI5f9F3tEi75Rr6T1naJaNWdd7h5emJH6kjhM/DkML+ggC6PEIv5+8ZIMuktJYu9TOfsNDE0yYw09jm7ZjNnxbNztdSRvQ2HES3a+JxU7k0dN+RSiBGMGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a configfs attribute to enable per-NUMA-node hardware contexts.
When enabled, the driver creates one hardware queue per NUMA node
instead of the default configuration.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 26 ++++++++++++++++++++++++--
 drivers/block/rnull/rnull.rs    | 28 ++++++++++++++++++++++------
 2 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index fd3cbf7aa012e..b05bfc23090c2 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -30,8 +30,11 @@
     time, //
 };
 use macros::{
+    configfs_attribute,
     configfs_simple_bool_field,
-    configfs_simple_field, //
+    configfs_simple_field,
+    show_field,
+    store_with_power_check, //
 };
 use pin_init::PinInit;
 
@@ -61,7 +64,7 @@ impl AttributeOperations<0> for Config {
         let mut writer = kernel::str::Formatter::new(page);
         writer.write_str(
             "blocksize,size,rotational,irqmode,completion_nsec,memory_backed\
-             submit_queues\n",
+             submit_queues,use_per_node_hctx\n",
         )?;
         Ok(writer.bytes_written())
     }
@@ -88,6 +91,7 @@ fn make_group(
                 completion_nsec: 5,
                 memory_backed: 6,
                 submit_queues: 7,
+                use_per_node_hctx: 8,
             ],
         };
 
@@ -280,3 +284,21 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     }
 }
+
+configfs_attribute!(DeviceConfig, 8,
+    show: |this, page| show_field(
+        this.data.lock().submit_queues == kernel::num_online_nodes(), page
+    ),
+    store: |this, page| store_with_power_check(this, page, |this, page| {
+        let value = core::str::from_utf8(page)?
+            .trim()
+            .parse::<u8>()
+            .map_err(|_| kernel::error::code::EINVAL)?
+            != 0;
+
+        if value {
+            this.data.lock().submit_queues *= kernel::num_online_nodes();
+        }
+        Ok(())
+    })
+);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 55ee5165b90b3..990dfcf95c9de 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -21,12 +21,17 @@
         },
     },
     error::Result,
-    new_mutex, new_xarray,
+    new_mutex,
+    new_xarray,
     page::SafePage,
     pr_info,
     prelude::*,
     str::CString,
-    sync::{aref::ARef, Arc, Mutex},
+    sync::{
+        aref::ARef,
+        Arc,
+        Mutex, //
+    },
     time::{
         hrtimer::{
             HrTimerCallback,
@@ -40,7 +45,7 @@
         OwnableRefCounted,
         Owned, //
     },
-    xarray::XArray,
+    xarray::XArray, //
 };
 use pin_init::PinInit;
 
@@ -73,8 +78,9 @@
             description:  "IRQ completion handler. 0-none, 1-softirq, 2-timer",
         },
         completion_nsec: u64 {
-            default: 10_000,
-            description:  "Time in ns to complete a request in hardware. Default: 10,000ns",
+                default: 10_000,
+                description:
+            "Time in ns to complete a request in hardware. Default: 10,000ns",
         },
         memory_backed: u8 {
             default: 0,
@@ -84,6 +90,11 @@
             default: 1,
             description: "Number of submission queues",
         },
+        use_per_node_hctx: u8 {
+            default: 0,
+            description:
+        "Use per-node allocation for hardware context queues, 0-false, 1-true. Default: 0-false",
+        },
     },
 }
 
@@ -106,6 +117,11 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
             for i in 0..(*module_parameters::nr_devices.value()) {
                 let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
 
+                let submit_queues = if *module_parameters::use_per_node_hctx.value() != 0 {
+                    kernel::num_online_nodes()
+                } else {
+                    *module_parameters::submit_queues.value()
+                };
                 let disk = NullBlkDevice::new(NullBlkOptions {
                     name: &name,
                     block_size: *module_parameters::bs.value(),
@@ -114,7 +130,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     irq_mode: (*module_parameters::irqmode.value()).try_into()?,
                     completion_time: Delta::from_nanos(completion_time),
                     memory_backed: *module_parameters::memory_backed.value() != 0,
-                    submit_queues: *module_parameters::submit_queues.value(),
+                    submit_queues,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }

-- 
2.51.2



