Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF75607E9AD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZJA+k4jF
Received: by kanga.kvack.org (Postfix)
	id 314BA6B05F4; Tue, 10 Nov 2026 04:20:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBE36B05F5; Tue, 10 Nov 2026 04:20:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201DA6B05F6; Tue, 10 Nov 2026 04:20:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1AC46B05F4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:20:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8440FC0388
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:40 +0000 (UTC)
X-FDA: 85418664240.29.9CE5087
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB09B140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJA+k4jF;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcRXRAYOuW3Mg9I3hu0cD8PLY2YH/pH7TktBJyJSNx8=;
	b=yv0X9re1DAulIkzUMonJUvFDYKaTB9JxpB/2IPCcGpfHkkZZbQ42aP5ndg69kOIpPRLe1F
	Vu4I71g+TfmqaRrFADoHQH9MZxXI8XLKphsX4Dn0wAp00NYzxWglFzLpZ9o3CwNy12GjKM
	MfdKS951zLQ/miN5+o6jYOfrcxyLbhA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302438;
	b=j9WUAHH9mvfKVqGmxrqhn85/bPfHhRf0Hhn5xzcRebdjBIGpPBIbAj+1EdfNmXjwOjWszn
	F/iKXgEbvSF7pCYOw5rvy+dRyodILUhRPWG9VCrNRtLT/IVQMW/X7sBwMGbPwYmSxNj58R
	2tQ8yyNdjfPvV0YomXdJ6nRRAba8v5Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJA+k4jF;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FF426382C;
	Tue, 10 Nov 2026 09:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D341A1F008A2;
	Tue, 10 Nov 2026 09:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302438;
	bh=HcRXRAYOuW3Mg9I3hu0cD8PLY2YH/pH7TktBJyJSNx8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZJA+k4jFVB7QcXl0KFVo6FAm8XI4UkHhmuHM+xAo6A08HhRmiH/wYZOdlnlgLrh/9
	 rcM+5k5rzdiLJi52fkaGO8lhYCA13C2aDo9CFXO/uzKhnDpIZ5rI/vU3Ljq7x3I7Bm
	 MkhWlzcBR2LGti6K8n98z2uTbwDhWQPDuXr4DHrqemvTOVN3Tx4nNOe+6eX4Ml7Fyp
	 9Vko9fTHjCHZ5NBoWCSVWvJBcx8Fv6eWP7XqdB6tuOAdRQweUL01pdhN1qREgq1HLW
	 tKInp2gJ5HWhSiFiMhTw2dXTpS/ltNMOEyHElB6ILu033FIsaRQKmc4sbsA3Bxf7u6
	 4uHy8e3VDnRvw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:57 +0100
Subject: [PATCH RFC 41/41] selftests/filesystems: add backing file tests
 for pseudo files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-41-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=9874; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WrNqWZ7KkNp+RAbIFwB8NnBVD99KxYHQRcnlviAxa6g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9enD4WbX5pPn5ziIC13kaPmfytEQmM0ZuPbw7WXPnm
 gSxsqe1HSUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNZ8ZHhf973fTs7218EO58x
 7P0e6Ze9+P+LjPP3fh7Xiy851MXwVZ/hx12Ja4+3MNaXiaTntPJ9281nGrssMtLdPjC4ZaFVjDA
 DAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB09B140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: k45ezp3misizjfmfhq3hcuissdh8tt19
X-Rspam-User: 
X-HE-Tag: 1794302438-694897
X-HE-Meta: U2FsdGVkX189IDpSKuMDJqfRVhJ9tjuqztCKtUNF6nVo7Mv4rrFH57cXG2bp+1P8s+Y7cf/tFB13J53sNx6qkU8cGOrXl2ZBmXNog+abDofCLMfUCxE0blaMqeA/jKBeBjb/mHRSD1/LE7V/tgG1fiIUsfj89ovPGDQB55m/7qdSsWaIljKh+iPgon3IBFdiPAxEHO4wGaKbufWddMadAV984SsKpPaiSBIUkFmTxcfNqJU6dC6EMEtY+/BBz5eJ1uTU+VwMLyneoQM+EA22fydJJJ1EmqCTrW1zErhh0OMzheEnFzI9GWmW7K7OUyYHK/R6BBOOfyVrfP0WPJMIOq58BLiUzhCVJEj/kAqV9H9kvFW1X2PMU3myVspPz+pVrTJLp1/QKzxYAMwARYYN841FrZlW/ll83Xx4HL03rD2LLhwXOn4fNm/QMIPjTqMUi5FF783M6ludroNjRYRmQ9eNvKNYd1bdUpW9PWQcUM9hJh4AHjLHTztjO9EdwOceDqI0ku0OfEH5l0AsF7ry7exZoZCp2muWTeH6jhJ0xkMA9whrrL1hJKQQgBmoLY7vjP9+N3RPJ/5jOnFDrxIN/itPejYydCV39uPXjX5FR0JpcH8q6E/fOishYtcyPyBmeE/BieuRt7iuqsC0wnkUQZmVUDkXe5k3Ur59hzYhLIKnuLvQC4EGLRZUxdbtYmF8jt0sbaDNOSTlcoTdbYXdHvoJ2iRM+jqf8podRoHuZAcSDlbZ3CIrJkpRxmqXsaeqB2qOKOHwQDDKOUEnE9H0x0nzMAKVYSr3h+M+0WTqMTAaNneNLN70jX3QKHrBHNkCRpgg/oFy8EXh+QwC3AOYdO92oL/O6SihTcXIDDKyV3UG/ciMuisM3i97+23dDamSA2DLaFS04+i64hlSXKYWry2zM+pKEPNvab3fr2f4XNpo+3Lbc3PZCd2Fc2GikTr8U5hSDEUw1wowBG2wovr
 v+zTxqdB
 S7dZshKWDFrI24DpCepuayxwMnRn/2OWimsjar3eo5juhErGEbPEAHiKidy7WEvXHipHMHYWRhzFvOIg0152z75hHr1WJFHVlrnAkhquE29FIlu2QlFLLtsOGel8c99skoflxEVXXJVZXx4wa75eyjxWTIZhh67NeNWEL6PMlylbD6YUnIlxRBa5zL5bEpMRFv+Z9b/WLN/2ADkvldUsRWjPyOtPERh5dWr8vF3Adrkzjn+XYq2hkT7p0itV+J+UVT+q2jA14PcZVvYTcEsX6pQWC/G5WJlzjVz0fuj5X0Y1m5ePsQrzPHXIBHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add tests that files on pseudo filesystems can't be used as storage:

- a procfs file attached read-only to a loop device
- sysfs files attached read-only and read-write to a loop device
- a sysfs file behind a lower-only overlayfs attached to a loop device
- a sysfs file as the backing file of a usb mass storage gadget LUN
- a sysfs file as the source of a file-backed erofs mount

And make sure that a memfd and another loop device still work as loop
backing files and that loop refuses a backing file that isn't open for
reading.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/filesystems/.gitignore     |   1 +
 tools/testing/selftests/filesystems/Makefile       |   2 +-
 tools/testing/selftests/filesystems/config         |   9 +
 .../selftests/filesystems/pseudo_backing_test.c    | 274 +++++++++++++++++++++
 4 files changed, 285 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/.gitignore b/tools/testing/selftests/filesystems/.gitignore
index cf79000e4092..8df38eabb125 100644
--- a/tools/testing/selftests/filesystems/.gitignore
+++ b/tools/testing/selftests/filesystems/.gitignore
@@ -7,3 +7,4 @@ kernfs_test
 idmapped_tmpfile
 ustat_test
 rw_hint_test
+pseudo_backing_test
diff --git a/tools/testing/selftests/filesystems/Makefile b/tools/testing/selftests/filesystems/Makefile
index fbd5c27505ef..0ebb9005bcd2 100644
--- a/tools/testing/selftests/filesystems/Makefile
+++ b/tools/testing/selftests/filesystems/Makefile
@@ -2,7 +2,7 @@
 
 CFLAGS += $(KHDR_INCLUDES)
 TEST_GEN_PROGS := devpts_pts anon_inode_test kernfs_test fclog ustat_test rw_hint_test
-TEST_GEN_PROGS += idmapped_tmpfile
+TEST_GEN_PROGS += idmapped_tmpfile pseudo_backing_test
 TEST_GEN_PROGS_EXTENDED := dnotify_test
 
 include ../lib.mk
diff --git a/tools/testing/selftests/filesystems/config b/tools/testing/selftests/filesystems/config
index 9f45bc493a30..228196160d29 100644
--- a/tools/testing/selftests/filesystems/config
+++ b/tools/testing/selftests/filesystems/config
@@ -6,3 +6,12 @@ CONFIG_NET=y
 CONFIG_NET_NS=y
 CONFIG_INET=y
 CONFIG_SYSFS=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_OVERLAY_FS=y
+CONFIG_TMPFS=y
+CONFIG_CONFIGFS_FS=y
+CONFIG_USB_GADGET=y
+CONFIG_USB_CONFIGFS=y
+CONFIG_USB_CONFIGFS_MASS_STORAGE=y
+CONFIG_EROFS_FS=y
+CONFIG_EROFS_FS_BACKED_BY_FILE=y
diff --git a/tools/testing/selftests/filesystems/pseudo_backing_test.c b/tools/testing/selftests/filesystems/pseudo_backing_test.c
new file mode 100644
index 000000000000..bc8e17ab8e6e
--- /dev/null
+++ b/tools/testing/selftests/filesystems/pseudo_backing_test.c
@@ -0,0 +1,274 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/loop.h>
+#include <linux/magic.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
+
+#include "kselftest_harness.h"
+#include "wrappers.h"
+
+/*
+ * Put @fd behind a free loop device. The device is set up with
+ * LO_FLAGS_AUTOCLEAR and goes away again when it is closed here.
+ */
+static int loop_attach(int fd, bool rw, char *dev, size_t len)
+{
+	struct loop_config cfg = {};
+	int ctl, nr, lfd, ret = 0;
+
+	ctl = open("/dev/loop-control", O_RDWR | O_CLOEXEC);
+	if (ctl < 0)
+		return -errno;
+	nr = ioctl(ctl, LOOP_CTL_GET_FREE);
+	if (nr < 0)
+		ret = -errno;
+	close(ctl);
+	if (ret)
+		return ret;
+
+	snprintf(dev, len, "/dev/loop%d", nr);
+	lfd = open(dev, (rw ? O_RDWR : O_RDONLY) | O_CLOEXEC);
+	if (lfd < 0)
+		return -errno;
+
+	cfg.fd = fd;
+	cfg.info.lo_flags = LO_FLAGS_AUTOCLEAR;
+	if (!rw)
+		cfg.info.lo_flags |= LO_FLAGS_READ_ONLY;
+	if (ioctl(lfd, LOOP_CONFIGURE, &cfg)) {
+		ret = -errno;
+		close(lfd);
+	} else {
+		ret = lfd;
+	}
+	return ret;
+}
+
+static int attach_path(const char *path, bool rw)
+{
+	char dev[PATH_MAX];
+	int fd, ret;
+
+	fd = open(path, (rw ? O_RDWR : O_RDONLY) | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	ret = loop_attach(fd, rw, dev, sizeof(dev));
+	close(fd);
+	if (ret >= 0) {
+		close(ret);
+		ret = 0;
+	}
+	return ret;
+}
+
+static bool can_use_loop(void)
+{
+	return geteuid() == 0 && access("/dev/loop-control", R_OK | W_OK) == 0;
+}
+
+TEST(memfd_backing_file)
+{
+	char dev[PATH_MAX];
+	int fd, lfd;
+
+	if (!can_use_loop())
+		SKIP(return, "loop devices unavailable");
+
+	fd = memfd_create("pseudo_backing_test", MFD_CLOEXEC);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
+
+	lfd = loop_attach(fd, true, dev, sizeof(dev));
+	ASSERT_GE(lfd, 0);
+	EXPECT_EQ(close(lfd), 0);
+	EXPECT_EQ(close(fd), 0);
+}
+
+TEST(loop_device_backing_file)
+{
+	char dev[PATH_MAX], dev2[PATH_MAX];
+	int fd, lfd, bfd, lfd2;
+
+	if (!can_use_loop())
+		SKIP(return, "loop devices unavailable");
+
+	fd = memfd_create("pseudo_backing_test", MFD_CLOEXEC);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
+	lfd = loop_attach(fd, true, dev, sizeof(dev));
+	ASSERT_GE(lfd, 0);
+
+	/* A block device stays fine as a backing file. */
+	bfd = open(dev, O_RDWR | O_CLOEXEC);
+	ASSERT_GE(bfd, 0);
+	lfd2 = loop_attach(bfd, true, dev2, sizeof(dev2));
+	ASSERT_GE(lfd2, 0);
+
+	EXPECT_EQ(close(lfd2), 0);
+	EXPECT_EQ(close(bfd), 0);
+	EXPECT_EQ(close(lfd), 0);
+	EXPECT_EQ(close(fd), 0);
+}
+
+TEST(write_only_backing_file)
+{
+	char dev[PATH_MAX], path[PATH_MAX];
+	int fd, wfd, lfd;
+
+	if (!can_use_loop())
+		SKIP(return, "loop devices unavailable");
+
+	fd = memfd_create("pseudo_backing_test", MFD_CLOEXEC);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
+
+	/* Loop reads from its backing file so it must be open for reading. */
+	snprintf(path, sizeof(path), "/proc/self/fd/%d", fd);
+	wfd = open(path, O_WRONLY | O_CLOEXEC);
+	ASSERT_GE(wfd, 0);
+
+	lfd = loop_attach(wfd, true, dev, sizeof(dev));
+	if (lfd >= 0)
+		close(lfd);
+	EXPECT_EQ(lfd, -EBADF);
+	EXPECT_EQ(close(wfd), 0);
+	EXPECT_EQ(close(fd), 0);
+}
+
+TEST(procfs_backing_file)
+{
+	if (!can_use_loop())
+		SKIP(return, "loop devices unavailable");
+
+	ASSERT_EQ(attach_path("/proc/cpuinfo", false), -EINVAL);
+}
+
+TEST(sysfs_backing_file)
+{
+	if (!can_use_loop())
+		SKIP(return, "loop devices unavailable");
+
+	ASSERT_EQ(attach_path("/sys/kernel/warn_count", false), -EINVAL);
+
+	if (access("/sys/kernel/reboot/mode", F_OK))
+		SKIP(return, "no /sys/kernel/reboot/mode");
+	ASSERT_EQ(attach_path("/sys/kernel/reboot/mode", true), -EINVAL);
+}
+
+TEST(overlayfs_on_sysfs_backing_file)
+{
+	if (!can_use_loop())
+		SKIP(return, "loop devices unavailable");
+
+	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
+	ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL), 0);
+	ASSERT_EQ(mount("tmpfs", "/tmp", "tmpfs", 0, NULL), 0);
+	ASSERT_EQ(mkdir("/tmp/empty", 0755), 0);
+	ASSERT_EQ(mkdir("/tmp/merged", 0755), 0);
+
+	/* A lower-only overlayfs serves reads from sysfs. */
+	if (mount("overlay", "/tmp/merged", "overlay", MS_RDONLY,
+		  "lowerdir=/sys/kernel:/tmp/empty"))
+		SKIP(return, "no overlayfs on top of sysfs: %s", strerror(errno));
+
+	ASSERT_EQ(attach_path("/tmp/merged/warn_count", false), -EINVAL);
+}
+
+#define CONFIGFS_DIR "/sys/kernel/config"
+#define GADGET_DIR CONFIGFS_DIR "/usb_gadget/pseudo_backing_test"
+#define MASS_STORAGE_DIR GADGET_DIR "/functions/mass_storage.0"
+
+TEST(usb_mass_storage_backing_file)
+{
+	const char *path = "/sys/kernel/warn_count";
+	struct statfs sfs;
+	ssize_t ret;
+	int fd, err;
+
+	if (geteuid())
+		SKIP(return, "needs root");
+
+	/* Mounting configfs on top of itself fails with EBUSY. */
+	if (statfs(CONFIGFS_DIR, &sfs) || sfs.f_type != CONFIGFS_MAGIC) {
+		ASSERT_EQ(unshare(CLONE_NEWNS), 0);
+		ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL), 0);
+		if (mount("configfs", CONFIGFS_DIR, "configfs", 0, NULL))
+			SKIP(return, "no configfs: %s", strerror(errno));
+	}
+
+	if (mkdir(GADGET_DIR, 0755))
+		SKIP(return, "no usb gadget configfs: %s", strerror(errno));
+	if (mkdir(MASS_STORAGE_DIR, 0755)) {
+		err = errno;
+		rmdir(GADGET_DIR);
+		SKIP(return, "no usb mass storage function: %s", strerror(err));
+	}
+
+	/* Writing the path opens the LUN's backing file right away. */
+	fd = open(MASS_STORAGE_DIR "/lun.0/file", O_WRONLY | O_CLOEXEC);
+	EXPECT_GE(fd, 0);
+	if (fd >= 0) {
+		ret = write(fd, path, strlen(path));
+		err = errno;
+		EXPECT_EQ(ret, -1);
+		EXPECT_EQ(err, EINVAL);
+		EXPECT_EQ(close(fd), 0);
+	}
+
+	EXPECT_EQ(rmdir(MASS_STORAGE_DIR), 0);
+	EXPECT_EQ(rmdir(GADGET_DIR), 0);
+}
+
+TEST(erofs_backing_file)
+{
+	bool refused = false;
+	char buf[256];
+	int fsfd, ret, err;
+	ssize_t n;
+
+	if (geteuid())
+		SKIP(return, "needs root");
+
+	fsfd = sys_fsopen("erofs", FSOPEN_CLOEXEC);
+	if (fsfd < 0)
+		SKIP(return, "no erofs: %s", strerror(errno));
+
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "source",
+			       "/sys/kernel/warn_count", 0), 0);
+	ret = sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
+	err = errno;
+	if (ret && err == ENOTBLK) {
+		close(fsfd);
+		SKIP(return, "no file-backed erofs mounts");
+	}
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(err, EINVAL);
+
+	/*
+	 * Something that isn't an erofs image fails with EINVAL as well so
+	 * check that the source itself was refused.
+	 */
+	while ((n = read(fsfd, buf, sizeof(buf) - 1)) > 0) {
+		buf[n] = '\0';
+		if (strstr(buf, "pseudo filesystem"))
+			refused = true;
+	}
+	EXPECT_TRUE(refused);
+	EXPECT_EQ(close(fsfd), 0);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


