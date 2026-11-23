Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142B2606A322
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kIgbcy+d
Received: by kanga.kvack.org (Postfix)
	id 65F2E6B05C1; Mon, 23 Nov 2026 18:39:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638906B05C2; Mon, 23 Nov 2026 18:39:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DD06B05C3; Mon, 23 Nov 2026 18:39:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 180636B05C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B70C4C0884
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:49 +0000 (UTC)
X-FDA: 85468003698.10.58C5FC8
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id EA976180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kIgbcy+d;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3ws4EawgKCNE09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3ws4EawgKCNE09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477188;
	b=PG24HLUwVRJTwCSHst0yymYw8sd9dncoLJ6cSDjU8MpUWKE5bAKzCPG0LgoHDZ9Uv/nI/S
	3tW2oy1FgDeWapnwNyExEZwy8TvDCwiDoQB6SISL2pxgRASY7di0/i0dRiBlpv8xH2isLg
	DAAcQa9yyOTMlQo5zib0aiJEUPtxSsM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0gvYOUOsBh9zCqNwor8+pPkFTru+bs+6gLwfR5yOEk=;
	b=8fhFCc8ITVkPClss+OHOudLAT2pglvGSkW+eaX4ZlfzWT96BtSLOCKEt7kNl6vc3d9lqk8
	ctDudfzccA+9ny3gxzTsxSHBwfOr9wonbdHgbWTTUizgQSh9eRuT7vCQ9RcQcg67+E3NM8
	xDUzsrFxwwB7n0XZ9BBHKOdgPe5etlE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kIgbcy+d;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3ws4EawgKCNE09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3ws4EawgKCNE09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-5384e381fbbso3538284b6e.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477187; x=1796081987; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/0gvYOUOsBh9zCqNwor8+pPkFTru+bs+6gLwfR5yOEk=;
        b=kIgbcy+d8CSOuZTFNjIM3gM1ae+bPA2lcMLg46+cpYZ0BKfDqQYmSH82HO24kPOnM/
         UbfdVhhvCAM+6Fp7HmGo4SKHZ3Vs4lA9E0DTFvvRJygUT59FJyhTQfDTPCgSbcrmuyYL
         luw2qTSM9U3LmNsNJgfQc0KjX6noLYQn31lH4zYY1ShAoLlKxlJo/wH3aoGhwpco6JSj
         13pSY1O65tg43uKrJwi7TtLdPSNwqct8KHikkJDF6nDOgIgyZGZHTgh2Fq2Btt+2IOYJ
         wUxXZaE0TvC+GmR7gZSThn2nGrLIJoR//2Ee0bF7GTXe7enWx5LlEPzpPUHh0BHp9PYP
         fUag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477187; x=1796081987;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/0gvYOUOsBh9zCqNwor8+pPkFTru+bs+6gLwfR5yOEk=;
        b=ABRTSYBvxnbnatv/HDX12mieHG6zZb3m8uXl3bV8jmzIOtxAwlwQTPWDLpYRAnenoC
         8W7z8kJ9Md5VmNH41Lj08RTFkuhoVuuwJWSOMbB6c+t24UwczLq7wlTRdRXztu+fhPyV
         fCUZDp/hwV1fUin7TFSr5ZEVkw4gN6gGRQLKCbi0pGC9VwH9sUdhzJ4HflLt4UjNhmOX
         BHSkTbX1a3lONzSFPpoAoEPDK5Ts5yEbdUneld6QPve/nkyClS5Xyfk9f8IGfWEMQcZM
         BGLBMVBt9QPUK2Epxw4GKRKoeoC25RnpOlFNOfpUt4TJmkLhGyjMDjMlpY9zMyeoCRYX
         rofA==
X-Forwarded-Encrypted: i=1; AL+hErGWDcnDMUBj219e10JIpRmAfnnPbyxtceIJaospRudKaco8iL5ZA+8K7Sza98eRk1LEZPp2j+NB7Q==@kvack.org
X-Gm-Message-State: APuU4Z8f+Fs23nzL6+abE7713Njq30I0J5Mf18yP9bZs3umF2dVy7y3s
	RPMfYx1JbtFZAoimEbGFslazZw2Dtm2P1SMwwmmSDWZh5egT5b4ws6G3n35ie2RgmroP6aGKHFh
	IZLqUsilzUgqxsA==
X-Received: from ilben18-n1.prod.google.com ([2002:a05:6e02:5112:10b0:54e:8e95:90ae])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4488:b0:4f9:6348:cd3b with SMTP id 5614622812f47-57a0b4413abmr14381949b6e.41.1795477186803;
 Mon, 23 Nov 2026 15:39:46 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:18 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-14-dmatlack@google.com>
Subject: [PATCH v5 13/18] selftests/liveupdate: Test which tmpfs files can be preserved
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
X-Rspamd-Queue-Id: EA976180003
X-Stat-Signature: m6bhmgkjmbmgxyumfbs9stenbe7n3rj1
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795477187-705789
X-HE-Meta: U2FsdGVkX1/xqJ8SMymQCnckain8dViB2qEqze3W4NKH1p6t63RCnA/YsHtMDEaawmq4I7Q3LMjRxpTBK6/dTOnlVyT093K5CEfJM/nZgG8g4zoTL84CapQCjuWzplssPxZ3Ezb9wMulL/aAb70rUBz4Iwreblkl5WrSPSZxO6zhE3B9FBmC3JEpTwgthT1U22nYm69/NL7NBBzAmv90LccZ8yp/EptaBiS+g8HbnfAO6ugFwHSmyGZzP929J9qSwR6pyqWqeEJKnHE2xadb4NDOpbRgQAJQOJAoQDycwonArYw7NweE8ZJP9JDbq1n5czmlVsRJw01C54pH/8RjTKoF0pavdzNgoBTq9/V6jRrkLSdPfXeTnlWMryblrfALjJaSXVo/afizt6yZY05X2TUD/bPoE3W2Z4rQOySyaDzeCUnQqs+lUOiEFEMAByXQdBoI3TAA4fMCXoJSLUHRYmWy0s3cLoybJ6seqDr+sVdrw9b5Z/HRTROULFKdQ1El72OObyUgJQW6E9dg1ZKf5XSPktJTtWeUk274YSJMz0Jn6BIKihR76EJ63qIYOQQKIC4Zsv9jOkITLNjug/JzJOI1hHVFpYs5Xah6weq5utk7FkW6036QlycdbDWTcsHr2AsOpbGob0rIjnTeAL/LWH/s8k+cjj2etebb6Y9y2CUmaRmJUn4huwX5Fc8CUH8o4sNB7cjJikNGraSvKhNVD983D5kPIMLiUz5jRNLQvWmZ0YbtoZXNP7xKEGcmoU9YTAw6Royes0kA3vO+QFsyiEUHV/NYOWmgN0TMNAduq2tzMJWZWH/ClJFv05d5spOE3m5Q+/c/LAsOX68jF4+Ra8XGGGGM8/YG8ivZu0PMcN/+k5GBy+k8SuGiXw196ZMt8ATzgspO+ziVqOhTf7aymE8TmdThBjaJnENs3ocW6fcbAebdf5CIZKYEq42yTZGXZsWawWLcjL3tgLB/y17
 HhXwhicF
 qlSq6QjLhIycG86oBAvXplanChOSqL6J6f3DoualqPmLHImKbhAWRdaIc59i4JzatF+QPfyBJrjZ12rbALUYlj5ZSAUzKAmTN1S2Pw9Z7XbDOUdGR5vmb0+Ic/h+G8xQeNOnziPdvmP27dl3CNfFBeMAu8FgD9QlGDpT1+gl9V4txmbc5g+pZ7PSTNWm7ynnl+CrZQk3zztfff7MGiWIMqjN7VVMQJba4oDRa81YEbjYw0nPOb4f8j3RTJGHBoLxFezDjrLsk0urAJ9yEbwqrv4heboAqDq1MTPTiZK2avc+n9ivnq0wIsH8/h4ksnSvlb9fjtt9FoRjOdXCctaKRiTNrUOo0dTMcI9j6i3QcQHN0BXE5/KzlWfQCygkppSOseOE0oHFICCnzXj0riuszCMvwZT3AlOfmaspk0nitLWXbI4cnnMYocKqwkB5zk+bZutRmZD8esiVppW3TZa3cblwilMWqgXAxr+N9klge7gCL4VNpPM/LbirAxI4ST+ENAwcrAird2IuybvIO6u9zHOpyM33zco8gu+TfKJ7KUF1iU01/NP3rsMhTfj2aeK9aVvLwjPKJVU7zOFPQV8wP0xb8pLh0EdMqmnYKKNvF87EO0XiPHON11s9q9ftn0HEguWD9K90MBo7P+GODgq3tExMu+dlgc50DsbUi/RRKjif0lrzobXORljHeHJwMs3PNfyfutjA+UhvjPVGuqDIrtHQok7WLuQaYmv9yw3PJ1wNLRRlD1AZBf8hpZ2aGXgdu/eGaZQ94xJZLcGc0d//+peVhbYzA+sokxVkk
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
preserved through a read-only mount. Also check that operations that
would change the size of a preserved file fail with -EPERM until the
file is unpreserved, while reads and writes within the file work.

The errors of these preserve failures aren't documented, so the tests
only check that the preserve fails.

These checks don't need a kexec, so they run as part of the regular
liveupdate selftest.

Enable CONFIG_TMPFS_XATTR, which tmpfs needs for FS_IOC_SETFLAGS. The
test cases that use it are skipped without it.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/liveupdate/config     |   1 +
 .../testing/selftests/liveupdate/liveupdate.c | 316 ++++++++++++++++++
 2 files changed, 317 insertions(+)

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
index 8b6e61695a35..094e7e22c1fb 100644
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
 
@@ -578,4 +587,311 @@ TEST_F(liveupdate_device, preserve_memfd_with_arg)
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
+	if (mount("tmpfs", self->dir, "tmpfs", 0, "size=1M")) {
+		int err = errno;
+
+		rmdir(self->dir);
+		SKIP(return, "Failed to mount tmpfs: %s", strerror(err));
+	}
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
+/*
+ * Open @path with @flags and preserve it. Return 0 if the preserve succeeds,
+ * -errno if it fails, or 1 if @path can't be opened.
+ */
+static int preserve_path(int session_fd, const char *path, int flags,
+			 __u64 token)
+{
+	int fd, ret;
+
+	fd = open(path, flags);
+	if (fd < 0)
+		return 1;
+
+	ret = luo_session_preserve_fd(session_fd, fd, token);
+	close(fd);
+	return ret;
+}
+
+/*
+ * Like preserve_path() with O_RDONLY, but as the user nobody. Also return 1 if
+ * the child can't become nobody.
+ */
+static int preserve_as_nobody(int session_fd, const char *path, __u64 token)
+{
+	int status, ret;
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0)
+		return 1;
+
+	if (!pid) {
+		if (setgroups(0, NULL) || setresgid(NOBODY, NOBODY, NOBODY) ||
+		    setresuid(NOBODY, NOBODY, NOBODY))
+			_exit(255);
+		ret = preserve_path(session_fd, path, O_RDONLY, token);
+		_exit(ret > 0 ? 255 : -ret);
+	}
+
+	if (waitpid(pid, &status, 0) != pid || !WIFEXITED(status) ||
+	    WEXITSTATUS(status) == 255)
+		return 1;
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
+	EXPECT_LT(preserve_path(self->session_fd, "file", O_WRONLY, 1), 0);
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
+	EXPECT_LT(preserve_as_nobody(self->session_fd, "file", 1), 0);
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
+	EXPECT_LT(preserve_path(self->session_fd, "file", O_RDONLY, 1), 0);
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
+	EXPECT_LT(preserve_as_nobody(self->session_fd, "other", 2), 0);
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
+	EXPECT_LT(preserve_as_nobody(self->session_fd, "other", 2), 0);
+}
+
+/*
+ * Test Case: Operations on a Preserved File
+ *
+ * While a file is preserved, operations that would change its size or punch
+ * holes into it fail with -EPERM. Reads and writes within the file still work.
+ * Closing the session unpreserves the file, after which its size can change
+ * again.
+ */
+TEST_F(preserve_tmpfs, preserved_ops)
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
2.56.1.809.ga0b61035b5-goog


