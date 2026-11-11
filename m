Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DCD9606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n5m3cyLn
Received: by kanga.kvack.org (Postfix)
	id C40316B05C2; Tue, 10 Nov 2026 19:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6196B05C3; Tue, 10 Nov 2026 19:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68EE6B05C4; Tue, 10 Nov 2026 19:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 762516B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E6FD1A01C2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:28 +0000 (UTC)
X-FDA: 85420941816.21.EA28329
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DE2F80003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n5m3cyLn;
	spf=pass (imf02.hostedemail.com: domain of 3ubXzaggKCFIx6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3ubXzaggKCFIx6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356666;
	b=dZ2C+mr63daSWvlhUwlx+/ka8hZSCTkcJw0FmslQ56f+VxpQpHlpgRxodJYH4hJ+pm4pGx
	VWxL39rzTuK1UadbH7uKJIshAJFC4L0BCCna9AiY4aBBB2Ys3TmZ0P8AzhYpfXZio86aGn
	6CbaRILIcrZ1LCbqT2KdchrsebQsyw0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n5m3cyLn;
	spf=pass (imf02.hostedemail.com: domain of 3ubXzaggKCFIx6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3ubXzaggKCFIx6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M468tcMTyxiICGASSjMUyw305Z48xpIK1tm16lcJZuA=;
	b=47hxgbkbnn6xOa+GIdbD2pHlukTbRwNYJP45EpgMYUalIg5cQ44KTX09T9JWAJuSxXHz+m
	PMGW8zRvLFbCxljA/6FR0sVPaDndbjsTFHJDlBFY5v2gAIQzGBtarpHgyrmXd4N1Dm6AOK
	RwYMCwzLlKlcOr/R5uo+JOQ/E4pL05U=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a7de733fa9so3072099b6e.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356665; x=1794961465; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M468tcMTyxiICGASSjMUyw305Z48xpIK1tm16lcJZuA=;
        b=n5m3cyLnNNfj6w67NExx499AXtRsk38Kz86yr9L/zHH54DtHY9hD2JkmcgluB7O0Ex
         Okd8SCLIXmL0mkfmh6Zgyxe6+D/fk6ZQqS6ubVh+mvS8VeGQ9luodDbPKt9IN4dHuNS9
         bR3nNoxipZJrUzYTapBo3A/looO+yhHF3huuvnfUzfLMjPulHNnzxUH7GXPqg6OuCyi6
         GzdcgnJT7h372z38/6aJcW7WjKf+iOWCqQayjzEAVZ0tp9pFOOWb6yhDij7gm1oFPNRf
         jxpt7P91otQPPBCrOL6Dnv92zI43BStqYpSlTT2eUANCFqmkSjn82OZmdRPmYpEty/Ld
         zJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356665; x=1794961465;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M468tcMTyxiICGASSjMUyw305Z48xpIK1tm16lcJZuA=;
        b=IYT6Jt02voS/rXhl6D6Jgkn3XsmjWzQ9tAOnyc6jmYK0QD5NsJQOODUrVBkglFS/wR
         GnuugfdXLfcq/hIXfSDojowg7BYgDi8kM4hFLANiDG+Q9+qbDnhXqr33UqfSoPYE1KeO
         /JXbLMnyHSI5L2aBdkoNXlRCdow6FNt58vvjdhAast5h59xpEUrDQpt0Fykpq0/VSAj7
         8XjR2Q3lbHSHzOoPQ2fc5oNt86ZNf4zQYhsBtKZd+R08bEGScvv4fSuKrT74xs84zCVp
         ZhjJo0DGtGn3tcrc+lSTl0euAINKAnpOgdTXz1UtkB+7e3EqB249fzQLQCDDJT+kPcPN
         cfWg==
X-Forwarded-Encrypted: i=1; AL+hErFZy9LHqGx6kLP7+CxyfXBRxGpovheRgE/vekkdTJGURLxnRFzYdvkmdAwt9M5cu42rIK18xrzj6A==@kvack.org
X-Gm-Message-State: APuU4Z8jlK35w/MgQKSYENqRhJbb4TpEzKycKeV3ZRuHP61oCyOPJApj
	jq3rPcp0dXT53lI07sODBEQCO21QG66Mdkj5LhEFobSAyTwvOGifm5Oe06o2sO4HdZLyl3qFAz0
	lydqJsLrEIWebHw==
X-Received: from iocot34-n1.prod.google.com ([2002:a05:6602:c2a2:10b0:9c7:75ad:5e7b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2507:b0:4f6:6041:f0a2 with SMTP id 5614622812f47-56b96def35emr633097b6e.27.1794356665063;
 Tue, 10 Nov 2026 16:24:25 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:52 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-15-dmatlack@google.com>
Subject: [PATCH v4 14/19] selftests/liveupdate: Test which tmpfs files can be preserved
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hoprodrmpc7idbck44xu4xeras8iuxyj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DE2F80003
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794356666-293476
X-HE-Meta: U2FsdGVkX1/LzAiC6zJNq6/LrqGPJMAIxcCViQrSBRfP8uNQtmPGIeP7IWhNPV7uGzm5ku91vbgglKcIC78vzMfaoNTFKyc693Ie02VhX1v+eVUixg1BLYVa1GCuiuTaoy9EK0kK7azj1JH9XMcr7y8FSRyAea5SEUYpn463FMKQHVf7IB4d4HjFAybMDcrle30Vq4DZhbFnwvjVa2fbE90XKS+Kbqq782HFR9G/VltfxYaCLKr0UdLSnRF6NDWpSIZrd2my687E4hriUERf6gqxkGwRT1oOi2SUQJ3GhHsSLHLTU2812dzVrG9BUOTK6RcB/5adzGv8bLuEHCdmiljdlBk3Jr3mZp2jp8C7pidzYEaQs60w2d+B6MJVY3r/Tc70GDb2tg79O4DWoPMxs2RO6NifBv+BUBPLKslGJhiMIvlsi4+jOClb5O+W5lkmeoY29JwGl7iAc/0o/Am7JOjwahYCf91XVfHaWuCDThjYU+DBBY6WMEKPmUeD6ojwMFnjf3vVUY09AwpcHEOtov48484I4S+3aMZepwUakYjEp5e3U3upVvZoEciDeSoTro5vJS6FlMzX2Jm4gt2ViFF6fs2pcqhzKTy64daGJUjCD/j4a2mUMOlam22aSLx+G/dglZXSlBZRR3tamjnkPuTaEeaTTCs8W1BQ/PK8QFQ9nqNp43T53ZeUpZimHLOWhyqRlNmK4iYmkowTz37gcqWmVj0rldwT6hY0z/+8Nq2ZHh/3B68hIV3WPbKr7vnC173c0Lu2+R8PVdtYv57P06wIQu7d24nUR90BftHaRg0PsmMXUwB82XKj6y9EzUd8AmBFY/j99P8MDLZpqp8BUtmqGydJcvWTQz2wLE15E+QnIyzAWB+rPB3F+UT34zbtfZHxza47kNwYGLAb6TDaoH7biO6Qsv6jjD5Y/1PrN4dlHls95OyobmrYuQlqctFFxaT2XcdbxA7q6wsLcZ8
 fSpTAvXv
 yyKIzQQVVUTfRHu+FTwOrhyKCG4GC/yXVGqq5picNvg6ZSaGo0oUkzK9A9Daf3wFzvyzQGGGa6iFLWvrgJsEbU41mstVac71ua5WblWF8u4ZTCQKTCBcMueDXFKB16cmasadU+DXvQ5Yvp/S/LCtdAEkxMIEAd42gn1PROUW2+BAgwFG2W+9f8u8bHuVvlikuzIRBU6JUR1IKXcp9pB7mK0kg1cBsiEAPD1pXsjkqcqKjI3a+RRr7KNeeCjKhajLMH6n3iGlcrGTOVueuMwDHcsHLbybKdXcrFWJl32LRh2ZkySTEYWl7EB/zRsOwjBvSyMWb9KUWXOXMKFuMMk/ZIxIYmOdtzEva5vH8vLGDvJm1wbfqjZrWTINUt/SxQwBmuqbF9yWMvtTmH520felBSsyaZHeMDMCYvcuvRfuv2y84ytyClp+zJ/2xJIRAqrWX0lqCNOmQmC/mQGiE0k9xwxoCtQheZBwg1mla2pCCdYU6hnWmaQ1+hx/pSRfT9q0KJJj/08Z3vnTTHUt/tQxGPVX+Jgg9IbriikZ4EZ5HMR7FWd2a1jUu9U8y8H17sPRQ6lmSDoBpfgCBaJuP2f+y4rIUpiJtBtbTsxXM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add tests to liveupdate.c for the checks done when preserving a tmpfs
file: A file can be preserved through a read-only fd, but not a
write-only fd. Preserving it requires permission to write to it, except
for the owner of an immutable file or of a file on a read-only
superblock. Append-only files can't be preserved, and files can be
preserved through a read-only mount. Also check that the size of a
preserved file is frozen until the file is unpreserved.

These checks don't need a kexec, so they run as part of the regular
liveupdate selftest.

Enable CONFIG_TMPFS_XATTR for FS_IOC_SETFLAGS. The test cases that use
it are skipped without it.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/liveupdate/config     |   1 +
 .../testing/selftests/liveupdate/liveupdate.c | 303 ++++++++++++++++++
 2 files changed, 304 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
index 016d009dba13..37230f4c488f 100644
--- a/tools/testing/selftests/liveupdate/config
+++ b/tools/testing/selftests/liveupdate/config
@@ -9,4 +9,5 @@ CONFIG_LIVEUPDATE=y
 CONFIG_LIVEUPDATE_TEST=y
 CONFIG_MEMFD_CREATE=y
 CONFIG_TMPFS=y
+CONFIG_TMPFS_XATTR=y
 CONFIG_SHMEM=y
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 4c4272167635..3d943b5672e6 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -16,15 +16,24 @@
  * - Resource preservation: successfully preserving individual and multiple memfds,
  *   verifying contents remain accessible.
  * - Complex multi-session scenarios involving mixed empty and populated files.
+ * - Which tmpfs files can be preserved, and the frozen size of preserved files.
  */
 
 #include <errno.h>
 #include <fcntl.h>
+#include <grp.h>
 #include <stddef.h>
+#include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
 #include <unistd.h>
 
+#include <linux/falloc.h>
+#include <linux/fs.h>
+
 #include <libliveupdate.h>
 #include <linux/liveupdate.h>
 
@@ -574,4 +583,298 @@ TEST_F(liveupdate_device, preserve_memfd_with_arg)
 	ASSERT_EQ(close(mem_fd2), 0);
 }
 
+#define NOBODY 65534
+
+FIXTURE(preserve_tmpfs) {
+	char dir[32];
+	int luo_fd;
+	int session_fd;
+	bool mounted;
+};
+
+FIXTURE_SETUP(preserve_tmpfs)
+{
+	self->luo_fd = -1;
+	self->session_fd = -1;
+	self->mounted = false;
+
+	self->luo_fd = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->luo_fd < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->luo_fd, 0);
+
+	self->session_fd = luo_create_session(self->luo_fd, "preserve-tmpfs");
+	ASSERT_GE(self->session_fd, 0);
+
+	strcpy(self->dir, "/tmp/luo-tmpfs-XXXXXX");
+	ASSERT_NE(mkdtemp(self->dir), NULL);
+	if (mount("tmpfs", self->dir, "tmpfs", 0, "size=1M"))
+		SKIP(return, "Failed to mount tmpfs: %s", strerror(errno));
+	self->mounted = true;
+	ASSERT_EQ(chdir(self->dir), 0);
+}
+
+FIXTURE_TEARDOWN(preserve_tmpfs)
+{
+	if (self->session_fd >= 0)
+		close(self->session_fd);
+	if (self->luo_fd >= 0)
+		close(self->luo_fd);
+	if (chdir("/"))
+		return;
+	if (self->mounted)
+		umount2(self->dir, MNT_DETACH);
+	rmdir(self->dir);
+}
+
+/* Create the file @path with some contents and the mode @mode. */
+static int create_file(const char *path, mode_t mode)
+{
+	int fd;
+
+	fd = open(path, O_CREAT | O_EXCL | O_RDWR, mode);
+	if (fd < 0)
+		return -1;
+
+	if (write(fd, "data", 4) != 4 || fchmod(fd, mode)) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+/* Open @path with @flags and preserve it. Return 0 or -errno. */
+static int preserve_path(int session_fd, const char *path, int flags,
+			 __u64 token)
+{
+	int fd, ret;
+
+	fd = open(path, flags);
+	if (fd < 0)
+		return -errno;
+
+	ret = luo_session_preserve_fd(session_fd, fd, token);
+	close(fd);
+	return ret;
+}
+
+/* Like preserve_path(), but as the user nobody. */
+static int preserve_as_nobody(int session_fd, const char *path, __u64 token)
+{
+	int status;
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0)
+		return -errno;
+
+	if (!pid) {
+		if (setgroups(0, NULL) || setresgid(NOBODY, NOBODY, NOBODY) ||
+		    setresuid(NOBODY, NOBODY, NOBODY))
+			_exit(255);
+		_exit(-preserve_path(session_fd, path, O_RDONLY, token));
+	}
+
+	if (waitpid(pid, &status, 0) != pid || !WIFEXITED(status))
+		return -ECHILD;
+
+	return -WEXITSTATUS(status);
+}
+
+/* Add the inode flag @flag, e.g. FS_IMMUTABLE_FL, to the file @fd. */
+static int add_inode_flag(int fd, int flag)
+{
+	int flags;
+
+	if (ioctl(fd, FS_IOC_GETFLAGS, &flags))
+		return -errno;
+
+	flags |= flag;
+	if (ioctl(fd, FS_IOC_SETFLAGS, &flags))
+		return -errno;
+
+	return 0;
+}
+
+/*
+ * Test Case: Preserve Through Read-Only and Write-Only Fds
+ *
+ * A file can be preserved through a read-only fd, but not through a
+ * write-only fd, since the retrieved file can be read.
+ */
+TEST_F(preserve_tmpfs, access_mode)
+{
+	int fd;
+
+	fd = create_file("file", 0644);
+	ASSERT_GE(fd, 0);
+	close(fd);
+
+	EXPECT_EQ(preserve_path(self->session_fd, "file", O_WRONLY, 1), -EBADF);
+	EXPECT_EQ(preserve_path(self->session_fd, "file", O_RDONLY, 2), 0);
+}
+
+/*
+ * Test Case: Preserve Without Write Permission
+ *
+ * Preserving a file freezes its size for all of its users, so it requires
+ * permission to write to the file.
+ */
+TEST_F(preserve_tmpfs, unwritable)
+{
+	int fd;
+
+	fd = create_file("file", 0644);
+	ASSERT_GE(fd, 0);
+	close(fd);
+
+	EXPECT_EQ(preserve_as_nobody(self->session_fd, "file", 1), -EACCES);
+	EXPECT_EQ(preserve_path(self->session_fd, "file", O_RDONLY, 2), 0);
+}
+
+/*
+ * Test Case: Preserve an Append-Only File
+ *
+ * Freezing the size of an append-only file would stop all writes to it, so
+ * append-only files can't be preserved.
+ */
+TEST_F(preserve_tmpfs, append_only)
+{
+	int fd, ret;
+
+	fd = create_file("file", 0644);
+	ASSERT_GE(fd, 0);
+	ret = add_inode_flag(fd, FS_APPEND_FL);
+	close(fd);
+	if (ret == -ENOTTY || ret == -EOPNOTSUPP)
+		SKIP(return, "FS_IOC_SETFLAGS is not supported");
+	ASSERT_EQ(ret, 0);
+
+	EXPECT_EQ(preserve_path(self->session_fd, "file", O_RDONLY, 1), -EPERM);
+}
+
+/*
+ * Test Case: Preserve an Immutable File
+ *
+ * The size of an immutable file can't change anyway, so its owner may preserve
+ * it. Others still need permission to write to it.
+ */
+TEST_F(preserve_tmpfs, immutable)
+{
+	int fd, ret;
+
+	fd = create_file("own", 0644);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(fchown(fd, NOBODY, NOBODY), 0);
+	ret = add_inode_flag(fd, FS_IMMUTABLE_FL);
+	close(fd);
+	if (ret == -ENOTTY || ret == -EOPNOTSUPP)
+		SKIP(return, "FS_IOC_SETFLAGS is not supported");
+	ASSERT_EQ(ret, 0);
+
+	fd = create_file("other", 0666);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(add_inode_flag(fd, FS_IMMUTABLE_FL), 0);
+	close(fd);
+
+	EXPECT_EQ(preserve_as_nobody(self->session_fd, "own", 1), 0);
+	EXPECT_EQ(preserve_as_nobody(self->session_fd, "other", 2), -EPERM);
+}
+
+/*
+ * Test Case: Preserve Through a Read-Only Mount
+ *
+ * Preserving a file only needs permission to write to the file, not a writable
+ * mount, so it works through a read-only mount.
+ */
+TEST_F(preserve_tmpfs, rdonly_mount)
+{
+	int fd;
+
+	ASSERT_EQ(mkdir("src", 0755), 0);
+	fd = create_file("src/file", 0644);
+	ASSERT_GE(fd, 0);
+	close(fd);
+
+	ASSERT_EQ(mkdir("ro", 0755), 0);
+	ASSERT_EQ(mount("src", "ro", NULL, MS_BIND, NULL), 0);
+	ASSERT_EQ(mount(NULL, "ro", NULL, MS_REMOUNT | MS_BIND | MS_RDONLY,
+			NULL), 0);
+
+	EXPECT_EQ(preserve_path(self->session_fd, "ro/file", O_RDONLY, 1), 0);
+	umount2("ro", MNT_DETACH);
+}
+
+/*
+ * Test Case: Preserve on a Read-Only Superblock
+ *
+ * The size of a file on a read-only superblock can't change anyway, so its
+ * owner may preserve it. Others still need permission to write to it.
+ */
+TEST_F(preserve_tmpfs, rdonly_sb)
+{
+	int fd;
+
+	fd = create_file("own", 0644);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(fchown(fd, NOBODY, NOBODY), 0);
+	close(fd);
+
+	fd = create_file("other", 0666);
+	ASSERT_GE(fd, 0);
+	close(fd);
+
+	ASSERT_EQ(mount(NULL, self->dir, NULL, MS_REMOUNT | MS_RDONLY, NULL),
+		  0);
+
+	EXPECT_EQ(preserve_as_nobody(self->session_fd, "own", 1), 0);
+	EXPECT_EQ(preserve_as_nobody(self->session_fd, "other", 2), -EROFS);
+}
+
+/*
+ * Test Case: Frozen Size of a Preserved File
+ *
+ * While a file is preserved, its size can't change and no holes can be punched
+ * into it. Writes within the file still work. Closing the session unpreserves
+ * the file, after which its size can change again.
+ */
+TEST_F(preserve_tmpfs, frozen_size)
+{
+	long page_size = getpagesize();
+	struct stat st;
+	char c;
+	int fd;
+
+	fd = create_file("file", 0644);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, 2 * page_size), 0);
+	ASSERT_EQ(luo_session_preserve_fd(self->session_fd, fd, 1), 0);
+
+	EXPECT_EQ(ftruncate(fd, page_size), -1);
+	EXPECT_EQ(errno, EPERM);
+	EXPECT_EQ(ftruncate(fd, 4 * page_size), -1);
+	EXPECT_EQ(errno, EPERM);
+	EXPECT_EQ(fallocate(fd, 0, 0, 4 * page_size), -1);
+	EXPECT_EQ(errno, EPERM);
+	EXPECT_EQ(fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
+			    page_size), -1);
+	EXPECT_EQ(errno, EPERM);
+	EXPECT_EQ(pwrite(fd, "x", 1, 2 * page_size), -1);
+	EXPECT_EQ(errno, EPERM);
+
+	/* The size didn't change, but writes within the file work. */
+	ASSERT_EQ(fstat(fd, &st), 0);
+	EXPECT_EQ(st.st_size, 2 * page_size);
+	EXPECT_EQ(pwrite(fd, "x", 1, page_size), 1);
+	EXPECT_EQ(pread(fd, &c, 1, page_size), 1);
+	EXPECT_EQ(c, 'x');
+
+	ASSERT_EQ(close(self->session_fd), 0);
+	self->session_fd = -1;
+	EXPECT_EQ(ftruncate(fd, page_size), 0);
+
+	close(fd);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0.542.g3ef89b7020-goog


