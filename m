Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F59FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D1C6B008C; Mon, 27 Apr 2026 03:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DEA6B0092; Mon, 27 Apr 2026 03:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23716B0093; Mon, 27 Apr 2026 03:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 936FD6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:10:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C0318C462
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:10:37 +0000 (UTC)
X-FDA: 84703462914.14.F35DCF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 58E121C000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:10:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h1WPTm/7";
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777273835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWDOJR0WMdVebkdanlSTansMbhmv5INxPKMTC6tDTP4=;
	b=OHjVndvV/YERmQdODszBKcZ3v9abWLna5LAaNhZJsq7QSPtHsV7iR0bPNJoAOVchM66vUg
	/jzR/RYlzCKGNsykT5UQp56YvbAbQOUL9A0KjvKsQtPHCicyAYYQeJQoqLeMhHdu08c1pl
	QyurHiCv1+vvnXFZtYso/6H2/jXYLKA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h1WPTm/7";
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777273835; a=rsa-sha256;
	cv=none;
	b=Fo9wmi8jva4NsOiUXszODT7UAkvVav+3FTd/x/KgmbFrVclBSzzhVQS14gzgTVEIV0N8iS
	4OQEfKkZIcGyOfl8XPuurwY3s9n7sbKmV2+BxbEx2UToNl+REXOWHgkQz/7h8rv5eEpKMq
	bl+HgCdRiJP5kdQF/vXF8MFvf1uf55s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EF7040725;
	Mon, 27 Apr 2026 07:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6265CC2BCB9;
	Mon, 27 Apr 2026 07:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777273834;
	bh=XdF7XzRa+uODLYSJER4F3+l7tRbl97mH0ZDNkW5g1/M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=h1WPTm/7QlbvpxONpZIjyQnpJr6EYMV7k2vo7US6F0HAY4IArxzBTGL7BWC/X0XGj
	 9bNX81UbibUZo0CqTQptZWXTyogqqcq1VvMllbSjGKMZV0ejjZ460LuerJVLdwwY/T
	 74PAP8PWrie/s6nHPH6KSpGaff6DD3DHTtaA053lf2fB/juXjq13WQh5JHOoU+51mm
	 3soWU4q0jEgU01GZ5xgUlNVDpWrcoadEihit/OUTmjbBt/vZ9DAHvbbeh310IyeFdo
	 ENOTUXZ+vvq4OMeC7oMnQOsGl23ewtTJV70bYY/B8/DMKEGNGN+9G/PPtQr4Kigsk4
	 AMG0KIQIrCG7Q==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 27 Apr 2026 16:09:53 +0900
Subject: [PATCH mm-hotfixes v2 2/2] mm/slab: return NULL early from
 kmalloc_nolock() in NMI on UP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-nolock-api-fix-v2-2-a6b83a92d9a4@kernel.org>
References: <20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org>
In-Reply-To: <20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Harry Yoo <harry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: b9ghxupfx8h3d88zynt1cwm753wweqtk
X-Rspamd-Queue-Id: 58E121C000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777273835-342990
X-HE-Meta: U2FsdGVkX1+ffxucy3IlxKT8HQOCxRNLXeP24gvgf3Qyy70Iy9kRwiQ9xXy0vDvIBNJ7MKBRac7ZV3Qbu7YVif3UaYd/9BQRWJe3LfG9n//K0OhlsPDP4kH57MC/z+c7nAq+YHkPq26iPm7wZlgB+swHNpFv/odPuLUO5JLy5Lc2IXWKGPrmb+falGqcHwtV1yKWQAn1O9pvjC7Ar8HFG9hTtS9JAfSyz8wtjPP8cbg8SyvdL/QzevgP00AY9B85JLXXpWtx5/7bUsKMAmnMi2/Y3AuiPMoMSW5oR/6pAW97ilR+zLhExxBVd+Bh42jLYnsarT5JwAywyYVZlUN1NnEt638Oju6VjA0jB5MIrubRwve/QJFRAkT124xpqMiZWTj55bZUIRU+yKnPtDprhRAnTOTszfzDt9b6P9ujMJ6oUZo89E0KyGulsmHlyFT2LDPVaqw7IRROiKCn6jatmhWQbf/cgmnOqT9orJOpNIZNTQgr8EtBbWxKGY2ad9TA+JyR30SC73BxeRM/Y7nblOE64d0xExSpZ7rl8M1Ymgpw6cA8otW2+PpIPWh1bYn3OuUlT3+lUyi8nVwEz5U55bhq626fgcyEsbFqtcoF0z3UpDRCTZv5pgkcGT9evLsB5ZFghEug3UXZ9issBQ4ceItZLSOI3Yz+Lsfo+q9MuMVQDJCaAL31ziQtA9pkpCIUUcSkG5XRSnKynZDYAasoJMidhgA7HZbQgvq1tClyeRFNzG9y3yOw7vV7DgKLJMz+HDPatYjFYCwuJ+nMtcrkS/aYtyOX+OzQ3xT3lzZEO4rIfvntY/19nN53SHiP635Mc89kKSBIJfV2uZh9HvadEqK6iR40jRi4wDjALeR6KpFhCLNrlSmTQ/JMqftavK9ta8qfMUWPqgzlfhCn/BCFMS2QozegL3IsSIN9Q+foGEg6+/Gw7vwOzkjQvriNsRT92fINIjjuUOHlxQqJEEF
 APtJiPLe
 vwQTjKwOfV4wOBcdDJDcUEOWeb7Axk1Vm4Oxj3ANjjuWe4bLWXZGzLWSzCCBEYTe9vYApMmByHF4NJ1uCtQlFGmYZRa5SMX+plkBxOIQeLAfWPIjHGqKSNoaR3etO0YUd3FdOU4b/wJEM5h/w05E7cf11ScZUpOZxJsuTJ/Lkd8QPNij/XcyEAMM58+HwsYGJgp1gI81IzYpnJQj1zwVW/3+m6n8YvOMqM8p0YqfrVyYwFn03+YhiQ0GEdOLA5p0bsGMMwAKCSBITtWJHjVYk2nvbH0Rl8xRg0BZT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held. As a
result, kmalloc_nolock() called from NMI context can re-enter the slab
allocator and acquire n->list_lock that the interrupted context is
already holding, corrupting slab state.

With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
the slub_kunit test module:

  BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
  [...]
  Call Trace:
   <NMI>
   dump_stack_lvl+0x3f/0x60
   do_raw_spin_trylock+0x41/0x50
   _raw_spin_trylock+0x24/0x50
   get_from_partial_node+0x120/0x4d0
   ___slab_alloc+0x8a/0x4c0
   kmalloc_nolock_noprof+0x164/0x310
   [...]
   </NMI>

Fix this by returning NULL early when invoked from NMI on a UP kernel.

Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
Cc: <stable@vger.kernel.org>
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 92362eeb13e5..b4ec15df92f6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5339,6 +5339,10 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
 
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;

-- 
2.43.0


