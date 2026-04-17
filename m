Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33362F436B4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601506B0120; Fri, 17 Apr 2026 11:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D96A6B0121; Fri, 17 Apr 2026 11:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515EC6B0122; Fri, 17 Apr 2026 11:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5FB6B0120
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:46:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9439B1A01EB
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:46:57 +0000 (UTC)
X-FDA: 84668476074.16.4CE7142
Received: from mail-m82138.xmail.ntesmail.com (mail-m82138.xmail.ntesmail.com [156.224.82.138])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9705A000F
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:46:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.138 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776440815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=AJkIVB1CVaftz2P3+4AMH+QJO3FnBgXQoGFo5iG5VQY=;
	b=Qx38ytdpKTvOyuH1JlxFFfMJr+zOfNuPEeNmROqrxIhUFz23XDbGDFSSyGlyPrDjykOx03
	S9m0LFsL8rDgIcCVAMnS24fr5go9th2TgJTlj8aLNte1tMd6UE6i0TyUv6WfpIF/sPhMJo
	/QMsmGMKhLZ3ILyRpNrDljQ6XnJQeMA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.138 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776440815; a=rsa-sha256;
	cv=none;
	b=frPAjl8QQoiB5Dl9qNUjQrrPG7mMP0CTuY8NXvyG8s84MhfaFBUrXXyOQWqSWi9DvVVhAg
	JTKhG7E1naRC8bhX/Cuwg63fvv8URpYnkG6K27JQ7U0XsYuwPSkFtH6Dv/jpVQccwR5vTV
	Kz5BIeyrLEUtEQho2A9VeYZx1rD9iV4=
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:ef7:a5b4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 190e229f4;
	Fri, 17 Apr 2026 23:46:47 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH 0/3] mm/page_owner: add filter infrastructure for compact mode and NUMA filtering
Date: Fri, 17 Apr 2026 23:46:35 +0800
Message-Id: <20260417154638.22370-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d9c1f8ede0229kunm7c3615e318e598
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaGkMYVkJJGEpNSRkaT0oeGFYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHh1MQRpOGU9BQ0NKS0FDHUxPQUMYSU1BSVlXWRYaDx
	IVHRRZQVlPS0hVSktJT09PS1VKS0tVS1kG
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9705A000F
X-Stat-Signature: p48bnq8zdkordo6fjhhkrdfkk8o1tzbm
X-Rspam-User: 
X-HE-Tag: 1776440814-982933
X-HE-Meta: U2FsdGVkX18yKR9fGjYoZhHwACVH7xc1ZD+ySesY4OgFzeRO+VMxWR11cJ/hZFWVTNkaCgPOFX6/Bdp1cBJghRyb8YKTvhqQGMCNkIi3jnvzS3kqsQD7a+AyoZmz8mSW8iAuO1+JlH0BbGTmDd1A5t9KLAQnqA2KrlB4ENkaAYNJ2dIWVMBNz7TSr9CjdhjR4h4TNMWvYdQwG7leKQdgv6kVyCFN76tH5Neog9qNeWHCOz4y5LoRfq/xKQqOyITxZ1qzb/GJDQWbwGNWmddqHe1o5NXcnMUlPnM7Wc+l/4DaZH20qIdupdG5HcxKLxzRdf72CMNAgUjg87SOJZGOEMluVd8LhusGHp4mIMJjkFFXd3+Cr81Wp+8+NYiJOnTNePk+UuGneIF/F/eKC4axtk3NS4G+nrXb8vjo1UuLKjWD8Al+DaNWHxByO1wo6QaVbeXWLtLiTQpHMhN/11poB11Oef22Gmhm+XjrW36pGbY30sTqRwl1WowVQPrafZs8hPbV9uxkzs1aRA3B905dVTMstNK7z1xLb6OoxW0NcBJz1C83VaPvwbJiunUXlCw1btpYzmOI50GWJASc3OSWWj3v8WktGUl0ohO3W9ZX4l18+N+xog3g0kuvToroRZsFdpZcNLkPPFsuf7wCZAKRSVWJL5/QNetZ83iTF00PWR6DCtWYA+S5AWKsyx9ZPkpxzmW4rxR0gozrT8VMtIKHB8LhmSdSi6xGov7TLfPNlcKhW6Wf4Eh/hqkP0cyH/lQMjECaurfG7jLewKBuA3QjaxfifoyXDiihZTrOFKpdCM47wUwyYWjdh4dKhlqRTsY1MfvQ3CC/kzVqmBxbyLCaxiYJVyIydcZzkhyAPzKTOz6pTOWlxcKTy0roi3w9rTiqf4igDOVqrh/xtnpXqGePSMSuATsY70hj5WdfyXOTtnH5Th+GsJgeITwGt2flurYEEzqU2Zwcci+Y7eaLzgd
 z/PuM8Ff
 W3Z+jw7Vfk4c8fHmlJozHaqPUWbcSWKY7Vm3FyCpsoPue3NQlI+Wr3e8dCqNaWWqhjECNrVCZ1YwSBmwZpLAzOE5o+2Bz6Es7pCuJ4rm9K2PoROwZDj6H3eeOX2CWdftYGb96ouwkULedpcKJYET6rX5jgRMujHVECBPwajqAvz8w8UI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces filtering capabilities to the page_owner
feature to address storage and performance challenges in production
environments.

Problem Statement
=================

In production environments with large memory configurations (e.g., 250GB+),
collecting page_owner information often results in files ranging from
several gigabytes to over 10GB. This creates significant challenges:

1. Storage pressure on production systems
2. Difficulty transferring large files from production environments
3. Post-processing overhead with tools/mm/page_owner_sort.c

The primary contributor to file size is redundant stack trace
information. While the kernel already deduplicates stacks via
stackdepot, page_owner retrieves and stores full stack traces for
each page, only to deduplicate them again during post-processing.

Additionally, in NUMA-aware environments (e.g., DPDK-based cloud
deployments where QEMU processes are bound to specific NUMA nodes),
OOM events are often node-specific rather than system-wide.
Currently, page_owner cannot filter by NUMA node, forcing users to
collect and analyze data for all nodes.

Solution
========

This patch series introduces a flexible filter infrastructure with
two initial filters:

1. **Compact Mode Filter**: Outputs only stack handles instead of
   full stack traces. The handle-to-stack mapping can be retrieved
   from the existing show_stacks_handles interface. This dramatically
   reduces output size while preserving all allocation metadata.

2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node ID,
   enabling targeted analysis of memory issues in NUMA-aware deployments.

Implementation
==============

The series is structured as follows:

- Patch 1: Add filter infrastructure (data structures and
  debugfs directory)
- Patch 2: Implement compact mode filter
- Patch 3: Implement NUMA node filter

Usage Example
=============

Enable compact mode and filter for NUMA node 2:

    # cd /sys/kernel/debug/page_owner_filter/
    # echo 1 > compact
    # echo 2 > nid
    # cat /sys/kernel/debug/page_owner > page_owner_0417.txt

Sample compact mode output:

    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper),
    ts 0 ns PFN 0x80000 type Unmovable Block 1024 type Unmovable
    Flags 0x23fffe0000000000(node=2|zone=0|lastcpupid=0x1ffff)
    handle: 1048577

    Page allocated via order 0, mask 0x252000(__GFP_NOWARN|
    __GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 0, tgid 0 (swapper),
    ts 0 ns PFN 0x80002 type Unmovable Block 1024 type Unmovable
    Flags 0x23fffe0000000200(workingset|node=2|zone=0|lastcpupid=0x1ffff)
    handle: 1048577

Future Enhancements
==================

The filter infrastructure is designed to be extensible. Potential
future filters could include:
- PID/TGID filtering
- Time range filtering (allocation timestamp windows)
- GFP flag filtering
- Migration type filtering

Testing
=======

Tested on a system with multiple NUMA nodes. Verified that:
- Filters work independently and in combination
- Compact mode output correlates correctly with show_stacks_handles
- Default behavior (filters disabled) remains unchanged

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

---

Zhen Ni (3):
  mm/page_owner: add filter infrastructure
  mm/page_owner: add compact mode filter
  mm/page_owner: add NUMA node filter

 mm/page_owner.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

--
2.20.1


