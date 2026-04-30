Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B66CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C616B0088; Thu, 30 Apr 2026 12:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03896B008C; Thu, 30 Apr 2026 12:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40806B0092; Thu, 30 Apr 2026 12:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D68A56B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:42:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F9B11C1088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:33:08 +0000 (UTC)
X-FDA: 84715766856.04.CDD308C
Received: from mail-m826.xmail.ntesmail.com (mail-m826.xmail.ntesmail.com [156.224.82.6])
	by imf03.hostedemail.com (Postfix) with ESMTP id 295F220002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:33:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2n5LJb/gbIMGLxy0xH5CuJfBWOrnRyG6CuCJgVGyrvg=;
	b=XXixaix0qX1RK3Q3A15u69wfm+6QxNwKfSHeh8RmG0Y3ovJ9rzaPb1AXPoR9mDP3VkWXCs
	1qmLVXNFSlFRMis1GZ6D+m/+za5t3c8qHTJNmJ1g+NbwB7mqaIlgMXlzWHQxES5cKHaoGN
	TBQT2kgRd6BTrcR6V882l+3qHv1naBg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566786; a=rsa-sha256;
	cv=none;
	b=rks870mtfDGbkvdKU5w5KIMj4pFk81huVK6Jo3Ipz0/h0ttPgCSqGVU6M+zLT/CTImTHUW
	5P94Uyg8fk5ZpyoIeLcMosvqYwe4B4WetlVZsryuMsquGxnYdHummF0hgmoG2SRIUYxjVB
	IrjDRqgICdiQmoVYMIdYSGNuTNCVeVM=
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:e24:8c24:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 199a96d51;
	Fri, 1 May 2026 00:33:02 +0800 (GMT+08:00)
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
Subject: [PATCH v4 3/3] mm/page_owner: document page_owner filter features
Date: Fri,  1 May 2026 00:32:47 +0800
Message-Id: <20260430163247.13628-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260430163247.13628-1-zhen.ni@easystack.cn>
References: <20260430163247.13628-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ddf3c93000229kunm7d32d45d8a8c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHhhKVkJJGE5PQk9PGU4fS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHklPQUMYSU9BQ0NKS0FDHUxPQUMYSU
	1BSVlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 295F220002
X-Stat-Signature: ngd1fhbnypxkwqae3mrttxb3d5smeimq
X-HE-Tag: 1777566785-874844
X-HE-Meta: U2FsdGVkX19cx4hu3L/amDhZ8+05l0Gjxcj5/bvv0/KPcpiIwJiQyZ0CzDdTuxI76FggEmekAz/IVxtZDhLlQejreSI5n+C5wcQ7kJ6YTKn4hl7H2C2sv4tcmxX3LUvbD/UOMKebCApI6cjYGzJPbwI8pWzp2Bvff4PX4oc6qB4uKDiNzTqCPH0VaNfDjwvUkvzRn4OGrGwnj/Mj7JiSXSDR1Pt7VxBQWi3Y+WOpU8BqBgNk5uPhgKwFAO6CnUk2Cz6Dj+CLtII3hUu53MulNytUidL2B4A0ZDRjB4DfiAmE1uSdB+n3OGzyCosOsUSzSGJ5NbAGk79dLMZEZrF2HemMgyoCwrFGHOwyufMw6nm6CoY4V81Fe51UeFFGH8qsvtHmCfk9xmGW54FHZofC28iGIXLwQOYgo80+9iDtTFEkOX7FPRs+k0hvBPbtHH4cnyQy85iWl1doRs6xFEHbOu9/JY4nc28F2cfJqo5TL8OG8sYKx+LzvVPnYbg7OSLy3Ppiw8HHWUHpBw02aje0Tle+y4/3LQDmy4zkxDbGjjnhNFJ4JpC9ay9r0SLxa0KXY9SFJoOAbXO2hWXhp2LKUn7Xbp00Ih0S/2eXBRt4/LjO3u0YfaH/d2Ql95MqsVDFwXOBPboBodrM3ymSySk09y7hFvhQRgQgagvfVr7uFTi1CTc9lSNRHURp+oIZgNspy/VTDyH7r4Reu3iNwvt0JF0P/rbL7KNXI4GNyVolDuFKQdZcx0jjKw4HSHOfbtCBS+i4ZvIShJkRz47w6SV537X3KhCsY41XDjrxjuoRExgb7/tHC+OQPhEV476drDwn1pp9isFu3chDVgX/cR4eVdRQrm2lJHqqRH/nHM7iOqe3yuLF7tL+60BaZEiDhN7Gm2Pclj/oQ60jCkYNA8akDME7dYSDDLK7NjIqpfWpBijfyBCIUHe3KuOuvgqfC6VwS1nyu43Igep/32KgKOP
 2kyvGe0/
 V4+3kHbYDPrzuuIXc3equPtYnKoKeNjbYaf8ZsmydQ8HwzzdDbX0KQCEOLjlpJV5YoK2bG79X9A5WGDzy/Xqlw8gu9X8ssWHqhG6KSLewRNJyOMkQTA7oBijWRulMZiqF/yRS94skTnNncpdfdVI++tGxnkSUudV60dhikh4kjH+rIOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the page_owner filter functionality, including:
- Print mode filter (full stack vs stack handle)
- NUMA node filter (single node, multiple nodes, ranges)
- Usage examples for both filters

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Changes in v4:
- Update print_mode documentation to reflect string-based interface
  * Change from "0/1" to "full_stack"/"stack_handle"
  * Add bracket notation example: "[full_stack] stack_handle"
- Update NUMA filter documentation
  * Remove "-1" example
  * Add empty string as clear method
- Fix indentation: use tabs instead of spaces in code examples

Changes in v3:
- New patch to document filter features as requested by Andrew Morton
---
 Documentation/mm/page_owner.rst | 61 ++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index 6b12f3b007ec..178bacfbb3fd 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -74,7 +74,17 @@ Usage
 
 3) Do the job that you want to debug.
 
-4) Analyze information from page owner::
+4) (Optional) Use filters to focus on specific memory allocations::
+
+	cd /sys/kernel/debug/page_owner_filter
+
+	# Print only stack handles instead of full traces
+	echo stack_handle > print_mode
+
+	# Filter by NUMA nodes
+	echo "0,2-3" > nid
+
+5) Analyze information from page owner::
 
 	cat /sys/kernel/debug/page_owner_stacks/show_stacks > stacks.txt
 	cat stacks.txt
@@ -238,6 +248,55 @@ Usage
 				./page_owner_sort <input> <output> --tgid=1,2,3
 				./page_owner_sort <input> <output> --name name1,name2
 
+Page Owner Filters
+==================
+
+The page_owner feature provides filtering capabilities to focus on specific
+memory allocations (e.g., by NUMA node). Filters are controlled through debugfs
+files in ``/sys/kernel/debug/page_owner_filter/``.
+
+Print Mode Filter
+-----------------
+
+The ``print_mode`` file controls the level of detail in stack trace output.
+
+Available modes:
+
+- ``full_stack`` (default): Print full stack traces
+- ``stack_handle``: Print only stack handles
+
+Reading the file shows the current mode with brackets around the active option::
+
+	cat /sys/kernel/debug/page_owner_filter/print_mode
+	[full_stack] stack_handle
+
+The ``stack_handle`` mode significantly reduces output size. Instead of full
+stack traces, it prints only the handle number::
+
+	Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
+	pid 1, tgid 1 (systemd), ts 349667370 ns
+	PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
+	Flags 0x33fffe0000004124(...)
+	handle: 17432583
+
+To retrieve the full stack trace for a handle, use::
+
+	cat /sys/kernel/debug/page_owner_stacks/show_stacks_handles
+
+NUMA Node Filter
+----------------
+
+The ``nid`` file filters pages by NUMA node. This is useful for NUMA-aware
+environments to analyze node-specific memory allocation.
+
+Supported input formats:
+
+- Single node: ``echo "2" > nid``
+- Multiple nodes: ``echo "0,2,3" > nid``
+- Node range: ``echo "0-3" > nid``
+- Mixed format: ``echo "0,2-4,7" > nid``
+- Clear filter: ``echo > nid`` (empty string)
+
 STANDARD FORMAT SPECIFIERS
 ==========================
 ::
-- 
2.20.1


