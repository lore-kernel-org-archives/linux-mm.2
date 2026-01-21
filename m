Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6377C44523
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34ACA6B0089; Wed, 21 Jan 2026 07:40:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8606B008A; Wed, 21 Jan 2026 07:40:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F78B6B008C; Wed, 21 Jan 2026 07:40:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF236B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:40:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F0A5136CAD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:40:11 +0000 (UTC)
X-FDA: 84355928622.29.D8AE52A
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F20EC000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:40:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pztY8jU8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768999209; a=rsa-sha256;
	cv=none;
	b=H6pa1/Y0YBPv1MnEi1MYbPsGBrkD9g8jiDmr++OU8p6BJngvcfnkvPk4H3gRX3dvgSdX8b
	Sq8COSeihRZuyUNFV5t+eOCOzB+r79CEpEGdWZTYko0hEi6/2AQaTllvN5DPG05Cwoz7V1
	en58bCeNStM3ZA4t9H347mGNtjgDaXY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pztY8jU8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768999209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AIgd4bOr0S+D4kFtBOGP07QN+SUDLqIaIGdlYZNzuKM=;
	b=FotgBpSIlbpQ97BbfsGdDJndurHNzTvNcCFAL//g47mWmYFJIMDDirPL0hrtoAJklKdixE
	LG9c9cjbizr88dGdVtBDgOoPzKgfeCqCR4ur3/EPAUtTzcx168G8x3hDhfALEkVTOPbAjF
	unZONrW5sW3CAwV2m5gm0Ry+dTcYrdk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768999206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AIgd4bOr0S+D4kFtBOGP07QN+SUDLqIaIGdlYZNzuKM=;
	b=pztY8jU84lPxHm5uxMRAKZomPFuvZe4E4WGRA0qyOTw9jwZV8Fz9G66Mz2MGFPKiY6tLbQ
	SI8WQuh3FITgIhhFTDqiLpsO/W1A2WGihUT6s9LvWvIG0V3/fjr6sWZsFJWcxk/gfemQCk
	l4jQZF2Pc7qvkMbK9S5qnz4OMuJESRk=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] mm/lru_gen: add memory.lru_gen interface for cgroup v2
Date: Wed, 21 Jan 2026 20:39:46 +0800
Message-ID: <20260121123955.84806-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F20EC000C
X-Stat-Signature: djo48g4htjn5mk3bempwp7xw9rkfe9sb
X-HE-Tag: 1768999209-44456
X-HE-Meta: U2FsdGVkX1+UJFSFKtgybFYWuYFxHnkPhAgIkgTs0eVhwEqQZ7GtmJ/u02AvH0cAIjZp3cDNcmXoQg+VXt1zcOPxEWgl7CmERfavX3Y3V7RTe/oiy6cj6yQgJ2HbdV0ftQPrYA7wS0hrC0lekHKXv4WZCvpqPtgDvg15EtS/EWpF42v1J2nKnRjV7H67k8lFEafxXaLl5wdEYN0FLjm4V+vZIm0n0xOFqyRSYBNkEYieBlAtlclJqsYKBC1DorVOv8DxxhK0sfg9bH4+b50gKcCVfKrCIwH/Dq79K3MZgp5QwWbuB34U9CW6ISAkqJgTCnQODj9w9UBc/fNl2Pl9xkiu9ZNhhR7haB14D8Z1RvF9aJW9bWUVxYPSpDyIZmFMg2XDyLLHR1JXYRCrSfZZvy0w4ySMmeVFsxnqTDSjJ0/cwIoh061Jj58r0KoMiny32rGc1OqQY01mjgrE8c1aNoFt8ZwFx2Eq0mAj5t3Y5zCs2j+cX3Ay5bHw/DQB0ZhUuYM2GfjV/Hs8PEPb/SBhTJTrizd3qeHH3nA0Ljqa8AU64WW+EXxOhwc0YDy3s6L4OOzk8OWZJqwa5eTxvQLx9UEcXWxnE6YMtXmHj5+ZgP0Jf8E4ob9qyunbzDPtvnqW5DxIwNd3gia3O1ap/M2BFpARA8QC6wKlFSzBrawlMNOmsP/rbR9wQeev0pD4CoyZlY+Qs1gSUGOJbq+Hz5RC92sV1ESXLia/VCFEb5G410F2ylnOWE2wWYFfoHlS1ANlgf7T25cfLfLz3P74Bmpbm2M6yPb7udvQjzEs4ne1wVtg1PLxLnuBPznmw72GZ3BFAQODeyD5FYDn5r9MkzoK8ynyUuufaPol8tr69tgWCd+fN0Y2/wfi6393eQcrXAzXJqgQ5FWBu42ui0WbBqTgpMppM3jpsPnWp/cQpCYdHZiRiVpmMYS5qAXs8rvjhoEyB/XMrRXnoo1sA0nUjFG
 RGLmvXWv
 xDKWyWofa0mORoYBabcgSQjFOXwBEb2Gn8mR66cniFBOUZCvbwKwe+bLUaJ0BIkd231pe9QhS0H/zeq9/R/xcsCyTWjnKm3AwcLr7OWgo4imPvu6w84Q3Azg/p9kczwVyPmhJHRy9jOjmW+nLaEyKkKPTD5FQTySxwbQ1l66S1soHBmuhy6Ae8t66F/LX98t/faBmMKG7jSW29KDlAzmVhIED1TIPODp0I49LZiIY6DKtLCTnisFsGtLnog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds a memory.lru_gen interface to cgroup v2, allowing users
to interact with MGLRU directly on a specific cgroup without needing to
know the internal memcg_id.

Motivation
==========
Currently, the only way to perform aging or eviction on a specific memcg
is through the debugfs interface (/sys/kernel/debug/lru_gen), which
requires the memcg_id. However, there's no straightforward way to get the
memcg_id for a given cgroup path. This makes it difficult for users to
leverage MGLRU's proactive reclaim capabilities on specific cgroups.

Solution
========
The new memory.lru_gen interface operates directly on the cgroup:

  # Show lru_gen info for this cgroup
  cat /sys/fs/cgroup/mygroup/memory.lru_gen

  # Run aging on node 0
  echo '+ 0 <seq>' > /sys/fs/cgroup/mygroup/memory.lru_gen

  # Evict cold pages on node 0
  echo '- 0 <seq> <swappiness> <nr_to_reclaim>' > \
       /sys/fs/cgroup/mygroup/memory.lru_gen

This interface is available on all cgroups including root, providing the
same functionality as the debugfs lru_gen interface.

Testing
=======
Create 1GB page cache, loop access 200MB as hot pages.
After aging twice, 200MB hot pages are in young generation,
800MB cold pages remain in oldest generation.
Eviction with seq=min_seq only reclaims cold pages, hot pages preserved.

Patches
=======
Patch 1 refactors the existing debugfs code to extract helper functions.
Patch 2 adds the memory.lru_gen interface using these helpers.
Patch 3 adds documentation for the new interface.


Jiayuan Chen (3):
  mm/lru_gen: refactor to extract helper functions
  mm/lru_gen: add memory.lru_gen interface for cgroup v2
  docs/cgroup: document memory.lru_gen interface

 Documentation/admin-guide/cgroup-v2.rst |  17 +++
 include/linux/mmzone.h                  |  16 +++
 mm/memcontrol.c                         |  31 +++++
 mm/vmscan.c                             | 176 +++++++++++++++++++-----
 4 files changed, 206 insertions(+), 34 deletions(-)

-- 
2.43.0


