Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBA6C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 11:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BA036B0096; Tue, 29 Jul 2025 07:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091CD6B0099; Tue, 29 Jul 2025 07:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3E96B009A; Tue, 29 Jul 2025 07:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB36F6B0096
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:32:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92A011605EA
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:32:23 +0000 (UTC)
X-FDA: 83717088966.16.A0AC7DA
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id B721F1C0006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:32:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U09IVyjW;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753788741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OHhUFJOea/Pd7a6BTVGSEExEjw5vXu28unEpKBj3Ibs=;
	b=uLjCZJgkLeQm/+WWW1PUHRN8DckChX1xrhagX+NzX+wobXSfl0KVHSE809b+QaXFiclPvk
	UwRA48+A1/4CdKzmVVio+/KjSzp8haNpVDC231o7TpRdFqL7pA5xzbNTnZjdJTY7vX+6qs
	8v5E6ahzQw7KcdwsThoWCpkR2r1gMsM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U09IVyjW;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753788741; a=rsa-sha256;
	cv=none;
	b=5qpkdvfKn/EATlubvzwXIo/GKooZANxRIrpvxOJZQ8wOS9etb0KcuC0+FBFM7wKPnaPvzd
	xkQ1NtJYpnfg11IVC1q0MvK6T7BZCNmEqj/Gbky+Kp8wgHA1crWKnpM4SiQCHtlb0Qs6JN
	k47DTwO6kfF+P+LG4Nn9FB1e+2TUxds=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-23fe9a5e5e8so20807645ad.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753788740; x=1754393540; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OHhUFJOea/Pd7a6BTVGSEExEjw5vXu28unEpKBj3Ibs=;
        b=U09IVyjWLwGQGHSCnpbSWTYXL4bEl6Tidnn6bCZ3slP2HFpfevImsv2RbAY3TiPW7T
         U0RI2RzEyX1ByDAQJNidrlS4eu+I4gRFIj7chMk+5jPu6Y4hx6AOB6OtWRbOCQDJju8H
         wLkUf1+RwJBw5FJ6Wsqghx9t+O6KlSaPF7vpdZS6m1mAz03a2Y6ATnl6um131UjkKOEl
         tIba1QhBz4Ey0p9O4oCtj+4ZmJ9svO5zq/KaWe2c2i9fjxUz5j49bGwbQew0T9cKGNAl
         MMsbrSZEPesGRcqMFcfbx3QxeJ9TZ62N3tNsLZYD+Q3PKK0kkj/8DK4ocGyKL1umIVWr
         vktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753788740; x=1754393540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OHhUFJOea/Pd7a6BTVGSEExEjw5vXu28unEpKBj3Ibs=;
        b=gP2G3r4QBPDWebfZN4XYxjxKFhK4eTv0Tz502TiPH1C1w9GLqmbfQeCSioopef9/KV
         ckmk/+Q92MMMl5vTBzH2huy0ciC+gSr99bqhvCxUYrjNm1fgXDmH5wen8lRq0Nl1HoXC
         bigeGwmlGfPYAyfw1KBN83GD/MR6Yl/QKdvDc5gy2O9kSzqCIueEckmmEKpcE7cxno+z
         8QCtjguxb/tVIeoGL6KCkUPMd1WbHQMC308Rc2k1os5PjbYgMSK+zSQqVydhkAXINWp4
         AvjEgbb3vhHfX2YZUQAoue4icMHPXUUfykNUIPRxGvKhWNpmDAbarWUnGPun97hLZZjb
         pzRg==
X-Forwarded-Encrypted: i=1; AJvYcCXDFAFzyLij9GlGz64qyVeRfkFsFBRZRZFwbNV5jBrMUWA2uQnZ1PM4IJ0K659+ZB61m6sWqU1qLA==@kvack.org
X-Gm-Message-State: AOJu0YyRDJgASzqEFvox7HD4n8IJ9/+UD9Ift7LMTuDhbzZvUkMWdgaS
	cD6Xj+/K++wQ+z+VRxg9KmvjLgKbIMoFKlSRvoYsQwi938A7tUIxpGly
X-Gm-Gg: ASbGnctLzWbEgWgIjAp52WGxLn1x9qgSCcbhOCtKYDYGfcanxFc4iCtXBdzlkt1Av7f
	TNttZIgdapqXNVXT0LQncvalkdoomifM0bo/QP/pVWxOOCvuzLidTPv0AkL+JOEUB72QT3LyKtw
	BBlIwfjCryzLKYY10GCQhr3EM+b/L9Mh1SVpUN67uRtY56bfml3iFU00djAZB2CbiiQ7onuGd8X
	AVUARc8mJgLdy4wuCP0fgz68dySU2c/8wg+KHy+rAvQr12sjO0w1+TE93c/yXCxrzNkS7jA3Q89
	xqzf/9oURWZfgw/oPON9XdcSgQxsMdgogw3uf65WO/HpVU8fCekw9v6SEVo2GFN1DTQk6djf1FR
	6kyO41Pp+rkwArZFC3tSbsTb1yKsDGEimRC1Ha6LG0+oItjFP7zj3xn4A/wg=
X-Google-Smtp-Source: AGHT+IFXzwzJWyCGho6shdLUUQN2sDwdI0rFz44svVIJGV/mIzME36PR/iNv/78wzMWtsb/GOcsAUQ==
X-Received: by 2002:a17:902:d484:b0:240:640a:c560 with SMTP id d9443c01a7336-240640ac6d1mr55978525ad.24.1753788740276;
        Tue, 29 Jul 2025 04:32:20 -0700 (PDT)
Received: from DESKTOP-GIED850.localdomain ([114.255.249.137])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24007d9a31bsm54092565ad.103.2025.07.29.04.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 04:32:19 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: akpm@linux-foundation.org,
	broonie@kernel.org,
	david@redhat.com,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org
Cc: brauner@kernel.org,
	jannh@google.com,
	Liam.Howlett@oracle.com,
	shuah@kernel.org,
	vbabka@suse.cz,
	gkwang@linx-info.com,
	p1ucky0923@gmail.com,
	ryancsn@gmail.com,
	zijing.zhang@proton.me,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v7] selftests/mm: add process_madvise() tests
Date: Tue, 29 Jul 2025 19:31:09 +0800
Message-ID: <20250729113109.12272-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 757ecobts8jdbj375af1h8s1na5jbhop
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B721F1C0006
X-Rspam-User: 
X-HE-Tag: 1753788741-468525
X-HE-Meta: U2FsdGVkX1+vzt4yGhtLTnMGgCzxPgzBSI4COBnOkfKTvY4ZJkjoW0Xod/bZcry64RhqicF4UmbYMxkLlfa3rKZACmsf3XowlwZ2ETUYaJKGesKsmldKrkmnhc55DFyxaKIv1awR3+xC1wbUXPwXwkGX4aVvmQhTmzN3ggU8rIQvglSVgVLLESt6xP9jttreuZ948KlNf3ZaBCBuByeYuDd2abJtXsqfFCtPgLViCCq63NXHzV/F5sOmNPLyFu/eEbPyhsWqZvUxYj8/dvWcRX0Vp15FWvrJcLVV4PYnDIKDpd+Jep0f5HZwFc/UTqQ8oUKb3/E3ZwqIizBfxDOqt4pATZPP/FULOfQETbYwvNriYIRT6sM/t425pJoGL5refLepKzngLglRf2t9WPoKeDOcjWf/jCDRnC51gg41yAAJXsQ4FuegTke1/klvT0dJykiz3Q8k0PjeV2nVaLkCsqjxZuEfAD0vmzL0SPbleJDRuHDe5J1ZK75AVOEkSEKKDSO374Qz+sjGqmn87YLXYP/hQt6dVtTOagS9v9IhmxTTIfrro92LuJrz50A+mcOUnS+bnRl+3l0BUqEiiZwyjEvlAeuvL+5wL8HciM5UQr92DHLgO/6YxfAklOpThOMWg109ZEDOtKT9sSliCdX9rUkUR8Dn5GMdNEAe2+KKzd2xke096sgMrePMD7EOohakJHqtvLgfGQvmYQ1W2McKFTbzU0HDtAnxiY6h5TD0gmzye7QEHgbAD3eP2loKOHwTKKlb77TesIitb1xKcUwD0oy6qJF2noXfzNzfALkaAfcGZm7HZnTuKrXLzGmC6K4omGwc2gIZddu6yZj126I/1Rm5OIF19pSroLMycQp6Qvh8elL5U+65PMX2lJrt/Dgf+1oQRCDTawwvz4ew1IBC7oOaec86eQDZs9pV348gDOHiD2Qzb1XZpAsgiQGdxVgj0ugWtun8HfGHJQrs9HC
 1cJ/FEpo
 /5VJHVZ56kkqszLeO+9n7vhw75aJ+xYTWEMgay2dENkJvQvyEhD+mHFsONTdh/D1MCFTu6P1koLjg7dtiVd4qkVVxv9CUE6olhmZiTqYkD4AU+isNTjacSqs0xp4NHx/MIvah9XmfJTg3QOFHvnfWtM/t/aSXWaUTEdOqHUEI+xVSJRM6JXXajrdzbmV4TnDUJ0qZ0zhz080cvrgpwGaOw7jCb5eOfnh+9SxMPQXj7YBx5oxBl85dFMtpTdLcv0vUFhISC9ANevXPaTJ39tLkN+hocHdT2O51JWyWEllpuR2YkSmzKWq+GoUYrU/hviqt7YhfgTULL+GlrmLys2t8fgcsCbQsZIQ78KI4yD13cI/V2+yE5+faL3gXmluuRQrwu37Y6rvgu+5uIJAJo8FvYDUZedIuxSsEQ+4WsR1/1MbByoRi1pWELVtshJhUssXKhOwHFJt/3ig04ofOHvgcr8Dps35/vAgb9px+1PF93a65fNpYf/pjwLbQbaUMQExfom0L0dKPnnKJMu2+Wyl+PHv3pC8PMtj4wGahGX86r32usXAjDcZQEDGpp9yvreAkpzrUcZJWfj6PwIYAVABw8P0JDMzIQlne+ARJ0+w33LI1/zTFQ11Tc2FjgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tests for process_madvise(), focusing on verifying behavior under
various conditions including valid usage and error cases.

Signed-off-by: wang lian <lianux.mm@gmail.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Mark Brown <broonie@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>

---
Changelog v7:
- In the remote_collapse test, replace default_huge_page_size() with read_pmd_pagesize()
- Add a new test, invalid_vlen, to verify that process_madvise() correctly 
 fails with EINVAL when the vlen argument exceeds UIO_MAXIOV.

Changelog v6: https://lore.kernel.org/lkml/20250721114614.40996-1-lianux.mm@gmail.com/
- Refactor child process and pidfd management to use the kselftest
  fixture's setup and teardown mechanism. This ensures that child
  processes are reliably terminated and file descriptors are closed, even
  when a test is aborted by an ASSERT or SKIP macro. This resolves the
  issue where a failed assertion could lead to a leaked child process.

Changelog v5: https://lore.kernel.org/lkml/20250714122533.3135-1-lianux.mm@gmail.com/
- Refactor the remote_collapse test to concentrate on its primary goal
  confirming the successful remote invocation of process_madvise() on a child process.
- Split the validation logic for invalid pidfds out of the remote test and into two new
  (`exited_process_pidfd` and `bad_pidfd`).
- Based mm-new branch, can ensure clean application


Changelog v4: https://lore.kernel.org/lkml/20250710112249.58722-1-lianux.mm@gmail.com/
- Refine resource cleanup logic in test teardown to be more robust.
- Improve remote_collapse test to correctly handle different THP
  (Transparent Huge Page) policies ('always', 'madvise', 'never'),
  including handling race conditions with khugepaged.
- Resolve build errors

Changelog v3: https://lore.kernel.org/lkml/20250703044326.65061-1-lianux.mm@gmail.com/
- Rebased onto the latest mm-stable branch to ensure clean application.
- Refactor common signal handling logic into vm_util to reduce code duplication.
- Improve test robustness and diagnostics based on community feedback.
- Address minor code style and script corrections.

Changelog v2: https://lore.kernel.org/lkml/20250630140957.4000-1-lianux.mm@gmail.com/
- Drop MADV_DONTNEED tests based on feedback.
- Focus solely on process_madvise() syscall.
- Improve error handling and structure.
- Add future-proof flag test.
- Style and comment cleanups.

-V1: https://lore.kernel.org/lkml/20250621133003.4733-1-lianux.mm@gmail.com/
 tools/testing/selftests/mm/.gitignore     |   1 +
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/process_madv.c | 344 ++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   5 +
 4 files changed, 351 insertions(+)
 create mode 100644 tools/testing/selftests/mm/process_madv.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index f2dafa0b700b..e7b23a8a05fe 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -21,6 +21,7 @@ on-fault-limit
 transhuge-stress
 pagemap_ioctl
 pfnmap
+process_madv
 *.tmp*
 protection_keys
 protection_keys_32
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index ae6f994d3add..d13b3cef2a2b 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -85,6 +85,7 @@ TEST_GEN_FILES += mseal_test
 TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += pfnmap
+TEST_GEN_FILES += process_madv
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
diff --git a/tools/testing/selftests/mm/process_madv.c b/tools/testing/selftests/mm/process_madv.c
new file mode 100644
index 000000000000..471cae8427f1
--- /dev/null
+++ b/tools/testing/selftests/mm/process_madv.c
@@ -0,0 +1,344 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#define _GNU_SOURCE
+#include "../kselftest_harness.h"
+#include <errno.h>
+#include <setjmp.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/mman.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+#include <sched.h>
+#include "vm_util.h"
+
+#include "../pidfd/pidfd.h"
+
+FIXTURE(process_madvise)
+{
+	unsigned long page_size;
+	pid_t child_pid;
+	int remote_pidfd;
+	int pidfd;
+};
+
+FIXTURE_SETUP(process_madvise)
+{
+	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
+	self->pidfd = PIDFD_SELF;
+	self->remote_pidfd = -1;
+	self->child_pid = -1;
+};
+
+FIXTURE_TEARDOWN_PARENT(process_madvise)
+{
+	/* This teardown is guaranteed to run, even if tests SKIP or ASSERT */
+	if (self->child_pid > 0) {
+		kill(self->child_pid, SIGKILL);
+		waitpid(self->child_pid, NULL, 0);
+	}
+
+	if (self->remote_pidfd >= 0)
+		close(self->remote_pidfd);
+}
+
+static ssize_t sys_process_madvise(int pidfd, const struct iovec *iovec,
+				   size_t vlen, int advice, unsigned int flags)
+{
+	return syscall(__NR_process_madvise, pidfd, iovec, vlen, advice, flags);
+}
+
+/*
+ * This test uses PIDFD_SELF to target the current process. The main
+ * goal is to verify the basic behavior of process_madvise() with
+ * a vector of non-contiguous memory ranges, not its cross-process
+ * capabilities.
+ */
+TEST_F(process_madvise, basic)
+{
+	const unsigned long pagesize = self->page_size;
+	const int madvise_pages = 4;
+	struct iovec vec[madvise_pages];
+	int pidfd = self->pidfd;
+	ssize_t ret;
+	char *map;
+
+	/*
+	 * Create a single large mapping. We will pick pages from this
+	 * mapping to advise on. This ensures we test non-contiguous iovecs.
+	 */
+	map = mmap(NULL, pagesize * 10, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (map == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+
+	/* Fill the entire region with a known pattern. */
+	memset(map, 'A', pagesize * 10);
+
+	/*
+	 * Setup the iovec to point to 4 non-contiguous pages
+	 * within the mapping.
+	 */
+	vec[0].iov_base = &map[0 * pagesize];
+	vec[0].iov_len = pagesize;
+	vec[1].iov_base = &map[3 * pagesize];
+	vec[1].iov_len = pagesize;
+	vec[2].iov_base = &map[5 * pagesize];
+	vec[2].iov_len = pagesize;
+	vec[3].iov_base = &map[8 * pagesize];
+	vec[3].iov_len = pagesize;
+
+	ret = sys_process_madvise(pidfd, vec, madvise_pages, MADV_DONTNEED, 0);
+	if (ret == -1 && errno == EPERM)
+		SKIP(return,
+			   "process_madvise() unsupported or permission denied, try running as root.\n");
+	else if (errno == EINVAL)
+		SKIP(return,
+			   "process_madvise() unsupported or parameter invalid, please check arguments.\n");
+
+	/* The call should succeed and report the total bytes processed. */
+	ASSERT_EQ(ret, madvise_pages * pagesize);
+
+	/* Check that advised pages are now zero. */
+	for (int i = 0; i < madvise_pages; i++) {
+		char *advised_page = (char *)vec[i].iov_base;
+
+		/* Content must be 0, not 'A'. */
+		ASSERT_EQ(*advised_page, '\0');
+	}
+
+	/* Check that an un-advised page in between is still 'A'. */
+	char *unadvised_page = &map[1 * pagesize];
+
+	for (int i = 0; i < pagesize; i++)
+		ASSERT_EQ(unadvised_page[i], 'A');
+
+	/* Cleanup. */
+	ASSERT_EQ(munmap(map, pagesize * 10), 0);
+}
+
+/*
+ * This test deterministically validates process_madvise() with MADV_COLLAPSE
+ * on a remote process, other advices are difficult to verify reliably.
+ *
+ * The test verifies that a memory region in a child process,
+ * focus on process_madv remote result, only check addresses and lengths.
+ * The correctness of the MADV_COLLAPSE can be found in the relevant test examples in khugepaged.
+ */
+TEST_F(process_madvise, remote_collapse)
+{
+	const unsigned long pagesize = self->page_size;
+	long huge_page_size;
+	int pipe_info[2];
+	ssize_t ret;
+	struct iovec vec;
+
+	struct child_info {
+		pid_t pid;
+		void *map_addr;
+	} info;
+
+	huge_page_size = read_pmd_pagesize();
+	if (huge_page_size <= 0)
+		SKIP(return, "Could not determine a valid huge page size.\n");
+
+	ASSERT_EQ(pipe(pipe_info), 0);
+
+	self->child_pid = fork();
+	ASSERT_NE(self->child_pid, -1);
+
+	if (self->child_pid == 0) {
+		char *map;
+		size_t map_size = 2 * huge_page_size;
+
+		close(pipe_info[0]);
+
+		map = mmap(NULL, map_size, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		ASSERT_NE(map, MAP_FAILED);
+
+		/* Fault in as small pages */
+		for (size_t i = 0; i < map_size; i += pagesize)
+			map[i] = 'A';
+
+		/* Send info and pause */
+		info.pid = getpid();
+		info.map_addr = map;
+		ret = write(pipe_info[1], &info, sizeof(info));
+		ASSERT_EQ(ret, sizeof(info));
+		close(pipe_info[1]);
+
+		pause();
+		exit(0);
+	}
+
+	close(pipe_info[1]);
+
+	/* Receive child info */
+	ret = read(pipe_info[0], &info, sizeof(info));
+	if (ret <= 0) {
+		waitpid(self->child_pid, NULL, 0);
+		SKIP(return, "Failed to read child info from pipe.\n");
+	}
+	ASSERT_EQ(ret, sizeof(info));
+	close(pipe_info[0]);
+	self->child_pid = info.pid;
+
+	self->remote_pidfd = syscall(__NR_pidfd_open, self->child_pid, 0);
+	ASSERT_GE(self->remote_pidfd, 0);
+
+	vec.iov_base = info.map_addr;
+	vec.iov_len = huge_page_size;
+
+	ret = sys_process_madvise(self->remote_pidfd, &vec, 1, MADV_COLLAPSE,
+				  0);
+	if (ret == -1) {
+		if (errno == EINVAL)
+			SKIP(return, "PROCESS_MADV_ADVISE is not supported.\n");
+		else if (errno == EPERM)
+			SKIP(return,
+				   "No process_madvise() permissions, try running as root.\n");
+		return;
+	}
+
+	ASSERT_EQ(ret, huge_page_size);
+}
+
+/*
+ * Test process_madvise() with a pidfd for a process that has already
+ * exited to ensure correct error handling.
+ */
+TEST_F(process_madvise, exited_process_pidfd)
+{
+	const unsigned long pagesize = self->page_size;
+	struct iovec vec;
+	char *map;
+	ssize_t ret;
+
+	map = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1,
+		   0);
+	if (map == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+
+	vec.iov_base = map;
+	vec.iov_len = pagesize;
+
+	/*
+	 * Using a pidfd for a process that has already exited should fail
+	 * with ESRCH.
+	 */
+	self->child_pid = fork();
+	ASSERT_NE(self->child_pid, -1);
+
+	if (self->child_pid == 0)
+		exit(0);
+
+	self->remote_pidfd = syscall(__NR_pidfd_open, self->child_pid, 0);
+	ASSERT_GE(self->remote_pidfd, 0);
+
+	/* Wait for the child to ensure it has terminated. */
+	waitpid(self->child_pid, NULL, 0);
+
+	ret = sys_process_madvise(self->remote_pidfd, &vec, 1, MADV_DONTNEED,
+				  0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ESRCH);
+}
+
+/*
+ * Test process_madvise() with bad pidfds to ensure correct error
+ * handling.
+ */
+TEST_F(process_madvise, bad_pidfd)
+{
+	const unsigned long pagesize = self->page_size;
+	struct iovec vec;
+	char *map;
+	ssize_t ret;
+
+	map = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1,
+		   0);
+	if (map == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+
+	vec.iov_base = map;
+	vec.iov_len = pagesize;
+
+	/* Using an invalid fd number (-1) should fail with EBADF. */
+	ret = sys_process_madvise(-1, &vec, 1, MADV_DONTNEED, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EBADF);
+
+	/*
+	 * Using a valid fd that is not a pidfd (e.g. stdin) should fail
+	 * with EBADF.
+	 */
+	ret = sys_process_madvise(STDIN_FILENO, &vec, 1, MADV_DONTNEED, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EBADF);
+}
+
+/*
+ * Test that process_madvise() rejects vlen > UIO_MAXIOV.
+ * The kernel should return -EINVAL when the number of iovecs exceeds 1024.
+ */
+TEST_F(process_madvise, invalid_vlen)
+{
+	const unsigned long pagesize = self->page_size;
+	int pidfd = self->pidfd;
+	struct iovec vec;
+	char *map;
+	ssize_t ret;
+
+	map = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1,
+		   0);
+	if (map == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+
+	vec.iov_base = map;
+	vec.iov_len = pagesize;
+
+	ret = sys_process_madvise(pidfd, &vec, 1025, MADV_DONTNEED, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	/* Cleanup. */
+	ASSERT_EQ(munmap(map, pagesize), 0);
+}
+
+/*
+ * Test process_madvise() with an invalid flag value. Currently, only a flag
+ * value of 0 is supported. This test is reserved for the future, e.g., if
+ * synchronous flags are added.
+ */
+TEST_F(process_madvise, flag)
+{
+	const unsigned long pagesize = self->page_size;
+	unsigned int invalid_flag;
+	int pidfd = self->pidfd;
+	struct iovec vec;
+	char *map;
+	ssize_t ret;
+
+	map = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1,
+		   0);
+	if (map == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+
+	vec.iov_base = map;
+	vec.iov_len = pagesize;
+
+	invalid_flag = 0x80000000;
+
+	ret = sys_process_madvise(pidfd, &vec, 1, MADV_DONTNEED, invalid_flag);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	/* Cleanup. */
+	ASSERT_EQ(munmap(map, pagesize), 0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a38c984103ce..471e539d82b8 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -65,6 +65,8 @@ separated by spaces:
 	test pagemap_scan IOCTL
 - pfnmap
 	tests for VM_PFNMAP handling
+- process_madv
+	test for process_madv
 - cow
 	test copy-on-write semantics
 - thp
@@ -425,6 +427,9 @@ CATEGORY="madv_guard" run_test ./guard-regions
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+# PROCESS_MADV test
+CATEGORY="process_madv" run_test ./process_madv
+
 CATEGORY="vma_merge" run_test ./merge
 
 if [ -x ./memfd_secret ]
-- 
2.43.0


