Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF578C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2CFB6B00A7; Mon, 20 Jul 2026 10:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDBC6B00A9; Mon, 20 Jul 2026 10:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B486B00AA; Mon, 20 Jul 2026 10:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77D636B00A7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:17:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2F47A01C8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:10 +0000 (UTC)
X-FDA: 85009357020.08.1E0002D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E26380010
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIzxc26D;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNnHaVXxj/mvFCRCqUFR4sjoNHHhPJC/qg6efDIn92M=;
	b=uhbjMbNbBgDkhnE5J3oUbwLd0ZsMvqkb1aNhuAYk5wQst6MaoVRqIkJemZHHYPOUU3Tkhm
	dWitbbQ8hIfy/V2djVExMpEQuUcq3/MQvLbVtU1MmxGFoJazzj99xw9dP2Gri+32fAB0JG
	kYOpvQs2OqjPjxTCY99Dk90Ai1gq+0E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557029;
	b=KUdjNABzdKfJ/vET3hYRPzskRCgaktHSwnXfCe0tfpNqyjPgq1FPIHA8bc95OHndQqMCXM
	Vu6gqq6x4m7Su4MwDLHHBVOqrkNIRnvjapEWuSo93VI53WRTUq2kldSj+khH1a2NnF5eSM
	WI7H3mymcgbCFvAa4A4cO2P8j9uTt+0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIzxc26D;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7A9260A7B;
	Mon, 20 Jul 2026 14:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080271F000E9;
	Mon, 20 Jul 2026 14:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557028;
	bh=zNnHaVXxj/mvFCRCqUFR4sjoNHHhPJC/qg6efDIn92M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KIzxc26DhH1045e+ExrzClszygTXStN9ECH4U/XdwnS8Yusfg53YVrEKplbAB88oc
	 4X+Df9BjB+OdTt+/vJnXkTl4OX5SBWervBjCoAA748KRgWIZhdBX/djV/P7R8F1YM/
	 tIsk4nrzCIQ1zt8B/G5PRTp/VhZHNtwvuUhscDZsaHynVXz3lybUDVJRWT842UFc5I
	 H8DRaiXxjTn0fWntsAXEQq0EPBS4RMl0wgaTYpU1fHKm1VIZAkmg2bjW3Em7oGJfA8
	 LZT3aAjEa3WdIoDoB+W6P0Scq2wxGAktVuXYVe9SBwmjsnNgQS5VD5Cy3uV/D2FTaX
	 MUHPhfGNWXbng==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:27 +0200
Subject: [PATCH v2 13/13] mm/slab: stop allocating objcg pointers when
 unnecessary
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-13-2fa7c6f60dbe@kernel.org>
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
X-Rspamd-Queue-Id: 4E26380010
X-Stat-Signature: y8wof353nrxsixbba7sby7put1yz6btj
X-Rspam-User: 
X-HE-Tag: 1784557029-325388
X-HE-Meta: U2FsdGVkX1+Ck3X94yrvrV7M16Edit0QU7nwm/zyzpxEE/X4YAGueseys7wTAKBaQgPQAP4SnCnYwLFw6GoVNEn1ER3kj7BSKA71topTwErbxvmeZ9r1gV24eYWvKi4gPheU0VcHUTfcUSpQR+PYFwWmIlABOOcYljqYmkgyo1uTRepgyj00BZPzp/P4eT0HrxL0+t45GC1a1vUvghyPTdECaJ1EWVHer/5N2myRhiSyr51ufcIZB82x48JBmUPlq+ysYAkl8w2ai1PYwMKl4Kif9JZwSqGbOvNeaa1LA1v7SsC2CzrGhwNNGXvaFAb3WXKyslrGuxeeqrBflmxphtPD197x8FMRYW1V/qzXE6AYStHOGvxPCwF20KZsfam7eyd2XcPSbhjPWtTaaHcfZ0JyuTmGbgSPIG/AFF+OL5uYSsQhW4g1R1UN0OaPY6hqontussuTZ8Hi0/lBKkEajANMZI33Bntoexw6wDgC/16mkvS+pL5oNheHhonmFfOtx9527PWzpKTYlYh+E5Xabs3I0fRt/Xhi1LZOXKbzYyNxJTonzhokdE/g8aJnzzEDPCMDiFHj/vycvXxpSrzmwxCQ6xn9J2jd53K/LcHso4W41Gg8bwuI++WMm96Zl5ijTh3IGxE/W7d7WtyUi4e3P7SEBFXF6p1Q8HRJAyV0I8OK4NPKnfiQEvgEXgc8JB3A1c4Pl3cFyv0I/TELrwVJM7KlmUOEj/jc5iPzF7Eeeb0JjAod7F7Ez33eMp0S5iE56gGpnYz+/KgLgsLfWABlAqvr2j1Zy8dvJwlgRDmTNcO8EA2B3ANnJZNH8nWkzsiitM7vuzMMOuijL6LtupJSf6gvzsVqDkv+erigj6JG/isBIC49wbTesHBDgKDBq2xDgdShvFijGiYRTWmKMPFOfEQUqVZuVHrFF2pRiBKddfX/iZuLxisx2WgojekcHzSblwvXua453y7TDD5C7iP
 RimE304a
 +dylerhLLPNzr09u1at2+tfKn8GycRZn+xdNN/LtrgdI8++nu5qoRTfRHH7o+ep7nrwGnnevj5nWljbk2T1UByGB1LFm5rDaVcQ+20wwRcHEuOFVJ1CRyAWqz6SLsiCCom2OVtzgBBNL5jH1C+Bd9AcX64mKMMo4+es/5qRwS36Ek3+hbgUBPh/KMJ1TTNFqHfd5l3SlUFJA5iWPouN4WyMO1K+BzXP19sDsmJ1h36rlFZ1FHrAhIzRYwyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Start using the slab_needs_objcg() helper to calculate slabobj_ext size.
Caches that we know to never need objcg pointers (currently
KMALLOC_NORMAL caches) will thus stop wasting memory on them when memory
allocation profiling is enabled.

For things to work properly, we need to also add slab_needs_objcg()
checks to mem_cgroup_from_obj_slab() and memcg_slab_free_hook(), because
when obj_exts array exists for a slab only due to mem_alloc profiling,
we would otherwise attempt to access a non-existing objcg pointer in
that slab.

The function __memcg_slab_post_alloc_hook() should not be possible to
call for a slab where slab_needs_objcg() is false, but add a DEBUG_VM
check there to prevent breaking this assumption accidentally.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memcontrol.c |  6 ++++++
 mm/slab.h       | 14 +++++++++++---
 mm/slub.c       |  3 +++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cb1e97b4edc1..aace85fb99f9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2871,6 +2871,9 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	if (!obj_exts)
 		return NULL;
 
+	if (!slab_needs_objcg(slab))
+		return NULL;
+
 	get_slab_obj_exts(obj_exts);
 	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
 	objcg = slab_obj_ext_objcg(obj_ext);
@@ -3580,6 +3583,9 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 
 		slab = virt_to_slab(p[i]);
 
+		if (IS_ENABLED(CONFIG_DEBUG_VM) && WARN_ON_ONCE(!slab_needs_objcg(slab)))
+			continue;
+
 		if (!slab_obj_exts(slab) &&
 		    alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags)) {
 			continue;
diff --git a/mm/slab.h b/mm/slab.h
index 65b44902c06e..18c2a807f023 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -615,7 +615,7 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 {
 	size_t sz = 0;
 
-	if (IS_ENABLED(CONFIG_MEMCG))
+	if (cache_needs_objcg(s))
 		sz += 1;
 
 	if (slab_obj_ext_has_codetag())
@@ -626,7 +626,15 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 
 static inline size_t slab_obj_ext_size(struct slab *slab)
 {
-	return cache_obj_ext_size(slab->slab_cache);
+	size_t sz = 0;
+
+	if (slab_needs_objcg(slab))
+		sz += 1;
+
+	if (slab_obj_ext_has_codetag())
+		sz += 1;
+
+	return sizeof(struct slabobj_ext) * sz;
 }
 
 #ifdef CONFIG_SLAB_OBJ_EXT
@@ -753,7 +761,7 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 static inline union codetag_ref *
 slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
 {
-	if (IS_ENABLED(CONFIG_MEMCG))
+	if (slab_needs_objcg(slab))
 		obj_ext += 1;
 
 	return &obj_ext->_ctref;
diff --git a/mm/slub.c b/mm/slub.c
index 30435e2509ea..e6148b73b92f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2512,6 +2512,9 @@ void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 	if (likely(!obj_exts))
 		return;
 
+	if (!slab_needs_objcg(slab))
+		return;
+
 	get_slab_obj_exts(obj_exts);
 	__memcg_slab_free_hook(s, slab, p, objects, obj_exts);
 	put_slab_obj_exts(obj_exts);

-- 
2.55.0


