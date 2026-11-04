Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAFCC607030B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fZMD0huu
Received: by kanga.kvack.org (Postfix)
	id CAF6B6B05C4; Wed,  4 Nov 2026 14:27:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86FD6B05D1; Wed,  4 Nov 2026 14:27:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B766D6B05DF; Wed,  4 Nov 2026 14:27:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D98C6B05C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:27:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BDA580850
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:27:17 +0000 (UTC)
X-FDA: 85398420114.16.9215210
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68B51180007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:27:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZMD0huu;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820435;
	b=LMvgOC+XqkE3FfZMSj6+9WuJQSRMuzS0qJTgsELi6/mnnhiFqPHmaU64bkjus4aiPeJZ6T
	4i0AN97B+AEmm23+qSuiBX3abHeOLfdZVD+AMXToEQrmrJvRXQ1RGdkC7uP7ijmkmXQsoT
	ehK0QTuAq9ZKLPqvsyjrB1bX8EXjBY0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fZMD0huu;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5+oZHp7BRrXwItSZJfGO9IDNpMhGDSeaixBJWzgZo8=;
	b=OWeLYNz76kUgO0FJWYyjENbhdrZVUjaUrbcdMZT1HyTEr2tIzUPY9hapkJT15vbSE+IhdW
	04TjTaGTX7k1BcxMWcDcHtJfZB24zT+lNBufa/oTzOeD2X7W0cDTvr+S2eOgCLgQ12GWz8
	msznKdA+cHqUfj6K+cIGfqtpKONP62I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1EE160D97;
	Wed,  4 Nov 2026 19:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AAB1F00A02;
	Wed,  4 Nov 2026 19:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820434;
	bh=r5+oZHp7BRrXwItSZJfGO9IDNpMhGDSeaixBJWzgZo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZMD0huuUQp5LSr9n7+L0WCkQqKPzyWmpwqfqg+XzsqNRlIuKtlf3Iar8GeYyXaoh
	 Duy1KTIkLZPd4wpyWSeEROyKAch5aD1WchnGy/bdzHJBKTDW5fUbZVdDqnccb3ML1S
	 ynk82YbCOwpdp9OfHLn4Hk4TAslcNPy+3iNGpY8Onlv8nBJw5pFj50Y4poa5zyKxIw
	 OVO6zjJj0L1s71YhuEz2nNM9sGb2RL+EkTlUz3tA5wau2YU3GduBQbxH1kPyHOemIX
	 jzrV1tyP5WTyanlHmpiwciBJbTfxSsr8dPDlHohaL0lhPAdIlgdQvP+X/AxRNITsuF
	 bSYKsfrnb9SrA==
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
Subject: [PATCH RESEND v2 45/51] selftests/proc: check a sysctl listing while entries come and go
Date: Wed,  4 Nov 2026 20:27:00 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-45-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5901; i=brauner@kernel.org; h=from:subject:message-id; bh=PpkRsqulHaX8LI6MUrkW65va02k7nMeISt9l3ZnWEgo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bmK23C5Vd0CJeVXYmud2s9Pn+J3m37HmVpnFi7ow2 bTfWdpXOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyeRLDfw/N+y99eaf/2OCk /PjiV39BNqFbYdWnZD3mCaZ8OpuwbArDb9buj/tfO6Qb3GbVUb7QsZ5hkv1nv0KD0viMIPmMExu SGQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 68B51180007
X-Stat-Signature: rwxk7hd6zknxze9gjwwcghzbyxznpx4z
X-Rspam-User: 
X-HE-Tag: 1793820435-382098
X-HE-Meta: U2FsdGVkX190CLg3QWXTuWJGp/kppJTYaWoeU+zBe8c3FC9+wxN+rKTiZRpOwcrDfXhGug78DCJ857auEekCZoN8X0K1v1c+IBB2ygxXHUgW4BRG/LZLDCVI+eiqVbkNrbjr3IboB5Nv3TkBz3upiI6kgEoEr31ZmstgctyNLW+RU40AmgCiTOrxwgOrZPxWe4RjrEYQcYC6Vt1BKM21EC/z2JGmSIcmDi4yu+CdqIfsWWY/wFG+m4a6c3oPrFZ9k+Va25FoU7zcM/vjO9UYyF5JPahUQsekTqp5QNaE4+GHwsqjR204wgNkJHktQCtJFWOA/8TMG9/13Wz07YISOp4VPGPD2D+lTQO136MvgxsIznbzTftZkc2E+8TiyqXJXd61PBKH9gAZeHJzCzZLlQ8TZgJEneo9EbgGyhKKFSJb3pFrDuDu8GvBYZtDgdTFxy0HcXK77R7z9PMcGzhfdJXEnr3QyOAnKW7FhzUJa0g2tfHpfKmatUgbTBI6g8yoRwfluQ/h9ucMZ4AxJrzoFNtss8A6gWZiiKsGDLjdffMYALA9TdU3xjJ3/OgcCSM+04uzow5kVyNJgL4vZqdMwQsnMPrk/im616nxy1paJKXss6AypunLL5hqLyPpQyAYtrK10g+VS2N9DWoTosHTcNZgoJ2DmrIAvNK6A8dD33yxG88nFl31FBAxXOiuh1KAF5I9qrtuAqSHO1Q4OMk648m5v6cCKqB51Bzl1m1HjDUT38S0uiVHrxWnnSmLtZI+ZjLifGOwcwDLsOwbccuDS/p4ayFjOssn3bIQvqx5YpajQ8VZKd04ZsDEOzxbMApcTVYqh0Snw3017QpEAgSmhfdO0Ef4A1Lm88RklMwvdo0JJ9LvALWgb7sOEyMjktbQqjlR+yP5WzHjJGeKRVvEFbbHV/MTsfgAuo0Kfi4S+NKAKfEWU3EUL+oRtgwG2YJTg8b27uub4g3SW0Gep9b
 mzVDGyqW
 HQGhwvpx7wlONLSwvc4bgI7Wpk/TEWcs6AcqBsUUlseDzUTp9QXGBC4GwwoPzTh8f8ju4ROcMnxx+fCkaLf7oY8DexcJ6S5iOTqnzNldhA+uvh7l7mcZe31gQ757AeB9l+C4aU2oMRRNBAjxZM0Qldoe8EVLxMBqXv+4ZtgokJP28B+cxe8DDHSgtvATZ336REacjcldt1SeAw1c2HZnDxCKBRYm7Yc7+tiiRsDaXZV694QfrW/QhwELfRAt4M/9UCFIAavJZPIgjLrCxXpXucAPJDAvl7g8U7kcN
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
 .../selftests/proc/proc-sysctl-readdir-churn.c     | 152 +++++++++++++++++++++
 3 files changed, 154 insertions(+)

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
index 000000000000..b2ad097b464a
--- /dev/null
+++ b/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c
@@ -0,0 +1,152 @@
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
+	int tun;
+
+	if (unshare(CLONE_NEWNET))
+		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
+	tun = open("/dev/net/tun", O_RDWR | O_CLOEXEC);
+	if (tun < 0)
+		SKIP(return, "/dev/net/tun: %s", strerror(errno));
+	close(tun);
+	self->dir = open(CONF_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	if (self->dir < 0)
+		SKIP(return, CONF_DIR ": %s", strerror(errno));
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


