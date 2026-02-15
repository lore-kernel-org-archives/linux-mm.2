Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D71E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25DA66B0112; Sun, 15 Feb 2026 18:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F656B0113; Sun, 15 Feb 2026 18:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127B26B0114; Sun, 15 Feb 2026 18:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A00106B0112
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:54:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8548C160AD9
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:53 +0000 (UTC)
X-FDA: 84448328706.10.8D86BA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5CCC120008
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmPoQJMO;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1u8ZYDZp/D2hMv8DR1mq8qozqVHKRYk/WyPr519F9k=;
	b=zrUVPrKoX6VFpVTZE6NlthYd7ODcg9yCEOT4XEro7Hxb4LDCCe5xN0TkFjyK/am7hADe5x
	+ZnCsvML/Iz40mIhpzt9lTKpWBdl3H7Ib3zLm5L9Ked73OjlCjshEUohxZ1ZezvUutvNss
	yHSSxvBN8eZ3e5RO4woEMASYx5kPuMw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmPoQJMO;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199211; a=rsa-sha256;
	cv=none;
	b=PlMezlgBvKmuPj6Ynny24fPXag8yg0ZeYEsCt8K1YpGGW/o01Kyk/384oiEE5N5Tubyqif
	/EKnbgiHaqgy8FchAVeN+ELDm5hUyNpToPyxfRbL/aBJyll0VZswx13oKM91j+Vzh6Soir
	8U7/MvJPpad6JSGv6zkUUf7Q5ZJWtD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C1E06013F;
	Sun, 15 Feb 2026 23:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05CFC4CEF7;
	Sun, 15 Feb 2026 23:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199211;
	bh=rgMlD4sSCyRxG8oxO2Pb6vDkLa6w1B6y8QPvsSGTaZc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WmPoQJMOP0UiKshCcGC2ekbgXi4gGMlJFjAOZ5MxskaSSSd+rXiJqBFSm59d9+B3m
	 0s5y1/PJFCE3IQLKtRAlU/wup1FgMbqxO4DKfmsSGzk6bQlt56ouh40xpjiJIu+xQ+
	 wUp4adpOBJ4FzHFcEec+9kxPGsWy9C69T3jmsLiZoXBV0KfD5lTEx8XwdR7Wv3vcfk
	 gopZcVsalEwSnEnreQVd+cFZIwC2gG5zdA9SFBdB2aLCV5v7uKeHzK9IeUHgcOLghj
	 ZfPFSozibHnKLdm772y85ZlrajGlHVSPadvHQKgUENZtO9GBKw4L2VHOOciApLT+5c
	 KSkkG/y80PoXw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:34:49 +0100
Subject: [PATCH 02/79] block: rnull: add module parameters
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-2-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3195; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=rgMlD4sSCyRxG8oxO2Pb6vDkLa6w1B6y8QPvsSGTaZc=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgdRABPWARqS1bNRC+vWhj9vKzZMZZcE3x1J
 YLYupX3Y7yJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYHQAKCRDhuBo+eShj
 d9LAD/9LvTRLSgtyV5rn6DK63XIy00fXEsKbYH8ZTfptYGBha30Wxnq4BRbzlAGzSI7eseVirtu
 U2fUA67OrAjwLTSxPkmJhR53AM7ylkIh+qc60AWS9hwAu0T5MyOK8jphpvwA0rWLKHaKw8JOFjA
 v4I49NQ7hDBxCmBG6svW1KzaxBnEN3sLb5zn7bAE6+wDppgTZc+pBYJXRK2ITRlWSl3BsDAY6fX
 eMajzH3BrBzqbS49rnM0/yjEGCyezkbXE+KCLx54uudBjCle9yLGzBqcTa6iFsxsgbj3xQl3W5d
 UUFXc3j/AjYSOLJaQPRE/AUjaFuXjdoEi72vpE5Be5eiikPFPU1N5KESsjdZ0rziWu7N5n2zBmI
 xUFRcHYOGWJlCoasEcDU1LzAy7NTFzrxsFs2c1oLrFLgVfbC/C4sQW3VDJ8S2OGeUsRhu7vdHtH
 SHF5YH9h5dksV5cM8rhy0uh+BC63HhvCM6ZqByKuFvxhd6Fh4al+YYmVYoYQgmFLMYcHprOo32D
 Oh+mJ02nU0YBCHqy0HGNrwQQBloNC864jBfkOPR62speL9TbdseULqpzx96q5EY1BBzzolCMUss
 lUP0KXF3Sp4JTC+3IqQ5sB3l/ZjUTARO52gSRtkLFn4XTHn5rP77RTo8Si+9U17qsEQvvKHrZt8
 vbnD6kdgtG+8tPw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: t9ha568qo8w6ddswnh5sy6kxsrt3qjtk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D5CCC120008
X-HE-Tag: 1771199211-502899
X-HE-Meta: U2FsdGVkX18l6B6sprBR7451LgDrtXmBJjXHfQ61AVeneAxLr6o3rhlcDsu1Id19QBVoZHNA8F4sQ+DJsGbUL3K+M1ViSvsCwYMXy6+/OVk77RqA76tOJB9kLlcKRoEHot0kXO4wBszPGEcuRiwinxRGzBjFdjHcZD1NlkAT/SXE6pcEdfaFZv0gR8gNnDaHsEgP7MyzwVKee6kgguI2+w8XdVATb156EBEbvtdV4Ra/7TG/W1zoh30P7ugCbYvwFifMm2003Ud/NHL/o1rkyFJXlzlMnl7nyXCnIjK5ZFBrY6qiBsZCsbuKw2QGvTTKHW/uaAAVO52t7zBWFPplF1q+l38XTWtaMBsH7ackiK0FPxQ2901aZxe1/3ZsDGMkmabf2mR/vgWonJ1+2lpxZFIF4sNkrXhwZlTuIy9PtS20RWkYyq+m4gtEthUJVBQ8q6sEHVjhgQ6r70ciumqnq5N49jB5x0erDAln7MQikSj4aY3LzSYtfJMp1Ib3up0dmGAdUP0PmA0mVp+lCjvT4dbgeDOO/8s5QBpt4w2NxvQ2zV2fUzbZm+v0Q5TOFEot9kbGMWJ36Fe8EWNmIyUdYDdmRFmlvctPn5l9QirIELxSMp/J4H/IaeSuNDIhhQVQz5ds20ab0PJWhxluxWNLkmvFs3AYT5IzZ/6VzAe0kknf4CqW0HoyJcZ9K4++b7dCxA25JYZTZkIxzY6mkBQZsVsvygP5OzPFqtva/L/Uvxac6luXfP7pW7dETM/k8X+mHlYkH63QvhT3Xf7OWW1RoSvrscTZsLT7qE9P0caqZpCyPUkjAH5Px4goU/duhxiBjaWNJHy9JWULpPdouXyWfjaUAB4IJTug3zSmdB3MqJel4yS/qP0Fg/9ndfhHMxFnOJ2fNJTOppiPz1mOk8qMznkgEy2egCc3QgkJ5A8gu4Wf39MrqM+6PqqqI5v/fUnqhPxZaKzSY0a4sXdNzFx
 56dWiu7U
 CKyVXqafJxSm6R0QoAc6ITBPbze6mjKUIKxrq0DznuQMCgMrn25j3OkB1KX4tDjk0jir1rOMgfXG3OXuSLKw0P0i//uVbKQ2Ru/+qyZYmOWReV/GiW1ONW2l+Av84wJX1nQ+TQ4IIQp9ZgW0mKY04yrdcntepQaWU6aJnKDDE0SS6kHKl9Hu+U6DbzykvNszzNj3uveCjmT91sQzozi3/BX3VW9bOYoK5Ipe7tvcbaCg28U9/sqmD7WggaByUohxQ4COvUq2Ubrh/46UqC1yitxDQfhympsKVAvW0zWB5yFIZJ9vUJub94qBHNldQlfPSn/xs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 drivers/block/rnull/rnull.rs | 51 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 2c83b014b05e9..bd883a5061cab 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -19,11 +19,13 @@
         },
     },
     error::Result,
-    pr_info,
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
 use pin_init::PinInit;
@@ -34,20 +36,65 @@
     authors: ["Andreas Hindborg"],
     description: "Rust implementation of the C null block driver",
     license: "GPL v2",
+    params: {
+        gb: u64 {
+            default: 4,
+            description: "Device capacity in GiB",
+        },
+        rotational: u8 {
+            default: 0,
+            description:
+            "Set the rotational feature for the device (0 for false, 1 for true). Default: 0",
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
+            for i in 0..(*module_parameters::nr_devices.value()) {
+                let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
+
+                let disk = NullBlkDevice::new(
+                    &name,
+                    *module_parameters::bs.value(),
+                    *module_parameters::rotational.value() != 0,
+                    *module_parameters::gb.value() * 1024,
+                    (*module_parameters::irqmode.value()).try_into()?,
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



