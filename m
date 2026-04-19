Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2106EA719A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D57D6B0319; Sun, 19 Apr 2026 11:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086BA6B031A; Sun, 19 Apr 2026 11:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDEB06B031B; Sun, 19 Apr 2026 11:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8D8F6B0319
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:56:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FF431A0774
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:02 +0000 (UTC)
X-FDA: 84675756564.04.5AEC1E1
Received: from mail-m82143.xmail.ntesmail.com (mail-m82143.xmail.ntesmail.com [156.224.82.143])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83D13A0008
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:55:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.143 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776614160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=IShjmqnm3BOIDWvEha9mfHaTyzQBg/XPEIoI1yh+Rio=;
	b=hV5Wnd8Rv9ar+8Q3Vq8fI0EZp4Ilo56QrcbjYgYEdX1sG/8VdBupemj9NcLduvoNQJr7sQ
	kxN1k2WHAGWmvolWN8bRVPnBk11G1ptchn/E+wjxjmt3xwBLhPX9DEhI+ZJoYdnsqGEB5d
	/MsLzpwO4QovyVxJBr/S0oxOE5PC8Hs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.143 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776614160; a=rsa-sha256;
	cv=none;
	b=DgglSnevLD4oKJwI2GFB4lQgxWk2gxGYMyy5pYWzt6Kk+JDbiZ5H4ReKshMQL2SKCHOUDn
	39Zzrqef1xV5bhTsmDfhLFWaX5dEZGgiTF7pZofW6r91lE4M4EfmkTKfNnmnHOBkVYoCbc
	HsXwq+QLdSezgCQaIDtvCKTkeVwVvW0=
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:ef7:a5b4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1918e52a7;
	Sun, 19 Apr 2026 23:55:51 +0800 (GMT+08:00)
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
Subject: [PATCH v2 0/3] mm/page_owner: add filter infrastructure for print_mode and NUMA filtering
Date: Sun, 19 Apr 2026 23:55:37 +0800
Message-Id: <20260419155540.376847-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9da67495b50229kunma1b4aa74234e80
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTh8ZVh0ZSU1MQxgaHk4eQ1YVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHh1MQRpOGU9BQ0NKS0FDHUxPQUMYSU1BSVlXWRYaDx
	IVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Stat-Signature: q1f3ky7ttr6879qn7jny9urxoqjd1kky
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83D13A0008
X-HE-Tag: 1776614158-525212
X-HE-Meta: U2FsdGVkX1+pOPIG68hHvcPUFRFBDtrYprJpwVJSEDde60EedmyH2NXV/wAwVF6sQHXNfyg6KKCo004c/raP4SsqaU5JjPNapVrkDWKW1RH+8YEiOd8TX2xpsx7W3QNNF91CfnsyRhZ5e6LRrBLxCL2F/oKSUo0VCiBVhi1HtIYPG9TXRpq2cqlyuA7n+MSU91/JcHPteb16gudLlQoH09D19r+3+74Z7N5vmm1/z7Rh9s/vPhrDzDetTk5gWbYBIpFBuBPJf4dj+e0XxB9ZmIBkGknnONGBxmZAfHeA6SuBGpSgMIPLuP9cCMi9eIpQK0mjNaVfxF6iOr9/CwB7J9uIFZkHR0Ng16WERRAg3pbcit5SJYPDmmpTBRgojn25eRg4S1cYmo+Sfu4yrUMEMBpRFnFHWCvN+38cVbbH50htvyMbRMQWqk64264Oho2+bynNSDKj/ktnSvyyH1+7gDPjXXoigNA3QUJd270DTs+q+BQ8d1M832e4E6zpmKqVpK/Ii+wtOErGPBRuKGcx6xbfFCzF4lnLJCujIlbi2Rr/BnS4JAdVxlXD7es5az9/fCFbGSnhaDJ6QapDzIQ7qKP/nZGqXEGAmShAo/XgjnEEMdFPghGyisNO255SMar0AhV/sxUwOT+j3MR7K5OifCon96drm6LswlH+HgymX7EojWVumUMoXB0d4VgWt9MgahZIxwdGI5JBzOP6ZtfRvjNv4ytbPzXtE7Ra6bJ1D4udkD0tpjTcDescpNdZro03AV/OWukv/LI0B2IpR1mXU7JGu7dm9iPuTI6ZPa4nlC19hNm6Xv2O6KbrKetSXsTlFXiKbqm3iKmepnfAyVWEl61qPNsI/EHLFffADjLOMrNTdW+KzVGb+cKQmKkI83+T4KA50MjFBdNwE5KK8qbx5DeTk2eAGE42XAil4urUaWO0ORjAwYaVUHnySjM8I7kfVTG1zcvPvAvg15Y3sHw
 ZLyLpxiw
 35scTtuNkBYQwkvbsaKZ5w8s2PIzqgvDMiueqTxE6QlRjcLq6UaKHei8wIbqD7LBQQT86gx/DYeCXzYrHX3HpgJ1+6vmW1/f2eIBqLkW6Vhlfkkppr/k+bqePFDrF8SuO1+V6elsKKlAHvvdEbAUJLzZdhwT75uPEgtZEfD4TU6i2UIf5QU862rIeOCL/+fOtdONDl9MLVKQWvhINS/hyPsID5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces filtering capabilities to the page_owner
feature to address storage and performance challenges in production
environments.

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

These changes address feedback from v1 review:
- "compact" was too vague → use descriptive enum (PAGE_OWNER_PRINT_*)
- Single node filter was limiting → use nodelist_parse() for multi-node support

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
==================

The filter infrastructure is designed to be extensible. Potential
future filters could include:
- PID/TGID filtering
- Time range filtering (allocation timestamp windows)
- GFP flag filtering
- Migration type filtering

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

---

Zhen Ni (3):
  mm/page_owner: add filter infrastructure
  mm/page_owner: add print_mode filter
  mm/page_owner: add NUMA node filter with nodelist support

 mm/page_owner.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 2 deletions(-)

--
2.20.1


