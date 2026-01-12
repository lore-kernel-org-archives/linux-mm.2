Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF389C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501C36B008A; Mon, 12 Jan 2026 10:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC936B00A1; Mon, 12 Jan 2026 10:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371466B00A2; Mon, 12 Jan 2026 10:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 230DC6B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4BD4C1E6C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:07 +0000 (UTC)
X-FDA: 84323664894.12.3936FE4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7BE37C0010
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ta4URRSV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xJ2UPpG5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ta4URRSV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xJ2UPpG5;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231025; a=rsa-sha256;
	cv=none;
	b=ukKNg0cADV082/Ytfb6P40nenGA6V7hr28rMyVLssvGOrpqScaYaDThHCWRLcMqcT1+2wD
	StL9F8wLA6dy8V81YHzz3HPbYfPclNLFniWgUHsluCtIUa8+Lv/FRmqfrfDauSgo1iqae6
	Jj8PLAQllkMVGj36t4UklYFYjA8DUbY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ta4URRSV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xJ2UPpG5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ta4URRSV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xJ2UPpG5;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQCs1RtsaTm73XRhw06koc6SL41acjRnO47ur3XmS+A=;
	b=v4FH530QcPrxwGCWxlXnmCx8J4Wg5tVkGohsJxrA78aVJXCkFCj16Ww3bfPnLmy2l5N31Q
	6QsrV1nZcAU0eZnTw3/yzcge3TiURrz455t2Vj3qopAIbYHMjE91JDr/XYCFeNxn4qYEwR
	vEH8iNpfwW9SIrn+9DKzfKFpXsUcBDA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 74E4E5BCC5;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQCs1RtsaTm73XRhw06koc6SL41acjRnO47ur3XmS+A=;
	b=Ta4URRSV+DyEoiUek1wdXbxW1hZ7ogIi5P9zh+RZM0KXJVNu+UpwEswnQccGpclW4HBE3A
	ZO8f4KSpOdwfldhhpvHoDf8ukcaCgDNWT3HxbXrOrco9W6AYoBUbgjsrQxD/jq2eMzoHqy
	LY25XgWzAD5Gd3qRmQKOi2EwWCScXgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQCs1RtsaTm73XRhw06koc6SL41acjRnO47ur3XmS+A=;
	b=xJ2UPpG5BmUrvRNmyhdB4KLAuB+7ULnwx8Xmwm5jPtcaotyQqtfNoQ8XU5025mcvXnCxzU
	aVkp9KIweHtUbQBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQCs1RtsaTm73XRhw06koc6SL41acjRnO47ur3XmS+A=;
	b=Ta4URRSV+DyEoiUek1wdXbxW1hZ7ogIi5P9zh+RZM0KXJVNu+UpwEswnQccGpclW4HBE3A
	ZO8f4KSpOdwfldhhpvHoDf8ukcaCgDNWT3HxbXrOrco9W6AYoBUbgjsrQxD/jq2eMzoHqy
	LY25XgWzAD5Gd3qRmQKOi2EwWCScXgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQCs1RtsaTm73XRhw06koc6SL41acjRnO47ur3XmS+A=;
	b=xJ2UPpG5BmUrvRNmyhdB4KLAuB+7ULnwx8Xmwm5jPtcaotyQqtfNoQ8XU5025mcvXnCxzU
	aVkp9KIweHtUbQBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5060C3EA66;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KPBRE2kQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:57 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:16:56 +0100
Subject: [PATCH RFC v2 02/20] mm/slab: move and refactor
 __kmem_cache_alias()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-2-98225cfb50cf@suse.cz>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
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
X-Stat-Signature: ad6npwcdbmd18tjzzus6bo4h9gthpxz8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7BE37C0010
X-Rspam-User: 
X-HE-Tag: 1768231025-137035
X-HE-Meta: U2FsdGVkX1+8MnlVROl1t9no2EJeViujUi8Z8d91kBjFI88hCbTIZK0rNKtdzMZfJjIn+LjOa3KA3IkYU4uvsCo9K+7UCsHlq+jGsS3omSR1OLtnBrM3dJ2NcncuvJSuX5ZTGlabJ77cHobs8nmlhBkvb01GcjnTx5mmPRycBWxVlUVvOoCw9adUYI9aPZEtLBkrM8cBl+6e9CicOCClm9WpAR7OCt2ffMiS4K74qus5KXej+fT8eqXHFUXH0ZrP2rsoFb+DNTkjiSMaClrqwGFNPBBOK5tOxwIPkwS7Bc+jvZDiETwmxG0WUO6sRCVwbQwrMmgIdDl52BZ4CtDe8nOjktfRbkjIyNes885VTujW5I6SEXBNv96oHi+M/eVpujSrKHhR14zkRfj1ys32PwjDDz6omONOwvAUnnAL23pNZSC5ULlA23/WOStEC4ZG6PGkx8dHWibsNwmKH2sXmenYApdPHfLq0WXtS0DGur93691uuJQbLGWuhhYyl4cYXC5E4xXgiiPnBQIszgf0HZf2weVV+OKkpL00hRG4adXhgFwVgj7W/lywLRSCNWUZ1KWFe/G5Lrob7uvcWgXaaP5y2+QfvfoH5XrIeDU5yL7X9QrVWGVE4h1gonmk8KYV5PPo5PXSrmCs0ggz4i/t0TPgEi8w7O3LpfJI3aA9hMQhuF3NgtE7gRxNraS9pbjCIzvyr6kspVR8PiMEBJbsi9h+lUWhAd49aj46sqalcjVHmX1SbXAvE7NOdvms6sQgOjrHb4UbR7e9uovENzWEkgLcpmrKdIrPtTUPc2J/O1I1IJvUf9oPJL/yFWzfHOispoBYHM7t0A29FVRffmItty0rKGbI45GkNbwxlOYvL/bpEp+HopzPAhVuBNY7chPZx9hvHexOkviRATBl7a6DuFnM/Wxgz7jD5v9PHC/vgAhmWl4BdsvWpea9c6b/lz/UKst2cziruHH0D1iRPdB
 bZI2bUwT
 beu4/cYzcRwaCPmVL+1R+hGCMus++JlUxWFRDdhOvQ9mRnI94zldDeKripQmEoTbkSYH03L3JG8bBdl1YiXxDM4hfivsLwn14ZRmOLSNuPOMkV5f8I4hvWGdIata1P4OH/6NyZULla9M/XKeOmFU3GQOLpdtjwtXvb2vfMVw5CqCP1UEunemhGmGFouRk06Zr4/0+zu9Kd4vDi9UwKPs9xeYv2rbHOQOhbGB7pqhRuPcZanEpgzxbfQrMpSCKdffN4vyYvs3g6ipBnlGzHLWAgplsFvTxmOP574D0ysEX3PgYuvE=
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
that __kmem_cache_alias() can keep caling it.

Add args parameter to __kmem_cache_alias() and find_mergeable() instead
of align and ctor. With that we can also move the checks for usersize
and sheaf_capacity there from __kmem_cache_create_args() and make the
result more symmetric with slab_unmergeable().

No functional changes intended.

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
index ee994ec7f251..52591d9c04f3 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -175,15 +175,22 @@ int slab_unmergeable(struct kmem_cache *s)
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
@@ -192,7 +199,7 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
 		return NULL;
 
 	size = ALIGN(size, sizeof(void *));
-	align = calculate_alignment(flags, align, size);
+	align = calculate_alignment(flags, args->align, size);
 	size = ALIGN(size, align);
 
 	list_for_each_entry_reverse(s, &slab_caches, list) {
@@ -253,6 +260,31 @@ static struct kmem_cache *create_cache(const char *name,
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
@@ -324,9 +356,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		    object_size - args->usersize < args->useroffset))
 		args->usersize = args->useroffset = 0;
 
-	if (!args->usersize && !args->sheaf_capacity)
-		s = __kmem_cache_alias(name, object_size, args->align, flags,
-				       args->ctor);
+	s = __kmem_cache_alias(name, object_size, flags, args);
 	if (s)
 		goto out_unlock;
 
diff --git a/mm/slub.c b/mm/slub.c
index 3076a1694008..8ffeb3ab3228 100644
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
@@ -8547,31 +8544,6 @@ void __init kmem_cache_init_late(void)
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
@@ -9804,7 +9776,7 @@ struct saved_alias {
 
 static struct saved_alias *alias_list;
 
-static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
+int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 {
 	struct saved_alias *al;
 

-- 
2.52.0


