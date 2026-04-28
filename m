Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F25FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0F66B0088; Tue, 28 Apr 2026 10:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698006B008A; Tue, 28 Apr 2026 10:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5966B008C; Tue, 28 Apr 2026 10:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD706B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:15:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D1FDC0727
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:15:51 +0000 (UTC)
X-FDA: 84708163302.09.ABF327E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8CF45C001A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:15:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YddqoRMU;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777385749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSYGlUGuwreg6SeumIlnGSE6doSdzKq26vT+QPauHIY=;
	b=7ILQatiV0/CCxU3+0HEIEW7s64FUHDHukPdHeiCoF3RFrHstINQ72sOVfHpoN7TNJ16Lzk
	tJdqYFuMMRnIDRUenUlSxRlSZfnWoeoDfC+UlGkjkUunILohZwLpu2PSR1Oe/UFzS0qZnB
	0SD2QS7AYhXv0cZ200A2oGnrnyuXdg4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777385749; a=rsa-sha256;
	cv=none;
	b=0Tcy3ZxzfztiMyDamj+RXPqSnWqmRfUQY7GLU3dl93/PEm32BWBmzef0AW5u8rRFHdjn19
	Io0RzLP+OXA11k3FIgZ41f3PdP/7ASsOVl1HwdL4miYPav8JLdOVFyc4/AQfXWJ6hbA9Tg
	3R3FNsBKYOgHrZGXkiuFuzN0J38/34E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YddqoRMU;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AC00A61119;
	Tue, 28 Apr 2026 14:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B41DC2BCAF;
	Tue, 28 Apr 2026 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777385748;
	bh=8D4HdJFxNVh66Lidrvh9gSBNONO6k08XZFtmHASmwPo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YddqoRMUtfia1yZupo2gKcRCph3fb/psTON0XvcJ621OMk/h7sZv/jKCm7LOPSvJV
	 amb241O2uIm61qcMFZm8TP8qx9fX2l+QRsVzhfO8y9dwwKTL3es4ou7dtOkZuyqbyA
	 CCSZEXgcTk/wks86EN1yxkL/1qCQhmcYFP+E1doI=
Date: Tue, 28 Apr 2026 07:15:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
Message-Id: <20260428071547.790d37de2e13716717abf022@linux-foundation.org>
In-Reply-To: <20260428071112.1420380-1-zhen.ni@easystack.cn>
References: <20260428071112.1420380-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CF45C001A
X-Stat-Signature: mtzepfqux1xg9gwfch4moin65zm7yper
X-Rspam-User: 
X-HE-Tag: 1777385749-580660
X-HE-Meta: U2FsdGVkX18MUd6qaZpqb/UtBEg8PIySyrU86owaIJ2zaPpG3CZxVCv6GvSyqKIq3hzuySYg9lsy08a5wjmylFbO2nWFG+0xY5kie9N9imijZwZn9+psY43OGylizybk7d9V99cm0QfhbmS4dBeO1dJJhyfdYmt6MnpEtTyWCePVSn1ur7uVHC5KcF0F7PSa8Qk8eVxwD9rSePUyUYvOM4LL0e7oe2rDkI+glBlASdCBbh522ZQkVK3sJsgI1K1/6kD45A+C471aYBgxUmkvuqRnr0o7HK5MRKAMUJ9eDODUMB9XN4RdKOHIwWd0VD2G6azOrVAK+h4yIqTwSgV9NToRAwHwZruAiSUg4WQJMehxvnlia1gcIwoSUSpjrQo5TEfggLHuFSAqSQHU0DrPiIlhlBlODeUeEY3/kVERGkiwen/0TYeOUmjDjeE9lGnoU8YeAXmSQ4pGVoyxbsumH58LCaKl/iepeBMxSDICwmK21/TEl0eGsrRVYZqObiBUt5UyOLAk8wGQyV6ypXU2k5IRZ7h0Ry9TjBY62D6mflLxWB4MWyBrQc31myGTpoXr9yLzPamNnZensO3kXdepG5pI44zrlsI/WF9w95DihOQMCZePs8XbbS9Bfp+y/r/kUlzzMawK0y+cNuRnGlPMuZsuu5Onwh/huP9lacYIkscpQPBj463Uhm+zhFsA5FquUKCBfBoeB3+bdp1if2AcRrFohtVRa/QAV42xiPaujt1Yt4bhm8DmEJlMcIaf/MDyTYkY3q/PC+E1OZbSXK52E53teGm1pmimSMg1Z94tB4Fr4n6DY1CpnrtlOWQB0i5QOHUDjDeMOlslxIJTTeaSermXnFfDNDZmh+kJ/lCV2Ehem7MqO9f1FLNXxbHYZHURg44qDiZk9NO7VTDebvfZZbXPbp3Cui6g7Wn7QfsfgtJ3CiEIN5Cmp/QjJfPEgMHxJPflUKPG2F4EAKVJKxL
 zoVC4wMw
 w1rTyF0G7SYxNXneHZhSRHTZDTz93Oma94rJtwM6r7sxv2LzOcc198vZo9NGBTrIRHpQNBll55UqeA14le79aiqs1PD4PyRT7V8PC6mM86ThpQsy47+flYplL+zG90Q3CYzKcQMEsTeYC9r21yr7BbgQ6vi+ab9xbWsRVp4NJB6UJFgLL+hLpO6RBFfjUVdHjON/FHWTBRWHJAlFop59GEQULot1JMnsRbPDf7QgQ1QtLRzQZFnMkIVgaJOeqVhkKawgMO487ZkSt9nYY3wN0tgjyIdg6hR+VrErdHc3Zpm5OL4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 15:11:08 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces filtering capabilities to the page_owner
> feature to address storage and performance challenges in production
> environments.

Thanks, I updated mm.git's mm-new branch to this version.

> Changes from v2:
> - Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
>   * nodemask_t is a large structure (128 bytes) that triggers compile-time asserts
>   * Direct assignment is safe for this use case
> - Add comment explaining input length calculation formula
>   * 6 bytes = ",NNNNN" (comma + 5-digit node number)
> - Simplify "-1" check using kstrtoint() instead of dual strcmp()
> - Move nodemask_t mask read outside PFN iteration loop for performance
>   * Avoids 128-byte structure copy on each iteration
> - Add documentation for filter features (patch 4/4)

Here's how v3 altered mm.git:



 Documentation/mm/page_owner.rst |   55 +++++++++++++++++++++++++++++-
 mm/page_owner.c                 |   14 +++++--
 2 files changed, 64 insertions(+), 5 deletions(-)

--- a/Documentation/mm/page_owner.rst~b
+++ a/Documentation/mm/page_owner.rst
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
--- a/mm/page_owner.c~b
+++ a/mm/page_owner.c
@@ -685,6 +685,7 @@ read_page_owner(struct file *file, char
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	nodemask_t mask;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -698,6 +699,8 @@ read_page_owner(struct file *file, char
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
 
+	mask = owner_filter.nid_mask;
+
 	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
 		/*
@@ -707,7 +710,6 @@ read_page_owner(struct file *file, char
 		 * user through copy_to_user() or GFP_KERNEL allocations.
 		 */
 		struct page_owner page_owner_tmp;
-		nodemask_t mask;
 
 		/*
 		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
@@ -732,7 +734,6 @@ read_page_owner(struct file *file, char
 			continue;
 
 		/* NUMA node filter using bitmask */
-		mask = owner_filter.nid_mask;
 		if (!nodes_empty(mask)) {
 			int nid = page_to_nid(page);
 
@@ -1026,8 +1027,13 @@ static ssize_t nid_filter_write(struct f
 	char *kbuf;
 	nodemask_t mask;
 	int ret;
+	int val;
 
-	/* Limit input size to handle worst-case nodelist (all nodes) */
+	/*
+	 * Limit input size to handle worst-case nodelist (all nodes).
+	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
+	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
+	 */
 	if (count > (100 + 6 * MAX_NUMNODES))
 		return -EINVAL;
 
@@ -1042,7 +1048,7 @@ static ssize_t nid_filter_write(struct f
 	kbuf[count] = '\0';
 
 	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
-	if (strcmp(kbuf, "-1\n") == 0 || strcmp(kbuf, "-1") == 0)
+	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
 		nodes_clear(mask);
 	else if (nodelist_parse(kbuf, mask)) {
 		ret = -EINVAL;
_


