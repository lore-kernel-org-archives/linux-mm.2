Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC3CD58E48
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8406B0089; Mon,  2 Mar 2026 11:53:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869936B0093; Mon,  2 Mar 2026 11:53:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713816B008A; Mon,  2 Mar 2026 11:53:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3EB6B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:53:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02D3B160239
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:53:42 +0000 (UTC)
X-FDA: 84501719526.17.5002963
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2BDA6100013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:53:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772470421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=O9PI8+onFZGVN1/IhZrnsm24bf6oli9nOe6yJlIwLiw=;
	b=yR9tp7uaZAQG5zHxE6DtjZnRxPiu+pzZZ2lENfI/Rpl91ArLqL5KIxJcyWg9iY+sQ2sp6n
	wDfw7SYgWLn8tvK9T+tgYUgw3wOVm23D9paZWa7NRXuQhqPHm1pciykpHx+nWBNWtXlNJI
	dNu3EDBuSUZTOO1OjVk12fq0kO8eppo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772470421; a=rsa-sha256;
	cv=none;
	b=CpQnLWxVhPRlU11Y+wFiJnH3q1HiH/oqQAS2cGQE0iYwepl4Sr5t7+g5plhEA0tqAMKryL
	XS6SZZXn4UE1cxp3ec3iNy5RlGZZX8AjPNzAru6K5KLYAXfShlj90DDZkXA39oOgou3/Gv
	wnekNd7UaNhUGpPeExwTrbzxQ3iS664=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 3 Mar 2026 01:53:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: linux-pm@vger.kernel.org
Cc: linux-mm@kvack.org,
	rafael@kernel.org,
	lenb@kernel.org,
	pavel@kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com
Subject: [RFC PATCH 0/2] kernel/power: fix swap device reference handling in hibernation swap path
Date: Tue,  3 Mar 2026 01:53:32 +0900
Message-Id: <20260302165334.1278479-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hhxia9xigr8dxt319zrzz94u8s3cs17r
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BDA6100013
X-HE-Tag: 1772470419-500615
X-HE-Meta: U2FsdGVkX1+uYq2hV7tcqI/4dGmdXrGQi5GvumV+B6D2RNx/e4gn0L2hUQwNeS6x3Yy2Rh66Fxd3K82vqI/+dF121piv44J3GJfUI+bKHAOEJPr4/nsXLiNnhticb85prdp/Ya3NhaNscp8UJp4ZRjvKi7/Z/XvU3xWijDPYT1KnSlQPHnhOTIZ/SLdyonT875QK2WkRPZu24SAvpRzsWNvSCEJghDRG95RjKjRY+5JUk9+y/eTEBLH8EI7Md7FodYA4RonQe8Tcmczme7s3jOt0AJWszq9BbkNdmVuPj7u1znAOJl+d6YQPULNI14Qx0LSfmr1LjM5yHdXREyLH5x+AVyflYGcpSPWM8yggUPlpgQYVHCTH/RciHGNuWOFCp5G5sQ/Lh9P6WtcKXLuAmSvCzhcIwG5CuF3SK4vgM5vzHpR5027qmh3Zn6JNDpVMGhLRsnHpULLqsARCSV+/RQGK0CR1NX4w2gFVLc2JM5UNnv3tqDSoVSXD67GpEoIPc1hLVOqbP9SR66It/XcwWGBK1Ix9nhZLuVU2yEv3DDINVU4pO+6cwyerKGv3HJosWm/xuFSR9qVGFuT4DjgPchJejuJ1QtCCKoJ7450EpxRzDkCrE3ea9BVA1GjjQmXME+P8PZ0IICv6uFrbIbQwJHb+ntfGZXnKERGmbCVk7owKL09lk5u2puMl+mFJA6cLCt5uSPjA2njsajIwT4rOLoZY8qpzvfQ7vTB8zOgsOCKHbAHZQPebu0BOjeGDLawNWAaKVXME3cuCByVKl8kzfZn582gWFWqjmSHmbLYJrV4CxturR/rqrWXU7pyAoh8cejh/UqbP/XKzc/TDBxoHCSPQGGsxGNCpjTPFpVbRb74ZVawFkmuhgHhUgh+fMGBfswm+WxmGYyJ06k1A+MPDYhoJLJIDicFlB/VlHlfA+VOAbWgCW7FyuTny8zj7NdMA+CxpyFolneDSIk9/12o
 E0gDcwlV
 QlvScpPzbIPD3+feYg+6IQEpb6HD/X3z5K3ItB1Y6lMNzfRUk4ZYfTgyh+0L7nOREvQ3QtCZ9+dYcEFy4Bcdktm+Ol/2OII3SN5r0f/j6f68Ge4hjcCrGNb6GzGFycd37LPAi9rxc10v7NdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series addresses two issues in the hibernation swap path.

First, grabbing and releasing the swap device reference on every slot
allocation is inefficient across the entire hibernation swap path.

Second, in the uswsusp path, only the swap type value is retrieved at
lookup time without holding a reference. If swapoff races after the
type is acquired, subsequent slot allocations operate on a stale swap
device.

The fix is to hold the swap device reference from the point the swap
device is looked up, and release it once at each exit path.

  Patch 1: Release the reference immediately after each slot allocation
            as a preparatory step.
  Patch 2: Lift the reference acquisition to the lookup site and place
            put_swap_device_by_type() at all relevant cleanup paths in
            swap.c and user.c.

This series is based on mm-new.

I'm sending this as RFC because my familiarity with the kernel/power
and snapshot paths is limited. I believe the approach is reasonable,
but I'd appreciate any feedback before moving forward with proper
testing and a formal submission.

Thanks,
Youngjun Park

Youngjun Park (2):
  mm/swap: release swap reference on each hibernation slot allocation
  kernel/power: hold swap device reference across hibernation swap
    operation

 include/linux/swap.h |  1 +
 kernel/power/swap.c  | 12 +++++++---
 kernel/power/user.c  |  9 +++++++-
 mm/swapfile.c        | 55 ++++++++++++++++++++++----------------------
 4 files changed, 45 insertions(+), 32 deletions(-)

-- 
2.34.1


