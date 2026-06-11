Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98842CD98CF
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AEC26B00A6; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E24F6B00AC; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70856B00AE; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 929126B009D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5439EA0757
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:29 +0000 (UTC)
X-FDA: 84868280658.14.17C65E0
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id A3F0A40008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=oe1NSfZ3;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgiBt+cXBNmLBpECoGiXITUCwoLXcLuCPMDzB/akGTA=;
	b=ALm+iZA2u+LXgXw6oVBbTUGqCTuG8xoxfZSPCYkt2do5hgkF0QsUpc9sKxrK4KWZX4+k7F
	5ZvEnvVq+wjzRSiScYEomGls/OY6vavM5wlpuYceVirr/dZstFmFyC6LyYFG8phEXr/cpI
	nvZDXq9G7F3E2/v/opJoY40/0DOIj88=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=oe1NSfZ3;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198067;
	b=pER9o8V6Ln59RLJcgWiB5OXpJy9nBgDwaDzAFGkABySXatmmXt0Rtca59PDAPZgeE3JH+B
	PX6Iq47zRmj//7p1LvceaBTnc34qpLD5EWia4ML/ODKo5uBZE/nU3uxnn1tY6zDylabnuX
	nWBDqusgqdXt6VB2r33+iSe7pfcAIaU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PgiBt+cXBNmLBpECoGiXITUCwoLXcLuCPMDzB/akGTA=; b=oe1NSfZ3c+G4ykkyxz2q+gOtZc
	vb/b/uKDXQgCp0dGzusCJoNwZgPAvMdA6+W9CnUC2vTANwymVYxEikEDm0E7NWESmqd7U1zHNRIJt
	WEnFxbN4JAxpYxZPq4LqJyBWI7Py51m0JBZU3/obNvVx9QokJwHen0fd1Tkx/RX4PQFnFXF2vlX6+
	iuYed1t8EdabPHm93Am5IUmHZOOI7zJsMLhRTltgoa1GSF11TztSdTVUYCzoDb8mi+ENSaInlz2Pz
	jLSx8LWhX4/nK5zH619TKsnEL+LZG8BmcSLVsRYFLzLsalwXps9281pF/YhLN/v/qidNlQji87Emu
	n//s+QpA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz4-000000070nH-2ftQ;
	Thu, 11 Jun 2026 17:14:26 +0000
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
Subject: [PATCH v2 8/9] make thread component caches (fs_cachep, files_cachep, etc.) statically allocated
Date: Thu, 11 Jun 2026 18:14:23 +0100
Message-ID: <20260611171425.1671254-9-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171309.GN2636677@ZenIV>
 <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A3F0A40008
X-Stat-Signature: 41fey97qwsghqqm5u39xexcqonifbbxz
X-HE-Tag: 1781198067-606689
X-HE-Meta: U2FsdGVkX1+YKIQeK4Kl67GvKAZXUAowV8RhpnNydA7QJ3OmJLbBNd6OaP8OQ9JWqcLlWVFDPFQo+3T44JlOzRTi+AxcaaO+A8PtJW1WjlMbFa3bwldFF9h7xSvveQM6i4tFBe+7qlZ5kaql1Du97HQIrWy8Q7UNx8npJvMb5ZCe3YHOp+d/MbK28zKHPRYzg5mzPYJ/9tWLvHFEh4bSILGrY0mtazQmkWigjNpfX1xUb786m4LAUWw5p5RymzEa2lGdGCd+cqZCS5YtXKCo+72B7Cco7KuhaimKqHePwF262OyKOl9bBS4FvwmTG3ZmjvT2oGGML1miuSZ28Y4kq1zrAYUPpcxwJ6KILsWozpzZotd77+DDqD127q3G6qMExNrNQpXbo67PwUyMMYIVubimksop1ME3f/oxzC8T1p8TqPK6eQY6HR8kKkxxxn07g19I71Jtuo8BR5Wkfn9OUSHjfS/OdRO3yVwk/D72AEXL3ZPEiiufIhndF2Vm38vI2RtaFrqNxTOjv7WLCbbVxi2xoaJ72PUGPiHF0t07fp1lBY0ZpOX88YZkV4UA/KOc0r+wiUzRR8WEJebavm+wxQUONuf+kayNb+N5258GlzJwOzflM+S2v44r+Ed2tQAkl7CYoITX0CcaqJKYO2ryG6wrvusCRgOgfKBCp3fvXIDA0fIEh9KTm9yt2CDK76y3k5oGCOBfv3WGgvSeos/IOoigd6ZWNbdkFs9zBUEgOeVJWTtKEJi4BnOtMi9PiaM/cZEms9/E7ajCUtvrioW42MyiHPaiGGBLRDpVDs6QhP7kqLzy/AaPA/0k98UyAt6nq2b9qoY8Yjc344TDlrYlFyO5cPKHC/IJ69ZCCR7exHG9mAZRyLAz9/E3y2sJfOqxQLeYEaeItvO5KnYt7+DzOLUMzer6eZKAAAcQxirclvj/cvY/+AiuM4W+BT4e8aiPE5t3eWDU5f2/IHRS/Vx
 Uab9j9IL
 6eTBs8XCIGbwMaH+RQ/mWesW7OfKshSSyXjYccGjOkXfg7lp7X211GjxepqQbOuLHR8Fv2XvGHhTbaEJz8LNr42BG6uzm1vkdGf+tx9HXeLm1GmiV/PxKn5ODIz1WP/Ko7hqAmOsKXA9+c2TE/Mrw/w4v0/+oXchqNVS47cHRboR43+M5i12hSEoR71pkuX44GdnNL/IbFTK5EAsVNL5sar8rzvo7VTPiTwhyq4KfMY72+/NQXuYyBkuZHO7tLhjztxr2V5c068Sgx/i2bdoxbXNxd7enXtr2z7xiM8uaWdTthIkaMqOuKvvRKZXNEDLkeI03PE5xhMIyB9qipMxf3J58YDK8Kme60qLVbwR2LrGH4Ubu8PC6l2z/miNtoZRlnkwF3Pjoc7wcbCYLVF7z9KNiy2tDyQrGLXGkODAtK3cW7KHEni1ou24D2L1/c7rnkPqvvTYQiAUGQRzcBhgxezUw/dbAIbIMjRbLDx7ty0sjzbF9xyqZXiOEkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All of them are created in kernel/fork.c, might as well convert all
at once...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/fdtable.h   |  3 ++-
 include/linux/fs_struct.h |  3 ++-
 include/linux/signal.h    |  3 ++-
 kernel/fork.c             | 37 +++++++++++++++++++++----------------
 4 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index c45306a9f007..f2d553f99c58 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -113,6 +113,7 @@ int iterate_fd(struct files_struct *, unsigned,
 extern int close_fd(unsigned int fd);
 extern struct file *file_close_fd(unsigned int fd);
 
-extern struct kmem_cache *files_cachep;
+extern struct kmem_cache_opaque files_cache;
+#define files_cachep to_kmem_cache(&files_cache)
 
 #endif /* __LINUX_FDTABLE_H */
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 0070764b790a..e8c9fac5b7b7 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -15,7 +15,8 @@ struct fs_struct {
 	struct path root, pwd;
 } __randomize_layout;
 
-extern struct kmem_cache *fs_cachep;
+extern struct kmem_cache_opaque fs_struct_cache;
+#define fs_cachep to_kmem_cache(&fs_struct_cache)
 
 extern void exit_fs(struct task_struct *);
 extern void set_fs_root(struct fs_struct *, const struct path *);
diff --git a/include/linux/signal.h b/include/linux/signal.h
index f19816832f05..a0c7fee8b22a 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -323,7 +323,8 @@ static inline void disallow_signal(int sig)
 	kernel_sigaction(sig, SIG_IGN);
 }
 
-extern struct kmem_cache *sighand_cachep;
+extern struct kmem_cache_opaque sighand_cache;
+#define sighand_cachep to_kmem_cache(&sighand_cache)
 
 extern bool unhandled_signal(struct task_struct *tsk, int sig);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 8ac38beae360..618f19bb482a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -111,6 +111,7 @@
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/slab-static.h>
 
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
@@ -180,7 +181,8 @@ void __weak arch_release_task_struct(struct task_struct *tsk)
 {
 }
 
-static struct kmem_cache *task_struct_cachep;
+static struct kmem_cache_opaque task_struct_cache;
+#define task_struct_cachep to_kmem_cache(&task_struct_cache)
 
 static inline struct task_struct *alloc_task_struct_node(int node)
 {
@@ -425,7 +427,8 @@ static void free_thread_stack(struct task_struct *tsk)
 
 #else /* !(THREAD_SIZE >= PAGE_SIZE) */
 
-static struct kmem_cache *thread_stack_cache;
+static struct kmem_cache_opaque __thread_stack_cache;
+#define thread_stack_cache to_kmem_cache(&__thread_stack_cache)
 
 static void thread_stack_free_rcu(struct rcu_head *rh)
 {
@@ -456,29 +459,31 @@ static void free_thread_stack(struct task_struct *tsk)
 
 void thread_stack_cache_init(void)
 {
-	thread_stack_cache = kmem_cache_create_usercopy("thread_stack",
-					THREAD_SIZE, THREAD_SIZE, 0, 0,
+	kmem_cache_setup_usercopy(thread_stack_cache, "thread_stack",
+					THREAD_SIZE, THREAD_SIZE,
+					SLAB_PANIC, 0,
 					THREAD_SIZE, NULL);
-	BUG_ON(thread_stack_cache == NULL);
 }
 
 #endif /* THREAD_SIZE >= PAGE_SIZE */
 #endif /* CONFIG_VMAP_STACK */
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
-static struct kmem_cache *signal_cachep;
+static struct kmem_cache_opaque signal_cache;
+#define signal_cachep to_kmem_cache(&signal_cache)
 
 /* SLAB cache for sighand_struct structures (tsk->sighand) */
-struct kmem_cache *sighand_cachep;
+struct kmem_cache_opaque sighand_cache;
 
 /* SLAB cache for files_struct structures (tsk->files) */
-struct kmem_cache *files_cachep;
+struct kmem_cache_opaque files_cache;
 
 /* SLAB cache for fs_struct structures (tsk->fs) */
-struct kmem_cache *fs_cachep;
+struct kmem_cache_opaque fs_struct_cache;
 
 /* SLAB cache for mm_struct structures (tsk->mm) */
-static struct kmem_cache *mm_cachep;
+static struct kmem_cache_opaque mm_cache;
+#define mm_cachep to_kmem_cache(&mm_cache)
 
 static void account_kernel_stack(struct task_struct *tsk, int account)
 {
@@ -859,7 +864,7 @@ void __init fork_init(void)
 
 	/* create a slab on which task_structs can be allocated */
 	task_struct_whitelist(&useroffset, &usersize);
-	task_struct_cachep = kmem_cache_create_usercopy("task_struct",
+	kmem_cache_setup_usercopy(task_struct_cachep, "task_struct",
 			arch_task_struct_size, align,
 			SLAB_PANIC|SLAB_ACCOUNT,
 			useroffset, usersize, NULL);
@@ -3079,7 +3084,7 @@ void __init mm_cache_init(void)
 	 */
 	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size();
 
-	mm_cachep = kmem_cache_create_usercopy("mm_struct",
+	kmem_cache_setup_usercopy(mm_cachep, "mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			offsetof(struct mm_struct, saved_auxv),
@@ -3089,19 +3094,19 @@ void __init mm_cache_init(void)
 
 void __init proc_caches_init(void)
 {
-	sighand_cachep = kmem_cache_create("sighand_cache",
+	kmem_cache_setup(sighand_cachep, "sighand_cache",
 			sizeof(struct sighand_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TYPESAFE_BY_RCU|
 			SLAB_ACCOUNT, sighand_ctor);
-	signal_cachep = kmem_cache_create("signal_cache",
+	kmem_cache_setup(signal_cachep, "signal_cache",
 			sizeof(struct signal_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-	files_cachep = kmem_cache_create("files_cache",
+	kmem_cache_setup(files_cachep, "files_cache",
 			sizeof(struct files_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-	fs_cachep = kmem_cache_create("fs_cache",
+	kmem_cache_setup(fs_cachep, "fs_cache",
 			sizeof(struct fs_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-- 
2.47.3


