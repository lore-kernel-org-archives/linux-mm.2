Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06023C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CAA76B016B; Mon, 13 Jul 2026 12:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0366B016D; Mon, 13 Jul 2026 12:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE056B016E; Mon, 13 Jul 2026 12:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC7F6B016B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:58:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61A1DC0DA6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:29:13 +0000 (UTC)
X-FDA: 84983985786.24.BE2C266
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B13474000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:29:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQJ58xVv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDVLveXJA8tyZM5x+2AUKuT7u3jiA9Hoaj06+pMMJeE=;
	b=36U36rzvjIHjIIbwS4ANQfE4F4OTpVDhgRbCL63L5EhzC/zS0M28/fZ6nv6Gss/9V05Wb+
	e2cOC064IZYjUXJuNhpfemoVjHSKOMUMza8Xw++OA6ppmMjj8uLxCg01pvsYIu9VLb0lNZ
	9HerYwiLicdi0cnHBQgrr/LR8lQWOzM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQJ58xVv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952951;
	b=7T/YoDmhkfftz3zbpmxTrbxvv0EZxusFpNZ+FV3yjSakYxNKTc6kBcuzqOxtLxSNW3gw7C
	jkXcTwEaoVAPrPmT6EC5kFiNDU7RT67b7MyfsrkLrWkGrFHcsHciQoq+KTZzVkvPEQSjEu
	AoF7op/Kc6Tfw09UsndR0sJI74Vl57Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57078601D9;
	Mon, 13 Jul 2026 14:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86C21F000E9;
	Mon, 13 Jul 2026 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783952951;
	bh=vDVLveXJA8tyZM5x+2AUKuT7u3jiA9Hoaj06+pMMJeE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZQJ58xVvCyDtYjqCq2vQ9fn6eA8hROHL62vQG/NKYOJtBYpofOJt8rhG1UdEODJrg
	 VCgH+2ZXab3dlhStSwalPlGfgkt6JQxjYXh0UFNVHFZIkPKNwVXvXzXDjXk1q2VuTV
	 YjsYPHrA/RZx7+Mcf0sCZda3bytbJ/Hv8MEd0Y17YF5bTTs4Y8HcJTB4lpvY65t4lu
	 uU+w8DsylDL7x2YjVkF/BDdrfEec8Nq4f5agwpvyK4/hqITgAMQQhRof42QzyPmTvk
	 f2I/M+6BHWZtIFtutnxcFK7pYzy+Ca7guzfr9YUmk0/WqCw4JOi/0O0PO9ci7tCtZr
	 Du4K/95AV7g+w==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 13 Jul 2026 23:28:50 +0900
Subject: [PATCH slab/for-next-fixes v3 2/4] mm/slab: decouple
 SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-kmalloc-no-objext-v3-2-47c7bd138de7@kernel.org>
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
In-Reply-To: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Danielle Constantino <dcostantino@meta.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B13474000D
X-Stat-Signature: p8zctwpd1es8rjf3di3wwocdimipjqgw
X-HE-Tag: 1783952951-483583
X-HE-Meta: U2FsdGVkX19nSKbvDpjZh4D7sVxfJxpYemOJBHtgpC5QdSe0nMZb4i4fwbRU7AI2KospVaRJQUX67HlDN+0DBppud0l46GLoaM8OmhdzaQNDiWw4VRu5wpRRLM8IvbIYy21/1nr7BPg++ZdBpy7W878WSnUXuMkV8F7DIagFJLU3iLl1U2FqOm5jSL/EjMbvVTW8+AW4y0/a9wDhsQNbmiqIwy9I1XWvxxJIEaAHHiltFgaqz+nuWeEcLsWNmlRr3+nvsP2njwzd06DeyHQcj7dqKoAb+iPsn5UltIU4TRxvBF0CtQUtMLbMMDvNM2xTM4PXvjrNWE/Cm1s1U9UErnSo7XTxGhTPH7pjiIXay4BcR2mZTtHRrYICk+/YPYAogniJAu/XOvo0VBGrfRGrAn8HlJF72NcKiiERUFF2PmwNYHUJxZ0dbQ1qKLZwsR6nqGz4evw0cwiJG2j1urcSRWh0/D5YNyoy8L+N3kIo6c7ysUekGjLuvMaRFWGi8Rn3UFgjZlVpl4TpVfCT2oqrykxEn6BrOxRoCIXtRfh1rEhsTmIjUhS+1U6xhoNDNhBxO/ne/+XK3vYjKSKeU6q9xsvXx3PqmEz3os4qVZLc99aJT7BHbCmTQDRbsCnktclxyu4X4qf/HJqUM6udZp9AbHaOv6iyJWGZyq5oEDimTxQV2C7HltwD8lzvaUqCWgkP5Tpk5k5wE4KDlafFfcFZPsCwFvIO/K+4IVvHUyp8keV3SIoJKm4RSNa+wJqSq78mAN2NafIvWgUMPQvmVXoJ3ReEjX4mFVlRRBmRjOQZQW9r1G2O/ro4t2NTBNce63iEhdhAiV7KJ74XU/IQzsy/GgrIw/T8Y3K+863KMxzVlxOTHFCLB2IxLeOub7votAc4EXGoQcA3aLia4aBkHjvQ/jKRy8hYH/MitoPrs4jrCITVQO99XHM4dSUqVnNuzKgzHXdUAhXQUUXkwJsFpfk
 stpw4zY2
 GAO/Ju5lpurxWTc6r4kaT+6Dhp3ZHtEakqjo+ATjkkDudzcDtMurgPxJnYQ4fKBlMrTbM04eeOILnRBU9CWBKvAYLWL6qvx/H4qtFcs8hZlOs6fldXvlAfPvhGMypOwM91c2QdlIrOkZVtNLyD3cSQ44qIe/OX5AVrc24APhymS8A8JXNmCRkIGkIG2rL2tuco1AIJk3KySieOtD7pDYLEN0OU2+r1WAhe3D5FTax6yezykYCNQUP5VXSuwccudXfSwAp6uTa6puAk+Wd3qGI6obCLPOU5dxlyeUD
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


