Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72BDAC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F016B0098; Wed, 23 Sep 2026 11:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEEF36B0099; Wed, 23 Sep 2026 11:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2AF26B009B; Wed, 23 Sep 2026 11:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 952E36B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25B3B1601E2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:26 +0000 (UTC)
X-FDA: 85245451452.10.314475C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C8A3160008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g3gL/0e+";
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YX7Ca9UzhzFLU5oRq22G+Ie5WRxnHJyj2v5cEtZOB2k=;
	b=y+O+mo+hxt1PKbKJY7JNF5LzAgu4yHc06RuSgPG5fzvCz30vRbeNcbzfSRA4VxwJqJzLMy
	myBJf08T/kSBuZgu8BxyjQHSteoCP0GZkZ6shaFZKaYOytxWmvcam4QsvjKENUXdLNd3mA
	gY6QHRBUjTM5KYrYv0gbDQs523WKSlY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178324;
	b=LmFwa4dbfToVBztaqIxSLcz7vOdnsePrHS6zokXTFKftZ5lvPGnG5CvwFlX84DDHSdFPff
	V+vG7mw0oHcr3/sWhFVXPKdBjECSjmtmHJ/cBAe5p8ZwvZ6Osld9EojsoSWEDFJVp/2S9X
	UuQgFGwjkwM2KObdwJwib3edVMF8D5c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g3gL/0e+";
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1DE84399A;
	Wed, 23 Sep 2026 15:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ECD1F000FF;
	Wed, 23 Sep 2026 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178323;
	bh=YX7Ca9UzhzFLU5oRq22G+Ie5WRxnHJyj2v5cEtZOB2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g3gL/0e+5shDUIHrn2nqmkylPMYc3pgM7ni3CiM2giZYpJMw0yGKkUO0lu2lhJ4CR
	 48BUlyiTw7uCvCEZS9r5COkM6I2WAL7RGyymiTauq4Px2ljwFwLnujrEr6XcpN7E7P
	 ob1OMdYzoy55f7h2Ts6J6ZkXdXdpo0e0XqGuUeEiiTdZYCAkeI8vCY/T7VLtTD7pKO
	 5TrlPxHEXgSAe5DcxuUqrIF9ILW+jeoGHO1ppQFfa+I7B0JMd1IyrqXnjFAjO2obeV
	 VAftTKn8j1vREkPZR/8WvfsptJdO9BpY/Rd2FgFsizx0wRD/643CiREh88X5OGeDv8
	 Oqt7P2DY97ajw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 23 Sep 2026 17:45:07 +0200
Subject: [PATCH RFC 2/8] mm, slab: introduce slab_debug=N
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-slub_tiny_rework-v1-2-a0e66d536eb5@kernel.org>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C8A3160008
X-Stat-Signature: 1hmusbmiqua8tpghtqyt6gunkub84rhn
X-Rspam-User: 
X-HE-Tag: 1790178324-768020
X-HE-Meta: U2FsdGVkX1+u7qpoL8Si7Nc2RXK6RTAuR5NVcdBcnZ9s6SWZLVqnM8UlA8oRgk4X38FOkA0QgPLKrAcPWmWrnkNI1oC495Xzok9NLzwUK9xu3ddnVQbJ5nu3kkrGnhQ+t3DiGL9Bg6/qRq9VuGosnPviNVp6I1cPrpjianzwCvq4G6yYVDWc3rgtK/3Am5t+rlA2u5JB/3gy7kuMhARlypLQf9uBtuE6kWME2/Tz6SzMHvhQo3jKSK2Pc3Olaxdz3+UX/zkncHLefKoWVZyFcV9fRVlhhY7vxmDU3rj87K1IuZBXl3ztLzkUbqsquDm9WXyYmwC+W02HOkrKiECDaROUoB6Pwxki9CtAzZWLwm2h9yJPVDdbv0IJTYwgWpPL7MTPprphUdauz8XoMJ85XvBwRl6kuhMZO5IL3FJwlDl1bdM5yZB2Vvs8bcxvpSnys+izyJm+skPzPadYWq9UwzY49bDyajJpGKdrco5/Bi0Oo66HksGkyQGvRK7pRUvFtI/XHjEZ4xHPWBdvKHS3+8iLCMzOUzrKr5cyJ2y/U5WRmi+eqi89PABwYSaSI4zY4hzdaB7BZMiN3kVbipYA5eJ8YM3yNZZz6WwJIu37ITkWhFQDOFh1kLWinDdUClBLxdRQOCdHiWseqrl3M2Ja6CDM2cc+bbtqIulgjmGONuECNwxkfsCy+eeiH6PNU5CxarBfWb9DsJhibuktfp6Ue9g+K+7lkVX20eM8KHu0RnjEBc0aEYvn3m0iEDHacRf05CK9JZjhFj3EhT0F3yDljFcpmUqqR9ZhxWtxVf5oojG9fCYcAxfaOFhRi8Jmg9cuioiYhSxC/Eu0ym2MYxB8/SsmJEgFL1VFydLqYfYBa+NYkcw97ysZU6IV3kv39yhnz7aUxKfD7kP2ngJ5FG7kxYxoJo6zhakG+YJH2/y8rH5krCOvu0WssqGh+UFSLOlLeUmhhH6kDf3QOB5VmaF
 HNIpzEhg
 ZWEvuFd1pX31VR2l6u18e9TFtpL5oEXM94FZkfa3zQ3fsZvMrBEfZzLmqLDJZPP8b2XtIiVY3hINFY6ISX4nRrm14PHn9lzGsYsHIbJUKUAcqDuHSZNPDjZHo2YFukwIy8rXDW8P3nyTvyqaONdl/tEfTo+DE7Lwvh8ddW58jvdJTji6bwR8U1fCh63/whibDl3gmdHr5enoBzTAW20Yq8FQVIu5ZBJJRnez4o5/bjWcH/f85nr+66TJFBlxSRYCA0YxsuZrkYi4hbedaK4L1AHYWKHlH083evxeA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enabling slab_debug has the side-effect of disabling all percpu caching
of objects (now via sheaves), which can be sometimes useful for saving
memory for e.g. kdump kernels. To make this possible without the
overhead (CPU or memory) of actual debugging options such as poisoning,
introduce a No-op debug option that only forces the debugging slow paths
and zero sheaf capacity.

This will also allow reimplementing CONFIG_SLUB_TINY as a boot-time
option.

While documenting the new N option, remove obsolete SLAB references from
the F option description.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/admin-guide/mm/slab.rst | 13 +++++++++++--
 include/linux/slab.h                  |  5 ++++-
 mm/slab.h                             |  2 +-
 mm/slub.c                             |  3 +++
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/slab.rst b/Documentation/admin-guide/mm/slab.rst
index 14429ab90611..0beeae71d472 100644
--- a/Documentation/admin-guide/mm/slab.rst
+++ b/Documentation/admin-guide/mm/slab.rst
@@ -45,12 +45,12 @@ of the first "select slabs" blocks that matches the slab's name are applied.
 
 Possible debug options are::
 
-	F		Sanity checks on (enables SLAB_DEBUG_CONSISTENCY_CHECKS
-			Sorry SLAB legacy issues)
+	F		Sanity (slab consistency) checks on alloc and free
 	Z		Red zoning
 	P		Poisoning (object and padding)
 	U		User tracking (free and alloc)
 	T		Trace (please only use on single slabs)
+	N		No-op (force debugging slowpaths without any checks)
 	A		Enable failslab filter mark for the cache
 	O		Switch debugging off for caches that would have
 			caused higher minimum slab orders
@@ -85,6 +85,15 @@ in low memory situations or if there's high fragmentation of memory.  To
 
 	slab_debug=O
 
+The No-op option can be useful to minimize slab memory overhead by forcing slab
+debugging slowpaths, which disables percpu object caching. This reduces SMP
+scalability significantly, but does not impose the extra cpu or memory overhead
+of debugging options that actually perform checks. This can be useful for e.g.
+kdump kernels where scalability is not a concern, but memory has to be
+pre-reserved from the production kernel. So for a kdump kernel you can use::
+
+	slab_debug=N
+
 You can apply different options to different list of slab names, using blocks
 of options. This will enable red zoning for dentry and user tracking for
 kmalloc. All other slabs will not get any debugging enabled::
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67a..ed949e8522be 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -35,6 +35,7 @@ enum _slab_flag_bits {
 	_SLAB_PANIC,
 	_SLAB_TYPESAFE_BY_RCU,
 	_SLAB_TRACE,
+	_SLAB_DEBUG_NOOP,
 #ifdef CONFIG_DEBUG_OBJECTS
 	_SLAB_DEBUG_OBJECTS,
 #endif
@@ -166,8 +167,10 @@ enum _slab_flag_bits {
  * Note that SLAB_TYPESAFE_BY_RCU was originally named SLAB_DESTROY_BY_RCU.
  */
 #define SLAB_TYPESAFE_BY_RCU	__SLAB_FLAG_BIT(_SLAB_TYPESAFE_BY_RCU)
-/* Trace allocations and frees */
+/* DEBUG: Trace allocations and frees */
 #define SLAB_TRACE		__SLAB_FLAG_BIT(_SLAB_TRACE)
+/* DEBUG: Force the debug slowpaths without actually doing anything */
+#define SLAB_DEBUG_NOOP		__SLAB_FLAG_BIT(_SLAB_DEBUG_NOOP)
 
 /* Flag to prevent checks on free */
 #ifdef CONFIG_DEBUG_OBJECTS
diff --git a/mm/slab.h b/mm/slab.h
index 8fd6835e4235..77fcbf99b7b4 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -490,7 +490,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
+			  SLAB_TRACE | SLAB_DEBUG_NOOP | SLAB_CONSISTENCY_CHECKS)
 
 #define SLAB_FLAGS_PERMITTED (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS)
 
diff --git a/mm/slub.c b/mm/slub.c
index a107a111c75e..bc593f0078c0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1897,6 +1897,9 @@ parse_slub_debug_flags(const char *str, slab_flags_t *flags, const char **slabs,
 		case 't':
 			*flags |= SLAB_TRACE;
 			break;
+		case 'n':
+			*flags |= SLAB_DEBUG_NOOP;
+			break;
 		case 'a':
 			*flags |= SLAB_FAILSLAB;
 			break;

-- 
2.55.0


