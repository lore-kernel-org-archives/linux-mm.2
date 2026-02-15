Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DAFCE63F1C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12C16B009B; Sun, 15 Feb 2026 18:41:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7AA6B009D; Sun, 15 Feb 2026 18:41:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09E66B009E; Sun, 15 Feb 2026 18:41:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8D3C6B009B
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:41:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4B901B4F34
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:11 +0000 (UTC)
X-FDA: 84448314342.13.0EA9420
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 294AC140007
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aOYNkd/v";
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5S5vE1SITgcGVigQBSBpX1RdNBJ401wFI7K0GHjKTo=;
	b=IpZlLnoVrROTTDe8UEpEtRQ9cbfYZpWt1QXCIcGNj6rmA0fQNqE32MU0Q/vrQoEZvvUBVN
	KoEzOeOM42pblhOuEqaatTDvUXTWWOudoYn85tUKN2jjPSYq0PzWSyMFVOdfmCLF0D27w8
	xnxpKsgjTX7M7N7vPhFhHH+Pf8jmpOU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aOYNkd/v";
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198870; a=rsa-sha256;
	cv=none;
	b=56exsEGhFuhupoW7yU9wmjnvpZtJUcj3gngt0GV+KSLmNUA1yQgbMTcSKRjqbx36INhjAT
	uS3TymUP1YJ7uHv3x5o2olDq+g5vJjWERgY56rPPGa7MJyi7NJQnegQol6R7Cpq2ZLeTo4
	ucti7pO0QrN2fFSrL0UTsifhv1DYNEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A185F6057A;
	Sun, 15 Feb 2026 23:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBE4C4CEF7;
	Sun, 15 Feb 2026 23:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198869;
	bh=tjrMyzA+BVtzT2Wqfa6F8miT38AdN9I/wjO3H7a9lZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aOYNkd/vcvbDJk4lE3gOjsaVJabfRblsr07ATuTEdxfmrk67CBg7J5kysXiPjCtlR
	 2zU9bETXF719U42grp0m7Op3NQLMvhUIekBy6Q/UNyUkAlIs52up01nsIUC3mLHddA
	 upcNqOSeH4D/vgC3ZsOP6rus8KsAknJYAeNFj0gu0oRsqo8NdMfGogMJs2wCRdqpFE
	 gzWlkn55XG3s2Zu3Q6Rgy5RXqZLJleL6lxTWbQ1pct/JtIteQwzVGW62QxUj+poYjA
	 v8guegINKlV/ZYKXtiJDGbvuP+rfMsz5x4zIMnuhqYryNT6caDZF84IRzyORKSK3YD
	 w/mFJr3ABStoQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:30 +0100
Subject: [PATCH 43/79] block: rnull: add queue depth config option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-43-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3790; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=tjrMyzA+BVtzT2Wqfa6F8miT38AdN9I/wjO3H7a9lZ0=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhCEp6FvtTf5ef2Ki4EejqZQMt6SGvhMnUs4
 sC8C3M0ImaJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYQgAKCRDhuBo+eShj
 d0lGEAClOQg1gPLy7HIVfKapYlBnLDghBIoEapbFs5J5AfZoMFvr3hvNmSvqrGJs7WY+HVl/jWN
 JAOYy1vdMseKVPdasMgue8+QSbEwM2NF00TAVppVb1LyQvcLHbwDARHwq513LL6yKWLYJ1q9g/9
 FYMVEN7axOaqI8F9+jfe8J6WJbJB/RQNEkv41poqsWK5L3bonD0W8iBl8TRB05w/r3SNo0wknhg
 15Kw2ZoeXbRLv7/nTSpMUvlGE6VwWpdfjNvP9AHG5YVEyLX3Y38yzh3zyR2FUF2JfCUzwJhGZSa
 EAwd5V56rOJlRWxGAoXkYIpORkb0PZCdhPLnkpGJtH2MzsMpjoWlikvMVvEAjt+Ed8lVYpsV7fR
 I/XY2M6/ZDosPtJhUseBVL3o4/+f/cz085lgiZcXEEt3r8o3RJdr4xXaIBSL6xXOT0UGaXDqgbE
 m3ftZKy6mIPmK3tpDpWsbCMRC4BdQwacV5HrZ+cnIoNeTJ/c6+Ngoect1UuUl794SGLNmfhey4D
 uVpY6bd0/iZitDW9KKO8deMVEMomcoI42B4jyn/Pok3Vl245uSL5Co0fglN36BjwSwzMfWfTjU8
 ZxZuAB28ACB6PnK8rusQ9rG2vTuKWtnb1VAhJcbhLzN9l3MR17TxgtduA3LTS6CkPqcmcziWvth
 Ky6Q4ks0SwaULHw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 294AC140007
X-Stat-Signature: mfb8gtm5wpbtcj6zxi9yqxkya8orrj5b
X-Rspam-User: 
X-HE-Tag: 1771198870-336984
X-HE-Meta: U2FsdGVkX1/8l9cHEiCj5L1ZvgEWrEPYJ28/fmJTX1YGCJXvhlnNWfnph5nps8JlznhKBNckEO+TUixzYrytzktJXLVeoKczx8ENDl3t3kfKrNDdZdiKvnw7LMoYHtw61R7QpSjwLUqQqLSYULCFoi7GgWUWmfPctyoJdxj4vxVbvwYzP0nt3cuQoTRmzO/kvuq2KQCEirlDRGACSHAb1mU/NvGsHx2krH0pcb4bKE+6hj0W/HPfHujQ3eljzrHfKXJ8S4nSEE3HdnpB3SGZ35GyaGrSkdlxj9TExojQYDs44MXQ2dQ5cxAl4SQ7QlZcd4Ez71Lvoi8wPFOTd3aPxZ9gFQdjCXftptdkQUKFNV8w1y0iE9+k4nXf43L9DDhnmiPNZpUqJopunouhlG80CUSoW17l4ZyKzWScDKh4jT8tuxpBQfAIHr2rCKV1K2uUkIsYZ2njdW3cRCnPQZMc8oIwcy6YntgTRNZoMo8Rov9FnTccIOS/zzc6eI2DbDGGNiFDJKMT6aQCnpiB4odOCiBhSRGUNXp+AopFwkvvULwMshFGnUpu8iRcoYae+5cRW8PAH7fRCkwWRFGQWlFQKMtJ4m1HHvpqEsQULUJ//yA4mBqrYtQmJIxPB0eXUPcN/4jSPkQqnG19uIeKUz2UhVJ1qZGCJgJIdYqrqum5pFYjfS5erbGkoCSobN4VFjUP346MCVnu2j/CIIxcue7Vyq3Cs1csIOiYV12sN9YF6C5JsL5sLQDHpq9m+e9wUCgi6uJP2Dt/90kRP3eFwh7dm3VEPRybVNK8thQWeZH2lPYYkOGhIJD6b0ret+/U5aS1ytsi/5oEOx42KEguggaGFE7AA4/JfImbOoGj0uoeQcUXKxbeTuTHybwLB+BSyekpLG75BGCRH7Frn0nJOX0eCqrpIZgsnCwkX+PGe5j/tCHO7hEy6/9SGuNmllVDsO4u36NxcnhGqfoQ0ZKCA/Q
 M7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a configfs attribute to configure the queue depth (number of tags)
for the rnull block device.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/configfs.rs | 5 +++++
 drivers/block/rnull/rnull.rs    | 9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/configfs.rs
index d1a70fe030cb2..90f2ecb454285 100644
--- a/drivers/block/rnull/configfs.rs
+++ b/drivers/block/rnull/configfs.rs
@@ -108,6 +108,7 @@ fn make_group(
                 mbps: 16,
                 blocking: 17,
                 shared_tags: 18,
+                hw_queue_depth: 19
             ],
         };
 
@@ -142,6 +143,7 @@ fn make_group(
                     mbps: 0,
                     blocking: false,
                     shared_tags: false,
+                    hw_queue_depth: 64,
                 }),
             }),
             core::iter::empty(),
@@ -209,6 +211,7 @@ struct DeviceConfigInner {
     mbps: u32,
     blocking: bool,
     shared_tags: bool,
+    hw_queue_depth: u32,
 }
 
 #[vtable]
@@ -251,6 +254,7 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
                 bandwidth_limit: u64::from(guard.mbps) * 2u64.pow(20),
                 blocking: guard.blocking,
                 shared_tags: guard.shared_tags,
+                hw_queue_depth: guard.hw_queue_depth,
             })?);
             guard.powered = true;
         } else if guard.powered && !power_op {
@@ -472,3 +476,4 @@ fn store(this: &DeviceConfig, page: &[u8]) -> Result {
 configfs_simple_field!(DeviceConfig, 16, mbps, u32);
 configfs_simple_bool_field!(DeviceConfig, 17, blocking);
 configfs_simple_bool_field!(DeviceConfig, 18, shared_tags);
+configfs_simple_field!(DeviceConfig, 19, hw_queue_depth, u32);
diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 84e75a7042214..3fb19836ce6ff 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -149,6 +149,10 @@
             default: 0,
             description: "Share tag set between devices for blk-mq",
         },
+        hw_queue_depth: u32 {
+            default: 64,
+            description:  "Queue depth for each hardware queue. Default: 64",
+        },
     },
 }
 
@@ -197,6 +201,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
                     bandwidth_limit: u64::from(*module_parameters::mbps.value()) * 2u64.pow(20),
                     blocking: *module_parameters::blocking.value() != 0,
                     shared_tags: *module_parameters::shared_tags.value() != 0,
+                    hw_queue_depth: *module_parameters::hw_queue_depth.value(),
                 })?;
                 disks.push(disk, GFP_KERNEL)?;
             }
@@ -230,6 +235,7 @@ struct NullBlkOptions<'a> {
     bandwidth_limit: u64,
     blocking: bool,
     shared_tags: bool,
+    hw_queue_depth: u32,
 }
 
 static SHARED_TAG_SET: SetOnce<Arc<TagSet<NullBlkDevice>>> = SetOnce::new();
@@ -276,6 +282,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
             bandwidth_limit,
             blocking,
             shared_tags,
+            hw_queue_depth,
         } = options;
 
         let mut flags = mq::tag_set::Flags::default();
@@ -297,7 +304,7 @@ fn new(options: NullBlkOptions<'_>) -> Result<Arc<GenDisk<Self>>> {
 
         let tagset_ctor = || -> Result<Arc<_>> {
             Arc::pin_init(
-                TagSet::new(submit_queues, (), 256, 1, home_node, flags),
+                TagSet::new(submit_queues, (), hw_queue_depth, 1, home_node, flags),
                 GFP_KERNEL,
             )
         };

-- 
2.51.2



