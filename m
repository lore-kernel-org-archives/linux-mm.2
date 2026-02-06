Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0105EE20B2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBA26B0092; Fri,  6 Feb 2026 10:57:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3096B0093; Fri,  6 Feb 2026 10:57:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D97A6B0096; Fri,  6 Feb 2026 10:57:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F39616B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:57:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 993641A01AF
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:57:13 +0000 (UTC)
X-FDA: 84414485946.14.7B75409
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C9AC840016
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:57:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="DdJZ/IUa";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770393432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxrkHB2DTg5yVwRrNhrmiksyuwYLeN8ID6+h1ZMEhpo=;
	b=2Zq1Yl8SjIp6+rBULsGFw3B8AYJ9WTs1NE1pafq9wnyJFnFjTC6rMDRhqdrhG4BK3sxEBU
	A6K1o3dDMST2LgCCHHxmqbgD2Tft1yfWbQg99o4EyoW5LX0Y5Zat2S08jj+qHjvoksNdQJ
	0ZklDRHvEGJX9nI8r1kuqpKMa9cMffI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="DdJZ/IUa";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770393432; a=rsa-sha256;
	cv=none;
	b=Qxd+ChFNf5gtGizT5ub5h6O7Ay+Fd9KLgeMLYrNzpSb59251aQMaNVP0EUyc7HyOgPyYH7
	nTKiqy+TBCH8he2jnClRdvWhlei4TQsirA0E3ROumyi6h6rDnRTwP0boxn99WTVi5JyDqU
	m5WpjNymdxsjjNT5vgL0q5Yz/tDlWk4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B20FE43C28;
	Fri,  6 Feb 2026 15:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B93C116C6;
	Fri,  6 Feb 2026 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770393430;
	bh=5yR2oXGuhV43ittUT6jpCwyyLEiU3bwv/gLoZQxn+1o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DdJZ/IUaKRT5oCG+okPUCt+1gPuCN14/rOSTrRAZpFXZIvK5xnRhrII4KhApFNFSH
	 31wpjF9PH6QjTFVP3fSzoe60mk+qo/1fDwTayK7yuee3INfoZYlVoBJhXVcaB9i/1O
	 vbqyvtVEM4DnkPV7cSYnY1oogKmh6bCT+gyN4WZU=
Date: Fri, 6 Feb 2026 07:57:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Gregory Price <gourry@gourry.net>, Cui Chao
 <cuichao1753@phytium.com.cn>, <dan.j.williams@intel.com>, Mike Rapoport
 <rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
 <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <qemu-devel@nongnu.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-Id: <20260206075709.0f4b60dd5dd664894cbd15c7@linux-foundation.org>
In-Reply-To: <20260206150941.000028ae@huawei.com>
References: <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
	<9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
	<20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
	<696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
	<2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
	<aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
	<a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
	<20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
	<aYUjf0OrD8f_bJCy@gourry-fedora-PF4VCD3F>
	<20260206110305.00001fbb@huawei.com>
	<aYXtHa4Y2y_5xgcS@gourry-fedora-PF4VCD3F>
	<20260206150941.000028ae@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: in8j1qx47a37e14rhpa8qsgqmf8nixj9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9AC840016
X-HE-Tag: 1770393431-140655
X-HE-Meta: U2FsdGVkX1/GiTbYiGXs2FKbdu/ncH/5ReTIyPkL+fD4xryh123cAX3U/NJivgBqZfgXAvHqVmKBHOX086QQYXhlQtsEs9oGfPlyloSUbzA6bMQhOJ7zIwgrplD74rd0aBYxApWqFnkyr7g9c51ovhrGRoErpuM7gY+JlR2M8ridHUZNTj1ghD7bKtZYRuSGsxk+YTzB2vk23DIUrBqUVCso2GWcciD8r8byUDYR+1+xO5qyjSb+dr/4UZhh6bepsWlBqED6jrX8EKxgAi++hhx42Xpr7Yg8rjPtK/hV792qo5jq2AeDPRknTERZW9YwlpDQFFx/UYvCIPYY9ASydcF6QTqJ79PRuXT80QFmIHH0N/In2JTkLIsGKY6dix+eiSSDF9kTX36kuZFc4uRYJdFePL/eMqf+eKHIzU/NZqYgWsia0OXCsgC4zyMZr8iyNKAHn4fBA9EBtFOlzMVa5SQhFWye2Wgo9EWS4riqAONq3G47es8GnW01vxJeYmkFt6LCe8wH44RPkF66B26t1HDolkT0v5qcasvJHMln8X4xnh3KJweUAlG0hMP7p/PMIX0Y+oUopT9GfGQ18fw7FCX+5NyF37QDVgN/pd0WT1G9hhbD4kI1VE8jsz0v0UPNMn8uFHErkK2pM4YRPetOpSFB96nmOUoNxZnzPT7AwkTUwfI6Xwu2f5AzPR0NBV+1kTu7/+PfbGMgpxPH9l3KATY/YZa86BF6Okm31Nlwi8br0PW7XNZqFJlGnO57KkLdTRMrJxriy4nnKV25/ZsAX+feCjP646cc7UoACnHLrEGzMCfFiVxRYD64W3VTmjf98mu12Fl0pTF5+beGl1+Em/iFvPIximQHbO9SU5FlsIo56eqzGcTHeY8f/LN6S/jZZsgezWiKMthzT2xB0OTWQE243wPPoQEC/UfiSXQB6gp2PT2TbRd7jcmOxEYzSsSewlMORP4Ck5NApZKguso
 z+3et5Ma
 ozDEG11LaW9PyXT2uaVkVYGpBPNHFit93HS1kDfCTAj7bp84Qu6ERrH9Rcp26FzRc5euROOn1FL5d8ryzvt9ys04u/XDMdjMM6LZJWcFIQxITYUnbqO5RjlDtrTfJRE1XXC4u77tQD6A1pRKvihYFWxkmajABpdHfd7xvQ1S5DuvNcZJAX3UKSTtHGyHcCMt8Cwo8QsyB3WuXr2W/wPPy6lcG+DUBEHWCUx4U5Iz4sRiNEvUgsFPSCrKRVezmFGAxLJMmMm+mqJ89pB+ix5+VBPLASQl33CUqURTvF4oUeL1JaxulNWANqWWa6C4PdTzBu3czm50qAfhaDqm1iwb5gjyw5uS3N+GuKQMDMW5NpwRFLjZ+abCgFoMqsOY3JAm5OK+DlcZ+2xQJpHdcP1J4lzdOTENOrfBokRpganNZjwwi7hacUsIKi3C1Fdqf8EhmmlCbyZMu/zhJHCcE/yK3Pvf3AlzlVhqQt5YLt64w1BCljjFysdUWpkt6woIWvBPK2qHOPrNvu2p9TEWXo9I5z4REJaIr+Bu1x2pIE3sTnr/OfTM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Feb 2026 15:09:41 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:

> > Andrew if Jonathan is good with it then with changelog updates this can
> > go in, otherwise I don't think this warrants a backport or anything.
> 
> Wait and see if anyone hits it on a real machine (or even non creative QEMU
> setup!)  So for now no need to backport.

Thanks, all.

Below is the current state of this patch.  Is the changelog suitable?


From: Cui Chao <cuichao1753@phytium.com.cn>
Subject: mm: numa_memblks: identify the accurate NUMA ID of CFMW
Date: Tue, 6 Jan 2026 11:10:42 +0800

In some physical memory layout designs, the address space of CFMW (CXL
Fixed Memory Window) resides between multiple segments of system memory
belonging to the same NUMA node.  In numa_cleanup_meminfo, these multiple
segments of system memory are merged into a larger numa_memblk.  When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory.

When a CXL RAM region is created in userspace, the memory capacity of
the newly created region is not added to the CFMW-dedicated NUMA node. 
Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
containing RAM).  This makes it impossible to clearly distinguish
between the two types of memory, which may affect memory-tiering
applications.

Example memory layout:

Physical address space:
    0x00000000 - 0x1FFFFFFF  System RAM (node0)
    0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
    0x40000000 - 0x5FFFFFFF  System RAM (node0)
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

After numa_cleanup_meminfo, the two node0 segments are merged into one:
    0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.

To address this scenario, accurately identifying the correct NUMA node
can be achieved by checking whether the region belongs to both
numa_meminfo and numa_reserved_meminfo.


1. Issue Impact and Backport Recommendation:

This patch fixes an issue on hardware platforms (not QEMU emulation)
where, during the dynamic creation of a CXL RAM region, the memory
capacity is not assigned to the correct CFMW-dedicated NUMA node.  This
issue leads to:

    Failure of the memory tiering mechanism: The system is designed to
    treat System RAM as fast memory and CXL memory as slow memory. For
    performance optimization, hot pages may be migrated to fast memory
    while cold pages are migrated to slow memory. The system uses NUMA
    IDs as an index to identify different tiers of memory. If the NUMA
    ID for CXL memory is calculated incorrectly and its capacity is
    aggregated into the NUMA node containing System RAM (i.e., the node
    for fast memory), the CXL memory cannot be correctly identified. It
    may be misjudged as fast memory, thereby affecting performance
    optimization strategies.

    Inability to distinguish between System RAM and CXL memory even for
    simple manual binding: Tools like |numactl|and other NUMA policy
    utilities cannot differentiate between System RAM and CXL memory,
    making it impossible to perform reasonable memory binding.

    Inaccurate system reporting: Tools like |numactl -H|would display
    memory capacities that do not match the actual physical hardware
    layout, impacting operations and monitoring.

This issue affects all users utilizing the CXL RAM functionality who
rely on memory tiering or NUMA-aware scheduling.  Such configurations
are becoming increasingly common in data centers, cloud computing, and
high-performance computing scenarios.

Therefore, I recommend backporting this patch to all stable kernel 
series that support dynamic CXL region creation.

2. Why a Kernel Update is Recommended Over a Firmware Update:

In the scenario of dynamic CXL region creation, the association between
the memory's HPA range and its corresponding NUMA node is established
when the kernel driver performs the commit operation.  This is a
runtime, OS-managed operation where the platform firmware cannot
intervene to provide a fix.

Considering factors like hardware platform architecture, memory
resources, and others, such a physical address layout can indeed occur.
This patch does not introduce risk; it simply correctly handles the
NUMA node assignment for CXL RAM regions within such a physical address
layout.

Thus, I believe a kernel fix is necessary.

Link: https://lkml.kernel.org/r/20260106031042.1606729-2-cuichao1753@phytium.com.cn
Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa_memblks.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/numa_memblks.c~mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw
+++ a/mm/numa_memblks.c
@@ -570,15 +570,16 @@ static int meminfo_to_nid(struct numa_me
 int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
+	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
 
 	/*
 	 * Prefer online nodes, but if reserved memory might be
 	 * hot-added continue the search with reserved ranges.
 	 */
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
 		return nid;
 
-	return meminfo_to_nid(&numa_reserved_meminfo, start);
+	return reserved_nid;
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 
_


