Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B36CF8549
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8926B002B; Thu, 20 Nov 2025 02:11:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0326B002D; Thu, 20 Nov 2025 02:11:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECE86B002E; Thu, 20 Nov 2025 02:11:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9AC6B002B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:11:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D11111407AE
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:11:43 +0000 (UTC)
X-FDA: 84130115286.10.B3BB499
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf10.hostedemail.com (Postfix) with ESMTP id 968E8C000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:11:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763622702; a=rsa-sha256;
	cv=none;
	b=wP6au5sfWc9b/5dzRNNsWbmR8c0wG3uHBO+9X7oNQd5H5GJWR49gCqO71rqfmUEGsy1AW6
	7vkh1pOxiA3qMPVdTtddarsJKiq+w2HWL1VjK/6cUpBXZTIc6DAjOgEWaC1qiaWCm/d0df
	l3lvmofoZ51JSaW6SzljNQQ/itAfMXM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763622702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7zeYsQGOfzlvL8HaDkGT8eUXUXOs3a9UD9O60DqZxSU=;
	b=XZqxBUFiDbmMl+Yk06uknS+OmRVGz6hc0dQ3yBgaQsXTkSfvCbQGhy97zLU1eZi79T/piz
	hSo7IRe/q2SzBPzacLaccub7UMEX2hIA09HqIY+Yc7OMv+Aj2tpxiR9rXinJCNDvMP7+25
	z9WVlcfe1iEYZhvRyXfzlVkP+mdVJ6U=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 20 Nov 2025 16:11:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 20 Nov 2025 16:11:37 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 10/19] mm, swap: consolidate cluster reclaim and check
 logic
Message-ID: <aR6/Kc0kag8Z9y6y@yjaykim-PowerEdge-T330>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 968E8C000C
X-Stat-Signature: kopa4jik8gmkbsi7tq6r11ytgca8w8jf
X-HE-Tag: 1763622700-462176
X-HE-Meta: U2FsdGVkX18Gj1m585CRScv6Ismm/0BypW/U6AOAZDW+k+Tz5gizV4DPbDstA84ZGlPU4aNxH6AX6eSJOMHBpv1EZ7JLB/pQzwDbEgqLS+7yrn25bqm6XnXnzyP0VsyJi8k4I/7yR4FRARBCpNkNw2O+4fB8PXrBve3l5z3VaAd4eUUCPT5fbYrb2tp7rFe3iAxWBzZdXbVnPdbdd+HJnU3jiO33jQMQgWnzbQdhhaS5HzNEL5JFne3FEGDJnECpXBzPtQI1U6joY+NpiBdLEUQT1DIkbxMIe4TTsOZ6jmiSnzbtJbPpWCf2UMful4oX2bqDZHqmVegwUD7/yRHOs4BL8bUUd0amVox+CxUFyoXFNoAwK6KlatfUfoDqmmxOW6cetQbCn2XVnr/pugob3zKfzH0GypaptzZ71l7AekzmPjnkJYu1YHe0Wlli79td57hT1/vk/pYgBGjTOKEZUSmz9UoRthgel0FN4NPtLcS9fDj/+t6SGseoO+fHlUZc//lvVLHiIoh99mS+foVtMHksyYTuyGPUr/wPHY8OP+0ecp6rGvORcM6ZcPiNmhQlglRQvEf5dnDvTz+LLFrhvj1HMNPZUZxUvhU28yWe+FJbswG7+WQLL1tftAgLsKY6FWCIxrcZwqJ7dl4wMbY8pBdvIGN9yzd+eYHyVBEp5mTeOGqEzWuPxNEhzkWswGHa/GQcQINZiz4dsN/Iat8o7KNsWFjCiHjc9sP56z7BuxyRhMz1VEajaO251ozbLWpIAaKJEyjim+hIpccxR6vBUi75fzGgJKnXkHYff4z4uQ5mfsEOPeDpS6f7jhFTQX9ydpSIaGvSPd2fJcGaZGoVSdpkfra6cw055inaVveKR5HhaeaGEePM/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I found the just very Nit comment cleanup.

In swap_cache_add_folio() comment, it mentions "SWAP_HAS_CACHE bit
to avoid race or conflict." Also shouldn't the comments that reference
HAS_CACHE(the word, swapfile.c) be updated accordingly?

Youngjun Park

