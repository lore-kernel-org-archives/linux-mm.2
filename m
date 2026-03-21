Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767271094468
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 10:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A6A6B0096; Sat, 21 Mar 2026 06:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB386B0098; Sat, 21 Mar 2026 06:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711AA6B0099; Sat, 21 Mar 2026 06:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB6C6B0096
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:33:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04DBB5912A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:33:17 +0000 (UTC)
X-FDA: 84569708076.30.4A5C96F
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A2734000F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:33:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774089196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=DQOy6zWzyr3bzQoKAP5jWi72/p1RLK5PJk3yi931Wf4=;
	b=xzLd7ggaJmEhWoXblw2iuB32HWXvl6ikmL96anYY/CvuDSE/35Tj6ZjbN9fdK0xTkVVXtB
	EKt4gBPYgPOkIIApAgS/hc90kCb8cO6jRG6XlqlUlOZq2wnhuYqun0rcEtqe+EP9tIvWjN
	6VhadGxYzizsFXZk3xOrYHU1R1Esjkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774089196; a=rsa-sha256;
	cv=none;
	b=aZruEXKt8R9r6bq38+QqZ2azcLOg6zAcQg6UYPnARQXj9VK5nRXv9QV069Oqva1PvdFiRH
	zpE6LUR46spbfCfwIIw0Xpz0wDwkgAFaLonGXk4rPF5wqF6yaGBp8SbOVTaegu2k5IoCJC
	U8Sdkw6KuPP8dfiLQSLDFEMtDfbd7gk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 21 Mar 2026 19:33:11 +0900
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
Subject: [PATCH v7 0/2] mm/swap, PM: hibernate: fix swapoff race and optimize swap
Date: Sat, 21 Mar 2026 19:33:07 +0900
Message-Id: <20260321103309.439265-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A2734000F
X-Stat-Signature: xtxqozhr38uaczp6s319aen7sw1uenfy
X-Rspam-User: 
X-HE-Tag: 1774089194-157710
X-HE-Meta: U2FsdGVkX18st/uPvLEUyoc2EINJ9d1eBRKkS9T7010wbn4TgkYi5ud8kxBIZS7/AVDoG++cdshBKZlSsVtj0cDEKeFpXMVZc0sm8UAYnwBBQ35ruUvw9HQonCD1d6OxHuSdF7uhSrGxK7zBnklhX7Ho/EjZOFbR46mXr5t+U55vwjVcHRk+TTgk+rsN/aMSib4jeUXN2KcZSYECb6aWmVK0eE1RS4wHzBsZBOIMM62vDxq6fk1qdZDVr+H5fh3DgTL9CDgXFippGLKPyaOPwTWIPa8UvXaRP8GkZCiRMXWYej8TegRKBURxJ7uF1V69sc37JalGgbpJPwKtQfJPlOhQ5HTUjyodp494MyVOMHS8zEcwlwXcEPBhAai/JrraSLUZevX3TWMUlR40Q8edeIDZFtbJZoMinIAIZP1i7/0D2r0X1VrznptfrrpPeZtszNoG/xBJnOkIPm756v6JSqVAEqWSCVIfrhIHEn71zFc+N5nld85S24JddTJPCs0Y4ocLK4Z9QZzY6HzssxFZDNicocLbBuZQaPxShvq4TwsBcOWdDX49kSPPOyx5q4vpj9HEvXwIyvy7TrZ/I/mMdQ9RkR65dPiTD35Ka/imsmFi8aitrofV0mMoomJ+DLSySixUKosdZqopEcXpMuKv5V7lEgHdm+2w8GfMxbl1dqI1Kp22S2uau1U/AIuc+Znt2DC1J6tadalUhf5MKYQvEUQZkfHCqPC2x5ysGe16wISdxW11D01EREB7dRaHn4M2mtzg0TZ6v43e9DiHhS+nmyLR6nqKUPhcxtrZaXlasEwNm+Q7+H2fFqHJOwRYtBfwxHOuvyoGZsRq0Mf4G4Kycg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apologies for the frequent revisions. Hopefully this version is close to final.

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

This series is based on v7.0-rc4(Refael's request for PM's modification)
. Happy to rebase onto mm-new if needed.

Links:
RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.arif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
RFC v2: https://lore.kernel.org/linux-mm/20260306024608.1720991-1-youngjun.park@lge.com/
RFC v3: https://lore.kernel.org/linux-mm/20260312112511.3596781-1-youngjun.park@lge.com/
v4: https://lore.kernel.org/linux-mm/abv+rjgyArqZ2uym@yjaykim-PowerEdge-T330/T/#m924fa3e58d0f0da488300653163ee8db7e870e4a
v5: https://lore.kernel.org/linux-mm/ab0YEn+Fd41q6LM7@yjaykim-PowerEdge-T330/T/#m8409d470c68cb152b0849940759bff7d7806f397
v6: https://lore.kernel.org/linux-mm/20260320182227.896f9ab62d62961b2caab5f7@linux-foundation.org/T/#m10ee3346cd8dcd052749105d9a8e2052dbf3bc80

Testing:
- Hibernate/resume via sysfs
  (echo reboot > /sys/power/disk && echo disk > /sys/power/state)
- Hibernate with suspend via sysfs
  (echo suspend > /sys/power/disk && echo disk > /sys/power/state)
- Hibernate/resume via uswsusp (suspend-utils s2disk/resume on QEMU)
  - Verified swap I/O works correctly after resume.
  - Verified swapoff succeeds after snapshot resume completes.
- swapoff during active uswsusp session:
  - Verified swapoff returns -EBUSY while swap device is pinned (Patch 1).
  - Verified swapoff succeeds after uswsusp process terminates.

Changelog:
v6 -> v7:
 - Dropped Patch 3 (pm_restore_gfp_mask fix) from series as it has
   no dependency on Patches 1-2. Will be sent separately.
   (Rafael J. Wysocki feedback)
 - Andrew Morton's AI review findings applied only to Patch 3;
   Patches 1-2 are unchanged. (no problem on AI's review)

v5 -> v6:
 - Replaced get/put reference approach with SWP_HIBERNATION
   pinning to prevent swapoff, per Kairui's feedback.  Renamed helpers
   from get/find/put_hibernation_swap_type() to
   pin/find/unpin_hibernation_swap_type().
 - Renamed swap_type_of() to __find_hibernation_swap_type() since
   it is now an internal helper with no external callers.
   (Kairui's feedback)
 - Removed swapoff waiting on hibernation reference.
   swapoff now returns -EBUSY immediately when the swap device is
   pinned.
 - Updated function comments per Kairui's review.
 - Updated commit message.

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
 - Rebased onto latest mm-new tree.

rfc v2 -> rfc v3:
 - Split into 2 patches per Chris Li's feedback.
 - Simplified by not holding reference in normal hibernation path
   per Chris Li's suggestion.
 - Removed redundant SWP_WRITEOK check.
 - Rebased onto f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b.

rfc v1 -> rfc v2:
 - Squashed into single patch per Usama Arif's feedback.

Youngjun Park (2):
  mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap
    device
  mm/swap: remove redundant swap device reference in alloc/free

 include/linux/swap.h |   5 +-
 kernel/power/swap.c  |   2 +-
 kernel/power/user.c  |  15 +++-
 mm/swapfile.c        | 178 +++++++++++++++++++++++++++++++++----------
 4 files changed, 156 insertions(+), 44 deletions(-)

base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.34.1

