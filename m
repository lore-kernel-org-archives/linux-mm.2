Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE59A60A2613
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ImYiBKVg
Received: by kanga.kvack.org (Postfix)
	id 650B16B05CD; Sat, 21 Nov 2026 20:19:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6009A6B05CE; Sat, 21 Nov 2026 20:19:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516956B05CF; Sat, 21 Nov 2026 20:19:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16B636B05CD
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BCACA068B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:35 +0000 (UTC)
X-FDA: 85460997510.14.09DDEEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CADBF20004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ImYiBKVg;
	spf=pass (imf13.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310374;
	b=3/4szHxrZ6Ee1GL3gsCxTOk5vJmu/S7w2GbR0K7ZCQya97HORMpC8xcZiH5G0QEmNAv/YT
	7wBUE2QwhvHbU04hfUVe/CtFwBhGMyIJk0q8aYWLpwhVSPbS8xrwSwaLjosJEByELUhYX4
	vEIhWnWjGolNccDk4p7ZlZMYVKd+mbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jfv3MMg/O7UN8A+W1NHYimNXqqAkPIDpKwh6yDT3Yps=;
	b=xR01heDO/d/Xmk2Vy87oY+VTUoSNQVd+X1H6/fL09rqpWzeqC+rSwelh3ZNHFvKb5tnhhU
	cBX7Y7yY4DBbkPqB1SVm7SxZAfgZ+YxGRBMBL/ldeT3qkGQOtKA5ehlCfrDmxe0cDRpYLm
	jlmP/H+W/JSQFKVN8egMM4pFwheBc1w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ImYiBKVg;
	spf=pass (imf13.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 26A654593F;
	Sun, 22 Nov 2026 01:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D51E1F000D2;
	Sun, 22 Nov 2026 01:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310373;
	bh=Jfv3MMg/O7UN8A+W1NHYimNXqqAkPIDpKwh6yDT3Yps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImYiBKVgbRfrgL6jWXxTiUQHqd1cEEzMz2iVAaA7uEeHzW4qLJDA3Tl2qGS/3utjZ
	 vH7FISh1UNPnyMNohDOGsom9ecspAClJKjNoOgplVjFIsRGrEtSBmfapZMPNZamQq1
	 stUP1vhyNg00QuEzC+Jcgt2GhFZBIdc80ERycGmeMUXDpAmT50+jxrbLIMCBdrfeT1
	 XI0TeGu0qJq904zZAMgLfpGW7w7+4+QruOgSA3OppYd/eN9giTW4jPDn8h0/uv9QAm
	 QkM/4NCJvGUQ2s+gGjCFYdooaAGbB7nkU9acbTLeYRCVyAXFKHeGUxZZBRobdO4d5l
	 N7vc71l/mwM4w==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 19/26] proc: Implement ->set_userland() fs_context operation
Date: Sun, 22 Nov 2026 03:18:02 +0200
Message-ID: <20261122011809.2667684-20-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: CADBF20004
X-Stat-Signature: uym6dszf13cchg9neifwycqdho3y3z6x
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795310373-298777
X-HE-Meta: U2FsdGVkX18cORWcJR3M474YCARkE1KzimpMdOxdmqJbeAjUwnjHHzauZwJOsHgiCC5MznfbFTyG+At9IgOx3qgVHltT1c4wrzHrkvC5hdCCRLMFhw4hvmw3w9I84gEGkMzna2RzXDlP0RGMXzUHzaD2aYpbT0vBJkzY5u0ChscPQjTFRdVkDK6bz2inMQ6L3+31vm/BUAFFBRks5oZm/aKuZQcnDDyI93J894jzo1QnTELkqND5sxmr5Qp3a3OK+Jv/KwV/mL6rrmFhekzfQQe07zwl24zF6NusA+ZVOrEE/L8jGV56Gbcy59VbZooFiT6OLFDZ0TU1ooEwsMgXn7kvCvOMRCSOEXyn7wQ0a00SY1Udd+oXFhL8ALw8CoVb+vG0FlZepFQU1EMbIY/z4krGIsyJ5fVlHn7IC6Ykqd8CE5tpOA8wcl0dFRAz2SSNSqUwYDber06HbEh048NVKI4ZEHSXtRfT0tTxO1dUN4CYMBivLWriotb4uMdlNI+1cST+xRXqZnJkYeRapsYiFt6uLn04RG4pGMcz0Jg7/Sa4Kz1yeK/BYndZB4C6BuI58I/BMS+6fgTeOtd/2VeEgSdDp1LE/cCHk4gBooZP/zXQPyuxQjjvljq4j0wtkiK0jsTUFuxtc3iI43+j/K7I5ZH04bE+ykLIVphLUejqzbqgz5kw7LhjLbJc4vP6BfdqKISLN2EW+fyTpBmEx8fX0iWArtud1zcwb3ZBprAcOBQXvmoocb6XHr1OMB1Hq/C2WsRfResN1/O5t7VxhZCgQxapgVpKVl9kYIGtWF/tVzJ2TI1546kLwWYTEFxbn944hyY+jqIJCWL+2VuJoIRU/Ms9cAAfRlu42x9BAQru4aUmuoJiLGdH3E/nNa7FkJJeS4U0mPP9qjgzYvDiMhwhg4G0/DnYHUvLlEMSfxCRi5R9DtlscMcg+z97eW5XouDaJ/FTnN0VoXcVnjLJV7x
 z+rF2g3P
 LXu+NtO5CFn1p+P2ZAX3rhKvQujKyi9m54bJZCeBB1c4i+9yOZMqeox4axRe53hi7EmVHd5By9J65RMsmzjc8FMD6yePYWXE4okhQOM6j7eiB8LlKfx7oPJe6zUg4XXgxPoVV4ZpDF6QcvhfcD3UjF6pfH3RoUZvPe1GjVvK/4sHTrDs8PO1iPek09UtTyL4dCS9DmeIZQZrw0eULm19d6EcpvX9yRp+N9hkOAaMDvOWG96L3ZdDQ5uqjU7liSbB+tOP/pJRK0wjjwpAm9adTcfVi+6oJhNN3YuNAktl+HjgqThFp44UY4ywDHUPoqU0PgZ8jmC6Rz0ubSTva5ntGb6QBl3h7zYUfT2M0CsDh5Kfmp2s+pJCL92VGSnf9xFqiFfoXNhJ1SM0h/Frg5RLgP4uC4rZVwxhllK3idKqUancHvFGE67uQaGB1M0k9+dcVUUlmMsfETTRqYpfrbaOV8X9x0tIjIa+jLA41nuyAqvTlK6Fmu73UXfcfKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_init_fs_context() binds ctx->pid_ns to task_active_pid_ns(current)
and resets fc->user_ns to ctx->pid_ns->user_ns, overriding the user
namespace delegated by FSCONFIG_SET_USERLAND and leaving the context
attached to the caller's PID namespace.

Wire up proc_set_userland() to verify that the target userland's PID
namespace is a descendant of the caller's active PID namespace and
rebind ctx->pid_ns and fc->user_ns accordingly, and mark proc with
FS_USERLAND_MOUNT.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/proc/root.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..e61b1a559172 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,8 @@
 #include <linux/sched/stat.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/nsproxy.h>
+#include <linux/userland.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
 #include <linux/mount.h>
@@ -206,6 +208,10 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			errorfc(fc, "cannot reconfigure pidns for existing procfs");
 			return -EBUSY;
 		}
+		if (fc->userland_bound) {
+			errorfc(fc, "cannot override pidns on userland-bound procfs");
+			return -EBUSY;
+		}
 		err = proc_parse_pidns_param(fc, param, &result);
 		if (err)
 			return err;
@@ -323,6 +329,21 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static int proc_set_userland(struct fs_context *fc, struct userland *userland)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+	struct pid_namespace *target = userland->ns->pid_ns_for_children;
+
+	if (!pidns_is_ancestor(target, task_active_pid_ns(current)))
+		return invalfc(fc, "cannot set pidns to non-descendant pidns");
+
+	put_pid_ns(ctx->pid_ns);
+	ctx->pid_ns = get_pid_ns(target);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
+	return 0;
+}
+
 static void proc_fs_context_free(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -334,6 +355,7 @@ static void proc_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
+	.set_userland	= proc_set_userland,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
@@ -371,7 +393,9 @@ static struct file_system_type proc_fs_type = {
 	.init_fs_context	= proc_init_fs_context,
 	.parameters		= proc_fs_parameters,
 	.kill_sb		= proc_kill_sb,
-	.fs_flags		= FS_USERNS_MOUNT | FS_USERNS_MOUNT_RESTRICTED | FS_DISALLOW_NOTIFY_PERM,
+	.fs_flags		= FS_USERNS_MOUNT | FS_USERLAND_MOUNT |
+				  FS_USERNS_MOUNT_RESTRICTED |
+				  FS_DISALLOW_NOTIFY_PERM,
 };
 
 void __init proc_root_init(void)
-- 
2.47.3


