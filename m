Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D809DC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EE46B00AF; Mon, 27 Jul 2026 08:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447666B00B0; Mon, 27 Jul 2026 08:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EE86B00B1; Mon, 27 Jul 2026 08:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0466B00AF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0B7940719
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:49 +0000 (UTC)
X-FDA: 85034551098.04.ADCB618
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0E6B10000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UT7XURPD;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGp6l8pNN7WNTKPcSeBuJWHpMtYin9pxGaKm+CCO6NI=;
	b=oKQO6xh/UuVvzFvXW1BIgD7/4AY4xSU7mE9tRn487/2QTVehEUTib6B+mEQR06s3cU3KyA
	wf8jpGh10d+L+/JO+ftYF3FeHZ3cXf58xdL9cXBN2bpPZ6oWaY6+zgLVfK8XvSBati6peV
	SpU6u4MVIWInjxgvBhzuCNwWJ5+5qjk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156888;
	b=R/O7gsng1XMsek5ypxD7cgd7R6fMMdaJX4gutMKW/l9KWLQiKzMbrPY8+GQnnrRhW0eDR+
	6T2hxxc5GSExKlSDdKdPduDjPxCe0JpYDQ1gnzu/pvlGCC97Ue/V6DXhKmJryVAHvCr9FJ
	W5atqtNiRFus/Y4MR+krz/T2KWhutYo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UT7XURPD;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 469C2435F1;
	Mon, 27 Jul 2026 12:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2331F000E9;
	Mon, 27 Jul 2026 12:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156887;
	bh=aGp6l8pNN7WNTKPcSeBuJWHpMtYin9pxGaKm+CCO6NI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UT7XURPD6WCdpFBPaFw97mhbwUjd9PlShAr2/GsEXCn6ZQh3B9XiB9E22vOm4iesl
	 Vbf1p/lY+Co8LPi/Q/RkejFT+I21fLFAAzodxDPTiMH4YuGfNeYg2z3HW0bXySVvKi
	 hzRBlObSeVnYzdDsMnp8kAXqgVFQOgI7pKaUzHLpIZ0qvA/46d2neIIuh4DKsQQlr+
	 p2w+SF+jXNMvy17CPh0CkCWPlAPXdZIL69lsJivvKAxf0YQHMVHLW9hGrWYoiqaZi2
	 yD1NfKPSSWCi9jdgPzVj+l6xXtkM0F07i5WU5brohR54OzTPBMX7WtrzOAGH8K+Jm7
	 fudr5KIAb0C2A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:06 +0200
Subject: [PATCH v3 12/13] mm/slab: stop allocating objcg pointers when
 unnecessary
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-12-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E0E6B10000E
X-Stat-Signature: gzye6me9rhusmyra599a5argu4p5uuwa
X-HE-Tag: 1785156887-906224
X-HE-Meta: U2FsdGVkX1+6uY61KPE/WCl8mb5IaFtox8kHAFSZuaqgQJusz9tWb89a8Eua2Rwp36OJ5C6P8fxdnBh93Xl7gazhUoowYrCk7SrkBNkI41KWw1RdqGbKRXaQLG6NpxYAma8g7MBxIQkCtYMmh/4vxu7+JS6GYiM3nCjq4FudU4I7gqdZ+vOBf22sJM4uZS6fCgI4DNUuod6GKGIPlN56kynO6d0pUoH6bWRqs9a8BEpk0VwzJW4qBfGTEbV5DyiuYgkVmmP/IBAAuxE101ql8LOffg4hHFZUAFGbbbI+SRQKi+OLrEOWzDWyrrl+2u9GeQ+ROXDtU6zsHjqOK97//1tbn5XuHkC1L3oB9H8sK1EKXcxQTkhtREfJG1axvDQKGuTvEOBV4RJFEIVe1gR5NskQKhLx+11xyjr5qMGXPq0tp4hKV1HO2CwELKCwR83wG/c/iTWfbinalO97iT/TkIc+xMaxfWaAt9qwY+UXljDcSY+Q8NhPW8SDVvnQniZVQaKjc8MVUhXRjMvHrSRxqMDuQMgF4PlAiwXdtiKZ+4MtOmoMeLFYj7xIizyhOd+K2wp/gz8mzMq0btwfDj4iJU7qKrBbu8EI2v8zPFWDSpzfA9p0vGNPavvHELTqe59DrPxygj/0kNsd3nUDabW2mtMohDK8gEOzTHRmeRoHt6Ck54o9mgcjvoT9N6sLCT0jtR4EUMrix/hJqCRVdvfWGAIfNkI6HjrPfGR9koOHqQYrtVX5MTrys+aeFxrr/GwHht6b/4ExfDyTv//uGXN71GKNksjVszVUYZCjZagnTF6ZWjiW1zzAWY3KR22mRrvQ7tFK4lNouiTBKfFJXryaQg97vDC2xhMs2V+rF6R7NZ0974OAeHpuJQC3YOguT+GTkCp6PY80lr0RNJ2QgJhrsFYa6X03wE6aaqsaQ4LNTaMjFZTUpUYb2C2IEh4j3FXhay+NTseSYTFmya7YKl8
 VtjxOEsU
 mo36453KaD3b2Hfs+q/wRN9d+QjI9Y1xqi7FBHOvEYVQ8NfX885qgJMTvuomIGWPIeM0CZ2TAME0zD61LP9ky4WG6TC65eySIasghKcbH913DDTiqDUFGZCGHEXHrn0kyLeqMVNvRe/b8atUb9xLlZiyCzIoQRJNMwKZolrPe0JNS8njmqDeIcpopbfwAQjzNabUQvKSULH7JZisdWZaUfDC+NOi/anI7HDBmBkfcXnqkb/r9KwnuFmkvOQ==
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

Reviewed-by: Hao Li <hao.li@linux.dev>
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
index ad2a3ef34ecf..44f9b2569e80 100644
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
index ccce1faac6de..893a11abcc20 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2510,6 +2510,9 @@ void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
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


