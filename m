Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC93D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598246B0005; Wed,  3 Dec 2025 04:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522526B0023; Wed,  3 Dec 2025 04:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410FD6B008A; Wed,  3 Dec 2025 04:26:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCAB6B0005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:26:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5055BA0E5
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:26:30 +0000 (UTC)
X-FDA: 84177629340.15.6BB59D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0ECCC1C0009
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:26:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eb3S81AB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764753989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Szuozijys6KqkvJ/UUzCoz7jStywwek0qEHV6vGMkk=;
	b=g1WWSybOuAGdMZo5XjsyQblFYzZqNAZ8TpgvMNVVZ32ZrG27RICJUFbKuiqY+8KHbt4L9x
	LAeJja/Qx6Lo/QsyceRyRSZgdrFmV+ngH4AU7af7ovjBs4O6Uqnpyg9obfnlTu+KKxoiGo
	8x+308mq8qAawN4ZzNR9ZReNqUckvG8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764753989; a=rsa-sha256;
	cv=none;
	b=ISDL78SRMJ9jhuJ3i7XYdJSOEhPrIAcjM1/07tLx0rba4mC8nC1D2R70siWICF47YOqayZ
	ysYnauFkqZt/et8vdHiGNpbc5Y6ICg+3drsqbs+WT0BS/1hYS9FcDWGVhXuifJi0/S3McY
	0twYAl4su/7Ti3xR+6tR0ESZfTyBY34=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eb3S81AB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25EF743CB8;
	Wed,  3 Dec 2025 09:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ECDC4CEFB;
	Wed,  3 Dec 2025 09:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764753988;
	bh=XE+UMl9ZJpLLb7Ssie0tS0fINbbRf85YKziq43ZPqIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Eb3S81ABWFi7Ey1sqYmwEvl8GJJze+QGMljZR/U1ykkp3vMRbjs5FA62Rjg7j80BJ
	 P3V/zYn2I17YRTPqhysBE7sf5i0imPIMNbDIVImGcGJN2DoRD2TmbBM/wrdh5X1nvt
	 b4aZqo0Ta2CBqaCaTOzkPDc1v8THYtnVbiD+rsPVz399Ril5/a+gLDTlsDJsrU1qlf
	 EIMEhPA4XE5Mv/Pc3C2cMOonLJCZn+83V7bodGZk4jOVACBB4Z1hEJNReUxL3FZI46
	 WUf9MLQ2iCZI++6dEQhZUlWx6nGuy7I0YbG+BhAsnMla6EBw+ek/6xvlHkZWkt1PgE
	 tRakWkZqyMWvA==
Message-ID: <305328e0-3011-409c-a040-76fc478d541a@kernel.org>
Date: Wed, 3 Dec 2025 10:26:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm, hugetlb: implement movable_gigantic_pages sysctl
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, osalvador@suse.de, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 muchun.song@linux.dev, Mel Gorman <mgorman@suse.de>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 David Rientjes <rientjes@google.com>
References: <20251203063836.187016-1-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251203063836.187016-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0ECCC1C0009
X-Stat-Signature: nijtf44g77jtexsbykakfc6jewc6f7ny
X-Rspam-User: 
X-HE-Tag: 1764753988-648122
X-HE-Meta: U2FsdGVkX194A0GUFgVb1YfkgmqiECRh7fdp1lg3+Q5lWRZwA76ZTouvqkjmkpytHJPkmhK+0BYFhhJvvbHLHrinGcq8BBQ3JwsPR/49s9tZkR4y2T7DEyddFGh1GOD9ViFoQ17kxVqQcFe22vFsmCK9ABOcr8lEW3mY41/v1KwLF8qzxCun1e0MzwLFsjjBXGxJqCFZnpj8mRFPrjbD1mddavzOTmuugDtYwFYVDu9c7nHr+3eljlC+Un3V42WJG72sLZPEiUQ7Jzfl8BDmepR6pB+ZNSkIz0VLj454GEZSDu0JJyM2ciIF11Gcaayo6T0UexQRXxj/OE+YSHkuuLMjuX2k44fa+MyBCodS1ralIHWjt6rEVEfLlP7B9EkHef1/J3t4qKIhh6D/KAnrHvIv29WB+pefzJmHBLJ/hAAhNbCOOwSzZcf12XPXFbl+EirHEzrFtdpU719q3XnUtPBVxb8QBQQeUjSXCGz/Vr3koJ4e6eh5sv/ZahCc+8aHIhEXaXWCFmF0gvwZlGJKFEOINW4iXatcD5hQYzuiFIGNq2YimBxal9lugdso9O/EYfh/EbwPwVzsdo/SyN08/Q6cyxYOjHEGGWKfy5H49Za4+3xzGx4L6XsYRQM36cMEi+TRmht4wQBb4z1rPcXUvfagMco4b9nbgNXpajjy4477hIplIgKOcNmxyi9RvmhTyEDEMRyoC0/WHs8Sf5joPV8x2Xigku5rd7ebFHENpFLGvVc6fE2OZAFdLqeX/a2VWwOMGGua1MXq1SjorNY+rwChx94MHeOT1AY/2sRmuH4/b5IjFO5iej3pUhcCKnMjK7hxhDcECJh9dkldRMQw8mooRuXlIsfzwDDh1kTgYDccstL0CRPw/H6EDbm3MFVsy+IFc90TQNlB3rYuliH8NxUs/IrJ9PQkxMxiSKQbk1vIZeAiLVFvBLhIDS85oDCV4y7NeRCgACFlbb1A9kT
 52gKhIqT
 tIv30cEJmhRWPfntiW+pkUGi3ZA0GofFt8Iq3o0C3YswA2aCPr6Q4hof7gSuGeyW9hmCrARkrw/MCeJc/TvRqVJFnLGHhw7LD3EKoKqHM3XqUDve5Blp3ScBk0dcgeMJaA811yDPSHW/m4vxxo1XBaTQU/QOn7WeLLSY8DWUhKHyuIOOA4a6FeMOImuPnoUx/PP8IgtsOAm4kmsZ8SN1RJh2How/UxsyChBqocki018yyLwfuyZiOIncjIKGSJAxABRN8m39qkLbXuqms6gEAJ9fYK20XfQzWI3J2Ud/F96OMu1yVm7W67WGWzOl+NG7LCDrJLIKT11j6O+CNr/+y1amc0ergz+EW/lFupFe8HaJmqd5FQF+8/W4jcDV1oVKwCzp/ftkwfvHcHPpVvKy+4XHdDO2vjztKZvWwQQrVjuxdTzu/yR3HeF68XJS+XmAxaHZlWIMuvE9yKN4vf42poCOQqyWJUNMs/jCDCQMQ0mCyQXnYSXUTiHzvjgd8zOgmOWiVM7jmFqkWazRles/3gylYI0pGXCj1sTHNRnvSF1YEQ8sOgs+MzEakjVg6FmTLnQJ6xW74hBWLap0UdDnGI7mtsl2ObJI3P0W4L8tySO0/oRYSiqlWCVtTziJJfoxokxYiNhLrHskjLlQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 07:38, Gregory Price wrote:
> This reintroduces a concept removed by:
> commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> 
> This sysctl provides flexibility between ZONE_MOVABLE use cases:
> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable
> 
> When ZONE_MOVABLE is used to make huge page allocation more reliable,
> disallowing gigantic pages memory in this region is pointless.  If
> hotplug is not a requirement, we can loosen the restrictions to allow
> 1GB gigantic pages in ZONE_MOVABLE.
> 
> Since 1GB can be difficult to migrate / has impacts on compaction /
> defragmentation, we don't enable this by default. Notably, 1GB pages
> can only be migrated if another 1GB page is available - so hot-unplug
> will fail if such a page cannot be found.

In light of the other discussion: will it fail or will it simplt retry 
forever, until there is a free 1g page?

> 
> However, since there are scenarios where gigantic pages are migratable,
> we should allow use of these on movable regions.
> 
> Note: Boot-time CMA is not possible for driver-managed hotplug memory,
> as CMA requires the memory to be registered as SystemRAM at boot time.
> Additionally, 1GB huge pages are not supported by THP.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Alexandru Moise <00moses.alexander00@gmail.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
> ---
>   Documentation/admin-guide/mm/memory-hotplug.rst | 14 ++++++++++++--
>   Documentation/admin-guide/sysctl/vm.rst         | 17 +++++++++++++++++
>   include/linux/hugetlb.h                         |  3 ++-
>   mm/hugetlb.c                                    |  1 -
>   mm/hugetlb_sysctl.c                             |  9 +++++++++
>   5 files changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
> index 33c886f3d198..6581558fd0d7 100644
> --- a/Documentation/admin-guide/mm/memory-hotplug.rst
> +++ b/Documentation/admin-guide/mm/memory-hotplug.rst
> @@ -612,8 +612,9 @@ ZONE_MOVABLE, especially when fine-tuning zone ratios:
>     allocations and silently create a zone imbalance, usually triggered by
>     inflation requests from the hypervisor.
>   
> -- Gigantic pages are unmovable, resulting in user space consuming a
> -  lot of unmovable memory.
> +- Gigantic pages are unmovable when an architecture does not support
> +  huge page migration and/or the ``movable_gigantic_pages`` sysctl is false.
> +  See Documentation/admin-guide/sysctl/vm.rst for more info on this sysctl.
>   
>   - Huge pages are unmovable when an architectures does not support huge
>     page migration, resulting in a similar issue as with gigantic pages.
> @@ -672,6 +673,15 @@ block might fail:
>   - Concurrent activity that operates on the same physical memory area, such as
>     allocating gigantic pages, can result in temporary offlining failures.
>   
> +- When an admin sets the ``movable_gigantic_pages`` sysctl to true, gigantic
> +  pages are allowed in ZONE_MOVABLE.  This only allows migratable gigantic
> +  pages to be allocated; however, if there are no eligible destination gigantic
> +  pages at offline, the offlining operation will fail.

Same question here.

Nothing else jumped at me, in general as discussed, as long as it is 
opt-in behavior

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

