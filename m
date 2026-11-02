Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0768A606B93C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJEhvund
Received: by kanga.kvack.org (Postfix)
	id 2D5306B05D3; Mon,  2 Nov 2026 09:26:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABD66B05D4; Mon,  2 Nov 2026 09:26:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2756B05D5; Mon,  2 Nov 2026 09:26:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F032A6B05D3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:26:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DD181A013C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:31 +0000 (UTC)
X-FDA: 85390404582.16.974E5E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E42F018000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJEhvund;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+smlnQLXpLrL35ZrT755yEE+Gx6TEny4ygG6ui3b9as=;
	b=6ta91cqfcRAYNboDtrNoqRM6ErJK62u2gWEBHMiU49yvDmhiCuflnHaeJAjFXbp6bkkywr
	Yzm2QO9vCyNtGsbIM6J1T6aZatRkwDErC+YdeJfLMPkyXh+YvYdEgUKtn1uGIYMbsb0t+w
	+1+v7OAcTh/H2KxjovPHezvmu2Es9uI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJEhvund;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629589;
	b=s0gPpKtAvb7PvZmLNoocIpECTQsDtO1UfonUZAW3TmtyYmQuq0sPRUj4O/8x6eWlWJWBI0
	uUQJZArncq66svRoMVTGJEy1A5hbgz9hvmKZKHnNY8OtMj8TGkSg6FApTbotP8yhvWMgH8
	kHIxF8h7eeoWwFzabFkom0CyPPe0tEE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9378D60018;
	Mon,  2 Nov 2026 14:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A611F00A17;
	Mon,  2 Nov 2026 14:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629588;
	bh=+smlnQLXpLrL35ZrT755yEE+Gx6TEny4ygG6ui3b9as=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XJEhvund6hMVPQJ3RcEchBrOm5EXEzPG/XmOipl3N20lbtuOVIbVGGth/lwANQmOm
	 2MLHVUgbpwmfwoS6ZxvNWEGNZytL8um4VA7L96QCc5ZElIKpNRCAnjTuSrPtTgq/Ku
	 F0u5uYY2avJ1M+M77dUQXw+eL3oJN09kinA/iBSZfN3TBIPuTtvvoIYzixJ6K1SmrK
	 we6emJ68mbMzZ9QAzcQ4Aq8/Ofd0frHNm3JBOohEdkJCS96TvC/88mtWwbGHABeGbk
	 QZHQknmcNs15nJxqRWMOPnS6OX7+hzotVdKm4q4BOSltonATyDmmP/vwWts9yNXKSM
	 NLhKCLq2kEgYg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:35 +0100
Subject: [PATCH RFC 20/38] selftests/proc: check a /proc listing while
 entries come and go
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-20-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8577; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6+oF1vHJFxUuLveQtxt4wRQj/KGMCrRoYw4g79cugGE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJPdk2/MaPxuoVaHsJFFWUnHu7MegVvsd+nWb7w79
 YfU78hZHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPRPMTIsFeHlV3F/6jK3TCp
 71XvNEzlLc87dG3dbSaXlxFZc7FZhuF/9HF+hXesy7/WGOV3RQY+PZAT9Yl/vifbXOeYsx2PWTR
 ZAQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E42F018000B
X-Stat-Signature: g6fjxckg5isgmpauupedxfe8qbxsmn4n
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629589-654596
X-HE-Meta: U2FsdGVkX1/9KvprDHD4xGuqFeqVll36IQG6MvsBvyOQJx6Gn5JquxBHQsjdDPlHbzdD7C/RpQgpruvoxeBTvAoK3k5IQuf0UNuBVsyzZ2gQQJPaZNb7tJuBTStPJZ17/rBHe5fBULZIT8POUsEuH3xFV99cdb9PS89orFGbQoJuNOVRejDWHtI87zOL40sToZHSHK1hjafwx3wACGklYCaAYzljlFc8p8sLuhPogZfD0jbtaKLdZ2r1FzcBb3r7Mm9zuU9fbMh7uosgWN8HKPLtv/aSoOUL+81eToBt3JyP/+YXYCoYHdNx5P3ZBQSGiMOPJ0Lr6aFaNTqfSZ/KybP7tKKbFbzwBP+9MGFC2rg+lepTTToJL0c/63GK4g17+NowWa6zqdY8kana1ipv8PXxwC3J4er2RB66mon9PvzfzpUfHLBgcWVNZTnBciDFA8MLys6PlpA0wXkobsiTNdwNIjO9gmSOuGFuEz3pMdkyqr3BGnQnEVVu2zhW3aGVi6/qNKxbwyU3+3vo+ZtYoXRkA3SUzhkpnLcdUkdqZ/bhghL3bTvuaQyl5IgXroslC1cYIZHrR7u6hM9BX8DqRGzbb1OR2WZEGP0LKsNeIaXU2cO7H2PkRgyO5OYMi29H++0nEGfioy9XZ6jUrxApw2BlfWL5IgmCOrQ/qLAE7MXanLB/jBuInRI/Mbv0nYxKxOy88uXFNut3Bd/eynSOYmafkGJKI/l76rOcE9Hzv4NFoEJ8zMw6YjjHw7ibVNcC2vNpFBe8m5dbrPMqOfneJQ4SbTIr8V1tE1qUPc01iLg0db4zQ+Pjj1RzpmgghinDkSQRY96N/nx5NlWf8kFJ4T5ROBkDMOM14k/jgbBttDMDDsJ4mTjEckXXLLgwlcGtFcLv89J59w4Y0xpiISGSAXb/TQn0vtrtAHZdbi9QjXf0DrsAb3fRinTShIEjeu9Le09s1HdlHgr+2cgAhan
 xj9WFW3z
 lyg4Mg53FuVgX/fOjn0r2civ4adSfijmzMbwsCC4rugmeOcZaEYhPePEOmdd+PkIFOv45TQNCm8XnZj88ZygYD4AH3YNy5n+kEFu4MoP57ct710QFdzXLq27Mi7N7sFpAb4t8v1Dwd5mf6kddnBr8P/bURGeii2OvdltjwHti0wx/YYmwbBiOySoe/taU55253HtF89VRpCyKJI0Ezj0O/wg/u7WLv09USCxrPHKmD1gV9Vx/AZ7bD28VJe23GIZKodKG2kzwhvciyWZlLFQoS4ka561OyyyOkcOd
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
 tools/testing/selftests/proc/proc-readdir-churn.c | 236 ++++++++++++++++++++++
 3 files changed, 238 insertions(+)

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
diff --git a/tools/testing/selftests/proc/proc-readdir-churn.c b/tools/testing/selftests/proc/proc-readdir-churn.c
new file mode 100644
index 000000000000..223b8a6698ee
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-readdir-churn.c
@@ -0,0 +1,236 @@
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
+	if (unshare(CLONE_NEWNET))
+		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
+	if (access("/dev/net/tun", F_OK))
+		SKIP(return, "/dev/net/tun: %s", strerror(errno));
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


