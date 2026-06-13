Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C82DCD98D9
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FCA6B0099; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E8F6B009E; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37ADA6B0095; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 899306B0095
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E08C5120322
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.04.A39466D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B94F100002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=myzaZMTD;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNpPMJRuzPptN3b4+pwG4kih5al6fcdrnvjIBitAll4=;
	b=xp5ltAwADTT/H7JlgiOPlXmofVF2YyneBYFbsbj/3ShG7ICoL++j+DbIyLXOYHOoZbXeBX
	CFHzmHyzFb2hobYBiXjO8E2RsrxMo+FZCl6jXE/qRIwpAV1k7reuFdCEIYfYYOvN2WIXqO
	2ALjdZH3cgGyLO3SwmD0ixphqPyn8UU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=myzaZMTD;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=nnsveOT+lXX5ZxLufGYZNN4zsU79fql+64doULL2I9AJQRYBtlZtDB4DQOD4krFiuvPLk7
	1+rlHNabhkfaol0CM5lgpES7Lj6oRJS7SFfve8bLBnusQOzwXf22ROn+fVYtIEOQqkcQg7
	Ptlx/VEefAVPGQ38TPamB/7bFehz2WA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cNpPMJRuzPptN3b4+pwG4kih5al6fcdrnvjIBitAll4=; b=myzaZMTD20T+4UAZkEnkfC4kib
	dv/f/fHmg5934MeqcRlO2CwLAZnDh1DanDfxMsauMZbpZuV3EldVcQdo+R2l+oOppcT9sTvS9bsiy
	z+3SdtWxjVnQYUM9tIY1KBC+mRDSSP8lPYG2M/kSaB0Rs3EmlMqTAPIUh6eykwJGsbJuHPXrPIuj3
	vlzdNDZYr1qc3Gtabmros25Ble+2R7GB4yh32hDsAz5lDZtR+tjTuKds2a3uz3ajudJOVrkIV2hnt
	azyRwfe2Fj42LQYUbVDvQLYsA8+Ui98849VLD+/wq7QbVRNupEkQ1tTt/zSHSiPvB3EfAVr5ECcuA
	NwMKNSKw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcy-00000003aT5-2IA0;
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
Subject: [RFC PATCH v3 04/10] VFS caches: switch from runtime_const() machinery to slab-static.h
Date: Sat, 13 Jun 2026 06:09:45 +0100
Message-ID: <20260613050951.855141-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0B94F100002
X-Stat-Signature: 5fujnknczpn84e37upzh9jaqq3hi9qxa
X-Rspam-User: 
X-HE-Tag: 1781327396-983776
X-HE-Meta: U2FsdGVkX1/H+W9m/VPqvRnUOaOv7m95hYPZSuTJDJ2ykHlkePqC95wMoi/em+wUQTEgNWCGZiE4ONxfTap8CN/Lj3NPsAGLPTEQQkX/p0Qpv+Z79K9ZMnl0FFUAA3J0CLyg15mmYD+F/rFDB7nyBM8CxOD07JoVoA1OhAZnIS1/NDwVyfePp+4ekNIvQAg1EvOGRxrkAwMdFH7BoCNjrXf3wgDMMs2TjjZWe0j5kPIvTkrqcFxglCkG7oGjmEKCspfVmbnDuXFQ0CWCQ3HSNPcqFsbYugvk//VsH3jL59sLGEaOkgzmTJ4uefN5yABsfbLMETG+KyrHIgcE0kuLs/JfR2gqOMsYb2bYGDsJEtqJ0jtgYDg7ll4Pn+d6mzDi3iikVZbABZ3+BjcHn4cPZJ7RYszGj1LHjuHewfO7eoy+Y9xLCFxuZm+robOm32GXTcRtVnfKq7uyYtFkdk4xDfLL/df44gOZo5if9a/DWeu7W2icnbT3VlZY0PVyLHoHxVhvPnGgNHBwUXYm3n03yIcQziW3bSammDQGCzuGw0i54j21sf552PCAkiA0wsKSFOTnCD+w0wpqm7tVmRjIpvBU0kFSZ++KhC9zgmYasem0aLPDmKTt+dGlcPRZFHfpB3FlyFeEhWbzg4gCnYkIZ2HQ5DuvhDTU7O3iXRntEhcqsJVVOnF1hJiHajH1eQzfLaAzTb2+waLMMxQTLh5YGld5Rvlp7uYVfv2CCJNO983xqlahzprrC1wZP/km6PCwYu0SQc4tGqgmU0SiyzJ7TMJlx1SJCkGGgO8AujCtjbb4KHHe0SCmEdXsZmVcJa5D8nk9OIhw2yoD67ukg25akI4ucgqo8d0zQXY8IJyZFM1zIufh1Q2xI1vKkxJGgvI8Pqh8mhVara65FS0eHf2Nu8nDsfdLeB6pgrgXca4usyvgzbQv9/peZryqyyQfAEhxSoEbwqHZv1IXfZsJ2il
 ++mchShu
 8a3tUjieO3wJmzhkdgsCggStUxP9fMOlF8ZYPWdiJENqOPx4iRmV4vXu/HT8CFWtx007F7ymvbp9JngRJPMKOXGm48djAqFFt/JdxzjzTiiyHONTaCK+yJRTeUe1KqJVodeG2MQbdDF7j57FNws6B2bInf4+8lD0KsrP/aCxc2sfhZUP2mhXUq6mrdHy6kVa/rV/9aFJZVim/luoQmIO90OuiWann+b/vqWdx5LZjoSKomYg6UIL4b5wNryE22t0iKJcbBhNVF3u1ONWlZcDX/FX6y3hXqUsOpisjA2XIQVSn0SP4irnYZ17MnFdzs8TXt0Cr6ZqnoAY7cpxH/pK0vQ0PoGZvt4QWTCtX56rkjGpNW9elBQgI8ixhqANie85wAjclXd4kNplurlhnhwH0aLf33rd6PpKO+2JPR4LxBeR42ZL7v0MAG+EkHLj6CF/IsxNb4twQ/wDAV8AytbCxAxkfTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Four VFS caches are currently playing games with runtime_const() to
reduce the overhead of pointer traversals - dentry, file, backing_file
and filename.  All of these kmem_cache instances can be allocated
statically now, getting rid of runtime_const() games.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c                       |  8 +++----
 fs/file_table.c                   | 40 ++++++++++++++-----------------
 fs/namei.c                        | 16 ++++++-------
 include/asm-generic/vmlinux.lds.h |  6 +----
 4 files changed, 31 insertions(+), 39 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 2c61aeea41f4..e2feea82682a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -32,6 +32,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rculist_bl.h>
 #include <linux/list_lru.h>
+#include <linux/slab-static.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -86,8 +87,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
 
-static struct kmem_cache *__dentry_cache __ro_after_init;
-#define dentry_cache runtime_const_ptr(__dentry_cache)
+static struct kmem_cache_opaque __dentry_cache;
+#define dentry_cache to_kmem_cache(&__dentry_cache)
 
 const struct qstr empty_name = QSTR_INIT("", 0);
 EXPORT_SYMBOL(empty_name);
@@ -3362,10 +3363,9 @@ static void __init dcache_init(void)
 	 * but it is probably not worth it because of the cache nature
 	 * of the dcache.
 	 */
-	__dentry_cache = KMEM_CACHE_USERCOPY(dentry,
+	KMEM_CACHE_SETUP_USERCOPY(dentry_cache, dentry,
 		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_ACCOUNT,
 		d_shortname.string);
-	runtime_const_init(ptr, __dentry_cache);
 
 	/* Hash may have been set up in dcache_init_early */
 	if (!hashdist)
diff --git a/fs/file_table.c b/fs/file_table.c
index 16e52e7fc2ac..3844bc9f0e0a 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -27,11 +27,10 @@
 #include <linux/task_work.h>
 #include <linux/swap.h>
 #include <linux/kmemleak.h>
+#include <linux/slab-static.h>
 
 #include <linux/atomic.h>
 
-#include <asm/runtime-const.h>
-
 #include "internal.h"
 
 /* sysctl tunables... */
@@ -40,10 +39,10 @@ static struct files_stat_struct files_stat = {
 };
 
 /* SLAB cache for file structures */
-static struct kmem_cache *__filp_cache __ro_after_init;
-#define filp_cache runtime_const_ptr(__filp_cache)
-static struct kmem_cache *__bfilp_cache __ro_after_init;
-#define bfilp_cache runtime_const_ptr(__bfilp_cache)
+static struct kmem_cache_opaque file_cache;
+static struct kmem_cache_opaque backing_file_cache;
+#define filp_cache to_kmem_cache(&file_cache)
+#define bfilp_cache to_kmem_cache(&backing_file_cache)
 
 static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 
@@ -629,22 +628,19 @@ void fput_close(struct file *file)
 
 void __init files_init(void)
 {
-	struct kmem_cache_args args = {
-		.use_freeptr_offset = true,
-		.freeptr_offset = offsetof(struct file, f_freeptr),
-	};
-
-	__filp_cache = kmem_cache_create("filp", sizeof(struct file), &args,
-				SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
-	runtime_const_init(ptr, __filp_cache);
-
-	args.freeptr_offset = offsetof(struct backing_file, bf_freeptr);
-	__bfilp_cache = kmem_cache_create("bfilp", sizeof(struct backing_file),
-				&args, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
-	runtime_const_init(ptr, __bfilp_cache);
-
+	__KMEM_CACHE_SETUP(filp_cache, "filp", sizeof(struct file),
+			   SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+			   SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
+			   .use_freeptr_offset = true,
+			   .freeptr_offset = offsetof(struct file,
+						      f_freeptr));
+
+	__KMEM_CACHE_SETUP(bfilp_cache, "bfilp", sizeof(struct backing_file),
+			   SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+			   SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
+			   .use_freeptr_offset = true,
+			   .freeptr_offset = offsetof(struct backing_file,
+						      bf_freeptr));
 	percpu_counter_init(&nr_files, 0, GFP_KERNEL);
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index 4787244ca4a7..13d95881e921 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -40,8 +40,7 @@
 #include <linux/bitops.h>
 #include <linux/init_task.h>
 #include <linux/uaccess.h>
-
-#include <asm/runtime-const.h>
+#include <linux/slab-static.h>
 
 #include "internal.h"
 #include "mount.h"
@@ -126,15 +125,16 @@
  */
 
 /* SLAB cache for struct filename instances */
-static struct kmem_cache *__names_cache __ro_after_init;
-#define names_cache	runtime_const_ptr(__names_cache)
+static struct kmem_cache_opaque __names_cache;
+#define names_cache	to_kmem_cache(&__names_cache)
 
 void __init filename_init(void)
 {
-	__names_cache = kmem_cache_create_usercopy("names_cache", sizeof(struct filename), 0,
-			 SLAB_HWCACHE_ALIGN|SLAB_PANIC, offsetof(struct filename, iname),
-			 EMBEDDED_NAME_MAX, NULL);
-	runtime_const_init(ptr, __names_cache);
+	kmem_cache_setup_usercopy(names_cache, "names_cache",
+				  sizeof(struct filename), 0,
+				  SLAB_HWCACHE_ALIGN|SLAB_PANIC,
+				  offsetof(struct filename, iname),
+				  EMBEDDED_NAME_MAX, NULL);
 }
 
 static inline struct filename *alloc_filename(void)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 60c8c22fd3e4..4719269086c7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -966,11 +966,7 @@
 
 #define RUNTIME_CONST_VARIABLES						\
 		RUNTIME_CONST(shift, d_hash_shift)			\
-		RUNTIME_CONST(ptr, dentry_hashtable)			\
-		RUNTIME_CONST(ptr, __dentry_cache)			\
-		RUNTIME_CONST(ptr, __names_cache)			\
-		RUNTIME_CONST(ptr, __filp_cache)			\
-		RUNTIME_CONST(ptr, __bfilp_cache)
+		RUNTIME_CONST(ptr, dentry_hashtable)
 
 /* Alignment must be consistent with (kunit_suite *) in include/kunit/test.h */
 #define KUNIT_TABLE()							\
-- 
2.47.3


