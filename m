Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89785606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F6B6I81R
Received: by kanga.kvack.org (Postfix)
	id 398196B089B; Tue, 24 Nov 2026 18:00:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348606B089D; Tue, 24 Nov 2026 18:00:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2107C6B089E; Tue, 24 Nov 2026 18:00:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E67946B089B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75534160C9D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:40 +0000 (UTC)
X-FDA: 85471533840.07.81E4FD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD24BC0011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6B6I81R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561238;
	b=nPV+EJV/HaqXKdDOq+RDqut1TFYYK7UrMwPQgDuNZZiAxV67P8RqBAyT8qsuIfhZz71nAK
	ESOvDoaYTMGFptOAmk8PDHPki4eBRIGOmcnBYc0c0BDAMAY+6NInQY7Vd6tgtJ4ri23Pwm
	fCt82CaOhCo4izXlHDIdJ6sqC6Oz/50=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKDDkm8rP0JSk+MZa8V9KUoNn40877PhwS+AzzAJOBo=;
	b=zeylCtpDQs/KQrvqHodOYjQKFw02UuB+JpcjPBWpGJaLtpjLjPUlVmdlknOV386lM3w/j1
	AqV8PIUtO4nlZU28DeCAlg2kufO1QMv+TGxl0Uq/MEdVKufXITZEgEHR1zYyRdHjgyRvnS
	69cy/NNER1JwcNy3y7EVVjMK0qAiaOs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6B6I81R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35C36628D7;
	Tue, 24 Nov 2026 23:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FAB1F00AD3;
	Tue, 24 Nov 2026 23:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561237;
	bh=oKDDkm8rP0JSk+MZa8V9KUoNn40877PhwS+AzzAJOBo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F6B6I81RFcocB+Pb6JEPh24PHgiZAGwC8jsAylcSgfaJE4/8XQPGDk5SqsUeoKc7R
	 IqzduO9jSUwHfnDeJPl4rzQp2I9Ap0J91IQksFiR9J2648aOXMWsK1MxrAIle0upVS
	 NPNg2FGQcfCzrvqiDfKlSzCu/E856ce2H//tE2mf/K+Z2F882N3RYEGB+5Hk6BgBAv
	 LkONKr8DOc4vXivY9vAb1ydnZV5wa5K6E1tkMr+9sl2N4+r9J/SHY+mUBc2TqILLRs
	 R3IrRcHZUYUVTHLOydF0i/iApaqTqdHQrM0pndOJWN0Yc+yL+vESwVTArLI+KZ3n1W
	 OsaVm6mXvFwsQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:41 +0100
Subject: [PATCH RFC 18/19] vfork: wake up the parent once the child has
 left the mm
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-18-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=5246; i=brauner@kernel.org;
 h=from:subject:message-id; bh=kKS/ga5cKveEWXaeubsSO0J9YWxV3URvRGlj1COQm9I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziZ0ylFNgjttf9WN2t4xg62OGKU7ir45+v7bO3Jnrw
 xLB9jfLO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZS/I6R4S7jHm6TW4/6v7n8
 uVusFeX1lN8xXW9yZZ6E0HX19UecxBn+pz1auop5c4FjoKhdadThKz2ndhcafhc4fOGg+ZH1ni9
 vsQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: AD24BC0011
X-Stat-Signature: crcw9uyjg75wuobk3on61z95xefzw8d8
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795561238-165544
X-HE-Meta: U2FsdGVkX1+IczHplLhNan3p/994hFkMW8ANKqwbyUHKHAHC7Yu7kGx1o/4lmJE+D1HpajBd6qSJ7lg0Hgyw1Jt/QaI65gwUp3x4oOv7LW5eLlNVK8WVmAQJbbVOU3oBNfcYjv8flpfPATLGDthYI9c67xVbBh78n9fMlmWytJMDPWeP8pdPAi1CFFqKrTYLqHHRNXtRzF9Hf9mT3U+gjAYClbBChGq8+sAIBA2Iepf6J6QWGl428ESSthvkH5PA8vHYGSPcyF01wFFEyBpPvKbUyT5tqMyPa6OSZ8YRwWftHX8ftefcrSqAH5PJVKCDJQOWU7LZoZ+aeWFUa7kUeuQERhB8xV3iKRfsJFMpK+yVMdra+8Vu39GlUFpj4aG9f+ju0ZIzG9VlcHqJ0TqbbezrG63UFqDTonVqAIlltcEZoLfqabviq0venMw/ErN7GcXF/tEl4C1K2RJibGdukxOkYOTreKT/7VX/sdhiHSdW1Oc+C82itQ6RdKrZkcKwukeEHesxgHnEkGNRsnmaWP5eHLQwGkx1Mtu3OgVjQp5Lw/1U5s0yb1J/oUW9KM36yF/vOXjgtbRmxAWT9XXid5sDaNXqAV3wuTAgRCKQ3DU1hzv1/Kf8hpk4WCVSBIhiEn11HN3bTrfuZPUR23Ubl6jpLJV2BHmOqtzGSe7qRQLnpHJt/WXiwLDB+lQKWT8msovkvCg3J2qfBpL46KPjE/7PIWL5bHtUnX92+U7/0XaXWfYYx/0DLfeW4J/1kyHPcHo4MKzk90CX1269i1mUqW76CMPX4V3a/BCgOEv4i5GYHfvlKX7OQARxdJh15n8G1EkD44/s0XXW+CYM6Zvv4XoyBrvebnPQtqEnj7JRviJbShFUwirddnBIWK+mykrwUJ1ZX3g0nRI9KvgP7tWBnr7yy3RSuurnuyR1Erg1mXy+//lWpvZv5WGazwifHdWk0mhum+uV7M+u5gLdznu
 m93k0nIw
 VVXIr61wE9Ges0dHy3wWVHy5Pak9M70jBPpZ7UhmFwck3An1xdK6sFtlIcMCLk/IKjS+sCzyGIaLrN72b7nyr794Eb+IsyT+A/9ij92MjTufLU2DicwPGaJCIGyarPML+oyltgWXlT4534wCeQCwND0Ztz1f6ijqY3atlEW1B4k4ErrlbstEgnkN64amiXJ8DGvHANtQ+8LXOEwe6TVpjP9DvBH9/FDqqq/J1cRZm1N6TMQze7UphSxbqYNWJ9XeL//LNMZIDi95f8nFJhbL0RbRqq1bE20vgyT4WimZNG0/HgISLDDs1iWonjU3HHbd0SkTcWGqBNFGHlWe5tJXnqWzvwQpcVsEbU5hjMCUnuNpg+kI1j3oUsl9gsuMVSWGIVECWN0xndGgJEmFDU+z54K6kgHul989FIMypoc6WlLeVwK1UDq48QgbA2yBFRq5nZ2ptVCmoUrK4WFyA/WhpSrjpAvm0TFbJNaK1s1DQdrOJWPVxhtEK1dmadF3BWxiEfPyXuejiMGXb22Dq/vM2cfBSgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A task that called vfork() sleeps until the child has released the mm in
mm_release(). But exec_mmap() releases the old mm, then waits for
exec_update_lock and only then switches to the new mm. And exit_mm()
releases the mm and only then drops it. So the parent is woken up while
the child is still on its mm.

It wasn't meant to be that way. When mm_release() was added in 2.2 it
was called after the task had been switched away from the mm. exec only
moved it in front of the switch in 2.5.56 because deactivate_mm() and
the write to the child tid address need the old mm (cf. [1]).

The release has to stay where it is as it can sleep in a page fault for
as long as userspace likes. So take the wakeup out of mm_release(). Wake
up the parent in exec_mmap() once the task has switched to its new mm
and in exit_mm() once it has dropped the mm.

While at it, fix the comment above mm_release(). It hasn't been called
after the mm was removed from the task since 2.5.56.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c                |  3 ++-
 include/linux/sched/mm.h |  4 +++-
 kernel/exit.c            |  7 ++++++-
 kernel/fork.c            | 24 ++++++++++++++----------
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 78046ed839646..4d3f78ea0b0e6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -854,7 +854,6 @@ static int exec_mmap(struct linux_binprm *bprm)
 	if (!exec_state)
 		return -ENOMEM;
 
-	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
 	/* Clean up futexes and release the mm */
@@ -897,6 +896,8 @@ static int exec_mmap(struct linux_binprm *bprm)
 		mmdrop_lazy_tlb(active_mm);
 	}
 	futex_exec_done(tsk);
+	/* We've left the old mm so a vfork() parent can run again. */
+	complete_vfork_done(tsk);
 	return 0;
 }
 
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index d7c6a942aa7e0..2adfba6217133 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -158,9 +158,11 @@ extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
 
 /*
  * Remove the current tasks stale references to the old mm_struct on exit() and
- * exec(). Cleans up futexes as well.
+ * exec(). Cleans up futexes as well. A parent that sleeps in vfork() is only
+ * woken up by complete_vfork_done() once the task has left the mm.
  */
 extern void mm_exit_exec_release(struct task_struct *, struct mm_struct *);
+void complete_vfork_done(struct task_struct *tsk);
 
 #ifdef CONFIG_MEMCG
 extern void mm_update_next_owner(struct mm_struct *mm);
diff --git a/kernel/exit.c b/kernel/exit.c
index 38de318a07aaa..6120f0dc3b17d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -554,8 +554,11 @@ static void exit_mm(void)
 	struct mm_struct *mm = current->mm;
 
 	mm_exit_exec_release(current, mm);
-	if (!mm)
+	if (!mm) {
+		/* kthread_stop() waits for this. */
+		complete_vfork_done(current);
 		return;
+	}
 
 	sched_cache_exit_mm(current);
 
@@ -579,6 +582,8 @@ static void exit_mm(void)
 	enter_lazy_tlb(mm, current);
 	local_irq_enable();
 	task_unlock(current);
+	/* We've left the mm so a vfork() parent can run again. */
+	complete_vfork_done(current);
 	mm_update_next_owner(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a78..f63133b9e6faf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1428,10 +1428,21 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 	return mm;
 }
 
-static void complete_vfork_done(struct task_struct *tsk)
+/**
+ * complete_vfork_done - wake up whoever waits for @tsk in vfork()
+ * @tsk: task that execs or exits
+ *
+ * A parent that sleeps in vfork() must not run before the child is off its
+ * mm. So this is called once @tsk has switched to its new mm in exec or has
+ * dropped its mm in exit. kthread_stop() uses this completion as well.
+ */
+void complete_vfork_done(struct task_struct *tsk)
 {
 	struct completion *vfork;
 
+	if (!tsk->vfork_done)
+		return;
+
 	task_lock(tsk);
 	vfork = tsk->vfork_done;
 	if (likely(vfork)) {
@@ -1465,8 +1476,8 @@ static int wait_for_vfork_done(struct task_struct *child,
  * mmput is called whenever we stop holding onto a mm_struct,
  * error success whatever.
  *
- * mm_release is called after a mm_struct has been removed
- * from the current process.
+ * mm_release is called when the current process is about to
+ * leave a mm_struct in exec or in exit. It's still on it.
  *
  * This difference is important for error handling, when we
  * only half set up a mm_struct for a new process and need to restore
@@ -1498,13 +1509,6 @@ static void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 		}
 		tsk->clear_child_tid = NULL;
 	}
-
-	/*
-	 * All done, finally we can wake up parent and return this mm to him.
-	 * Also kthread_stop() uses this completion for synchronization.
-	 */
-	if (tsk->vfork_done)
-		complete_vfork_done(tsk);
 }
 
 void mm_exit_exec_release(struct task_struct *tsk, struct mm_struct *mm)

-- 
2.53.0


