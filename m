Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29294E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FA16B011E; Sun, 15 Feb 2026 18:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF7C6B011F; Sun, 15 Feb 2026 18:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80ED46B0122; Sun, 15 Feb 2026 18:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87AAD6B011E
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:56:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5201E1A0B81
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:28 +0000 (UTC)
X-FDA: 84448327656.28.2F32EF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9EA62140007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tt2dauBM;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fB9hIk3t3IAfWgUpFRD4sCToQfZT9oNE0OxAgk6pfw=;
	b=RyfcKLy7VRiybH9q4FsMhMNds7MSsUUVQLPm0ixGO9YE36Rkpbs0CJsV5HmvbRC02T9N81
	6TZUqfDzjcsLPTwt0+VBksWWPrgZ0JEybhPuPTz75s2XEs8693c0F+T4AwgzYViPQuKVZb
	X26BrgsONt96N0LAd89Yg1L9aZj+EdM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199186; a=rsa-sha256;
	cv=none;
	b=5tRyXzvraWa7VTw7lHYj35K9lMYGi3LnZHLsz6FGOGNCxZMX8wlZTMFaqlpRhBtH9lipYF
	1qcy0fvNkyQK5Y+qbPYkE7RQVaMd1pbKGsDvtexxHhBEE804qGZM252OFpGstse0fOwVoa
	UWpr85vbk+xVg2wckKSl0Pu4ci4IDUA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tt2dauBM;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38D8F6013E;
	Sun, 15 Feb 2026 23:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980BCC4CEF7;
	Sun, 15 Feb 2026 23:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199185;
	bh=KwNsjS9BksChOKWlphQ7tBX5Ukevdabgk4N9RSuoPnU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Tt2dauBM/91ZcwHIxNjZy56t8ADRDk73M1R5xgyoFIhLuLmwJmT3LGC5PHQHKrRZU
	 UHEMd0NMajM/5cKHDRp50D0h0NngwdfrnD5Gap/LYFz1aW9lktQkW8EPg9j97g9TwP
	 Gcb8+JNOW7U8Gxsr5pJ6Cq+V9Xbmb2v6c6s7Ub6pAzjGLbpJWQ2f1R62YGKpCAVWME
	 ICQIpspC0YXkYRMeFUPjz+mi3UBrNgjteaVDgCAYR7/+xDO0EFkYlXrYxMG8M6XdCX
	 ZLiSWePHfLfXqWmTb9XyN4MPms6F3pxrawtqc67a6UB+m9/r6Vz5lWyEkj8CLW4v1b
	 SGGBfz54SbOew==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:28 +0100
Subject: [PATCH 41/79] block: rnull: add blocking queue mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-41-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4047; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=KwNsjS9BksChOKWlphQ7tBX5Ukevdabgk4N9RSuoPnU=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhAAmONZuTCFAmTy2QHtO/6KeA3aonRqhccD
 uZyYAiEM3SJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYQAAKCRDhuBo+eShj
 d/SdD/4xA7LPhW3edXP28x48xx8Oy40JA8mu40mUSF5x2Tm15UWJyOC4BFixM90yuvg4wTo2zbM
 5FjABT+A3GA1+BGStHP8qJFkr/LlankpKRWlAp5QS1fwzoNxiFBtmAzXpEppDrjRCdjb5IO+sTn
 0A5pcAJmZCRVPib8vlo5SxL3+A2VBpRxM0BLRiKqgmwDOUoeJxUfMq64NTn21Xyg7QpFKiJuIG1
 U5KaR5sY1hftYG38q+wQr2sVXEClQ1+x26DhrIsrneB9Rfr89n36u1ZtawLYg6R64d9xOgsz5Dy
 CN407ZNK5zGV4OjZVjkHlDK8n950RY/ZRevXXR6IOe07+ymK9yx311faO5rpu+VWEdxBKR6QT+C
 TWIxrxkT60DXJreOUhL8cnuLfgOhMx6hTBZO0ymjY+kULDyHYZ30QgZxVZkFfNywjxSUCGOMGXK
 o3jxI4/LUHD8A0tZF50UjiewRjVny1ZvKe5ToPQsRynbkxfzyJrQR07uq3QraGzA9ePn3bn+nZc
 eFBxwbD2XGyR2cwVAf4hjpQBQjj1GpldPiBqwUSW7Ar7j7kRG0+gGjaB+Vh6HRMAZwRt5Y+Ly6G
 SBJo8EI5oMVDXucaXmjm0FLx6TtARqzZXTGvr5SW1QfCF7UgcJGhNRr+q7FqMGqdJWkl+dMoRif
 og+WAb8NDQS7JeQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 9EA62140007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ibh3gtmadkkhpbx5qz3t9cjg4cnk5kgy
X-HE-Tag: 1771199186-560401
X-HE-Meta: U2FsdGVkX1+/oQpCgQwEGNN1hCDdQSTqrFm9K93rLXHIWiw1QJDiCigF1/EvFEXxsEO82VyqhT3U6jeRJAR9Km1aP5/1+W0PyJyIXxSKl6AZEZJJTSJ1baJz8wJerLEOmx0M6WsPDHo7M0qWTBADPiNQ+pKihKBTidtznmBfbdt6Q1WhWDjVB4d0t0ZEHNgX+6+8HhlcNfbAmVhuPJgy7Rx7QXCyrevwmiVHAISVSTkJrUUMiAdSfRqfz7BgKTszhWndzPnyMfWJQ9wJrPsFtBvINQ8/x37dNkt4+CTAb8hlUv18MDPtBQxBR0tP/BtYG16kBgFFOqgh2a9H+ta3Z4/OtYcUadPYFT4ysP4l2XZfQS3nw6BPNtVtpj5VFq1+CYUXGxRLw0r/yxqiQPKAF7htvC2pRAcYqL50Y4uToEgpNlP1Yx+QyL7f8bvNdEyUQGyQggZ91n9Li8MtH5W8VCMu+Q+el6mRXJlCh2lCgPPqguI+BPpTnQ5cN15RglhHp7MosGR8uiXyXS0Y0PyRxHGcxC7d8i5F9zCxm/X0OHUwuv6625Sl9j0OFks+niwj96b1De+Od65Ew5AdjVAx2TUlnnYsIS6uEqyZlzGoBfvhVhS+fT/WvgwB/0xO0+h+vkUkiJhYB/VUCmJ464LG5jZIr4Ho8SYDBzY4CgdBJjbsc/PdpadC+Gn/R9gseDCRLIUGYBuNu+hXcihy3CXozKaQAqErDDei8jl4nVKxOxT6kuiCo1uk0OMEnqu+NFXd03K/s5GLykZxRqwrJZ6oBeJ3Nl1p/UHY1KkOBbHwF1F+sGIroyGLxAx7QBAbzecVo8atfCtOGS4YZD+4rilB1VUdV0CocW1ev8tSuc6xh0z29L5v5zla1QWASXkdNH/ohIwxC+qsRriEQFPbbBBhEXbw5Z+U4s5lWRmjMeVQ2GajrdZokJoujWrELKHAZl0qfHH/Mgj3Zafu23KEG/m
 oGUsHugA
 Pg/YmYF4Cz/ADrotpqGd9zWQ8q8y0p2mgQAbUds3Bg29cdZIvfuBcQm0DTCVCPje8x6momf9h8KXfJhKU+5BR87oVZDocJVwEqI6XnnbMTSw7/ixBWCCi3JOe47ZpDsslr3es7K9NJvIUPriI+0BaLcpdmsFyzEdPwGWd/3U9HN+cb9MpG8XUb4Wpb97o2rg1vWeln7uo1shj4r7UO49n7pnSkr2txupajoya1uW+yUWDzqI2TL2qFGpQDKPswlz/3JcnQFPM7zTkg5Z2sh/8eRiu4hHsZyKrWd/0ZI4ajHuAmOWfsoiWBpw7vo4PcZKNHYxP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index d369d8b683c61..640e3de230c0a 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -70,7 +70,7 @@ impl AttributeOperations<0> for Config {
         let mut writer = kernel::str::Formatter::new(page);
         writer.write_str(
             "blocksize,size,rotational,irqmode,completion_nsec,memory_backed\
-             submit_queues,use_per_node_hctx\n",
+             submit_queues,use_per_node_hctx,discard,blocking\n",
         )?;
         Ok(writer.bytes_written())
     }
@@ -106,6 +106,7 @@ fn make_group(
                 badblocks_partial_io: 14,
                 cache_size_mib: 15,
                 mbps: 16,
+                blocking: 17,
             ],
         };
 
@@ -138,6 +139,7 @@ fn make_group(
                     )?,
                     cache_size_mib: 0,
                     mbps: 0,
+                    blocking: false,
                 }),
             }),
             core::iter::empty(),
@@ -203,6 +205,7 @@ struct DeviceConfigInner {
     cache_size_mib: u64,
     disk_storage: Arc<DiskStorage>,
     mbps: u32,
+    blocking: bool,
 }
 
 #[vtable]
@@ -243,6 +246,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 bad_blocks_partial_io: guard.bad_blocks_partial_io,
                 storage: guard.disk_storage.clone(),
                 bandwidth_limit: u64::from(guard.mbps) * 2u64.pow(20),
+                blocking: guard.blocking,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -462,3 +466,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 );
 
 configfs_simple_field!(DeviceConfig, 16, mbps, u32);
+configfs_simple_bool_field!(DeviceConfig, 17, blocking);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 16a4f915e59f4..cfc00c104d9ca 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -141,6 +141,10 @@
             default: 0,
             description: "Max bandwidth in MiB/s. 0 means no limit.",
         },
+        blocking: u8 {
+            default: 0,
+            description: "Register as a blocking blk-mq driver device",
+        },
     },
 }
 
@@ -187,6 +191,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     bad_blocks_partial_io: false,
                     storage: Arc::pin_init(DiskStorage::new(0, block_size as usize), GFP_KERNEL)?,
                     bandwidth_limit: u64::from(*module_parameters::mbps.value()) * 2u64.pow(20),
+                    blocking: *module_parameters::blocking.value() != 0,
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -218,6 +223,7 @@ struct NullBlkOptions<'a> {
     bad_blocks_partial_io: bool,
     storage: Arc<DiskStorage>,
     bandwidth_limit: u64,
+    blocking: bool,
 }
 
 #[pin_data]
@@ -260,6 +266,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             bad_blocks_partial_io,
             storage,
             bandwidth_limit,
+            blocking,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -267,7 +274,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
         // TODO: lim.features |= BLK_FEAT_WRITE_CACHE;
         // if (dev->fua)
         // 	lim.features |= BLK_FEAT_FUA;
-        if memory_backed {
+        if blocking || memory_backed {
             flags |= mq::tag_set::Flag::Blocking;
         }
 

-- 
2.51.2



