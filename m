Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14346CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7537D6B00BA; Tue,  9 Jun 2026 15:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7041A6B00BC; Tue,  9 Jun 2026 15:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619EB6B00BD; Tue,  9 Jun 2026 15:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50E156B00BA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 174A8914FF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:23 +0000 (UTC)
X-FDA: 84861320166.19.67F518E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4EFE7100014
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C+s/R9Z7";
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJTHJQtN5OQlA3kXWXe5gEXmVH0+1Vi2EqXteO8lhZw=;
	b=E+3VblLi/FZX3TLtVsZuL0xfIHJfzfoeqFAvjcSeaYac2vBIdPOM7BGSSelWyGFRotm6wQ
	9mkFHXM4JHPFjDURQ2Pr1jNq9BeQG+Zv2CWbzuMPI9G7wI/MzwxQarcnSo9CWkWIbpQ7+u
	aupGuIGpmfdjB5SkLxkxrVlfRXRlYII=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C+s/R9Z7";
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032341;
	b=zBNl40nmj2yi80Se/hrOBjAfMNWG1M/LthEYRPo26mrWxS5j88lZnhN6Hb18ttmK1bx0Jn
	9En7/TOh/lRClEGlw4blK0juGcUJqmviaPyJqFR3+V+T4BX8Ivo8f1WWLTo+mKplVicMKE
	wX2etCpeMKoYt4cun3W4uOFoPIqRv2Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2398602C4;
	Tue,  9 Jun 2026 19:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF061F00899;
	Tue,  9 Jun 2026 19:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032340;
	bh=EJTHJQtN5OQlA3kXWXe5gEXmVH0+1Vi2EqXteO8lhZw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C+s/R9Z74OZNoJ8c+zWo3+tXPkSQ+ixbl0fg0/issp3wrRbBBBDjbljXa2uPO40b8
	 lvDSlTFdE5WDffemG8zFJBUWVVw52K4d2aRHgQnSFGoJ/DesZRKu4t66tJUj5oHqUw
	 rIVFHikAFWiatp5W/5/ePqMuoCZ3RSRsCpB4VLPBgGifZwPobcsuI4F3Y1RuISna9J
	 /wrG+6sor58g/3TrfZwA64XDDFuxNDieIV5kBqswTFCyD+R9eUPzcazGTxsk9T4ath
	 yqICpu5rd+iAj1RXksr36w/9V1BUsLsgu+Rzt9TQiGiJiKxbzs/jiWPMaFsdf70n99
	 pLLnrIV/zc78Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:57 +0200
Subject: [PATCH v2 18/83] block: rnull: add `use_per_node_hctx` config
 option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-18-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4856; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=W6NPFvanCyRxN5s1t/T7s5V5cnK6/DFM8N+7PAduKdA=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTEij8XwF+frBqMC0Gcp9AC7AnB2pwS4JrQH
 ek+Hp3GUFiJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkxAAKCRD6UCkIqsW9
 0ItzD/4oGYrGoLcxFeTDDdsyisJ3mvbEwRaynStL7lKIivphzirl5FLUxqssIjKJqijnFMCvoGY
 QjYl5mD44FSDo8XdWpx9SsDLRQOjuenhzIKIUlTHH7uoUaDLly3ibLB30xRnzVN8rtmm0ePch06
 JdWR5Cy+yHWNuxPK/kHnwFqIRpEiGXHr2yVYCAICPrHt61+T7YzgBRjRC//48c/Bm4GzeJhJkzf
 d/80AbRIcQWyWKjc4AttPoAzJiS+WFbtuZyy/5o4xoAffsyViZBd4mE9fdC3Fx2xxx1gTw1zIls
 o+ZG41gtBClHyAiIergk19jmGs6WAYbe0E/egoNw21XVfvuGZHO9TzkEKhUZ2/TDWOB9Xjal6Eu
 G4hioZgaPf+eTZndWSHitjaME2pR+HMoc4wqPyqPJJyeVExFS31HQTw8x9WN7EblmK0LdWucfxy
 j/zICLMl1crwW62S+enQaUlrdQTvA6sKs5akQDG6kR+nk2gTv/mnCsLp0Kus6V/1EqDGypSGgEA
 5xkde6SImoDB7LjH6ySd0zpP8404Y059fXRD2PYoQ+npTmyUJVRVMdrMesppj0zJC0MK+qzBRAA
 zoWEecfczYKXWNIGs63icFgBLyZ256kJMhEytcjoSQITNRfvjEvC/WJ6GH6T88IW9tFuBrzAb6h
 Hg/g7XV17XnlawQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4EFE7100014
X-Stat-Signature: r43ngiapg7xnp5hpgz61gfp7rzoox1a9
X-Rspam-User: 
X-HE-Tag: 1781032341-880944
X-HE-Meta: U2FsdGVkX1+Z7QegmqmM4mM9NxcdZwdGIuUKt1Z6VJhK6ZfoQ3YMl09g1G56EWr+Qnp4YCcRc5hv0ZZPGmjll/PDkusW9JQVjw3GHo+o3A6uiXBkQF0tyhoZafaTXBraQ1XNYLam08u3aaPdbTTQyXxe6ZNQyOfgTdNbvVNouXzn5KJiJrRvSYQf2K3ENGHt4+OI6fyQlF3k0IyJxZIJFRtQzywC6ox7Z8NZlj1Drc/LhV15ztl+pqNMPzBjdZ/4otmLdJGd7DTYVtfh3avJ/lnqwJ0lqtPPrb/8pm6Rz3gtdCJN+tynjRtMO0Thw9OHNhzVW3Vr0Nwxr0jVey9RwNqRU/xuw4s7pQL+F+TY6QjsBNFpDFERLXpjZuspCMu+oy0zzzwxu99dTHvLZpi5eUCRZHTY0fX+yOkrZxvJzAzfnbVvOO+LC8DP+IUflNi9mYld71yH14yxdS8igCfX3008gtJLb4F8GLzZfQgCiPP/nVQ06gh90RK8VE7rmkIEUFZcZggU+tdEm6Pe/IqhYhFc6ZgtjS5eMQQw5Rw7sRVucaIRVz5z0eCr4iOAW/gF0mp4g1+6RNkyyXRfalRWtmj6b7XCOpf1iYCQUzZo+1+5OqOVyiICoPhFmXNLp7Y4xZmSWhLzm3ab773zHjPk3zwGva7SlizRlmkAa+yt5RO4X85ImNTsfVb626+4kVPCGkgQcqp1ZW7X8l6kCA7ObwaFmUS5jOP+6yx6V2KKECTGR36zKFmM/BYTFN4K9sY84FdIrYfcnFl62yqYFHweNNfLQOJUj6ti3b6CiocevxdOj9AbZVvMsFEjQMqAnNLY/LERCj2pQN6n2FYJe9DmfKZdcG4kLfVtA3QRfVEU4dcLxSR+CGD3JU36krnORKBLyubI66J9Jbh7AN5yzBxaFq8Glg1eJ1aoZomBagIHSb5pgt6gGCMrFUIRMTayGBWLtO8GCNb2vWSkbPdHGGO
 zX4W8yCb
 e5TfA8553YAyulEZG7vKus85OO6nJdZUp9yYMM8/vq7B+eA5eB6heIskvs/2b2N+LS1TeuhrighQ8+xdhaG9Xs37OH6rEng5ulbn5PPtq8qvuahD3+ru7Faid3OUlDywyF+kJFxjHb2FSzqTsPqSdu0bg5HH6j8fWqaGF6FPblZv2F4jostv6AaKWbSZXgEQ40LnvjQzbf5789P/w0r8CldVqHuGx/pvLvTMvOZnnW/gq8GMkSKrQAH+HcYemEjmX3iaMXxeiP2zv5MmnwoIdO2loQJ1ieChPuQR3nFRj8ulgeSUVbnlSIwJuSm9gBn/XLr/JQV2QfkXMu7eDCbDklig0y3mU4L/1uiuNbfbIZ4ze5bg=
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
 drivers/block/rnull/configfs.rs | 24 ++++++++++++++++++++++--
 drivers/block/rnull/rnull.rs    | 28 ++++++++++++++++++++++------
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 0dea92a9079b..71b38373be33 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -33,7 +33,8 @@
     configfs_simple_bool_field,
     configfs_simple_field,
     show_field,
-    store_number_with_power_check, //
+    store_number_with_power_check,
+    store_with_power_check, //
 };
 
 mod macros;
@@ -62,7 +63,7 @@ impl AttributeOperations<0> for Config {
         let mut writer = kernel::str::Formatter::new(page);
         writer.write_str(
             "blocksize,size,rotational,irqmode,completion_nsec,memory_backed,\
-             submit_queues\n",
+             submit_queues,use_per_node_hctx\n",
         )?;
         Ok(writer.bytes_written())
     }
@@ -89,6 +90,7 @@ fn make_group(
                 completion_nsec: 5,
                 memory_backed: 6,
                 submit_queues: 7,
+                use_per_node_hctx: 8,
             ],
         };
 
@@ -268,3 +270,21 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
         Ok(())
     }
 }
+
+configfs_attribute!(DeviceConfig, 8,
+    show: |this, page| show_field(
+        this.data.lock().submit_queues == kernel::numa::num_online_nodes(), page
+    ),
+    store: |this, page| store_with_power_check(this, page, |data, page| {
+        let value = core::str::from_utf8(page)?
+            .trim()
+            .parse::<u8>()
+            .map_err(|_| kernel::error::code::EINVAL)?
+            != 0;
+
+        if value {
+            data.submit_queues = kernel::numa::num_online_nodes();
+        }
+        Ok(())
+    })
+);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index a7c35f33631a..30de022146ec 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -21,12 +21,18 @@
         },
     },
     error::Result,
-    memalloc_scope, new_mutex, new_xarray,
+    memalloc_scope,
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
@@ -40,7 +46,7 @@
         OwnableRefCounted,
         Owned, //
     },
-    xarray::XArray,
+    xarray::XArray, //
 };
 
 module! {
@@ -71,8 +77,9 @@
             description:  "IRQ completion handler. 0-none, 1-softirq, 2-timer",
         },
         completion_nsec: u64 {
-            default: 10_000,
-            description:  "Time in ns to complete a request in hardware. Default: 10,000ns",
+                default: 10_000,
+                description:
+            "Time in ns to complete a request in hardware. Default: 10,000ns",
         },
         memory_backed: bool {
             default: false,
@@ -82,6 +89,10 @@
             default: 1,
             description: "Number of submission queues",
         },
+        use_per_node_hctx: bool {
+            default: false,
+            description: "Use per-node allocation for hardware context queues.",
+        },
     },
 }
 
@@ -104,6 +115,11 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
             for i in 0..module_parameters::nr_devices.value() {
                 let name = CString::try_from_fmt(fmt!("rnullb{}", i))?;
 
+                let submit_queues = if module_parameters::use_per_node_hctx.value() {
+                    kernel::numa::num_online_nodes()
+                } else {
+                    module_parameters::submit_queues.value()
+                };
                 let disk = NullBlkDevice::new(NullBlkOptions {
                     name: &name,
                     block_size: module_parameters::bs.value(),
@@ -112,7 +128,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     irq_mode: module_parameters::irqmode.value().try_into()?,
                     completion_time: Delta::from_nanos(completion_time),
                     memory_backed: module_parameters::memory_backed.value(),
-                    submit_queues: module_parameters::submit_queues.value(),
+                    submit_queues,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }

-- 
2.51.2



