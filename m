Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F7FDE63F0D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 02:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D306B00E7; Sun, 15 Feb 2026 18:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867D26B00EA; Sun, 15 Feb 2026 18:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769FC6B00EF; Sun, 15 Feb 2026 18:47:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18CE16B00E7
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:46:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85B7F1CB87
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:33 +0000 (UTC)
X-FDA: 84448327866.19.35FA1CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BDAD3C0007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HgADxpSr;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJhU3eFhlQZTpOH/Xxyp9EbBkRyjGFlUf0JPoyMHZ1U=;
	b=qDjYR7kChoVdXCvSVG1KmG9sg/ZKrls9ii6WN7sgrX6bqGORTlUeEIA0l2r4tTNyXdcv91
	UZG8bFTTzXGNDh+7DZpSoUIakXt/wI36pV4QwInguLivOc19qCWZtxjs+9UtWmjbhgDB7K
	D9pYtCOStUMhbTKr7SarA57FeKcgQYM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HgADxpSr;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199191; a=rsa-sha256;
	cv=none;
	b=4BN+yNtIGqJOYKtleTZPEeZlMIINM3W24XPgD9ef3uxy76FCFJ4ZLzBUYEID+HnSDSY+Pg
	vSKd8LrZfWzPEzGclcGVXmndjSAi9E9PSLsF15SYI9cdJlmB5wR0HtWVcFmxfwDB4bFMJg
	upFpCL3WYTwjYIWYyGcHDcQwCoswsPY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 030064081C;
	Sun, 15 Feb 2026 23:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADCEC4CEF7;
	Sun, 15 Feb 2026 23:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199190;
	bh=APKT03ZiQU135E3WUwHyPYiO1viCqNZ5coeNcIBfq84=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HgADxpSrEK++iloNXm0dnv+lPw8PVJH6rkUFydSeWsUY3/vjJ7KQzLcayU1lcgIjr
	 Peoe0Ghk8slIlwenivzdI5Z6QI8vSefKN+hFcJP6jzjYtIgsAeOKMWu/0t+9ZJuQIj
	 XCQLAuAavYqo3FyRh5jcob4tOdrSrvbSF4RENPBNaaDOMqUUeWvZ/0TKFKyIiU+pJD
	 O18RmlfqA+4HUxYEuKNhnpZ5vDSHmiK0NsYqk6+hv+50SW70K+hNzCSrRxcq6JoaWT
	 JSNm1Zrr9uRP9arGCa9VkHkv/EBo++kVwqlNVSww3kjVdNqTAqizOKVS8jGJQyiuBf
	 3WUMyModOsOLg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:36:02 +0100
Subject: [PATCH 75/79] block: rnull: allow configuration of the maximum IO
 size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-75-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3986; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=APKT03ZiQU135E3WUwHyPYiO1viCqNZ5coeNcIBfq84=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhfgXdxK7ttXIOY8hQZaSYd5Mu4euKOGaiXx
 5uLWTbYb22JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYXwAKCRDhuBo+eShj
 d40HEACZ5T4gkVkYvJNBnOSrIznKGWvjkIyhCyZHxOH9+g7Y0MC6tHeoEYprX5ajdXLwiM57ykV
 20YFMSaXWARI/zRNd0iBhRfr2sLliHiEAjhALtiU/exWz84ntqj7x91LQfT68LO2ssjRBhvqW2O
 DYM9rEfZqTmuCK1cBFkFWPAmcZ0xaZGncNLwz5sK5mgrlydVPiYj/rjQI70Jk/IozMq2lVnn8ol
 mdx4uQnQ6SneDipQdYxwbHO5fULYmB6KzyVvu/7H5J+nKpwyvJZj6AoJ3XcnutJNMuIH9TwLrH9
 DzM6h0CHQI0Oufl1qnf8mZ0cV/pnKKCPE6LftOZ1rAFQ6rvKJPVBOJWLxbJlIvlxqOERfHWyGdY
 QV+1Bt75TnNe2nufG3fkconWds293dATdw0C625tXnqC7ybMqWuXCYY9v9aRm7GQ/r/814TuHGG
 SljZZ1Dh2d+I3fl2I0exPjJAREe7FQ6nQVggS7sh7w94+g7oypSNUz/QNrm3VnCZE33gkE+/QM6
 a6cDED5Iqkm8vHEkr0+kK9cmufDBHfU47j+XDBLPNTi5Ro7t0T5tlFbX6ee8+kGftqnU2/p5kN0
 wmpNcSwKJ7vTiJICdhewvzxAlmuHHosKs18vhHQ0/PTGuknXPTOBLb1Ef7+fdJ7ZIsCadz1Ry0C
 ilaIYwkI9anAQuQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BDAD3C0007
X-Stat-Signature: cchanzdk751kcz64icgnu3set6zbi56z
X-Rspam-User: 
X-HE-Tag: 1771199191-682012
X-HE-Meta: U2FsdGVkX1/e6sDON50OpF5lp41hd4nS9iXwjYoDTM+KWDh9LOxLA2cKdStqcDmCIgvgvw9jXzrY5tblIUES9PCDV3jq7OeOWzeo1sBm19GUd5tj1A+1k4WuyXx8c4ZZxY7v1Yt3j1NLZAlJ9q1qwHMw5kYk1ETIabPllliZpqfPu2DV5xLAVstkhmC6JYtAoqSl+hbW5bKs1DWPIIeC2Edqrc5Czh00bnMrcTUFzEoWJyfRMfjZkPrT+U8joop8+7MylJ/gDoqPxT5usL5QHXN4N3sKCSucwEuiQ8aeFuD8O/tA+fIEDLp9wymflQ46oBEVJ/tl9c9qli+TkMgoFGuGhY10rI4sBQ6OuSfgqSc5QHjTszedqLL3artcU1bjmy+zvKlfg8gg3G7qnBwWyoSM2rVsI4jYGcTmblL1ufXQqdlmF6gZM2WNyJb3CV0PN8vZ4MW9kemc9UYamItPdGNr3YymAtmB4VHhZJSOt1KtoEiR/bRtKbqiDNRzgjdpSRuL2Fnj9nGFcvsbZrydw3ofyp6aZMMYS4vbrQA4Rogp2JH/lnp/JBtpPsWkWDfHvpPhWaB4T5M7daHQrl+dEaNKL6uC5FjGcGIwf/Dy0Ss+v8aeOdZvu1jXlerO/iVT8gM+6UT5LqgoLr87il5B5aJ9486dsCmWQc28dDHSmp7EBZMS0Uue03v+b/JKdvUG8O2+7aOb0UIM/Rel4lihGzeDpb1nEyE0ybZNstJ6HylTV2p4ItGTAvb2lGUN+o8U/EtMy+EOkvv10gf6mrG6DpgktrgFdll1JQGLdfltkdJbJVUkJssJCQiSBUDqUlCW0UKKGfpODM5hRnhHTe4OYd4vPWg4ImueMIJ/gnjc9G6cbd8eZqp0eORpv9/c1ivoQcNd0nRH4nBmae4vVGU1IvrqbxlKFntd+YM+olyvT5EPnEhzsxecvVITn8OQlrC0689shgKkK6yy1eI/htq
 5H+tFMoD
 vNl01c4MuYmkqBihNUmPDrhjsZooSYGyFBuQnj6UbUtVe3bydr45xmSqv2f0Q7LWWTXcPLEtcHr/voJ97Q0biUhZ9QLNt+NUNUi8yW3iKdErYwmp5SZvZrLgZKVQN3c44cYjHkOpB/BDCnkPf7aYxxgC0oHpB34u1oAPSuxrd7iyEcdj1KS0Z7X+gmd17WWlT9qeEGGt7YwjsOZCcqdkcHScFTBvmpJT085qdtKorEufLktY7im4n7muwgjwBwHguSWv/Abtlz2mSCUGH3LPlYUaurPOLPSjSqfxNK7UOEMuv5DuKmOwhaGHWUfL0O26DrrDW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index b449ac882d961..9eaace8b4257e 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -122,6 +122,7 @@ fn make_group(
                 zone_append_max_sectors: 26,
                 poll_queues: 27,
                 fua: 28,
+                max_sectors: 29,
             ],
         };
 
@@ -208,6 +209,7 @@ fn make_group(
                     requeue_inject,
                     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                     init_hctx_inject,
+                    max_sectors: 0,
                 }),
             }),
             default_groups,
@@ -290,6 +292,7 @@ struct DeviceConfigInner {
     requeue_inject: Arc<FaultConfig>,
     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
     init_hctx_inject: Arc<FaultConfig>,
+    max_sectors: u32,
 }
 
 #[vtable]
@@ -347,6 +350,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 init_hctx_inject: guard.init_hctx_inject.clone(),
                 #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                 timeout_inject: guard.timeout_inject.clone(),
+                max_sectors: guard.max_sectors,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -624,3 +628,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
     },
 }
 configfs_simple_bool_field!(DeviceConfig, 28, fua);
+configfs_simple_field!(DeviceConfig, 29, max_sectors, u32);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index b2b089a657f12..495a810f4f4e1 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -206,6 +206,10 @@
             default: 1,
             description: "Enable/disable FUA support when cache_size is used. Default: 1 (true)",
         },
+        max_sectors: u32 {
+            default: 0,
+            description: "Maximum size of a command (in 512B sectors)",
+        },
     },
 }
 
@@ -282,6 +286,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     )?,
                     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
                     timeout_inject: Arc::pin_init(FaultConfig::new(c"timeout_inject"), GFP_KERNEL)?,
+                    max_sectors: *module_parameters::max_sectors.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -336,6 +341,7 @@ struct NullBlkOptions<'a> {
     init_hctx_inject: Arc<FaultConfig>,
     #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
     timeout_inject: Arc<FaultConfig>,
+    max_sectors: u32,
 }
 
 static SHARED_TAG_SET: SetOnce<Arc<TagSet<NullBlkDevice>>> = SetOnce::new();
@@ -407,6 +413,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             init_hctx_inject,
             #[cfg(CONFIG_BLK_DEV_RUST_NULL_FAULT_INJECTION)]
             timeout_inject,
+            max_sectors,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -502,7 +509,8 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
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



