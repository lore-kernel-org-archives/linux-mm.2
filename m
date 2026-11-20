Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE330606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N9ejTIGx
Received: by kanga.kvack.org (Postfix)
	id 575976B05B7; Fri, 20 Nov 2026 08:42:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54CED6B05B9; Fri, 20 Nov 2026 08:42:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489CC6B05BA; Fri, 20 Nov 2026 08:42:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 141096B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:42:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A8DBC0F2C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:38 +0000 (UTC)
X-FDA: 85455612396.15.325BA12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B4F008000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N9ejTIGx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182156;
	b=BburhL4o4nCXxrVB2krmyAAOH1wyX8M96CylwpfT/jov7mf6CQepQPZLrv+AVy4U51YLTE
	dbZwAvoWyCMbEUh90BszpKxjWrR7LU/86H082tUbdzgToK/jaRLMTip/8S43VVHhlaiyYB
	0zPQDv6Bqi20oNisdw239KkF4hVWSEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3cUMF/axjpm7NLzQr7ZTPMw3JSwqyBaDBp2ykqJ5Lk=;
	b=yDkPZMP9hdz+5LBnraXIxJZ5n1thLLyzs7Lvno8I6Yycnrj2Gt6vrWqz7mV0YLjxcE/23/
	ZkbrNcqYGi+vMBR47J1mnOgido2RjDSjaqrll6PrkpUCzbmbJZarz0ZcDYP10CK/mliM3p
	yBCZvO5XxM03hL9M40/RcMF0lJiPurg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N9ejTIGx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11569465BB;
	Fri, 20 Nov 2026 13:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967321F000D3;
	Fri, 20 Nov 2026 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182155;
	bh=F3cUMF/axjpm7NLzQr7ZTPMw3JSwqyBaDBp2ykqJ5Lk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N9ejTIGxrkmHTH0Z4pSMVBRLv6qUQ1V40Jw7UJj9j8Ma8BqCixqcSdVamwDMZhWZH
	 KwVq2NWMrGUXhEpW7u5FhkK90AdpdvUhrbkDOCkzsBbbJbJmuMVPohAGlUehkpUp5A
	 ldUhKHz3x3IIysmAMhOKbqWHUQioYdhLIhiHayESvEdSjV+eF4evBWsMBEQ09xN57T
	 6VJdBLeDFmA/OsaER6kBULFJcWPhKWZIv8HoPKfY17DrGnFxK2qI1U4aSpDlL/uH5m
	 SxvC9PfajK1b05ZVY/njp1dVJZMeVXaMkx08CTc5ZxLc1w/IggaNKaCXPPikO8rLLM
	 EFOR7E4L35/yw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 20 Nov 2026 14:42:10 +0100
Subject: [PATCH 2/3] pidfd: convert remaining visibility checks to
 pid_in_current_pidns()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-work-pidfd-pidns_visible-v1-2-0e82d08469ae@kernel.org>
References: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
In-Reply-To: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jiwoo Kim <arpe1618@gmail.com>, Chen Linxuan <me@black-desk.cn>, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=3831; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hlLoaUSApv644mXQ3+zCbYHIM+rVd8v7BP7D1RrUt7g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQz+NmvcuhY1rnr9Zf1BlJX0nZwTfcJsrlky+4avlNvU
 8P3/ML6jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn0n2f47zVnQ4eKyVuu6N9a
 +zVyZrp4TjQNbfthbyChd/K+UlmcDMM/wyP/lylUPDu3tPtz/yz1rjSmmzffXW/S/fLN2+Jf7qa
 D3AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: B4F008000C
X-Stat-Signature: z8befujpr67p8tpkgksb79fqah1wtwsb
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795182156-514799
X-HE-Meta: U2FsdGVkX181cHX1mGctgkeMirScD3ExuCTdcgQat/NvpWtHWpjTBWohX3TWktAtpFC7t9BabhKJdvmGX5zUgr6PyEXaLTs4xNFw2isrrnmWr7wfllNMBorZWO3jz+sJ5EAxtpIejkIVxLo4YahzJ/mquGCZYMpq0yRzqG4HewFmlThrpIPltU2qOAI9piOZn0rxNAMxGfYWHn1ICJJPT69xZFgSF2SVelme/WMhrCIVudLKr3hsVjBQPchP7P31E/5zcCSLHx/AtCPI2eJJM+tv6MeUVDK1arsQ7t/qgM/njjIbGwOXLkdbO221krkbpO+OoLwEqG6Kgb043pysGU/IRyQLyidytTOsKl8ZlJQzXNWFHNsc5TzPx0/hVNWmZNebliToaBlyQMzhRG84/EUUIOtvg+EQ1Q32AZyPoNUJKU2EcTvCLdlsSOw0wPiYjO6FkcEt3Roi82VX/Rkpp5AfI5xBGK+Oq/Gq8kHS0uQXoVo4WE0xa6sNzqxdQZTBYphQ67pvvcIKD7Y2EmLNH58cMQ+RhW5sGg/oyzS7RRkxO2DlY/VjMKuxcl1jQiKlRNZXaoaXP/7dYrl8cJ5xIZxm2XewV2Bb1PvX8+8toaNqCDQ2CVp4D2NzdTbjnurN9MBxiXvJ3ZLATMkP38pAiRsnhqgARQXFD0d1X3wj37fJZGH59tpqn28XFc41g+9OxYVFvheBxfoXasbkd6wzunn8tasN8xqR/LGaZqWyureEcCbhbZejnxw3Wu3+owNBeMFE8upzBcyXYMSwcK8DhpukpTucy1c+cGfjNr7KwQWGFcE8ZO9bvSprTt0Yd/Q0tMy2D638im5D2xL074K1QDBMgXtNtbZggTgYsuDVXwzLKhyciC29L45cVhpuL56MAFV7IdE2jpr0O3B3SQIIIF7ZIUV9D8UOpNvbxX5YhZKJEM9+S8ikoQI5I7Rl9FXC/wyaouVA+mtc28h+yZF
 CMK9Ypck
 9sLsj5NJbq4lNcA4g9a5YlCFRlA6XiHZ0InCWbGAIxlhoTXEwE8miWe0UsuhMLKZBbjCJrhoPsOsK4YraB+MkUWwLjCDMgCDSwv+ozp99h70uIpKPQpluOPxrzuQULEJaeLu326vRrVsH79u+dhiiSZ6RYbYA8fWCE0Noz7FJy7fwwo67LJkveeJt7yWau73Rr6wzce+fkyYuaTj3kjpcHrDs6SEAJNeMS1EEcfgBO0QdQzErkDGyFVY7VkLBj6+QviDakCuOaxGhG933/DJlSjx8HeoFwLaGNdchaC/iglrzs2wR3J2seCJkgPgUgy7BAR94weEo+KZSBOtpOdl5v4aqAa4mKMOgMa4tZh5r+PTBA7gcUOZ2kJlybk/MfSWNiezXu8ppyaW9mXgP/gjrVtx6ifQnQkJnbSEqsauxzH5xypW88pdURq+uRooZYDCMP6x5phAsmZccgSabBno6oz5G6+zoYwrRZcXLRa0kYXH+BsmEyS2G+F0NPiu7i3+GWxXfwLcd5edI1y0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Switch the two remaining open-coded visibility checks in the pidfd api
over to pid_in_current_pidns() and drop access_pidfd_pidns().

pidfd_getfd() uses !pid_vnr(pid) which is the same check as explained
in the previous patch.

access_pidfd_pidns() walks up from ns_of_pid(pid) via ->parent until it
either finds the caller's active pid namespace or runs out of parents.
pid_in_current_pidns() instead looks directly at
pid->numbers[active->level]. Both answer the same question. alloc_pid()
fills in pid->numbers[i].ns with the ancestor at level i of the pid
namespace the pid was allocated in, starting from that namespace at
pid->level down to the initial pid namespace at level 0, and a pid
namespace is always exactly one level below its parent. So
pid->numbers[] is just the ->parent chain of ns_of_pid(pid) laid out by
level:

(1) The pid was allocated in the caller's active pid namespace or in a
    descendant of it. The walk reaches the caller's namespace and
    succeeds. The caller's namespace sits at active->level <= pid->level
    in the chain, so pid->numbers[active->level].ns == active as well.

(2) The pid was allocated in an ancestor of the caller's active pid
    namespace. Then pid->level < active->level, pid_in_current_pidns()
    fails right away, and the walk only visits namespaces above the
    caller's and ends at the initial pid namespace's NULL parent.

(3) The pid was allocated in an unrelated pid namespace, i.e., neither
    an ancestor nor a descendant. The walk never meets the caller's
    namespace and fails. If active->level <= pid->level then
    pid->numbers[active->level].ns is the pid's ancestor at that level
    which isn't the caller's namespace, so pid_in_current_pidns() fails
    too.

With CONFIG_PID_NS=n everything lives in init_pid_ns at level 0 and
both checks trivially succeed.

pidfd_send_signal() keeps returning -EINVAL for an invisible target as
that is existing uapi. pidfd_getfd() keeps returning -EREMOTE.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/pid.c    |  2 +-
 kernel/signal.c | 23 +----------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index aa3ed6b5d4a9d..72b98d0f35ab1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -918,7 +918,7 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	 * Require the target to be visible in the caller's pid namespace,
 	 * like the pidfs ioctls that grant access to its resources.
 	 */
-	if (!pid_vnr(pid))
+	if (!pid_in_current_pidns(pid))
 		return -EREMOTE;
 
 	task = get_pid_task(pid, PIDTYPE_PID);
diff --git a/kernel/signal.c b/kernel/signal.c
index dd770e68faee0..2c2907d969485 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -4045,27 +4045,6 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 	return kill_something_info(sig, SEND_SIG_NOINFO, pid);
 }
 
-/*
- * Verify that the signaler and signalee either are in the same pid namespace
- * or that the signaler's pid namespace is an ancestor of the signalee's pid
- * namespace.
- */
-static bool access_pidfd_pidns(struct pid *pid)
-{
-	struct pid_namespace *active = task_active_pid_ns(current);
-	struct pid_namespace *p = ns_of_pid(pid);
-
-	for (;;) {
-		if (!p)
-			return false;
-		if (p == active)
-			break;
-		p = p->parent;
-	}
-
-	return true;
-}
-
 static int copy_siginfo_from_user_any(kernel_siginfo_t *kinfo,
 		siginfo_t __user *info)
 {
@@ -4186,7 +4165,7 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 		if (IS_ERR(pid))
 			return PTR_ERR(pid);
 
-		if (!access_pidfd_pidns(pid))
+		if (!pid_in_current_pidns(pid))
 			return -EINVAL;
 
 		/* Infer scope from the type of pidfd. */

-- 
2.53.0


