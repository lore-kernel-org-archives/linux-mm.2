Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C408FD625E5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3565C6B03F5; Fri, 23 Jan 2026 01:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBF96B03F8; Fri, 23 Jan 2026 01:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF276B03F9; Fri, 23 Jan 2026 01:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 069C86B03F5
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5E5C1A032A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:20 +0000 (UTC)
X-FDA: 84362312160.05.66B4A6D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89B74100005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LnxYZGzr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f5V8qRMe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oW6Bsr69;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZlJuK/Q8";
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkJZc9VVDwbCOE5N88ecWISWdsb2/cOXldbaYOteozg=;
	b=ZCW8uAcC92ouFD5VkROXLwVFEImJ0X+xVePEpNi6rY6XvsFCziJVUa0wqEkdWrqnZi6C6T
	KQNx69i4NSfHYbXAbCKHTRQnzQkUX9jo7qBvbp4Gp2zEyJi9VMdEF54LKpizQbIC6IqQ3d
	XdNOClAjyp8kpb93C1WRQzznG2Odxro=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LnxYZGzr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f5V8qRMe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oW6Bsr69;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZlJuK/Q8";
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151198; a=rsa-sha256;
	cv=none;
	b=eePNLsSnd2q4kTge90uH723mIhsj4K+ThI2/1EogOLeWOajkZ3xmh75lRwH/aI6+L8Niaj
	XqwE3Sq7ZtPTUc7VL50OIivR5tArB/w2cl48bgzwd2ENuYeVognxPlqY8QIlq6WnZ29EO1
	om601u/slyN3xX2BHxbai/kU8FNLjs4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A2C565BCCE;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UkJZc9VVDwbCOE5N88ecWISWdsb2/cOXldbaYOteozg=;
	b=LnxYZGzrptkCsiSyPVbbUsSb0aPBRpWYY63pa5i9GzQr/0kWbbsqgglfJXQoBjEP08GU7O
	SwcIK/aPkcDvv/8GcTwWycnQe+y2/thJtIu/7NVOiECeLCSnb6r6qanZyDmdMNh6ekhQZ0
	PoMyeM0Rb2mJEIBzgr7EEwF7EIMl5Pg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UkJZc9VVDwbCOE5N88ecWISWdsb2/cOXldbaYOteozg=;
	b=f5V8qRMepjktCByLkxQJHJPmVw56oDDSlLdjzL0DNrLOJKv3kSwq+YyMH5koTXc+B/DlDZ
	DM+KOze4M8yN95Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UkJZc9VVDwbCOE5N88ecWISWdsb2/cOXldbaYOteozg=;
	b=oW6Bsr697b230juFpxKrMJ5DXruKdLELNWZ5BQj8E4nBwoGGtacKIokf0ME1leGKco0m8H
	fjV/D2WG9RgfKMbh+MNlW/dPL2ZeqWcFqzQG3bWEURZeyUk0jiMxp3MWufEkie64FIK/iG
	AHENluaMEj5z6QrK37LCFsGyznAm/w8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UkJZc9VVDwbCOE5N88ecWISWdsb2/cOXldbaYOteozg=;
	b=ZlJuK/Q8UZyUbtl5OrmdzJw3m82QpZQClCaZVIa/VpaK7HLKcQnJTJfAfthDtKUKLyWG5c
	jKDg8N7njGahNQDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CF5D139EB;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aBk4HtUac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:42 +0100
Subject: [PATCH v4 04/22] mm/slab: move and refactor __kmem_cache_alias()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-4-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
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
X-Rspamd-Server: rspam11
X-Stat-Signature: xh4afyuo5uorenb7dnrqt1e7w3xdkrxx
X-Rspam-User: 
X-Rspamd-Queue-Id: 89B74100005
X-HE-Tag: 1769151198-102647
X-HE-Meta: U2FsdGVkX184P0GkxuTqUs61rCsLYEkWk0tnubJcMcEDwY0mFaRwUxCl1E4tyjW3UgGcAD8T/LbGbCnhWIPLGZANd0tDyujYOW2EbUnEzlUyl61TBC5oT/ghqpE7YqzA0yv2zewZvWnYrae+xbiExpBLaEzj5eXEJhGK25GxHXfZ7hk3Tse4dbUP9pWQ988EmcViqaxcODUTJ/MBxcJ5tVPH3SH1bC8ySQSNrfJ2oXZhzLFq/rfKbSQ5JbC8v8trAObNRF5rxjuGaocgCF6hUe6dr+6Rfx51l2HDAEDrmtryk3YIg1LaM2L9AjfnvtVnUAz0Yzueo8LRu2100IUGAyGn4R+JWRYLndzi7WfjIfDDOyVAxo++Aa+1fOgvbDPqyuoSm1G8HxnEgzebfIJmi/wcw9EDSmANY3h5Gp2OkRf691WJRnADamKSBjH2BhFECl7bHUrFiQAujtkRAODgncTkaEAEIwjVKyIQ3a1UtPt6ma+5vcND3ypi6InK/R6On6Oq4rmvWqOv1KCjQBYJ1X7vHByUcItkBow1qZXwec6RC62mYLFjlQVPRZTJNAPW3ffds5bdD9Ii+8z6vXfMOp+7Zd20GJ3s+3J5LrJeTIIN4Bap7hWnHFklhvghzQk4akiUiyQRfNnL6sYCrwzVh7z5546SEsxsbHq1izeY87nVdrbJYsRcVsG2qoe6bQj9T0YfMdp1Gw7+exfobaLGOwDO8FxEXV36An1X234IbQ5/aPHX/p/UUNEd7LRUQ26HblF9+hpNFw75Kp/EGrJYsknlDY5DCa2e79S2EolxgDVu7nmTexqFLJksafJnRHb4oGFyC7R29JfB0tRxLSj3peWdj3py6K2T/ABumc9o9JmqhqMSk6BUNCR/ViPFBr+ExkZ6Ie4JZdd7gWvw9DL3E8pOirB+DMCiDOPcKeA3bc97K3+O85WBWeCizndF5j0YfTm/h7aWj8MRM+4Poo9
 mjqaF0qL
 wouWx56jt7wKc628R9Nhij1YFPFfNBEnp5oSS9w+CuKslHle2HDElYw3B179hyYspMi82X7K5PmkJkNsKQ+JSO0fv4l05KLRtK1ArKWKew9hjqUpgLMTf6wGgzMZqKcnr8UfwZWjGH/ScG74HvPfHFbxny6jVdq7qW5bOnNDa06LxEdG+tY1DG1ZCp9LKN2NcV3jHDrL5LCqGJomHFBmsduVCYya+DxR9SLNtsjRbOFXbaiDKK4W0/W5MA/VNyBvdGQAXDuxp2J3ifjVQGyQo4RjF02rc4Qsx6ChVP5u4kmM5UfyRI/r1BRXLWXSV4lM+1p1GMU02LfrTAXfdCvCaUwKRyuM1i31k2Ya1
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
index 4eb60e99abd7..9d86c0505dcd 100644
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
@@ -8570,31 +8567,6 @@ void __init kmem_cache_init_late(void)
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
@@ -9827,7 +9799,7 @@ struct saved_alias {
 
 static struct saved_alias *alias_list;
 
-static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
+int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 {
 	struct saved_alias *al;
 

-- 
2.52.0


