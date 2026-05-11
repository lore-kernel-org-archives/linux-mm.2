Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A6FCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83446B00A2; Mon, 11 May 2026 11:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B456B00E8; Mon, 11 May 2026 11:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70C16B00EB; Mon, 11 May 2026 11:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95F796B00A2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:46:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C59AC0841
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:46:13 +0000 (UTC)
X-FDA: 84755565426.15.A52B2B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 881A44000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:46:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JELj8aOD;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T62AYG/GhA2xJf8r7DizstG05J9q3UAZUmrh0w2Fy8g=;
	b=eWYzMzogtGDcvNw7ylCHZmgO52Q7oCX1x21bSpBx+fo4h0MnjSi4U5qwZDXubIWz/Ry/Sr
	2ixMyI2vXQCzc7bbi1Hq/tn/4giQshpMQAtBaUdAHEc9VuMZMUVxY1O7fbERVWv0cQrjdL
	smxqZOglOZr4F8rXgl8T8Rsd3MET6hg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JELj8aOD;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778514371; a=rsa-sha256;
	cv=none;
	b=adKR+chrAlaLCeheAHjJnbMDXEwICstG/cKs2M4vxUW9VByBu7/ZGMXembaERX4eqFIkU8
	o4VOq+h1gazc/l0VhnmgsekTJ7l+zwn6bG5pGaYpoX8wFApG/AsQp9JIfhMAYX5NgypH0M
	t6Efv2+xC8YnwoYf7BqY+UPmNUXeCsc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA95D60103;
	Mon, 11 May 2026 15:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BF4C2BCB0;
	Mon, 11 May 2026 15:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778514370;
	bh=q74dAch6WvCTTrmanvn0QGUN5w0P2uuTvOSqDfVMl5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JELj8aODuyGTtzXYd8ycVD5vBvKzt3EPIXfY0/rjidrOKBjc5aSUlZ0An2ne2SQPw
	 Z6SlvdQFRR9ACsykOp90aM8eGrO3IEAbw/7ITQo1A6LcqSw4feGqhpcMdiSPh5+rL9
	 aKng0uxk0jymU1lTRB4ApJFRtoAGE/b3UrUylDIJyXczIyuxFFrq+OopMi8+idsGaH
	 A0yfbWRiQHGD2Y3f5za980yqfqd5BVRulkQ+elL/Ej7EmH91hZthshQjW/zCKiT1Tp
	 KfEb2P1yuQfLAb7LDDU2qFIzHD2RTJgFHnphDiC9Mliv50ISV1hxm+0cBR/pHBrlNK
	 /obqFPMLBpm7w==
Message-ID: <5a0ee441-3c0d-43b0-84f3-7e727ae042bd@kernel.org>
Date: Mon, 11 May 2026 17:46:00 +0200
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
X-Stat-Signature: qufouxi5w385zpmz1c96ummp6of3gcsx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 881A44000C
X-Rspam-User: 
X-HE-Tag: 1778514371-968107
X-HE-Meta: U2FsdGVkX18zoNq+Zq4RR8AnaOjXV/kAlHjMTRk3j286rU8Wi7o/MSDPFA0OKOCBU8XwKMgtIHQpMZSkU6lfULZoOU6aVVwmTPdOD6Rs2r0G9iT3T0FqVoAK5aBKx/RMUi0g6NwOcIwl8i1CCu4vh26c5U1LpvyED/qzZU/83xbscdnv4/Gj8C9X6s39SFtiqWEQE+fK9mKULi41LimQaD9deso1fbRtbj64zf4o3zcGxCOx8tXMMrt+yxZ7UDjULX78JxJmwBdN09Y5U1eRTvxJ5cCSCWjO2YgBrkuv0MoXmCa61wzCnm9hnaVT9s64UYzBxZ4uidizLqjBxHI2Fu2vYe+B3FF9TLzTYhrRhvx9sASQY4B5zq239l+8bCxEqX8JJ4ZRoD0pMvvo6YMc5eSWAO73eP3uvar5nMnPzlheekF/F6aqSdJpg95RoFF4EFcFD47ogTEustpVP7t5ycBNmxWfboe4L0b8UDg2JOBsJe9l2aoVjhtwH3sBOi5Fs7iRmuN6fZorUh2BnMgATkyJYjfLnaYrgAHgiwda6fhb82mFa3GF5edgT5C9Sx2uAN4U9R2qM2dY19GbKyGI74WJSppcnIUURiO4OLzY9MDmk86LRRnDx3GdSO/6CKbBSE6UDLHYN0sspzAnJM5ZAScroY8RB/Wb4WLHn9H2Nq1U69rYfQewVDmOxnsexKxMbqoqIwugMLRn0jhkC3XHgWDqVDOXELPatVsQakbvzf0Z20EJmXXISPNBoMeeFZTVVFYmfBNQ7o3iGjswa/yUi1ilMdMmfyQI/sTEUsGBs1Hhfn7ybrOqLITrQvLPb7odpYnWbbo37v6VxEhtoQZUaGMTjb4TZxzEst0YUaTssP75TG8daX+4jIDMAK6iJ0HCIITXXP0uchmmYi038sgvVS9946DohYx8pHPMAWz4O+ehBhttyTieiqv1/Ls0OiYhZi/Ks9wXVhEg2WBuwmX
 gWKizOuh
 cqaPmXegnSbaoFqt2JhQV7mfkBHhDFxtO4+PRPR8OLQVhHUDn7A4ephZBWy4giN8JpVAgah6p5q55VMes7ZtUShZOdzI3c1G7Ve4eLei+2X8aqtq/4rs/7JRNRmf6WBvXO4doqmT0mhM9tALD4wKltJ2fAUVIujo76KNF2dp5vYw8Abr7v4rtyryF+NL/6LeL86SLqNapO2BUjvAuKYwnCasG3OHtWY3Lx0t62lXNthgXbMJznMuNth8tsBPJC65Nm9Bq/HnNgW5n9kwLAvDA4bk4yq5582SA4XVNTy5iuGF8NTwQyRP5hWvX1JLZEEF4IcXWk/IfXxk4VPPTLDD/DNltpx72Ue5du/KQ
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

MAINTAINERS file deserves some love (likely put the new files under the
migration section)

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
> +	}
> +}
> +
> +static int migrate_offload_batch_copy(struct list_head *dst_batch,
> +				      struct list_head *src_batch,
> +				      unsigned int nr_batch)
> +{
> +	int idx, rc;
> +
> +	idx = srcu_read_lock(&migrate_offload_srcu);
> +	rc = static_call(migrate_offload_copy)(dst_batch, src_batch, nr_batch);
> +	srcu_read_unlock(&migrate_offload_srcu, idx);
> +	return rc;
> +}
> +#else
> +static bool migrate_offload_do_batch(int reason)
> +{
> +	return false;
> +}
> +
> +static int migrate_offload_batch_copy(struct list_head *dst_batch,
> +				      struct list_head *src_batch,
> +				      unsigned int nr_batch)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif

Can't all that go to migrate_copy_offload.(hc) Looks like a clean interface form
migrate.c, no?

> +
>  static const struct movable_operations *offline_movable_ops;
>  static const struct movable_operations *zsmalloc_movable_ops;
>  
> @@ -1833,7 +1880,7 @@ static int migrate_pages_batch(struct list_head *from,
>  	struct folio *folio, *folio2, *dst = NULL;
>  	int rc, rc_saved = 0, nr_pages;
>  	unsigned int nr_batch = 0;
> -	bool batch_copied = false;
> +	bool do_batch = false, batch_copied = false;
>  	LIST_HEAD(unmap_batch);
>  	LIST_HEAD(dst_batch);
>  	LIST_HEAD(unmap_single);
> @@ -1843,6 +1890,8 @@ static int migrate_pages_batch(struct list_head *from,
>  	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
>  			!list_empty(from) && !list_is_singular(from));
>  
> +	do_batch = migrate_offload_do_batch(reason);
> +
>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>  		retry = 0;
>  		thp_retry = 0;
> @@ -1984,8 +2033,7 @@ static int migrate_pages_batch(struct list_head *from,
>  				nr_retry_pages += nr_pages;
>  				break;
>  			case 0:
> -				if (static_branch_unlikely(&migrate_offload_enabled) &&
> -				    folio_supports_batch_copy(folio)) {
> +				if (do_batch && folio_supports_batch_copy(folio)) {

I was about to say, the migrate_offload_enabled usage in the previous patch
looks off.

Can you move that to this patch here, and use in the previous patch simply a
default migrate_offload_do_batch() that simply returns "false" ?

>  					list_move_tail(&folio->lru, &unmap_batch);
>  					list_add_tail(&dst->lru, &dst_batch);
>  					nr_batch++;
> @@ -2017,7 +2065,8 @@ static int migrate_pages_batch(struct list_head *from,
>  
>  	/* Batch-copy eligible folios before the move phase */
>  	if (!list_empty(&unmap_batch)) {
> -		rc = folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
> +		rc = migrate_offload_batch_copy(&dst_batch, &unmap_batch,
> +						nr_batch);
>  		batch_copied = (rc == 0);
>  	}
>  
> diff --git a/mm/migrate_copy_offload.c b/mm/migrate_copy_offload.c
-- 
Cheers,

David

