Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE7D606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEd3CURb
Received: by kanga.kvack.org (Postfix)
	id 6F54C6B05BE; Thu,  5 Nov 2026 03:44:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD1A6B05BF; Thu,  5 Nov 2026 03:44:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3336B05C0; Thu,  5 Nov 2026 03:44:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33FA66B05BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C238640998
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:34 +0000 (UTC)
X-FDA: 85400429268.12.ADD472A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 223F61C0009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEd3CURb;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868273;
	b=NNm1QtXw7SEhPecy7l/xGi7lsspby+fpFt6JAFSNpQPNOj4aGZCYEJrEtVCQxp/bKGUeFk
	qN3PbA7T/QIEohIID79+SYSLvuzdhjJ/3rgUaS+fZQObDMeTQ4EemH1yXqqD6bdQB0iy2H
	c7rFDP+K8qXmp8T84dbm9DSxRU1zrgE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEd3CURb;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJRLNNmJfikXOgBL5Y+Y26aKpB5dn+CgY+okcx//Lv8=;
	b=FAZXJ6W2Cgn9Fi7/pDEXpSH5kRgyJUWaF2e8iaN2ztE+7MxARExdhd9dhkT0mQ/wSkiesG
	mZxSn0QQO0IOCuZuEx5fBR+NzGJ8PnFTSMZa5vgYbBZc1fdBiPpsoZVhsP6TiMIPUrB75T
	PpxPdfZyIiqEdceGFHq8mgYw/pfl5s0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB4F060F1F;
	Thu,  5 Nov 2026 08:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B54A1F00A02;
	Thu,  5 Nov 2026 08:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868272;
	bh=BJRLNNmJfikXOgBL5Y+Y26aKpB5dn+CgY+okcx//Lv8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QEd3CURbZ1esykt5LXMmEU3mwfK3EPhyW4UmuoNSMMCIN8OxCLQbdK870kStRfTnO
	 QMMsFWLj8laFl6eA49dxZKYC1ULRf1t2E24GpHMErTIuoqYLvmllXe/IVm1KklhF7U
	 bfdtqxYIdhutvs4jwZ/U0mQyCQ238T4Fp9Wp1RN6sIrFrCMEfuiaTFbwYe5RiGTnjP
	 Polc3flX5ZMI0pt6pblTm11jZOj5//4eIDS+pYy9b5FZ3INDYpAzhGAgGY2UJrbt67
	 s88iZHrYv7r4GY/HEMwsqZRk36NKW9mINCO3d2goF5qhaJeZwMrWEWENLTETQJZqV0
	 z6OxSufCJlS6A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:59 +0100
Subject: [PATCH v3 10/10] mm, slab: deprecate CONFIG_SLUB_TINY and reduce
 its Kconfig effects
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-10-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
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
X-Stat-Signature: sx3wspk6pbhbfnqchebsuh535cjki4gu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 223F61C0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793868272-41268
X-HE-Meta: U2FsdGVkX1/bYdN8/IQmSZRLswzOGbnjwU6mYU2jx+l5Z3tDr1h+UUj7FHQDssoH9Xzrmlr1LGa2AJyiS0fzX/pFNL5S2IH+HDtXMZWpcfk6xm6qcVLjpmmF5fjGejOVr2HNcf7B1Uh9m9zY1SdCBZEpRw8KygUb2OYBWMc1kmOCLBqfUUvVVBrFHVljw9ef8pNtNb4Xh3kZ/dG5Sh7no8g1T4peO7Mey2RSK8ECurRwJ20rnF7yl3YSu9KX3m1NERwjwmu++a4NlzGtwLU0rY9m+cl9i2Niy94rGcYUXMmuuPpAkqcA9NUvSs5N1yMHPMXk3Cgw6J4a5LPIcHTB1EiDygUSvJSyqvTzBfnzFGUoQ6W/PTZ8/FrsFw415dyCDaDpQwbakl4+MRqnfi9h0L1WzI0Y27tSRZWu+w+l4UHj+81pgxUFz59VFhu4akxdLD/S5WOg201zNhEdLclTBMYuI1zq+N4mgOd1XC3OhJPaObHUOPmEwI7ZwHpxL6F2FQ3KUOzSRDKwDI36hk/0wjzvKxdE/gr1aQmSuHURNWN9aZMmXsONMIBbPO0sW/9rVH3ZhO6ETL0ky2YE/5UAFmCMKHG76ajhRKjlCYUoOwoMj1jxV4a4dpBS5RTT0meqLrvcvXl0nKdtwXFV12C9GddrkFduevkalNFHqZub1Xxw7NaCXW7JHEpZN0DyHWlDU5ATIMdKGwea6maLWzTvzpU8/oc8ywQF+wV+3+P353H2KJGs9sBnhRSFvdtYMHUlYN6Vk0E2kEDuvg4vgyN+WDOAYlzRPPcNYkswNrxC+gd0VJpJkp4CdDiYQdZGSB+YP4JPy8I0ndoLNQ3Njp2Jhn8aK9f01cBiP+GV7zOVWvi4ykM0JbvjoD9gvMdxXb9i70byVvhipsQCphh7mKqXr21MIhRwOSEWyZYKvVUr1zyk0a+eFtLEEH8WRnANd7ShYfihVFavd8iyw91G4gz
 BMi3UNO4
 cZzcmw3oRssNkMpEYno3NyToc0vXcxi6Ru4SIMQT2SPktbQUyZI2zz6GvdQBFh7XRilNKqsnFbxepg8ISCIYBks21mFBw6iUAvC0NBbq2ujPnBwarXYYULF77LJIpn3hbHeYkhreStC/JYtwAZHNTiHq4oKUk8j7D6qx6kH/0S22kcvZin1cFNpxtW/sm3CfrsW3l92LDTg5uKM9mqG10FOO2EhgZ7KwPnvRWVOSYIE+GRclLoyAcL4f4aNR/Q8bGilLxQR4h6QLgGLwcsK5x1Ot2eLd4VpKXA3zPi2MGFQCxB01LKydoP7hJifntULwPOEumaQfDmGOkoEoJInlL9dNTgaX1SP7VLBO2mJbhWpPAtxkce8g71SsMyA==
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


