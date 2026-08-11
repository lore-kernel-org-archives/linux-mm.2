Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5FDC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24F0B6B007B; Tue, 11 Aug 2026 03:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7A56B008A; Tue, 11 Aug 2026 03:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7166B0092; Tue, 11 Aug 2026 03:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFCF26B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:08:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 762F9A03A6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:08:21 +0000 (UTC)
X-FDA: 85088110002.10.E5C3184
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9427F40003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:08:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGwyF+7g;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786432099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4jTbw0Wv+xPvXVSegCeaGGpLthSdk7LTeihL94Ey1U=;
	b=K8eotwgnSFVMT0bYmy5AD66lU/VsQhLLWi7WeUfeNVRRPED1saI/rbuW1MIoLCOvCCeyaZ
	62U1jpNYTV8p9d+9ETByTowaksuWYM7RXbhYs6pcy+YT5p6IMz+j1Kq9SzYDJBi8zlRaAx
	onsQkyraaIARjZtvQHucssviOFi1VFE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGwyF+7g;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786432099;
	b=NOUuwnRRXJbMlUIqMXCQsvOmbGUMtIGJ1PcWzRDYAhUa3mERXMFQH0nUrz3f3EFPxchAlG
	fLER3OyXlk1riVgzqeEb6VlrV7ddvQLplY11VMU0PXle67lSmI2fK94LcYMbVSK0UzPk9D
	sUNy6lHBAHkV56zR1eDiXO0URb3Z+cs=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786432097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H4jTbw0Wv+xPvXVSegCeaGGpLthSdk7LTeihL94Ey1U=;
	b=gGwyF+7gspN8TLlI7dUBS3GUsQYtjH0gz1vLncu6CTXLZFQi2QtIZTb1yr0d5jYuebYTZu
	CBroq19U1h12HEWxIXiIG57UUX2wCWEvTcPJJnTJEHYdQ80W/VHigwQcqVIQTdqVtz5Eh6
	VVtNMayzoaIuHHfpS7IZUTotbKZ9ABs=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v7] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260811052909.475635-1-souravpanda@google.com>
Date: Tue, 11 Aug 2026 15:07:56 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 usama.arif@linux.dev,
 shakeel.butt@linux.dev,
 wangkefeng.wang@huawei.com,
 anshuman.khandual@arm.com,
 david@kernel.org,
 surenb@google.com,
 fvdl@google.com,
 gthelen@google.com,
 hannes@cmpxchg.org,
 riel@surriel.com,
 sj@kernel.org,
 vbabka@suse.cz,
 mhocko@suse.com,
 bjackman@google.com,
 zi.yan@sent.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B16D9053-4BE0-4C7E-9D41-6BDD2096CB75@linux.dev>
References: <20260811052909.475635-1-souravpanda@google.com>
To: Sourav Panda <souravpanda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9427F40003
X-Stat-Signature: hsi43hfbay86cy39tznbbtkfhqjujkuf
X-HE-Tag: 1786432099-378782
X-HE-Meta: U2FsdGVkX1/u8sYkhjXlJsXgm2AppCfB4mqyllVcajgI1MaZd4cpQ6CJqmdhUWimkJj+S8rcYB/Brm4EVyGDtqxcnBzTKKDXWQ+di8V3cyRAmV/asTR2/K2VKwk6IQMMe2yg9TFvdOHP/KDwg9ypwtNZzm5QHhuWVolY+vNClJCmd7UX+rI+1IKBgnvB0JXls2996nA5XG2+caibwBDf6Kg6djaZNCAN7721aiNDsbBf07GHiHa+LWK+D9Rl42wpDDuUqMwJBC3RvkF+OX0+PnitzW9nyzNmaHaNsqXSJqunlLHwCZTuI300WNJC1KlV5RBhdnq6TCtNsmGoo1VmWpdZtTODmsAKXLTgR2P248zOqCcCvpGe+xyhtcK/7VcjbYOor0/ACYHEP0FJudpRR/NeWVRVwR5HPWZm1d25YMZT2po3SP9YgR/taD4npLmBPzhh5KucrRBwK/U69zIknrmM/zxrfts1sweprxQJoPTNOKv+sbYi+GpJ0MLBPCxK2CTox2dhKLEmPku0FFExG6+MXZKBKta+j8YhqxiBzKIKLL9X3uyzg6knMrnMcKJIc4id6t1O0HW51pfyOzJzgL4PIl3v/HLrDxPsvYSKizA67MK+dtr/I3rltSpmQXABfsqMMdmdu7CkbJn2+ArhjRVu0YCGXbl1L7v2D10yqJrzniec+H9MbQkgNMpv6l0K/nfW0w9f453ouSsF+e8V36l2SeHaYpcbbLBplWs8rDcWCk1wVD5JrJxarb5b5xcOwejRDfFHi4losP3d4CcLUgIa9JiJ9zIPLTFEUEwEBhFmDO+SGqU6NTMcqochHwK8Fkq+2AVeMUMUK1UBGyD4NDXZZjA7J6ju3psdSSv6pTrd/1BzCsgMtadLHSHa3ueUN0dp4DlsLxB3z5DBqOKJA8sBDUxYQ2EMMeMNpstTNlH5ORznL5f0/1Prl/ILFhhpw6VM/bTh5xU5O4jyFkO
 9ZU4aMCQ
 /qhjQoij8XbC6cMXWiAZlURbejt9MNl5PGCtzC3QtFi32ftKnLXZhJ32XdF4Rc0Dq/8VajTI7FXB7pTfPe5AJPhhq37fjOGpGQvYmc4UPqlLjhg5IWCQTq7EXOICH9DNc6vYRwTpjj8btxa1LfINHdH/99IZRy3WzPUSr+CIlKP+w2J0kS9+WmjLWWUSO1l6Kr6bJ6+0DHurR2fqg4dxcsI3dJTo3EJ/5lgtqvBYB9y5Cv+IOO7oikrcK2WVUiW7furbZ6zrV4BjUG2zTPbxY4eRHhx+vadlF0ddaRHeU7A0bp7e+K3eonpS1GRgrKwKg/Zco9CTSr3j3C1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 11, 2026, at 13:29, Sourav Panda <souravpanda@google.com> wrote:
> 
> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> alloc_gigantic_frozen_folio().
> 
> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
> allocation on hugetlb_cma[nid] without verifying if nid is included in
> the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensures
> the initial preferred node allocation honors the memory policy / nodemask.
> 
> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> leading to a null pointer dereference kernel panic when nodemask is NULL.
> 
> Fix this by checking if nodemask is NULL in
> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> cpuset_current_mems_allowed. Enclose the allocation attempts within
> the cpuset seqcount retry loop so that if the cpuset changes concurrently
> during allocation, the attempts are retried using the updated nodemask.
> This ensures that the initial node check and fallback loop safely honor
> the task's cpuset without violating cpuset constraints or causing NULL
> pointer dereferences or unexpected allocation failures.
> 
> From a userspace perspective, this bug allows an unprivileged user to
> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> configured on a subset of NUMA nodes.
> 
> This can be reproduced by booting a VM with two NUMA nodes, restricting
> CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
> hugepagesz=1G hugepages=0), and running a program that allocates a
> 1GB hugepage area without reserving, restricts allocation to Node 0
> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> 
>  void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
>                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
>                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
>  unsigned long nodemask = 1; /* Node 0 */
>  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
>        sizeof(nodemask) * 8, 0);
>  memset(ptr, 0, 1UL << 30); /* Trigger fault */
> 
> This results in a NULL pointer dereference:
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  Oops: Oops: 0000 [#1] SMP NOPTI
>  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
>  Call Trace:
>   <TASK>
>   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
>   alloc_surplus_hugetlb_folio+0x6d/0x100
>   alloc_hugetlb_folio+0x3c5/0x660
>   hugetlb_no_page+0x3d9/0x650
> 
> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sourav Panda <souravpanda@google.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


