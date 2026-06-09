Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A3E1CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA376B00DD; Tue,  9 Jun 2026 15:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1DF6B00DF; Tue,  9 Jun 2026 15:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0DC6B00E0; Tue,  9 Jun 2026 15:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99C3C6B00DD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:14:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 585DC1206ED
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:05 +0000 (UTC)
X-FDA: 84861324450.21.201EE36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 74506160014
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:14:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GkzrKIe2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07OL9kcN1ts1JXzzO+dUFMGY2+vD2vNCDEhWdbU7mT4=;
	b=ZmDN/fcRp/uRP/VMS3qx4wp8wtY9dj7/FKGAmqsGrYnpwQU0DUo9/+3j4pJ3IU7iISNGB6
	l2rh1Rf8qwGBWHTy6PMgfkIPcIRTCBBu2QecrM+44eiEGRZ9RaSm4XPTQSiCuPaNwB+1hb
	UtF0Ccd5PnF9RgVpDgyjb4csfaf17us=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GkzrKIe2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032443;
	b=DXmzLEDCKwsCPV8kr8gq3NA3QzBo9WtJFw5CT0DYP4a48prjV9sv0TzOGk485Rh8e1LeLn
	ueBa2yvmDN6Ee5p8nFj9WYgwcDKZfOTUsnk9pUItFIqW7eJqtcGXRBDoEpyHmwAnvU45Jm
	VHfP8S/zT+TAlCm83KJ2tGeZK/Xs0HA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF9BD41700;
	Tue,  9 Jun 2026 19:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391DF1F00898;
	Tue,  9 Jun 2026 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032442;
	bh=07OL9kcN1ts1JXzzO+dUFMGY2+vD2vNCDEhWdbU7mT4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GkzrKIe2u3GY0JbJewS0RuhVNBjw7yRlApgAHzBncBKj0XnPuXad13OLnC7CRwaXG
	 iMgQ1BzKirKGjzmSiTCjo/1Fs9/L8PDVtB/u0nDJbC37bCWViphuSoV3Cvd3UmrvDj
	 pME6QGR8NxzFmm0HDLEQWprWgzzml6RxsrCNYnyYa/HOjeT5IflAHk4Gc+lccHR5Vi
	 VOthBvAe25P+FT/ToGxNyMYpxjHPvckRZAzs9NU/Jcy5K5VwCW8qQLK31VymURNStI
	 NDGvTJie/NIGPH6KxtT/P0RBcLko0qNzcD+/4wPU5peW1CRKFAmJ+OMnnA6UGIRTP+
	 XfcBzTDei3a0Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:41 +0200
Subject: [PATCH v2 62/83] block: rust: allow setting write cache and FUA
 flags for `GenDisk`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-62-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2966; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=4KyhpI/ipNtBWo4VfFmPMWE541B+ewaPC0dhOaA747E=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTs54UDr8c4HG8t9kjVRyMVGYuBltQmu35Fx
 kzOC0ur7sGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk7AAKCRD6UCkIqsW9
 0MLED/9uhTnck2NzwFArogG6VlzaQyne7VPrBkfmw6Nv9UnoWpTNUkQfe/CsDpQGsQxLtCmae/z
 E1C6XowvFBrQtmwJ2gsPnNOe5tmkJuNQOAnrSXGO7sC5OeqlVJ0tgiEO5QGEfp1EQfsLt4qmIvu
 3ZEioOmYoItty3EBEvv5H3WyjCSGEdo4pKOewZ+FNfE/rJj0G8lpwsZs24HlwBUaXB847igdfCg
 Ww3FMnCeM7z37GSPdxmB6OaqZQM91MVDQrBzEQLu3NYjs5SSWknEe948agXVpRo+mI1nr44JdwO
 ha/ZiVWE5418t6/WrHnzw6UKoj0ALQ00jtulT74X883V9UJqgpSMtGRT/Zx28YdWJCNlG+HkSiJ
 ZUnN7IyNz5oRD5heUlK+3ymtP/gsAougCbARycu9ziTyMX6e5af8ofNWexv8+7LHjiwhlcCEMp2
 fUpW47RaTUxN7poQqnXe5JgXfBtdNmAk49uVTVHcFb2OE/FiYzqEJxqQ7fDA3vUS7Vw8fVGI8ti
 RAf2z/EcyjbByabxIQpiWqLQROy4g8G+IHdgVs+Bu8glPNHc0jzafKewS/RD19YKxcVZcwo+HR+
 37VssMaG+PTuLzYSpas3h8u7UljZO0tMrD6jZWTBYCgRlaz8Y1vLONVCt1MMtPYLPiZXT93duaC
 cq8ynYTAiX1BKag==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: tqxbkihxeiut7bbqnmg4cdahcoswfspp
X-Rspamd-Queue-Id: 74506160014
X-HE-Tag: 1781032443-443426
X-HE-Meta: U2FsdGVkX1+EL36IMpGqPwaJ2IVHItu9URjoj4fvZczzgWK5QOuHSV0QohKuc0AY1DfPhMAlq0IGXKKuR2RrNB9vKxTfms38fp3fQTXFHUUbyzYiDUofrj+VUXbZ/DxOnd9TRvw3MYsoSqiB6HwfNEDfeAmTP4LZMUXXfcqil147rTmk7uKt1eutpJ8LgygDgNYwqnHuCLtcOOhLIYI5DKyD7wSEcb4EXGscTYLtsnZ8z0oahBmBO/AD8MGoT0/vW4YDB8EKulw92NCD0h8f8xV9JAqm73lhLqYlBaNSSok1R6vZRyqdNHe3o6VhXKvYypmzhvAGxNX9cRS4VplOi9S0eMRgBlPGi6le8l9NxeXU3+C7sx0XWWlScbdV//JJvdMKxwctfWUbTFx3ZpH4/uzcJ0cfE/dJYBvGfcefAqRLIy9YQIx3Dj2nfBJlWWXVHAPDquQ0qD0D3AHH3eviXiAMpe1PALtbFCPj+Yop+Mx+SAJ6eBftLCvOtFE+xH2YQ2dN4fAuj/S7BKskWD0SgHwPDxM26px/qAUoA4zmYaJG0CG0TkYRMkBRqm0LtY+FWZLmUpBy63qLIs7ryqlfn2332Lt4cvqP8mVtwQiRHHgp/WEklY80YnWH7TEp2hl2AwN9FAaW2UZvJonGfcO1rx8NI8qlzNvF7+B3MKmYKfHJ18lx1IkmK5JIrm3OMLaRLo20418bVODMRDOvJjO5AKhoLMVlnfvh70lhchZNKCv/HSHRnhGsUGoLfoFUetogLvlkKg2VyUxrT5k4Nt3yut/j0u9TJMAv6g46YHOpp2f1agnfNOCN/3vv6THrKY74upMzt3tGINwnrb+y78SU6Mk/oTwkkUEvhTTYfRxQGE55gazlUXGAGjj5SaSIk5rtBlExqrHGAoeQvL7y5i+Dm2ChKpHy08JLMhxl1Eyquyvs6Z0R2m6s+WQA67qY0seq4u5NUZZ5qEnVR9p6erF
 wfw6yurU
 DuEEzRPooE54QofoH1ptpsZ5BbsqXwAmxa//bQ9N4ih5cTkGAglhav7ogqHuOBZFq+ZQ+fNg5Aj5HuBmd8rjsSFVwrxSfkIhFAjwzl/h8o0DG8Mc+RWyj9GsJUnaZtYIkPxj/WnQR3296z7EZnFDYcDmTgCqjV3XhTp/00Ivtz8pgu9gIwmfvNb/jM0j6eYGMZpfuIPpxt3n4wlNrNzqRDPca3iNVpg6DQbH/wBuShk3rSt1taCYRQyyswL2viUCQNR7hkmdtRu9sODg5Igw4wH9CDxsBQEThNu8XlrdEj/G80pjsqUKOspNzYK48gRzzYX+H
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
 rust/kernel/block/mq/gen_disk.rs | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index eedba691e167..5367ca92b7aa 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -9,6 +9,7 @@
     bindings,
     block::mq::{
         operations::OperationsVTable,
+        Feature,
         Operations,
         RequestQueue,
         TagSet, //
@@ -55,6 +56,8 @@ pub struct GenDiskBuilder<T> {
     zone_size_sectors: u32,
     #[cfg(CONFIG_BLK_DEV_ZONED)]
     zone_append_max_sectors: u32,
+    write_cache: bool,
+    forced_unit_access: bool,
     _p: PhantomData<T>,
 }
 
@@ -72,6 +75,8 @@ fn default() -> Self {
             zone_size_sectors: 0,
             #[cfg(CONFIG_BLK_DEV_ZONED)]
             zone_append_max_sectors: 0,
+            write_cache: false,
+            forced_unit_access: false,
             _p: PhantomData,
         }
     }
@@ -164,6 +169,18 @@ pub fn zone_append_max(mut self, sectors: u32) -> Self {
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
@@ -183,7 +200,7 @@ pub fn build(
         lim.physical_block_size = self.physical_block_size;
         lim.max_hw_discard_sectors = self.max_hw_discard_sectors;
         if self.rotational {
-            lim.features |= bindings::BLK_FEAT_ROTATIONAL;
+            lim.features = Feature::Rotational.into();
         }
 
         #[cfg(CONFIG_BLK_DEV_ZONED)]
@@ -192,11 +209,19 @@ pub fn build(
                 return Err(error::code::EINVAL);
             }
 
-            lim.features |= bindings::BLK_FEAT_ZONED;
+            lim.features |= Feature::Zoned;
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



