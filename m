Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF54FCD98DE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 03:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D48F6B0093; Wed, 17 Jun 2026 23:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511646B0095; Wed, 17 Jun 2026 23:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426986B0096; Wed, 17 Jun 2026 23:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0C26B0093
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:58:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AAB51A0645
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:18 +0000 (UTC)
X-FDA: 84891675876.17.6CD1CE2
Received: from mail-m82135.xmail.ntesmail.com (mail-m82135.xmail.ntesmail.com [156.224.82.135])
	by imf08.hostedemail.com (Postfix) with ESMTP id 367A2160003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.135 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781755096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ItFcvXUylDLtztUYNUWHJT0jInwN4eJ8mU+enojXGhQ=;
	b=FxTidF/ZHWa7Ih8LnllIuBwAY0KfFsx6xmWkR3o/Vr47BSutDM//7onVjgHZ5CtiFiZluu
	Pt/5th1dtea8hUEdNcoTwAja8zzCNyKlC+NJdsGj36mbF16tcWMJ5BjmUPkNYgVh6RUjEs
	VkAgR5O4inx2nIbetTPpoKT6Be8nSF4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.135 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781755096;
	b=BvoXDh7up1rlm/noGF5PtCuCcTW7h5+D0Cb0asu8NT01hXWrrzLWdcjEP7Iac46KSaf9Zx
	qJdjfdOzc2NWtwjDzOALTFo6BvAxGcu4DWwOiqFP7b7h6kNcb4ij7RYQsY14lAPKQaxFRW
	639fdq00Y+fHA6Pyjxm/jDvBAcRikY8=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b989993a;
	Thu, 18 Jun 2026 11:58:12 +0800 (GMT+08:00)
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
Subject: [PATCH v10 4/4] mm/page_owner: document page_owner filter
Date: Thu, 18 Jun 2026 11:57:50 +0800
Message-Id: <20260618035750.3724613-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260618035750.3724613-1-zhen.ni@easystack.cn>
References: <20260618035750.3724613-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed8e11d0c0229kunm88c9600fddaba
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGh5JVk4YH0wYQkhOTkMdTVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: djf8p9w4w9uo7w7z4j415a4zudwmg6g1
X-Rspamd-Queue-Id: 367A2160003
X-HE-Tag: 1781755095-553081
X-HE-Meta: U2FsdGVkX194x/BObKVDtFq4dXit80kH9WYMsHN1xcTN/ADoU9FHbA1AofJvCq3ahTUV7BWq7pEe9kjis8q693BjwCznpNxHdLB4zoVYfZg2K5zrX18dlx6kuPHruL/o6OWpxRqDeKHped9/qE68wySXPQVcQ7ExhgwCboLo/V71h30qTNlsJZd0au+dIpD7+610I61EVTrweHDHWFkh0GDy+JOnkg1JhWyNDwddlg9f1V6GDfSdXyLvehLx38TGd51D8Yr0moICUrM8Czn6NeIseVOfawF6vw+3RrGrugIY+GT5excBj9XM2Wn6qElYDMwBcGN136z+k5nvrffI2Jsq5iZIIIl3V7q8xZQs0YYuo9Zk4w32f29+8JW08hmNajToeciTbfUE0RGMswZYCvIbtXkjU6NT8f1Z5q1y2LQG9H9zHlmTz3T7vsyltNsgsBwdjH1lsQpTqntdsxdFUgIMOiQhhrwFaRh8/7l0LxLwDGjp10isuaoTXDBcPLz079ORs834jB/gP7rdaWxOa/LBjpbU0qK/XuZVWniAuWqNiEddVyQN3h/xICkQPnPGOofLzgd799ptdZEy6cHfbxY9gYy3J2t1/oPML4i1Hji3vymywwaQigoo/JOCtZl30WgLKkZK5mej9EhAQMLq4vwRUCmnbUEuXtcmZweg5rfFL9GMc6OcfeRtCOww8BpqydAQPzfyZwFpPn0v2NUPsQG2c2PRbnEZtQAks/J0Djac8nER4+L2AdMcDrB/KbP22kNvw4W76KHJ1hLxfXnUXChbmfQ+ozkbAiyOyvVKCc3kj87583ibSXEcJ+JO7vWr1z4Zf4kfGeXMkXzepUHb5qOUk8p0vqr5TDGyTOcWMQ/uTh9oCqpImbgAVLk29WnxcwifwRk8O2phSqm9AI+nDxGiCXWKHCZTAhWwIaDw3xE/wd8Nn7dWGF8aP34B3Hv0l5+yv5Nrey/gLoEmdW+
 u+Ifd/MA
 nrUPQepQHziSWNrVXM/Hgfi0CLZQcT3LfhTH7tBAEHzCYOQXd0C7kJjY7Jf5f0zBUGIRUZc2FAtwpBUTeD7jCebROrifsmlB+X2aD/AMfV20C1uhURpyFP/84pqB1M2LDmYcCmyVZJiwlNj7AyaFxL1AX2nqpLHUmMJq9Qtkj2l5StVQ=
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


