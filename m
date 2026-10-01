Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADE4CA5FC5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70A86B0096; Wed, 30 Sep 2026 20:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48A86B0098; Wed, 30 Sep 2026 20:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2476B0099; Wed, 30 Sep 2026 20:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CBC76B0096
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:14:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0065540274
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:46 +0000 (UTC)
X-FDA: 85272136572.01.D610801
Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2BEC020008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NjhK6ZPy;
	spf=pass (imf31.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.37 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790813685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiwKC3B6R+JkPafV6Q9DP9kax3XNskKt8f/l6UnpLUI=;
	b=32CkRb+o8uTZ5HgbgyhA9HPGbNcieDbq2MYZzSJBioIp5m97tqOK935bFXaiA2yDaO6j/2
	jssK1AkJQgz6jX0zBaBLCqChJZpOUlinBO7MbvxGz/UMSLqf9HnBGaceVa2LOwvBX0DMOa
	+j0U/0vtOuGKimfTeFRJ4iFXOhkCcns=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NjhK6ZPy;
	spf=pass (imf31.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.37 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790813685;
	b=nReWBgtZvI1GEVhRGsPKR2SQYbEw3xhgLnTrDydnM1uqd40NirvPXx9/07OfpMOQiktNMa
	qhk9VIVQO+z3qRBtzPnlRrekbNWv3H86MMlPqVjOxQLyUrHNTzByeH8OPQiScmyrtRPv1E
	n37VRKV2p2ZIxUsmcsszBpnSsnjIfbo=
Received: by mail-pz2-f37.google.com with SMTP id d2e1a72fcca58-887c067c816so389290b3a.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790813684; x=1791418484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UiwKC3B6R+JkPafV6Q9DP9kax3XNskKt8f/l6UnpLUI=;
        b=NjhK6ZPyL3DCFsHqyxJBP8qlC254L10Wwsvg0F/l1SoX8/0q85y6H5H3HuA6N9Wr/S
         D1UnYvKYxXaOetds9gsr4wuZZnJ9XgEdqjXEoVG9irz7si5iBXVhX65V3gPzET8bz09Q
         cMx948Zrvo9ZjC2tE9//h6eKinseHWsY0n1CajrrIdXYyIDzFVHW28KCwSbtS8kpS7II
         o1WTduYcCjg4up9/xawQxPI3FfkvFizGSE/4pjpfFsM0Fdbeo9n0Gayc9LREVv2RUED7
         bCgHEUKTiWAEbuhwOHTy3knoFHNteS23bJGgQm7vzlVRNYGUlpXkO4W+Vz3nYLjGTqIx
         TkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790813684; x=1791418484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UiwKC3B6R+JkPafV6Q9DP9kax3XNskKt8f/l6UnpLUI=;
        b=qGrPh0/PLOfAcGfmqZ+7NfciDtlNAkMZ8hJ0dF+ijTdXnakyNZt3HpKppAdR+ArgPj
         H6Xc7ida/57NBIeO0LHQCcE4K72b+qs5OuE2rsEDMOyv/aHIpZohyvof0CxlYJSdmrVD
         dR+E7ARWmYvi8qP7lUkCd46IDkK20c+Erov64Rn5jp9MdmEefOqP4qBSILvNKjVuQdzw
         ATaYrdI8xGEEXDh/Yp7xJa9439tjcEPgfpylPrFEBM5dJBZukcs7o7QakP1+N5M0CFXh
         8GqpR68lHxaUzmMTFlaLIMYtvky4yQAaaeDezz4xyN/aRqjUaJyxNooyYUKVVEnM2uLs
         erLw==
X-Forwarded-Encrypted: i=1; AKwUvBxuT/3+ZYwtieOFZhJSKH3QpAaByfjpFl3cOf8gQrio4xo5imxiy4EUlY2e8pSLujbR19VNKlEfUw==@kvack.org
X-Gm-Message-State: AFq9FYLgxT9gJd++9M1ktF63akpcNA/hX2/bfAoPrZQSgT0wbrhAgQ0i
	K+TngVVzxAKQk+82vQR2EP6fLrE4LXiCdy1pQby+S9jvDLhkwJEw6px0
X-Gm-Gg: AYBFou03zPlFU1C8xcKQYuUssBL9lPMC+O2CYpqej6oZQ4mMCkt4iBeK/EBCYGHk9Ec
	t368JOVp1OtfNsbRfU2OI/cJxoO/bzRU0qudv5c4cUsbaxup3Tk7e3CVEgb1hYQ1TBQqG0E0HvG
	6/hioIFblwLJXLsC/dxTgHbwQpx6f1mQEjrmo5EenHtHfsb5q9pVGAjbB5MsEYy8mAb78n7Hbb0
	Xz4Bb4sCovKMbWsVCAXE0+6UKzrMRWscfE5Rlb8QUzmorcr/3srDxcPDuhgJ7W/9rt/8DAsHggW
	b0DsXuPXGd+FPYCEX13/S3H6bfw3wC4D28dc3InsID6iJBorIeJbYX6uytVZWGSUzFFgS7dD/dQ
	u/xuAUvm4iMpecBu0fYSYmTxdLM9lZ09tR8ysS+nGBsx/Vr2eT+N64nk2xRUcJ7307ybgOrhfD2
	X7enhPrm88EgsgT6CdgHqfe4bcqt9UVP8XpyRuNEiUvrz8XYPFBUDUN8+KRF2UjmFDcVOfarBDT
	KzNxjHZsP3IvM/8
X-Received: by 2002:a05:6a00:1144:b0:874:705d:f653 with SMTP id d2e1a72fcca58-8874b7354d6mr2166151b3a.33.1790813684074;
        Wed, 30 Sep 2026 17:14:44 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88818814b2bsm253287b3a.19.2026.09.30.17.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 17:14:43 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH v2 4/4] mm: compaction: skip unmovable blocks for non-costly proactive mTHP compaction
Date: Thu,  1 Oct 2026 08:14:12 +0800
Message-Id: <20261001001412.3837085-5-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
References: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2BEC020008
X-Stat-Signature: cjtswbs8htwqqrthd4amx7cxqbtb44z1
X-HE-Tag: 1790813685-915461
X-HE-Meta: U2FsdGVkX1/ilZtH3Q/45A5yxaWzG6RBst+0dm/r1vFSZ8YA1X2w0A9xGVwJXhWp+HCWVeZ3MSnc/k9hSj0JjIY2Kcozbzr5SzR1vPMytZe0UYsAfbDB58ZauuJmyhpWDRgXSl/0l5Cg/UhJDZfFwH/SmxxwIqX3BwxYlUzWKYSFcD7JiL5eByUUMvLfLuZ+AsXRxMTFUR7ljaFWXpoi+AnflVkTS3g81pLy1ylR7V4D22sx9oT+HqgXdanc5O40hfsnRX20KimJkuARMrWnSD6iTe51tiY32lTF9jwqsH44bRzrd9dxS2sbOuhyOFVtAwydTWvUYmXa6p3FKXi34DVkOcCzP07J+bA2QiVd7fYyxpRAeW/x3qs3m+78dpm05WPA96YbftLGr5tot1nHm9KYWTHEDIKYHKuaMt4gzdSaHypKGCM8yL0nx48SqFRyOit5n2iH38hH+jbUD7cUKDLJhcWU//HD2rGFRldqgxIi7VM2H+/Llu1QHuaWiXBbwaSWnVfBFvcGykqQQJV98kWJuxY3JFTTV7Bk+ADqMfSdsnefgzzNwRTBH9WdQSWqcMKj2RMROC2XPtbDrO+NT3p+b/ubH5aLtbaZFQB+4lkw/guuv9NmZeqp8OQm5OKQE/1WMDrw5jNqaLPFgwtXfgJt/iujywJOonlcFB8l6XRVX13upnDbLPfrwX/9tb5baXM5JkgOQruVoyFqhAK3+jobtv/+eAuCQIb8TyShNUm8Lg9OX4xiZAs52VrjMY4lHspT88IzvHqIGfFbIfi8vu/TYuEqZ9LpFXICWmMlbU9EmZN1Zz505NQ9PffbVpF1dDeSP9XH/NgYMk7+pYa+NH+56KLK+CWbnbUgmXPfU7II70zT+T0kc4LUymRezxRX2N8DjQTsfHi/0YwFSQF0tw0xAs0t7YEcJv7Tl1L4d+pRmRsq3KbgCJ+WhAdA49QgifLaZFM9qtqiwQi/vyQ
 0kN2NXKK
 YR2l1iervkvrLrEvezusmWSgm2L8z2Qxcp/Xr+7iqhQCZybyu2nr6ayRwTw5+zD/9eXZJGjgNh17w8NeLSOfYXHas3oSzEpOv8Pvx4qJby9C7YZ0jl+XGcULt0qgaZVB+Iq7CwE1DIQ+A/C5c/714o+mLR7W868FT8XFQMGgILzdOsZkIiY2YaQSnfUMz2HbXRvxpXXKuajVPxvNoFPDyL23WCtYSD/EqdAKmXtfNZsOCYXK9eWb4w3HTq6UeijSTyvisQOa0Bl5ZWmZnKZwhRjCdioO/2BIjN3KP/ZLBvc6G/u9Cbc1eEl+E/hauNLYb6YQoVnQ7zqMamtjBFWh1eoCX6kcz4AzxQ3404rQ4QO06sjXXRCjTS9WX8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Proactive compaction scans all pageblocks including unmovable/reclaimable
ones. For non-costly mTHP orders (<= PAGE_ALLOC_COSTLY_ORDER), those blocks
are dominated by non-migratable kernel allocations (slab, page tables) and
scanning them wastes cycles: a small order is easily satisfied from movable
blocks alone, so there is no need to scavenge the few migratable fallback
pages inside unmovable blocks.

Costly orders keep scanning all blocks: they are hard to form and benefit
from any migratable page available, including allocator fallbacks inside
unmovable blocks.

Restrict non-costly proactive compaction to movable/CMA blocks.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/compaction.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 0ff454ee5604..deddf931d0f2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1404,10 +1404,19 @@ static bool suitable_migration_source(struct compact_control *cc,
 							struct page *page)
 {
 	int block_mt;
+	unsigned int order = compact_hpage_order();
+	bool costly = order > PAGE_ALLOC_COSTLY_ORDER;
 
 	if (pageblock_skip_persistent(page))
 		return false;
 
+	if (is_via_compact_memory(cc->order) && !costly) {
+		block_mt = get_pageblock_migratetype(page);
+		if (block_mt == MIGRATE_MOVABLE || is_migrate_cma(block_mt))
+			return true;
+		return false;
+	}
+
 	/*
 	 * Background compaction produces blocks for the zone at
 	 * large, with no particular allocation context. Allow all
-- 
2.34.1


