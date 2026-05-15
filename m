Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC7FCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504BF6B0092; Fri, 15 May 2026 05:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D98E6B0093; Fri, 15 May 2026 05:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B91D6B0095; Fri, 15 May 2026 05:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5C26B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:20:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD475120608
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:20:07 +0000 (UTC)
X-FDA: 84769107654.02.4A8B1F8
Received: from mail-m82152.xmail.ntesmail.com (mail-m82152.xmail.ntesmail.com [156.224.82.152])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9F56E160009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:20:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.152 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778836806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ESnlrLu6PVRpxz98EDxZjt2vKL3FBZm6GYaytSjYSps=;
	b=laYnL0hsR5re5r9AeY8eZlJhsuMpsGsdBIBhmXhAunWZLZpDtNbtoEIdJ406yw+8hcRoDA
	1yH2vP4dqM2zyx5ec9QxMa8DHLCQdk5zkvoB0kh9huSmTbMqlfEV1IU5jlF7VcitIEO/Xq
	3HrkborixDu7S2gomG7AzPZazp642Y4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778836806; a=rsa-sha256;
	cv=none;
	b=5xkoyGkNYdJrbwm6jpMaccVo/9TPsuykDDxpqT3zw6eSiHIZEHmCbUS1AkBH7iyyl9694U
	mFrgSEL36LHwWxwD+C6uj3P6SzD3y64Ogs1m8T2lv1k3CrY1yt3ldbRjUtL7tUzVMkjTsY
	QTNu9Ty2BnMYvG4RamPixwiGTgAmLWI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.152 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a2c1b5b6;
	Fri, 15 May 2026 17:20:00 +0800 (GMT+08:00)
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
Subject: [PATCH v7 4/4] mm/page_owner: document page_owner filter
Date: Fri, 15 May 2026 17:19:42 +0800
Message-Id: <20260515091942.1535677-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260515091942.1535677-1-zhen.ni@easystack.cn>
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e2aef84350229kunm2e28cf4e13723d
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQkNJVhlMTB5CQh4aHR1JSlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F56E160009
X-Stat-Signature: ouoaakxdgzazquwt9cbtuusibk9ua8zy
X-Rspam-User: 
X-HE-Tag: 1778836805-314952
X-HE-Meta: U2FsdGVkX1+mInaPg2iujmxLyBI9w5PshyB03gKLhv9gB8upMHBo6DrIy+n03F/16Q7aAWEWrKd4xtogMR/dcbfdXLvyN/LfCm9o5sx0TTN6eqHj75PVQcKga20SGRKt7o3pYzbt1UD4y8ZCu3GpCR9Qbflk+lxTg93LiYOzY5EbPDaZxbUhVLV6yk9uZpwQ9ZvEO8Uz5gY13M2cbE9FmJoxFqXgju/jQ9lzQiIF5d1KXJJR5nyDtqu1ioU2pHlailWmLPj/OrImlHtzxiy5Rr7Qv36Iu3ZukLVCHwJIBL9N9ybejmPnJBL0Ndvs8nsqCR7mG2YExeuHa85AgQbTfDI5kwKhq317zypxvZxghj7+NtFMCKJGssvs9cBJrgD1E8UDGsErnHXCNKdfZbITwbYv+vsS+w3O/4DBlNA24h49h4q4dhCOAV9+mM9DXYcoulSiaFvY8g8udc/L3PDWy/q1MNLvvWHRVgW86WcXx7PoWMuLvsmPZo8pXGTUi8MjMKboCLjv81fDjHEL+9GosGN4ONnsEvdrDkWrXT81B1OcREqPdvDefI3XLSZlG9taofuyP4qREpZ5MOXrxpInlM2gUYsfHlKYvkzYRsIC/OWcVCWzY7I+IpvriwEoCOFK2kJEU7PvGTqIF5rp9FqG+//2rXdpCud+FUwlbzTpp93u10AWFHoNXqD2n6KF//VqgfwwabezcdOVQro4dgDQ4fisWMLJhESEMos2oALNWSXCzslXyZYi3sHLU64Itm27EIaFx9X3YB028Kkb4muXPZ0ltM4V3Bi1a5TysXo94CVYIC/bMGLOPSt3NddwF+uRmc+E0gSDHA41YNRUWlVwz9nvt7FK/qzlmOFcPgHkXZfFC69xC/9bDybxV8mD8+zHL20YqDTjTs8Iy5cj6oiGDr+V+YIzOGQ9DTK/BkA1h6AuZHPOQY7+lFBjIF0Rp7KSMmWrNN3pe7mm3oMn32a
 koad8JYP
 cNDXTcwlRWDnd3MiuFAoiyLa2qSWwcZKQxCOIC1XmaJqjUYPOG7UKKx9Gopk4HyQDE9T0Q99KEbe1g0tN32wH4LOeRpbszTSk1espZAzTNlrTclX0U7Qt/6RptYBhU2KCl9GZSh2ugX6YWEUKIv1CFz3mAsm3avPChhn3/dbJ8MfOSlo=
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

v6: https://lore.kernel.org/linux-mm/20260511033017.747781-4-zhen.ni@easystack.cn/
v5: https://lore.kernel.org/linux-mm/20260507064643.179187-4-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-4-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-5-zhen.ni@easystack.cn/
---
 Documentation/mm/page_owner.rst | 77 ++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index 6b12f3b007ec..aef1fe561ade 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -65,7 +65,14 @@ un-tracking state.
 Usage
 =====
 
-1) Build user-space helper::
+1) Build user-space helpers::
+
+To filter page_owner output::
+
+	cd tools/mm
+	make page_owner_filter
+
+To sort and analyze page_owner output::
 
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


