Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0289C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61136B04F9; Thu, 13 Aug 2026 09:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C386D6B04FB; Thu, 13 Aug 2026 09:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B786C6B04FC; Thu, 13 Aug 2026 09:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9804C6B04F9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:59:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31A4A16016E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:59:22 +0000 (UTC)
X-FDA: 85096403364.25.20D879E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9279214000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:59:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HlHm0Q8N;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5W7QCmr2rjHR1mmHHdNertquJLOjQ0otV7ASBvPjV2M=;
	b=K8HDtfBt+TWcY0CK8x1ZyFg+MqQo8jdU0rn2oL0xKTCft5oGZBmOAmA3eyVikmr57zWGqb
	7+z7STJ8w8EoK1Fyipip6xZV/yLhYRUK775VgHjfTsypc1oVJgKeDaN3dp9NTmzdBzzsqG
	qXjum5cPQ/oi8MrUoLonXQ5PsYV4p7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786629560;
	b=GXFQGzXjp3Hc64WJnUJHpR40pq0aCQR4vg8+FhHdDnyXs5pi89AG7zkr5DtRhWUIbqKRn/
	JA4FxHGmJ7RCqGHEf59wgOrmcS6o+yrGG+kOBWEoAEY0j43Nvrv5l+QgDe3WwK7vq6rn4P
	2JclPAQGnEsV1xdSREbDkMeTesRlvDs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HlHm0Q8N;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B19DC41786;
	Thu, 13 Aug 2026 13:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAB11F000E9;
	Thu, 13 Aug 2026 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786629559;
	bh=5W7QCmr2rjHR1mmHHdNertquJLOjQ0otV7ASBvPjV2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HlHm0Q8N1sQqbIqpAcHntha66NxayV4XTqDjh1eJyAYnirCYXCcnx17Sp0Ez4EAnD
	 g1RYWvi5EIbk3Wq1kcqLhxuyaCvSc+keIMCsZEYkT0wCvc+ow0Vnc1csHk6OPCkPlG
	 KD+hoYgAi7lG1olYg2qO+6oXk6S1KP63njMZRrmhmyVNhUZHUnYlBbOvGoI4wO/Jtn
	 3qNGE3P4lZUiraa23eyzA67s709Ah3VsNn2gy1oLANdW2Z4kRevvC9OJwhUC+zfDeg
	 gLcxiPyaZRQ8jyN2nyJrXLSpGWgnl5aTR1MadQRM94Y2d/SVSapI79UKIswKCG/sS9
	 nQAlN4K8bvQ1w==
Date: Thu, 13 Aug 2026 14:58:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, nao.horiguchi@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gourry@gourry.net, 
	tony.luck@intel.com, bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH v2] mm/Kconfig: make MEMORY_FAILURE select MIGRATION
Message-ID: <an3NlTPC_TxuPrKu@lucifer>
References: <20260813134916.292733-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813134916.292733-1-xieyuanbin1@huawei.com>
X-Rspam-User: 
X-Stat-Signature: mu16scy3psoiwha3ga8p1jnq49s8eu4j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9279214000A
X-HE-Tag: 1786629560-387662
X-HE-Meta: U2FsdGVkX194aWTBYqXhEO0RynM06qG0pLqR1Et8VuxO/CBnD1g9fkVpt5yeDHDmSk8rVDl3ubG4T9yAfO95b+2H6JwozsV6yDDmrCN0qzy+chSaDfXGPx7R5JqK+8SmMDD33+T1lMptnpiNMDah6m7YO1lU4NA0Bf/zLauzrMBsxsvbJQRaUl0J02rvpTPjx5i3QUlOCZghEiIAZPMQC0gwSVnVxzSLJg4+UJI7zPLfoJmvecsJW9W/6IBLU21xL+qBU5rxG1nsMpEHJB2M28rOExgZXG9MdjtPg4FXZ73WYxr9H3R0Fo9cr7wQgFVD75HoyhoXBcD6yGexca7fS3IUczUIt80C9US+SGKiEOANol1hvXeJ7uazdvtiTMIrPk42tMtpAGi9pV0la170YwZlXutoO3Dd3q4x1NbrkoRz/Oy/ZzGt3DwogY0/dSctepF3/shl682AHgDCsRvVzmEs2J8Y23kxmoRGhpvzgEcDSTtqWJD241xbuXzULxiAZjAWztYZSaKE6PO08ox/GDwYcIaffsToZnKbAX8LSdcbkZHL0EEJGahSWhS3YBRznTp5lPgHJp+9t97kBWkP2wrxdqsPvF39O852nznwHWa2WlNAHdPPj4Dvo2zC5WayqI1C1S4nwaxkJMcG1JJ+uhVoy1D31b+bTMGaVdDjYpoaZXmxt62t7DicIu+GwtssbVtFMc1UQfXgvbEz3pj8GLiZAiov3pR+6w08zUSWU6FSHrAL89njldteyt0NjapHXjFZBj4LdxdvHPIxE8KRs+n1uJ/TIsI1X/Cy1L3IyqHSd0VBcPI5dK2MwmRoMYQWXAp4ErA8mtVy20s8zcTLyHISuPirJe5MLgSoChXz1ygI/Jr0pKR1Pi4Rc8IsQ0m1dx+Sd33d8sa+vd4R2AaPQDZxiIow1zFhbpXcYa/oWrBuBVhPJEyXQy/AeJEjdx0SQFRnHpTe6ylNG9Do4+w
 VQIQ4WJ1
 6ZO+Hq7gAFyjifLpVgYvE7qetc30ji2Ri2/s6+Q+VZaC/mPgK9Y0z/VmQa3QIMC2WW0Rwk5w8gmzRbiF1lrWNTtS441RvG37l3AM6zEPpSYtYWjwhVsM13Iu9Gn6LLTScMIh8YVJpmD6Gc3anTDdG3Roid/99kAJG991ksH5YnS3VAqKj9Pw9KY4cB/XSvbI9U6HevUAgc4Xfh2hsxGNfMgsFuMumVi4JApoWCInLpW50INBV6buE1G0u3XE2wZpHjeDkI1Yi62absQYbk7Dl1NIcpfVdRKaMXYBVf3/aqxV2uB6ufVArKPtMfxuka+ynNKmV9zzYBlmX+teSIs8xwDg9TRawwb+JdVAOgHEf3Nfz1sbIZapC79fkXU/Tr0yiR4dPZj4VZ/FJZIhYA95yq2sTWmXzvsWAeTWsvFtYRyHeg04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 09:49:16PM +0800, Xie Yuanbin wrote:
> For embedded devices, lacking support for NUMA, memory hotplug/hotremove,
> CMA and huge pages is a quite common scenario. In this scenario, the
> demand for contiguous physical memory allocation is very low. To reduce
> the kernel image size, some devices disable the compaction. However,
> their SoCs do support DDR ECC, meaning that memory-failure may be needed.
>
> Migration is very useful for soft_offline_page() in memory-failure, which
> may be triggered by correctable memory errors. Most anonymous and
> file-mapped faulty pages can be migrated to other healthy pages.
>
> Currently, MEMORY_FAILURE does not explicitly select MIGRATION. When
> COMPACTION, MEMORY_HOTREMOVE, NUMA_MIGRATION and CMA are all disabled,
> MEMORY_FAILURE can be enabled, but MIGRATION cannot be selected.
>
> Make MEMORY_FAILURE select MIGRATION to handle this situation.
>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> By the way, as DRAM prices continue to rise, memory-failure becomes
> more important, and we are trying to enable this feature on more devices.
>
> V1->V2: https://lore.kernel.org/20260812091644.224299-1-xieyuanbin1@huawei.com
>         Do not expose the MIGRATION config to users.
>
>  mm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 8a24c130d008..604c58199acb 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -767,6 +767,7 @@ config MEMORY_FAILURE
>  	depends on ARCH_SUPPORTS_MEMORY_FAILURE
>  	bool "Enable recovery from hardware memory errors"
>  	select INTERVAL_TREE
> +	select MIGRATION
>  	help
>  	  Enables code to recover from some memory failures on systems
>  	  with MCA recovery. This allows a system to continue running
> --
> 2.55.0
>

--
Cheers, Lorenzo

