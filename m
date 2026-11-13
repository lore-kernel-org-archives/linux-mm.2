Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC206606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Zq5VOko1
Received: by kanga.kvack.org (Postfix)
	id E1F4C6B05B0; Fri, 13 Nov 2026 09:37:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD04E6B05B3; Fri, 13 Nov 2026 09:37:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6046B05B4; Fri, 13 Nov 2026 09:37:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A33CA6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:37:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EF6A120321
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:37:46 +0000 (UTC)
X-FDA: 85430349732.22.3B62111
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4074B2000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:37:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Zq5VOko1;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794580664;
	b=CsJi50yb/dwTBeleJPaTHDky5jq6Z3B8qDERyb4JBwjkkZcR6D6YJJFOUrOfRDwS2uHOls
	ogZiz0WYPKmMAyOUgmStbTk8YIekHszOTq5ss7ZPGFLiZzLVzwTM4kQ4bTuh5NMVKzX4CU
	5/aa46ymW4SYRAABl9pr8impfIvQ86Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Zq5VOko1;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794580664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0XOYwcnTL1OrqwBoF5MD4vzS7pPsc+EeLqlZVee7Az8=;
	b=mp7mfaoaoGFdmZBXqoJLQkeZf2F95kgt4FX3PrYy1SI6QZ40gDYcLugEu/c/1oOo7fsbMO
	tBJoDkpo/8pQpRWHvTQcNZBPxNzXjO0unnVbG4mDgiIv8id7urinZjK1S8v+k5jn2d6Sw4
	oRUjYzRT/4r2wGTLBEJwqiWMjBux1lA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=0XOYwcnTL1OrqwBoF5MD4vzS7pPsc+EeLqlZVee7Az8=; b=Zq5VOko1cqLkfQ1tl0TxKx+U2A
	BrO5sDde1GL987KYcCiZwORFRaGRhWCRND/AA578kmIGBySGWMwPNnlzU/9ATdsmtkxhEBpFefRZz
	4eAgodYBVNWYi3E/dHCgZjxg8CLVCsyRbKkxAScbXEBWa9eSerzNOz4Z5YHdUu+bmu9i3IXw8PsqB
	VzZzEzFwhfgWyt8xWLOozoDBEoj+hbOhZZYiftGHSnDTo8qmcGd3qPmmeRUs+EmoXToM+iH9R5Ik6
	C5ygjQUx32+dq0wZOcKkGebrW9jMqBBpyhKw+iLR2bNNg8Z70A08/7aiXypNP1zy9xK+VLeS8cnK0
	QoFW6AnQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xRsPK-00Eoyu-1M;
	Fri, 13 Nov 2026 14:37:39 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 13 Nov 2026 06:36:56 -0800
Subject: [PATCH v2] slab: allow sheaves for SLAB_NOLEAKTRACE caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-kmemleak_sheaves-v2-1-8c557c66cec2@debian.org>
X-B4-Tracking: v=1; b=H4sIAI0g92oC/2XNQQrCMBBA0auEWSeSSaxiVr2HFEnN2Ay1jSQSl
 NK7iwVXbv/i/QUKZaYCTiyQqXLhNIMTRgq4Rj8PpDiAE2C0OSCiVuNE0538eCmRfKWiettYbE7
 og0GQAh6ZbvzayHMnBUQuz5Tf26Hit/4w849VVKhor8mGo+1NY9tAPft5l/IA3bquH7N2RnixA
 AAA
X-Change-ID: 20261110-kmemleak_sheaves-b3531591ad21
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Catalin Marinas <catalin.marinas@arm.com>, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5590; i=leitao@debian.org;
 h=from:subject:message-id; bh=hN7KC4nK5Owv04cUEbTFEZmP1bJF9lU4vD0yO9GIm/I=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq9yCu2z4dCHL6XE56dE2MUCgkEVLAj1Z+LJhfW
 majOQNI4FSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavcgrgAKCRA1o5Of/Hh3
 bUc6D/0ZOJiCyW6pVOZ/cMjO7dBGkn2UfsOs6ldvc4qdXQN8pbTs1ii0zdkGn07hDDXVyIhMK90
 3m/myaBOg+2MAVJzAkninWIt4Lnty27m9Ym3PyFdViyCliK89JMwjZgkXY58gJEzHjetIrngSoh
 e+jh3G7JJuF7QFJNU915x70w6YxU/Mu+HJ5DdHiTtw3LmgAkPo/v4dIvQcaWItsDv4mMwscaUK8
 Hbk2SnE6Xww0YOBA3ll6DxVCPQ7oXf5NNFVc5mfnrHXl915zyat1dlD1K0SM3VJdZfV1FkxTSDq
 zXl2uJl0vXmK5MMIRgH5r4rHNDYtQ0KcFo43xVhFB5R+ifz+RK8hFymOQk8ACQ7FHnCnmDBNVei
 9SEB1of1uGVYkUtHEFMoNMK+5q1YWzDIDkU+hdic1n07vUVSHM5DjpAA/6v/hxPgRKWiPPMaKnP
 OXRH+tmLR8RkgL2fU/3Tq95DY9zYeLRR/X1aY0J24RC2nUJSFLTplqFbT9Xys2/Rx3yACzAOELC
 JPOsKCJf49ECIJpTTg5kYCOBwG50rsA0+SNBDjAkvkfOEaPjXXlcL55wKMntQNFYDCEfhXCAa4l
 x5PcZRf77L53EqyeEsURk67CRn6A1cRY+Hk76Ekw4v6BnsySZ19iiktMoFgdylDtT5rSYPmM5jH
 n0t6paLCJ7yRGDg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: 3qxu8qjqcr3io87xdskhjz98ewxacpnr
X-Rspamd-Queue-Id: 4074B2000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794580664-141120
X-HE-Meta: U2FsdGVkX19z1yKp1LqlLhy3Uv46V9TmQC4HJizYXVzyu/6LNE/b/a/Kadszqfgocx1Bk92cBklMu1Rhha2aILNwbGLew3kz5N0kHTvt3P6Uq3cZBV6eO1LEPcidyYFXWKtRB/CFhXMa3sGXOLwy7gSxkNz46AVBbY6hi3JNt2OfFjOw9IbZwupvQFxnr9vugftGI6/m+DNHJxB9IAL3vTuJQ0XM+hXciI55FTMCR2uVPK/bCRks7D9aI4BN+Zsy2slZDUM1qRmh+8vKKUVhfbXjQLW3CPE3mLm3ZI5Ffl8mYsS6tN0KfwCjzmRwPOCo4c9Kfphh+S6c7ESRjzFmuFmcLgeFKrfObwiIYkWAl+ijGyfdYNxio6aobaA3AaviuLuqwCIDi645uGAbpFNtTZT7Q+KYzdmCLUr2jB2Z9bX2Nnihc6F0a5f4diRH6e09STPQ+jTSsXszciI4R72SkG+k6zVxaIVoW7F59d7Zz6WLA7vADjvkrANJP0gzQqQaO6gw7B7eH40d5OTolFs4sfSqtKJmv9EfnxjsQASLu5x6OJOaibiJy1YM8g1CI7vd/T1fwpwOcxAu5M3iL6Tzja51byAXumJ2gjn6ibBEraGDo1qGbE/xDgFrSFTzBLvefHdZFqoUoPl0gpgauJN+RhemVmuKNBWZnVBVOq+Tgomf4/ysfurFWfq5ChDk5IaCiR2YIBKeyy94eO7c9t217aUnadmGgIb+zZ0AKM0UJKJKg5tg8lYdkPpt4SKsBP3NhJGduYA6rNG+XoKmmqJrbQbZnUb+oU8xoidGZHkKkKJNrGZfcaDIU3+iS47qSVNtbAajeMBx7Dssjj5PMX2tCq3JL3w9TmgFshz4ufHbPmBvTCG+FDIsRniKloxEGKSBgGZ3wnN+UbrGA4e8grEiBYHPDbWx/ca4jG+P28D0N/PlYWz6HvwqvxXYkGFltnfaPIqaZGTjXo3VtFB51Jy
 hLJv8NoC
 w1/1/pBhWo034cT+vfN3/ppWBDiiP5Yn36U3C+IzU7gM2njn9trJzvuMDY8yxbo0sCUvsCNSkU9I0MnUcpnGtgc63uAw5g/Vu7LkNA3rKwxuGm8MCfYvw7tAgmcBvX97uC+EKa50wWMTMErJN0utSqjIs9ZiIvwPwSqlsG4e4jRHB+IvYxaJm1XtuGkJGw5l9LEK16qatWR+KCGSZdsTQiMCIwptxr2BYJv9P6F3fLK8g4OHmj6F3hkl5LTNtHxmWTHolRkFDI4Qcd9IbXKBiwUW1rOnHcI7nDvDYehFWpSgdPSslw7R7Jsgwu/p+lPb2NMllagIAtG9jGMjiYHM6cOF14SUYzXU10F69h5EuDIyc4XPjXitLR4hGdwtmS6ybj/E6EiSsfqaGu+4+9uvvkntuLseem8dGubeu0S1QNRM43p4HE/56Ux/nfiGWlzaHbzMHq7teg9KsYysbuc8T33UAmihG+HXMlX8/1un1ngYn9UF5upCwpP5fnblHtBb05S/GIxs4RHHR3r8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a patch that makes kmemleak cheaper to run, by letting
kmemleak's own metadata cache use a _new_ sheaves type. The flag only
makes that possible without recursion.

The cost today:
  * every allocation kmemleak tracks needs one kmemleak_object from
    object_cache. An RCU callback frees it later.

Why that's slow:
  * object_cache has no sheaves, so each of those allocations and frees
    goes to the shared slab lists under n->list_lock.
     - On meta's fleet kmemleak kernels, list_lock is the second most
       contended lock, after kmemleak_lock.
     - About 88% of that wait is RCU callbacks freeing kmemleak objects.

Why sheaves aren't allowed:
  * a sheaf is a kmalloc object. Tracking it makes kmemleak allocate
    another kmemleak_object, which needs a sheaf, and so on.

When I reported the recursion in [1], I suggested keeping
SLAB_NOLEAKTRACE caches away from sheaves, and commit e47c897a2949
("slab: add sheaves to most caches") did that. It stopped the
recursion, but it took the sheaves away from the whole cache, although
only the kmemleak tracking of the sheaf itself recursed.

Commit 17c38c88294d ("slab: remove cpu (partial) slabs usage from
allocation paths"), from the same series, then left these caches with
no per-CPU caching at all.

In hindsight, skipping kmemleak only for the
sheaf itself, as the new SLAB_ALLOC_NO_LEAKTRACE does, would have been
the better fix.

The sheaf is allocated with SLAB_ALLOC_NO_RECURSE as well, like kmalloc
sheaves. Without it, a backing kmalloc cache that needs a new sheaf of
its own allocates it with SLAB_ALLOC_NO_LEAKTRACE too. kmemleak then
does not track that sheaf, and can report objects queued in it by
kfree_rcu() as leaks.

SLAB_ALLOC_NO_RECURSE also skips allocation tagging, so mark the codetag
of these sheaves empty on free, as is done for kmalloc sheaves.

Link: https://lore.kernel.org/all/aW_NK2NXVgtuzCVH@gmail.com/ [1]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Fix sashiko findings:
  - Set SLAB_ALLOC_NO_RECURSE along with SLAB_ALLOC_NO_LEAKTRACE, so the
    flag stays off the kmalloc cache's own sheaf allocation, per Catalin
    Marinas.
  - Mark the codetag of SLAB_NOLEAKTRACE sheaves empty on free, per
    Catalin Marinas.
- Link to v1: https://patch.msgid.link/20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org
---
 mm/slab.h |  1 +
 mm/slub.c | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc03..7b20f10aa46a2e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -23,6 +23,7 @@
 #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
 #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
 #define SLAB_ALLOC_NO_OBJ_EXT	0x08 /* prevent obj_exts array allocation */
+#define SLAB_ALLOC_NO_LEAKTRACE	0x10 /* skip kmemleak tracking */
 
 #define SLAB_FREE_DEFAULT	0x00 /* no flags */
 #define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
diff --git a/mm/slub.c b/mm/slub.c
index 8369853ddca721..b927cd684ec656 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2850,6 +2850,14 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (s->flags & SLAB_KMALLOC)
 		alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 
+	/*
+	 * kmemleak allocates its metadata from SLAB_NOLEAKTRACE caches, so
+	 * tracking their sheaves would recurse into kmemleak. NO_RECURSE stops
+	 * NO_LEAKTRACE from reaching the kmalloc cache's own sheaf allocation.
+	 */
+	if (s->flags & SLAB_NOLEAKTRACE)
+		alloc_flags |= SLAB_ALLOC_NO_LEAKTRACE | SLAB_ALLOC_NO_RECURSE;
+
 	sheaf_size = struct_size(sheaf, objects, capacity);
 	sheaf = kmalloc_flags(sheaf_size, gfp | __GFP_ZERO, alloc_flags, NUMA_NO_NODE);
 
@@ -2883,7 +2891,7 @@ static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	 * warning, therefore replace NULL with CODETAG_EMPTY to indicate
 	 * that the extension for this sheaf is expected to be NULL.
 	 */
-	if (s->flags & SLAB_KMALLOC)
+	if (s->flags & (SLAB_KMALLOC | SLAB_NOLEAKTRACE))
 		mark_obj_codetag_empty(sheaf);
 
 	VM_WARN_ON_ONCE(sheaf->size > 0);
@@ -4727,7 +4735,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, size_t size,
 		if (init && p[i] && !is_kfence_address(p[i]))
 			memset(p[i], 0, zero_size);
 
-		if (alloc_flags_allow_spinning(ac->alloc_flags))
+		if (alloc_flags_allow_spinning(ac->alloc_flags) &&
+		    !(ac->alloc_flags & SLAB_ALLOC_NO_LEAKTRACE))
 			kmemleak_alloc_recursive(p[i], s->object_size, 1,
 						 s->flags, init_flags);
 		kmsan_slab_alloc(s, p[i], init_flags);
@@ -7987,13 +7996,8 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
 		return 0;
 
-	/*
-	 * Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES).
-	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
-	 * have sheaves to avoid recursion when sheaf allocation triggers
-	 * kmemleak tracking.
-	 */
-	if (s->flags & (SLAB_NO_SHEAVES | SLAB_NOLEAKTRACE))
+	/* Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES). */
+	if (s->flags & SLAB_NO_SHEAVES)
 		return 0;
 
 	/*

---
base-commit: 630059a5a632377b9b7b487baccde92b7ae1dd47
change-id: 20261110-kmemleak_sheaves-b3531591ad21

Best regards,
--  
Breno Leitao <leitao@debian.org>


