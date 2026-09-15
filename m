Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D96F9C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37146B009E; Tue, 15 Sep 2026 06:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0FC6B00A0; Tue, 15 Sep 2026 06:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B618B6B00A1; Tue, 15 Sep 2026 06:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA5E6B009E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:22:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6F3DA0390
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:54 +0000 (UTC)
X-FDA: 85215608268.03.9F78237
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14CD4A0009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1QmdycZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03HAcIyKfSHMzxQiWZYef4ptvXZuNWZ0+WSpNlAzZJI=;
	b=0eCRNyClLk2aYPrP0jB9hc0F1NPzkRUeCozKKMQpXYGqg6iD+ENQI0fO1G00AfSTs2v6Cc
	ggtxa5XpLBmLDxieil9qKCRWVF8YPi55RN5bP5Mi6/Hi09fj9NsTI4t1rQKikP5+jvlIsC
	SKPR1xAPm694qkqZUkoJPjD+iBZJWF0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467773;
	b=WDb1t6HejrqYHt2bfg+oclpE4u4nlfldqgfAUNwuoZd1LgTIZGV5CGOuAO6/8hI3PuByXp
	171TQVICNaq9tclMFBTDEmNkqydN8GtFvL+/pxzHF/EmcX7MM+toaw9AOoRAh2Uk5FgCc4
	vsmejRp8GrPqwZJ5NaibAMUWYb/QMkQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1QmdycZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9285602CB;
	Tue, 15 Sep 2026 10:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06611F00893;
	Tue, 15 Sep 2026 10:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467772;
	bh=03HAcIyKfSHMzxQiWZYef4ptvXZuNWZ0+WSpNlAzZJI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i1QmdycZg/kysGgYsZUSVnDuJ+PyvMDigeRQ/01GP4bmVJGsn9IuB0SF5VEJHcEpw
	 gE5H+miyh2pBFqpLpyDkjEKIG7g4nD6efWSs3T1sAoZtkILwY4hHokg44Fzmqm62rz
	 Ajm7hgwXiEJ4Xjl36QC1+4Hh/YU+okUOUxajcfo4HlPGYQKgLro6/uyiHNjwCVB+1A
	 8WIIycKjXZqUK5kebSvwVS7NpQiIVtE+9bawzagVwD5UcOoK9etucHsmHmIrRPzvSx
	 oYOvNsZ9cy7WS2Xudwbf1pS3428pSeCg8/uiGxRxOkwxJkD+Hmd+FYkP64KI9FohAP
	 Lbjv8oky63ODw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 12:22:20 +0200
Subject: [PATCH 5/6] coredump: parse a snapshot of core_pattern
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-coredump-fixes-v1-5-f354ca41780c@kernel.org>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
In-Reply-To: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=5241; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/Ett7rDx35bRTI/Va5F+j/FYrq0e4ECB2pQmOI5Zy84=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStlMnIW9Aktmi/37scj4kf2/ivZx17t3bTse/7Ds37/
 2zF6pPMOh2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQAT0VnE8N/vv8mVGvGfe3Yk
 zw/vyjL0mc23c/O6u9c8iv5FlvZknIpi+Kf4eub0rCJD/sbEMPXDc7Z2PfqSIemhdWH2x23ujLc
 lyxgB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 14CD4A0009
X-Stat-Signature: dtbzbcnzodobqwgcizagtfqezjd6fnkg
X-HE-Tag: 1789467772-690381
X-HE-Meta: U2FsdGVkX189CMvb4uqb/beXIvGE5hDkFGssNQyRSTotuy8jjPE/iB961yGhW1JDA9z6UIn+BdcWvQ2WJ6Womc5oifCQclRy5FlfOUhnevXXVl9Qb9ieGriHUrphXJNCAXPJK3mIc6OHxhR+DebpXPOhsUnZf29STw4wZnE4Cv2TMMy7kuL6seidVYk5rCdBAjI/LBr1FzUa6/OWi3s2hpqxrZoeF+kmFDMsHiFPyFbvfbFul8YP1EkKAy5hTHb6+BdElJi+uFcVsMbvSFchS8PKsc4toLaaiw9P5DMcn2KhnL90O5GK1F8Tw8qdS2Gk9MUnMTo0wBX38anBzr24yaI/rcWbKdzhtgXzRds23sZ8AU4MawPTyftLCZM4w4yt8bs0ACxd5z6zxS1SgsggPcm94te4W9lv8Z2wA/CfSE/blSE1yNOWvK/S6jNiyTdbz6HMlK+LtxdZfG43Awzrt0pUUkSMYEKKu8t6vc38YFSBVCCkLjoYzOUNxTmw1ufz/tnD9IcXtXNfK9z6U0SHh6/WZTIXRC3GWza5Rx7/SSWoooq0RNf+X+/A9r0vkqFfCIMQuHI5Jh1581GORl1FeWIKvRFlGK7DOmYWdTUGrPOmtXRpM11SyEESVySQ0pa02OXzFIPUfc1G2wDBoMQjWKh7XjrTiuhI5BllQhTsSSvhMUqQYmHCnpRzYGhWLV2pl7CyDPJCW+M0VFaVsE8GCqI7CwEhth1NNQg7W5hcJQiVGoYyOym3fuTZ2jmRtzUQn4QozFhzOttoGuw9y3tMG2j7jqDhk/ha76o1ndFRyDtEHwPxLgEMaLOoPlaBzkQg4ZrxgMslmqw0Qut5Cuo+pj/sBWFid9kAF2G7p/OTB/Ar6lxUpxuvnTqUS8kAn9qwCrHyqUzWN424G20VjRqYOCd9udd4VmROYx5MKZVLrYFoGgvEKolVHWYpCEaTajjajNR7Ylo3vG3Q7sAhO0u
 5mV5fAyv
 5hfeBtKfI5q1mTVqvLow/9CWFdNwKBazDrE8xLfHzIF5gp38osXrTlgJXDMgNPk0TwuPpP8daNNKfrMgZgfvw4A/SirRso0humtsE/SauwCTKZOTEdURaiM5zdM2diUA3PSFX0B9c7GUYF5z6XdMBbFdro9oTX89bws2b+FFu17XD0snFoE7aRm7+f62um9Mu6jY9vlRvV22f1bBVpp5SwhuqB7KJHOmQj5in8WJ8t86/vLBZc6imoUNUUZ+GcJPKGYGPNQOo/3Wzr87K1yH/hVcJEEyLCJanrLZo
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

Say the syscal handler updates the core_pattern array byte by byte
(idiotic but supported). So that can lead to all kinds of insane mixups.
Say you could transform the old "|/usr/bin/helper" and the new
"/tmp/core.%p" into a usermodehelper started as "tmp/core.<pid>".

So copy what proc_do_uts_string() does and let the handler run
proc_dostring() on a copy, validate the copy and make it visible beneath
a spinlock. Then coredump_parse() can take a snapshot under the same
spinlock and parse a stable copy.

From now on, rejected pattern are never visible and we can drop the
whole rollback logic. It has the same minor defect that utsname has,
namely that two writers can race on a non-zero offset. Irrelevant imho.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 58 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 78ab6cb78be8..20cd95786dbe 100644
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
@@ -1690,11 +1697,11 @@ void validate_coredump_safety(void)
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
@@ -1706,16 +1713,16 @@ static inline bool check_coredump_socket(void)
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
@@ -1723,7 +1730,7 @@ static inline bool check_coredump_socket(void)
 		return false;
 
 	/* Must not contain ".." in the path. */
-	if (name_contains_dotdot(core_pattern))
+	if (name_contains_dotdot(pattern))
 		return false;
 
 	return true;
@@ -1732,27 +1739,34 @@ static inline bool check_coredump_socket(void)
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


