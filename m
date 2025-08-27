Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89AD6CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7406B0022; Wed, 27 Aug 2025 16:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CF96B0025; Wed, 27 Aug 2025 16:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2776B0026; Wed, 27 Aug 2025 16:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 688C16B0022
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:24:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D848713A1EC
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:24:24 +0000 (UTC)
X-FDA: 83823664848.07.FB8C4A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 377FF120011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:24:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X5TEmnBa;
	spf=pass (imf29.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756326263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=uxA5rtE9iUQ2IEdNj2X1U/IrYL9E89PVv6PkpEsBUvA=;
	b=8NEn0a2pvx62Z+Havbw9wrS692Ue5ZI05wFRd5EmTYQq+xrk/GU/GQ2rEcjGJeFdbOowmd
	za6BcVadwgAOn9KpqJasMLFC2zl/B+ioPGRCt79932hq4R5lKWtoo5JDV6XvzQxOOidJm/
	PGX881aETGIc/44Xg6d7eGfXIOohWus=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X5TEmnBa;
	spf=pass (imf29.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756326263; a=rsa-sha256;
	cv=none;
	b=X4AeGOe73Jqvb1dGBgjBrDXvOMLdBuQkUVpeJTTKdpHiGYXUhV3GBZdBTEIk243hY/GbMt
	+u4Gc4PZsNyjJ4dpytT7cF8tP92vI7fjW9AWhK40P5sbm6RguHDCsQjyoVuDDbwLI+Fg4A
	ToFDvBJCmo3Jh7tFSGPf/7rTQO6zBSs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F13B044CA4;
	Wed, 27 Aug 2025 20:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F55C113CF;
	Wed, 27 Aug 2025 20:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756326261;
	bh=x3ujmxrXMW5vw5xWUC2Eexk5U5sWoGVjWxdi+GniSVQ=;
	h=Date:From:To:Cc:Subject:References:From;
	b=X5TEmnBa6/c0aYRdnRFaXv4CN7wcrdPF2ul2DVzN+Lzph6FxSrT83DZ/qV09PlM7o
	 GyFOP2dQ7eUMTsr72ncVBQGlGplCVW5utxNqOeyhL8zntJP7oE/HOET+rrdPpCOiyf
	 3ZWI/9QExnUC7OQdhvMv4nUPe0bgP4nU9Pc8xQq3lWfLdEnBIb9FhuJg/3TniUtiRF
	 JZVunGKr8zzwg7mnLvUXfYS8Tf6dXdJ5dUoCzIzr+iRjUlAxPeVIyzOvqgxDg0UFK0
	 3HySaAjtGi7TQRTCoCORlMONz9iN5pFryQBgTyr4rYCH8RHIeBjvtzGhfvaJymiGds
	 eyqEe1l+agWyw==
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@kernel.org>)
	id 1urMhE-00000003kws-2TbJ;
	Wed, 27 Aug 2025 16:24:40 -0400
Message-ID: <20250827202440.444464744@kernel.org>
User-Agent: quilt/0.68
Date: Wed, 27 Aug 2025 16:15:50 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org,
 x86@kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Andrii Nakryiko <andrii@kernel.org>,
 Indu Bhagat <indu.bhagat@oracle.com>,
 "Jose E. Marchesi" <jemarch@gnu.org>,
 Beau Belgrave <beaub@linux.microsoft.com>,
 Jens Remus <jremus@linux.ibm.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Florian Weimer <fweimer@redhat.com>,
 Sam James <sam@gentoo.org>,
 Kees Cook <kees@kernel.org>,
 "Carlos O'Donell" <codonell@redhat.com>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
Subject: [PATCH v10 02/11] unwind_user/sframe: Store sframe section data in per-mm maple tree
References: <20250827201548.448472904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 377FF120011
X-Stat-Signature: s13d68pgmkoxb8kh7q3yf4ab6ruw7dsn
X-Rspam-User: 
X-HE-Tag: 1756326263-534295
X-HE-Meta: U2FsdGVkX1/m1TxrBorVSC3SW8M3pSqNE4U0rp3zaZ/KpTDN1bxwz9NC84GR6abSNwJGUTtMMnMmjWa3NhX/b6sdto63iiaxrXbWhS5Wq35jMojustKXYfBkhOl78H81gEJzmDW7cZqrdBnWrLV3Zk+AxYjXvqdJyDGoJgf75aPLb4MIalujwgtPYpNKxN/NBVfUM65Pb6fY/D7gVp3UKXF8lYc/UYA8hKKr9V1XD2aVFJe20el73SPBUQGZMBp0d/KJT7jgsnFHMwQt1AW9+PTssb43sFVa31HkAp65eEm0czYQr/EwTXuRD6YNgvJSYwKCoROxAJZFE7olzHAnNwRhiOlL4D4IY2CXib2mrym6LJ4RI5esj6xjiNA8KEazxKlBWHDYToWwtArCVEhSkFtK0puMrmBfpNW+pzo+jJ0VAsfpTb21sy3t31rVHhBjJFTBUvghJ77w7lsJHrdvUD3stxzRsLb6AWCJLATjdakepfbMNE2DXYPNcAX7fktbEyB8ycwa2G8lUQoz/FauLg+J9ZC2cvPqTgWXQmIGEO5kPV9jFSauWIfDFmOv5mJIQTDDfHxI5pG9p+IatN8hZHATnimb1RI6VWqRwD0uDkj8rTbscblTrJ6xwGIzktU1LZDkY/EauttZZbiAkQVNBm6QKkEvAP9WJejPS9dG/nvNH+tqerUux6DsjqfAdECZ0LoMCfIRY0krDMCMA8uB/6AmQpFMp/KBi9JJBpBD+iggEpR08+YJDOoW8sonl8hJ+oNktZVjzJ6E3Sy31VcvWr3mEP63gK9lHhDrhoZIlkpj3sxFem4XBDNR00XS7c3JgKFirP79BH7ojqyPFWQJae6WksQfiN09K3qec5BYsjkU1Rkk4IqTyNuDu3573e2PeRDYj6MN4DRWCN4o3B2Ej02JjT2BhwcG/ohAL/QSqrX8a5AHuwFIiFPmZ0cvuuENUUuPM/VKqZL20KukqtW
 U1S3WoEm
 Hp+2KlSdiNm54Tgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Associate an sframe section with its mm by adding it to a per-mm maple
tree which is indexed by the corresponding text address range.  A single
sframe section can be associated with multiple text ranges.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: x86@kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 arch/x86/include/asm/mmu.h |  2 +-
 include/linux/mm_types.h   |  3 +++
 include/linux/sframe.h     | 13 +++++++++
 kernel/fork.c              | 10 +++++++
 kernel/unwind/sframe.c     | 55 +++++++++++++++++++++++++++++++++++---
 mm/init-mm.c               |  2 ++
 6 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 0fe9c569d171..227a32899a59 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -87,7 +87,7 @@ typedef struct {
 	.context = {							\
 		.ctx_id = 1,						\
 		.lock = __MUTEX_INITIALIZER(mm.context.lock),		\
-	}
+	},
 
 void leave_mm(void);
 #define leave_mm leave_mm
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 08bc2442db93..31fbd6663047 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1210,6 +1210,9 @@ struct mm_struct {
 #ifdef CONFIG_MM_ID
 		mm_id_t mm_id;
 #endif /* CONFIG_MM_ID */
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+		struct maple_tree sframe_mt;
+#endif
 	} __randomize_layout;
 
 	/*
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 0584f661f698..73bf6f0b30c2 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -22,18 +22,31 @@ struct sframe_section {
 	signed char	fp_off;
 };
 
+#define INIT_MM_SFRAME .sframe_mt = MTREE_INIT(sframe_mt, 0),
+extern void sframe_free_mm(struct mm_struct *mm);
+
 extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 			      unsigned long text_start, unsigned long text_end);
 extern int sframe_remove_section(unsigned long sframe_addr);
 
+static inline bool current_has_sframe(void)
+{
+	struct mm_struct *mm = current->mm;
+
+	return mm && !mtree_empty(&mm->sframe_mt);
+}
+
 #else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
 
+#define INIT_MM_SFRAME
+static inline void sframe_free_mm(struct mm_struct *mm) {}
 static inline int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 				     unsigned long text_start, unsigned long text_end)
 {
 	return -ENOSYS;
 }
 static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
+static inline bool current_has_sframe(void) { return false; }
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
 
diff --git a/kernel/fork.c b/kernel/fork.c
index af673856499d..496781b389bc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -106,6 +106,7 @@
 #include <linux/pidfs.h>
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
+#include <linux/sframe.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -690,6 +691,7 @@ void __mmdrop(struct mm_struct *mm)
 	mm_destroy_cid(mm);
 	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
 	futex_hash_free(mm);
+	sframe_free_mm(mm);
 
 	free_mm(mm);
 }
@@ -1027,6 +1029,13 @@ static void mmap_init_lock(struct mm_struct *mm)
 #endif
 }
 
+static void mm_init_sframe(struct mm_struct *mm)
+{
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+	mt_init(&mm->sframe_mt);
+#endif
+}
+
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	struct user_namespace *user_ns)
 {
@@ -1055,6 +1064,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	mm_init_sframe(mm);
 	hugetlb_count_init(mm);
 
 	if (current->mm) {
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 20287f795b36..fa7d87ffd00a 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -122,15 +122,64 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	if (ret)
 		goto err_free;
 
-	/* TODO nowhere to store it yet - just free it and return an error */
-	ret = -ENOSYS;
+	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
+	if (ret) {
+		dbg("mtree_insert_range failed: text=%lx-%lx\n",
+		    sec->text_start, sec->text_end);
+		goto err_free;
+	}
+
+	return 0;
 
 err_free:
 	free_section(sec);
 	return ret;
 }
 
+static int __sframe_remove_section(struct mm_struct *mm,
+				   struct sframe_section *sec)
+{
+	if (!mtree_erase(&mm->sframe_mt, sec->text_start)) {
+		dbg("mtree_erase failed: text=%lx\n", sec->text_start);
+		return -EINVAL;
+	}
+
+	free_section(sec);
+
+	return 0;
+}
+
 int sframe_remove_section(unsigned long sframe_start)
 {
-	return -ENOSYS;
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	unsigned long index = 0;
+	bool found = false;
+	int ret = 0;
+
+	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX) {
+		if (sec->sframe_start == sframe_start) {
+			found = true;
+			ret |= __sframe_remove_section(mm, sec);
+		}
+	}
+
+	if (!found || ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+void sframe_free_mm(struct mm_struct *mm)
+{
+	struct sframe_section *sec;
+	unsigned long index = 0;
+
+	if (!mm)
+		return;
+
+	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX)
+		free_section(sec);
+
+	mtree_destroy(&mm->sframe_mt);
 }
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 4600e7605cab..b32fcf167cc2 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -11,6 +11,7 @@
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
 #include <linux/iommu.h>
+#include <linux/sframe.h>
 #include <asm/mmu.h>
 
 #ifndef INIT_MM_CONTEXT
@@ -46,6 +47,7 @@ struct mm_struct init_mm = {
 	.user_ns	= &init_user_ns,
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
+	INIT_MM_SFRAME
 };
 
 void setup_initial_init_mm(void *start_code, void *end_code,
-- 
2.50.1



