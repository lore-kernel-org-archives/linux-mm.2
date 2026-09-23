Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65A0C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1567C6B009D; Wed, 23 Sep 2026 11:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E11E6B009E; Wed, 23 Sep 2026 11:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11FB6B009F; Wed, 23 Sep 2026 11:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFEAE6B009D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FD2E40503
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:31 +0000 (UTC)
X-FDA: 85245451662.22.6548BD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 836F340006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7OTHLD4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzT0YNZekEUjP9R0sb5doBa5YOLmVvxQILIsqj1HgT8=;
	b=ZIEesAyHKKBTOLVnzzipFTItL/roVRfDvD/v+gFHy+AuvjrvC1605QtzZxPBjZ9ivmzCEo
	y2s8W8YALAYNc8K75YleOkwh4va14A/hxJTDI6PCzGq/sJ/kNe75OD/cuqp4p7lSgihg/Q
	igoHgFyKeCdYrqaFTk+Obn38jQoD2g8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7OTHLD4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178329;
	b=7YBwq+gYMhYRLXTKuYvGqkkDrDAkGm4zSywBFjmXhHWZwYuLizhkTUWn5h3C48bExXNG90
	MALnh/u+22rMsnS0aFwQ7rqUnEj6E/37UiKCuytJFeclpJWaFVEl+ZI2rLccMWTQr3XWyh
	voM/joMRkn8gFyAN8dLmtR0NX4Nf71E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C38C343D91;
	Wed, 23 Sep 2026 15:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F671F000FF;
	Wed, 23 Sep 2026 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178328;
	bh=NzT0YNZekEUjP9R0sb5doBa5YOLmVvxQILIsqj1HgT8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h7OTHLD4zH6KwJ6BLFqpcKrGs3/t4gr+WYAn8O9Bo6UWEIK717FJcpQcPPo6FNOfL
	 As19/HSnO6zPWKxjEbIjEZrAgstc+GM7B+ikA2oa8Q+UYxtlCRBhuca6Lkb5PI7I1g
	 jpH4nyb9ASSYfAcWLvUiaOEM9z/dHG8Inr1gSxHLN13im1WQ4KK9nBgCDT4p960R96
	 mNcWU+OSWHFlUAjOyCO53HZHLgyLF/GhZALDFdPhq87GITelC3l52X2UEqERId29qn
	 wAGkz6H2+VvUk0NniOL6loNnfSem0f6VeI3P0tGaXVHY2IQRinHG7n23mREDpV4w3V
	 VEPH/eFmvOWgw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 23 Sep 2026 17:45:09 +0200
Subject: [PATCH RFC 4/8] mm, slab: make SLUB_TINY handling dynamic for
 sizing decisions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-slub_tiny_rework-v1-4-a0e66d536eb5@kernel.org>
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
X-Rspam-User: 
X-Stat-Signature: 6n8fy6m3md6yyw9qhm3is7594d86etmh
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 836F340006
X-HE-Tag: 1790178329-446009
X-HE-Meta: U2FsdGVkX19azbpYfynHa4HXcqhfr1nIkdgBbIXWPALA1LdzyBUkCsf2YOSQnCD/C0EHITmsPGk0Tgh0RcD7gzHBOlArO1JSMCy25HLcrQdPTD7Rtz6MR667WafzWXT2G0ppUW0CLq65K9gW+lgAj7k6QXUvi3ojW4SFwQrTESSEd65DmUxnsffPlPREu4vpe8JvBATJQg1rJ4sDUVr+5QxHxvrYfCHucSbv2hWB7OpmJMCDO5J4O0ZUolG8EHgGrwm1FEgAP40HqpVNFX+lQR1npo8FT014hSz2rHlFjYYAzeFKDRi8hjIURE/g5/EfrGFMmK86l5sbaU//fY9rWwvGA+guJGCo/Y40MgHYjGRBUs6RRsmB/mnVPdMg6TmTYPcLb51CY41qFzCVvDirA6QKLV3zpfRR5Ik5h2cb156VubbOX/Fe7YioZY+ZEUsPUIY6gT/018EQMz0CcG650kgn9rFfTj3fA0agCHdOeFRa91RAbLjl+xvIwB3z6dfZGN/zIgGP9BsB1DjccNXJ8/nWK9Sn6m8YGDb6zK1iUmOOKDyMkGYBgUmLERw0Z1PSpDq5UjtP6N7LbKMOKXlZ8mrISgCiosR0KOUE6cdKRELOzB0Eb+8/HZqMuhtoKZogyVJ0j9jMUBko8ydzZ5MiGYXKjDGe/CiiyOV9NxdUlA8+0/kGFFfntKwLHJA4vo2NMnip2xV9bRj9rb9atbUPb865FiexCgLsG9SYbc/8DPQ7GNScGp1VB6pWBRo6X9R/ghbEjeNNWSR0q+cVdADYMU+KufdW1nk+aOeqQvDSTxE8QwOoAOq3S6F9al0SJCnbGOWLtlPbr20i4uvKJdpvQjW+QpHke3TMRWvZ+QPjvExNxNCjxp8a/zIGSBhTBVtuyRMGT/q0ak0OhJafWJ8tnhqX5XaXRj7WAxOVEVx9BPH+AjJL3jPo+F8cl4wdI76cS4vzR8/2/au3hLz5ume
 5ED/qStC
 ScfT6L9rDuLy0AdFz1OochJA169GHdh2RF1wZICuGpzqx3PyUFxYnRDW7Wpq/HpUh0EjX/5Axr/ERMlYzZr4G8xQ/v2kDKIrvaLZOD5KCRdmwLc1yl61/aQ2AUM1CkrJfOINuTvgWQNotFNmN+rPBFkkf8RLoHlnYzNXnZi9gv6DvgLDa1ttx7HmKoEggVwjrwwQH9BexRECGQAtMDqS+NreW+XD4AcOTAmTUVx25ztMLTQaFpDpRP+xGgOM/OicqHXUYqsJvToHBClEpJohfnHR8VdrlgQf9HfPfELwmMzaTi8ezSgn6vZ4E5kYFkwbPN2s3b10sUu4sKEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enabling CONFIG_SLUB_TINY results in the caches' min partial slabs
threshold to be zero, thus every slab where all objects become free is
freed immediately. It also sets the default slab_max_order to 1, with
the goal of reducing the potential of internal slab fragmentation.

Rework both of these decisions to be based on the newly introduced
slab_tiny_enabled flag instead of #ifdefs. It's still possible to
override the reduced slab_max_order with the boot parameter, as before.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2a7b3b3b91b5..2c8477033700 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -272,7 +272,6 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
 /* Enable to log cmpxchg failures */
 #undef SLUB_DEBUG_CMPXCHG
 
-#ifndef CONFIG_SLUB_TINY
 /*
  * Minimum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
@@ -285,10 +284,6 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
  * sort the partial list by the number of objects in use.
  */
 #define MAX_PARTIAL 10
-#else
-#define MIN_PARTIAL 0
-#define MAX_PARTIAL 0
-#endif
 
 #define DEBUG_DEFAULT_FLAGS (SLAB_CONSISTENCY_CHECKS | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
@@ -7604,8 +7599,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
  * take the list_lock.
  */
 static unsigned int slab_min_order;
-static unsigned int slab_max_order =
-	IS_ENABLED(CONFIG_SLUB_TINY) ? 1 : PAGE_ALLOC_COSTLY_ORDER;
+static unsigned int slab_max_order = PAGE_ALLOC_COSTLY_ORDER;
 static unsigned int slab_min_objects;
 
 /*
@@ -7924,7 +7918,7 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
 	size_t size;
 
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
+	if (slab_tiny_enabled || s->flags & SLAB_DEBUG_FLAGS)
 		return 0;
 
 	/*
@@ -8660,6 +8654,9 @@ void __init kmem_cache_init(void)
 
 	slab_obj_ext_has_codetag_init();
 
+	if (slab_tiny_enabled)
+		slab_max_order = 1;
+
 	if (slab_max_order_param <= MAX_PAGE_ORDER)
 		slab_max_order = slab_max_order_param;
 
@@ -8783,6 +8780,8 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	 */
 	s->min_partial = min_t(unsigned long, MAX_PARTIAL, ilog2(s->size) / 2);
 	s->min_partial = max_t(unsigned long, MIN_PARTIAL, s->min_partial);
+	if (slab_tiny_enabled)
+		s->min_partial = 0;
 
 	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
 	if (!s->cpu_sheaves) {

-- 
2.55.0


