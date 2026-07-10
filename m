Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E24C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6AD6B009E; Fri, 10 Jul 2026 02:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67A66B00A0; Fri, 10 Jul 2026 02:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4F96B00A1; Fri, 10 Jul 2026 02:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A35A76B009E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:04:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3750F403A3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:04:08 +0000 (UTC)
X-FDA: 84971826576.17.1770FEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9E68C20003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:04:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h66H3jNc;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663446;
	b=og/wNHNLNEekVfuPKh9Peym36sLEc5iJoSASTJVMC6cDqU3LY2DxXZ65GBqqFJCyk0vkxa
	iNNtrX/J0j6NBMYhy+6C0FrdixQFE8LYFyPuk8x5UwYKmp+dAGOtdV/ea8i4cWMb8EHMMF
	mKHaK4Bsky6Ad9DAvUM4pgFzQ1NJSsA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h66H3jNc;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDVLveXJA8tyZM5x+2AUKuT7u3jiA9Hoaj06+pMMJeE=;
	b=b6wKoFBiZmXCl3cJdLT5FLX89iKEBldwcSIOYdCZGjJ8mSB5yHyj6xVW8LR8ky3GuO/pbo
	zCePxQdvB+zrQsIT5FdwjKCWIcDezlxuaURBaNLmobt5qx2+dyj17qjoxkXlxzTWv8QJPO
	4uZTctR6J3cON/vvei2fKLNgBTp4G1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 429C96136C;
	Fri, 10 Jul 2026 06:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898081F00A3D;
	Fri, 10 Jul 2026 06:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783663446;
	bh=vDVLveXJA8tyZM5x+2AUKuT7u3jiA9Hoaj06+pMMJeE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h66H3jNcRv7BzM08w6K8XqIrUenCowDf1LZm1yDgcD8Y7uHBzWUQbPPebxQnZXIEB
	 hYVplaHL/qYAUp1U4yOnYClnjwTqil6y2dLvUUtUoEuWQ5Zn7gc1B4fB+rpFvrEBUA
	 /1Bcx2oeqe8nwdhy+8Vk7YMXiy6xYlbUmWyHXJQ5Z/KgMvQgqc9xiJZdp/kzxZb/XP
	 32zn4z9n/9h4B19VG5RZZAqiR46d5i+ZZ+S9bb1w/6I4UvrAGNEb8/aBKxe6DntkDy
	 ti0JmapcGO9NMR1S2xmN8MCCDeoQFW9/z73yiVr2NtxRpyG8vvXcu96YnVS1i0kpN+
	 5bXu+0mQKNKfw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Fri, 10 Jul 2026 15:03:33 +0900
Subject: [PATCH slab/for-next-fixes v2 2/3] mm/slab: decouple
 SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-kmalloc-no-objext-v2-2-2709afb6a030@kernel.org>
References: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
In-Reply-To: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Danielle Constantino <dcostantino@meta.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E68C20003
X-Stat-Signature: ow6qweqf93dphzqeen5q7d6ozm7sfm8w
X-HE-Tag: 1783663446-135154
X-HE-Meta: U2FsdGVkX1+2aDi1xN7rVuXhP5Tzj6uC0/JPGeLXOGTjzjF8r5tFfzyCi8XM3EwB8TromPL5zY0LtGGeaJfd/WFwN7Foauzmbh5jQZLadQeX+dBSrm78D+e0rYk6oymEftaTrSbc/6S9scN3EzjNnTDbBSwaZ8YW/Ar52AW9SVVB1OtiMFg8r1YwyFScrtmDCtVaOrYCsv1bsn5LGEmqg8yvbRrTWH++EHmEPv9Yjz7EXmOmFxOlOYbuUymXM6C1dkdW3Lh2njEF9tFXdVNBiPxZ7Iklytw1xI32IoIQ4BfkFhNiEwaWrRY/A/9NDbATEYupKNsJMrSkVBR2SPmW+KQGThFqbKpQoPWcWX4iEiO7Vixemu8I//NH5bShsgcXWGGskVdROyswMPVJ8A/lKUZyf9KCrEyFTxPw40tcXk8hsUQafe1T21xElQxkLYqZZMLFHHGPt8+3hsvEzMnuLvIQxNlDrts7GwVrCBOuJ5gvO8thsIyPRzjBnhGv0W2luc8eJIBrSqact1QBZs4L3te4dyuLsyMvM/Fg6r3y0BO6kGUUeM2Xh/Y3+BouVScXiRUbxlFRJymahzsiD7j8T7FcjuGgqjjHZOlHmF32nRYLozrz5RY9jOi6f10yzmo9EfYv8Zzy3oYfZUlDaRpV5KmfWOMCB+FPqod4vbhDjw1OUOLVbEQHSsAwsGRDpq1+oRiVXGjZcRFrCZB5MxhhrSro4Q8BlA2HxeUKtiHq+h6m9p8KdhLBLLMvjubmWfsh3abx6bxG/YefrKLA+acC43arrQ381QALQKSb7lbYzXYUljLFDMRC+xH64/zU3v714v0Gin0P5cY5RYBpll5QI1g7ax6MLQWUFrE+0TEqF7CqYBvPVSfwtJvHQsFO2TXI4Ky2049n0+5jIqverorxuvvEQXtVJySkuwgQceAFowuP5o8pa3OFIiyPKEJGu8a0TIPmaUU9t22LiTzc1t/
 i7xbm5et
 qrLKzl8ccMyyuFm0gpdSaQChaHIyTcq7Neqz2bf9oCsm72yr/0afoWeWB0UTjTP8WhRE6fTeL88sQV2I4E0l7wRdvTO7MkitrcHO8hC9YSNuXEexhtv2MAQjzcOYekCNmJdmix2XPoWMgvVYOe2v8OzSq3BJ5h8P3EKoTqutH5PRWNlunZeDLHxo0X1Bvrcyw5/lFMhIS6+Wo8kQPhHK/48GCw6cvT7HxnLjBhxNaerWdEcnVDISq9n/urjDsTBOjylcyUt0oQBo7u+LZ79yPSz123X0czKuXKxjP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bootstrap caches are created with SLAB_NO_OBJ_EXT to disallow sheaves
and obj_exts.

To allow disabling obj_exts while allowing sheaves, decouple
SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT. Bootstrap caches now have both
SLAB_NO_SHEAVES and SLAB_NO_OBJ_EXT.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: e47c897a2949 ("slab: add sheaves to most caches")
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/slab.h | 13 +++++++++++--
 mm/slub.c            | 10 ++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 51f03f18c9a7..08d7b6c9c4d6 100644
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
index f9461a0c47d3..abe748b7dddb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7799,12 +7799,12 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
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
@@ -8586,7 +8586,8 @@ void __init kmem_cache_init(void)
 
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
 			sizeof(struct kmem_cache_node),
-			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
+			SLAB_HWCACHE_ALIGN | SLAB_NO_SHEAVES | SLAB_NO_OBJ_EXT,
+			0, 0);
 
 	hotplug_node_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
@@ -8596,7 +8597,8 @@ void __init kmem_cache_init(void)
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


