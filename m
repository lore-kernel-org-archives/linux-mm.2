Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0CA3CA0EFF
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 02:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F826B009D; Sun, 24 Aug 2025 22:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776DF6B00A0; Sun, 24 Aug 2025 22:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664FB6B00A1; Sun, 24 Aug 2025 22:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 509236B009D
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 22:06:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBE3B1DC11B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:06:33 +0000 (UTC)
X-FDA: 83813640666.28.4E247F8
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf15.hostedemail.com (Postfix) with ESMTP id 61F16A0006
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:06:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756087592; a=rsa-sha256;
	cv=none;
	b=nOeotSf3sAAOhQ8riJVcB6K2N/oyFdsdKL9CieowNbRk4RPBGF108QALeoKISyQ86l8ASN
	3APkqKhqHRmwrTRcgibXeNpk2I1kP9bPzrxFNQMgP7V4jTpHq6d03SuWO6Vs2OyXxUeRTo
	FFuOP9YLogU9frTOIliiUajZ/MjLuHc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756087592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cekiQ+U7YpLvaxE9qnlQfmVGDPHiDiGhFxFlLAteADw=;
	b=FJwplG0JBl/cwtCrv3nW2Je+1fJcXHjg8AlUUpaYnkRbkUkyy+X2/i2X+JV0T80XTWB8K8
	a0jDNkGrKoDJx7laToM5JPCspXn61L1hevkDPXPoyVJP/NE+rf6KhiMpqofoiMKTNG+3be
	0e5say9kcgtyc+li77VJpR4wNAr+/Ng=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c9DYH5ZvKz2CgGj;
	Mon, 25 Aug 2025 10:01:23 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id A0D08140276;
	Mon, 25 Aug 2025 10:05:48 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 10:05:48 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 10:05:47 +0800
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: fix hwpoisoned large folio
 handling in do_migrate_range
To: David Hildenbrand <david@redhat.com>
CC: Zi Yan <ziy@nvidia.com>, "Pankaj Raghav (Samsung)"
	<kernel@pankajraghav.com>, Matthew Wilcox <willy@infradead.org>, "Luis
 Chamberlain" <mcgrof@kernel.org>, Jinjiang Tu <tujinjiang@huawei.com>, "Oscar
 Salvador" <osalvador@suse.de>, <mhocko@kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, Andrew Morton <akpm@linux-foundation.org>
References: <61325284-d1d6-a973-8aa7-c0f226db95fa@huawei.com>
 <4c5d4fd5-5582-11d8-9fee-24828ac1913d@huawei.com>
 <8c9719f0-c072-40bb-b7f6-6f2cc41a31dc@redhat.com>
 <1D589FE5-3515-4ED5-B12E-D5CE23BA5D13@nvidia.com>
 <e505c25d-c4bf-4d87-8284-6aa0da2fd979@pankajraghav.com>
 <641F5B0B-2B48-46FA-AC58-3A8A4BEB1448@nvidia.com>
 <3702f6b0-27a9-4ca1-adbd-fb1e2985b2d3@redhat.com>
 <ocgxb3ggoaza3irdpea7xhcw3is4vbt24omy2qki36cxkmtecb@jpn7qtco3lvx>
 <345f7ae6-b2d6-44cd-b8b6-2bdd4b33e9d6@redhat.com>
 <CFAECEE9-24CE-42FD-8D55-FCE832D65DD3@nvidia.com>
 <A1B06D4B-5B39-47C3-94E9-93FE3F0A758D@nvidia.com>
 <c0f5492c-f9fe-48c8-98bc-d8cc8e7e00b3@redhat.com>
 <E0D87F2B-20AD-4AE4-943E-C126395C3CE5@nvidia.com>
 <66bc7274-ec2a-423a-8094-b8d4cc9438fe@redhat.com>
 <20250719192300.9e32c35ddc49f11c7954306b@linux-foundation.org>
 <a65acb01-282b-4b6e-979e-e3bc2fcd9b15@redhat.com>
 <20250820220212.bac0423a778d3b04b05d8bec@linux-foundation.org>
 <3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <e70238b5-0590-c7cb-7979-3ba62e38ef00@huawei.com>
Date: Mon, 25 Aug 2025 10:05:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 61F16A0006
X-Stat-Signature: ph9ydua66mebfsrantghtmbghfqoomc5
X-HE-Tag: 1756087591-872190
X-HE-Meta: U2FsdGVkX188IQJcEJd7iQdP/DKLx9pGd1TSdZrgcpFEVD24cMhbU6PhilZDpj562NbBdqjJH+HkOv9julVCBzxyGOw+0+++FLepGHhosom1/qxr8NVpZIXtxUPa2pjsS592n8jJgfcZsPtQCz53Z+p8mxIDTa1LgBnCQ+SvqFGdJdY0xKZ6YQ/2mE8qN9hZYiDRbgVlR1JwEXmwz0IwshFuf9a+s8Q7yZMIaUcQuz7g9UJ97dQ8EeWVKB8dKDh2wuMB0ATIcLe19NozV6lG72OceHyiwiS8Z+ikFxS6vOzPRCKqp44LOJIcDA14nuevgWByT5VSPrt00uWV2+d9+XlUejLifB7+mSPjPTlW4JJePvsRMGDfNtX78CI27m7+vUze6NNv6RcIcidOxW+USGU30dA+18VXV4HT2i/gbgZQeywB11wbt6kvbOFMvg91aiO5/nOAPBhlCX+iAuMQdbNOrpRzQUYK9O1b9l3PkNnIlFZXupy5ekSRuJmsK6Zr/DUSGZ/rSKKfPwyyrJS+NI2sO9wtiKB8tSjvBvCC71hEMJlTQ31JOAuo64+QHwF4s34XwsxArvT6H5gNBzvWQIscI6WfBy+qky32pPgLmGrI71+w4y+rLd0UiWktWYMQ7EnfmwTtQBl5kXGlF0IBkDjzrG/Vyui/ogy3bYdntfzmsyEaevzpS0KyIdjW3BzFKNw8RsHXv1RQNw5sdfhJTZh//bkuixCZ04WPgVFxH+RYGGtUto5VcUjPxiJ+7S0Pjig6qJwaKLXmAEBNW4zLYV8Kb1PwRM4kZVEUFHYWSZw4z/w9fHnTkO3z2MnEy8eb329NZ0Mu4OE7N68g3oAGHErLQJwpS89WMvFuQ65xRgZfDnv+hA2X+ChcKzUitElk4VRwc2iWistCjDU/P184nwymuKT83bdPhfGhl0VTE23kqCzIji5CaTdQE0wfenWxueIk01woaB+++s96wdj
 HbiGuXTa
 KhKuqXdTDDD8go8EOumM4PYIU75LYacTbz4gf0DOwVQVUEewzEbIPelgT1KpX5Bz4Mt5mkzaozgbbX11Jpzdvwsax/3o0WoOI9qUa6nj227EPXh8bZd/EMbdq1kADItuTY+6kdypUeY7NYQ57uyG/mbDLkVOO+8wnHs4Si1Bia7J1SyBP5wX/Uy4u7LZ6SUs5wE0YLsmFeH/FptJIOtPCKNzyJtVJJi2o1oOzLCVYdjoIjyAqubWTl6f5coXtGLZmiAQyFSC8fsqY/t3+v+l0xxX5gd6una4kBcwZ4ncOmKS/VQY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/22 6:07, David Hildenbrand wrote:
> On 21.08.25 07:02, Andrew Morton wrote:
>> On Tue, 22 Jul 2025 17:30:06 +0200 David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 20.07.25 04:23, Andrew Morton wrote:
>>>>
>>>> I continue to retain the original patch in mm-hotfixes as part of
>>>> akpm's lame bug-tracking system.  3 weeks in -next.
>>>>
>>>> And I just added a cc:stable to it because December 2018.
>>>>
>>>> I don't expect many real-world users will be putting fake delays in
>>>> memory_failure(), but it's there.
>>>>
>>>> So what do we do here?  Add a TODO, merge it under the
>>>> better-than-it-was-before theory and move on?
>>>
>>> I would feel better if we could just not fail memory offlining. Memory
>>> offlining is documented to loop forever if something bad happens, and
>>> user space can cancel it.
>>>
>>
>> Pathetic monthly prod to keep this on people's radar.
>>
> 
> Let's do something minimal for now:
> 
> From 403b2a375a10c17fd6e2aeffbe0fdaf623faa621 Mon Sep 17 00:00:00 2001
> From: Jinjiang Tu <tujinjiang@huawei.com>
> Date: Fri, 27 Jun 2025 20:57:47 +0800
> Subject: [PATCH] mm/memory_hotplug: fix hwpoisoned large folio handling in
>  do_migrate_range
> 
> In do_migrate_range(), the hwpoisoned folio may be large folio, which
> can't be handled by unmap_poisoned_folio().
> 
> I can reproduce this issue in qemu after adding delay in memory_failure()
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> RIP: 0010:try_to_unmap_one+0x16a/0xfc0
>  <TASK>
>  rmap_walk_anon+0xda/0x1f0
>  try_to_unmap+0x78/0x80
>  ? __pfx_try_to_unmap_one+0x10/0x10
>  ? __pfx_folio_not_mapped+0x10/0x10
>  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
>  unmap_poisoned_folio+0x60/0x140
>  do_migrate_range+0x4d1/0x600
>  ? slab_memory_callback+0x6a/0x190
>  ? notifier_call_chain+0x56/0xb0
>  offline_pages+0x3e6/0x460
>  memory_subsys_offline+0x130/0x1f0
>  device_offline+0xba/0x110
>  acpi_bus_offline+0xb7/0x130
>  acpi_scan_hot_remove+0x77/0x290
>  acpi_device_hotplug+0x1e0/0x240
>  acpi_hotplug_work_fn+0x1a/0x30
>  process_one_work+0x186/0x340
> 
> Besides, do_migrate_range() may be called between memory_failure set
> hwpoison flag and isolate the folio from lru, so remove WARN_ON(). In other
> places, unmap_poisoned_folio() is called when the folio is isolated, obey
> it in do_migrate_range() too.
> 
> Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> [ David: don't abort offlining, fixed typo, added comment ]
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/memory_hotplug.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 1f15af712bc34..74318c7877156 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1815,8 +1815,14 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
>              pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
>  
>          if (folio_contain_hwpoisoned_page(folio)) {
> -            if (WARN_ON(folio_test_lru(folio)))
> -                folio_isolate_lru(folio);
> +            /*
> +             * unmap_poisoned_folio() cannot handle large folios
> +             * in all cases yet.
> +             */
> +            if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> +                goto put_folio;
> +            if (folio_test_lru(folio) && !folio_isolate_lru(folio))
> +                goto put_folio;
>              if (folio_mapped(folio)) {
>                  folio_lock(folio);
>                  unmap_poisoned_folio(folio, pfn, false);

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Thanks.
.

