Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D55606CFDB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z6GBQG3a
Received: by kanga.kvack.org (Postfix)
	id 1A1676B05B1; Wed,  4 Nov 2026 12:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152086B05D4; Wed,  4 Nov 2026 12:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CF56B05D6; Wed,  4 Nov 2026 12:54:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5D246B05D4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:54:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6271BC060D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:54:47 +0000 (UTC)
X-FDA: 85398187014.28.5C6B3DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 92D3B40002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:54:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z6GBQG3a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kkSM5euWaBmFK3xxQcLv4mgEkXFSNdIObYnznwfIo0=;
	b=st3yUxz5es+8/B+HZP46B7pQNCIcPTS1cUq3dIYJDa3lsLWB5zu3fWBhEhUPNHKogVKTeS
	QKzxIZ+Ba/o8yHHIjXsetw40trc+cU6hpaKQ7ie7hKdD9wld3dGcJuh6Y+PpG3t6Y0/JM1
	VbLU1oIhhzDXD2gFrcydZgBQ4PBmMZs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z6GBQG3a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814885;
	b=3lLBQcMgDJ/AZALcpmur/bXpBWLBoPWC231dzF0DT1TqH6q1Csub/OSFx7JumDhi16O0H0
	S5vWYGIpqtHzgoyOOV6m7sapxCcgK7ltL7dRYEaRiUs4iTwJt46CsY75kZdgRHxOv3hI05
	3wxtFgLIDg1ZT8d1TpzFWJs09F7jUYw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2432360D7E;
	Wed,  4 Nov 2026 17:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB5C1F000C1;
	Wed,  4 Nov 2026 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814884;
	bh=/kkSM5euWaBmFK3xxQcLv4mgEkXFSNdIObYnznwfIo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6GBQG3a+cE9+wQbayuod2AfwcA5eSI1rtdPAEkR6NsmPTw1AE/19Dxg/FB18Obf3
	 XeQ2JrZZMlq292+9ChK0bIQZeBI8yTk2Y7w0ArULtzz4HoZpwmfFIWQXX01jOs2qz2
	 dBa6XSwjjcSVxzrNHHQHUyzzPpTJ3n31iuGj1X6UVrBJaXhutOPCNLWDGPPyku7CsY
	 ADhF22IYElhWlzbCL+rEi0mABGy1i40iw8REYvQq+3G3YTtbJWrStHhaTNtT19/eg/
	 Y2DXQdQbQR0mASt8maUnvhPyhKOUgnLTqnfjby8Gs9PaSRK+KNbc19NmvAxKsJvlJb
	 jl2nFD68jaEVQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH v2 33/51] selftests/proc: check a /proc listing while entries come and go
Date: Wed,  4 Nov 2026 18:47:19 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-33-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=9018; i=brauner@kernel.org; h=from:subject:message-id; bh=NzSqjSqcJKKkJ7jf3TwnqEZW3Bg2Bj/+2ncCZpJHWz8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znteUPfza18Zl1H306y789/998maHMe98ybzTa/LZ e7/2D687ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIxzcM/10mHY251p3WcXHP U1lhYVf/x9a7/IWf3ja4HKfZt1bWr4Xhr8jHyDNC91+GvAzI2e9Wfnz9rU0/6kyfbWNMMrCbZuM aygkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92D3B40002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: c9fbjwzxtcnp4bq7fozok58kw9eqwxai
X-HE-Tag: 1793814885-142876
X-HE-Meta: U2FsdGVkX1/+UoO76k3IOXuOWlHz5b+D84pIKeNWBGljgxxj8k9+scJSHcYwaLTauUxyacTROAgDJTDJlfwZLkIyPp1GbFd2CNa/MINVZyVOd7TA/+w3wcDK0Gb2Uho9i8tImDSQ3iL4PpeDVh/3FwtjoopyJ0wUGx2bY14JaRGrgz/cm0PXjM46a4q1n9UdI7SYJ2IKwpzTuYHbo7RoBkUZJzc0N7MPvaEq7sQHeU6ZZVIy0i5hogWjYBI2PnG1+NvHW3CLdxNDrxV+Sw9yRz0alhRCLboR0BlEE9Adot1WmTJ2sQFIOJRyVzahayiB37lp3nskHz+9OG7iyqVU45bwVkdQGezjt1zhCM1p3y1fHQQP7thx9wmKv3wA2RTwmNHNijLijacb/Ma/qXYGvqKfeZ8rqrFTZ84W1wUJCGEq1SWO06/7UTpRZ9iE2P+ziy6bRtI63Zq/lvD5PQUfrmGbbjLJ37v6B0HWHpyWYbwHBB+2EXA9/MWSRIHP08qCqA7fD1p0RWkmcL6c3BJ05m1Q22jCZGv588DajPFneep9eCBqMP/p3oBCO7dcKfA1Jwu3a1t5+Y/bWWyGhIDJfMVMK0GBZ6b+oJ3b2qLyYi3aCv62qnFI8gVEoODo2JXUXJggbCza1XoBLz5cy4zMFTH3dgWl2QA5+zAmuNMz8jcOCrKzaD33moqk4MRI2UUiqz3CsHjciDDtHCdbOlFSAF3+eYTkd2jqmf1pFO31NYIIIXgqt1HuiV9QkDrKowq3Dic0cam9GVHIhX5WUOhnsuASejo3X/dVg4Qbn8JCKZ6RHDB7d3juiv5A8yNl+6Y2Nh1M4TKL0iKaih3uW6PImZCpYRWm8JLTjzk88iXsAvGp/3eqBn7QiENdgGY5lA0FdhTwQldRs6dnOVk4gBd7kQd429cg6i9WWFTCAsqaq5pSk30N/SJ78aRDdV7UmJ7e55GJSgqEqD6fcThOf4A
 SLgjSayC
 J6RGvvV/BTQ5NI1ccDviv6oBNwSDBF1xoOikdeS6ulnBRLUzhs2kAfgxoJjBH7E1Y+5xkDLDOiZjl6FoYkFtguQbSVnhlQ6Oos1J8hMYC2teUsKRUoSoUlNpZ2G7p3wQheqNrKcuOQc49DlqfDtFdQ4F1lUH2Ks3pr+jVd9oBOdXWPH/GeTDWQIQxzzXR/qxHe7rwxI+ieBL44xLqNa/zoFeARkgcSaeS7vszLeaXPFBhewiuRiYqij2bFOnTSZmVnZZnHZnxBK//TRbJml1rph+W+H2+zi3UfRAh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

List /proc/net/dev_snmp6 of a new network namespace while a tun device
comes and goes:

- with a buffer that holds the dots and "lo", add a device whose name
  sorts first, finish the listing: "lo" is listed once

- with that device added and a buffer that holds the dots and it,
  remove it, finish the listing: "lo" is still listed

- with that device added, stall getdents64() on a userfaultfd page
  while it writes the device's entry, remove the device, finish the
  listing: "lo" is still listed

All three fail without the fix, the first lists "lo" twice, the other
two not at all.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/proc/.gitignore           |   1 +
 tools/testing/selftests/proc/Makefile             |   1 +
 tools/testing/selftests/proc/config               |   4 +
 tools/testing/selftests/proc/proc-readdir-churn.c | 240 ++++++++++++++++++++++
 4 files changed, 246 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index 9c9735570abf..8520c7878ea2 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -8,6 +8,7 @@
 /proc-maps-race
 /proc-multiple-procfs
 /proc-net-dev-lseek
+/proc-readdir-churn
 /proc-empty-vm
 /proc-pid-vm
 /proc-self-map-files-001
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index a7de2bb6d8be..e0c0d313f4d0 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -11,6 +11,7 @@ TEST_GEN_PROGS += proc-2-is-kthread
 TEST_GEN_PROGS += proc-loadavg-001
 TEST_GEN_PROGS += proc-maps-race
 TEST_GEN_PROGS += proc-net-dev-lseek
+TEST_GEN_PROGS += proc-readdir-churn
 TEST_GEN_PROGS += proc-empty-vm
 TEST_GEN_PROGS += proc-pid-vm
 TEST_GEN_PROGS += proc-self-map-files-001
diff --git a/tools/testing/selftests/proc/config b/tools/testing/selftests/proc/config
index 68fbd2b35884..052e365af5a9 100644
--- a/tools/testing/selftests/proc/config
+++ b/tools/testing/selftests/proc/config
@@ -1 +1,5 @@
 CONFIG_PROC_FS=y
+CONFIG_NET_NS=y
+CONFIG_IPV6=y
+CONFIG_TUN=y
+CONFIG_USERFAULTFD=y
diff --git a/tools/testing/selftests/proc/proc-readdir-churn.c b/tools/testing/selftests/proc/proc-readdir-churn.c
new file mode 100644
index 000000000000..fd9b504b60f5
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-readdir-churn.c
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A listing of a /proc directory that takes more than one getdents64()
+ * must not show an entry twice or skip one when an entry is added or
+ * removed in between, and a listing must go on after an entry that is
+ * removed while it is being emitted. /proc/net/dev_snmp6/<dev> of a tun
+ * device comes and goes with the device.
+ */
+#define _GNU_SOURCE
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/if.h>
+#include <linux/if_tun.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
+#include <pthread.h>
+#include <sched.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#define SNMP6_DIR	"/proc/net/dev_snmp6"
+#define TUN_NAME	"a0"		/* sorts before "lo" */
+#define TUN_PATH	SNMP6_DIR "/" TUN_NAME
+#define SMALL_BUF	80		/* ".", ".." and one short name */
+#define NAMES		64
+
+static int tun_open(const char *name)
+{
+	struct ifreq ifr = {};
+	int fd;
+
+	fd = open("/dev/net/tun", O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	strncpy(ifr.ifr_name, name, IFNAMSIZ - 1);
+	ifr.ifr_flags = IFF_TUN | IFF_NO_PI;
+	if (ioctl(fd, TUNSETIFF, &ifr)) {
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
+/* one getdents64() into @buf, the names appended to @names */
+static int list(int fd, char *buf, size_t size, char names[][NAME_MAX + 1],
+		int *n)
+{
+	long ret, off;
+	int got = 0;
+
+	ret = syscall(__NR_getdents64, fd, buf, size);
+	if (ret < 0)
+		return -errno;
+	for (off = 0; off < ret;) {
+		struct dirent64 *d = (void *)(buf + off);
+
+		if (*n < NAMES)
+			strcpy(names[(*n)++], d->d_name);
+		got++;
+		off += d->d_reclen;
+	}
+	return got;
+}
+
+static int count(char names[][NAME_MAX + 1], int n, const char *name)
+{
+	int i, c = 0;
+
+	for (i = 0; i < n; i++)
+		if (!strcmp(names[i], name))
+			c++;
+	return c;
+}
+
+/* removes the device once getdents64() faults on its entry, then resolves */
+struct stall {
+	int uffd;
+	int tun;
+	unsigned long addr;
+	unsigned long len;
+	int removed;
+};
+
+static void *stall_resolve(void *arg)
+{
+	struct stall *s = arg;
+	struct pollfd pfd = { .fd = s->uffd, .events = POLLIN };
+	struct uffdio_zeropage zero = {
+		.range = { .start = s->addr, .len = s->len },
+	};
+	struct uffd_msg msg;
+
+	if (poll(&pfd, 1, 10000) != 1)
+		return NULL;
+	if (read(s->uffd, &msg, sizeof(msg)) != sizeof(msg) ||
+	    msg.event != UFFD_EVENT_PAGEFAULT)
+		return NULL;
+	close(s->tun);
+	s->removed = access(TUN_PATH, F_OK) == -1;
+	ioctl(s->uffd, UFFDIO_ZEROPAGE, &zero);
+	return NULL;
+}
+
+FIXTURE(proc_readdir) {
+	int dir;
+	int n;
+	char names[NAMES][NAME_MAX + 1];
+	char buf[65536];
+};
+
+FIXTURE_SETUP(proc_readdir)
+{
+	int tun;
+
+	if (unshare(CLONE_NEWNET))
+		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
+	tun = open("/dev/net/tun", O_RDWR | O_CLOEXEC);
+	if (tun < 0)
+		SKIP(return, "/dev/net/tun: %s", strerror(errno));
+	close(tun);
+	self->dir = open(SNMP6_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	if (self->dir < 0)
+		SKIP(return, SNMP6_DIR ": %s", strerror(errno));
+	self->n = 0;
+}
+
+FIXTURE_TEARDOWN(proc_readdir)
+{
+	close(self->dir);
+}
+
+/* a device added in front of the position doesn't repeat an entry */
+TEST_F(proc_readdir, add_in_front)
+{
+	int tun;
+
+	/* ".", ".." and "lo" */
+	ASSERT_EQ(list(self->dir, self->buf, SMALL_BUF, self->names, &self->n), 3);
+	ASSERT_EQ(count(self->names, self->n, "lo"), 1);
+
+	tun = tun_open(TUN_NAME);
+	ASSERT_GE(tun, 0);
+	ASSERT_EQ(access(TUN_PATH, F_OK), 0);
+
+	while (list(self->dir, self->buf, sizeof(self->buf), self->names,
+		    &self->n) > 0)
+		;
+	EXPECT_EQ(count(self->names, self->n, "lo"), 1);
+	close(tun);
+}
+
+/* a device removed in front of the position doesn't skip an entry */
+TEST_F(proc_readdir, remove_in_front)
+{
+	int tun;
+
+	tun = tun_open(TUN_NAME);
+	ASSERT_GE(tun, 0);
+	ASSERT_EQ(access(TUN_PATH, F_OK), 0);
+
+	/* ".", ".." and the device, "lo" doesn't fit */
+	ASSERT_EQ(list(self->dir, self->buf, SMALL_BUF, self->names, &self->n), 3);
+	ASSERT_EQ(count(self->names, self->n, TUN_NAME), 1);
+
+	/* closing the device unregisters it and removes its entry */
+	close(tun);
+	ASSERT_EQ(access(TUN_PATH, F_OK), -1);
+
+	while (list(self->dir, self->buf, sizeof(self->buf), self->names,
+		    &self->n) > 0)
+		;
+	EXPECT_EQ(count(self->names, self->n, "lo"), 1);
+}
+
+/* the entry being emitted is removed meanwhile, the listing goes on */
+TEST_F(proc_readdir, remove_current)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = {};
+	long page = sysconf(_SC_PAGESIZE);
+	struct stall s = {};
+	pthread_t thread;
+	char *map;
+	long ret, off;
+
+	s.uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (s.uffd < 0)
+		SKIP(return, "userfaultfd: %s", strerror(errno));
+	ASSERT_EQ(ioctl(s.uffd, UFFDIO_API, &api), 0);
+
+	/* the first page is there, the second one faults */
+	map = mmap(NULL, 2 * page, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(map, MAP_FAILED);
+	map[0] = 0;
+	s.addr = (unsigned long)map + page;
+	s.len = page;
+	reg.range.start = s.addr;
+	reg.range.len = s.len;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	ASSERT_EQ(ioctl(s.uffd, UFFDIO_REGISTER, &reg), 0);
+
+	s.tun = tun_open(TUN_NAME);
+	ASSERT_GE(s.tun, 0);
+	ASSERT_EQ(access(TUN_PATH, F_OK), 0);
+	ASSERT_EQ(pthread_create(&thread, NULL, stall_resolve, &s), 0);
+
+	/*
+	 * ".." ends right before the second page, so writing the record of
+	 * the device stalls until it has been removed.
+	 */
+	ret = syscall(__NR_getdents64, self->dir, map + page - 48, 48 + page);
+	ASSERT_EQ(pthread_join(thread, NULL), 0);
+	ASSERT_TRUE(s.removed);
+	ASSERT_GT(ret, 0);
+	for (off = 0; off < ret;) {
+		struct dirent64 *d = (void *)(map + page - 48 + off);
+
+		if (self->n < NAMES)
+			strcpy(self->names[self->n++], d->d_name);
+		off += d->d_reclen;
+	}
+	ASSERT_EQ(count(self->names, self->n, TUN_NAME), 1);
+
+	while (list(self->dir, self->buf, sizeof(self->buf), self->names,
+		    &self->n) > 0)
+		;
+	EXPECT_EQ(count(self->names, self->n, "lo"), 1);
+	munmap(map, 2 * page);
+	close(s.uffd);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


