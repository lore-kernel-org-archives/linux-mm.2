Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62912F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F276B0092; Tue, 21 Apr 2026 19:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57356B0093; Tue, 21 Apr 2026 19:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D13E6B0095; Tue, 21 Apr 2026 19:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC8F6B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:02:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A58713C890
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:54 +0000 (UTC)
X-FDA: 84684089868.21.13336F4
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 408F140005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bu7/mPaj";
	spf=pass (imf12.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776812572;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwpK6htKdPchlWbZaSeEAHqzDpDsOuggPLlaoXdeCJA=;
	b=GZvGdSZH4A9GFszFHknmPSqwQcIVPVN3Z/P6e8ayUUPflqkO/T7PfcchRVipn3HSYLPgpk
	l76LXH/1lJ9gbbqtQvOpUG6dgRMpUlz/we/PsvjtSGb05u6UNLS9E99G5x51Iy+76zZoDK
	GBYXs0F5cJpaVDH2/lY7sYAkTA9IBg4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bu7/mPaj";
	spf=pass (imf12.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776812572; a=rsa-sha256;
	cv=none;
	b=CdvcqItFR1X8RQSoppErfv7G5C1oE/Q2VhDi2N4WXF/pYRHh01kRJTDDrl9jo1RoifxZXk
	mdT+pKysJVDucPm8ZTpQpau2oycb+j17Yq2SByfZnYQMPCCdQ4icLk97MSEmG+QUKDjFWu
	vKKF9JRv5r6Wa52JAFQHHRWpb1zHbqw=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12c7212836bso12630259c88.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776812571; x=1777417371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lwpK6htKdPchlWbZaSeEAHqzDpDsOuggPLlaoXdeCJA=;
        b=bu7/mPajtBMxaT9vY8ZSkHJT9MHIr1Jx/uXE120Hp97GlFvETcCZUo3zWeUH7x5GyE
         yqCW+7ryntgJczBN3TFAv2rqcX++smiB8SM4VMZDCjY1iL/26i1GQySXrrKO2315RTXU
         uff0Ejfk2w89a7tc9dH0NxIRCAu8bxt311kzwCDhZnXrsbWAXAw4821TZ9PMHZv67N2e
         WxXC2/Bts0grXAj6Vkgpp3/UjITDdWrka89sQWNbdhueiQRNHXJ+llv6A12tVQ7R4vnr
         UUf8YgShGwDbvY3ciqSvnZn+pJEBdhODHXSrCZkCroJlFuM4rF8cWNjxfcFfkqX+KyOx
         L75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776812571; x=1777417371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lwpK6htKdPchlWbZaSeEAHqzDpDsOuggPLlaoXdeCJA=;
        b=jOraKjzF9F0Jp5JRwqloqBBpGnfZAUjOXWmXBHa1i+/fyt8jL0XWUE3nsPnFICCJuf
         eRszux9Xc92zUIGGdFU8JapwB3zrgVY6BGcgh6CWXEKfPtPji+oexgY4oXMOT+L6fCCK
         1NnjUUs9DhAG9AQy23ds81GKojm7P0Sra/8E1cEQ7gW+4kxOMjHBLX22Hn7Wi3me1YLw
         gJowjYXrAwsZdqk5UPUR6hXKgc3xqhrS5+1BToQ5Mz6HikevltGZ5qMZn7b8Nt/C95UC
         fuhpvLblz0Ar5F5jfbUoFKZhABHiigRT70yVlUz3ytmFEAkA1MxGbsH418pr7lDxetTA
         zpfw==
X-Forwarded-Encrypted: i=1; AFNElJ927XtIjst4CxXXqTg/9W4WzL4yUVkrgGqHALJ/7mDhtynwuwbtunR0LY23jNDF9YZ18MfJyl4p+g==@kvack.org
X-Gm-Message-State: AOJu0YzY3l/CC2tzbaMonF/QqGNB7mjC2PVReu7XDTb10QT/tQZoJkMZ
	QHSCtCmgrCaR3Izx6DIV5GeCBex0NKHWK+qXC64NuD/ep9uEGXaBzd9Y
X-Gm-Gg: AeBDievSIFMnVZBMaRfmgeBIAq84w6h5h6cIYO6xBARbSYW7OVDX066ToNFAS+xQ4j/
	CSg+QSM9A2CpYOKq90oM78BVAdrmrK57HGvtsI9MC1L4h4YyJ7VCOipL7Y4mn8AHgEz4vuhaS0n
	9nHDwetNoqiSVahXBkFtsolzZ9OZpBkTZlWZT5PPcEig3CzoyqU7yTWNA0DeHbE/d20J/CESg3H
	ary1uPJcwAYQXxb5snCEwKubVQxuFAwoGju9B/OGnlJyx+aM2hnHOrFYyXZmI5ae8qr89edhQPx
	B1jMbh1P55BDhVgjix1yZX4k0DfOU5BxYYLlF0C2Al4sLGN/bBLsUT2oeohc/g7IpMDJ/0ZoNEr
	a+rA11uHwfUO7BCXzwnCjZRIZaH2NraEDpmVX4VdhQqTCJ96mjtp2mLyZCieEw7uOwd8crEVtwS
	7M3tpOhmpRS4LM3PX0Ud0LqIHnW24/23JAAx0sJ3eIrb3OZKYeX4DVLlvWIHF4/BEKAmuXy7iRm
	KLbAOk5AduoGQ==
X-Received: by 2002:a05:701b:2415:b0:12d:b26f:cafd with SMTP id a92af1059eb24-12db26fcc16mr2120556c88.5.1776812570960;
        Tue, 21 Apr 2026 16:02:50 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:4678:d28b:b946:bcc])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c74a20eb5sm26453546c88.14.2026.04.21.16.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 16:02:50 -0700 (PDT)
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
	Minchan Kim <minchan@google.com>,
	Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 3/3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
Date: Tue, 21 Apr 2026 16:02:39 -0700
Message-ID: <20260421230239.172582-4-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
In-Reply-To: <20260421230239.172582-1-minchan@kernel.org>
References: <20260421230239.172582-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ikmggstqgyz6zrrtsbs8dwpcf6n1ofmk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 408F140005
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1776812572-320011
X-HE-Meta: U2FsdGVkX18aY1euG5uZ/2WKiTUMeHQVTCi7qcqBxa0caWbtsYm/7ai1viJzVX3hojV30MWYzDGhJdpijFN44eYh0YOLcgw+G0EZB1+9kpcLpQ9v/fXYDHrT8vUySOOm6p49yMnWd5ltX8UsD7KGbJwMxwybPvRI8EcFBwjJy9UYyvtPtM5Jnm3XQDiKhaZQX6OAHJ5J2YORpOXh9IXLu50fIZOKekWrKoibLT+uAjEexdBbYazojJ4KQ+UhFz2z4t2f981UxVqtlAg/HG6g6ml/7TgFI2KBIMZBELThwGFsUYystWv1OJ16n6BbV4Jy7F66G1coYVzs4FeZts9vSEtVbKCscJVv3WLciaVY+ydbK5Bp2gYtGeAXH9DHWFC/2JpubRzIxInCeIyQq7somwJMXrn8YfFLxYyVV7YsUjX6dou1rfMmAz6tHbft/Oetx720vIv5k1k0dc1/ebmf4NzUCJJuoLQkjMLP5Rlj5vRmeNtNkBExwlox907ktXBJffbodcFbpiGpIWCVAswkr8DKB5otpdU32itiekfJjTAbEOu2fayk1fGZT6Dr0xfDDoy+Tnso/hF0nzbj5vTl0tgbZT6WLxOIw6K0vzCXnbp4bpwSNVVti13A9chHh4xG7TRJDMKxbzOaiQwFjBoquL9WYcaSYY8uAGIwhNIXHQTnOSxWijnG4/n1eIV3In4zue77/v18wJj26038DYtt25Lnc9baq4uMxmFXtYWLkeSyRwWmUknUrI1/mmoBaXD7eJLtFDMWrNBOBtsXV3GMWkqZvQaI5SECdGmPEX+pUMrD+w+pCMxnaOkowAu8nRJzAXBGDeDXulCskCYodXB0fG9PH38XJrowj5cnW7GeFAm4uRo5N+PfqqQpwu8Qr/PJ3soeYSxb4d6aylGIzN7rIlmVB/P+3m1xC28ywK6ONeZyUAp6zb3vPrLwpkhTEhWRBeW7Qtmcbk91GbSasSI
 uHuGdApQ
 lf/eH1gyPn7Ui/plPgNxaMTRomcsfih/dxO5VHRxteBwx5/Gq9g5s3s1GZ2ATnTQbH9k0iTvnB04oCS7FJce+HbvaZmayYjGiR+pJeB50pfe6gNMqumzvFHBN1OM+a4kxF1UQCw2Ah809Q5h77RV1eNwR9k0cPY9tXjxGpi55pbY2lzhUOL/HT+woZ6ePaIjYLIuQ/DUPR1SqTefT1T2ggI7cvF36IjKs4QclthpF0cWyjVSQ6nsf3DEYUCJYWAQA7OqcAb4EJwMbQ5dQHuolGSSShiHIMqxlt+rH9js1dcksMMR656Lo0tXxsSSX1zdanU0DKLCnbxWpPeG4dXTIFXTrS22D05rtu4s04vk7KgT0J19rsclypPgJAvXWNhf3WRvburF2Xde1SpMxzrSka/PHgV/6mrlmk5fYZwcI5quZZgdAmkbJtxvaSyE9jsbjKzAFemlxj6FrNWT1CmtR+u6ORhpmRWch/qOlbDc1bLByOFpDaEjOPT1QIAI91mHoTU+zOfAipq8Sr81QGGE9wX3hX4sM0Xg/JacbcJ1h0pGLTi+uJc5LHo2GjD5UNtg+Ca/o+7nmURnFGbwnLcBtHmJfndgAAVZlou9QlB2EzOIsnT66QnFrvHmB/AzZPka/fuiVBzft96JoBctdov12xcqI2bsk6QfqebWoMdmJpfpY+ermO6jfBKI7Zph17+rVRQe2PQ7JjeRNplU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, process_mrelease() requires userspace to send a SIGKILL signal
prior to the call. This separation introduces a scheduling race window
where the victim task may receive the signal and enter the exit path
before the reaper can invoke process_mrelease().

When the victim enters the exit path (do_exit -> exit_mm), it clears its
task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
leaving the actual address space teardown (exit_mmap) to be deferred until
the mm's reference count drops to zero. In Android, arbitrary reference counts
(e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
VM accesses) frequently delay this teardown indefinitely, defeating the
purpose of expedited reclamation.

This delay keeps memory pressure high, forcing the system to unnecessarily
kill additional innocent background apps before the memory from the first
victim is recovered.

This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
an integrated auto-kill mode. When specified, process_mrelease() directly
injects a SIGKILL into the target task.

To solve the race condition deterministically, we grab the mm reference
via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
victim from calling exit_mmap() in its own exit path. This ensures that
the memory is reclaimed synchronously and deterministically by the reaper
in the context of process_mrelease(), avoiding delays caused by
non-deterministic scheduling of the victim task.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/uapi/linux/mman.h |  4 +++
 mm/oom_kill.c             | 56 +++++++++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 17 deletions(-)

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
index 5c6c95c169ee..730ba0d19b53 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -20,6 +20,7 @@
 
 #include <linux/oom.h>
 #include <linux/mm.h>
+#include <uapi/linux/mman.h>
 #include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
@@ -850,7 +851,7 @@ bool oom_killer_disable(signed long timeout)
 	return true;
 }
 
-static inline bool __task_will_free_mem(struct task_struct *task)
+static inline bool __task_will_free_mem(struct task_struct *task, bool ignore_exit)
 {
 	struct signal_struct *sig = task->signal;
 
@@ -862,6 +863,9 @@ static inline bool __task_will_free_mem(struct task_struct *task)
 	if (sig->core_state)
 		return false;
 
+	if (ignore_exit)
+		return true;
+
 	if (sig->flags & SIGNAL_GROUP_EXIT)
 		return true;
 
@@ -878,7 +882,7 @@ static inline bool __task_will_free_mem(struct task_struct *task)
  * Caller has to make sure that task->mm is stable (hold task_lock or
  * it operates on the current).
  */
-static bool task_will_free_mem(struct task_struct *task)
+static bool task_will_free_mem(struct task_struct *task, bool ignore_exit)
 {
 	struct mm_struct *mm = task->mm;
 	struct task_struct *p;
@@ -892,7 +896,7 @@ static bool task_will_free_mem(struct task_struct *task)
 	if (!mm)
 		return false;
 
-	if (!__task_will_free_mem(task))
+	if (!__task_will_free_mem(task, ignore_exit))
 		return false;
 
 	/*
@@ -916,7 +920,7 @@ static bool task_will_free_mem(struct task_struct *task)
 			continue;
 		if (same_thread_group(task, p))
 			continue;
-		ret = __task_will_free_mem(p);
+		ret = __task_will_free_mem(p, false);
 		if (!ret)
 			break;
 	}
@@ -1034,7 +1038,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 	 * so it can die quickly
 	 */
 	task_lock(victim);
-	if (task_will_free_mem(victim)) {
+	if (task_will_free_mem(victim, false)) {
 		mark_oom_victim(victim);
 		queue_oom_reaper(victim);
 		task_unlock(victim);
@@ -1135,7 +1139,7 @@ bool out_of_memory(struct oom_control *oc)
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (task_will_free_mem(current)) {
+	if (task_will_free_mem(current, false)) {
 		mark_oom_victim(current);
 		queue_oom_reaper(current);
 		return true;
@@ -1217,8 +1221,9 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	unsigned int f_flags;
 	bool reap = false;
 	long ret = 0;
+	bool reap_kill;
 
-	if (flags)
+	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
 		return -EINVAL;
 
 	task = pidfd_get_task(pidfd, &f_flags);
@@ -1236,19 +1241,33 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	}
 
 	mm = p->mm;
-	mmgrab(mm);
 
-	if (task_will_free_mem(p))
-		reap = true;
-	else {
-		/* Error only if the work has not been done already */
-		if (!mm_flags_test(MMF_OOM_SKIP, mm))
+	reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
+	reap = task_will_free_mem(p, reap_kill);
+	if (!reap) {
+		if (reap_kill || !mm_flags_test(MMF_OOM_SKIP, mm))
 			ret = -EINVAL;
+
+		task_unlock(p);
+		goto put_task;
 	}
-	task_unlock(p);
 
-	if (!reap)
-		goto drop_mm;
+	if (reap_kill) {
+		/*
+		 * We use mmget() instead of mmgrab() to keep mm_users > 0,
+		 * preventing the victim from calling exit_mmap() in its
+		 * own exit path. This ensures that the memory is reclaimed
+		 * synchronously and deterministically by the reaper.
+		 */
+		mmget(mm);
+		task_unlock(p);
+		ret = kill_pid(task_tgid(task), SIGKILL, 0);
+		if (ret)
+			goto drop_mm;
+	} else {
+		mmgrab(mm);
+		task_unlock(p);
+	}
 
 	if (mmap_read_lock_killable(mm)) {
 		ret = -EINTR;
@@ -1263,7 +1282,10 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	mmap_read_unlock(mm);
 
 drop_mm:
-	mmdrop(mm);
+	if (reap_kill)
+		mmput(mm);
+	else
+		mmdrop(mm);
 put_task:
 	put_task_struct(task);
 	return ret;
-- 
2.54.0.rc1.555.g9c883467ad-goog


