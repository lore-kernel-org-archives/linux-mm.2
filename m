Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7EACCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F408E0097; Wed, 29 Oct 2025 11:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0A28E0045; Wed, 29 Oct 2025 11:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D1F8E0097; Wed, 29 Oct 2025 11:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E51FA8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC0E512B3BF
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:19 +0000 (UTC)
X-FDA: 84051611238.12.BDE8A95
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 04D8540018
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m68n5qCy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753558; a=rsa-sha256;
	cv=none;
	b=vXJFgyOZP2iISEk6AvuweyQaA27VA7BFeOSV7n8BekA7j0mQwOzqNgfvW9NyADqhnw3G9P
	4ahUbDdsiyaO5wosQ0bXD68Si/D227BYdq+aDirSow7uoo6nE7ERnHcuQmk9RbzfPL1hGy
	J1vtOeHoq2Q/ioEwY1BVvOYBMJqIyrA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m68n5qCy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sAbt8Aq11hD5HKF7vZsq1nYOhoSCTs6kYCBAgTfydA=;
	b=R2tIYBLvv+EYn6ruqd05FCzFuvmGOyVrWrqFNKy/7PCWbLUWDeTsVave+0N3Nr+7suX6Wy
	ITyC31+gGbL78r+AY7IMDxuIvoiAhyydFzzDT8eKOcsf6RG0vulkjnCXmCkZZsDb2yHiR6
	5V8GuvPKEijwuI/+3ie8bOFYTBnIQl8=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-33d896debe5so115974a91.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753557; x=1762358357; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7sAbt8Aq11hD5HKF7vZsq1nYOhoSCTs6kYCBAgTfydA=;
        b=m68n5qCyvqMci9jto6IhshvtZvEflferg5wINSXQsmakkzUavYUIIne5DDZfi7TmzO
         GFN3uLw2IfOs5wFSBLlKpJNkjrPdmjdwMWtXvk/Do13MoOtkvaTdPgherIxTLT/9G/Tj
         70cDhVye/hHtz1GbWzZ3tCE4fNHesBDzmCPVx68TQsFhLdoF9Yt0rwU3u2tD+4KwRGZW
         IR/ZAxtv6QNQtsJ8tOOkJtMg/yQ0oqQkpqNLp0GcN9gchE3PGAqi6ZIVPFgBmpJyNCKg
         KglbT5U/pGXen6Pr3S4Mlbj/VB1HfQTpoAwiIAr+DqtwqYyLmY553VoBqf/hXiHinIvN
         Zwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753557; x=1762358357;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sAbt8Aq11hD5HKF7vZsq1nYOhoSCTs6kYCBAgTfydA=;
        b=DDD4Tdys8Zpp7bvJimW6zagKXPSaE0xi5Hgv3wT48rLhNnqXiMcjB1miElzO1Cnqzg
         PxOD89ALXUCAa8ydYBIsX+rHfVMpeP+rfUi+8RhqKe2txfE8TMDcMzkjCQPQ3WqWndZp
         zCC4ytn9CPukHPpPQmYFgpiI35c5T97bbIK7PX4ds+XwQlvhpML7UQpNeJWt4jq7fp95
         ZiKDyqxp9FDw2eR1eb2M5JCBeoUbyXmtQpJ1tTnzdes/pQGct6RjgkNEb4Xei01Jjsbd
         Zg/+vxNgZE9nQ8mA1YBeMxHiMpub4U/ioUuH7F9gVcnRbUrPUem+cL8ET7tDMMQS8rMJ
         z4wg==
X-Gm-Message-State: AOJu0Yxs/mzhTl+raps/CzlgdFC/6yBPnCanTcSy3ZXYNmjhZJnfbphe
	yeRniI42L/D1orj0SmO2t3CAMtENtO4IHysdRX4kcncfl4/OeQdlLUxr
X-Gm-Gg: ASbGncvqa9ERRbm7O/KkKBcPV1nIucZ/aj+1cUJBwpDi0sJnAO4e4SEdvlewkC9Pf3K
	xV/6qEBmBfDu236wyd180OqcqV1jgdBG1saLG+M/YyezmRlIvasT18pVrKgFbfYlIjuiTX+5mFx
	Q7HrQL+Bpt4Q5gm0OC/AtXtdQqE+zPxB+vhW29r1jdBC4J27Gd/R+L1eC846PvsblVjYqdA7vyo
	lpJjQYj8UKW7zhPotc/8myzdrLn/FfEfcgEIztXUhk4DxJCpDnDcBtVjvzYIu7m9gJ4JIPIvICM
	Tci05qCNlMy9xSqUs/GFq7N9pLVPLBO7nSCDK0C+xDLkyCpQTer3XprNm0m+ABvkLgBjyBgYFCi
	w8MXi/nO4Zb5ByWxEXNqCW4k+e+Y3kOeOFMu3vnaoS6mvXgOhDZ0ARvfsTzS245/KT7eNhPYJ/n
	8XrvTUzTXbaQd9hltXa3B/
X-Google-Smtp-Source: AGHT+IFcx/tNH+mGfenFLGtMHSLOQFDVYtyEct3+kZwXnL2FV+gWAZHMp+QdJZXOLxNVix81OWQEkA==
X-Received: by 2002:a17:90b:3c4f:b0:32e:5cba:ae26 with SMTP id 98e67ed59e1d1-3403a282201mr4126488a91.23.1761753556776;
        Wed, 29 Oct 2025 08:59:16 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:16 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:30 +0800
Subject: [PATCH 04/19] mm, swap: always try to free swap cache for
 SWP_SYNCHRONOUS_IO devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-4-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Stat-Signature: dycmiamx7wxhuxtfpc43t9y6gfxiqwkr
X-Rspamd-Queue-Id: 04D8540018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761753557-22167
X-HE-Meta: U2FsdGVkX18NxSOKg9P/cNklDGyboSzPbpNVkmEx3YTtGxCPf0F+aYnlxnb7V+7aqvn8DnScw2IQh03d1Qu2w96uWdsXyVBOor2TKSNjaFlam86hb9/EQpIsA/mSmpWRrA+wSSUgRPfh5YEerHpebbKV2eB+yKrFYgAVx5vMwr/FM4SBxl4svHRgzOZOrL97ln8LwAe9AvLFjiB86MAOqP5FGXmOgz5ziNSNtxscyijBupY0i8zx80rHt28CVngQEzxBJp63nRQTuLZmMHqivCaoUy3rdblH99pQ9+1MuME5xb0GG3YGmecYm7InRFOviTL5JrEh6ydjmxgIPnXcVrwaNYezgjAwk+y3UhqOLcK540bSaC9DKTCd4Aagg1pvu1oNhx8aFo+0FjswDvQWK6KdWUMVsQdEacN+uPlzDUCqxQgJsEEYUV9BYVOOFdRQh5SIE17+zqSpIJPgcJ1uSFp13HYDPRjyh+Q6CCaKpKi2yXRpcTTtMoLYIjO0+xCvyUVLD4fqvkaG5p33bBtg3lsermNeMyQJEmESwN7lupXdmW8Q4PlbLS4CQgPE7AmurzPA3FPoMjsNbEAQmKq/akaM4zLkywB11HqkMX5qDeKY1oIgyqf52hfBs/e2Acft0wC4vJQwGt6wo8aimEl93OBE4WOwUv4TR4JqmChgn3AqnE+8iZ1rq+LfgoR+/FzK+v8fKQHiAv6L29IDD/w0zl1q9ofuGb8GathW2lqMAhplm1mGkR95UfcHWD9UfD3NAMgbaYMhBP9OJ9UEK7+aZqxrQXLkdCIZSulmxBXmJJN4cSe/0Zy3JpkFQcUitEWY8gkl+IOPsVqPT0ImPTVeIqey8x0FLyDCf7MFX+/nLlnat+HLTF+BxEUiK8DCyeP6gxAwI7p2LoY+KKr6WZYMEAA+yY1DdUdlmqGffKv0W/SqIm24ZCnbLqanml9RpELzODsHmh8osVGzhbkuZz+
 Z4jKC199
 bSHKnijxrjHYD7v0Be+HYZgsJenz9JWu7tM3/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now SWP_SYNCHRONOUS_IO devices are also using swap cache. One side
effect is that a folio may stay in swap cache for a longer time due to
lazy freeing (vm_swap_full()). This can help save some CPU / IO if folios
are being swapped out very frequently right after swapin, hence improving
the performance. But the long pinning of swap slots also increases the
fragmentation rate of the swap device significantly, and currently,
all in-tree SWP_SYNCHRONOUS_IO devices are RAM disks, so it also
causes the backing memory to be pinned, increasing the memory pressure.

So drop the swap cache immediately for SWP_SYNCHRONOUS_IO devices
after swapin finishes. Swap cache has served its role as a
synchronization layer to prevent any parallel swapin from wasting
CPU or memory allocation, and the redundant IO is not a major concern
for SWP_SYNCHRONOUS_IO devices.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9a43d4811781..78457347ae60 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4359,12 +4359,21 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	return 0;
 }
 
-static inline bool should_try_to_free_swap(struct folio *folio,
+static inline bool should_try_to_free_swap(struct swap_info_struct *si,
+					   struct folio *folio,
 					   struct vm_area_struct *vma,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
 		return false;
+	/*
+	 * Try to free swap cache for SWP_SYNCHRONOUS_IO devices.
+	 * Redundant IO is unlikely to be an issue for them, but a
+	 * slot being pinned by swap cache may cause more fragmentation
+	 * and delayed freeing of swap metadata.
+	 */
+	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
 		return true;
@@ -4935,7 +4944,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * yet.
 	 */
 	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(folio, vma, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);

-- 
2.51.1


