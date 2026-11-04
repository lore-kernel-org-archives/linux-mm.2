Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E1B608B6F6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hg7TwfiA
Received: by kanga.kvack.org (Postfix)
	id 864B56B05DC; Wed,  4 Nov 2026 14:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815D56B05DF; Wed,  4 Nov 2026 14:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7041E6B05E0; Wed,  4 Nov 2026 14:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43C336B05DC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:45:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A7A9C086A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:26 +0000 (UTC)
X-FDA: 85398465852.29.98D6D15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC36F1C000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hg7TwfiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1OInNVm7rDZtBrb7UUeMGX99YfIJ2KTCRFW+s46a8o=;
	b=z5p0hQsG+XofTZScCUu3/NRwqLAKznAdoT1h8+E3kN1TlAawEDG9oQtrBERmJIXBa5whb3
	uCEPSC4EYSGR8RdGBuH76Jb1PXCotioeTNASotBVKGS3QBozpTPZwGUHCHiFahcM5O0j6o
	n2Fn+VKrkjhyG9xT/+pYyC2LxQvF1Xw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hg7TwfiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821524;
	b=DL5/wyAbAeW/KdziRCWhHw1m/J3h00KnolomODwdn6a/OslecHCvw9plohs6t9g2jXdaGY
	1d7UO720dunAyvIMTWytBnxm98wFBmQCJBFjstL0BsU3ZtpqfmW56fhWE7bKl71hdn+h9J
	0OWZcUzWnDSuEw8Tg7MdiBcam2tmaSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 575B060F27;
	Wed,  4 Nov 2026 19:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68C31F00A1A;
	Wed,  4 Nov 2026 19:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821524;
	bh=E1OInNVm7rDZtBrb7UUeMGX99YfIJ2KTCRFW+s46a8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hg7TwfiAh/S+HZXwjJAnEjDkewVJnDjtQ15zWirXU9ybSWS9d5tFc6lb4Y46OnHUJ
	 k9OpxSnvE9RHefcLE70UegKD79VmvWjrEZWfFSASp8+F4OT7ezbj9J/gzzfOkq0eI0
	 JFptxedhnQpdfjNK2vocob1rAbfDUVpvb0e2aqCYrf3CiR/z9mhBdg5NCBNZAmV2TT
	 0Dy/0pgNhj91R4zKIrqK5q2xLhQ9eKBqhicbMV8LYJmRXvPmvWQmI5VRgk5kt4xFAy
	 R2uQeUdehiFWQWbmRdRp3WZQ9mmfU9nvCXWhciuLZYO4oxBvlZVPD8Q/HIy09vPmx5
	 Kl0SkzYGVBcDQ==
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
Subject: [PATCH RESEND v2 12/26] selftests/proc: check that a faulting writer doesn't hold up removal
Date: Wed,  4 Nov 2026 20:45:09 +0100
Message-ID: <20261104-work-procfs-drivers-v2-12-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7944; i=brauner@kernel.org; h=from:subject:message-id; bh=7tbUK/izHUmHqxD4f5JqbQl58tytBiN6D5mHTNsUScI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mq0cehqmXnq4qvLqz+9ru8WDfz/gONZqbnvzrPXV Eo9tKbbdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkOo7hn55UU7aKvdlzBtdr j+a0v7aKmVCU86s1Z779ZevXEZIVqxgZ7qZPv/h0+ez3JtXFv/lWVXzzb2Xe3qmjasKSvqYqb8s pDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC36F1C000A
X-Stat-Signature: dboauyaa5r9nwj1onweufmomj7kswe4s
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793821524-176409
X-HE-Meta: U2FsdGVkX1/ArTqDJYCmWri2BX5GRiBMJ+07DfvhCkvsLS/XoT6qGtPMbYST5T63pizplqfAt4ftapQg0XxTUPYoN0xlEE/nCqXtio2z8DrNy9Z0ZBizg5Y+7klCkHZ3aHx+XRZCiPQ6++KDwXvPBihVezef4IxQQ6Iy+5DFK9+d1qZa4FNAi3c2aCVbIw+1ZDVOou1QXFGZmLAbTuXPFQme17yhed5Ztfy3AEyzJKl5jn6T3yC2w7kUFPhSsnNWy3KdnXIq2/xfgv0/7uDeOAlKy6PHNxxuONoXqfqb1HI2CZnaNCKJm4oXDcQI51QZ4g3nUoHG8IBdTgba7g27nnBa1i0g6dUX/LAyUTfx+Ng/mb1WD+8xwwHmAmynT52EITAfhGB3IezMStq1X85CeLUU7hmoT7dzlmzDBz875FTM1AKr+GiUiEEKz6N2Z+ak2l0ShbNzG95yUYObaV7zSx0RsT260YSQEw8P5lwYcultrgPWp4PQJczjx8unbGaPUbI5tZJxrAhCGDjnBmJjHf2JvvQkAb31bUiTKh04/gajQTQPGEEjPW/g9BySnm/vpZrnxq3tp14mAsgGZztCGJDbLwYawjemwPzKZzrh70o6C25PUG/R778xSHvHNu6V+MDEpEBQbftuywmV4tYHKseZYqGcHdUmDV6tf9RaRP2eK8H1RbArkQFti4+NLCGHwXK7yEf+4xcl+VVvx8BarcKniyTQ0fF1gwwcBgsWQaj/siqeQMTYuQr8GUNC8q1BseFgm8Ns9sIQnrC+/EgLCTH2fQtGR1Rs8w2Ml3xBetud+uBPmhI1nOk85u3LaU3xvUlAG0nMau+9S8cqCIiLCqOKTMgwTPJAoZIPkinVJ315yCEzITCRjBab4XmG/4uwlv5om9a7jy4WQuTwkyoix1WQ07Ax9yR5SVHIQ9nLHznxyP+6bQQTnnillunkrzQxlP+e0dGTQ6eAN1OJV0X
 fFv/Z6sr
 x/gTrfvsaDHXSR/gQEEj71qWPveFil1BDxA+uO5k/VvHAUHQovUHLGb5GhNBCJthTGiDS1MlQeM4APdBgR+yP6nmcdOLAfBdoZ7IQ8ZmmfHRUWnjvSAQMf03BKl3rDUwUBVpB1bRZ7SWnSaR3CHYbxrGBKDqTqL5Mwa0I6ebBwvEtGJg/nUqVxm7FdGjdF6gpKu9LMyBczswKPiRW0vIanLPNYDgGp951LKbqyM7CerOqTMsDQPORnFVELhOzSdxus2a+rXXV++EeGR4GuK/bmRM6tJxQTR+1o4Jt
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

The test loads scsi_debug if it isn't there and skips without it or
without /proc/scsi.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 tools/testing/selftests/proc/config                |   3 +
 .../selftests/proc/proc-remove-slow-writer.c       | 209 +++++++++++++++++++++
 4 files changed, 214 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index cafd8c263c9a..a1994bda676c 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -25,6 +25,7 @@
 /proc-remove-slow-reader
 /proc-remove-mapped
 /proc-remove-slow-readlink
+/proc-remove-slow-writer
 /read
 /self
 /setns-dcache
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index c38297afc244..8fcab5af502b 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -36,5 +36,6 @@ TEST_GEN_PROGS += proc-remove-slow-sysctl
 TEST_GEN_PROGS += proc-remove-slow-reader
 TEST_GEN_PROGS += proc-remove-mapped
 TEST_GEN_PROGS += proc-remove-slow-readlink
+TEST_GEN_PROGS += proc-remove-slow-writer
 
 include ../lib.mk
diff --git a/tools/testing/selftests/proc/config b/tools/testing/selftests/proc/config
index 1504a761b39b..992577d15295 100644
--- a/tools/testing/selftests/proc/config
+++ b/tools/testing/selftests/proc/config
@@ -1,4 +1,7 @@
 CONFIG_PROC_FS=y
+CONFIG_SCSI=y
+CONFIG_SCSI_PROC_FS=y
+CONFIG_SCSI_DEBUG=m
 CONFIG_NET_NS=y
 CONFIG_IPV6=y
 CONFIG_TUN=y
diff --git a/tools/testing/selftests/proc/proc-remove-slow-writer.c b/tools/testing/selftests/proc/proc-remove-slow-writer.c
new file mode 100644
index 000000000000..3539293d353f
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-remove-slow-writer.c
@@ -0,0 +1,209 @@
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
+	/* the host files need CONFIG_SCSI_PROC_FS */
+	if (access("/proc/scsi", F_OK))
+		SKIP(return, "/proc/scsi: %s", strerror(errno));
+
+	/* host numbers are reused, so look for the one that's new */
+	ASSERT_EQ(list_hosts(before), 0);
+	ASSERT_EQ(add_host(1), 0);
+	if (!list_hosts(after))
+		self->host = new_host(before, after);
+	/* the teardown doesn't run when the setup fails */
+	if (self->host < 0)
+		add_host(-1);
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


