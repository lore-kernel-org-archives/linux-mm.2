Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7D7606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kosXWr10
Received: by kanga.kvack.org (Postfix)
	id 624E16B05C3; Mon, 16 Nov 2026 01:47:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E266B05C4; Mon, 16 Nov 2026 01:47:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BFC6B05C5; Mon, 16 Nov 2026 01:47:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25A206B05C3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9197512067C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:57 +0000 (UTC)
X-FDA: 85440052194.13.B3E08EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7552A0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kosXWr10;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811676;
	b=de9jxJ84krqbtbVyT+aM+4e2dFfTkTqljI6Bcv/hWi5U9EBNXVcQvjUOSJtZX2eP1Q7kkE
	aOCma1QzEg7S92WudRHC/z71EjzPyO/zxTBn+HTbUZgO8AIJvEmtELGdET6senM88tdv6q
	8UUWHJy4MbTOdv61zo4WxX5GTePVgG4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kosXWr10;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhwL0m1EsUEyiipqOIDsOQks5B8WnrLL2ZaoE/N7l78=;
	b=NnhwowURyXhzsry2W6mK6g1qLwt1RFdW9zcvGaYGMZ3oxNeEViPXyBmo1re0bI6YbGTfW/
	P+GQzaurWsNU/omT3LM9B/3IHkohLZa79t4MwN9Ti/6p3IoqHhPuP3oHtlw9uf0Ok6iG8u
	6L2yFhBAvOVdc0ndHhrHzQcs5ymCmM0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 463AA45B75;
	Mon, 16 Nov 2026 06:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E2C1F000C6;
	Mon, 16 Nov 2026 06:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811675;
	bh=mhwL0m1EsUEyiipqOIDsOQks5B8WnrLL2ZaoE/N7l78=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kosXWr10HnpHex6nFxMMsR4jnpxAw6+pMwL5CVcjwOrnqLSfeo0H3t3so6+jkE8yb
	 sZPIKwtQyQiNe89JmV6D691npkCppN3hbAN+t9Y/E2tCcFhaNsgjCWkwp7gGKmnzjP
	 i7S9CWJ6/M7XtvyXAcr/asl1OZZBeMna5uiov/TB3zRYXrSzt21xnkyBUie24GZLSC
	 D2ooQQMlFIY3s6hXxlYKQr8M5ot2SzdyX9O5ZwIEZ1tSNI7tW6dOQ1eSmJ481hgS4j
	 46Hv1mhEQ8ailcUwcOhcg/9IyN6+7ePWkEEqZ2mZP9vuWizynllcuSi0taDa/oqS/l
	 OmOlBqfUW7h5Q==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:18 +0100
Subject: [PATCH v4 10/10] mm, slab: deprecate CONFIG_SLUB_TINY and reduce
 its Kconfig effects
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-10-227a4b3636a5@kernel.org>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
In-Reply-To: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: uku7sbf8dz8ao685kubnywotjw7z4gno
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7552A0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794811675-504993
X-HE-Meta: U2FsdGVkX19fnsM7hwVDChgwdV6IpxascXWzFw8mvyCavrbeyFxw16Y8UxcciKGuyTMT2g6+fKQi8VACp1y3kRQvJtB8CZ3sT2P113dbaliEdeQmRn61MLNuQPKldHjwje/huEnrFuwnSTg5gWYVeTrr4g8yzCwGZq1NNq0shqmz+YP9WSlF8MWeucDgv8WpJ8e96gA60ALAIdUufjOxnfZp+fX26haOhYQrKJdLSjb6zSnGBbPIyjpGIuudUfBM07WGzMkcV/PXJtvrTDp6tHEA7kQd8J+wqRWiSjxHWVzkzPdp6Y6vCvOvIZBtXO5rtRxeQ+hGvTFR5NqrUv8aQV2xr6yTQI081wTiuJeWpsBTt5f1ZmDFDm0uTOM9woQC+VV3tQSjt5QpSohZlejuqjBdike0MxBGJQ7rAYHarILUUcmRF9Or8m+hOcQqwcjlJaGMCVetiASNc8FuN1PtwfWJG/Ilc8gTVJS3adllcJUtFB92fiLIlmCx1mbd34wBn28tB4IFBG3G+npRR7yDfbjXi7pXXoEfsGdQNLCPsUnoXtq1YhoQ6RpdqElfvH2zwJFyEnI7pnFMC1GZUmhVxSdNtzCQumjWl1sbvN6zAiBufK5SQiVIkFrFKhc5QV5xTAjyHA0hrSaO9aDMq0NnsC7eJPvg+F12GEljbPtynsUKPVR0FOceZyWpF39w2GflgrDfyzKEe84vUGS1fLCSJs6YZas8InNrXDGWYInMglgE5VWwI5a9pjPSNBBquWo71TrFQxUYW/7HMFlK5SYAEdYXVY1PL1TmYB159805feu6ckb4wWOOOJBqkjkWxYSRhMrU7wjFagc4hyvm1XfhBNXH2ZJcZtGb0BXePVehFdJtT6tKB3F1aDV7D4cDs5w+ZP+S7AJ6HX1WqwIZRdtPhYyTwKp/zCZK5LBfGmGxD2/PkWaSftWqbcr8iVzGAcH0eN9enIXqgWaAsTNDgD6
 ArRz3Xe3
 o3R0jvkhxFaHsmom7c6VAMPP931cDkvmeFcgOhXdi4HCoKX9d32lb0bbMLuQJtGaQVgV6EzM+60xkcoFZLuS/Si3uiLl9FcYoIa9eWwKp/Igmjn2smX3CxmFJcRrencRiSkZ4G3vQ8VTZNLRAZq6bT4P0IlG/33ygSVSZgFPmh6mHf0ecMvgVoVKs4WnCrPY2PQCjrFtrHeV1Fa3DGGU/FhGfqKfvrSW0F7eNgbbFryaQYGPQplB9Ueajv1eV5jFPMiM20ewGzbvrVxiYbcRFZs291fYmSn3FMaDqEubXPHCBeRgw9KXTNBK0JHT6Hwn7Ybe49LSDYAEVNL7qKTXhaYd5f62YiSZLCRdDTbcbRIQ4g4MHTZuP+EIuIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

At this point CONFIG_SLUB_TINY only affects the default value of
slab_tiny_enabled which has a boot-time parameter. Thus deprecate it in
the Kconfig description.

Also remove its interactions with other Kconfig option, as they are not
necessary:

- KASAN, SLUB_DEBUG or SLUB_STATS support do not need !SLUB_TINY

- KVFREE_RCU_BATCHED can simply depend on !TINY_RCU

- various hardening options do not need to be excluded, although it's
  unlikely that somebody would enable those with extra memory overhead
  together with slab_tiny

- SLAB_MERGE_DEFAULT does not need to be selected, although it's likely
  to be used together

Keep the "depends on EXPERT && !COMPILE_TEST" as there's no point making
the deprecated option more visible.

Note the change of KVFREE_RCU_BATCHED dependency can potentially
increase memory footprint on systems that are small but have SMP
support. If that causes troubles, we make it possible to disable
KVFREE_RCU_BATCHED explicitly.

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
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
index afff1b25b543..ec91a4cc6c83 100644
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
index 9ae75229c76d..1c43b6aeac9f 100644
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
2.56.0


