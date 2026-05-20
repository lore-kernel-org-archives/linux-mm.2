Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05B5CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C5E6B0092; Wed, 20 May 2026 03:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3EFA6B0095; Wed, 20 May 2026 03:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B966B0096; Wed, 20 May 2026 03:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED306B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:57:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B8A11A01AC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:57:08 +0000 (UTC)
X-FDA: 84787042536.01.FE71C6A
Received: from mail-m128248.netease.com (mail-m128248.netease.com [103.209.128.248])
	by imf02.hostedemail.com (Postfix) with ESMTP id 06A8D80008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:57:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf02.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.248 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779263826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmHK7u7m4NXrm6hitn8UkS9iT7CiPn5eUd0OytDRU+8=;
	b=1SivOgpNfNrk7EC/PjRmtwIYrGi96T9hCBShSoaFtSO5drKT7B4atDtGBvBeuhE73vFjYo
	KB3PTgAEVRumVv0Gwg4HXqjFmWPXhyt+Lg8TmJtAuR6+FlJxBa11sWXgv7ajVPuZT/Sd27
	DhiQ4yolSas3fgYfM4KAx9oM1d5F2nk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf02.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.248 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779263826; a=rsa-sha256;
	cv=none;
	b=Uq2QFrRtwPomb4i7JcUCAyM1NISiB1IKhJnVUOqIiY2eN2XgVJskEBffMZeUT4MYrA0VLi
	if4JQKKLVMMDoe6XFefYrEyKCtY5+sxdjFOUozX3PJL8qsITD0FYvENN8KLq3+670Jm2ui
	YiIi/3jMf1gVf+S48XOtRyFugj1TddU=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a5d18cbf;
	Wed, 20 May 2026 15:57:02 +0800 (GMT+08:00)
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
Subject: [PATCH v8 4/4] mm/page_owner: document page_owner filter
Date: Wed, 20 May 2026 15:56:41 +0800
Message-Id: <20260520075641.1931080-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260520075641.1931080-1-zhen.ni@easystack.cn>
References: <20260520075641.1931080-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e446359f50229kunm5cf26198439a0
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHkofVklOSkkZGE9DH01PGVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06A8D80008
X-Stat-Signature: nkmf78iefre7hbd5zwyeby9dsxyc5mqc
X-HE-Tag: 1779263825-274286
X-HE-Meta: U2FsdGVkX19TviozbAGkxZu9Rtd7dKGNrzIxh9gX1k1kzHXX23hLjoJv1rKPJrSukLkPDzSefVhEXaIaHn7GTBd53nT9ePcNvrg3BEU4OAMcmtsOjRcZ7E7+0iJLC0OhhPXQ6Z/ro3KBw33E38sVBryVCRYJzhNT/O1NQqeUrx2gu3KDqvQ+0BKEBvy0Cn53M2LkW/4li+y9eby8xTXo5lD9a3YVWfSfC+B/yH4bbBmA2ljaCVtswIf1mrTE8uhi9pZvLd4eL4h/pJcEqSIsMxCjbLjz/C6V+BC9XBDRyz5XVsZYw0IzsNr/aDnwFc3Nv11oaEF7V4k/Q+3NYf6RYQIrLbr5XozjX93FLBajAbTXRJWbe/GMCzmodL6yLMZ/48jO6Xr3a+i9Qk5jIEzQIrTsLaEbOBH/J5jzSDjNQ9lyS5xUQT4MXm1rN3V1BlBRyvxGAY3VxZ/3LIIPk/+t5/kjK+2iuIIbWnNp19kSfCYZmT/idduQS3qqT4Lb+gee++liBtduHNdQhXdFyFdoVg7VTrKRfp3mSuG3z1zX61JsDE1JZp9FoKKizWwKCez27ITxxsR9AGNXFlqsC5OoFYN+Fv9A+IKbdANMtZFDjTosHn9x2oBPN4zNWHCmajsnYz3u0dqWP3jWeNaUljxSWsKkkYrvJah4homFqzSxtC/oNUnDCZBfQK10ZAAtZdudujcYkvDogfAWCzX79CA7xkSFUaa1qGocQjmgIxW0rKzAE7Q+SCUL1yR8+AzXfPWHcUaBODg9FSIpbU/ZETQR32LZjgbS8IaqKexGHTnCK3Eh+/qMsf0YGi8dUFB7xwNSdD762ZxpW989y1ORT9D99PwmsbTz/WUp0SALOSuL9ujJzhpwUwX/cCwTvK2sUT7A0Kgq7jgubZeyKJcEFZdH17JdD9PRg6FnSc86I/vJuaP5NuSb2oC2+U9lHxNbdqFnWfRuZOsEQ42FojV3Y5/
 PXBtj/68
 8sPOJ+kcs/ql3QhC4VKXGb+Rd92Co6bPK/MDmJVSxVjHsyPtZtk1CABMDGNldO/xlOLmnsPVukHZ3H39FoPSfl36WaoFvjK7MTymiTdjfe572Cmhgo/XKAb9Nbz4S82SqCfSRVGSf41ayBjHPEwVO5sRePlfSei10Mtz9jiPjJQbNe+s=
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


