Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D5FE63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3D456B00DD; Sun, 15 Feb 2026 18:46:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2BA6B00E0; Sun, 15 Feb 2026 18:46:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B108B6B00E1; Sun, 15 Feb 2026 18:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2AC6B00DD
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:46:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E745C3539
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:18 +0000 (UTC)
X-FDA: 84448327236.22.A6DDD42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E143980004
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knbOyE00;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nhKNWPClmsLrxhuvD2Q4YPvKoxXJM8YnvfuZ5ROmxM=;
	b=b75iVjkBtkDQu7pDHWgEbmfGDfHi0ra4iA6IIlLAzVesbok0NHMRipw7KN0g44bAs/qVpP
	1vQFdFfOeWzs1KlcsveiFnr4HQgDryjpeYloZ0jIkCyhdra0qtjME6TbW+8MqUokpxwMt3
	rfaAcBzkSWqSjZeG1tg7kyIZ965NRK8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knbOyE00;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199176; a=rsa-sha256;
	cv=none;
	b=4PFZkVedusmXAfPdORGxQsvtPnn7EU2sYbh/WZYlNOLIIUpkvLM7RNK5LqkrV3kNrSzSx+
	x4CQLp/ibTORkk2BKUrIJbSdFtWHQnt+Arvem+hqGGnrwLdERBwKL4TcIXNwHYQiLDaoDo
	MO9bHZOO2wMJqIRo/q4fEdA1m6fPHNE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53A2D6013E;
	Sun, 15 Feb 2026 23:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864ACC4CEF7;
	Sun, 15 Feb 2026 23:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199176;
	bh=SmeQZXFebNfgMhT0PU4tfkkh8SCMyfZDkLAJp5Aj2+g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=knbOyE00fHy5kmFNl9V+TkJ2VfcplCF4AeFvXCssIlmBjbGFlST02ikxq5VIxwjEU
	 cAQJZulXgIGpfYdvUVCxJROn345beJ63HQacigsH3SmHFtf6p18NRlKq6KUopXzvMP
	 u0cXk/H7K1cqwE1c8TgMcIaQT8JZIJ8HbbWVJrqAUqJoCcQ4AkQ6I2JCMEg6NCpB1V
	 WNJLYtEpctbJO+lrb2+BrZv31E/bm/fLWSwLl1rZbB/+HgYV5MEQO6KnUSgZvFPBRX
	 aOPMGZzY8v3UJ5v7Hs8a/C5B4tt8R42GuU9axuD2s12tJTy5vwFFzj621e6yQ19su5
	 xUCBuNIC4KuJQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:44 +0100
Subject: [PATCH 57/79] block: rust: allow setting write cache and FUA flags
 for `GenDisk`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-57-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3122; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=SmeQZXFebNfgMhT0PU4tfkkh8SCMyfZDkLAJp5Aj2+g=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhPxhVYrbg/jqgQz+TX3wQMfT4hRanolERcq
 iBGDi6PjuSJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYTwAKCRDhuBo+eShj
 d8VrD/9iDAv4/R16Jikua6mLzD8+doovIV+CniFnxdRh9EjytOr41KXGvjIE2jpebbEWLXNvnhu
 J/pLqVjdxVGJkfuYyyOGJZ5xUTfed3f+2oGEwtn/fIyLjQ02fBxX3V9uR5TDvxbMFYEJWCXVInA
 nheaxy+vjh7rP0DPWqslmsajzqztYr7TD+XYRI2yVR1YD4a66YlslCmcSohocxU9Hvhf1rAJ3Zv
 9yedHbMyr0+T1UzL9DwSfvTpA0G4mFNzlt8/mIorrLgbrdodHgrkzJ33KOnZm2oNyVT7rJER5w9
 bk7/iOGMYu1bwzy3NiWaruwGoywlJgeMJf73OaUEv5nfFZE2Ed5/6ScUDATU5Opvnru7I+u5H1z
 awIZnLhwRz1x9qCRe0FTY2+0dlTT7X9hz1CBw4OjNK5rDTIHFw7i2A7NjdikeEowX73PwJJ141u
 3dnbRekFt9x72pavXfVUAGCkRjoVYqLtrHVOdYXrmbpit4JiwFkC+h/iRnhcE1YKtY9huAtmyW9
 BTvx4eSeANFBm4KjSKnbeIzmztOTXC6zo0U3cwvpe93LeFxvnlMhsr77Kwg6SfWi6oAxNuuaR5f
 jEIhOrv3llH+ImrALAH8vYA4RBFVYDkvE6igKcpWXNkbTDaBpeijcGuBrbGhYPAbOkUUIahPV7K
 /dIvSHjKMitbfpQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E143980004
X-Stat-Signature: 4tctsfp3fzeg56rjz7zqx34by4ndgyea
X-Rspam-User: 
X-HE-Tag: 1771199176-891794
X-HE-Meta: U2FsdGVkX18jVeAdQwB8yyTGCfrm5XMX7nuYkfQMp1s2NHs+nBDwf9smSP++yKlgli1+qatsOdtMedaQDy55exQwRpv8i+T82BrI6Uc8/LPzkNy+7tcJVgfnSy3UV6FGmXk/Fi6xtJb260A9myn+DTQ5tsPUFsglwUQr1G4HOnnxeBRz0N3crv+MdrmX8I97DnZuS+gwEY/xdN60SkeOYjpicOdAkieVgiVeTJyBWkGM9xzfhNbksFShjVI/X1ZlrRTvnPnfw++H9LvpRExq+IyucApX6BUvnQtdieWzJoRbtIxKQo9GvAlBT6hldlOZ2NgHP6cF/4IGRYI1u4OulOT/L+lWgG2Iq756bYvSBIOBlpdFgc+ctDAMYqQ2gfcz+GwgK+lKXX1ySUhJ9WsXW6JcwnZWm+sDYZFN8XO/VenUh7eFeFLxgPjAb0lrLPEIsB3flLL0AJZnCl80VRZeBB1cNrODO7ySbm/rUkt/ZB4T8TwyA3gEs7JnrQ1voF6sq+f2+qreJrJeCNJ3g/e24WRuiNrYlRhbAkRS05jbhNjEXHsLZbsPF6CahlH6RwAAcGuKOblxxAWWvLlrGDHknKfWDV0+j4VduUvwoh8U393ZSP+su7Vr9RlMIkALTWKWweHAILDhVJpGo/s1u0KG37jXDqNWmwW8J3aE+7hhD3VUTVXD711Gd8TmA/Dps9l2KxA05KunWjxJ9TH9Ew316WqB5GqhLJnSt82b1x1KYxeFSGDs3fS924BEk1ujX2iHwRYpKbFm5ty4YPm8YNVNtX/1WA5D2RLwsDMVt4aJELDrmRch3idIEj/lgMh8K5h2MhbHZvgsM9Sw+OjLwmJ/IQnV+nD7mhCh4aqC4rxFYUFdf7kYsLpCQkCZaIaa2yup4SMQ5x5yYBWdkRIMR5r+i3NqlGdRY0gc3swzTPrYcITdJ8T7klqNAvLUYerQzvRJ3n/z8x8Vz01cO3O8gIf
 P7nR2YlQ
 +hmSfnbZPW+pAXm4AcDZYlNvfWqFIaix1LvEWp+KlS1l2tHwPcJg6TLXOWpSzTWyV09S8CUOlkNVZYiksbllOiDSAsgY8+CZTxT3wh9RVOHRtekM8FUgNftwMJ0CDSXt/9lMvQq57qe8UeAZs5CjLZdHPlDEC8mSXPUv5+dXcBC2HvBhkDm107o2lTXidXhp8SsIFS+jOi4fNudV7fVziMzBKOeDESgLpQukYRBGOnSwKqG2SKDq6faKd92wrBBBLqa2Pgfkfx89t6OabzmXwMeG2sK0T+0MQsnUjeZvPkSBIJZSKueiV0UQOfWZhSDmU5NnK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add methods to `GenDiskBuilder` for enabling the write cache and FUA
feature flags. These flags are set in the `queue_limits` structure
when building the disk.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index a6f113ea4bea4..c6b9839864012 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -7,7 +7,7 @@
 
 use crate::{
     bindings,
-    block::mq::{operations::OperationsVTable, Operations, RequestQueue, TagSet},
+    block::mq::{operations::OperationsVTable, Feature, Operations, RequestQueue, TagSet},
     error::{self, from_err_ptr, Result},
     fmt::{self, Write},
     prelude::*,
@@ -34,6 +34,8 @@ pub struct GenDiskBuilder<T> {
     zone_size_sectors: u32,
     #[cfg(CONFIG_BLK_DEV_ZONED)]
     zone_append_max_sectors: u32,
+    write_cache: bool,
+    forced_unit_access: bool,
     _p: PhantomData<T>,
 }
 
@@ -51,6 +53,8 @@ fn default() -> Self {
             zone_size_sectors: 0,
             #[cfg(CONFIG_BLK_DEV_ZONED)]
             zone_append_max_sectors: 0,
+            write_cache: false,
+            forced_unit_access: false,
             _p: PhantomData,
         }
     }
@@ -143,6 +147,18 @@ pub fn zone_append_max(mut self, sectors: u32) -> Self {
         self
     }
 
+    /// Declare that this device supports forced unit access.
+    pub fn forced_unit_access(mut self, enable: bool) -> Self {
+        self.forced_unit_access = enable;
+        self
+    }
+
+    /// Declare that this device has a write-back cache.
+    pub fn write_cache(mut self, enable: bool) -> Self {
+        self.write_cache = enable;
+        self
+    }
+
     /// Build a new `GenDisk` and add it to the VFS.
     pub fn build(
         self,
@@ -163,7 +179,7 @@ pub fn build(
         lim.physical_block_size = self.physical_block_size;
         lim.max_hw_discard_sectors = self.max_hw_discard_sectors;
         if self.rotational {
-            lim.features |= bindings::BLK_FEAT_ROTATIONAL;
+            lim.features = Feature::Rotational.into();
         }
 
         #[cfg(CONFIG_BLK_DEV_ZONED)]
@@ -172,11 +188,19 @@ pub fn build(
                 return Err(error::code::EINVAL);
             }
 
-            lim.features |= bindings::BLK_FEAT_ZONED;
+            //lim.features |= request::Feature::Zoned.into();
             lim.chunk_sectors = self.zone_size_sectors;
             lim.max_hw_zone_append_sectors = self.zone_append_max_sectors;
         }
 
+        if self.write_cache {
+            lim.features |= Feature::WriteCache;
+        }
+
+        if self.forced_unit_access {
+            lim.features |= Feature::ForcedUnitAccess;
+        }
+
         // SAFETY: `tagset.raw_tag_set()` points to a valid and initialized tag set
         let gendisk = from_err_ptr(unsafe {
             bindings::__blk_mq_alloc_disk(

-- 
2.51.2



