Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB23D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69CB46B0089; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F596B009D; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C536B009F; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 726C86B0098
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 310B1C01BB
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.13.1699D7E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 68D77100009
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TFa5gVdr;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISNZFsbhMluGOOgPJOf7PuXZbW/+Y33dgsD1DeUdNV0=;
	b=71z3ELUL9v9rbvYPPbXwGBP1geuIJFH8Botq7F1T79NS7nmKs8Gj02jWS38dw7Fif/WsIo
	eb38eUyMZwFxKMmtY2Pun16PcoPPCdTSS2AypUrQaeif39u3aP1G4zjzxwSaKTJ5zvjffp
	Zie7sgOjtKf4UA8sJtZoeD36UYi/Ia0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TFa5gVdr;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=ABWFmGyGYdGd0yHGHujep7KWHJoBryt2s7W4P4W1/USv4faEZv25BANbu5H5E72gEzjLUl
	bC/U5LMeunhdscgrJ2SX5fBDJK9zI7AxaXZcyMjzeE+QcJKH9LH9GTtacsMj1CR/i9KynD
	kiqqwYg9TIJEY7YvX75siwUBHvGPsKs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ISNZFsbhMluGOOgPJOf7PuXZbW/+Y33dgsD1DeUdNV0=; b=TFa5gVdrJvHVBG1sACtJpPQTOx
	+glfX5twmsJHBvGQUd7Lw6Y+eEtRTXV77LC0AUyJHDPFml5kDOFay7oyDroqQn4vCJRcljjNA0aSz
	+QxWiTMVa86jafeoaXLMOWXtREF0YYii1VtGCQNHJh1BFZtaezyAEKZpJWWDXIm0Ld71UF4NIazsu
	GqDPFmAj1U/RyGs0YUSxdga4Vb0FbVSPchaXbqR40LpZ96DTfeku9RnQvxIVIwt4DEl3yIAUpfWmI
	4Ca+Fwlz7Q31GJeuKZ2e9DoUwKZLhy+hSK5pcPJPtymhmyfb1WBOr8Uia9RNWzOz5VlLooAzzSV/i
	JZInNl/g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB8-000000085ZD-1yqq;
	Sat, 10 Jan 2026 04:02:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/15] allow static-duration kmem_cache in modules
Date: Sat, 10 Jan 2026 04:02:04 +0000
Message-ID: <20260110040217.1927971-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u8eaitizj7pobbwk3t5fjk76rojbt7rc
X-Rspam-User: 
X-Rspamd-Queue-Id: 68D77100009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768017660-712933
X-HE-Meta: U2FsdGVkX19tYOLZReHOQ54SQdUlIhow3ELvR79gpLftfwDcyFfb/SCiI0uK/70VihcWhRy4d3VT+PnNaHm5t1CEMybw1NHklJx281cOW/irhYOapxtZhtweetox65HoHymnVDzhuv7DIBCh+crQmabUbZkPL8uz3KZ9TLZ5QGKZESUlZgA147Qsfik43pw6cAqz/5KQI71Mnn+WbzV+2O4aooJE0OVcBsTufxWaqATje52BAunyqVifRQKGz/ks/3VFJxVV3DXg1jBNBl3mjmP3NnXPyu0T9HgfzdAUUgTxa9jnVAZf0cdmaDZ3uCbOHeBl0Ufl1Cy0GTAEEfWlJfTnxVgn9x3NOxV7ORHbhrbW07wzzCXdXhEkjIpNvv9qsOQH310U65qNG5O0hgYsRjoFyTbjrHRCN7uuHjoehXAau9MsCd8opTcWRN8+Pm1ua6qUkOy1O2/FJ4w3gGnXrn+QNoTrLobFbfhKsJer7tUnBAkOoOQYwzEnZBruxPTUbBT0s3s31AB6NGNY3xAVkRW9P9ec3Yb1Bh+nhU+1aO3gIKHmUVPqDOlnfo9DH/pqllwylXjJ/lSEg1IBm4+zXmIjddG82fnUZErfpnw8F7oUA6IbxRRHu5D0qyycyRtqbShm/Uzp/QIfNuS25Oq/OwnxJz9O3INuzBuERICdBAXcecdr3MHEfXMtS0q7051ZC1pQyhnowWTAUqmCM6ludqY87rgWfh1P3cc6jdUWwoPzGJVQe4IpKjINLaWlhjLtyUJFpIySlB5PipVv4rTg7GkaSgVzy7vWNcLkY4N1RoAUXQ+2iO8Th798eoyJvBCM1FTcvXiD9UffXzbjTj8WywVVCxHmtYAd9/WE9yLiXR8YC64ocgnxbAmsAmbSpQj4+K9pcdkG7Yn6mohmHvtiggM1TvxnTNkAqd+WxtkDoYNKaf+4KtrQv5JK9ipk6SaVHL+kLrCOouCc5vF3B6d
 +5+pFLCb
 MmdWq282NYPh1cMZM9/L+VJW31AH3yqPuLjtiMq9FKgDO4Z8WVR6D9hCc61YxCYvQIdn3sYtAxBQvI/cXVLm4q4Qbffw7GLPzt4tHmSz1BrSKWhLKTRdQfQHH3DUol8ZrgZDZrhlM4krKN3CqZchifDXwrNinU9RhByxCx/u39H3dZ96dN0UdDBldkzJNzyvELVgMp8QETETsv0d3iooF6Ii73cDQhwj3X73EjGAjLYwc2AEzLd9tFFwMd1H//3x61515bdLGahj0J+YsrDCDyUINX2tjC9tEgHDd4B0bBcsUGW3JIs6z3krxerJeFsnBDcemyKWEJeG7Y51F/+mlQuhHLdk2feLOwcQpiMjGKMc+LaNOPQOTvype15vabKlunC5/obpoEGuEhpMw25d6QrKrHtKQVPgG1BOflujAU8iT8dY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

	Let setup helpers store the kobjetct to be pinned in
kmem_cache_args->owner (for preallocated; if somebody manually sets it
for non-preallocated case, it'll be ignored).  That would be
&THIS_MODULE->mkobj.kobj for a module and NULL in built-in.

	If sysfs is enabled and we are dealing with preallocated instance,
let create_cache() grab and stash that reference in kmem_cache->owner
and let slab_kmem_cache_release() drop it instead of freeing kmem_cache
instance.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/slab-static.h | 12 ++++++++----
 include/linux/slab.h        |  4 ++++
 mm/slab.h                   |  1 +
 mm/slab_common.c            | 16 ++++++++++++++--
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/linux/slab-static.h b/include/linux/slab-static.h
index 47b2220b4988..16d1564b4a4b 100644
--- a/include/linux/slab-static.h
+++ b/include/linux/slab-static.h
@@ -2,10 +2,7 @@
 #ifndef _LINUX_SLAB_STATIC_H
 #define _LINUX_SLAB_STATIC_H
 
-#ifdef MODULE
-#error "can't use that in modules"
-#endif
-
+#include <linux/init.h>
 #include <generated/kmem_cache_size.h>
 
 /* same size and alignment as struct kmem_cache: */
@@ -13,9 +10,16 @@ struct kmem_cache_opaque {
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
index f16c784148b4..dc1aeb14a12b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -60,6 +60,7 @@ enum _slab_flag_bits {
 #ifdef CONFIG_SLAB_OBJ_EXT
 	_SLAB_NO_OBJ_EXT,
 #endif
+	_SLAB_PREALLOCATED,
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -244,6 +245,8 @@ enum _slab_flag_bits {
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
 #endif
 
+#define SLAB_PREALLOCATED	__SLAB_FLAG_BIT(_SLAB_PREALLOCATED)
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
@@ -373,6 +376,7 @@ struct kmem_cache_args {
 	 */
 	unsigned int sheaf_capacity;
 	struct kmem_cache *preallocated;
+	struct kobject *owner;
 };
 
 struct kmem_cache *__kmem_cache_create_args(const char *name,
diff --git a/mm/slab.h b/mm/slab.h
index e767aa7e91b0..9ff9a0a3b164 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -249,6 +249,7 @@ struct kmem_cache {
 	struct list_head list;		/* List of slab caches */
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;		/* For sysfs */
+	struct kobject *owner;		/* keep that pinned while alive */
 #endif
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
 	unsigned long random;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 81a413b44afb..a854e6872acd 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -245,6 +245,12 @@ static struct kmem_cache *create_cache(const char *name,
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
@@ -322,7 +328,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		args->usersize = args->useroffset = 0;
 
 	if (args->preallocated)
-		flags |= SLAB_NO_MERGE;
+		flags |= SLAB_NO_MERGE | SLAB_PREALLOCATED;
 
 	if (!args->usersize && !args->sheaf_capacity)
 		s = __kmem_cache_alias(name, object_size, args->align, flags,
@@ -481,7 +487,13 @@ void slab_kmem_cache_release(struct kmem_cache *s)
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


