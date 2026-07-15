Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CCCC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635A96B009D; Wed, 15 Jul 2026 17:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60CEB6B009E; Wed, 15 Jul 2026 17:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6096B009F; Wed, 15 Jul 2026 17:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1A596B009D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:20:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 656E1A02EA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:47 +0000 (UTC)
X-FDA: 84992280534.17.142F8C8
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 804FCA000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="b/zlkkQV";
	spf=pass (imf25.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5RNDvczIEN6AYv3qNfijJBXqL18H/yVs14ZVOrYovY=;
	b=KFgoHZX8cQOyxANiUc9Fot2mWmgca3Ps0cb/YpLfeBVma/8MrkLxsikcJBhH3EHj9PVYB3
	wZk485cEo1S5yJHZvt+PpsRPWVIVCum3iCNPkbxwTd6twpaPUwTaxejFCWzIo33WD04LU2
	0DiH4pxodDLYrfTtmpUqdfz8Ygnozmc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150445;
	b=7bObP5/KUel8HEfRabmqEknFx6g9SPGGy/UKvBTO4JVAnNaKkUk0dn3FoP4d+5pNkee7zl
	vQn/TdO+tLvEOjsD34mGLfx7Yz2G3O9Zn3A8hTzFPu37J9JBWaW5UJuSnlsdChDQfWE9C2
	2RNtqIrOUdgYhjPShhN6Ou9CMutYKZ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="b/zlkkQV";
	spf=pass (imf25.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c89636920a3so1542438a12.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784150444; x=1784755244; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H5RNDvczIEN6AYv3qNfijJBXqL18H/yVs14ZVOrYovY=;
        b=b/zlkkQVnD1rEv8+F1fWfwKghVZh4ZMbhIwiETEixJAb89H3Qez/gHa/7J+rfzTvMx
         y5hdQ4pZttWoxiPeLF1U4osPJIInwEz9rikYksc9An2XKsCLD094kKNk6OhsuwcTugBr
         DePW/BQX8/aEr641JQWRmrvhaLFfQPVUgdE4lm0arJ95CpWU3J1T8O4VuHjEklAaXb3e
         Wzn6A7Sn5mLCvSgMJmuiSBgP7NfOagGt5mAQUG/RVRa10WaSZrJ8wdBx9wL5PZTfoTCG
         3RI9TH9b0QkUqZK90iyOtkhHnlpzP6piOPRzDzKUT08T24z9GaWRE37QUrfYLzqivwRV
         aXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784150444; x=1784755244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H5RNDvczIEN6AYv3qNfijJBXqL18H/yVs14ZVOrYovY=;
        b=SPQYGBsvaOBmW3z6t5qphRqtsWfD1B8Du27y2Ba/OqWZHP6cYUUR3TWXZ1HauIRLGJ
         sB+QUaLTZJbHMnd83Gzqn5UcmnCrOfxRjLfPQujU0j8/4dFUSis/mFo9RsXbfXrQWnxE
         j4gX4kCQzaEfVamCrwvSfjiKbD9n+ZwncrIxK230nIPKAz6rVsJPjRv9m9oaB8+LU7lm
         dJgGGgJTSvHLttyMUa6KvuHXre+vII/yGCVMGAUW/MAitYGl2loiyEvTVyrwLJvTqGlo
         Kzy96Yi0Xz5DiBvbAFLlpmB+tYB4uWroilDLs+cDEwhNMzWlcoVT+9bABUsm3XI9X1sL
         JZZw==
X-Forwarded-Encrypted: i=1; AHgh+Rqyin7QkN2Np0EA5ZOqURnwYBcFTnx7VUB+AcWQsDePsb6w6kmNikhPWu/m6/sGmeqmfEO52B7kMA==@kvack.org
X-Gm-Message-State: AOJu0YxxSjeLrBhf6fL8HPAAm/3kcJvumQkYHn0vF81eEJR6tlwa9zEK
	yxhh5uUUDay5IL13kN9a9bt0k4jBxX4Rj0R+Paih34PWFOkj3FnWfjSP
X-Gm-Gg: AfdE7ck7aW/DuB5rrLaMqelDBYjm1I2AY+AUGj+DrsXLAYPC2b145cntKkiH7hqcDHm
	ZE0yHQtxkq68xloJAcrQYv9q/lsZJCY+TgOfLDkG6bSB1THdaHQq9ZjcFxCpmDwHG4T8N9/LGMR
	wrmDjzVt67SE/OlOsHkb0vPO8Uk1GCx/8/EMacbVTLvHYgM5dkFZzRBAZqMp01U7z8PKsexVXie
	O0dajupEuAgdFmOhXe2sPoelto+xUlh9BxJWzojTs1symFn10Zt2eKRU1tlKsqdb2GSKCUV6KIA
	WXKpWiKMMgo5au5B9+4P1XDVGzGl92JA5wC4yq5K+WcRhDEkZhDeVwXGI4ILzwr6WE0ZsJgAGOz
	VpXlguzWzxgscQQC/ezzUOOXNOQ7YqZoejqlUWPrsQeLUEWOG1Ej66j4eacmjUjcOLsW5G7EBxd
	rOMkLENUcW/tA9iJ8B0RlYmH5imKBb/yKCpBgn20qJO+nR9WZsDW9OWU3vWvG0h5pfXTHQ
X-Received: by 2002:a05:6a20:d489:b0:3bf:c12c:2ecf with SMTP id adf61e73a8af0-3c110bafc02mr22625148637.59.1784150444192;
        Wed, 15 Jul 2026 14:20:44 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([129.210.115.107])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd403a7f7sm4126844c88.0.2026.07.15.14.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:20:43 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v6 6/8] seccomp: re-validate a redirected syscall against outer filters
Date: Wed, 15 Jul 2026 14:20:05 -0700
Message-ID: <20260715212007.2382846-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
References: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 804FCA000C
X-Stat-Signature: wfbas3fauo17u67wkrospn43b675hs9m
X-HE-Tag: 1784150445-548643
X-HE-Meta: U2FsdGVkX187DHAN+gZ6dB/mbNtR8YpcMe5AtGhTTERf98CAKeiOGlwc6NbvlYst7imSANSH897C9hcp386CxkHPtpP2FngA0+eCMVFF9qOOIgdnqDiejifHMOnLHlZW27y5ELLgFpoOBRsW/D0SM4j1ywFmwWFHq7FS6v7aC15A7VQM7djRIsaNFH+MbgvLlEq4KAgXJs9zPWe4fZCb8HnDHAS/JmBahylzeBsnldbC9fjOxzsimRfurcBzzPm5ptdUDcXswodLBC4HjZGoccIHNuon3ORbyRPAFjNwln1BdWe1O0vuTttIjM1KNigqKutN/letv1nIhhzVZxgehZRhonNyrhdPu+I4LGDSyaLhTZw5gVBZOovxm3S0VK9Al1pQLGktbRNUVkFuIVZmRImyTtl6VN5Qgk0V3TQp8tawkhdg1e6wE5TVYO7v7SNguxmOqG2+odRiMYLK3w85hau3JFCvh+hOayQQqplR1nwSR6epyE65bkChr6ci05wKO+nvtdgloXPO29WdJOyF5+n0HFhHxWW9/fdpwl0H5DxcanljQytqifhV4WHIzKWst6F84JQ7J4ANPQFEYgDQ56s6nBdfeS0Zd/KukDdtQ3euqYeeVmzdbJihnQMvZ7EYZ7R7FH1aMKcAi5sv7eRhMPYU3hOhC8kfvpthgjKxBsuajlB6BikOYEnuvlPNnMot65npmwqWUL+JCKqc5kzYlgobv8H9j54zPTzTF0cIYnfDCfB3SPzhQ08ph0TNET9QyU9F/11WPoUOb9Kd/SAGzbDgHh7PHx4jyakhm4A8BxSO2sSRje9aXVM2TCQ5y6wzUDmu89BAB3Gzd/b9QsvYYM7oHzd09tzdEDltjt1jGeu/ayP1yUznM3fa2dJMsgvpRR/NsmYvue4uFO7Rk62+Tj6hPS9HvTKi3HRR1VgG269CHQm7YcJVE3ULttKInTWfA33da0FgSxdOkB2bJHc
 eR+mQyGC
 r8IybNLdJKbakzp6N4punf1GRPE+14FCk1eW3rNOSKvrYDndjONL+UFTBqz/u/ZMm9ENwTvBoaKYX0O5Le3tsbsBXWAvtD9Lci+qOGFpZgkGwBytRYD5YCOXm83Nz4TzZdNXH/v/UiuRUaRfIKiue2NHyE9o2EVVcYB4MX19MKf/Nasx6ShqOe10fVeB9zJzWpsn2BfAyOqPnevhOf7F9k7UJ/rVzDqw64uGSAK6BVVtA88DwmRALTZER9Zq9y1LPqE249YC2ItzQ84sdrC95LeTlz1nNdHuKalVdwl9HBDHs2toQVNNHNNKThlSkOACv7QxO4UPAvhuVhaL9N5trKKlkzLWy8a0dzkDnj0K0TYW5sJqYpS9UYGOMTcXKHBdRmYOKbsKHs1uFqFYVtbkah3a0PFNBIcy2mCuRuQpGJFq/21I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Stacked filters compose by taking the most restrictive verdict over one
evaluation of a single seccomp_data, assuming the syscall they voted on
is the syscall that runs. SECCOMP_IOCTL_NOTIF_SEND_REDIRECT breaks that:
the supervisor rewrites the argument registers and the syscall resumes
without the stack being re-consulted, so an inner, container-installed
filter can redirect a syscall into a form an outer filter would have
blocked.

Close the hole with seccomp_redirect_revalidate(): after a redirect it
walks from the notifier outward, judging the substituted syscall one
filter at a time; the innermost filter that does not allow it decides.
ALLOW and LOG fall through; ERRNO, TRAP and KILL are terminal;
USER_NOTIF consults the outer supervisor, whose plain FLAG_CONTINUE
keeps the walk going; TRACE fails closed with -ENOSYS, since a tracer
rewrite cannot be soundly re-composed mid-walk.

The walk is strictly outward, so the notifier is never reconsulted and
no re-notify loop exists, so a deep chain cannot exhaust the kernel
stack. A redirect never changes the syscall number, only the argument
registers differ.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 kernel/seccomp.c | 141 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 126 insertions(+), 15 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 17fe4c360839..b1fd2ec44324 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -93,6 +93,13 @@ struct seccomp_knotif {
 	long val;
 	u32 flags;
 
+	/*
+	 * Set by SEND_REDIRECT: the reply rewrote the syscall's registers,
+	 * so on resume the syscall must be re-evaluated against the filters
+	 * outer to the one that notified (see __seccomp_filter()).
+	 */
+	bool redirect;
+
 	/*
 	 * Signals when this has changed states, such as the listener
 	 * dying, a new seccomp addfd message, or changing to REPLIED
@@ -1183,10 +1190,12 @@ static bool should_sleep_killable(struct seccomp_filter *match,
 
 static int seccomp_do_user_notification(int this_syscall,
 					struct seccomp_filter *match,
-					const struct seccomp_data *sd)
+					const struct seccomp_data *sd,
+					bool *redirected)
 {
 	int err;
 	u32 flags = 0;
+	bool redirect = false;
 	long ret = 0;
 	struct seccomp_knotif n = {};
 	struct seccomp_kaddfd *addfd, *tmp;
@@ -1243,6 +1252,7 @@ static int seccomp_do_user_notification(int this_syscall,
 	ret = n.val;
 	err = n.error;
 	flags = n.flags;
+	redirect = n.redirect;
 
 interrupted:
 	/* If there were any pending addfd calls, clear them out */
@@ -1269,19 +1279,120 @@ static int seccomp_do_user_notification(int this_syscall,
 	mutex_unlock(&match->notify_lock);
 
 	/* Userspace requests to continue the syscall. */
-	if (flags & SECCOMP_USER_NOTIF_FLAG_CONTINUE)
+	if (flags & SECCOMP_USER_NOTIF_FLAG_CONTINUE) {
+		*redirected = redirect;
 		return 0;
+	}
 
 	syscall_set_return_value(current, current_pt_regs(),
 				 err, ret);
 	return -1;
 }
 
+static void seccomp_kill_task(int this_syscall, u32 action, int data)
+{
+	current->seccomp.mode = SECCOMP_MODE_DEAD;
+	seccomp_log(this_syscall, SIGSYS, action, true);
+	/* Dump core only if this is the last remaining thread. */
+	if (action != SECCOMP_RET_KILL_THREAD ||
+	    (atomic_read(&current->signal->live) == 1)) {
+		/* Show the original registers in the dump. */
+		syscall_rollback(current, current_pt_regs());
+		/* Trigger a coredump with SIGSYS */
+		force_sig_seccomp(this_syscall, data, true);
+	} else {
+		do_exit(SIGSYS);
+	}
+}
+
+static int seccomp_redirect_revalidate(struct seccomp_filter *notifier)
+{
+	struct seccomp_filter *f;
+	struct seccomp_data sd;
+	bool redirected = false;
+	int this_syscall;
+	u32 action;
+	int data;
+
+	populate_seccomp_data(&sd);
+	this_syscall = sd.nr;
+
+	for (f = notifier->prev; f; f = f->prev) {
+		u32 cur_ret = bpf_prog_run_pin_on_cpu(f->prog, &sd);
+
+		data = cur_ret & SECCOMP_RET_DATA;
+		action = cur_ret & SECCOMP_RET_ACTION_FULL;
+
+		switch (action) {
+		case SECCOMP_RET_ALLOW:
+			continue;
+
+		case SECCOMP_RET_LOG:
+			seccomp_log(this_syscall, 0, action, true);
+			continue;
+
+		case SECCOMP_RET_ERRNO:
+			/* Set low-order bits as an errno, capped at MAX_ERRNO. */
+			if (data > MAX_ERRNO)
+				data = MAX_ERRNO;
+			syscall_set_return_value(current, current_pt_regs(),
+						 -data, 0);
+			goto skip;
+
+		case SECCOMP_RET_TRAP:
+			/* Show the handler the original registers. */
+			syscall_rollback(current, current_pt_regs());
+			/* Let the filter pass back 16 bits of data. */
+			force_sig_seccomp(this_syscall, data, false);
+			goto skip;
+
+		case SECCOMP_RET_USER_NOTIF:
+			/*
+			 * The outer supervisor judges the substituted call:
+			 * an error reply skips it, a plain FLAG_CONTINUE
+			 * keeps the walk going, or this reply would slip the
+			 * call past a stricter filter further out. It cannot
+			 * redirect again: at most one redirect-capable
+			 * listener exists in a chain, and the walk starts
+			 * outside it.
+			 */
+			if (seccomp_do_user_notification(this_syscall, f, &sd,
+							 &redirected))
+				goto skip;
+			continue;
+
+		case SECCOMP_RET_TRACE:
+			/*
+			 * A tracer may rewrite the syscall, and there is no
+			 * defensible way to restart composition mid-walk.
+			 * Fail closed exactly like TRACE with no tracer
+			 * attached: skip with -ENOSYS.
+			 */
+			syscall_set_return_value(current, current_pt_regs(),
+						 -ENOSYS, 0);
+			goto skip;
+
+		case SECCOMP_RET_KILL_THREAD:
+		case SECCOMP_RET_KILL_PROCESS:
+		default:
+			seccomp_kill_task(this_syscall, action, data);
+			return -1;
+		}
+	}
+
+	return 0;
+
+skip:
+	seccomp_log(this_syscall, 0, action, f->log);
+	return -1;
+}
+
 static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 {
 	u32 filter_ret, action;
 	struct seccomp_data sd;
 	struct seccomp_filter *match = NULL;
+	bool redirected = false;
 	int data;
 
 	/*
@@ -1356,9 +1467,19 @@ static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 		return 0;
 
 	case SECCOMP_RET_USER_NOTIF:
-		if (seccomp_do_user_notification(this_syscall, match, &sd))
+		if (seccomp_do_user_notification(this_syscall, match, &sd,
+						 &redirected))
 			goto skip;
 
+		/*
+		 * A redirect rewrote the argument registers; every filter
+		 * outer to the notifier must judge the substituted syscall
+		 * before it runs. A redirect from the outermost filter has
+		 * no outer filter left to judge it.
+		 */
+		if (redirected && match->prev)
+			return seccomp_redirect_revalidate(match);
+
 		return 0;
 
 	case SECCOMP_RET_LOG:
@@ -1376,18 +1497,7 @@ static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_KILL_PROCESS:
 	default:
-		current->seccomp.mode = SECCOMP_MODE_DEAD;
-		seccomp_log(this_syscall, SIGSYS, action, true);
-		/* Dump core only if this is the last remaining thread. */
-		if (action != SECCOMP_RET_KILL_THREAD ||
-		    (atomic_read(&current->signal->live) == 1)) {
-			/* Show the original registers in the dump. */
-			syscall_rollback(current, current_pt_regs());
-			/* Trigger a coredump with SIGSYS */
-			force_sig_seccomp(this_syscall, data, true);
-		} else {
-			do_exit(SIGSYS);
-		}
+		seccomp_kill_task(this_syscall, action, data);
 		return -1; /* skip the syscall go directly to signal handling */
 	}
 
@@ -2207,6 +2317,7 @@ static long seccomp_notify_send_redirect(struct seccomp_filter *filter,
 		goto out_unlock_free;
 	}
 
+	knotif->redirect = true;
 	knotif->state = SECCOMP_NOTIFY_REPLIED;
 	knotif->error = 0;
 	knotif->val = 0;
-- 
2.43.0


