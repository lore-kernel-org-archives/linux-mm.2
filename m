Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F572CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445EA6B009D; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357F96B009B; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0733D6B0098; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3FAF6B0099
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F4B91A05DD
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:39 +0000 (UTC)
X-FDA: 85291656198.20.12447B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5807740002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMdhQHzq;
	spf=pass (imf04.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQARg85OdF5eGN4sTix/VU3mJvlcuBipIV6C7S90Sf0=;
	b=bLlK3Uef8pxLizJE6JJBimug/KsZF6RDnm5DNZdJcn0jgPVmNezt1AsJhkP1x02DugTSn/
	tEDsKSN/GfSqVPjTuS4d8QBLONmCWa6BDuYV9XLwWwXuT6+b6dejzWI6DnN7SlBUeUnAyv
	SIMK6Amv9xJGo4oDxkSNQTViW0gKNPU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMdhQHzq;
	spf=pass (imf04.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278437;
	b=PfoBQ+53hWm9ZrpKIro0IwFDJBHKLy2SfnAnvOXit9CW/2r2TpICjpQ8vNa+HiWHOkuUrg
	y2yqnoWxM/I9/MDy0b0FU+d26FE/ZSoxHZj6P2gjJfQXyV0y1hcWeaO69Bg436U6iqOudH
	TTppUxxR9dctSDLwSAv+jrQuWmLMzho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F9F743F68;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F44F1F00899;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=bQARg85OdF5eGN4sTix/VU3mJvlcuBipIV6C7S90Sf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMdhQHzqdI4P9vGs4735+trKLMRhRI0V8H/o4q2jl8pdDlT8ie3YnFFrbvS+qLxX4
	 7vswKvj3s8lcAAJQIwedRBsfOuh6GN1nsv9a20stUq1gzoHVsTdbHTve3yxHOwPsIT
	 Tcz4TbaVpHfcHz00go1EFZ2tI4aFzv1JnlxbraZHbaLbWcoI8Ke7IsK7quVG05safR
	 yUZyX2tVW/3vIBS0wv499KIMmXqdIzTP6hwRE3q9/hAW2OQJqM8stMh6IoW/YKst7y
	 W9ixi3JR+sNrq2ff1ZKSO8tLGGEo6alocFRCg0nN7y54RCIOKi/Aauoh56zsFgPBsm
	 MApiu+vzmRMIA==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 3/8] mm/slab: Drop the ctor and flags arguments from kmem_buckets_create()
Date: Tue,  6 Oct 2026 02:20:29 -0700
Message-ID: <20261006092035.166776-3-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4654; i=kees@kernel.org; h=from:subject; bh=Qc4gibobM/KiTch6bZpTHBpEl8CwkLveGZU5LrXrSHk=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9iYsELHlDNGfpXea+WDn85cTcg/fn6H0RD/utP0s4 cm/hF/97ShlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZhIYQ3D//yKmZceL9px6567 3zZVx2uRdr9Vlsb2qvZ+Uoh6c0w4s5qR4fSunydahBQTmgIyfXt12pVa+4NS9DvapY66r7SU+aL OAAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5807740002
X-Rspam-User: 
X-Stat-Signature: 3ikffer4s7geth6xxsyfo9wwqmdesufo
X-HE-Tag: 1791278437-108285
X-HE-Meta: U2FsdGVkX1/R56Pey1UgCLlDUNV2kvwxOejSi+Wt/KObjoophhtUIqiDmiERYdlSmrTCyVR6LTbCx3lkrhG4y9mBK8f2qTMV2CtFeNt2KiIxXVbiSPhBvLmbxWi+Mj5VbjOdMtKNIdXnfZ2TqlsjzWM8p940pmhfVnhCVV8FiAlXsshly6AcfN5ouLAzX9Scih06AxzS+ykcmx9Xj1Pq5lUEbkVNpqIgGipJUBxZxnrKS8RrNdESoXeFdzaUMPxs4vQQlIbu+bNsRzqsCugCTGjlWgzHaiv3z7E+tKojaHUBWpl/khUKbDJ/C163XNH1EU/HjHw1bXZS+Xh87RgVtemg9l4oE3c+uta8SPDbdfxv/4Sz8BZPoIN/Y1OdPwUOVZ9qCu9yeFmrKvM4AWrxibgOsI6Te3RnmYMRj8sjv5u+m3ScRPxAWhWyD0Ngo2lZSdF6tVpf344Pfbnj03COhiWPfqNCqoNFtz0QuszoUiTerGxnxTOkJ7ZgZJjY7Gf4g3WXpZ/FQNfe+Liu1x5He+zm2QbFiVxYQ0E0nUUVtVnDIszIsbeFzrQvp3yRQPRDmXJa3S5KIos3IRhqUGcfXOLTMFw96kSS/EVOn3XRmcN54JXIiXAHIlUJr8rcWl6e7XT2Dk3+iD2bLziSm7QZQCO3q4fhuij7A/thOaTFo+AOZqL4Ui+S+O0WTaEHU/VY94bmEDUF9jXmvcucq/VJO2FVJZKG3qJNSKzm8rM9scLcycrPoAPzhCS0l2t5qxJKkuV7iExfEL5ciisjrAKbmkL4BoNSgQtEvTPsUT3QOzvE8Uxqdira3gIh60EdSKNKC6heW27uYHJt+jZ33fP/KXxnx+i5/9PH8CKaRd4sxcTmMBw3wenMc4G7NJVqSM959dz/CUTCTIhARqDWnFPEpA6q1cKSPEa5sKwnBZN9i2dbEhDRbOxgNAYo0kfmqGAET5ya0Hu2A/mFfDbJqo+
 6cS/m8FD
 lR+fcE9oPWwZT27a+2/7um2DofTqngReo+kT93ATGVrNchbgJVrFzTzASusRJZa63KwBeq02i5EnCjIYHi1b1RcuuNm+jxKPvx/9D0O/gitmWnMRr05C30Nj552p6VdG/8qa0xtLfxsLySko9/mAq4U0yLgEz9TO9LP/2F4AVniwN/Vk2IzhZbRTIrPtqob7ABFa3mHcErnTMHG0chnbZ6tjLlr1tD4Jf1v9M/RfV2Z8MAIfwAJ3X9HpvdJbExe0Nv4Hag2lswwOSwWilQgqggrVdi7IuTCnhgZ3m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A bucket set passes its constructor and slab flags to its own caches,
but its allocations do not always come from them. With
CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() returns ZERO_SIZE_PTR, and
when creating the set fails it returns NULL. Either way
kmem_buckets_alloc() is served by the general kmalloc caches, which have
neither, so a caller cannot depend on them. msg_msg depended on
SLAB_ACCOUNT, which it no longer passes since accounting through
GFP_KERNEL_ACCOUNT instead.

No caller passes a constructor or flags; drop both arguments. The set's
caches keep SLAB_NO_MERGE, which kmem_buckets_create() always added.

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/slab.h |  5 ++---
 ipc/msgutil.c        |  5 ++---
 mm/slab_common.c     | 14 ++++----------
 mm/util.c            |  2 +-
 4 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67a..31f97e2579a7 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -890,9 +890,8 @@ void *kmem_cache_alloc_lru_noprof(struct kmem_cache *s, struct list_lru *lru,
 bool kmem_cache_charge(void *objp, gfp_t gfpflags);
 void kmem_cache_free(struct kmem_cache *s, void *objp);
 
-kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
-				  unsigned int useroffset, unsigned int usersize,
-				  void (*ctor)(void *));
+kmem_buckets *kmem_buckets_create(const char *name, unsigned int useroffset,
+				  unsigned int usersize);
 
 /*
  * Bulk allocation and freeing operations. These are accelerated in an
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 1ba8e59cb255..10ce3087b089 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -43,9 +43,8 @@ static kmem_buckets *msg_buckets __ro_after_init;
 
 static int __init init_msg_buckets(void)
 {
-	msg_buckets = kmem_buckets_create("msg_msg", 0,
-					  sizeof(struct msg_msg),
-					  DATALEN_MSG, NULL);
+	msg_buckets = kmem_buckets_create("msg_msg", sizeof(struct msg_msg),
+					  DATALEN_MSG);
 
 	return 0;
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 270408ce5a9d..f8bb70d76eb4 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -415,12 +415,10 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *			 allocations via kmem_buckets_alloc()
  * @name: A prefix string which is used in /proc/slabinfo to identify this
  *	  cache. The individual caches with have their sizes as the suffix.
- * @flags: SLAB flags (see kmem_cache_create() for details).
  * @useroffset: Starting offset within an allocation that may be copied
  *		to/from userspace.
  * @usersize: How many bytes, starting at @useroffset, may be copied
  *		to/from userspace.
- * @ctor: A constructor for the objects, run when new allocations are made.
  *
  * Context: Cannot be called within an interrupt, but can be interrupted.
  *
@@ -429,10 +427,8 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
  * (i.e. callers only need to check for NULL on failure.)
  */
-kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
-				  unsigned int useroffset,
-				  unsigned int usersize,
-				  void (*ctor)(void *))
+kmem_buckets *kmem_buckets_create(const char *name, unsigned int useroffset,
+				  unsigned int usersize)
 {
 	unsigned long mask = 0;
 	unsigned int idx;
@@ -455,8 +451,6 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 	if (WARN_ON(!b))
 		return NULL;
 
-	flags |= SLAB_NO_MERGE;
-
 	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
 		char *short_size, *cache_name;
 		unsigned int cache_useroffset, cache_usersize;
@@ -487,8 +481,8 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 			if (WARN_ON(!cache_name))
 				goto fail;
 			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
-					0, flags, cache_useroffset,
-					cache_usersize, ctor);
+					0, SLAB_NO_MERGE, cache_useroffset,
+					cache_usersize, NULL);
 			kfree(cache_name);
 			if (WARN_ON(!(*b)[aligned_idx]))
 				goto fail;
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..0cd125f1ea99 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -199,7 +199,7 @@ static kmem_buckets *user_buckets __ro_after_init;
 
 static int __init init_user_buckets(void)
 {
-	user_buckets = kmem_buckets_create("memdup_user", 0, 0, INT_MAX, NULL);
+	user_buckets = kmem_buckets_create("memdup_user", 0, INT_MAX);
 
 	return 0;
 }
-- 
2.55.0


