Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9871CC43327
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 01:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7C26B00A1; Fri, 26 Jun 2026 21:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F816B00A2; Fri, 26 Jun 2026 21:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4956B00A3; Fri, 26 Jun 2026 21:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CAD26B00A1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:22:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9D551C356B
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:58 +0000 (UTC)
X-FDA: 84923943636.14.504FA79
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE27820009
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rXU6MK1c;
	spf=pass (imf13.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782523376;
	b=66UmEuqiUmBycVByfWKwtisFV+py4jTrvjm8YxbDWbmgEFgFySA5MtsW3jgfSeag5xV3yI
	dj7ImDy+ZVkj1eE/snlj7K6k+8J5411BQeMg5ZQKjG/q7kmfKEH7SQpbZA9qo0BM6Ylj8s
	l2rDEMdmafaz4vCQG3mdLTxXzAh/Gcc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782523376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRrGpKZ+abQ6YTR/WwGAxpwqxu+0Is3sCqTd33CTxkE=;
	b=xTkA2gG4D1J24+nnGy0Bd8niHGCimB2oPcyf/DJs8bT6y/j1vnOXsrHnMrTjm24M7/IavP
	LsvQKK5KpY27nSaMXSWA7q+x1/HpmcKcGfgZrGIRQFGtBjSvsZ6q0EZj7F/JB6RmUY2i1W
	Cz3PXObTLB4aYr/3OLNuK9cpgD64xZs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rXU6MK1c;
	spf=pass (imf13.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30c9c8c2697so1710856eec.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782523376; x=1783128176; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRrGpKZ+abQ6YTR/WwGAxpwqxu+0Is3sCqTd33CTxkE=;
        b=rXU6MK1c+Fd090ruxiLMiD9PfHhcL4slrN2kdoqa1GnRgV9fZceoEfSQlj1NzxvcBd
         kNwGiDG2tBYhdYFXtsEUbVMV1JuI5dIL6hqOMC+/f2PX7OcgxWqg77vpouwtyjvc14HK
         skw9BrfpB0wPpH4e95XWDKhT42Y1mqrnljq/h4/Ak/7a9XidD1cCt3paL0VBAMGA59vQ
         uu+OcXyFPLpkbAGJPAdPmakcYKIK5YkrNClcbWa5s/0qSwN87TLU9j/LAAThlBX7v8zK
         viLogefgqLf0w4vop2yXMHhgBgXKMkqZhBULEy/t3A3kTmkqwIHaOTohdETgpLXA3MXf
         UP3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782523376; x=1783128176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vRrGpKZ+abQ6YTR/WwGAxpwqxu+0Is3sCqTd33CTxkE=;
        b=jBq1UJvrOOQHTQRrutLtgzID3npd5xA9rZVJOWn9PQ80Uj5dibqLfOGN9QV1K1yUQF
         vLO7wCfWhGJ3aVv00u5Y4AqVXJlDnDOsplNK5sc3hAl0UVOzgvce/3ezoC7Zs1eFIjyo
         LJrey+LFXEJ17nRNUpsEcOJ0xdj+VONpc9/DcmQbFL/SbjdOATq/k9zNFz8Wxs3Wcx++
         iLGv9waatVu37yh8rz+qZitD3tuYPYHiLeMe0pApI/W7Kd0RdFgjmB5dGrkyOyVMT6av
         Wli+jAN4Hdis0+2XjJCKeWh7lHPhwLWXBacwE/ki3UVtAawf6WyDnjm3Qai7cEImt1fl
         fRbQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp0M39n57H+paXeFAPrXe5Py7aatmyOaR8PazXJSaZC3uXZUYEVzrutPLC8O1IdbqLvf/bd3MLefw==@kvack.org
X-Gm-Message-State: AOJu0Yw0O5Ag1bbrKpIyQnoO3Hi5+zTZ6oZi1u9GTqj201JlVGtqpAy9
	JNCemCYgaJPFjVv9LpTLyD6iePSbrirY/eemEaOqe3UuqLENSqHmFi1z
X-Gm-Gg: AfdE7cko87nDY/OPuNopN0m4j3jqxjIaaT0mPhbREJQvwA2UUsJmdc0zAqanEa8AkbO
	6BdGUK8cBvEDnf+1vEvZ32bBQTtpTOlbpN0dEKFFWkMd0MX+1MbLI3TKSSn8Xg8IV4w9NyLi6xy
	AT1y7+WM6QQJzqx3R3eq7Bdwe08/kt+lVdsFE6GTO+L/WDtAFZTXiLF0MFRi6OfZowhOMA6wm+V
	9uBTJr1M1YSSu6mpVn72Jl19g/NVq4UdlEUiui511E7fvZAVvu3YWeedsOnHNm10MELT2UgbNWP
	gJG3bwBF+YstaXW8y6ELcW01lZqHHYFH7KBq9NDQXIFu7NhPTYBvtHdY2ONENN8QBCqk8SJMRIL
	x/421ApkgbPYejLXd25JJFo+hgv5P1Zhv68XBmw3BUH5d2okX9FX1AVdHiOQcVD2UTF3bn26fCP
	iO2D1ybAY35kfdv5GwMBRTrnR/B1J6/NP6K68tVKqt336NSb+g
X-Received: by 2002:a05:693c:3105:b0:30c:ab4f:46a9 with SMTP id 5a478bee46e88-30cab4f4865mr2199291eec.45.1782523375611;
        Fri, 26 Jun 2026 18:22:55 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:fe0d:366d:f00:1840])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c9e9214sm22883437eec.20.2026.06.26.18.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 18:22:55 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v4 4/6] seccomp: re-validate a redirected syscall against outer filters
Date: Fri, 26 Jun 2026 18:22:17 -0700
Message-ID: <20260627012219.1079851-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
References: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CE27820009
X-Rspam-User: 
X-Stat-Signature: 4bktnh8e3ccey7fjwaiwncswjs1cf4fw
X-HE-Tag: 1782523376-683825
X-HE-Meta: U2FsdGVkX19GnjEDf1y4MKu0+JbOSx0YtHNiTbisNllA+06paq0To+GEJaj6bQoKY1f3ZNwWKJccphaTyRXOVglfDVYJNtaQqPhf3v8NRB8FFVm5wS0l6G0aklafogM5wKHo3uTxT3Not+GC+5kB4Q7/fXqxsLuI1VRnrPDOz4uqU4w6TReM9Y35n478otdeHPCXqnOI7DOWtZf4+mI+EfrwXK4T13Y51a9IJx40pzPJlVq+38ZVBsJGMeAypmBHtTjTxPJYBzW0F9zvz4xeLXgRsjureohAynoDHhdKQO6dqWPjcG2ZtcRGi9Kb4HRpl0KnTcpH/J0C8pW2JpKz0yy/lM5RyG5Mo7IsKHGD69oq9Z8UyOJn12U/0MAjX6ZwONtPfdW6anIpCwMhJ21L0Hekz/1DzhnlfY7mqj4EOESP6HWyQrXqLjQq0woXqJ9ljfhDXqYkzNobAEEWbSmtattJb4ltBDnerx8jrdsNGvxisUOii52KI/M32stLwQqzCrhCJ6i0+lwdTUtF4FS1HC0iFrfX+/2h7T93UZTzHF6F/wV3W1JHV1v6FyxDp9c6KI4w8MtUy6r819C1KRrx807AyhA2UtRfWVGlimV/dl4wT+mioo1q4TP3MkkxjhaG6tIyb/a42qfsnXknE3oLms7iDoV7Ruz5+urT++W28cIvYL7gtUlakxq1E4WWfz5K8pwkR4KEmFGhx2Fy/7YozlQI3V40FTJ6btYrAkl7/5f/kIMZDdCsImA+J8WGqy7V62Z+rzgno6J0D6ijQOOaasOnmMbG9CPT9AOTtYGP0GGoBsE6IBBE4ScwIQujw9moLTaOxdluPuinlqdKebryauttfOHcj1q2byzIsq213VI43PfOKHkTfuOca4ZywLqOyOpIgkkh8Tqhtz8YOOQfpmiCWQQVuh694Hq2p5fktdnjgX0AKgyt8D1txtmIJdpI09sawe3trIvLq1OjieS
 8BodZRhP
 v8Rh8igHhD0UiFtdlClROjWe9/0GI9/KhHqVWxPajZW2z/Q0OEWdeZKMmEnAHaXda74/VamTcTan2X1ThOP04J7y1nhKCker8fdlx1aC4nFTCENDvqWKgGCteLkyVIvmzTbBvzbxVUKu69s7T7M7DTo6xSwMW2nQJRFiUGZIIEqm0KwsHLIPkz7Im9M1tr217HAMNZ5l+r0yGXzbT5/jirHJdNexDW9e0yrOwhe0YONRyP4d1jIFzeAJm7EekTluSwUZXIHINEuk1f8IComJnysr0bvEcacHdx843OPY1uibDLA45fHv3AuBiAme41DbWkfK5GAT9vypUe0ntRzJQVvZQ0Trdeam9KmKp5dcR9F1gV51n2eopKE8cNMlQiDL4HMGnD1v05s1doqL1tAhdrURZ7HkAurfAqxVUHwNJtFabDTv6cC5TyuWj3O5uEO5Ew/lDzgezwmeHY6wCekJ/weoF+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Stacked seccomp filters are composed by seccomp_run_filters() taking the
min over a single evaluation of one seccomp_data: every filter votes on
the same registers, and the most restrictive verdict wins. That model
assumes the syscall the filters voted on is the syscall that runs.

SECCOMP_IOCTL_NOTIF_SEND_REDIRECT breaks the assumption. A USER_NOTIF
verdict only wins the min when every other (here: outer, earlier-applied)
filter returned something at least as permissive on the *original*
registers. The supervisor then rewrites the argument registers and the
syscall resumes via FLAG_CONTINUE without the stack being re-consulted.
So an inner, container-installed filter's notifier can redirect a syscall
whose substituted form an outer filter would have blocked.

Close the hole by resuming evaluation after a redirect instead of
re-running the min. A redirect turns one syscall into a different one, so
the outer filters cannot simply re-vote on a single seccomp_data; each
must judge the substituted syscall in turn, exactly as if the target had
issued it directly. Starting at the filter outer to the one that notified
(match->prev), seccomp_run_filters_seq() walks strictly toward the root,
evaluating one filter at a time and stopping at the first that does not
allow the call; ALLOW and LOG (which only logs) are non-blocking and
continue to the next filter. A BPF filter can only read registers, so
re-evaluating on the substituted registers is complete.

An outer filter may legitimately ERRNO/KILL/TRAP/TRACE or run its own
USER_NOTIF on the redirected syscall; if an outer notifier redirects
again, evaluation continues from its own ->prev. Walking strictly toward
the root is monotonic: the notifying filter and everything inner to it
are never reconsulted, so a notifier cannot loop by re-notifying on its
own redirect, and the walk is iterative (goto, not recursion) so a deep
stack of redirecting filters cannot exhaust the kernel stack.

Only a redirect triggers the continuation. The first pass is the
unchanged min over the full stack, and the allow-cache is consulted only
there, so nothing changes for existing, non-redirect users.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 kernel/seccomp.c | 79 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 6 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 7d499e422ba1..84812ce9bdb3 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -94,6 +94,13 @@ struct seccomp_knotif {
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
@@ -1181,10 +1188,12 @@ static bool should_sleep_killable(struct seccomp_filter *match,
 
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
@@ -1241,6 +1250,7 @@ static int seccomp_do_user_notification(int this_syscall,
 	ret = n.val;
 	err = n.error;
 	flags = n.flags;
+	redirect = n.redirect;
 
 interrupted:
 	/* If there were any pending addfd calls, clear them out */
@@ -1267,14 +1277,38 @@ static int seccomp_do_user_notification(int this_syscall,
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
 
+static u32 seccomp_run_filters_seq(const struct seccomp_data *sd,
+				   struct seccomp_filter **match,
+				   struct seccomp_filter *f,
+				   int this_syscall)
+{
+	for (; f; f = f->prev) {
+		u32 cur_ret = bpf_prog_run_pin_on_cpu(f->prog, sd);
+		u32 action = cur_ret & SECCOMP_RET_ACTION_FULL;
+
+		if (action == SECCOMP_RET_ALLOW)
+			continue;
+		/* LOG does not block the syscall; record it and continue. */
+		if (action == SECCOMP_RET_LOG) {
+			seccomp_log(this_syscall, 0, action, true);
+			continue;
+		}
+		*match = f;
+		return cur_ret;
+	}
+	return SECCOMP_RET_ALLOW;
+}
+
 static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 {
 	u32 filter_ret, action;
@@ -1291,6 +1325,8 @@ static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 	populate_seccomp_data(&sd);
 
 	filter_ret = seccomp_run_filters(&sd, &match);
+
+eval:
 	data = filter_ret & SECCOMP_RET_DATA;
 	action = filter_ret & SECCOMP_RET_ACTION_FULL;
 
@@ -1353,11 +1389,40 @@ static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 
 		return 0;
 
-	case SECCOMP_RET_USER_NOTIF:
-		if (seccomp_do_user_notification(this_syscall, match, &sd))
+	case SECCOMP_RET_USER_NOTIF: {
+		struct seccomp_filter *outer;
+		bool redirected = false;
+
+		if (seccomp_do_user_notification(this_syscall, match, &sd,
+						 &redirected))
 			goto skip;
 
+		if (redirected && match->prev) {
+			/*
+			 * The notifier rewrote the registers. Resume
+			 * evaluation at the next outer filter on the
+			 * substituted syscall, sequentially toward the root:
+			 * each outer filter judges the new syscall exactly as
+			 * if the target had issued it. Walking outward is
+			 * monotonic, so a notifier cannot re-notify on its own
+			 * redirect.
+			 */
+			this_syscall = syscall_get_nr(current,
+						      current_pt_regs());
+			if (this_syscall < 0)
+				return 0;
+			outer = match->prev;
+			match = NULL;
+			populate_seccomp_data(&sd);
+			filter_ret = seccomp_run_filters_seq(&sd, &match, outer,
+							     this_syscall);
+			if (!match)
+				return 0;
+			goto eval;
+		}
+
 		return 0;
+	}
 
 	case SECCOMP_RET_LOG:
 		seccomp_log(this_syscall, 0, action, true);
@@ -2154,13 +2219,15 @@ static long seccomp_notify_send_redirect(struct seccomp_filter *filter,
 	}
 
 	/*
-	 * Mark REPLIED with FLAG_CONTINUE so the wait-loop exit path
-	 * runs the syscall normally.
+	 * Mark REPLIED with FLAG_CONTINUE so the wait-loop exit path runs the
+	 * syscall normally. Flag the redirect so the resume path re-validates
+	 * the rewritten syscall against the filters outer to this one.
 	 */
 	knotif->state = SECCOMP_NOTIFY_REPLIED;
 	knotif->error = 0;
 	knotif->val = 0;
 	knotif->flags = SECCOMP_USER_NOTIF_FLAG_CONTINUE;
+	knotif->redirect = true;
 	if (filter->notif->flags & SECCOMP_USER_NOTIF_FD_SYNC_WAKE_UP)
 		complete_on_current_cpu(&knotif->ready);
 	else
-- 
2.43.0


