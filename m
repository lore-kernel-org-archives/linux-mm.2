Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C15C6070CAE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZfP/Kahw
Received: by kanga.kvack.org (Postfix)
	id 740F56B05BD; Mon,  2 Nov 2026 09:47:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718AB6B05BE; Mon,  2 Nov 2026 09:47:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607BA6B05BF; Mon,  2 Nov 2026 09:47:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37CE96B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:47:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC30C140136
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:47:15 +0000 (UTC)
X-FDA: 85390456830.16.C4F1AB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 08E8C1C0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:47:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZfP/Kahw";
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVagn+HE6BgGgxgbr+5XC5Y5Qcbb33m4Jb7EnpZPFUg=;
	b=YVykqsrYKjqrFCTIlpevc0hd/m4aTz06YkRIIul/hdcsgWj6RxuQM6doOzhEJyJfcaBiSf
	YCRrOk912dfV6AIGb2cLQb8GKACxML79JJ4LL0VLW8fNb9CylIMVSYf6nLydOCUbzcYANQ
	bqEJNmsj2w8Ih9mo7bS8rNEa/EhxIME=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZfP/Kahw";
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630834;
	b=udY8PKcy5cKxIVRrc+OVT7biUPoHfKh+IgzyFeTr05RZJuQ3lxz8ebulSsNn4FxUCfZHMX
	zO1S9wxg3EYOs1mDMQQ4JLqhiTsjDR3XJcoHlC35EIW9Fn9nL2MQF9l2aOlArDXbITVOey
	lbcqrbXH5he6wkBR2QDJUfr27e7Vzy4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B079404CE;
	Mon,  2 Nov 2026 14:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EE81F00A1A;
	Mon,  2 Nov 2026 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630833;
	bh=HVagn+HE6BgGgxgbr+5XC5Y5Qcbb33m4Jb7EnpZPFUg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZfP/KahwDm10wm2TSGrtLVkg7xDUNnpz+rBBaInyM45cZNagos2iYqnrDed5HxIBA
	 K+//mFWxDsWpOWe9Buj12+quSzkpcQzj2ngYZ9ZsEW0oSIiCRi7l1s6PLMfANxGQPz
	 ES6j9Tp68ZCoex9QLLCdMUr2RP+/gA7nMafoF8zKWkoSoj6HU61hIGfIek8HtzVsMz
	 WP7zxeoWb2ywthOOE6hEK8rHNlm6c5T599z/Oyvz7z8nNJFpq2Xxjua62S/Ez/3caV
	 aKvdxGOQzTpkPCeB1AmIzk8MgvSvtRVAT8gs8GThhJQslYhMWBFvphDQuEoGKj/fJB
	 b5NG8uh8YTrhw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:43:29 +0100
Subject: [PATCH RFC 38/38] selftests/proc: check that a faulting readlink()
 doesn't hold up removal
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-38-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 08E8C1C0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jyouxpwp8fg7x9ezr3cdxf6u5mojmccf
X-HE-Tag: 1793630833-607291
X-HE-Meta: U2FsdGVkX18xA4f8ter1Sb1PwM9SnG0CD/ZTnPKbOJUUsLgRqUUOOujLqj4KTeRWHiu0vBHh658fVBsBi1GWgxxH7p6cVYGvnEwW62OtvCjc8klc02TB05wFHq/re7yBKveLZYAeqcTfkAtIxMGRS0jfaKr3Ls6CGvHJTgq2qak2PEevAXjzUevo4GpOxxHvSV6jg99+dokgSaN/Qtl5/DaT5tNzzDDxYGeGDeyuYw9yXUyv9voemZZQD1YgttnptIyp3nKQWn5J8BMmDxnevS/YK28vd00hUq/Uk9+q8rXKO7rWyi1HKI/N4mrHaOiDSrFnvyZBJfwoSRsFIbdFhS3d3KeAdLO3LEjXuT8Twn9Nsa1GztYakeeynr7eI7AXLvXQU9EsOlZwIL0kZFtDwRVs0HIeD64VFXqX750IWG+n0xrT4qUyuCfitW0CcKncNnNFuhqukNx6Kb0VgXCKqR+lnbthRegpKf6rqr6Q08LiHJ9oawsa8Q0GDVbD9rT+LBQrD8m4lSH+wlIWH2whTDvtP/uc0m27jRBCbWxnyqj8Gx2Wgu+sAvXd0O65pherXABGzghHvyXM6iEl8DvLsiQKlX5yB1htJL6sKAY0zkzeXavJpYkPBCYhCHVXRTNnucbeORVD4xf1fn/joVrCMRW3/mSdS6pVoLTQzjVgV9uAsrk2rDEDFuP+UrP4nbJnO7EKNcdmeFQ190dMKdHadwNHek89Pew/0qqq+JCgxGu5jSsISv8XL2VJC6oSn6Dr13d5263rQKM0mkKZdgLx7zo+bSGoTrD4ezeKu8zTenkukbn2qUNi9OEJHMUKNjjqBc6cXuIKfiO6S8VaJmuuSKNj2E0ADAPpZWRinQvj7J2awlO6MSGgz7rxrhkjmllZliuFhhgyDPu/x/q8x0uK1NmtmefCRttMVL7XJpe9vlholflpCtJnJ1hJDDOwVnfAY6CcH74GypQHQuX3/6r
 4f9qqamR
 PzPWjdQ9+K4kf69bBROTI+VmmgEybLzCfvMgIzceUbwCDUuQUWMZ7gj3ELWKLUw+dpbHa1YDqrOWXp9OAjg1dYIb+N1f0DwyVNNGN/xyB7xORsL6uAaEGqOEVPGkVBsRHyCkcP4wPgDl9sM8jlzEwmZ9bTSIGbKDNHyMaQkMN+RINS5GLmx0ttcud9WfLjRWc+aUwWqkEpvIu/B1FzELA7WSmfFcRI7eJLA1WTZswbpoHuygZiNh3rLyb6ccjwbcwhc0pTnCaCVKdRNFX7odTgzwUsAfRXt/+KVXQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the symlink case:

- readlink() /proc/asound/<id> of a dummy card into a buffer backed by
  userfaultfd

- change the card's id through sysfs while the reader faults, which
  removes the symlink with snd_card_mutex and info_mutex held

- expect that to finish without waiting for the reader

Skipped without snd-dummy.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/proc/.gitignore            |   2 +
 tools/testing/selftests/proc/Makefile              |   2 +
 tools/testing/selftests/proc/config                |   3 +
 .../selftests/proc/proc-remove-slow-readlink.c     | 191 +++++++++++++++++++++
 4 files changed, 198 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index 7b8133492782..e2566cc0ae07 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -22,6 +22,8 @@
 /proc-uptime-002
 /proc-pidns
 /proc-remove-slow-sysctl
+/proc-remove-slow-reader
+/proc-remove-slow-readlink
 /read
 /self
 /setns-dcache
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index bce6beca7274..6a9bdc999f54 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -33,5 +33,7 @@ TEST_GEN_PROGS += proc-fsconfig-hidepid
 TEST_GEN_PROGS += proc-sysctl-readdir-churn
 TEST_GEN_PROGS += proc-pidns
 TEST_GEN_PROGS += proc-remove-slow-sysctl
+TEST_GEN_PROGS += proc-remove-slow-reader
+TEST_GEN_PROGS += proc-remove-slow-readlink
 
 include ../lib.mk
diff --git a/tools/testing/selftests/proc/config b/tools/testing/selftests/proc/config
index 3edd3c437fe4..7b0e1d9be1a2 100644
--- a/tools/testing/selftests/proc/config
+++ b/tools/testing/selftests/proc/config
@@ -2,3 +2,6 @@ CONFIG_PROC_FS=y
 CONFIG_IPV6=y
 CONFIG_TUN=y
 CONFIG_USERFAULTFD=y
+CONFIG_SOUND=y
+CONFIG_SND=y
+CONFIG_SND_DUMMY=m
diff --git a/tools/testing/selftests/proc/proc-remove-slow-readlink.c b/tools/testing/selftests/proc/proc-remove-slow-readlink.c
new file mode 100644
index 000000000000..3290225daecd
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-remove-slow-readlink.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A readlink() that faults while copying out the link must not hold up
+ * removal of the /proc symlink. Changing a sound card's id removes
+ * /proc/asound/<id> with snd_card_mutex and info_mutex held.
+ */
+#define _GNU_SOURCE
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#define CARD_ID		"Dummy"
+#define NEW_ID		"procslow"
+#define LINK_PATH	"/proc/asound/" CARD_ID
+#define TIMEOUT_MS	5000
+
+struct reader {
+	char *buf;
+	size_t len;
+	ssize_t ret;
+};
+
+struct renamer {
+	const char *id_path;
+	const char *id;
+	int done;
+	int ret;
+};
+
+static void *readlink_thread(void *arg)
+{
+	struct reader *r = arg;
+
+	r->ret = readlink(LINK_PATH, r->buf, r->len);
+	return NULL;
+}
+
+/* a new id removes the card's old /proc/asound/<id> link */
+static int set_id(const char *id_path, const char *id)
+{
+	int fd, ret;
+
+	fd = open(id_path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	ret = write(fd, id, strlen(id)) < 0 ? -errno : 0;
+	close(fd);
+	return ret;
+}
+
+static void *rename_thread(void *arg)
+{
+	struct renamer *r = arg;
+	ssize_t ret;
+
+	r->ret = set_id(r->id_path, r->id);
+	ret = write(r->done, "x", 1);
+	return (void *)ret;
+}
+
+/* the sysfs id file of the card with @id */
+static int find_card(const char *id, char *id_path, size_t size)
+{
+	struct dirent *d;
+	int ret = -1;
+	DIR *dir;
+
+	dir = opendir("/sys/class/sound");
+	if (!dir)
+		return -1;
+	while (ret && (d = readdir(dir))) {
+		char cur[32];
+		FILE *f;
+
+		if (strncmp(d->d_name, "card", 4))
+			continue;
+		snprintf(id_path, size, "/sys/class/sound/%s/id", d->d_name);
+		f = fopen(id_path, "r");
+		if (!f)
+			continue;
+		if (fgets(cur, sizeof(cur), f)) {
+			cur[strcspn(cur, "\n")] = '\0';
+			if (!strcmp(cur, id))
+				ret = 0;
+		}
+		fclose(f);
+	}
+	closedir(dir);
+	return ret;
+}
+
+FIXTURE(dummy) {
+	char id_path[PATH_MAX];
+	bool renamed;
+};
+
+FIXTURE_SETUP(dummy)
+{
+	self->renamed = false;
+	if (access(LINK_PATH, F_OK) && system("modprobe -q snd-dummy"))
+		SKIP(return, "no snd-dummy");
+	if (access(LINK_PATH, F_OK))
+		SKIP(return, LINK_PATH ": %s", strerror(errno));
+	if (find_card(CARD_ID, self->id_path, sizeof(self->id_path)))
+		SKIP(return, "no sysfs id file for " CARD_ID);
+	if (access(self->id_path, W_OK))
+		SKIP(return, "%s: %s", self->id_path, strerror(errno));
+}
+
+FIXTURE_TEARDOWN(dummy)
+{
+	if (self->renamed && set_id(self->id_path, CARD_ID))
+		TH_LOG("couldn't name the card " CARD_ID " again");
+}
+
+TEST_F(dummy, remove_while_readlink_faults)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = {};
+	struct uffdio_zeropage zero = {};
+	long psz = sysconf(_SC_PAGESIZE);
+	struct renamer rn = {};
+	struct reader r = {};
+	struct uffd_msg msg;
+	struct pollfd pfd;
+	pthread_t rt, nt;
+	int uffd, done[2];
+	char *buf;
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0)
+		SKIP(return, "userfaultfd: %s", strerror(errno));
+	ASSERT_EQ(ioctl(uffd, UFFDIO_API, &api), 0);
+
+	buf = mmap(NULL, psz, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(buf, MAP_FAILED);
+	reg.range.start = (unsigned long)buf;
+	reg.range.len = psz;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	ASSERT_EQ(ioctl(uffd, UFFDIO_REGISTER, &reg), 0);
+
+	r.buf = buf;
+	r.len = psz;
+	ASSERT_EQ(pthread_create(&rt, NULL, readlink_thread, &r), 0);
+
+	/* The reader now sleeps in the copy of the link to userspace. */
+	pfd = (struct pollfd){ .fd = uffd, .events = POLLIN };
+	ASSERT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1);
+	ASSERT_EQ(read(uffd, &msg, sizeof(msg)), sizeof(msg));
+	ASSERT_EQ(msg.event, UFFD_EVENT_PAGEFAULT);
+
+	/* Renaming the card removes the link that is being read. */
+	ASSERT_EQ(pipe2(done, O_CLOEXEC), 0);
+	rn.id_path = self->id_path;
+	rn.id = NEW_ID;
+	rn.done = done[1];
+	self->renamed = true;
+	ASSERT_EQ(pthread_create(&nt, NULL, rename_thread, &rn), 0);
+	pfd = (struct pollfd){ .fd = done[0], .events = POLLIN };
+	EXPECT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1) {
+		TH_LOG("removing " LINK_PATH " waited for the reader");
+	}
+
+	zero.range.start = (unsigned long)buf;
+	zero.range.len = psz;
+	ASSERT_EQ(ioctl(uffd, UFFDIO_ZEROPAGE, &zero), 0);
+	ASSERT_EQ(pthread_join(rt, NULL), 0);
+	ASSERT_EQ(pthread_join(nt, NULL), 0);
+	EXPECT_EQ(rn.ret, 0);
+
+	/* The link was read before it went away. */
+	EXPECT_GT(r.ret, 0);
+	EXPECT_EQ(readlink(LINK_PATH, buf, psz), -1);
+	EXPECT_EQ(errno, ENOENT);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


