Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5FAFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395C36B0088; Wed, 29 Apr 2026 17:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D986B008C; Wed, 29 Apr 2026 17:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CD76B0092; Wed, 29 Apr 2026 17:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 147006B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:14:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99D7D40112
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:14:26 +0000 (UTC)
X-FDA: 84712846932.08.5564BB6
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id ACC6740006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:14:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SiCedBsj;
	spf=pass (imf07.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497264;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0jlWaNcc6qDFBI62ibD+GVbVAHZzVlW6Nqyi6nQpvzc=;
	b=gc438iX7o7cKzli3ogk7F3yRqAN+UiUZVTPkzZkkfEm1Nn7E4eOidDT5uk/akt4bBVgovF
	H3eq7JuYVlO1/0tLWC7OyO/2rv2x94CI6amOVojK/errR8v6hZ2IFsmwikAEVBT9/K+Yh5
	dH32RduprQToL347VJHFrKeoA66qkHU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SiCedBsj;
	spf=pass (imf07.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777497264; a=rsa-sha256;
	cv=none;
	b=1XKeYg0bzsoZHBVxDQKnFAJKpTnV12/DnshXQK6eJ5G30ZkwIkdof1Hp8RjM6zg2I+aptg
	a8bi7iEhWjkIX1mkDuINYdREf3gpyrpEv5bYvH1BDHgmQnKbOKd5Ex7Djma+hBHdaYGEqP
	VrrCwDFdzpho7sdS+W1dQoeCwO2t5EA=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12c45281a06so358754c88.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777497263; x=1778102063; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=0jlWaNcc6qDFBI62ibD+GVbVAHZzVlW6Nqyi6nQpvzc=;
        b=SiCedBsjmC5Jw0r1bTh/LZWBpzqKStvvxbxEpHHrHhwcVKb2VnRg+NBTcCD20Vzyj7
         W/QEe7ugrX2Wnyn+kRQd/2Ykivk2/5/LkG5AaMWz4sXsbqp28UkuSDcUDpUac5Nwxt/y
         TMEW3Iqqn1d38UPYjEo9JqJfSJ//Tnz+bDl1E/warnm7o1375rO6sTrznWkfhkGvaCKH
         tl13+gNMNfbnHw470jbjReFUwNRMujOZaPuvLZttU4bkEheXetEBver5kWMNGugJdKgo
         TFXlX9CKXEZizOcFUEkHlmUPfpzqjV0mraw863t5glNKhaBxEoneh1dAdpZCO5mQEo/P
         91Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777497263; x=1778102063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jlWaNcc6qDFBI62ibD+GVbVAHZzVlW6Nqyi6nQpvzc=;
        b=c0AbXGMQmDA7Af7zutiiUhYIIqJI9cfULoFnNOxzWIf4yqYzF0y1UjxBeylbkb8JiX
         5kUH1T6JCzUfZO8CVwxxiq617tAoQ84pL/i5y0/HW4qgdHRwj97iaZPXXmDN1bPWc6xv
         g26p4mD8iz4o9ubwjZp126Iv+BgbcjvvVvamWqQsB9XcEBL0qfySjDBiorDIPrUO1cKu
         aoDoNA7/OM7S9AVlgR8ZL/wOT9aAsNGOyNy2PZQnPIV/JsonYiUACCJ7SKkYUO1uUDRU
         hXeQBLr27dFntlWdwdlEI0RdizIA/XjSV1z7KSJW6Sdw6FLzvFQk3kHrGhtivJvvGy5p
         fHPQ==
X-Forwarded-Encrypted: i=1; AFNElJ/OfWyZFJgcycUCV+jLwcPrsIOiz6K+ybOSgtYtq3qMDpFy9LTg2pnJnyE2TymKzZ3KfNVZlkyMGA==@kvack.org
X-Gm-Message-State: AOJu0YxMfoeslm7bmtRKgwQFzdhw8cCK2XTqqZgkxy17ij6Ldi1fQeeD
	r02bY7j6lVgeIjNUH6Hy7E2BmmXeSJqBPY2LlpVFAZZzSq6lj9jIaTok
X-Gm-Gg: AeBDietvr4+25XreZwbYPajhmJ0NgTcvOubgS9lU+9HzWaQGUoT29DBZ42GUHIdb8A7
	QE0a+oWZHtQYjhSuJ/nhKcDsjyoxdcP+lIjecoXsj5pIFigvMpQHGuw6dtLsuOQSm0PZCOwSJEo
	ev8JXjoKIlcuKobuzmokhfJbLQ9PkjAiKcxTj9Hk4KEUHdvYPiOp9ktW9QilpzR3O7ovMHqq6ri
	RTMnE3rpQJk2hVvQygL2eI3XUqUaLjEPPF8tyjIjqPgohV0evs70MZEvzjjE1S4zbZdOzKZzm7r
	7MPJBWWcDNlyhyKRl7D3bRnybTWrfdDUyJP86QJ5qQ4D+/GqSLtl/1O3kKbcqSyDklvHfIAwvgS
	SqXbznOw1jS6O9zRVi6w9H3llSwKWp/H9J+LJ+WW6IEonXAJUUj7+IXAfy18ElTeb9VFXR/nOgF
	hlWQZj1tjuum90bLXLy46wwQ3UFKG2gkSF3y54ykJs/mFqpQXRwEOfqz7sE2Tp6m05+bORe3yS9
	evhsO5PNbSjqsc=
X-Received: by 2002:a05:7022:3d12:b0:128:d715:b717 with SMTP id a92af1059eb24-12deac586damr120667c88.13.1777497263244;
        Wed, 29 Apr 2026 14:14:23 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:ef7d:2499:eb8e:9f62])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de320ed98sm4408879c88.3.2026.04.29.14.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 14:14:22 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: hca@linux.ibm.com,
	linux-s390@vger.kernel.org,
	david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@kernel.org>
Subject: [PATCH v2] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
Date: Wed, 29 Apr 2026 14:13:59 -0700
Message-ID: <20260429211359.3829683-1-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ACC6740006
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Stat-Signature: dw5gmnao4g7wkhb6yjejopd4ed7yater
X-Rspam: Yes
X-HE-Tag: 1777497264-934245
X-HE-Meta: U2FsdGVkX1/mv0VN/kfEwOiy8wmY7hmvs2gkRICVEQft7XFvVFdLepnW3rx8N1ZtWmqZC8ZgV9nq2V4Xdx+i593Ja89UMIyJ7l2zEFdp/L8kY42FmiGcWVg3Qx05IuVAnQXUY1SZW0uIP4f4sHBkdwku4P7MOiSS5WN0OdgD6T/MBe4DIddjBX8L5rTpuUkD04KSRZLHRkWw3iTZz5KRodJ+HtI77ICb0ByoRnqjWGPOkqn2gAno8uLNCUNkFJMXcgXajGKo6/OF/hpoKURlv0qNXAyHt+MnAx0wTkTYhl0tpJ3l90HdbKCJ5pha+gMO80CBdVC1tpl1hLqLdeVPcd6Bko/E1nUnwIx4xUM6DzyHeY11aqIDwgWdhV9tctpXf2Fp2gzr3sktrpSm1oM0JrAmTA8MHR5jI4cqTj532528a8qUiigxNiyvQBOiqW4LwlWLMphUDWo/6CE9iihp4yKds1DkwlUGI5ecxlZ91+SWQBAHJkSH/vRY78U3kIgeyGeP7dgg4WXhlHE34gtDOx73E27zcKxkv+Kbx5adUQMcFn3fah718joLL48IDkLkey98R1xCFiB7N1kQ9g43yVV2acq8Yj/MWuZ2djRWACI8jWOCNgyrO9TyVUEbD3YMvm4ThMaG8EcHFWXypwc89X5s82p6TWXHRP6kX0bJXLTB2y/saiNhm1IX/55FjC4/CnsnYPitakQ8+isOizMp8Vti6k2J6VZEiY0uxl70Fq/CWwBXKrG05a5cphPAO3eYLraelLeQ78C06/jAz1eRH2eSayJuyJ6q9Rbg9KuADtgbA5/Q/rZ1/DJ7Cu7nTGBH32Y0UddpknILQysJdQgJ4aanepXtqK0IXfNDD4pxlPOJvrTlRlsfEsi5Dy5WMzzhM7x1cWatK+J9BPwqJ1JXVUJFd3Q9KBPLQWMlahPUx4tkfAZQxZA7psu8kY/Vq8WVtI1CH+exScgbUI0ZkN5
 u8rx8ZQE
 R3OHPbOTYeLEa5JZTe8mZX/RKPrTyxBDYUkI4QNzeQy6bhTveWclAqcLMHSngPZ+DxQAJfA/jRclIc9swkTvWIGDIs9W7PdVHeb7giPoqjurW0v6kubHKxbuzrRcV6OFxk0uC0yTxMginBo160eALIBlG9b3u1F072nwvU1OUsYsQ4fK9RnEQNgdgFvAzHDB+QuuBtqo8lYRyJ1qT0Hb8X2iW9qt+Enm9YkAIaql2BT+C+2k36etacO/V19N7D+O9esVu2Bek+NebsyY3YAtT12jIVRQvE4pcDBIoSrSrT3XgUax6zh0PqtjEZTQeFiUvfvqsO6eJTu8nTIa3WwXS8wI4fDGyXZdE7gPlBBRxtxba6rSKUWlRaMbSdYS/0aAgMhWZ2Af5wj4o2wsf9DQZTnUH258i048zfsyGPmxrT5hvn9aF625CJCsMv2LriBARntdaCu4byftLmZ4mS68Gqjv6/F7anvCztq+g0fTeMPEg6sif9xzvsbKBV4Grd3+z0gjdFNEI9U4U3dyaN1HGEGSGHFSb8ilJ1sYFElv3wlZAkv2e8z+g7QC3su2DeM4G8KL179WwRJ4Sfu84EuBm1BtyXiZxIYzwGKkwN5gAsWzFyZ8N9CKf2EJl3cimt+PE64T70wgX5KfXtgy2BLF+LF30hawyeyJGvAaB9ZraNnUu0AiBcCxf24ikyZBs4N4FTTprfRYYLQ04HQ6+pfP7HcKaDwdzvwyaD1lx2luNL+hmIA3+YqmoeFM0BgkWBHBsKFc443vvbZrzszTJONa8oP+tAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, process_mrelease() requires userspace to send a SIGKILL signal
prior to invocation. This separation introduces a scheduling race window
where the victim task may receive the signal and enter the exit path
before the reaper can invoke process_mrelease().

When the victim enters the exit path (do_exit -> exit_mm), it clears its
task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
leaving the actual address space teardown (exit_mmap) to be deferred until
the mm's reference count drops to zero. In the field (e.g., Android),
arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
remote VM accesses) frequently delay this teardown indefinitely,
defeating the purpose of expedited reclamation.

In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
the system to unnecessarily kill additional innocent background apps before
the memory from the first victim is recovered.

This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
an integrated auto-kill mode. When specified, process_mrelease() directly
injects a SIGKILL into the target task after finding its mm.

To solve the race condition, we grab the mm reference via mmgrab() before
sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
it will free its memory and proceed with reaping, making the logic as simple
as reap = reap_kill || task_will_free_mem(p).

To handle shared address spaces safely in the auto-kill mode, we bail out
immediately if the mm is marked with MMF_MULTIPROCESS when
PROCESS_MRELEASE_REAP_KILL is specified. This protects existing users of
process_mrelease() from behavior changes while preventing unsafe reaping of
shared memory.

This policy differs from the global OOM killer, which kills all processes
sharing the same mm to guarantee memory reclamation at all costs (preventing
system hangs). However, process_mrelease() is invoked by userspace policy.
If it fails due to sharing, userspace can simply adapt and select another
victim process (such as another background app in Android case) to release
memory. We do not need to force success or affect processes that were not
targeted.

Fundamentally, this allows process_mrelease() to trigger targeted memory
reclaim (via oom_reaper infrastructure) quickly, even if the victim is
not yet in the exit path, while reusing existing race handling between
reaper and exit_mmap.

Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/uapi/linux/mman.h |  4 ++++
 mm/oom_kill.c             | 27 ++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
index e89d00528f2f..4266976b45ad 100644
--- a/include/uapi/linux/mman.h
+++ b/include/uapi/linux/mman.h
@@ -56,4 +56,8 @@ struct cachestat {
 	__u64 nr_recently_evicted;
 };
 
+/* Flags for process_mrelease */
+#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
+#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
+
 #endif /* _UAPI_LINUX_MMAN_H */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..efa6541b1c47 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -20,6 +20,7 @@
 
 #include <linux/oom.h>
 #include <linux/mm.h>
+#include <uapi/linux/mman.h>
 #include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
@@ -1217,9 +1218,11 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	unsigned int f_flags;
 	bool reap = false;
 	long ret = 0;
+	bool reap_kill;
 
-	if (flags)
+	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
 		return -EINVAL;
+	reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
 
 	task = pidfd_get_task(pidfd, &f_flags);
 	if (IS_ERR(task))
@@ -1236,19 +1239,29 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	}
 
 	mm = p->mm;
-	mmgrab(mm);
+	if (reap_kill && mm_flags_test(MMF_MULTIPROCESS, mm)) {
+		ret = -EINVAL;
+		task_unlock(p);
+		goto put_task;
+	}
 
-	if (task_will_free_mem(p))
-		reap = true;
-	else {
+	reap = reap_kill || task_will_free_mem(p);
+	if (!reap) {
 		/* Error only if the work has not been done already */
 		if (!mm_flags_test(MMF_OOM_SKIP, mm))
 			ret = -EINVAL;
+		task_unlock(p);
+		goto put_task;
 	}
+
+	mmgrab(mm);
 	task_unlock(p);
 
-	if (!reap)
-		goto drop_mm;
+	if (reap_kill) {
+		ret = kill_pid(task_tgid(task), SIGKILL, 0);
+		if (ret)
+			goto drop_mm;
+	}
 
 	if (mmap_read_lock_killable(mm)) {
 		ret = -EINTR;
-- 
2.54.0.545.g6539524ca2-goog


