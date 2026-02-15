Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3C6E63F22
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 00:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447FA6B011F; Sun, 15 Feb 2026 19:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427D16B0130; Sun, 15 Feb 2026 19:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311EA6B0134; Sun, 15 Feb 2026 19:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91FF86B0130
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:39:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 307A4160B0B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:44 +0000 (UTC)
X-FDA: 84448320768.14.2C20CB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E72E1C0004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:43:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FbOWUKbm;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GeW8NIhSUCU+3aLaJoURpeGYOPaRY4AoO84muosun+U=;
	b=x+FKpYTwp4h6fnG8JcRzcA0DEI+9rXU7bDnkiuCUKC7xLhgUjIqv3jAV/9HtCrSzPfUKr8
	XpqXtcD9kzfswsyhAnNQqQ5RnCgdh1s2Tf3Q1JBpLMSrY6+8cqtMAZ+FuDZSl33g9vqton
	FgFXZZnfxgvf/zJ9LHyxAkZGa9dqbKE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FbOWUKbm;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199022; a=rsa-sha256;
	cv=none;
	b=1ARTaiSGaHUqCXPNogB3Vt5VOsSdGMS9qLhHtPraQ8PlO9ljqOlPkGXANgXwShtgAit5Vg
	wPzvpuqZHnnQkWJ/HnzUFW3VpaakZXxpRNgb2hSAzjvJTsfRqlX9gVsLzrBSyQE1cZuSVZ
	Dy5Y/1rXI+II9ebNKWTda+XLag8zzAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C4A56013E;
	Sun, 15 Feb 2026 23:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77798C4CEF7;
	Sun, 15 Feb 2026 23:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199021;
	bh=/Kuy6Fsv3n8+vl73J+RNkL3tqtg0kG+WMvIfcKimuAY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FbOWUKbm4n/CXe3V1um1I3TjOg20nmVQfW2OtVaFFxdNQP6kQ5k2icORCLV9qSFr+
	 yJiiKsSkDyEiyqCVq2kaGn/5bQTqiyXmkFnwID7eGTArXZjDUmy6eLzrqTgQ9v/lG1
	 jZMc3W1bhGJosTvvYjhCHmIuoVx9vC4NnwNMNQu5ZyA/gDXXdGDn/4gnnsYqViu5xV
	 FMcXIeVhnCNDSNNOi41Vih3UrSVlAWYdB6SYUJBcn0XHodtOxIkic31DHfbzH7Blwo
	 AzMlXTinavW6AQNmNAtnunlhJBNafB6RZECUpmoLDCJj3wIxyzObvWNkXPdGvuci1d
	 I1LDxAxNta1Qw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:09 +0100
Subject: [PATCH 22/79] block: rnull: add no_sched module parameter and
 configfs attribute
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-22-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4831; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=/Kuy6Fsv3n8+vl73J+RNkL3tqtg0kG+WMvIfcKimuAY=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgv7mC1vFpEakQN4AFwbqnINSdbK/gHyJEkH
 nv6vJSxCo+JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYLwAKCRDhuBo+eShj
 d/ulD/0aSq4rGdIfmpcbHJkjMKGDZKFnDel5s8/iZYKX0kcfe5vL/96VBuvGiCoRVEkZ8B3AzCm
 JXU5pZeuGOCOYguGpmNw3/Y9W8riH+nzEPUw/tRHjqozu8EruCznv7k8kS/trwHLeYy5WvRVxxL
 8G7TYYyWO3FqZaKQ0eqgvDnUGMIKHCQwnEvkH1/5Wd8wmFfACXM588wRW3G795keARNiosEC636
 JepsEOmCU4dLOdjR/eOXrKvbtlNprOnX1J6YA1lWy9TMBHYA8cIvJ7m2LiwljAH+aU3epkpjIYD
 sXaRS6UlLf8z4ukbBBiEYsFmozNvXeCIQfN9aY1+KHROa6TJInR3Uink/5BUZxuASBgcWZBfoeT
 nRDUsg+8gX1JYv3dCe79oRV8gtmsRmOm+16DB0Wadp/1QNJhAOEtE82SP4vWiwgVXnBP4OZjG3Q
 hzV8bYoCNVVKzJuLqmsyuDpBO5oyY3ddBqfWlmNpBdUhNJAJTPOo9DCZL6HTPAc0kUnynM7C0vt
 18V6eyeYOtNtBrMUqXNuN+hUZGAw10Ofal8hynsLJW+B877Z1Q8lIAHzPnvfFiw6nPSe3s9PDOO
 Wp8cjGQqFBBaOrxxTJyTCDtC1FWxmTTyfW8IaKgkman2/gkTU7pxbl0pdZUzSCH4luV/GtBamh+
 LyYJCEG4DysFIgQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Stat-Signature: dzcewy9jbic5fbsd1tkpduixc3krnpcw
X-Rspamd-Queue-Id: 7E72E1C0004
X-Rspam-User: 
X-HE-Tag: 1771199022-859846
X-HE-Meta: U2FsdGVkX19XetFJwWMNg8Zks5iXTOpExzalGrqdqh6NYTBdoIL0/97QilwNLN00OgnTrKtyaKTdkBNPA1AI9YCsz4tgqkeuLh5yIsfYR/kMcXtEHQNyN63hkRjxLZCfCM6TnpKc4aEeR0amRdMBtBPa/aQPvbxuvsFEwEF42YRKteNPbhMwqau+wXGMsagSLwasU047rxK0hcu4fyp75/rcMUlQ1VqzXEvaD407Fl/cUEnXxcrFP2rSF7OAQtWVeFIEU3xTe4+f5eg8mDVxP2dl8oPyd3zha75armeufcp8WeB3gh5kNMWYO4zW1N1sCrn/6ooS14UMCtYJbOhuaOhZIka2lLm/IDgEDpU3bRqmDSWdKv6B9rXawIWF2/PszAYOy3LzIHk+bvH3RD1Zu9AFDZMQZ1ijlwTqid4jQpfHqlC8bJ/L7tuStAsT22dSa5GRhMbP8HmMQjLJ+a4NOcOPBKXG44XmlCxqwYj2fGM9wIQW3ZuOtxsnmHp9jw3wRX1578gGlGJbTyT1bdtXVH3NzWpj0V5RDQHgcjnoB4rp3lN42KgmdGmbBbscDJ9eARxPN7ccTiEyUv3S1XszVdbuOtqX7Em9qrJeIUbe8hfICgwlAOCuigllm22/pt1tQbieQEP8+soKbDxA49MWE4P0ahdZ0VPOm9sKLOfuG6XBkggzFxNwTtwK1HkKeP6gPv2Zt46osxoUJaLjsyNOs++txJBzd9drgmPzeg45tMPqHW38txN3mV+/mIesan5kKXghyyRjdtjyzUMHfPr84J5NeLwFtc8KeGBdy03+PeL6AP2P2OxNXxgc8vX9IkaIV3PLZ8Z9NwNbCqy9RSzvbU3/JhMFEEKAtvrBdg92LybOZiuiVOpHzo7zeVFdJDO0wKbOEAmB9apxrMvibtN/SQWj4X2ZCFXl6RpY7kN1EYnKQ5WltoFY8ySNobt0YgfaF67mcDEazPEiHBEonKw
 R4QPrvUx
 w/IZccZ3t7OWNEWR+ujKYNnV59w9V5jzhBDR4YwY6W9PInxv+HbB/0iIpRvU2ix86sMDARfy/NJcSpy2xALaZ1FA2Y5TtlOoBFB+QxES7LoYHYqZFdVHkkTVwinqM8yl3CMVpmSvgtNzPq4JY756QNwy2tUiywqg9hIEFYCoVLoue7iRCyzVsP0+b5s2YyDDgKpcULJpml8ha5VyHUBitBXkI/s1Sm8bR/XGQ50BETQPIwaFB92AH+vWx0Bku+I5xOyu3IO/c6OQVqrsXmWH3gDV5d3Clx9hnQNYHP8ixucapv1ETtsKwv+9w3KItLkFED6DzSOi3WhuMrR1zihOCQz5soRpEWSJc7Ms/L4+LGqMQkr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for disabling the default IO scheduler by adding:
- no_sched module parameter to control scheduler selection at device
  creation.
- no_sched configfs attribute (ID 11) for runtime configuration.
- Use of NO_DEFAULT_SCHEDULER flag when no_sched is enabled.

This allows bypassing the default 'mq-deadline' scheduler and using 'none'
instead, which can improve performance for certain workloads. The flag
selection logic is updated to use compound assignment operators for better
readability.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 31 +++++++++++++++++++++++++++++++
 drivers/block/rnull/rnull.rs    | 25 ++++++++++++++++++-------
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 4ec9be440105d..18e32a87673aa 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -95,6 +95,7 @@ fn make_group(
                 use_per_node_hctx: 8,
                 home_node: 9,
                 discard: 10,
+                no_sched:11,
             ],
         };
 
@@ -116,6 +117,7 @@ fn make_group(
                     submit_queues: 1,
                     home_node: bindings::NUMA_NO_NODE,
                     discard: false,
+                    no_sched: false,
                 }),
             }),
             core::iter::empty(),
@@ -174,6 +176,7 @@ struct DeviceConfigInner {
     submit_queues: u32,
     home_node: i32,
     discard: bool,
+    no_sched: bool,
 }
 
 #[vtable]
@@ -208,6 +211,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 submit_queues: guard.submit_queues,
                 home_node: guard.home_node,
                 discard: guard.discard,
+                no_sched: guard.no_sched,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -336,3 +340,30 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     })
 );
+
+#[vtable]
+impl configfs::AttributeOperations<11> for DeviceConfig {
+    type Data = DeviceConfig;
+
+    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
+        let mut writer = kernel::str::Formatter::new(page);
+
+        if this.data.lock().no_sched {
+            writer.write_str("1\n")?;
+        } else {
+            writer.write_str("0\n")?;
+        }
+
+        Ok(writer.bytes_written())
+    }
+
+    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
+        if this.data.lock().powered {
+            return Err(EBUSY);
+        }
+
+        this.data.lock().no_sched = kstrtobool_bytes(page)?;
+
+        Ok(())
+    }
+}
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index d1fb5fbc0c0be..9a301b06fc5e0 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -29,8 +29,8 @@
     new_mutex,
     new_xarray,
     page::{
-        SafePage, //
-        PAGE_SIZE,
+        SafePage,
+        PAGE_SIZE, //
     },
     pr_info,
     prelude::*,
@@ -112,6 +112,10 @@
             description:
             "Support discard operations (requires memory-backed null_blk device). Default: false",
         },
+        no_sched: u8 {
+            default: 0,
+            description: "No IO scheduler",
+        },
     },
 }
 
@@ -150,6 +154,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     submit_queues,
                     home_node: *module_parameters::home_node.value(),
                     discard: *module_parameters::discard.value() != 0,
+                    no_sched: *module_parameters::no_sched.value() != 0,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -175,6 +180,7 @@ struct NullBlkOptions<'a> {
     submit_queues: u32,
     home_node: i32,
     discard: bool,
+    no_sched: bool,
 }
 struct NullBlkDevice;
 
@@ -191,13 +197,18 @@ fn new(options: NullBlkOptions<'_>) -> Result<GenDisk<Self>> {
             submit_queues,
             home_node,
             discard,
+            no_sched,
         } = options;
 
-        let flags = if memory_backed {
-            mq::tag_set::Flag::Blocking.into()
-        } else {
-            mq::tag_set::Flags::default()
-        };
+        let mut flags = mq::tag_set::Flags::default();
+
+        if memory_backed {
+            flags |= mq::tag_set::Flag::Blocking;
+        }
+
+        if no_sched {
+            flags |= mq::tag_set::Flag::NoDefaultScheduler;
+        }
 
         if home_node > kernel::num_online_nodes().try_into()? {
             return Err(code::EINVAL);

-- 
2.51.2



