Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E40C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 00:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2406B007B; Sun,  9 Aug 2026 20:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3546B008A; Sun,  9 Aug 2026 20:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9C26B008C; Sun,  9 Aug 2026 20:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E30246B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 20:23:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DF231605E7
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 00:23:10 +0000 (UTC)
X-FDA: 85083460140.08.19D1DAC
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7D60180008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 00:23:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HjTigKHI;
	spf=pass (imf06.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786321388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OR/NeAT70AXkJxV5qLrjC7wfN9T2B+VjuoviUV573+o=;
	b=2cVoxzbX1TGcPeg6iNHmh2egcOn2eAWGhu+OdewagjKVgLJT5OJTlpZ6UAyJ1W1LdJ1Tiz
	36ZLg3iECEUhBmtabwbUKJy85HuuiO1qVPiuMyHXnO/rFqyKFHQ6Z4pnaaU1snanePS0nH
	N66giaV147ypiI3tvbQOO7Jpahf4HJg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HjTigKHI;
	spf=pass (imf06.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786321388;
	b=w6f4gHsy9/qnPAYQmWAcoefshijy6j1oxRze0rldpz7IBdch4Gm767Mp+A17xEUTc483FW
	gPPszdRnPnQnjVwE6VqpQ1IOfVuZVn/QNT4o+aL6RiKY7j/McZpy0eVCbWsUZADDIaOTsu
	reVCBL4ZT8EYigdcTPBv48KG+zFsDdE=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so875563b3a.3
        for <linux-mm@kvack.org>; Sun, 09 Aug 2026 17:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786321387; x=1786926187; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OR/NeAT70AXkJxV5qLrjC7wfN9T2B+VjuoviUV573+o=;
        b=HjTigKHI0ihgbTN3d8+L5L5OGDJ6IrRWRQliF2LIWaR0oKREZRbh9Q0HaNkHar+ZBP
         RayCgGWgjYIbClZFsZTVkB4je0J1ryrlNAEX4Wa2pDdhBtPnMaEkNvCaP7WbQFxEOQRb
         7j2hvWUFEVdHAYC6+nmZkN7xEgK1nkNBNx5sL9IM3WGpvYO+XKIpJTjPhwGYeoJA2OQ5
         4Xf/ToM01IDzIB0PtRZHnzCyqE7Wa2zvuNqpnuH9pe3SCVNkWIx25laDjZDvzTUeW3fm
         lBenieLBoUFir3HbbIb5eSO3ld0KV28JOO0Mi4z17UUEbxW8Vlea206ih9fPBj8U/YyI
         u/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786321387; x=1786926187;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OR/NeAT70AXkJxV5qLrjC7wfN9T2B+VjuoviUV573+o=;
        b=LsgIMMz08p95uWq7VTmj8oiuDXLxUg2l9WyaQ9TCkxkh/exrt9hBODMJ3Y767W7Kwy
         66BJ2sUdN3nIo3CvA3YrbrDbdnDMgw7NUWJX66qXRI4YNMmBt0rg9OhFwJSCBeoXwShz
         GzcpRUhk9oQAXw2/dxzLN4Tv5B9+xRe5uDb3zDmJyJwvrEGMMQ96nYfxpCBwxQryC0jR
         4pfBKjXA+fmgNMVb4ArTr1KqdFdUK3WC0SugYTTEqgNmFJW9htkZeMhHUkJwf++udNch
         q1E6VyqBcswsXqfGgEN49DR23rKavWuaK0p+q9lqP5CnUMR55eTSK9Sxxcaw1/3C+4wQ
         D9Ng==
X-Forwarded-Encrypted: i=1; AHgh+Rq4AAyw01FmECpzT0FUMaveLzL8+7wWQv6mz5rN+alGNSiJS8K3N/54KpFent+VqkT4WsBN7wf1qw==@kvack.org
X-Gm-Message-State: AOJu0Ywel59Io7UMcMB7THyFWS8/xQTuhTpOYSzei/wYzTIwUcG2NIAw
	KqnwXUpqvwDplwFRFhDr/gNQbAbXDKk+8mIsQFBdb6Y3e5HjsF/Oxs2N
X-Gm-Gg: AR+sD12RRAb0zatHVTxW/3AVisgQQRlwPAh0ZsqjB+53b9JAPPNwsCCIG/SHN2x6tFN
	LcdsVeoZcF1PvsjIa5cgTfTTP5jfzz37C9tyMoqaRMKvOu3vUQnmrsPkJHfEpF31gEi4syNCHV3
	HdWmafCfb8BOmMFVNUHGOlxpp0+FarjgoxtF980pR5il+w/MrFGBaJrHI/twnLHlaAJGUTZpRaf
	CzCjjcWDOfRHX7nvAsZdmRjepkIHsi7CdyKnaCnbb9Q0by7flS8RCSKG3rq5iJdjqGY/kroP3Hm
	FLDhFNHZ+6MHaLBCCDI9DxFeGttoCOI0qJzW5Oz3q2Ub3uzHQZVq6Cwgo0rdkcYlfU1hQ88J06w
	64cFKCiCiJOYXqv4xVyntac/90PDiJrN5xSykqTx1acS4+2DWXcrXKZmenO9ruQT/hiOIF8wvlx
	FKMC8KmFGMZY0tRKG6N48mv5QuDunTn7Uh3ccSqr/lCm5LTIcMq5MvAdm7/mKL1pfMLCh4ma3Xz
	KoxuCOM
X-Received: by 2002:a05:6a00:2d9a:b0:848:70dd:f5a9 with SMTP id d2e1a72fcca58-84f4fee2fd9mr26312460b3a.38.1786321387379;
        Sun, 09 Aug 2026 17:23:07 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f753b7dacsm1248234b3a.41.2026.08.09.17.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 17:23:06 -0700 (PDT)
Date: Mon, 10 Aug 2026 09:23:01 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, tglx@kernel.org,
	mingo@redhat.com, peterz@infradead.org, dave@stgolabs.net,
	andrealmeid@igalia.com, akpm@linux-foundation.org, david@kernel.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH v2] futex: Keep the PI owner of a private futex in the key's
 mm
Message-ID: <ankZ5euBcxDo0-Zq@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7D60180008
X-Stat-Signature: ou5hrzm7giaroop64tafdy1wmj9bsfg3
X-HE-Tag: 1786321388-42619
X-HE-Meta: U2FsdGVkX18FR58AznM1gdaIMCNc2Gs3CSEOhPnI65JNOr2/YqQNfZ0m03cyuWlN4e9NWIhqgcQMiOFgw8IF3LQISW8y1M3x0QstSK3ieTfZfV3H2W94md6Oxr+El9KV31LcwuN6sfrrnS/XbWsMsPQ3pvPJuMpRWJiENwKop/kN7nJgSvMoaJRR9WSvi49R171jR0vkFrRsp+lCTY7dzjc4Ar1eekyvB+ExzWX+eEnrVFH2Lcu83VccIZDWSp5FVjUEpdtooGPdd5MYpbToVUE2Sr+hxGNu7lGV8feY7TIvEZ2f4lcI/2oXlTtvnRWQhH8Nn5AfZgzN5kiAHvpM7ISY25ldsJz3ltU0atDhVXpKTU1pm+YuAFSSXsUJ4mUPDb+W6gjkNwY1lmQDNgtZfqSa41hPI9HLgAoBLTKgGTvvuiXZWfTYrSRhM0sbk2MqTWtwmCDqIFDcH94+e86gj2n96iBAv+gUoyi5zeHd8IOdGdvirWRrhBGoBHzdZ8f0QcaOJAZMAoG6yv6+SLF5AilyY+4HU5iCRsF+0MSAYibl81WUUFeEuAPNb0cVY5M8Roa2adS+/ryRQjxjRs3BG3rXJF4cJA+eT3zOTOsL5cJfONzgQZ9B9rNUnOUHUMBzsbj6XmHNdklT1BXMs7Hv7/rNsPXqcUL+ORggNoSH2kMUiyCaZH1X8iuwOgak2pbsW1NgHVLxXl/D0+vmmj+4Mo4qdGwTZvd99ZXBs+AQCC9K3iLmoKYtMc/8v32iqP+wKIg5XMWnupmCW4ILKv+Tz50FcscH3I/+qMmOY9VKIkvLzGfH1mUJutqy11HJD92vaIg+ku2o6XktcCKxuKB4P5cAna8ZhPv6IXvG2bJxjYeCA9IPPwDz1X4yeNotIKqvzWKUa8JcCXYjwlcxdRiRdD/9UOj4MXQGxVy+vr/VmhVM6RKL5avYZJLwNpjHhegqffMsQQVKf39yarao0wl
 XHjKtRYH
 EmsDQyLMZ9MxuEXsUv+EsQaWVl0nq3QxvlB/bTvN3R9kX4CwWM5lcb20MXPnlRzjgCMS21/YsPj0ctg2r80RPwdHUsTUG2UMbkRAfbMUWlO07fEy6zMszHYHfRI2ACi8ID+zfhrpgUAMnPejyp80S+CrkYhqxgVeZ3/2dSTFuc67HKO+2bmhblQKz4R5zSlCXDWoTTQW4h62kpgtrVCvBtWzQrih8aF+rtG7O2BaYDB+vfc8n5TzDCLZbQIPVpWUxg8hmpdy6BO6ytLPmgDbKnrew1RQLihXzeBqOA0dR2yIJl30cbRbBXxe3kGuoO2BjK1wSBhqvHIsqQhvQLH7kqrojMxZG/YyxRQ/6t8cQvSdO6DKUQRgVy3HZgU2GsD+L3IsLzyoAlCMn7rlgyTjJlKMn73DD/zgkEcokWyv89cYhcSVkYAeYn4X37l2qh+67rvcjx4NSLxzsiT5YY6MUblINmcIdQEkHv6j0nxHMjfCcX9kZgWFmlYu5xjKUojPKazcD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The futex word read by the FUTEX_LOCK_PI operations can hold an arbitrary
TID. For the task looked up by that TID, attach_to_pi_owner() only checks
whether it is a kernel thread and whether it is already exiting. It does
not verify that the task belongs to the address space the futex key was
taken from.

A private futex key is the pair (mm, address), and the mm is stored as a
plain pointer without taking a reference. __attach_to_pi_owner() copies
that key into the pi_state by value and links the pi_state onto the
owner's futex.pi_state_list. The pi_state can therefore hold a key of an
mm which is not the owner's, either because the TID named a task in
another mm to begin with, or because exec_mmap() installs a new mm on the
owner after the attach. de_thread() runs before exec_mmap(), so the waiter
in the latter case is not a thread but a sibling that only shares the mm.

When the owner exits, exit_pi_state_list() pins the private hash of the
owner's mm with guard(private_hash)(current->mm), but resolves the hash
bucket from the key stored in the pi_state, which points at the waiter's
mm (M below). The stored key holds no reference on M, and
futex_hash_free() does not look at the fph references still outstanding.

  T1 (waiter, CLONE_VM sibling)     T2 (owner, mm = M -> new_mm)

  clone(CLONE_VM)   // creates M's private hash

                                 execve()
                                   exec_mmap()
                                     exec_mm_release()
                                       futex_exec_release()  // STATE_OK

  futex_lock_pi()
    attach_to_pi_owner()   // p->mm == key->private.mm
      pi_state->key = *key   // {M, addr}
      list_add(&pi_state->list, &T2->futex.pi_state_list)

                                     tsk->mm = new_mm
                                 do_exit()
                                   exit_pi_state_list()
                                     guard(private_hash)(current->mm)
                                     key = pi_state->key   // M
                                     CLASS(hbr, hbr)(&key)
                                     hb = hbr.hb           // +refcount

  do_exit()
    exit_mm()
      mmput(M)
        __mmput(M)
          futex_hash_free(M)
            kvfree(fph)

                                     spin_lock(&hb->lock)  // UAF

A private futex only has meaning inside the mm its key was taken from.
Verify in attach_to_pi_owner() that the candidate owner belongs to the mm
of the private key and return -ESRCH otherwise, as the TID is then simply
a bogus user space value. p->mm is not protected by p->pi_lock, so it is
read with READ_ONCE(), and the check is placed after the exit state check.
That check alone does not stop exec, so futex_exec_release() is split into
begin/end to keep FUTEX_STATE_EXITING set until the mm has been swapped.
An attach in that window gets -EBUSY, retries, and then fails the check
against the new mm. Fixing only one of the two leaves the same
use-after-free reachable through the other path.

Fixes: 80367ad01d93 ("futex: Add basic infrastructure for local task local hash")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
Changes in v2:
- Also keep FUTEX_STATE_EXITING set across the whole exec transition. v1 only
validated at attach time, and a successful execve() invalidates that
afterwards, so the same use-after-free stayed reachable with v1 alone.
futex_exec_release() is split into begin/end, and every exec_mmap() unwind
calls the end half.
- Rewrite the commit message to cover both paths.
- v1: https://lore.kernel.org/all/angLZrg_1yeCW0ig@v4bel/
---
 fs/exec.c             | 7 ++++++-
 include/linux/futex.h | 8 ++++++--
 kernel/fork.c         | 2 +-
 kernel/futex/core.c   | 8 +++++++-
 kernel/futex/pi.c     | 7 +++++++
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c7b8f2d6366c44..42eb98fbd12593 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -65,6 +65,7 @@
 #include <linux/io_uring.h>
 #include <linux/syscall_user_dispatch.h>
 #include <linux/coredump.h>
+#include <linux/futex.h>
 #include <linux/time_namespace.h>
 #include <linux/user_events.h>
 #include <linux/rseq.h>
@@ -857,8 +858,10 @@ static int exec_mmap(struct linux_binprm *bprm)
 	exec_mm_release(tsk, old_mm);
 
 	ret = down_write_killable(&tsk->signal->exec_update_lock);
-	if (ret)
+	if (ret) {
+		futex_exec_release_end(tsk);
 		return ret;
+	}
 
 	if (old_mm) {
 		/*
@@ -869,6 +872,7 @@ static int exec_mmap(struct linux_binprm *bprm)
 		ret = mmap_read_lock_killable(old_mm);
 		if (ret) {
 			up_write(&tsk->signal->exec_update_lock);
+			futex_exec_release_end(tsk);
 			return ret;
 		}
 	}
@@ -896,6 +900,7 @@ static int exec_mmap(struct linux_binprm *bprm)
 		local_irq_enable();
 	lru_gen_add_mm(mm);
 	task_unlock(tsk);
+	futex_exec_release_end(tsk);
 	lru_gen_use_mm(mm);
 	if (old_mm) {
 		mmap_read_unlock(old_mm);
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 51f4ccdc909272..324f49493cbb43 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -72,7 +72,10 @@ static inline void futex_init_task(struct task_struct *tsk)
 
 void futex_exit_recursive(struct task_struct *tsk);
 void futex_exit_release(struct task_struct *tsk);
-void futex_exec_release(struct task_struct *tsk);
+void futex_exec_release_begin(struct task_struct *tsk)
+	__acquires(&tsk->futex.exit_mutex);
+void futex_exec_release_end(struct task_struct *tsk)
+	__releases(&tsk->futex.exit_mutex);
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
@@ -90,7 +93,8 @@ static inline int futex_hash_free(struct mm_struct *mm) { return 0; }
 static inline void futex_init_task(struct task_struct *tsk) { }
 static inline void futex_exit_recursive(struct task_struct *tsk) { }
 static inline void futex_exit_release(struct task_struct *tsk) { }
-static inline void futex_exec_release(struct task_struct *tsk) { }
+static inline void futex_exec_release_begin(struct task_struct *tsk) { }
+static inline void futex_exec_release_end(struct task_struct *tsk) { }
 static inline long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 			    u32 __user *uaddr2, u32 val2, u32 val3)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a9a5af..d2736b24ff7520 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1510,7 +1510,7 @@ void exit_mm_release(struct task_struct *tsk, struct mm_struct *mm)
 
 void exec_mm_release(struct task_struct *tsk, struct mm_struct *mm)
 {
-	futex_exec_release(tsk);
+	futex_exec_release_begin(tsk);
 	mm_release(tsk, mm);
 }
 
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 128c5752f225c2..a920dfbd0390d5 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1539,7 +1539,8 @@ static void futex_cleanup_end(struct task_struct *tsk, int state)
 	mutex_unlock(&tsk->futex.exit_mutex);
 }
 
-void futex_exec_release(struct task_struct *tsk)
+void futex_exec_release_begin(struct task_struct *tsk)
+	__acquires(&tsk->futex.exit_mutex)
 {
 	/*
 	 * The state handling is done for consistency, but in the case of
@@ -1550,6 +1551,11 @@ void futex_exec_release(struct task_struct *tsk)
 	 */
 	futex_cleanup_begin(tsk);
 	futex_cleanup(tsk);
+}
+
+void futex_exec_release_end(struct task_struct *tsk)
+	__releases(&tsk->futex.exit_mutex)
+{
 	/*
 	 * Reset the state to FUTEX_STATE_OK. The task is alive and about
 	 * exec a new binary.
diff --git a/kernel/futex/pi.c b/kernel/futex/pi.c
index 795011ea1202f1..d97611196b34ac 100644
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -465,6 +465,13 @@ static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
 		return ret;
 	}
 
+	if (IS_ENABLED(CONFIG_MMU) && futex_key_is_private(key) &&
+	    READ_ONCE(p->mm) != key->private.mm) {
+		raw_spin_unlock_irq(&p->pi_lock);
+		put_task_struct(p);
+		return -ESRCH;
+	}
+
 	__attach_to_pi_owner(p, key, ps);
 	raw_spin_unlock_irq(&p->pi_lock);
 
-- 
2.43.0


