Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37CC4CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 21:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76318E0003; Mon, 10 Nov 2025 16:19:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27B68E0002; Mon, 10 Nov 2025 16:19:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13BA8E0003; Mon, 10 Nov 2025 16:19:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9178E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:19:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35F31C0299
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:19:52 +0000 (UTC)
X-FDA: 84095964624.28.CF6C60C
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id 94D79C0004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:19:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762809590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJOnojI9lYn8+DlISkdz25ZYwu81gNY92rEk80SzypU=;
	b=4ucQwIrKsk+eQnkwzmOeH83h3dlpoE56o1RXSDAaU+hepoCrFc1v7blvkZ4vCltq4Sr243
	1Sy3J3q5HQZhG2hkOZ8LEPVhDWIhdNgiDTdNshuVsmTqWiw2wTdnXb/aN3OIY0PGdDYXkJ
	/acFaMUIVNKOzlr+q3b7ASWu5vYFKyM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762809590; a=rsa-sha256;
	cv=none;
	b=fsnFTjXHD65oKljgQEVl7ei0oVLbXZFiDwmAFlxUC69iktmALJjf8vlYNXX8H8j2juYB8m
	Z3Unq8fm7So0CufkgmuZVhJ/zq70ZXyJ8zZk3jaluI/smf51prdVEwfi3FXPrvSKXPk3at
	VjdUwPYnflptGJzBLqugHP/3TyAP1UU=
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7CA21402E5;
	Mon, 10 Nov 2025 21:19:48 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id C800540;
	Mon, 10 Nov 2025 21:19:45 +0000 (UTC)
Date: Mon, 10 Nov 2025 16:19:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Zi Yan
 <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: Add tracepoints for debugging
Message-ID: <20251110161954.47d88433@gandalf.local.home>
In-Reply-To: <20251016054619.3174997-1-balbirs@nvidia.com>
References: <20251016054619.3174997-1-balbirs@nvidia.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/3Pr4+3LUHhr0AeUUgO5HhSseUA8EaFaA=
X-HE-Meta: U2FsdGVkX18BsMzElzuLsMD34FPDD4fKo+Kgu8jIiag0c9GLy/cngUyB8adf/SbfOZHT/zm6ibd1t/neLfem/KcgJ8/HRaHXoMg0+172CP/PJy9F0gb3R7EYD9eYAXfkLJDhU4k2pvcAodUUkhznHbEgpOU323yeDdEbU02PXNv3HAZOgCUeL0/lEm+62gCZYF22IrSIDfMm0B6o6w+pNgyFdbL26i1LftrC8SI+Z75XckNoAcSwfeLOvugIWWo0gJOXKhHo8cohOgWpil8PRdxJr72Vntg5FvyzTuknxZDz9on278cpqiatWzMYgtoab4yWztvoKgNFPmTtwWaPI5IXQUjZPgBXdNmpCSAW03CXwascw2q+Y89ZScRGt0j7E0nKYTqUK190NR4qXGRJjCSmXNnshRREErRIJKWd91U31Tiy/3EAWKf3HQfAQKTMhkgZvq8uphZG8W4mlGM8ydGQXl0Opm5U2sS3VYdPs6JVZHNdr6Mgq6gGNRfo1kaVHKoukzqBEEwug5MZPgA9xeRkJTCBfLWXTF18B46vyNKF8sViMrQKdTDg13KnU8LEwoeK8NG2cqynscl9F6f8aoKabPn34PEP+I/EUGCrb3V3nm2rHry0fB7fbFEFF1xv70kfM9lmmi80qa/q7NosKLnXKdqjw4/kkIzumL2XxI8KZJY1GXe84zMoKTcSH8Y5AtqkQA2mvFsCoJ4axmC3Y2NF6CvwrW8r
X-Rspamd-Queue-Id: 94D79C0004
X-Stat-Signature: 4sgiqx7us134mdwj13bd3bxinr17kh4i
X-Rspamd-Server: rspam02
X-HE-Tag-Orig: 1762809585-440114
X-Rspam-User: 
X-HE-Tag: 1762809590-417622
X-HE-Meta: U2FsdGVkX1+XuArkEUCOHwiaBNlRLVzPVLV8VWF3n2aNLEAELj/HEfigNuyIkbee1vniDwW4ngVBMr3hZ1hTo5QLwovoGDcr+IaQb+/uqGew60APA37eFILwOYo/ntdxeCeRWazZcI6572Ey7rlkO7fuXjKVA/q3WulSONSO2kXgjCVMqkwLyOZkGzLeJtjDEMbHDqGgj/by5U23J3xSqdBfU/QDjNpBtmZvewuQ+2KuJkg8+vPxcrALkrB232EoTB8673xGDqc/bOCwm+laED0yzMQK+oTOUp+hStcVSaIFVy0h7uON/ZlkvQsXC5bPr+V5eFIuMo88Ncgi/cinLpBLYbphW0m+b598U6tlP3fcnwfQev/gFP62dCKtcrZLT3/23guY+pZO/93EOwP5XuHDSaVVVRagnOuCZ+bBEoJcn2CNe4Xk2zjIxXPWEMi5UaUqL3H4z6u/zf27+QlbPsFksr/ugvHw5yO+VADUtyY0c/09KF1+cOxYnWdtUhQHCQzs/wBA2dtRNG7mcS0yB4ym48tYbTj1oQwcfNXXGQjNcRRzKmfeVpg1xoCj0UfYb4hNCmfVVzWnaaM6dZ1ggHpERD0G/+PfbkbA+OmKqzy1HGtPFUOSvlbmdRwysNBfBIx9yj6XUZUmTlGGuL0qCiKDQyYMmfcHw8dtqMYRrxK2u39Oc3gOH46KUPzVas3BEKdTPFTPRM9m8L4DMlvxoqixp9RTTWJ0qQgP/8QOLNkYQOMFHyAFKeVcTeLgLqcfzIjhxArp1xesk8NEwc7D20gpbU2vzrG0f2CSfvMOpaY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 16:46:19 +1100
Balbir Singh <balbirs@nvidia.com> wrote:

> Add tracepoints for debugging device migration flow in migrate_device.c.
> This is helpful in debugging how long migration took (time can be
> tracked backwards from migrate_device_finalize to migrate_vma_setup).
> 
> A combination of these events along with existing thp:*, exceptions:*
> and migrate:* is very useful for debugging issues related to
> migration.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
> 
> Sample output from hmm-tests
> 
>        hmm-tests-855   [002]    50.042792: migrate_vma_setup:    start=0x7f2908a00000 end=0x7f2908c00000 nr_pages=512
>        hmm-tests-855   [002]    50.042800: set_migration_pmd:    addr=7f2908a00000, pmd=dfffffffd39ffe00
>        hmm-tests-855   [002]    50.042801: migrate_vma_collect_skip: start=0x7f2908a01000 end=0x7f2908c00000
>        hmm-tests-855   [002]    50.042802: migrate_vma_collect:  start=0x7f2908a00000 end=0x7f2908c00000 npages=512
>        hmm-tests-855   [002]    50.061929: migrate_device_pages: npages=512 migrated=512
>        hmm-tests-855   [002]    50.062345: remove_migration_pmd: addr=7f2908a00000, pmd=efffffe00403fe00
>        hmm-tests-855   [002]    50.062371: migrate_vma_finalize: npages=512

Looks like some of these tracepoints can be combined via classes:

>        hmm-tests-855   [002]    50.042792: migrate_vma_setup:    start=0x7f2908a00000 end=0x7f2908c00000 nr_pages=512
>        hmm-tests-855   [002]    50.042802: migrate_vma_collect:  start=0x7f2908a00000 end=0x7f2908c00000 npages=512

Is there a difference between "nr_pages" and "npages"?

>        hmm-tests-855   [002]    50.042800: set_migration_pmd:    addr=7f2908a00000, pmd=dfffffffd39ffe00
>        hmm-tests-855   [002]    50.062345: remove_migration_pmd: addr=7f2908a00000, pmd=efffffe00403fe00

Each TRACE_EVENT() is equivalent to:

DECLARE_EVENT_CLASS(event, ...)
DEFINE_EVENT(event, event, ...)

Where a class is around 4-5K in size, and the DEFINE_EVENT is between
500 and 1k in size.

By using a single DECLARE_EVENT_CLASS() for multiple events, you can save
several thousands of bytes of memory.

> 
> 
>  include/trace/events/migrate_device.h | 196 ++++++++++++++++++++++++++
>  mm/migrate_device.c                   |  11 ++
>  2 files changed, 207 insertions(+)
>  create mode 100644 include/trace/events/migrate_device.h
> 
> diff --git a/include/trace/events/migrate_device.h b/include/trace/events/migrate_device.h
> new file mode 100644
> index 000000000000..9b2782800ea9
> --- /dev/null
> +++ b/include/trace/events/migrate_device.h
> @@ -0,0 +1,196 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
> + */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM migrate_device
> +
> +#if !defined(_TRACE_MIGRATE_DEVICE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_MIGRATE_DEVICE_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/migrate.h>
> +
> +TRACE_EVENT(migrate_vma_setup,
> +
> +	TP_PROTO(unsigned long start, unsigned long end, unsigned long nr_pages),
> +
> +	TP_ARGS(start, end, nr_pages),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, start)
> +		__field(unsigned long, end)
> +		__field(unsigned long, nr_pages)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->start = start;
> +		__entry->end = end;
> +		__entry->nr_pages = nr_pages;
> +	),
> +
> +	TP_printk("start=0x%lx end=0x%lx nr_pages=%lu",
> +		__entry->start, __entry->end, __entry->nr_pages)
> +);

Make the above into:

DECLAER_EVENT_CLASS(migrate_vma_pages_template,

	TP_PROTO(unsigned long start, unsigned long end, unsigned long nr_pages),

	TP_ARGS(start, end, nr_pages),

	TP_STRUCT__entry(
		__field(unsigned long, start)
		__field(unsigned long, end)
		__field(unsigned long, nr_pages)
	),

	TP_fast_assign(
		__entry->start = start;
		__entry->end = end;
		__entry->nr_pages = nr_pages;
	),

	TP_printk("start=0x%lx end=0x%lx nr_pages=%lu",
		__entry->start, __entry->end, __entry->nr_pages)
);

DEFINE_EVENT(migrate_vma_pages_template, migrate_vma_setup,
	TP_PROTO(unsigned long start, unsigned long end, unsigned long nr_pages),
	TP_ARGS(start, end, nr_pages));

DEFINE_EVENT(migrate_vma_pages_template, migrate_vma_collect,
	TP_PROTO(unsigned long start, unsigned long end, unsigned long nr_pages),
	TP_ARGS(start, end, nr_pages));

DEFINE_EVENT(migrate_vma_pages_template, migrate_vma_collect_hole,
	TP_PROTO(unsigned long start, unsigned long end, unsigned long nr_pages),
	TP_ARGS(start, end, nr_pages));

> +
> +TRACE_EVENT(migrate_vma_collect_skip,
> +
> +	TP_PROTO(unsigned long start, unsigned long end),
> +
> +	TP_ARGS(start, end),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, start)
> +		__field(unsigned long, end)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->start = start;
> +		__entry->end = end;
> +	),
> +
> +	TP_printk("start=0x%lx end=0x%lx", __entry->start, __entry->end)
> +);

> +
> +TRACE_EVENT(migrate_vma_unmap,
> +
> +	TP_PROTO(unsigned long npages, unsigned long cpages),
> +
> +	TP_ARGS(npages, cpages),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, npages)
> +		__field(unsigned long, cpages)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->npages = npages;
> +		__entry->cpages = cpages;
> +	),
> +
> +	TP_printk("npages=%lu cpages=%lu",
> +		__entry->npages, __entry->cpages)
> +);
> +
> +TRACE_EVENT(migrate_device_pages,
> +
> +	TP_PROTO(unsigned long npages, unsigned long migrated),
> +
> +	TP_ARGS(npages, migrated),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, npages)
> +		__field(unsigned long, migrated)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->npages = npages;
> +		__entry->migrated = migrated;
> +	),
> +
> +	TP_printk("npages=%lu migrated=%lu",
> +		__entry->npages, __entry->migrated)
> +);

The above two could be converted to:

DECLARE_EVENT_CLASS(migrate_vma_device_template

	TP_PROTO(unsigned long npages, unsigned long cpage_migrate),

	TP_ARGS(npages, cpage_migrate),

	TP_STRUCT__entry(
		__field(unsigned long, npages)
		__field(unsigned long, cpage_migrated)
	),

	TP_fast_assign(
		__entry->npages = npages;
		__entry->cpage_migrated = cpage_migrate;
	),

	TP_printk("npages=%lu migrated=%lu",
		__entry->npages, __entry->migrated)
);

DEFINE_EVENT(migrate_vma_device_template, migrate_device_pages,
	TP_PROTO(unsigned long npages, unsigned long cpage_migrate),
	TP_ARGS(npages, cpage_migrate));

DEFINE_EVENT_PRINT(migrate_vma_device_template, migrate_vma_unmap
	TP_PROTO(unsigned long npages, unsigned long cpage_migrate),
	TP_ARGS(npages, cpage_migrate),
	TP_printk("npages=%lu cpages=%lu",
		__entry->npages, __entry->cpages));

Where the second one will show a different print format.


> +
> +TRACE_EVENT(migrate_vma_pages,
> +
> +	TP_PROTO(unsigned long npages, unsigned long start, unsigned long end),
> +
> +	TP_ARGS(npages, start, end),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, npages)
> +		__field(unsigned long, start)
> +		__field(unsigned long, end)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->npages = npages;
> +		__entry->start = start;
> +		__entry->end = end;
> +	),
> +
> +	TP_printk("npages=%lu start=0x%lx end=0x%lx",
> +		__entry->npages, __entry->start, __entry->end)

Is there a reason npages is not at the end? Otherwise you can save even more memory with:

DEFINE_EVENT(migrate_vma_pages_template, migrate_vma_pages,
	TP_PROTO(unsigned long start, unsigned long end, unsigned long nr_pages),
	TP_ARGS(start, end, nr_pages));


> +);
> +
> +TRACE_EVENT(migrate_device_finalize,
> +
> +	TP_PROTO(unsigned long npages),
> +
> +	TP_ARGS(npages),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, npages)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->npages = npages;
> +	),
> +
> +	TP_printk("npages=%lu", __entry->npages)
> +);
> +
> +TRACE_EVENT(migrate_vma_finalize,
> +
> +	TP_PROTO(unsigned long npages),
> +
> +	TP_ARGS(npages),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, npages)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->npages = npages;
> +	),
> +
> +	TP_printk("npages=%lu", __entry->npages)
> +);

The above two can be converted to:

DECLARE_EVENT_CLASS(migrate_finalize_template,

	TP_PROTO(unsigned long npages),

	TP_ARGS(npages),

	TP_STRUCT__entry(
		__field(unsigned long, npages)
	),

	TP_fast_assign(
		__entry->npages = npages;
	),

	TP_printk("npages=%lu", __entry->npages)
);

DEFINE_EVENT(migrate_finalize_template, migrate_device_finalize,
	TP_PROTO(unsigned long npages),
	TP_ARGS(npages));

DEFINE_EVENT(migrate_finalize_template, migrate_vma_finalize,
	TP_PROTO(unsigned long npages),
	TP_ARGS(npages));


-- Steve


> +#endif /* _TRACE_MIGRATE_DEVICE_H */
> +
> +#include <trace/define_trace.h>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index fa42d2ebd024..c869b272e85a 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -18,6 +18,9 @@
>  #include <asm/tlbflush.h>
>  #include "internal.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/migrate_device.h>
> +
>  static int migrate_vma_collect_skip(unsigned long start,
>  				    unsigned long end,
>  				    struct mm_walk *walk)
> @@ -25,6 +28,8 @@ static int migrate_vma_collect_skip(unsigned long start,
>  	struct migrate_vma *migrate = walk->private;
>  	unsigned long addr;
>  
> +	trace_migrate_vma_collect_skip(start, end);
> +
>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
>  		migrate->dst[migrate->npages] = 0;
>  		migrate->src[migrate->npages++] = 0;
> @@ -69,6 +74,7 @@ static int migrate_vma_collect_hole(unsigned long start,
>  		migrate->cpages++;
>  	}
>  
> +	trace_migrate_vma_collect_hole(start, end, migrate->npages);
>  	return 0;
>  }
>  
> @@ -517,6 +523,7 @@ static void migrate_vma_collect(struct migrate_vma *migrate)
>  
>  	mmu_notifier_invalidate_range_end(&range);
>  	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
> +	trace_migrate_vma_collect(migrate->start, migrate->end, migrate->npages);
>  }
>  
>  /*
> @@ -748,6 +755,8 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	if (args->fault_page && !PageLocked(args->fault_page))
>  		return -EINVAL;
>  
> +	trace_migrate_vma_setup(args->start, args->end, nr_pages);
> +
>  	memset(args->src, 0, sizeof(*args->src) * nr_pages);
>  	args->cpages = 0;
>  	args->npages = 0;
> @@ -1259,6 +1268,7 @@ EXPORT_SYMBOL(migrate_device_pages);
>  void migrate_vma_pages(struct migrate_vma *migrate)
>  {
>  	__migrate_device_pages(migrate->src, migrate->dst, migrate->npages, migrate);
> +	trace_migrate_device_pages(migrate->npages, migrate->npages);
>  }
>  EXPORT_SYMBOL(migrate_vma_pages);
>  
> @@ -1312,6 +1322,7 @@ static void __migrate_device_finalize(unsigned long *src_pfns,
>  			folio_put(dst);
>  		}
>  	}
> +	trace_migrate_vma_finalize(npages);
>  }
>  
>  /*


