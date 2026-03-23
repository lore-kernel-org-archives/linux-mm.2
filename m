Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FAEFF483C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721996B0088; Mon, 23 Mar 2026 12:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9DA6B008A; Mon, 23 Mar 2026 12:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F3D6B008C; Mon, 23 Mar 2026 12:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48C416B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:08:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7B145C3D7
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:08:30 +0000 (UTC)
X-FDA: 84577810380.05.BAA7443
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf04.hostedemail.com (Postfix) with ESMTP id AAF5940018
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:08:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774282109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=6xi62YtwX1GCa5skL0bguzc2CXWXt2PlBMpaMtesKRQ=;
	b=YQiyh1O3/s75LsiDvgnH4NMEBlHrJvJECPeaYhWSpcDzIGLQASXPxnkiHUqMSVgJl3jemp
	YRsBqvrS8uwsB/3zjTwHKzuCHjX1ljZomyukZlJa+NYx/yEYVqfsPw8MUbxhJ5XdIhAdSd
	Nk1bLylCRZSKKnK7rQ+MO5C8o4jVEOY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774282109; a=rsa-sha256;
	cv=none;
	b=gUb/SFcnfZtTdw9KS3tb2ypE2T3u1MOdL16ytfg3V+ty8rgxWDJfNOeA/sW8J5ggnrUlHq
	86RnvtmxmMaVa4+JbARfX2YYxK5iUCl5eC3u07sqonMAl0cpQVRL+UHumI7jl2QQJN6q+9
	J5xmksEXMIUDl3Y0gYse7++Tc3bZ+to=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 24 Mar 2026 01:08:24 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: "Rafael J . Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Pavel Machek <pavel@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v8 0/2] mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device
Date: Tue, 24 Mar 2026 01:08:20 +0900
Message-Id: <20260323160822.1409904-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nwubrpjm1iddtftzz3du3sbu5qqcstu4
X-Rspamd-Queue-Id: AAF5940018
X-Rspamd-Server: rspam09
X-HE-Tag: 1774282107-292541
X-HE-Meta: U2FsdGVkX1+fbDQ6QpbLKbABJGMpFVh86WVw+Pne0U0mvEXqtUkC6/g/IvKIOnixiq1TwpUecmCJHYcd/JMwJO384uNI9FDYPgL9m6Wn7aOhkQA2sYv3cJc0thQbLatpoFYp+af3fiGTX9UBPLOFsjArc0EzZ68ju8pED9WRUFOvEF/T5TxZwa/JsjcP8ypVihVwoHi0BQxdhl15RrUHFPFT4AUFJ9V/kkoqpZoBo1moCZTv7vaU9UJh+oxf2uEOkSetmsd+MQYkX2FqU4oWxlwvpWHMcfQIJN4BkV7HqrhNBLW5AJqPCloF5untpN4Qsu2AdQWI6KbwH5vAT22Tg5xBCGJVDCpIRhy31NgElj73BKBCrm96SjQXfgKO0FXkRQ0QQGC4glBOFwup3TFn6whVLkbnqerCaBA4KhM0OBHPpdxZ82hnnHQcFCLqPOv/urLONP01QEbisik3WeG1Hsm9F843pbJph5dCBg9qvKHJe8IhzCWFE+s0y5hDZYHllnhLdicAphRkZsc6n02RcytCKFvmvLvAc36UszE0mMDbK/owVdmfvsF/epdfgmBzXIOz8TIwE8xFQ7upQ29HZiKy2qqaeS6HAEk+OhZBF69g37hsvercgrztweTvuJ28eKF87WjQExXAg8b55l2pIaZrULNUoywMbQaO2Fq2ygU+dxu8plAlEANXGGdPbpXjiVAA99v6fjaW/AdwRj+0IKGgm75eCIZboBW/rC8XxhxNjzkBE3cLBBYVQ9tg16a/fESrJYdhp2DY0DA2TMbO5F5sTTtWt7LvWJU+filY1+1Mc+g2woxMcCPq3vasFVH7UAF5abeQLFxeI4i0eQag3tRw956sZtkdTGoi1NvG8GuOEMw8T15KvjMA831yeQCP1SWhyUjb3vzTsWfZA5X8ZNj+p/kHpL38ECOmsk0Q8qfrlsRs9A81U0llx9Z1k+ZQyAT6ALnjw2GwPbbAXzx
 BHBXactm
 bCKLJM7SikJ4OXb5drxXxel3ExRc9by+jyOzICMvYdd22NCvw9OiDnf0vQgVk4b8uHNpY59fhLJ0maTTbY4e+07PWHDjITnTKrdFm7AvTZFvgI8heHZwZBQvGUdg/ellr7z5L/W+nlRLnn8kAm3OAnQFEiLO68uL33N4jmV/IE3pULRCwP3a3rtoQC0qfK3UqEydjiVPGsec9ye9rKTSoSo9+P6xpaef1nJ5EpMWJMFomBQ1xn7iD9ZRJPQ==
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

Rebased onto mm-new per Andrew's suggestion [1]. The si->flags race
flagged by AI review in v7 (between SWP_HIBERNATION and cont_lock in
add_swap_count_continuation) and the proposed fixes discussed there
(atomic ops for si->flags, or serializing with swap_lock) are all moot
on mm-new since Kairui's series removed that code path entirely.
kernel/power/ changes are small, so Andrew proposed carrying everything
through mm-new.

Rafael, could you ack the PM-side changes?

Re-tested on mm-new (c51ea78c5466) with hibernate/resume cycles and
uswsusp paths. Also ran an additional round of AI review against the
rebased version, no new issues found.

[1] https://lore.kernel.org/linux-mm/20260322093038.25a7fd51f5d564b85815db7a@linux-foundation.org/

Links:
RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.arif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
RFC v2: https://lore.kernel.org/linux-mm/20260306024608.1720991-1-youngjun.park@lge.com/
RFC v3: https://lore.kernel.org/linux-mm/20260312112511.3596781-1-youngjun.park@lge.com/
v4: https://lore.kernel.org/linux-mm/abv+rjgyArqZ2uym@yjaykim-PowerEdge-T330/T/#m924fa3e58d0f0da488300653163ee8db7e870e4a
v5: https://lore.kernel.org/linux-mm/ab0YEn+Fd41q6LM7@yjaykim-PowerEdge-T330/T/#m8409d470c68cb152b0849940759bff7d7806f397
v6: https://lore.kernel.org/linux-mm/20260320182227.896f9ab62d62961b2caab5f7@linux-foundation.org/T/#m10ee3346cd8dcd052749105d9a8e2052dbf3bc80
v7: https://lore.kernel.org/linux-mm/ab/20260321103309.439265-1-youngjun.park@lge.com/

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
v7 -> v8:
 - Rebased onto mm-new per Andrew Morton's suggestion.
 - Clarified function comments (SWP_HIBERNATION pinning).
 - Re-tested and AI-reviewed on mm-new; no new issues found.

v6 -> v7:
 - Dropped Patch 3 (pm_restore_gfp_mask fix) from series as it has
   no dependency on Patches 1-2. Will be sent separately.
   (Rafael J. Wysocki feedback)

v5 -> v6:
 - Replaced get/put reference approach with SWP_HIBERNATION
   pinning to prevent swapoff, per Kairui's feedback.  Renamed helpers
   from get/find/put_hibernation_swap_type() to
   pin/find/unpin_hibernation_swap_type().
 - Renamed swap_type_of() to __find_hibernation_swap_type() since
   it is now an internal helper with no external callers.
 - Removed swapoff waiting on hibernation reference.
   swapoff now returns -EBUSY immediately when the swap device is
   pinned.
 - Updated function comments per Kairui's review.

v4 -> v5:
 - Rebased onto v7.0-rc4 (Rafael J. Wysocki comment)
 - No functional changes.

rfc v3 -> v4:
 - Introduced get/find/put_hibernation_swap_type() helpers per Kairui's
   feedback.
 - Switched to swap_type_to_info() and added type < 0 check.
 - Fixed get_hibernation_swap_type() return when ref == false.
 - Made swapoff wait interruptible to prevent hang when uswsusp
   holds a swap reference.

rfc v2 -> rfc v3:
 - Split into 2 patches per Chris Li's feedback.
 - Simplified by not holding reference in normal hibernation path.
 - Removed redundant SWP_WRITEOK check.

rfc v1 -> rfc v2:
 - Squashed into single patch per Usama Arif's feedback.

Youngjun Park (2):
  mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap
    device
  mm/swap: remove redundant swap device reference in alloc/free

 include/linux/swap.h |   5 +-
 kernel/power/swap.c  |   2 +-
 kernel/power/user.c  |  15 +++-
 mm/swapfile.c        | 203 +++++++++++++++++++++++++++++++++----------
 4 files changed, 172 insertions(+), 53 deletions(-)

base-commit: c51ea78c5466be89914cbfbe2618dea67026c2b1
-- 
2.34.1


