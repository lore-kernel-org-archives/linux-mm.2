Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C96D71099B20
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83786B00E0; Fri, 20 Mar 2026 13:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C342E6B00E2; Fri, 20 Mar 2026 13:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49D56B00E3; Fri, 20 Mar 2026 13:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2CE16B00E0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:03:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A873C16B5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:03:23 +0000 (UTC)
X-FDA: 84567062286.20.B025424
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf30.hostedemail.com (Postfix) with ESMTP id 725E880018
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:03:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774026201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=NVB3adPuuRSdZoIYsViGbhamzs8cgNf/u+PLJmrHrxQ=;
	b=Qsn1sLa1FFmFDXZ33oYvKY3hNk2eBhK8pE34xREncwDK/n9Wz0H3+TXMJ+o4pDJ16ocxVD
	4mf4RbkTN7Ypcdj2CrHwwkD5XHu5LkFLObXjUoH7uyAwKsVA2L5JHGb4NOWKuq/zdAB+9n
	yRQi0cLaHR0KpWraE4USMUiFxd1kg4s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774026201; a=rsa-sha256;
	cv=none;
	b=sR5YVOzM1ZuHWaIyLb1iGj3jAm/i7icKgQhFQ8vCu66mTo5lCzdqdzL/8MPl94NpER+9aW
	pgIft43kz+Bcal315yE5UcTKuDU0GqLKXWQXmdCWgHY+FENGs7rEXH1+q97p12HD11f/01
	kJdtDu9X4g3hAvH9RfrnBPK11qMRxEk=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 Mar 2026 02:03:14 +0900
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
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v6 0/3] mm/swap, PM: hibernate: fix swapoff race and optimize swap
Date: Sat, 21 Mar 2026 02:03:10 +0900
Message-Id: <20260320170313.163386-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 725E880018
X-Rspamd-Server: rspam08
X-Stat-Signature: u71zi8pkf5dt5hwngo5a7bjiiraem7em
X-HE-Tag: 1774026200-722527
X-HE-Meta: U2FsdGVkX1+Kf31qUXpF+ioyspz3qP7SXBSvDmYxEhSqvj+gIkPMUqJUfDZjgWBeH7gBcI6tIGacUUgQkIkxS2TKugM0BkxftgpYKxDuP6I7oZ0FBY6JlHFA9oxUAjm3HjdBLQwHySvFVcKbwQLXDOWm6l89XpljgqwarlEU4f928Z/vFhuSdQK9s4PomlJRMRYeVuXvCoVDkGRdNyP6a/hzaaN2PGHWDf2Ib42LswbsHG7DHEvEt1YnvpdgQA3qlFGBrXK8SmH6guBk4jGbetg2otrz3PRi/TkHRt+NFLZR0/Tb7uLK2ZosGAxmslISO0Ig+XkEidwf7aDd+VoKA4YToj+WQBA7RKQIxyRwyEhnPvQJVcqgEiH7gsVU2MJgaY0aYrKbPT5mWrIH2qhNn3APSoGVn6Bzxr3ydxjg1OX1HZDZHV6eRh2cFNrg+Gqmfir7d+f+fjvCouk6Evm4ZbeV0UJAtEfzzV14htK1I6lSyy0d1vlzNSFBmJGKe8VbHBemwES4e6Qf31OgEFq1s+r0qDUhwZ8tsjqLVDDA0qlFRtqAznRNrnS/ZEZWetdD7mXMkt4FIRQ2xzMUP4NNSd95nm4guxdnyJGWGnlbx0PQx32NkB7IjjozDfbedBG1yGvOjk0gUM06FCdVfWpx6v56iH5YcCaB9iKOp3Af/YcxHrnCLusRlIPfB5YieIWcEkeN+Y8zGpCHvgk6LXDO4o1rSO+Ci3paRAYwuyZn9EFqcskbHF8uM3BxwDciHnzsm0gPNn8waMSGKQE6I1MBTqUCVrMaHtTDzyfH9GVezI3km7uPjcolIARJsvCJz4BWR/tF5AUcy1KO0ucA17TG7evxRB/L0uWxcQF/oujikjLeEZvDnDxazlqruPLiD0tRkSzCD9tMIPmPr//YJiHXSMWeJQYdQ0IogAeAN98KbSGLAHOA5ft6uWJ0GkImEiwgjRAME6dNb+GHYvvqnZD
 kFd8fAWA
 e3yfKaPVrPIyNl1rnoydTENn4YfkcnfEnLZ1CqXqSQRRwm7EODdrNok0nk6+NTnJ+bov4GSqVCWvf2YeJq90NPqD/w42OgTKVOXafsNRCOLeGeBO5ZOpaS7CUgiUxx6Xv9jICfVH9sb4LGO+I49v9c+5P6zKAqwiyUAWC1hxItMJzsJqmFxHCk+SFAQ==
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
- Patch 1: Fixes the swapoff race in uswsusp by pinning the swap device
  from the point it is looked up until the session completes.
- Patch 2: Removes the overhead of per-slot reference counting in alloc/free
  paths and cleans up the redundant SWP_WRITEOK check.
- Patch 3: Fixes a spurious WARNING in the uswsusp GFP mask restore path.
  (Found during uswsusp test)

Links:
RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.arif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
RFC v2: https://lore.kernel.org/linux-mm/20260306024608.1720991-1-youngjun.park@lge.com/
RFC v3: https://lore.kernel.org/linux-mm/20260312112511.3596781-1-youngjun.park@lge.com/
v4: https://lore.kernel.org/linux-mm/abv+rjgyArqZ2uym@yjaykim-PowerEdge-T330/T/#m924fa3e58d0f0da488300653163ee8db7e870e4a
v5: https://lore.kernel.org/linux-mm/ab0YEn+Fd41q6LM7@yjaykim-PowerEdge-T330/T/#m8409d470c68cb152b0849940759bff7d7806f397

Testing:
- Hibernate/resume via sysfs
  (echo reboot > /sys/power/disk && echo disk > /sys/power/state)
- Hibernate with suspend via sysfs
  (echo suspend > /sys/power/disk && echo disk > /sys/power/state)
- Hibernate/resume via uswsusp (suspend-utils s2disk/resume on QEMU)
  - Verified swap I/O works correctly after resume.
  - Verified swapoff succeeds after snapshot resume completes.
  - Verified pm_restore_gfp_mask() WARNING no longer triggers (Patch 3).
  - Verified SNAPSHOT_FREEZE followed by snapshot_release() does not
    trigger pm_restore_gfp_mask() WARNING (Patch 3).
- swapoff during active uswsusp session:
  - Verified swapoff returns -EBUSY while swap device is pinned (Patch 1).
  - Verified swapoff succeeds after uswsusp process terminates.

Changelog:
v5 -> v6:
 - Replaced get/put reference approach with SWP_HIBERNATION
   pinning to prevent swapoff, per Kairui's feedback.  Renamed helpers
   from get/find/put_hibernation_swap_type() to
   pin/find/unpin_hibernation_swap_type().
 - Removed swapoff waiting on hibernation reference.
   swapoff now returns -EBUSY immediately when the swap device is
   pinned.
 - Updated function comments per Kairui's review.
 - Updated commit message.
 - Fixed pm_restore_gfp_mask_safe() to use saved_gfp_count
   check instead of saved_gfp_mask, and hold system_transition_mutex
   for the check.  Addressed AI review finding that SNAPSHOT_FREEZE
   followed by snapshot_release() could still trigger the WARNING.

v4 -> v5:
 - Rebased onto v7.0-rc4 (Rafael J. Wysocki comment)
 - No functional changes. rebase conflict fix.

rfc v3 -> v4:
 - Introduced get/find/put_hibernation_swap_type() helpers per Kairui's
   feedback. find_ for lookup-only, get/put for reference management.
 - Switched to swap_type_to_info() and added type < 0 check per
   Kairui's suggestion.
 - Fixed get_hibernation_swap_type() return when ref == false (Reviewed by Kairui)
 - Made swapoff wait interruptible to prevent hang when uswsusp
   holds a swap reference.
 - Fixed spurious WARN_ON in pm_restore_gfp_mask() by introducing
   pm_restore_gfp_mask_safe() (Patch 3).
 - Updated commit messages and added comments for clarity.
 - Rebased onto latest mm-new tree.

rfc v2 -> rfc v3:
 - Split into 2 patches per Chris Li's feedback.
 - Simplified by not holding reference in normal hibernation path
   per Chris Li's suggestion.
 - Removed redundant SWP_WRITEOK check.
 - Rebased onto f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b.

rfc v1 -> rfc v2:
 - Squashed into single patch per Usama Arif's feedback.

Youngjun Park (3):
  mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap
    device
  mm/swap: remove redundant swap device reference in alloc/free
  PM: hibernate: fix spurious GFP mask WARNING in uswsusp path

 include/linux/suspend.h |   1 +
 include/linux/swap.h    |   5 +-
 kernel/power/main.c     |  18 ++++
 kernel/power/swap.c     |   2 +-
 kernel/power/user.c     |  21 +++--
 mm/swapfile.c           | 178 +++++++++++++++++++++++++++++++---------
 6 files changed, 178 insertions(+), 47 deletions(-)


base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.34.1


