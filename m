Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AACEC982C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FFC6B0095; Fri, 16 Jan 2026 09:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B74A6B0096; Fri, 16 Jan 2026 09:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778016B0098; Fri, 16 Jan 2026 09:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 620B86B0095
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 265581AB20
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:59 +0000 (UTC)
X-FDA: 84338089038.19.013CBDD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id C938340004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IjRAZpDJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qqLsDMNQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bHTXKLTC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9axPLR58;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574457; a=rsa-sha256;
	cv=none;
	b=6f3PzdjIPUIETHpJg99GL2QjWUPLlkdF3DJmqOrVHXBGtZJHrLubqqiIQi4yESZBa9VSDm
	HrGatHlZljz0BmcGNohC/STV8E/qUnSRfOTKsnsyn90hUe+Rpte+hp//5nUzENPHbX/BPN
	6t3RSPbvmsRyBTqLA4PDD+bY+ZM0Kh4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IjRAZpDJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qqLsDMNQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bHTXKLTC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9axPLR58;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NQimX2qnHyu3iifkMxRzCZm5f98wg6UoDIBK4sRJ+Q=;
	b=vpr+cn3RZ/f85arkVUch3U9dT7pNwjC9dRTP3ZVPyYPSudyXtEuQinLucHvTb4ug4qIrLw
	cO8mSKXtw1E3N086zva1UZGj3uotNFk+X7Q3+Fv6eyUkIbdLvtA5GSySJQeirx+yLghVIc
	M6CQcXipvxp6j+pzdIvckivgAPmAQsk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E79D3337F7;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8NQimX2qnHyu3iifkMxRzCZm5f98wg6UoDIBK4sRJ+Q=;
	b=IjRAZpDJbvGkZ4PRHVRMajXUaylUKsG2mFfcgvO/CHqSHN2cJ8yClC0ETic9AFyX2fQK6y
	8yF6iEBZZf6rixxCayVusw0ognFkGoKkkB++gVL19t5zGyAzd1grPKGWiQGIfnoxC1YLjH
	7jZdt7MQMtW0oQnIqIXHOFiPgebfa5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8NQimX2qnHyu3iifkMxRzCZm5f98wg6UoDIBK4sRJ+Q=;
	b=qqLsDMNQEMi6oQ6kdtboFIM7Vl7xlGejWKY6vneFK8/3wYjx7lqIVGyZhMRdD5DgKu/bBy
	1SgGxa62xjciYwDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8NQimX2qnHyu3iifkMxRzCZm5f98wg6UoDIBK4sRJ+Q=;
	b=bHTXKLTCNaMmnRR8mday6p5+H8tMJLbOk/PFtk+8rHeqahiIL/IEnHVlMu6Be/QQ7ebuuB
	eENPdKKsDHwm3EjnXW7hqfdSOcx2z3I+M+CK35A2Pkw1HeasgV/h1rVQOOxNzkaiUjtAxD
	9VR2K7fsdnFTQEj3oPWIv6ewrVJzW44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8NQimX2qnHyu3iifkMxRzCZm5f98wg6UoDIBK4sRJ+Q=;
	b=9axPLR58O7D5zJ0fVfsle5q3EiPj0vyaTRz/qy585O/0mapFnq4eXTGymbxfuwAOIspUUs
	rKfoa/KpWMmGzHDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5E313EA67;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ECUEMORNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:36 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:23 +0100
Subject: [PATCH v3 03/21] mm/slab: move and refactor __kmem_cache_alias()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-3-5595cb000772@suse.cz>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C938340004
X-Stat-Signature: 9ainybjwk9dcgjgndg66baa4quf1m1tn
X-Rspam-User: 
X-HE-Tag: 1768574456-716662
X-HE-Meta: U2FsdGVkX1+ctO97zNYNO3Sciu5dfkGtM6ylbzzaROZofDfTH1aVG+k4xO9VjaXhLRCbmyKj+GfK57viXVH5ZW4cTm8kMjYRoKj1+TBMbULmESPesuRhK002VhD5CxEhlvpy+3vikzKRMK/9Ac0cfU+YChDzDJlAeR9UZwJ9TPpGAoIrEfe1UfhngOmLo6TbGbbXA3YeHgPsJc4GNhDtjlrfXkajwT2AoVN2nOpJ1M+VmL3+9JS6c9BzDytwj93KebAFh9axeuLx6EmtTMQZAwGvTWYKl4mRlbD5/ndfeJHL4Vgyy2C2NwQh0a/qOZKeRYsb1zwZSn67bWvg4Ur8BrhTthCK9Zy5/xfHYtT3J/mHluWVxIUhKFq7+UiZ88AvAdPSQ+17qWjqH22FcFGrO7E2YpQbxU3sZbKEu5peMIaHOzOV/m7Ue+nMhZ763Y1u0/ULyXlT9RsAFR2KX9h9oh+12xSFUbW7KS7EU+05GeydwrYvdd64B/2dhHBK+b/WJq6or1yq3lkAiLGlDRrTEWjfNpfCWiDz7wkTT9ye+qFZbZUYEZTv7R40CeplA7uTMwZlvXN2oL4/X5QWAJZ2D9nhwnXSjgXFWGhUvWBdO/sioWCay/ccypvhmzV5Pi2VeBnepqH5IFN80+bn6xdhWK0dHTJJ9WlgzeD3DQgKBpK8NhFPBuOrhM1qki70G+OjEqhDmg/0wOuhqviRoiA8zfFmgLMMEVX5WGaxa9QnnhqGECyVtkqptI3lY552d3JgLR8a9LPGxLfUel57W+gHXAGQ34woGwr9VE59hAegLpy0YOs9pKCv+CXaPRrgGqUIpLKxp3fJ/sflMzg8XJxtWdTltWewf9IoiqX6ZRCoq2aIz2yV646OmvSUjcqcWQr/v7gaRnPKXngqCJwnR2qYOKdx1TBrYr2UB2O7khOIaqb5jcaLV4IwfHQwm61Co5S+Mf7Vvup36glf4KQDV6s
 WRTa+Gss
 Gal2S7AEm/zw8ReX05JtyPf7COtpyFphJid+KpEoqhkC61nN+A/s2aUxbKR8I5wgLEZalhi4bgOLDwnRYRV/1vPktfbvSyN3IdrrZXD6ZsqmGcQInajSk/UJKV3pF0QZEbcBNCSp1dJ/t5i0oK5LhXidJoQ7TAgCFBR6jaFEhx9j7p6uH16sClt42EjSluhIr+Hqg+cZYmbeJcyiJ0rOBh2PiVhCipKTd97ZCewJPZ/KA46ZaW/vjFf3/+SlpbUJp3BVzo3W9jnp/UpH8v0Dzf83JGZJKVLdBPZ9hCMX6G+5x9L0cAer3yGDo+kDL22mYdtSBKuTHg+GPYOKOjE5pYKkwnoZq7T1tp36U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move __kmem_cache_alias() to slab_common.c since it's called by
__kmem_cache_create_args() and calls find_mergeable() that both
are in this file. We can remove two slab.h declarations and make
them static. Instead declare sysfs_slab_alias() from slub.c so
that __kmem_cache_alias() can keep calling it.

Add args parameter to __kmem_cache_alias() and find_mergeable() instead
of align and ctor. With that we can also move the checks for usersize
and sheaf_capacity there from __kmem_cache_create_args() and make the
result more symmetric with slab_unmergeable().

No functional changes intended.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h        |  8 +++-----
 mm/slab_common.c | 44 +++++++++++++++++++++++++++++++++++++-------
 mm/slub.c        | 30 +-----------------------------
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e767aa7e91b0..cb48ce5014ba 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -281,9 +281,12 @@ struct kmem_cache {
 #define SLAB_SUPPORTS_SYSFS 1
 void sysfs_slab_unlink(struct kmem_cache *s);
 void sysfs_slab_release(struct kmem_cache *s);
+int sysfs_slab_alias(struct kmem_cache *, const char *);
 #else
 static inline void sysfs_slab_unlink(struct kmem_cache *s) { }
 static inline void sysfs_slab_release(struct kmem_cache *s) { }
+static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
+							{ return 0; }
 #endif
 
 void *fixup_red_left(struct kmem_cache *s, void *p);
@@ -400,11 +403,6 @@ extern void create_boot_cache(struct kmem_cache *, const char *name,
 			unsigned int useroffset, unsigned int usersize);
 
 int slab_unmergeable(struct kmem_cache *s);
-struct kmem_cache *find_mergeable(unsigned size, unsigned align,
-		slab_flags_t flags, const char *name, void (*ctor)(void *));
-struct kmem_cache *
-__kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
-		   slab_flags_t flags, void (*ctor)(void *));
 
 slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e691ede0e6a8..ee245a880603 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -174,15 +174,22 @@ int slab_unmergeable(struct kmem_cache *s)
 	return 0;
 }
 
-struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
-		slab_flags_t flags, const char *name, void (*ctor)(void *))
+static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
+		const char *name, struct kmem_cache_args *args)
 {
 	struct kmem_cache *s;
+	unsigned int align;
 
 	if (slab_nomerge)
 		return NULL;
 
-	if (ctor)
+	if (args->ctor)
+		return NULL;
+
+	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
+		return NULL;
+
+	if (args->sheaf_capacity)
 		return NULL;
 
 	flags = kmem_cache_flags(flags, name);
@@ -191,7 +198,7 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
 		return NULL;
 
 	size = ALIGN(size, sizeof(void *));
-	align = calculate_alignment(flags, align, size);
+	align = calculate_alignment(flags, args->align, size);
 	size = ALIGN(size, align);
 
 	list_for_each_entry_reverse(s, &slab_caches, list) {
@@ -252,6 +259,31 @@ static struct kmem_cache *create_cache(const char *name,
 	return ERR_PTR(err);
 }
 
+static struct kmem_cache *
+__kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
+		   struct kmem_cache_args *args)
+{
+	struct kmem_cache *s;
+
+	s = find_mergeable(size, flags, name, args);
+	if (s) {
+		if (sysfs_slab_alias(s, name))
+			pr_err("SLUB: Unable to add cache alias %s to sysfs\n",
+			       name);
+
+		s->refcount++;
+
+		/*
+		 * Adjust the object sizes so that we clear
+		 * the complete object on kzalloc.
+		 */
+		s->object_size = max(s->object_size, size);
+		s->inuse = max(s->inuse, ALIGN(size, sizeof(void *)));
+	}
+
+	return s;
+}
+
 /**
  * __kmem_cache_create_args - Create a kmem cache.
  * @name: A string which is used in /proc/slabinfo to identify this cache.
@@ -323,9 +355,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		    object_size - args->usersize < args->useroffset))
 		args->usersize = args->useroffset = 0;
 
-	if (!args->usersize && !args->sheaf_capacity)
-		s = __kmem_cache_alias(name, object_size, args->align, flags,
-				       args->ctor);
+	s = __kmem_cache_alias(name, object_size, flags, args);
 	if (s)
 		goto out_unlock;
 
diff --git a/mm/slub.c b/mm/slub.c
index df71c156d13c..2dda2fc57ced 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -350,11 +350,8 @@ enum track_item { TRACK_ALLOC, TRACK_FREE };
 
 #ifdef SLAB_SUPPORTS_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
-static int sysfs_slab_alias(struct kmem_cache *, const char *);
 #else
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
-static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
-							{ return 0; }
 #endif
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_SLUB_DEBUG)
@@ -8553,31 +8550,6 @@ void __init kmem_cache_init_late(void)
 	WARN_ON(!flushwq);
 }
 
-struct kmem_cache *
-__kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
-		   slab_flags_t flags, void (*ctor)(void *))
-{
-	struct kmem_cache *s;
-
-	s = find_mergeable(size, align, flags, name, ctor);
-	if (s) {
-		if (sysfs_slab_alias(s, name))
-			pr_err("SLUB: Unable to add cache alias %s to sysfs\n",
-			       name);
-
-		s->refcount++;
-
-		/*
-		 * Adjust the object sizes so that we clear
-		 * the complete object on kzalloc.
-		 */
-		s->object_size = max(s->object_size, size);
-		s->inuse = max(s->inuse, ALIGN(size, sizeof(void *)));
-	}
-
-	return s;
-}
-
 int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 			 unsigned int size, struct kmem_cache_args *args,
 			 slab_flags_t flags)
@@ -9810,7 +9782,7 @@ struct saved_alias {
 
 static struct saved_alias *alias_list;
 
-static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
+int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 {
 	struct saved_alias *al;
 

-- 
2.52.0


