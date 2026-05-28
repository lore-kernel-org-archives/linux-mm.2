Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8549CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB50E6B008A; Thu, 28 May 2026 09:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C660B6B008C; Thu, 28 May 2026 09:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA34C6B0092; Thu, 28 May 2026 09:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC9286B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:30:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 527701C206A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:30:24 +0000 (UTC)
X-FDA: 84816912768.08.859A9BF
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 66C421C000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:30:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OqumLFAc;
	spf=pass (imf18.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779975022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KhpTO4hFo9OC+mrEE7JFS6Q7sHMI0fS8gBIMk6Qxzhc=;
	b=6NoSulZf3D7PLMJMSj5h9dWcgZOb79sfC8MPsxI/hNgdc4Q5EqpHfeoUhZbiXsPfNlaomt
	XriMKdYf+qyy/0AInzLVptQSko4KquCyYI8I//O7yoSyxELom7RCvkswXeeQoMc1EaM02t
	UDKOXxQ1mTkBWfI93uF8YAhlGlh91l4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779975022; a=rsa-sha256;
	cv=none;
	b=iPNlHEweSlRxcHtSDjrLgk78OnucQcGya1Dw12XNEzBlwNz0A/3bQCoykhk9IXp5I/aOCf
	JA3+vrN+rcHbnVP428wW3YV0mFSpcZwaCKHAW78k/kticdABTNwJKS5YRAuh/7ZzK5YfmR
	/vi2/gehkc3a6zgAjl/ThSqszk76y+k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OqumLFAc;
	spf=pass (imf18.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779975020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KhpTO4hFo9OC+mrEE7JFS6Q7sHMI0fS8gBIMk6Qxzhc=;
	b=OqumLFAcBtN5y4Aq9/aw82ZzRXDsV2lcJGVGQ20Nay8gah8vA4dNdFwYqyvjtI9ttavFN/
	889fLDus8fccZ7Gw/ux/E2Euq6yGMrc+wOdaB218uJgH05cuwVW92VuoiQusyZi2CqnME4
	zOOn9zvKFh7N/Hm96E8W5+4iA5aXsCQ=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: mhocko@suse.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev,
	Kaitao Cheng <kaitao.cheng@linux.dev>
Subject: [PATCH 0/2] mm/percpu: Fix possible NOFS/NOIO reclaim recursion
Date: Thu, 28 May 2026 21:29:15 +0800
Message-ID: <20260528132917.81123-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 66C421C000B
X-Stat-Signature: 3e9ikj8r433gs9bu487www4sfx3cfgin
X-Rspamd-Server: rspam06
X-HE-Tag: 1779975022-254642
X-HE-Meta: U2FsdGVkX1/csCiweQvgZfYf5F/9HEXP8GPkJEWKq51m9sjGNJaz06F3IS6WiiL/bJR5qWzuMsQpxbNRg95K6c34rpNkvP3lm1xQ9uLYjUdqz57yPRZJug6zmAY7PMguCXMUnZWY4R5G0R9y15DbDDcMP8WMvkj22q+fMy5JxIY+X+3kNAZJXpUrovW7J3Rgidq3fSDOg+Bgo3Ec1UqyxzEd23gxZoRPaIz9U1HW8SDTweDconWg0Ax9fwCyuU7MTKZExu8GX/GtL4ve+QeJ8Fz7GLvJDIC07CkVreuJM7gmyiD3I7l0MoruwfB98cjt7ZeVqvqAbciA32LEHhhofwr8dSk6nak3135eX+w/HA6ABWMueYmLfCORo61KJMjkXL3XW2w/h4FkmuI4qfrsDVoSJUrMl1gCCkflOQpQDnv9ulKQQhIdPHoV0N0buCdo4RzRv23udEF57F17IEzj6JIyH3Cbu1rktg+kNFQ577d4yAh5SkzHkLTmEuKNYeIuDuqLusAq6SGfHvAH/pYdI2d3csQsgAzRCrrP1XeiwD/eHC6AaG+rQdocGEKkIy7OOe0PQwiM22p3CKxuN+c+7V/OZkYlllx7kBPp3zGQree5mcK22SO+B+yXCsG3hQqS+j8IlayRdXZrQWIUR905UZpDmIDsYZbIU+ITE63gbgZOqYMVlnDuLIeXktxThJ4+N1Jv1zC5jfOxaOnW0H6kFZohUIq5LRNpQpOGRilv5FDpPd0jtwiBbHpdwINCHB2hEwjh2gKs+vfMzvoaqIw91mh2P1KCRTfb0fZihfk8SYAEXFfJ0YjqNpVs4M94kZFkXemM4iyBuH3n3Ogs9Gfxg2CUXYY5gjNPBXeZULzv/XHZW2z127BTx7DA1eXDP0NTCMGx3Ecbw82j6i5rW+EMENB9dy07GL4VNVKggztchL1JlUTUNgpHLe5T97CVa8srFOfpCGUTrBckKEDWIHT
 Lpg6lu0O
 viltOGJxso85ZmHNFEdrV88iTPChQLpuJjvt7x4b3rIkBdnV/PqIW4kLWZtmvgxieuBNbru6jAq58wnqWPMAgd1pIJ4SUK4rpDZFdAS8Rjn07GP9SL/mVX4YoYuKQqu73vgP1rAFU6Llc3ZpDMQqmJSEHcvvJf4hKFDxeMOMLwwPxNmINqviyzjjG4BXdNsgAViVy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
atomic") allowed GFP_NOFS and GFP_NOIO percpu allocations to use
pcpu_alloc_mutex and the chunk creation slow path. This restored the
allocation capability that was lost when those constrained allocations
were treated as atomic, but it also opens two possible reclaim recursion
problems.

The first problem is that the create and populate slow paths do not fully
preserve the caller's allocation constraints. pcpu_alloc_noprof() derives
pcpu_gfp from the caller supplied GFP mask and passes it to the backing
page allocator. However, pcpu_create_chunk() calls pcpu_get_vm_areas(),
and population can allocate temporary metadata or page tables while mapping
backing pages. Those internal allocations can use GFP_KERNEL. A caller
using GFP_NOFS or GFP_NOIO can therefore still enter unconstrained FS or
IO reclaim while holding pcpu_alloc_mutex. This defeats the caller's
allocation context.

The second problem is a possible pcpu_alloc_mutex recursion from reclaim.
If reclaim is entered while pcpu_alloc_mutex is already held, and reclaim
reaches a path which allocates percpu memory with GFP_NOFS or GFP_NOIO,
the nested allocation can now try to take pcpu_alloc_mutex again because
9a5b183941b5 no longer treats those masks as atomic.

Another possible way to avoid these issues is to revert 9a5b183941b5.
However, that would also bring back the premature allocation failures for
sleepable GFP_NOFS/GFP_NOIO percpu users that 9a5b183941b5 was intended
to fix.

Kaitao Cheng (2):
  mm/percpu: Preserve NOFS/NOIO scope during chunk create and populate
  mm/percpu: Avoid pcpu_alloc_mutex recursion from reclaim

 mm/percpu.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

-- 
2.50.1 (Apple Git-155)


