Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 789E4CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16BA6B0088; Wed, 20 May 2026 10:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F356B008C; Wed, 20 May 2026 10:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB56E6B0092; Wed, 20 May 2026 10:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABD2B6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:43:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74CB8C17C9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:25 +0000 (UTC)
X-FDA: 84788066370.02.A2B645E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A125914000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPEHdCNp;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+djlJ/+fpR6dON4NXb+28lKjQbX3PFCkMYFyK1eIB8=;
	b=MIEfo5uHeEeC0toRUQsVmyCnCIj03E3tdIJj1094ClYyPYdbvKEE/r94TG5GDNPfkVAGVN
	LUMw4mkKrwZfU3EJ1hofNWf6ZgBiJlPWFdk1Qm2KgMPsH/NxGQKCXW3xidiK6oLigGxvO1
	sLPFsps8TOtth7K48k84dF5tOt5tY5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288203; a=rsa-sha256;
	cv=none;
	b=VxSYuLxgrlZwYMUGuFiLHZjrrVVlfFLMqeh/gx3hEG3mDVjgA4O8bdiuMZdhHFz+w8q2gz
	aaAIm+MKfkBURhVVvYUqSjolUvNhgQXWwmdCWMv5gzAmCzFYL2Dcwp7cK05cXeitWVp2qe
	nPZaIFNjRZ1f8HQ+NszhsrCYh6WPvmU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPEHdCNp;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 396EC60126;
	Wed, 20 May 2026 14:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809CF1F000E9;
	Wed, 20 May 2026 14:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779288202;
	bh=x+djlJ/+fpR6dON4NXb+28lKjQbX3PFCkMYFyK1eIB8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RPEHdCNpn9fipjvBFqeaib/sis8Ysb7pDhGNGadvOwbEfWwSNCvRtSrR8WG3WGwWF
	 deYy2i3yYjxB1+EGUHDITC8uALYRltBBRm8ocFait98Rjx3QS0WOZ7GUGsgzS9MwAy
	 exAKYQC0zbVF/PYsx0E+zMJflUbUmUrxUB4Eb+43fE5oC6fwBt+1q6Fdso6UrAvbUS
	 iZLU8lkkCQhsz4ZuYo+FwFZrhYQFLnbffiXgWUrTgazkHY61HGcA7x+uckhJchJNhm
	 TLCq4ijauJ9VJW3OerTHb2FMIkB31KqyyBp/2vdxmeDybOAvM1TGJOT2HxhcmKNgUt
	 kFtWu4TOOIGJw==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 20 May 2026 16:42:54 +0200
Subject: [PATCH RFC v2 1/5] sched/coredump: introduce enum task_dumpable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-work-task_exec_state-v2-1-9ea88ceb09e6@kernel.org>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
To: Jann Horn <jannh@google.com>, 
 Linus Torvalds <torvalds@linuxfoundation.org>, 
 Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, 
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=8332; i=brauner@kernel.org;
 h=from:subject:message-id; bh=D5ACqOMb5/IX4CZnrdLWKSwb0BW9UPiaugZZjXzG6rQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTxnmjOKek4arTJ6kGaZ7J+wTqxF3tSz3sqF7NVHAr9I
 NLtO0Wyo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCL+gowMl7p6D6z2/bT8nELu
 wknm7/ZnW191sMia/F7szz21M7NV7jAyHJ8muFC8rkL9bI3Nst873f79DvryurgxhFvhQcEEO94
 EBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A125914000F
X-Stat-Signature: y4ha1aaxdxabjm8ojn3nw67tw6hazygc
X-Rspam-User: 
X-HE-Tag: 1779288203-872117
X-HE-Meta: U2FsdGVkX1/JcPar9S2QnhxIF139hEDSe6OAwcvdpx3Eg++Sy71poUyd4g9ZWjXNR3ABJWFe1dSTm0o5MqBufxAqni43bX19D93+4x32Wa/Jn/zVLOL7a67gsQboHTRMFtpvIvl242yB/u2+3vhuQDYCxJsNoI2S3Hf4WihFvqulf+h4D324jUi2Rh3xVIZe2ic81C7WHqq6fWXrZ9MBOn3OLblu4ZqcCJul+lHj3fpksz0CJrfgBcrlt7+Rb2gxt92BHxnwWUgvlStsXDbptfDn5Feo+iBY+7g2Rv+MNGAqfddi3inDofN9hFQRMZIO3ul0oERnlpYq61OEB2Hp1yd7vJTZB3zTcm1mTfZm+MluiapKbie5hupHiH3odPBtQXcI7ZIk8BI2tOFIcWREKWxbg5AYA8wu4YnGXgXvt0WdYQhd4R2VYQfFGmVd8AGkJH5VLPq5DVav8iVjREIj5n0rZlxir9DN1suxZA6cAQVpW0u9FXbEDkaNe88eOYzsQnXob0hTFm4hAXEN5jg6Hk7kzACF6poP3pDJFWutNSLLje+54mRMoRpD3BJX0ABF2i4Me1bUzjbEhaXHmzf/7BpBmKEyVthMiRmkkx3czQXWYjC0TxEdO90OeNOHUjxV8GxU1LkTVOBI7G2o2rRMafdYjHX0yaUd0AWvmqAe9Q6mM2eCMhZDFrjfzNF6/sOt40yr4X2M8zkfRlVfXukOSwCih6zbrCIsVEFwCVs00WmGpyPxvVsnbb/B5zYvwwl3m5RogYjedfLdxt2CO/x51oU7Htv7jvty6fXXSVaRIG77YO6s17PBorFK9E5I4oe33GDc9G0348yu0nqW81KPNTIWuf9do7L+OqKKBUR6c0OCjuDu/DmrzE0T+dhVBtqYqPjI+YhOrJEzjSaBQWxu2uvPkDK7hy3km3GHFml2MOV5DQP/EarA3iZzmB8VwSx7fVQbjl6FE4fxTzK0J8b
 xPQFcPWp
 z8/UUThUtyDCBhrARierlqS/QvxwfHO+qiVCePM4BOkQTZP60TXamlR2ztHnQRmJwsuv1wYA4+BzFObsDuT4cDHhaZnWGjumF0jqJLbz3DQfvWEN3Y9wkuzgDAhU5oYNGG5DEjLo7UqSdQQm7A+XxWI/GuWv60UTRN7h4UOnMolXfhg/lLVLX1s/lwWm4SY6SpbPSfX+Ngf161TAw7ODA6XiQQVoapitEEenebL94xX7KaabIMFF71Lai1IVqeDWuRkTZzB+FQAIcHv8m7WInYGjMy5h3STXxqXf4lZIhraSplfJRO9dZu/vzXmB75cnQN4OljZL9L9E0nODoBbw/C6DELCv6CeucPXqr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the SUID_DUMP_DISABLE/USER/ROOT preprocessor constants with
enum task_dumpable.  Numeric values are preserved (kernel.suid_dumpable
sysctl and prctl(PR_SET_DUMPABLE) ABI), so this is a pure rename with
no behavioral change.

Subsequent commits relocate dumpability onto a per-task structure
where the enum type will allow stronger type-checking on the new API.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 arch/arm64/kernel/mte.c        |  2 +-
 fs/coredump.c                  |  4 ++--
 fs/exec.c                      |  8 ++++----
 fs/pidfs.c                     |  6 +++---
 fs/proc/base.c                 |  2 +-
 include/linux/mm_types.h       |  2 +-
 include/linux/sched/coredump.h | 15 +++++++++++----
 kernel/exit.c                  |  2 +-
 kernel/ptrace.c                |  4 ++--
 kernel/sys.c                   |  2 +-
 10 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 6874b16d0657..904ac41f93bc 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -538,7 +538,7 @@ static int access_remote_tags(struct task_struct *tsk, unsigned long addr,
 		return -EPERM;
 
 	if (!tsk->ptrace || (current != tsk->parent) ||
-	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
+	    ((get_dumpable(mm) != TASK_DUMPABLE_OWNER) &&
 	     !ptracer_capable(tsk, mm->user_ns))) {
 		mmput(mm);
 		return -EPERM;
diff --git a/fs/coredump.c b/fs/coredump.c
index bb6fdb1f458e..f5348d5bc441 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -873,7 +873,7 @@ static inline bool coredump_socket(struct core_name *cn, struct coredump_params
 static inline bool coredump_force_suid_safe(const struct coredump_params *cprm)
 {
 	/* Require nonrelative corefile path and be extra careful. */
-	return __get_dumpable(cprm->mm_flags) == SUID_DUMP_ROOT;
+	return __get_dumpable(cprm->mm_flags) == TASK_DUMPABLE_ROOT;
 }
 
 static bool coredump_file(struct core_name *cn, struct coredump_params *cprm,
@@ -1419,7 +1419,7 @@ EXPORT_SYMBOL(dump_align);
 
 void validate_coredump_safety(void)
 {
-	if (suid_dumpable == SUID_DUMP_ROOT &&
+	if (suid_dumpable == TASK_DUMPABLE_ROOT &&
 	    core_pattern[0] != '/' && core_pattern[0] != '|' && core_pattern[0] != '@') {
 
 		coredump_report_failure("Unsafe core_pattern used with fs.suid_dumpable=2: "
diff --git a/fs/exec.c b/fs/exec.c
index ba12b4c466f6..f5663bb607d3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1212,7 +1212,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	      gid_eq(current_egid(), current_gid())))
 		set_dumpable(current->mm, suid_dumpable);
 	else
-		set_dumpable(current->mm, SUID_DUMP_USER);
+		set_dumpable(current->mm, TASK_DUMPABLE_OWNER);
 
 	perf_event_exec();
 
@@ -1261,7 +1261,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 * wait until new credentials are committed
 	 * by commit_creds() above
 	 */
-	if (get_dumpable(me->mm) != SUID_DUMP_USER)
+	if (get_dumpable(me->mm) != TASK_DUMPABLE_OWNER)
 		perf_event_exit_task(me);
 	/*
 	 * cred_guard_mutex must be held at least to this point to prevent
@@ -1906,11 +1906,11 @@ void set_binfmt(struct linux_binfmt *new)
 EXPORT_SYMBOL(set_binfmt);
 
 /*
- * set_dumpable stores three-value SUID_DUMP_* into mm->flags.
+ * set_dumpable stores three-value TASK_DUMPABLE_* into mm->flags.
  */
 void set_dumpable(struct mm_struct *mm, int value)
 {
-	if (WARN_ON((unsigned)value > SUID_DUMP_ROOT))
+	if (WARN_ON((unsigned)value > TASK_DUMPABLE_ROOT))
 		return;
 
 	__mm_flags_set_mask_dumpable(mm, value);
diff --git a/fs/pidfs.c b/fs/pidfs.c
index 1cce4f34a051..9cd12f2f004c 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -341,11 +341,11 @@ static inline bool pid_in_current_pidns(const struct pid *pid)
 static __u32 pidfs_coredump_mask(unsigned long mm_flags)
 {
 	switch (__get_dumpable(mm_flags)) {
-	case SUID_DUMP_USER:
+	case TASK_DUMPABLE_OWNER:
 		return PIDFD_COREDUMP_USER;
-	case SUID_DUMP_ROOT:
+	case TASK_DUMPABLE_ROOT:
 		return PIDFD_COREDUMP_ROOT;
-	case SUID_DUMP_DISABLE:
+	case TASK_DUMPABLE_OFF:
 		return PIDFD_COREDUMP_SKIP;
 	default:
 		WARN_ON_ONCE(true);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d9acfa89c894..da0b316befb8 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1909,7 +1909,7 @@ void task_dump_owner(struct task_struct *task, umode_t mode,
 		mm = task->mm;
 		/* Make non-dumpable tasks owned by some root */
 		if (mm) {
-			if (get_dumpable(mm) != SUID_DUMP_USER) {
+			if (get_dumpable(mm) != TASK_DUMPABLE_OWNER) {
 				struct user_namespace *user_ns = mm->user_ns;
 
 				uid = make_kuid(user_ns, 0);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..51ea37b2a0aa 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1908,7 +1908,7 @@ enum {
 
 /*
  * The first two bits represent core dump modes for set-user-ID,
- * the modes are SUID_DUMP_* defined in linux/sched/coredump.h
+ * the modes are TASK_DUMPABLE_* defined in linux/sched/coredump.h
  */
 #define MMF_DUMPABLE_BITS 2
 #define MMF_DUMPABLE_MASK (BIT(MMF_DUMPABLE_BITS) - 1)
diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
index 624fda17a785..ed6547692b61 100644
--- a/include/linux/sched/coredump.h
+++ b/include/linux/sched/coredump.h
@@ -4,9 +4,16 @@
 
 #include <linux/mm_types.h>
 
-#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
-#define SUID_DUMP_USER		1	/* Dump as user of process */
-#define SUID_DUMP_ROOT		2	/* Dump as root */
+/*
+ * Task dumpability mode.  Gates core dump production and ptrace_attach()
+ * authorization.  The numeric values are stable ABI (suid_dumpable
+ * sysctl, prctl(PR_SET_DUMPABLE)); do not renumber.
+ */
+enum task_dumpable {
+	TASK_DUMPABLE_OFF	= 0,	/* no dump; ptrace needs CAP_SYS_PTRACE */
+	TASK_DUMPABLE_OWNER	= 1,	/* default; dump and ptrace by uid match */
+	TASK_DUMPABLE_ROOT	= 2,	/* dump as root; ptrace needs CAP_SYS_PTRACE */
+};
 
 static inline unsigned long __mm_flags_get_dumpable(const struct mm_struct *mm)
 {
@@ -26,7 +33,7 @@ extern void set_dumpable(struct mm_struct *mm, int value);
 /*
  * This returns the actual value of the suid_dumpable flag. For things
  * that are using this for checking for privilege transitions, it must
- * test against SUID_DUMP_USER rather than treating it as a boolean
+ * test against TASK_DUMPABLE_OWNER rather than treating it as a boolean
  * value.
  */
 static inline int __get_dumpable(unsigned long mm_flags)
diff --git a/kernel/exit.c b/kernel/exit.c
index f50d73c272d6..507eda655e8d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -571,7 +571,7 @@ static void exit_mm(void)
 	 */
 	smp_mb__after_spinlock();
 	local_irq_disable();
-	current->user_dumpable = (get_dumpable(mm) == SUID_DUMP_USER);
+	current->user_dumpable = (get_dumpable(mm) == TASK_DUMPABLE_OWNER);
 	current->mm = NULL;
 	membarrier_update_current_mm(NULL);
 	enter_lazy_tlb(mm, current);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 130043bfc209..07398c9c8fe3 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -53,7 +53,7 @@ int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
 
 	if (!tsk->ptrace ||
 	    (current != tsk->parent) ||
-	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
+	    ((get_dumpable(mm) != TASK_DUMPABLE_OWNER) &&
 	     !ptracer_capable(tsk, mm->user_ns))) {
 		mmput(mm);
 		return 0;
@@ -276,7 +276,7 @@ static bool task_still_dumpable(struct task_struct *task, unsigned int mode)
 {
 	struct mm_struct *mm = task->mm;
 	if (mm) {
-		if (get_dumpable(mm) == SUID_DUMP_USER)
+		if (get_dumpable(mm) == TASK_DUMPABLE_OWNER)
 			return true;
 		return ptrace_has_cap(mm->user_ns, mode);
 	}
diff --git a/kernel/sys.c b/kernel/sys.c
index 62e842055cc9..f1189f719db5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2568,7 +2568,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		error = get_dumpable(me->mm);
 		break;
 	case PR_SET_DUMPABLE:
-		if (arg2 != SUID_DUMP_DISABLE && arg2 != SUID_DUMP_USER) {
+		if (arg2 != TASK_DUMPABLE_OFF && arg2 != TASK_DUMPABLE_OWNER) {
 			error = -EINVAL;
 			break;
 		}

-- 
2.47.3


