Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340FB606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+3r7WjY
Received: by kanga.kvack.org (Postfix)
	id 25CDB6B05BA; Sat, 24 Oct 2026 15:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236096B05BB; Sat, 24 Oct 2026 15:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1727F6B05BC; Sat, 24 Oct 2026 15:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF3A56B05BA
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 167A81A043F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:59 +0000 (UTC)
X-FDA: 85358454678.25.CA647C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F94B40006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+3r7WjY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMyYTioU/FrU2fWhiwuWu1FFpNsNlrYz9eN4f3WcI2I=;
	b=2GclCBrBU6yadhywoc38dSR4ZNRq9r06yYhpO8dTVXi/rY5Y3YBQMiY0iAN5Qz7fgTDbiZ
	29GsE8WszJQCSKeYys1zWqjzfaq/oL+vSazMCSj773w9XeKcY3U4Vhu/AnzI0b1TcaJwEo
	F2TbhsFeq6Lntr03P/hjW3gL1AHR324=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+3r7WjY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868877;
	b=HnYXMLrER3ygpD9PYBDY2Gpy9J4RTNYvyitqAkzj3kdtXmTIBSYAv0Bf3dm9SK77ckmh3u
	A7c0xGjp2GUTxgIqtLOOXkcOKdFQ5tnxOFYoqeV22GpeqS3bJRI6C2H70U4SxGmrKeFBfh
	A1gFxCUyRoJoTyN5jalZ65mMrhDIcko=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFD0343DB3;
	Sat, 24 Oct 2026 19:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860C61F031E0;
	Sat, 24 Oct 2026 19:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868876;
	bh=BMyYTioU/FrU2fWhiwuWu1FFpNsNlrYz9eN4f3WcI2I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n+3r7WjY0T01eAUCq/zRS0G+2hGEX5GFurChhcOIYE/HpDty0WA6gmzikNcxTYdH5
	 LhJWqrngg+qlGLVhYQimSpyue667XC+oTW6/Rxmbi6YLpG2amWpIW+41nxBiKRvPrG
	 WJSCfxvpry0it2d4f/nZKPV/i9+7MudMWie7qr9DtEmLffMO7uj7+Gy1UolLzetOQ5
	 yyplSGcW1ofPrAArDLBpw0F9Rx4ZQN8TjkBWRG7FfXY5BZ2iJldfxNENi9M7Gr023V
	 3N0Fu1cYoper5E9v9Z1XiFPaLA9apxQwEo/s+bz3O9k1ymRsh+WlkQYoR8MNPndQ6/
	 ZbloiE7IXl+uQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sat, 24 Oct 2026 21:07:30 +0200
Subject: [PATCH RFC v2 8/8] mm, slab: deprecate CONFIG_SLUB_TINY and reduce
 its Kconfig effects
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-slub_tiny_rework-v2-8-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
In-Reply-To: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 6F94B40006
X-Stat-Signature: 4zzfz8ihf48gkgdp3ng69prd981nu5cx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792868877-427155
X-HE-Meta: U2FsdGVkX18aPFmzLyL796qXtr8H8h2ib8+NiITr1H2N2M6vz9dP6JD1GYm13VRxBBAHrVn4eg0gNZ3Gdj7/++rPLpli/+kKVX9qE+fPuHAIAA3zSbZnd81AcqAFCARImv+2eEEmRApJm6ZryXsqm88YRLXYKIeOzgOsmshYa7hof3LfE+KCOJpDcHqN4xhw4zOuVoQsppP+Jsp8XnNLQip51aqwsSfcA9we4utKoh64ksLM+VyQ6idsu32DudLo7v+Ji9IBij+OEkrBQA1Bvmj2sQGi4UOOvczhD0Si6JuPi7QUaXsBc+yqbxymJ0ZTzjKcta4Rxz9q6K1dF8shOXTBA30MmpjrOj6W+fv09aSirCMY7XiJZW3TL3v4WYDzCv7QDgA/E6pZmxXBSEArYQCrEsI8pa9lCileJBmd342Jx+Ra6YdLIsIR1grHT7iUGzvRIy6fla///sF8AXqHDfbeQEI+O97fXm+xf1E+jrrMR34YefBaIqqB/a/2bHi3ooNJT56x0dhkM6yVnFuXkoyYCj28S0b4LnGOc2zMyA8KPvKkjSL95XTglQjYD/BqzF3JA6ud8/CS0LtLM+yWJA7D10YvP8t2uu8NFIhQfABJTiqeavpQPCLonr1mJdwbuqXSNN8hEOz5pu59i1wCOZ8Znhz7Xm04w7YzrhJN0TxojbPEs+uZp7huQrEl37vByJKgP2Rt1hradAkOlTY7wIV8EpyLmarLKLEXnwg/Qbj1QsXxWiyDy6oIBw7PbHPxbaeo3KFa49ou+1ENgHVd9wbWR7hNQiT/tmgFDFRy+1ZzxBuy1a0NMDGKSEMs8iNH99VRggTmGfJ9jmcP6r1aOpychm/vcj6KU+QVC7PnpwrZsrvdjPv/hODoEUXGkyTMBPDzdeRr5jLUGree7RxBeGP+xsWUZGDcb1pNen/msi0FLYWmuvagzuPSiiam3FRMQmWqAscxIB7YgTJZVuF
 KGiNHqLv
 gZTstFYRMR24z7Uv22wLReJudPbPLR4HYRqho8m9Izv9+FaFK1jsNdLQLGTHp2+j85m2Ljuu/XPIVuf8RXtVry3YP4a9AC/vjUYbJ4o1hAygI49yiLp8+dQT7MPBlO5x7OsjGGA6n/5r/He6HQk1o3p0Q4sKVwZ3wn86vLNtQfO0757KoRBwRytol8bZgqrD95Dfajhes32+x37WtsMdKAAv28XBLpsHae2NnR12w96NHxxGD6V6b5teO9Fu5XTyNZQFAv2ojq3AVXg1N82swOLuWTsFfFsd2fVV4B9SLFUmMgbE=
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
index edb4a6c0a870..2286073ea906 100644
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
index 9eaa25d1cf23..4e36c7c63ef7 100644
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


