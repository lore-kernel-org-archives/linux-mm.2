Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D451606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43DA6B05B0; Tue, 17 Nov 2026 05:51:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B276B05B1; Tue, 17 Nov 2026 05:51:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930FC6B05B2; Tue, 17 Nov 2026 05:51:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBE76B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:51:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 040E0803E8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:51:32 +0000 (UTC)
X-FDA: 85444294866.22.9804F67
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2615C80005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:51:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of yangyizhen3198@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=yangyizhen3198@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794912691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Le1aTwSmJJVjoIZHS1zuonXE4iOS881VhWU6iH/FA2w=;
	b=bQuGhtrhlfm4/lbQDmEsuI9hCVak8/M6qUEgPH4XWkmikSSJEzkjIl7yiOR1o4Yn14j5c5
	BlfGiFwGxgn2QQn7P9wV9jU7DHNtUpaJHgI9wQ1BUufOgno+POdCcORoAStb4BJ5r63mMP
	fBdC2QDS/yTE0tzm2aLcuV0uoSwSZtc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of yangyizhen3198@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=yangyizhen3198@phytium.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794912691;
	b=1YOhgSiVs6f5+0D6YT7qoiPGLJrVW46mtWXZ0YoASx1b3ootp4hPX4oOorCbJOwbMRpM2+
	cBqKs3iS5LTjqGLBqWf5zTzGiiq0QJrTY0psKv3Cl7vbyHoeRL6DDFAr7XI4RJw61hpkgM
	wu4UI8qy03zaOZjrrzmdNTLgzqOFksg=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with UTF8SMTP id AQAAfwDHzcGrMfxqF5NWBg--.16301S2;
	Tue, 17 Nov 2026 18:51:23 +0800 (CST)
Received: from phytium.. (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAf8DwSnOdMfxqF977AA--.36666S4;
	Tue, 17 Nov 2026 18:51:13 +0800 (CST)
From: Ethan <yangyizhen3198@phytium.com.cn>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yangyizhen3198@phytium.com.cn
Subject: [RFC PATCH 1/1] block: reclaim cache before block file close notification
Date: Tue, 17 Nov 2026 18:51:07 +0800
Message-Id: <20261117105107.14236-2-yangyizhen3198@phytium.com.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261117105107.14236-1-yangyizhen3198@phytium.com.cn>
References: <20261117105107.14236-1-yangyizhen3198@phytium.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DwSnOdMfxqF977AA--.36666S4
X-CM-SenderInfo: 51dqw5pl2kv0atrzmqxsk13x1xpou0fpof0/1tbiAQACDWr7WcwEQQANsC
X-Coremail-Antispam: 1Uk129KBjvJXoW3AryxKF13Cw1UWw1rZrWkJFb_yoWxuw1kpF
	Z8GFW5Jw48WryxGan7Za17WryFgayvgFWUXryfW34FyrnrtryvyrZ2vr1jyr47Crs7ArW5
	Xw47KrZ8CryUCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Stat-Signature: toadc1sneikfiemkt7pp8fisk6gi31ff
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2615C80005
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794912688-342171
X-HE-Meta: U2FsdGVkX1/w0LR2oLr9mWbQ35H3v3PXf3Mncg8guv1Lhj8197CVnFAsCkG7amPp+kxgC0cmAPZ283GcmBwkUXi7gaiO8RjN2jsZy4Afpb8ocb/0YHk3v92nVRIepiegeW+Ex7iv1V1awVhyp/TusKsThaPmkAXSI7DLe1dtdBQIw69vYcldtwBFhx9CS7XkQ8xy7y1d8I0TKlpefuRs7MC+X/7Su2NDwLvvFK3uUX1O+51Rtxc4iTXTtPyAomsUQ31MMHje4+RE7Wz9lfAhAqiBgD9zvC30kTsWo9PDH0KwL8XFWURROsMZBfGgsgwPw3mUrndIqVLUCcfiN0p9IhrOHpEqPHTq6UL2OxcI8kPJsUw6iRMy+jm1mQvmpZ38bLryQBOxkFHIN0bhT4bO+dY4qWjHO7vzCUQvlmvJSyExOOr+bI64ohG0s49z+fgMPTDegKcW7Zrs4Nk7A+THe0eDr6unbg6/rB+f5R/y42YbmmiaZREuXTNUIicSYtAFgY1wcsfWwPuIv+78Wlgrir7LD0+TnN4MbMeQCL/uMr/69SNGjOUK366vyGEfyMGi9exm2hc1Ot/CYghYXc8Ylciyrrx623myq/sAN1Q04qRPWbcaQUlFYEQLBTzdDUr/nbb+lcFpR9ZY9xiwwmmnbd1JXzqLbysyb1Zlv+/lwrESYGeLCdTsX8eo2WVntD49rjQGkBuzScdIAYywXlG/KBuNXMoixc/A+KQDLBpaxg3mHhQox7hWhdZu78+KIp8Z6HSOK7jBx06tMZaZZ4UPZywkF7qcisbI/g3uEuJG5QQvHSX4wh0aKsHJBjhv58+4KMMkP4SF9MDQiymX7933o5Gm8ymENgRSq72PFn9GNv3Ihs60bGub29VQCn/uYlSsn+dLtg6tqvgtpdefGu19uTzwUi7MOPS3YuR4B6Sg33C/HK1axWbtTk99nUIu2uzpFoIA+Qz9MM9kLz/mGDG
 onsqXKQJ
 wE0tfnFx71nPBrYZly9W0QMiK9GDaq/AMp3lqH5xQIvNsRAQgbVRpJIedn1QGOq5kmKYTb9BvgLxtu0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A full mkfs.ntfs run on a raw NVMe device can finish writing but leave
hundreds of GiB of device mapping cache for final close cleanup. On an
ARM64 system with about 1 TiB of RAM and a 1.92 TB NVMe device, a vendor
6.6 diagnostic kernel without reclaim optimizations reproduced long
udev open blocking in three consecutive runs. All three mkfs runs and
the subsequent NTFS information checks completed successfully.

The final truncate_inode_pages() calls took 423.282, 447.064 and 420.785
seconds with about 805 GiB of mapping pages at close. The corresponding
udev opens took 423.282, 447.061 and 420.785 seconds. The blocked udev
stacks went through mutex_lock(), blkdev_get_by_dev() and blkdev_open();
the diagnostic open_mutex wait values agreed at millisecond resolution.
Each run produced hung-task warnings and one udev watchdog restart.

The examined close path holds disk->open_mutex while the last-opener
blkdev_put_whole() calls blkdev_flush_mapping(), kill_bdev() and
truncate_inode_pages(). A concurrent opener needs the same mutex. In the
recorded runs, the long interval was concentrated in cache teardown,
not the separately recorded final sync. A successful sync can leave
clean cache pages and associated metadata for this later teardown.

The problem is therefore prolonged exclusion of other device openers
during final cache cleanup, even when formatting itself succeeds. The
120-second hung-task reporting threshold is not an open_mutex timeout.
The objective is to reduce time spent in that critical section, not to
make the complete mkfs or close finish within 120 seconds. The evidence
is from a vendor diagnostic kernel, not current upstream reproduction.

Explore best-effort reclaim before notification and original release:
at final __fput of a block-device file, call vfs_fsync(), then
vfs_fadvise(POSIX_FADV_DONTNEED), before fsnotify_close(). Keep the
original release responsible for any remaining pages and concurrent
activity. Skip O_PATH and missing fsync operations before interpreting
the block-device mapping. Log sync errors and skip advice; log advice
errors and continue release. No new close error return is introduced.

The hook applies to block-device files with a fsync operation, excluding
O_PATH handles. It runs at the last reference to each such struct file,
including files opened read-only or with O_DIRECT. It does not wait for
the last device opener. A read-only close can therefore initiate shared
mapping writeback and a device flush. Reclaim can evict useful cache.
Sync/reclaim can block in __fput and delayed fput, and placing it before
fsnotify_close changes when observers run. DONTNEED does not guarantee
an empty mapping or a bound on later lock hold time.

This is a design RFC based on the recorded vendor 6.6 tree. It is not
rebased or validated on current mainline, nor proposed as a stable
backport. Please advise whether this should remain a userspace action,
be placed elsewhere in the block lifecycle, or be addressed through a
more fundamental close-locking change before pursuing a mergeable fix.

Signed-off-by: Ethan <yangyizhen3198@phytium.com.cn>
---
Baseline: recorded vendor Linux 6.6 source snapshot, not current mainline.
The baseline measurements describe the problem, not results of this
proposed patch. No additional build or runtime test was run while
preparing this posting.

Questions for reviewers:
- Is __fput an appropriate context for this blocking work?
- Should implicit sync and cache eviction remain a userspace choice?
- If a kernel policy is appropriate, what eligibility rules avoid
  repeated work and interference with other mapping users?
- How should delayed fput and close notification ordering be handled?
- Would a different block close locking design be preferable?

 block/Makefile                |  2 ++
 block/bdev-preclose.c         | 29 +++++++++++++++++++++++++++++
 fs/file_table.c               |  4 ++++
 include/linux/bdev-preclose.h | 14 ++++++++++++++
 4 files changed, 49 insertions(+)
 create mode 100644 block/bdev-preclose.c
 create mode 100644 include/linux/bdev-preclose.h

diff --git a/block/Makefile b/block/Makefile
index 46ada9d..df775b4 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -11,6 +11,8 @@ obj-y		:= bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
 			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
 			disk-events.o blk-ia-ranges.o early-lookup.o
 
+obj-y += bdev-preclose.o
+
 obj-$(CONFIG_BOUNCE)		+= bounce.o
 obj-$(CONFIG_BLK_DEV_BSG_COMMON) += bsg.o
 obj-$(CONFIG_BLK_DEV_BSGLIB)	+= bsg-lib.o
diff --git a/block/bdev-preclose.c b/block/bdev-preclose.c
new file mode 100644
index 0000000..ba3849e
--- /dev/null
+++ b/block/bdev-preclose.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Best-effort cache reclaim before final release of a block-device file. */
+#include <linux/bdev-preclose.h>
+#include <linux/blkdev.h>
+#include <linux/fadvise.h>
+#include <linux/fs.h>
+#include <linux/printk.h>
+#include "blk.h"
+
+/* The caller is __fput, before fsnotify_close and the original release. */
+void bdev_preclose_reclaim(struct file *file)
+{
+	int ret;
+
+	/* A block-special inode can also be opened as a path-only handle. */
+	if ((file->f_mode & FMODE_PATH) || !file->f_op || !file->f_op->fsync)
+		return;
+
+	lockdep_assert_not_held(&I_BDEV(file->f_mapping->host)->bd_disk->open_mutex);
+	ret = vfs_fsync(file, 0);
+	if (ret) {
+		pr_err_ratelimited("bdev preclose: fsync failed (%d); skipping DONTNEED\n",
+				   ret);
+		return;
+	}
+	ret = vfs_fadvise(file, 0, 0, POSIX_FADV_DONTNEED);
+	if (ret)
+		pr_err_ratelimited("bdev preclose: DONTNEED failed (%d)\n", ret);
+}
diff --git a/fs/file_table.c b/fs/file_table.c
index ee21b3d..0b9d7a8 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -9,6 +9,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/file.h>
+#include <linux/bdev-preclose.h>
 #include <linux/fdtable.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -367,6 +368,9 @@ static void __fput(struct file *file)
 
 	might_sleep();
 
+	/* Reclaim before notifying observers; original release remains below. */
+	if (S_ISBLK(inode->i_mode))
+		bdev_preclose_reclaim(file);
 	fsnotify_close(file);
 	/*
 	 * The function eventpoll_release() should be the first called
diff --git a/include/linux/bdev-preclose.h b/include/linux/bdev-preclose.h
new file mode 100644
index 0000000..5e75ac3
--- /dev/null
+++ b/include/linux/bdev-preclose.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_BDEV_PRECLOSE_H
+#define _LINUX_BDEV_PRECLOSE_H
+
+struct file;
+
+#ifdef CONFIG_BLOCK
+void bdev_preclose_reclaim(struct file *file);
+#else
+static inline void bdev_preclose_reclaim(struct file *file)
+{
+}
+#endif
+#endif


