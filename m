Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A32DD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372EB6B000A; Mon,  1 Dec 2025 13:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323686B0092; Mon,  1 Dec 2025 13:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211F56B0093; Mon,  1 Dec 2025 13:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 095C76B000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:39:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3D4B12D3A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:39:04 +0000 (UTC)
X-FDA: 84171764208.21.D2878DF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6C758C000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:39:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Kn5gHxRd;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764614343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jvo3HfTGdOgZmyDWsndn9CedHCVWn6B7/Qgyo4cTBnw=;
	b=tQeL7U/rXCV5hPTabugRpkE1Ly0LTe3g4BRt4B53sFzQTJL3N4svib5wY6rNQr6BecD32W
	eyNCdJHNkFiCpVQZWGPrQ3Q7q5xbqQFMIIXrtORHBxrPRrjGPq9ngL+E/LYoEEPXg9azrd
	KCbTjbHQmZNAy9u9pIhpCqdYPvHb0kU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Kn5gHxRd;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764614343; a=rsa-sha256;
	cv=none;
	b=JfZGOJeOSyW0ElPHPrq3wBLGNR5V3561YOb5dcQ28U27r3YYGpSQ0092lsMbf9Z3aWBFX8
	dD4FcJXC95fbPOdGmJ9qpBmpmxxyzpNNtfrKVcH15NsKvwNIaS90BVeIQHfORwfDtYCy2N
	YXGhnBFzt5Hf9Ejt3uGP3xKrnptALxo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Jvo3HfTGdOgZmyDWsndn9CedHCVWn6B7/Qgyo4cTBnw=; b=Kn5gHxRd9UKdQKCSJQJBuzNm8c
	OJMVgBNG3O3TEKQelzD1dJa5JlvBf8twwHCzXuDaiGz10BEcop6qBaNWvllcCsIo8ADIwUKhwggEU
	Qrf8w8LpQ6d3+pxr1/SoLjrmzAzCKW2JtGEYzAsuZyqK38tIzv8eXnjdsCpBE6ihQ9JgrN2+7hmQv
	KLY71Rfdv5VW5LYMfbDZZvK0q8tzAPL7Y0uRHLxUic6uD3xR9/qYPBRbIgHHxNf7483msyvww48p8
	YW/y877cEf8Ot+Fd822pyAUw8JdezMe4LWYHR0b41ffDOng/+emP9MYIuUAgmR6q8s0v+8TBti06i
	FPjUyTBA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQ8na-00000004Qxz-2pUB;
	Mon, 01 Dec 2025 18:38:58 +0000
Message-ID: <654dc140-3ee6-4c0c-96d6-c1405b048dc1@infradead.org>
Date: Mon, 1 Dec 2025 10:38:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 mm-new 10/16] khugepaged: add per-order mTHP collapse
 failure statistics
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com, hughd@google.com,
 richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
 rppt@kernel.org, jannh@google.com, pfalcato@suse.de
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-11-npache@redhat.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251201174627.23295-11-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C758C000A
X-Rspamd-Server: rspam11
X-Stat-Signature: du1ac14gqy3yutwkaygds14esbat4ows
X-HE-Tag: 1764614342-630430
X-HE-Meta: U2FsdGVkX1/7vja0/KH9jynjjYPARm5gi+ty96pY9FAjlyIsZDWXElVLYLOO7/S1/uMjvqKvHtmDH31g8qmaNA/v6tf5cOPirlO+puBZa3H/hP0rT7b3bmj+AJ9WpU37qLJwtTekSODrDweVFzvHuPvXTSiV0TQmcpSOkkFXop9J3+MmqzPxlrGZEfAmMRAb0gz5xRV6Syv/tu2Zk17E4uGOjFPTT1JXGXxJ7RdL+4fr0Qasm9qgT7muZ7dLXmeELfahR15Ix6LBU9qX2cnSTb6umC8oR/0PW1ACsMw7YvHMl/EHW8lKE349Dfbkf2SuVv5KGdw1bTgGpA0Ue+ER14EGAB6OkjBjT5UpUPn2baYdYEmjVT2tGCmog7tKwj73Zuz8bnEPwl6PEq+rLNuEzhNnJs15+nEzzn3YF6dYmXv/j2/w0MNeFJSvPhZm068CLEwgJQFUHvKWW03SAwFKytY4Daff4x0MYTHUNMyLne26FzUWHZf8yyw/TFq7VLDqw2Z6raCe8U+R50Zx1iPSPV432BjgAjRNTPZw5axIz9X5l0gdFOWGHyw/gvGVddq29jNWLfacJbDgComwZqK7dKa0v5uAY98zY9JnLqXCHL2t5uochV1LLgZ0FtDk6zpD8Lr+4gjcxGC7oQIrNKhb1MYfiGeM3Xp5za5j+RtFzn9J5kujOquRRxA7E5Z7jXAw8Kk4pM8DOXlanXtdcvfdixC9OcvySpvDCixZu6Ac4wUMcM4J5J7YJYCa2R2IqwUliAWnyByhk46FW1Z3gVdd4rJzeZp+QAzn/NnXbb5YXXAs9Am0xmXMSKK6Tcf5GuuQSCqbchLk5rCNQHD8ArvreHzajoyP6nMNZNDHUZxAqR1Cc9cvsz9nSezzjpxNIW3Y58MlDvUpSeE9vAp8wf5cqMcYLTBg2PNbXvBWeMY9GZ3dFams2xlcH2PvfgWrAwn8WIn/JRmoE7RyXcQWyg2
 Q2b3rQFx
 ZY5Q77w93CmrPpxNuNLjJ+pnbrUbk2/sLMf5eXGVCgh4T4rzjHjwtpF9FwVHbpBAy4LWs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/1/25 9:46 AM, Nico Pache wrote:
> Add three new mTHP statistics to track collapse failures for different
> orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
> 
> - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
> 	PTEs
> 
> - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>   	exceeding the none PTE threshold for the given order
> 
> - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
>   	PTEs
> 
> These statistics complement the existing THP_SCAN_EXCEED_* events by
> providing per-order granularity for mTHP collapse attempts. The stats are
> exposed via sysfs under
> `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
> supported hugepage size.
> 
> As we currently dont support collapsing mTHPs that contain a swap or
> shared entry, those statistics keep track of how often we are
> encountering failed mTHP collapses due to these restrictions.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 24 ++++++++++++++++++++++
>  include/linux/huge_mm.h                    |  3 +++
>  mm/huge_memory.c                           |  7 +++++++
>  mm/khugepaged.c                            | 16 ++++++++++++---
>  4 files changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index c51932e6275d..d396d1bfb274 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -714,6 +714,30 @@ nr_anon_partially_mapped
>         an anonymous THP as "partially mapped" and count it here, even though it
>         is not actually partially mapped anymore.
>  
> +collapse_exceed_none_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_none threshold. For mTHP collapse, Currently only max_ptes_none

	                                              currently

> +       values of 0 and (HPAGE_PMD_NR - 1) are supported. Any other value will
> +       emit a warning and no mTHP collapse will be attempted. khugepaged will
> +       try to collapse to the largest enabled (m)THP size, if it fails, it will

	                                                size. If
or
	                                                size; if

> +       try the next lower enabled mTHP size. This counter records the number of
> +       times a collapse attempt was skipped for exceeding the max_ptes_none
> +       threshold, and khugepaged will move on to the next available mTHP size.
> +
> +collapse_exceed_swap_pte
> +       The number of anonymous mTHP pte ranges which were unable to collapse due

	                               PTE

> +       to containing at least one swap PTE. Currently khugepaged does not
> +       support collapsing mTHP regions that contain a swap PTE. This counter can
> +       be used to monitor the number of khugepaged mTHP collapses that failed
> +       due to the presence of a swap PTE.
> +
> +collapse_exceed_shared_pte
> +       The number of anonymous mTHP pte ranges which were unable to collapse due

	                               PTE

> +       to containing at least one shared PTE. Currently khugepaged does not
> +       support collapsing mTHP pte ranges that contain a shared PTE. This

	                          PTE

> +       counter can be used to monitor the number of khugepaged mTHP collapses
> +       that failed due to the presence of a shared PTE.
> +
>  As the system ages, allocating huge pages may be expensive as the
>  system uses memory compaction to copy data around memory to free a
>  huge page for use. There are some counters in ``/proc/vmstat`` to help


-- 
~Randy


