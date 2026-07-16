Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE6A8C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35EB86B0096; Thu, 16 Jul 2026 10:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BD66B009E; Thu, 16 Jul 2026 10:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029836B0099; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82EB96B0096
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1851C1201D3
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:41:57 +0000 (UTC)
X-FDA: 84994904274.08.E1E5D17
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf31.hostedemail.com (Postfix) with ESMTP id 39B6520002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:41:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=ZBwgMILz;
	spf=pass (imf31.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212915;
	b=3pW0ERuJpo6cKf+yq8hBpSGQ7FON2+Dv6sj0QkjzIHCCfJcizHbJCEIv1zcqGYqyo7+Y8f
	+isy2vYPwXOSUGZ5ZBW5O/H8+b1L8hefll2E/+AEy0e/MgNSQ5lwVfuNX7z7seZEcdqvPy
	OTMchj+e0XpvU8a62F5J3VMfQwxu6Q8=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=ZBwgMILz;
	spf=pass (imf31.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoK4SvsjwMeieg8o4bmFNUXZwhKfXanw0pGvrr4f5Qw=;
	b=A0E7+I1leibkeh2osvLYccxTCgVgDaPsyLaileTEq5rpgb4nusgy1G/VfsT0JbkgyyvaBo
	yy1ngrJOBqLsEW2jx2lOwQ4MYicepUTN7E3bogxUFR5xoLYtrIjNVufDT8PK726a9RXhYy
	+elC4RlaHgPa7I6ctLk0N+M1Q4vrPzk=
ARC-Seal: i=1; a=rsa-sha256; t=1784212501; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=nu1K5fhyZ84BrranuLaPmdTdPYfLMNoVfqxjZVOEDlsCLoSILd2b6p7FBWjyRMnnVxAVgiJMzqzjUrTsQrI6EqbwTfOeRmduFAdjnEued9yZ2rGfJk7hPvsaoGRa/UuY1BimEwsnamw98SnbNQiobm9Po4lupS0jq89f03LAQe8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212501; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yoK4SvsjwMeieg8o4bmFNUXZwhKfXanw0pGvrr4f5Qw=; 
	b=dk0WC6SoV2kLryLQGqSjCHYc8x6pN2bpOBCDJHFH6Q0InYDdkEaSk1/lUH2u+3sVqvUVQwdo+f/GAgBMzrKMomp9eFCbwncjZSFVkW8eFmEmkDPwV/Hs7H1/viELmAdpJ56cpzfY1Gq0GpNhGsK6kN6E15lmf7cVQX6ZkAXRkL8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212501;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yoK4SvsjwMeieg8o4bmFNUXZwhKfXanw0pGvrr4f5Qw=;
	b=ZBwgMILzjl5G63fDstUVtBkp8heqJiXzCOdKrgW63x/RQYv5US6IasXIoEcZHpxU
	UPtlNvrG5JJnrivIKEk7WsN4l4hqRGZ++4P4YPYiNBrOSnLBYa0lduxMelHrc3Bb3Y/
	a0m+7YUDJ7Y1F2iEvrXAhAhENxqtJTcGgc7rSWcM=
Received: by mx.zohomail.com with SMTPS id 1784212497833640.4955217561878;
	Thu, 16 Jul 2026 07:34:57 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 17/24] pidfd: audit child spawn execution
Date: Thu, 16 Jul 2026 22:31:43 +0800
Message-ID: <f12dd4088017f2718bcaf4b2796426f16ba486cd.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 39B6520002
X-Stat-Signature: 7ztxugxcnkbfabugorez7mbg4dcdmzwx
X-HE-Tag: 1784212915-964606
X-HE-Meta: U2FsdGVkX1/k6nTU8WmrV8rW4gLmrn6J4h98tDbuYVVXaxb1b1V+EK8ILsM7+7ogjIRkypZjlPIebpp+cdjoPpG9/oQvDz4W6YKLQHEwzfm8aAt6zrgfvWsZ012JouWKFDI50rXANANJGUsdwO0zQ+rNuXSRRtFwatuftxAqe99HNbfnZMHTFxqs8aVMYF7Od5qkMSIbU5s7n7nWU/1VzFN6EJkersgOt5qDLGJN0B9XHULcz3gx72ZUuB7l2Dpk6wQ2shKG53oLid/yctFhhOSA3X51jbQD9fh5b2eop5lhCcKzSQSG4MZE8qiUgeWBO2vLg66LoKIyPbqY3WQ3ZZhH+ewJaXgIBUghRUjMf0j0gY+VaLJmVGCTouodDOvOIi0NtI9F0dkiHQmcjPMCEEVOzA4niUl3lmgGiVx45O7ip0Tvt6s2fmBEHWAMflUBPElUPvEWhyiOKmFg2So2f2BAJ2RRWTTyhFDFf/G/GHGR0YFwlAg+7YfUYrXLQxY+6iL3MYT32PNlPOCpZ6E9X99jcNcu2nTBAG3/ct4ktIJEjnMXhIEBhWB2s1oxdt5hdRrrKXl1bv7cQL0otWOneNds0PherpVVWOvteopVnVutBBbMxX13oa5zn4cxUfzhBgX4gGPxt5S5RIQUu53wAlvrNvEJ8s+a0miFz9CGrHar3UrYCo1rNuZWk4mutiJeHGYD+tOWndbSu04hp6XNQ9YSR7WLH6uLZXyyC2L7tRjkthKsZ7XE7MpI3kwoLcXy2reXaMOAWOHThPo7GmRUo2GSidSNms3aiRcqcwcoPmWhWWhJ2XDN4ZpQTylyVa9755+Wxq33obZRDnmwsfLcYndrvP8qypaZ3ZPfRDkBcTonkirxdFhjkAkrJt+hPmHaizpxinup1kL3LnGxzWaSoa1BtyRzqtQBMdCAvKrOA7X+9K43aYJc9k9zPylW8KZWo9hrXkc+HpLabCnOcIm
 /99g5Ld2
 pGMauEp1QBCKcVfKRxkQAgyS/+kmTKiFUAV0IGlt9PzSQ8uUVZfNCybl7r0ZZDd02gr/RiTMAxEE7csRCeVijG6ihup+nIFHeuks0N8IBsbQFij7XKHvoywtOu3/nShg5SCQVEmaLN28kBpIlyXS/TOm4Q64AFKF4nTqDd0q2VgFAoUR8kE5qCHPEjDMEm2C+BZ5Q5f1Kz2sPbJqyn8+M67MUi5372t5veLg0LUI08olE+fcp/53zY7FxQWguzr5aVdPXVGnnq1Hzm/a7pVZcXAc4a/5ASVWP38/++L1xk73Do1qvlOsgX+77j8Cum+oFlRErI28/JDu9sESbJknSVFP4DfEJE78yS9Ye03L1+EA0AvH53HEg2kDXcxduYyLnNncTcHEYYx86DU4vXvw1aKiMXotL0qwr2YBvegFeUjrSFPKHK1oHmCkRdVtt6oU/+Oe4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The child exec path runs outside the caller's audit context. A delayed
filename can leave a name-only record in the caller transaction, but inode
metadata and exec arguments are otherwise lost because the new task starts
with an unused audit context.

Start a dedicated AUDIT_PIDFD_SPAWN transaction before executable lookup so
audit rules can observe child identity, EXECVE arguments, and inode-backed
PATH records. Close it explicitly with the child setup result.
Task work does not enter through a userspace syscall frame, so do not
synthesize one.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfd_spawn.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
index 41d5cbb49a0f7..5586926988406 100644
--- a/fs/pidfd_spawn.c
+++ b/fs/pidfd_spawn.c
@@ -3,6 +3,8 @@
  * pidfd-backed process spawn builders
  */
 
+#include <asm/syscall.h>
+#include <linux/audit.h>
 #include <linux/completion.h>
 #include <linux/cred.h>
 #include <linux/file.h>
@@ -81,6 +83,8 @@ struct pidfd_spawn_state {
 	char *staged_path;
 	struct user_arg_ptr argv;
 	struct user_arg_ptr envp;
+	unsigned long audit_args[4];
+	int audit_syscall;
 	int result;
 	enum pidfd_spawn_status status;
 };
@@ -206,6 +210,8 @@ static void pidfd_spawn_drop_run_data(struct pidfd_spawn_state *state,
 	state->staged_path = NULL;
 	state->argv = native_arg(NULL);
 	state->envp = native_arg(NULL);
+	memset(state->audit_args, 0, sizeof(state->audit_args));
+	state->audit_syscall = 0;
 	state->result = result;
 	pidfd_spawn_set_status(state, PIDFD_SPAWN_SETUP_DONE);
 	mutex_unlock(&state->lock);
@@ -377,6 +383,22 @@ SYSCALL_DEFINE5(pidfd_config, int, fd, unsigned int, cmd,
 	return ret;
 }
 
+static void pidfd_spawn_save_audit_context(struct pidfd_spawn_state *state)
+{
+	struct pt_regs *regs = current_pt_regs();
+	unsigned long args[6];
+
+	syscall_get_arguments(current, regs, args);
+	state->audit_syscall = syscall_get_nr(current, regs);
+	memcpy(state->audit_args, args, sizeof(state->audit_args));
+}
+
+static void pidfd_spawn_audit_entry(struct pidfd_spawn_state *state)
+{
+	audit_pidfd_spawn_entry(state->audit_syscall, state->audit_args[0],
+				state->audit_args[1], state->audit_args[2],
+				state->audit_args[3]);
+}
 static void pidfd_spawn_finish_child(struct pidfd_spawn_state *state,
 				     struct filename *filename, int result)
 {
@@ -391,6 +413,7 @@ static void pidfd_spawn_child(struct callback_head *work)
 	struct filename *filename;
 	int ret;
 
+	pidfd_spawn_audit_entry(state);
 	filename = complete_getname(&state->filename);
 	if (IS_ERR(filename))
 		ret = PTR_ERR(filename);
@@ -403,9 +426,11 @@ static void pidfd_spawn_child(struct callback_head *work)
 
 	pidfd_spawn_finish_child(state, filename, ret);
 	if (ret) {
+		audit_pidfd_spawn_exit(0, ret);
 		pidfd_spawn_state_put(state);
 		do_group_exit(PIDFD_SPAWN_EXIT_FAILURE);
 	}
+	audit_pidfd_spawn_exit(1, 0);
 	pidfd_spawn_state_put(state);
 }
 
@@ -575,6 +600,7 @@ static int pidfd_spawn_start(struct file *file,
 		state->argv = pidfd_spawn_user_arg(kargs->argv);
 		state->envp = pidfd_spawn_user_arg(kargs->envp);
 		pidfd_spawn_set_status(state, PIDFD_SPAWN_STARTING);
+		pidfd_spawn_save_audit_context(state);
 		reinit_completion(&state->done);
 
 		task = pidfd_spawn_create_task(file, state, &clone_args);
@@ -584,6 +610,9 @@ static int pidfd_spawn_start(struct file *file,
 			INIT_DELAYED_FILENAME(&state->filename);
 			state->argv = native_arg(NULL);
 			state->envp = native_arg(NULL);
+			memset(state->audit_args, 0,
+			       sizeof(state->audit_args));
+			state->audit_syscall = 0;
 			state->result = 0;
 			pidfd_spawn_set_status(state,
 					       PIDFD_SPAWN_CONFIGURING);
-- 
2.52.0


