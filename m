Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1375606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WByHw8Pb
Received: by kanga.kvack.org (Postfix)
	id 11A2D6B05C1; Mon, 16 Nov 2026 01:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F25E6B05C2; Mon, 16 Nov 2026 01:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22916B05C3; Mon, 16 Nov 2026 01:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D45B66B05C1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59BCFC08F2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:50 +0000 (UTC)
X-FDA: 85440051900.06.05096B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91F64140007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WByHw8Pb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTc4xLzdAujQ6ScWi/lwPCQ//qRhKRB4Q39XzYz2O6Y=;
	b=MIFIKMEACUjTnIOJifhl9ItUOHVvFGAFAUcohNYuSnG+dvY8gSi0zeNEmJCdF9a960iXCB
	lhx4QvVXCusjvoKsEWJJPgQYb61NPkv4hJ0IH6et8OoOQgV2YTmub3Ec2NTflTUQNLqRgy
	Fz3JFu3rlc/ObQz6AuDRFioC0jgWAj4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WByHw8Pb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811668;
	b=On1D3LzH9VOR78zAEHgpkpEsrFiGnAx9J8yjcjxs0MJ4UV3tSj1/Cmum54TIjB8XI21T/c
	Z4Tu4xXJSzDOpZuSdILRtcjjAXSpU8NvGS2vxSiD8iNopD3d3XfPAKZfPA/wafcxiLDm4Z
	3UHYGgO1vulOoRJ2CvrlHjKE8LsrRmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E370145B75;
	Mon, 16 Nov 2026 06:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C99B1F000C6;
	Mon, 16 Nov 2026 06:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811667;
	bh=dTc4xLzdAujQ6ScWi/lwPCQ//qRhKRB4Q39XzYz2O6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WByHw8PbTY5AmmJyEbePVaApyXWF+L3JfmcBzWodnnH31DERC2uK5kovM1okyPzwm
	 X31aKffEXpz8u6mMsD8DxnIh1tFh2eN2CYmoOQz4rkzhczGZU0aRvihx08EvflYCvO
	 sF8apaLV7imRK51TJLD2L6BPLlJAq4r2oth39/rO3riAshVRhsp/yM1VAX6qkaWIUG
	 RgPj7tg5E1AWZ1rBpJRTDxlgGNlHIYQVQMzVEgoOgJhZcZKddsk5hrPfMbqmg+hyW6
	 UNjhqRSFAFu6vbRFVS3a4aegz2qlHHDkpLNDrOR8NIYVnVNWrAhgYh6TSnL75T9U/a
	 6+h+0el2PvuRw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:16 +0100
Subject: [PATCH v4 08/10] mm, slab: remove remaining compile-time checks
 for CONFIG_SLUB_TINY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-8-227a4b3636a5@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 91F64140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6ofxpwpijfcgcy14tiwg69w39g1pghzi
X-HE-Tag: 1794811668-743325
X-HE-Meta: U2FsdGVkX18foD4Ph2z6TIOV8GcmIvj5E4Js3HwHa5F4eG0vekcMXqG+8e4a/AgVU6T6HB4JAjxHDsEqFNDlqun058PCQ6RTrNihqQbNEf64n1/EWQAda2+Kof4KyHN6fDVOO9NiuVvKSvx+7Bx0en+5mb9xL+GohWaA1Ac32/OqjSnjHmcx4oj1UG3+u0Q59+nR011RXYu6KzubRWBpFLTOBfK1Rv5EhpZERqmPkija08qNhdkgvPKDX8Tj4BLECT4wyIXV05t+MDThrbI3rEUenY3I6kvqsl8GTjllUSlYfKaG9FKTwu/1REspafGARP0cSJeV9teYhc7gLiA19C4bbxc6b+N+b8jFdREA65Ax0RRXhq48o45w/BxrUcPqM8ZfJZ1GCSU815+cNn8aFHlLmoRicjPwrivzlZyBLiuyGkk6phIJnEavQDaWAtEJqFy6CiRBed7MxK39J/8rJ52bvMakHj0WuvafHGPfuq/VJQG6hnIb0rp4k2i1+/fzLOOn5BMiwK/RQyKq0vZV641cUWgx6bTw4pxG0e9F7wCrabJEdVonb7igjIkYOx9aMlJ7BCqdu2FHtwfL3AEacTY07Nu+ORYyPCtKEdCX8yeNfsGqqKCUTKN1iUDlAqtN2aLZIdLHKuA7XXN4VKUgXZfjHw/dObqeFfGHy8psq6lEyRZZmvvLhHydECGT3I/zdPCYG5+elcd5uRL/QxdIqfcL8Ft+E93502/ZbsIwOwoPRj/Stwgoo7Jtg9triNzlb6Ku6q4m8x2ZWRRooVw55oOfk91XjWjYz/cUQeD05pdQ6MOUoyG40G8HIe1Qg0MDa9PnzWf2sMNGPcLTQEps4zJe0/eDmqJx/fhM2uzxW+opAavL3k7Je8KbYgHMjEWpE+W1jApJwYz7hUuv2NCfNKJotZ94/HYYK6XJyBHQtdB1tLY9LeBvTVW9MJVyT9/Oq1aq5xjwwuqdFVWs2p5
 ILDF8+9b
 Q0mUtk4LjzQF7DjBDpIu4TdwZ+Ec5pi4nJIUPa61Za2X0b8SDjRlsIhV8pyy//33OXoNIx9AdDtoZ71mjdmxARJcnPBBers8r4gm9yvWyBvD69+ZCETG5C3YtBbPj5HDwLs+ObbsFpWIqZ4XLk8ZCIj0Jz5ht8Rg1iYb28gblEySYiD/pzW/unYfAV2G6Hvj3VTUujNePAUB6ZbDN9o2S8NLs7dzNgPk3yfIoV//hdmV5rP6KfiIdX0i0Ymrhnjz6oA1dzsuVGOtM4kixeXHHSUm5evdBnv5K8DbX1WmNuQVPkoF1PVNffljn/ZOAJ4qpMU/xbfhv+LbkCDs5UWAxBOa5yUQ7bQfDCxJ7gZITPA4a+Y0mzCww3UcZiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
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
index 7ea057fda751..d39ea67d44f4 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -282,16 +282,15 @@ struct kmem_cache {
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
index ac9dcb4682fb..bb57728962c2 100644
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
2.56.0


