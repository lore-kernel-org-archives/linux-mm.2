Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9960E606A862
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NAj0hod0
Received: by kanga.kvack.org (Postfix)
	id B78A46B05E2; Wed,  4 Nov 2026 14:28:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50786B05E3; Wed,  4 Nov 2026 14:28:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F806B05E4; Wed,  4 Nov 2026 14:28:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4D86B05E2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:28:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D6E9C060D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:28:14 +0000 (UTC)
X-FDA: 85398422508.25.9FB3537
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C001140009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:28:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAj0hod0;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NP9uzi8hQ+GlRLcZMObnNOIDymBGDWJ+1F292ZdPL1I=;
	b=soYF04SarE4d0i6qTaJSzym6ZmtSpN2GlqE1M++3flBvG73O5IjAc/gVBzMEV6QKZSQjJd
	h18nGLHKL25Gsdsjm7gHMeUVKYq8xoSfB1tEVmF1Hlf8rv9O36fkuZBTsy1ukZMGeb7M/q
	HAnrA+nYPYPpSb/iGPwRvPqWOFpQtl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820492;
	b=nZeJCcP2225zaros4nkPvk/e+F/MajcNXXCnD53TfyeUghd9cK4kYRnvrdBsmEqTAUFbAL
	QJBd7Tz/lJkgOtJvDjS2w/ubsfdw/Zd3JRQ6sTDyyk63o1Uni0SPSnuA2tWtxAmwp0j1Hi
	ho5whIk0xC22Gr2xmkQslW8G7xbjhbA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAj0hod0;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 050E44027A;
	Wed,  4 Nov 2026 19:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0181F00A1A;
	Wed,  4 Nov 2026 19:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820491;
	bh=NP9uzi8hQ+GlRLcZMObnNOIDymBGDWJ+1F292ZdPL1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAj0hod0GiSh4qiNLTi1WX0FoLlXN1CGhLjOdCOe4qKNayvu6TCmjiiEC+ctqpF30
	 Igi4m0MulaDp3RSFvu12z8/wJ0dZpMZZQme4XlhE5RIM8NWMXxDqUFA5eauZhBnQRO
	 j2urs+dGqlCxGrcn5k38haREiKA82S2hwykYvSi0weYQCwh1ZmuLytX/pSd0D8M2hT
	 L77+vI7tAfBbEJuHDq4CScHOXscr4x4MRY6of9vu1Cc+S8fMmRGO+jwvJWiZORMyjB
	 7Dd2f7v8aATY8DgDMEEOJzcMqYDQ+r7ut2U0vVHHCtlWaUiln6c9F0ICijdirmp7HY
	 syT8HsDpuWIgQ==
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
Subject: [PATCH RESEND v2 49/51] selftests/proc: check that faulting sysctl accesses don't hold up removal
Date: Wed,  4 Nov 2026 20:27:58 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-49-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7877; i=brauner@kernel.org; h=from:subject:message-id; bh=nCZPyQUbx5TtYoxg9V0ET+7jSg+MEw36C1ShZRwuIz8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9buIQvq4skXTQTjUuXmTXOeOyKTNaPto9S5ZwizNK1 bd4x7mto5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCL1kxj+Vyjv+nbt3OspWhEb vBoP9CTYsfBOVTztsymEa5vl9nmsgYwMbxrZPeK5fOzuqipN+Wp3d03//tlX/wmFFa3eVMgRE3m LFQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C001140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: cfpa7mq4uthy75pp8b4xx91hakpc13p7
X-Rspam-User: 
X-HE-Tag: 1793820492-281419
X-HE-Meta: U2FsdGVkX1/WbnnZUgau0BbE7K8nZ9m5YeYC0y2Imj0eP8xqsaSeTCGQt9bDwTQLLIyV/K9Eo9f+bbNjoeLmx5FNT7Fmw+pMXi6hC+vinU615DoFGzlrevbNNlYa1b/4jXJ3VtFyQAINa+KvSXF6sbxqn7xQ0xt8++ocBRa45lVm0fv/hcxUWVvqBpTcczi4cVVAhycNs+T8ytGyIrrwsRCG/skp6XkHZlMxNB+bFcA40QRcv6e7jWs19eUmUzfsSOGi9pO5jgi1RgNEk00p71el6BhsAGFTaHdolWahPEnHLnPWgiaNcFV1KHTfLAZM/3T0JwHRKRfcKbqpODxUV4fBmII57NbvVlFTU5TpvTmi6DtlG2VO7ElN3gcJD7rc/6PzV/jIzwe+x7to2JdMlRP5dLq9KUWshksRJKe8Zt5ngwIRYH1sv9v4YJ4nHpNav6fpvabDk8lR3fGT5FNwPL2/yaIgOCUcNLn0qm7Znbxkd2G6vLkE3mtQ48wb3d0S8X53koV1YB2I5ym+Yr4CfjApD1EK2qb5nDYR6Dr/0XhxKOACFWrrbRd2rYv1NSgpbwIOsuRPddyl55XLiPUBQbLTIGOZnndyEWTbuWQ8M5u5Tmz7tuT832GHhceUekjWTr26ySnpQ93dap3KF3znmqDaaTsZHIN+BdwpQIfqpU1atpjr4DdxsJB5jNnOjy0HCnS805WJqMjinzO2bM+iTWS5ysOpXJMoOm8C5WUGIN9sY5Z+fd5JAlKLw9lrbgb6NMUOrk/nlERYIbPiTrEf7E6c7wKBxV/Gvn7W+ze6SoZSiw/oH3had25euATderA/QidiJeG1chkzEGUOabUcrqfYm+ybfH0/GoyC9Z78CarEs6coMQ8UM0Wz7FlNuIJcPZaLqpvjwooLp1yPzefpvbX88O75Gd8Bl/cXq+wgX7SPMuMp724Hp6CZRvnXlQTvTr11+ID0ap2r1U0CghX
 gg3Tgtnl
 kbU8A/GDgzwtUihjcl+Bi+I8nuTiQDTKFauaq9/BvXbr/zV7HuzAsNBgHN4H5RwTAUwLepaOb6MnLcBZbHQ8KYA+LaBpJXoGhz8XufwbFPHw2IHG+3uEiySgLu1QLn8XvOVbcL/PWsEHsHueE1JvTHs+o2vR8+hG9hemzkvcRouyhTZa93Pf/jKJtmAkamekgy1BCuHiGtwEuKAmwLNKgyg9U+8ZDk279zfWEhXDq+C6+xRyjUvs3vXQAZUglpPYyNGjt+o7rIKMgFerBbMf2Zl2CUdUnIai4DXVR
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
 .../selftests/proc/proc-remove-slow-sysctl.c       | 215 +++++++++++++++++++++
 3 files changed, 217 insertions(+)

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
diff --git a/tools/testing/selftests/proc/proc-remove-slow-sysctl.c b/tools/testing/selftests/proc/proc-remove-slow-sysctl.c
new file mode 100644
index 000000000000..e2992a26ed69
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-remove-slow-sysctl.c
@@ -0,0 +1,215 @@
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
+	/* start behind the dots so that it faults on an entry it looked up */
+	ASSERT_EQ(lseek(w.fd, 2, SEEK_SET), 2);
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


