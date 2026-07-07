Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D57D2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E4C6B00A1; Tue,  7 Jul 2026 07:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C876B00A2; Tue,  7 Jul 2026 07:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522886B00A3; Tue,  7 Jul 2026 07:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24BD46B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:54:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67150120401
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:54:38 +0000 (UTC)
X-FDA: 84961823436.15.368FE79
Received: from mail-m82157.xmail.ntesmail.com (mail-m82157.xmail.ntesmail.com [156.224.82.157])
	by imf10.hostedemail.com (Postfix) with ESMTP id 13054C000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:54:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.157 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783425276;
	b=yUGmVcfM8iIEwkiw8Qq+rN337zJ8ukAH18R3SHw1LI2NTDGDWquv0M+yQItHddMMlxjLjv
	oi8CPM/WagZifkNzvJzG/C2qtbC3htjGxcGPLil1v2E5lBQzOMV0SswZGKxatgkonosnoU
	3yRG7MdKiQYJZhYMLRtffp2Rrg+2Osg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.157 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783425276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QgQJWy4HwaKbwygggyHFc9lIdGV0UimfF2WhJi7kcJo=;
	b=Oy0w2xior+cUj0qLGCG12kMkkMe3+oCbPZEK41jxB1NZ5kpdtq6GNUsCTi1dmLaAU/4NuD
	jM8Hclmbp5fCqRNgMGDxrY9DRJ0gT105MvxmJH55KsWF1J8mDugPNemOzmE7/6IQUhqnh0
	kJ1V/V88qVAZ2SFi0YLB4XpCVoXJXGM=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1c66e4ef9;
	Tue, 7 Jul 2026 19:54:32 +0800 (GMT+08:00)
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
Subject: [PATCH v12 4/4] mm/page_owner: document page_owner filter
Date: Tue,  7 Jul 2026 19:54:11 +0800
Message-Id: <20260707115411.1714314-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260707115411.1714314-1-zhen.ni@easystack.cn>
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f3c6e096f0229kunm476cca175fab7
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTxhIVkMfTU8dS01KTx8eS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13054C000E
X-Stat-Signature: sa5j77i5xye3675yhbx9roxhirxxok14
X-HE-Tag: 1783425275-968662
X-HE-Meta: U2FsdGVkX18Y+gxhqeFQXWkxj/FeQiEnaRgz4aREvAyr5q22IziJVWswifZX6x/hH2YzdHKLRmqhKN4UVNJv4VP2aA4YmMXtcNWaqcfSqApWZy4kKO/CSJxhFTX2HhQVPMV8CV4T0gJvOe3uCK1g3e3rWDKTuVFNvQKa3yhYz7wNDDQBmf9X0kF3j/0pdCzkmT0f7JYaiOIsP6s2AykbrfJgA1U6jUR82zX4WB3WzMkQVMBTMX6QZXxfLfyIb0HDywHcWOu+QcecbYAAkebvynPA0FmgE8oZfbvONYmxMFuy4mfAj9W8iLPTPH8Zg5dA6GLKoPcwJgPt6FJMlZi1FPFj216VDdL0cMcNHo5MqRmd1/v6FZt2QnzEcNFEK1Ee0uzrRvSPElBfK6nSkxgqXh9879HXGGN2+PN4CDjUyjDWQKg/1GS11Ko91fM7hbE/yNhJLsWZP/yGvJ0JyAHajYrmAjgYmMVPbQmoCGGkEe0iYPR6TeF4UrcPJRH53Bmt56LRESzJAKT3WH//d7rx90X5a7ZtqoFlQ4ipvuHL98Z/FusY+ADtxB7JofPlsxtpHQRJz15izNSAcqiS3buzoYmCIbut2zTvimRbkTd5Ylb+BqWUoTEjfFh78Wiud+8X8DrBhvCzovU1+N+OdMEZdVPVOsE+dCkfGXsYTBnev94GmYN4yjN+uVeZ6Ta9RKcyRE4VcLLeoNnglKWxmMofJgc5FDYq98e8fceNwKj+fWbw1QdQzrjbXBAw6UMp4cztawjSzK/7cbwNOM2hy/ft/AqmFXc0G4lXewtg78c1qt0NPcrsMeAGGhRN88vROTZbE0XH/EWqHy7K1eP6Scpxf2mvLamWFYCyAzig6soppNrQi7UZ9tjU+T9Mx3PydBxVc7H3vh8w1HES7Rb3DlK82dB49KUjRk/LawifYQ1T3VL+ZcbvtwLRSzJGHSMkl7XOSzsykbO5HGJe41aWJ2A
 1qmccwsK
 nA5qWePAMtIhXHCFpH8Ah7KOQ0G04QNkwIgBFXTRm3GUpfEVqrh3GPZCjifnIGG95afSkSnrZ9gjQFOzEk21lTa1RL51jnGsIWmi4jm+qe+zF9+Zgbn49Thk236uFDJ3xrnlFo5BpEDQh3EN4BOfxDpwSFfMbKmWtZUihgOMVlLxugWU=
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
Changes in v12:
- No changes

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

v11: https://lore.kernel.org/linux-mm/20260625043101.338794-5-zhen.ni@easystack.cn/
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


