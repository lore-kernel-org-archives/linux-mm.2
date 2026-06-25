Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C60A5CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0AFE6B0092; Wed, 24 Jun 2026 21:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBB66B0093; Wed, 24 Jun 2026 21:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC4A6B0095; Wed, 24 Jun 2026 21:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 738506B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:47:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E889C8C7C5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:47:21 +0000 (UTC)
X-FDA: 84916747482.29.1E3C11B
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id DDEB21C0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:47:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X1MO0u0w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352040;
	b=yq70aqrBG4e0RJHTxKyr1SfrEVONnZ2PvYpXo9+0MpU9Hvm3XJ/8VqdqjpLFFi/6F20pDy
	jUsgd6jX2K5o1BtGuHJkElpfAv0/0itZQSgLJRmzH1X9sRaGd2DAaWITwVKhjmxLoEmu+X
	SsKv5kP2ImwpJS4r+Ge9JuLhzf0rRQs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OM4i1907t/VVrIa2X1MtyNtXBmmD94pG1xktaQRqS5Q=;
	b=zrpW/ppGW88LviveUbcJ/woiUcLJY16hYyKWDWFwlRaiw2vcyEjs7gKT6oaz/hQyI6u9eX
	BvlavFNpoLt6KHYvpNj1qs2SN3F/PVgMo3RF02aBOTnAYqs9WXxnuIOcD04RiQEI7WGgRJ
	2pUNp63oe2+HIQwcz2ywejXL4ZqPVGg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X1MO0u0w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782352036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OM4i1907t/VVrIa2X1MtyNtXBmmD94pG1xktaQRqS5Q=;
	b=X1MO0u0wVQcI1pkWaKgsuytkFRDqu6nTu9+WiX6i4JpO7LuL81AffECVu/YzneqtyqFHsN
	TtUDVoQHcjBRWFLInXO19xYJtJbUeD4mt7VJwxSzvKoBgQBSgPmf+A8hNnWSsagCU+rXvn
	cDkVcFvQbvvE8AaJ3B9McvINX3oWmdQ=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm/page_owner: fix TOCTOU races in lockless page state reading
Date: Thu, 25 Jun 2026 09:47:03 +0800
Message-ID: <20260625014708.87386-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDEB21C0002
X-Stat-Signature: yca5x3gm9hidbm63h6bia1tinxu3ydxg
X-HE-Tag: 1782352039-447944
X-HE-Meta: U2FsdGVkX195GcK3xvRDDgIKZ51EFE9JlSIvVtJOOh3ElNN2SHjVnhOh7b5Seg+ptNa2Cn0vvYzyx5Zt3RM9wiECuCs+YMetAvF8nehKbUHUX0nPclZfS8xNvAU+LA/pWtX2BS2ZJRm+SpkaNcbl2SdGFmdwcSJiRRZXbxhVaaJzBSys2fe5WdAVqLDIcFLAMe5xjjGBt5aIHQUue3dtfSPQfqlWhTUPbyZO3c0YgofunrnXRAOrar5AiZrdvMBO6HEP5kmw49lVZmfQPazfBYNqc6CmRyd4SahqqhV1FSU6JFWZGBQXxrnCBaZxFLUUnplo0NXJr5BbM4+ed5zexSP3Xr+uKJT1IyqY43w95Nv6Z0FTOwQ8evWLLzMCiAUxJIX5V+zAH0cAIWNR+1+lD3EhqVhpmR2SY71qoATutVtoT50YUdtcqJliKXZHGQszQ94ltdjOPA5iX8Gi50Fy36I3vutrBouQebEAmLBSLqRznvIVMl89YQNFr31iVNfyqoSl3fgc0+C18TS0mkOhQ1YjuqxRWse6Nm95hD3t356GZ3QXzqji/rH/Nt+t15XMwyOVWj/+A021ng65mAgyVLEIZ2d+zGDk/wlH0apX0rOnzDlhEYX1NjBG4hE8Bp9mXYruRL6x+HUOXpWVr6wdPHePkbaA5YTxhVq1ZZ9sou9kQ2UeJpSWKVvdqyi8f/Fdifd89onu/Ig+8bBhaXXsvxKPxr9YLp3mm7yZ/3dJlY2Ih37OLp23HHSpTa5Y0uSn7QRQ6YkkBEfCZ7ShD9zkuqN+DZHMnUOx2IZzZy5Ac0SnHyK2NcKicwDCL2UpIMPska498s8uCstW1wwBo8pxjGybkXZCi4cYMq0X/zU/vT+3TNCc9gwF+w4lQe6NjPf9MCjTum6hc9ulUR3AhVBN+OGFIFi21Yc+bi3tTh7hkhLYSLwuex/OKfzB5x4Vp24rOK7vsH9QClHVcgdO0Cm
 +MIN1Tn0
 PI2bCd5iLILfLwQG89cszX1NNYMVp4SPiqx7E6QLozMY1q/0OAfjH2W8h419zpIS8lpP6dTiBLC6fbJ2Zepzk2HwbD5xmJCiUXxYCt0hNxaggleOs3bpWmLAuNkHl4S6yLD1Ig3BGPjDDHJTpZflfnlF0rIDhCicgtqFfVSptaW1jPUATRmPf986qad+6r5JhxUmvIbZVACWWpSLq3xh8bYAnHUCx9yLtzGIUXUOzK56xpJsclFUmGWyO17wgGczCNsLrfu8ivLBEQKdVejGGIlBoWwebssnW74gaJAdSvET1mHoZ5ivtVTOJparcf2CBLQYuj9+zUFS9S+QGvljiuhs6RfYEmgNsby6Oa9MiVVAIels=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two TOCTOU races found during review of [1].

page_owner reads page state locklessly by design. In two places the
code reads the same metadata twice — once as a guard, then again as
a use — and the page can be concurrently reallocated between the two:

Patch 1: buddy_order_unsafe() in skip_buddy_pages() can return garbage
if the page is allocated between PageBuddy() and the private read,
causing the PFN to skip past a pfn_valid() boundary.  Clamp the
advance at MAX_ORDER_NR_PAGES.

Patch 2: PageMemcgKmem() in print_page_owner_memcg() re-reads
folio->memcg_data and triggers VM_BUG_ON assertions if the page
became a tail page or slab page.  Use the snapshot taken at entry.

[1] https://lore.kernel.org/all/20260623065234.31866-2-ye.liu@linux.dev/
[2] https://sashiko.dev/#/patchset/20260623065234.31866-2-ye.liu@linux.dev

Ye Liu (2):
  mm/page_owner: clamp skip_buddy_pages() PFN advance at
    MAX_ORDER_NR_PAGES boundary
  mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to
    avoid TOCTOU VM_BUG_ON

 mm/page_owner.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--
2.43.0


