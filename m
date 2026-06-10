Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FBF0CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE7B6B00B0; Wed, 10 Jun 2026 11:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5FF6B00B2; Wed, 10 Jun 2026 11:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3F46B00B3; Wed, 10 Jun 2026 11:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0696B00B0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:42:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 429BE1C0CA6
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:42:14 +0000 (UTC)
X-FDA: 84864419388.04.06A7114
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 77C0A12000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:42:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GEd6pmnW;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LD3P9VI3kjMnaqB1oWeO35sHnckrRuScdE5T1wmgSZs=;
	b=NC+brfkpyR9pBVuYEoMXzBnVasQzH3ptvqgFyJHfVemSnUCMpas6Q3eGYYeD2I8as2QthZ
	tWiCKqNp5lwe9BduodttpaJd2lf+/odow17mjoqcI2OnZPb+NXpd/oz8wEmwFHnLh2l74D
	t6vVhfFzug6xXmhj35cYr39XW9Y/j/Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GEd6pmnW;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106132;
	b=4YHnzyetXBDXn01S+z6PyIGSjnUvWE75KUBhMiWSSx+6Ni5B/V29mGLhGo/xy6yNuKxP4g
	6dcevQk/grRMfw0NHmWKKpGb9HqJGO2rIT/FNXXQSr+X/n6P1ajFhRBACBKkkTIbYgS79c
	HlBIZQK3srca/JK3F/sB10OPv5U3CB8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F2C4438CD;
	Wed, 10 Jun 2026 15:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1361F00898;
	Wed, 10 Jun 2026 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106131;
	bh=LD3P9VI3kjMnaqB1oWeO35sHnckrRuScdE5T1wmgSZs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GEd6pmnWoUybWjiSrGOgz3MjARHxwYF1EkDs3P05KxdPrviAgZnvZrs3E+6sqnGyV
	 /Xc1+8914FhjyocqKuioJa8fozQXsDwux14jBP19Ecyuqba2Gn0k6k1BAwHWsCnjOp
	 O6ShU/N7791wlISrpDXJKvtNRIMG84z/WSudl9weD0K38WwRwUur2BfDVDpIHF23il
	 u1tmFh2iyChexe2PkTC0Q3knY09QmGQM+D0OofLrzHtoccqpHWYtKPCKS9guSiGc/u
	 AlzpHYv/fqwCHFnUxkz4yseJ1+E9O7lY6wFjATckkfEJFXS0VjQFd6TfrgQ/YAn0y5
	 EetBTmqF7i+jg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:17 +0200
Subject: [PATCH v2 15/16] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 77C0A12000C
X-Stat-Signature: sscem9xtawny3ieg7f975s6mignej5nh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781106132-398441
X-HE-Meta: U2FsdGVkX188CVabL9r/ELAKdPySl0d6AkJGpxKiRg5aqY7Mgx0WEj3kEunwLfN4ewGZgLS8tyrMRywSV7e+qus435HWHhCeuRjccfcPgB1idJq6mKRjBaLcju9YnrOrHe+oHlaGbci7aJqeBEK4A9QAJsMnUqBHP2EDy2Gn0X7tD2wPiAkmXgkdJsaRNKmMfeXN4YVP8u9tQ9n20XOfSw1R/lUkeQDNsy41AR4h2fwLvSddTkXM1IIcEoIMUD0+GaFMsQESzC0RCb0IYMVCrZDD08Tnt2IfnTkJzSkyhYfoxjVz0OOB5aViXr8FRbe2fJ8gRvlw/M3qMbvfHSGqg+Yi/ptYKLAyiNUptsEM3znay1WFJ4bb9M+LMjVII0nL+M4TBb5tjl7sT+zHZPTZqQwFBS9vUuFwj8VqXW6X0tBT9CMuAFQfqOV7MBWAvc2TZFmppALXnsSZj7NV7cwGGKyVRD/pcvf/7GWTi2tIV88mcRcrCP1GshuhPi7rTKKAXqPSxYoh4Y8qDC4xD0qd4Sq5IS+yn1V6DLX0K6GfG+53GFnY9oxdJ71WLwWGapAbYTIBZQy6xlE6x52jwXCxuFuzR72eX/2BswN9/ofXAsI12y3n0BRdPNR6OhNlkK/4Rc/USOs/Txnm14SoouwYmOhBB6qZ0PGqw7Oaa6+yZl7/c2yQ6jV3kBHkDmRb8ORrFsHjpmr9M8BuA+S5Q8NrkYbo+JYWafShzWpJOik6fdn7Gg11hbAQIrfLbovf4B0qmbrcbL+0DPQUv02bRL2rHX4LXNjgZEmenA/Xk3zyMGq1R+h2E2rW9nbhCKPgODpyxbVlNdLLgHae3C9963bd1rIAXeSEh2q/BEJIityE/GbWMRwtR2jA+t8Ul3MyTdxlnj460kse7eEb7p3ujmf2B31s1X9OxhOfF+gHYeCKpL+nX77VQPbBT03i6hMviQafmeXqGtDUn6/haQIaWsc
 h9cT8Gm7
 k/3H9vAdaUcY3/MJydpx8vGgnXVLcFeoC/9X79RRdKSxe6imFt/COS34hWGiqx7CrEHxzxOVfIKD1SoEKRjlkOeww53oDAdL8AbzKv9uQQ8GXyyyaT0Bs6VegyQizGNcZHklPxWVphfObGgHKnbw7/sGF3kwPNHzYzC/L4Z/KXW/+rpFHjQr/dzNw/DtR22pPDQg5LYjhKXN5qWebPnK3X1ueNODt6K8tFplg3akuQs3duT+RXx9xiWFQ+egWs6D94YNj/uKp2sEvrcjhr2B8bUkVLeuL8sS62P9L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and
gfp flags are a scarce resource, unlike slab's alloc_flags.

Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
__GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
family function should not recurse into another kmalloc*() for the
purposes of allocating auxiliary structures (obj_ext arrays or sheaves).

First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
added. This will also pass through SLAB_ALLOC_TRYLOCK so we don't need
to special case kmalloc_nolock() anymore.

Note that until now the kmalloc_nolock() ignored the incoming gfp flags
and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
the incoming gfp flags (only augmented with __GFP_ZERO), because if
alloc_flags contain SLAB_ALLOC_TRYLOCK, the incoming gfp flags have to
be also compatible with it.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h |  1 +
 mm/slub.c | 13 +++++--------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 45bfcfb35a9c..509f330654b8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -21,6 +21,7 @@
 #define SLAB_ALLOC_DEFAULT	0x00 /* no flags */
 #define SLAB_ALLOC_TRYLOCK	0x01 /* a kmalloc_nolock() allocation */
 #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
+#define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
 
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
diff --git a/mm/slub.c b/mm/slub.c
index cbb38bd01e46..7dfbd0251aa2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2167,15 +2167,12 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
-	gfp |= __GFP_NO_OBJ_EXT;
+	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 
 	sz = obj_exts_alloc_size(s, slab, gfp);
 
-	if (unlikely(!allow_spin))
-		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
-				     slab_nid(slab));
-	else
-		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
+	/* This will use kmalloc_nolock() if alloc_flags say so */
+	vec = kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid(slab));
 
 	if (!vec) {
 		/*
@@ -2251,7 +2248,7 @@ static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
 	}
 
 	/*
-	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
+	 * obj_exts was created with SLAB_ALLOC_NO_RECURSE flag, therefore its
 	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
 	 * warning if slab has extensions but the extension of an object is
 	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
@@ -2374,7 +2371,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
 		return;
 
-	if (flags & __GFP_NO_OBJ_EXT)
+	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
 	slab = virt_to_slab(object);

-- 
2.54.0


