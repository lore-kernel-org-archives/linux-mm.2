Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D141E1090233
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB216B04D8; Thu, 19 Mar 2026 10:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B898B6B04DA; Thu, 19 Mar 2026 10:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A476B04DB; Thu, 19 Mar 2026 10:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2376B04D8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:24:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 796E91A0612
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:25 +0000 (UTC)
X-FDA: 84563032890.28.17EB338
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3045A160004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773930263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=E+KdvNXED7c6h3IWFxjbnEdNNtYX/xTo2GLPYE2QYLE=;
	b=yAaJi4EAghPFjCqSLU+GLuyE6xla2I44GRmQgrVTI0ha3JzIe1eJ7I5Ydvo/6bdf2I1AJe
	mxc/VdQjVXkaBVndJpQRwS3b5f5abmaq9gx2KkRb2e6KBtYuLf2if5i4nK0xb4Sr+nZb4z
	YGAX6cfo0yk4haZhLn2erFTY9tV7rjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773930263; a=rsa-sha256;
	cv=none;
	b=XHjvjDcTC+E62YYQuvT/I2raRoYOpZzlMzPqndqtghmVn/h8IRzLZNDoW8ozlTkcfrQvXJ
	bBF4Ab5UeUUtclWdt7FAf4NdevnllIs5f3aVkxno00wphWCW+Gbx9QG3DnCy+Ox4j9+0zi
	Zt7eXFi0Tq8/zLOQZmqNUIlPN2w7Q/A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 19 Mar 2026 23:24:18 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: rafael@kernel.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	pavel@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: [PATCH v5 0/3] Fix swapoff race and cleanup in hibernation swap path
Date: Thu, 19 Mar 2026 23:24:01 +0900
Message-Id: <20260319142404.3683019-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3045A160004
X-Stat-Signature: gowh39qbznqobdr65nf3r1inwosfqybu
X-HE-Tag: 1773930261-580366
X-HE-Meta: U2FsdGVkX18O+zoPXpF3UgrjGHGLbaeVDFGFJ/u2/bGPIUeeLEc23GyQvaRac8OvyrFxL886euYtt5lSEndx+9G3hM0lTpEUZuR0uHymqYEbnqvT1DvoUBa1wYzfltzs84l8V1aAgsSyTjgRiQWbvFMVskuNTd1CSABJcLvd+WvjQTzwe55aMVOB5F+LrHxDlQq7wxzszCCQ1IBjpmuCXQFcQqtCx3X24Xuyj4MNnuNJYyK1RuaME7mT07CLX9nUpzFE9BiPq+mPF/A+FG4lKepggUDgO4sSZv5KH9PgeM9gmI580Vr5xFJqNHDPCULpXd/A6rPXOIBTt8VtqUZ2HGwOaaXpsKovWQzuYuE8zgvMwoiCGpjQnhOnl/10y2I0HMIR553DkdjbPfQpWPcl4hI2hdxwG77ejztMU9XrtGiKkcgJptbjvvJ8TrkgVkeNsANn9PGIDb/SfP2A7odtrK/qxWJfEoYrjux46DEiN565vbgMEwFTp61XZIMo9rvvoZuamGF9y2KN4jKI6lxVgxvi+ImE8uA3yxKTzaWI7VNP6Ie9IfY2ETC6DUmHHbAYxFLpgCLIQe83HiR5a3+tBSe93n+hXI19chrL745v+wQQST1XKIZLrB8OKzNznD4MnU2bwyKM0wgC4uhbmHZth+M6ZKntd9crovY2E4KnSICecLb/LKJD5zOUlbYbKLHZefSpx77h32zIuPeleN5Eea6UhrfkPcNtnkJJnlTeM2VQTze23RE3dcgnhnJGUduBBAtSa5bSxmP+c0p7tc2AbM9Yee5hziz4mFNOcXdjkVoFDgxZbqOPC+BLDJ1s2lIgveoV31/5TjN0pBkLqIGEtXU9YBWcaOmn3T7BTeW597jCKhL8heGU3LDbunveLDsNAlf3byLBFtMHxx8G8AMuV91my2BqFCN2q4ylUQsrrCMY/JyjDbbKgfcch7e0u16ZY2+OBMHTQ/LVNzyBYLy
 O5K9sVG7
 QdI0c/6PtXLqRinWyx3cB2XhoU9rKLh4S36kblK8G4rYByxZSIGMXfhaTweY8ZjCAICLhHhmvRfyErWV6pVJOuAXO8Wb366Ia2YLNHvsTIvQmmsv5K00cpffWCpf7TJ4jCQoGhq5cR1gzGw/M08anuxh2c/7243q2WYMY5nm/24iPQcI/wy842u8Nfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, in the uswsusp path, only the swap type value is retrieved at
lookup time without holding a reference. If swapoff races after the type
is acquired, subsequent slot allocations operate on a stale swap device.

Additionally, grabbing and releasing the swap device reference on every
slot allocation is inefficient across the entire hibernation swap path.

This patch series addresses these issues:
- Patch 1: Fixes the swapoff race in uswsusp by holding the swap device
  reference from the point the swap device is looked up.
- Patch 2: Removes the overhead of per-slot reference counting in alloc/free
  paths and cleans up the redundant SWP_WRITEOK check.
- Patch 3: Fixes a spurious WARNING in the uswsusp GFP mask restore path.
  (Founded during uswsusp test)

Links:
RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.arif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
RFC v2: https://lore.kernel.org/linux-mm/20260306024608.1720991-1-youngjun.park@lge.com/
RFC v3: https://lore.kernel.org/linux-mm/20260312112511.3596781-1-youngjun.park@lge.com/
v4: https://lore.kernel.org/linux-mm/abv+rjgyArqZ2uym@yjaykim-PowerEdge-T330/T/#m924fa3e58d0f0da488300653163ee8db7e870e4a

Testing:
- Hibernate/resume via sysfs
  (echo reboot > /sys/power/disk && echo disk > /sys/power/state)
- Hibernate with suspend via sysfs
  (echo suspend > /sys/power/disk && echo disk > /sys/power/state)
- Hibernate/resume via uswsusp (suspend-utils s2disk/resume on QEMU)
  - Verified swap I/O works correctly after resume.
  - Verified swapoff succeeds after snapshot resume completes.
  - Verified pm_restore_gfp_mask() WARNING no longer triggers (Patch 3).
- swapoff during active uswsusp session:
  - Verified swapoff blocks while uswsusp holds swap reference.
  - Verified swapoff can be cancelled by signal (e.g. Ctrl+C).
  - Verified swapoff succeeds after uswsusp process terminates.

Changelog:
v4 -> v5:
 - Rebased onto v7.0-rc4 (Rafael J. Wysocki comment)
 - No functional changes. rebase conflict fix.

rfc v3 -> v4:
 - Introduced get/find/put_hibernation_swap_type() helpers per Kairui's
   feedback. find_ for lookup-only, get/put for reference management.
 - Switched to swap_type_to_info() and added type < 0 check per
   Kairui's suggestion.
 - Fixed get_hibernation_swap_type() return when ref == false (Reviewd by Kairui)
 - Made swapoff wait interruptible to prevent hang when uswsusp
   holds a swap reference.
 - Fixed spurious WARN_ON in pm_restore_gfp_mask() by introducing
   pm_restore_gfp_mask_safe() (Patch 3).
 - Updated commit messages and added comments for clarity.
 - Rebased onto latest mm-new tree.

 Note: Kairui suggested adding WARN on NULL in put_hibernation_swap_type(),
 but kept silent return instead, as type can legitimately be -1 when
 snapshot_open() fails to find a matching swap device. swap_type_to_info()
 returns NULL for type < 0, so the cleanup path stays simple.

rfc v2 -> rfc v3:
 - Split into 2 patches per Chris Li's feedback.
 - Simplified by not holding reference in normal hibernation path
   per Chris Li's suggestion.
 - Removed redundant SWP_WRITEOK check.
 - Rebased onto f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b.

rfc v1 -> rfc v2:
 - Squashed into single patch per Usama Arif's feedback.

Youngjun Park (3):
  mm/swap, PM: hibernate: fix swapoff race in uswsusp by getting swap
    reference
  mm/swap: remove redundant swap device reference in alloc/free
  PM: hibernate: fix spurious GFP mask WARNING in uswsusp path

 include/linux/suspend.h |   1 +
 include/linux/swap.h    |   4 +-
 kernel/power/main.c     |   7 +++
 kernel/power/swap.c     |   2 +-
 kernel/power/user.c     |  19 ++++--
 mm/swapfile.c           | 135 ++++++++++++++++++++++++++++------------
 6 files changed, 122 insertions(+), 46 deletions(-)

base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.34.1

