Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A00EC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4146C6B00D9; Mon, 21 Sep 2026 09:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5766B00DB; Mon, 21 Sep 2026 09:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB4A6B00DD; Mon, 21 Sep 2026 09:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07E326B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9071D1601AE
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:20 +0000 (UTC)
X-FDA: 85237891200.29.547F0A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C546EC000D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrGSwNJU;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMdX6MHSOqe32C0/+/LiVkpOkjZr/CxbphyJOfe1CoY=;
	b=WqMrcU32yKMcw/aioWxstZa8YVTkekSnR+S4MROpanIiILLr9lfO9dknWIVSIJDBf7kkZ/
	GH76PREL6lOC+B8qNTkMT5ce1E6M5EHEAt3yEYY4+X0fwyUh9lQRfxp0BC/pJjL/HphKiD
	A2BoXSETputVA1Z8nfhQ7oxF90jRBAE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrGSwNJU;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998318;
	b=5vjPlMpDOQnFXZ8R5dUB/c/pxlGfqF4ZtKob8qJzIoGYojdAclOHll8oEjf9IRzDNJM43d
	6cglDimMHzcDvSm5qCPnAjtjvcj1H9H3CN6Jpu3Si4HVVw82GNZBdn1wIc7TauJaJFIEoV
	r1zxCwiCCkE0vyWFllrPQ+1YRNc/bFc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6642F60AA3;
	Mon, 21 Sep 2026 13:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160871F00893;
	Mon, 21 Sep 2026 13:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998318;
	bh=RMdX6MHSOqe32C0/+/LiVkpOkjZr/CxbphyJOfe1CoY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JrGSwNJUfaYorWbdHx9MJYNKq8svon8b7c/hDVt/10yuh95LAe8aShc9uuPEgx5p5
	 j7vdEIjzOHK0bW+sK0/dBaixMeUaddgbjrQpXZlz2Is7yWqAHO++pyYQlu9okcXbm8
	 jrzRsIny+dLdhgpxXepR0SQVloeRm4AjCx7I23YecZ+5WVVYe9gBuGeSwGtRFNgR9y
	 3wLaBnDAWb7G+OpuW0dWx2NNX7PZsVhDOypbNt076EjmOc4eBS61cYLUdnAPe4PCI9
	 VNIjtigIpYAu+ajPw5FWEnU6wmv+YyDREzoVUeiS3873to5mmMb7yxExKs7qPmW5Zs
	 6utJEIEbkemFA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:52 +0200
Subject: [PATCH v3 03/17] coredump: parse a snapshot of core_pattern
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-3-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=5307; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Haa/wVyspvaLZ+kfdekU+bfXGoKBsPMcmx94/xgcUP8=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGqxNNyi2QcsZwZptVnS+SHxd0aR6NrZ2bcBRHvqEraPesAch
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmqxNNwACgkQkcYbwGV43KLL2AEAsljD
 MwGHkO+fvYYw7mjQP8R3jVwtHBXUtAZXQoiB3QcBAPscjTkLH3Iv1c2qiGKhZRn/9W+CMgQVSQK
 8SAQ0GygP
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: at1hfeuax79n68r686kan79nohf4iujm
X-Rspamd-Queue-Id: C546EC000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1789998318-286893
X-HE-Meta: U2FsdGVkX1/86TigSSoqjpCKvWd5vUWuObUetSLGIGAIZyJVNi2VW9ylM9jtfplTqE6meYGGcEm+9KeV3RhmxYoR5A9KgHXhclSsq1diRUBfhaDT1AZOwSQ4J2SnT0TWRMBypJZc5yyjignuCA3gNON1fsjBmre0qi8yz8blw5NdpRzPB6Cn1/UBgeV1zxS9Uutnfz98Z/Qbx/P1XNE25tCzsPoMOknRutBoAlA3wR3aMXFoCx1k9UbHoIxO7kBujzzdQgLeFQf9LjUwYNp7OqXzWDl/pOZ8VVuSxmTkyFw2TwERB+Ujq6u/aiHnNXeMbf+z5txqGsHMXmU2cbfujmWF1JY7lfNZD8yJXpe1yaHVp2gPdnRNgAu2DHRgKEokXNZ9JRWSCFyzdUhC2Xugtb0pGBGosIaYgNz+7uStIXjD5nkloNcJyBS6XL/ZGeD2XFonXJiVrUnyU502OzRX5UfyhmMwovyxbASYsoBLqIpsq48VNGLya1n2vNSNQsQZ6DgJ6a2PAufrtTnZqSNShyXcCXzhIrk6tCAD+ky4j1qnQ9fgOIviN8iolFAW3LoYPA1PG+JfV6DmwEwFU1jrRLNlD2/1h/MjlWnNc4tsmBAkmS4wE90So5sRHpcqoYqF9YZ6JHJwwaFC1iIURb3IlhCGVSMf2A6mK+5Ir55j/l5O/9KIk2qfKeXHBGYNnp0TU1zHF1V59tHvgSo1j8lb7qkgUEVHTBteeP5jFBMNPfen3vH9mrEEA6lE+UoaWPNaj61KEVRMdi5VJn2ZPVzzmUEGj9ecn9KfTFGOqmoOg9R0jLKXXlcK3zloCbNbA7GUCfWsJIiRkza5sVvg0nLAkdcz0nAO/YPRYZ/VdMBssKlvRfWYtwyLSeRakQPs2g+oO2HH6A9bOfmB4ia1IP26QvTV+32hAn8jAXVCuL4SuJA/oix8gG91Aqn7xaYmspq3UKD/zHHKghOSBPmzZUL
 NCZ94IEP
 grouATbQUdt3ZV+qJDgCNoACUshgxLXHwFtnXBB/A49PsYJ90ze+m+GQBbY33NwzIOx52RhRjRosm/FXBtKs7PBQy3qS/JXohxyui8DB+Cqa8FI4PC+rt1g4QBxA3b63Aj34nJ1J9ArzTp33CRPlz2P0LbHWuV6pZcE6ZX9jxF0V2cPla6W7Hwcw2s1b6xHd+GWDoIdv/kliWy4+ngMktoBsBMxN7S+FbPlDbZz/LiDiha1VXeVUiqQBb6xIOVG5S3YMx9/jIlsu22CSjgRU+92NjDHEjuZMT8NLVt0AHDqS456xawQN8bT61L6CY1qv2aOiz
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

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 59 +++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 40eca2b85b81..d5d76704df81 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -85,6 +85,8 @@ static int core_uses_pid;
 static unsigned int core_pipe_limit;
 static unsigned int core_sort_vma;
 static char core_pattern[CORENAME_MAX_SIZE] = "core";
+/* Taken around every copy in and out of core_pattern. */
+static DEFINE_SPINLOCK(core_pattern_lock);
 static int core_name_size = CORENAME_MAX_SIZE;
 unsigned int core_file_note_size_limit = CORE_FILE_NOTE_SIZE_DEFAULT;
 static atomic_t core_pipe_count = ATOMIC_INIT(0);
@@ -240,11 +242,16 @@ static bool coredump_parse(struct core_name *cn, struct coredump_params *cprm,
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
@@ -1640,11 +1647,11 @@ void validate_coredump_safety(void)
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
@@ -1656,16 +1663,16 @@ static inline bool check_coredump_socket(void)
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
@@ -1673,7 +1680,7 @@ static inline bool check_coredump_socket(void)
 		return false;
 
 	/* Must not contain ".." in the path. */
-	if (name_contains_dotdot(core_pattern))
+	if (name_contains_dotdot(pattern))
 		return false;
 
 	return true;
@@ -1682,27 +1689,35 @@ static inline bool check_coredump_socket(void)
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
+		if (changed)
+			strscpy(core_pattern, pattern);
+	}
+	if (changed)
 		validate_coredump_safety();
-	return error;
+	return 0;
 }
 
 static const unsigned int core_file_note_size_min = CORE_FILE_NOTE_SIZE_DEFAULT;

-- 
2.53.0


