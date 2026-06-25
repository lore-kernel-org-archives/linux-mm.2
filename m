Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB51CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937256B0096; Thu, 25 Jun 2026 00:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0916B0098; Thu, 25 Jun 2026 00:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD336B0099; Thu, 25 Jun 2026 00:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 532976B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:31:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C636A1C29B3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:31:24 +0000 (UTC)
X-FDA: 84917160888.21.380F31E
Received: from mail-m824.xmail.ntesmail.com (mail-m824.xmail.ntesmail.com [156.224.82.4])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A4BE140005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:31:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782361883;
	b=3SaaMg61Zl5Qglzw4rtoTY2+5H9OGd3R0NRh0ORVjVoBKZjo8Nu+HifL6SfaWru8XGbDnI
	4xdyqI7bvrUFA1tP4X1JLPZtvZi4wOupNLNkkDS8SoOs0MZrFZqBWiGqybtZVPNhJoOxIL
	tqvtVr6MxIOFEb1HGSa7fTeiz4J4rR4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782361883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sfnAX8jjc6asGm19Oxk3llABEYezlx3Dp9E7ZD9Nd14=;
	b=vAUwnWQ9dII+kK/l/daT6zTNCA+mU+lCIZZ/1nGg8L87kl49FuL52KzAIAXtOB3GmeuhyD
	PHLM6kVz+Zv/riUNXm50I0asep3Dee7QnVIkylz40oiKN24HwJr+Ca5LWYDPpKwj1V5E1w
	f5ckifLQVoe9Ix3OCgP9sL/DeKqeGuw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1bdf898b9;
	Thu, 25 Jun 2026 12:31:18 +0800 (GMT+08:00)
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
Subject: [PATCH v11 4/4] mm/page_owner: document page_owner filter
Date: Thu, 25 Jun 2026 12:31:01 +0800
Message-Id: <20260625043101.338794-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260625043101.338794-1-zhen.ni@easystack.cn>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9efd0bee570229kunm7d49e2638b50f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHx5CVk1IQkoZGhpOGhkYTlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A4BE140005
X-Stat-Signature: no7ygzjctkbw6qpcoaqh73j79b9pxtkq
X-HE-Tag: 1782361881-553450
X-HE-Meta: U2FsdGVkX1/6xsIOwEBQ1/cBZBJW43Wox4R+9cDUNml5kcWtt4zmuyVzWF+ZC261EAh01Tk0FRUeHu22L6MI7NslsfOC+oqa27STEyDszWL+leG+rlRKF9XHfP/hIJc+Fn/afaAnr8mFCZpxrk/Q+hhYahtFBLrajaEBIHC2zySGvDQXv5wmkPOMFoOCZkdsXnBlsjB6pV88WrzDrE2CDIY5w8peYi1LRFopqbgXombR4v55pUmApbVzP9+XQOOGyVxBvab6bQ5SRk6DkbS+hl69frae9TnaEM8umrjcsGQlcW+bbLL8f/2yvxpywp68fLc3BaU9CdzkM78CdBo5V7Cc4Boh3E44l7uuE7taCSbvHIms0aZ8JXqOS3vmXm2vzfCxGiKZ0Uqf0NtAVydktM9jQjkZfHlhFtdQDCBBzoe5BTA1AhltftSskebadOFq3OrU6ANrEK6tbYLy0X8Vn3GUOtUUeXXqDOYKIab4NAfAfy70CqJscOPLumX56T8uu8AZNZTqjGUKElNJ9l16YR1JppU4PtFFFIyQVQi3qVve12o6aiyD5xHkjdR0LCUSSSFTj09ucfCUWUBNwLvOx11xqiIQDCBBC9TfySEaLZdV+6/h/XzBqfgLj1Gud8KQUKhlnCWWlaWaIuhQlCazGb2UevHtHTZK2Hk+5aEBa0LvzUj9f1br2ry1TKW7yAlWeA2SiYRxoFTGZyFUxvmDUwm+lqGWknSaxGC95kEaLZy0bQ5oCk4cRbGS23OvnqJuFLAZATdAjo3EitbZ4+OkI3SHAJJpnce9LRbOLNziFzRKSNdjn/+MCPjj3IMReGWoXRNWVDI1hRAViONeMnk1togxJjTRereWdbk8u4IkkSmAkfXmSjT+hdBotegDm1ToKfZXvax13KRpoEq3ogSXeFtw6cljNBIGXaEA5P6mqLKatfcUNlACqS/JIvxTEydRULqDAMqOET8HD3wo9Oj
 oRuCYVt6
 x8FDrIhi60d/Y/HZ00NaZVNrKyfLbMRZqMHA/R66S4/EhNKmCZMVCfPFEzBBzcmR3E0QejNKpLdrifDTpji6vvU8u9oT6j3OZ0JlqyMpoVA1QfS3Gbjg2R5HzUgEPjlXor3Yut3/RGXg2sxMMmPitsboiv0GYNf76h+RfYpd6VHTkiyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the page_owner_filter userspace tool and
kernel-level filtering features.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v11:
- No changes

Changes in v10:
- No changes

Changes in v9:
- No changes

Changes in v8:
- Fix Sphinx double colon warning

Changes in v7:
- document for per-file-descriptor implementation

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

v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-5-zhen.ni@easystack.cn/
v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-5-zhen.ni@easystack.cn/
v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-5-zhen.ni@easystack.cn/
v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-5-zhen.ni@easystack.cn/
v6: https://lore.kernel.org/linux-mm/20260511033017.747781-4-zhen.ni@easystack.cn/
v5: https://lore.kernel.org/linux-mm/20260507064643.179187-4-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-4-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-5-zhen.ni@easystack.cn/
---
 Documentation/mm/page_owner.rst | 77 ++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index 6b12f3b007ec..383e59c42743 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -65,7 +65,14 @@ un-tracking state.
 Usage
 =====
 
-1) Build user-space helper::
+1) Build user-space helpers::
+
+To filter page_owner output:
+
+	cd tools/mm
+	make page_owner_filter
+
+To sort and analyze page_owner output:
 
 	cd tools/mm
 	make page_owner_sort
@@ -74,7 +81,11 @@ Usage
 
 3) Do the job that you want to debug.
 
-4) Analyze information from page owner::
+4) (Optional) Filter page_owner output::
+
+	./page_owner_filter -m handle -n 0,1,2 > filtered_page_owner.txt
+
+5) Analyze information from page owner::
 
 	cat /sys/kernel/debug/page_owner_stacks/show_stacks > stacks.txt
 	cat stacks.txt
@@ -263,3 +274,65 @@ STANDARD FORMAT SPECIFIERS
 	f		free		whether the page has been released or not
 	st		stacktrace	stack trace of the page allocation
 	ator		allocator	memory allocator for pages
+
+Filtering page_owner output
+============================
+
+page_owner supports filtering output at the kernel level before reading,
+which reduces the amount of data that needs to be processed in userspace.
+
+The page_owner_filter tool provides a convenient interface for this filtering
+capability. It supports two types of filters:
+
+1. **print_mode filter**: Control what information is printed for each page
+	- ``stack``: Print full stack traces (default, compatible with existing usage)
+	- ``handle``: Print only stack handle numbers (much faster, smaller output)
+	- ``stack_handle``: Print both stack traces and handle numbers
+
+	The ``handle`` mode uses numeric identifiers instead of full stack traces.
+	The mapping from handles to actual stack traces can be obtained via the
+	show_stacks_handles interface.
+
+2. **NUMA node filter**: Filter pages by NUMA node ID
+	- Supports single node: ``-n 0``
+	- Multiple nodes: ``-n 0,1,2``
+	- Ranges: ``-n 0-3``
+	- Mixed format: ``-n 0,2-3,5``
+
+Usage examples::
+
+	# Filter by print mode
+	./page_owner_filter -m handle
+	./page_owner_filter -m stack_handle
+
+	# Filter by NUMA node
+	./page_owner_filter -n 0
+	./page_owner_filter -n 0-3
+
+	# Combined filters
+	./page_owner_filter -m stack -n 0,1,2
+	./page_owner_filter -m handle -n 0,2-3
+
+	# Save to file
+	./page_owner_filter -m handle -o filtered_output.txt
+
+The handle mode is particularly useful for monitoring and performance-critical
+scenarios as it dramatically reduces output size. Testing shows handle mode can
+reduce output size by ~66% (84MB vs 244MB) and improve read performance by ~4.4x
+compared to full stack output.
+
+The NUMA node filter is useful for NUMA-aware memory allocation analysis and debugging.
+
+Behind the scenes, page_owner_filter opens /sys/kernel/debug/page_owner and
+writes filter commands before reading the filtered output. The filtering uses
+per-file-descriptor state, allowing each open() to have independent filter settings.
+
+Each file descriptor maintains its own filter state, so you can have multiple
+independent filtering operations running concurrently. For example, in different
+terminals you can run different filters simultaneously::
+
+	# Terminal 1: Filter node 0
+	./page_owner_filter -n 0 > node0_output.txt
+
+	# Terminal 2: Filter node 1 (runs concurrently)
+	./page_owner_filter -n 1 > node1_output.txt
-- 
2.20.1


