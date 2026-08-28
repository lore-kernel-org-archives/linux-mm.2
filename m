Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E68CC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 04:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF756B008A; Fri, 28 Aug 2026 00:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360526B008C; Fri, 28 Aug 2026 00:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2514C6B0092; Fri, 28 Aug 2026 00:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00DE56B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:47:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C4778035D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:47:40 +0000 (UTC)
X-FDA: 85149445080.14.1206B11
Received: from mta1.migadu.com (out-138.mta1.migadu.com [95.215.58.138])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4ECA1C0009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:47:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O8l0sqUH;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.138 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787892458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdBm7IQBEwS27BRoxu0g4gl3bScFpQDUGuu8sSuxScc=;
	b=2hKjZiYQCxyyT5aDuBvSdSN1H88CKKxUGCtLWGV9teBYp3N811ufhyXuhOhGuQOw31byW6
	ARkWpP4tHIuskBHdtcDXrr95ryPeRn7bNir4aGYAbdJCJA9TVi51kocYGAobhkh4n3vLlb
	u66avpBsfrVxB5W60U4x/cDGD8KOzUM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O8l0sqUH;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.138 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787892458;
	b=xhU/+r7gOQXo3VYRorwhmL5gtl2I1SmWCTRSWcMWGeR9ZbNASuID9X2MQsl1ljgPHNlBlR
	siNF78HQRLm6jjNx/6yGUdNcdXolJzcHOEnsvfgre00a22rVoHOrIBu7EMJdYh01gLQQ91
	CBfeFgeh5bd3ZliCIPrB3cax0y8NWOM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mOPeMmcWI99dgCmtPzUV5tpD1eXN6gK8SASB4LmC0O0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787892457; v=1; x=1788497257;
 b=O8l0sqUHasUayzeZQ0pzSC+4EFkh8Ye9ji62pFuD9I3Ln+EdcoB8xVYXMFmTjUj5mGTng465
 zYp99+ybkZBJVL+no9nZ6qIJnOpqrqX4FpTTkUOLOiSJ1WaiJVwpUQ+5R8lxDFT+V77vzmZ6wnE
 K2xfAxf1CRD23rxUW7SOlUN0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 026258ee24c5dde1;
	Fri, 28 Aug 2026 04:47:26 +0000
X-Mizu-Trace-ID: 026258ee24c5dde1
X-Migadu-Flow: FLOW_OUT
Message-ID: <de3eed17-cb80-4cad-8437-4ad78b5896c7@linux.dev>
Date: Fri, 28 Aug 2026 12:47:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, Nico Pache <nico.pache@linux.dev>,
 David Hildenbrand <david@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Usama Arif <usama.arif@linux.dev>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, "Liam R. Howlett" <liam@infradead.org>,
 Cedric Le Goater <clg@redhat.com>, Saravanan D <saravanand@crusoe.ai>,
 stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bm1b5gz43ifa1wrf1r8sbegp3ai58q57
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4ECA1C0009
X-Rspam-User: 
X-HE-Tag: 1787892458-772266
X-HE-Meta: U2FsdGVkX1+q0VXP4JqAQ2lqeq0UWZlMs/LVV49XPG4sZs29ox5HkTAI2vZVROeK39ncl+CLI2EbBftjemmooohzZ8S3gbMrh+QUKSOlfEjGMYaZ00xLDVxWVOF6FdFErJJWEheIMXUDBaU50A8/FWiQSf/zUIotOlqGw+UFOC9b7VNnvqQhNTiTIyxrOIYrYEXHXhp1IrdK1hYTCve2O9tw0mz3UcFTa6gkk/AiF+Qz8qsZHv0wketNhenIaPjUEOPp7lgta0wOvAhQVyAPNura1oTJa9nsDbPQcuxbVTTj5Yr++9GIPTQmLQ9PrNAKtBWSqUdNkFsIlJZdzCE5mD9BIhKAfVwJeh4YS2RvYBflum4kU/1QDNtwKigc2PbCEg5UkUnZNVdBjg2jTXx4CpN1BzY5T6ZrfDp0QSBATOZSzw3hwNSxd6VF6qkB8RxbKE/S8DOWBRvcR5YdRDfNKiOd6gAmSeAS9sIIkgzSJT/iNTE0CcoSfVaeFnVnQHsfoPYjZV6KnllNkLSMwJLDEEwq1tGmkZRjKH737bur8WZlxNKA9+I1rjvA63g2wO6/9vGP4uWEsT1Xfq57t9cHh+hiHLgmfad8zTQ0TyFf2H0j5PJyPTdvAxmQWZ9hIvbpgGlfe9tYiNZv0e70096Gos9OQQ1ezhVm52Bhvu/3gMqB2/qC6jqr5L1JVd0EwKytPet/ghZwdcdw2V14eC0DCR78fKWMqMeSs5AzU88UOh3a2bcc+CGnUBV2OpZxW52hzCXndkRvm7TrNNJgf2khcQDZo1nr5wCNTxrnW7e1hWq0PrCEgG6H4n8Rmu6UIShl8gjuLMuMywZ/sUjqO/FhU7zksocTwuilzDBEQeOR3KZWiw9OJDmZIsZpac2oeHODPs4t46JEna+4GE21Q1MJxsij1/Sco2ND2CWtT43xaQLiGr+XRC+vsKeF7WJlGnz1zm+PdcYlVUlcGiowFhO
 QwTUzqZD
 kej5L+PVO944GjTzCMut7EKd50etnPIcAPPnDljQtfm8IH7pcIXfDjhYOL+jylz2HSteCEX5d9nAq1hCWPLY4p6IeMbgGXSyADgyAP+zxiwGOmwLnlkdA3GFTymQkoCtYz1gi05nN8yfoifAcidK/Cdium+0WbPvfMHa+rRMRCLkiILblQk0LSPn144unYCnmU7I6Knbg7+BtIH/oHF+574bvSJmq+xUi+8cJa9sGbXWbedF8pDVf5bzK6uDRdNJrednwSZStRJ/FmAuc4KHlhBc8c3a6WdYvoFWAjiQ/T0wfuHJdqXQxGqRytlIJfOhPRoLPCRjzvYobzel6tj1vSFL+so0P9VgnNenJ4VxGmWUWSWC9ERASdxXG9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/28 03:55, Lorenzo Stoakes (ARM) wrote:
> The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
> confusingly only control the behaviour of THP in some instances.
> 
> They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.
> 
> Long-term, THP is predicated upon compaction being able to obtain large
> folios to populate THP ranges.
> 
> However, vm_normal_folio() returns NULL for PFN map mappings, thus their
> reference count is maintained by the driver, not core mm.
> 
> As a consequence, the folios are not subject to reclaim nor compaction, so
> are not truly part of the THP mechanism at all.
> 
> However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> introduced the ability to establish huge PFN maps, they have been subject
> to THP tuneables.
> 
> This is incorrect - if a huge PFN map is available (defined by
> vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
> should be mapped huge upon fault-in.
> 
> Correct this by explicitly checking for this while ensuring that smaps
> continues to accurately report THPeligible statistics.
> 
> While here, abstract the entire file-backed THP check in
> vma_can_map_huge_file(), with sensible separation of logic into helper
> functions.
> 
> Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
> maps of shmem folios, however they are marked unevictable in
> drm_gem_get_pages(), and in any case would fail the reference check in
> __remove_mapping() even if they weren't.
> 
> Failing to map huge PFN maps has resulted in significant real-world
> performance degradation, see links for details.
> 
> Reported-by: Cedric Le Goater <clg@redhat.com>
> Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
> Reported-by: Saravanan D <saravanand@crusoe.ai>
> Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
> Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Cool!

Tested-by: Lance Yang <lance.yang@linux.dev>

