Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6520FCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5DC76B0088; Tue,  9 Jun 2026 15:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A358D6B008A; Tue,  9 Jun 2026 15:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9247A6B008C; Tue,  9 Jun 2026 15:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82C486B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:10:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 277A21A0764
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:31 +0000 (UTC)
X-FDA: 84861315462.09.63B926E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F2EBC0019
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyVfnxIT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/0/Vaq6P+ehn9fD0MH6e+Cla87NJ0pjAGFS/FD6Uz0=;
	b=zTVBOocVeeYD4+ffkVyyhz4fCb8JJY9P3y8ddD8OUNo5rM8Ymt0V2fxZ0HUdngsMmhGJQw
	FNgN451Ohr11x/Wv8FR/4e75pErkcNjuraVQEHZ15In1ZrLgjO9EXuzyu/VQcOIDLElrSI
	TyFL02xPT8Q6xrHU7emtYNdQ+622/5o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyVfnxIT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032229;
	b=g+p231mYHogX5BJqWrdPFhpIEgxuce4WO6Q5GDcbOETU3I29uKk8zGYbWC+Kwq9d7NHL40
	iIaoP+ikqrGUMGA9P1w+36GQNLitK0vBPkasR2aoNz4F0M+uLL8pDy0c9Zyk7nMopeL+bO
	5Ot4U/onEs2juXCGRU54fMaN+oBSnZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8003240497;
	Tue,  9 Jun 2026 19:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B611F00898;
	Tue,  9 Jun 2026 19:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032228;
	bh=a/0/Vaq6P+ehn9fD0MH6e+Cla87NJ0pjAGFS/FD6Uz0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iyVfnxITOTX17YdbikJ+OjiLKUylrJ+piLYQesB6V3/nNJ0TcR04Wh1F7wRvaDNTP
	 pbnXpydkDDpZm7HBeQKMVRrpWxoueQTtoYjkddxqV4k8yy0l5xZXuaVzvwaiJhTWya
	 vvokoPwjXD2EW+F/buj61BNjGL7VQ/XR2xMfWZNMTRKikwaHeF1jKNPBOJvChU1KuI
	 hhIooOt9bYl3ZbzXzBu+Iecm7FTafUB8N1sIleSSyQIPsBI1V9aV0tcJHdwod3kEQd
	 BOxPGksCSQqXwLLUwL87RVDIdNc/sV5JoEIj/orDNnRw8sGq9T9AHMbEhyxRB6/jrZ
	 /ZCQavcFjWhug==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:24 +0200
Subject: [PATCH v2 45/83] block: rnull: add blocking queue mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-45-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3831; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=YZ/AfN8Kndq1dH1klIaGEGbAb5qaoYZQKEwqGVYQjkM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTdp0x0IRIof4+hYdVikG2ZXkHe5WzQAFj+a
 fipjeP29fKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk3QAKCRD6UCkIqsW9
 0AeeD/9aLlgjZ/YxFTP6ATkG1QnKkssNiKjananf2paDujmui75oDOJ3XtOQ2+e6g0zWLX2kcr1
 UpmZ8N2wd0jDgTVnsWobBsGfGVPpbRt2UH42VQQTZARKg9PF7RxBZPOJdAFRdervRPIVVRjhd9r
 O0JF5jOwKslo9hb8uu/Cdj1rL8PMXEx6TMPUE5OwFjoR4wP21AI9vAVPvKOkdZEf1Zec5+nboXb
 4JdPTKYAdSIFEalOguSL3KTPMljFp0FKDBEAcSXvVudk2rrcSpidVhuek7Knoe1uojyFFVaj8jJ
 woGhhNWlnntQyVcGCdbkV+pDgfhEqrDF6Q8g7d8Nn1P1VbDWcMgt5ws83KUyS4Jgwg4YUUUH2gI
 bWlfm+OnGjNqTbd0o+h0gsKMXikkvLj5T6An3TeVaw7OWSLl8GuQVe+Ely/KppzmhGZgdHQHKSR
 BKYcTSWemqX+aFp5pj3IAvmhaqJD4xfZyoIuUJKV1Rn22pPecj0AcCpE70s6t3DXDsiYv/1Zptj
 Q8SXFlAqzvqpOk5zy5sXxcyY9Y0VsKWJrRbekkMZ9tmcefsc/C+snQhnBKpCbESQ4kqRULDn+tz
 yd9L2IkSk22YqTmmQDGEeTjDxLy+C6in/VrSNgQb5mtkjskynCMyCZvg6vGTPkDaBGdPyjqct7N
 Jjs6wnX/pYuGKZQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F2EBC0019
X-Stat-Signature: bs98n6okj3o47qf3jdhnp67whxgyyhcu
X-HE-Tag: 1781032229-16809
X-HE-Meta: U2FsdGVkX19rgEHIwwsW1S46clRnlTqyFS5cmwGi3gIMgPRovz81AR7+AM2kiegV/TsinUUxNsEY3pmFjgO4c5EERUT+63EVX2Ng9t9xYRBNSMK7oYBcXpt+3DYbSUw3sTILaomdVilLQ9o6vKgtP7gVZI1nINe+MON+61YcA0OuKhqUR8UZqYgpVIpgP+A19tiqd4d7113NiS01XpvqUrK9tshhgVQLIzEvgMRQEU7yzYTnCiH6UOUur7IAw3K+eJXCWeYj7yWKJ3YRXQ1wRSUq+qygqfdsZeTo4kasFZfhy/UdS0q1HF+nvoDxfUG7e55KUOzmw3L5/dHiLHxE3LRxfcvB0BINYXd09QfF+s3YNWLiwKJWYC5l4PNeBW4DZ6g4IrDDwUya4ETF9BtlV00bvegupgd49ucBPmyOQ2IpnvpQuMjivKYdRJJAThwBzorBBHJs+7UjV/rfAZD1G9ugQ7qGNErAx0Gmhcq7QxIKDp9QvQl/bXzf9MjvlevsW93qWyhXOKn8db5wJ3Xs3gCK0hSAF2LdgKt6Zwm9mFNiO74faEInU8NlfhKE+R3DEiNKOOA5GI1xwVi2qpsZPZKvsPtEGmu9/KHA8/9b+eKcdj7drmQn7DUzy5W/H3x3x8AZyUup9k4/N8h/2c2BbIou1TMKb54MJnG7YL6nEB3R9294riTnyJBTJrb1XWdQ/FRJ4Gy419Lmy6C3Gsg8eYaZdVfa89ZYKnBhx5e+9NBweVoff5JOE6tifN58TOpOCDL96dnA5CHGxdHe8oNz4t7ccMezmOHLymq0ONm4GzZFGUcn2fJent7RuKGeasKEIPoz4CWX9G7s/R9m/IMUdJ0x2V/JZP+9pl+I0s/lyAx73Lm3YG9cYtAt9H+RurLfc51us3kBpvorIWJlXdx2sQjoSLPGA7TtMPW2l+zIPYXUYEQ4142m2lU3zmm4zBmRAbw9DI9qOaChaDTH1tS
 DqVEcjD/
 2lva6O2vy0rgSGiYpEWtebRocFKrdrUhRaUhu3CQHDDH6jcygXAVQHX2es3KTT6hZL30Skts3tNDlUApPrDDXkkaR5nzm6ugSFoaeb7SUSbWZ9SAPpQVL3+7uFuOP/SS1hY4aoAx1cOHlSk5W+hh0zWgZ6ILJyYn9Mpc2ruDOkwm+qQ0Uz03rQeNL8CI3NfNzrcpxiHnvEyxS3F0tDdypb3uMg3AXH2KHD28a4MOgS/8JCQyL76jrQEyD06d5nXcC4wt7VxxcAKpFnj9286+Lnd6U0fVaVJpXJnp/qF92IYTl0fQTnn0kY0K6X6IxwGD43eB7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for blocking queue mode via the `blocking` configfs
attribute. When enabled, the tag set is created with the
`BLK_MQ_F_BLOCKING` flag.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 7 ++++++-
 drivers/block/rnull/rnull.rs    | 9 ++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 59217d75f46b..5e6bcf9d31d8 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -69,7 +69,7 @@ impl AttributeOperations<0> for Config {
         let mut writer = kernel::str::Formatter::new(page);
         writer.write_str(
             "blocksize,size,rotational,irqmode,completion_nsec,memory_backed,\
-             submit_queues,use_per_node_hctx\n",
+             submit_queues,use_per_node_hctx,discard,blocking\n",
         )?;
         Ok(writer.bytes_written())
     }
@@ -105,6 +105,7 @@ fn make_group(
                 badblocks_partial_io: 14,
                 cache_size_mib: 15,
                 mbps: 16,
+                blocking: 17,
             ],
         };
 
@@ -137,6 +138,7 @@ fn make_group(
                     )?,
                     cache_size_mib: 0,
                     mbps: 0,
+                    blocking: false,
                 }),
             }),
             core::iter::empty(),
@@ -212,6 +214,7 @@ struct DeviceConfigInner {
     cache_size_mib: u64,
     disk_storage: Arc<DiskStorage>,
     mbps: u32,
+    blocking: bool,
 }
 
 #[vtable]
@@ -252,6 +255,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 bad_blocks_partial_io: guard.bad_blocks_partial_io,
                 storage: guard.disk_storage.clone(),
                 bandwidth_limit: u64::from(guard.mbps) * 2u64.pow(20),
+                blocking: guard.blocking,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -422,3 +426,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 );
 
 configfs_simple_field!(DeviceConfig, 16, mbps, u32);
+configfs_simple_bool_field!(DeviceConfig, 17, blocking);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 1dda8d717b95..181fce551a91 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -139,6 +139,10 @@
             default: 0,
             description: "Max bandwidth in MiB/s. 0 means no limit.",
         },
+        blocking: bool {
+            default: false,
+            description: "Register as a blocking blk-mq driver device",
+        },
     },
 }
 
@@ -185,6 +189,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     bad_blocks_partial_io: false,
                     storage: Arc::pin_init(DiskStorage::new(0, block_size as usize), GFP_KERNEL)?,
                     bandwidth_limit: u64::from(module_parameters::mbps.value()) * 2u64.pow(20),
+                    blocking: module_parameters::blocking.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -216,6 +221,7 @@ struct NullBlkOptions<'a> {
     bad_blocks_partial_io: bool,
     storage: Arc<DiskStorage>,
     bandwidth_limit: u64,
+    blocking: bool,
 }
 
 #[pin_data]
@@ -258,11 +264,12 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             bad_blocks_partial_io,
             storage,
             bandwidth_limit,
+            blocking,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
 
-        if memory_backed {
+        if blocking || memory_backed {
             flags |= mq::tag_set::Flag::Blocking;
         }
 

-- 
2.51.2



