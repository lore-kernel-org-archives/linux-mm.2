Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C79E606C543
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XWvDNXOE
Received: by kanga.kvack.org (Postfix)
	id 9B1706B05B2; Mon,  2 Nov 2026 09:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988646B05B3; Mon,  2 Nov 2026 09:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E3E6B05B4; Mon,  2 Nov 2026 09:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EAEF6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:46:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0B9D8014B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:34 +0000 (UTC)
X-FDA: 85390455108.23.F832BEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 33E4E20003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWvDNXOE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OUC3OpgPcYXff2v4b0WbdSVZE7XWpoJGNZRHA3e5A4=;
	b=IF/3Y2pc+09cm9lWv76xs7vAwz81VlcMvl5aiEXel58c7a4OMUO5yrDDrpgcaPflzk7UpP
	PDjMfRqSOCcGKC3Lu6OqhQyHOD2CUmWC3sH3+kdv1P0ZCOQCHwCfj+LcWeiWRmkvp83KSb
	OWCHFk3Sy/wk/U0OQCyDRpESY6VToK0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWvDNXOE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630793;
	b=xYXc4dnmEATgIhlKmldlCCcgoOGsRm76qZyUFD3HS0oZfQDWQThrd9rVfPSrxF8WXmM/TH
	wSG5eHR6ils98IPsA2cBCjUbhuAq/SlJNq/WP2Jb6C32o7txP/+tZoH0HEDT1YMVYaUDRB
	HV3UUY4M7WDyB3af006TT9NvHcp9t/0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5947B41AB5;
	Mon,  2 Nov 2026 14:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACC31F00A1C;
	Mon,  2 Nov 2026 14:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630792;
	bh=8OUC3OpgPcYXff2v4b0WbdSVZE7XWpoJGNZRHA3e5A4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XWvDNXOEbgzkyZSZLEEf/fLDGQTJKwF0ltSxY/EL3lo82Mkr/aDxZgyoDMPnEDdLr
	 5p9X0oQCHCkY63MlXypffIH/FgWzMKVYCEo4i3pEbfJuBXE7iGAORsSWwgE8jxQhAy
	 4NKKegcYQITsSSiB9ubx16WR7JIBFMAtYwmdkdE/Zzf6jzzLfZ7rDbpHNZ3omVKKWs
	 5YTo9uoKH3WQgJg5iglu6NkXshnM4oNeVvav8v5ihPYSLjDC/W/Dnb3rFkAiPkdkb/
	 knAVm1KzmCTPRmBb4tIwPxCsIua2TX2REoD5qySaeeWkURDqxkkuEp88D6dK5T0/43
	 GCmlt6X8Ltfhw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:43:27 +0100
Subject: [PATCH RFC 36/38] selftests/proc: check that faulting sysctl
 accesses don't hold up removal
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-36-59422ed3e465@kernel.org>
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
X-Rspamd-Queue-Id: 33E4E20003
X-Rspam-User: 
X-Stat-Signature: izhmtpm9dgkt63ots7sod7cmgawbyo1h
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793630794-384838
X-HE-Meta: U2FsdGVkX19nd5aFSlCt7LDyCtEQsz4pZy61GZdPSERghEP4QJdIH3WyoiIi6oOFvRyYkt3Cby5kY/tU9O5Lo1Yv4w/wYdwRz4vfgFYGrswn3ZN74ihnkGGegSep1mewg/A2x+QkLR/Cm59hOW5IlTtH9hw5luHdGfx/yT+fJFhI9sJm0B1ylAXR+eE+e+D1hiH/kgG4ZN821lHnHDuptz0fTIuFwMm1Bv6eU7Sx+3XGOgnlbKmwj6g+bUob+IvkR9zYfXrpdbNK0HuOJGCTzgr2OScVFtpWtyE4Zw33/J2xJPNV7fV9VdOEXMb/BTYgTKjPBlPMqCoQ0S+STVQOfFWTkZWPdm5e0F1c0/8K8ejcLjipu1iHv9PSPOqC/k0gGnqS98eOc3RNbX5/J/qUSdgwFvi8pOj1X69QtfPHnu7BS5CXNF60IZM62//Wc5zLDvSQJT1mjGQRfOxHlFnaJJW94hXV//W+R1OQ8U0//iXsnN2d1Jrw9h59hgGlmrQ7b90lVgVcihmtsuzm80yOr3aSxlffW3hsOL6xf+facgG+y09gGHtK6ISO6HS7DMW5OAKvLkkR8C10MOEGMbUYYVE74VnrxjHdo7bapuPCwRlAGC7025qd7EWWPsVCx6NzPURUWpe7WbpUWOHTT9BfeX78uSXbU0kf7KwgB3y9OWRfbPR3ne4tWBmlTBc/fmOLknxXOELAmfCjlS0NhMt2k8J7geGvx0AGI7+HObfwOnX8zaRCaCdVMfX4t7uFo1rtCS9Yl+lGHfTWT+OGatxC9EG/3UWcGkMOpFKK9NTIB7n92r/Pl56pvvKdu3dUOHJdm9NfW7/HmxWRN06IChmYd6K9GFVELHbG1hnfSYV9Sx1FfccbqCWEiA3fi+lUkBEemd384nWavcUtNnDP/DRlPHsPD/EzB9QujnwHySeNKG0zaPZOX1AGiA5/WN04S4SpzelW9eFJ+tZs+zdSCXF
 gYRanEwJ
 EfKRBaYp+xLgJKIUD0ViINYu3cTQ+Wr+HkvXVbedrfhmNuAZ4mTc9Hjc9t8/WxchFN+tAf1FUW8s6QPlsFuNbeySMtwZiB6wkCwh6rSGRUpkI2m2P32IQTlvmwxijy2yZzS74FfBCXKQyk6k47na2VMDz/wELslo6fSdmk/FgOrfRdUfuzlUtpq9dkxdRaxi8KEvDAjLB0FBRGolig1ZU3hbInEvac9zOS+u+vNxGhSNL4CGta6fAoCbox3X5srUzK5zVxogtVw3bjq4+mu3UkEbXBTlZHrl5Mk5s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Read, write and list /proc/sys/net/ipv6/conf/<dev>/ of a tun device
with a buffer whose first page is backed by userfaultfd and remove the
device while the task sleeps in its copy from or to userspace:

- unregistering the table doesn't wait for a faulting read(), write()
  or getdents64()

- the read still gets the value that was produced before the removal
  and the next read fails with -ENOENT

- the write is copied in after the removal and fails with -ENOENT

- getdents64() still lists what it looked up before the removal and
  fails with -ENOENT afterwards

The tables are unregistered under RTNL, so a regression stalls each
test for five seconds before it fails.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 tools/testing/selftests/proc/config                |   3 +
 .../selftests/proc/proc-remove-slow-sysctl.c       | 213 +++++++++++++++++++++
 4 files changed, 218 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index 5b5e24e39cbd..7b8133492782 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -21,6 +21,7 @@
 /proc-uptime-001
 /proc-uptime-002
 /proc-pidns
+/proc-remove-slow-sysctl
 /read
 /self
 /setns-dcache
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index dae09f333455..bce6beca7274 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -32,5 +32,6 @@ TEST_GEN_PROGS += proc-multiple-procfs
 TEST_GEN_PROGS += proc-fsconfig-hidepid
 TEST_GEN_PROGS += proc-sysctl-readdir-churn
 TEST_GEN_PROGS += proc-pidns
+TEST_GEN_PROGS += proc-remove-slow-sysctl
 
 include ../lib.mk
diff --git a/tools/testing/selftests/proc/config b/tools/testing/selftests/proc/config
index 68fbd2b35884..3edd3c437fe4 100644
--- a/tools/testing/selftests/proc/config
+++ b/tools/testing/selftests/proc/config
@@ -1 +1,4 @@
 CONFIG_PROC_FS=y
+CONFIG_IPV6=y
+CONFIG_TUN=y
+CONFIG_USERFAULTFD=y
diff --git a/tools/testing/selftests/proc/proc-remove-slow-sysctl.c b/tools/testing/selftests/proc/proc-remove-slow-sysctl.c
new file mode 100644
index 000000000000..e1b1fd19a07a
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-remove-slow-sysctl.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A read(), write() or getdents64() of /proc/sys that faults while copying
+ * from or to userspace must not hold up unregistering the sysctl table.
+ * /proc/sys/net/ipv6/conf/<dev>/ of a tun device is unregistered under RTNL
+ * when the device's file is closed.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
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
+#define TUN_NAME	"procslow0"
+#define CONF_PATH	"/proc/sys/net/ipv6/conf/" TUN_NAME
+#define MTU_PATH	CONF_PATH "/mtu"
+#define BUF_PAGES	16
+#define TIMEOUT_MS	5000
+
+enum sysctl_op {
+	SYSCTL_READ,
+	SYSCTL_WRITE,
+	SYSCTL_GETDENTS,
+};
+
+struct worker {
+	enum sysctl_op op;
+	int fd;
+	char *buf;
+	size_t len;
+	ssize_t ret;
+	int err;
+};
+
+struct closer {
+	int tun;
+	int done;
+};
+
+static void *work_thread(void *arg)
+{
+	struct worker *w = arg;
+
+	switch (w->op) {
+	case SYSCTL_READ:
+		w->ret = read(w->fd, w->buf, w->len);
+		break;
+	case SYSCTL_WRITE:
+		w->ret = write(w->fd, w->buf, w->len);
+		break;
+	case SYSCTL_GETDENTS:
+		w->ret = syscall(__NR_getdents64, w->fd, w->buf, w->len);
+		break;
+	}
+	w->err = errno;
+	return NULL;
+}
+
+static void *close_thread(void *arg)
+{
+	struct closer *c = arg;
+	ssize_t ret;
+
+	close(c->tun);
+	ret = write(c->done, "x", 1);
+	return (void *)ret;
+}
+
+FIXTURE(proc_sys_slow) {
+	int tun;
+	int uffd;
+	char *buf;
+	long psz;
+};
+
+FIXTURE_SETUP(proc_sys_slow)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = {};
+	struct ifreq ifr = {};
+
+	if (unshare(CLONE_NEWNET))
+		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
+
+	self->tun = open("/dev/net/tun", O_RDWR | O_CLOEXEC);
+	if (self->tun < 0)
+		SKIP(return, "/dev/net/tun: %s", strerror(errno));
+	strncpy(ifr.ifr_name, TUN_NAME, IFNAMSIZ - 1);
+	ifr.ifr_flags = IFF_TUN | IFF_NO_PI;
+	ASSERT_EQ(ioctl(self->tun, TUNSETIFF, &ifr), 0);
+	if (access(CONF_PATH, F_OK))
+		SKIP(return, CONF_PATH ": %s", strerror(errno));
+
+	self->uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (self->uffd < 0)
+		SKIP(return, "userfaultfd: %s", strerror(errno));
+	ASSERT_EQ(ioctl(self->uffd, UFFDIO_API, &api), 0);
+
+	/* Only the first page of the buffer goes through userfaultfd. */
+	self->psz = sysconf(_SC_PAGESIZE);
+	self->buf = mmap(NULL, BUF_PAGES * self->psz, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(self->buf, MAP_FAILED);
+	reg.range.start = (unsigned long)self->buf;
+	reg.range.len = self->psz;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	ASSERT_EQ(ioctl(self->uffd, UFFDIO_REGISTER, &reg), 0);
+}
+
+FIXTURE_TEARDOWN(proc_sys_slow)
+{
+}
+
+/*
+ * Let @w sleep in its copy from or to the first page of the buffer, then
+ * close the device. Unregistering the table must not wait for @w.
+ */
+static void stall_and_remove(struct __test_metadata *_metadata,
+			     FIXTURE_DATA(proc_sys_slow) *self,
+			     struct worker *w)
+{
+	struct closer c = { .tun = self->tun };
+	struct uffdio_zeropage zero = {};
+	struct uffd_msg msg;
+	struct pollfd pfd;
+	pthread_t wt, ct;
+	int done[2];
+
+	w->buf = self->buf;
+	ASSERT_EQ(pthread_create(&wt, NULL, work_thread, w), 0);
+
+	pfd = (struct pollfd){ .fd = self->uffd, .events = POLLIN };
+	ASSERT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1);
+	ASSERT_EQ(read(self->uffd, &msg, sizeof(msg)), sizeof(msg));
+	ASSERT_EQ(msg.event, UFFD_EVENT_PAGEFAULT);
+
+	ASSERT_EQ(pipe2(done, O_CLOEXEC), 0);
+	c.done = done[1];
+	ASSERT_EQ(pthread_create(&ct, NULL, close_thread, &c), 0);
+	pfd = (struct pollfd){ .fd = done[0], .events = POLLIN };
+	EXPECT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1) {
+		TH_LOG("unregistering " CONF_PATH " waited for the faulting task");
+	}
+
+	zero.range.start = (unsigned long)self->buf;
+	zero.range.len = self->psz;
+	ASSERT_EQ(ioctl(self->uffd, UFFDIO_ZEROPAGE, &zero), 0);
+	ASSERT_EQ(pthread_join(wt, NULL), 0);
+	ASSERT_EQ(pthread_join(ct, NULL), 0);
+}
+
+TEST_F(proc_sys_slow, read)
+{
+	struct worker w = {
+		.op	= SYSCTL_READ,
+		.len	= BUF_PAGES * self->psz,
+	};
+
+	w.fd = open(MTU_PATH, O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(w.fd, 0);
+	stall_and_remove(_metadata, self, &w);
+
+	/* The value was produced before the table went away, then nothing. */
+	EXPECT_GT(w.ret, 0);
+	EXPECT_EQ(read(w.fd, self->buf, self->psz), -1);
+	EXPECT_EQ(errno, ENOENT);
+}
+
+TEST_F(proc_sys_slow, write)
+{
+	struct worker w = {
+		.op	= SYSCTL_WRITE,
+		.len	= 5,
+	};
+
+	w.fd = open(MTU_PATH, O_WRONLY | O_CLOEXEC);
+	ASSERT_GE(w.fd, 0);
+	stall_and_remove(_metadata, self, &w);
+
+	/* The table went away while the value was copied in. */
+	EXPECT_EQ(w.ret, -1);
+	EXPECT_EQ(w.err, ENOENT);
+}
+
+TEST_F(proc_sys_slow, getdents)
+{
+	struct worker w = {
+		.op	= SYSCTL_GETDENTS,
+		.len	= BUF_PAGES * self->psz,
+	};
+
+	w.fd = open(CONF_PATH, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_GE(w.fd, 0);
+	stall_and_remove(_metadata, self, &w);
+
+	/* What was looked up before the removal still arrives, then nothing. */
+	EXPECT_GT(w.ret, 0);
+	EXPECT_EQ(syscall(__NR_getdents64, w.fd, self->buf, self->psz), -1);
+	EXPECT_EQ(errno, ENOENT);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


