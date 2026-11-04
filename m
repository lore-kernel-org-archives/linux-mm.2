Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052FE606D14C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iC5qhYuC
Received: by kanga.kvack.org (Postfix)
	id 2F5146B05CC; Wed,  4 Nov 2026 14:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5B26B05D3; Wed,  4 Nov 2026 14:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F266B05DA; Wed,  4 Nov 2026 14:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDFE06B05CC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:32:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C18D1C3EAD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:32:12 +0000 (UTC)
X-FDA: 85398432504.08.999D55E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D98A640003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:32:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iC5qhYuC;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8Eii8wlxK/U6i+WN38IP3N9K8zW9fYP0HNd0IGm1W0=;
	b=yDDdAygn4oO0fTGsxm16uwUJPH0Z6+Hhl/snNDBdptB+Y7KSLBOL+fwPj0Q9LS68ktDIZD
	Q1UFLUuAujLzyOGWAoKhQeRKmCkJWawwuklhZrok5Zd8X1J8SILB2wJTjiutnPzLr/LTki
	X5ow96bIsBAANlviJdsqPVdFXqpqRKM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820730;
	b=rdYvQaz2TJl/OO+S5dEwDagKOFrLd44xWofmnYitb6W6RnZAAmWLS1vpkKSAk0SQKe0DSI
	PWJNVm/O721RN3SkqqULYn7qzMyU9Fx9xYbLcBJjHO05f11V9EW6nNWjQu5IdcTbS+rQmJ
	t0iLcVNOB0BViS65rIOwySFtTdLRst4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iC5qhYuC;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CBFB60D9A;
	Wed,  4 Nov 2026 19:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4421F000C1;
	Wed,  4 Nov 2026 19:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820730;
	bh=a8Eii8wlxK/U6i+WN38IP3N9K8zW9fYP0HNd0IGm1W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iC5qhYuCRstV+TUqjEu0rWRbTttDUR0KoUFR/Nic2bFwF64VuSt1WDgXx4WbU4Et4
	 ZNlRYe+G0MHmA1/II6uBNZBPp9Wvcvb5bBVfPJtilV3/K8lP+xGqSdbaN6ECrO9DpW
	 du+eed3fzzQNoHO1No/AbIPvxNJkxVZOJdAGHIz/EgNENL5daivIVmmxtCp9lM8GEv
	 tRA4UQbju+ehP2qFzuoGBNUaSD6Jp1yqYS1bSnF83Bb3YxwerAD9vI0v1JOGv4u38c
	 FoRp/hBAQUDPq4wTOJ5N0tlVFGudcN+g6w+AJBph58Jc+dvlqzJ6WxnPYKNN9XQMYu
	 THb00UuOGzJdA==
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
Subject: [PATCH RESEND v2 11/23] selftests/proc: check that a faulting reader doesn't hold up removal
Date: Wed,  4 Nov 2026 20:31:56 +0100
Message-ID: <20261104-work-procfs-core-v2-11-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5703; i=brauner@kernel.org; h=from:subject:message-id; bh=XyuYjQOPhfqL05zxspI3Sf2ZwFKZLHj6jlvlh6Bj2Lk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bq97GaEjt/tSvJXDmnqfdIul4otUnkuetLcImZIuI frrsJ9sRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETcJjH8D3O/N+uiwGkGvqKb uoYJuYavRK3s+jeLapeqZFQ3hKf7Mfz3X/bwb8DUWRlpKSH5XPOF/65p/KKXLLfq9KTDH5ylnqz hBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: so39ao37h3txa9xb4uzenj3ja1k1ssfu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: D98A640003
X-Rspam-User: 
X-HE-Tag: 1793820730-191870
X-HE-Meta: U2FsdGVkX18c+JLhR0v7wGVQJtXOJua4peQtuFLHCyJnT+lVYzJzk6keHuKSt8qvAR6KjAxy7VtH+IppYQyzq5Y+BpL5rJASTte6KLZzWJ2f3duoe5dSAbEzmaSMDC3cKUvE2NM2CY1kcjeGeRPjnZ0Q4uwCiKB8HyvfOyyLyGxT9pqQn4WxpiGzt3aFfmWmI9FxP8bTsIZufb/rjhTD2KjwpXUAsjq3H+GzdPPbJvZu09JkHRnuHlLm0kv8ysLDUbVs4SurJA9iZ0FjQm1tl9q4RN2OapqK7i/8k8Oa0esnKgNYSOuuvFQ9lKplUdwsoaAIiMQYiuzFEcv5LG9WBViB1IubRXl3pd8l18/Yn+IAHP4L0fe3rTgcVlfcPxJ6lx5oRiXnTMWW081iH/VEzqjL4vyxP+tiabX2FGdi9nTl5t9VRaqy3wXU9ZojFouTpuuwgnp9/dZxOKxEikDBOqojOm26c/P/aCL6u6V9dk62xMtBkYtOL8y8ePJgYZIWKOvinXTSEIXYZ0Ns7kr1J387eHf1Im4uDNe8BrMlMAD27DKsje2KV/n6mVlCvzGrVtK5WscKVdUxqj4miyn7WrFuNWzGjBRV8dQnM050IS+yAdHL1AwD4CHMmF4r878lxsSjC0wun4vtZKIpEjKiySF53lPmACDYdB0GNcnSgx6QvV0VODtcFMXtGJyzhzB/9iXEFl+dfx6SaI5OYKswxI2wKM9xh+nFJl+mkY/Sqt0Pif/MRJ0dxthng21WBQQqS/86say0FCrfAUw1E/cuTHNF7ODJxNKs4J4ke6dcJAz0dz0qqAAsnmIg2JbOlqWr2a/usonPxsl4Wi+ukeifWy8SRwcKQiBpZAVYFceeAcf7hT36luvXhzwwPGOkZNDzxS95IByqP/h0irxoFd8tSIBjgeSYeNXdE44TOO2ydE0UqjeYudul1lwXVIydAcEzeTLKFk6i1wx2kyb1enl
 sP3CJPzT
 E9Fck2rf0DpFr/j9hOB0IeMoz+odM8asDQU6OBSe9/ehB5ZbitHcS6tIl4v57rQ3wPHHOg1ivyeBXHud6lXEjBkI0js+PH50j+mgvkVmMi8MgbAh0DwLovOnR95sbmWGnQFK7+DYdVzxJHaH23eIUlS7KV8mt9I8fDePL7KYmOChIax3Rya9leGcuxCZnSH+hnk8SuNH0mmy2Igz9Np9+Tg1txMPI6MMGo0OfbI0tYtunrwHZ/rVtUbRK3Dnq/5nyCdwpFc641XtFSJwBGPdReyOwnamtQudaG8h2
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
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 .../selftests/proc/proc-remove-slow-reader.c       | 133 +++++++++++++++++++++
 3 files changed, 135 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index 3fa89f46b9c7..e2566cc0ae07 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -22,6 +22,7 @@
 /proc-uptime-002
 /proc-pidns
 /proc-remove-slow-sysctl
+/proc-remove-slow-reader
 /proc-remove-slow-readlink
 /read
 /self
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index df02699a3587..6a9bdc999f54 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -33,6 +33,7 @@ TEST_GEN_PROGS += proc-fsconfig-hidepid
 TEST_GEN_PROGS += proc-sysctl-readdir-churn
 TEST_GEN_PROGS += proc-pidns
 TEST_GEN_PROGS += proc-remove-slow-sysctl
+TEST_GEN_PROGS += proc-remove-slow-reader
 TEST_GEN_PROGS += proc-remove-slow-readlink
 
 include ../lib.mk
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


