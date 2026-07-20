Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0CDC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3684C6B0095; Mon, 20 Jul 2026 10:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6686B0096; Mon, 20 Jul 2026 10:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2052B6B0098; Mon, 20 Jul 2026 10:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D17956B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58C1312019E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:41 +0000 (UTC)
X-FDA: 85009355802.25.BCEDE1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3DB5240013
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvaFlNqC;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784556999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3cjoXT+ctO1xn/lt8vvk/EJQ8UQyUkXc5d7Z/bIJ8Y=;
	b=Vp1WR+zONs0Gw7wdLdjR3hnKq3XTPSza0AUjLUgpkvwKREgV0/y3H2ayYuwEwrOvk4Dom+
	bREnKZRa5n27qrC63viWg4x5Zyx5uq7odsh4Fm2Q4DbNyLs6Y5oBukLWqkXZoOExldEGGt
	tUsH/FsUPlvaS67B0KCDsWvgUVs0PqY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784556999;
	b=hV/LRMRT+QJzc55IF6QVeb3/xvJwVddSv5nyeazB6xHm+C3BLPhjiVrbp6/UNC/wI2xWV6
	t9xlyjbYNbzwS5J+sXVH+aTIdVzcdtRvR+MUZujuXfi1eGj5liyexOTnFCCnX2CYZwC/VK
	zAWKfSP3wowmmLge1EYHPmkub9PUHy0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvaFlNqC;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EFD2435D1;
	Mon, 20 Jul 2026 14:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603041F00A3A;
	Mon, 20 Jul 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556998;
	bh=S3cjoXT+ctO1xn/lt8vvk/EJQ8UQyUkXc5d7Z/bIJ8Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BvaFlNqCT3zRcpj5gpCsMysl7f1Z5x6KlIqglS3wL8dE7fDb4vfljJG69QgDI5aMG
	 irsjdWDIFR4nZ5vEOphUnEvvRpnatSwcD3L+tSFQxnLwyibGDXScYKQP9xw505CO+z
	 H0hbacgYBv9pURgI5jYIqD0qCXg5IiLDVdbPZgl3HguYxKGLm94s21tsc+ci5YagvQ
	 4J/mFiiJEZsj4PhXu94EfmM980cNBnzjoVjbDPS4Mt3jztWUM66oaQoOTqrHgVe9/e
	 SiDqHSdH5SqzgWyksDDDO61RgEpDbwIU+Bi9S9P8fZ0Yt/lbMKgsA3tCmHspiFJhGx
	 MDLFUHVSnvi9g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:17 +0200
Subject: [PATCH v2 03/13] mm/slab: remove objs_per_slab()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3DB5240013
X-Stat-Signature: rgetwqbmm4pa8gneyj4unymuz3fh4k4u
X-Rspam-User: 
X-HE-Tag: 1784556999-56650
X-HE-Meta: U2FsdGVkX1+dr96Aar6/wy9nJTcsJiG/jBDLjs7ThkJxNaThTcel2zzYncSjhbdHKnp9am8QTIazSyZsaPxjrTLa/C6ELjs4/53faxKvXFHcaN9fYp2NPQZ8yHL4fMf0uz0Ll3JPWhFWdO1lACWwkvsDiOxhNoND9Xcfb9YqNfulQd2YUKGTvYZlINk5llcKXqxOYR/tncXKIUGcabtn4O7WoLqjydHtpJLF57ev0AGsBk7LeG7WM2lAPxZzFamBO6yICWACfJ82UMoT1m3Z7DznFuQGc7gCuQKC2qVGjlXN07H7+PAtrMAz8+4mfhoxr3pBynNqadSEBTq14HP112Z6d3MbD2XZkfbno50fXDXhLYrRxq9Gw3apNVaSKJBJgYyRBFgE406C0D6/QpIA+MYDzNSkQMyw969p+Jyfv16a+3GHEwYcSHcFoelO2CmWliKWXeoPXltcuZWGBrnAmrO/CJYngcaguVJxlJHwdzg8HQa7QT0sXt3MeHbPXJK51n806LW1nFMass0OLMxxJFNDLvx2eMVzl8wX9RRbwEv/257oMXawgM0ndB26l1Wr7BOWhF23phdu8LRZmjfwQPHcxUow9fz/VFjZhBiLmhSbnD/YqwyaeQZAXvAd+XrxuGJKs+/iZHxDK0Fj0j8e5X8tha0rrV5SzlU0+TFxqmiu2qa9zTqVncOsz5OrKS/ajeaZgxUPuoipfpQ0Pj/fUyt9GfaZMCCjFksWGbiXM3Y8AIrR2gspUVmcFzWC+wdpYvvUQGH0FzO2pzYKTkICN6mQpau0u+/o6PIQq0iO/LRgHC5KR6/VLcRCgCL0jGCsKtHbt8o+xPUt950tHlLc6YZPBnBo9mQwZagC23n0yyrxs5mHzgQjpgfD8Fs57qZpbBeIopCjDNRmu5WFNw0HtJpy/iFH+uFMcIGwrr8CgzyoaURuEN2pkDpct9FKbTZ4MtgvZvesYC2zdi2TGO1
 n5BbIjZH
 C3p48jmhmD+uUVnBrlByMBU7I+ty0BSDE0M2emgJ0vbFcGgBv4Hk4FfHo9xkG/lKW8JRyjdO5CJ2KkJmZeKAeHK5l8ZlaQxSDuI2plrhcm6RFKVtGDKcTUkxVvwO8vcg4yA7D+A7QnQ6KcP1Y/whPdGtaM4nVmvzmAcvct0GaIM10ow5qkwKkLHXs5Y7ARf5rtqahSNc2OH2d/T/WYcKsZq7/CiJ18lZRMUi2LW+/HHPNUiHpsEZDgz9wvcMQfX5pxKGcPupoM44LPMPkr586ISECTg94vNYd3hw8WK/zS7zYBe7n6YJJ/QBHhlltEWZBqh+HDHXD9q5g95746Yv1HsuwNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function has an unused kmem_cache argument and almost nothing uses
it anyway; doing slab->objects is simpler. Remove it with the last two
users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: ‘typeof’ applied
to a bit-field" but we don't need to keep a wrapper just for that.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/kfence_test.c | 2 +-
 mm/slab.h               | 6 ------
 mm/slub.c               | 3 +--
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index de2d0f7d62b1..9867c03ef0ae 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -295,7 +295,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 			 * memcg accounting works correctly.
 			 */
 			KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc), 0U);
-			KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
+			KUNIT_EXPECT_EQ(test, ((unsigned int)slab->objects), 1);
 
 			if (policy == ALLOCATE_ANY)
 				return alloc;
diff --git a/mm/slab.h b/mm/slab.h
index f5e336b6b6b0..01535e1e2d3c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -330,12 +330,6 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
 	return __obj_to_index(cache, slab_address(slab), obj);
 }
 
-static inline int objs_per_slab(const struct kmem_cache *cache,
-				const struct slab *slab)
-{
-	return slab->objects;
-}
-
 /*
  * State of the slab allocator.
  *
diff --git a/mm/slub.c b/mm/slub.c
index 95fa6fbad11a..8c1031989e41 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2133,7 +2133,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags)
 {
 	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
-	unsigned int objects = objs_per_slab(s, slab);
 	bool new_slab = alloc_flags & SLAB_ALLOC_NEW_SLAB;
 	unsigned long new_exts;
 	unsigned long old_exts;
@@ -2189,7 +2188,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
-	handle_failed_objexts_alloc(old_exts, vec, objects);
+	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
 
 	if (new_slab) {
 		/*

-- 
2.55.0


