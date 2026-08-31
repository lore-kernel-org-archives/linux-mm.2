Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933A4C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996F56B0088; Mon, 31 Aug 2026 04:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945FF6B008C; Mon, 31 Aug 2026 04:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85CCB6B0092; Mon, 31 Aug 2026 04:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 604836B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:16:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD09512027D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:15:59 +0000 (UTC)
X-FDA: 85160856438.20.929FB75
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F9DD14000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:15:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YhcOYYWh;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tt0yHsbfJEZ1+ZZbrMLoRaILCdqS9+900vtSCcW9og4=;
	b=DphqOlBVBkW566+BmqlonYcqKNxEzi5QZ/zEX+ShTucconnV4c1MfUM4iQ8e3OR394PhXV
	197vTBN4eRqnQnAfZo97nehKov8MAGUgKNRGSlHtuTvksfRKVDxXutP7ouafPymaFJQeYF
	s8gMI/ULicUVX7q3KYpj9mXDtPSCuds=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164158;
	b=3Um5wDCyzU4yz/rahOytAR/40RMtqFive4o06s/+CSm4MNddNy5qhCVh+44w2cGI9N8HjA
	I/SufyvrsAQmwEB5xC+WzVtl+XrQsQs+NiM2xffm4Jf+rEESLdAhwlPyBSTmY++eLXUsHA
	8trs/NAqtHvLHE7GOXhG/B+Z2kpdYiU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YhcOYYWh;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788164151; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tt0yHsbfJEZ1+ZZbrMLoRaILCdqS9+900vtSCcW9og4=;
	b=YhcOYYWhhUoS/qMw/h4airDhg5iWAPRj31tZn884Okb/7d9P2ploVnwHmeVK+KCySkQ2wco+ufh3AEkQtFZBeBx3BUtBH/4nd0e7lYRe8JVjpW7A49xTtPlKWfSHGZ50EwFxCHhJ5Cl/nhza5oCcsANCNH09HzIUyJH/QdDixM8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X9v1.h._1788164149;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9v1.h._1788164149 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 16:15:49 +0800
Message-ID: <80b86bdb-9ef7-4eb8-95db-695fdae551d6@linux.alibaba.com>
Date: Mon, 31 Aug 2026 16:15:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Cedric Le Goater <clg@redhat.com>, Saravanan D <saravanand@crusoe.ai>,
 stable@vger.kernel.org
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F9DD14000C
X-Stat-Signature: 8ej75x5xacxypxxk3pmigs3pky3hrb4z
X-Rspam-User: 
X-HE-Tag: 1788164156-822223
X-HE-Meta: U2FsdGVkX1/SclV3KY6y3JJILZphp0fp1UO4zmkVJ8M+NrdLeI9xLybe5bpGydF4BMdI2w/5J5icEJouON9ijFfy7MoLD6pn2BSdbXjO6sogQ/Dadg5J76M0cZ2AuzjmrB2PnFOuURXZTkMZsGlgg594du+IPcmhqANQxPOKj0e/4WA/bDfX9dxDPg4JD4UOVgfsFSafSkCvr9BY2ZKOLl5BQtKKRibCiGXPGKxvM4QvmKhUHO9fCnjoiNVWpPDBF/SBqZ7HMt4DoEdfqIT9DfiXKFVm2r7tLCQVXG1EcxE0Sb7oVdtcMH6xv0DDYG+HG2oXHsOjWM1WzqwlMu51XAtp8+zJQx6XXkbBXTZ7vVD+76NEObih9xVjxw7kM2kTV59LuFZnGFipWQJnh4olYb0UPE7x85Jw2OXHMoznu8oCrQz85BPPZfnnKI2vXw/FGEYPtcYcyWIbAU1MbwrTdIFeTnBymqUUvHiqrABtffCaW3SHHr6pc4eNLI+fnUUPHIJmk1yIklIhmLGyvHpilVXax2Lhp/EEyDNLnKdPsya7vjKbvUrqKXh4zTbD4XLuTkXHiG4bePj32Mu3fx/VCvMCHNZ5S1Ed7xGRPIYM7sQMVbumL+pQSvXI6BDoaxSCMzbA2R75QeCfGTFypsEmC8Ym/Ni15bJZxsWFgc14fMkMyclGOyVxDEmXczcKRiHEjA+Zzqgipc7hZoXf5OmAuBuN26hf0zVi6EB8S6UoAxbBuguqSAdy1nHezfRgNcZJAwSecWsyO3Dalot0UoZFHyFkh8niqMlzC6c7bgyEab/I4JND+zQan/JKpQINzTCKoy5B1lJ4H185+/y3k1qn4tLIXJuK8SPaWILDwXLULszZB/eb+gOSmNAVDqV4sKi5mLBgWfr+pmpoHk6Ol4WKCxFlProq6UNnJ5Qw3etwEyY2ZSCOSO5gK6elHZmDRGw28CPejjH+huuXuM43mlS
 F+Z+yB0P
 Rz2hRAFrvhe63ibMkvy5+vbNAcjPNhFJTqRMsGR2EFmRAbzjSYfhEQ2NGIgq95qcMnh3HHRHjW5CiKNTS9gJHpsRb1zDBEA07ciRVjkaNCM9oCk32KZaEBcgvwJjRuxSK9Lw1h2/KMX1x1imbHgnQzCTHFZ9idDzYPtGNHJ+TaMMyZh8JJbOCQZV2C0Kv0iFzCbMzMwby7LgTqcNpyMNFQXnGvz3uMFt6LFDL9SgA4fRoyWiaRvs1soqL5+pkV9YN7eL81Lj4/kw+NLKAVyLwZkjV6U5UMaVuBOTbTgqltvSCeyXZAEwj5vxyVJeMGsUBqe7slb2DX3F8gbOjMXar2INKNe5nIYiMp9BJTrgHgY03gFZ57o/RXZfp3x1YF8nrBDyejvQiRV6zJ4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/28/26 3:55 AM, Lorenzo Stoakes (ARM) wrote:
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

LGTM. Logic looks clearer now. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

