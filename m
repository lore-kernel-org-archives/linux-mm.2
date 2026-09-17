Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EC6C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE0F6B00A1; Thu, 17 Sep 2026 05:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5A76B00A2; Thu, 17 Sep 2026 05:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCA36B00A3; Thu, 17 Sep 2026 05:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED59A6B00A1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:18:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 701451C1C57
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:18:01 +0000 (UTC)
X-FDA: 85222702362.12.FF0F141
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A47DC100003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Oq+1zW/5";
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+aW9JMnDSXi7FuvCOPidViexMnH8zE59YRhofmPghk=;
	b=r01b8KA2QWSWaF/gNvMXclJovQF7QXViVs5+71/lSNROoacB6IjQ4Yq/qaHX7K0aZa0fGv
	TQ1/EPZlyiojOueJu/fD0jwu01hwvjWYuAqvlZiZF/t9V4Y4Mh6P7vzVx9tgMc8DkNfb8d
	sqFPhAgV8B6b57ubMcrvjjnbqJVJy+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636679;
	b=chGk9NQ2ekBPadCjJEz19MqUL96NnAD+FcDGdG/rN4unvCxhgHZpTz2DdT/wNOZpyuU6wK
	0Sy6C0A8Ue2MYbH8NEXyq5FMIIj95pGl2IAJk85mjY+WUU6D6qGEnBZmJNOosCxJqKzo1E
	mKLMKn7R1x3wPM4yUZAu4iPKyNCSdfQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Oq+1zW/5";
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0846B42E71;
	Thu, 17 Sep 2026 09:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547FD1F000FF;
	Thu, 17 Sep 2026 09:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636678;
	bh=k+aW9JMnDSXi7FuvCOPidViexMnH8zE59YRhofmPghk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Oq+1zW/5FhUu8SPCLmEpm8H02ZpiN/izogWXs9x4DXaIqU7RWggHSfWlPkW4li9N3
	 VoF7YXsoJuM733qS5DW2iOfoxvu9bJ6Q9vdrHMzOQFm6MMpgpqJ9GmGWIV4oFd3cTl
	 jHl15a5s1Bn+oLziT7bLcgn91B82Y2absrXANOkkYXvEjpaBCHl5sb+UYnOWlbiEoO
	 4gY5XjvAvDrWYBJc6LGcaqORu4fyxs+Riq8PbUaCTkjMjI60aGtZlz5WmidFGiBqAp
	 7J1ANR1UilhqsvSeeGLrbOThA6qauMZAV20kk7GbJYIprw4TxM7IRM46STqBY4Gi9t
	 gX7jFcH63QA3A==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:17:31 +0200
Subject: [PATCH v2 4/7] coredump: parse a snapshot of core_pattern
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-coredump-fixes-v2-4-f3787fcda051@kernel.org>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
In-Reply-To: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=5242; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/eND6QzpyGy1+J72GAGYP14pDboOpaRwzVGGLJ429T4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3mASIhC99tqC0klLl0yu934hPPeTsxdjobjjtJPMV
 qx9VlcVO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZic4mR4fWHjPiVN7/NjVuY
 3C8R9KZ+WqL46Sa7Jh2Gqi+5DwO27mdk6Oev7pxa1aamOndZyhLVisqP59er6vao/rQoE4tUcr/
 ACgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A47DC100003
X-Stat-Signature: cqmdoy5k7jzjfry5eb4rbax56t5neswi
X-Rspam-User: 
X-HE-Tag: 1789636679-434516
X-HE-Meta: U2FsdGVkX18X9M5zWK+BRN2oM233Ey0PhRGzu4DKeEapPWvJCLl3vqQ4bKpBKPblV9XMqEy4cKWikdMTlrsiNnFmveyeA8uA9xBAjnaHvHjei0G7+jIbyL5xulBM9DlDzKZp7UhnOYLnUx7xBDLmAkuNcc//mj3bhQH7+eHKV71FX/WPuJbHfHI96tgL7Ba4dw1b1WFAB+uvI/fyUK0T/cvhOVRUbcUGKV9Ncz9+VuZs6sDN8gw/6HO1RauKF/KkacL/cim7+EeMu5lVrpL/7Xi4d2VqeUWcDlZP2U7FuXJaD0CnrSee8E/TlRUMHjqddbH9n06HuygW+J22Xe6aJs8a9KCySvzlZmctn7epxN/JcOgl9NYZmN9Clulp+eoT8PbEtBJbgmhCavxskz8wvFsHzwBjFqUWhHjIE/VSOPcEiEyAWiPAnXrzD3EXrTo+huSLBTYzGLekc7rmb+mlXYq9rQ2cdN1ezl7xk+XtSSU7WBaoGXZ6PbBS8WcZ0ChXmsSNah9sEFR64vWyRHsLH/b7Bi9762QQ8wDTtLPWcxZiD7D9gHTwRsGwWlaepfYlbNNSTiNdW6t7++/QzKm/irKSuwYk/UEpZxKDI8Kk7EbtXdTmmUhX0oZJ2IeH26mkKnfYLeSK8+HS3zavJWxRIF1m01X4n8/CCs3Jj0xXFMdOpgh9SC5hgGENSnCQXMXLvADZjVZMo1KgetL7kvB/oDCDoLSW8duCvn//c+V+IvAZHmwRhAORhECPB6nhMSarwFp0vai8hiV5GJsZ5xRQHvyBCjS7Sq6efVrjo/dhyrRYpV2pYYzZz0zghTlrfsWsc0fZx9vY/k+qDp+ZuGNSW8gN6c/0KvcUUiE0EIeofxLcXOgruF6VMbF+HeFUre7FMCfamHZPAQLjw4l9sXDfYvhDiQbOblqLBWq6UpzTV9xups3Wt0rpPo2iv/5x0ykIkSkQWnoq8LnA5maBNOY
 xUY24Jpb
 uLVzOedCqLBX32teHHJAGCzfdWvHzB7l4mWZ0nCRY/JvKfTWdF8FL7EQZ26eL35A1jj/9MZNV6Ci3fl3DU1qvnjtVhhcCE43kuByZ4dpRc0mfa8KeVAIewK4v0j5zIpbhE4E9AJPid5NyXvuyyqACDeHkXvo116FMxfXeSlMsFC5A2Pq+nLmg7bOzwPrlMD8XeKzar3stQKcYCoHGfGkPc/ckE4WUCmrJxGEkMUPOZg7ajbM+VisKKmoyfmap3SJkBsWyP0jiSfIVfaBNhHWX4AydwneQmzJ2xwbj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a long-standing problem that I discussed a while back with Jann.
I didn't care enough about it to really fix it and it's from the
before-fore-times.

coredump_parse() reads core_pattern directly while it can concurrently
be modified. So it reads the first byte, figures out what mode is
wanted, then allocates the number buffer and then consumes the rest of
the core_pattern string.

Say the sysctl handler updates the core_pattern array byte by byte
(idiotic but supported). So that can lead to all kinds of insane mixups.
Say you could transform the old "|/usr/bin/helper" and the new
"/tmp/core.%p" into a usermodehelper started as "tmp/core.<pid>".

So copy what proc_do_uts_string() does and let the handler run
proc_dostring() on a copy, validate the copy and make it visible beneath
a spinlock. Then coredump_parse() can take a snapshot under the same
spinlock and parse a stable copy.

From now on, rejected patterns are never visible and we can drop the
whole rollback logic. It has the same minor defect that utsname has,
namely that two writers can race on a non-zero offset. Irrelevant imho.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 58 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index e0ade16c2f99..0e5d6e84238a 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -86,6 +86,8 @@ static int core_uses_pid;
 static unsigned int core_pipe_limit;
 static unsigned int core_sort_vma;
 static char core_pattern[CORENAME_MAX_SIZE] = "core";
+/* Taken around every copy in and out of core_pattern. */
+static DEFINE_SPINLOCK(core_pattern_lock);
 static int core_name_size = CORENAME_MAX_SIZE;
 unsigned int core_file_note_size_limit = CORE_FILE_NOTE_SIZE_DEFAULT;
 static atomic_t core_pipe_count = ATOMIC_INIT(0);
@@ -241,11 +243,16 @@ static bool coredump_parse(struct core_name *cn, struct coredump_params *cprm,
 			   size_t **argv, int *argc)
 {
 	const struct cred *cred = current_cred();
-	const char *pat_ptr = core_pattern;
+	char pattern[CORENAME_MAX_SIZE];
+	const char *pat_ptr = pattern;
 	bool was_space = false;
 	int pid_in_pattern = 0;
 	int err = 0;
 
+	/* The sysctl handler may be publishing a new pattern. */
+	scoped_guard(spinlock, &core_pattern_lock)
+		strscpy(pattern, core_pattern);
+
 	cprm->mask = COREDUMP_KERNEL;
 	if (core_pipe_limit)
 		cprm->mask |= COREDUMP_WAIT;
@@ -1688,11 +1695,11 @@ void validate_coredump_safety(void)
 	}
 }
 
-static inline bool check_coredump_socket(void)
+static inline bool check_coredump_socket(const char *pattern)
 {
 	const char *p;
 
-	if (core_pattern[0] != '@')
+	if (pattern[0] != '@')
 		return true;
 
 	/*
@@ -1704,16 +1711,16 @@ static inline bool check_coredump_socket(void)
 		return false;
 
 	/* Must be an absolute path... */
-	if (core_pattern[1] != '/') {
+	if (pattern[1] != '/') {
 		/* ... or the socket request protocol... */
-		if (core_pattern[1] != '@')
+		if (pattern[1] != '@')
 			return false;
 		/* ... and if so must be an absolute path. */
-		if (core_pattern[2] != '/')
+		if (pattern[2] != '/')
 			return false;
-		p = &core_pattern[2];
+		p = &pattern[2];
 	} else {
-		p = &core_pattern[1];
+		p = &pattern[1];
 	}
 
 	/* The path obviously cannot exceed UNIX_PATH_MAX. */
@@ -1721,7 +1728,7 @@ static inline bool check_coredump_socket(void)
 		return false;
 
 	/* Must not contain ".." in the path. */
-	if (name_contains_dotdot(core_pattern))
+	if (name_contains_dotdot(pattern))
 		return false;
 
 	return true;
@@ -1730,27 +1737,34 @@ static inline bool check_coredump_socket(void)
 static int proc_dostring_coredump(const struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos)
 {
+	char pattern[CORENAME_MAX_SIZE];
+	const struct ctl_table tmp = {
+		.procname	= table->procname,
+		.data		= pattern,
+		.maxlen		= sizeof(pattern),
+	};
+	bool changed = false;
 	int error;
-	ssize_t retval;
-	char old_core_pattern[CORENAME_MAX_SIZE];
-
-	if (!write)
-		return proc_dostring(table, write, buffer, lenp, ppos);
 
-	retval = strscpy(old_core_pattern, core_pattern, CORENAME_MAX_SIZE);
+	/* Work on a copy, proc_dostring() appends at *ppos. */
+	scoped_guard(spinlock, &core_pattern_lock)
+		strscpy(pattern, core_pattern);
 
-	error = proc_dostring(table, write, buffer, lenp, ppos);
-	if (error)
+	error = proc_dostring(&tmp, write, buffer, lenp, ppos);
+	if (error || !write)
 		return error;
 
-	if (!check_coredump_socket()) {
-		strscpy(core_pattern, old_core_pattern, retval + 1);
+	if (!check_coredump_socket(pattern))
 		return -EINVAL;
-	}
 
-	if (strncmp(old_core_pattern, core_pattern, CORENAME_MAX_SIZE))
+	/* Publish the validated pattern whole. */
+	scoped_guard(spinlock, &core_pattern_lock) {
+		changed = strncmp(pattern, core_pattern, CORENAME_MAX_SIZE);
+		strscpy(core_pattern, pattern);
+	}
+	if (changed)
 		validate_coredump_safety();
-	return error;
+	return 0;
 }
 
 static const unsigned int core_file_note_size_min = CORE_FILE_NOTE_SIZE_DEFAULT;

-- 
2.53.0


