Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AA2CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3E36B00A6; Mon, 11 May 2026 11:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95526B00B1; Mon, 11 May 2026 11:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D846A6B00E8; Mon, 11 May 2026 11:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C72F66B00A6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:50:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B2FAA019C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:50:30 +0000 (UTC)
X-FDA: 84755576220.04.EE8521F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8EEE080007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:50:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2eK+wQo;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nryQsjFKxTDW5lgzsrgTveCKynH3v3XDPkbm8PnqisU=;
	b=4lks7LRZGIAKco8kAzZFdVho4U5h+gmWL27Zj13OtbEGFodxmFmMZwbCCvU4mcOK8VWu9o
	o442GNMcRuprWzZ3PTLggRjKvJBj0Ah7oB+0XUa7yetc/q/+h64KuAa1L23dZNqzDMt2LC
	QPJBkSZyEcUZlrTweWGkxB9NUe8qYbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778514628; a=rsa-sha256;
	cv=none;
	b=8fEPY6Za4NM6NHPsXcSpVX6WJM13XuYXhMvxiN2GTZUsmSpf3cjBjwHnm6mCz5vcE90jw6
	oBmplLKzhF5QIt2ilBeqHauIMG+QQose+d4d2O0E31Co0SZk6CseLetpwYD+tkQo27pZnu
	dVCIfef8czlpTLz3tvbMVilMpFvbGjg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2eK+wQo;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 853B2442CC;
	Mon, 11 May 2026 15:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E355C2BCB0;
	Mon, 11 May 2026 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778514627;
	bh=J5/8Yx4PiIF6XARUrwLKk02VhVLQ37/JUaDQnAcKDL4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e2eK+wQoKuU/dStkO+lg6+gtbsaLruL0IGzpDs4HYazxL3WOgrg8jWQDkYzrqWIRj
	 Le5W454VCVDQa3xKJhEB5TAALlzvBVxVh+FCrI7GccrHB9JFd0iA+Y47iaZ35pZCtc
	 yQDKifj7fpN5kve7KYUNMrLsfHY5CAwn4qNSX/OiQWn65N2YN7U0sVhCh3guBz7UkQ
	 gm1wjLuiZhhOu/tjoLb4xsyed0Q4gh8gO7FHChhJC6uN5QC2Z7bjCOEUVIX9MEU9t8
	 Q/GuM9sJ5PRO8qkV/8MxIw4ybiB0+w5pbq4YPsGqtceMZAgmPzx3NuYTX8V02lbjhU
	 yjB2uC5SLTpUA==
Message-ID: <9145ae5b-a33e-4092-8cb5-efa18ae61287@kernel.org>
Date: Mon, 11 May 2026 17:50:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] mm/migrate: add copy offload registration
 infrastructure
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mike Day <michael.day@amd.com>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-12-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428155043.39251-12-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8EEE080007
X-Rspam-User: 
X-Stat-Signature: gicaqp1ngpemxj8qjgbsbrpkp4h9gz77
X-HE-Tag: 1778514628-371153
X-HE-Meta: U2FsdGVkX19ydrAiRRPC/fC4I4+WBu5V/dI9uy+At5BZnrbZJrDXy2CkgAwlrfb2lrKDya0ScdgPpDnSW83Aj+CxpFeP4AWTr2EgOWxGNA3Q/qQgX3v97B2ZrcZpkMHl9IdIQWW1wEsQiif13Zm8jyJUH6whEW6KaMSFV1EKSRIgff+wS4uL0x8bmB/9Bv2I5dfb808Vh/HLHGaXagiJmthMzDTNmTE0887v2VWRk5vRi2xq6mCmjjL3kYNgn+jn3+noYu6PeGshYDtlAstC9cgByeAF2ownuWG2qHGYXSXM6rWG4pFi8WmwKLHc4DhKyyOGtUCNrBvNA+neyzfyfZBW9zpn+IZn9tKY1hAnu0FV6/E0I/xWbSUB1FQWXQnnG0B1xKv6KPO8zEZb0JWTvHbUIvxmXS9thlXGwi1LinHanV2mco12nrZB4BkRS09Vk/IveFFOvmLnciXcgAsfatbEBKmSOAx2m47f+YoaRBuDouCOrLHOIZn8FQ6YRoFkpmUnORe+k860PhpuJi9aYwjJLYxPYM9X+dJ3mpHANU2TVj3n5SnSs3uPRXoK2Fgcc/cN443EcMH1LnP/nymJ012S9H2P8vnzONmX6FZ2woeRA/uOn/ql5GE0bmj8MbdxP/adEZwQicaskDgV519W54CD8UqSk8Q3RCaCLTZRP6dSL3XCIKb53wkoXxAFhl06Y6Ah+7DW6/HVygIbe7USnmGPgjUSrL+jd2CIg5SezW9nvrYs/tDsd5IBV8+mZQ8P0PG2fjBche1z7p9oLAisL01f5PkMNQ97s3KN5daxq0nLaTTEKIXxDgobLO0HzDarfXavIJ2oQi8uqoKhYdrob6n2v3QvBziFV2hO0CkaDBlSiGpM0qxvxZ52gBdDqXCVSlt0KmyFisc0jdogCiVoyOQhGy43MRCOoFt9OCfc/dDK/R/Sncd0ojedHnuHcNqYbD8RCKOX+q2kEJye+UN
 lQZhGy/S
 m8BRTqQEqYatJX8TpF4SlIDHHHWAiGqg1iSDJzA81Ur/u8MKJSejb8AkVExpdbzmFr0xHhMVR5rmJT6TCjoqI/qODIYpZ01zkihEnpi4f29szL/bU5qi1RjQo+6bRXm1KiRkU2onl6fqpTP83ZUGGeMZEo4J4q7reYuEYXP1hrNGObvWHQr78bmzquNDl9DsAXxbJiueUQjQCmU2+KP/Ni1dLdfKjgcvU4eqgjEukWI72UzJHOIzglD4lu6iRub45Ygszeigpt7J4jAWVCyLlcBOqAhkAulyrQn8aye0CBzbUV/gU45PW1CiJmwHk/izP5hFmvffTfl24kEA5kRY4W4FzOdtaKU4z/pGC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 17:50, Shivank Garg wrote:
> Add a registration interface that lets a single offload provider
> (DMA, multi-threaded CPU copy, etc) take over the batch folio copy
> performed by migrate_pages_batch().
> 
> The provider fills in a struct migrator with an offload_copy()
> callback and calls migrate_offload_register(). Registration patches
> the migrate_offload_copy() static_call and flips the
> migrate_offload_enabled static branch. The migrate_offload_unregister()
> reverts both.
> 
> Whether a migration reason is batch-copy eligible is decided by the
> core in migrate_offload_do_batch(). A migrator may decline a particular
> batch (e.g. when nr_batch is too small to amortize setup) by returning
> -EOPNOTSUPP, and the move phase falls back to per-folio CPU copy.
> 
> Only one migrator can be active at a time. A second registration
> returns -EBUSY, and only the active migrator can unregister itself.
> The static_call dispatch is protected by SRCU so that the
> synchronize_srcu() in unregister waits for all in-flight copy before
> the module reference is dropped.
> 
> Co-developed-by: Mike Day <michael.day@amd.com>
> Signed-off-by: Mike Day <michael.day@amd.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  include/linux/migrate_copy_offload.h | 44 +++++++++++++
>  mm/Kconfig                           |  6 ++
>  mm/Makefile                          |  1 +
>  mm/migrate.c                         | 57 +++++++++++++++--
>  mm/migrate_copy_offload.c            | 94 ++++++++++++++++++++++++++++
>  5 files changed, 198 insertions(+), 4 deletions(-)
>  create mode 100644 include/linux/migrate_copy_offload.h
>  create mode 100644 mm/migrate_copy_offload.c
> 
> diff --git a/include/linux/migrate_copy_offload.h b/include/linux/migrate_copy_offload.h
> new file mode 100644
> index 000000000000..d68b10a84743
> --- /dev/null
> +++ b/include/linux/migrate_copy_offload.h
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MIGRATE_COPY_OFFLOAD_H
> +#define _LINUX_MIGRATE_COPY_OFFLOAD_H
> +
> +#include <linux/errno.h>
> +#include <linux/jump_label.h>
> +#include <linux/srcu.h>
> +#include <linux/types.h>
> +
> +struct list_head;
> +struct module;
> +
> +#define MIGRATOR_NAME_LEN 32
> +
> +/**
> + * struct migrator - batch-copy provider for page migration.
> + * @name: name of the provider.
> + * @offload_copy: copy @folio_cnt folios from @src_list to @dst_list.
> + *
> + *	The migrator may inspect @folio_cnt to decide whether the batch
> + * 	is worth offloading, e.g. skip when the batch is too small to
> + * 	amortize setup cost. If returns error, the core falls back to CPU copy.
> + *
> + * @owner: module providing the migrator.
> + */
> +struct migrator {
> +	char name[MIGRATOR_NAME_LEN];
> +	int (*offload_copy)(struct list_head *dst_list,
> +			    struct list_head *src_list,
> +			    unsigned int folio_cnt);
> +	struct module *owner;
> +};
> +
> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
> +extern struct static_key_false migrate_offload_enabled;
> +extern struct srcu_struct migrate_offload_srcu;
> +int migrate_offload_register(struct migrator *m);
> +int migrate_offload_unregister(struct migrator *m);
> +#else
> +static inline int migrate_offload_register(struct migrator *m) { return -EOPNOTSUPP; }
> +static inline int migrate_offload_unregister(struct migrator *m) { return -EOPNOTSUPP; }
> +#endif
> +
> +#endif /* _LINUX_MIGRATE_COPY_OFFLOAD_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e8bf1e9e6ad9..325d79619680 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -647,6 +647,12 @@ config MIGRATION
>  config DEVICE_MIGRATION
>  	def_bool MIGRATION && ZONE_DEVICE
>  
> +# Page-migration batch-copy offload infrastructure.
> +# Selected by migrator drivers (e.g. CONFIG_DCBM_DMA).
> +config MIGRATION_COPY_OFFLOAD
> +	bool
> +	depends on MIGRATION
> +
>  config ARCH_ENABLE_HUGEPAGE_MIGRATION
>  	bool
>  
> diff --git a/mm/Makefile b/mm/Makefile
> index 8ad2ab08244e..db1ac8097089 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -96,6 +96,7 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
>  obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
>  obj-$(CONFIG_MEMTEST)		+= memtest.o
>  obj-$(CONFIG_MIGRATION) += migrate.o
> +obj-$(CONFIG_MIGRATION_COPY_OFFLOAD) += migrate_copy_offload.o
>  obj-$(CONFIG_NUMA) += memory-tiers.o
>  obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 6c2f1cb66f96..9af070f9a1f2 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -44,6 +44,8 @@
>  #include <linux/memory-tiers.h>
>  #include <linux/pagewalk.h>
>  #include <linux/jump_label.h>
> +#include <linux/static_call.h>
> +#include <linux/migrate_copy_offload.h>
>  
>  #include <asm/tlbflush.h>
>  
> @@ -54,6 +56,51 @@
>  
>  DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
>  
> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
> +DEFINE_SRCU(migrate_offload_srcu);
> +DEFINE_STATIC_CALL(migrate_offload_copy, folios_mc_copy);
> +
> +static bool migrate_offload_do_batch(int reason)
> +{
> +	if (!static_branch_unlikely(&migrate_offload_enabled))
> +		return false;
> +
> +	switch (reason) {
> +	case MR_COMPACTION:
> +	case MR_SYSCALL:
> +	case MR_DEMOTION:
> +	case MR_NUMA_MISPLACED:
> +		return true;
> +	default:
> +		return false;


What's the exact reason we don't do this for hotunplug etc? IOW, why do we make
this depend on a reason?


-- 
Cheers,

David

