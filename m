Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6078C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9CBC6B00A0; Wed, 23 Sep 2026 11:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75466B00A1; Wed, 23 Sep 2026 11:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8BA16B00A2; Wed, 23 Sep 2026 11:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B16726B00A0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B6D71A053C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:36 +0000 (UTC)
X-FDA: 85245451872.30.3FD50FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 87C7C14001A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YRPzTi0t;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMIQ8REFMb6acQ/FvLPkwRl4y6xpfycLIc9I6w2Z8IA=;
	b=gO7pHePPKcg9Te50bitA+MU7KmbWGbIPzMn/WrSfB76s/8JF9FWKClE96cjEM76SvFDzjS
	d0/XMNWsE77Cv0X9dswHPaJnPGYg7Au3N3uD31pWhyuEIy9vndhxLuoDsdaHpFId0ESuqU
	1h1VA8KGkhnVyR7SXUeYadswcQMV2jA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YRPzTi0t;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178334;
	b=EryngmUUoU0cp94XsCmpZLon2iuNBX8SFcakocFPNx4ZkmsIZCgD1XFSnAv2I8q43QqZse
	GsmyLSK+uLHsTArZzhvjWrezOZZvnh8glPjMLajhf6zFOUeqqSzwYfJrCkG6SGjKhD8WNp
	tTW9EXwMalYPY4mPhijX0oxUnAf7Xv0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19B0B60142;
	Wed, 23 Sep 2026 15:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91DE1F000FF;
	Wed, 23 Sep 2026 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178333;
	bh=EMIQ8REFMb6acQ/FvLPkwRl4y6xpfycLIc9I6w2Z8IA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YRPzTi0t/aNV2USi5quM29/LcexoXRiBzJyVHc9Cl1NZCUu6aGOkFA5NIXTzkBGGG
	 6f44I48FlewUg0O3N6WPXf/un48KDg2WhoHiT5YGYI3jL7Zdgw1ggOaK38pg+wZV9P
	 WaP/ezP/ugqgqP3VGWtVnn9ZSbKDjpdCZEIdxiSRYP/dK6VqS+YKOA8r0vdx2i4XZd
	 9RTd86EzJ009yfGLrGbMYV/4vqlKryoBdV4OxV9flX+3ALsrKpm9/+k9SUFVTOipfc
	 o3eZdGIFs9qvAqvURHcZsRJNp1r0QF9TLs1bYbzWuW9MfdoMmt2elyJErc4DuDxkXT
	 cKUAZ9xA/yJoA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 23 Sep 2026 17:45:11 +0200
Subject: [PATCH RFC 6/8] mm, slab: remove remaining compile-time checks for
 CONFIG_SLUB_TINY
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-slub_tiny_rework-v1-6-a0e66d536eb5@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87C7C14001A
X-Rspam-User: 
X-Stat-Signature: rcqwq1pt4uxa797z7xees6ot6xb7xifq
X-HE-Tag: 1790178334-722327
X-HE-Meta: U2FsdGVkX1/DjW7NYcv0LCvCNhfrzULMyzkc/zPKHoTUDOcbMHvPPpXQGm9YPTwI3AJLUo+3MsnHU9DQTJMChQs8UaLuQB32MCNaV8ShyiDBqCXKAMSl27FjrxY6W7hu4fa5xSooA7+Sg5fgpchMbU4cF9JiFqSYcOpogNB6h9pyf4288ER/UeAJlK+OjKIuaR9NevFIhpsR02GU2A7pear3CPgl4xodtS9txfHjDnQrRVJX6KkwKJAnVFama3Y9tq/2STM9M6VorNTfNdgwrjJZLVHazGJOL5Af+okQghDPif+oKblO4oi3g5VqASXnYJXLHL5vY6ee3NMGz8GD9tii/LzhBgp8XK+y9hshk8XF6DGrr1//02ZCHX2RjnasMOV3q/FK1/JTsL2cbVOKNdgynMYxc20DFESuTIcByj6asXy2NyGsxKcepZYvUFwltq0+fXsfnR3dndmA4rS0OMnUWzLnsCc9X+/pFeIjOLJhEghqSzI5OCF1AkE0PpG/MToOVpqn1XUxipuSvF8zzWDt66AJJhZKYBrB/aomoYioH/axyk7faHlbKfoYeSxJmasQERZnWdS/+3MVJN+W1et5JfI24hDUSXby4I+2AEqGkkjQX3GUMk5Yp/dp073q31ZCZHlysl6/2A0WFgQjnmvXQz0qabv0TDPlLsGj6Q7cRRxtdPKadQT2T1YGcKmPOKYmHqMR0d+0yT12NsXFoGXmugXjx7YZjywzs0t+rJ442A0G0SkOb/a/gYFynT/MEE4l6KajXYm39fVBAAG2/6vOgwBIsR5zJKTrq5TLcDCBa5XGTV+1XtFielVbXYw+P2QLXbuCMEpXFI6s2OXsNt6baaHq5Nk0y8fsuoVpqNgjDHeCXeuxCAW1S4jRfb8BPyVtpmbR0SnqcNOlsrBMgPCU6+L2fxLr288g1X+T7sVcF4Io4TWvcbWMsvc+X4yzU5PeUOExEvOPJQ3IY2i
 vHrAeaDm
 U2pUNnwM1gVs4xIQNtVN/wLk9mB4j3kfX1uqzNJjqp1Atgt9+6pVaff43kuMLzuuVX3OvK5ax5Wv/O2HvKacVjyRl7MyheEbozroYGpH5+7H/9icAtheWDItr8gAwXw/DuPfbA0srqUUEos8mdo0P+1dprFX5troRJAARksVc2iXA2JgSrNJVgqDW4WbXEMdk0g2V2bi12+v35N2D/3sINU6/VV7FqF9+EKqZkea1rr0SFcQ5eK9obc4dRiRHxHD16kGkiLKhdlDY/IpWkicG5l5i70cYqEluk/EQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove several minor aspect of CONFIG_SLUB_TINY to allow it to be fully
a boot-time decision:

- remove check in cache_has_sheaves(), with no change to functionality
  but only on code elimination

- remove SLAB_SUPPORTS_SYSFS dependency on !CONFIG_SLUB_TINY, thus
  /sys/kernel/slab will exist as long as CONFIG_SYSFS is enabled
  (for now leave SLAB_SUPPORTS_SYSFS around, can be cleaned up later)

- remove the control of __fastpath_inline so it's just a wrapper of
  __always_inline. Leave it also around for documenting the intent, can
  be revisited later.

- remove a comment for SLAB_NO_MERGE as we don't want new checks for
  CONFIG_SLUB_TINY

This leaves the only usage of CONFIG_SLUB_TINY in slab code to set the
value of slab_tiny_enabled around.

net/core/skbuff.c keeps using it to control SLAB_NO_MERGE but that can
be dealt with independently after the config is deprecated.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h | 2 +-
 mm/slab.h            | 7 +++----
 mm/slub.c            | 4 ----
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 930dd64b9ad6..ad645967a3ee 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -188,7 +188,7 @@ enum _slab_flag_bits {
  * - general caches created and used by a subsystem, only when a
  *   (subsystem-specific) debug option is enabled
  * - performance critical caches, should be very rare and consulted with slab
- *   maintainers, and not used together with CONFIG_SLUB_TINY
+ *   maintainers
  */
 #define SLAB_NO_MERGE		__SLAB_FLAG_BIT(_SLAB_NO_MERGE)
 
diff --git a/mm/slab.h b/mm/slab.h
index 23017a5d10d1..065de2b92586 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -296,16 +296,15 @@ struct kmem_cache {
 /*
  * Every cache has !NULL s->cpu_sheaves but they may point to the
  * bootstrap_sheaf temporarily during init, or permanently for the boot caches
- * and caches with debugging enabled, or all caches with CONFIG_SLUB_TINY. This
+ * and caches with debugging enabled (or all caches with slab_tiny). This
  * helper distinguishes whether cache has real non-bootstrap sheaves.
  */
 static inline bool cache_has_sheaves(struct kmem_cache *s)
 {
-	/* Test CONFIG_SLUB_TINY for code elimination purposes */
-	return !IS_ENABLED(CONFIG_SLUB_TINY) && s->sheaf_capacity;
+	return s->sheaf_capacity;
 }
 
-#if defined(CONFIG_SYSFS) && !defined(CONFIG_SLUB_TINY)
+#ifdef CONFIG_SYSFS
 #define SLAB_SUPPORTS_SYSFS 1
 void sysfs_slab_unlink(struct kmem_cache *s);
 void sysfs_slab_release(struct kmem_cache *s);
diff --git a/mm/slub.c b/mm/slub.c
index c6a0422e055d..4814f025fde5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -196,11 +196,7 @@ enum slab_flags {
 	SL_pfmemalloc = PG_active,	/* Historical reasons for this bit */
 };
 
-#ifndef CONFIG_SLUB_TINY
 #define __fastpath_inline __always_inline
-#else
-#define __fastpath_inline
-#endif
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_SLUB_DEBUG_ON, slub_debug_enabled);
 

-- 
2.55.0


