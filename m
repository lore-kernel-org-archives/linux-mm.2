Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B310C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 12:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AEEC6B0088; Sat,  1 Aug 2026 08:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05476B008A; Sat,  1 Aug 2026 08:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5256B0092; Sat,  1 Aug 2026 08:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A96186B0088
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:25:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 298EB160119
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:25:45 +0000 (UTC)
X-FDA: 85052621850.28.FFC7BC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92F76180009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:25:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XgBVE3Gb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785587143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fR5GQklAEmMIRAxF5ZINhcf10poKg1/4k56TIs+euS8=;
	b=qdIhMCfE4GnpaZsLkRLl2RJyJrSAj+BS6Yy08t3BJSSuk7ECczyuKmFfr3iojtEW9hckdM
	jcyuh0I3PaIsJkO68YNLd48SZNY3qxLiCq1n9iRWzHhVGk9osPI9fRjA6sB47mpQxBrOtO
	jNruRoBekN0QXZPquRRz5btc6fhVw7s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XgBVE3Gb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785587143;
	b=6ErWIBumggDKtLFcfWF2CEIx2gFf2g5ZoDUY9KoELPy0cb84VmKZkv0hMzAU2/tFsa1Ky5
	fvCCQaWOiCv64NUIZ5NM+ByMm0xIe+jqWStcx6NHPY1G4+zeIKDr3pQMgq8h3EAcQAZPdN
	ImaMx0Rr5xqQXbCa2407fW2DKgtIAuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B25A60A90;
	Sat,  1 Aug 2026 12:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63901F00ACF;
	Sat,  1 Aug 2026 12:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785587142;
	bh=fR5GQklAEmMIRAxF5ZINhcf10poKg1/4k56TIs+euS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgBVE3GbYz9QXwCf2ZRYlPhwPyUGUCO6C6tk9Pc2sQnSY35UCRgBrOJw4nNPSBjJe
	 7mKzbtf9C50CiWxQ+T6Ch+6bbkQUy64hdggkkV1/GPNmT9VegCkXhWu1RnPPl9AOGh
	 JwTWoJKtKGgQsh7iwJKb/A3T4FRUr1gvYiQOPe9eRlvISnD38j5w7BZiUyc/asvyxk
	 jwMlqIeV556EQIBILYc4nBH6N7PoML3cOtJeTYYA7nkEEsj9pMA66ZY92+kc9ncQl0
	 h8DQx1B9KOEObFLTFXfe/gYKYXAoodT2LqnpKvKNsVcWzClr7BOtVsn0dTipceSeuQ
	 rGy2YU4jTfIDQ==
From: Harry Yoo <harry@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [7.1.y 1/3] mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
Date: Sat,  1 Aug 2026 12:25:31 +0000
Message-ID: <20260801122533.319272-2-harry@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801122533.319272-1-harry@kernel.org>
References: <20260801122533.319272-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92F76180009
X-Rspam-User: 
X-Stat-Signature: 7hz8heoibjdz8d5thpkfjxmeptzuomnq
X-HE-Tag: 1785587143-672423
X-HE-Meta: U2FsdGVkX180MOBfAHwUsbfD/FOtNrsurIr8cYhd+sh9HYKTiGXPaBquRnXBdRD0ew4KShU9SijVSxNcFR7yuXckPVNA0fef66PZFmIuodzYkQJWQMzxO3rQykCZlv6k7raW09uog2XRigBE+j16rz7H+/kdIF01JIMlPSrHCmRLEYr4qwgr4wwxD7yhePJlhp8ea5BsY+jEQ21sUqugOJUOrsG+k/H4cAwDZSzwqPlhbgzBpGOTElo/vyW7gKzAv3R3jfLkNRXp7Qv8hmkv1bUf8Nj+tOcaedOzBtMB0+A3/EfN6X+82esyEvPiQng1WjYuPY2SZ0T4USV5MYls/LZyBrGEBY1Emsvgwiess/Rl4GeREn+u+8JSqaZ8FiRBvjDjSJwMkm87bBYMeSkj4ENe8F0fsgmeYtD7dxhxTDyC799VTPnWhJbeANL7M5A1aPfuNXuZV4nceF07RihHHCs8luDG7Mf5Wd00brkJrQIGZ1fuDUZuWsJnOz1f5Wxh2et8Fg+YW5TL0GZxs1C/wAjBhi/6hDrlKMZU1vSoVKQc8PyTWPQo0HwseoXzsscDO/RXUIQR0MOc67e+wGTXgb48CDx/3j48ZjcNYqzFvcAnfbyUfsmc5+Fdn+vdqhKNNKeAH4j7zeOTQKo3B67ZLLUdsgLHtmjYSZ1fnJAf+cghUEGz/1QqwlcqgqTK/CsoH97/h1ljMtEw/pJaNDusbbqQn5xT4Ukk28gOM+jf+JNyudooGgcayPTvISEkaHWsskRBzxWnY0KF2YdWMPnySBZ/US/G9p2VOYMGbdn8RjQYjGy8j8dzR7KYxreZsNeg2R0hERnzu4PeIxbblb/mD4rNEHTDngypMDdZPhF0UpECTKcjbLWxX6bHlsf+j3W3j3X3UMdC4WuSCO7wMXD/LJUzx8IobEtZCulZs+xNpaHuR4f0TkL01QuzqiWSL+gzSpQyt9HiEMJ0OsSs4lK
 3x+Isa/i
 oYBDjwcIOn2uTclgmOwzpNX9LRwaMF1SakB3k+j/Ai1OcxdxpHvSd2kZHnbMscmlhwXovtBTbpucbDy+S0AtMGwIXUThSEQt8kaCkL2K/ZK5dgD1XNmkqchrd4pEWM4VUhlh8Nc6JlOzDXVzWjJYa+9joA0IY7Xwoy3nQCAiDXYGCR+foUUr+lmQ0zbP5K+6x0mYPFZYPgzCWA3+106Z7mNipSV/TmbZtP4poc5RnzjEYYxwAd+ybO1ExBV4pAylqQsVANwsY2psMZ/YqXoHULCUEdh70+DVBZLME5ClrrYpcvd88WDCcJFdfsci/oHUeOunre1RWBEJvH+wArb3/gh99q2V8Mlqz/y9XOBC9llnwh4RPO0Wk2n3Cy+z4LcHg+TTcng0+AJ+7ke8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Harry Yoo (Oracle)" <harry@kernel.org>

commit 982e31382d9a1a3c8c4e6a13702a53711f4efe9f upstream.

Bootstrap caches are created with SLAB_NO_OBJ_EXT to disallow sheaves
and obj_exts.

To allow disabling obj_exts while allowing sheaves, decouple
SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT. Bootstrap caches now have both
SLAB_NO_SHEAVES and SLAB_NO_OBJ_EXT.

No functional change intended.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260713-kmalloc-no-objext-v3-2-47c7bd138de7@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo <harry@kernel.org>
---
 include/linux/slab.h | 13 +++++++++++--
 mm/slub.c            | 10 ++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 1a69255bb87f..fda7e24a762b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -58,10 +58,13 @@ enum _slab_flag_bits {
 #endif
 	_SLAB_OBJECT_POISON,
 	_SLAB_CMPXCHG_DOUBLE,
+#ifdef CONFIG_SLAB_OBJ_EXT
 	_SLAB_NO_OBJ_EXT,
-#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
+#ifdef CONFIG_64BIT
 	_SLAB_OBJ_EXT_IN_OBJ,
 #endif
+#endif
+	_SLAB_NO_SHEAVES,
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -239,8 +242,14 @@ enum _slab_flag_bits {
 #endif
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
-/* Slab created using create_boot_cache */
+/* Slab caches without obj_exts array */
+#ifdef CONFIG_SLAB_OBJ_EXT
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
+#else
+#define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
+#endif
+
+#define SLAB_NO_SHEAVES		__SLAB_FLAG_BIT(_SLAB_NO_SHEAVES)
 
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 #define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_BIT(_SLAB_OBJ_EXT_IN_OBJ)
diff --git a/mm/slub.c b/mm/slub.c
index fa24b985a783..33e64f21ecc1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7726,12 +7726,12 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
 		return 0;
 
 	/*
-	 * Bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
+	 * Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES).
 	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
 	 * have sheaves to avoid recursion when sheaf allocation triggers
 	 * kmemleak tracking.
 	 */
-	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+	if (s->flags & (SLAB_NO_SHEAVES | SLAB_NOLEAKTRACE))
 		return 0;
 
 	/*
@@ -8513,7 +8513,8 @@ void __init kmem_cache_init(void)
 
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
 			sizeof(struct kmem_cache_node),
-			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
+			SLAB_HWCACHE_ALIGN | SLAB_NO_SHEAVES | SLAB_NO_OBJ_EXT,
+			0, 0);
 
 	hotplug_node_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
@@ -8523,7 +8524,8 @@ void __init kmem_cache_init(void)
 	create_boot_cache(kmem_cache, "kmem_cache",
 			offsetof(struct kmem_cache, per_node) +
 				nr_node_ids * sizeof(struct kmem_cache_per_node_ptrs),
-			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
+			SLAB_HWCACHE_ALIGN | SLAB_NO_SHEAVES | SLAB_NO_OBJ_EXT,
+			0, 0);
 
 	kmem_cache = bootstrap(&boot_kmem_cache);
 	kmem_cache_node = bootstrap(&boot_kmem_cache_node);
-- 
2.53.0


