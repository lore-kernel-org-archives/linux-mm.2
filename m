Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328C0607039E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eW6R0uhw
Received: by kanga.kvack.org (Postfix)
	id 4AEA66B05E7; Mon,  2 Nov 2026 09:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45FBC6B05E8; Mon,  2 Nov 2026 09:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326F86B05E9; Mon,  2 Nov 2026 09:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 031B76B05E7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:29:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7158BA6592
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:29:28 +0000 (UTC)
X-FDA: 85390412016.01.73D774A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92294100005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:29:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eW6R0uhw;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629766;
	b=pmNOiCq2xQKvfwVYAzhcxe2mSMHPHj20tAdC4yujqixv732SU7Tu4QxHWxkM3QHYch1ZAO
	wBnWcSSZ3nPFkvTuy6SzTIyDAx98gunnlvvkwJm7Suy5c79AJRYyfazTedlrZbCBIEC/zo
	b8yn+2BM7+mcO534r9UhOTBgyJJma9M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eW6R0uhw;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Wx/9hEycnxG6QqWT58rgPjCjctkpbUJ1BsGJ+UfGVA=;
	b=2QhCgRXSVEoibXYX1NstI8jB1xY2v52uyHusbK1v8NtY4urCRQSyL2PZsUVnon5lDKchPB
	Z7/Srk+u4Qq55/lg3MU6W0OeCymwpBaHYfLklh/o256nf8HJFHTNaJwKP2GrB/qXekyqTe
	VOHTdX4abKm0Y3pusF1qJFltrqmJ8zI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0CE642DA5;
	Mon,  2 Nov 2026 14:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F5B1F00A18;
	Mon,  2 Nov 2026 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629765;
	bh=/Wx/9hEycnxG6QqWT58rgPjCjctkpbUJ1BsGJ+UfGVA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eW6R0uhwxmp1LxYPzZlSqP55jX3R1bLXeaGtF+FDg3DWqKEMDO9KauKhOwQ8ubsCQ
	 fBe4h39HrP7xRV61MSsKKfiOFZzvbU/OzY7VZU0Fq3CrSBnMDq0rZXzZfnCu/uF48O
	 HPf9NbOeuXPLNHRGdye5RY6G3G+n0wc9qdGZeOuvgwbw2lDj9zICBQVS7t2oEbXlMn
	 8S5mBzFa4thYSzcTzqy+1xJdsRKmYjB8C1Ihqi+VpoXlrdWAMX5nyktL+fKIUpcZet
	 5atlLoyOrwbZo+AWJ0BsA/ElUz6LoJgm1k0YxqIK/Lt/7rH1YT0aokmyMdLB5DliLp
	 f+qLHZu8+PEYw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:47 +0100
Subject: [PATCH RFC 32/38] selftests/proc: check a sysctl listing while
 entries come and go
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-32-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5795; i=brauner@kernel.org;
 h=from:subject:message-id; bh=PoVb2K3h8KM7KPudC9ie8mT7qnQN29SNHExdevOrgr4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOz8euhrPDD6keYJt57ESafo71NyvTKB4XSe0vV/
 d2L0jmrOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbyPp6R4T1v/gO3yVq1bLFa
 9xR+MagsYBDe1Wu1ffOZjP07lprMfsDI8GKVk+DOKW/3SgRckbmd9SEtUYQ39/Vpg2IN4d83DE5
 OYgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 92294100005
X-Stat-Signature: da91q8hekncfe89hp15fj5iazwr4u34p
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629766-759078
X-HE-Meta: U2FsdGVkX187v8/z86biDssljxX3/oBOXE/IDd4DUaMZmvynR/FaUQLQH4V+9o0663G5u1dimolVlsXnLCPsOm/QXauYxcQyL0GvjuABIzzW5jAMGPGqqQv/UIS0+D8dLJ2zIMmVSdsdHx8bLi8x2qg5C9YYbSSmYGK2M9X22Vj/Crgqq0Uol5YQeCCMYkcc+8+cASFOfxScbYAkRbM2YmEWKNV6sUAgZm3nJwYWR25WNRakpIjOT3cF7yVwdriyVQiWutZX0P+lBmlfG5qH/NhZWNU3WGqlQpJPzNfeveIlC7WBpRsT7mM8OmD2V9YZ2ScpyuFy8lpPbbe5mFdxWMBb1Y2kJ9LplH1I8k8pKsk720qkkJNAIdVk7Yc5b4NvwLzYXTskrOmYhge8U6Jpka46LUS0wzKfvA/rr8LXZR4shYT9RX3Nb2BboNDwDNtt150WVPxxZGsXmvAp7p3V45rmq7iuFWViYq0e2AFs+PcGhPCEn9ytdSyb2fGnyRK7n6/hKFwzzqQhqT/zIz8pX+QX0rVl6/hHfKOv8vzunFpWM8EPkkpID5KjeSRYrNxK6vYWWA77MqnceC3X+1H/07KzVx/igGD7vuHcXndV9GL7VMM3qqENPUCpQhdqBhhtrxbhSh6kytOU22iBnuBPr75OZTNuqy6xp/hf+N4EafC9sjefo5BOO1ZCznKUCBhGQCprw2oNcyFoRkBIrmz02vkPKPUypeepxvc1R+hYEpgSXxXj/biUxo/99wmCMbAPqjqneJ51QR3KNO+IqhJwa4HPYo2pRoTKvKX9f1T66NgaTZPugfX4RYzWwwwwW94c1Rl5+Dg+Ko4dc0dRJ1T0X3LBbKDgAy6y27jEpHBaC94DlL5NFj7RR2VQ9w4bU+I2xk6xA2j4S35WKoHaXfZhSNMy5S4tVM9bd0FURx6PP4QeWk6CWDjlLuWXQSM99NrPCfNuL8tEUApkUdmEfdb
 5NdGmuVm
 Mc3I6gTZdYS7c8e0v93A8NW7wh9FCCYrq5EoP/N4I9LaeRzEjjokQ4fglesPAB6D+6vbiTvVFHYBFeBaiRms3fGhUB2z18dqSWKr/FHNSaRRkQbljbIvvCucPaQBg218aq1NryI0grb4rwZANbmhxdco7UywnwWMtKfzqPcxLa5n+gYIllw5vAofcWxoDPEuYo0dfg9zxjO6198XNwtN7PbGve+Kca+Rldf4BieguKMzMqzOB5bsbz+fKqy7vN01sOBB6JsGujRUXwvYQd+9ehsymsaq9qX+noPk5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

List /proc/sys/net/ipv4/conf of a new network namespace in two pieces:

- with a buffer that holds the dots and "all", register a tun device
  whose name sorts first, finish the listing: "all" is listed once

- with that device registered and a buffer that holds the dots and it,
  unregister it, finish the listing: "all" is still listed

Both fail without the fix, the first lists "all" twice, the second not
at all.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 .../selftests/proc/proc-sysctl-readdir-churn.c     | 147 +++++++++++++++++++++
 3 files changed, 149 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index 8520c7878ea2..5b5e24e39cbd 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -25,4 +25,5 @@
 /self
 /setns-dcache
 /setns-sysvipc
+/proc-sysctl-readdir-churn
 /thread-self
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index e0c0d313f4d0..dae09f333455 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -30,6 +30,7 @@ TEST_GEN_PROGS += setns-sysvipc
 TEST_GEN_PROGS += thread-self
 TEST_GEN_PROGS += proc-multiple-procfs
 TEST_GEN_PROGS += proc-fsconfig-hidepid
+TEST_GEN_PROGS += proc-sysctl-readdir-churn
 TEST_GEN_PROGS += proc-pidns
 
 include ../lib.mk
diff --git a/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c b/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c
new file mode 100644
index 000000000000..0e067a3619c4
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A listing of a /proc/sys directory that takes more than one getdents64()
+ * must not show an entry twice or skip one when an entry is registered or
+ * unregistered in between. /proc/sys/net/ipv4/conf/<dev> of a tun device
+ * comes and goes with the device.
+ */
+#define _GNU_SOURCE
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/if.h>
+#include <linux/if_tun.h>
+#include <sched.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#define CONF_DIR	"/proc/sys/net/ipv4/conf"
+#define TUN_NAME	"a0"		/* sorts before "all" */
+#define TUN_PATH	CONF_DIR "/" TUN_NAME
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
+FIXTURE(sysctl_readdir) {
+	int dir;
+	int n;
+	char names[NAMES][NAME_MAX + 1];
+	char buf[65536];
+};
+
+FIXTURE_SETUP(sysctl_readdir)
+{
+	if (unshare(CLONE_NEWNET))
+		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
+	if (access("/dev/net/tun", F_OK))
+		SKIP(return, "/dev/net/tun: %s", strerror(errno));
+	self->dir = open(CONF_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_GE(self->dir, 0);
+	self->n = 0;
+}
+
+FIXTURE_TEARDOWN(sysctl_readdir)
+{
+	close(self->dir);
+}
+
+/* a device registered in front of the position doesn't repeat an entry */
+TEST_F(sysctl_readdir, register_in_front)
+{
+	int tun;
+
+	/* ".", ".." and "all", "default" doesn't fit */
+	ASSERT_EQ(list(self->dir, self->buf, SMALL_BUF, self->names, &self->n), 3);
+	ASSERT_EQ(count(self->names, self->n, "all"), 1);
+
+	tun = tun_open(TUN_NAME);
+	ASSERT_GE(tun, 0);
+	ASSERT_EQ(access(TUN_PATH, F_OK), 0);
+
+	while (list(self->dir, self->buf, sizeof(self->buf), self->names,
+		    &self->n) > 0)
+		;
+	EXPECT_EQ(count(self->names, self->n, "all"), 1);
+	EXPECT_EQ(count(self->names, self->n, "default"), 1);
+	EXPECT_EQ(count(self->names, self->n, "lo"), 1);
+	close(tun);
+}
+
+/* a device unregistered in front of the position doesn't skip an entry */
+TEST_F(sysctl_readdir, unregister_in_front)
+{
+	int tun;
+
+	tun = tun_open(TUN_NAME);
+	ASSERT_GE(tun, 0);
+	ASSERT_EQ(access(TUN_PATH, F_OK), 0);
+
+	/* ".", ".." and the device, "all" doesn't fit */
+	ASSERT_EQ(list(self->dir, self->buf, SMALL_BUF, self->names, &self->n), 3);
+	ASSERT_EQ(count(self->names, self->n, TUN_NAME), 1);
+
+	/* closing the device unregisters its sysctls under RTNL */
+	close(tun);
+	ASSERT_EQ(access(TUN_PATH, F_OK), -1);
+
+	while (list(self->dir, self->buf, sizeof(self->buf), self->names,
+		    &self->n) > 0)
+		;
+	EXPECT_EQ(count(self->names, self->n, "all"), 1);
+	EXPECT_EQ(count(self->names, self->n, "default"), 1);
+	EXPECT_EQ(count(self->names, self->n, "lo"), 1);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


