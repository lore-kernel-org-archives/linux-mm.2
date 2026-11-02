Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0516085576
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iCTZ0HLl
Received: by kanga.kvack.org (Postfix)
	id B89286B05FB; Mon,  2 Nov 2026 10:29:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61096B0629; Mon,  2 Nov 2026 10:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77306B062A; Mon,  2 Nov 2026 10:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 837376B05FB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:29:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2382E1C1DEC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:47 +0000 (UTC)
X-FDA: 85390564014.10.0E13DD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4629A20002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iCTZ0HLl;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633385;
	b=2gzGIumYA2MXaBqhB1KFdOJy17Kazt38/iTznWqaik/1bzwSosmTsUwX+mxA86m2/5U1Bh
	o8RxapOPx+UlLAd693uvUzY/IgGabzo3B8tJgVYeNwyBXUdrFlXnbl6eY6Bnz46gACGMU3
	47CxFzqew3XjP/10S45Z6uXMNaJKGxk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iCTZ0HLl;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmPg73ZsTa4hWS3OOTC3awBO6zvZml45J7NYZXMvC60=;
	b=TIJvN0GkwJaCeoFhQeeUq2ZDxEn6a5zkI9ni3p7/LryEf5XoqyEmTI6ZddZhmUBKa5nqkh
	onbOcx1MyzKWv1a82hXpVlwl4gGY168P/qCRH8uIJi3l4P9HJ2yPAEzvVaYo93fydC1C5e
	bgf68ddyb7Fwa/Nfn1j1t2aHCr2XOl8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0431560A55;
	Mon,  2 Nov 2026 15:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABFE1F00A16;
	Mon,  2 Nov 2026 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633383;
	bh=AmPg73ZsTa4hWS3OOTC3awBO6zvZml45J7NYZXMvC60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iCTZ0HLlYWpNnx3lzizxK8JbxxzlOIlnwN0PzIz6UY8TyRpRaYR72Sb+82Fin1P19
	 Uq89Sc4uR18wsPrD2qwZSSQbzB+QEEeZcU53jf0zSz5eUKXBjmK4CUBUbNj4BpKSiH
	 g1PfN1jUZKiW6zZ8IInfRG7plrh6BEL3vcjVxlzZSt4sfyNEOX+5HxH2pnDkByJ3iH
	 zi3R2HChW+GDD79p3OJETo/fMAQjBeGqh0tgmAviJY9oTgndZHpyisDmAZcnyucmRF
	 uqCOqicTKRLLVz6FAZmLIgCKbKzLivVkwBn/DT+cTH5rQKoiFnoIZfwVSbluahwRKT
	 gCOgTGaDF9XdA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:37 +0100
Subject: [PATCH RFC 27/27] selftests/proc: check that unloading configs
 doesn't wait for a reader
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-27-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6916; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oFCHsIIvTBz60E+Ak0mDBpMOymOH24bqy12BEzEjHtQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG5s9+n5iyVpzR1+S1Yv2LQn7sbvgAOy518pHj6k/
 3vVix0NlzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAmcjSIkeHy7QVrGFL87r7Z
 tTqn+l/utQKPCLlWdkbG2laOBQomEjcZGVq/pl+KCxWY775aK+r5+1f3Oh3yl/oJunu1PFcu1PK
 OYQQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 4629A20002
X-Stat-Signature: r8ajx6zzo84x4b4hkwm7p6g7ohfwxc4i
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633385-836359
X-HE-Meta: U2FsdGVkX1+EEpkyt3kc9+crD1kwXazlX5mn4icGTMQTeq4r7TNGu2Ednn47mLHTmlzqyHbR2kBPsizc6OnYwwg3mKDVLVxKUrJ+gPljt7gW5zrfvYOHzUKzLNeaGqUNj9xq6Y8Ad4/+ZWFaJXK+0A8ar3Mslsu0x+IiVmi59pxDVFgnrc4NHGJtpb2LETsSLjC+dpd41nHvCuT8DAlB1lHupf5DNeK+Hyr3w+j6DR6t2TC6DwRER6sKOE0VlLXCczE6VGZyYRYNcQl0qwn8p7jl3oRwK1nOt7gzG5LdaHJx9Nkv0fkuzY+eslv9oMM+pyDKc7SlQts91QTchVv2K2wmUXBkl9AIW2ozSmq1suQAojQEjpTaYnxXNBSwE/2AOcp8r+t6OIqUxbS26YhRUU7b7chi4ZkfoF4lbyGHHWeIkI1PwCogMrgHdoeJ9G5EibzxNXshrhMuU57lESuVlsx5dj3ZCFuK/a4mP73WZnAuN6hdtxGU8YUGl+6mfkSenPZraz0MBbiAl4kx9egVDeJY7QnL4nZu+tmn8BgupPp6+MsMimtNP2YwJc/FuRxD91R4LhI1m62N7FqkT9xOIT1jn7NWE15papXKQ/JjiIzp544BNULLMaznkOx41RkrSUQ71VDHIRnFvWMLLMWjHtFGjNOOqQBOL1njIzC58LQO/FvQw4dwM/ZFs6i9zOPTXE73o/Y3hmmkg8sbAOYtx7ljP+iq8G9AqKvd5i1qvnDhWqhANO+9cZS8zLnmCKwj3mDGKltLddLUHXYAqHwAZwzJKitNDmatrOdNfpd8sRcmDNlrhhq+ZT4M1YiftzADiZ7vOoqu/9fhsTskE5MS+Njp1jlBPappcYUAuegec3VAV3Zo9xX1c96Ed0d44wchTzSvXY+AaKMUjycwg8OSA4Tel4vB5ujdeKImHauQpbAcjv06bJavFFvkDcKflLnUBrnFVsl+GOFdfEpI8y6
 RqJhriMY
 yHZkG6ebS87Mw14dlFNLTy8bzmP/LHWZrqKCVa7ERg3WyfdgicUghjqMH2bh9P5ksCL6wkpEyWwEYnJPX5V4hB7Rh1MeLdk9dgIOwLvlLaLQ+MW3i4+7lI9VPeugZuIV18MXPMnCbuQ+KIoHA5+9VF+8T4gosGLflYtvx89kk0bjbadXR7ScHoeD6lQ7IySp3/H6FUTxRn0Y4eS0ijYLPCvaX0hf8I5oOllBv0AyIgY6fSVWwxIxW7CRn1ZXWGUZeUVUFK0A6jXtCNoEkrtJNl1Gi9AswDcqd5mUH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Read /proc/config.gz into a buffer whose first page is backed by
userfaultfd and unload configs.ko while procfs copies what was read to
userspace:

- removing the entry doesn't wait for the reader

- the reader still gets the page that was read before the removal, and
  nothing more

- and the next read fails with -EIO

The test loads configs.ko if it isn't there, skips if configs is built
in or can't be unloaded, and loads it again afterwards. It needs
CONFIG_IKCONFIG=m. kselftest-merge keeps the =y that other fragments
ask for, so it skips there.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 tools/testing/selftests/proc/config                |   4 +
 .../proc/proc-remove-slow-config-reader.c          | 157 +++++++++++++++++++++
 4 files changed, 163 insertions(+)

diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/selftests/proc/.gitignore
index 51969f81afc5..ed3f28652bb7 100644
--- a/tools/testing/selftests/proc/.gitignore
+++ b/tools/testing/selftests/proc/.gitignore
@@ -25,6 +25,7 @@
 /proc-remove-slow-reader
 /proc-remove-slow-readlink
 /proc-remove-slow-writer
+/proc-remove-slow-config-reader
 /read
 /self
 /setns-dcache
diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selftests/proc/Makefile
index aecec6b93173..adbb4b1e9e9e 100644
--- a/tools/testing/selftests/proc/Makefile
+++ b/tools/testing/selftests/proc/Makefile
@@ -36,5 +36,6 @@ TEST_GEN_PROGS += proc-remove-slow-sysctl
 TEST_GEN_PROGS += proc-remove-slow-reader
 TEST_GEN_PROGS += proc-remove-slow-readlink
 TEST_GEN_PROGS += proc-remove-slow-writer
+TEST_GEN_PROGS += proc-remove-slow-config-reader
 
 include ../lib.mk
diff --git a/tools/testing/selftests/proc/config b/tools/testing/selftests/proc/config
index c7c61a2d7927..8f672a8b49a8 100644
--- a/tools/testing/selftests/proc/config
+++ b/tools/testing/selftests/proc/config
@@ -8,3 +8,7 @@ CONFIG_SND_DUMMY=m
 CONFIG_SCSI=y
 CONFIG_SCSI_PROC_FS=y
 CONFIG_SCSI_DEBUG=m
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_IKCONFIG=m
+CONFIG_IKCONFIG_PROC=y
diff --git a/tools/testing/selftests/proc/proc-remove-slow-config-reader.c b/tools/testing/selftests/proc/proc-remove-slow-config-reader.c
new file mode 100644
index 000000000000..5f7bcb27b315
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-remove-slow-config-reader.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A read that faults while procfs copies it to userspace must not hold up
+ * removal of the /proc entry. Unloading configs.ko removes /proc/config.gz,
+ * which isn't a seq_file.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
+#include <pthread.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#define CONFIG_PATH	"/proc/config.gz"
+#define CONFIG_MODULE	"/sys/module/configs"
+#define READ_PAGES	2
+#define TIMEOUT_MS	5000
+
+struct reader {
+	int fd;
+	char *buf;
+	size_t len;
+	ssize_t ret;
+};
+
+struct unloader {
+	int done;
+	int ret;
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
+static void *unload_thread(void *arg)
+{
+	struct unloader *u = arg;
+	ssize_t ret;
+
+	u->ret = syscall(__NR_delete_module, "configs", O_NONBLOCK) ? -errno : 0;
+	ret = write(u->done, "x", 1);
+	return (void *)ret;
+}
+
+FIXTURE(configs) {
+	bool loaded;
+};
+
+FIXTURE_SETUP(configs)
+{
+	self->loaded = false;
+	if (access(CONFIG_PATH, R_OK) && system("modprobe -q configs"))
+		SKIP(return, "no " CONFIG_PATH);
+	if (access(CONFIG_PATH, R_OK))
+		SKIP(return, CONFIG_PATH ": %s", strerror(errno));
+	if (access(CONFIG_MODULE, F_OK))
+		SKIP(return, "configs isn't a module");
+	self->loaded = true;
+}
+
+FIXTURE_TEARDOWN(configs)
+{
+	/* an ASSERT may have fired with the module unloaded */
+	if (self->loaded && access(CONFIG_PATH, F_OK) &&
+	    system("modprobe -q configs"))
+		TH_LOG("couldn't load configs again");
+}
+
+TEST_F(configs, remove_while_reader_faults)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = {};
+	struct uffdio_zeropage zero = {};
+	long psz = sysconf(_SC_PAGESIZE);
+	struct unloader u = {};
+	struct reader r = {};
+	struct uffd_msg msg;
+	struct pollfd pfd;
+	pthread_t rt, ut;
+	int uffd, done[2];
+	char *buf, *ref;
+	ssize_t ref_len;
+
+	r.fd = open(CONFIG_PATH, O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(r.fd, 0);
+
+	/* what the first page of a read looks like */
+	ref = malloc(psz);
+	ASSERT_NE(ref, NULL);
+	ref_len = pread(r.fd, ref, psz, 0);
+	ASSERT_GT(ref_len, 0);
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
+	/* The reader now sleeps in the copy to userspace. */
+	pfd = (struct pollfd){ .fd = uffd, .events = POLLIN };
+	ASSERT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1);
+	ASSERT_EQ(read(uffd, &msg, sizeof(msg)), sizeof(msg));
+	ASSERT_EQ(msg.event, UFFD_EVENT_PAGEFAULT);
+
+	/* Unloading configs.ko removes the file that is being read. */
+	ASSERT_EQ(pipe2(done, O_CLOEXEC), 0);
+	u.done = done[1];
+	ASSERT_EQ(pthread_create(&ut, NULL, unload_thread, &u), 0);
+	pfd = (struct pollfd){ .fd = done[0], .events = POLLIN };
+	EXPECT_EQ(poll(&pfd, 1, TIMEOUT_MS), 1) {
+		TH_LOG("removing " CONFIG_PATH " waited for the reader");
+	}
+
+	zero.range.start = (unsigned long)buf;
+	zero.range.len = psz;
+	ASSERT_EQ(ioctl(uffd, UFFDIO_ZEROPAGE, &zero), 0);
+	ASSERT_EQ(pthread_join(rt, NULL), 0);
+	ASSERT_EQ(pthread_join(ut, NULL), 0);
+	if (u.ret)
+		SKIP(return, "unloading configs: %s", strerror(-u.ret));
+
+	/*
+	 * The page that was read before the removal still arrives and the
+	 * next piece isn't filled anymore, then nothing.
+	 */
+	EXPECT_EQ(r.ret, ref_len);
+	EXPECT_EQ(memcmp(buf, ref, ref_len), 0);
+	EXPECT_EQ(read(r.fd, buf, psz), -1);
+	EXPECT_EQ(errno, EIO);
+	free(ref);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


