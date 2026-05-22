Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3734FCD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A2E6B0096; Thu, 21 May 2026 21:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A576B0098; Thu, 21 May 2026 21:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FD86B0099; Thu, 21 May 2026 21:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24A396B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:19:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEBF716174A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:19:26 +0000 (UTC)
X-FDA: 84793297932.11.2096F60
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0B4E710000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:19:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IWeo9KvI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779412765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KKSfM/86lAA+qnVTKOkWKPhGo0U5csvRd25duVGKj3I=;
	b=tldl9nuB9/zrs55L/zVJup5X20VC7ycOQfVfr005fq0vjjy7SOk2q+GZb6wILhF0zlwBeu
	nARPujMZEuEx0te9NwXoGdUmB1ggO63TfLQEx7w7qwinZEItaGNtnvbK7INwJCQ5ZcPXUT
	PcTTcms5gE8KHIof1t0EZ9RmiKHAefQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779412765; a=rsa-sha256;
	cv=none;
	b=MoWwHhfecq13Np2fV+Be26tv70fBCXSq5soUl2vAqhrIO/e8mtVwc0JpFfFcoAULEyAxrW
	DgutTl2W+aFSs67x3a7htYxCkiCuzx+CrTkvwlX9iMCZeEwTXQwdRXCxHZajG9U9B7tt5n
	3efEL7VXAsSYOBpsSt2BVti7uBjdMHY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IWeo9KvI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779412763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KKSfM/86lAA+qnVTKOkWKPhGo0U5csvRd25duVGKj3I=;
	b=IWeo9KvIh2h2scxfoFtPqMmlThWuSS+fc0Azgjk9KBgBln+0lCDine9do+NBHzpw32wWfO
	A8P4nUpQ/mg5sd+iIDcEK3sBSsvfcYvKTXJoQBNARtPJcIYQgw2C7nj1NvdjGrvC6pDtbz
	cFFDELWcQTzrHO/iJBwK7ER8TeCTNzM=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2 0/4] memcg: shrink obj_stock_pcp and cache multiple objcgs
Date: Thu, 21 May 2026 18:19:04 -0700
Message-ID: <20260522011908.1669332-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B4E710000B
X-Stat-Signature: zscn8d9y7utr3tbi3imcbdxoscmiaan3
X-Rspam-User: 
X-HE-Tag: 1779412764-528379
X-HE-Meta: U2FsdGVkX18vVogBgEAxNT71u4RbvGbeZ1XFgkXyVOh2QLB3oWAlnYewaWlO5eeYctxgX17dBz2zvAfFJ0hkLsSDBkJcsz6EsCd5uEb3h2Lhnic752ydtlkqpRS5SlNeWUQbRt563KoJi2eBTsXspTdSGDaLwSSh8IBQ6uOFAhWMseRdJOCIH50cXOupIkVDpg/8M/4i2UWNqfQYZGDlw3SGomawzWF7epqJyoMdMG/5GFpU5SK9ZpAYL7Z+DhXj8txgsX13GRx28vejoNtxU2tLuQ2W+NVbOGIeNB6DsPWZXcMkuOEFJFTBXRoacp4ltzyEil6NN7Qu0f+apbfcWVXah+0/0+dwDWUnqYZV69K0yjhAVJ1IEiAOI2yUSPfLPGAd+TIwW/Js+tjEP4mlSUKucQrYaj7hD+L6Ru3OhdLPwo8eYSJJ5DZLpjByyelOUHCBBNCc9ySaTvXJwUIXOEMpC0bn78n2itDO10oj/4Vak3mNnmpEGt8ImIOjoI7+pBdYuRFE6Um57Uj2sLPm4oyS74CeFliD/ULcThbZ0jTNRLFAh6zvYAHVuiRwp3IS35Ez/+jMDvnbcN6R72B7Z4mj5iH1qUh79jJMlW7t9fdtWB/QlZZ6AtaYll0zItbgKTeuqNUv2SxpHUbk8+Y8nTkRZB74OxFYkjnjPJKDaYtR7KOJqaTTvomkSW3Tv/Saq2R3byWPDJ6PUUGZI/j9F84PEiis3OiiPmTVnijzfoazxvGCZ/W9PI77yok5QWB2o+CrB63c2LJDYoy3OZzcErc4foWRYSf4veuRTKf6Ymseu4uVOamkXplkf/yU+5blm+F6rCReuldCssHnDVMLsZoxPFBHRCgVgCRuG4JNcDBkOC4QABLzUHeRLar/3D4jzihDEJW8/utIQ1BdpfxEgGD+Qp+NehfdrnaeeTOhMrD7Oa/D2R4zXeIyMiDBnxPZtRWMJjoQywFdYfZpWZL
 xXhhwlXP
 cIQGpD5tkj/jnOfuHUaCx1zk5f8IDFRv0MRlIkk9VhqDZna/uh6BwmKJlzuyyLBHod+myaZ7fx967UHTQp1Nh/pCjmTb7nlLRbkfGc6WzcUpkQFWFFHs8OD02sHA+GsruAiaNbNmofhGvQxMLD+A9He/CcWu6tqonjwcuiqux4GMjc3EhjmEzxQqqXc5klk5UR7okmlCnv5xS6z8VqtkBkeu7ii9YD+gZosUTHDqvExXTkHp8oUXwzlAfUXK/DnMoXS0ci+7kjRrJ/dzQkq4j486nHX5P69DFHEMiCmGMPcujP7yGKmwspHi8b7amdsljw+Uk5n1Sf4HhjHCl2JnFYdMEglpseDpNlgjsGck3laMh6OA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node so that reparenting LRU folios can take per-node lru locks. As a
side effect, the per-CPU obj_stock_pcp -- which caches a single
cached_objcg pointer -- thrashes on workloads where threads of the
same memcg run on different NUMA nodes. The kernel test robot reported
a 67.7% regression on stress-ng.switch.ops_per_sec from this pattern.

Commit d0211878ce06 ("memcg: cache obj_stock by memcg, not by objcg
pointer") landed as a temporary fix by treating sibling per-node
objcgs as equivalent for the cache lookup, intended to be reverted
once per-node kmem accounting is introduced. This series takes a more
general approach: cache multiple objcgs per CPU using the multi-slot
pattern memcg_stock_pcp already uses, so the per-node objcg variants
of one memcg can all coexist in the stock without ever forcing a
drain. The temporary fix can then be reverted.

To avoid increasing the per-CPU cache footprint, the first three
patches shrink the existing single-slot obj_stock_pcp fields.
The final patch converts cached_objcg and nr_bytes into
NR_OBJ_STOCK=5 slot arrays and reorders the struct so the entire
consume/refill/account hot path fits within a single 64-byte cache
line on non-debug 64-bit builds (verified with pahole).

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Tested-by: kernel test robot <oliver.sang@intel.com>

Shakeel Butt (4):
  memcg: store node_id instead of pglist_data pointer
  memcg: uint16_t for nr_bytes in obj_stock_pcp
  memcg: int16_t for cached slab stats
  memcg: multi objcg charge support

 mm/memcontrol.c | 214 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 157 insertions(+), 57 deletions(-)

--

Changes since v1:
http://lore.kernel.org/20260520053123.2709959-1-shakeel.butt@linux.dev

- Collected review tags (Harry & Muchun)
- Fix comparison operators (Harry)
- Use round robin for drain

2.53.0-Meta


