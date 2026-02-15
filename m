Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB83FE63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6916B00EA; Sun, 15 Feb 2026 18:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060A96B00EC; Sun, 15 Feb 2026 18:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF226B00F0; Sun, 15 Feb 2026 18:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49A026B00EC
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:47:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78B411A0B92
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:47:13 +0000 (UTC)
X-FDA: 84448329546.25.5464BB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8FFF440007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:47:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEShHWH1;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BlVqh9QYm+BlgPCpei70yz4fKzBI6jW+8o3dJvhOpo=;
	b=RV/iwsyKtPzYltNX8R1+neRPR/VafnQRx90TP9elJ85Pta5nmDSgIFvYMByFWZxKLRc0tb
	Ikebx4ApBjAXyOp3tya69OSEKRg6PGnn7F4C2tgyARZJHPCDOtHGvTN9HtVkU6JGfL8Ft1
	vu+tapNF2CQQBlDoeRrP2+UuoCPfDlo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEShHWH1;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199231; a=rsa-sha256;
	cv=none;
	b=t3fMTeYhFt2HYchwMUPVYRVVAImDTw5/W6ZVrK1+QTvg9/wEmD9dnPC55VblImd0VqXzS+
	u4NNSj7tGxXE94lnDNN0QBNz7MsWELK+3MtpTqZLilrXIIY1qMyX0EcYgRiiUUUqIOTGjX
	FZ4JLoop4mDxYA01FfWWSIBLVoeF6yA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1C97431CF;
	Sun, 15 Feb 2026 23:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BE5C4CEF7;
	Sun, 15 Feb 2026 23:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199230;
	bh=0D920SHw42YiR49yYlbJhJD7PJMrwKoVYcH+BNnX7MQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fEShHWH1UvscSbdGktUgMloxWJWkyUCQj3znuqiDrFTbtn6av7N2wWRjQLUxyE9rb
	 jy9mjY8bK3oaMtiuEnib6D/O6wthIYzd+5PMm+ou7WJexXr8qk8T6vGwvDQ+ueciPC
	 imNE5o+5NO39dH8E5UssFNyMSsabrmiR5UU6QKOI4eLN10q/4jEWCzfNNCiZ1E4Y7S
	 ucnRpLXck5OjLMwjgMl89cse59c1ZZ2nWyGG+zYdDidkOigAw+4SxPNvz1I0RBlOh4
	 rB3fum8FwTBjF8wj0QEsF6qZDl9tXT2ajlbM5mnmQJGTOzOv1BuE5mG7fG8NifUg3O
	 dZotY7KQa6uLQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:36:05 +0100
Subject: [PATCH 78/79] block: rnull: add `shared_tag_bitmap` config option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-78-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4667; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=0D920SHw42YiR49yYlbJhJD7PJMrwKoVYcH+BNnX7MQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhiKZrX3/G4pA3JkHu1CIOx58kApLAWljhDP
 YWOJYIICo6JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYYgAKCRDhuBo+eShj
 d9SlD/9RmbXJFOgg9x0t/IP45eYn4VRYOpP8Ba54ODjKjkD838myUazuaXpFlcFQXsHueu8qRmy
 7vh7NOH2AWPtw8AzQWr05CAjaM4NYWoCMtyr3+nufR4dMnWXLvYi3gxoXla2QriJWBlzlP6vuF3
 3U4mAivhbzhQOVyfNF3ZFP0hd9mGj7MLd37B4CePJaQb7eNRjp1liLDNSm28QZb73E0wrAGEYiv
 gfA5b8Q+DHEoRn9rF22rzxwJ6XouTsZ9iA/48QHS8iE7w+AhOCpAfxDwk2rqX6wH6NPLklduGV9
 jq8ar4HB/jervqMppRZNtIv4/qwwGybA0TEP/gEzKO8qu3ScUqEtaWlIZrz9vyUxDV7voQZybPd
 3ZSS/StzDmlux6ZmM/tBJDxyHh9kDRIFMqMhroe40bPk2HaedNo93JJOu56JylGRvGLDBeAJ2KR
 0rsTkdh1rbLBpxH8/UikssDCRmti5wvgxOzzhW5dv/icaTXJqcbwN87USsY5tlGqUQ22jqdxtEl
 VmN1pUHOJrWPaLx5yUFlTPY6c0EW+dwmj6H9GqsqXXUnD2s7nyJDfkkz4g7oyVg5mP7QM8Yix8j
 ocWTju9O6PISgpRNPZJYKht9iULsjgpcnJe2hcHeGtFYQLHp9Dy+YRTdxes9hO1W8sZgbI3fymU
 KhBc3lLbvPB0bFw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 5mjbbxfw4odc88jacs7exy948jy97u5r
X-Rspamd-Queue-Id: 8FFF440007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771199231-982566
X-HE-Meta: U2FsdGVkX1/kWZommPu5rIVrvUHddY+I8ZrpEH58gblz/tqLYRV/1LJNSLiIkGxVkhYXfmM6sx1qLxUFLPk/0aQO0aIGEGY4uH6G2zgcKd2fTJfUdcNhK2HDowKgY6Caha9xnV60gNdzSCvzcLuCNaJOQQQyN0vIr1h5QdRE46S5akr580Ch/LK/3Lsk6o9IQUUTkIJMpITOrZE9ZLsXV1kBu4vRWX4vx4MX/BS0iWUPpSWfqK9lTa6LJzXl/TAgDxC2A7NwerkMVBzS8gI79iAckjqdOv1HKCwoj4Fhws3yVrSourHPT/SmX8F013L1g86IbtgdsuCUmyLbbi8RaRGVMm2mh3iR6NUehCa3xsE1DdhavH+/CUBdQjRQ61sssFgyaqD54sfFxLLI0LcvQclTpjjtoyJ3I+a5mQ68B+j10rSH+n8CxBXRVCAE6KMEUgPAhUz4X/0ddJOHUn/ONHgOzHtVnArsVLPvAIRPei5C8V0MhAXUzCwDR3SYsvQdpEInzD9GJjArepjQABydkDISBtxTltZCdr1EGpW2dXFCdQ3e6G6jIX2ipADiUg8MzAVYVMRz6LGv0TPTvfoGaUNQvnjSYub6MePiwiAhgEFoMLMLtCK2Qz0a9Wvim+IjR9ifbeLt1I+pMMs34Bst0TnFvNUlgIdYPwrx++sBGGXBM9C+1mLl6tJGeAd7W0NwNUocLjw7P4UJuBQUMUH0lCImczUHWOZLutlVwC90i3DoLHUNDOf7smM68Yw2BopRadVsMvVFGGY6r1hyuGZHgI7oxpiTc/7L9h0ybJF2vPTOBCqAI0jswCe4oJIMtmZPU384g4P2YhtWCwkG/Q4X2OSNJUDOkOom1pwBPZUddShxN/2uhF8YJh2GefWvOSZac7w9oBrTaculTutM3MFBpobYJi0HdZUQC4bHr/dVRwJ+4AGYY7b2DvqLWoWA36MU9BybfxzW/8YTXluL9Vl
 mo+DQGv2
 1G8ud6fkl4iHRwOer4eoTwc6V+wZDHaQgY84PtWGzsCGBs2T04cIOU8sQZVPBVR9Ojs6kLn9WwgDzBjrEzt2m+UEF+BiRPHIBfsv3B9hpjogtVS0hgdlM/kS5p/xYxy2/NieZGxjbWHXvn0hj1EK42mTOCNzR0mPfkUoCzXWX580/9Vy7BKwgAfPEOfQt1nNkzMqzSgAhv+zuSNZn/H+iADcGO8rXBFCUs8ulmTYbQ3gxP/9zeZHua7PG89GsIkrJOjUms7Ht+XT6shgeWTI6LD24kSS5tJD8+QpcD8cjj/29RGf/W+Ho8B1ZFt/6U0RqJygXr++n3anR1SJ42NbZkG4fb9lffAFGAkULTQ882Nn7+rE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a configfs attribute and module parameter to enable the
`BLK_MQ_F_TAG_HCTX_SHARED` flag for the rnull tag set. When enabled,
a tag bitmap is shared across all hardware queues.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs       |  5 +++++
 drivers/block/rnull/rnull.rs          | 11 +++++++++++
 rust/kernel/block/mq/tag_set/flags.rs |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index 8b9ad8a1a243b..395da68d96dc6 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -124,6 +124,7 @@ fn make_group(
                 fua: 28,
                 max_sectors: 29,
                 virt_boundary: 30,
+                shared_tag_bitmap: 31,
             ],
         };
 
@@ -212,6 +213,7 @@ fn make_group(
                     init_hctx_inject,
                     max_sectors: 0,
                     virt_boundary: false,
+                    shared_tag_bitmap: false,
                 }),
             }),
             default_groups,
@@ -296,6 +298,7 @@ struct DeviceConfigInner {
     init_hctx_inject: Arc<FaultConfig>,
     max_sectors: u32,
     virt_boundary: bool,
+    shared_tag_bitmap: bool,
 }
 
 #[vtable]
@@ -355,6 +358,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 timeout_inject: guard.timeout_inject.clone(),
                 max_sectors: guard.max_sectors,
                 virt_boundary: guard.virt_boundary,
+                shared_tag_bitmap: guard.shared_tag_bitmap,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -634,3 +638,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 configfs_simple_bool_field!(DeviceConfig, 28, fua);
 configfs_simple_field!(DeviceConfig, 29, max_sectors, u32);
 configfs_simple_bool_field!(DeviceConfig, 30, virt_boundary);
+configfs_simple_bool_field!(DeviceConfig, 31, shared_tag_bitmap);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index dfdb56bd76f52..5bf965908ef63 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -218,6 +218,10 @@
             default: 0,
             description: "Set alignment requirement for IO buffers to be page size.",
         },
+        shared_tag_bitmap: u8 {
+            default: 0,
+            description: "Use shared tag bitmap for all submission queues for blk-mq.",
+        },
     },
 }
 
@@ -296,6 +300,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     timeout_inject: Arc::pin_init(FaultConfig::new(c"timeout_inject"), GFP_KERNEL)?,
                     max_sectors: *module_parameters::max_sectors.value(),
                     virt_boundary: *module_parameters::virt_boundary.value() != 0,
+                    shared_tag_bitmap: *module_parameters::shared_tag_bitmap.value() != 0,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -352,6 +357,7 @@ struct NullBlkOptions<'a> {
     timeout_inject: Arc<FaultConfig>,
     max_sectors: u32,
     virt_boundary: bool,
+    shared_tag_bitmap: bool,
 }
 
 static SHARED_TAG_SET: SetOnce<Arc<TagSet<NullBlkDevice>>> = SetOnce::new();
@@ -425,6 +431,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             timeout_inject,
             max_sectors,
             virt_boundary,
+            shared_tag_bitmap,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -437,6 +444,10 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             flags |= mq::tag_set::Flag::NoDefaultScheduler;
         }
 
+        if shared_tag_bitmap {
+            flags |= mq::tag_set::Flag::TagHctxShared;
+        }
+
         if home_node > kernel::num_online_nodes().try_into()? {
             return Err(code::EINVAL);
         }
diff --git a/rust/kernel/block/mq/tag_set/flags.rs b/rust/kernel/block/mq/tag_set/flags.rs
index 1fca4fcb4dd20..cc5f54781cfd8 100644
--- a/rust/kernel/block/mq/tag_set/flags.rs
+++ b/rust/kernel/block/mq/tag_set/flags.rs
@@ -19,5 +19,9 @@ pub enum Flag {
         /// Select 'none' during queue registration in case of a single hwq or shared
         /// hwqs instead of 'mq-deadline'.
         NoDefaultScheduler = bindings::BLK_MQ_F_NO_SCHED_BY_DEFAULT,
+
+        /// Use shared tag bitmap for all submission queues.
+        TagHctxShared = bindings::BLK_MQ_F_TAG_HCTX_SHARED,
+
     }
 }

-- 
2.51.2



