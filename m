Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014E6C44500
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C222D6B00AC; Sat,  4 Jul 2026 19:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4086B00AD; Sat,  4 Jul 2026 19:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B366B00AE; Sat,  4 Jul 2026 19:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 713D16B00AC
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:19:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2C57A0306
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:12 +0000 (UTC)
X-FDA: 84952662144.28.1445754
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id ED2AFC0006
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jgK/QpFi";
	spf=pass (imf10.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783207150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByQ2HFYB3jNvuqPy2QTHv1A9/cHA6wxh+uKXzmjpR+o=;
	b=Qn/EySD+FCdofbk2LyfHwJGYeeabm3wFl5byKgzOBQtIfViSNoPuPtLtxUye5ziTyzAgZI
	DYSHd8sivXZJagy+5vi+yXrIrWaXHVRHci8AqpEJfbC+KJfPQcmii9GB7QoHetuA0pGKkv
	xsxi/MnRuEcWhTR95RRUQetQVgHegMc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jgK/QpFi";
	spf=pass (imf10.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783207150;
	b=blEx8OmgI6uf9ghp80HtXbUWnNP4EX3h2+w7fhjysAzV/R5QvAJqrD8N5EoA6CbjA5LNQe
	LarZF59ls+ikkr77f1VNNfuSP8po5y70izutiBLqJRYw3qgDSkh5NZqkZetpPtPREzAobA
	2zqSWn40jBrtJzN+qet1UXnDqQQ8rw4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c7c61b5292so24328715ad.0
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 16:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783207150; x=1783811950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ByQ2HFYB3jNvuqPy2QTHv1A9/cHA6wxh+uKXzmjpR+o=;
        b=jgK/QpFi1TLmiD1o6rDJb7crmKnay7v5NT7EvfV+G6Ms51rrI+NLi2DATzKysa228y
         H0e8QDPtiVCCXV/GTqfrhdi9QOfuTxx+5CxK0dcTFe6FIjdVTwa45kRZddwGmM4y3WoL
         EDNfSzq6c/Nns6kYGAuvVkq+LbfS9+a9v+UcdxbsV8xm85JeU5PB0u1Q7vfJqFzgWJuM
         peDgso8WP8AEiSVeb9XhPXzBJBeHXlYn/zvVbk66SR3F9QX0oypidJrLhKS9FPuELa/m
         aWAToaQNuIxBelyEs5nyf2Pup5HMndZwDCqPjGYgB5zpgHxsXJJ/nVohmL17KQIYFADU
         Tibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783207150; x=1783811950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ByQ2HFYB3jNvuqPy2QTHv1A9/cHA6wxh+uKXzmjpR+o=;
        b=lfeUB3Iz4plPGBA9UyUvc8KZHmcY30RBDDbO2QWSdJND6schcBFLcSf8NZb6PLpC01
         vCzhSVNBxF7RJyc1vtSMRC7e5ix8kAWzfK1VKjCIXFMKwFacuQve6h/mrNA9IxOVSDcJ
         hMcKx+24vkkPL5fxZVUytcX3fQ6piSyHW4SYQh7a/QmklkzjsAPbSBxa0af8D5wslyXX
         FmO63Rw9A/36bq1RM80Q/nZopZCq6X4Hy/juub+Akd12EwVsJzSKLkQeXPqGn76e4+OB
         OMU8ekAXfZQDEEysnLFSpGSKxwMEpEZBgvdBbQpgiX0GxjTSp0kubAK7DGZ3mf9RE9n5
         OnYg==
X-Forwarded-Encrypted: i=1; AHgh+Roe8u99JCjGhH7mx+xtbNbE4Usxs6T9AGhevq9XiLqY4TD+BU4yX7ddREjwOvjZudBiWd4+OqgPRA==@kvack.org
X-Gm-Message-State: AOJu0Yws+jPN+FOovbtAN5LGKWlElSLYx8MOieLrCA9+Cgash0noV/zv
	a5Y1QgVIbkJwKK7TiWKgRgQaP17d1XnVdeOz+IExnvRTdUXBtgN8kNmu
X-Gm-Gg: AfdE7cmI3hoEEMek7J5Smjw7S6RvNbGtkznMCmzmR9gSepiIGEpjS8TIwW70lhIHnY4
	8fhYwg8CaoHrdjKmIXdj4ncUMz3237SGnSZ4S30+YKL8Ebd2jJV7WIKQYKWHudnWRwOw/e+Zstq
	CoY+GVtNUtOwyIrkMY+w8TQhO+uvb0n0fEjbesqkeybwN8rDO4Kvg6zRDyM9e8tcL3xCefGHhGX
	YaBI0c7nj072dXGTc3kvYGRLQeMxpBxshS1GuByVc+kXWmqt86ql/7L1xl4EDS8kVsGE+xyklig
	lBbLBXkW3CTxkpz6iMESeJGP0P/fQvR9eGDChD8EfwAA8Md4+0JYLrWUo8I3hjIOAVYOkCKBTjL
	80skc9AH/MghTei8xSc4znAxMAt6eulm6WS31HJJqmU4Th34YtfnibhcVbs5DB0/Ad5wAGyIxu1
	VxBgT81BrgN/fCN/FK6D7g29EjdPS9G3+BwNME1XVa27YETnuLQWUOIT8IcItG
X-Received: by 2002:a17:902:f706:b0:2c9:ceb9:865b with SMTP id d9443c01a7336-2cbb9e2426fmr44675575ad.21.1783207149897;
        Sat, 04 Jul 2026 16:19:09 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:55ba:96cc:892f:32d7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776589fsm27088215ad.43.2026.07.04.16.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 16:19:09 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v5 5/7] seccomp: re-validate a redirected syscall against outer filters
Date: Sat,  4 Jul 2026 16:18:29 -0700
Message-ID: <20260704231831.354543-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
References: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED2AFC0006
X-Stat-Signature: 6ktq7kjx3r5k1qmtusci3ftfhusgrxj4
X-HE-Tag: 1783207150-759262
X-HE-Meta: U2FsdGVkX19KYoBxla0niqv6/DzrZRfHstXhiRZ4NtK6LmgaXpCGpKQO42bOThTq9Sj7RXIA3vhXclwIc7ri/bbcWdbgPq1t70rEf5nOR/A15R7hA8RonQTSeCR41o4EG3uvRWnz/4IeaxFwL+NQe33zr5Yh03IeVr/n2ciyhAthy17LOP/j6u0ljgsRNBAyq6QempKrZyccIlfJ2SkqKSe1V+BozqvHS+fBQnBrXjSqpbQG8ZhVCdUo7CZgJhXnC23oLQ1BJMwOs6xBvODaISBBS/B8mRhTWU9Zf/e5S1peeDjBroUwBzij7EgT2nxZlNLNkI2yaITo1Yw0ZhJTbNzo6RVkioBY2LK7Ah4fEL8OBVMkF7GewW/W1/n4l5Q4aqpdOFvtzIS2LqaeBld2OloygunJ304LomC8LmBkLBW/IoQC2aEjLnYxwXuaWnnIwaQAqbaOnY8dlXxqO0bQRgA6TBHm6sOk9rFbid8/qrvsa4sBtrXXS8I7Pd+GGTiszvrnSxQgPFsjNh7lALU0EAca41LDWI2MIJSWXSCbUVTwB1VWkAtSl+QskZ/067nKdDcBhyZ0A2/ktyxWNv0TniPYK9fmgSRKYSoywwQID4TBMlGyePGUvrg3GND8g5DM+C7iziTbTXkpkTzXlM18cRK/njULOQZ6PgyKH3ZaQgj5Q1Hlne5l2fRY5btgzZkX54KmeNMf0ifFXbw6TrTpznm1p4Dsz2xOKRz9apC6YLUcUi4DWfUqcl/MFVR+5z1x3LQ8eiJWEVvLOVPZowVRWLGLNjVyWEw0bzRuCOi6kO/h3tUKk2l4HZCgwyqsx6tJIiYI9CnPL0YpcBmuJsp9nV0NzhpyWEXTSZAkoMCXrMt3ZEGM8Shfs0YptwIksGeE5ymnfVE6CPc474ywEq3s9CYqWayjyhJEJhqT9hcQeU4hNA/k4gCmAiimPtER4n+qU3A+Ir0uOnipWpUj5dh
 Kd/F4pWi
 rP2oY1LzYejmvu8xbKIStq034Iu8sp770mu5EhyAFqM+9ORCDpJa42jLz7F0RYKss/idRhOxzC2H7MWsbnpJCZ5yV+HmNnRgS4mo1id3p8TS+UfzbJRrkBZNfkv5YgeuiBD7S9n/SUBgfHrYv5MMLL3cKKkGlB+KtbsHFNs3YUuFjvXaJz+sWuQJjTlKxZmhIPf8Ool1pJ6zgzYzI5LyfOoWaE2IXleXhfTeNertlhd9vWKzL6misi8GdQ1alvfGXYJtCVITmqtrqeRKyL8bGsAHojlhbhEMvZPyqXZb8lywRxjfFbcqNLsJpSmWNshI1gapWlwicVNCH3f2X3URjKPzPQ6JcRiyjfj97zUVtLOiUzgcZwpxoZjyzSWmISGWaEEtcfccv0QouhytDSEpgFTnnlCueLFnmaGm7eSkBm7qHaSjvm387MfPHY+WtwixXL1V/yDNXzV5um8me8GYUq+9bNB5sN0uefSQi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Stacked seccomp filters compose by seccomp_run_filters() taking the most
restrictive verdict over one evaluation of a single seccomp_data. That
assumes the syscall the filters voted on is the syscall that runs.

SECCOMP_IOCTL_NOTIF_SEND_REDIRECT breaks the assumption: a USER_NOTIF
filter's supervisor rewrites the argument registers and the syscall
resumes via FLAG_CONTINUE without the stack being re-consulted. So an
inner, container-installed filter can redirect a syscall into a form an
outer filter would have blocked.

Close the hole by re-evaluating after a redirect. Starting at the filter
outer to the one that notified (match->prev), seccomp_run_filters_seq()
walks toward the root, judging the substituted syscall one filter at a
time and stopping at the first that does not allow it. An outer filter may
ERRNO/KILL/TRAP/TRACE (terminal) or run its own USER_NOTIF; if that
notifier redirects again or resumes with a bare FLAG_CONTINUE, the syscall
still runs, so the walk continues from its ->prev. The walk is strictly
outward, so an inner filter is never reconsulted (no re-notify loop), and
iterative (goto, not recursion) so a deep chain cannot exhaust the kernel
stack.

Only a redirect starts the walk; the first pass and the allow-cache are
unchanged, so nothing changes for existing, non-redirect users.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 kernel/seccomp.c | 100 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 5 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index c5a01ae097d1..7e572bb34993 100644
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
@@ -1267,19 +1277,44 @@ static int seccomp_do_user_notification(int this_syscall,
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
+		u32 action = ACTION_ONLY(cur_ret);
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
 	struct seccomp_data sd;
 	struct seccomp_filter *match = NULL;
+	bool in_walk = false;
 	int data;
 
 	/*
@@ -1291,6 +1326,8 @@ static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 	populate_seccomp_data(&sd);
 
 	filter_ret = seccomp_run_filters(&sd, &match);
+
+eval:
 	data = filter_ret & SECCOMP_RET_DATA;
 	action = filter_ret & SECCOMP_RET_ACTION_FULL;
 
@@ -1342,6 +1379,18 @@ static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 		if (this_syscall < 0)
 			goto skip;
 
+		/*
+		 * During a post-redirect outward walk, TRACE is terminal: the
+		 * tracer has handled the call and, like the other blocking
+		 * actions, the walk consults no further filters. Do not run the
+		 * full-stack recheck below: it restarts from the innermost
+		 * filter and would reconsult (and re-notify) the inner filter
+		 * that redirected, breaking the walk's monotonic-outward
+		 * guarantee.
+		 */
+		if (in_walk)
+			return 0;
+
 		/*
 		 * Recheck the syscall, since it may have changed. This
 		 * intentionally uses a NULL struct seccomp_data to force
@@ -1353,11 +1402,51 @@ static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 
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
 
-		return 0;
+		/*
+		 * Continue the outward walk only when the syscall still runs
+		 * and there is an outer filter left to judge it. That holds for
+		 * a redirect, and for a plain FLAG_CONTINUE (resume, no
+		 * redirect) reached during the walk: either way the call must
+		 * keep being offered to the remaining outer filters, or this
+		 * notifier's reply would let it slip past a stricter filter
+		 * further out. A redirect by the outermost filter (no
+		 * match->prev) has no outer filter to re-validate against.
+		 */
+		if (!match->prev || !(redirected || in_walk))
+			return 0;
+
+		if (redirected) {
+			/*
+			 * The notifier rewrote the registers. Reload the
+			 * seccomp_data so the outer filters judge the
+			 * substituted syscall; a plain resume leaves the
+			 * registers (and thus the current sd) unchanged. The
+			 * walk is strictly outward, so a notifier can never
+			 * re-notify on its own redirect.
+			 */
+			populate_seccomp_data(&sd);
+			this_syscall = sd.nr;
+			if (this_syscall < 0)
+				return 0;
+			in_walk = true;
+		}
+
+		outer = match->prev;
+		match = NULL;
+		filter_ret = seccomp_run_filters_seq(&sd, &match, outer,
+						     this_syscall);
+		if (!match)
+			return 0;
+		goto eval;
+	}
 
 	case SECCOMP_RET_LOG:
 		seccomp_log(this_syscall, 0, action, true);
@@ -2201,6 +2290,7 @@ static long seccomp_notify_send_redirect(struct seccomp_filter *filter,
 		goto out_unlock_free;
 	}
 
+	knotif->redirect = true;
 	knotif->state = SECCOMP_NOTIFY_REPLIED;
 	knotif->error = 0;
 	knotif->val = 0;
-- 
2.43.0


