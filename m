Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B10C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A3B6B0377; Wed, 27 Aug 2025 04:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39D96B0379; Wed, 27 Aug 2025 04:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01816B037A; Wed, 27 Aug 2025 04:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 841586B0377
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:27:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 477E01604E7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:27:10 +0000 (UTC)
X-FDA: 83821857420.13.B637326
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1B34EC000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:27:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7a61Ijdlx8vCC7HxGUCW9CHIwxCFiO6NahG2FrftWxE=;
	b=R9La/pFe9FAWW9WLEKPjNguf+RHUPNISpf1sYxoNEB9azQMZlSyX8ZW06koUMMqdHu3XMI
	vHXMF6cCFpHJ3JHG2/TJelqcYgsdUbOppeCaa2ziBz6KSh6JXjkt2AZO0HHzuclqEjGrQb
	BgSccvNxoQTTiq/df1we9rvgrHYJhog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283228; a=rsa-sha256;
	cv=none;
	b=itD91c2V43b4kj+83rosmcOdkw1kBZM7D0GibYXpIg+WnjHlL7rIPW1Hvm76rwT3gj2nzB
	2gzWynB03uvX4mBjlYM5NjUYhKvXCFbTaCirZUY+vF7AgURBQnPbDGP2hkU7goiAlD+xIh
	bsNaXBxWjmJZmat/4t64MHhSZal8NPY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C45CC1FF24;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A552F13310;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KPkQKDvBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 27 Aug 2025 10:26:41 +0200
Subject: [PATCH v6 09/10] tools/testing: Add testing support for slab
 caches with sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-slub-percpu-caches-v6-9-f0f775a3f73f@suse.cz>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
In-Reply-To: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B34EC000B
X-Stat-Signature: 6tmbf4wcwugimyz5y5zr81i5h7xkyti7
X-Rspam-User: 
X-HE-Tag: 1756283227-454589
X-HE-Meta: U2FsdGVkX1/BenXTCEPXLnjKUC+oBf3Urp0apjqbECClzrFyI2mrAdL8Nab8V6SoGVZ3hl94aV/75ZD5yBLMkKA9olLJr4U5QFOzjgYYPsS06euSfKH9zUneUPwZe/sVnE86/wBmpUIlwLmhhfOR3KWRqVa1XWs2yZdvX9e1LkSoSRNBKgdPG3uMlO5N4HBXoyLkuSmYLK1A45+Rw2w8bbarCncO7pEDsF96eeOffof22uV1/VzsYppZb2b3Xy6IVEMQL1e8F/ZClXe/lHN7XK0OZwFrChQrPnMY1kxJWOQ/ehQ64RoT5cgk3yXD+zNaJu5wXa8ggA7d9lQrJzjgIGeely3lUKj+9r8xaP4/L8dXD3h84cfMRCnRJa9b8ALaMP95K03Noa2GI6FLGPD2NLGuvPORaGfsmmbuZGlzzaK3f9OQ99S44EJaKapYH0bj4uYjxObqvw1+1MBolsMhKV7QdWrGlsbZ9MczTF0rlmenmiwmo95juHyxaz2TXgAUOOCgTetUDGX37WavyB1uMsy7NtPbjX1g6Ow5ve0E4mrDzKgI1EzaPtj5r0lhAFcuc+ic7Kgz49UPXk7N/FFoltPzf4zEYjKSa/pv2ObdW3d5HUc4HjxLsOhygXj7h9hC3c+rA08ZNZohM1FMjhjYJW9CXSPKqpYst7tJHu9G9FSnJ9xohZUWpaAHQmPwdetxR0Jj9TCCbh/YEt9ut/GiYuIuzjsjvRV89oU37ErZ8GOyZ0RL+Ag7IuCWpsPr4IJCYGWsiJehKjsPpJNdhSncmGcdj/q3o8PqI4Czl28NHDBvrlgsVQZE3zPc8nkQee8VvqXEEdjhPR+jb6CgtHCT8Dvr1o31w1mgchI8bWBczAupDZdHIsDVt4sPx9EhQiGIwS+ciiWo/G9CtPOILgKC7ELpBSPiu6y/2f0oKlkRNtcgBv3jNxJnGPv5KDdO4WlktMScmgGToTdrX68IkMv
 lZmS8MPl
 M6cXpjJdPHJIrsxpVgxsduvxppHv6QF6FRYn+axJoHDdXf4LI14HeyvcGv47SevsiCNd/11HzL8Zb9Sb+LiNzwTBrGpYJmZf0erD4eyhScsvLcUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Make testing work for the slab changes that have come in with the
sheaves work. That means support kmem_cache_args with sheaf_capacity.

[vbabka@suse.cz: remove kfree_rcu() support, to be added later]
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/include/linux/slab.h   | 41 ++++++++++++++++++++++++++++++++++++++---
 tools/testing/shared/linux.c | 12 ++++++++----
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index c87051e2b26f5a7fee0362697fae067076b8e84d..d1444e79f2685edb828adbce8b3fbb500c0f8844 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -23,6 +23,12 @@ enum slab_state {
 	FULL
 };
 
+struct kmem_cache_args {
+	unsigned int align;
+	unsigned int sheaf_capacity;
+	void (*ctor)(void *);
+};
+
 static inline void *kzalloc(size_t size, gfp_t gfp)
 {
 	return kmalloc(size, gfp | __GFP_ZERO);
@@ -37,9 +43,38 @@ static inline void *kmem_cache_alloc(struct kmem_cache *cachep, int flags)
 }
 void kmem_cache_free(struct kmem_cache *cachep, void *objp);
 
-struct kmem_cache *kmem_cache_create(const char *name, unsigned int size,
-			unsigned int align, unsigned int flags,
-			void (*ctor)(void *));
+
+struct kmem_cache *
+__kmem_cache_create_args(const char *name, unsigned int size,
+		struct kmem_cache_args *args, unsigned int flags);
+
+/* If NULL is passed for @args, use this variant with default arguments. */
+static inline struct kmem_cache *
+__kmem_cache_default_args(const char *name, unsigned int size,
+		struct kmem_cache_args *args, unsigned int flags)
+{
+	struct kmem_cache_args kmem_default_args = {};
+
+	return __kmem_cache_create_args(name, size, &kmem_default_args, flags);
+}
+
+static inline struct kmem_cache *
+__kmem_cache_create(const char *name, unsigned int size, unsigned int align,
+		unsigned int flags, void (*ctor)(void *))
+{
+	struct kmem_cache_args kmem_args = {
+		.align	= align,
+		.ctor	= ctor,
+	};
+
+	return __kmem_cache_create_args(name, size, &kmem_args, flags);
+}
+
+#define kmem_cache_create(__name, __object_size, __args, ...)           \
+	_Generic((__args),                                              \
+		struct kmem_cache_args *: __kmem_cache_create_args,	\
+		void *: __kmem_cache_default_args,			\
+		default: __kmem_cache_create)(__name, __object_size, __args, __VA_ARGS__)
 
 void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list);
 int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index 0f97fb0d19e19c327aa4843a35b45cc086f4f366..04730abe4dffbd6849b848373ec110b87c81bf33 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -20,6 +20,7 @@ struct kmem_cache {
 	pthread_mutex_t lock;
 	unsigned int size;
 	unsigned int align;
+	unsigned int sheaf_capacity;
 	int nr_objs;
 	void *objs;
 	void (*ctor)(void *);
@@ -234,23 +235,26 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 }
 
 struct kmem_cache *
-kmem_cache_create(const char *name, unsigned int size, unsigned int align,
-		unsigned int flags, void (*ctor)(void *))
+__kmem_cache_create_args(const char *name, unsigned int size,
+			  struct kmem_cache_args *args,
+			  unsigned int flags)
 {
 	struct kmem_cache *ret = malloc(sizeof(*ret));
 
 	pthread_mutex_init(&ret->lock, NULL);
 	ret->size = size;
-	ret->align = align;
+	ret->align = args->align;
+	ret->sheaf_capacity = args->sheaf_capacity;
 	ret->nr_objs = 0;
 	ret->nr_allocated = 0;
 	ret->nr_tallocated = 0;
 	ret->objs = NULL;
-	ret->ctor = ctor;
+	ret->ctor = args->ctor;
 	ret->non_kernel = 0;
 	ret->exec_callback = false;
 	ret->callback = NULL;
 	ret->private = NULL;
+
 	return ret;
 }
 

-- 
2.51.0


