Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A25607990F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7Ox97aH
Received: by kanga.kvack.org (Postfix)
	id 54F9A6B05CA; Mon,  2 Nov 2026 10:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFEF6B0601; Mon,  2 Nov 2026 10:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF006B0602; Mon,  2 Nov 2026 10:14:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13A3A6B05CA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:14:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A08CBA0168
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:14:00 +0000 (UTC)
X-FDA: 85390524240.18.9BBB946
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C08E78000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:13:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7Ox97aH;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632439;
	b=7MugmN5ZFvUviUGwU1dE1OCGNW3u1RRzS63ZWRfIOAqGqKUrFQSwHCwJDo5Z7Ky/Kvpn9S
	A+rxTyByUurxV268GrPxkfB6AkcgRo187Mu7piBA2F5IhUZpmn/9gbicnsD/MoNOX5vjLC
	9YkwXyf27w3QHfXMoMs+SPelknfAbH0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7Ox97aH;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+W+g44aCaL43FGK45odLf2WH3NZSIh4HEIsQNMUIAQ=;
	b=ZWijxukUiJlO8TtPB9MZu0D/OTACsqJSMmq9b0UnM78Vq6clbq90d18Rt/YuN12PvjnEAa
	XNjlUXgRakXNGvkBvd7MeKPPgRfNcqtKuHrAsavkESpn5CX2SJ0I4Q2IuvIkx2U38dQwTb
	vnIdFfKr6W/KweJGtmPlEIo+5hd1acQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C3E343CEA;
	Mon,  2 Nov 2026 15:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A051F00A17;
	Mon,  2 Nov 2026 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632438;
	bh=S+W+g44aCaL43FGK45odLf2WH3NZSIh4HEIsQNMUIAQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F7Ox97aHb5v/69dEjCfSG3zYZyDUWGBbQmgwQbZqpHayfaTm2G57txgqdUeZo3I1H
	 tTuLLwDngX1C0kdrF8+z5iHcLOLMVPlNHU7Ek70BsEwCNAgxWcFwACFn8dRM9vXuNi
	 fR/HuBwWCNGkBIHly+3JqFmxpEpN+D+9f46wasKzYOnOtzNu5VuibzVNrASnI3ElKf
	 98h5jEevjX95199qLf7TWhYAItcY3sascPk/jhcInRBKh/iRe1KPIclCVzGPEmbyX3
	 JHM1Cp1LfYRKc0S2TNo/H269vvS4ZY0/H1hFOPI9a3WaLrf1PSJB04nf+i5VJqta6B
	 C97Z41nHrVXzg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:18 +0100
Subject: [PATCH RFC 11/23] selftests/proc: check that a faulting writer
 doesn't hold up removal
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-11-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7699; i=brauner@kernel.org;
 h=from:subject:message-id; bh=E/Aoc9uQW8LTsep+BLiQcemfYl1Vwa4LIRzF+EstznY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7Q9XihutiU620/TOp4nTfpGEvuYL3x8mh9fPS6m
 l0cd9YYdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykYy0jw80klv9bnE6761yY
 H2ijFaLOd2/76W8uCq84DzG1i6+RmM7I0Gm2vy378801RpOnHzpQy/rRzmj9jUkqNSHZgglMcT1
 TWAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: C08E78000C
X-Stat-Signature: z1b6n937htkr3173j9r1bq3qcpr6emos
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632438-244683
X-HE-Meta: U2FsdGVkX191fcS5Zym/1dgtCHtCODiTYeVgVZwCWF0qgJZPiklrpid7xtgnwTuzesTiAvQGkVrUbol7IiPbuosnuS5CCfrDIjtaXTw7yq48EvhLz9a6KDso5YiifPio1vhWYSn55KfClF82P0HrqSb0utmkZGaolHeahdjig4Ia4/yClLLwh6Dv2Hs3dJ9xVMPxwMx6uO6sKwkwxdnqy6w0klT/H2sf5k0UtEwNJvJZtOHnJ7UWKy9JOecKBGkeavLzQwVEZgcgb4DKHxLYPY4wpgBMYQ0w3mEffHvdf0a47XuVylgFAkNfgFtgrAb+42rXF6LUiutJBqoVCIPm2GRHORorFUXVCkixiaIfZoi/txJ0hjKrr28maY8SRlGoTGXxTg4N+tZOYrLEXivYj5DkCZJYsagxwkUUkkcSO2yGi7Bigqf/KVCZTYGy2Wcft1wngsLUH4/5ZCKqAEs5M4eTytvPBNmXCsJrnWUO63nmByf4I0+jJK+iO5BStmqOZaJWQnHKSzgcE19GvvrLcwwAFIXn/aH3jdVOZznliCGX0GJ4JQ4pXYpv/SGShUdLjsFl0ykwTz0kiplss0rWY9WzuxSTeN7Hq4+/lRN1/ycYA7NAbfFpLlNf72lL8YbOSOmTYGEaeFrQsGAA8beN078X/1LynMVoQj5pN4+5zMbYO3sJm9ffZDv0v4dAgtSGSaOFF2KYyxSgSaxCvMuBdcW1g2+K/xz4Di/ddYtzQqxlfUQGbIwkXONcXRZobevxv+j7DdC9ZKUJHbKn9+NwQxeeQIrxpNligolYvSpYbbL4LQCyok0l9cXBKYQZTo5LPTM4slHfJGPDbUyAKV18svLP0+JqXd0yP9g41IzC3T3INpBXA/Z7hB38Db9z2PZbjMIrfTeoPOAK4sM1+sWcINXwN7f7a2DuOYF9KHki5n5LuB4JsBKrFQVyt3W9ldKVbw7UeBKVmtWBwUcbLUB
 BZe0YvMk
 sIobdCLXnCgkTyZixp6GySv/oNtgMXUOJRQxk2v8w0NQW8er0rOLAzJ7i+VeXKpCbZRCtsqcxq+rXPF0tkxDl6ok+JYajVqdd/Zfx2vDd1v1xHAs+yPBY4dD4AZNrOCljOZ22VkfRajmMWNE+jZyM64gveQz3ymCH5mAw1KSYB4P9ZATVv1OFCmjp4Tgfr4mCPs/izc+cV+jIvUxRmKnB3y4GzwtpRGvXmAdTAJNSit9s2WldcgS6LdnDvLoAmCLp3h8twgT9MdqwKxph/mFnfFkkuiEI7+B8QtG6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Write to /proc/scsi/scsi_debug/<host> from a buffer whose page is backed
by userfaultfd and remove the host while procfs copies in what is
written:

- removing the entry doesn't wait for the writer

- the write fails with -EIO once the fault is resolved

The test loads scsi_debug if it isn't there and skips without it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 tools/testing/selftests/proc/config                |   3 +
 .../selftests/proc/proc-remove-slow-writer.c       | 203 +++++++++++++++++++++
 4 files changed, 208 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index e2566cc0ae07..51969f81afc5 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -24,6 +24,7 @@
 /proc-remove-slow-sysctl
 /proc-remove-slow-reader
 /proc-remove-slow-readlink
+/proc-remove-slow-writer
 /read
 /self
 /setns-dcache
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index 6a9bdc999f54..aecec6b93173 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -35,5 +35,6 @@ TEST_GEN_PROGS += proc-pidns
 TEST_GEN_PROGS += proc-remove-slow-sysctl
 TEST_GEN_PROGS += proc-remove-slow-reader
 TEST_GEN_PROGS += proc-remove-slow-readlink
+TEST_GEN_PROGS += proc-remove-slow-writer
 
 include ../lib.mk
diff --git a/tools/testing/selftests/proc/config b/tools/testing/selftests/proc/config
index 7b0e1d9be1a2..c7c61a2d7927 100644
--- a/tools/testing/selftests/proc/config
+++ b/tools/testing/selftests/proc/config
@@ -5,3 +5,6 @@ CONFIG_USERFAULTFD=y
 CONFIG_SOUND=y
 CONFIG_SND=y
 CONFIG_SND_DUMMY=m
+CONFIG_SCSI=y
+CONFIG_SCSI_PROC_FS=y
+CONFIG_SCSI_DEBUG=m
diff --git a/tools/testing/selftests/proc/proc-remove-slow-writer.c b/tools/testing/selftests/proc/proc-remove-slow-writer.c
new file mode 100644
index 000000000000..f69ca75ba87c
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-remove-slow-writer.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A write that faults while procfs copies it in must not hold up removal of
+ * the /proc entry. Removing a scsi_debug host removes its
+ * /proc/scsi/scsi_debug/<host> file.
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
+#define ADD_HOST	"/sys/bus/pseudo/drivers/scsi_debug/add_host"
+#define HOST_DIR	"/proc/scsi/scsi_debug"
+#define TIMEOUT_MS	5000
+#define MAX_HOSTS	4096
+#define HOST_BITS	(8 * sizeof(unsigned long))
+
+struct writer {
+	int fd;
+	char *buf;
+	ssize_t ret;
+	int err;
+};
+
+struct remover {
+	int done;
+	int ret;
+};
+
+/* a positive @nr adds hosts, a negative one removes the last ones added */
+static int add_host(int nr)
+{
+	char s[16];
+	int fd, len, ret;
+
+	fd = open(ADD_HOST, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	len = snprintf(s, sizeof(s), "%d", nr);
+	ret = write(fd, s, len) == len ? 0 : -errno;
+	close(fd);
+	return ret;
+}
+
+/* the numbers of the hosts in /proc/scsi/scsi_debug as a bitmap */
+static int list_hosts(unsigned long *hosts)
+{
+	struct dirent *d;
+	DIR *dir;
+
+	memset(hosts, 0, MAX_HOSTS / 8);
+	dir = opendir(HOST_DIR);
+	if (!dir)
+		/* the directory comes with the first host and goes with the last */
+		return errno == ENOENT ? 0 : -errno;
+	while ((d = readdir(dir))) {
+		char *end;
+		long nr = strtol(d->d_name, &end, 10);
+
+		if (end != d->d_name && !*end && nr >= 0 && nr < MAX_HOSTS)
+			hosts[nr / HOST_BITS] |= 1UL << (nr % HOST_BITS);
+	}
+	closedir(dir);
+	return 0;
+}
+
+/* the host that is in @after but wasn't in @before */
+static int new_host(const unsigned long *before, const unsigned long *after)
+{
+	for (int i = 0; i < MAX_HOSTS / HOST_BITS; i++) {
+		unsigned long new = after[i] & ~before[i];
+
+		if (new)
+			return i * HOST_BITS + __builtin_ctzl(new);
+	}
+	return -1;
+}
+
+static void *write_thread(void *arg)
+{
+	struct writer *w = arg;
+
+	w->ret = write(w->fd, w->buf, 2);
+	w->err = errno;
+	return NULL;
+}
+
+static void *remove_thread(void *arg)
+{
+	struct remover *r = arg;
+	ssize_t ret;
+
+	r->ret = add_host(-1);
+	ret = write(r->done, "x", 1);
+	return (void *)ret;
+}
+
+FIXTURE(host) {
+	char path[PATH_MAX];
+	int host;
+};
+
+FIXTURE_SETUP(host)
+{
+	unsigned long before[MAX_HOSTS / HOST_BITS];
+	unsigned long after[MAX_HOSTS / HOST_BITS];
+
+	self->host = -1;
+	if (access(ADD_HOST, W_OK) && system("modprobe -q scsi_debug add_host=0"))
+		SKIP(return, "no scsi_debug");
+	if (access(ADD_HOST, W_OK))
+		SKIP(return, ADD_HOST ": %s", strerror(errno));
+
+	/* host numbers are reused, so look for the one that's new */
+	ASSERT_EQ(list_hosts(before), 0);
+	ASSERT_EQ(add_host(1), 0);
+	ASSERT_EQ(list_hosts(after), 0);
+	self->host = new_host(before, after);
+	ASSERT_GE(self->host, 0);
+	snprintf(self->path, sizeof(self->path), HOST_DIR "/%d", self->host);
+}
+
+FIXTURE_TEARDOWN(host)
+{
+	if (self->host >= 0 && !access(self->path, F_OK))
+		add_host(-1);
+}
+
+TEST_F(host, remove_while_writer_faults)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = {};
+	struct uffdio_zeropage zero = {};
+	long psz = sysconf(_SC_PAGESIZE);
+	struct writer w = {};
+	struct remover r = {};
+	struct uffd_msg msg;
+	struct pollfd pfd;
+	pthread_t wt, rt;
+	int uffd, done[2];
+	char *buf;
+
+	w.fd = open(self->path, O_WRONLY | O_CLOEXEC);
+	if (w.fd < 0)
+		SKIP(return, "%s: %s", self->path, strerror(errno));
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
+	w.buf = buf;
+	ASSERT_EQ(pthread_create(&wt, NULL, write_thread, &w), 0);
+
+	/* The writer now sleeps while what it writes is copied in. */
+	pfd = (struct pollfd){ .fd = uffd, .events = POLLIN };
+	ASSERT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1);
+	ASSERT_EQ(read(uffd, &msg, sizeof(msg)), sizeof(msg));
+	ASSERT_EQ(msg.event, UFFD_EVENT_PAGEFAULT);
+
+	/* Removing the host removes the file that is being written. */
+	ASSERT_EQ(pipe2(done, O_CLOEXEC), 0);
+	r.done = done[1];
+	ASSERT_EQ(pthread_create(&rt, NULL, remove_thread, &r), 0);
+	pfd = (struct pollfd){ .fd = done[0], .events = POLLIN };
+	EXPECT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1) {
+		TH_LOG("removing %s waited for the writer", self->path);
+	}
+
+	zero.range.start = (unsigned long)buf;
+	zero.range.len = psz;
+	ASSERT_EQ(ioctl(uffd, UFFDIO_ZEROPAGE, &zero), 0);
+	ASSERT_EQ(pthread_join(wt, NULL), 0);
+	ASSERT_EQ(pthread_join(rt, NULL), 0);
+	EXPECT_EQ(r.ret, 0);
+
+	/* The entry was gone by the time the write got to it. */
+	EXPECT_EQ(w.ret, -1);
+	EXPECT_EQ(w.err, EIO);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


