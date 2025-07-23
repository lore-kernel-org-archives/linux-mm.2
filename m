Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA1EC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1146E6B00DB; Wed, 23 Jul 2025 09:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5336B00DC; Wed, 23 Jul 2025 09:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80CD6B00DD; Wed, 23 Jul 2025 09:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D2D6A6B00DB
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE2C616052A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:31 +0000 (UTC)
X-FDA: 83695626462.09.066A1F3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6AB1C40013
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KxrbcoQK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5VH7Cvn5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KxrbcoQK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5VH7Cvn5;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277729; a=rsa-sha256;
	cv=none;
	b=wPfvHOSGOtFIVB7FnTJMnXe0kehEsxIPRvHBLe89rJ8itnUyXXl9QoFSTk8coCZQ4boocg
	ear2jIoHTDMuDw6UnukZvKzkXfIhzbF0xKXQSDAOubTNUqWfrhXgoqpgXmKP1CoQQEN2lq
	WZ+NjyEsbpQzmCDtGFt+umxgWtMJl9o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KxrbcoQK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5VH7Cvn5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KxrbcoQK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5VH7Cvn5;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rl2sdnU3Na/QjO19ynlaiFzijVMgFDAZeg0f3e42QKM=;
	b=UUxITK92AySnnZ4h5csU/kZ9Tgi7VleiS2Inm5cyixDiAT0CVZJ4EOX2yfQ3hJ9Ystzi2k
	JssxQUHO/UYTLyorGM7n7V95qHsyAnZFZT+Oc08g3o+3a+jP1BXIszYF8Rru+ugRt8H7S4
	1PttrBvPhAqRaw6NuYTongDpOGEep8M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 447311F791;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rl2sdnU3Na/QjO19ynlaiFzijVMgFDAZeg0f3e42QKM=;
	b=KxrbcoQKJ5Zfh0d43utMQ996V/KuOHaz6QEYI7AgHy8WjqkcVQXXy527a0GvSIEIX5CuIm
	kX6sxUWQegF3+JIEGkUor41DcDTaGhM1mbpxq8bLum1o3JAA3BtoWZiZIUW9MdKS1ymbay
	8lEda69OpP83eNKooq6uFbn09O+5cVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rl2sdnU3Na/QjO19ynlaiFzijVMgFDAZeg0f3e42QKM=;
	b=5VH7Cvn50oCDXW33Smu9Pmz6TOm7KOYfInWQRUWwsYQRJm35g1CbxZiVux8KjZZ2CGGDZB
	XXH7aUnC+4hDV8AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rl2sdnU3Na/QjO19ynlaiFzijVMgFDAZeg0f3e42QKM=;
	b=KxrbcoQKJ5Zfh0d43utMQ996V/KuOHaz6QEYI7AgHy8WjqkcVQXXy527a0GvSIEIX5CuIm
	kX6sxUWQegF3+JIEGkUor41DcDTaGhM1mbpxq8bLum1o3JAA3BtoWZiZIUW9MdKS1ymbay
	8lEda69OpP83eNKooq6uFbn09O+5cVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rl2sdnU3Na/QjO19ynlaiFzijVMgFDAZeg0f3e42QKM=;
	b=5VH7Cvn50oCDXW33Smu9Pmz6TOm7KOYfInWQRUWwsYQRJm35g1CbxZiVux8KjZZ2CGGDZB
	XXH7aUnC+4hDV8AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B13E13ADD;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wIc6CgjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:38 +0200
Subject: [PATCH v5 05/14] tools: Add testing support for changes to rcu and
 slab for sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-5-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6AB1C40013
X-Stat-Signature: 6766b85hfsdfioshzqnwkkxo5zjae34c
X-Rspam-User: 
X-HE-Tag: 1753277729-505882
X-HE-Meta: U2FsdGVkX1/DDX4p8ZeyS2cGgczvlXN4fD0iBFSNJa7caiRpbdWjmYIXDlxgnunRjRLXsrlmX8zPo6iNx8TSgl8tTvG1yzwk8Xy44tBZs4eGtDeSZs3+dL+k1Ku+B6MZWURKakmbRI1/73hE3Aga0QOeLwj1ccpQ9FLoqDmizJQWp1mcdWBRNJHcv9eF/X0SsBAQbwLaSvtzW79vLg35UTdsAGk9YIs8SpDlas4zOtIySl3+ddRrRvInP88tnF9nCNZofYg6pZkVwK+xCi7WsnRLq1c3pPTUTvVDM1Xxkw7U6fwy0lXBxukxGrCDX0y1Ru0Mh25ImaAbvh50612k2jBmjYVUxYE31isnO5LrW64B15dous0ozd7aIT+wqlrxfP9XbTWNOZ9f06wfvICRwIcCIwKDEcyaazOdeCIAB7yEQKHSPv+wDyNWk8Tatlel7xjpEvCVS/vRi9z/dAoia4DHTdCYDt8PfjqfB+gDoqLCdt6XO9tw2RjNCUsKrMWig65GhMMv+xSZPfqRV0bQCgPVA0Y0+yWen+xNoyN1qqiW8rTCOPsbUlWGF8lefkBd5rKvk5YeNvabkezAOBE5lZdOGSr2SwPSkUHA00TxJ3Jau9aoO9xj5S6hr/ijR5Kui4dSCtLjZ9unHjjitU7T1Q2UoYzbVf7nZyj3lzvCvGmhL9afPTbtdl+9lXp7OIjtxRmvTGsCaBPTZNuPfxgm86kXHuMc5AZOnZe7C2M2me/0sGSvsE8F1KTaKfvSM4JFjXXLQ72/LItQg9z02EHLMSycyZWApqxV6hk+ZqbIQSJpxJSeDirN/xdEdfJA9ZJGC5BZkHGCQlEGn51xDLXU7Ql5lReiXAUIpKzbClERwMmUDtjc+pnh+fG5SEfiNGiqFC4K0FX7FPSJZIt3lsOYewSNn1kKSKwj75j5e5D4R7rP10sCzrrP49DqY0HDbCTCiCWbIagZInrYq3g/b5U
 aSGEXiW+
 zESnxrwsWkeFOHYvvGwUE7uq3Y+Q5F1IhJ80QN7nVNKpszAfLb6JMSg2zW85cfqAIS4sUgtCxWeazftRYS9AYp3HDl3cd0k9LOg5QujHbF7adnyKLv84gP3/gkUzCvD8s21Ncxwb/MRDTgAse9p0P/oupwSXJymQMTn65C+ni2cxxu+DD9J444picXWbCMjxED8C5INu0CxpIOCLlIT7qEQQLjr6HnvAyGDtMZbOP7+PtGdepUEWv018C1Aau3U0nKbOIO7zj6/aDj4gcDGVeCst7XVtGLbtlMK2yDmSxCLiXQV7PJIs19grZBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Make testing work for the slab and rcu changes that have come in with
the sheaves work.

This only works with one kmem_cache, and only the first one used.
Subsequent setting of kmem_cache will not update the active kmem_cache
and will be silently dropped because there are other tests which happen
after the kmem_cache of interest is set.

The saved active kmem_cache is used in the rcu callback, which passes
the object to be freed.

The rcu call takes the rcu_head, which is passed in as the field in the
struct (in this case rcu in the maple tree node), which is calculated by
pointer math.  The offset of which is saved (in a global variable) for
restoring the node pointer on the callback after the rcu grace period
expires.

Don't use any of this outside of testing, please.

Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/include/linux/slab.h            | 41 ++++++++++++++++++++++++++++++++---
 tools/testing/shared/linux.c          | 24 ++++++++++++++++----
 tools/testing/shared/linux/rcupdate.h | 22 +++++++++++++++++++
 3 files changed, 80 insertions(+), 7 deletions(-)

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
index 0f97fb0d19e19c327aa4843a35b45cc086f4f366..f998555a1b2af4a899a468a652b04622df459ed3 100644
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
@@ -31,6 +32,8 @@ struct kmem_cache {
 	void *private;
 };
 
+static struct kmem_cache *kmem_active = NULL;
+
 void kmem_cache_set_callback(struct kmem_cache *cachep, void (*callback)(void *))
 {
 	cachep->callback = callback;
@@ -147,6 +150,14 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 	pthread_mutex_unlock(&cachep->lock);
 }
 
+void kmem_cache_free_active(void *objp)
+{
+	if (!kmem_active)
+		printf("WARNING: No active kmem_cache\n");
+
+	kmem_cache_free(kmem_active, objp);
+}
+
 void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list)
 {
 	if (kmalloc_verbose)
@@ -234,23 +245,28 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
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
+	if (!kmem_active)
+		kmem_active = ret;
+
 	return ret;
 }
 
diff --git a/tools/testing/shared/linux/rcupdate.h b/tools/testing/shared/linux/rcupdate.h
index fed468fb0c78db6f33fb1900c7110ab5f3c19c65..c95e2f0bbd93798e544d7d34e0823ed68414f924 100644
--- a/tools/testing/shared/linux/rcupdate.h
+++ b/tools/testing/shared/linux/rcupdate.h
@@ -9,4 +9,26 @@
 #define rcu_dereference_check(p, cond) rcu_dereference(p)
 #define RCU_INIT_POINTER(p, v)	do { (p) = (v); } while (0)
 
+void kmem_cache_free_active(void *objp);
+static unsigned long kfree_cb_offset = 0;
+
+static inline void kfree_rcu_cb(struct rcu_head *head)
+{
+	void *objp = (void *) ((unsigned long)head - kfree_cb_offset);
+
+	kmem_cache_free_active(objp);
+}
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER)	__builtin_offsetof(TYPE, MEMBER)
+#endif
+
+#define kfree_rcu(ptr, rhv)						\
+do {									\
+	if (!kfree_cb_offset)						\
+		kfree_cb_offset = offsetof(typeof(*(ptr)), rhv);	\
+									\
+	call_rcu(&ptr->rhv, kfree_rcu_cb);				\
+} while (0)
+
 #endif

-- 
2.50.1


