Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D84F9CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7AD6B0098; Thu, 28 May 2026 05:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186726B009E; Thu, 28 May 2026 05:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3816B009F; Thu, 28 May 2026 05:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEA556B0098
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:56:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD2618D770
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:56:20 +0000 (UTC)
X-FDA: 84816373320.24.3CA4DF6
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id E285040004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:56:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=HwEjpNFq;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf17.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3VNKxy6o+qZDgK0d9YYafZFNdtvAg1gG3GqRA4oDgQ=;
	b=q40CFMUMuKEO0cvtwWycCdQjnA/nHxsGrmgZfClrqhBQTo71EEuupnl+mOzj6monGdVDnN
	pODptOY5QryX5d3prtro6MefBHGD+tWpXUXYdu49UoEUojE2owadJUf5DH5Y/LpQ7xr99u
	nhpDzz8YRYXOJm7ABDhJi+ow3NR7qZ4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=HwEjpNFq;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf17.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962179; a=rsa-sha256;
	cv=pass;
	b=sDlIhc+UyBh1MX3fP5v3JSbpXbZJDTa08XZmbrdv3ntaocrlKb1uAB0pyrgXStKKvwo/OO
	peNSeVV9jTp4WiNwikLvxb4AJsxC1gibSLQZrbC8q4VSQZ6b55WRhQxA9tcMXJ1ID1OKc+
	8z59qIVAXCstMyUlJ6UFpqwgymTxa84=
ARC-Seal: i=1; a=rsa-sha256; t=1779962035; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mmg76vlXUMu7dlawi6NDHCp6O0oTFsQmfTVuLFxqSdUMbKfjEZbCh0KyTqCVHrmMYsde1TRtQGy3wcqhSv16ptcHBg7nYepm3KNUx8enEz/Pg9luF0HGRmje6Ffk3ChonbxRp8amRuih7xfjIR2x4Z2vO6iJ1E8b63xbnWSIMyQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962035; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=S3VNKxy6o+qZDgK0d9YYafZFNdtvAg1gG3GqRA4oDgQ=; 
	b=OzARIUo5Ve2WqOMw+nknkyJkrJSsCGrZPjykF/ig+lqyb/HwRdF9n0fix4/EF2gA8V4cCriSANsXKoMsZkB2ALbSAP2O22hTk9FSjSU16Jw0sOgHR8gOnw+ggT3GCA6dP2S8RyCkIP4bMmOO5yZxobeAbFp/ngZNWXbjSMVr07k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962035;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=S3VNKxy6o+qZDgK0d9YYafZFNdtvAg1gG3GqRA4oDgQ=;
	b=HwEjpNFqDcXQlndFpGcTxqSRdxdCivlSsAwWArDbUHbdDJDZ+pBR+x3Ams3MWFNm
	Q6KM6gmwzkFMLwIFWBsQhzwojPzLcDA8IoFAhesrq7q+JRiq3AhM0YIPVJdCxKZ10kR
	VzYR8BXEsUxAphMcHjtw/1e8rzidyACy8KlBd9Ps=
Received: by mx.zohomail.com with SMTPS id 1779962032692104.2223552851018;
	Thu, 28 May 2026 02:53:52 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH v1 07/13] exec: validate spawn template executable identity
Date: Thu, 28 May 2026 17:52:28 +0800
Message-ID: <20260528095235.2491226-8-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E285040004
X-Stat-Signature: q9iu4o8s9ierci6pykedzpdgb96aje6m
X-Rspam-User: 
X-HE-Tag: 1779962178-472806
X-HE-Meta: U2FsdGVkX189J0CCIYhtti2/Y4EzW22XHDMMWbwrobU/gQTrXs8LCz3mvcOl3zscOKPAhxnMAxHsN+IYUe6wfhuQoDj3MORrEjo07U5965dRFnLkKHBMJcIwaQwcSEAUGza11LKztk1T3dDh2+Fy6A4l8G1O8LTXJtHr/d6aT7yn4wYgujL6exuudlXyoyJQHNg3tvTDkUtkenbMAJ9mNucSPjoNeNEesgqHrknVqh1FIc8aZ871ia7E6YolDv8S5r+fzdsl3HILOvMPv1hxc/jZboZPJSPKYhfCdhJoNp5gjwhjZJc2XJCNSBNp0FKZ2pNkAKWVslyCO0a6oUbd2FU4s7ouJkDMplT0EXAU/yIQa50TdzWDzYYNz/+RFp4kFh8lm75SpN3C6AVqwMYcpB3Wos7TYrft8EMZDR470sX3etoBJwiPgloQsoeTcDKFJYmfQ4oVYGqgfrRQ1PTLfddg2PgBYfxfKirIYRy+UPq31Ayd0r+2LSD7DYsscnJ1ceB68iR73PSeVZWLfFAbIF+rK0KdU2NPqhWJan6RBxrzDCRp5jOEw+32ElLBqKiM6qCAEdshHoTKn5Mf9bOkvoyC3H8rX3cbJ1fRWuSUozOc1WbBfOJHwxLV29Sai4jrZ5wknq2sIkAmZNB67VaYubhXZ1Fysc0fbh6NmenNY5qnnuteAQVlE8i/yGB+n7ybZ95rTxa6ZetalpCCLhzO7xAHNm0lC2s0axS24K5pJ8xDhXHASVfgYIVJJ5qVquH725PXW2LPen5ps77GoyERRkv649kckjcaBSxgHae4AkaBR/YwMyCKujO1RE7XKjRLvdrof4yZo/8HoLhp+6w70f/eaILEDBsSfVzsDyzXazigkHrYFR4i2WGo5DBNqbZHoot1XFUdhEu2MahgoQPF5Wp5HvXdlQXFkXB5ELgkS/mNFBfk+wSsRFbChhkP+i1Epn7WlH5LfLwykCgDnEG
 DqTX8qsS
 +e6j9ZFyGCg/9Qrn4/MqlAxD6BtCxvMK7wztyrh1BbsQh6fXCd1eteDLQxJWu0B//u++uWGphJWYMclbB2ziDJP7XOpWMPNdngUATn54+WtGgrSUUs6gI/PRHUyeNu7xzgaxvE+cWi22z5GduiyK8tRs7SvLDi6qa/Wl7PE6+goS7vUowJk+mtly/Ian09KEQtr0emAZmW7zoWL7VW/d5dghv38M716w4pGo1YNhFNZPX+3p+wPDT3iE6iNjgvSKyAwWjlmgt2Jwh3UPWwOgX/zwSbR+MbDYcVbqnoQaDCI1ciCGwWL0ChK+IHljzmcwJYqPZQnjHneRcfWs9Iu+RMwIDXygCgCI6Mr5cmOcUk1By3agmk+t2wZe6+XbMKunieydOj+u5JNc/gDXoCYnR26NDUoj4NQ72Gz9LBP/DJkyHCEK9olx0DPQ80dMIW1F979nmq3PlcEAjayKLSiQ4vq/Pww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Record a conservative executable identity key when a template is created:
device, inode, size, mode, owner, ctime, and mtime. Recheck it before
each spawn. For path-created templates, also reopen the path so a replaced
executable cannot silently reuse the old template fd.
Reject stale templates with ESTALE. Keep the check conservative by also
rechecking that the file remains a regular executable mapping target.

Signed-off-by: Li Chen <me@linux.beauty>
---
 MAINTAINERS                    |  1 +
 fs/spawn_template.c            | 75 ++++++++++++++++++++++++++++++++++
 include/linux/spawn_template.h | 25 ++++++++++++
 3 files changed, 101 insertions(+)
 create mode 100644 include/linux/spawn_template.h

diff --git a/MAINTAINERS b/MAINTAINERS
index d5441812825c3..ea4134a188779 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9737,6 +9737,7 @@ F:	fs/tests/binfmt_*_kunit.c
 F:	fs/tests/exec_kunit.c
 F:	include/linux/binfmts.h
 F:	include/linux/elf.h
+F:	include/linux/spawn_template.h
 F:	include/uapi/linux/auxvec.h
 F:	include/uapi/linux/binfmts.h
 F:	include/uapi/linux/elf.h
diff --git a/fs/spawn_template.c b/fs/spawn_template.c
index 8c3711929cffb..268f804227987 100644
--- a/fs/spawn_template.c
+++ b/fs/spawn_template.c
@@ -15,6 +15,7 @@
 #include <linux/sched/task.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
+#include <linux/spawn_template.h>
 #include <linux/string.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
@@ -27,6 +28,7 @@
 
 struct spawn_template {
 	struct file *exec_file;
+	struct spawn_template_file_key exec_key;
 	const struct cred *creator_cred;
 	char *filename;
 	bool deny_write;
@@ -40,6 +42,46 @@ struct spawn_template_spawn_context {
 
 static const struct file_operations spawn_template_fops;
 
+static bool spawn_template_file_exec_allowed(struct file *file);
+
+void spawn_template_fill_file_key(struct file *file,
+				  struct spawn_template_file_key *key)
+{
+	struct inode *inode = file_inode(file);
+	struct timespec64 ctime = inode_get_ctime(inode);
+	struct timespec64 mtime = inode_get_mtime(inode);
+
+	key->dev = inode->i_sb->s_dev;
+	key->ino = inode->i_ino;
+	key->size = i_size_read(inode);
+	key->mode = READ_ONCE(inode->i_mode);
+	key->uid = inode->i_uid;
+	key->gid = inode->i_gid;
+	key->ctime_sec = ctime.tv_sec;
+	key->ctime_nsec = ctime.tv_nsec;
+	key->mtime_sec = mtime.tv_sec;
+	key->mtime_nsec = mtime.tv_nsec;
+}
+
+bool spawn_template_file_key_matches(struct file *file,
+				     const struct spawn_template_file_key *key)
+{
+	struct spawn_template_file_key cur;
+
+	spawn_template_fill_file_key(file, &cur);
+
+	return cur.dev == key->dev &&
+	       cur.ino == key->ino &&
+	       cur.size == key->size &&
+	       cur.mode == key->mode &&
+	       uid_eq(cur.uid, key->uid) &&
+	       gid_eq(cur.gid, key->gid) &&
+	       cur.ctime_sec == key->ctime_sec &&
+	       cur.ctime_nsec == key->ctime_nsec &&
+	       cur.mtime_sec == key->mtime_sec &&
+	       cur.mtime_nsec == key->mtime_nsec;
+}
+
 static int spawn_template_exit_status(int err)
 {
 	switch (err) {
@@ -58,6 +100,32 @@ static bool spawn_template_cred_matches(struct spawn_template *tmpl)
 	return current_cred() == tmpl->creator_cred;
 }
 
+static bool spawn_template_key_matches(struct spawn_template *tmpl)
+{
+	bool matches;
+
+	if (tmpl->filename) {
+		struct file *file __free(fput) = NULL;
+		struct file *tmp;
+
+		tmp = open_exec(tmpl->filename);
+		if (IS_ERR(tmp))
+			return false;
+		file = tmp;
+
+		matches = spawn_template_file_key_matches(file,
+							  &tmpl->exec_key);
+		matches = matches && spawn_template_file_exec_allowed(file);
+		exe_file_allow_write_access(file);
+		if (!matches)
+			return false;
+	}
+
+	return spawn_template_file_exec_allowed(tmpl->exec_file) &&
+	       spawn_template_file_key_matches(tmpl->exec_file,
+					       &tmpl->exec_key);
+}
+
 static int spawn_template_copy_signal_set(const struct spawn_template_action *action,
 					  sigset_t *mask)
 {
@@ -433,6 +501,7 @@ SYSCALL_DEFINE2(spawn_template_create,
 						 &tmpl->deny_write);
 	if (ret)
 		goto out_free_tmpl;
+	spawn_template_fill_file_key(tmpl->exec_file, &tmpl->exec_key);
 
 	if (args.flags & SPAWN_TEMPLATE_CREATE_CLOEXEC)
 		fd_flags |= O_CLOEXEC;
@@ -507,6 +576,11 @@ SYSCALL_DEFINE3(spawn_template_spawn, int, template_fd,
 	if (ret)
 		goto out_free_ctx;
 
+	if (!spawn_template_key_matches(ctx->tmpl)) {
+		ret = -ESTALE;
+		goto out_free_actions;
+	}
+
 	kargs = (struct kernel_clone_args) {
 		.flags		= CLONE_VM | CLONE_VFORK | CLONE_PIDFD,
 		.pidfd		= u64_to_user_ptr(ctx->args.pidfd),
@@ -517,6 +591,7 @@ SYSCALL_DEFINE3(spawn_template_spawn, int, template_fd,
 
 	ret = kernel_clone(&kargs);
 
+out_free_actions:
 	kfree(ctx->actions);
 out_free_ctx:
 	kfree(ctx);
diff --git a/include/linux/spawn_template.h b/include/linux/spawn_template.h
new file mode 100644
index 0000000000000..f14a7749fe55b
--- /dev/null
+++ b/include/linux/spawn_template.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SPAWN_TEMPLATE_H
+#define _LINUX_SPAWN_TEMPLATE_H
+
+#include <linux/fs.h>
+
+struct spawn_template_file_key {
+	dev_t dev;
+	ino_t ino;
+	loff_t size;
+	umode_t mode;
+	kuid_t uid;
+	kgid_t gid;
+	u64 ctime_sec;
+	u64 ctime_nsec;
+	u64 mtime_sec;
+	u64 mtime_nsec;
+};
+
+void spawn_template_fill_file_key(struct file *file,
+				  struct spawn_template_file_key *key);
+bool spawn_template_file_key_matches(struct file *file,
+				     const struct spawn_template_file_key *key);
+
+#endif /* _LINUX_SPAWN_TEMPLATE_H */
-- 
2.52.0


