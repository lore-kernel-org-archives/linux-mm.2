Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C1DEC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104096B00A0; Tue, 28 Jul 2026 08:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC2E6B00A4; Tue, 28 Jul 2026 08:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33936B00A5; Tue, 28 Jul 2026 08:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B31BA6B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:26:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 359D2120377
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:26:50 +0000 (UTC)
X-FDA: 85038109380.24.38CCA74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C52220009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:26:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkwjnDmS;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785241608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vt+CJvPgKyczXyAdtoV88qBhp4afcyiatTku0ZwlgLA=;
	b=WcUtGBZBjx8SPYuO2iqtGDgFNt6r1XPvLtRGG6riNUx/+0BzcYUP/sALvvd92ZLpz+Ki8J
	T1GfW6tDiU+P882OXRYFT7rGd/VEVU+EN8/yiuE1rpcmtnFViM8Dcj2IGhj7mGYAqcb3w9
	8QbmFUkdT1hdvjEsg51haWpyv1Yeq/c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkwjnDmS;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785241608;
	b=lDSmmIEkwYTSBIpvFiHqvAmnXePiU4tMgRnXiC00GY51bAbrgb+ztygNoiZxihJwmgoaAH
	+pajuO/Pa4W23LIWiO1N2GMwbSAuhD7c53bq+X201qvHLYG14gf7cQ39+nsCmjoSgxh75z
	Gck2BoAXdj1Qr+ZheE9Nw89UqO5RvpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFCF460A9E;
	Tue, 28 Jul 2026 12:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CB51F000E9;
	Tue, 28 Jul 2026 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241607;
	bh=vt+CJvPgKyczXyAdtoV88qBhp4afcyiatTku0ZwlgLA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RkwjnDmS64pm/DmPqFCIfCwnQdHdazM/1/l2XmCdXFlJ3GXdmOTjev4t3PRrex56N
	 zYYW2z5f3s4cK6w68uhCmpBC0TVyoWbbCmoScpcSzTe1dcJvt9QzOPKsljwx+LvT1S
	 U9cRFXaNi3zkrrzQuojn2k+93bF18+ES/QjiPvNeN+UvhFbQLRxdWXADGb6aYZt90p
	 j1EUWnYe3iMRWeSj8lhGWGjA2TggoeKZyTuJkIJOYCx6K+EHi4lQjORjySrTMmw8jN
	 6jFD59IFqxu/Ti4XqDmcN0ixxxDH6+ME38K2CziAJbq3xdhmrTJZmtz38bZ6pyS+pM
	 ngI/uOID+H7VQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 28 Jul 2026 14:26:33 +0200
Subject: [PATCH 2/2] selftests/exec: check that a binfmt_misc instance
 cannot be pinned
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-work-binfmt_misc-selfpin-v1-2-74df5daeca5b@kernel.org>
References: <20260728-work-binfmt_misc-selfpin-v1-0-74df5daeca5b@kernel.org>
In-Reply-To: <20260728-work-binfmt_misc-selfpin-v1-0-74df5daeca5b@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 bpf@vger.kernel.org, jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-cca4b
X-Developer-Signature: v=1; a=openpgp-sha256; l=7434; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CmftR+Uc2FulAhzpeWNRVyNZ624y2VtvgpyJWGwwBlM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlzP8XHbF14qzo2Nuvn/toXA25t9lG7uHS9ikdxU/t9
 tw6e1hnfkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEZlxjZLh4h8Vgw62WGfJ3
 OlqEg+aZFajXOk/YKZ9nGt+3a9mez3KMDFt6V5gYzt+9Pl/9NOO7/5vus7Cm+es9U596f0HT0kX
 ySTwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C52220009
X-Stat-Signature: 8cnq6dzqp6n9jfcpiwkfbwer163zcyir
X-HE-Tag: 1785241608-240324
X-HE-Meta: U2FsdGVkX19kO+w+LXUwIBRYwDdMtHa9YsEOOLeOOgMKDx6ndr3Gdbd0JBNNQB3aoFtc1+XAoF4Tt+JdWZ+DRQ1xRRDCPiqjzS68RlkVbkU19w+OYf1ckopynd7ZJ4G1jg9t/iyKKCj6Vv3oYSRVJuRYzeSTmegHXrtX7g1Cdj3/s6t9Y5wxLVH1r3jf9bt47X8pleYRBQlHO4gN44LtD2l8S3R1YSPm6iBpGTYiR/huVn+IMNtWL+0iAsVXUS6ZVGtNoQo4kG17bVTyRpnT4xsXyDskSEyT9QcoFVQbsVKIqESKIwCoosCr1WQ09q3ZSeOFGFsDrbhL8WrR1rqOkU5bm06/8WJriIKZdd5H6tPfc29VSmrEel+ocVV7TBTwKSE336u8wfrMOZmVzy29xywT+8GJI1CRLdNsgTq3h5PkD+P/SQU7Q4f/NRnCBIXMt9erx+Nr17wuzC1rumHUQhi+W+4/HOz5flGMo/SUddziHRn9NRM1bYnaqwwUS2dRkHVTl/mn22qxOer2Y/Uzz2hyn8heSYhxMgcwLIEFWUOK7iMBTdPymPSuzYIF6xCVatm6lrqwLJ6wSlnj0yizpnQZUGWO6iCpvu2nGJTvbUeKCdwaB4V897VWF2WKtu3qu+8MWTqArCuXF0qf0pBJnQhD4/OONMsEE68fh403ejsab7HhXT/1+MUfED4DFYoFQ4b6WBOP6nmI3URFhfNS6/PEEOIV5O9muVaKTX7eF6usl2l8HhFbaYNqHTiZuCI5v64xZHD+/zPdTNBDfnapjdYbysiZY9m9PgBwCq4Z+D7hEQE9d4dQA9W37t3kFkO1D9YfH86xW4UXtSO2p6h8OvqhSoel/+nbIV35aMqMU3ykJ1ZA0zvpoq6aWp+kTzm2rhxNzRarkrOljzSlXoJqFNWzclOgnBgDYz2NeQyvV4ke2p4weJfuvIGZQEyKGpcevdSd2j/I8uf9VHvJhkc
 IAX+Gvys
 Mpht+nmtYO7dhAMsCkLhE59YkHRwW446foKRimuJ435TnSLuFDMQErYNnPIP8KYo40V9hKdhur8q/RhFyHyS8b4ga5lWcexJZbFK8jAdkGUG84Q7KRzPvpA63zwF+F6AloPzmmDhn1V49yPDQLYriXSZm2tCB0jMurcYnE7vDnRvgIgrIDattsy5c2AtocBubAjCjrbtjxns8+rasrIuzCfiJPcMIHRXdrn63lPrCNB/MXdCIX5bPQgP/BG/82upJQRLMmTbJLAJNxbGfKyMcT9pI8ONByOCpBP8UaBFwa7z2u5mt9j4XXky065RQ7BKt+XOnKSLUVWzlwViLH2rhAO0QGSMrD80JTqYOfMM2wfjv0xM0K44UHcgfUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An 'F' entry whose interpreter keeps the binfmt_misc superblock alive
pins the instance that owns it forever. Cover both ways to build that:

- an interpreter on the instance's own files, control file and entry
  file alike

- and an instance used as an overlayfs lower layer.

Check that an ordinary 'F' registration still succeeds so the fix stays
honest about not changing what 'F' promises.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/Makefile              |  10 ++
 tools/testing/selftests/exec/binfmt_misc_selfpin.c | 158 +++++++++++++++++++++
 tools/testing/selftests/exec/config                |   4 +
 3 files changed, 172 insertions(+)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 45a3cfc435cf..b15505f5e0bc 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -21,6 +21,10 @@ TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
 
+# binfmt_misc must not be reachable as an exec source or as a stacking layer,
+# or an 'F' entry can pin the instance that owns it. Unprivileged, no bpf.
+TEST_GEN_PROGS += binfmt_misc_selfpin
+
 EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\
 	       $(OUTPUT)/S_I*.test
 
@@ -55,3 +59,9 @@ $(OUTPUT)/script-exec.inc: $(CHECK_EXEC_SAMPLES)/script-exec.inc
 	cp $< $@
 $(OUTPUT)/script-noexec.inc: $(CHECK_EXEC_SAMPLES)/script-noexec.inc
 	cp $< $@
+
+# Reuses setup_userns()/write_file() from the filesystems selftests. Their
+# wrappers.h wants the uapi headers, so ask for them here rather than widening
+# CFLAGS for every program in this directory.
+$(OUTPUT)/binfmt_misc_selfpin: CFLAGS += $(TOOLS_INCLUDES)
+$(OUTPUT)/binfmt_misc_selfpin: ../filesystems/utils.c
diff --git a/tools/testing/selftests/exec/binfmt_misc_selfpin.c b/tools/testing/selftests/exec/binfmt_misc_selfpin.c
new file mode 100644
index 000000000000..5286b0604eed
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_misc_selfpin.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * An 'F' entry keeps its interpreter open for as long as the entry exists,
+ * and the entry only goes away when the binfmt_misc superblock is destroyed.
+ * An interpreter that lives on a mount which in turn keeps that superblock
+ * alive therefore pins the instance that owns it, and nothing can break the
+ * cycle. Check the two ways userspace could arrange for that: an interpreter
+ * on the binfmt_misc instance itself, and one on a filesystem stacked on it.
+ *
+ * Runs unprivileged in a user namespace; binfmt_misc is FS_USERNS_MOUNT.
+ */
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <limits.h>
+#include <sched.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+
+#include "../filesystems/utils.h"
+#include "kselftest_harness.h"
+
+#define MNT		"/tmp/binfmt_selfpin"
+#define BACKING		"/tmp/binfmt_selfpin_back"
+#define LOWER		BACKING "/lower"
+#define MERGED		"/tmp/binfmt_selfpin_merged"
+
+#define MAGIC		"\\xde\\xad"
+#define RULE(interp)	":selfpin:M::" MAGIC "::" interp ":F"
+/* Not on the instance, and unlike /bin/true it always exists. */
+#define INTERP		"/proc/self/exe"
+
+#define OPTS_MAX	(3 * PATH_MAX + 64)
+
+static int ensure_dir(const char *path)
+{
+	if (mkdir(path, 0755) && errno != EEXIST)
+		return -1;
+	return 0;
+}
+
+/* Write @rule to this instance's register file, preserving write(2)'s errno. */
+static int register_at(struct __test_metadata *_metadata, const char *rule)
+{
+	int fd, saved;
+	ssize_t n;
+
+	fd = open(MNT "/register", O_WRONLY);
+	ASSERT_GE(fd, 0);
+	n = write(fd, rule, strlen(rule));
+	saved = errno;
+	close(fd);
+	errno = saved;
+	return n < 0 ? -1 : 0;
+}
+
+/*
+ * Mount an overlay over @lower using a private upper/work pair, so the two
+ * mounts this test performs cannot interfere with each other and neither
+ * overlaps the lower layer.
+ */
+static int mount_overlay(const char *lower, int nr)
+{
+	char opts[OPTS_MAX], upper[PATH_MAX], work[PATH_MAX];
+
+	snprintf(upper, sizeof(upper), "%s/upper%d", BACKING, nr);
+	snprintf(work, sizeof(work), "%s/work%d", BACKING, nr);
+	if (mkdir(upper, 0755) || mkdir(work, 0755))
+		return -1;
+
+	snprintf(opts, sizeof(opts), "lowerdir=%s,upperdir=%s,workdir=%s",
+		 lower, upper, work);
+	return mount("ovl", MERGED, "overlay", 0, opts);
+}
+
+FIXTURE(selfpin) {
+};
+
+FIXTURE_SETUP(selfpin)
+{
+	/* setup_userns() exits rather than returns if this is not there. */
+	if (access("/proc/self/ns/user", F_OK))
+		SKIP(return, "kernel without user namespaces");
+	ASSERT_EQ(setup_userns(), 0);
+
+	ASSERT_EQ(ensure_dir(MNT), 0);
+	if (mount("binfmt_misc", MNT, "binfmt_misc", 0, NULL)) {
+		int saved = errno;
+
+		/* Teardown doesn't run when setup skips, so clean up here. */
+		rmdir(MNT);
+		SKIP(return, "no binfmt_misc: %s", strerror(saved));
+	}
+}
+
+FIXTURE_TEARDOWN(selfpin)
+{
+	/* The namespaces go with the process; just don't litter /tmp. */
+	umount2(MERGED, MNT_DETACH);
+	umount2(BACKING, MNT_DETACH);
+	umount2(MNT, MNT_DETACH);
+	rmdir(MERGED);
+	rmdir(BACKING);
+	rmdir(MNT);
+}
+
+/*
+ * The instance's own files are regular files the mounter owns, so they can be
+ * made executable. Opening one for exec still has to fail, otherwise the entry
+ * pins the very superblock it lives in.
+ */
+TEST_F(selfpin, interpreter_on_the_instance)
+{
+	ASSERT_EQ(chmod(MNT "/status", 0755), 0);
+
+	ASSERT_NE(register_at(_metadata, RULE(MNT "/status")), 0);
+	EXPECT_EQ(errno, EACCES);
+}
+
+/* Same for an entry file rather than one of the control files. */
+TEST_F(selfpin, interpreter_on_an_entry)
+{
+	ASSERT_EQ(register_at(_metadata, ":victim:M::" MAGIC "::" INTERP ":"), 0);
+	ASSERT_EQ(chmod(MNT "/victim", 0755), 0);
+
+	ASSERT_NE(register_at(_metadata, RULE(MNT "/victim")), 0);
+	EXPECT_EQ(errno, EACCES);
+}
+
+/*
+ * A stacking filesystem holds a private clone of each layer for its whole
+ * lifetime, so an instance used as a layer can be pinned by an interpreter
+ * that does not live on it at all. Refuse to be a layer.
+ */
+TEST_F(selfpin, refuses_to_be_stacked_on)
+{
+	ASSERT_EQ(ensure_dir(BACKING), 0);
+	ASSERT_EQ(mount("tmpfs", BACKING, "tmpfs", 0, NULL), 0);
+	ASSERT_EQ(mkdir(LOWER, 0755), 0);
+	ASSERT_EQ(ensure_dir(MERGED), 0);
+
+	/* Nothing to prove unless overlayfs works here at all. */
+	if (mount_overlay(LOWER, 1)) {
+		if (errno == ENODEV || errno == EPERM)
+			SKIP(return, "no unprivileged overlayfs");
+		SKIP(return, "overlayfs unusable here: %s", strerror(errno));
+	}
+	ASSERT_EQ(umount(MERGED), 0);
+
+	EXPECT_NE(mount_overlay(MNT, 2), 0);
+}
+
+/* An ordinary interpreter still registers with 'F'. */
+TEST_F(selfpin, ordinary_interpreter_still_works)
+{
+	EXPECT_EQ(register_at(_metadata, RULE(INTERP)), 0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/exec/config b/tools/testing/selftests/exec/config
index c308079867b3..c03d52d8abee 100644
--- a/tools/testing/selftests/exec/config
+++ b/tools/testing/selftests/exec/config
@@ -1,2 +1,6 @@
 CONFIG_BLK_DEV=y
 CONFIG_BLK_DEV_LOOP=y
+CONFIG_BINFMT_MISC=y
+CONFIG_OVERLAY_FS=y
+CONFIG_TMPFS=y
+CONFIG_USER_NS=y

-- 
2.53.0


