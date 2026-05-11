Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A44BCD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 03:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17326B0092; Sun, 10 May 2026 23:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78CE6B0093; Sun, 10 May 2026 23:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40AB6B0095; Sun, 10 May 2026 23:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88BD66B0092
	for <linux-mm@kvack.org>; Sun, 10 May 2026 23:30:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 507A11A056B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:30:37 +0000 (UTC)
X-FDA: 84753711714.02.1C19B48
Received: from mail-m826.xmail.ntesmail.com (mail-m826.xmail.ntesmail.com [156.224.82.6])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1E7B1100006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:30:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf05.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778470235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rf6H+Xll49/vPmnkJCZQvDPt4sQfcEIg0ho7AJPHOQk=;
	b=OIb8/Z+6Utm0EGIkBwwFIkqPRfcSLDGyXUd8Zx+eM6fdA2Y0v9e629V+hTudao4UVAheB+
	G9YPktwqRPno6uUYmsO9h7UjJyHV812FEvd/5VBOEq5TjG8RISEhD515nIDsRnKviF3ZU3
	YHPtbhjP9vBcxWt66GHGJjQuxtcoUUo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf05.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778470235; a=rsa-sha256;
	cv=none;
	b=Kk4vO7FVvP4zsoul6HIIumQYOuYxInNMuCeNOVFekx5mOpZ6Anj/2gK2PhNn31NWeMmJwU
	WYsG7YnwGnGZHQTKykpHX88fsFgmT0kZL61/JrRPcelRFCtEAJHeFcutvDYCSyiu/UGrPO
	nNkpYAYcyodblliR0uqkr+o7DIO+mjo=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19f36187c;
	Mon, 11 May 2026 11:30:31 +0800 (GMT+08:00)
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
	Zhen Ni <zhen.ni@easystack.cn>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v6 3/3] mm/page_owner: document page_owner filter features
Date: Mon, 11 May 2026 11:30:17 +0800
Message-Id: <20260511033017.747781-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260511033017.747781-1-zhen.ni@easystack.cn>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e15161c480229kunm0464dab52dcf18
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSkhCVktLSkNOGhlMGR9MQ1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E7B1100006
X-Rspam-User: 
X-Stat-Signature: 9on38itwxtwentg3hcoomfh1zcw8jxdk
X-HE-Tag: 1778470234-418728
X-HE-Meta: U2FsdGVkX1+EyyuXvwUDI9hHWF2P8ZQznYncpMajzo8nNJvDQS1uvL1sWkuTGglDXfGgk6tq3FnbTgu81jbEvUqBQA4U0gBv5OzB3+i/vf6nNM4qcuF5AAjpUi4p8pNTtauQNNIJ9gGkglJoBa+abWEufiVpXPFotr0r+A0FYJAdc5uzHPXLQklbFdQnrrcYAmWBni9GLwDYvqTMtDKKre2JvDfr2yXmNBNOplBGe9YQbyrtBuzK/veUGFiT5FsvK9VKbF/mtOJxwPC+nutTvnkCTMdGClkCJsjo3lZXiQ36XnF+pG18lgmGCD3VTQxs8e54YqeEtnH9lV/TDuN4N51K6MU8X1uDNSiueItfYXAWR5TMSq+DfEYJQu15K863s0AHBCW+PdQGbDBb4J4HgtId4dc64KjinPuH3JPWMERRrIn/6V1A/t37TZvfE51dcnbWdrWVznngU2Kb1w6IvEc3IGR666l2cDShIuYmLVGUYrb+swgqi57PgNQO3TAu2s05E+22SlEUaUTs+6hH1nQXvM/VynDGh6l/WoxyQJGpqddsD3yty5cLwe4Gm3Wn/gh2EdTpxd6VSdK2Ylc2hlxfs0F9MnuRVseweMQKReOlRoOaGlJIfODnA2BOY1/cLaJ1O2Xv3xw9Q63BHSTCUaeG5D6P56L2e6zWAQZUj70at9WUTVissO6vYp7vIzMdXAssC6xhD5wgyVvdWZCkf0rvz6YJnztWloQTMv6wgL0gnnzSKiVd6QNxfPOrX4ltlIFQ2CrHcRGZhsO4gFReMFm2AW3PYiz2hoTMi3XKQ+CMznvQA41ZfCphjSVTd/TrcpJNtZU/m4sfFEDng2BftYK69truZP+CDwAuQ+iL9TXbVJzudNsG3REbpGLkFlFVwGRtHQiwbjR+BE9MXEoEPtZt5SQnauUOVLe3yZWNyKUdFC9cFJqX3FryqLn6cJyphTx3stpe+1FvNAFKq0f
 O2GcQm9A
 2peB+B6SmqTA/HObeVfUfLDpOGPYlmyRZ6+gl3HOjeaEkZFn/7ZggAi5BiB+2O3vVKHyeWrD8lx1c/jxnhbAXIIAvpFxV4bTD97+8FIoYBkjqC7bI5cjOE19oJzCg4qBvvBoytkRtwLEbMDzrWE+zb9YIErXUIKZToIkv+Q1erWP8ARw=
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

Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Changes in v6:
- No code changes

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

v5: https://lore.kernel.org/linux-mm/20260507064643.179187-4-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-4-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-5-zhen.ni@easystack.cn/
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


