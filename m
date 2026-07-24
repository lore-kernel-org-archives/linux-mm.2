Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34BD7C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818B66B0099; Fri, 24 Jul 2026 18:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9A46B009B; Fri, 24 Jul 2026 18:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9206B009D; Fri, 24 Jul 2026 18:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0B46B0099
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:02:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90DC9C01A7
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:32 +0000 (UTC)
X-FDA: 85025044944.06.D565AEC
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA7D54000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Iq6kod3b;
	spf=pass (imf07.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAzNTf9Ao1Jd+i4HQ1y+PwV6f9J/K6SmB5ui1Xz+21c=;
	b=RICG3DqSnyfXljN4MhAuz0D5YheSuBR7Zhq+0FyKD08OEeIx9YlBTNpj43HVtZsdzo3+cP
	ucSX6X5aXOS57OWWZjrTvyBKwbBGsTqyWt+8qTEYYTH2wfnhYbDYDfey6qoh0yjmStdRbx
	BMkFd4TAs4hyDiFWiL1DkXs6yL9jXjk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Iq6kod3b;
	spf=pass (imf07.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930550;
	b=XmD9AY+pmVp1gXlKPYVKP5/sfSR+gESJFGl8RxK54p6u14j+xcYtSdBxXyl9hzywQ+V2lI
	gjuCM6xbhlgl6tfCZnOfSkeToRUP1ntxik5Kf6mJBjNZQhZbAPMQtRECi6dfrfEYWJkKrV
	n+KN2Ghb3+z5VAXTxsXrO4eDfstZKmw=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-848743155bcso422073b3a.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930550; x=1785535350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PAzNTf9Ao1Jd+i4HQ1y+PwV6f9J/K6SmB5ui1Xz+21c=;
        b=Iq6kod3bpEFugU82kTIe5OLGWPX1ujTKB+zBEKiaHEfUN7D1w+Ik2ZZd5U6T7F7xmM
         eAMi9zGcA0cijl36z2YzDgiEEgJgJwsXKf9yFhTWf5wxTVKD149Axt3LeHJndnQ1c4Fm
         VXSOz17wBMSUWpIU0ACXSwhwJGEXEUsW1MCfkPcKrGGVbfW0ZfkADcRpB0tlq37meAQU
         QoRNdxslxLSVP9N1qNTZ9KxsQcAhyCVkipejSiA3bkM4nv72QBG/QNFlRgwRk1k2G+F2
         PwmhnipaqLv1iM3c0guR5PVxz9USghNh2VNe7KwRtwrnoqGt+ERTPsyjpkCbLUfgZ2Qw
         ur6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930550; x=1785535350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PAzNTf9Ao1Jd+i4HQ1y+PwV6f9J/K6SmB5ui1Xz+21c=;
        b=ZB/4SM1nbKoaLFYOpWL8X7JEt3WCOHTargFMeD4nhUnDA3sKn2RKmYNLNUYEU4bs2/
         RekdkpK4FzYulmey16Bat71cg5UFK6xKIRPZONPzO629H/6f0QpRmgPMsMCJznoO5VqM
         LyqhRpX4OmGMm2EdRgsyq0vrxaSeTbJT4Q3aQm98CcRt/dntl7Gm7gyLUIMSe42pi/Xf
         ppb28inGSb9Sm6iAoQkiHu0Vv74gIH+WY6ZaHbVwNkQW/RPyxxxoFpKXhfNg8Qu1FfYl
         1tSziSLYyN2Qb0t71kbZKUPmGxBtXPuh08XvWglPWBw63b+94S1p/xn2xtdg/P+LBAij
         Rr4g==
X-Forwarded-Encrypted: i=1; AHgh+Rrgkk5Pzxz5AEHnUPlNTzX7yhpWa81fKphOgmW6DkutSgu0hbcWLZPK23Xw2k1v+neC5NXTm3t+uw==@kvack.org
X-Gm-Message-State: AOJu0YyWKIeAD7phn6aFouNPdInQ07QtSRvdnV3jMc+59kew0q1lz42u
	vWksiHwbJYlUF7cVnfejhJnRfWgkizclW/CSKyZRwQFdCdbQznB+Zbeu
X-Gm-Gg: AR+sD13fELLrOVdESn0Bl+8PM/nbVIBGxWL+8L8Z5S7h9gbyAH1LgNaAUzEOf1YFuJ+
	p6da1yBnpAnF8TqTmUVkxR7ib++SXTaUH2C5VXopDkI8WlgKDhCMLnnGbIHyqlWR8idBAwDJe49
	OwJpnzdfjdBglu9/u52hJ+L4U6zSd+fJwOOGEqknm+X50UHuT6QAU/4qE015fxd3u3QbiNpEjWE
	ttzc4diYLppN6emi35zA396+vVwrA8Cv1W9Go3szf9zpp9Guyn5p0ioPHgQkUuGf3ea6+KazGXg
	ghfx/07ab7cyIXWQvj5qvqYlcQsZ0NCP8r6TFYSSGRx87bHgLc1q7yY44T25Ysy4Jhq7E0n4Gpr
	daZbYNeWRCQlO8K0198DumGJjRsxMmWlrkBKUDtxh2IJq+u9dCCBDEcDfv1osIS9pcQZfvjyfy0
	WhrmKn+jg+Dore+WWoIjGljdptSrAhTeGaKu4LHvgOSce8wkxuGF6EKL+JuS3I
X-Received: by 2002:a05:6a21:495:b0:39f:59c8:f302 with SMTP id adf61e73a8af0-3c67df10d07mr125091637.37.1784930549615;
        Fri, 24 Jul 2026 15:02:29 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([2601:647:6802:dbc0:546a:e1b0:9574:3a29])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm2962631eec.29.2026.07.24.15.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:28 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v7 6/8] seccomp: re-validate a redirected syscall against outer filters
Date: Fri, 24 Jul 2026 15:01:45 -0700
Message-ID: <20260724220147.214396-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
References: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA7D54000E
X-Stat-Signature: 1y3h6o7jx6yarr96b96r9a5wymrbp83b
X-HE-Tag: 1784930550-24309
X-HE-Meta: U2FsdGVkX1/O9PcZZmDJNOEQ51aI3uCtmGOeCEBReyDzd+fm6e6b6LFdNDvYmCswQeYMrSUjg7Rx0212UFAtnZ3x+ZydUQtMobijydFmgYkO9mftk7QHa/USLlzgX/kuB4iw0fcQZ25xjjuW44aB4EldH6OrEcMKCDaXroDEkGQw9/sbYqdNKapuyd1+nBuqPGgg0yyNbFlNdicQ6BAiE0XDUe2UzmsNkdCQYDs4gEiMeMXO3rzPW8+JfGwgxyQXycgojlUeULS28qNaZ7P9yWok2jmqqW6U23igR2OK/F0N59dIrc+RLn4w6S/fP6/Ux6IMxk1uL0y/M1c1pbExI+z0IJH+l5U+J3XFOh0mSEkaXrMvlsZ75vicQtcYQnkgzQn9ETyxFOPM9KbXfAHQIaRwxAPfc53wd+9J8aG8dPmgqngrlaum4P8p+ZDziTkQ3CnJztrx2W+u3IGfODFFGlZbN1Ko8NWwVl92M3zOwOSe0yUzkI2LuWPgLaKTyf3hmwJ5TNk8X4oxDErFiDfJ5zBE/0NEu7lM6m8BmOX8yjqI2BcQgf2vsE+f7nLUP5H3m2YHF2IgG//sN5yeQrtJhnZRlMD3/UyTaIo37BFeFwIRc8dydY/gllaxJtsGsAcDTJLCZy/pHpKNvFQIwGy0GE03xg3udEEgwdIvXiR8X3yMV9lJNgBeU5eGc6P9JW8hOgCDDyBeP4q6ynRqwViYeN977rKW5mmTRlfTnEu4J8EBpbUgWiiwRcBfnkbxq1Udhmx0nE7+qIN6ik19zuBrRdktQ9YX89raiEfVvDc5w0h//fbJf7jk6ULfSDRaUiGyZJrYbl4nCt8z1Z4uxCLbQdqMU6oFf3vxfpBhcsXnHFz6vtAhhO9254vv3X2EnuJjvSI8E4h4LtdGan+lzFzDyQGxHm2n2pvuGUqZhjIuIkgq1KkZZstFzh+m+M4TPO4sQGGPxDxKbPSeTw9BNvP
 +bINBu1F
 GjOP4rGEw9Q2rltjmh7iylI9lPu/lLo6zx3Ow9yrcgVoS87YyZdgPZfcNubHW2HQvadn/zCpR6C68xcFC0Mt8TUrnJywzTJgnK++7flqLVaKWfFmr2vV4ah9kX5M0pZ1DMhuWSxUI24aLyd6zbl4r/t6TjxbmlpHexwisfXU5wsS9XZs4isSAgU1QFp0dHfila2zreVpEuqDhBlG59tGtyKAvZXUMcwc3detzJOidy2EnytnpYYlmQwSJ4lNib0Rq7imC14hKktVd0DU/Q6/yxB30qwaMhXnfGlsU08GQzd++LgWrNnFwnYV/1ATNlJGHZKpaA54q+stJ4QuryMQ8CXKaCTKhqgVy7A1/xhhgjye9KAgbDovflpxWtFqEGEBbIDsN4DHZoaCbVSqoqbR0D9X2ajI15+0fiT3AJlulocCeo5UFIS4gYWl6jfMDax8MnMTrnUcLfoMAthvkRvMMxOnCoHduvJvjqadR
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
index f23dbee12ab7..2475aff55ec2 100644
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
 
@@ -2223,6 +2333,7 @@ static long seccomp_notify_send_redirect(struct seccomp_filter *filter,
 		goto out_unlock_free;
 	}
 
+	knotif->redirect = true;
 	knotif->state = SECCOMP_NOTIFY_REPLIED;
 	knotif->error = 0;
 	knotif->val = 0;
-- 
2.43.0


