Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA82606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38CC86B00EF; Tue, 17 Nov 2026 05:51:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CD56B05B0; Tue, 17 Nov 2026 05:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253676B05B1; Tue, 17 Nov 2026 05:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 000366B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:51:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C724803DA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:51:23 +0000 (UTC)
X-FDA: 85444294446.06.F1FFD9F
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf09.hostedemail.com (Postfix) with ESMTP id 90DF0140005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:51:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of yangyizhen3198@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=yangyizhen3198@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794912681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=D5L6+ctkUXEVCvLdhSmE9kuyDK2TKGhWbB/u6kdjjno=;
	b=D0ICHyeLjvR79R/0yqimfyYnGwg9I7cfqMHsQnne0bw5qEa8XrM+Vr7LqS6lwvwzny5TNt
	nPLWKGXbvDLirSRLxbrc4RS1VcgGd+CDAa0GV57z8eOW0z3NM6T/SdeaOSK64ABatl5M2K
	uWxTvwmWk41VQid7CSbdvf4mfkf8eSE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of yangyizhen3198@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=yangyizhen3198@phytium.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794912681;
	b=s959ZxE8xgnWNh7mwzjqk656PKT7KwW+CpFITM9tF4t+Ct/98hQ11AS+ijZqjVG0V8HgLY
	f9SwyfMtqvWKqovQ7MmsynrYoadn0DRLGfHJfeKkHrgy19ushekMNglXYOgV0nly/+L6x0
	cgG7Z1pULajYXguQd3Ze/zC83m4AnoQ=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with UTF8SMTP id AQAAfwAXTaWiMfxqspJWBg--.40816S2;
	Tue, 17 Nov 2026 18:51:14 +0800 (CST)
Received: from phytium.. (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAf8DwSnOdMfxqF977AA--.36666S3;
	Tue, 17 Nov 2026 18:51:10 +0800 (CST)
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
Subject: [RFC PATCH 0/1] block: long udev open waits during cache teardown
Date: Tue, 17 Nov 2026 18:51:06 +0800
Message-Id: <20261117105107.14236-1-yangyizhen3198@phytium.com.cn>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DwSnOdMfxqF977AA--.36666S3
X-CM-SenderInfo: 51dqw5pl2kv0atrzmqxsk13x1xpou0fpof0/1tbiAQACDWr7WcwEQQALsE
X-Coremail-Antispam: 1Uk129KBjvJXoWxKr1kZrWUtr43JF1UuF45ZFb_yoW3GF1kpF
	WfGFZxtrWkGrWxKrn7Zw4UWr1rKrWrGa15JrnxK340ywn8CryvqrW0qF18XayUCrZ5JF4j
	qr4jqrZ5C34DAaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Stat-Signature: wiw8dq16i44xzc8co453t1tst63wsubx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90DF0140005
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794912679-799126
X-HE-Meta: U2FsdGVkX18EPxGW004wlslDE+4piNRg+OoW6toakgCnkx7ahhoWNbNy2H+LknU25LUlPexfYL4jOaaa5SeLRwgc7sqk63hGAQ28yYlavoeVObUT4KNCut3bMRUjmP1tfE+05B1pCSrKcxZsvDfyo+DAAmws1xb44cx4lnTWGxxOCTfzimdn32kkks0/ub7PrtB4JklaTxxkDsUQRxdBPn2ZKMLwoJ4r143ehvFnIA2ABBwNApjEH08ZkmbBEz0qJ10pvdOUVKcpVDRojQt3bSeVpfhtHsrYzyg0QO41lGaKNe/9Ao80G1LjKkuAopLm2DzLNYjQxLwy63XJPRGYdd88aRoU0lyVe7oGY0FaqrVtJimVLHuRDKsasUg60JS7q4RiNY8qUgmD6L4tk798pi6DrVXBwpGdFPa2BokPdFNVp8GL4/VoAtWzCvXwlMLsuCOSFv3+pmEhTORoJYtmbMjkiYz1+DYCY/WIS1+0YbhIAtJy0ErJgwtBCrz4H3C9Xxp6FTZvl8s4OG8LCA8WXoivmwUQyo+b0ne8+QfCANCtD/h67dNCr/Lwp8u73dOUbL9UEF8CuBPJ6uh7VTNLeAcq/1s8nWhaSXyN7BIkWPkODqLP6Q+jYm8hC+GpEpX/aQzrb41PyljHKxK6AtLdwNM2jP/Xxik51X5Hacb42RWeEn5B8Mdz8dxPnwUM9ANVPU4MlpOfkDAEnciuLTaDNsxhEKwAsr6T/0nn3y02zxezNQT72BVI+HKfswhxFKqtXWqmPGgfI2IC+RFwROJl6fW5wrkZpRgQiWGJydAxqvP43P7IlqnIQ69UiizI8o+XTe7oA8JDqAfX0aKw1n/kxYiLZjoPuvHp83vJu8W94CeS1G5di8Yc88f8IRuKdWp/Yj7jhs5b8pxj7aNAAmEKZRFanypCNOndhS6TnCPe+GSMHqhoW4TVdDG9/bm/HMAxUPlrWgvzFwvuYBTVk0F
 mbOagQT9
 vV2ZtQbK+ylFxht4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This is the first posting of this proposal.

I am requesting feedback on long device-open blocking during final cache
teardown after large buffered writes to a raw block device. In repeated
full mkfs.ntfs runs, formatting succeeds, but a udev process opening the
same device waits for several minutes on disk->open_mutex. The system
reports hung tasks and udev is restarted after watchdog timeouts.

The issue is not simply that formatting or close takes a long time.
The concern is that device lifecycle exclusion is held while large-scale
cache cleanup runs, preventing another device opener from progressing.
The attached patch is an early pre-reclaim prototype for discussing how
to address that exclusion. It is not a current-mainline merge request
or a 6.6.y stable backport request.

Reproduction context and observed impact
----------------------------------------
The recorded system is Phytium ARM64 with about 1 TiB RAM, a 1.92 TB NVMe
device and 512-byte logical sectors. The reproducer is a full, non-quick
mkfs.ntfs run using the original userspace binary and library. Such a
reproducer destroys the target; it was run only on a disposable device.
No userspace cache-drop option or changed write-size option was enabled.
The hung-task reporting threshold remained 120 seconds.

The baseline was 6.6.0.6.6-server-v11-bdevdbg: a vendor 6.6 kernel with
BDEVDBG diagnostics for observing the close path. No preclose cache
reclaim hook was present. This is not an unmodified upstream v6.6 binary.
Three consecutive runs on the same boot produced:

  Run   Mapping cache at close   Final truncate   Udev entire open
        (4 KiB pages / GiB)      (seconds)        (seconds)
   1    211073040 / 805.180      423.281554       423.281502
   2    211110775 / 805.324      447.063839       447.061432
   3    211255349 / 805.875      420.785212       420.785106

All three mkfs runs and subsequent NTFS information checks returned 0.
Nevertheless, each run recorded target udev hung-task reports and one
associated udev watchdog restart; the service recovered afterwards.
The three runs contained seven hung-task messages in total. These are
repeated reports of the waiting tasks, not seven independent failures.
No soft lockup, RCU stall, media I/O error or new AER was recorded in
this baseline batch. Other device-event latency was not quantified.

A shortened stack from the first run is:

  INFO: task systemd-udevd:95598 blocked for more than 122 seconds.
  task:systemd-udevd state:D
    __mutex_lock.constprop.0
    __mutex_lock_slowpath
    mutex_lock
    blkdev_get_by_dev.part.0
    blkdev_get_by_dev
    blkdev_open
    do_dentry_open

The same task was subsequently reported blocked for over 245 seconds.
The diagnostic mutex wait was 423281 ms, agreeing with the paired udev
open at millisecond resolution. The entire open includes more than the
mutex wait, so it is not itself an exact mutex measurement. Likewise,
120 seconds is a hung-task reporting threshold, not a timed mutex that
returns an error after 120 seconds.

Where the time is spent
------------------------
The examined vendor block release path is:

  mkfs final file release               Concurrent udev open
    blkdev_release                       blkdev_open
      blkdev_put                           blkdev_get_by_dev
        sync before lock where applicable    mutex_lock(open_mutex)
        mutex_lock(open_mutex)                -> sleeps waiting
        blkdev_put_whole
          last opener reaches zero
          blkdev_flush_mapping
            sync_blockdev
            kill_bdev
              invalidate_bh_lrus
              truncate_inode_pages
        mutex_unlock(open_mutex)              -> can proceed

The last-opener check is significant: the existing final cleanup is
performed when the opener count reaches zero. A new opener is serialized
by the same disk mutex while that cleanup completes. The proposed hook,
in contrast, is per struct file and is not a last-device-opener check.

The diagnostic logs bracket cache teardown and show the target mapping
falling from the page counts above to zero. Paired tracing places nearly
all the final release interval inside truncate_inode_pages. The final
sync was recorded as 0 ms at the diagnostic timer's resolution; this is
not zero cost or proof that every page was always clean. A completed
sync need not evict clean cache pages or remove all associated metadata,
so finishing writes does not eliminate the later cache teardown work.
The cache is a shared block-device mapping, not mkfs process-private RSS.

This supports cache teardown under lifecycle exclusion as the bottleneck
in these runs. It does not establish the separate CPU cost of every BH,
shadow entry or traversal, or prove the same delay on every system.

Proposed direction and scope of this RFC
----------------------------------------
Try vfs_fsync followed by vfs_fadvise(DONTNEED) before fsnotify_close and
the original release, outside open_mutex at the hook. Keep the original
release to clean up remaining pages and concurrent activity. Allow cache
residue; no zero-page invariant or fixed timeout bound is promised.
The objective is to reduce how much cleanup other openers wait behind,
not to eliminate reclaim cost or guarantee a shorter complete close.

The proposed hook applies to block-device files that have a fsync
operation, excluding O_PATH handles. It runs at the final reference to
each such struct file, including read-only and O_DIRECT opens; this is
not a last-device-opener hook. Syncing and evicting a shared mapping at
that point can affect other users. Sync/reclaim may be long and run in
task work, exit or delayed fput context. These are unresolved policy and
placement concerns. Placing the hook before fsnotify_close also defers
notification, which must be distinguished from reduced mutex hold time.

The main questions are whether __fput is an acceptable hook, whether
this should instead remain an explicit userspace action, and whether
a different block close locking design would better address the issue.
If a kernel pre-reclaim policy is appropriate, what eligibility and
accounting could prevent repeated work and interference with other users?

Validation boundaries
----------------------
The implementation is based on the recorded vendor Linux 6.6 source
snapshot. Patch application and comparison with the prepared source
files passed. checkpatch reports 0 errors and one new-file MAINTAINERS
warning. Current mainline has not been used to reproduce or validate
this RFC, and no additional build or runtime test was run while preparing
this posting. The three baseline runs above characterize the problem;
they are not performance or safety results for the proposed patch.

This posting does not claim that all workloads are free of regressions,
or that the change fixes soft lockups or RCU stalls. Buffered-cache and
concurrent-open behavior need dedicated validation.

If the direction is appropriate, the next step is to rebase to the
agreed current tree and validate lifecycle contexts, concurrent buffered
I/O and open/close, error/removal paths, lockdep, CONFIG_BLOCK=n and
complete close and command cost. I would appreciate design feedback
before pursuing a mergeable implementation.

Thanks,
Ethan

Ethan (1):
  block: reclaim cache before block file close notification

 block/Makefile                |  2 ++
 block/bdev-preclose.c         | 29 +++++++++++++++++++++++++++++
 fs/file_table.c               |  4 ++++
 include/linux/bdev-preclose.h | 14 ++++++++++++++
 4 files changed, 49 insertions(+)


