Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1482606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dGHVSIYi
Received: by kanga.kvack.org (Postfix)
	id 7924E6B081E; Wed, 21 Oct 2026 21:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747B66B081F; Wed, 21 Oct 2026 21:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632086B0820; Wed, 21 Oct 2026 21:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBAB6B081E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:57:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7BB0C1C4003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:51 +0000 (UTC)
X-FDA: 85348601142.26.4C72A16
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id B0A09C0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dGHVSIYi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2IDhZYwVj7b9i7gM+96EPBlHJzaHOSETwMh33ACHTQ=;
	b=7tDdYZfbe9kx1+OamuiRzhIHM9M3t0rB+oz5639RksE0Cpy8yrEbaFzpMvSjrtnogt/y95
	P79MUhcGZ8LCXh416Op5uskkdOHFVAKTqXRGzU4rtF5JKqk960vLjd+NYRp6prbJPzjFMH
	PmRGibg7N35e2oFmzvZhJyqZyCMmn0U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dGHVSIYi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634269;
	b=aljx4X+I9Vw6O0Z43l0T9L4H1WVIvhviVcSojcztQEgEAGi8shENmXwLUD2UoP/VnYLvwK
	XCC4/5oB0h60FxGSMft/k3qeljSAKR/s9S7SLaRP8f3WgL1huIbSwKhp+gacu7ueVFIJKX
	r64CF6p3/qzkGUtJ1JxmUKm8R+fkSAM=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a05e3f0d23so624841b3a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634269; x=1793239069; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t2IDhZYwVj7b9i7gM+96EPBlHJzaHOSETwMh33ACHTQ=;
        b=dGHVSIYiJzayMbiIcDngYn+UjW0CBnxdOFiIWrsa4DSgoECFSS6TtU8LRPzcZps7s4
         JYS8nCMz1I1sVlDvnzJBdFUYHUSdGGNuArzWa30kCki56+N+6PYwzkFAACUPlAp+6WdR
         mvTkHdfW+ZZ4q5ItTnym8SjtbgDwq3063Kbh3n/fyt0zncQ0zBBMF4Dzzvm5L/tDbt64
         OYS4JJ1r0D7zmL/PVAlivEXy9HbntXepa+/k/piGG96CpIbLfPkDDk3XBbGO7vTb45cK
         QRhNqfm8jvgXY+nXPDnlfEpmXNkTPlQ79Yl4EcCDHfeOtF3m52SeQDTZBRNPi7o+hPaQ
         611w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634269; x=1793239069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t2IDhZYwVj7b9i7gM+96EPBlHJzaHOSETwMh33ACHTQ=;
        b=tf654PwpjC7Rl8+do98zgTyQrtlUbyPBhNlUEVJFWu5TmHcbeMLmedjzk9/5ZdvNRG
         03TFdH92iJ9E/qDhZyusQtWPS0/TkPU/FrLjzb/e8i2nOjiLvOcFak58Ze/gewjVP4Gs
         ny+zcUNxyvYKKDxDW82MGZuSGujru3XritIbHniryumYTsKSS1T12ysFDrs/pXnEnM/6
         a9UUCqLRlfHDIIPwArLco3ZEbubsKrVFkzqeKqXMOTqbj1fTP1QvamAQvgFAnbOHSUi2
         eb1Q2JnJkad/ZvKIA0/JFMtIqe6CK57c+7daHrw9MyqqsjWsGUlYuODUiAK0ObnwbF4M
         OLiA==
X-Forwarded-Encrypted: i=1; AKwUvBzSnSeEqWO5nPkJourDP3A/ydHaGY/FSuYa2njV7vDvbwzCOnTEyJ4GzqgPQm1dAnUtZyw0zVwPug==@kvack.org
X-Gm-Message-State: AFq9FYLlKlKVlqq0T/phcFxJXUQLkuqWJ3xLm8bizr5yY3nFH3bP3gpW
	4KeDNU0v+9wjswp+pZRW0uMvua34c2U2Okvp6cSWoBg9GPR+/7o/v/RA
X-Gm-Gg: AYBFou18PgUV1dVKbDpQL3O1m9A2kEi7biAlUGLYikWFFtRRlE4FEkl0j0IrLoOLXoN
	wzku7U0466Q9fS2UT2mecQWlVjyKtjwJFk0CLNukVGGq8gae7evkAmSAEsCfy2elYM+O5PUnfFA
	/+u0syCw8w2w42u5sxbefffUQsK4+WxPCTyazZVOqqdrDNpFYOSGg613Xf0q3lpeYsv9KJdRddg
	pS6JscN24cGQg7Ehr+XiIPGuHj4dyccnqWK9xbz/RZ7m03BlpRvFbKunZDpO3yqGrW17CbcNUWp
	39Q+XONZW7QwXHGDq8EsL9wfxn2f6Wj+3I3VFgt56cvD2SWgECfjVcaXxvGpzOLWMqmklMBhwIr
	BY7mBK6KloUMU1S7O6FgmrgGBfb+UXoWGHVX4dapwc3/Mw+CiowbhlEbhaUIQ+X0zPYEXuQSutA
	EsAjBGY9Gvzo4VLc8HuJxIw8YkH1MRtr3PsL0hx6PVWCBZmcHs1MTYpScg/TmZ29T1iqrtsaP2P
	xEnH9Juj47vZP/uQs6X2AJDUiRevR0l4Z1ZbNBJ+T3Yhq1+7EQKxGW00loTzJaWWcP4IUt2K7Pk
	WiZis0Xab0p6eOpGz/KtFVIhdtlNczRW0zG5DcYCw7JYGiMQP0U/gqb2vwxmy6GPuIyzJ7IDOHG
	njKUsklChpULJV3itnA4V/TbN
X-Received: by 2002:a05:6a20:b096:b0:3e2:200b:dc25 with SMTP id adf61e73a8af0-3e287d875c5mr2712316637.30.1792634268485;
        Wed, 21 Oct 2026 18:57:48 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895d8e49sm1408036b3a.33.2026.10.21.18.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:57:47 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	oleg@redhat.com,
	peterz@infradead.org,
	mhiramat@kernel.org,
	jolsa@kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	surenb@google.com,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	hughd@google.com,
	kees@kernel.org,
	mingo@redhat.com,
	tglx@kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 5/9] uprobes: Don't sleep on mmap_lock under dup_mmap_sem
Date: Thu, 22 Oct 2026 01:57:08 +0000
Message-ID: <20261022015712.1297331-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0A09C0009
X-Stat-Signature: 34iygyh75nyetw8aobh7ienjd451g4sm
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792634269-790912
X-HE-Meta: U2FsdGVkX198Il5SkZSNxTAjft6Jn6p9v2V54qovyMJiWwcYAubd1orKrIZhuQdGX6j34d+FeXrRHl1M7in5m1V1g2WbTi0P+AXoPbSgH7QULgoqjTqCID5B9WToHk2JzaNArj3guXhCZ6sCQ7zI+d2TeWD7A4mUxvbBhrqUCmOYTRNOUS/JtqNjW6NKYgQcMr1krAA7aFStwhPHoFKOQBmmidF6ymIkVxq2k4v1tQ/Q+q/wVRVCW5SocvWMkfI5eQObAjcjRPSIBdMZGpPmZoNccQZkbuRQwPU7/e1Z/3gNUy8t0kL98UZB06Ch9CoEI2loTpN4Ja6VaBGtsdgdPu02EmGVYaywcxXpTlC/dSWgF5yFHEUf9UxzZWs/j7w1oA4EfmLu30v5U1tfJ0Lf+rUGu+VMGioe5svvDtqtF3AEMFdQfG+/xjkgysBlRFMkMwycKR6Ko8lPdaxy6PZOg8/6jlmG67qVw4Rk8U2Uze1kootnAV+N5CRUCZ9jWSrIlM5rscy/iRPLCfAChbFkUkPyWQlhSyTTMoGHJbuv6GuIgWLVEN0uNLTLBkWfIbHEO35AyV8dmWGkiVJ4fh0+NPfYk13HrteURDA25XJenz25p2UZnKCD1IJMVWb7q1TAlB5gutXdQpOpyeOrc03aJzIsJ0OsiVpFbMr1smlOpyoq6mHYJFhPXQy2lDdtGeLRYEaSGlRhJxOhAvOydkpaP7iQqkZcDuWOZaxK6Mx3bjty+Agbo2aLa1iG+HPmy9F+fXwRMKCraWiaTT7enNfETibNo+2KBhVu5QHm+mKOF/1wKYJFDAmLF6fwpEI6VT04Hs56VZ5cs+bnX9cYwYZNj2DAlFWe7UrmstZhTxhUfLLDI2YOXL7PjWE2oMS0W5GABe1rjbIH/8dvcdrvWa1cEX7wT1al/ZD7iVdDf1Uo552GNv5RlRMRp2UJA5I2Rga3eXum1hJ9eWBNPCwovVO
 LogeCSq+
 dPFZ6SFC5XssmiYoRoYk04pzV0BONMWYO0tr6ttcKvpz1QWOUp+XgBc/NyIUryshR17bZHykr8mqQL6jiiHQoyzjrjw5EWDpAhZN2NOMgs7oCWgrz/jlwJxjRn02953lWrlGAvtr1sEOlhjLrG50ky9AW/JV/hIvusmX5x0LL/tNmSOv3KXqocRz0HggSGdC97BP6tu9JYCtntTR8YgaGFzHyMkaq3OizKnspmLkUIj+mBxm3DDTpkXRqOnEDwO9a8Le5qMw51YfiDHqpQweYjc/sX3/SF9TNrR8gAp3qMv4DhLASyYumcvTdLHxqa/+HzrK0eh9Km7F3EBeOihMfCaDa8u+IQsCKGBTBEBTmm3kLLRAgDDAdeztqieoSnDOQ/AI0yw3P8FDg69kl6UDU/sP8ixwSPaWlvQASTsQyV0Ca6f/A8M6BXturW3A8lm7XhnUMyQbjd2bqKqGsMJINbAhz3acFm1XFBecqAzp6A9Jc1f8Re6wQb2DOvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

register_for_each_vma() takes dup_mmap_sem for writing, collects mms that
map the file and takes mmap_lock of every mm. fork() takes dup_mmap_sem for
reading. When mmap_lock of one mm is busy every fork() in the system waits
for it:

  A:       mmap(MAP_POPULATE) -> mmap_read_lock(A)
  tracer:  percpu_down_write(&dup_mmap_sem), mmap_write_lock(A) sleeps
  others:  fork() -> percpu_down_read(&dup_mmap_sem) sleeps

Only trylock mmap_lock under dup_mmap_sem. Leave mms with busy mmap_lock in
the list, drop dup_mmap_sem and then wait for them.

dup_mmap_sem makes sure that mm doesn't fork between build_map_info() and
install_breakpoint() or remove_breakpoint(). Otherwise the child misses
the breakpoint, or inherits the breakpoint of uprobe that is gone and gets
SIGTRAP. Now mm in the list can fork. dup_mmap() holds mmap_lock of
the parent, so uprobe_dup_mmap() does what the walk is going to do to this
mm before vmas are copied. The walk sees info->done and skips it.

The error in uprobe_dup_mmap() is the error of the walk, unless fork() is
being killed. Such fork() fails in copy_process() and there is no child, so
leave mm to the walk. With ref_ctr_offset the walk can update the counter
twice in this case.

dup_mmap_sem protects the list of walks. mm in the list is kept by
mm_count. The walk takes mm_users only for the visit, so the process that
exits meanwhile frees its memory.

Busy mms are visited last. The tracer that is killed while it waits for one
of them has installed the breakpoint in all other mms and cannot remove it.
"uprobes: Don't leak the breakpoints if the unregistering task is killed"
fixes that.

Process A loops over mmap(4G, MAP_POPULATE) and munmap(). A and 10 idle
processes map the file. Process B calls fork() in a loop. 32 cpu VM.
Median (max) of 15-25 runs, msec:

                         the longest fork() in B    attach
                         before      after          before  after
 uprobe_multi, 1 uprobe  197 (209)   0.33 (0.70)       210    233
 uprobe_multi, 4 uprobes 421 (429)   0.38 (0.60)      1467   1532
 perf_event, 4 uprobes   422 (439)   0.43 (0.59)      3135   3289

During detach: 264-423 -> 0.35-0.47. Attach and detach still wait for
mmap_lock of A. B doesn't.

The tracer pays when traced processes fork all the time. mm that forks
holds its mmap_lock, so the walk sleeps on many mms in turn. Fork storms of
1200, 2000 and 5000 processes, 6 cpu VM, msec, without and with the series:

 enable uprobe event    105 -> 205   201 -> 481   207 -> 784
 disable uprobe event   225 -> 294   354 -> 579   407 -> 893

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/events/uprobes.c | 178 ++++++++++++++++++++++++++++++++--------
 1 file changed, 143 insertions(+), 35 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6792004be6fa..a9274016c55d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1192,8 +1192,29 @@ struct map_info {
 	struct map_info *next;
 	struct mm_struct *mm;
 	unsigned long vaddr;
+	bool done;
 };
 
+/*
+ * Every fork() waits for dup_mmap_sem, so register_for_each_vma() must not
+ * sleep on mmap_lock while it holds dup_mmap_sem. It leaves mms with busy
+ * mmap_lock in ->busy, drops dup_mmap_sem, and only then waits for them.
+ *
+ * Such mm can fork before its turn comes. dup_mmap() holds its mmap_lock, so
+ * uprobe_dup_mmap() does what the walk is going to do to this mm, and
+ * the child has the same breakpoints as the child of mm that wasn't busy.
+ */
+struct uprobe_walk {
+	struct list_head list;
+	struct uprobe *uprobe;
+	struct uprobe_consumer *new;
+	struct map_info *busy;
+	int err;
+};
+
+/* dup_mmap_sem protects the list and ->busy of every walk in it */
+static LIST_HEAD(uprobe_walks);
+
 static inline struct map_info *free_map_info(struct map_info *info)
 {
 	struct map_info *next = info->next;
@@ -1242,6 +1263,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 
 		info->mm = vma->vm_mm;
 		info->vaddr = offset_to_vaddr(vma, offset);
+		info->done = false;
 	}
 	i_mmap_unlock_read(mapping);
 
@@ -1271,26 +1293,79 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 	return curr;
 }
 
-static int
-register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
+/*
+ * mmap_lock of info->mm is held for writing. info->done is set under it.
+ * The walk also tests it without mmap_lock, to skip mm.
+ */
+static void register_one_mm(struct uprobe_walk *walk, struct map_info *info,
+			    bool in_fork)
 {
+	struct uprobe_consumer *new = walk->new;
+	struct uprobe *uprobe = walk->uprobe;
+	struct mm_struct *mm = info->mm;
+	struct vm_area_struct *vma;
 	bool is_register = !!new;
-	struct map_info *info;
 	int err = 0;
 
+	if (info->done)
+		return;
+
+	if (is_register && READ_ONCE(walk->err))
+		goto done;
+
+	if (check_stable_address_space(mm))
+		goto done;
+
+	vma = find_vma(mm, info->vaddr);
+	if (!vma || !valid_vma(vma, is_register) ||
+	    file_inode(vma->vm_file) != uprobe->inode)
+		goto done;
+
+	if (vma->vm_start > info->vaddr ||
+	    vaddr_to_offset(vma, info->vaddr) != uprobe->offset)
+		goto done;
+
+	if (is_register) {
+		/* consult only the "caller", new consumer. */
+		if (consumer_filter(new, mm))
+			err = install_breakpoint(uprobe, vma, info->vaddr);
+	} else if (mm_flags_test(MMF_HAS_UPROBES, mm)) {
+		if (!filter_chain(uprobe, mm))
+			err = remove_breakpoint(uprobe, vma, info->vaddr);
+	}
+
+	if (err) {
+		/*
+		 * fork() was killed meanwhile. This is not the error of
+		 * the walk. See uprobe_dup_mmap().
+		 */
+		if (in_fork && fatal_signal_pending(current))
+			return;
+		WRITE_ONCE(walk->err, err);
+	}
+ done:
+	WRITE_ONCE(info->done, true);
+}
+
+static int
+register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
+{
+	struct uprobe_walk walk = { .uprobe = uprobe, .new = new };
+	struct map_info *info, *next;
+
 	percpu_down_write(&dup_mmap_sem);
-	info = build_map_info(uprobe->inode->i_mapping,
-					uprobe->offset, is_register);
+	info = build_map_info(uprobe->inode->i_mapping, uprobe->offset, !!new);
 	if (IS_ERR(info)) {
-		err = PTR_ERR(info);
-		goto out;
+		percpu_up_write(&dup_mmap_sem);
+		return PTR_ERR(info);
 	}
 
-	while (info) {
+	for (; info; info = next) {
 		struct mm_struct *mm = info->mm;
-		struct vm_area_struct *vma;
 
-		if (err && is_register)
+		next = info->next;
+		/* If install failed the caller is going to undo it */
+		if (new && walk.err)
 			goto free;
 		/*
 		 * We take mmap_lock for writing to avoid the race with
@@ -1299,38 +1374,56 @@ register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
 		 * is_trap_at_addr() true right after find_uprobe_rcu()
 		 * returns NULL in find_active_uprobe_rcu().
 		 */
-		mmap_write_lock(mm);
-		if (check_stable_address_space(mm))
-			goto unlock;
-
-		vma = find_vma(mm, info->vaddr);
-		if (!vma || !valid_vma(vma, is_register) ||
-		    file_inode(vma->vm_file) != uprobe->inode)
-			goto unlock;
-
-		if (vma->vm_start > info->vaddr ||
-		    vaddr_to_offset(vma, info->vaddr) != uprobe->offset)
-			goto unlock;
-
-		if (is_register) {
-			/* consult only the "caller", new consumer. */
-			if (consumer_filter(new, mm))
-				err = install_breakpoint(uprobe, vma, info->vaddr);
-		} else if (mm_flags_test(MMF_HAS_UPROBES, mm)) {
-			if (!filter_chain(uprobe, mm))
-				err |= remove_breakpoint(uprobe, vma, info->vaddr);
+		if (!mmap_write_trylock(mm)) {
+			/*
+			 * uprobe_dup_mmap() compares info->mm until list_del().
+			 * Keep mm_struct, but not the memory of the process.
+			 */
+			mmgrab(mm);
+			mmput_async(mm);
+			info->next = walk.busy;
+			walk.busy = info;
+			continue;
 		}
-
- unlock:
+		register_one_mm(&walk, info, false);
 		mmap_write_unlock(mm);
  free:
 		/* exit_mmap() of the last user must not run under dup_mmap_sem */
 		mmput_async(mm);
-		info = free_map_info(info);
+		kfree(info);
 	}
- out:
+
+	if (!walk.busy) {
+		percpu_up_write(&dup_mmap_sem);
+		return walk.err;
+	}
+
+	list_add(&walk.list, &uprobe_walks);
 	percpu_up_write(&dup_mmap_sem);
-	return err;
+
+	for (info = walk.busy; info; info = info->next) {
+		struct mm_struct *mm = info->mm;
+
+		/* Don't wait for mm if its fork() did it or if install failed */
+		if (READ_ONCE(info->done) || (new && READ_ONCE(walk.err)))
+			continue;
+		/* All users are gone, like in build_map_info() */
+		if (!mmget_not_zero(mm))
+			continue;
+		mmap_write_lock(mm);
+		register_one_mm(&walk, info, false);
+		mmap_write_unlock(mm);
+		mmput(mm);
+	}
+
+	percpu_down_write(&dup_mmap_sem);
+	list_del(&walk.list);
+	percpu_up_write(&dup_mmap_sem);
+
+	for (info = walk.busy; info; info = free_map_info(info))
+		mmdrop(info->mm);
+
+	return walk.err;
 }
 
 /**
@@ -1841,6 +1934,21 @@ void uprobe_end_dup_mmap(void)
 
 void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
+	struct uprobe_walk *walk;
+	struct map_info *info;
+
+	list_for_each_entry(walk, &uprobe_walks, list) {
+		/*
+		 * fork() that is being killed fails in copy_process().
+		 * There will be no child. Leave oldmm to the walk.
+		 */
+		if (fatal_signal_pending(current))
+			break;
+		for (info = walk->busy; info; info = info->next)
+			if (info->mm == oldmm)
+				register_one_mm(walk, info, true);
+	}
+
 	if (mm_flags_test(MMF_HAS_UPROBES, oldmm)) {
 		mm_flags_set(MMF_HAS_UPROBES, newmm);
 		/* unconditionally, dup_mmap() skips VM_DONTCOPY vmas */
-- 
2.55.0


