Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7293F60A381E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mZByVa8g
Received: by kanga.kvack.org (Postfix)
	id 57D476B05B5; Mon, 26 Oct 2026 17:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E646B05B6; Mon, 26 Oct 2026 17:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4443F6B05B7; Mon, 26 Oct 2026 17:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 008AD6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74A251C41DE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:53 +0000 (UTC)
X-FDA: 85366127826.16.5234991
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf18.hostedemail.com (Postfix) with ESMTP id B1B7D1C0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mZByVa8g;
	spf=pass (imf18.hostedemail.com: domain of 3ssvfagoKCCcMWKRXJKWRQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jthoughton.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3ssvfagoKCCcMWKRXJKWRQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051571;
	b=2fEHS3paMk+Lh9l6TDgIyqEWxvp5YmhntqApaWlVgVIP95gHJgta+g59FCG0NVMNSjeez5
	HSn1/XcHDsSJKPY8RzcpYjNTuw9R1u39JKwKj+VsZBTLFM30Wmer2fFSSpGWZzHr06nDx1
	FRuuuMZ5Z8izt3ERuCIDXERMI5mz64Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mZByVa8g;
	spf=pass (imf18.hostedemail.com: domain of 3ssvfagoKCCcMWKRXJKWRQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jthoughton.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3ssvfagoKCCcMWKRXJKWRQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oogWXdI71uSApWoisQtM4clnwhLv0Vs2bmtqChsuYec=;
	b=1QTUW3fq6x17+/XMtkIOZfdQuQo+/QlfnrwYBnA5iCP1uy0BGZ5SXvbn1x4F70hKYg+z+W
	W3xsuWmk0v49RTnyGZZyiNNMtjy4soXV+hWzJDjiWOJWRGLLJvXaqscvK5LV0iufCi9lh8
	DTs8FZzDJ5QTicCsPbPUIdbKIIkV8Wg=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd3b9e70f88so4489079a12.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051570; x=1793656370; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oogWXdI71uSApWoisQtM4clnwhLv0Vs2bmtqChsuYec=;
        b=mZByVa8gOwOqd9QRllpLsziXL7QkV8qNP+2pji1R5W7nBOCbSrc74xTHnJ9k0GaRx/
         ygFKv+wirwpNZSDuceFp6+n6N1OHHGLhWKOnPWBbtHhTTjMFrEunoInjnUR4X5EBLCFn
         UcI7cWY2AuAO3Ctba36rAs/vqhAjYObLBwba+/5ut1CLkkLqYcESRq77MwTXVLNOiPn/
         00lQWr4qumuiEQ3VFMKVqFHTr2nA1N4Cm69HqY2ciQ4AIOFHRUnsqmeck4PFgfyGDjwc
         MB9rLIDhYoS44LKY+hk+d+uS2OexD9LQU1bj8+scS7A/3PcXQ7Is/P37dAzzsfmJIQxJ
         GPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051570; x=1793656370;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oogWXdI71uSApWoisQtM4clnwhLv0Vs2bmtqChsuYec=;
        b=nOens4PrW/60Ac3/gFNr72PeKGikOWVCnknqzbbojCtJ6e3qldvH+rKTHz71EeTXGB
         vsgnM3SNYUvzAIAwu+1UM+bwrh3ve+muveWruJ2MQ+pqfp1WAS2W6MDuL7d3w2CILrN9
         IBuiEkb53zTGFKWjlNosbHf92Hh3oWCPiSRBmrJiyO+ZPLXHzV5DQQ9qaoIN2wNeV3I0
         YG0O/B/c2uDGqa/T4wtl34oL1eU9voHk3wC/+/J0+z6SCrfJoNPulcieSCeNlm9Ma9mf
         F4gAXqEKp4stVIUl5+EB2f9t3jp4mUMnShs9hk09GoNGErl63JRtSBY43zp3FB5Lqyq2
         rjZg==
X-Forwarded-Encrypted: i=1; AKwUvBz0JrZtP51WxtSTRRMbEjxu88TZrA6oXqAvw1HxXMor4FjCS+wrB7atGjAN/urhDB4yRoECPHNY6w==@kvack.org
X-Gm-Message-State: AFq9FYIOC1GIQx46+08U8iSNHrzmz9RFp5lYLekTHpfxeI97wwOJNo2K
	nNYf1at6Lxmu/uyYmoggTmjcah88No+LMb4w06H1GNOkMpHeAGutkMzhnltvaP4m0G+c1sNpEor
	ToS3wAX0dEX1qJ4rLWisb0Q==
X-Received: from pjbml16.prod.google.com ([2002:a17:90b:3610:b0:3ab:54fb:2a3d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:56ce:b0:3a8:9d0d:ca50 with SMTP id 98e67ed59e1d1-3adeaae618emr6704272a91.10.1793051570356;
 Mon, 26 Oct 2026 14:52:50 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:19 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-4-jthoughton@google.com>
Subject: [RFC PATCH 03/10] bpf: Fail sleepable user copy helpers when
 current->mm is NULL
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ba8ihknmpis7ijmwgy69j3wo8fedguia
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B1B7D1C0006
X-Rspam-User: 
X-HE-Tag: 1793051571-461534
X-HE-Meta: U2FsdGVkX18nC3XFTbFeeiSP2g0sUBqXWBr2YAxy9htN9NBibcwRYdQI4mrQ+La9xBcZaOR4HTMF10UhdA2KwU1nSfIgd+O4c+j6G68waneJRhAqu4QI0swCGekcmZL5JKBAgLURm9X5LxM9Vp/HfemwdqXMVHX8hOYn1zMlimMYWm90FKhsT4p7gAddwk3B00XxfhqMNFNNr4xy/eBCUk1JFWNtelocSi1mzbSAConSwKzxTbFGq6BdU7GCeMtzsTC1uDzVSesUrGgwsWFDnLdBPQa6nEkv7GZrvgt0NK3z2jHyIdI3TvpbB3FJJvwJQsIKQLFDfWduMHhr5g+zUopVhsiB2OfOR7yLWy74NfG2Sdu35uu1j9FCGMYp+IWYBHKkcdpUl+kR+g6H67C3ZpPklUdcCs2YdKWHU8z5hE7TdTFCc3Pror4U5Alx3bMBaLKKTyOm2Sb3cwi6u5bh6GHxr2jy63xTi0uCmflsBrM49kjKcwjM5bProIAzcncVUtLyDzHyAEepJyj2WM0URTxUJ1Uqv0XlG8QFlAV2qNY4PMWMyArVPv8d9Lcim9HxgPi1YvzdCnTPAvrI4gju32cWffOD3q+tA3xiKAk+9S+TjzaCbNq2HvXdlyp8ArbiC9U1+T4nQqL/u7Ai3MEOJOYJc3qD7JYS3uBAQkAQwRWSFniq8kabg6ygyjA5rSTY5yARnG/KlxQOmyuzJbmI30I3AbIqCuIXsWVqcB7PvAysatSIBTvi1eV6zIwE3YRnhfe05LoUO4xKvYHULGSyTWO/RT3Tzs09ot2PQyx/dY7hnbQchh9t+P6CX3xxrPVMUmcIzfRUBSYPql8I1C+8eb3dGMOIre5xouyrp9u9bfwIUwBKCPo1Elv+h7E7sQJHJS87YNa6wcHxyRG0AArx9bEykw9ECTp+bC70EfCex7rKzFUC7ANt+KjQYgpAKi7ybrcMaXkBfsDNxFlsDow
 gGO5mGxQ
 dHW52fWnZMRP2BkpXpTI4Cubk5pgG6p+9pdolXwaOhbbMpugPlMZf8oXUgcGgJoRlCH25PBE1LYFtmQBDFEp0FJbMsolDu+bwQjvO42HS2TZVRSavvIxIqhy8HY1BCcU/1I0goMAGT60fGKN6Y3kZWn0qvjI+3XUzTVan8/Wf2IF2xssiHstfbx82GumZeL/eCw8Jkn8E8DibrC6NNE1uPKXrGQROHlgirSmNn1Bb0Y6QPLiACi9AsIno0mozqJ7wyRTaVbfm5w+7q2ur9p8O2X7K7CtXdLqrrRK1vZh+8njU7ogi3jWud6LNGdv1TukvidtaYftvs7wXQY4xDG3QXL2HlXuuZkUvBB9cV7s5cQAigMv2nbSTadvL359l16zwxbiiZISp/vRwhXMbpFfV5fgNKobCBJU0+2U9lHeleM3ImFeqe+y0hz5BzATUNCpyhF4UClPxVEgf2KryYX78fnZccKvlCNtCcdM8+xGnO4pb436lq+7zgtKyaRyy3FIYhP0z7Ye8KEuSsnYbw+Vc9ESAIkVO4dwrDZQQdZg3HOoW2ahess5mzpg8xV+fMSosIytPGJeSeDHj9SgxJi3b89QIKAXtcw93SnvSkoEbgpxbYi9F7NgVJjYFlTDIrE1RwcmXSwKPHcX+xtKlEjO7znYzeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sleepable BPF programs can run on behalf of a kernel thread, or of a
task that has already gone through exit_mm(). For example, bpf_wq
callbacks always run from a kworker, bpf_task_work callbacks queued
late enough run from exit_task_work(), and lsm.s or fentry.s programs
may be attached to functions called during exit_files(),
exit_task_work() or from kernel threads (e.g. security_file_release()
from a kworker running delayed_fput()).

In such contexts, bpf_copy_from_user(), bpf_copy_from_user_str() and
bpf_copy_from_user{,_str}_dynptr() (when reading from the current task)
call copy_from_user() or strncpy_from_user() without an mm. That access
does not reliably fail: the user half of the address space belongs to
whatever mm happens to be lazily loaded, if any, so the program may read
another task's memory.

As there is no user memory to read from in this case, fail with -EFAULT
without attempting the access.

Fixes: 07be4c4a3e7a ("bpf: Add bpf_copy_from_user() helper.")
Fixes: 65ab5ac4df01 ("bpf: Add bpf_copy_from_user_str kfunc")
Fixes: a498ee7576de ("bpf: Implement dynptr copy kfuncs")
Signed-off-by: James Houghton <jthoughton@google.com>
---
Tested with a small bpf_wq reproducer: a SEC("syscall") program arms a
bpf_wq whose callback (which runs in a kworker) calls
bpf_copy_from_user() on an address in the loader. With the uaccess check
from later in this series but without this patch, that triggers the new
WARN from bpf_copy_from_user(); with this patch, the helper returns
-EFAULT without warning. I can turn this into a selftest under
tools/testing/selftests/bpf if that's useful.
---
 kernel/bpf/helpers.c     | 11 +++++++++--
 kernel/trace/bpf_trace.c |  4 ++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 712dca5a2c5b..c4aa8bcaf2bd 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -659,7 +659,11 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
 BPF_CALL_3(bpf_copy_from_user, void *, dst, u32, size,
 	   const void __user *, user_ptr)
 {
-	int ret = copy_from_user(dst, user_ptr, size);
+	int ret = -EFAULT;
+
+	/* Sleepable programs may run without an mm, e.g. on kernel threads. */
+	if (likely(current->mm))
+		ret = copy_from_user(dst, user_ptr, size);
 
 	if (unlikely(ret)) {
 		memset(dst, 0, size);
@@ -3642,7 +3646,10 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
 	if (unlikely(!dst__sz))
 		return 0;
 
-	ret = strncpy_from_user(dst, unsafe_ptr__ign, dst__sz - 1);
+	if (unlikely(!current->mm))
+		ret = -EFAULT;
+	else
+		ret = strncpy_from_user(dst, unsafe_ptr__ign, dst__sz - 1);
 	if (ret < 0) {
 		if (flags & BPF_F_PAD_ZEROS)
 			memset((char *)dst, 0, dst__sz);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 88c3b5b513ab..793fb3dce5f1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3556,6 +3556,8 @@ static __always_inline int copy_user_data_sleepable(void *dst, const void *unsaf
 	int ret;
 
 	if (!tsk) { /* Read from the current task */
+		if (unlikely(!current->mm))
+			return -EFAULT;
 		ret = copy_from_user(dst, (const void __user *)unsafe_src, size);
 		if (ret)
 			return -EFAULT;
@@ -3590,6 +3592,8 @@ static __always_inline int copy_user_str_sleepable(void *dst, const void *unsafe
 
 	if (tsk) {
 		ret = copy_remote_vm_str(tsk, (unsigned long)unsafe_src, dst, size, 0);
+	} else if (unlikely(!current->mm)) {
+		ret = -EFAULT;
 	} else {
 		ret = strncpy_from_user(dst, (const void __user *)unsafe_src, size - 1);
 		/* strncpy_from_user does not guarantee NUL termination */
-- 
2.56.0.307.g5fe7bd680c-goog


