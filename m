Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CC76072660
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fINV72S8
Received: by kanga.kvack.org (Postfix)
	id 2A8B76B05BD; Wed,  4 Nov 2026 16:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FD26B05BE; Wed,  4 Nov 2026 16:14:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F726B05BF; Wed,  4 Nov 2026 16:14:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E09A36B05BD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:14:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A50580820
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:37 +0000 (UTC)
X-FDA: 85398690594.22.906E749
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 661DAC0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fINV72S8;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4hWAYy+9h5Ws1+QsnOeSYUee4W4bqw00qwXFyYDM2Q=;
	b=eYr3PHQ0l2aF3QVvzGuMFh6/CsLpHFGDUOk8SPII+eKxawzF/tGQT8WV9h8Zipsb96ZQfR
	QaHxc92hEE232o4hb2MW8WfQRfccftNSofXevKLhEuf0I1X/+A1YNZpdCONgSFTSuTSew+
	M4HaalDwCn1UNz6AVebTUBDoGP4B5Hk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826875;
	b=YNBTq17odS0UbzMi6QtsoRYSWp1Iaqrhx4eC6ehu6RFsDUN2fNh46lYcqH+pCDlMw6WIX7
	XNyQkJld4CQhAR2oYQ9VkRq7QcO0P7vQ56mYE6u7YBa8z9WR6aq76TiPLKN4CnD1x3mgNu
	CjU9P4hPAx0gJP1okdFY3u1jCWGVm/c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fINV72S8;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1BF243E67;
	Wed,  4 Nov 2026 21:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032A61F00A02;
	Wed,  4 Nov 2026 21:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826874;
	bh=e4hWAYy+9h5Ws1+QsnOeSYUee4W4bqw00qwXFyYDM2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fINV72S8bDDNAGDfuVdNkKEJ8IkqVCRv+9pBI3vQ5asq9IiLLozzE0QdmmFli8th5
	 X4s5LvAfCGJyYoNEE5Wh/0hw46DJ/gYX99FhVUKbbQ9fpJN7vbIOTm0BON4CFe267M
	 fjt8RFAd/brjcqiBtefp8sO8lO8+Jk10nEbQ6PlyE/7KlVHDLViBB+q3BjfLDENgvu
	 +cfDHNU9ti/Im92D+yfRD+3y/UeJe2pfCEzwWfnk7g5gX1KGx3F4JUPAldHuRmAzQX
	 R9u5jYwMUj2KA/fDxFq3B1ucLCU5hIL1w9JynYqO9s8HhX0xdmUp1Rax8ITizcXngq
	 K4fOq7xS0CHnQ==
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
Subject: [PATCH RESEND v2 13/13] selftests/proc: check that removing a polled entry wakes its pollers
Date: Wed,  4 Nov 2026 22:14:20 +0100
Message-ID: <20261104-work-procfs-net-v2-13-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7551; i=brauner@kernel.org; h=from:subject:message-id; bh=fkaoStBZv6n90Leh8+p5gt2ttSaWSW3wQWIJomPzMyw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97jO6eabzQ8af0CCncwxiapUmjm9LO9ZX+8151WM8/ 0fHlH+xHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMpiWJkWD31e+bEH6H98r+P hcf+KTFovSdbka6jnFTV2m3yOt4ygeGvZHu0Ve0uR+XXvqyXA8Nqj7+7aLx20bk/219c3a4dcte SEQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 661DAC0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: hzww8uy9icz8di9qrb4oe35irazmpq7f
X-Rspam-User: 
X-HE-Tag: 1793826875-709226
X-HE-Meta: U2FsdGVkX1+AvLtMTbYahUN3BbFZDQ/OTfjuzIM3oWL5WW0DIvggVwFWYuQCKVsOKXFuqXdZp0V+bF4nLAEyd1/OW55EqejP/QwHWADEMtvnhvphfJSBBfpGeH0pBu6+PzF42o4ITA+GPWL0WVYY7N7+/ViGGegczc5vwSjZ5bq1Y51R1lb7bVD3RKxHHKCQzO4nT2X6wjKylg1VxKahLAs/x3LZ9VFJ4xeWg2aoEB876xARKFaD6EEUT1x8rs5xp4NvOBFgGVF8LiV4nT3oSMepPZPjSmhNbGYCNxX6zusieCx5q1U6LIxTOGeyF+P5X//B27TxamMc9XLvHvyFp9ufrwNzvheOmMSnSWgxH6YUrg5GClyFz9X8hY2xbWVwqDTDU4YG+nxQItGa4UvnMyylOIjoVqyNaxwI8EKnkyoF9pzW2uU1qgSMqx4BNJVv1BQ6IUMzHe08BxiZCw/hRanLLuFZNB+AbRPHpv+XVcDJSOL0Hsk8zs7wvKReZJQ0jtHsrMnGZIkBiIT0K1OJjqrKe1yI3elU/i27qK87K2mDO4/dAQ6Onw10NfPrd6UEZ4H95oXjrtvh2akU1UUecjmFWC3ixHuRIW1gjrsFYVYuU4S0A5u8yvLPy4uPKvzVYXUlDHcaSYzKOxcP6geUjk9UhRKkjIDv1wt8vNFwNXUW8GkRmKWxPp20Xwtg9KmHlRrur8/M4IbXkkUK6C7q/pctNGnUS7dqRDr4eNnGdbIfcb6EBgouQ7Ija0MpnrMqr2dZ3XL0X9JMCN+6OdNMyaJNQ7AAziQeSV3f/gH/giHJBVI6zM/CwQVj77bfaK92JJIZwcLKgN5rqDE4oq5qRtZ2Jaq8O0fZMYYbESlZglZkJugtMCGo9ig6h+LfSsO+uCD+zTv+nk5l7bkMGGVmbFjSLZVZk9j0+/WB/nDeDafz2ea0FeBP3c+pkaHWOgoUYXxCUEnsP2/fBKIiR1+
 iO4A/qkd
 dlnGOavQKXwQZZ/wyRfA7BMnYM3l41HTo+w3tceN5VfWzbwhtMC/qhvxAWs93vMr2quJBlDi2IxeR0bk6iBRZtgSz3dQdT9M9pyPWrl1FQBgnxMpkF+QetA9hCccTrEAZCgOypp0d+4/Mcsh0seBv736ul7AfuDti2DEKNpBP8rwBG0loGbGJaLXrswoCfomt21Guv0HnwGr8vcXdsdSCirE2Em+h98DIVxRQsxtMAkl5mqpJESpiScJdnHMosr/M03n9o8mg8gaUvi+TfTf+/+2QPXekjRnmShhb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Poll the channel file of a sunrpc cache in /proc/net of a network
namespace of its own and let the namespace die while the poller sleeps:

- the poller wakes up and gets POLLERR | POLLPRI

- so does an epoll with an item on the entry

- a poll of the removed entry keeps reporting POLLERR, and a read of it
  fails with -EIO

The namespace is torn down from a workqueue, so a regression stalls the
test for ten seconds before it fails.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/proc/.gitignore           |   1 +
 tools/testing/selftests/proc/Makefile             |   1 +
 tools/testing/selftests/proc/config               |   2 +
 tools/testing/selftests/proc/proc-remove-polled.c | 189 ++++++++++++++++++++++
 4 files changed, 193 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index ed863db1688f..d06bb704d29d 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -31,5 +31,6 @@
 /self
 /setns-dcache
 /setns-sysvipc
+/proc-remove-polled
 /proc-sysctl-readdir-churn
 /thread-self
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index 95c9212fb670..e4f5142da47d 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -30,6 +30,7 @@ TEST_GEN_PROGS += setns-sysvipc
 TEST_GEN_PROGS += thread-self
 TEST_GEN_PROGS += proc-multiple-procfs
 TEST_GEN_PROGS += proc-fsconfig-hidepid
+TEST_GEN_PROGS += proc-remove-polled
 TEST_GEN_PROGS += proc-sysctl-readdir-churn
 TEST_GEN_PROGS += proc-pidns
 TEST_GEN_PROGS += proc-remove-slow-sysctl
diff --git a/tools/testing/selftests/proc/config b/tools/testing/selftests/proc/config
index 15b307189392..3cc12e91e5a7 100644
--- a/tools/testing/selftests/proc/config
+++ b/tools/testing/selftests/proc/config
@@ -6,6 +6,8 @@ CONFIG_NET_NS=y
 CONFIG_IPV6=y
 CONFIG_TUN=y
 CONFIG_USERFAULTFD=y
+CONFIG_USER_NS=y
+CONFIG_SUNRPC=y
 CONFIG_SOUND=y
 CONFIG_SND=y
 CONFIG_SND_DUMMY=m
diff --git a/tools/testing/selftests/proc/proc-remove-polled.c b/tools/testing/selftests/proc/proc-remove-polled.c
new file mode 100644
index 000000000000..e313d22be43f
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-remove-polled.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A poll() or epoll on a /proc entry must wake up when the entry is removed,
+ * and report the removed entry as an error. The channel file of a sunrpc
+ * cache lives in /proc/net of a network namespace and goes away with it.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/epoll.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#define CHANNEL_FMT	"/proc/%d/net/rpc/auth.unix.ip/channel"
+#define TIMEOUT_MS	10000
+
+struct netns_child {
+	pid_t pid;
+	int go;		/* closing it lets the child exit, and its netns die */
+};
+
+struct poller {
+	int fd;
+	int done;
+	int ret;
+	short revents;
+};
+
+static int write_file(const char *path, const char *fmt, ...)
+{
+	char buf[64];
+	va_list ap;
+	int fd, len, ret;
+
+	va_start(ap, fmt);
+	len = vsnprintf(buf, sizeof(buf), fmt, ap);
+	va_end(ap);
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	ret = write(fd, buf, len) == len ? 0 : -1;
+	close(fd);
+	return ret;
+}
+
+/*
+ * A child in a network namespace of its own, owned by a user namespace that
+ * maps us to root, so that we may open the files in its /proc/net. The child
+ * is the only thing that keeps the namespace alive.
+ */
+static int start_netns_child(struct netns_child *c)
+{
+	uid_t uid = getuid();
+	gid_t gid = getgid();
+	int ready[2], go[2];
+	char ch = 'f';
+
+	if (pipe2(ready, O_CLOEXEC) || pipe2(go, O_CLOEXEC))
+		return -1;
+	c->pid = fork();
+	if (c->pid < 0)
+		return -1;
+	if (c->pid == 0) {
+		close(ready[0]);
+		close(go[1]);
+		if (!unshare(CLONE_NEWUSER) &&
+		    !write_file("/proc/self/setgroups", "deny") &&
+		    !write_file("/proc/self/uid_map", "0 %d 1", uid) &&
+		    !write_file("/proc/self/gid_map", "0 %d 1", gid) &&
+		    !unshare(CLONE_NEWNET))
+			ch = 'r';
+		if (write(ready[1], &ch, 1) == 1 && ch == 'r')
+			(void)!read(go[0], &ch, 1);
+		_exit(0);
+	}
+	close(ready[1]);
+	close(go[0]);
+	c->go = go[1];
+	if (read(ready[0], &ch, 1) != 1 || ch != 'r') {
+		close(ready[0]);
+		close(c->go);
+		waitpid(c->pid, NULL, 0);
+		errno = EPERM;
+		return -1;
+	}
+	close(ready[0]);
+	return 0;
+}
+
+static void end_netns_child(struct netns_child *c)
+{
+	close(c->go);
+	waitpid(c->pid, NULL, 0);
+}
+
+static int open_channel(struct netns_child *c, char *path, size_t len)
+{
+	snprintf(path, len, CHANNEL_FMT, c->pid);
+	return open(path, O_RDONLY | O_CLOEXEC);
+}
+
+static void *poll_thread(void *arg)
+{
+	struct poller *p = arg;
+	struct pollfd pfd = { .fd = p->fd, .events = POLLPRI };
+	ssize_t ret;
+
+	p->ret = poll(&pfd, 1, TIMEOUT_MS);
+	p->revents = pfd.revents;
+	ret = write(p->done, "x", 1);
+	return (void *)ret;
+}
+
+TEST(poll_wakes_on_removal)
+{
+	struct netns_child c;
+	struct poller p = {};
+	struct pollfd pfd;
+	char path[64], buf[16];
+	pthread_t pt;
+	int done[2];
+
+	if (start_netns_child(&c))
+		SKIP(return, "network namespace: %s", strerror(errno));
+	p.fd = open_channel(&c, path, sizeof(path));
+	if (p.fd < 0)
+		SKIP(return, "%s: %s", path, strerror(errno));
+
+	/* A fresh channel has nothing to read and no error. */
+	pfd = (struct pollfd){ .fd = p.fd, .events = POLLIN | POLLPRI };
+	ASSERT_EQ(poll(&pfd, 1, 0), 0);
+
+	ASSERT_EQ(pipe2(done, O_CLOEXEC), 0);
+	p.done = done[1];
+	ASSERT_EQ(pthread_create(&pt, NULL, poll_thread, &p), 0);
+
+	/* The poller sleeps on the entry, now its namespace goes away. */
+	end_netns_child(&c);
+	pfd = (struct pollfd){ .fd = done[0], .events = POLLIN };
+	EXPECT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1) {
+		TH_LOG("removing %s didn't wake its poller", path);
+	}
+	ASSERT_EQ(pthread_join(pt, NULL), 0);
+	EXPECT_EQ(p.ret, 1);
+	EXPECT_EQ(p.revents & (POLLERR | POLLPRI), POLLERR | POLLPRI);
+
+	/* The removed entry stays an error, and there is nothing to read. */
+	pfd = (struct pollfd){ .fd = p.fd, .events = POLLIN };
+	EXPECT_EQ(poll(&pfd, 1, 0), 1);
+	EXPECT_TRUE(pfd.revents & POLLERR);
+	EXPECT_EQ(read(p.fd, buf, sizeof(buf)), -1);
+	EXPECT_EQ(errno, EIO);
+}
+
+TEST(epoll_wakes_on_removal)
+{
+	struct epoll_event ev = { .events = EPOLLPRI };
+	struct netns_child c;
+	char path[64];
+	int fd, epfd;
+
+	if (start_netns_child(&c))
+		SKIP(return, "network namespace: %s", strerror(errno));
+	fd = open_channel(&c, path, sizeof(path));
+	if (fd < 0)
+		SKIP(return, "%s: %s", path, strerror(errno));
+
+	epfd = epoll_create1(EPOLL_CLOEXEC);
+	ASSERT_GE(epfd, 0);
+	ASSERT_EQ(epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev), 0);
+	ASSERT_EQ(epoll_wait(epfd, &ev, 1, 0), 0);
+
+	/* The item sits on the entry's queue, now its namespace goes away. */
+	end_netns_child(&c);
+	EXPECT_EQ(epoll_wait(epfd, &ev, 1, TIMEOUT_MS), 1) {
+		TH_LOG("removing %s didn't wake epoll", path);
+	}
+	EXPECT_EQ(ev.events & (EPOLLERR | EPOLLPRI), EPOLLERR | EPOLLPRI);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


