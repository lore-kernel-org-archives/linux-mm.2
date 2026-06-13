Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0259ACD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4866B0098; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158496B009E; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA456B009B; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8F16B0096
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D057B140301
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.29.2E1F312
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0E9A9A0002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hHPcAiXH;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=pGwbujPROHj2IPcC0gZrceFT4P51ImpyBRkqej8dnXT4jQ9tBLssSyKSvbbI0ORzFt/N8s
	bCTLT4Ds/Ro7DunNNoVRJrfcJJW3yjJ7DM9jBUitBd4Sffw8jkLLBo0yOZIwQ8scaS3/Bs
	Xl4Rz8R7QyS7sALSw4r2mi1iP/Z8WQM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hHPcAiXH;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgiBt+cXBNmLBpECoGiXITUCwoLXcLuCPMDzB/akGTA=;
	b=TnolZJolsLLg71sr3tnhFkEnS2VbYz6yIAdh6g9gRpXUAujJGFIUcQz/60YPNTJZ9b+9UI
	wB6uTQV3gcFoSsAgoeOxZSkp8SJuahxgu/XceIhSaJxT4PXwamRHYUrb6m4M0Ew5BJJ6U9
	nZZ3msBIfzPyg1Sr3eQQt8bgYwDpbKM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PgiBt+cXBNmLBpECoGiXITUCwoLXcLuCPMDzB/akGTA=; b=hHPcAiXHeVgaLLjvjpBxpyNC9E
	UYDBnBCLcLqoQpAPYS2U0r1DopzNQ6/LZZLMighTBBsdiawe0464cTBafMwSbIAQrm8ojuf1BAyWe
	u4gYy6sHmrIvCJwAoYUc56plrHPz6uTganRPD/ea7hlrL4jkoQsKcuCEM/4jyFt1ZGbaysrSldL/I
	bcxgROxabuXlNsbtuqdGyyUqtCk/Q5vmRDhGg9OjzUSeNoc1HTQgKoBDXUyWsDL5bHuiLGgUh6bvh
	XybQJJKZzMEhMYEdfc+uhGukV04XBprjV0mCl5d+stZ3sph6piCHfmCG6vxex96B6vargi4PvCLrf
	aI7/BtpA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcz-00000003aTT-1lVP;
	Sat, 13 Jun 2026 05:09:53 +0000
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
Subject: [RFC PATCH v3 09/10] make thread component caches (fs_cachep, files_cachep, etc.) statically allocated
Date: Sat, 13 Jun 2026 06:09:50 +0100
Message-ID: <20260613050951.855141-10-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E9A9A0002
X-Stat-Signature: uojptcgczmq9r1j6b31us8rxa75zw7tw
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781327396-603171
X-HE-Meta: U2FsdGVkX1+uCK5Bq0f7BWTnS2W5/WDcVaiW+/Xl1SJmIT0m2V8mB0QN8A0iteQcxw4uOFopyajajFpTMYfWRGgHMrUg7UmVe9rZvDOaLb4mACKBGhunMTAm3YIYBlQ2rseZE7FwiB+OsruL14nfn+upPlppXejcKRPCCR/fueuu5f2AlJwG+eqTEwae7OAgG4mc5yYrb9zOxfzGInhbke6fEkhGaaqXMVA+WO5vP0JEhypOJo3c31HQrS5XHpzM0nyZBNwl6HxKaTWYovGlZWYjE/sVF6XzElsvu2clnj2Cj/9q4CQajj60bBPCpagM8eCNzLIPyKWiKXHjzZdCgWiMjthCBO7pZHBDPqghZRg7csuxhJHu3QLPl91KQXXge+04atxAMJcRPn34GerNUgbTsVoWLqdPNBdt3bv6dqK1I6pL4oAfae/n+TNs7kn/VqUJIPafY6zWgYoUgsN7oMDEqfd+eyJrNG20Cz7hGPqel7pjAQ9HpJM2L1kbzilsF2jsCJaMVgmSvZZTae9NHtX636MXR7xk9dDWP0JyWmcrOfuusri9TEzVc/qlyAIqiEDpVTmIbzuEusQF5aedlTbY3MmyLA3AhEaXymoeHu0UH53vlysMbKyfmgohQ3jKKFgZDIJEDVdHMzrW3Af0ipVDLvfKe7ids7NGriNTUYYbRbyax61OTkuFZ4bE3zEyfW4/yiNi/0LDqhL6rN5g348jDZgww6eefYPLceGPT0YyLDAUWKdKebkoYoq614x37VOuUuckwhP4MXUVn0op2kPv34BsiUxPqc0tKZZHU3RrP7DHZcv4iiQi8Fod2xgk71vSOLNxXzUBrYDIbFbY9/H/sq6CgUK5Bhg6q6GJTjAovjkRosKL2wgbLvhdN1ZB0xjukih9yCoZWBAIOPOK5xjvpVvhf2bom7NrYDV1nMzkok2t1VVZdiW7wz8tuKrR0/LrkaSgp2H4sNWCnci
 3JpiMc3H
 uNZ0mqnZ/4PS6jVf3w+QNMaexRU8QLVwrn5cu5OjRuC+5PlNMSVCrVSfCGhDGAHPtNkSr1bHuxKNHcl3PZNjqKndyHoEnUXfvohKkHBeeyG6/Xqv4RjwS0WRukVQC0slGhb84ZuuhRuzP/UgBhAsIlYk0FUOdTWlM83zWjsUn6+R5Jknv0jzuStFTNePddptuMMn5Luew2hQe74OZedriW7RT9HOvQ5LnQsJthPkKyvy1hCNSBYxhtnFV51KUjo8rlQpx4/RZIAuu5CQwn4ux5BzVuPsVCZ7bfQqOaVP42Iw1HDfeWLF7J9eQ+KJE0hnMtAo7W/egJr0LYSPF3jXD4dkwZW3fwcze07xmt97RWRThLUk9Cpq004cdhB3BPcHRaURH32SHyxg/32TeuMzTtl86Ge68S6A29G/3i8Qbl/rv9t6eX+02gOp1aXgw27M+x5F6dL2VyiqfSWW1yr0a/Ua1RPB2a02hKZE3XyHopsFsbYHVPM5EnDHY4g==
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


