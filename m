Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2127FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504946B0096; Tue, 28 Apr 2026 03:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B866B0098; Tue, 28 Apr 2026 03:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355DC6B0099; Tue, 28 Apr 2026 03:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1326B0096
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:11:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBA151C0765
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:36 +0000 (UTC)
X-FDA: 84707094192.13.FCEF07A
Received: from mail-m82136.xmail.ntesmail.com (mail-m82136.xmail.ntesmail.com [156.224.82.136])
	by imf08.hostedemail.com (Postfix) with ESMTP id A2A2D160009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.136 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZpdmFFUmrtk+Qa/nrznvPET8CgW/NRZvvuVITWpeWM=;
	b=Ua+4GNBQ3xe3gnAfgHUW/rsiGK2MHSKFjGwehjOqaEQl9DKIE6W3EFDulG6qBFAIzFc24B
	PYUxEvxD5tmCi57dvyTOxXmplZBZ6SoQLa+W+YC09tLlMI2IuFrfKVVN/1CVnhS/94djlV
	l/GkhJZ/UIT7149Hr68B0VsAfR7KxEs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.136 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360295; a=rsa-sha256;
	cv=none;
	b=ksicMfi+NtNAj9uWqWQAHXPfPAsHzKAuYZWAk0ZP+swlNTn/xOOK8Dn8TEzl1yV58a3Hyp
	4Mz7avLiKoJatd5jqtMyN216Xdg+Ku08RyCBQDC9hXFyqC7MalGotcI6XfXpUNwLtEvCuf
	A8o7MlHX16tWt/+51ZcJ3miMKPjbzWE=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 197b49313;
	Tue, 28 Apr 2026 15:11:29 +0800 (GMT+08:00)
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
Subject: [PATCH v3 4/4] mm/page_owner: document page_owner filter features
Date: Tue, 28 Apr 2026 15:11:12 +0800
Message-Id: <20260428071112.1420380-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428071112.1420380-1-zhen.ni@easystack.cn>
References: <20260428071112.1420380-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd2edc0af0229kunmb0c223f1156f39
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTENPVkxNSk4ZTk5DGU1JHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Queue-Id: A2A2D160009
X-Rspamd-Server: rspam06
X-Stat-Signature: hhj3rbey3znasfndx7exzmaff7d7sz1w
X-HE-Tag: 1777360294-26831
X-HE-Meta: U2FsdGVkX18fSsyqB/JiUyNGOKdPZXUk7w1C7tNUTPvhlQesDvCrhw2+x1+mDf6xFpBL+pcxMagmbfnzhSXW7/fQOmEihRV9dIcAYd6049iQRYUEwjhyaEvyuvGGYcR+jN898nOouQbRdybpQe4EgOofoOp0idn/c1+5n8Z9lRgFxDw1RsK+dE+t4rDxVAu6QEjVk+eITmJurxkUsMey++ZyHIpy7cmPXwIU1TLFI1oxdfsge1DQMbDZOkPgZmlasL5Fg9zPsrhBN4xf+RsZ9/cgc6Wr9FLtXVCsfbUxQ9cd85UKCZ3+Z/qy+ExKndFrwYZzHF6ztf5POJdYzLCxiOHhBGJNxasrbIyD538K9jLxJ7I1ag1xjFC9r6Uv7R5FQoB5M3IIJzBz21vX9vioReH12GDFY9JfhabnXhlBTV/xvQZorS4JV9AnHJRHbyJSYzUMCek0LnqvMh32+VWXXIIZgKmI8WbWjGpT5Jo9Q/DYM0aYTDpwP45ql+j6UG8ojHctt3+H1qDfayRXAyMemI8ue8J5eNSuFZopCPOLU3yp6PC++4wQh8pdrte5VmfcTWjQmq4HezfBILWaCXnjWckYn1DqNAYdWz+BmSNJH3CsZEYWEK53VFcqH7K59CzaRPRYDJtrvP+3tbBnouKrPunM9YhDhPA9BKQjVakrNOTDwBjb4WzimPePQnrwo9L4RU5t0gU6f33MCI3frNOKMWk0pXEUWg0qKAvvIUnZixXGIIB6fm/UJ6wJI2TzccF5ujrmAMsWFj5iRTBUsoOdiF4qqsYFHvqVCzgmlj3aQWMka7LFYoLpPy+5ZsUbq2aL1jr07lt7ED6qdoeiG7xpd39+DGOcgT0mK40Dh3fatEJXdh+eOFuieQukczEiXVXKqPcvSumAmTe3rs4B/NGDsALxpqtqlwDgOXkD18N68CE87T2D/+e5xJMiMxedAqFZVtTgYrVsaYN+LzjtZws
 xZI2LMLU
 M5Zq9sri6is5iPlEMYDNEUgJs1Cf5fdS6gnkIv4jsmRuUDhRjeeFTlVa9dVcu0WE20fYl5/3CUHIXVTjZ5rOrQUF2pG6C75g5kRX+H9kHXBCPqDjKw7/FaQYEJz6iqAZSoRleIvUn+uiN2vU=
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

Changes in v3:
- New patch to document filter features as requested by Andrew Morton
---
 Documentation/mm/page_owner.rst | 55 ++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index 6b12f3b007ec..6261366d33fe 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -74,7 +74,17 @@ Usage
 
 3) Do the job that you want to debug.
 
-4) Analyze information from page owner::
+4) (Optional) Use filters to focus on specific memory allocations::
+
+    cd /sys/kernel/debug/page_owner_filter
+
+    # Print only stack handles instead of full traces
+    echo 1 > print_mode
+
+    # Filter by NUMA nodes
+    echo "0,2-3" > nid
+
+5) Analyze information from page owner::
 
 	cat /sys/kernel/debug/page_owner_stacks/show_stacks > stacks.txt
 	cat stacks.txt
@@ -238,6 +248,49 @@ Usage
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
+- ``0`` (default): Print full stack traces
+- ``1``: Print only stack handles
+
+The ``print_mode=1`` output format::
+
+    Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
+    pid 1, tgid 1 (systemd), ts 349667370 ns
+    PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
+    Flags 0x33fffe0000004124(...)
+    handle: 17432583
+
+To retrieve the full stack trace for a handle, use::
+
+    cat /sys/kernel/debug/page_owner_stacks/show_stacks_handles
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
+- Disable filter: ``echo "-1" > nid``
+
 STANDARD FORMAT SPECIFIERS
 ==========================
 ::
-- 
2.20.1


