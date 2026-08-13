Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 752AEC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9E76B0290; Thu, 13 Aug 2026 06:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769E96B0291; Thu, 13 Aug 2026 06:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7276B0292; Thu, 13 Aug 2026 06:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9026B0290
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:51:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9D5240641
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:51:06 +0000 (UTC)
X-FDA: 85095928932.02.621F5F9
Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC0784000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:51:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f1JAXQ9pxhh2Uji0rKmvIcRtYDYsF04BCci/9SP1GL4=;
	b=gpYAhsHZCSCMebx1XCoPt15vXnBonVQwIZRV+5QgF6IV9ZomXOd6AuYCDkMI9e6QdkHhU6
	51cWOIJP8zWVLjP4sUbhjRXbEj8AZNgwEwHURDkVYRvi0yx/4cZo5vyg1uUSFt0J/KNEtq
	bEtXnx7rk5xfoK5i/E9lViE4hdU9j5o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.124 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618265;
	b=NMAXWFeNjTt6sbi2DDCmT1knYs8nXC2PkkQzFWSsvatbhLSy8E7F59Gt9peF/G/GaGHmfN
	ARBTIGQf9mleURYIOIMs89ARNo2bIC1Ki19dcXDjgljFEEMfp2bzKkqLP/IXS4Yj6yJbKN
	0yQc/HIdDooGEWa/Rqe+N3b5lVE+kzQ=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 4a1f0adc64f58fee;
	Thu, 13 Aug 2026 10:51:03 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 15/15] mm, swap: require zswap for xswap devices
Date: Thu, 13 Aug 2026 18:48:54 +0800
Message-ID: <20260813104857.3450386-16-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC0784000A
X-Stat-Signature: fzmiitzbshxji37mrfhuyogufieyzkhh
X-Rspam-User: 
X-HE-Tag: 1786618264-84454
X-HE-Meta: U2FsdGVkX18uKFosdGyL+1x4ZkH91C+RSVBtZuuzACKgnDJcZJUDzmhT2/itzdaVAdFqDejG2v3QSaRNYeY667J5ham/2FZ/munGD8rDAG4ZLlWZVCcSa8BVPBbD9dH8BaInEZ5V7Yb4mdIo+qZ4PF5tRp8Z6tx8DhHjrYV4v9RwOAmOinFXfOGBvM1WF9+UtdLh13p0zCa4b2FqT40iP3BzgkSG1NdMhC/wkr2PMCAdvVYMe3bI0LWP4KImNfDwtHWM1OkBNE4WZQ++0POWBgrq9LeuqCHCfAwoKp66ou9USx7k9S88PKfSbwaA1OjdWGfafayvC1cL0yX+/s+kwEbTiuztGMufFWt/q03maNew0eTOK+Bx30P9Wo7qz7h2WvgoThn8TvtyRxFxfMYnZ0r5d75T57vfjPFrsywA19ozLvzePcV/Bn6XS8CQ8aqyGd8yOAgnuFvjjzp1tim6PyEViR1WLi1H8ChGTujqhPYQzHK0RTXE970gYg9Odah5ppikWt3n2pldqCPGq/j/g9KMRf1cY1KVY3Eb94lTGVsfL+uj48SE2TwTPIuSGqAvyU24olMpC4DlRHlNG2bxp+2ZpK/k/1quZzpNxxAQ12yPJvNUKeeAtXazTpkj/p3XAF4r3lw/SWd3O47IQuvhbTiIflDEFnIhLCdjXy6CiUxsCmD1z6yUkgoxqkzO3+tVbhIcBwD3LWMgtxChWWwNqj35Gv1pIyfpwFu3PJ1jctEBN3dIXWK4oyMyKMhDwbSqPiI57chh+ie94HeZ62wFJApCy8h5FQcEvvFJxokpZNc0xOmrVwfpghPQghy4Rf7SBadolG5qgs5zfXCZaYbqkpmrbQxA9TlrqqTRTB41/VCef20kRBhQprsMdLzPcMljZ/V+Lk5TkXtsjnv4TS0Wzx2ffmK+USelcHWqCp/5lWD0mQQdFzzvpA0lAXNJ2ODQBILAd2FPhelLGJWvBHN
 cAseoMNu
 3mHQm6Ftw/MPUczF1wv1+WLIB335mkQq2FQXQet8Iy/gnIiLZ13cF+zoghur8xHuPr3YFjvMSYpm36zEFOcQPIjyyHd01UDzKr3bs2xoAI/B/lq10QLUWRsrHBOAYnsZ1TqNvZKdxdqhjPxRA5YcnRzMxZ1EG+mH/QKMpFaddNSdzdJiV4Hkqq0rlxPEP4PFCZCwcdjxUcMPXJCn3qqdwfxjj7T1q5YCunbNyuE1/bXpsWo5I6SjC9/camSZi3Hw8dhCxAsj0drMcFdMmkfj6SMGJlvm6w/tDOk2biXrQb8SvKhkYalblFM2FVHOZxeIL1vcF0qKg+DQDHtJhgxBekGncqeE2JshFvJloorHaD3oHKvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap has no backing storage: swapped-out pages live only in zswap.
Without zswap, swapout always bounces back, so the device would
consume swap entry space without ever freeing memory.  Refuse to
create a device when zswap is unavailable.

Runtime disabling of zswap after creation is safe: existing entries
stay loadable (zswap_load() gates on zswap_never_enabled(), not the
runtime zswap_enabled flag) and new swapouts merely bounce back to
memory without freeing it.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 61c307b6a432..911bf3b8c863 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4340,6 +4340,10 @@ static int xswap_create(int percent)
 	if (percent < 1 || percent > 100)
 		return -EINVAL;
 
+	/* xswap has no backing store, it relies on zswap. */
+	if (!zswap_is_enabled())
+		return -EOPNOTSUPP;
+
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
-- 
2.54.0


