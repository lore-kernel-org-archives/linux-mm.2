Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E60CC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEFE36B00A5; Wed, 23 Sep 2026 11:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9216B00A6; Wed, 23 Sep 2026 11:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD836B00A7; Wed, 23 Sep 2026 11:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99B9C6B00A5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61705140811
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:41 +0000 (UTC)
X-FDA: 85245452082.01.BE07941
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AA2E71C0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c5lR8OKn;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndf5eV8Fv81ukOHNfSKozUzjOHGtJEUSne1n2V5ZgcI=;
	b=XizrlFlGma/pScmA7UhcjvZgHsrIdPsSMre0PliRY1WIdDB++nmNdB0Df/uQKGq2kWqilW
	RuNIVCNTbVo8l9RXnSri6kNo/n5PP+eIJHewRKwTUvWxn9I8Mvb7SM/s9kdMQLgCfvmyv2
	bb6R21LoOrc17bgibps8STPCXL1ufi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178339;
	b=Qo766Rqu2hxdHcJn68AZbnJl/Btbpgnq+TDInqDAikW8FCl8T+yhlCWDICl3qjuHrY5d7R
	E6+T0+3BUFes+hErElkaLVT4v+/lEeMp0VaUUgZSPPqTbbyo0z0DQym9eKpsSJzn6A9iUZ
	ZwgqxchfMgXApaaREP5OEUGKYjZDPxM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c5lR8OKn;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B86A43B15;
	Wed, 23 Sep 2026 15:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D4C1F0089E;
	Wed, 23 Sep 2026 15:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178338;
	bh=ndf5eV8Fv81ukOHNfSKozUzjOHGtJEUSne1n2V5ZgcI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c5lR8OKnJT4jmtwR73IkOvXqTMfO1KzNkUM0tHa0jX4ycvfPBwCUgK9uiWPRQcIlR
	 fP/+/vp9BrmECh988I7fFDMTg2DNRJ9zhLyhplQR2sP38LLBE6fdGkwz3CXrmFNRTl
	 EtNHSLdvAEd3dbt4Ztv4Wo7BgGilRRiKZyxaELSoCe5r+PLoU8qcc7H2Y5maZ2mIV3
	 EyJD0jN7vMAdbMr0UoAmv0GOOnk3ZyJKIzsrv0G8btzYPPBy2FeHkItFUqD1uCQr+8
	 DtGS5HCypt6vSzLr4abeVSTy2eGQYnPQMi/qDqNi5ameOhv6UxDDR4OW3YoedW1ueT
	 Lguuzn69uHV3Q==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 23 Sep 2026 17:45:13 +0200
Subject: [PATCH RFC 8/8] mm, slab: deprecate CONFIG_SLUB_TINY and reduce
 its Kconfig effects
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-slub_tiny_rework-v1-8-a0e66d536eb5@kernel.org>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
In-Reply-To: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA2E71C0005
X-Stat-Signature: qeagezff7yorknty6kfrgmrfqkkioqo3
X-HE-Tag: 1790178339-848831
X-HE-Meta: U2FsdGVkX1+gIPNPChBUR2wZyCUK93z5U0GR8tgdb+ms3oa8H8HvxGosKlUplNLqZNdV4fxEJZGjmP9LKRyvRlI55KMocLjIx16Rkth3zEOAU7qxDcaihHOjfWxyp17SiY4vIiRuflu67dAQcdhmRudFHn3JgHmVfFk37oW+78EG6Kegdbl6hGzSSzaPq3+FYiCRAr3b5YtUvZCSFngnTq9vHERLiKT3S+tw9I79xGLLVgvWzE2tI/DV4Gd3GChvRaOAyfLp1rbsvHQa2YDmJ3DTJFhO3Dd/f20xqqyVXG7fx4SBIVmtuTGTczoMKKkWbEaF5wTs52gxSHTug6E350Wvpm0y6lfvOSTe4V+yoKB8f9nIvRwv/hI7RO8RnVjVaD3rws9SASqF92I2dHit4HQKHSE1HKapmbu/MR8/PXf+HwAxQ5AzzO80egDh9bMwQ6NM1Hf//sNLfXYe/WYDCt8Gw4VhksrxzSYqsw04uTmJXCtO5nEslmZYPXMzWc5yx7YJg6iuEBmvomBsFmICPRmkmlPKEEQlkkSrEuB2cY9rSMUvUo+qyu88CSilWPx1/e9He9FCdYKXsNJ0MWP4oWXQKQTGhWd9+wFt/WX4xnMNZFqNeaeA1LDmhIsZvfcUCW+llTeSkRcqzdqRNvesGIg6dMn1ZtooGAitBej/wy23eOFKarsSLAu8wHJd1e11Z+eXos2/ZznnLAy0b5/BNEhMrYfkkqJA9kPEHKyrgVK54DI+HrpAIKVb7sV0+TUcOygV49x0j/iIw7vZmm/Zn77jpvnJ9HeluPXNQ/v5fmML3fXU+/DfdnTXjnowbinMqMPobzeeX1H+nta9Sa0VZ5jIZwRk/2pAf32+UZooA0+JitWE3t1APA28u9fNdx94rBeBXVr4v4kGPryIkSTZHCEaD3luoA9p8hHMYBmvULGCqVixsK7S0za0ZCViVxaNlwSUzuJTitT5od46o0u
 iJbuSsPt
 wvVL1HSjIfGb07Rmg5E1SpSzcp1lbGTex6hq52p1zGF8ENlHSjHsnfADLjALwSL61XwvD5QLotGHeKmKigmGynjh/WQ3ZC+kZlnNjFe4IzZ0xL9UNyJAQp90VmnTy2fp1jrBfx4Q47aA/58hXsBDo5vVD20fDTTUOmPRA3Ic7ZS6cwQgXMriO7ffB6lKcYLieI29H6bSuFqrTB3LTXNZSE1FjtqQzdljp3ytxJrY05l8f1sODhqOrnQhDYIq2UUR2q89Z+5B4FUhrYrZoxYB4i0shrXiUCsxpS2J8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At this point CONFIG_SLUB_TINY only affects the default value of
slab_tiny_enabled which has a boot-time parameter. Thus deprecate it in
the Kconfig description.

Also remove its interactions with other Kconfig option, as they are not
necessary:

- KASAN, SLUB_DEBUG or SLUB_STATS support does not need !SLUB_TINY

- KVFREE_RCU_BATCHED can simply depend on !TINY_RCU

- various hardening options do not need to be excluded, although it's
  unlikely that somebody would enable those with extra memory overhead
  together with slab_tiny

- SLAB_MERGE_DEFAULT does not need to be selected, although it's likely
  to be used together

Keep the "depends on EXPERT && !COMPILE_TEST" as there's no point making
the deprecated option more visible.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 lib/Kconfig.kasan |  2 +-
 mm/Kconfig        | 16 +++++++---------
 mm/Kconfig.debug  |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index a4bb610a7a6f..f20b574f6653 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -49,7 +49,7 @@ menuconfig KASAN
 		     (HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS)) && \
 		    CC_HAS_WORKING_NOSANITIZE_ADDRESS) || \
 		   HAVE_ARCH_KASAN_HW_TAGS
-	depends on SYSFS && !SLUB_TINY
+	depends on SYSFS
 	select STACKDEPOT_ALWAYS_INIT
 	help
 	  Enables KASAN (Kernel Address Sanitizer) - a dynamic memory safety
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..a1b1ff7db59f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -167,16 +167,18 @@ config SLUB
 
 config KVFREE_RCU_BATCHED
 	def_bool y
-	depends on !SLUB_TINY && !TINY_RCU
+	depends on !TINY_RCU
 	depends on !RCU_STRICT_GRACE_PERIOD
 
 config SLUB_TINY
-	bool "Configure for minimal memory footprint"
+	bool "Enable slab_tiny by default"
 	depends on EXPERT && !COMPILE_TEST
-	select SLAB_MERGE_DEFAULT
 	help
+	   Deprecated option that enables the slab_tiny boot parameter by
+	   default, and can be overridden by booting with slab_tiny=0.
+
 	   Configures the slab allocator in a way to achieve minimal memory
-	   footprint, sacrificing scalability, debugging and other features.
+	   footprint, sacrificing scalability.
 	   This is intended only for the smallest system that had used the
 	   SLOB allocator and is not recommended for systems with more than
 	   16MB RAM.
@@ -199,7 +201,6 @@ config SLAB_MERGE_DEFAULT
 
 config SLAB_FREELIST_RANDOM
 	bool "Randomize slab freelist"
-	depends on !SLUB_TINY
 	help
 	  Randomizes the freelist order used on creating new pages. This
 	  security feature reduces the predictability of the kernel slab
@@ -207,7 +208,6 @@ config SLAB_FREELIST_RANDOM
 
 config SLAB_FREELIST_HARDENED
 	bool "Harden slab freelist metadata"
-	depends on !SLUB_TINY
 	help
 	  Many kernel heap attacks try to target slab cache metadata and
 	  other infrastructure. This options makes minor performance
@@ -216,7 +216,6 @@ config SLAB_FREELIST_HARDENED
 
 config SLAB_BUCKETS
 	bool "Support allocation from separate kmalloc buckets"
-	depends on !SLUB_TINY
 	default SLAB_FREELIST_HARDENED
 	help
 	  Kernel heap attacks frequently depend on being able to create
@@ -234,7 +233,7 @@ config SLAB_BUCKETS
 config SLUB_STATS
 	default n
 	bool "Enable performance statistics"
-	depends on SYSFS && !SLUB_TINY
+	depends on SYSFS
 	help
 	  The statistics are useful to debug slab allocation behavior in
 	  order find ways to optimize the allocator. This should never be
@@ -245,7 +244,6 @@ config SLUB_STATS
 	  Try running: slabinfo -DA
 
 config KMALLOC_PARTITION_CACHES
-	depends on !SLUB_TINY
 	bool "Partitioned slab caches for normal kmalloc"
 	default RANDOM_KMALLOC_CACHES
 	help
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 15dca19dd07d..7fa01e48c9f0 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -48,7 +48,7 @@ config DEBUG_PAGEALLOC_ENABLE_DEFAULT
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EXPERT
-	depends on SYSFS && !SLUB_TINY
+	depends on SYSFS
 	select STACKDEPOT if STACKTRACE_SUPPORT
 	help
 	  SLUB has extensive debug support features. Disabling these can

-- 
2.55.0


