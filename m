Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0A4C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB47C6B00E1; Thu, 16 Jul 2026 10:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DD86B00E3; Thu, 16 Jul 2026 10:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7B66B00E4; Thu, 16 Jul 2026 10:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3F66B00E1
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2F1D12014A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:43:00 +0000 (UTC)
X-FDA: 84994906920.24.84D604D
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1564E80002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:42:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=dQsbi3Vk;
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212979;
	b=3T148ORxwh50KvKE8HV7mOOQVG06mmxSA7fsUkuQu302Op9RAVxkM/oIBfiZvewk5XMcOx
	helrEybFP4BIzFne3KDTgDFY/50iGSszGR+KSUt/BeeAzWtuZCvY1riMc7sTA8i3n8d09L
	8/xXtuDwdoicadwMGU+SNwHhjjFRMO8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=dQsbi3Vk;
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4c5dTszoqEm6NDTThmAIzODAGvFqwPJuKg6pJyF2JU=;
	b=j1GK1HDcvayUxdc8ahQPYhTHHn33ipGRDYeOuewClivH7QYebhOkZc5ZhxsTAWEV5AMhNu
	M1zOoiGv7f2RK5Oy6qO4nw3/OGaQ7Cyf38+MC3SuPt0gUOw1rOXAgJ9EIp3kNphZFzwGPo
	UCVsvd/ZX62Y33Zl60njO/4qKG6TJFM=
ARC-Seal: i=1; a=rsa-sha256; t=1784212519; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=jivl9Si2tzrgW2TWRxYTEgSGTrd9fIckk2zQgqpkmOpsYSl0qFMW1jESl/jSN8Gdx1yy/zW9ujsPO6U/Z+j84IUWuuTLjcbsJBk1fBLScDoqhYIoEvn7bJ2WYmlkKzsYcSk5e9R2h7sugIZLWas1C99LzPEL8IKBu0iZ1hJda2w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212519; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=l4c5dTszoqEm6NDTThmAIzODAGvFqwPJuKg6pJyF2JU=; 
	b=UlOIo6zIxvMm6ZvPr1oDZyFLQlspxpdfJ7AdvTLjPFYNMOtYMaErrEqov10/42UllktxPz98FNh5x9dcmSTqhxpZk1k+ijvgqLxvmmVWAMZjyjKGV9gJE/C2oEo59KyjOt0GkYBV211oniciVPU4+LdBjTPO0L2roPaZu1z2zcg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212519;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=l4c5dTszoqEm6NDTThmAIzODAGvFqwPJuKg6pJyF2JU=;
	b=dQsbi3VkI6jCoAjM5LNwtScRr+BQ10uZztyd9ethvs6BQ1bO7Va6o8QVjej7FyCr
	K9j/0ErAl5wQJvdioQ2YC2zf7xVwoQ5gxOHkcplaMkzJ9oxTWgAckgKgCJzcUK5Mwv8
	1xlm5c94CTysq10GjBXGRlpwds6xFZxBI5D/tGVg=
Received: by mx.zohomail.com with SMTPS id 1784212516958201.0119212011324;
	Thu, 16 Jul 2026 07:35:16 -0700 (PDT)
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
Subject: [RFC PATCH 19/24] file: expose spawn file-action helpers
Date: Thu, 16 Jul 2026 22:31:45 +0800
Message-ID: <0ef568259d4e7b0ec79e81ee16e0f38bfdab0483.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1564E80002
X-Stat-Signature: h36ifkyhhe45s7qkm3cxixr9bei7hjop
X-HE-Tag: 1784212978-819127
X-HE-Meta: U2FsdGVkX1+rRoc1XSn4S9haMvEQ1inLALo7qgNvb1Jp8n8vF7cM5kEbR8WQDuaDdQoT6ibkbP5u7jaCVw5MtP4Q5QncGvNHYZ81ZVm3pvNg8nH5gyRPyb8C9IeFivypip5ZyCgUDuYFGwLsBWqQmtA/7yGU1AwhXskJ2tvx1fOselnVGp5eAz0KybQFtKztz7EM3VLQmExcQtE6NobRuEAc/qRXmB0tvXvUt6fVHVYxZJWmQgqzhjvO5IzSAI4x/9LJyIs9OG0iSF1ca5XT7BjmOMTWAju6Gw/7lwCam/QfrwoAXDWs08oF7VoXp70kWPs8nJ5M5O4iOd/g9+Y33Bh46R+EoJDtPR5ADjcIwQaqfci44fI0wVn88ulXrr+CDCgA4QcPFUfnf1uBq4Liqa6Qk6FT+IWVVnOuIbJjQ+NHKdCX9MYV4P+VY8i/gy/sGOaxFci3yEWDrOjmcWBa3INx4Za7teTXl/2O9CQX1AHbLdrrvhQX2OcwhogiBGIO9DA92buZKKVEvqI/AsPjFWE+zp2a5EFrjljS0ayMlKVAXMBy6wrZAnpV/4HC3GPn68SIhvCd2CtywR+K7/+XYCWckzYxX9AxAfDKNfodT7RfPV5Zd14hqViG/rSnbtjOmBfTB3YtTAqus1qlo38W9J12gEDf5OJxp0rcZWoHD/eNGT4CSVf/aYSATEpR2dCqCp1qR9a/4Wwy9pqoWspKgelI8TBwgSnHPy+zgEnTD4Ekt2f3Q3hu3AR3IWiiGtu8ljvWagaDd/R8ZKWCbmOUoZtvrUvovkrnxYaZZZwzSt8DcuMqMQmRb3xgcHtmw0k6F9xPPmfARzCm6bqAM1RbiJnQ6548wBTKD+ZzpWbwTmQM1BJJ/nPo+XQvbLBhvWMzp1KDtGjQn3esWyl364lao4bF9dCr6EQX0LJhnRG0EKvq7gxsHfSSzrOKh5d39yr/mVlMADhhGE2SEJ9E6Xo
 ov0OEHuv
 EF+u6HDCM2PtshqAc5vTOmBDazySXiJDkdiwdp1URUK9XsuKRowNoscEGkt0JRm0Kg0nloXsVz1TJKkpDg5+smT2xBqqYtMAN4tVfIcCfi/61AzK0IQn4saRjJ2gyPo4VVJPw+sHQmxRzCQZM3W/8G4XYZFnn+csf/rwR9Luxqvvxgs0x2521tK9vIO42k3BgK5zjHYMZ3tveTLtVlIZbcZGI4bOWhPUqb0gCvqEKR0Qv1XtFcWeG5fvugcGLK1HPjWpkKpcH5A0D9YdmsfHGxsfXXewewIvdkYag/NKMW/BQJeD/0+1PpgfCLTtWPOAWkbJ8HRAt448BhmWivD+M2iTEtaovjxB0+ZdFZjSsk0Gcg/NSk1q4WA2Mrq7FCb6+PB3ZlJYVTVfujtCYRGOOQmg2AtKUtXq5biYfd4zM3g80qY+NO5aZok9tLcRnGfeVxl8T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Process builders need to apply close_range() and fchdir() while
preparing a child. Split the syscall bodies into internal helpers so
callers in fs can reuse existing validation and state updates. Keep the
helpers internal to fs rather than adding new global interfaces.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/file.c     | 11 ++++++++---
 fs/internal.h |  2 ++
 fs/open.c     |  7 ++++++-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 628ca07dc4b17..4f4cb1d5752c2 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -805,7 +805,7 @@ static inline void __range_close(struct files_struct *files, unsigned int fd,
 }
 
 /**
- * sys_close_range() - Close all file descriptors in a given range.
+ * do_close_range() - Close all file descriptors in a given range.
  *
  * @fd:     starting file descriptor to close
  * @max_fd: last file descriptor to close
@@ -815,8 +815,7 @@ static inline void __range_close(struct files_struct *files, unsigned int fd,
  * from @fd up to and including @max_fd are closed.
  * Currently, errors to close a given file descriptor are ignored.
  */
-SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
-		unsigned int, flags)
+int do_close_range(unsigned int fd, unsigned int max_fd, unsigned int flags)
 {
 	struct task_struct *me = current;
 	struct files_struct *cur_fds = me->files, *fds = NULL;
@@ -867,6 +866,12 @@ SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
 	return 0;
 }
 
+SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
+		unsigned int, flags)
+{
+	return do_close_range(fd, max_fd, flags);
+}
+
 /**
  * file_close_fd - return file associated with fd
  * @fd: file descriptor to retrieve file for
diff --git a/fs/internal.h b/fs/internal.h
index 71cc43e72b33e..25492194e2883 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -198,6 +198,8 @@ extern struct file *do_file_open_root(const struct path *,
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 struct file *file_close_fd_locked(struct files_struct *files, unsigned fd);
+int do_close_range(unsigned int fd, unsigned int max_fd, unsigned int flags);
+int do_fchdir(unsigned int fd);
 
 int do_ftruncate(struct file *file, loff_t length, unsigned int flags);
 int chmod_common(const struct path *path, umode_t mode);
diff --git a/fs/open.c b/fs/open.c
index 408925d7bd0b7..bf9d7bdcf487c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -568,7 +568,7 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 	return error;
 }
 
-SYSCALL_DEFINE1(fchdir, unsigned int, fd)
+int do_fchdir(unsigned int fd)
 {
 	CLASS(fd_raw, f)(fd);
 	int error;
@@ -585,6 +585,11 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 	return error;
 }
 
+SYSCALL_DEFINE1(fchdir, unsigned int, fd)
+{
+	return do_fchdir(fd);
+}
+
 SYSCALL_DEFINE1(chroot, const char __user *, filename)
 {
 	struct path path;
-- 
2.52.0


