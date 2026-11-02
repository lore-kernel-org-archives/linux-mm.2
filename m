Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F2360771D8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PR4eStJu
Received: by kanga.kvack.org (Postfix)
	id 1F4726B05D0; Mon,  2 Nov 2026 09:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A45D6B05D1; Mon,  2 Nov 2026 09:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0938A6B05D2; Mon,  2 Nov 2026 09:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C899F6B05D0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:52:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 602F1160155
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:52:09 +0000 (UTC)
X-FDA: 85390469178.12.100EEAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3D37140003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:52:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PR4eStJu;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJ84nEP4YY4K28kLfEZAA/6j0sLXVTf/aEe1LCZ8e14=;
	b=w2R/+aZWGNvbMSv45biO4Q7a4yg+xF8QEPUwLKITJf7MgwhW3soE5gepee9l56oVbb21Ie
	wUipEWy1lNOBK3ZuH3itb6X7KxKqBkc5I+p7vBdpu7JDpO6Fd3W+mCVWxFtDGGm6ckfBHB
	9Xfp8wjID9f0GcjbzcIYnvclwKXk+WA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631127;
	b=i8ChG4X2rpZkmyZ+7dKiYZWFgvuNJfbRVLqYteb3raHe9WEqCzFEPK1gkxzrie1N9CZCgW
	98IEeam5M/JtP7BjRwU7yJkGi+dQsTU6AR8qJNXeqZOfyVpUpaIHwpTAA3VOmzEbqjwFlC
	5ea31tRdpdBwsqoKyiq0p30CW7wzfwM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PR4eStJu;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DE1E600D4;
	Mon,  2 Nov 2026 14:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FECC1F00A1B;
	Mon,  2 Nov 2026 14:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631126;
	bh=iJ84nEP4YY4K28kLfEZAA/6j0sLXVTf/aEe1LCZ8e14=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PR4eStJuCoR+mECGMaIVXtQASozW+a7AOmyTO4iG4xy4nIzb4PWW2BKxvYmoNRuHs
	 x2Lm2Rfp+v90UcW719VC0BYV4O8DTyukQ9z+uecUIg7pY28G7drnWgQgVWiNUS+/ck
	 xxhSirH9ZyCaYNU7/1qRcYlti7eFvPDGGsReRJYcEPKXsJ5iSGH7SZJURK2R0hC4aT
	 hXX/7O0Tf8cPki+pg2H6SZ7pXnNxkptKTlJYs8cIZrx/PHwXHyzeBPMp/y/AzKyvOE
	 N8mqzLmWmEBFNIMmXqg5H4OevB0bDwM2UM7fMf6GDHFGBq7FkN5sBI9EBYQrhUrLbY
	 N6tJxPjUYmLBA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:48 +0100
Subject: [PATCH RFC 08/16] selftests/proc: check that a faulting reader
 doesn't hold up removal
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-8-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
In-Reply-To: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3D37140003
X-Stat-Signature: edr34q4xmbcui9634j6ca31z58e16afe
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631127-736733
X-HE-Meta: U2FsdGVkX1/VHUoV4VQIxylkRvWimFFV8RxuwslIEz+Jj8xZXSOusRkC7OQVN7zfXA/0ShUKrOAvb98koHz6nhNFyYcgA+xZpnHg2Rlp0EeTSxhMYQwSOInOzJ4b6gZ+j4FQsXL0zyt9+BBEIHHpmdtei3/Y6wgUfmF0jqQj5roinsTBkKFlG15ogwtblXgnISXxd6godc0EZ0P/CLNhQqXVcfjlOXYUpNfl3lhNFE8Z/ESe+5NoITYd4YZRCRgOomS3PGlDHcGUkEFQoSpaUB3ejN3lu6h0Cx9oiVgnYwDy+njPjv8OD/6aVdcLWujG7dtWCpTbUyzcPQpT91XOLrc3LuUyOOPWn9O1nncscE8rP+IHy8c35KIsmpuWW7FHt2YR4OfWf6Pxo0Ghgx3kpktGvvz+b5i8o4aOe7VrLK8SXQhevD8WLVR8Kw3xPRcQW3Y0MFDKec7yy1wWeCf1nJU7K8aOM13D+IXUNU0Ekkxr5c6I+TPZh7StFXGbMgq8pI37areqbF4qHGW2fkcBKtD96XojfQWQ0Oer1/inqFPbj6HYaf4fyfXto8TX0t9/6zXd/o/SxdIhk2mhxTIz+Y7qe2SkTB+qPpXyPWwcREAiurlP8fuzFPk86QSRyo/aaItlFjcZ0W4KDom4PV0L5PouAb4DrYZqnk0a3rXcV4+DvplRkkuAEdNMX/nMGZsrK1s2IrbNaVWYeCpSeLuieFkyFpbgVg69/O/a0HfGHCUazoNL0gQlDS0fDWZz+bAjYaWQkWhb0NSqv7zFmcndz7GdwyuLxH7501lRzOtOQ02emz4JQZlkYYCaaBi31FaY0ZBeO1WMmkfjvci7sfNDxFMbvDpKvy47ok08lC231OgDdFkHwf5eZPafvjcobdF7B0H+GXNYq4dUSmZJ8a6gdnDJvejXyK9S/aSZmTnYXigRthgF2LnYLReuYEjkdX7/vMO6f8J1GinzrcFmo9O
 eXmff4ax
 b8yzd++l9TpzB1KHHhGL+kCMM9FMW9GJbzKHjFwek9DNKRJysKsLp1b736Hw79X3zGNimLqdYKkEM62FQCRvMSRxqFFhh0vr0Q2KYpAczShx25jPj6yaqFLNnjZg3YJ2FJI/++0kUIAioLOaiRJLC/yvn7te00FCV1CyT+y59e5vy4hwjItcdBaizQtdQdysoBNZ+AmcGvrJANKpsaZkKDxGtg6hC5R3Dyny9zE89r2BKjmqV2Xt/jQkmAAfywaIwFVwYE50kEeAZvv/yGS4JgNynxl+HJcf3hQt1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Read /proc/net/dev_snmp6/<dev> of a tun device into a buffer whose first
page is backed by userfaultfd and remove the device while the reader
sleeps in its copy to userspace:

- removing the entry doesn't wait for the reader

- the reader still gets what was printed before the removal

- and the next read fails with -EIO

The entry is removed under RTNL, so a regression stalls the test for
five seconds before it fails.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/proc/proc-remove-slow-reader.c       | 133 +++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/tools/testing/selftests/proc/proc-remove-slow-reader.c b/tools/testing/selftests/proc/proc-remove-slow-reader.c
new file mode 100644
index 000000000000..a201645beca9
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-remove-slow-reader.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A read that faults while copying to userspace must not hold up removal of
+ * the /proc entry. /proc/net/dev_snmp6/<dev> of a tun device is removed under
+ * RTNL when the device's file is closed.
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
+#define SNMP6_PATH	"/proc/net/dev_snmp6/" TUN_NAME
+#define READ_PAGES	16
+#define TIMEOUT_MS	5000
+
+struct reader {
+	int fd;
+	char *buf;
+	size_t len;
+	ssize_t ret;
+};
+
+struct closer {
+	int tun;
+	int done;
+};
+
+static void *read_thread(void *arg)
+{
+	struct reader *r = arg;
+
+	r->ret = read(r->fd, r->buf, r->len);
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
+TEST(remove_while_reader_faults)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = {};
+	struct uffdio_zeropage zero = {};
+	long psz = sysconf(_SC_PAGESIZE);
+	struct ifreq ifr = {};
+	struct reader r = {};
+	struct closer c = {};
+	struct uffd_msg msg;
+	struct pollfd pfd;
+	pthread_t rt, ct;
+	int uffd, done[2];
+	char *buf;
+
+	if (unshare(CLONE_NEWNET))
+		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
+
+	c.tun = open("/dev/net/tun", O_RDWR | O_CLOEXEC);
+	if (c.tun < 0)
+		SKIP(return, "/dev/net/tun: %s", strerror(errno));
+	strncpy(ifr.ifr_name, TUN_NAME, IFNAMSIZ - 1);
+	ifr.ifr_flags = IFF_TUN | IFF_NO_PI;
+	ASSERT_EQ(ioctl(c.tun, TUNSETIFF, &ifr), 0);
+
+	r.fd = open(SNMP6_PATH, O_RDONLY | O_CLOEXEC);
+	if (r.fd < 0)
+		SKIP(return, SNMP6_PATH ": %s", strerror(errno));
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0)
+		SKIP(return, "userfaultfd: %s", strerror(errno));
+	ASSERT_EQ(ioctl(uffd, UFFDIO_API, &api), 0);
+
+	/* Only the first page of the buffer goes through userfaultfd. */
+	buf = mmap(NULL, READ_PAGES * psz, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(buf, MAP_FAILED);
+	reg.range.start = (unsigned long)buf;
+	reg.range.len = psz;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	ASSERT_EQ(ioctl(uffd, UFFDIO_REGISTER, &reg), 0);
+
+	r.buf = buf;
+	r.len = READ_PAGES * psz;
+	ASSERT_EQ(pthread_create(&rt, NULL, read_thread, &r), 0);
+
+	/* The reader now sleeps in its copy to userspace. */
+	pfd = (struct pollfd){ .fd = uffd, .events = POLLIN };
+	ASSERT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1);
+	ASSERT_EQ(read(uffd, &msg, sizeof(msg)), sizeof(msg));
+	ASSERT_EQ(msg.event, UFFD_EVENT_PAGEFAULT);
+
+	/* Closing the device removes the file that is being read. */
+	ASSERT_EQ(pipe2(done, O_CLOEXEC), 0);
+	c.done = done[1];
+	ASSERT_EQ(pthread_create(&ct, NULL, close_thread, &c), 0);
+	pfd = (struct pollfd){ .fd = done[0], .events = POLLIN };
+	EXPECT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1) {
+		TH_LOG("removing " SNMP6_PATH " waited for the reader");
+	}
+
+	zero.range.start = (unsigned long)buf;
+	zero.range.len = psz;
+	ASSERT_EQ(ioctl(uffd, UFFDIO_ZEROPAGE, &zero), 0);
+	ASSERT_EQ(pthread_join(rt, NULL), 0);
+	ASSERT_EQ(pthread_join(ct, NULL), 0);
+
+	/* What was printed before the removal still arrives, then nothing. */
+	EXPECT_GT(r.ret, 0);
+	EXPECT_EQ(read(r.fd, buf, psz), -1);
+	EXPECT_EQ(errno, EIO);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


