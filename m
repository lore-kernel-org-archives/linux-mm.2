Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357C4C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9666B0095; Thu, 10 Sep 2026 11:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290606B0096; Thu, 10 Sep 2026 11:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7076B0098; Thu, 10 Sep 2026 11:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E622A6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:15:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 557951A02A3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:15:21 +0000 (UTC)
X-FDA: 85198201242.12.7C32DED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97F8AA000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:15:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ChFiY7I3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789053319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEjaO8gOjD9f0+2IPCgP2BKjHuk9oDJMBENGv6o5iiw=;
	b=32jaRbxgsnncEYAvxpgfmC8IdXqp0zAK5+g/kILncEtv7AovMz/xE7vo7EGNmSkUrOT+bA
	2pNK4h1dw9FyWswR4dbOMbJ4c4HKuTFOImo+PmRwOS5Fhc33HSzLsvFOwuKEuYNQkwu4MA
	4DpZilKLTqAgXZo/Z5N7DlSXklN8oBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789053319;
	b=v2HjoOaIShixMfQ3DxnclFBFvdHB+LB/c7WxUoWkIDXLgW8UKm4hUmA3qzzo8Hzd9amONc
	1XzFg6r97VXQYdeHo73Gv7gtpS6eib4Oh2SUSXoz2sgOjMqthzAFjNSYzyPGtewZohu8Cs
	oIfa5/+Q4PrygTRfJ7eBFDRPyGQ1UVg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ChFiY7I3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D3676020A;
	Thu, 10 Sep 2026 15:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86291F000FF;
	Thu, 10 Sep 2026 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789053318;
	bh=sEjaO8gOjD9f0+2IPCgP2BKjHuk9oDJMBENGv6o5iiw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ChFiY7I337QtzPmO3e7pcxLcEiMW3c1lGj7lAr0LVceobI2YDbaaxxmH1dC6zorIl
	 2CRvuMT7kg+rqXci4EFF4yJVGlkA9vNas9C0TInFKFDfqxKNb1rFMxCNo3/1UDihoW
	 0haaIsYy1dqa2/uNbuReA4WEbIKSJUekxWb70+W2gE8zsXlrbQXX9zzoKrfBQfs+Xn
	 AhtS0iR5gFi2a/NG5ov/TJGW8Jqkth5BTSjOvDdr8srlm7rb/N3mlos5XxV9Sf5lLX
	 LTajdiF1XC6BWLtjJtFqM4hjql8Y6Q2miG/DHnk/ybv8hIF0IVrw5RJ/A5GY1rJrk0
	 60aIeb92PeZwg==
Message-ID: <73b9f7b5-1c4c-4b03-92a4-8b093a5c9a04@kernel.org>
Date: Thu, 10 Sep 2026 17:15:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] mm/memory_hotplug: drop CONFIG_HAVE_ARCH_PFN_VALID
 handling from pfn_to_online_page()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-12-008fc8d579fe@kernel.org>
 <aqLB0Fe_bCRSph9E@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqLB0Fe_bCRSph9E@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 97F8AA000E
X-Stat-Signature: paw9n9un3x879fam3aq3e8g7j7cmapmy
X-HE-Tag: 1789053319-378053
X-HE-Meta: U2FsdGVkX1+uGds1toBiLsYetY286hs695gZD6AE2oaLcLn+MivmK/xwGd3B1NaC1r9/O9zQbGVkojOnYvN8bDqEEDtirw0hUT9Pg6s77TSIYpnSu2a5bSmGFtf+NDdEIC1YI9peveRYO3feflGZJ7uCfdsiSs/Qb0cE9y7no67SJzfNIaycgVbWs0Twurh9H2iG1KODLyD8a9NJsLICsewEDRDkqSrocFUXwFb1DD/RnUMxKYbADa9T3DtdF/drMUzo+9R6zZ9oUiQfzW6hHuAp0v2CkVWn4uI6lsRNOHVc+d+DeCg/j9JdPc3yQV51i0yszrOLHB8zudZRhZq1g6U5s6pZwYUEcB8dQk0i6ne8zBs/BOAAlCM0C/vXiD/S+OoGVHEUCJXglYZHQvCinrgQB5wDjS7Xm9y2FFRP9/wjfRITyyxipVU5MTnGadNTN6NvSmV1gy1iInydF3X2VYLcSJphw2geWcv9x4TExJVKHz8XU+jO89pgmHh8FY9LFNfVmETIvH0RRr6zAEMRsCDhwgNKh9jd/kwIp1c73vasuoWMBUV8knDz5WZuHL89lAB6pd5lzVLIKl57FHqhc+D0ZWsTD68WF82W96FI10pEYBaw0PuxcVtyzTYwum7TOnah3PMq53bP00gOBzINEXrS0SAZ0sDyVp6/McnEUU1Cy4DRAgb2pISBlczjX9CcXC9M+N3jSsm7mYtWo2kJKucSxsoc7O9Jq+9nOm0OUuEkmfGH2GN/uhh7uATm/rXdh/fo2naA1l8zw1qBXGWiopImn2gYZuiKxGHdzvKhKReSvgsOrQYOHDPhk21VkCUNkP9DnoXF89ousjh6T4ix3E4PrffS134rj4ED3y7wDxSjFIAw77G2PtY8qIcoBMlcXXxQxtnfOsvYOv0/HhjB1qa8ToqNY143hBe54d9vMCRDZnWRjjDdpGLcUOB7DamB0KJWJlCywdW5f/lff99
 znOxr7Q8
 Pa0QUqijo+MvXSpNyRwazmxSvifftFzZojzmWHXbTKjDFLDeA/4+s20maoPqNLJx4qgwm/MbbCKIrhFvgjrT7AeB3TqRceSrdMOuai8ikqbycgWWLRKmbdFN8H9YZ+/GbClcH2b56UAkLIvWOKtIi8chm1ovqbym6uODZ9rRqkmNq8fQltf1jHeObiJwLkM/7uNiHK0Z9lKVqVhSUlMfsZrb2SicFQMIBPCzp/UfN2VdWdjZUXjBoPNXkWbQ68BZVD+pJ5oZfgMMVBKpRibWu45CqT2EToymgLGsiistUqQrd0LhMjFgB9IFnwpkuRLZJISJLoT55pOpfuZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 16:47, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 09, 2026 at 03:33:05PM +0200, David Hildenbrand (Arm) wrote:
>> Drop CONFIG_HAVE_ARCH_PFN_VALID handling, as CONFIG_HAVE_ARCH_PFN_VALID
>> is never used with CONFIG_MEMORY_HOTPLUG, as the latter depends on
>> CONFIG_SPARSEMEM_VMEMMAP. Make sure it stays that way.
> 
> So argument is:
> 
> mm/Makefile:
> 
> memory-hotplug-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
> 
> Is memory_hotplug.c even compiled at all?
> 
> mm/Kconfig:
> 
> menuconfig MEMORY_HOTPLUG
> 	bool "Memory hotplug"
> 	select MEMORY_ISOLATION
> 	depends on SPARSEMEM_VMEMMAP
> 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
> 	depends on 64BIT
> 	select NUMA_KEEP_MEMINFO if NUMA
> 
> $ cd arch
> $ rg HAVE_ARCH_PFN_VALID
> Kconfig
> 1762:config HAVE_ARCH_PFN_VALID
> 
> arm/Kconfig
> 94:	select HAVE_ARCH_PFN_VALID
> 
> arm/mm/init.c
> 121:#ifdef CONFIG_HAVE_ARCH_PFN_VALID
> 
> arm/include/asm/page.h
> 178:#ifdef CONFIG_HAVE_ARCH_PFN_VALID
> 
> m68k/Kconfig.cpu
> 23:	select HAVE_ARCH_PFN_VALID
> 40:	select HAVE_ARCH_PFN_VALID
> 
> arc/Kconfig
> 463:	select HAVE_ARCH_PFN_VALID
> 
> All of arm, m68k and arc are 32-bit arches so by definition MEMORY_HOTPLUG
> can't be selected.
> 
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> So LGTM and:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
>> ---
>>  mm/memory_hotplug.c | 9 ++-------
>>  1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index b428da66d279c..58ce35cb48f57 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -344,6 +344,8 @@ struct page *pfn_to_online_page(unsigned long pfn)
>>  	struct dev_pagemap *pgmap;
>>  	struct mem_section *ms;
>>
>> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID));
> 
> Haha nicest way of removing some later code I've seen. Just make it not compile
> if such a thing happens :)

Better be safe than sorry :)

Thanks!

-- 
Cheers,

David

