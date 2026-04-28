Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90100FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E054F6B008C; Tue, 28 Apr 2026 03:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6686B0092; Tue, 28 Apr 2026 03:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5776B0093; Tue, 28 Apr 2026 03:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB0816B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:11:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B76B1B95B1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:29 +0000 (UTC)
X-FDA: 84707093898.02.72F98AE
Received: from mail-m82132.xmail.ntesmail.com (mail-m82132.xmail.ntesmail.com [156.224.82.132])
	by imf22.hostedemail.com (Postfix) with ESMTP id A4A06C0014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.132 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=gceHwzJWqo2C4WNisjVj6YoHT6j8CbgtSe3Y2exj3zU=;
	b=UBEHV9XffOG0IUl2UG5KN6KalCSnAm44n3M3O+kzYGDQ77BBB4rpzhdDPXhRn7vI+7KGQ5
	nh9GU6g+IZTDNcpt8A5opphB+uzwwaEh74AY7Ztef8wF2TnXFQyMmzr4C1kOSXY5JejNXK
	Zx6hdoMb7smvyKKEEandDue7oPbJh5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360287; a=rsa-sha256;
	cv=none;
	b=u0oU4nhIXwHuxWtqLbc/ls2fQvrH7S2giiJtPzr0DUer4TTz3PVj6Rt6kY6pyqakNtvo06
	EnOzQr7c1lC2UvOYzPXeh6vfsrJuDYIHuoFzIU1Z49Ymts69EvsZszOmSNsUSLYi4GQZ6U
	nEM1vdcI96AZG4Ab36R5t5127nC1AmU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.132 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 197b492f0;
	Tue, 28 Apr 2026 15:11:21 +0800 (GMT+08:00)
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
Subject: [PATCH v3 0/4] mm/page_owner: add filter infrastructure for print_mode and NUMA filtering
Date: Tue, 28 Apr 2026 15:11:08 +0800
Message-Id: <20260428071112.1420380-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd2ed9f030229kunmb0c223f1156eed
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGEtMVkoaSB9KSx0ZSBgdQlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4A06C0014
X-Rspam-User: 
X-Stat-Signature: sp3yztgsek6iwumupmbam939tez47zp8
X-HE-Tag: 1777360286-433687
X-HE-Meta: U2FsdGVkX1+TJXUPEfKs434Mw84DCta8VK1Wu7MDBezExAm6P/YfrW7PZIrQlxMm09o+FcsShFuvWiwxPEpSNb5Qtw4mSkfcRMf/VgXBf5Pl2JEpGsmFHwTcqebGqOlWdcvPyeni1Z1rm49cJkss81HkdwXvzdYhhk0x80c7NNjyOGROgeGw1bpm9Qt8ZD3gWtZMJlV4nkqiwxivzNUyDUiMGTbKuH4nGzXJxRjBCpDk6rkPmxklcq7tMGoA7tpUSswDQVTYDY8Ye5qdDP/bT7jlvUOQUQ4VyItT3EQQkvU25VecPjJQ4bucWRfSuSDSIuE/ewXp80+8QY2hIhW5kjk9QtecbhZDUNzbdBoXNlPyI1OSb4rTX84/OdpwPuYodB0zf9eTDVO9t9QcX833HlhxjaVIO2CMPqJwKJus1+tyFZMK1YzXer9+gqXrSRtiFBimMMai9GapVHU3vvbg/2H9p+WjXZ8OxkT1dp1wMyuLQNUnwExhLYW4BfAHrUmsCQO95ew489C0KAlrwzHrs5Qx+y+ptIb8/g+paaakKaWkYt2QcLWISLKQxMRHWzCfy4m8QpoawNTFX/vmRN10+h3pNFpVUY2d8GyQD086gKmzrQ8GqKyZiiWtAyg5XpdBUhR9cC+cA/XA6Qx7I6YZNr81amSH1NCYGFZOqWbsQS9LSfds38dJrkaiEBvneoLBV8n4XG1Dc8CJVMBRJyjC26PckRXSchlu6xdurzeYjjrYityaivIH+gD4/sczEQZAu3/TCRiEJAAyUobp3HmLK/EKTyhpk7DBCLPmj4OwlBvE9EUSSq8iasFaKG3QyNocM9Z0YlhdUSNEPesgQjfKDX/8iBylYqClhKnbB2KaCI1PqkYQq1QdPxx7ryO/E2Jy8zsyoMe0l2RwtcdSoQc8GcYQhzypclMNjyhBodogmeoe8fWezZp3F2/qUlgyf+8uYwo1Cg/yZm1eMP6GfTv
 BBbQw9lm
 Fqoh4NTVx9xPOCA3v5ehFBKWAi3TAbkbw4dtZrOenyjS6trOQYb1Xnctkf6dQZK0/uhNZHz3yAG/CUFIzvK/OaGRqRxmG4+8INr9AP2rXC5Vu38aizyiRGeR8rhISLy1JqX/9A6DspJApM8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces filtering capabilities to the page_owner
feature to address storage and performance challenges in production
environments.

Changes from v2:
- Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
  * nodemask_t is a large structure (128 bytes) that triggers compile-time asserts
  * Direct assignment is safe for this use case
- Add comment explaining input length calculation formula
  * 6 bytes = ",NNNNN" (comma + 5-digit node number)
- Simplify "-1" check using kstrtoint() instead of dual strcmp()
- Move nodemask_t mask read outside PFN iteration loop for performance
  * Avoids 128-byte structure copy on each iteration
- Add documentation for filter features (patch 4/4)

Changes from v1:
- Renamed 'compact' to 'print_mode' with enum type for better clarity
  * PAGE_OWNER_PRINT_FULL_STACK (0): print full stack traces
  * PAGE_OWNER_PRINT_STACK_HANDLE (1): print only stack handles
- Changed NUMA filter from single node to nodelist with bitmask support
  * Uses nodelist_parse() to support "0", "0,2", "0-3", "0,2-4,7" formats
  * Uses nodemask_t internally for efficient multi-node filtering
  * Output uses %*pbl format (e.g., "0-2", "0,2-4,7")
- Improved memory handling in nid_filter_write using dynamic allocation
  * Limit: (100 + 6 * MAX_NUMNODES) to handle worst-case input

These changes address feedback from v2 review:
- AI review tool (sashiko.dev) identified READ_ONCE/WRITE_ONCE issue with nodemask_t
- Andrew Morton requested documentation for filter features
- Input length calculation justification
- Code simplification using kstrtoint()
- Performance optimization for mask read

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

1. **Print Mode Filter**: Outputs only stack handles instead of
   full stack traces. The handle-to-stack mapping can be retrieved
   from the existing show_stacks_handles interface. This dramatically
   reduces output size while preserving all allocation metadata.

2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
   using flexible nodelist format, enabling targeted analysis of memory
   issues in NUMA-aware deployments.

Implementation
==============

The series is structured as follows:

- Patch 1: Add filter infrastructure (data structures and
  debugfs directory)
- Patch 2: Implement print_mode filter
- Patch 3: Implement NUMA node filter with nodelist support
- Patch 4: Document filter features

Usage Example
=============

Enable print_mode and filter for NUMA nodes 0,2-3:

    # cd /sys/kernel/debug/page_owner_filter/
    # echo 1 > print_mode
    # echo "0,2-3" > nid
    # cat /sys/kernel/debug/page_owner > page_owner.txt

Sample print_mode output (showing handles only):

    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper),
    ts 0 ns PFN 0x40000 type Unmovable Block 512 type Unmovable
    Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    handle: 1048577

    Page allocated via order 0, mask 0x252000(__GFP_NOWARN|
    __GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 0, tgid 0 (swapper),
    ts 0 ns PFN 0x40002 type Unmovable Block 512 type Unmovable
    Flags 0x23fffe0000000200(workingset|node=0|zone=0|lastcpupid=0x1ffff)
    handle: 1048577

Testing
=======

Tested on a system with multiple NUMA nodes. Verified that:
- Filters work independently and in combination
- Print_mode output correlates correctly with show_stacks_handles
- Default behavior (filters disabled) remains unchanged
- NUMA filter works with single node, multiple nodes, and ranges
- Code compiles without warnings or errors (allmodconfig tested)

Example test session:
    # cat print_mode
    0
    # echo "0,1-2" > nid
    # cat nid
    0-2
    # echo "0,2-3" > nid
    # cat nid
    0,2-3
    # echo 1 > print_mode
    # head -n 100 /sys/kernel/debug/page_owner
    [Shows compact mode output with handles only]

Future Enhancements
===================

The filter infrastructure is designed to be extensible. Potential
future filters could include:
- PID/TGID filtering
- Time range filtering (allocation timestamp windows)
- GFP flag filtering
- Migration type filtering

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Zhen Ni (4):
  mm/page_owner: add filter infrastructure
  mm/page_owner: add print_mode filter
  mm/page_owner: add NUMA node filter with nodelist support
  mm/page_owner: document page_owner filter features

 Documentation/mm/page_owner.rst |  55 +++++++++++++-
 mm/page_owner.c                 | 130 +++++++++++++++++++++++++++++++-
 2 files changed, 182 insertions(+), 3 deletions(-)

--
2.20.1

