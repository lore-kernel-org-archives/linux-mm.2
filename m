Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19004C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347606B0092; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EC16B0096; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C416B009B; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 052816B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9374FA0165
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:34 +0000 (UTC)
X-FDA: 85136539908.05.DA892D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9EB8C160002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jf5rfTik;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585192;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1NaZhy7K71qTHqCgzEo7uhdf+4ntNxAB3uAJ4u7EDLs=;
	b=5Sl6E5sKumKMSxrEVv0V0/hXAzJQ/3Hb4kXsusXvk8DrGkGa0viOmCUVKlSbSmMjdXDxAs
	RymS6y61A/6vp3sY/8bJmzmR8qkitKBiY+yU9/nMk5L1jLnR5VIWGf6uSkIGuuXcrgYoXK
	s89wfFAKM0gqoC7C2VEbX1GGXUcrKOo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jf5rfTik;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585192;
	b=HdABOrAmkeVTbeORkMQ/WTdRNORlTB59PCuFhmMZhyhwYVVu7OSpamF4VJF09HIqcZYk0t
	JiOZJ2SiI+NNsSLHxjj4Sry1KFxuh+4SmoJhp2NUrhPgMmna5JGywhfEsLWB8AtUzHZ/W8
	HMbB361Sa0Se2QsV2gCEqzX58taJGV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 267256011F;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C059EC2BCF6;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787585191;
	bh=h/haknnj8pSvM1JoVwSzP1DECAsXwqNBvWxA9kRJxV0=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Jf5rfTikOx0VrEQU0bgQUo3pujh8B4YWi731mwpPplwS/taKWi75TM6Y2TKXjUcmS
	 CZaMT7fNaSOpQwcw7oCsPDnWUxGZkgiFLCbcUPC77dJuLpMOz7X19arlua8J2B5GMW
	 AOJ6/dhoR0ZwMA10lFfnd0xGKuH0wYCLVjMqEJI0IQXi30n6NRyPkq+lZUBf428eIz
	 aifkyB5AiNnLJoBLY5GhWmQFD+Ur66WjX0nMts43WQIK7z4JzDBCqJjBPi/HJficnk
	 ooOaDTN5TVkFIkfph97cjhBz1i6Vw4dFKYeWAQgL7+IWLVWjGcDfO4oAHNXBm6sjy8
	 1giYRuMAVChew==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985F9C5DF81;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v2 0/6] mm/mglru: clean up folio counters and flag usage
Date: Mon, 24 Aug 2026 23:26:27 +0800
Message-Id: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NQQ6CMBBFr0Jm7ZjSIKmuvAdhUaZTqIFC2kI0h
 LsLuHf5kvffXyFycBzhka0QeHHRjX4HecmAOu1bRmd2BilkKVSucGj7MKPtdRuRetZ+npCouJP
 VprwVFvblFNi691mt6h/HuXkxpSN1GJ2LaQyf83bJD+//w5KjQGWaxmgSRip6JvbEPl1pHKDet
 u0LpB498coAAAA=
X-Change-ID: 20260818-mglru-flags-cleanup-cc49cfad654f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787585189; l=2302;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=h/haknnj8pSvM1JoVwSzP1DECAsXwqNBvWxA9kRJxV0=;
 b=a4Y23NvntoKAxWeXth0PVBJK9aQsc8tTuri17H2veCuuj+DP1oDuHP9/uIBmNoeGrNBypDJji
 9B/iyN22v/2Bs99/hfZzTq/PeAxTqFSLKyQcHl0lLzR88jeEEb7aKST
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EB8C160002
X-Rspamd-Server: rspam07
X-Stat-Signature: 4hfkoxhqcn8bk8qhqzncgmkq5rgar3un
X-HE-Tag: 1787585192-600754
X-HE-Meta: U2FsdGVkX19yquMjMwJgctcRj2JbtT7NYPM4XgYgZY9wcPN4l0zy8PPl6mWPYHUWj5Sd0EQXJdomfJYk1m9/UpxJAQwcKuqUM49RW+8gUTpQYjxIRiyOyhV9Y6S3KdGqTFdvdGyuFmgJ9syxznbLsrGeuWA/u8QnA5mF0/veocD9Lr6biwVXcixyo82GZJ1BqRZPnWATMbwFLzszZvAtPQCwXa1oacePK/AyzDr2ds80SlcozjxgHq5oC2EKTRsMA74Ou+CRaIVKQWJJkMCmMDcQ08jxm29yIyab8vcP1qNCrw2t0FBsvun1ZKyfTj3IQBvXaqcUvb8MKF57ipyy2zydlbedU+tSRm4GPCeIxe5ckTiUe4D1bdiFSQA7nvilhgDrH6+4T2AwmPsdW7I4SQBirNo5bsnLX6Zxlwxni/tfndAiDJBNGRYJeHGlDptWShf5ha+wXwinSxYJGUrg5iVydSLkoa7DHvnPVG461MB5clupoZVqr8Ard6CXTuERwCumStMGEsPi0NwsDXNIZdSuzOFAAKWp9AtrGrxlVJCY6GSuWbiLxoWOV1gZjFPgtq5B0GyqvxzyrqxsItN3a4T7uhWPavxqr0j7/hHibrg+bnwSunZjtXu+jneUlZk4nDN/hTCmr5cxJ45IO83zYnnITGQclGQ5KMjYM84S1qhZp+8FBvoQMGUNNr6b/Nv6OwHR9NrITmxlGtuDA98qt7O3vP71ejtQGrYMeUUBWtGCbsPxzyTmatVBPF8FcAvdwhxFrlmqedrALso9Ud+XUJGTyq2F9pEDwc/hnrcpzhvO0UjwI5yzdb5Akib4rnWR2o5wN1EaH/AnK9H1RWI6NcqYvsK0F5ZuhooEPJlhumSeIwAF+OxFu2U8ujK0IwhAo5QTDTQk8sLQAzGxV/p+iwXxZn77AAJkOPQwggLTGcO8kV9fG+oB9EQyh8Rl2mhpng9/efkz19k54aN/ZGn
 gvHRQ4Ez
 oO9yehYMSFZ7N0CgqGMpIPQ9v8LxUJPySuiYDL/l+W0pu7IkG4veZIyy2LjLrdRRY6H19P9p7e9SyoTP2N03LqqselT1CTNZ92LvRTjqBvljy3phe8Xc7XCSOHHKAYpFcj38z1wGnuTFFuciZbXAZJ822NTJPKpBEBbSx71KetnvUNdarTd1/+d3Leyo92HM0qQ3JGM4K4hb5OdlJIIaZJOihPP+PsRJwj7ej9sHDgWzSvjOtDvBUzX+b84RKnlaqybB848CQmAGcVKZMp8cf6hEwkG1zpdcM0Z3H4+aXLruSYoftWAopw8TZwtoKyXEG27HuWb1cS1UKXnUjCUqb+/N5MQ3i+opqMkPRTvejk4f+SoSC40j3AShz4W2w9ajD3t4MN6GdEdzxzhcwJoNuSN8SrwMmSKn5OaOdAWZ0A6wH+EeB417qB02moXaxWcxVqN3z0rUDVsS0CJBjP14/6vaOxtAy6erowq4RJ2RfcJ49N9ZRgahP6komFmnYl/SI5vfc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a cleanup series separated out from the MGLRU-FG series [1]. As
that series is getting too long in following updates, seperate out the
clean up part for easier review and merge.

No feature change is intended, except one bugfix. It mostly replaces
the open-coded bit operations scattered throughout the MGLRU code with
new helpers, with proper kdocs, sanity debug checks, and hardens a few
MGLRU functions.

A subtle generation counter leak is also found during the refactoring
and the fix is included.

Also collected review feedbacks on the cleanup part from the posted
series.

Link: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v2:
- Dropped the redundant LRU_GEN_MAX macro.
- Renamed folio_migrate_refs() to folio_migrate_lru_refs() and reworded
  its commit message to describe the referenced state being transferred.
- Rewrote patch 6's commit message with a detailed analysis of the
  anon/file accounting race.
- Dropped patch 7, it doesn't really fix anything, and might be in
  conflict with other updating series.
- Collected Reviewed-by tags.
- Link to v1: https://patch.msgid.link/20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com

---
Kairui Song (6):
      mm/memcontrol: make lru_zone_size atomic and simplify sanity check
      mm/mglru: introduce helpers for manipulating gen and refs flags
      mm/migrate: copy all referenced state via folio_migrate_lru_refs
      mm/mglru: move max_seq read into walk_update_folio
      mm/mglru: use explicit tier range in read_ctrl_pos()
      mm/mglru: fix potential generation folio number leak

 include/linux/memcontrol.h |   9 +++-
 include/linux/mm_inline.h  | 103 +++++++++++++++++++++++++++++++++------
 include/linux/mmzone.h     |   3 ++
 mm/folio.c                 |  19 ++++----
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   6 +--
 mm/vmscan.c                | 117 +++++++++++++++++++++++----------------------
 7 files changed, 175 insertions(+), 100 deletions(-)
---
base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>



