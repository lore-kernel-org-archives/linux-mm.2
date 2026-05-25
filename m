Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 596FECD5BCB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17E26B0096; Mon, 25 May 2026 04:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0076B0099; Mon, 25 May 2026 04:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB46D6B0096; Mon, 25 May 2026 04:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B58856B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:17:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7876E1401BD
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:17:17 +0000 (UTC)
X-FDA: 84805237314.24.750CB0E
Received: from mail-m824.xmail.ntesmail.com (mail-m824.xmail.ntesmail.com [156.224.82.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3C19310000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:17:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf05.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779697035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+uRQ3M/SfkXbpMtcvyCPuGV8kK5td3lkgXQJht1i3KQ=;
	b=grB2hooiNtujZK5bFjTk39M9YNoTcTm42i5sGkC7M5teGWDXdeN41izpMQd9krOILpUBDK
	acafeKEIVxuv1iGYGDigFCOfVRdYlsF8dtFrk2CnxBrKVOGogJnQ+9n0To/mCPidLBfLHp
	5tAKXWRIg5dTWX8Oke/98/ALA5jscD8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf05.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779697035; a=rsa-sha256;
	cv=none;
	b=a6rJ2MF8ZmtPG3OxjqJbboGH0Ewg8wwIbI8NM/ECoD0e0DNBi4ZVBty7S/yzKISFOwS9sb
	T9iXI7nBNQM72puq2zHSiBo+dKAe68hZNFn3jbP+37W+PE++4JxWLABKnVk8ZQFOOU58qy
	btnqN4X/GLYmLgHlbYxPrBcbuPxe1r0=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a8ce5e0f;
	Mon, 25 May 2026 16:17:10 +0800 (GMT+08:00)
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
Subject: [PATCH v9 4/4] mm/page_owner: document page_owner filter
Date: Mon, 25 May 2026 16:16:52 +0800
Message-Id: <20260525081652.2210206-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260525081652.2210206-1-zhen.ni@easystack.cn>
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e5e3596f80229kunm9b83604117f150
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDT09DVh1DTUNCQxpDHh1ITFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3C19310000A
X-Rspam-User: 
X-Stat-Signature: sk9a7cw73nf53rk5t8i8tmfugfczadbd
X-HE-Tag: 1779697034-203833
X-HE-Meta: U2FsdGVkX1/7o/qYVKdkilAktLScUmEtyxkWBN8KrLqaaygUiOmT+sakExWs2paqxtnvoCjT4ZKv+c7MKEMesToye6VUG2JqUaigkeF6wbeWQbyEiYyW9gMGTVMSXRA9CLGHyWlwZn+oHiv6F3GXQwrp7k7QeGdJZQurZnRD3tYFEHRiC6EUSr0u4sDjet2EAt4TtgczSc0vDQ5XMEAf6ySAwG7z0R7ZWGSucnivjQQRonGrL+RFfpoOWG5uqAm4DHlQAdvKMgK0nhvSPJcGjvsCcwlaDiU3p3XSXNNLc7/G3h664jYNkjOFW2mKHqlmW2KFHHL4E7GLnEDuoiLcknyUHblJ7b5WLdH2fhf8DcBFtF0cYOW7iR6f8zX09yibeZRUKuChm5RDe3/+ZiII+nak2Jpl4k1CbA1mXQJwIXmmJIE/OukqL2sH4cw6J+xa6A1G7+h4/Jd06KwmVr8A+njeTLQjFiW7rOTxEpAv4nM44XZip8v2OktIbGQELGTy/5PU6Z+jmWP2cSxJEH5TKknVegomZbhjqvhy0Lrn0iBk1vrSnRzt8jztFcPtFupprQk1QVDty3UIuAVbgBHitX1OyqKVeLtP9kKSd7lDp9SOsrdMiKZchNcso139Q62u/u6+ixUWKFDpgdITn67Hsqqwfnvhxg2k8SaZZn9ZS7hmY2WfQOz7zsPwaETX7cwd7hFTuGCBE0JDBXZmONI3aP1WrDdPvUAdO23ubdA/T7nRaiSJbTFBXFtJ4Mu/GhTCGNiak2kpsApAMjjFARpjw54RGVSxDyXt7Gk01bk6bzv8YcO6OHygvWwymarjcyxZPO0dtoOzUaZdEjyNCukeNJs+tZm4Cw6NieyPDrHKmrUosJ+dLwm3E4IEQ4uDF26xq8erT4GqzXwXaZojEDkJaHYL1w17DuR7SMy0qE4TybZtWpoC8nyI09gyZk4Qhr6FTxgLNovekbe2IBlpPem
 Zmpnu65r
 oT9JmERbQtiXS04pzrFDMyixjMVq7emIxVtshjq3LoB2GYAoqiWBalHYFzzttl32vq2h4uDjHHGAbSVWdIV0bQtOrQk1Wzb8Idy4hyNFgdKox1keGXlo4ysD75/FcFFiveMViv5GmKQH7lRACwJlS+bm/WnFHvDQV9Nthaa4QT7iBFeM=
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


