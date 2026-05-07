Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9A7CD343B
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 06:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40F786B0093; Thu,  7 May 2026 02:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BFD96B0095; Thu,  7 May 2026 02:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261E56B0096; Thu,  7 May 2026 02:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 145766B0093
	for <linux-mm@kvack.org>; Thu,  7 May 2026 02:47:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EAB51C0E36
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:47:21 +0000 (UTC)
X-FDA: 84739692282.27.E6A859D
Received: from mail-m82135.xmail.ntesmail.com (mail-m82135.xmail.ntesmail.com [156.224.82.135])
	by imf16.hostedemail.com (Postfix) with ESMTP id 54330180002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:47:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.135 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778136440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3x7AA3JYH2+eCppI5zkUUnt7CodUivKzyvJyf7b+q8=;
	b=bV90evoWAeaN5c6SgRu/Flnh2s1r8oGEy9QeF2OcwI0TuunvM/RyM0jbsJADH1UInTl/G0
	/IPYws+G72w5pEV615CKVEbK8KOLMuPe9VeqeGT6Hf4qq8RaFbcu/k8JxoTZb195pkKNkw
	VayQXM833XNda01Od4XFcjJlGHz03u4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778136440; a=rsa-sha256;
	cv=none;
	b=a8mB2Zo3W6qzX+fsWH7MoLN11HPd5ntW14Bpb6+hGAts+18qbfOwkL99uh77bbu0MyGOpG
	cnbYkRByWM4DDNnitAZxdhjqCvj5+f3Hm+2ETC5Yc1YGEcCwCBNNny2ZYoTTu6py9DtiJ7
	fQj9X7zUu+cQbXyQqb46kg6kPkej4xs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.135 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19cdddfca;
	Thu, 7 May 2026 14:47:14 +0800 (GMT+08:00)
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
Subject: [PATCH v5 3/3] mm/page_owner: document page_owner filter features
Date: Thu,  7 May 2026 14:46:43 +0800
Message-Id: <20260507064643.179187-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260507064643.179187-1-zhen.ni@easystack.cn>
References: <20260507064643.179187-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e0130c7410229kunm3f68df491bc969
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSBhIVk0YHkNJGE9OQh5OSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 54330180002
X-Stat-Signature: 4owbordaqbgjeo4teosuc3qcayqf5drs
X-Rspam-User: 
X-HE-Tag: 1778136438-919158
X-HE-Meta: U2FsdGVkX1+bij0633cGxHJ1eNx6jftjuuyq5OgT2kKynDy1eOlmBa/Tpya/u3bVXBvtEKqZsV87sMKLhgmynlo9ty6ye7lgEcbud5ipmFNyzdZDhzUO2LwRL0DbsuUzLTHBPhHBsuoTuU7xtNVeBfagDTc9CbfsDws7+sjGLD49KCo2LU5fQQHBBOnldFZAI8L6wH9v7lbIZqx3n86gdeoEzXzzhOMvXvMQF8ORIXkzvZasiXhG04s3BwagRPMbIUtyXlvp/K6S7GqPJlbm45lUIBZlZUE+PSqD2tetWnEPhbnPeHhLL49BatqOxjiHCgS3VOcCHq0dHR6SFQj0fy10AWSnvM8yUPvgnMhW/+oHyAPKTcmxKSmXTy1o5m0akMy03unCUrqMjlseUIDGDn4wQsIW3PP8XTinxS0oOL0VgJ7IW3pL4Wnf7zI2S7HdKgZft4m+e7N1Y5e/fLFzHxbw6iP/H1tArLzM6Vb9gXxbjAtBEoNPAjoMecn5vHy0+/sIhz5wHdphYhFZf2fuECrG1qWhrNKxNTPXnpDM/6IVymblGBbn8PKsYnRcaWCxDTfdFlcBF8chiKL/RG5BmiGBle93gbRl3Mrrq3p/NhD9MCGCgWXdKY9FW5DHf7Q4evjD0xE1LJF0r1IhnrDcoeJOMMgnRfT7Cike48DF9gw56Uxw2Gdb4zuTEwkJzf+ldqivN129lF08TAkNa04u8b0uwNzhP3yTjkIVHVwBaqvTqHzzEdXYv2hPtdAowaxclK5Q3GYGWXaUmjw9Gjdm+unoYQKWHhVhLMMIsy4ATl/Z+uvpCSMHGbgECHzza3zi4ux0cyY1fAT9Ukbgb6EFiAXlIoYAaYbllls1EfLyDRultt1yqya3DAc7k6CQsSq/JHkxxcjZu9R+Q1BY4b4o+GczurIQpbdr6BEf4UvyRCaMXdwgJc/dkoS4ekp+nkr4rusPpwDYiN17TiucKhk
 EsZ6LEps
 eWYvM20JBDsqO2IaL3ALwiXaFZ3GTy9pj25nvSEVf70rzVru6ugG3UMmve7vbl98rwQun02kVLnNUsidhDoyNxdxsdRVgLNy/dVCs/HtXF15IgrSQC/ye0lWKuyR+A+3B/LPremFEnsZOHyA=
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

Changes in v5:
- No code changes

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


