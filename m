Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCDA1CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E916B00A5; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC9A6B00AE; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028E96B00A5; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF386B00A9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68F459117D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:29 +0000 (UTC)
X-FDA: 84868280658.01.DD5EC67
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1172240015
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=oBGxjT9C;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198067;
	b=7tfgooS3bwguvVbvg19fB2CCDJcNtC8yQvSV/je7Qgu0faAOi2mHdo4C5Z98kBOD8gJORT
	04jFsPlPikkT9tNcZgP6Hab86NtY5n0l92LZLgs03eZkp0WaXcMQLMoRSJQFRJTn5ZbdjZ
	S28Nz5/W9L6zsTVDayOrrMVA0TSO65Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=oBGxjT9C;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxJht1/v+tMh9CkAooJgN+z3AWBrmdU8Oh7WKsy29Bw=;
	b=nn5TixvbsYUmR3T5CnIjIj5Gu27AvlmWKdsK8x/ssUVfNKav4xtMwVLxSz5yFjmJ2b/2ZN
	R4onx124C39RnsTEB+L/jhH0Mxha0eHt5a1ng+68SnhkgL4Mp4qDpVLYaVJsLy4OZo2AQz
	rj/lvAum/Ysz1YD0FdkI88gCXXagTok=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MxJht1/v+tMh9CkAooJgN+z3AWBrmdU8Oh7WKsy29Bw=; b=oBGxjT9CzjTGO3icATLcjH4W27
	OMCnPArujlVOXEqdjagI5lHfnFsDwf+4/GXk89SKh9+atRFb8BVjzBC55ljshrPY4MvZ7mccWLhvN
	cnrbQ0SC6NhPK/lf4H+nB7++DqxDQHflS9vPW1JtZK0SjY97ZKlID07Q2wj5IimmDQ0TV1puQSh3w
	EDHg5j4Q6yG5WXeHoSKRE5MVSAPEu01K164tATk4e2Pa61Ai5K6Fqi8jCWdEy0C9PUVNrMobAwp5i
	xt/i59Qe7k6avXXLBpQQNLdO0jp0nwWfB8vcPmeVUvRau7zD5LsUBsMIId+ELksn+UBSBxqHd+2Pl
	oEDrcvLw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz3-000000070mE-3Pge;
	Thu, 11 Jun 2026 17:14:25 +0000
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
Subject: [PATCH v2 2/9] allow static-duration kmem_cache in modules
Date: Thu, 11 Jun 2026 18:14:17 +0100
Message-ID: <20260611171425.1671254-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171309.GN2636677@ZenIV>
 <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1172240015
X-Rspam-User: 
X-Stat-Signature: 7rkn6m95wcaq6tybngbo9wp7yb36ob43
X-HE-Tag: 1781198066-940305
X-HE-Meta: U2FsdGVkX1/4TGKmrJ+4bKOdyTQ5jdSdAOLcdqeYxDRC6aizYsw1QyM8rw061crCfHn63jDpM6b2Cz3giGA27o3oT0hHng4Qidps6/IR0MeqRlGuM6VAitBy0uR+IjABGVIbgJl4aLTdXpUdcR6C3fxl1tLHvhQC2NBCA/abEb0uaKy6vqNtvwZ9wJKAIOG4ejKOPoP4MRp001/epP77cAcn5Tlp5g9W5r79hj6jXdSB5OKhtRXdHe/sX5TRiFnNwA/53mAltmEgkeJa1YncYngTUpEr8YE6xxVe+sQU6qFLI3WWvKt4g/LNYO9lyWB02vi+spD2xh5lgcC9BnBItGk3V/T3e2fMFK8wkVo72oXcBkhkhFhtE+mOzflV37L1dlwjvYRJB4Wix9v025uwEbWnSougsFfwxqmdxOYwRYJjq503OjqWO8D8eRnZieSTJBLD2xr6mcOfaJGjdVcghct5/WNZ2aNcOd88ZF0eTjdUHI1bYTG20UpuI3o/rNJ+yZOQGYpZv/P9aL2PqLXN43mfmjOL4S1tvHCr5/fdZKBpFkxKHdCVA3/NkncK4ZetybOvlSmJUCse6hq0C+767X0unkYnyB5qtOV/q5RjhMHERdmcJmD1UdI3N28AZHjxPpH7Byx9zuSrk6cx82mwa/2pICky6DOB2MSNnnxALaIF5EjJVTWcGlUSLZbG//oMM2RAFbWKHSxlRmgkNyrTDw/pLatxlJxjl/Mb2waUpff1turPLZYJ7Bk8oIa1tOf/rMhsm70fTyuZkgKZiVEXhCle9ejHzuFfhVq29maD/SNxeBQEm52a2ubwJZ+k9wwCo5DwqiRvuAcclQERLzoKOgNI7GEHK7v3R8owNpfHWnU9diMtruBJG7yQqXnx81jeq9Le05la9TGjj/RDgNHfvnYmPYt1LHmnHZom+JutSUPbEhGMhoppjCmCd0scpGQv2QkleX5EohYh3ErmSMo
 f1orT2K3
 tLn9LS6gYe72vmTEOXOUvxqHz4oWECm7LYJb34kc5o2teMAH3nhhbGV+3gR/3At+kDLxxiHZwQ0jDts8/YvU09uqQ+Boeo8hHYidaAtjk55GmKN2WTG/yjxg6fKL1aXs7+78brfvlIE8mXC0q8llzoA4DB3caDeezJT6vvaIegF8AFatlNkD4d5j9swcFFPJrbjF5/98oa1ej2Ce2jINeB9R5FdhuEEy42oQC5y0VXNB1F4/hujVnYmD8yzpGqYvLuY+EyGINoXrG0KYvFLSjEeRcWS7vumwheC/GmblFNXOmDflq11iNasH5tmGN0orIL7V+W6LHQnEoX2imd+sVAopIa+iVX9+fdcWMlGR+oIEUD/N6GnWsKsUTTO/0/ZQZFR/G3UAeaLtRoo+tCF3lRC4DnAlyFOGx1Nj1loPaIiUf7JSW2XdIj3SqvCKr5XRQSJE3nsHfpHqfixT+BKdQXqse0Ucu+3zwMeDcpYWrosNyEyjrkr14En1SUw==
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
 mm/slab_common.c            | 25 ++++++++++++++++++++-----
 4 files changed, 33 insertions(+), 9 deletions(-)

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
index f63657d3cf81..c95ad771ece2 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -62,6 +62,7 @@ enum _slab_flag_bits {
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 	_SLAB_OBJ_EXT_IN_OBJ,
 #endif
+	_SLAB_PREALLOCATED,
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -248,6 +249,8 @@ enum _slab_flag_bits {
 #define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_UNUSED
 #endif
 
+#define SLAB_PREALLOCATED	__SLAB_FLAG_BIT(_SLAB_PREALLOCATED)
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
@@ -379,6 +382,7 @@ struct kmem_cache_args {
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
index 57de41c7f1aa..2567c1c19847 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -182,13 +182,10 @@ bool slab_args_unmergeable(struct kmem_cache_args *args, slab_flags_t flags)
 	if (args->ctor)
 		return true;
 
-	if (args->preallocated)
-		return true;
-
 	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
 		return true;
 
-	if (flags & SLAB_NEVER_MERGE)
+	if (flags & (SLAB_PREALLOCATED | SLAB_NEVER_MERGE))
 		return true;
 
 	return false;
@@ -258,6 +255,12 @@ static struct kmem_cache *create_cache(const char *name,
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
@@ -366,6 +369,12 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		    object_size - args->usersize < args->useroffset))
 		args->usersize = args->useroffset = 0;
 
+	if (args->preallocated) {
+		flags |= SLAB_PREALLOCATED;
+		if (args->owner)
+			flags |= SLAB_NO_MERGE;
+	}
+
 	s = __kmem_cache_alias(name, object_size, flags, args);
 	if (s)
 		goto out_unlock;
@@ -521,7 +530,13 @@ void slab_kmem_cache_release(struct kmem_cache *s)
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


