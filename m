Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6982DCD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799E96B0093; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772676B009B; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6885D6B009D; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB0F6B0093
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE8A51C32B8
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.01.AB7A02E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0DAD11C0007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=r2gupMby;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5eFW2g7W1dcJNtE4gdFektrsMjBmaMLK4+5JsIr98U=;
	b=tP8isfH552mJil+su3jw5HmKDMFi7qM9PJfO1Ns6QHUSg4CCxSEDUaHo4e2phR91VOEiw1
	3hMckOHDW1qUjB5aCiEr87/iAW9AgaaS5R5Rp9MPuePxkxQ/Q5UIzzMsrK31f0tmKlXcqZ
	mgBFBUau+dPuozFO91Ltscw1lSkLRN4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=r2gupMby;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=D90SPQ/1rPu+5rKkZeIrrIGLPKp9gGLS9PkeZCsjUbewGTbgopFjoLtU7cLp8RXXU/lQLC
	y1E6NXjsN2PmFuAgMAx3ELsruE+Z9LUF+WIOREB3ImeBiw1J9wDZeCQA+hk9BCyqZmL8fj
	qI3tZV17G5F7LRwj9FXOE55MK4CAVXs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=v5eFW2g7W1dcJNtE4gdFektrsMjBmaMLK4+5JsIr98U=; b=r2gupMbySKmfWqHfZq5g0R3ZS2
	7W+4ibTEhfYBwKj2I+ajAicV076fh4vivRZ+uZEH6YvFWmJZSjlu7DaV7W8C1RaSYia07QdF0zdYj
	kLsgFib+h3Z67aodCxRYuO6EeZFXAwccbKa5jjt/1BnzCRTRO521+zppM73EuzLBJjATpifJl1GVZ
	msdUMEIffQxNn8EcSjWY0VKAdaOpmo6Hiq+nxpKdc4e7d9aaZ3bmPvs8qE7CgQT79fGvupEzevxH8
	oa2oae8BiJBuPf87hdGwp4HBHYYgIRQrOklBS39V///Q9ETpfA3DwUoTrE8eMdgzII1wAQTOFVJkq
	2yrgLPmg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcy-00000003aT0-1Lre;
	Sat, 13 Jun 2026 05:09:52 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 03/10] allow preallocated kmem_cache instances in modules
Date: Sat, 13 Jun 2026 06:09:44 +0100
Message-ID: <20260613050951.855141-4-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0DAD11C0007
X-Rspam-User: 
X-Stat-Signature: fp43utdgfj83itswbumr6yhhys9yhoet
X-Rspamd-Server: rspam09
X-HE-Tag: 1781327396-602120
X-HE-Meta: U2FsdGVkX19+980XJYWNpv5hKaAXchoU0z4A5ZJmZJea/At2RJhnkKKOrbmtfgUuvePPFFwLapj7saaUYVxhnrtub7Taxn7g1UNRPSmo2Ah6NCAYaHlQ0AbVkHEf9Ymyt2QTAier8Ky6mtiAiaMBb9VAhy3CqvR6/iqqJH0fohXBENKQeVNLjfYw2Tdt0TeV1sEYy0GFn/sOl2IY6iaFSrLHQ3ctxMsvTjppkVKuGo/SisJDDL2Gv2J5YwP66VWCCC8i1b+8/EnAVTgSkC3LGst+qu1LBdvLNntA7BXMb5dP6TX8XQanoQJoUr321YFVwrYAk13SI1QwywMtrOk3coeuCFfXJ022IjF2eJofjCH/+Frxyjy9M9RLniNbvUIEGe/N0AQSH0q4Wv12URVzeBfWpk7cMq1vHp6eTHfJyI/chc/aCq96lgDxza1xtMwlqUem7FJKXhHWmdiZY0GvBOAukof3RPTGtLe1tlBC9x1S/oNUqLol+oaQ/H83dUzm2ypnPensZ+LS8+bqStj2/9wbuPy1ixg2p91PQimHf/qAr0WkGCV6VHmRDVIwwisMIXHu0VsUIaNndpSf3kVy0ulBeBR7I4LZiSMFOaOBcxDA+Li0Sf7jVvqpBUFveyBaiE8BwWTJHDXAQ4djGYbTZ+WhWNDx46YzIXfA6JRscM23llGokewFJnYzzjwk4BQZepiFQ68DdDyt9Of+a3ONesWOfNa0KzIMp2P+WwOdaqsm5MW+qjUFraOXn5elbAFSARsZydGHIacsBETv5yUbm8ix40Ptl/P4sLwPrIdpWvM13eP0MmTNJSNrSTN/muaJF1gIyVG/6vsJj8pGm3pZMYqRvBzYgpjU9GbnuBrGiyVltWoxPAZOZe/FcRCfxSkB4o8zbKjR5bQhOVXSYbue+X44+haOAKSLtxVcE9IMZJbPjKtysWsE+q0GtBtbrpCNCsHSWUqVwHGEeikNz/s
 JZh5Q/t+
 tMylooYJDUb0427QF5MjQkffGRgXxm3cg2gKZFJUrEtENdGWWkTBNsXC7unF2BRNbXMBQMXB/ga96cnhliXh9ezKxcfw8JbJ99eFtQI7MQ5MKWQ1v8emLV/MndznPye8OX4KzOEJx8uPlENhZoACLuY1KINmAS9ddNqCXjVzbjIm1Ee8wyhE/DsJtiwm8QjuDrGIBGVUB1HQgxly0U8wDciK0JxE4wmOMmI4/lmRBWWdTTKzt2Tu7IkorhtyroS+BllFd+aIydO20rCLK1dUyMVrCHdsCwbHUQqvIKRbjWsKjIVhoS0QMQt+KiCOZBUg7J+Sk8wH0UCboN7OlLZ+9FxobWa/HAt6q6jg91jWBwnx1B1AZz7ZUBz12yf5STOsWQ2/ljrV/mZkkciVKswCWV/nS0cu20IZOkN0UOim32aWxAwKbzJik5oeWEi++c+Hz4ZevoA9jBwsgj4hqzQrUKvxU8v3RIniWazWSK7eDA2PpDffIe4Qzba9JuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

	We need to make sure that instance in a module will get to
slab_kmem_cache_release() before the module data gets freed.  That's only
a problem on sysfs setups - otherwise it'll definitely be finished before
kmem_cache_destroy() returns.

	Note that modules themselves have sysfs-exposed attributes,
so a similar problem already exists there.  That's dealt with by
having mod_sysfs_teardown() wait for refcount of module->mkobj.kobj
reaching zero.  Let's make use of that - have static-duration-in-module
kmem_cache instances grab a reference to that kobject upon setup and
drop it in the end of slab_kmem_cache_release().

	Let setup helpers store the kobject to be pinned in
kmem_cache_args->owner (for preallocated; if somebody manually sets it
for non-preallocated case, it'll be ignored).  That would be
&THIS_MODULE->mkobj.kobj for a module and NULL in built-in.

	If sysfs is enabled and we are dealing with preallocated instance,
let create_cache() grab and stash that reference in kmem_cache->owner
and let slab_kmem_cache_release() drop it instead of freeing kmem_cache
instance.

	Preallocated kmem_cache instances in modules are forcibly made
non-mergable - any subsequent alias could outlive the module (and module's
.data) by arbitrary long time.  If you really want your (modular) cache
to be mergable, just have it dynamically allocated.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/slab-static.h | 11 +++++++----
 include/linux/slab.h        |  1 +
 mm/slab.h                   |  1 +
 mm/slab_common.c            | 19 +++++++++++++++++--
 4 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/slab-static.h b/include/linux/slab-static.h
index 007fc0bd4e8c..16d1564b4a4b 100644
--- a/include/linux/slab-static.h
+++ b/include/linux/slab-static.h
@@ -5,18 +5,21 @@
 #include <linux/init.h>
 #include <generated/kmem_cache_size.h>
 
-#ifdef MODULE
-#error "can't use that in modules"
-#endif
-
 /* same size and alignment as struct kmem_cache: */
 struct kmem_cache_opaque {
 	unsigned char opaque[KMEM_CACHE_SIZE];
 } __aligned(KMEM_CACHE_ALIGN);
 
+#ifdef MODULE
+#define THIS_MODULE_KOBJ &THIS_MODULE->mkobj.kobj
+#else
+#define THIS_MODULE_KOBJ NULL
+#endif
+
 #define __KMEM_CACHE_SETUP(cache, name, size, flags, ...)	\
 		__kmem_cache_create_args((name), (size),	\
 			&(struct kmem_cache_args) {		\
+				.owner = THIS_MODULE_KOBJ,	\
 				.preallocated = (cache),	\
 				__VA_ARGS__}, (flags))
 
diff --git a/include/linux/slab.h b/include/linux/slab.h
index ec68aabf98df..c95ad771ece2 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -382,6 +382,7 @@ struct kmem_cache_args {
 	 */
 	unsigned int sheaf_capacity;
 	struct kmem_cache *preallocated;
+	struct kobject *owner;
 };
 
 struct kmem_cache *__kmem_cache_create_args(const char *name,
diff --git a/mm/slab.h b/mm/slab.h
index bf2f87acf5e3..8b1db0d03226 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -219,6 +219,7 @@ struct kmem_cache {
 	struct list_head list;		/* List of slab caches */
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;		/* For sysfs */
+	struct kobject *owner;		/* keep that pinned while alive */
 #endif
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
 	unsigned long random;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 5b6aaa96d68d..1717c79d92be 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -255,6 +255,12 @@ static struct kmem_cache *create_cache(const char *name,
 			kmem_cache_free(kmem_cache, s);
 		return ERR_PTR(err);
 	}
+#ifdef CONFIG_SYSFS
+	if (flags & SLAB_PREALLOCATED) {
+		s->owner = args->owner;
+		kobject_get(s->owner);
+	}
+#endif
 	s->refcount = 1;
 	list_add(&s->list, &slab_caches);
 	return s;
@@ -366,8 +372,11 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		    object_size - args->usersize < args->useroffset))
 		args->usersize = args->useroffset = 0;
 
-	if (args->preallocated)
+	if (args->preallocated) {
 		flags |= SLAB_PREALLOCATED;
+		if (args->owner)
+			flags |= SLAB_NO_MERGE;
+	}
 
 	s = __kmem_cache_alias(name, object_size, flags, args);
 	if (s)
@@ -524,7 +533,13 @@ void slab_kmem_cache_release(struct kmem_cache *s)
 {
 	__kmem_cache_release(s);
 	kfree_const(s->name);
-	kmem_cache_free(kmem_cache, s);
+	if (!(s->flags & SLAB_PREALLOCATED)) {
+		kmem_cache_free(kmem_cache, s);
+		return;
+	}
+#ifdef CONFIG_SYSFS
+	kobject_put(s->owner);
+#endif
 }
 
 void kmem_cache_destroy(struct kmem_cache *s)
-- 
2.47.3


